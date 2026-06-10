unit FMlearningCurve;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UReShape, Vcl.ExtCtrls;

type

  TlearningCurve = class(TForm)
    ListBoxCurveCode: TListBox;
    STCurrentCode: TStaticText;
    LblCurveCodeList: TLabel;
    BitBtn1: TcxButton;
    BitBtn2: TcxButton;
    procedure FormCreate(Sender: TObject);
    constructor CreateLearnCurveCng(AOwner : TComponent; CurrCurve : string);
    destructor  Destroy; override;
    procedure ListBoxCurveCodeClick(Sender: TObject);
    function  GetNewCurveCode : string;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);

  private
    m_CurveCode : string;
  public

  end;

  procedure LoadCurveDataFromDB();
  function GetDataForCurveCode(CurveCode : string; var _1th : double; var _1th_effic : integer;
                               var _2th : double; var _2th_effic : integer;
                               var _3th : double; var _3th_effic : integer;
                               var _4th : double; var _4th_effic : integer;
                               var _5th : double; var _5th_effic : integer;
                               var _6th : double; var _6th_effic : integer;
                               var _7th : double; var _7th_effic : integer;
                               var _8th : double; var _8th_effic : integer) : boolean;

implementation

{$R *.dfm}

uses UGGlobal,DMsrvPc,UMTblDesc, UMCOmmon;

type

  TLearningCurveRec = record
    Code       : string;
    Desc       : string;
    _1th       : double;
    _1th_effic : integer;
    _2th       : double;
    _2th_effic : integer;
    _3th       : double;
    _3th_effic : integer;
    _4th       : double;
    _4th_effic : integer;
    _5th       : double;
    _5th_effic : integer;
    _6th       : double;
    _6th_effic : integer;
    _7th       : double;
    _7th_effic : integer;
    _8th       : double;
    _8th_effic : integer;
  end;
  PTLearningCurveRec = ^TLearningCurveRec;

var
  List_LearningCurve : TList;

//----------------------------------------------------------------------------//

procedure LoadCurveDataFromDB();
var
  LearningCurve : PTLearningCurveRec;
  qry:    TMqmQuery;
  TbInfo: ^TTblInfo;
begin
  qry := CreateQuery(Main_DB);
  TbInfo := @tblInfo[tbl_LearningCurve];

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select * from ' + TbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(TbInfo.pfx, fli_Identifier)));
    open;
    while not EOF do
    begin
      new(LearningCurve);
      LearningCurve.Code       := FieldByName(CreateFld(TbInfo.pfx, fli_LearningCurveCode)).AsString;
      LearningCurve.Desc       := FieldByName(CreateFld(TbInfo.pfx, fli_LearningCurveDesc)).AsString;
      LearningCurve._1th       := FieldByName(CreateFld(TbInfo.pfx, fli_CurveFirstHours)).AsFloat;
      LearningCurve._1th_effic := FieldByName(CreateFld(TbInfo.pfx, fli_CurveFirstEffic)).AsInteger;
      LearningCurve._2th       := FieldByName(CreateFld(TbInfo.pfx, fli_CurveSecondHours)).AsFloat;
      LearningCurve._2th_effic := FieldByName(CreateFld(TbInfo.pfx, fli_CurveSecondEffic)).AsInteger;
      LearningCurve._3th       := FieldByName(CreateFld(TbInfo.pfx, fli_CurveThirdHours)).AsFloat;
      LearningCurve._3th_effic := FieldByName(CreateFld(TbInfo.pfx, fli_CurveThirdEffic)).AsInteger;
      LearningCurve._4th       := FieldByName(CreateFld(TbInfo.pfx, fli_CurveForthHours)).AsFloat;
      LearningCurve._4th_effic := FieldByName(CreateFld(TbInfo.pfx, fli_CurveForthEffic)).AsInteger;
      LearningCurve._5th       := FieldByName(CreateFld(TbInfo.pfx, fli_CurveFifthhHours)).AsFloat;
      LearningCurve._5th_effic := FieldByName(CreateFld(TbInfo.pfx, fli_CurveFifthEffic)).AsInteger;
      LearningCurve._6th       := FieldByName(CreateFld(TbInfo.pfx, fli_CurveSixThHours)).AsFloat;
      LearningCurve._6th_effic := FieldByName(CreateFld(TbInfo.pfx, fli_CurveSixThEffic)).AsInteger;
      LearningCurve._7th       := FieldByName(CreateFld(TbInfo.pfx, fli_CurveSevenThHours)).AsFloat;
      LearningCurve._7th_effic := FieldByName(CreateFld(TbInfo.pfx, fli_CurveSevenThEffic)).AsInteger;
      LearningCurve._8th       := FieldByName(CreateFld(TbInfo.pfx, fli_CurveEighthHours)).AsFloat;
      LearningCurve._8th_effic := FieldByName(CreateFld(TbInfo.pfx, fli_CurveEighthEffic)).AsInteger;
      List_LearningCurve.Add(LearningCurve);
      Next;
    end;
    qry.close;
    qry.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure FreeList;
var
  I : integer;
begin
  for I := 0 to List_LearningCurve.Count - 1 do
    Dispose(PTLearningCurveRec(List_LearningCurve[I]));
  List_LearningCurve.Free;
end;

//----------------------------------------------------------------------------//

procedure TlearningCurve.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
//  close;
end;

procedure TlearningCurve.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrAbort;
  close;
end;

constructor TlearningCurve.CreateLearnCurveCng(AOwner : TComponent; CurrCurve : string);
begin
  inherited Create(AOwner);
  m_CurveCode := CurrCurve;
end;

//----------------------------------------------------------------------------//

destructor TlearningCurve.Destroy;
begin
  inherited destroy;
end;

//----------------------------------------------------------------------------//

procedure TlearningCurve.FormCreate(Sender: TObject);
var
  I : Integer;
  LearningCurveRec : PTLearningCurveRec;
  CurrentCode : Integer;
begin
  CurrentCode := -1;
  SetComponent(STCurrentCode, comp_Descr, false);
  for I := 0 to List_LearningCurve.Count - 1 do
  begin
    LearningCurveRec := PTLearningCurveRec(List_LearningCurve[I]);
//    ListBoxCurveCode.Items.AddObject(LearningCurveRec.Code + LearningCurveRec.Desc, List_LearningCurve[I]);
    ListBoxCurveCode.Items.AddObject(LearningCurveRec.Desc, List_LearningCurve[I]);
    if (m_CurveCode = LearningCurveRec.Code) then
       CurrentCode := I
  end;

  if List_LearningCurve.Count = 0 then
    ListBoxCurveCode.ItemIndex := -1
  else if CurrentCode <> -1 then
    ListBoxCurveCode.ItemIndex := CurrentCode
  else
    ListBoxCurveCode.ItemIndex := 0;
  ListBoxCurveCodeClick(self);

  ReShape(self);
//  ReShape(bitbtn1);
//  ReShape(bitbtn2);
end;

//----------------------------------------------------------------------------//

procedure TlearningCurve.ListBoxCurveCodeClick(Sender: TObject);
var
  LearningCurveRec : PTLearningCurveRec;
begin
  LearningCurveRec  := PTLearningCurveRec(ListBoxCurveCode.Items.Objects[ListBoxCurveCode.ItemIndex]);
  STCurrentCode.Caption := LearningCurveRec.Code;
end;

//----------------------------------------------------------------------------//

function TlearningCurve.GetNewCurveCode : string;
begin
  Result := STCurrentCode.Caption;
end;

//----------------------------------------------------------------------------//

function GetDataForCurveCode(CurveCode : string; var _1th : double; var _1th_effic : integer;
                               var _2th : double; var _2th_effic : integer;
                               var _3th : double; var _3th_effic : integer;
                               var _4th : double; var _4th_effic : integer;
                               var _5th : double; var _5th_effic : integer;
                               var _6th : double; var _6th_effic : integer;
                               var _7th : double; var _7th_effic : integer;
                               var _8th : double; var _8th_effic : integer) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to List_LearningCurve.Count - 1 do
  begin
    if (CurveCode = PTLearningCurveRec(List_LearningCurve[I]).Code) then
    begin
      Result := true;
      _1th   := PTLearningCurveRec(List_LearningCurve[I])._1th;
      _1th_effic := PTLearningCurveRec(List_LearningCurve[I])._1th_effic;
      _2th       := PTLearningCurveRec(List_LearningCurve[I])._2th;
      _2th_effic := PTLearningCurveRec(List_LearningCurve[I])._2th_effic;
      _3th       := PTLearningCurveRec(List_LearningCurve[I])._3th;
      _3th_effic := PTLearningCurveRec(List_LearningCurve[I])._3th_effic;
      _4th       := PTLearningCurveRec(List_LearningCurve[I])._4th;
      _4th_effic := PTLearningCurveRec(List_LearningCurve[I])._4th_effic;
      _5th       := PTLearningCurveRec(List_LearningCurve[I])._5th;
      _5th_effic := PTLearningCurveRec(List_LearningCurve[I])._5th_effic;
      _6th       := PTLearningCurveRec(List_LearningCurve[I])._6th;
      _6th_effic := PTLearningCurveRec(List_LearningCurve[I])._6th_effic;
      _7th       := PTLearningCurveRec(List_LearningCurve[I])._7th;
      _7th_effic := PTLearningCurveRec(List_LearningCurve[I])._7th_effic;
      _8th       := PTLearningCurveRec(List_LearningCurve[I])._8th;
      _8th_effic := PTLearningCurveRec(List_LearningCurve[I])._8th_effic;
    end;

  end;

end;

//----------------------------------------------------------------------------//

initialization
  List_LearningCurve := TList.Create;

finalization
  FreeList;


end.
