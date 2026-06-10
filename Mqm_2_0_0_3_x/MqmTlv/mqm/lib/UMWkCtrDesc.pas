unit UMWkCtrDesc;

interface

uses
  classes,
  forms,
  UMCommon,
  stdctrls,
  DMSrvPC,
  gnugettext;

type

  TWorkCntrDesc = class
  private
    m_List : TList;
    procedure Clear;
  public
    procedure LoadFromDb(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText);
    function  GetLDesc(Code : string) : string;
    function  GetSDesc(Code : string) : string;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  UMTblDesc, DB;

type

  RecWrkCtrDesc = record
    Code : string;
    LDesc : string;
    SDesc : string;
  end;
  PRecWrkCtrDesc = ^RecWrkCtrDesc;

{ WorkCntrDesc }

//----------------------------------------------------------------------------//

procedure TWorkCntrDesc.Clear;
var
  I : Integer;
begin
  for I := 0 to m_List.Count - 1 do
    Dispose(PRecWrkCtrDesc(m_list[I]));
end;

//----------------------------------------------------------------------------//

constructor TWorkCntrDesc.Create;
begin
  Inherited create;
  m_List := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TWorkCntrDesc.Destroy;
begin
  clear;
  m_List.free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TWorkCntrDesc.GetLDesc(Code: string): string;
var
  I : Integer;
begin
  Result := '';
  for I := 0 to m_List.count - 1 do
  begin
    if Code = PRecWrkCtrDesc(m_List[I]).Code then
    begin
      Result := PRecWrkCtrDesc(m_List[I]).LDesc;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TWorkCntrDesc.GetSDesc(Code: string): string;
var
  I : Integer;
begin
  Result := '';
  for I := 0 to m_List.count - 1 do
  begin
    if Code = PRecWrkCtrDesc(m_List[I]).Code then
    begin
      Result := PRecWrkCtrDesc(m_List[I]).SDesc;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TWorkCntrDesc.LoadFromDb(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText);
var
  tbInfoWkc : ^TTblInfo;
  RecWorkCnr : PRecWrkCtrDesc;
begin
  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading workcenter descriptions from database...');
  Application.ProcessMessages;

  tbInfoWkc := @tblInfo[tbl_wkc];

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select');

    SQL.Add(CreateFld(tbInfoWkc.pfx,fli_wkCtrCode)  + ',');
    SQL.Add(CreateFld(tbInfoWkc.pfx,fli_SDescr)   + ',');
    SQL.Add(CreateFld(tbInfoWkc.pfx,fli_LDescr));
    SQL.Add(' from ' + tbInfoWkc.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoWkc.pfx, fli_Identifier)));
    open;

    Application.ProcessMessages;

    if Assigned(ProgBar) then
      ProgBar.SetMax(1000);
    if Assigned(Status) then
      Status.Caption := _('Loading workcenter descriptions in memory...');

    Application.ProcessMessages;

    while not Eof do
    begin
      Application.ProcessMessages;
      new(RecWorkCnr);
      RecWorkCnr.Code := FieldByName(CreateFld(tbInfoWkc.pfx,fli_wkCtrCode)).AsString;
      RecWorkCnr.LDesc := FieldByName(CreateFld(tbInfoWkc.pfx,fli_SDescr)).AsString;
      RecWorkCnr.SDesc := FieldByName(CreateFld(tbInfoWkc.pfx,fli_LDescr)).AsString;
      m_List.add(RecWorkCnr);
      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
    end;

    Close;

  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';

  Application.ProcessMessages;
end;

end.

