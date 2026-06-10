unit UGPropComp;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, ComCtrls, CommCtrl, ExtCtrls,
  CheckLst, Grids, Menus, gnugettext, UMCompatSrv,UMSchedContFunc;

type

  TPropGridType = (CapResProp, TabProp, TabReqProp, SelectedProp, PlannerPropDef , PropAsDate, PropAsRGB, GroupBy);
  TCheckPropOnAdd = function(PropCode: string): boolean;
  TOnPropChange = procedure;

  TPropComponent = class(TPanel)
    GBox: TGroupBox;
    SGPropList: TStringGrid;
    BtnAdd: TcxButton;
    BtnRemove: TcxButton;
    SGAddedPropList: TStringGrid;
    procedure SGAddedPropListSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SGAddedPropListDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure SGAddedPropListGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure SGAddedPropListKeyPress(Sender: TObject; var Key: Char);
    procedure SGPropListDblClick(Sender: TObject);
    procedure SGAddedPropListDblClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnRemoveClick(Sender: TObject);
    procedure set_checkbox_alignment;
    procedure clean_previus_buffer;

  private
    m_Firstval : boolean;
    m_AlfaCode : boolean;
    m_GridType : TPropGridType;
    m_ChkOnAddFunc: TCheckPropOnAdd;
    m_OnChgFunc: TOnPropChange;
    NumberOnly : Boolean;
    procedure GetPropertyList;
    procedure SetJobProp(Prop : TProperties);
    procedure SetJobPropPlannerDefine(Prop : TProperties; ID : TSchedID);
    procedure Loadcaptions;
    function  CheckLimitRows : boolean;
    function  CheckDoubleProp : boolean;
    function  GetRowCount : Integer;
    function  GetPropVal(Index : Integer) : string;
    function  GetPropRsc(Index : Integer) : string;
    function  GetValFrom(Index : Integer) : string;
    function  GetValTo(Index : Integer) : string;
    function  GetBooleanVal(Index : Integer) : boolean;
    function  GetSequenceVal(Index : Integer) : String;
    //function  GetPropDescVal(Index : Integer) : string;

    procedure SGAddedPropListOnExit(Sender: TObject);

  public
    constructor CreatePropComp(AOwner: TComponent; TypeComp: TPropGridType; Prop: TProperties;
                               SchedID: TSchedId; ChkFunc: TCheckPropOnAdd; OnChgFunc: TOnPropChange);
    function IsPropEnter : boolean;
    Function  GetNumericPropList : TList;
  public
    procedure AddPropLine(Code, Valfrom, ValTo: string);
    procedure AddPropLineForGrp(Code, Seq: string);
    procedure SetPropVal(Code: string ; Index: Integer; First: boolean);
    procedure SetPropDescVal(Code: string ;desc : string; Index: Integer; First: boolean; Val : string);
    procedure SetPropRes(ResCode: string; Index: Integer);
    procedure SetValFrom(Valfrom: string ; Index: Integer);
    procedure SetValTo(ValTo: string ;Index: Integer);
    procedure SetColWidth(ColNr : Integer; Width : Integer);
    procedure SetError(RowNr: Integer);
    function  GetPropDescVal(Index : Integer) : string;

    property  P_RowCount : Integer  Read GetRowCount;
    property  P_GetPropVal[I : Integer] : string read GetPropVal;
    property  P_GetPropRsc[I : Integer] : string read GetPropRsc;
    property  P_GetValFrom[I : Integer] : string read GetValFrom;
    property  P_GetValTo[I : Integer] : string read GetValTo;
    property  P_GetBooleanVal[I : Integer] : boolean read GetBooleanVal;
    property  P_GetSeqVal[i : Integer] : String read GetSequenceVal;

    { Public declarations }
  end;

implementation

uses UMCompat,UMObjCont,Types,UMWkCtr, FMCalendarUserEnter, UReshape;

//----------------------------------------------------------------------------------------------

procedure RemoveRowFromStrGrid(grid: TStringGrid; rowStart, rowEnd: integer);
var
  c, r: integer;
  i: integer;
begin
  for r := rowStart to grid.RowCount-2 do
    for c := 0 to grid.ColCount-1 do
      grid.Cells[c, r] := grid.Cells[c, rowEnd-rowStart+r+1];
  grid.RowCount := grid.RowCount-1 - (rowEnd-rowStart);
  if grid.RowCount = 1 then
    begin
      grid.RowCount := 2;
      for i := 0 to grid.ColCount do
        grid.Cells[i,1] := '';
    end;
  grid.FixedRows := 1;
end;

//----------------------------------------------------------------------------------------------

constructor TPropComponent.CreatePropComp(AOwner:TComponent; TypeComp: TPropGridType;
                                          Prop: TProperties; SchedID: TSchedId;
                                          ChkFunc: TCheckPropOnAdd; OnChgFunc: TOnPropChange);
var
  Properties : TProperties;
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  Align := alClient;
  left := 0;
  top := 0;
  width := 875;
  height := 710;
  height := 100;
  visible := true;
  BorderStyle := bsNone;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  m_GridType := TypeComp;
  m_ChkOnAddFunc := ChkFunc;
  m_OnChgFunc := OnChgFunc;
  Color := clWhite;
  NumberOnly := False;
  GBox := TGroupBox.Create(aowner);
  GBox.Parent := Self;
  GBox.Caption := _('Property List');
  GBox.Align := alClient;

  SGPropList := TStringgrid.Create(GBox);
  SGPropList.parent := GBox;
  SGPropList.ColWidths[0] := 100;
  SGPropList.ColWidths[1] := 120;
  SGPropList.ColWidths[2] := 40;

  if (m_GridType = TabProp) or (m_GridType = TabReqProp) then
  begin
    SGPropList.ColCount := 4;
    SGPropList.ColWidths[3] := 0
  end
  else
    SGPropList.ColCount := 3;

  SGPropList.RowCount := 2;
  SGPropList.top := 20;
  SGPropList.left := 10;
//  SGPropList.height := 243; //273
  SGPropList.height := SGPropList.RowHeights[0] * 10 - 11; // fp
  SGPropList.width := 295;
  SGPropList.Visible := true;
  SGPropList.Options := [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goDrawFocusSelected,goRowSelect];
  SGPropList.OnDblClick := SGPropListDblClick;

  BtnAdd := TcxButton.Create(GBox);
  BtnAdd.parent := GBox; //self
  BtnAdd.top := 20;
  BtnAdd.left := SGPropList.left + SGPropList.Width + 10;
  BtnAdd.height := 25;
  BtnAdd.width := 30;
  BtnAdd.Caption := '>';
  BtnAdd.OnClick := BtnAddClick;
  BtnAdd.OnCustomDraw := GDrawHelper.cxButtonCustomDraw;

  BtnRemove := TcxButton.Create(GBox);
  with BtnRemove do
  begin
    parent := GBox; //self
    top := BtnAdd.top + BtnAdd.Height + 5;
    left := BtnAdd.Left;
    height := 25;
    width := 30;
    Caption := '<';
    OnClick := BtnRemoveClick;
    OnCustomDraw := GDrawHelper.cxButtonCustomDraw;
  end;

  SGAddedPropList := TStringgrid.create(GBox);
  SGAddedPropList.parent := GBox;
  SGAddedPropList.RowCount := 2;
  case m_GridType of
    TabProp,
    TabReqProp:
        begin
          SGAddedPropList.ColCount := 4;
          SGAddedPropList.width := 270;
        end;
    PlannerPropDef:
        begin
          SGAddedPropList.ColCount := 3;
          SGAddedPropList.ColWidths[1]  := 100;
          SGAddedPropList.ColWidths[2]  := 90;
          SGAddedPropList.width := 300;
        end;
    CapResProp:
        begin
          SGAddedPropList.ColCount := 3;
          SGAddedPropList.ColWidths[0]  := 60;
          SGAddedPropList.ColWidths[1]  := 100;
          SGAddedPropList.ColWidths[2]  := 90;
          SGAddedPropList.width := 300;
        end;
    GroupBy:
      begin
        SGAddedPropList.ColCount := 2;
        SGAddedPropList.ColWidths[1]  := 80;
        SGAddedPropList.width := 190;
        NumberOnly := True;
      end;
  else
    begin
      SGAddedPropList.ColCount := 1;
      SGAddedPropList.width := 150;
    end;
  end;

  SGAddedPropList.TabStops[0] := false;
  SGAddedPropList.top := 20;
  SGAddedPropList.left := BtnAdd.left + BtnAdd.Width + 10;
//  SGAddedPropList.height := 243; //273
  SGAddedPropList.height := SGPropList.height; // fp
  SGAddedPropList.Visible := true;
  if m_GridType = SelectedProp then
    SGAddedPropList.ColWidths[0] := 150
  else
    SGAddedPropList.ColWidths[0] := 100;
  if (m_GridType <> PropAsDate) and (m_GridType <> SelectedProp) and
     (m_GridType <> PlannerPropDef) and (m_GridType <> CapResProp) and  (m_GridType <> PropAsRGB) and  (m_GridType <>GroupBy) then
  begin
    SGAddedPropList.ColWidths[1] := 80;
    SGAddedPropList.ColWidths[2] := 80;
    SGAddedPropList.ColWidths[3] := 80;
  end;

  SGAddedPropList.FixedRows := 1;
  SGAddedPropList.FixedCols := 0;
  SGAddedPropList.OnGetEditText := SGAddedPropListGetEditText;
  SGAddedPropList.OnKeyPress := SGAddedPropListKeyPress;
  SGAddedPropList.OnSelectCell := SGAddedPropListSelectCell;
  SGAddedPropList.OnDrawCell :=  SGAddedPropListDrawCell;
  SGAddedPropList.OnDblClick := SGAddedPropListDblClick;
  SGAddedPropList.OnExit := SGAddedPropListOnExit;

  LoadCaptions;
  m_FirstVal := true;

  if (TypeComp = PlannerPropDef) and (SchedID <> CSchedIDnull) then
  begin
    Properties := p_sc.GetProperties(SchedID, nil);
    if Assigned(Properties) then
    begin
      SetColWidth(2,60);
      SetJobPropPlannerDefine(Properties, SchedId)
    end
  end

  else if (TypeComp = TabReqProp) and (SchedID <> CSchedIDnull) then
  begin
    Properties := p_sc.GetProperties(SchedID, nil);
    if Assigned(Properties) then
    begin
      SetColWidth(3,60);
      SetJobProp(Properties)
    end
    else
      GetPropertyList;
  end
  else
    GetPropertyList;

  if Screen.PixelsPerInch = 120 then
  begin
    FontResize2(SGPropList.Font,-2);
    SGPropList.Font.Name := 'Montserrat';

    FontResize2(SGAddedPropList.Font,-2);
    SGAddedPropList.Font.Name := 'Montserrat';
  end;
//  m_FirstVal := true;
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.IsPropEnter : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 1 to SGAddedPropList.RowCount - 1 do
  begin
    if SGAddedPropList.Rows[I].Strings[0] <> '' then
    begin
      Result := true;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.AddPropLine(Code, ValFrom, ValTo: string);
begin
  if (Code <> '')
  and CheckPropExist(Code) then
  begin
    if (SGAddedPropList.Rows[1].Strings[0] <> '') then
      SGAddedPropList.RowCount := p_RowCount + 1;
    SGAddedPropList.Rows[p_RowCount - 1].Strings[0] := Code;
    SGAddedPropList.Rows[p_RowCount - 1].Strings[1] := ValFrom;
    SGAddedPropList.Rows[p_RowCount - 1].Strings[2] := ValTo;
  end
end;

procedure TPropComponent.AddPropLineForGrp(Code, Seq: string);
begin
  if (Code <> '')
  and CheckPropExist(Code) then
  begin
    if (SGAddedPropList.Rows[1].Strings[0] <> '') then
      SGAddedPropList.RowCount := p_RowCount + 1;
    SGAddedPropList.Rows[p_RowCount - 1].Strings[0] := Code;
    SGAddedPropList.Rows[p_RowCount - 1].Strings[1] := Seq;

    m_Firstval := false;
  end
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.GetRowCount : Integer;
begin
  Result := SGAddedPropList.RowCount;
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.GetSequenceVal(Index : Integer) : String;
begin
  Result := SGAddedPropList.Rows[Index].Strings[1];
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.GetPropVal(Index : Integer) : string;
begin
  Result := SGAddedPropList.Rows[Index].Strings[0];
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.GetPropRsc(Index : Integer) : string;
begin
  Result := SGAddedPropList.Rows[Index].Strings[3];
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.GetValFrom(Index : Integer) : string;
begin
  Result := SGAddedPropList.Rows[Index].Strings[1];
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.GetValTo(Index : Integer) : string;
begin
  Result := SGAddedPropList.Rows[Index].Strings[2];
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.GetBooleanVal(Index : Integer) : boolean;
var
  CheckBox : TCheckBox;
begin
  Result := false;
  CheckBox := (SGAddedPropList.Objects[2, Index] as TCheckBox);
  if Assigned(CheckBox) then
    Result := CheckBox.checked;
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.GetPropDescVal(Index : Integer) : string;
begin
  Result := SGAddedPropList.Rows[Index].Strings[2];
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SetPropVal(Code : string; Index : Integer ; First : boolean);
begin
  if not First then
    SGAddedPropList.RowCount := SGAddedPropList.RowCount + 1
  else
    m_Firstval := false;
  SGAddedPropList.Rows[Index].Strings[0] := Code;
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SetPropDescVal(Code: string; desc : string; Index: Integer; First: boolean; Val : string);
var
  PropId : TPropId;
  NewCheckBox : TCheckBox;
begin
  if not First then
    SGAddedPropList.RowCount := SGAddedPropList.RowCount + 1
  else
    m_Firstval := false;
  SGAddedPropList.Rows[Index].Strings[0] := Code;
  SGAddedPropList.Rows[Index].Strings[1] := desc;

  PropId := GetIdFromCode(Code);
  if IsAssignedBooleanProp1(PropId) then
  begin
    NewCheckBox := TCheckBox.Create(Application);
    NewCheckBox.Width := 0;
    NewCheckBox.Visible := false;
    NewCheckBox.Caption := _('Yes');
    NewCheckBox.Color := clWindow;
    NewCheckBox.Parent := self;
    SGAddedPropList.Objects[2, Index] := NewCheckBox;
    if val <> '1' then
      NewCheckBox.Checked := false
    else
      NewCheckBox.Checked := true;
  end
  else
    SGAddedPropList.Rows[Index].Strings[2] := val;
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SetPropRes(ResCode: string; Index: Integer);
begin
  SGAddedPropList.Rows[Index].Strings[3] := ResCode;
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SetValFrom(ValFrom : string ; Index : Integer);
begin
  SGAddedPropList.Rows[Index].Strings[1] := ValFrom;
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SetValTo(ValTo : string ; Index : Integer);
begin
  SGAddedPropList.Rows[Index].Strings[2] := ValTo;
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SetColWidth(ColNr : Integer; Width : Integer);
begin
  SGPropList.ColWidths[ColNr] := Width
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.CheckDoubleProp : boolean;
var
  PropCode: string;
  I : Integer;
begin
  Result := true;
  PropCode := SGPropList.Rows[SGPropList.Row].Strings[0];
  for I := 0 to SGAddedPropList.RowCount - 1 do
    if PropCode = SGAddedPropList.Rows[I].Strings[0] then
    begin
      Result := false;
      Showmessage(_('Property code already exist'));
    end;
end;

//----------------------------------------------------------------------------------------------

function TPropComponent.CheckLimitRows : boolean;
begin
  Result := true;
  if (SGAddedPropList.RowCount > 60) and ((m_GridType = TabProp) or (m_GridType = SelectedProp)) then
    Result := false;
end;

//----------------------------------------------------------------------------------------------

Function TPropComponent.GetNumericPropList : TList;
var
  Code, Desc : string;
  PType : CScPropType;
  I: Integer;
  PropId : TPropId;
begin
  Result := TList.Create;

  for I := 0 to GetPropertyCount - 1 do
  begin
    code := GetNextProp(I,Desc,PType);

    if (PType = CSA_Numerc) then
    begin
      PropId := GetIdFromCode(Code);
      if not IsPropNumeric(PropId) then
        continue;

      Result.Add(PropId);
    end
  end;

end;

procedure TPropComponent.GetPropertyList;
var
  Code,Desc : string;
  PType : CScPropType;
  I,J,k : Integer;
  PropId : TPropId;
begin

  J := 1;
  for I := 0 to GetPropertyCount - 1 do
  begin
    K := 0;
    code := GetNextProp(I,Desc,PType);

    if (m_GridType = PropAsDate) then
    begin
      if (PType = CSA_Alpha) then
      begin
        PropId := GetIdFromCode(Code);
        if GetLength(PropId) <> 8 then
          continue;
      end
      else
        continue;
    end;

    if (m_GridType = PropAsRGB) then
    begin
      if (PType = CSA_Alpha) then
      begin
        PropId := GetIdFromCode(Code);
        if GetLength(PropId) <> 6 then
          continue;
      end
      else
        continue;
    end;

   { if (m_GridType = Groupby) then
    begin
      if (PType = CSA_Numerc) then
      begin
        PropId := GetIdFromCode(Code);
        if not IsPropNumeric(PropId) then
          continue;
      end
      else
        continue;
    end;       }


    SGPropList.Cells[K,J] := code;
    Inc(K);
    SGPropList.Cells[K,J] := Desc;
    Inc(K);
    if (PType = CSA_Alpha) then
      SGPropList.Cells[K,J] := 'A'
    else if (PType = CSA_Numerc) then
      SGPropList.Cells[K,J] := 'N'
    else if (PType = CSA_Dynamic) then
      SGPropList.Cells[K,J] := 'D';
    Inc(J);
    SGPropList.RowCount := SGPropList.RowCount + 1;

  end;
  SGPropList.RowCount := SGPropList.RowCount - 1;

end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SetJobProp(Prop : TProperties);
var
  Code,Desc : string;
  I,J,k : Integer;
  val: variant;
  PropId : TPropID;
  PType : CScPropType;
begin

  J := 1;
  for I := 0 to GetPropertyCount - 1 do
  begin
    K := 0;
    code := GetNextProp(I,Desc,PType);

    SGPropList.Cells[K,J] := code;
    Inc(K);
    SGPropList.Cells[K,J] := Desc;
    Inc(K);
    if (PType = CSA_Alpha) then
      SGPropList.Cells[K,J] := 'A'
    else if (PType = CSA_Numerc) then
      SGPropList.Cells[K,J] := 'N'
    else if (PType = CSA_Dynamic) then
      SGPropList.Cells[K,J] := 'D';
    PropId := GetPropFromPos(I);
    if Prop.GetValforProp(PropId , val) then
    begin
      Inc(K);
      SGPropList.Cells[K,J] := val;
    end;

    Inc(J);
    SGPropList.RowCount := SGPropList.RowCount + 1;

  end;
  SGPropList.RowCount := SGPropList.RowCount - 1;

end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SetJobPropPlannerDefine(Prop : TProperties; ID : TSchedID);
var
  Code, desc : string;
  I,J,k,P : Integer;
  val: variant;
  PropIdJob,PropId : TPropID;
  PType : CScPropType;
  jobPropVal:  variant;
  RscCode : string;
  tpLink: TCompatTopoLink;
  mtx:    TCompatMatrix;
  PropIdJobFound : boolean;
  wkc: TMqmWrkCtr;
begin
  PropIdJobFound := false;
  J := 1;
  P := 1;
  for I := 0 to Prop.p_PropCount - 1 do
  begin
    K := 0;
    jobPropVal := prop.GetProperty(i, PropIdJob, RscCode);
    if not IsPropPlanner(PropIdJob) then continue;

    code := GetPropCodeFromID(PropIdJob);
    SGPropList.Cells[K,J] := code;
    Inc(K);
    SGPropList.Cells[K,J] := GetPropDescr(PropIdJob);
    Inc(K);

    PType := GetPropType(PropIdJob);

    if (PType = CSA_Alpha) then
      SGPropList.Cells[K,J] := 'A'
    else if (PType = CSA_Numerc) then
      SGPropList.Cells[K,J] := 'N'
    else if (PType = CSA_Dynamic) then
      SGPropList.Cells[K,J] := 'D';

    if Prop.GetValforProp(PropIdJob , val) then
    begin
      code := GetPropCodeFromID(PropIdJob);
      desc := GetPropDescr(PropIdJob);
      if P = 1 then
        SetPropDescVal(Code, desc, P, true, val)
      else
        SetPropDescVal(Code, desc, P, false, val);
      m_Firstval := false;
      Inc(p);
    end;

    Inc(J);
    SGPropList.RowCount := SGPropList.RowCount + 1;
  end;

  for I := 0 to GetPropertyCount - 1 do
  begin
    K := 0;
    PropId := GetPropFromPos(I);
    if not IsPropPlanner(PropId) then continue;
    for P := 0 to Prop.p_PropCount - 1 do
    begin
      PropIdJobFound := false;
      jobPropVal := prop.GetProperty(p, PropIdJob, RscCode);
      if (PropId = PropIdJob) then
      begin
        PropIdJobFound := true;
        break
      end;
    end;
    if PropIdJobFound then continue;
    GetPropCoordForValue(PropId, tpLink, mtx);
  //  if (tpLink <> CTL_wkc) and (tpLink <> CTL_global) then continue;

    if (tpLink = CTL_wkc) then
    begin
      wkc := p_sc.GetWrkCtrPtr(id);
      if not Assigned(wkc) then continue;
      if not wkc.GetPropIdInWrctrLevelList(PropId) then continue;
    end;

    code := GetPropCodeFromID(PropId);
    SGPropList.Cells[K,J] := code;
    Inc(K);
    SGPropList.Cells[K,J] := GetPropDescr(PropId);
    Inc(K);
    PType := GetPropType(PropId);
    if (PType = CSA_Alpha) then
      SGPropList.Cells[K,J] := 'A'
    else if (PType = CSA_Numerc) then
      SGPropList.Cells[K,J] := 'N'
    else if (PType = CSA_Dynamic) then
      SGPropList.Cells[K,J] := 'D';

    Inc(J);
    SGPropList.RowCount := SGPropList.RowCount + 1;

  end;

  SGPropList.RowCount := SGPropList.RowCount - 1;
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.Loadcaptions;
begin
  with SGPropList do
  begin
    Cells[0,0] := _(' Property code');
    Cells[1,0] := _(' Description');
    Cells[2,0] := _('Type');
    Cells[3,0] := _(' Values');
  end;

  with SGAddedPropList do
  begin
    Cells[0,0] := _(' Property code');
    if (m_GridType = TabProp) or (m_GridType = TabReqProp) then
    begin
      Cells[1,0] := _(' Value from');
      Cells[2,0] := _(' Value to');
      Cells[3,0] := _(' Res. code');
    end
    else if (m_GridType = CapResProp) or (m_GridType = PlannerPropDef) then
    begin
      Cells[1,0] := _(' Description');
      Cells[2,0] := _(' Value');
    end else if (m_GridType = GroupBy) then
      Cells[1,0] := _(' Sequence');

  end;

end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SGAddedPropListSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  IsDateProp : boolean;
  PropId : TPropId;
  Calendar: TCalendar;
  TmpDate : TDateTime;
begin
  IsDateProp := false;
  if (m_GridType = PlannerPropDef) and (ACol = 2) then
  begin
    PropId := GetIdFromCode(SGAddedPropList.Rows[ARow].Strings[0]);
  //  SetUserAsDateProp(PropId, true); // to be remove !
    IsDateProp := IsPropAsDate(PropId);
  end;

  SGAddedPropList.Options := [goTabs, goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine];

  if (m_GridType <> CapResProp) and (m_GridType <> PlannerPropDef) and (ACol = 1) then
    SGAddedPropList.Options := [goTabs, goFixedVertLine,goFixedHorzLine,goEditing,goVertLine,goHorzLine]

  else if (m_GridType = PlannerPropDef) and IsDateProp then
  begin
    SGAddedPropList.Selection := TGridRect(Rect(-1,-1,-1,-1));
    Calendar := TCalendar.CreateCalendarUserEnter(self, PropComp, SGAddedPropList.Rows[ARow].Strings[0], SGAddedPropList.Rows[ARow].Strings[2]);
    if Calendar.ShowModal = mrOk then
    begin
      TmpDate := Calendar.GetDate;
      if TmpDate = 0 then
        SGAddedPropList.Rows[ARow].Strings[2] := ''
      else
        SGAddedPropList.Rows[ARow].Strings[2] := DateToStr(Calendar.GetDate)
    end;
    Calendar.Free;
  end

  else if ((m_GridType = CapResProp) or (m_GridType = PlannerPropDef)) and (ACol = 2) then
    SGAddedPropList.Options := [goTabs, goFixedVertLine,goFixedHorzLine,goEditing,goVertLine,goHorzLine]

  else if (m_GridType = TabProp) and ((ACol = 2) or (ACol = 3)) then
    SGAddedPropList.Options := [goTabs, goFixedVertLine,goFixedHorzLine,goEditing,goVertLine,goHorzLine];

end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SGPropListDblClick(Sender: TObject);
begin
  BtnAddClick(Sender)
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SGAddedPropListDblClick(Sender: TObject);
begin
//  BtnRemoveClick(Sender)
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.BtnAddClick(Sender: TObject);
var
  I : Integer;
  PropId : TPropId;
  NewCheckBox : TCheckBox;
begin
  if (m_GridType <> TabProp) and not CheckDoubleProp then
    Exit;

  if (m_GridType <> TabProp) and not CheckLimitRows then
  begin
    Showmessage(_('Can not insert more then 60 properties'));
    exit;
  end;

  if assigned(m_ChkOnAddFunc) and not m_ChkOnAddFunc(SGPropList.Rows[SGPropList.Row].Strings[0]) then
    exit;

  if m_Firstval and (SGAddedPropList.RowCount = 2) then
  begin
    if (m_GridType = CapResProp) or (m_GridType = PlannerPropDef) then
    begin
      SGAddedPropList.Cells[0 ,SGAddedPropList.RowCount-1] := SGPropList.Rows[SGPropList.Row].Strings[0];
      SGAddedPropList.Cells[1 ,SGAddedPropList.RowCount-1] := SGPropList.Rows[SGPropList.Row].Strings[1];
      m_FirstVal := false;
      if (SGPropList.Row < SGPropList.RowCount-1) then
        SGPropList.Row := SGPropList.Row + 1;

      if m_GridType = PlannerPropDef then
      begin
        PropId := GetIdFromCode(SGAddedPropList.Cells[0 ,SGAddedPropList.RowCount-1]);
        if IsAssignedBooleanProp1(PropId) then
        begin
          NewCheckBox := TCheckBox.Create(Application);
          NewCheckBox.Width := 0;
          NewCheckBox.Visible := false;
          NewCheckBox.Caption := _('Yes');
          NewCheckBox.Color := clWindow;
          NewCheckBox.Parent := self;
          SGAddedPropList.Objects[2, SGAddedPropList.RowCount-1] := NewCheckBox;
        end;
      end;
      exit;
    end
    else
    begin
      SGAddedPropList.Cells[0 ,SGAddedPropList.RowCount-1] := SGPropList.Rows[SGPropList.Row].Strings[0];
      if (m_GridType = TabReqProp) then
        SGAddedPropList.Cells[1 ,SGAddedPropList.RowCount-1] := SGPropList.Rows[SGPropList.Row].Strings[3];
      m_FirstVal := false;
      if (SGPropList.Row < SGPropList.RowCount-1) then
        SGPropList.Row := SGPropList.Row + 1;
      exit;
    end;
  end;

  SGAddedPropList.RowCount := SGAddedPropList.RowCount + 1;
  SGAddedPropList.Cells[0 ,SGAddedPropList.RowCount-1] := SGPropList.Rows[SGPropList.Row].Strings[0];

  if (m_GridType = CapResProp) or (m_GridType = PlannerPropDef) then
    SGAddedPropList.Cells[1 ,SGAddedPropList.RowCount-1] := SGPropList.Rows[SGPropList.Row].Strings[1];

  if (m_GridType = TabReqProp) then
    SGAddedPropList.Cells[1 ,SGAddedPropList.RowCount-1] := SGPropList.Rows[SGPropList.Row].Strings[3]
  else
  begin

    if (m_GridType = CapResProp) or (m_GridType = PlannerPropDef) then
    begin
      for i := 2 to SGAddedPropList.ColCount - 1 do
        SGAddedPropList.Cells[i ,SGAddedPropList.RowCount-1] := '';
    end
    else
      for i := 1 to SGAddedPropList.ColCount - 1 do
        SGAddedPropList.Cells[i ,SGAddedPropList.RowCount-1] := '';

  end;
  if (SGPropList.Row < SGPropList.RowCount-1) then
    SGPropList.Row := SGPropList.Row + 1;

  if m_GridType = PlannerPropDef then
  begin
    PropId := GetIdFromCode(SGAddedPropList.Cells[0 ,SGAddedPropList.RowCount-1]);
    if IsAssignedBooleanProp1(PropId) then
    begin
      NewCheckBox := TCheckBox.Create(Application);
      NewCheckBox.Width := 0;
      NewCheckBox.Visible := false;
      NewCheckBox.Caption := _('Yes');
      NewCheckBox.Color := clWindow;
      NewCheckBox.Parent := self;
      SGAddedPropList.Objects[2, SGAddedPropList.RowCount-1] := NewCheckBox;
    end;
  end;

end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.BtnRemoveClick(Sender: TObject);
begin
  clean_previus_buffer;
  RemoveRowFromStrGrid(SGAddedPropList, SGAddedPropList.row, SGAddedPropList.row);
  if Assigned(m_OnChgFunc) then
    m_OnChgFunc;

  if (SGAddedPropList.RowCount = 2) and (SGAddedPropList.Rows[1].Strings[0] = '') then
    m_Firstval := true;

end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.set_checkbox_alignment;
var
  I : Integer;
  NewCheckBox : TCheckBox;
  Rect: TRect;
begin
  for i := 1 to SGAddedPropList.RowCount do
  begin
    NewCheckBox := (SGAddedPropList.Objects[2 , I] as TCheckBox);
    if NewCheckBox <> nil then
    begin
      Rect := SGAddedPropList.CellRect(2, I);
      NewCheckBox.Left := SGAddedPropList.Left + Rect.Left + 2;
      NewCheckBox.Top := SGAddedPropList.Top + Rect.Top + 2;
      NewCheckBox.Width := Rect.Right - Rect.Left;
      NewCheckBox.Height := Rect.Bottom - Rect.Top;
      NewCheckBox.Visible := True;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.clean_previus_buffer;
var
  NewCheckBox : TCheckBox;
begin
  NewCheckBox := (SGAddedPropList.Objects[2, SGAddedPropList.Row] as TCheckBox);
  if NewCheckBox <> nil then
  begin
    NewCheckBox.Visible := false;
    SGAddedPropList.Objects[2, SGAddedPropList.Row] := nil;
  end;
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SGAddedPropListGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
var
  IsAlpha : boolean;
  IsDateProp : boolean;
  PropId : TPropId;
begin

  IsDateProp := false;
  if (m_GridType = PlannerPropDef) and (ACol = 2) then
  begin
    PropId := GetIdFromCode(SGAddedPropList.Rows[ARow].Strings[0]);
    IsDateProp := IsPropAsDate(PropId);
  end;

  if SGAddedPropList.Rows[ARow].Strings[0] = '' then
  begin
    SGAddedPropList.Options := [goTabs, goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine];
    Abort;
  end
  else if (m_GridType = PlannerPropDef) and IsDateProp then
  begin
    SGAddedPropList.Options:= SGAddedPropList.Options - [goEditing, goRangeSelect];
  end
  else
    SGAddedPropList.Options := [goTabs, goFixedVertLine,goFixedHorzLine,goEditing,goVertLine,goHorzLine];

  IsAlpha := IsPropAlpha(SGAddedPropList.Rows[ARow].Strings[0]);
  if IsAlpha then
    m_AlfaCode := true
  else m_AlfaCode := false;

end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SGAddedPropListKeyPress(Sender: TObject; var Key: Char);
begin

  if NumberOnly then
  begin
    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (key = chr(VK_DELETE))) then
      abort;

    if Key = '.' then abort
    
  end;

  if not m_AlfaCode then
    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (key = chr(VK_DELETE)) or (Key = chr(24)) or (Key = ',') or (Key = '%')) then
      abort;

end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SetError(RowNr: Integer);
begin
   SGAddedPropList.Cells[2,RowNr] := _('Warning');
end;

//----------------------------------------------------------------------------------------------

procedure TPropComponent.SGAddedPropListDrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var
  OldColor : TColor;
  OldBrush : TBrush;
  TempPString:Array [0..255] of char;

begin
  if (gdFixed in State){or (gdSelected in State)} then exit;

  set_checkbox_alignment;

  if m_GridType = CapResProp then
  begin
    with SGAddedPropList.Canvas do
    begin
      OldColor := Font.Color;
      OldBrush := Brush;

      if SGAddedPropList.Cells[2,Row] = _('Warning') then
      begin
        FillRect(Rect);
        Font.Color := clRed;
        StrPCopy(TempPString,SGAddedPropList.Cells[Col,Row]);
        DrawText(Handle,TempPString,-1,Rect,DT_LEFT);
      end;
      Font.Color := OldColor;
      Brush := OldBrush;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------


procedure TPropComponent.SGAddedPropListOnExit(Sender: TObject);
begin
  if Assigned(m_OnChgFunc) then
    m_OnChgFunc;

end;

//----------------------------------------------------------------------------------------------

end.



