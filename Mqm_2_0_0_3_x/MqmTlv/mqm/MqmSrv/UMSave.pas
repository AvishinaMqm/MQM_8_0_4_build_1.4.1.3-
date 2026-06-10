unit UMSave;

interface

uses
  Windows,
  UMTblDesc,
  Db,
  DMSrvPC,
  ADOdb,
  DateUtils,
  gnugettext;

  function SaveProdSched(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function SaveProdSchedMcm(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function SendRes(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function SendSubRes(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function SendProp_Res(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function SendWkst_Wkc(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function SendPlannerProperties(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
//  function SendStockDetails(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function SendCapRes(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;

implementation

uses
  SysUtils,
  UMSrvConfig,
  UMSrvLoad,
  Classes,
  UGconvert,
  UmGlobal,
  UMTransfer,
  UMCommon,
  UOpThread,
  UMSaveLoad;

//----------------------------------------------------------------------------//

type
  RecPropPlanner = record
    preqNo       : string;
    pstepId      : Integer;
    PropertyCode : string;
    PropValue    : string;
    usrCr        : string;
    usrTmCr      : TDateTime;
  end;
  pRecPropPlanner = ^RecPropPlanner;

  RecPropSched = record
    preqNo   : string;
    pstepId  : integer;
    psubstId : integer;
    reprocNo : integer;
    ProdType : string;
    ProdLine : string;
    ProdUMCode : string;
    StepType   : string;
    stGroup    : integer;
    StepIsGrouped  : string;
    schedType    : string;
    wkCtrCode    : string;
    wkcProc      : string;
    AlternativCode : string;
    rsc            : string;
    subLinRscId    : integer;
    NumSubRscComponents : integer;
    quant      : double;
    supMinReal : double;
    supMinBase : double;
//    supMinOvlp : double;
    exeMin     : double;
    schedStart : TDateTime;
    schedEnd   : TDateTime;
    ActualStart : TDateTime;
    ActualEnd   : TDateTime;
    Comment    : string;
    ConnForwardSubStep   : integer;
    ConnForwardReProcess : integer;
    ConnBackwardSubStep  : integer;
    ConnBackwardReProcess : integer;
    SaveAtLeastOnesAsFinnal : string;
    MachSetupCode   : string;
    NettedQuantity  : double;
    ChangedQuantity : double;
    NEW_PREQ_UNIQ_ID : string;
    usrCr    : string;
    usrTmCr  : TDateTime;
    usrCg    : string;
    usrTmCg  : TDateTime;
  end;
  pRecPropSched = ^RecPropSched;

  RecCapRes = record
    CapResNum    : Integer;
    Res          : string;
    SubLinRscId : Integer;
    WCProcess    : string;
    CapacyResTyp : string;
    Capacity_To_Job : string;
    Comment : string;
    schedStart : TDateTime;
    schedEnd   : TDateTime;
  end;
  pRecCapRes = ^RecCapRes;

  RecPSValues = record
    preqNo   : string;
    pstepId  : string;
    UM       : string;
    Qty      : string;
  end;
  PRecPSValues = ^RecPSValues;


function GetHostTableName(Name : string; var HostTableName : string) : boolean;
var
  qry:    TMqmQuery;
//  trs:    TMqmTransaction;
  tbInfo: ^TTblInfo;
begin
  Result := false;
  HostTableName := '';
//  trs := CreateTransaction(Cfg_DB);
  qry := ThreadCreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_Archive_To_Host];

//  trs.StartTransaction;
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
//  trs.free;
  qry.Free;
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
  DateTimeFormat : TDateTimeFormat;
begin
  tbInfo := @tblInfo[tbl];

  tblName := ASLib + tbInfo.ASname;
  DateTimeFormat := GetDateTimeFormat;

  // select the data from AS400
  with srvQry do
  begin
    UpdateOperation(_('PC query ') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('select');
    for i := 0 to High(linkArr)-1 do
      SQL.Add(CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + ' from ' + tbInfo.GetTableName);
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
      linkList.Add(srvQry.FieldByName(CreateFld(tbInfo.pfx,linkArr[i].fldPC)))
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
                          if (DateTimeFormat = Frm_As400) then
                          begin
                            TParameter(linkList[parm]).DataType := ftFloat;
                            TParameter(linkList[parm]).value := DateTimeToTimDateTime(TField(linkList[field]).AsDateTime)
                          end
                          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTimeExceptControl) then
                          begin
                            TParameter(linkList[parm]).DataType := ftDateTime;
                            TParameter(linkList[parm]).value := TField(linkList[field]).AsDateTime;
                          end;
                        end;
          TLD_dateTime :begin
                          if (DateTimeFormat = Frm_As400) then
                          begin
                            TParameter(linkList[parm]).DataType := ftFloat;
                            TParameter(linkList[parm]).value := DateTimeToTimDateTime(TField(linkList[field]).AsDateTime)
                          end
                          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTimeExceptControl) then
                          begin
                            TParameter(linkList[parm]).DataType := ftString;
                            TParameter(linkList[parm]).value := Datetimetostr(TField(linkList[field]).AsDateTime);                          end;
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

function InsertHostQryTables(tbl: table; linkArr: array of TQryLinkRec; srvQry: TMqmQuery) : boolean;
var
  tbInfo:         ^TTblInfo;
  I : Integer;
  sl : TStringList;
  InstSql : String;
begin
  Result := true;
  tbInfo := @tblInfo[tbl];
  InstSql := '';
  try

//  with srvQry do
//  begin

   // InstSql.Clear;
    InstSql := 'insert into ' + tbInfo.ASname + ' (';
//    InstSql.Add('insert into ' + tbInfo.ASname + ' (');
    for i := 0 to High(linkArr)-1 do
      //InstSql.Add(linkArr[i].fldAS + ',');
      InstSql := InstSql + linkArr[i].fldAS + ',';

    //InstSql.Add(linkArr[High(linkArr)].fldAS);

    InstSql := InstSql + linkArr[High(linkArr)].fldAS;

 //   InstSql.Add(') values (');

    InstSql := InstSql + ') values (';
    for i := 0 to High(linkArr)-1 do
     // InstSql.Add(':' + linkArr[i].fldAS + ',');
       InstSql := InstSql + ':' + linkArr[i].fldAS + ',';

   // InstSql.Add(':' +   linkArr[High(linkArr)].fldAS + ')');
    InstSql := InstSql + ':' +   linkArr[High(linkArr)].fldAS + ')';

    srvQry.SQL.Text := InstSql;
//  end;


  except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add('while Insert ' + tbInfo.GetTableName);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        Result := false
      end
  end;

end;

//----------------------------------------------------------------------------//

function SortProdSched10F(Item1, Item2: Pointer) : integer;
var
  MQMPS1 : pRecPropSched;
  MQMPS2 : pRecPropSched;
begin
  MQMPS1 := pRecPropSched(Item1);
  MQMPS2 := pRecPropSched(Item2);
  if MQMPS1.preqNo < MQMPS2.preqNo then
     Result := -1
  else if (MQMPS1.preqNo = MQMPS2.preqNo) then
  begin
    if (MQMPS1.pstepId < MQMPS2.pstepId) then
       Result := -1
    else if (MQMPS1.pstepId = MQMPS2.pstepId) then
    begin
      if (MQMPS1.psubstId < MQMPS2.psubstId) then
        Result := -1
      else if (MQMPS1.psubstId = MQMPS2.psubstId) then
      begin
        if (MQMPS1.reprocNo < MQMPS2.reprocNo) then
          Result := -1
        else if (MQMPS1.reprocNo > MQMPS2.reprocNo) then
          Result := 1
        else
          Result  := 0;
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

//-----------------------------------------------------------------------------

function SendMqmPs10FTable(tbl: table; ASLib, PCcondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery; found_NEW_PREQ_UNIQ_ID : boolean; found_ActualDateTime : boolean; var ErrorSql : string): boolean;
var
  tbProdSched : ^TTblInfo;
  RecProdSched : pRecPropSched;
  ListProdSched : TList;
  IndexPS : Integer;
  SqlHost, SqlSrv, ChangeType : string;
  CommentStr : string;
  I : integer;
  QryDel, QryUpdate, QryInsert : TMqmQuery;

  TempStartDateTime, TempEndDateTime, TempActualStartDateTime, TempActualEndDateTime : TDateTime;
  Year, Month, Day, Hour, Minute, Second, MilliSecond : word;
begin
  tbProdSched := @tblInfo[tbl];

  TempActualStartDateTime := 0;
  TempActualEndDateTime := 0;

  Result := true;

  srvQry.SQL.Clear;
  SqlSrv := 'Select count(*) from ' + tbProdSched.GetTableName;
  srvQry.sql.Text := SqlSrv;
  srvQry.open;
  srvQry.FieldByName('count').asInteger;

  srvQry.SQL.Clear;
  srvQry.SQL.Add('update ' + tbProdSched.GetTableName + ' set ' + CreateFld(tbProdSched.pfx,fli_exeMin) + ' = ' + '999999 where ' + CreateFld(tbProdSched.pfx,fli_exeMin) + '>  999999');
  srvQry.ExecSQL;
//  srvQry.Transaction.Commit;

  srvQry.SQL.Clear;
  srvQry.SQL.Add('update ' + tbProdSched.GetTableName + ' set ' + CreateFld(tbProdSched.pfx,fli_exeMin) + ' = ' + '999999 where ' + CreateFld(tbProdSched.pfx,fli_exeMin) + '<  -999999');
  srvQry.ExecSQL;
  srvQry.Transaction.Commit;

  SqlSrv := 'Select * from ' + tbProdSched.GetTableName;
  SqlSrv := SqlSrv + ' Order by ' + CreateFld(tbProdSched.pfx, fli_preqNo);
  SqlSrv := SqlSrv + ', ' + CreateFld(tbProdSched.pfx, fli_pstepId);
  SqlSrv := SqlSrv + ', ' + CreateFld(tbProdSched.pfx, fli_psubstId);
  SqlSrv := SqlSrv + ', ' + CreateFld(tbProdSched.pfx, fli_reprocNo);
  srvQry.sql.Text := SqlSrv;

  srvQry.open;

  UpdateOperation(_('Updating') + '  ' + tbProdSched.ASname + ' ' + (_('in host . . .')));
  HostQry.sql.Clear;

  // for TMG , each time delete all
  SqlHost := 'delete from ' + tbProdSched.ASname;
  HostQry.Sql.Text := SqlHost;
  HostQry.ExecSQL;
  HostQry.Sql.Clear;

  SqlHost := 'select * from ' + tbProdSched.ASname;
  SqlHost := SqlHost + ' Order by ' + linkArr[0].fldAS + ',' + linkArr[1].fldAS + ',' + linkArr[2].fldAS + ',' + linkArr[3].fldAS;
  HostQry.Sql.Clear;
  HostQry.Sql.Text := SqlHost;
  HostQry.Open;

  ListProdSched := TList.Create;

  QryDel    := ThreadCreateQueryHost;
  QryUpdate := ThreadCreateQueryHost;
  QryInsert := ThreadCreateQueryHost;

  InsertHostQryTables(tbl,linkArr,QryInsert);

  //  fix noscheduled ps, datetime start/end no sec , fast insert qry

  while not HostQry.Eof do
  begin
    new(RecProdSched);
    RecProdSched.preqNo          := Trim(HostQry.FieldByName(linkArr[0].fldAS).AsString);
    RecProdSched.pstepId         := HostQry.FieldByName(linkArr[1].fldAS).AsInteger;
    RecProdSched.psubstId        := HostQry.FieldByName(linkArr[2].fldAS).AsInteger;
    RecProdSched.reprocNo        := HostQry.FieldByName(linkArr[3].fldAS).AsInteger;
    RecProdSched.ProdType        := Trim(HostQry.FieldByName(linkArr[4].fldAS).AsString);
    RecProdSched.ProdLine        := Trim(HostQry.FieldByName(linkArr[5].fldAS).AsString);
    RecProdSched.ProdUMCode      := Trim(HostQry.FieldByName(linkArr[6].fldAS).AsString);
    RecProdSched.StepType        := Trim(HostQry.FieldByName(linkArr[7].fldAS).AsString);
    RecProdSched.stGroup         := HostQry.FieldByName(linkArr[8].fldAS).AsInteger;
    RecProdSched.StepIsGrouped   := Trim(HostQry.FieldByName(linkArr[9].fldAS).AsString);
    RecProdSched.schedType       := Trim(HostQry.FieldByName(linkArr[10].fldAS).AsString);
    RecProdSched.wkCtrCode       := Trim(HostQry.FieldByName(linkArr[11].fldAS).AsString);
    RecProdSched.wkcProc         := Trim(HostQry.FieldByName(linkArr[12].fldAS).AsString);
    RecProdSched.AlternativCode  := Trim(HostQry.FieldByName(linkArr[13].fldAS).AsString);
    RecProdSched.rsc             := Trim(HostQry.FieldByName(linkArr[14].fldAS).AsString);
    RecProdSched.subLinRscId     := HostQry.FieldByName(linkArr[15].fldAS).AsInteger;
    RecProdSched.NumSubRscComponents := HostQry.FieldByName(linkArr[16].fldAS).AsInteger;
    RecProdSched.quant           := HostQry.FieldByName(linkArr[17].fldAS).AsFloat;
    RecProdSched.supMinReal      := HostQry.FieldByName(linkArr[18].fldAS).AsFloat;
    RecProdSched.supMinBase      := HostQry.FieldByName(linkArr[19].fldAS).AsFloat;
//    RecProdSched.supMinOvlp      := HostQry.FieldByName(linkArr[20].fldAS).AsFloat;
    RecProdSched.exeMin          := HostQry.FieldByName(linkArr[20].fldAS).AsFloat;
    RecProdSched.schedStart      := TimDateTimeToDateTime(HostQry.FieldByName(linkArr[21].fldAS).AsFloat);
    RecProdSched.schedEnd        := TimDateTimeToDateTime(HostQry.FieldByName(linkArr[22].fldAS).AsFloat);
    RecProdSched.Comment         := Trim(HostQry.FieldByName(linkArr[23].fldAS).AsString);
    RecProdSched.ConnForwardSubStep := HostQry.FieldByName(linkArr[24].fldAS).AsInteger;
    RecProdSched.ConnForwardReProcess := HostQry.FieldByName(linkArr[25].fldAS).AsInteger;
    RecProdSched.ConnBackwardSubStep  := HostQry.FieldByName(linkArr[26].fldAS).AsInteger;
    RecProdSched.ConnBackwardReProcess := HostQry.FieldByName(linkArr[27].fldAS).AsInteger;
    RecProdSched.SaveAtLeastOnesAsFinnal := Trim(HostQry.FieldByName(linkArr[28].fldAS).AsString);
    RecProdSched.MachSetupCode     := Trim(HostQry.FieldByName(linkArr[29].fldAS).AsString);
    RecProdSched.NettedQuantity    := HostQry.FieldByName(linkArr[30].fldAS).AsFloat;
    RecProdSched.ChangedQuantity   := HostQry.FieldByName(linkArr[31].fldAS).AsFloat;
    RecProdSched.NEW_PREQ_UNIQ_ID := '';
    if found_NEW_PREQ_UNIQ_ID then
      RecProdSched.NEW_PREQ_UNIQ_ID := trim(HostQry.FieldByName(linkArr[36].fldAS).AsString);
    if found_ActualDateTime then
    begin
      RecProdSched.ActualStart      := TimDateTimeToDateTime(HostQry.FieldByName(linkArr[37].fldAS).AsFloat);
      RecProdSched.ActualEnd        := TimDateTimeToDateTime(HostQry.FieldByName(linkArr[38].fldAS).AsFloat);
    end;

    ListProdSched.Add(RecProdSched);
    HostQry.Next;
  end;

  ListProdSched.Sort(SortProdSched10F);
  IndexPS := 0;

  while true do
  begin

    if (IndexPS > ListProdSched.count - 1) and srvQry.Eof then break;

    while True do
    begin
      if (IndexPS > ListProdSched.count - 1) then
      begin
        ChangeType := '1';
        break;
      end;

      if srvQry.Eof then
      begin
        ChangeType := '3';
        break;
      end;

      if pRecPropSched(ListProdSched[IndexPS]).preqNo > Trim(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_preqNo)).AsString) then
      begin
        ChangeType := '1';
        break;
      end;

      if pRecPropSched(ListProdSched[IndexPS]).preqNo < Trim(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_preqNo)).AsString) then
      begin
        ChangeType := '3';
        break;
      end;

      if pRecPropSched(ListProdSched[IndexPS]).pstepId > srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_pstepId)).AsInteger then
      begin
        ChangeType := '1';
        break;
      end;

      if pRecPropSched(ListProdSched[IndexPS]).pstepId < srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_pstepId)).AsInteger then
      begin
        ChangeType := '3';
        break;
      end;

      if pRecPropSched(ListProdSched[IndexPS]).psubstId > srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_psubstId)).AsInteger then
      begin
        ChangeType := '1';
        break;
      end;

      if pRecPropSched(ListProdSched[IndexPS]).psubstId < srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_psubstId)).AsInteger then
      begin
        ChangeType := '3';
        break;
      end;

      if pRecPropSched(ListProdSched[IndexPS]).reprocNo > srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_reprocNo)).AsInteger then
      begin
        ChangeType := '1';
        break;
      end;

      if pRecPropSched(ListProdSched[IndexPS]).reprocNo < srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_reprocNo)).AsInteger then
      begin
        ChangeType := '3';
        break;
      end;

      TempStartDateTime := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedStart)).AsDateTime;
      DecodeDateTime(TempStartDateTime,Year,Month,Day,Hour,Minute,Second,MilliSecond);
      TempStartDateTime := EncodeDateTime(Year, Month, Day, Hour, Minute, 0, 0);

      TempEndDateTime := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedEnd)).AsDateTime;
      DecodeDateTime(TempEndDateTime,Year,Month,Day,Hour,Minute,Second,MilliSecond);
      TempEndDateTime := EncodeDateTime(Year, Month, Day, Hour, Minute, 0, 0);

      if found_ActualDateTime then
      begin
        TempActualStartDateTime := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ActualStart)).AsDateTime;
        DecodeDateTime(TempActualStartDateTime,Year,Month,Day,Hour,Minute,Second,MilliSecond);
        TempActualStartDateTime := EncodeDateTime(Year, Month, Day, Hour, Minute, 0, 0);
        TempActualEndDateTime := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ActualEnd)).AsDateTime;
        DecodeDateTime(TempActualEndDateTime,Year,Month,Day,Hour,Minute,Second,MilliSecond);
        TempActualEndDateTime := EncodeDateTime(Year, Month, Day, Hour, Minute, 0, 0);
      end;

      CommentStr := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_Comment)).AsString;
      for i := length(CommentStr) downto 1 do
        if CommentStr[i] = '"' then
          CommentStr[i] := ' ';
      CommentStr := StringReplace(CommentStr,'''','',[rfReplaceAll]);

      if (pRecPropSched(ListProdSched[IndexPS]).ProdType = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ProdType)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).ProdLine = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ProdLine)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).ProdUMCode = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ProdUMCode)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).StepType = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_StepType)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).stGroup = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_stGroup)).AsInteger) and
         (pRecPropSched(ListProdSched[IndexPS]).StepIsGrouped = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_StepIsGrouped)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).schedType = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedType)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).wkCtrCode = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_wkCtrCode)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).wkcProc   = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_wkcProc)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).AlternativCode = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_AlternativCode)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).rsc = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_rsc)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).subLinRscId = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_subLinRscId)).AsInteger) and
         (pRecPropSched(ListProdSched[IndexPS]).NumSubRscComponents = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NumSubRscComponents)).AsInteger) and
         (pRecPropSched(ListProdSched[IndexPS]).quant = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_quant)).AsFloat) and
         (pRecPropSched(ListProdSched[IndexPS]).supMinReal   = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_supMinReal)).AsFloat) and
         (pRecPropSched(ListProdSched[IndexPS]).supMinBase = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_supMinBase)).AsFloat) and
         (pRecPropSched(ListProdSched[IndexPS]).exeMin = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_exeMin)).AsFloat) and
         (pRecPropSched(ListProdSched[IndexPS]).schedStart = TempStartDateTime) and//srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedStart)).AsDateTime) and
         (pRecPropSched(ListProdSched[IndexPS]).schedEnd = TempEndDateTime) and//srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedEnd)).AsDateTime) and
         (pRecPropSched(ListProdSched[IndexPS]).Comment = Trim(CommentStr)) and //srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_Comment)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).ConnForwardSubStep   = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnForwardSubStep)).AsInteger) and
         (pRecPropSched(ListProdSched[IndexPS]).ConnForwardReProcess = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnForwardReProcess)).AsInteger) and
         (pRecPropSched(ListProdSched[IndexPS]).ConnBackwardSubStep = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnBackwardSubStep)).AsInteger) and
         (pRecPropSched(ListProdSched[IndexPS]).ConnBackwardReProcess = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnBackwardReProcess)).AsInteger) and
         (pRecPropSched(ListProdSched[IndexPS]).SaveAtLeastOnesAsFinnal = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_SaveAtLeastOnesAsFinnal)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).MachSetupCode = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_MachSetupCode)).AsString) and
         (pRecPropSched(ListProdSched[IndexPS]).NettedQuantity = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NettedQuantity)).AsFloat) and
         (pRecPropSched(ListProdSched[IndexPS]).ChangedQuantity = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ChangedQuantity)).AsFloat) then

      begin

        if found_NEW_PREQ_UNIQ_ID and found_ActualDateTime then
        begin
          if (pRecPropSched(ListProdSched[IndexPS]).NEW_PREQ_UNIQ_ID = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NewPreqUniqId)).AsString) and
             (pRecPropSched(ListProdSched[IndexPS]).ActualStart = TempActualStartDateTime) and
             (pRecPropSched(ListProdSched[IndexPS]).ActualEnd   = TempActualEndDateTime) then
          begin
            ChangeType := '0';
            break;
          end
        end
        else if found_NEW_PREQ_UNIQ_ID then
        begin
          if (pRecPropSched(ListProdSched[IndexPS]).NEW_PREQ_UNIQ_ID = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NewPreqUniqId)).AsString) then
          begin
            ChangeType := '0';
            break;
          end;
        end;

     {   if found_NEW_PREQ_UNIQ_ID and (pRecPropSched(ListProdSched[IndexPS]).NEW_PREQ_UNIQ_ID = srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NewPreqUniqId)).AsString) then
        begin
          ChangeType := '0';
          break;
        end;  }
      end;

      ChangeType := '2';
      break;
    end;

     if ChangeType = '1' then
     begin
       QryInsert.ParamByName(linkArr[0].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[0].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_preqNo)).AsString;
       QryInsert.ParamByName(linkArr[1].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(linkArr[1].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_pstepId)).AsInteger;
       QryInsert.ParamByName(linkArr[2].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(linkArr[2].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_psubstId)).AsInteger;
       QryInsert.ParamByName(linkArr[3].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(linkArr[3].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_reprocNo)).AsInteger;
       QryInsert.ParamByName(linkArr[4].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[4].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ProdType)).AsString;
       QryInsert.ParamByName(linkArr[5].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[5].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ProdLine)).AsString;
       QryInsert.ParamByName(linkArr[6].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[6].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ProdUMCode)).AsString;
       QryInsert.ParamByName(linkArr[7].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[7].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_StepType)).AsString;
       QryInsert.ParamByName(linkArr[8].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(linkArr[8].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_stGroup)).AsInteger;
       QryInsert.ParamByName(linkArr[9].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[9].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_StepIsGrouped)).AsString;
       QryInsert.ParamByName(linkArr[10].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[10].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedType)).AsString;
       QryInsert.ParamByName(linkArr[11].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[11].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_wkCtrCode)).AsString;
       QryInsert.ParamByName(linkArr[12].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[12].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_wkcProc)).AsString;
       QryInsert.ParamByName(linkArr[13].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[13].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_AlternativCode)).AsString;
       QryInsert.ParamByName(linkArr[14].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[14].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_rsc)).AsString;
       QryInsert.ParamByName(linkArr[15].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(linkArr[15].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_subLinRscId)).AsInteger;
       QryInsert.ParamByName(linkArr[16].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(linkArr[16].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NumSubRscComponents)).AsInteger;
       QryInsert.ParamByName(linkArr[17].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(linkArr[17].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_quant)).AsFloat;
       QryInsert.ParamByName(linkArr[18].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(linkArr[18].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_supMinReal)).AsFloat;
       QryInsert.ParamByName(linkArr[19].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(linkArr[19].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_supMinBase)).AsFloat;
       QryInsert.ParamByName(linkArr[20].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(linkArr[20].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_exeMin)).AsFloat;
       QryInsert.ParamByName(linkArr[21].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(linkArr[21].fldAS).Value := DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedStart)).AsDateTime);
       QryInsert.ParamByName(linkArr[22].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(linkArr[22].fldAS).Value := DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedEnd)).AsDateTime);
       QryInsert.ParamByName(linkArr[23].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[23].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_Comment)).AsString;
       QryInsert.ParamByName(linkArr[24].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(linkArr[24].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnForwardSubStep)).AsInteger;
       QryInsert.ParamByName(linkArr[25].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(linkArr[25].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnForwardReProcess)).AsInteger;
       QryInsert.ParamByName(linkArr[26].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(linkArr[26].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnBackwardSubStep)).AsInteger;
       QryInsert.ParamByName(linkArr[27].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(linkArr[27].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnBackwardReProcess)).AsInteger;
       QryInsert.ParamByName(linkArr[28].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[28].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_SaveAtLeastOnesAsFinnal)).AsString;
       QryInsert.ParamByName(linkArr[29].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[29].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_MachSetupCode)).AsString;
       QryInsert.ParamByName(linkArr[30].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(linkArr[30].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NettedQuantity)).AsFloat;
       QryInsert.ParamByName(linkArr[31].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(linkArr[31].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ChangedQuantity)).AsFloat;
       QryInsert.ParamByName(linkArr[32].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[32].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_usrCr)).AsString;
       QryInsert.ParamByName(linkArr[33].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(linkArr[33].fldAS).Value := DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_usrTmCr)).AsDateTime);
       QryInsert.ParamByName(linkArr[34].fldAS).DataType := ftString;
       QryInsert.ParamByName(linkArr[34].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_usrCg)).AsString;
       QryInsert.ParamByName(linkArr[35].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(linkArr[35].fldAS).Value := DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_usrTmCg)).AsDateTime);

       if found_NEW_PREQ_UNIQ_ID then
       begin
         QryInsert.ParamByName(linkArr[36].fldAS).DataType := ftString;
         QryInsert.ParamByName(linkArr[36].fldAS).Value := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NewPreqUniqId)).AsString;
       end;

       if found_ActualDateTime then
       begin
         QryInsert.ParamByName(linkArr[37].fldAS).DataType := ftFloat;
         QryInsert.ParamByName(linkArr[37].fldAS).Value := DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ActualStart)).AsDateTime);
         QryInsert.ParamByName(linkArr[38].fldAS).DataType := ftFloat;
         QryInsert.ParamByName(linkArr[38].fldAS).Value := DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ActualEnd)).AsDateTime);
       end;

       try
         QryInsert.ExecSQL;
       except
         ErrorSql := 'Problem Occured while Inserting : ' + 'Req : ' +
                     srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_preqNo)).AsString + ' Step : ' +
                     IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_pstepId)).AsInteger) + ' Sub Step ' +
                     IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_psubstId)).AsInteger);
         ErrorSql := ErrorSql + ' SQL ERROR : ' + QryInsert.SQL.Text;
         Raise;
       end;
       srvQry.Next;
       continue;
     end;

     if ChangeType = '2' then
     begin
       QryUpdate.SQL.Clear;
       SqlHost := 'Update ' + tbProdSched.ASname + ' set ';
       SqlHost := SqlHost +  linkArr[4].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ProdType)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[5].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ProdLine)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[6].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ProdUMCode)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[7].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_StepType)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[8].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_stGroup)).AsInteger) + '''';
       SqlHost := SqlHost + ',' + linkArr[9].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_StepIsGrouped)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[10].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedType)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[11].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_wkCtrCode)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[12].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_wkcProc)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[13].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_AlternativCode)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[14].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_rsc)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[15].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_subLinRscId)).AsInteger) + '''';
       SqlHost := SqlHost + ',' + linkArr[16].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NumSubRscComponents)).AsInteger) + '''';
       SqlHost := SqlHost + ',' + linkArr[17].fldAS + '= ''' + FloatToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_quant)).AsFloat) + '''';
       SqlHost := SqlHost + ',' + linkArr[18].fldAS + '= ''' + FloatToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_supMinReal)).AsFloat) + '''';
       SqlHost := SqlHost + ',' + linkArr[19].fldAS + '= ''' + FloatToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_supMinBase)).AsFloat) + '''';
       SqlHost := SqlHost + ',' + linkArr[20].fldAS + '= ''' + FloatToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_exeMin)).AsFloat) + '''';
       SqlHost := SqlHost + ',' + linkArr[21].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedStart)).AsFloat)) + '''';
       SqlHost := SqlHost + ',' + linkArr[22].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_schedEnd)).AsFloat)) + '''';
       SqlHost := SqlHost + ',' + linkArr[23].fldAS + '= ''' + CommentStr + '''';
       SqlHost := SqlHost + ',' + linkArr[24].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnForwardSubStep)).AsInteger) + '''';
       SqlHost := SqlHost + ',' + linkArr[25].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnForwardReProcess)).AsInteger) + '''';
       SqlHost := SqlHost + ',' + linkArr[26].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnBackwardSubStep)).AsInteger) + '''';
       SqlHost := SqlHost + ',' + linkArr[27].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ConnBackwardReProcess)).AsInteger) + '''';
       SqlHost := SqlHost + ',' + linkArr[28].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_SaveAtLeastOnesAsFinnal)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[29].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_MachSetupCode)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[30].fldAS + '= ''' + FloatToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NettedQuantity)).AsFloat) + '''';
       SqlHost := SqlHost + ',' + linkArr[31].fldAS + '= ''' + FloatToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ChangedQuantity)).AsFloat) + '''';
       SqlHost := SqlHost + ',' + linkArr[32].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_usrCr)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[33].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_usrTmCr)).AsFloat)) + '''';
       SqlHost := SqlHost + ',' + linkArr[34].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_usrCg)).AsString + '''';
       SqlHost := SqlHost + ',' + linkArr[35].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_usrTmCg)).AsFloat)) + '''';

       if found_NEW_PREQ_UNIQ_ID then
       begin
         SqlHost := SqlHost + ',' + linkArr[36].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_NewPreqUniqId)).AsString + '''';
       end;

       if found_ActualDateTime then
       begin
         SqlHost := SqlHost + ',' + linkArr[37].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ActualStart)).AsFloat)) + '''';
         SqlHost := SqlHost + ',' + linkArr[38].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_ActualEnd)).AsFloat)) + '''';
       end;

       SqlHost := SqlHost + ' where ' + linkArr[0].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_preqNo)).AsString + '''';
       SqlHost := SqlHost + ' And ' + linkArr[1].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_pstepId)).AsInteger) + '''';
       SqlHost := SqlHost + ' And ' + linkArr[2].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_psubstId)).AsInteger) + '''';
       SqlHost := SqlHost + ' And ' + linkArr[3].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_reprocNo)).AsInteger) + '''';
       QryUpdate.SQL.Text := SqlHost;

       try
         QryUpdate.ExecSQL;
       except
         ErrorSql := 'Problem Occured while updating : ' + 'Req : ' +
                     srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_preqNo)).AsString + ' Step : ' +
                     IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_pstepId)).AsInteger) + ' Sub Step ' +
                     IntToStr(srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_psubstId)).AsInteger);
         ErrorSql := ErrorSql + ' SQL ERROR : ' + QryUpdate.SQL.Text;
         Raise;
       end;

       Inc(IndexPS);
       srvQry.Next;
       continue;
     end;

     if ChangeType = '3' then
     begin
       QryDel.SQL.Clear;
       SqlHost := 'delete from ' + tbProdSched.ASname + ' where ';
       SqlHost := SqlHost + linkArr[0].fldAS + '= ''' + pRecPropSched(ListProdSched[IndexPS]).preqNo + '''';
       SqlHost := SqlHost + ' And ' + linkArr[1].fldAS + '= ''' + IntToStr(pRecPropSched(ListProdSched[IndexPS]).pstepId) + '''';
       SqlHost := SqlHost + ' And ' + linkArr[2].fldAS + '= ''' + IntToStr(pRecPropSched(ListProdSched[IndexPS]).psubstId) + '''';
       SqlHost := SqlHost + ' And ' + linkArr[3].fldAS + '= ''' + IntToStr(pRecPropSched(ListProdSched[IndexPS]).reprocNo) + '''';

       QryDel.SQL.Text := SqlHost;
       QryDel.ExecSQL;
       Inc(IndexPS);
       continue;
     end;

     Inc(IndexPS);
     srvQry.Next;
  end;

  for IndexPS := 0 to ListProdSched.Count - 1 do
     dispose(pRecPropSched(ListProdSched[IndexPS]));

  ListProdSched.free;

  QryDel.Free;
  QryUpdate.Free;
  QryInsert.Free;

end;

//----------------------------------------------------------------------------//

function SendMqmPs10FTableOld(tbl: table; ASLib, PCcondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  i, parm, field: integer;
  tbInfo: ^TTblInfo;
  tblName:        string;
  linkList:       TList;
  LinkCount: integer;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL, GeneralSQLHost : string;
begin
  tbInfo := @tblInfo[tbl];
  SetFldPfx(tbInfo.pfx);
  tblName := ASLib + tbInfo.ASname;
  DateTimeFormat := GetDateTimeFormat;

  // select the data from AS400
  with srvQry do
  begin
    UpdateOperation(_('PC query ') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
//    SQL.Add('select ');
    GeneralSQL := '';
    GeneralSQL := 'select ';
    for i := 0 to High(linkArr)-1 do
    //  SQL.Add(CreatePfxFld(linkArr[i].fldPC) + ',');
      GeneralSQL := GeneralSQL + CreateFld(tbInfo.pfx,linkArr[i].fldPC) + ',';

    GeneralSQL := GeneralSQL + CreatePfxFld(linkArr[High(linkArr)].fldPC) + ' from ' + tbInfo.GetTableName;
   // SQL.Add(CreatePfxFld(linkArr[High(linkArr)].fldPC) + ' from ' + tbInfo.GetTableName);
    if PCcondition <> '' then
     // SQL.Add(PCcondition);
      GeneralSQL := GeneralSQL + PCcondition;
    SQL.add(GeneralSQL);
    Open
  end;

  with HostQry do
  begin

    // clear the table on the server
    UpdateOperation(_('Clearing') + ' ' + tbInfo.ASname);
    SQL.Clear;
    GeneralSQLHost := '';
    GeneralSQLHost := 'delete from ' + tblName;
    SQL.Add(GeneralSQLHost);
    //SQL.Add('delete from ' + tblName);
    ExecSQL;
    Close;

    LinkCount := High(linkArr);
//for testing purpose    LinkCount := 15;

    // update the AS400
//    UpdateOperation(_('Sending to ') + tbInfo.ASname);
    UpdateOperation(_(' Replacing  ') + tbInfo.ASname  + _(' on Host ...') );
    SQL.Clear;
    GeneralSQLHost := '';
    GeneralSQLHost := 'insert into ' + tblName + ' (';
 //   SQL.Add('insert into ' + tblName + ' (');
    for i := 0 to LinkCount-1 do
      //SQL.Add(linkArr[i].fldAS + ',');
      GeneralSQLHost := GeneralSQLHost + linkArr[i].fldAS + ',';
    GeneralSQLHost := GeneralSQLHost + linkArr[LinkCount].fldAS;
   // SQL.Add(linkArr[LinkCount].fldAS);
  //  SQL.Add(') values (');
    GeneralSQLHost := GeneralSQLHost + ') values (';
    for i := 0 to LinkCount-1 do
     // SQL.Add(':' + linkArr[i].fldAS + ',');
      GeneralSQLHost := GeneralSQLHost + ':' + linkArr[i].fldAS + ',';

    GeneralSQLHost := GeneralSQLHost + ':' + linkArr[LinkCount].fldAS + ')';
   // SQL.Add(':' + linkArr[LinkCount].fldAS + ')');
    SQL.Add(GeneralSQLHost);

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
                          if (DateTimeFormat = Frm_As400) then
                          begin
                            TParameter(linkList[parm]).DataType := ftFloat;
                            TParameter(linkList[parm]).value := DateTimeToTimDateTime(TField(linkList[field]).AsDateTime)
                          end
                          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTimeExceptControl) then
                          begin
                            TParameter(linkList[parm]).DataType := ftDateTime;
                            TParameter(linkList[parm]).value := TField(linkList[field]).AsDateTime;
                          end;
                        end;
          TLD_dateTime :begin
                          if (DateTimeFormat = Frm_As400) then
                          begin
                            TParameter(linkList[parm]).DataType := ftFloat;
                            TParameter(linkList[parm]).value := DateTimeToTimDateTime(TField(linkList[field]).AsDateTime)
                          end
                          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTimeExceptControl) then
                          begin
                            TParameter(linkList[parm]).DataType := ftString;
                            TParameter(linkList[parm]).value := Datetimetostr(TField(linkList[field]).AsDateTime);                          end;
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

function formatStringToNum(value: String): String;
begin
  if (Length(value) = 0) or (value = '0') then
    Result := '0'
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

function ConvertDateFormatTo(dateToConvert: TDateTime; DateTimeFormat : TDateTimeFormat): String;
var
  year: Word;
  month: Word;
  day: Word;
  hour: Word;
  minute: Word;
  second: Word;
  milisecond: Word;
begin
  DecodeDate(dateToConvert, year, month, day);
  DecodeTime(dateToConvert, hour, minute, second, milisecond);

  if (DateTimeFormat = Frm_TDateTime) then
    Result := QuotedStr( IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year) + ' ' +
                        formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                        formatForTwoDigits(IntToStr(second)) + '.' + IntToStr(milisecond))
  else if (DateTimeFormat = Frm_Db2) then

    Result := QuotedStr(IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day) + ' ' +
                        formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                        formatForTwoDigits(IntToStr(second)) + '.' + IntToStr(milisecond)); //' 00:00:00.0'
end;

//----------------------------------------------------------------------------//

function SendProd_SchedTable(tbl: table; ASLib, PCcondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery; var ErrorSql : string): boolean;
var
  i : integer;
  tbInfo: ^TTblInfo;
  tblName:        string;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL, GeneralSQLHost : string;

  // MCM
  MCMReadQry, MCMDeleteQry, MCMUpdateQry :   TMqmQuery;
  MCMReadtrs, MCMDeletetrs, MCMUpdatetrs :   TMqmTransaction;
  MCMReadtbInfo: ^TTblInfo;
  MCMWritetbInfo: ^TTblInfo;
  MqmProd_Step  : ^TTblInfo;
  MqmProd_ReqHdr : ^TTblInfo;
  Req        : string;
  Step       : string;
  RecPSValues : PRecPSValues;
  ListPsValues : TList;
//  TempStartDateTime, TempEndDateTime : TDateTime;
//  Year, Month, Day, Hour, Minute, Second, MilliSecond : word;
begin

  tbInfo := @tblInfo[tbl];

  tblName := tbInfo.GetTableName;
  DateTimeFormat := GetDateTimeFormat;

  with srvQry do
  begin
    UpdateOperation(_('PC query ') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    GeneralSQL := '';
    GeneralSQL := 'select ';
    for i := 0 to High(linkArr)-1 do
      GeneralSQL := GeneralSQL + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',';

    GeneralSQL := GeneralSQL + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + ' from ' + tbInfo.GetTableName;

//    if PCcondition <> '' then
//      GeneralSQL := GeneralSQL + PCcondition;
    SQL.add(GeneralSQL);
    Open
  end;

  with HostQry do
  begin
    // clear the table on the server
    UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    GeneralSQLHost := '';
    GeneralSQLHost := 'delete from ' + tblName;
    SQL.Add(GeneralSQLHost);
    ExecSQL;
    Close;

    UpdateOperation(_(' Replacing  ') + tbInfo.GetTableName  + _(' on Host ...') );
    SQL.Clear;

    while not srvQry.EOF do
    begin
      HostQry.SQL.Clear;

      HostQry.SQL.Text := 'INSERT INTO "PROD_SCHED" ("PS_PREQ_NO", "PS_PSTEP_ID", ' +
                        '"PS_PSUBST_ID", "PS_REPROC_NO", ' +
                        '"PS_TYPE_PROD", "PS_PROD_LINE", "PS_PROD_UM", ' +
                        '"PS_STEP_TYP", "PS_ST_GROUP", ' +
                        '"PS_STEP_IS_GRPED", "PS_SCHED_TYPE", "PS_WKCNTER", ' +
                        '"PS_WKCT_PROC", "PS_ALTERNATIVE_CODE", "PS_RSC_CODE", ' +
                        '"PS_PROD_SUBLIN_RSC", "PS_NUM_RSC_COMPONENTS", "PS_QTY", ' +
                        '"PS_SUP_BASE", "PS_SUP_REAL", "PS_SUP_OVERLAP", "PS_EXE_MIN", ' +
                        '"PS_SCH_START", "PS_SCH_END", "PS_COMMENT", "PS_FWD_SUBSTEP", ' +
                        '"PS_FWD_REPROC_SUBSTEP","PS_BKW_SUBSTEP", "PS_BKW_REPROC_SUBSTEP", ' +
                        '"PS_SAVES_AT_LEAST_ONES_FINNAL", "PS_NETTED_QUANTITY", ' +
                        '"PS_CHANGED_QUANTITY", "PS_MACHINE_SETUP_CODE", "PS_USR_NAMECR", ' +
                        '"PS_USR_TIMECR", "PS_USR_NAMECG", "PS_USR_TIMECG", "PS_NEW_PREQ_UNIQ_ID", "PS_SPLITED_FAMILY" ' +
                        ') VALUES (' +
                        QuotedStr(srvQry.FieldByName('PS_PREQ_NO').AsString) + ', ' +
                        srvQry.FieldByName('PS_PSTEP_ID').AsString + ', ' +
                        srvQry.FieldByName('PS_PSUBST_ID').AsString + ', ' +
                        srvQry.FieldByName('PS_REPROC_NO').AsString + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_TYPE_PROD').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_PROD_LINE').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_PROD_UM').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_STEP_TYP').AsString) + ', ' +
                        srvQry.FieldByName('PS_ST_GROUP').AsString + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_STEP_IS_GRPED').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_SCHED_TYPE').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_WKCNTER').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_WKCT_PROC').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_ALTERNATIVE_CODE').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_RSC_CODE').AsString) + ', ' +
                        srvQry.FieldByName('PS_PROD_SUBLIN_RSC').AsString + ', ' +
                        srvQry.FieldByName('PS_NUM_RSC_COMPONENTS').AsString + ', ' +
                        srvQry.FieldByName('PS_QTY').AsString + ', ' +
                        srvQry.FieldByName('PS_SUP_BASE').AsString + ', ' +
                        srvQry.FieldByName('PS_SUP_REAL').AsString + ', ' +
                        srvQry.FieldByName('PS_SUP_OVERLAP').AsString + ', ' +
                        srvQry.FieldByName('PS_EXE_MIN').AsString + ', ' +
                        ConvertDateFormatTo(srvQry.FieldByName('PS_ACTUAL_START').AsDateTime, DateTimeFormat) + ', ' +
                        ConvertDateFormatTo(srvQry.FieldByName('PS_ACTUAL_END').AsDateTime, DateTimeFormat) + ', ' +
                //        ConvertDateFormatTo(srvQry.FieldByName('PS_SCH_START').AsDateTime, DateTimeFormat) + ', ' +
                //        ConvertDateFormatTo(srvQry.FieldByName('PS_SCH_END').AsDateTime, DateTimeFormat) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_COMMENT').AsString) + ', ' +
                        srvQry.FieldByName('PS_FWD_SUBSTEP').AsString + ', ' +
                        srvQry.FieldByName('PS_FWD_REPROC_SUBSTEP').AsString + ', ' +
                        srvQry.FieldByName('PS_BKW_SUBSTEP').AsString + ', ' +
                        srvQry.FieldByName('PS_BKW_REPROC_SUBSTEP').AsString + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_SAVES_AT_LEAST_ONES_FINNAL').AsString) + ', ' +
                        formatStringToNum(srvQry.FieldByName('PS_NETTED_QUANTITY').AsString) + ', ' +
                        srvQry.FieldByName('PS_CHANGED_QUANTITY').AsString + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_MACHINE_SETUP_CODE').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_USR_NAMECR').AsString) + ', ' +
                        ConvertDateFormatTo(srvQry.FieldByName('PS_USR_TIMECR').AsDateTime, DateTimeFormat) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_USR_NAMECG').AsString) + ', ' +
                        ConvertDateFormatTo(srvQry.FieldByName('PS_USR_TIMECG').AsDateTime, DateTimeFormat) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_NEW_PREQ_UNIQ_ID').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('PS_SPLITED_FAMILY').AsString) + ')';

      try
      HostQry.ExecSql;
       except
         ErrorSql := 'Problem Occured while Inserting : ' + 'Req : ' +
                     srvQry.FieldByName('PS_PREQ_NO').AsString + ' Step : ' +
                     IntToStr(srvQry.FieldByName('PS_PSTEP_ID').AsInteger) + ' Sub Step ' +
                     IntToStr(srvQry.FieldByName('PS_PSUBST_ID').AsInteger);
         ErrorSql := ErrorSql + ' SQL ERROR : ' + HostQry.SQL.Text;
         Raise;
       end;
      srvQry.Next
    end;
    HostQry.Close;

  end;

  UpdateOperation(_('saved ') + tbInfo.GetTableName);
  Result := true
end;

//----------------------------------------------------------------------------//

function SendProd_Sched_Mcm_Table(tbl: table; ASLib, PCcondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery; var ErrorSql : string): boolean;
var
  i : integer;
  tbInfo: ^TTblInfo;
  tblName:        string;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL, GeneralSQLHost : string;

  // MCM
  MCMReadQry, MCMDeleteQry, MCMUpdateQry :   TMqmQuery;
  MCMReadtrs, MCMDeletetrs, MCMUpdatetrs :   TMqmTransaction;
  MCMReadtbInfo: ^TTblInfo;
  MCMWritetbInfo: ^TTblInfo;
  MqmProd_Step  : ^TTblInfo;
  MqmProd_ReqHdr : ^TTblInfo;
  Req        : string;
  Step       : string;
  RecPSValues : PRecPSValues;
  ListPsValues : TList;
begin

  tbInfo := @tblInfo[tbl];

  tblName := tbInfo.GetTableName;
  DateTimeFormat := GetDateTimeFormat;

  with srvQry do
  begin
    UpdateOperation(_('PC query ') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    GeneralSQL := '';
    GeneralSQL := 'select ';
    for i := 0 to High(linkArr)-1 do
      GeneralSQL := GeneralSQL + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',';

    GeneralSQL := GeneralSQL + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + ' from ' + tbInfo.GetTableName;

//    if PCcondition <> '' then
//      GeneralSQL := GeneralSQL + PCcondition;
    SQL.add(GeneralSQL);
    Open
  end;

  with HostQry do
  begin
    // clear the table on the server
    UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    GeneralSQLHost := '';
    GeneralSQLHost := 'delete from ' + tblName;
    SQL.Add(GeneralSQLHost);
    ExecSQL;
    Close;

    UpdateOperation(_(' Replacing  ') + tbInfo.GetTableName  + _(' on Host ...') );
    SQL.Clear;

    while not srvQry.EOF do
    begin
      HostQry.SQL.Clear;

      HostQry.SQL.Text := 'INSERT INTO "PROD_SCHED_MCM" ("MS_PREQ_NO", "MS_PSTEP_ID", ' +
                        '"MS_PSUBST_ID", "MS_REPROC_NO", ' +
                        '"MS_TYPE_PROD", "MS_PROD_LINE", "MS_PROD_UM", ' +
                        '"MS_STEP_TYP", "MS_ST_GROUP", ' +
                        '"MS_STEP_IS_GRPED", "MS_SCHED_TYPE", "MS_WKCNTER", ' +
                        '"MS_WKCT_PROC", "MS_ALTERNATIVE_CODE",'+  //"MS_RSC_CODE", ' +
                        '"MS_PROD_SUBLIN_RSC", "MS_NUM_RSC_COMPONENTS", "MS_QTY", ' +
                        '"MS_SUP_BASE", "MS_SUP_REAL", "MS_SUP_OVERLAP", "MS_EXE_MIN", ' +
                        '"MS_SCH_START", "MS_SCH_END", "MS_COMMENT", "MS_FWD_SUBSTEP", ' +
                        '"MS_FWD_REPROC_SUBSTEP","MS_BKW_SUBSTEP", "MS_BKW_REPROC_SUBSTEP", ' +
                        '"MS_SAVES_AT_LEAST_ONES_FINNAL", "MS_NETTED_QUANTITY", ' +
                        '"MS_CHANGED_QUANTITY", "MS_MACHINE_SETUP_CODE", "MS_USR_NAMECR", ' +
                        '"MS_USR_TIMECR", "MS_USR_NAMECG", "MS_USR_TIMECG", "MS_NEW_PREQ_UNIQ_ID", "MS_SPLITED_FAMILY" ' +
                        ') VALUES (' +
                        QuotedStr(srvQry.FieldByName('MS_PREQ_NO').AsString) + ', ' +
                        srvQry.FieldByName('MS_PSTEP_ID').AsString + ', ' +
                        srvQry.FieldByName('MS_PSUBST_ID').AsString + ', ' +
                        srvQry.FieldByName('MS_REPROC_NO').AsString + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_TYPE_PROD').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_PROD_LINE').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_PROD_UM').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_STEP_TYP').AsString) + ', ' +
                        srvQry.FieldByName('MS_ST_GROUP').AsString + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_STEP_IS_GRPED').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_SCHED_TYPE').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_WKCNTER').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_WKCT_PROC').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_ALTERNATIVE_CODE').AsString) + ', ' +
                      //  QuotedStr(srvQry.FieldByName('MS_RSC_CODE').AsString) + ', ' +
                        srvQry.FieldByName('MS_PROD_SUBLIN_RSC').AsString + ', ' +
                        srvQry.FieldByName('MS_NUM_RSC_COMPONENTS').AsString + ', ' +
                        srvQry.FieldByName('MS_QTY').AsString + ', ' +
                        srvQry.FieldByName('MS_SUP_BASE').AsString + ', ' +
                        srvQry.FieldByName('MS_SUP_REAL').AsString + ', ' +
                        srvQry.FieldByName('MS_SUP_OVERLAP').AsString + ', ' +
                        srvQry.FieldByName('MS_EXE_MIN').AsString + ', ' +
                        ConvertDateFormatTo(srvQry.FieldByName('MS_ACTUAL_START').AsDateTime, DateTimeFormat) + ', ' +
                        ConvertDateFormatTo(srvQry.FieldByName('MS_ACTUAL_END').AsDateTime, DateTimeFormat) + ', ' +
                //        ConvertDateFormatTo(srvQry.FieldByName('PS_SCH_START').AsDateTime, DateTimeFormat) + ', ' +
                //        ConvertDateFormatTo(srvQry.FieldByName('PS_SCH_END').AsDateTime, DateTimeFormat) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_COMMENT').AsString) + ', ' +
                        srvQry.FieldByName('MS_FWD_SUBSTEP').AsString + ', ' +
                        srvQry.FieldByName('MS_FWD_REPROC_SUBSTEP').AsString + ', ' +
                        srvQry.FieldByName('MS_BKW_SUBSTEP').AsString + ', ' +
                        srvQry.FieldByName('MS_BKW_REPROC_SUBSTEP').AsString + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_SAVES_AT_LEAST_ONES_FINNAL').AsString) + ', ' +
                        formatStringToNum(srvQry.FieldByName('MS_NETTED_QUANTITY').AsString) + ', ' +
                        srvQry.FieldByName('MS_CHANGED_QUANTITY').AsString + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_MACHINE_SETUP_CODE').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_USR_NAMECR').AsString) + ', ' +
                        ConvertDateFormatTo(srvQry.FieldByName('MS_USR_TIMECR').AsDateTime, DateTimeFormat) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_USR_NAMECG').AsString) + ', ' +
                        ConvertDateFormatTo(srvQry.FieldByName('MS_USR_TIMECG').AsDateTime, DateTimeFormat) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_NEW_PREQ_UNIQ_ID').AsString) + ', ' +
                        QuotedStr(srvQry.FieldByName('MS_SPLITED_FAMILY').AsString) + ')';

      try
      HostQry.ExecSql;
       except
         ErrorSql := 'Problem Occured while Inserting : ' + 'Req : ' +
                     srvQry.FieldByName('MS_PREQ_NO').AsString + ' Step : ' +
                     IntToStr(srvQry.FieldByName('MS_PSTEP_ID').AsInteger) + ' Sub Step ' +
                     IntToStr(srvQry.FieldByName('MS_PSUBST_ID').AsInteger);
         ErrorSql := ErrorSql + ' SQL ERROR : ' + HostQry.SQL.Text;
         Raise;
       end;
      srvQry.Next
    end;
    HostQry.Close;

  end;

  UpdateOperation(_('saved ') + tbInfo.GetTableName);
  Result := true
end;

//----------------------------------------------------------------------------//

function SaveprodSched(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..40] of TQryLinkRec = (
    (fldPC: fli_preqNo;                   fldAS: 'TPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;                  fldAS: 'TPRSTP'; fldType: TLD_integer),
    (fldPC: fli_psubstId;                 fldAS: 'TPRSST'; fldType: TLD_integer),
    (fldPC: fli_reprocNo;                 fldAS: 'TRPRNB'; fldType: TLD_integer),
    (fldPC: fli_ProdType;                 fldAS: 'TRECTY'; fldType: TLD_string),
    (fldPC: fli_ProdLine;                 fldAS: 'TPRDLN'; fldType: TLD_string),
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
    (fldPC: fli_Comment;                  fldAS: 'TCOMMN'; fldType: TLD_string),
    (fldPC: fli_ConnForwardSubStep;       fldAS: 'TFWSST'; fldType: TLD_integer),
    (fldPC: fli_ConnForwardReProcess;     fldAS: 'TFWRNB'; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardSubStep;      fldAS: 'TBCSST'; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardReProcess;    fldAS: 'TBCRNB'; fldType: TLD_integer),
    (fldPC: fli_SaveAtLeastOnesAsFinnal;  fldAS: 'TSVFIN'; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;            fldAS: 'TSETCD'; fldType: TLD_string),
    (fldPC: fli_NettedQuantity;           fldAS: 'TNETQT'; fldType: TLD_float),
    (fldPC: fli_ChangedQuantity;          fldAS: 'TCHGQT'; fldType: TLD_float),
    (fldPC: fli_usrCr;                    fldAS: 'TUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;                  fldAS: 'TDTOCR'; fldType: TLD_DateTime),
    (fldPC: fli_usrCg;                    fldAS: 'TUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'TDTOCH'; fldType: TLD_DateTime),
    (fldPC: fli_NewPreqUniqId;            fldAS: 'TMQMNR'; fldType: TLD_string),
    (fldPC: fli_ActualStart;              fldAS: '';       fldType: TLD_DateTime),
    (fldPC: fli_ActualEnd;                fldAS: '';       fldType: TLD_DateTime),
    (fldPC: fli_SplitFamaly;              fldAS: ''; fldType: TLD_string)
  );

  fldList10F: array [0..38] of TQryLinkRec = (
    (fldPC: fli_preqNo;                   fldAS: 'TPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;                  fldAS: 'TPRSTP'; fldType: TLD_integer),
    (fldPC: fli_psubstId;                 fldAS: 'TPRSST'; fldType: TLD_integer),
    (fldPC: fli_reprocNo;                 fldAS: 'TRPRNB'; fldType: TLD_integer),
    (fldPC: fli_ProdType;                 fldAS: 'TRECTY'; fldType: TLD_string),
    (fldPC: fli_ProdLine;                 fldAS: 'TPRDLN'; fldType: TLD_string),
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
    (fldPC: fli_exeMin;                   fldAS: 'TEXCTM'; fldType: TLD_float),
    (fldPC: fli_schedStart;               fldAS: 'TSTSDT'; fldType: TLD_DateTime),
    (fldPC: fli_schedEnd;                 fldAS: 'TENSDT'; fldType: TLD_DateTime),
    (fldPC: fli_Comment;                  fldAS: 'TCOMMN'; fldType: TLD_string),
    (fldPC: fli_ConnForwardSubStep;       fldAS: 'TFWSST'; fldType: TLD_integer),
    (fldPC: fli_ConnForwardReProcess;     fldAS: 'TFWRNB'; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardSubStep;      fldAS: 'TBCSST'; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardReProcess;    fldAS: 'TBCRNB'; fldType: TLD_integer),
    (fldPC: fli_SaveAtLeastOnesAsFinnal;  fldAS: 'TSVFIN'; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;            fldAS: 'TSETCD'; fldType: TLD_string),
    (fldPC: fli_NettedQuantity;           fldAS: 'TNETQT'; fldType: TLD_float),
    (fldPC: fli_ChangedQuantity;          fldAS: 'TCHGQT'; fldType: TLD_float),
    (fldPC: fli_usrCr;                    fldAS: 'TUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;                  fldAS: 'TDTOCR'; fldType: TLD_DateTime),
    (fldPC: fli_usrCg;                    fldAS: 'TUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'TDTOCH'; fldType: TLD_DateTime),
    (fldPC: fli_NewPreqUniqId;            fldAS: 'TMQMNR'; fldType: TLD_string),
    (fldPC: fli_ActualStart;              fldAS: 'TSTADT'; fldType: TLD_DateTime),
    (fldPC: fli_ActualEnd;                fldAS: 'TENADT'; fldType: TLD_DateTime)
  );

var
  sl: TStringList;
  tbInfo: ^TTblInfo;
  DndArchiveHostName : TDndArchiveName;
  ErrorSql : string;
  UpdatedfldList10F : array of TQryLinkRec;
  SqlHost : string;
  found_NEW_PREQ_UNIQ_ID : boolean;
  found_ActualDateTime : boolean;
  I : Integer;
begin
  tbInfo := @tblInfo[tbl];
  found_NEW_PREQ_UNIQ_ID := true;
  found_ActualDateTime   := true;

  DndArchiveHostName := GetDndArchiveHostName;
  Assert(tbl = tbl_prod_sched);

//  try
  if (DndArchiveHostName = TD_AS_400) then
  begin

    SqlHost := 'select ' + fldList10F[36].fldAS + ' from ' + tbInfo.ASname;
    HostQry.Sql.Clear;
    HostQry.Sql.Text := SqlHost;
    try
      HostQry.Open;
    except
      found_NEW_PREQ_UNIQ_ID := false;
    end;

    SqlHost := 'select ' + fldList10F[37].fldAS + ' from ' + tbInfo.ASname;
    HostQry.Sql.Clear;
    HostQry.Sql.Text := SqlHost;
    try
      HostQry.Open;
    except
      found_ActualDateTime := false;
    end;

    if found_NEW_PREQ_UNIQ_ID and found_ActualDateTime then
    begin
      SetLength(UpdatedfldList10F, (High(fldList10F) + 1));
      for I := Low(UpdatedfldList10F) to High(UpdatedfldList10F) do
        UpdatedfldList10F[I] := fldList10F[I];
    end
    else if found_NEW_PREQ_UNIQ_ID then
    begin
      SetLength(UpdatedfldList10F, (High(fldList10F) - 1));
      for I := Low(UpdatedfldList10F) to High(UpdatedfldList10F) do
        UpdatedfldList10F[I] := fldList10F[I];
    end
    else
    begin
      SetLength(UpdatedfldList10F, (High(fldList10F) - 2));
      for I := Low(UpdatedfldList10F) to High(UpdatedfldList10F) do
        UpdatedfldList10F[I] := fldList10F[I];
    end;

    Result := SendMqmPs10FTable(tbl, AS400Speclib, ' where ' + CreateFld(tbInfo.pfx, fli_schedType) + ' <> ''0''', UpdatedfldList10F, srvQry, HostQry, found_NEW_PREQ_UNIQ_ID, found_ActualDateTime, ErrorSql)
  end;
{    else
    begin
      Result := true;
      if DBAppGlobals.License_MQM then
      begin
        Result := SendProd_SchedTable(tbl, AS400Speclib, ' where ' + CreateFld(tbInfo.pfx, fli_schedType) + ' <> ''0''', fldList, srvQry, HostQry, ErrorSql)
      end;
    end;  }
{  except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add(_('Sending') + ' PROD_SCHED');
        E.Message := E.Message + ErrorSql;
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        UpdateStatuseBtn(false, true);
        Raise;
      end
  end }
end;

//----------------------------------------------------------------------------//

function SaveProdSchedMcm(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..40] of TQryLinkRec = (
    (fldPC: fli_preqNo;                   fldAS: ''; fldType: TLD_string),
    (fldPC: fli_pstepId;                  fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_psubstId;                 fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_reprocNo;                 fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_ProdType;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ProdLine;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ProdUMCode;               fldAS: ''; fldType: TLD_string),
    (fldPC: fli_StepType;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_stGroup;                  fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_StepIsGrouped;            fldAS: ''; fldType: TLD_string),
    (fldPC: fli_schedType;                fldAS: ''; fldType: TLD_string),
    (fldPC: fli_wkCtrCode;                fldAS: ''; fldType: TLD_string),
    (fldPC: fli_wkcProc;                  fldAS: ''; fldType: TLD_string),
    (fldPC: fli_AlternativCode;           fldAS: ''; fldType: TLD_string),
    (fldPC: fli_rsc;                      fldAS: ''; fldType: TLD_string),
    (fldPC: fli_subLinRscId;              fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_NumSubRscComponents;      fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_quant;                    fldAS: ''; fldType: TLD_float),
    (fldPC: fli_supMinReal;               fldAS: ''; fldType: TLD_float),
    (fldPC: fli_supMinBase;               fldAS: ''; fldType: TLD_float),
    (fldPC: fli_supMinOvlp;               fldAS: ''; fldType: TLD_float),
    (fldPC: fli_exeMin;                   fldAS: ''; fldType: TLD_float),
    (fldPC: fli_schedStart;               fldAS: ''; fldType: TLD_DateTime),
    (fldPC: fli_schedEnd;                 fldAS: ''; fldType: TLD_DateTime),
    (fldPC: fli_Comment;                  fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ConnForwardSubStep;       fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_ConnForwardReProcess;     fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardSubStep;      fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardReProcess;    fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_SaveAtLeastOnesAsFinnal;  fldAS: ''; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;            fldAS: ''; fldType: TLD_string),
    (fldPC: fli_NettedQuantity;           fldAS: ''; fldType: TLD_float),
    (fldPC: fli_ChangedQuantity;          fldAS: ''; fldType: TLD_float),
    (fldPC: fli_usrCr;                    fldAS: ''; fldType: TLD_string),
    (fldPC: fli_usrTmCr;                  fldAS: ''; fldType: TLD_DateTime),
    (fldPC: fli_usrCg;                    fldAS: ''; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: ''; fldType: TLD_DateTime),
    (fldPC: fli_NewPreqUniqId;            fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ActualStart;              fldAS: ''; fldType: TLD_DateTime),
    (fldPC: fli_ActualEnd;                fldAS: ''; fldType: TLD_DateTime),
    (fldPC: fli_SplitFamaly;              fldAS: ''; fldType: TLD_string)
  );

var
  sl : TStringList;
  ErrorSql : string;
  tbInfo: ^TTblInfo;
begin
  if DBAppGlobals.License_MCM then
  begin
    Result := SendProd_Sched_Mcm_Table(tbl, AS400Speclib, ' where ' + CreateFld(tbInfo.pfx, fli_schedType) + ' <> ''0''', fldList, srvQry, HostQry, ErrorSql)
  end;
end;

//----------------------------------------------------------------------------//

function SendRes(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..12] of TQryLinkRec = (
    (fldPC: fli_rsc;              fldAS: 'TCDRSC'; fldType: TLD_string),
    (fldPC: fli_SDescr;           fldAS: 'TDESCR'; fldType: TLD_string),
    (fldPC: fli_LDescr;           fldAS: 'TSUPDS'; fldType: TLD_string),
    (fldPC: fli_ProcesType;       fldAS: 'TBCFLG'; fldType: TLD_string),
    (fldPC: fli_wkCtrCode;        fldAS: 'TCDMAC'; fldType: TLD_string),
    (fldPC: fli_rscCat;           fldAS: 'TCATRS'; fldType: TLD_string),
    (fldPC: fli_Standrd_bch_Size; fldAS: 'TBATSZ'; fldType: TLD_float),
    (fldPC: fli_BchUM;            fldAS: 'TUMBAT'; fldType: TLD_string),
    (fldPC: fli_CalCod;           fldAS: 'TCDCAL'; fldType: TLD_string),
    (fldPC: fli_rscType;          fldAS: 'TFVPMQ'; fldType: TLD_string),
    (fldPC: fli_NumOfRsc;         fldAS: 'TNRRSC'; fldType: TLD_float),
    (fldPC: fli_Min_bch_size;     fldAS: 'TMINBZ'; fldType: TLD_float),
    (fldPC: fli_Max_bch_size;     fldAS: 'TMAXBZ'; fldType: TLD_float)
  );
var
  sl: TStringList;
  tbInfo: ^TTblInfo;
  HostTableName : string;
begin
  tbInfo := @tblInfo[tbl];
  SetFldPfx(tbInfo.pfx);
  Result := true;
  if not GetHostTableName(tbInfo.GetTableName,HostTableName) then
    exit
  else
    tbInfo.ASname := HostTableName;
  try
    Assert(tbl = tbl_res);
    Result := SendArchiveTable(tbl, AS400Speclib, '', fldList, srvQry, HostQry)
  except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add(_('Sending') + ' ' +  tbInfo.ASname);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        Result := false
      end
  end
end;

//----------------------------------------------------------------------------//

function SendSubRes(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..9] of TQryLinkRec = (
    (fldPC: fli_rsc;                 fldAS: 'RCDRSC'; fldType: TLD_string),
    (fldPC: fli_SubRsc;              fldAS: 'RRSCSL'; fldType: TLD_integer),
    (fldPC: fli_CalCod;              fldAS: 'RCDCAL'; fldType: TLD_string),
    (fldPC: fli_ProdLine;            fldAS: 'RPRDLN'; fldType: TLD_string),
    (fldPC: fli_Comment;             fldAS: 'RCOMME'; fldType: TLD_string),
    (fldPC: fli_NumSubRscComponents; fldAS: 'RNRRSC'; fldType: TLD_integer),
    (fldPC: fli_usrCr;               fldAS: 'RUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;             fldAS: 'RDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;               fldAS: 'RUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;             fldAS: 'RDTOCH'; fldType: TLD_dateTime)
  );
var
  sl: TStringList;
  tbInfo: ^TTblInfo;
  HostTableName : string;
begin
  tbInfo := @tblInfo[tbl];
  SetFldPfx(tbInfo.pfx);
  Result := true;
  if not GetHostTableName(tbInfo.GetTableName,HostTableName) then
    exit
  else
    tbInfo.ASname := HostTableName;
  try
    Assert(tbl = tbl_res_sub);
    Result := SendArchiveTable(tbl, AS400Speclib, '', fldList, srvQry, HostQry)
  except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add(_('Sending') + ' ' +  tbInfo.ASname);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        Result := false
      end
  end
end;

//----------------------------------------------------------------------------//

function SendProp_Res(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..15] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;                        fldAS: 'DCDMAC'; fldType: TLD_string),
    (fldPC: fli_rscCat;                           fldAS: 'DCATRS'; fldType: TLD_string),
    (fldPC: fli_WCProcess;                        fldAS: 'DCDMAP'; fldType: TLD_string),
    (fldPC: fli_Rsc;                              fldAS: 'DCDRSC'; fldType: TLD_string),
    (fldPC: fli_PropertyCode;                     fldAS: 'DCDPPT'; fldType: TLD_string),
    (fldPC: fli_PropBaseValue;                    fldAS: 'DVALUE'; fldType: TLD_string),
    (fldPC: fli_PropAddRscOfOcc;                  fldAS: 'DADRSC'; fldType: TLD_string),
    (fldPC: fli_PropAddValToAddiRsc;              fldAS: 'DVLRSC'; fldType: TLD_float),
    (fldPC: fli_PropValTakeForGroup;              fldAS: 'DVLGRP'; fldType: TLD_string),
    (fldPC: fli_PropDftCaseRsc_Occ_Ruls;          fldAS: 'DDFCRO'; fldType: TLD_string),
    (fldPC: fli_PropDftCaseOcc_Occ_Ruls;          fldAS: 'DDFCOO'; fldType: TLD_string),
    (fldPC: fli_PropDftSameGroupForOcc_Occ_Ruls;  fldAS: 'DDSGOO'; fldType: TLD_string),
    (fldPC: fli_usrCr;                            fldAS: 'DUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;                          fldAS: 'DDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;                            fldAS: 'DUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                          fldAS: 'DDTOCH'; fldType: TLD_dateTime)
  );
var
  sl: TStringList;
  tbInfo: ^TTblInfo;
  HostTableName : string;
begin
  tbInfo := @tblInfo[tbl];
  SetFldPfx(tbInfo.pfx);
  Result := true;
  if not GetHostTableName(tbInfo.GetTableName,HostTableName) then
    exit
  else
    tbInfo.ASname := HostTableName;
  try
    Assert(tbl = tbl_prop_res);
    Result := SendArchiveTable(tbl, AS400Speclib, '', fldList, srvQry, HostQry)
  except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add(_('Sending') + ' ' +  tbInfo.ASname);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        Result := false
      end
  end
end;

//----------------------------------------------------------------------------//

function SendWkst_Wkc(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..6] of TQryLinkRec = (
    (fldPC: fli_wkstCode;  fldAS: 'BWRKST'; fldType: TLD_string),
    (fldPC: fli_wkCtrCode; fldAS: 'BCDMAC'; fldType: TLD_string),
    (fldPC: fli_TypeOfUse; fldAS: 'BUSETP'; fldType: TLD_string),
    (fldPC: fli_usrCr;     fldAS: 'BUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;   fldAS: 'BDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;     fldAS: 'BUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;   fldAS: 'BDTOCH'; fldType: TLD_dateTime)
  );
var
  sl: TStringList;
  tbInfo: ^TTblInfo;
  HostTableName : string;
begin
  tbInfo := @tblInfo[tbl];
  SetFldPfx(tbInfo.pfx);
  Result := true;
  if not GetHostTableName(tbInfo.GetTableName,HostTableName) then
    exit
  else
    tbInfo.ASname := HostTableName;
  try
    Assert(tbl = tbl_wkst_wkc);
    Result := SendArchiveTable(tbl, AS400Speclib, '', fldList, srvQry, HostQry)
  except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add(_('Sending') + ' ' +  tbInfo.ASname);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        Result := false
      end
  end
end;

//----------------------------------------------------------------------------//

function SortPlannerProp(Item1, Item2: Pointer) : integer;
var
  MQMPP1 : pRecPropPlanner;
  MQMPP2 : pRecPropPlanner;
begin
  MQMPP1 := pRecPropPlanner(Item1);
  MQMPP2 := pRecPropPlanner(Item2);
  if MQMPP1.preqNo < MQMPP2.preqNo then
     Result := -1
  else if (MQMPP1.preqNo = MQMPP2.preqNo) then
  begin
    if (MQMPP1.pstepId < MQMPP2.pstepId) then
       Result := -1
    else if (MQMPP1.pstepId = MQMPP2.pstepId) then
    begin
      if (MQMPP1.PropertyCode < MQMPP2.PropertyCode) then
        Result := -1
      else if (MQMPP1.PropertyCode = MQMPP2.PropertyCode) then
        Result := 0
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

function SendPlannerProperties(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..5] of TQryLinkRec = (
    (fldPC: fli_preqNo;        fldAS: 'EPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;       fldAS: 'EPRSTP'; fldType: TLD_integer),
    (fldPC: fli_PropertyCode;  fldAS: 'ECDPPT'; fldType: TLD_string),
    (fldPC: fli_PropValue;     fldAS: 'EPPTVL'; fldType: TLD_string),
    (fldPC: fli_usrCr;         fldAS: 'EUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;       fldAS: 'EDTOCH'; fldType: TLD_dateTime)
  );

  fldListNow: array [0..5] of TQryLinkRec = (
    (fldPC: fli_preqNo;        fldAS: 'PU_PREQ_NO'; fldType: TLD_string),
    (fldPC: fli_pstepId;       fldAS: 'PU_PSTEP_ID'; fldType: TLD_integer),
    (fldPC: fli_PropertyCode;  fldAS: 'PU_PROPERTY'; fldType: TLD_string),
    (fldPC: fli_PropValue;     fldAS: 'PU_VALUE'; fldType: TLD_string),
    (fldPC: fli_usrCr;         fldAS: 'PU_USR_NAMECG'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;       fldAS: 'PU_USR_TIMECG'; fldType: TLD_dateTime)
  );

var
  tbPropPlanner, tbProp : ^TTblInfo;
  HostTableName : string;
  RecProp : PRecPropPlanner;
  ListPropHost : TList;
  IndexPP : Integer;
  SqlHost, SqlSrv, ChangeType : string;
  QryDel, QryUpdate, QryInsert : TMqmQuery;
  DndArchiveHostName : TDndArchiveName;
begin
  DndArchiveHostName := GetDndArchiveHostName;
  tbPropPlanner := @tblInfo[tbl];
  tbProp := @tblInfo[tbl_prop];

  Result := true;
  if not GetHostTableName(tbPropPlanner.GetTableName,HostTableName) then
    exit
  else
    tbPropPlanner.ASname := HostTableName;

  srvQry.SQL.Clear;
  SqlSrv := ' select * from ' + tbProp.GetTableName;
  SqlSrv := SqlSrv + ' where ' + CreateFld(tbProp.pfx, fli_MQMRelevance) + ' = ''' + '3' + '''';
  srvQry.SQL.Text := SqlSrv;
  srvQry.open;
  if srvQry.Eof then Exit;

  srvQry.SQL.Clear;
  SqlSrv := 'Select * from ' + tbPropPlanner.GetTableName;
  SqlSrv := SqlSrv + ' Order by ' + CreateFld(tbPropPlanner.pfx, fli_preqNo);
  SqlSrv := SqlSrv + ', ' + CreateFld(tbPropPlanner.pfx, fli_pstepId);
  SqlSrv := SqlSrv + ', ' + CreateFld(tbPropPlanner.pfx, fli_PropertyCode);
  srvQry.sql.Text := SqlSrv;
  srvQry.open;

  UpdateOperation(_('Updating') + '  ' + tbPropPlanner.ASname + ' ' + (_('in host . . .')));
  HostQry.sql.Clear;

  if (DndArchiveHostName = TD_AS_400) then
  begin
    SqlHost := 'select * from ' + tbPropPlanner.ASname;
    SqlHost := SqlHost + ' Order by EPRREQ,EPRSTP,ECDPPT';
    HostQry.Sql.Text := SqlHost;
  end
  else
  begin
    SqlHost := 'select * from ' + tbPropPlanner.ASname;
    SqlHost := SqlHost + ' Order by PU_PREQ_NO,PU_PSTEP_ID,PU_PROPERTY';
    HostQry.Sql.Text := SqlHost;
  end;
  HostQry.Open;
  ListPropHost := TList.Create;
  QryDel    := ThreadCreateQueryHost;
  QryUpdate := ThreadCreateQueryHost;
  QryInsert := ThreadCreateQueryHost;

  if (DndArchiveHostName = TD_AS_400) then
    InsertHostQryTables(tbl,fldList,QryInsert)
  else
    InsertHostQryTables(tbl,fldListNow,QryInsert);

  while not HostQry.Eof do
  begin
    new(RecProp);
    if (DndArchiveHostName = TD_AS_400) then
    begin
      RecProp.preqNo          := Trim(HostQry.FieldByName(fldList[0].fldAS).AsString);
      RecProp.pstepId         := HostQry.FieldByName(fldList[1].fldAS).AsInteger;
      RecProp.PropertyCode    := Trim(HostQry.FieldByName(fldList[2].fldAS).AsString);
      RecProp.PropValue       := Trim(HostQry.FieldByName(fldList[3].fldAS).AsString);
    end
    else
    begin
      RecProp.preqNo          := Trim(HostQry.FieldByName(fldListNow[0].fldAS).AsString);
      RecProp.pstepId         := HostQry.FieldByName(fldListNow[1].fldAS).AsInteger;
      RecProp.PropertyCode    := Trim(HostQry.FieldByName(fldListNow[2].fldAS).AsString);
      RecProp.PropValue       := Trim(HostQry.FieldByName(fldListNow[3].fldAS).AsString);
    end;
    ListPropHost.Add(RecProp);
    HostQry.Next;
  end;

  ListPropHost.Sort(SortPlannerProp);
  IndexPP := 0;

  while true do
  begin

    if (IndexPP > ListPropHost.count - 1) and srvQry.Eof then break;

    while True do
    begin
      if (IndexPP > ListPropHost.count - 1) then
      begin
        ChangeType := '1';
        break;
      end;

      if srvQry.Eof then
      begin
        ChangeType := '3';
        break;
      end;

      if pRecPropPlanner(ListPropHost[IndexPP]).preqNo > Trim(srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_preqNo)).AsString) then
      begin
        ChangeType := '1';
        break;
      end;

      if pRecPropPlanner(ListPropHost[IndexPP]).preqNo < Trim(srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_preqNo)).AsString) then
      begin
        ChangeType := '3';
        break;
      end;

      if pRecPropPlanner(ListPropHost[IndexPP]).pstepId > srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_pstepId)).AsInteger then
      begin
        ChangeType := '1';
        break;
      end;

      if pRecPropPlanner(ListPropHost[IndexPP]).pstepId < srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_pstepId)).AsInteger then
      begin
        ChangeType := '3';
        break;
      end;

      if pRecPropPlanner(ListPropHost[IndexPP]).PropertyCode > srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropertyCode)).AsString then
      begin
        ChangeType := '1';
        break;
      end;

      if pRecPropPlanner(ListPropHost[IndexPP]).PropertyCode < srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropertyCode)).AsString then
      begin
        ChangeType := '3';
        break;
      end;

      if pRecPropPlanner(ListPropHost[IndexPP]).PropValue = srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropValue)).AsString then
      begin
        ChangeType := '0';
        break;
      end;

      ChangeType := '2';
      break;
    end;

     if ChangeType = '1' then
     begin
       if (DndArchiveHostName = TD_AS_400) then
       begin
         QryInsert.ParamByName(fldList[0].fldAS).DataType := ftString;
         QryInsert.ParamByName(fldList[0].fldAS).Value := srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_preqNo)).AsString;
         QryInsert.ParamByName(fldList[1].fldAS).DataType := ftInteger;
         QryInsert.ParamByName(fldList[1].fldAS).Value := srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_pstepId)).AsInteger;
         QryInsert.ParamByName(fldList[2].fldAS).DataType := ftString;
         QryInsert.ParamByName(fldList[2].fldAS).Value := srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropertyCode)).AsString;
         QryInsert.ParamByName(fldList[3].fldAS).DataType := ftString;
         QryInsert.ParamByName(fldList[3].fldAS).Value := srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropValue)).AsString;
         QryInsert.ParamByName(fldList[4].fldAS).DataType := ftString;
         QryInsert.ParamByName(fldList[4].fldAS).Value := srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_usrCr)).AsString;
         QryInsert.ParamByName(fldList[5].fldAS).DataType := ftFloat;
         QryInsert.ParamByName(fldList[5].fldAS).Value := DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_usrTmCr)).AsDateTime);
       end
       else
       begin
         QryInsert.ParamByName(fldListNow[0].fldAS).DataType := ftString;
         QryInsert.ParamByName(fldListNow[0].fldAS).Value := srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_preqNo)).AsString;
         QryInsert.ParamByName(fldListNow[1].fldAS).DataType := ftInteger;
         QryInsert.ParamByName(fldListNow[1].fldAS).Value := srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_pstepId)).AsInteger;
         QryInsert.ParamByName(fldListNow[2].fldAS).DataType := ftString;
         QryInsert.ParamByName(fldListNow[2].fldAS).Value := srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropertyCode)).AsString;
         QryInsert.ParamByName(fldListNow[3].fldAS).DataType := ftString;
         QryInsert.ParamByName(fldListNow[3].fldAS).Value := srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropValue)).AsString;
         QryInsert.ParamByName(fldListNow[4].fldAS).DataType := ftString;
         QryInsert.ParamByName(fldListNow[4].fldAS).Value := srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_usrCr)).AsString;
         QryInsert.ParamByName(fldListNow[5].fldAS).DataType := ftFloat;
         QryInsert.ParamByName(fldListNow[5].fldAS).Value := DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_usrTmCr)).AsDateTime);
       end;

       QryInsert.ExecSQL;
       srvQry.Next;
       continue;
     end;

     if ChangeType = '2' then
     begin
       QryUpdate.SQL.Clear;
       SqlHost := 'Update ' + tbPropPlanner.ASname + ' set ';
       if (DndArchiveHostName = TD_AS_400) then
       begin
         SqlHost := SqlHost +  fldList[3].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropValue)).AsString + '''';
         SqlHost := SqlHost + ',' + fldList[4].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_usrCr)).AsString + '''';
         SqlHost := SqlHost + ',' + fldList[5].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_usrTmCr)).AsDateTime)) + '''';
         SqlHost := SqlHost + ' where ' + fldList[0].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_preqNo)).AsString + '''';
         SqlHost := SqlHost + ' And ' + fldList[1].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_pstepId)).AsInteger) + '''';
         SqlHost := SqlHost + ' And ' + fldList[2].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropertyCode)).AsString + '''';
       end
       else
       begin
         SqlHost := SqlHost +  fldListNow[3].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropValue)).AsString + '''';
         SqlHost := SqlHost + ',' + fldListNow[4].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_usrCr)).AsString + '''';
         SqlHost := SqlHost + ',' + fldListNow[5].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_usrTmCr)).AsDateTime)) + '''';
         SqlHost := SqlHost + ' where ' + fldListNow[0].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_preqNo)).AsString + '''';
         SqlHost := SqlHost + ' And ' + fldListNow[1].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_pstepId)).AsInteger) + '''';
         SqlHost := SqlHost + ' And ' + fldListNow[2].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbPropPlanner.pfx, fli_PropertyCode)).AsString + '''';
       end;
       QryUpdate.SQL.Text := SqlHost;
       QryUpdate.ExecSQL;
       Inc(IndexPP);
       srvQry.Next;
       continue;
     end;

     if ChangeType = '3' then
     begin
       QryDel.SQL.Clear;
       SqlHost := 'delete from ' + tbPropPlanner.ASname + ' where ';
       if (DndArchiveHostName = TD_AS_400) then
       begin
         SqlHost := SqlHost + fldList[0].fldAS + '= ''' + pRecPropPlanner(ListPropHost[IndexPP]).preqNo + '''';
         SqlHost := SqlHost + ' And ' + fldList[1].fldAS + '= ''' + IntToStr(pRecPropPlanner(ListPropHost[IndexPP]).pstepId) + '''';
         SqlHost := SqlHost + ' And ' + fldList[2].fldAS + '= ''' + pRecPropPlanner(ListPropHost[IndexPP]).PropertyCode + '''';
       end
       else
       begin
         SqlHost := SqlHost + fldListNow[0].fldAS + '= ''' + pRecPropPlanner(ListPropHost[IndexPP]).preqNo + '''';
         SqlHost := SqlHost + ' And ' + fldListNow[1].fldAS + '= ''' + IntToStr(pRecPropPlanner(ListPropHost[IndexPP]).pstepId) + '''';
         SqlHost := SqlHost + ' And ' + fldListNow[2].fldAS + '= ''' + pRecPropPlanner(ListPropHost[IndexPP]).PropertyCode + '''';
       end;
       QryDel.SQL.Text := SqlHost;
       QryDel.ExecSQL;
       Inc(IndexPP);
       continue;
     end;

     Inc(IndexPP);
     srvQry.Next;
  end;

  for IndexPP := 0 to ListPropHost.Count - 1 do
     dispose(pRecPropPlanner(ListPropHost[IndexPP]));

  ListPropHost.free;

  QryDel.Free;
  QryUpdate.Free;
  QryInsert.Free;

end;

//----------------------------------------------------------------------------//

{function SendStockDetails(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  tbStockDetails : ^TTblInfo;
  HostTableName : string;
  SqlSrv, SqlHost : string;
begin
  tbStockDetails := @tblInfo[tbl];
  Result := true;
  if not GetHostTableName(tbStockDetails.GetTableName,HostTableName) then
    exit;

  SqlSrv := ' select * from ' + tbStockDetails.GetTableName + ' Order by ' + CreateFld(tbStockDetails.pfx, fli_BalanceIdentifier);
  srvQry.SQL.Text := SqlSrv;
  srvQry.open;
  if srvQry.Eof then Exit;

  UpdateOperation(_('Updating') + '  ' + tbStockDetails.GetTableName + ' ' + (_('in host . . .')));

  while not srvQry.Eof do
  begin
    SqlHost := 'update ' + HostTableName + ' set ' +
                CreateFld(tbStockDetails.pfx, fli_used) + '=''' + srvQry.FieldByName(CreateFld(tbStockDetails.pfx, fli_used)).AsString + '''' + ', ' +
                CreateFld(tbStockDetails.pfx, fli_preqNo) + '=''' + srvQry.FieldByName(CreateFld(tbStockDetails.pfx, fli_preqNo)).AsString + '''' +  ', ' +
                CreateFld(tbStockDetails.pfx, fli_pstepId) + '=''' + IntToStr(srvQry.FieldByName(CreateFld(tbStockDetails.pfx, fli_pstepId)).AsInteger) + '''' +  ', ' +
                CreateFld(tbStockDetails.pfx, fli_psubstId) + '=''' + IntToStr(srvQry.FieldByName(CreateFld(tbStockDetails.pfx, fli_psubstId)).AsInteger) + '''' +  ', ' +
                CreateFld(tbStockDetails.pfx, fli_reprocNo) + '=''' + IntToStr(srvQry.FieldByName(CreateFld(tbStockDetails.pfx, fli_reprocNo)).AsInteger) + '''' +
                ' where ' + CreateFld(tbStockDetails.pfx, fli_BalanceIdentifier) + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbStockDetails.pfx, fli_BalanceIdentifier)).AsInteger) + '''';
    HostQry.SQL.Text := SqlHost;
    HostQry.ExecSQL;
    srvQry.Next;
  end;
end;      }

//----------------------------------------------------------------------------//

function SendCapRes(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..12] of TQryLinkRec = (
    (fldPC: fli_CapacyResrv;     fldAS: 'UCAPNM'; fldType: TLD_integer),
    (fldPC: fli_rsc;             fldAS: 'UPRRSC'; fldType: TLD_string),
    (fldPC: fli_subLinRscId;     fldAS: 'URSCSL'; fldType: TLD_integer),
    (fldPC: fli_WCProcess;       fldAS: 'UCDMAP'; fldType: TLD_string),
    (fldPC: fli_CapacyResTyp;    fldAS: 'UCAPTP'; fldType: TLD_string),
    (fldPC: fli_Capacity_To_Job; fldAS: 'UCASEX'; fldType: TLD_string),
    (fldPC: fli_Comment;         fldAS: 'UCOMME'; fldType: TLD_string),
    (fldPC: fli_schedStart;      fldAS: 'USTSDT'; fldType: TLD_dateTime),
    (fldPC: fli_schedEnd;        fldAS: 'UENSDT'; fldType: TLD_dateTime),
    (fldPC: fli_usrCr;           fldAS: 'UUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;         fldAS: 'UDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;           fldAS: 'UUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;         fldAS: 'UDTOCH'; fldType: TLD_dateTime)
  );
var
  tbCapRes : ^TTblInfo;
  HostTableName : string;
  RecCapRes : pRecCapRes;
  ListCapResHost : TList;
  IndexCapRes : Integer;
  TempSchedStart, TempSchedEnd : TDateTime;
  Year, Month, Day, Hour, Minute, Second, MilliSecond : word;
  SqlHost, SqlSrv, ChangeType : string;
  QryDel, QryUpdate, QryInsert : TMqmQuery;
  SL : TStringList;
  CommentStr : string;
  I : Integer;
begin
  tbCapRes := @tblInfo[tbl];
  Result := true;
  if not GetHostTableName(tbCapRes.GetTableName,HostTableName) then
    exit
  else
    tbCapRes.ASname := HostTableName;

  srvQry.SQL.Clear;
  SqlSrv := ' select * from ' + tbCapRes.GetTableName;
  SqlSrv := SqlSrv + ' where ' + CreateFld(tbCapRes.pfx, fli_CapacyResTyp) +  ' = ''' + '2' + '''';
  SqlSrv := SqlSrv + ' and ' + CreateFld(tbCapRes.pfx, fli_CapacyResrvStatus) + ' is null OR ' + CreateFld(tbCapRes.pfx, fli_CapacyResrvStatus) +  ' <> ''' + '3' + '''';
  srvQry.SQL.Text := SqlSrv;
  srvQry.open;
  if srvQry.Eof then
  begin
    SqlHost := 'select * from ' + tbCapRes.ASname;
    SqlHost := SqlHost + ' Order by UCAPNM';
    HostQry.Sql.Text := SqlHost;
    HostQry.Open;
    if HostQry.Eof then
       Exit;
  end;

  srvQry.SQL.Clear;
  SqlSrv := 'Select * from ' + tbCapRes.GetTableName;
  SqlSrv := SqlSrv + ' where ' + CreateFld(tbCapRes.pfx, fli_CapacyResTyp) +  ' = ''' + '2' + '''';
  SqlSrv := SqlSrv + ' and ' + CreateFld(tbCapRes.pfx, fli_CapacyResrvStatus) + ' is null OR ' + CreateFld(tbCapRes.pfx, fli_CapacyResrvStatus) +  ' <> ''' + '3' + '''';
  SqlSrv := SqlSrv + ' Order by ' + CreateFld(tbCapRes.pfx, fli_CapacyResrv);
  srvQry.sql.Text := SqlSrv;
  srvQry.open;

  UpdateOperation(_('Updating') + '  ' + tbCapRes.ASname + ' ' + (_('in host . . .')));
  HostQry.sql.Clear;
  /////////////////////
//  HostQry.Sql.Text := 'Delete from ' + tbCapRes.ASname;
//  HostQry.ExecSQL;
  ////////////////////
  SqlHost := 'select * from ' + tbCapRes.ASname;
  SqlHost := SqlHost + ' Order by UCAPNM';
  HostQry.Sql.Text := SqlHost;
  HostQry.Open;
  ListCapResHost := TList.Create;

  QryDel    := ThreadCreateQueryHost;
  QryUpdate := ThreadCreateQueryHost;
  QryInsert := ThreadCreateQueryHost;
  InsertHostQryTables(tbl,fldList,QryInsert);

  while not HostQry.Eof do
  begin
    new(RecCapRes);
    RecCapRes.CapResNum        := HostQry.FieldByName(fldList[0].fldAS).AsInteger;
    RecCapRes.Res              := HostQry.FieldByName(fldList[1].fldAS).AsString;
    RecCapRes.SubLinRscId      := HostQry.FieldByName(fldList[2].fldAS).AsInteger;
    RecCapRes.WCProcess        := Trim(HostQry.FieldByName(fldList[3].fldAS).AsString);
    RecCapRes.CapacyResTyp     := Trim(HostQry.FieldByName(fldList[4].fldAS).AsString);
    RecCapRes.Capacity_To_Job  := Trim(HostQry.FieldByName(fldList[5].fldAS).AsString);
    RecCapRes.Comment          := Trim(HostQry.FieldByName(fldList[6].fldAS).AsString);
    RecCapRes.schedStart       := TimDateTimeToDateTime(HostQry.FieldByName(fldList[7].fldAS).AsFloat);
    RecCapRes.schedEnd         := TimDateTimeToDateTime(HostQry.FieldByName(fldList[8].fldAS).AsFloat);

    ListCapResHost.Add(RecCapRes);
    HostQry.Next;
  end;

//  ListCapResHost.Sort(SortcapRes);
  IndexCapRes := 0;

  while true do
  begin

    if (IndexCapRes > ListCapResHost.count - 1) and srvQry.Eof then break;

    while True do
    begin
      if (IndexCapRes > ListCapResHost.count - 1) then
      begin
        ChangeType := '1';
        break;
      end;

      if srvQry.Eof then
      begin
        ChangeType := '3';
        break;
      end;

      if pRecCapRes(ListCapResHost[IndexCapRes]).CapResNum > srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResrv)).AsInteger then
      begin
        ChangeType := '1';
        break;
      end;

      if pRecCapRes(ListCapResHost[IndexCapRes]).CapResNum < srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResrv)).AsInteger then
      begin
        ChangeType := '3';
        break;
      end;

      TempSchedStart := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedStart)).AsDateTime;
      DecodeDateTime(TempSchedStart,Year,Month,Day,Hour,Minute,Second,MilliSecond);
      TempSchedStart := EncodeDateTime(Year, Month, Day, Hour, Minute, 0, 0);

      TempSchedEnd  := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedEnd)).AsDateTime;
      DecodeDateTime(TempSchedEnd,Year,Month,Day,Hour,Minute,Second,MilliSecond);
      TempSchedEnd := EncodeDateTime(Year, Month, Day, Hour, Minute, 0, 0);
      CommentStr := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_Comment)).AsString;

      for i := length(CommentStr) downto 1 do
        if CommentStr[i] = '"' then
          CommentStr[i] := ' ';
      CommentStr := StringReplace(CommentStr,'''','',[rfReplaceAll]);

      if (pRecCapRes(ListCapResHost[IndexCapRes]).Res = srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_rsc)).AsString) and
         (pRecCapRes(ListCapResHost[IndexCapRes]).WCProcess = srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_WCProcess)).AsString) and
         (pRecCapRes(ListCapResHost[IndexCapRes]).CapacyResTyp = srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResTyp)).AsString) and
         (pRecCapRes(ListCapResHost[IndexCapRes]).Capacity_To_Job = srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_Capacity_To_Job)).AsString) and
         (pRecCapRes(ListCapResHost[IndexCapRes]).Comment = CommentStr) and //srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_Comment)).AsString) and
         (pRecCapRes(ListCapResHost[IndexCapRes]).schedStart = TempSchedStart) and
         (pRecCapRes(ListCapResHost[IndexCapRes]).schedEnd = TempSchedEnd) then
      begin
        ChangeType := '0';
        break;
      end;

      ChangeType := '2';
      break;
    end;

     if ChangeType = '1' then
     begin
       QryInsert.ParamByName(fldList[0].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(fldList[0].fldAS).Value := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResrv)).AsInteger;
       QryInsert.ParamByName(fldList[1].fldAS).DataType := ftString;
       QryInsert.ParamByName(fldList[1].fldAS).Value := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_rsc)).AsString;
       QryInsert.ParamByName(fldList[2].fldAS).DataType := ftInteger;
       QryInsert.ParamByName(fldList[2].fldAS).Value := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_subLinRscId)).AsInteger;
       QryInsert.ParamByName(fldList[3].fldAS).DataType := ftString;
       QryInsert.ParamByName(fldList[3].fldAS).Value := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_WCProcess)).AsString;
       QryInsert.ParamByName(fldList[4].fldAS).DataType := ftString;
       QryInsert.ParamByName(fldList[4].fldAS).Value := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResTyp)).AsString;
       QryInsert.ParamByName(fldList[5].fldAS).DataType := ftString;
       QryInsert.ParamByName(fldList[5].fldAS).Value := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_Capacity_To_Job)).AsString;
       QryInsert.ParamByName(fldList[6].fldAS).DataType := ftString;
       QryInsert.ParamByName(fldList[6].fldAS).Value := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_Comment)).AsString;
       QryInsert.ParamByName(fldList[7].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(fldList[7].fldAS).Value := DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedStart)).AsDateTime);
       QryInsert.ParamByName(fldList[8].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(fldList[8].fldAS).Value := DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedEnd)).AsDateTime);
       QryInsert.ParamByName(fldList[9].fldAS).DataType := ftString;
       QryInsert.ParamByName(fldList[9].fldAS).Value := IniAppGlobals.WkstCode; //srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_usrCr)).AsString;
       QryInsert.ParamByName(fldList[10].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(fldList[10].fldAS).Value := DateTimeToTimDateTime(Now);
       QryInsert.ParamByName(fldList[11].fldAS).DataType := ftString;
       QryInsert.ParamByName(fldList[11].fldAS).Value := IniAppGlobals.WkstCode;//srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_usrCg)).AsString;
       QryInsert.ParamByName(fldList[12].fldAS).DataType := ftFloat;
       QryInsert.ParamByName(fldList[12].fldAS).Value := DateTimeToTimDateTime(Now);
       QryInsert.ExecSQL;
       srvQry.Next;
       continue;
     end;

     if ChangeType = '2' then
     begin
       QryUpdate.SQL.Clear;
       SqlHost := 'Update ' + tbCapRes.ASname + ' set ';
       SqlHost := SqlHost +  fldList[1].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_rsc)).AsString + '''';
       SqlHost := SqlHost + ',' + fldList[2].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_subLinRscId)).AsInteger) + '''';
       SqlHost := SqlHost + ',' + fldList[3].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_WCProcess)).AsString + '''';
       SqlHost := SqlHost + ',' + fldList[4].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResTyp)).AsString + '''';
       SqlHost := SqlHost + ',' + fldList[5].fldAS + '= ''' + srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_Capacity_To_Job)).AsString + '''';
       SqlHost := SqlHost + ',' + fldList[6].fldAS + '= ''' + CommentStr + '''';
       SqlHost := SqlHost + ',' + fldList[7].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedStart)).AsDateTime)) + '''';
       SqlHost := SqlHost + ',' + fldList[8].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedEnd)).AsDateTime)) + '''';
       SqlHost := SqlHost + ',' + fldList[11].fldAS + '= ''' + IniAppGlobals.WkstCode + '''';
       SqlHost := SqlHost + ',' + fldList[12].fldAS + '= ''' + FloatToStr(DateTimeToTimDateTime(now)) + '''';
       SqlHost := SqlHost + ' where ' + fldList[0].fldAS + '= ''' + IntToStr(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResrv)).AsInteger) + '''';
       QryUpdate.SQL.Text := SqlHost;

       try
         QryUpdate.ExecSQL;
       except

         on E: Exception do
         begin
           sl := TStringList.Create;
           sl.Add('Problem Occured while updating CapRes On Host : ' + 'Cap Res Number : ' +
                     IntToStr(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResrv)).AsInteger));
           sl.Add(' SQL ERROR : ' + QryUpdate.SQL.Text);
           sl.Add(E.Message);
           UpdateError(sl);
           sl.Free;
           Result := false
         end

       end;

       Inc(IndexCapRes);
       srvQry.Next;
       continue;
     end;

     if ChangeType = '3' then
     begin
       QryDel.SQL.Clear;
       SqlHost := 'delete from ' + tbCapRes.ASname + ' where ';
       SqlHost := SqlHost + fldList[0].fldAS + '= ''' + IntToStr(pRecCapRes(ListCapResHost[IndexCapRes]).CapResNum) + '''';
       QryDel.SQL.Text := SqlHost;
       QryDel.ExecSQL;
       Inc(IndexCapRes);
       continue;
     end;

     Inc(IndexCapRes);
     srvQry.Next;
  end;

  for IndexCapRes := 0 to ListCapResHost.Count - 1 do
     dispose(pRecCapRes(ListCapResHost[IndexCapRes]));

  ListCapResHost.free;

  QryDel.Free;
  QryUpdate.Free;
  QryInsert.Free;

end;

//----------------------------------------------------------------------------//

end.
