unit UMBinDefault;

interface

uses
  Windows, DMsrvPc, Dialogs, SysUtils , UMSchedContFunc;

type
  TBinColCurrent = Record
    Field     : CBinColId;
    Title     : string;
    Pos       : integer;
    Width     : integer;
    Visible   : boolean;
    Order     : integer;
    RealPos   : integer;
    PropCode  : string;
    DescendingSort : boolean;
    Index     : integer;
    NumColSorted : Integer;
  end;

  TBinColDefault = Record
    Field     : CBinColId;
    FieldName : string;
    Title     : Integer;
    Pos       : integer;
    Width     : integer;
    Visible   : boolean;
    Order     : integer;
    Index     : integer;
    PropCode  : string;
    NumColSorted : Integer;
  end;

  procedure LoadDefaultBinTabsSet;
  procedure SaveDefaultTabBinSet;
  procedure SaveDefaultTabSlotFilter;
  procedure SaveDefaultTabSearch;
  procedure SaveDefaultTabAutoSeqResults;
  procedure SaveDefaultTabBinMatCompatibleSet;
  procedure SaveDefaultTabJobSchedSequence;

  function  CheckErrorInArrayWidth : boolean;
  function  GetNumberFields : integer;

  procedure CopyBinDefaultTabSlotFilter(var ColArray : array of TBinColCurrent);
  procedure CopyBinDefaultTabSearch(var ColArray : array of TBinColCurrent);
  procedure CopyBinDefaultTabAutoSeqResults(var ColArray : array of TBinColCurrent);
  procedure CopyBinDefaultTabCompatibleWarp(var ColArray : array of TBinColCurrent);
  Procedure CopyBinDefaultSequence(var ColArray : array of TBinColCurrent);

  procedure ConfBinLoadDefaultValues(var ColArray : array of TBinColCurrent);
  procedure ConfBinLoadDefaultValuesSchedJobSeq(var ColArray : array of TBinColCurrent);
  procedure FixOldArrayBinCol(var BinColArray : array of TBinColCurrent; LastEntry: Integer);
  function  GiveTempTitle(I : Integer ; var IsExistProp : boolean ; PropPosition : Integer) : string;
  function  CheckIfBinColIdIsProp(ColId : CBinColId) : boolean;
  procedure OrganizeDefaultTabs;
  procedure OrganizeBinDefaultTabColumnSetForNewPropSet;
  procedure OrganizeBinDefaultTabSlotFilterForNewPropSet;
  procedure OrganizeBinDefaultTabSearchForNewPropSet;
  procedure OrganizeBinDefaultTabAutoSeqResultsForNewPropSet;
  Procedure OrganizeBinDefaultTabSequenceForNewPropSet;
  procedure OrganizeBinDefaultTabTabCompatibleWarpForNewPropSet;

var
  //When changing this also change the  BinColNum const
  BinDefaultTabColumnSet: array [0..151] of TBinColCurrent;
  BinDefaultTabSlotFilter: array [0..151] of TBinColCurrent;
  BinDefaultTabSearch: array [0..151] of TBinColCurrent;
  BinDefaultTabAutoSeqResults: array [0..151] of TBinColCurrent;
  BinDefaultTabCompColumnSet: array [0..151] of TBinColCurrent;
  BinDefaultTabSchedJobSequence: array [0..151] of TBinColCurrent;
  BinDefaultFromDB : boolean;
  BinDefaultFromDB_SchedJobSequence : boolean;
  BinDefaultFromDB_AutoSeqResults : boolean;
  BinDefaultFromDB_Search : boolean;
  BinDefaultFromDB_Slot : boolean;
  BinDefaultFromDB_Material_Compatible : boolean;

  // continue all definitions

const
  BinColNum = 152 ;  //the number of Bin Columns - used at Bar text config
  Titletemp : array [0..151] of string =
//If any of the strings are changed the above notused corresponding
//string should also be changed in file UMBinFunc
  ('Info.',
   'Production req.',
   'Step',
   'Sub step',
   'Re-process',
   'Step group',
   'Actual work center',
   'Actual work center description',
   'Actual process',
   'Actual process description',
   'Planned work center',
   'Planned work center descr.',
   'Planned process',
   'Planned process description',
   'Product type',
   'Product type description',
   'Production line',
   'Product family',
   'Material family',
   'Production um',
   'Um description',
   'Comment',
   'Prod.req earliest date',
   'Prod.req delivery date',
   'Step type',
   'Materials planned date',
   'Plan start',
   'Earliest start',
   'Plan end',
   'Latest end',
   'Calendar',
   'Initial quantity',
   'Final quantity',
   'Weight + um',
   'Step setup time',
   'Step execution time',
   'Planned nbr. of resources',
   'Connection type previous step',
   'Quantity {to} schedule',
   'Scheduled execution time',
   'Scheduled set up time' ,
   'Resource',
   'Resource description',
   'Scheduled start',
   'Scheduled end',
   'Actual start',
   'Actual end',
   'Progress quantity',
   'Progress type',
   'Actual resource',
   'Actual resource description',
   'Backward connected sub step',
   'Backward connected re-process',
   'Forward connected sub step',
   'Forward connect re-process',
   'Actual Time',
   'Sequence',
   'Customized column 1',
   'Prev end date',
   'Next start date',
   'Last Schedule Changed',
   'Shared comment',
   'Customized column 2',
   'Customized column 3',
   'Case to Previous job',
   'Generic plan work center',
   'Generic plan duration',
   'Generic plan lead time',
   'Generic plan machine number',
   'Generic plan start date',
   'Generic plan end date',
   'Serving group code',
   'Serving group lowest date',
   'Prev actual end date',
   'Next actual start date',
   'Customer date',
   'Saved schedule date',
   'Learning curve',
   'Schedule seq.',
   'Schedule seq. Selection',
   'Approval date',
   'First schedule resource',
   'First Schedule start',
   'First schedule end',
   'Version ID.',
   'Schedule resource version',
   'Schedule start version',
   'Schedule end version',
   'Product description',
   'Modified speed',
   'Job components',
   'Machine components',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' '
   );
  //The Index field is a STATIC number - do not change it even when adding new fields to the bin
  //It is needed for the Bar Text config.
  BinColDefault: array [0..151] of TBinColDefault = (
    (Field: CSC_MsgFromHost;       FieldName : 'CSC_MsgFromHost';    Title: 0;  Pos:  0; Width: 40; Visible: true; Order: 54;Index:0; NumColSorted:3),    // info.
    (Field: CSC_ProdReq;           FieldName : 'CSC_ProdReq';        Title: 1;  Pos:  1; Width: 80; Visible: true; Order: 0; Index:1; NumColSorted:3),    // PRODUCTION. REQ.
    (Field: CSC_ProdStep;          FieldName : 'CSC_ProdStep';       Title: 2;  Pos:  2; Width: 80; Visible: true; Order: 1; Index:2; NumColSorted:3),    // STEP
    (Field: CSC_ProdSubStep;       FieldName : 'CSC_ProdSubStep';    Title: 3;  Pos:  3; Width: 80; Visible: true; Order: 2; Index:3; NumColSorted:3),    // SUB STEP
    (Field: CSC_ReprocNo;          FieldName : 'CSC_ReprocNo';       Title: 4;  Pos:  4; Width: 80; Visible: true; Order: 3; Index:4; NumColSorted:3),    // RE - PROCESS
    (Field: CSC_GroupNo;           FieldName : 'CSC_GroupNo';        Title: 5;  Pos:  5; Width: 80; Visible: true; Order: 4; Index:5; NumColSorted:3),    // GROUP
    (Field: CSC_WkctCode;          FieldName : 'CSC_WkctCode';       Title: 6;  Pos:  6; Width: 80; Visible: true; Order: 5; Index:6; NumColSorted:3),    // WORK CENTER
    (Field: CSC_WkctCodeDesc;      FieldName : 'CSC_WkctCodeDesc';   Title: 7;  Pos:  7; Width: 80; Visible: true; Order: 6; Index:7; NumColSorted:3),    // WORK CENTER Desc
    (Field: CSC_WkctProc;          FieldName : 'CSC_WkctProc';       Title: 8;  Pos:  8; Width: 80; Visible: true; Order: 7; Index:8; NumColSorted:3),    // PROCESS
    (Field: CSC_WkctProcDesc;      FieldName : 'CSC_WkctProcDesc';   Title: 9;  Pos:  9; Width: 80; Visible: true; Order: 8; Index:9; NumColSorted:3),    // PROCESS Desc
    (Field: CSC_PlanWkctCode;      FieldName : 'CSC_PlanWkctCode';   Title: 10; Pos: 10; Width: 80; Visible: true; Order: 9; Index:10; NumColSorted:3),    // Planed Work Center
    (Field: CSC_PlanWkctDesc;      FieldName : 'CSC_PlanWkctDesc';   Title: 11; Pos: 11; Width: 80; Visible: true; Order: 10; Index:11; NumColSorted:3),   // Planed Work Center description
    (Field: CSC_PlanWkctProc;      FieldName : 'CSC_PlanWkctProc';   Title: 12; Pos: 12; Width: 80; Visible: true; Order: 11; Index:12; NumColSorted:3),   // Planed process
    (Field: CSC_PlanWkctProcDesc;  FieldName : 'CSC_PlanWkctProcDesc';  Title: 13; Pos: 13; Width: 80; Visible: true; Order: 12; Index:13; NumColSorted:3),   // Planed Process description
    (Field: CSC_ProdType;          FieldName : 'CSC_ProdType';       Title: 14; Pos: 14; Width: 80; Visible: true; Order: 13; Index:14; NumColSorted:3),  // PRODUCT TYPE
    (Field: CSC_ProdTypeDesc;      FieldName : 'CSC_ProdTypeDesc';   Title: 15; Pos: 15; Width: 80; Visible: true; Order: 14; Index:15; NumColSorted:3),  // PRODUCT TYPE Desc
    (Field: CSC_ProdLine;          FieldName : 'CSC_ProdLine';       Title: 16; Pos: 16; Width: 80; Visible: true; Order: 15; Index:16; NumColSorted:3),  // PRODUCTION LINE
    (Field: CSC_ProdFamily;        FieldName : 'CSC_ProdFamily';     Title: 17; Pos: 17; Width: 80; Visible: true; Order: 16; Index:17; NumColSorted:3),  // PRODUCT FAMILY
    (Field: CSC_ProdMatFamily;     FieldName : 'CSC_ProdMatFamily';  Title: 18; Pos: 18; Width: 80; Visible: true; Order: 17; Index:18; NumColSorted:3),  // MATERIAL FAMILY
    (Field: CSC_ProdUM;            FieldName : 'CSC_ProdUM';         Title: 19; Pos: 19; Width: 80; Visible: true; Order: 18; Index:19; NumColSorted:3),  // PRODUCTION UM
    (Field: CSC_ProdUMDesc;        FieldName : 'CSC_ProdUMDesc';     Title: 20; Pos: 20; Width: 80; Visible: true; Order: 19; Index:20; NumColSorted:3),  // PRODUCTION UM Desc
    (Field: CSC_Comment;           FieldName : 'CSC_Comment';        Title: 21; Pos: 21; Width: 80; Visible: true; Order: 20; Index:21; NumColSorted:3),  // COMMENT
    (Field: CSC_LowStartTimeLimit; FieldName : 'CSC_LowStartTimeLimit';  Title: 22; Pos: 22; Width: 80; Visible: true; Order: 21; Index:22; NumColSorted:3),  // PROD.REQ LOWEST DATE
    (Field: CSC_ProdDlvDate;       FieldName : 'CSC_ProdDlvDate';    Title: 23; Pos: 23; Width: 80; Visible: true; Order: 22; Index:23; NumColSorted:3),  // PROD.REQ DELIVERY DATE
    (Field: CSC_StepType;          FieldName : 'CSC_StepType';       Title: 24; Pos: 24; Width: 80; Visible: true; Order: 23; Index:24; NumColSorted:3),  // STEP TYPE
    (Field: CSC_MatArrivalDate;    FieldName : 'CSC_MatArrivalDate'; Title: 25; Pos: 25; Width: 80; Visible: true; Order: 24; Index:25; NumColSorted:3),  // MATERIAL ARRIVAL DATE
    (Field: CSC_PlanStartDate;     FieldName : 'CSC_PlanStartDate';  Title: 26; Pos: 26; Width: 80; Visible: true; Order: 25; Index:26; NumColSorted:3),  // PLAN START
    (Field: CSC_LowStartDate;      FieldName : 'CSC_LowStartDate';   Title: 27; Pos: 27; Width: 80; Visible: true; Order: 26; Index:27; NumColSorted:3),  // LOWEST START
    (Field: CSC_PlanEndDate;       FieldName : 'CSC_PlanEndDate';    Title: 28; Pos: 28; Width: 80; Visible: true; Order: 27; Index:28; NumColSorted:3),  // PLAN END
    (Field: CSC_HighEndLimit;      FieldName : 'CSC_HighEndLimit';   Title: 29; Pos: 29; Width: 80; Visible: true; Order: 28; Index:29; NumColSorted:3),  // HIGHEST END
    (Field: CSC_Calendar;          FieldName : 'CSC_Calendar';       Title: 30; Pos: 30; Width: 80; Visible: true; Order: 29; Index:30; NumColSorted:3),  // CALENDAR
    (Field: CSC_IniQty;            FieldName : 'CSC_IniQty';         Title: 31; Pos: 31; Width: 80; Visible: true; Order: 30; Index:31; NumColSorted:3),  // INITIAL QUANTITY
    (Field: CSC_FinQty;            FieldName : 'CSC_FinQty';         Title: 32; Pos: 32; Width: 80; Visible: true; Order: 31; Index:32; NumColSorted:3),  // FINAL QUANTITY
    (Field: CSC_WeightWithUM;      FieldName : 'CSC_WeightWithUM';   Title: 33; Pos: 33; Width: 80; Visible: true; Order: 32; Index:33; NumColSorted:3),  // WEIGHT + UM
    (Field: CSC_PlanSetup;         FieldName : 'CSC_PlanSetup';      Title: 34; Pos: 34; Width: 80; Visible: true; Order: 33; Index:34; NumColSorted:3),  // PLANED SETUP TIME
    (Field: CSC_ExeTime;           FieldName : 'CSC_ExeTime';        Title: 35; Pos: 35; Width: 80; Visible: true; Order: 34; Index:35; NumColSorted:3),  // PLANED EXECUTION TIME
    (Field: CSC_NumOfRscPlan;      FieldName : 'CSC_NumOfRscPlan';   Title: 36; Pos: 36; Width: 80; Visible: true; Order: 35; Index:36; NumColSorted:3),  // NUMBER OF RESOURCES
    (Field: CSC_ConnTypePrvStep;   FieldName : 'CSC_ConnTypePrvStep'; Title: 37; Pos: 37; Width: 80; Visible: true; Order: 36; Index:37; NumColSorted:3),  // CONNECTION TYPE PREVIOUS STEP
    (Field: CSC_QtyToSched;        FieldName : 'CSC_QtyToSched';     Title: 38; Pos: 38; Width: 80; Visible: true; Order: 37; Index:38; NumColSorted:3),  // QUANTITY TO SCHED
    (Field: CSC_ExeTimeSched;      FieldName : 'CSC_ExeTimeSched';   Title: 49; Pos: 39; Width: 80; Visible: true; Order: 38; Index:39; NumColSorted:3),  // EXECUTION TIME TO SCHED
    (Field: CSC_SupTimeSched;      FieldName : 'CSC_SupTimeSched';   Title: 40; Pos: 40; Width: 80; Visible: true; Order: 39; Index:40; NumColSorted:3),  // SET - UP TIME TO SCHED
    (Field: CSC_Rsc;               FieldName : 'CSC_Rsc';            Title: 41; Pos: 41; Width: 80; Visible: true; Order: 40; Index:41; NumColSorted:3),  // Resource
    (Field: CSC_RscDesc;           FieldName : 'CSC_RscDesc';        Title: 42; Pos: 42; Width: 80; Visible: true; Order: 41; Index:42; NumColSorted:3),  // Resource Desc
    (Field: CSC_SchedStart;        FieldName : 'CSC_SchedStart';     Title: 43; Pos: 43; Width: 80; Visible: true; Order: 42; Index:43; NumColSorted:3),  // SCHED Start
    (Field: CSC_SchedEnd;          FieldName : 'CSC_SchedEnd';       Title: 44; Pos: 44; Width: 80; Visible: true; Order: 43; Index:44; NumColSorted:3),  // SCHED End
    (Field: CSC_ProgStart;         FieldName : 'CSC_ProgStart';      Title: 45; pos: 45; Width: 80; Visible: true; Order: 44; Index:45; NumColSorted:3),  // Progress Start
    (Field: CSC_ProgEnd;           FieldName : 'CSC_ProgEnd';        Title: 46; Pos: 46; Width: 80; Visible: true; Order: 45; Index:46; NumColSorted:3),  // Progress end
    (Field: CSC_ProgQty;           FieldName : 'CSC_ProgQty';        Title: 47; Pos: 47; Width: 80; Visible: true; Order: 46; Index:47; NumColSorted:3),  // Progress qty
    (Field: CSC_ProgType;          FieldName : 'CSC_ProgType';       Title: 48; Pos: 48; Width: 80; Visible: true; Order: 47; Index:48; NumColSorted:3),  // Progress Type
    (Field: CSC_ProgRsc;           FieldName : 'CSC_ProgRsc';        Title: 49; Pos: 49; Width: 80; Visible: true; Order: 48; Index:49; NumColSorted:3),  // Progress Resource
    (Field: CSC_ProgRscDesc;       FieldName : 'CSC_ProgRscDesc';    Title: 50; Pos: 50; Width: 80; Visible: true; Order: 49; Index:50; NumColSorted:3),  // Progress Resource Description
    (Field: CSC_BkwConnSubStp;     FieldName : 'CSC_BkwConnSubStp';  Title: 51; Pos: 51; Width: 80; Visible: true; Order: 50; Index:51; NumColSorted:3),    // BACKWORD CONNECTION SUB STEP
    (Field: CSC_BkwConnReProcs;    FieldName : 'CSC_BkwConnReProcs'; Title: 52; Pos: 52; Width: 80; Visible: true; Order: 51; Index:52; NumColSorted:3),  // BACKWORD CONNECTION RE - PROCESS
    (Field: CSC_FwdConnSubStp;     FieldName : 'CSC_FwdConnSubStp';  Title: 53; Pos: 53; Width: 80; Visible: true; Order: 52; Index:53; NumColSorted:3),    // FORWARD CONNECTION SUB STEP
    (Field: CSC_FwdConnReProcs;    FieldName : 'CSC_FwdConnReProcs'; Title: 54; Pos: 54; Width: 80; Visible: true; Order: 53; Index:54; NumColSorted:3),  // FORWARD CONNECTION RE - PROCESS
    (Field: CSC_ActualTime;        FieldName : 'CSC_ActualTime';     Title: 55; Pos: 55; Width: 80; Visible: true; Order: 55; Index:55; NumColSorted:3),  // ACTUAL TIME
    (Field: CSC_Sequence;          FieldName : 'CSC_Sequence';       Title: 56; Pos: 56; Width: 80; Visible: false; Order: 56; Index:56; NumColSorted:3),  // Sequence
    (Field: CSC_Customized_column1;FieldName : 'CSC_Customized_column1';  Title: 57; Pos: 57; Width: 80; Visible: false; Order: 57; Index:57; NumColSorted:3),  // CSC_Customized_Column1
    (Field: CSC_PrvHighestDate;    FieldName : 'CSC_PrvHighestDate'; Title: 58; Pos: 58; Width: 80; Visible: false; Order: 58; Index:58; NumColSorted:3),  // CSC_PrvHighestDate
    (Field: CSC_NxtLowestDate;     FieldName : 'CSC_NxtLowestDate';  Title: 59; Pos: 59; Width: 80; Visible: false; Order: 59; Index:59; NumColSorted:3),  // CSC_NxtLowestDate
    (Field: CSC_LastScheudleChange; FieldName : 'CSC_LastScheudleChange'; Title: 60; Pos: 60; Width: 80; Visible: false; Order: 60; Index:60; NumColSorted:3),  // CSC_DateTimeOfScheudleChange
    (Field: CSC_SharedComment;     FieldName : 'CSC_SharedComment';  Title: 61; pos: 61; Width: 80; Visible: false; Order: 61; Index:61; NumColSorted:3), // shared comments
    (Field: CSC_Customized_column2;FieldName : 'CSC_Customized_column2';  Title: 62; pos: 62; Width: 80; Visible: false; Order: 62; Index:62; NumColSorted:3), // CSC_Customized_Column2
    (Field: CSC_Customized_column3;FieldName : 'CSC_Customized_column3';  Title: 63; pos: 63; Width: 80; Visible: false; Order: 63; Index:63; NumColSorted:3), // CSC_Customized_Column3
    (Field: CSC_Case_with_prev_job;FieldName : 'CSC_Case_with_prev_job';  Title: 64; pos: 64; Width: 80; Visible: false; Order: 64; Index:64; NumColSorted:3), // CSC_Case_with_prev_job
    (Field: CSC_GenericPlanWC;     FieldName : 'CSC_GenericPlanWC';  Title: 65; pos: 65; Width: 80; Visible: false; Order: 65; Index:65; NumColSorted:3), // CSC_GenericPlanWC
    (Field: CSC_GenericPlanDur;    FieldName : 'CSC_GenericPlanDur'; Title: 66; pos: 66; Width: 80; Visible: false; Order: 66; Index:66; NumColSorted:3), // CSC_GenericPlanDur
    (Field: CSC_GenericPlanLeadTime;FieldName : 'CSC_GenericPlanLeadTime';  Title: 67; pos: 67; Width: 80; Visible: false; Order: 67; Index:67; NumColSorted:3), // CSC_GenericPlanLeadTime
    (Field: CSC_GenericPlanMachineNum;FieldName : 'CSC_GenericPlanMachineNum'; Title: 68; pos: 68; Width: 80; Visible: false; Order: 68; Index:68; NumColSorted:3), // CSC_GenericPlanMachineNum
    (Field: CSC_GenericPlanStartDate;FieldName : 'CSC_GenericPlanStartDate';   Title: 69; pos: 69; Width: 80; Visible: false; Order: 69; Index:69; NumColSorted:3), // CSC_GenericPlanStartDate
    (Field: CSC_GenericPlanEndDate;FieldName : 'CSC_GenericPlanEndDate';       Title: 70; pos: 70; Width: 80; Visible: false; Order: 70; Index:70; NumColSorted:3), // CSC_GenericPlanEndDate
    (Field: CSC_ServingGroupCode;  FieldName : 'CSC_ServingGroupCode'; Title: 71; pos: 71; Width: 80; Visible: false; Order: 71; Index:71; NumColSorted:3), // CSC_ServingGroupCode
    (Field: CSC_ServingGroupLowestDate;  FieldName : 'CSC_ServingGroupLowestDate'; Title: 72; pos: 72; Width: 80; Visible: false; Order: 72; Index:72; NumColSorted:3), // CSC_ServingGroupLowestDate
    (Field: CSC_PrvActualEnd;      FieldName : 'CSC_PrvActualEnd';   Title: 73; pos: 73; Width: 80; Visible: false; Order: 73; Index:73; NumColSorted:3), // CSC_PrvActualEnd
    (Field: CSC_NxtActualStart;    FieldName : 'CSC_NxtActualStart'; Title: 74; pos: 74; Width: 80; Visible: false; Order: 74; Index:74; NumColSorted:3), // CSC_NxtActualStart
    (Field: CSC_CustomerDate;      FieldName : 'CSC_CustomerDate';   Title: 75; pos: 75; Width: 80; Visible: false; Order: 75; Index:75; NumColSorted:3), // CSC_CustomerDate
    (Field: CSC_SavedScheduleDate; FieldName : 'CSC_SavedScheduleDate';   Title: 76; pos: 76; Width: 80; Visible: false; Order: 76; Index:76; NumColSorted:3), // CSC_SavedScheduleDate
    (Field: CSC_CurveCode;         FieldName : 'CSC_CurveCode';      Title: 77; pos: 77; Width: 80; Visible: false; Order: 77; Index:77; NumColSorted:3), // CSC_CurveCode
    (Field: CSC_SchedSeq;          FieldName : 'CSC_SchedSeq';       Title: 78;  Pos: 78; Width: 40; Visible: false; Order: 78; Index:78; NumColSorted:3),    // Sched. Seq.
    (Field: CSC_SeqCB;             FieldName : 'CSC_SeqCB';          Title: 79;  Pos: 79; Width: 40; Visible: false; Order: 79; Index:79; NumColSorted:3),    // CB Seq.
    (Field: CSC_ApprovalDate;      FieldName : 'CSE_ApprovalDate';   Title: 80;  Pos: 80; Width: 40; Visible: false; Order: 80; Index:80; NumColSorted:3),    // CB Seq.
    (Field: CSC_FirstScheduleResource;    FieldName : 'CSC_FirstScheduleResource';   Title: 81;  Pos: 81; Width: 40; Visible: false; Order: 81; Index:81; NumColSorted:3),    // CB Seq.
    (Field: CSC_FirstScheduleStart;       FieldName : 'CSC_FirstScheduleStart';      Title: 82;  Pos: 82; Width: 40; Visible: false; Order: 82; Index:82; NumColSorted:3),    // CB Seq.
    (Field: CSC_FirstScheduleEnd;         FieldName : 'CSC_FirstScheduleEnd';        Title: 83;  Pos: 83; Width: 40; Visible: false; Order: 83; Index:83; NumColSorted:3),    // CB Seq.
    (Field: CSC_VersionIdentifier;        FieldName : 'CSC_VersionIdentifier';       Title: 84;  Pos: 84; Width: 40; Visible: false; Order: 84; Index:84; NumColSorted:3),    // CB Seq.
    (Field: CSC_VersionScheduleResource;  FieldName : 'CSC_VersionScheduleResource'; Title: 85;  Pos: 85; Width: 40; Visible: false; Order: 85; Index:85; NumColSorted:3),    // CB Seq.
    (Field: CSC_VersionScheduleStart;     FieldName : 'CSC_VersionScheduleStart';    Title: 86;  Pos: 86; Width: 40; Visible: false; Order: 86; Index:86; NumColSorted:3),    // CB Seq.
    (Field: CSC_VersionScheduleEnd;       FieldName : 'CSC_VersionScheduleEnd';      Title: 87;  Pos: 87; Width: 40; Visible: false; Order: 87; Index:87; NumColSorted:3),    // CB Seq.
    (Field: CSC_ProductDescription;       FieldName : 'CSC_ProductDescription';      Title: 88;  Pos: 88; Width: 40; Visible: false; Order: 88; Index:88; NumColSorted:3),    // ProductDescription
    (Field: CSC_ModifiedSpeed;     FieldName : 'CSC_ModifiedSpeed';  Title: 89;  Pos: 89; Width: 40; Visible: false; Order: 89; Index:89; NumColSorted:3),    // Modifiedspeed
    (Field: CSC_JobComponents;     FieldName : 'CSC_JobComponents';  Title: 90;  Pos: 90; Width: 40; Visible: false; Order: 90; Index:90; NumColSorted:3),    // CSC_JobComponents
    (Field: CSC_MachineComponents; FieldName : 'CSC_MachineComponents';  Title: 91;  Pos: 91; Width: 40; Visible: false; Order: 91; Index:91; NumColSorted:3),    // CSC_MachineComponents
    (Field: CSC_property1;         FieldName : 'CSC_property1';      Title: 92; pos: 92; Width: 80; Visible: false; Order: 92; Index:92; NumColSorted:3), // Property1
    (Field: CSC_property2;         FieldName : 'CSC_property2';      Title: 93; Pos: 93; Width: 80; Visible: false; Order: 93; Index:93; NumColSorted:3), // Property2
    (Field: CSC_property3;         FieldName : 'CSC_property3';      Title: 94; Pos: 94; Width: 80; Visible: false; Order: 94; Index:94; NumColSorted:3), // Property3
    (Field: CSC_property4;         FieldName : 'CSC_property4';      Title: 95; Pos: 95; Width: 80; Visible: false; Order: 95; Index:95; NumColSorted:3), // Property4
    (Field: CSC_property5;         FieldName : 'CSC_property5';      Title: 96; Pos: 96; Width: 80; Visible: false; Order: 96; Index:96; NumColSorted:3), // Property5
    (Field: CSC_property6;         FieldName : 'CSC_property6';      Title: 97; Pos: 97; Width: 80; Visible: false; Order: 97; Index:97; NumColSorted:3), // Property6
    (Field: CSC_property7;         FieldName : 'CSC_property7';      Title: 98; Pos: 98; Width: 80; Visible: false; Order: 98; Index:98; NumColSorted:3), // Property7
    (Field: CSC_property8;         FieldName : 'CSC_property8';      Title: 99; Pos: 99; Width: 80; Visible: false; Order: 99; Index:99; NumColSorted:3), // Property8
    (Field: CSC_property9;         FieldName : 'CSC_property9';      Title: 100; Pos: 100; Width: 80; Visible: false; Order: 100; Index:100; NumColSorted:3), // Property9
    (Field: CSC_property10;        FieldName : 'CSC_property10';     Title: 101; Pos: 101; Width: 80; Visible: false; Order: 101; Index:101; NumColSorted:3), // Property10
    (Field: CSC_property11;        FieldName : 'CSC_property11';     Title: 102; Pos: 102; Width: 80; Visible: false; Order: 102; Index:102; NumColSorted:3), // Property11
    (Field: CSC_property12;        FieldName : 'CSC_property12';     Title: 103; Pos: 103; Width: 80; Visible: false; Order: 103; Index:103; NumColSorted:3), // Property12
    (Field: CSC_property13;        FieldName : 'CSC_property13';     Title: 104; Pos: 104; Width: 80; Visible: false; Order: 104; Index:104; NumColSorted:3), // Property13
    (Field: CSC_property14;        FieldName : 'CSC_property14';     Title: 105; Pos: 105; Width: 80; Visible: false; Order: 105; Index:105; NumColSorted:3), // Property14
    (Field: CSC_property15;        FieldName : 'CSC_property15';     Title: 106; Pos: 106; Width: 80; Visible: false; Order: 106; Index:106; NumColSorted:3), // Property15
    (Field: CSC_property16;        FieldName : 'CSC_property16';     Title: 107; Pos: 107; Width: 80; Visible: false; Order: 107; Index:107; NumColSorted:3), // Property16
    (Field: CSC_property17;        FieldName : 'CSC_property17';     Title: 108; Pos: 108; Width: 80; Visible: false; Order: 108; Index:108; NumColSorted:3), // Property17
    (Field: CSC_property18;        FieldName : 'CSC_property18';     Title: 109; Pos: 109; Width: 80; Visible: false; Order: 109; Index:109; NumColSorted:3), // Property18
    (Field: CSC_property19;        FieldName : 'CSC_property19';     Title: 110; Pos: 110; Width: 80; Visible: false; Order: 110; Index:110; NumColSorted:3), // Property19
    (Field: CSC_property20;        FieldName : 'CSC_property20';     Title: 111; Pos: 111; Width: 80; Visible: false; Order: 111; Index:111; NumColSorted:3), // Property20
    (Field: CSC_property21;        FieldName : 'CSC_property21';     Title: 112; Pos: 112; Width: 80; Visible: false; Order: 112; Index:112; NumColSorted:3), // Property21
    (Field: CSC_property22;        FieldName : 'CSC_property22';     Title: 113; Pos: 113; Width: 80; Visible: false; Order: 113; Index:113; NumColSorted:3), // Property22
    (Field: CSC_property23;        FieldName : 'CSC_property23';     Title: 114; Pos: 114; Width: 80; Visible: false; Order: 114; Index:114; NumColSorted:3), // Property23
    (Field: CSC_property24;        FieldName : 'CSC_property24';     Title: 115; Pos: 115; Width: 80; Visible: false; Order: 115; Index:115; NumColSorted:3), // Property24
    (Field: CSC_property25;        FieldName : 'CSC_property25';     Title: 116; Pos: 116; Width: 80; Visible: false; Order: 116; Index:116; NumColSorted:3), // Property25
    (Field: CSC_property26;        FieldName : 'CSC_property26';     Title: 117; Pos: 117; Width: 80; Visible: false; Order: 117; Index:117; NumColSorted:3), // Property26
    (Field: CSC_property27;        FieldName : 'CSC_property27';     Title: 118; Pos: 118; Width: 80; Visible: false; Order: 118; Index:118; NumColSorted:3), // Property27
    (Field: CSC_property28;        FieldName : 'CSC_property28';     Title: 119; Pos: 119; Width: 80; Visible: false; Order: 119; Index:119; NumColSorted:3), // Property28
    (Field: CSC_property29;        FieldName : 'CSC_property29';     Title: 120; Pos: 120; Width: 80; Visible: false; Order: 120; Index:120; NumColSorted:3), // Property29
    (Field: CSC_property30;        FieldName : 'CSC_property30';     Title: 121; Pos: 121; Width: 80; Visible: false; Order: 121; Index:121; NumColSorted:3),  // Property30
    (Field: CSC_property31;        FieldName : 'CSC_property31';     Title: 122; pos: 122; Width: 80; Visible: false; Order: 122; Index:122; NumColSorted:3), // Property31
    (Field: CSC_property32;        FieldName : 'CSC_property32';     Title: 123; Pos: 123; Width: 80; Visible: false; Order: 123; Index:123; NumColSorted:3), // Property32
    (Field: CSC_property33;        FieldName : 'CSC_property33';     Title: 124; Pos: 124; Width: 80; Visible: false; Order: 124; Index:124; NumColSorted:3), // Property33
    (Field: CSC_property34;        FieldName : 'CSC_property34';     Title: 125; Pos: 125; Width: 80; Visible: false; Order: 125; Index:125; NumColSorted:3), // Property34
    (Field: CSC_property35;        FieldName : 'CSC_property35';     Title: 126; Pos: 126; Width: 80; Visible: false; Order: 126; Index:126; NumColSorted:3), // Property35
    (Field: CSC_property36;        FieldName : 'CSC_property36';     Title: 127; Pos: 127; Width: 80; Visible: false; Order: 127; Index:127; NumColSorted:3), // Property36
    (Field: CSC_property37;        FieldName : 'CSC_property37';     Title: 128; Pos: 128; Width: 80; Visible: false; Order: 128; Index:128; NumColSorted:3), // Property37
    (Field: CSC_property38;        FieldName : 'CSC_property38';     Title: 129; Pos: 129; Width: 80; Visible: false; Order: 129; Index:129; NumColSorted:3), // Property38
    (Field: CSC_property39;        FieldName : 'CSC_property39';     Title: 130; Pos: 130; Width: 80; Visible: false; Order: 130; Index:130; NumColSorted:3), // Property39
    (Field: CSC_property40;        FieldName : 'CSC_property40';     Title: 131; Pos: 131; Width: 80; Visible: false; Order: 131; Index:131; NumColSorted:3), // Property40
    (Field: CSC_property41;        FieldName : 'CSC_property41';     Title: 132; Pos: 132; Width: 80; Visible: false; Order: 132; Index:132; NumColSorted:3), // Property41
    (Field: CSC_property42;        FieldName : 'CSC_property42';     Title: 133; Pos: 133; Width: 80; Visible: false; Order: 133; Index:133; NumColSorted:3), // Property42
    (Field: CSC_property43;        FieldName : 'CSC_property43';     Title: 134; Pos: 134; Width: 80; Visible: false; Order: 134; Index:134; NumColSorted:3), // Property43
    (Field: CSC_property44;        FieldName : 'CSC_property44';     Title: 135; Pos: 135; Width: 80; Visible: false; Order: 135; Index:135; NumColSorted:3), // Property44
    (Field: CSC_property45;        FieldName : 'CSC_property45';     Title: 136; Pos: 136; Width: 80; Visible: false; Order: 136; Index:136; NumColSorted:3), // Property45
    (Field: CSC_property46;        FieldName : 'CSC_property46';     Title: 137; Pos: 137; Width: 80; Visible: false; Order: 137; Index:137; NumColSorted:3), // Property46
    (Field: CSC_property47;        FieldName : 'CSC_property47';     Title: 138; Pos: 138; Width: 80; Visible: false; Order: 138; Index:138; NumColSorted:3), // Property47
    (Field: CSC_property48;        FieldName : 'CSC_property48';     Title: 139; Pos: 139; Width: 80; Visible: false; Order: 139; Index:139; NumColSorted:3), // Property48
    (Field: CSC_property49;        FieldName : 'CSC_property49';     Title: 140; Pos: 140; Width: 80; Visible: false; Order: 140; Index:140; NumColSorted:3), // Property49
    (Field: CSC_property50;        FieldName : 'CSC_property50';     Title: 141; Pos: 141; Width: 80; Visible: false; Order: 141; Index:141; NumColSorted:3), // Property50
    (Field: CSC_property51;        FieldName : 'CSC_property51';     Title: 142; Pos: 142; Width: 80; Visible: false; Order: 142; Index:142; NumColSorted:3), // Property51
    (Field: CSC_property52;        FieldName : 'CSC_property52';     Title: 143; Pos: 143; Width: 80; Visible: false; Order: 143; Index:143; NumColSorted:3), // Property52
    (Field: CSC_property53;        FieldName : 'CSC_property53';     Title: 144; Pos: 144; Width: 80; Visible: false; Order: 144; Index:144; NumColSorted:3), // Property53
    (Field: CSC_property54;        FieldName : 'CSC_property54';     Title: 145; Pos: 145; Width: 80; Visible: false; Order: 145; Index:145; NumColSorted:3), // Property54
    (Field: CSC_property55;        FieldName : 'CSC_property55';     Title: 146; Pos: 146; Width: 80; Visible: false; Order: 146; Index:146; NumColSorted:3), // Property55
    (Field: CSC_property56;        FieldName : 'CSC_property56';     Title: 147; Pos: 147; Width: 80; Visible: false; Order: 147; Index:147; NumColSorted:3), // Property56
    (Field: CSC_property57;        FieldName : 'CSC_property57';     Title: 148; Pos: 148; Width: 80; Visible: false; Order: 148; Index:148; NumColSorted:3), // Property57
    (Field: CSC_property58;        FieldName : 'CSC_property58';     Title: 149; Pos: 149; Width: 80; Visible: false; Order: 149; Index:149; NumColSorted:3), // Property58
    (Field: CSC_property59;        FieldName : 'CSC_property59';     Title: 150; Pos: 150; Width: 80; Visible: false; Order: 150; Index:150; NumColSorted:3), // Property59
    (Field: CSC_property60;        FieldName : 'CSC_property60';     Title: 151; Pos: 151; Width: 80; Visible: false; Order: 151; Index:151; NumColSorted:3)  // Property60

  );

implementation

uses
  UMCompat,
  UMGlobal,
  UMcommon,
  UMTblDesc,
  Vcl.Forms,
  System.Classes,
  gnugettext;

//----------------------------------------------------------------------------//

function GiveTempTitle(I : Integer ; var IsExistProp : boolean ; PropPosition : Integer) : string;
begin
  IsExistProp := false;

  if i <= PropPosition - 1  then
    Result := _(Titletemp[I])
  else if Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
  begin
    Result := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[i-PropPosition]);
    IsExistProp := true;
  end
  else
    Result := _(Titletemp[I]);
end;

//----------------------------------------------------------------------------//

function CheckIfBinColIdIsProp(ColId : CBinColId) : boolean;
begin
  result := false;
  case ColId of
    CSC_property1,
    CSC_property2,
    CSC_property3,
    CSC_property4,
    CSC_property5,
    CSC_property6,
    CSC_property7,
    CSC_property8,
    CSC_property9,
    CSC_property10,
    CSC_property11,
    CSC_property12,
    CSC_property13,
    CSC_property14,
    CSC_property15,
    CSC_property16,
    CSC_property17,
    CSC_property18,
    CSC_property19,
    CSC_property20,
    CSC_property21,
    CSC_property22,
    CSC_property23,
    CSC_property24,
    CSC_property25,
    CSC_property26,
    CSC_property27,
    CSC_property28,
    CSC_property29,
    CSC_property30,
    CSC_property31,
    CSC_property32,
    CSC_property33,
    CSC_property34,
    CSC_property35,
    CSC_property36,
    CSC_property37,
    CSC_property38,
    CSC_property39,
    CSC_property40,
    CSC_property41,
    CSC_property42,
    CSC_property43,
    CSC_property44,
    CSC_property45,
    CSC_property46,
    CSC_property47,
    CSC_property48,
    CSC_property49,
    CSC_property50,
    CSC_property51,
    CSC_property52,
    CSC_property53,
    CSC_property54,
    CSC_property55,
    CSC_property56,
    CSC_property57,
    CSC_property58,
    CSC_property59,
    CSC_property60 : result := true;
  end;

end;

//----------------------------------------------------------------------------//

procedure OrganizeDefaultTabs;
begin
  OrganizeBinDefaultTabColumnSetForNewPropSet;
  OrganizeBinDefaultTabSlotFilterForNewPropSet;
  OrganizeBinDefaultTabSearchForNewPropSet;
  OrganizeBinDefaultTabAutoSeqResultsForNewPropSet;
  OrganizeBinDefaultTabTabCompatibleWarpForNewPropSet;
  OrganizeBinDefaultTabSequenceForNewPropSet;
end;

//----------------------------------------------------------------------------//

procedure OrganizeBinDefaultTabColumnSetForNewPropSet;
var
  I,J,K,PropPosition, Index : Integer;
  Low, Last, current, HighBinProp : Integer;
  Found : boolean;
  Temparray: array [0..high(DBAppGlobals.ShowBinPropArry)] of TBinColCurrent;
  PropListString : TStringList;
begin
  PropListString := TStringList.create;
  Current := 0;
  Index := 0;
  PropPosition := GetNumberFields;
  Last := -1;

  // Find how many propertyes defined for the planner and keep each defined property in temporary //
  //**********************************************************************************************//
  K := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    //if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    if I = 0 then
    begin
      if (DBAppGlobals.ShowBinPropArry[I] = nil) then
      begin
        for J := PropPosition to High(BinDefaultTabColumnSet) do
        begin
          BinDefaultTabColumnSet[J].PropCode := '';
        end;
        break;
      end
      else
        PropListString.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
    end
    else if (DBAppGlobals.ShowBinPropArry[I] = nil) then
    begin
      for J := PropPosition to High(BinDefaultTabColumnSet) do
      begin
        if PropListString.IndexOf(BinDefaultTabColumnSet[J].PropCode) = -1 then
           BinDefaultTabColumnSet[J].PropCode := '';
      end;
      break;
    end;
    //////////////////

    Index := Index + 1;
    for J := PropPosition to High(BinDefaultTabColumnSet) do
    begin
      if BinDefaultTabColumnSet[J].PropCode <>
          GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Temparray[K].Title    := BinDefaultTabColumnSet[J].Title;
      Temparray[K].Pos      := BinDefaultTabColumnSet[J].Pos;
      Temparray[K].Width    := BinDefaultTabColumnSet[J].Width;
      Temparray[K].Visible  := BinDefaultTabColumnSet[J].Visible;
      Temparray[K].Order    := BinDefaultTabColumnSet[J].Order;
      Temparray[K].PropCode := BinDefaultTabColumnSet[J].PropCode;
      K := K + 1;
      break;
    end;
  end;

  // Loop on all defined properties, and, enter them to bin. If defined before, restore values //
  //*******************************************************************************************//
  PropPosition := GetNumberFields;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    K := I + PropPosition;
    Found := False;

    // Search if the property was kept before //
    for J := 0 to high(DBAppGlobals.ShowBinPropArry) do
    begin
      if Temparray[J].PropCode <> GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Found := True;
      break;
    end;

    BinDefaultTabColumnSet[K].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]);

    if found then
    begin
      BinDefaultTabColumnSet[K].Title    := Temparray[J].Title;
      BinDefaultTabColumnSet[K].Pos      := Temparray[J].Pos;
      BinDefaultTabColumnSet[K].Width    := Temparray[J].Width;
      BinDefaultTabColumnSet[K].Visible  := Temparray[J].Visible;
      BinDefaultTabColumnSet[K].Order    := Temparray[J].Order;
    end
    else
    begin
      BinDefaultTabColumnSet[K].Title    := '';
      BinDefaultTabColumnSet[K].Pos      := 998;
      BinDefaultTabColumnSet[K].Width    := 80;
      BinDefaultTabColumnSet[K].Visible  := true;
      BinDefaultTabColumnSet[K].Order    := 998;
    end;
  end;

  HighBinProp := Index;
  PropPosition := PropPosition + HighBinProp;

  // Compress the order values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabColumnSet[J].order > last) and (BinDefaultTabColumnSet[J].order < Low) then
      begin
        Current := J;
        Low := BinDefaultTabColumnSet[J].order;
       end;
    end;
    Last := BinDefaultTabColumnSet[Current].order;
    if last = 998 then last := 997;
    BinDefaultTabColumnSet[Current].order := I;
  end;

  // Complete the order for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabColumnSet) do
  begin
    BinDefaultTabColumnSet[I].order := I;
  end;

  Last := -1;
  Current := 0;

 // Compress the position values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabColumnSet[J].Pos > last) and (BinDefaultTabColumnSet[J].Pos < Low) then
      begin
        Current := J;
        Low := BinDefaultTabColumnSet[J].Pos;
      end;
    end;
    Last := BinDefaultTabColumnSet[Current].Pos;
    if last = 998 then last := 997;
    BinDefaultTabColumnSet[Current].Pos := I;
  end;

 // Complete the position for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabColumnSet) do
  begin
    BinDefaultTabColumnSet[I].Pos := I;
  end;

  // just be sure that all rest of properties are signed as false

  PropPosition := GetNumberFields;

  for I := PropPosition to high(BinDefaultTabColumnSet) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      BinDefaultTabColumnSet[I].Visible := false;
      BinDefaultTabColumnSet[I].Title := Titletemp[I];
    end;
  end;

  PropListString.Free;
end;

//----------------------------------------------------------------------------//

procedure OrganizeBinDefaultTabSlotFilterForNewPropSet;
var
  I,J,K,PropPosition, Index : Integer;
  Low, Last, current, HighBinProp : Integer;
  Found : boolean;
  Temparray: array [0..high(DBAppGlobals.ShowBinPropArry)] of TBinColCurrent;
  PropListString : TStringList;
begin
  PropListString := TStringList.create;
  Current := 0;
  Index := 0;
  PropPosition := GetNumberFields;
  Last := -1;

  // Find how many propertyes defined for the planner and keep each defined property in temporary //
  //**********************************************************************************************//
  K := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    //if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    if I = 0 then
    begin
      if (DBAppGlobals.ShowBinPropArry[I] = nil) then
      begin
        for J := PropPosition to High(BinDefaultTabSlotFilter) do
        begin
          BinDefaultTabSlotFilter[J].PropCode := '';
        end;
        break;
      end
      else
        PropListString.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
    end
    else if (DBAppGlobals.ShowBinPropArry[I] = nil) then
    begin
      for J := PropPosition to High(BinDefaultTabSlotFilter) do
      begin
        if PropListString.IndexOf(BinDefaultTabSlotFilter[J].PropCode) = -1 then
           BinDefaultTabSlotFilter[J].PropCode := '';
      end;
      break;
    end;
    //////////////////

    Index := Index + 1;
    for J := PropPosition to High(BinDefaultTabSlotFilter) do
    begin
      if BinDefaultTabSlotFilter[J].PropCode <>
          GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Temparray[K].Title    := BinDefaultTabSlotFilter[J].Title;
      Temparray[K].Pos      := BinDefaultTabSlotFilter[J].Pos;
      Temparray[K].Width    := BinDefaultTabSlotFilter[J].Width;
      Temparray[K].Visible  := BinDefaultTabSlotFilter[J].Visible;
      Temparray[K].Order    := BinDefaultTabSlotFilter[J].Order;
      Temparray[K].PropCode := BinDefaultTabSlotFilter[J].PropCode;
      K := K + 1;
      break;
    end;
  end;

  // Loop on all defined properties, and, enter them to bin. If defined before, restore values //
  //*******************************************************************************************//
  PropPosition := GetNumberFields;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    K := I + PropPosition;
    Found := False;

    // Search if the property was kept before //
    for J := 0 to high(DBAppGlobals.ShowBinPropArry) do
    begin
      if Temparray[J].PropCode <> GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Found := True;
      break;
    end;

    BinDefaultTabSlotFilter[K].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]);

    if found then
    begin
      BinDefaultTabSlotFilter[K].Title    := Temparray[J].Title;
      BinDefaultTabSlotFilter[K].Pos      := Temparray[J].Pos;
      BinDefaultTabSlotFilter[K].Width    := Temparray[J].Width;
      BinDefaultTabSlotFilter[K].Visible  := Temparray[J].Visible;
      BinDefaultTabSlotFilter[K].Order    := Temparray[J].Order;
    end
    else
    begin
      BinDefaultTabSlotFilter[K].Title    := '';
      BinDefaultTabSlotFilter[K].Pos      := 998;
      BinDefaultTabSlotFilter[K].Width    := 80;
      BinDefaultTabSlotFilter[K].Visible  := true;
      BinDefaultTabSlotFilter[K].Order    := 998;
    end;
  end;

  HighBinProp := Index;
  PropPosition := PropPosition + HighBinProp;

  // Compress the order values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabSlotFilter[J].order > last) and (BinDefaultTabSlotFilter[J].order < Low) then
      begin
        Current := J;
        Low := BinDefaultTabSlotFilter[J].order;
       end;
    end;
    Last := BinDefaultTabSlotFilter[Current].order;
    if last = 998 then last := 997;
    BinDefaultTabSlotFilter[Current].order := I;
  end;

  // Complete the order for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabSlotFilter) do
  begin
    BinDefaultTabSlotFilter[I].order := I;
  end;

  Last := -1;
  Current := 0;

 // Compress the position values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabSlotFilter[J].Pos > last) and (BinDefaultTabSlotFilter[J].Pos < Low) then
      begin
        Current := J;
        Low := BinDefaultTabSlotFilter[J].Pos;
      end;
    end;
    Last := BinDefaultTabSlotFilter[Current].Pos;
    if last = 998 then last := 997;
    BinDefaultTabSlotFilter[Current].Pos := I;
  end;

 // Complete the position for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabSlotFilter) do
  begin
    BinDefaultTabSlotFilter[I].Pos := I;
  end;

  // just be sure that all rest of properties are signed as false

  PropPosition := GetNumberFields;

  for I := PropPosition to high(BinDefaultTabSlotFilter) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      BinDefaultTabSlotFilter[I].Visible := false;
      BinDefaultTabSlotFilter[I].Title := Titletemp[I];
    end;
  end;

  PropListString.Free;
end;

//----------------------------------------------------------------------------//

procedure OrganizeBinDefaultTabSearchForNewPropSet;
var
  I,J,K,PropPosition, Index : Integer;
  Low, Last, current, HighBinProp : Integer;
  Found : boolean;
  Temparray: array [0..high(DBAppGlobals.ShowBinPropArry)] of TBinColCurrent;
  PropListString : TStringList;
begin
  PropListString := TStringList.create;
  Current := 0;
  Index := 0;
  PropPosition := GetNumberFields;
  Last := -1;

  // Find how many propertyes defined for the planner and keep each defined property in temporary //
  //**********************************************************************************************//
  K := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    //if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    if I = 0 then
    begin
      if (DBAppGlobals.ShowBinPropArry[I] = nil) then
      begin
        for J := PropPosition to High(BinDefaultTabSearch) do
        begin
          BinDefaultTabSearch[J].PropCode := '';
        end;
        break;
      end
      else
        PropListString.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
    end
    else if (DBAppGlobals.ShowBinPropArry[I] = nil) then
    begin
      for J := PropPosition to High(BinDefaultTabSearch) do
      begin
        if PropListString.IndexOf(BinDefaultTabSearch[J].PropCode) = -1 then
           BinDefaultTabSearch[J].PropCode := '';
      end;
      break;
    end;
    //////////////////

    Index := Index + 1;
    for J := PropPosition to High(BinDefaultTabSearch) do
    begin
      if BinDefaultTabSearch[J].PropCode <>
          GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Temparray[K].Title    := BinDefaultTabSearch[J].Title;
      Temparray[K].Pos      := BinDefaultTabSearch[J].Pos;
      Temparray[K].Width    := BinDefaultTabSearch[J].Width;
      Temparray[K].Visible  := BinDefaultTabSearch[J].Visible;
      Temparray[K].Order    := BinDefaultTabSearch[J].Order;
      Temparray[K].PropCode := BinDefaultTabSearch[J].PropCode;
      K := K + 1;
      break;
    end;
  end;

  // Loop on all defined properties, and, enter them to bin. If defined before, restore values //
  //*******************************************************************************************//
  PropPosition := GetNumberFields;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    K := I + PropPosition;
    Found := False;

    // Search if the property was kept before //
    for J := 0 to high(DBAppGlobals.ShowBinPropArry) do
    begin
      if Temparray[J].PropCode <> GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Found := True;
      break;
    end;

    BinDefaultTabSearch[K].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]);

    if found then
    begin
      BinDefaultTabSearch[K].Title    := Temparray[J].Title;
      BinDefaultTabSearch[K].Pos      := Temparray[J].Pos;
      BinDefaultTabSearch[K].Width    := Temparray[J].Width;
      BinDefaultTabSearch[K].Visible  := Temparray[J].Visible;
      BinDefaultTabSearch[K].Order    := Temparray[J].Order;
    end
    else
    begin
      BinDefaultTabSearch[K].Title    := '';
      BinDefaultTabSearch[K].Pos      := 998;
      BinDefaultTabSearch[K].Width    := 80;
      BinDefaultTabSearch[K].Visible  := true;
      BinDefaultTabSearch[K].Order    := 998;
    end;
  end;

  HighBinProp := Index;
  PropPosition := PropPosition + HighBinProp;

  // Compress the order values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabSearch[J].order > last) and (BinDefaultTabSearch[J].order < Low) then
      begin
        Current := J;
        Low := BinDefaultTabSearch[J].order;
       end;
    end;
    Last := BinDefaultTabSearch[Current].order;
    if last = 998 then last := 997;
    BinDefaultTabSearch[Current].order := I;
  end;

  // Complete the order for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabSearch) do
  begin
    BinDefaultTabSearch[I].order := I;
  end;

  Last := -1;
  Current := 0;

 // Compress the position values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabSearch[J].Pos > last) and (BinDefaultTabSearch[J].Pos < Low) then
      begin
        Current := J;
        Low := BinDefaultTabSearch[J].Pos;
      end;
    end;
    Last := BinDefaultTabSearch[Current].Pos;
    if last = 998 then last := 997;
    BinDefaultTabSearch[Current].Pos := I;
  end;

 // Complete the position for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabSearch) do
  begin
    BinDefaultTabSearch[I].Pos := I;
  end;

  // just be sure that all rest of properties are signed as false

  PropPosition := GetNumberFields;

  for I := PropPosition to high(BinDefaultTabSearch) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      BinDefaultTabSearch[I].Visible := false;
      BinDefaultTabSearch[I].Title := Titletemp[I];
    end;
  end;

  PropListString.Free;
end;

//----------------------------------------------------------------------------//

procedure OrganizeBinDefaultTabSequenceForNewPropSet;
var
  I,J,K,PropPosition, Index : Integer;
  Low, Last, current, HighBinProp : Integer;
  Found : boolean;
  Temparray: array [0..high(DBAppGlobals.ShowBinPropArry)] of TBinColCurrent;
  PropListString : TStringList;
begin
  PropListString := TStringList.create;
  Current := 0;
  Index := 0;
  PropPosition := GetNumberFields;
  Last := -1;

  // Find how many propertyes defined for the planner and keep each defined property in temporary //
  //**********************************************************************************************//
  K := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    //if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    if I = 0 then
    begin
      if (DBAppGlobals.ShowBinPropArry[I] = nil) then
      begin
        for J := PropPosition to High(BinDefaultTabSchedJobSequence) do
        begin
          BinDefaultTabSchedJobSequence[J].PropCode := '';
        end;
        break;
      end
      else
        PropListString.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
    end
    else if (DBAppGlobals.ShowBinPropArry[I] = nil) then
    begin
      for J := PropPosition to High(BinDefaultTabSchedJobSequence) do
      begin
        if PropListString.IndexOf(BinDefaultTabSchedJobSequence[J].PropCode) = -1 then
           BinDefaultTabSchedJobSequence[J].PropCode := '';
      end;
      break;
    end;
    //////////////////

    Index := Index + 1;
    for J := PropPosition to High(BinDefaultTabSchedJobSequence) do
    begin
      if BinDefaultTabSchedJobSequence[J].PropCode <>
          GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Temparray[K].Title    := BinDefaultTabSchedJobSequence[J].Title;
      Temparray[K].Pos      := BinDefaultTabSchedJobSequence[J].Pos;
      Temparray[K].Width    := BinDefaultTabSchedJobSequence[J].Width;
      Temparray[K].Visible  := BinDefaultTabSchedJobSequence[J].Visible;
      Temparray[K].Order    := BinDefaultTabSchedJobSequence[J].Order;
      Temparray[K].PropCode := BinDefaultTabSchedJobSequence[J].PropCode;
      K := K + 1;
      break;
    end;
  end;

  // Loop on all defined properties, and, enter them to bin. If defined before, restore values //
  //*******************************************************************************************//
  PropPosition := GetNumberFields;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    K := I + PropPosition;
    Found := False;

    // Search if the property was kept before //
    for J := 0 to high(DBAppGlobals.ShowBinPropArry) do
    begin
      if Temparray[J].PropCode <> GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Found := True;
      break;
    end;

    BinDefaultTabSchedJobSequence[K].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]);

    if found then
    begin
      BinDefaultTabSchedJobSequence[K].Title    := Temparray[J].Title;
      BinDefaultTabSchedJobSequence[K].Pos      := Temparray[J].Pos;
      BinDefaultTabSchedJobSequence[K].Width    := Temparray[J].Width;
      BinDefaultTabSchedJobSequence[K].Visible  := Temparray[J].Visible;
      BinDefaultTabSchedJobSequence[K].Order    := Temparray[J].Order;
    end
    else
    begin
      BinDefaultTabSchedJobSequence[K].Title    := '';
      BinDefaultTabSchedJobSequence[K].Pos      := 998;
      BinDefaultTabSchedJobSequence[K].Width    := 80;
      BinDefaultTabSchedJobSequence[K].Visible  := true;
      BinDefaultTabSchedJobSequence[K].Order    := 998;
    end;
  end;

  HighBinProp := Index;
  PropPosition := PropPosition + HighBinProp;

  // Compress the order values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabSchedJobSequence[J].order > last) and (BinDefaultTabSchedJobSequence[J].order < Low) then
      begin
        Current := J;
        Low := BinDefaultTabSchedJobSequence[J].order;
       end;
    end;
    Last := BinDefaultTabSchedJobSequence[Current].order;
    if last = 998 then last := 997;
    BinDefaultTabSchedJobSequence[Current].order := I;
  end;

  // Complete the order for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabSchedJobSequence) do
  begin
    BinDefaultTabSchedJobSequence[I].order := I;
  end;

  Last := -1;
  Current := 0;

 // Compress the position values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabSchedJobSequence[J].Pos > last) and (BinDefaultTabSchedJobSequence[J].Pos < Low) then
      begin
        Current := J;
        Low := BinDefaultTabSchedJobSequence[J].Pos;
      end;
    end;
    Last := BinDefaultTabSchedJobSequence[Current].Pos;
    if last = 998 then last := 997;
    BinDefaultTabSchedJobSequence[Current].Pos := I;
  end;

 // Complete the position for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabSchedJobSequence) do
  begin
    BinDefaultTabSchedJobSequence[I].Pos := I;
  end;

  // just be sure that all rest of properties are signed as false

  PropPosition := GetNumberFields;

  for I := PropPosition to high(BinDefaultTabSchedJobSequence) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      BinDefaultTabSchedJobSequence[I].Visible := false;
      BinDefaultTabSchedJobSequence[I].Title := Titletemp[I];
    end;
  end;

  PropListString.Free;
end;

procedure OrganizeBinDefaultTabAutoSeqResultsForNewPropSet;
var
  I,J,K,PropPosition, Index : Integer;
  Low, Last, current, HighBinProp : Integer;
  Found : boolean;
  Temparray: array [0..high(DBAppGlobals.ShowBinPropArry)] of TBinColCurrent;
  PropListString : TStringList;
begin
  PropListString := TStringList.create;
  Current := 0;
  Index := 0;
  PropPosition := GetNumberFields;
  Last := -1;

  // Find how many propertyes defined for the planner and keep each defined property in temporary //
  //**********************************************************************************************//
  K := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    //if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    if I = 0 then
    begin
      if (DBAppGlobals.ShowBinPropArry[I] = nil) then
      begin
        for J := PropPosition to High(BinDefaultTabAutoSeqResults) do
        begin
          BinDefaultTabAutoSeqResults[J].PropCode := '';
        end;
        break;
      end
      else
        PropListString.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
    end
    else if (DBAppGlobals.ShowBinPropArry[I] = nil) then
    begin
      for J := PropPosition to High(BinDefaultTabAutoSeqResults) do
      begin
        if PropListString.IndexOf(BinDefaultTabAutoSeqResults[J].PropCode) = -1 then
           BinDefaultTabAutoSeqResults[J].PropCode := '';
      end;
      break;
    end;
    //////////////////

    Index := Index + 1;
    for J := PropPosition to High(BinDefaultTabAutoSeqResults) do
    begin
      if BinDefaultTabAutoSeqResults[J].PropCode <>
          GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Temparray[K].Title    := BinDefaultTabAutoSeqResults[J].Title;
      Temparray[K].Pos      := BinDefaultTabAutoSeqResults[J].Pos;
      Temparray[K].Width    := BinDefaultTabAutoSeqResults[J].Width;
      Temparray[K].Visible  := BinDefaultTabAutoSeqResults[J].Visible;
      Temparray[K].Order    := BinDefaultTabAutoSeqResults[J].Order;
      Temparray[K].PropCode := BinDefaultTabAutoSeqResults[J].PropCode;
      K := K + 1;
      break;
    end;
  end;

  // Loop on all defined properties, and, enter them to bin. If defined before, restore values //
  //*******************************************************************************************//
  PropPosition := GetNumberFields;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    K := I + PropPosition;
    Found := False;

    // Search if the property was kept before //
    for J := 0 to high(DBAppGlobals.ShowBinPropArry) do
    begin
      if Temparray[J].PropCode <> GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Found := True;
      break;
    end;

    BinDefaultTabAutoSeqResults[K].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]);

    if found then
    begin
      BinDefaultTabAutoSeqResults[K].Title    := Temparray[J].Title;
      BinDefaultTabAutoSeqResults[K].Pos      := Temparray[J].Pos;
      BinDefaultTabAutoSeqResults[K].Width    := Temparray[J].Width;
      BinDefaultTabAutoSeqResults[K].Visible  := Temparray[J].Visible;
      BinDefaultTabAutoSeqResults[K].Order    := Temparray[J].Order;
    end
    else
    begin
      BinDefaultTabAutoSeqResults[K].Title    := '';
      BinDefaultTabAutoSeqResults[K].Pos      := 998;
      BinDefaultTabAutoSeqResults[K].Width    := 80;
      BinDefaultTabAutoSeqResults[K].Visible  := true;
      BinDefaultTabAutoSeqResults[K].Order    := 998;
    end;
  end;

  HighBinProp := Index;
  PropPosition := PropPosition + HighBinProp;

  // Compress the order values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabAutoSeqResults[J].order > last) and (BinDefaultTabAutoSeqResults[J].order < Low) then
      begin
        Current := J;
        Low := BinDefaultTabAutoSeqResults[J].order;
       end;
    end;
    Last := BinDefaultTabAutoSeqResults[Current].order;
    if last = 998 then last := 997;
    BinDefaultTabAutoSeqResults[Current].order := I;
  end;

  // Complete the order for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabAutoSeqResults) do
  begin
    BinDefaultTabAutoSeqResults[I].order := I;
  end;

  Last := -1;
  Current := 0;

 // Compress the position values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabAutoSeqResults[J].Pos > last) and (BinDefaultTabAutoSeqResults[J].Pos < Low) then
      begin
        Current := J;
        Low := BinDefaultTabAutoSeqResults[J].Pos;
      end;
    end;
    Last := BinDefaultTabAutoSeqResults[Current].Pos;
    if last = 998 then last := 997;
    BinDefaultTabAutoSeqResults[Current].Pos := I;
  end;

 // Complete the position for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabAutoSeqResults) do
  begin
    BinDefaultTabAutoSeqResults[I].Pos := I;
  end;

  // just be sure that all rest of properties are signed as false

  PropPosition := GetNumberFields;

  for I := PropPosition to high(BinDefaultTabAutoSeqResults) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      BinDefaultTabAutoSeqResults[I].Visible := false;
      BinDefaultTabAutoSeqResults[I].Title := Titletemp[I];
    end;
  end;

  PropListString.Free;
end;

//----------------------------------------------------------------------------//

procedure OrganizeBinDefaultTabTabCompatibleWarpForNewPropSet;
var
  I,J,K,PropPosition, Index : Integer;
  Low, Last, current, HighBinProp : Integer;
  Found : boolean;
  Temparray: array [0..high(DBAppGlobals.ShowBinPropArry)] of TBinColCurrent;
  PropListString : TStringList;
begin
  PropListString := TStringList.create;
  Current := 0;
  Index := 0;
  PropPosition := GetNumberFields;
  Last := -1;

  // Find how many propertyes defined for the planner and keep each defined property in temporary //
  //**********************************************************************************************//
  K := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    //if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    if I = 0 then
    begin
      if (DBAppGlobals.ShowBinPropArry[I] = nil) then
      begin
        for J := PropPosition to High(BinDefaultTabCompColumnSet) do
        begin
          BinDefaultTabCompColumnSet[J].PropCode := '';
        end;
        break;
      end
      else
        PropListString.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
    end
    else if (DBAppGlobals.ShowBinPropArry[I] = nil) then
    begin
      for J := PropPosition to High(BinDefaultTabCompColumnSet) do
      begin
        if PropListString.IndexOf(BinDefaultTabCompColumnSet[J].PropCode) = -1 then
           BinDefaultTabCompColumnSet[J].PropCode := '';
      end;
      break;
    end;
    //////////////////

    Index := Index + 1;
    for J := PropPosition to High(BinDefaultTabCompColumnSet) do
    begin
      if BinDefaultTabCompColumnSet[J].PropCode <>
          GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Temparray[K].Title    := BinDefaultTabCompColumnSet[J].Title;
      Temparray[K].Pos      := BinDefaultTabCompColumnSet[J].Pos;
      Temparray[K].Width    := BinDefaultTabCompColumnSet[J].Width;
      Temparray[K].Visible  := BinDefaultTabCompColumnSet[J].Visible;
      Temparray[K].Order    := BinDefaultTabCompColumnSet[J].Order;
      Temparray[K].PropCode := BinDefaultTabCompColumnSet[J].PropCode;
      K := K + 1;
      break;
    end;
  end;

  // Loop on all defined properties, and, enter them to bin. If defined before, restore values //
  //*******************************************************************************************//
  PropPosition := GetNumberFields;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    K := I + PropPosition;
    Found := False;

    // Search if the property was kept before //
    for J := 0 to high(DBAppGlobals.ShowBinPropArry) do
    begin
      if Temparray[J].PropCode <> GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Found := True;
      break;
    end;

    BinDefaultTabCompColumnSet[K].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]);

    if found then
    begin
      BinDefaultTabCompColumnSet[K].Title    := Temparray[J].Title;
      BinDefaultTabCompColumnSet[K].Pos      := Temparray[J].Pos;
      BinDefaultTabCompColumnSet[K].Width    := Temparray[J].Width;
      BinDefaultTabCompColumnSet[K].Visible  := Temparray[J].Visible;
      BinDefaultTabCompColumnSet[K].Order    := Temparray[J].Order;
    end
    else
    begin
      BinDefaultTabCompColumnSet[K].Title    := '';
      BinDefaultTabCompColumnSet[K].Pos      := 998;
      BinDefaultTabCompColumnSet[K].Width    := 80;
      BinDefaultTabCompColumnSet[K].Visible  := true;
      BinDefaultTabCompColumnSet[K].Order    := 998;
    end;
  end;

  HighBinProp := Index;
  PropPosition := PropPosition + HighBinProp;

  // Compress the order values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabCompColumnSet[J].order > last) and (BinDefaultTabCompColumnSet[J].order < Low) then
      begin
        Current := J;
        Low := BinDefaultTabCompColumnSet[J].order;
       end;
    end;
    Last := BinDefaultTabCompColumnSet[Current].order;
    if last = 998 then last := 997;
    BinDefaultTabCompColumnSet[Current].order := I;
  end;

  // Complete the order for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabCompColumnSet) do
  begin
    BinDefaultTabCompColumnSet[I].order := I;
  end;

  Last := -1;
  Current := 0;

 // Compress the position values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinDefaultTabCompColumnSet[J].Pos > last) and (BinDefaultTabCompColumnSet[J].Pos < Low) then
      begin
        Current := J;
        Low := BinDefaultTabCompColumnSet[J].Pos;
      end;
    end;
    Last := BinDefaultTabCompColumnSet[Current].Pos;
    if last = 998 then last := 997;
    BinDefaultTabCompColumnSet[Current].Pos := I;
  end;

 // Complete the position for the remaining no-handled properties //
  for I := PropPosition to High(BinDefaultTabCompColumnSet) do
  begin
    BinDefaultTabCompColumnSet[I].Pos := I;
  end;

  // just be sure that all rest of properties are signed as false

  PropPosition := GetNumberFields;

  for I := PropPosition to high(BinDefaultTabCompColumnSet) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      BinDefaultTabCompColumnSet[I].Visible := false;
      BinDefaultTabCompColumnSet[I].Title := Titletemp[I];
    end;
  end;

  PropListString.Free;
end;

//----------------------------------------------------------------------------//

procedure CopyBinDefaultTabSlotFilter(var ColArray : array of TBinColCurrent);
var
  J : Integer;
begin
  for J := low(BinDefaultTabSlotFilter) to high(BinDefaultTabSlotFilter) do
  begin
    ColArray[J].Field := BinDefaultTabSlotFilter[J].Field;
    ColArray[J].Title := BinDefaultTabSlotFilter[J].Title;
    ColArray[J].Pos   := BinDefaultTabSlotFilter[J].Pos;
    ColArray[J].Width := BinDefaultTabSlotFilter[J].Width;
    ColArray[J].Visible := BinDefaultTabSlotFilter[J].Visible;
    ColArray[J].Order := BinDefaultTabSlotFilter[J].Order;
    ColArray[J].PropCode := BinDefaultTabSlotFilter[J].PropCode;
    ColArray[J].RealPos := BinDefaultTabSlotFilter[J].RealPos;
    ColArray[J].NumColSorted := BinDefaultTabSlotFilter[J].NumColSorted;
  end;
end;

//----------------------------------------------------------------------------//

procedure CopyBinDefaultTabSearch(var ColArray : array of TBinColCurrent);
var
  J : Integer;
begin
  for J := low(BinDefaultTabSearch) to high(BinDefaultTabSearch) do
  begin
    ColArray[J].Field := BinDefaultTabSearch[J].Field;
    ColArray[J].Title := BinDefaultTabSearch[J].Title;
    ColArray[J].Pos   := BinDefaultTabSearch[J].Pos;
    ColArray[J].Width := BinDefaultTabSearch[J].Width;
    ColArray[J].Visible := BinDefaultTabSearch[J].Visible;
    ColArray[J].Order    := BinDefaultTabSearch[J].Order;
    ColArray[J].PropCode := BinDefaultTabSearch[J].PropCode;
    ColArray[J].RealPos := BinDefaultTabSearch[J].RealPos;
    ColArray[J].NumColSorted := BinDefaultTabSlotFilter[J].NumColSorted;
  end;
end;

//----------------------------------------------------------------------------//

procedure CopyBinDefaultSequence(var ColArray : array of TBinColCurrent);
var
  J : Integer;
begin
  for J := low(BinDefaultTabSchedJobSequence) to high(BinDefaultTabSchedJobSequence) do
  begin
    ColArray[J].Field := BinDefaultTabSchedJobSequence[J].Field;
    ColArray[J].Title := BinDefaultTabSchedJobSequence[J].Title;
    ColArray[J].Pos   := BinDefaultTabSchedJobSequence[J].Pos;
    ColArray[J].Width := BinDefaultTabSchedJobSequence[J].Width;
    ColArray[J].Visible := BinDefaultTabSchedJobSequence[J].Visible;
    ColArray[J].Order := BinDefaultTabSchedJobSequence[J].Order;
    ColArray[J].PropCode := BinDefaultTabSchedJobSequence[J].PropCode;
    ColArray[J].RealPos := BinDefaultTabSchedJobSequence[J].RealPos;
    ColArray[J].NumColSorted := BinDefaultTabSchedJobSequence[J].NumColSorted;
  end;
end;

procedure CopyBinDefaultTabAutoSeqResults(var ColArray : array of TBinColCurrent);
var
  J : Integer;
begin
  for J := low(BinDefaultTabAutoSeqResults) to high(BinDefaultTabAutoSeqResults) do
  begin
    ColArray[J].Field := BinDefaultTabAutoSeqResults[J].Field;
    ColArray[J].Title := BinDefaultTabAutoSeqResults[J].Title;
    ColArray[J].Pos   := BinDefaultTabAutoSeqResults[J].Pos;
    ColArray[J].Width := BinDefaultTabAutoSeqResults[J].Width;
    ColArray[J].Visible := BinDefaultTabAutoSeqResults[J].Visible;
    ColArray[J].Order := BinDefaultTabAutoSeqResults[J].Order;
    ColArray[J].PropCode := BinDefaultTabAutoSeqResults[J].PropCode;
    ColArray[J].RealPos := BinDefaultTabAutoSeqResults[J].RealPos;
    ColArray[J].NumColSorted := BinDefaultTabSlotFilter[J].NumColSorted;
  end;
end;

//----------------------------------------------------------------------------//

procedure CopyBinDefaultTabCompatibleWarp(var ColArray : array of TBinColCurrent);
var
  J : Integer;
begin
  for J := low(BinDefaultTabCompColumnSet) to high(BinDefaultTabCompColumnSet) do
  begin
    ColArray[J].Field := BinDefaultTabCompColumnSet[J].Field;
    ColArray[J].Title := BinDefaultTabCompColumnSet[J].Title;
    ColArray[J].Pos   := BinDefaultTabCompColumnSet[J].Pos;
    ColArray[J].Width := BinDefaultTabCompColumnSet[J].Width;
    ColArray[J].Visible := BinDefaultTabCompColumnSet[J].Visible;
    ColArray[J].Order := BinDefaultTabCompColumnSet[J].Order;
    ColArray[J].PropCode := BinDefaultTabCompColumnSet[J].PropCode;
    ColArray[J].RealPos := BinDefaultTabCompColumnSet[J].RealPos;
    ColArray[J].NumColSorted := BinDefaultTabCompColumnSet[J].NumColSorted;
  end;
end;

//----------------------------------------------------------------------------//

procedure ConfBinLoadDefaultValuesSchedJobSeq(var ColArray : array of TBinColCurrent);
var
  i, y : integer;
  IsExistProp : boolean;
  PropPosition : Integer;
  TempTitle : string;
begin
  PropPosition := GetNumberFields;

  // Load default configuration
  for i := low(ColArray) to high(ColArray) do
  begin
    ColArray[i].Field := BinColDefault[i].Field;
//    ColArray[i].Title := GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);
    TempTitle := GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);
    if IsExistProp then
      ColArray[i].PropCode := TempTitle
    else
      ColArray[i].Title := TempTitle;
    ColArray[i].Pos     := BinColDefault[i].Pos;
    ColArray[i].Width   := BinColDefault[i].Width;
    if IsExistProp then
      ColArray[i].Visible := true
    else
      ColArray[i].Visible := BinColDefault[i].Visible;
    ColArray[i].Order   := BinColDefault[i].Order;
    ColArray[i].NumColSorted := BinColDefault[i].NumColSorted;
  end;

  y := 1;
  for i := low(ColArray) to high(ColArray) do
  begin
    if ColArray[i].Field = CSC_SchedSeq then
    begin
      ColArray[i].Pos   := 0;
      ColArray[i].Visible := true

    end else if ColArray[i].Field = CSC_SeqCB then
    begin
      ColArray[i].Pos   := 1;
      ColArray[i].Visible := true
    end else
    begin
      ColArray[i].Pos   := y + 1;
      inc(y);
    end;

  end;

end;

procedure ConfBinLoadDefaultValues(var ColArray : array of TBinColCurrent);
var
  i : integer;
  IsExistProp : boolean;
  PropPosition : Integer;
  TempTitle : string;
begin
  PropPosition := GetNumberFields;

  // Load default configuration
  for i := low(ColArray) to high(ColArray) do
  begin
    ColArray[i].Field := BinColDefault[i].Field;
//    ColArray[i].Title := GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);
    TempTitle := GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);
    if IsExistProp then
      ColArray[i].PropCode := TempTitle
    else
      ColArray[i].Title := TempTitle;
    ColArray[i].Pos     := BinColDefault[i].Pos;
    ColArray[i].Width   := BinColDefault[i].Width;
    if IsExistProp then
      ColArray[i].Visible := true
    else
      ColArray[i].Visible := BinColDefault[i].Visible;
    ColArray[i].Order   := BinColDefault[i].Order;
    ColArray[i].NumColSorted := BinColDefault[i].NumColSorted;
  end;

end;

//----------------------------------------------------------------------------//

procedure FixOldArrayBinCol(var BinColArray : array of TBinColCurrent; LastEntry: Integer);
var
  I,J, AttributesAdded, TmpIndex : Integer;
begin
//  if LastEntry > 87 then exit;
  AttributesAdded := High(BinColDefault) + 1 - LastEntry;
  if AttributesAdded = 0 then exit;

  for I := High(BinColDefault) downto GetNumberFields  do
  begin
    J := I - AttributesAdded;
    BinColArray[I].Field := BinColArray[J].Field;
    BinColArray[I].Title := BinColArray[J].Title;
    BinColArray[I].Pos := BinColArray[J].Pos;
    BinColArray[I].Width := BinColArray[J].Width;
    BinColArray[I].Visible := BinColArray[J].Visible;
    BinColArray[I].Order := BinColArray[J].Order;
    BinColArray[I].RealPos := BinColArray[J].RealPos;
    BinColArray[I].PropCode := BinColArray[J].PropCode;
    BinColArray[I].Index := BinColArray[J].Index;
  end;

  TmpIndex := High(BinColDefault) + 1 - AttributesAdded;
  for I := (GetNumberFields - AttributesAdded) to GetNumberFields - 1  do
  begin
    BinColArray[I].Title := Titletemp[I];
    BinColArray[I].Pos := TmpIndex;
    BinColArray[I].Order := TmpIndex;
    BinColArray[I].Width := 80;
    BinColArray[I].Visible := false;
    BinColArray[I].PropCode := '';
    BinColArray[I].RealPos := 0;
    BinColArray[I].Index := 0;
    TmpIndex := TmpIndex + 1;
  end;

{  if LastEntry = 86 then
  begin
    BinColArray[56].Title := Titletemp[56];
    BinColArray[56].Pos := 86;
    BinColArray[56].Order := 86;
    BinColArray[56].Width := 80;
    BinColArray[56].Visible := false;
    BinColArray[56].PropCode := '';
    BinColArray[56].RealPos := 0;
    BinColArray[56].Index := 0;
  end;

  if (LastEntry = 86) or (LastEntry = 87) then
  begin

    BinColArray[57].Title := Titletemp[57];
    BinColArray[57].Pos := 87;
    BinColArray[57].Order := 87;
    BinColArray[57].Width := 80;
    BinColArray[57].Visible := false;
    BinColArray[57].PropCode := '';
    BinColArray[57].RealPos := 0;
    BinColArray[57].Index := 0;

  end;    }

  for I := Low(BinColDefault) to High(BinColDefault) do
    BinColArray[I].Field := BinColDefault[I].Field;
  Application.ProcessMessages;
end;

//----------------------------------------------------------------------------//

procedure LoadBinDefaultTabSchedJobSequenceResults;
var
  I   : Integer;
  qry : TMqmQuery;
  tbInfo:   ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
//  SetFldPfx(tbInfo.pfx);
  qry := CreateQuery(Cfg_DB);

  qry.SQL.Clear;
  qry.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-7''');
//  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TypeOfUse) + ' <> ''' + '1''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(' Order by ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.SQL.Add(' , ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.Open;
  qry.First;

  if qry.Eof then
    ConfBinLoadDefaultValuesSchedJobSeq(BinDefaultTabSchedJobSequence)
  else
  begin
    BinDefaultFromDB_SchedJobSequence := true;
    I := 0;
    while (not qry.EOF) do
    begin
      BinDefaultTabSchedJobSequence[I].Field := BinColDefault[qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger].Field;
      BinDefaultTabSchedJobSequence[I].Title   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString;
      BinDefaultTabSchedJobSequence[I].Pos     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger;
      BinDefaultTabSchedJobSequence[I].Width   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger;
      if qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger = 1 then
        BinDefaultTabSchedJobSequence[I].Visible := true
      else
        BinDefaultTabSchedJobSequence[I].Visible := false;
      BinDefaultTabSchedJobSequence[I].PropCode  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString;
      BinDefaultTabSchedJobSequence[I].Order   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger;
      BinDefaultTabSchedJobSequence[I].NumColSorted   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger;
      Inc(I);
      qry.Next;
      Application.ProcessMessages;
    end;

    FixOldArrayBinCol(BinDefaultTabSchedJobSequence,  I);

  end;
  qry.Close;
  qry.Free;
end;

procedure LoadBinDefaultTabAutoSeqResults;
var
  I   : Integer;
  qry : TMqmQuery;
  tbInfo:   ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
//  SetFldPfx(tbInfo.pfx);
  qry := CreateQuery(Cfg_DB);

  qry.SQL.Clear;
  qry.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-4''');
//  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TypeOfUse) + ' <> ''' + '1''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(' Order by ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.SQL.Add(' , ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.Open;
  qry.First;

  if qry.Eof then
    ConfBinLoadDefaultValues(BinDefaultTabAutoSeqResults)
  else
  begin
    BinDefaultFromDB_AutoSeqResults := true;
    I := 0;
    while (not qry.EOF) do
    begin
      BinDefaultTabAutoSeqResults[I].Field := BinColDefault[qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger].Field;
      BinDefaultTabAutoSeqResults[I].Title   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString;
      BinDefaultTabAutoSeqResults[I].Pos     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger;
      BinDefaultTabAutoSeqResults[I].Width   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger;
      if qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger = 1 then
        BinDefaultTabAutoSeqResults[I].Visible := true
      else
        BinDefaultTabAutoSeqResults[I].Visible := false;
      BinDefaultTabAutoSeqResults[I].PropCode  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString;
      BinDefaultTabAutoSeqResults[I].Order   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger;
      BinDefaultTabAutoSeqResults[I].NumColSorted   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger;
      Inc(I);
      qry.Next;
      Application.ProcessMessages;
    end;

    FixOldArrayBinCol(BinDefaultTabAutoSeqResults,  I);

  end;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure LoadBinDefaultTabSearch;
var
  I   : Integer;
  qry : TMqmQuery;
  tbInfo:   ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
//  SetFldPfx(tbInfo.pfx);
  qry := CreateQuery(Cfg_DB);
  qry.SQL.Clear;
  qry.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-3''');
//  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TypeOfUse) + ' <> ''' + '1''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(' Order by ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.SQL.Add(' , ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.Open;
  qry.First;

  if qry.Eof then
    ConfBinLoadDefaultValues(BinDefaultTabSearch)
  else
  begin
    BinDefaultFromDB_Search := true;
    I := 0;
    while (not qry.EOF) do
    begin
      BinDefaultTabSearch[I].Field := BinColDefault[qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger].Field;
      BinDefaultTabSearch[I].Title   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString;
      BinDefaultTabSearch[I].Pos     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger;
      BinDefaultTabSearch[I].Width   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger;
      if qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger = 1 then
        BinDefaultTabSearch[I].Visible := true
      else
        BinDefaultTabSearch[I].Visible := false;
      BinDefaultTabSearch[I].PropCode  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString;
      BinDefaultTabSearch[I].Order   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger;
      BinDefaultTabSearch[I].NumColSorted   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger;
      Inc(I);
      qry.Next;
      Application.ProcessMessages;
    end;

    FixOldArrayBinCol(BinDefaultTabSearch,  I);

  end;
  qry.Close;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure LoadBinDefaultTabSlotFilter;
var
  I   : Integer;
  qry : TMqmQuery;
  tbInfo:   ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
//  SetFldPfx(tbInfo.pfx);
  qry := CreateQuery(Cfg_DB);

  qry.SQL.Clear;
  qry.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-2''');
//  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TypeOfUse) + ' <> ''' + '1''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(' Order by ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.SQL.Add(' , ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.Open;
  qry.First;

  if qry.Eof then
    ConfBinLoadDefaultValues(BinDefaultTabSlotFilter)
  else
  begin
    BinDefaultFromDB_Slot := true;
    I := 0;
    while (not qry.EOF) do
    begin
      BinDefaultTabSlotFilter[I].Field := BinColDefault[qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger].Field;
      BinDefaultTabSlotFilter[I].Title   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString;
      BinDefaultTabSlotFilter[I].Pos     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger;
      BinDefaultTabSlotFilter[I].Width   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger;
      if qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger = 1 then
        BinDefaultTabSlotFilter[I].Visible := true
      else
        BinDefaultTabSlotFilter[I].Visible := false;
      BinDefaultTabSlotFilter[I].PropCode  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString;
      BinDefaultTabSlotFilter[I].Order   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger;
      BinDefaultTabSlotFilter[I].NumColSorted   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger;
      Inc(I);
      qry.Next;
      Application.ProcessMessages;
    end;

    FixOldArrayBinCol(BinDefaultTabSlotFilter,  I);

  end;
  qry.Close;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure LoadDefaultBinTabSet;
var
  I   : Integer;
  qry : TMqmQuery;
  tbInfo:   ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
  qry := CreateQuery(Cfg_DB);
  qry.SQL.Clear;
  qry.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-1''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(' Order by ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.SQL.Add(' , ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.Open;
  qry.First;

  if qry.Eof then
    ConfBinLoadDefaultValues(BinDefaultTabColumnSet)
  else
  begin
    BinDefaultFromDB := true;
    I := 0;
    while (not qry.EOF) do
    begin
      BinDefaultTabColumnSet[I].Field := BinColDefault[qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger].Field;
      BinDefaultTabColumnSet[I].Title   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString;
      BinDefaultTabColumnSet[I].Pos     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger;
      BinDefaultTabColumnSet[I].Width   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger;
      if qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger = 1 then
        BinDefaultTabColumnSet[I].Visible := true
      else
        BinDefaultTabColumnSet[I].Visible := false;
      BinDefaultTabColumnSet[I].PropCode  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString;
      BinDefaultTabColumnSet[I].Order   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger;
      BinDefaultTabColumnSet[I].NumColSorted   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger;
      Inc(I);
      qry.Next;
      Application.ProcessMessages;
    end;

    FixOldArrayBinCol(BinDefaultTabColumnSet,  I);

  end;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure LoadDefaultMatCompBinTabSet;
var
  I   : Integer;
  qry : TMqmQuery;
  tbInfo:   ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
  qry := CreateQuery(Cfg_DB);
  qry.SQL.Clear;
  qry.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-6''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(' Order by ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.SQL.Add(' , ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.Open;
  qry.First;

  if qry.Eof then
    UMBinDefault.ConfBinLoadDefaultValues(BinDefaultTabCompColumnSet)
  else
  begin
   // BinDefaultFromDB_Comp := true;
    BinDefaultFromDB_Material_Compatible := true;
    I := 0;
    while (not qry.EOF) do
    begin
      BinDefaultTabCompColumnSet[I].Field := BinColDefault[qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger].Field;
      BinDefaultTabCompColumnSet[I].Title   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString;
      BinDefaultTabCompColumnSet[I].Pos     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger;
      BinDefaultTabCompColumnSet[I].Width   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger;
      if qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger = 1 then
        BinDefaultTabCompColumnSet[I].Visible := true
      else
        BinDefaultTabCompColumnSet[I].Visible := false;
      BinDefaultTabCompColumnSet[I].PropCode  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString;
      BinDefaultTabCompColumnSet[I].Order   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger;
      BinDefaultTabCompColumnSet[I].NumColSorted   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger;
      Inc(I);
      qry.Next;
    end;

    FixOldArrayBinCol(BinDefaultTabCompColumnSet,  I);

  end;
  qry.Close;
  qry.Free;
end;


procedure LoadDefaultBinTabsSet;
begin
  LoadDefaultBinTabSet;
  LoadBinDefaultTabSlotFilter;
  LoadBinDefaultTabSearch;
  LoadBinDefaultTabAutoSeqResults;
  LoadDefaultMatCompBinTabSet;
  LoadBinDefaultTabSchedJobSequenceResults;
  Application.ProcessMessages;
end;

//----------------------------------------------------------------------------//

procedure SaveDefaultTabBinSet;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  I, arraysize : Integer;
begin
  if CheckErrorInArrayWidth then
     Exit;
  BinDefaultFromDB := true;
  tbInfo := @tblInfo[tbl_cfg_binTab_col];

  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

//  try
  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-1''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Close;

  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName   + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier)  + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode)    + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsCode)    + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColPos)   + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColOrder)  + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColNumColSorted) + ')');
  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColNumColSorted));
  qry.SQL.Add(')');

  arraysize := -1;
  for I := Low(BinDefaultTabColumnSet) to High(BinDefaultTabColumnSet) do
  begin
    Application.ProcessMessages;
    Inc(arraysize);
    qry.params.arraysize := arraysize + 1;
    qry.params[0].AsIntegers[arraysize]  := StrToInt(IniAppGlobals.Identifier);

    qry.params[1].AsStrings[arraysize]      := IniAppGlobals.WkstCode;
    qry.params[2].AsIntegers[arraysize]     := -1;
    qry.params[3].AsIntegers[arraysize]     := I;

    qry.params[4].AsStrings[arraysize]      := BinDefaultTabColumnSet[I].Title;
    qry.params[5].AsIntegers[arraysize]     := BinDefaultTabColumnSet[I].Pos;
    qry.params[6].AsIntegers[arraysize]     := BinDefaultTabColumnSet[I].Width;
    if BinDefaultTabColumnSet[I].Visible  then
      qry.params[7].AsIntegers[arraysize]  := 1
    else
      qry.params[7].AsIntegers[arraysize]  := 0;
    qry.params[8].AsStrings[arraysize]     := BinDefaultTabColumnSet[I].PropCode;
    qry.params[9].AsIntegers[arraysize]    := BinDefaultTabColumnSet[I].Order;
    qry.params[10].AsIntegers[arraysize]   := BinDefaultTabColumnSet[I].NumColSorted;

    {qry.ParamByName(CreateFld(tbInfo.pfx, fli_Identifier)).AsString      := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString      := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger     := -1;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger  := I;

    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString   := BinDefaultTabColumnSet[I].Title;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger    := BinDefaultTabColumnSet[I].Pos;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger  := BinDefaultTabColumnSet[I].Width;
    if BinDefaultTabColumnSet[I].Visible  then
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 1
    else
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 0;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger  := BinDefaultTabColumnSet[I].Order;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString  := BinDefaultTabColumnSet[I].PropCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger  := BinDefaultTabColumnSet[I].NumColSorted;

    qry.ExecSQL;   }
  end;
{  except
    qry.Close;
    qry.Free;
    Exit;
  end;   }

  if arraysize >= 0 then
    qry.execute(arraysize + 1);

  qry.Transaction.Commit;
  qry.Close;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure SaveDefaultTabSlotFilter;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  I, arraysize : Integer;
begin
  if CheckErrorInArrayWidth then
     Exit;

  BinDefaultFromDB_Slot := true;
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
//  SetFldPfx(tbInfo.pfx);
  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

//  try

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-2''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
//    Trs.Commit;
  qry.Close;


  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColNumColSorted) + ')');
  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColNumColSorted));
  qry.SQL.Add(')');

  arraysize := -1;
  for I := Low(BinDefaultTabSlotFilter) to High(BinDefaultTabSlotFilter) do
  begin
    Application.ProcessMessages;
    Inc(arraysize);
    qry.params.arraysize := arraysize + 1;
    qry.params[0].AsIntegers[arraysize]  := StrToInt(IniAppGlobals.Identifier);
    qry.params[1].Asstrings[arraysize]   := IniAppGlobals.WkstCode;
    qry.params[2].AsIntegers[arraysize]  := -2;
    qry.params[3].AsIntegers[arraysize]  := I;
    qry.params[4].Asstrings[arraysize]   := BinDefaultTabSlotFilter[I].Title;
    qry.params[5].AsIntegers[arraysize]    := BinDefaultTabSlotFilter[I].Pos;
    qry.params[6].AsIntegers[arraysize]  := BinDefaultTabSlotFilter[I].Width;
    if BinDefaultTabSlotFilter[I].Visible  then
      qry.params[7].AsIntegers[arraysize] := 1
    else
      qry.params[7].AsIntegers[arraysize] := 0;
    qry.params[8].Asstrings[arraysize]    := BinDefaultTabSlotFilter[I].PropCode;
    qry.params[9].AsIntegers[arraysize]   := BinDefaultTabSlotFilter[I].Order;
    qry.params[10].AsIntegers[arraysize]  := BinDefaultTabSlotFilter[I].NumColSorted;

    {qry.ParamByName(CreateFld(tbInfo.pfx, fli_Identifier)).AsString    := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString      := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger     := -2;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger  := I;

    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString   := BinDefaultTabSlotFilter[I].Title;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger    := BinDefaultTabSlotFilter[I].Pos;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger  := BinDefaultTabSlotFilter[I].Width;
    if BinDefaultTabSlotFilter[I].Visible  then
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 1
    else
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 0;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger  := BinDefaultTabSlotFilter[I].Order;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString  := BinDefaultTabSlotFilter[I].PropCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger  := BinDefaultTabSlotFilter[I].NumColSorted;
    qry.ExecSQL;  }
  end;

  if arraysize >= 0 then
    qry.execute(arraysize + 1);

  qry.Transaction.Commit;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure SaveDefaultTabSearch;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  I, arraysize : Integer;
begin
  if CheckErrorInArrayWidth then
     Exit;

  BinDefaultFromDB_Search := true;
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
//  SetFldPfx(tbInfo.pfx);
  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

//  try

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-3''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
//    Trs.Commit;
  qry.Close;

  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColNumColSorted) + ')');
  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColNumColSorted));
  qry.SQL.Add(')');
//  qry.Prepare;

  arraysize := -1;
  for I := Low(BinDefaultTabSearch) to High(BinDefaultTabSearch) do
  begin
    Application.ProcessMessages;
    Inc(arraysize);
    qry.params.arraysize := arraysize + 1;
    qry.params[0].AsIntegers[arraysize]  := StrToInt(IniAppGlobals.Identifier);
    qry.params[1].AsStrings[arraysize]      := IniAppGlobals.WkstCode;
    qry.params[2].AsIntegers[arraysize]     := -3;
    qry.params[3].AsIntegers[arraysize]     := I;
    qry.params[4].AsStrings[arraysize]      := BinDefaultTabSearch[I].Title;
    qry.params[5].AsIntegers[arraysize]     := BinDefaultTabSearch[I].Pos;
    qry.params[6].AsIntegers[arraysize]  := BinDefaultTabSearch[I].Width;
    if BinDefaultTabSearch[I].Visible  then
      qry.params[7].AsIntegers[arraysize] := 1
    else
      qry.params[7].AsIntegers[arraysize] := 0;
    qry.params[8].AsStrings[arraysize]   := BinDefaultTabSearch[I].PropCode;
    qry.params[9].AsIntegers[arraysize]  := BinDefaultTabSearch[I].Order;
    qry.params[10].AsIntegers[arraysize]  := BinDefaultTabSearch[I].NumColSorted;

    {qry.ParamByName(CreateFld(tbInfo.pfx, fli_Identifier)).AsString    := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString      := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger     := -3;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger  := I;

    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString   := BinDefaultTabSearch[I].Title;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger    := BinDefaultTabSearch[I].Pos;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger  := BinDefaultTabSearch[I].Width;
    if BinDefaultTabSearch[I].Visible  then
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 1
    else
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 0;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger  := BinDefaultTabSearch[I].Order;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString  := BinDefaultTabSearch[I].PropCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger  := BinDefaultTabSearch[I].NumColSorted;
    qry.ExecSQL;      }
  end;

  if arraysize >= 0 then
    qry.execute(arraysize + 1);

{  except
    qry.Close;
    qry.Free;
    Exit;
  end; }
  qry.Transaction.Commit;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

Procedure SaveDefaultTabJobSchedSequence;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  I, arraysize : Integer;
begin
  if CheckErrorInArrayWidth then
     Exit;

  BinDefaultFromDB_SchedJobSequence := true;
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

//  try

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-7''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Close;

  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColNumColSorted) + ')');
  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColNumColSorted));
  qry.SQL.Add(')');
//  qry.Prepare;

  arraysize := -1;
  for I := Low(BinDefaultTabSchedJobSequence) to High(BinDefaultTabSchedJobSequence) do
  begin
    Application.ProcessMessages;
    Inc(arraysize);
    qry.params.arraysize := arraysize + 1;

    qry.params[0].AsIntegers[arraysize]  := StrToInt(IniAppGlobals.Identifier);

    qry.params[1].AsStrings[arraysize]      := IniAppGlobals.WkstCode;
    qry.params[2].AsIntegers[arraysize]     := -7;
    qry.params[3].AsIntegers[arraysize]  := I;

    qry.params[4].Asstrings[arraysize]   := BinDefaultTabSchedJobSequence[I].Title;
    qry.params[5].AsIntegers[arraysize]    := BinDefaultTabSchedJobSequence[I].Pos;
    qry.params[6].AsIntegers[arraysize]  := BinDefaultTabSchedJobSequence[I].Width;
    if BinDefaultTabSchedJobSequence[I].Visible  then
      qry.params[7].AsIntegers[arraysize] := 1
    else
      qry.params[7].AsIntegers[arraysize] := 0;
    qry.params[8].AsStrings[arraysize]  := BinDefaultTabSchedJobSequence[I].PropCode;
    qry.params[9].AsIntegers[arraysize]  := BinDefaultTabSchedJobSequence[I].Order;
    qry.params[10].AsIntegers[arraysize]  := BinDefaultTabSchedJobSequence[I].NumColSorted;

    {qry.ParamByName(CreateFld(tbInfo.pfx, fli_Identifier)).AsString    := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString      := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger     := -7;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger  := I;

    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString   := BinDefaultTabSchedJobSequence[I].Title;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger    := BinDefaultTabSchedJobSequence[I].Pos;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger  := BinDefaultTabSchedJobSequence[I].Width;
    if BinDefaultTabSchedJobSequence[I].Visible  then
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 1
    else
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 0;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger  := BinDefaultTabSchedJobSequence[I].Order;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString  := BinDefaultTabSchedJobSequence[I].PropCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger  := BinDefaultTabSchedJobSequence[I].NumColSorted;
    qry.ExecSQL; }
  end;

  if arraysize >= 0 then
    qry.execute(arraysize + 1);

{  except
    qry.Close;
    qry.Free;
    Exit;
  end; }
  qry.Transaction.Commit;
  qry.Close;
  qry.Free;

end;

procedure SaveDefaultTabAutoSeqResults;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  I, arraysize : Integer;
begin
  if CheckErrorInArrayWidth then
     Exit;

  BinDefaultFromDB_AutoSeqResults := true;
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
//  SetFldPfx(tbInfo.pfx);
  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

//  try

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-4''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Close;

  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColNumColSorted) + ')');
  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColNumColSorted));
  qry.SQL.Add(')');
//  qry.Prepare;

  arraysize := -1;
  for I := Low(BinDefaultTabAutoSeqResults) to High(BinDefaultTabAutoSeqResults) do
  begin
    Application.ProcessMessages;
    Inc(arraysize);
    qry.params.arraysize := arraysize + 1;
    qry.params[0].AsIntegers[arraysize]  := StrToInt(IniAppGlobals.Identifier);
    qry.params[1].AsStrings[arraysize]   := IniAppGlobals.WkstCode;
    qry.params[2].AsIntegers[arraysize]  := -4;
    qry.params[3].AsIntegers[arraysize]  := I;
    qry.params[4].Asstrings[arraysize]   := BinDefaultTabAutoSeqResults[I].Title;
    qry.params[5].AsIntegers[arraysize]    := BinDefaultTabAutoSeqResults[I].Pos;
    qry.params[6].AsIntegers[arraysize]  := BinDefaultTabAutoSeqResults[I].Width;
    if BinDefaultTabSearch[I].Visible  then
      qry.params[7].AsIntegers[arraysize] := 1
    else
      qry.params[7].AsIntegers[arraysize] := 0;
    qry.params[8].AsStrings[arraysize]   := BinDefaultTabAutoSeqResults[I].PropCode;
    qry.params[9].AsIntegers[arraysize]   := BinDefaultTabAutoSeqResults[I].Order;
    qry.params[10].AsIntegers[arraysize]  := BinDefaultTabAutoSeqResults[I].NumColSorted;

    {qry.ParamByName(CreateFld(tbInfo.pfx, fli_Identifier)).AsString    := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString      := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger     := -4;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger  := I;

    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString   := BinDefaultTabAutoSeqResults[I].Title;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger    := BinDefaultTabAutoSeqResults[I].Pos;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger  := BinDefaultTabAutoSeqResults[I].Width;
    if BinDefaultTabSearch[I].Visible  then
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 1
    else
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 0;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger  := BinDefaultTabAutoSeqResults[I].Order;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString  := BinDefaultTabAutoSeqResults[I].PropCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger  := BinDefaultTabAutoSeqResults[I].NumColSorted;
    qry.ExecSQL;   }
  end;

  if arraysize >= 0 then
    qry.execute(arraysize + 1);

{  except
    qry.Close;
    qry.Free;
    Exit;
  end; }
  qry.Transaction.Commit;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure SaveDefaultTabBinMatCompatibleSet;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  I : Integer;
begin
  if CheckErrorInArrayWidth then
     Exit;
 // BinDefaultFromDB_Comp := true;
  BinDefaultFromDB_Material_Compatible := true;
  tbInfo := @tblInfo[tbl_cfg_binTab_col];

  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

//  try
  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-6''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Close;

  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName   + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier)  + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode)    + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsCode)    + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColPos)   + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColOrder)  + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColNumColSorted) + ')');
  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColNumColSorted));
  qry.SQL.Add(')');

  for I := Low(BinDefaultTabCompColumnSet) to High(BinDefaultTabCompColumnSet) do
  begin
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_Identifier)).AsString      := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString      := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger     := -6;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger  := I;

    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString   := BinDefaultTabCompColumnSet[I].Title;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger    := BinDefaultTabCompColumnSet[I].Pos;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger  := BinDefaultTabCompColumnSet[I].Width;
    if BinDefaultTabCompColumnSet[I].Visible  then
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 1
    else
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 0;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger  := BinDefaultTabCompColumnSet[I].Order;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString  := BinDefaultTabCompColumnSet[I].PropCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger  := BinDefaultTabCompColumnSet[I].NumColSorted;

    qry.ExecSQL;
  end;
{  except
    qry.Close;
    qry.Free;
    Exit;
  end;   }
  qry.Transaction.Commit;
  qry.Close;
  qry.Free;

end;


function CheckErrorInArrayWidth : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := Low(BinDefaultTabColumnSet) to High(BinDefaultTabColumnSet) do
  begin
    if (BinDefaultTabColumnSet[I].Width = 0) then
    begin
      Result := true;
      Exit
    end;
  end;
end;

//----------------------------------------------------------------------------//

function GetNumberFields : integer;
begin
  Result := 0;
  while BinColDefault[Result].Field <> CSC_property1 do
    Result := Result + 1;
end;

//----------------------------------------------------------------------------//

initialization
  BinDefaultFromDB := false;
  BinDefaultFromDB_SchedJobSequence := false;
  BinDefaultFromDB_Search := false;
  BinDefaultFromDB_AutoSeqResults := false;
  BinDefaultFromDB_Slot := false;
  BinDefaultFromDB_Material_Compatible := false
end.
