unit UGHdrMan;

interface

uses
  classes,
  Controls,
  UGCal;

type

  THdrManClass = class of TGenHdrMan;

  TGenHdrCfg = class
    m_class: THdrManClass;
    m_rh:    integer;
    m_rw:    integer;
    constructor Create; virtual;
  end;

  TGenHdrMan = class(TComponent)
    constructor CreateHdrMan(AOwner: TWinControl; hdrCfg: TGenHdrCfg; IsDynamic : boolean); virtual; abstract;
  end;

implementation

//----------------------------------------------------------------------------//

constructor TGenHdrCfg.Create;
begin
  m_class := nil;
  m_rh    := 10;
  m_rw    := 10
end;

//----------------------------------------------------------------------------//
end.
