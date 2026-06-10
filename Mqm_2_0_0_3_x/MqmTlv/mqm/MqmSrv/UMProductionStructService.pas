unit UMProductionStructService;

interface

uses

  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, UMProdMemory,
  Menus, Db, StdCtrls,  SysUtils, StrUtils, DMsrvPc;

  procedure CheckTableColumns(ArcQry : TMqmQuery; var m_Exist_INITIALPLANSCHEDDATETIME, m_Exist_FINALPLANSCHEDDATETIME,
                            m_Exist_INITIALPLANNEDSCHEDULEDDATE, m_Exist_FINALPLANNEDSCHEDULEDDATE, m_Exist_MQMSPLITREFERENCE : boolean);
  function  getForcedGroupNo(curr_Production_Order_Grp_No_list: TList; productionOrderCode, GrpStep: String): integer;
  procedure fill_Production_Order_Grp_No_list(Production_Order_Grp_No_list : TList);
  procedure DeleteOldProduction_Order_Grp(Production_Order_Grp_No_list: TList);
  function  DownloadCompanyHandling(srvQry : TMqmQuery; HostQry: TMqmQuery): boolean;
  function  GetCompanyLevelHandlingByEntityName(EntitySearchPrm : string; var CompanyInUsed : string) : boolean;
  function  PrepareHandledAttributeWorkCenter(ArcQry : TMqmQuery) : string;
  function  LoadIntoWORKCENTERANDOPERATTRIBUTES(OperAttributesList : TList; HostQry : TMqmQuery; HandledWorkCenterAttribute : string): boolean;

  function  FindWORKCENTERANDOPERATTRIBUTES(WORKCENTERCODE, OPERATIONCODE : string; OperAttributesList : TList) : TList;
  procedure Fill_MATERIAL_DETAIL_SCHEDULE(HostQry: TMqmQuery; LocalQry: TMqmQuery; HandledProductionDemandMqinSql : string; var WarpItemHandledStrList : TstringList; var WarpItemHandledStr : string; read_Material_Schedule_list : TList; read_Material_Schedule_list_Link : TList; articleTypeList : Tlist; logicalWarehouseList : TList; HandledWorkCenterSql : string; handledWorkCentersList : TList);
  procedure fillRoutingStepTimeTypeToList(HostQry: TMqmQuery; routingStepTimeTypeList: TList);
  procedure Fill_PRODUCT_FULLITEMKEYDECODER_TOOL(ArcQry : TMqmQuery; HostQry: TMqmQuery; WarpItemHandledStr : string; var ColumnNamesSql : string; List_Items : TList; HandledProductionDemandMqinSql : string);
  function  FindProductItem(FIKd : string; List_Items : TList ) : pointer;
  procedure Fill_Generic(ArcQry : TMqmQuery; HostQry: TMqmQuery; List_Generic, List_TNA : TList; HandledProductionDemandMqinSql, TNA_code_list1, TNA_code_list2 : string);
  procedure LoadProjectNumbers(ArcQry : TMqmQuery; ProjectNumberList : TList);
  function  GetNumberByProject(ProjectNumberList : TList; Project : string) : string;
  function  LoadIntoStockDetails(logicalWarehouseList : TList; itemTypesList : TList; ProjectNumberList : TList; List_Items : TList): boolean;
  function  SortProductionReservation(Item1, Item2: Pointer) : integer;
  function  FindCodeInproductionReservationList(Code : string; productionReservationList : TList ) : Integer;
  function  GetPropBuildFromOtherPropsList(PropBuildFromOtherPropsList : TList) : boolean;
  function  BuildAvailabilityStruct(balanceHandledItemTypeCodes : string; STOCKTYPECODES : string; NETGROUP_IS_LOT_Handaled : boolean) : string;
  procedure UpdatePropertyLinkerToServingGroup(propertyList, read_prop_prod_list, read_prod_reqhdr_list : TList; ServingCode : string);
  procedure UpdatePropertyLinker_CurveFamily_IdCode_BuildFromProp(propertyList, read_prop_prod_list, read_prod_reqhdr_list : TList);
  function  CheckColumnExistsInTable(ArcQry : TMqmQuery; TABLE_NAME : string; ColumnToCheck : string) : boolean;
  procedure Find_prod_req_OR_AddToList_FamilyMerge(Tmp_read_prod_req_list : TList; MQMPR : PTMQMPR);
  procedure Find_prod_reqHdr_OR_AddToList_FamilyMerge(Tmp_read_prod_reqHdr_list : TList; MQMPH : PTMQMPH);
  procedure Find_prod_Step_OR_AddToList_FamilyMerge(Tmp_read_prod_step_list : TList; MQMPD : PTMQMPD);
  procedure Find_prod_Prop_OR_AddToList_FamilyMerge(Tmp_read_prod_prop_list : TList; MQMPP : PTMQMPP);
  procedure Find_prod_Step_Time_OR_AddToList_FamilyMerge(Tmp_prod_step_time_list : TList; MQMST : PTMQMST);
  procedure Find_Material_OR_AddToList_FamilyMerge(Tmp_Material_list : TList; MQMMT : PTMQMMT);
  procedure Find_prod_info_OR_AddToList_FamilyMerge(Tmp_read_prod_info_list : TList; MQMPI : PTMQMPI);
  procedure Find_STEP_BATCH_SIZE_FamilyMerge(Tmp_read_Step_Batch_size_list : TList; MQMSB : PTMQMSB);
  procedure Find_PRODUCED_ARTICLE_FamilyMerge(read_produced_article_list : TList; MQMPA : PTMQMPA);
  procedure Find_REQCONN_list_FamilyMerge(Tmp_PROD_REQCONN_list : TList; MQMIC : PTMQMIC);
  procedure Find_EXT_CONNECTION_list_FamilyMerge(Tmp_EXT_CONNECTION_list : TList; MQMEC : PTMQMEC);

  function Sort_Concatinated(Item1, Item2: Pointer) : integer;
  function Sort_WORKCENTER(Item1, Item2: Pointer) : integer;
  function Sort_PPROCESSES(Item1, Item2: Pointer) : integer;
  function Sort_UserGenericGroupType(Item1, Item2: Pointer) : integer;
  function Sort_ColorType(Item1, Item2: Pointer) : integer;

  function Sort_PropListByCode(Item1, Item2: Pointer) : integer;
  function Sort_propRtvValueListByItemType(Item1, Item2: Pointer) : integer;
  function Sort_ALT_WAREHOUSE_WKC(Item1, Item2: Pointer) : integer;

  function Sort_PRODUCTS(Item1, Item2: Pointer) : integer;
  function Sort_PRODUCTIONDEMANDTEMPLATES(Item1, Item2: Pointer) : integer;
  function Sort_OPERATIONS(Item1, Item2: Pointer) : integer;
  function Sort_LOGICALWAREHOUSES(Item1, Item2: Pointer) : integer;

  function Sort_ITEMTYPETEMPLATES(Item1, Item2: Pointer) : integer;
  function Sort_PPRODUCTIONDEMANDCOUNTERS(Item1, Item2: Pointer) : integer;
  function Sort_SALESORDERS(Item1, Item2: Pointer) : integer;

  function Sort_ARTICLE_TYPES(Item1, Item2: Pointer) : integer;
  function Sort_PRODUCTIONPROGRESSTEMPLATES(Item1, Item2: Pointer) : integer;
  function Sort_List_TNA_By_ABSUNIQUEID(Item1, Item2: Pointer) : integer;

implementation

uses
  UMGlobal, UOpThread, UMProductionStruct, UMSrvConfig, UMTblDesc, UMsrvLoad, UMCommon, FMDownloadInfoMsg, UMProdSortList, gnugettext;

type
  TABSCOMPANYHANDLING = Record
    ENTITYNAME : String;
    COMPANYLEVELHANDLING: String;
  end;
  PABSCOMPANYHANDLING = ^TABSCOMPANYHANDLING;

var
  M_ABSCOMPANYHANDLING : TList;
  minProductionOrderGroupNo: integer;

//------------------------------------------------------------------------------------------------//

procedure InsertproductionOrderCodeGrpStep(productionOrderCode : string; GrpStep : Integer; FORCED_GROUP_NUM : integer);
var
  qryInseret : TMqmQuery;
  srvSqlInsertStr : string;
  TestList : TStringList;
  TableName : string;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
     TableName := 'PRODUCTION_ORDER_GRP'
  else
     TableName := 'SCDA_PRODUCTION_ORDER_GRP';

  qryInseret := ThreadCreateQueryArc;
  srvSqlInsertStr := 'insert into  ' + TableName +
                   ' (PG_IDENTIFIER, PG_PRODUCTION_ORDER, PG_GROUP_STEP_NUM, PG_FORCED_GROUP_NUM )' +
                     ' values ( ' + IniAppGlobals.Identifier + ',' +  QuotedStr(productionOrderCode) + ',' + IntToStr(GrpStep) + ',' + IntToStr(FORCED_GROUP_NUM) + ')';
  qryInseret.sql.Text := srvSqlInsertStr;
//  try
  qryInseret.ExecSQL;
 { except;
    TestList := TStringList.Create;
    TestList.Add(srvSqlInsertStr);
    TestList.SaveToFile('c:\GroupError.txt');
    raise;
  end;     }
  qryInseret.Connection.Commit;
  qryInseret.free;
end;

//------------------------------------------------------------------------------------------------//

procedure CheckTableColumns(ArcQry : TMqmQuery; var m_Exist_INITIALPLANSCHEDDATETIME, m_Exist_FINALPLANSCHEDDATETIME,
                            m_Exist_INITIALPLANNEDSCHEDULEDDATE, m_Exist_FINALPLANNEDSCHEDULEDDATE, m_Exist_MQMSPLITREFERENCE : boolean);
var
  DndArchiveArcName : TDndArchiveName;
  TableName : string;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  TableName := 'NOW_TABLES_COLUMNS';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'NOW_TABLES_COLUMNS';

  with ArcQry do
  begin
    SQL.Clear;
    SQL.Add(' Select COLUMN_NAME from ' + TableName + ' WHERE COLUMN_NAME = ' + QuotedStr('INITIALPLANSCHEDDATETIME'));
    SQL.Add(' AND TABLE_NAME = ' + QuotedStr('PRODUCTIONDEMANDSTEP'));
    open;
    if not ArcQry.EOF then
      m_Exist_INITIALPLANSCHEDDATETIME := true;
    SQL.Clear;
    SQL.Add(' Select COLUMN_NAME from ' + TableName + ' WHERE COLUMN_NAME = ' + QuotedStr('FINALPLANSCHEDDATETIME'));
    SQL.Add(' AND TABLE_NAME = ' + QuotedStr('PRODUCTIONDEMANDSTEP'));
    open;
    if not ArcQry.EOF then
      m_Exist_FINALPLANSCHEDDATETIME := true;

    SQL.Clear;
    SQL.Add(' Select COLUMN_NAME from ' + TableName + ' WHERE COLUMN_NAME = ' + QuotedStr('INITIALPLANNEDSCHEDULEDDATE'));
    SQL.Add(' AND TABLE_NAME = ' + QuotedStr('PRODUCTIONDEMAND'));
    open;
    if not ArcQry.EOF then
      m_Exist_INITIALPLANNEDSCHEDULEDDATE := true;
    SQL.Clear;
    SQL.Add(' Select COLUMN_NAME from ' + TableName + ' WHERE COLUMN_NAME = ' + QuotedStr('FINALPLANNEDSCHEDULEDDATE'));
    SQL.Add(' AND TABLE_NAME = ' + QuotedStr('PRODUCTIONDEMAND'));
    open;
    if not ArcQry.EOF then
      m_Exist_FINALPLANNEDSCHEDULEDDATE := true;
    SQL.Clear;
    SQL.Add(' Select COLUMN_NAME from ' + TableName + ' WHERE COLUMN_NAME = ' + QuotedStr('MQMSPLITREFERENCE'));
    SQL.Add(' AND TABLE_NAME = ' + QuotedStr('PRODUCTIONDEMAND'));
    open;
    if not ArcQry.EOF then
      m_Exist_MQMSPLITREFERENCE := true;
    Close;
  end;
end;

//------------------------------------------------------------------------------------------------//

function getForcedGroupNo(curr_Production_Order_Grp_No_list: TList;
                          productionOrderCode, GrpStep : String): integer;
var
  NEW_PRODUCTION_ORDER_GRP_NO: PPRODUCTION_ORDER_GRP_NOS;
  index: integer;
begin
  index := searchInListLinear(curr_Production_Order_Grp_No_list, 6, productionOrderCode + GrpStep);
  if index = -1 then
  begin
    minProductionOrderGroupNo := minProductionOrderGroupNo - 1;

    New(NEW_PRODUCTION_ORDER_GRP_NO);
    NEW_PRODUCTION_ORDER_GRP_NO.productionOrderCodeGrpStep := productionOrderCode + GrpStep;
    NEW_PRODUCTION_ORDER_GRP_NO.productionOrderCode := productionOrderCode;
    NEW_PRODUCTION_ORDER_GRP_NO.GroupStep := StrToInt(GrpStep);
    NEW_PRODUCTION_ORDER_GRP_NO.groupNo := minProductionOrderGroupNo;
    NEW_PRODUCTION_ORDER_GRP_NO.ToBedelete := false;

    curr_Production_Order_Grp_No_list.Add(NEW_PRODUCTION_ORDER_GRP_NO);
    result := minProductionOrderGroupNo;
    InsertproductionOrderCodeGrpStep(productionOrderCode, StrToInt(GrpStep) , minProductionOrderGroupNo);

  end
  else
  begin
    PPRODUCTION_ORDER_GRP_NOS(curr_Production_Order_Grp_No_list.Items[index]).ToBedelete := false;
    result := PPRODUCTION_ORDER_GRP_NOS(curr_Production_Order_Grp_No_list.Items[index]).groupNo;
  end;

end;

//------------------------------------------------------------------------------------------------//

procedure fill_Production_Order_Grp_No_list(Production_Order_Grp_No_list : TList);
var
  srvSqlStr : string;
  SrvQry : TMqmQuery;
  index : Integer;
  NEW_PRODUCTION_ORDER_GRP_NO: PPRODUCTION_ORDER_GRP_NOS;
  TableName : string;
  DndArchiveArcName : TDndArchiveName;

  PG_PRODUCTION_ORDER_FIELD, PG_GROUP_STEP_NUM_FIELD, PG_FORCED_GROUP_NUM_FIELD  : TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'PRODUCTION_ORDER_GRP';
  if DndArchiveArcName <> TD_Interbase then
    TableName := 'SCDA_PRODUCTION_ORDER_GRP';

  srvSqlStr := 'SELECT * FROM ' + TableName + WHERE_IDF_Condition('PG_IDENTIFIER') + 'ORDER BY pg_forced_group_num DESC';

  srvQry := ThreadCreateQueryArc;

  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := True;

  PG_PRODUCTION_ORDER_FIELD := srvQry.FieldByName('PG_PRODUCTION_ORDER');
  PG_GROUP_STEP_NUM_FIELD   := srvQry.FieldByName('PG_GROUP_STEP_NUM');
  PG_FORCED_GROUP_NUM_FIELD := srvQry.FieldByName('PG_FORCED_GROUP_NUM');

  while ( not srvQry.Eof ) do
  begin

    index := searchInListLinear(Production_Order_Grp_No_list, 6
    , trim(PG_PRODUCTION_ORDER_FIELD.AsString) +
             PG_GROUP_STEP_NUM_FIELD.AsString);

    if index = -1 then
    begin
      New(NEW_PRODUCTION_ORDER_GRP_NO);
      NEW_PRODUCTION_ORDER_GRP_NO.productionOrderCode := trim(PG_PRODUCTION_ORDER_FIELD.AsString);
      NEW_PRODUCTION_ORDER_GRP_NO.GroupStep           := PG_GROUP_STEP_NUM_FIELD.AsInteger;
      NEW_PRODUCTION_ORDER_GRP_NO.productionOrderCodeGrpStep := Trim(PG_PRODUCTION_ORDER_FIELD.AsString) + PG_GROUP_STEP_NUM_FIELD.AsString;
      NEW_PRODUCTION_ORDER_GRP_NO.groupNo := PG_FORCED_GROUP_NUM_FIELD.AsInteger;
      NEW_PRODUCTION_ORDER_GRP_NO.ToBedelete := true;

      if minProductionOrderGroupNo > NEW_PRODUCTION_ORDER_GRP_NO.groupNo then
        minProductionOrderGroupNo := NEW_PRODUCTION_ORDER_GRP_NO.groupNo;

      Production_Order_Grp_No_list.Add(NEW_PRODUCTION_ORDER_GRP_NO);
    end;
    srvQry.Next;
  end;
  srvQry.free;
end;

//------------------------------------------------------------------------------------------------//

procedure DeleteOldProduction_Order_Grp(Production_Order_Grp_No_list: TList);
var
  I : Integer;
  srvSqlStr : string;
  SrvQry : TMqmQuery;
  TableName : string;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    TableName := 'PRODUCTION_ORDER_GRP'
  else
    TableName := 'SCDA_PRODUCTION_ORDER_GRP';

  srvQry := ThreadCreateQueryArc;
  srvSqlStr := 'delete FROM ' + TableName;
  for I := 0 to Production_Order_Grp_No_list.Count - 1 do
  begin
    if not PPRODUCTION_ORDER_GRP_NOS(Production_Order_Grp_No_list[I]).ToBedelete then continue;
    srvQry.SQL.text := srvSqlStr + ' where PG_PRODUCTION_ORDER = ' + QuotedStr(PPRODUCTION_ORDER_GRP_NOS(Production_Order_Grp_No_list[I]).productionOrderCode) +
                                   ' and PG_GROUP_STEP_NUM = ' + IntToStr(PPRODUCTION_ORDER_GRP_NOS(Production_Order_Grp_No_list[I]).GroupStep) +
                                     AND_IDF_Condition('PG_IDENTIFIER');
    srvQry.ExecSQL;
  end;
  srvQry.Connection.Commit;
  srvQry.free;
end;

//------------------------------------------------------------------------------------------------//

function GetCompanyLevelHandlingByEntityName(EntitySearchPrm : string; var CompanyInUsed : string) : boolean;
var
  I : Integer;
  ReqPABSCOMPANYHANDLING : PABSCOMPANYHANDLING;
  LevelHandling, Str, EntitySearch : string;
  LengthOrig, LengthFound : integer;
begin
  Result := false;
  EntitySearch := '.' + EntitySearchPrm;
  LengthOrig := Length(EntitySearch);

  for I := 0 to M_ABSCOMPANYHANDLING.Count - 1 do
  begin
    ReqPABSCOMPANYHANDLING := PABSCOMPANYHANDLING(M_ABSCOMPANYHANDLING[I]);
    LengthFound := Length(ReqPABSCOMPANYHANDLING.ENTITYNAME);
    Str := Trim(copy(ReqPABSCOMPANYHANDLING.ENTITYNAME, (LengthFound - LengthOrig + 1), LengthFound));
  //  if AnsiContainsStr(ReqPABSCOMPANYHANDLING.ENTITYNAME, '.' + EntitySearch) then
    if AnsiContainsStr(Str, EntitySearch) then
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

//------------------------------------------------------------------------------------------------//

procedure CleanCompanyLevelHandlingByEntity;
var
  I : Integer;
begin
  if assigned(M_ABSCOMPANYHANDLING) then
  begin
    for I := 0 to M_ABSCOMPANYHANDLING.Count - 1 do
      dispose(PABSCOMPANYHANDLING(M_ABSCOMPANYHANDLING[I]));
    M_ABSCOMPANYHANDLING.Clear;
  end;
end;

//----------------------------------------------------------------------------//

function DownloadCompanyHandling(srvQry : TMqmQuery; HostQry: TMqmQuery): boolean;
var

  hostSqlStr : string;
  ReqPABSCOMPANYHANDLING : PABSCOMPANYHANDLING;
begin
  Result := true;
  CleanCompanyLevelHandlingByEntity;

  UpdateOperation(_('Downloading data for ABSCOMPANYHANDLING'));
  hostSqlStr := 'SELECT * FROM ABSCOMPANYHANDLING';

  HostQry.SQL.Text := hostSqlStr;
  hostQry.Active:=true;
  var fldCH_EntityName      := HostQry.FieldByName('ENTITYNAME');
  var fldCH_CompanyLvlHndlg := HostQry.FieldByName('COMPANYLEVELHANDLING');

  while ( not hostQry.Eof) do
  begin
    new(ReqPABSCOMPANYHANDLING);
    ReqPABSCOMPANYHANDLING.ENTITYNAME := UpperCase(Trim(fldCH_EntityName.AsString));
    ReqPABSCOMPANYHANDLING.COMPANYLEVELHANDLING := Trim(fldCH_CompanyLvlHndlg.AsString);
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

function SortItems(Item1, Item2: Pointer) : integer;
var
  ItemMqm1 : PTITEMS;
  ItemMqm2 : PTITEMS;
begin
  ItemMqm1 := PTITEMS(Item1);
  ItemMqm2 := PTITEMS(Item2);
  if ItemMqm1.ABSUNIQUEIDINT < ItemMqm2.ABSUNIQUEIDINT then
    Result := -1
  else if ItemMqm1.ABSUNIQUEIDINT > ItemMqm2.ABSUNIQUEIDINT then
    Result := 1
  else
    Result := 0;
end;

//----------------------------------------------------------------------------//

function SortGeneric(Item1, Item2: Pointer) : integer;
var
  Left : PRGeneric;
  Right : PRGeneric;
begin
  Left := PRGeneric(Item1);
  Right := PRGeneric(Item2);
  Result := 0;

  if Left.Entity < Right.Entity then
  begin
    Result := -1;
    exit;
  end;
  if Left.Entity > Right.Entity then
  begin
    Result := 1;
    exit;
  end;

  if Left.Key1 < Right.Key1 then
  begin
    Result := -1;
    exit;
  end;
  if Left.Key1 > Right.Key1 then
  begin
    Result := 1;
    exit;
  end;

  if Left.NumberOfKeys = 1 then exit;

  if Left.Key2 < Right.Key2 then
  begin
    Result := -1;
    exit;
  end;
  if Left.Key2 > Right.Key2 then
  begin
    Result := 1;
    exit;
  end;

  if Left.NumberOfKeys = 2 then exit;

  if Left.Key3 < Right.Key3 then
  begin
    Result := -1;
    exit;
  end;
  if Left.Key3 > Right.Key3 then
  begin
    Result := 1;
    exit;
  end;

  if Left.NumberOfKeys = 3 then exit;

  if Left.Key4 < Right.Key4 then
  begin
    Result := -1;
    exit;
  end;
  if Left.Key4 > Right.Key4 then
  begin
    Result := 1;
    exit;
  end;

  if Left.NumberOfKeys = 4 then exit;

  if Left.Key5 < Right.Key5 then
  begin
    Result := -1;
    exit;
  end;
  if Left.Key5 > Right.Key5 then
  begin
    Result := 1;
    exit;
  end;

  if Left.NumberOfKeys = 5 then exit;

  if Left.Key6 < Right.Key6 then
  begin
    Result := -1;
    exit;
  end;
  if Left.Key6 > Right.Key6 then
  begin
    Result := 1;
    exit;
  end;

end;

//----------------------------------------------------------------------------//

function compareValuesOfTheLists(curr_valueList: TStringList; read_valueList: TStringList;
                                 numberOfKeys: integer): TDBOperation;
var
  index : integer;
  rv: String;
  cv: String;
begin
  Result := DBEqual;
  for index := 0 to curr_valueList.Count - 1 do
  begin
    if curr_valueList[Index] = read_valueList[Index] then
      continue
    else
    begin
      rv := read_valueList[Index];
      cv := curr_valueList[Index];

      if ( index >= numberOfKeys ) then // not key field
        Result := DBUpdate
      else
      begin
        if read_valueList[Index] > curr_valueList[Index] then
          Result := DBDelete
        else
          Result := DBInsert;
      end;

      break;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function PrepareHandledAttributeWorkCenter(ArcQry : TMqmQuery) : string;
var
  srvSqlStr, Str, TableName : string;
  WcList : TStringList;
  DndArchiveArcName : TDndArchiveName;
begin

  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'PRODUCTION_TIMES_LEVEL';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'PRODUCTION_TIMES_LEVEL';

  Str := '';
  WcList := TStringList.Create;

  srvSqlStr := 'SELECT DISTINCT WORK_CENTER_CODE from ' + TableName +
               ' WHERE (HANDLE_TIMES_BY = ' + QuotedStr('4') + ') Or (HANDLE_TIMES_BY = ' + QuotedStr('5') + ')' + AND_IDF_Condition('IDENTIFIER');
  ArcQry.sql.Clear;

  ArcQry.sql.Text := srvSqlStr;

  ArcQry.Open;
  var fldPHAWC_WcCode := ArcQry.FieldByName('WORK_CENTER_CODE');
  while not ArcQry.Eof do
  begin
    if WcList.IndexOf(fldPHAWC_WcCode.AsString) = -1 then
    begin
      WcList.Add(fldPHAWC_WcCode.AsString);
      if trim(str) <> '' then
        str := str + ', ';
      str := str + QuotedStr(fldPHAWC_WcCode.AsString);
    end;
    ArcQry.Next
  end;

  TableName := 'PRODUCTION_TIMES';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'PRODUCTION_TIMES';

  srvSqlStr := 'SELECT DISTINCT WORK_CENTER from ' + TableName + WHERE_IDF_Condition('IDENTIFIER');;

  ArcQry.sql.Clear;
  ArcQry.sql.Text := srvSqlStr;

  ArcQry.Open;
  var fldPHAWC_Wc := ArcQry.FieldByName('WORK_CENTER');
  while not ArcQry.Eof do
  begin
    if WcList.IndexOf(fldPHAWC_Wc.AsString) = -1 then
    begin
      WcList.Add(fldPHAWC_Wc.AsString);
      if trim(str) <> '' then
        str := str + ', ';
      str := str + QuotedStr(fldPHAWC_Wc.AsString);
    end;
    ArcQry.Next
  end;
  Result := str;
end;

//----------------------------------------------------------------------------//

function LoadIntoWORKCENTERANDOPERATTRIBUTES(OperAttributesList : TList; HostQry : TMqmQuery; HandledWorkCenterAttribute : string): boolean;
var
  NEW_WORKCENTERANDOPERATTRIBUTE: POPERATTRIBUTES;

  hostSqlStr:          String;
  srvSqlStr:           String;
//  tbInfo:              ^TTblInfo;
  I : Integer;
  curr_workcenterandoperattribute_list: TList;
  read_workcenterandoperattribute_list: TList;
  CompanyInUsed : string;
begin
//  tbInfo := @tblInfo[tbl_workcenter_and_operation_attributes];

  if not GetCompanyLevelHandlingByEntityName('WORKCENTERANDOPERATTRIBUTES',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  UpdateOperation(_('Downloading data for WORKCENTERANDOPERATTRIBUTES table'));

  hostSqlStr := 'SELECT WORKCENTERCODE, OPERATIONCODE, CODE, SHORTDESCRIPTION, ' +
                'STANDARDSTEPQUANTITY, STANDARDSTEPQTYUOMCODE, STEPEFFICIENCYAPPLY, ' +
                'STEPEFFICIENCY, TIMETYPE1CODE, TIME1, TIMEUNIT1, TIMEREFQTY1, ' +
                'TIMEREFUOM1CODE, TIMETYPE2CODE, TIME2, TIMEUNIT2, TIMEREFQTY2, ' +
                'TIMEREFUOM2CODE, TIMETYPE3CODE, TIME3, TIMEUNIT3, TIMEREFQTY3, ' +
                'TIMEREFUOM3CODE, TIMETYPE4CODE, TIME4,TIMEUNIT4, TIMEREFQTY4, ' +
                'TIMEREFUOM4CODE, TIMETYPE5CODE, TIME5, TIMEUNIT5, TIMEREFQTY5, ' +
                'TIMEREFUOM5CODE, REPETITIONNUMBER FROM WORKCENTERANDOPERATTRIBUTES ' +
                ' WHERE ( COMPANYCODE =  ' + QuotedStr('') +
                ' OR COMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' )' +
                ' AND WORKCENTERCODE IN (' + HandledWorkCenterAttribute + ')' +
                ' ORDER BY WORKCENTERCODE, OPERATIONCODE, CODE';

  HostQry.SQL.Text := hostSqlStr;
  hostQry.Open;

  var WORKCENTERCODE_FIELD := HostQry.FieldByName('WORKCENTERCODE');
  var OPERATIONCODE_FIELD := HostQry.FieldByName('OPERATIONCODE');
  var CODE_FIELD := HostQry.FieldByName('CODE');
  var SHORTDESCRIPTION_FIELD := HostQry.FieldByName('SHORTDESCRIPTION');
  var STANDARDSTEPQUANTITY_FIELD := HostQry.FieldByName('STANDARDSTEPQUANTITY');
  var STANDARDSTEPQTYUOMCODE_FIELD := HostQry.FieldByName('STANDARDSTEPQTYUOMCODE');
  var STEPEFFICIENCYAPPLY_FIELD := HostQry.FieldByName('STEPEFFICIENCYAPPLY');
  var STEPEFFICIENCY_FIELD := HostQry.FieldByName('STEPEFFICIENCY');
  var TIMETYPE1CODE_FIELD:= HostQry.FieldByName('TIMETYPE1CODE');
  var TIME1_FIELD := HostQry.FieldByName('TIME1');
  var TIMEUNIT1_FIELD := HostQry.FieldByName('TIMEUNIT1');
  var TIMEREFQTY1_FIELD := HostQry.FieldByName('TIMEREFQTY1');
  var TIMEREFUOM1CODE_FIELD := HostQry.FieldByName('TIMEREFUOM1CODE');
  var TIMETYPE2CODE_FIELD := HostQry.FieldByName('TIMETYPE2CODE');
  var TIME2_FIELD := HostQry.FieldByName('TIME2');
  var TIMEUNIT2_FIELD := HostQry.FieldByName('TIMEUNIT2');
  var TIMEREFQTY2_FIELD := HostQry.FieldByName('TIMEREFQTY2');
  var TIMEREFUOM2CODE_FIELD := HostQry.FieldByName('TIMEREFUOM2CODE');
  var TIMETYPE3CODE_FIELD := HostQry.FieldByName('TIMETYPE3CODE');
  var TIME3_FIELD := HostQry.FieldByName('TIME3');
  var TIMEUNIT3_FIELD := HostQry.FieldByName('TIMEUNIT3');
  var TIMEREFQTY3_FIELD := HostQry.FieldByName('TIMEREFQTY3');
  var TIMEREFUOM3CODE_FIELD := HostQry.FieldByName('TIMEREFUOM3CODE');
  var TIMETYPE4CODE_FIELD := HostQry.FieldByName('TIMETYPE4CODE');
  var TIME4_FIELD := HostQry.FieldByName('TIME4');
  var TIMEUNIT4_FIELD := HostQry.FieldByName('TIMEUNIT4');
  var TIMEREFQTY4_FIELD := HostQry.FieldByName('TIMEREFQTY4');
  var TIMEREFUOM4CODE_FIELD := HostQry.FieldByName('TIMEREFUOM4CODE');
  var TIMETYPE5CODE_FIELD := HostQry.FieldByName('TIMETYPE5CODE');
  var TIME5_FIELD := HostQry.FieldByName('TIME5');
  var TIMEUNIT5_FIELD := HostQry.FieldByName('TIMEUNIT5');
  var TIMEREFQTY5_FIELD := HostQry.FieldByName('TIMEREFQTY5');
  var TIMEREFUOM5CODE_FIELD := HostQry.FieldByName('TIMEREFUOM5CODE');
  var REPETITIONNUMBER_FIELD := HostQry.FieldByName('REPETITIONNUMBER');

  read_workcenterandoperattribute_list := TList.Create;
  while ( not hostQry.Eof ) do
  begin
    New(NEW_WORKCENTERANDOPERATTRIBUTE);
    NEW_WORKCENTERANDOPERATTRIBUTE.WORKCENTERCODE := Trim(WORKCENTERCODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.OPERATIONCODE := Trim(OPERATIONCODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.CODE := trim(CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.SHORTDESCRIPTION := trim(SHORTDESCRIPTION_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.STANDARDSTEPQUANTITY := getNumericValueOf(STANDARDSTEPQUANTITY_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.STANDARDSTEPQTYUOMCODE := TRIM(STANDARDSTEPQTYUOMCODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.STEPEFFICIENCYAPPLY := Trim(STEPEFFICIENCYAPPLY_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.STEPEFFICIENCY := getNumericValueOf(STEPEFFICIENCY_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMETYPE1CODE := trim(TIMETYPE1CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIME1 := getNumericValueOf(TIME1_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEUNIT1 := Trim(TIMEUNIT1_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEREFQTY1 := getNumericValueOf(TIMEREFQTY1_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEREFUOM1CODE := trim(TIMEREFUOM1CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMETYPE2CODE := trim(TIMETYPE2CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIME2 := getNumericValueOf(TIME2_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEUNIT2 := trim(TIMEUNIT2_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEREFQTY2 := getNumericValueOf(TIMEREFQTY2_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEREFUOM2CODE := trim(TIMEREFUOM2CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMETYPE3CODE := trim(TIMETYPE3CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIME3 := getNumericValueOf(TIME3_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEUNIT3 :=  trim(TIMEUNIT3_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEREFQTY3 := getNumericValueOf(TIMEREFQTY3_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEREFUOM3CODE := trim(TIMEREFUOM3CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMETYPE4CODE := trim(TIMETYPE4CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIME4 := getNumericValueOf(TIME4_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEUNIT4 := trim(TIMEUNIT4_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEREFQTY4 := getNumericValueOf(TIMEREFQTY4_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEREFUOM4CODE := trim(TIMEREFUOM4CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMETYPE5CODE := trim(TIMETYPE5CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIME5 := getNumericValueOf(TIME5_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEUNIT5 := trim(TIMEUNIT5_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEREFQTY5 := getNumericValueOf(TIMEREFQTY5_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.TIMEREFUOM5CODE := trim(TIMEREFUOM5CODE_FIELD.AsString);
    NEW_WORKCENTERANDOPERATTRIBUTE.REPETITIONNUMBER := REPETITIONNUMBER_FIELD.AsFloat;

    OperAttributesList.Add(NEW_WORKCENTERANDOPERATTRIBUTE);

    HostQry.Next;
  end;

  hostQry.Close;
  Result := True;
end;

//----------------------------------------------------------------------------//

function FindWORKCENTERANDOPERATTRIBUTES(WORKCENTERCODE, OPERATIONCODE : string; OperAttributesList : TList) : TList;
var
  i,J: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  RecordFound : POPERATTRIBUTES;
begin
  Result := nil;
  RecordFound := nil;

  NumberOfEntries := OperAttributesList.Count;
  if NumberOfEntries = 0 then exit;
  NumberOfEntriesMinusOne := NumberOfEntries - 1;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne)
    or ((POPERATTRIBUTES(OperAttributesList[i]).WORKCENTERCODE > WORKCENTERCODE)) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if  (POPERATTRIBUTES(OperAttributesList[i]).WORKCENTERCODE < WORKCENTERCODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (POPERATTRIBUTES(OperAttributesList[i]).OPERATIONCODE < OPERATIONCODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (POPERATTRIBUTES(OperAttributesList[i]).OPERATIONCODE > OPERATIONCODE) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    RecordFound := POPERATTRIBUTES(OperAttributesList[i]);
    Break;

  end;

  if RecordFound <> nil then
  begin
    J := i;
    Result := TList.Create;
    while (I >= 0) and (POPERATTRIBUTES(OperAttributesList[i]).WORKCENTERCODE = WORKCENTERCODE) and
            (POPERATTRIBUTES(OperAttributesList[i]).OPERATIONCODE = OPERATIONCODE) do
    begin
      J := i;
      dec(i);
    end;
    i := J;
    while (I <= OperAttributesList.Count -1) and (POPERATTRIBUTES(OperAttributesList[i]).WORKCENTERCODE = WORKCENTERCODE) and
            (POPERATTRIBUTES(OperAttributesList[i]).OPERATIONCODE = OPERATIONCODE) do
    begin
      Result.Add(OperAttributesList[I]);
      Inc(i)
    end;

  end;


end;

//----------------------------------------------------------------------------//

function Sort_PROUTING_STEP_TIME_TYPE(Item1, Item2: Pointer) : integer;
var
  PROUTING_STEP_TIME1 : PROUTING_STEP_TIME_TYPES;
  PROUTING_STEP_TIME2 : PROUTING_STEP_TIME_TYPES;
begin
  PROUTING_STEP_TIME1 := PROUTING_STEP_TIME_TYPES(Item1);
  PROUTING_STEP_TIME2 := PROUTING_STEP_TIME_TYPES(Item2);
  if PROUTING_STEP_TIME1.RSTT_CODE < PROUTING_STEP_TIME2.RSTT_CODE then
    Result := -1
  else if (PROUTING_STEP_TIME1.RSTT_CODE = PROUTING_STEP_TIME2.RSTT_CODE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

Procedure CompareForUpdate(HostQry : TMqmQuery; List1 : TList; Listdb : TList);
var
  DemandOrderReservationLine, DemandOrderReservationLinesDB : PRecDemandOrOrderReservationLine;
  i, y : Integer;
  Found : Boolean;
begin
  for i := 0 to List1.Count - 1  do
  begin
    Found := False;
    y := 0;
    DemandOrderReservationLine := PRecDemandOrOrderReservationLine(List1[i]);

    while y <= Listdb.Count - 1 do
    begin
      if  (DemandOrderReservationLine.Environment = PRecDemandOrOrderReservationLine(Listdb[y]).Environment)
      and (DemandOrderReservationLine.CompanyCode = PRecDemandOrOrderReservationLine(Listdb[y]).CompanyCode)
      and (DemandOrderReservationLine.CounterCode = PRecDemandOrOrderReservationLine(Listdb[y]).CounterCode)
      and (DemandOrderReservationLine.code = PRecDemandOrOrderReservationLine(Listdb[y]).code)
      and (DemandOrderReservationLine.reservationline = PRecDemandOrOrderReservationLine(Listdb[y]).reservationline) then
      begin
        Found := True;
        y := Listdb.Count - 1;
      end;

      inc(y);

    end;

    if not Found and ((y<= Listdb.Count) or (Listdb.Count = 0)) then
    Begin
       try
         HostQry.ExecSQL('Insert into SCHEDULESDOWNLOADWARPRSV '
          + ' Values('+ QuotedStr(DemandOrderReservationLine.CompanyCode)
          + ','+ QuotedStr(DemandOrderReservationLine.Environment)
          + ','+ QuotedStr(DemandOrderReservationLine.CounterCode)
          + ','+ QuotedStr(DemandOrderReservationLine.code)
          + ','+ IntToStr(DemandOrderReservationLine.reservationline) + ')');
       except
       end;
    End;
  end;

  for i := 0 to Listdb.Count - 1  do
  begin
    Found := False;
    y := 0;
    DemandOrderReservationLine := PRecDemandOrOrderReservationLine(Listdb[i]);

    while y <= List1.Count - 1 do
    begin
      if  (DemandOrderReservationLine.Environment = PRecDemandOrOrderReservationLine(List1[y]).Environment)
      and (DemandOrderReservationLine.CompanyCode = PRecDemandOrOrderReservationLine(List1[y]).CompanyCode)
      and (DemandOrderReservationLine.CounterCode = PRecDemandOrOrderReservationLine(List1[y]).CounterCode)
      and (DemandOrderReservationLine.code = PRecDemandOrOrderReservationLine(List1[y]).code)
      and (DemandOrderReservationLine.reservationline = PRecDemandOrOrderReservationLine(List1[y]).reservationline) then
      begin
        Found := True;
        y := List1.Count - 1;
      end;

      inc(y);

    end;

    if not Found then
    Begin
      HostQry.ExecSQL('Delete from SCHEDULESDOWNLOADWARPRSV '
        + ' where ENVIRONMENTCODE = ' + QuotedStr(DemandOrderReservationLine.Environment)
        + ' and COMPANYCODE  = ' + QuotedStr(DemandOrderReservationLine.CompanyCode)
        + ' and COUNTERCODE  = ' + QuotedStr(DemandOrderReservationLine.CounterCode)
        + ' and CODE  = ' + QuotedStr(DemandOrderReservationLine.code)
        + ' and RESERVATIONLINE  = ' + IntToStr(DemandOrderReservationLine.reservationline));
    End;

  end;

  HostQry.Close;

end;

//----------------------------------------------------------------------------//

function SortDemandOrOrderReservationLines(Item1, Item2: Pointer) : integer;
var
  ItemDORL1 : PRecDemandOrOrderReservationLine;
  ItemDORL2 : PRecDemandOrOrderReservationLine;
begin
  try
    ItemDORL1 := PRecDemandOrOrderReservationLine(Item1);
    ItemDORL2 := PRecDemandOrOrderReservationLine(Item2);

    if ItemDORL1.CounterCode < ItemDORL2.CounterCode then
      Result := -1
    else if ItemDORL1.CounterCode = ItemDORL2.CounterCode then
      Result := 0
    else
    begin
      if ItemDORL1.code < ItemDORL2.code then
        Result := -1
      else if ItemDORL1.code = ItemDORL2.code then
        Result := 0
      else
      begin
        if ItemDORL1.reservationline < ItemDORL2.reservationline then
          Result := -1
        else if ItemDORL1.reservationline = ItemDORL2.reservationline then
          Result := 0
        else
          result := 1;
      end;
    end;

  except
    Result := 0
  end;
end;

//----------------------------------------------------------------------------//

procedure Fill_MATERIAL_DETAIL_SCHEDULE(HostQry: TMqmQuery; LocalQry: TMqmQuery; HandledProductionDemandMqinSql : string; var WarpItemHandledStrList : TStringList; var WarpItemHandledStr : string; read_Material_Schedule_list : TList; read_Material_Schedule_list_Link : TList; articleTypeList : Tlist; logicalWarehouseList : TList; HandledWorkCenterSql : string; handledWorkCentersList : TList);
var
  CUR_ARTICLE_TYPE: PARTICLE_TYPES;
  RecMS : PRecMS;
  I, PrevGroupLine, StepNumber, Index, groupline : integer;
  qty : double;
  FoundWarp : boolean;
  hostSqlStr, LocaleSqlStr, CounterCode, CompanyInUsed_FIKD, WarpWcHandledStr : string;
  ProductCode, EntryWarehouseCode, SubDetail, DetailCode, request, DetailCodeType, SubDetailHostType ,
  PrevCode,PrevPRODUCTIONORDERCOUNTERCODE : string;
  ItemTypeWarp, UNITCODE, ORDERCOUNTERCODE : String;
  DecoSubCode01, DecoSubCode02, DecoSubCode03, DecoSubCode04, DecoSubCode05 : String;
  DecoSubCode06, DecoSubCode07, DecoSubCode08, DecoSubCode09, DecoSubCode10 : String;
  Curr_LOGICALWAREHOUSE: PLOGICALWAREHOUSES;
  SqlPrint : TStringList;
  FoundsameRec : boolean;
  WORKCENTER: PWORKCENTERS;
    //new
  DemandReservationLine : PRecDemandReservationLine;
  DemandOrderReservationLine, DemandOrderReservationLinesDB : PRecDemandOrOrderReservationLine;
  MaterialDetailScheduleLink : pRecMS;
  DemandReservationLines_List, DemandOrOrderReservationLine_List , DemandOrOrderReservationLineDB_List : TList;
  ProductionOrderCounters : TStringlist;

  tbInfo: ^TTblInfo;
begin

  FoundWarp := false;
  WarpItemHandledStr := '';
  WarpWcHandledStr   := '';

  // if at least one w.c is handling Warp , otherwise go out

  for I := 0 to articleTypeList.Count - 1 do
  begin
    CUR_ARTICLE_TYPE := PARTICLE_TYPES(articleTypeList.Items[I]);
    if not CUR_ARTICLE_TYPE.AT_IS_WARP_TYPE then continue;
    WarpItemHandledStrList.Add(CUR_ARTICLE_TYPE.AT_ART_TYPE);
    if trim(WarpItemHandledStr) <> '' then
      WarpItemHandledStr := WarpItemHandledStr + ', ';
    WarpItemHandledStr := WarpItemHandledStr + QuotedStr(CUR_ARTICLE_TYPE.AT_ART_TYPE);
    FoundWarp := true;
  end;

  if not FoundWarp then exit;

  for I := 0 to handledWorkCentersList.Count - 1 do
  begin
    WORKCENTER := PWORKCENTERS(handledWorkCentersList.Items[I]);
    if (WORKCENTER.WC_HANDLE_WARP <> '1') and (WORKCENTER.WC_HANDLE_WARP <> '2') then continue;
    if trim(WarpWcHandledStr) <> '' then
      WarpWcHandledStr := WarpWcHandledStr + ', ';
    WarpWcHandledStr := WarpWcHandledStr + QuotedStr(WORKCENTER.WC_WKCNTER);
  end;

  ///new
  DemandReservationLines_List := TList.Create;
  DemandOrOrderReservationLine_List := TList.Create;
  DemandOrOrderReservationLineDB_List := TList.Create;

  ProductionOrderCounters := TStringlist.Create;
  ProductionOrderCounters.Sorted := true;

  hostSqlStr := 'select pr.COMPANYCODE, pr.ORDERCOUNTERCODE, pr.ordercode, pr.reservationline, '+
    ' min(pr.RESERVATIONINGROUPORDER) RESERVATIONINGROUPORDER, min(pr.PRODUCTIONORDERCODE) PRODUCTIONORDERCODE, '+
    ' min(po.PRODUCTIONORDERCOUNTERCODE) PRODUCTIONORDERCOUNTERCODE, min(cast(pr.groupline as decimal(7,0))) groupline, '+
    ' min(case when  pdsWarp.PRODUCTIONDEMANDCOMPANYCODE is null then (pds.STEPNUMBER * 10 + 1) else (pds.STEPNUMBER * 10) end) StepNumberAndWarpRelevant '+
    ' from productionreservation pr  '+
    ' left join productionorder po on po.COMPANYCODE = pr.companycode and po.code = pr.PRODUCTIONORDERCODE  '+
    ' join productiondemandstep pds '+
    ' on pds.PRODUCTIONDEMANDCOMPANYCODE = pr.COMPANYCODE   '+
    ' and pds.PRODUCTIONDEMANDCOUNTERCODE = pr.ORDERCOUNTERCODE  ' +
    ' and pds.PRODUCTIONDEMANDCODE = pr.ordercode '+
    ' and pds.STEPNUMBER >= pr.STEPNUMBER '+
    ' and pds.WORKCENTERCODE in (' + HandledWorkCenterSql + ') ' + // List of work centers handled in MQM
    ' left join productiondemandstep pdsWarp '+
    ' on pdsWarp.PRODUCTIONDEMANDCOMPANYCODE = pr.COMPANYCODE ' +
    ' and pdsWarp.PRODUCTIONDEMANDCOUNTERCODE = pr.ORDERCOUNTERCODE  ' +
    ' and pdsWarp.PRODUCTIONDEMANDCODE = pr.ordercode '+
    ' and pdsWarp.STEPNUMBER = pds.STEPNUMBER '+
    ' and pdsWarp.WORKCENTERCODE in (' + WarpWcHandledStr + ') ' +
    ' where pr.companycode = ' + QuotedStr(IniAppGlobals.CompanyCode) +
    ' and   pr.ITEMTYPEAFICODE in (' + WarpItemHandledStr + ') ' +
    ' and   exists (select 1 from SCHEDULESDOWNLOADDEMANDS SDD where sdd.ENVIRONMENTCODE = '+ QuotedStr(IniAppGlobals.EnvironmentCode) +' and sdd.companycode = pr.companycode and sdd.countercode = pr.ORDERCOUNTERCODE  and sdd.code = pr.ordercode) '+
    ' group by pr.COMPANYCODE, pr.ORDERCOUNTERCODE, pr.ordercode, pr.reservationline '+
    ' order by RESERVATIONINGROUPORDER, PRODUCTIONORDERCOUNTERCODE, PRODUCTIONORDERCODE, groupline ';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;
  var fldMDS_StepNumWarp  := HostQry.FieldByName('StepNumberAndWarpRelevant');
  var fldMDS_OrdCtrCode   := HostQry.FieldByName('ORDERCOUNTERCODE');
  var fldMDS_OrderCode    := HostQry.FieldByName('ordercode');
  var fldMDS_ResLine      := HostQry.FieldByName('reservationline');
  var fldMDS_ProdOrdCode  := HostQry.FieldByName('PRODUCTIONORDERCODE');
  var fldMDS_GroupLine    := HostQry.FieldByName('groupline');
  var fldMDS_ResInGrpOrd  := HostQry.FieldByName('RESERVATIONINGROUPORDER');
  var fldMDS_ProdOrdCtr   := HostQry.FieldByName('PRODUCTIONORDERCOUNTERCODE');

  while not HostQry.Eof do
  begin

    if frac(fldMDS_StepNumWarp.AsFloat / 10) <> 0 then
    begin
      HostQry.Next;
      continue
    end;

    new(DemandReservationLine);
    DemandReservationLine.ORDERCOUNTERCODE    := fldMDS_OrdCtrCode.AsString;
    DemandReservationLine.ORDERCODE           := fldMDS_OrderCode.AsString;
    DemandReservationLine.reservationline     := fldMDS_ResLine.AsInteger;
    DemandReservationLine.PRODUCTIONORDERCODE := fldMDS_ProdOrdCode.AsString;
    DemandReservationLine.groupline           := fldMDS_GroupLine.AsInteger;
    DemandReservationLine.StepNumber          := trunc(fldMDS_StepNumWarp.AsFloat / 10);
    DemandReservationLines_List.Add(DemandReservationLine);

    PrevGroupLine := -1;
    PrevCode := '';
    PrevPRODUCTIONORDERCOUNTERCODE := '';

    if (fldMDS_ResInGrpOrd.AsInteger = 1) and (not fldMDS_ProdOrdCode.IsNull)
    and (fldMDS_ProdOrdCode.AsString <> ' ') then
    begin
      //new  PRODUCTIONORDERCODE
      if (PrevPRODUCTIONORDERCOUNTERCODE <> fldMDS_ProdOrdCtr.AsString) or
         (PrevCode <> fldMDS_ProdOrdCode.AsString) or
         (PrevGroupLine <> fldMDS_GroupLine.AsInteger) then
      begin
        PrevCode := fldMDS_ProdOrdCode.AsString;
        PrevGroupLine := fldMDS_GroupLine.AsInteger;

        new(DemandOrderReservationLine);
        DemandOrderReservationLine.Environment      := IniAppGlobals.EnvironmentCode;
        DemandOrderReservationLine.CompanyCode      := IniAppGlobals.CompanyCode;
        DemandOrderReservationLine.code             := fldMDS_ProdOrdCode.AsString;
        DemandOrderReservationLine.CounterCode      := fldMDS_ProdOrdCtr.AsString;
        DemandOrderReservationLine.reservationline  := fldMDS_GroupLine.AsInteger;
        DemandOrOrderReservationLine_List.Add(DemandOrderReservationLine);
      end;

      //new  PRODUCTIONORDERCOUNTERCODE
      if (PrevPRODUCTIONORDERCOUNTERCODE <> fldMDS_ProdOrdCtr.AsString) then
      begin
        PrevPRODUCTIONORDERCOUNTERCODE := fldMDS_ProdOrdCtr.AsString;
        ProductionOrderCounters.Add(PrevPRODUCTIONORDERCOUNTERCODE);
      end

    end
    else
    begin
       new(DemandOrderReservationLine);
       DemandOrderReservationLine.Environment      := IniAppGlobals.EnvironmentCode;
       DemandOrderReservationLine.CompanyCode      := IniAppGlobals.CompanyCode;
       DemandOrderReservationLine.code             := fldMDS_OrderCode.AsString;
       DemandOrderReservationLine.CounterCode      := fldMDS_OrdCtrCode.AsString;
       DemandOrderReservationLine.reservationline  := fldMDS_ResLine.AsInteger;
       DemandOrOrderReservationLine_List.Add(DemandOrderReservationLine);
    end;

    HostQry.Next;
  end;

  HostQry.Close;

  DemandOrOrderReservationLine_List.Sort(SortDemandOrOrderReservationLines);
  ///////////////////////////////////////////////

  hostSqlStr := 'select * from SCHEDULESDOWNLOADWARPRSV where ENVIRONMENTCODE = '+ QuotedStr(IniAppGlobals.EnvironmentCode) +
                ' and COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) +
                ' order by COUNTERCODE, CODE, RESERVATIONLINE';
  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;
  var fldWRSV_CounterCode   := HostQry.FieldByName('COUNTERCODE');
  var fldWRSV_Code          := HostQry.FieldByName('CODE');
  var fldWRSV_ResLine       := HostQry.FieldByName('RESERVATIONLINE');

  while not HostQry.Eof do
  begin
    new(DemandOrderReservationLinesDB);
    DemandOrderReservationLinesDB.Environment      := IniAppGlobals.EnvironmentCode;
    DemandOrderReservationLinesDB.CompanyCode      := IniAppGlobals.CompanyCode;
    DemandOrderReservationLinesDB.CounterCode := fldWRSV_CounterCode.AsString;
    DemandOrderReservationLinesDB.code := fldWRSV_Code.AsString;
    DemandOrderReservationLinesDB.reservationline := fldWRSV_ResLine.AsInteger;
    DemandOrOrderReservationLineDB_List.Add(DemandOrderReservationLinesDB);
    HostQry.Next;
  end;
  HostQry.Close;

  DemandOrOrderReservationLineDB_List.Sort(SortDemandOrOrderReservationLines);
  CompareForUpdate(HostQry, DemandOrOrderReservationLine_List, DemandOrOrderReservationLineDB_List);

  if not GetCompanyLevelHandlingByEntityName('FULLITEMKEYDECODER',  CompanyInUsed_FIKD) then
     CompanyInUsed_FIKD := IniAppGlobals.CompanyCode;

  hostSqlStr :=
    ' Select 0 FromTransactionOrAlloc,  pd.countercode, PD.code, 0.0 line,  pd.ITEMTYPEAFICODE ITYP, ' +
    ' pd.SUBCODE01, pd.SUBCODE02, pd.SUBCODE03, pd.SUBCODE04, ' +
    ' pd.SUBCODE05, pd.SUBCODE06, pd.SUBCODE07, pd.SUBCODE08, ' +
    ' pd.SUBCODE09, pd.SUBCODE10, ' +
    ' null CONTAINERITEMTYPECODE, null CONTAINERSUBCODE01 ,' +
    ' null CONTAINERELEMENTCODE, pde.ELEMENTCODE ELEMENTSCODE, ' +
    ' pde.BASEPRIMARYQUANTITY qty, pd.BASEPRIMARYUOMCODE uom, ' +
    ' pd.ENTRYWAREHOUSECODE warehouse, fikd.IDENTIFIER ' +
    ' from SCHEDULESDOWNLOADDEMANDS SDD ' +
    ' join PRODUCTIONDEMAND PD on pd.companycode = SDD.companycode and pd.countercode = SDD.countercode and PD.code = SDD.CODE and itemtypeaficode in (' + WarpItemHandledStr + ') ' +
    ' join FULLITEMKEYDECODER fikd on fikd.companycode= ' + QuotedStr(CompanyInUsed_FIKD) + ' and fikd.ITEMTYPECODE = pd.ITEMTYPEAFICODE and fikd.SUBCODE01 = pd.SUBCODE01 ' +
    ' and fikd.SUBCODE02 = pd.SUBCODE02 and fikd.SUBCODE03 = pd.SUBCODE03 and fikd.SUBCODE04 = pd.SUBCODE04 and fikd.SUBCODE05 = pd.SUBCODE05 ' +
    ' and fikd.SUBCODE06 = pd.SUBCODE06 and fikd.SUBCODE07 = pd.SUBCODE07 and fikd.SUBCODE08 = pd.SUBCODE08 and fikd.SUBCODE09 = pd.SUBCODE09 and fikd.SUBCODE10 = pd.SUBCODE10 ' +
    ' join PRODUCTIONDEMANDELEMENTS PDE on pde.companycode = sdd.companycode and pde.DEMANDCOUNTERCODE = sdd.countercode and pde.demandcode = sdd.code and pde.PROGRESSSTATUS = ' + QuotedStr('0') +
    ' where SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) +
    ' and SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
    ' and SDD.TemplateCode IN (' + HandledProductionDemandMqinSql + ')';

    hostSqlStr := hostSqlStr + ' union all ';

    hostSqlStr := hostSqlStr +
    'select 0 FromTransactionOrAlloc, null countercode, null code, 0.0 line, b.ITEMTYPECODE ITYP, ' +
    ' b.DECOSUBCODE01 SUBCODE01, b.DECOSUBCODE02 SUBCODE02, b.DECOSUBCODE03 SUBCODE03, b.DECOSUBCODE04 SUBCODE04, ' +
    ' b.DECOSUBCODE05 SUBCODE05, b.DECOSUBCODE06 SUBCODE06, b.DECOSUBCODE07 SUBCODE07, b.DECOSUBCODE08 SUBCODE08, ' +
    ' b.DECOSUBCODE09 SUBCODE09, b.DECOSUBCODE10 SUBCODE10, ' +
    ' b.CONTAINERITEMTYPECODE, b.CONTAINERSUBCODE01 ,' +
    ' b.CONTAINERELEMENTCODE, b.ELEMENTSCODE, ' +
    ' b.BASEPRIMARYQUANTITYUNIT qty, b.BASESECONDARYUNITCODE uom, ' +
    ' b.LOGICALWAREHOUSECODE warehouse, fikd.IDENTIFIER ' +
    ' from balance b ' +
    ' join FULLITEMKEYDECODER fikd on fikd.companycode= ' + QuotedStr(CompanyInUsed_FIKD) + ' and fikd.ITEMTYPECODE = b.ITEMTYPECODE and fikd.SUBCODE01 = b.DECOSUBCODE01 ' +
    ' and fikd.SUBCODE02 = b.DECOSUBCODE02 and fikd.SUBCODE03 = b.DECOSUBCODE03 and fikd.SUBCODE04 = b.DECOSUBCODE04 and fikd.SUBCODE05 = b.DECOSUBCODE05 ' +
    ' and fikd.SUBCODE06 = b.DECOSUBCODE06 and fikd.SUBCODE07 = b.DECOSUBCODE07 and fikd.SUBCODE08 = b.DECOSUBCODE08 and fikd.SUBCODE09 = b.DECOSUBCODE09 and fikd.SUBCODE10 = b.DECOSUBCODE10 ' +
    ' where b.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and b.ITEMTYPECODE in (' + WarpItemHandledStr + ')' +
    ' and ((b.ELEMENTSCODE is null and b.CONTAINERELEMENTCODE is not null) or (b.ELEMENTSCODE is not null))  ';

    hostSqlStr := hostSqlStr + ' union all ' +

    'select 1 FromTransactionOrAlloc, ' +
    'st.ordercountercode countercode, st.ordercode code, st.orderline line, st.ITEMTYPECODE ITYP, ' +
    'st.decoSUBCODE01 SUBCODE01, st.decoSUBCODE02 SUBCODE02, st.decoSUBCODE03 SUBCODE03, st.decoSUBCODE04 SUBCODE04, st.decoSUBCODE05 SUBCODE05, ' +
    'st.decoSUBCODE06 SUBCODE06, st.decoSUBCODE07 SUBCODE07, st.decoSUBCODE08 SUBCODE08, st.decoSUBCODE09 SUBCODE09, st.decoSUBCODE10 SUBCODE10, ' +
    'st.CONTAINERITEMTYPECODE, st.CONTAINERSUBCODE01 , st.CONTAINERELEMENTCODE, st.itemelementcode ELEMENTSCODE, ' +
    'st.BASEPRIMARYQUANTITY qty, st.BASEPRIMARYUOMCODE uom, st.logicalWAREHOUSECODE warehouse, st.FULLITEMIDENTIFIER IDENTIFIER ' +
    ' from stocktransaction st ' +
    ' where st.companycode = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and st.stocktransactiontype = ' + QuotedStr('5') + ' and st.ITEMTYPECODE in (' + WarpItemHandledStr + ')' +
    ' and ((st.itemelementcode is null and st.CONTAINERELEMENTCODE is not null) or (st.itemelementcode is not null)) ' +
    ' and exists (select 1 from SCHEDULESDOWNLOADWARPRSV SDWR where SDWR.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
    ' and sdwr.companycode = st.companycode and sdwr.countercode = st.ordercountercode and sdwr.code = st.ordercode and sdwr.reservationline = st.orderline )' +
    ' union all ' +
    ' select 2 FromTransactionOrAlloc, ' +
    ' a.countercode, a.ordercode code, a.orderline line,  a.ITEMTYPECODE ITYP, ' +
    ' a.decoSUBCODE01 SUBCODE01, a.decoSUBCODE02 SUBCODE02, a.decoSUBCODE03 SUBCODE03, a.decoSUBCODE04 SUBCODE04, a.decoSUBCODE05 SUBCODE05, ' +
    ' a.decoSUBCODE06 SUBCODE06, a.decoSUBCODE07 SUBCODE07, a.decoSUBCODE08 SUBCODE08, a.decoSUBCODE09 SUBCODE09, a.decoSUBCODE10 SUBCODE10, ' +
    ' a.CONTAINERITEMTYPECODE, a.CONTAINERSUBCODE01 , a.CONTAINERELEMENTCODE, a.itemelementcode ELEMENTSCODE, ' +
    ' a.BASEPRIMARYQUANTITY qty, a.BASEPRIMARYUOMCODE uom, a.logicalWAREHOUSECODE warehouse, a.FULLITEMIDENTIFIER IDENTIFIER ' +
    ' from allocation a ' +
    ' where a.companycode = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and a.detailtype = ' + QuotedStr('0') + ' and a.PROGRESSSTATUS in (' + QuotedStr('0') + ',' + QuotedStr('1') + ')' +
    ' and a.DestinationType = ' + QuotedStr('4') + ' and a.ITEMTYPECODE in (' + WarpItemHandledStr + ')' +
    ' and ((a.itemelementcode is null and a.CONTAINERELEMENTCODE is not null) or (a.itemelementcode is not null))' +
    ' and exists (select 1 from SCHEDULESDOWNLOADWARPRSV SDWR where SDWR.EnvironmentCode = ' + QuotedStr(IniAppGlobals.CompanyCode) +
    ' and sdwr.companycode = a.companycode and sdwr.countercode = a.countercode and sdwr.code = a.ordercode and sdwr.reservationline = a.orderline)' +
    ' order by FromTransactionOrAlloc, IDENTIFIER, ELEMENTSCODE, CONTAINERELEMENTCODE';

  HostQry.SQL.Text := hostSqlStr;
  SqlPrint := TStringList.Create;
  SqlPrint.Add(hostSqlStr);
  SqlPrint.SaveToFile(LocAppGlobals.AppDir + '\MaterialSched.txt');
  SqlPrint.Free;
  hostQry.Open;

  {
   Preq_No  - build request when countercode is not null
   DetailCodeType (1-Container element/2=Item element) = 1 when  ELEMENTSCODE is null else = 2
   SubDetailHostType (0=Empty/1=Container/2=ContainerElement) 0 When CONTAINERITEMTYPECODE = null else 1 when CONTAINERELEMENTCODE = null else 2.
   Sub_Detail Depend on SubDetailHostType. When 0 - Blank, when 1 CONTAINERITEMTYPECODE;CONTAINERSUBCODE01 when 2 CONTAINERITEMTYPECODE;CONTAINERSUBCODE01;CONTAINERELEMENTCODE
   Detail_Code Depend on DetailCodeType when 1 - CONTAINERELEMENTCODE else ELEMENTSCODE
   HostItemIndentifier  = IDENTIFIER
   HostWarehouse = warehouse
  }

  var ITEMTYPECODE_FIELD := HostQry.FieldByName('ITYP');
  var LOGICALWAREHOUSECODE_FIELD := HostQry.FieldByName('warehouse');
  var DECOSUBCODE01_FIELD := HostQry.FieldByName('SUBCODE01');
  var DECOSUBCODE02_FIELD := HostQry.FieldByName('SUBCODE02');
  var DECOSUBCODE03_FIELD := HostQry.FieldByName('SUBCODE03');
  var DECOSUBCODE04_FIELD := HostQry.FieldByName('SUBCODE04');
  var DECOSUBCODE05_FIELD := HostQry.FieldByName('SUBCODE05');
  var DECOSUBCODE06_FIELD := HostQry.FieldByName('SUBCODE06');
  var DECOSUBCODE07_FIELD := HostQry.FieldByName('SUBCODE07');
  var DECOSUBCODE08_FIELD := HostQry.FieldByName('SUBCODE08');
  var DECOSUBCODE09_FIELD := HostQry.FieldByName('SUBCODE09');
  var DECOSUBCODE10_FIELD := HostQry.FieldByName('SUBCODE10');
  var COUNTER_CODE_FIELD  := HostQry.FieldByName('countercode');
  var CODE_FIELD                := HostQry.FieldByName('CODE');
  var LINE_FIELD                := HostQry.FieldByName('line');
  var BASEPRIMARYQUANTITYUNIT_FIELD := HostQry.FieldByName('qty');
  var BASEPRIMARYQUANTITYUNITCODE_FIELD := HostQry.FieldByName('uom');
  var HostItemIndentifier_Field := HostQry.FieldByName('IDENTIFIER');
  var HostWarehouse_Field := HostQry.FieldByName('warehouse');
  var CONTAINERSUBCODE01_FIELD := HostQry.FieldByName('CONTAINERSUBCODE01');
  var ContainerTypeCode_FIELD := HostQry.FieldByName('CONTAINERITEMTYPECODE');
  var ContainerElement_FIELD := HostQry.FieldByName('CONTAINERELEMENTCODE');
  var ElementCode_FIELD := HostQry.FieldByName('ELEMENTSCODE');
  var FromTransactionOrAlloc_FIELD := HostQry.FieldByName('FromTransactionOrAlloc');

  while ( not hostQry.Eof ) do
  begin
    ItemTypeWarp  := ITEMTYPECODE_FIELD.AsString;
    DecoSubCode01 := DECOSUBCODE01_FIELD.AsString;
    DecoSubCode02 := DECOSUBCODE02_FIELD.AsString;
    DecoSubCode03 := DECOSUBCODE03_FIELD.AsString;
    DecoSubCode04 := DECOSUBCODE04_FIELD.AsString;
    DecoSubCode05 := DECOSUBCODE05_FIELD.AsString;
    DecoSubCode06 := DECOSUBCODE06_FIELD.AsString;
    DecoSubCode07 := DECOSUBCODE07_FIELD.AsString;
    DecoSubCode08 := DECOSUBCODE08_FIELD.AsString;
    DecoSubCode09 := DECOSUBCODE09_FIELD.AsString;
    DecoSubCode10 := DECOSUBCODE10_FIELD.AsString;
    EntryWarehouseCode := LOGICALWAREHOUSECODE_FIELD.AsString;

    ProductCode := getFullItemKeyCode(ItemTypeWarp, DecoSubCode01, DecoSubCode02, DecoSubCode03,
                       DecoSubCode04, DecoSubCode05, DecoSubCode06, DecoSubCode07, DecoSubCode08,
                       DecoSubCode09, DecoSubCode10);

    CounterCode := trim(COUNTER_CODE_FIELD.AsString);

    request := '';
    if (CounterCode <> '') then
    begin
      request := setStringLengthTo(IniAppGlobals.CompanyCode, 3) +
                             setStringLengthTo(CounterCode , 8) +
                             CODE_FIELD.AsString;
    end;

    qty := BASEPRIMARYQUANTITYUNIT_FIELD.AsFloat;

    if qty <= 0 then
    begin
      HostQry.Next;
      continue
    end;

    UNITCODE := BASEPRIMARYQUANTITYUNITCODE_FIELD.AsString;

    new(RecMS);
    RecMS.MS_Type_Prod    := ItemTypeWarp;
    RecMS.MS_Product_Code := ProductCode;
    RecMS.MS_UNITCODE     := UNITCODE;

    Curr_LOGICALWAREHOUSE := getLogicalWHStruct(EntryWarehouseCode, logicalWarehouseList);
    if Curr_LOGICALWAREHOUSE = nil then
      RecMS.MS_Net_Group_Code := ''
    else
      RecMS.MS_Net_Group_Code := Curr_LOGICALWAREHOUSE.MQMGROUPCODE;
    RecMS.MS_Preq_No := request;

    if (ElementCode_FIELD = nil) then
      DetailCodeType := '1'
    else
      DetailCodeType := '2';

    RecMS.MS_DetailCodeType := DetailCodeType;

    if (ContainerTypeCode_FIELD = nil) then
      SubDetailHostType := '0'
    else if (ContainerElement_FIELD = nil) then
      SubDetailHostType := '1'
    else
      SubDetailHostType := '2';

    RecMs.MS_SubDetailHostType := SubDetailHostType;

    if SubDetailHostType = '0' then
      RecMS.MS_Sub_Detail := ''
    else if SubDetailHostType = '1' then
      RecMS.MS_Sub_Detail := ContainerTypeCode_FIELD.AsString + ';' + CONTAINERSUBCODE01_FIELD.AsString
    else if SubDetailHostType = '2' then
    begin
      if (Trim(ContainerTypeCode_FIELD.AsString) <> '') and (Trim(CONTAINERSUBCODE01_FIELD.AsString) <> '') and (Trim(ContainerElement_FIELD.AsString) <> '') then
        RecMS.MS_Sub_Detail := ContainerTypeCode_FIELD.AsString + ';' + CONTAINERSUBCODE01_FIELD.AsString + ContainerElement_FIELD.AsString
      else
        RecMS.MS_Sub_Detail := '';
    end;

    if DetailCodeType = '1' then
      RecMS.MS_Detail_Code := ContainerElement_FIELD.AsString
    else
      RecMS.MS_Detail_Code := ElementCode_FIELD.AsString;

    RecMS.MS_HostItemIndentifier := HostItemIndentifier_Field.AsFloat;
    RecMS.MS_HostWarehouse := HostWarehouse_Field.AsString;

    RecMS.MS_Quantity := qty;

    FoundsameRec := false;
    for I := 0 to read_Material_Schedule_list.Count - 1 do
    begin
      if (PRecMS(RecMS).MS_Type_Prod = PRecMS(read_Material_Schedule_list[I]).MS_Type_Prod) and
         (PRecMS(RecMS).MS_Product_Code = PRecMS(read_Material_Schedule_list[I]).MS_Product_Code) and
         (PRecMS(RecMS).MS_Preq_No = PRecMS(read_Material_Schedule_list[I]).MS_Preq_No) and
         (PRecMS(RecMS).MS_Sub_Detail = PRecMS(read_Material_Schedule_list[I]).MS_Sub_Detail) and
         (PRecMS(RecMS).MS_Detail_Code = PRecMS(read_Material_Schedule_list[I]).MS_Detail_Code) then
      begin
        FoundsameRec := true;
        break;
      end;
    end;

    If FoundsameRec and (FromTransactionOrAlloc_FIELD.AsInteger = 1) then
       PRecMS(RecMS).MS_Quantity := PRecMS(RecMS).MS_Quantity + qty;

    if not FoundsameRec then
      read_Material_Schedule_list.Add(RecMS);

    if FromTransactionOrAlloc_FIELD.AsInteger = 0 then
    begin
      HostQry.Next;
      continue
    end;

    if not COUNTER_CODE_FIELD.IsNull then
    begin
      if ProductionOrderCounters.IndexOf(COUNTER_CODE_FIELD.AsString) = -1 then
      begin
        DemandReservationLine := FindInDemandReservationLines(DemandReservationLines_List, COUNTER_CODE_FIELD.AsString, CODE_FIELD.AsString,  LINE_FIELD.AsInteger);
        if (DemandReservationLine <> nil) then
        begin
          StepNumber := DemandReservationLine.StepNumber;
          MaterialDetailScheduleLink := FindAndAdd_MaterialDetailScheduleLink(read_Material_Schedule_list_Link, request, StepNumber, ItemTypeWarp, ProductCode, RecMS.MS_Sub_Detail, RecMS.MS_Detail_Code);
        end;
      end
      else
      begin
        Index := ProductionOrderCounters.IndexOf(COUNTER_CODE_FIELD.AsString);
        for I := 0 to DemandReservationLines_List.Count - 1 do
        begin
          ORDERCOUNTERCODE := ProductionOrderCounters.Strings[Index];
          groupline        := LINE_FIELD.AsInteger;
          StepNumber       := PRecDemandReservationLine(DemandReservationLines_List[I]).StepNumber;
          FindAndAdd_MaterialDetailScheduleLink(read_Material_Schedule_list_Link, request, StepNumber, ItemTypeWarp, ProductCode, RecMS.MS_Sub_Detail, RecMS.MS_Detail_Code);
        end;

      end;

    end;

    HostQry.Next;
  end;

end;

//----------------------------------------------------------------------------//

procedure fillRoutingStepTimeTypeToList(HostQry: TMqmQuery; routingStepTimeTypeList: TList);
var
  HostSqlStr: String;
  NEW_ROUTINGSTEPTIMETYPE : PROUTING_STEP_TIME_TYPES;
  CompanyInUsed : string;
begin

  if not GetCompanyLevelHandlingByEntityName('ROUTINGSTEPTIMETYPE',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  UpdateOperation(_('Downloading data for ROUTINGSTEPTIMETYPE table'));

  hostSqlStr := 'SELECT CODE, SHORTDESCRIPTION, "TYPE", APPLY, APPLYTYPECODE, EFFICIENCYSTEPUSED,REPETITIONSTEPUSED, PRINTINGSETUPTIMETYPE FROM '
                + 'ROUTINGSTEPTIMETYPE' + ' WHERE ( COMPANYCODE =  '+ QuotedStr('') +
                ' OR COMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' ) ' +
                'ORDER BY CODE';
  HostQry.SQL.Text := hostSqlStr;
  hostQry.Open;

  var CODE_FIELD := HostQry.FieldByName('CODE');
  var SHORTDESCRIPTION_FIELD := HostQry.FieldByName('SHORTDESCRIPTION');
  var APPLY_FIELD := HostQry.FieldByName('APPLY');
  var APPLYTYPECODE_FIELD := HostQry.FieldByName('APPLYTYPECODE');
  var TYPE_FIELD := HostQry.FieldByName('TYPE');
  var EFFICIENCYSTEPUSED_FIELD := HostQry.FieldByName('EFFICIENCYSTEPUSED');
  var REPETITIONSTEPUSED_FIELD := HostQry.FieldByName('REPETITIONSTEPUSED');
  var PRINTINGSETUPTIMETYPE_FIELD := HostQry.FieldByName('PRINTINGSETUPTIMETYPE');

  while ( not hostQry.Eof ) do
  begin
    New(NEW_ROUTINGSTEPTIMETYPE);
    NEW_ROUTINGSTEPTIMETYPE.RSTT_CODE := Trim(CODE_FIELD.AsString);
    NEW_ROUTINGSTEPTIMETYPE.RSTT_SHORTDESCRIPTION := Trim(SHORTDESCRIPTION_FIELD.AsString);
    NEW_ROUTINGSTEPTIMETYPE.RSTT_APPLY := APPLY_FIELD.AsString;
    NEW_ROUTINGSTEPTIMETYPE.RSTT_APPLYTYPECODE := Trim(APPLYTYPECODE_FIELD.AsString);
    NEW_ROUTINGSTEPTIMETYPE.RSTT_TYPE := TYPE_FIELD.AsString;

    NEW_ROUTINGSTEPTIMETYPE.RSTT_EFFICIENCYSTEPUSED := Trim(EFFICIENCYSTEPUSED_FIELD.AsString);
    NEW_ROUTINGSTEPTIMETYPE.RSTT_REPETITIONSTEPUSED := Trim(REPETITIONSTEPUSED_FIELD.AsString);
    NEW_ROUTINGSTEPTIMETYPE.RSTT_PRINTINGSETUPTIMETYPE := Trim(PRINTINGSETUPTIMETYPE_FIELD.AsString);

    routingStepTimeTypeList.Add(NEW_ROUTINGSTEPTIMETYPE);

    HostQry.Next;
  end;
  routingStepTimeTypeList.Sort(Sort_PROUTING_STEP_TIME_TYPE);

  hostQry.Close;

end;

//----------------------------------------------------------------------------//

procedure Fill_PRODUCT_FULLITEMKEYDECODER_TOOL(ArcQry : TMqmQuery; HostQry: TMqmQuery; WarpItemHandledStr : string; var ColumnNamesSql : string; List_Items : TList; HandledProductionDemandMqinSql : string);
var
  srvSqlStr, hostSqlStr, hostSqlStr_ItemWarehouse, lastPrimaryNR, SubCodeStr : string;
  ProductSpecializedGreigeSQL, ProductSpecializedSizeSQL, ProductSpecializedYarnSQL : String;
  ColumnNamesProduct, ColumnNamesProductSpecializedGreige : TStringList;
  ColumnNamesProductSpecializedSize, ColumnNamesProductSpecializedYarn : TStringList;
  ColumnNamesFullItemKeyDecoder : TStringList;
  columnName, tableName, tablePrefix, TempcolumnName, ItemWarehouseLinkCompanyInUsed, ItemTypeCompanyInUsed, LogicalWarehouseCompanyInUsed, ToolCompanyInUsed, ITEMREPLENISHMENTCompanyInUsed,
  CompanyInUsed_P, CompanyInUsed_FIKD, RecipeCompanyInUsed, DesignCompanyInUsed : string;
  I : Integer;
  Items : PTITEMS;
  ItemWarehouseLinkRec : PItemWarehouseLinkRec;

  Prev_ABSUNIQUEID, InfoDemand, WarpSQL : String;
  SqlPrint : TStringList;
  DndArchiveArcName : TDndArchiveName;
  TABLE_NAME_FIELD, COLUMN_NAME_FIELD
  , TABLENAME1_FIELD, COLUMNNAME1_FIELD, TABLENAME2_FIELD, COLUMNNAME2_FIELD, TABLENAME3_FIELD, COLUMNNAME3_FIELD
  , TABLENAME4_FIELD, COLUMNNAME4_FIELD, TABLENAME5_FIELD, COLUMNNAME5_FIELD, TABLENAME6_FIELD, COLUMNNAME6_FIELD
  , TABLENAME7_FIELD, COLUMNNAME7_FIELD, TABLENAME8_FIELD, COLUMNNAME8_FIELD, TABLENAME9_FIELD, COLUMNNAME9_FIELD
  , TABLENAME10_FIELD, COLUMNNAME10_FIELD : TField;
  fldProduct, fldProductSpecializedGreige, fldProductSpecializedSize,
  fldProductSpecializedYarn, fldFullItemKeyDecoder: array of TField;
  PSG_COMPANYCODE_FIELD, PSS_COMPANYCODE_FIELD, PSY_COMPANYCODE_FIELD: TField;
begin

  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'PROPERTY_RTV_VALUE';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'PROPERTY_RTV_VALUE';

  SqlPrint   := TStringList.Create;
//  tbInfoArty := @tblInfo[tbl_article_type];
  if not GetCompanyLevelHandlingByEntityName('FULLITEMKEYDECODER',  CompanyInUsed_FIKD) then
     CompanyInUsed_FIKD := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PRODUCT',  CompanyInUsed_P) then
     CompanyInUsed_P := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('ITEMTYPE',  ItemTypeCompanyInUsed) then
     ItemTypeCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('LOGICALWAREHOUSE',  LogicalWarehouseCompanyInUsed) then
     LogicalWarehouseCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('ITEMREPLENISHMENT',  ITEMREPLENISHMENTCompanyInUsed) then
     ITEMREPLENISHMENTCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('ITEMWAREHOUSELINK',  ItemWarehouseLinkCompanyInUsed) then
     ItemWarehouseLinkCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('TOOL',  ToolCompanyInUsed) then
     ToolCompanyInUsed := IniAppGlobals.CompanyCode;

  UpdateOperation(_('Fill_PRODUCT_Start'));

 { for I := List_Items.Count - 1 downto 0 do    // Not in used ColumnNamesSql = '' in this stage.
  begin
    if ColumnNamesSql <> '' then
    begin
      if PTITEMS(List_Items[I]).ProductColumn_Created then
      begin
        PTITEMS(List_Items[I]).ProductColumn_Created := false;
        PTITEMS(List_Items[I]).ProductColumnNames.Free;
        PTITEMS(List_Items[I]).ProductColumnNames := nil;
        PTITEMS(List_Items[I]).ProductColumnValue.Free;
        PTITEMS(List_Items[I]).ProductColumnValue := nil;
      end;
      if PTITEMS(List_Items[I]).ProductSpecializedGreigeColumn_Created then
      begin
        PTITEMS(List_Items[I]).ProductSpecializedGreigeColumn_Created := false;
        PTITEMS(List_Items[I]).ProductSpecializedGreigeColumnNames.Free;
        PTITEMS(List_Items[I]).ProductSpecializedGreigeColumnNames := nil;
        PTITEMS(List_Items[I]).ProductSpecializedGreigeColumnValue.Free;
        PTITEMS(List_Items[I]).ProductSpecializedGreigeColumnValue := nil;
      end;
      if PTITEMS(List_Items[I]).ProductSpecializedSizeColumn_Created then
      begin
        PTITEMS(List_Items[I]).ProductSpecializedSizeColumn_Created := false;
        PTITEMS(List_Items[I]).ProductSpecializedSizeColumnNames.Free;
        PTITEMS(List_Items[I]).ProductSpecializedSizeColumnNames := nil;
        PTITEMS(List_Items[I]).ProductSpecializedSizeColumnValue.Free;
        PTITEMS(List_Items[I]).ProductSpecializedSizeColumnValue := nil;
      end;
      if PTITEMS(List_Items[I]).ProductSpecializedYarnColumn_Created then
      begin
        PTITEMS(List_Items[I]).ProductSpecializedYarnColumn_Created := false;
        PTITEMS(List_Items[I]).ProductSpecializedYarnColumnNames.Free;
        PTITEMS(List_Items[I]).ProductSpecializedYarnColumnNames := nil;
        PTITEMS(List_Items[I]).ProductSpecializedYarnColumnValue.Free;
        PTITEMS(List_Items[I]).ProductSpecializedYarnColumnValue := nil;
      end;
      if PTITEMS(List_Items[I]).FullItemKeyDecoderColumn_Created then
      begin
        PTITEMS(List_Items[I]).FullItemKeyDecoderColumn_Created := false;
        PTITEMS(List_Items[I]).FullItemKeyDecoderColumnNames.Free;
        PTITEMS(List_Items[I]).FullItemKeyDecoderColumnNames := nil;
        PTITEMS(List_Items[I]).FullItemKeyDecoderColumnValue.Free;
        PTITEMS(List_Items[I]).FullItemKeyDecoderColumnValue := nil;
      end;
    end;
    dispose(PTITEMS(List_Items[I]));
  end;  }
  List_Items.clear;
  ColumnNamesSql := '';

  srvSqlStr := 'SELECT TABLE_NAME, COLUMN_NAME FROM ' + TableName +
               ' WHERE ' +
               ' TABLE_NAME IN ( ' +
               QuotedStr('PRODUCT') + ',' +
               QuotedStr('PRODUCTSPECIALIZEDGREIGE') + ',' +
               QuotedStr('PRODUCTSPECIALIZEDSIZE') + ',' +
               QuotedStr('PRODUCTSPECIALIZEDYARN') + ',' +
               QuotedStr('FULLITEMKEYDECODER') + ')' +
               AND_IDF_Condition('IDENTIFIER');

  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;

  TABLE_NAME_FIELD := ArcQry.FieldByName('TABLE_NAME');
  COLUMN_NAME_FIELD := ArcQry.FieldByName('COLUMN_NAME');

  ColumnNamesFullItemKeyDecoder := TSTringList.create;
  ColumnNamesProduct := TSTringList.create;
  ColumnNamesProductSpecializedGreige := TSTringList.create;
  ColumnNamesProductSpecializedSize := TSTringList.create;
  ColumnNamesProductSpecializedYarn := TSTringList.create;

  while ( not ArcQry.Eof ) do
  begin
    tableName := Trim(TABLE_NAME_FIELD.AsString);
    columnName := Trim(COLUMN_NAME_FIELD.AsString);

    //tablePrefix := '';

    if ( tableName = 'FULLITEMKEYDECODER') then
      tablePrefix := 'FIKD'
    else if (tableName = 'PRODUCTSPECIALIZEDGREIGE') then
      tablePrefix := 'PSG'
    else if (tableName = 'PRODUCTSPECIALIZEDSIZE') then
      tablePrefix := 'PSS'
    else if (tableName = 'PRODUCTSPECIALIZEDYARN') then
      tablePrefix := 'PSY'
    else if ( tableName = 'PRODUCT') then
      tablePrefix := 'P';

    if (tablePrefix = 'P') then
    begin
      if ( ColumnNamesProduct.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
      begin
        TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
        ColumnNamesProduct.Add(TempcolumnName);
        ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName +
                           ' AS ' + TempcolumnName;
        ColumnNamesSql := ColumnNamesSql + ', ';
      end;
    end
    else if (tablePrefix = 'PSG') then
    begin
      if ( ColumnNamesProductSpecializedGreige.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
      begin
        TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
        ColumnNamesProductSpecializedGreige.Add(TempcolumnName);
        ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName +
                           ' AS ' + TempcolumnName;
        ColumnNamesSql := ColumnNamesSql + ', ';
      end;
    end
    else if (tablePrefix = 'PSS') then
    begin
      if ( ColumnNamesProductSpecializedSize.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
      begin
        TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
        ColumnNamesProductSpecializedSize.Add(TempcolumnName);
        ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName +
                           ' AS ' + TempcolumnName;
        ColumnNamesSql := ColumnNamesSql + ', ';
      end;
    end
    else if (tablePrefix = 'PSY') then
    begin
      if ( ColumnNamesProductSpecializedYarn.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
      begin
        TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
        ColumnNamesProductSpecializedYarn.Add(TempcolumnName);
        ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName +
                           ' AS ' + TempcolumnName;
        ColumnNamesSql := ColumnNamesSql + ', ';
      end;
    end
    else if (tablePrefix = 'FIKD') then
    begin
      if ( ColumnNamesFullItemKeyDecoder.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
      begin
        TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
        ColumnNamesFullItemKeyDecoder.Add(TempcolumnName);
        ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName +
                           ' AS ' + TempcolumnName;
        ColumnNamesSql := ColumnNamesSql + ', ';
      end;

    end;

    ArcQry.Next;
  end;

  TableName := 'PRODUCTION_TIMES_LEVEL';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'PRODUCTION_TIMES_LEVEL';

  ArcQry.Active := false;
  srvSqlStr := 'SELECT TABLENAME1, COLUMNNAME1, TABLENAME2, COLUMNNAME2, ' +
               'TABLENAME3, COLUMNNAME3, TABLENAME4, COLUMNNAME4, ' +
               'TABLENAME5, COLUMNNAME5, TABLENAME6, COLUMNNAME6, ' +
               'TABLENAME7, COLUMNNAME7, TABLENAME8, COLUMNNAME8, ' +
               'TABLENAME9, COLUMNNAME9, TABLENAME10, COLUMNNAME10 ' +
               'FROM ' + TableName + WHERE_IDF_Condition('IDENTIFIER');

  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;

  TABLENAME1_FIELD := ArcQry.FieldByName('TABLENAME1');
  COLUMNNAME1_FIELD := ArcQry.FieldByName('COLUMNNAME1');
  TABLENAME2_FIELD := ArcQry.FieldByName('TABLENAME2');
  COLUMNNAME2_FIELD := ArcQry.FieldByName('COLUMNNAME2');
  TABLENAME3_FIELD := ArcQry.FieldByName('TABLENAME3');
  COLUMNNAME3_FIELD := ArcQry.FieldByName('COLUMNNAME3');
  TABLENAME4_FIELD := ArcQry.FieldByName('TABLENAME4');
  COLUMNNAME4_FIELD := ArcQry.FieldByName('COLUMNNAME4');
  TABLENAME5_FIELD := ArcQry.FieldByName('TABLENAME5');
  COLUMNNAME5_FIELD := ArcQry.FieldByName('COLUMNNAME5');
  TABLENAME6_FIELD := ArcQry.FieldByName('TABLENAME6');
  COLUMNNAME6_FIELD := ArcQry.FieldByName('COLUMNNAME6');
  TABLENAME7_FIELD := ArcQry.FieldByName('TABLENAME7');
  COLUMNNAME7_FIELD := ArcQry.FieldByName('COLUMNNAME7');
  TABLENAME8_FIELD := ArcQry.FieldByName('TABLENAME8');
  COLUMNNAME8_FIELD := ArcQry.FieldByName('COLUMNNAME8');
  TABLENAME9_FIELD := ArcQry.FieldByName('TABLENAME9');
  COLUMNNAME9_FIELD := ArcQry.FieldByName('COLUMNNAME9');
  TABLENAME10_FIELD := ArcQry.FieldByName('TABLENAME10');
  COLUMNNAME10_FIELD := ArcQry.FieldByName('COLUMNNAME10');


  while ( not ArcQry.Eof ) do
  begin
    for i := 1 to 10 do
    begin
      case i of
         1 :
         begin
          tableName := Trim(TABLENAME1_FIELD.AsString);
          columnName := Trim(COLUMNNAME1_FIELD.AsString);
         end;
         2 :
         begin
          tableName := Trim(TABLENAME2_FIELD.AsString);
          columnName := Trim(COLUMNNAME2_FIELD.AsString);
         end;
         3 :
         begin
          tableName := Trim(TABLENAME3_FIELD.AsString);
          columnName := Trim(COLUMNNAME3_FIELD.AsString);
         end;
         4 :
         begin
          tableName := Trim(TABLENAME4_FIELD.AsString);
          columnName := Trim(COLUMNNAME4_FIELD.AsString);
         end;

         5 :
         begin
          tableName := Trim(TABLENAME5_FIELD.AsString);
          columnName := Trim(COLUMNNAME5_FIELD.AsString);
         end;
         6 :
         begin
          tableName := Trim(TABLENAME6_FIELD.AsString);
          columnName := Trim(COLUMNNAME6_FIELD.AsString);
         end;
         7 :
         begin
          tableName := Trim(TABLENAME7_FIELD.AsString);
          columnName := Trim(COLUMNNAME7_FIELD.AsString);
         end;
         8 :
         begin
          tableName := Trim(TABLENAME8_FIELD.AsString);
          columnName := Trim(COLUMNNAME8_FIELD.AsString);
         end;
         9 :
         begin
          tableName := Trim(TABLENAME9_FIELD.AsString);
          columnName := Trim(COLUMNNAME9_FIELD.AsString);
         end;
         10 :
         begin
          tableName := Trim(TABLENAME10_FIELD.AsString);
          columnName := Trim(COLUMNNAME10_FIELD.AsString);
         end;
      end;


      tablePrefix := '';

      if (tableName = 'PRODUCT') then
        tablePrefix := 'P'
      else if (tableName = 'PRODUCTSPECIALIZEDGREIGE') then
        tablePrefix := 'PSG'
      else if (tableName = 'PRODUCTSPECIALIZEDSIZE') then
        tablePrefix := 'PSS'
      else if (tableName = 'PRODUCTSPECIALIZEDYARN') then
        tablePrefix := 'PSY'
      else if (tableName = 'FULLITEMKEYDECODER') then
        tablePrefix := 'FIKD';

      if (tablePrefix = '') then
         continue;

      if (tablePrefix = 'P') then
      begin
        if ( ColumnNamesProduct.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
        begin
          TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
          ColumnNamesProduct.Add(TempcolumnName);
          ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName +
                             ' AS ' + TempcolumnName;
          ColumnNamesSql := ColumnNamesSql + ', ';
        end;
      end
      else if (tablePrefix = 'PSG') then
      begin
        if ( ColumnNamesProductSpecializedGreige.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
        begin
          TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
          ColumnNamesProductSpecializedGreige.Add(TempcolumnName);
          ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName +
                             ' AS ' + TempcolumnName;
          ColumnNamesSql := ColumnNamesSql + ', ';
        end;
      end
      else if (tablePrefix = 'PSS') then
      begin
        if ( ColumnNamesProductSpecializedSize.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
        begin
          TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
          ColumnNamesProductSpecializedSize.Add(TempcolumnName);
          ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName +
                             ' AS ' + TempcolumnName;
          ColumnNamesSql := ColumnNamesSql + ', ';
        end;
      end
      else if (tablePrefix = 'PSY') then
      begin
        if ( ColumnNamesProductSpecializedYarn.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
        begin
          TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
          ColumnNamesProductSpecializedYarn.Add(TempcolumnName);
          ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName +
                             ' AS ' + TempcolumnName;
          ColumnNamesSql := ColumnNamesSql + ', ';
        end;
      end
      else if (tablePrefix = 'FIKD') then
      begin
        if ( ColumnNamesFullItemKeyDecoder.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
        begin
          TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
          ColumnNamesFullItemKeyDecoder.Add(TempcolumnName);
          ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName +
                             ' AS ' + TempcolumnName;
          ColumnNamesSql := ColumnNamesSql + ', ';
        end;
      end;

    end;

    ArcQry.Next;

  end;

  ArcQry.Active := false;

  WarpSQL := '';
  if (WarpItemHandledStr <> '') then
    WarpSQL :=
    ' UNION ' +
    'Select distinct ' +
      'ITEM.CompanyCode, ITEM.ITEMTYPEAFICOMPANYCODE, ITEM.ITEMTYPEAFICODE,' +
      'ITEM.SUBCODE01, ITEM.SUBCODE02, ITEM.SUBCODE03, ITEM.SUBCODE04, ITEM.SUBCODE05,' +
      'ITEM.SUBCODE06, ITEM.SUBCODE07, ITEM.SUBCODE08, ITEM.SUBCODE09, ITEM.SUBCODE10,' +
      'case when IT.LASTPRIMARYNR > 1 then ITEM.SUBCODE02 else ' + QuotedStr(' ') + ' end Primary_SUBCODE02,' +
      'case when IT.LASTPRIMARYNR > 2 then ITEM.SUBCODE03 else ' + QuotedStr(' ') + ' end Primary_SUBCODE03,' +
      'case when IT.LASTPRIMARYNR > 3 then ITEM.SUBCODE04 else ' + QuotedStr(' ') + ' end Primary_SUBCODE04,' +
      'case when IT.LASTPRIMARYNR > 4 then ITEM.SUBCODE05 else ' + QuotedStr(' ') + ' end Primary_SUBCODE05,' +
      'case when IT.LASTPRIMARYNR > 5 then ITEM.SUBCODE06 else ' + QuotedStr(' ') + ' end Primary_SUBCODE06,' +
      'case when IT.LASTPRIMARYNR > 6 then ITEM.SUBCODE07 else ' + QuotedStr(' ') + ' end Primary_SUBCODE07,' +
      'case when IT.LASTPRIMARYNR > 7 then ITEM.SUBCODE08 else ' + QuotedStr(' ') + ' end Primary_SUBCODE08,' +
      'case when IT.LASTPRIMARYNR > 8 then ITEM.SUBCODE09 else ' + QuotedStr(' ') + ' end Primary_SUBCODE09,' +
      'case when IT.LASTPRIMARYNR > 9 then ITEM.SUBCODE10 else ' + QuotedStr(' ') + ' end Primary_SUBCODE10 ' +
    'From SchedulesDownloadDemAnds SDD ' +
    'JOIN PRODUCTIONDEMAND ITEM ' +
    'On ITEM.CompanyCode = SDD.CompanyCode ' +
    'And ITEM.CounterCode = SDD.CounterCode ' +
    'And ITEM.Code = SDD.Code ' +
    'and item.itemtypeaficode in (' + WarpItemHandledStr + ') ' +
    'Join ITEMTYPE IT On IT.COMPANYCODE = ' + QuotedStr(ItemTypeCompanyInUsed) + ' And IT.CODE = ITEM.ITEMTYPEAFICODE ' +
    'WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
    'and SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
  //  'and SDD.TemplateCode IN (' + HandledProductionDemandMqinSql + ') ' + ' ' +
    'and exists (select 1 from PRODUCTIONDEMANDELEMENTS PDE where pde.companycode = sdd.companycode and pde.DEMANDCOUNTERCODE = sdd.countercode and pde.demandcode = sdd.code and pde.PROGRESSSTATUS = ' + QuotedStr('0') + ') ' +
    'union ' +
    'Select distinct ' +
      'ITEM.CompanyCode, ITEM.ITEMTYPECOMPANYCODE ITEMTYPEAFICOMPANYCODE, ITEM.ITEMTYPECODE ITEMTYPEAFICODE, ' +
      'ITEM.DECOSUBCODE01 SUBCODE01, ITEM.DECOSUBCODE02 SUBCODE02, ITEM.DECOSUBCODE03 SUBCODE03, ITEM.DECOSUBCODE04 SUBCODE04, ' +
      'ITEM.DECOSUBCODE05 SUBCODE05, ITEM.DECOSUBCODE06 SUBCODE06, ITEM.DECOSUBCODE07 SUBCODE07, ITEM.DECOSUBCODE08 SUBCODE08, ' +
      'ITEM.DECOSUBCODE09 SUBCODE09, ITEM.DECOSUBCODE10 SUBCODE10, ' +
      'case when IT.LASTPRIMARYNR > 1 then ITEM.DECOSUBCODE02 else ' + QuotedStr(' ') + ' end Primary_SUBCODE02,' +
      'case when IT.LASTPRIMARYNR > 2 then ITEM.DECOSUBCODE03 else ' + QuotedStr(' ') + ' end Primary_SUBCODE03,' +
      'case when IT.LASTPRIMARYNR > 3 then ITEM.DECOSUBCODE04 else ' + QuotedStr(' ') + ' end Primary_SUBCODE04,' +
      'case when IT.LASTPRIMARYNR > 4 then ITEM.DECOSUBCODE05 else ' + QuotedStr(' ') + ' end Primary_SUBCODE05,' +
      'case when IT.LASTPRIMARYNR > 5 then ITEM.DECOSUBCODE06 else ' + QuotedStr(' ') + ' end Primary_SUBCODE06,' +
      'case when IT.LASTPRIMARYNR > 6 then ITEM.DECOSUBCODE07 else ' + QuotedStr(' ') + ' end Primary_SUBCODE07,' +
      'case when IT.LASTPRIMARYNR > 7 then ITEM.DECOSUBCODE08 else ' + QuotedStr(' ') + ' end Primary_SUBCODE08,' +
      'case when IT.LASTPRIMARYNR > 8 then ITEM.DECOSUBCODE09 else ' + QuotedStr(' ') + ' end Primary_SUBCODE09,' +
      'case when IT.LASTPRIMARYNR > 9 then ITEM.DECOSUBCODE10 else ' + QuotedStr(' ') + ' end Primary_SUBCODE10 ' +
    'From balance ITEM ' +
    'Join ITEMTYPE IT On IT.COMPANYCODE = ' + QuotedStr(ItemTypeCompanyInUsed) + ' And IT.CODE = ITEM.ITEMTYPECODE ' +
    'WHERE ITEM.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
    'and ITEM.ITEMTYPECODE in (' + WarpItemHandledStr + ')';


  if ColumnNamesProductSpecializedGreige.Count > 0 then
  begin
    ColumnNamesSql := ColumnNamesSql + 'PSG.PRODUCTCOMPANYCODE AS PSGCOMPANYCODE, ';
    ProductSpecializedGreigeSQL :=
     'left Join ProductSpecializedGreige PSG ' +
     'On   PSG.PRODUCTCOMPANYCODE = ITEM.ITEMTYPEAFICOMPANYCODE And PSG.PRODUCTITEMTYPECODE = ITEM.ITEMTYPEAFICODE ' +
     'AND  PSG.PRODUCTSUBCODE01 = ITEM.SUBCODE01 And PSG.PRODUCTSUBCODE02 = ITEM.Primary_SUBCODE02 And PSG.PRODUCTSUBCODE03 = ITEM.Primary_SUBCODE03 ' +
	   'AND  PSG.PRODUCTSUBCODE04 = ITEM.Primary_SUBCODE04 And PSG.PRODUCTSUBCODE05 = ITEM.Primary_SUBCODE05 AND  PSG.PRODUCTSUBCODE06 = ITEM.Primary_SUBCODE06 ' +
	   'AND  PSG.PRODUCTSUBCODE07 = ITEM.Primary_SUBCODE07 And PSG.PRODUCTSUBCODE08 = ITEM.Primary_SUBCODE08 And PSG.PRODUCTSUBCODE09 = ITEM.Primary_SUBCODE09 ' +
	   'AND  PSG.PRODUCTSUBCODE10 = ITEM.Primary_SUBCODE10 '
  end
  else
    ProductSpecializedGreigeSQL := '';

  if ColumnNamesProductSpecializedSize.Count > 0 then
  begin
    ColumnNamesSql := ColumnNamesSql + 'PSS.PRODUCTCOMPANYCODE AS PSSCOMPANYCODE, ';
    ProductSpecializedSizeSQL :=
     'left Join ProductSpecializedSize PSS ' +
     'On   PSS.PRODUCTCOMPANYCODE = ITEM.ITEMTYPEAFICOMPANYCODE And PSS.PRODUCTITEMTYPECODE = ITEM.ITEMTYPEAFICODE ' +
     'AND  PSS.PRODUCTSUBCODE01 = ITEM.SUBCODE01 And PSS.PRODUCTSUBCODE02 = ITEM.Primary_SUBCODE02 And PSS.PRODUCTSUBCODE03 = ITEM.Primary_SUBCODE03 ' +
	   'AND  PSS.PRODUCTSUBCODE04 = ITEM.Primary_SUBCODE04 And PSS.PRODUCTSUBCODE05 = ITEM.Primary_SUBCODE05 AND  PSS.PRODUCTSUBCODE06 = ITEM.Primary_SUBCODE06 ' +
	   'AND  PSS.PRODUCTSUBCODE07 = ITEM.Primary_SUBCODE07 And PSS.PRODUCTSUBCODE08 = ITEM.Primary_SUBCODE08 And PSS.PRODUCTSUBCODE09 = ITEM.Primary_SUBCODE09 ' +
	   'AND  PSS.PRODUCTSUBCODE10 = ITEM.Primary_SUBCODE10 '
  end
  else
    ProductSpecializedSizeSQL := '';

  if ColumnNamesProductSpecializedYarn.Count > 0 then
  begin
    ColumnNamesSql := ColumnNamesSql + 'PSY.PRODUCTCOMPANYCODE AS PSYCOMPANYCODE, ';
    ProductSpecializedYarnSQL :=
     'left Join ProductSpecializedYarn PSY ' +
     'On   PSY.PRODUCTCOMPANYCODE = ITEM.ITEMTYPEAFICOMPANYCODE And PSY.PRODUCTITEMTYPECODE = ITEM.ITEMTYPEAFICODE ' +
     'AND  PSY.PRODUCTSUBCODE01 = ITEM.SUBCODE01 And PSY.PRODUCTSUBCODE02 = ITEM.Primary_SUBCODE02 And PSY.PRODUCTSUBCODE03 = ITEM.Primary_SUBCODE03 ' +
	   'AND  PSY.PRODUCTSUBCODE04 = ITEM.Primary_SUBCODE04 And PSY.PRODUCTSUBCODE05 = ITEM.Primary_SUBCODE05 AND  PSY.PRODUCTSUBCODE06 = ITEM.Primary_SUBCODE06 ' +
	   'AND  PSY.PRODUCTSUBCODE07 = ITEM.Primary_SUBCODE07 And PSY.PRODUCTSUBCODE08 = ITEM.Primary_SUBCODE08 And PSY.PRODUCTSUBCODE09 = ITEM.Primary_SUBCODE09 ' +
	   'AND  PSY.PRODUCTSUBCODE10 = ITEM.Primary_SUBCODE10 '
  end
  else
    ProductSpecializedYarnSQL := '';

  hostSqlStr :=
    'Select ' +
       ColumnNamesSql + ' ITEM.ITEMTYPEAFICOMPANYCODE, ITEM.ITEMTYPEAFICODE,' +
      'ITEM.SUBCODE01, ITEM.SUBCODE02, ITEM.SUBCODE03, ITEM.SUBCODE04, ITEM.SUBCODE05,' +
      'ITEM.SUBCODE06, ITEM.SUBCODE07, ITEM.SUBCODE08, ITEM.SUBCODE09, ITEM.SUBCODE10,' +
      'FIKD.ITEMCODE, P.SECONDARYUNSTEADYCVSFACTOR, FIKD.SEARCHDESCRIPTION, P.SEARCHDESCRIPTION as P_SEARCHDESCRIPTION,' +
      'FIKD.ABSUNIQUEID AS FIKD_ABSUNIQUEID, P.ABSUNIQUEID AS P_ABSUNIQUEID,' +
      'P.PROJECTCONTROLLED P_PROJECTCONTROLLED, P.STATISTICALGROUPCONTROLLED P_STATISTICALGROUPCONTROLLED, ' +
      'P.CUSTOMERCONTROLLED P_CUSTOMERCONTROLLED, P.SUPPLIERCONTROLLED P_SUPPLIERCONTROLLED, ' +
      'IWL.LogicalWarehouseCode, IWL.PROJECTCONTROLLED, IWL.STATISTICALGROUPCONTROLLED, IWL.CUSTOMERCONTROLLED ,IWL.SUPPLIERCONTROLLED ,IPM.PURCHASELEADTIME ' +
    'From ( ' +
      'Select distinct ' +
        'ITEM.COMPANYCODE, ITEM.ITEMTYPEAFICOMPANYCODE, ITEM.ITEMTYPEAFICODE,' +
        'ITEM.SUBCODE01, ITEM.SUBCODE02, ITEM.SUBCODE03, ITEM.SUBCODE04, ITEM.SUBCODE05,' +
        'ITEM.SUBCODE06, ITEM.SUBCODE07, ITEM.SUBCODE08, ITEM.SUBCODE09, ITEM.SUBCODE10,' +
        'case when IT.LASTPRIMARYNR > 1 then ITEM.SUBCODE02 else ' + QuotedStr(' ') + ' end Primary_SUBCODE02,' +
        'case when IT.LASTPRIMARYNR > 2 then ITEM.SUBCODE03 else ' + QuotedStr(' ') + ' end Primary_SUBCODE03,' +
        'case when IT.LASTPRIMARYNR > 3 then ITEM.SUBCODE04 else ' + QuotedStr(' ') + ' end Primary_SUBCODE04,' +
        'case when IT.LASTPRIMARYNR > 4 then ITEM.SUBCODE05 else ' + QuotedStr(' ') + ' end Primary_SUBCODE05,' +
        'case when IT.LASTPRIMARYNR > 5 then ITEM.SUBCODE06 else ' + QuotedStr(' ') + ' end Primary_SUBCODE06,' +
        'case when IT.LASTPRIMARYNR > 6 then ITEM.SUBCODE07 else ' + QuotedStr(' ') + ' end Primary_SUBCODE07,' +
        'case when IT.LASTPRIMARYNR > 7 then ITEM.SUBCODE08 else ' + QuotedStr(' ') + ' end Primary_SUBCODE08,' +
        'case when IT.LASTPRIMARYNR > 8 then ITEM.SUBCODE09 else ' + QuotedStr(' ') + ' end Primary_SUBCODE09,' +
        'case when IT.LASTPRIMARYNR > 9 then ITEM.SUBCODE10 else ' + QuotedStr(' ') + ' end Primary_SUBCODE10 ' +
      'From SchedulesDownloadDemAnds SDD ' +
      'JOIN PRODUCTIONDEMAND ITEM On ITEM.CompanyCode = SDD.CompanyCode And ITEM.CounterCode = SDD.CounterCode And ITEM.Code = SDD.Code ' +
      'Join ITEMTYPE IT On IT.COMPANYCODE = ITEM.ITEMTYPEAFICOMPANYCODE And IT.CODE = ITEM.ITEMTYPEAFICODE ' +
      'WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
      ' Union ' +
      'Select distinct ' +
        'ITEM.COMPANYCODE, ITEM.ITEMTYPEAFICOMPANYCODE, ITEM.ITEMTYPEAFICODE,' +
        'ITEM.SUBCODE01, ITEM.SUBCODE02, ITEM.SUBCODE03, ITEM.SUBCODE04, ITEM.SUBCODE05,' +
        'ITEM.SUBCODE06, ITEM.SUBCODE07, ITEM.SUBCODE08, ITEM.SUBCODE09, ITEM.SUBCODE10,' +
        'case when IT.LASTPRIMARYNR > 1 then ITEM.SUBCODE02 else ' + QuotedStr(' ') + ' end Primary_SUBCODE02,' +
        'case when IT.LASTPRIMARYNR > 2 then ITEM.SUBCODE03 else ' + QuotedStr(' ') + ' end Primary_SUBCODE03,' +
        'case when IT.LASTPRIMARYNR > 3 then ITEM.SUBCODE04 else ' + QuotedStr(' ') + ' end Primary_SUBCODE04,' +
        'case when IT.LASTPRIMARYNR > 4 then ITEM.SUBCODE05 else ' + QuotedStr(' ') + ' end Primary_SUBCODE05,' +
        'case when IT.LASTPRIMARYNR > 5 then ITEM.SUBCODE06 else ' + QuotedStr(' ') + ' end Primary_SUBCODE06,' +
        'case when IT.LASTPRIMARYNR > 6 then ITEM.SUBCODE07 else ' + QuotedStr(' ') + ' end Primary_SUBCODE07,' +
        'case when IT.LASTPRIMARYNR > 7 then ITEM.SUBCODE08 else ' + QuotedStr(' ') + ' end Primary_SUBCODE08,' +
        'case when IT.LASTPRIMARYNR > 8 then ITEM.SUBCODE09 else ' + QuotedStr(' ') + ' end Primary_SUBCODE09,' +
        'case when IT.LASTPRIMARYNR > 9 then ITEM.SUBCODE10 else ' + QuotedStr(' ') + ' end Primary_SUBCODE10 ' +
      'From SchedulesDownloadDemAnds SDD ' +
      'Join PRODUCTIONRESERVATION ITEM On ITEM.COMPANYCODE = SDD.CompanyCode And ITEM.ORDERCOUNTERCODE = SDD.CounterCode And ITEM.ORDERCODE = SDD.Code AND ITEM.RESERVATIONNATURE = ' + QuotedStr('1') + ' ' +
      'Join ITEMTYPE IT On IT.COMPANYCODE = ITEM.ITEMTYPEAFICOMPANYCODE And IT.CODE = ITEM.ITEMTYPEAFICODE ' +
      'WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode);

    hostSqlStr := hostSqlStr + WarpSQL +

    ') ITEM ' +
    'Join PRODUCT P ' +
    'On   P.COMPANYCODE = ITEM.ITEMTYPEAFICOMPANYCODE And P.ITEMTYPECODE = ITEM.ITEMTYPEAFICODE ' +
    'AND  P.SUBCODE01 = ITEM.SUBCODE01 And P.SUBCODE02 = ITEM.Primary_SUBCODE02 And P.SUBCODE03 = ITEM.Primary_SUBCODE03 And P.SUBCODE04 = ITEM.Primary_SUBCODE04 And P.SUBCODE05 = ITEM.Primary_SUBCODE05 ' +
    'AND  P.SUBCODE06 = ITEM.Primary_SUBCODE06 And P.SUBCODE07 = ITEM.Primary_SUBCODE07 And P.SUBCODE08 = ITEM.Primary_SUBCODE08 And P.SUBCODE09 = ITEM.Primary_SUBCODE09 And P.SUBCODE10 = ITEM.Primary_SUBCODE10 ' +
    ProductSpecializedGreigeSQL + ProductSpecializedSizeSQL + ProductSpecializedYarnSQL +
    'Join FULLITEMKEYDECODER FIKD ' +
    'On   FIKD.COMPANYCODE = ITEM.ITEMTYPEAFICOMPANYCODE And FIKD.ITEMTYPECODE = ITEM.ITEMTYPEAFICODE ' +
    'And  FIKD.SUBCODE01 = ITEM.SUBCODE01 And FIKD.SUBCODE02 = ITEM.SUBCODE02 And FIKD.SUBCODE03 = ITEM.SUBCODE03 And FIKD.SUBCODE04 = ITEM.SUBCODE04 And  FIKD.SUBCODE05 = ITEM.SUBCODE05 ' +
    'And  FIKD.SUBCODE06 = ITEM.SUBCODE06 And FIKD.SUBCODE07 = ITEM.SUBCODE07 And  FIKD.SUBCODE08 = ITEM.SUBCODE08 And FIKD.SUBCODE09 = ITEM.SUBCODE09 And FIKD.SUBCODE10 = ITEM.SUBCODE10 ' +
    'left Join ItemWarehouseLink IWL  ' +
    'On   IWL.COMPANYCODE = ITEM.COMPANYCODE ' +
    'And  IWL.ITEMTYPECOMPANYCODE = ITEM.ITEMTYPEAFICOMPANYCODE And IWL.ITEMTYPECODE = ITEM.ITEMTYPEAFICODE ' +
    'And  IWL.SUBCODE01 = ITEM.SUBCODE01 And IWL.SUBCODE02 = ITEM.Primary_SUBCODE02 And IWL.SUBCODE03 = ITEM.Primary_SUBCODE03 And IWL.SUBCODE04 = ITEM.Primary_SUBCODE04 And IWL.SUBCODE05 = ITEM.Primary_SUBCODE05 ' +
    'And  IWL.SUBCODE06 = ITEM.Primary_SUBCODE06 And IWL.SUBCODE07 = ITEM.Primary_SUBCODE07 And IWL.SUBCODE08 = ITEM.Primary_SUBCODE08 And IWL.SUBCODE09 = ITEM.Primary_SUBCODE09 And IWL.SUBCODE10 = ITEM.Primary_SUBCODE10 ' +

    'left Join ITEMREPLENISHMENT IPM  ' +
    'On   IPM.COMPANYCODE = ITEM.ITEMTYPEAFICOMPANYCODE ' +
//    'And  IPM.ITEMTYPECOMPANYCODE = ' + QuotedStr(ItemTypeCompanyInUsed) + ' And IPM.ITEMTYPECODE = ITEM.ITEMTYPEAFICODE ' +
    'And  IPM.ITEMTYPECODE = ITEM.ITEMTYPEAFICODE ' +
    'And  IPM.SUBCODE01 = ITEM.SUBCODE01 And IPM.SUBCODE02 = ITEM.Primary_SUBCODE02 And IPM.SUBCODE03 = ITEM.Primary_SUBCODE03 And IPM.SUBCODE04 = ITEM.Primary_SUBCODE04 And IPM.SUBCODE05 = ITEM.Primary_SUBCODE05 ' +
    'And  IPM.SUBCODE06 = ITEM.Primary_SUBCODE06 And IPM.SUBCODE07 = ITEM.Primary_SUBCODE07 And IPM.SUBCODE08 = ITEM.Primary_SUBCODE08 And IPM.SUBCODE09 = ITEM.Primary_SUBCODE09 And IPM.SUBCODE10 = ITEM.Primary_SUBCODE10 ' +
    'ORDER BY FIKD.ABSUNIQUEID, IWL.LogicalWarehouseCode ';

  HostQry.SQL.Text := hostSqlStr;
  SqlPrint.Add(hostSqlStr);
  SqlPrint.SaveToFile(LocAppGlobals.AppDir + '\Product.txt');
  IniAppGlobals.Time_Fill_PRODUCT_SqlStart := NOW;
  hostQry.Open;
  IniAppGlobals.Time_Fill_PRODUCT_SqlStart := NoW - IniAppGlobals.Time_Fill_PRODUCT_SqlStart;

  UpdateOperation(_('Fill_PRODUCT_Read'));
  Prev_ABSUNIQUEID := '';
  DownloadInfoMsgProductStr.Clear;

  var FIKD_ABSUNIQUEID_FIELD := HostQry.FieldByName('FIKD_ABSUNIQUEID');
  var LogicalWarehouseCode_FILED := HostQry.FieldByName('LogicalWarehouseCode');
  var ITEMTYPEAFICODE_FIELD := HostQry.FieldByName('ITEMTYPEAFICODE');
  var SUBCODE01_FIELD := HostQry.FieldByName('SUBCODE01');
  var SUBCODE02_FIELD := HostQry.FieldByName('SUBCODE02');
  var SUBCODE03_FIELD := HostQry.FieldByName('SUBCODE03');
  var SUBCODE04_FIELD := HostQry.FieldByName('SUBCODE04');
  var SUBCODE05_FIELD := HostQry.FieldByName('SUBCODE05');
  var SUBCODE06_FIELD := HostQry.FieldByName('SUBCODE06');
  var SUBCODE07_FIELD := HostQry.FieldByName('SUBCODE07');
  var SUBCODE08_FIELD := HostQry.FieldByName('SUBCODE08');
  var SUBCODE09_FIELD := HostQry.FieldByName('SUBCODE09');
  var SUBCODE10_FIELD := HostQry.FieldByName('SUBCODE10');
  var P_ABSUNIQUEID_FIELD := HostQry.FieldByName('P_ABSUNIQUEID');
  var SECONDARYUNSTEADYCVSFACTOR_FIELD := HostQry.FieldByName('SECONDARYUNSTEADYCVSFACTOR');
  var SEARCHDESCRIPTION_FIELD := HostQry.FieldByName('SEARCHDESCRIPTION');
  var P_SEARCHDESCRIPTION_FIELD := HostQry.FieldByName('P_SEARCHDESCRIPTION') ;
  var P_PROJECTCONTROLLED_FIELD := HostQry.FieldByName('P_PROJECTCONTROLLED');
  var P_STATISTICALGROUPCONTROLLED_FIELD := HostQry.FieldByName('P_STATISTICALGROUPCONTROLLED');
  var P_CUSTOMERCONTROLLED_FIELD := HostQry.FieldByName('P_CUSTOMERCONTROLLED');
  var P_SUPPLIERCONTROLLED_FIELD := HostQry.FieldByName('P_SUPPLIERCONTROLLED');
  var PURCHASELEADTIME_FIELD := HostQry.FieldByName('PURCHASELEADTIME');
  var PROJECTCONTROLLED_FIELD := HostQry.FieldByName('PROJECTCONTROLLED');
  var STATISTICALGROUPCONTROLLED_FIELD := HostQry.FieldByName('STATISTICALGROUPCONTROLLED');
  var CUSTOMERCONTROLLED_FIELD := HostQry.FieldByName('CUSTOMERCONTROLLED');
  var SUPPLIERCONTROLLED_FIELD := HostQry.FieldByName('SUPPLIERCONTROLLED');

  PSG_COMPANYCODE_FIELD := nil;
  PSS_COMPANYCODE_FIELD := nil;
  PSY_COMPANYCODE_FIELD := nil;
  if ColumnNamesSql <> '' then
  begin
    SetLength(fldProduct, ColumnNamesProduct.Count);
    for I := 0 to ColumnNamesProduct.Count - 1 do
      fldProduct[I] := HostQry.FieldByName(ColumnNamesProduct.Strings[I]);
    SetLength(fldProductSpecializedGreige, ColumnNamesProductSpecializedGreige.Count);
    for I := 0 to ColumnNamesProductSpecializedGreige.Count - 1 do
      fldProductSpecializedGreige[I] := HostQry.FieldByName(ColumnNamesProductSpecializedGreige.Strings[I]);
    SetLength(fldProductSpecializedSize, ColumnNamesProductSpecializedSize.Count);
    for I := 0 to ColumnNamesProductSpecializedSize.Count - 1 do
      fldProductSpecializedSize[I] := HostQry.FieldByName(ColumnNamesProductSpecializedSize.Strings[I]);
    SetLength(fldProductSpecializedYarn, ColumnNamesProductSpecializedYarn.Count);
    for I := 0 to ColumnNamesProductSpecializedYarn.Count - 1 do
      fldProductSpecializedYarn[I] := HostQry.FieldByName(ColumnNamesProductSpecializedYarn.Strings[I]);
    SetLength(fldFullItemKeyDecoder, ColumnNamesFullItemKeyDecoder.Count);
    for I := 0 to ColumnNamesFullItemKeyDecoder.Count - 1 do
      fldFullItemKeyDecoder[I] := HostQry.FieldByName(ColumnNamesFullItemKeyDecoder.Strings[I]);
    if ColumnNamesProductSpecializedGreige.Count > 0 then
      PSG_COMPANYCODE_FIELD := HostQry.FieldByName('PSGCOMPANYCODE');
    if ColumnNamesProductSpecializedSize.Count > 0 then
      PSS_COMPANYCODE_FIELD := HostQry.FieldByName('PSSCOMPANYCODE');
    if ColumnNamesProductSpecializedYarn.Count > 0 then
      PSY_COMPANYCODE_FIELD := HostQry.FieldByName('PSYCOMPANYCODE');
  end;

  while not HostQry.Eof do
  begin
    if Prev_ABSUNIQUEID <> FIKD_ABSUNIQUEID_FIELD.AsString then
    begin
      Prev_ABSUNIQUEID := FIKD_ABSUNIQUEID_FIELD.AsString;

      if LogicalWarehouseCode_FILED.IsNull then
      begin
        InfoDemand := trim(ITEMTYPEAFICODE_FIELD.AsString) + ' ' +
                      trim(SUBCODE01_FIELD.AsString) + ' ' +
                      trim(SUBCODE02_FIELD.AsString) + ' ' +
                      trim(SUBCODE03_FIELD.AsString) + ' ' +
                      trim(SUBCODE04_FIELD.AsString) + ' ' +
                      trim(SUBCODE05_FIELD.AsString) + ' ' +
                      trim(SUBCODE06_FIELD.AsString) + ' ' +
                      trim(SUBCODE07_FIELD.AsString) + ' ' +
                      trim(SUBCODE08_FIELD.AsString) + ' ' +
                      trim(SUBCODE09_FIELD.AsString) + ' ' +
                      trim(SUBCODE10_FIELD.AsString);

        if DownloadInfoMsgProductStr.Count = 0 then
          DownloadInfoMsgProductStr.Add('Missing ItemWarehouseLink for Sub codes :');
        if DownloadInfoMsgProductStr.IndexOf(InfoDemand) = -1 then
           DownloadInfoMsgProductStr.add(InfoDemand);
      end;

      new(Items);

      Items.MAT_STANDARD_SPEED_Warp  := 0;
      Items.MAT_STANDARD_SETMIN_Warp := 0;
      Items.MAT_SCHEDULE_Type_Warp   := '';
      Items.ProductColumn_Created := false;
      Items.ProductSpecializedGreigeColumn_Created := false;
      Items.ProductSpecializedSizeColumn_Created := false;
      Items.ProductSpecializedYarnColumn_Created := false;
      Items.FullItemKeyDecoderColumn_Created := false;

      Items.ABSUNIQUEID    := trim(FIKD_ABSUNIQUEID_FIELD.AsString);
      Items.ABSUNIQUEIDINT := StrToInt64Def(Items.ABSUNIQUEID, 0);
      Items.ABSUNIQUEID_P := TRIM(P_ABSUNIQUEID_FIELD.AsString);
      Items.ITEMTYPEAFICODE := trim(ITEMTYPEAFICODE_FIELD.AsString);
      Items.SECONDARYUNSTEADYCVSFACTOR := Trim(SECONDARYUNSTEADYCVSFACTOR_FIELD.AsString);
      Items.SEARCHDESCRIPTION := trim(SEARCHDESCRIPTION_FIELD.AsString);
      Items.SEARCHDESCRIPTION_P := trim(P_SEARCHDESCRIPTION_FIELD.AsString);
      Items.SUBCODE01 := trim(SUBCODE01_FIELD.AsString);
      Items.SUBCODE02 := trim(SUBCODE02_FIELD.AsString);
      Items.SUBCODE03 := trim(SUBCODE03_FIELD.AsString);
      Items.SUBCODE04 := trim(SUBCODE04_FIELD.AsString);
      Items.SUBCODE05 := trim(SUBCODE05_FIELD.AsString);
      Items.SUBCODE06 := trim(SUBCODE06_FIELD.AsString);
      Items.SUBCODE07 := trim(SUBCODE07_FIELD.AsString);
      Items.SUBCODE08 := trim(SUBCODE08_FIELD.AsString);
      Items.SUBCODE09 := trim(SUBCODE09_FIELD.AsString);
      Items.SUBCODE10 := trim(SUBCODE10_FIELD.AsString);
      Items.ProjectControlled := false;
      Items.StatisticalGroupControlled := false;
      Items.CustomerControlled := false;
      Items.SupplierControlled := false;
      if trim(P_PROJECTCONTROLLED_FIELD.AsString) = '1' then
        Items.ProjectControlled := true;
      if trim(P_STATISTICALGROUPCONTROLLED_FIELD.AsString) = '1' then
        Items.StatisticalGroupControlled := true;
      if trim(P_CUSTOMERCONTROLLED_FIELD.AsString) = '1' then
        Items.CustomerControlled := true;
      if trim(P_SUPPLIERCONTROLLED_FIELD.AsString) = '1' then
        Items.SupplierControlled := true;
      Items.PURCHASELEADTIME := PURCHASELEADTIME_FIELD.AsInteger;
      if (ColumnNamesSql <> '') then
      begin
        Items.ProductColumnNames := TStringList.Create;
        Items.ProductColumnValue := TStringList.Create;
        Items.ProductColumn_Created := true;
        Items.FullItemKeyDecoderColumnNames := TStringList.Create;
        Items.FullItemKeyDecoderColumnValue := TStringList.Create;
        Items.FullItemKeyDecoderColumn_Created := true;

        for I := 0 to ColumnNamesProduct.Count - 1 do
        begin
          Items.ProductColumnNames.Add(ColumnNamesProduct.Strings[I]);
          Items.ProductColumnValue.Add( fldProduct[I].AsString );
        end;

        if (ColumnNamesProductSpecializedGreige.Count > 0)
        and (not PSG_COMPANYCODE_FIELD.IsNull) then
        begin
           Items.ProductSpecializedGreigeColumnNames := TStringList.Create;
           Items.ProductSpecializedGreigeColumnValue := TStringList.Create;
           Items.ProductSpecializedGreigeColumn_Created := true;
           for I := 0 to ColumnNamesProductSpecializedGreige.Count - 1 do
           begin
             Items.ProductSpecializedGreigeColumnNames.Add(ColumnNamesProductSpecializedGreige.Strings[I]);
             Items.ProductSpecializedGreigeColumnValue.Add( fldProductSpecializedGreige[I].AsString );
           end;
        end;

        if (ColumnNamesProductSpecializedSize.Count > 0)
        and (not PSS_COMPANYCODE_FIELD.IsNull) then
        begin
           Items.ProductSpecializedSizeColumnNames := TStringList.Create;
           Items.ProductSpecializedSizeColumnValue := TStringList.Create;
           Items.ProductSpecializedSizeColumn_Created := true;
           for I := 0 to ColumnNamesProductSpecializedSize.Count - 1 do
           begin
             Items.ProductSpecializedSizeColumnNames.Add(ColumnNamesProductSpecializedSize.Strings[I]);
             Items.ProductSpecializedSizeColumnValue.Add( fldProductSpecializedSize[I].AsString );
           end;
        end;

        if (ColumnNamesProductSpecializedYarn.Count > 0)
        and (not PSY_COMPANYCODE_FIELD.IsNull) then
        begin
           Items.ProductSpecializedYarnColumnNames := TStringList.Create;
           Items.ProductSpecializedYarnColumnValue := TStringList.Create;
           Items.ProductSpecializedYarnColumn_Created := true;
           for I := 0 to ColumnNamesProductSpecializedYarn.Count - 1 do
           begin
             Items.ProductSpecializedYarnColumnNames.Add(ColumnNamesProductSpecializedYarn.Strings[I]);
             Items.ProductSpecializedYarnColumnValue.Add( fldProductSpecializedYarn[I].AsString );
           end;
        end;

        for I := 0 to ColumnNamesFullItemKeyDecoder.Count - 1 do
        begin
          Items.FullItemKeyDecoderColumnNames.Add(ColumnNamesFullItemKeyDecoder.Strings[I]);
          Items.FullItemKeyDecoderColumnValue.Add( fldFullItemKeyDecoder[I].AsString );
        end;

      end;

      List_Items.Add(Items);
      Items.ItemWarehouseLink := TList.Create;

    end;

    new(ItemWarehouseLinkRec);
    ItemWarehouseLinkRec.LogicalWarehouseCode := trim(LogicalWarehouseCode_FILED.AsString);
    ItemWarehouseLinkRec.ProjectControlled := false;
    ItemWarehouseLinkRec.StatisticalGroupControlled := false;
    ItemWarehouseLinkRec.CustomerControlled := false;
    ItemWarehouseLinkRec.SupplierControlled := false;
    if trim(PROJECTCONTROLLED_FIELD.AsString) = '1' then
      ItemWarehouseLinkRec.ProjectControlled := true;
    if trim(STATISTICALGROUPCONTROLLED_FIELD.AsString) = '1' then
      ItemWarehouseLinkRec.StatisticalGroupControlled := true;
    if trim(CUSTOMERCONTROLLED_FIELD.AsString) = '1' then
      ItemWarehouseLinkRec.CustomerControlled := true;
    if trim(SUPPLIERCONTROLLED_FIELD.AsString) = '1' then
      ItemWarehouseLinkRec.SupplierControlled := true;
    Items.ItemWarehouseLink.Add(ItemWarehouseLinkRec);

    HostQry.Next;
  end;

  UpdateOperation(_('Fill_Tool_Start'));

  hostSqlStr :=
    'Select T.ABSUNIQUEID, T.SEARCHDESCRIPTION, T.ITEMTYPECODE, T.SUBCODE01, ' +
    'IWL.LogicalWarehouseCode, IWL.PROJECTCONTROLLED, IWL.STATISTICALGROUPCONTROLLED, IWL.CUSTOMERCONTROLLED, IWL.SUPPLIERCONTROLLED ' +
    'From ( ' +
      'Select distinct ITEM.CompanyCode, ITEM.ITEMTYPEAFICODE, ITEM.SUBCODE01 ' +
      'From SchedulesDownloadDemAnds SDD ' +
      'Join PRODUCTIONRESERVATION ITEM On ITEM.COMPANYCODE = SDD.CompanyCode And ITEM.ORDERCOUNTERCODE = SDD.CounterCode And ITEM.ORDERCODE = SDD.Code AND ITEM.RESERVATIONNATURE = ' + QuotedStr('4') + ' ' +
      'WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' and SDD.TemplateCode IN (' + HandledProductionDemandMqinSql + ') ' +
    ') ITEM ' +
    'JOIN TOOL T ' +
    'ON   T.COMPANYCODE = ' + QuotedStr(ToolCompanyInUsed) + ' AND T.ITEMTYPECODE = ITEM.ITEMTYPEAFICODE AND T.SUBCODE01 = ITEM.SUBCODE01 ' +
    'Join ItemWarehouseLink IWL  ' +
    'On   IWL.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' And IWL.ITEMTYPECOMPANYCODE = ' + QuotedStr(ItemTypeCompanyInUsed) + ' ' +
    'And  IWL.LOGICALWAREHOUSECOMPANYCODE = ' + QuotedStr(LogicalWarehouseCompanyInUsed) + ' ' +
    'And  IWL.ITEMTYPECODE = ITEM.ITEMTYPEAFICODE And IWL.SUBCODE01 = ITEM.SUBCODE01 ' +
    'ORDER BY ABSUNIQUEID, IWL.LogicalWarehouseCode ';

  HostQry.SQL.Text := hostSqlStr;

  IniAppGlobals.Time_Fill_Tool_SqlStart := NOW;
  hostQry.Open;
  IniAppGlobals.Time_Fill_Tool_SqlStart := NoW - IniAppGlobals.Time_Fill_Tool_SqlStart;
  UpdateOperation(_('Fill_Tool_Read'));
  Prev_ABSUNIQUEID := '';

  var ABSUNIQUEID_FIELD := HostQry.FieldByName('ABSUNIQUEID');
  var SEARCHDESCRIPTION1_FIELD := HostQry.FieldByName('SEARCHDESCRIPTION');
  var SUBCODE01_FIELD1 := HostQry.FieldByName('SUBCODE01');
  var ITEMTYPECODE_FIELD := HostQry.FieldByName('ITEMTYPECODE');
  var PROJECTCONTROLLED_FIELD1 := HostQry.FieldByName('PROJECTCONTROLLED');
  var STATISTICALGROUPCONTROLLED_FIELD1 := HostQry.FieldByName('STATISTICALGROUPCONTROLLED');
  var CUSTOMERCONTROLLED_FIELD1 := HostQry.FieldByName('CUSTOMERCONTROLLED');
  var SUPPLIERCONTROLLED_FIELD1 := HostQry.FieldByName('SUPPLIERCONTROLLED');

  while not HostQry.Eof do
  begin
    if Trim(ABSUNIQUEID_FIELD.AsString) = '' then
    begin
      HostQry.Next;
      continue
    end;

    if Prev_ABSUNIQUEID <> trim(ABSUNIQUEID_FIELD.AsString) then
    begin
      new(Items);
      Items.MAT_STANDARD_SPEED_Warp  := 0;
      Items.MAT_STANDARD_SETMIN_Warp := 0;
      Items.MAT_SCHEDULE_Type_Warp        := '';
      Items.productColumn_Created := false;
      Items.ProductSpecializedGreigeColumn_Created := false;
      Items.ProductSpecializedSizeColumn_Created := false;
      Items.ProductSpecializedYarnColumn_Created := false;
      Items.FullItemKeyDecoderColumn_Created := false;
      Items.PURCHASELEADTIME := 0;
      Items.ABSUNIQUEID       := trim(ABSUNIQUEID_FIELD.AsString);
      Items.ABSUNIQUEIDINT    := StrToInt64Def(Items.ABSUNIQUEID, 0);
      Items.SEARCHDESCRIPTION_T := trim(SEARCHDESCRIPTION1_FIELD.AsString);
      Items.SUBCODE01         := trim(SUBCODE01_FIELD1.AsString);
      Items.ITEMTYPECODE_T    := trim(ITEMTYPECODE_FIELD.AsString);
      List_Items.Add(Items);
      Items.ItemWarehouseLink := TList.Create;
    end;

    new(ItemWarehouseLinkRec);
    ItemWarehouseLinkRec.ProjectControlled := false;
    ItemWarehouseLinkRec.StatisticalGroupControlled := false;
    ItemWarehouseLinkRec.CustomerControlled := false;
    ItemWarehouseLinkRec.SupplierControlled := false;
    if trim(PROJECTCONTROLLED_FIELD1.AsString) = '1' then
      ItemWarehouseLinkRec.ProjectControlled := true;
    if trim(STATISTICALGROUPCONTROLLED_FIELD1.AsString) = '1' then
      ItemWarehouseLinkRec.StatisticalGroupControlled := true;
    if trim(CUSTOMERCONTROLLED_FIELD1.AsString) = '1' then
      ItemWarehouseLinkRec.CustomerControlled := true;
    if trim(SUPPLIERCONTROLLED_FIELD1.AsString) = '1' then
      ItemWarehouseLinkRec.SupplierControlled := true;
    Items.ItemWarehouseLink.Add(ItemWarehouseLinkRec);

    HostQry.Next;
  end;

  List_Items.sort(SortItems);
  SqlPrint.Free;
  ColumnNamesProduct.Free;
  ColumnNamesProductSpecializedGreige.Free;
  ColumnNamesProductSpecializedSize.Free;
  ColumnNamesProductSpecializedYarn.Free;
  ColumnNamesFullItemKeyDecoder.Free;

end;

//----------------------------------------------------------------------------//

procedure Fill_Generic(ArcQry : TMqmQuery; HostQry: TMqmQuery; List_Generic, List_TNA : TList; HandledProductionDemandMqinSql, TNA_code_list1, TNA_code_list2 : string);
type
 TDemandsLinks = record
   DemandCounterCode, DemandCode, ABSUniqueId, CounterCode, Code, Line, SubLine, ComponentLine, DeliveryLine : String;
 end;
 PTDemandsLinks = ^TDemandsLinks;
var
  srvSqlStr, hostSqlStr, ColumnNamesSql, hostSqlStrTNA, tblname : string;
  ColumnNamesProduction : TStringList;
  columnName, tableName, tableNameSql, tablePrefix, TempcolumnName : string;
  RecipeCompanyInUsed, DesignCompanyInUsed, OrderPartnerCompanyInUsed, PrevProjectCode, PrevCounterCode, PrevCode : string;
  ABSUniqueId, CounterCode, Code, Line, SubLine, ComponentLine, DeliveryLine : String;
  I, CurrentIndex, J, K, LastABSID : Integer;
  Generic : PRGeneric;
  TNA : PT_TNA;
  TNA_Fields : PT_TNA_FIELDS;
  ADExists, SalesByProjectIsNeeded, First, DemandChanged, LineFoundForDemand, PointerFound, CodeAlreadyFound, HasTNA, OrderPartnerColumnTaken : boolean;
  TmpOrgCounter, TmpOrgCode, TmpLinkedCounter, TmpLinkedCode, TmpFoundCounter, TmpFoundCode : TStringList;
  GenericProjectSalesPointer : PRGeneric;
  DemandsLinksList : TList;
  PDemandsLinks : PTDemandsLinks;
  OrderDate, DemandDate : Tdate;
  DndArchiveArcName : TDndArchiveName;
  CodeList, BusinessPartnerAttributes, OrderPartners : TStringList;
  COLUMN_NAME_FIELD, ORDPRNCUSTOMERSUPPLIERCODE_FIELD : Tfield;
  InStatement, Comma : String; 
begin
  SalesByProjectIsNeeded := false;
  DndArchiveArcName := GetDndArchiveLocalName;
  UpdateOperation(_('Fill_RECIPE'));
  tableNameSql := 'PROPERTY_RTV_VALUE';
    if DndArchiveArcName <> TD_Interbase then
  tableNameSql  := 'SCDA_' + 'PROPERTY_RTV_VALUE';

  if not GetCompanyLevelHandlingByEntityName('RECIPE',  RecipeCompanyInUsed) then
     RecipeCompanyInUsed := IniAppGlobals.CompanyCode;

  ColumnNamesSql := '';
  srvSqlStr := 'SELECT TABLE_NAME,COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('RECIPE') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
//  ColumnNamesProduction.Free;
  ColumnNamesProduction := TSTringList.create;
  tablePrefix := 'R';

  var TABLE_NAME_FIELD := ArcQry.FieldByName('TABLE_NAME');
  COLUMN_NAME_FIELD := ArcQry.FieldByName('COLUMN_NAME');

  while (not ArcQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD.AsString);
    if ( ColumnNamesProduction.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
    begin
      TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
      ColumnNamesProduction.Add(TempcolumnName);
      ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName + ' AS ' + TempcolumnName;
      ColumnNamesSql := ColumnNamesSql + ', ';
    end;
    ArcQry.Next;
  end;
  ArcQry.Active := false;

  hostSqlStr := 'Select ' + ColumnNamesSql + 'R.ABSUNIQUEID FROM ' +
    '(SELECT DISTINCT ' +
      'PRSV.ITEMTYPEAFICODE,PRSV.SUBCODE01,PRSV.SUBCODE02,PRSV.SUBCODE03,PRSV.SUBCODE04,PRSV.SUBCODE05,'+
      'PRSV.SUBCODE06,PRSV.SUBCODE07,PRSV.SUBCODE08,PRSV.SUBCODE09,PRSV.SUBCODE10,PRSV.SUFFIXCODE ' +
     'FROM ' +
       '(SELECT CompanyCode, CounterCode, Code FROM SchedulesDownloadDemands WHERE ' +
          'COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and ' +
          'EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' and ' +
          'TemplateCode IN (' + HandledProductionDemandMqinSql + ')) SDD ' +
     'JOIN PRODUCTIONRESERVATION PRSV ' +
     'ON PRSV.CompanyCode = SDD.CompanyCode AND PRSV.OrderCounterCode = SDD.CounterCode ' +
     'AND PRSV.OrderCode = SDD.Code AND PRSV.ITEMNATURE = ' + QuotedStr('9') + ') PRSV ' +
  'JOIN RECIPE R ' +
  'ON R.COMPANYCODE = ' + QuotedStr(RecipeCompanyInUsed) + ' AND R.ITEMTYPECODE = PRSV.ITEMTYPEAFICODE AND ' +
  'R.SUBCODE01 = PRSV.SUBCODE01 AND R.SUBCODE02 = PRSV.SUBCODE02 AND R.SUBCODE03 = PRSV.SUBCODE03 AND ' +
  'R.SUBCODE04 = PRSV.SUBCODE04 AND R.SUBCODE05 = PRSV.SUBCODE05 AND R.SUBCODE06 = PRSV.SUBCODE06 AND ' +
  'R.SUBCODE07 = PRSV.SUBCODE07 AND R.SUBCODE08 = PRSV.SUBCODE08 AND R.SUBCODE09 = PRSV.SUBCODE09 AND ' +
  'R.SUBCODE10 = PRSV.SUBCODE10 AND R.SUFFIXCODE = PRSV.SUFFIXCODE ';

  if (ColumnNamesSql <> '') then
  begin
    HostQry.SQL.Text := hostSqlStr;
    HostQry.FetchOptions.RowsetSize := 5000;
    hostQry.Open;

    var ABSUNIQUEID_FIELD := HostQry.FieldByName('ABSUNIQUEID');
    var dynRecipeFields: TArray<TField>;
    SetLength(dynRecipeFields, ColumnNamesProduction.Count);
    for I := 0 to ColumnNamesProduction.Count - 1 do
      dynRecipeFields[I] := HostQry.Fields.FieldByName(ColumnNamesProduction.Strings[I]);

    while not HostQry.Eof do
    begin
      new(Generic);
      Generic.Entity := 'Recipe';
      Generic.NumberOfKeys := 1;
      Generic.Key1 := ABSUNIQUEID_FIELD.AsFloat;
      Generic.ABSUniqueId := trim(ABSUNIQUEID_FIELD.AsString);
      Generic.ColumnNames := TStringList.Create;
      Generic.ColumnValue := TStringList.Create;
      for I := 0 to ColumnNamesProduction.Count - 1 do
      begin
        Generic.ColumnNames.Add(ColumnNamesProduction.Strings[I]);
        Generic.ColumnValue.Add(dynRecipeFields[I].AsString);
      end;
      List_Generic.Add(Generic);
      HostQry.Next;
    end;
  end;

  UpdateOperation(_('Fill_DESIGN'));

  if not GetCompanyLevelHandlingByEntityName('DESIGN',  DesignCompanyInUsed) then
     DesignCompanyInUsed := IniAppGlobals.CompanyCode;

  ColumnNamesSql := '';
  srvSqlStr := 'SELECT TABLE_NAME,COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('DESIGN') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
 // ColumnNamesProduction.Free;
  ColumnNamesProduction.clear;
  tablePrefix := 'D';

  var COLUMN_NAME_FIELD1 := ArcQry.FieldByName('COLUMN_NAME');

  while (not ArcQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD1.AsString);
    if ( ColumnNamesProduction.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
    begin
      TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
      ColumnNamesProduction.Add(TempcolumnName);
      ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName + ' AS ' + TempcolumnName;
      ColumnNamesSql := ColumnNamesSql + ', ';
    end;
    ArcQry.Next;
  end;
  ArcQry.Active := false;

  hostSqlStr := ' Select ' + ColumnNamesSql + 'D.ABSUNIQUEID FROM ' +
    '(SELECT DISTINCT ' +
      'PRSV.ITEMTYPEAFICODE,PRSV.SUBCODE01,PRSV.SUBCODE02,PRSV.SUBCODE03,PRSV.SUBCODE04,PRSV.SUBCODE05,'+
      'PRSV.SUBCODE06,PRSV.SUBCODE07,PRSV.SUBCODE08,PRSV.SUBCODE09,PRSV.SUBCODE10,PRSV.SUFFIXCODE ' +
     'FROM ' +
       '(SELECT CompanyCode, CounterCode, Code FROM SchedulesDownloadDemands WHERE ' +
          'COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and ' +
          'EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' and ' +
          'TemplateCode IN (' + HandledProductionDemandMqinSql + ')) SDD ' +
     'JOIN PRODUCTIONRESERVATION PRSV ' +
     'ON PRSV.CompanyCode = SDD.CompanyCode AND PRSV.OrderCounterCode = SDD.CounterCode ' +
     'AND PRSV.OrderCode = SDD.Code AND PRSV.ITEMNATURE = ' + QuotedStr('A') + ') PRSV ' +
  'JOIN DESIGN D ' +
  'ON D.COMPANYCODE = ' + QuotedStr(RecipeCompanyInUsed) + ' AND D.ITEMTYPECODE = PRSV.ITEMTYPEAFICODE AND ' +
  'D.SUBCODE01 = PRSV.SUBCODE01 AND D.SUBCODE02 = PRSV.SUBCODE02 AND D.SUBCODE03 = PRSV.SUBCODE03 AND ' +
  'D.SUBCODE04 = PRSV.SUBCODE04 AND D.SUBCODE05 = PRSV.SUBCODE05 AND D.SUBCODE06 = PRSV.SUBCODE06 AND ' +
  'D.SUBCODE07 = PRSV.SUBCODE07 AND D.SUBCODE08 = PRSV.SUBCODE08 AND D.SUBCODE09 = PRSV.SUBCODE09 AND ' +
  'D.SUBCODE10 = PRSV.SUBCODE10 AND D.SUFFIXCODE = PRSV.SUFFIXCODE ';

  if (ColumnNamesSql <> '') then
  begin
    HostQry.SQL.Text := hostSqlStr;
    HostQry.FetchOptions.RowsetSize := 5000;
    hostQry.Open;

    var ABSUNIQUEID_FIELD1 := HostQry.FieldByName('ABSUNIQUEID');
    var dynDesignFields: TArray<TField>;
    SetLength(dynDesignFields, ColumnNamesProduction.Count);
    for I := 0 to ColumnNamesProduction.Count - 1 do
      dynDesignFields[I] := HostQry.Fields.FieldByName(ColumnNamesProduction.Strings[I]);

    while not HostQry.Eof do
    begin
      new(Generic);
      Generic.Entity := 'Design';
      Generic.NumberOfKeys := 1;
      Generic.Key1 := ABSUNIQUEID_FIELD1.AsFloat;
      Generic.ABSUniqueId := trim(ABSUNIQUEID_FIELD1.AsString);
      Generic.ColumnNames := TStringList.Create;
      Generic.ColumnValue := TStringList.Create;
      for I := 0 to ColumnNamesProduction.Count - 1 do
      begin
        Generic.ColumnNames.Add(ColumnNamesProduction.Strings[I]);
        Generic.ColumnValue.Add(dynDesignFields[I].AsString);
      end;
      List_Generic.Add(Generic);
      HostQry.Next;
    end;
  end;

  UpdateOperation(_('Fill_SALES_ORDER'));

  ADExists := false;
  srvSqlStr := 'SELECT TABLE_NAME,COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('SalesOrder AD') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  if not ArcQry.Eof then ADExists := true;
  ArcQry.Active := false;

  ColumnNamesSql := '';
  srvSqlStr := 'SELECT TABLE_NAME,COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('SALESORDER') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
//  ColumnNamesProduction.Free;
  ColumnNamesProduction.Create;
  tablePrefix := 'SO';

  var COLUMN_NAME_FIELD2 := ArcQry.FieldByName('COLUMN_NAME');

  OrderPartnerColumnTaken := false; 
  while (not ArcQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD2.AsString);
    if ( ColumnNamesProduction.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
    begin
      TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
      ColumnNamesProduction.Add(TempcolumnName);
      ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName + ' AS ' + TempcolumnName;
      ColumnNamesSql := ColumnNamesSql + ', ';
      if TempcolumnName = 'ORDPRNCUSTOMERSUPPLIERCODE' then
        OrderPartnerColumnTaken := true;	  
    end;
    ArcQry.Next;
  end;
  ArcQry.Active := false;
  
  // If the customer code was not requested and any attribute from business partner was requested, we need to force bringing the customer code.
  BusinessPartnerAttributes := TStringList.Create;
  srvSqlStr := 'SELECT COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('BUSINESSPARTNER') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  COLUMN_NAME_FIELD := ArcQry.FieldByName('COLUMN_NAME');
  while (not ArcQry.Eof ) do
  begin
    if not OrderPartnerColumnTaken then
    begin
      OrderPartnerColumnTaken := true;
      TempcolumnName := (tablePrefix + '_' + 'ORDPRNCUSTOMERSUPPLIERCODE');
      ColumnNamesProduction.Add(TempcolumnName);
      ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + 'ORDPRNCUSTOMERSUPPLIERCODE' + ' AS ' + TempcolumnName;
      ColumnNamesSql := ColumnNamesSql + ', ';
    end;
    columnName := Trim(COLUMN_NAME_FIELD.AsString);
    BusinessPartnerAttributes.Add(columnName);
    ArcQry.Next;
  end;  

  tblname  := 'ACTIVITY';
  if DndArchiveArcName <> TD_Interbase then
    tblName := 'SCDA_' + tblName;

  //list of activity
  CodeList := TStringList.Create;


   ArcQry.SQL.Text := 'Select AC_CODE from ' + tblname  +
    ' where AC_ACTIVITYAFFECTSAPPROVALDATE = ' + QuotedStr('1') + ' and AC_IDENTIFIER = ' + IniAppGlobals.Identifier;
   ArcQry.Active := true;
   var fldCL_AcCode := ArcQry.FieldByName('AC_CODE');

   while not ArcQry.Eof do
   begin
     CodeList.Add(fldCL_AcCode.AsString);
     ArcQry.Next;
   end;
   ArcQry.Active := false;

   HasTNA := False;
   if TNA_code_list1 <> '' then
   begin
     hostSqlStrTNA := 'SELECT TNAAD.TNAACTIVITYUNIQUEID, TNAAD.TNAACTIVITYTNAHEADERCODE HEADERCODE' +
      ', TNAAD.ACTIVITYCODECODE ACTIVITYCODE, TNAAD.SEQNO SEQUENCENUMBER, TNAAD.STARTDATE, TNAAD.ENDDATE' +
      ' FROM ' +
        ' (SELECT DISTINCT PD.COMPANYCODE, PD.ORIGDLVSALORDLINESALORDCNTCOD COUNTERCODE, PD.ORIGDLVSALORDLINESALORDERCODE CODE'+
        ' FROM SCHEDULESDOWNLOADDEMANDS SDD'+
        ' JOIN PRODUCTIONDEMAND PD ON PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE'+
        ' WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) +
        ' AND SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
        ' AND SDD.TEMPLATECODE IN (' + TNA_code_list1 + ')'+
      ' UNION'+
        ' SELECT DISTINCT PD.COMPANYCODE, SOD.SALORDLINESALORDERCOUNTERCODE COUNTERCODE, SOD.SALESORDERLINESALESORDERCODE CODE' +
        ' FROM SCHEDULESDOWNLOADDEMANDS SDD'+
        ' JOIN PRODUCTIONDEMAND PD ON PD.COMPANYCODE = SDD.COMPANYCODE AND  PD.COUNTERCODE = SDD.COUNTERCODE AND  PD.CODE = SDD.CODE'+
        ' JOIN SALESORDERDELIVERY SOD ON SOD.SALORDLINESALORDERCOMPANYCODE = SDD.COMPANYCODE AND SOD.PROJECTCODE = PD.PROJECTCODE'+
        ' WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) +
        ' AND SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
        ' AND SDD.TEMPLATECODE IN (' + TNA_code_list1 + ')) PD' +
      ' JOIN SALESORDER SO ON  SO.COMPANYCODE = PD.COMPANYCODE AND SO.COUNTERCODE = PD.COUNTERCODE AND SO.CODE = PD.CODE'+
      ' JOIN TNAACTIVITYDETAIL TNAAD ON TNAAD.TNAACTIVITYUNIQUEID = SO.ABSUNIQUEID'+
      ' ORDER BY TNAAD.TNAACTIVITYUNIQUEID, TNAAD.TNAACTIVITYTNAHEADERCODE, TNAAD.ACTIVITYCODECODE, TNAAD.SEQNO';

     HostQry.Close;
     HostQry.SQL.Text := hostSqlStrTNA;
     HostQry.FetchOptions.RowsetSize := 5000;
     hostQry.Open;
     var fldTNA_UniqueId     := HostQry.FieldByName('TNAACTIVITYUNIQUEID');
     var fldTNA_ActivityCode := HostQry.FieldByName('ACTIVITYCODE');
     var fldTNA_EndDate      := HostQry.FieldByName('ENDDATE');
     var fldTNA_HeaderCode   := HostQry.FieldByName('HEADERCODE');
     var fldTNA_SeqNum       := HostQry.FieldByName('SEQUENCENUMBER');
     var fldTNA_StartDate    := HostQry.FieldByName('STARTDATE');

     while not HostQry.Eof do
     begin
       if (not HasTNA) or (LastABSID <> fldTNA_UniqueId.AsInteger) then
       begin
         if HasTNA then
           List_TNA.Add(TNA);
         HasTNA := True;
         LastABSID := fldTNA_UniqueId.AsInteger;
         New(TNA);
         TNA.Entity := 'SalesOrder';
         TNA.ABSUniqueId := fldTNA_UniqueId.AsString;
         TNA.ApprovalDate := 0;
         TNA.TNA_List := TList.Create;
       end;

       if (CodeList.Indexof(fldTNA_ActivityCode.AsString) > -1)
         and (TNA.ApprovalDate < fldTNA_EndDate.AsDateTime) then
            TNA.ApprovalDate := fldTNA_EndDate.AsDateTime;

       New(TNA_Fields);
       TNA_Fields.HEADERCODE   := fldTNA_HeaderCode.AsString;
       TNA_Fields.ACTIVITYCODE := fldTNA_ActivityCode.AsString;
       TNA_Fields.SEQUENCENUMBER := fldTNA_SeqNum.AsInteger;
       TNA_Fields.STARTDATE      := fldTNA_StartDate.AsDateTime;
       TNA_Fields.ENDDATE        := fldTNA_EndDate.AsDateTime;
       TNA.TNA_List.Add(TNA_Fields);
       HostQry.Next;
     end;

     if HasTNA then
       List_TNA.Add(TNA);
   end;

     hostSqlStr := 'SELECT ' + ColumnNamesSql +'SO.COUNTERCODE, SO.CODE, SO.ABSUNIQUEID FROM ' +
       ' (SELECT DISTINCT PD.ORIGDLVSALORDLINESALORDCNTCOD COUNTERCODE, PD.ORIGDLVSALORDLINESALORDERCODE CODE ' +
       ' FROM SCHEDULESDOWNLOADDEMANDS SDD ' +
      'JOIN PRODUCTIONDEMAND PD ' +
      'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
      'WHERE ' +
      'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
      'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
      'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ') ' +
      'UNION ' +
      'SELECT DISTINCT SOD.SALORDLINESALORDERCOUNTERCODE COUNTERCODE, SOD.SALESORDERLINESALESORDERCODE CODE ' +
      'FROM ' +
      'SCHEDULESDOWNLOADDEMANDS SDD ' +
      'JOIN PRODUCTIONDEMAND PD ' +
      'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
      'JOIN SALESORDERDELIVERY SOD ' +
      'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'AND SOD.PROJECTCODE = PD.PROJECTCODE ' +
      'WHERE ' +
      'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
      'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
      'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ')) PD ' +
      'JOIN SALESORDER SO ' +
      'ON  SO.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'AND SO.COUNTERCODE = PD.COUNTERCODE ' +
      'AND SO.CODE = PD.CODE ';

     OrderPartners := TStringList.Create;
     OrderPartners.Sorted := true;
     if (ColumnNamesSql <> '') or ADExists or HasTNA then
     begin
       SalesByProjectIsNeeded := true;
       HostQry.SQL.Text := hostSqlStr;
       HostQry.FetchOptions.RowsetSize := 5000;
       hostQry.Open;

         var COUNTERCODE_FIELD := HostQry.FieldByName('COUNTERCODE');
         var CODE_FIELD := HostQry.FieldByName('CODE');
         var ABSUNIQUEID_FIELD2 := HostQry.FieldByName('ABSUNIQUEID');
         if BusinessPartnerAttributes.Count > 0 then
           ORDPRNCUSTOMERSUPPLIERCODE_FIELD := HostQry.FieldByName('SO_ORDPRNCUSTOMERSUPPLIERCODE');		 

       while not HostQry.Eof do
       begin
         new(Generic);
         Generic.Entity := 'SalesOrder';
         Generic.NumberOfKeys := 2;
         Generic.Key1 := TRIM(COUNTERCODE_FIELD.AsString);
         Generic.Key2 := Trim(CODE_FIELD.AsString);
         Generic.ABSUniqueId := trim(ABSUNIQUEID_FIELD2.AsString);
         if (BusinessPartnerAttributes.Count > 0) and (OrderPartners.IndexOf(TRIM(ORDPRNCUSTOMERSUPPLIERCODE_FIELD.AsString)) = -1)  then
           OrderPartners.Add(TRIM(ORDPRNCUSTOMERSUPPLIERCODE_FIELD.AsString));		 
         Generic.ColumnNames := TStringList.Create;
         Generic.ColumnValue := TStringList.Create;
         for I := 0 to ColumnNamesProduction.Count - 1 do
         begin
           Generic.ColumnNames.Add(ColumnNamesProduction.Strings[I]);
           Generic.ColumnValue.Add( HostQry.Fields.FieldByName(ColumnNamesProduction.Strings[I]).AsString );
         end;
         List_Generic.Add(Generic);
         HostQry.Next;
       end;
     end;

   //end;

  if OrderPartners.Count > 0 then
  begin
    if not GetCompanyLevelHandlingByEntityName('ORDERPARTNER',  OrderPartnerCompanyInUsed) then
      OrderPartnerCompanyInUsed := IniAppGlobals.CompanyCode;
    ColumnNamesSql := 'OP.CUSTOMERSUPPLIERCODE';
    for I := 0 to BusinessPartnerAttributes.Count - 1 do
      ColumnNamesSql := ColumnNamesSql + ', BP.' + BusinessPartnerAttributes.Strings[I];
    J := 0;
    Comma := '';
    InStatement := '';
    for I := 0 to OrderPartners.Count - 1 do
    begin
      inc(j);
      InStatement := InStatement + Comma + QuotedStr(OrderPartners.Strings[I]);
      Comma := ',';
      if (J = 999) or (I = OrderPartners.Count - 1) then
      begin
        hostSqlStr :=
          'SELECT ' + ColumnNamesSql + ' FROM orderpartner op ' +
          'join BUSINESSPARTNER BP on bp.numberid = op.ORDERBUSINESSPARTNERNUMBERID ' +
          'where ' +
          'CUSTOMERSUPPLIERCOMPANYCODE = ' + QuotedStr(OrderPartnerCompanyInUsed) + ' ' +
          'and CUSTOMERSUPPLIERTYPE = ' + QuotedStr('1') + ' ' +
          'and CUSTOMERSUPPLIERCODE in (' + InStatement + ') ';
        HostQry.SQL.Text := hostSqlStr;
        hostQry.Open;
        if not HostQry.Eof then
          ORDPRNCUSTOMERSUPPLIERCODE_FIELD := HostQry.FieldByName('CUSTOMERSUPPLIERCODE');
        while not HostQry.Eof do
        begin
          new(Generic);
          Generic.Entity := 'BusinessPartner';
          Generic.NumberOfKeys := 1;
          Generic.Key1 := TRIM(ORDPRNCUSTOMERSUPPLIERCODE_FIELD.AsString);
          Generic.ABSUniqueId := '';
          Generic.ColumnNames := TStringList.Create;
          Generic.ColumnValue := TStringList.Create;
          for K := 0 to BusinessPartnerAttributes.Count - 1 do
          begin
            Generic.ColumnNames.Add(BusinessPartnerAttributes.Strings[K]);
            Generic.ColumnValue.Add(HostQry.Fields.FieldByName(BusinessPartnerAttributes.Strings[K]).AsString);
          end;
          List_Generic.Add(Generic);
          HostQry.Next;
        end;
        J := 0;
        Comma := '';
        InStatement := '';
      end;
    end;
  end;

  BusinessPartnerAttributes.Free;
  OrderPartners.Free;

  UpdateOperation(_('Fill_SALES_ORDER_LINE'));

  ADExists := false;
  srvSqlStr := 'SELECT TABLE_NAME,COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('SalesOrderLine AD') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  if not ArcQry.Eof then ADExists := true;
  ArcQry.Active := false;

  ColumnNamesSql := '';
  srvSqlStr := 'SELECT TABLE_NAME,COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('SALESORDERLINE') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
//  ColumnNamesProduction.Free;
  ColumnNamesProduction.Clear;
  tablePrefix := 'SOL';

  var COLUMN_NAME_FIELD3 := ArcQry.FieldByName('COLUMN_NAME');

  while (not ArcQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD3.AsString);
    if ( ColumnNamesProduction.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
    begin
      TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
      ColumnNamesProduction.Add(TempcolumnName);
      ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName + ' AS ' + TempcolumnName;
      ColumnNamesSql := ColumnNamesSql + ', ';
    end;
    ArcQry.Next;
  end;
  ArcQry.Active := false;

/////////

   HasTNA := False;
   if TNA_code_list2 <> '' then
   begin
     hostSqlStrTNA := 'SELECT TNAAD.TNAACTIVITYUNIQUEID, TNAAD.TNAACTIVITYTNAHEADERCODE HEADERCODE' +
      ', TNAAD.ACTIVITYCODECODE ACTIVITYCODE, TNAAD.SEQNO SEQUENCENUMBER, TNAAD.STARTDATE, TNAAD.ENDDATE' +
      ' FROM ' +
      '(SELECT DISTINCT PD.ORIGDLVSALORDLINESALORDCNTCOD COUNTERCODE, PD.ORIGDLVSALORDLINESALORDERCODE CODE, PD.ORIGDLVSALORDERLINEORDERLINE LINE, ' +
                    'PD.ORIGDLVSALORDLINEORDERSUBLINE SUBLINE, PD.ORIGDLVSALORDLINECMPORDERLINE COMPONENTLINE ' +
     'FROM ' +
     'SCHEDULESDOWNLOADDEMANDS SDD ' +
     'JOIN PRODUCTIONDEMAND PD ' +
     'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
     'WHERE ' +
     'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
     'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
     'SDD.TEMPLATECODE IN (' + TNA_code_list2 + ') ' +
     'UNION ' +
     'SELECT DISTINCT SOD.SALORDLINESALORDERCOUNTERCODE COUNTERCODE, SOD.SALESORDERLINESALESORDERCODE CODE, SOD.SALESORDERLINEORDERLINE LINE, ' +
                     'SOD.SALESORDERLINEORDERSUBLINE SUBLINE, SOD.SALORDLINECOMPONENTORDERLINE COMPONENTLINE ' +
     'FROM ' +
     'SCHEDULESDOWNLOADDEMANDS SDD ' +
     'JOIN PRODUCTIONDEMAND PD ' +
     'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
     'JOIN SALESORDERDELIVERY SOD ' +
     'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
     'AND SOD.PROJECTCODE = PD.PROJECTCODE ' +
     'WHERE ' +
     'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
     'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
     'SDD.TEMPLATECODE IN (' + TNA_code_list2 + ')) PD ' +
     'JOIN SALESORDERLINE SOL ' +
     'ON  SOL.SALESORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
     'AND SOL.SALESORDERCOUNTERCODE = PD.COUNTERCODE ' +
     'AND SOL.SALESORDERCODE = PD.CODE ' +
     'AND SOL.ORDERLINE = PD.LINE ' +
     'AND SOL.ORDERSUBLINE = PD.SUBLINE ' +
     'AND SOL.COMPONENTORDERLINE = PD.COMPONENTLINE' +

     ' JOIN TNAACTIVITYDETAIL TNAAD ON TNAAD.TNAACTIVITYUNIQUEID = SOL.ABSUNIQUEID' +
     ' ORDER BY TNAAD.TNAACTIVITYUNIQUEID, TNAAD.TNAACTIVITYTNAHEADERCODE, TNAAD.ACTIVITYCODECODE, TNAAD.SEQNO';

     HostQry.Close;
     HostQry.SQL.Text := hostSqlStrTNA;
     HostQry.FetchOptions.RowsetSize := 5000;
     hostQry.Open;
     var fldTNA2_UniqueId     := HostQry.FieldByName('TNAACTIVITYUNIQUEID');
     var fldTNA2_ActivityCode := HostQry.FieldByName('ACTIVITYCODE');
     var fldTNA2_EndDate      := HostQry.FieldByName('ENDDATE');
     var fldTNA2_HeaderCode   := HostQry.FieldByName('HEADERCODE');
     var fldTNA2_SeqNum       := HostQry.FieldByName('SEQUENCENUMBER');
     var fldTNA2_StartDate    := HostQry.FieldByName('STARTDATE');

     while not HostQry.Eof do
     begin
       if (not HasTNA) or (LastABSID <> fldTNA2_UniqueId.AsInteger) then
       begin
         if HasTNA then
           List_TNA.Add(TNA);
         HasTNA := True;
         LastABSID := fldTNA2_UniqueId.AsInteger;
         New(TNA);
         TNA.Entity := 'SalesOrderLine';
         TNA.ABSUniqueId := fldTNA2_UniqueId.AsString;
         TNA.ApprovalDate := 0;
         TNA.TNA_List := TList.Create;
       end;

       if (CodeList.Indexof(fldTNA2_ActivityCode.AsString) > -1)
         and (TNA.ApprovalDate < fldTNA2_EndDate.AsDateTime) then
            TNA.ApprovalDate := fldTNA2_EndDate.AsDateTime;

       New(TNA_Fields);
       TNA_Fields.HEADERCODE   := fldTNA2_HeaderCode.AsString;
       TNA_Fields.ACTIVITYCODE := fldTNA2_ActivityCode.AsString;
       TNA_Fields.SEQUENCENUMBER := fldTNA2_SeqNum.AsInteger;
       TNA_Fields.STARTDATE      := fldTNA2_StartDate.AsDateTime;
       TNA_Fields.ENDDATE        := fldTNA2_EndDate.AsDateTime;
       TNA.TNA_List.Add(TNA_Fields);
       HostQry.Next;
     end;

     if HasTNA then
       List_TNA.Add(TNA);

   end;

////////////

  hostSqlStr := ' ' +
  'SELECT ' + ColumnNamesSql +
      'SOL.SALESORDERCOUNTERCODE, SOL.SALESORDERCODE, SOL.ORDERLINE, SOL.ORDERSUBLINE, SOL.COMPONENTORDERLINE, SOL.ABSUNIQUEID FROM ' +
   '(SELECT DISTINCT PD.ORIGDLVSALORDLINESALORDCNTCOD COUNTERCODE, PD.ORIGDLVSALORDLINESALORDERCODE CODE, PD.ORIGDLVSALORDERLINEORDERLINE LINE, ' +
                    'PD.ORIGDLVSALORDLINEORDERSUBLINE SUBLINE, PD.ORIGDLVSALORDLINECMPORDERLINE COMPONENTLINE ' +
   'FROM ' +
   'SCHEDULESDOWNLOADDEMANDS SDD ' +
   'JOIN PRODUCTIONDEMAND PD ' +
   'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
   'WHERE ' +
   'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
   'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
   'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ') ' +
   'UNION ' +
   'SELECT DISTINCT SOD.SALORDLINESALORDERCOUNTERCODE COUNTERCODE, SOD.SALESORDERLINESALESORDERCODE CODE, SOD.SALESORDERLINEORDERLINE LINE, ' +
                   'SOD.SALESORDERLINEORDERSUBLINE SUBLINE, SOD.SALORDLINECOMPONENTORDERLINE COMPONENTLINE ' +
   'FROM ' +
   'SCHEDULESDOWNLOADDEMANDS SDD ' +
   'JOIN PRODUCTIONDEMAND PD ' +
   'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
   'JOIN SALESORDERDELIVERY SOD ' +
   'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
   'AND SOD.PROJECTCODE = PD.PROJECTCODE ' +
   'WHERE ' +
   'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
   'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
   'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ')) PD ' +
  'JOIN SALESORDERLINE SOL ' +
  'ON  SOL.SALESORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
  'AND SOL.SALESORDERCOUNTERCODE = PD.COUNTERCODE ' +
  'AND SOL.SALESORDERCODE = PD.CODE ' +
  'AND SOL.ORDERLINE = PD.LINE ' +
  'AND SOL.ORDERSUBLINE = PD.SUBLINE ' +
  'AND SOL.COMPONENTORDERLINE = PD.COMPONENTLINE';

  if (ColumnNamesSql <> '') or ADExists or HasTNA then
  begin
    SalesByProjectIsNeeded := true;
    HostQry.SQL.Text := hostSqlStr;
    HostQry.FetchOptions.RowsetSize := 5000;
    hostQry.Open;

    var SALESORDERCOUNTERCODE_FIELD := HostQry.FieldByName('SALESORDERCOUNTERCODE');
    var SALESORDERCODE_FIELD := HostQry.FieldByName('SALESORDERCODE');
    var ORDERLINE_FIELD := HostQry.FieldByName('ORDERLINE');
    var ORDERSUBLINE_FIELD := HostQry.FieldByName('ORDERSUBLINE');
    var COMPONENTORDERLINE_FIELD := HostQry.FieldByName('COMPONENTORDERLINE');
    var ABSUNIQUEID_FIELD3 := HostQry.FieldByName('ABSUNIQUEID');
    while not HostQry.Eof do
    begin
      new(Generic);
      Generic.Entity := 'SalesOrderLine';
      Generic.NumberOfKeys := 5;
      Generic.Key1 := trim(SALESORDERCOUNTERCODE_FIELD.AsString);
      Generic.Key2 := trim(SALESORDERCODE_FIELD.AsString);
      Generic.Key3 := ORDERLINE_FIELD.AsFloat;
      Generic.Key4 := ORDERSUBLINE_FIELD.AsFloat;
      Generic.Key5 := COMPONENTORDERLINE_FIELD.AsFloat;
      Generic.ABSUniqueId := trim(ABSUNIQUEID_FIELD3.AsString);
      Generic.ColumnNames := TStringList.Create;
      Generic.ColumnValue := TStringList.Create;
      for I := 0 to ColumnNamesProduction.Count - 1 do
      begin
        Generic.ColumnNames.Add(ColumnNamesProduction.Strings[I]);
        Generic.ColumnValue.Add( HostQry.Fields.FieldByName(ColumnNamesProduction.Strings[I]).AsString );
      end;
      List_Generic.Add(Generic);
      HostQry.Next;
    end;
  end;

  UpdateOperation(_('Fill_SALES_ORDER_DELIVERY'));

  ADExists := false;
  srvSqlStr := 'SELECT TABLE_NAME,COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('SalesOrderDelivery AD') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  if not ArcQry.Eof then ADExists := true;
  ArcQry.Active := false;

  ColumnNamesSql := '';
  srvSqlStr := 'SELECT TABLE_NAME,COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('SALESORDERDELIVERY') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
//  ColumnNamesProduction.Free;
  ColumnNamesProduction.Clear;
  tablePrefix := 'SOD';

  var COLUMN_NAME_FIELD4 := ArcQry.FieldByName('COLUMN_NAME');
  while (not ArcQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD4.AsString);
    if ( ColumnNamesProduction.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
    begin
      TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
      ColumnNamesProduction.Add(TempcolumnName);
      ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName + ' AS ' + TempcolumnName;
      ColumnNamesSql := ColumnNamesSql + ', ';
    end;
    ArcQry.Next;
  end;
  ArcQry.Active := false;

 { hostSqlStr := ' ' +
    'Select ' + ColumnNamesSql +
		  'SOD.SALORDLINESALORDERCOUNTERCODE, SOD.SALESORDERLINESALESORDERCODE, SOD.SALESORDERLINEORDERLINE, SOD.SALESORDERLINEORDERSUBLINE, ' +
      'SOD.SALORDLINECOMPONENTORDERLINE, SOD.DELIVERYLINE, SOD.ABSUNIQUEID FROM ' +
    '(SELECT DISTINCT ' +
      'PD.ORIGDLVSALORDLINESALORDCNTCOD, PD.ORIGDLVSALORDLINESALORDERCODE, PD.ORIGDLVSALORDERLINEORDERLINE, ' +
			'PD.ORIGDLVSALORDLINEORDERSUBLINE, PD.ORIGDLVSALORDLINECMPORDERLINE, PD.ORIGDELIVERYDELIVERYLINE ' +
     'FROM ' +
       '(SELECT CompanyCode, CounterCode, Code FROM SchedulesDownloadDemands WHERE ' +
          'COMPANYCODE = ' + QuotedStr(NowGlobalSettings.CompanyCode) + ' and ' +
          'EnvironmentCode = ' + QuotedStr(NowGlobalSettings.EnvironmentCode) + ' and ' +
          'TemplateCode IN (' + HandledProductionDemandMqinSql + ')) SDD ' +
     'JOIN PRODUCTIONDEMAND PD ' +
     'ON  PD.CompanyCode = SDD.CompanyCode AND PD.CounterCode = SDD.CounterCode AND PD.Code = SDD.Code) PD ' +
  'JOIN SALESORDERDELIVERY SOD ' +
  'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(NowGlobalSettings.CompanyCode) + ' ' +
  'AND SOD.SALORDLINESALORDERCOUNTERCODE = PD.ORIGDLVSALORDLINESALORDCNTCOD ' +
  'AND SOD.SALESORDERLINESALESORDERCODE = PD.ORIGDLVSALORDLINESALORDERCODE ' +
  'AND SOD.SALESORDERLINEORDERLINE = PD.ORIGDLVSALORDERLINEORDERLINE ' +
  'AND SOD.SALESORDERLINEORDERSUBLINE = PD.ORIGDLVSALORDLINEORDERSUBLINE ' +
  'AND SOD.SALORDLINECOMPONENTORDERLINE = PD.ORIGDLVSALORDLINECMPORDERLINE ' +
	'AND SOD.DELIVERYLINE = PD.ORIGDELIVERYDELIVERYLINE';    }
  hostSqlStr := ' ' +
  'SELECT ' + ColumnNamesSql +
      'SOD.SALORDLINESALORDERCOUNTERCODE, SOD.SALESORDERLINESALESORDERCODE, SOD.SALESORDERLINEORDERLINE, SOD.SALESORDERLINEORDERSUBLINE, ' +
      'SOD.SALORDLINECOMPONENTORDERLINE, SOD.DELIVERYLINE, SOD.ABSUNIQUEID FROM ' +
   '(SELECT DISTINCT PD.ORIGDLVSALORDLINESALORDCNTCOD COUNTERCODE, PD.ORIGDLVSALORDLINESALORDERCODE CODE, PD.ORIGDLVSALORDERLINEORDERLINE LINE, ' +
     'PD.ORIGDLVSALORDLINEORDERSUBLINE SUBLINE, PD.ORIGDLVSALORDLINECMPORDERLINE COMPONENTLINE, PD.ORIGDELIVERYDELIVERYLINE DELIVERYLINE ' +
   'FROM ' +
   'SCHEDULESDOWNLOADDEMANDS SDD ' +
   'JOIN PRODUCTIONDEMAND PD ' +
   'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
   'WHERE ' +
   'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
   'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
   'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ') ' +
   'UNION ' +
   'SELECT DISTINCT SOD.SALORDLINESALORDERCOUNTERCODE COUNTERCODE, SOD.SALESORDERLINESALESORDERCODE CODE, SOD.SALESORDERLINEORDERLINE LINE, ' +
                   'SOD.SALESORDERLINEORDERSUBLINE SUBLINE, SOD.SALORDLINECOMPONENTORDERLINE COMPONENTLINE, SOD.DELIVERYLINE DELIVERYLINE ' +
   'FROM ' +
   'SCHEDULESDOWNLOADDEMANDS SDD ' +
   'JOIN PRODUCTIONDEMAND PD ' +
   'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
   'JOIN SALESORDERDELIVERY SOD ' +
   'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
   'AND SOD.PROJECTCODE = PD.PROJECTCODE ' +
   'WHERE ' +
   'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
   'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
   'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ')) PD ' +
  'JOIN SALESORDERDELIVERY SOD ' +
  'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
  'AND SOD.SALORDLINESALORDERCOUNTERCODE = PD.COUNTERCODE ' +
  'AND SOD.SALESORDERLINESALESORDERCODE = PD.CODE ' +
  'AND SOD.SALESORDERLINEORDERLINE = PD.LINE ' +
  'AND SOD.SALESORDERLINEORDERSUBLINE = PD.SUBLINE ' +
  'AND SOD.SALORDLINECOMPONENTORDERLINE = PD.COMPONENTLINE ' +
  'AND SOD.DELIVERYLINE = PD.DELIVERYLINE';

  if (ColumnNamesSql <> '') or ADExists then
  begin
    SalesByProjectIsNeeded := true;
    HostQry.SQL.Text := hostSqlStr;
    hostQry.Open;

    var SALORDLINESALORDERCOUNTERCODE_FIELD := HostQry.FieldByName('SALORDLINESALORDERCOUNTERCODE');
    var SALESORDERLINESALESORDERCODE_FIELD := HostQry.FieldByName('SALESORDERLINESALESORDERCODE');
    var SALESORDERLINEORDERLINE_FIELD := HostQry.FieldByName('SALESORDERLINEORDERLINE');
    var SALESORDERLINEORDERSUBLINE_FIELD := HostQry.FieldByName('SALESORDERLINEORDERSUBLINE');
    var SALORDLINECOMPONENTORDERLINE_FIELD := HostQry.FieldByName('SALORDLINECOMPONENTORDERLINE');
    var DELIVERYLINE_FIELD := HostQry.FieldByName('DELIVERYLINE');
    var ABSUNIQUEID_FIELD5 := HostQry.FieldByName('ABSUNIQUEID');

    while not HostQry.Eof do
    begin
      new(Generic);
      Generic.Entity := 'SalesOrderDelivery';
      Generic.NumberOfKeys := 6;
      Generic.Key1 := trim(SALORDLINESALORDERCOUNTERCODE_FIELD.AsString);
      Generic.Key2 := trim(SALESORDERLINESALESORDERCODE_FIELD.AsString);
      Generic.Key3 := SALESORDERLINEORDERLINE_FIELD.AsFloat;
      Generic.Key4 := SALESORDERLINEORDERSUBLINE_FIELD.AsFloat;
      Generic.Key5 := SALORDLINECOMPONENTORDERLINE_FIELD.AsFloat;
      Generic.Key6 := DELIVERYLINE_FIELD.AsFloat;
      Generic.ABSUniqueId := trim(ABSUNIQUEID_FIELD5.AsString);
      Generic.ColumnNames := TStringList.Create;
      Generic.ColumnValue := TStringList.Create;
      for I := 0 to ColumnNamesProduction.Count - 1 do
      begin
        Generic.ColumnNames.Add(ColumnNamesProduction.Strings[I]);
        Generic.ColumnValue.Add( HostQry.Fields.FieldByName(ColumnNamesProduction.Strings[I]).AsString );
      end;
      List_Generic.Add(Generic);
      HostQry.Next;
    end;
  end;

  UpdateOperation(_('Fill_PROJECT_TO_SALES_POINTER'));

  hostSqlStr := ' ' +
  'Select ' +
   'SOD.SALORDLINESALORDERCOUNTERCODE, SOD.SALESORDERLINESALESORDERCODE, SOD.SALESORDERLINEORDERLINE, SOD.SALESORDERLINEORDERSUBLINE, ' +
   'SOD.SALORDLINECOMPONENTORDERLINE, SOD.DELIVERYLINE, SOD.ABSUNIQUEID, SOD.PROJECTCODE ' +
  'FROM ' +
    '(SELECT DISTINCT PD.PROJECTCODE ' +
     'FROM SchedulesDownloadDemands SDD ' +
     'JOIN PRODUCTIONDEMAND PD ' +
     'ON  PD.CompanyCode = SDD.CompanyCode ' +
     'AND PD.CounterCode = SDD.CounterCode ' +
     'AND PD.Code = SDD.Code ' +
     'WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
     'AND   SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ') PD ' +
  'JOIN SALESORDERDELIVERY SOD ' +
  'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
  'AND SOD.PROJECTCODE = PD.PROJECTCODE ' +
  'ORDER BY ' +
  'SOD.PROJECTCODE, SOD.SALORDLINESALORDERCOUNTERCODE, SOD.SALESORDERLINESALESORDERCODE, SOD.SALESORDERLINEORDERLINE, ' +
  'SOD.SALESORDERLINEORDERSUBLINE, SOD.SALORDLINECOMPONENTORDERLINE, SOD.DELIVERYLINE';

  if SalesByProjectIsNeeded then
  begin
    PrevProjectCode := '';
    HostQry.SQL.Text := hostSqlStr;
    hostQry.Open;

    var PROJECTCODE_FIELD := HostQry.FieldByName('PROJECTCODE');
    var SALORDLINESALORDERCOUNTERCODE_FIELD := HostQry.FieldByName('SALORDLINESALORDERCOUNTERCODE');
    var ABSUNIQUEID_FIELD6 := HostQry.FieldByName('ABSUNIQUEID');
    var SALESORDERLINESALESORDERCODE_FIELD := HostQry.FieldByName('SALESORDERLINESALESORDERCODE');
    var SALESORDERLINEORDERLINE_FIELD := HostQry.FieldByName('SALESORDERLINEORDERLINE');
    var SALESORDERLINEORDERSUBLINE_FIELD := HostQry.FieldByName('SALESORDERLINEORDERSUBLINE');
    var SALORDLINECOMPONENTORDERLINE_FIELD := HostQry.FieldByName('SALORDLINECOMPONENTORDERLINE');
    var DELIVERYLINE_FIELD := HostQry.FieldByName('DELIVERYLINE');

    while not HostQry.Eof do
    begin
      if trim(PROJECTCODE_FIELD.AsString) <> PrevProjectCode  then
      begin
        new(Generic);
        Generic.Entity := 'SalesOrderDeliveryByProject';
        Generic.NumberOfKeys := 1;
        Generic.Key1 := trim(PROJECTCODE_FIELD.AsString);
        Generic.ABSUniqueId := trim(ABSUNIQUEID_FIELD6.AsString);
        Generic.ColumnNames := TStringList.Create;
        Generic.ColumnValue := TStringList.Create;
        Generic.ColumnNames.Add('COUNTERCODE');
        Generic.ColumnValue.Add(SALORDLINESALORDERCOUNTERCODE_FIELD.AsString);
        Generic.ColumnNames.Add('CODE');
        Generic.ColumnValue.Add(SALESORDERLINESALESORDERCODE_FIELD.AsString);
        Generic.ColumnNames.Add('LINE');
        Generic.ColumnValue.Add(SALESORDERLINEORDERLINE_FIELD.AsString);
        Generic.ColumnNames.Add('SUBLINE');
        Generic.ColumnValue.Add(SALESORDERLINEORDERSUBLINE_FIELD.AsString);
        Generic.ColumnNames.Add('COMPONENTLINE');
        Generic.ColumnValue.Add(SALORDLINECOMPONENTORDERLINE_FIELD.AsString);
        Generic.ColumnNames.Add('DELIVERYLINE');
        Generic.ColumnValue.Add(DELIVERYLINE_FIELD.AsString);
        List_Generic.Add(Generic);
        PrevProjectCode := trim(PROJECTCODE_FIELD.AsString);
      end;
      HostQry.Next;
    end;
  end;

  UpdateOperation(_('Fill_DEMAND_PROJECT_TO_SALES_POINTER'));

  hostSqlStr := ' ' +
  'Select ' +
   'SOD.SALORDLINESALORDERCOUNTERCODE, SOD.SALESORDERLINESALESORDERCODE, SOD.SALESORDERLINEORDERLINE, SOD.SALESORDERLINEORDERSUBLINE, ' +
   'SOD.SALORDLINECOMPONENTORDERLINE, SOD.DELIVERYLINE, SOD.ABSUNIQUEID, SOD.RESERVATIONDATE, PD.COUNTERCODE, PD.CODE, PD.FINALPLANNEDDATE ' +
  'FROM SchedulesDownloadDemands SDD ' +
  'JOIN PRODUCTIONDEMAND PD ' +
  'ON  PD.CompanyCode = SDD.CompanyCode AND PD.CounterCode = SDD.CounterCode AND PD.Code = SDD.Code ' +
  'JOIN SALESORDERDELIVERY SOD ' +
  'ON  SOD.SALORDLINESALORDERCOMPANYCODE = SDD.CompanyCode AND SOD.PROJECTCODE = PD.PROJECTCODE ' +
  'AND SOD.ITEMTYPEAFICODE = PD.ITEMTYPEAFICODE ' +
  'AND SOD.SUBCODE01 = PD.SUBCODE01 AND SOD.SUBCODE02 = PD.SUBCODE02 AND SOD.SUBCODE03 = PD.SUBCODE03 AND SOD.SUBCODE04 = PD.SUBCODE04 ' +
  'AND SOD.SUBCODE05 = PD.SUBCODE05 AND SOD.SUBCODE06 = PD.SUBCODE06 AND SOD.SUBCODE07 = PD.SUBCODE07 AND SOD.SUBCODE08 = PD.SUBCODE08 ' +
  'AND SOD.SUBCODE09 = PD.SUBCODE09 AND SOD.SUBCODE10 = PD.SUBCODE10 ' +
  'WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
  'AND   SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
  'ORDER BY ' +
  'PD.COUNTERCODE, PD.CODE, SOD.RESERVATIONDATE, ' +
  'SOD.SALORDLINESALORDERCOUNTERCODE, SOD.SALESORDERLINESALESORDERCODE, SOD.SALESORDERLINEORDERLINE, ' +
  'SOD.SALESORDERLINEORDERSUBLINE, SOD.SALORDLINECOMPONENTORDERLINE, SOD.DELIVERYLINE';

  if SalesByProjectIsNeeded then
  begin
    First := true;
    HostQry.SQL.Text := hostSqlStr;
    hostQry.Open;

    var COUNTERCODE_FIELD := HostQry.FieldByName('COUNTERCODE');
    var CODE_FIELD := HostQry.FieldByName('CODE');
    var ABSUNIQUEID_FIELD7 := HostQry.FieldByName('ABSUNIQUEID');
    var RESERVATIONDATE_FIELD := HostQry.FieldByName('RESERVATIONDATE');
    var FINALPLANNEDDATE_FIELD := HostQry.FieldByName('FINALPLANNEDDATE');

    while not HostQry.Eof do
    begin
      if First then
      begin
        First := false;
        DemandChanged := true;
        LineFoundForDemand := false;
      end
      else
      begin
        DemandChanged := false;
        if (COUNTERCODE_FIELD.AsString <> PrevCounterCode)
        or (CODE_FIELD.AsString <> PrevCode) then
        begin
          DemandChanged := true;
          LineFoundForDemand := false;
          new(Generic);
          Generic.Entity := 'SalesOrderDeliveryByDemandProject';
          Generic.NumberOfKeys := 2;
          Generic.Key1 := PrevCounterCode;
          Generic.Key2 := PrevCode;
          Generic.ABSUniqueId := ABSUNIQUEID_FIELD7.AsString;
          Generic.ColumnNames := TStringList.Create;
          Generic.ColumnValue := TStringList.Create;
          Generic.ColumnNames.Add('COUNTERCODE');
          Generic.ColumnValue.Add(CounterCode);
          Generic.ColumnNames.Add('CODE');
          Generic.ColumnValue.Add(Code);
          Generic.ColumnNames.Add('LINE');
          Generic.ColumnValue.Add(Line);
          Generic.ColumnNames.Add('SUBLINE');
          Generic.ColumnValue.Add(SubLine);
          Generic.ColumnNames.Add('COMPONENTLINE');
          Generic.ColumnValue.Add(ComponentLine);
          Generic.ColumnNames.Add('DELIVERYLINE');
          Generic.ColumnValue.Add(DeliveryLine);
          List_Generic.Add(Generic);
        end;
      end;
      PrevCounterCode := COUNTERCODE_FIELD.AsString;
      PrevCode := CODE_FIELD.AsString;
      if RESERVATIONDATE_FIELD.IsNull then
        OrderDate := 999999
      else
        OrderDate := trunc(RESERVATIONDATE_FIELD.AsDateTime);
      DemandDate := trunc(FINALPLANNEDDATE_FIELD.AsDateTime);

      if DemandChanged or (OrderDate >= DemandDate) then
      begin
        if DemandChanged or (not DemandChanged and not LineFoundForDemand) then
        begin
          var ABSUNIQUEID_FIELD8 := HostQry.FieldByName('ABSUNIQUEID');
          var SALORDLINESALORDERCOUNTERCODE_FIELD := HostQry.FieldByName('SALORDLINESALORDERCOUNTERCODE');
          var SALESORDERLINESALESORDERCODE_FIELD := HostQry.FieldByName('SALESORDERLINESALESORDERCODE');
          var SALESORDERLINEORDERLINE_FIELD := HostQry.FieldByName('SALESORDERLINEORDERLINE');
          var SALESORDERLINEORDERSUBLINE_FIELD := HostQry.FieldByName('SALESORDERLINEORDERSUBLINE');
          var SALORDLINECOMPONENTORDERLINE_FIELD := HostQry.FieldByName('SALORDLINECOMPONENTORDERLINE');
          var DELIVERYLINE_FIELD := HostQry.FieldByName('DELIVERYLINE');

          ABSUniqueId := ABSUNIQUEID_FIELD8.AsString;
          CounterCode := SALORDLINESALORDERCOUNTERCODE_FIELD.AsString;
          Code := SALESORDERLINESALESORDERCODE_FIELD.AsString;
          Line := SALESORDERLINEORDERLINE_FIELD.AsString;
          SubLine := SALESORDERLINEORDERSUBLINE_FIELD.AsString;
          ComponentLine := SALORDLINECOMPONENTORDERLINE_FIELD.AsString;
          DeliveryLine := DELIVERYLINE_FIELD.AsString;
        end;
        if (OrderDate >= DemandDate) then  // The first order with a date equal or greater the demand final date is the most suitible
          LineFoundForDemand := true;
      end;
      HostQry.Next;
    end;
    if not First then
    begin
      new(Generic);
      Generic.Entity := 'SalesOrderDeliveryByDemandProject';
      Generic.NumberOfKeys := 2;
      Generic.Key1 := PrevCounterCode;
      Generic.Key2 := PrevCode;
      Generic.ABSUniqueId := ABSUniqueId;
      Generic.ColumnNames := TStringList.Create;
      Generic.ColumnValue := TStringList.Create;
      Generic.ColumnNames.Add('COUNTERCODE');
      Generic.ColumnValue.Add(CounterCode);
      Generic.ColumnNames.Add('CODE');
      Generic.ColumnValue.Add(Code);
      Generic.ColumnNames.Add('LINE');
      Generic.ColumnValue.Add(Line);
      Generic.ColumnNames.Add('SUBLINE');
      Generic.ColumnValue.Add(SubLine);
      Generic.ColumnNames.Add('COMPONENTLINE');
      Generic.ColumnValue.Add(ComponentLine);
      Generic.ColumnNames.Add('DELIVERYLINE');
      Generic.ColumnValue.Add(DeliveryLine);
      List_Generic.Add(Generic);
    end;
  end;

  UpdateOperation(_('Fill_DEMAND_TO_DEMAND_PROJECT_TO_SALES_POINTER'));

 { hostSqlStr := ' ' +
  'Select ' +
   'PD.COUNTERCODE, PD.CODE, PD.FINALPLANNEDDATE, PD.PROJECTCODE, ' +
   'PR.ORDERCOUNTERCODE, PR.ORDERCODE, PR.ISSUEDATE ' +
  'FROM SchedulesDownloadDemands SDD ' +
  'JOIN PRODUCTIONDEMAND PD ' +
  'ON  PD.CompanyCode = SDD.CompanyCode AND PD.CounterCode = SDD.CounterCode AND PD.Code = SDD.Code ' +
  'JOIN PRODUCTIONRESERVATION PR ' +
  'ON  PR.COMPANYCODE = SDD.CompanyCode AND PR.PROJECTCODE = PD.PROJECTCODE ' +
  'AND PR.ITEMTYPEAFICODE = PD.ITEMTYPEAFICODE ' +
  'AND PR.SUBCODE01 = PD.SUBCODE01 AND PR.SUBCODE02 = PD.SUBCODE02 AND PR.SUBCODE03 = PD.SUBCODE03 AND PR.SUBCODE04 = PD.SUBCODE04 ' +
  'AND PR.SUBCODE05 = PD.SUBCODE05 AND PR.SUBCODE06 = PD.SUBCODE06 AND PR.SUBCODE07 = PD.SUBCODE07 AND PR.SUBCODE08 = PD.SUBCODE08 ' +
  'AND PR.SUBCODE09 = PD.SUBCODE09 AND PR.SUBCODE10 = PD.SUBCODE10 ' +
  'WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
  'AND   SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
  'ORDER BY ' +
  'PD.PROJECTCODE, PD.COUNTERCODE, PD.CODE, PR.ISSUEDATE, ' +
  'PR.ORDERCOUNTERCODE, PR.ORDERCODE';  }

  hostSqlStr := ' ' +

  'Select ' +
  'PD.COUNTERCODE, PD.CODE, PD.FINALPLANNEDDATE, PD.PROJECTCODE, ' +
  'PR.ORDERCOUNTERCODE, PR.ORDERCODE, PR.ISSUEDATE  ' +
  'FROM PRODUCTIONDEMAND PD  ' +
  'JOIN PRODUCTIONRESERVATION PR ' +
  'ON  PR.COMPANYCODE = PD.CompanyCode AND PR.PROJECTCODE = PD.PROJECTCODE ' +
  'AND PR.ITEMTYPEAFICODE = PD.ITEMTYPEAFICODE AND PR.FULLITEMIDENTIFIER = PD.FULLITEMIDENTIFIER ' +
  'WHERE PD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND PD.FULLITEMIDENTIFIER > 0.0 ' +
  'AND exists ' +
    '(select 1 from SchedulesDownloadDemands SDD ' +
     'where SDD.CompanyCode = PD.CompanyCode AND SDD.CounterCode = PD.CounterCode AND SDD.Code = PD.Code and SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ') ' +
  'ORDER BY ' +
  'PD.PROJECTCODE, PD.COUNTERCODE, PD.CODE, PR.ISSUEDATE, ' +
  'PR.ORDERCOUNTERCODE, PR.ORDERCODE';

  if SalesByProjectIsNeeded then
  begin
    First := true;
    TmpOrgCounter := TStringList.Create;
    TmpOrgCode := TStringList.Create;
    TmpLinkedCounter := TStringList.Create;
    TmpLinkedCode := TStringList.Create;
    TmpFoundCounter := TStringList.Create;
    TmpFoundCode := TStringList.Create;
    DemandsLinksList := TList.Create;
    HostQry.SQL.Text := hostSqlStr;
    hostQry.Open;

    var COUNTERCODE_FIELD := HostQry.FieldByName('COUNTERCODE');
    var CODE_FIELD := HostQry.FieldByName('CODE');
    var PROJECTCODE_FIELD := HostQry.FieldByName('PROJECTCODE');
    var ISSUEDATE_FIELD := HostQry.FieldByName('ISSUEDATE');
    var FINALPLANNEDDATE_FIELD := HostQry.FieldByName('FINALPLANNEDDATE');
    var ORDERCOUNTERCODE_FIELD := HostQry.FieldByName('ORDERCOUNTERCODE');
    var ORDERCODE_FIELD := HostQry.FieldByName('ORDERCODE');

    while not HostQry.Eof do
    begin
      if First then
      begin
        List_Generic.sort(SortGeneric);
        First := false;
        DemandChanged := true;
        LineFoundForDemand := false;
      end
      else
      begin
        DemandChanged := false;
        if (COUNTERCODE_FIELD.AsString <> PrevCounterCode)
        or (CODE_FIELD.AsString <> PrevCode) then
        begin
          TmpOrgCounter.Add(PrevCounterCode);
          TmpOrgCode.Add(PrevCode);
          TmpLinkedCounter.Add(CounterCode);
          TmpLinkedCode.Add(Code);
          DemandChanged := true;
          LineFoundForDemand := false;
        end;
        if (PROJECTCODE_FIELD.AsString <> PrevProjectCode) then
        begin
          for I := 0 to TmpOrgCounter.Count - 1 do
          begin
            TmpFoundCounter.Clear;
            TmpFoundCode.Clear;
            J := I;
            while true do
            begin
              CurrentIndex := J;
              PointerFound := false;
              CodeAlreadyFound := false;
              for J := 0 to TmpOrgCounter.Count - 1 do
              begin
                if J = CurrentIndex then continue;
                if  (TmpOrgCounter.Strings[J] = TmpLinkedCounter.Strings[CurrentIndex])
                and (TmpOrgCode.Strings[J] = TmpLinkedCode.Strings[CurrentIndex]) then
                begin
                  CodeAlreadyFound := false;
                  for K := 0 to TmpFoundCounter.Count - 1 do
                  begin
                    if  (TmpOrgCounter.Strings[J] <> TmpFoundCounter.Strings[K])
                    or (TmpOrgCode.Strings[J] <> TmpFoundCode.Strings[K]) then
                      continue;
                    CodeAlreadyFound := true;
                    break;
                  end;
                  if not CodeAlreadyFound then
                  begin
                    TmpFoundCounter.Add(TmpOrgCounter.Strings[J]);
                    TmpFoundCode.Add(TmpOrgCode.Strings[J]);
                    PointerFound := true;
                    break;
                  end;
                end;
              end;
              if PointerFound then
                continue;
              if CodeAlreadyFound then
                break;
              GenericProjectSalesPointer := FindGenericBinarSearch(List_Generic, 'SalesOrderDeliveryByDemandProject', TmpOrgCounter.Strings[I], TmpOrgCode.Strings[I], 0, 0, 0, 0);
              if GenericProjectSalesPointer = nil then  // If the demand is not already there
              begin
                GenericProjectSalesPointer := FindGenericBinarSearch(List_Generic, 'SalesOrderDeliveryByDemandProject', TmpLinkedCounter.Strings[CurrentIndex], TmpLinkedCode.Strings[CurrentIndex], 0, 0, 0, 0);
                if GenericProjectSalesPointer <> nil then
                begin
                  new(PDemandsLinks);
                  PDemandsLinks.DemandCounterCode := TmpOrgCounter.Strings[I];
                  PDemandsLinks.DemandCode := TmpOrgCode.Strings[I];
                  PDemandsLinks.ABSUniqueId := GenericProjectSalesPointer.ABSUniqueId;
                  PDemandsLinks.CounterCode := GenericProjectSalesPointer.ColumnValue.Strings[0];
                  PDemandsLinks.Code := GenericProjectSalesPointer.ColumnValue.Strings[1];
                  PDemandsLinks.Line := GenericProjectSalesPointer.ColumnValue.Strings[2];
                  PDemandsLinks.SubLine := GenericProjectSalesPointer.ColumnValue.Strings[3];
                  PDemandsLinks.ComponentLine := GenericProjectSalesPointer.ColumnValue.Strings[4];
                  PDemandsLinks.DeliveryLine := GenericProjectSalesPointer.ColumnValue.Strings[5];
                  DemandsLinksList.add(PDemandsLinks);
                end;
              end;
              break;
            end;
          end;
          TmpOrgCounter.Clear;
          TmpOrgCode.Clear;
          TmpLinkedCounter.Clear;
          TmpLinkedCode.Clear;
        end;
      end;


      PrevProjectCode := PROJECTCODE_FIELD.AsString;
      PrevCounterCode := COUNTERCODE_FIELD.AsString;
      PrevCode := CODE_FIELD.AsString;
      if ISSUEDATE_FIELD.IsNull then
        OrderDate := 999999
      else
        OrderDate := trunc(ISSUEDATE_FIELD.AsDateTime);
      DemandDate := trunc(FINALPLANNEDDATE_FIELD.AsDateTime);
      if DemandChanged or (OrderDate >= DemandDate) then
      begin
        if DemandChanged or (not DemandChanged and not LineFoundForDemand) then
        begin
          CounterCode := ORDERCOUNTERCODE_FIELD.AsString;
          Code := ORDERCODE_FIELD.AsString;
        end;
        if (OrderDate >= DemandDate) then  // The first reservation date equal or greater the demand final date is the most suitible
          LineFoundForDemand := true;
      end;
      HostQry.Next;
    end;

    if not First then
    begin
      TmpOrgCounter.Add(PrevCounterCode);
      TmpOrgCode.Add(PrevCode);
      TmpLinkedCounter.Add(CounterCode);
      TmpLinkedCode.Add(Code);
      for I := 0 to TmpOrgCounter.Count - 1 do
      begin
        TmpFoundCounter.Clear;
        TmpFoundCode.Clear;
        J := I;
        while true do
        begin
          CurrentIndex := J;
          PointerFound := false;
          CodeAlreadyFound := false;
          for J := 0 to TmpOrgCounter.Count - 1 do
          begin
            if J = CurrentIndex then continue;
            if  (TmpOrgCounter.Strings[J] = TmpLinkedCounter.Strings[CurrentIndex])
            and (TmpOrgCode.Strings[J] = TmpLinkedCode.Strings[CurrentIndex]) then
            begin
              CodeAlreadyFound := false;
              for K := 0 to TmpFoundCounter.Count - 1 do
              begin
                if  (TmpOrgCounter.Strings[J] <> TmpFoundCounter.Strings[K])
                or (TmpOrgCode.Strings[J] <> TmpFoundCode.Strings[K]) then
                  continue;
                CodeAlreadyFound := true;
                break;
              end;
              if not CodeAlreadyFound then
              begin
                TmpFoundCounter.Add(TmpOrgCounter.Strings[J]);
                TmpFoundCode.Add(TmpOrgCode.Strings[J]);
                PointerFound := true;
                break;
              end;
            end;
          end;
          if PointerFound then
            continue;
          if CodeAlreadyFound then
            break;
          GenericProjectSalesPointer := FindGenericBinarSearch(List_Generic, 'SalesOrderDeliveryByDemandProject', TmpOrgCounter.Strings[I], TmpOrgCode.Strings[I], 0, 0, 0, 0);
          if GenericProjectSalesPointer = nil then  // If the demand is not already there
          begin
            GenericProjectSalesPointer := FindGenericBinarSearch(List_Generic, 'SalesOrderDeliveryByDemandProject', TmpLinkedCounter.Strings[CurrentIndex], TmpLinkedCode.Strings[CurrentIndex], 0, 0, 0, 0);
            if GenericProjectSalesPointer <> nil then
            begin
              new(PDemandsLinks);
              PDemandsLinks.DemandCounterCode := TmpOrgCounter.Strings[I];
              PDemandsLinks.DemandCode := TmpOrgCode.Strings[I];
              PDemandsLinks.ABSUniqueId := GenericProjectSalesPointer.ABSUniqueId;
              PDemandsLinks.CounterCode := GenericProjectSalesPointer.ColumnValue.Strings[0];
              PDemandsLinks.Code := GenericProjectSalesPointer.ColumnValue.Strings[1];
              PDemandsLinks.Line := GenericProjectSalesPointer.ColumnValue.Strings[2];
              PDemandsLinks.SubLine := GenericProjectSalesPointer.ColumnValue.Strings[3];
              PDemandsLinks.ComponentLine := GenericProjectSalesPointer.ColumnValue.Strings[4];
              PDemandsLinks.DeliveryLine := GenericProjectSalesPointer.ColumnValue.Strings[5];
              DemandsLinksList.add(PDemandsLinks);
            end;
          end;
          break;
        end;
      end;
    end;

    for I := 0 to DemandsLinksList.Count - 1 do
    begin
      new(Generic);
      Generic.Entity := 'SalesOrderDeliveryByDemandProject';
      Generic.NumberOfKeys := 2;
      Generic.Key1 := PTDemandsLinks(DemandsLinksList[I]).DemandCounterCode;
      Generic.Key2 := PTDemandsLinks(DemandsLinksList[I]).DemandCode;
      Generic.ABSUniqueId := PTDemandsLinks(DemandsLinksList[I]).ABSUniqueId;
      Generic.ColumnNames := TStringList.Create;
      Generic.ColumnValue := TStringList.Create;
      Generic.ColumnNames.Add('COUNTERCODE');
      Generic.ColumnValue.Add(PTDemandsLinks(DemandsLinksList[I]).CounterCode);
      Generic.ColumnNames.Add('CODE');
      Generic.ColumnValue.Add(PTDemandsLinks(DemandsLinksList[I]).Code);
      Generic.ColumnNames.Add('LINE');
      Generic.ColumnValue.Add(PTDemandsLinks(DemandsLinksList[I]).Line);
      Generic.ColumnNames.Add('SUBLINE');
      Generic.ColumnValue.Add(PTDemandsLinks(DemandsLinksList[I]).SubLine);
      Generic.ColumnNames.Add('COMPONENTLINE');
      Generic.ColumnValue.Add(PTDemandsLinks(DemandsLinksList[I]).ComponentLine);
      Generic.ColumnNames.Add('DELIVERYLINE');
      Generic.ColumnValue.Add(PTDemandsLinks(DemandsLinksList[I]).DeliveryLine);
      List_Generic.Add(Generic);
    end;
    for I := 0 to DemandsLinksList.Count - 1 do
      Dispose(PTDemandsLinks(DemandsLinksList[I]));
    DemandsLinksList.Clear;
    DemandsLinksList.Free;
    TmpOrgCounter.Free;
    TmpOrgCode.Free;
    TmpLinkedCounter.Free;
    TmpLinkedCode.Free;
    TmpFoundCounter.Free;
    TmpFoundCode.Free;
  end;

  UpdateOperation(_('Fill_PROJECT'));

  ADExists := false;
  srvSqlStr := 'SELECT TABLE_NAME,COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  if not ArcQry.Eof then ADExists := true;
  ArcQry.Active := false;

  ColumnNamesSql := '';
  srvSqlStr := 'SELECT TABLE_NAME,COLUMN_NAME FROM ' + tableNameSql + ' WHERE TABLE_NAME = ' + QuotedStr('PROJECT') + AND_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
//  ColumnNamesProduction.Free;
  ColumnNamesProduction.Clear;
  tablePrefix := 'P';

  var COLUMN_NAME_FIELD9 := ArcQry.FieldByName('COLUMN_NAME');

  while (not ArcQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD9.AsString);
    if ( ColumnNamesProduction.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
    begin
      TempcolumnName := copy(tablePrefix + '_' + columnName, 1, 30);
      ColumnNamesProduction.Add(TempcolumnName);
      ColumnNamesSql := ColumnNamesSql + tablePrefix + '.' + columnName + ' AS ' + TempcolumnName;
      ColumnNamesSql := ColumnNamesSql + ', ';
    end;
    ArcQry.Next;
  end;
  ArcQry.Active := false;

  hostSqlStr := ' ' +
  'Select ' + ColumnNamesSql + 'P.CODE, P.ABSUNIQUEID ' +
  'FROM ' +
    '(SELECT DISTINCT PD.PROJECTCODE ' +
     'FROM SchedulesDownloadDemands SDD ' +
     'JOIN PRODUCTIONDEMAND PD ' +
     'ON  PD.CompanyCode = SDD.CompanyCode ' +
     'AND PD.CounterCode = SDD.CounterCode ' +
     'AND PD.Code = SDD.Code ' +
     'WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
     'AND   SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ') PD ' +
  'JOIN PROJECT P ' +
  'ON  P.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
  'AND P.CODE = PD.PROJECTCODE ';

  if (ColumnNamesSql <> '') or ADExists then
  begin
    HostQry.SQL.Text := hostSqlStr;
    hostQry.Open;

    var CODE_FIELD := HostQry.FieldByName('CODE');
    var ABSUNIQUEID_FIELD := HostQry.FieldByName('ABSUNIQUEID');

    while not HostQry.Eof do
    begin
      new(Generic);
      Generic.Entity := 'Project';
      Generic.NumberOfKeys := 1;
      Generic.Key1 := CODE_FIELD.AsString;
      Generic.ABSUniqueId := ABSUNIQUEID_FIELD.AsString;
      Generic.ColumnNames := TStringList.Create;
      Generic.ColumnValue := TStringList.Create;
      for I := 0 to ColumnNamesProduction.Count - 1 do
      begin
        Generic.ColumnNames.Add(ColumnNamesProduction.Strings[I]);
        Generic.ColumnValue.Add( HostQry.Fields.FieldByName(ColumnNamesProduction.Strings[I]).AsString );
      end;
      List_Generic.Add(Generic);
      HostQry.Next;
    end;
  end;

  List_Generic.sort(SortGeneric);

  ColumnNamesProduction.Free;

end;

//----------------------------------------------------------------------------//

function SortProject_Number(Item1, Item2: Pointer) : integer;
var
  MQMPR1 : PTPROJECT_NUMBER;
  MQMPR2 : PTPROJECT_NUMBER;
begin
  MQMPR1 := PTPROJECT_NUMBER(Item1);
  MQMPR2 := PTPROJECT_NUMBER(Item2);
  if MQMPR1.CODE < MQMPR2.CODE then
    Result := -1
  else if (MQMPR1.CODE = MQMPR2.CODE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function GetNumberByProject(ProjectNumberList : TList; Project : string) : string;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
  qryArc:    TMqmQuery;
  srvSqlStr : string;
  ProjectNumber : PTPROJECT_NUMBER;
  LastNumber : string;
  TableName : string;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    TableName := 'PROJECT_NUMBER'
  else
    TableName := 'SCDA_PROJECT_NUMBER';
  Result := '';

  NumberOfEntries := ProjectNumberList.Count;
  if NumberOfEntries > 0 then
  begin
    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

    while (Multiplier > 0) do
    begin

      if  (i < NumberOfEntries)
      and (PTPROJECT_NUMBER(ProjectNumberList[i]).CODE = Project) then break;

      Multiplier := trunc(Multiplier / 2);

      if  (i < NumberOfEntries)
      and (PTPROJECT_NUMBER(ProjectNumberList[i]).CODE < Project) then
        i := i + Multiplier
      else
        i := i - Multiplier;

    end;

    if Multiplier > 0 then Result := PTPROJECT_NUMBER(ProjectNumberList[i]).NUMBER;

  end;

  if Result = '' then
  begin
    qryArc := ThreadCreateQueryArc;
    LastNumber := IntToStr(ProjectNumberList.Count + 1);
    qryArc.SQL.Clear;
   { qryArc.SQL.Add('insert into ' + TableName        + '(');
    qryArc.SQL.Add('IDENTIFIER' + ',');
    qryArc.SQL.Add('CODE'       + ',');
    qryArc.sql.Add('PROJECT_NUMBER');
    qryArc.SQL.Add(') values (');
    qryArc.SQL.Add(':' + 'IDENTIFIER'    + ',');
    qryArc.SQL.Add(':' + 'CODE' + ',');
    qryArc.SQL.Add(':' + 'PROJECT_NUMBER');
    qryArc.SQL.Add(')');

    qryArc.ParamByName('IDENTIFIER').AsInteger := StrToInt(IniAppGlobals.Identifier);
    qryArc.ParamByName('CODE').AsString := QuotedStr(Project);
    qryArc.ParamByName('PROJECT_NUMBER').AsString := LastNumber;   }

    srvSqlStr := 'insert into  ' + TableName +
                   ' (IDENTIFIER, CODE, PROJECT_NUMBER)' +
                     ' values ( ' + IniAppGlobals.Identifier + ',' + QuotedStr(Project) + ',' + LastNumber + ')';

    qryArc.SQL.Text := srvSqlStr;
  //  try
      qryArc.ExecSQL;
      qryArc.Connection.Commit;
  //  except

  //  end;
    new(ProjectNumber);
    ProjectNumber.CODE := Project;
    ProjectNumber.NUMBER := LastNumber;
    ProjectNumberList.Add(ProjectNumber);
    ProjectNumberList.Sort(SortProject_Number);
    qryArc.free;
  end;

end;

//----------------------------------------------------------------------------//

function LoadIntoStockDetails(logicalWarehouseList : TList; itemTypesList : TList; ProjectNumberList : TList; List_Items : TList): boolean;
var
  srvQryArc, srvQryArcUpdate : TMqmQuery;
  SQLText:   String;
  ColumnName, DisplayBefore, Separator : String;
  tbInfo: ^TTblInfo;
  First, FoundWhLink : boolean;
  i: integer;
  SQLCONCAT : String;
  Temp, Operation : String;

  LocalID, HostID : integer;
  LocalItemType, HostItemType : String;
  LocalProduct, HostProduct : String;
  LocalNetGroup, HostNetGroup : String;
  Curr_LOGICALWAREHOUSE: PLOGICALWAREHOUSES;
  LocalDetails, HostDetails : String;
  LogicalWarehouseCode : String;
  DecoSubCode01, DecoSubCode02, DecoSubCode03, DecoSubCode04, DecoSubCode05 : String;
  DecoSubCode06, DecoSubCode07, DecoSubCode08, DecoSubCode09, DecoSubCode10 : String;
  HostQry: TMqmQuery;
  Items : PTITEMS;
  ProjectCode : string;
  TableName : string;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    TableName := 'ITEMTYPELOGICALWAREHOUSE'
  else
    TableName := 'SCDA_ITEMTYPELOGICALWAREHOUSE';
  SQLCONCAT := ' CONCAT ';
  Result := true;
  First := true;
  HostID := -1;
  LocalID := -1;
  HostQry := ThreadCreateQueryHost;
  srvQryArc := ThreadCreateQueryArc;

  srvQryArcUpdate := ThreadCreateQueryArc;

  tbInfo := @tblInfo[tbl_StockDetails];

  SQLText := 'SELECT * FROM ' + TableName +
            ' WHERE CONN_BTW_STOCK_AND_RESRV = ' + QuotedStr('1') + AND_IDF_Condition('IDENTIFIER');
  srvQryArc.SQL.Text := SQLText;
  srvQryArc.Active:=true;

  SQLText := '';
  while ( not srvQryArc.Eof ) do
  begin
    Separator := trim(srvQryArc.FieldByName('SEPARATE_BTW_ATTRIBUTE').AsString);
    ColumnName := trim(srvQryArc.FieldByName('IW_1ST_COLUMN').AsString);
    if ColumnName <> '' then
    begin
      if not First then
        SQLText := SQLText + 'UNION ALL ';
      First := false;
      SQLText := SQLText +
        'SELECT FIKD.ABSUNIQUEID, BALANCE.NUMBERID,BALANCE.ITEMTYPECODE, BALANCE.LOGICALWAREHOUSECODE,' +
        'BALANCE.PROJECTCODE, BALANCE.DECOSUBCODE01, BALANCE.DECOSUBCODE02, BALANCE.DECOSUBCODE03,' +
        'BALANCE.DECOSUBCODE04, BALANCE.DECOSUBCODE05, BALANCE.DECOSUBCODE06, BALANCE.DECOSUBCODE07,' +
        'BALANCE.DECOSUBCODE08, BALANCE.DECOSUBCODE09, BALANCE.DECOSUBCODE10,(';
      SQLText := SQLText + 'TRIM(BALANCE.' + ColumnName + ')';
      for i := 2 to 6 do
      begin
        Temp := 'IW_' + IntToStr(i) + 'ST_COLUMN';
        ColumnName := trim(srvQryArc.FieldByName(Temp).AsString);
        Temp := 'DSP_BEFORE_' + IntToStr(i) + 'ST_COLUMN';
        DisplayBefore := trim(srvQryArc.FieldByName(Temp).AsString);
        if ColumnName <> '' then
        begin
          SQLText := SQLText + SQLCONCAT;
          if DisplayBefore = '1' then
            SQLText := SQLText + QuotedStr(' ') + SQLCONCAT;
          if DisplayBefore = '2' then
            SQLText := SQLText + QuotedStr(' ' + Separator) + SQLCONCAT;
          if DisplayBefore = '3' then
            SQLText := SQLText + QuotedStr(Separator) + SQLCONCAT;
          SQLText := SQLText + 'TRIM(BALANCE.' + ColumnName + ')';
        end;
      end;
      SQLText := SQLText + ') DETAILS FROM BALANCE ';
      SQLText := SQLText + ' JOIN FULLITEMKEYDECODER FIKD ON ';
      SQLText := SQLText + ' FIKD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ';
      SQLText := SQLText + ' AND	FIKD.ITEMTYPECODE = BALANCE.ITEMTYPECODE AND FIKD.SUBCODE01 = BALANCE.DECOSUBCODE01 ';
      SQLText := SQLText + ' AND FIKD.SUBCODE02 = BALANCE.DECOSUBCODE02 AND FIKD.SUBCODE03 = BALANCE.DECOSUBCODE03 ';
      SQLText := SQLText + ' AND FIKD.SUBCODE04 = BALANCE.DECOSUBCODE04 AND FIKD.SUBCODE05 = BALANCE.DECOSUBCODE05 ';
      SQLText := SQLText + ' AND FIKD.SUBCODE06 = BALANCE.DECOSUBCODE06 AND FIKD.SUBCODE07 = BALANCE.DECOSUBCODE07 ';
      SQLText := SQLText + ' AND FIKD.SUBCODE08 = BALANCE.DECOSUBCODE08 AND FIKD.SUBCODE09 = BALANCE.DECOSUBCODE09 ';
      SQLText := SQLText + ' AND FIKD.SUBCODE10 = BALANCE.DECOSUBCODE10	';
      SQLText := SQLText + ' WHERE ';
      Temp := trim(srvQryArc.FieldByName('ITEMTYPECODE').AsString);
      SQLText := SQLText + ' BALANCE.ITEMTYPECODE = ' + QuotedStr(Temp);
      Temp := trim(srvQryArc.FieldByName('LOGICALWAREHOUSECODE').AsString);
      SQLText := SQLText + ' AND BALANCE.LOGICALWAREHOUSECODE = ' + QuotedStr(Temp);
    end;
    srvQryArc.Next;
  end;

  if SQLText = '' then
  begin
    HostQry.Free;
    srvQryArc.Free;
    srvQryArcUpdate.Free;
    exit;
  end;
  SQLText := SQLText + ' ORDER BY NUMBERID';

  HostQry.SQL.Text := SQLText;
  hostQry.Open;
  var fldSD_NumberId    := HostQry.FieldByName('NUMBERID');
  var fldSD_ItemType    := HostQry.FieldByName('ITEMTYPECODE');
  var fldSD_WareHouse   := HostQry.FieldByName('LOGICALWAREHOUSECODE');
  var fldSD_AbsUniqueId := HostQry.FieldByName('ABSUNIQUEID');
  var fldSD_ProjectCode := HostQry.FieldByName('PROJECTCODE');
  var fldSD_Deco01      := HostQry.FieldByName('DECOSUBCODE01');
  var fldSD_Deco02      := HostQry.FieldByName('DECOSUBCODE02');
  var fldSD_Deco03      := HostQry.FieldByName('DECOSUBCODE03');
  var fldSD_Deco04      := HostQry.FieldByName('DECOSUBCODE04');
  var fldSD_Deco05      := HostQry.FieldByName('DECOSUBCODE05');
  var fldSD_Deco06      := HostQry.FieldByName('DECOSUBCODE06');
  var fldSD_Deco07      := HostQry.FieldByName('DECOSUBCODE07');
  var fldSD_Deco08      := HostQry.FieldByName('DECOSUBCODE08');
  var fldSD_Deco09      := HostQry.FieldByName('DECOSUBCODE09');
  var fldSD_Deco10      := HostQry.FieldByName('DECOSUBCODE10');
  var fldSD_HostDetails := HostQry.FieldByName('DETAILS');

  if DndArchiveArcName = TD_Interbase then
    TableName := 'STOCKDETAILS'
  else
    TableName := 'SCDA_STOCKDETAILS';

  srvQryArc.SQL.Text := ' SELECT * FROM ' + TableName + ' ' + WHERE_IDF_Condition('SD_IDENTIFIER') +  ' ORDER BY SD_BALANCEID ';
  srvQryArc.Active:=true;
  var fldArcSD_BalanceId := srvQryArc.FieldByName('SD_BALANCEID');
  var fldArcSD_TypeProd  := srvQryArc.FieldByName('SD_TYPE_PROD');
  var fldArcSD_ProdCode  := srvQryArc.FieldByName('SD_PRODUCT_CODE');
  var fldArcSD_NetGroup  := srvQryArc.FieldByName('SD_NET_GROUP_CODE');
  var fldArcSD_Details   := srvQryArc.FieldByName('SD_DETAILS');

  while true do
  begin
    if srvQryArc.Eof and hostQry.Eof then break;

    Operation := '0';

    if srvQryArc.Eof then
      Operation := '1' // Insert
    else
    begin
      LocalID := fldArcSD_BalanceId.AsInteger;
      LocalItemType := fldArcSD_TypeProd.AsString;
      LocalProduct := fldArcSD_ProdCode.AsString;
      LocalNetGroup := fldArcSD_NetGroup.AsString;
      LocalDetails := fldArcSD_Details.AsString;
    end;

    if hostQry.Eof then
      Operation := '3' // Delete
    else
    begin
      HostID := fldSD_NumberId.AsInteger;
      HostItemType := fldSD_ItemType.AsString;
      LogicalWarehouseCode := fldSD_WareHouse.AsString;

      Curr_LOGICALWAREHOUSE := getLogicalWHStruct(LogicalWarehouseCode, logicalWarehouseList);
      if Curr_LOGICALWAREHOUSE = nil then
        HostNetGroup := ''
      else
        HostNetGroup := Curr_LOGICALWAREHOUSE.MQMGROUPCODE;

      Items := FindProductItem(fldSD_AbsUniqueId.AsString , List_Items);

      if Items <> nil then
      begin
        FoundWhLink := false;
        for I := 0 to Items.ItemWarehouseLink.Count - 1 do
        begin
          if trim(fldSD_WareHouse.AsString) = trim(PItemWarehouseLinkRec(Items.ItemWarehouseLink[I]).LogicalWarehouseCode) then
          begin
            FoundWhLink := true;
            if PItemWarehouseLinkRec(Items.ItemWarehouseLink[I]).ProjectControlled then
            begin
              if trim(fldSD_ProjectCode.AsString) <> '' then
              begin
                ProjectCode := trim(fldSD_ProjectCode.AsString);
                HostNetGroup := HostNetGroup + GetNumberByProject(ProjectNumberList, ProjectCode);
              end;
            end;
            break;
          end;
        end;
        if not FoundWhLink
           and Items.ProjectControlled
           and (trim(fldSD_ProjectCode.AsString) <> '') and (Curr_LOGICALWAREHOUSE <> nil)
           and Curr_LOGICALWAREHOUSE.ProjectControlled then
        begin
          ProjectCode := trim(fldSD_ProjectCode.AsString);
          HostNetGroup := HostNetGroup + GetNumberByProject(ProjectNumberList, ProjectCode);
        end;
      end;

      DecoSubCode01 := fldSD_Deco01.AsString;
      DecoSubCode02 := fldSD_Deco02.AsString;
      DecoSubCode03 := fldSD_Deco03.AsString;
      DecoSubCode04 := fldSD_Deco04.AsString;
      DecoSubCode05 := fldSD_Deco05.AsString;
      DecoSubCode06 := fldSD_Deco06.AsString;
      DecoSubCode07 := fldSD_Deco07.AsString;
      DecoSubCode08 := fldSD_Deco08.AsString;
      DecoSubCode09 := fldSD_Deco09.AsString;
      DecoSubCode10 := fldSD_Deco10.AsString;
      HostProduct := getFullItemKeyCode(HostItemType, DecoSubCode01, DecoSubCode02, DecoSubCode03,
                     DecoSubCode04, DecoSubCode05, DecoSubCode06, DecoSubCode07, DecoSubCode08,
                     DecoSubCode09, DecoSubCode10);
      HostDetails := fldSD_HostDetails.AsString;
    end;

    if Operation = '0' then
    begin
      if HostID < LocalID then Operation := '1'; // Insert
      if HostID > LocalID then Operation := '3'; // Delete
      if HostID = LocalID then
      begin
        if (LocalItemType <> HostItemType) OR (LocalProduct <> HostProduct)
        OR (LocalNetGroup <> HostNetGroup) OR (LocalDetails <> HostDetails)
          then Operation := '2'; // Update
      end;
    end;

    if Operation = '1' then
    begin
      SQLText :=  'INSERT INTO ' + TableName + //tbInfo.GetTableName +
                   ' (SD_IDENTIFIER, SD_BALANCEID, SD_TYPE_PROD, SD_PRODUCT_CODE, SD_NET_GROUP_CODE, SD_DETAILS, SD_USED, SD_PREQ_NO, SD_PSTEP_ID, SD_PSUBST_ID,SD_REPROC_NO )' +
                   ' VALUES (' +
       IniAppGlobals.Identifier + ', ' + inttostr(HostID) + ', ' + QuotedStr(HostItemType) + ', ' + QuotedStr(HostProduct) +
       ', ' + QuotedStr(HostNetGroup) + ', ' + QuotedStr(HostDetails) +
      // ', false, null, null, null, null)';
       ',' + '0' + ', null, null, null, null)';
      srvQryArcUpdate.SQL.Text := SQLText;
      srvQryArcUpdate.ExecSQL;
    end;

    if Operation = '2' then
    begin
      SQLText := '' +
       'UPDATE ' + TableName + ' SET' +
       ' SD_TYPE_PROD = ' + QuotedStr(HostItemType) +
       ', SD_PRODUCT_CODE = ' + QuotedStr(HostProduct) +
       ', SD_NET_GROUP_CODE = ' + QuotedStr(HostNetGroup) +
       ', SD_DETAILS = ' + QuotedStr(HostDetails) +
       ' WHERE SD_BALANCEID = ' +  inttostr(HostID) + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
      srvQryArcUpdate.SQL.Text := SQLText;
      srvQryArcUpdate.ExecSQL;
    end;

    if Operation = '3' then
    begin
      SQLText := '' +
       'DELETE FROM ' + TableName + ' WHERE SD_BALANCEID = ' + inttostr(LocalID) + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
      srvQryArcUpdate.SQL.Text := SQLText;
      srvQryArcUpdate.ExecSQL;
    end;

    if (Operation <> '3') then hostQry.Next;
    if (Operation <> '1') then srvQryArc.Next;

  end;

  srvQryArcUpdate.connection.commit;
  HostQry.Free;
  srvQryArc.Free;
  srvQryArcUpdate.Free;
end;

//----------------------------------------------------------------------------//

function SortProductionReservation(Item1, Item2: Pointer) : integer;
var
  MQMProductionReservation1 : PMQMProductionReservation;
  MQMProductionReservation2 : PMQMProductionReservation;
begin
  MQMProductionReservation1 := PMQMProductionReservation(Item1);
  MQMProductionReservation2 := PMQMProductionReservation(Item2);
  if MQMProductionReservation1.Code < MQMProductionReservation2.Code then
    Result := -1
  else if (MQMProductionReservation1.Code = MQMProductionReservation2.Code) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function FindCodeInproductionReservationList(Code : string; productionReservationList : TList ) : Integer;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := -1;

  NumberOfEntries := productionReservationList.Count;
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
      and (PMQMProductionReservation(productionReservationList[i]).Code = Code) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (PMQMProductionReservation(productionReservationList[i]).Code < Code) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  if Multiplier > 0 then
    Result := I;
end;

//----------------------------------------------------------------------------//

function GetPropBuildFromOtherPropsList(PropBuildFromOtherPropsList : TList) : boolean;
var
  PROPERTY_BUILD_FROM_OTHER : PTPROPERTY_BUILD_FROM_OTHER;
  qrySrv:    TMqmQuery;
  srvSqlStr : string;
  I : Integer;
  TableName : string;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    TableName  := 'PROP'
  else
    TableName  := 'SCDA_' + 'PROP';
  result := false;
  qrySrv := ThreadCreateQueryArc;

  srvSqlStr := 'SELECT PY_PROPERTY, PY_PROP_VAL_BUILDED1, PY_PROP_VAL_BUILDED2,' +
               'PY_PROP_VAL_BUILDED3, PY_PROP_VAL_BUILDED4, PY_PROP_VAL_BUILDED5, PY_DESIGNATEDPROPERTY, PY_TYPE, PY_OPTIONAL_SEPARATOR'+
               ' FROM ' + TableName +
               ' WHERE PY_IS_PROP_BUILD_FROM_PROP = ' + QuotedStr('1') + ' AND ' +
               ' PY_TYPE = ' + QuotedStr('1') + AND_IDF_Condition('PY_IDENTIFIER');

  qrySrv.SQL.Text := srvSqlStr;
  qrySrv.open;
  var fldPBFO_DesigProp := qrySrv.FieldByName('PY_DESIGNATEDPROPERTY');
  var fldPBFO_PropCode  := qrySrv.FieldByName('PY_PROPERTY');
  var fldPBFO_Built1    := qrySrv.FieldByName('PY_PROP_VAL_BUILDED1');
  var fldPBFO_Built2    := qrySrv.FieldByName('PY_PROP_VAL_BUILDED2');
  var fldPBFO_Built3    := qrySrv.FieldByName('PY_PROP_VAL_BUILDED3');
  var fldPBFO_Built4    := qrySrv.FieldByName('PY_PROP_VAL_BUILDED4');
  var fldPBFO_Built5    := qrySrv.FieldByName('PY_PROP_VAL_BUILDED5');

  while not qrySrv.Eof do
  begin
    if fldPBFO_DesigProp.AsString = '6' then
    begin
      qrySrv.Next;
      Continue
    end;
    new(PROPERTY_BUILD_FROM_OTHER);
    PROPERTY_BUILD_FROM_OTHER.PROPERTYCODE := fldPBFO_PropCode.AsString;
    PROPERTY_BUILD_FROM_OTHER.PROPCODE1    := trim(fldPBFO_Built1.AsString);
    PROPERTY_BUILD_FROM_OTHER.PROPCODE2    := trim(fldPBFO_Built2.AsString);
    PROPERTY_BUILD_FROM_OTHER.PROPCODE3    := trim(fldPBFO_Built3.AsString);
    PROPERTY_BUILD_FROM_OTHER.PROPCODE4    := trim(fldPBFO_Built4.AsString);
    PROPERTY_BUILD_FROM_OTHER.PROPCODE5    := trim(fldPBFO_Built5.AsString);
    PROPERTY_BUILD_FROM_OTHER.Separator    := trim(qrySrv.FieldByName('PY_OPTIONAL_SEPARATOR').AsString);	
    PROPERTY_BUILD_FROM_OTHER.IsPropLinkerToServingGroup := false;
    if fldPBFO_DesigProp.AsString = '3' then
       PROPERTY_BUILD_FROM_OTHER.IsPropLinkerToServingGroup := true;
    PropBuildFromOtherPropsList.Add(PROPERTY_BUILD_FROM_OTHER);
    result := true;
    qrySrv.Next;
  end;

  for I := 0 to PropBuildFromOtherPropsList.Count - 1 do
  begin
    qrySrv.SQL.Clear;
    PROPERTY_BUILD_FROM_OTHER := PTPROPERTY_BUILD_FROM_OTHER(PropBuildFromOtherPropsList[I]);

    if (PROPERTY_BUILD_FROM_OTHER.PROPCODE1 <> '') then
    begin
      srvSqlStr := 'SELECT PY_TYPE, PY_PROP_LEN FROM ' + TableName +
               ' WHERE PY_PROPERTY = ' + QuotedStr(PROPERTY_BUILD_FROM_OTHER.PROPCODE1) + AND_IDF_Condition('PY_IDENTIFIER');
      qrySrv.SQL.Text := srvSqlStr;
      qrySrv.open;
      if not qrySrv.Eof then
      begin
        PROPERTY_BUILD_FROM_OTHER.TYPE1 := qrySrv.FieldByName('PY_TYPE').AsString;
        PROPERTY_BUILD_FROM_OTHER.LEN1 := qrySrv.FieldByName('PY_PROP_LEN').AsInteger;
      end;
      qrySrv.SQL.Clear;
    end;

    if (PROPERTY_BUILD_FROM_OTHER.PROPCODE2 <> '') then
    begin
      srvSqlStr := 'SELECT PY_TYPE, PY_PROP_LEN FROM ' + TableName +
                 ' WHERE PY_PROPERTY = ' + QuotedStr(PROPERTY_BUILD_FROM_OTHER.PROPCODE2) + AND_IDF_Condition('PY_IDENTIFIER');
      qrySrv.SQL.Text := srvSqlStr;
      qrySrv.open;

      if not qrySrv.Eof then
      begin
        PROPERTY_BUILD_FROM_OTHER.TYPE2 := qrySrv.FieldByName('PY_TYPE').AsString;
        PROPERTY_BUILD_FROM_OTHER.LEN2  := qrySrv.FieldByName('PY_PROP_LEN').AsInteger;
      end;

      qrySrv.SQL.Clear;
    end;

    if (PROPERTY_BUILD_FROM_OTHER.PROPCODE3 <> '') then
    begin
      srvSqlStr := 'SELECT PY_TYPE, PY_PROP_LEN FROM ' + TableName +
                 ' WHERE PY_PROPERTY = ' + QuotedStr(PROPERTY_BUILD_FROM_OTHER.PROPCODE3) + AND_IDF_Condition('PY_IDENTIFIER');
      qrySrv.SQL.Text := srvSqlStr;
      qrySrv.open;

      if not qrySrv.Eof then
      begin
        PROPERTY_BUILD_FROM_OTHER.TYPE3 := qrySrv.FieldByName('PY_TYPE').AsString;
        PROPERTY_BUILD_FROM_OTHER.LEN3  := qrySrv.FieldByName('PY_PROP_LEN').AsInteger;
      end;

      qrySrv.SQL.Clear;
    end;

    if (PROPERTY_BUILD_FROM_OTHER.PROPCODE4 <> '') then
    begin
      srvSqlStr := 'SELECT PY_TYPE, PY_PROP_LEN FROM ' + TableName +
                 ' WHERE PY_PROPERTY = ' + QuotedStr(PROPERTY_BUILD_FROM_OTHER.PROPCODE4) + AND_IDF_Condition('PY_IDENTIFIER');
      qrySrv.SQL.Text := srvSqlStr;
      qrySrv.open;

      if not qrySrv.Eof then
      begin
        PROPERTY_BUILD_FROM_OTHER.TYPE4 := qrySrv.FieldByName('PY_TYPE').AsString;
        PROPERTY_BUILD_FROM_OTHER.LEN4  := qrySrv.FieldByName('PY_PROP_LEN').AsInteger;
      end;

      qrySrv.SQL.Clear;
    end;

    if (PROPERTY_BUILD_FROM_OTHER.PROPCODE5 <> '') then
    begin
      srvSqlStr := 'SELECT PY_TYPE, PY_PROP_LEN FROM ' + TableName +
                 ' WHERE PY_PROPERTY = ' + QuotedStr(PROPERTY_BUILD_FROM_OTHER.PROPCODE5) + AND_IDF_Condition('PY_IDENTIFIER');
      qrySrv.SQL.Text := srvSqlStr;
      qrySrv.open;

      if not qrySrv.Eof then
      begin
        PROPERTY_BUILD_FROM_OTHER.TYPE5 := qrySrv.FieldByName('PY_TYPE').AsString;
        PROPERTY_BUILD_FROM_OTHER.LEN5  := qrySrv.FieldByName('PY_PROP_LEN').AsInteger;
      end;
    end;

  end;

  qrySrv.free;

end;

//----------------------------------------------------------------------------//

function BuildAvailabilityStruct(balanceHandledItemTypeCodes : string; STOCKTYPECODES : string; NETGROUP_IS_LOT_Handaled : boolean) : string;
var
  BalanceCompanyInUsed, AllocationCompanyInUsed, SalesOrderDeliveryCompanyInUsed, SALORDLINESALORDERCompanyInUsed,
  SALESRELEASELINECompanyInUsed, PURCHASERETURNDOCUMENTCompanyInUsed, PRODUCTIONRESERVATIONCompanyInUsed,
  PRODUCTIONORDERRESERVATIONCompanyInUsed, PRODUCTIONDEMANDCompanyInUsed, REPLENISHMENTREQUISITIONCompanyInUsed,
  INTERNALRETURNDOCUMENTCompanyInUsed, FULLITEMKEYDECODERCompanyInUsed, TOOLCompanyInUsed, SALESDOCUMENTLINECompanyInUsed,
  PURCHASEORDERDELIVERYCompanyInUsed, INTERNALORDERDELIVERYCompanyInUsed, INTERNALDOCUMENTLINECompanyInUsed : string;
  ConvertDateFormat : Integer;
begin
  UpdateOperation(_('Downloading AVAILABILITY'));

  if IniAppGlobals.DownloadFrom = '0' then
    ConvertDateFormat := 1
  else if IniAppGlobals.DownloadFrom = '1' then
    ConvertDateFormat := 2
  else
    ConvertDateFormat := 1;

  if not GetCompanyLevelHandlingByEntityName('BALANCE',  BalanceCompanyInUsed) then
     BalanceCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('ALLOCATION',  AllocationCompanyInUsed) then
     AllocationCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('SALESORDERDELIVERY',  SalesOrderDeliveryCompanyInUsed) then
     SalesOrderDeliveryCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('SALORDLINESALORDER',  SALORDLINESALORDERCompanyInUsed) then
     SALORDLINESALORDERCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('SALESRELEASELINE',  SALESRELEASELINECompanyInUsed) then
     SALESRELEASELINECompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PURCHASERETURNDOCUMENT',  PURCHASERETURNDOCUMENTCompanyInUsed) then
     PURCHASERETURNDOCUMENTCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONRESERVATION',  PRODUCTIONRESERVATIONCompanyInUsed) then
     PRODUCTIONRESERVATIONCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONORDERRESERVATION',  PRODUCTIONORDERRESERVATIONCompanyInUsed) then
     PRODUCTIONORDERRESERVATIONCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONDEMAND',  PRODUCTIONDEMANDCompanyInUsed) then
     PRODUCTIONDEMANDCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('REPLENISHMENTREQUISITION',  REPLENISHMENTREQUISITIONCompanyInUsed) then
     REPLENISHMENTREQUISITIONCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('INTERNALRETURNDOCUMENT',  INTERNALRETURNDOCUMENTCompanyInUsed) then
     INTERNALRETURNDOCUMENTCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('FULLITEMKEYDECODER',  FULLITEMKEYDECODERCompanyInUsed) then
     FULLITEMKEYDECODERCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('TOOL',  TOOLCompanyInUsed) then
     TOOLCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('SALESDOCUMENTLINE',  SALESDOCUMENTLINECompanyInUsed) then
     SALESDOCUMENTLINECompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PURCHASEORDERDELIVERY',  PURCHASEORDERDELIVERYCompanyInUsed) then
     PURCHASEORDERDELIVERYCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('INTERNALORDERDELIVERY',  INTERNALORDERDELIVERYCompanyInUsed) then
     INTERNALORDERDELIVERYCompanyInUsed := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('INTERNALDOCUMENTLINE',  INTERNALDOCUMENTLINECompanyInUsed) then
     INTERNALDOCUMENTLINECompanyInUsed := IniAppGlobals.CompanyCode;

  if ConvertDateFormat = 2 then
  begin
     Result := 'SELECT INFOAREA, AVL.DUEDATE, AVL.LOGICALWAREHOUSECODE, AVL.ITEMTYPECODE, ' +
                  'AVL.SUBCODE01 as DECOSUBCODE01, AVL.SUBCODE02 as DECOSUBCODE02, AVL.SUBCODE03 as DECOSUBCODE03, AVL.SUBCODE04 as DECOSUBCODE04, AVL.SUBCODE05 as DECOSUBCODE05, AVL.SUBCODE06 as DECOSUBCODE06, ' +
                  'AVL.SUBCODE07 as DECOSUBCODE07, AVL.SUBCODE08 as DECOSUBCODE08, AVL.SUBCODE09 as DECOSUBCODE09, AVL.SUBCODE10 as DECOSUBCODE10, ' +
                  'AVL.CUSTOMERCODE, AVL.SUPPLIERCODE, AVL.PROJECTCODE, AVL.STATISTICALGROUPCODE, ' +
                  'SUM(AVL.BASEPRIMARYQUANTITYUNIT*AVL.STOCKTYPEMULTIPLIER) AS QTY, ' +
                  'FIKD.ABSUNIQUEID AS FIKD_ABSUNIQUEID, T.ABSUNIQUEID AS T_ABSUNIQUEID, ' +
                  'AVL.LOTCODE ' +
                  'FROM ( ' +

                  'SELECT ' + QuotedStr(_('Stock')) + ' AS INFOAREA, ';
                   if IniAppGlobals.BalanceViewToUseInAvailability = '' then
                     Result := Result + 'to_date(' + QuotedStr('19700101') + ',' + QuotedStr('YYYYMMDD') + ')' + ' AS DUEDATE, '
                   else
                     Result := Result + 'BL.DUEDATE, ';

                   Result := Result +
                  'BL.LOGICALWAREHOUSECODE, BL.ITEMTYPECODE, ' +
                  'BL.DECOSUBCODE01 AS SUBCODE01, BL.DECOSUBCODE02 AS SUBCODE02, BL.DECOSUBCODE03 AS SUBCODE03, ' +
               //   'SELECT ' + QuotedStr(_('Stock')) + ' AS INFOAREA, ' +
               //   'CAST(' + QuotedStr('1970-01-01') + ' AS DATE) AS DUEDATE, BL.LOGICALWAREHOUSECODE, BL.ITEMTYPECODE, ' +
               //   'to_date(' + QuotedStr('19700101') + ',' + QuotedStr('YYYYMMDD') + ')' + ' AS DUEDATE, BL.LOGICALWAREHOUSECODE, BL.ITEMTYPECODE, ' +
               //   'BL.DECOSUBCODE01 AS SUBCODE01, BL.DECOSUBCODE02 AS SUBCODE02, BL.DECOSUBCODE03 AS SUBCODE03, ' +
                  'BL.DECOSUBCODE04 AS SUBCODE04, BL.DECOSUBCODE05 AS SUBCODE05, BL.DECOSUBCODE06 AS SUBCODE06, ' +
                  'BL.DECOSUBCODE07 AS SUBCODE07, BL.DECOSUBCODE08 AS SUBCODE08, BL.DECOSUBCODE09 AS SUBCODE09, BL.DECOSUBCODE10 AS SUBCODE10, ' +
                  'BL.CUSTOMERCODE, BL.SUPPLIERCODE, BL.PROJECTCODE, BL.STATISTICALGROUPCODE, BL.STOCKTYPECODE, BL.BASEPRIMARYQUANTITYUNIT, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN =  ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER ';
                   if NETGROUP_IS_LOT_Handaled then
                     Result := Result + ' ,' + 'BL.LOTCODE '
                   else
                     Result := Result + ' ,' + QuotedStr(' ') + ' AS LOTCODE ';

                   if IniAppGlobals.BalanceViewToUseInAvailability = '' then
                    Result := Result + 'FROM BALANCE BL '
                   else
                    Result := Result + 'FROM '+IniAppGlobals.BalanceViewToUseInAvailability+' BL ';

                  Result := Result + ' JOIN STOCKTYPE ST ON ST.CODE = BL.STOCKTYPECODE ' +
                  'WHERE BL.COMPANYCODE = ' + QuotedStr(BalanceCompanyInUsed) + ' ' +
                  'AND BL.ITEMTYPECODE IN (' + balanceHandledItemTypeCodes + ')' + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Allocation')) + ' AS INFOAREA, ' +
                  'AL.THEORETICISSUEDATE AS DUEDATE, AL.LOGICALWAREHOUSECODE, AL.ITEMTYPECODE, ' +
                  'AL.DECOSUBCODE01 AS SUBCODE01, AL.DECOSUBCODE02 AS SUBCODE02, AL.DECOSUBCODE03 AS SUBCODE03, AL.DECOSUBCODE04 AS SUBCODE04, ' +
                  'AL.DECOSUBCODE05 AS SUBCODE05, AL.DECOSUBCODE06 AS SUBCODE06, AL.DECOSUBCODE07 AS SUBCODE07, AL.DECOSUBCODE08 AS SUBCODE08, ' +
                  'AL.DECOSUBCODE09 AS SUBCODE09, AL.DECOSUBCODE10 AS SUBCODE10, ' +
                  'AL.CUSTOMERCODE, AL.SUPPLIERCODE, AL.PROJECTCODE, AL.STATISTICALGROUPCODE, AL.STOCKTYPECODE, ' +
                  'COALESCE(AL.BASEPRIMARYQUANTITY, 0.0) - COALESCE(AL.BASEPRIMARYUSEDQUANTITY, 0.0) AS BASEPRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER ';
                   if NETGROUP_IS_LOT_Handaled then
                     Result := Result + ' ,' + 'AL.LOTCODE '
                   else
                     Result := Result + ' ,' + QuotedStr(' ') + ' AS LOTCODE ';
                   Result := Result +
                  'FROM ALLOCATION AL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = AL.STOCKTYPECODE ' +
                  'WHERE AL.COMPANYCODE = ' + QuotedStr(AllocationCompanyInUsed) + ' ' +
                  'AND AL.ITEMTYPECODE IN (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND AL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Sales delivery')) + ' AS INFOAREA, ' +
                  'SOD.RESERVATIONDATE AS DUEDATE,  SOD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, SOD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'SI.INTERNALSUBCODE01 AS SUBCODE01, SI.INTERNALSUBCODE02 AS SUBCODE02, SI.INTERNALSUBCODE03 AS SUBCODE03, ' +
                  'SI.INTERNALSUBCODE04 AS SUBCODE04, SI.INTERNALSUBCODE05 AS SUBCODE05, SI.INTERNALSUBCODE06 AS SUBCODE06, ' +
                  'SI.INTERNALSUBCODE07 AS SUBCODE07, SI.INTERNALSUBCODE08 AS SUBCODE08, SI.INTERNALSUBCODE09 AS SUBCODE09, SI.INTERNALSUBCODE10 AS SUBCODE10, ' +
                  'SO.ORDPRNCUSTOMERSUPPLIERCODE AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, SOD.PROJECTCODE, SOD.STATISTICALGROUPCODE, SOD.STOCKTYPECODE, ' +
                  'COALESCE(SOD.BASEPRIMARYQUANTITY, 0.0) -  COALESCE(SOD.USEDBASEPRIMARYQUANTITY, 0.0) -  COALESCE(SOD.CANCELLEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM SALESORDERDELIVERY SOD ' +
                  'JOIN	STOCKTYPE ST ON ST.CODE = SOD.STOCKTYPECODE ' +
                  'JOIN SALESORDER SO ' +
                  'ON SO.COMPANYCODE = SOD.SALORDLINESALORDERCOMPANYCODE ' +
                  'AND SO.COUNTERCODE = SOD.SALORDLINESALORDERCOUNTERCODE ' +
                  'AND SO.CODE = SOD.SALESORDERLINESALESORDERCODE ' +
                  'JOIN SELLINGITEM SI ' +
                  'ON SI.COMPANYCODE = SOD.SALORDLINESALORDERCOMPANYCODE ' +
                  'AND SI.ITEMTYPECODE = SOD.ITEMTYPEAFICODE ' +
                  'AND SI.SUBCODE01 = SOD.SUBCODE01 ' +
                  'AND SI.SUBCODE02 = SOD.SUBCODE02 ' +
                  'AND SI.SUBCODE03 = SOD.SUBCODE03 ' +
                  'AND SI.SUBCODE04 = SOD.SUBCODE04 ' +
                  'AND SI.SUBCODE05 = SOD.SUBCODE05 ' +
                  'AND SI.SUBCODE06 = SOD.SUBCODE06 ' +
                  'AND SI.SUBCODE07 = SOD.SUBCODE07 ' +
                  'AND SI.SUBCODE08 = SOD.SUBCODE08 ' +
                  'AND SI.SUBCODE09 = SOD.SUBCODE09 ' +
                  'AND SI.SUBCODE10 = SOD.SUBCODE10 ' +
                  'WHERE SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(SalesOrderDeliveryCompanyInUsed) +
                  'AND SOD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND SOD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND SOD.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Sales delivery consignment')) + ' AS INFOAREA, ' +
                  'SOD.RESERVATIONDATE AS DUEDATE, SOD.CONSIGNMENTWAREHOUSECODE AS LOGICALWAREHOUSECODE, SOD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'SI.INTERNALSUBCODE01 AS SUBCODE01, SI.INTERNALSUBCODE02 AS SUBCODE02, SI.INTERNALSUBCODE03 AS SUBCODE03, ' +
                  'SI.INTERNALSUBCODE04 AS SUBCODE04, SI.INTERNALSUBCODE05 AS SUBCODE05, ' +
                  'SI.INTERNALSUBCODE06 AS SUBCODE06, SI.INTERNALSUBCODE07 AS SUBCODE07, SI.INTERNALSUBCODE08 AS SUBCODE08, SI.INTERNALSUBCODE09 AS SUBCODE09, SI.INTERNALSUBCODE10 AS SUBCODE10, ' +
                  'SO.ORDPRNCUSTOMERSUPPLIERCODE AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, SOD.PROJECTCODE, SOD.STATISTICALGROUPCODE, SOD.STOCKTYPECODE, ' +
                  '(COALESCE(SOD.BASEPRIMARYQUANTITY, 0.0) -  COALESCE(SOD.USEDBASEPRIMARYQUANTITY, 0.0) -  COALESCE(SOD.CANCELLEDBASEPRIMARYQUANTITY, 0.0)) * -1.0 AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM SALESORDERDELIVERY SOD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = SOD.STOCKTYPECODE ' +
                  'JOIN SALESORDER SO ' +
                  'ON SO.COMPANYCODE = SOD.SALORDLINESALORDERCOMPANYCODE ' +
                  'AND SO.COUNTERCODE = SOD.SALORDLINESALORDERCOUNTERCODE ' +
                  'AND SO.CODE = SOD.SALESORDERLINESALESORDERCODE ' +
                  'JOIN SELLINGITEM SI ' +
                  'ON SI.COMPANYCODE = SOD.SALORDLINESALORDERCOMPANYCODE ' +
                  'AND SI.ITEMTYPECODE = SOD.ITEMTYPEAFICODE ' +
                  'AND SI.SUBCODE01 = SOD.SUBCODE01 ' +
                  'AND SI.SUBCODE02 = SOD.SUBCODE02 ' +
                  'AND SI.SUBCODE03 = SOD.SUBCODE03 ' +
                  'AND SI.SUBCODE04 = SOD.SUBCODE04 ' +
                  'AND SI.SUBCODE05 = SOD.SUBCODE05 ' +
                  'AND SI.SUBCODE06 = SOD.SUBCODE06 ' +
                  'AND SI.SUBCODE07 = SOD.SUBCODE07 ' +
                  'AND SI.SUBCODE08 = SOD.SUBCODE08 ' +
                  'AND SI.SUBCODE09 = SOD.SUBCODE09 ' +
                  'AND SI.SUBCODE10 = SOD.SUBCODE10 ' +
                  'WHERE SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(SALORDLINESALORDERCompanyInUsed) + ' ' +
                  'AND SOD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND SOD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND SOD.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +
                  'AND SOD.CONSIGNMENTTYPE IN (' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Sales document')) + ' AS INFOAREA, ' +
                  'COALESCE(SD.DEFINITIVEDOCUMENTDATE, SD.PROVISIONALDOCUMENTDATE) AS DUEDAT,  SD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, SDL.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'SI.INTERNALSUBCODE01 AS SUBCODE01, SI.INTERNALSUBCODE02 AS SUBCODE02, SI.INTERNALSUBCODE03 AS SUBCODE03, SI.INTERNALSUBCODE04 AS SUBCODE04, ' +
                  'SI.INTERNALSUBCODE05 AS SUBCODE05, SI.INTERNALSUBCODE06 AS SUBCODE06, SI.INTERNALSUBCODE07 AS SUBCODE07, SI.INTERNALSUBCODE08 AS SUBCODE08, ' +
                  'SI.INTERNALSUBCODE09 AS SUBCODE09, SI.INTERNALSUBCODE10 AS SUBCODE10, ' +
                  'SD.ORDPRNCUSTOMERSUPPLIERCODE AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, SDL.PROJECTCODE, SDL.STATISTICALGROUPCODE, SDL.STOCKTYPECODE, ' +
                  'COALESCE(SDL.BASEPRIMARYQUANTITY, 0.0) - COALESCE(SDL.SHIPPEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                    QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM SALESDOCUMENTLINE SDL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = SDL.STOCKTYPECODE ' +
                  'JOIN SALESDOCUMENT SD ' +
                  'ON	SD.COMPANYCODE = SDL.SALESDOCUMENTCOMPANYCODE ' +
                  'AND SD.PROVISIONALCOUNTERCODE = SDL.SALDOCPROVISIONALCOUNTERCODE ' +
                  'AND SD.PROVISIONALCODE = SDL.SALESDOCUMENTPROVISIONALCODE ' +
                  'JOIN SELLINGITEM SI ' +
                  'ON SI.COMPANYCODE = SDL.SALESDOCUMENTCOMPANYCODE ' +
                  'AND SI.ITEMTYPECODE = SDL.ITEMTYPEAFICODE ' +
                  'AND SI.SUBCODE01 = SDL.SUBCODE01 ' +
                  'AND SI.SUBCODE02 = SDL.SUBCODE02 ' +
                  'AND SI.SUBCODE03 = SDL.SUBCODE03 ' +
                  'AND SI.SUBCODE04 = SDL.SUBCODE04 ' +
                  'AND SI.SUBCODE05 = SDL.SUBCODE05 ' +
                  'AND SI.SUBCODE06 = SDL.SUBCODE06 ' +
                  'AND SI.SUBCODE07 = SDL.SUBCODE07 ' +
                  'AND SI.SUBCODE08 = SDL.SUBCODE08 ' +
                  'AND SI.SUBCODE09 = SDL.SUBCODE09 ' +
                  'AND SI.SUBCODE10 = SDL.SUBCODE10 ' +
                  'WHERE SDL.SALESDOCUMENTPROVISIONALCODE = ' + QuotedStr(SALESDOCUMENTLINECompanyInUsed) + ' ' +
                  'AND SDL.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND SDL.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +
                  'AND SDL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND SD.DOCUMENTTYPETYPE IN (' + QuotedStr('05') + ',' + QuotedStr('07') + ',' + QuotedStr('08') + ',' + QuotedStr('10') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Sales document consignment')) +  ' AS INFOAREA, ' +
                  'COALESCE(SD.DEFINITIVEDOCUMENTDATE, SD.PROVISIONALDOCUMENTDATE) AS DUEDAT,  SD.CONSIGNMENTWAREHOUSECODE AS LOGICALWAREHOUSECODE, SDL.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'SI.INTERNALSUBCODE01 AS SUBCODE01, SI.INTERNALSUBCODE02 AS SUBCODE02, SI.INTERNALSUBCODE03 AS SUBCODE03, SI.INTERNALSUBCODE04 AS SUBCODE04, SI.INTERNALSUBCODE05 AS SUBCODE05, ' +
                  'SI.INTERNALSUBCODE06 AS SUBCODE06, SI.INTERNALSUBCODE07 AS SUBCODE07, SI.INTERNALSUBCODE08 AS SUBCODE08, SI.INTERNALSUBCODE09 AS SUBCODE09, SI.INTERNALSUBCODE10 AS SUBCODE10, ' +
                  'SD.ORDPRNCUSTOMERSUPPLIERCODE AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, SDL.PROJECTCODE, SDL.STATISTICALGROUPCODE, SDL.STOCKTYPECODE, ' +
                  '(COALESCE(SDL.BASEPRIMARYQUANTITY, 0.0) - COALESCE(SDL.SHIPPEDBASEPRIMARYQUANTITY, 0.0)) * -1.0 AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM SALESDOCUMENTLINE SDL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = SDL.STOCKTYPECODE ' +
                  'JOIN SALESDOCUMENT SD ' +
                  'ON SD.COMPANYCODE = SDL.SALESDOCUMENTCOMPANYCODE ' +
                  'AND SD.PROVISIONALCOUNTERCODE = SDL.SALDOCPROVISIONALCOUNTERCODE ' +
                  'AND SD.PROVISIONALCODE = SDL.SALESDOCUMENTPROVISIONALCODE ' +
                  'JOIN SELLINGITEM SI ' +
                  'ON SI.COMPANYCODE = SDL.SALESDOCUMENTCOMPANYCODE ' +
                  'AND	SI.ITEMTYPECODE = SDL.ITEMTYPEAFICODE ' +
                  'AND SI.SUBCODE01 = SDL.SUBCODE01 ' +
                  'AND SI.SUBCODE02 = SDL.SUBCODE02 ' +
                  'AND SI.SUBCODE03 = SDL.SUBCODE03 ' +
                  'AND SI.SUBCODE04 = SDL.SUBCODE04 ' +
                  'AND SI.SUBCODE05 = SDL.SUBCODE05 ' +
                  'AND SI.SUBCODE06 = SDL.SUBCODE06 ' +
                  'AND SI.SUBCODE07 = SDL.SUBCODE07 ' +
                  'AND SI.SUBCODE08 = SDL.SUBCODE08 ' +
                  'AND SI.SUBCODE09 = SDL.SUBCODE09 ' +
                  'AND SI.SUBCODE10 = SDL.SUBCODE10 ' +
                  'WHERE SDL.SALESDOCUMENTPROVISIONALCODE = ' + QuotedStr(SALESDOCUMENTLINECompanyInUsed) + ' ' +
                  'AND SDL.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND SDL.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +
                  'AND SDL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND SD.DOCUMENTTYPETYPE IN (' + QuotedStr('05') + ',' + QuotedStr('07') + ',' + QuotedStr('08') + ',' + QuotedStr('10') + ') ' +
                  'AND SDL.CONSIGNMENTTYPE IN (' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Sales release')) + ' AS INFOAREA, ' +
                  'SRL.RELEASEDATE AS DUEDATE,  SRL.WAREHOUSECODE AS LOGICALWAREHOUSECODE, SRL.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'SI.INTERNALSUBCODE01 AS SUBCODE01, SI.INTERNALSUBCODE02 AS SUBCODE02, SI.INTERNALSUBCODE03 AS SUBCODE03, SI.INTERNALSUBCODE04 AS SUBCODE04, ' +
                  'SI.INTERNALSUBCODE05 AS SUBCODE05, SI.INTERNALSUBCODE06 AS SUBCODE06, SI.INTERNALSUBCODE07 AS SUBCODE07, SI.INTERNALSUBCODE08 AS SUBCODE08, ' +
                  'SI.INTERNALSUBCODE09 AS SUBCODE09, SI.INTERNALSUBCODE10 AS SUBCODE10, ' +
                  'SRL.ORDPRNCUSTOMERSUPPLIERCODE AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, SRL.PROJECTCODE, SRL.STATISTICALGROUPCODE, SRL.STOCKTYPECODE, ' +
                  'COALESCE(SRL.RELEASEBASEPRIMARYQUANTITY, 0.0) - COALESCE(SRL.USEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM SALESRELEASELINE SRL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = SRL.STOCKTYPECODE ' +
                  'JOIN SELLINGITEM SI ' +
                  'ON SI.COMPANYCODE = SRL.COMPANYCODE ' +
                  'AND SI.ITEMTYPECODE = SRL.ITEMTYPEAFICODE ' +
                  'AND SI.SUBCODE01 = SRL.SUBCODE01 ' +
                  'AND SI.SUBCODE02 = SRL.SUBCODE02 ' +
                  'AND SI.SUBCODE03 = SRL.SUBCODE03 ' +
                  'AND SI.SUBCODE04 = SRL.SUBCODE04 ' +
                  'AND SI.SUBCODE05 = SRL.SUBCODE05 ' +
                  'AND SI.SUBCODE06 = SRL.SUBCODE06 ' +
                  'AND SI.SUBCODE07 = SRL.SUBCODE07 ' +
                  'AND SI.SUBCODE08 = SRL.SUBCODE08 ' +
                  'AND SI.SUBCODE09 = SRL.SUBCODE09 ' +
                  'AND SI.SUBCODE10 = SRL.SUBCODE10 ' +
                  'WHERE SRL.COMPANYCODE = ' + QuotedStr(SALESRELEASELINECompanyInUsed) + ' ' +
                  'AND SRL.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND SRL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Purchase delivery')) + ' AS INFOAREA, ' +
                  'POD.RESERVATIONDATE AS DUEDATE, POD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, POD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'POD.SUBCODE01, POD.SUBCODE02, POD.SUBCODE03, POD.SUBCODE04, POD.SUBCODE05, ' +
                  'POD.SUBCODE06, POD.SUBCODE07, POD.SUBCODE08, POD.SUBCODE09, POD.SUBCODE10, ' +
                   QuotedStr(' ') + ' AS CUSTOMERCODE, PO.ORDPRNCUSTOMERSUPPLIERCODE AS SUPPLIERCODE, POD.PROJECTCODE, POD.STATISTICALGROUPCODE, POD.STOCKTYPECODE, ' +
                  'COALESCE(POD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(POD.USEDBASEPRIMARYQUANTITY, 0.0) - COALESCE(POD.CANCELLEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ';

                  if IniAppGlobals.VIEWTLSPODUpdateDeliveryDate = '' then
                    Result := Result + 'FROM PURCHASEORDERDELIVERY POD '
                  else
                    Result := Result + ' FROM ' + IniAppGlobals.VIEWTLSPODUpdateDeliveryDate + ' POD ';

                  Result := Result +

               //   'FROM PURCHASEORDERDELIVERY POD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = POD.STOCKTYPECODE ' +
                  'JOIN PURCHASEORDER PO ' +
                  'ON PO.COMPANYCODE = POD.PURORDLINEPURORDERCOMPANYCODE ' +
                  'AND PO.COUNTERCODE = POD.PURORDLINEPURORDERCOUNTERCODE ' +
                  'AND PO.CODE = POD.PURORDERLINEPURCHASEORDERCODE ' +
                  'WHERE POD.PURORDLINEPURORDERCOMPANYCODE = ' + QuotedStr(PURCHASEORDERDELIVERYCompanyInUsed) + ' ' +
                  'AND POD.ITEMTYPEAFICODE IN (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND POD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND POD.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Internal order from')) + ' AS INFOAREA, ' +
                  'IOD.DELIVERYDATE AS DUEDATE, IOD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, IOD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'IOD.SUBCODE01, IOD.SUBCODE02, IOD.SUBCODE03, IOD.SUBCODE04, IOD.SUBCODE05, ' +
                  'IOD.SUBCODE06, IOD.SUBCODE07, IOD.SUBCODE08, IOD.SUBCODE09, IOD.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, IOD.PROJECTCODE, IOD.STATISTICALGROUPCODE, IOD.STOCKTYPECODE, ' +
                  'COALESCE(IOD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(IOD.USEDBASEPRIMARYQUANTITY, 0.0) - COALESCE(IOD.CANCELLEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM INTERNALORDERDELIVERY IOD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = IOD.STOCKTYPECODE ' +
                  'WHERE IOD.INTORDLINEINTORDERCOMPANYCODE = ' + QuotedStr(INTERNALORDERDELIVERYCompanyInUsed) + ' ' +
                  'AND IOD.ITEMTYPEAFICODE IN (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND IOD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND IOD.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Internal order to')) + ' AS INFOAREA, ' +
                  'IOD.DELIVERYDATE AS DUEDATE, IOD.DESTINATIONWAREHOUSECODE AS LOGICALWAREHOUSECODE, IOD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'IOD.SUBCODE01, IOD.SUBCODE02, IOD.SUBCODE03, IOD.SUBCODE04, IOD.SUBCODE05, ' +
                  'IOD.SUBCODE06, IOD.SUBCODE07, IOD.SUBCODE08, IOD.SUBCODE09, IOD.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, IOD.PROJECTCODE, IOD.STATISTICALGROUPCODE, IOD.RESERVATIONSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(IOD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(IOD.USEDBASEPRIMARYQUANTITY, 0.0) - COALESCE(IOD.CANCELLEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = '  + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM INTERNALORDERDELIVERY IOD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = IOD.RESERVATIONSTOCKTYPECODE ' +
                  'WHERE IOD.INTORDLINEINTORDERCOMPANYCODE = ' + QuotedStr(INTERNALORDERDELIVERYCompanyInUsed) + ' ' +
                  'AND IOD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND IOD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND IOD.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Internal document from')) + ' AS INFOAREA, ' +
                  'COALESCE(ID.DEFINITIVEDOCUMENTDATE, ID.PROVISIONALDOCUMENTDATE) AS DUEDATE,	IDL.WAREHOUSECODE AS LOGICALWAREHOUSECODE, IDL.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'IDL.SUBCODE01, IDL.SUBCODE02, IDL.SUBCODE03, IDL.SUBCODE04, IDL.SUBCODE05, ' +
                  'IDL.SUBCODE06, IDL.SUBCODE07, IDL.SUBCODE08, IDL.SUBCODE09, IDL.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, IDL.PROJECTCODE, IDL.STATISTICALGROUPCODE, IDL.STOCKTYPECODE, ' +
                  'COALESCE(IDL.BASEPRIMARYQUANTITY, 0.0) - COALESCE(IDL.SHIPPEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM INTERNALDOCUMENTLINE IDL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = IDL.STOCKTYPECODE ' +
                  'JOIN INTERNALDOCUMENT ID ' +
                  'ON ID.COMPANYCODE = IDL.INTERNALDOCUMENTCOMPANYCODE ' +
                  'AND ID.PROVISIONALCOUNTERCODE = IDL.INTDOCPROVISIONALCOUNTERCODE ' +
                  'AND ID.PROVISIONALCODE = IDL.INTDOCUMENTPROVISIONALCODE ' +
                  'WHERE IDL.INTERNALDOCUMENTCOMPANYCODE = ' + QuotedStr(INTERNALDOCUMENTLINECompanyInUsed) + ' ' +
                  'AND IDL.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND IDL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND IDL.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Internal document to')) + ' AS INFOAREA, ' +
                  'COALESCE(ID.DEFINITIVEDOCUMENTDATE, ID.PROVISIONALDOCUMENTDATE) AS DUEDATE,	IDL.DESTINATIONWAREHOUSECODE AS LOGICALWAREHOUSECODE, IDL.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'IDL.SUBCODE01, IDL.SUBCODE02, IDL.SUBCODE03, IDL.SUBCODE04, IDL.SUBCODE05, ' +
                  'IDL.SUBCODE06, IDL.SUBCODE07, IDL.SUBCODE08, IDL.SUBCODE09, IDL.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, IDL.PROJECTCODE, IDL.STATISTICALGROUPCODE, IDL.RECEIVINGSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(IDL.BASEPRIMARYQUANTITY, 0.0) - COALESCE(IDL.SHIPPEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM INTERNALDOCUMENTLINE IDL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = IDL.RECEIVINGSTOCKTYPECODE ' +
                  'JOIN INTERNALDOCUMENT ID ' +
                  'ON ID.COMPANYCODE = IDL.INTERNALDOCUMENTCOMPANYCODE ' +
                  'AND ID.PROVISIONALCOUNTERCODE = IDL.INTDOCPROVISIONALCOUNTERCODE ' +
                  'AND ID.PROVISIONALCODE = IDL.INTDOCUMENTPROVISIONALCODE ' +
                  'WHERE IDL.INTERNALDOCUMENTCOMPANYCODE = ' + QuotedStr(INTERNALDOCUMENTLINECompanyInUsed) + ' ' +
                  'AND IDL.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND IDL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND IDL.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Purchase document return')) + ' AS INFOAREA, ' +
                  'PRD.RETURNDATE AS DUEDATE, PRD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, PRD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'PRD.SUBCODE01, PRD.SUBCODE02, PRD.SUBCODE03, PRD.SUBCODE04, PRD.SUBCODE05, ' +
                  'PRD.SUBCODE06, PRD.SUBCODE07, PRD.SUBCODE08, PRD.SUBCODE09, PRD.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, PRD.ORDPRNCUSTOMERSUPPLIERCODE AS SUPPLIERCODE, PRD.PROJECTCODE, PRD.STATISTICALGROUPCODE, PRD.RETURNSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(PRD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PRD.SHIPPEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PURCHASERETURNDOCUMENT PRD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = PRD.RETURNSTOCKTYPECODE ' +
                  'WHERE PRD.COMPANYCODE = ' + QuotedStr(PURCHASERETURNDOCUMENTCompanyInUsed) + ' ' +
                  'AND PRD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND PRD.RETURNSTATUS IN (' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Reservation')) + ' AS INFOAREA, ' +
                  'PR.ISSUEDATE AS DUEDATE, ' +
                  'CASE WHEN PR.SUBCONTRACTORWAREHOUSECODE <> ' + QuotedStr(' ') + ' THEN PR.SUBCONTRACTORWAREHOUSECODE ELSE PR.WAREHOUSECODE END LOGICALWAREHOUSECODE, PR.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'PR.SUBCODE01, PR.SUBCODE02, PR.SUBCODE03, PR.SUBCODE04, PR.SUBCODE05, PR.SUBCODE06, PR.SUBCODE07, PR.SUBCODE08, PR.SUBCODE09, PR.SUBCODE10, ' +
                  'CASE WHEN PR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('1') + ' THEN PR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + ' END AS CUSTOMERCODE, ' +
                  'CASE WHEN PR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('2') +  ' THEN PR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + '  END AS SUPPLIERCODE, ' +
                  'PR.PROJECTCODE, PR.STATISTICALGROUPCODE, PR.STOCKTYPECODE, ' +
                  'CASE WHEN PR.SUBCONTRACTORWAREHOUSECODE <> ' + QuotedStr(' ') + ' AND PR.WAREHOUSECODE IS NOT NULL AND PR.WAREHOUSECODE <> ' + QuotedStr(' ') + ' ' +
                  'THEN (COALESCE(PR.USEDBASEPRIMARYQUANTITY, 0.0) - COALESCE(PR.SBCUSEDBASEPRIMARYQUANTITY, 0.0)) ' +
                  'WHEN PR.SUBCONTRACTORWAREHOUSECODE <> ' + QuotedStr(' ') + ' AND (PR.WAREHOUSECODE IS NULL OR PR.WAREHOUSECODE = ' + QuotedStr(' ') + ')' + ' ' +
                  'THEN (COALESCE(PR.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PR.SBCUSEDBASEPRIMARYQUANTITY, 0.0)) ' +
                  'ELSE (COALESCE(PR.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PR.USEDBASEPRIMARYQUANTITY, 0.0)) ' +
                  'END PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PRODUCTIONRESERVATION PR ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = PR.STOCKTYPECODE ' +
                  'WHERE PR.COMPANYCODE = ' + QuotedStr(PRODUCTIONRESERVATIONCompanyInUsed) + ' ' +
                  'AND PR.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND PR.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND PR.RESERVATIONINGROUPORDER = ' + IntToStr(0) + ' ' +
                  'AND PR.SPLITTINGMANAGEMENT = ' + IntToStr(0) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Reservation')) + ' AS INFOAREA, ' +
                  'PRS.PERIODDATE AS DUEDATE, PR.WAREHOUSECODE AS LOGICALWAREHOUSECODE, PR.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'PR.SUBCODE01, PR.SUBCODE02, PR.SUBCODE03, PR.SUBCODE04, PR.SUBCODE05, ' +
                  'PR.SUBCODE06, PR.SUBCODE07, PR.SUBCODE08, PR.SUBCODE09, PR.SUBCODE10, ' +
                  'CASE WHEN PR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('1') + ' THEN PR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + ' END AS CUSTOMERCODE, ' +
                  'CASE WHEN PR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('2') + ' THEN PR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + ' END AS SUPPLIERCODE, ' +
                  'PR.PROJECTCODE, PR.STATISTICALGROUPCODE, PR.STOCKTYPECODE, ' +
                  'COALESCE(PRS.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PRS.USEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') +  ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PRODUCTIONRESERVATION PR ' + ' ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = PR.STOCKTYPECODE ' +
                  'JOIN PRODRESSPLITDATEQTY PRS ' +
                  'ON PRS.PRORESERVATIONCOMPANYCODE = PR.COMPANYCODE ' +
                  'AND PRS.PRORESERVATIONORDCOUNTERCODE = PR.ORDERCOUNTERCODE ' +
                  'AND PRS.PRODUCTIONRESERVATIONORDERCODE	= PR.ORDERCODE ' +
                  'AND PRS.PRORESERVATIONRESERVATIONLINE = PR.RESERVATIONLINE ' +
                  'WHERE PR.COMPANYCODE = ' + QuotedStr(PRODUCTIONRESERVATIONCompanyInUsed) + ' ' +
                  'AND PR.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND PR.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND PR.RESERVATIONINGROUPORDER = ' + IntToStr(0) + ' ' +
                  'AND PR.SPLITTINGMANAGEMENT = ' + IntToStr(1) + ' ' +
                  'AND	PR.WAREHOUSECODE <> ' + QuotedStr(' ') + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Reservation')) + ' AS INFOAREA, ' +
                  'POR.ISSUEDATE AS DUEDATE, POR.WAREHOUSECODE AS LOGICALWAREHOUSECODE, POR.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'POR.SUBCODE01, POR.SUBCODE02, POR.SUBCODE03, POR.SUBCODE04, POR.SUBCODE05, ' +
                  'POR.SUBCODE06, POR.SUBCODE07, POR.SUBCODE08, POR.SUBCODE09, POR.SUBCODE10, ' +
                  'CASE WHEN POR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('1') + ' THEN POR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + ' END AS CUSTOMERCODE, ' +
                  'CASE WHEN POR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('2') + ' THEN POR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + ' END AS SUPPLIERCODE, ' +
                  'POR.PROJECTCODE, POR.STATISTICALGROUPCODE, POR.STOCKTYPECODE, ' +
                  'COALESCE(POR.BASEPRIMARYQUANTITY, 0.0) - COALESCE(POR.USEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') +  ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PRODUCTIONORDERRESERVATION POR ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = POR.STOCKTYPECODE ' +
                  'WHERE POR.COMPANYCODE = ' + QuotedStr(PRODUCTIONORDERRESERVATIONCompanyInUsed) + ' ' +
                  'AND POR.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND POR.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND POR.SPLITTINGMANAGEMENT = ' + IntToStr(0) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Demand')) + ' AS INFOAREA, ' +
                  'PD.FINALPLANNEDDATE AS DUEDATE, PD.ENTRYWAREHOUSECODE AS LOGICALWAREHOUSECODE, PD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'PD.SUBCODE01, PD.SUBCODE02, PD.SUBCODE03, PD.SUBCODE04, PD.SUBCODE05, ' +
                  'PD.SUBCODE06, PD.SUBCODE07, PD.SUBCODE08, PD.SUBCODE09, PD.SUBCODE10, ' +
                  'PD.CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, PD.PROJECTCODE, PD.STATISTICALGROUPCODE, PD.PRDDEMANDSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(PD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PD.ENTEREDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PRODUCTIONDEMAND PD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = PD.PRDDEMANDSTOCKTYPECODE ' +
                  'WHERE PD.COMPANYCODE = ' + QuotedStr(PRODUCTIONDEMANDCompanyInUsed) + ' ' +
                  'AND PD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND PD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + ') ' +
                  'AND PD.SPLITTINGMANAGEMENT = ' + IntToStr(0) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Demand')) + ' AS INFOAREA, ' +
                  'PDS.PERIODDATE AS DUEDATE, PD.ENTRYWAREHOUSECODE AS LOGICALWAREHOUSECODE, PD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'PD.SUBCODE01, PD.SUBCODE02, PD.SUBCODE03, PD.SUBCODE04, PD.SUBCODE05, ' +
                  'PD.SUBCODE06, PD.SUBCODE07, PD.SUBCODE08, PD.SUBCODE09, PD.SUBCODE10, ' +
                  'PD.CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, PD.PROJECTCODE, PD.STATISTICALGROUPCODE, PD.PRDDEMANDSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(PDS.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PDS.USEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' +  QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PRODUCTIONDEMAND PD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = PD.PRDDEMANDSTOCKTYPECODE ' +
                  'JOIN PRODDEMANDSPLITDATEQTY PDS ' +
                  'ON PDS.PRODUCTIONDEMANDCOMPANYCODE = PD.COMPANYCODE ' +
                  'AND PDS.PRODUCTIONDEMANDCOUNTERCODE = PD.COUNTERCODE ' +
                  'AND PDS.PRODUCTIONDEMANDCODE = PD.CODE ' +
                  'WHERE PD.COMPANYCODE = ' + QuotedStr(PRODUCTIONDEMANDCompanyInUsed) + ' ' +
                  'AND PD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND PD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + ') ' +
                  'AND PD.SPLITTINGMANAGEMENT = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Requisition')) + ' AS INFOAREA, ' +
                  'RR.DELIVERYDATE AS DUEDATE, RR.DESTINATIONWAREHOUSECODE AS LOGICALWAREHOUSECODE, RR.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'RR.SUBCODE01, RR.SUBCODE02, RR.SUBCODE03, RR.SUBCODE04, RR.SUBCODE05, ' +
                  'RR.SUBCODE06, RR.SUBCODE07, RR.SUBCODE08, RR.SUBCODE09, RR.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, RR.CUSTOMERSUPPLIERCODE AS SUPPLIERCODE, RR.PROJECTCODE, RR.STATISTICALGROUPINGCODE AS STATISTICALGROUPCODE, RR.STOCKTYPECODE, ' +
                  'COALESCE(RR.ORDERBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM REPLENISHMENTREQUISITION RR ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = RR.STOCKTYPECODE ' +
                  'WHERE RR.COMPANYCODE = ' + QuotedStr(REPLENISHMENTREQUISITIONCompanyInUsed) + ' ' +
                  'AND RR.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND RR.RELEASELEVEL IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Internal document retrun')) + ' AS INFOAREA, ' +
                  'IRD.RETURNDATE AS DUEDATE, IRD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, IRD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'IRD.SUBCODE01, IRD.SUBCODE02, IRD.SUBCODE03, IRD.SUBCODE04, IRD.SUBCODE05, ' +
                  'IRD.SUBCODE06, IRD.SUBCODE07, IRD.SUBCODE08, IRD.SUBCODE09, IRD.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, IRD.PROJECTCODE, IRD.STATISTICALGROUPCODE, IRD.RETURNSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(IRD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(IRD.SHIPPEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM INTERNALRETURNDOCUMENT IRD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = IRD.RETURNSTOCKTYPECODE ' +
                  'WHERE IRD.COMPANYCODE = ' + QuotedStr(INTERNALRETURNDOCUMENTCompanyInUsed) +
                  'AND IRD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND IRD.RETURNSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ') ' +

                  ') AVL ' +

                  'LEFT JOIN FULLITEMKEYDECODER FIKD ' +
                  'ON FIKD.COMPANYCODE = ' + QuotedStr(FULLITEMKEYDECODERCompanyInUsed) + ' ' +
                  'AND FIKD.ITEMTYPECODE = AVL.ITEMTYPECODE ' +
                  'AND FIKD.SUBCODE01 = AVL.SUBCODE01 ' +
                  'AND FIKD.SUBCODE02 = AVL.SUBCODE02 ' +
                  'AND FIKD.SUBCODE03 = AVL.SUBCODE03 ' +
                  'AND FIKD.SUBCODE04 = AVL.SUBCODE04 ' +
                  'AND FIKD.SUBCODE05 = AVL.SUBCODE05 ' +
                  'AND FIKD.SUBCODE06 = AVL.SUBCODE06 ' +
                  'AND FIKD.SUBCODE07 = AVL.SUBCODE07 ' +
                  'AND FIKD.SUBCODE08 = AVL.SUBCODE08 ' +
                  'AND FIKD.SUBCODE09 = AVL.SUBCODE09 ' +
                  'AND FIKD.SUBCODE10 = AVL.SUBCODE10 ' +
                  'LEFT JOIN TOOL T ' +
                  'ON	T.COMPANYCODE = ' + QuotedStr(TOOLCompanyInUsed) + ' ' +
                  'AND T.ITEMTYPECODE = AVL.ITEMTYPECODE ' +
                  'AND T.SUBCODE01 = AVL.SUBCODE01 ' +

                  'WHERE AVL.STOCKTYPECODE IN  (' + STOCKTYPECODES + ') ' + ' AND (FIKD.ABSUNIQUEID > ' + IntToStr(0) + ' OR T.ABSUNIQUEID > ' + IntToStr(0) + ' ) ' +

                  'GROUP BY AVL.INFOAREA, AVL.DUEDATE, AVL.LOGICALWAREHOUSECODE, AVL.ITEMTYPECODE, AVL.SUBCODE01, AVL.SUBCODE02, AVL.SUBCODE03, AVL.SUBCODE04, AVL.SUBCODE05, ' +
                  'AVL.SUBCODE06, AVL.SUBCODE07, AVL.SUBCODE08, AVL.SUBCODE09, AVL.SUBCODE10, AVL.CUSTOMERCODE, AVL.SUPPLIERCODE, AVL.PROJECTCODE, AVL.STATISTICALGROUPCODE, ' +
                  'FIKD.ABSUNIQUEID,  T.ABSUNIQUEID, AVL.LOTCODE ';  // , AVL.LOTCODE

  end
  else
  begin
    Result := 'SELECT INFOAREA, AVL.DUEDATE, AVL.LOGICALWAREHOUSECODE, AVL.ITEMTYPECODE, ' +
                  'AVL.SUBCODE01 as DECOSUBCODE01, AVL.SUBCODE02 as DECOSUBCODE02, AVL.SUBCODE03 as DECOSUBCODE03, AVL.SUBCODE04 as DECOSUBCODE04, AVL.SUBCODE05 as DECOSUBCODE05, AVL.SUBCODE06 as DECOSUBCODE06, ' +
                  'AVL.SUBCODE07 as DECOSUBCODE07, AVL.SUBCODE08 as DECOSUBCODE08, AVL.SUBCODE09 as DECOSUBCODE09, AVL.SUBCODE10 as DECOSUBCODE10, ' +
                  'AVL.CUSTOMERCODE, AVL.SUPPLIERCODE, AVL.PROJECTCODE, AVL.STATISTICALGROUPCODE, ' +
                  'SUM(AVL.BASEPRIMARYQUANTITYUNIT*AVL.STOCKTYPEMULTIPLIER) AS QTY, ' +
                  'FIKD.ABSUNIQUEID AS FIKD_ABSUNIQUEID, T.ABSUNIQUEID AS T_ABSUNIQUEID, ' +
                  'AVL.LOTCODE ' +
                  'FROM ( ' +

                  'SELECT ' + QuotedStr(_('Stock')) + ' AS INFOAREA, ';
                   if IniAppGlobals.BalanceViewToUseInAvailability = '' then
                     Result := Result + 'to_date(' + QuotedStr('19700101') + ',' + QuotedStr('YYYYMMDD') + ')' + ' AS DUEDATE, '
                   else
                     Result := Result + 'BL.DUEDATE, ';

                   Result := Result +
                  'BL.LOGICALWAREHOUSECODE, BL.ITEMTYPECODE, ' +
                  'BL.DECOSUBCODE01 AS SUBCODE01, BL.DECOSUBCODE02 AS SUBCODE02, BL.DECOSUBCODE03 AS SUBCODE03, ' +
               {   'SELECT ' + QuotedStr(_('Stock')) + ' AS INFOAREA, ' +
               //   'CAST(' + QuotedStr('1970-01-01') + ' AS DATE) AS DUEDATE, BL.LOGICALWAREHOUSECODE, BL.ITEMTYPECODE, ' +
                //  'to_date(' + QuotedStr('19700101') + ',' + QuotedStr('YYYYMMDD') + ')' + ' AS DUEDATE, BL.LOGICALWAREHOUSECODE, BL.ITEMTYPECODE, ' +
                  'date(' + QuotedStr('1970-01-01') + ')' + ' AS DUEDATE, BL.LOGICALWAREHOUSECODE, BL.ITEMTYPECODE, ' +
                  'BL.DECOSUBCODE01 AS SUBCODE01, BL.DECOSUBCODE02 AS SUBCODE02, BL.DECOSUBCODE03 AS SUBCODE03, ' +   }
                  'BL.DECOSUBCODE04 AS SUBCODE04, BL.DECOSUBCODE05 AS SUBCODE05, BL.DECOSUBCODE06 AS SUBCODE06, ' +
                  'BL.DECOSUBCODE07 AS SUBCODE07, BL.DECOSUBCODE08 AS SUBCODE08, BL.DECOSUBCODE09 AS SUBCODE09, BL.DECOSUBCODE10 AS SUBCODE10, ' +
                  'BL.CUSTOMERCODE, BL.SUPPLIERCODE, BL.PROJECTCODE, BL.STATISTICALGROUPCODE, BL.STOCKTYPECODE, BL.BASEPRIMARYQUANTITYUNIT, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN =  ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER ';
                   if NETGROUP_IS_LOT_Handaled then
                     Result := Result + ' ,' + 'BL.LOTCODE '
                   else
                     Result := Result + ' ,' +  QuotedStr(' ') + ' AS LOTCODE ';

                   if IniAppGlobals.BalanceViewToUseInAvailability = '' then
                    Result := Result + 'FROM BALANCE BL '
                   else
                    Result := Result + 'FROM '+IniAppGlobals.BalanceViewToUseInAvailability+' BL ';

                  Result := Result + ' JOIN STOCKTYPE ST ON ST.CODE = BL.STOCKTYPECODE ' +
                  'WHERE BL.COMPANYCODE = ' + QuotedStr(BalanceCompanyInUsed) + ' ' +
                  'AND BL.ITEMTYPECODE IN (' + balanceHandledItemTypeCodes + ')' + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Allocation')) + ' AS INFOAREA, ' +
                  'AL.THEORETICISSUEDATE AS DUEDATE, AL.LOGICALWAREHOUSECODE, AL.ITEMTYPECODE, ' +
                  'AL.DECOSUBCODE01 AS SUBCODE01, AL.DECOSUBCODE02 AS SUBCODE02, AL.DECOSUBCODE03 AS SUBCODE03, AL.DECOSUBCODE04 AS SUBCODE04, ' +
                  'AL.DECOSUBCODE05 AS SUBCODE05, AL.DECOSUBCODE06 AS SUBCODE06, AL.DECOSUBCODE07 AS SUBCODE07, AL.DECOSUBCODE08 AS SUBCODE08, ' +
                  'AL.DECOSUBCODE09 AS SUBCODE09, AL.DECOSUBCODE10 AS SUBCODE10, ' +
                  'AL.CUSTOMERCODE, AL.SUPPLIERCODE, AL.PROJECTCODE, AL.STATISTICALGROUPCODE, AL.STOCKTYPECODE, ' +
                  'COALESCE(AL.BASEPRIMARYQUANTITY, 0.0) - COALESCE(AL.BASEPRIMARYUSEDQUANTITY, 0.0) AS BASEPRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER ';
                   if NETGROUP_IS_LOT_Handaled then
                     Result := Result + ' ,' + 'AL.LOTCODE '
                   else
                     Result := Result + ' ,' + QuotedStr(' ') + ' AS LOTCODE ';
                   Result := Result +
                  'FROM ALLOCATION AL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = AL.STOCKTYPECODE ' +
                  'WHERE AL.COMPANYCODE = ' + QuotedStr(AllocationCompanyInUsed) + ' ' +
                  'AND AL.ITEMTYPECODE IN (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND AL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Sales delivery')) + ' AS INFOAREA, ' +
                  'SOD.RESERVATIONDATE AS DUEDATE,  SOD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, SOD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'SI.INTERNALSUBCODE01 AS SUBCODE01, SI.INTERNALSUBCODE02 AS SUBCODE02, SI.INTERNALSUBCODE03 AS SUBCODE03, ' +
                  'SI.INTERNALSUBCODE04 AS SUBCODE04, SI.INTERNALSUBCODE05 AS SUBCODE05, SI.INTERNALSUBCODE06 AS SUBCODE06, ' +
                  'SI.INTERNALSUBCODE07 AS SUBCODE07, SI.INTERNALSUBCODE08 AS SUBCODE08, SI.INTERNALSUBCODE09 AS SUBCODE09, SI.INTERNALSUBCODE10 AS SUBCODE10, ' +
                  'SO.ORDPRNCUSTOMERSUPPLIERCODE AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, SOD.PROJECTCODE, SOD.STATISTICALGROUPCODE, SOD.STOCKTYPECODE, ' +
                  'COALESCE(SOD.BASEPRIMARYQUANTITY, 0.0) -  COALESCE(SOD.USEDBASEPRIMARYQUANTITY, 0.0) -  COALESCE(SOD.CANCELLEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM SALESORDERDELIVERY SOD ' +
                  'JOIN	STOCKTYPE ST ON ST.CODE = SOD.STOCKTYPECODE ' +
                  'JOIN SALESORDER SO ' +
                  'ON SO.COMPANYCODE = SOD.SALORDLINESALORDERCOMPANYCODE ' +
                  'AND SO.COUNTERCODE = SOD.SALORDLINESALORDERCOUNTERCODE ' +
                  'AND SO.CODE = SOD.SALESORDERLINESALESORDERCODE ' +
                  'JOIN SELLINGITEM SI ' +
                  'ON SI.COMPANYCODE = SOD.SALORDLINESALORDERCOMPANYCODE ' +
                  'AND SI.ITEMTYPECODE = SOD.ITEMTYPEAFICODE ' +
                  'AND SI.SUBCODE01 = SOD.SUBCODE01 ' +
                  'AND SI.SUBCODE02 = SOD.SUBCODE02 ' +
                  'AND SI.SUBCODE03 = SOD.SUBCODE03 ' +
                  'AND SI.SUBCODE04 = SOD.SUBCODE04 ' +
                  'AND SI.SUBCODE05 = SOD.SUBCODE05 ' +
                  'AND SI.SUBCODE06 = SOD.SUBCODE06 ' +
                  'AND SI.SUBCODE07 = SOD.SUBCODE07 ' +
                  'AND SI.SUBCODE08 = SOD.SUBCODE08 ' +
                  'AND SI.SUBCODE09 = SOD.SUBCODE09 ' +
                  'AND SI.SUBCODE10 = SOD.SUBCODE10 ' +
                  'WHERE SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(SalesOrderDeliveryCompanyInUsed) +
                  'AND SOD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND SOD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND SOD.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Sales delivery consignment')) + ' AS INFOAREA, ' +
                  'SOD.RESERVATIONDATE AS DUEDATE, SOD.CONSIGNMENTWAREHOUSECODE AS LOGICALWAREHOUSECODE, SOD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'SI.INTERNALSUBCODE01 AS SUBCODE01, SI.INTERNALSUBCODE02 AS SUBCODE02, SI.INTERNALSUBCODE03 AS SUBCODE03, ' +
                  'SI.INTERNALSUBCODE04 AS SUBCODE04, SI.INTERNALSUBCODE05 AS SUBCODE05, ' +
                  'SI.INTERNALSUBCODE06 AS SUBCODE06, SI.INTERNALSUBCODE07 AS SUBCODE07, SI.INTERNALSUBCODE08 AS SUBCODE08, SI.INTERNALSUBCODE09 AS SUBCODE09, SI.INTERNALSUBCODE10 AS SUBCODE10, ' +
                  'SO.ORDPRNCUSTOMERSUPPLIERCODE AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, SOD.PROJECTCODE, SOD.STATISTICALGROUPCODE, SOD.STOCKTYPECODE, ' +
                  '(COALESCE(SOD.BASEPRIMARYQUANTITY, 0.0) -  COALESCE(SOD.USEDBASEPRIMARYQUANTITY, 0.0) -  COALESCE(SOD.CANCELLEDBASEPRIMARYQUANTITY, 0.0)) * -1.0 AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM SALESORDERDELIVERY SOD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = SOD.STOCKTYPECODE ' +
                  'JOIN SALESORDER SO ' +
                  'ON SO.COMPANYCODE = SOD.SALORDLINESALORDERCOMPANYCODE ' +
                  'AND SO.COUNTERCODE = SOD.SALORDLINESALORDERCOUNTERCODE ' +
                  'AND SO.CODE = SOD.SALESORDERLINESALESORDERCODE ' +
                  'JOIN SELLINGITEM SI ' +
                  'ON SI.COMPANYCODE = SOD.SALORDLINESALORDERCOMPANYCODE ' +
                  'AND SI.ITEMTYPECODE = SOD.ITEMTYPEAFICODE ' +
                  'AND SI.SUBCODE01 = SOD.SUBCODE01 ' +
                  'AND SI.SUBCODE02 = SOD.SUBCODE02 ' +
                  'AND SI.SUBCODE03 = SOD.SUBCODE03 ' +
                  'AND SI.SUBCODE04 = SOD.SUBCODE04 ' +
                  'AND SI.SUBCODE05 = SOD.SUBCODE05 ' +
                  'AND SI.SUBCODE06 = SOD.SUBCODE06 ' +
                  'AND SI.SUBCODE07 = SOD.SUBCODE07 ' +
                  'AND SI.SUBCODE08 = SOD.SUBCODE08 ' +
                  'AND SI.SUBCODE09 = SOD.SUBCODE09 ' +
                  'AND SI.SUBCODE10 = SOD.SUBCODE10 ' +
                  'WHERE SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(SALORDLINESALORDERCompanyInUsed) + ' ' +
                  'AND SOD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND SOD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND SOD.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +
                  'AND SOD.CONSIGNMENTTYPE IN (' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Sales document')) + ' AS INFOAREA, ' +
                  'COALESCE(SD.DEFINITIVEDOCUMENTDATE, SD.PROVISIONALDOCUMENTDATE) AS DUEDATE,  SD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, SDL.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'SI.INTERNALSUBCODE01 AS SUBCODE01, SI.INTERNALSUBCODE02 AS SUBCODE02, SI.INTERNALSUBCODE03 AS SUBCODE03, SI.INTERNALSUBCODE04 AS SUBCODE04, ' +
                  'SI.INTERNALSUBCODE05 AS SUBCODE05, SI.INTERNALSUBCODE06 AS SUBCODE06, SI.INTERNALSUBCODE07 AS SUBCODE07, SI.INTERNALSUBCODE08 AS SUBCODE08, ' +
                  'SI.INTERNALSUBCODE09 AS SUBCODE09, SI.INTERNALSUBCODE10 AS SUBCODE10, ' +
                  'SD.ORDPRNCUSTOMERSUPPLIERCODE AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, SDL.PROJECTCODE, SDL.STATISTICALGROUPCODE, SDL.STOCKTYPECODE, ' +
                  'COALESCE(SDL.BASEPRIMARYQUANTITY, 0.0) - COALESCE(SDL.SHIPPEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM SALESDOCUMENTLINE SDL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = SDL.STOCKTYPECODE ' +
                  'JOIN SALESDOCUMENT SD ' +
                  'ON	SD.COMPANYCODE = SDL.SALESDOCUMENTCOMPANYCODE ' +
                  'AND SD.PROVISIONALCOUNTERCODE = SDL.SALDOCPROVISIONALCOUNTERCODE ' +
                  'AND SD.PROVISIONALCODE = SDL.SALESDOCUMENTPROVISIONALCODE ' +
                  'JOIN SELLINGITEM SI ' +
                  'ON SI.COMPANYCODE = SDL.SALESDOCUMENTCOMPANYCODE ' +
                  'AND SI.ITEMTYPECODE = SDL.ITEMTYPEAFICODE ' +
                  'AND SI.SUBCODE01 = SDL.SUBCODE01 ' +
                  'AND SI.SUBCODE02 = SDL.SUBCODE02 ' +
                  'AND SI.SUBCODE03 = SDL.SUBCODE03 ' +
                  'AND SI.SUBCODE04 = SDL.SUBCODE04 ' +
                  'AND SI.SUBCODE05 = SDL.SUBCODE05 ' +
                  'AND SI.SUBCODE06 = SDL.SUBCODE06 ' +
                  'AND SI.SUBCODE07 = SDL.SUBCODE07 ' +
                  'AND SI.SUBCODE08 = SDL.SUBCODE08 ' +
                  'AND SI.SUBCODE09 = SDL.SUBCODE09 ' +
                  'AND SI.SUBCODE10 = SDL.SUBCODE10 ' +
                  'WHERE SDL.SALESDOCUMENTPROVISIONALCODE = ' + QuotedStr(SALESDOCUMENTLINECompanyInUsed) + ' ' +
                  'AND SDL.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND SDL.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +
                  'AND SDL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND SD.DOCUMENTTYPETYPE IN (' + QuotedStr('05') + ',' + QuotedStr('07') + ',' + QuotedStr('08') + ',' + QuotedStr('10') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Sales document consignment')) +  ' AS INFOAREA, ' +
                  'COALESCE(SD.DEFINITIVEDOCUMENTDATE, SD.PROVISIONALDOCUMENTDATE) AS DUEDATE,  SD.CONSIGNMENTWAREHOUSECODE AS LOGICALWAREHOUSECODE, SDL.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'SI.INTERNALSUBCODE01 AS SUBCODE01, SI.INTERNALSUBCODE02 AS SUBCODE02, SI.INTERNALSUBCODE03 AS SUBCODE03, SI.INTERNALSUBCODE04 AS SUBCODE04, SI.INTERNALSUBCODE05 AS SUBCODE05, ' +
                  'SI.INTERNALSUBCODE06 AS SUBCODE06, SI.INTERNALSUBCODE07 AS SUBCODE07, SI.INTERNALSUBCODE08 AS SUBCODE08, SI.INTERNALSUBCODE09 AS SUBCODE09, SI.INTERNALSUBCODE10 AS SUBCODE10, ' +
                  'SD.ORDPRNCUSTOMERSUPPLIERCODE AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, SDL.PROJECTCODE, SDL.STATISTICALGROUPCODE, SDL.STOCKTYPECODE, ' +
                  '(COALESCE(SDL.BASEPRIMARYQUANTITY, 0.0) - COALESCE(SDL.SHIPPEDBASEPRIMARYQUANTITY, 0.0)) * -1.0 AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM SALESDOCUMENTLINE SDL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = SDL.STOCKTYPECODE ' +
                  'JOIN SALESDOCUMENT SD ' +
                  'ON SD.COMPANYCODE = SDL.SALESDOCUMENTCOMPANYCODE ' +
                  'AND SD.PROVISIONALCOUNTERCODE = SDL.SALDOCPROVISIONALCOUNTERCODE ' +
                  'AND SD.PROVISIONALCODE = SDL.SALESDOCUMENTPROVISIONALCODE ' +
                  'JOIN SELLINGITEM SI ' +
                  'ON SI.COMPANYCODE = SDL.SALESDOCUMENTCOMPANYCODE ' +
                  'AND	SI.ITEMTYPECODE = SDL.ITEMTYPEAFICODE ' +
                  'AND SI.SUBCODE01 = SDL.SUBCODE01 ' +
                  'AND SI.SUBCODE02 = SDL.SUBCODE02 ' +
                  'AND SI.SUBCODE03 = SDL.SUBCODE03 ' +
                  'AND SI.SUBCODE04 = SDL.SUBCODE04 ' +
                  'AND SI.SUBCODE05 = SDL.SUBCODE05 ' +
                  'AND SI.SUBCODE06 = SDL.SUBCODE06 ' +
                  'AND SI.SUBCODE07 = SDL.SUBCODE07 ' +
                  'AND SI.SUBCODE08 = SDL.SUBCODE08 ' +
                  'AND SI.SUBCODE09 = SDL.SUBCODE09 ' +
                  'AND SI.SUBCODE10 = SDL.SUBCODE10 ' +
                  'WHERE SDL.SALESDOCUMENTPROVISIONALCODE = ' + QuotedStr(SALESDOCUMENTLINECompanyInUsed) + ' ' +
                  'AND SDL.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND SDL.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +
                  'AND SDL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND SD.DOCUMENTTYPETYPE IN (' + QuotedStr('05') + ',' + QuotedStr('07') + ',' + QuotedStr('08') + ',' + QuotedStr('10') + ') ' +
                  'AND SDL.CONSIGNMENTTYPE IN (' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Sales release')) + ' AS INFOAREA, ' +
                  'SRL.RELEASEDATE AS DUEDATE,  SRL.WAREHOUSECODE AS LOGICALWAREHOUSECODE, SRL.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'SI.INTERNALSUBCODE01 AS SUBCODE01, SI.INTERNALSUBCODE02 AS SUBCODE02, SI.INTERNALSUBCODE03 AS SUBCODE03, SI.INTERNALSUBCODE04 AS SUBCODE04, ' +
                  'SI.INTERNALSUBCODE05 AS SUBCODE05, SI.INTERNALSUBCODE06 AS SUBCODE06, SI.INTERNALSUBCODE07 AS SUBCODE07, SI.INTERNALSUBCODE08 AS SUBCODE08, ' +
                  'SI.INTERNALSUBCODE09 AS SUBCODE09, SI.INTERNALSUBCODE10 AS SUBCODE10, ' +
                  'SRL.ORDPRNCUSTOMERSUPPLIERCODE AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, SRL.PROJECTCODE, SRL.STATISTICALGROUPCODE, SRL.STOCKTYPECODE, ' +
                  'COALESCE(SRL.RELEASEBASEPRIMARYQUANTITY, 0.0) - COALESCE(SRL.USEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM SALESRELEASELINE SRL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = SRL.STOCKTYPECODE ' +
                  'JOIN SELLINGITEM SI ' +
                  'ON SI.COMPANYCODE = SRL.COMPANYCODE ' +
                  'AND SI.ITEMTYPECODE = SRL.ITEMTYPEAFICODE ' +
                  'AND SI.SUBCODE01 = SRL.SUBCODE01 ' +
                  'AND SI.SUBCODE02 = SRL.SUBCODE02 ' +
                  'AND SI.SUBCODE03 = SRL.SUBCODE03 ' +
                  'AND SI.SUBCODE04 = SRL.SUBCODE04 ' +
                  'AND SI.SUBCODE05 = SRL.SUBCODE05 ' +
                  'AND SI.SUBCODE06 = SRL.SUBCODE06 ' +
                  'AND SI.SUBCODE07 = SRL.SUBCODE07 ' +
                  'AND SI.SUBCODE08 = SRL.SUBCODE08 ' +
                  'AND SI.SUBCODE09 = SRL.SUBCODE09 ' +
                  'AND SI.SUBCODE10 = SRL.SUBCODE10 ' +
                  'WHERE SRL.COMPANYCODE = ' + QuotedStr(SALESRELEASELINECompanyInUsed) + ' ' +
                  'AND SRL.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND SRL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Purchase delivery')) + ' AS INFOAREA, ' +
                  'POD.RESERVATIONDATE AS DUEDATE, POD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, POD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'POD.SUBCODE01, POD.SUBCODE02, POD.SUBCODE03, POD.SUBCODE04, POD.SUBCODE05, ' +
                  'POD.SUBCODE06, POD.SUBCODE07, POD.SUBCODE08, POD.SUBCODE09, POD.SUBCODE10, ' +
                   QuotedStr(' ') + ' AS CUSTOMERCODE, PO.ORDPRNCUSTOMERSUPPLIERCODE AS SUPPLIERCODE, POD.PROJECTCODE, POD.STATISTICALGROUPCODE, POD.STOCKTYPECODE, ' +
                  'COALESCE(POD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(POD.USEDBASEPRIMARYQUANTITY, 0.0) - COALESCE(POD.CANCELLEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ';

                  if IniAppGlobals.VIEWTLSPODUpdateDeliveryDate = '' then
                    Result := Result + 'FROM PURCHASEORDERDELIVERY POD '
                  else
                    Result := Result + ' FROM ' + IniAppGlobals.VIEWTLSPODUpdateDeliveryDate + ' POD ';

                  Result := Result +
 //                 'FROM PURCHASEORDERDELIVERY POD ' +
                  ' JOIN STOCKTYPE ST ON ST.CODE = POD.STOCKTYPECODE ' +
                  'JOIN PURCHASEORDER PO ' +
                  'ON PO.COMPANYCODE = POD.PURORDLINEPURORDERCOMPANYCODE ' +
                  'AND PO.COUNTERCODE = POD.PURORDLINEPURORDERCOUNTERCODE ' +
                  'AND PO.CODE = POD.PURORDERLINEPURCHASEORDERCODE ' +
                  'WHERE POD.PURORDLINEPURORDERCOMPANYCODE = ' + QuotedStr(PURCHASEORDERDELIVERYCompanyInUsed) + ' ' +
                  'AND POD.ITEMTYPEAFICODE IN (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND POD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND POD.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Internal order from')) + ' AS INFOAREA, ' +
                  'IOD.DELIVERYDATE AS DUEDATE, IOD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, IOD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'IOD.SUBCODE01, IOD.SUBCODE02, IOD.SUBCODE03, IOD.SUBCODE04, IOD.SUBCODE05, ' +
                  'IOD.SUBCODE06, IOD.SUBCODE07, IOD.SUBCODE08, IOD.SUBCODE09, IOD.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, IOD.PROJECTCODE, IOD.STATISTICALGROUPCODE, IOD.STOCKTYPECODE, ' +
                  'COALESCE(IOD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(IOD.USEDBASEPRIMARYQUANTITY, 0.0) - COALESCE(IOD.CANCELLEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM INTERNALORDERDELIVERY IOD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = IOD.STOCKTYPECODE ' +
                  'WHERE IOD.INTORDLINEINTORDERCOMPANYCODE = ' + QuotedStr(INTERNALORDERDELIVERYCompanyInUsed) + ' ' +
                  'AND IOD.ITEMTYPEAFICODE IN (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND IOD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND IOD.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Internal order to')) + ' AS INFOAREA, ' +
                  'IOD.DELIVERYDATE AS DUEDATE, IOD.DESTINATIONWAREHOUSECODE AS LOGICALWAREHOUSECODE, IOD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'IOD.SUBCODE01, IOD.SUBCODE02, IOD.SUBCODE03, IOD.SUBCODE04, IOD.SUBCODE05, ' +
                  'IOD.SUBCODE06, IOD.SUBCODE07, IOD.SUBCODE08, IOD.SUBCODE09, IOD.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, IOD.PROJECTCODE, IOD.STATISTICALGROUPCODE, IOD.RESERVATIONSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(IOD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(IOD.USEDBASEPRIMARYQUANTITY, 0.0) - COALESCE(IOD.CANCELLEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = '  + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM INTERNALORDERDELIVERY IOD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = IOD.RESERVATIONSTOCKTYPECODE ' +
                  'WHERE IOD.INTORDLINEINTORDERCOMPANYCODE = ' + QuotedStr(INTERNALORDERDELIVERYCompanyInUsed) + ' ' +
                  'AND IOD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND IOD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND IOD.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Internal document from')) + ' AS INFOAREA, ' +
                  'COALESCE(ID.DEFINITIVEDOCUMENTDATE, ID.PROVISIONALDOCUMENTDATE) AS DUEDATE,	IDL.WAREHOUSECODE AS LOGICALWAREHOUSECODE, IDL.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'IDL.SUBCODE01, IDL.SUBCODE02, IDL.SUBCODE03, IDL.SUBCODE04, IDL.SUBCODE05, ' +
                  'IDL.SUBCODE06, IDL.SUBCODE07, IDL.SUBCODE08, IDL.SUBCODE09, IDL.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, IDL.PROJECTCODE, IDL.STATISTICALGROUPCODE, IDL.STOCKTYPECODE, ' +
                  'COALESCE(IDL.BASEPRIMARYQUANTITY, 0.0) - COALESCE(IDL.SHIPPEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM INTERNALDOCUMENTLINE IDL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = IDL.STOCKTYPECODE ' +
                  'JOIN INTERNALDOCUMENT ID ' +
                  'ON ID.COMPANYCODE = IDL.INTERNALDOCUMENTCOMPANYCODE ' +
                  'AND ID.PROVISIONALCOUNTERCODE = IDL.INTDOCPROVISIONALCOUNTERCODE ' +
                  'AND ID.PROVISIONALCODE = IDL.INTDOCUMENTPROVISIONALCODE ' +
                  'WHERE IDL.INTERNALDOCUMENTCOMPANYCODE = ' + QuotedStr(INTERNALDOCUMENTLINECompanyInUsed) + ' ' +
                  'AND IDL.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND IDL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND IDL.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Internal document to')) + ' AS INFOAREA, ' +
                  'COALESCE(ID.DEFINITIVEDOCUMENTDATE, ID.PROVISIONALDOCUMENTDATE) AS DUEDATE,	IDL.DESTINATIONWAREHOUSECODE AS LOGICALWAREHOUSECODE, IDL.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'IDL.SUBCODE01, IDL.SUBCODE02, IDL.SUBCODE03, IDL.SUBCODE04, IDL.SUBCODE05, ' +
                  'IDL.SUBCODE06, IDL.SUBCODE07, IDL.SUBCODE08, IDL.SUBCODE09, IDL.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, IDL.PROJECTCODE, IDL.STATISTICALGROUPCODE, IDL.RECEIVINGSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(IDL.BASEPRIMARYQUANTITY, 0.0) - COALESCE(IDL.SHIPPEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM INTERNALDOCUMENTLINE IDL ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = IDL.RECEIVINGSTOCKTYPECODE ' +
                  'JOIN INTERNALDOCUMENT ID ' +
                  'ON ID.COMPANYCODE = IDL.INTERNALDOCUMENTCOMPANYCODE ' +
                  'AND ID.PROVISIONALCOUNTERCODE = IDL.INTDOCPROVISIONALCOUNTERCODE ' +
                  'AND ID.PROVISIONALCODE = IDL.INTDOCUMENTPROVISIONALCODE ' +
                  'WHERE IDL.INTERNALDOCUMENTCOMPANYCODE = ' + QuotedStr(INTERNALDOCUMENTLINECompanyInUsed) + ' ' +
                  'AND IDL.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND IDL.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND IDL.UPDATEWAREHOUSEAVAILABILITY = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Purchase document return')) + ' AS INFOAREA, ' +
                  'PRD.RETURNDATE AS DUEDATE, PRD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, PRD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'PRD.SUBCODE01, PRD.SUBCODE02, PRD.SUBCODE03, PRD.SUBCODE04, PRD.SUBCODE05, ' +
                  'PRD.SUBCODE06, PRD.SUBCODE07, PRD.SUBCODE08, PRD.SUBCODE09, PRD.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, PRD.ORDPRNCUSTOMERSUPPLIERCODE AS SUPPLIERCODE, PRD.PROJECTCODE, PRD.STATISTICALGROUPCODE, PRD.RETURNSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(PRD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PRD.SHIPPEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PURCHASERETURNDOCUMENT PRD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = PRD.RETURNSTOCKTYPECODE ' +
                  'WHERE PRD.COMPANYCODE = ' + QuotedStr(PURCHASERETURNDOCUMENTCompanyInUsed) + ' ' +
                  'AND PRD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND PRD.RETURNSTATUS IN (' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Reservation')) + ' AS INFOAREA, ' +
                  'PR.ISSUEDATE AS DUEDATE, ' +
                  'CASE WHEN PR.SUBCONTRACTORWAREHOUSECODE <> ' + QuotedStr(' ') + ' THEN PR.SUBCONTRACTORWAREHOUSECODE ELSE PR.WAREHOUSECODE END LOGICALWAREHOUSECODE, PR.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'PR.SUBCODE01, PR.SUBCODE02, PR.SUBCODE03, PR.SUBCODE04, PR.SUBCODE05, PR.SUBCODE06, PR.SUBCODE07, PR.SUBCODE08, PR.SUBCODE09, PR.SUBCODE10, ' +
                  'CASE WHEN PR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('1') + ' THEN PR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + ' END AS CUSTOMERCODE, ' +
                  'CASE WHEN PR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('2') +  ' THEN PR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + '  END AS SUPPLIERCODE, ' +
                  'PR.PROJECTCODE, PR.STATISTICALGROUPCODE, PR.STOCKTYPECODE, ' +
                  'CASE WHEN PR.SUBCONTRACTORWAREHOUSECODE <> ' + QuotedStr(' ') + ' AND PR.WAREHOUSECODE IS NOT NULL AND PR.WAREHOUSECODE <> ' + QuotedStr(' ') + ' ' +
                  'THEN (COALESCE(PR.USEDBASEPRIMARYQUANTITY, 0.0) - COALESCE(PR.SBCUSEDBASEPRIMARYQUANTITY, 0.0)) ' +
                  'WHEN PR.SUBCONTRACTORWAREHOUSECODE <> ' + QuotedStr(' ') + ' AND (PR.WAREHOUSECODE IS NULL OR PR.WAREHOUSECODE = ' + QuotedStr(' ') + ')' + ' ' +
                  'THEN (COALESCE(PR.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PR.SBCUSEDBASEPRIMARYQUANTITY, 0.0)) ' +
                  'ELSE (COALESCE(PR.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PR.USEDBASEPRIMARYQUANTITY, 0.0)) ' +
                  'END PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PRODUCTIONRESERVATION PR ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = PR.STOCKTYPECODE ' +
                  'WHERE PR.COMPANYCODE = ' + QuotedStr(PRODUCTIONRESERVATIONCompanyInUsed) + ' ' +
                  'AND PR.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND PR.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND PR.RESERVATIONINGROUPORDER = ' + IntToStr(0) + ' ' +
                  'AND PR.SPLITTINGMANAGEMENT = ' + IntToStr(0) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Reservation')) + ' AS INFOAREA, ' +
                  'PRS.PERIODDATE AS DUEDATE, PR.WAREHOUSECODE AS LOGICALWAREHOUSECODE, PR.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'PR.SUBCODE01, PR.SUBCODE02, PR.SUBCODE03, PR.SUBCODE04, PR.SUBCODE05, ' +
                  'PR.SUBCODE06, PR.SUBCODE07, PR.SUBCODE08, PR.SUBCODE09, PR.SUBCODE10, ' +
                  'CASE WHEN PR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('1') + ' THEN PR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + ' END AS CUSTOMERCODE, ' +
                  'CASE WHEN PR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('2') + ' THEN PR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + ' END AS SUPPLIERCODE, ' +
                  'PR.PROJECTCODE, PR.STATISTICALGROUPCODE, PR.STOCKTYPECODE, ' +
                  'COALESCE(PRS.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PRS.USEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') +  ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PRODUCTIONRESERVATION PR ' + ' ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = PR.STOCKTYPECODE ' +
                  'JOIN PRODRESSPLITDATEQTY PRS ' +
                  'ON PRS.PRORESERVATIONCOMPANYCODE = PR.COMPANYCODE ' +
                  'AND PRS.PRORESERVATIONORDCOUNTERCODE = PR.ORDERCOUNTERCODE ' +
                  'AND PRS.PRODUCTIONRESERVATIONORDERCODE	= PR.ORDERCODE ' +
                  'AND PRS.PRORESERVATIONRESERVATIONLINE = PR.RESERVATIONLINE ' +
                  'WHERE PR.COMPANYCODE = ' + QuotedStr(PRODUCTIONRESERVATIONCompanyInUsed) + ' ' +
                  'AND PR.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND PR.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND PR.RESERVATIONINGROUPORDER = ' + IntToStr(0) + ' ' +
                  'AND PR.SPLITTINGMANAGEMENT = ' + IntToStr(1) + ' ' +
                  'AND	PR.WAREHOUSECODE <> ' + QuotedStr(' ') + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Reservation')) + ' AS INFOAREA, ' +
                  'POR.ISSUEDATE AS DUEDATE, POR.WAREHOUSECODE AS LOGICALWAREHOUSECODE, POR.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'POR.SUBCODE01, POR.SUBCODE02, POR.SUBCODE03, POR.SUBCODE04, POR.SUBCODE05, ' +
                  'POR.SUBCODE06, POR.SUBCODE07, POR.SUBCODE08, POR.SUBCODE09, POR.SUBCODE10, ' +
                  'CASE WHEN POR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('1') + ' THEN POR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + ' END AS CUSTOMERCODE, ' +
                  'CASE WHEN POR.CUSTOMERSUPPLIERTYPE = ' + QuotedStr('2') + ' THEN POR.CUSTOMERSUPPLIERCODE ELSE ' + QuotedStr(' ') + ' END AS SUPPLIERCODE, ' +
                  'POR.PROJECTCODE, POR.STATISTICALGROUPCODE, POR.STOCKTYPECODE, ' +
                  'COALESCE(POR.BASEPRIMARYQUANTITY, 0.0) - COALESCE(POR.USEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') +  ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PRODUCTIONORDERRESERVATION POR ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = POR.STOCKTYPECODE ' +
                  'WHERE POR.COMPANYCODE = ' + QuotedStr(PRODUCTIONORDERRESERVATIONCompanyInUsed) + ' ' +
                  'AND POR.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND POR.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                  'AND POR.SPLITTINGMANAGEMENT = ' + IntToStr(0) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Demand')) + ' AS INFOAREA, ' +
                  'PD.FINALPLANNEDDATE AS DUEDATE, PD.ENTRYWAREHOUSECODE AS LOGICALWAREHOUSECODE, PD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'PD.SUBCODE01, PD.SUBCODE02, PD.SUBCODE03, PD.SUBCODE04, PD.SUBCODE05, ' +
                  'PD.SUBCODE06, PD.SUBCODE07, PD.SUBCODE08, PD.SUBCODE09, PD.SUBCODE10, ' +
                  'PD.CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, PD.PROJECTCODE, PD.STATISTICALGROUPCODE, PD.PRDDEMANDSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(PD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PD.ENTEREDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PRODUCTIONDEMAND PD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = PD.PRDDEMANDSTOCKTYPECODE ' +
                  'WHERE PD.COMPANYCODE = ' + QuotedStr(PRODUCTIONDEMANDCompanyInUsed) + ' ' +
                  'AND PD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND PD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + ') ' +
                  'AND PD.SPLITTINGMANAGEMENT = ' + IntToStr(0) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Demand')) + ' AS INFOAREA, ' +
                  'PDS.PERIODDATE AS DUEDATE, PD.ENTRYWAREHOUSECODE AS LOGICALWAREHOUSECODE, PD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'PD.SUBCODE01, PD.SUBCODE02, PD.SUBCODE03, PD.SUBCODE04, PD.SUBCODE05, ' +
                  'PD.SUBCODE06, PD.SUBCODE07, PD.SUBCODE08, PD.SUBCODE09, PD.SUBCODE10, ' +
                  'PD.CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, PD.PROJECTCODE, PD.STATISTICALGROUPCODE, PD.PRDDEMANDSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(PDS.BASEPRIMARYQUANTITY, 0.0) - COALESCE(PDS.USEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' +  QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM PRODUCTIONDEMAND PD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = PD.PRDDEMANDSTOCKTYPECODE ' +
                  'JOIN PRODDEMANDSPLITDATEQTY PDS ' +
                  'ON PDS.PRODUCTIONDEMANDCOMPANYCODE = PD.COMPANYCODE ' +
                  'AND PDS.PRODUCTIONDEMANDCOUNTERCODE = PD.COUNTERCODE ' +
                  'AND PDS.PRODUCTIONDEMANDCODE = PD.CODE ' +
                  'WHERE PD.COMPANYCODE = ' + QuotedStr(PRODUCTIONDEMANDCompanyInUsed) + ' ' +
                  'AND PD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND PD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ',' + QuotedStr('3') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + ') ' +
                  'AND PD.SPLITTINGMANAGEMENT = ' + IntToStr(1) + ' ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Requisition')) + ' AS INFOAREA, ' +
                  'RR.DELIVERYDATE AS DUEDATE, RR.DESTINATIONWAREHOUSECODE AS LOGICALWAREHOUSECODE, RR.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'RR.SUBCODE01, RR.SUBCODE02, RR.SUBCODE03, RR.SUBCODE04, RR.SUBCODE05, ' +
                  'RR.SUBCODE06, RR.SUBCODE07, RR.SUBCODE08, RR.SUBCODE09, RR.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, RR.CUSTOMERSUPPLIERCODE AS SUPPLIERCODE, RR.PROJECTCODE, RR.STATISTICALGROUPINGCODE AS STATISTICALGROUPCODE, RR.STOCKTYPECODE, ' +
                  'COALESCE(RR.ORDERBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM REPLENISHMENTREQUISITION RR ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = RR.STOCKTYPECODE ' +
                  'WHERE RR.COMPANYCODE = ' + QuotedStr(REPLENISHMENTREQUISITIONCompanyInUsed) + ' ' +
                  'AND RR.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND RR.RELEASELEVEL IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ') ' +

                  'UNION ALL ' +

                  'SELECT ' + QuotedStr(_('Internal document retrun')) + ' AS INFOAREA, ' +
                  'IRD.RETURNDATE AS DUEDATE, IRD.WAREHOUSECODE AS LOGICALWAREHOUSECODE, IRD.ITEMTYPEAFICODE AS ITEMTYPECODE, ' +
                  'IRD.SUBCODE01, IRD.SUBCODE02, IRD.SUBCODE03, IRD.SUBCODE04, IRD.SUBCODE05, ' +
                  'IRD.SUBCODE06, IRD.SUBCODE07, IRD.SUBCODE08, IRD.SUBCODE09, IRD.SUBCODE10, ' +
                  QuotedStr(' ') + ' AS CUSTOMERCODE, ' + QuotedStr(' ') + ' AS SUPPLIERCODE, IRD.PROJECTCODE, IRD.STATISTICALGROUPCODE, IRD.RETURNSTOCKTYPECODE AS STOCKTYPECODE, ' +
                  'COALESCE(IRD.BASEPRIMARYQUANTITY, 0.0) - COALESCE(IRD.SHIPPEDBASEPRIMARYQUANTITY, 0.0) AS PRIMARYQUANTITY, ' +
                  'CASE WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('1') + ' THEN 1.0 WHEN ST.AVAILABILITYSIGN = ' + QuotedStr('2') + ' THEN -1.0 ELSE 0.0 END AS STOCKTYPEMULTIPLIER, ' +
                   QuotedStr(' ') + ' AS LOTCODE ' +
                  'FROM INTERNALRETURNDOCUMENT IRD ' +
                  'JOIN STOCKTYPE ST ON ST.CODE = IRD.RETURNSTOCKTYPECODE ' +
                  'WHERE IRD.COMPANYCODE = ' + QuotedStr(INTERNALRETURNDOCUMENTCompanyInUsed) +
                  'AND IRD.ITEMTYPEAFICODE in (' + balanceHandledItemTypeCodes + ')' + ' ' +
                  'AND IRD.RETURNSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ') ' +

                  ') AVL ' +

                  'LEFT JOIN FULLITEMKEYDECODER FIKD ' +
                  'ON FIKD.COMPANYCODE = ' + QuotedStr(FULLITEMKEYDECODERCompanyInUsed) + ' ' +
                  'AND FIKD.ITEMTYPECODE = AVL.ITEMTYPECODE ' +
                  'AND FIKD.SUBCODE01 = AVL.SUBCODE01 ' +
                  'AND FIKD.SUBCODE02 = AVL.SUBCODE02 ' +
                  'AND FIKD.SUBCODE03 = AVL.SUBCODE03 ' +
                  'AND FIKD.SUBCODE04 = AVL.SUBCODE04 ' +
                  'AND FIKD.SUBCODE05 = AVL.SUBCODE05 ' +
                  'AND FIKD.SUBCODE06 = AVL.SUBCODE06 ' +
                  'AND FIKD.SUBCODE07 = AVL.SUBCODE07 ' +
                  'AND FIKD.SUBCODE08 = AVL.SUBCODE08 ' +
                  'AND FIKD.SUBCODE09 = AVL.SUBCODE09 ' +
                  'AND FIKD.SUBCODE10 = AVL.SUBCODE10 ' +
                  'LEFT JOIN TOOL T ' +
                  'ON	T.COMPANYCODE = ' + QuotedStr(TOOLCompanyInUsed) + ' ' +
                  'AND T.ITEMTYPECODE = AVL.ITEMTYPECODE ' +
                  'AND T.SUBCODE01 = AVL.SUBCODE01 ' +

                  'WHERE AVL.STOCKTYPECODE IN  (' + STOCKTYPECODES + ') ' + ' AND (FIKD.ABSUNIQUEID > ' + IntToStr(0) + ' OR T.ABSUNIQUEID > ' + IntToStr(0) + ' ) ' +

                  'GROUP BY AVL.INFOAREA, AVL.DUEDATE, AVL.LOGICALWAREHOUSECODE, AVL.ITEMTYPECODE, AVL.SUBCODE01, AVL.SUBCODE02, AVL.SUBCODE03, AVL.SUBCODE04, AVL.SUBCODE05, ' +
                  'AVL.SUBCODE06, AVL.SUBCODE07, AVL.SUBCODE08, AVL.SUBCODE09, AVL.SUBCODE10, AVL.CUSTOMERCODE, AVL.SUPPLIERCODE, AVL.PROJECTCODE, AVL.STATISTICALGROUPCODE, ' +
                  'FIKD.ABSUNIQUEID,  T.ABSUNIQUEID, AVL.LOTCODE ';
  end;
end;

//----------------------------------------------------------------------------//

procedure UpdatePropertyLinkerToServingGroup(propertyList, read_prop_prod_list, read_prod_reqhdr_list : TList; ServingCode : string);
var
  ServingCodeValue, ValueTmp, value, prod_req : string;
  I, J : integer;
  TempPropProdList : TList;
  CUR_PROP, Tested_PROP : PPROPS;
  function getTestedProp(Prop : string) : PPROPS;
  var
    K : Integer;
  begin
    Result := nil;
    for K := 0 to propertyList.Count - 1 do
    begin
      if Prop = PPROPS(propertyList.Items[K]).PY_PROPERTY then
      begin
        Result := propertyList.Items[K];
        break
      end;
    end;
  end;
begin
  TempPropProdList := TList.Create;
  prod_req := PTMQMPP(read_prop_prod_list[read_prop_prod_list.Count - 1]).PP_PREQ_NO;

  for I := read_prop_prod_list.Count - 1 downto 0 do
  begin
    if trim(prod_req) <> trim(PTMQMPP(read_prop_prod_list[I]).PP_PREQ_NO) then break;
    if PTMQMPP(read_prop_prod_list[I]).PP_PSTEP_ID = 0 then
      TempPropProdList.Add(read_prop_prod_list[I]);
  end;

  for I := 0 to propertyList.Count - 1 do
  begin
    CUR_PROP := propertyList.Items[i];
    if CUR_PROP.PY_Planner_Prop then continue;
    if CUR_PROP.PY_DESIGNATEDPROPERTY = '3' then
    begin
      if CUR_PROP.PY_IS_PROP_BUILD_FROM_PROP then
      begin

        if CUR_PROP.PY_BUILD_PROPCODE1 <> '' then
        begin
          Tested_PROP := getTestedProp(CUR_PROP.PY_BUILD_PROPCODE1);
          if Tested_PROP <> nil then
          begin
            for J := 0 to TempPropProdList.Count - 1 do
            begin
              if CUR_PROP.PY_BUILD_PROPCODE1 = PTMQMPP(TempPropProdList[J]).PP_PROPERTY then
              begin
                ValueTmp := PTMQMPP(TempPropProdList[J]).PP_VALUE;
                if (Tested_PROP.PY_TYPE = '2') and (Length(ValueTmp) = 90) then
                  value := value + copy(trim(ValueTmp), 91 - Tested_PROP.PY_PROP_LEN, Tested_PROP.PY_PROP_LEN)
                else
                  value := value + copy(trim(ValueTmp), 1, Tested_PROP.PY_PROP_LEN);
                break;
              end;
            end;
          end;
        end;

        if CUR_PROP.PY_BUILD_PROPCODE2 <> '' then
        begin
          Tested_PROP := getTestedProp(CUR_PROP.PY_BUILD_PROPCODE2);
          if Tested_PROP <> nil then
          begin
            for J := 0 to TempPropProdList.Count - 1 do
            begin
              if CUR_PROP.PY_BUILD_PROPCODE2 = PTMQMPP(TempPropProdList[J]).PP_PROPERTY then
              begin
                ValueTmp := PTMQMPP(TempPropProdList[J]).PP_VALUE;
                if (Tested_PROP.PY_TYPE = '2') and (Length(ValueTmp) = 90) then
                  value := value + copy(trim(ValueTmp), 91 - Tested_PROP.PY_PROP_LEN, Tested_PROP.PY_PROP_LEN)
                else
                  value := value + copy(trim(ValueTmp), 1, Tested_PROP.PY_PROP_LEN);
                break;
              end;
            end;
          end;
        end;

        if CUR_PROP.PY_BUILD_PROPCODE3 <> '' then
        begin
          Tested_PROP := getTestedProp(CUR_PROP.PY_BUILD_PROPCODE3);
          if Tested_PROP <> nil then
          begin
            for J := 0 to TempPropProdList.Count - 1 do
            begin
              if CUR_PROP.PY_BUILD_PROPCODE3 = PTMQMPP(TempPropProdList[J]).PP_PROPERTY then
              begin
                ValueTmp := PTMQMPP(TempPropProdList[J]).PP_VALUE;
                if (Tested_PROP.PY_TYPE = '2') and (Length(ValueTmp) = 90) then
                  value := value + copy(trim(ValueTmp), 91 - Tested_PROP.PY_PROP_LEN, Tested_PROP.PY_PROP_LEN)
                else
                  value := value + copy(trim(ValueTmp), 1, Tested_PROP.PY_PROP_LEN);
                break;
              end;
            end;
          end;
        end;

        if CUR_PROP.PY_BUILD_PROPCODE4 <> '' then
        begin
          Tested_PROP := getTestedProp(CUR_PROP.PY_BUILD_PROPCODE4);
          if Tested_PROP <> nil then
          begin
            for J := 0 to TempPropProdList.Count - 1 do
            begin
              if CUR_PROP.PY_BUILD_PROPCODE4 = PTMQMPP(TempPropProdList[J]).PP_PROPERTY then
              begin
                ValueTmp := PTMQMPP(TempPropProdList[J]).PP_VALUE;
                if (Tested_PROP.PY_TYPE = '2') and (Length(ValueTmp) = 90) then
                  value := value + copy(trim(ValueTmp), 91 - Tested_PROP.PY_PROP_LEN, Tested_PROP.PY_PROP_LEN)
                else
                  value := value + copy(trim(ValueTmp), 1, Tested_PROP.PY_PROP_LEN);
                break;
              end;
            end;
          end;
        end;

        if CUR_PROP.PY_BUILD_PROPCODE5 <> '' then
        begin
          Tested_PROP := getTestedProp(CUR_PROP.PY_BUILD_PROPCODE5);
          if Tested_PROP <> nil then
          begin
            for J := 0 to TempPropProdList.Count - 1 do
            begin
              if CUR_PROP.PY_BUILD_PROPCODE5 = PTMQMPP(TempPropProdList[J]).PP_PROPERTY then
              begin
                ValueTmp := PTMQMPP(TempPropProdList[J]).PP_VALUE;
                if (Tested_PROP.PY_TYPE = '2') and (Length(ValueTmp) = 90) then
                  value := value + copy(trim(ValueTmp), 91 - Tested_PROP.PY_PROP_LEN, Tested_PROP.PY_PROP_LEN)
                else
                  value := value + copy(trim(ValueTmp), 1, Tested_PROP.PY_PROP_LEN);
                break;
              end;
            end;
          end;
        end;

        ServingCodeValue := value;
        break;

      end
      else
      begin
        ServingCodeValue := ServingCode;
        break;
      end;
    end;

  end;

  PTMQMPH(read_prod_reqhdr_list[read_prod_reqhdr_list.Count - 1]).PH_Serving_Code := ServingCodeValue;
  TempPropProdList.Free

end;

//----------------------------------------------------------------------------//

procedure UpdatePropertyLinker_CurveFamily_IdCode_BuildFromProp(propertyList, read_prop_prod_list, read_prod_reqhdr_list : TList);
var
  CurveFamily_IdCode, ValueTmp, value, prod_req : string;
  I, J : integer;
  TempPropProdList : TList;
  CUR_PROP, Tested_PROP : PPROPS;
  function getTestedProp(Prop : string) : PPROPS;
  var
    K : Integer;
  begin
    Result := nil;
    for K := 0 to propertyList.Count - 1 do
    begin
      if Prop = PPROPS(propertyList.Items[K]).PY_PROPERTY then
      begin
        Result := propertyList.Items[K];
        break
      end;
    end;
  end;

begin
  TempPropProdList := TList.Create;
  prod_req := PTMQMPP(read_prop_prod_list[read_prop_prod_list.Count - 1]).PP_PREQ_NO;

  for I := read_prop_prod_list.Count - 1 downto 0 do
  begin
    if trim(prod_req) <> trim(PTMQMPP(read_prop_prod_list[I]).PP_PREQ_NO) then break;
    if PTMQMPP(read_prop_prod_list[I]).PP_PSTEP_ID = 0 then
      TempPropProdList.Add(read_prop_prod_list[I]);
  end;

  for I := 0 to propertyList.Count - 1 do
  begin
    CUR_PROP := propertyList.Items[i];
    if CUR_PROP.PY_Planner_Prop then continue;
    if CUR_PROP.PY_DESIGNATEDPROPERTY = '6' then
    begin
      if CUR_PROP.PY_IS_PROP_BUILD_FROM_PROP then
      begin

        if CUR_PROP.PY_BUILD_PROPCODE1 <> '' then
        begin
          Tested_PROP := getTestedProp(CUR_PROP.PY_BUILD_PROPCODE1);
          if Tested_PROP <> nil then
          begin
            for J := 0 to TempPropProdList.Count - 1 do
            begin
              if CUR_PROP.PY_BUILD_PROPCODE1 = PTMQMPP(TempPropProdList[J]).PP_PROPERTY then
              begin
                ValueTmp := PTMQMPP(TempPropProdList[J]).PP_VALUE;
                if (Tested_PROP.PY_TYPE = '2') and (Length(ValueTmp) = 90) then
                  value := value + copy(trim(ValueTmp), 91 - Tested_PROP.PY_PROP_LEN, Tested_PROP.PY_PROP_LEN)
                else
                  value := value + copy(trim(ValueTmp), 1, Tested_PROP.PY_PROP_LEN);
                break;
              end;
            end;
          end;
        end;

        if CUR_PROP.PY_BUILD_PROPCODE2 <> '' then
        begin
          Tested_PROP := getTestedProp(CUR_PROP.PY_BUILD_PROPCODE2);
          if Tested_PROP <> nil then
          begin
            for J := 0 to TempPropProdList.Count - 1 do
            begin
              if CUR_PROP.PY_BUILD_PROPCODE2 = PTMQMPP(TempPropProdList[J]).PP_PROPERTY then
              begin
                ValueTmp := PTMQMPP(TempPropProdList[J]).PP_VALUE;
                if (Tested_PROP.PY_TYPE = '2') and (Length(ValueTmp) = 90) then
                  value := value + copy(trim(ValueTmp), 91 - Tested_PROP.PY_PROP_LEN, Tested_PROP.PY_PROP_LEN)
                else
                  value := value + copy(trim(ValueTmp), 1, Tested_PROP.PY_PROP_LEN);
                break;
              end;
            end;
          end;
        end;

        if CUR_PROP.PY_BUILD_PROPCODE3 <> '' then
        begin
          Tested_PROP := getTestedProp(CUR_PROP.PY_BUILD_PROPCODE3);
          if Tested_PROP <> nil then
          begin
            for J := 0 to TempPropProdList.Count - 1 do
            begin
              if CUR_PROP.PY_BUILD_PROPCODE3 = PTMQMPP(TempPropProdList[J]).PP_PROPERTY then
              begin
                ValueTmp := PTMQMPP(TempPropProdList[J]).PP_VALUE;
                if (Tested_PROP.PY_TYPE = '2') and (Length(ValueTmp) = 90) then
                  value := value + copy(trim(ValueTmp), 91 - Tested_PROP.PY_PROP_LEN, Tested_PROP.PY_PROP_LEN)
                else
                  value := value + copy(trim(ValueTmp), 1, Tested_PROP.PY_PROP_LEN);
                break;
              end;
            end;
          end;
        end;

        if CUR_PROP.PY_BUILD_PROPCODE4 <> '' then
        begin
          Tested_PROP := getTestedProp(CUR_PROP.PY_BUILD_PROPCODE4);
          if Tested_PROP <> nil then
          begin
            for J := 0 to TempPropProdList.Count - 1 do
            begin
              if CUR_PROP.PY_BUILD_PROPCODE4 = PTMQMPP(TempPropProdList[J]).PP_PROPERTY then
              begin
                ValueTmp := PTMQMPP(TempPropProdList[J]).PP_VALUE;
                if (Tested_PROP.PY_TYPE = '2') and (Length(ValueTmp) = 90) then
                  value := value + copy(trim(ValueTmp), 91 - Tested_PROP.PY_PROP_LEN, Tested_PROP.PY_PROP_LEN)
                else
                  value := value + copy(trim(ValueTmp), 1, Tested_PROP.PY_PROP_LEN);
                break;
              end;
            end;
          end;
        end;

        if CUR_PROP.PY_BUILD_PROPCODE5 <> '' then
        begin
          Tested_PROP := getTestedProp(CUR_PROP.PY_BUILD_PROPCODE5);
          if Tested_PROP <> nil then
          begin
            for J := 0 to TempPropProdList.Count - 1 do
            begin
              if CUR_PROP.PY_BUILD_PROPCODE5 = PTMQMPP(TempPropProdList[J]).PP_PROPERTY then
              begin
                ValueTmp := PTMQMPP(TempPropProdList[J]).PP_VALUE;
                if (Tested_PROP.PY_TYPE = '2') and (Length(ValueTmp) = 90) then
                  value := value + copy(trim(ValueTmp), 91 - Tested_PROP.PY_PROP_LEN, Tested_PROP.PY_PROP_LEN)
                else
                  value := value + copy(trim(ValueTmp), 1, Tested_PROP.PY_PROP_LEN);
                break;
              end;
            end;
          end;
        end;

        CurveFamily_IdCode := value;
        break;

      end
    end;

  end;

  PTMQMPH(read_prod_reqhdr_list[read_prod_reqhdr_list.Count - 1]).PH_Curve_Family_Id_Code := CurveFamily_IdCode;
  TempPropProdList.Free
end;

//----------------------------------------------------------------------------//


function FindProductItem(FIKd : string; List_Items : TList ) : pointer;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
  FIKd_Int: Int64;
begin
  Result := nil;

  NumberOfEntries := List_Items.Count;
  if NumberOfEntries = 0 then
  begin
    Exit;
  end;

  FIKd_Int := StrToInt64Def(FIKd, 0);

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
      and (PTITEMS(List_Items[i]).ABSUNIQUEIDINT = FIKd_Int) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (PTITEMS(List_Items[i]).ABSUNIQUEIDINT < FIKd_Int) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  if Multiplier > 0 then
    Result := PTITEMS(List_Items[i]);
end;

//----------------------------------------------------------------------------//

procedure LoadProjectNumbers(ArcQry : TMqmQuery; ProjectNumberList : TList);
var
  srvSqlStr : String;
  tbInfo    : ^TTblInfo;
  ProjectNumber : PTPROJECT_NUMBER;
  TableName : string;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'PROJECT_NUMBER';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'PROJECT_NUMBER';

  srvSqlStr := 'SELECT * FROM ' + TableName + WHERE_IDF_Condition('IDENTIFIER') + 'ORDER BY CODE';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active:=true;
  var fldPN_Code   := ArcQry.FieldByName('CODE');
  var fldPN_Number := ArcQry.FieldByName('PROJECT_NUMBER');

  while not ArcQry.Eof do
  begin
    new(ProjectNumber);
    ProjectNumber.CODE := Trim(fldPN_Code.AsString);
    ProjectNumber.NUMBER := Trim(fldPN_Number.AsString);
    ProjectNumberList.add(ProjectNumber);
    ArcQry.Next;
  end;
end;

//----------------------------------------------------------------------------//

procedure FreeCompanyLevelHandlingByEntity;
var
  I : Integer;
begin
  if assigned(M_ABSCOMPANYHANDLING) then
  begin
    CleanCompanyLevelHandlingByEntity;
    M_ABSCOMPANYHANDLING.Free;
  end;
end;

//----------------------------------------------------------------------------//

function CheckColumnExistsInTable(ArcQry : TMqmQuery; TABLE_NAME : string; ColumnToCheck : string) : boolean;
var
  srvSqlStr, TableName: String;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
     TableName := 'NOW_TABLES_COLUMNS'
  else
     TableName := 'SCDA_NOW_TABLES_COLUMNS';

  srvSqlStr := 'Select COLUMN_NAME from ' + TableName + ' WHERE COLUMN_NAME = ' + QuotedStr(ColumnToCheck) +
               ' AND TABLE_NAME = ' + QuotedStr(TABLE_NAME);

  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;

  if (not ArcQry.Eof ) then
    Result := true;
  ArcQry.Active := false;
end;
//----------------------------------------------------------------------------//

procedure Find_prod_req_OR_AddToList_FamilyMerge(Tmp_read_prod_req_list : TList; MQMPR : PTMQMPR);
var
  RecMQMPR : PTMQMPR;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_read_prod_req_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPR(Tmp_read_prod_req_list[I]).PR_FAMILYCODE < MQMPR.PR_FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPR(Tmp_read_prod_req_list[I]).PR_FAMILYCODE > MQMPR.PR_FAMILYCODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      Exit;

    end;
  end;

  new(RecMQMPR);
  RecMQMPR^ := MQMPR^;
  RecMQMPR.PR_PREQ_NO := MQMPR.PR_FAMILYCODE;
  Tmp_read_prod_req_list.Insert(LowestHighestValue, RecMQMPR);

end;

//----------------------------------------------------------------------------//

procedure Find_prod_reqHdr_OR_AddToList_FamilyMerge(Tmp_read_prod_reqHdr_list : TList; MQMPH : PTMQMPH);
var
  RecMQMPH : PTMQMPH;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_read_prod_reqHdr_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPH(Tmp_read_prod_reqHdr_list[I]).PH_FAMILYCODE < MQMPH.PH_FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPH(Tmp_read_prod_reqHdr_list[I]).PH_FAMILYCODE > MQMPH.PH_FAMILYCODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      Exit;

    end;
  end;

  new(RecMQMPH);
  RecMQMPH^ := MQMPH^;
  RecMQMPH.PH_PREQ_NO := MQMPH.PH_FAMILYCODE;
  Tmp_read_prod_reqHdr_list.Insert(LowestHighestValue, RecMQMPH);
end;

//----------------------------------------------------------------------------//

procedure Find_prod_Step_OR_AddToList_FamilyMerge(Tmp_read_prod_step_list : TList; MQMPD : PTMQMPD);
var
  RecMQMPD : PTMQMPD;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_read_prod_step_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPD(Tmp_read_prod_step_list[I]).PD_FAMILYCODE < MQMPD.PD_FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPD(Tmp_read_prod_step_list[I]).PD_FAMILYCODE > MQMPD.PD_FAMILYCODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPD(Tmp_read_prod_step_list[I]).PD_PSTEP_ID < MQMPD.PD_PSTEP_ID then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPD(Tmp_read_prod_step_list[I]).PD_PSTEP_ID > MQMPD.PD_PSTEP_ID) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      PTMQMPD(Tmp_read_prod_step_list[I]).PD_INIT_QUENT     := StrToFloat(addUpFields(FloatToStr(PTMQMPD(Tmp_read_prod_step_list[I]).PD_INIT_QUENT) , FloatToStr(MQMPD.PD_INIT_QUENT), false));
      PTMQMPD(Tmp_read_prod_step_list[I]).PD_FIN_QUENT      := StrToFloat(addUpFields(FloatToStr(PTMQMPD(Tmp_read_prod_step_list[I]).PD_FIN_QUENT), FloatToStr(MQMPD.PD_FIN_QUENT), false));
      PTMQMPD(Tmp_read_prod_step_list[I]).PD_WEIGHT         := StrToFloat(addUpFields(FloatToStr(PTMQMPD(Tmp_read_prod_step_list[I]).PD_WEIGHT), FloatToStr(MQMPD.PD_WEIGHT), false));

      if (PTMQMPD(Tmp_read_prod_step_list[I]).PD_STEP_TYP = 'C') then
      begin
        PTMQMPD(Tmp_read_prod_step_list[I]).PD_MAT_ARRV_DATE       := getMinimumDate(PTMQMPD(Tmp_read_prod_step_list[I]).PD_MAT_ARRV_DATE, MQMPD.PD_MAT_ARRV_DATE);
        PTMQMPD(Tmp_read_prod_step_list[I]).PD_PLAN_START          := getMinimumDate(PTMQMPD(Tmp_read_prod_step_list[I]).PD_PLAN_START, MQMPD.PD_PLAN_START);
        PTMQMPD(Tmp_read_prod_step_list[I]).PD_LOW_LIMIT_TIME_STRT := getMinimumDate(PTMQMPD(Tmp_read_prod_step_list[I]).PD_LOW_LIMIT_TIME_STRT, MQMPD.PD_LOW_LIMIT_TIME_STRT);
        PTMQMPD(Tmp_read_prod_step_list[I]).PD_PLAN_END            := getMaximumDate(PTMQMPD(Tmp_read_prod_step_list[I]).PD_PLAN_END, MQMPD.PD_PLAN_END);
        PTMQMPD(Tmp_read_prod_step_list[I]).PD_HIGH_LIMIT_TIMEND   := getMaximumDate(PTMQMPD(Tmp_read_prod_step_list[I]).PD_HIGH_LIMIT_TIMEND, MQMPD.PD_HIGH_LIMIT_TIMEND);
        PTMQMPD(Tmp_read_prod_step_list[I]).PD_SETUP_TIME_STP      := StrToFloat(addUpFields(FloatToStr(PTMQMPD(Tmp_read_prod_step_list[I]).PD_SETUP_TIME_STP), FloatToStr(MQMPD.PD_SETUP_TIME_STP), false));
        PTMQMPD(Tmp_read_prod_step_list[I]).PD_EXC_TIME_STP        := StrToFloat(addUpFields(FloatToStr(PTMQMPD(Tmp_read_prod_step_list[I]).PD_EXC_TIME_STP), FloatToStr(MQMPD.PD_EXC_TIME_STP), false));
      end;

      if PTMQMPD(Tmp_read_prod_step_list[I]).PD_STEP_CLOSED = '1' then
      begin
        if MQMPD.PD_STEP_CLOSED = '0' then
          PTMQMPD(Tmp_read_prod_step_list[I]).PD_STEP_CLOSED := '0';
      end;

      Exit;

    end;
  end;

  new(RecMQMPD);
  RecMQMPD^ := MQMPD^;
  RecMQMPD.PD_PREQ_NO := MQMPD.PD_FAMILYCODE;
  Tmp_read_prod_step_list.Insert(LowestHighestValue, RecMQMPD);
end;

//----------------------------------------------------------------------------//

procedure Find_prod_prop_OR_AddToList_FamilyMerge(Tmp_read_prod_prop_list : TList; MQMPP : PTMQMPP);
var
  RecMQMPP : PTMQMPP;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_read_prod_prop_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPP(Tmp_read_prod_prop_list[I]).PP_FAMILYCODE < MQMPP.PP_FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPP(Tmp_read_prod_prop_list[I]).PP_FAMILYCODE > MQMPP.PP_FAMILYCODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPP(Tmp_read_prod_prop_list[I]).PP_PSTEP_ID < MQMPP.PP_PSTEP_ID then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPP(Tmp_read_prod_prop_list[I]).PP_PSTEP_ID > MQMPP.PP_PSTEP_ID) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPP(Tmp_read_prod_prop_list[I]).PP_PROPERTY < MQMPP.PP_PROPERTY then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPP(Tmp_read_prod_prop_list[I]).PP_PROPERTY > MQMPP.PP_PROPERTY) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPP(Tmp_read_prod_prop_list[I]).PP_RSC_CODE < MQMPP.PP_RSC_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPP(Tmp_read_prod_prop_list[I]).PP_RSC_CODE > MQMPP.PP_RSC_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPP(Tmp_read_prod_prop_list[I]).PP_NUMERIC_VALUE > 0 then
      begin
        PTMQMPP(Tmp_read_prod_prop_list[I]).PP_NUMERIC_VALUE := StrToFloat(addUpFields(FloatToStr(PTMQMPP(Tmp_read_prod_prop_list[I]).PP_NUMERIC_VALUE), FloatToStr(MQMPP.PP_NUMERIC_VALUE) , false));
        PTMQMPP(Tmp_read_prod_prop_list[I]).PP_VALUE := FloatToStr(PTMQMPP(Tmp_read_prod_prop_list[I]).PP_NUMERIC_VALUE);
      end;

      Exit;

    end;
  end;

  new(RecMQMPP);
  RecMQMPP^ := MQMPP^;
  RecMQMPP.PP_PREQ_NO := MQMPP.PP_FAMILYCODE;
  Tmp_read_prod_prop_list.Insert(LowestHighestValue, RecMQMPP);
end;

//----------------------------------------------------------------------------//

procedure Find_prod_Step_Time_OR_AddToList_FamilyMerge(Tmp_prod_step_time_list : TList; MQMST : PTMQMST);
var
  RecMQMST : PTMQMST;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_prod_step_time_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(Tmp_prod_step_time_list[I]).ST_FAMILYCODE < MQMST.ST_FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(Tmp_prod_step_time_list[I]).ST_FAMILYCODE > MQMST.ST_FAMILYCODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(Tmp_prod_step_time_list[I]).ST_PSTEP_ID < MQMST.ST_PSTEP_ID then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(Tmp_prod_step_time_list[I]).ST_PSTEP_ID > MQMST.ST_PSTEP_ID) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(Tmp_prod_step_time_list[I]).ST_WKCNTER < MQMST.ST_WKCNTER then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(Tmp_prod_step_time_list[I]).ST_WKCNTER > MQMST.ST_WKCNTER) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(Tmp_prod_step_time_list[I]).ST_WKCT_PROC < MQMST.ST_WKCT_PROC then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(Tmp_prod_step_time_list[I]).ST_WKCT_PROC > MQMST.ST_WKCT_PROC) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(Tmp_prod_step_time_list[I]).ST_RES_CATEGORY < MQMST.ST_RES_CATEGORY then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(Tmp_prod_step_time_list[I]).ST_RES_CATEGORY > MQMST.ST_RES_CATEGORY) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(Tmp_prod_step_time_list[I]).ST_RSC_CODE < MQMST.ST_RSC_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(Tmp_prod_step_time_list[I]).ST_RSC_CODE > MQMST.ST_RSC_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(Tmp_prod_step_time_list[I]).ST_SETUP_TIME_Mechin_Code < MQMST.ST_SETUP_TIME_Mechin_Code then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(Tmp_prod_step_time_list[I]).ST_SETUP_TIME_Mechin_Code > MQMST.ST_SETUP_TIME_Mechin_Code) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(Tmp_prod_step_time_list[I]).ST_timeTypeCode = 'C' then
        PTMQMST(Tmp_prod_step_time_list[I]).ST_EXC_TIME_INIT_QTY := StrToFloat(addUpFields(FloatToStr(PTMQMST(Tmp_prod_step_time_list[I]).ST_EXC_TIME_INIT_QTY), FloatToStr(MQMST.ST_EXC_TIME_INIT_QTY) , false));

      Exit;

    end;
  end;

  new(RecMQMST);
  RecMQMST^ := MQMST^;
  RecMQMST.ST_PREQ_NO := MQMST.ST_FAMILYCODE;
  Tmp_prod_step_time_list.Insert(LowestHighestValue, RecMQMST);
end;

//----------------------------------------------------------------------------//

procedure Find_Material_OR_AddToList_FamilyMerge(Tmp_Material_list : TList; MQMMT : PTMQMMT);
var
  RecMQMMT : PTMQMMT;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_Material_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_FAMILYCODE < MQMMT.MT_FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_FAMILYCODE > MQMMT.MT_FAMILYCODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_PSTEP_ID < MQMMT.MT_PSTEP_ID then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_PSTEP_ID > MQMMT.MT_PSTEP_ID) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_WKCTR_CODE < MQMMT.MT_WKCTR_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_WKCTR_CODE > MQMMT.MT_WKCTR_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_RES_CAT_CODE < MQMMT.MT_RES_CAT_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_RES_CAT_CODE > MQMMT.MT_RES_CAT_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_RES_CODE < MQMMT.MT_RES_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_RES_CODE > MQMMT.MT_RES_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_MACHIN_SETUP_CODE < MQMMT.MT_MACHIN_SETUP_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_MACHIN_SETUP_CODE > MQMMT.MT_MACHIN_SETUP_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_ALTERNATIVE_CODE < MQMMT.MT_ALTERNATIVE_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_ALTERNATIVE_CODE > MQMMT.MT_ALTERNATIVE_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_PROD_TYPE < MQMMT.MT_PROD_TYPE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_PROD_TYPE > MQMMT.MT_PROD_TYPE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_PROD_CODE < MQMMT.MT_PROD_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_PROD_CODE > MQMMT.MT_PROD_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_NET_GROUP_CODE < MQMMT.MT_NET_GROUP_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_NET_GROUP_CODE > MQMMT.MT_NET_GROUP_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_ISSUE_CODE < MQMMT.MT_ISSUE_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_ISSUE_CODE > MQMMT.MT_ISSUE_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMMT(Tmp_Material_list[I]).MT_SEQ_ISSUED < MQMMT.MT_SEQ_ISSUED then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(Tmp_Material_list[I]).MT_SEQ_ISSUED > MQMMT.MT_SEQ_ISSUED) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      PTMQMMT(Tmp_Material_list[I]).MT_HIGH_DATe_ALLOC := getMaximumDate(PTMQMMT(Tmp_Material_list[I]).MT_HIGH_DATe_ALLOC, MQMMT.MT_HIGH_DATe_ALLOC);
      PTMQMMT(Tmp_Material_list[I]).MT_QUANTITY_ALLOC := StrToFloat(addUpFields(FloatToStr(PTMQMMT(Tmp_Material_list[I]).MT_QUANTITY_ALLOC), FloatToStr(MQMMT.MT_QUANTITY_ALLOC) , false));
      PTMQMMT(Tmp_Material_list[I]).MT_QUANTITY_ISSUE := StrToFloat(addUpFields(FloatToStr(PTMQMMT(Tmp_Material_list[I]).MT_QUANTITY_ISSUE), FloatToStr(MQMMT.MT_QUANTITY_ISSUE) , false));
      PTMQMMT(Tmp_Material_list[I]).MT_REQ_QUANTITY   := StrToFloat(addUpFields(FloatToStr(PTMQMMT(Tmp_Material_list[I]).MT_REQ_QUANTITY), FloatToStr(MQMMT.MT_REQ_QUANTITY) , false));

      if PTMQMMT(Tmp_Material_list[I]).MT_SETTLED = '1' then
      begin
        if MQMMT.MT_SETTLED = '0' then
          PTMQMMT(Tmp_Material_list[I]).MT_SETTLED := '0';
      end;

      Exit;

    end;
  end;

  new(RecMQMMT);
  RecMQMMT^ := MQMMT^;
  RecMQMMT.MT_PROD_REQ_Nr := MQMMT.MT_FAMILYCODE;
  Tmp_Material_list.Insert(LowestHighestValue, RecMQMMT);
end;

//----------------------------------------------------------------------------//

procedure Find_prod_info_OR_AddToList_FamilyMerge(Tmp_read_prod_info_list : TList; MQMPI : PTMQMPI);
var
  RecMQMPI : PTMQMPI;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_read_prod_info_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPI(Tmp_read_prod_info_list[I]).PI_FAMILYCODE < MQMPI.PI_FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPI(Tmp_read_prod_info_list[I]).PI_FAMILYCODE > MQMPI.PI_FAMILYCODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPI(Tmp_read_prod_info_list[I]).PI_PSTEP_ID < MQMPI.PI_PSTEP_ID then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPI(Tmp_read_prod_info_list[I]).PI_PSTEP_ID > MQMPI.PI_PSTEP_ID) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPI(Tmp_read_prod_info_list[I]).PI_INFO_TYPE < MQMPI.PI_INFO_TYPE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPI(Tmp_read_prod_info_list[I]).PI_INFO_TYPE > MQMPI.PI_INFO_TYPE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPI(Tmp_read_prod_info_list[I]).PI_INFO_LINE_NUM < MQMPI.PI_INFO_LINE_NUM then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMPI(Tmp_read_prod_info_list[I]).PI_INFO_LINE_NUM > MQMPI.PI_INFO_LINE_NUM) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      Exit;

    end;
  end;

  new(RecMQMPI);
  RecMQMPI^ := MQMPI^;
  RecMQMPI.PI_PREQ_NO := MQMPI.PI_FAMILYCODE;
  Tmp_read_prod_info_list.Insert(LowestHighestValue, RecMQMPI);
end;

//----------------------------------------------------------------------------//

procedure Find_STEP_BATCH_SIZE_FamilyMerge(Tmp_read_Step_Batch_size_list : TList; MQMSB : PTMQMSB);
var
  RecMQMSB : PTMQMSB;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_read_Step_Batch_size_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if (PTMQMSB(Tmp_read_Step_Batch_size_list[I]).SB_FAMILYCODE < MQMSB.SB_FAMILYCODE) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMSB(Tmp_read_Step_Batch_size_list[I]).SB_FAMILYCODE > MQMSB.SB_FAMILYCODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if (PTMQMSB(Tmp_read_Step_Batch_size_list[I]).SB_PSTEP_ID < MQMSB.SB_PSTEP_ID) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMSB(Tmp_read_Step_Batch_size_list[I]).SB_PSTEP_ID > MQMSB.SB_PSTEP_ID) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMSB(Tmp_read_Step_Batch_size_list[I]).SB_PSTEP_ID < MQMSB.SB_PSTEP_ID then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMSB(Tmp_read_Step_Batch_size_list[I]).SB_PSTEP_ID > MQMSB.SB_PSTEP_ID) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMSB(Tmp_read_Step_Batch_size_list[I]).SB_BCH_UM < MQMSB.SB_BCH_UM then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMSB(Tmp_read_Step_Batch_size_list[I]).SB_BCH_UM > MQMSB.SB_BCH_UM) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      Exit;

    end;
  end;

  new(RecMQMSB);
  RecMQMSB^ := MQMSB^;
  RecMQMSB.SB_PREQ_NO := MQMSB.SB_FAMILYCODE;
  Tmp_read_Step_Batch_size_list.Insert(LowestHighestValue, RecMQMSB);
end;

//----------------------------------------------------------------------------//

procedure Find_PRODUCED_ARTICLE_FamilyMerge(read_produced_article_list : TList; MQMPA : PTMQMPA);
var
  RecMQMPA : PTMQMPA;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := read_produced_article_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPA(read_produced_article_list[I]).PA_FAMILYCODE < MQMPA.PA_FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTMQMPA(read_produced_article_list[I]).PA_FAMILYCODE > MQMPA.PA_FAMILYCODE then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPA(read_produced_article_list[I]).PA_PROD_CODE < MQMPA.PA_PROD_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTMQMPA(read_produced_article_list[I]).PA_PROD_CODE > MQMPA.PA_PROD_CODE then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPA(read_produced_article_list[I]).PA_NET_GROUP_Code < MQMPA.PA_NET_GROUP_Code then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTMQMPA(read_produced_article_list[I]).PA_NET_GROUP_Code > MQMPA.PA_NET_GROUP_Code then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMPA(read_produced_article_list[I]).PA_ALL_REQ < MQMPA.PA_ALL_REQ then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTMQMPA(read_produced_article_list[I]).PA_ALL_REQ > MQMPA.PA_ALL_REQ then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      PTMQMPA(read_produced_article_list[I]).PA_REQ_QUANTY := StrToFloat(addUpFields(FloatToStr(PTMQMPA(read_produced_article_list[I]).PA_REQ_QUANTY), FloatToStr(MQMPA.PA_REQ_QUANTY) , false));
      PTMQMPA(read_produced_article_list[I]).PA_QTY_PRODUCED := StrToFloat(addUpFields(FloatToStr(PTMQMPA(read_produced_article_list[I]).PA_QTY_PRODUCED), FloatToStr(MQMPA.PA_QTY_PRODUCED) , false));
      PTMQMPA(read_produced_article_list[I]).PA_QTY_ALL := StrToFloat(addUpFields(FloatToStr(PTMQMPA(read_produced_article_list[I]).PA_QTY_ALL), FloatToStr(MQMPA.PA_QTY_ALL) , false));

      Exit;

    end;
  end;

  new(RecMQMPA);
  RecMQMPA^ := MQMPA^;
  RecMQMPA.PA_PROD_REQ_NR := MQMPA.PA_FAMILYCODE;
  read_produced_article_list.Insert(LowestHighestValue, RecMQMPA);
end;

//----------------------------------------------------------------------------//

procedure Find_Progress_list_FamilyMerge(Tmp_Progress_list : TList; MQMSP : PTPROGRESSES);
var
  RecMQMSP : PTPROGRESSES;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_Progress_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTPROGRESSES(Tmp_Progress_list[I]).FAMILYCODE < MQMSP.FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTPROGRESSES(Tmp_Progress_list[I]).FAMILYCODE > MQMSP.FAMILYCODE then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTPROGRESSES(Tmp_Progress_list[I]).Step < MQMSP.Step then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTPROGRESSES(Tmp_Progress_list[I]).Step > MQMSP.Step then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTPROGRESSES(Tmp_Progress_list[I]).Resource < MQMSP.Resource then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTPROGRESSES(Tmp_Progress_list[I]).Resource > MQMSP.Resource then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      try
        if StrToInt(MQMSP.ProgressType) > StrToInt(PTPROGRESSES(Tmp_Progress_list[I]).ProgressType) then
        begin
          PTPROGRESSES(Tmp_Progress_list[I]).ProgressType := MQMSP.ProgressType;
          PTPROGRESSES(Tmp_Progress_list[I]).ProgressCurrent := MQMSP.ProgressCurrent;
        end;
      except
      end;

      PTPROGRESSES(Tmp_Progress_list[I]).Qty := StrToFloat(addUpFields(FloatToStr(PTPROGRESSES(Tmp_Progress_list[I]).Qty), FloatToStr(MQMSP.Qty) , false));

      Exit;

    end;
  end;

  new(RecMQMSP);
  RecMQMSP^ := MQMSP^;
  RecMQMSP.Request := MQMSP.FAMILYCODE;
  Tmp_Progress_list.Insert(LowestHighestValue, RecMQMSP);
end;

//----------------------------------------------------------------------------//

procedure Find_REQCONN_list_FamilyMerge(Tmp_PROD_REQCONN_list : TList; MQMIC : PTMQMIC);
var
  RecMQMIC : PTMQMIC;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_PROD_REQCONN_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMIC(Tmp_PROD_REQCONN_list[I]).IC_FAMILYCODE < MQMIC.IC_FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTMQMIC(Tmp_PROD_REQCONN_list[I]).IC_FAMILYCODE > MQMIC.IC_FAMILYCODE then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMIC(Tmp_PROD_REQCONN_list[I]).IC_PREV_PREQ_NO < MQMIC.IC_PREV_PREQ_NO then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTMQMIC(Tmp_PROD_REQCONN_list[I]).IC_PREV_PREQ_NO > MQMIC.IC_PREV_PREQ_NO then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      Exit;

    end;
  end;

  new(RecMQMIC);
  RecMQMIC^ := MQMIC^;
  RecMQMIC.IC_PREQ_NO := MQMIC.IC_FAMILYCODE;
  Tmp_PROD_REQCONN_list.Insert(LowestHighestValue, RecMQMIC);
end;

//----------------------------------------------------------------------------//

procedure Find_EXT_CONNECTION_list_FamilyMerge(Tmp_EXT_CONNECTION_list : TList; MQMEC : PTMQMEC);
var
  RecMQMEC : PTMQMEC;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := Tmp_EXT_CONNECTION_list.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMEC(Tmp_EXT_CONNECTION_list[I]).EC_FAMILYCODE < MQMEC.EC_FAMILYCODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTMQMEC(Tmp_EXT_CONNECTION_list[I]).EC_FAMILYCODE > MQMEC.EC_FAMILYCODE then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMEC(Tmp_EXT_CONNECTION_list[I]).EC_CONNE_KEY < MQMEC.EC_CONNE_KEY then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTMQMEC(Tmp_EXT_CONNECTION_list[I]).EC_CONNE_KEY > MQMEC.EC_CONNE_KEY then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      Exit;

    end;
  end;

  new(RecMQMEC);
  RecMQMEC^ := MQMEC^;
  RecMQMEC.EC_PREQ_NO := MQMEC.EC_FAMILYCODE;
  Tmp_EXT_CONNECTION_list.Insert(LowestHighestValue, RecMQMEC);
end;

//----------------------------------------------------------------------------//

function Sort_Concatinated(Item1, Item2: Pointer) : integer;
var
  PRODUCTIONTIME_Concatinated_1 : PPRODUCTIONTIMES;
  PRODUCTIONTIME_Concatinated_2 : PPRODUCTIONTIMES;
begin
  PRODUCTIONTIME_Concatinated_1 := PPRODUCTIONTIMES(Item1);
  PRODUCTIONTIME_Concatinated_2 := PPRODUCTIONTIMES(Item2);
  if PRODUCTIONTIME_Concatinated_1.StrConcatination < PRODUCTIONTIME_Concatinated_2.StrConcatination then
    Result := -1
  else if (PRODUCTIONTIME_Concatinated_1.StrConcatination = PRODUCTIONTIME_Concatinated_2.StrConcatination) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_WORKCENTER(Item1, Item2: Pointer) : integer;
var
  PWORKCENTERS_1 : PWORKCENTERS;
  PWORKCENTERS_2 : PWORKCENTERS;
begin
  PWORKCENTERS_1 := PWORKCENTERS(Item1);
  PWORKCENTERS_2 := PWORKCENTERS(Item2);
  if PWORKCENTERS_1.WC_WKCNTER < PWORKCENTERS_2.WC_WKCNTER then
    Result := -1
  else if (PWORKCENTERS_1.WC_WKCNTER = PWORKCENTERS_2.WC_WKCNTER) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_PPROCESSES(Item1, Item2: Pointer) : integer;
var
  PROCESSES_1 : PPROCESSES;
  PROCESSES_2 : PPROCESSES;
begin
  PROCESSES_1 := PPROCESSES(Item1);
  PROCESSES_2 := PPROCESSES(Item2);
  if PROCESSES_1.WP_WKCT_PROC < PROCESSES_2.WP_WKCT_PROC then
    Result := -1
  else if (PROCESSES_1.WP_WKCT_PROC = PROCESSES_2.WP_WKCT_PROC) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_UserGenericGroupType(Item1, Item2: Pointer) : integer;
var
  UserGenericGroupType_1 : PTUserGenericGroupType;
  UserGenericGroupType_2 : PTUserGenericGroupType;
begin
  UserGenericGroupType_1 := PTUserGenericGroupType(Item1);
  UserGenericGroupType_2 := PTUserGenericGroupType(Item2);
  if (UserGenericGroupType_1.ITEMTYPECODE < UserGenericGroupType_2.ITEMTYPECODE) then
    Result := -1
  else if (UserGenericGroupType_1.ITEMTYPECODE = UserGenericGroupType_2.ITEMTYPECODE) then
  begin
    if (UserGenericGroupType_1.POSITION < UserGenericGroupType_2.POSITION) then
      Result := -1
    else if (UserGenericGroupType_1.POSITION = UserGenericGroupType_2.POSITION) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_ColorType(Item1, Item2: Pointer) : integer;
var
  ColorType_1 : PTColorType;
  ColorType_2 : PTColorType;
begin
  ColorType_1 := PTColorType(Item1);
  ColorType_2 := PTColorType(Item2);
  if (ColorType_1.ITEMTYPECODE < ColorType_2.ITEMTYPECODE) then
    Result := -1
  else if (ColorType_1.ITEMTYPECODE = ColorType_2.ITEMTYPECODE) then
  begin
    if (ColorType_1.POSITION < ColorType_2.POSITION) then
      Result := -1
    else if (ColorType_1.POSITION = ColorType_2.POSITION) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_PropListByCode(Item1, Item2: Pointer) : integer;
var
  PROPS_1 : PPROPS;
  PROPS_2 : PPROPS;
begin
  PROPS_1 := PPROPS(Item1);
  PROPS_2 := PPROPS(Item2);
  if PROPS_1.PY_PROPERTY < PROPS_2.PY_PROPERTY then
    Result := -1
  else if (PROPS_1.PY_PROPERTY = PROPS_2.PY_PROPERTY) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_propRtvValueListByItemType(Item1, Item2: Pointer) : integer;
var
  RTV_VALUE_1 : PPROP_RTV_VALUES;
  RTV_VALUE_2 : PPROP_RTV_VALUES;
begin
  RTV_VALUE_1 := PPROP_RTV_VALUES(Item1);
  RTV_VALUE_2 := PPROP_RTV_VALUES(Item2);
  if RTV_VALUE_1.ITEMTYPE < RTV_VALUE_2.ITEMTYPE then
    Result := -1
  else if (RTV_VALUE_1.ITEMTYPE = RTV_VALUE_2.ITEMTYPE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_ALT_WAREHOUSE_WKC(Item1, Item2: Pointer) : integer;
var
  PALT_WAREHOUSE_1 : PALT_WAREHOUSE_WKCS;
  PALT_WAREHOUSE_2 : PALT_WAREHOUSE_WKCS;
begin
  PALT_WAREHOUSE_1 := PALT_WAREHOUSE_WKCS(Item1);
  PALT_WAREHOUSE_2 := PALT_WAREHOUSE_WKCS(Item2);

  if PALT_WAREHOUSE_1.WORKCENTER < PALT_WAREHOUSE_2.WORKCENTER then
     Result := -1
  else if (PALT_WAREHOUSE_1.WORKCENTER = PALT_WAREHOUSE_2.WORKCENTER) then
  begin
    if (PALT_WAREHOUSE_1.NET_GROUP_CODE < PALT_WAREHOUSE_2.NET_GROUP_CODE) then
       Result := -1
    else if (PALT_WAREHOUSE_1.NET_GROUP_CODE = PALT_WAREHOUSE_2.NET_GROUP_CODE) then
    begin
      if (PALT_WAREHOUSE_1.ISSUE_ITEM_TYPE < PALT_WAREHOUSE_2.ISSUE_ITEM_TYPE) then
        Result := -1
      else if (PALT_WAREHOUSE_1.ISSUE_ITEM_TYPE = PALT_WAREHOUSE_2.ISSUE_ITEM_TYPE) then
      begin
        if (PALT_WAREHOUSE_1.ALTERN_WC < PALT_WAREHOUSE_2.ALTERN_WC) then
          Result := -1
        else if (PALT_WAREHOUSE_1.ALTERN_WC > PALT_WAREHOUSE_2.ALTERN_WC) then
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

//----------------------------------------------------------------------------//

function Sort_PRODUCTS(Item1, Item2: Pointer) : integer;
var
  PPRODUCTS_1 : PPRODUCTS;
  PPRODUCTS_2 : PPRODUCTS;
begin
  PPRODUCTS_1 := PPRODUCTS(Item1);
  PPRODUCTS_2 := PPRODUCTS(Item2);
  if (PPRODUCTS_1.PAR_TYPE_PROD < PPRODUCTS_2.PAR_TYPE_PROD) then
    Result := -1
  else if (PPRODUCTS_1.PAR_TYPE_PROD = PPRODUCTS_2.PAR_TYPE_PROD) then
  begin
    if (PPRODUCTS_1.PAR_PRODUCT_CODE < PPRODUCTS_2.PAR_PRODUCT_CODE) then
      Result := -1
    else if (PPRODUCTS_1.PAR_PRODUCT_CODE = PPRODUCTS_2.PAR_PRODUCT_CODE) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_PRODUCTIONDEMANDTEMPLATES(Item1, Item2: Pointer) : integer;
var
  PRODUCTIONDEMANDTEMPLATES_1 : PPRODUCTIONDEMANDTEMPLATES;
  PRODUCTIONDEMANDTEMPLATES_2 : PPRODUCTIONDEMANDTEMPLATES;
begin
  PRODUCTIONDEMANDTEMPLATES_1 := PPRODUCTIONDEMANDTEMPLATES(Item1);
  PRODUCTIONDEMANDTEMPLATES_2 := PPRODUCTIONDEMANDTEMPLATES(Item2);
  if PRODUCTIONDEMANDTEMPLATES_1.CODE < PRODUCTIONDEMANDTEMPLATES_2.CODE then
    Result := -1
  else if (PRODUCTIONDEMANDTEMPLATES_1.CODE = PRODUCTIONDEMANDTEMPLATES_2.CODE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_OPERATIONS(Item1, Item2: Pointer) : integer;
var
  OPERATIONS_1 : POPERATIONS;
  OPERATIONS_2 : POPERATIONS;
begin
  OPERATIONS_1 := POPERATIONS(Item1);
  OPERATIONS_2 := POPERATIONS(Item2);
  if OPERATIONS_1.CODE < OPERATIONS_2.CODE then
    Result := -1
  else if (OPERATIONS_1.CODE = OPERATIONS_2.CODE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_LOGICALWAREHOUSES(Item1, Item2: Pointer) : integer;
var
  LOGICALWAREHOUSES_1 : PLOGICALWAREHOUSES;
  LOGICALWAREHOUSES_2 : PLOGICALWAREHOUSES;
begin
  LOGICALWAREHOUSES_1 := PLOGICALWAREHOUSES(Item1);
  LOGICALWAREHOUSES_2 := PLOGICALWAREHOUSES(Item2);
  if LOGICALWAREHOUSES_1.CODE < LOGICALWAREHOUSES_2.CODE then
    Result := -1
  else if (LOGICALWAREHOUSES_1.CODE = LOGICALWAREHOUSES_2.CODE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_ITEMTYPETEMPLATES(Item1, Item2: Pointer) : integer;
var
  ITEMTYPETEMPLATES_1 : PITEMTYPETEMPLATES;
  ITEMTYPETEMPLATES_2 : PITEMTYPETEMPLATES;
begin
  ITEMTYPETEMPLATES_1 := PITEMTYPETEMPLATES(Item1);
  ITEMTYPETEMPLATES_2 := PITEMTYPETEMPLATES(Item2);
  if ITEMTYPETEMPLATES_1.ITEMTYPECODE < ITEMTYPETEMPLATES_2.ITEMTYPECODE then
    Result := -1
  else if (ITEMTYPETEMPLATES_1.ITEMTYPECODE = ITEMTYPETEMPLATES_2.ITEMTYPECODE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_PPRODUCTIONDEMANDCOUNTERS(Item1, Item2: Pointer) : integer;
var
  RODUCTIONDEMANDCOUNTERS_1 : PPRODUCTIONDEMANDCOUNTERS;
  RODUCTIONDEMANDCOUNTERS_2 : PPRODUCTIONDEMANDCOUNTERS;
begin
  RODUCTIONDEMANDCOUNTERS_1 := PPRODUCTIONDEMANDCOUNTERS(Item1);
  RODUCTIONDEMANDCOUNTERS_2 := PPRODUCTIONDEMANDCOUNTERS(Item2);
  if RODUCTIONDEMANDCOUNTERS_1.CODE < RODUCTIONDEMANDCOUNTERS_2.CODE then
    Result := -1
  else if (RODUCTIONDEMANDCOUNTERS_1.CODE = RODUCTIONDEMANDCOUNTERS_2.CODE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_SALESORDERS(Item1, Item2: Pointer) : integer;
var
  SALESORDERS_1 : PSALESORDERS;
  SALESORDERS_2 : PSALESORDERS;
begin
  SALESORDERS_1 := PSALESORDERS(Item1);
  SALESORDERS_2 := PSALESORDERS(Item2);
  if SALESORDERS_1.CODE < SALESORDERS_2.CODE then
    Result := -1
  else if (SALESORDERS_1.CODE = SALESORDERS_2.CODE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_ARTICLE_TYPES(Item1, Item2: Pointer) : integer;
var
  PARTICLE_TYPES_1 : PARTICLE_TYPES;
  PARTICLE_TYPES_2 : PARTICLE_TYPES;
begin
  PARTICLE_TYPES_1 := PARTICLE_TYPES(Item1);
  PARTICLE_TYPES_2 := PARTICLE_TYPES(Item2);
  if PARTICLE_TYPES_1.AT_ART_TYPE < PARTICLE_TYPES_2.AT_ART_TYPE then
    Result := -1
  else if (PARTICLE_TYPES_1.AT_ART_TYPE = PARTICLE_TYPES_2.AT_ART_TYPE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_PRODUCTIONPROGRESSTEMPLATES(Item1, Item2: Pointer) : integer;
var
  PRODUCTIONPROGRESSTEMPLATES_1 : PPRODUCTIONPROGRESSTEMPLATES;
  PRODUCTIONPROGRESSTEMPLATES_2 : PPRODUCTIONPROGRESSTEMPLATES;
begin
  PRODUCTIONPROGRESSTEMPLATES_1 := PPRODUCTIONPROGRESSTEMPLATES(Item1);
  PRODUCTIONPROGRESSTEMPLATES_2 := PPRODUCTIONPROGRESSTEMPLATES(Item2);
  if PRODUCTIONPROGRESSTEMPLATES_1.CODE < PRODUCTIONPROGRESSTEMPLATES_2.CODE then
    Result := -1
  else if (PRODUCTIONPROGRESSTEMPLATES_1.CODE = PRODUCTIONPROGRESSTEMPLATES_2.CODE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Sort_List_TNA_By_ABSUNIQUEID(Item1, Item2: Pointer) : integer;
var
  PT_TNA_1, PT_TNA_2 : PT_TNA;
begin
  PT_TNA_1 := PT_TNA(Item1);
  PT_TNA_2 := PT_TNA(Item2);
  if PT_TNA_1.ABSUniqueId < PT_TNA_2.ABSUniqueId then
    Result := -1
  else if (PT_TNA_1.ABSUniqueId = PT_TNA_2.ABSUniqueId) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

initialization

 M_ABSCOMPANYHANDLING := TList.Create;

finalization

FreeCompanyLevelHandlingByEntity;

end.

