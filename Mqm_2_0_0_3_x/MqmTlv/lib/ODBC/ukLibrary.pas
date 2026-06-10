unit ukLibrary;

interface

uses Windows, SysUtils;

type

{ TKCustomLibraryMapping }

	EKCustomLibraryMapping = class( Exception );

	TKCustomLibraryMapping = class( TObject )
	private
		FhLibrary: HModule;
		FLibraryName: String;

		function GethLibrary: HModule;

	protected

		procedure FreeHandle; virtual;
		procedure HandleNeeded; virtual;
		function CheckLibrary: Boolean; virtual;
		function CheckProc( const Proc ): Boolean; virtual;
		procedure SetLibraryName( const LibraryName: String ); dynamic;
		function InternalLoadProc( const ProcName: ShortString; var Proc ): Pointer; virtual;

	public
		constructor Create; virtual;
		destructor Destroy; override;

		property hLibrary: HModule
						 read GethLibrary;
		property LibraryName: String
						 read FLibraryName;

	end;

implementation

ResourceString
	sCLMNoLibNameSpecified = 'No library name specified.';
	sCLMLoadLibraryError = 'Could not load library [%s].';
	sCLMLoadProcError = 'Could not load proc [%s].';

{
--------------------------------------------------------------------------
------------------------- TKCustomLibraryMapping ---------------------------
--------------------------------------------------------------------------
}

constructor TKCustomLibraryMapping.Create;
begin
	inherited Create;
	FLibraryName := '';
	FhLibrary := HINSTANCE_ERROR;
end;

destructor TKCustomLibraryMapping.Destroy;
begin
	FreeHandle;
	inherited Destroy;
end;

procedure TKCustomLibraryMapping.SetLibraryName( const LibraryName: String );
begin
	if CheckLibrary then Exit;
	if ( Trim( LibraryName ) <> '' ) then
		FLibraryName := LibraryName
	else
		raise EKCustomLibraryMapping.Create( sCLMNoLibNameSpecified );
end;

function TKCustomLibraryMapping.GethLibrary: HModule;
begin
	HandleNeeded;
	Result := FhLibrary;
end;

procedure TKCustomLibraryMapping.FreeHandle;
begin
	if CheckLibrary then
		FreeLibrary( FhLibrary );
end;

procedure TKCustomLibraryMapping.HandleNeeded;
begin
	if ( not CheckLibrary ) then
	begin
		FhLibrary := LoadLibrary( PChar( String( FLibraryName ) ) );
		if ( not CheckLibrary ) then
			raise EKCustomLibraryMapping.CreateFmt( sCLMLoadLibraryError, [FLibraryName] );
	end;
end;

function TKCustomLibraryMapping.CheckLibrary: Boolean;
begin
	Result := ( FhLibrary > HINSTANCE_ERROR );
end;

function TKCustomLibraryMapping.CheckProc( const Proc ): Boolean;
begin
	Result := ( Pointer( Proc ) <> nil );
end;

function TKCustomLibraryMapping.InternalLoadProc( const ProcName: ShortString; var Proc ): Pointer;
begin
	if ( not CheckProc( Proc ) ) then
	begin
		Pointer( Proc ) := GetProcAddress( hLibrary, PChar( String( ProcName ) ) );
		if ( not CheckProc( Proc ) ) then
			raise EKCustomLibraryMapping.CreateFmt( sCLMLoadProcError, [ProcName] );
	end;
	Result := Pointer( Proc );
end;

end.
