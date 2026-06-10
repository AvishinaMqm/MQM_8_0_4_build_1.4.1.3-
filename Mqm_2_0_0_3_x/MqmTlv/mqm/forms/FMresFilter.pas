unit FMresFilter;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, Buttons, ExtCtrls, CheckLst, UMPlan, UReShape,
  UMResCat,
  UMwkCtr, gnugettext;

type

  TFResFilter = class(TForm)
    Panel3: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Panel1: TPanel;
    LableName: TLabel;
    EditTabName: TEdit;
    Panel2: TPanel;
    CBSort: TComboBox;
    LabelSort: TLabel;
    Splitter1: TSplitter;
    CLBres: TCheckListBox;
    CLBcat: TCheckListBox;
    Splitter2: TSplitter;
    CLBwc: TCheckListBox;
    Splitter3: TSplitter;
    BtnAbo: TcxButton;
    BtnOk: TcxButton;
    CBResSelectdeselectAll: TCheckBox;
    CBWcSelectdeselectAll: TCheckBox;
    cbGroup: TComboBox;
    Label2: TLabel;
    procedure ExitMainClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure CLBresClickCheck(Sender: TObject);
    procedure CLBcatClickCheck(Sender: TObject);
    procedure CLBwcClickCheck(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
    procedure CBWcSelectdeselectAllClick(Sender: TObject);
    procedure CBResSelectdeselectAllClick(Sender: TObject);
    procedure cbGroupSelect(Sender: TObject);
  public
    function  GetResList : TList;
  private
    m_ListallRes: TList;
    m_LisWC : TList;
    m_SelResList: TList;
    m_IsEditMode: boolean;
    m_IsMcm : boolean;
    m_SlotGoup : Integer;
    sg : Integer;
    function EditResChecked(RscCode: string): boolean;
    function EditWCChecked(WCCode: string): boolean;
    procedure FillWcRsc;
    function  GetResIndexforWc(ResCode : String) : integer;
    procedure FilterRecForWkc(Remove: boolean; wkc: TMqmWrkCtr);
    procedure FilterRecForCateg(Remove : boolean; resCat: TMqmResCat);
    function  CheckActivCatBox(catRes: TMqmResCat): boolean;
    function  CheckActivWcBox(Wc : string) : boolean;
    function  SetResListChoosen : boolean;
    function  GetTabName : string;
    procedure LoadCaptions;
    Procedure RefillWCCategory;
    Procedure FillGroup;
  public
    constructor CreateFrmResFilter(AOwner: Tcomponent; IsMcm : boolean; PlanTabName : string);
    constructor EditFrmResFilter(AOwner: Tcomponent; TabName: string; WCList: TList; ResList: TList ; IsMcm : boolean);
    property    P_GetTabName : string read GetTabName;
    property    P_SlotGoup : Integer read m_SlotGoup;
  end;

implementation

uses
  UMRes,
  UMObjCont,
  UMglobal,
  UGglobal,
  FMMainPlan,
  UMPlanTbs;

{$R *.DFM}

//----------------------------------------------------------------------------//

constructor TFResFilter.CreateFrmResFilter(AOwner: Tcomponent; IsMcm : boolean; PlanTabName : string);
var i : Integer;
begin
  inherited create(AOwner);
  m_IsEditMode := false;
  m_IsMcm := IsMcm;
  EditTabName.Text := PlanTabName;

  label2.Visible := IsMcm;
  cbGroup.Visible := IsMcm;

  cbSort.Clear;
  if IsMcm then
  begin
    Caption := _('Work centers filter');
    labelSort.Visible := false;
    CBSort.Visible := false;
    CLBcat.Width := 1000;
    Splitter3.Visible := false;
    //StaticText2.Visible := false;
    StaticText3.Visible := false;
    //CLBres.Visible := false;
    CLBcat.Align := alLeft;
    sg := 0;

   { StaticText3.Visible := false;
    CLBres.Visible := false;
    CLBcat.Align := alLeft;

    CLBcat.Width := 1000;
    Splitter3.Visible := false;
    StaticText2.Visible := false;

    cbSort.AddItem('Work center', cbSort);
    cbSort.AddItem('W.c sequence and code', cbSort);
    cbSort.AddItem('W.c sequence decending and code', cbSort);

    labelSort.Caption := 'Work Center sequence:';   }
  end else
  begin
    Caption := _('Resources filter');
    cbSort.AddItem('Resource code', cbSort);
    cbSort.AddItem('Category and  resource code', cbSort);
    cbSort.AddItem('Work center', cbSort);
    cbSort.AddItem('Work center and resource code', cbSort);
    cbSort.AddItem('Work center category and resource', cbSort);

    labelSort.Caption := 'Default resource sequence:';

  end;

  m_SelResList := TList.Create;
  m_ListallRes := TList.Create;
  m_LisWC  := TList.Create;

    for I := 0 to p_pl.p_WrkCtrsCount - 1 do
     m_LisWC.Add(p_pl.p_WrkCtr[i]);
end;

//----------------------------------------------------------------------------//

constructor TFResFilter.EditFrmResFilter(AOwner: Tcomponent; TabName: string; WCList: TList; ResList: TList ; IsMcm : boolean);
var
  I : Integer;
begin
  inherited create(AOwner);
  CBResSelectdeselectAll.Visible := not IsMcm;
  StaticText3.Visible := not IsMcm;
  m_IsEditMode := true;
  m_IsMcm := IsMcm;
  EditTabName.Text := trim(TabName);

  label2.Visible := IsMcm;
  cbGroup.Visible := IsMcm;

  cbSort.Clear;
  if IsMcm then
  begin
    Caption := _('work centers filter');

    CLBres.Visible := false;
    CLBcat.Align := alLeft;

    CLBcat.Width := 1000;
    Splitter3.Visible := false;
    //StaticText2.Visible := false;
    CBSort.Visible := false;
    labelSort.Visible := False;
    sg :=  TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.GetActiveView).p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup;
    //cbSort.AddItem('Work center', cbSort);
    //cbSort.AddItem('W.c sequence and code', cbSort);
    //cbSort.AddItem('W.c sequence decending and code', cbSort);

   // labelSort.Caption := 'Work Center sequence:';
  end else
  begin
    cbSort.AddItem('Resource code', cbSort);
    cbSort.AddItem('Category and  resource code', cbSort);
    cbSort.AddItem('Work center', cbSort);
    cbSort.AddItem('Work center and resource code', cbSort);
    cbSort.AddItem('Work center category and resource', cbSort);

    labelSort.Caption := 'Default resource sequence:';

  end;

  m_SelResList := TList.Create;
  m_ListallRes := TList.Create;
  m_LisWC := TList.Create;

  for I := 0 to ResList.Count - 1 do
     m_SelResList.Add(ResList.Items[I]);

  for I := 0 to WCList.Count - 1 do
     m_LisWC.Add(WCList.Items[I]);
end;

//----------------------------------------------------------------------------//

function TFResFilter.EditWCChecked(WCCode: string): boolean;
var
  i: Integer;
begin
  Result := False;
  i := 0;
  while (not Result) and (i <= m_LisWC.count - 1) do begin
    Result := TMqmWrkCtr(m_LisWC[i]).p_WrkCtrCode = WCCode;
    i := i + 1;
  end;
end;

function TFResFilter.EditResChecked(RscCode: string): boolean;
var
  i: Integer;
begin
  Result := False;
  i := 0;
  while (not Result) and (i <= m_SelResList.count - 1) do begin
    Result := TMqmRes(m_SelResList[i]).p_ResCode = RscCode;
    i := i + 1;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.ExitMainClick(Sender: TObject);
begin
  Close
end;

Procedure TFResFilter.FillGroup;
var i, pos : Integer;
  WC:     TMqmWrkCtr;
begin
  cbGroup.Clear;
  cbGroup.Items.Add('No');
  for i := 0 to p_pl.p_WrkCtrsCount - 1 do
   begin
     WC := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
     if Trim(WC.P_WcGrp) <> '' then
     begin
      cbGroup.Items.Add('By Work center group');
      break
     end;
   end;

   for i := 0 to p_pl.p_WrkCtrsCount - 1 do
   begin
     WC := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
     if Trim(WC.p_PlantCode) <> '' then
     begin
      cbGroup.Items.Add('By Plant');
      break
     end;
   end;

   for i := 0 to p_pl.p_WrkCtrsCount - 1 do
   begin
     WC := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
     if Trim(WC.p_Division) <> '' then
     begin
      cbGroup.Items.Add('By Division');
      break
     end;
   end;

end;

//----------------------------------------------------------------------------//

procedure TFResFilter.LoadCaptions;
begin
 // Caption                := _('Resource filter'); // LngStr(S_000594);
  BtnOk.Caption          := _('OK');              // LngStr(S_000002); // OK
  BtnAbo.Caption         := _('Abort');           // LngStr(S_000001); // Abort
end;

function SortOnWcGrp(Item1, Item2: Pointer): Integer;
var
  Wc1 , Wc2 : TMqmWrkCtr;
begin
  Wc1 := TMqmWrkCtr(Item1);
  Wc2 := TMqmWrkCtr(Item2);

  result := 0;
  if Wc1.p_ReadOnly then
  begin
    if Wc2.p_ReadOnly then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if Wc2.p_ReadOnly then
  begin
    Result := -1;
    exit
  end;

  if Wc1.P_WcGrp < Wc2.P_WcGrp then
    Result := 1  // WC1 < WC2
  else if Wc1.P_WcGrp > Wc2.P_WcGrp then
    Result := -1   // WC1 > WC2
  else
    Result := 0;
end;

function SortOnWcPlant(Item1, Item2: Pointer): Integer;
var
  Wc1 , Wc2 : TMqmWrkCtr;
begin
  Wc1 := TMqmWrkCtr(Item1);
  Wc2 := TMqmWrkCtr(Item2);

  result := 0;
  if Wc1.p_ReadOnly then
  begin
    if Wc2.p_ReadOnly then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if Wc2.p_ReadOnly then
  begin
    Result := -1;
    exit
  end;

  if Wc1.p_PlantCode < Wc2.p_PlantCode then
    Result := 1  // WC1 < WC2
  else if Wc1.p_PlantCode > Wc2.p_PlantCode then
    Result := -1   // WC1 > WC2
  else
    Result := 0;
end;

function SortOnWcDivision(Item1, Item2: Pointer): Integer;
var
  Wc1 , Wc2 : TMqmWrkCtr;
begin
  Wc1 := TMqmWrkCtr(Item1);
  Wc2 := TMqmWrkCtr(Item2);

  result := 0;
  if Wc1.p_ReadOnly then
  begin
    if Wc2.p_ReadOnly then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if Wc2.p_ReadOnly then
  begin
    Result := -1;
    exit
  end;

  if Wc1.p_Division < Wc2.p_Division then
    Result := 1  // WC1 < WC2
  else if Wc1.p_Division > Wc2.p_Division then
    Result := -1   // WC1 > WC2
  else
    Result := 0;
end;

procedure TFResFilter.RefillWCCategory;
var i, y, pos, ItemIndex : Integer;
  WC:     TMqmWrkCtr;
begin
  CLBCat.Items.Clear;
  clbwc.Enabled := True;
  CBWcSelectdeselectAll.Enabled := True;

  if cbGroup.ItemIndex = -1 then
    cbGroup.ItemIndex := 0;

 { if cbGroup.Items[cbGroup.ItemIndex] = 'By Work center group' then
    p_pl.p_AllWrkCtr.Sort(SortOnWcGrp)
  else  if cbGroup.Items[cbGroup.ItemIndex] = 'By Plant' then
    p_pl.p_AllWrkCtr.Sort(SortOnWcPlant)
  else if cbGroup.Items[cbGroup.ItemIndex] = 'By Division' then
    p_pl.p_AllWrkCtr.Sort(SortOnWcDivision);  }

   for i := 0 to p_pl.p_WrkCtrsCount - 1 do
   begin
     WC := TMqmWrkCtr(p_pl.p_WrkCtr[i]);

     if cbGroup.Items[cbGroup.ItemIndex] = 'By Work center group' then
     begin
      if CLBCat.Items.IndexOf(WC.P_WcGrp) = -1 then
        if Trim(WC.P_WcGrp) <> '' then
        begin
          pos := CLBCat.Items.Add(WC.P_WcGrp);
          CLBCat.Checked[pos] := EditWcChecked(wc.p_WrkCtrCode);
        end;
     end else
     if cbGroup.Items[cbGroup.ItemIndex] = 'By Plant' then
     begin
      if CLBCat.Items.IndexOf(WC.p_PlantCode) = -1 then
        if Trim(WC.p_PlantCode) <> '' then
        begin
          pos := CLBCat.Items.Add(WC.p_PlantCode);
          CLBCat.Checked[pos] := EditWcChecked(wc.p_WrkCtrCode);
        end;
     end else
     if cbGroup.Items[cbGroup.ItemIndex] = 'By Division' then
     begin
      if CLBCat.Items.IndexOf(WC.p_Division) = -1 then
        if Trim(WC.p_Division) <> '' then
        begin
          pos := CLBCat.Items.Add(WC.p_Division);
          CLBCat.Checked[pos] := EditWcChecked(wc.p_WrkCtrCode);
        end;
     end;

   end;

   if cbGroup.ItemIndex = -1 then
    cbGroup.ItemIndex := 0;

   if cbGroup.Items[cbGroup.ItemIndex] <> 'No' then
   begin
    clbwc.CheckAll(cbChecked);
      for I := 0 to CLBwc.Items.Count - 1 do
      begin
         WC := TMqmWrkCtr(CLBwc.items.objects[I]);

         if m_LisWC.indexof(wc) = -1 then
         begin
          clbwc.Checked[i] := False;

          for y := 0 to wc.p_ResCount - 1 do
          begin
            ItemIndex := GetResIndexforWc(TMqmRes(wc.p_Res[y]).p_ResCode);
            if (ItemIndex = -1) then continue;
            CLBres.Checked[ItemIndex] := CLBwc.Checked[i];

          end;

          continue;
         end;

         if (WC.P_WcGrp = '') and (cbGroup.Items[cbGroup.ItemIndex] = 'By Work center group') then
          clbwc.Checked[i] := False
         else if (WC.p_PlantCode = '') and (cbGroup.Items[cbGroup.ItemIndex] = 'By Plant') then
          clbwc.Checked[i] := False
         else if (WC.p_Division = '') and (cbGroup.Items[cbGroup.ItemIndex] = 'By Division') then
          clbwc.Checked[i] := False;

          for y := 0 to wc.p_ResCount - 1 do
          begin
            ItemIndex := GetResIndexforWc(TMqmRes(wc.p_Res[y]).p_ResCode);
            if (ItemIndex = -1) then continue;
            CLBres.Checked[ItemIndex] := CLBwc.Checked[i];
          end;
      end;
    clbwc.Enabled := False;
    CBWcSelectdeselectAll.Enabled := False;
   end else
   begin
     clbwc.CheckAll(cbChecked);
     CLBres.CheckAll(cbChecked);
   end;

end;

//----------------------------------------------------------------------------//

procedure TFResFilter.FormCreate(Sender: TObject);
var i : Integer;
  Grptypename : String;
begin
  ScaleFormSize(self, Screen.PixelsPerInch);
//  BtnAbo.Left := Width - BtnAbo.Width - BtnOk.Width - 20;
//  BtnOk.Left := Width - BtnOk.Width - 15;
  TranslateComponent (self);
  LoadCaptions;

  FillWcRsc;


  if sg = 0 then
    Grptypename := 'No'
  else if sg = 1 then
    Grptypename := 'By Work center group'
  else if sg = 2 then
    Grptypename := 'By Plant'
  else if sg = 3 then
    Grptypename := 'By Division';

  if m_isMcm then //and m_IsEditMode then
  begin
    for i := 0 to cbGroup.Items.Count -1 do
    begin
      if cbGroup.Items[i] = Grptypename then
        cbGroup.ItemIndex := i;
    end;

    RefillWCCategory;
  end else
    cbGroup.ItemIndex := 0;

  ReShape(Self);
//  ReShape(BtnAbo);
//  ReShape(BtnOk);
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.FillWcRsc;
var
  I,J,K : Integer;
  pos:    integer;
  WC:     TMqmWrkCtr;
  Rsc:    TMqmRes;
  resCat: TMqmResCat;
begin

  for i := 0 to p_pl.p_WrkCtrsCount - 1 do
  begin
    WC := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
    if (WC.p_ReadOnly) and (not WC.p_Visible) then
      Continue;
    if WC.p_ReadOnly then
      pos := CLBwc.Items.Add(WC.p_WrkCtrSDesc + '(' + WC.p_WrkCtrCode + ')  (Read Only)')
    else
      pos := CLBwc.Items.Add(WC.p_WrkCtrSDesc + '(' + WC.p_WrkCtrCode + ')');
    CLBwc.Items.Objects[pos] := wc;

    if not m_IsMcm then
      CLBwc.Checked[pos] := not m_IsEditMode
    else
    begin
      if m_IsEditMode then
        CLBwc.Checked[pos] := EditWcChecked(WC.p_WrkCtrCode)
      else
        CLBwc.Checked[pos] := not m_IsEditMode;

    end;

    for J := 0 to WC.p_ResCount - 1 do
    begin
      Rsc := TMqmRes(WC.p_Res[J]);
      m_ListallRes.add(Rsc)
    end
  end;


  if not m_IsMcm then
  begin
    for k := 0 to p_pl.p_ResCatCount - 1 do
    begin
      resCat := TMqmResCat(p_pl.p_resCat[k]);
      pos := CLBcat.Items.Add(resCat.p_ResCatDesc + ' (' + resCat.p_ResCatCode + ')');
      CLBcat.Items.Objects[pos] := resCat;
      CLBcat.Checked[pos] := not m_IsEditMode;
    end;
  end else
  begin

    FillGroup;
    RefillWCCategory;

  end;

    for I := 0 to m_ListallRes.Count - 1 do
    begin
      Rsc := TMqmRes(m_ListallRes[I]);
      pos := CLBres.Items.Add(Rsc.p_ResCode + '    ' + Rsc.p_ResSDesc);
      CLBres.Items.Objects[pos] := Rsc;
      CLBres.Checked[I] := (not m_IsEditMode) or (EditResChecked(Rsc.p_ResCode));
    end;


end;

//----------------------------------------------------------------------------//

function TFResFilter.GetResIndexforWc(ResCode : String) : integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to m_ListallRes.count - 1 do
  begin
    if ResCode = TMqmRes(m_ListallRes[I]).p_ResCode then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.FilterRecForWkc(Remove: boolean; wkc: TMqmWrkCtr);
var
 I, ItemIndex : Integer;
begin
  for I := 0 to wkc.p_ResCount - 1 do
  begin
    if not CheckActivCatBox(TMqmRes(wkc.p_Res[I]).p_ResCat) then
      continue;
    ItemIndex := GetResIndexforWc(TMqmRes(wkc.p_Res[I]).p_ResCode);
    if (ItemIndex = -1) then continue;
    CLBres.Checked[ItemIndex] := Remove;

  end;
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.FilterRecForCateg(Remove: boolean; resCat: TMqmResCat);
var
  i:   integer;
  Rsc: TMqmRes;
begin
  if m_ListallRes.Count = 0 then exit;

  for I := 0 to m_ListallRes.Count - 1 do
  begin
    Rsc := TMqmRes(m_ListallRes[I]);
    if not CheckActivWcBox(TMqmWrkCtr(Rsc.p_Father).p_WrkCtrCode) then continue;

    if Rsc.p_ResCat = resCat then
        CLBres.Checked[I] := Remove
  end
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.CBResSelectdeselectAllClick(Sender: TObject);
var
  I : Integer;
  clb: TCheckBox;
begin
  clb := TCheckBox(Sender);
  for I := 0 to CLBres.Items.Count - 1 do
  begin
    if clb.Checked then
      CLBres.Checked[I] := true
    else
      CLBres.Checked[I] := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.CBWcSelectdeselectAllClick(Sender: TObject);
var
  I : Integer;
  clb: TCheckBox;
begin
  clb := TCheckBox(Sender);
  for I := 0 to CLBwc.Items.Count - 1 do
  begin
    if clb.Checked then
    begin
      CLBwc.Checked[I] := true;
      FilterRecForWkc(true, TMqmWrkCtr(CLBwc.items.objects[I]))
    end
    else
    begin
      CLBwc.Checked[I] := false;
      FilterRecForWkc(false, TMqmWrkCtr(CLBwc.items.objects[I]));
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TFResFilter.CheckActivCatBox(catRes: TMqmResCat): boolean;
var
  I : Integer;
begin
  Result := true;
  for I := 0 to CLBcat.Items.Count-1 do
  begin
    if catRes = CLBcat.Items.Objects[i] then
      if not CLBcat.Checked[I] then
      begin
        Result := false;
        exit;
      end;
  end;
end;

//----------------------------------------------------------------------------//

function TFResFilter.CheckActivWcBox(Wc : string) : boolean;
var
  i: Integer;
begin
  Result := true;
  for i := 0 to CLBwc.Items.Count - 1 do
  begin
    if (Wc = TMqmWrkCtr(CLBwc.Items.Objects[i]).p_WrkCtrCode) then
      if not CLBwc.Checked[i] then
      begin
        Result := false;
        exit
      end
  end
end;

//----------------------------------------------------------------------------//

function TFResFilter.SetResListChoosen : boolean;
var
  I : Integer;
  Templist : Tlist;
  mqmObj:    TMqmObj;
begin
  Templist := TList.Create;
  Result := false;

{  for I := 0 to CLBWC.Items.Count - 1 do
  begin
    if CLBWC.Checked[I] then
      Result := true;
  end;

  if (Result = false) then
  begin
    showmessage(_('One workcenter at least must be choosen'));
    exit;
  end; }

  for I := 0 to CLBRes.Items.Count - 1 do
  begin
    if CLBRes.Checked[I] then
    begin
      Result := true;
      Templist.add(m_ListallRes[I]);
    end;
  end;

  if (Result = false) then
  begin
    showmessage(_('One resource at least must be choosen'));
    Templist.free;
    exit;
  end;

  m_ListallRes.Clear;

  for I := 0 to Templist.Count - 1 do
  begin
    mqmObj := p_pl.FindResByCode(TMqmRes(Templist[I]).p_ResCode);
    m_ListallRes.Add(mqmObj);
  end;

  if cbGroup.ItemIndex = 0 then
    m_SlotGoup := 0
  else if cbGroup.Items[cbGroup.ItemIndex] = 'By Work center group' then
    m_SlotGoup := 1
  else if cbGroup.Items[cbGroup.ItemIndex] = 'By Plant' then
    m_SlotGoup := 2
  else if cbGroup.Items[cbGroup.ItemIndex] = 'By Division' then
    m_SlotGoup := 3;

  Templist := nil;
  Templist.free;
end;

//----------------------------------------------------------------------------//

function TFResFilter.GetTabName : string;
begin
  Result := '   ' + EditTabName.Text + '   ';
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.BtnAboClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TFResFilter.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
  if not SetResListChoosen then
    ModalResult := mrAbort;
end;

procedure TFResFilter.cbGroupSelect(Sender: TObject);
begin
  RefillWCCategory
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrAbort then Abort;
{  m_SelResList.Clear;
  for i := 0 to CLBRes.Items.Count - 1 do
    if CLBRes.Checked[i] then
      m_SelResList.Add(TMqmRes(CLBres.Items.Objects[i])); }
  Action := caFree
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.FormDestroy(Sender: TObject);
begin
  m_ListallRes.free;
  m_SelResList.Free;
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.CLBwcClickCheck(Sender: TObject);
var
  clb: TCheckListBox;
begin
  clb := TCheckListBox(Sender);
  if not CLBwc.Checked[clb.ItemIndex] then
    FilterRecForWkc(false, TMqmWrkCtr(clb.items.objects[clb.ItemIndex]))
  else
    FilterRecForWkc(true, TMqmWrkCtr(clb.items.objects[clb.ItemIndex]));
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.CLBresClickCheck(Sender: TObject);
var
  CLBres: TCheckListBox;
begin
 CLBres := TCheckListBox(Sender);
 if CLBres.Checked[CLBres.ItemIndex] then
   CLBres.Checked[CLBres.ItemIndex] := true
 else
 CLBres.Checked[CLBres.ItemIndex] := false
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.CLBcatClickCheck(Sender: TObject);
var resCat: TMqmResCat;
  i,y, ItemIndex : Integer;
  wc : TMqmWrkCtr;
begin
  if not m_IsMcm then
  begin
    resCat := TMqmResCat(CLBcat.Items.Objects[CLBcat.ItemIndex]);
    if (CLBcat.Checked[CLBcat.ItemIndex] = false) then
      FilterRecForCateg(false, resCat)
    else
      FilterRecForCateg(true, resCat)
  end else
  begin

    for I := 0 to CLBwc.Items.Count - 1 do
    begin
      wc := TMqmWrkCtr(CLBwc.Items.Objects[i]);

      if cbGroup.Items[cbGroup.ItemIndex] = 'By Work center group' then //by wkc group
      begin
        if CLBcat.Items[CLBcat.ItemIndex] = wc.P_WcGrp then
        begin
          if CLBcat.Checked[CLBcat.ItemIndex] then
            CLBwc.Checked[i] := True
          else
            CLBwc.Checked[i] := False;
        end;
      end else
      if cbGroup.Items[cbGroup.ItemIndex] = 'By Plant' then  //by Plant
      begin
        if CLBcat.Items[CLBcat.ItemIndex] = wc.p_PlantCode then
        begin
          if CLBcat.Checked[CLBcat.ItemIndex] then
            CLBwc.Checked[i] := True
          else
            CLBwc.Checked[i] := False;
        end;
      end else
      if cbGroup.Items[cbGroup.ItemIndex] = 'By Division' then  //by Division
      begin
        if CLBcat.Items[CLBcat.ItemIndex] = wc.p_Division then
        begin
          if CLBcat.Checked[CLBcat.ItemIndex] then
            CLBwc.Checked[i] := True
          else
            CLBwc.Checked[i] := False;
        end;
      end;
    end;

    for I := 0 to CLBwc.Items.Count - 1 do
    begin
      wc := TMqmWrkCtr(CLBwc.Items.Objects[i]);

      for y := 0 to wc.p_ResCount - 1 do
      begin
        ItemIndex := GetResIndexforWc(TMqmRes(wc.p_Res[y]).p_ResCode);
        if (ItemIndex = -1) then continue;
        CLBres.Checked[ItemIndex] := CLBwc.Checked[i];

      end;
    end;



  end;
end;

//----------------------------------------------------------------------------//

function SortBySeqDesc(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
  res1 := TMqmRes(Item1);
  res2 := TMqmRes(Item2);

  if (TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq = 0) and (TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq > 0) then
    Result := 1
  else if (TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq > 0) and (TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq = 0) then
    Result := -1
  else
  begin

    if TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq < TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq then
      Result := 1  // res1 < res 2
    else if TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq > TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq then
      Result := -1   // res1 > res 2
    else //if both have the same WC sort by Sequence code
    begin
      if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := 1  // res1 < res 2
      else if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := -1   // res1 > res 2
      else //if both have the same WC sort by Work center code
      begin
        if res1.p_ResCode < res2.p_ResCode then
          Result := 1  // res1 < res 2
        else if res1.p_ResCode > res2.p_ResCode then
          Result := -1   // res1 > res 2
        else
          Result := 0;
      end;
    end;
  end;
  //  Result := SortByWC(Item1, Item2); //Result := 0;  // res 1 = res 2
end;

function SortBySeq(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
  res1 := TMqmRes(Item1);
  res2 := TMqmRes(Item2);

  if (TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq = 0) and (TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq > 0) then
    Result := 1
  else if (TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq > 0) and (TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq = 0) then
    Result := -1
  else
  begin

    if TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq < TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq then
      Result := -1  // res1 < res 2
    else if TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq > TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq then
      Result := 1   // res1 > res 2
    else //if both have the same WC sort by Sequence code
    begin
      if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := -1  // res1 < res 2
      else if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := 1   // res1 > res 2
      else //if both have the same WC sort by Work center code
      begin
        if res1.p_ResCode < res2.p_ResCode then
          Result := -1  // res1 < res 2
        else if res1.p_ResCode > res2.p_ResCode then
          Result := 1   // res1 > res 2
        else
          Result := 0;
      end;
    end;
  end;
  //  Result := SortByWC(Item1, Item2); //Result := 0;  // res 1 = res 2
end;

function SortByResCode(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
  res1 := TMqmRes(Item1);
  res2 := TMqmRes(Item2);

  if res1.p_ResCode < res2.p_ResCode then
    Result := -1  // res1 < res 2
  else if res1.p_ResCode > res2.p_ResCode then
    Result := 1   // res1 > res 2
  else
    Result := 0;
   // Result := SortBySubResource(res1, res2, Item1, Item2);
end;

//----------------------------------------------------------------------------//

function SortByCategory(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
//  Result := 0;
  res1 := TMqmRes(Item1);
  res2 := TMqmRes(Item2);

  if TMqmResCat(res1.p_ResCat).p_ResCatCode < TMqmResCat(res2.p_ResCat).p_ResCatCode then
    Result := -1  // res1 < res 2
  else if TMqmResCat(res1.p_ResCat).p_ResCatCode > TMqmResCat(res2.p_ResCat).p_ResCatCode then
    Result := 1   // res1 > res 2
  else //if both have the same category sort by Resource code
    Result := SortByResCode(Item1, Item2); //Result := 0;  // res 1 = res 2
end;

//----------------------------------------------------------------------------//

function SortByWC(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
//  Result := 0;
  res1 := TMqmRes(Item1);
  res2 := TMqmRes(Item2);

  if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
    Result := -1  // res1 < res 2
  else if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
    Result := 1   // res1 > res 2
  else //if both have the same WC sort by Resource code
    Result := SortByResCode(Item1, Item2); //Result := 0;  // res 1 = res 2
end;

//----------------------------------------------------------------------------//

function SortByWCAndCategory(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
//  Result := 0;
  res1 := TMqmRes(Item1);
  res2 := TMqmRes(Item2);

  if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
    Result := -1  // res1 < res 2
  else if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
    Result := 1   // res1 > res 2
  else //if both have the same WC sort by Category code and also Res code
    Result := SortByCategory(Item1, Item2); //Result := 0;  // res 1 = res 2
end;

//----------------------------------------------------------------------------//

function TFResFilter.GetResList: TList;
begin
  if not m_IsMcm then
  begin
    case CBSort.ItemIndex of
      0 : m_ListallRes.Sort(SortByResCode);
      1 : m_ListallRes.Sort(SortByCategory);
      2 : m_ListallRes.Sort(SortByWC);
      3 : m_ListallRes.Sort(SortByWCAndCategory);
      4 : m_ListallRes.Sort(SortByWCAndCategory);   //??
    end;
  end else
  begin
    m_ListallRes.Sort(SortBySeq);
    {case CBSort.ItemIndex of
      0 : m_ListallRes.Sort(SortByWC);
      1 : m_ListallRes.Sort(SortBySeq);
      2 : m_ListallRes.Sort(SortBySeqDesc);
    end; }
  end;

  Result := m_ListallRes;
end;

//----------------------------------------------------------------------------//

procedure TFResFilter.FormShow(Sender: TObject);
begin
  CBSort.ItemIndex := 0;

  StaticText2.Visible := not DBAppGlobals.MCM_App;

end;

end.
