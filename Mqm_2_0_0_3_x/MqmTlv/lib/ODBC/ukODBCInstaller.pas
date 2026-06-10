unit ukODBCInstaller;

interface

uses Windows, ukLibrary, ukODBCTypes;

type

{ TKODBCInstaller }

	EKODBCInstaller = class( EKCustomLibraryMapping );

	TKODBCInstaller = class( TKCustomLibraryMapping )
	private
		FSQLInstallODBCProc: TSQLInstallODBCProc;
		FSQLManageDataSourcesProc: TSQLManageDataSourcesProc;
		FSQLCreateDataSourceProc: TSQLCreateDataSourceProc;
		FSQLGetTranslatorProc: TSQLGetTranslatorProc;
		FSQLInstallDriverProc: TSQLInstallDriverProc;
		FSQLInstallDriverManagerProc: TSQLInstallDriverManagerProc;
		FSQLGetInstalledDriversProc: TSQLGetInstalledDriversProc;
		FSQLGetAvailableDriversProc: TSQLGetAvailableDriversProc;
		FSQLConfigDataSourceProc: TSQLConfigDataSourceProc;
		FSQLRemoveDefaultDataSourceProc: TSQLRemoveDefaultDataSourceProc;
		FSQLWriteDSNToIniProc: TSQLWriteDSNToIniProc;
		FSQLRemoveDSNFromIniProc: TSQLRemoveDSNFromIniProc;
		FSQLValidDSNProc: TSQLValidDSNProc;
		FSQLWritePrivateProfileStringProc: TSQLWritePrivateProfileStringProc;
		FSQLGetPrivateProfileStringProc: TSQLGetPrivateProfileStringProc;
		FSQLRemoveDriverManagerProc: TSQLRemoveDriverManagerProc;
		FSQLInstallTranslatorProc: TSQLInstallTranslatorProc;
		FSQLRemoveTranslatorProc: TSQLRemoveTranslatorProc;
		FSQLRemoveDriverProc: TSQLRemoveDriverProc;
		FSQLConfigDriverProc: TSQLConfigDriverProc;
		FSQLInstallerErrorProc: TSQLInstallerErrorProc;
		FSQLPostInstallerErrorProc: TSQLPostInstallerErrorProc;
		FSQLWriteFileDSNProc: TSQLWriteFileDSNProc;
		FSQLReadFileDSNProc: TSQLReadFileDSNProc;
		FSQLInstallDriverExProc: TSQLInstallDriverExProc;
		FSQLInstallTranslatorExProc: TSQLInstallTranslatorExProc;
		FSQLGetConfigModeProc: TSQLGetConfigModeProc;
		FSQLSetConfigModeProc: TSQLSetConfigModeProc;
//		FConfigDSNProc: TConfigDSNProc;
//		FConfigTranslatorProc: TConfigTranslatorProc;
//		FConfigDriverProc: TConfigDriverProc;

		function GetSQLInstallODBC: TSQLInstallODBCProc;
		function GetSQLManageDataSources: TSQLManageDataSourcesProc;
		function GetSQLCreateDataSource: TSQLCreateDataSourceProc;
		function GetSQLGetTranslator: TSQLGetTranslatorProc;
		function GetSQLInstallDriver: TSQLInstallDriverProc;
		function GetSQLInstallDriverManager: TSQLInstallDriverManagerProc;
		function GetSQLGetInstalledDrivers: TSQLGetInstalledDriversProc;
		function GetSQLGetAvailableDrivers: TSQLGetAvailableDriversProc;
		function GetSQLConfigDataSource: TSQLConfigDataSourceProc;
		function GetSQLRemoveDefaultDataSource: TSQLRemoveDefaultDataSourceProc;
		function GetSQLWriteDSNToIni: TSQLWriteDSNToIniProc;
		function GetSQLRemoveDSNFromIni: TSQLRemoveDSNFromIniProc;
		function GetSQLValidDSN: TSQLValidDSNProc;
		function GetSQLWritePrivateProfileString: TSQLWritePrivateProfileStringProc;
		function GetSQLGetPrivateProfileString: TSQLGetPrivateProfileStringProc;
		function GetSQLRemoveDriverManager: TSQLRemoveDriverManagerProc;
		function GetSQLInstallTranslator: TSQLInstallTranslatorProc;
		function GetSQLRemoveTranslator: TSQLRemoveTranslatorProc;
		function GetSQLRemoveDriver: TSQLRemoveDriverProc;
		function GetSQLConfigDriver: TSQLConfigDriverProc;
		function GetSQLInstallerError: TSQLInstallerErrorProc;
		function GetSQLPostInstallerError: TSQLPostInstallerErrorProc;
		function GetSQLWriteFileDSN: TSQLWriteFileDSNProc;
		function GetSQLReadFileDSN: TSQLReadFileDSNProc;
		function GetSQLInstallDriverEx: TSQLInstallDriverExProc;
		function GetSQLInstallTranslatorEx: TSQLInstallTranslatorExProc;
		function GetSQLGetConfigMode: TSQLGetConfigModeProc;
		function GetSQLSetConfigMode: TSQLSetConfigModeProc;
//		function GetConfigDSN: TConfigDSNProc;
//		function GetConfigTranslator: TConfigTranslatorProc;
//		function GetConfigDriver: TConfigDriverProc;

	public
		constructor Create; override;

		property SQLInstallODBC: TSQLInstallODBCProc
						 read GetSQLInstallODBC;
		property SQLManageDataSources: TSQLManageDataSourcesProc
						 read GetSQLManageDataSources;
		property SQLCreateDataSource: TSQLCreateDataSourceProc
						 read GetSQLCreateDataSource;
		property SQLGetTranslator: TSQLGetTranslatorProc
						 read GetSQLGetTranslator;
		property SQLInstallDriver: TSQLInstallDriverProc
						 read GetSQLInstallDriver;
		property SQLInstallDriverManager: TSQLInstallDriverManagerProc
						 read GetSQLInstallDriverManager;
		property SQLGetInstalledDrivers: TSQLGetInstalledDriversProc
						 read GetSQLGetInstalledDrivers;
		property SQLGetAvailableDrivers: TSQLGetAvailableDriversProc
						 read GetSQLGetAvailableDrivers;
		property SQLConfigDataSource: TSQLConfigDataSourceProc
						 read GetSQLConfigDataSource;
		property SQLRemoveDefaultDataSource: TSQLRemoveDefaultDataSourceProc
						 read GetSQLRemoveDefaultDataSource;
		property SQLWriteDSNToIni: TSQLWriteDSNToIniProc
						 read GetSQLWriteDSNToIni;
		property SQLRemoveDSNFromIni: TSQLRemoveDSNFromIniProc
						 read GetSQLRemoveDSNFromIni;
		property SQLValidDSN: TSQLValidDSNProc
						 read GetSQLValidDSN;
		property SQLWritePrivateProfileString: TSQLWritePrivateProfileStringProc
						 read GetSQLWritePrivateProfileString;
		property SQLGetPrivateProfileString: TSQLGetPrivateProfileStringProc
						 read GetSQLGetPrivateProfileString;
		property SQLRemoveDriverManager: TSQLRemoveDriverManagerProc
						 read GetSQLRemoveDriverManager;
		property SQLInstallTranslator: TSQLInstallTranslatorProc
						 read GetSQLInstallTranslator;
		property SQLRemoveTranslator: TSQLRemoveTranslatorProc
						 read GetSQLRemoveTranslator;
		property SQLRemoveDriver: TSQLRemoveDriverProc
						 read GetSQLRemoveDriver;
		property SQLConfigDriver: TSQLConfigDriverProc
						 read GetSQLConfigDriver;
		property SQLInstallerError: TSQLInstallerErrorProc
						 read GetSQLInstallerError;
		property SQLPostInstallerError: TSQLPostInstallerErrorProc
						 read GetSQLPostInstallerError;
		property SQLWriteFileDSN: TSQLWriteFileDSNProc
						 read GetSQLWriteFileDSN;
		property SQLReadFileDSN: TSQLReadFileDSNProc
						 read GetSQLReadFileDSN;
		property SQLInstallDriverEx: TSQLInstallDriverExProc
						 read GetSQLInstallDriverEx;
		property SQLInstallTranslatorEx: TSQLInstallTranslatorExProc
						 read GetSQLInstallTranslatorEx;
		property SQLGetConfigMode: TSQLGetConfigModeProc
						 read GetSQLGetConfigMode;
		property SQLSetConfigMode: TSQLSetConfigModeProc
						 read GetSQLSetConfigMode;
//		property ConfigDSN: TConfigDSNProc
//						 read GetConfigDSN;
//		property ConfigTranslator: TConfigTranslatorProc
//						 read GetConfigTranslator;
//		property ConfigDriver: TConfigDriverProc
//						 read GetConfigDriver;

	end;

implementation

ResourceString
	sODBC_LibNameInstaller = 'ODBCCP32.DLL';
	sODBC_SQLInstallODBCProc = 'SQLInstallODBC';
	sODBC_SQLManageDataSourcesProc = 'SQLManageDataSources';
	sODBC_SQLCreateDataSourceProc = 'SQLCreateDataSource';
	sODBC_SQLGetTranslatorProc = 'SQLGetTranslator';
	sODBC_SQLInstallDriverProc = 'SQLInstallDriver';
	sODBC_SQLInstallDriverManagerProc = 'SQLInstallDriverManager';
	sODBC_SQLGetInstalledDriversProc = 'SQLGetInstalledDrivers';
	sODBC_SQLGetAvailableDriversProc = 'SQLGetAvailableDrivers';
	sODBC_SQLConfigDataSourceProc = 'SQLConfigDataSource';
	sODBC_SQLRemoveDefaultDataSourceProc = 'SQLRemoveDefaultDataSource';
	sODBC_SQLWriteDSNToIniProc = 'SQLWriteDSNToIni';
	sODBC_SQLRemoveDSNFromIniProc = 'SQLRemoveDSNFromIni';
	sODBC_SQLValidDSNProc = 'SQLValidDSN';
	sODBC_SQLWritePrivateProfileStringProc = 'SQLWritePrivateProfileString';
	sODBC_SQLGetPrivateProfileStringProc = 'SQLGetPrivateProfileString';
	sODBC_SQLRemoveDriverManagerProc = 'SQLRemoveDriverManager';
	sODBC_SQLInstallTranslatorProc = 'SQLInstallTranslator';
	sODBC_SQLRemoveTranslatorProc = 'SQLRemoveTranslator';
	sODBC_SQLRemoveDriverProc = 'SQLRemoveDriver';
	sODBC_SQLConfigDriverProc = 'SQLConfigDriver';
	sODBC_SQLInstallerErrorProc = 'SQLInstallerError';
	sODBC_SQLPostInstallerErrorProc = 'SQLPostInstallerError';
	sODBC_SQLWriteFileDSNProc = 'SQLWriteFileDSN';
	sODBC_SQLReadFileDSNProc = 'SQLReadFileDSN';
	sODBC_SQLInstallDriverExProc = 'SQLInstallDriverEx';
	sODBC_SQLInstallTranslatorExProc = 'SQLInstallTranslatorEx';
	sODBC_SQLGetConfigModeProc = 'SQLGetConfigMode';
	sODBC_SQLSetConfigModeProc = 'SQLSetConfigMode';

{ These are not installer functions }
	sODBC_ConfigDSNProc = 'ConfigDSN';
	sODBC_ConfigTranslatorProc = 'ConfigTranslator';
	sODBC_ConfigDriverProc = 'ConfigDriver';

{
--------------------------------------------------------------------------
--------------------------- TKODBCInstaller ------------------------------
--------------------------------------------------------------------------
}

constructor TKODBCInstaller.Create;
begin
	inherited Create;
	SetLibraryName( sODBC_LibNameInstaller );
end;

function TKODBCInstaller.GetSQLInstallODBC: TSQLInstallODBCProc;
begin
	Result := InternalLoadProc( sODBC_SQLInstallODBCProc, @FSQLInstallODBCProc );
end;

function TKODBCInstaller.GetSQLManageDataSources: TSQLManageDataSourcesProc;
begin
	Result := InternalLoadProc( sODBC_SQLManageDataSourcesProc, @FSQLManageDataSourcesProc );
end;

function TKODBCInstaller.GetSQLCreateDataSource: TSQLCreateDataSourceProc;
begin
	Result := InternalLoadProc( sODBC_SQLCreateDataSourceProc, @FSQLCreateDataSourceProc );
end;

function TKODBCInstaller.GetSQLGetTranslator: TSQLGetTranslatorProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetTranslatorProc, @FSQLGetTranslatorProc );
end;

function TKODBCInstaller.GetSQLInstallDriver: TSQLInstallDriverProc;
begin
	Result := InternalLoadProc( sODBC_SQLInstallDriverProc, @FSQLInstallDriverProc );
end;

function TKODBCInstaller.GetSQLInstallDriverManager: TSQLInstallDriverManagerProc;
begin
	Result := InternalLoadProc( sODBC_SQLInstallDriverManagerProc, @FSQLInstallDriverManagerProc );
end;

function TKODBCInstaller.GetSQLGetInstalledDrivers: TSQLGetInstalledDriversProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetInstalledDriversProc, @FSQLGetInstalledDriversProc );
end;

function TKODBCInstaller.GetSQLGetAvailableDrivers: TSQLGetAvailableDriversProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetAvailableDriversProc, @FSQLGetAvailableDriversProc );
end;

function TKODBCInstaller.GetSQLConfigDataSource: TSQLConfigDataSourceProc;
begin
	Result := InternalLoadProc( sODBC_SQLConfigDataSourceProc, @FSQLConfigDataSourceProc );
end;

function TKODBCInstaller.GetSQLRemoveDefaultDataSource: TSQLRemoveDefaultDataSourceProc;
begin
	Result := InternalLoadProc( sODBC_SQLRemoveDefaultDataSourceProc, @FSQLRemoveDefaultDataSourceProc );
end;

function TKODBCInstaller.GetSQLWriteDSNToIni: TSQLWriteDSNToIniProc;
begin
	Result := InternalLoadProc( sODBC_SQLWriteDSNToIniProc, @FSQLWriteDSNToIniProc );
end;

function TKODBCInstaller.GetSQLRemoveDSNFromIni: TSQLRemoveDSNFromIniProc;
begin
	Result := InternalLoadProc( sODBC_SQLRemoveDSNFromIniProc, @FSQLRemoveDSNFromIniProc );
end;

function TKODBCInstaller.GetSQLValidDSN: TSQLValidDSNProc;
begin
	Result := InternalLoadProc( sODBC_SQLValidDSNProc, @FSQLValidDSNProc );
end;

function TKODBCInstaller.GetSQLWritePrivateProfileString: TSQLWritePrivateProfileStringProc;
begin
	Result := InternalLoadProc( sODBC_SQLWritePrivateProfileStringProc, @FSQLWritePrivateProfileStringProc );
end;

function TKODBCInstaller.GetSQLGetPrivateProfileString: TSQLGetPrivateProfileStringProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetPrivateProfileStringProc, @FSQLGetPrivateProfileStringProc );
end;

function TKODBCInstaller.GetSQLRemoveDriverManager: TSQLRemoveDriverManagerProc;
begin
	Result := InternalLoadProc( sODBC_SQLRemoveDriverManagerProc, @FSQLRemoveDriverManagerProc );
end;

function TKODBCInstaller.GetSQLInstallTranslator: TSQLInstallTranslatorProc;
begin
	Result := InternalLoadProc( sODBC_SQLInstallTranslatorProc, @FSQLInstallTranslatorProc );
end;

function TKODBCInstaller.GetSQLRemoveTranslator: TSQLRemoveTranslatorProc;
begin
	Result := InternalLoadProc( sODBC_SQLRemoveTranslatorProc, @FSQLRemoveTranslatorProc );
end;

function TKODBCInstaller.GetSQLRemoveDriver: TSQLRemoveDriverProc;
begin
	Result := InternalLoadProc( sODBC_SQLRemoveDriverProc, @FSQLRemoveDriverProc );
end;

function TKODBCInstaller.GetSQLConfigDriver: TSQLConfigDriverProc;
begin
	Result := InternalLoadProc( sODBC_SQLConfigDriverProc, @FSQLConfigDriverProc );
end;

function TKODBCInstaller.GetSQLInstallerError: TSQLInstallerErrorProc;
begin
	Result := InternalLoadProc( sODBC_SQLInstallerErrorProc, @FSQLInstallerErrorProc );
end;

function TKODBCInstaller.GetSQLPostInstallerError: TSQLPostInstallerErrorProc;
begin
	Result := InternalLoadProc( sODBC_SQLPostInstallerErrorProc, @FSQLPostInstallerErrorProc );
end;

function TKODBCInstaller.GetSQLWriteFileDSN: TSQLWriteFileDSNProc;
begin
	Result := InternalLoadProc( sODBC_SQLWriteFileDSNProc, @FSQLWriteFileDSNProc );
end;

function TKODBCInstaller.GetSQLReadFileDSN: TSQLReadFileDSNProc;
begin
	Result := InternalLoadProc( sODBC_SQLReadFileDSNProc, @FSQLReadFileDSNProc );
end;

function TKODBCInstaller.GetSQLInstallDriverEx: TSQLInstallDriverExProc;
begin
	Result := InternalLoadProc( sODBC_SQLInstallDriverExProc, @FSQLInstallDriverExProc );
end;

function TKODBCInstaller.GetSQLInstallTranslatorEx: TSQLInstallTranslatorExProc;
begin
	Result := InternalLoadProc( sODBC_SQLInstallTranslatorExProc, @FSQLInstallTranslatorExProc );
end;

function TKODBCInstaller.GetSQLGetConfigMode: TSQLGetConfigModeProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetConfigModeProc, @FSQLGetConfigModeProc );
end;

function TKODBCInstaller.GetSQLSetConfigMode: TSQLSetConfigModeProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetConfigModeProc, @FSQLSetConfigModeProc );
end;

{
function TKODBCInstaller.GetConfigDSN: TConfigDSNProc;
begin
	Result := InternalLoadProc( sODBC_ConfigDSNProc, @FConfigDSNProc );
end;

function TKODBCInstaller.GetConfigTranslator: TConfigTranslatorProc;
begin
	Result := InternalLoadProc( sODBC_ConfigTranslatorProc, @FConfigTranslatorProc );
end;

function TKODBCInstaller.GetConfigDriver: TConfigDriverProc;
begin
	Result := InternalLoadProc( sODBC_ConfigDriverProc, @FConfigDriverProc );
end;
}

end.
