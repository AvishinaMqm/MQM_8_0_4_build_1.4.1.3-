unit UMNotes;

interface

uses Classes, DMsrvPc ,SysUtils, UMglobal, UMTblDesc, UOpThread;

procedure Handling_PROD_INFO_Notes(read_prod_info_list: TList; m_NeedToMakeMerge : boolean; productionDemandCounters : TList);

implementation

uses UMProductionStruct, UMCommon, UMProdMemory;

procedure Handling_PROD_INFO_Notes(read_prod_info_list: TList; m_NeedToMakeMerge : boolean; productionDemandCounters : TList);
var
  hostSqlStr, srvSqlStr : string;
  HostQry : TMqmQuery;
  languageCode : string;
  NEW_PROD_INFO: PTMQMPI;
  PrevReq , PrevStep : string;
  I, Index : Integer;
  //SrvQryFD, QryFDGen : TMqmQuery;
  PREQ_NO : string;
//  trs, trsRead :  TMqmIBTransaction;
  tbInfo : ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_prod_info];
  HostQry := ThreadCreateQueryHost;

 // SrvQryFD := ThreadCreateQuery(Main_DB);
 // QryFDGen := ThreadCreateQuery(Main_DB);

  hostSqlStr := 'SELECT LANGUAGECODE FROM ABSCOMPANY ' +
                'WHERE CODE = ' + QuotedStr(IniAppGlobals.CompanyCode);
  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;

  if ( not HostQry.Eof ) then
    languageCode := Trim(HostQry.FieldByName('LANGUAGECODE').AsString)
  else
    languageCode := 'EN';

  HostQry.Close;

  hostSqlStr := ' Select * From (SELECT PD.CounterCode, PD.Code, 0.0 StepNumber, NOTE.CODE NoteCode, NOTE ' +
                ' FROM (select * from SchedulesDownloadDemands where ' +
                ' ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                ' COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ') SDD ' +
                ' Join ProductionDemand PD ' +
                ' On PD.CompanyCode = SDD.CompanyCode and PD.CounterCode = SDD.CounterCode and PD.Code = SDD.Code ' +
                ' Join NOTE ' +
                ' On  NOTE.FATHERID = PD.ABSUNIQUEID ' +
                ' And LANGUAGECODE = ' + QuotedStr(languageCode) +
                ' Union all ' +
                ' SELECT PDS.ProductionDemandCounterCode CounterCode, PDS.ProductionDemandCode Code, StepNumber, NOTE.CODE NoteCode, NOTE ' +
                ' FROM (select * from SchedulesDownloadDemands where ' +
                ' ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                ' COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ') SDD ' +
                ' Join ProductionDemandStep PDS On PDS.ProductionDemandCompanyCode = SDD.CompanyCode ' +
                ' and PDS.ProductionDemandCounterCode = SDD.CounterCode and PDS.ProductionDemandCode = SDD.Code ' +
                ' Join NOTE ' +
                ' On NOTE.FATHERID = PDS.ABSUNIQUEID And LANGUAGECODE = ' + QuotedStr(languageCode) + ') NOTE ' +
                ' Order by CounterCode, Code, StepNumber' ;

  HostQry.SQL.Text := hostSqlStr;
  HostQry.open;

  PrevReq := '';
  PrevStep := '';

  I := 0;
  while not HostQry.Eof do
  begin

    New(NEW_PROD_INFO);
    NEW_PROD_INFO.PI_PREQ_NO := setStringLengthTo(IniAppGlobals.CompanyCode, 3) +
                                  setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                                  HostQry.FieldByName('CODE').AsString;
    NEW_PROD_INFO.PI_INFO_TYPE := '5';
    NEW_PROD_INFO.PI_PSTEP_ID := HostQry.FieldByName('STEPNUMBER').AsInteger;

    if (PrevReq <> '') then
    begin
      if (NEW_PROD_INFO.PI_PREQ_NO = PrevReq) and (NEW_PROD_INFO.PI_PSTEP_ID = StrToInt(PrevStep)) then
        Inc(i)
      else
        I := 0;
    end;

    NEW_PROD_INFO.PI_INFO_LINE_NUM := i;

    NEW_PROD_INFO.PI_INFO_AREA := Copy(HostQry.FieldByName('NOTE').AsString, 1, 70);
    NEW_PROD_INFO.PI_USR_CG := 'USERNAME';
    NEW_PROD_INFO.PI_USR_TM_CG := Now;

    PrevReq := NEW_PROD_INFO.PI_PREQ_NO;
    PrevStep := IntToStr(NEW_PROD_INFO.PI_PSTEP_ID);
    if m_NeedToMakeMerge then
    begin
      PREQ_NO := NEW_PROD_INFO.PI_PREQ_NO;
      if CheckMerge(PREQ_NO, setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8), productionDemandCounters) then
      begin
        NEW_PROD_INFO.PI_FAMILYCODE := PREQ_NO;
        m_NeedToMakeMerge := true
      end;
    end;

    read_prod_info_list.Add(NEW_PROD_INFO);
    HostQry.Next;

  end;

{  srvSqlStr := ' select * from PROD_INFO join Prod_req on pI_preq_no = Prod_req.pr_preq_no and ' +
               ' (Prod_req.Pr_Isfamily is null or Prod_req.Pr_Isfamily = ' + QuotedStr('0') + ')' +
               ' ORDER BY PI_PREQ_NO, PI_INFO_TYPE, PI_PSTEP_ID, PI_INFO_LINE_NUM';

  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active:=true;

  Index := 0;

//QryGen.Transaction.Active := true;

  while true do
  begin

    if (Index > read_prod_info_list.count - 1) and srvQry.Eof then break;

    if (Index > read_prod_info_list.count - 1) or
       ((Index <= read_prod_info_list.count - 1) and (not srvQry.Eof) and

       (PPROD_INFOS(read_prod_info_list[Index]).PI_PREQ_NO > srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPreq_No)).AsString) or

       ((PPROD_INFOS(read_prod_info_list[Index]).PI_PREQ_NO = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPreq_No)).AsString) and
        (PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_TYPE > srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Type)).AsString)) or

       ((PPROD_INFOS(read_prod_info_list[Index]).PI_PREQ_NO = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPreq_No)).AsString) and
        (PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_TYPE = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Type)).AsString) and
        (PPROD_INFOS(read_prod_info_list[Index]).PI_PSTEP_ID > srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPstep_Id)).AsString)) or

       ((PPROD_INFOS(read_prod_info_list[Index]).PI_PREQ_NO = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPreq_No)).AsString) and
        (PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_TYPE = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Type)).AsString) and
        (PPROD_INFOS(read_prod_info_list[Index]).PI_PSTEP_ID = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPstep_Id)).AsString) and
        (PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_LINE_NUM > srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Line_Num)).AsString))) then

    begin
      with QryGen do
      begin
        Sql.Clear;
        Sql.Add(' delete from PROD_INFO where');
        Sql.Add(' PI_PREQ_NO ' + '=''' + srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPreq_No)).AsString + '''');
        Sql.Add(' AND PI_INFO_TYPE ' + '=''' + srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Type)).AsString + '''');
        Sql.Add(' AND PI_PSTEP_ID ' + '=''' + srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPstep_Id)).AsString + '''');
        Sql.Add(' AND PI_INFO_LINE_NUM ' + '=''' + srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Line_Num)).AsString + '''');
        ExecSQL;
      end;
      srvQry.next;
      continue;
    end;

    if srvQry.Eof or
      ((Index <= read_prod_info_list.count - 1) and (not srvQry.Eof) and
      (PPROD_INFOS(read_prod_info_list[Index]).PI_PREQ_NO < srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPreq_No)).AsString) or

      ((PPROD_INFOS(read_prod_info_list[Index]).PI_PREQ_NO = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPreq_No)).AsString) and
      (PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_TYPE < srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Type)).AsString)) or

      ((PPROD_INFOS(read_prod_info_list[Index]).PI_PREQ_NO = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPreq_No)).AsString) and
      (PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_TYPE = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Type)).AsString) and
      (PPROD_INFOS(read_prod_info_list[Index]).PI_PSTEP_ID < srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPstep_Id)).AsString))  or

      ((PPROD_INFOS(read_prod_info_list[Index]).PI_PREQ_NO = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPreq_No)).AsString) and
      (PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_TYPE = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Type)).AsString) and
      (PPROD_INFOS(read_prod_info_list[Index]).PI_PSTEP_ID = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIPstep_Id)).AsString) and
      (PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_LINE_NUM < srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Line_Num)).AsString))) then

    begin
      with QryGen do
      begin
          SQL.Text := 'INSERT INTO PROD_INFO ("PI_PREQ_NO", "PI_INFO_TYPE", ' +
                  '"PI_PSTEP_ID", "PI_INFO_LINE_NUM", "PI_INFO_AREA", "PI_USR_NAMECG", ' +
                  '"PI_USR_TIMECG") VALUES (' +
                  QuotedStr(PPROD_INFOS(read_prod_info_list[Index]).PI_PREQ_NO) + ', ' +
                  QuotedStr(PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_TYPE) + ', ' +
                  PPROD_INFOS(read_prod_info_list[Index]).PI_PSTEP_ID + ', ' +
                  QuotedStr(PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_LINE_NUM) + ', ' +
                  QuotedStr(PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_AREA) + ', ' +
                  QuotedStr(PPROD_INFOS(read_prod_info_list[Index]).PI_USR_NAMECG) + ', ' +
                  ConvertDateFormatTo(PPROD_INFOS(read_prod_info_list[Index]).PI_USR_TIMECG, GetDownloadTo) + ')';
          try
            ExecSQL;
            Inc(Index);
            except
           // on E: Exception do
            begin
           //   E.Message := E.Message + ('  Request : ' + PPROD_REQHDRS(read_prod_info_list[Index]).PH_PREQ_NO);
           //   raise;
            end;
            Inc(Index);
          end;
          continue;
      end;
    end;

    // key is equal

    if ((PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_AREA) <> srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PIInfo_Area)).AsString) then
    begin
      with QryGen do
      begin
          SQL.Text := 'UPDATE PROD_INFO SET ' +
                  '"PI_INFO_AREA" = ' + QuotedStr(PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_AREA) + ', ' +
                  '"PI_USR_NAMECG" = ' + QuotedStr(PPROD_INFOS(read_prod_info_list[Index]).PI_USR_NAMECG) + ', ' +
                  '"PI_USR_TIMECG" = ' + ConvertDateFormatTo(PPROD_INFOS(read_prod_info_list[Index]).PI_USR_TIMECG, GetDownloadTo) + ' ' +
                  'WHERE "PI_PREQ_NO" = ' + QuotedStr(PPROD_INFOS(read_prod_info_list[Index]).PI_PREQ_NO) + ' AND ' +
                  '"PI_INFO_TYPE" = ' + QuotedStr(PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_TYPE) + ' AND ' +
                  '"PI_PSTEP_ID" = ' + PPROD_INFOS(read_prod_info_list[Index]).PI_PSTEP_ID + ' AND ' +
                  '"PI_INFO_LINE_NUM" = ' + PPROD_INFOS(read_prod_info_list[Index]).PI_INFO_LINE_NUM;
        ExecSQL;
      end;
    end;
    srvQry.Next;
    Inc(Index);
  end;

  QryGen.connection.commit;
//trs.Commit;
//trsRead.Free;
  srvQry.free;
//trs.Free;
  QryGen.Free;
  HostQry.Free;            }

  HostQry.free;

//  SrvQryFD.free;
//  QryFDGen.free;

end;


end.
