unit UGCustomList;

interface

uses Classes;

type
  TMQMCustomList = class
  private
    m_List: TList;
    m_Sorted: boolean;
    function GetCount: Integer;
    function GetItem(Index: integer): Pointer;
  public
    constructor Create;
    destructor Destroy; override;
    function AddItem(Item: Pointer): integer;
    function RemoveItem(Item: Pointer): integer;
    procedure Insert(Index: Integer; Item: Pointer);
    procedure SortList(Compare: TListSortCompare);
    procedure CleanList;
    property p_count: Integer read GetCount;
    property p_Item[i: integer]: Pointer read GetItem;
    property p_GetList : TList read m_list;
  end;

implementation


{
******************************** TMQMCustomList ********************************
}
function TMQMCustomList.GetCount: Integer;
begin
  Result := m_List.Count
end;

//----------------------------------------------------------------------------//

function TMQMCustomList.GetItem(Index: integer): Pointer;
begin
  Result := m_List[Index]
end;

//----------------------------------------------------------------------------//

constructor TMQMCustomList.Create;
begin
  m_List := TList.Create;
  m_Sorted := false;
end;

//----------------------------------------------------------------------------//

destructor TMQMCustomList.Destroy;
begin
  m_List.Free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TMQMCustomList.AddItem(Item: Pointer): integer;
begin
  Result := m_List.Add(Item);
  m_Sorted := false;
end;

//----------------------------------------------------------------------------//

function TMQMCustomList.RemoveItem(Item: Pointer): integer;
begin
  Result := m_List.Remove(Item);
  m_Sorted := false;
end;

//----------------------------------------------------------------------------//

procedure TMQMCustomList.Insert(Index: Integer; Item: Pointer);
begin
  m_List.Insert(Index,item);
end;

//----------------------------------------------------------------------------//
procedure TMQMCustomList.CleanList;
begin
  m_List.Clear;
end;

//----------------------------------------------------------------------------//

procedure TMQMCustomList.SortList(Compare: TListSortCompare);
begin
  if not m_Sorted then
  begin
    m_List.Sort(Compare);
    m_Sorted := true;
  end
end;

end.
