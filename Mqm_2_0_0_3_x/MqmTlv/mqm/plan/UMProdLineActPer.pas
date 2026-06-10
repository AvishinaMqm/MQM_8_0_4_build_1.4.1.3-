unit UMProdLineActPer;

interface

uses
  UMDurObj;

type
  TMqmProdLnAtcPer = class(TMqmDurObj)
  public
    m_RscNum: integer;
    function GetDescr: string; override;
    procedure SetDur(durMin: integer); override;
    function  GetDur: integer; override;
  private
    m_Start: TDateTime;
    m_End  : TDateTime;
  protected
    procedure SetStart(date: TDateTime); override;
    procedure SetEnd(date: TDateTime);   override;
    function  GetStart: TDateTime;       override;
    function  GetEnd: TDateTime;         override;
  end;

implementation

//----------------------------------------------------------------------------//

procedure TMqmProdLnAtcPer.SetStart(date: TDateTime);
begin
  m_Start := date
end;

//----------------------------------------------------------------------------//

procedure TMqmProdLnAtcPer.SetDur(durMin: integer);
begin

end;

procedure TMqmProdLnAtcPer.SetEnd(date: TDateTime);
begin
  m_End := date
end;

//----------------------------------------------------------------------------//

function TMqmProdLnAtcPer.GetStart: TDateTime;
begin
  Result := m_Start
end;

//----------------------------------------------------------------------------//

function TMqmProdLnAtcPer.GetDur;
begin
  Result := 0;
end;

function TMqmProdLnAtcPer.GetEnd: TDateTime;
begin
  Result := m_End
end;

//----------------------------------------------------------------------------//

function TMqmProdLnAtcPer.GetDescr: string;
begin
  Result := '';
end;

//----------------------------------------------------------------------------//
end.

