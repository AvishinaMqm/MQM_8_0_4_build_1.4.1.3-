unit UMPriorities;

interface

uses
  classes,
  UMCommon,
  stdctrls,
  DMSrvPC,
  gnugettext;

type
  TMPriorities = class
    constructor Create;
    destructor  Destroy; override;

    procedure Clear;
    procedure LoadFromDb(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText);
    function  GetPriority(WrkCtrCode, WrkCtrProc: string): integer;
  private
    m_list: TStringList;
    procedure AddPriority(WrkCtrCode, WrkCtrProc: string; Priority: string);
  end;

implementation

Uses
  UMTblDesc;

//----------------------------------------------------------------------------//

constructor TMPriorities.Create;
begin
  inherited Create;
  m_list := TStringList.Create;
end;

//----------------------------------------------------------------------------//

destructor TMPriorities.Destroy;
begin
  Clear;

  m_list.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMPriorities.Clear;
var
  i: integer;
begin
  for i := 0 to m_list.Count-1 do
    TStringList(m_list.Objects[i]).Free;

  m_list.Clear;
end;

//----------------------------------------------------------------------------//

procedure TMPriorities.LoadFromDb(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText);
var
  tbInfoPrior: ^TTblInfo;
begin
  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading priorities from database...');

  Clear;
  tbInfoPrior := @tblInfo[tbl_wkc_priority];
  SetFldPfx(tbInfoPrior.pfx);

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select *');
    SQL.Add(' from ' + tbInfoPrior.GetTableName);
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfoPrior.pfx, fli_Identifier)));

    Transaction.StartTransaction;

    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(2000);
    if Assigned(Status) then
      Status.Caption := _('Loading priorities in memory...');

    while not EOF do
    begin
      AddPriority(FieldByName(CreatePfxFld(fli_wkCtrCode)).AsString,
                  FieldByName(CreatePfxFld(fli_wkcProc)).AsString,
                  FieldByName(CreatePfxFld(fli_SeqAlpha)).AsString);
      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
    end;

    Close;
    Transaction.Commit
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
end;

//----------------------------------------------------------------------------//

function TMPriorities.GetPriority(WrkCtrCode, WrkCtrProc: string): integer;
var
  i,j: integer;
  WCList: TStringList;
begin
  Result := -1;
  i := m_list.IndexOf(WrkCtrCode);

  if i = -1 then exit;

  WCList := TStringList(m_list.Objects[i]);
  j := WCList.IndexOf(WrkCtrProc);

  if j = -1 then exit;

  Result := integer(WCList.Objects[j]);
end;

//----------------------------------------------------------------------------//

procedure TMPriorities.AddPriority(WrkCtrCode, WrkCtrProc: string; Priority: string);
var
  i,j: integer;
  WCList: TStringList;
begin

  i := m_list.IndexOf(WrkCtrCode);

  if i = -1 then
  begin
    m_list.Add(WrkCtrCode);
    i := m_list.IndexOf(WrkCtrCode);
    m_list.Objects[i] := TStringList.Create;
  end;

  WCList := TStringList(m_list.Objects[i]);
  j := WCList.IndexOf(WrkCtrProc);

  if j = -1 then
  begin
    WCList.Add(WrkCtrProc);
    j := WCList.IndexOf(WrkCtrProc);
  end;

  WCList.Objects[j] := TObject(Priority);
end;

end.
