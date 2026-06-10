unit UMPropComp;

interface

uses
  classes,
  controls,
  extCtrls;

type

  TMPropComp = class(TPanel)
    constructor CreatePropComp(AOwner: TWinControl; filterCat: string;
                               mtxList: TList;
                               isForRules, isOtoO: boolean); virtual; abstract;
  end;

implementation

//----------------------------------------------------------------------------//
end.

