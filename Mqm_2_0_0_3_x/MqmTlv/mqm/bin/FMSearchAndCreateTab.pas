unit FMSearchAndCreateTab;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UMSchedContFunc, ComCtrls, UMCompat, Vcl.ExtCtrls, Dateutils, UReShape;

type
  TSearchAndCreateTab = class(TForm)
    TabName: TLabel;
    EditTabName: TEdit;
    LblFrom: TLabel;
    EditFrom: TEdit;
    LBlTo: TLabel;
    EditTo: TEdit;
    DatePickDelivDate_From: TDateTimePicker;
    DatePickDelivDate_To: TDateTimePicker;
    ComboBoxTo: TComboBox;
    ComboBoxFrom: TComboBox;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    procedure BtnOkClick(Sender: TObject);
    procedure EditFromKeyPress(Sender: TObject; var Key: Char);
    procedure BtnAboClick(Sender: TObject);
  private
    m_BinColId: CBinColId;
    m_IsPropSearch : boolean;
    m_PropId : TPropID;
    m_ListWC : TList;
    m_ListProces : TStringList;
    procedure IniSettings;
    procedure IniDate;
    { Private declarations }
  public
    constructor SearchAndCreateTab(AOwner: TComponent ; BinColId : CBinColId);
    constructor SearchAndCreateTabByProp(AOwner: TComponent ;PropID : TPropID);
    { Public declarations }
  end;

var
  SearchAndCreateTab: TSearchAndCreateTab;

implementation

{$R *.dfm}

uses gnugettext,FMbin, UMplan, UMObjCont, UMWkCtr;

//----------------------------------------------------------------------------//

procedure TSearchAndCreateTab.BtnAboClick(Sender: TObject);
begin
  close;
end;

//----------------------------------------------------------------------------//

procedure TSearchAndCreateTab.BtnOkClick(Sender: TObject);
var
  Year, Month, Day: Word;
  DateFrom, DateTo : TDateTime;
begin
  if assigned(FBin) then
  begin
    if not m_IsPropSearch then
    begin
      Case m_BinColId of
      CSC_ProdDlvDate,CSC_PlanStartDate,CSC_SchedStart, CSC_LowStartDate,
         CSC_HighEndLimit, CSC_LowStartTimeLimit : begin
                            DecodeDate(DatePickDelivDate_From.Date, Year, Month, Day);
                            DateFrom := EncodeDate(Year, Month, Day);
                            DecodeDate(DatePickDelivDate_To.Date, Year, Month, Day);
                            DateTo := EncodeDate(Year, Month, Day);
                            FBin.CreateTabBySearchValues(EditTabName.Text, DateFrom ,DateTo, m_BinColId, false, nil);
                        end;
         CSC_WkctCode , CSC_WkctProc : FBin.CreateTabBySearchValues(EditTabName.Text,ComboBoxFrom.Items[ComboBoxFrom.ItemIndex],ComboBoxTo.Items[ComboBoxTo.ItemIndex], m_BinColId, false, nil);

         CSC_StepType, CSC_prodType :  FBin.CreateTabBySearchValues(EditTabName.Text,ComboBoxFrom.Items[ComboBoxFrom.ItemIndex],0, m_BinColId, false, nil);
        else
          FBin.CreateTabBySearchValues(EditTabName.Text,EditFrom.Text,EditTo.Text, m_BinColId, false, nil);
      end;
    end
    else
    begin
      FBin.CreateTabBySearchValues(EditTabName.Text,EditFrom.Text,EditTo.Text, m_BinColId, true, m_PropId);
    end;

  end;
  close;
end;

//----------------------------------------------------------------------------//

procedure TSearchAndCreateTab.EditFromKeyPress(Sender: TObject; var Key: Char);
var
  AlphaCode : boolean;
begin
  if m_IsPropSearch then
  begin
    AlphaCode := IsPropAlpha(m_PropId);
    if not AlphaCode then
    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24))) then
      abort;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSearchAndCreateTab.IniDate;
var
  I, J : Integer;
  wc : TMqmWrkCtr;
  function CheckExistProc(Pro : string) : boolean;
  var
    i: integer;
  begin
    Result := false;
    for i := 0 to m_ListProces.Count - 1 do
      if Pro = m_ListProces.Strings[I] then exit;
    Result := true
  end;

begin

  if (m_BinColId = CSC_ProdType) then
  begin
    ComboBoxFrom.Items.Add('');
    for I := 0 to p_ArtType.GetCount - 1 do
    ComboBoxFrom.Items.Add(p_ArtType.GetNext(I));
  end;

  if (m_BinColId = CSC_StepType) then
  begin
    i := ComboBoxFrom.Items.Add('');
    ComboBoxFrom.Items.Objects[i] := TObject(CST_undef);

    i := ComboBoxFrom.Items.Add('Batches');
    ComboBoxFrom.Items.Objects[i] := TObject(CST_batch);

    i := ComboBoxFrom.Items.Add('Continuous');
    ComboBoxFrom.Items.Objects[i] := TObject(CST_Continuous);

    i := ComboBoxFrom.Items.Add('Printing');
    ComboBoxFrom.Items.Objects[i] := TObject(CST_printing);

    ComboBoxFrom.ItemIndex := 0
  end;

  if (m_BinColId = CSC_WkctCode) or (m_BinColId = CSC_WkctProc) then
  begin
    m_ListWC := TList.Create;
    m_ListWC.Clear;
    for i := 0 to p_pl.p_WrkCtrsCount -1 do
    begin
      wc := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
      m_ListWC.Add(wc);
    end;
    ComboBoxFrom.Items.Clear;
    ComboBoxFrom.Enabled := true;
    ComboBoxFrom.Items.Add('');
    ComboBoxTo.Items.Clear;
    ComboBoxTo.Enabled := true;
    ComboBoxTo.Items.Add('');
  end;

  if (m_BinColId = CSC_WkctCode) then
  begin
    for I := 0 to m_ListWC.Count - 1 do
    begin
      ComboBoxFrom.Items.Add(TMqmWrkCtr(m_ListWC[I]).p_WrkCtrCode);
      ComboBoxTo.Items.Add(TMqmWrkCtr(m_ListWC[I]).p_WrkCtrCode);
    end;
  end;

  if (m_BinColId = CSC_WkctProc) then
  begin
    for I := 0 to m_ListWc.Count - 1 do
    begin
      Wc := TMqmWrkCtr(m_ListWc[I]);
      for J := 0 to Wc.P_GetProccesCount - 1 do
      begin
        if CheckExistProc(Wc.P_GetProcess[J]) then
          m_ListProces.Add(Wc.P_GetProcess[J]);
      end;
    end;

    for I := 0 to m_ListProces.Count - 1 do
    begin
      ComboBoxFrom.Items.Add(m_ListProces.Strings[I]);
      ComboBoxTo.Items.Add(m_ListProces.Strings[I]);
    end;

  end;

end;

//----------------------------------------------------------------------------//

procedure TSearchAndCreateTab.IniSettings;
var
  Year, Month, Day: Word;
begin
  case m_BinColId of
    CSC_ProdDlvDate,CSC_PlanStartDate, CSC_LowStartTimeLimit
     ,CSC_SchedStart, CSC_HighEndLimit, CSC_LowStartDate : begin
                        EditFrom.Visible := false;
                        EditTo.Visible   := false;
                        ComboBoxTo.Visible   := false;
                        ComboBoxFrom.Visible   := false;
                        DecodeDate(Now, Year, Month, Day);
                        DatePickDelivDate_From.Visible := true;
                        DatePickDelivDate_To.Visible   := true;
                        DatePickDelivDate_From.Date := EncodeDate(Year, Month, Day);
                        DecodeDate(Now + DaysInYear(YearOf(Now))*2, Year, Month, Day);                        DatePickDelivDate_To.Date := EncodeDate(Year, Month, Day);
                      end;
      CSC_WkctCode, CSC_WkctProc : begin
                                     ComboBoxTo.Visible   := true;
                                     ComboBoxFrom.Visible := true;
                                   end;
      CSC_StepType, CSC_prodType : begin
                                     LBlTo.Visible := false;
                                     ComboBoxFrom.Visible := true;
                                   end
     else
       begin
         EditFrom.Visible := true;
         EditTo.Visible   := true;
         if (m_BinColId = CSC_ProdFamily) or (m_BinColId = CSC_ProdMatFamily) then
         begin
           LBlTo.Visible := false;
           EditTo.Visible   := false;
         end;
       end;
  end;

  Caption := _('Create Tab by ');

  case m_BinColId of
    CSC_ProdReq : caption := Caption + ' ' +  _('Production req.');
    CSC_ProdDlvDate : caption := Caption + ' ' +  _('Prod.req delivery date');
    CSC_PlanStartDate : caption := Caption + ' ' +  _('Planned start date');
    CSC_SchedStart    : caption := Caption + ' ' +  _('Actual start date');
    CSC_HighEndLimit  : caption := Caption + ' ' +  _('Latest ending date');
    CSC_LowStartTimeLimit : caption := Caption + ' ' + _('Earliest start date/time');
    CSC_LowStartDate      : caption := Caption + ' ' +  _('Production earliest date');
    CSC_WkctCode          : caption := Caption + ' ' +  _('Work center');
    CSC_WkctProc          : caption := Caption + ' ' +  _('Work center process');
    CSC_StepType          : caption := Caption + ' ' +  _('Step type');
    CSC_ProdType          : caption := Caption + ' ' +  _('Product type');
    CSC_ProdStep          : caption := Caption + ' ' +  _('Step');
    CSC_ProdSubStep       : caption := Caption + ' ' +  _('Sub Step');
    CSC_GroupNo           : caption := Caption + ' ' +  _('Group number');
    CSC_Rsc               : caption := Caption + ' ' +  _('resource');
    CSC_QtyToSched        : caption := Caption + ' ' +  _('Quantity {to} schedule');
    CSC_ProdFamily        : caption := Caption + ' ' +  _('Product family');
    CSC_ProdMatFamily     : caption := Caption + ' ' +  _('Material family');
  end;

end;

//----------------------------------------------------------------------------//

constructor TSearchAndCreateTab.SearchAndCreateTab(AOwner: TComponent;
  BinColId: CBinColId);
begin
  inherited create(Aowner);
  TranslateComponent(self);
  m_IsPropSearch := false;
  m_BinColId := BinColId;
  if (m_BinColId = CSC_WkctCode) then
     m_ListWC := TList.Create;
  if (m_BinColId = CSC_WkctProc) then
  begin
    m_ListWC     := TList.Create;
    m_ListProces := TStringList.Create;
  end;
  IniDate;
  IniSettings;
  ReShape(Self);
//  EditTabName.Text := _('Bin View');
end;

//----------------------------------------------------------------------------//

constructor TSearchAndCreateTab.SearchAndCreateTabByProp(AOwner: TComponent ; PropID : TPropID);
begin
  inherited create(Aowner);
  TranslateComponent(self);
  m_IsPropSearch := true;
  m_PropId := PropID;
  EditFrom.Visible := true;
  EditTo.Visible := true;
  Caption := _('Create Tab by');
  caption := Caption + ' ' + GetPropDescr(m_PropId);
  EditTabName.Text := _('Bin View');
  ReShape(Self);
end;

end.
