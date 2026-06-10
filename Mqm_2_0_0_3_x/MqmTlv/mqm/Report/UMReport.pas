unit UMReport;

interface

uses
  Forms,
  Variants,
  SysUtils,
  Classes,
  Controls,
  UMGlobal,
  UMObjCont,
  FMMainPlan,
  UMBinDefault,
  FMbin,
  UMBinTbs,
  UMbinGrid,
  UMBinPanel,
  FmBintotals,
  UMCompat,
  UMSchedCont,
  DMSrvPC,
  UMTblDesc,
  UMSchedContFunc,
  UMArticles,
  UMIssuedArt,
  UMRes,
  UMActArea,
  UMWkCtr,
  UMBalance,
  Dialogs;

    function CreateTbl(qry: TMQMQuery; TbInfo: PTblInfo): boolean;
    function DeleteTable(qry: TMQMQuery; TbInfo: PTblInfo): boolean;
    function WriteTable(qry: TMQMQuery; TbInfo: PTblInfo): boolean;
    function GetPropValue(id: TSchedID; sPropName: string): string;
    function SaveCurrBin: boolean;
    function GetCustomer(sReqNo: string): string;
    function GetMaterialCode(id: TSchedID): string;

implementation

uses UGCustomList;

//----------------------------------------------------------------------------//

function GetMaterialCode(id: TSchedID): string;
var
  z: integer;
  MacSetupRec: TMacSetup;
  Res: TmqmRes;
  IssArtList: TMQMIssuedArtList;
  MachSetupCodeList :TMQMMacSetupList;
  IssuedAL: PTIssuedArt;
  TimingInfo: TSQtimingInfo;
begin
  p_sc.GetTimingInfo(id, TimingInfo);

  MacSetupRec.WrkCtrCode := TimingInfo.wkctCode;
  MacSetupRec.MachineSetupCode := TimingInfo.MachSetupCode;

  MachSetupCodeList := p_sc.GetStepIssMaterials(id);
  Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(id)).p_res);
  if Assigned(Res) then
  begin
    MacSetupRec.ResCat := Res.p_ResCat.p_ResCatCode;
    MacSetupRec.ResCode := Res.p_ResCode;
    MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;

    IssArtList := TMQMIssuedArtList.Create(true);
    MachSetupCodeList.GetIssuedArtList(MacSetupRec, IssArtList);

    Result := '';
    for z:= 0 to IssArtList.p_count-1 do
    begin
      IssuedAL := IssArtList.p_Item[z];
      if (IssuedAL.ArtOnBalance = aob_ReqNumber)
         or (IssuedAL.Article.p_Nature = Ar_NotBalance)
         or (IssuedAL.Article.p_Nature = Ar_AddRes)
         or (IssuedAL.Article.p_Nature = Ar_AddRes_ManPower)
         or (IssuedAL.Article.p_Nature = Ar_AddRes_Capacity) then  Continue;

      Result := Result + IssuedAL.Article.p_ArtCode;
      if Length(Result) >= 70 then
      begin
        Result := Copy(Result, 1, 70);
        Break;
      end;
      Result := Result + ', ';
    end;
    if result <> '' then
    begin
      if result[length(result)-1]= ',' then
        result := Copy(Result,1,length(Result)-2);
    end;
    IssArtList.Free;
  end;
end;

//----------------------------------------------------------------------------//

function GetCustomer(sReqNo: string): string;
var
  trsTmp : TMqmTransaction;
  qryTmp : TMqmQuery;
  tbInfoEi,
  tbInfoEC: PTblInfo;
begin
  trsTmp := CreateTransaction(Main_DB, true);
  qryTmp := CreateQuery(trsTmp, Main_DB);

  tbInfoEi := @tblInfo[tbl_ext_info];
  tbInfoEC := @tblInfo[tbl_ext_connection];
  qryTmp.Transaction.Active := true;

  with qryTmp do
  begin
    SQL.Clear;
    SQL.Add('select * FROM '+ tbInfoEi.GetTableName + ', ' + tbInfoEC.GetTableName );
    SQL.Add(' where ' + CreateFld(tbInfoEC.pfx, fli_preqNo) + '=''' + sReqNo + '''');
    SQL.Add(' and '   + CreateFld(tbInfoEi.pfx, fli_ConnKey) +'=' + CreateFld(tbInfoEC.pfx,fli_ConnKey));
    SQL.Add(' and '   + CreateFld(tbInfoEi.pfx, fli_infoLineNum) + '= 1');
    Open;

    result :=  qryTmp.FieldByName(CreateFld(tbInfoEi.pfx, fli_InfoArea)).AsString;

    Close;
  end;
  trsTmp.Commit;
  qryTmp.Free;
  trsTmp.Free;
end;

//----------------------------------------------------------------------------//

function GetPropValue(id: TSchedID; sPropName: string): string;
var
  value : variant;
begin
 value := '';
 p_sc.GetPropVal(id, GetIdFromCode(sPropName), value );
 result := VarToStr(Value);
end;

//----------------------------------------------------------------------------//

function CreateTbl(qry: TMQMQuery; TbInfo: PTblInfo): boolean;
var
  i: integer;
  sKey : string;
begin

  SetFldPfx(tbInfo.pfx);

  qry.SQL.Clear;
  qry.SQL.Add('CREATE TABLE ' + tbInfo.GetTableName+ '(');

  sKey := '';
  for i := 0 to tbInfo.nrfld - 1 do
  begin
    qry.SQL.Add(CreatePfxFldDef(tbInfo.struct[i].fInfo));

    if tbInfo.struct[i].defval > -1 then
    qry.SQL.Add(' DEFAULT ' + IntToStr(tbInfo.struct[i].defval));

    if tbInfo.struct[i].nrkey = 1 then
    begin
      if sKey = '' then
        sKey := 'PRIMARY KEY (';
      sKey := sKey + CreatePfxFld(tbInfo.struct[i].fInfo) +',';
    end;

    if tbInfo.struct[i].notnull then
      qry.SQL.Add(' NOT NULL ');

    qry.SQL.Add(',');
  end;

  if sKey = '' then
    qry.SQL.Delete(qry.SQL.Count-1)
  else
  begin
    if sKey[length(sKey)] = ',' then
    begin
      sKey[length(sKey)] := ')';
      qry.SQL.Add(sKey);
    end;
  end;

  qry.SQL.Add(')');
  qry.ExecSQL;
  qry.Close;

  result := true;
end;

//----------------------------------------------------------------------------//

function DeleteTable(qry: TMQMQuery; TbInfo: PTblInfo):boolean;
begin
  with qry do
  begin
    SQL.Clear;
    SQL.Add(' Delete from ' + tbInfo.GetTableName);
    SQL.Add('WHERE ' + CreatePfxFld(fli_WkstCode)  + '=''' +Trim(IniAppGlobals.WkstCode) + '''');
    try
      ExecSQL;
    except
      result := False ;
      Exit;
    end;
    Close;
  end;

  Result := true;

end;

//----------------------------------------------------------------------------//

function WriteTable(qry: TMQMQuery; TbInfo: PTblInfo): boolean;
var
  i,j, NumberOfRowsInBin: Integer;
  Value: Variant;
  ActTab: TBinTabSheet;
  ActBinGrid : TBinDrawGrid;
  id: TschedID;
  ColAttributes: TBinColDefault;
  dataType:  CBinColValType;
  SchedCounter,
  notSchedCounter : Integer;
  SchedQuantity,
  NotSchedQuantity: Double;
  TotSetup, TotExe: Double;
  planInfo: TSQplanInfo;
  sProdType,
  sProdArt: string;
  //
begin
  ActTab := FBin.GetActiveView;
  ActbinGrid := ActTab.GetBinGrid;
  NumberOfRowsInBin := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLinkCount;
  CalcTotals(notSchedCounter,SchedCounter,
             notSchedQuantity,SchedQuantity,TotSetup, TotExe);

  qry.SQL.Clear;
  qry.SQL.Add('INSERT INTO ' + tbInfo.GetTableName + '(');
  for j := 0 to tbInfo.nrfld -1 do
  begin
    qry.SQL.Add(CreatePfxFld(tbInfo.struct[j].fInfo));
    if j < tbInfo.nrfld -1 then
      qry.SQL.Add(',');
  end;
  qry.SQL.Add(') VALUES (');
  for j := 0 to tbInfo.nrfld -1 do
  begin
    qry.SQL.Add(' :' + CreatePfxFld(tbInfo.struct[j].fInfo));
    if j < tbInfo.nrfld -1 then
      qry.SQL.Add(',');
  end;
  qry.SQL.Add(')');
  qry.Prepare;

  for i := 0 to NumberOfRowsInBin do
  begin
    sProdType := '';
    sProdArt  := '';
    id := TSchedId(TBinPanel(ActbinGrid.Parent).m_ObjList.GetLink(i));
    if id <> CSchedIdNull then
    begin
      qry.Params[0].AsString := Trim(IniAppGlobals.WkstCode);
      //loop over all columns of row in bin
      for j:= 0 to High(BinColDefault)-1 do
      begin
      //  pos := ActbinGrid.findpos(j);
        ColAttributes := BinColDefault[j];// ActbinGrid.BinColumnSet[pos];

        p_sc.GetFldValue(Id, ColAttributes.Field ,Value, dataType);

        if (ColAttributes.Field = CSC_property1)
        or (ColAttributes.Field = CSC_property2)
        or (ColAttributes.Field = CSC_property3)
        or (ColAttributes.Field = CSC_property4)
        or (ColAttributes.Field = CSC_property5)
        or (ColAttributes.Field = CSC_property6)
        or (ColAttributes.Field = CSC_property7)
        or (ColAttributes.Field = CSC_property8)
        or (ColAttributes.Field = CSC_property9)
        or (ColAttributes.Field = CSC_property10)
        or (ColAttributes.Field = CSC_property11)
        or (ColAttributes.Field = CSC_property12)
        or (ColAttributes.Field = CSC_property13)
        or (ColAttributes.Field = CSC_property14)
        or (ColAttributes.Field = CSC_property15)
        or (ColAttributes.Field = CSC_property16)
        or (ColAttributes.Field = CSC_property17)
        or (ColAttributes.Field = CSC_property18)
        or (ColAttributes.Field = CSC_property19)
        or (ColAttributes.Field = CSC_property20)
        or (ColAttributes.Field = CSC_property21)
        or (ColAttributes.Field = CSC_property22)
        or (ColAttributes.Field = CSC_property23)
        or (ColAttributes.Field = CSC_property24)
        or (ColAttributes.Field = CSC_property25)
        or (ColAttributes.Field = CSC_property26)
        or (ColAttributes.Field = CSC_property27)
        or (ColAttributes.Field = CSC_property28)
        or (ColAttributes.Field = CSC_property29)
        or (ColAttributes.Field = CSC_property30)
        then
         Continue;

        if ColAttributes.Field = CSC_ProdType then
          sProdType := VarToStr(Value);

        if ColAttributes.Field = CSC_ProdFamily  then
          sProdArt  := VarToStr(Value);

        if (ColAttributes.Field = CSC_FwdConnReProcs)
        or (ColAttributes.Field = CSC_BkwConnSubStp)
        or (ColAttributes.Field = CSC_BkwConnReProcs)
        or (ColAttributes.Field = CSC_FwdConnSubStp) then
        begin
          Value := 0;
          dataType := CBT_integer
        end;

        case dataType of
          CBT_date   : qry.Params[j+1].AsDateTime:= Value;
          CBT_integer: qry.Params[j+1].AsInteger := Value;
          CBT_float,
          CBT_dur    : qry.Params[j+1].AsFloat   := Value;
          CBT_string : qry.Params[j+1].AsString  := Value;
          CBT_bool   : qry.Params[j+1].AsBoolean := Value;
        end;

        if ColAttributes.Field = CSC_ProdReq then
          qry.ParamByName(CreateFld(tbInfo.pfx, fli_InfoArea)).AsString := GetCustomer(value);
      end;//j Column Loop

      //write propr
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom1)).AsString  := GetPropValue(id, 'MCTAX');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom2)).AsString  := GetPropValue(id, 'MCPRI');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom3)).AsString  := GetPropValue(id, 'NEWRQ');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom4)).AsString  := GetPropValue(id, 'TPFSE');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom5)).AsString  := GetPropValue(id, 'TPLAM');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom6)).AsString  := GetPropValue(id, 'CLACQ');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom7)).AsString  := GetPropValue(id, 'CLRUV');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom8)).AsString  := GetPropValue(id, 'FRINT');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom9)).AsString  := GetPropValue(id, 'ETIRT');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom10)).AsString := GetPropValue(id, 'MTLIN');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom11)).AsString := GetPropValue(id, 'FASPR');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom12)).AsString := GetPropValue(id, 'NMIMP');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom13)).AsString := GetPropValue(id, 'DMMND');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom14)).AsString := GetPropValue(id, 'TPBAS');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom15)).AsString := GetPropValue(id, 'COL01');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom16)).AsString := GetPropValue(id, 'COL02');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom17)).AsString := GetPropValue(id, 'COL03');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom18)).AsString := GetPropValue(id, 'COL04');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom19)).AsString := GetPropValue(id, 'COL05');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom20)).AsString := GetPropValue(id, 'COL06');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom21)).AsString := GetPropValue(id, 'DIRTL');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom22)).AsString := GetPropValue(id, 'LURTL');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom23)).AsString := GetPropValue(id, 'BASPR');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom24)).AsString := GetPropValue(id, 'CHETC');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom25)).AsString := GetPropValue(id, 'CMPLX');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom26)).AsString := GetPropValue(id, 'DPCPA');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom27)).AsString := GetPropValue(id, 'ETBCO');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom28)).AsString := GetPropValue(id, 'FSRED');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom29)).AsString := GetPropValue(id, 'STPRT');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropValueFrom30)).AsString := GetPropValue(id, 'TPCOL');
      //
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_schedType)).AsString := p_sc.GetSchedType(id);
      //
      p_sc.GetPlanInfo(id, planInfo);
      case planInfo.FrcDelDate of
        CSF_Yes:        qry.ParamByName(CreateFld(tbInfo.pfx, fli_FrcDelDate)).AsString := '1';
        CSF_Forceable:  qry.ParamByName(CreateFld(tbInfo.pfx, fli_FrcDelDate)).AsString := '2';
        CSF_Yes2:       qry.ParamByName(CreateFld(tbInfo.pfx, fli_FrcDelDate)).AsString := '3';
        CSF_Forceable2: qry.ParamByName(CreateFld(tbInfo.pfx, fli_FrcDelDate)).AsString := '4';
      else
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_FrcDelDate)).AsString := '0';
      end;

//      if planInfo.FrcDelDate <> CSF_No then
//        qry.ParamByName(CreateFld(tbInfo.pfx, fli_FrcDelDate)).AsString := '1'
//      else
//        qry.ParamByName(CreateFld(tbInfo.pfx, fli_FrcDelDate)).AsString := '0';
      //
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SchedID)).AsInteger := id;
      //
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_DescArt)).AsString :=
        TMQMArticle(p_ArtTypeList.FindArticle(sProdType,sProdArt)).p_Description;
      //
      if planInfo.isOnPlan then
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_MatCode)).AsString := GetMaterialCode(id);
      //
      qry.ExecSQL;
    end;//if
  end;//i Rows Loop
  result := True;
end;

//----------------------------------------------------------------------------//

function SaveCurrBin: boolean;
var
  DB :        TMQMDatabase;
  trs:        TMQMTransaction;
  qry:        TMQMQuery;
  tbInfo:     PTblInfo;
  listTables: TStrings;
begin
  Result := False;
  listTables := TStringList.Create;

 // DB Connection
  DB := GetMqmDb(Temp_DB);
  if not DB.Connected then
    DMib.ConnectTMPDB();
  if not SrvFoundDb(Temp_DB) then
    exit;

  Screen.Cursor := crSQLWait;

  tbInfo := @tblInfo[table(tbl_report)];
  SetFldPfx(tbInfo.pfx);

  trs := CreateTransaction(Temp_DB, false);
  qry := CreateQuery(trs, Temp_DB);

  trs.Active := true;

  GetMqmDb(Temp_DB).GetTableNames(listTables, False);

  if listTables.IndexOf(tbInfo.GetTableName) = -1 then
  begin
    CreateTbl(qry, tbInfo);
    trs.Commit;
  end;

  if DeleteTable(qry, tbInfo) then
  begin
    WriteTable(qry, tbInfo);
    Result := True
  end
  else
    Result := False;

  trs.Commit;
  trs.Active := false;

  qry.Free;
  trs.Free;
  Screen.Cursor := crDefault;
end;

//----------------------------------------------------------------------------//

end.
