unit FMlock;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TFLock = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure ShowLockWindow(AOwner: TComponent);

implementation

{$R *.DFM}

// -------------------------------------------------------------------------- //

procedure ShowLockWindow(AOwner: TComponent);
var
  FLock: TFLock;
begin
  FLock := TFLock.Create(AOwner);
  FLock.ShowModal
end;

// -------------------------------------------------------------------------- //

procedure TFLock.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree
end;

// -------------------------------------------------------------------------- //
end.
