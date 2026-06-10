unit ukODBCCore;

interface

uses Windows, ukLibrary, ukODBCTypes;

type

{ TKODBCCore }

{
		functions map from SQL.h and SQLExt.h;
		these functions should be found in ODBC32.DLL;
}

	EKODBCCore = class( EKCustomLibraryMapping );

	TKODBCCore = class( TKCustomLibraryMapping )
	private
{ SQL.h }
		FSQLAllocConnectProc: TSQLAllocConnectProc;
		FSQLAllocEnvProc: TSQLAllocEnvProc;
		FSQLAllocHandleProc: TSQLAllocHandleProc;
		FSQLAllocStmtProc: TSQLAllocStmtProc;
		FSQLBindColProc: TSQLBindColProc;
		FSQLBindParamProc: TSQLBindParamProc;
		FSQLCancelProc: TSQLCancelProc;
		FSQLCloseCursorProc: TSQLCloseCursorProc;
		FSQLColAttributeProc: TSQLColAttributeProc;
		FSQLColumnsProc: TSQLColumnsProc;
		FSQLConnectProc: TSQLConnectProc;
		FSQLCopyDescProc: TSQLCopyDescProc;
		FSQLDataSourcesProc: TSQLDataSourcesProc;
		FSQLDescribeColProc: TSQLDescribeColProc;
		FSQLDisconnectProc: TSQLDisconnectProc;
		FSQLEndTranProc: TSQLEndTranProc;
		FSQLErrorProc: TSQLErrorProc;
		FSQLExecDirectProc: TSQLExecDirectProc;
		FSQLExecuteProc: TSQLExecuteProc;
		FSQLFetchProc: TSQLFetchProc;
		FSQLFetchScrollProc: TSQLFetchScrollProc;
		FSQLFreeConnectProc: TSQLFreeConnectProc;
		FSQLFreeEnvProc: TSQLFreeEnvProc;
		FSQLFreeHandleProc: TSQLFreeHandleProc;
		FSQLFreeStmtProc: TSQLFreeStmtProc;
		FSQLGetConnectAttrProc: TSQLGetConnectAttrProc;
		FSQLGetConnectOptionProc: TSQLGetConnectOptionProc;
		FSQLGetCursorNameProc: TSQLGetCursorNameProc;
		FSQLGetDataProc: TSQLGetDataProc;
		FSQLGetDescFieldProc: TSQLGetDescFieldProc;
		FSQLGetDescRecProc: TSQLGetDescRecProc;
		FSQLGetDiagFieldProc: TSQLGetDiagFieldProc;
		FSQLGetDiagRecProc: TSQLGetDiagRecProc;
		FSQLGetEnvAttrProc: TSQLGetEnvAttrProc;
		FSQLGetFunctionsProc: TSQLGetFunctionsProc;
		FSQLGetInfoProc: TSQLGetInfoProc;
		FSQLGetStmtAttrProc: TSQLGetStmtAttrProc;
		FSQLGetStmtOptionProc: TSQLGetStmtOptionProc;
		FSQLGetTypeInfoProc: TSQLGetTypeInfoProc;
		FSQLNumResultColsProc: TSQLNumResultColsProc;
		FSQLParamDataProc: TSQLParamDataProc;
		FSQLPrepareProc: TSQLPrepareProc;
		FSQLPutDataProc: TSQLPutDataProc;
		FSQLRowCountProc: TSQLRowCountProc;
		FSQLSetConnectAttrProc: TSQLSetConnectAttrProc;
		FSQLSetConnectOptionProc: TSQLSetConnectOptionProc;
		FSQLSetCursorNameProc: TSQLSetCursorNameProc;
		FSQLSetDescFieldProc: TSQLSetDescFieldProc;
		FSQLSetDescRecProc: TSQLSetDescRecProc;
		FSQLSetEnvAttrProc: TSQLSetEnvAttrProc;
		FSQLSetParamProc: TSQLSetParamProc;
		FSQLSetStmtAttrProc: TSQLSetStmtAttrProc;
		FSQLSetStmtOptionProc: TSQLSetStmtOptionProc;
		FSQLSpecialColumnsProc: TSQLSpecialColumnsProc;
		FSQLStatisticsProc: TSQLStatisticsProc;
		FSQLTablesProc: TSQLTablesProc;
		FSQLTransactProc: TSQLTransactProc;

{ SQLExt.h }
		FSQLDriverConnectProc: TSQLDriverConnectProc;
		FSQLBrowseConnectProc: TSQLBrowseConnectProc;
		FSQLBulkOperationsProc: TSQLBulkOperationsProc;
		FSQLColAttributesProc: TSQLColAttributesProc;
		FSQLColumnPrivilegesProc: TSQLColumnPrivilegesProc;
		FSQLDescribeParamProc: TSQLDescribeParamProc;
		FSQLExtendedFetchProc: TSQLExtendedFetchProc;
		FSQLForeignKeysProc: TSQLForeignKeysProc;
		FSQLMoreResultsProc: TSQLMoreResultsProc;
		FSQLNativeSqlProc: TSQLNativeSqlProc;
		FSQLNumParamsProc: TSQLNumParamsProc;
		FSQLParamOptionsProc: TSQLParamOptionsProc;
		FSQLPrimaryKeysProc: TSQLPrimaryKeysProc;
		FSQLProcedureColumnsProc: TSQLProcedureColumnsProc;
		FSQLProceduresProc: TSQLProceduresProc;
		FSQLSetPosProc: TSQLSetPosProc;
		FSQLTablePrivilegesProc: TSQLTablePrivilegesProc;
		FSQLDriversProc: TSQLDriversProc;
		FSQLBindParameterProc: TSQLBindParameterProc;
		FSQLAllocHandleStdProc: TSQLAllocHandleStdProc;
		FSQLSetScrollOptionsProc: TSQLSetScrollOptionsProc;

{ SQL.h }
		function GetSQLAllocConnect: TSQLAllocConnectProc;
		function GetSQLAllocEnv: TSQLAllocEnvProc;
		function GetSQLAllocHandle: TSQLAllocHandleProc;
		function GetSQLAllocStmt: TSQLAllocStmtProc;
		function GetSQLBindCol: TSQLBindColProc;
		function GetSQLBindParam: TSQLBindParamProc;
		function GetSQLCancel: TSQLCancelProc;
		function GetSQLCloseCursor: TSQLCloseCursorProc;
		function GetSQLColAttribute: TSQLColAttributeProc;
		function GetSQLColumns: TSQLColumnsProc;
		function GetSQLConnect: TSQLConnectProc;
		function GetSQLCopyDesc: TSQLCopyDescProc;
		function GetSQLDataSources: TSQLDataSourcesProc;
		function GetSQLDescribeCol: TSQLDescribeColProc;
		function GetSQLDisconnect: TSQLDisconnectProc;
		function GetSQLEndTran: TSQLEndTranProc;
		function GetSQLError: TSQLErrorProc;
		function GetSQLExecDirect: TSQLExecDirectProc;
		function GetSQLExecute: TSQLExecuteProc;
		function GetSQLFetch: TSQLFetchProc;
		function GetSQLFetchScroll: TSQLFetchScrollProc;
		function GetSQLFreeConnect: TSQLFreeConnectProc;
		function GetSQLFreeEnv: TSQLFreeEnvProc;
		function GetSQLFreeHandle: TSQLFreeHandleProc;
		function GetSQLFreeStmt: TSQLFreeStmtProc;
		function GetSQLGetConnectAttr: TSQLGetConnectAttrProc;
		function GetSQLGetConnectOption: TSQLGetConnectOptionProc;
		function GetSQLGetCursorName: TSQLGetCursorNameProc;
		function GetSQLGetData: TSQLGetDataProc;
		function GetSQLGetDescField: TSQLGetDescFieldProc;
		function GetSQLGetDescRec: TSQLGetDescRecProc;
		function GetSQLGetDiagField: TSQLGetDiagFieldProc;
		function GetSQLGetDiagRec: TSQLGetDiagRecProc;
		function GetSQLGetEnvAttr: TSQLGetEnvAttrProc;
		function GetSQLGetFunctions: TSQLGetFunctionsProc;
		function GetSQLGetInfo: TSQLGetInfoProc;
		function GetSQLGetStmtAttr: TSQLGetStmtAttrProc;
		function GetSQLGetStmtOption: TSQLGetStmtOptionProc;
		function GetSQLGetTypeInfo: TSQLGetTypeInfoProc;
		function GetSQLNumResultCols: TSQLNumResultColsProc;
		function GetSQLParamData: TSQLParamDataProc;
		function GetSQLPrepare: TSQLPrepareProc;
		function GetSQLPutData: TSQLPutDataProc;
		function GetSQLRowCount: TSQLRowCountProc;
		function GetSQLSetConnectAttr: TSQLSetConnectAttrProc;
		function GetSQLSetConnectOption: TSQLSetConnectOptionProc;
		function GetSQLSetCursorName: TSQLSetCursorNameProc;
		function GetSQLSetDescField: TSQLSetDescFieldProc;
		function GetSQLSetDescRec: TSQLSetDescRecProc;
		function GetSQLSetEnvAttr: TSQLSetEnvAttrProc;
		function GetSQLSetParam: TSQLSetParamProc;
		function GetSQLSetStmtAttr: TSQLSetStmtAttrProc;
		function GetSQLSetStmtOption: TSQLSetStmtOptionProc;
		function GetSQLSpecialColumns: TSQLSpecialColumnsProc;
		function GetSQLStatistics: TSQLStatisticsProc;
		function GetSQLTables: TSQLTablesProc;
		function GetSQLTransact: TSQLTransactProc;

{ SQLExt.h }
		function GetSQLDriverConnectProc: TSQLDriverConnectProc;
		function GetSQLBrowseConnectProc: TSQLBrowseConnectProc;
		function GetSQLBulkOperationsProc: TSQLBulkOperationsProc;
		function GetSQLColAttributesProc: TSQLColAttributesProc;
		function GetSQLColumnPrivilegesProc: TSQLColumnPrivilegesProc;
		function GetSQLDescribeParamProc: TSQLDescribeParamProc;
		function GetSQLExtendedFetchProc: TSQLExtendedFetchProc;
		function GetSQLForeignKeysProc: TSQLForeignKeysProc;
		function GetSQLMoreResultsProc: TSQLMoreResultsProc;
		function GetSQLNativeSqlProc: TSQLNativeSqlProc;
		function GetSQLNumParamsProc: TSQLNumParamsProc;
		function GetSQLParamOptionsProc: TSQLParamOptionsProc;
		function GetSQLPrimaryKeysProc: TSQLPrimaryKeysProc;
		function GetSQLProcedureColumnsProc: TSQLProcedureColumnsProc;
		function GetSQLProceduresProc: TSQLProceduresProc;
		function GetSQLSetPosProc: TSQLSetPosProc;
		function GetSQLTablePrivilegesProc: TSQLTablePrivilegesProc;
		function GetSQLDriversProc: TSQLDriversProc;
		function GetSQLBindParameterProc: TSQLBindParameterProc;
		function GetSQLAllocHandleStdProc: TSQLAllocHandleStdProc;
		function GetSQLSetScrollOptionsProc: TSQLSetScrollOptionsProc;

	public
		constructor Create; override;

{ SQL.h }
		property SQLAllocConnect: TSQLAllocConnectProc
						 read GetSQLAllocConnect;
		property SQLAllocEnv: TSQLAllocEnvProc
						 read GetSQLAllocEnv;
		property SQLAllocHandle: TSQLAllocHandleProc
						 read GetSQLAllocHandle;
		property SQLAllocStmt: TSQLAllocStmtProc
						 read GetSQLAllocStmt;
		property SQLBindCol: TSQLBindColProc
						 read GetSQLBindCol;
		property SQLBindParam: TSQLBindParamProc
						 read GetSQLBindParam;
		property SQLCancel: TSQLCancelProc
						 read GetSQLCancel;
		property SQLCloseCursor: TSQLCloseCursorProc
						 read GetSQLCloseCursor;
		property SQLColAttribute: TSQLColAttributeProc
						 read GetSQLColAttribute;
		property SQLColumns: TSQLColumnsProc
						 read GetSQLColumns;
		property SQLConnect: TSQLConnectProc
						 read GetSQLConnect;
		property SQLCopyDesc: TSQLCopyDescProc
						 read GetSQLCopyDesc;
		property SQLDataSources: TSQLDataSourcesProc
						 read GetSQLDataSources;
		property SQLDescribeCol: TSQLDescribeColProc
						 read GetSQLDescribeCol;
		property SQLDisconnect: TSQLDisconnectProc
						 read GetSQLDisconnect;
		property SQLEndTran: TSQLEndTranProc
						 read GetSQLEndTran;
		property SQLError: TSQLErrorProc
						 read GetSQLError;
		property SQLExecDirect: TSQLExecDirectProc
						 read GetSQLExecDirect;
		property SQLExecute: TSQLExecuteProc
						 read GetSQLExecute;
		property SQLFetch: TSQLFetchProc
						 read GetSQLFetch;
		property SQLFetchScroll: TSQLFetchScrollProc
						 read GetSQLFetchScroll;
		property SQLFreeConnect: TSQLFreeConnectProc
						 read GetSQLFreeConnect;
		property SQLFreeEnv: TSQLFreeEnvProc
						 read GetSQLFreeEnv;
		property SQLFreeHandle: TSQLFreeHandleProc
						 read GetSQLFreeHandle;
		property SQLFreeStmt: TSQLFreeStmtProc
						 read GetSQLFreeStmt;
		property SQLGetConnectAttr: TSQLGetConnectAttrProc
						 read GetSQLGetConnectAttr;
		property SQLGetConnectOption: TSQLGetConnectOptionProc
						 read GetSQLGetConnectOption;
		property SQLGetCursorName: TSQLGetCursorNameProc
						 read GetSQLGetCursorName;
		property SQLGetData: TSQLGetDataProc
						 read GetSQLGetData;
		property SQLGetDescField: TSQLGetDescFieldProc
						 read GetSQLGetDescField;
		property SQLGetDescRec: TSQLGetDescRecProc
						 read GetSQLGetDescRec;
		property SQLGetDiagField: TSQLGetDiagFieldProc
						 read GetSQLGetDiagField;
		property SQLGetDiagRec: TSQLGetDiagRecProc
						 read GetSQLGetDiagRec;
		property SQLGetEnvAttr: TSQLGetEnvAttrProc
						 read GetSQLGetEnvAttr;
		property SQLGetFunctions: TSQLGetFunctionsProc
						 read GetSQLGetFunctions;
		property SQLGetInfo: TSQLGetInfoProc
						 read GetSQLGetInfo;
		property SQLGetStmtAttr: TSQLGetStmtAttrProc
						 read GetSQLGetStmtAttr;
		property SQLGetStmtOption: TSQLGetStmtOptionProc
						 read GetSQLGetStmtOption;
		property SQLGetTypeInfo: TSQLGetTypeInfoProc
						 read GetSQLGetTypeInfo;
		property SQLNumResultCols: TSQLNumResultColsProc
						 read GetSQLNumResultCols;
		property SQLParamData: TSQLParamDataProc
						 read GetSQLParamData;
		property SQLPrepare: TSQLPrepareProc
						 read GetSQLPrepare;
		property SQLPutData: TSQLPutDataProc
						 read GetSQLPutData;
		property SQLRowCount: TSQLRowCountProc
						 read GetSQLRowCount;
		property SQLSetConnectAttr: TSQLSetConnectAttrProc
						 read GetSQLSetConnectAttr;
		property SQLSetConnectOption: TSQLSetConnectOptionProc
						 read GetSQLSetConnectOption;
		property SQLSetCursorName: TSQLSetCursorNameProc
						 read GetSQLSetCursorName;
		property SQLSetDescField: TSQLSetDescFieldProc
						 read GetSQLSetDescField;
		property SQLSetDescRec: TSQLSetDescRecProc
						 read GetSQLSetDescRec;
		property SQLSetEnvAttr: TSQLSetEnvAttrProc
						 read GetSQLSetEnvAttr;
		property SQLSetParam: TSQLSetParamProc
						 read GetSQLSetParam;
		property SQLSetStmtAttr: TSQLSetStmtAttrProc
						 read GetSQLSetStmtAttr;
		property SQLSetStmtOption: TSQLSetStmtOptionProc
						 read GetSQLSetStmtOption;
		property SQLSpecialColumns: TSQLSpecialColumnsProc
						 read GetSQLSpecialColumns;
		property SQLStatistics: TSQLStatisticsProc
						 read GetSQLStatistics;
		property SQLTables: TSQLTablesProc
						 read GetSQLTables;
		property SQLTransact: TSQLTransactProc
						 read GetSQLTransact;
{ SQLExt.h }
		property SQLDriverConnect: TSQLDriverConnectProc
						 read GetSQLDriverConnectProc;
		property SQLBrowseConnect: TSQLBrowseConnectProc
						 read GetSQLBrowseConnectProc;
		property SQLBulkOperations: TSQLBulkOperationsProc
						 read GetSQLBulkOperationsProc;
		property SQLColAttributes: TSQLColAttributesProc
						 read GetSQLColAttributesProc;
		property SQLColumnPrivileges: TSQLColumnPrivilegesProc
						 read GetSQLColumnPrivilegesProc;
		property SQLDescribeParam: TSQLDescribeParamProc
						 read GetSQLDescribeParamProc;
		property SQLExtendedFetch: TSQLExtendedFetchProc
						 read GetSQLExtendedFetchProc;
		property SQLForeignKeys: TSQLForeignKeysProc
						 read GetSQLForeignKeysProc;
		property SQLMoreResults: TSQLMoreResultsProc
						 read GetSQLMoreResultsProc;
		property SQLNativeSql: TSQLNativeSqlProc
						 read GetSQLNativeSqlProc;
		property SQLNumParams: TSQLNumParamsProc
						 read GetSQLNumParamsProc;
		property SQLParamOptions: TSQLParamOptionsProc
						 read GetSQLParamOptionsProc;
		property SQLPrimaryKeys: TSQLPrimaryKeysProc
						 read GetSQLPrimaryKeysProc;
		property SQLProcedureColumns: TSQLProcedureColumnsProc
						 read GetSQLProcedureColumnsProc;
		property SQLProcedures: TSQLProceduresProc
						 read GetSQLProceduresProc;
		property SQLSetPos: TSQLSetPosProc
						 read GetSQLSetPosProc;
		property SQLTablePrivileges: TSQLTablePrivilegesProc
						 read GetSQLTablePrivilegesProc;
		property SQLDrivers: TSQLDriversProc
						 read GetSQLDriversProc;
		property SQLBindParameter: TSQLBindParameterProc
						 read GetSQLBindParameterProc;
		property SQLAllocHandleStd: TSQLAllocHandleStdProc
						 read GetSQLAllocHandleStdProc;
		property SQLSetScrollOptions: TSQLSetScrollOptionsProc
						 read GetSQLSetScrollOptionsProc;

	end;

implementation

ResourceString
	sODBC_LibNameCore = 'ODBC32.DLL';

{ SQL.h }
	sODBC_SQLAllocConnectProc = 'SQLAllocConnect';
	sODBC_SQLAllocEnvProc = 'SQLAllocEnv';
	sODBC_SQLAllocHandleProc = 'SQLAllocHandle';
	sODBC_SQLAllocStmtProc = 'SQLAllocStmt';
	sODBC_SQLBindColProc = 'SQLBindCol';
	sODBC_SQLBindParamProc = 'SQLBindParam';
	sODBC_SQLCancelProc = 'SQLCancel';
	sODBC_SQLCloseCursorProc = 'SQLCloseCursor';
	sODBC_SQLColAttributeProc = 'SQLColAttribute';
	sODBC_SQLColumnsProc = 'SQLColumns';
	sODBC_SQLConnectProc = 'SQLConnect';
	sODBC_SQLCopyDescProc = 'SQLCopyDesc';
	sODBC_SQLDataSourcesProc = 'SQLDataSources';
	sODBC_SQLDescribeColProc = 'SQLDescribeCol';
	sODBC_SQLDisconnectProc = 'SQLDisconnect';
	sODBC_SQLEndTranProc = 'SQLEndTran';
	sODBC_SQLErrorProc = 'SQLError';
	sODBC_SQLExecDirectProc = 'SQLExecDirect';
	sODBC_SQLExecuteProc = 'SQLExecute';
	sODBC_SQLFetchProc = 'SQLFetch';
	sODBC_SQLFetchScrollProc = 'SQLFetchScroll';
	sODBC_SQLFreeConnectProc = 'SQLFreeConnect';
	sODBC_SQLFreeEnvProc = 'SQLFreeEnv';
	sODBC_SQLFreeHandleProc = 'SQLFreeHandle';
	sODBC_SQLFreeStmtProc = 'SQLFreeStmt';
	sODBC_SQLGetConnectAttrProc = 'SQLGetConnectAttr';
	sODBC_SQLGetConnectOptionProc = 'SQLGetConnectOption';
	sODBC_SQLGetCursorNameProc = 'SQLGetCursorName';
	sODBC_SQLGetDataProc = 'SQLGetData';
	sODBC_SQLGetDescFieldProc = 'SQLGetDescField';
	sODBC_SQLGetDescRecProc = 'SQLGetDescRec';
	sODBC_SQLGetDiagFieldProc = 'SQLGetDiagField';
	sODBC_SQLGetDiagRecProc = 'SQLGetDiagRec';
	sODBC_SQLGetEnvAttrProc = 'SQLGetEnvAttr';
	sODBC_SQLGetFunctionsProc = 'SQLGetFunctions';
	sODBC_SQLGetInfoProc = 'SQLGetInfo';
	sODBC_SQLGetStmtAttrProc = 'SQLGetStmtAttr';
	sODBC_SQLGetStmtOptionProc = 'SQLGetStmtOption';
	sODBC_SQLGetTypeInfoProc = 'SQLGetTypeInfo';
	sODBC_SQLNumResultColsProc = 'SQLNumResultCols';
	sODBC_SQLParamDataProc = 'SQLParamData';
	sODBC_SQLPrepareProc = 'SQLPrepare';
	sODBC_SQLPutDataProc = 'SQLPutData';
	sODBC_SQLRowCountProc = 'SQLRowCount';
	sODBC_SQLSetConnectAttrProc = 'SQLSetConnectAttr';
	sODBC_SQLSetConnectOptionProc = 'SQLSetConnectOption';
	sODBC_SQLSetCursorNameProc = 'SQLSetCursorName';
	sODBC_SQLSetDescFieldProc = 'SQLSetDescField';
	sODBC_SQLSetDescRecProc = 'SQLSetDescRec';
	sODBC_SQLSetEnvAttrProc = 'SQLSetEnvAttr';
	sODBC_SQLSetParamProc = 'SQLSetParam';
	sODBC_SQLSetStmtAttrProc = 'SQLSetStmtAttr';
	sODBC_SQLSetStmtOptionProc = 'SQLSetStmtOption';
	sODBC_SQLSpecialColumnsProc = 'SQLSpecialColumns';
	sODBC_SQLStatisticsProc = 'SQLStatistics';
	sODBC_SQLTablesProc = 'SQLTables';
	sODBC_SQLTransactProc = 'SQLTransact';
	
{ SQLExt.h }
	sODBC_SQLDriverConnectProc = 'SQLDriverConnect';
	sODBC_SQLBrowseConnectProc = 'SQLBrowseConnect';
	sODBC_SQLBulkOperationsProc = 'SQLBulkOperations';
	sODBC_SQLColAttributesProc = 'SQLColAttributes';
	sODBC_SQLColumnPrivilegesProc = 'SQLColumnPrivileges';
	sODBC_SQLDescribeParamProc = 'SQLDescribeParam';
	sODBC_SQLExtendedFetchProc = 'SQLExtendedFetch';
	sODBC_SQLForeignKeysProc = 'SQLForeignKeys';
	sODBC_SQLMoreResultsProc = 'SQLMoreResults';
	sODBC_SQLNativeSqlProc = 'SQLNativeSql';
	sODBC_SQLNumParamsProc = 'SQLNumParams';
	sODBC_SQLParamOptionsProc = 'SQLParamOptions';
	sODBC_SQLPrimaryKeysProc = 'SQLPrimaryKeys';
	sODBC_SQLProcedureColumnsProc = 'SQLProcedureColumns';
	sODBC_SQLProceduresProc = 'SQLProcedures';
	sODBC_SQLSetPosProc = 'SQLSetPos';
	sODBC_SQLTablePrivilegesProc = 'SQLTablePrivileges';
	sODBC_SQLDriversProc = 'SQLDrivers';
	sODBC_SQLBindParameterProc = 'SQLBindParameter';
	sODBC_SQLAllocHandleStdProc = 'SQLAllocHandleStd';
	sODBC_SQLSetScrollOptionsProc = 'SQLSetScrollOptions';

{
--------------------------------------------------------------------------
----------------------------- TKODBCCore ---------------------------------
--------------------------------------------------------------------------
}

constructor TKODBCCore.Create;
begin
	inherited Create;
	SetLibraryName( sODBC_LibNameCore );
end;

{ SQL.h }

function TKODBCCore.GetSQLAllocConnect: TSQLAllocConnectProc;
begin
	Result := InternalLoadProc( sODBC_SQLAllocConnectProc, @FSQLAllocConnectProc );
end;

function TKODBCCore.GetSQLAllocEnv: TSQLAllocEnvProc;
begin
	Result := InternalLoadProc( sODBC_SQLAllocEnvProc, @FSQLAllocEnvProc );
end;

function TKODBCCore.GetSQLAllocHandle: TSQLAllocHandleProc;
begin
	Result := InternalLoadProc( sODBC_SQLAllocHandleProc, @FSQLAllocHandleProc );
end;

function TKODBCCore.GetSQLAllocStmt: TSQLAllocStmtProc;
begin
	Result := InternalLoadProc( sODBC_SQLAllocStmtProc, @FSQLAllocStmtProc );
end;

function TKODBCCore.GetSQLBindCol: TSQLBindColProc;
begin
	Result := InternalLoadProc( sODBC_SQLBindColProc, @FSQLBindColProc );
end;

function TKODBCCore.GetSQLBindParam: TSQLBindParamProc;
begin
	Result := InternalLoadProc( sODBC_SQLBindParamProc, @FSQLBindParamProc );
end;

function TKODBCCore.GetSQLCancel: TSQLCancelProc;
begin
	Result := InternalLoadProc( sODBC_SQLCancelProc, @FSQLCancelProc );
end;

function TKODBCCore.GetSQLCloseCursor: TSQLCloseCursorProc;
begin
	Result := InternalLoadProc( sODBC_SQLCloseCursorProc, @FSQLCloseCursorProc );
end;

function TKODBCCore.GetSQLColAttribute: TSQLColAttributeProc;
begin
	Result := InternalLoadProc( sODBC_SQLColAttributeProc, @FSQLColAttributeProc );
end;

function TKODBCCore.GetSQLColumns: TSQLColumnsProc;
begin
	Result := InternalLoadProc( sODBC_SQLColumnsProc, @FSQLColumnsProc );
end;

function TKODBCCore.GetSQLConnect: TSQLConnectProc;
begin
	Result := InternalLoadProc( sODBC_SQLConnectProc, @FSQLConnectProc );
end;

function TKODBCCore.GetSQLCopyDesc: TSQLCopyDescProc;
begin
	Result := InternalLoadProc( sODBC_SQLCopyDescProc, @FSQLCopyDescProc );
end;

function TKODBCCore.GetSQLDataSources: TSQLDataSourcesProc;
begin
	Result := InternalLoadProc( sODBC_SQLDataSourcesProc, @FSQLDataSourcesProc );
end;

function TKODBCCore.GetSQLDescribeCol: TSQLDescribeColProc;
begin
	Result := InternalLoadProc( sODBC_SQLDescribeColProc, @FSQLDescribeColProc );
end;

function TKODBCCore.GetSQLDisconnect: TSQLDisconnectProc;
begin
	Result := InternalLoadProc( sODBC_SQLDisconnectProc, @FSQLDisconnectProc );
end;

function TKODBCCore.GetSQLEndTran: TSQLEndTranProc;
begin
	Result := InternalLoadProc( sODBC_SQLEndTranProc, @FSQLEndTranProc );
end;

function TKODBCCore.GetSQLError: TSQLErrorProc;
begin
	Result := InternalLoadProc( sODBC_SQLErrorProc, @FSQLErrorProc );
end;

function TKODBCCore.GetSQLExecDirect: TSQLExecDirectProc;
begin
	Result := InternalLoadProc( sODBC_SQLExecDirectProc, @FSQLExecDirectProc );
end;

function TKODBCCore.GetSQLExecute: TSQLExecuteProc;
begin
	Result := InternalLoadProc( sODBC_SQLExecuteProc, @FSQLExecuteProc );
end;

function TKODBCCore.GetSQLFetch: TSQLFetchProc;
begin
	Result := InternalLoadProc( sODBC_SQLFetchProc, @FSQLFetchProc );
end;

function TKODBCCore.GetSQLFetchScroll: TSQLFetchScrollProc;
begin
	Result := InternalLoadProc( sODBC_SQLFetchScrollProc, @FSQLFetchScrollProc );
end;

function TKODBCCore.GetSQLFreeConnect: TSQLFreeConnectProc;
begin
	Result := InternalLoadProc( sODBC_SQLFreeConnectProc, @FSQLFreeConnectProc );
end;

function TKODBCCore.GetSQLFreeEnv: TSQLFreeEnvProc;
begin
	Result := InternalLoadProc( sODBC_SQLFreeEnvProc, @FSQLFreeEnvProc );
end;

function TKODBCCore.GetSQLFreeHandle: TSQLFreeHandleProc;
begin
	Result := InternalLoadProc( sODBC_SQLFreeHandleProc, @FSQLFreeHandleProc );
end;

function TKODBCCore.GetSQLFreeStmt: TSQLFreeStmtProc;
begin
	Result := InternalLoadProc( sODBC_SQLFreeStmtProc, @FSQLFreeStmtProc );
end;

function TKODBCCore.GetSQLGetConnectAttr: TSQLGetConnectAttrProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetConnectAttrProc, @FSQLGetConnectAttrProc );
end;

function TKODBCCore.GetSQLGetConnectOption: TSQLGetConnectOptionProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetConnectOptionProc, @FSQLGetConnectOptionProc );
end;

function TKODBCCore.GetSQLGetCursorName: TSQLGetCursorNameProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetCursorNameProc, @FSQLGetCursorNameProc );
end;

function TKODBCCore.GetSQLGetData: TSQLGetDataProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetDataProc, @FSQLGetDataProc );
end;

function TKODBCCore.GetSQLGetDescField: TSQLGetDescFieldProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetDescFieldProc, @FSQLGetDescFieldProc );
end;

function TKODBCCore.GetSQLGetDescRec: TSQLGetDescRecProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetDescRecProc, @FSQLGetDescRecProc );
end;

function TKODBCCore.GetSQLGetDiagField: TSQLGetDiagFieldProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetDiagFieldProc, @FSQLGetDiagFieldProc );
end;

function TKODBCCore.GetSQLGetDiagRec: TSQLGetDiagRecProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetDiagRecProc, @FSQLGetDiagRecProc );
end;

function TKODBCCore.GetSQLGetEnvAttr: TSQLGetEnvAttrProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetEnvAttrProc, @FSQLGetEnvAttrProc );
end;

function TKODBCCore.GetSQLGetFunctions: TSQLGetFunctionsProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetFunctionsProc, @FSQLGetFunctionsProc );
end;

function TKODBCCore.GetSQLGetInfo: TSQLGetInfoProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetInfoProc, @FSQLGetInfoProc );
end;

function TKODBCCore.GetSQLGetStmtAttr: TSQLGetStmtAttrProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetStmtAttrProc, @FSQLGetStmtAttrProc );
end;

function TKODBCCore.GetSQLGetStmtOption: TSQLGetStmtOptionProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetStmtOptionProc, @FSQLGetStmtOptionProc );
end;

function TKODBCCore.GetSQLGetTypeInfo: TSQLGetTypeInfoProc;
begin
	Result := InternalLoadProc( sODBC_SQLGetTypeInfoProc, @FSQLGetTypeInfoProc );
end;

function TKODBCCore.GetSQLNumResultCols: TSQLNumResultColsProc;
begin
	Result := InternalLoadProc( sODBC_SQLNumResultColsProc, @FSQLNumResultColsProc );
end;

function TKODBCCore.GetSQLParamData: TSQLParamDataProc;
begin
	Result := InternalLoadProc( sODBC_SQLParamDataProc, @FSQLParamDataProc );
end;

function TKODBCCore.GetSQLPrepare: TSQLPrepareProc;
begin
	Result := InternalLoadProc( sODBC_SQLPrepareProc, @FSQLPrepareProc );
end;

function TKODBCCore.GetSQLPutData: TSQLPutDataProc;
begin
	Result := InternalLoadProc( sODBC_SQLPutDataProc, @FSQLPutDataProc );
end;

function TKODBCCore.GetSQLRowCount: TSQLRowCountProc;
begin
	Result := InternalLoadProc( sODBC_SQLRowCountProc, @FSQLRowCountProc );
end;

function TKODBCCore.GetSQLSetConnectAttr: TSQLSetConnectAttrProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetConnectAttrProc, @FSQLSetConnectAttrProc );
end;

function TKODBCCore.GetSQLSetConnectOption: TSQLSetConnectOptionProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetConnectOptionProc, @FSQLSetConnectOptionProc );
end;

function TKODBCCore.GetSQLSetCursorName: TSQLSetCursorNameProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetCursorNameProc, @FSQLSetCursorNameProc );
end;

function TKODBCCore.GetSQLSetDescField: TSQLSetDescFieldProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetDescFieldProc, @FSQLSetDescFieldProc );
end;

function TKODBCCore.GetSQLSetDescRec: TSQLSetDescRecProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetDescRecProc, @FSQLSetDescRecProc );
end;

function TKODBCCore.GetSQLSetEnvAttr: TSQLSetEnvAttrProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetEnvAttrProc, @FSQLSetEnvAttrProc );
end;

function TKODBCCore.GetSQLSetParam: TSQLSetParamProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetParamProc, @FSQLSetParamProc );
end;

function TKODBCCore.GetSQLSetStmtAttr: TSQLSetStmtAttrProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetStmtAttrProc, @FSQLSetStmtAttrProc );
end;

function TKODBCCore.GetSQLSetStmtOption: TSQLSetStmtOptionProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetStmtOptionProc, @FSQLSetStmtOptionProc );
end;

function TKODBCCore.GetSQLSpecialColumns: TSQLSpecialColumnsProc;
begin
	Result := InternalLoadProc( sODBC_SQLSpecialColumnsProc, @FSQLSpecialColumnsProc );
end;

function TKODBCCore.GetSQLStatistics: TSQLStatisticsProc;
begin
	Result := InternalLoadProc( sODBC_SQLStatisticsProc, @FSQLStatisticsProc );
end;

function TKODBCCore.GetSQLTables: TSQLTablesProc;
begin
	Result := InternalLoadProc( sODBC_SQLTablesProc, @FSQLTablesProc );
end;

function TKODBCCore.GetSQLTransact: TSQLTransactProc;
begin
	Result := InternalLoadProc( sODBC_SQLTransactProc, @FSQLTransactProc );
end;

{ SQLExt.h }

function TKODBCCore.GetSQLDriverConnectProc: TSQLDriverConnectProc;
begin
	Result := InternalLoadProc( sODBC_SQLDriverConnectProc, @FSQLDriverConnectProc );
end;

function TKODBCCore.GetSQLBrowseConnectProc: TSQLBrowseConnectProc;
begin
	Result := InternalLoadProc( sODBC_SQLBrowseConnectProc, @FSQLBrowseConnectProc );
end;

function TKODBCCore.GetSQLBulkOperationsProc: TSQLBulkOperationsProc;
begin
	Result := InternalLoadProc( sODBC_SQLBulkOperationsProc, @FSQLBulkOperationsProc );
end;

function TKODBCCore.GetSQLColAttributesProc: TSQLColAttributesProc;
begin
	Result := InternalLoadProc( sODBC_SQLColAttributesProc, @FSQLColAttributesProc );
end;

function TKODBCCore.GetSQLColumnPrivilegesProc: TSQLColumnPrivilegesProc;
begin
	Result := InternalLoadProc( sODBC_SQLColumnPrivilegesProc, @FSQLColumnPrivilegesProc );
end;

function TKODBCCore.GetSQLDescribeParamProc: TSQLDescribeParamProc;
begin
	Result := InternalLoadProc( sODBC_SQLDescribeParamProc, @FSQLDescribeParamProc );
end;

function TKODBCCore.GetSQLExtendedFetchProc: TSQLExtendedFetchProc;
begin
	Result := InternalLoadProc( sODBC_SQLExtendedFetchProc, @FSQLExtendedFetchProc );
end;

function TKODBCCore.GetSQLForeignKeysProc: TSQLForeignKeysProc;
begin
	Result := InternalLoadProc( sODBC_SQLForeignKeysProc, @FSQLForeignKeysProc );
end;

function TKODBCCore.GetSQLMoreResultsProc: TSQLMoreResultsProc;
begin
	Result := InternalLoadProc( sODBC_SQLMoreResultsProc, @FSQLMoreResultsProc );
end;

function TKODBCCore.GetSQLNativeSqlProc: TSQLNativeSqlProc;
begin
	Result := InternalLoadProc( sODBC_SQLNativeSqlProc, @FSQLNativeSqlProc );
end;

function TKODBCCore.GetSQLNumParamsProc: TSQLNumParamsProc;
begin
	Result := InternalLoadProc( sODBC_SQLNumParamsProc, @FSQLNumParamsProc );
end;

function TKODBCCore.GetSQLParamOptionsProc: TSQLParamOptionsProc;
begin
	Result := InternalLoadProc( sODBC_SQLParamOptionsProc, @FSQLParamOptionsProc );
end;

function TKODBCCore.GetSQLPrimaryKeysProc: TSQLPrimaryKeysProc;
begin
	Result := InternalLoadProc( sODBC_SQLPrimaryKeysProc, @FSQLPrimaryKeysProc );
end;

function TKODBCCore.GetSQLProcedureColumnsProc: TSQLProcedureColumnsProc;
begin
	Result := InternalLoadProc( sODBC_SQLProcedureColumnsProc, @FSQLProcedureColumnsProc );
end;

function TKODBCCore.GetSQLProceduresProc: TSQLProceduresProc;
begin
	Result := InternalLoadProc( sODBC_SQLProceduresProc, @FSQLProceduresProc );
end;

function TKODBCCore.GetSQLSetPosProc: TSQLSetPosProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetPosProc, @FSQLSetPosProc );
end;

function TKODBCCore.GetSQLTablePrivilegesProc: TSQLTablePrivilegesProc;
begin
	Result := InternalLoadProc( sODBC_SQLTablePrivilegesProc, @FSQLTablePrivilegesProc );
end;

function TKODBCCore.GetSQLDriversProc: TSQLDriversProc;
begin
	Result := InternalLoadProc( sODBC_SQLDriversProc, @FSQLDriversProc );
end;

function TKODBCCore.GetSQLBindParameterProc: TSQLBindParameterProc;
begin
	Result := InternalLoadProc( sODBC_SQLBindParameterProc, @FSQLBindParameterProc );
end;

function TKODBCCore.GetSQLAllocHandleStdProc: TSQLAllocHandleStdProc;
begin
	Result := InternalLoadProc( sODBC_SQLAllocHandleStdProc, @FSQLAllocHandleStdProc );
end;

function TKODBCCore.GetSQLSetScrollOptionsProc: TSQLSetScrollOptionsProc;
begin
	Result := InternalLoadProc( sODBC_SQLSetScrollOptionsProc, @FSQLSetScrollOptionsProc );
end;

end.
