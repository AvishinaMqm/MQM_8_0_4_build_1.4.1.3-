unit UMload;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Db,  StdCtrls,
  UMTblDesc,
  DMSrvPC,
  gnugettext ;

  function LoadAlternativeWC(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadaltWarehouse(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadArticleType(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadBalanceHeader(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadBalanceDetail(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadCalendar(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadCategory(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadCapacityReserv(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadCapacityProp(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadDownloadTime(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadForcedSched(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadHeadRscSplit(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadOccOccCompatRule(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadGroupByPropertyRule(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;

//Eran said that this tables are not needed
{
  function LoadOverlappingQuantities(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadOverlappingRules(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadNonWorkingHour(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadRscDivision(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
}
  function LoadMachineSetupCode(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean; //MQMMS
//  function LoadMaterial(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean; //MQMMT
  function LoadMaterialSupDetail(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean; //MQMMD
  function LoadMaterialSupHeader(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean; //MQMMH
  function LoadProdLineCntr(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadProdSched(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadProperty(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadPropertyOld(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  //  function LoadProducedArticle(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean; //MQMPA
  function LoadProducts(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadStockDetail(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadResources(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadRscOccCompatRul(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadRscProperty(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadIdentifiers(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;

  //  function LoadSetUpAddRsc(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadStpProgress(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadUnit(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function Loadwkst(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function Loadwkctr(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadwkctrGroup(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadWkcDependency(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean; //MQMWD
  function LoadProc(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadWCProc(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function Loadwkst_wkctrs(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadWorkCntrPrior(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;

  function LoadExt_Info(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadExt_InfoHeadr(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadMaterialSchedule(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadMaterialScheduleLink(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadProductProperties(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;

  /// mcm tables
{  function Load_wkc_Category(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function Load_CategoryDatesInfo(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function Load_wkc_Penalties(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean; }

  /////
  function UpdateWorkCenterVisible(qry: TMqmQuery): boolean;
  function UpdateLocalPropertyTable(qry: TMqmQuery): boolean;
  function UpdateLocalPlantForWorkCenter(qry: TMqmQuery): boolean;
  function Load_Learning_Curve(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadItemsStock(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadItemsStockExceptions(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function LoadItemsStockChanges(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function Load_Material_Tollerance_Types(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function DeleteOldLogRecords(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  function DeleteSharedDataRecords(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;

implementation

uses
  SysUtils,
  StrUtils,
  UMSrvConfig,
  UMSrvLoad,
  UMStoredProc,
  UMSaveLoad,
  UGBaseCal,
  UMglobal,
  DateUtils,
  FireDAC.Stan.Error,
  UMProductionStruct,
  UMProdMemory,
  UMCommon,
  UOpThread,
  UGconvert;

type

  RecWS = record
    WS_wkstCode : string;
    WS_wkDescr   : string;
    WS_wkPasswd : string;
    WS_usrCr    : string;
    WS_usrTmCr  : TDateTime;
    WS_usrCg    : string;
    WS_usrTmCg  : TDateTime;
    WS_WkStationType : string;
  end;
  PRecWS = ^RecWS;

  RecAR = record
    AR_ArtProdType : string;
    AR_ProdCode   : string;
    AR_ProductNature : string;
    AR_StartConsumPoint : string;
    AR_EndConsumPoint : string;
    AR_InfoArea       : string;
    AR_StdPurcOrProdTime : Integer;
    AR_Ignor_Mat_check   : boolean;
    AR_MATERIAL_TOLLERANCE_CODE : string;
    AR_HOURSTODOWNFROMMACHINE : integer;
  end;
  PRecAR = ^RecAR;

  RecBH = record
    BH_ProdType : string;
    BH_InfoArea   : string;
    BH_ProdCode : string;
    BH_netGroupCode : string;
    BH_dueDate : TDateTime;
    BH_OrigdueDate : TDateTime;
    BH_quant : double;
    BH_usrCg : string;
    BH_usrTmCg : TDateTime;
    BH_TabIndex : Integer;
  end;
  PRecBH = ^RecBH;

  RecBD = record
    BD_dueDate : TDateTime;
    BD_InfoArea   : string;
    BD_netGroupCode : string;
    BD_occupyCode : string;
    BD_ProdCode : string;
    BD_quant : double;
    BD_ProdType : string;
  end;
  PRecBD = ^RecBD;

  RecEI = record
    EI_ConnKey : string;
    EI_infoLineNum : Integer;
    EI_InfoArea : string;
    EI_usrCg : string;
    EI_usrTmCg : TDateTime;
  end;
  PRecEI = ^RecEI;

  RecEH = record
    EH_ConnKey  : string;
    EH_ConnType : string;
    EH_DueDate  : TDateTime;
    EH_usrCg    : string;
    EH_usrTmCg  : TDateTime;
  end;
  PRecEH = ^RecEH;

  RecSD = record
    SD_BalanceIdentifier : LongInt;
    SD_prodtype : string;
    SD_ProdCode : string;
    SD_netGroupCode : string;
    SD_Details : string;
  end;
  PRecSD = ^RecSD;

//----------------------------------------------------------------------------//

function LoadDateTime(tbl: table; ASLib, AScondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  tbInfo:         ^TTblInfo;
  tblName:        string;
begin
  tbInfo := @tblInfo[tbl];

  tbInfo.ASname := 'MQMCN00f';
  tblName  := ASLib + tbInfo.ASname;

  // select the data from AS400
  if (Trim(IniAppGlobals.PreparationExeName) = '') then
  begin
    with HostQry do
    begin
      HostQry := ThreadCreateQueryHost;
      UpdateOperation(_('Reading Time from host . . .'));
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.ASname);
   //   SQL.Add(tbInfo.ASname);
      Open
    end;
  end;

  with srvQry do
  begin
    UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    ExecSQL;
    Close;

    UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_downloadTime)+ ',');
    SQL.Add(CreateFld(tbInfo.pfx,  fli_IDENTIFIER));
    SQL.Add(') values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_downloadTime) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    SQL.Add(')');

    if (Trim(IniAppGlobals.PreparationExeName) = '') and not HostQry.EOF then
    begin
      if (GetDateTimeFormat = Frm_As400) then
      begin
        ParamByName(CreateFld(tbInfo.pfx, fli_downloadTime)).AsDateTime := TimDateTimeToDateTime(HostQry.FieldByName('KSRSTR').AsFloat);
        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;
      end;
    end
    else
    begin
      Params.ParamByName(CreateFld(tbInfo.pfx, fli_downloadTime)).AsDateTime := now;//HostQry.FieldByName('KSRSTR').AsDateTime;
      Params.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;//HostQry.FieldByName('KSRSTR').AsDateTime;
    end;
    srvQry.ExecSQL;
    srvQry.Connection.Commit;
    srvQry.Close
  end;

  UpdateOperation(_('Loaded')+ ' ' + tbInfo.GetTableName);
  Result := true
end;

//----------------------------------------------------------------------------//

function OpenQryTables(tbl: table; ASLib, AScondition, OrderCondition: string;
                   linkArr: array of TQryLinkRec;
                   var HostQry: TMqmQuery; var ArcQry: TMqmQuery; UseArcTable : boolean): boolean;
var
  tbInfo:         ^TTblInfo;
//  tblName:        string;
  linkList:       TList;
  sl:             TStringList;
  GeneralSQL, LocalTableName:     String;
  DndArchiveHostName, LocalHostName : TDndArchiveName;
begin
  tbInfo := @tblInfo[tbl];
  linkList := nil;
  Result := true;
  DndArchiveHostName := GetDndArchiveHostName;
  LocalHostName := GetDndArchiveLocalName;

  LocalTableName := tbInfo.PCname;
  if LocalHostName <> TD_Interbase then
    LocalTableName  := 'SCDA_' + tbInfo.PCname;

  if DndArchiveHostName = TD_AS_400 then
  begin
    HostQry  := ThreadCreateQueryHost;
    with HostQry do
    begin
      SQL.Clear;
      GeneralSQL := '';
      GeneralSQL := 'select * from ' + tbInfo.ASname;
      if AScondition <> '' then
        GeneralSQL := GeneralSQL + AScondition;
      if OrderCondition <> '' then
        GeneralSQL := GeneralSQL + OrderCondition;
      SQL.Add(GeneralSQL);
      Open
    end;
  end
  else
  begin
    GeneralSQL := 'select * from ' + LocalTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    if UseArcTable then
    begin
      ArcQry := ThreadCreateQueryArc;
      ArcQry.SQL.Add(GeneralSQL);
      ArcQry.Open
    end
    else
    begin
      with HostQry do
      begin
        SQL.Clear;
        SQL.Add(GeneralSQL);
        Open
      end;
    end;
    // avi old code
  end;


{  except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add('while loading ' + tbInfo.PCname);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        if Assigned(linkList) then linkList.Free;
        Result := false
      end
  end; }

end;

//----------------------------------------------------------------------------//

function InsertQryTables(tbl: table; linkArr: array of TQryLinkRec; srvQry: TMqmQuery) : boolean;
var
  tbInfo:         ^TTblInfo;
  I : Integer;
  sl : TStringList;
//  linkList : TList;
begin
  Result := true;
  tbInfo := @tblInfo[tbl];

//  UpdateOperation(_('Loaded to memory') + ' ' + tbInfo.ASname);
//  try

  with srvQry do
  begin

    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName + ' (');
    for i := 0 to High(linkArr)-1 do
      SQL.Add(CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC));
    SQL.Add(') values (');
    for i := 0 to High(linkArr)-1 do
      SQL.Add(':' + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + ')');
  //  Prepare;
  end;

{  except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add('while Insert ' + tbInfo.PCname);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
  //      if Assigned(linkList) then linkList.Free;
        Result := false
      end
  end; }

end;

//----------------------------------------------------------------------------//

function LoadTable(tbl: table; ASLib, AScondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  i, parm, field: integer;
  tbInfo:         ^TTblInfo;
  tblName, tblArcName :        string;
  linkList:       TList;
  fldF:           double;
  fldI:           integer;
  sl:             TStringList;
  RecNumber: integer;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL:     String;
  DndArchiveHostName, DndArchiveArcName : TDndArchiveName;
begin
  Result := true;
  RecNumber := 0;
  field := 1;
  DndArchiveHostName := GetDndArchiveHostName;
  DndArchiveArcName := GetDndArchiveLocalName;

  DateTimeFormat := GetDateTimeFormat;
  tbInfo := @tblInfo[tbl];

  if DndArchiveHostName = TD_AS_400 then
  begin
    tblName  := ASLib + tbInfo.ASname;
    linkList := nil;

    try
      // select the data from AS400
      with HostQry do
      begin
        UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
        SQL.Clear;
        GeneralSQL := '';
        // Select only needed columns — reduces WAN data transfer
        GeneralSQL := ' Select ';
        for i := 0 to High(linkArr)-1 do
          GeneralSQL := GeneralSQL + linkArr[i].fldAS + ',';
        GeneralSQL := GeneralSQL + linkArr[High(linkArr)].fldAS + ' from ' + tbInfo.ASname;
        if AScondition <> '' then
          GeneralSQL := GeneralSQL + AScondition;
        SQL.Add(GeneralSQL);
        Open
      end;

      with srvQry do
      begin

        // clear the table on the server
        UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
        SQL.Clear;
        SQL.Add('delete from ' + tbInfo.GetTableName);
        ExecSQL;
        Close;
        Application.ProcessMessages;

        // update the server
        UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);

        SQL.Clear;
        SQL.Add('insert into ' + tbInfo.GetTableName + ' (');
        for i := 0 to High(linkArr)-1 do
          SQL.Add(CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
        SQL.Add(CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC));
        SQL.Add(') values (');
        for i := 0 to High(linkArr)-1 do
          SQL.Add(':' + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + ')');
   //     Prepare;

        linkList := TList.Create;
        for i := 0 to High(linkArr) do
        begin
          linkList.Add(srvQry.ParamByName(CreateFld(tbInfo.pfx, linkArr[i].fldPC)));
          try
            linkList.Add(HostQry.FieldByName(linkArr[i].fldAS))
          except
            linkList.Add(nil);
            Continue;
          end;
        end;

        RecNumber := 0;
        while not HostQry.EOF do
        begin
          // assign the fields
          parm  := 0;
          field := 1;

          for i := 0 to High(linkArr) do
          begin
            case linkArr[i].fldType of
              TLD_string   :  begin
                                try
                                  if linkList[field] = nil then
                                    Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := ''
                                  else
                                    Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := Trim(TField(linkList[field]).AsString);
                                except
                                  Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := '';
                                end;
                              end;

              TLD_integer  :  begin
                                try
                                  if linkList[field] = nil then
                                    Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0
                                  else
                                    Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := TField(linkList[field]).AsInteger;
                                   // ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsInteger := 1;//TField(linkList[field]).AsInteger;
                                except
                                  Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0;
                                end;

                              end;

              TLD_float    :  begin
                                try
                                  if linkList[field] = nil then
                                     Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0
                                  else
                                     Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := TField(linkList[field]).AsFloat;
                                except
                                  Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0;
                                end;
                              end;

              TLD_date     : begin
                               try
                                 if linkList[field] = nil then
                                    Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0
                                 else
                                 begin
                                   if (DateTimeFormat = Frm_As400) then
                                     Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := TruncToDayDate(TimDateToDateTime(TField(linkList[field]).AsFloat))
                                   else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
                                     Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := TField(linkList[field]).AsFloat;
                                 end;
                               except
                                 Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0;
                               end;

                             end;
              TLD_dateTime : begin
                               try
                                 if linkList[field] = nil then
                                   Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0
                                 else
                                 begin
                                   if (DateTimeFormat = Frm_As400) then
                                     Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := TimDateTimeToDateTime(TField(linkList[field]).AsFloat)
                                   else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
                                     Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := TField(linkList[field]).AsDateTime;
                                 end;
                               except
                                 Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0;
                               end;
                             end;
              TLD_calConv  :
                begin
                  try
                    if linkList[field] = nil then
                       Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0
                    else
                    begin
                      fldF := TField(linkList[field]).AsFloat;
                      fldI := Trunc(TField(linkList[field]).AsFloat/100);
                      Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := fldI*60 + Trunc(fldF-fldI*100)
                    end;
                  except
                    Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0;
                  end;
                end
            end;
            parm  := parm  + 2;
            field := field + 2
          end;

          srvQry.ExecSql;
          HostQry.Next;
          if (RecNumber mod 500 = 0) then Application.ProcessMessages;

          inc(RecNumber);
          if (RecNumber mod 100) = 0 then
            UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName + ' ' + intToStr(RecNumber));
        end;

        linkList.Free;
        HostQry.Close;
      end;

      UpdateOperation(_('Loaded')+ ' ' + tbInfo.ASname);
      Result := true
    except
      on E: Exception do
        begin
          sl := TStringList.Create;
          sl.Add('while loading ' + tbInfo.GetTableName);
          sl.Add(E.Message);
          UpdateError(sl);
          sl.Free;
          if Assigned(linkList) then linkList.Free;
          Result := false;
          raise
        end
    end
  end

  else
  begin

    tblArcName := tbInfo.PCname;
    if DndArchiveArcName <> TD_Interbase then
      tblArcName  := 'SCDA_' + tbInfo.PCname;

    linkList := nil;

    try
      // select the data from AS400
      with HostQry do
      begin
        UpdateOperation(_('Reading') + '  ' + tblArcName + ' ' + (_('from host . . .')));
        SQL.Clear;
        GeneralSQL := '';
        GeneralSQL := ' Select * from ' +  tblArcName;
        if (tbl <> tbl_Identifiers) then
          GeneralSQL := GeneralSQL + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER));

        SQL.Add(GeneralSQL);
        Open
      end;

      with srvQry do
      begin

        // clear the table on the server
        UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
        SQL.Clear;
        SQL.Add('delete from ' + tbInfo.GetTableName);
        if (tbl <> tbl_Identifiers) then
           SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
        ExecSQL;
        Close;
        Application.ProcessMessages;

        // update the server
        UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);

        SQL.Clear;
        SQL.Add('insert into ' + tbInfo.GetTableName + ' (');
        for i := 0 to High(linkArr)-1 do
          SQL.Add(CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
        SQL.Add(CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC));
        SQL.Add(') values (');
        for i := 0 to High(linkArr)-1 do
          SQL.Add(':' + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + ')');
     //   Prepare;

        linkList := TList.Create;
        for i := 0 to High(linkArr) do
        begin
          linkList.Add(srvQry.ParamByName(CreateFld(tbInfo.pfx, linkArr[i].fldPC)));
          //linkList.Add(HostQry.FieldByName(CreateFld(tbInfo.pfx, linkArr[i].fldPC)));
          try
            linkList.Add(HostQry.FieldByName(CreateFld(tbInfo.pfx, linkArr[i].fldPC)));
          except
            linkList.Add(nil);
            Continue;
          end;
        end;

        RecNumber := 0;
        while not HostQry.EOF do
        begin
          // assign the fields
          parm  := 0;
          field := 1;

          for i := 0 to High(linkArr) do
          begin
            case linkArr[i].fldType of
              TLD_string   : begin
                               try

                                 if linkList[field] = nil then
                                 begin
                                   if DndArchiveArcName = TD_Oracle then
                                     ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsString := ' '
                                   else
                                     ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsString := ''
                                 end
                                 else
                                 begin
                                   if (DndArchiveArcName = TD_Oracle) and (Trim(TField(linkList[field]).AsString) = '') then
                                     ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsString := ' '
                                   else
                                     ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsString := Trim(TField(linkList[field]).AsString)
                                 end;
                               except
                                 ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsString := '';
                               end;
                             end;

              TLD_integer  : begin
                               try
                                 if linkList[field] = nil then
                                   ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsInteger := 0
                                 else
                                   ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsInteger  := TField(linkList[field]).AsInteger;
                               except
                                 ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsInteger := 0;
                               end;
                             end;
              TLD_float    : begin
                               try
                                 if linkList[field] = nil then
                                    ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsFloat := 0
                                 else
                                   ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsFloat := TField(linkList[field]).AsFloat;
                               except
                                 ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsFloat := 0;
                               end;
                             end;

              TLD_date     : begin
                               try
                                 if linkList[field] = nil then
                                   ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsDate := 0
                                 else
                                 begin
                                   if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
                                     ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsDate := TField(linkList[field]).AsFloat;
                                 end;
                               except
                                 ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsDate := 0;
                               end;
                             end;
              TLD_dateTime : begin
                               try
                                 if linkList[field] = nil then
                                   ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsDateTime := 0
                                 else
                                 begin
                                   if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
                                     ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsDateTime := TField(linkList[field]).AsDateTime;
                                 end;
                               except
                                 ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsDateTime := 0;
                               end;
                             end;
              TLD_calConv  :
                begin
                  fldF := TField(linkList[field]).AsFloat;
                  fldI := Trunc(TField(linkList[field]).AsFloat/100);
                  ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsInteger := fldI*60 + Trunc(fldF-fldI*100)
                end
            end;
            parm  := parm  + 2;
            field := field + 2
          end;

          srvQry.ExecSql;
          HostQry.Next;
          if (RecNumber mod 500 = 0) then Application.ProcessMessages;

          inc(RecNumber);
          if (RecNumber mod 100) = 0 then
            UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName + ' ' + intToStr(RecNumber));
        end;

        linkList.Free;
        HostQry.Close;
      end;

      UpdateOperation(_('Loaded')+ ' ' + tbInfo.GetTableName);
      Result := true
    except
      on E: Exception do
        begin
          sl := TStringList.Create;
          sl.Add('while loading ' + tbInfo.GetTableName);
          sl.Add(E.Message);
          UpdateError(sl);
          sl.Free;
          if Assigned(linkList) then linkList.Free;
          Result := false;
          Raise
        end
    end

  end;

end;

//----------------------------------------------------------------------------//

function LoadWorcCenterProcessTable(tbl: table; ASLib, AScondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
type
  TWorkCenterProcess = Record
    WorkCenter : string;
    Process    : string;
    UseAllResourceParts : string;
  end;
  PWorkCenterProcess = ^TWorkCenterProcess;

  function SearchInList(List : TList; Wc : string; Process : string) : boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to List.Count - 1 do
    begin
      if (Wc = PWorkCenterProcess(List[J]).WorkCenter) and (Process = PWorkCenterProcess(List[J]).Process) then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;

var
  i, parm, field: integer;
  tbInfo:         ^TTblInfo;
  tblName:        string;
  linkList:       TList;
  fldF:           double;
  fldI:           integer;
  sl:             TStringList;
  RecNumber: integer;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL:     String;
  DndArchiveHostName : TDndArchiveName;
  WorkCenterProcess : PWorkCenterProcess;
  List_wcProces1, List_wcProces2 : TList;
begin
  Result := true;
  DndArchiveHostName := GetDndArchiveHostName;
  DateTimeFormat := GetDateTimeFormat;
  tbInfo := @tblInfo[tbl];

  tblName  := ASLib + tbInfo.ASname;
  linkList := nil;

  with srvQry do
  begin
    List_wcProces1 := TList.Create;
    SQL.Clear;
    GeneralSQL := '';
    GeneralSQL := ' Select * from ' + tbInfo.GetTableName;
    SQL.Add(GeneralSQL);
    Open;
    while not srvQry.EOF do
    begin
      try
      if (FieldByName(CreateFld(tbInfo.pfx, fli_UseAllResourceParts)).AsString = '0') then
      begin
        New(WorkCenterProcess);
        WorkCenterProcess.WorkCenter := FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString;
        WorkCenterProcess.Process := FieldByName(CreateFld(tbInfo.pfx, fli_wkcProc)).AsString;
        WorkCenterProcess.UseAllResourceParts := FieldByName(CreateFld(tbInfo.pfx, fli_UseAllResourceParts)).AsString;
        List_wcProces1.Add(WorkCenterProcess);
      end

      else if (FieldByName(CreateFld(tbInfo.pfx, fli_UseAllResourceParts)).AsString = '1') then
      begin
        New(WorkCenterProcess);
        WorkCenterProcess.WorkCenter := FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString;
        WorkCenterProcess.Process := FieldByName(CreateFld(tbInfo.pfx, fli_wkcProc)).AsString;
        WorkCenterProcess.UseAllResourceParts := FieldByName(CreateFld(tbInfo.pfx, fli_UseAllResourceParts)).AsString;
        List_wcProces1.Add(WorkCenterProcess);
      end

      else if (FieldByName(CreateFld(tbInfo.pfx, fli_UseAllResourceParts)).AsString = '2') then
      begin
        New(WorkCenterProcess);
        WorkCenterProcess.WorkCenter := FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString;
        WorkCenterProcess.Process := FieldByName(CreateFld(tbInfo.pfx, fli_wkcProc)).AsString;
        WorkCenterProcess.UseAllResourceParts := FieldByName(CreateFld(tbInfo.pfx, fli_UseAllResourceParts)).AsString;
        List_wcProces1.Add(WorkCenterProcess);
      end;

      Next;
      except
        break;
      end;
    end;
  end;

  try
    // select the data from AS400
    with HostQry do
    begin
      UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
      SQL.Clear;
      GeneralSQL := '';
      GeneralSQL := ' Select * from ' +  tbInfo.ASname;
      if AScondition <> '' then
        GeneralSQL := GeneralSQL + AScondition;
      SQL.Add(GeneralSQL);
      Open
    end;

    with srvQry do
    begin

      // clear the table on the server
      UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
      SQL.Clear;
      SQL.Add('delete from ' + tbInfo.GetTableName);
      ExecSQL;
      Close;
      Application.ProcessMessages;

      // update the server
      UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);

      SQL.Clear;
      SQL.Add('insert into ' + tbInfo.GetTableName + ' (');
      for i := 0 to High(linkArr)-1 do
        SQL.Add(CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC));
      SQL.Add(') values (');
      for i := 0 to High(linkArr)-1 do
        SQL.Add(':' + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + ')');
//      Prepare;

      linkList := TList.Create;
      for i := 0 to High(linkArr) do
      begin
        linkList.Add(srvQry.ParamByName(CreateFld(tbInfo.pfx, linkArr[i].fldPC)));
        try
          linkList.Add(HostQry.FieldByName(linkArr[i].fldAS))
        except
          linkList.Add(nil);
          Continue;
        end;
      end;

      RecNumber := 0;
      while not HostQry.EOF do
      begin
        // assign the fields
        parm  := 0;
        field := 1;

        for i := 0 to High(linkArr) do
        begin
          case linkArr[i].fldType of
            TLD_string   : Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value   := Trim(TField(linkList[field]).AsString);
            TLD_integer  :  begin //Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value  := TField(linkList[field]).AsInteger;
                              try
                                if linkList[field] = nil then
                                  Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0
                                else
                                  Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := TField(linkList[field]).AsInteger;
                                 // ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).AsInteger := 1;//TField(linkList[field]).AsInteger;
                              except
                                Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := 0;
                              end;
                            end;

            TLD_float    : Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value    := TField(linkList[field]).AsFloat;
            TLD_date     : begin
                             if (DateTimeFormat = Frm_As400) then
                               Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value := TruncToDayDate(TimDateToDateTime(TField(linkList[field]).AsFloat))
                             else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
                               Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value := TField(linkList[field]).AsFloat;
                           end;
            TLD_dateTime : begin
                             if (DateTimeFormat = Frm_As400) then
                               Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value := TimDateTimeToDateTime(TField(linkList[field]).AsFloat)
                             else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
                               Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value := TField(linkList[field]).AsDateTime;
                           end;
            TLD_calConv  :
              begin
                fldF := TField(linkList[field]).AsFloat;
                fldI := Trunc(TField(linkList[field]).AsFloat/100);
                Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value := fldI*60 + Trunc(fldF-fldI*100)
              end
          end;
          parm  := parm  + 2;
          field := field + 2
        end;

        srvQry.ExecSql;
        HostQry.Next;
        if (RecNumber mod 500 = 0) then Application.ProcessMessages;

        inc(RecNumber);
        if (RecNumber mod 100) = 0 then
          UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName + ' ' + intToStr(RecNumber));
      end;

      linkList.Free;
      HostQry.Close;
    end;

    UpdateOperation(_('Loaded')+ ' ' + tbInfo.ASname);
    Result := true
    except
    on E: Exception do
    begin
    {  sl := TStringList.Create;
      sl.Add('while loading ' + tbInfo.PCname);
      sl.Add(E.Message);
      UpdateError(sl);
      sl.Free;
      if Assigned(linkList) then linkList.Free;  }
      Result := false;
      raise
    end
  end;

  if List_wcProces1.Count > 0 then
  begin
    with srvQry do
    begin
      List_wcProces2 := TList.Create;
      SQL.Clear;
      GeneralSQL := '';
      GeneralSQL := ' Select * from ' + tbInfo.GetTableName;
      SQL.Add(GeneralSQL);
      Open;
      while not srvQry.EOF do
      begin
        New(WorkCenterProcess);
        WorkCenterProcess.WorkCenter := FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString;
        WorkCenterProcess.Process := FieldByName(CreateFld(tbInfo.pfx, fli_wkcProc)).AsString;
        List_wcProces2.Add(WorkCenterProcess);
        Next;
      end;

      SQL.Clear;
      SQL.Add('update ' + tbInfo.GetTableName + ' set ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_UseAllResourceParts)  + '=');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_UseAllResourceParts)   );
      SQL.Add(' where ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wkCtrCode)         + '=');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkCtrCode)   + ' and ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wkcProc)           + '=');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkcProc));

      for I := 0 to List_wcProces1.Count - 1 do
      begin
        if SearchInList(List_wcProces2, PWorkCenterProcess(List_wcProces1[I]).WorkCenter, PWorkCenterProcess(List_wcProces1[I]).Process) then
        begin
          ParamByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString := PWorkCenterProcess(List_wcProces1[I]).WorkCenter;
          ParamByName(CreateFld(tbInfo.pfx, fli_wkcProc)).AsString := PWorkCenterProcess(List_wcProces1[I]).Process;
          ParamByName(CreateFld(tbInfo.pfx, fli_UseAllResourceParts)).AsString := PWorkCenterProcess(List_wcProces1[I]).UseAllResourceParts  ;
          ExecSQL;
        end;
      end;

      for I := 0 to List_wcProces2.Count - 1 do
        Dispose(PWorkCenterProcess(List_wcProces2[I]));

      List_wcProces2.Free;
    end;
  end;

  for I := 0 to List_wcProces1.Count - 1 do
    Dispose(PWorkCenterProcess(List_wcProces1[I]));

  List_wcProces1.Free;

end;

//----------------------------------------------------------------------------//

function LoadResourceTable(tbl: table; ASLib, AScondition: string;
                   linkArr: array of TQryLinkRec; linkArrPC: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
type
  TRESOURCE = Record
    RESCODE : string;
    Tex1    : string;
    Tex2    : string;
    WorkedAsOneBtachMachineCode : string;
    LineWithinPlant : string;
    GroupCodeBy : string;
  end;
  PTRESOURCE = ^TRESOURCE;

  function SearchInList(List : TList; Res : String; var Text1 : string; var text2 : string; var WorkedAsOneBtachMachineCode : string;
    var GroupCodeBy : string; var LineWithinPlant : string) : boolean;
  var
    J : Integer;
  begin
    Result := false;
    Text1 := '';
    Text2 := '';
    for J := 0 to List.Count - 1 do
    begin
      if (Res = PTRESOURCE(List[J]).RESCODE) then
      begin
        Text1 := PTRESOURCE(List[J]).Tex1;
        Text2 := PTRESOURCE(List[J]).Tex2;
        WorkedAsOneBtachMachineCode := PTRESOURCE(List[J]).WorkedAsOneBtachMachineCode;
        GroupCodeBy := PTRESOURCE(List[J]).GroupCodeBy;
        LineWithinPlant := PTRESOURCE(List[J]).LineWithinPlant;
        Result := true;
        Exit;
      end;
    end;
  end;

var
  i, parm, field: integer;
  tbInfo:         ^TTblInfo;
  tblName, tblArcName:        string;
  linkList:       TList;
  fldF:           double;
  fldI:           integer;
  sl:             TStringList;
  RecNumber: integer;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL:     String;
  DndArchiveHostName, DndArchiveArcName : TDndArchiveName;
  RESOURCE : PTRESOURCE;
  List_res, List_res2 : TList;
begin
  Result := true;
  DndArchiveHostName := GetDndArchiveHostName;
  DndArchiveArcName := GetDndArchiveLocalName;
  tbInfo := @tblInfo[tbl];

  tblArcName := tbInfo.PCname;
  if DndArchiveArcName <> TD_Interbase then
    tblArcName  := 'SCDA_' + tbInfo.PCname;

  DateTimeFormat := GetDateTimeFormat;

  if DndArchiveHostName = TD_AS_400 then
  begin
    tblName  := ASLib + tbInfo.ASname;
    linkList := nil;

    ////////  handling text resource

    with srvQry do
    begin
      List_res := TList.Create;
      SQL.Clear;
      GeneralSQL := '';
      GeneralSQL := ' Select * from ' + tbInfo.GetTableName;
      SQL.Add(GeneralSQL);
      Open;
      while not srvQry.EOF do
      begin
        try
        if (FieldByName(CreateFld(tbInfo.pfx, fli_DisplayText1)).AsString <> '') or
           (FieldByName(CreateFld(tbInfo.pfx, fli_DisplayText2)).AsString <> '') or
           (FieldByName(CreateFld(tbInfo.pfx, fli_WorkAsOneBatchMachineGroupCode)).AsString <> '') or
           (FieldByName(CreateFld(tbInfo.pfx, fli_LineWithinPlant)).AsString <> '') or
           (FieldByName(CreateFld(tbInfo.pfx, fli_OneBatchMachineGrouptype)).AsString <> '') then
        begin
          New(RESOURCE);
          RESOURCE.RESCODE := FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString;
          RESOURCE.Tex1 := '';
          RESOURCE.Tex2 := '';
          RESOURCE.WorkedAsOneBtachMachineCode := '';
          RESOURCE.GroupCodeBy := '';
          RESOURCE.LineWithinPlant := '';
          if not FieldByName(CreateFld(tbInfo.pfx, fli_DisplayText1)).IsNull then
             RESOURCE.Tex1 := FieldByName(CreateFld(tbInfo.pfx, fli_DisplayText1)).AsString;
          if not FieldByName(CreateFld(tbInfo.pfx, fli_DisplayText2)).IsNull then
             RESOURCE.Tex2 := FieldByName(CreateFld(tbInfo.pfx, fli_DisplayText2)).AsString;
          if not FieldByName(CreateFld(tbInfo.pfx, fli_WorkAsOneBatchMachineGroupCode)).IsNull then
             RESOURCE.WorkedAsOneBtachMachineCode := FieldByName(CreateFld(tbInfo.pfx, fli_WorkAsOneBatchMachineGroupCode)).AsString;
          if not FieldByName(CreateFld(tbInfo.pfx, fli_OneBatchMachineGrouptype)).IsNull then
             RESOURCE.GroupCodeBy := FieldByName(CreateFld(tbInfo.pfx, fli_OneBatchMachineGrouptype)).AsString;
          if not FieldByName(CreateFld(tbInfo.pfx, fli_LineWithinPlant)).IsNull then
             RESOURCE.LineWithinPlant := FieldByName(CreateFld(tbInfo.pfx, fli_LineWithinPlant)).AsString;

          List_res.Add(RESOURCE);
        end;
        Next;
        except
          break;
        end;
      end;
    end;

    try
      // select the data from AS400
      with HostQry do
      begin
        UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
        SQL.Clear;
        GeneralSQL := '';
        // Select only needed columns — reduces WAN data transfer
        GeneralSQL := ' Select ';
        for i := 0 to High(linkArr)-1 do
          GeneralSQL := GeneralSQL + linkArr[i].fldAS + ',';
        GeneralSQL := GeneralSQL + linkArr[High(linkArr)].fldAS + ' from ' + tbInfo.ASname;
        if AScondition <> '' then
          GeneralSQL := GeneralSQL + AScondition;
        SQL.Add(GeneralSQL);
        Open
      end;

      with srvQry do
      begin

        // clear the table on the server
        UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
        SQL.Clear;
        SQL.Add('delete from ' + tbInfo.GetTableName);
        ExecSQL;
        Close;
        Application.ProcessMessages;

        // update the server
        UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);

        SQL.Clear;
        SQL.Add('insert into ' + tbInfo.GetTableName + ' (');
        for i := 0 to High(linkArr)-1 do
          SQL.Add(CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
        SQL.Add(CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC));
        SQL.Add(') values (');
        for i := 0 to High(linkArr)-1 do
          SQL.Add(':' + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + ')');
      //  Prepare;

        linkList := TList.Create;
        for i := 0 to High(linkArr) do
        begin
          linkList.Add(srvQry.ParamByName(CreateFld(tbInfo.pfx, linkArr[i].fldPC)));
          try
            linkList.Add(HostQry.FieldByName(linkArr[i].fldAS))
          except
            linkList.Add(nil);
            Continue;
          end;
        end;


        RecNumber := 0;
        while not HostQry.EOF do
        begin
          // assign the fields
          parm  := 0;
          field := 1;

          for i := 0 to High(linkArr) do
          begin
            case linkArr[i].fldType of

              TLD_string   :  begin
                                try
                                  if linkList[field] = nil then
                                    Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := ''
                                  else
                                    Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := Trim(TField(linkList[field]).AsString);
                                except
                                  Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).Value := '';
                                end;
                              end;


              TLD_integer  : begin
                               if linkList[field] = nil then
                                 Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value  := 0
                               else
                                 Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value  := TField(linkList[field]).AsInteger;
                             end;

              TLD_float    : Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value    := TField(linkList[field]).AsFloat;
              TLD_date     : begin
                               if (DateTimeFormat = Frm_As400) then
                                 Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value := TruncToDayDate(TimDateToDateTime(TField(linkList[field]).AsFloat))
                               else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
                                 Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value := TField(linkList[field]).AsFloat;
                             end;
              TLD_dateTime : begin
                               if (DateTimeFormat = Frm_As400) then
                                 Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value := TimDateTimeToDateTime(TField(linkList[field]).AsFloat)
                               else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
                                 Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value := TField(linkList[field]).AsDateTime;
                             end;
              TLD_calConv  :
                begin
                  fldF := TField(linkList[field]).AsFloat;
                  fldI := Trunc(TField(linkList[field]).AsFloat/100);
                  Params.ParamByName(CreateFld(tbInfo.pfx, linkArr[I].fldPC)).value := fldI*60 + Trunc(fldF-fldI*100)
                end
            end;
            parm  := parm  + 2;
            field := field + 2
          end;

          srvQry.ExecSql;
          HostQry.Next;
          if (RecNumber mod 500 = 0) then Application.ProcessMessages;

          inc(RecNumber);
          if (RecNumber mod 100) = 0 then
            UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName + ' ' + intToStr(RecNumber));
        end;

        linkList.Free;
        HostQry.Close;
      end;

      UpdateOperation(_('Loaded')+ ' ' + tbInfo.ASname);
      Result := true
      except
      on E: Exception do
      begin
      {  sl := TStringList.Create;
        sl.Add('while loading ' + tbInfo.PCname);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        if Assigned(linkList) then linkList.Free; }
        Result := false;
        Raise
      end
    end;

    if List_res.Count > 0 then
    begin
      with srvQry do
      begin
        List_res2 := TList.Create;
        SQL.Clear;
        GeneralSQL := '';
        GeneralSQL := ' Select * from ' + tbInfo.GetTableName;
        SQL.Add(GeneralSQL);
        Open;
        while not srvQry.EOF do
        begin
          New(RESOURCE);
          RESOURCE.RESCODE := FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString;
          List_res2.Add(RESOURCE);
          Next;
        end;

        SQL.Clear;
        SQL.Add('update ' + tbInfo.GetTableName + ' set ');
        SQL.Add(CreateFld(tbInfo.pfx, fli_DisplayText1)         + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_DisplayText1)   + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_DisplayText2)         + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_DisplayText2)   + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_WorkAsOneBatchMachineGroupCode)         + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_WorkAsOneBatchMachineGroupCode)   + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_LineWithinPlant)         + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_LineWithinPlant)   + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_OneBatchMachineGrouptype) + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OneBatchMachineGrouptype));

        SQL.Add('where');
        SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)                  + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc));

        for I := 0 to List_res2.Count - 1 do
        begin
          if SearchInList(List_res, PTRESOURCE(List_res2[I]).RESCODE, PTRESOURCE(List_res2[I]).Tex1, PTRESOURCE(List_res2[I]).Tex2,
                          PTRESOURCE(List_res2[I]).WorkedAsOneBtachMachineCode, PTRESOURCE(List_res2[I]).GroupCodeBy, PTRESOURCE(List_res2[I]).LineWithinPlant) then
          begin
            ParamByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString := PTRESOURCE(List_res2[I]).RESCODE;
            ParamByName(CreateFld(tbInfo.pfx, fli_DisplayText1)).AsString := PTRESOURCE(List_res2[I]).Tex1;
            ParamByName(CreateFld(tbInfo.pfx, fli_DisplayText2)).AsString := PTRESOURCE(List_res2[I]).Tex2;
            ParamByName(CreateFld(tbInfo.pfx, fli_WorkAsOneBatchMachineGroupCode)).AsString := PTRESOURCE(List_res2[I]).WorkedAsOneBtachMachineCode;
            ParamByName(CreateFld(tbInfo.pfx, fli_OneBatchMachineGrouptype)).AsString := PTRESOURCE(List_res2[I]).GroupCodeBy;
            ParamByName(CreateFld(tbInfo.pfx, fli_LineWithinPlant)).AsString := PTRESOURCE(List_res2[I]).LineWithinPlant;

            ExecSQL;
          end;
        end;

        for I := 0 to List_res2.Count - 1 do
          Dispose(PTRESOURCE(List_res2[I]));

        List_res2.Free;
      end;
    end;

    for I := 0 to List_res.Count - 1 do
      Dispose(PTRESOURCE(List_res[I]));

    List_res.Free;

  end

  else
  begin

    //tblName  := tbInfo.GetTableName;

    linkList := nil;

    try

      with HostQry do
      begin
        UpdateOperation(_('Reading') + '  ' + tblArcName + ' ' + (_('from host . . .')));
        SQL.Clear;
        GeneralSQL := '';
        GeneralSQL := ' Select * from ' +  tblArcName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER));
        SQL.Add(GeneralSQL);
        Open
      end;

      with srvQry do
      begin

        // clear the table on the server
        UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
        SQL.Clear;
        SQL.Add('delete from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
        ExecSQL;
        Close;
        Application.ProcessMessages;

        // update the server
        UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);

        SQL.Clear;
        SQL.Add('insert into ' + tbInfo.GetTableName + ' (');
        for i := 0 to High(linkArrPC)-1 do
          SQL.Add(CreateFld(tbInfo.pfx, linkArrPC[i].fldPC) + ',');
        SQL.Add(CreateFld(tbInfo.pfx, linkArrPC[High(linkArrPC)].fldPC));
        SQL.Add(') values (');
        for i := 0 to High(linkArrPC)-1 do
          SQL.Add(':' + CreateFld(tbInfo.pfx, linkArrPC[i].fldPC) + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, linkArrPC[High(linkArrPC)].fldPC) + ')');
       // Prepare;

        linkList := TList.Create;
        for i := 0 to High(linkArrPC) do
        begin
          linkList.Add(srvQry.ParamByName(CreateFld(tbInfo.pfx, linkArrPC[i].fldPC)));
          linkList.Add(HostQry.FieldByName(CreateFld(tbInfo.pfx, linkArrPC[i].fldPC)));
        end;

        RecNumber := 0;
        while not HostQry.EOF do
        begin
          // assign the fields
          parm  := 0;
          field := 1;

          for i := 0 to High(linkArrPC) do
          begin
            case linkArrPC[i].fldType of
              TLD_string   : ParamByName(CreateFld(tbInfo.pfx, linkArrPC[I].fldPC)).AsString   := Trim(TField(linkList[field]).AsString);
              TLD_integer  : ParamByName(CreateFld(tbInfo.pfx, linkArrPC[I].fldPC)).AsInteger  := TField(linkList[field]).AsInteger;
              TLD_float    : ParamByName(CreateFld(tbInfo.pfx, linkArrPC[I].fldPC)).AsFloat    := TField(linkList[field]).AsFloat;
              TLD_date     : begin
                               ParamByName(CreateFld(tbInfo.pfx, linkArrPC[I].fldPC)).AsDate := TField(linkList[field]).AsFloat;
                             end;
              TLD_dateTime : begin
                               if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
                                 ParamByName(CreateFld(tbInfo.pfx, linkArrPC[I].fldPC)).AsDateTime := TField(linkList[field]).AsDateTime;
                             end;
              TLD_calConv  :
                begin
                  fldF := TField(linkList[field]).AsFloat;
                  fldI := Trunc(TField(linkList[field]).AsFloat/100);
                  ParamByName(CreateFld(tbInfo.pfx, linkArrPC[I].fldPC)).AsInteger := fldI*60 + Trunc(fldF-fldI*100)
                end
            end;
            parm  := parm  + 2;
            field := field + 2
          end;

          srvQry.ExecSql;
          HostQry.Next;
          if (RecNumber mod 500 = 0) then Application.ProcessMessages;

          inc(RecNumber);
          if (RecNumber mod 100) = 0 then
            UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName + ' ' + intToStr(RecNumber));
        end;

        linkList.Free;
        HostQry.Close;
      end;

      UpdateOperation(_('Loaded')+ ' ' + tblArcName);
      Result := true


      except
      on E: Exception do
      begin
     {   sl := TStringList.Create;
        sl.Add('while loading ' + tbInfo.PCname);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        if Assigned(linkList) then linkList.Free;  }
        Result := false;
        raise
      end
    end

  end;


end;

//----------------------------------------------------------------------------//

function LoadAlternativeWC(tbl: table; srvQry: TMqmQuery;
                           HostQry: TMqmQuery): boolean;
const
  fldList: array [0..4] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;     fldAS: 'FCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;       fldAS: 'FCDMAP'; fldType: TLD_string),
    (fldPC: fli_AlterWC;       fldAS: 'FCDMCR'; fldType: TLD_string),
    (fldPC: fli_AlterWCProces; fldAS: 'FCDMPR'; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;    fldAS: '';       fldType: TLD_Integer)
  );
begin
  Assert(tbl = tbl_wkc_alt);
  Result := LoadTable(tbl, AS400Speclib, ' where FANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadaltWarehouse(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  DndArchiveHostName : TDndArchiveName;
const
  fldList: array [0..5] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;     fldAS: ''; fldType: TLD_string),
    (fldPC: fli_AlterWC;       fldAS: ''; fldType: TLD_string),
    (fldPC: fli_netGroupCode;  fldAS: ''; fldType: TLD_string),
    (fldPC: fli_IssueItemType; fldAS: ''; fldType: TLD_string),
    (fldPC: fli_AWHAltern_Net_Group_Code;  fldAS: ''; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;    fldAS: ''; fldType: TLD_Integer)
  );
begin
  DndArchiveHostName := GetDndArchiveHostName;
  if DndArchiveHostName = TD_AS_400 then
  begin
    Result := true;
    Exit
  end;
  Assert(tbl = tbl_alt_warehouse);
  Result := LoadTable(tbl, AS400Speclib, ' where FANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadArticleType(tbl: table; srvQry: TMqmQuery;
                         HostQry: TMqmQuery): boolean;
var
  tbInfo:         ^TTblInfo;
  tblName, tblArcName: string;
  str:     string;
  DndArchiveHostName, DndArchiveArcName : TDndArchiveName;
begin
  Assert(tbl = tbl_arty);

  tbInfo := @tblInfo[tbl_arty];

  DndArchiveHostName := GetDndArchiveHostName;
  DndArchiveArcName := GetDndArchiveLocalName;

  tblArcName := tbInfo.PCname;
  if DndArchiveArcName <> TD_Interbase then
    tblArcName  := 'SCDA_' + tbInfo.PCname;

  if DndArchiveHostName = TD_AS_400 then
    tblName := AS400Speclib + tbInfo.ASname
  else
    tblName := tbInfo.GetTableName;

  with HostQry do
  begin
    if DndArchiveHostName = TD_AS_400 then
    begin
      UpdateOperation(_('Reading') + '  ' + tblName + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblName + ' where TABLE=''ARTY'' and ANNUL' + CAnnulFilter);
    end
    else
    begin
      UpdateOperation(_('Reading') + '  ' + tblArcName + '  ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblArcName);
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    end;

    open;

  end;

  with srvQry do
  begin
    UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    ExecSQL;
    Close;

    UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    SQL.Add(CreateFld(tbInfo.pfx,  fli_ArtType)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx,  fli_SDescr)   + ',');
    SQL.Add(CreateFld(tbInfo.pfx,  fli_LDescr)    + ',');
    SQL.Add(CreateFld(tbInfo.pfx,  fli_BalanceDecNum) + ',');
    SQL.Add(CreateFld(tbInfo.pfx,  fli_IDENTIFIER));
    SQL.Add(') values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ArtType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SDescr)  + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_LDescr)  + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BalanceDecNum) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    SQL.Add(')');

    while not HostQry.EOF do
    begin
      if DndArchiveHostName = TD_AS_400 then
      begin
        str := HostQry.Fields[3].AsString;
        ParamByName(CreateFld(tbInfo.pfx, fli_ArtType)).AsString := trim(HostQry.Fields[2].AsString); // article type
        ParamByName(CreateFld(tbInfo.pfx, fli_SDescr)).AsString  := Copy(str,  1, 14);        // short description
        ParamByName(CreateFld(tbInfo.pfx, fli_LDescr)).AsString  := Copy(str, 15, 30);        // long description
        ParamByName(CreateFld(tbInfo.pfx, fli_BalanceDecNum)).AsInteger := 2;
        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger  := StrToInt(IniAppGlobals.Identifier);
      end
      else
      begin
        ParamByName(CreateFld(tbInfo.pfx, fli_ArtType)).AsString := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_ArtType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_SDescr)).AsString  := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_SDescr)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_LDescr)).AsString  := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_LDescr)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_BalanceDecNum)).AsInteger := HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_BalanceDecNum)).AsInteger;
        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger  := StrToInt(IniAppGlobals.Identifier);
      end;

      srvQry.ExecSql;
      HostQry.Next;
      Application.ProcessMessages;
    end;
    HostQry.Close
  end;

  if DndArchiveHostName = TD_AS_400 then
    UpdateOperation(_('Loaded')+ ' ' + tbInfo.ASname)
  else
    UpdateOperation(_('Loaded')+ ' ' + tbInfo.GetTableName);

  Result := true
end;

//----------------------------------------------------------------------------//

function LoadCalendar(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..10] of TQryLinkRec = (
    (fldPC: fli_CalCod;      fldAS: 'KCDCAL'; fldType: TLD_string),
    (fldPC: fli_CalDate;     fldAS: 'KCALDT'; fldType: TLD_date),
    (fldPC: fli_Prog_Wrk_Hr; fldAS: 'KPRGWH'; fldType: TLD_float),
    (fldPC: fli_SH1_start;   fldAS: 'KINZT1'; fldType: TLD_calConv),
    (fldPC: fli_SH1_end;     fldAS: 'KFINT1'; fldType: TLD_calConv),
    (fldPC: fli_SH2_start;   fldAS: 'KINZT2'; fldType: TLD_calConv),
    (fldPC: fli_SH2_end;     fldAS: 'KFINT2'; fldType: TLD_calConv),
    (fldPC: fli_SH3_start;   fldAS: 'KINZT3'; fldType: TLD_calConv),
    (fldPC: fli_SH3_end;     fldAS: 'KFINT3'; fldType: TLD_calConv),
    (fldPC: fli_SH4_start;   fldAS: 'KINZT4'; fldType: TLD_calConv),
    (fldPC: fli_SH4_end;     fldAS: 'KFINT4'; fldType: TLD_calConv)
  );
begin
  Assert(tbl = tbl_calendar);

// limited calendar handling
//  dtIni := FloatToStr(DateTimeToTimDate(trunc(Now - 90)));
//  dtFin := FloatToStr(DateTimeToTimDate(trunc(Now + 720)));
//                      'where KANNUL' + CAnnulFilter + ' and KCALDT > ' +
//                      dtIni + ' and KCALDT < ' + dtFin,

  Result := LoadTable(tbl, AS400Speclib,
                      ' where KANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadCategory(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  tbInfo:         ^TTblInfo;
  tblName, tblArcName: string;
  str:     string;
  DndArchiveHostName, DndArchiveArcName : TDndArchiveName;
begin
  Assert(tbl = tbl_resCat);

  tbInfo := @tblInfo[tbl_resCat];

  DndArchiveHostName := GetDndArchiveHostName;
  DndArchiveArcName := GetDndArchiveLocalName;

  tblArcName := tbInfo.PCname;
  if DndArchiveArcName <> TD_Interbase then
    tblArcName  := 'SCDA_' + tbInfo.PCname;

  if DndArchiveHostName = TD_AS_400 then
    tblName := AS400Speclib + tbInfo.ASname
  else
    tblName := tbInfo.GetTableName;

  with HostQry do
  begin
    if DndArchiveHostName = TD_AS_400 then
    begin
      UpdateOperation(_('Reading') + '  ' + tblName + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblName + ' where TABLE=''CATR'' and ANNUL' + CAnnulFilter);
    end
    else
    begin
      UpdateOperation(_('Reading') + '  ' + tblArcName + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblArcName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    end;
    Open;
  end;

  with srvQry do
  begin
    UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    ExecSQL;
    Close;

    UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_RscCat) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CategorySDesc)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CategoryLDesc)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_AdditionalCapacity)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)  + ')');
    SQL.Add(' values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RscCat) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CategorySDesc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CategoryLDesc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_AdditionalCapacity) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    SQL.Add(')');
//    Prepare;

    while not HostQry.EOF do
    begin
      if DndArchiveHostName = TD_AS_400 then
      begin
        str := HostQry.Fields[3].AsString;
        ParamByName(CreateFld(tbInfo.pfx, fli_RscCat)).AsString        := trim(HostQry.Fields[2].AsString); //property code
        ParamByName(CreateFld(tbInfo.pfx, fli_CategorySDesc)).AsString := Copy(str,  1, 14); // property short description
        ParamByName(CreateFld(tbInfo.pfx, fli_CategoryLDesc)).AsString := Copy(str, 15, 30); // property Long description
        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger  := StrToInt(IniAppGlobals.Identifier);
      end
      else
      begin
        ParamByName(CreateFld(tbInfo.pfx, fli_RscCat)).AsString := HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RscCat)).AsString;
        ParamByName(CreateFld(tbInfo.pfx, fli_CategorySDesc)).AsString := HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_CategorySDesc)).AsString;
        ParamByName(CreateFld(tbInfo.pfx, fli_CategoryLDesc)).AsString := HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_CategoryLDesc)).AsString;
        ParamByName(CreateFld(tbInfo.pfx, fli_AdditionalCapacity)).AsString := HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_AdditionalCapacity)).AsString;
        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger   := HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger;
      end;
      srvQry.ExecSql;
      HostQry.Next;
      Application.ProcessMessages;
    end;
    HostQry.Close
  end;

  if DndArchiveHostName = TD_AS_400 then
    UpdateOperation(_('Loaded')+ ' ' + tbInfo.ASname)
  else
    UpdateOperation(_('Loaded')+ ' ' + tbInfo.GetTableName);

  Result := true
end;

//----------------------------------------------------------------------------//

function LoadCapacityProp(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..4] of TQryLinkRec = (
    (fldPC: fli_CapacyResrv;  fldAS: 'WCAPNM'; fldType: TLD_integer),
    (fldPC: fli_PropertyCode; fldAS: 'WCDPPT'; fldType: TLD_string),
    (fldPC: fli_PropValue;    fldAS: 'WPPTVL'; fldType: TLD_string),
    (fldPC: fli_usrCg;        fldAS: 'WUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;      fldAS: 'WDTOCH'; fldType: TLD_dateTime)
  );
begin
  Assert(tbl = tbl_prop_capRes);
  Result := LoadTable(tbl, AS400Speclib, ' where WANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadCapacityReserv(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
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
begin
  Assert(tbl = tbl_capRes);
  Result := LoadTable(tbl, AS400Speclib, ' where UANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadForcedSched(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..26] of TQryLinkRec = (
    (fldPC: fli_preqNo;                  fldAS: 'TPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;                 fldAS: 'TPRSTP'; fldType: TLD_integer),
    (fldPC: fli_psubstId;                fldAS: 'TPRSST'; fldType: TLD_integer),
    (fldPC: fli_reprocNo;                fldAS: 'TRPRNB'; fldType: TLD_integer),
    (fldPC: fli_stGroup;                 fldAS: 'TSTPGR'; fldType: TLD_integer),
    (fldPC: fli_StepIsGrouped;           fldAS: 'TFLGRP'; fldType: TLD_string),
    (fldPC: fli_schedType;               fldAS: 'TSCHTP'; fldType: TLD_string),
    (fldPC: fli_wkCtrCode;               fldAS: 'TCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;                 fldAS: 'TCDMAP'; fldType: TLD_string),
    (fldPC: fli_rsc;                     fldAS: 'TPRRSC'; fldType: TLD_string),
    (fldPC: fli_subLinRscId;             fldAS: 'TRSCSL'; fldType: TLD_integer),
    (fldPC: fli_NumSubRscComponents;     fldAS: 'TNRRSC'; fldType: TLD_integer),
    (fldPC: fli_quant;                   fldAS: 'TSCHQT'; fldType: TLD_float),
    (fldPC: fli_supMin;                  fldAS: 'TSETTM'; fldType: TLD_float),
    (fldPC: fli_exeMin;                  fldAS: 'TEXCTM'; fldType: TLD_float),
    (fldPC: fli_schedStart;              fldAS: 'TSTSDT'; fldType: TLD_dateTime),
    (fldPC: fli_schedEnd;                fldAS: 'TENSDT'; fldType: TLD_dateTime),
    (fldPC: fli_Comment;                 fldAS: 'TCOMMN'; fldType: TLD_string),
    (fldPC: fli_ConnForwardSubStep;      fldAS: 'TFWSST'; fldType: TLD_integer),
    (fldPC: fli_ConnForwardReProcess;    fldAS: 'TFWRNB'; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardSubStep;     fldAS: 'TBCSST'; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardReProcess;   fldAS: 'TBCRNB'; fldType: TLD_integer),
    (fldPC: fli_SaveAtLeastOnesAsFinnal; fldAS: 'TSVFIN'; fldType: TLD_string),
    (fldPC: fli_usrCr;                   fldAS: 'TUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;                 fldAS: 'TDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;                   fldAS: 'TUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                 fldAS: 'TDTOCH'; fldType: TLD_dateTime)
  );
begin
  Assert(tbl = tbl_prod_schedForce);
  Result := LoadTable(tbl, AS400Speclib, ' where TANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry);
end;

//----------------------------------------------------------------------------//

function LoadHeadRscSplit(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..10] of TQryLinkRec = (
    (fldPC: fli_rsc;                 fldAS: 'RCDRSC'; fldType: TLD_string),
    (fldPC: fli_SubRsc;              fldAS: 'RRSCSL'; fldType: TLD_integer),
    (fldPC: fli_CalCod;              fldAS: 'RCDCAL'; fldType: TLD_string),
    (fldPC: fli_ProdLine;            fldAS: 'RPRDLN'; fldType: TLD_string),
    (fldPC: fli_Comment;             fldAS: 'RCOMME'; fldType: TLD_string),
    (fldPC: fli_NumSubRscComponents; fldAS: 'RNRRSC'; fldType: TLD_integer),
    (fldPC: fli_usrCr;               fldAS: 'RUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;             fldAS: 'RDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;               fldAS: 'RUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;             fldAS: 'RDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;          fldAS: ''; fldType: TLD_integer)
  );
begin
  Assert(tbl = tbl_res_sub);
  Result := LoadTable(tbl, AS400Speclib, ' where RANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadOccOccCompatRule(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..26] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;                 fldAS: 'FCDMAC'; fldType: TLD_string),
    (fldPC: fli_rscCat;                    fldAS: 'FCATRS'; fldType: TLD_string),
    (fldPC: fli_WCProcess;                 fldAS: 'FCDMAP'; fldType: TLD_string),
    (fldPC: fli_Rsc;                       fldAS: 'FCDRSC'; fldType: TLD_string),
    (fldPC: fli_PropertyCode;              fldAS: 'FCDPPT'; fldType: TLD_string),
    (fldPC: fli_ProdType;                  fldAS: 'FRECTY'; fldType: TLD_string),
    (fldPC: fli_PropLineNum;               fldAS: 'FLNNUM'; fldType: TLD_integer),
    (fldPC: fli_Sequence;                  fldAS: 'FCKSEQ'; fldType: TLD_integer),
    (fldPC: fli_DepOnCurr;                 fldAS: 'FFLDPN'; fldType: TLD_string),
    (fldPC: fli_DepValue;                  fldAS: 'FDPNVL'; fldType: TLD_string),
    (fldPC: fli_RuleConst;                 fldAS: 'FVALUE'; fldType: TLD_string),
    (fldPC: fli_PropOperand;               fldAS: 'FOPRND'; fldType: TLD_string),
    (fldPC: fli_PropCase;                  fldAS: 'FCASEX'; fldType: TLD_string),
    (fldPC: fli_PropSetupTyp;              fldAS: 'FSETTP'; fldType: TLD_string),
    (fldPC: fli_PropSetUpTime;             fldAS: 'FSETTM'; fldType: TLD_float),
    (fldPC: fli_PropSetUpOverlappTime;     fldAS: 'FSETOV'; fldType: TLD_float),
    (fldPC: fli_PropSetUpTimeMult;         fldAS: 'FSETML'; fldType: TLD_float),
    (fldPC: fli_PropSetUpOverlappTimeMult; fldAS: 'FSETMO'; fldType: TLD_float),
    (fldPC: fli_CanBeSameGroup;            fldAS: 'FSMGRP'; fldType: TLD_string),
    (fldPC: fli_teoreticl_wc;              fldAS: 'FTPMAC'; fldType: TLD_string),
    (fldPC: fli_duration;                  fldAS: 'FDURAT'; fldType: TLD_float),
    (fldPC: fli_LeadTime;                  fldAS: 'FLEADT'; fldType: TLD_float),
    (fldPC: fli_usrCr;                     fldAS: 'FUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;                   fldAS: 'FDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;                     fldAS: 'FUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                   fldAS: 'FDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;                fldAS: '';       fldType: TLD_Integer)
  );

  fldListPc : array [0..32] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;                 fldAS: 'FCDMAC'; fldType: TLD_string),
    (fldPC: fli_rscCat;                    fldAS: 'FCATRS'; fldType: TLD_string),
    (fldPC: fli_WCProcess;                 fldAS: 'FCDMAP'; fldType: TLD_string),
    (fldPC: fli_Rsc;                       fldAS: 'FCDRSC'; fldType: TLD_string),
    (fldPC: fli_PropertyCode;              fldAS: 'FCDPPT'; fldType: TLD_string),
    (fldPC: fli_ProdType;                  fldAS: 'FRECTY'; fldType: TLD_string),
    (fldPC: fli_PropLineNum;               fldAS: 'FLNNUM'; fldType: TLD_integer),
    (fldPC: fli_Sequence;                  fldAS: 'FCKSEQ'; fldType: TLD_integer),
    (fldPC: fli_DepOnCurr;                 fldAS: 'FFLDPN'; fldType: TLD_string),
    (fldPC: fli_DepValue;                  fldAS: 'FDPNVL'; fldType: TLD_string),
    (fldPC: fli_RuleConst;                 fldAS: 'FVALUE'; fldType: TLD_string),
    (fldPC: fli_PropOperand;               fldAS: 'FOPRND'; fldType: TLD_string),
    (fldPC: fli_PropCase;                  fldAS: 'FCASEX'; fldType: TLD_string),
    (fldPC: fli_PropSetupTyp;              fldAS: 'FSETTP'; fldType: TLD_string),
    (fldPC: fli_PropSetUpTime;             fldAS: 'FSETTM'; fldType: TLD_float),
    (fldPC: fli_PropSetUpOverlappTime;     fldAS: 'FSETOV'; fldType: TLD_float),
    (fldPC: fli_PropSetUpTimeMult;         fldAS: 'FSETML'; fldType: TLD_float),
    (fldPC: fli_PropSetUpOverlappTimeMult; fldAS: 'FSETMO'; fldType: TLD_float),
    (fldPC: fli_CanBeSameGroup;            fldAS: 'FSMGRP'; fldType: TLD_string),
    (fldPC: fli_teoreticl_wc;              fldAS: '';       fldType: TLD_string),
    (fldPC: fli_duration;                  fldAS: '';       fldType: TLD_float),
    (fldPC: fli_LeadTime;                  fldAS: '';       fldType: TLD_float),
    (fldPC: fli_RuleOccFrom;               fldAS: '';       fldType: TLD_integer),
    (fldPC: fli_RuleOccLength;             fldAS: '';       fldType: TLD_integer),
    (fldPC: fli_RuleOccForPartialPropVal;  fldAS: '';       fldType: TLD_string),
    (fldPC: fli_WhenOkNextSeq;             fldAS: '';       fldType: TLD_integer),
    (fldPC: fli_DecNum;                    fldAS: '';       fldType: TLD_integer),
    (fldPC: fli_LearningCurveCode;         fldAS: '';       fldType: TLD_string),
    (fldPC: fli_usrCr;                     fldAS: 'FUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;                   fldAS: 'FDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;                     fldAS: 'FUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                   fldAS: 'FDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;                fldAS: '';       fldType: TLD_Integer)
  );

var
  DndArchiveHostName : TDndArchiveName;
begin
  DndArchiveHostName := GetDndArchiveHostName;
  if DndArchiveHostName <> TD_AS_400 then
  begin
    Assert(tbl = tbl_ruleOccToOcc);
    Result := LoadTable(tbl, AS400Speclib, ' where FANNUL' + CAnnulFilter,
                      fldListPc, srvQry, HostQry)
  end
  else
  begin
    Assert(tbl = tbl_ruleOccToOcc);
    Result := LoadTable(tbl, AS400Speclib, ' where FANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end;

end;

//----------------------------------------------------------------------------//

function LoadGroupByPropertyRule(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..10] of TQryLinkRec = (
    (fldPC: fli_CodeRuleForGrouping;     fldAS: ''; fldType: TLD_string),
    (fldPC: fli_SDescr;                  fldAS: ''; fldType: TLD_string),
    (fldPC: fli_PropertyCode1;           fldAS: ''; fldType: TLD_string),
    (fldPC: fli_PropertyCode2;           fldAS: ''; fldType: TLD_string),
    (fldPC: fli_PropertyCode3;           fldAS: ''; fldType: TLD_string),
    (fldPC: fli_PropertyCode4;           fldAS: ''; fldType: TLD_string),
    (fldPC: fli_PropertyCode5;           fldAS: ''; fldType: TLD_string),
    (fldPC: fli_PropertyCode6;           fldAS: ''; fldType: TLD_string),
    (fldPC: fli_PropertyCode7;           fldAS: ''; fldType: TLD_string),
    (fldPC: fli_PropertyCode8;           fldAS: ''; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;              fldAS: ''; fldType: TLD_integer)
  );
var
  DndArchiveHostName : TDndArchiveName;
begin
  Assert(tbl = tbl_GroupByPropertyRules);

  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName <> TD_AS_400 then
  begin
    Result := LoadTable(tbl, AS400Speclib, ' where AANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end;

end;

//Eran said that this table is not needed
{
function LoadOverlappingQuantities(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..10] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;         fldAS: 'YCDMAC'; fldType: TLD_string),
    (fldPC: fli_RscCat;            fldAS: 'YCATRS'; fldType: TLD_string),
    (fldPC: fli_WCProcess;         fldAS: 'YCDMAP'; fldType: TLD_string),
    (fldPC: fli_Rsc;               fldAS: 'YCDRSC'; fldType: TLD_string),
    (fldPC: fli_um;                fldAS: 'YPRDUM'; fldType: TLD_string),
    (fldPC: fli_MinQtyPassNextStp; fldAS: 'YMQTNS'; fldType: TLD_float),
    (fldPC: fli_MinQtyToStart;     fldAS: 'YMINQT'; fldType: TLD_float),
    (fldPC: fli_usrCr;             fldAS: 'YUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;           fldAS: 'YDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;             fldAS: 'YUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;           fldAS: 'YDTOCH'; fldType: TLD_dateTime)
  );

begin
  Assert(tbl = tbl_overlap_qty);
  Result := LoadTable(tbl, AS400Speclib, 'where YANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadNonWorkingHour(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..8] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;           fldAS: 'RCDMAC'; fldType: TLD_string),
    (fldPC: fli_RscCat;              fldAS: 'RCATRS'; fldType: TLD_string),
    (fldPC: fli_WCProcess;           fldAS: 'RCDMAP'; fldType: TLD_string),
    (fldPC: fli_Rsc;                 fldAS: 'RCDRSC'; fldType: TLD_string),
    (fldPC: fli_CanOverlapNonWrkingHours;    fldAS: 'ROVNWH'; fldType: TLD_string),
    (fldPC: fli_usrCr;               fldAS: 'RUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;             fldAS: 'RDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;               fldAS: 'RUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;             fldAS: 'RDTOCH'; fldType: TLD_dateTime)
  );

begin
  Assert(tbl = tbl_nonWorking);
  Result := LoadTable(tbl, AS400Speclib, 'where RANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadOverlappingRules(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..11] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;           fldAS: 'RCDMAC'; fldType: TLD_string),
    (fldPC: fli_RscCat;              fldAS: 'RCATRS'; fldType: TLD_string),
    (fldPC: fli_WCProcess;           fldAS: 'RCDMAP'; fldType: TLD_string),
    (fldPC: fli_Rsc;                 fldAS: 'RCDRSC'; fldType: TLD_string),
    (fldPC: fli_MinutAddAftrStp;     fldAS: 'RMNAST'; fldType: TLD_integer),
    (fldPC: fli_MaxMinutBfrNxtStp;   fldAS: 'RMNBST'; fldType: TLD_integer),
    (fldPC: fli_StepCanBeOverlapped; fldAS: 'ROVLPD'; fldType: TLD_string),
    (fldPC: fli_CanStepOverlap;      fldAS: 'ROVERL'; fldType: TLD_string),
    (fldPC: fli_usrCr;               fldAS: 'RUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;             fldAS: 'RDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;               fldAS: 'RUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;             fldAS: 'RDTOCH'; fldType: TLD_dateTime)
  );

begin
  Assert(tbl = tbl_overlap_rules);
  Result := LoadTable(tbl, AS400Speclib, 'where RANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;
}
//----------------------------------------------------------------------------//

function LoadProdLineCntr(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..4] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode; fldAS: 'NCDMAC'; fldType: TLD_string),
    (fldPC: fli_ProdLine;  fldAS: 'NPRDLN'; fldType: TLD_string),
    (fldPC: fli_DateBegin; fldAS: 'NDTBEG'; fldType: TLD_date),
    (fldPC: fli_DateEnd;   fldAS: 'NDTEND'; fldType: TLD_date),
    (fldPC: fli_NumResPlan;  fldAS: 'NNUMAC'; fldType: TLD_float)
  );

begin
  Assert(tbl = tbl_wkc_prodLine);
  Result := LoadTable(tbl, AS400Speclib, ' where NANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadprodSched(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
type
  RecordPS = record
    ReqNo : string;
    Step:   Integer;
    SubStep: Integer;
    ReprocesNo: Integer;
  end;
  PRecordPS = ^RecordPS;
//var
//  tbInfo:    ^TTblInfo;
const
  fldList: array [0..35] of TQryLinkRec = (
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
    (fldPC: fli_usrCg;                    fldAS: 'TUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'TDTOCR'; fldType: TLD_DateTime),
    (fldPC: fli_usrCg;                    fldAS: 'TUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'TDTOCH'; fldType: TLD_DateTime)
  );

begin
  Assert(tbl = tbl_prod_sched);
//  tbInfo := @tblInfo[tbl];
//  OldASName := tbInfo.ASname;
//  tbInfo.ASname := 'MQMPS20F';
  Result := LoadTable(tbl, AS400Speclib, ' where TANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry);
//  tbInfo.ASname := OldASName;
end;

//----------------------------------------------------------------------------//

function LoadProperty(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  tbInfo:         ^TTblInfo;
  tblName: string;
  str:     string;
  RStr : string;
  FlagsFromRight, FlagsFromLeft, ShortDesc, LongDesc : string;
  DndArchiveHostName : TDndArchiveName;
begin
  Assert(tbl = tbl_prop);

  tbInfo := @tblInfo[tbl_prop];

  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName = TD_AS_400 then
    tblName := AS400Speclib + tbInfo.ASname
  else
    tblName := ' SCDA_' + tbInfo.PCname;

  with HostQry do
  begin
    if DndArchiveHostName = TD_AS_400 then
    begin
      UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblName + ' where TABLE=''MQPR'' and ANNUL' + CAnnulFilter);
    end
    else
    begin
      UpdateOperation(_('Reading') + '  ' + tblName + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblName);
    end;
    Open;
  end;

  with srvQry do
  begin
    UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName);
    ExecSQL;
    Close;

    UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropSDesc) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropLDesc) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropType) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropLen) + ',');
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
    SQL.Add(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_MQMRelevance) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_MCMRelevance) + ')');
    SQL.Add(' values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropertyCode) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropSDesc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropLDesc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropLen) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_DecNum) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RP_MainLevel) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RO_CompatChekType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RO_MainLevel) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RO_Add_ProdType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OO_CompatChekType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OO_MainLevel) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OO_Add_ProdType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MQMRelevance) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MCMRelevance));
    SQL.Add(')');
    Prepare;

    while not HostQry.EOF do
    begin
      if DndArchiveHostName = TD_AS_400 then
      begin
        str := HostQry.Fields[3].AsString;
        RStr := '                                            ';
        RStr := RStr + RightStr(str,67);

        FlagsFromRight := RightStr(str,67);
        FlagsFromLeft := Copy(str,  45, 67);

        if FlagsFromRight = FlagsFromLeft then
        begin
          ShortDesc := Copy(str,  1, 14);
          LongDesc := Copy(str, 15, 30);
        end else
        begin
          ShortDesc := Copy(str,  1, 12);
          LongDesc := Copy(str, 13, 28);
        end;

        ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString      := trim(HostQry.Fields[2].AsString); //property code
        ParamByName(CreateFld(tbInfo.pfx, fli_PropSDesc)).AsString         := ShortDesc; // property short description
        ParamByName(CreateFld(tbInfo.pfx, fli_PropLDesc)).AsString         := LongDesc; // property Long description
        ParamByName(CreateFld(tbInfo.pfx, fli_PropType)).AsString          := Copy(Rstr, 45,  1); // property type
        ParamByName(CreateFld(tbInfo.pfx, fli_PropLen)).AsString           := Copy(Rstr, 46,  2); // property length
        ParamByName(CreateFld(tbInfo.pfx, fli_DecNum)).AsString            := Copy(Rstr, 48,  1); // no. of decimals
        ParamByName(CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched)).AsString  := Copy(Rstr, 49,  1); // change prop valuecauses resched
        ParamByName(CreateFld(tbInfo.pfx, fli_RP_MainLevel)).AsString      := Copy(Rstr, 50,  1); // RP_LvlConnc_WC
        ParamByName(CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc)).AsString    := Copy(Rstr, 51,  1); // RP_LvlConnc_Rsc
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_MainLevel)).AsString      := Copy(Rstr, 52,  1); // RO_LvlConnc_WC
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc)).AsString    := Copy(Rstr, 53,  1); // RO_LvlConnc_Rsc
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType)).AsString   := Copy(Rstr, 54,  1); // RO_LvlConnc_ProdType
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_CompatChekType)).AsString := Copy(Rstr, 55,  1); // RP_LvConncCmptlChk
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_MainLevel)).AsString      := Copy(Rstr, 56,  1); // OO_LvlConnc_WC
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc)).AsString    := Copy(Rstr, 57,  1); // OO_LvlConnc_Rsc
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType)).AsString   := Copy(Rstr, 58,  1); // OO_LvlConnc_ProdType
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_CompatChekType)).AsString := Copy(Rstr, 59,  1); // RO_LvConncCmptlChk
//        if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') then
//        begin
          ParamByName(CreateFld(tbInfo.pfx, fli_MQMRelevance)).AsString      := Copy(Rstr, 60,  1); // fli_MQMRelevance
          ParamByName(CreateFld(tbInfo.pfx, fli_MCMRelevance)).AsString      := Copy(Rstr, 61,  1); // fli_MCMRelevance
//        end;
      end
      else
      begin
        ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropSDesc)).AsString         := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropSDesc)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropLDesc)).AsString         := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropLDesc)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropType)).AsString          := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropLen)).AsString           := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropLen)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_DecNum)).AsString            := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_DecNum)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched)).AsString := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RP_MainLevel)).AsString      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RP_MainLevel)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc)).AsString    := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_MainLevel)).AsString      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RO_MainLevel)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc)).AsString    := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType)).AsString   := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_CompatChekType)).AsString := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RO_CompatChekType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_MainLevel)).AsString      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_OO_MainLevel)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc)).AsString    := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType)).AsString   := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_CompatChekType)).AsString := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_OO_CompatChekType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_MQMRelevance)).AsString      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_MQMRelevance)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_MCMRelevance)).AsString      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_MCMRelevance)).AsString);
      end;
      srvQry.ExecSql;
      HostQry.Next;
      Application.ProcessMessages;
    end;
    HostQry.Close
  end;

  UpdateOperation(_('Loaded') + ' ' + tbInfo.GetTableName);
  Result := true
end;

//----------------------------------------------------------------------------//

function LoadPropertyOld(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  tbInfo:         ^TTblInfo;
  tblName, tblArcName: string;
  str:     string;
  DndArchiveHostName, DndArchiveArcName : TDndArchiveName;
begin
  Assert(tbl = tbl_prop);

  tbInfo := @tblInfo[tbl_prop];

  DndArchiveHostName := GetDndArchiveHostName;
  DndArchiveArcName := GetDndArchiveLocalName;

  tblArcName := tbInfo.PCname;
  if DndArchiveArcName <> TD_Interbase then
    tblArcName  := 'SCDA_' + tbInfo.PCname;

  if DndArchiveHostName = TD_AS_400 then
    tblName := AS400Speclib + tbInfo.ASname
  else
    tblName := tbInfo.GetTableName;

  with HostQry do
  begin
    if DndArchiveHostName = TD_AS_400 then
    begin
      UpdateOperation(_('Reading') + '  ' + tblName + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblName + ' where TABLE=''MQPR'' and ANNUL' + CAnnulFilter);
    end
    else
    begin
      UpdateOperation(_('Reading') + '  ' + tblArcName + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblArcName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    end;
    Open;
  end;

  try

  with srvQry do
  begin
    UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    ExecSQL;
    Close;

    UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropSDesc) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropLDesc) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropType) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropIsdate) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropLen) + ',');
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
    SQL.Add(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_MQMRelevance)    + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_MCMRelevance)    + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropInstanceCounter) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropValueInstanceCounter) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ')');
    SQL.Add(' values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropertyCode) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropSDesc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropLDesc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropIsdate) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropLen) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_DecNum) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RP_MainLevel) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RO_CompatChekType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RO_MainLevel) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RO_Add_ProdType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OO_CompatChekType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OO_MainLevel) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OO_Add_ProdType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MQMRelevance) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MCMRelevance) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropInstanceCounter) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropValueInstanceCounter) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    SQL.Add(')');
//    Prepare;

    while not HostQry.EOF do
    begin
      if DndArchiveHostName = TD_AS_400 then
      begin
        str := HostQry.Fields[3].AsString;
        ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).Value      := trim(HostQry.Fields[2].AsString); //property code
        ParamByName(CreateFld(tbInfo.pfx, fli_PropSDesc)).Value         := Copy(str,  1, 14); // property short description
        ParamByName(CreateFld(tbInfo.pfx, fli_PropLDesc)).Value         := Copy(str, 15, 30); // property Long description
        ParamByName(CreateFld(tbInfo.pfx, fli_PropType)).Value          := Copy(str, 45,  1); // property type
        ParamByName(CreateFld(tbInfo.pfx, fli_PropLen)).Value           := Copy(str, 46,  2); // property length
        ParamByName(CreateFld(tbInfo.pfx, fli_DecNum)).Value            := Copy(str, 48,  1); // no. of decimals
        ParamByName(CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched)).Value  := Copy(str, 49,  1); // change prop valuecauses resched
        ParamByName(CreateFld(tbInfo.pfx, fli_RP_MainLevel)).Value      := Copy(str, 50,  1); // RP_LvlConnc_WC
        ParamByName(CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc)).Value    := Copy(str, 51,  1); // RP_LvlConnc_Rsc
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_MainLevel)).Value      := Copy(str, 52,  1); // RO_LvlConnc_WC
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc)).Value    := Copy(str, 53,  1); // RO_LvlConnc_Rsc
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType)).Value   := Copy(str, 54,  1); // RO_LvlConnc_ProdType
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_CompatChekType)).Value := Copy(str, 55,  1); // RP_LvConncCmptlChk
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_MainLevel)).Value      := Copy(str, 56,  1); // OO_LvlConnc_WC
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc)).Value    := Copy(str, 57,  1); // OO_LvlConnc_Rsc
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType)).Value   := Copy(str, 58,  1); // OO_LvlConnc_ProdType
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_CompatChekType)).Value := Copy(str, 59,  1); // RO_LvConncCmptlChk
        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).Value := IniAppGlobals.Identifier;
        //if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') then
        try
        begin
          ParamByName(CreateFld(tbInfo.pfx, fli_MQMRelevance)).Value      := Copy(str, 60,  1); // fli_MQMRelevance
          ParamByName(CreateFld(tbInfo.pfx, fli_MCMRelevance)).Value      := Copy(str, 61,  1); // fli_MCMRelevance
        end;
        Except
        end;

        try
        begin
          ParamByName(CreateFld(tbInfo.pfx, fli_PropInstanceCounter)).Value      := '';
          ParamByName(CreateFld(tbInfo.pfx, fli_PropValueInstanceCounter)).Value := '';
        end;
        Except
        end;

      end
      else
      begin
        ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).Value      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropSDesc)).Value         := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropSDesc)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropLDesc)).Value         := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropLDesc)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropType)).Value          := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropIsdate)).Value        := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropIsdate)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropLen)).Value           := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropLen)).AsString);
        if trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_DecNum)).AsString) = '' then
          ParamByName(CreateFld(tbInfo.pfx, fli_DecNum)).Value := '0'
        else
          ParamByName(CreateFld(tbInfo.pfx, fli_DecNum)).Value            := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_DecNum)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched)).Value := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RP_MainLevel)).Value      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RP_MainLevel)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc)).Value    := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_MainLevel)).Value      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RO_MainLevel)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc)).Value    := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType)).Value   := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_RO_CompatChekType)).Value := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_RO_CompatChekType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_MainLevel)).Value      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_OO_MainLevel)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc)).Value    := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType)).Value   := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_OO_CompatChekType)).Value := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_OO_CompatChekType)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_MQMRelevance)).Value      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_MQMRelevance)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_MCMRelevance)).Value      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_MCMRelevance)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropInstanceCounter)).Value      := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropInstanceCounter)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PropValueInstanceCounter)).Value := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropValueInstanceCounter)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).Value := HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger;
      end;
     // try
        srvQry.ExecSql;
     // except
        Application.ProcessMessages;
     // end;
      HostQry.Next;
      Application.ProcessMessages;
    end;
    HostQry.Close
  end;

  except

  on E: Exception do
   begin
     if DndArchiveHostName <> TD_AS_400 then
     begin
       E.Message := E.Message + ' While reading data of propery ' + trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).Value);
     end
     else
     begin
        E.Message := E.Message + ' While reading data of propery ' + trim(HostQry.Fields[2].AsString);
     end;
     raise Exception.CreateFmt(E.Message + tbInfo.GetTableName + ' xxx UMTransfer.LoadFromHost' , [E.Message]);
   end;
  end;
  UpdateOperation(_('Loaded') + ' ' + tblArcName);
  Result := true
end;

//----------------------------------------------------------------------------//

function LoadResources(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..15] of TQryLinkRec = (
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
    (fldPC: fli_Max_bch_size;     fldAS: 'TMAXBZ'; fldType: TLD_float),
    (fldPC: fli_PropOptimumMaxMultiplier;  fldAS: 'TPRBSM'; fldType: TLD_string),
    (fldPC: fli_PropMinMultiplier; fldAS: 'XXXXXX'; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;               fldAS: ''; fldType: TLD_integer)
  );

  fldListPC : array [0..23] of TQryLinkRec = (
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
    (fldPC: fli_Max_bch_size;     fldAS: 'TMAXBZ'; fldType: TLD_float),
    (fldPC: fli_DisplayText1;     fldAS: 'TMINBZ'; fldType: TLD_string),
    (fldPC: fli_DisplayText2;     fldAS: 'TMAXBZ'; fldType: TLD_string),
    (fldPC: fli_WorkAsOneBatchMachineGroupCode; fldAS: ''; fldType: TLD_string),
    (fldPC: fli_Rsc_PLanType;     fldAS: ''; fldType: TLD_string),
    (fldPC: fli_OneBatchMachineGrouptype;     fldAS: ''; fldType: TLD_string),
    (fldPC: fli_LineWithinPlant;     fldAS: ''; fldType: TLD_string),
    (fldPC: fli_PropOptimumMaxMultiplier; fldAS: ''; fldType: TLD_string),
    (fldPC: fli_PropMinMultiplier; fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ForceOutsideLimitQty;     fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ForceOccToResCase99;      fldAS: ''; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;               fldAS: ''; fldType: TLD_integer)
  );

begin
  Assert(tbl = tbl_res);
  Result := LoadResourceTable(tbl, AS400Speclib, ' where TANNUL' + CAnnulFilter,
                      fldList, fldListPC, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//
{//Eran said that this table is not needed
function LoadRscDivision(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..8] of TQryLinkRec = (
    (fldPC: fli_rsc;                 fldAS: 'GCDRSC'; fldType: TLD_string),
    (fldPC: fli_SubRsc;              fldAS: 'GRSCSL'; fldType: TLD_integer),
    (fldPC: fli_DateBegin;           fldAS: 'GFRDTT'; fldType: TLD_dateTime),
    (fldPC: fli_DateEnd;             fldAS: 'GTODTT'; fldType: TLD_dateTime),
    (fldPC: fli_NumOfRsc;            fldAS: 'GNBSRC'; fldType: TLD_integer),
    (fldPC: fli_usrCg;               fldAS: 'GUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;             fldAS: 'GDTOCR'; fldType: TLD_DateTime),
    (fldPC: fli_usrCg;               fldAS: 'GUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;             fldAS: 'GDTOCH'; fldType: TLD_DateTime)
  );
begin
  Assert(tbl = tbl_res_apa);
  Result := LoadTable(tbl, AS400Speclib, 'where GANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;
}
//----------------------------------------------------------------------------//

function LoadRscOccCompatRul(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..16] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;    fldAS: 'ECDMAC'; fldType: TLD_string),
    (fldPC: fli_rscCat;       fldAS: 'ECATRS'; fldType: TLD_string),
    (fldPC: fli_WCProcess;    fldAS: 'ECDMAP'; fldType: TLD_string),
    (fldPC: fli_Rsc;          fldAS: 'ECDRSC'; fldType: TLD_string),
    (fldPC: fli_PropertyCode; fldAS: 'ECDPPT'; fldType: TLD_string),
    (fldPC: fli_ProdType;     fldAS: 'ERECTY'; fldType: TLD_string),
    (fldPC: fli_PropLineNum;  fldAS: 'ELNNUM'; fldType: TLD_integer),
    (fldPC: fli_Sequence;     fldAS: 'ECKSEQ'; fldType: TLD_integer),
    (fldPC: fli_DepOnCurr;    fldAS: 'EREFBS'; fldType: TLD_string),
    (fldPC: fli_DepValue;     fldAS: 'EVALUE'; fldType: TLD_string),
    (fldPC: fli_PropOperand;  fldAS: 'EOPRND'; fldType: TLD_string),
    (fldPC: fli_PropCase;     fldAS: 'ECASEX'; fldType: TLD_string),
    (fldPC: fli_usrCr;        fldAS: 'EUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;      fldAS: 'EDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;        fldAS: 'EUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;      fldAS: 'EDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;   fldAS: '';       fldType: TLD_Integer)
  );

begin
  Assert(tbl = tbl_ruleResToOcc);
  Result := LoadTable(tbl, AS400Speclib, ' where EANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadRscProperty(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..16] of TQryLinkRec = (
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
    (fldPC: fli_usrTmCg;                          fldAS: 'DDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;                       fldAS: '';       fldType: TLD_Integer)
  );
begin
  Assert(tbl = tbl_prop_res);
  Result := LoadTable(tbl, AS400Speclib, ' where DANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadIdentifiers(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..1] of TQryLinkRec = (
    (fldPC: fli_IDENTIFIER;                          fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_SDescr;                              fldAS: ''; fldType: TLD_string)
  );
begin
  Assert(tbl = tbl_Identifiers);
  Result := LoadTable(tbl, AS400Speclib, ' ' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

{function LoadSetUpAddRsc(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..16] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;               fldAS: 'ACDMAC'; fldType: TLD_string),
    (fldPC: fli_rscCat;                  fldAS: 'ACATRS'; fldType: TLD_string),
    (fldPC: fli_WCProcess;               fldAS: 'ACDMAP'; fldType: TLD_string),
    (fldPC: fli_Rsc;                     fldAS: 'ACDRSC'; fldType: TLD_string),
    (fldPC: fli_PropertyCode;            fldAS: 'ACDPPT'; fldType: TLD_string),
    (fldPC: fli_ProdType;                fldAS: 'ARECTY'; fldType: TLD_string),
    (fldPC: fli_PropLineNum;             fldAS: 'ALNNUM'; fldType: TLD_integer),
    (fldPC: fli_AddiRsc;                 fldAS: 'AADRSC'; fldType: TLD_string),
    (fldPC: fli_NumHourBforSetup;        fldAS: 'AHRBFR'; fldType: TLD_integer),
    (fldPC: fli_ValAddAddiRscBeforSetup; fldAS: 'AVLBFR'; fldType: TLD_float),
    (fldPC: fli_ValAddAddiRscWhileSetup; fldAS: 'AVLWHL'; fldType: TLD_float),
    (fldPC: fli_NumHourAfterSetup;       fldAS: 'AHRAFT'; fldType: TLD_integer),
    (fldPC: fli_ValAddAddiRscAfterSetup; fldAS: 'AVLAFT'; fldType: TLD_float),
    (fldPC: fli_usrCr;                   fldAS: 'AUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;                 fldAS: 'ADTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;                   fldAS: 'AUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                 fldAS: 'ADTOCH'; fldType: TLD_dateTime)
  );
begin
  Assert(tbl = tbl_addRes_setup);
  Result := LoadTable(tbl, AS400Speclib, 'where AANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;  }

//----------------------------------------------------------------------------//

function LoadStpProgress(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..11] of TQryLinkRec = (
    (fldPC: fli_preqNo;        fldAS: 'SPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;       fldAS: 'SPRSTP'; fldType: TLD_integer),
    (fldPC: fli_psubstId;      fldAS: 'SPRSST'; fldType: TLD_integer),
    (fldPC: fli_reprocNo;      fldAS: 'SRPRNB'; fldType: TLD_integer),
    (fldPC: fli_ProgressType;  fldAS: 'SLPRTY'; fldType: TLD_string),
    (fldPC: fli_rsc;           fldAS: 'SCDRSC'; fldType: TLD_string),
    (fldPC: fli_ProgressGroup; fldAS: 'SPRGRP'; fldType: TLD_integer),
    (fldPC: fli_progrStart;    fldAS: 'SSTRDT'; fldType: TLD_dateTime),
    (fldPC: fli_prgCurrDate;   fldAS: 'SCURDT'; fldType: TLD_dateTime),
    (fldPC: fli_progrEnd;      fldAS: 'SENDDT'; fldType: TLD_dateTime),
    (fldPC: fli_quant;         fldAS: 'SPRQTY'; fldType: TLD_float),
    (fldPC: fli_prgRemTime;    fldAS: 'SRMNTM'; fldType: TLD_float)
  );
begin
  Assert(tbl = tbl_sched_progress);
  Result := LoadTable(tbl, AS400Speclib, '', fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function SortWS(Item1, Item2: Pointer) : integer;
var
  MQMWS1 : PRecWS;
  MQMWS2 : PRecWS;
begin
  MQMWS1 := PRecWS(Item1);
  MQMWS2 := PRecWS(Item2);
  if (MQMWS1.WS_wkstCode < MQMWS2.WS_wkstCode) then
    Result := -1
  else if (MQMWS1.WS_wkstCode = MQMWS2.WS_wkstCode) then
    Result := 0
  else
    Result := 1
end;

//----------------------------------------------------------------------------//

function Loadwkst(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList : array [0..8] of TQryLinkRec = (
    (fldPC: fli_wkstCode;         fldAS: 'AWRKST'; fldType: TLD_string),
    (fldPC: fli_wkDescr;          fldAS: 'AWRSDS'; fldType: TLD_string),
    (fldPC: fli_wkPasswd;         fldAS: 'AWRSPS'; fldType: TLD_string),
    (fldPC: fli_usrCr;            fldAS: 'AUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;          fldAS: 'ADTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;            fldAS: 'AUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;          fldAS: 'ADTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_WorkStationType;  fldAS: 'AUSETP'; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;       fldAS: '';       fldType: TLD_integer)
  );

var
  OrderBy : string;
  tbInfo:   ^TTblInfo;
  RecWS   : pRecWS;
  ListWS : TList;
  IndexWS  : Integer;
  QryWS, QryDel, QryUpdate : TMqmQuery;
//  srvTrs: TMqmTransaction;
  Tmp_Date1,Tmp_Date2  : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName, LocalHostName : TDndArchiveName;
  ArcQry: TMqmQuery;
begin
  Assert(tbl = tbl_wkst);
  tbInfo := @tblInfo[tbl];
  Result := true;
  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName <> TD_AS_400 then
  begin
    Result := LoadTable(tbl, AS400Speclib, 'where AANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry);
  end

  else if DndArchiveHostName = TD_AS_400 then
  begin

    LocalHostName := GetDndArchiveLocalName;

    DateTimeFormat := GetDateTimeFormat;

    QryWS := ThreadCreateQuery(Main_DB);
    QryWS.Transaction := ThreadCreateTransaction(Main_DB);
    QryWS.Transaction.StartTransaction;

    QryDel := ThreadCreateQuery(Main_DB);
    QryDel.Transaction := ThreadCreateTransaction(Main_DB);
    QryDel.Transaction.StartTransaction;

    QryUpdate := ThreadCreateQuery(Main_DB);
    QryUpdate.Transaction := ThreadCreateTransaction(Main_DB);
    QryUpdate.Transaction.StartTransaction;

    OrderBy := '';
    ListWS := TList.Create;
    UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
    with HostQry do
    begin
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.ASname + ' where AANNUL ' + CAnnulFilter);
      open
    end;

    IndexWS := 0;
    Tmp_Date1 := 0;
    Tmp_Date2 := 0;

    while not HostQry.Eof do
    begin
      New(RecWS);

      if (DateTimeFormat = Frm_As400) then
      begin
        Tmp_Date1  := TimDateTimeToDateTime(HostQry.FieldByName(fldList[4].fldAS).AsFloat);
        Tmp_Date2  := TimDateTimeToDateTime(HostQry.FieldByName(fldList[6].fldAS).AsFloat);
      end;

      if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
      begin
        Tmp_Date1  := HostQry.FieldByName(fldList[4].fldAS).AsDateTime;
        Tmp_Date2  := HostQry.FieldByName(fldList[6].fldAS).AsDateTime;
      end;

      RecWS.WS_wkstCode       := Trim(HostQry.FieldByName(fldList[0].fldAS).AsString);
      RecWS.WS_wkDescr        := Trim(HostQry.FieldByName(fldList[1].fldAS).AsString);
      RecWS.WS_wkPasswd       := Trim(HostQry.FieldByName(fldList[2].fldAS).AsString);
      RecWS.WS_usrCr          := Trim(HostQry.FieldByName(fldList[3].fldAS).AsString);
      RecWS.WS_usrTmCr        := Tmp_Date1;
      RecWS.WS_usrCg          := Trim(HostQry.FieldByName(fldList[5].fldAS).AsString);
      RecWS.WS_usrTmCg        := Tmp_Date2;
      RecWS.WS_WkStationType  := '0';//Trim(HostQry.FieldByName(fldList[7].fldAS).AsString);
      ListWS.add(RecWS);
      Application.ProcessMessages;
      HostQry.Next;
    end;
    HostQry.close;
    ListWS.Sort(SortWS);

    InsertQryTables(tbl,fldList,QryWS);
    with srvQry do
    begin
      SQL.Clear;
      UpdateOperation(_('Updating') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));

      if (LocalHostName = TD_Db2) or (LocalHostName = TD_Oracle) then
      begin
        SQL.Add('Select * from ' + tbInfo.GetTableName + ' order by WK_WKST_CODE');
      end
      else if LocalHostName = TD_Interbase then
      begin
        SQL.Add('Select * from WKST order by WK_WKST_CODE');
      end;

      open;
      while true do
      begin

        if (IndexWS > ListWS.count - 1) and srvQry.Eof then break;

        if (IndexWS > ListWS.count - 1) or
          ((IndexWS <= ListWS.count - 1) and (not srvQry.Eof) and
           (pRecWS(ListWS[IndexWS]).WS_wkstCode > Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString))) then
        begin
          with QryDel do
          begin
            Sql.Clear;
            Sql.Add(' delete from WKST where');
            Sql.Add(' WK_WKST_CODE ' + '=''' + Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString) + '''');
          //  Prepare;



         {   if LocalHostName = TD_Db2 then
            begin
              SQL.Add('Select * from ' + tbInfo.GetTableName + ' order by AWRKST');
            end
            else if LocalHostName = TD_Interbase then
            begin
              SQL.Add('Select * from WKST order by WK_WKST_CODE');
            end
            else if LocalHostName = TD_Oracle then
            begin

            end;    }


            ExecSQL;
          end;
          srvQry.next;
          Application.ProcessMessages;
          continue;
        end;

       if srvQry.Eof or
        ((IndexWS <= ListWS.count - 1) and (not srvQry.Eof) and
          (pRecWS(ListWS[IndexWS]).WS_wkstCode < Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString))) then
        begin
          //  Insert into products from memory
          QryWS.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).Value := pRecWS(ListWS[IndexWS]).WS_wkstCode;
          QryWS.ParamByName(CreateFld(tbInfo.pfx, fli_wkDescr)).Value := pRecWS(ListWS[IndexWS]).WS_wkDescr;
          QryWS.ParamByName(CreateFld(tbInfo.pfx, fli_wkPasswd)).Value := pRecWS(ListWS[IndexWS]).WS_wkPasswd;
          QryWS.ParamByName(CreateFld(tbInfo.pfx, fli_usrCr)).Value := pRecWS(ListWS[IndexWS]).WS_usrCr;
          QryWS.ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCr)).Value := pRecWS(ListWS[IndexWS]).WS_usrTmCr;
          QryWS.ParamByName(CreateFld(tbInfo.pfx, fli_usrCg)).Value := pRecWS(ListWS[IndexWS]).WS_usrCg;
          QryWS.ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCg)).Value := pRecWS(ListWS[IndexWS]).WS_usrTmCg;
          QryWS.ParamByName(CreateFld(tbInfo.pfx, fli_WorkStationType)).Value := pRecWS(ListWS[IndexWS]).WS_WkStationType;
          QryWS.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).Value := IniAppGlobals.Identifier;

          QryWS.ExecSQL;
          IndexWS := IndexWS + 1;
          Application.ProcessMessages;
          continue;
        end;

       { if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') then // mcm
        begin
           // Key is equal //
          if ((pRecWS(ListWS[IndexWS]).WS_wkDescr) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkDescr)).AsString)) or
             ((pRecWS(ListWS[IndexWS]).WS_wkPasswd) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkPasswd)).AsString)) or
             ((pRecWS(ListWS[IndexWS]).WS_WkStationType) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_WorkStationType)).AsString)) then
          begin
            with QryUpdate do
            begin
              Sql.Clear;
              Sql.Add('update WKST set ');
              Sql.Add('WK_WKDESCR ' + '=''' + pRecWS(ListWS[IndexWS]).WS_wkDescr + '''');
              Sql.Add(' , ');
              Sql.Add('WK_WKPASSWD ' + '=''' + pRecWS(ListWS[IndexWS]).WS_wkPasswd + '''');
              Sql.Add(' , ');
              Sql.Add('WK_WorkStationType ' + '=''' + pRecWS(ListWS[IndexWS]).WS_WkStationType + '''');
              Sql.Add(' Where');
              Sql.Add(' WK_WKST_CODE ' + '=''' + srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString + '''');
              Prepare;
              ExecSQL;
            end;
          end;
        end   }
       // else   // mqm users
       // begin
           // Key is equal //
        if ((pRecWS(ListWS[IndexWS]).WS_wkDescr) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkDescr)).AsString)) or
           ((pRecWS(ListWS[IndexWS]).WS_wkPasswd) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkPasswd)).AsString)) or
           ((pRecWS(ListWS[IndexWS]).WS_WkStationType) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_WorkStationType)).AsString)) then
        begin
          with QryUpdate do
          begin
            Sql.Clear;
            Sql.Add('update WKST set ');
            Sql.Add('WK_WKDESCR ' + '=''' + pRecWS(ListWS[IndexWS]).WS_wkDescr + '''');
            Sql.Add(' , ');
            Sql.Add('WK_WORKSTATIONTYPE ' + '=''' + pRecWS(ListWS[IndexWS]).WS_WkStationType + '''');
            Sql.Add(' , ');
            Sql.Add('WK_WKPASSWD ' + '=''' + pRecWS(ListWS[IndexWS]).WS_wkPasswd + '''');
            Sql.Add(' Where');
            Sql.Add(' WK_WKST_CODE ' + '=''' + srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString + '''');
            Prepare;
            ExecSQL;
          end;
        end;
      //  end;

        srvQry.Next;
        Application.ProcessMessages;
        IndexWS := IndexWS + 1;
      end;
    end;

    for IndexWS := 0 to ListWS.count - 1 do
       dispose(pRecWS(ListWS[IndexWS]));

    ListWS.Free;
    QryWS.Transaction.Commit;
    QryDel.Transaction.Commit;
    QryUpdate.Transaction.Commit;
    QryWS.Close;
    QryWS.Free;
    QryDel.Close;
    QryDel.Free;
    QryUpdate.Close;
    QryUpdate.Free;
  end;
end;

//----------------------------------------------------------------------------//

function LoadUnit(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  tbInfo:         ^TTblInfo;
  tblName, tblArcName : string;
  str:     string;
  DndArchiveName, DndArchiveArcName : TDndArchiveName;
begin
  Assert(tbl = tbl_unit);

  tbInfo := @tblInfo[tbl_unit];

  DndArchiveName := GetDndArchiveHostName;
  DndArchiveArcName := GetDndArchiveLocalName;

  tblArcName := tbInfo.PCname;
  if DndArchiveArcName <> TD_Interbase then
    tblArcName  := 'SCDA_' + tbInfo.PCname;

  if DndArchiveName = TD_AS_400 then
    tblName := AS400Speclib + tbInfo.ASname
  else
    tblName := tbInfo.GetTableName;

  with HostQry do
  begin
    if DndArchiveName = TD_AS_400 then
    begin
      UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblName + ' where TABLE=''UNIT'' and ANNUL' + CAnnulFilter);
    end
    else
    begin
      UpdateOperation(_('Reading') + '  ' + tblArcName + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblArcName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    end;
    Open;
  end;

  with srvQry do
  begin
    UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    ExecSQL;
    Close;

    UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Um) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_SDescr)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_LDescr)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_DecNum)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)  + ')');
    SQL.Add(' values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Um) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SDescr) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_LDescr) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_DecNum) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    SQL.Add(')');
//    Prepare;

    while not HostQry.EOF do
    begin
      if DndArchiveName = TD_AS_400 then
      begin
        str := HostQry.Fields[3].AsString;
        ParamByName(CreateFld(tbInfo.pfx, fli_Um)).AsString     := trim(HostQry.Fields[2].AsString); //property code
        ParamByName(CreateFld(tbInfo.pfx, fli_SDescr)).AsString := Copy(str,  1, 14); // property short description
        ParamByName(CreateFld(tbInfo.pfx, fli_LDescr)).AsString := Copy(str, 15, 30); // property Long description
        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger := StrToInt(IniAppGlobals.Identifier);
      end
      else
      begin
        ParamByName(CreateFld(tbInfo.pfx, fli_Um)).AsString     := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_Um)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_SDescr)).AsString := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_SDescr)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_LDescr)).AsString := trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_LDescr)).AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_DecNum)).AsInteger := HostQry.FieldByName(CreateFld(tbInfo.pfx, fli_DecNum)).AsInteger;
        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger := StrToInt(IniAppGlobals.Identifier);
      end;
      srvQry.ExecSql;
      HostQry.Next;
      Application.ProcessMessages;
    end;
    HostQry.Close
  end;

  if DndArchiveName = TD_AS_400 then
    UpdateOperation(_('Loaded')+ ' ' + tbInfo.ASname)
  else
    UpdateOperation(_('Loaded')+ ' ' + tbInfo.GetTableName);

  Result := true
end;

//----------------------------------------------------------------------------//

function LoadProc(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..5] of TQryLinkRec = (
    (fldPC: fli_wkcProc;     fldAS: ''; fldType: TLD_string),
    (fldPC: fli_SDescr;      fldAS: ''; fldType: TLD_string),
    (fldPC: fli_Alternative_um_handled; fldAS: ''; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;  fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_RuleForGroupingMQM; fldAS: ''; fldType: TLD_string),
    (fldPC: fli_RuleForGroupingMCM; fldAS: ''; fldType: TLD_string)
  );

var
  DndArchiveHostName : TDndArchiveName;
begin
  Assert(tbl = tbl_proc);

  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName <> TD_AS_400 then
  begin
    Result := LoadTable(tbl, AS400Speclib, ' where AANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end;
end;

//----------------------------------------------------------------------------//

function LoadWCProc(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldListAS: array [0..4] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;   fldAS: 'ACDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;     fldAS: 'ACDMAP'; fldType: TLD_string),
    (fldPC: fli_SDescr;      fldAS: 'ADESCR'; fldType: TLD_string),
    (fldPC: fli_LDescr;      fldAS: 'ASUPDS'; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;  fldAS: ''; fldType: TLD_integer)
  );

  fldList: array [0..6] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;   fldAS: 'ACDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;     fldAS: 'ACDMAP'; fldType: TLD_string),
    (fldPC: fli_SDescr;      fldAS: 'ADESCR'; fldType: TLD_string),
    (fldPC: fli_LDescr;      fldAS: 'ASUPDS'; fldType: TLD_string),
    (fldPC: fli_ResOccupation; fldAS: ''; fldType: TLD_string),
    (fldPC: fli_UseAllResourceParts; fldAS: ''; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;  fldAS: ''; fldType: TLD_integer)
  );

var
  DndArchiveHostName : TDndArchiveName;
begin
  Assert(tbl = tbl_wkc_proc);

  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName = TD_AS_400 then
  begin
    Result := LoadWorcCenterProcessTable(tbl, AS400Speclib, ' where AANNUL' + CAnnulFilter,
                      fldListAS, srvQry, HostQry)
  end
  else
    Result := LoadTable(tbl, AS400Speclib, ' where AANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function Loadwkctr(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..8] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;   fldAS: 'MCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkCtrGroup;  fldAS: 'MCDMAG'; fldType: TLD_string),
    (fldPC: fli_SDescr;      fldAS: 'MDESCR'; fldType: TLD_string),
    (fldPC: fli_LDescr;      fldAS: 'MSUPDS'; fldType: TLD_string),
    (fldPC: fli_TypOprtion;  fldAS: 'MBCFLG'; fldType: TLD_string),
    (fldPC: fli_TypProcess;  fldAS: 'MMACOP'; fldType: TLD_string),
    (fldPC: fli_NumResPlan;  fldAS: 'MNUMAC'; fldType: TLD_float),
    (fldPC: fli_CalCod;      fldAS: 'MCDCAL'; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;  fldAS: '';       fldType: TLD_Integer)
  );

  fldListPC: array [0..13] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;   fldAS: 'MCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkCtrGroup;  fldAS: 'MCDMAG'; fldType: TLD_string),
    (fldPC: fli_SDescr;      fldAS: 'MDESCR'; fldType: TLD_string),
    (fldPC: fli_LDescr;      fldAS: 'MSUPDS'; fldType: TLD_string),
    (fldPC: fli_TypOprtion;  fldAS: 'MBCFLG'; fldType: TLD_string),
    (fldPC: fli_TypProcess;  fldAS: 'MMACOP'; fldType: TLD_string),
    (fldPC: fli_PlantCode;   fldAS: '';       fldType: TLD_string),
    (fldPC: fli_NumResPlan;  fldAS: 'MNUMAC'; fldType: TLD_float),
    (fldPC: fli_CalCod;      fldAS: 'MCDCAL'; fldType: TLD_string),
    (fldPC: fli_MCMSequence; fldAS: '';       fldType: TLD_Integer),
    (fldPC: fli_WarpHandle;  fldAS: '';       fldType: TLD_string),
    (fldPC: fli_Division;    fldAS: '';       fldType: TLD_string),
    (fldPC: fli_Ignoreprogress; fldAS: '';    fldType: TLD_Integer),
    (fldPC: fli_IDENTIFIER;  fldAS: '';       fldType: TLD_Integer)
  );

var
  DndArchiveHostName : TDndArchiveName;
begin
  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName = TD_AS_400 then
  begin
    Result := LoadTable(tbl, AS400Speclib, ' where MANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end

  else
  begin
    Result := LoadTable(tbl, AS400Speclib, ' where MANNUL' + CAnnulFilter,
                      fldListPC, srvQry, HostQry)
  end
end;

//----------------------------------------------------------------------------//

{function LoadwkctrGroup(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..2] of TQryLinkRec = (
   (fldPC: fli_wkCtrGroup;  fldAS: 'MAGWGW'; fldType: TLD_string),
   (fldPC: fli_PlantCode;   fldAS: 'CDPLNX'; fldType: TLD_float),
   (fldPC: fli_MainWC;      fldAS: 'CDMWCX'; fldType: TLD_string)
  );
begin
  Assert(tbl = tbl_wkc_group);
  Result := LoadTable(tbl, AS400Speclib, ' where MANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)          }


function LoadwkctrGroup(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  tbInfo:         ^TTblInfo;
  tblName: string;
  str:     string;
  DndArchiveHostName : TDndArchiveName;
begin
  // seems not been in used 06072020 avi (no identifier handled)
  Assert(tbl = tbl_wkc_group);

  tbInfo := @tblInfo[tbl_wkc_group];

  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName = TD_AS_400 then
    tblName := AS400Speclib + tbInfo.ASname;//
//  else if DndArchiveName = TD_PC_MqmDfn then
//    tblName := tbInfo.PCname;

  with HostQry do
  begin
    if DndArchiveHostName = TD_AS_400 then
    begin
      UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblName + ' where TABLE=''WORK'' and ANNUL' + CAnnulFilter);
    end
    else
    begin
      UpdateOperation(_('Reading') + '  ' + tbInfo.GetTableName + ' ' + (_('from host . . .')));
      SQL.Clear;
      SQL.Add('select * from ' + tblName);
    end;
    Open;
  end;

  with srvQry do
  begin
    UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName);
    ExecSQL;
    Close;

    UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_wkCtrGroup) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PlantCode)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_MainWC)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    SQL.Add(') values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkCtrGroup) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PlantCode)  + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MainWC)  + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    SQL.Add(')');
//    Prepare;

    while not HostQry.EOF do
    begin
      if DndArchiveHostName = TD_AS_400 then
      begin
        str := HostQry.Fields[3].AsString;
        ParamByName(CreateFld(tbInfo.pfx, fli_wkCtrGroup)).AsString := trim(HostQry.Fields[2].AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PlantCode)).AsString  := trim(Copy(str,  18, 8));        // short description
        ParamByName(CreateFld(tbInfo.pfx, fli_MainWC)).AsString  := trim(Copy(str, 26, 5));        // long description
        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;
      end
      else
      begin
        ParamByName(CreateFld(tbInfo.pfx, fli_wkCtrGroup)).AsString := trim(HostQry.Fields[0].AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_PlantCode)).AsString  := trim(HostQry.Fields[1].AsString);
        ParamByName(CreateFld(tbInfo.pfx, fli_MainWC)).AsString  := trim(HostQry.Fields[2].AsString);
      end;

      srvQry.ExecSql;
      HostQry.Next;
      Application.ProcessMessages;
    end;
    HostQry.Close
  end;

  if DndArchiveHostName = TD_AS_400 then
    UpdateOperation(_('Loaded')+ ' ' + tbInfo.ASname)
  else
    UpdateOperation(_('Loaded')+ ' ' + tbInfo.GetTableName);

  Result := true
end;

//----------------------------------------------------------------------------//

function Loadwkst_wkctrs(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..7] of TQryLinkRec = (
    (fldPC: fli_wkstCode;  fldAS: 'BWRKST'; fldType: TLD_string),
    (fldPC: fli_wkCtrCode; fldAS: 'BCDMAC'; fldType: TLD_string),
    (fldPC: fli_TypeOfUse; fldAS: 'BUSETP'; fldType: TLD_string),
    (fldPC: fli_usrCr;     fldAS: 'BUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;   fldAS: 'BDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;     fldAS: 'BUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;   fldAS: 'BDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER; fldAS: '';      fldType: TLD_Integer)
  );
begin
  Assert(tbl = tbl_wkst_wkc);
  Result := LoadTable(tbl, AS400Speclib, ' where BANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadWorkCntrPrior(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..10] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;          fldAS: 'JCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;            fldAS: 'JCDMAP'; fldType: TLD_string),
    (fldPC: fli_SequenceDepend;     fldAS: 'JPRIOR'; fldType: TLD_string),
    (fldPC: fli_SeqAlpha;           fldAS: 'JSEQNC'; fldType: TLD_string),
    (fldPC: fli_PriorityRelation;   fldAS: 'JDISDP'; fldType: TLD_string),
    (fldPC: fli_Mach_stp_code_lvl;  fldAS: 'JSTCDL'; fldType: TLD_string),
    (fldPC: fli_usrCr;              fldAS: 'JUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;            fldAS: 'JDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;              fldAS: 'JUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;            fldAS: 'JDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;         fldAS: '';       fldType: TLD_Integer)
  );
begin
  Assert(tbl = tbl_wkc_priority);
  Result := LoadTable(tbl, AS400Speclib, ' where JANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadMachineSetupCode(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..10] of TQryLinkRec = (
    (fldPC: fli_ResCatcode;         fldAS: 'CCATRS'; fldType: TLD_string),
    (fldPC: fli_wkCtrCode;          fldAS: 'CCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;            fldAS: 'CCDMAP'; fldType: TLD_string),
    (fldPC: fli_rsc;                fldAS: 'CCDRSC'; fldType: TLD_string),
    (fldPC: fli_Desc;               fldAS: 'CDESCR'; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;      fldAS: 'CSETCD'; fldType: TLD_string),
    (fldPC: fli_usrCr;              fldAS: 'CUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;            fldAS: 'CDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;              fldAS: 'CUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;            fldAS: 'CDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;         fldAS: '';       fldType: TLD_Integer)
  );
begin
  Assert(tbl = tbl_machine_setup_code);
  Result := LoadTable(tbl, AS400Speclib, ' where CANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadWkcDependency(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..13] of TQryLinkRec = (
    (fldPC: fli_SchedWkc;           fldAS: 'RCDMAC'; fldType: TLD_string),
    (fldPC: fli_SchedWkCtrProc;     fldAS: 'RCDMAP'; fldType: TLD_string),
    (fldPC: fli_DependOn;           fldAS: 'RDEPDR'; fldType: TLD_string),
    (fldPC: fli_DepIsSchedRscCat;   fldAS: 'RDPCAT'; fldType: TLD_string),
    (fldPC: fli_DepIsSchedWkc;      fldAS: 'RDPMAC'; fldType: TLD_string),
    (fldPC: fli_DepIsSchedRsc;      fldAS: 'RDPRSC'; fldType: TLD_string),
    (fldPC: fli_NoSchedRscCat;      fldAS: 'RORCAT'; fldType: TLD_string),
    (fldPC: fli_NoSchedWkc;         fldAS: 'RORMAC'; fldType: TLD_string),
    (fldPC: fli_NoSchedRsc;         fldAS: 'RORRSC'; fldType: TLD_string),
    (fldPC: fli_usrCr;              fldAS: 'RUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCr;            fldAS: 'RDTOCR'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;              fldAS: 'RUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;            fldAS: 'RDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;         fldAS: '';       fldType: TLD_Integer)
   );
begin
  Assert(tbl = tbl_Wkc_dependency);
  Result := LoadTable(tbl, AS400Speclib, ' where RANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

{function LoadMaterial(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..16] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;           fldAS: 'HCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;             fldAS: 'HCDMAP'; fldType: TLD_string),
    (fldPC: fli_ResCatcode;          fldAS: 'HCATRS'; fldType: TLD_string),
    (fldPC: fli_rsc;                 fldAS: 'HCDRSC'; fldType: TLD_string),
    (fldPC: fli_prodtype;            fldAS: 'HRECTY'; fldType: TLD_string),
    (fldPC: fli_highDateAlloc;       fldAS: 'HDTMAX'; fldType: TLD_datetime),
    (fldPC: fli_SearchMatByAlloc;    fldAS: 'HFLALC'; fldType: TLD_string),
    (fldPC: fli_settled;             fldAS: 'HFLSAL'; fldType: TLD_string),
    (fldPC: fli_issueCode;           fldAS: 'HISSCD'; fldType: TLD_string),
    (fldPC: fli_quantityIssue;       fldAS: 'HISSQT'; fldType: TLD_float),
    (fldPC: fli_netGroupCode;        fldAS: 'HNETCD'; fldType: TLD_string),
    (fldPC: fli_ProdCode;            fldAS: 'HPRDCD'; fldType: TLD_string),
    (fldPC: fli_preqNo;              fldAS: 'HPRREQ'; fldType: TLD_string),
    (fldPC: fli_orgStep;             fldAS: 'HPRSTP'; fldType: TLD_string),
    (fldPC: fli_reqQuant;            fldAS: 'HREQQT'; fldType: TLD_Float),
    (fldPC: fli_seqIssued;           fldAS: 'HSEQNC'; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;       fldAS: 'HSETCD'; fldType: TLD_string)
    );
begin
  Assert(tbl = tbl_Material);
  Result := LoadTable(tbl, AS400Speclib, 'where HANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;  }

//----------------------------------------------------------------------------//

function LoadMaterialSupDetail(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldListMcm: array [0..12] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;           fldAS: 'YCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;             fldAS: 'YCDMAP'; fldType: TLD_string),
    (fldPC: fli_ResCatcode;          fldAS: 'YCATRS'; fldType: TLD_string),
    (fldPC: fli_rsc;                 fldAS: 'YCDRSC'; fldType: TLD_string),
    (fldPC: fli_prodtype;            fldAS: 'YRECTY'; fldType: TLD_string),
    (fldPC: fli_searchBalance;       fldAS: 'YFLBAL'; fldType: TLD_string),
    (fldPC: fli_waitEntireMat;       fldAS: 'YFLSTR'; fldType: TLD_string),
    (fldPC: fli_issueTransType;      fldAS: 'YISSCD'; fldType: TLD_string),
    (fldPC: fli_minQty;              fldAS: 'YMINQT'; fldType: TLD_float),
    (fldPC: fli_updReqHrs;           fldAS: 'YREQHR'; fldType: TLD_float),
    (fldPC: fli_MatProdType;         fldAS: 'YYRECT'; fldType: TLD_string),
    (fldPC: fli_ModuleRule;          fldAS: 'YMODUL'; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;          fldAS: '';       fldType: TLD_Integer)
   );

  fldListMqm: array [0..11] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;           fldAS: 'YCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;             fldAS: 'YCDMAP'; fldType: TLD_string),
    (fldPC: fli_ResCatcode;          fldAS: 'YCATRS'; fldType: TLD_string),
    (fldPC: fli_rsc;                 fldAS: 'YCDRSC'; fldType: TLD_string),
    (fldPC: fli_prodtype;            fldAS: 'YRECTY'; fldType: TLD_string),
    (fldPC: fli_searchBalance;       fldAS: 'YFLBAL'; fldType: TLD_string),
    (fldPC: fli_waitEntireMat;       fldAS: 'YFLSTR'; fldType: TLD_string),
    (fldPC: fli_issueTransType;      fldAS: 'YISSCD'; fldType: TLD_string),
    (fldPC: fli_minQty;              fldAS: 'YMINQT'; fldType: TLD_float),
    (fldPC: fli_updReqHrs;           fldAS: 'YREQHR'; fldType: TLD_float),
    (fldPC: fli_MatProdType;         fldAS: 'YYRECT'; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;          fldAS: '';       fldType: TLD_Integer)
   );
var
  DndArchiveHostName : TDndArchiveName;
begin
  Assert(tbl = tbl_material_sup_detail);
  DndArchiveHostName := GetDndArchiveHostName;
//  if DndArchiveName = TD_PC_MqmDfn then
//  begin
  Result := LoadTable(tbl, AS400Speclib, ' where YANNUL' + CAnnulFilter,
                      fldListMcm, srvQry, HostQry)
//  end
{  else
  begin
    Result := LoadTable(tbl, AS400Speclib, ' where YANNUL' + CAnnulFilter,
                      fldListMqm, srvQry, HostQry)
  end;        }

end;

//----------------------------------------------------------------------------//

function LoadMaterialSupHeader(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldListMcm: array [0..19] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;           fldAS: 'RCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;             fldAS: 'RCDMAP'; fldType: TLD_string),
    (fldPC: fli_ResCatcode;          fldAS: 'RCATRS'; fldType: TLD_string),
    (fldPC: fli_rsc;                 fldAS: 'RCDRSC'; fldType: TLD_string),
    (fldPC: fli_prodtype;            fldAS: 'RRECTY'; fldType: TLD_string),
    (fldPC: fli_waitPrevQty;         fldAS: 'RFLSTR'; fldType: TLD_string),
    (fldPC: fli_MinQtyPassNxt;       fldAS: 'RMNQTN'; fldType: TLD_float),
    (fldPC: fli_MinQtyPrevStp;       fldAS: 'RMNQTP'; fldType: TLD_float),
    (fldPC: fli_MinDelWaitDays;      fldAS: 'RMNWTD'; fldType: TLD_float),
    (fldPC: fli_MinDelWaitHrs;       fldAS: 'RMNWTH'; fldType: TLD_float),
    (fldPC: fli_MinDelWaitMin;       fldAS: 'RMNWTM'; fldType: TLD_float),
    (fldPC: fli_MaxDelWaitDays;      fldAS: 'RMXWTD'; fldType: TLD_float),
    (fldPC: fli_MaxDelWaitHrs;       fldAS: 'RMXWTH'; fldType: TLD_float),
    (fldPC: fli_MaxDelWaitMin;       fldAS: 'RMXWTM'; fldType: TLD_float),
    (fldPC: fli_PartDel;             fldAS: 'RPARTL'; fldType: TLD_string),
    (fldPC: fli_UpdBalHrs;           fldAS: 'RPRDHR'; fldType: TLD_float),
    (fldPC: fli_UpdBalQty;           fldAS: 'RPRDQT'; fldType: TLD_float),
    (fldPC: fli_UpdReqPrevStpHrs;    fldAS: 'RREQHR'; fldType: TLD_float),
    (fldPC: fli_ModuleRule;          fldAS: 'RMODUL'; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;          fldAS: '';       fldType: TLD_Integer)
   );

  fldListMqm: array [0..18] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;           fldAS: 'RCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;             fldAS: 'RCDMAP'; fldType: TLD_string),
    (fldPC: fli_ResCatcode;          fldAS: 'RCATRS'; fldType: TLD_string),
    (fldPC: fli_rsc;                 fldAS: 'RCDRSC'; fldType: TLD_string),
    (fldPC: fli_prodtype;            fldAS: 'RRECTY'; fldType: TLD_string),
    (fldPC: fli_waitPrevQty;         fldAS: 'RFLSTR'; fldType: TLD_string),
    (fldPC: fli_MinQtyPassNxt;       fldAS: 'RMNQTN'; fldType: TLD_float),
    (fldPC: fli_MinQtyPrevStp;       fldAS: 'RMNQTP'; fldType: TLD_float),
    (fldPC: fli_MinDelWaitDays;      fldAS: 'RMNWTD'; fldType: TLD_float),
    (fldPC: fli_MinDelWaitHrs;       fldAS: 'RMNWTH'; fldType: TLD_float),
    (fldPC: fli_MinDelWaitMin;       fldAS: 'RMNWTM'; fldType: TLD_float),
    (fldPC: fli_MaxDelWaitDays;      fldAS: 'RMXWTD'; fldType: TLD_float),
    (fldPC: fli_MaxDelWaitHrs;       fldAS: 'RMXWTH'; fldType: TLD_float),
    (fldPC: fli_MaxDelWaitMin;       fldAS: 'RMXWTM'; fldType: TLD_float),
    (fldPC: fli_PartDel;             fldAS: 'RPARTL'; fldType: TLD_string),
    (fldPC: fli_UpdBalHrs;           fldAS: 'RPRDHR'; fldType: TLD_float),
    (fldPC: fli_UpdBalQty;           fldAS: 'RPRDQT'; fldType: TLD_float),
    (fldPC: fli_UpdReqPrevStpHrs;    fldAS: 'RREQHR'; fldType: TLD_float),
    (fldPC: fli_IDENTIFIER;          fldAS: '';       fldType: TLD_Integer)
   );
var
  DndArchiveName : TDndArchiveName;
begin
  Assert(tbl = tbl_material_sup_header);
//  DndArchiveName := GetDndArchiveName;

//  if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') or (DndArchiveName = TD_PC_MqmDfn) then
//  begin
  Result := LoadTable(tbl, AS400Speclib, ' where RANNUL' + CAnnulFilter,
                      fldListMcm, srvQry, HostQry)
//  end
//  else
{  begin
    Result := LoadTable(tbl, AS400Speclib, ' where RANNUL' + CAnnulFilter,
                      fldListMqm, srvQry, HostQry)
  end }

end;

//----------------------------------------------------------------------------//

{function LoadProducedArticle(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..6] of TQryLinkRec = (
    (fldPC: fli_settled;             fldAS: 'AFLSAL'; fldType: TLD_string),
    (fldPC: fli_netGroupCode;        fldAS: 'ANETCD'; fldType: TLD_string),
    (fldPC: fli_ProdCode;            fldAS: 'APRDCD'; fldType: TLD_string),
    (fldPC: fli_qtyProduced;         fldAS: 'APRDQT'; fldType: TLD_float),
    (fldPC: fli_preqNo;              fldAS: 'APRREQ'; fldType: TLD_string),
    (fldPC: fli_reqQuant;            fldAS: 'AREQQT'; fldType: TLD_float),
    (fldPC: fli_sequenceChar;        fldAS: 'ASEQNC'; fldType: TLD_string)
   );
begin
  Assert(tbl = tbl_produced_article);
  Result := LoadTable(tbl, AS400Speclib, 'where AANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;    }

//----------------------------------------------------------------------------//

function SortAR(Item1, Item2: Pointer) : integer;
var
  MQMAR1 : pRecAR;
  MQMAR2 : pRecAR;
begin
  MQMAR1 := pRecAR(Item1);
  MQMAR2 := pRecAR(Item2);
  if (MQMAR1.AR_ArtProdType < MQMAR2.AR_ArtProdType) then
    Result := -1
  else if (MQMAR1.AR_ArtProdType = MQMAR2.AR_ArtProdType) then
  begin
    if (MQMAR1.AR_ProdCode < MQMAR2.AR_ProdCode) then
      Result := -1
    else if (MQMAR1.AR_ProdCode = MQMAR2.AR_ProdCode) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function LoadProducts(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..10] of TQryLinkRec = (
    (fldPC: fli_IDENTIFIER;           fldAS: '';       fldType: TLD_string),
    (fldPC: fli_ProdType;             fldAS: 'CRECTY'; fldType: TLD_string),
    (fldPC: fli_ProdCode;             fldAS: 'CPRDCD'; fldType: TLD_string),
    (fldPC: fli_ProductNature;        fldAS: 'CPRDNT'; fldType: TLD_string),
    (fldPC: fli_StartConsumPoint;     fldAS: 'CFLSTR'; fldType: TLD_string),
    (fldPC: fli_EndConsumPoint;       fldAS: 'CFLEND'; fldType: TLD_string),
    (fldPC: fli_InfoArea;             fldAS: 'CDESCR'; fldType: TLD_string),
    (fldPC: fli_StdPurcOrProdTime;    fldAS: 'CSTDTM'; fldType: TLD_integer),
    (fldPC: fli_IgnorMaterialCheck;   fldAS: 'CIGMAT'; fldType: TLD_string),
    (fldPC: fli_HoursToDownFromMachine;   fldAS: '';   fldType: TLD_integer),
    (fldPC: fli_Material_Tollerance_Types_Code; fldAS: ''; fldType: TLD_string)
  );

{  fldListAs400: array [0..8] of TQryLinkRec = (
    (fldPC: fli_ProdType;             fldAS: 'CRECTY'; fldType: TLD_string),
    (fldPC: fli_ProdCode;             fldAS: 'CPRDCD'; fldType: TLD_string),
    (fldPC: fli_ProductNature;        fldAS: 'CPRDNT'; fldType: TLD_string),
    (fldPC: fli_StartConsumPoint;     fldAS: 'CFLSTR'; fldType: TLD_string),
    (fldPC: fli_EndConsumPoint;       fldAS: 'CFLEND'; fldType: TLD_string),
    (fldPC: fli_InfoArea;             fldAS: 'CDESCR'; fldType: TLD_string),
    (fldPC: fli_StdPurcOrProdTime;    fldAS: 'CSTDTM'; fldType: TLD_integer),
    (fldPC: fli_IgnorMaterialCheck;   fldAS: 'CIGMAT'; fldType: TLD_string),
    (fldPC: fli_Material_Tollerance_Types_Code; fldAS: ''; fldType: TLD_string)
  );
          }
var
  OrderBy : string;
  tbInfo, tbInfoMT:         ^TTblInfo;
  RecAR   : pRecAR;
  ListAR : TList;
  IndexAR  : Integer;
  QryAR, QryDel, QryUpdate  : TMqmQuery;
  DndArchiveHostName : TDndArchiveName;
  DndArchiveLocalName : TDndArchiveName;
  IgnorMaterialCheck : boolean;
  IgnorMaterial, tblArcName, RQ_HDR_PRODUCTS  : string;
  ArcQry: TMqmQuery;
begin
  Assert(tbl = tbl_products);
  tbInfo := @tblInfo[tbl];
  tbInfoMT := @tblInfo[tbl_material];
  QryAR := ThreadCreateQuery(Main_DB);
  QryDel := ThreadCreateQuery(Main_DB);
  QryUpdate := ThreadCreateQuery(Main_DB);
  OrderBy := '';
  DndArchiveHostName := GetDndArchiveHostName;
  DndArchiveLocalName := GetDndArchiveLocalName;

  tblArcName := tbInfo.PCname;
  if DndArchiveHostName <> TD_Interbase then
    tblArcName  := 'SCDA_' + tbInfo.PCname;

  ListAR := TList.Create;
  UpdateOperation(_('Reading') + '  ' + tbInfo.GetTableName + ' ' + (_('from host . . .')));
  Result := OpenQryTables(tbl, AS400Speclib, '', OrderBy,
                      fldList, HostQry, ArcQry, true);

  if DndArchiveHostName <> TD_AS_400 then exit;

  if DndArchiveHostName = TD_AS_400 then
  begin

    while not HostQry.Eof do
    begin
      New(RecAR);

      RecAR.AR_ArtProdType        := Trim(HostQry.FieldByName(fldList[1].fldAS).AsString);
      RecAR.AR_ProdCode           := Trim(HostQry.FieldByName(fldList[2].fldAS).AsString);
      RecAR.AR_ProductNature      := Trim(HostQry.FieldByName(fldList[3].fldAS).AsString);
      RecAR.AR_StartConsumPoint   := Trim(HostQry.FieldByName(fldList[4].fldAS).AsString);
      RecAR.AR_EndConsumPoint     := Trim(HostQry.FieldByName(fldList[5].fldAS).AsString);

      if RecAR.AR_ProductNature = '' then
      begin
        RecAR.AR_ProductNature := '1';
        RecAR.AR_StartConsumPoint := '0';
        RecAR.AR_EndConsumPoint := '0';
      end;

      RecAR.AR_InfoArea          := Trim(HostQry.FieldByName(fldList[6].fldAS).AsString);

      RecAR.AR_StdPurcOrProdTime := HostQry.FieldByName(fldList[7].fldAS).AsInteger;

      RecAR.AR_Ignor_Mat_check := false;
      try
        if Trim(HostQry.FieldByName(fldList[8].fldAS).AsString) = '1' then
           RecAR.AR_Ignor_Mat_check := true;
      except
      end;

      ListAR.add(RecAR);
      HostQry.Next;
      Application.ProcessMessages;
    end;

  end
  else
  begin

    while not ArcQry.Eof do
    begin
      New(RecAR);
      RecAR.AR_ArtProdType        := Trim(ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString);
      RecAR.AR_ProdCode           := Trim(ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString);
      RecAR.AR_ProductNature      := Trim(ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProductNature)).AsString);
      RecAR.AR_StartConsumPoint   := Trim(ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_StartConsumPoint)).AsString);
      RecAR.AR_EndConsumPoint     := Trim(ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_EndConsumPoint)).AsString);

      if RecAR.AR_ProductNature = '' then
      begin
        RecAR.AR_ProductNature := '1';
        RecAR.AR_StartConsumPoint := '0';
        RecAR.AR_EndConsumPoint := '0';
      end;

      RecAR.AR_InfoArea          := Trim(ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_InfoArea)).AsString);

      RecAR.AR_StdPurcOrProdTime := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_StdPurcOrProdTime)).AsInteger;
      RecAR.AR_MATERIAL_TOLLERANCE_CODE := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_Material_Tollerance_Types_Code)).AsString;
      RecAR.AR_HOURSTODOWNFROMMACHINE := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_HoursToDownFromMachine)).AsInteger;

      try
        RecAR.AR_Ignor_Mat_check := false;
      except
      end;

      ListAR.add(RecAR);
      ArcQry.Next;
      Application.ProcessMessages;
    end;
  end;

  HostQry.close;
  ListAR.Sort(SortAR);

  for IndexAR := ListAR.Count - 1 downto 0 do
  begin
    if IndexAR = 0 then break;
    if pRecAR(ListAR[IndexAR]).AR_ArtProdType <> pRecAR(ListAR[IndexAR - 1]).AR_ArtProdType then continue;
    if pRecAR(ListAR[IndexAR]).AR_ProdCode <> pRecAR(ListAR[IndexAR - 1]).AR_ProdCode then continue;
    ListAR.Delete(IndexAR);
  end;
  IndexAR := 0;

  InsertQryTables(tbl,fldList,QryAR);

  with srvQry do
  begin
    SQL.Clear;
    UpdateOperation(_('Updating') + '  ' + tbInfo.GetTableName + ' ' + (_('from host . . .')));
    SQL.Add('Select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) + ' order by PAR_TYPE_PROD, PAR_PRODUCT_CODE');
    open;
    while true do
    begin

      if (IndexAR > ListAR.count - 1) and srvQry.Eof then break;

      if (IndexAR > ListAR.count - 1) or
        ((IndexAR <= ListAR.count - 1) and (not srvQry.Eof) and
         (pRecAR(ListAR[IndexAR]).AR_ArtProdType > Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString))) or
        ((IndexAR <= ListAR.count - 1) and (not srvQry.Eof) and
          (pRecAR(ListAR[IndexAR]).AR_ArtProdType = Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString)) and
         (pRecAR(ListAR[IndexAR]).AR_ProdCode > Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString))) then
      begin

        with QryDel do
        begin
          Sql.Clear;
          Sql.Add(' select * from ' + tbInfoMT.GetTableName + ' where ');
          Sql.Add('MT_TYPE_PROD ' + '=''' + Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString) + '''' + ' and');
          Sql.Add('MT_PRODUCT_CODE ' + '=''' + Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString) + '''');
          Sql.Add(AND_IDF_Condition(CreateFld(tbInfoMT.pfx, fli_IDENTIFIER)));
          Open;
          if not eof then
          begin
            srvQry.next;
            Application.ProcessMessages;
            continue;
          end;

          RQ_HDR_PRODUCTS := 'RQ_HDR_PRODUCTS';
          if DndArchiveLocalName <> TD_Interbase then
             RQ_HDR_PRODUCTS := 'SCDM_' + RQ_HDR_PRODUCTS;

          Sql.Clear;
          Sql.Add(' select * from ' + RQ_HDR_PRODUCTS + ' where');
          Sql.Add('PH_TYPE_PROD ' + '=''' + Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString) + '''' + ' and');
          Sql.Add('PA_PRODUCT_CODE ' + '=''' + Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString) + '''');
          Sql.Add(AND_IDF_Condition(RQ_HDR_PRODUCTS +'.'+ 'PH_IDENTIFIER'));
          Open;

          if not eof then
          begin
            srvQry.next;
            Application.ProcessMessages;
            continue;
          end;

          Sql.Clear;
          Sql.Add(' delete from ' + tbInfo.GetTableName + ' where');
          Sql.Add(' PAR_TYPE_PROD ' + '=''' + Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString) + '''' + ' AND ');
          Sql.Add(' PAR_PRODUCT_CODE ' + '=''' + Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString) + '''');
          Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
          ExecSQL;

        end;
        srvQry.next;
        Application.ProcessMessages;
        continue;
      end;

     if srvQry.Eof or
      ((IndexAR <= ListAR.count - 1) and (not srvQry.Eof) and
        (pRecAR(ListAR[IndexAR]).AR_ArtProdType < Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString))) or
      ((IndexAR <= ListAR.count - 1) and (not srvQry.Eof) and
        (pRecAR(ListAR[IndexAR]).AR_ArtProdType = Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString)) and
        (pRecAR(ListAR[IndexAR]).AR_ProdCode < Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString))) then
      begin
        //  Insert into products from memory
        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).Value := IniAppGlobals.Identifier;
        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_ProdType)).Value := pRecAR(ListAR[IndexAR]).AR_ArtProdType;
        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).Value := pRecAR(ListAR[IndexAR]).AR_ProdCode;
        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_ProductNature)).Value := pRecAR(ListAR[IndexAR]).AR_ProductNature;
        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_StartConsumPoint)).Value := pRecAR(ListAR[IndexAR]).AR_StartConsumPoint;
        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_EndConsumPoint)).Value := pRecAR(ListAR[IndexAR]).AR_EndConsumPoint;
        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_InfoArea)).Value := pRecAR(ListAR[IndexAR]).AR_InfoArea;
        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_Material_Tollerance_Types_Code)).Value := pRecAR(ListAR[IndexAR]).AR_MATERIAL_TOLLERANCE_CODE;
        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_StdPurcOrProdTime)).Value := pRecAR(ListAR[IndexAR]).AR_StdPurcOrProdTime;
        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_HoursToDownFromMachine)).Value := pRecAR(ListAR[IndexAR]).AR_HOURSTODOWNFROMMACHINE;

        QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_IgnorMaterialCheck)).Value := '0';
        if pRecAR(ListAR[IndexAR]).AR_Ignor_Mat_check then
          QryAR.Params.ParamByName(CreateFld(tbInfo.pfx, fli_IgnorMaterialCheck)).Value := '1';
        try
          QryAR.ExecSQL;
        except

        end;
        IndexAR := IndexAR + 1;
        Application.ProcessMessages;
        continue;
      end;

      IgnorMaterialCheck := false;
      try
        if (srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_IgnorMaterialCheck)).AsString = '1') then
            IgnorMaterialCheck := true;
      except
      end;

   //   if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') then
   //   begin
           // Key is equal //

        if ((pRecAR(ListAR[IndexAR]).AR_ProductNature) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProductNature)).AsString)) or
            ((pRecAR(ListAR[IndexAR]).AR_StartConsumPoint <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_StartConsumPoint)).AsString)) or
            ((pRecAR(ListAR[IndexAR]).AR_EndConsumPoint <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_EndConsumPoint)).AsString)) or
            (pRecAR(ListAR[IndexAR]).AR_MATERIAL_TOLLERANCE_CODE <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Material_Tollerance_Types_Code)).AsString)) or
            ((pRecAR(ListAR[IndexAR]).AR_Ignor_Mat_check <> IgnorMaterialCheck)) or
            ((pRecAR(ListAR[IndexAR]).AR_StdPurcOrProdTime <> srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_StdPurcOrProdTime)).AsInteger)) or
            ((pRecAR(ListAR[IndexAR]).AR_HOURSTODOWNFROMMACHINE <> srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_HoursToDownFromMachine)).AsInteger)) or
            (pRecAR(ListAR[IndexAR]).AR_InfoArea <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_InfoArea)).AsString)))) then
        begin

          with QryUpdate do
          begin
            IgnorMaterial := '0';
            if pRecAR(ListAR[IndexAR]).AR_Ignor_Mat_check then
            IgnorMaterial := '1';

            Sql.Clear;
            Sql.Add('update ' + tbInfo.GetTableName + ' set ');
            Sql.Add('PAR_PRODUT_NATURE = :PAR_PRODUT_NATURE,');
            Sql.Add('PAR_STR_CONS_POINT = :PAR_STR_CONS_POINT,');
            Sql.Add('PAR_END_CONS_POINT = :PAR_END_CONS_POINT,');
            Sql.Add('PAR_StdPurcOrProdTime = :PAR_StdPurcOrProdTime,');
            Sql.Add('PAR_MATERIAL_TOLLERANCE_CODE = :PAR_MATERIAL_TOLLERANCE_CODE,');
            Sql.Add('PAR_IGNOR_MAT_CHECK = :PAR_IGNOR_MAT_CHECK,');
            Sql.Add('PAR_HOURSTODOWNFROMMACHINE = :PAR_HOURSTODOWNFROMMACHINE,');
            Sql.Add(' PAR_INFO_AREA = :PAR_INFO_AREA');
            Sql.Add(' Where');
            Sql.Add(' PAR_TYPE_PROD = :PAR_TYPE_PROD');
            Sql.Add(' And');
            Sql.Add(' PAR_PRODUCT_CODE = :PAR_PRODUCT_CODE');
            Sql.Add(AND_IDF_Condition('PAR_IDENTIFIER'));
            ParamByName('PAR_PRODUT_NATURE').Value := pRecAR(ListAR[IndexAR]).AR_ProductNature;
            ParamByName('PAR_STR_CONS_POINT').Value := pRecAR(ListAR[IndexAR]).AR_StartConsumPoint;
            ParamByName('PAR_END_CONS_POINT').Value := pRecAR(ListAR[IndexAR]).AR_EndConsumPoint;
            ParamByName('PAR_IGNOR_MAT_CHECK').Value      := IgnorMaterial;
            ParamByName('PAR_INFO_AREA').Value      := pRecAR(ListAR[IndexAR]).AR_InfoArea;
            ParamByName('PAR_MATERIAL_TOLLERANCE_CODE').Value  := pRecAR(ListAR[IndexAR]).AR_MATERIAL_TOLLERANCE_CODE;
            ParamByName('PAR_TYPE_PROD').Value      := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString;
            ParamByName('PAR_PRODUCT_CODE').Value   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString;
            ParamByName('PAR_StdPurcOrProdTime').Value := pRecAR(ListAR[IndexAR]).AR_StdPurcOrProdTime;
            ParamByName('PAR_HOURSTODOWNFROMMACHINE').Value := pRecAR(ListAR[IndexAR]).AR_HOURSTODOWNFROMMACHINE;

           // Prepare;
            ExecSQL;
          end;
        end;
     // end

     { else
      begin
        if ((pRecAR(ListAR[IndexAR]).AR_ProductNature) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProductNature)).AsString)) or
            ((pRecAR(ListAR[IndexAR]).AR_StartConsumPoint <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_StartConsumPoint)).AsString)) or
            ((pRecAR(ListAR[IndexAR]).AR_Ignor_Mat_check <> IgnorMaterialCheck )) or
            ((pRecAR(ListAR[IndexAR]).AR_EndConsumPoint <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_EndConsumPoint)).AsString)) or
            (pRecAR(ListAR[IndexAR]).AR_InfoArea <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_InfoArea)).AsString)))) then
        begin

          IgnorMaterial := '0';
          if pRecAR(ListAR[IndexAR]).AR_Ignor_Mat_check then
          IgnorMaterial := '1';

          with QryUpdate do
          begin
            Sql.Clear;
            Sql.Add('update products set ');
            Sql.Add('PAR_PRODUT_NATURE = :PAR_PRODUT_NATURE,');
            Sql.Add('PAR_STR_CONS_POINT = :PAR_STR_CONS_POINT,');
            Sql.Add('PAR_END_CONS_POINT = :PAR_END_CONS_POINT,');
            Sql.Add('PAR_IGNOR_MAT_CHECK = :PAR_IGNOR_MAT_CHECK,');
            Sql.Add(' PAR_INFO_AREA = :PAR_INFO_AREA');
            Sql.Add(' Where');
            Sql.Add(' PAR_TYPE_PROD = :PAR_TYPE_PROD');
            Sql.Add(' And');
            Sql.Add(' PAR_PRODUCT_CODE = :PAR_PRODUCT_CODE');
            ParamByName('PAR_PRODUT_NATURE').Value := pRecAR(ListAR[IndexAR]).AR_ProductNature;
            ParamByName('PAR_STR_CONS_POINT').Value := pRecAR(ListAR[IndexAR]).AR_StartConsumPoint;
            ParamByName('PAR_END_CONS_POINT').Value := pRecAR(ListAR[IndexAR]).AR_EndConsumPoint;
            ParamByName('PAR_IGNOR_MAT_CHECK').Value  := IgnorMaterial;
            ParamByName('PAR_INFO_AREA').Value      := pRecAR(ListAR[IndexAR]).AR_InfoArea;
            ParamByName('PAR_TYPE_PROD').Value      := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString;
            ParamByName('PAR_PRODUCT_CODE').Value   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString;
            Prepare;
            ExecSQL;
          end;
        end;        }
    //  end;

      srvQry.Next;
      Application.ProcessMessages;
      IndexAR := IndexAR + 1;
    end;
  end;

  for IndexAR := 0 to ListAR.count - 1 do
     dispose(pRecAR(ListAR[IndexAR]));

  ListAR.Free;

  QryAr.Connection.commit;
  QryDel.Connection.commit;
  QryUpdate.Connection.commit;

  QryAr.Close;
  QryAr.Free;
  QryDel.Close;
  QryDel.Free;
  QryUpdate.Close;
  QryUpdate.Free;
end;

{function LoadProducts(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldListMcm : array [0..6] of TQryLinkRec = (
    (fldPC: fli_ProdType;             fldAS: 'CRECTY'; fldType: TLD_string),
    (fldPC: fli_ProdCode;             fldAS: 'CPRDCD'; fldType: TLD_string),
    (fldPC: fli_ProductNature;        fldAS: 'CPRDNT'; fldType: TLD_string),
    (fldPC: fli_StartConsumPoint;     fldAS: 'CFLSTR'; fldType: TLD_string),
    (fldPC: fli_EndConsumPoint;       fldAS: 'CFLEND'; fldType: TLD_string),
    (fldPC: fli_InfoArea;             fldAS: 'CDESCR'; fldType: TLD_string),
    (fldPC: fli_StdPurcOrProdTime;    fldAS: 'CSTDTM'; fldType: TLD_integer)
  );

  fldListMqm : array [0..5] of TQryLinkRec = (
    (fldPC: fli_ProdType;             fldAS: 'CRECTY'; fldType: TLD_string),
    (fldPC: fli_ProdCode;             fldAS: 'CPRDCD'; fldType: TLD_string),
    (fldPC: fli_ProductNature;        fldAS: 'CPRDNT'; fldType: TLD_string),
    (fldPC: fli_StartConsumPoint;     fldAS: 'CFLSTR'; fldType: TLD_string),
    (fldPC: fli_EndConsumPoint;       fldAS: 'CFLEND'; fldType: TLD_string),
    (fldPC: fli_InfoArea;             fldAS: 'CDESCR'; fldType: TLD_string)
  );

begin
  Assert(tbl = tbl_products);
  if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') and (DndArchiveName = TD_PC_MqmDfn) then // mcm
  begin
    Result := LoadTable(tbl, AS400Speclib, 'where CANNUL' + CAnnulFilter,
                      fldListMcm, srvQry, HostQry)
  end
  else
    Result := LoadTable(tbl, AS400Speclib, 'where CANNUL' + CAnnulFilter,
                      fldListMqm, srvQry, HostQry)


end;  }

//----------------------------------------------------------------------------//

function SortSD(Item1, Item2: Pointer) : integer;
var
  MQMSD1 : pRecSD;
  MQMSD2 : pRecSD;
begin
  MQMSD1 := pRecSD(Item1);
  MQMSD2 := pRecSD(Item2);

  if MQMSD1.SD_BalanceIdentifier < MQMSD2.SD_BalanceIdentifier then
    Result := -1
  else if (MQMSD1.SD_BalanceIdentifier = MQMSD2.SD_BalanceIdentifier) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function LoadStockDetail(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..6] of TQryLinkRec = (
    (fldPC: fli_IDENTIFIER;           fldAS: ''; fldType: TLD_Integer),
    (fldPC: fli_BalanceIdentifier;    fldAS: ''; fldType: TLD_Integer),
    (fldPC: fli_prodtype;             fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ProdCode;             fldAS: ''; fldType: TLD_string),
    (fldPC: fli_netGroupCode;         fldAS: ''; fldType: TLD_string),
    (fldPC: fli_Details;              fldAS: ''; fldType: TLD_string),
    (fldPC: fli_used;                 fldAS: ''; fldType: TLD_string)
   );

var
  OrderBy : string;
  RecSD   : pRecSD;
  ListSD  : TList;
  tbInfo:         ^TTblInfo;
  IndexSD : Integer;
  QrySD, QryDel, QryUpdate : TMqmQuery;
  DndArchiveHostName : TDndArchiveName;
  ArcQry: TMqmQuery;
begin
  DndArchiveHostName := GetDndArchiveHostName;
  Result := true;
  if DndArchiveHostName = TD_AS_400 then
     Exit;

  Assert(tbl = tbl_StockDetails);
  tbInfo := @tblInfo[tbl];
  QrySD := CreateQuery(Main_DB);
  QrySD.Transaction := CreateTransaction(Main_DB);
  QrySD.Transaction.StartTransaction;

  QryDel := CreateQuery(Main_DB);
  QryDel.Transaction := CreateTransaction(Main_DB);
  QryDel.Transaction.StartTransaction;

  QryUpdate := CreateQuery(Main_DB);
  QryUpdate.Transaction := CreateTransaction(Main_DB);
  QryUpdate.Transaction.StartTransaction;

  OrderBy := ' Order by ' + CreateFld(tbInfo.pfx, fli_BalanceIdentifier);

  ListSD := TList.Create;
  UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
  Result := OpenQryTables(tbl, AS400Speclib,'',OrderBy,
                      fldList, HostQry, ArcQry, true);
  IndexSD := 0;

  var fldSD_BalanceId    := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fldList[1].fldPC));
  var fldSD_prodtype     := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fldList[2].fldPC));
  var fldSD_ProdCode     := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fldList[3].fldPC));
  var fldSD_netGroupCode := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fldList[4].fldPC));
  var fldSD_Details      := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fldList[5].fldPC));
  while not ArcQry.Eof do
  begin
    New(RecSD);
    RecSD.SD_BalanceIdentifier := fldSD_BalanceId.AsInteger;
    RecSD.SD_prodtype          := Trim(fldSD_prodtype.AsString);
    RecSD.SD_ProdCode          := Trim(fldSD_ProdCode.AsString);
    RecSD.SD_netGroupCode      := Trim(fldSD_netGroupCode.AsString);
    RecSD.SD_Details           := Trim(fldSD_Details.AsString);
    ListSD.add(RecSD);
    ArcQry.Next;
    Application.ProcessMessages;
  end;
  ArcQry.close;
  ListSD.Sort(SortSD);

  srvQry.SQL.Clear;
  srvQry.SQL.Add('delete from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
  srvQry.ExecSQL;

  InsertQryTables(tbl,fldList,QrySD);
  with srvQry do
  begin
    SQL.Clear;
    UpdateOperation(_('Updating') + '  ' + tbInfo.GetTableName + ' ' + (_('from host . . .')));

    SQL.clear;
    SQL.Add('Select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) + ' order by SD_BALANCEID');
    open;

    while true do
    begin

      if (IndexSD > ListSD.count - 1) and srvQry.Eof then break;

      if (IndexSD > ListSD.count - 1) or

        ((IndexSD <= ListSD.count - 1) and (not srvQry.Eof) and
         (pRecSD(ListSD[IndexSD]).SD_BalanceIdentifier > srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_BalanceIdentifier)).AsInteger)) then

      begin
        QryDel.SQL.Clear;
        QryDel.SQL.Add('delete from ' + tbInfo.GetTableName + ' where ');
        QryDel.SQL.Add(CreateFld(tbInfo.pfx, fli_BalanceIdentifier) + ' = ''' + IntToStr(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_BalanceIdentifier)).AsInteger) + '''');
        Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
      //  QryDel.Prepare;
        QryDel.ExecSQL;
        srvQry.next;
        Application.ProcessMessages;
        continue;
      end;

     if srvQry.Eof or

        ((IndexSD <= ListSD.count - 1) and (not srvQry.Eof) and
        (pRecSD(ListSD[IndexSD]).SD_BalanceIdentifier < srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_BalanceIdentifier)).AsInteger)) then

      begin
        QrySD.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger := StrToInt(IniAppGlobals.Identifier);
        QrySD.ParamByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString := pRecSD(ListSD[IndexSD]).SD_prodtype;
        QrySD.ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString := pRecSD(ListSD[IndexSD]).SD_ProdCode;
        QrySD.ParamByName(CreateFld(tbInfo.pfx, fli_netGroupCode)).AsString := pRecSD(ListSD[IndexSD]).SD_netGroupCode;
        QrySD.ParamByName(CreateFld(tbInfo.pfx, fli_Details)).AsString := pRecSD(ListSD[IndexSD]).SD_Details;
        QrySD.ParamByName(CreateFld(tbInfo.pfx, fli_used)).AsString := '0';
        QrySD.ParamByName(CreateFld(tbInfo.pfx, fli_BalanceIdentifier)).AsInteger := pRecSD(ListSD[IndexSD]).SD_BalanceIdentifier;
        QrySD.ExecSQL;
        IndexSD := IndexSD + 1;
        Application.ProcessMessages;
        continue;
      end;

         // Key is equal //

      if ((pRecSD(ListSD[IndexSD]).SD_Details) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Details)).AsString)) or
         ((pRecSD(ListSD[IndexSD]).SD_prodtype) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString)) or
         ((pRecSD(ListSD[IndexSD]).SD_ProdCode) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString)) or
         ((pRecSD(ListSD[IndexSD]).SD_netGroupCode) <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_netGroupCode)).AsString)) then

      begin
        with QryUpdate do
        begin
          Sql.Clear;
          Sql.Add('update ' + tbInfo.GetTableName + ' set ');
          Sql.Add(CreateFld(tbInfo.pfx, fli_Details) + ' = ''' + pRecSD(ListSD[IndexSD]).SD_Details + '''' + ',');
          Sql.Add(CreateFld(tbInfo.pfx, fli_ProdType) + ' = ''' + pRecSD(ListSD[IndexSD]).SD_prodtype + '''' + ',');
          Sql.Add(CreateFld(tbInfo.pfx, fli_ProdCode) + ' = ''' + pRecSD(ListSD[IndexSD]).SD_ProdCode + '''' + ',');
          Sql.Add(CreateFld(tbInfo.pfx, fli_netGroupCode) + ' = ''' + pRecSD(ListSD[IndexSD]).SD_netGroupCode + '''');
          Sql.Add(' Where');
          SQL.Add(CreateFld(tbInfo.pfx, fli_BalanceIdentifier) + ' = ''' + IntToStr(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_BalanceIdentifier)).AsInteger) + '''');
          Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
         // Prepare;
          ExecSQL;
        end;
      end;
      srvQry.Next;
      Application.ProcessMessages;
      IndexSD := IndexSD + 1;
    end;
  end;

  for IndexSD := 0 to ListSD.count - 1 do
     dispose(pRecSD(ListSD[IndexSD]));

  QrySD.connection.commit;
  QryDel.connection.commit;
  QryUpdate.connection.commit;
  QrySD.Close;
  QrySD.Free;
  QryDel.Close;
  QryDel.Free;
  QryUpdate.Close;
  QryUpdate.Free;
end;

//----------------------------------------------------------------------------//

function SortBH(Item1, Item2: Pointer) : integer;
var
  MQMBH1 : pRecBH;
  MQMBH2 : pRecBH;
begin
  MQMBH1 := pRecBH(Item1);
  MQMBH2 := pRecBH(Item2);

  if MQMBH1.BH_ProdType < MQMBH2.BH_ProdType then
     Result := -1
  else if (MQMBH1.BH_ProdType = MQMBH2.BH_ProdType) then
  begin
    if (MQMBH1.BH_ProdCode < MQMBH2.BH_ProdCode) then
       Result := -1
    else if (MQMBH1.BH_ProdCode = MQMBH2.BH_ProdCode) then
    begin
      if (MQMBH1.BH_netGroupCode < MQMBH2.BH_netGroupCode) then
        Result := -1
      else if (MQMBH1.BH_netGroupCode = MQMBH2.BH_netGroupCode) then
      begin
        if (MQMBH1.BH_dueDate < MQMBH2.BH_dueDate) then
          Result := -1
        else if (MQMBH1.BH_dueDate = MQMBH2.BH_dueDate) then
        begin
          if (MQMBH1.BH_InfoArea < MQMBH2.BH_InfoArea) then
            Result := -1
          else if (MQMBH1.BH_InfoArea = MQMBH2.BH_InfoArea) then
            Result := 0
          else
            Result := 1
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

function LoadBalanceHeader(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..7] of TQryLinkRec = (
    (fldPC: fli_ProdType;             fldAS: 'DRECTY'; fldType: TLD_string),
    (fldPC: fli_InfoArea;             fldAS: 'DINFAR'; fldType: TLD_string),
    (fldPC: fli_ProdCode;             fldAS: 'DPRDCD'; fldType: TLD_string),
    (fldPC: fli_netGroupCode;         fldAS: 'DNETCD'; fldType: TLD_string),
    (fldPC: fli_dueDate;              fldAS: 'DDUEDT'; fldType: TLD_dateTime),
    (fldPC: fli_quant;                fldAS: 'DQUANT'; fldType: TLD_float),
    (fldPC: fli_usrCg;                fldAS: 'DUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;              fldAS: 'DDTOCH'; fldType: TLD_dateTime)
   );

  fldListPC: array [0..8] of TQryLinkRec = (
    (fldPC: fli_IDENTIFIER;           fldAS: '';       fldType: TLD_string),
    (fldPC: fli_ProdType;             fldAS: 'DRECTY'; fldType: TLD_string),
    (fldPC: fli_InfoArea;             fldAS: 'DINFAR'; fldType: TLD_string),
    (fldPC: fli_ProdCode;             fldAS: 'DPRDCD'; fldType: TLD_string),
    (fldPC: fli_netGroupCode;         fldAS: 'DNETCD'; fldType: TLD_string),
    (fldPC: fli_dueDate;              fldAS: 'DDUEDT'; fldType: TLD_dateTime),
    (fldPC: fli_orig_duedate;         fldAS: ' ';      fldType: TLD_dateTime),
    (fldPC: fli_quant;                fldAS: 'DQUANT'; fldType: TLD_float),
  //  (fldPC: fli_usrCg;                fldAS: 'DUSRCH'; fldType: TLD_string),
  //  (fldPC: fli_usrTmCg;              fldAS: 'DDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_index;                fldAS: '' ;      fldType: TLD_integer)
   );

var
  OrderBy : string;
  RecBH   : pRecBH;
  ListBH  : TList;
  ListBH_Local : TList;
  tbInfo:         ^TTblInfo;
  IndexBH : Integer;
  IndexBH_Local : Integer;
  DateTimeFormat : TDateTimeFormat;
  QryBH, QryDel, QryUpdate : TMqmQuery;
  Tmp_Date : Tdatetime;
  Tmp_Date1 : Tdatetime;
  TblIndex : longInt;
  DndArchiveHostName : TDndArchiveName;
  ArcQry: TMqmQuery;
  QtyHostCurr ,QtyLocalCurr : Currency;
  QtyHost, QtyLocal : Integer;
//  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
begin
  Assert(tbl = tbl_balance_header);
  tbInfo := @tblInfo[tbl];
  QryBH := ThreadCreateQuery(Main_DB);
  QryDel := ThreadCreateQuery(Main_DB);
  QryUpdate := ThreadCreateQuery(Main_DB);
  IndexBH := 0;
  TblIndex := 0;
  Tmp_Date := 0;
  Tmp_Date1 := 0;

  DndArchiveHostName := GetDndArchiveHostName;
  DateTimeFormat := GetDateTimeFormat;
  if (Trim(IniAppGlobals.PreparationExeName) = '') then
  begin
    if DndArchiveHostName = TD_AS_400 then
      OrderBy := ' Order by DRECTY,DINFAR,DPRDCD,DNETCD,DDUEDT '
    else
      OrderBy := ' Order by ' + CreateFld(tbInfo.pfx, fli_ProdType) + ',' +
                                CreateFld(tbInfo.pfx, fli_InfoArea)  + ',' +
                                CreateFld(tbInfo.pfx, fli_ProdCode)  + ',' +
                                CreateFld(tbInfo.pfx, fli_netGroupCode)  + ',' +
                                CreateFld(tbInfo.pfx, fli_dueDate);

    ListBH := TList.Create;
    UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
    Result := OpenQryTables(tbl, AS400Speclib,'',OrderBy,
                        fldList, HostQry, ArcQry, true);
  //  RecBH := nil;

    while not HostQry.Eof do
    begin

      if (DateTimeFormat = Frm_As400) then
      begin
        Tmp_Date  := TimDateTimeToDateTime(HostQry.FieldByName(fldList[4].fldAS).AsFloat);
        Tmp_Date1 := TimDateTimeToDateTime(HostQry.FieldByName(fldList[7].fldAS).AsFloat);
      end;

      if (DateTimeFormat = Frm_TDateTime) then
      begin
        if DndArchiveHostName = TD_AS_400 then
        begin
          Tmp_Date  := HostQry.FieldByName((fldList[4].fldAS)).AsDateTime;
          Tmp_Date1 := HostQry.FieldByName((fldList[7].fldAS)).AsDateTime;
        end
        else
        begin
          Tmp_Date  := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[4].fldPC)).AsDateTime;
          Tmp_Date1 := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[7].fldPC)).AsDateTime;
        end;
      end;

      New(RecBH);

      if DndArchiveHostName = TD_AS_400 then
      begin
        RecBH.BH_ProdType      := Trim(HostQry.FieldByName(fldList[0].fldAS).AsString);
        RecBH.BH_InfoArea      := Trim(HostQry.FieldByName(fldList[1].fldAS).AsString);
        RecBH.BH_ProdCode      := Trim(HostQry.FieldByName(fldList[2].fldAS).AsString);
        RecBH.BH_netGroupCode  := Trim(HostQry.FieldByName(fldList[3].fldAS).AsString);
        RecBH.BH_dueDate       := Tmp_Date;
        RecBH.BH_quant         := HostQry.FieldByName(fldList[5].fldAS).AsFloat;
        RecBH.BH_usrCg         := Trim(HostQry.FieldByName(fldList[6].fldAS).AsString);
        RecBH.BH_usrTmCg       := Tmp_Date1;
      end
      else
      begin
        RecBH.BH_ProdType      := Trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[0].fldPC)).AsString);
        RecBH.BH_InfoArea      := Trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[1].fldPC)).AsString);
        RecBH.BH_ProdCode      := Trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[2].fldPC)).AsString);
        RecBH.BH_netGroupCode  := Trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[3].fldPC)).AsString);
        RecBH.BH_dueDate       := Tmp_Date;
        RecBH.BH_quant         := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[5].fldPC)).AsFloat;
        RecBH.BH_usrCg         := Trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[6].fldPC)).AsString);
        RecBH.BH_usrTmCg       := Tmp_Date1;
      end;

      if RecBH.BH_InfoArea = '' then RecBH.BH_InfoArea := ' ';
      if RecBH.BH_netGroupCode = '' then RecBH.BH_netGroupCode := ' ';

      ListBH.add(RecBH);
      HostQry.Next;
      Application.ProcessMessages;
    end;
    HostQry.close;
    ListBH.Sort(SortBH);

  end
  else
  begin
    ListBH := Get_Host_balance_header_list;
    ListBH.Sort(SortBH);
    Merge_Host_balance_header_list(ListBH);
    result := true;
    for IndexBH := 0 to ListBH.Count - 1 do
    begin
      if pRecBH(ListBH[IndexBH]).BH_InfoArea = '' then pRecBH(ListBH[IndexBH]).BH_InfoArea := ' ';
      if pRecBH(ListBH[IndexBH]).BH_netGroupCode = '' then pRecBH(ListBH[IndexBH]).BH_netGroupCode := ' ';
    end;
  end;

  InsertQryTables(tbl,fldListPC,QryBH);
  UpdateOperation(_('Updating') + '  ' + tbInfo.GetTableName + ' ' + (_('from host . . .')));

  // Load local data into list
  ListBH_Local := TList.Create;
  srvQry.SQL.Clear;
  srvQry.SQL.Add('Select * from ' + tbInfo.GetTableName +
                 WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) +
                 ' order by ' + CreateFld(tbInfo.pfx, fli_ProdType) + ',' +
                                CreateFld(tbInfo.pfx, fli_InfoArea) + ',' +
                                CreateFld(tbInfo.pfx, fli_ProdCode) + ',' +
                                CreateFld(tbInfo.pfx, fli_netGroupCode) + ',' +
                                CreateFld(tbInfo.pfx, fli_orig_duedate));
  srvQry.Open;
  while not srvQry.Eof do
  begin
    New(RecBH);
    RecBH.BH_ProdType     := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString);
    RecBH.BH_InfoArea     := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_InfoArea)).AsString);
    RecBH.BH_ProdCode     := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString);
    RecBH.BH_netGroupCode := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_netGroupCode)).AsString);
    RecBH.BH_dueDate      := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_orig_duedate)).AsDateTime;
    RecBH.BH_quant        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_quant)).AsFloat;
    RecBH.BH_TabIndex     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_index)).AsInteger;
    if RecBH.BH_InfoArea = '' then RecBH.BH_InfoArea := ' ';
    if RecBH.BH_netGroupCode = '' then RecBH.BH_netGroupCode := ' ';
    if RecBH.BH_TabIndex > TblIndex then TblIndex := RecBH.BH_TabIndex;
    ListBH_Local.Add(RecBH);
    srvQry.Next;
  end;
  srvQry.Close;
  ListBH_Local.Sort(SortBH);

  // Two-pointer merge: host (ListBH) vs local (ListBH_Local)
  IndexBH := 0;
  IndexBH_Local := 0;
  while true do
  begin
    if (IndexBH > ListBH.count - 1) and (IndexBH_Local > ListBH_Local.count - 1) then break;

    // Local record has no match in host → DELETE
    if (IndexBH > ListBH.count - 1) or

       ((IndexBH <= ListBH.count - 1) and (IndexBH_Local <= ListBH_Local.count - 1) and
        (pRecBH(ListBH[IndexBH]).BH_ProdType > pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdType)) or

       ((IndexBH <= ListBH.count - 1) and (IndexBH_Local <= ListBH_Local.count - 1) and
         (pRecBH(ListBH[IndexBH]).BH_ProdType = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdType) and
        (pRecBH(ListBH[IndexBH]).BH_ProdCode > pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdCode)) or

       ((IndexBH <= ListBH.count - 1) and (IndexBH_Local <= ListBH_Local.count - 1) and
         (pRecBH(ListBH[IndexBH]).BH_ProdType = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdType) and
        (pRecBH(ListBH[IndexBH]).BH_ProdCode = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdCode) and
        (pRecBH(ListBH[IndexBH]).BH_netGroupCode > pRecBH(ListBH_Local[IndexBH_Local]).BH_netGroupCode)) or

       ((IndexBH <= ListBH.count - 1) and (IndexBH_Local <= ListBH_Local.count - 1) and
         (pRecBH(ListBH[IndexBH]).BH_ProdType = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdType) and
        (pRecBH(ListBH[IndexBH]).BH_ProdCode = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdCode) and
        (pRecBH(ListBH[IndexBH]).BH_netGroupCode = pRecBH(ListBH_Local[IndexBH_Local]).BH_netGroupCode) and
        (pRecBH(ListBH[IndexBH]).BH_dueDate > pRecBH(ListBH_Local[IndexBH_Local]).BH_dueDate)) or

       ((IndexBH <= ListBH.count - 1) and (IndexBH_Local <= ListBH_Local.count - 1) and
         (pRecBH(ListBH[IndexBH]).BH_ProdType = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdType) and
        (pRecBH(ListBH[IndexBH]).BH_ProdCode = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdCode) and
        (pRecBH(ListBH[IndexBH]).BH_netGroupCode = pRecBH(ListBH_Local[IndexBH_Local]).BH_netGroupCode) and
        (pRecBH(ListBH[IndexBH]).BH_dueDate = pRecBH(ListBH_Local[IndexBH_Local]).BH_dueDate) and
        (pRecBH(ListBH[IndexBH]).BH_InfoArea > pRecBH(ListBH_Local[IndexBH_Local]).BH_InfoArea)) then

    begin
      QryDel.SQL.Clear;
      QryDel.SQL.Add('delete from ' + tbInfo.GetTableName + ' where ');
      QryDel.SQL.Add(CreateFld(tbInfo.pfx, fli_index) + ' = ' + IntToStr(pRecBH(ListBH_Local[IndexBH_Local]).BH_TabIndex));
      QryDel.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
      SetBalanceHeader_Changed_Send_Client(true);
      QryDel.ExecSQL;
      IndexBH_Local := IndexBH_Local + 1;
      Application.ProcessMessages;
      continue;
    end;

    // Host record has no match in local → INSERT
    if (IndexBH_Local > ListBH_Local.count - 1) or

       ((IndexBH <= ListBH.count - 1) and (IndexBH_Local <= ListBH_Local.count - 1) and
        (pRecBH(ListBH[IndexBH]).BH_ProdType < pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdType)) or

       ((IndexBH <= ListBH.count - 1) and (IndexBH_Local <= ListBH_Local.count - 1) and
         (pRecBH(ListBH[IndexBH]).BH_ProdType = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdType) and
        (pRecBH(ListBH[IndexBH]).BH_ProdCode < pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdCode)) or

       ((IndexBH <= ListBH.count - 1) and (IndexBH_Local <= ListBH_Local.count - 1) and
         (pRecBH(ListBH[IndexBH]).BH_ProdType = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdType) and
        (pRecBH(ListBH[IndexBH]).BH_ProdCode = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdCode) and
        (pRecBH(ListBH[IndexBH]).BH_netGroupCode < pRecBH(ListBH_Local[IndexBH_Local]).BH_netGroupCode)) or

       ((IndexBH <= ListBH.count - 1) and (IndexBH_Local <= ListBH_Local.count - 1) and
         (pRecBH(ListBH[IndexBH]).BH_ProdType = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdType) and
        (pRecBH(ListBH[IndexBH]).BH_ProdCode = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdCode) and
        (pRecBH(ListBH[IndexBH]).BH_netGroupCode = pRecBH(ListBH_Local[IndexBH_Local]).BH_netGroupCode) and
        (pRecBH(ListBH[IndexBH]).BH_dueDate < pRecBH(ListBH_Local[IndexBH_Local]).BH_dueDate)) or

       ((IndexBH <= ListBH.count - 1) and (IndexBH_Local <= ListBH_Local.count - 1) and
         (pRecBH(ListBH[IndexBH]).BH_ProdType = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdType) and
        (pRecBH(ListBH[IndexBH]).BH_ProdCode = pRecBH(ListBH_Local[IndexBH_Local]).BH_ProdCode) and
        (pRecBH(ListBH[IndexBH]).BH_netGroupCode = pRecBH(ListBH_Local[IndexBH_Local]).BH_netGroupCode) and
        (pRecBH(ListBH[IndexBH]).BH_dueDate = pRecBH(ListBH_Local[IndexBH_Local]).BH_dueDate) and
        (pRecBH(ListBH[IndexBH]).BH_InfoArea < pRecBH(ListBH_Local[IndexBH_Local]).BH_InfoArea)) then

    begin
      Inc(TblIndex);
      QryBH.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString     := IniAppGlobals.Identifier;
      QryBH.ParamByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString       := pRecBH(ListBH[IndexBH]).BH_ProdType;
      QryBH.ParamByName(CreateFld(tbInfo.pfx, fli_InfoArea)).AsString       := pRecBH(ListBH[IndexBH]).BH_InfoArea;
      QryBH.ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString       := pRecBH(ListBH[IndexBH]).BH_ProdCode;
      QryBH.ParamByName(CreateFld(tbInfo.pfx, fli_netGroupCode)).AsString   := pRecBH(ListBH[IndexBH]).BH_netGroupCode;
      QryBH.ParamByName(CreateFld(tbInfo.pfx, fli_dueDate)).AsDateTime      := pRecBH(ListBH[IndexBH]).BH_dueDate;
      QryBH.ParamByName(CreateFld(tbInfo.pfx, fli_orig_duedate)).AsDateTime := pRecBH(ListBH[IndexBH]).BH_dueDate;
      QtyHost := Trunc(pRecBH(ListBH[IndexBH]).BH_quant * 100);
      QtyHostCurr := QtyHost/100;
      QryBH.ParamByName(CreateFld(tbInfo.pfx, fli_quant)).AsFloat           := QtyHostCurr;
      QryBH.ParamByName(CreateFld(tbInfo.pfx, fli_index)).AsInteger         := TblIndex;
      try
        QryBH.ExecSQL;
        SetBalanceHeader_Changed_Send_Client(true);
      except
      end;
      IndexBH := IndexBH + 1;
      Application.ProcessMessages;
      continue;
    end;

    // Keys equal → check if quant changed → UPDATE
    if pRecBH(ListBH[IndexBH]).BH_quant <> pRecBH(ListBH_Local[IndexBH_Local]).BH_quant then
    begin

      QtyHost := Trunc(pRecBH(ListBH[IndexBH]).BH_quant * 100);
      QtyLocal := Trunc(pRecBH(ListBH_Local[IndexBH_Local]).BH_quant * 100);

      QtyHostCurr := QtyHost/100;
      QtyLocalCurr := QtyLocal/100;

      if (QtyHostCurr <> QtyLocalCurr) then
      begin
        with QryUpdate do
        begin
          SQL.Clear;
          SQL.Add('update ' + tbInfo.GetTableName + ' set ');
          SQL.Add(CreateFld(tbInfo.pfx, fli_quant) + ' = ''' + FloatToStr(QtyHostCurr) + '''');
          SQL.Add(' where ');
          SQL.Add(CreateFld(tbInfo.pfx, fli_index) + ' = ' + IntToStr(pRecBH(ListBH_Local[IndexBH_Local]).BH_TabIndex));
          SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
          try
            ExecSQL;
            SetBalanceHeader_Changed_Send_Client(true);
          except
          end;
        end;
      end;
    end;
    IndexBH := IndexBH + 1;
    IndexBH_Local := IndexBH_Local + 1;
    Application.ProcessMessages;
  end;

  for IndexBH_Local := 0 to ListBH_Local.count - 1 do
    dispose(pRecBH(ListBH_Local[IndexBH_Local]));
  ListBH_Local.Free;

  for IndexBH := 0 to ListBH.count - 1 do
     dispose(pRecBH(ListBH[IndexBH]));

  ListBH.Free;
  QryBH.connection.commit;
  QryDel.connection.commit;
  QryUpdate.connection.commit;
  QryBH.Close;
  QryBH.Free;
  QryDel.Close;
  QryDel.Free;
  QryUpdate.Close;
  QryUpdate.Free;
end;

{
function LoadBalanceHeader(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..7] of TQryLinkRec = (
    (fldPC: fli_ProdType;             fldAS: 'DRECTY'; fldType: TLD_string),
    (fldPC: fli_InfoArea;             fldAS: 'DINFAR'; fldType: TLD_string),
    (fldPC: fli_ProdCode;             fldAS: 'DPRDCD'; fldType: TLD_string),
    (fldPC: fli_netGroupCode;         fldAS: 'DNETCD'; fldType: TLD_string),
    (fldPC: fli_dueDate;              fldAS: 'DDUEDT'; fldType: TLD_dateTime),
    (fldPC: fli_quant;                fldAS: 'DQUANT'; fldType: TLD_float),
    (fldPC: fli_usrCg;                fldAS: 'DUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;              fldAS: 'DDTOCH'; fldType: TLD_dateTime)
   );
begin
  Assert(tbl = tbl_balance_header);
  Result := LoadTable(tbl, AS400Speclib, '' ,
                      fldList, srvQry, HostQry)
end;
}
//----------------------------------------------------------------------------//

function SortBD(Item1, Item2: Pointer) : integer;
var
  MQMBD1 : pRecBD;
  MQMBD2 : pRecBD;
begin
  MQMBD1 := pRecBD(Item1);
  MQMBD2 := pRecBD(Item2);
  if MQMBD1.BD_ProdType < MQMBD2.BD_ProdType then
     Result := -1
  else if (MQMBD1.BD_ProdType = MQMBD2.BD_ProdType) then
  begin
    if (MQMBD1.BD_ProdCode < MQMBD2.BD_ProdCode) then
       Result := -1
    else if (MQMBD1.BD_ProdCode = MQMBD2.BD_ProdCode) then
    begin
      if (MQMBD1.BD_netGroupCode < MQMBD2.BD_netGroupCode) then
        Result := -1
      else if (MQMBD1.BD_netGroupCode = MQMBD2.BD_netGroupCode) then
      begin
        if (MQMBD1.BD_occupyCode < MQMBD2.BD_occupyCode) then
          Result := -1
        else if (MQMBD1.BD_occupyCode = MQMBD2.BD_occupyCode) then
        begin
          if (MQMBD1.BD_dueDate < MQMBD2.BD_dueDate) then
            Result := -1
          else if (MQMBD1.BD_dueDate = MQMBD2.BD_dueDate) then
          begin
            if (MQMBD1.BD_InfoArea < MQMBD2.BD_InfoArea) then
              Result := -1
            else if (MQMBD1.BD_InfoArea = MQMBD2.BD_InfoArea) then
              Result := 0
            else
              Result := 1
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
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function LoadBalanceDetail(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..6] of TQryLinkRec = (
    (fldPC: fli_dueDate;              fldAS: 'EDUEDT'; fldType: TLD_dateTime),
    (fldPC: fli_InfoArea;             fldAS: 'EINFAR'; fldType: TLD_string),
    (fldPC: fli_netGroupCode;         fldAS: 'ENETCD'; fldType: TLD_string),
    (fldPC: fli_occupyCode;           fldAS: 'EOCUCD'; fldType: TLD_string),
    (fldPC: fli_ProdCode;             fldAS: 'EPRDCD'; fldType: TLD_string),
    (fldPC: fli_quant;                fldAS: 'EQUANT'; fldType: TLD_float),
    (fldPC: fli_ProdType;             fldAS: 'ERECTY'; fldType: TLD_string)
   );
var
  OrderBy : string;
  RecBD   : pRecBD;
  ListBD : TList;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName : TDndArchiveName;
  tbInfo:         ^TTblInfo;
  IndexBD : Integer;
  QryBD,QryDel,QryUpdate : TMqmQuery;
  srvTrs: TMqmTransaction;
  Prev_Check : Boolean;
  Prev_ProdType : string;
  Prev_InfoArea : string;
  Prev_ProdCode : string;
  Prev_OccCode : string;
  Prev_netGroupCode : string;
  Prev_dueDate : Tdatetime;
  Tmp_Date : Tdatetime;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
  ArcQry: TMqmQuery;
begin
  Assert(tbl = tbl_balance_detail);
  DateTimeFormat := GetDateTimeFormat;
  tbInfo := @tblInfo[tbl];
  QryBD := ThreadCreateQuery(Main_DB);
  QryDel := ThreadCreateQuery(Main_DB);
  QryUpdate := ThreadCreateQuery(Main_DB);
  OrderBy := '';
  DndArchiveHostName := GetDndArchiveHostName;
  ListBD := TList.Create;
  UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
  Result := OpenQryTables(tbl, AS400Speclib,'',OrderBy,
                      fldList, HostQry, ArcQry, true);
  Prev_Check := False;
  Prev_dueDate := 0;
  Prev_InfoArea := '';
  Prev_netGroupCode := '';
  Prev_OccCode := '';
  Prev_ProdCode := '';
  Prev_ProdType := '';
  Tmp_Date := 0;
  IndexBD := 0;
  RecBD := nil;

  if DndArchiveHostName = TD_AS_400 then
  begin
    var fldBD_AS0 := HostQry.FieldByName(fldList[0].fldAS); // EDUEDT (dueDate)
    var fldBD_AS1 := HostQry.FieldByName(fldList[1].fldAS); // EINFAR (InfoArea)
    var fldBD_AS2 := HostQry.FieldByName(fldList[2].fldAS); // ENETCD (netGroupCode)
    var fldBD_AS3 := HostQry.FieldByName(fldList[3].fldAS); // EOCUCD (occupyCode)
    var fldBD_AS4 := HostQry.FieldByName(fldList[4].fldAS); // EPRDCD (ProdCode)
    var fldBD_AS5 := HostQry.FieldByName(fldList[5].fldAS); // EQUANT (quant)
    var fldBD_AS6 := HostQry.FieldByName(fldList[6].fldAS); // ERECTY (ProdType)
    while not HostQry.Eof do
    begin
      if (DateTimeFormat = Frm_As400) then
        Tmp_Date := TimDateTimeToDateTime(fldBD_AS0.AsFloat);
      if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
        Tmp_Date := fldBD_AS0.AsDateTime;
      if Prev_Check and
         (Prev_InfoArea = Trim(fldBD_AS1.AsString)) and
         (Prev_netGroupCode = Trim(fldBD_AS2.AsString)) and
         (Prev_OccCode = Trim(fldBD_AS3.AsString)) and
         (Prev_ProdCode = Trim(fldBD_AS4.AsString)) and
         (Prev_ProdType = Trim(fldBD_AS6.AsString)) and
         (Prev_dueDate = Tmp_Date) then
      begin
        RecBD.BD_quant := RecBD.BD_quant + fldBD_AS5.AsFloat;
      end
      else
      begin
        New(RecBD);
        RecBD.BD_InfoArea     := Trim(fldBD_AS1.AsString);
        RecBD.BD_netGroupCode := Trim(fldBD_AS2.AsString);
        RecBD.BD_occupyCode   := Trim(fldBD_AS3.AsString);
        RecBD.BD_ProdCode     := Trim(fldBD_AS4.AsString);
        RecBD.BD_quant        := fldBD_AS5.AsFloat;
        RecBD.BD_ProdType     := Trim(fldBD_AS6.AsString);
        RecBD.BD_dueDate      := Tmp_Date;
        ListBD.add(RecBD);
        Prev_Check        := True;
        Prev_InfoArea     := RecBD.BD_InfoArea;
        Prev_netGroupCode := RecBD.BD_netGroupCode;
        Prev_OccCode      := RecBD.BD_occupyCode;
        Prev_ProdCode     := RecBD.BD_ProdCode;
        Prev_ProdType     := RecBD.BD_ProdType;
        Prev_dueDate      := Tmp_Date;
      end;
      HostQry.Next;
      Application.ProcessMessages;
    end;
  end
  else
  begin
    if not HostQry.Eof then
    begin
    var fldBD_PC0 := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[0].fldPC)); // dueDate
    var fldBD_PC1 := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[1].fldPC)); // InfoArea
    var fldBD_PC2 := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[2].fldPC)); // netGroupCode
    var fldBD_PC3 := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[3].fldPC)); // occupyCode
    var fldBD_PC4 := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[4].fldPC)); // ProdCode
    var fldBD_PC5 := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[5].fldPC)); // quant
    var fldBD_PC6 := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldList[6].fldPC)); // ProdType
    while not HostQry.Eof do
    begin
      Tmp_Date := fldBD_PC0.AsDateTime;
      if Prev_Check and
         (Prev_InfoArea = Trim(fldBD_PC1.AsString)) and
         (Prev_netGroupCode = Trim(fldBD_PC2.AsString)) and
         (Prev_OccCode = Trim(fldBD_PC3.AsString)) and
         (Prev_ProdCode = Trim(fldBD_PC4.AsString)) and
         (Prev_ProdType = Trim(fldBD_PC6.AsString)) and
         (Prev_dueDate = Tmp_Date) then
      begin
        RecBD.BD_quant := RecBD.BD_quant + fldBD_PC5.AsFloat;
      end
      else
      begin
        New(RecBD);
        RecBD.BD_InfoArea     := Trim(fldBD_PC1.AsString);
        RecBD.BD_netGroupCode := Trim(fldBD_PC2.AsString);
        RecBD.BD_occupyCode   := Trim(fldBD_PC3.AsString);
        RecBD.BD_ProdCode     := Trim(fldBD_PC4.AsString);
        RecBD.BD_quant        := fldBD_PC5.AsFloat;
        RecBD.BD_ProdType     := Trim(fldBD_PC6.AsString);
        RecBD.BD_dueDate      := Tmp_Date;
        ListBD.add(RecBD);
        Prev_Check        := True;
        Prev_InfoArea     := RecBD.BD_InfoArea;
        Prev_netGroupCode := RecBD.BD_netGroupCode;
        Prev_OccCode      := RecBD.BD_occupyCode;
        Prev_ProdCode     := RecBD.BD_ProdCode;
        Prev_ProdType     := RecBD.BD_ProdType;
        Prev_dueDate      := Tmp_Date;
      end;
      HostQry.Next;
      Application.ProcessMessages;
    end;
    end; // if not HostQry.Eof
  end;
  HostQry.close;
  ListBD.Sort(SortBD);

  InsertQryTables(tbl,fldList,QryBD);
  with srvQry do
  begin
    SQL.Clear;
    UpdateOperation(_('Updating') + '  ' + tbInfo.GetTableName  + ' ' + (_('from host . . .')));
    SQL.Add('Select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) + ' order by BD_TYPE_PROD,BD_PRODUCT_CODE,BD_NET_GROUP_CODE,BD_OCCUPY_CODE,BD_DUE_DATE,BD_INFO_AREA');
    open;
    var fldBDsrv_ProdType     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType));
    var fldBDsrv_ProdCode     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode));
    var fldBDsrv_netGroupCode := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_netGroupCode));
    var fldBDsrv_dueDate      := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_dueDate));
    var fldBDsrv_InfoArea     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_InfoArea));
    var fldBDsrv_occupyCode   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_occupyCode));
    var fldBDsrv_quant        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_quant));
    while true do
    begin

      if (IndexBD > ListBD.count - 1) and srvQry.Eof then break;

      if (IndexBD > ListBD.count - 1) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
         (pRecBD(ListBD[IndexBD]).BD_ProdType > Trim(fldBDsrv_ProdType.AsString))) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
          (pRecBD(ListBD[IndexBD]).BD_ProdType = Trim(fldBDsrv_ProdType.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_ProdCode > Trim(fldBDsrv_ProdCode.AsString))) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
          (pRecBD(ListBD[IndexBD]).BD_ProdType = Trim(fldBDsrv_ProdType.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_ProdCode = Trim(fldBDsrv_ProdCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_netGroupCode > Trim(fldBDsrv_netGroupCode.AsString))) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
          (pRecBD(ListBD[IndexBD]).BD_ProdType = Trim(fldBDsrv_ProdType.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_ProdCode = Trim(fldBDsrv_ProdCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_netGroupCode = Trim(fldBDsrv_netGroupCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_dueDate > fldBDsrv_dueDate.AsDateTime)) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
          (pRecBD(ListBD[IndexBD]).BD_ProdType = Trim(fldBDsrv_ProdType.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_ProdCode = Trim(fldBDsrv_ProdCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_netGroupCode = Trim(fldBDsrv_netGroupCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_dueDate = fldBDsrv_dueDate.AsDateTime) and
         (pRecBD(ListBD[IndexBD]).BD_InfoArea > Trim(fldBDsrv_InfoArea.AsString))) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
          (pRecBD(ListBD[IndexBD]).BD_ProdType = Trim(fldBDsrv_ProdType.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_ProdCode = Trim(fldBDsrv_ProdCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_netGroupCode = Trim(fldBDsrv_netGroupCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_dueDate = fldBDsrv_dueDate.AsDateTime) and
         (pRecBD(ListBD[IndexBD]).BD_InfoArea = Trim(fldBDsrv_InfoArea.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_occupyCode > Trim(fldBDsrv_occupyCode.AsString))) then

      begin
        tmp_date := fldBDsrv_dueDate.AsDateTime;
        DecodeDateTime(tmp_date, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
        QryDel.SQL.Clear;
        QryDel.SQL.Add('delete from ' + tbInfo.GetTableName + ' where ');
        QryDel.SQL.Add(' BD_TYPE_PROD ' + '=''' + Trim(fldBDsrv_ProdType.AsString) + '''' + ' And ');
        QryDel.SQL.Add(' BD_PRODUCT_CODE ' + '=''' + Trim(fldBDsrv_ProdCode.AsString) + '''' + ' And ');
        QryDel.SQL.Add(' BD_NET_GROUP_CODE ' + '=''' + Trim(fldBDsrv_netGroupCode.AsString) + '''' + ' And ');
        QryDel.SQL.Add(' BD_OCCUPY_CODE ' + '=''' + Trim(fldBDsrv_occupyCode.AsString) + '''' + ' And ');
        QryDel.SQL.Add(' extract(year from bd_due_date)' + '= ' + IntTostr(AYear) + ' And ');
        QryDel.SQL.Add(' extract(month from bd_due_date)' + '= ' + IntTostr(AMonth) + ' And ');
        QryDel.SQL.Add(' extract(day from bd_due_date)' + '= ' + IntTostr(ADay) + ' And ');
        QryDel.SQL.Add(' extract(hour from bd_due_date)' + '= ' + IntTostr(AHour) + ' And ');
        QryDel.SQL.Add(' extract(minute from bd_due_date)' + '= ' + IntTostr(AMinute) + ' And ');
        QryDel.SQL.Add(' extract(second from bd_due_date)' + '= ' + IntTostr(ASecond) + ' And ');
        QryDel.SQL.Add(' BD_INFO_AREA ' + '=''' + Trim(fldBDsrv_InfoArea.AsString) + '''');
        QryDel.SQL.add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));

     //   QryDel.Prepare;
        QryDel.ExecSQL;
        srvQry.next;
        Application.ProcessMessages;
        continue;
      end;

     if srvQry.Eof or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
         (pRecBD(ListBD[IndexBD]).BD_ProdType < Trim(fldBDsrv_ProdType.AsString))) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
          (pRecBD(ListBD[IndexBD]).BD_ProdType = Trim(fldBDsrv_ProdType.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_ProdCode < Trim(fldBDsrv_ProdCode.AsString))) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
          (pRecBD(ListBD[IndexBD]).BD_ProdType = Trim(fldBDsrv_ProdType.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_ProdCode = Trim(fldBDsrv_ProdCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_netGroupCode < Trim(fldBDsrv_netGroupCode.AsString))) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
          (pRecBD(ListBD[IndexBD]).BD_ProdType = Trim(fldBDsrv_ProdType.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_ProdCode = Trim(fldBDsrv_ProdCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_netGroupCode = Trim(fldBDsrv_netGroupCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_dueDate < fldBDsrv_dueDate.AsDateTime)) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
          (pRecBD(ListBD[IndexBD]).BD_ProdType = Trim(fldBDsrv_ProdType.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_ProdCode = Trim(fldBDsrv_ProdCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_netGroupCode = Trim(fldBDsrv_netGroupCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_dueDate = fldBDsrv_dueDate.AsDateTime) and
         (pRecBD(ListBD[IndexBD]).BD_InfoArea < Trim(fldBDsrv_InfoArea.AsString))) or

        ((IndexBD <= ListBD.count - 1) and (not srvQry.Eof) and
         (pRecBD(ListBD[IndexBD]).BD_ProdType = Trim(fldBDsrv_ProdType.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_ProdCode = Trim(fldBDsrv_ProdCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_netGroupCode = Trim(fldBDsrv_netGroupCode.AsString)) and
         (pRecBD(ListBD[IndexBD]).BD_dueDate = fldBDsrv_dueDate.AsDateTime) and
         (pRecBD(ListBD[IndexBD]).BD_InfoArea = Trim(fldBDsrv_InfoArea.AsString)) and
        (pRecBD(ListBD[IndexBD]).BD_occupyCode < Trim(fldBDsrv_occupyCode.AsString))) then

      begin
        //  Insert into products balance from memory
        QryBD.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;
        QryBD.ParamByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString := pRecBD(ListBD[IndexBD]).BD_ProdType;
        QryBD.ParamByName(CreateFld(tbInfo.pfx, fli_InfoArea)).AsString := pRecBD(ListBD[IndexBD]).BD_InfoArea;
        QryBD.ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString := pRecBD(ListBD[IndexBD]).BD_ProdCode;
        QryBD.ParamByName(CreateFld(tbInfo.pfx, fli_netGroupCode)).Asstring := pRecBD(ListBD[IndexBD]).BD_netGroupCode;
        QryBD.ParamByName(CreateFld(tbInfo.pfx, fli_dueDate)).AsDateTime := pRecBD(ListBD[IndexBD]).BD_dueDate;
        QryBD.ParamByName(CreateFld(tbInfo.pfx, fli_quant)).AsFloat := pRecBD(ListBD[IndexBD]).BD_quant;
        QryBD.ParamByName(CreateFld(tbInfo.pfx, fli_occupyCode)).AsString := pRecBD(ListBD[IndexBD]).BD_occupyCode;
        QryBD.ExecSQL;
        IndexBD := IndexBD + 1;
        Application.ProcessMessages;
        continue;
      end;

         // Key is equal //
      if (pRecBD(ListBD[IndexBD]).BD_quant <> fldBDsrv_quant.AsFloat) then
      begin

        with QryUpdate do
        begin
          tmp_date := fldBDsrv_dueDate.AsDateTime;
          DecodeDateTime(tmp_date, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
          Sql.Clear;
          Sql.Add('update ' + tbInfo.GetTableName + ' set ');
          Sql.Add(' BD_QTY ' + '=''' + FloatTostr(pRecBD(ListBD[IndexBD]).BD_quant) + '''');
          Sql.Add(' Where');
          Sql.Add(' BD_TYPE_PROD ' + '=''' + fldBDsrv_ProdType.AsString + '''');
          Sql.Add(' And');
          Sql.Add(' BD_PRODUCT_CODE ' + '=''' + fldBDsrv_ProdCode.AsString + '''');
          Sql.Add(' And');
          Sql.Add(' BD_NET_GROUP_CODE ' + '=''' + fldBDsrv_netGroupCode.AsString + '''');
          Sql.Add(' And');
          SQL.Add(' BD_OCCUPY_CODE ' + '=''' + Trim(fldBDsrv_occupyCode.AsString) + '''');
          Sql.Add(' And');
          SQL.Add(' extract(year from bd_due_date)' + '= ' + IntTostr(AYear) + ' And ');
          SQL.Add(' extract(month from bd_due_date)' + '= ' + IntTostr(AMonth) + ' And ');
          SQL.Add(' extract(day from bd_due_date)' + '= ' + IntTostr(ADay) + ' And ');
          SQL.Add(' extract(hour from bd_due_date)' + '= ' + IntTostr(AHour) + ' And ');
          SQL.Add(' extract(minute from bd_due_date)' + '= ' + IntTostr(AMinute) + ' And ');
          SQL.Add(' extract(second from bd_due_date)' + '= ' + IntTostr(ASecond) + ' And ');
          Sql.Add(' BD_INFO_AREA ' + '=''' + fldBDsrv_InfoArea.AsString + '''');
          SQL.add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
          //Prepare;
          ExecSQL;
        end;
      end;
      srvQry.Next;
      Application.ProcessMessages;
      IndexBD := IndexBD + 1;
    end;
  end;

  for IndexBD := 0 to ListBD.count - 1 do
     dispose(pRecBD(ListBD[IndexBD]));

  ListBD.Free;
  QryBD.connection.commit;
  QryDel.connection.commit;
  QryUpdate.connection.commit;
  QryBD.Close;
  QryBD.Free;
  QryDel.Close;
  QryDel.Free;
  QryUpdate.Close;
  QryUpdate.Free;
end;


{function LoadBalanceDetail(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..6] of TQryLinkRec = (
    (fldPC: fli_dueDate;              fldAS: 'EDUEDT'; fldType: TLD_dateTime),
    (fldPC: fli_InfoArea;             fldAS: 'EINFAR'; fldType: TLD_string),
    (fldPC: fli_netGroupCode;         fldAS: 'ENETCD'; fldType: TLD_string),
    (fldPC: fli_occupyCode;           fldAS: 'EOCUCD'; fldType: TLD_string),
    (fldPC: fli_ProdCode;             fldAS: 'EPRDCD'; fldType: TLD_string),
    (fldPC: fli_quant;                fldAS: 'EQUANT'; fldType: TLD_float),
    (fldPC: fli_ProdType;             fldAS: 'ERECTY'; fldType: TLD_string)
   );
begin
  Assert(tbl = tbl_balance_detail);
  Result := LoadTable(tbl, AS400Speclib, '' ,
                      fldList, srvQry, HostQry)
end; }

//----------------------------------------------------------------------------//

function LoadDownloadTime(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..0] of TQryLinkRec = (
    (fldPC: fli_downloadTime;  fldAS: 'RDTDWN'; fldType: TLD_dateTime)
   );
begin
  Assert(tbl = tbl_download_time);
  Result := LoadDateTime(tbl, AS400Speclib, '' ,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

{function LoadExt_Info(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..4] of TQryLinkRec = (
    (fldPC: fli_ConnKey;     fldAS: 'YCNKEY'; fldType: TLD_string),
    (fldPC: fli_infoLineNum; fldAS: 'YINFLN'; fldType: TLD_integer),
    (fldPC: fli_InfoArea;    fldAS: 'YINFAR'; fldType: TLD_string),
    (fldPC: fli_usrCg;       fldAS: 'YUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;     fldAS: 'YDTOCH'; fldType: TLD_dateTime)
  );
begin
  Assert(tbl = tbl_ext_info);
  Result := LoadTable(tbl, AS400Speclib, '' ,fldList, srvQry, HostQry);
end;  }

//----------------------------------------------------------------------------//

function SortEI(Item1, Item2: Pointer) : integer;
var
  MQMEI1 : pRecEI;
  MQMEI2 : pRecEI;
begin
  MQMEI1 := pRecEI(Item1);
  MQMEI2 := pRecEI(Item2);
  if MQMEI1.EI_ConnKey < MQMEI2.EI_ConnKey then
    Result := -1
  else if (MQMEI1.EI_ConnKey = MQMEI2.EI_ConnKey) then
  begin
    if (MQMEI1.EI_infoLineNum < MQMEI2.EI_infoLineNum) then
      Result := -1
    else if (MQMEI1.EI_infoLineNum = MQMEI2.EI_infoLineNum) then
    begin
      if (MQMEI1.EI_InfoArea < MQMEI2.EI_InfoArea) then
        Result := -1
      else if (MQMEI1.EI_InfoArea = MQMEI2.EI_InfoArea) then
        Result := 0
      else
        Result := 1;
    end
    else
      Result := 1
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function LoadExt_Info(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..5] of TQryLinkRec = (
    (fldPC: fli_IDENTIFIER;  fldAS: '';       fldType: TLD_string),
    (fldPC: fli_ConnKey;     fldAS: 'YCNKEY'; fldType: TLD_string),
    (fldPC: fli_infoLineNum; fldAS: 'YINFLN'; fldType: TLD_integer),
    (fldPC: fli_InfoArea;    fldAS: 'YINFAR'; fldType: TLD_string),
    (fldPC: fli_usrCg;       fldAS: 'YUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;     fldAS: 'YDTOCH'; fldType: TLD_dateTime)
  );

  fldListAS400: array [0..5] of TQryLinkRec = (
    (fldPC: fli_ConnKey;     fldAS: 'YCNKEY'; fldType: TLD_string),
    (fldPC: fli_infoLineNum; fldAS: 'YINFLN'; fldType: TLD_integer),
    (fldPC: fli_InfoArea;    fldAS: 'YINFAR'; fldType: TLD_string),
    (fldPC: fli_usrCg;       fldAS: 'YUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;     fldAS: 'YDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;  fldAS: '';       fldType: TLD_string)
  );

var
  OrderBy, tblArcName : string;
  tbInfo:         ^TTblInfo;
  RecEI   : pRecEI;
  ListEI : TList;
  IndexEI  : Integer;
  QryEI, QryDel, QryUpdate : TMqmQuery;
  Tmp_Date : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName : TDndArchiveName;
  DndArchiveArcName : TDndArchiveName;
  ArcQry: TMqmQuery;
begin
  Assert(tbl = tbl_ext_info);
  tbInfo := @tblInfo[tbl];
  DateTimeFormat := GetDateTimeFormat;
  QryEI := ThreadCreateQuery(Main_DB);
  QryDel := ThreadCreateQuery(Main_DB);
  QryUpdate := ThreadCreateQuery(Main_DB);
  OrderBy := '';
  if (Trim(IniAppGlobals.PreparationExeName) = '') then
    ListEI := TList.Create;
  IndexEI := 0;
  Tmp_Date := 0;

  if (Trim(IniAppGlobals.PreparationExeName) = '') then
  begin
    tblArcName := 'MQMEI00F';
    DndArchiveHostName := GetDndArchiveHostName;
    UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
    Result := OpenQryTables(tbl, AS400Speclib, '', OrderBy,
                      fldListAS400, HostQry, ArcQry, true);

    while not HostQry.Eof do
    begin
      New(RecEI);

      if DndArchiveHostName = TD_AS_400 then
      begin
        if (DateTimeFormat = Frm_As400) then
          Tmp_Date  := TimDateTimeToDateTime(HostQry.FieldByName(fldListAS400[4].fldAS).AsFloat);

        if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
          Tmp_Date  := HostQry.FieldByName(fldListAS400[4].fldAS).AsDateTime;

        RecEI.EI_ConnKey        := Trim(HostQry.FieldByName(fldListAS400[0].fldAS).AsString);
        RecEI.EI_infoLineNum    := HostQry.FieldByName(fldListAS400[1].fldAS).AsInteger;
        RecEI.EI_InfoArea       := Trim(HostQry.FieldByName(fldListAS400[2].fldAS).AsString);
        RecEI.EI_usrCg          := Trim(HostQry.FieldByName(fldListAS400[3].fldAS).AsString);
        RecEI.EI_usrTmCg        := Tmp_Date;
      end

      else
      begin
        Tmp_Date := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldListAS400[4].fldPC)).AsDateTime;
        RecEI.EI_ConnKey        := Trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fldListAS400[0].fldPC)).AsString);
        RecEI.EI_infoLineNum    := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldListAS400[1].fldPC)).AsInteger;
        RecEI.EI_InfoArea       := Trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fldListAS400[2].fldPC)).AsString);
        RecEI.EI_usrCg          := Trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fldListAS400[3].fldPC)).AsString);
        RecEI.EI_usrTmCg        := Tmp_Date;
      end;

      ListEI.add(RecEI);
      Application.ProcessMessages;
      HostQry.Next;
    end;
    HostQry.close;
    ListEI.Sort(SortEI);
    InsertQryTables(tbl,fldListAs400,QryEI);
  end
  else
  begin
    DndArchiveArcName := GetDndArchiveLocalName;
    if DndArchiveArcName = TD_Interbase then
      tblArcName  := 'EXT_INFO'
    else
      tblArcName  := 'SCDM_' + 'EXT_INFO';
    ListEI := Get_Host_ext_info_list;
    ListEI.Sort(SortEI);
    InsertQryTables(tbl,fldList,QryEI);
    Result := true
  end;

  with srvQry do
  begin
    SQL.Clear;
    UpdateOperation(_('Updating') + '  ' + tbInfo.GetTableName + ' ' + (_('from host . . .')));
    SQL.Add('Select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) + ' order by EI_CONNE_KEY, EI_INFO_LINE_NUM');
    open;
    var fldEI_ConnKey     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ConnKey));
    var fldEI_infoLineNum := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_infoLineNum));
    var fldEI_InfoArea    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_InfoArea));
    while true do
    begin

      if (IndexEI > ListEI.count - 1) and srvQry.Eof then break;

      if (IndexEI > ListEI.count - 1) or
        ((IndexEI <= ListEI.count - 1) and (not srvQry.Eof) and
         (pRecEI(ListEI[IndexEI]).EI_ConnKey > Trim(fldEI_ConnKey.AsString))) or
        ((IndexEI <= ListEI.count - 1) and (not srvQry.Eof) and
          (pRecEI(ListEI[IndexEI]).EI_ConnKey = Trim(fldEI_ConnKey.AsString)) and
         (pRecEI(ListEI[IndexEI]).EI_infoLineNum > fldEI_infoLineNum.AsInteger)) then
      begin
        with QryDel do
        begin
          Sql.Clear;
          Sql.Add(' delete from ' + tbInfo.GetTableName + ' where');
          Sql.Add(' EI_CONNE_KEY ' + '=''' + Trim(fldEI_ConnKey.AsString) + '''' + ' AND ');
          Sql.Add(' EI_INFO_LINE_NUM ' + '=''' + IntToStr(fldEI_infoLineNum.AsInteger) + '''');
          Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
        //  Prepare;
          ExecSQL;
        end;
        srvQry.next;
        Application.ProcessMessages;
        continue;
      end;

     if srvQry.Eof or
      ((IndexEI <= ListEI.count - 1) and (not srvQry.Eof) and
        (pRecEI(ListEI[IndexEI]).EI_ConnKey < Trim(fldEI_ConnKey.AsString))) or
      ((IndexEI <= ListEI.count - 1) and (not srvQry.Eof) and
        (pRecEI(ListEI[IndexEI]).EI_ConnKey = Trim(fldEI_ConnKey.AsString)) and
        (pRecEI(ListEI[IndexEI]).EI_infoLineNum < fldEI_infoLineNum.AsInteger)) then
      begin
        //  Insert into products from memory
        QryEI.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;
        QryEI.ParamByName(CreateFld(tbInfo.pfx, fli_ConnKey)).AsString := pRecEI(ListEI[IndexEI]).EI_ConnKey;
        QryEI.ParamByName(CreateFld(tbInfo.pfx, fli_infoLineNum)).AsInteger := pRecEI(ListEI[IndexEI]).EI_infoLineNum;
        QryEI.ParamByName(CreateFld(tbInfo.pfx, fli_InfoArea)).AsString := pRecEI(ListEI[IndexEI]).EI_InfoArea;
        QryEI.ParamByName(CreateFld(tbInfo.pfx, fli_usrCg)).AsString := pRecEI(ListEI[IndexEI]).EI_usrCg;
        QryEI.ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCg)).AsDateTime := pRecEI(ListEI[IndexEI]).EI_usrTmCg;
        QryEI.ExecSQL;
        IndexEI := IndexEI + 1;
        Application.ProcessMessages;
        continue;
      end;

         // Key is equal //
      if ((pRecEI(ListEI[IndexEI]).EI_InfoArea) <> Trim(fldEI_InfoArea.AsString)) then
      begin
        with QryUpdate do
        begin
          Sql.Clear;
          Sql.Add('update ' + tbInfo.GetTableName + ' set ');
          Sql.Add('EI_INFO_AREA = :EI_INFO_AREA');
          Sql.Add(' Where');
          Sql.Add(' EI_CONNE_KEY = :EI_CONNE_KEY');
          Sql.Add(' And');
          Sql.Add(' EI_INFO_LINE_NUM = :EI_INFO_LINE_NUM');
          Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
          ParamByName('EI_INFO_AREA').Value := pRecEI(ListEI[IndexEI]).EI_InfoArea;
          ParamByName('EI_CONNE_KEY').Value := fldEI_ConnKey.AsString;
          ParamByName('EI_INFO_LINE_NUM').Value := IntToStr(fldEI_infoLineNum.AsInteger);
        //  Prepare;
          ExecSQL;
        end;
//        with QryEI do
//        begin
//          Sql.Clear;
//          Sql.Add('update EXT_INFO set ');
//          Sql.Add('EI_INFO_AREA ' + '=''' + pRecEI(ListEI[IndexEI]).EI_InfoArea + '''');
//          Sql.Add(' Where');
//          Sql.Add(' EI_CONNE_KEY ' + '=''' + srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ConnKey)).AsString + '''');
//          Sql.Add(' And');
//          Sql.Add(' EI_INFO_LINE_NUM ' + '=''' + IntToStr(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_infoLineNum)).AsInteger) + '''');
//          Prepare;
//          ExecSQL;
//        end;
      end;
      srvQry.Next;
      Application.ProcessMessages;
      IndexEI := IndexEI + 1;
    end;
  end;

  for IndexEI := 0 to ListEI.count - 1 do
     dispose(pRecEI(ListEI[IndexEI]));

  ListEI.Free;
  QryEI.connection.commit;
  QryDel.connection.commit;
  QryUpdate.connection.commit;
  QryEI.Close;
  QryEI.Free;
  QryDel.Close;
  QryDel.Free;
  QryUpdate.Close;
  QryUpdate.Free;
end;

//----------------------------------------------------------------------------//
{
function LoadExt_InfoHeadr(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..4] of TQryLinkRec = (
    (fldPC: fli_ConnKey;  fldAS: 'WCNKEY'; fldType: TLD_string),
    (fldPC: fli_ConnType; fldAS: 'WCNTYP'; fldType: TLD_string),
    (fldPC: fli_DueDate;  fldAS: 'WDUEDT'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;    fldAS: 'WUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;  fldAS: 'WDTOCH'; fldType: TLD_dateTime)
  );
begin
  Assert(tbl = tbl_ext_infoHdr);
  Result := LoadTable(tbl, AS400Speclib, '' ,fldList, srvQry, HostQry);
end;
 }
//----------------------------------------------------------------------------//

function SortEH(Item1, Item2: Pointer) : integer;
var
  MQMEH1 : PRecEH;
  MQMEH2 : PRecEH;
begin
  MQMEH1 := PRecEH(Item1);
  MQMEH2 := PRecEH(Item2);
  if MQMEH1.EH_ConnKey < MQMEH2.EH_ConnKey then
    Result := -1
  else if (MQMEH1.EH_ConnKey = MQMEH2.EH_ConnKey) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortMDS(Item1, Item2: Pointer) : integer;
var
  MQMEH1 : PRecMS;
  MQMEH2 : PRecMS;
begin
  MQMEH1 := PRecMS(Item1);
  MQMEH2 := PRecMS(Item2);

  if MQMEH1.MS_Type_Prod < MQMEH2.MS_Type_Prod then   //MDS_TYPE_PROD
    Result := -1
  else if (MQMEH1.MS_Type_Prod = MQMEH2.MS_Type_Prod) then
  begin
    if MQMEH1.MS_Product_Code < MQMEH2.MS_Product_Code then  //MDS_PRODUCT_CODE
      Result := -1
    else if MQMEH1.MS_Product_Code = MQMEH2.MS_Product_Code then
    begin
      if MQMEH1.MS_Sub_Detail < MQMEH2.MS_Sub_Detail then  //MDS_PREQ_NO
        Result := -1
      else if MQMEH1.MS_Sub_Detail = MQMEH2.MS_Sub_Detail then
      begin
        if MQMEH1.MS_Detail_Code < MQMEH2.MS_Detail_Code then  //MDS_SUB_DETAIL
          Result := -1
        else if MQMEH1.MS_Detail_Code > MQMEH2.MS_Detail_Code then
          Result := 1
        else
          Result := 0;
      end;
    end
    else
      Result := 1;

  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortMDSL(Item1, Item2: Pointer) : integer;
var
  MQMEH1 : PRecMS;
  MQMEH2 : PRecMS;
begin
  MQMEH1 := PRecMS(Item1);
  MQMEH2 := PRecMS(Item2);

  if MQMEH1.MS_Type_Prod < MQMEH2.MS_Type_Prod then   //MDS_TYPE_PROD
    Result := -1
  else if (MQMEH1.MS_Type_Prod = MQMEH2.MS_Type_Prod) then
  begin
    if MQMEH1.MS_Product_Code < MQMEH2.MS_Product_Code then  //MDS_PRODUCT_CODE
      Result := -1
    else if MQMEH1.MS_Product_Code = MQMEH2.MS_Product_Code then
    begin
      if MQMEH1.MS_Sub_Detail < MQMEH2.MS_Sub_Detail then  //MDS_PREQ_NO
        Result := -1
      else if MQMEH1.MS_Sub_Detail = MQMEH2.MS_Sub_Detail then
      begin
        if MQMEH1.MS_Detail_Code < MQMEH2.MS_Detail_Code then  //MDS_SUB_DETAIL
          Result := -1
        else if MQMEH1.MS_Detail_Code = MQMEH2.MS_Detail_Code then
        begin

          if MQMEH1.MS_Preq_No < MQMEH2.MS_Preq_No then  //MDS_PREQ_NO
            Result := -1
          else if MQMEH1.MS_Preq_No = MQMEH2.MS_Preq_No then
          begin
            if MQMEH1.MS_Step < MQMEH2.MS_Step then  //MDS_SUB_DETAIL
              Result := -1
            else if MQMEH1.MS_Step > MQMEH2.MS_Step then
              result := 1
            else
              result := 0

          end;

        end;

      end;
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function LoadExt_InfoHeadr(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..5] of TQryLinkRec = (
    (fldPC: fli_IDENTIFIER; fldAS: '';     fldType: TLD_string),
    (fldPC: fli_ConnKey;  fldAS: 'WCNKEY'; fldType: TLD_string),
    (fldPC: fli_ConnType; fldAS: 'WCNTYP'; fldType: TLD_string),
    (fldPC: fli_DueDate;  fldAS: 'WDUEDT'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;    fldAS: 'WUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;  fldAS: 'WDTOCH'; fldType: TLD_dateTime)
  );

  fldListAS400 : array [0..5] of TQryLinkRec = (
    (fldPC: fli_ConnKey;  fldAS: 'WCNKEY'; fldType: TLD_string),
    (fldPC: fli_ConnType; fldAS: 'WCNTYP'; fldType: TLD_string),
    (fldPC: fli_DueDate;  fldAS: 'WDUEDT'; fldType: TLD_dateTime),
    (fldPC: fli_usrCg;    fldAS: 'WUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;  fldAS: 'WDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER; fldAS: '';     fldType: TLD_string)
  );

var
  OrderBy, tblArcName : string;
  tbInfo:         ^TTblInfo;
  RecEH   : pRecEH;
  ListEH : TList;
  IndexEH  : Integer;
  QryEH, QryDel, QryUpdate : TMqmQuery;
  srvTrs: TMqmTransaction;
  Tmp_Date,Tmp_Date1 : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word;
  DateAsString: String;
  DndArchiveHostName,DndArchiveArcName : TDndArchiveName;
  ArcQry: TMqmQuery;
begin
  Assert(tbl = tbl_ext_infoHdr);
  tbInfo := @tblInfo[tbl];
  DateTimeFormat := GetDateTimeFormat;
  QryEH := ThreadCreateQuery(Main_DB);
  QryDel := ThreadCreateQuery(Main_DB);
  QryUpdate := ThreadCreateQuery(Main_DB);
  OrderBy := '';
  if (Trim(IniAppGlobals.PreparationExeName) = '') then
    ListEH := TList.Create;

  IndexEH := 0;
  Tmp_Date := 0;
  Tmp_Date1 := 0;

  if (Trim(IniAppGlobals.PreparationExeName) = '') then
  begin
    tblArcName := 'EXT_INFO_HDR';
    UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + ' ' + (_('from host . . .')));
    Result := OpenQryTables(tbl, AS400Speclib, '', OrderBy,
                        fldListAS400, HostQry, ArcQry, true);
    DndArchiveHostName := GetDndArchiveHostName;

    while not HostQry.Eof do
    begin
      New(RecEH);

      if DndArchiveHostName = TD_AS_400 then
      begin

        if (DateTimeFormat = Frm_As400) then
        begin
          try
            Tmp_Date  := TimDateTimeToDateTime(HostQry.FieldByName(fldListAS400[2].fldAS).AsFloat);
          except
            Tmp_Date := 0;
          end;

          try
            Tmp_Date1 := TimDateTimeToDateTime(HostQry.FieldByName(fldListAS400[4].fldAS).AsFloat);
          except
            Tmp_Date1 := 0;
          end;
        end;

        if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
        begin
          Tmp_Date  := HostQry.FieldByName(fldListAS400[2].fldAS).AsDateTime;
          Tmp_Date1 := HostQry.FieldByName(fldListAS400[4].fldAS).AsDateTime;
        end;

        RecEH.EH_ConnKey        := Trim(HostQry.FieldByName(fldListAS400[0].fldAS).AsString);
        RecEH.EH_ConnType       := HostQry.FieldByName(fldListAS400[1].fldAS).AsString;
        RecEH.EH_DueDate        := Tmp_Date;
        RecEH.EH_usrCg          := Trim(HostQry.FieldByName(fldListAS400[3].fldAS).AsString);
        RecEH.EH_usrTmCg        := Tmp_Date1;
      end

      else
      begin
        Tmp_Date  := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldListAS400[2].fldPC)).AsDateTime;
        Tmp_Date1 := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldListAS400[4].fldPC)).AsDateTime;
        RecEH.EH_ConnKey        := Trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fldListAS400[0].fldPC)).AsString);
        RecEH.EH_ConnType       := HostQry.FieldByName(CreateFld(tbInfo.pfx, fldListAS400[1].fldPC)).AsString;
        RecEH.EH_DueDate        := Tmp_Date;
        RecEH.EH_usrCg          := Trim(HostQry.FieldByName(CreateFld(tbInfo.pfx, fldListAS400[3].fldPC)).AsString);
        RecEH.EH_usrTmCg        := Tmp_Date1;
      end;

      ListEH.add(RecEH);
      HostQry.Next;
      Application.ProcessMessages;
    end;
    HostQry.close;
    ListEH.Sort(SortEH);
    InsertQryTables(tbl,fldListAS400,QryEH);
  end
  else
  begin
    DndArchiveArcName := GetDndArchiveLocalName;
    if DndArchiveArcName = TD_Interbase then
      tblArcName  := 'EXT_INFO_HDR'
    else
      tblArcName  := 'SCDM_' + 'EXT_INFO_HDR';
    ListEH := Get_Host_ext_info_hdr_list;
    ListEH.Sort(SortEH);
    InsertQryTables(tbl,fldList,QryEH);
    result := true
  end;

  with srvQry do
  begin
    SQL.Clear;
    UpdateOperation(_('Updating') + '  ' + tbInfo.GetTableName + ' ' + (_('from host . . .')));
    SQL.Add('Select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) + ' order by EH_CONNE_KEY');
    open;
    while true do
    begin

      if (IndexEH > ListEH.count - 1) and srvQry.Eof then break;

      if (IndexEH > ListEH.count - 1) or
        ((IndexEH <= ListEH.count - 1) and (not srvQry.Eof) and
         (pRecEH(ListEH[IndexEH]).EH_ConnKey > Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ConnKey)).AsString))) then
      begin
        with QryDel do
        begin
          Sql.Clear;
          Sql.Add(' delete from ' + tblArcName + ' where');
          Sql.Add(' EH_CONNE_KEY ' + '=''' + Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ConnKey)).AsString) + '''');
          Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
       //   Prepare;
          ExecSQL;
        end;
        srvQry.next;
        Application.ProcessMessages;
        continue;
      end;

     if srvQry.Eof or
      ((IndexEH <= ListEH.count - 1) and (not srvQry.Eof) and
        (pRecEH(ListEH[IndexEH]).EH_ConnKey < Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ConnKey)).AsString))) then
      begin
        //  Insert into products from memory
        QryEH.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;
        QryEH.ParamByName(CreateFld(tbInfo.pfx, fli_ConnKey)).AsString := pRecEH(ListEH[IndexEH]).EH_ConnKey;
        QryEH.ParamByName(CreateFld(tbInfo.pfx, fli_ConnType)).AsString := pRecEH(ListEH[IndexEH]).EH_ConnType;
        QryEH.ParamByName(CreateFld(tbInfo.pfx, fli_DueDate)).AsDateTime := pRecEH(ListEH[IndexEH]).EH_DueDate;
        QryEH.ParamByName(CreateFld(tbInfo.pfx, fli_usrCg)).AsString := pRecEH(ListEH[IndexEH]).EH_usrCg;
        QryEH.ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCg)).AsDateTime := pRecEH(ListEH[IndexEH]).EH_usrTmCg;
      //  try
        QryEH.ExecSQL;
      //  except
      //  end;
        IndexEH := IndexEH + 1;
        Application.ProcessMessages;
        continue;
      end;

         // Key is equal //
      if ((pRecEH(ListEH[IndexEH]).EH_ConnType <> Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ConnType)).AsString)) or
         (pRecEH(ListEH[IndexEH]).EH_DueDate <> srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_DueDate)).AsDateTime)) then
      begin

        with QryUpdate do
        begin
          if (pRecEH(ListEH[IndexEH]).EH_DueDate = 0) then
            DateAsString := '12/30/1899 12:00'
          else
          begin
            tmp_date := pRecEH(ListEH[IndexEH]).EH_DueDate;
            DecodeDateTime(tmp_date, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
            DateAsString := intTostr(Amonth) + '/' + intTostr(Aday) + '/' + intTostr(AYear) + ' ' ;
            DateAsString := DateAsString + intTostr(Ahour) + ':' + intTostr(AMinute) + ':' + intTostr(Asecond);
          end;
          Sql.Clear;
        //  Sql.Add('update EXT_INFO_HDR set ');
        //  Sql.Add('EH_CONNE_TYPE ' + '=''' + pRecEH(ListEH[IndexEH]).EH_ConnType + '''' + ',');
        //  Sql.Add('EH_DUE_DATE ' + '=''' + DateAsString + '''');
        //  Sql.Add(' Where ');
        //  Sql.Add(' EH_CONNE_KEY ' + '=''' + srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ConnKey)).AsString + '''');
          Sql.Add('update ' + tbInfo.GetTableName + ' set ');
          Sql.Add('EH_CONNE_TYPE = :EH_CONNE_TYPE,');
          Sql.Add('EH_DUE_DATE = :EH_DUE_DATE');
          Sql.Add(' Where ');
          Sql.Add(' EH_CONNE_KEY = :EH_CONNE_KEY');
          Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
          ParamByName('EH_CONNE_TYPE').Value := pRecEH(ListEH[IndexEH]).EH_ConnType;
          ParamByName('EH_DUE_DATE').Value := tmp_date;//DateAsString;
          ParamByName('EH_CONNE_KEY').Value := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ConnKey)).AsString;
        //  Prepare;
          ExecSQL;
        end;
      end;
      srvQry.Next;
      Application.ProcessMessages;
      IndexEH := IndexEH + 1;
    end;
  end;

  for IndexEH := 0 to ListEH.count - 1 do
     dispose(pRecEH(ListEH[IndexEH]));

  ListEH.Free;
  QryEH.connection.commit;
  QryDel.connection.commit;
  QryUpdate.connection.commit;
  QryEH.Close;
  QryEH.Free;
  QryDel.Close;
  QryDel.Free;
  QryUpdate.Close;
  QryUpdate.Free;
end;

//----------------------------------------------------------------------------//

function LoadMaterialSchedule(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..12] of TQryLinkRec = (
    (fldPC: fli_IDENTIFIER;     fldAS: '';       fldType: TLD_string),
    (fldPC: fli_ProdType;       fldAS: '';       fldType: TLD_string),
    (fldPC: fli_ProdCode;       fldAS: '';       fldType: TLD_string),
    (fldPC: fli_preqNo;         fldAS: '';       fldType: TLD_string),
    (fldPC: fli_Sub_Detail;     fldAS: '';       fldType: TLD_string),
    (fldPC: fli_Detail_Code;    fldAS: '';       fldType: TLD_string),
    (fldPC: fli_quant;          fldAS: '';       fldType: TLD_Float),
    (fldPC: fli_ProdUMCode;     fldAS: '';       fldType: TLD_string),
    (fldPC: fli_netGroupCode;   fldAS: '';       fldType: TLD_string),
    (fldPC: fli_HostItemIndentifier; fldAS: '';  fldType: TLD_Float),
    (fldPC: fli_HostWarehouse;       fldAS: '';  fldType: TLD_string),
    (fldPC: fli_SubDetailHostType;   fldAS: '';  fldType: TLD_string),
    (fldPC: fli_DetailCodeType;      fldAS: '';  fldType: TLD_string)
  );

var
  OrderBy, tblArcName : string;
  tbInfo:         ^TTblInfo;
  RecMS   : pRecMS;
  ListMS : TList;
  IndexMS  : Integer;
  QryMS, QryDel, QryUpdate : TMqmQuery;
  srvTrs: TMqmTransaction;
  Tmp_Date,Tmp_Date1 : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word;
  DateAsString: String;
  DndArchiveHostName,DndArchiveArcName : TDndArchiveName;
  ArcQry: TMqmQuery;
  i,K : Integer;
begin
  Result := true;

  Assert(tbl = tbl_MaterialDetailSchedule);
  tbInfo := @tblInfo[tbl];
  DateTimeFormat := GetDateTimeFormat;
  QryMS := ThreadCreateQuery(Main_DB);
  QryDel := ThreadCreateQuery(Main_DB);
  QryUpdate := ThreadCreateQuery(Main_DB);
  OrderBy := '';
  if (Trim(IniAppGlobals.PreparationExeName) = '') then exit;

  IndexMS := 0;
  Tmp_Date := 0;
  Tmp_Date1 := 0;


  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'Material_Detail_Schedule'
  else
    tblArcName  := 'SCDM_' + 'Material_Detail_Schedule';
  ListMS := Get_Host_Material_Schedule;

  ListMS.Sort(SortMDS);

  InsertQryTables(tbl,fldList,QryMS);
  result := true;


  with srvQry do
  begin
    SQL.Clear;
    UpdateOperation(_('Updating') + '  ' + tbInfo.GetTableName + ' ' + (_('from host . . .')));
    SQL.Add('Select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER))
    + ' order by MDS_TYPE_PROD, MDS_PRODUCT_CODE, MDS_PREQ_NO, MDS_SUB_DETAIL, MDS_DETAIL_CODE');
    open;
    var fldMS_ProdType    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType));
    var fldMS_ProdCode    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode));
    var fldMS_Sub_Detail  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Sub_Detail));
    var fldMS_Detail_Code := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Detail_Code));
    var fldMS_quant       := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_quant));
    var fldMS_preqNo      := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo));
    var fldMS_ProdUMCode  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdUMCode));
    var fldMS_HostItemId  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_HostItemIndentifier));
    var fldMS_HostWhouse  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_HostWarehouse));
    var fldMS_SubDetHType := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SubDetailHostType));
    var fldMS_DetailCType := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_DetailCodeType));
    while true do
    begin

  {    if (IndexMS > 0) and (pRecMS(ListMS[IndexMS -1]).MS_Type_Prod = pRecMS(ListMS[IndexMS]).MS_Type_Prod) and
         (pRecMS(ListMS[IndexMS-1]).MS_Product_Code = pRecMS(ListMS[IndexMS]).MS_Product_Code) and
         (pRecMS(ListMS[IndexMS-1]).MS_Preq_No = pRecMS(ListMS[IndexMS]).MS_Preq_No) and
         (pRecMS(ListMS[IndexMS-1]).MS_Sub_Detail = pRecMS(ListMS[IndexMS]).MS_Sub_Detail) and
         (pRecMS(ListMS[IndexMS-1]).MS_Detail_Code = pRecMS(ListMS[IndexMS]).MS_Detail_Code)
      then
      begin
         inc(IndexMS);
         Continue;
      end;  }

      if (IndexMS > ListMS.count - 1) and srvQry.Eof then break;

      if (IndexMS > ListMS.count - 1) or
        ((IndexMS <= ListMS.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS[IndexMS]).MS_Type_Prod > Trim(fldMS_ProdType.AsString)) or

        ((IndexMS <= ListMS.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS[IndexMS]).MS_Type_Prod = Trim(fldMS_ProdType.AsString)) and
         (pRecMS(ListMS[IndexMS]).MS_Product_Code > fldMS_ProdCode.AsString)) or

{        ((IndexMS <= ListMS.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS[IndexMS]).MS_Type_Prod = Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString)) and
         (pRecMS(ListMS[IndexMS]).MS_Product_Code = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString)) or
         (pRecMS(ListMS[IndexMS]).MS_Preq_No > srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString)) or  }

        ((IndexMS <= ListMS.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS[IndexMS]).MS_Type_Prod = Trim(fldMS_ProdType.AsString)) and
         (pRecMS(ListMS[IndexMS]).MS_Product_Code = fldMS_ProdCode.AsString) and
      //   (pRecMS(ListMS[IndexMS]).MS_Preq_No = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) and
         (pRecMS(ListMS[IndexMS]).MS_Sub_Detail > fldMS_Sub_Detail.AsString)) or

         ((IndexMS <= ListMS.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS[IndexMS]).MS_Type_Prod = Trim(fldMS_ProdType.AsString)) and
         (pRecMS(ListMS[IndexMS]).MS_Product_Code = fldMS_ProdCode.AsString) and
//         (pRecMS(ListMS[IndexMS]).MS_Preq_No = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) and
         (pRecMS(ListMS[IndexMS]).MS_Sub_Detail = fldMS_Sub_Detail.AsString)) and
         (pRecMS(ListMS[IndexMS]).MS_Detail_Code > fldMS_Detail_Code.AsString))

         then
      begin
        with QryDel do
        begin
          Sql.Clear;
          Sql.Add(' delete from ' + tblArcName + ' where');
          Sql.Add(' MDS_TYPE_PROD ' + '=''' + Trim(fldMS_ProdType.AsString) + '''');
          Sql.Add(' and MDS_PRODUCT_CODE ' + '=''' + Trim(fldMS_ProdCode.AsString) + '''');
        //  Sql.Add(' and MDS_PREQ_NO ' + '=''' + Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) + '''');
          Sql.Add(' and MDS_SUB_DETAIL ' + '=''' + Trim(fldMS_Sub_Detail.AsString) + '''');
          Sql.Add(' and MDS_DETAIL_CODE ' + '=''' + Trim(fldMS_Detail_Code.AsString) + '''');
          Sql.Add(' and MDS_IDENTIFIER = ' + IniAppGlobals.Identifier);
       //   Prepare;
          ExecSQL;
        end;
        SetMaterialSchedule_Warp_Send_Client(true);
        srvQry.next;
        Application.ProcessMessages;
        continue;
      end;


      if  srvQry.Eof or
        ((IndexMS <= ListMS.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS[IndexMS]).MS_Type_Prod < Trim(fldMS_ProdType.AsString)) or

        ((IndexMS <= ListMS.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS[IndexMS]).MS_Type_Prod = Trim(fldMS_ProdType.AsString)) and
         (pRecMS(ListMS[IndexMS]).MS_Product_Code < fldMS_ProdCode.AsString)) or

      //  ((IndexMS <= ListMS.count - 1) and (not srvQry.Eof) and
      //   (pRecMS(ListMS[IndexMS]).MS_Type_Prod = Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString)) and
        // (pRecMS(ListMS[IndexMS]).MS_Product_Code = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString)) and
      //   (pRecMS(ListMS[IndexMS]).MS_Preq_No < srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString)) or

        ((IndexMS <= ListMS.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS[IndexMS]).MS_Type_Prod = Trim(fldMS_ProdType.AsString)) and
         (pRecMS(ListMS[IndexMS]).MS_Product_Code = fldMS_ProdCode.AsString) and
       //  (pRecMS(ListMS[IndexMS]).MS_Preq_No = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) and
         (pRecMS(ListMS[IndexMS]).MS_Sub_Detail < fldMS_Sub_Detail.AsString)) or

         ((IndexMS <= ListMS.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS[IndexMS]).MS_Type_Prod = Trim(fldMS_ProdType.AsString)) and
         (pRecMS(ListMS[IndexMS]).MS_Product_Code = fldMS_ProdCode.AsString) and
       //  (pRecMS(ListMS[IndexMS]).MS_Preq_No = srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) and
         (pRecMS(ListMS[IndexMS]).MS_Sub_Detail = fldMS_Sub_Detail.AsString)) and
         (pRecMS(ListMS[IndexMS]).MS_Detail_Code < fldMS_Detail_Code.AsString))

        then
      begin
        //  Insert into products from memory
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString := pRecMS(ListMS[IndexMS]).MS_Type_Prod;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString := pRecMS(ListMS[IndexMS]).MS_Product_Code;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString := pRecMS(ListMS[IndexMS]).MS_Preq_No;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_Sub_Detail)).AsString := pRecMS(ListMS[IndexMS]).MS_Sub_Detail;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_Detail_Code)).AsString := pRecMS(ListMS[IndexMS]).MS_Detail_Code;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_quant)).asFloat := pRecMS(ListMS[IndexMS]).MS_Quantity;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_netGroupCode)).AsString := pRecMS(ListMS[IndexMS]).MS_Net_Group_Code;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_HostItemIndentifier)).AsFloat := pRecMS(ListMS[IndexMS]).MS_HostItemIndentifier;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_HostWarehouse)).AsString := pRecMS(ListMS[IndexMS]).MS_HostWarehouse;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_SubDetailHostType)).AsString := pRecMS(ListMS[IndexMS]).MS_SubDetailHostType;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_DetailCodeType)).AsString := pRecMS(ListMS[IndexMS]).MS_DetailCodeType;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_ProdUMCode)).AsString := pRecMS(ListMS[IndexMS]).MS_UNITCODE;
        try
        QryMS.ExecSQL;
        except
        end;
        SetMaterialSchedule_Warp_Send_Client(true);
        IndexMS := IndexmS + 1;
        Application.ProcessMessages;
        continue;
      end;

         // Key is equal //
      if ((pRecMS(ListMS[IndexMS]).MS_Quantity <> fldMS_quant.asFloat) or
         (pRecMS(ListMS[IndexMS]).MS_Preq_No <> fldMS_preqNo.AsString) or
         (pRecMS(ListMS[IndexMS]).MS_UNITCODE <> fldMS_ProdUMCode.asString) or
         (pRecMS(ListMS[IndexMS]).MS_HostItemIndentifier <> fldMS_HostItemId.asFloat) or
         (pRecMS(ListMS[IndexMS]).MS_HostWarehouse <> fldMS_HostWhouse.asString) or
         (pRecMS(ListMS[IndexMS]).MS_SubDetailHostType <> fldMS_SubDetHType.asString) or
         (pRecMS(ListMS[IndexMS]).MS_DetailCodeType <> fldMS_DetailCType.asString)) then
      begin

        with QryUpdate do
        begin
          {if (pRecMS(ListMS[IndexMS]).MS_SCH_START = 0) then
            DateAsString := '12/30/1899 12:00'
          else
          begin
            tmp_date := pRecMS(ListMS[IndexMS]).MS_SCH_START;
            DecodeDateTime(tmp_date, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
            DateAsString := intTostr(Amonth) + '/' + intTostr(Aday) + '/' + intTostr(AYear) + ' ' ;
            DateAsString := DateAsString + intTostr(Ahour) + ':' + intTostr(AMinute) + ':' + intTostr(Asecond);
          end;   }
          Sql.Clear;

          Sql.Add('update ' + tbInfo.GetTableName + ' set ');
          Sql.Add('MDS_QTY = :MDS_QTY,');
          Sql.Add('MDS_NET_GROUP_CODE = :MDS_NET_GROUP_CODE,');
          Sql.Add('MDS_HOSTITEMINDENTIFIER = :MDS_HOSTITEMINDENTIFIER,');
          Sql.Add('MDS_HOSTWAREHOUSE = :MDS_HOSTWAREHOUSE,');
          Sql.Add('MDS_SUBDETAILHOSTTYPE = :MDS_SUBDETAILHOSTTYPE,');
          Sql.Add('MDS_DETAILCODETYPE = :MDS_DETAILCODETYPE,');
          Sql.Add('MDS_PREQ_NO = :MDS_PREQ_NO,');
          Sql.Add('MDS_PROD_UM = :MDS_PROD_UM');
          Sql.Add(' Where ');
          Sql.Add(' MDS_TYPE_PROD = :MDS_TYPE_PROD');
          Sql.Add(' and MDS_PRODUCT_CODE = :MDS_PRODUCT_CODE');
        //  Sql.Add(' and MDS_PREQ_NO = :MDS_PREQ_NO');
          Sql.Add(' and MDS_SUB_DETAIL = :MDS_SUB_DETAIL');
          Sql.Add(' and MDS_DETAIL_CODE = :MDS_DETAIL_CODE');
          Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));

          ParamByName('MDS_TYPE_PROD').Value := fldMS_ProdType.AsString;
          ParamByName('MDS_PRODUCT_CODE').Value := fldMS_ProdCode.AsString;
          ParamByName('MDS_SUB_DETAIL').Value := fldMS_Sub_Detail.AsString;
          ParamByName('MDS_DETAIL_CODE').Value := fldMS_Detail_Code.AsString;
          ParamByName('MDS_PREQ_NO').Value := pRecMS(ListMS[IndexMS]).MS_Preq_No;
          ParamByName('MDS_QTY').Value := pRecMS(ListMS[IndexMS]).MS_Quantity;
          ParamByName('MDS_NET_GROUP_CODE').Value := pRecMS(ListMS[IndexMS]).MS_Net_Group_Code;
          ParamByName('MDS_HOSTITEMINDENTIFIER').Value := pRecMS(ListMS[IndexMS]).MS_HostItemIndentifier;
          ParamByName('MDS_HOSTWAREHOUSE').Value := pRecMS(ListMS[IndexMS]).MS_HostWarehouse;
          ParamByName('MDS_SUBDETAILHOSTTYPE').Value := pRecMS(ListMS[IndexMS]).MS_SubDetailHostType;
          ParamByName('MDS_DETAILCODETYPE').Value := pRecMS(ListMS[IndexMS]).MS_DetailCodeType;
          ParamByName('MDS_PROD_UM').Value := pRecMS(ListMS[IndexMS]).MS_UNITCODE;

       //   try
            ExecSQL;
       //   Except

       //   end;
          SetMaterialSchedule_Warp_Send_Client(true);
        end;
      end;
      srvQry.Next;
      Application.ProcessMessages;
      IndexMS := IndexMS + 1;
    end;
  end;

  for IndexMS := 0 to ListMS.count - 1 do
     dispose(pRecMS(ListMS[IndexMS]));

  ListMS.Free;
  QryMS.connection.commit;
  QryDel.connection.commit;
  QryUpdate.connection.commit;
  QryMS.Close;

  QryDel.Close;

  QryUpdate.Close;
  QryUpdate.Free;
  QryMS.Free;
  QryDel.Free;
end;

//----------------------------------------------------------------------------//

function LoadMaterialScheduleLink(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..6] of TQryLinkRec = (
    (fldPC: fli_IDENTIFIER;     fldAS: '';       fldType: TLD_string),
    (fldPC: fli_ProdType;       fldAS: '';       fldType: TLD_string),
    (fldPC: fli_ProdCode;       fldAS: '';       fldType: TLD_string),
    (fldPC: fli_Sub_Detail;     fldAS: '';       fldType: TLD_string),
    (fldPC: fli_Detail_Code;    fldAS: '';       fldType: TLD_string),
    (fldPC: fli_preqNo;         fldAS: '';       fldType: TLD_string),
    (fldPC: fli_pstepId;        fldAS: '';       fldType: TLD_integer)
  );

var
  OrderBy, tblArcName : string;
  tbInfo:         ^TTblInfo;
  ListMS_Link : TList;
  IndexMS_Link  : Integer;
  QryMS, QryDel, QryUpdate : TMqmQuery;
  srvTrs: TMqmTransaction;
  Tmp_Date,Tmp_Date1 : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName,DndArchiveArcName : TDndArchiveName;
  i,K : Integer;
begin
  Result := true;

  Assert(tbl = tbl_MaterialDetailchedule_Link);
  tbInfo := @tblInfo[tbl];
  DateTimeFormat := GetDateTimeFormat;
  QryMS := ThreadCreateQuery(Main_DB);
  QryDel := ThreadCreateQuery(Main_DB);
  QryUpdate := ThreadCreateQuery(Main_DB);
  OrderBy := '';
  if (Trim(IniAppGlobals.PreparationExeName) = '') then exit;

  IndexMS_Link := 0;
  Tmp_Date := 0;
  Tmp_Date1 := 0;

  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'MATERIAL_DET_SCHED_LINK'
  else
    tblArcName  := 'SCDM_' + 'MATERIAL_DET_SCHED_LINK';
  ListMS_Link := Get_Host_Material_Schedule_Link;
  ListMS_Link.Sort(SortMDSL);
  InsertQryTables(tbl,fldList,QryMS);
  result := true;

  with srvQry do
  begin
    SQL.Clear;
    UpdateOperation(_('Updating') + '  ' + tbInfo.GetTableName + ' ' + (_('from host . . .')));
    SQL.Add('Select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER))
    + ' order by MDSL_TYPE_PROD, MDSL_PRODUCT_CODE, MDSL_SUB_DETAIL, MDSL_DETAIL_CODE, MDSL_PREQ_NO, MDSL_PSTEP_ID');
    open;
    var fldMSL_ProdType    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType));
    var fldMSL_ProdCode    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode));
    var fldMSL_Sub_Detail  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Sub_Detail));
    var fldMSL_Detail_Code := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Detail_Code));
    var fldMSL_preqNo      := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo));
    var fldMSL_pstepId     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId));
    while true do
    begin

      if (IndexMS_Link > ListMS_Link.count - 1) and srvQry.Eof then break;

      if (IndexMS_Link > ListMS_Link.count - 1) or
        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod > fldMSL_ProdType.AsString)) or

        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod = Trim(fldMSL_ProdType.AsString)) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code > fldMSL_ProdCode.AsString)) or

        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod = fldMSL_ProdType.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code = fldMSL_ProdCode.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Sub_Detail > fldMSL_Sub_Detail.AsString)) or

        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod = fldMSL_ProdType.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code = fldMSL_ProdCode.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Sub_Detail = fldMSL_Sub_Detail.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Detail_Code > fldMSL_Detail_Code.AsString)) or

        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod = fldMSL_ProdType.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code = fldMSL_ProdCode.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Sub_Detail = fldMSL_Sub_Detail.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Detail_Code = fldMSL_Detail_Code.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Preq_No > fldMSL_preqNo.AsString)) or

        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod = fldMSL_ProdType.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code = fldMSL_ProdCode.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Sub_Detail = fldMSL_Sub_Detail.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Detail_Code = fldMSL_Detail_Code.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Preq_No = fldMSL_preqNo.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Step > fldMSL_pstepId.AsInteger))

         then
      begin
        with QryDel do
        begin
          Sql.Clear;
          Sql.Add(' delete from ' + tblArcName + ' where');
          Sql.Add(' MDSL_TYPE_PROD ' + '=''' + Trim(fldMSL_ProdType.AsString) + '''');
          Sql.Add(' and MDSL_PRODUCT_CODE ' + '=''' + Trim(fldMSL_ProdCode.AsString) + '''');
          Sql.Add(' and MDSL_SUB_DETAIL ' + '=''' + Trim(fldMSL_Sub_Detail.AsString) + '''');
          Sql.Add(' and MDSL_DETAIL_CODE ' + '=''' + Trim(fldMSL_Detail_Code.AsString) + '''');
          Sql.Add(' and MDSL_PREQ_NO ' + '=''' + Trim(fldMSL_preqNo.AsString) + '''');
          Sql.Add(' and MDSL_PSTEP_ID ' + '=''' + Trim(fldMSL_pstepId.AsString) + '''');
          Sql.Add(' and MDSL_IDENTIFIER = ' + IniAppGlobals.Identifier);
          ExecSQL;
        end;
        SetMaterialSchedule_Warp_Send_Client(true);
        srvQry.next;
        Application.ProcessMessages;
        continue;
      end;

      if srvQry.Eof or
        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod > fldMSL_ProdType.AsString)) or

        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod = Trim(fldMSL_ProdType.AsString)) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code > fldMSL_ProdCode.AsString)) or

        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod = fldMSL_ProdType.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code = fldMSL_ProdCode.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Sub_Detail > fldMSL_Sub_Detail.AsString)) or

        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod = fldMSL_ProdType.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code = fldMSL_ProdCode.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Sub_Detail = fldMSL_Sub_Detail.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Detail_Code > fldMSL_Detail_Code.AsString)) or

        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod = fldMSL_ProdType.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code = fldMSL_ProdCode.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Sub_Detail = fldMSL_Sub_Detail.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Detail_Code = fldMSL_Detail_Code.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Preq_No > fldMSL_preqNo.AsString)) or

        ((IndexMS_Link <= ListMS_Link.count - 1) and (not srvQry.Eof) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod = fldMSL_ProdType.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code = fldMSL_ProdCode.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Sub_Detail = fldMSL_Sub_Detail.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Detail_Code = fldMSL_Detail_Code.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Preq_No = fldMSL_preqNo.AsString) and
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Step > fldMSL_pstepId.AsInteger))

        then
      begin
        //  Insert into products from memory
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString := pRecMS(ListMS_Link[IndexMS_Link]).MS_Type_Prod;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString := pRecMS(ListMS_Link[IndexMS_Link]).MS_Product_Code;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString := pRecMS(ListMS_Link[IndexMS_Link]).MS_Preq_No;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger := pRecMS(ListMS_Link[IndexMS_Link]).MS_Step;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_Sub_Detail)).AsString := pRecMS(ListMS_Link[IndexMS_Link]).MS_Sub_Detail;
        QryMS.ParamByName(CreateFld(tbInfo.pfx, fli_Detail_Code)).AsString := pRecMS(ListMS_Link[IndexMS_Link]).MS_Detail_Code;
        try
          QryMS.ExecSQL;
        except
        end;
        SetMaterialSchedule_Warp_Send_Client(true);
        IndexMS_Link := IndexMS_Link + 1;
        Application.ProcessMessages;
        continue;
      end;

         // Key is equal //
      if ((pRecMS(ListMS_Link[IndexMS_Link]).MS_Preq_No <> fldMSL_preqNo.AsString) or
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_Step <> fldMSL_pstepId.AsInteger)) then
        { (pRecMS(ListMS_Link[IndexMS_Link]).MS_UNITCODE <> srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdUMCode)).asString) or
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_HostItemIndentifier <> srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_HostItemIndentifier)).asFloat) or
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_HostWarehouse <> srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_HostWarehouse)).asString) or
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_SubDetailHostType <> srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SubDetailHostType)).asString) or
         (pRecMS(ListMS_Link[IndexMS_Link]).MS_DetailCodeType <> srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_DetailCodeType)).asString)) then  }
      begin

        with QryUpdate do
        begin
          {if (pRecMS(ListMS[IndexMS]).MS_SCH_START = 0) then
            DateAsString := '12/30/1899 12:00'
          else
          begin
            tmp_date := pRecMS(ListMS[IndexMS]).MS_SCH_START;
            DecodeDateTime(tmp_date, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
            DateAsString := intTostr(Amonth) + '/' + intTostr(Aday) + '/' + intTostr(AYear) + ' ' ;
            DateAsString := DateAsString + intTostr(Ahour) + ':' + intTostr(AMinute) + ':' + intTostr(Asecond);
          end;   }
          Sql.Clear;

         { Sql.Add('update ' + tbInfo.GetTableName + ' set ');
          Sql.Add('MDSL_PREQ_NO = :MDSL_PREQ_NO,');
          Sql.Add('MDSL_PSTEP_ID = :MDSL_PSTEP_ID');
          Sql.Add(' Where ');
          Sql.Add(' MDSL_TYPE_PROD = :MDSL_TYPE_PROD');
          Sql.Add(' and MDSL_PRODUCT_CODE = :MDSL_PRODUCT_CODE');
        //  Sql.Add(' and MDS_PREQ_NO = :MDS_PREQ_NO');
          Sql.Add(' and MDSL_SUB_DETAIL = :MDSL_SUB_DETAIL');
          Sql.Add(' and MDSL_DETAIL_CODE = :MDSL_DETAIL_CODE');
          Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));

          ParamByName('MDSL_TYPE_PROD').Value := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString;
          ParamByName('MDSL_PRODUCT_CODE').Value := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString;
          ParamByName('MDSL_SUB_DETAIL').Value := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Sub_Detail)).AsString;
          ParamByName('MDSL_DETAIL_CODE').Value := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Detail_Code)).AsString;

          ParamByName('MDSL_PREQ_NO').Value := pRecMS(ListMS_Link[IndexMS_Link]).MS_Preq_No;
          ParamByName('MDSL_PSTEP_ID').Value := pRecMS(ListMS_Link[IndexMS_Link]).MS_Step;




       //   try
            ExecSQL;
       //   Except

       //   end;
          SetMaterialSchedule_Warp_Send_Client(true);       }
        end;
      end;
      srvQry.Next;
      Application.ProcessMessages;
      IndexMS_Link := IndexMS_Link + 1;
    end;
  end;

  for IndexMS_Link := 0 to ListMS_Link.count - 1 do
     dispose(pRecMS(ListMS_Link[IndexMS_Link]));

  ListMS_Link.Free;
  QryMS.connection.commit;
  QryDel.connection.commit;
  QryUpdate.connection.commit;
  QryMS.Close;

  QryDel.Close;

  QryUpdate.Close;
  QryUpdate.Free;
  QryMS.Free;
  QryDel.Free;
end;

//----------------------------------------------------------------------------//

function SortPDP(Item1, Item2: Pointer) : integer;
var
  MQMPR1 : PMQMProductProperty;
  MQMPR2 : PMQMProductProperty;
begin
  MQMPR1 := PMQMProductProperty(Item1);
  MQMPR2 := PMQMProductProperty(Item2);

  if MQMPR1.PDP_TYPE_PROD < MQMPR2.PDP_TYPE_PROD then
    Result := -1
  else if (MQMPR1.PDP_TYPE_PROD = MQMPR2.PDP_TYPE_PROD) then
  begin
    if MQMPR1.PDP_PRODUCT_CODE < MQMPR2.PDP_PRODUCT_CODE then
      Result := -1
    else if (MQMPR1.PDP_PRODUCT_CODE = MQMPR2.PDP_PRODUCT_CODE) then
    begin
      if MQMPR1.PDP_PROPERTY < MQMPR2.PDP_PROPERTY then
        Result := -1
      else if (MQMPR1.PDP_PROPERTY = MQMPR2.PDP_PROPERTY) then
        Result := 0
      else
        Result := 1;
    end else
      Result := 1;
  end else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function LoadProductProperties(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;

  const
  fldList: array [0..4] of TQryLinkRec = (
    (fldPC: fli_IDENTIFIER;     fldAS: '';       fldType: TLD_string),
    (fldPC: fli_ProdType;       fldAS: '';       fldType: TLD_string),
    (fldPC: fli_ProdCode;       fldAS: '';       fldType: TLD_string),
    (fldPC: fli_PropertyCode;   fldAS: '';       fldType: TLD_string),
    (fldPC: fli_PropValue;      fldAS: '';       fldType: TLD_string)
  );

type
  TProductWarp = Record
    ProdType : string;
    ProdCode : string;
  end;
  PTProductWarp = ^TProductWarp;
var
  tbInfo,  tbInfoProduct : ^TTblInfo;
  InsQry: TMqmQuery;
  I,k : Integer;
  ProductPropList : TList;
  OrderBy, tblArcName : string;
  RecMS   : pRecMS;
  //ListMS : TList;
  IndexPP  : Integer;
  QryInsert, QryDel, QryUpdate : TMqmQuery;
  srvTrs: TMqmTransaction;
  Tmp_Date,Tmp_Date1 : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond : Word;
  DateAsString: String;
  DndArchiveHostName,DndArchiveArcName : TDndArchiveName;
  ArcQry: TMqmQuery;
  WarpHandledList : TList;
  ProductWarp : PTProductWarp;
  FoundProductWarp : boolean;
begin
  Result := true;
  Assert(tbl = tbl_ProductProperties);
  tbInfo := @tblInfo[tbl];
  // for getting host list need to use the function :
  ProductPropList := Get_Host_Productproperty;
  ProductPropList.Sort(SortPDP);

  DateTimeFormat := GetDateTimeFormat;
  OrderBy := '';
  if (Trim(IniAppGlobals.PreparationExeName) = '') then exit;
  IndexPP := 0;
  result := true;

  // check if Warp is handled

  with srvQry do
  begin
    SQL.Clear;
    tbInfoProduct := @tblInfo[tbl_products];
    SQL.Add('Select * from ' + tbInfoProduct.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfoProduct.pfx, fli_IDENTIFIER)));
    SQL.Add(' And (' + CreateFld(tbInfoProduct.pfx, fli_MaterialSchedule) + '=' + QuotedStr('1'));
    SQL.Add(' or ' + CreateFld(tbInfoProduct.pfx, fli_MaterialSchedule) + '=' + QuotedStr('2') + ')' ) ;
    open;
    var fldPP_WarpProdType := srvQry.FieldByName(CreateFld(tbInfoProduct.pfx, fli_ProdType));
    var fldPP_WarpProdCode := srvQry.FieldByName(CreateFld(tbInfoProduct.pfx, fli_ProdCode));

    if EOF then
    begin
      close;
      Exit;
    end;

    QryInsert := ThreadCreateQuery(Main_DB);
    QryDel := ThreadCreateQuery(Main_DB);
    QryUpdate := ThreadCreateQuery(Main_DB);
    InsertQryTables(tbl,fldList,QryInsert);

    WarpHandledList := TList.Create;
    while not EOF do
    begin
      new(ProductWarp);
      ProductWarp.ProdType := Trim(fldPP_WarpProdType.AsString);
      ProductWarp.ProdCode := Trim(fldPP_WarpProdCode.AsString);
      WarpHandledList.Add(ProductWarp);
      Next;
    end;
  end;

  with srvQry do
  begin
    SQL.Clear;
    UpdateOperation(_('Updating') + '  ' + tbInfo.GetTableName + ' ' + (_('from host . . .')));
    SQL.Add('Select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER))
    + ' order by PDP_TYPE_PROD, PDP_PRODUCT_CODE, PDP_PROPERTY');
    open;
    var fldPP_ProdType  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType));
    var fldPP_ProdCode  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode));
    var fldPP_propcode  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_propertycode));
    var fldPP_PropValue := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PropValue));

    while true do
    begin

      if (IndexPP > ProductPropList.count - 1) and srvQry.Eof then break;

      if (IndexPP > ProductPropList.count - 1) or
        ((IndexPP <= ProductPropList.count - 1) and (not srvQry.Eof) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_TYPE_PROD > Trim(fldPP_ProdType.AsString)) or

        ((IndexPP <= ProductPropList.count - 1) and (not srvQry.Eof) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_TYPE_PROD = Trim(fldPP_ProdType.AsString)) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_PRODUCT_CODE > fldPP_ProdCode.AsString)) or

        ((IndexPP <= ProductPropList.count - 1) and (not srvQry.Eof) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_TYPE_PROD = Trim(fldPP_ProdType.AsString)) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_PRODUCT_CODE = fldPP_ProdCode.AsString)) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_PROPERTY > fldPP_propcode.AsString))

         then
      begin
        with QryDel do
        begin
          Sql.Clear;
          Sql.Add(' delete from ' + tbInfo.GetTableName + ' where');
          Sql.Add(' PDP_TYPE_PROD ' + '=''' + Trim(fldPP_ProdType.AsString) + '''');
          Sql.Add(' and PDP_PRODUCT_CODE ' + '=''' + Trim(fldPP_ProdCode.AsString) + '''');
          Sql.Add(' and PDP_PROPERTY ' + '=''' + Trim(fldPP_propcode.AsString) + '''');
          Sql.Add(' and PDP_IDENTIFIER = ' + IniAppGlobals.Identifier);
          ExecSQL;

          for I := 0 to WarpHandledList.Count - 1 do
          begin
            if (fldPP_ProdType.AsString = PTProductWarp(WarpHandledList[I]).ProdType) and
               (fldPP_ProdCode.AsString = PTProductWarp(WarpHandledList[I]).ProdCode) then
            begin
              SetMaterialSchedule_Warp_Send_Client(true);
              break
            end;
          end;

        end;
        srvQry.next;
        Application.ProcessMessages;
        continue;
      end;

      if  srvQry.Eof or
        ((IndexPP <= ProductPropList.count - 1) and (not srvQry.Eof) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_TYPE_PROD < Trim(fldPP_ProdType.AsString)) or

        ((IndexPP <= ProductPropList.count - 1) and (not srvQry.Eof) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_TYPE_PROD = Trim(fldPP_ProdType.AsString)) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_PRODUCT_CODE < fldPP_ProdCode.AsString)) or

        ((IndexPP <= ProductPropList.count - 1) and (not srvQry.Eof) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_TYPE_PROD = Trim(fldPP_ProdType.AsString)) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_PRODUCT_CODE = fldPP_ProdCode.AsString)) and
         (PMQMProductProperty(ProductPropList[IndexPP]).PDP_PROPERTY < fldPP_propcode.AsString))

        then
      begin
        //  Insert into products from memory
        QryInsert.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;
        QryInsert.ParamByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString := PMQMProductProperty(ProductPropList[IndexPP]).PDP_TYPE_PROD;
        QryInsert.ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString := PMQMProductProperty(ProductPropList[IndexPP]).PDP_PRODUCT_CODE;
        QryInsert.ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString := PMQMProductProperty(ProductPropList[IndexPP]).PDP_PROPERTY;
        QryInsert.ParamByName(CreateFld(tbInfo.pfx, fli_PropValue)).AsString := PMQMProductProperty(ProductPropList[IndexPP]).PDP_VALUE;
        try
          QryInsert.ExecSQL;
        except
        end;
        IndexPP := IndexPP + 1;

        for I := 0 to WarpHandledList.Count - 1 do
        begin
          if (fldPP_ProdType.AsString = PTProductWarp(WarpHandledList[I]).ProdType) and
             (fldPP_ProdCode.AsString = PTProductWarp(WarpHandledList[I]).ProdCode) then
          begin
            SetMaterialSchedule_Warp_Send_Client(true);
            break
          end;
        end;

        Application.ProcessMessages;
        continue;
      end;

         // Key is equal //
      if PMQMProductProperty(ProductPropList[IndexPP]).PDP_VALUE <> fldPP_PropValue.AsString then
      begin

        with QryUpdate do
        begin
          Sql.Clear;

          Sql.Add('update ' + tbInfo.GetTableName + ' set ');
          Sql.Add('PDP_Value = :PDP_VALUE');
          Sql.Add(' Where ');
          Sql.Add(' PDP_TYPE_PROD = :PDP_TYPE_PROD');
          Sql.Add(' and PDP_PRODUCT_CODE = :PDP_PRODUCT_CODE');
          Sql.Add(' and PDP_PROPERTY = :PDP_Property');
          Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));

          ParamByName('PDP_TYPE_PROD').Value := fldPP_ProdType.AsString;
          ParamByName('PDP_PRODUCT_CODE').Value := fldPP_ProdCode.AsString;
          ParamByName('PDP_PROPERTY').Value := fldPP_propcode.AsString;
          ParamByName('PDP_VALUE').Value := PMQMProductProperty(ProductPropList[IndexPP]).PDP_VALUE;
       //   try
            ExecSQL;
       //   Except

       //   end;

          for I := 0 to WarpHandledList.Count - 1 do
          begin
            if (fldPP_ProdType.AsString = PTProductWarp(WarpHandledList[I]).ProdType) and
               (fldPP_ProdCode.AsString = PTProductWarp(WarpHandledList[I]).ProdCode) then
            begin
              SetMaterialSchedule_Warp_Send_Client(true);
              break
            end;
          end;


        end;
      end;
      srvQry.Next;
      Application.ProcessMessages;
      IndexPP := IndexPP + 1;
    end;
  end;

  for IndexPP := 0 to ProductPropList.count - 1 do
     dispose(PMQMProductProperty(ProductPropList[IndexPP]));

  for IndexPP := 0 to WarpHandledList.count - 1 do
     dispose(PTProductWarp(WarpHandledList[IndexPP]));

  WarpHandledList.Free;
  ProductPropList.Free;
  QryInsert.connection.commit;
  QryDel.connection.commit;
  QryUpdate.connection.commit;
  QryInsert.Close;

  QryDel.Close;

  QryUpdate.Close;
  QryUpdate.Free;
  QryInsert.Free;
  QryDel.Free;

end;

//----------------------------------------------------------------------------//

function UpdateWorkCenterVisible(qry: TMqmQuery): boolean;
var
  tbAw:    ^TTblInfo;
  tbww:    ^TTblInfo;
//  tbWC:    ^TTblInfo;
//  tbWS:    ^TTblInfo;
  InsQry: TMqmQuery;
  TblAW, Tblww : string;
  sl:      TStringList;
  DndLocalNameName : TDndArchiveName;
begin
  Result := true;
  tbAw    := @tblInfo[tbl_wkc_alt];
  tbww    := @tblInfo[tbl_wkst_wkc];
//  tbWC    := @tblInfo[tbl_wkc];
//  tbWS    := @tblInfo[tbl_wkst];

  InsQry := ThreadCreateQuery(Main_DB);


//  DndArchiveHostName := GetDndArchiveHostName;



//  if DndArchiveArcName = TD_DbInterbase then
//    tblArcName  := tbInfo.PCname
//  else
//    tblArcName  := 'SCDA_' + tbInfo.PCname;

{  DndLocalNameName := GetDndArchiveLocalName;
  begin
    if DndLocalNameName = TD_DbInterbase then
    begin
      TblAW := tbInfo.PCname
      TblWW :=
    end

    else
      tblName := tbInfo.GetTableName;

  end;  }



//  try

  // Update work center-stations
  // --------------
    with qry do
    begin

//      Transaction.StartTransaction;
      UpdateOperation(_('Update work centers') + ' ' + tbWW.GetTableName);
      SQL.clear;
      SQL.add('UPDATE ' + tbww.GetTableName + ' SET ');
      SQL.add(CreateFld(tbWW.pfx, fli_Visible) + ' = ''1''');
      SQL.add(WHERE_IDF_Condition(CreateFld(tbWW.pfx, fli_IDENTIFIER)));
      ExecSQL;
      close;
      connection.commit;
     // Transaction.Commit;

     // Transaction.StartTransaction;
      UpdateOperation(_('Update work centers not Visible') + ' ' + tbWW.GetTableName);
      InsQry.SQL.Clear;
      InsQry.SQL.Add('insert into ' + tbww.GetTableName + '(');
      InsQry.SQL.Add(CreateFld(tbww.pfx, fli_wkstCode) + ',');
      InsQry.SQL.Add(CreateFld(tbww.pfx, fli_wkCtrCode) + ',');
      InsQry.SQL.Add(CreateFld(tbww.pfx, fli_TypeOfUse) + ',');
      InsQry.SQL.Add(CreateFld(tbww.pfx, fli_IDENTIFIER) + ',');
      InsQry.SQL.Add(CreateFld(tbww.pfx, fli_Visible));
      InsQry.SQL.Add(') values (');
      InsQry.SQL.Add(':' + CreateFld(tbww.pfx, fli_wkstCode) + ',');
      InsQry.SQL.Add(':' + CreateFld(tbww.pfx, fli_wkCtrCode) + ',');
      InsQry.SQL.Add(':' + CreateFld(tbww.pfx, fli_TypeOfUse) + ',');
      InsQry.SQL.Add(':' + CreateFld(tbww.pfx, fli_IDENTIFIER) + ',');
      InsQry.SQL.Add(':' + CreateFld(tbww.pfx, fli_Visible));
      InsQry.SQL.Add(')');
  //    InsQry.Prepare;

      SQL.clear;
      SQL.Add('select distinct ');
      SQL.add(CreateFld(tbWW.pfx, fli_wkstCode) + ',');
      SQL.add(CreateFld(tbaw.pfx, fli_wkCtrCode) + ' from ' + tbww.GetTableName + ',' + tbaw.GetTableName);
  //    SQL.add( ' Where ' + CreateFld(tbww.pfx, fli_wkCtrCode)  + ' = ' + CreateFld(tbaw.pfx, fli_AlterWC));

      SQL.add(WHERE_IDF_Condition(CreateFld(tbww.pfx, fli_IDENTIFIER)));
      SQL.add( ' AND ' + CreateFld(tbww.pfx, fli_wkCtrCode)  + ' = ' + CreateFld(tbaw.pfx, fli_AlterWC));

      SQL.add(' And (' + CreateFld(tbww.pfx, fli_wkstCode) + ' || ' +
                        CreateFld(tbaw.pfx, fli_wkCtrCode) + ') NOT IN (');
      SQL.add('Select ' + CreateFld(tbww.pfx, fli_wkstCode) + ' || ' +
                          CreateFld(tbww.pfx, fli_wkCtrCode) + ' from ' + tbww.GetTableName + WHERE_IDF_Condition(CreateFld(tbww.pfx, fli_IDENTIFIER)) + ')');
      SQL.add(' Order by ' + CreateFld(tbww.pfx, fli_wkstCode) + ',');
      SQL.add(CreateFld(tbaw.pfx, fli_wkCtrCode));
      open;
      while not Eof do
      begin
        InsQry.ParamByName(CreateFld(tbww.pfx, fli_wkstCode)).AsString := FieldByName(CreateFld(tbww.pfx, fli_wkstCode)).AsString;
        InsQry.ParamByName(CreateFld(tbww.pfx, fli_wkCtrCode)).AsString := FieldByName(CreateFld(tbaw.pfx, fli_wkCtrCode)).AsString;
        InsQry.ParamByName(CreateFld(tbww.pfx, fli_TypeOfUse)).AsString := '2';
        InsQry.ParamByName(CreateFld(tbww.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;
        InsQry.ParamByName(CreateFld(tbww.pfx, fli_Visible)).AsString := '0';
        InsQry.ExecSQL;
        Next;
        Application.ProcessMessages;
      end;

      close;
    //  Transaction.Commit;
      InsQry.Connection.Commit;

{      Transaction.StartTransaction;
      UpdateOperation(_(' Update work centers not Visible With Type 2') + tbWW.PCname);
      InsQry.SQL.Clear;
      InsQry.SQL.Add('insert into ' + tbww.PCname + '(');
      InsQry.SQL.Add(CreateFld(tbww.pfx, fli_wkstCode) + ',');
      InsQry.SQL.Add(CreateFld(tbww.pfx, fli_wkCtrCode) + ',');
      InsQry.SQL.Add(CreateFld(tbww.pfx, fli_TypeOfUse) + ',');
      InsQry.SQL.Add(CreateFld(tbww.pfx, fli_Visible));
      InsQry.SQL.Add(') values (');
      InsQry.SQL.Add(':' + CreateFld(tbww.pfx, fli_wkstCode) + ',');
      InsQry.SQL.Add(':' + CreateFld(tbww.pfx, fli_wkCtrCode) + ',');
      InsQry.SQL.Add(':' + CreateFld(tbww.pfx, fli_TypeOfUse) + ',');
      InsQry.SQL.Add(':' + CreateFld(tbww.pfx, fli_Visible));
      InsQry.SQL.Add(')');
      InsQry.Prepare;

      SQL.clear;
      SQL.add('Select ');
      SQL.add(CreateFld(tbWS.pfx, fli_wkstCode) + ',');
      SQL.add(CreateFld(tbWC.pfx, fli_wkCtrCode) + ' from ' + tbWS.PCname + ',' + tbWC.PCname);
      SQL.add(' Where ');
      SQL.add(CreateFld(tbWC.pfx, fli_wkCtrCode) + ' IN ');
      SQL.add('(Select ' + CreateFld(tbww.pfx, fli_wkCtrCode) + ' from ' + tbww.PCname);
      SQL.add(' where ' + CreateFld(tbww.pfx, fli_TypeOfUse) + ' = ''1''' + ')');
      SQL.add(' And (' + CreateFld(tbWS.pfx, fli_wkstCode) + ' || ' +
                        CreateFld(tbWC.pfx, fli_wkCtrCode) + ') NOT IN (');
      SQL.add('Select (' + CreateFld(tbww.pfx, fli_wkstCode) + ' || ' +
                          CreateFld(tbww.pfx, fli_wkCtrCode) + ') from ' + tbww.PCname + ')');
      open;
      while not Eof do
      begin
        InsQry.ParamByName(CreateFld(tbww.pfx, fli_wkstCode)).AsString := FieldByName(CreateFld(tbWS.pfx, fli_wkstCode)).AsString;
        InsQry.ParamByName(CreateFld(tbww.pfx, fli_wkCtrCode)).AsString := FieldByName(CreateFld(tbWC.pfx, fli_wkCtrCode)).AsString;
        InsQry.ParamByName(CreateFld(tbww.pfx, fli_TypeOfUse)).AsString := '2';
        InsQry.ParamByName(CreateFld(tbww.pfx, fli_Visible)).AsString := '0';
        InsQry.ExecSQL;
        Next;
      end;

      close;
      Transaction.Commit;
      InsQry.Transaction.Commit;  }

    end;

{  except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add('Error In UpdateWorkCenterVisible ' + E.Message);
        UpdateError(sl);
        sl.Free;
        raise
      end
  end;   }

  InsQry.Free;

end;

//----------------------------------------------------------------------------//

function UpdateLocalPropertyTable(qry: TMqmQuery): boolean;
var
  tbProp, Tb_rule_Occ_to_occ , Tb_rule_res_to_occ : ^TTblInfo;
begin
  Result := true;
  tbProp := @tblInfo[tbl_prop];
  Tb_rule_res_to_occ := @tblInfo[tbl_ruleResToOcc];
  Tb_rule_Occ_to_occ := @tblInfo[tbl_ruleOccToOcc];

  qry.SQL.Clear;
  qry.SQL.Add(' update ' + tbProp.GetTableName + ' set ');
  qry.SQL.Add(CreateFld(tbProp.pfx, fli_RO_MainLevel) + ' = ' + QuotedStr('0'));

  Qry.SQL.add(WHERE_IDF_Condition(CreateFld(tbProp.pfx, fli_IDENTIFIER)));
  qry.SQL.Add(' AND ' + CreateFld(tbProp.pfx, fli_RO_MainLevel) + ' > ' + QuotedStr('0'));

  //qry.SQL.Add(' where ' + CreateFld(tbProp.pfx, fli_RO_MainLevel) + ' > ' + QuotedStr('0'));

  qry.SQL.Add(' And ' + CreateFld(tbProp.pfx, fli_PropertyCode) + ' not in ');
  qry.SQL.Add(' (select ro_property from ' + Tb_rule_res_to_occ.GetTableName + WHERE_IDF_Condition(CreateFld(Tb_rule_res_to_occ.pfx, fli_IDENTIFIER))  +  ' )   ');
  qry.ExecSQL;

  qry.SQL.Clear;
  qry.SQL.Add(' update ' + tbProp.GetTableName + ' set ');
  qry.SQL.Add(CreateFld(tbProp.pfx, fli_OO_MainLevel) + ' = ' + QuotedStr('0'));
  Qry.SQL.add(WHERE_IDF_Condition(CreateFld(tbProp.pfx, fli_IDENTIFIER)));
  qry.SQL.Add(' AND ' + CreateFld(tbProp.pfx, fli_OO_MainLevel) + ' > ' + QuotedStr('0'));

 // qry.SQL.Add(' where ' + CreateFld(tbProp.pfx, fli_OO_MainLevel) + ' > ' + QuotedStr('0'));
  qry.SQL.Add(' And ' + CreateFld(tbProp.pfx, fli_PropertyCode) + ' not in ');
  qry.SQL.Add(' (select oo_property from ' + Tb_rule_Occ_to_occ.GetTableName + WHERE_IDF_Condition(CreateFld(Tb_rule_Occ_to_occ.pfx, fli_IDENTIFIER)) + ' )   ');
  qry.ExecSQL;
  qry.Connection.Commit;

end;

//----------------------------------------------------------------------------//

function UpdateLocalPlantForWorkCenter(qry: TMqmQuery): boolean;
type
  TWcGroup = record
    WK_CNTER_GROUP : string;
    PLANT_CODE     : string;
    MAIN_WC        : string;
  end;
  PTWcGroup = ^TWcGroup;
var
  tbWcG, tbWc : ^TTblInfo;
  PWcGroup : PTWcGroup;
  WcList : TList;
  I : Integer;
begin
  Result := true;
  tbWcG := @tblInfo[tbl_wkc_group];
  tbWc := @tblInfo[tbl_wkc];

  with qry do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from ' + tbWcG.GetTableName);
    SQL.Add(' where ' + CreateFld(tbWcG.pfx, fli_wkCtrGroup) + '<>' + '''''');
    Open;
    if eof then
      exit;

    WcList := TList.Create;
    while not eof do
    begin
      begin
        new(PWcGroup);
        PWcGroup.WK_CNTER_GROUP := FieldByName(CreateFld(tbWcG.pfx, fli_wkCtrGroup)).AsString;
        PWcGroup.PLANT_CODE     := FieldByName(CreateFld(tbWcG.pfx, fli_PlantCode)).AsString;
        PWcGroup.MAIN_WC        := FieldByName(CreateFld(tbWcG.pfx, fli_MainWC)).AsString;
        WcList.Add(PWcGroup);
      end;
      next;
    end;
  end;

  for I := 0 to WcList.Count - 1 do
  begin
    qry.SQL.Clear;
    qry.SQL.Add(' update ' + tbWc.GetTableName + ' set ');
    qry.SQL.Add(CreateFld(tbWc.pfx, fli_PlantCode) + ' = ' + QuotedStr(PTWcGroup(WcList[I]).PLANT_CODE));
    qry.SQL.Add(' where ' + CreateFld(tbWc.pfx, fli_wkCtrGroup) + ' = ' + QuotedStr(PTWcGroup(WcList[I]).WK_CNTER_GROUP));
    qry.ExecSQL;
    qry.connection.Commit;
  end;

  for I := 0 to WcList.Count - 1 do
    dispose(PTWcGroup(WcList[I]));
  WcList.free;
end;

//----------------------------------------------------------------------------//

{function Load_wkc_Category(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..5] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;                fldAS: 'SCDMAC'; fldType: TLD_string),
    (fldPC: fli_Category;                 fldAS: 'SCATRS'; fldType: TLD_string),
    (fldPC: fli_MixRegroups;              fldAS: 'SMIXRG'; fldType: TLD_string),
    (fldPC: fli_CalCod;                   fldAS: 'SCDCAL'; fldType: TLD_string),
    (fldPC: fli_usrCg;                    fldAS: 'SUSRNM'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'SDTORA'; fldType: TLD_dateTime)
  );
begin
  // mcm users
  Result := true;
  if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') then
  begin
    Assert(tbl = tbl_wkc_Category);
    Result := LoadTable(tbl, AS400Speclib, ' where SANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end;
end;

//----------------------------------------------------------------------------//

function Load_CategoryDatesInfo(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..6] of TQryLinkRec = (
    (fldPC: fli_wkCtrCode;                fldAS: 'TCDMAC'; fldType: TLD_string),
    (fldPC: fli_Category;                 fldAS: 'TCATRS'; fldType: TLD_string),
    (fldPC: fli_DateBegin;                fldAS: 'TFDATE'; fldType: TLD_date),
    (fldPC: fli_NumOfMachines;            fldAS: 'TNBRMC'; fldType: TLD_integer),
    (fldPC: fli_FiniteCapacity;           fldAS: 'TCAPPR'; fldType: TLD_integer),
    (fldPC: fli_usrCg;                    fldAS: 'TUSRNM'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'TDTORA'; fldType: TLD_dateTime)
  );
begin
  // mcm users
  Result := true;
  if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') then
  begin
    Assert(tbl = tbl_CategoryDatesInfo);
    Result := LoadTable(tbl, AS400Speclib, ' where TANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end;
end;

//----------------------------------------------------------------------------//

function Load_wkc_Penalties(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..5] of TQryLinkRec = (
    (fldPC: fli_PlanWkctCode;             fldAS: 'HCDMAC'; fldType: TLD_string),
    (fldPC: fli_PlanWkctProc;             fldAS: 'HCDMAP'; fldType: TLD_string),
    (fldPC: fli_CompCaseNum;              fldAS: 'HCASEN'; fldType: TLD_string),
    (fldPC: fli_DaysPanelty;              fldAS: 'HPNLTY'; fldType: TLD_integer),
    (fldPC: fli_usrCg;                    fldAS: 'HUSRNM'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'HDTORA'; fldType: TLD_dateTime)
  );
begin
  // mcm users
  result := true;
  if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') then
  begin
    Assert(tbl = tbl_wkc_Penalties);
    Result := LoadTable(tbl, AS400Speclib, ' where HANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end;
end;  }

//----------------------------------------------------------------------------//

function Load_Learning_Curve(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldListAS400 : array [0..12] of TQryLinkRec = (
    (fldPC: fli_LearningCurveCode;             fldAS: 'LCDLRC'; fldType: TLD_string),
    (fldPC: fli_LearningCurveDesc;             fldAS: 'LDESCR'; fldType: TLD_string),
    (fldPC: fli_CurveFirstHours;               fldAS: 'LCRHR1'; fldType: TLD_float),
    (fldPC: fli_CurveFirstEffic;               fldAS: 'LCREF1'; fldType: TLD_integer),
    (fldPC: fli_CurveSecondHours;              fldAS: 'LCRHR2'; fldType: TLD_float),
    (fldPC: fli_CurveSecondEffic;              fldAS: 'LCREF2'; fldType: TLD_integer),
    (fldPC: fli_CurveThirdHours;               fldAS: 'LCRHR3'; fldType: TLD_float),
    (fldPC: fli_CurveThirdEffic;               fldAS: 'LCREF3'; fldType: TLD_integer),
    (fldPC: fli_CurveForthHours;               fldAS: 'LCRHR4'; fldType: TLD_float),
    (fldPC: fli_CurveForthEffic;               fldAS: 'LCREF4'; fldType: TLD_integer),
    (fldPC: fli_CurveFifthhHours;              fldAS: 'LCRHR5'; fldType: TLD_float),
    (fldPC: fli_CurveFifthEffic;               fldAS: 'LCREF5'; fldType: TLD_integer),
    (fldPC: fli_IDENTIFIER;                    fldAS: ''; fldType: TLD_integer)
  );

  fldList : array [0..18] of TQryLinkRec = (
    (fldPC: fli_LearningCurveCode;             fldAS: ''; fldType: TLD_string),
    (fldPC: fli_LearningCurveDesc;             fldAS: ''; fldType: TLD_string),
    (fldPC: fli_CurveFirstHours;               fldAS: ''; fldType: TLD_float),
    (fldPC: fli_CurveFirstEffic;               fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_CurveSecondHours;              fldAS: ''; fldType: TLD_float),
    (fldPC: fli_CurveSecondEffic;              fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_CurveThirdHours;               fldAS: ''; fldType: TLD_float),
    (fldPC: fli_CurveThirdEffic;               fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_CurveForthHours;               fldAS: ''; fldType: TLD_float),
    (fldPC: fli_CurveForthEffic;               fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_CurveFifthhHours;              fldAS: ''; fldType: TLD_float),
    (fldPC: fli_CurveFifthEffic;               fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_CurveSixThHours;               fldAS: ''; fldType: TLD_float),
    (fldPC: fli_CurveSixThEffic;               fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_CurveSeventhHours;             fldAS: ''; fldType: TLD_float),
    (fldPC: fli_CurveSeventhEffic;             fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_CurveEighThHours;              fldAS: ''; fldType: TLD_float),
    (fldPC: fli_CurveEighThEffic;              fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_IDENTIFIER;                    fldAS: ''; fldType: TLD_integer)
  );
var
  DndArchiveHostName : TDndArchiveName;
  GeneralSQL : string;
  tbInfo :     ^TTblInfo;
//  TableFound : boolean;
begin
  Result := true;
  tbInfo := @tblInfo[tbl];
  Assert(tbl = tbl_LearningCurve);
  DndArchiveHostName := GetDndArchiveHostName;
  if DndArchiveHostName = TD_AS_400 then
  begin
    with HostQry do
    begin
      SQL.Clear;
      GeneralSQL := '';
      GeneralSQL := 'Select * from ' + tbInfo.ASname;
      SQL.Add(GeneralSQL);
      try
        Open;
        Close;
      Except
        Exit;
      end;
    end;
    Result := LoadTable(tbl, AS400Speclib, ' where LANNUL' + CAnnulFilter,
                      fldListAS400, srvQry, HostQry)
  end
  else
    Result := LoadTable(tbl, AS400Speclib, ' where LANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
end;

//----------------------------------------------------------------------------//

function LoadItemsStock(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..4] of TQryLinkRec = (
    (fldPC: fli_ItemType;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_netGroupCode;             fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ItemCode;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_stock;                    fldAS: ''; fldType: TLD_float),
    (fldPC: fli_IDENTIFIER;               fldAS: ''; fldType: TLD_Integer)
  );
var
  DndArchiveHostName : TDndArchiveName;
begin
  Result := true;
  DndArchiveHostName := GetDndArchiveHostName;
  if DndArchiveHostName <> TD_AS_400 then
  begin
    Result := LoadTable(tbl, AS400Speclib, ' where LANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end;
end;

//----------------------------------------------------------------------------//

function LoadItemsStockExceptions(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..7] of TQryLinkRec = (
    (fldPC: fli_ItemType;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_netGroupCode;             fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ItemCode;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_Date;                     fldAS: ''; fldType: TLD_dateTime),
    (fldPC: fli_fromTime;                 fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_ToTime;                   fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_StockDifference;          fldAS: ''; fldType: TLD_float),
    (fldPC: fli_IDENTIFIER;               fldAS: ''; fldType: TLD_Integer)
  );
var
  DndArchiveHostName : TDndArchiveName;
begin
  Result := true;
  DndArchiveHostName := GetDndArchiveHostName;
  if DndArchiveHostName <> TD_AS_400 then
  begin
    Result := LoadTable(tbl, AS400Speclib, ' where LANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end;
end;

//----------------------------------------------------------------------------//

function LoadItemsStockChanges(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..7] of TQryLinkRec = (
    (fldPC: fli_ItemType;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_netGroupCode;             fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ItemCode;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_DayInWeek;                fldAS: ''; fldType: TLD_Integer),
    (fldPC: fli_fromTime;                 fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_ToTime;                   fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_StockDifference;          fldAS: ''; fldType: TLD_float),
    (fldPC: fli_IDENTIFIER;               fldAS: ''; fldType: TLD_Integer)
  );
var
  DndArchiveHostName : TDndArchiveName;
begin
  Result := true;
  DndArchiveHostName := GetDndArchiveHostName;
  if DndArchiveHostName <> TD_AS_400 then
  begin
    Result := LoadTable(tbl, AS400Speclib, ' where LANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end;
end;

//----------------------------------------------------------------------------//

function Load_Material_Tollerance_Types(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..12] of TQryLinkRec = (
    (fldPC: fli_Material_Tollerance_Types_Code;             fldAS: ''; fldType: TLD_string),
    (fldPC: fli_Material_Tollerance_Types_Desc;             fldAS: ''; fldType: TLD_string),
    (fldPC: fli_TillQty1;                                   fldAS: ''; fldType: TLD_float),
    (fldPC: fli_TillQty1Percent;                            fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_TillQty2;                                   fldAS: ''; fldType: TLD_float),
    (fldPC: fli_TillQty2Percent;                            fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_TillQty3;                                   fldAS: ''; fldType: TLD_float),
    (fldPC: fli_TillQty3Percent;                            fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_TillQty4;                                   fldAS: ''; fldType: TLD_float),
    (fldPC: fli_TillQty4Percent;                            fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_TillQty5;                                   fldAS: ''; fldType: TLD_float),
    (fldPC: fli_TillQty5Percent;                            fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_IDENTIFIER;                                 fldAS: ''; fldType: TLD_integer)
  );
var
  GeneralSQL : string;
  tbInfo :     ^TTblInfo;
  DndArchiveHostName : TDndArchiveName;
begin
  Result := true;
  tbInfo := @tblInfo[tbl];
  Assert(tbl = tbl_Material_Tollerance_Types);
  DndArchiveHostName := GetDndArchiveHostName;
  if DndArchiveHostName <> TD_AS_400 then
  begin
    Result := LoadTable(tbl, AS400Speclib, ' where LANNUL' + CAnnulFilter,
                      fldList, srvQry, HostQry)
  end;
end;

//----------------------------------------------------------------------------//

function DeleteOldLogRecords(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  tbInfo:         ^TTblInfo;
  year, month, day : word;
  DateStr, Separetor : string;
  DndArchiveArcName : TDndArchiveName;
begin
  Result := true;
  Assert(tbl = tbl_Log);
  tbInfo := @tblInfo[tbl];

  DecodeDate(Now - StrToInt(IniAppGlobals.DaysKeepLogHistory), year, month, day);

  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    DateStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year))
  else if DndArchiveArcName = TD_Db2 then
    DateStr := ConvertDateFormatDb2Oracle(Now - StrToInt(IniAppGlobals.DaysKeepLogHistory), false, true)
  else if DndArchiveArcName = TD_Oracle then
  begin
    DateStr := 'to_date(' + QuotedStr(IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day) + ' ' +
                           (IntToStr(01)) + ':' + IntToStr(01) + ':' +
                           IntToStr(00)) + ', ' + QuotedStr('YYYY-MM-DD HH24:MI:SS') + ')'
  end;

  with srvQry do
  begin
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_DateTime) + ' < '  + DateStr);
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    ExecSQL;
    Close;
  end;
  UpdateOperation(_(''));
end;

//----------------------------------------------------------------------------//

function DeleteSharedDataRecords(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  tbInfo:         ^TTblInfo;
  DndArchiveArcName : TDndArchiveName;
  tblArcName, tblArcNameSched : string;
begin
  Result := true;
  Assert(tbl = tbl_prod_sched_shared_data);
//  tbInfo := @tblInfo[tbl];
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
  begin
    tblArcName  := 'PROD_SCHED_SHARED_DATA';
    tblArcNameSched := 'PROD_REQ';
  end
  else
  begin
    tblArcName  := 'SCDM_' + 'PROD_SCHED_SHARED_DATA';
    tblArcNameSched := 'SCDM_' + 'PROD_REQ';
  end;

  with srvQry do
  begin
    SQL.Clear;
    sql.add(' DELETE FROM ' + tblArcName + WHERE_IDF_Condition('PSD_IDENTIFIER') + 'AND' + ' PSD_PREQ_NO NOT IN ');
    sql.add('(SELECT PR_PREQ_NO FROM ' + tblArcNameSched + WHERE_IDF_Condition('PR_IDENTIFIER') + ')');
    ExecSQL;
    Close;
  end;

end;

//----------------------------------------------------------------------------//

end.
