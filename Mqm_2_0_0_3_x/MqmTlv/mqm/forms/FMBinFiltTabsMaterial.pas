unit FMBinFiltTabsMaterial;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, gnugettext,
  UMBinFunc, UMSchedContFunc, UGPropComp, ExSpinEdit, Vcl.ComCtrls, UReShape,
  Vcl.StdCtrls, Vcl.CheckLst, Vcl.ExtCtrls, Vcl.Buttons,
  Grids, Menus, UMwkCtr ,  Spin, UMObjCont, UMCompat, Vcl.Mask;


type
  TTBinFilterMaterial = class(TForm)
    Panel1: TPanel;
    EditTabName: TEdit;
    TabName: TLabel;
    BtnAbo: TcxButton;
    BtnOk: TcxButton;
    PageControl1: TPageControl;
    TabFiltervalues: TTabSheet;
    TabProperty: TTabSheet;
    ScrollBox2: TScrollBox;
    eItemType: TLabeledEdit;
    eProdCode: TLabeledEdit;
    bClearall: TcxButton;
    rgSched: TRadioGroup;
    rgWarplvl: TRadioGroup;
    gbFirst: TGroupBox;
    gbSecond: TGroupBox;
    eItemtype2: TLabeledEdit;
    eProdCode2: TLabeledEdit;
    eMatCodeSubDet: TLabeledEdit;
    eNetGrpCode: TLabeledEdit;
    eMatCode: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
    procedure bClearallClick(Sender: TObject);
  private
    m_Parmflt : TBinFilterParms;
    m_TabName : string;
    m_Id      : TSchedID;
    m_PropComp : TPropComponent;
    m_SrchType : CSearchTabs;
    procedure SetTabName;
  public
    function  GetTabName: string;
    procedure InitFilter;
    procedure CleanSearchParams;
    procedure SetFilter;
    constructor CreateMaterialBinFilter(AOwner: TComponent; Parmflt: TBinFilterParms; TabName : string;
             PropType : TPropGridType ; SchedID : TSchedID ; SRChType : CSearchTabs);
  end;

//var
//  TBinFilterMaterial: TTBinFilterMaterial;

implementation

uses UGglobal, FMbin;

{$R *.dfm}

{ TTBinFilterMaterial }

procedure TTBinFilterMaterial.bClearallClick(Sender: TObject);
begin
  eItemType.Text := '';
  eProdCode.Text := '';
  eNetGrpCode.Text := '';
  eMatCode.Text := '';
  eMatCodeSubDet.Text := '';

end;

procedure TTBinFilterMaterial.BtnAboClick(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//
procedure TTBinFilterMaterial.SetFilter;
var i : INteger;
begin
  CleanSearchParams;

  if (m_SrchType = CSR_New) then
  begin
     case rgWarplvl.ItemIndex of
    0 :  begin
           Include(m_Parmflt.RecFilt.Options, Filt_WarpBasicLvl);
           Exclude(m_Parmflt.RecFilt.Options, Filt_WarpSecondLvl);
           m_Parmflt.RecFilt.WarpLevel   := 0;
           eItemType2.Text := '';
           eProdCode2.Text := '';
         end;
    1 :  begin
           Exclude(m_Parmflt.RecFilt.Options, Filt_WarpBasicLvl);
           Include(m_Parmflt.RecFilt.Options, Filt_WarpSecondLvl);
           m_Parmflt.RecFilt.WarpLevel   := 1;
           eItemType.Text := '';
           eProdCode.Text := '';
           eNetGrpCode.Text := '';
           eMatCode.Text := '';
           eMatCodeSubDet.Text := '';
         end;
    2 :  begin
           Include(m_Parmflt.RecFilt.Options, Filt_WarpBasicLvl);
           Include(m_Parmflt.RecFilt.Options, Filt_WarpSecondLvl);
           m_Parmflt.RecFilt.WarpLevel   := 2;
         end
    end;

    if eItemType.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, Filt_Item_Type);
      m_Parmflt.RecFilt.Item_Type := eItemType.Text;
    end else
    begin
      Exclude(m_Parmflt.RecFilt.Options, Filt_Item_Type);
      m_Parmflt.RecFilt.Item_Type := '';
    end;

    if eProdCode.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, Filt_Product_code);
      m_Parmflt.RecFilt.Product_code := eProdCode.Text;
    end else
    begin
      Exclude(m_Parmflt.RecFilt.Options, Filt_Product_code);
      m_Parmflt.RecFilt.Product_code := '';
    end;

    if eNetGrpCode.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, Filt_NetGroup_Code);
      m_Parmflt.RecFilt.NetGroup_Code := eNetGrpCode.Text;
    end else
    begin
      Exclude(m_Parmflt.RecFilt.Options, Filt_NetGroup_Code);
      m_Parmflt.RecFilt.NetGroup_Code  := '';
    end;

    if eMatCode.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, Filt_MaterialDetailCode);
      m_Parmflt.RecFilt.MaterialDetailCode := eMatCode.Text;
    end else
    begin
      Exclude(m_Parmflt.RecFilt.Options, Filt_MaterialDetailCode);
      m_Parmflt.RecFilt.MaterialDetailCode  := '';
    end;

    if eMatCodeSubDet.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, Filt_MaterialCode_SUB_DETAILS);
      m_Parmflt.RecFilt.MaterialCodeSubDetail := eMatCodeSubDet.Text;
    end else
    begin
      Exclude(m_Parmflt.RecFilt.Options, Filt_MaterialCode_SUB_DETAILS);
      m_Parmflt.RecFilt.MaterialCodeSubDetail  := '';
    end;

    //2nd
    if eItemType2.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, Filt_Item_Type2);
      m_Parmflt.RecFilt.Item_Type2 := eItemType2.Text;
    end else
    begin
      Exclude(m_Parmflt.RecFilt.Options, Filt_Item_Type2);
      m_Parmflt.RecFilt.Item_Type2 := '';
    end;

    if eProdCode2.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, Filt_Product_code2);
      m_Parmflt.RecFilt.Product_code2 := eProdCode2.Text;
    end else
    begin
      Exclude(m_Parmflt.RecFilt.Options, Filt_Product_code2);
      m_Parmflt.RecFilt.Product_code2 := '';
    end;

    case rgSched.ItemIndex of
    0 :  begin
           Exclude(m_Parmflt.RecFilt.Options, FiltSchedJobs);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlySchedJobs);
           m_Parmflt.RecFilt.SchedJobs   := 0;
         end;
    1 :  begin
           Include(m_Parmflt.RecFilt.Options, FiltSchedJobs);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlySchedJobs);
           m_Parmflt.RecFilt.SchedJobs   := 1;
         end;
    2 :  begin
           Exclude(m_Parmflt.RecFilt.Options, FiltSchedJobs);
           Include(m_Parmflt.RecFilt.Options, FiltOnlySchedJobs);
           m_Parmflt.RecFilt.SchedJobs   := 2;
         end
    end;

  end;

  m_Parmflt.RecFilt.IsPropEnter := m_PropComp.IsPropEnter;
    if m_Parmflt.RecFilt.IsPropEnter then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltProp);

      m_Parmflt.ClearFiltPropList;
      m_Parmflt.ClearPropRecFields;
      for I := 1 to m_PropComp.P_RowCount - 1 do
      begin
        if m_PropComp.P_GetPropVal[I] <> '' then
        begin
          m_Parmflt.SetPropValue(m_PropComp.P_GetPropVal[I],
                            '',//m_PropComp.P_GetPropRsc[I],
                            m_PropComp.P_GetValFrom[I],
                            m_PropComp.P_GetValTo[I]);

          m_Parmflt.RecFilt.PropCod[I] := m_PropComp.P_GetPropVal[I];
          m_Parmflt.RecFilt.PropRes[I] := '';//m_PropComp.P_GetPropRsc[I];
          m_Parmflt.RecFilt.PropValfrom[I] := m_PropComp.P_GetValFrom[I];
          m_Parmflt.RecFilt.PropValTo[I] := m_PropComp.P_GetValTo[I];
        end;
      end;
    end
    else
    begin
      m_Parmflt.ClearPropRecFields;
      Exclude(m_Parmflt.RecFilt.Options, FiltProp);
    end;

end;

//----------------------------------------------------------------------------//

procedure TTBinFilterMaterial.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;

  SetFilter;

  m_Parmflt.GetOrConditionProp;
  m_Parmflt.P_SetListOnProp := false;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilterMaterial.CleanSearchParams;
begin
  Exclude(m_Parmflt.RecFilt.Options, Filt_Item_Type);
  m_Parmflt.RecFilt.Item_Type  := '';

  Exclude(m_Parmflt.RecFilt.Options, Filt_Product_code);
  m_Parmflt.RecFilt.Product_code   := '';

  Exclude(m_Parmflt.RecFilt.Options, Filt_NetGroup_Code);
  m_Parmflt.RecFilt.NetGroup_Code   := '';

  Exclude(m_Parmflt.RecFilt.Options, Filt_MaterialDetailCode);
  m_Parmflt.RecFilt.MaterialDetailCode   := '';

  Exclude(m_Parmflt.RecFilt.Options, Filt_MaterialCode_SUB_DETAILS);
  m_Parmflt.RecFilt.MaterialCodeSubDetail   := '';
  //2nd
  Exclude(m_Parmflt.RecFilt.Options, Filt_Item_Type2);
  m_Parmflt.RecFilt.Item_Type2  := '';

  Exclude(m_Parmflt.RecFilt.Options, Filt_Product_code2);
  m_Parmflt.RecFilt.Product_code2   := '';

  Exclude(m_Parmflt.RecFilt.Options, FiltSchedJobs);
  m_Parmflt.RecFilt.SchedJobs   := 0;

  Include(m_Parmflt.RecFilt.Options, Filt_WarpBasicLvl);
  Include(m_Parmflt.RecFilt.Options, Filt_WarpSecondLvl);
  m_Parmflt.RecFilt.WarpLevel   := 2;
end;

//----------------------------------------------------------------------------//

constructor TTBinFilterMaterial.CreateMaterialBinFilter(AOwner: TComponent;
  Parmflt: TBinFilterParms; TabName: string; PropType: TPropGridType;
  SchedID: TSchedID; SRChType: CSearchTabs);
begin
  inherited Create(AOwner);
  m_Parmflt := Parmflt;
  m_TabName := Trim(TabName);
  m_Id := SchedID;
  m_SrchType := SRChType; //check for later ...
  m_PropComp := TPropComponent.CreatePropComp(TabProperty,PropType,nil,m_Id, nil, nil);
end;

//----------------------------------------------------------------------------//

procedure TTBinFilterMaterial.FormCreate(Sender: TObject);
begin
 // ScaleFormSize(Self, Screen.PixelsPerInch);
 // InitFields;
  TranslateComponent(self);
  PageControl1.ActivePage := TabFiltervalues;
  SetTabName;
  ReShape(Self);
  rgSched.ItemIndex := 1;
end;

//----------------------------------------------------------------------------//

function TTBinFilterMaterial.GetTabName: string;
begin
  Result := '   ' + EditTabName.Text + '   ';
end;

//----------------------------------------------------------------------------//

procedure TTBinFilterMaterial.InitFilter;
var i : Integer;
begin

  if FiltSchedJobs in m_Parmflt.RecFilt.Options then
    rgSched.ItemIndex := 1
  else if FiltOnlySchedJobs in m_Parmflt.RecFilt.Options then
    rgSched.ItemIndex := 2
  else
    rgSched.ItemIndex := 0;


  //FIRST LEVEL
  if (Filt_WarpBasicLvl in m_Parmflt.RecFilt.Options) and not (Filt_WarpSecondLvl in m_Parmflt.RecFilt.Options) then
  begin
    rgWarplvl.ItemIndex := 0;
    gbFirst.Enabled := True;
    gbSecond.Enabled := False;

    if Filt_Item_Type in m_Parmflt.RecFilt.Options then
      eItemType.Text := m_Parmflt.RecFilt.Item_Type;

    if Filt_Product_code in m_Parmflt.RecFilt.Options then
      eProdCode.Text := m_Parmflt.RecFilt.Product_code;

    if Filt_NetGroup_Code in m_Parmflt.RecFilt.Options then
      eNetGrpCode.Text := m_Parmflt.RecFilt.NetGroup_Code;

    if Filt_MaterialDetailCode in m_Parmflt.RecFilt.Options then
      eMatCode.Text := m_Parmflt.RecFilt.MaterialDetailCode;

    if Filt_MaterialCode_SUB_DETAILS in m_Parmflt.RecFilt.Options then
      eMatCodeSubDet.Text := m_Parmflt.RecFilt.MaterialCodeSubDetail ;

  end else if not (Filt_WarpBasicLvl in m_Parmflt.RecFilt.Options) and (Filt_WarpSecondLvl in m_Parmflt.RecFilt.Options) then
  begin //SECOND LEVEL
    rgWarplvl.ItemIndex := 1;
    gbFirst.Enabled := False;
    gbSecond.Enabled := True;

    if Filt_Item_Type2 in m_Parmflt.RecFilt.Options then
      eItemType2.Text := m_Parmflt.RecFilt.Item_Type2;

    if Filt_Product_code2 in m_Parmflt.RecFilt.Options then
      eProdCode2.Text := m_Parmflt.RecFilt.Product_code2;

  end else //if (Filt_WarpBasicLvl in m_Parmflt.RecFilt.Options) and (Filt_WarpSecondLvl in m_Parmflt.RecFilt.Options) then
  begin  //BOTH
    rgWarplvl.ItemIndex := 2;
    gbFirst.Enabled := True;
    gbSecond.Enabled := True;

    if Filt_Item_Type in m_Parmflt.RecFilt.Options then
      eItemType.Text := m_Parmflt.RecFilt.Item_Type;

    if Filt_Product_code in m_Parmflt.RecFilt.Options then
      eProdCode.Text := m_Parmflt.RecFilt.Product_code;

    if Filt_NetGroup_Code in m_Parmflt.RecFilt.Options then
      eNetGrpCode.Text := m_Parmflt.RecFilt.NetGroup_Code;

    if Filt_MaterialDetailCode in m_Parmflt.RecFilt.Options then
      eMatCode.Text := m_Parmflt.RecFilt.MaterialDetailCode;

    if Filt_MaterialCode_SUB_DETAILS in m_Parmflt.RecFilt.Options then
      eMatCodeSubDet.Text := m_Parmflt.RecFilt.MaterialCodeSubDetail ;

      //2nd
    if Filt_Item_Type2 in m_Parmflt.RecFilt.Options then
      eItemType2.Text := m_Parmflt.RecFilt.Item_Type2;

    if Filt_Product_code2 in m_Parmflt.RecFilt.Options then
      eProdCode2.Text := m_Parmflt.RecFilt.Product_code2;

  end; {else if not (Filt_WarpBasicLvl in m_Parmflt.RecFilt.Options) and not (Filt_WarpSecondLvl in m_Parmflt.RecFilt.Options) then
  begin
    rgWarplvl.ItemIndex := 2;
    gbFirst.Enabled := True;
    gbSecond.Enabled := True;
  end;  }

  if FiltProp in m_Parmflt.RecFilt.Options then
  begin
    for I := low(m_Parmflt.RecFilt.PropCod) to High(m_Parmflt.RecFilt.PropCod) do
    begin
      if (m_Parmflt.RecFilt.PropCod[I] <> '')
      and CheckPropExist(m_Parmflt.RecFilt.PropCod[I]) then
      begin
        if (I = 1) then
          m_PropComp.SetPropVal(m_Parmflt.RecFilt.PropCod[I],I,true)
        else
          m_PropComp.SetPropVal(m_Parmflt.RecFilt.PropCod[I],I,false);
        if m_Parmflt.RecFilt.PropRes[I] <> '' then
          m_PropComp.SetPropRes(m_Parmflt.RecFilt.PropRes[I],I);
        if m_Parmflt.RecFilt.PropValfrom[I] <> '' then
          m_PropComp.SetValFrom(m_Parmflt.RecFilt.PropValfrom[I],I);
        if m_Parmflt.RecFilt.PropValTo[I] <> '' then
          m_PropComp.SetValTo(m_Parmflt.RecFilt.PropValTo[I],I);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilterMaterial.SetTabName;
begin
  if m_TabName <> '' then
    EditTabName.Text := m_TabName;

  // Default name
  if (EditTabName.Text = '') and Assigned(Fbin) then
    EditTabName.Text := Fbin.SetDefaultTabName      //EditTabName.Text := _('Bin View');
  else if m_TabName <> '' then
    EditTabName.Text := m_TabName  // _('Bin View');
  else if EditTabName.Text <> '' then
    EditTabName.Text := EditTabName.Text;
end;

//----------------------------------------------------------------------------//

end.
