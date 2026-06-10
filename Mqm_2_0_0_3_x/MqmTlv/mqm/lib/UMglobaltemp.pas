unit UMglobal;

interface

uses
  SysUtils,
  Graphics,
  Classes,
  UMCompat,
  UMTblDesc,
  UMCompatRules,
  UMCompatSrv;

const
  // RELEINFO
  C_MQM_MAIN_VER   = '2';
  C_MQM_HOST_DB    = '0';
  C_MQM_MAIN_PC_DB = '0';
  C_MQM_CFG_PC_DB  = '3';
  C_MQM_BUILD      = '6';

  csMqmMainBranch = 'main';
{$ifdef CUST_RELE}
  csMqmGroup      = 'mqm';
{$else}
  {$ifdef DEV_RELE}
    csMqmGroup      = 'mqm'+C_MQM_MAIN_VER+C_MQM_EXT_RELE+C_MQM_INT_RELE+C_MQM_BUILD;
  {$else}
    csMqmGroup      = 'mqmSched';
  {$endif}
{$endif}

type

  TDetCmpClr = record
//    lim: integer;
    int: TColor;
    brd: TColor;
    txt: TColor;
    Dsc: String;   // Description
  end;
  TColorArray = array of TDetCmpClr;

  TIniAppGlobals = record
    // Environment
    Server     : string;
    MainDBPath : string;
    CfgDBPath  : string;
    TempDBPath : string;
    MainDBName : string;
    CfgDBName  : string;
    TempDBName : string;
    Alias      : string;
    PCAlias    : string;
    TimeLoop   : string;
    DwnTypeMode   : string;
    DwnLoopWithMqmCg : string;
    HostDateFormat : string;
    LoginAuto      : string;
    User           : string;
    Password       : string;
    HtmlRowNum     : string;
    ShowBinCaption : string;
    ShowCriteria   : string;
    ReportComment1 : String;



//    JobBarTextSet : string;
//    StatusBarTextSet : string;

    // Setting for Workstation
    TempWkstCode : string;
    WkstCode : string;
    WkstDesc : string;

    FilePlanPropRepo: string;
  end;

  TLocAppGlobals = record
    // Environment
    AppDir    : string;
    AppDrive  : char;
    ImgDir    : string;
    LangDir   : string;
    IsDevelop : boolean;
  end;

  TDBAppSettings = record
    DisableCapRes: boolean;

    // tab filterings and sorting
    TabResSort:    boolean;
    TabKeepSort:   boolean;
    TabFilterRead: boolean;
    TabWorkcenter: boolean;
    TabNoTimings:  boolean;
    TabNoCompat:   boolean;

    FixColCompVis:   boolean;
    FixColStatVis:   boolean;
    FixColDelDVis:   boolean;
    FixColMatDVis:   boolean;
    FixColLowDVis:   boolean;
    FixColHigDVis:   boolean;
    FixColOvlpVis:   boolean;
    FixColDatesVis:  boolean;
    FixColSelection: boolean;

    ChkDelDate:    boolean;
    ChkMaterials:  boolean;
    ChkPrevStpQty: boolean;
    ChkAddRes:     boolean;
    ChkLowStart:   boolean;
    ChkHighEnd:    boolean;
    ChkLinkOvlp:   boolean;

    AutoGroupSingleJob: boolean;
    ShowInBinOnMove:    boolean;
    ShowGroupLinesInBin: boolean;
    ShowBinToolBar: boolean;
    ShowRowInBin:        boolean;

  end;

  TDBAppGlobals = record

    // Environment
    EnvDescr       : string;   // description of the running environment
    Customer       : string;
    MqmVersion     : string;

    // General Date format string
    MonthBefore    : integer;    // Month before (Table VIPD on AS)
    StDateForPlan  : TDateTime;  // Start Date for Plan
    EndDateForPlan : TDateTime;  // End Date for Plan

    // Setting for Workstation
    Language       : string;

    // Last Setting for Plan
    CurrTScale  : integer;
    CurrDtTime  : TDateTime;
    ShowCal     : integer; // 0=no   1=yes
    CurrRscSort : integer; // Code Value for Sort Resources
    ShowZoom    : integer;

    // Setting for Select Resources Form
    SelRscOrderType : string;
    SelRscOrderItem : string;

    // Form Plan
    WdwPlanLeft   : integer;
    WdwPlanTop    : integer;
    WdwPlanWidth  : integer;
    WdwPlanHeight : integer;
    WdwPlanState  : boolean;

    // Form Bin
    WdwBinDock      : integer; // 0=Undocked  1=Right Dock    -1=Bottom Dock
    WdwBinLeft      : integer;
    WdwBinTop       : integer;
    WdwBinWidth     : integer;
    WdwBinHeight    : integer;
    WdwBinState     : boolean;
    WdwBinSplitterH : integer;
    BinCfg_Main     : string;
    BinCfg_SrcByNum : string;
    BinCfg_SrcByOrd : string;
    BinCfg_SrcByIss : string;
    BinCfg_SrcByArt : string;
    BinCfg_SrcByTD  : string;

    //Bin Icon Toolbar
    ToolBarDock      : integer; // 0=Undocked  1=Right Dock    -1=Bottom Dock
    ToolBarLeft      : integer;
    ToolBarTop       : integer;
    ToolBarWidth     : integer;
    ToolBarHeight    : integer;
    ToolBarState     : boolean;

    // Form Move
    WdwMoveLeft     : integer;
    WdwMoveTop      : integer;
    WdwMoveDetails  : boolean;

    // color arrays

    JobToJobCompColor    : TColorArray;
    JobToCapCompColor    : TColorArray;
    JobCapToRscCompColor : TColorArray;
    JobStatusColor       : TColorArray;
    JobDateWarningColor  : TColorArray;
    JobMatWarningColor   : TColorArray;
    ResColors            : TColorArray;
    CapResColors         : TColorArray;

    ShowBinPropArry : array [0..29] of TPropID;

    //Application preferences
    CheckStepSeq : boolean;
    CenterStartOnMove : boolean;
    WarnOnMoveFinal : boolean;
    DefSchedType : integer;
    ConfLevels   : integer;
    MoveOption   : integer;
    LastUpdatNr  : Integer;              // Last Updated Number from Database.


    ActAutoSched : string;
  end;

  procedure GlobLoadIniValues;
  procedure GlobSaveIniValues;
  procedure GlobLoadLocValues;
  procedure GlobLoadDbValues;
  procedure GlobLoadSettingsValues;
  procedure GlobSaveValues;
  procedure GlobSaveSettingsValues;
  procedure GlobSaveConfig;
  procedure GlobInitPosForm(value : integer);

  function GetGlobValueForProperty(pID: TPropID; mtx: TCompatMatrix): TPropRes;
  function GetGlobRuleRtoOfForProperty(pID: TPropID; prod: string; mtx: TCompatMatrix): TCompRules;
  function GetGlobRuleOtoOfForProperty(pID: TPropID; prod: string; mtx: TCompatMatrix): TCompRules;
  function GlobAddProperty(code: string; var val: TPropResRec; ErrList: TStringList): boolean;
  function GlobAddRtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
  function GlobAddOtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;

  procedure GlobGetPropMtxs(lst: TList);
  function  GlobGetRulesRtoOMtxs: TList;
  function  GlobGetRulesOtoOMtxs: TList;

  function GetWorkStationForWc(wc: string; isDesc: boolean): string;
  function GetLastUpdatedNumber : Integer;
  function IsCalendarLoaded: boolean;
  procedure CheckChangedProperties;
  function GetDateForPlanLine(): TDateTime;

var
  IniAppGlobals: TIniAppGlobals;
  LocAppGlobals: TLocAppGlobals;
  DBAppGlobals:  TDBAppGlobals;
  DBAppSettings: TDBAppSettings;

  s_suicide:     boolean;


const

  ArrLanguages: array [0..4] of string = (
    'English', 'Italian', 'German', 'Spanish', 'French');

  DfltCmpClr: array [0..99] of TDetCmpClr = (
  // Remember to modify the strings for translations in procedure "TranslationExtractionPurpose" of this unit
    (int: clWhite;   brd: $00000000; txt: $00000000; dsc: 'No description'), // 0
    (int: $00B9FFD0; brd: $00000000; txt: $00000000; dsc: 'No description'), // 1
    (int: $00B4FFCB; brd: $00000000; txt: $00000000; dsc: 'No description'), // 2
    (int: $00AFFFC6; brd: $00000000; txt: $00000000; dsc: 'No description'), // 3
    (int: $00AAFFC1; brd: $00000000; txt: $00000000; dsc: 'No description'), // 4
    (int: $00A5FFBC; brd: $00000000; txt: $00000000; dsc: 'No description'), // 5
    (int: $00A0FFB7; brd: $00000000; txt: $00000000; dsc: 'No description'), // 6
    (int: $009BFFB2; brd: $00000000; txt: $00000000; dsc: 'No description'), // 7
    (int: $0096FFAD; brd: $00000000; txt: $00000000; dsc: 'No description'), // 8
    (int: $0091FFA8; brd: $00000000; txt: $00000000; dsc: 'No description'), // 9
    (int: $008CFFA3; brd: $00000000; txt: $00000000; dsc: 'No description'), // 10
    (int: $0087FF9E; brd: $00000000; txt: $00000000; dsc: 'No description'), // 11
    (int: $0082FF99; brd: $00000000; txt: $00000000; dsc: 'No description'), // 12
    (int: $007DFF94; brd: $00000000; txt: $00000000; dsc: 'No description'), // 13
    (int: $0078FF8F; brd: $00000000; txt: $00000000; dsc: 'No description'), // 14

    (int: $00FFFFC4; brd: $00000000; txt: $00000000; dsc: 'No description'), // 15
    (int: $00FFFFB6; brd: $00000000; txt: $00000000; dsc: 'No description'), // 16
    (int: $00FFFFA8; brd: $00000000; txt: $00000000; dsc: 'No description'), // 17
    (int: $00FFFF9A; brd: $00000000; txt: $00000000; dsc: 'No description'), // 18
    (int: $00FFFF8C; brd: $00000000; txt: $00000000; dsc: 'No description'), // 19
    (int: $00FFFF7E; brd: $00000000; txt: $00000000; dsc: 'No description'), // 20
    (int: $00FFFF70; brd: $00000000; txt: $00000000; dsc: 'No description'), // 21
    (int: $00FFFF62; brd: $00000000; txt: $00000000; dsc: 'No description'), // 22
    (int: $00FFFF54; brd: $00000000; txt: $00000000; dsc: 'No description'), // 23
    (int: $00FFFF46; brd: $00000000; txt: $00000000; dsc: 'No description'), // 24
    (int: $00FFFF38; brd: $00000000; txt: $00000000; dsc: 'No description'), // 25
    (int: $00FFFF2A; brd: $00000000; txt: $00000000; dsc: 'No description'), // 26
    (int: $00FFFF1C; brd: $00000000; txt: $00000000; dsc: 'No description'), // 27
    (int: $00FFFF0E; brd: $00000000; txt: $00000000; dsc: 'No description'), // 28

    (int: $00FFC1A8; brd: $00000000; txt: $00000000; dsc: 'No description'), // 29
    (int: $00FFBC9C; brd: $00000000; txt: $00000000; dsc: 'No description'), // 30
    (int: $00FFB790; brd: $00000000; txt: $00000000; dsc: 'No description'), // 31
    (int: $00FFB284; brd: $00000000; txt: $00000000; dsc: 'No description'), // 32
    (int: $00FFAD78; brd: $00000000; txt: $00000000; dsc: 'No description'), // 33
    (int: $00FFA86C; brd: $00000000; txt: $00000000; dsc: 'No description'), // 34
    (int: $00FFA360; brd: $00000000; txt: $00000000; dsc: 'No description'), // 35
    (int: $00FF9E54; brd: $00000000; txt: $00000000; dsc: 'No description'), // 36
    (int: $00FF9948; brd: $00000000; txt: $00000000; dsc: 'No description'), // 37
    (int: $00FF943C; brd: $00000000; txt: $00000000; dsc: 'No description'), // 38
    (int: $00FF8F30; brd: $00000000; txt: $00000000; dsc: 'No description'), // 39
    (int: $00FF8A24; brd: $00000000; txt: $00000000; dsc: 'No description'), // 40
    (int: $00FF8518; brd: $00000000; txt: $00000000; dsc: 'No description'), // 41
    (int: $00FF800C; brd: $00000000; txt: $00000000; dsc: 'No description'), // 42

    (int: $00D6D6D6; brd: $00000000; txt: $00000000; dsc: 'No description'), // 43
    (int: $00D1D1D1; brd: $00000000; txt: $00000000; dsc: 'No description'), // 44
    (int: $00CCCCCC; brd: $00000000; txt: $00000000; dsc: 'No description'), // 45
    (int: $00C7C7C7; brd: $00000000; txt: $00000000; dsc: 'No description'), // 46
    (int: $00C2C2C2; brd: $00000000; txt: $00000000; dsc: 'No description'), // 47
    (int: $00BDBDBD; brd: $00000000; txt: $00000000; dsc: 'No description'), // 48
    (int: $00B8B8B8; brd: $00000000; txt: $00000000; dsc: 'No description'), // 49
    (int: $00B3B3B3; brd: $00000000; txt: $00000000; dsc: 'No description'), // 50
    (int: $00AEAEAE; brd: $00000000; txt: $00000000; dsc: 'No description'), // 51
    (int: $00A9A9A9; brd: $00000000; txt: $00000000; dsc: 'No description'), // 52
    (int: $00A4A4A4; brd: $00000000; txt: $00000000; dsc: 'No description'), // 53
    (int: $009F9F9F; brd: $00000000; txt: $00000000; dsc: 'No description'), // 54
    (int: $00959595; brd: $00000000; txt: $00000000; dsc: 'No description'), // 55
    (int: $00909090; brd: $00000000; txt: $00000000; dsc: 'No description'), // 56

    (int: $00FFC4FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 57
    (int: $00FFBDFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 58
    (int: $00FFB6FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 59
    (int: $00FFAFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 60
    (int: $00FFA8FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 61
    (int: $00FFA1FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 62
    (int: $00FF9AFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 63
    (int: $00FF93FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 64
    (int: $00FF8CFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 65
    (int: $00FF85FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 66
    (int: $00FF7EFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 67
    (int: $00FF77FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 68
    (int: $00FF70FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 69
    (int: $00FF69FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 70

    (int: $00C4FFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 71
    (int: $00B6FFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 72
    (int: $00A8FFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 73
    (int: $009AFFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 74
    (int: $008CFFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 75
    (int: $007EFFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 76
    (int: $0070FFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 77
    (int: $0062FFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 78
    (int: $0054FFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 79
    (int: $0046FFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 80
    (int: $0038FFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 81
    (int: $002AFFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 82
    (int: $001CFFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 83
    (int: $000EFFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 84

    (int: $008CB1FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 85
    (int: $0084ACFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 86
    (int: $007CA7FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 87
    (int: $0074A2FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 88
    (int: $006C9DFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 89
    (int: $006498FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 90
    (int: $008593FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 91
    (int: $00858EFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 92
    (int: $008489FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 93
    (int: $008484FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 94
    (int: $00837FFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 95
    (int: $00837AFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 96
    (int: $008275FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 97
    (int: $002470FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 98

    (int: clRed;     brd: $00000000; txt: $00000000; dsc: 'No description')  // 99
  );

  DfltJobStatusClr: array [0..9] of TDetCmpClr = (
  // Remember to modify the strings for translations in procedure "TranslationExtractionPurpose" of this unit
    (int: $00FFDDDD; brd: $00000000; txt: ClBlack; dsc: 'Initial schedule'),
    (int: $00FF00AA; brd: $00000000; txt: ClBlack; dsc: 'Confirmation level 1'),
    (int: $00FF00AA; brd: $00000000; txt: ClBlack; dsc: 'Confirmation level 2'),
    (int: $00FF00AA; brd: $00000000; txt: ClBlack; dsc: 'Confirmation level 3'),
    (int: $00FF00AA; brd: $00000000; txt: ClBlack; dsc: 'Confirmation level 4'),
    (int: $00FF00AA; brd: $00000000; txt: ClBlack; dsc: 'Confirmation level 5'),
    (int: $00EE0000; brd: $00000000; txt: ClWhite; dsc: 'Final scheduled'),
    (int: $0033DD33; brd: $00000000; txt: ClBlack; dsc: 'Progressed'),
    (int: $00007700; brd: $00000000; txt: ClBlack; dsc: 'Progressed as final'),
    (int: $00007700; brd: $00000000; txt: ClBlack; dsc: 'Closed')
  );

  DfltJobDateWrnClr: array [0..2] of TDetCmpClr = (
  // Remember to modify the strings for translations in procedure "TranslationExtractionPurpose" of this unit
    (int: $000000FF; brd: $00000000; txt: ClBlack; dsc: 'After delivery date' ), // 1
    (int: $000000FF; brd: $00000000; txt: ClBlack; dsc: 'After latest end'), // 3
    (int: $000088FF; brd: $00000000; txt: ClBlack; dsc: 'Before earliest start') // 4
  );

  DfltJobMatWrnClr: array [0..3] of TDetCmpClr = (
  // Remember to modify the strings for translations in procedure "TranslationExtractionPurpose" of this unit
    (int: $00FFFFFF; brd: $00000000; txt: ClBlack; dsc: 'Steps overlapping'), // 7 Overlaps
    (int: $0000FFFF; brd: $00000000; txt: ClBlack; dsc: 'Materials warning'), // 2
    (int: $0000AAFF; brd: $00000000; txt: ClBlack; dsc: 'Additional resources warning'), // 2
    (int: $000000FF; brd: $00000000; txt: ClBlack; dsc: 'Materials and additional resources warning')  // 9 Overlaps
  );

  DfltRscClr: array [0..7] of TDetCmpClr = (
  // Remember to modify the strings for translations in procedure "TranslationExtractionPurpose" of this unit
    (int: $00FF9999; brd: clBlack; txt: clBlack; dsc: 'Continuous'), // 0  Continues
    (int: $00FF9999; brd: clBlack; txt: clBlack; dsc: 'Continuous (Read only)'), // 1  Continues (Read only)
    (int: $00DD7777; brd: clBlack; txt: clBlack; dsc: 'Sub resource Continuous'), // 2  Sub resource Continues
    (int: $00DD7777; brd: clBlack; txt: clBlack; dsc: 'Sub resource Continuous (Read only)'), // 3  Sub resource Continues(Read only)
    (int: $0099FF99; brd: clBlack; txt: clBlack; dsc: 'Batch'), // 4  Batch
    (int: $0099FF99; brd: clBlack; txt: clBlack; dsc: 'Batch (Read Only)'),  // 5  Batch (Read Only)
    (int: $0066CC66; brd: clBlack; txt: clBlack; dsc: 'Sub resource Batch'), // 6  Batch
    (int: $0066CC66; brd: clBlack; txt: clBlack; dsc: 'Sub resource Batch (Read Only)')  // 7  Batch (Read Only)
  );

implementation

uses
  Dialogs,
  forms,
  gnugettext,
  UGprogCtrl,
  DMsrvPc,
  UGRegItf;

const
  RegDefault    = 'Main';                     // default vip registry section

  RgMqmSezCfg   = '\Config';                  // Vip configuration section
  RgMqmSezBin   = '\BinConfig';               // Vip Bin section
  RgMqmSezForm  = '\Forms';                   // Vip Forms section
  RgMqmEnvDesc  = 'EnvDescr';                 // Environment Description

  RgMqmSezCol   = RgMqmSezBin + '\Column';    // Vip Bin columns section
  RgMqmFormPlan = RgMqmSezForm + '\Plan';     // Section about Plan Form
  RgMqmFormBin  = RgMqmSezForm + '\Bin';      // Section about Bin Form
  RgMqmFormMove = RgMqmSezForm + '\Move';     // Section about Move Form

  // Environment
  RgCfgServer     = 'Server';
  RgCfgMainDBPath = 'MainDBPath';
  RgCfgCfgDBPath  = 'CfgDBPath';
  RgCfgMainDBName = 'MainDBName';
  RgCfgCfgDBName  = 'CfgDBName';

  // Temp DB
  RgCfgTempDBPath = 'TempDBPath';
  RgCfgTempDBName = 'TempDBName';

  RgCfgAS400Alias = 'Alias';
  RgCfgPcalias    = 'PCalias';

  RgRepoPlanProp  = 'PlanPropFile';

  RgCfgASsysName      = 'ASsysName';               // AS Local Name
  RgCfgASSerNumb      = 'ASSerialNumber';          // AS Serial Number
  RgCfgASLibList      = 'ASLibList';               // AS library list
  RgCfgODBCAlias      = '0DBCAlias';               // AS400 ODBC alias
  RgCfgLocAlias       = 'LocAlias';                // local database alias
  RgCfgCustomer       = 'Customer';                // Customer name
  RgCfgSrvPath        = 'SrvPath';                 // server database path
  RgCfgLastWkstCode   = 'LastWkstCode';            // last workstation Code
  RgCfgTimeSrvLoop    = 'TimeLoopAouto';           // Time Loop auto for mode
  RgLoopWithMqmCg     = 'LoopWithMqmCg';           // Using Mqmcg for second loop
  RgHostDateFormat    = 'HostDateFormat';          // Host Date Time Format
  RgLoginAuto         = 'LoginAuto';               // Host Automatic Connection User/Password
  RgUser              = 'User';                    // Host User Name
  RgPassword          = 'Password';                // Host Password
  RgDwnTypeMode       = 'DowloadTypMode';          // All Files, Only archives, Only Production
  RgHtmlRowNum        = 'HtmlRowNum';              // Number of rows to print per HTML page
  RgShowBinCaption    = 'ShowBinCaption';          // do we show the bin caption in the report
  RgShowCriteria      = 'ShowCriteria ';           // Show criteria in the report
  RgReportComment1    = 'ReportComment1';          // comment to show in the report

  RgCfgLanguage       = 'Language';                // Current Language
  RgCfgLibForSP       = 'LibForSP';                // Library for Stored Procedure
  // Directories of environment
  RgCfgImgDir      = 'DirImg';                  // image files directory
  RgCfgLangDir     = 'DirLang';                 // Languages files directory
  // Calendar Setting
  RgCfgMnthBefore  = 'MonthBefore';             // MonthBefore (Table VIPD on AS)
  RgCfgShowCal     = 'ShowCal';                 // Show calendar shapes on Gantt
  RgCfgTScale      = 'TScale';                  // TimeScale of Plan selected
  RgCfgCurrDTime   = 'CurrDtTime';              // Current Date/Time choose by user
  RgCfgShowZoom    = 'ShowZoom';                // Zoom Gant is active or not
  RgCfgRunMode     = 'Check';                   // configuring the behaviour of the program
  // Various Ordering and setting
  RgCfgRscSort     = 'RscSort';                 // Current Sort of Plan resource
  RgCfgRscOrdType  = 'RscOrdType';              // Current Sort of resource 1(Resource form)
  RgCfgRscOrdItm   = 'RscOrdItm';               // Current Sort of resource 2(Resource form)
  RgCfgDelOccAlone = 'DelOccAlone';             // Delete Occ alone before upload
  RgCfgDrawProg    = 'DrawProg';                // Show if download with delay recalculation
  // Setting of Plan Form
  RgPlanLeft       = 'WdwPlanPosLeft';          // Left Position of Plan form
  RgPlanTop        = 'WdwPlanPosTop';           // Top Position of Plan form
  RgPlanWidth      = 'WdwPlanWidth';            // Width of Plan form
  RgPlanHeight     = 'WdwPlanHeight';           // Height of Plan form
  RgPlanState      = 'WdwPlanState';            // State of Plan form
  // Setting of Bin Form
  RgBinDock        = 'WdwBinDock';              // Docking Position of Bin Form
  RgBinLeft        = 'WdwBinPosLeft';           // Left Position of Bin form
  RgBinTop         = 'WdwBinPosTop';            // Top Position of Bin form
  RgBinWidth       = 'WdwBinWidth';             // Width of Bin form
  RgBinHeight      = 'WdwBinHeight';            // Height of Bin form
  RgBinState       = 'WdwBinState';             // State of Bin form
  RgBinSplitterH   = 'WdwBinSplitterH';         // Splitter Height for Bin Plan Form
  RgBinCfgMain     = 'BinCfg_Main';             // Main Bin Configuration
  RgBinCfgSrcByNum = 'BinCfg_SrcByNum';         // Search by number bin configuration
  RgBinCfgSrcByOrd = 'BinCfg_SrcByOrd';         // Search by order bin configuration
  RgBinCfgSrcByIss = 'BinCfg_SrcByIss';         // Search by issue bin configuration
  RgBinCfgSrcByArt = 'BinCfg_SrcByArt';         // Search by article bin configuration
  RgBinCfgSrcByTD  = 'BinCfg_SrcByTD';          // Search by tecnical data bin configuration

  // Setting of Move Form
  RgMoveLeft        = 'WdwMoveLeft';            // Left Position of Move form
  RgMoveTop         = 'WdwMoveTop';             // Top Position of Move form
  RgMoveDetails     = 'WdwMoveDetails';         // Move form Details open
  RgMoveOcc         = 'OccMove';                // Last move option selected for Occupations
  RgMoveVL          = 'VLMove';                 // Last move option selected for Vip Lines
  RgMoveOTP         = 'OTPMove';                // Last move option selected for Order to produce

  //Application Preferences
  RgCheckStepSeq    = 'CheckStepSeq';           // Check step sequence
  RgCenterStartOnMove = 'CenterStartOnMove';    // Center the planned start date on the gantt when moving from the bin
  RGWarnOnMoveFinal = 'WarnOnMoveFinal';         // Warning message when a movement need to move a final schedule on gantt
  RgDefSchedType    = 'DefSchedType';           // Default Schedulation type
  RgConfLevels      = 'ConfLevels';             // Confirmation levels
  RgCfgJobBarTextSet   = 'JobBarTextSet';             //Active Set of BarText
  RgCfgStatusBarTextSet   = 'StatusBarTextSet';             //Active Set of BarText

  CFG_LIMITOCC = $00000001;
  CFG_DEVELOP  = $00000002;

var

  // compatibility handling informations
  s_propMtx:      array[1..1] of TOrigMatrix;
  s_rulesRtoOMtx: array[1..2] of TOrigMatrix;
  s_rulesOtoOMtx: array[1..2] of TOrigMatrix;

const

  PropMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
       -1,  // code and process
       -1,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );

  RulesRtoOMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
       -1,  // code and process
        2,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );

  RulesOtoOMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
       -1,  // code and process
        2,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );

procedure TranslationExtractionPurpose;
//These strings are not really used in the program and are here only
//for the translation extraction purpose
var
  notused1,notused2,notused3,notused4,notused5,notused6,notused7,notused8,
  notused9,notused10,notused11,notused12,notused13,notused14,notused15,notused16,
  notused17, notused20, notused21, notused22, notused23,
  notused24, notused25, notused26, notused27, notused28 : string;
begin
  notused1:= _('Initial schedule');
  notused2:= _('Confirmation level 1');
  notused3:= _('Confirmation level 2');
  notused4:= _('Confirmation level 3');
  notused5:= _('Confirmation level 4');
  notused6:= _('Confirmation level 5');
  notused7:= _('Final scheduled');
  notused8:= _('Progressed');
  notused9:= _('Progressed as final');
  notused10:= _('Closed');
  notused11:= _('After delivery date' );
  notused12:= _('After latest end');
  notused13:= _('Before earliest start');
  notused14:= _('Steps overlapping');
  notused15:= _('Materials warning');
  notused16:= _('Additional resources warning');
  notused17:= _('Materials and additional resources warning');

  notused20:= _('Continuous');
  notused21:= _('Continuous (read only)');
  notused22:= _('Sub resource Continuous');
  notused23:= _('Sub resource Continuous (read only)');
  notused24:= _('Batch');
  notused25:= _('Batch (read Only)');
  notused26:= _('Sub resource Batch');
  notused27:= _('Sub resource Batch (read Only)');

  notused28:= _('No description');
end;

//----------------------------------------------------------------------------//
//                          COMPATIBILITY FUNCTIONS                           //
//----------------------------------------------------------------------------//

function GetGlobValueForProperty(pID: TPropID; mtx: TCompatMatrix): TPropRes;
begin
  Result := nil;
  Assert(mtx = CMX_code);
  if PropMtxMap[mtx] = -1 then exit;
  if not Assigned(s_propMtx[PropMtxMap[mtx]]) then exit;
  Result := TPropRes(TOneDmatrix(s_propMtx[PropMtxMap[mtx]]).GetObject(pID))
end;

//----------------------------------------------------------------------------//

function GetGlobRuleRtoOfForProperty(pID: TPropID; prod: string; mtx: TCompatMatrix): TCompRules;
var
  mtxVal: TOrigMatrix;
begin
  Result := nil;
  if RulesRtoOMtxMap[mtx] = -1 then exit;
  mtxVal := s_rulesRtoOMtx[RulesRtoOMtxMap[mtx]];
  if not Assigned(mtxVal) then exit;

  case mtx of
  CMX_code:      Result := TCompRules(TOneDmatrix(mtxVal).GetObject(pID));
  CMX_code_prod: Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,prod));
  else
    Assert(false)
  end
end;

//----------------------------------------------------------------------------//

function GetGlobRuleOtoOfForProperty(pID: TPropID; prod: string; mtx: TCompatMatrix): TCompRules;
var
  mtxVal: TOrigMatrix;
begin
  Result := nil;
  if RulesOtoOMtxMap[mtx] = -1 then exit;
  mtxVal := s_rulesOtoOMtx[RulesOtoOMtxMap[mtx]];
  if not Assigned(mtxVal) then exit;

  case mtx of
  CMX_code:      Result := TCompRules(TOneDmatrix(mtxVal).GetObject(pID));
  CMX_code_prod: Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,prod));
  else
    Assert(false)
  end
end;

//----------------------------------------------------------------------------//

function GlobAddProperty(code: string; var val: TPropResRec; ErrList: TStringList): boolean;
var
  propRes: TPropRes;
  pId:     TPropID;
  tpLink:  TCompatTopoLink;
  mtx:     TCompatMatrix;
  mtxVal:  TOrigMatrix;
begin
  propRes := TPropRes.Create;

  propRes.m_addResToOcc := val.addResToOcc;
  propRes.m_dfltResOcc  := val.dfltResOcc;
  propRes.m_dfltOccOcc  := val.dfltOccOcc;
  propRes.m_dfltSameGrp := val.dfltSameGrp;
  propRes.m_ValForGrp   := val.ValForGrp;

  pId := DecodeProp(code, val.valStr, propRes.m_val);
  if not Assigned(pId) then
  begin
    ErrList.Add(_('Global') + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;
{
  // mario to put on log
  if not Assigned(pId) then
  begin
    Result := false;
    exit
  end;
}
  GetPropCoordForValue(pID, tpLink, mtx);
  Assert(tpLink = CTL_global);

  Assert(PropMtxMap[mtx] <> -1);
  if not Assigned(s_propMtx[PropMtxMap[mtx]]) then
    CreateMatrix(s_propMtx[PropMtxMap[mtx]], mtx);

  mtxVal := s_propMtx[PropMtxMap[mtx]];

  Assert(mtx = CMX_code);
  TOneDmatrix(mtxVal).AddObject(pId, propRes);

  Result := true
end;

//----------------------------------------------------------------------------//

procedure AssignRuleToMat(pId: TPropID; mtx: TCompatMatrix; mtxVal: TOrigMatrix;
                          isOtoO: boolean; var vrnt: variant; var val: TRuleResRec);
var
  oneDmtx: TOneDmatrix;
  twoDmtx: TTwoDmatrix;
  rule:    TCompRules;
  sup:     TSetupRec;
begin
  rule := nil;

  case mtx of
  CMX_code: begin
              oneDmtx := TOneDmatrix(mtxVal);
              rule := TCompRules(oneDmtx.GetObject(pId));
              if not Assigned(rule) then
              begin
                rule := TCompRules.Create;
                oneDmtx.AddObject(pId, rule)
              end
            end;

  CMX_code_prod: begin // code and product type
                   twoDmtx := TTwoDmatrix(mtxVal);
                   rule := TCompRules(twoDmtx.GetObject(pId, val.prodType));
                   if not Assigned(rule) then
                   begin
                     rule := TCompRules.Create;
                     twoDmtx.AddObject(pId, val.prodType, rule)
                   end
                 end;
  end;

  Assert(Assigned(rule));

  if not isOtoO then
    rule.AddItem(val.checkSeq, val.toBase, vrnt, val.op, val.comp, nil)
  else
  begin
    sup.Value          := ConvPropValue(pId, val.constStr);
    sup.supAdjType     := val.supAdjType;
    sup.supTime        := val.supTime;
    sup.supOverlap     := val.supOverlap;
    sup.supMult        := val.supMult;
    sup.supMultOverlap := val.supMultOverlap;
    if val.onSameGroup = '1' then
      sup.onSameGroup := true
    else
      sup.onSameGroup := false;

    rule.AddItem(val.checkSeq, val.toBase, vrnt, val.op, val.comp, @sup)
  end
end;

//----------------------------------------------------------------------------//

function GlobAddRtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
var
  pId:       TPropID;
  tpLink:    TCompatTopoLink;
  mtx:       TCompatMatrix;
  vrnt:      variant;
begin
  pId := DecodeProp(code, val.valStr, vrnt);
  if not Assigned(pId) then
  begin
    ErrList.Add(_('Global') + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;

  GetPropCoordForRtoOcomp(pId, tpLink, mtx);
  Assert(tpLink = CTL_global);

  Assert(RulesRtoOMtxMap[mtx] <> -1);
  if not Assigned(s_rulesRtoOMtx[RulesRtoOMtxMap[mtx]]) then
    CreateMatrix(s_rulesRtoOMtx[RulesRtoOMtxMap[mtx]], mtx);

  AssignRuleToMat(pId, mtx, s_rulesRtoOMtx[RulesRtoOMtxMap[mtx]], false, vrnt, val);
  Result := true
end;

//----------------------------------------------------------------------------//

function GlobAddOtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
var
  pId:    TPropID;
  tpLink: TCompatTopoLink;
  mtx:    TCompatMatrix;
  vrnt:   variant;
begin
  pId := DecodeProp(code, val.valStr, vrnt);
  if not Assigned(pId) then
  begin
    ErrList.Add(_('Global') + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;

  GetPropCoordForOtoOcomp(pId, tpLink, mtx);
  Assert(tpLink = CTL_global);

  Assert(RulesOtoOMtxMap[mtx] <> -1);
  if not Assigned(s_rulesOtoOMtx[RulesOtoOMtxMap[mtx]]) then
    CreateMatrix(s_rulesOtoOMtx[RulesOtoOMtxMap[mtx]], mtx);

  AssignRuleToMat(pId, mtx, s_rulesOtoOMtx[RulesOtoOMtxMap[mtx]], true, vrnt, val);
  Result := true
end;

//----------------------------------------------------------------------------//

procedure GlobGetPropMtxs(lst: TList);
var
  cmpM: TCompatMatrix;
begin
  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (PropMtxMap[cmpM] = -1) or
       (not Assigned(s_propMtx[PropMtxMap[cmpM]])) then continue;
    lst.Add(s_propMtx[PropMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function GlobGetRulesRtoOMtxs: TList;
var
  cmpM: TCompatMatrix;
begin
  Result := TList.Create;

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (RulesRtoOMtxMap[cmpM] = -1) or
       (not Assigned(s_rulesRtoOMtx[RulesRtoOMtxMap[cmpM]])) then continue;
    Result.Add(s_rulesRtoOMtx[RulesRtoOMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function GlobGetRulesOtoOMtxs: TList;
var
  cmpM: TCompatMatrix;
begin
  Result := TList.Create;

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (RulesOtoOMtxMap[cmpM] = -1) or
       (not Assigned(s_rulesOtoOMtx[RulesOtoOMtxMap[cmpM]])) then continue;
    Result.Add(s_rulesOtoOMtx[RulesOtoOMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function GetWorkStationForWc(wc: string; isDesc: boolean): string;
var
  qry:      TMqmQuery;
  trs:      TMqmTransaction;
  tbInfoww: ^TTblInfo;
  tbInfows: ^TTblInfo;
  WsCode:   string;
begin
  Result := '';
  tbInfoww := @tblInfo[tbl_wkst_wkc];

  trs := CreateTransaction(Main_DB, true);
  qry := CreateQuery(trs, Main_DB);

  with qry do
  begin
    Transaction.Active := true;
    SQL.Clear;
    SQL.Add('select ' + CreateFld(tbInfoww.pfx,fli_wkstCode) + ' from ' + tbInfoww.PCname + ' where ' + CreateFld(tbInfoww.pfx,fli_wkCtrCode) + '=''' + WC + '''');
    SQL.Add(' and ' + CreateFld(tbInfoww.pfx,fli_TypeOfUse) +  ' = ' + '1');
    open;
    if not IsDesc then
      Result := fieldByName(CreateFld(tbInfoww.pfx,fli_wkstCode)).AsString
    else
    begin
      tbInfows := @tblInfo[tbl_wkst];
      WsCode := qry.fieldByName(CreateFld(tbInfoww.pfx,fli_wkstCode)).AsString;
      Close;
      SQL.Clear;
      Transaction.Active := true;
      SQL.Add('select ' + CreateFld(tbInfows.pfx,fli_wkDescr) + ' from ' + tbInfows.PCname + ' where ' + CreateFld(tbInfows.pfx,fli_wkstCode) + '=''' + WsCode + '''');
      open;
      Result := fieldByName(CreateFld(tbInfows.pfx,fli_wkDescr)).AsString
    end;
    Close
  end;

  trs.Commit;
  qry.Free;
  trs.Free
end;

//----------------------------------------------------------------------------//

procedure DecodeConfig(config: integer);
begin
  with LocAppGlobals do
    if (config and CFG_DEVELOP) > 0 then
      IsDevelop := true
end;

//----------------------------------------------------------------------------//

procedure GlobLoadIniValues;
begin
  with IniAppGlobals do
  begin
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgLastWkstCode, WkstCode);

    ReadStrFromIniFile(RgMqmSezCfg, RgCfgServer,     Server);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgMainDBPath, MainDBPath);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgCfgDBPath,  CfgDBPath);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgMainDBName, MainDBName);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgCfgDBName,  CfgDBName);

    // Temp DB
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgTempDBPath, TempDBPath);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgTempDBName, TempDBName);

    ReadStrFromIniFile(RgMqmSezCfg, RgCfgAS400alias, Alias);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgPcalias, PCAlias);
    ReadStrFromIniFile(RgMqmSezCfg, RgRepoPlanProp,  FilePlanPropRepo);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgTimeSrvLoop, TimeLoop);
    ReadStrFromIniFile(RgMqmSezCfg, RgDwnTypeMode, DwnTypeMode);
    ReadStrFromIniFile(RgMqmSezCfg, RgLoopWithMqmCg, DwnLoopWithMqmCg);
    ReadStrFromIniFile(RgMqmSezCfg, RgHostDateFormat,  HostDateFormat);
    ReadStrFromIniFile(RgMqmSezCfg, RgLoginAuto, LoginAuto);
    ReadStrFromIniFile(RgMqmSezCfg, RgUser, User);
    ReadStrFromIniFile(RgMqmSezCfg, RgPassword, Password);
    ReadStrFromIniFile(RgMqmSezCfg, RgHtmlRowNum, HtmlRowNum);
    ReadStrFromIniFile(RgMqmSezCfg, RgShowBinCaption,  ShowBinCaption);
    ReadStrFromIniFile(RgMqmSezCfg, RgShowCriteria, ShowCriteria);
    ReadStrFromIniFile(RgMqmSezCfg, RgReportComment1, ReportComment1);

//    ReadStrFromIniFile(RgMqmSezCfg, RgCfgJobBarTextSet, JobBarTextSet);
//    ReadStrFromIniFile(RgMqmSezCfg, RgCfgStatusBarTextSet, StatusBarTextSet);
  end
end;

//----------------------------------------------------------------------------//

procedure DefaultComptColors(var DefaultCmptColr : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultCmptColr, Length(DfltCmpClr));
  for I := Low(DfltCmpClr) to High(DfltCmpClr) do
    DefaultCmptColr[I] := DfltCmpClr[I];
end;

//----------------------------------------------------------------------------//

procedure DefaultJobStatusColors(var DefaultStatusColor : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultStatusColor, Length(DfltJobStatusClr));
  for I := Low(DfltJobStatusClr) to High(DfltJobStatusClr) do
  begin
    DefaultStatusColor[I] := DfltJobStatusClr[I];
    DefaultStatusColor[I].Dsc := _(DfltJobStatusClr[I].Dsc);
  end;
end;

//----------------------------------------------------------------------------//

procedure DefaultJobDateWrnColors(var DefaultDateWrnColors : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultDateWrnColors, Length(DfltJobDateWrnClr));
  for I := Low(DfltJobDateWrnClr) to High(DfltJobDateWrnClr) do
  begin
    DefaultDateWrnColors[I] := DfltJobDateWrnClr[I];
    DefaultDateWrnColors[I].Dsc := _(DfltJobDateWrnClr[I].Dsc);
  end;
end;

//----------------------------------------------------------------------------//

procedure DefaultJobMatWrnColors(var DefaultMatWrnColors : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultMatWrnColors, Length(DfltJobMatWrnClr));
  for I := Low(DfltJobMatWrnClr) to High(DfltJobMatWrnClr) do
  begin
    DefaultMatWrnColors[I] := DfltJobMatWrnClr[I];
    DefaultMatWrnColors[I].Dsc := _(DfltJobMatWrnClr[I].Dsc);
  end;
end;

//----------------------------------------------------------------------------//

procedure DefaultResColors(var DefaultResColr : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultResColr, Length(DfltRscClr));
  for I := Low(DfltRscClr) to High(DfltRscClr) do
    DefaultResColr[I] := DfltRscClr[I];
end;

//----------------------------------------------------------------------------//
// Is it in use at all ?
procedure DefaultCapResColors(var DefaultCapResColr : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultCapResColr, Length(DfltCmpClr));
  for I := Low(DfltCmpClr) to High(DfltCmpClr) do
    DefaultCapResColr[I] := DfltCmpClr[I];
end;

//----------------------------------------------------------------------------//

function GetLastUpdatedNumber : Integer;
var
  qry:       TMqmQuery;
  trs:       TMqmTransaction;
  tbReqChange : ^TTblInfo;
begin
  tbReqChange := @tblInfo[tbl_Req_Change];
  SetFldPfx(tbReqChange.pfx);

  trs := CreateTransaction(Main_DB, true);
  qry := CreateQuery(trs, Main_DB);

  trs.StartTransaction;

  // load the Last updated number for the request changed table

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ' + CreatePfxFld(fli_updCode));
    SQL.Add(' from ' + tbReqChange.PCname);
    SQL.Add(' Order by ' + CreatePfxFld(fli_updCode));
    Open;
    if Eof then
      Result := -1
    else
    begin
      Last;
      Result := FieldByName(CreatePfxFld(fli_updCode)).AsInteger;
    end;
    Close;
  end;
  trs.Commit;
  qry.free;
  trs.Free;

end;

//----------------------------------------------------------------------------//

procedure LoadColors;
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
  I,color:integer;
  ColrCmptTbl : Table;
  J : Integer;
  Description : String;
begin

  ColrCmptTbl := tbl_cfg_colorJobToJob;
  trs := CreateTransaction(Cfg_DB, true);
  qry := CreateQuery(trs, Cfg_DB);

  for J := 0 to 7 do
  begin
    case J of
      0 : ColrCmptTbl := tbl_cfg_colorJobToJob;
      1 : ColrCmptTbl := tbl_cfg_clrCapToJob;
      2 : ColrCmptTbl := tbl_cfg_colorJobToRes;
      3 : ColrCmptTbl := tbl_cfg_colorStatus;
      4 : ColrCmptTbl := tbl_cfg_colorDateWarn;
      5 : ColrCmptTbl := tbl_cfg_colorMatWarn;
      6 : ColrCmptTbl := tbl_cfg_clrRes;
      7 : ColrCmptTbl := tbl_cfg_clrCapRes;
    end;

    tbInfo := @tblInfo[ColrCmptTbl];
    SetFldPfx(tbInfo.pfx);

    qry.Transaction.StartTransaction;

    qry.SQL.Add('select * from ' + tbInfo.PCname + ' where ' + CreatePfxFld(fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    qry.SQL.Add('Order by ' + CreatePfxFld(fli_ValFrom));
    qry.open;

    case J of
      0 : begin

            if qry.Eof then
               DefaultComptColors(DBAppGlobals.JobToJobCompColor)
            else
            begin
              SetLength(DBAppGlobals.JobToJobCompColor, Length(DfltCmpClr));
              for i := 0 to high(DfltCmpClr) do
              begin
             //   numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
             //   DBAppGlobals.JobToJobCompColor[I].lim := numfrom;
                color := qry.FieldByName(CreatePfxFld(Fli_intColor)).AsInteger;
                DBAppGlobals.JobToJobCompColor[I].int := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobToJobCompColor[I].brd := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_txtColor)).AsInteger;
                DBAppGlobals.JobToJobCompColor[I].txt := TColor(color);
                qry.Next;
                if qry.Eof then break;
              end;
              while I < Length(DBAppGlobals.JobToJobCompColor) do
              begin
                DBAppGlobals.JobToJobCompColor[I] := DfltCmpClr[I];
                DBAppGlobals.JobToJobCompColor[I].Dsc := _(DfltCmpClr[I].Dsc);
                I := I +1;
              end;
            end;
          end;

      1 : begin

            if qry.Eof then
               DefaultComptColors(DBAppGlobals.JobToCapCompColor)
            else
            begin
              SetLength(DBAppGlobals.JobToCapCompColor, Length(DfltCmpClr));
              for i := 0 to high(DfltCmpClr) do
              begin
             //   numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
             //   DBAppGlobals.JobToCapCompColor[I].lim := numfrom;
                color := qry.FieldByName(CreatePfxFld(Fli_intColor)).AsInteger;
                DBAppGlobals.JobToCapCompColor[I].int := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobToCapCompColor[I].brd := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_txtColor)).AsInteger;
                DBAppGlobals.JobToCapCompColor[I].txt := TColor(color);
                qry.Next;
                if qry.Eof then break;
              end;
              while I < Length(DBAppGlobals.JobToCapCompColor) do
              begin
                DBAppGlobals.JobToCapCompColor[I] := DfltCmpClr[I];
                DBAppGlobals.JobToCapCompColor[I].Dsc := _(DfltCmpClr[I].Dsc);
                I := I +1;
              end;
            end;
          end;

      2 : begin

            if qry.Eof then
               DefaultComptColors(DBAppGlobals.JobCapToRscCompColor)
            else
            begin
              SetLength(DBAppGlobals.JobCapToRscCompColor, Length(DfltCmpClr));
              for i := 0 to high(DfltCmpClr) do
              begin
            //    numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
            //    DBAppGlobals.JobCapToRscCompColor[I].lim := numfrom;
                color := qry.FieldByName(CreatePfxFld(Fli_intColor)).AsInteger;
                DBAppGlobals.JobCapToRscCompColor[I].int := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobCapToRscCompColor[I].brd := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_txtColor)).AsInteger;
                DBAppGlobals.JobCapToRscCompColor[I].txt := TColor(color);
                qry.Next;
                if qry.Eof then break;
              end;
              while I < Length(DBAppGlobals.JobCapToRscCompColor) do
              begin
                DBAppGlobals.JobCapToRscCompColor[I] := DfltCmpClr[I];
                DBAppGlobals.JobCapToRscCompColor[I].Dsc := _(DfltCmpClr[I].Dsc);
                I := I +1;
              end;
            end;
          end;

      3 : begin

            if qry.Eof then
               DefaultJobStatusColors(DBAppGlobals.JobStatusColor)
            else
            begin
              SetLength(DBAppGlobals.JobStatusColor, Length(DfltJobStatusClr));
              for i := 0 to high(DfltJobStatusClr) do
              begin
//                SetLength(DBAppGlobals.ErrorsColor, I + 1);
           //     numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
           //     DBAppGlobals.ErrorsColor[I].lim := numfrom;
                color := qry.FieldByName(CreatePfxFld(Fli_intColor)).AsInteger;
                DBAppGlobals.JobStatusColor[I].int := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobStatusColor[I].brd := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_txtColor)).AsInteger;
                DBAppGlobals.JobStatusColor[I].txt := TColor(color);
                Description := qry.FieldByName(CreatePfxFld(Fli_txtDescription)).AsString;
                DBAppGlobals.JobStatusColor[I].dsc := Description;
                qry.Next;
                if qry.Eof then break;
              end;
              while I < Length(DBAppGlobals.JobStatusColor) do
              begin
                DBAppGlobals.JobStatusColor[I] := DfltJobStatusClr[I];
                DBAppGlobals.JobStatusColor[I].Dsc := _(DfltJobStatusClr[I].Dsc);
                I := I +1;
              end;
            end;
          end;

      4 : begin

            if qry.Eof then
               DefaultJobDateWrnColors(DBAppGlobals.JobDateWarningColor)
            else
            begin
              SetLength(DBAppGlobals.JobDateWarningColor, Length(DfltJobDateWrnClr));
              for i := 0 to high(DfltJobDateWrnClr) do
              begin
                color := qry.FieldByName(CreatePfxFld(Fli_intColor)).AsInteger;
                DBAppGlobals.JobDateWarningColor[I].int := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobDateWarningColor[I].brd := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_txtColor)).AsInteger;
                DBAppGlobals.JobDateWarningColor[I].txt := TColor(color);
                Description := qry.FieldByName(CreatePfxFld(Fli_txtDescription)).AsString;
                DBAppGlobals.JobDateWarningColor[I].dsc := Description;
                qry.Next;
                if qry.Eof then break;
              end;
              while I < Length(DBAppGlobals.JobDateWarningColor) do
              begin
                DBAppGlobals.JobDateWarningColor[I] := DfltJobDateWrnClr[I];
                DBAppGlobals.JobDateWarningColor[I].Dsc := _(DfltJobDateWrnClr[I].Dsc);
                I := I +1;
              end;
            end;
          end;

      5 : begin

            if qry.Eof then
               DefaultJobMatWrnColors(DBAppGlobals.JobMatWarningColor)
            else
            begin
              SetLength(DBAppGlobals.JobMatWarningColor, Length(DfltJobMatWrnClr));
              for i := 0 to high(DfltJobMatWrnClr) do
              begin
                color := qry.FieldByName(CreatePfxFld(Fli_intColor)).AsInteger;
                DBAppGlobals.JobMatWarningColor[I].int := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobMatWarningColor[I].brd := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_txtColor)).AsInteger;
                DBAppGlobals.JobMatWarningColor[I].txt := TColor(color);
                Description := qry.FieldByName(CreatePfxFld(Fli_txtDescription)).AsString;
                DBAppGlobals.JobMatWarningColor[I].dsc := Description;
                qry.Next;
                if qry.Eof then break;
              end;
              while I < Length(DBAppGlobals.JobMatWarningColor) do
              begin
                DBAppGlobals.JobMatWarningColor[I] := DfltJobMatWrnClr[I];
                DBAppGlobals.JobMatWarningColor[I].Dsc := _(DfltJobMatWrnClr[I].Dsc);
                I := I +1;
              end;
            end;
          end;

      6 : begin

            if qry.Eof then
               DefaultResColors(DBAppGlobals.ResColors)
            else
            begin
              SetLength(DBAppGlobals.ResColors, Length(DfltRscClr));
              for i := 0 to high(DfltRscClr) do
              begin
           //     numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
           //     DBAppGlobals.ErrorsColor[I].lim := numfrom;
                color := qry.FieldByName(CreatePfxFld(Fli_intColor)).AsInteger;
                DBAppGlobals.ResColors[I].int := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_bdrColor)).AsInteger;
                DBAppGlobals.ResColors[I].brd := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_txtColor)).AsInteger;
                DBAppGlobals.ResColors[I].txt := TColor(color);
                Description := qry.FieldByName(CreatePfxFld(Fli_txtDescription)).AsString;
                DBAppGlobals.ResColors[I].dsc := Description ;
                qry.Next;
                if qry.Eof then break;
              end;
              while I < Length(DBAppGlobals.ResColors) do
              begin
                DBAppGlobals.ResColors[I] := DfltRscClr[I];
                DBAppGlobals.ResColors[I].Dsc := _(DfltRscClr[I].Dsc);
                I := I +1;
              end;
            end;
          end;


      7 : begin

            if qry.Eof then
               DefaultCapResColors(DBAppGlobals.CapResColors)
            else
            begin
              I := 0;
              while not qry.Eof do
              begin
                SetLength(DBAppGlobals.CapResColors, I + 1);
           //     numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
           //     DBAppGlobals.ErrorsColor[I].lim := numfrom;
                color := qry.FieldByName(CreatePfxFld(Fli_intColor)).AsInteger;
                DBAppGlobals.CapResColors[I].int := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_bdrColor)).AsInteger;
                DBAppGlobals.CapResColors[I].brd := TColor(color);
                color := qry.FieldByName(CreatePfxFld(Fli_txtColor)).AsInteger;
                DBAppGlobals.CapResColors[I].txt := TColor(color);
                Description := qry.FieldByName(CreatePfxFld(Fli_txtDescription)).AsString;
                DBAppGlobals.CapResColors[I].dsc := Description ;
                I := I + 1;
                qry.Next;
              end;
            end;
          end;
    end;

   // DefaultResColors(DBAppGlobals.ResColors);   // temporary

    qry.Close;   // Vinc
    qry.Transaction.Commit;
    qry.SQL.Clear;

  end;

//  trs.Commit;  // Vinc

  qry.free;
  trs.free;
end;

//----------------------------------------------------------------------------//

procedure GlobLoadLocValues;
begin
  with LocAppGlobals do
  begin
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgImgDir, ImgDir);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgLangDir, LangDir);
  end;
end;

//----------------------------------------------------------------------------//

procedure LoadPropBin;
var
  qry:       TMqmQuery;
  trs:       TMqmTransaction;
  tbBinProp :  ^TTblInfo;
  i: integer;
begin

  tbBinProp := @tblInfo[tbl_cfg_bin_showProp];
  SetFldPfx(tbBinProp.pfx);

  trs := CreateTransaction(Cfg_DB, true);
  qry := CreateQuery(trs, Cfg_DB);

  trs.Active := true;

  // load the Properties to show in Bin

  with qry do
  begin
  //WARNING THE QUERY FIELDS ARE ACCESSED BY INDEX!
    SQL.Add('select');
    for i := 1 to 30 do
    begin
      if i < 30 then
        SQL.Add(CreatePfxFld(fli_FiltPropCode) + IntToStr(i) + ',')
      else
        SQL.Add(CreatePfxFld(fli_FiltPropCode) + IntToStr(i));
    end;
    SQL.Add(' from ' + tbBinProp.PCname);
    SQL.Add(' where ' + CreatePfxFld(fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    Open;
    First;

    for i := 1 to 30 do
    begin
      if (FieldByName(CreatePfxFld(fli_FiltPropCode) + IntToStr(i)).AsString) <> '' then
        DBAppGlobals.ShowBinPropArry[i-1] := GetIdFromCode(FieldByName(CreatePfxFld(fli_FiltPropCode) + IntToStr(i)).AsString)
      else
        DBAppGlobals.ShowBinPropArry[i-1] := nil;
    end;
    Close;
  end;
  trs.Commit;  //Vinc

  qry.Free;    //Vinc
  trs.Free;    //Vinc
end;

//----------------------------------------------------------------------------//

procedure GlobLoadDbValues;
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
begin
  LoadColors;
  LoadPropBin;
  tbInfo := @tblInfo[tbl_cfg_appGlob];
  SetFldPfx(tbInfo.pfx);

  trs := CreateTransaction(Cfg_DB, true);
  qry := CreateQuery(trs,Cfg_DB);

  trs.Active := true;
  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.PCname + ' where ' + CreatePfxFld(fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.Open;

  with DBAppGlobals do
  begin
    // set values from db into AppGlobals
    if not qry.EOF then
    begin
      EnvDescr        := qry.FieldByName(CreatePfxFld(fli_EnvDescr)).AsString;
      Customer        := qry.FieldByName(CreatePfxFld(fli_Customer)).AsString;
 //     MqmVersion      := qry.FieldByName(CreatePfxFld(fli_MqmVersion)).AsString;
      MonthBefore     := qry.FieldByName(CreatePfxFld(fli_MonthBefore)).AsInteger;
      StDateForPlan   := qry.FieldByName(CreatePfxFld(fli_StDateForPlan)).AsDateTime;
      EndDateForPlan  := StDateForPlan + 500;
      Language        := qry.FieldByName(CreatePfxFld(fli_Language)).AsString;
      CurrTScale      := qry.FieldByName(CreatePfxFld(fli_CurrTScale)).AsInteger;
      CurrDtTime      := qry.FieldByName(CreatePfxFld(fli_CurrDtTime)).AsDateTime;
      ShowCal         := qry.FieldByName(CreatePfxFld(fli_ShowCal)).AsInteger;
      CurrRscSort     := qry.FieldByName(CreatePfxFld(fli_CurrRscSort)).AsInteger;
      ShowZoom        := qry.FieldByName(CreatePfxFld(fli_ShowZoom)).AsInteger;
      SelRscOrderType := qry.FieldByName(CreatePfxFld(fli_RscOrderType)).AsString;
      SelRscOrderItem := qry.FieldByName(CreatePfxFld(fli_RscOrderItem)).AsString;

      WdwPlanLeft   := qry.FieldByName(CreatePfxFld(fli_wdwPlanLeft)).AsInteger;
      WdwPlanTop    := qry.FieldByName(CreatePfxFld(fli_wdwPlanTop)).AsInteger;
      WdwPlanWidth  := qry.FieldByName(CreatePfxFld(fli_wdwPlanWidth)).AsInteger;
      WdwPlanHeight := qry.FieldByName(CreatePfxFld(fli_wdwPlanHeight)).AsInteger;

      if qry.FieldByName(CreatePfxFld(fli_wdwPlanstate)).AsInteger = 1 then  // planstate
        WdwPlanState := true
      else
        WdwPlanState := false;

      WdwBinDock := qry.FieldByName(CreatePfxFld(fli_wdwBinDock)).AsInteger;
      Wdwbinleft := qry.FieldByName(CreatePfxFld(fli_wdwBinLeft)).AsInteger;
      Wdwbintop := qry.FieldByName(CreatePfxFld(fli_wdwBinTop)).AsInteger;
      Wdwbinwidth := qry.FieldByName(CreatePfxFld(fli_wdwBinWidth)).AsInteger;
      Wdwbinheight := qry.FieldByName(CreatePfxFld(fli_wdwBinHeight)).AsInteger;
      if (qry.FieldByName(CreatePfxFld(fli_wdwBinState)).AsInteger) = 1 then  // binstate
        WdwBinState := true
      else
        WdwBinState := false;
      WdwbinsplitterH := qry.FieldByName(CreatePfxFld(fli_wdwBinSplitter)).AsInteger;

      ToolBarDock      := qry.FieldByName(CreatePfxFld(fli_ToolBarDock)).AsInteger; // 0=Undocked  1=Right Dock    -1=Bottom Dock
      ToolBarLeft      := qry.FieldByName(CreatePfxFld(fli_ToolBarLeft)).AsInteger;
      ToolBarTop       := qry.FieldByName(CreatePfxFld(fli_ToolBarTop )).AsInteger;
      ToolBarWidth     := qry.FieldByName(CreatePfxFld(fli_ToolBarWidth)).AsInteger;
      ToolBarHeight    := qry.FieldByName(CreatePfxFld(fli_ToolBarHeight)).AsInteger;
      if ( qry.FieldByName(CreatePfxFld(fli_ToolBarState)).AsInteger) = 1 then        ToolBarState := true      else
        ToolBarState := false;

      if (qry.FieldByName(CreatePfxFld(fli_CheckStepSeq)).AsInteger) = 1 then  // Check step sequence
        CheckStepSeq := true
      else
        CheckStepSeq := false;

      if (qry.FieldByName(CreatePfxFld(fli_CenterStartOnMove)).AsInteger) = 1 then
        CenterStartOnMove := true
      else
        CenterStartOnMove := false;

      if (qry.FieldByName(CreatePfxFld(fli_WarnOnMoveFinal)).AsInteger) = 1 then
        WarnOnMoveFinal := true
      else
        WarnOnMoveFinal := false;

      DefSchedType := qry.FieldByName(CreatePfxFld(fli_DefSchedType)).AsInteger;
      ConfLevels   := qry.FieldByName(CreatePfxFld(fli_ConfLevels)).AsInteger;
      MoveOption   := qry.FieldByName(CreatePfxFld(fli_MoveOption)).AsInteger;
      ActAutoSched := qry.FieldByName(CreatePfxFld(fli_ActAutoSchedCode)).AsString;
      LastUpdatNr := GetLastUpdatedNumber;
    end
  end;

  qry.Close;
  trs.Commit;

  qry.Free;
  trs.Free
end;

//----------------------------------------------------------------------------//

function EncodeSettings: string;
begin
  with DBAppSettings do
  begin
    if DisableCapRes then
      Result := '1'
    else
      Result := '0';

    if TabResSort then
      Result := Result + '1'
    else
      Result := Result + '0';

    if TabKeepSort then
      Result := Result + '1'
    else
      Result := Result + '0';

    if TabFilterRead then
      Result := Result + '1'
    else
      Result := Result + '0';

    if TabWorkcenter then
      Result := Result + '1'
    else
      Result := Result + '0';

    if TabNoTimings then
      Result := Result + '1'
    else
      Result := Result + '0';

    if TabNoCompat then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColCompVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColStatVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColDelDVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColMatDVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColLowDVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColHigDVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColOvlpVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColDatesVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColSelection then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ShowInBinOnMove then
      Result := Result + '1'
    else
      Result := Result + '0';

    if AutoGroupSingleJob then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ShowGroupLinesInBin then
      Result := Result + '1'
    else
      Result := Result + '0';

     if ShowBinToolBar then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkDelDate then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkMaterials then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkPrevStpQty then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkAddRes then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkLowStart then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkHighEnd then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkLinkOvlp then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ShowRowInBin then
      Result := Result + '1'
    else
      Result := Result + '0';


  end
end;

//----------------------------------------------------------------------------//

procedure DecodeSettings(str: string);
begin
  with DBAppSettings do
  begin
    DisableCapRes := (Copy(str, 1, 1) = '1');
    TabResSort    := (Copy(str, 2, 1) = '1');
    TabKeepSort   := (Copy(str, 3, 1) = '1');
    TabFilterRead := (Copy(str, 4, 1) = '1');
    TabWorkcenter := (Copy(str, 5, 1) = '1');
    TabNoTimings  := (Copy(str, 6, 1) = '1');
    TabNoCompat   := (Copy(str, 7, 1) = '1');
    FixColCompVis := (Copy(str, 8, 1) = '1');
    FixColStatVis := (Copy(str, 9, 1) = '1');
    FixColDelDVis := (Copy(str, 10, 1) = '1');
    FixColMatDVis := (Copy(str, 11, 1) = '1');
    FixColLowDVis := (Copy(str, 12, 1) = '1');
    FixColHigDVis := (Copy(str, 13, 1) = '1');
    FixColOvlpVis := (Copy(str, 14, 1) = '1');
    FixColDatesVis     := (Copy(str, 15, 1) = '1');
    FixColSelection    := (Copy(str, 16, 1) = '1');
    ShowInBinOnMove    := (Copy(str, 17, 1) = '1');
    AutoGroupSingleJob := (Copy(str, 18, 1) = '1');
    ShowGroupLinesInBin := (Copy(str, 19, 1) = '1');
    ShowBinToolBar := (Copy(str, 20, 1) = '1');
    ChkDelDate    := (Copy(str, 21, 1) = '1');
    ChkMaterials  := (Copy(str, 22, 1) = '1');
    ChkPrevStpQty := (Copy(str, 23, 1) = '1');
    ChkAddRes     := (Copy(str, 24, 1) = '1');
    ChkLowStart   := (Copy(str, 25, 1) = '1');
    ChkHighEnd    := (Copy(str, 26, 1) = '1');
    ChkLinkOvlp   := (Copy(str, 27, 1) = '1');
    ShowRowInBin  := (Copy(str, 28, 1) = '1');


  end
end;

//----------------------------------------------------------------------------//

function IsCalendarLoaded: boolean;
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
  rowNum: Integer;
begin
  result := false;
  tbInfo := @tblInfo[tbl_calendar];
  SetFldPfx(tbInfo.pfx);
  rowNum := 0;

  trs := CreateTransaction(Main_DB, true);
  qry := CreateQuery(trs,Main_DB);

  trs.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('select count(*) from ' + tbInfo.PCname );
  qry.Open;

  if not qry.EOF then
    rowNum := qry.FieldByName('count').asInteger;
    
  qry.Close;
  trs.Commit;

  qry.Free;
  trs.Free;

  if rowNum > 0 then
    result := true;

end;

//----------------------------------------------------------------------------//

procedure GlobLoadSettingsValues;
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_appSettings];
  SetFldPfx(tbInfo.pfx);

  trs := CreateTransaction(Cfg_DB, true);
  qry := CreateQuery(trs,Cfg_DB);

  trs.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.PCname + ' where ' + CreatePfxFld(fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.Open;

  if not qry.EOF then
    DecodeSettings(qry.FieldByName(CreatePfxFld(fli_appSettings)).AsString);

  qry.Close;
  trs.Commit;

  qry.Free;
  trs.Free
end;

//----------------------------------------------------------------------------//

procedure GlobSaveSettingsValues;
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_appSettings];
  SetFldPfx(tbInfo.pfx);

  trs := CreateTransaction(Cfg_DB, false);
  qry := CreateQuery(trs,Cfg_DB);

  trs.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('delete from ' +  tbInfo.PCname + ' where ' + CreatePfxFld(fli_wkstCode) + '=''' + IniAppGlobals.WkstCode+'''');
  qry.ExecSQL;
  qry.Close;
  trs.Commit;

  trs.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.PCname + '(');
  qry.SQL.Add(CreatePfxFld(fli_wkstCode)     + ',');
  qry.SQL.Add(CreatePfxFld(fli_appSettings)  + ')');
  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreatePfxFld(fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreatePfxFld(fli_appSettings));
  qry.SQL.Add(')');
  qry.Prepare;

  qry.ParamByName(CreatePfxFld(fli_wkstCode)).AsString    := IniAppGlobals.WkstCode;
  qry.ParamByName(CreatePfxFld(fli_appSettings)).AsString := EncodeSettings;

  qry.ExecSQL;
  qry.Close;
  trs.Commit;

  qry.Free;
  trs.Free
end;

//----------------------------------------------------------------------------//

procedure GlobSaveConfig;
var
  cfg: integer;
begin
  cfg := 0;
  with LocAppGlobals do
  begin
    if IsDevelop then cfg := cfg or CFG_DEVELOP
  end;
  WriteIntToRegistry(RgMqmSezCfg, RgCfgRunMode, cfg)
end;

//----------------------------------------------------------------------------//

procedure SaveColors;
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
  I,J, color:integer;
  ColrCmptTbl : Table;
  Description : String;
begin

  ColrCmptTbl := tbl_cfg_colorJobToJob;
  trs := CreateTransaction(Cfg_DB, false);
  qry := CreateQuery(trs, Cfg_DB);

  for J := 0 to 7 do
  begin
    case J of
      0 : ColrCmptTbl := tbl_cfg_colorJobToJob;
      1 : ColrCmptTbl := tbl_cfg_clrCapToJob;
      2 : ColrCmptTbl := tbl_cfg_colorJobToRes;
      3 : ColrCmptTbl := tbl_cfg_colorStatus;
      4 : ColrCmptTbl := tbl_cfg_colorDateWarn;
      5 : ColrCmptTbl := tbl_cfg_colorMatWarn;
      6 : ColrCmptTbl := tbl_cfg_clrRes;
      7 : ColrCmptTbl := tbl_cfg_clrCapRes;
    end;

    tbInfo := @tblInfo[ColrCmptTbl];
    SetFldPfx(tbInfo.pfx);

    qry.Transaction.Active := true;
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' +  tbInfo.PCname + ' where ' + CreatePfxFld(fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
    qry.ExecSQL;
    qry.Transaction.Commit;
    qry.Close;

    qry.Transaction.Active := true;
    qry.SQL.Clear;
    qry.SQL.Add('insert into ' + tbInfo.PCname + '(');
    qry.SQL.Add(CreatePfxFld(fli_wkstCode) + ',');
    qry.SQL.Add(CreatePfxFld(fli_ValFrom) + ',');
    qry.SQL.Add(CreatePfxFld(fli_intColor) + ',');
    qry.SQL.Add(CreatePfxFld(fli_bdrColor) + ',');

    if J > 2 then   //if we are saving description
    begin
      qry.SQL.Add(CreatePfxFld(fli_txtColor) + ',');
      qry.SQL.Add(CreatePfxFld(fli_txtDescription) + ')');
    end
    else
      qry.SQL.Add(CreatePfxFld(fli_txtColor) + ')');

    qry.SQL.Add(' values (');
    qry.SQL.Add(':' + CreatePfxFld(fli_wkstCode) + ',');
    qry.SQL.Add(':' + CreatePfxFld(fli_ValFrom) + ',');
    qry.SQL.Add(':' + CreatePfxFld(fli_intColor) + ',');
    qry.SQL.Add(':' + CreatePfxFld(fli_bdrColor) + ',');

    if J > 2 then   //if we are saving description
    begin
      qry.SQL.Add(':' + CreatePfxFld(fli_txtColor) + ',');
      qry.SQL.Add(':' + CreatePfxFld(fli_txtDescription));
    end
    else
      qry.SQL.Add(':' + CreatePfxFld(fli_txtColor));

    qry.SQL.Add(')');
    qry.Prepare;

    case J of
      0 : begin

            for i := Low(DBAppGlobals.JobToJobCompColor) to High(DBAppGlobals.JobToJobCompColor) do
            begin
              qry.ParamByName(CreatePfxFld(fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreatePfxFld(fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].int);
              qry.ParamByName(CreatePfxFld(fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].brd);
              qry.ParamByName(CreatePfxFld(fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].txt);
              qry.ParamByName(CreatePfxFld(fli_txtColor)).AsInteger := Color;
              qry.ExecSQL;
            end;
            qry.Transaction.Commit;

          end;

      1 : begin

            for i := Low(DBAppGlobals.JobToCapCompColor) to High(DBAppGlobals.JobToCapCompColor) do
            begin
              qry.ParamByName(CreatePfxFld(fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreatePfxFld(fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].int);
              qry.ParamByName(CreatePfxFld(fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].brd);
              qry.ParamByName(CreatePfxFld(fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].txt);
              qry.ParamByName(CreatePfxFld(fli_txtColor)).AsInteger := Color;
              qry.ExecSQL;
            end;
            qry.Transaction.Commit;

          end;

      2 : begin

            for i := Low(DBAppGlobals.JobCapToRscCompColor) to High(DBAppGlobals.JobCapToRscCompColor) do
            begin
              qry.ParamByName(CreatePfxFld(fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreatePfxFld(fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].int);
              qry.ParamByName(CreatePfxFld(fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].brd);
              qry.ParamByName(CreatePfxFld(fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].txt);
              qry.ParamByName(CreatePfxFld(fli_txtColor)).AsInteger := Color;
              qry.ExecSQL;
            end;
            qry.Transaction.Commit;

          end;

      3 : begin

            for i := Low(DBAppGlobals.JobStatusColor) to High(DBAppGlobals.JobStatusColor) do
            begin
              qry.ParamByName(CreatePfxFld(fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreatePfxFld(fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobStatusColor[I].int);
              qry.ParamByName(CreatePfxFld(fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobStatusColor[I].brd);
              qry.ParamByName(CreatePfxFld(fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobStatusColor[I].txt);
              qry.ParamByName(CreatePfxFld(fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.JobStatusColor[I].dsc;
              qry.ParamByName(CreatePfxFld(Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;
            end;
            qry.Transaction.Commit;

          end;

      4 : begin

            for i := Low(DBAppGlobals.JobDateWarningColor) to High(DBAppGlobals.JobDateWarningColor) do
            begin
              qry.ParamByName(CreatePfxFld(fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreatePfxFld(fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].int);
              qry.ParamByName(CreatePfxFld(fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].brd);
              qry.ParamByName(CreatePfxFld(fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].txt);
              qry.ParamByName(CreatePfxFld(fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.JobDateWarningColor[I].dsc;
              qry.ParamByName(CreatePfxFld(Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;
            end;
            qry.Transaction.Commit;

          end;

      5 : begin

            for i := Low(DBAppGlobals.JobMatWarningColor) to High(DBAppGlobals.JobMatWarningColor) do
            begin
              qry.ParamByName(CreatePfxFld(fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreatePfxFld(fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].int);
              qry.ParamByName(CreatePfxFld(fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].brd);
              qry.ParamByName(CreatePfxFld(fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].txt);
              qry.ParamByName(CreatePfxFld(fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.JobMatWarningColor[I].dsc;
              qry.ParamByName(CreatePfxFld(Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;
            end;
            qry.Transaction.Commit;

          end;

      6 : begin

            for i := Low(DBAppGlobals.ResColors) to High(DBAppGlobals.ResColors) do
            begin
              qry.ParamByName(CreatePfxFld(fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreatePfxFld(fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.ResColors[I].int);
              qry.ParamByName(CreatePfxFld(fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.ResColors[I].brd);
              qry.ParamByName(CreatePfxFld(fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.ResColors[I].txt);
              qry.ParamByName(CreatePfxFld(fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.ResColors[I].dsc;
              qry.ParamByName(CreatePfxFld(Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;
            end;
            qry.Transaction.Commit;

          end;

      7 : begin

            for i := Low(DBAppGlobals.CapResColors) to High(DBAppGlobals.CapResColors) do
            begin
              qry.ParamByName(CreatePfxFld(fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreatePfxFld(fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.CapResColors[I].int);
              qry.ParamByName(CreatePfxFld(fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.CapResColors[I].brd);
              qry.ParamByName(CreatePfxFld(fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.CapResColors[I].txt);
              qry.ParamByName(CreatePfxFld(fli_txtColor)).AsInteger := Color;

              Description := DBAppGlobals.CapResColors[I].dsc;
              qry.ParamByName(CreatePfxFld(Fli_txtDescription)).AsString := Description;
              //CapResDescription := qry.FieldByName(CreatePfxFld(Fli_txtDescription)).AsString;
              //DBAppGlobals.CapResColors[I].txt := CapResDescription ;
              qry.ExecSQL;
            end;
            qry.Transaction.Commit;

          end;

    end;

  end;

  qry.Close;      //Vinc

  qry.free;
  trs.free;
end;

//----------------------------------------------------------------------------//

procedure SavePropBin;
var
  qry:    TMqmQuery;
  trs:    TMqmTransaction;
  tbBinProp : ^TTblInfo;
  i: integer;
begin
  trs := CreateTransaction(Cfg_DB, false);
  qry := CreateQuery(trs, Cfg_DB);

  trs.Active := true;

  // set the property into database

  tbBinProp := @tblInfo[tbl_cfg_bin_showProp];
  SetFldPfx(tbBinProp.pfx);

  with qry do
  begin

    SQL.Clear;
    SQL.Add('delete from ' + tbBinProp.PCname + ' where ' + CreatePfxFld(fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
    ExecSQL;
    Close;

    SQL.Clear;
  //WARNING THE QUERY PARAMETERS ARE ACCESSED BY INDEX!
    SQL.Add('insert into ' + tbBinProp.PCname + '(');
    SQL.Add(CreatePfxFld(fli_wkstCode) + ',');
    for i := 1 to 30 do
    begin
      if i < 30 then
        SQL.Add(CreatePfxFld(fli_FiltPropCode) + IntToStr(i) + ',')
      else
        SQL.Add(CreatePfxFld(fli_FiltPropCode) + IntToStr(i));
    end;
    SQL.Add(') values (');
    SQL.Add(':' + CreatePfxFld(fli_wkstCode) + ',');
    for i := 1 to 30 do
    begin
      if i < 30 then
        SQL.Add(':' + CreatePfxFld(fli_FiltPropCode) + IntToStr(i) + ',')
      else
        SQL.Add(':' + CreatePfxFld(fli_FiltPropCode) + IntToStr(i));
    end;
    SQL.Add(')');
    Prepare;

    ParamByName(CreatePfxFld(fli_wkstCode)).AsString  := IniAppGlobals.WkstCode;

    for i := 1 to 30 do
    begin
      if DBAppGlobals.ShowBinPropArry[I-1] <> nil then
        ParamByName(CreatePfxFld(fli_FiltPropCode) + IntToStr(i)).AsString := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[i-1])
      else
        ParamByName(CreatePfxFld(fli_FiltPropCode) + IntToStr(i)).AsString := '';
    end;

    ExecSQL;

    Close;
  end;

  trs.Commit;

  qry.Free;
  trs.Free;

end;

//----------------------------------------------------------------------------//

procedure GlobSaveIniValues;
begin
  with IniAppGlobals do
  begin
    // Environment
    WriteStrToIniFile(RgMqmSezCfg, RgCfgServer,     Server);

    WriteStrToIniFile(RgMqmSezCfg, RgCfgMainDBPath, MainDBPath);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgMainDBName, MainDBName);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgCfgDBPath,  CfgDBPath);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgCfgDBName,  CfgDBName);

    WriteStrToIniFile(RgMqmSezCfg, RgCfgAS400alias, Alias);

    // Temp DB
    WriteStrToIniFile(RgMqmSezCfg, RgCfgTempDBPath, TempDBPath);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgTempDBName, TempDBName);

    WriteStrToIniFile(RgMqmSezCfg, RgCfgPcalias, PCAlias);
    WriteStrToIniFile(RgMqmSezCfg, RgRepoPlanProp,  FilePlanPropRepo);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgTimeSrvLoop, TimeLoop);
    WriteStrToIniFile(RgMqmSezCfg, RgDwnTypeMode, DwnTypeMode);
    WriteStrToIniFile(RgMqmSezCfg, RgLoopWithMqmCg, DwnLoopWithMqmCg);
    WriteStrToIniFile(RgMqmSezCfg, RgHostDateFormat,  HostDateFormat);
    WriteStrToIniFile(RgMqmSezCfg, RgLoginAuto, LoginAuto);
    WriteStrToIniFile(RgMqmSezCfg, RgUser, User);
    WriteStrToIniFile(RgMqmSezCfg, RgPassword, Password);
    WriteStrToIniFile(RgMqmSezCfg, RgHtmlRowNum, HtmlRowNum);
    WriteStrToIniFile(RgMqmSezCfg, RgShowBinCaption,  ShowBinCaption);
    WriteStrToIniFile(RgMqmSezCfg, RgShowCriteria , ShowCriteria );
    WriteStrToIniFile(RgMqmSezCfg, RgReportComment1, ReportComment1);


//    WriteStrToIniFile(RgMqmSezCfg, RgCfgJobBarTextSet, JobBarTextSet);
//    WriteStrToIniFile(RgMqmSezCfg, RgCfgStatusBarTextSet, StatusBarTextSet);
  end
end;

//----------------------------------------------------------------------------//

procedure GlobSaveValues;
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  ChkStpSeq, CntrStrtOnMove, WrnOnMoveFnl,
  binstate, planstate, TBState : integer;
  tbInfo: ^TTblInfo;
begin
  SaveColors;
  SavePropBin;

  tbInfo := @tblInfo[tbl_cfg_appGlob];
  SetFldPfx(tbInfo.pfx);

  trs := CreateTransaction(Cfg_DB, false);
  qry := CreateQuery(trs, Cfg_DB);

  with LocAppGlobals do
  begin
    WriteStrToRegistry(RgMqmSezCfg, RgCfgImgDir, ImgDir);
    WriteStrToRegistry(RgMqmSezCfg, RgCfgLangDir, LangDir);
  end;

  with IniAppGlobals do
  begin
    // Environment
    WriteStrToIniFile(RgMqmSezCfg, RgCfgLastWkstCode, WkstCode);
  end;

  with DBAppGlobals do
  begin
    qry.Transaction.Active := true;
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' +  tbInfo.PCname + ' where ' + CreatePfxFld(fli_wkstCode) + '=''' + IniAppGlobals.WkstCode+'''');
    qry.ExecSQL;
    qry.Transaction.Commit;
    qry.Close;

    if WdwBinState = true then
       binstate := 1
    else
       binstate := 0;

    if ToolBarState = true then
       TBstate := 1
    else
       TBstate := 0;

    if WdwPlanState = true then
       planstate := 1
    else
      planstate:=0;

    if CheckStepSeq = true then
       ChkStpSeq := 1
    else
       ChkStpSeq := 0;

    if CenterStartOnMove = true then
       CntrStrtOnMove := 1
    else
       CntrStrtOnMove := 0;

    if WarnOnMoveFinal = true then
       WrnOnMoveFnl := 1
    else
       WrnOnMoveFnl := 0;


    with qry do
    begin
      Transaction.Active := true;
      SQL.Clear;
      SQL.Add('insert into ' + tbInfo.PCname + '(');
      SQL.Add(CreatePfxFld(fli_wkstCode)       + ',');
      SQL.Add(CreatePfxFld(fli_EnvDescr)       + ','); // environement description
      SQL.Add(CreatePfxFld(fli_Customer)       + ','); // Customer
      SQL.Add(CreatePfxFld(fli_MqmVersion)     + ','); // Mqm Version
      SQL.Add(CreatePfxFld(fli_MonthBefore)    + ',');
      SQL.Add(CreatePfxFld(fli_StDateForPlan)  + ',');
      SQL.Add(CreatePfxFld(fli_Language)       + ',');
      SQL.Add(CreatePfxFld(fli_CurrTScale)     + ',');
      SQL.Add(CreatePfxFld(fli_CurrDtTime)     + ',');
      SQL.Add(CreatePfxFld(fli_ShowCal)        + ',');
      SQL.Add(CreatePfxFld(fli_CurrRscSort)    + ',');
      SQL.Add(CreatePfxFld(fli_ShowZoom)       + ',');
      SQL.Add(CreatePfxFld(fli_RscOrderType)   + ',');
      SQL.Add(CreatePfxFld(fli_RscOrderItem)   + ',');
      SQL.Add(CreatePfxFld(fli_wdwPlanLeft)    + ',');
      SQL.Add(CreatePfxFld(fli_wdwPlanTop)     + ',');
      SQL.Add(CreatePfxFld(fli_wdwPlanWidth)   + ',');
      SQL.Add(CreatePfxFld(fli_wdwPlanHeight)  + ',');
      SQL.Add(CreatePfxFld(fli_wdwPlanState)   + ',');
      SQL.Add(CreatePfxFld(fli_wdwBinDock)     + ',');
      SQL.Add(CreatePfxFld(fli_wdwBinLeft)     + ',');
      SQL.Add(CreatePfxFld(fli_wdwBinTop)      + ',');
      SQL.Add(CreatePfxFld(fli_wdwBinWidth)    + ',');
      SQL.Add(CreatePfxFld(fli_wdwBinHeight)   + ',');
      SQL.Add(CreatePfxFld(fli_wdwBinState)    + ',');
      SQL.Add(CreatePfxFld(fli_wdwBinSplitter) + ',');

      SQL.Add(CreatePfxFld(fli_ToolBarDock )     + ',');
      SQL.Add(CreatePfxFld(fli_ToolBarLeft)     + ',');
      SQL.Add(CreatePfxFld(fli_ToolBarTop )      + ',');
      SQL.Add(CreatePfxFld(fli_ToolBarWidth)    + ',');
      SQL.Add(CreatePfxFld(fli_ToolBarHeight)   + ',');
      SQL.Add(CreatePfxFld(fli_ToolBarState)    + ',');

      SQL.Add(CreatePfxFld(fli_CheckStepSeq)   + ',');
      SQL.Add(CreatePfxFld(fli_CenterStartOnMove)+ ',');
      SQL.Add(CreatePfxFld(fli_WarnOnMoveFinal) + ',');
      SQL.Add(CreatePfxFld(fli_DefSchedType)   + ',');
      SQL.Add(CreatePfxFld(fli_ConfLevels)      + ',');
      SQL.Add(CreatePfxFld(fli_MoveOption)     + ',');
      SQL.Add(CreatePfxFld(fli_ActAutoSchedCode)   + ')');
      SQL.Add(' values (');
      SQL.Add(':' + CreatePfxFld(fli_wkstCode)       + ',');
      SQL.Add(':' + CreatePfxFld(fli_EnvDescr)       + ','); // environement description
      SQL.Add(':' + CreatePfxFld(fli_Customer)       + ','); // Customer
      SQL.Add(':' + CreatePfxFld(fli_MqmVersion)     + ','); // Mqm Version
      SQL.Add(':' + CreatePfxFld(fli_MonthBefore)    + ',');
      SQL.Add(':' + CreatePfxFld(fli_StDateForPlan)  + ',');
      SQL.Add(':' + CreatePfxFld(fli_Language)       + ',');
      SQL.Add(':' + CreatePfxFld(fli_CurrTScale)     + ',');
      SQL.Add(':' + CreatePfxFld(fli_CurrDtTime)     + ',');
      SQL.Add(':' + CreatePfxFld(fli_ShowCal)        + ',');
      SQL.Add(':' + CreatePfxFld(fli_CurrRscSort)    + ',');
      SQL.Add(':' + CreatePfxFld(fli_ShowZoom)       + ',');
      SQL.Add(':' + CreatePfxFld(fli_RscOrderType)   + ',');
      SQL.Add(':' + CreatePfxFld(fli_RscOrderItem)   + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwPlanLeft)    + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwPlanTop)     + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwPlanWidth)   + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwPlanHeight)  + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwPlanState)   + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwBinDock)     + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwBinLeft)     + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwBinTop)      + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwBinWidth)    + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwBinHeight)   + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwBinState)    + ',');
      SQL.Add(':' + CreatePfxFld(fli_wdwBinSplitter) + ',');

      SQL.Add(':' + CreatePfxFld(fli_ToolBarDock )   + ',');
      SQL.Add(':' + CreatePfxFld(fli_ToolBarLeft)    + ',');
      SQL.Add(':' + CreatePfxFld(fli_ToolBarTop )    + ',');
      SQL.Add(':' + CreatePfxFld(fli_ToolBarWidth)   + ',');
      SQL.Add(':' + CreatePfxFld(fli_ToolBarHeight)  + ',');
      SQL.Add(':' + CreatePfxFld(fli_ToolBarState)   + ',');

      SQL.Add(':' + CreatePfxFld(fli_CheckStepSeq)   + ',');
      SQL.Add(':' + CreatePfxFld(fli_CenterStartOnMove)+ ',');
      SQL.Add(':' + CreatePfxFld(fli_WarnOnMoveFinal)+ ',');
      SQL.Add(':' + CreatePfxFld(fli_DefSchedType)   + ',');
      SQL.Add(':' + CreatePfxFld(fli_ConfLevels)   + ',');
      SQL.Add(':' + CreatePfxFld(fli_MoveOption)   + ',');
      SQL.Add(':' + CreatePfxFld(fli_ActAutoSchedCode));
      SQL.Add(')');
      Prepare;

      ParamByName(CreatePfxFld(fli_wkstCode)).AsString := IniAppGlobals.WkstCode;

      ParamByName(CreatePfxFld(fli_EnvDescr)).AsString        := EnvDescr;
      ParamByName(CreatePfxFld(fli_Customer)).AsString        := Customer;
      ParamByName(CreatePfxFld(fli_MqmVersion)).AsString      := MqmVersion;
      ParamByName(CreatePfxFld(fli_MonthBefore)).AsInteger    := MonthBefore;
      ParamByName(CreatePfxFld(fli_StDateForPlan)).AsDateTime := StDateForPlan;

      ParamByName(CreatePfxFld(fli_Language)).AsString        := Language;
      ParamByName(CreatePfxFld(fli_CurrTScale)).AsSmallInt    := CurrTScale;
      ParamByName(CreatePfxFld(fli_CurrDtTime)).AsDateTime    := CurrDtTime;
      ParamByName(CreatePfxFld(fli_ShowCal)).AsSmallInt       := ShowCal;
      ParamByName(CreatePfxFld(fli_CurrRscSort)).AsSmallInt   := CurrRscSort;
      ParamByName(CreatePfxFld(fli_ShowZoom)).AsSmallInt      := ShowZoom;
      ParamByName(CreatePfxFld(fli_RscOrderType)).AsString    := SelRscOrderType;
      ParamByName(CreatePfxFld(fli_RscOrderItem)).AsString    := SelRscOrderItem;

      ParamByName(CreatePfxFld(fli_wdwPlanLeft)).AsSmallInt   := wdwplanleft;
      ParamByName(CreatePfxFld(fli_wdwPlanTop)).AsSmallInt    := wdwplantop;
      ParamByName(CreatePfxFld(fli_wdwPlanWidth)).AsSmallInt  := wdwplanwidth;
      ParamByName(CreatePfxFld(fli_wdwPlanHeight)).AsSmallInt := wdwplanheight;
      ParamByName(CreatePfxFld(fli_wdwPlanState)).AsSmallInt  := planstate;
      ParamByName(CreatePfxFld(fli_wdwBinDock)).AsSmallInt    := WdwBinDock;
      ParamByName(CreatePfxFld(fli_wdwBinLeft)).AsSmallInt    := WdwBinLeft;
      ParamByName(CreatePfxFld(fli_wdwBinTop)).AsSmallInt     := WdwBinTop;
      ParamByName(CreatePfxFld(fli_wdwBinWidth)).AsSmallInt   := WdwBinWidth;
      ParamByName(CreatePfxFld(fli_wdwBinHeight)).AsSmallInt  := WdwBinHeight;
      ParamByName(CreatePfxFld(fli_wdwBinState)).AsSmallInt   := binstate;
      ParamByName(CreatePfxFld(fli_wdwBinSplitter)).AsSmallInt := WdwBinSplitterH;

      ParamByName(CreatePfxFld(fli_ToolBarDock)).AsSmallInt    := ToolBarDock;
      ParamByName(CreatePfxFld(fli_ToolBarLeft)).AsSmallInt    := ToolBarLeft;
      ParamByName(CreatePfxFld(fli_ToolBarTop )).AsSmallInt    := ToolBarTop;
      ParamByName(CreatePfxFld(fli_ToolBarWidth)).AsSmallInt   := ToolBarWidth;
      ParamByName(CreatePfxFld(fli_ToolBarHeight)).AsSmallInt  := ToolBarHeight;
      ParamByName(CreatePfxFld(fli_ToolBarState)).AsSmallInt   := TBState;
 
      ParamByName(CreatePfxFld(fli_CheckStepSeq)).AsSmallInt   := ChkStpSeq;
      ParamByName(CreatePfxFld(fli_CenterStartOnMove)).AsSmallInt:= CntrStrtOnMove;
      ParamByName(CreatePfxFld(fli_WarnOnMoveFinal)).AsSmallInt:= WrnOnMoveFnl;
      ParamByName(CreatePfxFld(fli_DefSchedType)).AsSmallInt   := DefSchedType;
      ParamByName(CreatePfxFld(fli_ConfLevels)).AsSmallInt     := ConfLevels;
      ParamByName(CreatePfxFld(fli_MoveOption)).AsSmallInt     := MoveOption;
      ParamByName(CreatePfxFld(fli_ActAutoSchedCode)).AsString := ActAutoSched;

      
      ParamByName(CreatePfxFld(fli_wdwPlanLeft)).AsSmallInt   := wdwplanleft;
      ParamByName(CreatePfxFld(fli_wdwPlanTop)).AsSmallInt    := wdwplantop;
      ParamByName(CreatePfxFld(fli_wdwPlanWidth)).AsSmallInt  := wdwplanwidth;
      ParamByName(CreatePfxFld(fli_wdwPlanHeight)).AsSmallInt := wdwplanheight;
      ParamByName(CreatePfxFld(fli_wdwPlanState)).AsSmallInt  := planstate;

      ExecSQL
    end;

    trs.Commit;
    qry.Close;
    qry.free;
    trs.free
  end
end;

//----------------------------------------------------------------------------//

procedure GlobInitPosForm(value : integer);
begin
  // Set the default value for position form
  // value:  -1=All Forms    0=Only Plan    1=Only Bin    2=Only Move
  if value <= 0 then
  begin
    // Form Plan
    with DBAppGlobals do begin
      WdwPlanLeft := 0;
      WdwPlanTop := 0;
      WdwPlanWidth := 500;
      WdwPlanHeight := 400;
      WdwPlanState := false;
    end;
  end;
  if (value = -1) or (value = 1) then
  begin
    // Form Bin
    with DBAppGlobals do begin
      WdwBinDock := -1; // 0=Undocked  1=Right Dock    -1=Bottom Dock
      WdwBinLeft := 0;
      WdwBinTop := 0;
      WdwBinWidth := 500;
      WdwBinHeight := 70;
      WdwBinState := false;
      WdwBinSplitterH := 150;
    end;
  end;
  if (value = -1) or (value = 2) then
  begin
    // Form Move
    with DBAppGlobals do begin
      WdwMoveLeft := 0;
      WdwMoveTop := 0;
      WdwMoveDetails := false
    end
  end
end;

//----------------------------------------------------------------------------//

procedure CheckChangedProperties;
var
  qry:       TMqmQuery;
  trs:       TMqmTransaction;
  tbBinProp :  ^TTblInfo;
  i,j : integer;
begin
  tbBinProp := @tblInfo[tbl_cfg_bin_showProp];
  SetFldPfx(tbBinProp.pfx);

  trs := CreateTransaction(Cfg_DB, true);
  qry := CreateQuery(trs, Cfg_DB);

  for I := Low(DBAppGlobals.ShowBinPropArry) to High(DBAppGlobals.ShowBinPropArry) do
     DBAppGlobals.ShowBinPropArry[I] := nil;

  trs.Active := true;

  // load the Properties to show in Bin

  with qry do
  begin
  //WARNING THE QUERY FIELDS ARE ACCESSED BY INDEX!
    SQL.Add('select');
    for i := 1 to 30 do
    begin
      if i < 30 then
        SQL.Add(CreatePfxFld(fli_FiltPropCode) + IntToStr(i) + ',')
      else
        SQL.Add(CreatePfxFld(fli_FiltPropCode) + IntToStr(i));
    end;
    SQL.Add(' from ' + tbBinProp.PCname);
    SQL.Add(' where ' + CreatePfxFld(fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    Open;
    First;

    J := 0;
    for i := 1 to 30 do
    begin
      if ((FieldByName(CreatePfxFld(fli_FiltPropCode) + IntToStr(i)).AsString) <> '') and
         (GetIdFromCode(FieldByName(CreatePfxFld(fli_FiltPropCode) + IntToStr(i)).AsString) <> nil) then
      begin
        DBAppGlobals.ShowBinPropArry[j] := GetIdFromCode(FieldByName(CreatePfxFld(fli_FiltPropCode) + IntToStr(i)).AsString);
        j := j + 1;
      end
      else
        DBAppGlobals.ShowBinPropArry[j] := nil;
    end;
    Close;
  end;
  trs.Commit;  //Vinc

  qry.Free;    //Vinc
  trs.Free;    //Vinc
end;

//----------------------------------------------------------------------------//

function GetDateForPlanLine(): TDateTime;
var
  qry:      TMqmQuery;
  trs:      TMqmTransaction;
  tbDate: ^TTblInfo;
begin
  Result := now;
  tbDate := @tblInfo[tbl_download_time];

  trs := CreateTransaction(Main_DB, true);
  qry := CreateQuery(trs, Main_DB);

  with qry do
  begin
    Transaction.Active := true;
    SQL.Clear;
    SQL.Add('select ' + CreateFld(tbDate.pfx, fli_downloadTime) + ' from ' + tbDate.PCname );
    open;
    if not qry.EOF then
      Result := fieldByName(CreateFld(tbDate.pfx,fli_downloadTime)).AsDateTime;
    if Result = 0 then Result := now;
    Close
  end;

  trs.Commit;
  qry.Free;
  trs.Free
end;

//----------------------------------------------------------------------------//

initialization

  s_suicide := false;

  s_propMtx[1] := nil;;
  s_rulesRtoOMtx[1] := nil;
  s_rulesRtoOMtx[2] := nil;
  s_rulesOtoOMtx[1] := nil;
  s_rulesOtoOMtx[2] := nil;

  with DBAppSettings do
  begin
    DisableCapRes := false;
    TabResSort    := true;
    TabKeepSort   := true;
    TabFilterRead := false;
    TabWorkcenter := false;
    TabNoTimings  := false;
    TabNoCompat   := false;
    FixColCompVis := true;
    FixColStatVis := true;
    FixColDelDVis := false;
    FixColMatDVis := false;
    FixColLowDVis := false;
    FixColHigDVis := false;
    FixColOvlpVis := true;
    FixColDatesVis  := true;
    FixColSelection := true;
    ShowInBinOnMove := true;
    AutoGroupSingleJob := true;
    ShowGroupLinesInBin := false;
    ShowBinToolBar  := true;
    ChkDelDate    := true;
    ChkMaterials  := true;
    ChkPrevStpQty := true;
    ChkAddRes     := true;
    ChkLowStart   := true;
    ChkHighEnd    := true;
    ChkLinkOvlp   := true;
  end;

  with LocAppGlobals do
  begin
    AppDir   := ExtractFilePath(Application.ExeName);
    AppDrive := AppDir[1];
    ImgDir := 'Images';
    LangDir := 'Languages';

    // Others
    IsDevelop   := false
  end;

  with IniAppGlobals do
  begin
    MainDbPath := LocAppGlobals.AppDir;
    MainDbName := 'MQM_Main.gdb';
    Alias      := '';
    PCAlias    := 'MQM_DBPC';
    CfgDbPath  :=  LocAppGlobals.AppDir;
    CfgDbName  := 'MQM_Cfg.gdb';

    // Temp DB
    TempDbPath  :=  LocAppGlobals.AppDir;
    TempDbName  := 'MQM_TEMP.gdb';

    WkstCode   := 'UNKNOWN';
//    JobBarTextSet := 'Job default';
//    JobBarTextSet := 'Status default';

    FilePlanPropRepo := LocAppGlobals.AppDir + 'PlanPropRepo.htm'
  end;

  with DBAppGlobals do
  begin
    // Environment
    EnvDescr := 'Standard';
    Customer := 'Datatex S.r.l.';
//sav    AdminPC := IsAdmin; // this from UGprogCtrl

    // General Date format string
    MonthBefore := 2;
    StDateForPlan  := IncMonth(trunc(Now), -(MonthBefore));  // Start Date for Plan
    EndDateForPlan := StDateForPlan + 500;
//Sav    StDateForDLoad := IncMonth(trunc(Now)-10 , -(MonthBefore)); // Start Date for Download

    // Setting for Workstation
    Language := GetCurrentLanguage;//'English';

    // Last Setting for Plan
    CurrTScale := 3;
    CurrDtTime := now;
    ShowCal := 0;
    ShowZoom := 20;
    CurrRscSort := 0;  // Code Value for Sort Resources

    // Setting for Select Resources Form
    SelRscOrderType := '';
    SelRscOrderItem := '';

    // Form Position and setting
    GlobInitPosForm(-1);

    //Application preferences
    CheckStepSeq      := false;
    CenterStartOnMove := true;
    WarnOnMoveFinal   := false;
    DefSchedType := 0;
    ConfLevels   := 1;
    MoveOption   := 0;
    ActAutoSched := 'DEFAULT';

    // RELEINFO
    MqmVersion := C_MQM_MAIN_VER + '.' + C_MQM_HOST_DB + '.' +
                  C_MQM_MAIN_PC_DB + '.' + C_MQM_CFG_PC_DB + ' build ' + C_MQM_BUILD;
  end;

//----------------------------------------------------------------------------//
end.




