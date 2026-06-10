unit UMCapRes;

interface

uses
  Dialogs,
  gnugettext,
  SysUtils,
  UMDurObj,
  UMCompatSrv,
  UMPlanObj,
  UGBaseCal,
  Graphics,
  UMRes,
  UMCompat,
  UMSchedCont,
  UMGlobal;

type
  TCapResType = (cr_Normal, cr_DownTime, Cr_CrossingDtm, Cr_DummyDtm, Cr_DummyUpTime, Cr_Dynamic);

  TMqmCapRes = class(TMqmDurObj)
    constructor CreateCapRes(Number: integer);
    destructor  Destroy; override;
  private
    m_Number: integer;
    m_NewInMemorty : boolean;
    function  GetWrkCtr: TMqmPlanObj;
    function  GetRes: TMqmPlanObj;

  protected
    procedure SetStart(date: TDateTime); override;
    procedure SetEnd(date: TDateTime);   override;
    procedure SetDur(durMin: integer);   override;
    function  GetStart: TDateTime;       override;
    function  GetEnd: TDateTime;         override;
    function  GetDur: integer;           override;
    function  GetCalendar: TPGCALObj;
  public
    m_Type: TCapResType;
    m_compatVal:   integer;
    m_propList:    TProperties;
    m_Comment: String;
    m_UpMostCase: integer;
    m_WCProc: string;
    m_Work_Station : string;
    m_BrushColor : TColor;
    m_brdColor : TColor;
    m_Dsc: String;

    m_ColorIndex: integer;  //the color chosen for the Cap res
{
    m_BrushColor: Tcolor;  //the color chosen for the Cap res
    m_PenColor: Tcolor;  //the color chosen for the Cap res
    m_FontColor: Tcolor;  //the color chosen for the Cap res
    m_ColorDesc: string;  // the color description chosen for Cap res
}
    function GetDescr: string; override;
    procedure GetNormalColors(ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont); override;
    function IsMoved: CMoved;
    function CheckUpMostCase(CompVal: TCompatVal): boolean;

    property p_CapResNum: integer     read m_Number write m_Number;
    property p_NewInMemorty : boolean read m_NewInMemorty write m_NewInMemorty;
    property p_WrkCtr: TMqmPlanObj             read GetWrkCtr;
    property p_Res: TMqmPlanObj                read GetRes;

  { //already defined in UMDurObj
    property p_Start: TDateTime       read GetStart   write SetStart;
    property p_End: TDateTime         read GetEnd     write SetEnd;
    property p_Dur: integer           read GetDur     write SetDur;
   }
  end;

implementation

uses
  UMObjCont,
  UMCompatRules;

//----------------------------------------------------------------------------//

constructor TMqmCapRes.CreateCapRes(Number: integer);
begin
  inherited Create;
  m_Number := Number;
  m_propList := TProperties.Create;
  m_compatVal := 0;
  m_ColorIndex := 0;

//  m_BrushColor := clwhite;
//  m_brdColor := clwhite;

{
  m_BrushColor := clwhite;
  m_PenColor := clwhite;
  m_fontColor := clBlack;
}
end;

//----------------------------------------------------------------------------//

destructor TMqmCapRes.Destroy;
begin
  m_propList.Free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TMqmCapRes.SetStart(date: TDateTime);
begin
  m_Start := date;
  m_savedEnd := 0
end;

//----------------------------------------------------------------------------//

procedure TMqmCapRes.SetEnd(date: TDateTime);
//var
//  calObj: TPGCALObj;
begin
//  calObj := GetCalendar;
//  calObj.NormalizeDate(date, ntNormalizeBackward);
//  m_savedEnd := date;
//  if not calObj.OfsByWH(-(p_dur/60), true, date, m_Start, nil) then
//    m_start := m_savedEnd - m_dur/24/60
//  else
    m_savedEnd := date;
end;

//----------------------------------------------------------------------------//

procedure TMqmCapRes.SetDur(durMin: integer);
begin
  m_dur := durMin;
  m_savedEnd := 0
end;

//----------------------------------------------------------------------------//

function TMqmCapRes.GetStart: TDateTime;
begin
  Result := m_Start
end;

//----------------------------------------------------------------------------//

function TMqmCapRes.GetEnd: TDateTime;
var
  start: TDateTime;
begin
  if m_savedEnd = 0 then
  begin
    start := p_start;
    GetCalendar.OfsByWH((p_dur/60), false, start, m_savedEnd, nil);
  end;
  Result := m_savedEnd
end;

//----------------------------------------------------------------------------//

function TMqmCapRes.GetDur: integer;
begin
  Result := m_dur
end;

//----------------------------------------------------------------------------//

function TMqmCapRes.GetCalendar: TPGCALObj;
var
  visRes: TMqmVisibleRes;
begin
  Assert(Assigned(p_father));
  visRes := TMqmVisibleRes(p_father.p_father);
  Assert(Assigned(visRes));
  Result := visRes.GetCalendar
end;

//----------------------------------------------------------------------------//

function TMqmCapRes.GetWrkCtr: TMqmPlanObj;
begin
  Result := nil;
  if Assigned(p_father)
  and Assigned(p_father.p_Father)
  and Assigned(p_father.p_Father.p_Father)
  and Assigned(p_father.p_Father.p_Father.p_Father) then
    Result := p_father.p_Father.p_Father.p_Father
end;

//----------------------------------------------------------------------------//

function TMqmCapRes.GetRes: TMqmPlanObj;
begin
  Result := nil;
  if Assigned(p_father)
  and Assigned(p_father.p_Father)
  and Assigned(p_father.p_Father.p_Father) then
    Result := p_father.p_Father.p_Father
end;

//----------------------------------------------------------------------------//

function TMqmCapRes.GetDescr: string;
begin
  Result := '';
end;

//----------------------------------------------------------------------------//

procedure TMqmCapRes.GetNormalColors(ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
begin
  pen.Style := psSolid;
  brush.Style := bsSolid;
  case m_Type of
    cr_Normal, Cr_Dynamic: begin
                   //Brush.Color := clwhite;
                   {Brush.Color := DBAppGlobals.CapResColors[m_ColorIndex].int;
                   Pen.Color := DBAppGlobals.CapResColors[m_ColorIndex].brd;
                   Font.Color := DBAppGlobals.CapResColors[m_ColorIndex].txt; }

                   brush.Color := m_BrushColor;
                   pen.Color   := m_brdColor;

                 end;

    cr_DownTime: begin
                   Brush.Color := clBlack;
                   Pen.Color := clwhite;
                   if m_Number < 0 then
                   begin
                     Pen.Color := clRed;
                     Pen.Width := 5;
                   end;

                   Font.Color := clwhite
                 end;

    Cr_CrossingDtm: begin
                      Brush.Color := clBlack;
                      if m_dur > 1 then
                        Pen.Color := clYellow
                      else
                        Pen.Color := clBlack;
                      Font.Color := clwhite
                   end;
  end;

  if objPr_MoveSel in m_ObjProp then
  begin
    Pen.Color := Cl_STNDRD_LIGHT_BLUE;
    Pen.Width := 2
  end else
   Pen.Width := 1 ;

end;

//----------------------------------------------------------------------------//

function TMqmCapRes.IsMoved: CMoved;
begin
  Result := mov_none;

  if (m_bkStart > 0)
  and (m_bkDur > 0) then
  begin
    if p_Start < m_bkStart then
      Result := mov_left
    else if p_start > m_bkDur then
      Result := mov_right
  end;

end;

//----------------------------------------------------------------------------//

function TMqmCapRes.CheckUpMostCase(CompVal: TCompatVal): boolean;
begin
   Result := true;
   if (m_UpMostCase = 0) and (CompVal = 1) then exit;
   if (m_UpMostCase < CompVal) then result := false;
end;

end.
