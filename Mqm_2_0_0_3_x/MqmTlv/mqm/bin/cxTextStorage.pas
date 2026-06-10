unit cxTextStorage;

interface

uses
  Classes, cxGridCustomView, cxStorage, dxLayoutContainer, dxLayoutControl;

type
  TcxTextStreamReader = class(TcxIniFileReader)
  protected
    function BeginRead(const AObjectName: string): Boolean; override;
    function CanRead: Boolean; override;
  end;

  TcxTextStreamWriter = class(TcxIniFileWriter)
  protected
    procedure EndWrite; override;
  end;

  TcxCustomGridViewHelper = class helper for TcxCustomGridView
    procedure RestoreFromTextStream(AStream: TStream;
      AChildrenCreating: Boolean = True; AChildrenDeleting: Boolean = False;
      AOptions: TcxGridStorageOptions = [gsoUseFilter, gsoUseSummary];
      const ARestoreViewName: string = ''; const AOwnerName: string = '');
    procedure StoreToTextStream(AStream: TStream;
      AOptions: TcxGridStorageOptions = []; const ASaveViewName: string = '';
      const AOwnerName: string = '');
  end;

  TdxLayoutContainerHelper = class helper for TdxLayoutContainer
    procedure RestoreFromTextStream(AStream: TStream; const ARestoreName: string = ''; ADeleteUnloaded: Boolean = False);
    procedure StoreToTextStream(AStream: TStream; const ASaveName: string = '');
  end;

  TdxCustomLayoutControlHelper = class helper for TdxCustomLayoutControl
    procedure LoadFromTextStream(AStream: TStream);
    procedure SaveToTextStream(AStream: TStream);
  end;

implementation

uses SysUtils;

function TcxTextStreamReader.BeginRead(const AObjectName: string): Boolean;
var List: TStringList;
begin
  Result := True;
  if CanRead then
  begin
    List := TStringList.Create;
    try
      List.LoadFromStream(StorageStream);
      IniFile.SetStrings(List);
    finally
      List.Free;
    end;
  end
  else
    IniFile.Clear;
end;

function TcxTextStreamReader.CanRead: Boolean;
begin
  Result := (StorageStream <> nil) and (StorageStream.Size > 0);
end;

procedure TcxTextStreamWriter.EndWrite;
var  List: TStringList;
begin
  List := TStringList.Create;
  try
    IniFile.GetStrings(List);
    List.SaveToStream(StorageStream);
  finally
    List.Free;
  end;
end;

procedure TcxCustomGridViewHelper.RestoreFromTextStream(AStream: TStream;
  AChildrenCreating: Boolean = True; AChildrenDeleting: Boolean = False;
  AOptions: TcxGridStorageOptions = [gsoUseFilter, gsoUseSummary];
  const ARestoreViewName: string = ''; const AOwnerName: string = '');
begin
  RestoreFrom('', AStream, TcxTextStreamReader, AChildrenCreating,
    AChildrenDeleting, AOptions, ARestoreViewName, AOwnerName);
end;

procedure TcxCustomGridViewHelper.StoreToTextStream(AStream: TStream;
  AOptions: TcxGridStorageOptions = []; const ASaveViewName: string = '';
  const AOwnerName: string = '');
begin
  StoreTo('', AStream, TcxTextStreamWriter, True, AOptions, ASaveViewName, AOwnerName);
end;

procedure TdxLayoutContainerHelper.RestoreFromTextStream(AStream: TStream;
  const ARestoreName: string = ''; ADeleteUnloaded: Boolean = False);
begin
  RestoreFrom('', AStream, TcxTextStreamReader, ARestoreName);
end;

procedure TdxLayoutContainerHelper.StoreToTextStream(AStream: TStream; const ASaveName: string = '');
begin
  StoreTo('', AStream, TcxTextStreamWriter, True, ASaveName);
end;

procedure TdxCustomLayoutControlHelper.LoadFromTextStream(AStream: TStream);
begin
  BeginUpdate;
  try
    Container.RestoreFromTextStream(AStream);
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomLayoutControlHelper.SaveToTextStream(AStream: TStream);
begin
  Container.StoreToTextStream(AStream);
end;

end.
