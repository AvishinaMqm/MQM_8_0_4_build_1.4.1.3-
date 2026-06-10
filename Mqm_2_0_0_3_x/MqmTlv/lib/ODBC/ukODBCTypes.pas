{
	Libraries to be mapped:

					ODBC Administrator: ODBCCP32.DLL (installer)
				 ODBC Driver Manager: ODBC32.DLL
					ODBC Cusor Library: ODBCCR32.DLL
	ODBC UNICODE Cusor Library: ODBCCU32.DLL


	Still not implemented:

	ODBCss.h   ( SQLServer extensions )
	SQLUCode.h ( Unicode ODBC core functions, types, and constants )

	Already implemented:

	SQL.h      ( ODBC core functions, types, and constants )
	SQLext.h   ( Microsoft SQL extensions to ODBC )
	SQLTypes.h ( Generic ODBC types )
	ODBCInst.h ( ODBC Installer prototypes, types and constants )

}

unit ukODBCTypes;

interface

uses Windows;

{$DEFINE ODBCVER300}

{$IFDEF ODBCVER300}
	{$DEFINE ODBCVER201}
	{$DEFINE ODBCVER250}
{$ENDIF} (* ODBCVER300 *)

{$IFDEF ODBCVER300}
const
	SQL_MAX_NUMERIC_LEN = 16;
{$ENDIF} (* ODBCVER300 *)

{
--------------------------------------------------------------------------
---------- ODBC API Type Definitions  ( SQLTypes.h ) ---------------------
--------------------------------------------------------------------------
}

{
	API declaration data types:
	---------------------------
}

type

	SQLCHAR = type UCHAR;         { typedef unsigned char SQLCHAR;       }

{$IFDEF ODBCVER300}
	SQLSCHAR = type CHAR;         { typedef signed char SQLSCHAR;        }
	SQLDATE = type UCHAR;         { typedef unsigned char SQLDATE;       }
	SQLDECIMAL = type UCHAR;		  { typedef unsigned char SQLDECIMAL;    }
	SQLDOUBLE = type Double;		  { typedef double SQLDOUBLE;            }
	SQLFLOAT = type Double;			  { typedef double SQLFLOAT;             }
	SQLNUMERIC = type UCHAR;      { typedef unsigned char SQLNUMERIC;    }
	SQLREAL = type Single;	      { typedef float SQLREAL;               }
	SQLTIME = type UCHAR;					{ typedef unsigned char SQLTIME;       }
	SQLTIMESTAMP = type UCHAR;    { typedef unsigned char SQLTIMESTAMP;  }
	SQLVARCHAR = type UCHAR;			{ typedef unsigned char SQLVARCHAR;    }
{$ENDIF} (* ODBCVER300 *)

	SQLINTEGER = type LongInt;    { typedef long SQLINTEGER;             }
	SQLUINTEGER = type LongInt;   { typedef unsigned long SQLUINTEGER;   }
	SQLPOINTER = type Pointer;	  { typedef void* SQLPOINTER;            }
	SQLSMALLINT = type SmallInt;  { typedef short SQLSMALLINT;           }
	SQLUSMALLINT = type SmallInt; { typedef unsigned short SQLUSMALLINT; }

{
	Function Return Types:
	----------------------
}

	SQLRETURN = type SQLSMALLINT; { typedef SQLSMALLINT SQLRETURN;       }

{
	Generic Data Structures:
	------------------------
}

{$IFDEF ODBCVER300}
	{$IFDEF WIN32}
		SQLHANDLE = type Pointer;	    { typedef void* SQLHANDLE;           }
	{$ELSE}
		SQLHANDLE = type SQLINTEGER;  { typedef SQLINTEGER SQLHANDLE;      }
	{$ENDIF} (* WIN32 *)
	SQLHENV = type SQLHANDLE; 		  { typedef SQLHANDLE SQLHENV;         }
	SQLHDBC = type SQLHANDLE;       { typedef SQLHANDLE SQLHDBC;         }
	SQLHSTMT = type SQLHANDLE;      { typedef SQLHANDLE SQLHSTMT;        }
	SQLHDESC = type SQLHANDLE;      { typedef SQLHANDLE SQLHDESC;        }
{$ELSE}
	{$IFDEF WIN32}
		SQLHENV = type Pointer; 		  { typedef void* SQLHENV;             }
		SQLHDBC = type Pointer;       { typedef void* SQLHDBC;             }
		SQLHSTMT = type Pointer;      { typedef void* SQLHSTMT;            }
	{$ELSE}
		SQLHENV = type SQLINTEGER; 		{ typedef SQLINTEGER SQLHENV;        }
		SQLHDBC = type SQLINTEGER;    { typedef SQLINTEGER SQLHDBC;        }
		SQLHSTMT = type SQLINTEGER;   { typedef SQLINTEGER SQLHSTMT;       }
	{$ENDIF} (* WIN32 *)
{$ENDIF} (* ODBCVER300 *)

{
	SQL portable types for C:
	-------------------------
}

	SCHAR = type CHAR;        { typedef signed char          SCHAR; }
	SDWORD = type LongInt;    { typedef long int             SDWORD; }
	SWORD = type SHORT;       { typedef short int            SWORD; }
	UDWORD = type ULONG;      { typedef unsigned long int    UDWORD; }
	UWORD = type SHORT;       { typedef unsigned short int   UWORD; }

	SLONG = type LongInt;   { typedef signed long             SLONG; }
	SSHORT = type SHORT;    { typedef signed short            SSHORT; }
	USHORT = type SHORT;    { typedef unsigned short          USHORT; }
	SDOUBLE = type Double;  { typedef double                  SDOUBLE; }
	LDOUBLE = type Double;  { typedef double            		LDOUBLE; }
	SFLOAT = type Single;   { typedef float                   SFLOAT; }

	PTR = type Pointer;   { typedef void*              PTR; }
	HENV = type Pointer;  { typedef void*              HENV;  }
	HDBC = type Pointer;  { typedef void*              HDBC;  }
	HSTMT = type Pointer; { typedef void*              HSTMT; }

	RETCODE = type SHORT; { typedef signed short       RETCODE; }

{$IFDEF WIN32}
	SQLHWND = type HWND; { typedef HWND SQLHWND; }
{$ENDIF} (* WIN32 *)

	DATE_STRUCT = record
		year: SQLSMALLINT;
		month: SQLSMALLINT;
		day: SQLSMALLINT;
	end;

{$IFDEF ODBCVER300}
	SQL_DATE_STRUCT = type DATE_STRUCT; { typedef DATE_STRUCT	SQL_DATE_STRUCT; }
{$ENDIF} (* ODBCVER300 *)

	TIME_STRUCT = record
		hour: SQLSMALLINT;
		minute: SQLSMALLINT;
		second: SQLSMALLINT;
	end;

{$IFDEF ODBCVER300}
	SQL_TIME_STRUCT = type TIME_STRUCT; { typedef TIME_STRUCT	SQL_TIME_STRUCT; }
{$ENDIF} (* ODBCVER300 *)

	TIMESTAMP_STRUCT = record
		year: SQLSMALLINT;
		month: SQLSMALLINT;
		day: SQLSMALLINT;
		hour: SQLSMALLINT;
		minute: SQLSMALLINT;
		second: SQLSMALLINT;
		fraction: SQLSMALLINT;
	end;

{$IFDEF ODBCVER300}
	SQL_TIMESTAMP_STRUCT = type TIMESTAMP_STRUCT; { typedef TIMESTAMP_STRUCT	SQL_TIMESTAMP_STRUCT; }
{$ENDIF} (* ODBCVER300 *)

{
 enumerations for DATETIME_INTERVAL_SUBCODE values for interval data
 types; these values are from SQL-92
}

{$IFDEF ODBCVER300}
	SQLINTERVAL =
	(
	SQL_UNKNOWN,
	SQL_IS_YEAR,
	SQL_IS_MONTH,
	SQL_IS_DAY,
	SQL_IS_HOUR,
	SQL_IS_MINUTE,
	SQL_IS_SECOND,
	SQL_IS_YEAR_TO_MONTH,
	SQL_IS_DAY_TO_HOUR,
	SQL_IS_DAY_TO_MINUTE,
	SQL_IS_DAY_TO_SECOND,
	SQL_IS_HOUR_TO_MINUTE,
	SQL_IS_HOUR_TO_SECOND,
	SQL_IS_MINUTE_TO_SECOND
	);

	SQL_YEAR_MONTH_STRUCT = record
		year: SQLUINTEGER;
		month: SQLUINTEGER;
	end;

	SQL_DAY_SECOND_STRUCT = record
		day: SQLUINTEGER;
		hour: SQLUINTEGER;
		minute: SQLUINTEGER;
		second: SQLUINTEGER;
		fraction: SQLUINTEGER;
	end;

	SQL_INTERVAL_STRUCT = record
		interval_type: SQLINTERVAL;
		interval_sign: SQLSMALLINT;
		case Integer of
			0: ( year_month: SQL_YEAR_MONTH_STRUCT );
			1: ( day_second: SQL_DAY_SECOND_STRUCT );
	end;
{$ENDIF}

{$IFDEF VER120}
	ODBCINT64 = type Int64;
{$ELSE}
	ODBCINT64 = type Comp;
{$ENDIF} (* VER120 *)

	SQLBIGINT = type ODBCINT64; { typedef ODBCINT64	SQLBIGINT; }
	SQLUBIGINT = type ODBCINT64; { typedef unsigned ODBCINT64	SQLUBIGINT; }

	SQL_NUMERIC_STRUCT = record
		precision: SQLCHAR;
		scale: SQLCHAR;
		sign: SQLCHAR;
		val: array[0..SQL_MAX_NUMERIC_LEN-1] of SQLCHAR;
	end;

	BOOKMARK = type LongInt; { typedef unsigned long int BOOKMARK; }

//	SQLWCHAR = type          { typedef wchar_t SQLWCHAR; }

{$IFDEF UNICODE}
//	SQLTCHAR = type SQLWCHAR; { typedef SQLWCHAR SQLTCHAR; }
{$ELSE}
	SQLTCHAR = type SQLCHAR; { typedef SQLCHAR SQLTCHAR; }
{$ENDIF} (* UNICODE *)

{
	Some extra types declared by KnowHow:
	-------------------------------------
}

	PUWORD = ^UWORD;     { typedef unsigned short int   UWORD; }

{
--------------------------------------------------------------------------
-------- ODBC Core API Type Definitions ( SQL.h ) ------------------------
--------------------------------------------------------------------------
}

{$DEFINE __SQL}

const
{ special length/indicator values }
	SQL_NULL_DATA = -1;
	SQL_DATA_AT_EXEC = -2;

{ return values from functions }
	SQL_SUCCESS = 0;
	SQL_SUCCESS_WITH_INFO = 1;

{$IFDEF ODBCVER300}
	SQL_NO_DATA = 100;
{$ENDIF} (* ODBCVER300 *)

	SQL_ERROR = -1;
	SQL_INVALID_HANDLE = -2;
	SQL_STILL_EXECUTING = 2;
	SQL_NEED_DATA = 99;

(*
{ test for SQL_SUCCESS or SQL_SUCCESS_WITH_INFO }
#define SQL_SUCCEEDED(rc) (((rc)&(~1))==0)
*)

{ flags for null-terminated string }
	SQL_NTS = -3;
	SQL_NTSL: LongInt = -3;

{ maximum message length }
	SQL_MAX_MESSAGE_LENGTH = 512;

{$IFDEF ODBCVER300}

{ date/time length constants }
	SQL_DATE_LEN = 10;
	SQL_TIME_LEN = 8;        { add P+1 if precision is nonzero }
	SQL_TIMESTAMP_LEN = 19;  { add P+1 if precision is nonzero }

{ handle type identifiers }
	SQL_HANDLE_ENV = 1;
	SQL_HANDLE_DBC = 2;
	SQL_HANDLE_STMT = 3;
	SQL_HANDLE_DESC = 4;

{ environment attribute }
	SQL_ATTR_OUTPUT_NTS = 10001;

{ connection attributes }
	SQL_ATTR_AUTO_IPD = 10001;
	SQL_ATTR_METADATA_ID = 10014;

{ statement attributes }
	SQL_ATTR_APP_ROW_DESC = 10010;
	SQL_ATTR_APP_PARAM_DESC = 10011;
	SQL_ATTR_IMP_ROW_DESC = 10012;
	SQL_ATTR_IMP_PARAM_DESC = 10013;
	SQL_ATTR_CURSOR_SCROLLABLE = -1;
	SQL_ATTR_CURSOR_SENSITIVITY = -2;

{ SQL_ATTR_CURSOR_SCROLLABLE values }
	SQL_NONSCROLLABLE	= 0;
	SQL_SCROLLABLE = 1;

{ identifiers of fields in the SQL descriptor }
	SQL_DESC_COUNT = 1001;
	SQL_DESC_TYPE = 1002;
	SQL_DESC_LENGTH = 1003;
	SQL_DESC_OCTET_LENGTH_PTR = 1004;
	SQL_DESC_PRECISION = 1005;
	SQL_DESC_SCALE = 1006;
	SQL_DESC_DATETIME_INTERVAL_CODE = 1007;
	SQL_DESC_NULLABLE = 1008;
	SQL_DESC_INDICATOR_PTR = 1009;
	SQL_DESC_DATA_PTR = 1010;
	SQL_DESC_NAME = 1011;
	SQL_DESC_UNNAMED = 1012;
	SQL_DESC_OCTET_LENGTH = 1013;
	SQL_DESC_ALLOC_TYPE = 1099;

{ identifiers of fields in the diagnostics area }
	SQL_DIAG_RETURNCODE = 1;
	SQL_DIAG_NUMBER = 2;
	SQL_DIAG_ROW_COUNT = 3;
	SQL_DIAG_SQLSTATE = 4;
	SQL_DIAG_NATIVE = 5;
	SQL_DIAG_MESSAGE_TEXT = 6;
	SQL_DIAG_DYNAMIC_FUNCTION = 7;
	SQL_DIAG_CLASS_ORIGIN = 8;
	SQL_DIAG_SUBCLASS_ORIGIN = 9;
	SQL_DIAG_CONNECTION_NAME = 10;
	SQL_DIAG_SERVER_NAME = 11;
	SQL_DIAG_DYNAMIC_FUNCTION_CODE = 12;

{ dynamic function codes }
	SQL_DIAG_ALTER_TABLE = 4;
	SQL_DIAG_CREATE_INDEX = -1;
	SQL_DIAG_CREATE_TABLE = 77;
	SQL_DIAG_CREATE_VIEW = 84;
	SQL_DIAG_DELETE_WHERE = 19;
	SQL_DIAG_DROP_INDEX = -2;
	SQL_DIAG_DROP_TABLE = 32;
	SQL_DIAG_DROP_VIEW = 36;
	SQL_DIAG_DYNAMIC_DELETE_CURSOR = 38;
	SQL_DIAG_DYNAMIC_UPDATE_CURSOR = 81;
	SQL_DIAG_GRANT = 48;
	SQL_DIAG_INSERT = 50;
	SQL_DIAG_REVOKE = 59;
	SQL_DIAG_SELECT_CURSOR = 85;
	SQL_DIAG_UNKNOWN_STATEMENT = 0;
	SQL_DIAG_UPDATE_WHERE = 82;

{$ENDIF} (* ODBCVER300 *)

{ SQL data type codes }
	SQL_UNKNOWN_TYPE = 0;
	SQL_CHAR = 1;
	SQL_NUMERIC = 2;
	SQL_DECIMAL = 3;
	SQL_INTEGER = 4;
	SQL_SMALLINT = 5;
	SQL_FLOAT = 6;
	SQL_REAL = 7;
	SQL_DOUBLE = 8;
{$IFDEF ODBCVER300}
	SQL_DATETIME = 9;
{$ENDIF} (* ODBCVER300 *)
	SQL_VARCHAR = 12;

{$IFDEF ODBCVER300}

{ One-parameter shortcuts for date/time data types }
	SQL_TYPE_DATE = 91;
	SQL_TYPE_TIME = 92;
	SQL_TYPE_TIMESTAMP = 93;

{ Statement attribute values for cursor sensitivity }
	SQL_UNSPECIFIED = 0;
	SQL_INSENSITIVE = 1;
	SQL_SENSITIVE = 2;

{$ENDIF} (* ODBCVER300 *)

{ GetTypeInfo() request for all data types }
	SQL_ALL_TYPES = 0;

{$IFDEF ODBCVER300}
{ Default conversion code for SQLBindCol(), SQLBindParam() and SQLGetData() }
	SQL_DEFAULT = 99;

{ SQLGetData() code indicating that the application row descriptor
	* specifies the data type }
	SQL_ARD_TYPE = -99;

{ SQL date/time type subcodes }
	SQL_CODE_DATE = 1;
	SQL_CODE_TIME = 2;
	SQL_CODE_TIMESTAMP = 3;

{ CLI option values }
	SQL_FALSE = 0;
	SQL_TRUE  = 1;

{$ENDIF} (* ODBCVER300 *)

{ values of NULLABLE field in descriptor }
	SQL_NO_NULLS = 0;
	SQL_NULLABLE = 1;

{ Value returned by SQLGetTypeInfo() to denote that it is
	* not known whether or not a data type supports null values. }
	SQL_NULLABLE_UNKNOWN = 2;

{$IFDEF ODBCVER300}

{ Values returned by SQLGetTypeInfo() to show WHERE clause
	* supported }
	SQL_PRED_NONE = 0;
	SQL_PRED_CHAR = 1;
	SQL_PRED_BASIC = 2;

{ values of UNNAMED field in descriptor }
	SQL_NAMED = 0;
	SQL_UNNAMED = 1;

{ values of ALLOC_TYPE field in descriptor }
	SQL_DESC_ALLOC_AUTO = 1;
	SQL_DESC_ALLOC_USER = 2;

{$ENDIF} (* ODBCVER300 *)

{ FreeStmt() options }
	SQL_CLOSE = 0;
	SQL_DROP = 1;
	SQL_UNBIND = 2;
	SQL_RESET_PARAMS = 3;

{ Codes used for FetchOrientation in SQLFetchScroll(),
	and in SQLDataSources() }
	SQL_FETCH_NEXT = 1;
	SQL_FETCH_FIRST = 2;

{ SQLEndTran() options }
	SQL_COMMIT = 0;
	SQL_ROLLBACK = 1;

{ NULL handles returned by SQLAllocHandle() }
	SQL_NULL_HENV = 0;
	SQL_NULL_HDBC = 0;
	SQL_NULL_HSTMT = 0;

{$IFDEF ODBCVER300}
	SQL_NULL_HDESC = 0;

{ NULL handle used in place of parent handle when allocating HENV }
	SQL_NULL_HANDLE: LongInt = 0;

{$ENDIF} (* ODBCVER300 *)

{ Values that may appear in the result set of SQLSpecialColumns() }
	SQL_SCOPE_CURROW = 0;
	SQL_SCOPE_TRANSACTION = 1;
	SQL_SCOPE_SESSION = 2;

	SQL_PC_UNKNOWN = 0;

{$IFDEF ODBCVER300}

	SQL_PC_NON_PSEUDO = 1;
	SQL_PC_PSEUDO = 2;

{ Reserved value for the IdentifierType argument of SQLSpecialColumns() }
	SQL_ROW_IDENTIFIER = 1;

{$ENDIF} (* ODBCVER300 *)

{ Reserved values for UNIQUE argument of SQLStatistics() }
	SQL_INDEX_UNIQUE = 0;
	SQL_INDEX_ALL = 1;

{ Values that may appear in the result set of SQLStatistics() }
	SQL_INDEX_CLUSTERED = 1;
	SQL_INDEX_HASHED = 2;
	SQL_INDEX_OTHER = 3;

{ SQLGetFunctions() values to identify ODBC APIs }
	SQL_API_SQLALLOCCONNECT = 1;
	SQL_API_SQLALLOCENV = 2;
	SQL_API_SQLALLOCSTMT = 3;
	SQL_API_SQLBINDCOL = 4;

{$IFDEF ODBCVER300}

	SQL_API_SQLALLOCHANDLE = 1001;
	SQL_API_SQLBINDPARAM = 1002;
	SQL_API_SQLCLOSECURSOR = 1003;
	SQL_API_SQLCOLATTRIBUTE = 6;
	SQL_API_SQLCOPYDESC = 1004;
	SQL_API_SQLENDTRAN = 1005;
	SQL_API_SQLFETCHSCROLL = 1021;
	SQL_API_SQLFREEHANDLE = 1006;
	SQL_API_SQLGETCONNECTATTR = 1007;
	SQL_API_SQLGETDESCFIELD = 1008;
	SQL_API_SQLGETDESCREC = 1009;
	SQL_API_SQLGETDIAGFIELD = 1010;
	SQL_API_SQLGETDIAGREC = 1011;
	SQL_API_SQLGETENVATTR = 1012;
	SQL_API_SQLGETSTMTATTR = 1014;
	SQL_API_SQLSETCONNECTATTR = 1016;
	SQL_API_SQLSETDESCFIELD = 1017;
	SQL_API_SQLSETDESCREC = 1018;
	SQL_API_SQLSETENVATTR = 1019;
	SQL_API_SQLSETSTMTATTR = 1020;

{$ENDIF} (* ODBCVER300 *)

	SQL_API_SQLCANCEL = 5;
	SQL_API_SQLCOLUMNS = 40;
	SQL_API_SQLCONNECT = 7;
	SQL_API_SQLDATASOURCES = 57;
	SQL_API_SQLDESCRIBECOL = 8;
	SQL_API_SQLDISCONNECT = 9;
	SQL_API_SQLERROR = 10;
	SQL_API_SQLEXECDIRECT = 11;
	SQL_API_SQLEXECUTE = 12;
	SQL_API_SQLFETCH = 13;
	SQL_API_SQLFREECONNECT = 14;
	SQL_API_SQLFREEENV = 15;
	SQL_API_SQLFREESTMT = 16;
	SQL_API_SQLGETCONNECTOPTION = 42;
	SQL_API_SQLGETCURSORNAME = 17;
	SQL_API_SQLGETDATA = 43;
	SQL_API_SQLGETFUNCTIONS = 44;
	SQL_API_SQLGETINFO = 45;
	SQL_API_SQLGETSTMTOPTION = 46;
	SQL_API_SQLGETTYPEINFO = 47;
	SQL_API_SQLNUMRESULTCOLS = 18;
	SQL_API_SQLPARAMDATA = 48;
	SQL_API_SQLPREPARE = 19;
	SQL_API_SQLPUTDATA = 49;
	SQL_API_SQLROWCOUNT = 20;
	SQL_API_SQLSETCONNECTOPTION = 50;
	SQL_API_SQLSETCURSORNAME = 21;
	SQL_API_SQLSETPARAM = 22;
	SQL_API_SQLSETSTMTOPTION = 51;
	SQL_API_SQLSPECIALCOLUMNS = 52;
	SQL_API_SQLSTATISTICS = 53;
	SQL_API_SQLTABLES = 54;
	SQL_API_SQLTRANSACT = 23;

{ Information requested by SQLGetInfo() }

{$IFDEF ODBCVER300}

	SQL_MAX_DRIVER_CONNECTIONS = 0;
	SQL_MAXIMUM_DRIVER_CONNECTIONS = SQL_MAX_DRIVER_CONNECTIONS;
	SQL_MAX_CONCURRENT_ACTIVITIES = 1;
	SQL_MAXIMUM_CONCURRENT_ACTIVITIES	= SQL_MAX_CONCURRENT_ACTIVITIES;

{$ENDIF} (* ODBCVER300 *)

	SQL_DATA_SOURCE_NAME = 2;
	SQL_FETCH_DIRECTION = 8;
	SQL_SERVER_NAME = 13;
	SQL_SEARCH_PATTERN_ESCAPE = 14;
	SQL_DBMS_NAME = 17;
	SQL_DBMS_VER = 18;
	SQL_ACCESSIBLE_TABLES = 19;
	SQL_ACCESSIBLE_PROCEDURES = 20;
	SQL_CURSOR_COMMIT_BEHAVIOR = 23;
	SQL_DATA_SOURCE_READ_ONLY = 25;
	SQL_DEFAULT_TXN_ISOLATION = 26;
	SQL_IDENTIFIER_CASE = 28;
	SQL_IDENTIFIER_QUOTE_CHAR = 29;
	SQL_MAX_COLUMN_NAME_LEN = 30;
	SQL_MAXIMUM_COLUMN_NAME_LENGTH = SQL_MAX_COLUMN_NAME_LEN;
	SQL_MAX_CURSOR_NAME_LEN = 31;
	SQL_MAXIMUM_CURSOR_NAME_LENGTH = SQL_MAX_CURSOR_NAME_LEN;
	SQL_MAX_SCHEMA_NAME_LEN = 32;
	SQL_MAXIMUM_SCHEMA_NAME_LENGTH = SQL_MAX_SCHEMA_NAME_LEN;
	SQL_MAX_CATALOG_NAME_LEN = 34;
	SQL_MAXIMUM_CATALOG_NAME_LENGTH	= SQL_MAX_CATALOG_NAME_LEN;
	SQL_MAX_TABLE_NAME_LEN = 35;
	SQL_SCROLL_CONCURRENCY = 43;
	SQL_TXN_CAPABLE = 46;
	SQL_TRANSACTION_CAPABLE = SQL_TXN_CAPABLE;
	SQL_USER_NAME = 47;
	SQL_TXN_ISOLATION_OPTION = 72;
	SQL_TRANSACTION_ISOLATION_OPTION = SQL_TXN_ISOLATION_OPTION;
	SQL_INTEGRITY = 73;
	SQL_GETDATA_EXTENSIONS = 81;
	SQL_NULL_COLLATION = 85;
	SQL_ALTER_TABLE = 86;
	SQL_ORDER_BY_COLUMNS_IN_SELECT = 90;
	SQL_SPECIAL_CHARACTERS = 94;
	SQL_MAX_COLUMNS_IN_GROUP_BY = 97;
	SQL_MAXIMUM_COLUMNS_IN_GROUP_BY	= SQL_MAX_COLUMNS_IN_GROUP_BY;
	SQL_MAX_COLUMNS_IN_INDEX = 98;
	SQL_MAXIMUM_COLUMNS_IN_INDEX = SQL_MAX_COLUMNS_IN_INDEX;
	SQL_MAX_COLUMNS_IN_ORDER_BY = 99;
	SQL_MAXIMUM_COLUMNS_IN_ORDER_BY	= SQL_MAX_COLUMNS_IN_ORDER_BY;
	SQL_MAX_COLUMNS_IN_SELECT = 100;
	SQL_MAXIMUM_COLUMNS_IN_SELECT	= SQL_MAX_COLUMNS_IN_SELECT;
	SQL_MAX_COLUMNS_IN_TABLE = 101;
	SQL_MAX_INDEX_SIZE = 102;
	SQL_MAXIMUM_INDEX_SIZE = SQL_MAX_INDEX_SIZE;
	SQL_MAX_ROW_SIZE = 104;
	SQL_MAXIMUM_ROW_SIZE = SQL_MAX_ROW_SIZE;
	SQL_MAX_STATEMENT_LEN = 105;
	SQL_MAXIMUM_STATEMENT_LENGTH = SQL_MAX_STATEMENT_LEN;
	SQL_MAX_TABLES_IN_SELECT = 106;
	SQL_MAXIMUM_TABLES_IN_SELECT = SQL_MAX_TABLES_IN_SELECT;
	SQL_MAX_USER_NAME_LEN = 107;
	SQL_MAXIMUM_USER_NAME_LENGTH = SQL_MAX_USER_NAME_LEN;

{$IFDEF ODBCVER300}

	SQL_OJ_CAPABILITIES = 115;
	SQL_OUTER_JOIN_CAPABILITIES	= SQL_OJ_CAPABILITIES;
	SQL_XOPEN_CLI_YEAR = 10000;
	SQL_CURSOR_SENSITIVITY = 10001;
	SQL_DESCRIBE_PARAMETER = 10002;
	SQL_CATALOG_NAME = 10003;
	SQL_COLLATION_SEQ = 10004;
	SQL_MAX_IDENTIFIER_LEN = 10005;
	SQL_MAXIMUM_IDENTIFIER_LENGTH = SQL_MAX_IDENTIFIER_LEN;

{ SQL_ALTER_TABLE bitmasks }

	SQL_AT_ADD_COLUMN: LongInt     = $00000001;
	SQL_AT_DROP_COLUMN: LongInt    = $00000002;
	SQL_AT_ADD_CONSTRAINT: LongInt = $00000008;

{ The following bitmasks are ODBC extensions and defined in sqlext.h }

(*
	SQL_AT_COLUMN_SINGLE					0x00000020L
	SQL_AT_ADD_COLUMN_DEFAULT				0x00000040L
	SQL_AT_ADD_COLUMN_COLLATION				0x00000080L
	SQL_AT_SET_COLUMN_DEFAULT				0x00000100L
	SQL_AT_DROP_COLUMN_DEFAULT				0x00000200L
	SQL_AT_DROP_COLUMN_CASCADE				0x00000400L
	SQL_AT_DROP_COLUMN_RESTRICT				0x00000800L
	SQL_AT_ADD_TABLE_CONSTRAINT				0x00001000L
	SQL_AT_DROP_TABLE_CONSTRAINT_CASCADE		0x00002000L
	SQL_AT_DROP_TABLE_CONSTRAINT_RESTRICT		0x00004000L
	SQL_AT_CONSTRAINT_NAME_DEFINITION			0x00008000L
	SQL_AT_CONSTRAINT_INITIALLY_DEFERRED		0x00010000L
	SQL_AT_CONSTRAINT_INITIALLY_IMMEDIATE		0x00020000L
	SQL_AT_CONSTRAINT_DEFERRABLE				0x00040000L
	SQL_AT_CONSTRAINT_NON_DEFERRABLE			0x00080000L

{ SQL_ASYNC_MODE values }
	SQL_AM_NONE = 0;
	SQL_AM_CONNECTION = 1;
	SQL_AM_STATEMENT = 2;
*)

{$ENDIF} (* ODBCVER300 *)

{ SQL_CURSOR_COMMIT_BEHAVIOR values }
	SQL_CB_DELETE                     =  0;
	SQL_CB_CLOSE                      =  1;
	SQL_CB_PRESERVE                   =  2;

{ SQL_GETDATA_EXTENSIONS bitmasks }
	SQL_GD_ANY_COLUMN        : LongInt = $00000001;
	SQL_GD_ANY_ORDER         : LongInt = $00000002;

{ SQL_IDENTIFIER_CASE values }
	SQL_IC_UPPER                      =  1;
	SQL_IC_LOWER                      =  2;
	SQL_IC_SENSITIVE                  =  3;
	SQL_IC_MIXED                      =  4;

{ SQL_OJ_CAPABILITIES bitmasks }
{ NB: this means 'outer join', not what  you may be thinking }

{$IFDEF ODBCVER201}
	SQL_OJ_LEFT               : LongInt = $00000001;
	SQL_OJ_RIGHT              : LongInt = $00000002;
	SQL_OJ_FULL               : LongInt = $00000004;
	SQL_OJ_NESTED             : LongInt = $00000008;
	SQL_OJ_NOT_ORDERED        : LongInt = $00000010;
	SQL_OJ_INNER              : LongInt = $00000020;
	SQL_OJ_ALL_COMPARISON_OPS : LongInt = $00000040;
{$ENDIF} (* ODBCVER201 *)

{ SQL_TXN_CAPABLE values }
	SQL_TC_NONE                       =  0;
	SQL_TC_DML                        =  1;
	SQL_TC_ALL                        =  2;
	SQL_TC_DDL_COMMIT                 =  3;
	SQL_TC_DDL_IGNORE                 =  4;

{ SQL_TXN_ISOLATION_OPTION bitmasks }
	SQL_TXN_READ_UNCOMMITTED : LongInt = $00000001;
	SQL_TRANSACTION_READ_UNCOMMITTED : LongInt = $00000001;
	SQL_TXN_READ_COMMITTED : LongInt = $00000002;
	SQL_TRANSACTION_READ_COMMITTED : LongInt = $00000002;
	SQL_TXN_REPEATABLE_READ : LongInt = $00000004;
	SQL_TRANSACTION_REPEATABLE_READ	: LongInt = $00000004;
	SQL_TXN_SERIALIZABLE : LongInt = $00000008;
	SQL_TRANSACTION_SERIALIZABLE : LongInt = $00000008;

{ SQL_NULL_COLLATION values }
	SQL_NC_HIGH = 0;
	SQL_NC_LOW = 1;

{
--------------------------------------------------------------------------
----- ODBC Core API Extensions Type Definitions ( SQLExt.h ) -------------
--------------------------------------------------------------------------
}

{$IFNDEF __SQLEXT}
	{$DEFINE __SQLEXT}
{$ENDIF}

	SQL_SPEC_MAJOR    = 3;     	  (* Major version of specification  *)
	SQL_SPEC_MINOR	  = 00;     	(* Minor version of specification  *)
	SQL_SPEC_STRING   = '03.00';	(* String constant for version *)

	SQL_SQLSTATE_SIZE	  = 5;	  (* size of SQLSTATE *)
	SQL_MAX_DSN_LENGTH	= 32;	  (* maximum data source name size *)

	SQL_MAX_OPTION_STRING_LENGTH =  256;

(* return code SQL_NO_DATA_FOUND is the same as SQL_NO_DATA *)
	SQL_NO_DATA_FOUND	= 100;

(* connection attributes *)
	SQL_ACCESS_MODE                 = 101;
	SQL_AUTOCOMMIT                  = 102;
	SQL_LOGIN_TIMEOUT               = 103;
	SQL_OPT_TRACE                   = 104;
	SQL_OPT_TRACEFILE               = 105;
	SQL_TRANSLATE_DLL               = 106;
	SQL_TRANSLATE_OPTION            = 107;
	SQL_TXN_ISOLATION               = 108;
	SQL_CURRENT_QUALIFIER           = 109;
	SQL_ODBC_CURSORS                = 110;
	SQL_QUIET_MODE                  = 111;
	SQL_PACKET_SIZE                 = 112;

{$IFDEF ODBCVER300}

(* an end handle type *)
	SQL_HANDLE_SENV	=	5;

(* env attribute *)
	SQL_ATTR_ODBC_VERSION				  = 200;
	SQL_ATTR_CONNECTION_POOLING		= 201;
	SQL_ATTR_CP_MATCH					    = 202;

	SQL_CP_OFF: ULONG = 0;
	SQL_CP_ONE_PER_DRIVER: ULONG = 1;
	SQL_CP_ONE_PER_HENV: ULONG = 2;
	SQL_CP_DEFAULT: ULONG = 0;

(* values for SQL_ATTR_CP_MATCH *)
	SQL_CP_STRICT_MATCH: ULONG  = 0;
	SQL_CP_RELAXED_MATCH: ULONG = 1;
	SQL_CP_MATCH_DEFAULT: ULONG = 0;

(* values for SQL_ATTR_ODBC_VERSION *)
	SQL_OV_ODBC2: ULONG = 2;
	SQL_OV_ODBC3: ULONG = 3;

(* connection attributes with new names *)
	SQL_ATTR_ACCESS_MODE					= SQL_ACCESS_MODE;
	SQL_ATTR_AUTOCOMMIT						= SQL_AUTOCOMMIT;
	SQL_ATTR_CONNECTION_TIMEOUT		= 113;
	SQL_ATTR_CURRENT_CATALOG			= SQL_CURRENT_QUALIFIER;
	SQL_ATTR_DISCONNECT_BEHAVIOR	= 114;
	SQL_ATTR_ENLIST_IN_DTC				= 1207;
	SQL_ATTR_ENLIST_IN_XA					= 1208;
	SQL_ATTR_LOGIN_TIMEOUT				= SQL_LOGIN_TIMEOUT;
	SQL_ATTR_ODBC_CURSORS					= SQL_ODBC_CURSORS;
	SQL_ATTR_PACKET_SIZE					= SQL_PACKET_SIZE;
	SQL_ATTR_QUIET_MODE						= SQL_QUIET_MODE;
	SQL_ATTR_TRACE								= SQL_OPT_TRACE;
	SQL_ATTR_TRACEFILE						= SQL_OPT_TRACEFILE;
	SQL_ATTR_TRANSLATE_LIB				= SQL_TRANSLATE_DLL;
	SQL_ATTR_TRANSLATE_OPTION			= SQL_TRANSLATE_OPTION;
	SQL_ATTR_TXN_ISOLATION				= SQL_TXN_ISOLATION;

(* SQL_CONNECT_OPT_DRVR_START is not meaningful for 3.0 driver *)
	SQL_CONNECT_OPT_DRVR_START    = 1000;

(* values for SQL_ATTR_DISCONNECT_BEHAVIOR *)
	SQL_DB_RETURN_TO_POOL: ULONG = 0;
	SQL_DB_DISCONNECT: ULONG = 1;
	SQL_DB_DEFAULT: ULONG = 0;

(* values for SQL_ATTR_ENLIST_IN_DTC *)
	SQL_DTC_DONE: ULONG = 0;

{$ENDIF} (* ODBCVER300 *)


{$IFNDEF ODBCVER300}

	SQL_CONN_OPT_MAX              =  SQL_PACKET_SIZE;
	SQL_CONN_OPT_MIN              =  SQL_ACCESS_MODE;

{$ENDIF} (* ODBCVER300 *)

(* SQL_ACCESS_MODE options *)
	SQL_MODE_READ_WRITE: ULONG = 0;
	SQL_MODE_READ_ONLY: ULONG = 1;
	SQL_MODE_DEFAULT: ULONG = 0;

(* SQL_AUTOCOMMIT options *)
	SQL_AUTOCOMMIT_OFF: ULONG = 0;
	SQL_AUTOCOMMIT_ON: ULONG = 1;
	SQL_AUTOCOMMIT_DEFAULT: ULONG = 0;

(* SQL_LOGIN_TIMEOUT options *)
	SQL_LOGIN_TIMEOUT_DEFAULT: ULONG = 15;

(* SQL_OPT_TRACE options *)
	SQL_OPT_TRACE_OFF: ULONG = 0;
	SQL_OPT_TRACE_ON: ULONG = 1;
	SQL_OPT_TRACE_DEFAULT: ULONG = 0;
	SQL_OPT_TRACE_FILE_DEFAULT = '\\SQL.LOG';

(* SQL_ODBC_CURSORS options *)
	SQL_CUR_USE_IF_NEEDED: ULONG = 0;
	SQL_CUR_USE_ODBC: ULONG = 1;
	SQL_CUR_USE_DRIVER: ULONG = 2;
  SQL_CUR_DEFAULT: ULONG = 2;

(* statement attributes *)
	SQL_QUERY_TIMEOUT		= 0;
	SQL_MAX_ROWS			  = 1;
	SQL_NOSCAN				  = 2;
	SQL_MAX_LENGTH			= 3;
	SQL_ASYNC_ENABLE		= 4;	(* same as SQL_ATTR_ASYNC_ENABLE *)
	SQL_BIND_TYPE			  = 5;
	SQL_CURSOR_TYPE			= 6;
	SQL_CONCURRENCY			= 7;
	SQL_KEYSET_SIZE			= 8;
	SQL_ROWSET_SIZE			= 9;
	SQL_SIMULATE_CURSOR	=	10;
	SQL_RETRIEVE_DATA		= 11;
	SQL_USE_BOOKMARKS		= 12;
	SQL_GET_BOOKMARK		= 13;      (*      GetStmtOption Only *)
	SQL_ROW_NUMBER			= 14;      (*      GetStmtOption Only *)

(* SQLColAttributes subdefines for SQL_COLUMN_SEARCHABLE *)
(* These are also used by SQLGetInfo                     *)
	SQL_UNSEARCHABLE         = 0;
	SQL_LIKE_ONLY            = 1;
	SQL_ALL_EXCEPT_LIKE      = 2;
	SQL_SEARCHABLE           = 3;
	SQL_PRED_SEARCHABLE			 = SQL_SEARCHABLE;

{$IFDEF ODBCVER300}

(* statement attributes for ODBC 3.0 *)
	SQL_ATTR_ASYNC_ENABLE				   = 4;
	SQL_ATTR_CONCURRENCY				   = SQL_CONCURRENCY;
	SQL_ATTR_CURSOR_TYPE				   = SQL_CURSOR_TYPE;
	SQL_ATTR_ENABLE_AUTO_IPD			 = 15;
	SQL_ATTR_FETCH_BOOKMARK_PTR		 = 16;
	SQL_ATTR_KEYSET_SIZE				   = SQL_KEYSET_SIZE;
	SQL_ATTR_MAX_LENGTH					   = SQL_MAX_LENGTH;
	SQL_ATTR_MAX_ROWS					     = SQL_MAX_ROWS;
	SQL_ATTR_NOSCAN						     = SQL_NOSCAN;
	SQL_ATTR_PARAM_BIND_OFFSET_PTR = 17;
	SQL_ATTR_PARAM_BIND_TYPE			 = 18;
	SQL_ATTR_PARAM_OPERATION_PTR	 = 19;
	SQL_ATTR_PARAM_STATUS_PTR			 = 20;
	SQL_ATTR_PARAMS_PROCESSED_PTR	 = 21;
	SQL_ATTR_PARAMSET_SIZE				 = 22;
	SQL_ATTR_QUERY_TIMEOUT				 = SQL_QUERY_TIMEOUT;
	SQL_ATTR_RETRIEVE_DATA				 = SQL_RETRIEVE_DATA;
	SQL_ATTR_ROW_BIND_OFFSET_PTR	 = 23;
	SQL_ATTR_ROW_BIND_TYPE				 = SQL_BIND_TYPE;
	SQL_ATTR_ROW_NUMBER					   = SQL_ROW_NUMBER;	  	(*GetStmtAttr*)
	SQL_ATTR_ROW_OPERATION_PTR		 = 24;
	SQL_ATTR_ROW_STATUS_PTR				 = 25;
	SQL_ATTR_ROWS_FETCHED_PTR			 = 26;
	SQL_ATTR_ROW_ARRAY_SIZE				 = 27;
	SQL_ATTR_SIMULATE_CURSOR			 = SQL_SIMULATE_CURSOR;
	SQL_ATTR_USE_BOOKMARKS				 = SQL_USE_BOOKMARKS;

(* New defines for SEARCHABLE column in SQLGetTypeInfo *)
	SQL_COL_PRED_CHAR		= SQL_LIKE_ONLY;
	SQL_COL_PRED_BASIC	=	SQL_ALL_EXCEPT_LIKE;

(* whether an attribute is a pointer or not *)
	SQL_IS_POINTER							= (-4);
	SQL_IS_UINTEGER							= (-5);
	SQL_IS_INTEGER							= (-6);
	SQL_IS_USMALLINT						= (-7);
	SQL_IS_SMALLINT							= (-8);

(* the value of SQL_ATTR_PARAM_BIND_TYPE *)
	SQL_PARAM_BIND_BY_COLUMN: ULONG	= 0;
	SQL_PARAM_BIND_TYPE_DEFAULT			= 0;

{$ENDIF} (* ODBCVER300 *)

{$IFNDEF ODBCVER300}

	SQL_STMT_OPT_MAX  = SQL_ROW_NUMBER;
	SQL_STMT_OPT_MIN	= SQL_QUERY_TIMEOUT;

{$ENDIF} (* ODBCVER300 *)

(* SQL_QUERY_TIMEOUT options *)
	SQL_QUERY_TIMEOUT_DEFAULT: ULONG = 0;

(* SQL_MAX_ROWS options *)
	SQL_MAX_ROWS_DEFAULT: ULONG = 0;

(* SQL_NOSCAN options *)
	SQL_NOSCAN_OFF: ULONG = 0;
	SQL_NOSCAN_ON: ULONG = 1;
	SQL_NOSCAN_DEFAULT: ULONG = 0;

(* SQL_MAX_LENGTH options *)
	SQL_MAX_LENGTH_DEFAULT: ULONG = 0;

(* values for SQL_ATTR_ASYNC_ENABLE *)
	SQL_ASYNC_ENABLE_OFF: ULONG = 0;
	SQL_ASYNC_ENABLE_ON: ULONG = 1;
	SQL_ASYNC_ENABLE_DEFAULT: ULONG = 0;

(* SQL_BIND_TYPE options *)
	SQL_BIND_BY_COLUMN: ULONG = 0;
	SQL_BIND_TYPE_DEFAULT: ULONG = 0;

(* SQL_CONCURRENCY options *)
	SQL_CONCUR_READ_ONLY            = 1;
	SQL_CONCUR_LOCK                 = 2;
	SQL_CONCUR_ROWVER               = 3;
	SQL_CONCUR_VALUES               = 4;
	SQL_CONCUR_DEFAULT              = SQL_CONCUR_READ_ONLY; (* Default value *)

(* SQL_CURSOR_TYPE options *)
	SQL_CURSOR_FORWARD_ONLY: ULONG = 0;
	SQL_CURSOR_KEYSET_DRIVEN: ULONG = 1;
	SQL_CURSOR_DYNAMIC: ULONG = 2;
	SQL_CURSOR_STATIC: ULONG = 3;
	SQL_CURSOR_TYPE_DEFAULT: ULONG = 0;

(* SQL_ROWSET_SIZE options *)
	SQL_ROWSET_SIZE_DEFAULT: ULONG = 1;

(* SQL_KEYSET_SIZE options *)
	SQL_KEYSET_SIZE_DEFAULT: ULONG = 0;

(* SQL_SIMULATE_CURSOR options *)
	SQL_SC_NON_UNIQUE: ULONG = 0;
	SQL_SC_TRY_UNIQUE: ULONG = 1;
	SQL_SC_UNIQUE: ULONG = 2;

(* SQL_RETRIEVE_DATA options *)
	SQL_RD_OFF: ULONG = 0;
	SQL_RD_ON: ULONG = 1;
	SQL_RD_DEFAULT: ULONG = 1;

(* SQL_USE_BOOKMARKS options *)
	SQL_UB_OFF: ULONG = 0;
	SQL_UB_ON: ULONG = 1;
	SQL_UB_DEFAULT: ULONG = 0;

(* SQLColAttributes defines *)
	SQL_COLUMN_COUNT                = 0;
	SQL_COLUMN_NAME                 = 1;
	SQL_COLUMN_TYPE                 = 2;
	SQL_COLUMN_LENGTH               = 3;
	SQL_COLUMN_PRECISION            = 4;
	SQL_COLUMN_SCALE                = 5;
	SQL_COLUMN_DISPLAY_SIZE         = 6;
	SQL_COLUMN_NULLABLE             = 7;
	SQL_COLUMN_UNSIGNED             = 8;
	SQL_COLUMN_MONEY                = 9;
	SQL_COLUMN_UPDATABLE            = 10;
	SQL_COLUMN_AUTO_INCREMENT       = 11;
	SQL_COLUMN_CASE_SENSITIVE       = 12;
	SQL_COLUMN_SEARCHABLE           = 13;
	SQL_COLUMN_TYPE_NAME            = 14;
	SQL_COLUMN_TABLE_NAME           = 15;
	SQL_COLUMN_OWNER_NAME           = 16;
	SQL_COLUMN_QUALIFIER_NAME       = 17;
	SQL_COLUMN_LABEL                = 18;
	SQL_COLATT_OPT_MAX              = SQL_COLUMN_LABEL;

{$IFDEF ODBCVER300}

(* New values for SQL_USE_BOOKMARKS attribute *)
	SQL_UB_FIXED: ULONG = 1;
	SQL_UB_VARIABLE: ULONG = 2;

(* extended descriptor field *)
	SQL_DESC_ARRAY_SIZE						       = 20;
	SQL_DESC_ARRAY_STATUS_PTR				     = 21;
	SQL_DESC_AUTO_UNIQUE_VALUE				   = SQL_COLUMN_AUTO_INCREMENT;
	SQL_DESC_BASE_COLUMN_NAME				     = 22;
	SQL_DESC_BASE_TABLE_NAME				     = 23;
	SQL_DESC_BIND_OFFSET_PTR				     = 24;
	SQL_DESC_BIND_TYPE						       = 25;
	SQL_DESC_CASE_SENSITIVE					     = SQL_COLUMN_CASE_SENSITIVE;
	SQL_DESC_CATALOG_NAME					       = SQL_COLUMN_QUALIFIER_NAME;
	SQL_DESC_CONCISE_TYPE					       = SQL_COLUMN_TYPE;
	SQL_DESC_DATETIME_INTERVAL_PRECISION = 26;
	SQL_DESC_DISPLAY_SIZE					       = SQL_COLUMN_DISPLAY_SIZE;
	SQL_DESC_FIXED_PREC_SCALE				     = SQL_COLUMN_MONEY;
	SQL_DESC_LABEL							         = SQL_COLUMN_LABEL;
	SQL_DESC_LITERAL_PREFIX					     = 27;
	SQL_DESC_LITERAL_SUFFIX					     = 28;
	SQL_DESC_LOCAL_TYPE_NAME				     = 29;
	SQL_DESC_MAXIMUM_SCALE					     = 30;
	SQL_DESC_MINIMUM_SCALE					     = 31;
	SQL_DESC_NUM_PREC_RADIX					     = 32;
	SQL_DESC_PARAMETER_TYPE					     = 33;
	SQL_DESC_ROWS_PROCESSED_PTR				   = 34;
	SQL_DESC_SCHEMA_NAME					       = SQL_COLUMN_OWNER_NAME;
	SQL_DESC_SEARCHABLE						       = SQL_COLUMN_SEARCHABLE;
	SQL_DESC_TYPE_NAME						       = SQL_COLUMN_TYPE_NAME;
	SQL_DESC_TABLE_NAME						       = SQL_COLUMN_TABLE_NAME;
	SQL_DESC_UNSIGNED						         = SQL_COLUMN_UNSIGNED;
	SQL_DESC_UPDATABLE						       = SQL_COLUMN_UPDATABLE;

(* defines for diagnostics fields *)
	SQL_DIAG_CURSOR_ROW_COUNT			 = (-1249);
	SQL_DIAG_ROW_NUMBER					   = (-1248);
	SQL_DIAG_COLUMN_NUMBER				 = (-1247);

(* dynamic function codes *)
	SQL_DIAG_CALL					  = 7;

	SQL_INTERVAL						=	10;

(* interval code *)
	SQL_CODE_YEAR				      = 1;
	SQL_CODE_MONTH			      = 2;
	SQL_CODE_DAY				      = 3;
	SQL_CODE_HOUR				      = 4;
	SQL_CODE_MINUTE			      = 5;
	SQL_CODE_SECOND			      = 6;
	SQL_CODE_YEAR_TO_MONTH	  =	7;
	SQL_CODE_DAY_TO_HOUR		  =	8;
	SQL_CODE_DAY_TO_MINUTE	  = 9;
	SQL_CODE_DAY_TO_SECOND	  =	10;
	SQL_CODE_HOUR_TO_MINUTE	  =	11;
	SQL_CODE_HOUR_TO_SECOND	  =	12;
	SQL_CODE_MINUTE_TO_SECOND	= 13;

	SQL_INTERVAL_YEAR					    = (100 + SQL_CODE_YEAR);
	SQL_INTERVAL_MONTH					  = (100 + SQL_CODE_MONTH);
	SQL_INTERVAL_DAY					    = (100 + SQL_CODE_DAY);
	SQL_INTERVAL_HOUR					    = (100 + SQL_CODE_HOUR);
	SQL_INTERVAL_MINUTE					  = (100 + SQL_CODE_MINUTE);
	SQL_INTERVAL_SECOND           = (100 + SQL_CODE_SECOND);
	SQL_INTERVAL_YEAR_TO_MONTH		= (100 + SQL_CODE_YEAR_TO_MONTH);
	SQL_INTERVAL_DAY_TO_HOUR			= (100 + SQL_CODE_DAY_TO_HOUR);
	SQL_INTERVAL_DAY_TO_MINUTE		= (100 + SQL_CODE_DAY_TO_MINUTE);
	SQL_INTERVAL_DAY_TO_SECOND		= (100 + SQL_CODE_DAY_TO_SECOND);
	SQL_INTERVAL_HOUR_TO_MINUTE		= (100 + SQL_CODE_HOUR_TO_MINUTE);
	SQL_INTERVAL_HOUR_TO_SECOND		= (100 + SQL_CODE_HOUR_TO_SECOND);
	SQL_INTERVAL_MINUTE_TO_SECOND	= (100 + SQL_CODE_MINUTE_TO_SECOND);

{$ENDIF} (* ODBCVER300 *)

(* SQL extended datatypes *)
	SQL_DATE                                = 9;
	SQL_TIME                                = 10;
	SQL_TIMESTAMP                           = 11;
	SQL_LONGVARCHAR                         = (-1);
	SQL_BINARY                              = (-2);
	SQL_VARBINARY                           = (-3);
	SQL_LONGVARBINARY                       = (-4);
	SQL_BIGINT                              = (-5);
	SQL_TINYINT                             = (-6);
	SQL_BIT                                 = (-7);

{$IFNDEF ODBCVER300}

	SQL_INTERVAL_YEAR                       = (-80);
	SQL_INTERVAL_MONTH                      = (-81);
	SQL_INTERVAL_YEAR_TO_MONTH              = (-82);
	SQL_INTERVAL_DAY                        = (-83);
	SQL_INTERVAL_HOUR                       = (-84);
	SQL_INTERVAL_MINUTE                     = (-85);
	SQL_INTERVAL_SECOND                     = (-86);
	SQL_INTERVAL_DAY_TO_HOUR                = (-87);
	SQL_INTERVAL_DAY_TO_MINUTE              = (-88);
	SQL_INTERVAL_DAY_TO_SECOND              = (-89);
	SQL_INTERVAL_HOUR_TO_MINUTE             = (-90);
	SQL_INTERVAL_HOUR_TO_SECOND             = (-91);
	SQL_INTERVAL_MINUTE_TO_SECOND           = (-92);

	SQL_TYPE_DRIVER_START                   = SQL_INTERVAL_YEAR;
	SQL_TYPE_DRIVER_END                     = SQL_UNICODE_LONGVARCHAR;

{$ENDIF} (* ODBCVER300 *)

	SQL_UNICODE                             = (-95);
	SQL_UNICODE_VARCHAR                     = (-96);
	SQL_UNICODE_LONGVARCHAR                 = (-97);
	SQL_UNICODE_CHAR                        = SQL_UNICODE;

(* C datatype to SQL datatype mapping      SQL types
																					 ------------------- *)
	SQL_C_CHAR   = SQL_CHAR;
	SQL_C_LONG   = SQL_INTEGER;
	SQL_C_SHORT  = SQL_SMALLINT;
	SQL_C_FLOAT  = SQL_REAL;
	SQL_C_DOUBLE = SQL_DOUBLE;

	SQL_SIGNED_OFFSET      = (-20);
	SQL_UNSIGNED_OFFSET    = (-22);

{$IFDEF ODBCVER300}

	SQL_C_NUMERIC										 = SQL_NUMERIC;
	SQL_C_TYPE_DATE									 = SQL_TYPE_DATE;
	SQL_C_TYPE_TIME									 = SQL_TYPE_TIME;
	SQL_C_TYPE_TIMESTAMP						 = SQL_TYPE_TIMESTAMP;
	SQL_C_INTERVAL_YEAR							 = SQL_INTERVAL_YEAR;
	SQL_C_INTERVAL_MONTH						 = SQL_INTERVAL_MONTH;
	SQL_C_INTERVAL_DAY							 = SQL_INTERVAL_DAY;
	SQL_C_INTERVAL_HOUR							 = SQL_INTERVAL_HOUR;
	SQL_C_INTERVAL_MINUTE						 = SQL_INTERVAL_MINUTE;
	SQL_C_INTERVAL_SECOND						 = SQL_INTERVAL_SECOND;
	SQL_C_INTERVAL_YEAR_TO_MONTH	   = SQL_INTERVAL_YEAR_TO_MONTH;
	SQL_C_INTERVAL_DAY_TO_HOUR		   = SQL_INTERVAL_DAY_TO_HOUR;
	SQL_C_INTERVAL_DAY_TO_MINUTE	   = SQL_INTERVAL_DAY_TO_MINUTE;
	SQL_C_INTERVAL_DAY_TO_SECOND	   = SQL_INTERVAL_DAY_TO_SECOND;
	SQL_C_INTERVAL_HOUR_TO_MINUTE	   = SQL_INTERVAL_HOUR_TO_MINUTE;
	SQL_C_INTERVAL_HOUR_TO_SECOND	   = SQL_INTERVAL_HOUR_TO_SECOND;
	SQL_C_INTERVAL_MINUTE_TO_SECOND	 = SQL_INTERVAL_MINUTE_TO_SECOND;
	SQL_C_SBIGINT	 = (SQL_BIGINT+SQL_SIGNED_OFFSET);
	SQL_C_UBIGINT	 = (SQL_BIGINT+SQL_UNSIGNED_OFFSET);

{$ENDIF} (* ODBCVER300 *)

	SQL_C_DEFAULT = 99;

(* C datatype to SQL datatype mapping *)
	SQL_C_DATE       = SQL_DATE;
	SQL_C_TIME       = SQL_TIME;
	SQL_C_TIMESTAMP  = SQL_TIMESTAMP;
	SQL_C_BINARY     = SQL_BINARY;
	SQL_C_BIT        = SQL_BIT;
	SQL_C_TINYINT    = SQL_TINYINT;
	SQL_C_SLONG      = (SQL_C_LONG+SQL_SIGNED_OFFSET);
	SQL_C_SSHORT     = (SQL_C_SHORT+SQL_SIGNED_OFFSET);
	SQL_C_STINYINT   = (SQL_TINYINT+SQL_SIGNED_OFFSET);
	SQL_C_ULONG      = (SQL_C_LONG+SQL_UNSIGNED_OFFSET);
	SQL_C_USHORT     = (SQL_C_SHORT+SQL_UNSIGNED_OFFSET);
	SQL_C_UTINYINT   = (SQL_TINYINT+SQL_UNSIGNED_OFFSET);
	SQL_C_BOOKMARK   = SQL_C_ULONG;

	SQL_TYPE_NULL    = 0;

{$IFNDEF ODBCVER300}

	SQL_TYPE_MIN     = SQL_BIT;
	SQL_TYPE_MAX     = SQL_VARCHAR;

{$ENDIF} (* ODBCVER300 *)

{$IFDEF ODBCVER300}

	SQL_C_VARBOOKMARK		= SQL_C_BINARY;

(* define for SQL_DIAG_ROW_NUMBER and SQL_DIAG_COLUMN_NUMBER *)
	SQL_NO_ROW_NUMBER						= (-1);
	SQL_NO_COLUMN_NUMBER				= (-1);
	SQL_ROW_NUMBER_UNKNOWN			=	(-2);
	SQL_COLUMN_NUMBER_UNKNOWN		=	(-2);

{$ENDIF} (* ODBCVER300 *)

(* SQLBindParameter extensions *)
	SQL_DEFAULT_PARAM            = (-5);
	SQL_IGNORE                   = (-6);

{$IFDEF ODBCVER300}

	SQL_COLUMN_IGNORE			= SQL_IGNORE;

{$ENDIF} (* ODBCVER300 *)

	SQL_LEN_DATA_AT_EXEC_OFFSET  = (-100);

{
	SQL_LEN_DATA_AT_EXEC(length) = (-(length)+SQL_LEN_DATA_AT_EXEC_OFFSET)
}

(* binary length for driver specific attributes *)
	SQL_LEN_BINARY_ATTR_OFFSET	 = (-100);

{
	SQL_LEN_BINARY_ATTR(length)	 (-(length)+SQL_LEN_BINARY_ATTR_OFFSET)
}

(* Defines for SQLBindParameter and SQLProcedureColumns (returned in the result set) *)
	SQL_PARAM_TYPE_UNKNOWN           = 0;
	SQL_PARAM_INPUT                  = 1;
	SQL_PARAM_INPUT_OUTPUT           = 2;
	SQL_RESULT_COL                   = 3;
	SQL_PARAM_OUTPUT                 = 4;
	SQL_RETURN_VALUE                 = 5;

(* Defines used by Driver Manager when mapping SQLSetParam to SQLBindParameter *)
	SQL_PARAM_TYPE_DEFAULT           = SQL_PARAM_INPUT_OUTPUT;
	SQL_SETPARAM_VALUE_MAX: LongInt  = (-1);

{$IFNDEF ODBCVER300}
	SQL_COLUMN_DRIVER_START         = 1000;
{$ENDIF} (* ODBCVER300 *)

	SQL_COLATT_OPT_MIN              = SQL_COLUMN_COUNT;

(* SQLColAttributes subdefines for SQL_COLUMN_UPDATABLE *)
	SQL_ATTR_READONLY               = 0;
	SQL_ATTR_WRITE                  = 1;
	SQL_ATTR_READWRITE_UNKNOWN      = 2;

(* Special return values for SQLGetData *)
	SQL_NO_TOTAL                    = (-4);

(********************************************)
(* SQLGetFunctions: additional values for   *)
(* fFunction to represent functions that    *)
(* are not in the X/Open spec.				*)
(********************************************)

{$IFDEF ODBCVER300}

	SQL_API_SQLALLOCHANDLESTD	= 73;
	SQL_API_SQLBULKOPERATIONS	= 24;

{$ENDIF} (* ODBCVER300 *)

	SQL_API_SQLBINDPARAMETER    = 72;
	SQL_API_SQLBROWSECONNECT    = 55;
	SQL_API_SQLCOLATTRIBUTES    = 6;
	SQL_API_SQLCOLUMNPRIVILEGES = 56;
	SQL_API_SQLDESCRIBEPARAM    = 58;
	SQL_API_SQLDRIVERCONNECT	  = 41;
	SQL_API_SQLDRIVERS          = 71;
	SQL_API_SQLEXTENDEDFETCH    = 59;
	SQL_API_SQLFOREIGNKEYS      = 60;
	SQL_API_SQLMORERESULTS      = 61;
	SQL_API_SQLNATIVESQL        = 62;
	SQL_API_SQLNUMPARAMS        = 63;
	SQL_API_SQLPARAMOPTIONS     = 64;
	SQL_API_SQLPRIMARYKEYS      = 65;
	SQL_API_SQLPROCEDURECOLUMNS = 66;
	SQL_API_SQLPROCEDURES       = 67;
	SQL_API_SQLSETPOS           = 68;
	SQL_API_SQLSETSCROLLOPTIONS = 69;
	SQL_API_SQLTABLEPRIVILEGES  = 70;

(*-------------------------------------------*)
(* SQL_EXT_API_LAST is not useful with ODBC  *)
(* version 3.0 because some of the values    *)
(* from X/Open are in the 10000 range.       *)
(*-------------------------------------------*)

{$IFNDEF ODBCVER300}

	SQL_EXT_API_LAST            = SQL_API_SQLBINDPARAMETER;
	SQL_NUM_FUNCTIONS           = 23;
	SQL_EXT_API_START           = 40;
	SQL_NUM_EXTENSIONS          = (SQL_EXT_API_LAST-SQL_EXT_API_START+1);

{$ENDIF} (* ODBCVER300 *)

(*--------------------------------------------*)
(* SQL_API_ALL_FUNCTIONS returns an array     *)
(* of 'booleans' representing whether a       *)
(* function is implemented by the driver.     *)
(*                                            *)
(* CAUTION: Only functions defined in ODBC    *)
(* version 2.0 and earlier are returned, the  *)
(* new high-range function numbers defined by *)
(* X/Open break this scheme.   See the new    *)
(* method -- SQL_API_ODBC3_ALL_FUNCTIONS      *)
(*--------------------------------------------*)

	SQL_API_ALL_FUNCTIONS       = 0;		(* See CAUTION above *)

(*----------------------------------------------*)
(* 2.X drivers export a dummy function with  	*)
(* ordinal number SQL_API_LOADBYORDINAL to speed*)
(* loading under the windows operating system.  *)
(* 						*)
(* CAUTION: Loading by ordinal is not supported *)
(* for 3.0 and above drivers.			*)
(*----------------------------------------------*)

	SQL_API_LOADBYORDINAL       = 199;		(* See CAUTION above *)

(*----------------------------------------------*)
(* SQL_API_ODBC3_ALL_FUNCTIONS                  *)
(* This returns a bitmap, which allows us to    *)
(* handle the higher-valued function numbers.   *)
(* Use  SQL_FUNC_EXISTS(bitmap,function_number) *)
(* to determine if the function exists.         *)
(*----------------------------------------------*)


{$IFDEF ODBCVER300}

	SQL_API_ODBC3_ALL_FUNCTIONS	= 999;
	SQL_API_ODBC3_ALL_FUNCTIONS_SIZE	= 250;		(* array of 250 words *)

{
	SQL_FUNC_EXISTS(pfExists, uwAPI) \
				((*(((UWORD*) (pfExists)) + ((uwAPI) >> 4)) \
					& (1 << ((uwAPI) & 0x000F)) \
				 ) ? SQL_TRUE : SQL_FALSE \
				)
}

{$ENDIF} (* ODBCVER300 *)


(************************************************)
(* Extended definitions for SQLGetInfo			*)
(************************************************)

(*---------------------------------*)
(* Values in ODBC 2.0 that are not *)
(* in the X/Open spec              *)
(*---------------------------------*)

	SQL_INFO_FIRST                       = 0;
	SQL_ACTIVE_CONNECTIONS               = 0;	(* MAX_DRIVER_CONNECTIONS *)
	SQL_ACTIVE_STATEMENTS                = 1;	(* MAX_CONCURRENT_ACTIVITIES *)
	SQL_DRIVER_HDBC                      = 3;
	SQL_DRIVER_HENV                      = 4;
	SQL_DRIVER_HSTMT                     = 5;
	SQL_DRIVER_NAME                      = 6;
	SQL_DRIVER_VER                       = 7;
	SQL_ODBC_API_CONFORMANCE             = 9;
	SQL_ODBC_VER                         = 10;
	SQL_ROW_UPDATES                      = 11;
	SQL_ODBC_SAG_CLI_CONFORMANCE         = 12;
	SQL_ODBC_SQL_CONFORMANCE             = 15;
	SQL_PROCEDURES                       = 21;
	SQL_CONCAT_NULL_BEHAVIOR             = 22;
	SQL_CURSOR_ROLLBACK_BEHAVIOR         = 24;
	SQL_EXPRESSIONS_IN_ORDERBY           = 27;
	SQL_MAX_OWNER_NAME_LEN               = 32;	(* MAX_SCHEMA_NAME_LEN *)
	SQL_MAX_PROCEDURE_NAME_LEN           = 33;
	SQL_MAX_QUALIFIER_NAME_LEN           = 34;	(* MAX_CATALOG_NAME_LEN *)
	SQL_MULT_RESULT_SETS                 = 36;
	SQL_MULTIPLE_ACTIVE_TXN              = 37;
	SQL_OUTER_JOINS                      = 38;
	SQL_OWNER_TERM                       = 39;
	SQL_PROCEDURE_TERM                   = 40;
	SQL_QUALIFIER_NAME_SEPARATOR         = 41;
	SQL_QUALIFIER_TERM                   = 42;
	SQL_SCROLL_OPTIONS                   = 44;
	SQL_TABLE_TERM                       = 45;
	SQL_CONVERT_FUNCTIONS                = 48;
	SQL_NUMERIC_FUNCTIONS                = 49;
	SQL_STRING_FUNCTIONS                 = 50;
	SQL_SYSTEM_FUNCTIONS                 = 51;
	SQL_TIMEDATE_FUNCTIONS               = 52;
	SQL_CONVERT_BIGINT                   = 53;
	SQL_CONVERT_BINARY                   = 54;
	SQL_CONVERT_BIT                      = 55;
	SQL_CONVERT_CHAR                     = 56;
	SQL_CONVERT_DATE                     = 57;
	SQL_CONVERT_DECIMAL                  = 58;
	SQL_CONVERT_DOUBLE                   = 59;
	SQL_CONVERT_FLOAT                    = 60;
	SQL_CONVERT_INTEGER                  = 61;
	SQL_CONVERT_LONGVARCHAR              = 62;
	SQL_CONVERT_NUMERIC                  = 63;
	SQL_CONVERT_REAL                     = 64;
	SQL_CONVERT_SMALLINT                 = 65;
	SQL_CONVERT_TIME                     = 66;
	SQL_CONVERT_TIMESTAMP                = 67;
	SQL_CONVERT_TINYINT                  = 68;
	SQL_CONVERT_VARBINARY                = 69;
	SQL_CONVERT_VARCHAR                  = 70;
	SQL_CONVERT_LONGVARBINARY            = 71;
	SQL_ODBC_SQL_OPT_IEF                 = 73;		(* SQL_INTEGRITY *)
	SQL_CORRELATION_NAME                 = 74;
	SQL_NON_NULLABLE_COLUMNS             = 75;
	SQL_DRIVER_HLIB                      = 76;
	SQL_DRIVER_ODBC_VER                  = 77;
	SQL_LOCK_TYPES                       = 78;
	SQL_POS_OPERATIONS                   = 79;
	SQL_POSITIONED_STATEMENTS            = 80;
	SQL_BOOKMARK_PERSISTENCE             = 82;
	SQL_STATIC_SENSITIVITY               = 83;
	SQL_FILE_USAGE                       = 84;
	SQL_COLUMN_ALIAS                     = 87;
	SQL_GROUP_BY                         = 88;
	SQL_KEYWORDS                         = 89;
	SQL_OWNER_USAGE                      = 91;
	SQL_QUALIFIER_USAGE                  = 92;
	SQL_QUOTED_IDENTIFIER_CASE           = 93;
	SQL_SUBQUERIES                       = 95;
	SQL_UNION                            = 96;
	SQL_MAX_ROW_SIZE_INCLUDES_LONG       = 103;
	SQL_MAX_CHAR_LITERAL_LEN             = 108;
	SQL_TIMEDATE_ADD_INTERVALS           = 109;
	SQL_TIMEDATE_DIFF_INTERVALS          = 110;
	SQL_NEED_LONG_DATA_LEN               = 111;
	SQL_MAX_BINARY_LITERAL_LEN           = 112;
	SQL_LIKE_ESCAPE_CLAUSE               = 113;
	SQL_QUALIFIER_LOCATION               = 114;

{#if (ODBCVER >= 0x0201 && ODBCVER < 0x0300)}
{$IFNDEF ODBCVER300}
	{$IFDEF ODBCVER201}
		SQL_OJ_CAPABILITIES         = 65003;  (* Temp value until ODBC 3.0 *)
	{$ENDIF} (* ODBCVER201 *)
{$ENDIF}  (* ODBCVER >= 0x0201 && ODBCVER < 0x0300 *)

(*----------------------------------------------*)
(* SQL_INFO_LAST and SQL_INFO_DRIVER_START are  *)
(* not useful anymore, because  X/Open has      *)
(* values in the 10000 range.   You  			*)
(* must contact X/Open directly to get a range	*)
(* of numbers for driver-specific values.	    *)
(*----------------------------------------------*)

{$IFNDEF ODBCVER300}
	SQL_INFO_LAST						= SQL_QUALIFIER_LOCATION;
	SQL_INFO_DRIVER_START		= 1000;
{$ENDIF} (* ODBCVER < 0x0300 *)

(*-----------------------------------------------*)
(* ODBC 3.0 SQLGetInfo values that are not part  *)
(* of the X/Open standard at this time.   X/Open *)
(* standard values are in sql.h.				 *)
(*-----------------------------------------------*)

{$IFDEF ODBCVER300}
	SQL_ACTIVE_ENVIRONMENTS			          = 116;
	SQL_ALTER_DOMAIN						          = 117;

	SQL_SQL_CONFORMANCE					          = 118;
	SQL_DATETIME_LITERALS				          = 119;

	SQL_ASYNC_MODE							          = 10021;	(* new X/Open spec *)
	SQL_BATCH_ROW_COUNT					          = 120;
	SQL_BATCH_SUPPORT						          = 121;
	SQL_CATALOG_LOCATION				          = SQL_QUALIFIER_LOCATION;
	SQL_CATALOG_NAME_SEPARATOR	          = SQL_QUALIFIER_NAME_SEPARATOR;
	SQL_CATALOG_TERM						          = SQL_QUALIFIER_TERM;
	SQL_CATALOG_USAGE						          = SQL_QUALIFIER_USAGE;
	SQL_CONVERT_WCHAR						          = 122;
	SQL_CONVERT_INTERVAL_DAY_TIME			    = 123;
	SQL_CONVERT_INTERVAL_YEAR_MONTH		    = 124;
	SQL_CONVERT_WLONGVARCHAR				      = 125;
	SQL_CONVERT_WVARCHAR					        = 126;
	SQL_CREATE_ASSERTION					        = 127;
	SQL_CREATE_CHARACTER_SET				      = 128;
	SQL_CREATE_COLLATION					        = 129;
	SQL_CREATE_DOMAIN							        = 130;
	SQL_CREATE_SCHEMA							        = 131;
	SQL_CREATE_TABLE							        = 132;
	SQL_CREATE_TRANSLATION				        = 133;
	SQL_CREATE_VIEW								        = 134;
	SQL_DRIVER_HDESC							        = 135;
	SQL_DROP_ASSERTION						        = 136;
	SQL_DROP_CHARACTER_SET				        = 137;
	SQL_DROP_COLLATION						        = 138;
	SQL_DROP_DOMAIN								        = 139;
	SQL_DROP_SCHEMA								        = 140;
	SQL_DROP_TABLE								        = 141;
	SQL_DROP_TRANSLATION					        = 142;
	SQL_DROP_VIEW									        = 143;
	SQL_DYNAMIC_CURSOR_ATTRIBUTES1		    = 144;
	SQL_DYNAMIC_CURSOR_ATTRIBUTES2		    = 145;
	SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1	  = 146;
	SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2	  = 147;
	SQL_INDEX_KEYWORDS									  = 148;
	SQL_INFO_SCHEMA_VIEWS								  = 149;
	SQL_KEYSET_CURSOR_ATTRIBUTES1				  = 150;
	SQL_KEYSET_CURSOR_ATTRIBUTES2				  = 151;
	SQL_MAX_ASYNC_CONCURRENT_STATEMENTS	  = 10022;	(* new X/Open spec *)
	SQL_ODBC_INTERFACE_CONFORMANCE			  = 152;
	SQL_PARAM_ARRAY_ROW_COUNTS     			  = 153;
	SQL_PARAM_ARRAY_SELECTS     				  = 154;
	SQL_SCHEMA_TERM											  = SQL_OWNER_TERM;
	SQL_SCHEMA_USAGE										  = SQL_OWNER_USAGE;
	SQL_SQL92_DATETIME_FUNCTIONS				  = 155;
	SQL_SQL92_FOREIGN_KEY_DELETE_RULE		  = 156;
	SQL_SQL92_FOREIGN_KEY_UPDATE_RULE		  = 157;
	SQL_SQL92_GRANT											  = 158;
	SQL_SQL92_NUMERIC_VALUE_FUNCTIONS		  = 159;
	SQL_SQL92_PREDICATES								  = 160;
	SQL_SQL92_RELATIONAL_JOIN_OPERATORS	  = 161;
	SQL_SQL92_REVOKE										  = 162;
	SQL_SQL92_ROW_VALUE_CONSTRUCTOR			  = 163;
	SQL_SQL92_STRING_FUNCTIONS					  = 164;
	SQL_SQL92_VALUE_EXPRESSIONS					  = 165;
	SQL_STANDARD_CLI_CONFORMANCE				  = 166;
	SQL_STATIC_CURSOR_ATTRIBUTES1				  = 167;
	SQL_STATIC_CURSOR_ATTRIBUTES2				  = 168;

	SQL_AGGREGATE_FUNCTIONS				= 169;
	SQL_DDL_INDEX									= 170;
	SQL_DM_VER								    = 171;
	SQL_INSERT_STATEMENT					= 172;
	SQL_UNION_STATEMENT						= SQL_UNION;

{$ENDIF}  (* ODBCVER >= 0x0300 *)

(* SQL_ALTER_TABLE bitmasks *)
{$IFDEF ODBCVER300}
(* the following 5 bitmasks are defined in sql.h
*  SQL_AT_ADD_COLUMN                   	: LongInt = $00000001;
*  SQL_AT_DROP_COLUMN                  	: LongInt = $00000002;
*  SQL_AT_ADD_CONSTRAINT               	: LongInt = $00000008;
*)
	SQL_AT_ADD_COLUMN_SINGLE				: LongInt = $00000020;
	SQL_AT_ADD_COLUMN_DEFAULT				: LongInt = $00000040;
	SQL_AT_ADD_COLUMN_COLLATION				: LongInt = $00000080;
	SQL_AT_SET_COLUMN_DEFAULT				: LongInt = $00000100;
	SQL_AT_DROP_COLUMN_DEFAULT				: LongInt = $00000200;
	SQL_AT_DROP_COLUMN_CASCADE				: LongInt = $00000400;
	SQL_AT_DROP_COLUMN_RESTRICT				: LongInt = $00000800;
	SQL_AT_ADD_TABLE_CONSTRAINT				: LongInt = $00001000;
	SQL_AT_DROP_TABLE_CONSTRAINT_CASCADE	: LongInt = $00002000;
	SQL_AT_DROP_TABLE_CONSTRAINT_RESTRICT	: LongInt = $00004000;
	SQL_AT_CONSTRAINT_NAME_DEFINITION		: LongInt = $00008000;
	SQL_AT_CONSTRAINT_INITIALLY_DEFERRED	: LongInt = $00010000;
	SQL_AT_CONSTRAINT_INITIALLY_IMMEDIATE	: LongInt = $00020000;
	SQL_AT_CONSTRAINT_DEFERRABLE			: LongInt = $00040000;
	SQL_AT_CONSTRAINT_NON_DEFERRABLE		: LongInt = $00080000;
{$ENDIF}	(* ODBCVER >= : LongInt = $0300 *)

(* SQL_CONVERT_*  return value bitmasks *)

	SQL_CVT_CHAR                        : LongInt = $00000001;
	SQL_CVT_NUMERIC                     : LongInt = $00000002;
	SQL_CVT_DECIMAL                     : LongInt = $00000004;
	SQL_CVT_INTEGER                     : LongInt = $00000008;
	SQL_CVT_SMALLINT                    : LongInt = $00000010;
	SQL_CVT_FLOAT                       : LongInt = $00000020;
	SQL_CVT_REAL                        : LongInt = $00000040;
	SQL_CVT_DOUBLE                      : LongInt = $00000080;
	SQL_CVT_VARCHAR                     : LongInt = $00000100;
	SQL_CVT_LONGVARCHAR                 : LongInt = $00000200;
	SQL_CVT_BINARY                      : LongInt = $00000400;
	SQL_CVT_VARBINARY                   : LongInt = $00000800;
	SQL_CVT_BIT                         : LongInt = $00001000;
	SQL_CVT_TINYINT                     : LongInt = $00002000;
	SQL_CVT_BIGINT                      : LongInt = $00004000;
	SQL_CVT_DATE                        : LongInt = $00008000;
	SQL_CVT_TIME                        : LongInt = $00010000;
	SQL_CVT_TIMESTAMP                   : LongInt = $00020000;
	SQL_CVT_LONGVARBINARY               : LongInt = $00040000;
{$IFDEF ODBCVER300}
	SQL_CVT_INTERVAL_YEAR_MONTH	    	: LongInt = $00080000;
	SQL_CVT_INTERVAL_DAY_TIME	    	: LongInt = $00100000;
	SQL_CVT_WCHAR						: LongInt = $00200000;
	SQL_CVT_WLONGVARCHAR				: LongInt = $00400000;
	SQL_CVT_WVARCHAR					: LongInt = $00800000;

{$ENDIF}  (* ODBCVER >= : LongInt = $0300 *)


(* SQL_CONVERT_FUNCTIONS functions *)
	SQL_FN_CVT_CONVERT                  : LongInt = $00000001;
{$IFDEF ODBCVER300}
	SQL_FN_CVT_CAST						: LongInt = $00000002;
{$ENDIF}  (* ODBCVER >= : LongInt = $0300 *)


(* SQL_STRING_FUNCTIONS functions *)

	SQL_FN_STR_CONCAT                   : LongInt = $00000001;
	SQL_FN_STR_INSERT                   : LongInt = $00000002;
	SQL_FN_STR_LEFT                     : LongInt = $00000004;
	SQL_FN_STR_LTRIM                    : LongInt = $00000008;
	SQL_FN_STR_LENGTH                   : LongInt = $00000010;
	SQL_FN_STR_LOCATE                   : LongInt = $00000020;
	SQL_FN_STR_LCASE                    : LongInt = $00000040;
	SQL_FN_STR_REPEAT                   : LongInt = $00000080;
	SQL_FN_STR_REPLACE                  : LongInt = $00000100;
	SQL_FN_STR_RIGHT                    : LongInt = $00000200;
	SQL_FN_STR_RTRIM                    : LongInt = $00000400;
	SQL_FN_STR_SUBSTRING                : LongInt = $00000800;
	SQL_FN_STR_UCASE                    : LongInt = $00001000;
	SQL_FN_STR_ASCII                    : LongInt = $00002000;
	SQL_FN_STR_CHAR                     : LongInt = $00004000;
	SQL_FN_STR_DIFFERENCE               : LongInt = $00008000;
	SQL_FN_STR_LOCATE_2                 : LongInt = $00010000;
	SQL_FN_STR_SOUNDEX                  : LongInt = $00020000;
	SQL_FN_STR_SPACE                    : LongInt = $00040000;
{$IFDEF ODBCVER300}
	SQL_FN_STR_BIT_LENGTH				: LongInt = $00080000;
	SQL_FN_STR_CHAR_LENGTH				: LongInt = $00100000;
	SQL_FN_STR_CHARACTER_LENGTH			: LongInt = $00200000;
	SQL_FN_STR_OCTET_LENGTH				: LongInt = $00400000;
	SQL_FN_STR_POSITION					: LongInt = $00800000;
{$ENDIF}  (* ODBCVER >= : LongInt = $0300 *)

(* SQL_SQL92_STRING_FUNCTIONS *)
{$IFDEF ODBCVER300}
	SQL_SSF_CONVERT						: LongInt = $00000001;
	SQL_SSF_LOWER						: LongInt = $00000002;
	SQL_SSF_UPPER						: LongInt = $00000004;
	SQL_SSF_SUBSTRING					: LongInt = $00000008;
	SQL_SSF_TRANSLATE					: LongInt = $00000010;
	SQL_SSF_TRIM_BOTH					: LongInt = $00000020;
	SQL_SSF_TRIM_LEADING				: LongInt = $00000040;
	SQL_SSF_TRIM_TRAILING				: LongInt = $00000080;
{$ENDIF} (* ODBCVER >= : LongInt = $0300 *)

(* SQL_NUMERIC_FUNCTIONS functions *)

	SQL_FN_NUM_ABS                      : LongInt = $00000001;
	SQL_FN_NUM_ACOS                     : LongInt = $00000002;
	SQL_FN_NUM_ASIN                     : LongInt = $00000004;
	SQL_FN_NUM_ATAN                     : LongInt = $00000008;
	SQL_FN_NUM_ATAN2                    : LongInt = $00000010;
	SQL_FN_NUM_CEILING                  : LongInt = $00000020;
	SQL_FN_NUM_COS                      : LongInt = $00000040;
	SQL_FN_NUM_COT                      : LongInt = $00000080;
	SQL_FN_NUM_EXP                      : LongInt = $00000100;
	SQL_FN_NUM_FLOOR                    : LongInt = $00000200;
	SQL_FN_NUM_LOG                      : LongInt = $00000400;
	SQL_FN_NUM_MOD                      : LongInt = $00000800;
	SQL_FN_NUM_SIGN                     : LongInt = $00001000;
	SQL_FN_NUM_SIN                      : LongInt = $00002000;
	SQL_FN_NUM_SQRT                     : LongInt = $00004000;
	SQL_FN_NUM_TAN                      : LongInt = $00008000;
	SQL_FN_NUM_PI                       : LongInt = $00010000;
	SQL_FN_NUM_RAND                     : LongInt = $00020000;
	SQL_FN_NUM_DEGREES                  : LongInt = $00040000;
	SQL_FN_NUM_LOG10                    : LongInt = $00080000;
	SQL_FN_NUM_POWER                    : LongInt = $00100000;
	SQL_FN_NUM_RADIANS                  : LongInt = $00200000;
	SQL_FN_NUM_ROUND                    : LongInt = $00400000;
	SQL_FN_NUM_TRUNCATE                 : LongInt = $00800000;

(* SQL_SQL92_NUMERIC_VALUE_FUNCTIONS *)
{$IFDEF ODBCVER300}
	SQL_SNVF_BIT_LENGTH					: LongInt = $00000001;
	SQL_SNVF_CHAR_LENGTH				: LongInt = $00000002;
	SQL_SNVF_CHARACTER_LENGTH			: LongInt = $00000004;
	SQL_SNVF_EXTRACT					: LongInt = $00000008;
	SQL_SNVF_OCTET_LENGTH				: LongInt = $00000010;
	SQL_SNVF_POSITION					: LongInt = $00000020;
{$ENDIF}  (* ODBCVER >= : LongInt = $0300 *)

(* SQL_TIMEDATE_FUNCTIONS functions *)

	SQL_FN_TD_NOW                       : LongInt = $00000001;
	SQL_FN_TD_CURDATE                   : LongInt = $00000002;
	SQL_FN_TD_DAYOFMONTH                : LongInt = $00000004;
	SQL_FN_TD_DAYOFWEEK                 : LongInt = $00000008;
	SQL_FN_TD_DAYOFYEAR                 : LongInt = $00000010;
	SQL_FN_TD_MONTH                     : LongInt = $00000020;
	SQL_FN_TD_QUARTER                   : LongInt = $00000040;
	SQL_FN_TD_WEEK                      : LongInt = $00000080;
	SQL_FN_TD_YEAR                      : LongInt = $00000100;
	SQL_FN_TD_CURTIME                   : LongInt = $00000200;
	SQL_FN_TD_HOUR                      : LongInt = $00000400;
	SQL_FN_TD_MINUTE                    : LongInt = $00000800;
	SQL_FN_TD_SECOND                    : LongInt = $00001000;
	SQL_FN_TD_TIMESTAMPADD              : LongInt = $00002000;
	SQL_FN_TD_TIMESTAMPDIFF             : LongInt = $00004000;
	SQL_FN_TD_DAYNAME                   : LongInt = $00008000;
	SQL_FN_TD_MONTHNAME                 : LongInt = $00010000;
{$IFDEF ODBCVER300}
	SQL_FN_TD_CURRENT_DATE				: LongInt = $00020000;
	SQL_FN_TD_CURRENT_TIME				: LongInt = $00040000;
	SQL_FN_TD_CURRENT_TIMESTAMP			: LongInt = $00080000;
	SQL_FN_TD_EXTRACT					: LongInt = $00100000;
{$ENDIF}  (* ODBCVER >= : LongInt = $0300 *)

(* SQL_SQL92_DATETIME_FUNCTIONS *)
{$IFDEF ODBCVER300}
	SQL_SDF_CURRENT_DATE				: LongInt = $00000001;
	SQL_SDF_CURRENT_TIME				: LongInt = $00000002;
	SQL_SDF_CURRENT_TIMESTAMP			: LongInt = $00000004;
{$ENDIF} (* ODBCVER >= : LongInt = $0300 *)

(* SQL_SYSTEM_FUNCTIONS functions *)

	SQL_FN_SYS_USERNAME                 : LongInt = $00000001;
	SQL_FN_SYS_DBNAME                   : LongInt = $00000002;
	SQL_FN_SYS_IFNULL                   : LongInt = $00000004;

(* SQL_TIMEDATE_ADD_INTERVALS and SQL_TIMEDATE_DIFF_INTERVALS functions *)

	SQL_FN_TSI_FRAC_SECOND              : LongInt = $00000001;
	SQL_FN_TSI_SECOND                   : LongInt = $00000002;
	SQL_FN_TSI_MINUTE                   : LongInt = $00000004;
	SQL_FN_TSI_HOUR                     : LongInt = $00000008;
	SQL_FN_TSI_DAY                      : LongInt = $00000010;
	SQL_FN_TSI_WEEK                     : LongInt = $00000020;
	SQL_FN_TSI_MONTH                    : LongInt = $00000040;
	SQL_FN_TSI_QUARTER                  : LongInt = $00000080;
	SQL_FN_TSI_YEAR                     : LongInt = $00000100;

(* bitmasks for SQL_DYNAMIC_CURSOR_ATTRIBUTES1,
 * SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1,
 * SQL_KEYSET_CURSOR_ATTRIBUTES1, and SQL_STATIC_CURSOR_ATTRIBUTES1
 *)
{$IFDEF ODBCVER300}
(* supported SQLFetchScroll FetchOrientation's *)
	SQL_CA1_NEXT						: LongInt = $00000001;
	SQL_CA1_ABSOLUTE					: LongInt = $00000002;
	SQL_CA1_RELATIVE					: LongInt = $00000004;
	SQL_CA1_BOOKMARK					: LongInt = $00000008;

(* supported SQLSetPos LockType's *)
	SQL_CA1_LOCK_NO_CHANGE				: LongInt = $00000040;
	SQL_CA1_LOCK_EXCLUSIVE				: LongInt = $00000080;
	SQL_CA1_LOCK_UNLOCK					: LongInt = $00000100;

(* supported SQLSetPos Operations *)
	SQL_CA1_POS_POSITION				: LongInt = $00000200;
	SQL_CA1_POS_UPDATE					: LongInt = $00000400;
	SQL_CA1_POS_DELETE					: LongInt = $00000800;
	SQL_CA1_POS_REFRESH					: LongInt = $00001000;

(* positioned updates and deletes *)
	SQL_CA1_POSITIONED_UPDATE			: LongInt = $00002000;
	SQL_CA1_POSITIONED_DELETE			: LongInt = $00004000;
	SQL_CA1_SELECT_FOR_UPDATE			: LongInt = $00008000;

(* supported SQLBulkOperations operations *)
	SQL_CA1_BULK_ADD					: LongInt = $00010000;
	SQL_CA1_BULK_UPDATE_BY_BOOKMARK		: LongInt = $00020000;
	SQL_CA1_BULK_DELETE_BY_BOOKMARK		: LongInt = $00040000;
	SQL_CA1_BULK_FETCH_BY_BOOKMARK		: LongInt = $00080000;
{$ENDIF}  (* ODBCVER >= : LongInt = $0300 *)

(* bitmasks for SQL_DYNAMIC_CURSOR_ATTRIBUTES2,
 * SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2,
 * SQL_KEYSET_CURSOR_ATTRIBUTES2, and SQL_STATIC_CURSOR_ATTRIBUTES2
 *)
{$IFDEF ODBCVER300}
(* supported values for SQL_ATTR_SCROLL_CONCURRENCY *)
	SQL_CA2_READ_ONLY_CONCURRENCY		: LongInt = $00000001;
	SQL_CA2_LOCK_CONCURRENCY			: LongInt = $00000002;
	SQL_CA2_OPT_ROWVER_CONCURRENCY		: LongInt = $00000004;
	SQL_CA2_OPT_VALUES_CONCURRENCY		: LongInt = $00000008;

(* sensitivity of the cursor to its own inserts, deletes, and updates *)
	SQL_CA2_SENSITIVITY_ADDITIONS		: LongInt = $00000010;
	SQL_CA2_SENSITIVITY_DELETIONS		: LongInt = $00000020;
	SQL_CA2_SENSITIVITY_UPDATES			: LongInt = $00000040;

(* semantics of SQL_ATTR_MAX_ROWS *)
	SQL_CA2_MAX_ROWS_SELECT				: LongInt = $00000080;
	SQL_CA2_MAX_ROWS_INSERT				: LongInt = $00000100;
	SQL_CA2_MAX_ROWS_DELETE				: LongInt = $00000200;
	SQL_CA2_MAX_ROWS_UPDATE				: LongInt = $00000400;
	SQL_CA2_MAX_ROWS_CATALOG			: LongInt = $00000800;
	SQL_CA2_MAX_ROWS_AFFECTS_ALL	: LongInt =	$00000F80;

(* semantics of SQL_DIAG_CURSOR_ROW_COUNT *)
	SQL_CA2_CRC_EXACT					: LongInt = $00001000;
	SQL_CA2_CRC_APPROXIMATE				: LongInt = $00002000;

(* the kinds of positioned statements that can be simulated *)
	SQL_CA2_SIMULATE_NON_UNIQUE			: LongInt = $00004000;
	SQL_CA2_SIMULATE_TRY_UNIQUE			: LongInt = $00008000;
	SQL_CA2_SIMULATE_UNIQUE				: LongInt = $00010000;
{$ENDIF}  (* ODBCVER >= : LongInt = $0300 *)

(* SQL_ODBC_API_CONFORMANCE values *)

	SQL_OAC_NONE                        = $0000;
	SQL_OAC_LEVEL1                      = $0001;
	SQL_OAC_LEVEL2                      = $0002;

(* SQL_ODBC_SAG_CLI_CONFORMANCE values *)

	SQL_OSCC_NOT_COMPLIANT              = $0000;
	SQL_OSCC_COMPLIANT                  = $0001;

(* SQL_ODBC_SQL_CONFORMANCE values *)

	SQL_OSC_MINIMUM                     = $0000;
	SQL_OSC_CORE                        = $0001;
	SQL_OSC_EXTENDED                    = $0002;


(* SQL_CONCAT_NULL_BEHAVIOR values *)

	SQL_CB_NULL                         = $0000;
	SQL_CB_NON_NULL                     = $0001;

(* SQL_SCROLL_OPTIONS masks *)

	SQL_SO_FORWARD_ONLY                 : LongInt = $00000001;
	SQL_SO_KEYSET_DRIVEN                : LongInt = $00000002;
	SQL_SO_DYNAMIC                      : LongInt = $00000004;
	SQL_SO_MIXED                        : LongInt = $00000008;
	SQL_SO_STATIC                       : LongInt = $00000010;

(* SQL_FETCH_DIRECTION masks *)

(* SQL_FETCH_RESUME is no longer supported *)
{$IFNDEF ODBCVER300}
	SQL_FD_FETCH_RESUME                 : LongInt = $00000040;
{$ENDIF}

	SQL_FD_FETCH_BOOKMARK               : LongInt = $00000080;

(* SQL_TXN_ISOLATION_OPTION masks *)
(* SQL_TXN_VERSIONING is no longer supported *)
{$IFNDEF ODBCVER300}
	SQL_TXN_VERSIONING                  : LongInt = $00000010;
{$ENDIF}

(* SQL_CORRELATION_NAME values *)

	SQL_CN_NONE                         = $0000;
	SQL_CN_DIFFERENT                    = $0001;
	SQL_CN_ANY                          = $0002;

(* SQL_NON_NULLABLE_COLUMNS values *)

	SQL_NNC_NULL                        = $0000;
	SQL_NNC_NON_NULL                    = $0001;

(* SQL_NULL_COLLATION values *)

	SQL_NC_START                        = $0002;
	SQL_NC_END                          = $0004;

(* SQL_FILE_USAGE values *)

	SQL_FILE_NOT_SUPPORTED              = $0000;
	SQL_FILE_TABLE                      = $0001;
	SQL_FILE_QUALIFIER                  = $0002;
	SQL_FILE_CATALOG										= SQL_FILE_QUALIFIER;	// ODBC 3.0


(* SQL_GETDATA_EXTENSIONS values *)

	SQL_GD_BLOCK                        : LongInt = $00000004;
	SQL_GD_BOUND                        : LongInt = $00000008;

(* SQL_POSITIONED_STATEMENTS masks *)

	SQL_PS_POSITIONED_DELETE            : LongInt = $00000001;
	SQL_PS_POSITIONED_UPDATE            : LongInt = $00000002;
	SQL_PS_SELECT_FOR_UPDATE            : LongInt = $00000004;

(* SQL_GROUP_BY values *)

	SQL_GB_NOT_SUPPORTED                = $0000;
	SQL_GB_GROUP_BY_EQUALS_SELECT       = $0001;
	SQL_GB_GROUP_BY_CONTAINS_SELECT     = $0002;
	SQL_GB_NO_RELATION                  = $0003;
{$IFDEF ODBCVER300}
	SQL_GB_COLLATE											= $0004;

{$ENDIF}  (* ODBCVER >= : LongInt = $0300 *)

(* SQL_OWNER_USAGE masks *)

	SQL_OU_DML_STATEMENTS               : LongInt = $00000001;
	SQL_OU_PROCEDURE_INVOCATION         : LongInt = $00000002;
	SQL_OU_TABLE_DEFINITION             : LongInt = $00000004;
	SQL_OU_INDEX_DEFINITION             : LongInt = $00000008;
	SQL_OU_PRIVILEGE_DEFINITION         : LongInt = $00000010;

(* SQL_SCHEMA_USAGE masks *)
{$IFDEF ODBCVER300}
	SQL_SU_DML_STATEMENTS					: LongInt = $00000001;
	SQL_SU_PROCEDURE_INVOCATION		: LongInt = $00000002;
	SQL_SU_TABLE_DEFINITION				: LongInt = $00000004;
	SQL_SU_INDEX_DEFINITION				: LongInt = $00000008;
	SQL_SU_PRIVILEGE_DEFINITION		: LongInt = $00000010;
{$ENDIF}  (* ODBCVER >= : LongInt = $0300 *)

(* SQL_QUALIFIER_USAGE masks *)

	SQL_QU_DML_STATEMENTS               : LongInt = $00000001;
	SQL_QU_PROCEDURE_INVOCATION         : LongInt = $00000002;
	SQL_QU_TABLE_DEFINITION             : LongInt = $00000004;
	SQL_QU_INDEX_DEFINITION             : LongInt = $00000008;
	SQL_QU_PRIVILEGE_DEFINITION         : LongInt = $00000010;

{$IFDEF ODBCVER300}
(* SQL_CATALOG_USAGE masks *)
	SQL_CU_DML_STATEMENTS					: LongInt = $00000001;
	SQL_CU_PROCEDURE_INVOCATION		: LongInt = $00000002;
	SQL_CU_TABLE_DEFINITION				: LongInt = $00000004;
	SQL_CU_INDEX_DEFINITION				: LongInt = $00000008;
	SQL_CU_PRIVILEGE_DEFINITION		: LongInt = $00000010;
{$ENDIF}  (* ODBCVER >= : LongInt = $0300 *)

(* SQL_SUBQUERIES masks *)

	SQL_SQ_COMPARISON                   : LongInt = $00000001;
	SQL_SQ_EXISTS                       : LongInt = $00000002;
	SQL_SQ_IN                           : LongInt = $00000004;
	SQL_SQ_QUANTIFIED                   : LongInt = $00000008;
	SQL_SQ_CORRELATED_SUBQUERIES        : LongInt = $00000010;

(* SQL_UNION masks *)

	SQL_U_UNION                         : LongInt = $00000001;
	SQL_U_UNION_ALL                     : LongInt = $00000002;

(* SQL_BOOKMARK_PERSISTENCE values *)

	SQL_BP_CLOSE                        : LongInt = $00000001;
	SQL_BP_DELETE                       : LongInt = $00000002;
	SQL_BP_DROP                         : LongInt = $00000004;
	SQL_BP_TRANSACTION                  : LongInt = $00000008;
	SQL_BP_UPDATE                       : LongInt = $00000010;
	SQL_BP_OTHER_HSTMT                  : LongInt = $00000020;
	SQL_BP_SCROLL                       : LongInt = $00000040;

(* SQL_STATIC_SENSITIVITY values *)

	SQL_SS_ADDITIONS                    : LongInt = $00000001;
	SQL_SS_DELETIONS                    : LongInt = $00000002;
	SQL_SS_UPDATES                      : LongInt = $00000004;

(* SQL_VIEW values *)
	SQL_CV_CREATE_VIEW					: LongInt = $00000001;
	SQL_CV_CHECK_OPTION					: LongInt = $00000002;
	SQL_CV_CASCADED						: LongInt = $00000004;
	SQL_CV_LOCAL						: LongInt = $00000008;

(* SQL_LOCK_TYPES masks *)

	SQL_LCK_NO_CHANGE                   : LongInt = $00000001;
	SQL_LCK_EXCLUSIVE                   : LongInt = $00000002;
	SQL_LCK_UNLOCK                      : LongInt = $00000004;

(* SQL_POS_OPERATIONS masks *)

	SQL_POS_POSITION                    : LongInt = $00000001;
	SQL_POS_REFRESH                     : LongInt = $00000002;
	SQL_POS_UPDATE                      : LongInt = $00000004;
	SQL_POS_DELETE                      : LongInt = $00000008;
	SQL_POS_ADD                         : LongInt = $00000010;

(* SQL_QUALIFIER_LOCATION values *)

	SQL_QL_START                        = $0001;
	SQL_QL_END                          = $0002;

(* Here start return values for ODBC 3.0 SQLGetInfo *)

{$IFDEF ODBCVER300}
(* SQL_AGGREGATE_FUNCTIONS bitmasks *)
	SQL_AF_AVG						: LongInt = $00000001;
	SQL_AF_COUNT					: LongInt = $00000002;
	SQL_AF_MAX						: LongInt = $00000004;
	SQL_AF_MIN						: LongInt = $00000008;
	SQL_AF_SUM						: LongInt = $00000010;
	SQL_AF_DISTINCT				: LongInt = $00000020;
	SQL_AF_ALL						: LongInt = $0000003F;

(* SQL_SQL_CONFORMANCE bit masks *)
	SQL_SC_SQL92_ENTRY				: LongInt = $00000001;
	SQL_SC_FIPS127_2_TRANSITIONAL	: LongInt = $00000002;
	SQL_SC_SQL92_INTERMEDIATE		: LongInt = $00000004;
	SQL_SC_SQL92_FULL				: LongInt = $00000008;

(* SQL_DATETIME_LITERALS masks *)
	SQL_DL_SQL92_DATE						: LongInt = $00000001;
	SQL_DL_SQL92_TIME						: LongInt = $00000002;
	SQL_DL_SQL92_TIMESTAMP					: LongInt = $00000004;
	SQL_DL_SQL92_INTERVAL_YEAR				: LongInt = $00000008;
	SQL_DL_SQL92_INTERVAL_MONTH				: LongInt = $00000010;
	SQL_DL_SQL92_INTERVAL_DAY				: LongInt = $00000020;
	SQL_DL_SQL92_INTERVAL_HOUR				: LongInt = $00000040;
	SQL_DL_SQL92_INTERVAL_MINUTE			: LongInt = $00000080;
	SQL_DL_SQL92_INTERVAL_SECOND			: LongInt = $00000100;
	SQL_DL_SQL92_INTERVAL_YEAR_TO_MONTH		: LongInt = $00000200;
	SQL_DL_SQL92_INTERVAL_DAY_TO_HOUR		: LongInt = $00000400;
	SQL_DL_SQL92_INTERVAL_DAY_TO_MINUTE		: LongInt = $00000800;
	SQL_DL_SQL92_INTERVAL_DAY_TO_SECOND		: LongInt = $00001000;
	SQL_DL_SQL92_INTERVAL_HOUR_TO_MINUTE	: LongInt = $00002000;
	SQL_DL_SQL92_INTERVAL_HOUR_TO_SECOND	: LongInt = $00004000;
	SQL_DL_SQL92_INTERVAL_MINUTE_TO_SECOND	: LongInt = $00008000;

(* SQL_CATALOG_LOCATION values *)
	SQL_CL_START						= SQL_QL_START;
	SQL_CL_END							= SQL_QL_END;

(* values for SQL_BATCH_ROW_COUNT *)
	SQL_BRC_PROCEDURES		= $0000001;
	SQL_BRC_EXPLICIT			= $0000002;
	SQL_BRC_ROLLED_UP			= $0000004;

(* bitmasks for SQL_BATCH_SUPPORT *)
	SQL_BS_SELECT_EXPLICIT				: LongInt = $00000001;
	SQL_BS_ROW_COUNT_EXPLICIT			: LongInt = $00000002;
	SQL_BS_SELECT_PROC					: LongInt = $00000004;
	SQL_BS_ROW_COUNT_PROC				: LongInt = $00000008;

(* Values for SQL_PARAM_ARRAY_ROW_COUNTS getinfo *)
	SQL_PARC_BATCH		= 1;
	SQL_PARC_NO_BATCH	= 2;

(* values for SQL_PARAM_ARRAY_SELECT_BATCH*)
	SQL_PAS_BATCH				= 1;
	SQL_PAS_NO_BATCH		=	2;
	SQL_PAS_NO_SELECT		=	3;

(* Bitmasks for SQL_INDEX_KEYWORDS *)
	SQL_IK_NONE							: LongInt = $00000000;
	SQL_IK_ASC							: LongInt = $00000001;
	SQL_IK_DESC							: LongInt = $00000002;
	SQL_IK_ALL							: LongInt = $00000003;

(* Bitmasks for SQL_INFO_SCHEMA_VIEWS *)

	SQL_ISV_ASSERTIONS					: LongInt = $00000001;
	SQL_ISV_CHARACTER_SETS				: LongInt = $00000002;
	SQL_ISV_CHECK_CONSTRAINTS			: LongInt = $00000004;
	SQL_ISV_COLLATIONS					: LongInt = $00000008;
	SQL_ISV_COLUMN_DOMAIN_USAGE			: LongInt = $00000010;
	SQL_ISV_COLUMN_PRIVILEGES			: LongInt = $00000020;
	SQL_ISV_COLUMNS						: LongInt = $00000040;
	SQL_ISV_CONSTRAINT_COLUMN_USAGE		: LongInt = $00000080;
	SQL_ISV_CONSTRAINT_TABLE_USAGE		: LongInt = $00000100;
	SQL_ISV_DOMAIN_CONSTRAINTS			: LongInt = $00000200;
	SQL_ISV_DOMAINS						: LongInt = $00000400;
	SQL_ISV_KEY_COLUMN_USAGE			: LongInt = $00000800;
	SQL_ISV_REFERENTIAL_CONSTRAINTS		: LongInt = $00001000;
	SQL_ISV_SCHEMATA					: LongInt = $00002000;
	SQL_ISV_SQL_LANGUAGES				: LongInt = $00004000;
	SQL_ISV_TABLE_CONSTRAINTS			: LongInt = $00008000;
	SQL_ISV_TABLE_PRIVILEGES			: LongInt = $00010000;
	SQL_ISV_TABLES						: LongInt = $00020000;
	SQL_ISV_TRANSLATIONS				: LongInt = $00040000;
	SQL_ISV_USAGE_PRIVILEGES			: LongInt = $00080000;
	SQL_ISV_VIEW_COLUMN_USAGE			: LongInt = $00100000;
	SQL_ISV_VIEW_TABLE_USAGE			: LongInt = $00200000;
	SQL_ISV_VIEWS						: LongInt = $00400000;

(* Bitmasks for SQL_ASYNC_MODE *)

	SQL_AM_NONE			  = 0;
	SQL_AM_CONNECTION	= 1;
	SQL_AM_STATEMENT	= 2;

(* Bitmasks for SQL_ALTER_DOMAIN *)
	SQL_AD_CONSTRAINT_NAME_DEFINITION		: LongInt = $00000001;
	SQL_AD_ADD_DOMAIN_CONSTRAINT	 			: LongInt = $00000002;
	SQL_AD_DROP_DOMAIN_CONSTRAINT	 			: LongInt = $00000004;
	SQL_AD_ADD_DOMAIN_DEFAULT   	 			: LongInt = $00000008;
	SQL_AD_DROP_DOMAIN_DEFAULT   	 			: LongInt = $00000010;
	SQL_AD_ADD_CONSTRAINT_INITIALLY_DEFERRED	: LongInt = $00000020;
	SQL_AD_ADD_CONSTRAINT_INITIALLY_IMMEDIATE	: LongInt = $00000040;
	SQL_AD_ADD_CONSTRAINT_DEFERRABLE			: LongInt = $00000080;
	SQL_AD_ADD_CONSTRAINT_NON_DEFERRABLE		: LongInt = $00000100;


(* SQL_CREATE_SCHEMA bitmasks *)
	SQL_CS_CREATE_SCHEMA				: LongInt = $00000001;
	SQL_CS_AUTHORIZATION				: LongInt = $00000002;
	SQL_CS_DEFAULT_CHARACTER_SET		: LongInt = $00000004;

(* SQL_CREATE_TRANSLATION bitmasks *)
	SQL_CTR_CREATE_TRANSLATION			: LongInt = $00000001;

(* SQL_CREATE_ASSERTION bitmasks *)
	SQL_CA_CREATE_ASSERTION					: LongInt = $00000001;
	SQL_CA_CONSTRAINT_INITIALLY_DEFERRED	: LongInt = $00000010;
	SQL_CA_CONSTRAINT_INITIALLY_IMMEDIATE	: LongInt = $00000020;
	SQL_CA_CONSTRAINT_DEFERRABLE			: LongInt = $00000040;
	SQL_CA_CONSTRAINT_NON_DEFERRABLE		: LongInt = $00000080;

(* SQL_CREATE_CHARACTER_SET bitmasks *)
	SQL_CCS_CREATE_CHARACTER_SET		: LongInt = $00000001;
	SQL_CCS_COLLATE_CLAUSE				: LongInt = $00000002;
	SQL_CCS_LIMITED_COLLATION			: LongInt = $00000004;

(* SQL_CREATE_COLLATION bitmasks *)
	SQL_CCOL_CREATE_COLLATION			: LongInt = $00000001;

(* SQL_CREATE_DOMAIN bitmasks *)
	SQL_CDO_CREATE_DOMAIN					: LongInt = $00000001;
	SQL_CDO_DEFAULT							: LongInt = $00000002;
	SQL_CDO_CONSTRAINT						: LongInt = $00000004;
	SQL_CDO_COLLATION						: LongInt = $00000008;
	SQL_CDO_CONSTRAINT_NAME_DEFINITION		: LongInt = $00000010;
	SQL_CDO_CONSTRAINT_INITIALLY_DEFERRED	: LongInt = $00000020;
	SQL_CDO_CONSTRAINT_INITIALLY_IMMEDIATE	: LongInt = $00000040;
	SQL_CDO_CONSTRAINT_DEFERRABLE			: LongInt = $00000080;
	SQL_CDO_CONSTRAINT_NON_DEFERRABLE		: LongInt = $00000100;

(* SQL_CREATE_TABLE bitmasks *)
	SQL_CT_CREATE_TABLE						: LongInt = $00000001;
	SQL_CT_COMMIT_PRESERVE					: LongInt = $00000002;
	SQL_CT_COMMIT_DELETE					: LongInt = $00000004;
	SQL_CT_GLOBAL_TEMPORARY					: LongInt = $00000008;
	SQL_CT_LOCAL_TEMPORARY					: LongInt = $00000010;
	SQL_CT_CONSTRAINT_INITIALLY_DEFERRED	: LongInt = $00000020;
	SQL_CT_CONSTRAINT_INITIALLY_IMMEDIATE	: LongInt = $00000040;
	SQL_CT_CONSTRAINT_DEFERRABLE			: LongInt = $00000080;
	SQL_CT_CONSTRAINT_NON_DEFERRABLE		: LongInt = $00000100;
	SQL_CT_COLUMN_CONSTRAINT				: LongInt = $00000200;
	SQL_CT_COLUMN_DEFAULT					: LongInt = $00000400;
	SQL_CT_COLUMN_COLLATION					: LongInt = $00000800;
	SQL_CT_TABLE_CONSTRAINT					: LongInt = $00001000;
	SQL_CT_CONSTRAINT_NAME_DEFINITION		: LongInt = $00002000;

(* SQL_DDL_INDEX bitmasks *)
	SQL_DI_CREATE_INDEX						: LongInt = $00000001;
	SQL_DI_DROP_INDEX						: LongInt = $00000002;

(* SQL_DROP_COLLATION bitmasks *)
	SQL_DC_DROP_COLLATION					: LongInt = $00000001;

(* SQL_DROP_DOMAIN bitmasks *)
	SQL_DD_DROP_DOMAIN						: LongInt = $00000001;
	SQL_DD_RESTRICT							: LongInt = $00000002;
	SQL_DD_CASCADE							: LongInt = $00000004;

(* SQL_DROP_SCHEMA bitmasks *)
	SQL_DS_DROP_SCHEMA						: LongInt = $00000001;
	SQL_DS_RESTRICT							: LongInt = $00000002;
	SQL_DS_CASCADE							: LongInt = $00000004;

(* SQL_DROP_CHARACTER_SET bitmasks *)
	SQL_DCS_DROP_CHARACTER_SET				: LongInt = $00000001;

(* SQL_DROP_ASSERTION bitmasks *)
	SQL_DA_DROP_ASSERTION					: LongInt = $00000001;

(* SQL_DROP_TABLE bitmasks *)
	SQL_DT_DROP_TABLE						: LongInt = $00000001;
	SQL_DT_RESTRICT							: LongInt = $00000002;
	SQL_DT_CASCADE							: LongInt = $00000004;

(* SQL_DROP_TRANSLATION bitmasks *)
	SQL_DTR_DROP_TRANSLATION				: LongInt = $00000001;

(* SQL_DROP_VIEW bitmasks *)
	SQL_DV_DROP_VIEW						: LongInt = $00000001;
	SQL_DV_RESTRICT							: LongInt = $00000002;
	SQL_DV_CASCADE							: LongInt = $00000004;

(* SQL_INSERT_STATEMENT bitmasks *)
	SQL_IS_INSERT_LITERALS					: LongInt = $00000001;
	SQL_IS_INSERT_SEARCHED					: LongInt = $00000002;
	SQL_IS_SELECT_INTO						: LongInt = $00000004;

(* SQL_ODBC_INTERFACE_CONFORMANCE values *)
	SQL_OIC_CORE						: ULONG	= 1;
	SQL_OIC_LEVEL1					: ULONG	= 2;
	SQL_OIC_LEVEL2					: ULONG	= 3;

(* SQL_SQL92_FOREIGN_KEY_DELETE_RULE bitmasks *)
	SQL_SFKD_CASCADE						: LongInt = $00000001;
	SQL_SFKD_NO_ACTION						: LongInt = $00000002;
	SQL_SFKD_SET_DEFAULT					: LongInt = $00000004;
	SQL_SFKD_SET_NULL						: LongInt = $00000008;

(* SQL_SQL92_FOREIGN_KEY_UPDATE_RULE bitmasks *)
	SQL_SFKU_CASCADE						: LongInt = $00000001;
	SQL_SFKU_NO_ACTION						: LongInt = $00000002;
	SQL_SFKU_SET_DEFAULT					: LongInt = $00000004;
	SQL_SFKU_SET_NULL						: LongInt = $00000008;

(* SQL_SQL92_GRANT	bitmasks *)
	SQL_SG_USAGE_ON_DOMAIN					: LongInt = $00000001;
	SQL_SG_USAGE_ON_CHARACTER_SET			: LongInt = $00000002;
	SQL_SG_USAGE_ON_COLLATION				: LongInt = $00000004;
	SQL_SG_USAGE_ON_TRANSLATION				: LongInt = $00000008;
	SQL_SG_WITH_GRANT_OPTION				: LongInt = $00000010;
	SQL_SG_DELETE_TABLE						: LongInt = $00000020;
	SQL_SG_INSERT_TABLE						: LongInt = $00000040;
	SQL_SG_INSERT_COLUMN					: LongInt = $00000080;
	SQL_SG_REFERENCES_TABLE					: LongInt = $00000100;
	SQL_SG_REFERENCES_COLUMN				: LongInt = $00000200;
	SQL_SG_SELECT_TABLE						: LongInt = $00000400;
	SQL_SG_UPDATE_TABLE						: LongInt = $00000800;
	SQL_SG_UPDATE_COLUMN					: LongInt = $00001000;

(* SQL_SQL92_PREDICATES bitmasks *)
	SQL_SP_EXISTS							: LongInt = $00000001;
	SQL_SP_ISNOTNULL						: LongInt = $00000002;
	SQL_SP_ISNULL							: LongInt = $00000004;
	SQL_SP_MATCH_FULL						: LongInt = $00000008;
	SQL_SP_MATCH_PARTIAL					: LongInt = $00000010;
	SQL_SP_MATCH_UNIQUE_FULL				: LongInt = $00000020;
	SQL_SP_MATCH_UNIQUE_PARTIAL				: LongInt = $00000040;
	SQL_SP_OVERLAPS							: LongInt = $00000080;
	SQL_SP_UNIQUE							: LongInt = $00000100;
	SQL_SP_LIKE								: LongInt = $00000200;
	SQL_SP_IN								: LongInt = $00000400;
	SQL_SP_BETWEEN							: LongInt = $00000800;
	SQL_SP_COMPARISON						: LongInt = $00001000;
	SQL_SP_QUANTIFIED_COMPARISON			: LongInt = $00002000;

(* SQL_SQL92_RELATIONAL_JOIN_OPERATORS bitmasks *)
	SQL_SRJO_CORRESPONDING_CLAUSE			: LongInt = $00000001;
	SQL_SRJO_CROSS_JOIN						: LongInt = $00000002;
	SQL_SRJO_EXCEPT_JOIN					: LongInt = $00000004;
	SQL_SRJO_FULL_OUTER_JOIN				: LongInt = $00000008;
	SQL_SRJO_INNER_JOIN						: LongInt = $00000010;
	SQL_SRJO_INTERSECT_JOIN					: LongInt = $00000020;
	SQL_SRJO_LEFT_OUTER_JOIN				: LongInt = $00000040;
	SQL_SRJO_NATURAL_JOIN					: LongInt = $00000080;
	SQL_SRJO_RIGHT_OUTER_JOIN				: LongInt = $00000100;
	SQL_SRJO_UNION_JOIN						: LongInt = $00000200;

(* SQL_SQL92_REVOKE bitmasks *)
	SQL_SR_USAGE_ON_DOMAIN					: LongInt = $00000001;
	SQL_SR_USAGE_ON_CHARACTER_SET			: LongInt = $00000002;
	SQL_SR_USAGE_ON_COLLATION				: LongInt = $00000004;
	SQL_SR_USAGE_ON_TRANSLATION				: LongInt = $00000008;
	SQL_SR_GRANT_OPTION_FOR					: LongInt = $00000010;
	SQL_SR_CASCADE							: LongInt = $00000020;
	SQL_SR_RESTRICT							: LongInt = $00000040;
	SQL_SR_DELETE_TABLE						: LongInt = $00000080;
	SQL_SR_INSERT_TABLE						: LongInt = $00000100;
	SQL_SR_INSERT_COLUMN					: LongInt = $00000200;
	SQL_SR_REFERENCES_TABLE					: LongInt = $00000400;
	SQL_SR_REFERENCES_COLUMN				: LongInt = $00000800;
	SQL_SR_SELECT_TABLE						: LongInt = $00001000;
	SQL_SR_UPDATE_TABLE						: LongInt = $00002000;
	SQL_SR_UPDATE_COLUMN					: LongInt = $00004000;

(* SQL_SQL92_ROW_VALUE_CONSTRUCTOR bitmasks *)
	SQL_SRVC_VALUE_EXPRESSION				: LongInt = $00000001;
	SQL_SRVC_NULL							: LongInt = $00000002;
	SQL_SRVC_DEFAULT						: LongInt = $00000004;
	SQL_SRVC_ROW_SUBQUERY					: LongInt = $00000008;

(* SQL_SQL92_VALUE_EXPRESSIONS bitmasks *)
	SQL_SVE_CASE							: LongInt = $00000001;
	SQL_SVE_CAST							: LongInt = $00000002;
	SQL_SVE_COALESCE						: LongInt = $00000004;
	SQL_SVE_NULLIF							: LongInt = $00000008;

(* SQL_STANDARD_CLI_CONFORMANCE bitmasks *)
	SQL_SCC_XOPEN_CLI_VERSION1				: LongInt = $00000001;
	SQL_SCC_ISO92_CLI						: LongInt = $00000002;

(* SQL_UNION_STATEMENT bitmasks *)
	SQL_US_UNION							: LongInt = $00000001;
	SQL_US_UNION_ALL					: LongInt = $00000002;

{$ENDIF}  (* ODBCVER >= 0x0300 *)

(* additional SQLDataSources fetch directions *)
{$IFDEF ODBCVER300}
	SQL_FETCH_FIRST_USER				= 31;
	SQL_FETCH_FIRST_SYSTEM			=	32;
{$ENDIF}  (* ODBCVER >= 0x0300 *)


(* Defines for SQLSetPos *)
	SQL_ENTIRE_ROWSET           = 0;

(* Operations in SQLSetPos *)
	SQL_POSITION                 = 0;               (*      1.0 FALSE *)
	SQL_REFRESH                  = 1;               (*      1.0 TRUE *)
	SQL_UPDATE                   = 2;
	SQL_DELETE                   = 3;

(* Operations in SQLBulkOperations *)
	SQL_ADD                      = 4;
	SQL_SETPOS_MAX_OPTION_VALUE	 = SQL_ADD;
{$IFDEF ODBCVER300}
	SQL_UPDATE_BY_BOOKMARK		 = 5;
	SQL_DELETE_BY_BOOKMARK		 = 6;
	SQL_FETCH_BY_BOOKMARK		   = 7;

{$ENDIF} (*  ODBCVER >= 0x0300 *)

(* Lock options in SQLSetPos *)
	SQL_LOCK_NO_CHANGE           = 0;               (*      1.0 FALSE *)
	SQL_LOCK_EXCLUSIVE           = 1;               (*      1.0 TRUE *)
	SQL_LOCK_UNLOCK              = 2;

	SQL_SETPOS_MAX_LOCK_VALUE		= SQL_LOCK_UNLOCK;

(* Macros for SQLSetPos *)

{
	SQL_POSITION_TO(hstmt,irow) SQLSetPos(hstmt,irow,SQL_POSITION,SQL_LOCK_NO_CHANGE)
	SQL_LOCK_RECORD(hstmt,irow,fLock) SQLSetPos(hstmt,irow,SQL_POSITION,fLock)
	SQL_REFRESH_RECORD(hstmt,irow,fLock) SQLSetPos(hstmt,irow,SQL_REFRESH,fLock)
	SQL_UPDATE_RECORD(hstmt,irow) SQLSetPos(hstmt,irow,SQL_UPDATE,SQL_LOCK_NO_CHANGE)
	SQL_DELETE_RECORD(hstmt,irow) SQLSetPos(hstmt,irow,SQL_DELETE,SQL_LOCK_NO_CHANGE)
	SQL_ADD_RECORD(hstmt,irow) SQLSetPos(hstmt,irow,SQL_ADD,SQL_LOCK_NO_CHANGE)
}

(* Column types and scopes in SQLSpecialColumns.  *)
	SQL_BEST_ROWID                  = 1;
	SQL_ROWVER                      = 2;

(* Defines for SQLSpecialColumns (returned in the result set)
	 SQL_PC_UNKNOWN and SQL_PC_PSEUDO are defined in sql.h *)
	SQL_PC_NOT_PSEUDO               = 1;

(* Defines for SQLStatistics *)
	SQL_QUICK                       = 0;
	SQL_ENSURE                      = 1;

(* Defines for SQLStatistics (returned in the result set)
	 SQL_INDEX_CLUSTERED, SQL_INDEX_HASHED, and SQL_INDEX_OTHER are
	 defined in sql.h *)
	SQL_TABLE_STAT                  = 0;


(* Defines for SQLTables *)
{$IFDEF ODBCVER300}
	SQL_ALL_CATALOGS				= '%';
	SQL_ALL_SCHEMAS					= '%';
	SQL_ALL_TABLE_TYPES			= '%';
{$ENDIF}  (* ODBCVER >= 0x0300 *)

(* Options for SQLDriverConnect *)
	SQL_DRIVER_NOPROMPT             = 0;
	SQL_DRIVER_COMPLETE             = 1;
	SQL_DRIVER_PROMPT               = 2;
	SQL_DRIVER_COMPLETE_REQUIRED    = 3;

(* Level 2 Functions                             *)

(* SQLExtendedFetch "fFetchType" values *)
	SQL_FETCH_BOOKMARK               = 8;

(* SQLExtendedFetch "rgfRowStatus" element values *)
	SQL_ROW_SUCCESS                  = 0;
	SQL_ROW_DELETED                  = 1;
	SQL_ROW_UPDATED                  = 2;
	SQL_ROW_NOROW                    = 3;
	SQL_ROW_ADDED                    = 4;
	SQL_ROW_ERROR                    = 5;
{$IFDEF ODBCVER300}
	SQL_ROW_SUCCESS_WITH_INFO	 = 6;
	SQL_ROW_PROCEED					   = 0;
	SQL_ROW_IGNORE					   = 1;
{$ENDIF}

(* value for SQL_DESC_ARRAY_STATUS_PTR *)
{$IFDEF ODBCVER300}
	SQL_PARAM_SUCCESS				    = 0;
	SQL_PARAM_SUCCESS_WITH_INFO	= 6;
	SQL_PARAM_ERROR					    = 5;
	SQL_PARAM_UNUSED				    = 7;
	SQL_PARAM_DIAG_UNAVAILABLE	= 1;

	SQL_PARAM_PROCEED				    = 0;
	SQL_PARAM_IGNORE				    = 1;
{$ENDIF}  (* ODBCVER >= 0x0300 *)

(* Defines for SQLForeignKeys (returned in result set) *)
	SQL_CASCADE                      = 0;
	SQL_RESTRICT                     = 1;
	SQL_SET_NULL                     = 2;
{$IFDEF ODBCVER250}
	SQL_NO_ACTION			 = 3;
	SQL_SET_DEFAULT		 = 4;
{$ENDIF}  (* ODBCVER >= 0x0250 *)
{$IFDEF ODBCVER300}
	SQL_INITIALLY_DEFERRED			= 5;
	SQL_INITIALLY_IMMEDIATE			= 6;
{$ENDIF}  (* ODBCVER >= 0x0300 *)


(* Defines for SQLProcedures (returned in the result set) *)
	SQL_PT_UNKNOWN                  = 0;
	SQL_PT_PROCEDURE                = 1;
	SQL_PT_FUNCTION                 = 2;

(*      This define is too large for RC *)
	SQL_ODBC_KEYWORDS =
		'ABSOLUTE,ACTION,ADA,ADD,ALL,ALLOCATE,ALTER,AND,ANY,ARE,AS,' +
		'ASC,ASSERTION,AT,AUTHORIZATION,AVG,' +
		'BEGIN,BETWEEN,BIT,BIT_LENGTH,BOTH,BY,CASCADE,CASCADED,CASE,CAST,CATALOG,' +
		'CHAR,CHAR_LENGTH,CHARACTER,CHARACTER_LENGTH,CHECK,CLOSE,COALESCE,' +
		'COLLATE,COLLATION,COLUMN,COMMIT,CONNECT,CONNECTION,CONSTRAINT,' +
		'CONSTRAINTS,CONTINUE,CONVERT,CORRESPONDING,COUNT,CREATE,CROSS,CURRENT,' +
		'CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,' +
		'DATE,DAY,DEALLOCATE,DEC,DECIMAL,DECLARE,DEFAULT,DEFERRABLE,' +
		'DEFERRED,DELETE,DESC,DESCRIBE,DESCRIPTOR,DIAGNOSTICS,DISCONNECT,' +
		'DISTINCT,DOMAIN,DOUBLE,DROP,' +
		'ELSE,END,END-EXEC,ESCAPE,EXCEPT,EXCEPTION,EXEC,EXECUTE,' +
		'EXISTS,EXTERNAL,EXTRACT,' +
		'FALSE,FETCH,FIRST,FLOAT,FOR,FOREIGN,FORTRAN,FOUND,FROM,FULL,' +
		'GET,GLOBAL,GO,GOTO,GRANT,GROUP,HAVING,HOUR,' +
		'IDENTITY,IMMEDIATE,IN,INCLUDE,INDEX,INDICATOR,INITIALLY,INNER,' +
		'INPUT,INSENSITIVE,INSERT,INT,INTEGER,INTERSECT,INTERVAL,INTO,IS,ISOLATION,' +
		'JOIN,KEY,LANGUAGE,LAST,LEADING,LEFT,LEVEL,LIKE,LOCAL,LOWER,' +
		'MATCH,MAX,MIN,MINUTE,MODULE,MONTH,' +
		'NAMES,NATIONAL,NATURAL,NCHAR,NEXT,NO,NONE,NOT,NULL,NULLIF,NUMERIC,' +
		'OCTET_LENGTH,OF,ON,ONLY,OPEN,OPTION,OR,ORDER,OUTER,OUTPUT,OVERLAPS,' +
		'PAD,PARTIAL,PASCAL,PLI,POSITION,PRECISION,PREPARE,PRESERVE,' +
		'PRIMARY,PRIOR,PRIVILEGES,PROCEDURE,PUBLIC,' +
		'READ,REAL,REFERENCES,RELATIVE,RESTRICT,REVOKE,RIGHT,ROLLBACK,ROWS' +
		'SCHEMA,SCROLL,SECOND,SECTION,SELECT,SESSION,SESSION_USER,SET,SIZE,' +
		'SMALLINT,SOME,SPACE,SQL,SQLCA,SQLCODE,SQLERROR,SQLSTATE,SQLWARNING,' +
		'SUBSTRING,SUM,SYSTEM_USER,' +
		'TABLE,TEMPORARY,THEN,TIME,TIMESTAMP,TIMEZONE_HOUR,TIMEZONE_MINUTE,' +
		'TO,TRAILING,TRANSACTION,TRANSLATE,TRANSLATION,TRIM,TRUE,' +
		'UNION,UNIQUE,UNKNOWN,UPDATE,UPPER,USAGE,USER,USING,' +
		'VALUE,VALUES,VARCHAR,VARYING,VIEW,WHEN,WHENEVER,WHERE,WITH,WORK,WRITE,' +
		'YEAR,ZONE';

(*---------------------------------------------------------*)
(* SQLAllocHandleStd is implemented to make SQLAllocHandle *)
(* compatible with X/Open standard.	 an application should *)
(* not call SQLAllocHandleStd directly					   *)
(*---------------------------------------------------------*)
{$IFDEF ODBC_STD}
	SQLAllocHandle  = SQLAllocHandleStd;
{
	SQLAllocEnv(phenv)  SQLAllocHandleStd(SQL_HANDLE_ENV, SQL_NULL_HANDLE, phenv)
}

(* Internal type subcodes *)
	SQL_YEAR						    = SQL_CODE_YEAR;
	SQL_MONTH						    = SQL_CODE_MONTH;
	SQL_DAY							    = SQL_CODE_DAY;
	SQL_HOUR						    = SQL_CODE_HOUR;
	SQL_MINUTE					 	  = SQL_CODE_MINUTE;
	SQL_SECOND						  = SQL_CODE_SECOND;
	SQL_YEAR_TO_MONTH				= SQL_CODE_YEAR_TO_MONTH;
	SQL_DAY_TO_HOUR					= SQL_CODE_DAY_TO_HOUR;
	SQL_DAY_TO_MINUTE				= SQL_CODE_DAY_TO_MINUTE;
	SQL_DAY_TO_SECOND				= SQL_CODE_DAY_TO_SECOND;
	SQL_HOUR_TO_MINUTE			= SQL_CODE_HOUR_TO_MINUTE;
	SQL_HOUR_TO_SECOND			= SQL_CODE_HOUR_TO_SECOND;
	SQL_MINUTE_TO_SECOND		=	SQL_CODE_MINUTE_TO_SECOND;
{$ENDIF} (* ODBC_STD *)

{ Other codes used for FetchOrientation in SQLFetchScroll() }
	SQL_FETCH_LAST = 3;
	SQL_FETCH_PRIOR = 4;
	SQL_FETCH_ABSOLUTE = 5;
	SQL_FETCH_RELATIVE = 6;

{ SQL_FETCH_DIRECTION bitmasks }
	SQL_FD_FETCH_NEXT        : LongInt = $00000001;
	SQL_FD_FETCH_FIRST       : LongInt = $00000002;
	SQL_FD_FETCH_LAST        : LongInt = $00000004;
	SQL_FD_FETCH_PRIOR       : LongInt = $00000008;
	SQL_FD_FETCH_ABSOLUTE    : LongInt = $00000010;
	SQL_FD_FETCH_RELATIVE    : LongInt = $00000020;

{ SQL_SCROLL_CONCURRENCY bitmasks }
	SQL_SCCO_READ_ONLY        : LongInt = $00000001;
	SQL_SCCO_LOCK             : LongInt = $00000002;
	SQL_SCCO_OPT_ROWVER       : LongInt = $00000004;
	SQL_SCCO_OPT_VALUES       : LongInt = $00000008;

(*      Deprecated defines from prior versions of ODBC *)
	SQL_DATABASE_NAME               = 16;    (* Use SQLGetConnectOption/SQL_CURRENT_QUALIFIER *)
	SQL_FD_FETCH_PREV               : LongInt = $00000008;
	SQL_FETCH_PREV                  = SQL_FETCH_PRIOR;
	SQL_CONCUR_TIMESTAMP            = SQL_CONCUR_ROWVER;
	SQL_SCCO_OPT_TIMESTAMP          : LongInt = $00000004;
	SQL_CC_DELETE                   = SQL_CB_DELETE;
	SQL_CR_DELETE                   = SQL_CB_DELETE;
	SQL_CC_CLOSE                    = SQL_CB_CLOSE;
	SQL_CR_CLOSE                    = SQL_CB_CLOSE;
	SQL_CC_PRESERVE                 = SQL_CB_PRESERVE;
	SQL_CR_PRESERVE                 = SQL_CB_PRESERVE;
(* SQL_FETCH_RESUME is not supported by 2.0+ drivers  *)
{$IFNDEF ODBCVER300}
	SQL_FETCH_RESUME                = 7;
{$ENDIF}
	SQL_SCROLL_FORWARD_ONLY         : LongInt = 0;    (*-SQL_CURSOR_FORWARD_ONLY *)
	SQL_SCROLL_KEYSET_DRIVEN        : LongInt = (-1); (*-SQL_CURSOR_KEYSET_DRIVEN *)
	SQL_SCROLL_DYNAMIC              : LongInt = (-2); (*-SQL_CURSOR_DYNAMIC *)
	SQL_SCROLL_STATIC               : LongInt = (-3); (*-SQL_CURSOR_STATIC *)

{
--------------------------------------------------------------------------
---------- ODBC API Function Prototypes ----------------------------------
--------------------------------------------------------------------------
}

{
	ODBC Mappings: ODBC Core Functions

	Header files translated from SQL.h


01) SQLRETURN  SQL_API SQLAllocConnect(SQLHENV EnvironmentHandle,
							 SQLHDBC *ConnectionHandle);

02) SQLRETURN  SQL_API SQLAllocEnv(SQLHENV *EnvironmentHandle);

03) SQLRETURN  SQL_API SQLAllocHandle(SQLSMALLINT HandleType,
							 SQLHANDLE InputHandle, SQLHANDLE *OutputHandle);

04) SQLRETURN  SQL_API SQLAllocStmt(SQLHDBC ConnectionHandle,
							 SQLHSTMT *StatementHandle);

05) SQLRETURN  SQL_API SQLBindCol(SQLHSTMT StatementHandle,
							 SQLUSMALLINT ColumnNumber, SQLSMALLINT TargetType,
							 SQLPOINTER TargetValue, SQLINTEGER BufferLength,
							 SQLINTEGER *StrLen_or_Ind);

06) SQLRETURN  SQL_API SQLBindParam(SQLHSTMT StatementHandle,
							 SQLUSMALLINT ParameterNumber, SQLSMALLINT ValueType,
							 SQLSMALLINT ParameterType, SQLUINTEGER LengthPrecision,
							 SQLSMALLINT ParameterScale, SQLPOINTER ParameterValue,
							 SQLINTEGER *StrLen_or_Ind);

07) SQLRETURN  SQL_API SQLCancel(SQLHSTMT StatementHandle);

08) SQLRETURN  SQL_API SQLCloseCursor(SQLHSTMT StatementHandle);

09) SQLRETURN  SQL_API SQLColAttribute (SQLHSTMT StatementHandle,
							 SQLUSMALLINT ColumnNumber, SQLUSMALLINT FieldIdentifier,
							 SQLPOINTER CharacterAttribute, SQLSMALLINT BufferLength,
							 SQLSMALLINT *StringLength, SQLPOINTER NumericAttribute);

10) SQLRETURN  SQL_API SQLColumns(SQLHSTMT StatementHandle,
							 SQLCHAR *CatalogName, SQLSMALLINT NameLength1,
							 SQLCHAR *SchemaName, SQLSMALLINT NameLength2,
							 SQLCHAR *TableName, SQLSMALLINT NameLength3,
							 SQLCHAR *ColumnName, SQLSMALLINT NameLength4);

11)SQLRETURN  SQL_API SQLConnect(SQLHDBC ConnectionHandle,
					 SQLCHAR *ServerName, SQLSMALLINT NameLength1,
					 SQLCHAR *UserName, SQLSMALLINT NameLength2,
					 SQLCHAR *Authentication, SQLSMALLINT NameLength3);

12) SQLRETURN  SQL_API SQLCopyDesc(SQLHDESC SourceDescHandle,
						SQLHDESC TargetDescHandle);

13) SQLRETURN  SQL_API SQLDataSources(SQLHENV EnvironmentHandle,
					 SQLUSMALLINT Direction, SQLCHAR *ServerName,
					 SQLSMALLINT BufferLength1, SQLSMALLINT *NameLength1,
					 SQLCHAR *Description, SQLSMALLINT BufferLength2,
					 SQLSMALLINT *NameLength2);

14) SQLRETURN  SQL_API SQLDescribeCol(SQLHSTMT StatementHandle,
					 SQLUSMALLINT ColumnNumber, SQLCHAR *ColumnName,
					 SQLSMALLINT BufferLength, SQLSMALLINT *NameLength,
					 SQLSMALLINT *DataType, SQLUINTEGER *ColumnSize,
					 SQLSMALLINT *DecimalDigits, SQLSMALLINT *Nullable);

15) SQLRETURN  SQL_API SQLDisconnect(SQLHDBC ConnectionHandle);

16) SQLRETURN  SQL_API SQLEndTran(SQLSMALLINT HandleType, SQLHANDLE Handle,
					 SQLSMALLINT CompletionType);

17) SQLRETURN  SQL_API SQLError(SQLHENV EnvironmentHandle,
					 SQLHDBC ConnectionHandle, SQLHSTMT StatementHandle,
					 SQLCHAR *Sqlstate, SQLINTEGER *NativeError,
					 SQLCHAR *MessageText, SQLSMALLINT BufferLength,
					 SQLSMALLINT *TextLength);

18) SQLRETURN  SQL_API SQLExecDirect(SQLHSTMT StatementHandle,
					 SQLCHAR *StatementText, SQLINTEGER TextLength);

19) SQLRETURN  SQL_API SQLExecute(SQLHSTMT StatementHandle);

20) SQLRETURN  SQL_API SQLFetch(SQLHSTMT StatementHandle);

21) SQLRETURN  SQL_API SQLFetchScroll(SQLHSTMT StatementHandle,
					 SQLSMALLINT FetchOrientation, SQLINTEGER FetchOffset);

22) SQLRETURN  SQL_API SQLFreeConnect(SQLHDBC ConnectionHandle);

23) SQLRETURN  SQL_API SQLFreeEnv(SQLHENV EnvironmentHandle);

24) SQLRETURN  SQL_API SQLFreeHandle(SQLSMALLINT HandleType, SQLHANDLE Handle);

25) SQLRETURN  SQL_API SQLFreeStmt(SQLHSTMT StatementHandle,
					 SQLUSMALLINT Option);

26) SQLRETURN  SQL_API SQLGetConnectAttr(SQLHDBC ConnectionHandle,
					 SQLINTEGER Attribute, SQLPOINTER Value,
					 SQLINTEGER BufferLength, SQLINTEGER *StringLength);

27) SQLRETURN  SQL_API SQLGetConnectOption(SQLHDBC ConnectionHandle,
					 SQLUSMALLINT Option, SQLPOINTER Value);

28) SQLRETURN  SQL_API SQLGetCursorName(SQLHSTMT StatementHandle,
					 SQLCHAR *CursorName, SQLSMALLINT BufferLength,
					 SQLSMALLINT *NameLength);

29) SQLRETURN  SQL_API SQLGetData(SQLHSTMT StatementHandle,
					 SQLUSMALLINT ColumnNumber, SQLSMALLINT TargetType,
					 SQLPOINTER TargetValue, SQLINTEGER BufferLength,
					 SQLINTEGER *StrLen_or_Ind);

30) SQLRETURN  SQL_API SQLGetDescField(SQLHDESC DescriptorHandle,
					 SQLSMALLINT RecNumber, SQLSMALLINT FieldIdentifier,
					 SQLPOINTER Value, SQLINTEGER BufferLength,
					 SQLINTEGER *StringLength);

31) SQLRETURN  SQL_API SQLGetDescRec(SQLHDESC DescriptorHandle,
					 SQLSMALLINT RecNumber, SQLCHAR *Name,
					 SQLSMALLINT BufferLength, SQLSMALLINT *StringLength,
					 SQLSMALLINT *Type, SQLSMALLINT *SubType,
					 SQLINTEGER *Length, SQLSMALLINT *Precision,
					 SQLSMALLINT *Scale, SQLSMALLINT *Nullable);

32) SQLRETURN  SQL_API SQLGetDiagField(SQLSMALLINT HandleType, SQLHANDLE Handle,
					 SQLSMALLINT RecNumber, SQLSMALLINT DiagIdentifier,
					 SQLPOINTER DiagInfo, SQLSMALLINT BufferLength,
					 SQLSMALLINT *StringLength);

33) SQLRETURN  SQL_API SQLGetDiagRec(SQLSMALLINT HandleType, SQLHANDLE Handle,
					 SQLSMALLINT RecNumber, SQLCHAR *Sqlstate,
					 SQLINTEGER *NativeError, SQLCHAR *MessageText,
					 SQLSMALLINT BufferLength, SQLSMALLINT *TextLength);

34) SQLRETURN  SQL_API SQLGetEnvAttr(SQLHENV EnvironmentHandle,
					 SQLINTEGER Attribute, SQLPOINTER Value,
					 SQLINTEGER BufferLength, SQLINTEGER *StringLength);

35) SQLRETURN  SQL_API SQLGetFunctions(SQLHDBC ConnectionHandle,
					 SQLUSMALLINT FunctionId, SQLUSMALLINT *Supported);

36) SQLRETURN  SQL_API SQLGetInfo(SQLHDBC ConnectionHandle,
					 SQLUSMALLINT InfoType, SQLPOINTER InfoValue,
					 SQLSMALLINT BufferLength, SQLSMALLINT *StringLength);

37) SQLRETURN  SQL_API SQLGetStmtAttr(SQLHSTMT StatementHandle,
					 SQLINTEGER Attribute, SQLPOINTER Value,
					 SQLINTEGER BufferLength, SQLINTEGER *StringLength);

38) SQLRETURN  SQL_API SQLGetStmtOption(SQLHSTMT StatementHandle,
					 SQLUSMALLINT Option, SQLPOINTER Value);

39) SQLRETURN  SQL_API SQLGetTypeInfo(SQLHSTMT StatementHandle,
					 SQLSMALLINT DataType);

40) SQLRETURN  SQL_API SQLNumResultCols(SQLHSTMT StatementHandle,
					 SQLSMALLINT *ColumnCount);

41) SQLRETURN  SQL_API SQLParamData(SQLHSTMT StatementHandle,
					 SQLPOINTER *Value);

42) SQLRETURN  SQL_API SQLPrepare(SQLHSTMT StatementHandle,
					 SQLCHAR *StatementText, SQLINTEGER TextLength);

43) SQLRETURN  SQL_API SQLPutData(SQLHSTMT StatementHandle,
					 SQLPOINTER Data, SQLINTEGER StrLen_or_Ind);

44) SQLRETURN  SQL_API SQLRowCount(SQLHSTMT StatementHandle,
		 SQLINTEGER *RowCount);

45) SQLRETURN  SQL_API SQLSetConnectAttr(SQLHDBC ConnectionHandle,
					 SQLINTEGER Attribute, SQLPOINTER Value,
					 SQLINTEGER StringLength);

46) SQLRETURN  SQL_API SQLSetConnectOption(SQLHDBC ConnectionHandle,
					 SQLUSMALLINT Option, SQLUINTEGER Value);

47) SQLRETURN  SQL_API SQLSetCursorName(SQLHSTMT StatementHandle,
					 SQLCHAR *CursorName, SQLSMALLINT NameLength);

48) SQLRETURN  SQL_API SQLSetDescField(SQLHDESC DescriptorHandle,
					 SQLSMALLINT RecNumber, SQLSMALLINT FieldIdentifier,
					 SQLPOINTER Value, SQLINTEGER BufferLength);

49) SQLRETURN  SQL_API SQLSetDescRec(SQLHDESC DescriptorHandle,
					 SQLSMALLINT RecNumber, SQLSMALLINT Type,
					 SQLSMALLINT SubType, SQLINTEGER Length,
					 SQLSMALLINT Precision, SQLSMALLINT Scale,
					 SQLPOINTER Data, SQLINTEGER *StringLength,
					 SQLINTEGER *Indicator);

50) SQLRETURN  SQL_API SQLSetEnvAttr(SQLHENV EnvironmentHandle,
					 SQLINTEGER Attribute, SQLPOINTER Value,
					 SQLINTEGER StringLength);

51) SQLRETURN  SQL_API SQLSetParam(SQLHSTMT StatementHandle,
					 SQLUSMALLINT ParameterNumber, SQLSMALLINT ValueType,
					 SQLSMALLINT ParameterType, SQLUINTEGER LengthPrecision,
					 SQLSMALLINT ParameterScale, SQLPOINTER ParameterValue,
					 SQLINTEGER *StrLen_or_Ind);

52) SQLRETURN  SQL_API SQLSetStmtAttr(SQLHSTMT StatementHandle,
					 SQLINTEGER Attribute, SQLPOINTER Value,
					 SQLINTEGER StringLength);

53) SQLRETURN  SQL_API SQLSetStmtOption(SQLHSTMT StatementHandle,
					 SQLUSMALLINT Option, SQLUINTEGER Value);

54) SQLRETURN  SQL_API SQLSpecialColumns(SQLHSTMT StatementHandle,
					 SQLUSMALLINT IdentifierType, SQLCHAR *CatalogName,
					 SQLSMALLINT NameLength1, SQLCHAR *SchemaName,
					 SQLSMALLINT NameLength2, SQLCHAR *TableName,
					 SQLSMALLINT NameLength3, SQLUSMALLINT Scope,
					 SQLUSMALLINT Nullable);

55) SQLRETURN  SQL_API SQLStatistics(SQLHSTMT StatementHandle,
					 SQLCHAR *CatalogName, SQLSMALLINT NameLength1,
					 SQLCHAR *SchemaName, SQLSMALLINT NameLength2,
					 SQLCHAR *TableName, SQLSMALLINT NameLength3,
					 SQLUSMALLINT Unique, SQLUSMALLINT Reserved);

56) SQLRETURN  SQL_API SQLTables(SQLHSTMT StatementHandle,
					 SQLCHAR *CatalogName, SQLSMALLINT NameLength1,
					 SQLCHAR *SchemaName, SQLSMALLINT NameLength2,
					 SQLCHAR *TableName, SQLSMALLINT NameLength3,
					 SQLCHAR *TableType, SQLSMALLINT NameLength4);

57) SQLRETURN  SQL_API SQLTransact(SQLHENV EnvironmentHandle,
					 SQLHDBC ConnectionHandle, SQLUSMALLINT CompletionType);

}

type

{ 01 - ODBC 1.0, deprecated }
	TSQLAllocConnectProc = function( EnvironmentHandle: SQLHENV;
		var ConnectionHandle: SQLHDBC ): SQLRETURN; stdcall;

{ 02 - ODBC 1.0, deprecated }
	TSQLAllocEnvProc = function( var EnvironmentHandle: SQLHENV ):
		SQLRETURN; stdcall;

{ 03 - ODBC 3.0, ISO92 }
	TSQLAllocHandleProc = function( HandleType: SQLSMALLINT;
		InputHandle: SQLHANDLE; var OutputHandle: SQLHANDLE ): SQLRETURN; stdcall;

{ 04 - ODBC 1.0, deprecated }
	TSQLAllocStmtProc = function( ConnectionHandle: SQLHDBC;
		var StatementHandle: SQLHSTMT ): SQLRETURN; stdcall;

{ 05 - ODBC 1.0, ISO92 }
	TSQLBindColProc = function( StatementHandle: SQLHSTMT;
		ColumnNumber: SQLUSMALLINT; TargetType: SQLSMALLINT;
		TargetValue: SQLPOINTER; BufferLength: SQLINTEGER;
		var StrLen_or_Ind: SQLINTEGER ): SQLRETURN; stdcall;

{ 06 - ODBC 2.0, ODBC }
	TSQLBindParamProc = function( StatementHandle: SQLHSTMT;
		ParameterNumber: SQLUSMALLINT; ValueType: SQLSMALLINT;
		ParameterType: SQLSMALLINT; LengthPrecision: SQLUINTEGER;
		ParameterScale: SQLSMALLINT; ParameterValue: SQLPOINTER;
		var StrLen_or_Ind: SQLINTEGER ): SQLRETURN; stdcall;

{ 07 - ODBC 1.0, ISO92 }
	TSQLCancelProc = function( StatementHandle: SQLHSTMT ): SQLRETURN; stdcall;

{ 08 - ODBC 3.0, ISO92 }
	TSQLCloseCursorProc = function( StatementHandle: SQLHSTMT ): SQLRETURN; stdcall;

{ 09 - ODBC 3.0, ISO92 }
	TSQLColAttributeProc = function( StatementHandle: SQLHSTMT;	ColumnNumber,
		FieldIdentifier: SQLUSMALLINT; CharacterAttribute: SQLPOINTER;
		BufferLength: SQLSMALLINT; var StringLength: SQLSMALLINT;
		NumericAttribute: SQLPOINTER ):	SQLRETURN; stdcall;

{ 10 - ODBC 1.0, X/Open }
	TSQLColumnsProc = function( StatementHandle: SQLHSTMT; CatalogName: PCHAR;
		NameLength1: SQLSMALLINT; SchemaName: PCHAR; NameLength2: SQLSMALLINT;
		TableName: PCHAR; NameLength3: SQLSMALLINT; ColumnName: PCHAR;
		NameLength4: SQLSMALLINT ):	SQLRETURN; stdcall;

{ 11 - ODBC 1.0, ISO92 }
	TSQLConnectProc = function( ConnectionHandle: SQLHDBC; ServerName: PCHAR;
		NameLength1: SQLSMALLINT; UserName: PCHAR; NameLength2: SQLSMALLINT;
		Authentication: PCHAR; NameLength3: SQLSMALLINT ):	SQLRETURN; stdcall;

{ 12 - ODBC 3.0, ISO92 }
	TSQLCopyDescProc = function( SourceDescHandle: SQLHDESC;
		TargetDescHandle: SQLHDESC ):	SQLRETURN; stdcall;

{ 13 - ODBC 1.0, ISO92 }
	TSQLDataSourcesProc = function( EnvironmentHandle: SQLHENV;
		Direction: SQLUSMALLINT; ServerName: PCHAR;
		BufferLength1: SQLSMALLINT; var NameLength1: SQLSMALLINT;
		Description: PCHAR; BufferLength2: SQLSMALLINT;
		var NameLength2: SQLSMALLINT ):	SQLRETURN; stdcall;

{ 14 - ODBC 1.0, ISO92 }
	TSQLDescribeColProc = function( StatementHandle: SQLHSTMT;
		ColumnNumber: SQLUSMALLINT; ColumnName: PCHAR;
		BufferLength: SQLSMALLINT; var NameLength, DataType: SQLSMALLINT;
		var ColumnSize: SQLUINTEGER; var DecimalDigits,
		Nullable: SQLSMALLINT ):	SQLRETURN; stdcall;

{ 15 - ODBC 1.0, ISO92 }
	TSQLDisconnectProc = function( ConnectionHandle: SQLHDBC ):	SQLRETURN;
		stdcall;

{ 16 - ODBC 3.0, ISO92 }
	TSQLEndTranProc = function( HandleType: SQLSMALLINT; Handle: SQLHANDLE;
		CompletionType: SQLSMALLINT ):	SQLRETURN; stdcall;

{ 17 - ODBC 1.0, deprecated }
	TSQLErrorProc = function( EnvironmentHandle: SQLHENV;
		ConnectionHandle: SQLHDBC; StatementHandle: SQLHSTMT;
		Sqlstate: PCHAR; var NativeError: SQLINTEGER; MessageText: PCHAR;
		BufferLength: SQLSMALLINT; var TextLength: SQLSMALLINT ):	SQLRETURN;
		stdcall;

{ 18 - ODBC 1.0, ISO92 }
	TSQLExecDirectProc = function( StatementHandle: SQLHSTMT;
		StatementText: PCHAR; TextLength: SQLINTEGER ):	SQLRETURN; stdcall;

{ 19 - ODBC 1.0, ISO92 }
	TSQLExecuteProc = function( StatementHandle: SQLHSTMT ): SQLRETURN; stdcall;

{ 20 - ODBC 1.0, ISO92 }
	TSQLFetchProc = function( StatementHandle: SQLHSTMT ): SQLRETURN; stdcall;

{ 21 - ODBC 3.0, ISO92 }
	TSQLFetchScrollProc = function( StatementHandle: SQLHSTMT;
		FetchOrientation: SQLSMALLINT; FetchOffset: SQLINTEGER ): SQLRETURN;
		stdcall;

{ 22 - ODBC 1.0, deprecated }
	TSQLFreeConnectProc = function( ConnectionHandle: SQLHDBC ): SQLRETURN;	stdcall;

{ 23 - ODBC 1.0, deprecated }
	TSQLFreeEnvProc = function( EnvironmentHandle: SQLHENV ): SQLRETURN; stdcall;

{ 24 - ODBC 3.0, ISO92 }
	TSQLFreeHandleProc = function( HandleType: SQLSMALLINT;	Handle: SQLHANDLE ):
		SQLRETURN; stdcall;

{ 25 - ODBC 1.0, ISO92 }
	TSQLFreeStmtProc = function( StatementHandle: SQLHSTMT;
		Option: SQLUSMALLINT ):	SQLRETURN; stdcall;

{ 26 - ODBC 3.0, ISO92 }
	TSQLGetConnectAttrProc = function( ConnectionHandle: SQLHDBC;
		Attribute: SQLINTEGER; Value: SQLPOINTER;	BufferLength: SQLINTEGER;
		var StringLength: SQLINTEGER ):	SQLRETURN; stdcall;

{ 27 - ODBC 1.0, deprecated }
	TSQLGetConnectOptionProc = function( ConnectionHandle: SQLHDBC;
		Option: SQLUSMALLINT; Value: SQLPOINTER ):	SQLRETURN; stdcall;

{ 28 - ODBC 1.0, ISO92 }
	TSQLGetCursorNameProc = function( StatementHandle: SQLHSTMT;
		CursorName: PCHAR; BufferLength: SQLSMALLINT;
		var NameLength: SQLSMALLINT ): SQLRETURN; stdcall;

{ 29 - ODBC 1.0, ISO92 }
	TSQLGetDataProc = function( StatementHandle: SQLHSTMT;
		ColumnNumber, TargetType: SQLSMALLINT; TargetValue: SQLPOINTER;
		BufferLength: SQLINTEGER; var StrLen_or_Ind: SQLINTEGER ): SQLRETURN; stdcall;

{ 30 - ODBC 3.0, ISO92 }
	TSQLGetDescFieldProc = function( DescriptorHandle: SQLHDESC;
		RecNumber, FieldIdentifier: SQLSMALLINT; Value: SQLPOINTER;
		BufferLength: SQLINTEGER; var StringLength: SQLINTEGER ):	SQLRETURN; stdcall;

{ 31 - ODBC 3.0, ISO92 }
	TSQLGetDescRecProc = function( DescriptorHandle: SQLHDESC;
		RecNumber: SQLSMALLINT; Name: PCHAR; BufferLength: SQLSMALLINT;
		var StringLength, pType, SubType: SQLSMALLINT; var Length: SQLINTEGER;
		var Precision, Scale, Nullable: SQLSMALLINT ): SQLRETURN; stdcall;

{ 32 - ODBC 3.0, ISO92 }
	TSQLGetDiagFieldProc = function( HandleType: SQLSMALLINT; Handle: SQLHANDLE;
		RecNumber, DiagIdentifier: SQLSMALLINT; DiagInfo: SQLPOINTER;
		BufferLength: SQLSMALLINT; var StringLength: SQLSMALLINT ):	SQLRETURN; stdcall;

{ 33 - ODBC 3.0, ISO92 }
	TSQLGetDiagRecProc = function( HandleType: SQLSMALLINT; Handle: SQLHANDLE;
		RecNumber: SQLSMALLINT; Sqlstate: PCHAR; var NativeError: SQLINTEGER;
		MessageText: PCHAR; BufferLength: SQLSMALLINT;
		var TextLength: SQLSMALLINT ): SQLRETURN; stdcall;

{ 34 - ODBC 3.0, ISO92 }
	TSQLGetEnvAttrProc = function( EnvironmentHandle: SQLHENV;
		Attribute: SQLINTEGER; Value: SQLPOINTER; BufferLength: SQLINTEGER;
		var StringLength: SQLINTEGER ): SQLRETURN; stdcall;

{ 35 - ODBC 1.0, ISO92 }
	TSQLGetFunctionsProc = function( ConnectionHandle: SQLHDBC;
		FunctionId: SQLUSMALLINT; var Supported: SQLUSMALLINT ): SQLRETURN; stdcall;

{ 36 - ODBC 1.0, ISO92 }
	TSQLGetInfoProc = function( ConnectionHandle: SQLHDBC;
		InfoType: SQLUSMALLINT; InfoValue: SQLPOINTER;
		BufferLength: SQLSMALLINT; var StringLength: SQLSMALLINT ): SQLRETURN; stdcall;

{ 37 - ODBC 3.0, ISO92 }
	TSQLGetStmtAttrProc = function( StatementHandle: SQLHSTMT;
		Attribute: SQLINTEGER; Value: SQLPOINTER; BufferLength: SQLINTEGER;
		var StringLength: SQLINTEGER ): SQLRETURN; stdcall;

{ 38 - ODBC 1.0, deprecated }
	TSQLGetStmtOptionProc = function( StatementHandle: SQLHSTMT;
		Option: SQLUSMALLINT; Value: SQLPOINTER ): SQLRETURN; stdcall;

{ 39 - ODBC 1.0, ISO92 }
	TSQLGetTypeInfoProc = function( StatementHandle: SQLHSTMT;
		DataType: SQLSMALLINT ): SQLRETURN; stdcall;

{ 40 - ODBC 1.0, ISO92 }
	TSQLNumResultColsProc = function( StatementHandle: SQLHSTMT;
		var ColumnCount: SQLSMALLINT ): SQLRETURN; stdcall;

{ 41 - ODBC 1.0, ISO92 }
	TSQLParamDataProc = function( StatementHandle: SQLHSTMT;
		var Value: SQLPOINTER ): SQLRETURN; stdcall;

{ 42 - ODBC 1.0, ISO92 }
	TSQLPrepareProc = function( StatementHandle: SQLHSTMT;
		StatementText: PCHAR; TextLength: SQLINTEGER ): SQLRETURN; stdcall;

{ 43 - ODBC 1.0, ISO92 }
	TSQLPutDataProc = function( StatementHandle: SQLHSTMT;
		Data: SQLPOINTER; StrLen_or_Ind: SQLINTEGER ): SQLRETURN; stdcall;

{ 44 - ODBC 1.0, ISO92 }
	TSQLRowCountProc = function( StatementHandle: SQLHSTMT;
		 var RowCount: SQLINTEGER ): SQLRETURN; stdcall;

{ 45 - ODBC 3.0, ISO92 }
	TSQLSetConnectAttrProc = function( ConnectionHandle: SQLHDBC;
		Attribute: SQLINTEGER; Value: SQLPOINTER;
		StringLength: SQLINTEGER ): SQLRETURN; stdcall;

{ 46 - ODBC 1.0, deprecated }
	TSQLSetConnectOptionProc = function( ConnectionHandle: SQLHDBC;
		Option: SQLUSMALLINT; Value: SQLUINTEGER ): SQLRETURN; stdcall;

{ 47 - ODBC 1.0, ISO92 }
	TSQLSetCursorNameProc = function( StatementHandle: SQLHSTMT;
		CursorName: PCHAR; NameLength: SQLSMALLINT ): SQLRETURN; stdcall;

{ 48 - ODBC 3.0, ISO92 }
	TSQLSetDescFieldProc = function( DescriptorHandle: SQLHDESC;
		RecNumber, FieldIdentifier: SQLSMALLINT; Value: SQLPOINTER;
		BufferLength: SQLINTEGER ): SQLRETURN; stdcall;

{ 49 - ODBC 3.0, ISO92 }
	TSQLSetDescRecProc = function( DescriptorHandle: SQLHDESC;
		RecNumber, pType, SubType: SQLSMALLINT; Length: SQLINTEGER;
		Precision, Scale: SQLSMALLINT; Data: SQLPOINTER;
		var StringLength, Indicator: SQLINTEGER ): SQLRETURN; stdcall;

{ 50 - ODBC 3.0, ISO92 }
	TSQLSetEnvAttrProc = function( EnvironmentHandle: SQLHENV;
		Attribute: SQLINTEGER; Value: SQLPOINTER;
		StringLength: SQLINTEGER ): SQLRETURN; stdcall;

{ 51 - ODBC 1.0, deprecated }
	TSQLSetParamProc = function( StatementHandle: SQLHSTMT;
		ParameterNumber: SQLUSMALLINT; ValueType, ParameterType: SQLSMALLINT;
		LengthPrecision: SQLUINTEGER; ParameterScale: SQLSMALLINT;
		ParameterValue: SQLPOINTER; var StrLen_or_Ind: SQLINTEGER ): SQLRETURN; stdcall;

{ 52 - ODBC 3.0, ISO92 }
	TSQLSetStmtAttrProc = function( StatementHandle: SQLHSTMT;
		Attribute: SQLINTEGER; Value: SQLPOINTER;
		StringLength: SQLINTEGER ): SQLRETURN; stdcall;

{ 53 - ODBC 1.0, deprecated }
	TSQLSetStmtOptionProc = function( StatementHandle: SQLHSTMT;
		Option: SQLUSMALLINT; Value: SQLUINTEGER ): SQLRETURN; stdcall;

{ 54 - ODBC 1.0, X/Open }
	TSQLSpecialColumnsProc = function( StatementHandle: SQLHSTMT;
		IdentifierType: SQLUSMALLINT; CatalogName: PCHAR;
		NameLength1: SQLSMALLINT; SchemaName: PCHAR;
		NameLength2: SQLSMALLINT; TableName: PCHAR;
		NameLength3: SQLSMALLINT; Scope, Nullable: SQLUSMALLINT ): SQLRETURN; stdcall;

{ 55 - ODBC 1.0, ISO92 }
	TSQLStatisticsProc = function( StatementHandle: SQLHSTMT;
		CatalogName: PCHAR; NameLength1: SQLSMALLINT;
		SchemaName: PCHAR; NameLength2: SQLSMALLINT;
		TableName: PCHAR; NameLength3: SQLSMALLINT;
		Unique, Reserved: SQLUSMALLINT ): SQLRETURN; stdcall;

{ 56 - ODBC 1.0, X/Open }
	TSQLTablesProc = function( StatementHandle: SQLHSTMT;
		CatalogName: PCHAR; NameLength1: SQLSMALLINT;
		SchemaName: PCHAR; NameLength2: SQLSMALLINT;
		TableName: PCHAR; NameLength3: SQLSMALLINT;
		TableType: PCHAR; NameLength4: SQLSMALLINT ): SQLRETURN; stdcall;

{ 57 - ODBC 1.0, deprecated }
	TSQLTransactProc = function( EnvironmentHandle: SQLHENV;
		ConnectionHandle: SQLHDBC; CompletionType: SQLUSMALLINT ): SQLRETURN; stdcall;

{
	ODBC Mappings: Extended ODBC Functions

	Header files translated from SQLExt.h

01) SQLRETURN SQL_API SQLDriverConnect(
		SQLHDBC            hdbc,
		SQLHWND            hwnd,
		SQLCHAR 		  *szConnStrIn,
		SQLSMALLINT        cbConnStrIn,
		SQLCHAR           *szConnStrOut,
		SQLSMALLINT        cbConnStrOutMax,
		SQLSMALLINT 	  *pcbConnStrOut,
		SQLUSMALLINT       fDriverCompletion);

02) SQLRETURN SQL_API SQLBrowseConnect(
		SQLHDBC            hdbc,
		SQLCHAR 		  *szConnStrIn,
		SQLSMALLINT        cbConnStrIn,
		SQLCHAR 		  *szConnStrOut,
		SQLSMALLINT        cbConnStrOutMax,
		SQLSMALLINT       *pcbConnStrOut);

03) SQLRETURN	SQL_API	SQLBulkOperations(
	SQLHSTMT			StatementHandle,
	SQLSMALLINT			Operation);

04) SQLRETURN SQL_API SQLColAttributes(
		SQLHSTMT           hstmt,
		SQLUSMALLINT       icol,
		SQLUSMALLINT       fDescType,
		SQLPOINTER         rgbDesc,
		SQLSMALLINT        cbDescMax,
		SQLSMALLINT 	  *pcbDesc,
		SQLINTEGER 		  *pfDesc);

05) SQLRETURN SQL_API SQLColumnPrivileges(
		SQLHSTMT           hstmt,
		SQLCHAR 		  *szCatalogName,
		SQLSMALLINT        cbCatalogName,
		SQLCHAR 		  *szSchemaName,
		SQLSMALLINT        cbSchemaName,
		SQLCHAR 		  *szTableName,
		SQLSMALLINT        cbTableName,
		SQLCHAR 		  *szColumnName,
		SQLSMALLINT        cbColumnName);

06) SQLRETURN SQL_API SQLDescribeParam(
		SQLHSTMT           hstmt,
		SQLUSMALLINT       ipar,
		SQLSMALLINT 	  *pfSqlType,
		SQLUINTEGER 	  *pcbParamDef,
		SQLSMALLINT 	  *pibScale,
		SQLSMALLINT 	  *pfNullable);

07) SQLRETURN SQL_API SQLExtendedFetch(
		SQLHSTMT           hstmt,
		SQLUSMALLINT       fFetchType,
		SQLINTEGER         irow,
		SQLUINTEGER 	  *pcrow,
		SQLUSMALLINT 	  *rgfRowStatus);

08) SQLRETURN SQL_API SQLForeignKeys(
		SQLHSTMT           hstmt,
		SQLCHAR 		  *szPkCatalogName,
		SQLSMALLINT        cbPkCatalogName,
		SQLCHAR 		  *szPkSchemaName,
		SQLSMALLINT        cbPkSchemaName,
		SQLCHAR 		  *szPkTableName,
		SQLSMALLINT        cbPkTableName,
		SQLCHAR 		  *szFkCatalogName,
		SQLSMALLINT        cbFkCatalogName,
		SQLCHAR 		  *szFkSchemaName,
		SQLSMALLINT        cbFkSchemaName,
		SQLCHAR 		  *szFkTableName,
		SQLSMALLINT        cbFkTableName);

09) SQLRETURN SQL_API SQLMoreResults(
		SQLHSTMT           hstmt);

10) SQLRETURN SQL_API SQLNativeSql(
		SQLHDBC            hdbc,
		SQLCHAR 		  *szSqlStrIn,
		SQLINTEGER         cbSqlStrIn,
		SQLCHAR 		  *szSqlStr,
		SQLINTEGER         cbSqlStrMax,
		SQLINTEGER 		  *pcbSqlStr);

11) SQLRETURN SQL_API SQLNumParams(
		SQLHSTMT           hstmt,
		SQLSMALLINT 	  *pcpar);

12) SQLRETURN SQL_API SQLParamOptions(
		SQLHSTMT           hstmt,
		SQLUINTEGER        crow,
		SQLUINTEGER 	  *pirow);

13) SQLRETURN SQL_API SQLPrimaryKeys(
		SQLHSTMT           hstmt,
		SQLCHAR 		  *szCatalogName,
		SQLSMALLINT        cbCatalogName,
		SQLCHAR 		  *szSchemaName,
		SQLSMALLINT        cbSchemaName,
		SQLCHAR 		  *szTableName,
		SQLSMALLINT        cbTableName);

14) SQLRETURN SQL_API SQLProcedureColumns(
		SQLHSTMT           hstmt,
		SQLCHAR 		  *szCatalogName,
		SQLSMALLINT        cbCatalogName,
		SQLCHAR 		  *szSchemaName,
		SQLSMALLINT        cbSchemaName,
		SQLCHAR 		  *szProcName,
		SQLSMALLINT        cbProcName,
		SQLCHAR 		  *szColumnName,
		SQLSMALLINT        cbColumnName);

15) SQLRETURN SQL_API SQLProcedures(
		SQLHSTMT           hstmt,
		SQLCHAR 		  *szCatalogName,
		SQLSMALLINT        cbCatalogName,
		SQLCHAR 		  *szSchemaName,
		SQLSMALLINT        cbSchemaName,
		SQLCHAR 		  *szProcName,
		SQLSMALLINT        cbProcName);

16) SQLRETURN SQL_API SQLSetPos(
		SQLHSTMT           hstmt,
		SQLUSMALLINT       irow,
		SQLUSMALLINT       fOption,
		SQLUSMALLINT       fLock);

17) SQLRETURN SQL_API SQLTablePrivileges(
		SQLHSTMT           hstmt,
		SQLCHAR 		  *szCatalogName,
		SQLSMALLINT        cbCatalogName,
		SQLCHAR 		  *szSchemaName,
		SQLSMALLINT        cbSchemaName,
		SQLCHAR 		  *szTableName,
		SQLSMALLINT        cbTableName);

18) SQLRETURN SQL_API SQLDrivers(
		SQLHENV            henv,
		SQLUSMALLINT       fDirection,
		SQLCHAR 		  *szDriverDesc,
		SQLSMALLINT        cbDriverDescMax,
		SQLSMALLINT 	  *pcbDriverDesc,
		SQLCHAR 		  *szDriverAttributes,
		SQLSMALLINT        cbDrvrAttrMax,
		SQLSMALLINT 	  *pcbDrvrAttr);

19) SQLRETURN SQL_API SQLBindParameter(
		SQLHSTMT           hstmt,
		SQLUSMALLINT       ipar,
		SQLSMALLINT        fParamType,
		SQLSMALLINT        fCType,
		SQLSMALLINT        fSqlType,
		SQLUINTEGER        cbColDef,
		SQLSMALLINT        ibScale,
		SQLPOINTER         rgbValue,
		SQLINTEGER         cbValueMax,
		SQLINTEGER 		  *pcbValue);


20) SQLRETURN SQL_API SQLAllocHandleStd(
	SQLSMALLINT		fHandleType,
	SQLHANDLE		hInput,
	SQLHANDLE	   *phOutput);

21) SQLRETURN SQL_API SQLSetScrollOptions(    (*      Use SQLSetStmtOptions *)
		SQLHSTMT           hstmt,
		SQLUSMALLINT       fConcurrency,
		SQLINTEGER         crowKeyset,
		SQLUSMALLINT       crowRowset);

// Trace Section

22) RETCODE	SQL_API TraceOpenLogFile(LPWSTR,LPWSTR,DWORD);// open a trace log file
23) RETCODE	SQL_API TraceCloseLogFile();			// Request to close a trace log
24) VOID	SQL_API TraceReturn(RETCODE,RETCODE);	// Processes trace after FN is called
25) DWORD	SQL_API TraceVersion();					// Returns trace API version

}

type

{01 - ODBC 1.0, ODBC }
{	TSQLDriverConnectProc = function( hdbc: SQLHDBC; hwnd: SQLHWND;
		szConnStrIn: PCHAR; cbConnStrIn: SQLSMALLINT; szConnStrOut: PCHAR;
		cbConnStrOutMax: SQLSMALLINT;	var pcbConnStrOut: SQLSMALLINT;
		fDriverCompletion: SQLUSMALLINT ): SQLRETURN; stdcall; }

{02 - ODBC 1.0, ODBC }
	TSQLBrowseConnectProc = function( hdbc: SQLHDBC; szConnStrIn: PCHAR;
		cbConnStrIn: SQLSMALLINT; szConnStrOut: PCHAR;
		cbConnStrOutMax: SQLSMALLINT; var pcbConnStrOut: SQLSMALLINT ):
		SQLRETURN; stdcall;

{03 - ODBC 3.0, ODBC }
	TSQLBulkOperationsProc = function( StatementHandle: SQLHSTMT;
		Operation: SQLSMALLINT ): SQLRETURN; stdcall;

{04 - ODBC 1.0, deprecated }
	TSQLColAttributesProc = function( hstmt: SQLHSTMT; icol,
		fDescType: SQLUSMALLINT; rgbDesc: SQLPOINTER; cbDescMax: SQLSMALLINT;
		var pcbDesc: SQLSMALLINT; var pfDesc: SQLINTEGER ): SQLRETURN; stdcall;

{05 - ODBC 1.0, ODBC }
	TSQLColumnPrivilegesProc = function( hstmt: SQLHSTMT;
		szCatalogName: PCHAR; cbCatalogName: SQLSMALLINT; szSchemaName: PCHAR;
		cbSchemaName: SQLSMALLINT; szTableName: PCHAR;
		cbTableName: SQLSMALLINT; szColumnName: PCHAR;
		cbColumnName: SQLSMALLINT ): SQLRETURN; stdcall;

{06 - ODBC 1.0, ODBC }
	TSQLDescribeParamProc = function( hstmt: SQLHSTMT; ipar: SQLUSMALLINT;
		var pfSqlType: SQLSMALLINT; var pcbParamDef: SQLUINTEGER;
		var pibScale, pfNullable: SQLSMALLINT ): SQLRETURN; stdcall;

{07 - ODBC 1.0, deprecated }
	TSQLExtendedFetchProc = function( hstmt: SQLHSTMT;
		fFetchType: SQLUSMALLINT; irow: SQLINTEGER;	var pcrow: SQLUINTEGER;
		var rgfRowStatus: SQLUSMALLINT ): SQLRETURN; stdcall;

{08 - ODBC 1.0, ODBC }
	TSQLForeignKeysProc = function( hstmt: SQLHSTMT; szPkCatalogName: PCHAR;
		cbPkCatalogName: SQLSMALLINT; szPkSchemaName: PCHAR;
		cbPkSchemaName: SQLSMALLINT; szPkTableName: PCHAR;
		cbPkTableName: SQLSMALLINT; szFkCatalogName: PCHAR;
		cbFkCatalogName: SQLSMALLINT; szFkSchemaName: PCHAR;
		cbFkSchemaName: SQLSMALLINT; szFkTableName: PCHAR;
		cbFkTableName: SQLSMALLINT ): SQLRETURN; stdcall;

{09 - ODBC 1.0, ODBC }
	TSQLMoreResultsProc = function( hstmt: SQLHSTMT ): SQLRETURN; stdcall;

{10 - ODBC 1.0, ODBC }
	TSQLNativeSqlProc = function( hdbc: SQLHDBC; szSqlStrIn: PCHAR;
		cbSqlStrIn: SQLINTEGER; szSqlStr: PCHAR; cbSqlStrMax: SQLINTEGER;
		var pcbSqlStr: SQLINTEGER ): SQLRETURN; stdcall;

{11 - ODBC 1.0, ISO92 }
	TSQLNumParamsProc = function( hstmt: SQLHSTMT;
		var pcpar: SQLSMALLINT ): SQLRETURN; stdcall;

{12 - ODBC 1.0, deprecated }
	TSQLParamOptionsProc = function( hstmt: SQLHSTMT; crow: SQLUINTEGER;
		var pirow: SQLUINTEGER ): SQLRETURN; stdcall;

{13 - ODBC 1.0, ODBC }
	TSQLPrimaryKeysProc = function( hstmt: SQLHSTMT; szCatalogName: PCHAR;
		cbCatalogName: SQLSMALLINT; szSchemaName: PCHAR;
		cbSchemaName: SQLSMALLINT; szTableName: PCHAR;
		cbTableName: SQLSMALLINT ): SQLRETURN; stdcall;

{14 - ODBC 1.0, ODBC }
	TSQLProcedureColumnsProc = function( hstmt: SQLHSTMT;
		szCatalogName: PCHAR; cbCatalogName: SQLSMALLINT; szSchemaName: PCHAR;
		cbSchemaName: SQLSMALLINT; szProcName: PCHAR; cbProcName: SQLSMALLINT;
		szColumnName: PCHAR; cbColumnName: SQLSMALLINT ): SQLRETURN; stdcall;

{15 - ODBC 1.0, ODBC }
	TSQLProceduresProc = function( hstmt: SQLHSTMT; szCatalogName: PCHAR;
		cbCatalogName: SQLSMALLINT; szSchemaName: PCHAR;
		cbSchemaName: SQLSMALLINT; szProcName: PCHAR;
		cbProcName: SQLSMALLINT ): SQLRETURN; stdcall;

{16 - ODBC 1.0, ODBC }
	TSQLSetPosProc = function( hstmt: SQLHSTMT; irow, fOption,
		fLock: SQLUSMALLINT ): SQLRETURN; stdcall;

{17 - ODBC 1.0, ODBC }
	TSQLTablePrivilegesProc = function( hstmt: SQLHSTMT;
		szCatalogName: PCHAR; cbCatalogName: SQLSMALLINT; szSchemaName: PCHAR;
		cbSchemaName: SQLSMALLINT; szTableName: PCHAR;
		cbTableName: SQLSMALLINT ): SQLRETURN; stdcall;

{18 - ODBC 2.0, ODBC }
	TSQLDriversProc = function( henv: SQLHENV; fDirection: SQLUSMALLINT;
		szDriverDesc: PCHAR; cbDriverDescMax:	SQLSMALLINT;
		var pcbDriverDesc: SQLSMALLINT; szDriverAttributes: PCHAR;
		cbDrvrAttrMax: SQLSMALLINT;
		var pcbDrvrAttr: SQLSMALLINT ): SQLRETURN; stdcall;

{19 - ODBC 2.0, ODBC }
	TSQLBindParameterProc = function( hstmt: SQLHSTMT; ipar,
		fParamType, fCType, fSqlType: SQLSMALLINT; cbColDef: SQLUINTEGER;
		ibScale: SQLSMALLINT; rgbValue: SQLPOINTER; cbValueMax: SQLINTEGER;
		var pcbValue: SQLINTEGER ): SQLRETURN; stdcall;

{20 - ODBC 3.0, ISO92 }
	TSQLAllocHandleStdProc = function( fHandleType: SQLSMALLINT;
		hInput: SQLHANDLE; var phOutput: SQLHANDLE ): SQLRETURN; stdcall;

{21 - ODBC 1.0, deprecated }
(* Use SQLSetStmtOptions *)
	TSQLSetScrollOptionsProc = function( hstmt: SQLHSTMT;
		fConcurrency: SQLUSMALLINT; crowKeyset:	SQLINTEGER;
		crowRowset: SQLUSMALLINT ): SQLRETURN; stdcall;

(*

	Don't know what to do with this trace section yet...
	----------------------------------------------------

// Trace Section

{22}
	TTraceOpenLogFileProc(LPWSTR,LPWSTR,DWORD): RETCODE; stdcall// open a trace log file

{23}
	TTraceCloseLogFileProc = function: RETCODE; stdcall;			// Request to close a trace log

{24}
	TTraceReturnProc = procedure(RETCODE,RETCODE);	stdcall; // Processes trace after FN is called

{25}
	TTraceVersionProc = function: DWORD; stdcall;					// Returns trace API version

*)

{
	ODBC Mappings: ODBC Core Functions

	Header files translated from SQLExt.h

}

{
	ODBC Mappings: Installer DLL Mappings

	Header files translated from ODBCInst.h

	Technical Note:
	---------------
		The header files translated so far do not include the UNICODE
		versions prototypes of the function prototypes. The low level
		prototypes imported are used just for compatibility. Higher
		level functions should be used instead.


	High Level API:
	---------------

01)	BOOL INSTAPI SQLInstallODBC( HWND hwndParent, LPCSTR lpszInfFile,
			LPCSTR lpszSrcPath, LPCSTR lpszDrivers );

02)	BOOL INSTAPI SQLManageDataSources( HWND hwndParent );

03)	BOOL INSTAPI SQLCreateDataSource( HWND hwndParent, LPCSTR lpszDSN );

04)	BOOL INSTAPI SQLGetTranslator( HWND hwnd, LPSTR lpszName,
			WORD cbNameMax, WORD* pcbNameOut, LPSTR lpszPath, WORD cbPathMax,
			WORD* pcbPathOut, DWORD* pvOption );


	Low Level API:
	--------------

05)	BOOL INSTAPI SQLInstallDriver( LPCSTR lpszInfFile, LPCSTR lpszDriver,
			LPSTR lpszPath, WORD cbPathMax, WORD* pcbPathOut );

06)	BOOL INSTAPI SQLInstallDriverManager( LPSTR lpszPath, WORD cbPathMax,
			WORD* pcbPathOut );

07)	BOOL INSTAPI SQLGetInstalledDrivers( LPSTR lpszBuf, WORD cbBufMax,
			WORD* pcbBufOut );

08)	BOOL INSTAPI SQLGetAvailableDrivers( LPCSTR lpszInfFile,
			LPSTR lpszBuf, WORD cbBufMax, WORD* pcbBufOut );

09)	BOOL INSTAPI SQLConfigDataSource( HWND hwndParent, WORD fRequest,
			LPCSTR lpszDriver, LPCSTR lpszAttributes );

10)	BOOL INSTAPI SQLRemoveDefaultDataSource( void );

11)	BOOL INSTAPI SQLWriteDSNToIni( LPCSTR lpszDSN, LPCSTR lpszDriver );

12)	BOOL INSTAPI SQLRemoveDSNFromIni( LPCSTR lpszDSN );

13)	BOOL INSTAPI SQLValidDSN( LPCSTR lpszDSN );

14)	BOOL INSTAPI SQLWritePrivateProfileString( LPCSTR lpszSection,
			LPCSTR lpszEntry, LPCSTR lpszString, LPCSTR lpszFilename );

15)	int INSTAPI SQLGetPrivateProfileString( LPCSTR lpszSection,
			LPCSTR lpszEntry, LPCSTR lpszDefault, LPSTR  lpszRetBuffer,
			int cbRetBuffer, LPCSTR lpszFilename );

16)	BOOL INSTAPI SQLRemoveDriverManager( LPDWORD lpdwUsageCount );

17)	BOOL INSTAPI SQLInstallTranslator( LPCSTR lpszInfFile,
			LPCSTR lpszTranslator, LPCSTR lpszPathIn, LPSTR  lpszPathOut,
			WORD cbPathOutMax, WORD* pcbPathOut, WORD	fRequest,
			LPDWORD	lpdwUsageCount );

18)	BOOL INSTAPI SQLRemoveTranslator( LPCSTR lpszTranslator,
			LPDWORD lpdwUsageCount );

19)	BOOL INSTAPI SQLRemoveDriver( LPCSTR lpszDriver, BOOL fRemoveDSN,
			LPDWORD lpdwUsageCount );

20)	BOOL INSTAPI SQLConfigDriver( HWND hwndParent, WORD fRequest,
			LPCSTR lpszDriver, LPCSTR lpszArgs, LPSTR lpszMsg, WORD cbMsgMax,
			WORD* pcbMsgOut );

21)	SQLRETURN INSTAPI SQLInstallerError( WORD iError, DWORD* pfErrorCode,
			LPSTR	lpszErrorMsg, WORD cbErrorMsgMax, WORD* pcbErrorMsg );

22)	SQLRETURN INSTAPI SQLPostInstallerError( DWORD dwErrorCode,
			LPCSTR lpszErrMsg );

23)	BOOL INSTAPI SQLWriteFileDSN( LPCSTR lpszFileName, LPCSTR lpszAppName,
			LPCSTR lpszKeyName, LPCSTR lpszString );

24)	BOOL INSTAPI  SQLReadFileDSN( LPCSTR lpszFileName, LPCSTR lpszAppName,
			LPCSTR lpszKeyName, LPSTR lpszString, WORD cbString,
			WORD* pcbString );

25)	BOOL INSTAPI SQLInstallDriverEx( LPCSTR lpszDriver, LPCSTR lpszPathIn,
			LPSTR lpszPathOut, WORD cbPathOutMax, WORD* pcbPathOut,
			WORD fRequest, LPDWORD lpdwUsageCount );

26)	BOOL INSTAPI SQLInstallTranslatorEx( LPCSTR lpszTranslator,
			LPCSTR lpszPathIn, LPSTR lpszPathOut, WORD cbPathOutMax,
			WORD* pcbPathOut, WORD fRequest, LPDWORD lpdwUsageCount );

27)	BOOL INSTAPI SQLGetConfigMode( UWORD* pwConfigMode );

28)	BOOL INSTAPI SQLSetConfigMode( UWORD wConfigMode );


	Driver specific Setup APIs called by installer:
	-----------------------------------------------

29)	BOOL INSTAPI ConfigDSN( HWND hwndParent, WORD fRequest,
			LPCSTR lpszDriver, LPCSTR lpszAttributes );

30)	BOOL INSTAPI ConfigTranslator( HWND hwndParent, DWORD* pvOption );

31)	BOOL INSTAPI ConfigDriver( HWND hwndParent, WORD fRequest,
			LPCSTR lpszDriver, LPCSTR lpszArgs, LPSTR lpszMsg, WORD cbMsgMax,
			WORD* pcbMsgOut );

}

type

{ 01 - removed as of ODBC 3.0 }
	TSQLInstallODBCProc = function( hwndParent: HWND; lpszInfFile,
		lpszSrcPath, lpszDrivers: LPCSTR ): BOOL; stdcall;

{ 02 - ODBC 2.0 }
	TSQLManageDataSourcesProc = function( hwndParent: HWND ): BOOL; stdcall;

{ 03 - ODBC 2.0 }
	TSQLCreateDataSourceProc = function( hwndParent: HWND;
		lpszDSN: LPCSTR ): BOOL; stdcall;

{ 04 - ODBC 2.0 }
	TSQLGetTranslatorProc = function( hwndParent: HWND; lpszName: LPSTR;
		cbNameMax: WORD; pcbNameOut: PWORD; lpszPath: LPSTR;
		cbPathMax: WORD; pcbPathOut: PWORD; pvOption: PDWORD ): BOOL; stdcall;

{ 05 - removed as of ODBC 3.0 }
	TSQLInstallDriverProc = function( lpszInfFile, lpszDriver,
		lpszPath: LPCSTR; cbPathMax: WORD; pcbPathOut: PWORD ): BOOL; stdcall;

{ 06 - ODBC 1.0 }
	TSQLInstallDriverManagerProc = function( lpszPath: LPSTR;
		cbPathMax: WORD; pcbPathOut: PWORD ): BOOL; stdcall;

{ 07 - ODBC 1.0 }
	TSQLGetInstalledDriversProc = function( lpszBuf: LPSTR; cbBufMax: WORD;
		pcbBufOut: PWORD ): BOOL; stdcall;

{ 08 - not found anywhere in the documentation; probably declared for
			 compatibility }
	TSQLGetAvailableDriversProc = function( lpszInfFile, lpszBuf: LPSTR;
		cbBufMax: WORD; pcbBufOut: PWORD ): BOOL; stdcall;

{ 09 - ODBC 1.0 }
	TSQLConfigDataSourceProc = function( hwndParent: HWND; fRequest: WORD;
		lpszDriver, lpszAttributes: LPCSTR ): BOOL; stdcall;

{ 10 - ODBC 1.0, deprecated }
	TSQLRemoveDefaultDataSourceProc = function: BOOL; stdcall;

{ 11 - ODBC 1.0 }
	TSQLWriteDSNToIniProc = function( lpszDSN, lpszDriver: LPCSTR ):
		BOOL; stdcall;

{ 12 - ODBC 1.0 }
	TSQLRemoveDSNFromIniProc = function( lpszDSN: LPCSTR ): BOOL; stdcall;

{ 13 - ODBC 2.0 }
	TSQLValidDSNProc = function( lpszDSN: LPCSTR ): BOOL; stdcall;

{ 14 - ODBC 2.0}
	TSQLWritePrivateProfileStringProc = function( lpszSection, lpszEntry,
		lpszString, lpszFilename: LPCSTR ): BOOL; stdcall;

{ 15 - ODBC 2.0 }
	TSQLGetPrivateProfileStringProc = function( lpszSection, lpszEntry,
		lpszDefault, lpszRetBuffer: LPCSTR; cbRetBuffer: Integer;
		lpszFilename: LPCSTR ): Integer; stdcall;

{ 16 - ODBC 3.0 }
	TSQLRemoveDriverManagerProc = function( lpdwUsageCount: LPDWORD ):
		BOOL; stdcall;

{ 17 - ODBC 2.5, deprecated }
	TSQLInstallTranslatorProc = function( lpszInfFile, lpszTranslator,
		lpszPathIn, lpszPathOut: LPSTR; cbPathOutMax: WORD;
		pcbPathOut: PWORD; fRequest: WORD; lpdwUsageCount: LPDWORD ):
		BOOL; stdcall;

{ 18 - ODBC 3.0 }
	TSQLRemoveTranslatorProc = function( lpszTranslator: LPCSTR;
		lpdwUsageCount: LPDWORD ): BOOL; stdcall;

{ 19 - ODBC 3.0 }
	TSQLRemoveDriverProc = function( lpszDriver: LPCSTR; fRemoveDSN: BOOL;
		lpdwUsageCount: LPDWORD ): BOOL; stdcall;

{ 20 - ODBC 2.5 }
	TSQLConfigDriverProc = function( hwndParent: HWND; fRequest: WORD;
		lpszDriver, lpszArgs, lpszMsg: LPSTR; cbMsgMax: WORD;
		pcbMsgOut: PWORD ): BOOL; stdcall;

{ 21 - ODBC 3.0 }
	TSQLInstallerErrorProc = function( iError: WORD; pfErrorCode: PDWORD;
		lpszErrorMsg: LPSTR; cbErrorMsgMax: WORD; pcbErrorMsg: PWORD ):
		SQLRETURN; stdcall;

{ 22 - ODBC 3.0 }
	TSQLPostInstallerErrorProc = function( dwErrorCode: DWORD;
		lpszErrMsg: LPCSTR ): SQLRETURN; stdcall;

{ 23 - ODBC 3.0 }
	TSQLWriteFileDSNProc = function( lpszFileName, lpszAppName,
		lpszKeyName, lpszString: LPCSTR ): BOOL; stdcall;

{ 24 - ODBC 3.0 }
	TSQLReadFileDSNProc = function( lpszFileName, lpszAppName,
		lpszKeyName: LPCSTR; lpszString: LPSTR; cbString: WORD;
		pcbString: PWORD ):	BOOL; stdcall;

{ 25 - ODBC 3.0 }
	TSQLInstallDriverExProc = function( lpszDriver, lpszPathIn,
		lpszPathOut: LPSTR; cbPathOutMax: WORD; pcbPathOut: PWORD;
		fRequest: WORD; lpdwUsageCount: LPDWORD ): BOOL; stdcall;

{ 26 - ODBC 3.0 }
	TSQLInstallTranslatorExProc = function( lpszTranslator,
		lpszPathIn, lpszPathOut: LPSTR; cbPathOutMax: WORD;
		pcbPathOut: PWORD; fRequest: WORD; lpdwUsageCount: LPDWORD ):
		BOOL; stdcall;

{ 27 - ODBC 3.0 }
	TSQLGetConfigModeProc = function( pwConfigMode: PUWORD ):
		BOOL; stdcall;

{ 28 - ODBC 3.0 }
	TSQLSetConfigModeProc = function( wConfigMode: UWORD ):
		BOOL; stdcall;

{
	Driver specific Setup APIs called by installer:
	-----------------------------------------------
}

{ 29 - ODBC 1.0 }
	TConfigDSNProc = function( hwndParent: HWND; fRequest: WORD;
		lpszDriver, lpszAttributes: LPCSTR ): BOOL; stdcall;

{ 30 - ODBC 2.0 }
	TConfigTranslatorProc = function( hwndParent: HWND;
		pvOption: PDWORD ): BOOL; stdcall;

{ 31 - ODBC 2.5 }
	TConfigDriverProc = function( hwndParent: HWND; fRequest: WORD;
		lpszDriver, lpszArgs: LPCSTR; lpszMsg: LPSTR; cbMsgMax: WORD;
		pcbMsgOut: PWORD ): BOOL; stdcall;

implementation

end.
