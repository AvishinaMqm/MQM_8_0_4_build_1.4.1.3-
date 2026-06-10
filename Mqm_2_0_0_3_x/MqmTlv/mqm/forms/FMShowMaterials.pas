unit FMShowMaterials;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UMArticles, UMBalance, Grids, ComCtrls, ExtCtrls, UMIssuedArt,
  UMSchedContFunc, Menus, UReShape;

type
  TFShowMaterials = class(TForm)
    SaveDialog: TSaveDialog;
    PageControl1: TPageControl;
    tbsMaterials: TTabSheet;
    sgrdBalance: TStringGrid;
    tbsPositions: TTabSheet;
    Panel1: TPanel;
    popShowArrivalDate: TPopupMenu;
    MIShowPos: TMenuItem;
    sgrPos: TStringGrid;
    tbsAvailable: TTabSheet;
    sgrMov: TStringGrid;
    TbsSteps: TTabSheet;
    SGReqBalance: TStringGrid;
    Panel2: TPanel;
    btnSaveReqToFile: TcxButton;
    PnlTop: TPanel;
    cboxArtType: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cboxArticles: TComboBox;
    cboxNetGroups: TComboBox;
    Label3: TLabel;
    btnSaveToFile: TcxButton;
    constructor CreateFrmShowMat(AOwner: TComponent; id: TSchedId; LstPos, LstMov,
                                 LstPTArtBal: TList; LstArticles: TMQMIssuedArtList;
                                 LstReqBal: TMQMRequestBalList);
    destructor Destroy; override;

    procedure cboxArtTypeClick(Sender: TObject);
    procedure cboxArticlesClick(Sender: TObject);
    procedure cboxNetGroupsClick(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure MIShowPosClick(Sender: TObject);
    procedure popShowArrivalDatePopup(Sender: TObject);
    procedure btnSaveReqToFileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    m_StrLst: TStringList;
    m_ReqBalStrLst: TStringList;
    m_LstPos: TList;
    m_LstMov: TList;
    m_LstPtArtBal: TList;
    m_LstArticles: TMQMIssuedArtList;
    procedure RefreshArticleList(ArtType: TMQMArticleType);
    procedure RefreshNetGroupList(Article: TMQMArticle);
    procedure RefreshGridMat(Lst: TMQMArtBalanceList);
    procedure RefreshGridReqBal(Lst: TMQMRequestBalList);
    procedure RefreshGridPos(Lst: TList);
    procedure RefreshGridMov;
  end;

var
  FShowMaterials: TFShowMaterials;

implementation

{$R *.dfm}

uses   gnugettext, UMRes, UMActArea, UMSchedOnPlan,
       UMObjCont, UGCustomList, UMSchedCont;

//----------------------------------------------------------------------------//

constructor TFShowMaterials.CreateFrmShowMat(AOwner: TComponent; id: TSchedID;
                                             LstPos, LstMov, LstPTArtBal: TList;
                                             LstArticles: TMQMIssuedArtList;
                                             LstReqBal: TMQMRequestBalList);
var
  i : integer;
  ArtType : TMQMArticleType;
  Article : TMQMArticle;
  IssuedArt: PTIssuedArt;
  StepInfo: TSQStepInfo;
  TimingInfo: TSQtimingInfo;
begin
  inherited Create(AOwner);

  Height := 586;
  Width := 865;

  m_LstArticles := nil;
  m_StrLst := TStringList.Create;
  m_ReqBalStrLst := TStringList.Create;

  TranslateComponent (self);

  if Assigned(LstPos) then
    m_LstPos := LstPos
  else
    m_LstPos := nil;

  if Assigned(LstMov) then
    m_LstMov := LstMov
  else
    m_LstMov := nil;

  if Assigned(LstPTArtBal) then
    m_LstPtArtBal := LstPTArtBal
  else
    m_LstPtArtBal := nil;

  if Assigned(LstReqBal) then
  begin
    LstReqBal.SortBalanceList;
    p_sc.GetTimingInfo(id, TimingInfo);
    p_sc.GetPrecStepToSched(TimingInfo.prodReq, TimingInfo.step, StepInfo);


    LstReqBal.UpdateBalanceTotals(StepInfo.StepNo, CSchedIDnull);

    RefreshGridReqBal(LstReqBal);
    TbsSteps.TabVisible := true
  end else
  begin
    TbsSteps.TabVisible := false
  end;

  if Assigned(LstArticles) then
  begin
    m_LstArticles := LstArticles;
    cboxArtType.Enabled := false;
    cboxNetGroups.Enabled := false;

    for i := 0 to m_LstArticles.p_Count -1 do
    begin
      IssuedArt := m_LstArticles.p_Item[i];
      Article := IssuedArt.Article;
      cboxArticles.AddItem(Article.p_ArtCode, Article);
    end;
  end else
  begin

    for i := 0 to p_ArtTypeList.p_count -1 do
    begin
      ArtType := TMQMArticleType(p_ArtTypeList.p_Item[i]);
      if ArtType.p_ArtTypeCode = '' then
        cboxArtType.AddItem('DEFAULT', artType)
      else
        cboxArtType.AddItem(ArtType.p_ArtTypeCode, artType);
    end;

    if cboxArtType.Items.Count > 0 then
    begin
      cboxArtType.ItemIndex := 0;
      cboxArtTypeClick(self);
    end;

  end;

{$ifdef Develop}
  with SaveDialog do
  begin
    Title := _('Save list of balance:');
    InitialDir := GetCurrentDir;
    Filter := 'Text file|*.txt';//'Text file|*.txt|Word file|*.doc';
    DefaultExt := 'txt';
    FilterIndex := 1;
  end;
  sgrdBalance.ColCount := 6;
  SGReqBalance.ColCount := 7;
  btnSaveReqToFile.Visible := true;
  btnSaveToFile.Visible := true;
{$else}
  sgrdBalance.ColCount := 5;
  SGReqBalance.ColCount := 6;
  btnSaveReqToFile.Visible := false;
  btnSaveToFile.Visible := false;
{$endif}

  PageControl1.ActivePageIndex := 0;

  if Assigned(m_LstPtArtBal) then
    RefreshGridMat(TMQMArtBalanceList(m_LstPtArtBal))
  else
    RefreshGridMat(nil);

  if Assigned(m_LstPos) then
    RefreshGridPos(nil);

  if Assigned(m_LstMov) then
    RefreshGridMov;

end;

//----------------------------------------------------------------------------//

destructor TFShowMaterials.Destroy;
begin
  m_StrLst.Clear;
  m_StrLst.Free;
  m_StrLst := nil;
  m_ReqBalStrLst.Clear;
  m_ReqBalStrLst.Free;
  m_ReqBalStrLst := nil;
  inherited Destroy;
end;

procedure TFShowMaterials.FormShow(Sender: TObject);
begin
  ReShape(Self);
//  ReShape(btnSaveToFile);
end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.cboxArtTypeClick(Sender: TObject);
var
  ArtType : TMQMArticleType;
begin
  ArtType := nil;
  if cboxArtType.ItemIndex <> -1 then
    ArtType := TMQMArticleType(cboxArtType.Items.Objects[cboxArtType.ItemIndex]);
  RefreshArticleList(ArtType);
end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.RefreshArticleList(ArtType: TMQMArticleType);
var
  i : integer;
  Article : TMQMArticle;
begin
  cboxArticles.Clear;
  if Assigned(ArtType) then
    for i := 0 to ArtType.p_ArticleList.Count -1 do
    begin
      Article := TMQMArticle(ArtType.p_ArticleList.Items[i]);
      cboxArticles.AddItem(Article.p_ArtCode, Article);
    end;
end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.cboxArticlesClick(Sender: TObject);
var
  Article : TMQMArticle;
begin
  Article := TMQMArticle(cboxArticles.Items.Objects[cboxArticles.ItemIndex]);
  RefreshNetGroupList(Article);
end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.RefreshNetGroupList(Article: TMQMArticle);
var
  i : integer;
  NetGroup : TMQMNetGroup;
begin
  cboxNetGroups.Clear;
  for i := 0 to Article.p_NetGroupList.p_count -1 do
  begin
    NetGroup := TMQMNetGroup(Article.p_NetGroupList.p_Item[i]);
    if Trim(NetGroup.p_Code) = '' then
      cboxNetGroups.AddItem(cboxArticles.Items.Strings[cboxArticles.ItemIndex], NetGroup)
    else
      cboxNetGroups.AddItem(NetGroup.p_Code, NetGroup);
  end;

  if cboxNetGroups.Items.Count > 0 then
  begin
    cboxNetGroups.ItemIndex := 0;
    cboxNetGroupsClick(self);
  end else
    RefreshGridMat(nil);

end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.cboxNetGroupsClick(Sender: TObject);
var
  NetGroup : TMQMNetGroup;
begin
  NetGroup := TMQMNetGroup(cboxNetGroups.Items.Objects[cboxNetGroups.ItemIndex]);
  RefreshGridMat(NetGroup.m_BalanceList);
end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.RefreshGridMat(Lst: TMQMArtBalanceList);
var
  i: integer;
{$ifdef Develop}
  z : integer;
{$endif}
  recArtBalance : PTArtBalance;
  QtyTotal : double;
  NotUsed: boolean;
  str: string;
begin
  m_StrLst.Clear;
  m_StrLst.Add(_('Article:') + ' ' + cboxArtType.Text + ' - ' + cboxArticles.Text);
  m_StrLst.Add('');
  str := '';

  with sgrdBalance do
  begin
    RowCount := 2;
    Cells[0, 0] := _('Description');
    Cells[1, 0] := _('Type');
    Cells[2, 0] := _('Date');
    Cells[3, 0] := _('Quantity');
    Cells[4, 0] := _('Total');
{$ifdef Develop}
    Cells[5, 0] := _('ID');
{$endif}
    for i := 0 to ColCount -1 do
      Cells[i, 1] := '';

    if Assigned(Lst) and (Lst.p_count > 0) then
    begin
      RowCount := Lst.p_count +1;
      QtyTotal := 0;
      for i := 0 to Lst.p_count -1 do
      begin
        recArtBalance := PTArtBalance(Lst.p_Item[i]);

        if recArtbalance.JobID <> CSchedIDnull then
          Cells[0, i+1] := p_sc.GetObjInfo(recArtbalance.JobID, NotUsed)
        else
          Cells[0, i+1] := recArtbalance.Description;
        case recArtbalance.BalanceType of
          bt_Entry:
            begin
              Cells[1, i+1] := _('Entry');
              QtyTotal := QtyTotal + recArtbalance.Quantity;
            end;
          bt_EntryExp:     Cells[1, i+1] := _('Entry exp');
          bt_Expiration:   Cells[1, i+1] := _('Expiration');
          bt_Issue:
            begin
              Cells[1, i+1] := _('Issue');
              QtyTotal := QtyTotal - recArtbalance.Quantity;
            end;
          bt_IssueByAlloc: Cells[1, i+1] := _('Issue by alloc');
        end;

        Cells[2, i+1] := DateTimeToStr(recArtbalance.DueDate);
        Cells[3, i+1] := FloatToStr(recArtbalance.Quantity);
//        Cells[4, i+1] := FloatToStr(QtyTotal);
        Cells[4, i+1] := FloatToStr(recArtbalance.TotalBal);
{$ifdef Develop}
        Cells[5, i+1] := IntToStr(recArtbalance.JobID);

        // Prepare the List
        if i >= 0 then
        begin
          if Trim(Cells[0, i+1]) <> '' then
            str := _('Request:') + ' ' + Cells[0, i+1] + Chr(VK_TAB)
          else
          begin
            str := _('Request:') + ' ' + _('Entry warehouse');
            for z := 1 to 5 do str := str + Chr(VK_TAB);
          end;

          str := str +
                 _('Type:')        + ' ' + Cells[1, i+1] + Chr(VK_TAB) +
                 _('Date:')        + ' ' + Cells[2, i+1] + Chr(VK_TAB) +
                 _('Quantity:')    + ' ' + Cells[3, i+1] + Chr(VK_TAB) +
                 _('Total:')       + ' ' + Cells[4, i+1] + Chr(VK_TAB) +
                 _('Description:') + ' ' + Cells[5, i+1] + Chr(VK_TAB) +
                 _('ID:')          + ' ' + Cells[6, i+1];

          m_StrLst.Add(str)
        end;
{$endif}
      end;
    end;
  end;

  PageControl1.ActivePageIndex := 0;
end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.RefreshGridReqBal(Lst: TMQMRequestBalList);
var
  i: integer;
  BalRec: PTReqBalance;
  NotUsed: boolean;
  str: string;
begin
  str := '';

  with SGReqBalance do
  begin
    RowCount := 2;
    Cells[0, 0] := _('Description');
    Cells[1, 0] := _('Type');
    Cells[2, 0] := _('Date');
    Cells[3, 0] := _('Quantity');
    Cells[4, 0] := _('Total');
    Cells[5, 0] := _('Step');
{$ifdef Develop}
    Cells[6, 0] := _('ID');
{$endif}
    for i := 0 to ColCount -1 do
      Cells[i, 1] := '';

    if Assigned(Lst) and (Lst.p_count > 0) then
    begin
      RowCount := Lst.p_count +1;
      for i := 0 to Lst.p_count -1 do
      begin
        BalRec := PTReqBalance(Lst.p_Item[i]);
        if BalRec.JobID <> CSchedIDnull then
          Cells[0, i+1] := p_sc.GetObjInfo(BalRec.JobID, NotUsed)
        else
          Cells[0, i+1] := '';
        case BalRec.BalanceType of
          bt_Entry:
            begin
              Cells[1, i+1] := _('Entry');
            end;
          bt_EntryExp:     Cells[1, i+1] := _('Entry exp');
          bt_Expiration:   Cells[1, i+1] := _('Expiration');
          bt_Issue:
            begin
              Cells[1, i+1] := _('Issue');
            end;
          bt_IssueByAlloc: Cells[1, i+1] := _('Issue by alloc');
        end;

        Cells[2, i+1] := DateTimeToStr(BalRec.DueDate);
        Cells[3, i+1] := FloatToStr(BalRec.Quantity);
        Cells[4, i+1] := FloatToStr(BalRec.TotalBal);
        Cells[5, i+1] := IntToStr(BalRec.Step);
{$ifdef Develop}
        Cells[6, i+1] := IntToStr(BalRec.JobID);

        // Prepare the List
        if i >= 0 then
        begin
          str := '';
          str := _('Type:') + ' ' + Cells[1, i+1] + Chr(VK_TAB) +
                 _('Date:') + ' ' + Cells[2, i+1] + Chr(VK_TAB) +
                 _('Quantity:') + ' ' + Cells[3, i+1] + Chr(VK_TAB) +
                 _('Total:') + ' ' + Cells[4, i+1] + Chr(VK_TAB) +
                 _('ID:') + ' ' + Cells[5, i+1] + Chr(VK_TAB) +
                 _('Step:') + ' ' + Cells[6, i+1];

          m_ReqBalStrLst.Add(str)
        end;
{$endif}
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.btnSaveToFileClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    m_StrLst.SaveToFile(saveDialog.FileName);
end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.MIShowPosClick(Sender: TObject);
var
  id : integer;
  res : TMQMRes;
  Lst: TList;
begin
  Lst := TList.Create;

  // retrieve
  id := StrToInt(sgrdBalance.Cells[5, sgrdBalance.Row]);
  res := TMqmRes(TMqmActArea(p_sc.GetExtLinkPtr(id)).p_res);

  // get list of position
  p_sc.GetMinMaterialsArrivalDate(id, Res, [Ar_Material, Ar_MatWithDet], Lst, -1, -1, -1, false);

  // show position
  RefreshGridPos(Lst);

  Lst.Clear;
end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.popShowArrivalDatePopup(Sender: TObject);
begin
  if (Trim(sgrdBalance.Cells[5, sgrdBalance.Row]) <> '') and
     (StrToInt(sgrdBalance.Cells[5, sgrdBalance.Row]) <> -1) then
    MIShowPos.Enabled := true
  else
    MIShowPos.Enabled := false;
end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.RefreshGridPos(Lst: TList);
var
  i : integer;
  RecNoMat: PTRecNoMatDate;
begin
  if Assigned(m_LstPos) then
    Lst := m_LstPos;

  with sgrPos do
  begin
    RowCount := 2;
    Cells[1, 0] := _('Start');
    Cells[2, 0] := _('End');
    for i := 0 to ColCount -1 do
      Cells[i, 1] := '';

    if Assigned(Lst) and (Lst.Count > 0) then
    begin
      RowCount := Lst.Count +1;
      for i := 0 to Lst.Count -1 do
      begin
        RecNoMat := PTRecNoMatDate(Lst.Items[i]);
        Cells[1, i+1] := DateTimeToStr(RecNoMat.m_start);
        Cells[2, i+1] := DateTimeToStr(RecNoMat.m_end);
      end;
    end;
  end;

  PageControl1.ActivePageIndex := 1;

end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.RefreshGridMov;
var
  Rec: PTAvailRec;
  i : integer;
begin

//  TAvailRec = record
//    LocRec: PTLocRec;
//    BalanceType: CBalanceType;
//    Date: TDateTime;
//    Avail: boolean;
//  end;

  with sgrMov do
  begin
    RowCount := 2;
    Cells[0, 0] := _('Balance type');
    Cells[1, 0] := _('Date');
    Cells[2, 0] := _('Available');

    for i := 0 to ColCount -1 do
      Cells[i, 1] := '';

    if Assigned(m_LstMov) and (m_LstMov.Count > 0) then
    begin
      RowCount := m_LstMov.Count +1;
      for i := 0 to m_LstMov.Count -1 do
      begin
        Rec := PTAvailRec(m_LstMov.Items[i]);

        case Rec.BalanceType of
          bt_Entry:        Cells[0, i+1] := _('Entry');
          bt_EntryExp:     Cells[0, i+1] := _('Entry exp');
          bt_Expiration:   Cells[0, i+1] := _('Expiration');
          bt_Issue:        Cells[0, i+1] := _('Issue');
          bt_IssueByAlloc: Cells[0, i+1] := _('Issue by alloc');
        end;

        Cells[1, i+1] := DateTimeToStr(Rec.Date);

        if Rec.Avail then
          Cells[2, i+1] := _('YES')
        else
          Cells[2, i+1] := _('NO')

      end;
    end;
  end;

  PageControl1.ActivePageIndex := 2;

end;

//----------------------------------------------------------------------------//

procedure TFShowMaterials.btnSaveReqToFileClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    m_ReqBalStrLst.SaveToFile(saveDialog.FileName);
end;

end.
