unit FMStockDetails;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  ExtCtrls, Grids, StdCtrls, Buttons, DMsrvPc, UMCommon, UMGlobal,
  UMSchedContFunc, UMIssuedArt, UMArticles, UMBalance, Menus, UReShape;

type
  TStockDetails = class(TForm)
    Panel2: TPanel;
    LblReq: TLabel;
    LblStep: TLabel;
    LblSubStep: TLabel;
    LblRePrc: TLabel;
    STProd: TStaticText;
    Ststep: TStaticText;
    StSubStep: TStaticText;
    StReProcess: TStaticText;
    Panel3: TPanel;
    SGRequirements: TStringGrid;
    Splitter1: TSplitter;
    Bevel2: TBevel;
    PopupMenu1: TPopupMenu;
    MDeleteConnection: TMenuItem;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    constructor CreateStockForm(AOwner: TComponent; Id: TSchedID; LstArticles: TMQMIssuedArtList);
    procedure SGRequirementsDblClick(Sender: TObject);
    procedure SGRequirementsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BtnOkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MDeleteConnectionClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure SGRequirementsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
  private
    m_id : TSchedId;
    m_LstArticles : TMQMIssuedArtList;
    m_GridDataList: Tlist;
    m_SelectedRow: Integer;
  procedure IniData;
  function  SearchDetalis(ArtType : string; ArticleCode : string; netGroup : string; var Identifier : LongInt) : string;
  procedure ListArticles(LstArticles: TMQMIssuedArtList);
  procedure   AddArticleToForm(Article: TMQMArticle ;NetCode : TMQMNetGroup ; IssuedArt: PTIssuedArt);
  procedure  PrintMatReqGrid;
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure RefreshStockDetails(qry: TMqmQuery; ProgBar: TMqmProgBar);
  procedure LoadStockDetails(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
  procedure SaveStockDetails(qry: TMqmQuery);
  procedure HandleStockDetails(AOwner: TComponent; id: TSchedId);


//var
//  StockDetails: TStockDetails;

implementation

{$R *.dfm}

uses UMObjCont, gnugettext, UMTblDesc,UMSchedCont, UMSchedOnPlan,UMRes,UMActArea,
     FMStockDetailsChild,UMWkCtr;

{ TStockDetails }

//----------------------------------------------------------------------------//

type

  TStock = record
    Identifier :  LongInt;
    Used       :  boolean;
    Modified   :  boolean;
    Current    :  boolean;
    TYPE_PROD  : string;
    PRODUCT_CODE : string;
    NET_GROUP_CODE : string;
    DETAILS : string;
    PREQ_NO : string;
    PSTEP_ID : Integer;
    PSUBST_ID : Integer;
    REPROC_NO : Integer;
    JobId     : TSChedId;
  end;
  PTStock =  ^TStock;

var
  m_StockDetailsList : TList;
  m_StockChangedList : Tlist;
  StockDetails : TStockDetails;

//----------------------------------------------------------------------------//

function TStockDetails.SearchDetalis(ArtType : string; ArticleCode : string; netGroup : string; var Identifier : LongInt) : string;
var
  I : Integer;
  Stock : PTStock;
begin
  Result := '';
  for I := 0 to m_StockDetailsList.Count - 1 do
  begin
    Stock := PTStock(m_StockDetailsList[I]);
    if (Stock.TYPE_PROD = ArtType) and  (Stock.PRODUCT_CODE = ArticleCode) and (Stock.NET_GROUP_CODE = netGroup) then
    begin
      if (Stock.PREQ_NO = STProd.Caption) and (Stock.PSTEP_ID = StrToInt(Ststep.Caption))and
         (Stock.PSUBST_ID = StrToInt(StSubStep.Caption)) and (Stock.REPROC_NO = StrToInt(StReProcess.Caption)) then
      begin
        Result := Stock.DETAILS;
        Identifier := Stock.Identifier;
        exit;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TStockDetails.AddArticleToForm(Article: TMQMArticle;
  NetCode: TMQMNetGroup; IssuedArt: PTIssuedArt);
var
  NetGroup : TMQMNetGroup;
  i : Integer;
  HeaderRow:  PTHeaderRow;
  Identifier : LongInt;
  value: variant;
  dataType: CBinColValType;
  JobQty, quantInit  : double;
begin

  for i := 0 to Article.p_NetGroupList.p_count -1 do
  begin
    NetGroup := TMQMNetGroup(Article.p_NetGroupList.p_Item[i]);
    if (assigned(NetCode)) and (NetCode.m_Code <> NetGroup.m_Code) then
       Continue;
    new(HeaderRow);
    HeaderRow.modified    := false;
    HeaderRow.ArticleCode := Article.p_ArtCode;
    HeaderRow.netGroup    := NetGroup.p_Code;
    HeaderRow.Qty         := p_sc.GetMaterialRequiredQty(m_id, Article.p_ArtCode);

    if HeaderRow.Qty > 0 then
    begin
      p_sc.GetFldValue(m_Id, CSC_QtyToSched, value, dataType);
      JobQty := value;
      p_sc.GetFldValue(m_id, CSC_IniQty, value, dataType);
      quantInit := value;
      if quantInit > 0 then
      begin
        HeaderRow.Qty := (HeaderRow.Qty * JobQty)/ quantInit;
        HeaderRow.Qty := trunc(HeaderRow.Qty*100)/100;
      end;
    end;
    HeaderRow.description := Article.p_Description;
    HeaderRow.ArtType     := Article.p_ArtType.p_ArtTypeCode;
    HeaderRow.Details     := SearchDetalis(HeaderRow.ArtType, HeaderRow.ArticleCode, HeaderRow.netGroup, Identifier);
    HeaderRow.Jobid       := m_id;
    if HeaderRow.Details <> '' then
       HeaderRow.Identifier := Identifier
    else
      HeaderRow.Identifier  :=  -1;
    m_GridDataList.Add(HeaderRow);
  end;
  PrintMatReqGrid;
end;

//----------------------------------------------------------------------------//

procedure TStockDetails.BtnAboClick(Sender: TObject);
begin
  MOdalResult := mrAbort;
  Close;
end;

procedure TStockDetails.BtnOkClick(Sender: TObject);
var
  HeaderRow : PTStock;
  I, J : Integer;
  Used : boolean;
  Idfier : LongInt;
begin
  for I := 0 to m_GridDataList.Count - 1 do
  begin
    if PTHeaderRow(m_GridDataList[I]).modified then
    begin
      new(HeaderRow);
      HeaderRow.Identifier         := PTHeaderRow(m_GridDataList[I]).Identifier;
      HeaderRow.PRODUCT_CODE       := PTHeaderRow(m_GridDataList[I]).ArticleCode;
      HeaderRow.NET_GROUP_CODE     := PTHeaderRow(m_GridDataList[I]).netGroup;
      HeaderRow.TYPE_PROD          := PTHeaderRow(m_GridDataList[I]).ArtType;
      HeaderRow.DETAILS            := PTHeaderRow(m_GridDataList[I]).Details;
      HeaderRow.JobId              := PTHeaderRow(m_GridDataList[I]).Jobid;
      if HeaderRow.DETAILS = '' then
      begin
        HeaderRow.Used := false;
        HeaderRow.PREQ_NO := '';
        HeaderRow.PSTEP_ID  := 0;
        HeaderRow.PSUBST_ID := 0;
        HeaderRow.REPROC_NO := 0;
      end
      else
      begin
        HeaderRow.PREQ_NO            := STProd.Caption;
        HeaderRow.PSTEP_ID           := StrToInt(Ststep.Caption);
        HeaderRow.PSUBST_ID          := StrToInt(StSubStep.Caption);
        HeaderRow.REPROC_NO          := StrToInt(StReProcess.Caption);
        HeaderRow.Used               := true;
      end;

      Used := HeaderRow.Used;
      Idfier := HeaderRow.Identifier;

      m_StockChangedList.add(HeaderRow);

      for J := 0 to m_StockDetailsList.Count - 1 do
      begin
        if (PTStock(m_StockDetailsList[J]).TYPE_PROD = HeaderRow.TYPE_PROD) and
           (PTStock(m_StockDetailsList[J]).PRODUCT_CODE = HeaderRow.PRODUCT_CODE) and
           (PTStock(m_StockDetailsList[J]).NET_GROUP_CODE = HeaderRow.NET_GROUP_CODE) then
        begin
          if (PTStock(m_StockDetailsList[J]).Identifier <> Idfier) and
             Used then
          begin
            if (PTStock(m_StockDetailsList[J]).PREQ_NO = STProd.Caption) and
               (PTStock(m_StockDetailsList[J]).PSTEP_ID = StrToInt(Ststep.Caption)) and
               (PTStock(m_StockDetailsList[J]).PSUBST_ID = StrToInt(StSubStep.Caption)) and
               (PTStock(m_StockDetailsList[J]).REPROC_NO = StrToInt(StReProcess.Caption)) then
            begin
              new(HeaderRow);
              HeaderRow.Identifier         := PTStock(m_StockDetailsList[J]).Identifier;
              HeaderRow.PRODUCT_CODE       := PTStock(m_StockDetailsList[J]).PRODUCT_CODE;
              HeaderRow.NET_GROUP_CODE     := PTStock(m_StockDetailsList[J]).NET_GROUP_CODE;
              HeaderRow.TYPE_PROD          := PTStock(m_StockDetailsList[J]).TYPE_PROD;
              HeaderRow.Used := false;
              HeaderRow.PREQ_NO            := '';
              HeaderRow.PSTEP_ID           := 0;
              HeaderRow.PSUBST_ID          := 0;
              HeaderRow.REPROC_NO          := 0;
              PTStock(m_StockDetailsList[J]).PREQ_NO  := '';
              PTStock(m_StockDetailsList[J]).PSTEP_ID := 0;
              PTStock(m_StockDetailsList[J]).PSUBST_ID := 0;
              PTStock(m_StockDetailsList[J]).REPROC_NO := 0;
              m_StockChangedList.add(HeaderRow);
            end;
          end
          else if (PTStock(m_StockDetailsList[J]).Identifier = Idfier) and
             not Used then
          begin
            PTStock(m_StockDetailsList[J]).PREQ_NO  := '';
            PTStock(m_StockDetailsList[J]).PSTEP_ID := 0;
            PTStock(m_StockDetailsList[J]).PSUBST_ID := 0;
            PTStock(m_StockDetailsList[J]).REPROC_NO := 0;
          end;

        end;
      end;

    end;
  end;

  ModalResult := mrOk;
//  Close;
end;

//----------------------------------------------------------------------------//

constructor TStockDetails.CreateStockForm(AOwner: TComponent; Id: TSchedID; LstArticles: TMQMIssuedArtList);
begin
  inherited create(Aowner);
  m_LstArticles := LstArticles;
  m_id := Id;
  m_GridDataList := Tlist.Create;
  IniData;
  ListArticles(LstArticles);

  ReSHape(self);
//  ReShape(BtnOk);
//  ReShape(BtnAbo);
end;

//----------------------------------------------------------------------------//

procedure TStockDetails.FormCreate(Sender: TObject);
var
  CanSelect : boolean;
begin
  if m_GridDataList.Count > 0 then
     SGRequirementsSelectCell(self,0,1,CanSelect);
end;

//----------------------------------------------------------------------------//

procedure TStockDetails.FormDestroy(Sender: TObject);
var
  I : Integer;
begin
  for I := m_GridDataList.Count - 1 downto 0 do
     dispose(PTHeaderRow(m_GridDataList[I]));
  m_GridDataList.Free;
end;

//----------------------------------------------------------------------------//

procedure TStockDetails.IniData;
begin
  STProd.Caption      := p_sc.GetFldDescr(m_id,CSC_ProdReq, false);
  Ststep.Caption      := p_sc.GetFldDescr(m_id,CSC_ProdStep, false);
  StSubStep.Caption   := p_sc.GetFldDescr(m_id,CSC_ProdSubStep, false);
  StReProcess.Caption := p_sc.GetFldDescr(m_id,CSC_ReprocNo, false);

  with SGRequirements do
  begin
    RowCount := 1;
    Cells[0, 0] := _('Material type');
    Cells[1, 0] := _('Material code');
    Cells[2, 0] := _('Description');
    Cells[3, 0] := _('Net group');
    Cells[4, 0] := _('Quantity');
    Cells[5, 0] := _('Connected to');
  end;
end;

//----------------------------------------------------------------------------//

procedure TStockDetails.ListArticles(LstArticles: TMQMIssuedArtList);
var
  i,j: Integer;
  ArtType : TMQMArticleType;
  Article : TMQMArticle;
  IssuedArt: PTIssuedArt;
begin
 if Assigned(LstArticles) then
  begin
    for i := 0 to LstArticles.p_Count -1 do
    begin
      IssuedArt := LstArticles.p_Item[i];
      Article := IssuedArt.Article;
      AddArticleToForm( Article, IssuedArt.NetGroup, IssuedArt);
    end;
  end

  else
  begin
    for i := 0 to p_ArtTypeList.p_count -1 do
    begin
      ArtType := TMQMArticleType(p_ArtTypeList.p_Item[i]);
      if ArtType.p_ArtTypeCode = '' then
      begin
        for j:= 1 to ArtType.p_ArticleList.Count -1 do
        begin
          Article := TMQMArticle(ArtType.p_ArticleList.Items[i]);
          AddArticleToForm( Article, nil, nil);
        end;
      end;
    end;
   end;
end;

//----------------------------------------------------------------------------//

procedure TStockDetails.MDeleteConnectionClick(Sender: TObject);
begin
  if m_SelectedRow = 0 then
     Exit;
  PTHeaderRow(m_GridDataList[m_SelectedRow -1]).Details := '';
  PTHeaderRow(m_GridDataList[m_SelectedRow -1]).modified := true;
  PrintMatReqGrid;
end;

//----------------------------------------------------------------------------//

procedure TStockDetails.PopupMenu1Popup(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TStockDetails.PrintMatReqGrid;
var
  i: integer;
  HeaderRow:  PTHeaderRow;
begin

  with SGRequirements do
  begin
    RowCount := m_GridDataList.Count + 1;
    Cells[0, 0] := _('Material type');
    Cells[1, 0] := _('Material code');
    Cells[2, 0] := _('Description');
    Cells[3, 0] := _('Net group');
    Cells[4, 0] := _('Quantity');
    Cells[5, 0] := _('Connected to');

    for i:= 0 to m_GridDataList.Count -1 do
    begin
      HeaderRow := m_GridDataList.Items[i];
      Cells[0, i+1] := HeaderRow.ArtType;
      Cells[1, i+1] := HeaderRow.ArticleCode;
      Cells[2, i+1] := HeaderRow.description;
      Cells[3, i+1] := HeaderRow.netGroup;
      Cells[4, i+1] := FloatToStr(HeaderRow.Qty);
      Cells[5, i+1] := HeaderRow.Details
    end;

  end;
end;

//----------------------------------------------------------------------------//

procedure TStockDetails.SGRequirementsDblClick(Sender: TObject);
var
  I : Integer;
  TempHeaderRow : PTHeaderRow;
  ArticleCode:  string;
  netGroup:     String;
  ArtType   :   string;
  TmpList   :   TList;
  StockDetailsChild : TStockDetailsChild;
begin
  if m_SelectedRow = 0 then
     Exit;

  TmpList := TList.Create;
  ArtType := PTHeaderRow(m_GridDataList.Items[m_SelectedRow -1]).ArtType;
  ArticleCode := PTHeaderRow(m_GridDataList.Items[m_SelectedRow -1]).ArticleCode;
  netGroup := PTHeaderRow(m_GridDataList.Items[m_SelectedRow -1]).netGroup;

  for I := 0 to m_StockDetailsList.Count - 1 do
  begin
    if (PTStock(m_StockDetailsList[I]).TYPE_PROD = ArtType) and
       (PTStock(m_StockDetailsList[I]).PRODUCT_CODE = ArticleCode) and
       (PTStock(m_StockDetailsList[I]).NET_GROUP_CODE = netGroup) then
      // Trim(PTStock(m_StockDetailsList[I]).PREQ_NO = '') and (PTStock(m_StockDetailsList[I]).PREQ_NO <> STProd.Caption)) then
    begin
      if (Trim(PTStock(m_StockDetailsList[I]).PREQ_NO) = '') or (PTStock(m_StockDetailsList[I]).PREQ_NO = STProd.Caption) then
      begin
        new(TempHeaderRow);
        TempHeaderRow.ArticleCode := PTStock(m_StockDetailsList[I]).NET_GROUP_CODE;
        TempHeaderRow.netGroup    := PTStock(m_StockDetailsList[I]).PRODUCT_CODE;
        TempHeaderRow.ArtType     := PTStock(m_StockDetailsList[I]).TYPE_PROD;
        TempHeaderRow.Details     := PTStock(m_StockDetailsList[I]).DETAILS;
        TempHeaderRow.MainIndex   := I;
        TmpList.Add(TempHeaderRow);
      end;
    end;
  end;

  StockDetailsChild := TStockDetailsChild.CreateStockChild(self,TmpList,m_id,ArtType,ArticleCode,netGroup);
  if StockDetailsChild.ShowModal = mrOk then
  begin
    I := StockDetailsChild.GetSelectedRow;
    if I = 0 then exit;
    PTHeaderRow(m_GridDataList.Items[m_SelectedRow -1]).Details := PTHeaderRow(TmpList[I - 1]).Details;
    PTHeaderRow(m_GridDataList.Items[m_SelectedRow -1]).modified := true;

    for I := 0 to m_StockDetailsList.Count - 1 do
    begin
      if (PTStock(m_StockDetailsList[I]).TYPE_PROD = ArtType) and
         (PTStock(m_StockDetailsList[I]).PRODUCT_CODE = ArticleCode) and
         (PTStock(m_StockDetailsList[I]).NET_GROUP_CODE = netGroup) and
         (PTHeaderRow(m_GridDataList.Items[m_SelectedRow -1]).Details = PTStock(m_StockDetailsList[I]).DETAILS) then
      begin
        PTHeaderRow(m_GridDataList.Items[m_SelectedRow -1]).Identifier := PTStock(m_StockDetailsList[I]).Identifier;
        break
      end;
    end;

    PTStock(m_StockDetailsList[I]).PREQ_NO := STProd.Caption;
    PTStock(m_StockDetailsList[I]).PSTEP_ID := StrToInt(Ststep.Caption);
    PTStock(m_StockDetailsList[I]).PSUBST_ID := StrToInt(StSubStep.Caption);
    PTStock(m_StockDetailsList[I]).PSUBST_ID := StrToInt(StReProcess.Caption);

    PrintMatReqGrid;
  end;

  StockDetailsChild.free;

  for I := TmpList.Count - 1 downto 0 do
     dispose(PTHeaderRow(TmpList[I]));
  TmpList.Free;

end;

procedure TStockDetails.SGRequirementsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

//----------------------------------------------------------------------------//

procedure TStockDetails.SGRequirementsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
   m_SelectedRow := ARow;
end;

//----------------------------------------------------------------------------//

Procedure CreateStockList;
begin
  m_StockDetailsList := TList.Create;
  m_StockChangedList := TList.Create;
end;

//----------------------------------------------------------------------------//

Procedure FreeStockList;
var
  I : Integer;
begin
  for I := m_StockDetailsList.Count - 1 downto 0 do
     dispose(PTStock(m_StockDetailsList[I]));
  m_StockDetailsList.Free;

  for I := m_StockChangedList.Count - 1 downto 0 do
     dispose(PTStock(m_StockChangedList[I]));
  m_StockChangedList.Free;
end;

//----------------------------------------------------------------------------//

procedure UpdateChangedList(Delete : boolean; Stock : PTStock);
var
  I : Integer;
begin
  for I := m_StockChangedList.Count - 1 downto 0 do
  begin
    if  PTStock(m_StockChangedList[I]).Identifier = Stock.Identifier then
    begin
      if Delete then
        m_StockChangedList.Delete(I)
      else
      begin
        PTStock(m_StockChangedList[I]).TYPE_PROD := Stock.TYPE_PROD;
        PTStock(m_StockChangedList[I]).PRODUCT_CODE := Stock.PRODUCT_CODE;
        PTStock(m_StockChangedList[I]).NET_GROUP_CODE := Stock.NET_GROUP_CODE;
        PTStock(m_StockChangedList[I]).DETAILS := Stock.DETAILS;
      end;
      break;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure RefreshStockDetails(qry: TMqmQuery; ProgBar: TMqmProgBar);
var
  tbInfo : ^TTblInfo;
  IndexStock : Integer;
  Stock : PTStock;
  I : Integer;
  Operation : String;
  HostID, LocalID : integer;
begin
  I := 0;
  LocalID := 0;
  HostID := 0;
  tbInfo := @tblInfo[tbl_StockDetails];
  if m_StockDetailsList.Count = 0 then  exit;

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select Count(*) CNT From ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    //Transaction.StartTransaction;
    Open;
    if not EOF then
    begin
      if Assigned(ProgBar) then
      begin
        ProgBar.SetPosition(0);
        ProgBar.SetMax((FieldByName('CNT')).AsInteger); // could be that in oracle will be float.
      end;
    end;
    close;
    SQL.Clear;
    SQL.Add('select *');
    SQL.Add(' from ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    SQL.Add(' order by ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_BalanceIdentifier) + '');
    //Transaction.StartTransaction;
    Open;
    IndexStock := 0;
    while true do
    begin
      if Assigned(ProgBar) then
        ProgBar.SetPosition(i + 1);

      if (IndexStock > m_StockDetailsList.count - 1) and qry.Eof then break;

      Operation := '0';

      if (IndexStock > m_StockDetailsList.count - 1) then
        Operation := '1' // Insert
      else
        LocalID := PTStock(m_StockDetailsList[IndexStock]).Identifier;

      if qry.Eof then
        Operation := '3' // Deleted
      else
        HostID := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BalanceIdentifier)).AsInteger;

      if Operation = '0' then
      begin
        if HostID < LocalID then Operation := '1'; // Insert
        if HostID = LocalID then Operation := '2'; // Update
        if HostID > LocalID then Operation := '3'; // Delete
      end;

      if Operation = '3' then
      begin
        UpdateChangedList(true, m_StockDetailsList[IndexStock]);
        m_StockDetailsList.Delete(IndexStock);
        dec(IndexStock);
      end;

      if Operation = '1' then
      begin
        Application.ProcessMessages;
        new(Stock);
        Stock.Identifier := FieldByName(CreateFld(tbInfo.pfx, fli_BalanceIdentifier)).AsInteger;
        Stock.Modified        := false;
        Stock.TYPE_PROD       := FieldByName(CreateFld(tbInfo.pfx, fli_prodtype)).AsString;
        Stock.PRODUCT_CODE    := FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString;
        Stock.NET_GROUP_CODE  := FieldByName(CreateFld(tbInfo.pfx, fli_netGroupCode)).AsString;
        Stock.Used := false;
        if FieldByName(CreateFld(tbInfo.pfx, fli_used)).AsString = '1' then
          Stock.Used := true;
        Stock.DETAILS         := FieldByName(CreateFld(tbInfo.pfx, fli_Details)).AsString;
        Stock.PREQ_NO         := FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString;
        Stock.PSTEP_ID        := FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger;
        Stock.PSUBST_ID       := FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger;
        Stock.REPROC_NO       := FieldByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger;
        m_StockDetailsList.Insert(IndexStock,Stock);
      end;

      if (Operation = '2') then
      begin
        UpdateChangedList(false, m_StockDetailsList[IndexStock]);
        PTStock(m_StockDetailsList[IndexStock]).DETAILS   := Trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_Details)).AsString);
        PTStock(m_StockDetailsList[IndexStock]).TYPE_PROD := Trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_prodtype)).AsString);
        PTStock(m_StockDetailsList[IndexStock]).PRODUCT_CODE := Trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString);
        PTStock(m_StockDetailsList[IndexStock]).NET_GROUP_CODE := Trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_netGroupCode)).AsString);
      end;

      IndexStock := IndexStock + 1;
      if Operation <> '3' then qry.Next;

      Application.ProcessMessages;

      Inc(I);

    end;

    if Assigned(ProgBar) then
      ProgBar.SetPosition(0);

  end;
end;

//----------------------------------------------------------------------------//

procedure LoadStockDetails(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
var
  Stock : PTStock;
  tbInfo : ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_StockDetails];

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);

  if Assigned(Status) then
    Status.Caption := _('Reading stock details from database...');
  Application.ProcessMessages;

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select *');
    SQL.Add(' from ' + tbInfo.GetTableName);
    qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    SQL.Add(' order by ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_BalanceIdentifier) + '');
    Open;

    while not EOF do
    begin
      Application.ProcessMessages;
      new(Stock);
      Stock.Identifier := FieldByName(CreateFld(tbInfo.pfx, fli_BalanceIdentifier)).AsInteger;
      Stock.Modified        := false;
      Stock.TYPE_PROD       := FieldByName(CreateFld(tbInfo.pfx, fli_prodtype)).AsString;
      Stock.PRODUCT_CODE    := FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString;
      Stock.NET_GROUP_CODE  := FieldByName(CreateFld(tbInfo.pfx, fli_netGroupCode)).AsString;
      Stock.Used := false;
      if FieldByName(CreateFld(tbInfo.pfx, fli_used)).AsString = '1' then
         Stock.Used := true;
      Stock.DETAILS         := FieldByName(CreateFld(tbInfo.pfx, fli_Details)).AsString;
      Stock.PREQ_NO         := FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString;
      Stock.PSTEP_ID        := FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger;
      Stock.PSUBST_ID       := FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger;
      Stock.REPROC_NO       := FieldByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger;
      m_StockDetailsList.Add(Stock);
      next;
    end;
    close;
  end;

end;

//----------------------------------------------------------------------------//

procedure SaveStockDetails(qry: TMqmQuery);
var
  I : Integer;
  SqlUpdate : string;
  tbInfo : ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_StockDetails];
  for I := 0 to m_StockChangedList.Count - 1 do
  begin
    if PTStock(m_StockChangedList[I]).Identifier < 0 then continue;
    with qry do
    begin
      SqlUpdate := 'update ' + tbInfo.GetTableName + ' set ';
      SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_used) + ' = ';
      SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_used)  + ',';
      SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_preqNo) + ' = ';
      SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_preqNo)  + ',';
      SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_pstepId) + ' = ';
      SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_pstepId)  + ',';
      SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_psubstId) + ' = ';
      SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_psubstId)  + ',';
      SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ';
      SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_reprocNo);
      SqlUpdate := SqlUpdate + ' where ';
      SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_Identifier)   + ' = ';
      SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_Identifier) + ' and ';
      SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_BalanceIdentifier)   + ' = ';
      SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_BalanceIdentifier);
      SQL.Text := SqlUpdate;
     // Prepare;

      ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
      ParamByName(CreateFld(tbInfo.pfx, fli_BalanceIdentifier)).AsInteger := PTStock(m_StockChangedList[I]).Identifier;
      if PTStock(m_StockChangedList[I]).Used then
        ParamByName(CreateFld(tbInfo.pfx, fli_used)).AsString := '1'
      else
        ParamByName(CreateFld(tbInfo.pfx, fli_used)).AsString := '0';
      ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString := PTStock(m_StockChangedList[I]).PREQ_NO;
      ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger := PTStock(m_StockChangedList[I]).PSTEP_ID;
      ParamByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger := PTStock(m_StockChangedList[I]).PSUBST_ID;
      ParamByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger := PTStock(m_StockChangedList[I]).REPROC_NO;
      p_sc.SetSchedObjStatus(PTStock(m_StockChangedList[I]).JobId, CSS_modi);
      ExecSQL;
    end;

  end;

  for I := m_StockChangedList.Count - 1 downto 0 do
     dispose(PTStock(m_StockChangedList[I]));
  m_StockChangedList.Clear;

end;

//----------------------------------------------------------------------------//

procedure HandleStockDetails(AOwner: TComponent; id: TSchedId);
var
  planInfo: TSQplanInfo;
  TimingInfo: TSQtimingInfo;
  MachSetupCodeList :TMQMMacSetupList;
  MacSetupRec: TMacSetup;
  IssArtList: TMQMIssuedArtList;
begin
  p_sc.GetPlanInfo(id, planInfo);
  p_sc.GetTimingInfo(id, TimingInfo);
  MacSetupRec.WrkCtrCode := TimingInfo.wkctCode;
  MacSetupRec.MachineSetupCode := TimingInfo.MachSetupCode;
  MachSetupCodeList := p_sc.GetStepIssMaterials(id);
  MacSetupRec.ResCat := '';
  MacSetupRec.ResCode := '';
  MacSetupRec.WrkCtrCode := '';
  IssArtList := TMQMIssuedArtList.Create(true);
  MachSetupCodeList.GetIssuedArtList(MacSetupRec, IssArtList);
  StockDetails := TStockDetails.CreateStockForm(AOwner,id,IssArtList);
  StockDetails.ShowModal;
  StockDetails.Free;
  IssArtList.Free;
end;

//----------------------------------------------------------------------------//

Initialization
  CreateStockList;

finalization
  FreeStockList;


end.
