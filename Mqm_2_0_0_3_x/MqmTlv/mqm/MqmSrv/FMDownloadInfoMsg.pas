unit FMDownloadInfoMsg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TDownloadInfoMsg = class(TForm)
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
  end;
  function CheckInfoMsgProductDownload : boolean;

var
  DownloadInfoMsg: TDownloadInfoMsg;
  DownloadInfoMsgProductStr : TStringList;

implementation

{$R *.dfm}

{ TDownloadInfoMsg }

//----------------------------------------------------------------------------//

procedure TDownloadInfoMsg.FormShow(Sender: TObject);
var
  I : Integer;
begin
  Memo1.Lines.Clear;
  for I := 0 to DownloadInfoMsgProductStr.Count - 1 do
    Memo1.lines.Add(DownloadInfoMsgProductStr.Strings[I])
end;

//----------------------------------------------------------------------------//

function CheckInfoMsgProductDownload : boolean;
begin
  Result := false;
  if DownloadInfoMsgProductStr.Count > 0 then
    Result := true
end;

//----------------------------------------------------------------------------//

initialization
  DownloadInfoMsgProductStr := TStringList.Create;
finalization
  DownloadInfoMsgProductStr.Free;
end.
