unit UMDescUm;

interface

uses
  classes,Sysutils;

type

  TUMDesc = class
  private
    m_list: TList;
    procedure Clear;
    procedure AddUMDesc(Um : string; SDesc : string ; LDesc : string; NumOfDecimals : integer = 2);
  public
    procedure LoadFromDb;
    destructor Destroy; override;
    constructor Create;
  end;

  procedure LoadUMDesc;
  function GetSUmDesc(Um : string) : string;
  function GetLUmDesc(Um : string) : string;
  function GetUmNumOfDecimals(Um : string) : integer;

implementation

uses DMSrvPC, UMTblDesc, UMCOmmon, DB;

type

  TRecUnitDesc = record
    Um : string;
    LDesc : string;
    SDesc : string;
    NumOfDecimals : integer;
  end;
  PRecUnitDesc = ^TRecUnitDesc;

var
  s_UnitDesc : TUMDesc;

//----------------------------------------------------------------------------//

procedure LoadUMDesc;
begin
  if not Assigned(s_UnitDesc) then
    s_UnitDesc := TUMDesc.Create;
end;

//----------------------------------------------------------------------------//

procedure TUMDesc.AddUMDesc(Um : string; SDesc : string ; LDesc : string; NumOfDecimals : integer = 2);
var
  RecUnitDesc : PRecUnitDesc;
begin
  New(RecUnitDesc);
  RecUnitDesc.Um := Um;
  RecUnitDesc.SDesc := SDesc;
  RecUnitDesc.LDesc := LDesc;
  RecUnitDesc.NumOfDecimals := NumOfDecimals;
  m_list.add(RecUnitDesc)
end;

//----------------------------------------------------------------------------//

procedure TUMDesc.Clear;
var
  i: integer;
begin
  for i := 0 to m_list.Count-1 do
    Dispose(PRecUnitDesc(m_list[i]));

  m_list.Clear;
end;

//----------------------------------------------------------------------------//

constructor TUMDesc.Create;
begin
  m_list := TList.Create;
  LoadFromDb;
end;

//----------------------------------------------------------------------------//

destructor TUMDesc.Destroy;
begin
  clear;
  m_list.free;
  inherited destroy;
end;

procedure TUMDesc.LoadFromDb;
var
  qry: TMqmQuery;
  tbUmDesc : ^TTblInfo;
  fldDecNum : TField;
  numDec : integer;
begin
  tbUmDesc := @tblInfo[tbl_unit];
  qry := CreateQuery(Main_DB);
  with qry do
  begin
    SQL.Clear;
    SQL.Add('select *');
    SQL.Add(' from ' + tbUmDesc.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbUmDesc.pfx, fli_Identifier)));
    Open;

    fldDecNum := FindField(CreateFld(tbUmDesc.pfx, fli_DecNum));
    while not EOF do
    begin
      if Assigned(fldDecNum) then numDec := fldDecNum.AsInteger else numDec := 2;
      AddUMDesc(FieldByName(CreateFld(tbUmDesc.pfx, fli_Um)).AsString,
                  FieldByName(CreateFld(tbUmDesc.pfx, fli_SDescr)).AsString,
                  FieldByName(CreateFld(tbUmDesc.pfx, fli_LDescr)).AsString,
                  numDec);
      Next
    end;

    Close
  end;
  qry.Close;
  qry.free;
end;

//----------------------------------------------------------------------------//

function GetSUmDesc(Um : string) : string;
var
  I: Integer;
begin
  Result := '';
  if Assigned(s_UnitDesc) then
    for I := 0 to s_UnitDesc.m_list.Count - 1 do
      if PRecUnitDesc(s_UnitDesc.m_list[I]).Um = Um then
      begin
        Result := Trim(PRecUnitDesc(s_UnitDesc.m_list[I]).SDesc);
        exit
      end
end;

//----------------------------------------------------------------------------//

function GetLUmDesc(Um : string) : string;
var
  I: Integer;
begin
  Result := '';
  if Assigned(s_UnitDesc) then
    for I := 0 to s_UnitDesc.m_list.Count - 1 do
      if PRecUnitDesc(s_UnitDesc.m_list[I]).Um = Um then
      begin
        Result := Trim(PRecUnitDesc(s_UnitDesc.m_list[I]).LDesc);
        exit
      end
end;

//----------------------------------------------------------------------------//

function GetUmNumOfDecimals(Um : string) : integer;
var
  I: Integer;
begin
  Result := 2;
  if Assigned(s_UnitDesc) then
    for I := 0 to s_UnitDesc.m_list.Count - 1 do
      if PRecUnitDesc(s_UnitDesc.m_list[I]).Um = Um then
      begin
        Result := PRecUnitDesc(s_UnitDesc.m_list[I]).NumOfDecimals;
        exit
      end
end;

//----------------------------------------------------------------------------//

initialization

  s_UnitDesc := nil;

finalization

  if Assigned(s_UnitDesc) then
    s_UnitDesc.free;

//----------------------------------------------------------------------------//
end.
