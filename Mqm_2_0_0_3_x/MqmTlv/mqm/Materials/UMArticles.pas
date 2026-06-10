unit UMArticles;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DMsrvPc, UMCommon, StdCtrls, UMBalance, UGCustomList, UMGlobal;

type

  SetArProdNature = set of ArProdNature;

  ArResTime = (Ar_No, Ar_NoMatSetup, Ar_MatSetup, Ar_Exec, Ar_Day);
  ArMaterialScheduleLvl = (MT_No, MT_BaseLvl, MT_SecondLvl);

  TRecArticle = record
    ArticleCode: string;
    Nature: ArProdNature;
    AddResStart: ArResTime;
    AddResEnd: ArResTime;
    Description: string;
    IgnoreMatCheck : boolean;
    StdPurcOrProdTime : integer;
    MaterialTolleranceCode : string;
    HoursToDownFromMachine : integer;
    MaterialSchedule   : ArMaterialScheduleLvl;
    MaterialStandardSetupMinutes : double;
    MaterialStandardSpeed : double;
  end;

  TTollerancePercent = record
    Code : string;
    TolleranceQty1 : double;
    TollerancePercent1 : integer;
    TolleranceQty2 : double;
    TollerancePercent2 : integer;
    TolleranceQty3 : double;
    TollerancePercent3 : integer;
    TolleranceQty4 : double;
    TollerancePercent4 : integer;
    TolleranceQty5 : double;
    TollerancePercent5 : integer;
  end;
  PTTollerancePercent = ^TTollerancePercent;

  TMQMArticle = class;

  //Vinc
  TMQMArticleType = class
    constructor Create(sArtType: string);
    destructor  Destroy; override;
  private
    m_ArticleList: TList;
    m_ArtTypeCode: string;
  public
    function  SearchAndAddArticle(recArticle: TRecArticle): TMQMArticle;
    function  AddArticle(recArticle: TRecArticle): TMQMArticle;
//    function  FindArticle(sArtCode: string): TMQMArticle;
    procedure ClearBalanceLists;
    property p_ArtTypeCode: string read m_ArtTypeCode;
    property p_ArticleList: TList  read m_ArticleList;
  end;

  TMQMArticle = class
    constructor Create(ArtType:TMQMArticleType; recArticle: TRecArticle);
    destructor  Destroy; override;
  private
    m_Type: TMQMArticleType;
    m_ArticleCode: string;
    m_NumberOfDecimal : integer;
    m_Nature: ArProdNature;
    m_AddResStart: ArResTime;
    m_AddResEnd: ArResTime;
    m_Description: string;
    m_IgnoreCheck: boolean;
    m_NetGroupList: TMQMNetGroupList;
    m_RecTollerancePercent : TTollerancePercent;
    m_StdPurcOrProdTime : integer;
    m_HoursToDownFromMachine : integer;
    m_MaterialSchedule   : ArMaterialScheduleLvl;
    m_MaterialStandardSetupMinutes : double;
    m_MaterialStandardSpeed : double;

  public
    function FindNetGroup(sNetGroupCode: string; var Index : Integer): TMQMNetGroup;
    function AddNetGroup(sNetGroupCode: string): TMQMNetGroup;
    procedure ClearBalanceLists;
    function GetTolleranceQuantity(RequiredQuantity: double): double;
    property p_ArtType: TMQMArticleType         read m_Type;
    property p_Nature: ArProdNature             read m_Nature;
    property p_ArtCode: string                  read m_ArticleCode;
    property p_AddResStart: ArResTime           read m_AddResStart;
    property p_AddResEnd: ArResTime             read m_AddResEnd;
    property p_NetGroupList: TMQMNetGroupList   read m_NetGroupList;
    property p_Description: string              read m_Description;
    property p_IgnoreCheck: boolean             read m_IgnoreCheck;
    property p_RecTollerancePercent: TTollerancePercent read m_RecTollerancePercent;
    property p_StdPurcOrProdTime : integer      read m_StdPurcOrProdTime;
    property P_HoursToDownFromMachine : integer read m_HoursToDownFromMachine;
	  property p_MaterialSchedule : ArMaterialScheduleLvl read m_MaterialSchedule;
    property p_MaterialStandardSetupMinutes : double  read m_MaterialStandardSetupMinutes;
    property p_MaterialStandardSpeed : double  read m_MaterialStandardSpeed;
    property p_NumberOfDecimal : Integer read m_NumberOfDecimal;
  end;

  TMQMArtTypeList = class(TMQMCustomList)
    destructor  Destroy; override;
  public
    function AddArtType(sArtType: string): TMQMArticleType;
    function FindArtType(sArtType: string): TMQMArticleType;
    function FindArticle(sArtType, sArtProd: string): TMQMArticle;
    function LoadFromDb(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; WorkCentersHandledList, WorkCentersViewedList : string) : boolean;
    procedure ClearBalanceLists;
  end;

  function DecodeNature(iNature: integer): ArProdNature;
  function DecodeResTime(iResTime: integer): ArResTime;

  implementation

uses
  UMTblDesc, gnugettext, DB, UMObjCont, UMSchedContFunc;
var
  m_MaterialTolleranceList : TList;

{
******************************* internal funtion ******************************
}

//----------------------------------------------------------------------------//

function SortArtType(Item1, Item2: Pointer): integer;
var
  ArtType1, ArtType2 : TMQMArticleType;
begin
  ArtType1 := TMQMArticleType(Item1);
  ArtType2 := TMQMArticleType(Item2);

  if ArtType1.m_ArtTypeCode = ArtType2.m_ArtTypeCode then
    Result :=  0
  else
    if ArtType1.m_ArtTypeCode < ArtType2.m_ArtTypeCode then
      Result := -1
    else
      Result :=  1
end;


//----------------------------------------------------------------------------//

function DecodeNature(iNature: integer): ArProdNature;
begin
  case iNature of
    0: result := Ar_NotBalance;
    1: result := Ar_Material;
    2: result := Ar_MatWithDet;
    3: result := Ar_AddRes;
    4: result := Ar_AddRes_ManPower;
    5: result := Ar_AddRes_Capacity
  else
    result := Ar_NotBalance;
  end;

end;

//----------------------------------------------------------------------------//

function DecodeResTime(iResTime: integer): ArResTime;
begin
  case iResTime of
    0: result := Ar_No;
    1: result := Ar_NoMatSetup;
    2: result := Ar_MatSetup;
    3: result := Ar_Exec;
    4: result := Ar_Day;
  else
    result := Ar_No;
  end;
end;

{
******************************* TMQMArtTypeList ********************************
}
{
procedure TMQMArtTypeList.LoadFromDb(OnStart : boolean; qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText);
var
  tbInfoProducts : ^TTblInfo;
  tbInfoBalance_Hed : ^TTblInfo;
//  tbInfoBalance_Det : ^TTblInfo;
  sOldArtType: string;
  ArtType : TMQMArticleType;
  Article : TMQMArticle;
  recArt: TRecArticle;
  recBalance: TArtBalance;
  recBobbin: PTRecBobbin;
begin
  if Assigned(ProgBar) then ProgBar.SetPosition(0);
  if Assigned(Status) then Status.Caption := _('Reading products from database...');
  Application.ProcessMessages;

  tbInfoProducts    := @tblInfo[tbl_products];
  tbInfoBalance_Hed := @tblInfo[tbl_balance_header];
//  tbInfoBalance_Det := @tblInfo[tbl_balance_detail];

  with qry do
  begin
    if OnStart then Transaction.StartTransaction;
    SQL.Clear;
    SQL.Add('select ');
    SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProdType) + ',');
    SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProdCode) + ',');
    SQL.Add(CreateFld(tbInfoProducts.pfx,fli_IgnorMaterialCheck) + ',');
    SQL.Add(CreateFld(tbInfoBalance_Hed.pfx, fli_netGroupCode) + ',');
    SQL.Add(CreateFld(tbInfoBalance_Hed.pfx, fli_DueDate)      + ',');
    SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProductNature)    + ',');
    SQL.Add(CreateFld(tbInfoProducts.pfx,fli_StartConsumPoint) + ',');
    SQL.Add(CreateFld(tbInfoProducts.pfx,fli_EndConsumPoint)   + ',');
    SQL.Add(CreateFld(tbInfoProducts.pfx,fli_InfoArea)         + ',');
    SQL.Add(CreateFld(tbInfoBalance_Hed.pfx,fli_ProdType)      + ',');
    SQL.Add(CreateFld(tbInfoBalance_Hed.pfx,fli_DueDate)       + ',');
    SQL.Add(CreateFld(tbInfoBalance_Hed.pfx,fli_InfoArea)      + ',');
    SQL.Add(CreateFld(tbInfoBalance_Hed.pfx,fli_quant));
    SQL.Add(' from ' +  tbInfoProducts.PCname);
    SQL.Add(' Left join ' + tbInfoBalance_Hed.PCname + ' on (');
    SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProdType) + '=' + CreateFld(tbInfoBalance_Hed.pfx,fli_ProdType));
    SQL.Add(' and ' + CreateFld(tbInfoProducts.pfx,fli_ProdCode) + '=' + CreateFld(tbInfoBalance_Hed.pfx,fli_ProdCode));
    SQL.Add(' )');
    SQL.Add(' order by ' + CreateFld(tbInfoProducts.pfx, fli_ProdType) + ',');
    SQL.Add(CreateFld(tbInfoProducts.pfx, fli_ProdCode)        + ',');
    SQL.Add(CreateFld(tbInfoBalance_Hed.pfx, fli_netGroupCode) + ',');
    SQL.Add(CreateFld(tbInfoBalance_Hed.pfx, fli_DueDate));
    Open;
    Application.ProcessMessages;

    if Assigned(ProgBar) then ProgBar.SetMax(2500);
    if Assigned(Status) then Status.Caption := _('Loading products in memory...');
    Application.ProcessMessages;

    //Add a phantom article type for the requests
    AddArtType('REQUEST');

    ArtType := nil;
    sOldArtType := 'EMPTY';

    New(recBobbin);  // only as a par for one procedure
    while not Eof do
    begin
      Application.ProcessMessages;

      if sOldArtType <> qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_ProdType)).AsString then
      begin
        ArtType := AddArtType(qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_ProdType)).AsString);
        sOldArtType := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_ProdType)).AsString;
      end;

      with recArt do
      begin
        ArticleCode := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_ProdCode)).AsString;
        Nature      := DecodeNature(qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_ProductNature)).AsInteger);
        AddResStart := DecodeResTime(qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_StartConsumPoint)).AsInteger);
        AddResEnd   := DecodeResTime(qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_EndConsumPoint)).AsInteger);
        Description := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_InfoArea)).AsString;
        IgnoreMatCheck := false;
        if qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_IgnorMaterialCheck)).AsString = '1' then
          IgnoreMatCheck := true
      end;

      Article := ArtType.AddArticle(recArt);
      Application.ProcessMessages;

      if recArt.Nature <> Ar_NotBalance then
      begin
        if not qry.FieldByName(CreateFld(tbInfoBalance_Hed.pfx,fli_ProdType)).isnull and
               (qry.FieldByName(CreateFld(tbInfoBalance_Hed.pfx,fli_DueDate)).AsDateTime > 0)  then
        begin
          recBalance.BalanceType := bt_Entry;
          recBalance.DueDate     := qry.FieldByName(CreateFld(tbInfoBalance_Hed.pfx,fli_DueDate)).AsDateTime;
          recBalance.JobID       := CSchedIDnull;
          recBalance.BobinCode   := '';
          recBalance.Description := qry.FieldByName(CreateFld(tbInfoBalance_Hed.pfx,fli_InfoArea)).AsString;
          recBalance.Quantity    := qry.FieldByName(CreateFld(tbInfoBalance_Hed.pfx,fli_quant)).AsFloat;
          recBalance.RecType     := brt_NoDet;
          recBalance.ToRequest   := '';
          recBalance.TotalBal    := 0;
          recBalance.TotExpBal   := 0;
          recBalance.TotExpUsed  := 0;
          recBalance.RealQty     := 0;
          //Add net group and balance
          Article.m_NetGroupList.AddNetGroup(qry.FieldByName(CreateFld(tbInfoBalance_Hed.pfx,fli_NetGroupCode)).AsString, recBalance, nil);
        end;
      end;
      Application.ProcessMessages;

      Next;

      if Assigned(ProgBar) then ProgBar.SetPosition(RecNo);
    end;
    qry.Close;
    if OnStart then Transaction.Commit;
    Dispose(recBobbin);   // only as a par for one procedure
  end;

  SortList(SortArtType);

  if Assigned(ProgBar) then ProgBar.SetPosition(0);
  if Assigned(Status) then  Status.Caption := '';
  Application.ProcessMessages;
end;   }

function GetMaterialTolleranceForCode(code : string) : TTollerancePercent;
var
  I : integer;
begin
  for I := 0 to m_MaterialTolleranceList.Count -1 do
  begin
    if code = PTTollerancePercent(m_MaterialTolleranceList[I]).Code then
    begin
      result.TolleranceQty1     := PTTollerancePercent(m_MaterialTolleranceList[I]).TolleranceQty1;
      result.TollerancePercent1 := PTTollerancePercent(m_MaterialTolleranceList[I]).TollerancePercent1;
      result.TolleranceQty2     := PTTollerancePercent(m_MaterialTolleranceList[I]).TolleranceQty2;
      result.TollerancePercent2 := PTTollerancePercent(m_MaterialTolleranceList[I]).TollerancePercent2;
      result.TolleranceQty3     := PTTollerancePercent(m_MaterialTolleranceList[I]).TolleranceQty3;
      result.TollerancePercent3 := PTTollerancePercent(m_MaterialTolleranceList[I]).TollerancePercent3;
      result.TolleranceQty4     := PTTollerancePercent(m_MaterialTolleranceList[I]).TolleranceQty4;
      result.TollerancePercent4 := PTTollerancePercent(m_MaterialTolleranceList[I]).TollerancePercent4;
      result.TolleranceQty5     := PTTollerancePercent(m_MaterialTolleranceList[I]).TolleranceQty5;
      result.TollerancePercent5 := PTTollerancePercent(m_MaterialTolleranceList[I]).TollerancePercent5;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure FillMaterialTolleranceList;
var
  qry:    TMqmQuery;
  tbInfo : ^TTblInfo;
  TolleranceCode : string;
  TollerancePercent : PTTollerancePercent;
begin
  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_Material_Tollerance_Types];
  with qry do
  begin
    SQL.Clear;
    SQL.Add('select * from ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    open;
    while not Eof do
    begin
      Application.ProcessMessages;
      new(TollerancePercent);
      TollerancePercent.Code           := qry.FieldByName(CreateFld(tbInfo.pfx,fli_Material_Tollerance_Types_Code)).AsString;
      TollerancePercent.TolleranceQty1 := qry.FieldByName(CreateFld(tbInfo.pfx,fli_TillQty1)).AsFloat;
      TollerancePercent.TollerancePercent1 := qry.FieldByName(CreateFld(tbInfo.pfx,fli_TillQty1Percent)).AsInteger;
      TollerancePercent.TolleranceQty2 := qry.FieldByName(CreateFld(tbInfo.pfx,fli_TillQty2)).AsFloat;
      TollerancePercent.TollerancePercent2 := qry.FieldByName(CreateFld(tbInfo.pfx,fli_TillQty2Percent)).AsInteger;
      TollerancePercent.TolleranceQty3 := qry.FieldByName(CreateFld(tbInfo.pfx,fli_TillQty3)).AsFloat;
      TollerancePercent.TollerancePercent3 := qry.FieldByName(CreateFld(tbInfo.pfx,fli_TillQty3Percent)).AsInteger;
      TollerancePercent.TolleranceQty4 := qry.FieldByName(CreateFld(tbInfo.pfx,fli_TillQty4)).AsFloat;
      TollerancePercent.TollerancePercent4 := qry.FieldByName(CreateFld(tbInfo.pfx,fli_TillQty4Percent)).AsInteger;
      TollerancePercent.TolleranceQty5 := qry.FieldByName(CreateFld(tbInfo.pfx,fli_TillQty5)).AsFloat;
      TollerancePercent.TollerancePercent5 := qry.FieldByName(CreateFld(tbInfo.pfx,fli_TillQty5Percent)).AsInteger;
      m_MaterialTolleranceList.Add(TollerancePercent);
      Next
    end;
    Close;
  end;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function FillMaterialRelevantPerWorkCenterList(MatRelStrList : TStringList; Status : TStaticText; ProgBar: TMqmProgBar) : string;
var
  qry:    TMqmQuery;
  tbInfoMat, tbInfoProdStep, tbInfoArt, tbInfoWW : ^TTblInfo;
  PrgHour, PrgMinute, PrgSecond, PrgMilliSecond, PrgPrevSecond : Word;
  PrgIndex, PrgBlock : integer;
begin
  qry := CreateQuery(Main_DB);
  tbInfoMat := @tblInfo[tbl_material];
  tbInfoProdStep := @tblInfo[tbl_prod_step];
  tbInfoArt := @tblInfo[tbl_produced_article];
  tbInfoWW := @tblInfo[tbl_wkst_wkc];

  if Assigned(Status) then
    Status.Caption := _('Filling Material relevant per Work Center list...');
  Application.ProcessMessages;

  result := '';

  with qry do
  begin
    SQL.Clear;

    // EXISTS → IN subquery: PROD_STEP+WW scanned once instead of once per material/article row
    sql.Text := 'select distinct m.mt_net_group_code from ' + tbInfoMat.GetTableName + ' m '
      + ' where m.mt_identifier = ' + IniAppGlobals.Identifier
      + ' and m.mt_PREQ_NO in (select pd.PD_PREQ_NO from ' + tbInfoProdStep.GetTableName
      + ' pd join ' + tbInfoWW.GetTableName + ' WW on ww.WW_IDENTIFIER = pd.pd_IDENTIFIER'
      + ' and ww.ww_wkcnter = pd.pd_wkcnter and ww.WW_WKST_CODE=' + QuotedStr(IniAppGlobals.WkstCode)
      + ' where pd.pd_IDENTIFIER = ' + IniAppGlobals.Identifier
      + ' and pd.PD_SCHDULE_BY_MQM=' + '''1''' + ')'
      + ' union '
      + ' select distinct pa.pa_net_group_code from ' + tbInfoArt.GetTableName + ' PA'
      + ' where pa.pa_identifier = ' + IniAppGlobals.Identifier
      + ' and pa.pa_PREQ_NO in (select pd.PD_PREQ_NO from ' + tbInfoProdStep.GetTableName
      + ' pd join ' + tbInfoWW.GetTableName + ' WW on ww.WW_IDENTIFIER = pd.pd_IDENTIFIER'
      + ' and ww.ww_wkcnter = pd.pd_wkcnter and ww.WW_WKST_CODE=' + QuotedStr(IniAppGlobals.WkstCode)
      + ' where pd.pd_IDENTIFIER = ' + IniAppGlobals.Identifier
      + ' and pd.PD_SCHDULE_BY_MQM=' + '''1''' + ')';

    FetchOptions.RowsetSize := 5000;
    Open;

    if Assigned(ProgBar) then
    begin
      ProgBar.SetMax(0);
      ProgBar.SetPosition(0);
    end;
    PrgIndex := 0;

    var fld_NetGroup := qry.FieldByName('mt_net_group_code');
    while not Eof do
    begin
      var sNetGroup := fld_NetGroup.AsString;
      MatRelStrList.Add(sNetGroup);

      if Result <> '' then
        Result := Result + ',' + QuotedStr(sNetGroup)
      else
        Result := QuotedStr(sNetGroup);

      DecodeTime(Now, PrgHour, PrgMinute, PrgSecond, PrgMilliSecond);
      if PrgPrevSecond <> PrgSecond then
      begin
        PrgPrevSecond := PrgSecond;
        ProgBar.SetPosition(PrgIndex);
        Application.ProcessMessages;
      end;
      inc(PrgIndex);

      Next
    end;
    Close;
  end;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function TMQMArtTypeList.LoadFromDb(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; WorkCentersHandledList, WorkCentersViewedList : string) : boolean;
type
 TItemsStock = record
   ItemType : String;
   netGroup : String;
   ItemCode : String;
   Stock    : double;
   Article : TMQMArticle;
 end;
 PTItemsStock = ^TItemsStock;

 TItemsStockChangeAndException = record
   ByDate : boolean;
   Date : TDate;
   DayInWeek : Integer;
   fromTime : integer;
   ToTime : integer;
   StockDifference : double;
 end;
 PTItemsStockChangeAndException = ^TItemsStockChangeAndException;

var
  tbInfoProdreqHdr           : ^TTblInfo;
  tbInfoProdStep             : ^TTblInfo;
  tbInfoPrododucedArticle    : ^TTblInfo;
  tbInfoProducts             : ^TTblInfo;
  tbInfoBalance_Hed          : ^TTblInfo;
  tbInfoMaterial             : ^TTblInfo;
  tbInfoItemsStock           : ^TTblInfo;
  tbInfoItemsStockChanges    : ^TTblInfo;
  tbInfoItemsStockExceptions : ^TTblInfo;
  CurrentArtType, sOldArtType: string;
  CurrentArticleCode, sOldArticleCode : string;
  ArtType : TMQMArticleType;
  Article : TMQMArticle;
  recArt: TRecArticle;
  recBalance: TArtBalance;
  P_ArticleCode, P_ProdType, P_ProductNature, P_StartConsumPoint, P_EndConsumPoint, P_InfoArea, P_HoursToDownFromMachine,
  P_IgnorMaterialCheck, p_MatTorreranceCode, P_StdPurcOrProdTime,
  P_MaterialSchedule, P_MaterialStandardSetupMinutes, P_MaterialStandardSpeed : TField;
  PrgHour, PrgMinute, PrgSecond, PrgMilliSecond, PrgPrevSecond : Word;
  PrgIndex, PrgBlock : integer;
  Index, Index1, Index2, i, MatCount, PrgRowCount : integer;
  ItemsStockList, ItemsStockChangeAndExceptionList : TList;
  PItemsStock : PTItemsStock;
  PItemsStockChangeAndException : PTItemsStockChangeAndException;
  CurrentDate, DateOfBalance, DateOfBalanceCalced : TDate;
  FromTime, ToTime : TDateTime;
  Hour, Min, Sec, MSec: Word;
  Year, Month, Day: Word;
  ExceptionByDateFound : Boolean;
  MaterialPerWorkCenterList, sqlText, WorkCentersList : string;
  MatRelStrList : TStringList;
  AllExcMap, AllChgMap : TStringList;
  AllExcSubList, AllChgSubList : TList;
  itemKey : String;
  mapIdx : Integer;
begin

  Result := true;
  FillMaterialTolleranceList;

  MatRelStrList := TStringList.Create;
  MaterialPerWorkCenterList := FillMaterialRelevantPerWorkCenterList(MatRelStrList, Status, ProgBar);
  MatRelStrList.Sorted := True;

  if Assigned(ProgBar) then
  begin
    ProgBar.SetPosition(0);
    ProgBar.SetMax(2000);
    PrgBlock := trunc(2000/100) + 1;
    PrgIndex := 0;
    PrgPrevSecond := 0;
  end;

  if Assigned(Status) then Status.Caption := _('Reading products from database...');
  Application.ProcessMessages;

  tbInfoProdreqHdr           := @tblInfo[tbl_prod_reqHdr];
  tbInfoProdStep             := @tblInfo[tbl_prod_step];
  tbInfoPrododucedArticle    := @tblInfo[tbl_produced_article];
  tbInfoProducts             := @tblInfo[tbl_products];
  tbInfoBalance_Hed          := @tblInfo[tbl_balance_header];
  tbInfoMaterial             := @tblInfo[tbl_material];
  tbInfoItemsStock           := @tblInfo[tbl_ItemsStock];
  tbInfoItemsStockChanges    := @tblInfo[tbl_ItemsStockChanges];
  tbInfoItemsStockExceptions := @tblInfo[tbl_ItemsStockExceptions];

  if WorkCentersHandledList = '' then
  begin
    if WorkCentersViewedList = '' then
      WorkCentersList := ''
    else
      WorkCentersList := WorkCentersViewedList;
  end
  else
  begin
    if WorkCentersViewedList = '' then
      WorkCentersList := WorkCentersHandledList
    else
      WorkCentersList := WorkCentersHandledList + ',' + WorkCentersViewedList;
  end;

  if WorkCentersList = '' then exit;

  with qry do
  begin
    SQL.Clear;

    if IniAppGlobals.downloadTo = '2' then
    begin
      SQL.Add('select ');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProdType) + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProdCode) + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_IgnorMaterialCheck) + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProductNature)    + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_StartConsumPoint) + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_EndConsumPoint)   + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_StdPurcOrProdTime)   + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_Material_Tollerance_Types_Code)   + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_HoursToDownFromMachine) + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_MaterialSchedule)   + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_MaterialStandardSetupMinutes)   + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_MaterialStandardSpeed)   + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_InfoArea));
      SQL.Add(' from ' +  tbInfoProducts.GetTableName);
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoProducts.pfx, fli_Identifier)));
      SQL.Add(' order by ' + CreateFld(tbInfoProducts.pfx, fli_ProdType) + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx, fli_ProdCode));
      FetchOptions.RowsetSize := 5000;
      Open;
    end
    else
    begin

      // EXISTS → IN subquery: PROD_STEP scanned once per branch instead of once per row
      sqlText := 'Select * from (' +
                 ' Select distinct mt.MT_IDENTIFIER IDENTIFIER, mt.MT_TYPE_PROD TYPE_PROD, mt.MT_PRODUCT_CODE PRODUCT_CODE' +
                 ' From ' + tbInfoMaterial.GetTableName + ' MT' +
                   WHERE_IDF_Condition(CreateFld(tbInfoMaterial.pfx, fli_Identifier)) +
                 ' AND MT.MT_PREQ_NO IN (select PD.PD_PREQ_NO from ' + tbInfoProdStep.GetTableName + ' PD' +
                 ' where PD.PD_IDENTIFIER = ' + IniAppGlobals.Identifier +
                 ' AND PD.PD_PSTEP_ID = MT.MT_PSTEP_ID' +
                 ' AND PD.PD_WKCNTER IN (' + WorkCentersList + ')' + ')' +
                 ' union ' +
                 ' Select distinct pa.pa_IDENTIFIER IDENTIFIER, ph.PH_TYPE_PROD TYPE_PROD, pa.PA_PRODUCT_CODE PRODUCT_CODE ' +
                 ' From ' + tbInfoPrododucedArticle.GetTableName + ' PA' +
                 ' join ' + tbInfoProdreqHdr.GetTableName + ' ph on ph.PH_IDENTIFIER = pa.PA_IDENTIFIER and ph.PH_PREQ_NO = pa.PA_PREQ_NO' +
                 ' WHERE pa.PA_IDENTIFIER = ' + IniAppGlobals.Identifier +
                 ' AND pa.PA_PREQ_NO IN (select PD.PD_PREQ_NO from ' + tbInfoProdStep.GetTableName + ' PD' +
                 ' where PD.PD_IDENTIFIER = ' + IniAppGlobals.Identifier +
                 ' AND PD.PD_WKCNTER IN (' + WorkCentersList + ')' + ')' +
                 ' ) MTPA ' +
                 ' join ' + tbInfoProducts.GetTableName + ' P on p.PAR_IDENTIFIER = mtpa.IDENTIFIER and p.PAR_TYPE_PROD = mtpa.TYPE_PROD and p.PAR_PRODUCT_CODE = mtpa.PRODUCT_code' +
                 ' order by ' + CreateFld(tbInfoProducts.pfx, fli_ProdType) + ',' +
                   CreateFld(tbInfoProducts.pfx, fli_ProdCode);

         SQL.Add(sqlText);
         FetchOptions.RowsetSize := 5000;
         Open;
    end;

    P_ProdType :=  qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_ProdType));
    P_ArticleCode  := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_ProdCode));
    P_ProductNature := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_ProductNature));
    P_StartConsumPoint := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_StartConsumPoint));
    P_EndConsumPoint := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_EndConsumPoint));
    P_InfoArea := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_InfoArea));
    P_HoursToDownFromMachine := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_HoursToDownFromMachine));
    P_IgnorMaterialCheck := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_IgnorMaterialCheck));
    p_MatTorreranceCode  := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_Material_Tollerance_Types_Code));
    P_StdPurcOrProdTime  := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_StdPurcOrProdTime));
    P_MaterialSchedule   := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_MaterialSchedule));
    P_MaterialStandardSetupMinutes := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_MaterialStandardSetupMinutes));
    P_MaterialStandardSpeed        := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_MaterialStandardSpeed));

    if Assigned(Status) then Status.Caption := _('Loading products in memory...');

    //add a phantom article type for the requests
    AddArtType('REQUEST');

    ArtType := nil;
    sOldArtType := 'EMPTY';
    PrgRowCount := 0;

    try
    while not Eof do
    begin
      if sOldArtType <> P_ProdType.AsString then
      begin
        ArtType := AddArtType(P_ProdType.AsString);
        sOldArtType := P_ProdType.AsString;
      end;

      with recArt do
      begin
        ArticleCode := P_ArticleCode.AsString;
        Nature      := DecodeNature(P_ProductNature.AsInteger);
        AddResStart := DecodeResTime(P_StartConsumPoint.AsInteger);
        AddResEnd   := DecodeResTime(P_EndConsumPoint.AsInteger);
        if (P_StdPurcOrProdTime.AsString = '') then
           StdPurcOrProdTime := 0
        else
          StdPurcOrProdTime := P_StdPurcOrProdTime.AsInteger;
        HoursToDownFromMachine := 0;
        if not (P_HoursToDownFromMachine.IsNull) and (P_HoursToDownFromMachine.AsInteger > 0) then
           HoursToDownFromMachine := P_HoursToDownFromMachine.AsInteger;

        Description := P_InfoArea.AsString;
        MaterialTolleranceCode := p_MatTorreranceCode.AsString;
        IgnoreMatCheck := false;
        if P_IgnorMaterialCheck.AsString = '1' then
          IgnoreMatCheck := true;

        MaterialSchedule   :=  MT_No;
        if P_MaterialSchedule.AsString = '1' then
           MaterialSchedule := MT_BaseLvl
        else if P_MaterialSchedule.AsString = '2' then
           MaterialSchedule := MT_SecondLvl;
        MaterialStandardSetupMinutes := P_MaterialStandardSetupMinutes.AsFloat;
        MaterialStandardSpeed        := P_MaterialStandardSpeed.AsFloat;
      end;

      ArtType.SearchAndAddArticle(recArt);

      inc(PrgRowCount);
      if (PrgRowCount mod 500 = 0) then Application.ProcessMessages;
      Next;

    end;
    except
      showMessage(_('problem occurred while loading Products file :') + #13#10 +
                   _('Product type') + ' - '  + ArtType.m_ArtTypeCode + ', ' + _('Product Code') + ' - ' + recArt.ArticleCode);
      Result := false;
      Exit
    end;
    qry.Close;
  end;
  SortList(SortArtType);

  with qry do
  begin
    if Assigned(ProgBar) then
    begin
      ProgBar.SetPosition(0);
      PrgIndex := 0;
    end;

    if MatRelStrList.Count > 0 then
    begin
      if Assigned(Status) then Status.Caption := _('Reading balance in memory...');

      SQL.Clear;
      SQL.Add('select ');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProdType) + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProdCode) + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_IgnorMaterialCheck) + ',');
      SQL.Add(CreateFld(tbInfoBalance_Hed.pfx, fli_netGroupCode) + ',');
      SQL.Add(CreateFld(tbInfoBalance_Hed.pfx, fli_DueDate)      + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProductNature)    + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_StartConsumPoint) + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_EndConsumPoint)   + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_InfoArea)         + ',');
      SQL.Add(CreateFld(tbInfoBalance_Hed.pfx,fli_DueDate)       + ',');
      SQL.Add(CreateFld(tbInfoBalance_Hed.pfx,fli_InfoArea)      + ',');
      SQL.Add(CreateFld(tbInfoBalance_Hed.pfx,fli_quant));
      SQL.Add(' from ' +  tbInfoBalance_Hed.GetTableName);
      SQL.Add(' join ' + tbInfoProducts.GetTableName + ' on (');
      SQL.Add(CreateFld(tbInfoProducts.pfx,fli_ProdType) + '=' + CreateFld(tbInfoBalance_Hed.pfx,fli_ProdType));
      SQL.Add(' and ' + CreateFld(tbInfoProducts.pfx,fli_ProdCode) + '=' + CreateFld(tbInfoBalance_Hed.pfx,fli_ProdCode));
      SQL.Add(' and ' + CreateFld(tbInfoProducts.pfx,fli_IDENTIFIER) + '=' + CreateFld(tbInfoBalance_Hed.pfx,fli_IDENTIFIER));
      SQL.Add(' )');

      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoBalance_Hed.pfx, fli_Identifier)));

      if MatRelStrList.Count < 500 then
        if MaterialPerWorkCenterList <> '' then
          SQL.Add(' and ' + CreateFld(tbInfoBalance_Hed.pfx, fli_netGroupCode) + ' in (' + MaterialPerWorkCenterList + ')');

      SQL.Add(' order by ' + CreateFld(tbInfoProducts.pfx, fli_ProdType) + ',');
      SQL.Add(CreateFld(tbInfoProducts.pfx, fli_ProdCode)        + ',');
      SQL.Add(tbInfoBalance_Hed.GetTableName + '.' + CreateFld(tbInfoBalance_Hed.pfx, fli_netGroupCode) + ',');
      SQL.Add(tbInfoBalance_Hed.GetTableName + '.' + CreateFld(tbInfoBalance_Hed.pfx, fli_DueDate));
      FetchOptions.RowsetSize := 5000;
      Open;

      if Assigned(Status) then Status.Caption := _('Loading balance in memory...');

      var B2_ProdType     := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_ProdType));
      var B2_ProdCode     := qry.FieldByName(CreateFld(tbInfoProducts.pfx,fli_ProdCode));
      var B2_DueDate      := qry.FieldByName(CreateFld(tbInfoBalance_Hed.pfx,fli_DueDate));
      var B2_InfoArea     := qry.FieldByName(CreateFld(tbInfoBalance_Hed.pfx,fli_InfoArea));
      var B2_Quant        := qry.FieldByName(CreateFld(tbInfoBalance_Hed.pfx,fli_quant));
      var B2_NetGroupCode := qry.FieldByName(CreateFld(tbInfoBalance_Hed.pfx,fli_NetGroupCode));
      sOldArtType := 'EMPTY';
      sOldArticleCode := 'EMPTY';
      Article := nil;
      PrgRowCount := 0;

      while not Eof do
      begin
        if (sOldArtType <> B2_ProdType.AsString) or
           (sOldArticleCode <> B2_ProdCode.AsString) then
        begin
          CurrentArtType := B2_ProdType.AsString;
          sOldArtType := CurrentArtType;
          CurrentArticleCode := B2_ProdCode.AsString;
          sOldArticleCode := CurrentArticleCode;
          Article := FindArticle(CurrentArtType, CurrentArticleCode);
        end;
                // if there is a balance record that does not exist in the producted article and the material ,
                // we ignore that balance.
        if Article <> nil then
        begin
          if Article.m_Nature <> Ar_NotBalance then
          begin
            recBalance.BalanceType := bt_Entry;
            recBalance.DueDate     := B2_DueDate.AsDateTime;
            recBalance.JobID       := CSchedIDnull;
            recBalance.BobinCode   := '';
            recBalance.Description := _(B2_InfoArea.AsString);
            recBalance.Quantity    := B2_Quant.AsFloat;
            recBalance.RecType     := brt_NoDet;
            recBalance.ToRequest   := '';
            recBalance.TotalBal    := 0;
            recBalance.TotExpBal   := 0;
            recBalance.TotExpUsed  := 0;
            recBalance.RealQty     := 0;

            if MatRelStrList.Count >= 500 then
            begin
              if MatRelStrList.IndexOf(B2_NetGroupCode.AsString) > -1 then
                 Article.m_NetGroupList.AddNetGroup(B2_NetGroupCode.AsString, recBalance, nil);
            end
            else
              Article.m_NetGroupList.AddNetGroup(B2_NetGroupCode.AsString, recBalance, nil);

          end;
        end;

        Next;

      end;
      qry.Close;

    end;

  end;

  with qry do
  begin

    if Assigned(ProgBar) then
    begin
      ProgBar.SetPosition(0);
      PrgIndex := 0;
    end;

    if MatRelStrList.Count > 0 then
    begin

      if Assigned(Status) then Status.Caption := _('Reading materials for completing balances in memory...');
      PrgRowCount := 0;
      SQL.Clear;
      SQL.Add('select ');
      SQL.Add('DISTINCT ');

      SQL.Add(CreateFld(tbInfoMaterial.pfx,fli_ProdType) + ',');
      SQL.Add(CreateFld(tbInfoMaterial.pfx,fli_ProdCode) + ',');
      SQL.Add(CreateFld(tbInfoMaterial.pfx, fli_netGroupCode));
      // LEFT JOIN replaces NOT EXISTS correlated subquery � DB2 uses hash/merge join (O(N+M)) instead of nested loops (O(N*M))
      SQL.Add(' from ' + tbInfoMaterial.GetTableName);
      SQL.Add(' LEFT JOIN ' + tbInfoBalance_Hed.GetTableName);
      SQL.Add(' ON ' + CreateFld(tbInfoBalance_Hed.pfx,fli_ProdType)     + ' = ' + CreateFld(tbInfoMaterial.pfx,fli_ProdType));
      SQL.Add(' AND ' + CreateFld(tbInfoBalance_Hed.pfx,fli_ProdCode)    + ' = ' + CreateFld(tbInfoMaterial.pfx,fli_ProdCode));
      SQL.Add(' AND ' + CreateFld(tbInfoBalance_Hed.pfx,fli_netGroupCode)+ ' = ' + CreateFld(tbInfoMaterial.pfx,fli_netGroupCode));
      SQL.Add(' AND ' + CreateFld(tbInfoBalance_Hed.pfx,fli_IDENTIFIER)  + ' = ' + CreateFld(tbInfoMaterial.pfx,fli_IDENTIFIER));
      SQL.Add(' WHERE ' + CreateFld(tbInfoMaterial.pfx,fli_MatBalance) + '=' + QuotedStr('0'));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfoMaterial.pfx, fli_Identifier)));
      SQL.Add(' AND ' + CreateFld(tbInfoBalance_Hed.pfx,fli_ProdType) + ' IS NULL');

      if MatRelStrList.Count < 500 then
        if MaterialPerWorkCenterList <> '' then
          SQL.Add(' and ' + CreateFld(tbInfoMaterial.pfx, fli_netGroupCode) + ' in (' + MaterialPerWorkCenterList + ')');

      SQL.Add(' order by ' + CreateFld(tbInfoMaterial.pfx,fli_ProdType) + ',');
      SQL.Add(CreateFld(tbInfoMaterial.pfx, fli_ProdCode));

      FetchOptions.RowsetSize := 5000;
      Open;

      if Assigned(Status) then Status.Caption := _('Loading materials for completing balances in memory...');

      var M3_ProdCode     := qry.FieldByName(CreateFld(tbInfoMaterial.pfx,fli_ProdCode));
      var M3_ProdType     := qry.FieldByName(CreateFld(tbInfoMaterial.pfx,fli_ProdType));
      var M3_NetGroupCode := qry.FieldByName(CreateFld(tbInfoMaterial.pfx,fli_NetGroupCode));
      sOldArtType := 'EMPTY';
      sOldArticleCode := 'EMPTY';
      Article := nil;

      while not Eof do
      begin
        CurrentArticleCode := M3_ProdCode.AsString;
        CurrentArtType := M3_ProdType.AsString;
        Article := FindArticle(CurrentArtType, CurrentArticleCode);
        if Article <> nil then
        begin
          if Article.m_Nature <> Ar_NotBalance then
          begin
            recBalance.BalanceType := bt_Entry;
            recBalance.DueDate     := trunc(now);
            recBalance.JobID       := CSchedIDnull;
            recBalance.BobinCode   := '';
            recBalance.Description := '';
            recBalance.Quantity    := 0;
            recBalance.RecType     := brt_NoDet;
            recBalance.ToRequest   := '';
            recBalance.TotalBal    := 0;
            recBalance.TotExpBal   := 0;
            recBalance.TotExpUsed  := 0;
            recBalance.RealQty     := 0;
            //Add net group and balance

            if MatRelStrList.Count >= 500 then
            begin
              if MatRelStrList.IndexOf(M3_NetGroupCode.AsString) > -1 then
                Article.m_NetGroupList.AddNetGroup(M3_NetGroupCode.AsString, recBalance, nil);
            end
            else
              Article.m_NetGroupList.AddNetGroup(M3_NetGroupCode.AsString, recBalance, nil);
          end;
        end;

        Next;

      end;
      qry.Close;
    end;

  end;

  // Read all item stock

  ItemsStockList := TList.Create;
  ItemsStockChangeAndExceptionList := TList.Create;
  CurrentDate := Date;
  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ');
    SQL.Add(CreateFld(tbInfoItemsStock.pfx,fli_ItemType) + ',');
    SQL.Add(CreateFld(tbInfoItemsStock.pfx,fli_netGroupCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStock.pfx,fli_ItemCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStock.pfx,fli_Stock));
    SQL.Add(' from ' +  tbInfoItemsStock.PCname);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoItemsStock.pfx, fli_Identifier)));
    SQL.Add(' order by ' + CreateFld(tbInfoItemsStock.pfx,fli_ItemType) + ',');
    SQL.Add(CreateFld(tbInfoItemsStock.pfx,fli_netGroupCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStock.pfx,fli_ItemCode));
    FetchOptions.RowsetSize := 5000;
    Open;
    var IS_ItemType := qry.FieldByName(CreateFld(tbInfoItemsStock.pfx,fli_ItemType));
    var IS_ItemCode := qry.FieldByName(CreateFld(tbInfoItemsStock.pfx,fli_ItemCode));
    var IS_NetGroup := qry.FieldByName(CreateFld(tbInfoItemsStock.pfx,fli_netGroupCode));
    var IS_Stock    := qry.FieldByName(CreateFld(tbInfoItemsStock.pfx,fli_Stock));
    PrgRowCount := 0;
    while not Eof do
    begin
      Article := FindArticle(trim(IS_ItemType.AsString), trim(IS_ItemCode.AsString));
      if assigned(Article) and (Article.m_Nature <> Ar_NotBalance) then
      begin
        new(PItemsStock);
        PItemsStock.ItemType := trim(IS_ItemType.AsString);
        PItemsStock.netGroup := trim(IS_NetGroup.AsString);
        PItemsStock.ItemCode := trim(IS_ItemCode.AsString);
        PItemsStock.Stock    := IS_Stock.AsFloat;
        PItemsStock.Article  := Article;
        ItemsStockList.add(PItemsStock);
      end;
      Next;
    end;
    qry.Close;
  end;

  // Pre-load ALL stock exceptions and changes in 2 bulk queries
  // instead of N*2 per-item round-trips to DB2 inside the loop
  AllExcMap := TStringList.Create;
  AllExcMap.Sorted := True;
  AllChgMap := TStringList.Create;
  AllChgMap.Sorted := True;
  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_ItemType) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_netGroupCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_ItemCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_Date) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_fromTime) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_ToTime) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_StockDifference));
    SQL.Add(' from ' + tbInfoItemsStockExceptions.PCname);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoItemsStockExceptions.pfx, fli_Identifier)));
    SQL.Add(' order by ' + CreateFld(tbInfoItemsStockExceptions.pfx,fli_ItemType) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_netGroupCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_ItemCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_Date) + ' desc,');
    SQL.Add(CreateFld(tbInfoItemsStockExceptions.pfx,fli_fromTime));
    FetchOptions.RowsetSize := 5000;
    Open;
    var EX_ItemType  := FieldByName(CreateFld(tbInfoItemsStockExceptions.pfx,fli_ItemType));
    var EX_NetGroup  := FieldByName(CreateFld(tbInfoItemsStockExceptions.pfx,fli_netGroupCode));
    var EX_ItemCode  := FieldByName(CreateFld(tbInfoItemsStockExceptions.pfx,fli_ItemCode));
    var EX_Date      := FieldByName(CreateFld(tbInfoItemsStockExceptions.pfx,fli_Date));
    var EX_FromTime  := FieldByName(CreateFld(tbInfoItemsStockExceptions.pfx,fli_fromTime));
    var EX_ToTime    := FieldByName(CreateFld(tbInfoItemsStockExceptions.pfx,fli_ToTime));
    var EX_StockDiff := FieldByName(CreateFld(tbInfoItemsStockExceptions.pfx,fli_StockDifference));
    PrgRowCount := 0;
    while not Eof do
    begin
      itemKey := trim(EX_ItemType.AsString) + '|' +
                 trim(EX_NetGroup.AsString) + '|' +
                 trim(EX_ItemCode.AsString);
      mapIdx := AllExcMap.IndexOf(itemKey);
      if mapIdx = -1 then
      begin
        AllExcSubList := TList.Create;
        AllExcMap.AddObject(itemKey, AllExcSubList);
      end else
        AllExcSubList := TList(AllExcMap.Objects[mapIdx]);
      new(PItemsStockChangeAndException);
      PItemsStockChangeAndException.ByDate         := true;
      PItemsStockChangeAndException.Date           := EX_Date.AsDateTime;
      PItemsStockChangeAndException.DayInWeek      := 0;
      PItemsStockChangeAndException.fromTime       := EX_FromTime.AsInteger;
      PItemsStockChangeAndException.ToTime         := EX_ToTime.AsInteger;
      PItemsStockChangeAndException.StockDifference:= EX_StockDiff.AsFloat;
      AllExcSubList.Add(PItemsStockChangeAndException);
      Next;
    end;
    Close;
    SQL.Clear;
    SQL.Add('select ');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_ItemType) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_netGroupCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_ItemCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_DayInWeek) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_fromTime) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_ToTime) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_StockDifference));
    SQL.Add(' from ' + tbInfoItemsStockChanges.PCname);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoItemsStockChanges.pfx, fli_Identifier)));
    SQL.Add(' order by ' + CreateFld(tbInfoItemsStockChanges.pfx,fli_ItemType) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_netGroupCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_ItemCode) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_DayInWeek) + ',');
    SQL.Add(CreateFld(tbInfoItemsStockChanges.pfx,fli_fromTime));
    FetchOptions.RowsetSize := 5000;
    Open;
    var CH_ItemType  := FieldByName(CreateFld(tbInfoItemsStockChanges.pfx,fli_ItemType));
    var CH_NetGroup  := FieldByName(CreateFld(tbInfoItemsStockChanges.pfx,fli_netGroupCode));
    var CH_ItemCode  := FieldByName(CreateFld(tbInfoItemsStockChanges.pfx,fli_ItemCode));
    var CH_DayInWeek := FieldByName(CreateFld(tbInfoItemsStockChanges.pfx,fli_DayInWeek));
    var CH_FromTime  := FieldByName(CreateFld(tbInfoItemsStockChanges.pfx,fli_fromTime));
    var CH_ToTime    := FieldByName(CreateFld(tbInfoItemsStockChanges.pfx,fli_ToTime));
    var CH_StockDiff := FieldByName(CreateFld(tbInfoItemsStockChanges.pfx,fli_StockDifference));
    PrgRowCount := 0;
    while not Eof do
    begin
      itemKey := trim(CH_ItemType.AsString) + '|' +
                 trim(CH_NetGroup.AsString) + '|' +
                 trim(CH_ItemCode.AsString);
      mapIdx := AllChgMap.IndexOf(itemKey);
      if mapIdx = -1 then
      begin
        AllChgSubList := TList.Create;
        AllChgMap.AddObject(itemKey, AllChgSubList);
      end else
        AllChgSubList := TList(AllChgMap.Objects[mapIdx]);
      new(PItemsStockChangeAndException);
      PItemsStockChangeAndException.ByDate         := false;
      PItemsStockChangeAndException.Date           := 0;
      PItemsStockChangeAndException.DayInWeek      := CH_DayInWeek.AsInteger;
      PItemsStockChangeAndException.fromTime       := CH_FromTime.AsInteger;
      PItemsStockChangeAndException.ToTime         := CH_ToTime.AsInteger;
      PItemsStockChangeAndException.StockDifference:= CH_StockDiff.AsFloat;
      AllChgSubList.Add(PItemsStockChangeAndException);
      Next;
    end;
    Close;
  end;

  for Index := 0 to ItemsStockList.Count - 1 do
  begin

    // Records are owned by AllExcMap/AllChgMap � just clear the reference list
    ItemsStockChangeAndExceptionList.Clear;

    recBalance.BalanceType := bt_Entry;
    recBalance.DueDate     := CurrentDate - 90;
    recBalance.JobID       := CSchedIDnull;
    recBalance.BobinCode   := '';
    recBalance.Description := '';
    recBalance.Quantity    := PTItemsStock(ItemsStockList[Index]).Stock;
    recBalance.RecType     := brt_NoDet;
    recBalance.ToRequest   := '';
    recBalance.TotalBal    := 0;
    recBalance.TotExpBal   := 0;
    recBalance.TotExpUsed  := 0;
    recBalance.RealQty     := 0;
    PTItemsStock(ItemsStockList[Index]).Article.m_NetGroupList.AddNetGroup(PTItemsStock(ItemsStockList[Index]).netGroup, recBalance, nil);

    // Look up pre-loaded exceptions for this item
    itemKey := PTItemsStock(ItemsStockList[Index]).ItemType + '|' +
               PTItemsStock(ItemsStockList[Index]).netGroup + '|' +
               PTItemsStock(ItemsStockList[Index]).ItemCode;
    mapIdx := AllExcMap.IndexOf(itemKey);
    if mapIdx >= 0 then
    begin
      AllExcSubList := TList(AllExcMap.Objects[mapIdx]);
      for Index1 := 0 to AllExcSubList.Count - 1 do
        ItemsStockChangeAndExceptionList.Add(AllExcSubList[Index1]);
    end;

    // Look up pre-loaded changes for this item (itemKey already set above)
    mapIdx := AllChgMap.IndexOf(itemKey);
    if mapIdx >= 0 then
    begin
      AllChgSubList := TList(AllChgMap.Objects[mapIdx]);
      for Index1 := 0 to AllChgSubList.Count - 1 do
        ItemsStockChangeAndExceptionList.Add(AllChgSubList[Index1]);
    end;

    for Index1 := -10 to 400 do
    begin
      DateOfBalance := CurrentDate + Index1;
      ExceptionByDateFound := false;
      for Index2 := 0 to ItemsStockChangeAndExceptionList.Count - 1 do
      begin
        if PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).ByDate then
        begin
          if PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).Date <> DateOfBalance then
          begin
            if ExceptionByDateFound then
              break;
            Continue;
          end;
          ExceptionByDateFound := true;
        end
        else
        begin
          if ExceptionByDateFound then
            break;
          if dayofweek(DateOfBalance) <> PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).DayInWeek then
            continue;
        end;
        DecodeTime(PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).fromTime/24/60, Hour, Min, Sec, MSec);
        FromTime := EncodeTime(Hour, Min, 0, 0);
        DecodeDate(DateOfBalance, Year, Month, Day);

        DateOfBalanceCalced := Trunc(DateOfBalance) + FromTime;

        recBalance.DueDate     := DateOfBalanceCalced; // + From time
        if PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).StockDifference < 0 then
        begin
          recBalance.BalanceType := bt_Issue;
          recBalance.Quantity    := PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).StockDifference * -1;
        end
        else
        begin
          recBalance.BalanceType := bt_Entry;
          recBalance.Quantity    := PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).StockDifference;
        end;
        PTItemsStock(ItemsStockList[Index]).Article.m_NetGroupList.AddNetGroup(PTItemsStock(ItemsStockList[Index]).netGroup, recBalance, nil);

        DecodeTime(PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).ToTime/24/60, Hour, Min, Sec, MSec);
        ToTime := EncodeTime(Hour, Min, 0, 0);
        DecodeDate(DateOfBalance, Year, Month, Day);
        DateOfBalanceCalced := Trunc(DateOfBalance) + ToTime;

        recBalance.DueDate     := DateOfBalanceCalced; // + To time
        if PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).StockDifference < 0 then
        begin
          recBalance.BalanceType := bt_Entry;
          recBalance.Quantity    := PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).StockDifference * -1;
        end
        else
        begin
          recBalance.BalanceType := bt_Issue;
          recBalance.Quantity    := PTItemsStockChangeAndException(ItemsStockChangeAndExceptionList[Index2]).StockDifference;
        end;
        PTItemsStock(ItemsStockList[Index]).Article.m_NetGroupList.AddNetGroup(PTItemsStock(ItemsStockList[Index]).netGroup, recBalance, nil);
      end;
    end;

  end;

  MatRelStrList.Free;

  for Index := 0 to ItemsStockList.Count - 1 do
    Dispose(PTItemsStock(ItemsStockList[Index]));
  ItemsStockList.Free;

  // Records are owned by AllExcMap/AllChgMap � just free the reference list
  ItemsStockChangeAndExceptionList.Free;

  // Free all pre-loaded exception records and their sublists
  for Index1 := 0 to AllExcMap.Count - 1 do
  begin
    AllExcSubList := TList(AllExcMap.Objects[Index1]);
    for Index2 := 0 to AllExcSubList.Count - 1 do
      Dispose(PTItemsStockChangeAndException(AllExcSubList[Index2]));
    AllExcSubList.Free;
  end;
  AllExcMap.Free;

  // Free all pre-loaded change records and their sublists
  for Index1 := 0 to AllChgMap.Count - 1 do
  begin
    AllChgSubList := TList(AllChgMap.Objects[Index1]);
    for Index2 := 0 to AllChgSubList.Count - 1 do
      Dispose(PTItemsStockChangeAndException(AllChgSubList[Index2]));
    AllChgSubList.Free;
  end;
  AllChgMap.Free;

  if Assigned(ProgBar) then ProgBar.SetPosition(0);
  if Assigned(Status) then  Status.Caption := '';
  Application.ProcessMessages;
end;

//----------------------------------------------------------------------------//

procedure TMQMArtTypeList.ClearBalanceLists;
var
  i : integer;
  ArtTp: TMQMArticleType;
begin
  for i := p_count -1 downto 0 do
  begin
    ArtTp := TMQMArticleType(p_Item[i]);
    ArtTp.ClearBalanceLists;
  end;
end;

//----------------------------------------------------------------------------//

destructor TMQMArtTypeList.Destroy;
var
  i : integer;
  ArtTp: TMQMArticleType;
begin
  for i := p_count -1 downto 0 do
  begin
    ArtTp := TMQMArticleType(p_Item[i]);
    RemoveItem(ArtTp);
    ArtTp.Free;
  end;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TMQMArtTypeList.FindArtType(sArtType: string): TMQMArticleType;
var
  i: integer;
  L, H: integer;
  Found: boolean;
begin
  Result := nil;

//  Binary search we have to sort the list before using it
  L := 0;
  H := p_count - 1;
  Found := false;

  while (L <= H) and not Found do
  begin
    i := (H-L) div 2;
    if i < L then i := L+i;
    if i > H then i := H-i;

    if (sArtType < TMQMArticleType(p_Item[i]).p_ArtTypeCode) then
      H := i - 1
    else
    begin
      if (sArtType > TMQMArticleType(p_Item[i]).p_ArtTypeCode) then
        L := i + 1
      else
      begin
        Result := TMQMArticleType(p_Item[i]);
        Found := true
      end;
    end;
  end;

  if Found then
    Assert(result.p_ArtTypeCode = sArtType);
end;

//----------------------------------------------------------------------------//

function TMQMArtTypeList.FindArticle(sArtType, sArtProd: string): TMQMArticle;
var
  I: integer;
  Found: boolean;
  ArtType : TMQMArticleType;
  Multiplier, NumberOfEntries : integer;
begin
  Result := nil;

  Found := false;

  ArtType := FindArtType(sArtType);

{  if assigned (ArtType) then
  begin
    for I := 0 to ArtType.m_ArticleList.Count - 1 do
    begin
      if sArtProd = TMQMArticle(ArtType.m_ArticleList[I]).m_ArticleCode then
      begin
        Result := TMQMArticle(ArtType.m_ArticleList[I]);
        Found := true
      end;
    end;
  end; }

  if assigned (ArtType) then
  begin
    NumberOfEntries := ArtType.m_ArticleList.Count;
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
        if (TMQMArticle(ArtType.m_ArticleList[I]).m_ArticleCode < sArtProd) then
        begin
          i := i + Multiplier;
          Continue;
        end;
        if (TMQMArticle(ArtType.m_ArticleList[I]).m_ArticleCode > sArtProd) then
        begin
          i := i - Multiplier;
          Continue;
        end;
        Result := TMQMArticle(ArtType.m_ArticleList[I]);
        Found := true;
        break;
      end;
    end;
  end;

  if Found then
    Assert(Result.m_ArticleCode = sArtProd);

end;

//----------------------------------------------------------------------------//

function TMQMArtTypeList.AddArtType(sArtType: string): TMQMArticleType;
begin
  result := FindArtType(sArtType);

  if not Assigned(result) then
  begin
    result := TMQMArticleType.Create(sArtType);
    AddItem(result)
  end;
end;

{
******************************* TMQMArticle **********************************
}

constructor TMQMArticle.Create(ArtType:TMQMArticleType; recArticle: TRecArticle);
begin
  Inherited create;
  m_Type        := ArtType;
  m_ArticleCode := recArticle.ArticleCode;
  m_NumberOfDecimal := UMObjCont.p_ArtType.GetNumberOfDecimal(ArtType.m_ArtTypeCode);
  m_Nature      := recArticle.Nature;
  m_AddResStart := recArticle.AddResStart;
  m_AddResEnd   := recArticle.AddResEnd;
  m_Description := recArticle.Description;
  m_NetGroupList:= TMQMNetGroupList.Create;
  m_NetGroupList.m_ArtNature := m_Nature;
  m_IgnoreCheck := recArticle.IgnoreMatCheck;
  m_StdPurcOrProdTime := recArticle.StdPurcOrProdTime;
  m_HoursToDownFromMachine := recArticle.HoursToDownFromMachine;
  m_RecTollerancePercent.TolleranceQty1 := 0;
  m_RecTollerancePercent.TolleranceQty2 := 0;
  m_RecTollerancePercent.TolleranceQty3 := 0;
  m_RecTollerancePercent.TolleranceQty4 := 0;
  m_RecTollerancePercent.TolleranceQty5 := 0;
  if recArticle.MaterialTolleranceCode <> '' then
    m_RecTollerancePercent := GetMaterialTolleranceForCode(recArticle.MaterialTolleranceCode);
  m_MaterialSchedule             :=  recArticle.MaterialSchedule;
  m_MaterialStandardSetupMinutes :=  recArticle.MaterialStandardSetupMinutes;
  m_MaterialStandardSpeed        :=  recArticle.MaterialStandardSpeed;
end;

//----------------------------------------------------------------------------//

destructor TMQMArticle.Destroy;
begin
  m_NetGroupList.Free;
  m_NetGroupList := nil;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function  TMQMArticle.FindNetGroup(sNetGroupCode: string; var Index : Integer): TMQMNetGroup;
var
  i: integer;
  L, H: integer;
  Found: boolean;
begin
  Result := nil;

  Found := false;

//  Binary search we have to sort the list before using it
  L := 0;
  H := m_NetGroupList.p_count - 1;

  while (L <= H) and not Found do
  begin
    i := (H-L) div 2;
    if i < L then i := L+i;
    if i > H then i := H-i;

    if (sNetGroupCode < TMQMNetGroup(m_NetGroupList.p_Item[i]).p_Code) then
      H := i - 1
    else
    begin
      if (sNetGroupCode > TMQMNetGroup(m_NetGroupList.p_Item[i]).p_Code) then
        L := i + 1
      else
      begin
        Result := TMQMNetGroup(m_NetGroupList.p_Item[i]);
        Found := true;
        Index := i;
        Assert(Result.p_Code = sNetGroupCode);
      end;
    end;
  end;

  Index := m_NetGroupList.p_count;
  if not found then
  begin
    for H := 0 to m_NetGroupList.p_count - 1 do
    begin
      if (sNetGroupCode < TMQMNetGroup(m_NetGroupList.p_Item[H]).p_Code) then
      begin
        Index := H;
        break
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TMQMArticle.AddNetGroup(sNetGroupCode: string): TMQMNetGroup;
var
  Index : integer;
begin
  result := FindNetGroup(sNetGroupCode, Index);

  if not Assigned(result) then
  begin
    result := TMQMNetGroup.Create(sNetGroupCode);
    m_NetGroupList.Insert(Index, Result);
//    m_NetGroupList.AddItem(result)
  end;
end;

//----------------------------------------------------------------------------//

procedure TMQMArticle.ClearBalanceLists;
var
  i: integer;
  NetGroup: TMQMNetGroup;
begin
  for i := 0 to m_NetGroupList.p_count -1 do
  begin
    NetGroup := m_NetGroupList.p_item[i];
    NetGroup.ClearBalanceLists
  end;
end;

//----------------------------------------------------------------------------//
function TMQMArticle.GetTolleranceQuantity(RequiredQuantity: double): double;
begin
  Result := 0;
  if m_RecTollerancePercent.TolleranceQty1 > RequiredQuantity then
  begin
    Result := m_RecTollerancePercent.TollerancePercent1 * RequiredQuantity / 100;
    exit;
  end;
  if m_RecTollerancePercent.TolleranceQty2 > RequiredQuantity then
  begin
    Result := m_RecTollerancePercent.TollerancePercent2 * RequiredQuantity / 100;
    exit;
  end;
  if m_RecTollerancePercent.TolleranceQty3 > RequiredQuantity then
  begin
    Result := m_RecTollerancePercent.TollerancePercent3 * RequiredQuantity / 100;
    exit;
  end;
  if m_RecTollerancePercent.TolleranceQty4 > RequiredQuantity then
  begin
    Result := m_RecTollerancePercent.TollerancePercent4 * RequiredQuantity / 100;
    exit;
  end;
  if m_RecTollerancePercent.TolleranceQty5 > RequiredQuantity then
  begin
    Result := m_RecTollerancePercent.TollerancePercent5 * RequiredQuantity / 100;
    exit;
  end;
end;

{
******************************* TMQMArticleType*********************************
}

constructor TMQMArticleType.Create(sArtType: string);
begin
  Inherited Create;
  m_ArtTypeCode := sArtType;
  m_ArticleList := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TMQMArticleType.Destroy;
var
  i : integer;
  Art: TMQMArticle;
begin
  for i := m_ArticleList.count -1 downto 0 do
  begin
    Art := TMQMArticle(m_ArticleList.Items[i]);
    m_ArticleList.Remove(Art);
    Art.Free;
  end;

  m_ArticleList.Free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//
{
function  TMQMArticleType.FindArticle(sArtCode: string): TMQMArticle;
var
  ii : integer;
begin
  result := nil;
  for ii := 0 to m_ArticleList.Count -1 do
  begin
    if sArtCode = TMQMArticle(m_ArticleList[ii]).m_ArticleCode then
    begin
      result :=  TMQMArticle(m_ArticleList[ii]);
      Break;
    end;
  end;
end;         }

//----------------------------------------------------------------------------//

procedure TMQMArticleType.ClearBalanceLists;
var
  i : integer;
  Art: TMQMArticle;
begin
  for i := m_ArticleList.count -1 downto 0 do
  begin
    Art := TMQMArticle(m_ArticleList.Items[i]);
    Art.ClearBalanceLists;
  end;
end;

//----------------------------------------------------------------------------//

function  TMQMArticleType.SearchAndAddArticle(recArticle: TRecArticle): TMQMArticle;
var
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin

  NumberOfEntries := m_ArticleList.Count;
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
      if (TMQMArticle(m_ArticleList[I]).m_ArticleCode < recArticle.ArticleCode) then
      begin
        i := i + Multiplier;
        Continue;
      end;
      if (TMQMArticle(m_ArticleList[I]).m_ArticleCode > recArticle.ArticleCode) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;
      result :=  TMQMArticle(m_ArticleList[I]);
      Exit;
    end;
  end;

  result := TMQMArticle.Create(self, recArticle);
  m_ArticleList.insert(LowestHighestValue, result);

{  result  := FindArticle(recArticle.ArticleCode);
  if not Assigned(result) then
    result := AddArticle(recArticle); }
end;

//----------------------------------------------------------------------------//

function  TMQMArticleType.AddArticle(recArticle: TRecArticle): TMQMArticle;
begin
  result := TMQMArticle.Create(self, recArticle);
  m_ArticleList.Add(result);
end;

//----------------------------------------------------------------------------//

procedure CleanListMaterialTollerance;
var
  I : Integer;
begin
  for I := m_MaterialTolleranceList.Count - 1 downto 0 do
    Dispose(PTTollerancePercent(m_MaterialTolleranceList[I]));
  m_MaterialTolleranceList.Free;
end;

//----------------------------------------------------------------------------//

initialization
  m_MaterialTolleranceList := TList.Create;
finalization
  CleanListMaterialTollerance;

end.
