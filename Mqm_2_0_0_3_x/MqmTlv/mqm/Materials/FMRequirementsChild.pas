unit FMRequirementsChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, FMRequirements, gnugettext, StdCtrls, UMSchedContFunc,
  UMBalance,Menus, UReShape;

type
  TFReqChild = class(TForm)
    SGRowDetails: TStringGrid;
    StProduct: TStaticText;
    LblProduct: TLabel;
    LblReq: TLabel;
    STProd: TStaticText;
    LblStep: TLabel;
    Ststep: TStaticText;
    LblSubStep: TLabel;
    StSubStep: TStaticText;
    LblRePrc: TLabel;
    StReProcess: TStaticText;
    StProductType: TStaticText;
    PopupMenu1: TPopupMenu;
    MIBalanceChange: TMenuItem;

    constructor CreateMatReqChildForm(AOwner: TComponent; RowList: Tlist; Id: TSchedId;
                ProductDesc: String; ArtType : string; Tollerance : double);
    procedure SGRowDetailsDblClick(Sender: TObject);
    procedure SGRowDetailsPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure SGRowDetailsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure MIBalanceChangeClick(Sender: TObject);
    procedure RefreshGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure SGRowDetailsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    m_SelectedRow: Integer;
    m_RowList: Tlist;
    m_Id     : TSchedId;
    m_Tollerance : double;
    m_JobInfo : string;
  public
    { Public declarations }
  end;

var
  FReqChild: TFReqChild;

implementation

{$R *.dfm}
uses
  Math,
  FMMainPlan,
  FMBalanceChange,
  UMObjCont;

//----------------------------------------------------------------------------//

constructor TFReqChild.CreateMatReqChildForm(AOwner: TComponent; RowList: Tlist; Id: TSchedId;
    ProductDesc: String; ArtType : string; Tollerance : double);
var
  NotInUsed : boolean;
begin
  inherited create(Aowner);
  TranslateComponent(self);
  m_RowList := RowList;
  m_Id      := id;
  m_Tollerance := Tollerance;
  m_JobInfo           := p_sc.GetObjInfo(m_id, NotInUsed);
  STProd.Caption      := p_sc.GetFldDescr(id,CSC_ProdReq, false);
  Ststep.Caption      := p_sc.GetFldDescr(id,CSC_ProdStep, false);
  StSubStep.Caption   := p_sc.GetFldDescr(id,CSC_ProdSubStep, false);
  StReProcess.Caption := p_sc.GetFldDescr(id,CSC_ReprocNo, false);
  StProduct.Caption   := ProductDesc;
  StProductType.Caption := ArtType;
  RefreshGrid;

  ReShape(Self);
end;

//----------------------------------------------------------------------------//

procedure TFReqChild.SGRowDetailsPopUp(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
var
  Column,Row: LongInt;
  MouseX,MouseY : Integer;
  GridX,GridY: Integer;
  GridXY : TPoint;
begin
  MouseX := MousePos.X;
  MouseY := MousePos.Y;
  SGRowDetails.MouseToCell( MouseX ,MouseY,Column,Row);
  m_SelectedRow := Row;
  GridXY := SGRowDetails.ClientOrigin;
  GridX := GridXY.X + MouseX;
  GridY := GridXY.Y + MouseY;
  PopupMenu1.Popup(GridX,GridY);
end;

//----------------------------------------------------------------------------//

procedure TFReqChild.SGRowDetailsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  m_SelectedRow := ARow;
end;

//----------------------------------------------------------------------------//

procedure TFReqChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_RowList.Free;
  Action := caFree;
end;

//----------------------------------------------------------------------------//

procedure TFReqChild.MIBalanceChangeClick(Sender: TObject);
begin
  SGRowDetailsDblClick(self);
end;

//----------------------------------------------------------------------------//

procedure TFReqChild.PopupMenu1Popup(Sender: TObject);
begin
  PopupMenu1.Items[0].Enabled := false;
  if m_SelectedRow = 0 then
     Exit;
  if PTDetailRows(m_RowList.Items[m_SelectedRow - 1]).FromHeader then
    PopupMenu1.Items[0].Enabled := true
  else
    PopupMenu1.Items[0].Enabled := false;
end;

//----------------------------------------------------------------------------//

procedure TFReqChild.RefreshGrid;
var
  I : integer;
  RowData: PTDetailRows;
begin
  try
  with SGRowDetails do
  begin

    RowCount := m_RowList.Count + 1;

    Cells[0, 0] := _('Date');
    Cells[1, 0] := _('Quantity');
    Cells[2, 0] := _('Balance');
    Cells[3, 0] := _('Details');

    for i:= 0 to m_RowList.Count -1 do
    begin
      RowData := m_RowList.Items[i];

      Cells[0, i+1] := RowData.Date;
      Cells[1, i+1] := FloatToStr(RowData.Quantity);
      Cells[2, i+1] := FloatToStr(RowData.TotalBal);  //FloatToStr(TotalBalance);
      Cells[3, i+1] := RowData.description;
    //  Cells[3, i+1] := FloatToStr(recArtbalance.TotalBal);
    //  Cells[4, i+1] := IntToStr(recArtbalance.JobID);

      Cells[4, i+1] := 'xxx';

    end; //for
   end;//with
   except
    on e:Exception do MessageDlg('FMRequirementsChild - CreateMatReqChildForm'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;


end;

//----------------------------------------------------------------------------//

procedure TFReqChild.SGRowDetailsDblClick(Sender: TObject);
var
  FBalanceChange: TFBalanceChange;
  MQMPlan : TFMQMPlan;
  I : Integer;
  NetGroup : TMQMNetGroup;
  ArtBalList: TMQMArtBalanceList;
  NotUsed: boolean;
  RowData: PTDetailRows;
  ArtBalance : PTArtBalance;
  ProductCode : string;
begin
  try

    if (m_SelectedRow = 0) or not PTDetailRows(m_RowList.Items[m_SelectedRow - 1]).FromHeader then
       Exit;

    ProductCode := PTDetailRows(m_RowList.Items[m_SelectedRow - 1]).ProductCode;

    FBalanceChange := TFBalanceChange.CreateBalanceChangeForm(self, PTDetailRows(m_RowList.Items[m_SelectedRow - 1]));
    FBalanceChange.ShowModal;
    FBalanceChange.Free;
    PTDetailRows(m_RowList.Items[m_SelectedRow - 1]).NetGroupPtr.m_lastBalanceUpdatedTime := now;
    p_sc.UpdateBalance(m_Id);

    NetGroup := TMQMNetGroup(PTDetailRows(m_RowList.Items[m_SelectedRow - 1]).NetGroupPtr);

    for I := 0 to m_RowList.Count - 1 do
      Dispose(PTDetailRows(m_RowList[i]));

    m_RowList.clear;
    ArtBalList := NetGroup.m_BalanceList;

    ArtBalList.SortBalanceList;
    NetGroup.UpdateBalanceTotals('', CSchedIDnull);

    if Assigned(ArtBalList) and (ArtBalList.p_count > 0) then
    begin
      for i := 0 to ArtBalList.p_count -1 do
      begin
        new(RowData);
        RowData.FromHeader := false;
        ArtBalance := PTArtBalance(ArtBalList.p_Item[i]);
        RowData.Artbalance  := ArtBalance;
        RowData.Date        := DateTimeToStr(ArtBalance.DueDate);
        RowData.Quantity    := RoundTo(ArtBalance.RealQty,-2);

        if (ArtBalance.BalanceType <> bt_Entry) and
           (ArtBalance.BalanceType <> bt_EntryExp) then
          RowData.Quantity  := (-1) * RowData.Quantity;

        RowData.TotalBal    := RoundTo(ArtBalance.TotalBal, -2);

        if ArtBalance.JobID <> CSchedIDnull then
          Rowdata.description := p_sc.GetObjInfo(ArtBalance.JobID, NotUsed)
        else
        begin
          Rowdata.description := ArtBalance.Description;
          Rowdata.FromHeader  := true;
        end;
        Rowdata.ProductCode := ProductCode;
        if ArtBalance.BalanceType = bt_Expiration then
          Rowdata.description := _('Expire of:') + ' ' + Rowdata.description;

        if ArtBalance.JobID = m_id then
        begin
//        if Shortage > recArtbalance.TotalBal then
//          Shortage := recArtbalance.TotalBal;
        end;
        Rowdata.NetGroupPtr    := NetGroup;
        m_RowList.Add(RowData);
      end;
    end;

    RefreshGrid;
    MQMPlan := GetPlanView;
    MQMPlan.RefreshActiveTab;
  except
    on e:Exception do MessageDlg('FMBalanceChange - SGRowDetailsDblClick'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

procedure TFReqChild.SGRowDetailsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  S: string;
  RectForText: TRect;
  RowData : PTDetailRows;
begin
 // Check for your cell here (in this case the cell in column 4 and row 2 will be colored)
  if m_RowList.Count = 0 then exit;
  try
    if ARow = 0 then exit;
    RowData := PTDetailRows(m_RowList[ARow - 1]);
  except
    RowData := PTDetailRows(m_RowList[ARow]);
  end;

  if RowData.description = m_JobInfo then
  begin
    S := SGRowDetails.Cells[ACol, ARow];
    // Fill rectangle with colour
    if RowData.TotalBal >= 0 then
      SGRowDetails.Canvas.Brush.Color := clgreen
    else
    begin
      if RowData.TotalBal > (0 - m_Tollerance) then
        SGRowDetails.Canvas.Brush.Color := ClLime
      else
        SGRowDetails.Canvas.Brush.Color := clred;
    end;

    SGRowDetails.Canvas.FillRect(Rect);
    // Next, draw the text in the rectangle
    SGRowDetails.Canvas.Font.Color := clWhite;
    RectForText := Rect;
    // Make the rectangle where the text will be displayed a bit smaller than the cell
    // so the text is not "glued" to the grid lines
    InflateRect(RectForText, -2, -2);
    // Edit: using TextRect instead of TextOut to prevent overflowing of text
    SGRowDetails.Canvas.TextRect(RectForText, S);
  end;


end;

end.
