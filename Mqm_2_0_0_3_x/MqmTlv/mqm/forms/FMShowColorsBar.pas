unit FMShowColorsBar;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, ComCtrls, Buttons,UMCompat,gnugettext,
  UMSchedContFunc,Menus,UMglobal,DMSrvPC, UReSHape, System.UITypes, Vcl.Mask;

type
  TShowColor = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    EditValTo: TLabeledEdit;
    EditValFrom: TLabeledEdit;
    BitBtn3: TBitBtn;
    DrawGridDefined: TDrawGrid;
    PopupMenu1: TPopupMenu;
    PopUpEdit: TMenuItem;
    PopUpDelete: TMenuItem;
    BitBtn4: TBitBtn;
    Shape2: TShape;
    Label1: TLabel;
    BitBtn1: TcxButton;
    BitBtAbort: TcxButton;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure DrawGridDefinedDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PopUpEditClick(Sender: TObject);
    procedure PopUpDeleteClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure EditValFromKeyPress(Sender: TObject; var Key: WideChar);
    procedure EditValToKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtAbortClick(Sender: TObject);
  private
    m_Pid : TPropId;
    m_DftColor : Integer;
    m_AlfaCode : boolean;
//    m_ChoosedColor : boolean;
    m_CurrentPropList,m_SavedSetColorList : TList;
    { Private declarations }
    function CheckValuesExist : boolean;
    procedure IniFormDftColor;
    procedure UpdateDisplayedPropList(P_Id : TPropId);
    procedure SaveToDb;
  public
    constructor CreateSetColorForm(AOwner: Tcomponent; PropId : TPropId);
    destructor  Destroy; override;
    { Public declarations }
  end;

  procedure FillColorPropDisplayList(P_ID : TPropID);
  function  FindColorInDisplayedPropList(Id : TSchedID) : TColor;
  function  FindPropIdInDisplayedPropList : TPropID;
  procedure LoadPropShowColorData;

  procedure FillColorPropDisplayListActivTab(P_ID : TPropID);
  function  FindColorInDisplayedPropListActivTab(Id : TSchedID) : TColor;
  function  FindPropIdInDisplayedPropListActivTab : TPropID;

  procedure FillColorDinamicPropDisplayList(P_ID : TPropID; ListOfVals : TStringList);
  function  FindColorInDynamicListPropValues(id: TSchedID) : TColor;

  function  GetColorPropFromPropID(P_ID : TPropID; jobPropVal : string; var Color : TColor) : boolean;

implementation

uses UMCompatSrv, UMObjCont, UMTblDesc, UMCommon;
{$R *.dfm}

type

  TPropColorValue = record
    PropID   :      TPropID;
    ValFrom  :      string;
    ValTo    :      string;
    ColorVal :      TColor;
    DftColorVar :   Integer;
  end;
  PTPropColorValue = ^TPropColorValue;

  TPropDinamicColorValue = record
    PropID     :      TPropID;
    PropValue  :      string;
    ColorVal   :      TColor;
  end;
  PTPropDinamicColorValue = ^TPropDinamicColorValue;

var
  m_PropertiesColorList : TList;
  m_ColorPropListForDisplayedJob : TList;
  m_ColorPropListForDisplayedJobActivTab : TList;
  m_ColorDinamicPropListForDisplayedJob : TList;

//----------------------------------------------------------------------------//

function SortPropVal(Item1, Item2: Pointer): Integer;
begin
  if StrToInt(PTPropColorValue(Item1).ValFrom) < StrToInt(PTPropColorValue(Item2).ValFrom) then
    Result := -1
  else if StrToInt(PTPropColorValue(Item1).ValFrom) > StrToInt(PTPropColorValue(Item2).ValFrom) then
    Result := 1
  else
    Result := 0;
end;

//----------------------------------------------------------------------------//

function SortPropValAlpha(Item1, Item2: Pointer): Integer;
begin
  if PTPropColorValue(Item1).ValFrom < PTPropColorValue(Item2).ValFrom then
    Result := -1
  else if PTPropColorValue(Item1).ValFrom > PTPropColorValue(Item2).ValFrom then
    Result := 1
  else
    Result := 0;
end;

//----------------------------------------------------------------------------//

function ExistInList(PropertiesColorList : TList; P_id : TPropID; ValFrom : string; ValTo : string): boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to PropertiesColorList.Count - 1 do
  begin
    if (PTPropColorValue(PropertiesColorList[I]).PropID = P_id) and
       (PTPropColorValue(PropertiesColorList[I]).ValFrom = ValFrom) and
       (PTPropColorValue(PropertiesColorList[I]).ValTo = ValTo) then
    begin
      Result := true;
      Exit
    end;
  end;
end;

//----------------------------------------------------------------------------//

constructor TShowColor.CreateSetColorForm(AOwner: Tcomponent; PropId : TPropId);
var
  I : Integer;
  PropColorValue : PTPropColorValue;
begin
  inherited create(AOwner);
  ModalResult := mrNone;
  m_CurrentPropList := TList.Create;
  m_SavedSetColorList := TList.Create;
  m_SavedSetColorList.Clear;

  for I := m_PropertiesColorList.Count - 1 downto 0 do
  begin
    if (PTPropColorValue(m_PropertiesColorList[I]).PropID = PropId) then
    begin
      m_CurrentPropList.Add(PTPropColorValue(m_PropertiesColorList[I]));
      m_PropertiesColorList.Remove(PTPropColorValue(m_PropertiesColorList[I]));
    end;
  end;

  for I := 0 to m_CurrentPropList.Count - 1 do
  begin
    if not ExistInList(m_SavedSetColorList, PTPropColorValue(m_CurrentPropList[I]).PropID,
                       PTPropColorValue(m_CurrentPropList[I]).ValFrom,PTPropColorValue(m_CurrentPropList[I]).ValTo) then
    begin
      New(PropColorValue);
      PropColorValue.PropID        := PTPropColorValue(m_CurrentPropList[I]).PropID;
      PropColorValue.ValFrom       := PTPropColorValue(m_CurrentPropList[I]).ValFrom;
      PropColorValue.ValTo         := PTPropColorValue(m_CurrentPropList[I]).ValTo;
      PropColorValue.ColorVal      := PTPropColorValue(m_CurrentPropList[I]).ColorVal;
      PropColorValue.DftColorVar   := PTPropColorValue(m_CurrentPropList[I]).DftColorVar;
      m_SavedSetColorList.add(PropColorValue);
    end;
  end;

  Caption := _('Set Color') + '- ' + GetPropCodeFromID(PropId) + ' ' + GetPropDescr(PropId);
  m_Pid   := PropId;
  IniFormDftColor;
  m_AlfaCode := IsPropAlpha(m_Pid);
end;

//----------------------------------------------------------------------------//

function TShowColor.CheckValuesExist : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to m_CurrentPropList.count - 1 do
  begin
    if not m_AlfaCode then
    begin
      if ((StrToInt(EditValFrom.Text) >= StrToInt(PTPropColorValue(m_CurrentPropList[I]).ValFrom)) and
         (StrToInt(EditValFrom.Text) <= StrToInt(PTPropColorValue(m_CurrentPropList[I]).ValTo))) or

         ((StrToInt(EditValTo.Text) >= StrToInt(PTPropColorValue(m_CurrentPropList[I]).ValFrom)) and
         (StrToInt(EditValTo.Text) <= StrToInt(PTPropColorValue(m_CurrentPropList[I]).ValTo))) or

         ((StrToInt(EditValFrom.Text) < StrToInt(PTPropColorValue(m_CurrentPropList[I]).ValFrom)) and
         (StrToInt(EditValTo.Text) > StrToInt(PTPropColorValue(m_CurrentPropList[I]).ValTo))) then
      begin
        result := true;
        exit;
      end;
    end
    else
    begin
      if ((EditValFrom.Text >= PTPropColorValue(m_CurrentPropList[I]).ValFrom) and
         (EditValFrom.Text <= PTPropColorValue(m_CurrentPropList[I]).ValTo)) or

         ((EditValTo.Text >= PTPropColorValue(m_CurrentPropList[I]).ValFrom) and
         (EditValTo.Text  <= PTPropColorValue(m_CurrentPropList[I]).ValTo)) or

         ((EditValFrom.Text < PTPropColorValue(m_CurrentPropList[I]).ValFrom) and
         (EditValTo.Text > PTPropColorValue(m_CurrentPropList[I]).ValTo)) then
      begin
        Result := true;
        exit;
      end;
    end;

  end;

end;

//----------------------------------------------------------------------------//

procedure TShowColor.IniFormDftColor;
var
  I : Integer;
begin
  if m_CurrentPropList.Count = 0 then
  begin
    m_DftColor := ClSilver;
    Shape2.Brush.Color := ClSilver;
  end
  else
  for I := 0 to m_CurrentPropList.Count - 1 do
  begin
    Shape2.Brush.Color := PTPropColorValue(m_CurrentPropList[I]).DftColorVar;
    exit
  end;

end;

//----------------------------------------------------------------------------//

procedure TShowColor.UpdateDisplayedPropList(P_Id : TPropId);
begin
  if m_ColorPropListForDisplayedJob.Count > 0 then
    if PTPropColorValue(m_ColorPropListForDisplayedJob[0]).PropID = P_Id then
       FillColorPropDisplayList(P_Id);
end;

//----------------------------------------------------------------------------//

procedure TShowColor.FormCreate(Sender: TObject);
begin
  if m_CurrentPropList.Count = 0 then
    DrawGridDefined.RowCount := 2
  else DrawGridDefined.RowCount := m_CurrentPropList.Count + 1;
  if m_AlfaCode then
    m_CurrentPropList.Sort(SortPropValAlpha)
  else
   m_CurrentPropList.Sort(SortPropVal);

   ReShape(Self);
//   ReShape(BitBtn1);
//   ReShape(BitBtAbort);
end;

//----------------------------------------------------------------------------//

procedure TShowColor.BitBtAbortClick(Sender: TObject);
Var
  I : Integer;
  PropColorValue : PTPropColorValue;
begin
 { for I := 0 to m_SavedSetColorList.Count - 1 do
  begin
    New(PropColorValue);
    PropColorValue.PropID        := PTPropColorValue(m_SavedSetColorList[I]).PropID;
    PropColorValue.ValFrom       := PTPropColorValue(m_SavedSetColorList[I]).ValFrom;
    PropColorValue.ValTo         := PTPropColorValue(m_SavedSetColorList[I]).ValTo;
    PropColorValue.ColorVal      := PTPropColorValue(m_SavedSetColorList[I]).ColorVal;
    PropColorValue.DftColorVar   := PTPropColorValue(m_SavedSetColorList[I]).DftColorVar;
    m_PropertiesColorList.add(PropColorValue);
  end;
  m_SavedSetColorList.Free;    }
  modalresult := mrCancel;
  close;
end;

//----------------------------------------------------------------------------//

procedure TShowColor.BitBtn3Click(Sender: TObject);
var
  ColorDialog : TColorDialog;
  PropColorValue : PTPropColorValue;
begin
  if EditValTo.Text = '' then
  begin
    if EditValFrom.Text = '' then
       exit
    else
      EditValTo.Text := EditValFrom.Text;
  end
  else if (EditValTo.Text <> '') and (EditValFrom.Text = '') then
     exit
  else
  begin
    if not m_AlfaCode then
    begin
      if StrToInt(EditValFrom.Text) > StrToInt(EditValTo.Text) then
      begin
        ShowMessage(_('Value From is bigger from Value To'));
        exit;
      end;
    end
    else
      if EditValFrom.Text > EditValTo.Text then
      begin
        ShowMessage(_('Value From is bigger from Value To'));
        exit;
      end;
  end;

  ColorDialog := TColorDialog.create(self);

  if ColorDialog.Execute then
  begin
    Shape1.Brush.Color := ColorDialog.Color;

    new(PropColorValue);
    PropColorValue.PropID   := m_Pid;
    PropColorValue.ValFrom  := EditValFrom.Text;
    PropColorValue.ValTo    := EditValTo.Text;
    PropColorValue.ColorVal := Shape1.Brush.Color;
    PropColorValue.DftColorVar := Shape2.Brush.Color;
    if not CheckValuesExist then
    begin
//      m_ChoosedColor := true;
      m_CurrentPropList.Add(PropColorValue);
      DrawGridDefined.RowCount := m_CurrentPropList.Count + 1;
      DrawGridDefined.Invalidate;
    end
    else
    begin
//      m_ChoosedColor := false;
      showmessage(_('Values already exist'));
    end;
  end;

  if m_AlfaCode then
    m_CurrentPropList.Sort(SortPropValAlpha)
  else
   m_CurrentPropList.Sort(SortPropVal);

  EditValTo.Text := '';
  EditValFrom.Text := '';

  ColorDialog.free;
end;

//----------------------------------------------------------------------------//

destructor TShowColor.Destroy;
begin
  m_CurrentPropList.Clear;
  m_CurrentPropList.Free;
  inherited destroy;
end;

//----------------------------------------------------------------------------//

procedure TShowColor.DrawGridDefinedDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  try
  if ARow = 0 then
  begin
    case ACol of
      0: DrawGridDefined.Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + _('Value From'));
      1: DrawGridDefined.Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + _('Value To'));
      2: DrawGridDefined.Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + _('Color'));
    end;
  end else
  begin
    case ACol of
      0: begin
         if m_CurrentPropList.Count = 0 then exit;
         DrawGridDefined.Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + PTPropColorValue(m_CurrentPropList[Arow - 1]).ValFrom);
         end;
      1: begin
           if m_CurrentPropList.Count = 0 then exit;
           DrawGridDefined.Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + PTPropColorValue(m_CurrentPropList[Arow - 1]).ValTo);
         end;
      2: begin
           if m_CurrentPropList.Count = 0 then exit;
           DrawGridDefined.Canvas.Brush.Color := PTPropColorValue(m_CurrentPropList[Arow - 1]).ColorVal;  //m_TmpColorArray[ARow - 1].txt;
           DrawGridDefined.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2, Rect.Right - 2, Rect.Bottom - 2, 3, 3);
         end;
      3: begin

         end;

      4: begin
         end;

    end;
  end

  except
    DrawGridDefined.Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + PTPropColorValue(m_CurrentPropList[Arow - 1]).ValFrom);
  end;

end;

//----------------------------------------------------------------------------//

procedure TShowColor.FormClose(Sender: TObject; var Action: TCloseAction);
    Var
  I : Integer;
  PropColorValue : PTPropColorValue;
begin
  if (ModalResult = mrCancel) then
  begin
    for I := 0 to m_SavedSetColorList.Count - 1 do
    begin
      New(PropColorValue);
      PropColorValue.PropID        := PTPropColorValue(m_SavedSetColorList[I]).PropID;
      PropColorValue.ValFrom       := PTPropColorValue(m_SavedSetColorList[I]).ValFrom;
      PropColorValue.ValTo         := PTPropColorValue(m_SavedSetColorList[I]).ValTo;
      PropColorValue.ColorVal      := PTPropColorValue(m_SavedSetColorList[I]).ColorVal;
      PropColorValue.DftColorVar   := PTPropColorValue(m_SavedSetColorList[I]).DftColorVar;
      m_PropertiesColorList.add(PropColorValue);
    end;
      m_SavedSetColorList.Free;
  end;
  Action := caFree;
end;

//----------------------------------------------------------------------------//

procedure TShowColor.PopUpEditClick(Sender: TObject);
var
  ColorDialog : TColorDialog;
begin
  ColorDialog := TColorDialog.create(self);
  if ColorDialog.Execute then
  begin
    PTPropColorValue(m_CurrentPropList[DrawGridDefined.row - 1]).ColorVal := ColorDialog.Color;
    DrawGridDefined.Refresh;
    DrawGridDefined.Invalidate;
  end
  else
    Exit;
end;

//----------------------------------------------------------------------------//

procedure TShowColor.PopUpDeleteClick(Sender: TObject);
begin
  m_CurrentPropList.Remove(m_CurrentPropList[DrawGridDefined.row - 1]);

  if m_CurrentPropList.Count = 0 then
    DrawGridDefined.RowCount := 2
  else
    DrawGridDefined.RowCount := m_CurrentPropList.Count + 1;
  DrawGridDefined.Refresh;
  DrawGridDefined.Invalidate;
end;

//----------------------------------------------------------------------------//

procedure TShowColor.PopupMenu1Popup(Sender: TObject);
var
  I : Integer;
begin
  if m_CurrentPropList.Count = 0 then
  begin
    for I := 0 to PopupMenu1.Items.Count - 1 do
      PopupMenu1.Items[I].Enabled := false;
  end
  else
    for I := 0 to PopupMenu1.Items.Count - 1 do
      PopupMenu1.Items[I].Enabled := true;
end;

//----------------------------------------------------------------------------//

procedure TShowColor.SaveToDb;
var
  I : Integer;
  PropColorValue : PTPropColorValue;
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
  TempList : TList;
begin
  TempList := TList.Create;
  tbInfo := @tblInfo[tbl_cfg_Prop_Show_Color];
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  with qry.sql do
  begin
    Clear;
    Add('Delete from ' + tbInfo.GetTableName);
    Add(' Where ');
    Add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    Add( 'And' );
    Add(CreateFld(tbInfo.pfx, fli_PropertyCode) + '=''' + GetPropCodeFromID(m_Pid) + '''');
    Add(AND_IDF_Condition(CreateFld(TbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;

    Clear;
    Add('insert into ' + tbInfo.GetTableName + '(');
    Add(CreateFld(tbInfo.pfx,fli_Identifier) + ',');
    Add(CreateFld(tbInfo.pfx,fli_wkstCode) + ',');
    Add(CreateFld(tbInfo.pfx,fli_PropertyCode) + ',');
    Add(CreateFld(tbInfo.pfx,fli_PropValFrom) + ',');
    Add(CreateFld(tbInfo.pfx,fli_PropValTo) + ',');
    Add(CreateFld(tbInfo.pfx,fli_JobPropColor) + ',');
    Add(CreateFld(tbInfo.pfx,fli_DftColor) + ')');

    qry.SQL.Add(' values (');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_Identifier) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_wkstCode) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_PropertyCode) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_PropValFrom) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_PropValTo) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_JobPropColor) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_DftColor));
    qry.SQL.Add(')');

    for I  := 0 to m_CurrentPropList.Count - 1 do
    begin
      PropColorValue := PTPropColorValue(m_CurrentPropList[I]);
      if ExistInList(TempList,PropColorValue.PropID,PropColorValue.ValFrom,PropColorValue.ValTo) then
        continue;

      qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString      := IniAppGlobals.Identifier;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_wkstCode)).AsString      := IniAppGlobals.WkstCode;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString  := GetPropCodeFromID(PropColorValue.PropID);
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropValFrom)).AsString       := PropColorValue.ValFrom;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropValTo)).AsString         :=   PropColorValue.ValTo;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_JobPropColor)).AsInteger := PropColorValue.ColorVal;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_DftColor)).AsInteger     := PropColorValue.DftColorVar;
      qry.ExecSQL;
      TempList.Add(PropColorValue);
    end;

  end;
  Qry.transaction.commit;
  TempList.Clear;
  TempList.free;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure TShowColor.BitBtn4Click(Sender: TObject);
var
  ColorDialog : TColorDialog;
  I : Integer;
begin
  ColorDialog := TColorDialog.create(self);
  if ColorDialog.Execute then
  begin
    Shape2.Brush.Color := ColorDialog.Color;
    for I := 0 to m_CurrentPropList.Count - 1 do
    begin
      PTPropColorValue(m_CurrentPropList[I]).DftColorVar := ColorDialog.Color;
    end;

    for I := 0 to m_PropertiesColorList.Count - 1 do
    begin
      if (PTPropColorValue(m_PropertiesColorList[I]).PropID = m_Pid) then
         PTPropColorValue(m_PropertiesColorList[I]).DftColorVar := ColorDialog.Color;
    end;
  end;


end;

//----------------------------------------------------------------------------//

procedure TShowColor.EditValFromKeyPress(Sender: TObject; var Key: WideChar);
begin
  if not m_AlfaCode then
    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24))) then
      abort;
 // Old delphi 7 :
//  if not ((Key in ['0'..'9']) or (key = chr(vk_Back)) or (Key = chr(24))) then
end;

//----------------------------------------------------------------------------//

procedure TShowColor.EditValToKeyPress(Sender: TObject; var Key: Char);
begin
  if not m_AlfaCode then
    if not ((CharInSet(Key , ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24))) then
      abort;
end;

//----------------------------------------------------------------------------//

procedure FillColorPropDisplayList(P_ID : TPropID);
var
  I : Integer;
begin
  m_ColorPropListForDisplayedJob.Clear;
  for I := 0 to m_PropertiesColorList.Count - 1 do
  begin
    if (PTPropColorValue(m_PropertiesColorList[I]).PropID = P_ID) then
      m_ColorPropListForDisplayedJob.Add(PTPropColorValue(m_PropertiesColorList[I]));
  end;
end;

//----------------------------------------------------------------------------//

procedure FillColorDinamicPropDisplayList(P_ID : TPropID; ListOfVals : TStringList);
var
  I, J : Integer;
  PropDinamicColorValue : PTPropDinamicColorValue;
begin
  for I  := m_ColorDinamicPropListForDisplayedJob.Count -1 downto 0 do
    Dispose(PTPropDinamicColorValue(m_ColorDinamicPropListForDisplayedJob[I]));
  m_ColorDinamicPropListForDisplayedJob.Clear;

  J := 0;
  for I := 0 to ListOfVals.Count - 1 do
  begin
    new(PropDinamicColorValue);
    PropDinamicColorValue.PropID    := P_ID;
    PropDinamicColorValue.PropValue := ListOfVals.Strings[I];


    m_ColorDinamicPropListForDisplayedJob.Add(PropDinamicColorValue);

    case J of
      0 : PropDinamicColorValue.ColorVal := 9084916;
      1 : PropDinamicColorValue.ColorVal := 9367780;
      2 : PropDinamicColorValue.ColorVal := 8454016;
      3 : PropDinamicColorValue.ColorVal := 7124808;
      4 : PropDinamicColorValue.ColorVal := 16777088;
      5 : PropDinamicColorValue.ColorVal := 16744448;
      6 : PropDinamicColorValue.ColorVal := 12615935;
      7 : PropDinamicColorValue.ColorVal := 15439072;
      8 : PropDinamicColorValue.ColorVal := 2246621;
      9 : PropDinamicColorValue.ColorVal := 65535;
      10 : PropDinamicColorValue.ColorVal := 65408;
      11 : PropDinamicColorValue.ColorVal := 12123394;
      12 : PropDinamicColorValue.ColorVal := 16776960;
      13 : PropDinamicColorValue.ColorVal := 12615680;
      14 : PropDinamicColorValue.ColorVal := 12615808;
      15 : PropDinamicColorValue.ColorVal := 16711935;
      16 : PropDinamicColorValue.ColorVal := 4210816;
      17 : PropDinamicColorValue.ColorVal := 4227327;
      18 : PropDinamicColorValue.ColorVal := 65280;
      19 : PropDinamicColorValue.ColorVal := 8421376;
      20 : PropDinamicColorValue.ColorVal := 8404992;
      21 : PropDinamicColorValue.ColorVal := 16744576;
      22 : PropDinamicColorValue.ColorVal := 4194432;
      23 : PropDinamicColorValue.ColorVal := 7801207;
      24 : PropDinamicColorValue.ColorVal := 7810769;
      25 : PropDinamicColorValue.ColorVal := 128;
      26 : PropDinamicColorValue.ColorVal := 33023;
      27 : PropDinamicColorValue.ColorVal := 228461;
      28 : PropDinamicColorValue.ColorVal := 8023813;
      29 : PropDinamicColorValue.ColorVal := 13826965;
      30 : PropDinamicColorValue.ColorVal := 16544515;
      31 : PropDinamicColorValue.ColorVal := 10485760;
      32 : PropDinamicColorValue.ColorVal := 8388736;
      33 : PropDinamicColorValue.ColorVal := 16711808;
      34 : PropDinamicColorValue.ColorVal := 16512;
      35 : PropDinamicColorValue.ColorVal := 8388608;
      36 : PropDinamicColorValue.ColorVal := 32896;
      37 : PropDinamicColorValue.ColorVal := 8421504;
      38 : PropDinamicColorValue.ColorVal := 8421440;
      39 : PropDinamicColorValue.ColorVal := 12632256;
      40 : PropDinamicColorValue.ColorVal := 7168082;
      41 : PropDinamicColorValue.ColorVal := 8070873;
      42 : PropDinamicColorValue.ColorVal := 11843591;
      43 : PropDinamicColorValue.ColorVal := 161661;
      44 : PropDinamicColorValue.ColorVal := 10193143;
      45 : PropDinamicColorValue.ColorVal := 290299;
      46 : PropDinamicColorValue.ColorVal := 13612465;
      47 : PropDinamicColorValue.ColorVal := 8023813;
      48 : PropDinamicColorValue.ColorVal := 16777156;
      49 : PropDinamicColorValue.ColorVal := 16766935
        else PropDinamicColorValue.ColorVal := 9084916;
    end;
    inc(J);
    if J = 49 then J := 0;

  end;
end;

//----------------------------------------------------------------------------//

function FindColorInDisplayedPropList(Id : TSchedID) : Tcolor;
var
  prop : TProperties;
  I, J    : Integer;
  pId     : TPropId;
  PropRscCode: string;
  jobPropVal,TestedVal : variant;
begin

  if m_ColorPropListForDisplayedJobActivTab.Count > 0 then//if m_ColorPropListForDisplayedJob.Count > 0 then
  begin
    prop := p_sc.GetProperties(id, nil);
    for I := 0 to prop.p_PropCount - 1 do
    begin
      prop.GetProperty(i, pId, PropRscCode);
      begin
        if (PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[0]).PropID = pId) then//if (PTPropColorValue(m_ColorPropListForDisplayedJob[0]).PropID = pId) then
        begin
          jobPropVal := prop.GetProperty(i, pId, PropRscCode);

          if IsPropDynamic(pId) then
          begin
            p_sc.GetPropVal(Id,pId,TestedVal);
            if (TestedVal = jobPropVal) then
            begin
              jobPropVal := p_sc.GetPropDinamicVal(Id,jobPropVal);
              jobPropVal := round(jobPropVal);
            end;
          end;

          //Result := PTPropColorValue(m_ColorPropListForDisplayedJob[0]).DftColorVar;
          Result := PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[0]).DftColorVar;
          //for J := 0 to m_ColorPropListForDisplayedJob.Count - 1 do
          for J := 0 to m_ColorPropListForDisplayedJobActivTab.Count - 1 do
          begin
           { if (jobPropVal >= PTPropColorValue(m_ColorPropListForDisplayedJob[J]).ValFrom) and
               (jobPropVal <= PTPropColorValue(m_ColorPropListForDisplayedJob[J]).ValTo) then
            begin
              Result := PTPropColorValue(m_ColorPropListForDisplayedJob[J]).ColorVal;
              exit
            end;   }
             if (jobPropVal >= PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[J]).ValFrom) and
               (jobPropVal <= PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[J]).ValTo) then
            begin
              Result := PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[J]).ColorVal;
              exit
            end; 
          end;
        end
      end;
    end;

  end;

  if Result = 0 then
    Result := ClSilver;
  

end;

//----------------------------------------------------------------------------//

function FindPropIdInDisplayedPropList : TPropID;
begin
  Result := nil;
  if m_ColorPropListForDisplayedJob.Count > 0 then
     Result := PTPropColorValue(m_ColorPropListForDisplayedJob[0]).PropID;
end;

//----------------------------------------------------------------------------//

function FindColorInDynamicListPropValues(id : TSchedID) : TColor;
var
  prop : TProperties;
  I, J    : Integer;
  pId     : TPropId;
  PropRscCode: string;
  jobPropVal,TestedVal : variant;
begin
  Result := ClSilver;
  if m_ColorDinamicPropListForDisplayedJob.Count > 0 then
  begin
    prop := p_sc.GetProperties(id, nil);
    for I := 0 to prop.p_PropCount - 1 do
    begin
      prop.GetProperty(I, pId, PropRscCode);
      begin
        if (PTPropDinamicColorValue(m_ColorDinamicPropListForDisplayedJob[0]).PropID = pId) then
        begin
          jobPropVal := prop.GetProperty(I, pId, PropRscCode);

          if IsPropDynamic(pId) then
          begin
            p_sc.GetPropVal(Id,pId,TestedVal);
            if (TestedVal = jobPropVal) then
            begin
              jobPropVal := p_sc.GetPropDinamicVal(Id,jobPropVal);
              jobPropVal := round(jobPropVal);
            end;
          end;

          for J := 0 to m_ColorDinamicPropListForDisplayedJob.Count - 1 do
          begin
            if jobPropVal = PTPropDinamicColorValue(m_ColorDinamicPropListForDisplayedJob[J]).PropValue then
            begin
              Result := PTPropDinamicColorValue(m_ColorDinamicPropListForDisplayedJob[J]).ColorVal;
              exit
            end;
          end;
        end
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function GetColorPropFromPropID(P_ID : TPropID; jobPropVal : string; var Color : TColor) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to m_PropertiesColorList.Count - 1 do
  begin
    if (PTPropColorValue(m_PropertiesColorList[I]).PropID = P_ID) then
    begin
      if (jobPropVal >= PTPropColorValue(m_PropertiesColorList[I]).ValFrom) and
        (jobPropVal <= PTPropColorValue(m_PropertiesColorList[I]).ValTo) then
      begin
        Result := true;
        Color := PTPropColorValue(m_PropertiesColorList[I]).ColorVal;
        exit
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure LoadPropShowColorData;
var
  tbInfo : ^TTblInfo;
  P_Id   : TPropID;
  PropColorValue : PTPropColorValue;
  qry: TMqmQuery;
begin
  qry := CreateQuery(Cfg_DB);

  with qry do
  begin
    tbInfo := @tblInfo[tbl_cfg_Prop_Show_Color];
    SQL.Clear;
    SQL.Add('select * from ' + tbInfo.GetTablename);
    SQL.Add(' where ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(TbInfo.pfx, fli_Identifier)));
    SQL.Add(' Order by ' + CreateFld(tbInfo.pfx, fli_PropertyCode));
    Open;
    while not EOF do
    begin
      Application.ProcessMessages;
      P_Id := GetIdFromCode(fieldByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString);
      if (P_Id <> nil) then
      begin
        if not ExistInList(m_PropertiesColorList, P_Id, fieldByName(CreateFld(tbInfo.pfx,fli_PropValFrom)).AsString,
                                 fieldByName(CreateFld(tbInfo.pfx,fli_PropValTo)).AsString) then
        begin
          new(PropColorValue);
          Application.ProcessMessages;
          PropColorValue.PropID  := P_Id;
          PropColorValue.ValFrom := fieldByName(CreateFld(tbInfo.pfx,fli_PropValFrom)).AsString;
          PropColorValue.ValTo   := fieldByName(CreateFld(tbInfo.pfx,fli_PropValTo)).AsString;

          if IniAppglobals.ShowPropColor_Standart_RGB = '1' then
            PropColorValue.ColorVal := BGRtoRGB(TColor(fieldByName(CreateFld(tbInfo.pfx,fli_JobPropColor)).AsInteger))
          else
            PropColorValue.ColorVal := TColor(fieldByName(CreateFld(tbInfo.pfx,fli_JobPropColor)).AsInteger);
          PropColorValue.DftColorVar := TColor(fieldByName(CreateFld(tbInfo.pfx,fli_DftColor)).AsInteger);
          m_PropertiesColorList.Add(PropColorValue);
        end;
      end;
      Next;
    end;
    Close;
  end;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure FillColorPropDisplayListActivTab(P_ID : TPropID);
var
  I : Integer;
begin
  m_ColorPropListForDisplayedJobActivTab.Clear;
  for I := 0 to m_PropertiesColorList.Count - 1 do
  begin
    if (PTPropColorValue(m_PropertiesColorList[I]).PropID = P_ID) then
      m_ColorPropListForDisplayedJobActivTab.Add(PTPropColorValue(m_PropertiesColorList[I]));
  end;
end;

//----------------------------------------------------------------------------//

function FindColorInDisplayedPropListActivTab(Id : TSchedID) : TColor;
var
  prop : TProperties;
  I, J    : Integer;
  pId     : TPropId;
  PropRscCode: string;
  jobPropVal,TestedVal : variant;
begin
  Result := ClSilver;
  if m_ColorPropListForDisplayedJobActivTab.Count > 0 then
  begin
    prop := p_sc.GetProperties(id, nil);
    for I := 0 to prop.p_PropCount - 1 do
    begin
      prop.GetProperty(i, pId, PropRscCode);
      begin
        if (PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[0]).PropID = pId) then
        begin
          jobPropVal := prop.GetProperty(i, pId, PropRscCode);

          if IsPropDynamic(pId) then
          begin
            p_sc.GetPropVal(Id,pId,TestedVal);
            if (TestedVal = jobPropVal) then
            begin
              jobPropVal := p_sc.GetPropDinamicVal(Id,jobPropVal);
              jobPropVal := round(jobPropVal);
            end;
          end;

          Result := PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[0]).DftColorVar;
          for J := 0 to m_ColorPropListForDisplayedJobActivTab.Count - 1 do
          begin
            if (jobPropVal >= PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[J]).ValFrom) and
               (jobPropVal <= PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[J]).ValTo) then
            begin
              Result := PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[J]).ColorVal;
              exit
            end;
          end;
        end
      end;
    end;

  end;
end;

//----------------------------------------------------------------------------//

function FindPropIdInDisplayedPropListActivTab : TPropID;
begin
  Result := nil;
  if m_ColorPropListForDisplayedJobActivTab.Count > 0 then
    Result := PTPropColorValue(m_ColorPropListForDisplayedJobActivTab[0]).PropID;
end;

//----------------------------------------------------------------------------//

procedure TShowColor.BitBtn1Click(Sender: TObject);
var
  I : Integer;
begin
  modalResult := mrOk;
  for I := 0 to m_CurrentPropList.Count - 1 do
    m_PropertiesColorList.Add(PTPropColorValue(m_CurrentPropList[I]));

  for I := 0 to m_SavedSetColorList.Count - 1 do
    Dispose(PTPropColorValue(m_SavedSetColorList[I]));
  m_SavedSetColorList.Free;

  UpdateDisplayedPropList(m_Pid);
  //if m_CurrentPropList.Count > 0 then
    SaveToDb
end;

//----------------------------------------------------------------------------//

procedure ClearPropertiesColorList;
var
  I : Integer;
begin
  for I := m_PropertiesColorList.Count - 1 downto 0 do
    Dispose(PTPropColorValue(m_PropertiesColorList[I]));

  for I  := m_ColorDinamicPropListForDisplayedJob.Count -1 downto 0 do
    Dispose(PTPropDinamicColorValue(m_ColorDinamicPropListForDisplayedJob[I]));

  m_PropertiesColorList.Clear;
  m_ColorDinamicPropListForDisplayedJob.Clear;
end;

//----------------------------------------------------------------------------//

initialization

if not Assigned(m_PropertiesColorList) then
begin
  m_PropertiesColorList := TList.Create;
  m_ColorPropListForDisplayedJob := TList.Create;
  m_ColorPropListForDisplayedJobActivTab := TList.Create;
  m_ColorDinamicPropListForDisplayedJob := TList.Create;
end;

finalization

if Assigned(m_PropertiesColorList) then
begin
  ClearPropertiesColorList;
  m_PropertiesColorList.Free;
  m_ColorPropListForDisplayedJob.Free;
  m_ColorPropListForDisplayedJobActivTab.Free;
  m_ColorDinamicPropListForDisplayedJob.Free;
end


end.
