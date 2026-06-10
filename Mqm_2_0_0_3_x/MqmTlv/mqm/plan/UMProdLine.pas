unit UMProdLine;

interface

uses
  classes,
  UMPlanObj,
  UMDurObj;

type

  TMqmProdLine = class(TMqmPlanObj)
    constructor CreateProdLine(Code: string);
    destructor  Destroy; override;
  private
    m_ActPeriods: TDurList;
    m_Code: string;
    function ActPerCount: integer;
    function GetActPer(i: integer): TMqmPlanObj;
  public
    function GetDescr: string; override;
    procedure AddActPeriod(ActPeriod: TMqmDurObj);

    property p_ProdLineCode: string    read m_code;
    property p_ActPerCount: integer                  read ActPerCount;
    property p_ActPer[i: integer]: TMqmPlanObj       read GetActPer;
  end;
  
implementation

//----------------------------------------------------------------------------//

constructor TMqmProdLine.CreateProdLine(Code: string);
begin
  inherited Create;
  m_Code := Code;
end;

//----------------------------------------------------------------------------//

destructor TMqmProdLine.Destroy;
begin
  inherited Destroy;
  m_ActPeriods.Free;
end;

//----------------------------------------------------------------------------//

procedure TMqmProdLine.AddActPeriod(ActPeriod: TMqmDurObj);
begin
  if not Assigned(m_ActPeriods) then
    m_ActPeriods := TDurList.Create(self);

  m_ActPeriods.Add(ActPeriod);
  ActPeriod.p_Father := self;
  ActPeriod.m_plan := m_plan
end;

//----------------------------------------------------------------------------//

function TMqmProdLine.ActPerCount: integer;
begin
  if Assigned(m_ActPeriods) then
    Result := m_ActPeriods.Count
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TMqmProdLine.GetActPer(i: integer): TMqmPlanObj;
begin
  Assert((i >= 0) and (i < m_ActPeriods.Count));
  Result := TMqmPlanObj(m_ActPeriods[i])
end;

//----------------------------------------------------------------------------//

function TMqmProdLine.GetDescr: string;
begin
  Result := '';
end;

end.
