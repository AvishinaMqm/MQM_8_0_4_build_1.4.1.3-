//The compatibilty bar between the capacity reservation and a job

unit UMCmp;

interface

uses
  classes,
  UMPlanObj,
  UMCompat,
  graphics,
  UMDurObj;

type

  TMqmCmp = class(TMqmDurObj)//class(TObject)
    constructor CreateMqmCmp;
    destructor  Destroy; override;

    procedure  GetColor(var int, brd: TColor);
    function  GetDescr: string; override;
    procedure SetStart(date: TDateTime); override;
    procedure SetEnd(date: TDateTime);   override;
    procedure SetDur(durMin: integer);   override;
    function  GetStart: TDateTime;       override;
    function  GetEnd: TDateTime;         override;
    function  GetDur: integer;           override;



  public
    m_diffVal: TCompatVal;
  end;

implementation

uses
  UGbaseCal;

//----------------------------------------------------------------------------//

constructor TMqmCmp.CreateMqmCmp;
begin
  inherited Create;
end;

//----------------------------------------------------------------------------//

destructor TMqmCmp.Destroy;
begin
  inherited Destroy
end;

//----------------------------------------------------------------------------//
//not used ?
procedure TMqmCmp.GetColor(var int, brd: TColor);
begin
  if m_diffVal < 30 then
    int := clWhite
  else if m_diffVal < 50 then
    int := clYellow
  else
    int := clblack;
  brd := int
end;

//----------------------------------------------------------------------------//

function TMqmCmp.GetDescr: string;
begin
  Result := '';
end;

function TMqmCmp.GetDur: integer;
begin
  Result := 0;
end;

function TMqmCmp.GetEnd: TDateTime;
begin
  Result := 0;
end;

function TMqmCmp.GetStart: TDateTime;
begin
  Result := 0;
end;

//----------------------------------------------------------------------------//

procedure TMqmCmp.SetDur(durMin: integer);
begin

end;

procedure TMqmCmp.SetEnd(date: TDateTime);
begin

end;

//----------------------------------------------------------------------------//

procedure TMqmCmp.SetStart(date: TDateTime);
begin

end;

//----------------------------------------------------------------------------//
end.
