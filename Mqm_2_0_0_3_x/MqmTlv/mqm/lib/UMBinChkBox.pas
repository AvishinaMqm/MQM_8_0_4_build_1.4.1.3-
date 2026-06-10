unit UMBinChkBox;

interface

uses
  StdCtrls,
  Classes,
  controls,
  UMSchedContFunc;

type

  TBinChkBoxDestroyFunc  = procedure(id: TSchedID) of object;

  TMqmBinChkBox = class(TCheckBox)
    constructor CreateBinChkBox(AOwner: TComponent; Id: TSchedID; DestroyFnc: TBinChkBoxDestroyFunc);
    destructor Destroy; override;
    procedure  SetFuncToNil;
  private
    m_DestroyFnc: TBinChkBoxDestroyFunc;
  end;

implementation

//----------------------------------------------------------------------------//

constructor TMqmBinChkBox.CreateBinChkBox(AOwner: TComponent; Id: TSchedID; DestroyFnc: TBinChkBoxDestroyFunc);
begin
  inherited Create(AOwner);

  Parent := AOwner as TWinControl;
  Width  := 16;
  Height := 16;
  Visible := false;
  Tag := id;
  m_DestroyFnc := DestroyFnc;
end;

//----------------------------------------------------------------------------//

destructor  TMqmBinChkBox.Destroy;
begin
{  if Assigned(m_DestroyFnc) then
    m_DestroyFnc(Tag); }

  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TMqmBinChkBox.SetFuncToNil;
begin
  if Assigned(m_DestroyFnc) then
  begin
    m_DestroyFnc := nil;
    free;
  end;
end;


end.
