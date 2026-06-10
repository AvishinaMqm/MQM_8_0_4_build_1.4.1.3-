unit UMArticle;

interface

uses
  classes,
  forms,
  UMCommon,
  stdctrls,
  DMSrvPC,
  gnugettext;

type

  TArticle = class
  private
    m_List : TList;
    procedure Clear;
  public
    procedure LoadFromDb(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText);
    function  GetCount : integer;
    function  GetNext(Index : Integer) : string;
    function  GetLDesc(Code : string) : string;
    function  GetSDesc(Code : string) : string;
    function  GetNumberOfDecimal(Code : string) : Integer;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses UMTblDesc;

type

  RecArticle = record
    Code : string;
    NumberOfDecimal : integer;
    LDesc : string;
    SDesc : string;
  end;
  PRecArticle = ^RecArticle;

{ TArticle }

procedure TArticle.Clear;
var
  I : Integer;
begin
  for I := 0 to m_List.Count - 1 do
    Dispose(PRecArticle(m_list[I]));
end;

//----------------------------------------------------------------------------//

constructor TArticle.Create;
begin
  Inherited create;
  m_List := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TArticle.Destroy;
begin
  clear;
  m_List.free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TArticle.GetCount : integer;
begin
  Result := m_List.count
end;

//----------------------------------------------------------------------------//

function TArticle.GetNext(Index : Integer) : string;
begin
  Assert(Index <= m_List.count);
  Result := PRecArticle(m_List[Index]).Code
end;

//----------------------------------------------------------------------------//

function TArticle.GetLDesc(Code: string): string;
var
  I : Integer;
begin
  Result := '';
  for I := 0 to m_List.count - 1 do
  begin
    if Code = PRecArticle(m_List[I]).Code then
    begin
      Result := PRecArticle(m_List[I]).LDesc;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TArticle.GetSDesc(Code: string): string;
var
  I : Integer;
begin
  Result := '';
  for I := 0 to m_List.count - 1 do
  begin
    if Code = PRecArticle(m_List[I]).Code then
    begin
      Result := PRecArticle(m_List[I]).SDesc;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TArticle.GetNumberOfDecimal(Code : string) : Integer;
var
  I : Integer;
begin
  Result := 2;
  for I := 0 to m_List.count - 1 do
  begin
    if Code = PRecArticle(m_List[I]).Code then
    begin
      Result := PRecArticle(m_List[I]).NumberOfDecimal;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TArticle.LoadFromDb(qry: TMqmQuery; ProgBar: TMqmProgBar;
  Status: TStaticText);
var
  tbArtcle : ^TTblInfo;
  RecArti : PRecArticle;
begin
  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading article type from Database...');

  Application.ProcessMessages;

  tbArtcle := @tblInfo[tbl_arty];

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select');
    SQL.Add(CreateFld(tbArtcle.pfx, fli_ArtType)  + ',');
    SQL.Add(CreateFld(tbArtcle.pfx, fli_BalanceDecNum)  + ',');
    SQL.Add(CreateFld(tbArtcle.pfx, fli_SDescr)   + ',');
    SQL.Add(CreateFld(tbArtcle.pfx, fli_LDescr));
    SQL.Add(' from ' + tbArtcle.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbArtcle.pfx, fli_Identifier)));
    open;

    Application.ProcessMessages;

    if Assigned(ProgBar) then
      ProgBar.SetMax(1000);
    if Assigned(Status) then
      Status.Caption := _('Loading article type descriptions in memory...');

    Application.ProcessMessages;

    while not Eof do
    begin
      Application.ProcessMessages;

      new(RecArti);
      RecArti.Code := FieldByName(CreateFld(tbArtcle.pfx,fli_ArtType)).AsString;
      RecArti.NumberOfDecimal := FieldByName(CreateFld(tbArtcle.pfx,fli_BalanceDecNum)).AsInteger;
      RecArti.LDesc := FieldByName(CreateFld(tbArtcle.pfx,fli_SDescr)).AsString;
      RecArti.SDesc := FieldByName(CreateFld(tbArtcle.pfx,fli_LDescr)).AsString;
      m_List.add(RecArti);
      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
      Application.ProcessMessages;
    end;

  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
  Application.ProcessMessages;
end;

//----------------------------------------------------------------------------//

end.

