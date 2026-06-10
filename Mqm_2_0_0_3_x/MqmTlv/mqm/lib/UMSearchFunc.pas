unit UMSearchFunc;

interface

uses
  checklst,UMCompat,
  UMSchedContFunc;

type

  TSrchType = (SRC_ProdReq, SRC_ProdType, SRC_ProdFamily, SRC_ProdProcused_PI, SRC_MaterialFamily, SRC_Material_PI,
                   SRC_ProdLine, SRC_GenInfo_PI, SRC_Comment_PI, SRC_Instruction_PI, SRC_Others_PI,
                   SRC_StepType, SRC_GroupNo, SRC_WkctProc, SRC_QtyToSched, SRC_ExeTime, SRC_JobComment);

  TCondType = (SRC_equal, SRC_Less, SRC_Big, SRC_Like, SRC_FromTo);

  TCnfigSearch = Record
    Field     : TSrchType;
    Prop      : TPropID;
    IsAlpa    : Boolean;
    CondType  : TCondType;
    ValFrom   : string;
    ValTo     : string;
    Name      : string;
    Visible   : boolean;
   end;
  PTCnfigSearch = ^TCnfigSearch;

{  TPropChecked = Record
    Prop : TPropID;
    CondType : TCondType;
    Name : string;
    IsAlpa : Boolean;
    ValFrom   : variant;
    ValTo     : variant;
    Visible   : boolean;
  end;
  PTPropChecked = ^TPropChecked;   }

  TCBoxSearch = class(TCheckListBox)
  public
    CnfigSearch : TCnfigSearch;
  end;



  procedure LoadSrcCnfg(var ArrayCnfg : array of TCnfigSearch);
  procedure SaveSrcCnfg(Pos : Integer ; Visible : boolean);


  procedure InitPropListCnfg(CheckList : TCheckListBox);
  procedure SavePropListCnfg(CheckList : TCheckListBox);
  procedure GetValuesForPropId(PropId : TPropId; var IsAlpha : boolean ; var ValFrom: string ;
                            var Valto: string; var Cond : TCondType; var PropName : string);
  procedure SetValuesForPropId(PRec : PTCnfigSearch);
  procedure SetDataFromJob(Id : TSchedId);
  procedure ClearAllFields;

implementation

uses
  classes;

type

  TSrchSet = class
  private
    m_List : TList;
//    procedure Clear;
    procedure InitPropList;
    function GetValuesForPropId(PropId : TPropId) : PTCnfigSearch;
    procedure SetValuesForPropId(PRec : PTCnfigSearch);
  public
    constructor Create;
    destructor Destroy ; override;
  end;

var
  m_SrchSet : TSrchSet;

  VaL_fieldSearch : array[0..16] of TCnfigSearch = (
    (Field : SRC_ProdReq;          CondType : SRC_equal; ValFrom : ''; ValTo : '';  Name : 'Production Request';    Visible : true),
    (Field : SRC_ProdType;         CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Product Type';           Visible : true),
    (Field : SRC_ProdFamily;       CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Product Family';         Visible : true),
    (Field : SRC_MaterialFamily;   CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Material Family';        Visible : true),
    (Field : SRC_ProdLine;         CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Production Line';        Visible : true),
    (Field : SRC_StepType;         CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Step Type';              Visible : true),
    (Field : SRC_GroupNo;          CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Group Nomber';           Visible : true),
    (Field : SRC_WkctProc;         CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Work Center Proccess';   Visible : true),
    (Field : SRC_QtyToSched;       CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Quentity';               Visible : true),
    (Field : SRC_ExeTime;          CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Excution Time';          Visible : true),
    (Field : SRC_JobComment;       CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Job Comments';           Visible : true),
    (Field : SRC_ProdProcused_PI;  CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Products Produced';      Visible : true),
    (Field : SRC_Material_PI;      CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Materials';              Visible : true),
    (Field : SRC_GenInfo_PI;       CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'General Information';    Visible : true),
    (Field : SRC_Comment_PI;       CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Comment Information';    Visible : true),
    (Field : SRC_Instruction_PI;   CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Instruction Information';Visible : true),
    (Field : SRC_Others_PI;        CondType : SRC_equal; ValFrom : ''; ValTo : ''; Name : 'Other Information';      Visible : true)

    );

procedure LoadSrcCnfg(var ArrayCnfg : array of TCnfigSearch);
var
  I : Integer;
begin
  for I := Low(VaL_fieldSearch) to High(VaL_fieldSearch) do
  begin
    ArrayCnfg[I] := VaL_fieldSearch[I];
  end;
end;

//----------------------------------------------------------------------------//

procedure SaveSrcCnfg(Pos : Integer ; Visible : boolean);
begin
  VaL_fieldSearch[Pos].Visible := Visible;
end;

//----------------------------------------------------------------------------//

procedure InitPropListCnfg(CheckList : TCheckListBox);
var
  I : Integer;
  pRec: PTCnfigSearch;
begin
  if not Assigned(m_SrchSet) then
     m_SrchSet := TSrchSet.Create;
  for I := 0 to m_SrchSet.m_List.Count - 1 do
  begin
    pRec := PTCnfigSearch(m_SrchSet.m_List[I]);
    CheckList.Items.add(pRec.Name);
    CheckList.Items.Objects[I] := pRec.Prop;
    CheckList.Checked[I] := pRec.Visible;
  end;

end;

//----------------------------------------------------------------------------//

procedure SavePropListCnfg(CheckList : TCheckListBox);
begin
{  for I := 0 to CheckList.Items.count - 1 do
    PTPropChecked(m_SrchSet.m_List[I]).Visible := CheckList.Checked[I]; }
end;

//----------------------------------------------------------------------------//

procedure GetValuesForPropId(PropId : TPropId ; var IsAlpha : boolean ; var ValFrom: string ; var Valto: string; var Cond : TCondType; var PropName : string);
var
  CnfigSearch : PTCnfigSearch;
begin
  CnfigSearch := m_SrchSet.GetValuesForPropId(PropId);
  IsAlpha := CnfigSearch.IsAlpa;
  ValFrom := CnfigSearch.Valfrom;
  ValTo   := CnfigSearch.ValTo;
  PropName := CnfigSearch.Name;
  Cond    := CnfigSearch.CondType;
end;

//----------------------------------------------------------------------------//

procedure SetValuesForPropId(PRec : PTCnfigSearch);
begin
  m_SrchSet.SetValuesForPropId(PRec);
end;

//----------------------------------------------------------------------------//

procedure ClearAllFields;
begin
//  m_SrchSet.

end;

//----------------------------------------------------------------------------//

procedure SetDataFromJob(Id : TSchedId);
begin
  // first clear all :
//  for I := 0 to


end;

//----------------------------------------------------------------------------//

{ TSrchSet }
{
procedure TSrchSet.Clear;
var
  I : Integer;
  pRec: PTCnfigSearch;
begin
  for I := 0 to m_List.Count - 1 do
  begin
    pRec := PTCnfigSearch(m_List[i]);
    pRec.CondType := SRC_equal;
    pRec.ValFrom := '';
    pRec.ValTo := '';
  end;
end;
}
//----------------------------------------------------------------------------//

constructor TSrchSet.Create;
begin
  inherited Create;
  m_List := TList.Create;
  InitPropList;
end;

//----------------------------------------------------------------------------//

destructor TSrchSet.Destroy;
var
  I:    integer;
  pRec: PTCnfigSearch;
begin
  for i := 0 to m_List.Count-1 do
  begin
    pRec := PTCnfigSearch(m_List[i]);
    Dispose(pRec)
  end;

  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TSrchSet.GetValuesForPropId(PropId : TPropId): PTCnfigSearch;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to m_List.count - 1 do
  begin
    if PTCnfigSearch(m_List[I]).Prop = PropId then
    begin
      Result := PTCnfigSearch(m_List[I]);
      exit;
    end
  end;
end;

//----------------------------------------------------------------------------//

procedure TSrchSet.InitPropList;
var
  I : Integer;
//  isAlpha : boolean;
  pRec : PTCnfigSearch;
begin
  for I := 0 to GetPropertyCount - 1 do
  begin
    New(pRec);
    pRec.Prop := GetPropFromPos(I);
    pRec.Name := GetPropCodeFromID(pRec.Prop);   //GetNextProp(I,Desc,isAlpha);
//    pRec.IsAlpa := isAlpha;
    pRec.IsAlpa := false;
    pRec.ValFrom := '';
    pRec.ValTo   := '';
    pRec.Visible := false;
    pRec.CondType := SRC_equal;
    m_List.add(pRec);
  end;
end;

//----------------------------------------------------------------------------//

procedure TSrchSet.SetValuesForPropId(PRec: PTCnfigSearch);
var
  I : Integer;
  Rec : PTCnfigSearch;
begin
  for I := 0 to m_List.count - 1 do
  begin
    Rec := PTCnfigSearch(m_List[I]);
    if Rec.Prop = Prec.Prop then
    begin
      Rec.CondType := Prec.CondType;
      Rec.ValFrom := Prec.ValFrom;
      Rec.ValTo := Prec.ValTo;
      exit;
    end;
  end;

end;

initialization

//----------------------------------------------------------------------------//

finalization

  if Assigned(m_SrchSet) then
    m_SrchSet.free;

end.
