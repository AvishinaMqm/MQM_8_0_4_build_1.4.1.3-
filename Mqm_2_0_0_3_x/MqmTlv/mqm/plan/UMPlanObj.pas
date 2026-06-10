unit UMPlanObj;

interface

uses
  classes,
  Graphics,
  UMCompat,
  UMPlan;

type

  TObjProp    = (objPr_InDB, objPr_Pivot, objPr_MoveSel);

  TChkCompOpt = (cho_compVal, cho_timing, cho_wkc, cho_readOnly, cho_useDate, cho_Qty, cho_Depend);
  TSetChkCompOpt = set of TChkCompOpt;

  TMqmPlanObj = class(TMqmObj)
    constructor Create;
    destructor  Destroy; override;
  private
    m_Father: TMqmPlanObj;
    function  GetFather: TMqmPlanObj;
    procedure SetFather(Father: TMqmPlanObj);
  public
    m_ObjProp: set of TObjProp;
    procedure GetNormalColors(ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont); virtual;
    function  CheckCompatWithOcc(opt: TSetChkCompOpt; id: integer; toDate: TDateTime; errLst: TStrings; var compVal: TCompatVal; var Dependency : boolean): boolean; virtual;
    function  GetDescr: string; virtual; abstract;

    property p_Father: TMqmPlanObj       read GetFather    write SetFather;
  end;

implementation

//----------------------------------------------------------------------------//

constructor TMqmPlanObj.Create;
begin
  inherited Create;
end;

//----------------------------------------------------------------------------//

destructor TMqmPlanObj.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TMqmPlanObj.GetFather: TMqmPlanObj;
begin
  Result := m_Father
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanObj.SetFather(Father: TMqmPlanObj);
begin
  m_Father := Father
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanObj.GetNormalColors(ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
begin
  brush.Color := clwhite;
  pen.Color := clwhite;
  font.Color := clwhite
end;

//----------------------------------------------------------------------------//

function TMqmPlanObj.CheckCompatWithOcc(opt: TSetChkCompOpt; id: integer; toDate: TDateTime; errLst: TStrings; var compVal: TCompatVal; var Dependency : boolean): boolean;
begin
  if Assigned(p_Father) then
    Result := p_Father.CheckCompatWithOcc(opt, id, toDate, errLst, compVal, Dependency)
  else
    Result := True;
end;

//----------------------------------------------------------------------------//

end.

