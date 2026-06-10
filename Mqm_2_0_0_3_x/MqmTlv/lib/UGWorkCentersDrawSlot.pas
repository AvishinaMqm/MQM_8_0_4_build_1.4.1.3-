unit UGWorkCentersDrawSlot;

interface

uses
  Windows, Graphics, Classes, UMSchedContFunc;

type

  TSlotType = (Slt_non, Slt_Wc, slt_secondLvl, slt_Wc_category, Slt_property, Slt_WcGroup);

  TColorWcView = record
    CalbackgroundColor : TColor;
    WCbackgroundColor  : TColor;
    WCbackgroundColorReadOnly : TColor;
    MaterialProductbackgroundColor : TColor;
    WcPropertyColor : TColor;
    WCSlotColor   : TColor;
    TodaySlotColor : TColor;
    MaterialProductSlotColor : TColor;
    WCGroup : TColor;
  end;
  PTCololWcView = ^TColorWcView;

  TSelectedParam = record
    S_WkCtr : pointer;
    s_PropertyCode : string;
    s_PropertyValue : string;
    S_TypeSelected : TSlotType;
    S_code :    string;
    S_startDt : TDateTime;
    S_endDt   : TDateTime;
    S_slot    : Integer;
    S_lngDscSlot : string;
    S_PosinPlanShotList : Integer;
  end;
  PTSelectedParam = ^TSelectedParam;

  TSlotData = class
    constructor CreateSlotData;
    procedure   AddData(val, phi, ovl: double);
  private
    m_Hours_Available : double;
    m_Hours_used      : double;
    m_Hours_Used_wc   : double;
    m_errSet : SetOfErrors;
    m_dataValid: boolean;
    m_val:       double;  // loaded quantity
    m_ovl:       double;  // overloaded quantity
    m_log:       double;  // logical quantity

  public
    property p_val: double read m_val write m_val;
    property p_ovl: double read m_ovl;
    property p_log: double read m_log;
    property p_dataValid: boolean read m_dataValid;
    property p_Hours_Available : double read m_Hours_Available write m_Hours_Available;
    property p_Hours_used : double read m_Hours_used write m_Hours_used;
    property p_Hours_used_wc : double read m_Hours_used_wc write m_Hours_used_wc;
    property p_errSet : SetOfErrors read m_errSet write m_errSet;

  end;

  TSelectSlot = class(TObject)
    constructor CreateSelectSlot;
    destructor Destroy; override;
    function  DeferentWcSelected(WkCtr : pointer) : boolean;
    function  IsSelectedWc(WkCtr : pointer; code: string; start: TDateTime; endDt: TDateTime; TypeSelection : TSlotType): boolean;
    function  IsSelectedWcGroup(WkCtr : pointer; code: string; start: TDateTime; endDt: TDateTime; TypeSelection : TSlotType): boolean;

    function  IsSelectedPropCodeVal(WkCtr : pointer; code: string; start: TDateTime; endDt: TDateTime; PropCode : string; PropVal : string; TypeSelection : TSlotType): boolean;
    procedure RemoveSelectedFromList(WkCtr : pointer; code: string; start: TDateTime; endDt: TDateTime; TypeSelection : TSlotType);
    procedure RemoveAllIfNotSameType(TypeSelection : TSlotType);
    procedure AddToSelectedList(WkCtr : pointer; code : string; start, endDt: TDateTime;
                                PropCode : string; PropValue : string;
                                TypeSelection : TSlotType; slot : integer; PosinPlanShotList : Integer);
    function  CheckSequenceOnWcForShiftOperation(WkCtr : pointer; Code : string; TypeSelection : TSlotType; start: TDateTime; endDt: TDateTime; slot : integer) : Integer;
    function  CheckSequenceOnDatesForShiftOperation(WkCtr : pointer; TypeSelection : TSlotType; slot : integer; var PosInGroupList : Integer) : integer;
    procedure ClearSelectedList;
  private
    m_SelectedList : TList;
  public
    property p_SelectedList : TList read m_SelectedList;
  end;

  TDrawSlot = class(TObject)
    constructor CreateDrawSlot(SlotType : TSlotType);
    destructor  Destroy; override;
  private
    m_SlotData : TSlotData;
    function GetSlotData : TSlotData;
  public
    m_SlotType:   TSlotType;
    m_isSum:      boolean;
    m_showAlerts: boolean;
    m_isSelected: boolean;
    m_ShowCategoryTypePrecent : CCategoryTypePrecent;
    m_ShowPropertyTypePrecent : CPropTypePrecent;
    property p_SlotData : TSlotData read GetSlotData;
  end;

  TRecDataPaint = record
    Hours_Available : double;
    Hours_used      : double;
    Hours_used_wc   : double;
    errSet          : SetOfErrors;
    val   : double;
    log    : double;
    ovl    : double;
    ABValue: integer;
    m_ShowCategoryTypePrecent : CCategoryTypePrecent;
    m_ShowPropertyTypePrecent : CPropTypePrecent;
  end;

  function GetColorWcView : TColorWcView;
  function GetColoForPercent(RecDataPaint : TRecDataPaint) : TColor;

implementation

uses
  UMGlobal;

function GetColorWcView : TColorWcView;
begin
  Result.CalbackgroundColor := ClWhite;//6381999; //  DBAppGlobals.JobToJobCompColor[0].int; // 13499135;
  Result.WCbackgroundColor :=  RGB(75, 155, 205);    // modern blue for WC headers
  Result.WCbackgroundColorReadonly :=  RGB(180, 195, 210); // soft gray-blue for read-only
  Result.MaterialProductbackgroundColor := RGB(90, 115, 60); // muted olive for category
  result.WcPropertyColor                := RGB(45, 105, 165);  // clean navy for property labels
  Result.WCSlotColor               := $00EBE8E4; // slot background unchanged
  Result.TodaySlotColor            := RGB(100, 210, 110); // today marker green
  Result.MaterialProductSlotColor  := 16777088;
  Result.WCGroup := RGB(140, 150, 165);           // muted gray-blue for default group
end;

function GetColoForPercent(RecDataPaint : TRecDataPaint) : TColor;
var
  perc : double;
begin
  Result := RGB(88, 200, 88);  // default soft green
  if (RecDataPaint.Hours_Available = 0) then
  begin
    if (RecDataPaint.Hours_used = 0) then
      result := RGB(240, 240, 244)  // subtle light gray for empty slots
    else
      result := RGB(220, 60, 60);  // red — used hours but no capacity
    exit;
  end;
  perc := 100 * (RecDataPaint.Hours_used / RecDataPaint.Hours_Available);
  if (perc <= 0) then
    result := RGB(240, 240, 244)  // subtle light gray for 0% slots
  else if (perc <= 30) then
    result := RGB(100, 210, 110)   // soft green
  else if (perc <= 50) then
    result := RGB(80, 195, 80)     // medium green
  else if (perc <= 70) then
    result := RGB(60, 180, 60)     // deeper green
  else if (perc <= 85) then
    result := RGB(240, 200, 50)    // amber / yellow
  else if (perc <= 95) then
    result := RGB(245, 155, 40)    // orange
  else if (perc <= 100) then
    result := RGB(240, 110, 40)    // dark orange
  else
    result := RGB(220, 60, 60);    // red — over capacity
end;


{ TDrawSlot }

constructor TDrawSlot.CreateDrawSlot(SlotType : TSlotType);
begin
  inherited Create;
  m_SlotData := TSlotData.CreateSlotData;
  m_showAlerts := false;
  m_SlotType := SlotType;
  m_isSelected := false
end;

//----------------------------------------------------------------------------//

destructor TDrawSlot.Destroy;
begin
  inherited;
  m_SlotData.Free;
end;

//----------------------------------------------------------------------------//

function TDrawSlot.GetSlotData: TSlotData;
begin
  result := m_SlotData
end;

//----------------------------------------------------------------------------//

{ TCapacityData }

procedure TSlotData.AddData(val, phi, ovl: double);
begin

end;

constructor TSlotData.CreateSlotData;
begin
  m_Hours_Available := 0.0;
  m_Hours_used      := 0.0;
  m_errSet          := [];
  m_ovl := 0.0;
  m_log := 0.0;
  m_val := 0.0;
end;

{ TSelectSlot }

//----------------------------------------------------------------------------//

constructor TSelectSlot.CreateSelectSlot;
begin
  m_SelectedList := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TSelectSlot.Destroy;
begin
  inherited;
end;

//----------------------------------------------------------------------------//

function TSelectSlot.IsSelectedWc(WkCtr : pointer; code: string; start: TDateTime; endDt: TDateTime; TypeSelection : TSlotType): boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to m_SelectedList.Count - 1 do
  begin
    if (PTSelectedParam(m_SelectedList[I]).S_WkCtr = WkCtr) and
       (PTSelectedParam(m_SelectedList[I]).S_code = code)   and
       (PTSelectedParam(m_SelectedList[I]).S_startDt = start) and
       (PTSelectedParam(m_SelectedList[I]).S_endDt = endDt) and
       (PTSelectedParam(m_SelectedList[I]).S_TypeSelected = TypeSelection) then
    begin
      Result := true;
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSelectSlot.IsSelectedWcGroup(WkCtr : pointer; code: string; start: TDateTime; endDt: TDateTime; TypeSelection : TSlotType): boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to m_SelectedList.Count - 1 do
  begin
    if //(PTSelectedParam(m_SelectedList[I]).S_WkCtr = WkCtr) and
       (PTSelectedParam(m_SelectedList[I]).S_code = code)   and
       (PTSelectedParam(m_SelectedList[I]).S_startDt = start) and
       (PTSelectedParam(m_SelectedList[I]).S_endDt = endDt) and
       (PTSelectedParam(m_SelectedList[I]).S_TypeSelected = TypeSelection) then
    begin
      Result := true;
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSelectSlot.DeferentWcSelected(WkCtr : pointer) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to m_SelectedList.Count - 1 do
  begin
    if (PTSelectedParam(m_SelectedList[I]).S_WkCtr <> WkCtr) then
    begin
      Result := true;
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSelectSlot.IsSelectedPropCodeVal(WkCtr : pointer; code: string; start: TDateTime; endDt: TDateTime; PropCode : string; PropVal : string; TypeSelection : TSlotType): boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to m_SelectedList.Count - 1 do
  begin
    if (PTSelectedParam(m_SelectedList[I]).S_WkCtr = WkCtr) and
       (PTSelectedParam(m_SelectedList[I]).S_code = code)   and
       (PTSelectedParam(m_SelectedList[I]).S_startDt = start) and
       (PTSelectedParam(m_SelectedList[I]).S_endDt = endDt) and
       (PTSelectedParam(m_SelectedList[I]).s_PropertyCode = PropCode) and
       (PTSelectedParam(m_SelectedList[I]).s_PropertyValue = PropVal) and
       (PTSelectedParam(m_SelectedList[I]).S_TypeSelected = TypeSelection) then
    begin
      Result := true;
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSelectSlot.RemoveSelectedFromList(WkCtr : pointer; code: string; start: TDateTime; endDt: TDateTime; TypeSelection : TSlotType);
var
  I : Integer;
begin
  for I := 0 to m_SelectedList.Count - 1 do
  begin
    if (PTSelectedParam(m_SelectedList[I]).S_WkCtr = WkCtr) and
       (PTSelectedParam(m_SelectedList[I]).S_code = code)   and
       (PTSelectedParam(m_SelectedList[I]).S_startDt = start) and
       (PTSelectedParam(m_SelectedList[I]).S_endDt = endDt) and
       (PTSelectedParam(m_SelectedList[I]).S_TypeSelected = TypeSelection) then
    begin
      m_SelectedList.Delete(I);
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSelectSlot.RemoveAllIfNotSameType(TypeSelection : TSlotType);
var
  I : Integer;
begin
  for I := m_SelectedList.Count - 1 downto 0 do
  begin
    if (PTSelectedParam(m_SelectedList[I]).S_TypeSelected <> TypeSelection) then
       m_SelectedList.Delete(I);
  end;
end;

//----------------------------------------------------------------------------//

procedure TSelectSlot.AddToSelectedList(WkCtr : pointer; code : string; start, endDt: TDateTime;
                                PropCode : string; PropValue : string;
                                TypeSelection : TSlotType; slot : integer; PosinPlanShotList : Integer);
var
  SelectedParam : PTSelectedParam;
begin
  new(SelectedParam);
  SelectedParam.S_WkCtr   := WkCtr;
  SelectedParam.S_code    := code;
  SelectedParam.S_startDt := start;
  SelectedParam.S_endDt   := endDt;
  SelectedParam.s_PropertyCode := PropCode;
  SelectedParam.s_PropertyValue := PropValue;
  SelectedParam.S_TypeSelected := TypeSelection;
  SelectedParam.S_slot         := slot;
  SelectedParam.S_PosinPlanShotList := PosinPlanShotList;
  m_SelectedList.Add(SelectedParam);
end;

//----------------------------------------------------------------------------//

function TSelectSlot.CheckSequenceOnWcForShiftOperation(WkCtr : pointer; Code : string; TypeSelection : TSlotType; start: TDateTime; endDt: TDateTime; slot : integer) : Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to m_SelectedList.Count - 1 do
  begin
    if TypeSelection <> PTSelectedParam(m_SelectedList[I]).S_TypeSelected then continue;
    if WkCtr = PTSelectedParam(m_SelectedList[I]).S_WkCtr then
    begin
      if PTSelectedParam(m_SelectedList[I]).S_slot <> slot then
      begin
        Result := PTSelectedParam(m_SelectedList[I]).S_slot;
        break
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSelectSlot.CheckSequenceOnDatesForShiftOperation(WkCtr : pointer; TypeSelection : TSlotType; slot : integer; var PosInGroupList : Integer) : integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to m_SelectedList.Count - 1 do
  begin
   // if TypeSelection <> PTSelectedParam(m_SelectedList[I]).S_TypeSelected then continue;
    if TypeSelection <> PTSelectedParam(m_SelectedList[I]).S_TypeSelected then continue;

    if TypeSelection = Slt_Wc then
    begin

      if WkCtr <> PTSelectedParam(m_SelectedList[I]).S_WkCtr then
      begin
        if PTSelectedParam(m_SelectedList[I]).S_slot = slot then
        begin
          Result := PTSelectedParam(m_SelectedList[I]).S_PosinPlanShotList;
          break
        end;
      end;
    end
    else if TypeSelection = slt_secondLvl then
    begin
      if WkCtr = PTSelectedParam(m_SelectedList[I]).S_WkCtr then
      begin
        if PTSelectedParam(m_SelectedList[I]).S_slot = slot then
        begin
          Result := PTSelectedParam(m_SelectedList[I]).S_PosinPlanShotList;
         // PosInList   := PTSelectedParam(m_SelectedList[I]).S_code;
          break
        end;
      end;
    end


  end;
end;

//----------------------------------------------------------------------------//

procedure TSelectSlot.ClearSelectedList;
var
  I : Integer;
begin
  for I := 0 to m_SelectedList.Count - 1 do
    dispose(PTSelectedParam(m_SelectedList[I]));
  m_SelectedList.Clear;
end;

end.
