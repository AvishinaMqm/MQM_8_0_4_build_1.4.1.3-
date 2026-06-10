unit UMViewTbs;

interface

uses
  classes, ureshape,
  controls,
  comctrls,
  Windows, Messages;

type
  TBStype = (tbs_bin, tbs_plan);

  TMViewTabSheet = class(TTabSheet)
    constructor CreateViewTab(AOwner: TComponent);
    destructor  Close;

    function    GetCode: integer; virtual; abstract;
    procedure   SetCode(Code : Integer); virtual; abstract;
  private
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  end;


implementation

//----------------------------------------------------------------------------//

constructor TMViewTabSheet.CreateViewTab(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Assert(AOwner is TPageControl);
  PageControl := TPageControl(AOwner);

  Fontresize2(PageControl.Font,0);
end;

//----------------------------------------------------------------------------//

procedure TMViewTabSheet.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  // Suppress background erase to prevent white flash when switching plan tabs.
  // Child controls cover the entire tab area so skipping the erase is safe.
  Message.Result := 1;
end;

//----------------------------------------------------------------------------//

destructor TMViewTabSheet.Close;
var
  Pgc: TPageControl;
begin
  Pgc := PageControl;

  with Pgc do
  begin
    if PageCount = 1 then
      pages[0].TabVisible := false;
    ActivePage := pages[0]
  end;

  inherited destroy
end;

//----------------------------------------------------------------------------//
end.
