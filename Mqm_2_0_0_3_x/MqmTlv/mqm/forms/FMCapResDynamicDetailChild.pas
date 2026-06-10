unit FMCapResDynamicDetailChild;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, UGPropComp,
  Vcl.Samples.Spin, Vcl.ComCtrls, UMRes, UReShape, ExSpinEdit;

type
  TCapResDynamicDetailChild = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    tbsParams: TTabSheet;
    GBStDate: TGroupBox;
    LblStDate: TLabel;
    LblStTime: TLabel;
    DTPStDate: TDateTimePicker;
    DTPStTime: TDateTimePicker;
    GBDuration: TGroupBox;
    LblDays: TLabel;
    SEDays: TexSpinEdit;
    GBEndDate: TGroupBox;
    LblEndDate: TLabel;
    DTPEndDate: TDateTimePicker;
    GroupBox1: TGroupBox;
    LblResource: TLabel;
    LblClrDesc: TLabel;
    LblUpToCase: TLabel;
    CBResource: TComboBox;
    CBClrDesc: TComboBox;
    SpEdtUpToCase: TexSpinEdit;
    TabProp: TTabSheet;
    GroupBox5: TGroupBox;
    EdtComment: TEdit;
    LblSequence: TLabel;
    SEdtSequence: TexSpinEdit;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    procedure CBClrDescDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    m_PropComp : TPropComponent;
    { Private declarations }
  public
    constructor CreateNewCapResDynamicDetailChild(AOwner: TComponent; ResCode : string; NewSequence : integer; DateBegin : TDate; FromTime : TTime; ToDateLimit : TDate);
    constructor CreateUpdateCapResDynamicDetailChild(AOwner: TComponent; ResCode : string; DateBegin : TDate; FromTime : TTime; ToDateLimit : TDate;
                NumberOfDays, Sequencing, ColorIndex, CompactCase : Integer; Comment : string; PropCode, PropValue : TStringlist);
    procedure   GetDateDetails(var NumberOfDays, Sequencing, ColorIndex, CompactCase : Integer; var Comment : string; var PropComp : TPropComponent);
    procedure   GetResourceProperties(Res: TMqmRes; ResProperties: TStrings);
    { Public declarations }
  end;

var
  CapResDynamicDetailChild: TCapResDynamicDetailChild;

implementation

{$R *.dfm}

uses UMglobal, UGglobal, gnugettext, UMCompat, UMCompatSrv, UMObjCont;

{ TCapResDynamicDetailChild }

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetailChild.BtnAbortClick(Sender: TObject);
begin
  Close;
end;

procedure TCapResDynamicDetailChild.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;

  if SEDays.Value = 0 then
  begin
    showmessage(_('Please insert duration for the occupation'));
    ModalResult := mrNone;
  end;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetailChild.CBClrDescDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  str: string;
begin
  str := _(DBAppGlobals.CapResColors[Index].Dsc);
  CBClrDesc.Canvas.Font.Color := DBAppGlobals.CapResColors[Index].txt;
  CBClrDesc.Canvas.Brush.Color := DBAppGlobals.CapResColors[Index].int;
  CBClrDesc.Canvas.Pen.Color := DBAppGlobals.CapResColors[Index].brd;
  CBClrDesc.Canvas.TextRect(rect, rect.left, rect.top, str);
end;

//----------------------------------------------------------------------------------------------

function BtnAddPropCheck(PropCode: string): boolean;
var
  ResProperties: TStringList;
  Res: TMqmRes;
  ResCode : string;
begin
  Result := true;

  ResProperties := TStringList.Create;
  ResCode := CapResDynamicDetailChild.CBResource.Items[CapResDynamicDetailChild.CBResource.ItemIndex];

  Res := TMqmRes(p_pl.FindResByCode(ResCode));
  if not assigned(Res) then
    exit;

  CapResDynamicDetailChild.GetResourceProperties(Res, ResProperties);
  if ResProperties.IndexOf(PropCode) < 0 then
  begin
    Result := false;
    MessageDlg(_('The property is irrelevant for that resource.'), mtWarning, [mbOK], 0);
  end;

  ResProperties.Free;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetailChild.GetResourceProperties(Res: TMqmRes;
  ResProperties: TStrings);
var
  i:     integer;
  pId:      TPropId;
  mat1:     TOneDmatrix;
  mat2:     TTwoDmatrix;
  mtx:      TOrigMatrix;
  iProp:    integer;
  iProc:    integer;
  iCat:     integer;
  m_mtxList: TList;
  m_filterCat: String;

begin
  ResProperties.Clear;
  m_mtxList := TList.Create;
  Res.GetPropMtxs(m_mtxList, true);
  Res.m_resCat.GetPropMtxs(m_mtxList);
  m_filterCat := Res.m_ResCat.p_ResCatCode;

  for i := 0 to m_mtxList.Count-1 do
  begin
    mtx := TOrigMatrix(m_mtxList[i]);
    Assert((mtx.m_mtx <> CMX_code_prod)      and
           (mtx.m_mtx <> CMX_code_prod_proc) and
           (mtx.m_mtx <> CMX_code_prod_cat));

    case mtx.m_mtx of

    CMX_code:
      begin
        mat1 := TOneDmatrix(mtx);
        Assert(Assigned(mat1));

        for iProp := 0 to mat1.GetLev1Count - 1 do
        begin
          mat1.GetLev1Obj(iProp, pId);
          ResProperties.Add(GetPropCodeFromID(pId));//GetPropDescr(pId));
        end
      end;

    CMX_code_proc:
      begin
        mat2 := TTwoDmatrix(mtx);
        Assert(Assigned(mat2));

        for iProc := 0 to mat2.GetLev1Count - 1 do
          for iProp := 0 to mat2.GetLev2Count(iProc)-1 do
          begin
            mat2.GetLev2Obj(iProc, iProp, pId);
            ResProperties.Add(GetPropCodeFromID(pId));//GetPropDescr(pId));
          end
      end;

    CMX_code_cat:
      begin
        mat2 := TTwoDmatrix(mtx);
        Assert(Assigned(mat2));

        for iCat := 0 to mat2.GetLev1Count - 1 do
          for iProp := 0 to mat2.GetLev2Count(iCat)-1 do
          begin
            if mat2.GetLev1Key(iCat) <> m_filterCat then continue;
            mat2.GetLev2Obj(iCat, iProp, pId);
            ResProperties.Add(GetPropCodeFromID(pId));//GetPropDescr(pId));
           end
      end
    end
  end;

end;

//----------------------------------------------------------------------------------------------

constructor TCapResDynamicDetailChild.CreateNewCapResDynamicDetailChild(
  AOwner: TComponent; ResCode: string; NewSequence : integer; DateBegin: TDate; FromTime: TTime; ToDateLimit : TDate);
var
  I : Integer;
begin
  inherited Create(AOwner);

  SetComponent(LblDays,    comp_Label, false);
  SetComponent(LblStDate,  comp_Label, false);
  SetComponent(LblStTime,  comp_Label, false);
  SetComponent(LblEndDate, comp_Label, false);
  SetComponent(LblClrDesc, comp_Label, false);
  SetComponent(CBClrDesc,  comp_Edit, true);
  SetComponent(CBResource, comp_Edit, false);

  m_PropComp := TPropComponent.CreatePropComp(TabProp,CapResProp,nil,-1, BtnAddPropCheck, nil);
  CBClrDesc.Items.Clear;
  for i := 0 to high(DBAppGlobals.CapResColors) do
    CBClrDesc.Items.Add( DBAppGlobals.CapResColors[i].Dsc);
  CBClrDesc.ItemIndex := 0;
  CBResource.Items.Add(ResCode);
  CBResource.ItemIndex := 0;
  DTPStDate.Date := DateBegin;
  DTPStTime.time := FromTime;
  DTPEndDate.Date := ToDateLimit;
  SEdtSequence.Value := NewSequence ;
  ReShape(Self);
end;

//----------------------------------------------------------------------------------------------

constructor TCapResDynamicDetailChild.CreateUpdateCapResDynamicDetailChild(AOwner: TComponent; ResCode : string; DateBegin : TDate; FromTime : TTime; ToDateLimit : TDate;
                NumberOfDays, Sequencing, ColorIndex, CompactCase : Integer; Comment : string; PropCode, PropValue : TStringlist);
var
  I : Integer;
  PropDesc : string;
  propId : TpropId;
begin
  inherited Create(AOwner);

  SetComponent(LblDays,    comp_Label, false);
  SetComponent(LblStDate,  comp_Label, false);
  SetComponent(LblStTime,  comp_Label, false);
  SetComponent(LblEndDate, comp_Label, false);
  SetComponent(LblClrDesc, comp_Label, false);
  SetComponent(CBClrDesc,  comp_Edit, true);
  SetComponent(CBResource, comp_Edit, false);

  m_PropComp := TPropComponent.CreatePropComp(TabProp,CapResProp,nil,-1, nil, nil);
  CBClrDesc.Items.Clear;
  for i := 0 to high(DBAppGlobals.CapResColors) do
    CBClrDesc.Items.Add( DBAppGlobals.CapResColors[i].Dsc);

  CBClrDesc.ItemIndex := ColorIndex;

  CBResource.Items.Add(ResCode);
  CBResource.ItemIndex := 0;
  DTPStDate.Date := DateBegin;
  DTPStTime.time := FromTime;
  DTPEndDate.Date := ToDateLimit;

  SEDays.Value := NumberOfDays;
  SEdtSequence.Value := Sequencing;
  SpEdtUpToCase.Value := CompactCase;
  EdtComment.Text     := Comment;
  CBClrDesc.ItemIndex := ColorIndex;

  for I := 0 to PropCode.Count -1 do
  begin
    propId := GetIdFromCode(PropCode.Strings[I]);
    PropDesc := GetPropDescr(propId);
    if I = 0 then
      m_PropComp.SetPropDescVal(PropCode.Strings[I], PropDesc, I + 1, true, PropValue.Strings[I])
    else
      m_PropComp.SetPropDescVal(PropCode.Strings[I], PropDesc, I + 1, false, PropValue.Strings[I]);
  end;

end;

procedure TCapResDynamicDetailChild.FormShow(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetailChild.GetDateDetails(var NumberOfDays, Sequencing,
  ColorIndex, CompactCase: Integer; var Comment: string; var PropComp: TPropComponent);
begin
  NumberOfDays := SEDays.Value;
  Sequencing   := SEdtSequence.Value;
  ColorIndex   := CBClrDesc.ItemIndex;
  CompactCase  := SpEdtUpToCase.Value;
  Comment      := EdtComment.Text;
  PropComp := m_PropComp;
end;

//----------------------------------------------------------------------------------------------

end.
