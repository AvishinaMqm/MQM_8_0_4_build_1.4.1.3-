//******************************************************************************
// This form shows the requirement material needed per Job
// Applied per Work Center . The user can also create and delete sets.
// The set in focus in the Combo box is the active set.
// If there is no set configured for the Wkc then a default set is returned.
// all the data is kept in two lists
// BarSetList keeps all the sets with their name
// WkcSetList keeps all the WorkCenters with their sets
//******************************************************************************

unit FMRequirements;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids,
  UMSchedContFunc,
  gnugettext,
  StdCtrls,
  UMIssuedArt,
  UMBalance,
  UMArticles,
  Math, ComCtrls, Menus, ExtCtrls, UReShape;

type
  THeaderRow = record
    ArticleCode:  string;
    netGroup:     String;
    TotalBal:     Double;
    Shortage:     Double;
    description:  String;
    DetailRows:   Tlist;
    ArtType   :   string;
    TolleranceQty : double;
end;
  PTHeaderRow =  ^THeaderRow;

type
  TFMaterialReq = class(TForm)
    PopupMenu1: TPopupMenu;
    MIShowmaterials: TMenuItem;
    Panel1: TPanel;
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
    GroupBox1: TGroupBox;
    LblPrevstepBal: TLabel;
    LblPrevBal: TLabel;
    StBalancePrev: TStaticText;
    LblPrevShort: TLabel;
    StPrevShort: TStaticText;
    StNextShort: TStaticText;
    LblMaxNextShort: TLabel;
    StNextBal: TStaticText;
    LblNextBal: TLabel;
    LblNextstepBal: TLabel;
    BtnPrevStepBal: TcxButton;
    BtnNextStepBalance: TcxButton;
    BtnAbort: TcxButton;

  constructor CreateReqForm(AOwner: TComponent; Id: TSchedID;
                                 LstArticles: TMQMIssuedArtList); //ArtBalList: TMQMArtBalanceList);
  procedure   PrintMatReqGrid;//ArtBalList: TMQMArtBalanceList);
  procedure   GetDataForGrid(NetGroup : TMQMNetGroup; artdesc: String;
                             var RowList: Tlist;
                             out TotalBal: double;
                             out Shortage: double; ArticleCode : string);
  procedure   ListArticles( LstArticles: TMQMIssuedArtList );
  procedure   AddArticleToForm(Article: TMQMArticle ; NetCode : TMQMNetGroup ; IssuedArt: PTIssuedArt);
  function    GetBalance(id: TSchedID; var TotalBalance: double; var Shortage: double; isPrevstep: boolean): boolean;
//  function    GetNextStep(id: TSchedID; var TotalBalance: double; var Shortage: double):boolean;
  procedure MIShowmaterialsClick(Sender: TObject);
  procedure SGRequirementsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure SGRequirementsSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure BtnPrevStepBalClick(Sender: TObject);
    procedure BtnNextStepBalanceClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    m_GridDataList:  Tlist;
    m_PrevStepData:  Tlist;
    m_NextStepData:  Tlist;
    m_id:            Integer;
    m_LstArticles:   TMQMIssuedArtList;
  public
    { Public declarations }
  end;

var
  FMaterialReq: TFMaterialReq;
  SelectedRow: Integer;
implementation

{$R *.dfm}
uses
   UMSchedCont,
   UMObjCont,
   UMSchedList,
   FMRequirementsChild,
   FMRequirementsStepChild;


//----------------------------------------------------------------------------//

constructor TFMaterialReq.CreateReqForm(AOwner: TComponent; Id: TSchedID;
                                      LstArticles: TMQMIssuedArtList);//ArtBalList: TMQMArtBalanceList);
var
  PrevStepInfo: TSQStepInfo;
  NextStepInfo: TSQStepInfo;
  TimingInfo:   TSQtimingInfo;
  Balance, Shortage: double;

begin
  try
  inherited create(Aowner);
  TranslateComponent(self);

  m_LstArticles := LstArticles;
  Balance := 0;
  Shortage := 0;
 // m_numOfRows    := 2;
  m_GridDataList := Tlist.create();
  m_PrevStepData := Tlist.create();
  m_NextStepData := Tlist.create();
  m_id           := id;

  PrevStepInfo.StepNo := 0;
  NextStepInfo.StepNo := 0;
  p_sc.GetTimingInfo(id, TimingInfo);
  p_sc.GetPrecStepToSched(TimingInfo.prodReq, TimingInfo.step, PrevStepInfo);
  p_sc.GetNextStepToSched(TimingInfo.prodReq, TimingInfo.step, NextStepInfo);
  {
  HeaderDetail := _('Request')   + ' :' + p_sc.GetFldDescr(id,CSC_ProdReq)     + ' ' +
                  _('Step')      + ' :' + p_sc.GetFldDescr(id,CSC_ProdStep)    + ' ' +
                  _('Sub step')  + ' :' + p_sc.GetFldDescr(id,CSC_ProdSubStep) + ' ' +
                  _('Re process')+ ' :' + p_sc.GetFldDescr(id,CSC_ReprocNo)    + ' ' ;
   }
   STProd.Caption      := p_sc.GetFldDescr(id,CSC_ProdReq, false);
   Ststep.Caption      := p_sc.GetFldDescr(id,CSC_ProdStep, false);
   StSubStep.Caption   := p_sc.GetFldDescr(id,CSC_ProdSubStep, false);
   StReProcess.Caption := p_sc.GetFldDescr(id,CSC_ReprocNo, false);
  if PrevStepInfo.StepNo > 0 then
  begin
    if GetBalance(id, Balance, Shortage, true) then
    begin
      Balance := RoundTo(Balance,-2);
      BtnPrevStepBal.Enabled := true;
      StBalancePrev.Enabled  := true;
      StPrevShort.Enabled    := true;
      LblPrevstepBal.Enabled := true;
      LblPrevBal.Enabled     := true;
      LblPrevShort.Enabled   := true;
      StBalancePrev.Caption  := FloatToStr(RoundTo(Balance, -2));
      StPrevShort.Caption    := FloatToStr(RoundTo(Shortage, -2));
    //    PrevStepDetail := _('Previous step balance') + ' :' + FloatToStr(Balance);
//    PrevStepDetail := PrevStepDetail  + '  ' + _('Max Shortage') + ' : ' + FloatToStr(Shortage);
//    BtnPrevStepBal.Caption := PrevStepDetail;
    end;
  end;//if there is a previous step

  if NextStepInfo.StepNo > 0 then
  begin
//    if GetNextStep(id, Balance, Shortage) then
    if GetBalance(id, Balance, Shortage, false) then
    begin
      Balance := RoundTo(Balance,-2);
      BtnNextStepBalance.Enabled := True;
      StNextBal.Enabled          := true;
      StNextShort.Enabled        := true;
      LblNextstepBal.Enabled     := true;
      LblNextBal.Enabled         := true;
      LblMaxNextShort.Enabled    := true;
      StNextBal.Caption          := FloatToStr(RoundTo(Balance, -2));
      StNextShort.Caption        := FloatToStr(RoundTo(Shortage, -2));
   //   NextStepDetail := _('Next step balance') + ' :' + FloatToStr(Balance);
   //   NextStepDetail :=  NextStepDetail + '  ' +  _('Max Shortage') + ' : ' + FloatToStr(Shortage);
   //   BtnNextStepBalance.Caption := NextStepDetail;
    end;
  end;

 // LblHeader.Caption := HeaderDetail;
 // BtnPrevStepBal.Caption     := PrevStepDetail;

  //  LblPrevStep.Caption := PrevStepDetail;
//  LblNextStep.Caption := NextStepDetail;

  ListArticles( LstArticles );
  except
    on e:Exception do MessageDlg('FMRequirements - CreateReqForm'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;

  self.OnShow := FormShow;
  ReShape(Self);

end;

procedure TFMaterialReq.FormShow(Sender: TObject);
begin
    BringToFront;
end;

//----------------------------------------------------------------------------//

procedure TFMaterialReq.PrintMatReqGrid;//ArtBalList: TMQMArtBalanceList);
var
  i: integer;
//  TotalBalance: double;
//  recArtBalance : PTArtBalance;
//  ArtBalList: TMQMArtBalanceList;
//  NotUsed: boolean;
//  RowData: PTDetailRows;
  HeaderRow:  PTHeaderRow;
begin
  try
  with SGRequirements do
  begin

    RowCount := m_GridDataList.Count + 1;
    Cells[0, 0] := _('Material type');
    Cells[1, 0] := _('Material code');
    Cells[2, 0] := _('Description');
    Cells[3, 0] := _('Net group');
    Cells[4, 0] := _('Total balance');
    Cells[5, 0] := _('Shortage');
    ColWidths[5] := 70;
    Cells[6, 0] := _('Tolerance');
    ColWidths[6] := 70;

    for i:= 0 to m_GridDataList.Count -1 do
    begin
      HeaderRow := m_GridDataList.Items[i];
      Cells[0, i+1] := HeaderRow.ArtType;
      Cells[1, i+1] := HeaderRow.ArticleCode;
      Cells[2, i+1] := HeaderRow.description;
      Cells[3, i+1] := HeaderRow.netGroup;
      Cells[4, i+1] := FloatToStr(HeaderRow.TotalBal);  //FloatToStr(TotalBalance);
      Cells[5, i+1] := FloatToStr(HeaderRow.Shortage);
      Cells[6, i+1] := FloatToStr(HeaderRow.TolleranceQty);

    //   Cells[4, i+1] := FloatToStr(QtyTotal);
    //  Cells[3, i+1] := FloatToStr(recArtbalance.TotalBal);
    //  Cells[4, i+1] := IntToStr(recArtbalance.JobID);
    end; //for
   end;//with
   except
    on e:Exception do MessageDlg('FMRequirements - PrintMatReqGrid'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
 end;

//----------------------------------------------------------------------------//

procedure TFMaterialReq.ListArticles( LstArticles: TMQMIssuedArtList );
var
  i,j: Integer;
  ArtType : TMQMArticleType;
  Article : TMQMArticle;
  IssuedArt: PTIssuedArt;
begin
 try
 if Assigned(LstArticles) then
  begin
 //   m_LstArticles := LstArticles;

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
        end;//for j
      end;//if
    end;//for
   end;//else

  except
    on e:Exception do MessageDlg('FMRequirements  ListArticles'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

//----------------------------------------------------------------------------//

//add a new article
procedure  TFMaterialReq.AddArticleToForm(Article: TMQMArticle ; NetCode : TMQMNetGroup; IssuedArt: PTIssuedArt);
var
  NetGroup : TMQMNetGroup;
  i: Integer;
  ArtDesc: String;
  RowList: Tlist;
  HeaderRow:  PTHeaderRow;
  TotalBal,
  Shortage, TolleranceQuantity: double;
  quantSched, IniQty : variant;
  DataType: CBinColValType;
begin
  try
  for i := 0 to Article.p_NetGroupList.p_count -1 do
  begin
    //new (HeaderRow);
    RowList := Tlist.Create();
    NetGroup := TMQMNetGroup(Article.p_NetGroupList.p_Item[i]);
    if (assigned(NetCode)) and (NetCode.m_Code <> NetGroup.m_Code) then
       Continue;

    TolleranceQuantity := 0;
    if Article.p_RecTollerancePercent.TolleranceQty1 > 0 then
    begin
      p_sc.GetFldValue(m_Id , CSC_QtyToSched, quantSched, dataType);
      p_sc.GetFldValue(m_Id , CSC_IniQty, IniQty, dataType);
      TolleranceQuantity := Article.GetTolleranceQuantity(IssuedArt.RequiredQty);
    end;

    GetDataForGrid(NetGroup, ArtDesc, RowList, TotalBal, Shortage,Article.p_ArtCode);
    if RowList.Count = 0 then
       Continue;
    new (HeaderRow);
    HeaderRow.ArticleCode := Article.p_ArtCode;
    HeaderRow.netGroup := NetGroup.p_Code;
    HeaderRow.TotalBal := TotalBal;
    HeaderRow.Shortage := Shortage;
    HeaderRow.DetailRows := RowList;
    HeaderRow.description := Article.p_Description;
    HeaderRow.ArtType     := Article.p_ArtType.p_ArtTypeCode;
    HeaderRow.TolleranceQty := TolleranceQuantity;

    m_GridDataList.Add(HeaderRow);
  end;
 //  RefreshGridRequirements();
  PrintMatReqGrid;
  except
    on e:Exception do MessageDlg('FMRequirements  AddArticleToForm'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;
//----------------------------------------------------------------------------//

{
procedure TFMaterialReq.GetDataForGrid(NetGroup : TMQMNetGroup; artdesc: String;
                                   var RowList: Tlist;
                                   out TotalBalance: double;
                                   out Shortage: double);
  }
procedure   TFMaterialReq.GetDataForGrid(NetGroup : TMQMNetGroup; artdesc: String;
                             var RowList: Tlist;
                             out TotalBal: double;
                             out Shortage: double; ArticleCode : string);
var
  i: integer;
  recArtBalance : PTArtBalance;
  ArtBalList: TMQMArtBalanceList;
  NotUsed: boolean;
  RowData: PTDetailRows;
begin
  recArtBalance := nil;
  try
    TotalBal := 0;
    Shortage     := 0;
    ArtBalList := NetGroup.m_BalanceList;
    // fp - may, 08 2006
    ArtBalList.SortBalanceList;
    NetGroup.UpdateBalanceTotals('', CSchedIDnull);

    if Assigned(ArtBalList) and (ArtBalList.p_count > 0) then
    begin
      for i := 0 to ArtBalList.p_count -1 do
      begin
        new(RowData);
        Rowdata.FromHeader := false;
        recArtBalance := PTArtBalance(ArtBalList.p_Item[i]);
        RowData.Date        := DateTimeToStr(recArtbalance.DueDate);
        RowData.Quantity    := RoundTo(recArtbalance.RealQty,-2);
   //    RowData.Quantity    := RoundTo(recArtbalance.Quantity,-2);

        if (recArtbalance.BalanceType <> bt_Entry) and
           (recArtbalance.BalanceType <> bt_EntryExp) then
          RowData.Quantity  := (-1) * RowData.Quantity;

        RowData.TotalBal    := RoundTo(recArtbalance.TotalBal, -2);

        if recArtbalance.JobID <> CSchedIDnull then
          Rowdata.description := p_sc.GetObjInfo(recArtbalance.JobID, NotUsed)
        else
        begin
          Rowdata.description := recArtbalance.Description;
          Rowdata.FromHeader  := true;
         // Rowdata.Artbalance  := recArtbalance;
          Rowdata.ProductCode := ArticleCode;
        end;
        if recArtbalance.BalanceType = bt_Expiration then
          Rowdata.description := _('Expire of:') + ' ' + Rowdata.description;

        if recArtbalance.JobID = m_id then
        begin
        if Shortage > recArtbalance.TotalBal then
          Shortage := recArtbalance.TotalBal;
        end;
        Rowdata.NetGroupPtr    := NetGroup;
        Rowdata.Artbalance  := recArtbalance;
        RowList.Add(RowData);
      end;//for
      TotalBal    := recArtbalance.TotalBal;

    end;//if
  except
    on e:Exception do MessageDlg('FMRequirements  GetDataForGrid'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

//----------------------------------------------------------------------------//
{
function TFMaterialReq.GetNextStep(id: TSchedID;var TotalBalance: double; var Shortage: double):boolean;
var
  NextJobsList: TMSchedList;
  TimingInfo:   TSQtimingInfo;
  NextStepInfo: TSQStepInfo;
begin
  Result := false;
 try
  p_sc.GetTimingInfo(id, TimingInfo);
  NextJobsList := TMSchedList.Create(self);
  p_sc.GetNextStepToSched(TimingInfo.prodReq, TimingInfo.step, NextStepInfo);
  p_sc.GetStepJobs(TimingInfo.ProdReq, NextStepInfo.StepNo, NextJobsList);
 // for i := 0 to NextJobsList.GetLinkCount-1 do //go over all jobs of next step
 //   Result :=  Result + GetBalance(NextJobsList.GetLink(i);
  if NextJobsList.GetLink(0) > 0 then
     result := GetBalance(NextJobsList.GetLink(0), TotalBalance,Shortage, false);
      

  NextJobsList.Free;
  except
    on e:Exception do MessageDlg('FMRequirements  GetNextStep'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;
}
//----------------------------------------------------------------------------//

function TFMaterialReq.GetBalance(id: TSchedID; var TotalBalance: double; var Shortage: double; isPrevstep: boolean): boolean;
var
  ReqBalList: TMQMRequestBalList;
  i: Integer;
  BalRec: PTReqBalance;
  RowData: PTDetailRows;
  NotUsed: Boolean;
  TimingInfo: TSQtimingInfo;
  StepInfo: TSQstepInfo;
begin
  result := false;
  try
    Shortage := 0;
    TotalBalance := 0;
    ReqBalList := p_sc.GetReqBalList(id);
    p_sc.UpdateBalance(id);
    p_sc.GetTimingInfo(id, TimingInfo);
    ReqBalList.SortBalanceList;

    if isPrevstep then
    begin
      p_sc.GetPrecStepToSched(TimingInfo.prodReq, TimingInfo.step, StepInfo);
      ReqBalList.UpdateBalanceTotals(StepInfo.StepNo, CSchedIDnull);
    end
    else
      ReqBalList.UpdateBalanceTotals(TimingInfo.step, CSchedIDnull);

    if Assigned(ReqBalList) and (ReqBalList.p_count > 0) then
    begin
      for i := 0 to ReqBalList.p_count -1 do
      begin
        BalRec := PTReqBalance(ReqBalList.p_Item[i]);
        if (BalRec.JobID <> CSchedIDnull) and (BalRec.RealQty > 0) then
        begin
          result := true;
          new(RowData);

          RowData.Date        := DateTimeToStr(BalRec.DueDate);
          RowData.Quantity    := RoundTo(BalRec.RealQty, -2);
          if (BalRec.BalanceType <> bt_Entry) and
             (BalRec.BalanceType <> bt_EntryExp) then
            RowData.Quantity  := (-1) * RowData.Quantity;

          RowData.TotalBal    := RoundTo(BalRec.TotalBal, -2);  //RoundTo(BalRec.TotalBal, -2);

          if BalRec.JobID <> CSchedIDnull then
            RowData.description := p_sc.GetObjInfo(BalRec.JobID, NotUsed)
          else
            RowData.description := '';

          if BalRec.BalanceType = bt_Expiration then
            Rowdata.description := _('Expire of:') + ' ' + Rowdata.description;

          if Shortage > BalRec.TotalBal then
            Shortage := BalRec.TotalBal;

          if isPrevStep then
            m_PrevStepData.Add(RowData)
          else
            m_NextStepData.Add(RowData);

          TotalBalance := RowData.TotalBal;
        end;//if
      end;//for
    end;//if
  except
    on e:Exception do MessageDlg('FMRequirements - GetBalance'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

//----------------------------------------------------------------------------//

{
procedure TFMaterialReq.SGRequirementsSelectCell(Sender: TObject; ACol,
                                 ARow: Integer; var CanSelect: Boolean);
var
  i:  Integer;
  RowD: TStrings;
  HeaderRow:  PTHeaderRow;
  RowData: PTDetailRows;
  FormRowDetails: TFReqChild;
begin
  try
  HeaderRow := m_GridDataList.Items[ARow - 1];
  FormRowDetails := TFReqChild.CreateMatReqChildForm(self, HeaderRow.DetailRows);
  FormRowDetails.ShowModal;
  FormRowDetails.Free;
  except
    on e:Exception do MessageDlg('FMRequirements - SGRequirementsSelectCell'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;
 }

//----------------------------------------------------------------------------//

procedure TFMaterialReq.MIShowmaterialsClick(Sender: TObject);
var
  HeaderRow:  PTHeaderRow;
  FormRowDetails: TFReqChild;
begin
  try
    if SelectedRow = 0 then
      Exit;
    HeaderRow := m_GridDataList.Items[SelectedRow -1];
    FormRowDetails := TFReqChild.CreateMatReqChildForm(self,HeaderRow.DetailRows, m_id, HeaderRow.ArticleCode, HeaderRow.ArtType, HeaderRow.TolleranceQty);
    FormRowDetails.ShowModal;
    m_GridDataList.Clear;
    ListArticles(m_LstArticles);
    PrintMatReqGrid;
    FormRowDetails.Free;
  except
    on e:Exception do MessageDlg('FMRequirements - MIShowmaterialsClick'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMaterialReq.SGRequirementsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  Column,Row: LongInt;
  MouseX,MouseY : Integer;
  GridX,GridY: Integer;
  GridXY : TPoint;
begin
  MouseX := MousePos.X;
  MouseY := MousePos.Y;
  SGRequirements.MouseToCell( MouseX ,MouseY,Column,Row);
  SelectedRow := Row;
  GridXY := SGRequirements.ClientOrigin;
  GridX := GridXY.X + MouseX;
  GridY := GridXY.Y + MouseY;
  PopupMenu1.Popup(GridX,GridY);
end;

//----------------------------------------------------------------------------//

procedure TFMaterialReq.SGRequirementsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  SelectedRow := Arow;
end;

//----------------------------------------------------------------------------//

procedure TFMaterialReq.BtnPrevStepBalClick(Sender: TObject);
var
  FormStepDetails: TFPrevNextStepDetails;
begin
  FormStepDetails := TFPrevNextStepDetails.CreatePrevNextChildForm(self, m_PrevStepData, m_id,true);
  FormStepDetails.ShowModal;
  FormStepDetails.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMaterialReq.BtnAbortClick(Sender: TObject);
begin
  Close;
end;

procedure TFMaterialReq.BtnNextStepBalanceClick(Sender: TObject);
var
  FormStepDetails: TFPrevNextStepDetails;
begin
  FormStepDetails := TFPrevNextStepDetails.CreatePrevNextChildForm(self, m_NextStepData, m_id, false);
  FormStepDetails.ShowModal;
  FormStepDetails.Free;
end;

end.
