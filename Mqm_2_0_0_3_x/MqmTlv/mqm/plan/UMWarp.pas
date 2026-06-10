unit UMWarp;

interface

uses
  Dialogs,
  UMSchedContFunc,
  gnugettext,
  SysUtils,
  UMPlanObj,
  UGbaseCal,
  Vcl.Graphics,
  UMSchedList,
  UMArticles,
  UMDurObj;

type

  TMqmWarp = class(TMqmDurObj)
    constructor CreateWarp(Id : TSchedId; Qty : double; WarpLvl : ArMaterialScheduleLvl; LinkedToRequest : boolean);
    constructor CreateWarpNonSchedule(Id : TSchedId);
    destructor  Destroy; override;
  private
    m_Id : TSchedId;
    m_linkedToRequest : boolean;
    m_quantity : double;

    function  GetRes: TMqmPlanObj;
  protected
    procedure SetStart(date: TDateTime); override;
    procedure SetEnd(date: TDateTime);   override;
    procedure SetDur(durMin: integer);   override;
    procedure SetDurDouble(durMin: double);  override;
    function  GetStart: TDateTime;       override;
    function  GetEnd: TDateTime;         override;
    function  GetDur: integer;           override;
    function  GetDurDouble : double;      override;
    function  GetCalendar: TPGCALObj;
  public

    m_WarpLvl : ArMaterialScheduleLvl;
    m_compatVal:   integer;
    procedure SetQuantity(qty : double);
    function  IsLinkedToRequest : boolean;
    function GetQuantity : double;
    procedure GetNormalColors(ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
    function Get_M_id : TSchedId;
    property p_Res: TMqmPlanObj  read GetRes;

  end;

implementation

uses UMRes, UMglobal;

{ TMqmWarp }

constructor TMqmWarp.CreateWarp(Id : TSchedId; Qty : double; WarpLvl : ArMaterialScheduleLvl; LinkedToRequest : boolean);
begin
  inherited Create;
  m_id := Id;
  m_linkedToRequest := LinkedToRequest;
  m_quantity := qty;
  m_WarpLvl := WarpLvl;
end;

//----------------------------------------------------------------------------//

constructor TMqmWarp.CreateWarpNonSchedule(Id : TSchedId);
begin
  inherited Create;
  m_id := Id;
end;

//----------------------------------------------------------------------------//

destructor TMqmWarp.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TMqmWarp.GetCalendar: TPGCALObj;
var
  visRes : TMqmVisibleRes;
begin
  if not Assigned(p_father) then
  begin
    Result := nil;
    exit
  end;
  visRes := TMqmVisibleRes(p_father.p_father);
  Assert(Assigned(visRes));
  Result := visRes.GetCalendar
end;

//----------------------------------------------------------------------------//

function TMqmWarp.GetDur: integer;
begin
  Result := m_dur
end;

//----------------------------------------------------------------------------//

function TMqmWarp.GetDurDouble : double;
begin
  Result := m_durDouble
end;

//----------------------------------------------------------------------------//

function TMqmWarp.GetEnd: TDateTime;
var
  start: TDateTime;
begin
  if m_savedEnd = 0 then // should never be 0 ! avi
  begin
    start := p_start;
    if GetCalendar = nil then
      m_savedEnd := start + p_durDouble/60/24
    else
    begin
      start := p_start;
      GetCalendar.OfsByWH((p_durDouble/60), false, start, m_savedEnd, nil);
    end;
  end;
  Result := m_savedEnd
end;

//----------------------------------------------------------------------------//

procedure TMqmWarp.GetNormalColors(ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
begin
  pen.Style := psSolid;
  brush.Style := bsSolid;
  case m_WarpLvl of      //  Wrp_Normal, Wrp_SecondLevl
    MT_BaseLvl: begin
                   brush.Color := clGreen;//m_BrushColor;
                   pen.Color   := clBlack;//m_brdColor;
                 end;

    MT_SecondLvl: begin
                   Brush.Color := clblue;
                   Pen.Color := clBlack;
                   Font.Color := clwhite
                 end;

  end;

//  if objPr_MoveSel in m_ObjProp then
//  begin
//    Pen.Color := Cl_STNDRD_LIGHT_BLUE;
//    Pen.Width := 2
//  end
//  else
  Pen.Width := 1;
end;

//----------------------------------------------------------------------------//

function TMqmWarp.Get_M_id : TSchedId;
begin
  Result := m_Id
end;

//----------------------------------------------------------------------------//

function TMqmWarp.GetRes: TMqmPlanObj;
begin
  Result := nil;
  if Assigned(p_father)
  and Assigned(p_father.p_Father)
  and Assigned(p_father.p_Father.p_Father) then
    Result := p_father.p_Father.p_Father
end;

//----------------------------------------------------------------------------//

procedure TMqmWarp.SetQuantity(qty : double);
begin
  m_quantity := qty
end;

//----------------------------------------------------------------------------//

function TMqmWarp.IsLinkedToRequest : boolean;
begin
  result := m_linkedToRequest
end;

//----------------------------------------------------------------------------//

function TMqmWarp.GetQuantity : double;
begin
  Result := m_quantity
end;

//----------------------------------------------------------------------------//

//function TMqmWarp.GetSpeedMinPerUm : double;
//begin
//  result := m_SpeedMinPerUm
//end;

//----------------------------------------------------------------------------//

function TMqmWarp.GetStart: TDateTime;
begin
  Result := m_Start
end;

//----------------------------------------------------------------------------//

procedure TMqmWarp.SetDur(durMin: integer);
begin
  m_dur := durMin;
 // m_savedEnd := 0
end;

//----------------------------------------------------------------------------//

procedure TMqmWarp.SetDurDouble(durMin: double);
begin
  m_durDouble := durMin;
 // m_savedEnd := 0
end;

//----------------------------------------------------------------------------//

procedure TMqmWarp.SetEnd(date: TDateTime);
begin
  m_savedEnd := date;
end;

//----------------------------------------------------------------------------//

procedure TMqmWarp.SetStart(date: TDateTime);
begin
  m_Start := date;
//  m_savedEnd := 0
end;

//----------------------------------------------------------------------------//

end.
