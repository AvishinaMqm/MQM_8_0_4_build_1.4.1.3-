unit UMBinFunc;

interface
uses
  Windows, SysUtils, Classes, Controls, menus,
  UMSchedCont,   UMGlobal, Variants , Vcl.Forms,
  UMSchedContFunc, UMBinDefault, StrUtils,
  Grids, gnugettext;

type

  Filter = (FiltQty, FiltProp, FiltWkcr, FlitProcces ,FiltWkcrTo, FlitProccesTo,  FiltWkcrAlterntiv,
            FiltWkcr_Active, FiltResource, FiltResourceTo, FiltProdType, FiltProgress, FiltOnlyProgress,
            FiltReProcces, FiltStepType, FiltGroupNum, FiltGroupNumTo,  FiltLowDate, FiltDeliveryDate,  FiltProdReq, FiltProdReqTo, Filt_ReadOnly, FiltGroups,
            FiltLowStartDate, FiltPlanStartDate, FiltPlanStartDate_DaysFromToday,
            FiltPlanEndDate, FiltPlanEndDate_DaysFromToday, FiltCBSeq, FiltSeq,
            FiltNextStartDate, FiltNextStartDate_DaysFromToday,
            FiltPrevEndDate, FiltPrevEndDate_DaysFromToday,
            FiltProdFamily, FiltMaterialFamily , FiltSchedJobs, FiltOnlySchedJobs,
            FiltClosedJobs, FiltOnlyClosedJobs, FiltOnlyReadOnly, FiltOnlyGroups, FiltFltJobsOnGantt,
            FiltJobPriority, FiltSchedStartDate, FiltSchedStartDate_Days, FiltLatestEndingDate, FiltTemporary, FiltFix, FiltAfterDeliveryDay, FiltAfterDeliveryInDays,
            FiltBeforeEarliestStart, FiltBeforeEarliestStartInDays, FiltBeforeEarliestStartFixed, FiltBeforeEarliestStartInDaysFixed,
            FiltAfterLatestEnd, FiltAfterLatestEndInDays, FiltImbalancedSteps,
            FiltShouldBeScheduled, FiltShouldBeScheduledIndays, FiltStepId, FiltStepIdTo, FiltSubStepId, FiltSubStepIdTo,
            FiltMissingmaterials, FiltMissingAddRes, FiltOveridePrevious, FiltOverideNext, FiltScheduledJobsCrossesDateTime,
            FiltCompWithPrevJob, FiltCompWithPrevJobInCase, FiltCompWithRes, FiltJobMsg, FiltCompWithResInCase, FiltConfLevNewLog,
            FiltConfLevelsfinal,FiltConfLevelsIni,FiltConfLevels1,FiltConfLevels2,FiltConfLevels3,FiltConfLevels4,FiltConfLevels5,
            FiltCustomerDateConfirmed, FiltCustomerDateCulculated, FiltCustomerDateRequested, FiltIgnoredProg, FiltWkcrGrp, FiltWkcrPlant,FiltWkcrDivision, FiltResCat,

          //  FiltItemTypeAndProdCodeBaseWarp, FiltItemTypeAndProdCodeSecondWarp,
            FiltItemTypeBaseWarp, FiltProdCodeBaseWarp, FiltItemTypeSecondWarp, FiltProdCodeSecondWarp,

            // material filters
            Filt_Item_Type,
            Filt_Product_code,
            Filt_NetGroup_Code,
            Filt_MaterialDetailCode,
            Filt_MaterialCode_SUB_DETAILS,

            Filt_Item_Type2,
            Filt_Product_code2,

            Filt_WarpBasicLvl,
            Filt_WarpSecondLvl
            );

  TBinType = (BT_Main, BT_SrcByNum, BT_SrcByOrd, BT_SrcByIss, BT_SrcByArt, BT_SrcByTD);
  TTabObj  = (Tb_Normal, Tb_MaterialSched);
  TTabType = (Tb_Search, Tb_FilterSloteBydate, Tb_AutoSeqResults, Tb_WeavJobsForWarp, Tb_SchedJobSequence);

  TDrawCell     = procedure (Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
  TSelectCell   = procedure (Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
  TDblClick     = procedure (Sender: TObject);
  TMseDown      = procedure (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  TLoadBinCfg   = procedure;
  TBinFilterJob = function  (sc: TMSchedCont; id: TSchedID; prm: TObject): boolean;

  TBinConfig = class
    m_OnDrawCell    : TDrawCell;
    m_OnDblClick    : TDblClick;
    m_OnSelectCell  : TSelectCell;
    m_OnMouseDown   : TMseDown;
    m_PopUp         : TPopUpMenu;
    constructor Create;
  end;

  TConfRec = Record
    Status    : Char;
    Name      : array [0..10] of Char;
    Descr     : array [0..50] of Char;
    DataArray : array [0..50] of TBinColCurrent;
  end;
  PTConfRec = ^TConfRec;

  TAllCfgRec = array of TConfRec;

  TFiltOptions = set of Filter;

  TGroupedByFieldSet = Record
    Code : string;
    GroupedByOption : TFiltOptions;
    PropCode : array [0..9] of string;
  end;
  PTGroupedByFieldSet = ^TGroupedByFieldSet;

  TRecFilter = Record
    IsPropEnter : boolean;
    MinQty :  double;
    MaxQty :  double;
    SchedType : CScSchedType;
    Resource : string;
    ResourceTo : string;
    ResCatCode : string;
    ProdType : string;

    ProdLowDate_From : TDate;
    ProdLowDate_To : TDate;
    ProdDelivDate_From : TDate;
    ProdDelivDate_To : TDate;

    PlanStartDate_From : TDate;
    PlanStartDate_To : TDate;
    PlanStartDate_DaysFromToday : Integer;
    PlanStartDate_DaysTillToday : Integer;
    PlanEndDate_From : TDate;
    PlanEndDate_To : TDate;
    PlanEndDate_DaysFromToday : Integer;
    PlanEndDate_DaysTillToday : Integer;
    NextStartDate_From : TDate;
    NextStartDate_to : TDate;
    NextStartDate_DaysFromToday : Integer;
    NextStartDate_DaysTillToday : Integer;
    PrevEndDate_From : TDate;
    PrevEndDate_to : TDate;
    PrevEndDate_DaysFromToday : Integer;
    PrevEndDate_DaysTillToday : Integer;

    LowStartDate_From : TDate;
    LowStartDate_To : TDate;
    SchedStartDate_From : TDate;
    SchedStartDate_To : TDate;
    SchedStartDate_DaysFromToday : Integer;
    SchedStartDate_DaysTillToday : Integer;
    SchedStartDate_DaysTillToday_time : double;

    FixedEarliestDate_From : TDate;
    FixedEarliestDate_To : TDate;
    EarliestDays_From : Integer;
    EarliestDays_To : Integer;

    LatestEndingDate_From : TDate;
    LatestEndingDate_To : TDate;
    ScheduleJobsCrosses_From : TDateTime;
    ScheduleJobsCrosses_To : TDateTime;

    ProdReq  : string;
    ProdReqTo  : string;
    ReadOnly : CScBinView;
    wkCtrCode : string;
    wkCtrGroup : string;
    wkCtrPlant : string;
    wkCtrDivision : string;
    wkcProc : string;
    wkCtrCodeTo : string;
    wkcProcTo : string;
    StepType : CScSchedType;
    GroupNum : Integer;
    GroupNumTo : integer;
    MaterialArrivDate : TDateTime;
    PlanStart : TDateTime;
    LowStartTimeLimit : TDateTime;
    ProductFamily : string;
    MaterialFamily : string;
    StepId   : Integer;
    StepIdTo : Integer;
    SubStepId   : Integer;
    SubStepIdTo : Integer;
    JobMsg      : boolean;
    ShowFirstGrplineInBin : boolean;
    AutoGroupSingleJob    : boolean;
    ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
    ShowBatchGroupLinesInBin    : boolean;
    IgnoredProg : Boolean;

    PropCod : array [1..60] of string;
    PropRes : array [1..60] of string;
    PropValfrom : array [1..60] of string;
    PropValTo : array [1..60] of string;

    AfterDeliveryInDays : integer;
    BeforeEarliestStartInDays : Integer;
    AfterLatestEndInDays : Integer;
    CompWithPrevJobInCase : Integer;
    CompWithResInCase     : Integer;
    ShouldBeScheduledIndays : Integer;

    ShowDependingOnNextHandledStep : CScShowDependingOnHandledStepOrLinkRequest;
    ShowDependingOnPrevHandledStep : CScShowDependingOnHandledStepOrLinkRequest;
    ShowDependingOnNextHandledLinkedRequest : CScShowDependingOnHandledStepOrLinkRequest;
    ShowDependingOnPrevHandledLinkedRequest : CScShowDependingOnHandledStepOrLinkRequest;

    ItemTypeCodeBaseWarp : String;
    ProdCodeBaseWarp : String;
    ItemTypeCodeSecondWarp : String;
    ProdCodeSecondWarp : String;

    Sequence : Integer;
    CBSequence : Integer;

    // material filters fields

    Item_Type : string;
    Product_code : string;
    NetGroup_Code : string;
    MaterialDetailCode : string;
    MaterialCodeSubDetail : string;

    Item_Type2 : string;
    Product_code2 : string;

    SchedJobs : Integer;
    WarpLevel : Integer;   //0-basic 1-second  2-both
    // need to use also FiltSchedJobs  '0' - all jobs '1' 0nly scheduled jobs '2' only not scheduled jobs
    // also properties as in normal filter
    Options : TFiltOptions;
  end;

  PRecFilter = ^TRecFilter;

  TBinFilterParms = class(TObject)
  private
    m_ListFiltProp : TList;
    m_ListOrProp   : TList;
    m_IsListOrProp : boolean;
    m_OverriddenTab : boolean;
    m_GroupedByCode : string;
    m_SavedShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
    m_savedShowBatchGroupLinesInBin    : boolean;
    m_AutoSeqResultFilter : boolean;
    m_MaterialSchedFilter : boolean;
    m_SeqFilter : Boolean;
  public
    RecFilt : TRecFilter;
    procedure SignGroupedByCode(Code : string);
    function CheckGroupedByFields(Id : TschedId) : boolean;
    function AddToListGroupedByField(Str : String; Id : TSchedId) : boolean;
    function GetCountPropList : Integer;
    procedure ClearFiltPropList;
    procedure DeletePropFromList(PropCode : string);
    constructor Create;
    function  GetOrConditionProp : TList;
    procedure ClearPropRecFields;
    procedure CopyFilterSetting(BinFilterParms : TBinFilterParms);
    procedure SetPropValue(Code, RscCode : string; val1 : string; Val2 : string);
    function  GetValCodeByIndex(Index: Integer; var RscCode: string; var val1: variant; var val2: variant): string;
    function  TestJobValFilter(ValJob: variant; ValFrom: variant; ValTo: variant): boolean;
    function  TestMatFilterOpts(id: TSchedID) : boolean;
    function  TestFilterOpts(id: TSchedID; WcProcAllowedList : Tlist) : boolean;
    Destructor Destroy ; override;
    property  P_SetListOnProp : boolean write m_IsListOrProp;
    property  P_OverriddenTab : boolean read m_OverriddenTab write m_OverriddenTab;
    property  P_GroupedByCode : string read m_GroupedByCode write m_GroupedByCode;
    property  p_SavedShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin read m_SavedShowContinueGroupLinesInBin write m_SavedShowContinueGroupLinesInBin;
    property  p_savedShowBatchGroupLinesInBin : boolean read m_savedShowBatchGroupLinesInBin write m_savedShowBatchGroupLinesInBin;
    property  P_AutoSeqResultFilter : boolean read m_AutoSeqResultFilter write m_AutoSeqResultFilter;
    property  P_MaterialSchedFilter : boolean read m_MaterialSchedFilter write m_MaterialSchedFilter;
    property  P_SeqFilter : boolean read m_SeqFilter write m_SeqFilter;
  end;

  procedure RefreshAfterMove(ptr: pointer);
  procedure OccMoveEnter(ptr1, ptr2: pointer);
  procedure OccMoveExit(ptr: pointer; BtnOk : boolean);
  procedure BinDblClick(Sender: TObject);
  procedure MatDblClick(Sender: TObject);
  function  MoveToBin(id: TSchedId; OnlyOneJob: boolean): boolean;
  procedure BinSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
  procedure MatSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
  procedure BinMseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  procedure MatMseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  procedure GetBinCfg(BinType: TBinType; var ColArray : array of TBinColCurrent);
  function  SetFilterParams(BinColId : CBinColId; Value : variant; var dataType : CBinColValType; Info : boolean;
                            Pos : Integer; BinFilterParms :TBinFilterParms; var Title : string; binGrid : Pointer) : boolean;
  procedure ClearFilterParams(var Options : TFiltOptions; BinFilterParms : TBinFilterParms; TabType : TTabType);
  procedure ClearGroupedByFieldList;
//  function  SortByStrGroupedByField(Item1, Item2: Pointer): Integer;
  procedure SortListGroupedByFieldId;
//  function  AddToListGroupedByField(Str : String; Id : TSchedId) : boolean;
  function  GetGroupedByFieldListCount : Integer;
  function  FindIdValueInGroupedByFieldList(Id : TSchedId; fld: CBinColId; var FoundGroupedById : boolean) : variant;

implementation

uses
  FMBin,
  UMBinTbs,
  UMBinGrid,
  Dialogs,
  UMWkCtr,
  UMRes,
  FMMainPlan,
  UMObjCont,
  UMCompatSrv,
  FMOccMov,
  FMGroupDetail,
  FMCreateCapRes,
  FMCrtDownTime,
  UGShapeMan,
  UMPlanTbs,
  UMSchedList,
  UGGanttPanel,
  UMActArea,
  UMOpStack,
  UMCompat,
  FMAutoSched,
  DMsrvPc,
  UMSchedObjMover,
  UMSchedOnPlan,
  FMGroupedByFieldsConfig,
  UMGenericSchedulePrevStep,
  UMbinGridMaterial,
  FMCreateWarp,
  UMAutoSchedCfg;

// -------------------------------------------------------------------------- //
// TBinConfig                                                                 //
// -------------------------------------------------------------------------- //

var
  m_GroupedByFieldList : TList;

type

  FilterRecProp = Record
    PropCode : string;
    ResCode  : string;
    ValFrom  : variant;
    ValTo    : variant;
  end;
  PRecProp = ^FilterRecProp;

  RecGroupedByFieldSet = Record
    id : TSchediD;
    str : string;
    MatArrivalDate    : TDateTime;
    ProdDlvDate       : TDateTime;
    LowStartTimeLimit : TDateTime;
    PlanStartDate     : TDateTime;
    PlanEndDate       : TDateTime;
    LowStartDate      : TDateTime;
    HighEndLimit      : TDateTime;
    IniQty            : double;
    FinQty            : double;
    Weight            : double;
    NumOfRscPlan      : double;
    NoResComp         : double;
    PlanSetup         : double;
    ExeTime           : double;
    SupTimeSched      : double;
    ExeTimeSched      : double;
    QtyToSched        : double;
    SchedStart        : TDateTime;
    SchedEnd          : TDateTime;
    ActualTime        : double;
    ProgStart         : TDateTime;
    ProgEnd           : TDateTime;
    ProgQty           : double;
    //ProgType          : string;
  end;
  PRecGroupedByFieldSet = ^RecGroupedByFieldSet;

//----------------------------------------------------------------------------//

constructor TBinConfig.Create;
begin
  m_OnDrawCell    := nil;
  m_OnDblClick    := nil;
  m_OnSelectCell  := nil;
  m_OnMouseDown   := nil;
  m_PopUp         := nil;
end;

//----------------------------------------------------------------------------//

procedure TranslationExtractionPurpose;
//These strings are not really used in the program and are here only
//for the translation extraction purpose
var
  notused1,notused2,notused3,notused4,notused5,notused6,notused7,notused8,
  notused9,notused10,notused11,notused12,notused13,notused14,notused15,notused16,
  notused17,notused18,notused19,notused20,notused21,notused22,notused23,notused24,
  notused25,notused26,notused27,notused28,notused29,notused30,notused31,notused32,
  notused33,notused34,notused35,notused36,notused37,notused38,notused39,notused40,
  notused41,notused42,notused43,notused44,notused45,notused46,notused47,notused48,
  notused49,notused50,notused51,notused52,notused53,notused54,notused55,notused56,
  notused57,notused58,notused59,notused60,notused61,notused62,notused63,notused64,
  notused65, notused66, notused67, notused68, notused69, notused70, notused71,
  notused72, notused73, notused74, notused75, notused76, notused77, notused78,
  notused79, notused80, notused81 : string;
begin
  notused1:= _('Info.');
  notused2:= _('Production req.');
  notused3:= _('Step');
  notused4:= _('Sub step');
  notused5:= _('Re-process');
  notused6:= _('Step group');
  notused7:= _('Actual work center');
  notused8:= _('Actual work center description');
  notused9:= _('Actual process');
  notused10:= _('Actual process description');
  notused11:= _('Planned work center');
  notused12:= _('Planned work center description');
  notused13:= _('Planned process');
  notused14:= _('Planned process description');
  notused15:= _('Product type');
  notused16:= _('Product type description');
  notused17:= _('Production line');
  notused18:= _('Product family');
  notused19:= _('Material family');
  notused20:= _('Production um');
  notused21:= _('Um description');
  notused22:= _('Comment');
  notused23:= _('Prod.req earliest date');
  notused24:= _('Prod.req delivery date');
  notused25:= _('Step type');
  notused26:= _('Materials planned date');
  notused27:= _('Plan start');
  notused28:= _('Earliest start');
  notused29:= _('Plan end');
  notused30:= _('Latest end');
  notused31:= _('Calendar');
  notused32:= _('Initial quantity');
  notused33:= _('Final quantity');
  notused34:= _('Weight + um');
  notused35:= _('Step setup time');
  notused36:= _('Step execution time');
  notused37:= _('Planned nbr. of resources');
  notused38:= _('Connection type previous step');
  notused39:= _('Quantity {to} schedule');
  notused40:= _('Scheduled execution time');
  notused41:= _('Scheduled set up time');
  notused42:= _('Resource');
  notused43:= _('Resource description');
  notused44:= _('Scheduled start');
  notused45:= _('Scheduled end');
  notused46:= _('Actual start');
  notused47:= _('Actual end');
  notused48:= _('Progress quantity');
  notused49:= _('Progress type');
  notused50:= _('Actual resource');
  notused51:= _('Actual resource description');
  notused52:= _('Forward connected sub step');
  notused53:= _('Forward connect re-process');
  notused54:= _('Backward connected sub step');
  notused55:= _('Backward connected re-process');
  notused56:= _('Actual Time');
  notused57:= _('Sequece');
  notused58:= _('Customized column 1');
  notused59:= _('Prev end date');
  notused60:= _('Next start date');
  notused61:= _('Last Schedule Changed');
  notused62:= _('Shared comment');
  notused63:= _('Customized column 2');
  notused64:= _('Customized column 3');
  notused65:= _('Case with previous job');
  notused66:= _('Generic plan work center');
  notused67:= _('Generic plan duration');
  notused68:= _('Generic plan lead time');
  notused69:= _('Generic plan machine number');
  notused70:= _('Generic plan start date');
  notused71:= _('Generic plan end date');
  notused72:= _('Serving group code');
  notused73:= _('Serving group lowest date');
  notused74:= _('Prev actual end date');
  notused75:= _('Next actual start date');
  notused76:= _('Customer date');
  notused77:= _('Saved schedule date');
  notused78:= _('Learning curve');
  notused79:= _('Schedule seq.');
  notused80:= _('Schedule seq. Selection');
  notused81:= _('Approval date');


// shouldnt be translated any more  (avi)...
{  notused56:= _('Prop 1');
  notused57:= _('Prop 2');
  notused58:= _('Prop 3');
  notused59:= _('Prop 4');
  notused60:= _('Prop 5');
  notused61:= _('Prop 6');
  notused62:= _('Prop 7');
  notused63:= _('Prop 8');
  notused64:= _('Prop 9');
  notused65:= _('Prop 10');
  notused66:= _('Prop 11');
  notused67:= _('Prop 12');
  notused68:= _('Prop 13');
  notused69:= _('Prop 14');
  notused70:= _('Prop 15');
  notused71:= _('Prop 16');
  notused72:= _('Prop 17');
  notused73:= _('Prop 18');
  notused74:= _('Prop 19');
  notused75:= _('Prop 20');
  notused76:= _('Prop 21');
  notused77:= _('Prop 22');
  notused78:= _('Prop 23');
  notused79:= _('Prop 24');
  notused80:= _('Prop 25');
  notused81:= _('Prop 26');
  notused82:= _('Prop 27');
  notused83:= _('Prop 28');
  notused84:= _('Prop 29');
  notused85:= _('Prop 30');   }

end;

//----------------------------------------------------------------------------//

procedure RefreshAfterMove(ptr: pointer);
var
  fmPlan: TFMQMPlan;
  tbs:      TBinTabSheet;
begin
  fmPlan := TFMQMPlan(ptr);

  fmPlan.RefreshActiveTab;   // Refresh Plan

  tbs := nil;
  if Assigned(FBin) then
    tbs  := FBin.GetActiveView;
  if Assigned(tbs) then
  begin
    if DBAppSettings.RefreshBinByButton and
       ((GetOccMoveForm <> nil) or (GetDownTimeForm <> nil) or (GetCrtWarpForm <> nil)) then
    begin
      tbs.m_BinPanel.RefreshGrid;
      if Assigned(FBin) then
        FBin.ActivateRefreshButton;
    end
    else
      tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin
  end;

end;

//----------------------------------------------------------------------------//

procedure OccMoveEnter(ptr1, ptr2: pointer);
var
  fmPlan: TFMQMPlan;
  tbs:    TMqmPlanTabSheet;
  LinksList: TList;
begin
  Assert(Assigned(ptr1));
  fmPlan := TFMQMPlan(ptr1);

  tbs  := fmPlan.GetActiveTab;
  if Assigned(tbs) then
  begin
    LinksList := TList.Create;
    p_sc.GetLinks(TSchedId(ptr2), LinksList);
    tbs.p_shapeMan.AddLinkList(LinksList);
    LinksList.Free
  end;

  fmPlan.EnterCompatModeInPlan(TSchedId(ptr2));

end;

//----------------------------------------------------------------------------//

procedure OccMoveExit(ptr: pointer; BtnOk : boolean);
var
  fmPlan: TFMQMPlan;
  tbs:      TBinTabSheet;
  PlanTbs:  TMqmPlanTabSheet;
begin
  Assert(Assigned(ptr));
  TFMQMPlan(ptr).ExitCompatModeInPlan;
  p_sc.ClearMoveOp;

  fmPlan := TFMQMPlan(ptr);
  PlanTbs  := fmPlan.GetActiveTab;
  if Assigned(PlanTbs) then
    PlanTbs.p_shapeMan.ClearLinks;

  if DBAppGlobals.OrganizeJobsAfterDoday then exit;

  if AutoSchedCfg.m_GraphOnMove or not Assigned(FAutoSched) then
  begin
    fmPlan.RefreshActiveTab;   // Refresh Plan

    tbs := nil;
    if Assigned(FBin) then
      tbs  := FBin.GetActiveView;

    if not BtnOk then
    begin
      if Assigned(tbs) then
      begin
        if DBAppSettings.RefreshBinByButton then
        begin
          tbs.m_BinPanel.RefreshGrid;
        end
        else
          tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin
      end;
    end
    else
    begin
      if Assigned(tbs) then
        tbs.m_BinPanel.RefreshGrid
    end;

  end;

end;

//----------------------------------------------------------------------------//

function MoveToBin(id: TSchedId; OnlyOneJob: boolean): boolean;
var
  act:     TMqmActArea;
//  ObjsMoved, FinalObjsMoved, ObjsDelayed, NoMaterials, NoAddRes: boolean;
  MarkStack: TStackMark;
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
  errlist : TStringList;
  linkInfo: TSQlinkInfo;
  I : Integer;
  SonId : TSchedID;
  planInfo: TSQplanInfo;
begin
  p_sc.GetLinkInfo(Id, linkInfo);

  result := false;
  if OnlyOneJob then
  begin
    errlist := TStringList.Create;
    if p_sc.CanMoveToBin(id, errlist, true) = false then
    begin
      if errlist.Text <> '' then
        showmessage(errlist.Text);
      errlist.Free;
      exit;
    end;
    errlist.Free;
  end
  else
  begin

    if linkInfo.isGroup then
    begin
      // in case one of the other lines except from the first are progress
      for I := 0 to p_sc.GetGrpNumSons(id) - 1 do
      begin
        SonId := p_sc.GetGrpSon(id, I);
        if p_sc.CanMoveToBin(SonId, nil, true) = false then
          exit;
      end;

    end
    else
      if p_sc.CanMoveToBin(id, nil, true) = false then
        exit;
  end;

  //Checks for preceding jobs that are already scheduled that are
  //dependant on our Job , if true then there such a dependant job
  //and we skip our job/step to the next one
  if not p_sc.CheckPriorityToUnsched(id) then
  begin
    if OnlyOneJob then
      MessageDlg(_('It is not possible to unschedule this job because there are priorities'), mtWarning, [mbOk], 0);
    exit;
  end;

  act := p_sc.GetExtLinkPtr(id);
  Assert(Assigned(act));

  if not (AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_UnscheduleBefore) then
    MarkStack := p_opStack.MarkStack;

  if linkInfo.IsGenericPlan then
  begin
    UnScheduleGenericPlan(id);
    p_sc.GetJobInfo(id, planInfo);
    planInfo.isGroup := linkInfo.isGroup;
    planInfo.GenericPlanWC := '';
    p_opStack.DetachGenInfoFromApa(id, planInfo);
    if OnlyOneJob then
      CheckNextIdGenericPlan(act, Id);
  end;

  p_opStack.DetachOccFromApa(id, act);
  p_opStack.UpdateOvlpLimits(id, nil);
  p_opStack.SetSchedType(id, '0');
  p_sc.CleanInstanceCounterProperty(id);
  if OnlyOneJob then

    if act.ReorganizeOccForUnsched(id, False, OptsMover, DeltaSetupObjToMove, nil) <> CSM_Yes then
    begin
      p_opStack.UndoTo(MarkStack);
      MessageDlg(_('It was not possible to unschedule this job because following jobs reorganization failed'),
                mtWarning, [mbOk], 0);
      exit;
    end;

  p_sc.ClearBalance(id);

  if OnlyOneJob then
  begin
    FMQMPlan.RefreshActiveTab;
    if DBAppSettings.RefreshBinByButton then
    begin
      if Assigned(FBin) then
        FBin.ActivateRefreshButton;
    end
    else
    begin
      if not AutoSchedCfg.m_OverridingParams_Activated then
        FBin.ChangeTabBinforChangeTabPlan;
    end;
  end;
  result := true;
end;

//----------------------------------------------------------------------------//
//IS - ITEM06
procedure BinDblClick(Sender: TObject);
var
//  col, row: Longint;
//  pt:       TPoint;
  isGroup:  boolean;
  tbs:      TBinTabSheet;
  grid:     TBinDrawGrid;
  id, IdGroup: TSchedID;
  FieldVal, IniVal, FinVal: variant;
  dataType: CBinColValType;
  BinView : CScBinView;
  DatesInfo: TSQDatesInfo;
  ShowBatchGroupLinesInBin : boolean;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
begin
  tbs  := FBin.GetActiveView;
  if tbs.m_BinPanel.GetFiltParms.P_GroupedByCode <> '' then exit;

  isGroup := false;

  if (GetOccMoveForm <> nil)
//  or IsGroupFormOut
  or (GetCrtCapResForm <> nil)
  or (GetDownTimeForm <> nil) then exit;

  if IsGroupFormOut then
  begin
    FBin.MIAddToGroupClick(Sender);
    exit;
  end;

  if DBAppGlobals.MCM_App and CheckIfActiveGanttTabIsMcm then exit;
  if not DBAppGlobals.MCM_App and CheckIfActiveGanttTabIsMcm then exit;

  grid := tbs.GetBinGrid;
//  pt := grid.ScreenToClient(Mouse.CursorPos);
//  grid.MouseToCell(pt.X, pt.Y, col, row);
  if grid.row < 1 then exit;

  id := tbs.m_BinPanel.m_objList.GetLink(grid.row-1);

  if (id = CSchedIDnull) or (p_sc.GetSchedObjStatus(id) = CSS_Del) then
    Exit;

  p_sc.GetFldValue(id, CSC_IniQty, IniVal, dataType);
  p_sc.GetFldValue(id, CSC_FinQty, FinVal, dataType);
  if (IniVal = 0) or (FinVal = 0) then
  begin
    ShowMessage(_('Step can not be scheduled with Quantity 0'));
    Exit
  end;

  if (tbs.m_BinPanel.GetFiltParms.RecFilt.ShowContinueGroupLinesInBin <> CsSCG_No) or (tbs.m_BinPanel.GetFiltParms.RecFilt.ShowBatchGroupLinesInBin) then
  begin
    IdGroup := p_sc.LinesBelongToGroup(id, isGroup);
    if isGroup then
      Id := IdGroup;
  end;

  Assert(id <> CSchedIDnull);
  if p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType) and FieldVal then exit;
  BinView := p_sc.GetVisbleInBin(id);
  if (BinView = CSB_ReadOnly) then Exit;

  p_sc.GetDatesInfo(id, DatesInfo);
  if Assigned(p_sc.GetExtLinkPtr(id)) then
    FMQMPlan.FocusAllTbsOnID(id)
  else
    if DBAppGlobals.CenterStartOnMove then
      FMQMPlan.FocusAllTbsOnDate(DatesInfo.LowStrDate);

  OpenOccMoveForm(FMqmPlan, id, RefreshAfterMove, FMQMPlan, OccMoveEnter, OccMoveExit, FMQMPlan.CheckMultiResInActiveTab);

//  tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin
end;

//----------------------------------------------------------------------------//

procedure MatDblClick(Sender: TObject);
var
  tbs : TBinTabSheet;
  grid:     TBinDrawGridMat;
  id, IdGroup: TSchedID;
begin
  tbs  := FBin.GetActiveView;
  if not tbs.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then exit;

  if (GetCrtWarpForm <> nil) then exit;

  grid := tbs.GetMatGrid;

  if grid.row < 1 then exit;

  id := tbs.m_BinPanel.m_objList.GetLink(grid.row-1);

  if (id = CSchedIDnull) or (p_sc.GetSchedObjStatus(id) = CSS_Del) then
    Exit;

  Assert(id <> CSchedIDnull);

  if (p_sc.GetExtLinkPtr_Material(Id) <> nil) then
  begin
    fbin.MiShowOnPlanMatClick(Application);
    OpenWarpForm(FMqmPlan, nil, id, RefreshAfterMove, FMQMPlan, OccMoveEnter, OccMoveExit, TMqmActArea(p_sc.GetExtLinkPtr_Material(Id)))
  end
  else
    OpenWarpForm(FMqmPlan, nil, id, RefreshAfterMove, FMQMPlan, OccMoveEnter, OccMoveExit, nil);
end;

//----------------------------------------------------------------------------//

procedure BinSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  FBin.SetBinMenuItems(FBin.GetSchedObjByRow(ARow));
(*
  if assigned(FBin) and FBin.MIShowCompatible.Checked and (GetMoveForm = nil) then
    FBin.TestCompatibility(ARow,true);
*)
end;

//----------------------------------------------------------------------------//

procedure MatSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
begin

end;

//----------------------------------------------------------------------------//

procedure BinMseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  GCol, GRow: Longint;
  binGrid:    TBinDrawGrid;
  id,IdGroup: TSchedID;
  planInfo: TSQplanInfo;
  isGroup : boolean;
  ShowBatchGroupLinesInBin : boolean;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
begin
  binGrid := FBin.GetActiveView.GetBinGrid;

  binGrid.MouseToCell(X, Y, GCol, GRow);

  if not DBAppSettings.ShowRowInBin then //take care of cell select
    if GCol > 8 then binGrid.Col := GCol;

  if GRow > 0 then binGrid.Row := GRow;

  if Button = mbLeft then
  begin
    //FBin.PopUpBinPopup(application);
    // working with a resource, active planning area or a capacity reservation
    if GetOccMoveForm <> nil then
    begin
      id := FBin.GetSchedObjByRow(GRow);
      FBin.ShowGroupLinesInBin(ShowBatchGroupLinesInBin, ShowContinueGroupLinesInBin);
      if (ShowContinueGroupLinesInBin <> CsSCG_No) or ShowBatchGroupLinesInBin then
      begin
        IdGroup := p_sc.LinesBelongToGroup(id, isGroup);
        if isGroup then
          Id := IdGroup;
      end;

      if  (id <> CSchedIdNull)
      and (id <>p_pl.GetCompatModeInPlanId) then
      begin
        GetOccMoveForm.Reset;
        p_sc.GetPlanInfo(id, planInfo);

        if (ssShift in Shift) then
          ChangeOccTo(TMqmActArea(p_sc.GetExtLinkPtr(id)), 0 {planInfo.StartDate}, true, id, false) // right side
        else
          ChangeOccTo(TMqmActArea(p_sc.GetExtLinkPtr(id)), 0 {planInfo.endDate}, false, id, false) // left side
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure MatMseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  GCol, GRow: Longint;
  binGrid:    TBinDrawGridMat;
  id,IdGroup: TSchedID;
  planInfo: TSQplanInfo;
  isGroup : boolean;
  ShowBatchGroupLinesInBin : boolean;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
begin
  binGrid := FBin.GetActiveView.GetMatGrid;

  binGrid.MouseToCell(X, Y, GCol, GRow);

  if not DBAppSettings.ShowRowInBin then //take care of cell select
    if GCol > 1 then binGrid.Col := GCol;   // fixed column = 1

  if GRow > 0 then binGrid.Row := GRow;

{  if Button = mbLeft then
  begin
    FBin.PopUpBinPopup(application);
    // working with a resource, active planning area or a capacity reservation
    if GetOccMoveForm <> nil then
    begin
      id := FBin.GetSchedObjByRow(GRow);
      FBin.ShowGroupLinesInBin(ShowBatchGroupLinesInBin, ShowContinueGroupLinesInBin);
      if (ShowContinueGroupLinesInBin <> CsSCG_No) or ShowBatchGroupLinesInBin then
      begin
        IdGroup := p_sc.LinesBelongToGroup(id, isGroup);
        if isGroup then
          Id := IdGroup;
      end;

      if  (id <> CSchedIdNull)
      and (id <>p_pl.GetCompatModeInPlanId) then
      begin
        GetOccMoveForm.Reset;
        p_sc.GetPlanInfo(id, planInfo);

        if (ssShift in Shift) then
          ChangeOccTo(TMqmActArea(p_sc.GetExtLinkPtr(id)), 0  true, id, false) // right side
        else
          ChangeOccTo(TMqmActArea(p_sc.GetExtLinkPtr(id)), 0  false, id, false) // left side
      end;
    end;
  end;  }
end;

//----------------------------------------------------------------------------//

procedure GetBinCfg(BinType: TBinType; var ColArray : array of TBinColCurrent);
begin
  ConfBinLoadDefaultValues(ColArray);
end;

//----------------------------------------------------------------------------//

function SetFilterParams(BinColId : CBinColId; Value : variant; var dataType : CBinColValType; Info : boolean;

                         Pos : Integer; BinFilterParms :TBinFilterParms; var Title : string; binGrid : Pointer) : boolean;
var
  num : Integer;
  pId : TPropId;
begin
  Result := true;
  Title := TBinDrawGrid(binGrid).BinColumnSet[Pos].Title;
  case BinColId of
    CSC_ProdReq : begin
                    if Assigned(BinFilterParms) then
                    begin
                      BinFilterParms.RecFilt.ProdReq := Value;
                      Include(BinFilterParms.RecFilt.Options, FiltProdReq);
                      dataType := CBT_string
                    end;
                  end;
    CSC_ProdStep : begin
                     if Assigned(BinFilterParms) then
                     begin
                       BinFilterParms.RecFilt.StepId := Value;
                       Include(BinFilterParms.RecFilt.Options, FiltStepId);
                       dataType := CBT_integer
                     end;
                   end;
    CSC_ProdSubStep : begin
                        if Assigned(BinFilterParms) then
                        begin
                          BinFilterParms.RecFilt.SubStepId := Value;
                          Include(BinFilterParms.RecFilt.Options, FiltSubStepId);
                          dataType := CBT_integer
                        end;
                      end;

    CSC_GroupNo :  begin
                     if Assigned(BinFilterParms) then
                     begin
                       BinFilterParms.RecFilt.GroupNum := Value;
                       Include(BinFilterParms.RecFilt.Options, FiltGroupNum);
                       dataType := CBT_integer
                     end;
                   end;

    CSC_WkctCode :  begin
                      if Assigned(BinFilterParms) then
                      begin
                        BinFilterParms.RecFilt.wkCtrCode := Value;
                        Include(BinFilterParms.RecFilt.Options, FiltWkcr);
                        dataType := CBT_string;
                      end;
                   end;

    CSC_WkctProc : begin
                     if Assigned(BinFilterParms) then
                     begin
                       BinFilterParms.RecFilt.wkcProc := Value;
                       Include(BinFilterParms.RecFilt.Options, FlitProcces);
                       dataType := CBT_string;
                     end;
                   end;

    CSC_ProdType : begin
                     if Assigned(BinFilterParms) then
                     begin
                       BinFilterParms.RecFilt.ProdType := Value;
                       Include(BinFilterParms.RecFilt.Options, FiltProdType);
                       dataType := CBT_string;
                     end;
                   end;

    CSC_ProdFamily : begin
                       if Assigned(BinFilterParms) then
                       begin

                         BinFilterParms.RecFilt.ProductFamily := Value;
                         Include(BinFilterParms.RecFilt.Options, FiltProdFamily);
                         dataType := CBT_string;
                       end;
                     end;

    CSC_ProdMatFamily : begin
                          if Assigned(BinFilterParms) then
                          begin
                            BinFilterParms.RecFilt.MaterialFamily := Value;
                            Include(BinFilterParms.RecFilt.Options, FiltMaterialFamily);
                            dataType := CBT_string;
                          end;
                        end;

    CSC_QtyToSched : begin
                     if Assigned(BinFilterParms) then
                     begin
                       BinFilterParms.RecFilt.MinQty := Value;
                       Include(BinFilterParms.RecFilt.Options, FiltQty);
                       dataType := CBT_float
                     end;
                   end;

    CSC_Rsc : begin
                     if Assigned(BinFilterParms) then
                     begin
                       BinFilterParms.RecFilt.Resource := Value;
                       Include(BinFilterParms.RecFilt.Options, FiltResource);
                       dataType := CBT_string;
                     end;
                   end;

    CSC_LowStartDate, CSC_LowStartTimeLimit : begin
                        if Assigned(BinFilterParms) then
                        begin
                          BinFilterParms.RecFilt.ProdLowDate_From := Value;
                          BinFilterParms.RecFilt.ProdLowDate_From := trunc(BinFilterParms.RecFilt.ProdLowDate_From);
                          BinFilterParms.RecFilt.ProdLowDate_To := BinFilterParms.RecFilt.ProdLowDate_From;
                          Include(BinFilterParms.RecFilt.Options, FiltLowDate);
                          dataType := CBT_date
                        end;
                       end;

    CSC_ProdDlvDate : begin
                        if Assigned(BinFilterParms) then
                        begin
                          BinFilterParms.RecFilt.ProdDelivDate_From := Value;
                          BinFilterParms.RecFilt.ProdDelivDate_From := trunc(BinFilterParms.RecFilt.ProdDelivDate_From);
                          BinFilterParms.RecFilt.ProdDelivDate_To := BinFilterParms.RecFilt.ProdDelivDate_From;
                          Include(BinFilterParms.RecFilt.Options, FiltDeliveryDate);
                          dataType := CBT_date
                        end;
                      end;

    CSC_PlanStartDate : begin
                          if Assigned(BinFilterParms) then
                          begin
                            BinFilterParms.RecFilt.PlanStartDate_From := Value;
                            BinFilterParms.RecFilt.PlanStartDate_From := trunc(BinFilterParms.RecFilt.PlanStartDate_From);
                            BinFilterParms.RecFilt.PlanStartDate_To := BinFilterParms.RecFilt.PlanStartDate_From;
                            Include(BinFilterParms.RecFilt.Options, FiltPlanStartDate);
                            dataType := CBT_date
                          end;
                        end;
    CSC_ProgStart    : begin
                          if Assigned(BinFilterParms) then
                          begin
                            BinFilterParms.RecFilt.SchedStartDate_From := Value;
                            BinFilterParms.RecFilt.SchedStartDate_From := trunc(BinFilterParms.RecFilt.SchedStartDate_From);
                            BinFilterParms.RecFilt.SchedStartDate_To := BinFilterParms.RecFilt.SchedStartDate_From;
                            Include(BinFilterParms.RecFilt.Options, FiltSchedStartDate);
                            dataType := CBT_date;
                          end;
                        end;

    CSC_HighEndLimit  : begin
                          if Assigned(BinFilterParms) then
                          begin
                            BinFilterParms.RecFilt.LatestEndingDate_From := Value;
                            BinFilterParms.RecFilt.LatestEndingDate_From := trunc(BinFilterParms.RecFilt.LatestEndingDate_From);
                            BinFilterParms.RecFilt.LatestEndingDate_To := BinFilterParms.RecFilt.LatestEndingDate_From;
                            Include(BinFilterParms.RecFilt.Options, FiltLatestEndingDate);
                            dataType := CBT_date
                          end;
                        end;

    CSC_WkctGrp :  begin
                      if Assigned(BinFilterParms) then
                      begin
                        BinFilterParms.RecFilt.wkCtrGroup := Value;
                        Include(BinFilterParms.RecFilt.Options, FiltWkcrGrp);
                        dataType := CBT_string;
                      end;
                   end;

    CSC_WkctPlant :  begin
                      if Assigned(BinFilterParms) then
                      begin
                        BinFilterParms.RecFilt.wkCtrPlant := Value;
                        Include(BinFilterParms.RecFilt.Options, FiltWkcrPlant);
                        dataType := CBT_string;
                      end;
                   end;

    CSC_WkctDivision :  begin
                      if Assigned(BinFilterParms) then
                      begin
                        BinFilterParms.RecFilt.wkCtrDivision := Value;
                        Include(BinFilterParms.RecFilt.Options, FiltWkcrDivision);
                        dataType := CBT_string;
                      end;
                   end;

    CSC_property1,
    CSC_property2, CSC_property3, CSC_property4, CSC_property5, CSC_property6, CSC_property7,
    CSC_property8, CSC_property9, CSC_property10, CSC_property11, CSC_property12, CSC_property13,
    CSC_property14, CSC_property15, CSC_property16, CSC_property17, CSC_property18, CSC_property19,
    CSC_property20, CSC_property21, CSC_property22, CSC_property23, CSC_property24, CSC_property25,
    CSC_property26, CSC_property27, CSC_property28, CSC_property29, CSC_property30,
    CSC_property31, CSC_property32, CSC_property33, CSC_property34, CSC_property35,
    CSC_property36, CSC_property37, CSC_property38, CSC_property39, CSC_property40,
    CSC_property41, CSC_property42, CSC_property43, CSC_property44, CSC_property45,
    CSC_property46, CSC_property47, CSC_property48, CSC_property49, CSC_property50,
    CSC_property51, CSC_property52, CSC_property53, CSC_property54, CSC_property55,
    CSC_property56, CSC_property57, CSC_property58, CSC_property59, CSC_property60 :

                    begin
                      if Info then Exit;
                      num := -1;

                      case BinColId of
                        CSC_property1:   num := 0;
                        CSC_property2:   num := 1;
                        CSC_property3:   num := 2;
                        CSC_property4:   num := 3;
                        CSC_property5:   num := 4;
                        CSC_property6:   num := 5;
                        CSC_property7:   num := 6;
                        CSC_property8:   num := 7;
                        CSC_property9:   num := 8;
                        CSC_property10:  num := 9;
                        CSC_property11:  num := 10;
                        CSC_property12:  num := 11;
                        CSC_property13:  num := 12;
                        CSC_property14:  num := 13;
                        CSC_property15:  num := 14;
                        CSC_property16:  num := 15;
                        CSC_property17:  num := 16;
                        CSC_property18:  num := 17;
                        CSC_property19:  num := 18;
                        CSC_property20:  num := 19;
                        CSC_property21:  num := 20;
                        CSC_property22:  num := 21;
                        CSC_property23:  num := 22;
                        CSC_property24:  num := 23;
                        CSC_property25:  num := 24;
                        CSC_property26:  num := 25;
                        CSC_property27:  num := 26;
                        CSC_property28:  num := 27;
                        CSC_property29:  num := 28;
                        CSC_property30:  num := 29;
                        CSC_property31:  num := 30;
                        CSC_property32:  num := 31;
                        CSC_property33:  num := 32;
                        CSC_property34:  num := 33;
                        CSC_property35:  num := 34;
                        CSC_property36:  num := 35;
                        CSC_property37:  num := 36;
                        CSC_property38:  num := 37;
                        CSC_property39:  num := 38;
                        CSC_property40:  num := 39;
                        CSC_property41:  num := 40;
                        CSC_property42:  num := 41;
                        CSC_property43:  num := 42;
                        CSC_property44:  num := 43;
                        CSC_property45:  num := 44;
                        CSC_property46:  num := 45;
                        CSC_property47:  num := 46;
                        CSC_property48:  num := 47;
                        CSC_property49:  num := 48;
                        CSC_property50:  num := 49;
                        CSC_property51:  num := 50;
                        CSC_property52:  num := 51;
                        CSC_property53:  num := 52;
                        CSC_property54:  num := 53;
                        CSC_property55:  num := 54;
                        CSC_property56:  num := 55;
                        CSC_property57:  num := 56;
                        CSC_property58:  num := 57;
                        CSC_property59:  num := 58;
                        CSC_property60:  num := 59
                      end;

                     if (num <> -1) then
                     begin
                       pId := DBAppGlobals.ShowBinPropArry[num];
                       Title := GetPropCodeFromID(pId);
                       BinFilterParms.RecFilt.PropCod[1] := Title;
                       BinFilterParms.RecFilt.PropValfrom[1] := value;
                       BinFilterParms.RecFilt.PropValTo[1] := '';
                      // BinFilterParms.RecFilt.PropValTo[1] := value;
                       Include(BinFilterParms.RecFilt.Options, FiltProp);
                       BinFilterParms.RecFilt.IsPropEnter := true;
                       BinFilterParms.SetPropValue(Title,'', BinFilterParms.RecFilt.PropValfrom[1],
                       BinFilterParms.RecFilt.PropValTo[1]);

                       Title := GetPropDescr(pId);
                       if (TBinDrawGrid(binGrid).BinColumnSet[Pos].Title <> ' ') and (TBinDrawGrid(binGrid).BinColumnSet[Pos].Title <> '') then
                          Title := TBinDrawGrid(binGrid).BinColumnSet[Pos].Title;
                       dataType := CBT_string;
                     end;
                   end

    else
      Result := false;
  end;

end;

//----------------------------------------------------------------------------//

procedure ClearFilterParams(var Options : TFiltOptions; BinFilterParms : TBinFilterParms; TabType : TTabType);
begin

  Exclude(Options, FiltSeq);
  BinFilterParms.RecFilt.Sequence := 0;

  Exclude(Options, FiltCBSeq);
  BinFilterParms.RecFilt.CBSequence := 0;

  Exclude(Options, FiltProdReq);
  BinFilterParms.RecFilt.Resource := '';

  Exclude(Options, FiltResCat);
  BinFilterParms.RecFilt.ResCatCode := '';

  Exclude(Options, FiltStepId);
  BinFilterParms.RecFilt.StepId := -1;

  Exclude(Options, FiltStepIdTo);
  BinFilterParms.RecFilt.StepIdTo := -1;

  Exclude(Options, FiltSubStepId);
  BinFilterParms.RecFilt.SubStepId := -1;

  Exclude(Options, FiltSubStepIdTo);
  BinFilterParms.RecFilt.SubStepIdTo := -1;

  Exclude(Options, FiltGroupNum);
  BinFilterParms.RecFilt.GroupNum := 1234;

  Exclude(Options, FiltGroupNumTo);
  BinFilterParms.RecFilt.GroupNumTo := 1234;

  Exclude(Options, FiltProdType);
  BinFilterParms.RecFilt.ProdType := '';

  Exclude(Options, FiltStepType);
  BinFilterParms.RecFilt.StepType := CST_undef;

  Exclude(Options, FiltWkcr);
  BinFilterParms.RecFilt.wkCtrCode := '';

  Exclude(Options, FlitProcces);
  BinFilterParms.RecFilt.wkcProc := '';

  Exclude(Options, FiltWkcrTo);
  BinFilterParms.RecFilt.wkCtrCodeTo := '';

  Exclude(Options, FlitProccesTo);
  BinFilterParms.RecFilt.wkcProcTo := '';

  Exclude(Options, FiltProdFamily);
  BinFilterParms.RecFilt.ProductFamily := '';

  Exclude(Options, FiltMaterialFamily);
  BinFilterParms.RecFilt.MaterialFamily := '';

  Exclude(Options, FiltResource);
  BinFilterParms.RecFilt.Resource := '';

  Exclude(Options, FiltResourceTo);
  BinFilterParms.RecFilt.ResourceTo := '';

  Exclude(Options, FiltResCat);
  BinFilterParms.RecFilt.ResCatCode := '';

  Exclude(Options, FiltQty);
  BinFilterParms.RecFilt.MinQty := -1;
  BinFilterParms.RecFilt.MaxQty := -1;

  Exclude(Options, FiltAfterDeliveryInDays);
  BinFilterParms.RecFilt.AfterDeliveryInDays := -1;

  Exclude(Options, FiltBeforeEarliestStartInDays);
  BinFilterParms.RecFilt.BeforeEarliestStartIndays := -1;

  Exclude(Options, FiltAfterLatestEndInDays);
  BinFilterParms.RecFilt.AfterLatestEndInDays := -1;

  Exclude(Options, FiltCompWithPrevJobInCase);
  BinFilterParms.RecFilt.CompWithPrevJobInCase := -1;

  Exclude(Options, FiltCompWithResInCase);
  BinFilterParms.RecFilt.CompWithResInCase := -1;

  Exclude(Options, FiltJobMsg);
  BinFilterParms.RecFilt.JobMsg := false;

  Exclude(Options, FiltIgnoredProg);
  BinFilterParms.RecFilt.IgnoredProg := false;

  Exclude(Options, FiltAfterDeliveryInDays);
  BinFilterParms.RecFilt.AfterDeliveryInDays := -1;

  Exclude(Options, FiltBeforeEarliestStartInDays);
  BinFilterParms.RecFilt.BeforeEarliestStartIndays := -1;

  Exclude(Options, FiltAfterLatestEndInDays);
  BinFilterParms.RecFilt.AfterLatestEndInDays := -1;

  Exclude(Options, FiltCompWithPrevJobInCase);
  BinFilterParms.RecFilt.CompWithPrevJobInCase := -1;

  Exclude(Options, FiltShouldBeScheduledIndays);
  BinFilterParms.RecFilt.ShouldBeScheduledIndays := -1;

  Exclude(Options, FiltAfterDeliveryInDays);
  BinFilterParms.RecFilt.AfterDeliveryInDays := -1;

  Exclude(Options, FiltBeforeEarliestStartInDays);
  BinFilterParms.RecFilt.BeforeEarliestStartIndays := -1;

  Exclude(Options, FiltAfterLatestEndInDays);
  BinFilterParms.RecFilt.AfterLatestEndInDays := -1;

  Exclude(Options, FiltCompWithPrevJobInCase);
  BinFilterParms.RecFilt.CompWithPrevJobInCase := -1;

  Exclude(Options, FiltShouldBeScheduledIndays);
  BinFilterParms.RecFilt.ShouldBeScheduledIndays := -1;

  Exclude(Options, FiltWkcr_Active);
  Exclude(Options, FiltJobPriority);
  Exclude(Options, FiltWkcrAlterntiv);
 // Include(Options, FiltSchedJobs);
  if TabType = Tb_AutoSeqResults then
  begin
    Include(Options, FiltSchedJobs);
    Exclude(Options, FiltOnlySchedJobs)
  end
  else
    Include(Options, FiltOnlySchedJobs);
  Include(Options, FiltFltJobsOnGantt);
  Include(Options, FiltProgress);
  Include(Options, Filt_ReadOnly);
  exclude(Options, FiltReProcces);
  Include(Options, FiltClosedJobs);
  exclude(Options, FiltJobPriority);
  include(Options, FiltGroups);

  Include(Options, FiltConfLevelsfinal);
  Include(Options, FiltConfLevelsIni);
  Include(Options, FiltConfLevels1);
  Include(Options, FiltConfLevels2);
  Include(Options, FiltConfLevels3);
  Include(Options, FiltConfLevels4);
  Include(Options, FiltConfLevels5);
  Include(Options, FiltConfLevels5);
  Include(Options, FiltCustomerDateConfirmed);
  Include(Options, FiltCustomerDateCulculated);
  Include(Options, FiltCustomerDateRequested);

  Exclude(Options, FiltItemTypeBaseWarp);
  Exclude(Options, FiltProdCodeBaseWarp);
  Exclude(Options, FiltItemTypeSecondWarp);
  Exclude(Options, FiltProdCodeSecondWarp);
  if TabType = Tb_WeavJobsForWarp then
  begin
    Exclude(Options, FiltSchedJobs);
    Exclude(Options, FiltClosedJobs);
    Exclude(Options, FiltOnlySchedJobs);
    Exclude(Options, FiltProgress);
    Include(Options, FiltWkcr_Active);
    Include(Options, FiltWkcrAlterntiv);
  end;
  BinFilterParms.RecFilt.ItemTypeCodeBaseWarp := '';
  BinFilterParms.RecFilt.ProdCodeBaseWarp := '';
  BinFilterParms.RecFilt.ItemTypeCodeSecondWarp := '';
  BinFilterParms.RecFilt.ProdCodeSecondWarp := '';

  Exclude(Options, FiltWkcrGrp);
  Exclude(Options, FiltWkcrPlant);
  Exclude(Options, FiltWkcrDivision);
  Exclude(Options, FiltResCat);

  BinFilterParms.RecFilt.wkCtrGroup := '';
  BinFilterParms.RecFilt.wkCtrPlant := '';
  BinFilterParms.RecFilt.wkCtrDivision := '';
  BinFilterParms.RecFilt.ResCatCode := '';
end;

//----------------------------------------------------------------------------//

{ TBinFilterParms }

function TBinFilterParms.GetValCodeByIndex(Index: Integer; var RscCode: string; var val1: variant; var Val2: variant): string;
var
  PRec : PRecProp;
begin
  Result := '';
  if Assigned(m_ListFiltProp) then
  begin
    Assert(Index < m_ListFiltProp.count);
    PRec := PRecProp(m_ListFiltProp[Index]);
    RscCode := PRec.ResCode;
    val1 := PRec.ValFrom;
    Val2 := PRec.ValTo;
    Result := PRec.PropCode;
  end;
end;

//----------------------------------------------------------------------------//

function TBinFilterParms.TestJobValFilter(ValJob: variant; ValFrom: variant; ValTo: variant): boolean;
var
  L : Integer;
  TempStr : string;
begin
  Result := false;

  if (Trim(valFrom) = '') and (Trim(valTo) = '') then
  begin
    if VarIsStr(ValJob) then
      if Trim(valto) = ValJob then
         Result := true;
    Exit;
  end;

  if Trim(Valto) = '' then
  begin
{    if (UpperCase(Trim(valFrom)) = ValJob) or (Trim(valFrom) = ValJob) then
      Result := true;
    if not VarIsStr(ValJob) then exit;
    L := Length(Trim(valFrom));
    if L < 3 then exit;
    TempStr := copy(Trim(valFrom),1,1);
    if TempStr <> '%' then Exit;
    TempStr := copy(Trim(valFrom),L,1);
    if TempStr <> '%' then Exit;
    TempStr := copy(Trim(valFrom),2,l-2);
    Result := AnsiContainsStr(ValJob , TempStr);
    exit;  }

    if (UpperCase(Trim(valFrom)) = ValJob) or (Trim(valFrom) = ValJob) then
      Result := true
    else
    begin
      if not VarIsStr(ValJob) then exit;
      L := Length(Trim(valFrom));

      if L < 2 then exit;
      if (copy(Trim(valFrom),1,1) <> '%') and (copy(Trim(valFrom),L,1) <> '%') then
         Exit;
      if (copy(Trim(valFrom),1,1) = '%') and (copy(Trim(valFrom),L,1) = '%') then
      begin
        if L < 3 then exit;
        TempStr := copy(Trim(valFrom),2,l-2);
        if AnsiContainsStr(ValJob , TempStr) then
        begin
          Result := true;
          Exit;
        end
      end
      else if copy(Trim(valFrom),1,1) = '%' then
      begin
        TempStr := copy(Trim(valFrom),2,l-1);
        if AnsiEndsStr(TempStr, ValJob) then
        begin
          Result := true;
          exit;
        end
      end
      else
      begin
        TempStr := copy(Trim(valFrom),1,l-1);
        if AnsiStartsStr(TempStr, ValJob) then
        begin
          Result := true;
          exit;
        end
      end;

    end;



  end;

  if Trim(valFrom) = '' then
  begin
    if (UpperCase(Trim(valto)) <= ValJob) or (Trim(valto) <= ValJob) then
      Result := true;
    exit;
  end;

  if VarIsStr(ValJob) then
  begin
    if (UpperCase(valFrom) <= ValJob) and (UpperCase(valTo) >= ValJob) then
        Result := true;
  end
  else
  begin
    try
     if (valFrom <> '') and (valTo = '') then
         valTo := valFrom;

     if (valFrom <= ValJob) and (valTo >= ValJob) then
         Result := true;
    except
      if (valFrom <= FloatToStr(ValJob)) and (valTo >= FloatToStr(ValJob)) then
         Result := true;
    end;

  end;
//  if (valFrom <= ValJob) and (valTo >= ValJob) then
//      Result := true;

end;

//----------------------------------------------------------------------------//

function CheckTempPropList(TempList : TStringList; Prop : string) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to TempList.Count - 1 do
  begin
    if (Prop = TempList.Strings[I]) then
    begin
      Result := true;
      Exit;
    end;
  end;
  TempList.Add(prop);
end;

//----------------------------------------------------------------------------//

function CheckPropInOrList(List : TList; Prop : string) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to List.Count -1 do
  begin
    if (Prop = PRecProp(List[I]).PropCode) then
    begin
      Result := true;
      exit;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TBinFilterParms.TestMatFilterOpts(id: TSchedID): boolean;
var
  i, J, G: integer;
  SonId : TSchedId;
  WrkCtr: TMqmWrkCtr;
  CodeProp, AltProc, RscCode : string;
  FieldVal, WcVal : variant;
  Wc, TempWC : TMqmWrkCtr;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  valFrom, valTo, JobVal: variant;
  JobDate, JobTime, JobDateTime : TDateTime;
  linkInfo: TSQlinkInfo;
  PlanSetUp, PlanExeTime : double;
  Properties : TProperties;
  dataType: CBinColValType;
  DatesInfo: TSQDatesInfo;
  SchedType: string;
  ListOrProp : TList;
  TempPropList : TStringList;
  TempProp : string;
  errSet: SetOfErrors;
  compRes, compPrev : TCompatVal;
  extPtr : TMqmActArea;
  ShouldBeScheduled : boolean;
  ResultcompRes, ResultCompPrev : boolean;
  IsGroup, JobIsGrouped : boolean;
  GetMsg, SentMsg, NoPropValue : boolean;
  ShowBatchGroupLinesInBin : boolean;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
  ProdNo : string;
  Step : integer;
  value: variant;
  StepInfo: TSQStepInfo;
  SchedIdsList : TMSchedList;
  StepList : TList;
  ProdReqDet : TSCProdReqDet;
  tJob : TSCProdSched;
  PWorkCnterProcessAllowed : PTWorkCnterProcessAllowed;
  Idx: integer;
  Multiplier, NumberOfEntries : integer;
  ExistPropInGroup : boolean;
  IdGroup : TschedId;
  DummyList : TList;
begin
  Result := true;

  TempPropList := nil;
  DummyList    := nil;

  if not p_sc.IsProdSchedMaterial(Id) then exit;
  if p_sc.IsProdSchedMaterialDeleted(Id) then
  begin
    Result := false;
    exit
  end;

  p_sc.GetFldValue(id, CSC_Warp_level, FieldVal, dataType);
  var lvl := FieldVal;
  FieldVal := '';

  if lvl = 'Basic' then
  begin
    if (Filt_Item_Type in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_Item_Type, FieldVal, dataType))
      and (FieldVal <> RecFilt.Item_Type) then
        Result := False;

    if (Filt_Product_code in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_PRODUCT_CODE, FieldVal, dataType))
      and (FieldVal <> RecFilt.Product_code) then
        Result := False;

  end;

  if (Filt_NetGroup_Code in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_NET_GROUP_CODE, FieldVal, dataType))
    and (FieldVal <> RecFilt.NetGroup_Code) then
      Result := False;

  if (Filt_MaterialDetailCode in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_Detail_Code, FieldVal, dataType))
    and (FieldVal <> RecFilt.MaterialDetailCode) then
      Result := False;

  if (Filt_MaterialCode_SUB_DETAILS in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_MATERIAL_CODE_SUB_DET, FieldVal, dataType))
    and (FieldVal <> RecFilt.MaterialCodeSubDetail) then
      Result := False;
  //end

  if lvl = 'Second' then
  begin
    //2nd level
    if (Filt_Item_Type in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_Item_Type, FieldVal, dataType))
      and (FieldVal <> RecFilt.Item_Type2) then
        Result := False;

    if (Filt_Product_code in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_PRODUCT_CODE, FieldVal, dataType))
      and (FieldVal <> RecFilt.Product_code2) then
        Result := False;

  end;

  {
  else if lvl = 'Both' then
  begin
    if (Filt_Item_Type in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_Item_Type, FieldVal, dataType))
      and (FieldVal <> RecFilt.Item_Type) then
        Result := False;

    if (Filt_Product_code in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_PRODUCT_CODE, FieldVal, dataType))
      and (FieldVal <> RecFilt.Product_code) then
        Result := False;

    if (Filt_NetGroup_Code in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_NET_GROUP_CODE, FieldVal, dataType))
      and (FieldVal <> RecFilt.NetGroup_Code) then
        Result := False;

    if (Filt_MaterialDetailCode in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_Detail_Code, FieldVal, dataType))
      and (FieldVal <> RecFilt.MaterialDetailCode) then
        Result := False;

    if (Filt_MaterialCode_SUB_DETAILS in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_MATERIAL_CODE_SUB_DET, FieldVal, dataType))
      and (FieldVal <> RecFilt.MaterialCodeSubDetail) then
        Result := False;
    //2nd level
    if (Filt_Item_Type in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_Item_Type, FieldVal, dataType))
      and (FieldVal <> RecFilt.Item_Type2) then
        Result := False;

    if (Filt_Product_code in RecFilt.Options) and (p_sc.GetFldValue(id, CSC_Mat_PRODUCT_CODE, FieldVal, dataType))
      and (FieldVal <> RecFilt.Product_code2) then
        Result := False;

  end
  else
    result := false;    }

  //SCHED JOBS
  if (FiltOnlySchedJobs in RecFilt.Options) then
  begin
    if p_sc.GetExtLinkPtr_Material(id) = nil then Result := false
  end else
  begin
    if not (FiltSchedJobs in RecFilt.Options) then
      if p_sc.GetExtLinkPtr_Material(id) <> nil then Result := false;
  end;

  //WARP level
  if (Filt_WarpBasicLvl in RecFilt.Options) and not (Filt_WarpSecondLvl in RecFilt.Options)
    and (p_sc.GetFldValue(id, CSC_Warp_level, FieldVal, dataType)) then
  begin

    if FieldVal = '' then
       result := false
    else
    begin
      if FieldVal = 'Basic' then FieldVal := 0
      else if FieldVal = 'Second' then FieldVal := 1
      else if FieldVal = 'Both' then FieldVal := 2;

      if (FieldVal <> RecFilt.WarpLevel)  then
        Result := false;
    end;

  end else
  if not (Filt_WarpBasicLvl in RecFilt.Options) and (Filt_WarpSecondLvl in RecFilt.Options)
    and (p_sc.GetFldValue(id, CSC_Warp_level, FieldVal, dataType)) then
  begin

    if FieldVal = '' then
       FieldVal := false
    else
    begin
      if FieldVal = 'Basic' then FieldVal := 0
      else if FieldVal = 'Second' then FieldVal := 1
      else if FieldVal = 'Both' then FieldVal := 2;

      if (FieldVal <> RecFilt.WarpLevel)  then
        Result := false;
    end;
  end
  else
  begin
    p_sc.GetFldValue(id, CSC_Warp_level, FieldVal, dataType);
    if FieldVal = '' then
      Result := false;
  end;

  //PROPERTIES FILTER
  if Result and (FiltProp in RecFilt.Options)
  and (GetCountPropList <> -1)
  and (RecFilt.IsPropEnter) then // only to be sure ..
  begin

    if not m_IsListOrProp then
    begin
      ListOrProp := GetOrConditionProp;
      m_ListOrProp := ListOrProp
    end
    else
      ListOrProp := m_ListOrProp;

    for I := 0 to GetCountPropList - 1 do
    begin
      CodeProp := GetValCodeByIndex(I,RscCode,valFrom,valTo);
      if Assigned(ListOrProp) then
      begin
         if CheckPropInOrList(ListOrProp, CodeProp) then
            continue;
      end;

        Properties := p_sc.GetProperties(id, nil);
        if not Assigned(Properties) then
          continue;

        if not Properties.GetValforCode(CodeProp, RscCode, -1, JobVal) then
        begin
          if (valFrom = '') and (valTo = '') then continue;
          Result := false;
          Break;
        end;

        Result := TestJobValFilter(JobVal, valFrom, valTo);

        if not Result then
        begin
          exit;
        end;
    end;

    if Assigned(ListOrProp) then
    begin
      TempPropList := TStringList.Create;
      for I := 0 to ListOrProp.Count - 1 do
      begin
        TempProp := PRecProp(ListOrProp[I]).PropCode;

        if CheckTempPropList(TempPropList, TempProp) then
          continue;

        Properties := p_sc.GetProperties(id, nil);
          if not Assigned(Properties) then
            continue;

          NoPropValue := false;
          if not Properties.GetValforCode(TempProp, RscCode, -1, JobVal) then
          begin
            NoPropValue := true;
//            Result := false;
//            Break;
          end;

          Result := true;

          for J := 0 to ListOrProp.Count - 1 do
          begin
            if (PRecProp(ListOrProp[J]).PropCode = TempProp) then
            begin
              if NoPropValue then
              begin
                if (PRecProp(ListOrProp[J]).ValFrom = '') and (PRecProp(ListOrProp[J]).ValTo = '') then
                begin
                  Result := true;
                  break;
                end;
                Result := false;
                Continue;
              end;
              Result := TestJobValFilter(JobVal, PRecProp(ListOrProp[J]).ValFrom , PRecProp(ListOrProp[J]).ValTo);
              if Result then
              begin
                break;
              end
            end;
          end;
          if not Result then
          begin
            if Assigned(TempPropList) then
              TempPropList.Free;
            exit;
          end;
        //end;
      end;

    end;

  end;

  if Assigned(TempPropList) then
    TempPropList.Free;

end;

//----------------------------------------------------------------------------//

function TBinFilterParms.TestFilterOpts(id: TSchedID; WcProcAllowedList : Tlist) : boolean;
var
  i, J, G: integer;
  SonId : TSchedId;
  WrkCtr: TMqmWrkCtr;
  CodeProp, AltProc, RscCode : string;
  FieldVal, WcVal : variant;
  Wc, TempWC : TMqmWrkCtr;
  Res : TMqmRes;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  valFrom, valTo, JobVal: variant;
  JobDate, JobTime, JobDateTime : TDateTime;
  linkInfo: TSQlinkInfo;
  PlanSetUp, PlanExeTime : double;
  Properties : TProperties;
  dataType: CBinColValType;
  DatesInfo: TSQDatesInfo;
  SchedType: string;
  ListOrProp : TList;
  TempPropList : TStringList;
  TempProp : string;
  errSet: SetOfErrors;
  compRes, compPrev : TCompatVal;
  extPtr : TMqmActArea;
  ShouldBeScheduled : boolean;
  ResultcompRes, ResultCompPrev : boolean;
  IsGroup, JobIsGrouped : boolean;
  GetMsg, SentMsg, NoPropValue : boolean;
  ShowBatchGroupLinesInBin : boolean;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
  ProdNo : string;
  Step : integer;
  value: variant;
  StepInfo: TSQStepInfo;
  SchedIdsList : TMSchedList;
  StepList : TList;
  ProdReqDet : TSCProdReqDet;
  tJob : TSCProdSched;
  PWorkCnterProcessAllowed : PTWorkCnterProcessAllowed;
  Idx: integer;
  Multiplier, NumberOfEntries : integer;
  ExistPropInGroup : boolean;
  IdGroup : TschedId;
  DummyList : TList;
  ProgressIgnoredType : CProgressTypeIgnored;
begin
  Result := false;
  TempPropList := nil;
  DummyList    := nil;

  if p_sc.IsProdSchedMaterial(Id) then
  begin
    // just to make sure (should not arrive here ...) avi
    exit;
  end;

  if (p_sc.GetExtLinkPtr(id) = nil) then
     p_sc.SetSchedType(id, '0');

  if Assigned(FBin) then
    FBin.ShowGroupLinesInBin(ShowBatchGroupLinesInBin, ShowContinueGroupLinesInBin);

  if p_sc.BelongsToGroup(id, ShowBatchGroupLinesInBin, ShowContinueGroupLinesInBin) then exit;

  if ((FiltJobPriority in RecFilt.Options)
     and (p_sc.ToBeSched(id, nil) <> CSX_YES)) then exit;

  Result := true;

  if (FiltOnlySchedJobs in RecFilt.Options) then
  begin
    if p_sc.GetExtLinkPtr(id) = nil then Result := false
  end else
  begin
    if not (FiltSchedJobs in RecFilt.Options) then
      if p_sc.GetExtLinkPtr(id) <> nil then Result := false;
  end;

  if FiltIgnoredProg in RecFilt.Options then
    if not (p_sc.GetProgressOverrideStatus(id, ProgressIgnoredType) = Prg_Ignored) then Result := false;

  if (FiltOnlyProgress in RecFilt.Options) then
  begin
    if (p_sc.IsProgressed(id) = prg_none) and (not (p_sc.GetProgressOverrideStatus(id, ProgressIgnoredType) = Prg_Ignored)) then Result := false
  end else
  begin
    if not (FiltProgress in RecFilt.Options) then
      if (p_sc.IsProgressed(id) <> prg_none) and (not (p_sc.GetProgressOverrideStatus(id, ProgressIgnoredType) = Prg_Ignored)) then Result := false;
  end;

  if not (FiltGroups in RecFilt.Options) then // If not "Show ALSO groups"
  begin
    p_sc.GetLinkInfo(id, linkInfo);
    if   linkInfo.isGroup then JobIsGrouped := true
    else p_sc.LinesBelongToGroup(id, JobIsGrouped);
    if (FiltOnlyGroups in RecFilt.Options) and not JobIsGrouped then Result := false;
    if not (FiltOnlyGroups in RecFilt.Options) and JobIsGrouped then Result := false;
  end;

  if not Result then exit;

  if (FiltOnlyReadOnly in RecFilt.Options) then
  begin
    if (p_sc.GetVisbleInBin(id) <> CSB_ReadOnly) then Result := false;
  end else
  begin
    if not (Filt_ReadOnly in RecFilt.Options) then
    begin
      if (p_sc.GetVisbleInBin(id) <> CSB_Normal) then Result := false;
    end
  end;

  if (FiltOnlyClosedJobs in RecFilt.Options) then
  begin
    if p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType) then
       if not FieldVal then
         Result := false;
  end else
  begin
    if not (FiltClosedJobs in RecFilt.Options) then
      if p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType) then
      begin
        if FieldVal then
          Result := false;
      end;
  end;

  if not Result then exit;

  if (FlitProcces in RecFilt.Options) and not (FlitProccesTo in RecFilt.Options)
  and p_sc.GetFldValue(id, CSC_WkctProc, FieldVal, dataType)
  and (RecFilt.wkcProc <> FieldVal) then
    Result := false
  else if (FlitProcces in RecFilt.Options) and (FlitProccesTo in RecFilt.Options)
  and p_sc.GetFldValue(id, CSC_WkctProc, FieldVal, dataType) then
  begin
    if (FieldVal < RecFilt.wkcProc) or (FieldVal > RecFilt.wkcProcTo) then
       Result := false
  end;

  p_sc.GetLinkInfo(id, linkInfo);
  if Result and linkInfo.isGroup and (FiltProdReq in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_ProdReq, RecFilt.ProdReq, RecFilt.ProdReqTo);
  end
  else
  begin
    if Result and (FiltProdReq in RecFilt.Options) and not (FiltProdReqTo in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_ProdReq, FieldVal, dataType)
    and (FieldVal <> UpperCase(RecFilt.ProdReq)) then
        Result := false

    else if Result and (FiltProdReq in RecFilt.Options) and (FiltProdReqTo in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_ProdReq, FieldVal, dataType) then
    begin
      if (FieldVal < UpperCase(RecFilt.ProdReq)) or (FieldVal > UpperCase(RecFilt.ProdReqTo)) then
        Result := false;
    end;

  end;

  if Result and linkInfo.isGroup and (FiltStepType in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_StepType, RecFilt.StepType, '');
  end
  else
  begin
    if Result and (FiltStepType in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_StepType, FieldVal, dataType)
    and (FieldVal <> RecFilt.StepType) then
        Result := false;
  end;

  if Result and linkInfo.isGroup and (FiltStepId in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_ProdStep, RecFilt.StepId, RecFilt.StepIdTo);
  end
  else
  begin
    if Result and (FiltStepId in RecFilt.Options) and not (FiltStepIdTo in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_ProdStep, FieldVal, dataType)
    and (FieldVal <> RecFilt.StepId) then
        Result := false

    else if Result and (FiltStepId in RecFilt.Options) and (FiltStepIdTo in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_ProdStep, FieldVal, dataType) then
    begin
      if ((FieldVal < RecFilt.StepId) or (FieldVal > RecFilt.StepIdTo)) then
        Result := false;
    end;
  end;

  if Result and linkInfo.isGroup and (FiltSubStepId in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_ProdSubStep, RecFilt.SubStepId, RecFilt.SubStepIdTo);
  end
  else
  begin
    if Result and (FiltSubStepId in RecFilt.Options) and not (FiltSubStepIdTo in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_ProdSubStep, FieldVal, dataType)
    and (FieldVal <> RecFilt.SubStepId) then
        Result := false

    else if Result and (FiltSubStepId in RecFilt.Options) and (FiltSubStepIdTo in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_ProdSubStep, FieldVal, dataType) then
    begin
      if ((FieldVal < RecFilt.SubStepId) or (FieldVal > RecFilt.SubStepIdTo)) then
        Result := false;
    end;
  end;

  if Result and not linkInfo.isGroup and (FiltGroupNum in RecFilt.Options) then
  begin
    IdGroup := p_sc.LinesBelongToGroup(id, isGroup);
    if isGroup then
      Result := p_sc.CheckGroupValues(IdGroup, CSC_GroupNo, RecFilt.GroupNum, RecFilt.GroupNumTo)
    else
      Result := false
  end
  else if Result and linkInfo.isGroup and (FiltGroupNum in RecFilt.Options) then
    Result := p_sc.CheckGroupValues(Id, CSC_GroupNo, RecFilt.GroupNum, RecFilt.GroupNumTo);

{  if Result and linkInfo.isGroup and (FiltGroupNum in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_GroupNo, RecFilt.GroupNum, RecFilt.GroupNumTo);
  end
  else if Result and not linkInfo.isGroup and (FiltGroupNum in RecFilt.Options) then
     Result := false;   }

  if Result and linkInfo.isGroup and (FiltProdType in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_ProdType, RecFilt.ProdType, '');
  end
  else
  begin
    if Result and (FiltProdType in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_ProdType, FieldVal, dataType)
    and (FieldVal <> RecFilt.ProdType) then
        Result := false;
  end;

  if Result and linkInfo.isGroup and (FiltResource in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_Rsc, RecFilt.Resource, RecFilt.ResourceTo);
  end
  else
  begin
    if Result and (FiltResource in RecFilt.Options) and not (FiltResourceTo in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_Rsc, FieldVal, dataType)
    and (FieldVal <> RecFilt.Resource) then
        Result := false

    else if Result and (FiltResource in RecFilt.Options) and (FiltResourceTo in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_Rsc, FieldVal, dataType) then
    if (FieldVal < RecFilt.Resource) or (FieldVal > RecFilt.ResourceTo) then
        Result := false;
  end;

  if Result and linkInfo.isGroup and (FiltProdFamily in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_ProdFamily, RecFilt.ProductFamily, '');
  end
  else
  begin
    if Result and (FiltProdFamily in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_ProdFamily, FieldVal, dataType)
    and (FieldVal <> RecFilt.ProductFamily) then
        Result := false;
  end;

  if Result and linkInfo.isGroup and (FiltMaterialFamily in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_ProdMatFamily, RecFilt.MaterialFamily, '');
  end
  else
  begin
    if Result and (FiltMaterialFamily in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_ProdMatFamily, FieldVal, dataType)
    and (FieldVal <> RecFilt.MaterialFamily) then
        Result := false;
  end;

  if Result and linkInfo.isGroup and (FiltReProcces in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_ReprocNo, '', '');
  end
  else
  begin
    if Result and (FiltReProcces in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_ReprocNo, FieldVal, dataType)
    and (FieldVal <= 0) then
        Result := false;
  end;

  if Result and (FiltQty in RecFilt.Options)
  and p_sc.GetFldValue(id, CSC_QtyToSched, FieldVal, dataType) then
  begin
    if (RecFilt.MaxQty = -1) then
    begin
      if (FieldVal <> RecFilt.MinQty) then
        Result := false
    end
    else if (FieldVal < RecFilt.MinQty) or (FieldVal > RecFilt.MaxQty) then
      Result := false
  end;

  if (FiltItemTypeBaseWarp in RecFilt.Options) or (FiltProdCodeBaseWarp in RecFilt.Options) or
    (FiltItemTypeSecondWarp in RecFilt.Options) or (FiltProdCodeSecondWarp in RecFilt.Options) then
  begin
    ProdNo := p_sc.GetFldDescr(id, CSC_ProdReq, false);
    Step := StrToInt(p_sc.GetFldDescr(id, CSC_ProdStep, false));
    StepInfo := p_sc.GetStepInfoByNumber(ProdNo, Step);
  end;

  if FiltItemTypeBaseWarp in RecFilt.Options then
  begin
    if Trim(StepInfo.ProdTypeBaseLvl) <> Trim(RecFilt.ItemTypeCodeBaseWarp) then
       result := false;
  end;

  if FiltProdCodeBaseWarp in RecFilt.Options then
  begin
    if Trim(StepInfo.ProductBaseLvl) <> Trim(RecFilt.ProdCodeBaseWarp) then
       result := false;
  end;

  if FiltItemTypeSecondWarp in RecFilt.Options then
  begin
    if Trim(StepInfo.ProdTypeSecondLvl) <> Trim(RecFilt.ItemTypeCodeSecondWarp) then
       result := false;
  end;

  if FiltProdCodeSecondWarp in RecFilt.Options then
  begin
    if Trim(StepInfo.ProductSecondLvl) <> Trim(RecFilt.ProdCodeSecondWarp) then
       result := false;
  end;

  if not Result then Exit;

  if WcProcAllowedList.Count > 0 then
  begin
    Result := false;
    NumberOfEntries := WcProcAllowedList.Count;
    p_sc.GetFldValue(id, CSC_WkctCode, WcVal, dataType);
    if (NumberOfEntries > 0) and p_sc.GetFldValue(id, CSC_WkctProc, FieldVal, dataType) then
    begin
      Multiplier := 1;
      while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
      Idx := Multiplier - 1;
      while (Multiplier > 0) do
      begin
        Multiplier := trunc(Multiplier / 2);
        if (idx >= NumberOfEntries) then
        begin
          idx := idx - Multiplier;
          Continue;
        end;
        if (PTWorkCnterProcessAllowed(WcProcAllowedList[Idx]).wc < WcVal) then
        begin
          idx := idx + Multiplier;
          Continue;
        end;
        if (PTWorkCnterProcessAllowed(WcProcAllowedList[Idx]).wc > WcVal) then
        begin
          idx := idx - Multiplier;
          Continue;
        end;
        if PTWorkCnterProcessAllowed(WcProcAllowedList[Idx]).proc <> '' then
        begin
          if (PTWorkCnterProcessAllowed(WcProcAllowedList[Idx]).proc < FieldVal) then
          begin
            idx := idx + Multiplier;
            Continue;
          end;
          if (PTWorkCnterProcessAllowed(WcProcAllowedList[Idx]).proc > FieldVal) then
          begin
            idx := idx - Multiplier;
            Continue;
          end;
        end;
        Result := true;
        Break;
      end;
    end;
  end;

  //////////////////////////

  if Result and linkInfo.isGroup and (FiltWkcr in RecFilt.Options) then
  begin
    Result := p_sc.CheckGroupValues(id, CSC_WkctCode, RecFilt.wkCtrCode, RecFilt.wkCtrCodeTo);
  end
  else
  begin
    if Result and (FiltWkcr in RecFilt.Options) and not (FiltWkcrTo in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_WkctCode, FieldVal, dataType)
    and (FieldVal <> UpperCase(RecFilt.wkCtrCode)) then
        Result := false

    else if Result and (FiltWkcr in RecFilt.Options) and (FiltWkcrTo in RecFilt.Options)
    and p_sc.GetFldValue(id, CSC_WkctCode, FieldVal, dataType) then
    begin
      if (FieldVal < UpperCase(RecFilt.wkCtrCode)) or (FieldVal > UpperCase(RecFilt.wkCtrCodeTo)) then
        Result := false;
    end;

  end;


  //////////////////////////
  if not Result then exit;

  if (FiltLowDate in RecFilt.Options)
  or (FiltDeliveryDate in RecFilt.Options)
  or (FiltLowStartDate in RecFilt.Options)
  or (FiltPlanStartDate in RecFilt.Options)
  or (FiltSchedStartDate in RecFilt.Options)
  or (FiltSchedStartDate_Days in RecFilt.Options)
  or (FiltPlanStartDate in RecFilt.Options)
  or (FiltPlanStartDate_DaysFromToday in RecFilt.Options)
  or (FiltPlanEndDate in RecFilt.Options)
  or (FiltPlanEndDate_DaysFromToday in RecFilt.Options)
  or (FiltNextStartDate in RecFilt.Options)
  or (FiltNextStartDate_DaysFromToday in RecFilt.Options)
  or (FiltPrevEndDate in RecFilt.Options)
  or (FiltPrevEndDate_DaysFromToday in RecFilt.Options)
  or (FiltLatestEndingDate in RecFilt.Options)
  or (FiltScheduledJobsCrossesDateTime in RecFilt.Options)
  or (FiltAfterDeliveryDay in RecFilt.Options)
  or (FiltBeforeEarliestStart in RecFilt.Options)
  or (FiltAfterLatestEnd in RecFilt.Options)
  or (FiltMissingMaterials in RecFilt.Options)
  or (FiltMissingAddRes in RecFilt.Options)
  or (FiltShouldBeScheduled in RecFilt.Options)
  or (FiltOveridePrevious in RecFilt.Options)
  or (FiltOverideNext in RecFilt.Options)
  or (FiltImbalancedSteps in RecFilt.Options)
  or (FiltCompWithPrevJob in RecFilt.Options)
  or (FiltCompWithRes in RecFilt.Options)
  //new
  or (FiltBeforeEarliestStartFixed in RecFilt.Options)
  or (FiltBeforeEarliestStartInDaysFixed in RecFilt.Options) then
    p_sc.GetDatesInfo(id, DatesInfo);

  if Result and (FiltLowDate in RecFilt.Options)
  and p_sc.GetFldValue(id, CSC_LowStartTimeLimit, FieldVal, dataType) then
  begin
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);
    //if "to Date" is not checked and "from Date" is Checked
    if (RecFilt.ProdLowDate_To = 0) and (RecFilt.ProdLowDate_From > 0) then
    begin
      //don't show earlier jobs but do show later jobs
      if (JobDate < RecFilt.ProdLowDate_from) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.ProdLowDate_To > 0) and (RecFilt.ProdLowDate_From = 0) then
    begin
       //don't show later jobs but do show earlier jobs
       if (JobDate > RecFilt.ProdLowDate_To) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.ProdLowDate_To > 0) and (RecFilt.ProdLowDate_From > 0) then
    begin
      //don't show later jobs and don't show earlier jobs
      if ((JobDate < RecFilt.ProdLowDate_From) or (JobDate > RecFilt.ProdLowDate_To)) then
        Result := false;
    end;
  end;

  if Result and (FiltDeliveryDate in RecFilt.Options) then
  begin
    DecodeDate(DatesInfo.DeliveryDate, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);
    //if "to Date" is not checked and "from Date" is Checked
    if (RecFilt.ProdDelivDate_To = 0) and (RecFilt.ProdDelivDate_From > 0) then
    begin
      //don't show earlier jobs but do show later jobs
      if (JobDate < RecFilt.ProdDelivDate_from) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.ProdDelivDate_To > 0) and (RecFilt.ProdDelivDate_From = 0) then
    begin
       //don't show later jobs but do show earlier jobs
       if (JobDate > RecFilt.ProdDelivDate_To) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.ProdDelivDate_To > 0) and (RecFilt.ProdDelivDate_From > 0) then
    begin
      //don't show later jobs and don't show earlier jobs
      if ((JobDate < RecFilt.ProdDelivDate_From) or (JobDate > RecFilt.ProdDelivDate_To)) then
        Result := false;
    end;
  end;

  if Result and (FiltLowStartDate in RecFilt.Options) then
  begin
    DecodeDate(DatesInfo.LowStrDate, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);
    //if "to Date" is not checked and "from Date" is Checked
    if (RecFilt.LowStartDate_To = 0) and (RecFilt.LowStartDate_From > 0) then
    begin
      //don't show earlier jobs but do show later jobs
      if (JobDate < RecFilt.LowStartDate_from) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.LowStartDate_To > 0) and (RecFilt.LowStartDate_From = 0) then
    begin
       //don't show later jobs but do show earlier jobs
       if (JobDate > RecFilt.LowStartDate_To) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.LowStartDate_To > 0) and (RecFilt.LowStartDate_From > 0) then
    begin
      //don't show later jobs and don't show earlier jobs
      if ((JobDate < RecFilt.LowStartDate_From) or (JobDate > RecFilt.LowStartDate_To)) then
        Result := false;
    end;
  end;

  if Result and (FiltPlanStartDate in RecFilt.Options) then
  begin
    DecodeDate(DatesInfo.PlannedStrDate, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);
    //if "to Date" is not checked and "from Date" is Checked
    if (RecFilt.PlanStartDate_To = 0) and (RecFilt.PlanStartDate_From > 0) then
    begin
      //don't show earlier jobs but do show later jobs
      if (JobDate < RecFilt.PlanStartDate_from) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.PlanStartDate_To > 0) and (RecFilt.PlanStartDate_From = 0) then
    begin
       //don't show later jobs but do show earlier jobs
       if (JobDate > RecFilt.PlanStartDate_To) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.PlanStartDate_To > 0) and (RecFilt.PlanStartDate_From > 0) then
    begin
      //don't show later jobs and don't show earlier jobs
      if ((JobDate < RecFilt.PlanStartDate_From) or (JobDate > RecFilt.PlanStartDate_To)) then
        Result := false;
    end;
  end;

  if Result and (FiltSchedStartDate in RecFilt.Options) then
  begin
    p_sc.GetFldValue(id, CSC_ProgStart, FieldVal, dataType);
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    //if "to Date" is not checked and "from Date" is Checked
    if (RecFilt.SchedStartDate_To = 0) and (RecFilt.SchedStartDate_From > 0) then
    begin
      //don't show earlier jobs but do show later jobs
      if (JobDate < RecFilt.SchedStartDate_From) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.SchedStartDate_To > 0) and (RecFilt.SchedStartDate_From = 0) then
    begin
       //don't show later jobs but do show earlier jobs
       if (JobDate > RecFilt.SchedStartDate_To) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.SchedStartDate_To > 0) and (RecFilt.SchedStartDate_From > 0) then
    begin
      //don't show later jobs and don't show earlier jobs
      if ((JobDate < RecFilt.SchedStartDate_From) or (JobDate > RecFilt.SchedStartDate_To)) then
        Result := false;
    end;
  end;

  if Result and (FiltSchedStartDate_Days in RecFilt.Options) then
  begin
    p_sc.GetFldValue(id, CSC_ProgStart, FieldVal, dataType);
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);
    DecodeTime(FieldVal, Hour, Min, Sec, MSec);
    JobTime := EncodeTime(Hour, Min, Sec, 0);
    JobDateTime := JobDate + JobTime;

    if (RecFilt.SchedStartDate_DaysTillToday = -1) and (RecFilt.SchedStartDate_DaysFromToday > -1) then
    begin
      if (JobDate < (RecFilt.SchedStartDate_DaysFromToday + date)) then
        Result := false
    end;

    if (RecFilt.SchedStartDate_DaysTillToday > -1) and (RecFilt.SchedStartDate_DaysFromToday = -1) then
    begin
       if (JobDate > (RecFilt.SchedStartDate_DaysFromToday + date)) then
        Result := false
    end;

    if (RecFilt.SchedStartDate_DaysFromToday > -1) and (RecFilt.SchedStartDate_DaysTillToday > -1) then
    begin
      if ((JobDate < (RecFilt.SchedStartDate_DaysFromToday + date)) or (JobDateTime > (RecFilt.SchedStartDate_DaysTillToday + date + Frac(RecFilt.SchedStartDate_DaysTillToday_time/60/24)))) then
          Result := false;
     //   if ((JobDate < (RecFilt.SchedStartDate_DaysFromToday + date)) or (JobDate > (RecFilt.SchedStartDate_DaysTillToday + date))) then
     //     Result := false;
    end;
  end;

  ///////////////////////////

  if Result and (FiltLowStartDate in RecFilt.Options) then
  begin
    p_sc.GetFldValue(id, CSC_PlanStartDate, FieldVal, dataType);
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    //if "to Date" is not checked and "from Date" is Checked
    if (RecFilt.PlanStartDate_To = 0) and (RecFilt.PlanStartDate_From > 0) then
    begin
      //don't show earlier jobs but do show later jobs
      if (JobDate < RecFilt.PlanStartDate_From) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.PlanStartDate_To > 0) and (RecFilt.PlanStartDate_From = 0) then
    begin
       //don't show later jobs but do show earlier jobs
       if (JobDate > RecFilt.PlanStartDate_To) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.PlanStartDate_To > 0) and (RecFilt.PlanStartDate_From > 0) then
    begin
      //don't show later jobs and don't show earlier jobs
      if ((JobDate < RecFilt.PlanStartDate_From) or (JobDate > RecFilt.PlanStartDate_To)) then
        Result := false;
    end;
  end;

  if Result and (FiltPlanStartDate_DaysFromToday in RecFilt.Options) then
  begin
    p_sc.GetFldValue(id, CSC_PlanStartDate, FieldVal, dataType);
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    if (RecFilt.PlanStartDate_DaysTillToday = -1) and (RecFilt.PlanStartDate_DaysFromToday > -1) then
    begin
      if (JobDate < (RecFilt.PlanStartDate_DaysFromToday + date)) then
        Result := false
    end;

    if (RecFilt.PlanStartDate_DaysTillToday > -1) and (RecFilt.PlanStartDate_DaysFromToday = -1) then
    begin
       if (JobDate > (RecFilt.PlanStartDate_DaysFromToday + date)) then
        Result := false
    end;

    if (RecFilt.PlanStartDate_DaysFromToday > -1) and (RecFilt.PlanStartDate_DaysTillToday > -1) then
    begin
      if ((JobDate < (RecFilt.PlanStartDate_DaysFromToday + date)) or (JobDate > (RecFilt.PlanStartDate_DaysTillToday + date))) then
        Result := false;
    end;
  end;

  if Result and (FiltPlanEndDate in RecFilt.Options) then
  begin
    p_sc.GetFldValue(id, CSC_PlanEndDate, FieldVal, dataType);
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    //if "to Date" is not checked and "from Date" is Checked
    if (RecFilt.PlanEndDate_To = 0) and (RecFilt.PlanEndDate_From > 0) then
    begin
      //don't show earlier jobs but do show later jobs
      if (JobDate < RecFilt.PlanEndDate_From) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.PlanEndDate_To > 0) and (RecFilt.PlanEndDate_From = 0) then
    begin
       //don't show later jobs but do show earlier jobs
       if (JobDate > RecFilt.PlanEndDate_To) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.PlanEndDate_To > 0) and (RecFilt.PlanEndDate_From > 0) then
    begin
      //don't show later jobs and don't show earlier jobs
      if ((JobDate < RecFilt.PlanEndDate_From) or (JobDate > RecFilt.PlanEndDate_To)) then
        Result := false;
    end;
  end;

  //////////////NEW

  if Result and (FiltBeforeEarliestStartFixed in RecFilt.Options) then
  begin
    //p_sc.GetFldValue(id, LowStrDate, FieldVal, dataType);
    DecodeDate(DatesInfo.LowStrDate, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    //if "to Date" is not checked and "from Date" is Checked
    if (RecFilt.FixedEarliestDate_To = 0) and (RecFilt.FixedEarliestDate_From > 0) then
    begin
      //don't show earlier jobs but do show later jobs
      if (JobDate < RecFilt.FixedEarliestDate_From) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.FixedEarliestDate_To > 0) and (RecFilt.FixedEarliestDate_From = 0) then
    begin
       //don't show later jobs but do show earlier jobs
       if (JobDate > RecFilt.FixedEarliestDate_To) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.FixedEarliestDate_To > 0) and (RecFilt.FixedEarliestDate_From > 0) then
    begin
      //don't show later jobs and don't show earlier jobs
      if ((JobDate < RecFilt.FixedEarliestDate_From) or (JobDate > RecFilt.FixedEarliestDate_To)) then
        Result := false;
    end;
  end;

  if Result and (FiltBeforeEarliestStartInDaysFixed in RecFilt.Options) then
  begin
    //p_sc.GetFldValue(id, CSC_PlanStartDate, FieldVal, dataType);
    DecodeDate(DatesInfo.LowStrDate, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    if (RecFilt.EarliestDays_To = -1) and (RecFilt.EarliestDays_From > -1) then
    begin
      if (JobDate < (RecFilt.EarliestDays_From + date)) then
        Result := false
    end;

    if (RecFilt.EarliestDays_To > -1) and (RecFilt.EarliestDays_From = -1) then
    begin
       if (JobDate > (RecFilt.EarliestDays_From + date)) then
        Result := false
    end;

    if (RecFilt.EarliestDays_To > -1) and (RecFilt.EarliestDays_From > -1) then
    begin
      if ((JobDate < (RecFilt.EarliestDays_From + date)) or (JobDate > (RecFilt.EarliestDays_To + date))) then
        Result := false;
    end;
  end;
  ///

  if Result and (FiltPlanEndDate_DaysFromToday in RecFilt.Options) then
  begin
    p_sc.GetFldValue(id, CSC_PlanEndDate, FieldVal, dataType);
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    if (RecFilt.PlanEndDate_DaysTillToday = -1) and (RecFilt.PlanEndDate_DaysFromToday > -1) then
    begin
      if (JobDate < (RecFilt.PlanEndDate_DaysFromToday + date)) then
        Result := false
    end;

    if (RecFilt.PlanEndDate_DaysTillToday > -1) and (RecFilt.PlanEndDate_DaysFromToday = -1) then
    begin
       if (JobDate > (RecFilt.PlanEndDate_DaysFromToday + date)) then
        Result := false
    end;

    if (RecFilt.PlanEndDate_DaysFromToday > -1) and (RecFilt.PlanEndDate_DaysTillToday > -1) then
    begin
      if ((JobDate < (RecFilt.PlanEndDate_DaysFromToday + date)) or (JobDate > (RecFilt.PlanEndDate_DaysTillToday + date))) then
        Result := false;
    end;
  end;


  if Result and (FiltPrevEndDate in RecFilt.Options) then
  begin
    p_sc.GetFldValue(id, CSC_PrvHighestDate, FieldVal, dataType);
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    //if "to Date" is not checked and "from Date" is Checked
    if (RecFilt.PrevEndDate_to = 0) and (RecFilt.PrevEndDate_From > 0) then
    begin
      //don't show earlier jobs but do show later jobs
      if (JobDate < RecFilt.PrevEndDate_From) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.PrevEndDate_To > 0) and (RecFilt.PrevEndDate_From = 0) then
    begin
       //don't show later jobs but do show earlier jobs
       if (JobDate > RecFilt.PrevEndDate_To) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.PrevEndDate_To > 0) and (RecFilt.PrevEndDate_From > 0) then
    begin
      //don't show later jobs and don't show earlier jobs
      if ((JobDate < RecFilt.PrevEndDate_From) or (JobDate > RecFilt.PrevEndDate_To)) then
        Result := false;
    end;
  end;

  if Result and (FiltPrevEndDate_DaysFromToday in RecFilt.Options) then
  begin
    p_sc.GetFldValue(id, CSC_PrvHighestDate, FieldVal, dataType);
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    if (RecFilt.PrevEndDate_DaysTillToday = -1) and (RecFilt.PrevEndDate_DaysFromToday > -1) then
    begin
      if (JobDate < (RecFilt.PrevEndDate_DaysFromToday + date)) then
        Result := false
    end;

    if (RecFilt.PrevEndDate_DaysTillToday > -1) and (RecFilt.PrevEndDate_DaysFromToday = -1) then
    begin
       if (JobDate > (RecFilt.PrevEndDate_DaysFromToday + date)) then
        Result := false
    end;

    if (RecFilt.PrevEndDate_DaysFromToday > -1) and (RecFilt.PrevEndDate_DaysTillToday > -1) then
    begin
      if ((JobDate < (RecFilt.PrevEndDate_DaysFromToday + date)) or (JobDate > (RecFilt.PrevEndDate_DaysTillToday + date))) then
        Result := false;
    end;
  end;

  if Result and (FiltNextStartDate in RecFilt.Options) then
  begin
    p_sc.GetFldValue(id, CSC_NxtLowestDate, FieldVal, dataType);
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    //if "to Date" is not checked and "from Date" is Checked
    if (RecFilt.NextStartDate_to = 0) and (RecFilt.NextStartDate_From > 0) then
    begin
      //don't show earlier jobs but do show later jobs
      if (JobDate < RecFilt.NextStartDate_From) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.NextStartDate_to > 0) and (RecFilt.NextStartDate_From = 0) then
    begin
       //don't show later jobs but do show earlier jobs
       if (JobDate > RecFilt.NextStartDate_to) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.NextStartDate_to > 0) and (RecFilt.NextStartDate_From > 0) then
    begin
      //don't show later jobs and don't show earlier jobs
      if ((JobDate < RecFilt.NextStartDate_From) or (JobDate > RecFilt.NextStartDate_to)) then
        Result := false;
    end;
  end;

  if Result and (FiltNextStartDate_DaysFromToday in RecFilt.Options) then
  begin
    p_sc.GetFldValue(id, CSC_NxtLowestDate, FieldVal, dataType);
    DecodeDate(FieldVal, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    if (RecFilt.NextStartDate_DaysTillToday = -1) and (RecFilt.NextStartDate_DaysFromToday > -1) then
    begin
      if (JobDate < (RecFilt.NextStartDate_DaysFromToday + date)) then
        Result := false
    end;

    if (RecFilt.NextStartDate_DaysTillToday > -1) and (RecFilt.NextStartDate_DaysFromToday = -1) then
    begin
       if (JobDate > (RecFilt.NextStartDate_DaysFromToday + date)) then
        Result := false
    end;

    if (RecFilt.NextStartDate_DaysFromToday > -1) and (RecFilt.NextStartDate_DaysTillToday > -1) then
    begin
      if ((JobDate < (RecFilt.NextStartDate_DaysFromToday + date)) or (JobDate > (RecFilt.NextStartDate_DaysTillToday + date))) then
        Result := false;
    end;
  end;


  ///////////////////////////

  if Result and (FiltLatestEndingDate in RecFilt.Options) then
  begin
    DecodeDate(DatesInfo.HighEndDate, Year, Month, Day);
    JobDate := EncodeDate(Year, Month, Day);

    if (RecFilt.LatestEndingDate_To = 0) and (RecFilt.LatestEndingDate_From > 0) then
    begin
      if (JobDate < RecFilt.LatestEndingDate_From) then
        Result := false
    end;
    //if "to Date" is  checked and "from Date" is not Checked
    if (RecFilt.LatestEndingDate_To > 0) and (RecFilt.LatestEndingDate_From = 0) then
    begin
       if (JobDate > RecFilt.LatestEndingDate_To) then
        Result := false
    end;
    //if both "to Date" and "from Date" are Checked
    if (RecFilt.LatestEndingDate_To > 0) and (RecFilt.LatestEndingDate_From > 0) then
    begin
      if ((JobDate < RecFilt.LatestEndingDate_From) or (JobDate > RecFilt.LatestEndingDate_To)) then
        Result := false;
    end;
  end;

  if Result and (FiltScheduledJobsCrossesDateTime in RecFilt.Options) then
  begin

    if (DatesInfo.HighEndDate = 0) or (DatesInfo.endDate = 0) then
       Result := false
    else
    begin

      if (RecFilt.ScheduleJobsCrosses_To = 0) and (RecFilt.ScheduleJobsCrosses_From > 0) then
      begin
        if DatesInfo.endDate < RecFilt.ScheduleJobsCrosses_From then
          Result := false;
      end;

      if (RecFilt.ScheduleJobsCrosses_To > 0) and (RecFilt.ScheduleJobsCrosses_From = 0) then
      begin
        if DatesInfo.startDate > RecFilt.ScheduleJobsCrosses_To then
          Result := false;
      end;

      if (RecFilt.ScheduleJobsCrosses_To > 0) and (RecFilt.ScheduleJobsCrosses_From > 0) then
      begin
        if DatesInfo.endDate < RecFilt.ScheduleJobsCrosses_From then
          Result := false
        else if DatesInfo.startDate > RecFilt.ScheduleJobsCrosses_To then
          Result := false;
      end;

    end;
  end;

  SchedType := p_sc.GetSchedType(id);
  if Result and (SchedType <> '0') then
  begin
    //SchedType := p_sc.GetSchedType(id);
    if not (FiltConfLevNewLog in RecFilt.Options) then//  ((FiltFix in RecFilt.Options) or (FiltTemporary in RecFilt.Options)) then//or
    begin
      if (FiltTemporary in RecFilt.Options)
      and (SchedType = '2') then
        Result := false;
      if (FiltFix in RecFilt.Options) and (SchedType <> '2') then Result := false;
    end
    else
    begin
      if SchedType = '2' then
      begin
        if not (FiltConfLevelsfinal in RecFilt.Options) then
           Result := false
      end
      else if SchedType = '1' then
      begin
        if not (FiltConfLevelsIni in RecFilt.Options) then
           Result := false
      end
      else if SchedType = '3' then
      begin
        if not (FiltConfLevels1 in RecFilt.Options) then
           Result := false
      end
      else if SchedType = '4' then
      begin
        if not (FiltConfLevels2 in RecFilt.Options) then
           Result := false
      end
      else if SchedType = '5' then
      begin
        if not (FiltConfLevels3 in RecFilt.Options) then
           Result := false
      end
      else if SchedType = '6' then
      begin
        if not (FiltConfLevels4 in RecFilt.Options) then
           Result := false
      end
      else if SchedType = '7' then
      begin
        if not (FiltConfLevels5 in RecFilt.Options) then
           Result := false
      end
    end;

  end;

  if result and not (FiltCustomerDateConfirmed in RecFilt.Options) then
  begin
   // p_sc.GetFldValue(id, CSC_CustomerDate, FieldVal, dataType);
   // if FieldVal = _('Confirmed') then result := false;
  end;

  if result and not (FiltCustomerDateCulculated in RecFilt.Options) then
  begin
   // p_sc.GetFldValue(id, CSC_CustomerDate, FieldVal, dataType);
   // if FieldVal = _('Culculated') then result := false;
  end;

  if result and not (FiltCustomerDateRequested in RecFilt.Options) then
  begin
   // p_sc.GetFldValue(id, CSC_CustomerDate, FieldVal, dataType);
   // if FieldVal = _('Requested') then result := false;
  end;

  if Result and (FiltProp in RecFilt.Options)
  and (GetCountPropList <> -1)
  and (RecFilt.IsPropEnter) then // only to be sure ..
  begin

    if not m_IsListOrProp then
    begin
      ListOrProp := GetOrConditionProp;
      m_ListOrProp := ListOrProp
    end
    else
      ListOrProp := m_ListOrProp;

    for I := 0 to GetCountPropList - 1 do
    begin
      CodeProp := GetValCodeByIndex(I,RscCode,valFrom,valTo);
      if Assigned(ListOrProp) then
      begin
         if CheckPropInOrList(ListOrProp, CodeProp) then
            continue;
      end;

      if linkInfo.isGroup then
      begin

        if ((ShowContinueGroupLinesInBin = CsSCG_No) and (p_sc.GetJobType(id) = CST_Continuous))
             or (ShowBatchGroupLinesInBin and (p_sc.GetJobType(id) = CST_batch)) then
        begin
          ExistPropInGroup := false;

          for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
          begin
            SonId := p_sc.GetGrpSon(Id, G);
            Properties := p_sc.GetProperties(SonId,nil);
            if not Assigned(Properties) then
              continue;

            if not Properties.GetValforCode(CodeProp, RscCode, -1, JobVal) then
            begin
              continue;
            end;

          //  Result := TestJobValFilter(JobVal, valFrom, valTo);
            if TestJobValFilter(JobVal, valFrom, valTo) then

           // if Result then
            begin
              ExistPropInGroup := true;
              break
            end;

          end;

          if ExistPropInGroup then
             Result := true
          else
          begin
            result := false;
            break;
          end;


        end else
        begin
          for G := 0 to p_sc.GetGrpNumSons(id) - 1 do
          begin
            SonId := p_sc.GetGrpSon(id, G);

            Properties := p_sc.GetProperties(SonId, nil);
            if not Assigned(Properties) then
              continue;

            if not Properties.GetValforCode(CodeProp, RscCode, -1, JobVal) then
            begin
              if (valFrom = '') and (valTo = '') then continue;
              Result := false;
              Break;
            end;

            Result := TestJobValFilter(JobVal, valFrom, valTo);

            if not Result then
            begin
              exit;
            end;

          end;
        end;

      end else
      begin

        Properties := p_sc.GetProperties(id, nil);
        if not Assigned(Properties) then
          continue;

        if not Properties.GetValforCode(CodeProp, RscCode, -1, JobVal) then
        begin
          if (valFrom = '') and (valTo = '') then continue;
          Result := false;
          Break;
        end;

        Result := TestJobValFilter(JobVal, valFrom, valTo);

        if not Result then
        begin
          exit;
        end;

      end;
    end;

    if Assigned(ListOrProp) then
    begin
      TempPropList := TStringList.Create;
      for I := 0 to ListOrProp.Count - 1 do
      begin
        TempProp := PRecProp(ListOrProp[I]).PropCode;

        if CheckTempPropList(TempPropList, TempProp) then
          continue;

        if linkInfo.isGroup then
        begin
          for G := 0 to p_sc.GetGrpNumSons(id) - 1 do
          begin
            SonId := p_sc.GetGrpSon(id, G);

            Properties := p_sc.GetProperties(SonId, nil);
            if not Assigned(Properties) then
              continue;

            NoPropValue := false;
            if not Properties.GetValforCode(TempProp, RscCode, -1, JobVal) then
            begin
              NoPropValue := true;
//              Result := false;
//              Break;
            end;

            Result := true;
            for J := 0 to ListOrProp.Count - 1 do
            begin
              if (PRecProp(ListOrProp[J]).PropCode = TempProp) then
              begin

                if NoPropValue then
                begin
                  if (PRecProp(ListOrProp[J]).ValFrom = '') and (PRecProp(ListOrProp[J]).ValTo = '') then
                  begin
                    Result := true;
                    break;
                  end;
                  Result := false;
                  Continue;
                end;

                Result := TestJobValFilter(JobVal, PRecProp(ListOrProp[J]).ValFrom , PRecProp(ListOrProp[J]).ValTo);
                if Result then
                begin
                  break;
                end
              end;
            end;
            if not result then
            begin
              if Assigned(TempPropList) then
                TempPropList.Free;
              exit;
            end;

          end;
        end
        else
        begin
          Properties := p_sc.GetProperties(id, nil);
          if not Assigned(Properties) then
            continue;

          NoPropValue := false;
          if not Properties.GetValforCode(TempProp, RscCode, -1, JobVal) then
          begin
            NoPropValue := true;
//            Result := false;
//            Break;
          end;

          Result := true;
          for J := 0 to ListOrProp.Count - 1 do
          begin
            if (PRecProp(ListOrProp[J]).PropCode = TempProp) then
            begin
              if NoPropValue then
              begin
                if (PRecProp(ListOrProp[J]).ValFrom = '') and (PRecProp(ListOrProp[J]).ValTo = '') then
                begin
                  Result := true;
                  break;
                end;
                Result := false;
                Continue;
              end;
              Result := TestJobValFilter(JobVal, PRecProp(ListOrProp[J]).ValFrom , PRecProp(ListOrProp[J]).ValTo);
              if Result then
              begin
                break;
              end
            end;
          end;
          if not Result then
          begin
            if Assigned(TempPropList) then
              TempPropList.Free;
            exit;
          end;
        end;
      end;

    end;

  end;

  if Assigned(TempPropList) then
    TempPropList.Free;

  ResultcompRes := false;
  ResultCompPrev := false;
  ShouldBeScheduled := false;
  if Result and ((FiltAfterDeliveryDay in RecFilt.Options) or (FiltBeforeEarliestStart in RecFilt.Options) or (FiltAfterLatestEnd in RecFilt.Options) or
                 (FiltMissingMaterials in RecFilt.Options) or (FiltMissingAddRes in RecFilt.Options) or (FiltShouldBeScheduled in RecFilt.Options) or
                 (FiltOveridePrevious in RecFilt.Options)  or (FiltOverideNext in RecFilt.Options) or (FiltImbalancedSteps in RecFilt.Options) or
                 (FiltCompWithPrevJob in RecFilt.Options)  or (FiltCompWithRes in RecFilt.Options)) then
  begin
    errSet := [];
    p_sc.CheckErrors(id, CSEG_All, errSet, DummyList);

    if ((FiltShouldBeScheduled in RecFilt.Options) and (p_sc.GetExtLinkPtr(id) = nil)) then
    begin
      PlanSetUp     := StrToFloat(p_sc.GetFldDescr(id, CSC_PlanSetup_Float, false));
      PlanExeTime   := StrToFloat(p_sc.GetFldDescr(id, CSC_ExeTime_Float, false));
      if (FiltShouldBeScheduledIndays in RecFilt.Options) then
        ShouldBeScheduled := (Now + PlanSetUp/24/60 + PlanExeTime/24/60) + RecFilt.ShouldBeScheduledIndays > DatesInfo.PlannedEndDate
      else
        ShouldBeScheduled := (Now + PlanSetUp/24/60 + PlanExeTime/24/60) > DatesInfo.PlannedEndDate;
    end;

    if (FiltCompWithRes in RecFilt.Options) and (FiltCompWithResInCase in RecFilt.Options) and (p_sc.GetExtLinkPtr(id) <> nil) then
    begin
      p_sc.CheckCompatWithRes(id, compRes);
      ResultcompRes := (RecFilt.CompWithResInCase <= compRes);
    end;

    if (FiltImbalancedSteps in RecFilt.Options) and (p_sc.CheckSchedSumQty(Id)) then
       Include(errSet, CSE_Imbalance);

    if (FiltCompWithPrevJob in RecFilt.Options) and (FiltCompWithPrevJobInCase in RecFilt.Options) then
    begin
      extPtr := p_sc.GetExtLinkPtr(id);
      if (extPtr <> nil) then
      begin
        compPrev := CSchedIDnull;
        p_sc.GetCompatIdWithPrevOcc(id, extPtr, compPrev);
        if (compPrev > CSchedIDnull) then
           ResultCompPrev := RecFilt.CompWithPrevJobInCase <= compPrev;
      end;
    end;

    if not ((CSE_Imbalance in errSet) or (CSE_DelDate in errSet) or (CSE_LowStrDate in errSet) or (CSE_HighEndDate in errSet) or
           (CSE_Materials in errSet) or (CSE_AddRes in errSet) or (CSE_LeftOvlp in errSet) or (CSE_RightOvlp in errSet) or
            ResultCompPrev or ResultcompRes or ShouldBeScheduled) then
    begin
      Result := false
    end
    else
    begin
      if not (((FiltAfterDeliveryDay in RecFilt.Options) and (CSE_DelDate in errSet)) or
         ((FiltAfterLatestEnd in RecFilt.Options) and (CSE_HighEndDate in errSet)) or
         ((FiltImbalancedSteps in RecFilt.Options) and (CSE_Imbalance in errSet)) or
         ((FiltBeforeEarliestStart in RecFilt.Options) and (CSE_LowStrDate in errSet)) or ShouldBeScheduled or
         ((FiltMissingMaterials in RecFilt.Options) and (CSE_Materials in errSet)) or
         ((FiltMissingAddRes in RecFilt.Options) and (CSE_AddRes in errSet)) or
         ((FiltOveridePrevious in RecFilt.Options) and (CSE_LeftOvlp in errSet)) or
         ((FiltOverideNext in RecFilt.Options) and (CSE_RightOvlp in errSet)) or ResultcompRes or ResultCompPrev) then
        Result := false;
    end;

    if result and ((FiltAfterDeliveryDay in RecFilt.Options) or (FiltBeforeEarliestStart in RecFilt.Options) or
                  (FiltAfterLatestEnd in RecFilt.Options)) then
    begin
      if (p_sc.GetExtLinkPtr(id) = nil) then Result := false;
    end;

    if result and ((FiltAfterDeliveryInDays in RecFilt.Options) or (FiltBeforeEarliestStartInDays in RecFilt.Options) or
                  (FiltAfterLatestEndInDays in RecFilt.Options)) then
    begin
      if not (((FiltAfterDeliveryDay in RecFilt.Options) and (CSE_DelDate in errSet) and (DatesInfo.endDate - DatesInfo.DeliveryDate >= RecFilt.AfterDeliveryInDays)) or
              ((FiltBeforeEarliestStart in RecFilt.Options) and (CSE_LowStrDate in errSet) and ((DatesInfo.LowStrDate - DatesInfo.startDate) >= RecFilt.BeforeEarliestStartInDays)) or
              ((FiltAfterLatestEnd in RecFilt.Options) and (CSE_HighEndDate in errSet) and (DatesInfo.endDate - DatesInfo.HighEndDate >= RecFilt.AfterLatestEndInDays))) then
        Result := false
    end;

  end;

  if RecFilt.ShowDependingOnNextHandledStep <> CsAlways then
  begin
    ProdNo := p_sc.GetFldDescr(id, CSC_ProdReq, false);
    Step := StrToInt(p_sc.GetFldDescr(id, CSC_ProdStep, false));
    if p_sc.GetNextStepToSched(ProdNo, Step, StepInfo) then
    begin
      if Assigned(StepInfo.ReqDet) then
      begin
        SchedIdsList := TMSchedList.Create(self);
        p_sc.GetStepJobs(ProdNo, StepInfo.StepNo, SchedIdsList);
        for J := 0 to SchedIdsList.GetLinkCount - 1 do
        begin
          if RecFilt.ShowDependingOnNextHandledStep = CsWhenNotScheduled then
          begin
            if p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J)) <> nil then
            begin
              result := false;
              break;
            end;
          end
          else if RecFilt.ShowDependingOnNextHandledStep = CsWhenScheduled then
          begin
            if p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J)) = nil then
            begin
              result := false;
              break;
            end;
          end;
        end;
      end;
    end;
  end;

  if RecFilt.ShowDependingOnPrevHandledStep <> CsAlways then
  begin
    ProdNo := p_sc.GetFldDescr(id, CSC_ProdReq, false);
    Step := StrToInt(p_sc.GetFldDescr(id, CSC_ProdStep, false));
    if p_sc.GetPrecStepToSched(ProdNo, step, StepInfo) then
    begin
      if Assigned(StepInfo.ReqDet) then
      begin
        SchedIdsList := TMSchedList.Create(self);
        p_sc.GetStepJobs(ProdNo, StepInfo.StepNo, SchedIdsList);
        for J := 0 to SchedIdsList.GetLinkCount - 1 do
        begin
          if RecFilt.ShowDependingOnPrevHandledStep = CsWhenNotScheduled then
          begin
            if p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J)) <> nil then
            begin
              result := false;
              break;
            end;
          end
          else if RecFilt.ShowDependingOnPrevHandledStep = CsWhenScheduled then
          begin
            if p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J)) = nil then
            begin
              result := false;
              break;
            end;
          end;
        end;
      end;
    end;
  end;

  if RecFilt.ShowDependingOnNextHandledLinkedRequest <> CsAlways then
  begin
    StepList := TList.Create;
    p_sc.GetNextConnReqSteps(Id, StepList);

    for J := 0 to StepList.Count - 1 do
    begin
      ProdReqDet := TSCProdReqDet(StepList[J]);
      for I := 0 to ProdReqDet.m_list.Count - 1 do
      begin
        tJob := TSCProdSched(ProdReqDet.m_list[I]);
        if tJob.m_isDeleted then continue;

        if RecFilt.ShowDependingOnNextHandledLinkedRequest = CsWhenNotScheduled then
        begin
          if p_sc.GetExtLinkPtr(tJob.m_Id) <> nil then
          begin
            result := false;
            break;
          end;
        end;
        if RecFilt.ShowDependingOnNextHandledLinkedRequest = CsWhenScheduled then
        begin
          if p_sc.GetExtLinkPtr(tJob.m_Id) = nil then
          begin
            result := false;
            break;
          end;
        end;
      end;
    end;
    StepList.Free;
  end;


  if RecFilt.ShowDependingOnPrevHandledLinkedRequest <> CsAlways then
  begin
    StepList := TList.Create;
    p_sc.GetPrevConnReqSteps(Id, StepList);

    for J := 0 to StepList.Count - 1 do
    begin
      ProdReqDet := TSCProdReqDet(StepList[J]);
      for I := 0 to ProdReqDet.m_list.Count - 1 do
      begin
        tJob := TSCProdSched(ProdReqDet.m_list[I]);
        if tJob.m_isDeleted then continue;

        if RecFilt.ShowDependingOnPrevHandledLinkedRequest = CsWhenNotScheduled then
        begin
          if p_sc.GetExtLinkPtr(tJob.m_Id) <> nil then
          begin
            result := false;
            break;
          end;
        end;
        if RecFilt.ShowDependingOnPrevHandledLinkedRequest = CsWhenScheduled then
        begin
          if p_sc.GetExtLinkPtr(tJob.m_Id) = nil then
          begin
            result := false;
            break;
          end;
        end;
      end;
    end;
    StepList.Free;

  end;


  if (FiltJobMsg in RecFilt.Options) then
  begin
    if not p_sc.GetStatuseMsgForJob(id, IsGroup, GetMsg, SentMsg) then
       result := false;
  end;

  if result and (m_GroupedByCode <> '') then
    if CheckGroupedByFields(Id) then
      Result := true
    else
      result := false;

  if m_AutoSeqResultFilter then
  begin
    if result and not (p_sc.GetAutoSeqTakePart(id)) then
      Result := false;
  end;

  if Result and (FiltWkcrGrp in RecFilt.Options)
  and p_sc.GetFldValue(id, CSC_WkctGrp, FieldVal, dataType)
    and (FieldVal <> RecFilt.wkCtrGroup) then
        Result := false;

  if Result and (FiltWkcrPlant in RecFilt.Options)
  and p_sc.GetFldValue(id, CSC_WkctPlant, FieldVal, dataType)
    and (FieldVal <> RecFilt.wkCtrPlant) then
        Result := false;


  if Result and (FiltWkcrDivision in RecFilt.Options)
  and p_sc.GetFldValue(id, CSC_WkctDivision, FieldVal, dataType)
    and (FieldVal <> RecFilt.wkCtrDivision) then
        Result := false;

  if Result and (FiltResCat in RecFilt.Options) then
  begin
    if p_sc.GetFldValue(id, CSC_Rsc, FieldVal, dataType) then
    begin
      Res := TMqmRes(p_pl.FindResByCode(FieldVal));
      if Assigned(Res) and Assigned(Res.p_ResCat) then
      begin
        if Res.p_ResCat.p_ResCatCode <> RecFilt.ResCatCode then
          Result := false;
      end
      else
        Result := false;
    end
    else
      Result := false;
  end

end;

//----------------------------------------------------------------------------//

procedure TBinFilterParms.ClearFiltPropList;
var
  I : Integer;
  PRec : PRecProp;
begin
  if Assigned(m_ListFiltProp) then
  begin
    for I := 0 to m_ListFiltProp.Count - 1 do
    begin
      PRec := PRecProp(m_ListFiltProp[I]);
      Dispose(PRec)
    end;
    m_ListFiltProp.Clear;
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinFilterParms.DeletePropFromList(PropCode : string);
var
  I : Integer;
  PRec : PRecProp;
begin
  if Assigned(m_ListFiltProp) then
  begin
    for I := m_ListFiltProp.Count - 1 downto 0 do
    begin
      PRec := PRecProp(m_ListFiltProp[I]);
      if PropCode = PRec.PropCode then
      begin
        Dispose(PRec);
        m_ListFiltProp.Remove(PRec);
        exit;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

constructor TBinFilterParms.Create;
begin
  inherited Create;
  m_IsListOrProp := false;
  RecFilt.GroupNum := 1234;
  RecFilt.GroupNumTo := 1234;
end;

//----------------------------------------------------------------------------//

function TBinFilterParms.GetOrConditionProp : TList;
var
  I,J : Integer;
  PRec : PRecProp;
  Prop_Or_List : TList;
  PropList : TStringList;
  ListOrProp : TStringList;
  FoundInPropList : boolean;
  FoundInTemp : boolean;
procedure CheckPropInList(Prop : string);
var
  J,K : Integer;
begin
  Result := nil;
  FoundInPropList := false;
  for J := 0 to PropList.Count - 1 do
  begin
    if (Prop = PropList.Strings[J]) then
      FoundInPropList := true
  end;
  if not FoundInPropList then
    PropList.add(Prop)
  else
  begin
    FoundInTemp := false;
    for K := 0 to ListOrProp.Count - 1 do
    begin
      if (Prop = ListOrProp.Strings[K]) then
        FoundInTemp := true;
    end;
    if not FoundInTemp then
    begin
      ListOrProp.Add(Prop);
    end;

  end;

end;

begin
  PropList := TStringList.Create;
  ListOrProp := TStringList.Create;
  Prop_Or_List := TList.Create;
  if Assigned(m_ListFiltProp) then
  begin
    for I := 0 to m_ListFiltProp.Count - 1 do
    begin
      PRec := PRecProp(m_ListFiltProp[I]);
      CheckPropInList(PRec.PropCode);
    end;
  end;

  if Assigned(m_ListFiltProp) then
  begin
    for I := 0 to ListOrProp.Count - 1 do
    begin
      for J := 0 to m_ListFiltProp.Count - 1 do
      begin
        if (ListOrProp.Strings[I] = PRecProp(m_ListFiltProp[J]).PropCode) then
           Prop_Or_List.Add(m_ListFiltProp[J]);
      end;

    end;
  end;

  if Prop_Or_List.Count > 0 then
  begin
    m_ListOrProp := Prop_Or_List;
    Result := m_ListOrProp;
  end;

  m_IsListOrProp := true;

  PropList.Free;
  ListOrProp.Free;

end;

//----------------------------------------------------------------------------//

Procedure TBinFilterParms.ClearPropRecFields;
var
  I : Integer;
begin
  for I := Low(RecFilt.PropCod) to High(RecFilt.PropCod) do
  begin
    RecFilt.PropCod[I] := '';
    RecFilt.PropRes[I] := '';
    RecFilt.PropValfrom[I] := '';
    RecFilt.PropValTo[I] := '';
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinFilterParms.CopyFilterSetting(BinFilterParms : TBinFilterParms);
var
  I : Integer;
  PRec : PRecProp;
begin
  if Assigned(BinFilterParms.m_ListFiltProp) then
  begin
    for I := 0 to BinFilterParms.m_ListFiltProp.Count - 1 do
    begin
      PRec := PRecProp(BinFilterParms.m_ListFiltProp[I]);
      SetPropValue(PRec.PropCode,PRec.ResCode,PRec.ValFrom,PRec.ValTo);
    end;
  end;
  RecFilt := BinFilterParms.RecFilt;
end;

//----------------------------------------------------------------------------//

procedure TBinFilterParms.SetPropValue(Code, RscCode : string; val1 : string; Val2 : string);
var
  PRec : PRecProp;
begin
  if not Assigned(m_ListFiltProp) then
    m_ListFiltProp := TList.Create;
  new(PRec);
  PRec.PropCode := Code;
  PRec.ResCode := RscCode;
  PRec.ValFrom := Val1;
  PRec.ValTo := Val2;
  m_ListFiltProp.add(PRec);
end;

//----------------------------------------------------------------------------//

function TBinFilterParms.GetCountPropList : Integer;
begin
  if not Assigned(m_ListFiltProp) then
  begin
    Result := -1;
    Exit;
  end;
  Result := m_ListFiltProp.count;
end;

//----------------------------------------------------------------------------//

procedure TBinFilterParms.SignGroupedByCode(Code : string);
begin
  m_GroupedByCode := code
end;

//----------------------------------------------------------------------------//

function TBinFilterParms.CheckGroupedByFields(Id : TschedId) : boolean;
var
  GroupedByFieldSet : PTGroupedByFieldSet;
  Str : string;
  FieldVal : variant;
  dataType: CBinColValType;
  Properties : TProperties;
  JobVal : variant;
  ListIndex, I : integer;
  SonId : TSchedId;
begin
  result := false;
  GroupedByFieldSet := GetGroupBySetByCode(m_GroupedByCode);
  if assigned(GroupedByFieldSet) then
  begin
    Str := '';
    if FiltProdReq in GroupedByFieldSet.GroupedByOption then
    begin

      if p_sc.IsGroup(id) then    // can not be , only sons group will come
      begin
        for I := 0 to p_sc.GetGrpNumSons(id)-1 do
        begin
          SonId := p_sc.GetGrpSon(id, i);
          p_sc.GetFldValue(SonId, CSC_ProdReq, FieldVal, dataType);
          Str := FieldVal;
          if AddToListGroupedByField(str, SonId) then
             result := true;
        end;
        exit;
      end
      else
      begin
        p_sc.GetFldValue(id, CSC_ProdReq, FieldVal, dataType);
          Str := FieldVal;
      end
    end;

    if FiltProdFamily in GroupedByFieldSet.GroupedByOption then
    begin
      p_sc.GetFldValue(id, CSC_ProdFamily, FieldVal, dataType);
        Str := Str + FieldVal;
    end;
    Properties := p_sc.GetProperties(Id,nil);
    if GroupedByFieldSet.PropCode[0] <> '' then
    begin
      Properties.GetValforCode(GroupedByFieldSet.PropCode[0], '', -1, JobVal);
      Str := Str + VarToStr(JobVal);
    end;
    if GroupedByFieldSet.PropCode[1] <> '' then
    begin
      Properties.GetValforCode(GroupedByFieldSet.PropCode[1], '', -1, JobVal);
      Str := Str + VarToStr(JobVal);
    end;
    if GroupedByFieldSet.PropCode[2] <> '' then
    begin
      Properties.GetValforCode(GroupedByFieldSet.PropCode[2], '', -1, JobVal);
      Str := Str + VarToStr(JobVal);
    end;
    if GroupedByFieldSet.PropCode[3] <> '' then
    begin
      Properties.GetValforCode(GroupedByFieldSet.PropCode[3], '', -1, JobVal);
      Str := Str + VarToStr(JobVal);
    end;
    if GroupedByFieldSet.PropCode[4] <> '' then
    begin
      Properties.GetValforCode(GroupedByFieldSet.PropCode[4], '', -1, JobVal);
      Str := Str + VarToStr(JobVal);
    end;
    if GroupedByFieldSet.PropCode[5] <> '' then
    begin
      Properties.GetValforCode(GroupedByFieldSet.PropCode[5], '', -1, JobVal);
      Str := Str + VarToStr(JobVal);
    end;
    if GroupedByFieldSet.PropCode[6] <> '' then
    begin
      Properties.GetValforCode(GroupedByFieldSet.PropCode[6], '', -1, JobVal);
      Str := Str + VarToStr(JobVal);
    end;
    if GroupedByFieldSet.PropCode[7] <> '' then
    begin
      Properties.GetValforCode(GroupedByFieldSet.PropCode[7], '', -1, JobVal);
      Str := Str + VarToStr(JobVal);
    end;
    if GroupedByFieldSet.PropCode[8] <> '' then
    begin
      Properties.GetValforCode(GroupedByFieldSet.PropCode[8], '', -1, JobVal);
      Str := Str + VarToStr(JobVal);
    end;
    if GroupedByFieldSet.PropCode[9] <> '' then
    begin
      Properties.GetValforCode(GroupedByFieldSet.PropCode[9], '', -1, JobVal);
      Str := Str + VarToStr(JobVal);
    end;

    Result := AddToListGroupedByField(str, Id)

  end;

end;

//----------------------------------------------------------------------------//

function TBinFilterParms.AddToListGroupedByField(Str : String; Id : TSchedId) : boolean;
var
  GroupedByFieldSet : PRecGroupedByFieldSet;
  I : integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
  FieldVal : variant;
  dataType: CBinColValType;
begin
  Result := true;
  NumberOfEntries := m_GroupedByFieldList.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);
      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PRecGroupedByFieldSet(m_GroupedByFieldList[I]).str = Str then
      begin
        p_sc.GetFldValue(id, CSC_MatArrivalDate, FieldVal, dataType);
        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).MatArrivalDate = 0) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).MatArrivalDate := FieldVal
        else if (FieldVal > 0) and (FieldVal > PRecGroupedByFieldSet(m_GroupedByFieldList[I]).MatArrivalDate) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).MatArrivalDate := FieldVal;

        p_sc.GetFldValue(id, CSC_ProdDlvDate, FieldVal, dataType);
        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProdDlvDate = 0) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProdDlvDate := FieldVal
        else if (FieldVal > 0) and (FieldVal > PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProdDlvDate) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProdDlvDate := FieldVal;

        p_sc.GetFldValue(id, CSC_LowStartTimeLimit, FieldVal, dataType);
        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).LowStartTimeLimit = 0) then
            PRecGroupedByFieldSet(m_GroupedByFieldList[I]).LowStartTimeLimit := FieldVal
        else if (FieldVal > 0) and (FieldVal < PRecGroupedByFieldSet(m_GroupedByFieldList[I]).LowStartTimeLimit) then
            PRecGroupedByFieldSet(m_GroupedByFieldList[I]).LowStartTimeLimit := FieldVal;

        p_sc.GetFldValue(id, CSC_PlanStartDate, FieldVal, dataType);
        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).PlanStartDate = 0) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).PlanStartDate := FieldVal
        else if (FieldVal > 0) and (FieldVal < PRecGroupedByFieldSet(m_GroupedByFieldList[I]).PlanStartDate) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).PlanStartDate := FieldVal;

        p_sc.GetFldValue(id, CSC_PlanEndDate, FieldVal, dataType);
        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).PlanEndDate = 0) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).PlanEndDate := FieldVal
        else if (FieldVal > 0) and (FieldVal > PRecGroupedByFieldSet(m_GroupedByFieldList[I]).PlanEndDate) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).PlanEndDate := FieldVal;

        p_sc.GetFldValue(id, CSC_LowStartDate, FieldVal, dataType);
        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).LowStartDate = 0) then
           PRecGroupedByFieldSet(m_GroupedByFieldList[I]).LowStartDate := FieldVal
        else if (FieldVal > 0) and (FieldVal < PRecGroupedByFieldSet(m_GroupedByFieldList[I]).LowStartDate) then
            PRecGroupedByFieldSet(m_GroupedByFieldList[I]).LowStartDate := FieldVal;

        p_sc.GetFldValue(id, CSC_HighEndLimit, FieldVal, dataType);
        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).HighEndLimit = 0) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).HighEndLimit := FieldVal
        else if (FieldVal > 0) and (FieldVal > PRecGroupedByFieldSet(m_GroupedByFieldList[I]).HighEndLimit) then
            PRecGroupedByFieldSet(m_GroupedByFieldList[I]).HighEndLimit := FieldVal;

        p_sc.GetFldValue(id, CSC_IniQty, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).IniQty := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).IniQty + FieldVal;

        p_sc.GetFldValue(id, CSC_FinQty, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).FinQty := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).FinQty + FieldVal;

        p_sc.GetFldValue(id, CSC_Weight, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).Weight := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).Weight + FieldVal;

        p_sc.GetFldValue(id, CSC_NumOfRscPlan, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).NumOfRscPlan := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).NumOfRscPlan + FieldVal;

        p_sc.GetFldValue(id, CSC_NoResComp, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).NoResComp := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).NoResComp + FieldVal;

        p_sc.GetFldValue(id, CSC_PlanSetup, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).PlanSetup := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).PlanSetup + FieldVal;

        p_sc.GetFldValue(id, CSC_ExeTime, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ExeTime := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ExeTime + FieldVal;

        p_sc.GetFldValue(id, CSC_SupTimeSched, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).SupTimeSched := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).SupTimeSched + FieldVal;

        p_sc.GetFldValue(id, CSC_ExeTimeSched, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ExeTimeSched := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ExeTimeSched + FieldVal;

        p_sc.GetFldValue(id, CSC_QtyToSched, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).QtyToSched := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).QtyToSched + FieldVal;

        p_sc.GetFldValue(id, CSC_SchedStart, FieldVal, dataType);
        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).SchedStart = 0) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).SchedStart := FieldVal
        else if (FieldVal > 0) and (FieldVal < PRecGroupedByFieldSet(m_GroupedByFieldList[I]).SchedStart) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).SchedStart := FieldVal;

        p_sc.GetFldValue(id, CSC_SchedEnd, FieldVal, dataType);

        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).SchedEnd = 0) then
           PRecGroupedByFieldSet(m_GroupedByFieldList[I]).SchedEnd := FieldVal
        else if (FieldVal > 0) and (FieldVal > PRecGroupedByFieldSet(m_GroupedByFieldList[I]).SchedEnd) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).SchedEnd := FieldVal;

        p_sc.GetFldValue(id, CSC_ActualTime, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ActualTime := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ActualTime + FieldVal;

        p_sc.GetFldValue(id, CSC_ProgStart, FieldVal, dataType);
        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProgStart = 0) then
           PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProgStart := FieldVal
        else if (FieldVal > 0) and (FieldVal < PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProgStart) then
          PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProgStart := FieldVal;

        p_sc.GetFldValue(id, CSC_ProgEnd, FieldVal, dataType);
        if (FieldVal > 0) and (PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProgEnd = 0) then
           PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProgEnd := FieldVal
        else if (FieldVal > 0) and (FieldVal > PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProgEnd) then
            PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProgEnd := FieldVal;

        p_sc.GetFldValue(id, CSC_ProgQty, FieldVal, dataType);
        PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProgQty := PRecGroupedByFieldSet(m_GroupedByFieldList[I]).ProgQty + FieldVal;

        Result := false;
        Exit;
      end;

      if PRecGroupedByFieldSet(m_GroupedByFieldList[I]).str < str then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if I < LowestHighestValue then LowestHighestValue := I;
      i := i - Multiplier;
    end;
  end;

  new(GroupedByFieldSet);

  p_sc.GetFldValue(id, CSC_MatArrivalDate, FieldVal, dataType);
  GroupedByFieldSet.MatArrivalDate := FieldVal;

  p_sc.GetFldValue(id, CSC_ProdDlvDate, FieldVal, dataType);
  GroupedByFieldSet.ProdDlvDate := FieldVal;

  p_sc.GetFldValue(id, CSC_LowStartTimeLimit, FieldVal, dataType);
  GroupedByFieldSet.LowStartTimeLimit := FieldVal;

  p_sc.GetFldValue(id, CSC_PlanStartDate, FieldVal, dataType);
  GroupedByFieldSet.PlanStartDate := FieldVal;

  p_sc.GetFldValue(id, CSC_PlanEndDate, FieldVal, dataType);
  GroupedByFieldSet.PlanEndDate := FieldVal;

  p_sc.GetFldValue(id, CSC_LowStartDate, FieldVal, dataType);
  GroupedByFieldSet.LowStartDate := FieldVal;

  p_sc.GetFldValue(id, CSC_HighEndLimit, FieldVal, dataType);
  GroupedByFieldSet.HighEndLimit := FieldVal;

  p_sc.GetFldValue(id, CSC_IniQty, FieldVal, dataType);
  GroupedByFieldSet.IniQty := FieldVal;

  p_sc.GetFldValue(id, CSC_FinQty, FieldVal, dataType);
  GroupedByFieldSet.FinQty := FieldVal;

  p_sc.GetFldValue(id, CSC_Weight, FieldVal, dataType);
  GroupedByFieldSet.Weight := FieldVal;

  p_sc.GetFldValue(id, CSC_NumOfRscPlan, FieldVal, dataType);
  GroupedByFieldSet.NumOfRscPlan := FieldVal;

  p_sc.GetFldValue(id, CSC_NoResComp, FieldVal, dataType);
  GroupedByFieldSet.NoResComp := FieldVal;

  p_sc.GetFldValue(id, CSC_PlanSetup, FieldVal, dataType);
  GroupedByFieldSet.PlanSetup := FieldVal;

  p_sc.GetFldValue(id, CSC_ExeTime, FieldVal, dataType);
  GroupedByFieldSet.ExeTime := FieldVal;

  p_sc.GetFldValue(id, CSC_SupTimeSched, FieldVal, dataType);
  GroupedByFieldSet.SupTimeSched := FieldVal;

  p_sc.GetFldValue(id, CSC_ExeTimeSched, FieldVal, dataType);
  GroupedByFieldSet.ExeTimeSched := FieldVal;

  p_sc.GetFldValue(id, CSC_QtyToSched, FieldVal, dataType);
  GroupedByFieldSet.QtyToSched := FieldVal;

  p_sc.GetFldValue(id, CSC_SchedStart, FieldVal, dataType);
  GroupedByFieldSet.SchedStart := FieldVal;

  p_sc.GetFldValue(id, CSC_SchedEnd, FieldVal, dataType);
  GroupedByFieldSet.SchedEnd := FieldVal;

  p_sc.GetFldValue(id, CSC_ActualTime, FieldVal, dataType);
  GroupedByFieldSet.ActualTime := FieldVal;

  p_sc.GetFldValue(id, CSC_ProgStart, FieldVal, dataType);
  GroupedByFieldSet.ProgStart := FieldVal;

  p_sc.GetFldValue(id, CSC_ProgEnd, FieldVal, dataType);
  GroupedByFieldSet.ProgEnd := FieldVal;

  p_sc.GetFldValue(id, CSC_ProgQty, FieldVal, dataType);
  GroupedByFieldSet.ProgQty := FieldVal;

//  p_sc.GetFldValue(id, CSC_ProgType, FieldVal, dataType);
//  GroupedByFieldSet.ProgType := FieldVal;

  GroupedByFieldSet.str := Str;
  GroupedByFieldSet.id  := id;

  m_GroupedByFieldList.insert(LowestHighestValue, GroupedByFieldSet);
end;

//----------------------------------------------------------------------------//


destructor TBinFilterParms.Destroy;
var
  PRec : PRecProp;
  I : Integer;
begin
  if Assigned(m_ListFiltProp) then
  begin
    for I := 0 to m_ListFiltProp.Count - 1 do
    begin
      PRec := PRecProp(m_ListFiltProp[I]);
      Dispose(PRec)
    end;
    m_ListFiltProp.free
  end;
  if Assigned(m_ListOrProp) then
    m_ListOrProp.free;
end;

//----------------------------------------------------------------------------//

procedure ClearGroupedByFieldList;
var
  I : Integer;
begin
  for I := m_GroupedByFieldList.Count - 1 downto 0 do
     dispose(PRecGroupedByFieldSet(m_GroupedByFieldList[I]));
  m_GroupedByFieldList.Clear;
end;

//----------------------------------------------------------------------------//

function SortByIdGroupedByField(Item1, Item2: Pointer): Integer;
var
  GroupedByFieldSet1, GroupedByFieldSet2 : PRecGroupedByFieldSet;
begin
  GroupedByFieldSet1 := PRecGroupedByFieldSet(Item1);
  GroupedByFieldSet2 := PRecGroupedByFieldSet(Item2);
  if GroupedByFieldSet1.id < GroupedByFieldSet2.id then
    Result := -1
  else if (GroupedByFieldSet1.id = GroupedByFieldSet2.id) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure SortListGroupedByFieldId;
begin
  m_GroupedByFieldList.Sort(SortByIdGroupedByField);
end;

//----------------------------------------------------------------------------//

function FindIdValueInGroupedByFieldList(Id : TSchedId; fld: CBinColId; var FoundGroupedById : boolean) : variant;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := '';
  FoundGroupedById := false;

  NumberOfEntries := m_GroupedByFieldList.Count;
  if NumberOfEntries = 0 then Exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries) and (PRecGroupedByFieldSet(m_GroupedByFieldList[i]).id = id) then
    begin
      case fld of
        CSC_LowStartTimeLimit :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).LowStartTimeLimit;
        end;
        CSC_ProdDlvDate       :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).ProdDlvDate;
        end;

        CSC_MatArrivalDate    :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).MatArrivalDate;
        end;

        CSC_PlanStartDate     :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).PlanStartDate;
        end;

        CSC_PlanEndDate       :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).PlanEndDate;
        end;

        CSC_LowStartDate      :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).LowStartDate;
        end;

        CSC_HighEndLimit      :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).HighEndLimit;
        end;

        CSC_IniQty            :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).IniQty;
        end;

        CSC_FinQty            :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).FinQty;
        end;

        CSC_Weight            :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).Weight;
        end;

        CSC_NumOfRscPlan      :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).NumOfRscPlan;
        end;

        CSC_NoResComp         :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).NoResComp;
        end;

        CSC_PlanSetup         :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).PlanSetup;
        end;

        CSC_ExeTime           :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).ExeTime;
        end;

        CSC_SupTimeSched      :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).SupTimeSched;
        end;

        CSC_ExeTimeSched      :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).ExeTimeSched;
        end;

        CSC_QtyToSched        :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).QtyToSched;
        end;

        CSC_SchedStart        :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).SchedStart;
        end;

        CSC_SchedEnd          :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).SchedEnd;
        end;

        CSC_ActualTime        :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).ActualTime;
        end;

        CSC_ProgStart         :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).ProgStart;
        end;

        CSC_ProgEnd           :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).ProgEnd;
        end;

        CSC_ProgQty           :
        begin
          result := PRecGroupedByFieldSet(m_GroupedByFieldList[i]).ProgQty;
        end;

      end;
      FoundGroupedById := true;
      break;
    end;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (PRecGroupedByFieldSet(m_GroupedByFieldList[i]).id < id) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  {for I := 0 to m_GroupedByFieldList.Count - 1 do
  begin
    if PRecGroupedByFieldSet(m_GroupedByFieldList[i]).id = id then
    begin
      FoundGroupedById := true;
      exit;
    end;
  end;}


end;

//----------------------------------------------------------------------------//

function GetGroupedByFieldListCount : integer;
begin
  Result := m_GroupedByFieldList.Count;
end;

//----------------------------------------------------------------------------//

initialization

  m_GroupedByFieldList := TList.Create;

finalization

  ClearGroupedByFieldList;
  m_GroupedByFieldList.Free

end.
