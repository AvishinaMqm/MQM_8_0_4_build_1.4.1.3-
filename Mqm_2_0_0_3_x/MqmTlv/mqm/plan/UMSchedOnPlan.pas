unit UMSchedOnPlan;

interface

uses
  Classes,
  SysUtils,
  UMCompat,
  UMSchedContFunc,
  UMCompatSrv,
  UMIssuedArt,
  UMBalance,
  UMProdArt,
  {$ifdef Big}
  Dialogs,
  {$endif}

  UMArticles,
  UMOverlap,
  StdCtrls;

type
  TSCFlags  = set of CScFlags;

  TLocRec = record
    IssArt: PTIssuedArt;
    LastAvail: boolean;
  end;
  PTLocRec = ^TLocRec;

  TAvailRec = record
    LocRec: PTLocRec;
    BalanceType: CBalanceType;
    Date: TDateTime;
    Avail: boolean;
    UpToDateQuantity : double;
    StdPurcOrProdTime : integer;
  end;
  PTAvailRec = ^TAvailRec;

  // information needed for Split Mqm According to Mcm Qty/work center
  TMQMSplitInfoFromMcm = record
    Qty : double;
    SchedwkCtrCode : string;
    ProcessCode    : string;
    SchduleType    : string;
    Id             : TSchedId;
  end;
  PTMQMSplitInfoFromMcm = ^TMQMSplitInfoFromMcm;

  TSCSchedOnPlan = class
    constructor Create;
    destructor  Destroy; override;
    function    GetStrId: string; virtual; abstract;
    function    GetBarStr(isJobBar: boolean; LineNumber : Integer): string; virtual; abstract;
    function    GetLineNum(isJobBar:boolean): Integer; virtual; abstract;
    procedure   SetFlags(remove: TSCFlags; add: TSCFlags);
  private

    procedure UpdateBalanceEntries(VisResPtr: pointer; CalcMat : boolean); virtual; abstract;
    procedure UpdateBalanceIssues(VisResPtr: pointer; CalcMat : boolean); virtual; abstract;
    function  GetLastScheudleChange : TDateTime; virtual; abstract;
    procedure SetLastScheudleChange(StDate: TDateTime); virtual; abstract;
    function  GetSavedScheduleDate : TDateTime; virtual; abstract;
    procedure SetSavedScheduleDate(StDate: TDateTime); virtual; abstract;
    function  GetSchedStartOfJobInContGroup : TDateTime; virtual; abstract;
    procedure SetSchedStartOfJobInContGroup(StDate: TDateTime); virtual; abstract;
    function  GetSchedEndOfJobInContGroup: TDateTime; virtual; abstract;
    procedure SetSchedEndOfJobInContGroup(EndDate: TDateTime); virtual; abstract;
    function  GetStartDate: TDateTime; virtual; abstract;
    procedure SetStartDate(StDate: TDateTime); virtual; abstract;
    function  GetEndDate: TDateTime; virtual; abstract;
    procedure SetEndDate(EndDate: TDateTime); virtual; abstract;
    function GetSetupEndDate: TDateTime; virtual; abstract;
    function GetOrigStartDate: TDateTime; virtual; abstract;
    function GetOrigEndDate: TDateTime; virtual; abstract;
    procedure SetProgToClose(EndDate: TDateTime); virtual; abstract;
    function GetExeMin: double; virtual; abstract;
    procedure SetExeMin(ExeMin: double); virtual; abstract;
    function GetExeMinIgnoreProgress : double; virtual; abstract;
    function GetActualTime : double; virtual; abstract;
    function GetSupMinBase: double; virtual; abstract;
    procedure SetSupMinBase(SupMinBase: double); virtual; abstract;
    function GetSupMinReal: double; virtual; abstract;
    procedure SetSupMinReal(SupMinReal: double); virtual; abstract;
    function GetSupMinOvlp: double; virtual; abstract;
    procedure SetSupMinOvlp(SupMinOvlp: double); virtual; abstract;
    function GetQuantSched: double; virtual; abstract;
    procedure SetQuantSched(QuantSched: double); virtual; abstract;
    procedure SetLoadQuantSched(QuantSched: double); virtual; abstract;
    function GetFinalQuant: double; virtual; abstract;
    function GetQtySchdWithoutChg: double; virtual; abstract;
    function GetStartDateWithMat: TDateTime;
    function GetDeliveryDate: TDateTime; virtual; abstract;
    function GetPlannedStrDate: TDateTime; virtual; abstract;
    function GetPlannedEndDate: TDateTime; virtual; abstract;
    function GetLowStartDate: TDateTime; virtual; abstract;
    function GetHighEndDate: TDateTime; virtual; abstract;
    function GetHighEndDateTemp: TDateTime; virtual; abstract;
    function GetApprovalDate: TDateTime; virtual; abstract;
    function GetMatArrDate: TDateTime; virtual; abstract;
    procedure SetQuantManualChg(ManualChange: double);  virtual; abstract;
    function GetQuantManualChg: double; virtual; abstract;
    function GetQtyChgSchedNet: double; virtual; abstract;
    procedure SetQtyChgSchedNet(ManualChange: double); virtual; abstract;
    procedure SetProgQtyToDate; virtual; abstract;
    function CheckProgressed : boolean; virtual; abstract;

    procedure SetNewSetup(NewSetup: double); virtual; abstract;
    function GetNewSetup: Double; virtual; abstract;
    procedure SetNewSetupChanged(NewSetup: boolean); virtual; abstract;
    function GetNewSetupChanged: boolean; virtual; abstract;

  public
    m_compRes:  TCompatVal;
    m_compBack: TCompatVal;
    m_compFore: TCompatVal;
    m_MoveOp:   Pointer;
   // m_DatesErrSet: SetOfErrors;
   // m_MatErrSet: SetOfErrors;

    m_status:    CScStatus;
    m_Id:        TSchedID;
    m_isDeleted: boolean;
    m_srvPtr:    pointer;
    m_flags:     TSCFlags;

    m_forcedGrpNo: Integer;
    m_GroupType:  String;

    m_AutoSeqMaxBefore : double;
    m_AutoSeqHandled : Boolean;
    m_AutoSeqPrevID : Integer;
    m_AutoSeqNextID : Integer;
    m_SharedComment:  string;
    m_AutoSeqTakePart : Boolean;
    m_Mqm_environment : boolean;
//    m_binBool: boolean;
//    m_binCheck: TCheckBox;
    function FormatId: string;
    function GetMinMatArrDate(ResPtr: pointer; ProdNature: SetArProdNature; var NoAvailList: TList;
                              PrmSupMinBase, PrmDur, PrmSetupNeedMat : double; ByProduct : boolean) : Tlist; virtual; abstract;
    function CheckEnoughMatAtDateMain(ApaPtr: pointer; ProdNature: SetArProdNature;
                                  StrDate: TDateTime; var ListMatNotAvail: TList; var ListOfLeadTime: TList): boolean ; virtual; abstract;
    procedure GetStepBalanceLimits(VisResPtr: pointer; out LowLimit, HighLimit: TDateTime; OvlpChk : TypeOvlpChk; Setup, Duration : double); virtual; abstract;
    procedure UpdateBalance(VisResPtr: pointer; CalcMat : boolean); virtual; abstract;
    procedure ClearBalance; virtual; abstract;
//    procedure CalcOvlpLimits(out LowLimit, HighLimit: TDateTime); virtual; abstract;

    property p_OrigSchedStart: TDateTime  read GetOrigStartDate;
    property p_LastScheudleChange: TDateTime  read GetLastScheudleChange write SetLastScheudleChange;
    property p_SavedScheudleDate: TDateTime  read GetSavedScheduleDate write SetSavedScheduleDate;
    property p_schedStart:     TDateTime  read GetStartDate          write SetStartDate;
    property p_schedEnd:       TDateTime  read GetEndDate            write SetEndDate;
    property p_SchedStartOfJobInContGroup  : TDateTime read GetSchedStartOfJobInContGroup write SetSchedStartOfJobInContGroup;
    property p_SchedEndOfJobInContGroup    : TDateTime read GetSchedEndOfJobInContGroup   write SetSchedEndOfJobInContGroup;
    property p_OrigschedEnd:   TDateTime  read GetOrigEndDate;
    property p_SetupEndDate:   TDateTime  read GetSetupEndDate;
    property p_exeMin:         double     read GetExeMin             write SetExeMin;
    property p_ExeMinIgnoreProgress : double  read GetExeMinIgnoreProgress;
    property p_GetActualTime:  double     read GetActualTime;
    property p_supMinBase:     double     read GetSupMinBase         write SetSupMinBase;
    property p_supMinReal:     double     read GetSupMinReal         write SetSupMinReal;
    property p_supMinOvlp:     double     read GetSupMinOvlp         write SetSupMinOvlp;
    property p_quantSched:     double     read GetQuantSched         write SetQuantSched;
    property p_LoadquantSched: double     write SetLoadQuantSched;
    property p_FinalQuant:     double     read GetFinalQuant;
    property p_qtySchdWithoutChg: double  read GetQtySchdWithoutChg; //Get qty without manual changes
    property p_quantManualChg: double     read GetQuantManualChg     write SetQuantManualChg;
    property p_qtyChgSchedNet: double     read GetQtyChgSchedNet;  //    write SetQtyChgSchedNet;
    property p_StartWithMat:   TDateTime  read GetStartDateWithMat;
    property p_DeliveryDate:   TDateTime  read GetDeliveryDate;
    property p_PlannedStrDate: TDateTime  read GetPlannedStrDate;
    property p_PlannedEndDate: TDateTime  read GetPlannedEndDate;
    property p_LowStartDate:   TDateTime  read GetLowStartDate;
    property p_HighEndDate:    TDateTime  read GetHighEndDate;
    property p_HighEndDateTemp: TDateTime read GetHighEndDateTemp;
    property p_ApprovalDate:   TDateTime  read GetApprovalDate;
    property p_MatArrDate:     TDateTime  read GetMatArrDate;
    property p_CloseProgress:     TDateTime  {read GetQtyChgSchedNet;}  write SetProgToClose;
    property p_NewSetup:  double     read GetNewSetup      write SetNewSetup;
    property p_NewSetupChanged:  boolean     read GetNewSetupChanged write SetNewSetupChanged;
  end;

  TSCProdGroup  = class;
  TSCProdReqDet = class;
  TSCProdReqHdr = class;
  TSCMaterialSched = class;

  TSCProdSched = class(TSCSchedOnPlan)
  private
    m_CurrentSchedDate : TDateTime;
    m_SavedScheduleDate : TDateTime;
    m_SchedStartOfJobInContGroup : TDateTime;
    m_SchedEndOfJobInContGroup :  TDateTime;
    m_schedStart:     TDateTime;
    m_schedEnd:       TDateTime;
    m_exeMin:         double;
    m_supMinBase:     double;
    m_supMinReal:     double;
    m_supMinOvlp:     double;
    m_quantSched:     double;
    m_manualChange:   double;
    m_QtyChgSchedNet: double;
    m_rscCode:        string;
    m_OldrscCode:     string;
    m_schedType:      string;
    m_wkcCodeTimingFile : string;
    m_wkcProcTimingFile : string;
    m_resCodeTimingFile : string;
    m_resCatTimingFile  : string;
    m_CurveCode         : string;
    m_CurveCodeOccToOcc : string;
    m_Grp_Sequence      : string;
    m_IgnorExeTimeWhenGrp : boolean;
    // versioring
    m_VersionIdentifier   : string;
    m_FirstScheduleResource : string;
    m_FirstScheduleStart    : TDateTime;
    m_FirstScheduleEnd      : TDateTime;
    m_VersionScheduleResource : string;
    m_VersionScheduleStart    : TDatetime;
    m_VersionScheduleEnd      : TDateTime;

    // original values
    m_VersionIdentifier_ORIGINAL   : string;
    m_VersionScheduleResource_ORIGINAL : string;
    m_VersionScheduleStart_ORIGINAL    : TDatetime;
    m_VersionScheduleEnd_ORIGINAL      : TDateTime;

    m_LastScheudleChange_ORIGINAL  : TDateTime;
    m_rscCode_ORIGINAL             : string;
    m_AlternativeCode_ORIGINAL     : string;
    m_WorkCenterCode_ORIGINAL      : string;
    m_ProcessCode_ORIGINAL         : string;
    m_GroupCode_ORIGINAL           : integer;
    m_SchedType_ORIGINAL           : string;
    m_NumSubRscComponents_ORIGINAL : integer;
    m_SubLinRscId_ORIGINAL         : integer;
    m_MachSetupCode_ORIGINAL       : string;
    m_schedStart_ORIGINAL     : TDateTime;
    m_schedEnd_ORIGINAL       : TDateTime;
    m_exeMin_ORIGINAL         : double;
    m_supMinBase_ORIGINAL     : double;
    m_supMinReal_ORIGINAL     : double;
    m_supMinOvlp_ORIGINAL     : double;
    m_quantSched_ORIGINAL     : double;
    m_manualChange_ORIGINAL   : double;
    m_Comment_ORIGINAL        : string;
    m_CurveCode_ORIGINAL      : string;
    m_ActualStartDate_ORIGINAL : TDateTime;
    m_ActualEndDate_ORIGINAL : TDateTime;

    m_NewSetup:         double;
    m_NewSetupChanged  :boolean;

    function GetWorkCenter : string;
    procedure SetWorkCenter(Wc : string);
    function GetWrkCtrPtr : pointer;
    procedure SetWrkCtrPtr(WC: pointer);
    function GetProcess : string;
    procedure SetProcess(Process : String);
    function GetOrigStartDate: TDateTime; override;
    function GetLastScheudleChange : TDateTime; override;
    procedure SetLastScheudleChange(StDate: TDateTime); override;
    procedure SetSavedScheduleDate(StDate: TDateTime); override;
    function GetSavedScheduleDate : TDateTime; override;
    function  GetSchedStartOfJobInContGroup: TDateTime; override;
    procedure SetSchedStartOfJobInContGroup(StDate: TDateTime); override;
    function  GetSchedEndOfJobInContGroup: TDateTime; override;
    procedure SetSchedEndOfJobInContGroup(EndDate: TDateTime); override;
    function GetStartDate: TDateTime; override;
    procedure SetStartDate(StDate: TDateTime); override;
    function GetEndDate: TDateTime; override;
    procedure SetEndDate(EndDate: TDateTime); override;
    function GetOrigEndDate: TDateTime; override;
    function GetSetupEndDate: TDateTime; override;
    procedure SetProgToClose(EndDate: TDateTime); override;
    function GetExeMin: double; override;
    function GetExeMinIgnoreProgress: double; override;
    function GetActualTime : double; override;
    procedure SetExeMin(ExeMin: double); override;
    function GetSupMinBase: double; override;
    procedure SetSupMinBase(SupMinBase: double); override;
    function GetSupMinReal: double; override;
    procedure SetSupMinReal(SupMinReal: double); override;
    function GetSupMinOvlp: double; override;
    procedure SetSupMinOvlp(SupMinOvlp: double); override;
    function GetQuantSched: double; override;
    procedure SetQuantSched(QuantSched: double); override;
    procedure SetLoadQuantSched(QuantSched: double); override;
    function GetFinalQuant: double; override;
    function GetQtySchdWithoutChg: double; override;
    function GetDeliveryDate: TDateTime; override;
    function GetPlannedStrDate: TDateTime; override;
    function GetPlannedEndDate: TDateTime; override;
    function GetLowStartDate: TDateTime; override;
    function GetHighEndDate: TDateTime; override;
    function GetHighEndDateTemp: TDateTime; override;
    function GetApprovalDate: TDateTime; override;
    function GetMatArrDate: TDateTime; override;
    procedure SetQuantManualChg(ManualChange: double);  override;
    function GetQuantManualChg: double; override;
    function GetQtyChgSchedNet: double; override;
    procedure SetQtyChgSchedNet(ManualChange: double);  override;
    procedure SetProgQtyToDate; override;
    procedure UpdateBalanceEntries(VisResPtr: pointer; CalcMat : boolean); override;
    procedure UpdateBalanceIssues(VisResPtr: pointer; CalcMat : boolean); override;
    function  CheckProgressed : boolean; override;

    function GetNewSetup: double; override;
    procedure SetNewSetup(NewSetup : Double); override;
    function GetNewSetupChanged: boolean; override;
    procedure SetNewSetupChanged(NewSetup : boolean); override;

    procedure ProduceBalanceCalc(VisResPtr: Pointer; StartQty, EndQty: double;
                                 EndDTime: TDateTime; Sequence: string; NetGroup: TMQMNetGroup;
                                 JobPercentInAGroup, QuantityAlreadyInStock : Double);

    procedure CalculateEntriesNextStep(VisResPtr: Pointer; dtStartDTime : TDateTime;
                              dWriteBalance : Boolean; setUp, Execution : Double);
    procedure CalculateEntriesNextStepWriting(BWQuantity : double; BWDate: TDateTime; BWWaitAtLeast : TDateTime; BWWaitAtMost : TDateTime; BWWriteBalance : Boolean);

    procedure QuantityTimeProduced(VisResPtr: pointer; StartQty, CurrQty, EndQty: double;
                                 CurrDTime, EndDTime: TDateTime;
                                 var ProducedQty: double; var ProducedDTime: TDateTime;
                                 JobPercentInAGroup : Double);
    procedure BalanceEntriesWriting(VisResPtr: pointer; ProdQty, PrevProdQty: double;
                                         BalanceDTime: TDateTime; Sequence: string; NetGroup: TMQMNetGroup);
    procedure BalanceEntriesWriteForStep(VisResPtr: pointer; QtyBalance: double; BalanceDTime: TDateTime);
    procedure BalanceEntriesWriteForMat(VisResPtr: pointer; NetGroup: TMQMNetGroup; QtyBalance: double;
                                         BalanceDTime: TDateTime);

    procedure CalculateIssues(Res: Pointer; NetGroup: TMQMNetGroup;
                              bWaitAllQty: boolean; iUpdateHours: integer;
                              dtStartDTime, dtEndDTime: TDateTime;
                              ExecusionMinutes, dMinQty, dStartQty, dQuantity, dQuantityIssued, dSchedQty,
                              dRadioToPrevStep, dLeadTime: Double; ProductBalanceList : Tlist);


    procedure CalculateIssuesPrevStep(VisResPtr: Pointer; dtStartDTime : TDateTime;
                              dWriteBalance, dConsiderLeadTime : Boolean; setUp, Execution : Double; var FirstBalanceQuantity : double);
    procedure CalculateIssuesPrevStepWriting(BWQuantity : double; BWDate: TDateTime; BWWriteBalance : Boolean);

    function BalanceIssueWriting(ActArea: Pointer; NetGroup: TMQMNetGroup;
                                 dtDateTimeBalance: TDateTime; UpdateHours,
                                 dIssueBalance, dPrevBalance,dRemainQtyIssued,
                                 dRadioToPrevStep: Double; BalanceType: CBalanceType; ProductBalanceList: Tlist;
                                 EndDate : TDateTime): Double;
    procedure BalIssueWritingForMat(NetGroup: TMQMNetGroup; BalanceType: CBalanceType;
                                           dtStBalance, dtEndBalance, dQty: double);
    procedure BalIssueWritingForStep(BalanceType: CBalanceType;
                                     dtBalance, dQty: double);
    procedure GetMinMatArrDateForPrdList(ResPtr: pointer; IssArtList : TMQMIssuedArtList; ProdNature: SetArProdNature;
                                         var NoAvailList: TList;
                                         PrmSupMinBase, PrmDur, PrmSetupNeedMat : double);
    procedure InitializeListForBallance(ArtList: TMQMIssuedArtList; ProdNature: SetArProdNature;
                                         var ListToFill: TList; CalcBalanceTotal : boolean);
    function GetAddResStDate(DateType: ArResTime; ReferenceDate : TDateTime): TDateTime;
    function GetAddResEndDate(DateType: ArResTime; ReferenceDate : TDateTime): TDateTime;
    function GetLastScheudleChange_ORIGINAL : TDateTime;
    procedure SetLastScheudleChange_ORIGINAL(LastSchedDate : TDateTime);
    function  GetExeMinForSave : double;
    function  GetRscCode_ORIGINAL : string ;
    procedure SetRscCode_ORIGINAL(RscCode: string);
    function  GetAlternativeCode_ORIGINAL: string;
    procedure SetAlternativeCode_ORIGINAL(AltCode: string);
    function  GetWorkCenterCode_ORIGINAL: string;
    procedure SetWorkCenterCode_ORIGINAL(WcCode: string);
    function  GetProcessCode_ORIGINAL: string ;
    procedure SetProcessCode_ORIGINAL(ProcessCode: string);
    function  GetGroupCode_ORIGINAL: integer;
    procedure SetGroupCode_ORIGINAL(GroupCode: integer);
    function  GetSchedType_ORIGINAL: string;
    procedure SetSchedType_ORIGINAL(SchedTypeCode: string);
    function  GetNumSubRscComponents_ORIGINAL: integer;
    procedure SetNumSubRscComponents_ORIGINAL(NumOfComp: integer);
    function  GetSubLinRscId_ORIGINAL: integer;
    procedure SetsubLinRscId_ORIGINAL(SubLinRsc: integer);
    function  GetMachSetupCode_ORIGINAL: string;
    procedure SetMachSetupCode_ORIGINAL(MachSetupCode: string);
    function  GetStartDate_ORIGINAL : TDateTime;
    procedure SetStartDate_ORIGINAL(StDate: TDateTime);
    function  GetEndDate_ORIGINAL: TDateTime;
    procedure SetEndDate_ORIGINAL(EndDate: TDateTime);
    function  GetExeMin_ORIGINAL: double;
    procedure SetExeMin_ORIGINAL(ExeMin: double);
    function  GetSupMinBase_ORIGINAL: double;
    procedure SetSupMinBase_ORIGINAL(SupMinBase: double);
    function  GetSupMinReal_ORIGINAL: double;
    procedure SetSupMinReal_ORIGINAL(SupMinReal: double);
    function  GetSupMinOvlp_ORIGINAL: double;
    procedure SetSupMinOvlp_ORIGINAL(SupMinOvlp: double);
    function  GetQuantSched_ORIGINAL: double;
    procedure SetQuantSched_ORIGINAL(QuantSched: double);
    function  GetQuantManualChg_ORIGINAL: double;
    procedure SetQuantManualChg_ORIGINAL(ManualChange: double);
    function  GetComment_ORIGINAL : string;
    procedure setComment_ORIGINAL(Comment : string);
    function  GetLearningCurve_ORIGINAL : string;
    procedure setLearningCurve_ORIGINAL(CurveCode : string);
    function  GetActualStartDate_ORIGINAL : TDateTime;
    procedure SetActualStartDate_ORIGINAL(StDate: TDateTime);
    function  GetActualEndDate_ORIGINAL : TDateTime;
    procedure SetActualEndDate_ORIGINAL(EndDate: TDateTime);
	function CheckEnoughMatAtDate(ApaPtr: pointer; ProdNature: SetArProdNature;
             StrDate: TDateTime; var ListMatNotAvail: TList; var ListOfLeadTime: TList;
             var MaterialsAlreadyChecked : Tlist; CheckForTheGroup : boolean): boolean;

   { function  GetFirstSchedRes : string;
    procedure setFirstSchedRes(Res : string);
    function  GetFirstSchedStart : TDateTime;
    procedure setFirstSchedStart(dStart : TDateTime);
    function  GetFirstSchedEnd : TDateTime;
    procedure setFirstSchedEnd(dEnd : TDateTime);   }

  public
    m_fromPD:         boolean;
    m_MsgFromHost:    CScMsgFromHost;
    m_code:           integer;
    m_NewReqUniqId:     string;
    m_uniqueIdSavedInDB: boolean;
    m_reprocNo:       integer;
    m_SplitFamilyCode: string;
    m_Id_CalcTiming  : TSchedId;
    m_CalculatedTimes : boolean;
 //   m_exeMinBeforeCurveForProgress : double;
    m_GroupAutomaticInternalSortingSequence : integer;
	  m_updateLearningCurve : boolean;
	  m_UserReqSplitOnHost : boolean;
    m_SavedMachineCode_AUTOSEQ : string;
    m_SavedScheduledDateTime_AUTOSEQ : TDateTime;
    m_schedTypeBackup : string;

    // generic plan values
    m_GenericPlanWC     : string;
    m_GenericPlanDur    : double;
    m_GenericPlanLeadTime : double;
    m_GenericPlanMachineNum : Integer;
    m_GenericPlanStartDate  : TDateTime;
    m_GenericPlanEndDate    : TDateTime;

    m_ChangedWkCtr:  pointer;  // Assign only when Work center was changed

    m_PlanWkCtrCode:  string;  // Plan Work Center , has values only when W.Center was changed
    m_PlanWrkCtrProc: string;  // Plan Work Center Procces, has values only when W.Center was changed

    m_subLinRscId:    integer;
    m_numOfRscComp:   integer;
    m_comment:        string;
   // m_SharedComment:  string;
    m_fwdConnSubStp:  integer;
    m_fwdConnReProcs: integer;
    m_bkwConnSubStp:  integer;
    m_bkwConnReProcs: integer;
    m_PrgSt:          TDateTime;
    m_PrgCurDt:       TDateTime;
    m_PrgEd:          TDateTime;
    m_PrgQty:         double;
    m_PrgStartingQty: double;
    m_PrgRemTime:     double;
    m_ProgType:       string;
    m_ProgRsc:        string;
    m_TimeDescr:      string;
    m_HaltedTime:     double;
    m_ProgTypeHost:   string;
    m_ProgRscHost:    string;
    m_PrgStHost:      TDateTime;
    m_PrgCurDtHost:   TDateTime;
    m_PrgEdHost:      TDateTime;
    m_PrgQtyHost:     double;
    m_PrgRemTimeHost: double;
    m_PrgStartingQtyOrig : double;
    m_ProgTypeOrig:   string;
    m_ProgRscOrig:    string;
    m_PrgStOrig:      TDateTime;
    m_PrgCurDtOrig:   TDateTime;
    m_PrgEdOrig:      TDateTime;
    m_PrgQtyOrig:     double;
    m_PrgRemTimeOrig: double;
    m_ProgressOverride : CProgressIgnor;
    m_ProgressIgnoredType : CProgressTypeIgnored;
    m_PrgStSaved:     TDateTime;
    m_PrgCurDtSaved:  TDateTime;
    m_PrgEdSaved:     TDateTime;
    m_ProgTypeSaved:  string;
    m_ProgSaved:      boolean;
    m_MachSetupCode:  string;
    m_AlternativeCode:string;
    m_VisbleInBin:    CScBinView;
    m_ChangeViewWC:   boolean;
    m_MinOvlpDate:    TDateTime;
    m_MaxOvlpDate:    TDateTime;
    m_DontCalcOvlp:   boolean;
    m_QtyProgToDate:  double;
    m_pcntOfInitQty:  double;
    m_JobMsgGet    :  boolean;
    m_JobMsgSent   :  boolean;
    m_ProdSched_ID_FromDatabase : TSchedId;

    // backup values for insert to db in case of communication fail
    m_Backup_Saved : boolean;
    m_fromPD_Saved : boolean;
    m_status_Saved : CScStatus;
    m_LastScheudleChange_ORIGINAL_Saved  : TDateTime;
    m_rscCode_ORIGINAL_Saved             : string;
    m_AlternativeCode_ORIGINAL_Saved     : string;
    m_WorkCenterCode_ORIGINAL_Saved      : string;
    m_ProcessCode_ORIGINAL_Saved         : string;
    m_GroupCode_ORIGINAL_Saved           : integer;
    m_SchedType_ORIGINAL_Saved           : string;
    m_NumSubRscComponents_ORIGINAL_Saved : integer;
    m_SubLinRscId_ORIGINAL_Saved         : integer;
    m_MachSetupCode_ORIGINAL_Saved       : string;
    m_schedStart_ORIGINAL_Saved     : TDateTime;
    m_schedEnd_ORIGINAL_Saved       : TDateTime;
    m_exeMin_ORIGINAL_Saved         : double;
    m_supMinBase_ORIGINAL_Saved     : double;
    m_supMinReal_ORIGINAL_Saved     : double;
    m_supMinOvlp_ORIGINAL_Saved     : double;
    m_quantSched_ORIGINAL_Saved     : double;
    m_quantManualChange_ORIGINAL_Saved   : double;
    m_Comment_ORIGINAL_Saved        : string;
    m_LearningCurve_ORIGINAL_Saved      : string;
    m_ActualStartDate_ORIGINAL_Saved : TDateTime;
    m_ActualEndDate_ORIGINAL_Saved : TDateTime;

    m_mtr:         TSCMaterialSched;
    m_grp:         TSCProdGroup;
    m_grpRemovedReason: string;  // reason why job was removed from its group; cleared when job joins a group
    m_deleteReason: string;      // reason why job was marked as deleted
    m_reqDet:      TSCProdReqDet;

    constructor Create;
    destructor  Destroy; override;

    function GetProgEndOrig: TDateTime;
    function GetProgEnd: TDateTime;
    function GetRscCode: string;
    procedure SetRscCode(RscCode: string);
    function GetOldRscCode : string;
    procedure SetOldRscCode(OldRscCode: string);
    function GetStrId: string; override;
    function GetBarStr(isJobBar: boolean; LineNumber : Integer): string; override;
    function GetLineNum(isJobBar:boolean): Integer; Override;

    function GetPrevStepToSched(Step : integer) : TSCProdReqDet;
    function GetNextStepToSched(Step : integer) : TSCProdReqDet;
    function GetMinMatArrDate(ResPtr: pointer; ProdNature: SetArProdNature; var NoAvailList: TList;
                              PrmSupMinBase, PrmDur, PrmSetupNeedMat : double; ByProduct : boolean) : Tlist; override;
    function CheckEnoughMatAtDateMain(ApaPtr: pointer; ProdNature: SetArProdNature;
                                  StrDate: TDateTime; var ListMatNotAvail: TList; var ListOfLeadTime: TList): boolean; override;
    procedure ClearBalance; override;
    procedure GetStepBalanceLimits(VisResPtr: Pointer; out LowLimit, HighLimit: TDateTime; OvlpChk : TypeOvlpChk; Setup, Duration : double); override;
//    procedure CalcOvlpLimits(out LowLimit, HighLimit: TDateTime); override;
    procedure CheckPrevConnReqLowestStart(var LowLimit : TDateTime; var LowLimit_WithoutLeadTime : TDateTime; IncludOvrlRules : boolean; OvlRules: TMQMOvlpRule; ResBatchType : boolean);
    procedure CheckPrevConnReqLastStepJobs(var LowLimit : TDateTime; var LowLimit_WithoutLeadTime : TDateTime; IncludOvrlRules : boolean; OvlRules: TMQMOvlpRule; ResBatchType : boolean);
    procedure CheckConnReqHighestEnd(var HighLimit : TDatetime; var HighLimit_WithoutLeadTime : TDatetime; IncludOvrlRules : boolean; OvlRules: TMQMOvlpRule; ResBatchType : boolean);
    procedure CheckConnReqFirstStepJobs(var HighLimit : TDatetime; var HighLimit_WithoutLeadTime : TDatetime; IncludOvrlRules : boolean; OvlRules: TMQMOvlpRule; ResBatchType : boolean);
    procedure CanOverLap(var WaitEntirePrvQty : boolean; var CanDeliverPartial : boolean ; var LeadTimePrev : double ; var LeadTimeNext : double);
    function  GetOvlpLowLimit(VisResPtr: pointer; OvlpChk : TypeOvlpChk; RealSetup, Duration : double; out ExpireDateHighLimit : TDateTime): TDateTime;
    function  GetOvlpHighLimit(VisResPtr: pointer; OvlpChk : TypeOvlpChk; RealSetup, Duration : double;  out ExpireDateLowLimit : TDateTime): TDateTime;

    procedure CopyDataFromJobToJob(NewJob : TSCProdSched);
    procedure UpdateBalance(VisResPtr: pointer; CalcMat : boolean); override;
    function  CalcQtyFinnalProg : double;
    function  GetLearningCurveSaved : string;
    function  GetLearningCurve : string;
    procedure SetLearningCurve(CurveCode : string);
    function  GetLearningCurveByOccToOcc : string;
    procedure SetLearningCurveByOccToOcc(CurveCode : string);
    function  GetGrpSequence : string;
    procedure SetGrpSequence (GrpSequence : string);

    property p_rscCode:       string     read GetRscCode       write SetRscCode;
    property p_OldrscCode:    string     read GetOldRscCode    write SetOldRscCode;
    property p_WorkCenter:    string     read GetWorkCenter    write SetWorkCenter;
    property p_WrkCtrPtr:     pointer    read GetWrkCtrPtr     write SetWrkCtrPtr;
    property p_Process:       string     read GetProcess       write SetProcess;
    property p_GetStepType:   string     read m_schedType;
    property p_SetStepType:   string     write m_schedType;
    property P_wkcCodeTimingFile : string read m_wkcCodeTimingFile write m_wkcCodeTimingFile;
    property P_wkcProcTimingFile : string read m_wkcProcTimingFile write m_wkcProcTimingFile;
    property P_resCodeTimingFile : string read m_resCodeTimingFile write m_resCodeTimingFile;
    property P_resCatTimingFile  : string read m_resCatTimingFile  write m_resCatTimingFile;
    property p_CurveCodeSaved : string read GetLearningCurveSaved;
    property p_CurveCode : string read GetLearningCurve write SetLearningCurve;
    property p_CurveCodeByOccToOcc : string read GetLearningCurveByOccToOcc write SetLearningCurveByOccToOcc;
    property p_Grp_Sequence : string read GetGrpSequence write SetGrpSequence;
    property P_IgnorExeTimeWhenGrp : boolean read m_IgnorExeTimeWhenGrp;
    //versioning
    property P_FirstScheduleResource        : string    read m_FirstScheduleResource  write m_FirstScheduleResource;
    property P_FirstScheduleStart           : TdateTime read m_FirstScheduleStart     write m_FirstScheduleStart;
    property P_FirstScheduleEnd             : TdateTime read m_FirstScheduleEnd       write m_FirstScheduleEnd;
    property P_VersionIdentifier            : string    read m_VersionIdentifier      write m_VersionIdentifier;
    property P_VersionScheduleResource      : string    read m_VersionScheduleResource write m_VersionScheduleResource;
    property P_VersionScheduleStart         : TdateTime read m_VersionScheduleStart   write m_VersionScheduleStart;
    property P_VersionScheduleEnd           : TdateTime read m_VersionScheduleEnd     write m_VersionScheduleEnd;

    property P_VersionIdentifier_ORIGINAL   : string read m_VersionIdentifier_ORIGINAL           write m_VersionIdentifier_ORIGINAL;
    property P_VersionScheduleResource_ORIGINAL : string read m_VersionScheduleResource_ORIGINAL write m_VersionScheduleResource_ORIGINAL;
    property P_VersionScheduleStart_ORIGINAL : TdateTime read m_VersionScheduleStart_ORIGINAL    write m_VersionScheduleStart_ORIGINAL;
    property P_VersionScheduleEnd_ORIGINAL   : TdateTime read m_VersionScheduleEnd_ORIGINAL      write m_VersionScheduleEnd_ORIGINAL;

    property p_GetExeMinForSave: double read GetExeMinForSave;
    property p_LastScheudleChange_ORIGINAL  : TDateTime read GetLastScheudleChange_ORIGINAL  write SetLastScheudleChange_ORIGINAL;
    property p_RscCode_ORIGINAL             : string    read GetRscCode_ORIGINAL             write SetRscCode_ORIGINAL;
    property p_AlternativeCode_ORIGINAL     : string    read GetAlternativeCode_ORIGINAL     write SetAlternativeCode_ORIGINAL;
    property p_WorkCenterCode_ORIGINAL      : string    read GetWorkCenterCode_ORIGINAL      write SetWorkCenterCode_ORIGINAL;
    property p_ProcessCode_ORIGINAL         : string    read GetProcessCode_ORIGINAL         write SetProcessCode_ORIGINAL;
    property p_GroupCode_ORIGINAL           : integer   read GetGroupCode_ORIGINAL           write SetGroupCode_ORIGINAL;
    property p_SchedType_ORIGINAL           : string    read GetSchedType_ORIGINAL           write SetSchedType_ORIGINAL;
    property p_NumSubRscComponents_ORIGINAL : integer   read GetNumSubRscComponents_ORIGINAL write SetNumSubRscComponents_ORIGINAL;
    property p_SubLinRscId_ORIGINAL         : integer   read GetSubLinRscId_ORIGINAL         write SetsubLinRscId_ORIGINAL;
    property p_MachSetupCode_ORIGINAL       : string    read GetMachSetupCode_ORIGINAL       write SetMachSetupCode_ORIGINAL;
    property p_schedStart_ORIGINAL          : TDateTime read GetStartDate_ORIGINAL           write SetStartDate_ORIGINAL;
    property p_schedEnd_ORIGINAL            : TDateTime read GetEndDate_ORIGINAL             write SetEndDate_ORIGINAL;
    property p_exeMin_ORIGINAL              : double    read GetExeMin_ORIGINAL              write SetExeMin_ORIGINAL;
    property p_supMinBase_ORIGINAL          : double    read GetSupMinBase_ORIGINAL          write SetSupMinBase_ORIGINAL;
    property p_supMinReal_ORIGINAL          : double    read GetSupMinReal_ORIGINAL          write SetSupMinReal_ORIGINAL;
    property p_supMinOvlp_ORIGINAL          : double    read GetSupMinOvlp_ORIGINAL          write SetSupMinOvlp_ORIGINAL;
    property p_quantSched_ORIGINAL          : double    read GetQuantSched_ORIGINAL          write SetQuantSched_ORIGINAL;
    property p_quantManualChg_ORIGINAL      : double    read GetQuantManualChg_ORIGINAL      write SetQuantManualChg_ORIGINAL;
    property p_Comment_ORIGINAL             : string    read GetComment_ORIGINAL             write setComment_ORIGINAL;
    property p_LearningCurve_ORIGINAL       : string    read GetLearningCurve_ORIGINAL       write setLearningCurve_ORIGINAL;
    property p_ActualStartDate_ORIGINAL     : TDateTime read GetActualStartDate_ORIGINAL     write SetActualStartDate_ORIGINAL;
    property p_ActualEndDate_ORIGINAL       : TDateTime read GetActualEndDate_ORIGINAL       write SetActualEndDate_ORIGINAL;

 end;

  TSCProdGroup = class(TSCSchedOnPlan)
  private
    function GetOrigStartDate: TDateTime; override;
    function GetLastScheudleChange : TDateTime; override;
    procedure SetLastScheudleChange(StDate: TDateTime); override;
    procedure SetSavedScheduleDate(StDate: TDateTime); override;
    function GetSavedScheduleDate : TDateTime; override;
    function GetSchedStartOfJobInContGroup: TDateTime; override;
    function GetSchedEndOfJobInContGroup: TDateTime; override;
    function GetStartDate: TDateTime; override;
    procedure SetStartDate(StDate: TDateTime); override;
    function GetEndDate: TDateTime; override;
    procedure SetEndDate(EndDate: TDateTime); override;
    function GetOrigEndDate: TDateTime; override;
    function GetSetupEndDate: TDateTime; override;
    procedure SetProgToClose(EndDate: TDateTime); override;
    function GetExeMin: double; override;
    procedure SetExeMin(ExeMin: double); override;
    function GetSupMinBase: double; override;
    procedure SetSupMinBase(SupMinBase: double); override;
    function GetSupMinReal: double; override;
    procedure SetSupMinReal(SupMinReal: double); override;
    function GetSupMinOvlp: double; override;
    procedure SetSupMinOvlp(SupMinOvlp: double); override;
    function GetQuantSched: double; override;
    procedure SetQuantSched(QuantSched: double); override;
    function GetFinalQuant: double; override;
    function GetDeliveryDate: TDateTime; override;
    function GetPlannedStrDate: TDateTime; override;
    function GetPlannedEndDate: TDateTime; override;
    function GetLowStartDate: TDateTime; override;
    function GetHighEndDate: TDateTime; override;
    function GetHighEndDateTemp: TDateTime; override;
    function GetApprovalDate: TDateTime; override;
    function GetMatArrDate: TDateTime; override;
    procedure UpdateBalanceEntries(VisResPtr: pointer; CalcMat : boolean); override;
    procedure UpdateBalanceIssues(VisResPtr: pointer; CalcMat : boolean); override;
    function  GetExeMinIgnoreProgress : double; override;
    function  GetActualTime : double; override;
    procedure SetQuantManualChg(ManualChange: double);  override;
    procedure SetProgQtyToDate; override;
    function GetQuantManualChg: double; override;
    procedure SetLoadQuantSched(QuantSched: double); override;
    function GetQtySchdWithoutChg: double; override;
    function GetQtyChgSchedNet: double; override;
    procedure SetQtyChgSchedNet(ManualChange: double);  override;
    function  CheckProgressed : boolean; override;

  public
    m_code:        integer;
    m_list:        TList;
    m_ListOfSequence : TStringList;
    m_Job_Sequence   : Integer;
    m_propList       : TProperties;
    m_ResourceForPropList : string;
    m_RealoadProperties : boolean;
    m_NewSpeed: double;
    m_IsSpeedChanged: boolean;
    m_NewSetup: double;
    m_IsSetupChanged : boolean;

    m_NewJobSetup: double;
    m_IsJobSetupChanged : boolean;

    constructor Create;
    destructor  Destroy; override;

    function  GetStrId: string; override;
    function GetMinMatArrDate(ResPtr: pointer; ProdNature: SetArProdNature; var NoAvailList: TList;
             PrmSupMinBase, PrmDur, PrmSetupNeedMat : double; ByProduct : boolean) : Tlist; override;
    function CheckEnoughMatAtDateMain(ApaPtr: pointer; ProdNature: SetArProdNature;
                                  StrDate: TDateTime; var ListMatNotAvail: TList; var ListOfLeadTime: TList): boolean; override;
    procedure GetStepBalanceLimits(VisResPtr: Pointer; out LowLimit, HighLimit: TDateTime; OvlpChk : TypeOvlpChk; Setup, Duration : double); override;
    function GetBarStr(isJobBar: boolean; LineNumber : Integer) : string; override;
    function GetLineNum(isJobBar:boolean): Integer; override;
    procedure UpdateBalance(VisResPtr: pointer; CalcMat : boolean); override;
    procedure ClearBalance; override;
    procedure SortGroup;
    function  GetMinIdInGroup : TSchediD;
    procedure SetSchedResourceAsProgress(Resource : string);
    function  GetNewSpeed : double;
    procedure SetNewSpeed(speed : double);
    function  GetNewSetup : double;
    procedure SetNewSetup(setup : double);
    property  p_IsSpeedChanged:boolean read m_IsSpeedChanged write m_IsSpeedChanged;
    property  p_NewSpeed:double read GetNewSpeed write SetNewSpeed;
    property  p_IsSetupChanged:boolean read m_IsSetupChanged write m_IsSetupChanged;
    property  p_NewSetup:double read GetNewSetup write SetNewSetup;
    function  GetNewJobSetup : double;
    procedure SetNewJobSetup(Setup : double);
    property  p_NewJobSetup:double read GetNewJobSetup write SetNewJobSetup;
    property  p_IsJobSetupChanged : boolean read m_IsJobSetupChanged write m_IsJobSetupChanged;
  end;

  TSCMaterialSched = class
    m_Id              : TSchedId;
    m_FOUND_In_LOCALE : boolean;
    m_Is_Deleted      : boolean;
    m_ITEM_TYPE    : string;
    m_PRODUCT_CODE : string;
    m_NET_GROUP_CODE : string;
    m_Material_Code_DET  : string;
    m_MATERIAL_CODE_SUB_DET : string;
    m_MATERIAL_Overriden_Speed : double;
    m_MATERIAL_Overriden_Setup_Time : double;
    m_RequestNo   : string;
    m_propList:    TProperties;
    m_schedType:      string;
    m_warp_levl:      ArMaterialScheduleLvl;
    m_SpeedInminutePerUoM : double;
    m_Standard_Setup : double;
    m_ResCode: string;
    m_start : TDateTime;
    m_end : TDateTime;

    m_ResCode_Old: string;
    m_start_Old : TDateTime;
    m_end_Old : TDateTime;

    m_UM  : string;
    m_qty : double;
    m_Job :  TSCProdSched;
    m_WarpObj : pointer;
    m_MqmActArea : pointer;

    m_LinkedToRequest : boolean;
    m_LinkedRequestList : TStringList;
    m_LinkedStepList  : TStringList;
    procedure SetLinkedRequestToWarp(request : string; step : integer);
    function  CheckLinkRequest(Request : string; Step : Integer) : boolean;
    procedure FillLinkRequestStep(LinkReqStep : TStrings);
    constructor Create;
    destructor  Destroy; override;
  end;

  TSCProdReqDet = class
  private
    m_toBeSched:  CScToBeSched;
    m_CurveType:  CSCurveType;
    m_Grp_Sequence : string;
    m_IgnoreProgress : boolean;
    function GetRealCount : integer;
  public
    m_code:                    integer;
    m_StepToSched:             boolean;
    m_prevStep:                integer;
    m_nextStep:                integer;
    m_prevRealStep:            integer;
    m_nextRealStep:            integer;
    m_stepType:                CScSchedType;
    m_batch_ContinuesTime:     boolean;
    m_Continues_Parallel:      boolean;
    m_materialArrivDate:       TDateTime;
    m_lowStartTimeLimit_Orig:  TDateTime;
    m_planStart_Orig:          TDateTime;
    m_planEnd_Orig:            TDateTime;
    m_highEndTimeLimit_Orig:   TDateTime;
    m_lowStartTimeLimit:       TDateTime;
    m_planStart:               TDateTime;
    m_planEnd:                 TDateTime;
    m_highEndTimeLimit:        TDateTime;
    m_highEndTimeLimitTemp:    TDateTime;
    m_highEndTimeLimitOverriden: boolean;
    m_customerDate:            CSCustomerDateType;
    m_Approvaldate:            TDateTime;
    m_Approvaldate_UserChanged : boolean;
    m_planWkctr:               string;
    m_planWkctrProc:           string;
    m_PlanWrkCtrPtr:           pointer;
    m_quantInit:               double;
    m_quantFinl:               double;
    m_quantAlternative:        double;
    m_UM_Alternative:          string;
    m_weight:                  double;
    m_weightUM:                string;
    m_calCod:                  string;
    m_totPlanSetup:            double;
    m_totPlanExeTime:          double;
    m_planNumRes:              double;
    m_minAfterStep:            integer;
    m_maxMinBeforeNext:        integer;
    m_stepCanBeOverlapped:     boolean;
    m_minQuantPastNextStep:    double;
    m_stepCanOverlap:          boolean;
    m_minQuantPastNextToStart: boolean;
    m_connTypeToPrevious:      string;
    m_stepClosed:              boolean;
    m_propList:                TProperties;
    m_SetupTimeStep:           double;
    m_ExeTimeStep:             double;
    m_CanGroup:                string;
    m_forcedGrpNo:             Integer;
    m_FrcMatDate:              CScFrcDate;
    m_FrcLowestDate:           CScFrcDate;
    m_FrcHighestDate:          CScFrcDate;
    m_FrcOverlapp:             CScFrcDate;
    m_SplitAllow:              CScSplitAllow;
    m_SkipAutoSeqMatTest:      boolean;
    m_GenericPlan:             string;
    m_ResComp:                 Integer;
    m_MaxStartingDateAutoSeq:  TDateTime;

    m_hdr:                     TSCProdReqHdr;
    m_list:                    TList;
    m_StepTimeList:            TList;
    m_SplitInfoList_FromMcmToMqm : TList;
    m_SplitFromMcmToMqmAndAlterWorkCenter : boolean;
    m_OfThisWrkst:             boolean;
//    m_VisbleInBin:             CScBinView;
//    m_SavedPP    :             boolean;
    //m_ProdReqDetList:          TStringlist;
    m_PriorStepList:           TStringlist;
    m_MacSetupList:            TMQMMacSetupList;
    m_BchUMList   :            TMQMBchUMList;
    m_LeadTimePrev:            double;
    m_LeadTimeNext:            double;
   	m_LeadTimePrevBatch:       double;
  	m_LeadTimeNextBatch:       double;
    m_BatchSizePerStep :       boolean;
    m_MinBatchSize     :       double;
    m_OptimumBatchSize :       double;
    m_MaxBatchSize     :       double;
    m_OverlapWithOtherSteps :  boolean;
    m_ResOccupation    :       CSResOccupation;
    m_NewSpeed: double;
    m_IsSpeedChanged: boolean;
    m_NewSetup: double;
    m_IsSetupChanged: boolean;

    // For Warp
    m_ProdTypeBaseLvl : string;
    m_ProdTypeSecondLvl : string;
    m_ProductBaseLvl : string;
    m_ProductSecondLvl : string;
    
    constructor Create;
    destructor  Destroy; override;
    function GetStrId: string;
    function FindJobFromCode(jobCode, ReprocNo: integer): TSCProdSched;
    procedure InvalidateToBeSched;
    function CheckPriorityToSched(ErrList: TStrings): boolean;
    function CheckPriorityToUnsched(ErrList: TStrings): boolean;
    function CheckDependencyToSched(ResPtr: Pointer; ErrList: TStrings): boolean;
    function CheckJobsForLeadStep(ErrList: TStrings; ConfirmationLvl : string): boolean;
    function CheckJobsNotOnPlan(ErrList: TStrings): boolean;
    function CheckJobsOnPlan(ErrList: TStrings): boolean;
    function CheckDependencyNotOnPlan(RecPtr, ResPtr: Pointer; ErrList: TStrings): boolean;
    function CheckDependencyOnRes(ResPtr: Pointer; ErrList: TStrings): boolean;
    function ToBeSched(ErrList: TStrings): CScToBeSched;
    function CheckIfUseMatOfReqConnected(ArtToBeCheck: TMQMArticle; ResPtr: Pointer; MacSetupCode: string) : boolean;
    function  GetLearningCurveType : CSCurveType;
    procedure SetLearningCurveType(CurveType : CSCurveType);
    procedure SetMaxStartingDateAutoSeq(MaxDate : TDateTime);
    function  GetNewSpeed : double;
    procedure SetNewSpeed (speed : double);
    function  GetNewSetup : double;
    procedure SetNewSetup (setup : double);
    function  GetGrpSequence : string;
    procedure SetGrpSequence (GrpSequence : string);
    function GetLeadTimePrev: double;
    procedure SetLeadTimePrev(LeadTimePrev: double);
    function GetLeadTimeNext: double;
    procedure SetLeadTimeNext(LeadTimeNext: double);
    function GetLeadTimePrevBatch: double;
    procedure SetLeadTimePrevBatch(LeadTimePrevBatch : double);
    function GetLeadTimeNextBatch: double;
    procedure SetLeadTimeNextBatch(LeadTimeNextBatch : double);
    property p_IsSpeedChanged:boolean read m_IsSpeedChanged write m_IsSpeedChanged;
    property p_NewSpeed :double read GetNewSpeed write SetNewSpeed;
    property p_IsSetupChanged:boolean read m_IsSetupChanged write m_IsSetupChanged;
    property p_NewSetup :double read GetNewSetup write SetNewSetup;
    property p_Count : integer read GetRealCount;
    property p_Grp_Sequence : string read GetGrpSequence write SetGrpSequence;
    property p_CurveType : CSCurveType read GetLearningCurveType write SetLearningCurveType;
    property p_LeadTimePrev:  double      read GetLeadTimePrev  write SetLeadTimePrev;
    property p_LeadTimeNext:  double      read GetLeadTimeNext  write SetLeadTimeNext;
    property p_LeadTimePrevBatch:  double read GetLeadTimePrevBatch  write SetLeadTimePrevBatch;
    property p_LeadTimeNextBatch:  double read GetLeadTimeNextBatch  write SetLeadTimeNextBatch;
    property p_OverlapWithOtherSteps : boolean read m_OverlapWithOtherSteps write m_OverlapWithOtherSteps;
    property p_ResOccupation         : CSResOccupation read m_ResOccupation write m_ResOccupation;
    property p_RscComp               : integer read m_ResComp write m_ResComp;
    property p_MaxStartingDateAutoSeq : TDateTime read m_MaxStartingDateAutoSeq write SetMaxStartingDateAutoSeq;
    property P_quantAlternative : double read m_quantAlternative write m_quantAlternative;
    property P_UmAlternative    : string read m_Um_Alternative write m_Um_Alternative;
    property P_IgnoreProgress : boolean  read m_IgnoreProgress write m_IgnoreProgress;

  end;

  TSCProdReqHdr = class
    m_code:              string;
    m_historicReq:       boolean;
    m_prodLine:          string;
    m_prodType:          string;
    m_prodTypeDesc:      string;
    m_prodFamily:        string;
  //  m_producedArticleCode: string;
    m_ProductDescription : string;
    m_matFamily:         string;
    m_prodUMCode:        string;
    m_NumOfDecimals:     integer;
    m_ConfLevels:        string;
    m_LeadStepForSplit:  integer;
    m_CurveFamilyIdCode: string;
    m_NewReqUniqId    :  string;
    m_ServingCode     :  string;
    m_ServingCodeHdrList : TList;
    m_prodLowDateTime:   TDateTime;
    m_prodDelivDate:     TDateTime;
    m_FrcDelDate:        CScFrcDate;
    m_list:              TList;
    m_PrecLinkedReqList: TList;
    m_NextLinkedReqList: TList;
    m_ProdArtList:       TMQMProdArtList;
    m_RequestBalList:    TMQMRequestBalList;

    constructor Create;
    destructor  Destroy; override;

    function GetStrId: string;
    function FindDetFromCode(detCode: integer): TSCProdReqDet;
    procedure InvalidateDetToBeSched;
//    function GetPrecStepToSched(StepId: integer): TSCProdReqDet;
//    function GetPrecStepToUNSched(StepId: integer): TSCProdReqDet;
    procedure AddLinkedRequest(Request: TSCProdReqHdr; MachSetupCode: string);
    function CheckJobsNotOnPlan(PriorityOnly: boolean; ErrList: TStrings): boolean;
    function CheckJobsOnPlan(Back, HasPriority: boolean; ErrList: TStrings): boolean;
    function CheckDependencyNotOnPlan(Prev: boolean; RecPtr, ResPtr: Pointer; ErrList: TStrings): boolean;
    function GetPrecStepToSched(StepId: integer): TSCProdReqDet;
    function GetNextStepToSched(StepId: integer): TSCProdReqDet;
    procedure ClearLinkedRequest;
  end;

  TLinkReqRec = record
    Request: TSCProdReqHdr;
    MachSetupCode: string;
  end;
  PTLinkReqRec = ^TLinkReqRec;

  TRecTiming = record
    wkcCode:       string;
    wkcProc:       string;
    resCat:        string;
    resCode:       string;
    supTime:       double;
    exeTime:       double;
  end;
  PTRecTiming = ^TRecTiming;

  function SortAvailList(Item1, Item2: Pointer): integer;
  function SortSubStep(Item1, Item2: Pointer): integer;

implementation

uses
  gnugettext,
  UMActArea,
  UMWkCtr,
  UMSchedList,
  UMPlanFunc,
  UMCommon,
  // ONLY FOR DEBUG - FP
  FMShowMaterials,
  FMMainPlan,
  // ONLY FOR DEBUG - FP

  UMRes,
  UMObjCont,
  UGBaseCal,
  UMpgCal,
  UMGlobal,
  FMPlannerPropDefine,
  UMSchedObjMover,
  umcalcTimings,  FMAutoSched,
  FMBarConfig, UGCustomList, DateUtils;

type
  TProductBalance = record
    UpToDateQuantity : double;
    Date: TDateTime;
  end;
  PTProductBalance = ^TProductBalance;


//----------------------------------------------------------------------------//
// TSCSchedOnPlan
//----------------------------------------------------------------------------//

constructor TSCSchedOnPlan.Create;
begin
  inherited Create;
  m_status    := CSS_none;
  m_isDeleted := false;
  m_srvPtr    := nil;
  m_flags     := [];
  m_MoveOp    := nil;
  m_AutoSeqPrevID := CSchedIDnull;
  m_AutoSeqNextID := CSchedIDnull;
  m_SharedComment := '';
//  m_DatesErrSet := [CSE_none];
//  m_MatErrSet   := [CSE_none];
//  m_binBool   := true;
end;

//----------------------------------------------------------------------------//

destructor TSCSchedOnPlan.Destroy;
begin
  inherited destroy;
end;

//----------------------------------------------------------------------------//

function TSCSchedOnPlan.FormatId: string;
begin
  Result := Format('%6d', [m_Id])
end;

//----------------------------------------------------------------------------//

procedure TSCSchedOnPlan.SetFlags(remove: TSCFlags; add: TSCFlags);
begin
  m_flags := m_flags - remove;
  m_flags := m_flags + add
end;

//----------------------------------------------------------------------------//

function TSCSchedOnPlan.GetStartDateWithMat: TDateTime;
var
  Cal: TPGCALObj;
  ActArea:  TMqmActArea;
  TmpDate: TDateTime;
begin
  Result := p_schedStart;
  if not Assigned(m_srvPtr) then
  begin
    Result := p_schedStart;
    Exit
  end;

  ActArea := TMqmActArea(m_srvPtr);
  Cal := ActArea.GetCalendar;

  TmpDate := p_schedStart;
  if not CheckProgressed then
    cal.OfsByWH(p_supMinOvlp/60, true, TmpDate, Result, ActArea.m_CrossDownTmList);

  if Result < p_schedStart then
    Result := p_schedStart;
end;

//----------------------------------------------------------------------------//
// TSCProdReqHdr
//----------------------------------------------------------------------------//

constructor TSCProdReqHdr.Create;
begin
  inherited Create;
  m_list := TList.Create;
  m_PrecLinkedReqList := TList.Create;
  m_NextLinkedReqList := TList.Create;
  m_ProdArtList       := TMQMProdArtList.Create;
  m_RequestBalList    := TMQMRequestBalList.Create;
  m_ProductDescription := '';
end;

//----------------------------------------------------------------------------//

destructor TSCProdReqHdr.Destroy;
var
  i: integer;
begin
  for i := 0 to m_list.Count-1 do
    TSCProdReqDet(m_list[i]).Free;
  m_list.Free;

  for i := 0 to m_PrecLinkedReqList.Count-1 do
    Dispose(PTLinkReqRec(m_PrecLinkedReqList[i]));
  m_PrecLinkedReqList.Free;

  for i := 0 to m_NextLinkedReqList.Count-1 do
    Dispose(PTLinkReqRec(m_NextLinkedReqList[i]));
  m_NextLinkedReqList.Free;

  m_ProdArtList.Free;
  m_RequestBalList.Free;

  inherited Destroy
end;

//----------------------------------------------------------------------------//

function TSCProdReqHdr.GetStrId: string;
begin
  Result := _('Request. header:') + ' ' + m_code
end;

//----------------------------------------------------------------------------//

function TSCProdReqHdr.FindDetFromCode(detCode: integer): TSCProdReqDet;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to m_list.Count-1 do
    if TSCProdReqDet(m_list[i]).m_code = detCode then
    begin
      Result := TSCProdReqDet(m_list[i]);
      exit
    end
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqHdr.InvalidateDetToBeSched;
var
  i, j: integer;
  tHdr: TSCProdReqHdr;
begin
  for i := 0 to m_list.Count-1 do
    TSCProdReqDet(m_list[i]).InvalidateToBeSched;

  if assigned(m_PrecLinkedReqList) then
  begin
    for i := 0 to m_PrecLinkedReqList.Count-1 do
    begin
      tHdr := PTLinkReqRec(m_PrecLinkedReqList[i]).Request;
      for j := 0 to tHdr.m_list.Count-1 do
        TSCProdReqDet(tHdr.m_list[j]).InvalidateToBeSched;
    end;
  end;

  if assigned(m_NextLinkedReqList) then
  begin
    for i := 0 to m_NextLinkedReqList.Count-1 do
    begin
      tHdr := PTLinkReqRec(m_NextLinkedReqList[i]).Request;
      for j := 0 to tHdr.m_list.Count-1 do
        TSCProdReqDet(tHdr.m_list[j]).InvalidateToBeSched;
    end;
  end;
end;

//----------------------------------------------------------------------------//
{
 Returns the preceding steps needed to be scheduled before a specific step
 @param StepId the step number we are checking for preceding steps needed before
 @return TSCProdReqDet Production request details object with a list of steps
         Or nil if there is no object to return
 }
{
function TSCProdReqHdr.GetPrecStepToSched(StepId: integer): TSCProdReqDet;
var
  TmpProdReqDet, CurrentProdReqDet: TSCProdReqDet;
  TmpPrior, Prior, i: integer;
begin
  Result := nil;

  if not Assigned(m_list) then
    exit;

  CurrentProdReqDet := FindDetFromCode(StepId);

  if not assigned(CurrentProdReqDet) then exit;
  CurrentProdReqDet.m_PriorStepList.Clear;

  // This is the priority value of OUR step
  Prior := p_Priorities.GetPriority(CurrentProdReqDet.m_planWkctr, CurrentProdReqDet.m_planWkctrProc);

  //This loops over all steps of the production request and checks
  //if there is a priority over our step
  for i := 0 to m_list.Count-1 do
  begin
    TmpProdReqDet := TSCProdReqDet(m_list[i]);
    if not assigned(TmpProdReqDet) then exit;

    TmpPrior := p_Priorities.GetPriority(TmpProdReqDet.m_planWkctr, TmpProdReqDet.m_planWkctrProc);

    //if Check Step Sequence is checked ,then first must plan the previous step
    if (DBAppGlobals.CheckStepSeq) and
        not((TmpPrior < 0) and (Prior > 0))then    //don't use check sequence with a priority step
      if CurrentProdReqDet.m_prevStep = TmpProdReqDet.m_code then
      begin
        CurrentProdReqDet.m_PriorStepList.Add(IntToStr(TmpProdReqDet.m_code));
        continue;
      end;

  //If both steps have a priority and the other step priority is higher
  //than ours then it must precede our step
    if (TmpPrior > -1) and (TmpPrior < Prior) then
    begin
      CurrentProdReqDet.m_PriorStepList.Add(IntToStr(TmpProdReqDet.m_code));
    end;
    //If our step (Prior) has no priority(-1) and the other step has some
    //Then the other step (TmpPrior) must come first
    if (TmpPrior > -1) and (Prior < 0) then
    begin
      CurrentProdReqDet.m_PriorStepList.Add(IntToStr(TmpProdReqDet.m_code));
    end;

  end; //for loop
  result := CurrentProdReqDet;

end;
}
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
{
 Returns the steps that have  no priority over a specific step .And so can be removed
 back to bin

 @param StepId the step number we are checking for following steps that are dependant upon it
 @return TSCProdReqDet Production request details object with a list of steps Or nil if there is no
          object to return
 }
{
function TSCProdReqHdr.GetPrecStepToUNSched(StepId: integer): TSCProdReqDet;
var
  TmpProdReqDet, CurrentProdReqDet: TSCProdReqDet;
  TmpPrior, Prior, i: integer;
begin
  Result := nil;

  if not Assigned(m_list) then
    exit;

  CurrentProdReqDet := FindDetFromCode(StepId);

  if not assigned(CurrentProdReqDet) then exit;
  CurrentProdReqDet.m_PriorStepList.Clear;

  // This is the priority value of OUR step
  Prior := p_Priorities.GetPriority(CurrentProdReqDet.m_planWkctr, CurrentProdReqDet.m_planWkctrProc);

  //This loops over all steps of the production request and checks
  //if there is a priority over our step
  for i := 0 to m_list.Count-1 do
  begin
    TmpProdReqDet := TSCProdReqDet(m_list[i]);
    if not assigned(TmpProdReqDet) then exit;

    TmpPrior := p_Priorities.GetPriority(TmpProdReqDet.m_planWkctr, TmpProdReqDet.m_planWkctrProc);

     //if Check Step Sequence is checked ,then first must remove the next step
    if (DBAppGlobals.CheckStepSeq) and
        (Prior < 0) and (TmpPrior < 0) then //If the next step has a priority then no step seq performed
      if  CurrentProdReqDet.m_nextStep = TmpProdReqDet.m_code then
      begin
        CurrentProdReqDet.m_PriorStepList.Add(IntToStr(TmpProdReqDet.m_code));
        continue;
      end;

    //If both steps have a priority and the other step priority is lower
    //than ours so OUR step precedes that step - add OTHER step to list
    if (TmpPrior > -1) and (Prior > -1) and (TmpPrior > Prior) then
    begin
      CurrentProdReqDet.m_PriorStepList.Add(IntToStr(TmpProdReqDet.m_code));
    end;

    //If our step (Prior) has a priority(> -1) and the other step has no
    //Then our step (Prior) must come first - add OTHER step to list
    if (TmpPrior < 0) and (Prior > -1) then
    begin
      CurrentProdReqDet.m_PriorStepList.Add(IntToStr(TmpProdReqDet.m_code));
    end;

  end; //for loop
  result := CurrentProdReqDet;

end;
}
//----------------------------------------------------------------------------//

procedure TSCProdReqHdr.AddLinkedRequest(Request: TSCProdReqHdr; MachSetupCode: string);
var
  LinkRec: PTLinkReqRec;
begin
  new(LinkRec);
  LinkRec.Request := Request;
  LinkRec.MachSetupCode := MachSetupCode;
  m_PrecLinkedReqList.Add(LinkRec);

  new(LinkRec);
  LinkRec.Request := self;
  LinkRec.MachSetupCode := MachSetupCode;
  Request.m_NextLinkedReqList.Add(LinkRec)
end;

//----------------------------------------------------------------------------//

function TSCProdReqHdr.CheckJobsNotOnPlan(PriorityOnly: boolean; ErrList: TStrings): boolean;
//Check if there are job not scheduled
//if PriorityOnly = true check just the steps that have priority
var
  i: integer;
  tDet: TSCProdReqDet;
  RecPrior: PTWkcPriority;
begin
  Result := false;
  for i := 0 to m_list.Count -1 do
  begin
    tDet := TSCProdReqDet(m_list[i]);
    if Assigned(tDet) and not tDet.m_StepToSched then
      continue;
    if PriorityOnly then
    begin
      RecPrior := TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[tDet.m_planWkctrProc].RecPriority;
      if not Assigned(RecPrior) or not RecPrior.PriorInDispo then
        continue
    end;

    if tDet.CheckJobsNotOnPlan(ErrList) then
      Result := true;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqHdr.CheckJobsOnPlan(Back, HasPriority: boolean; ErrList: TStrings): boolean;
//Check if there are scheduled job
//if HasPriority = true check just the steps that have priority
var
  i: integer;
  tDet: TSCProdReqDet;
  RecPrior: PTWkcPriority;
begin
  Result := false;
  for i := 0 to m_list.Count -1 do
  begin
    tDet := TSCProdReqDet(m_list[i]);
    RecPrior := TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[tDet.m_planWkctrProc].RecPriority;
    if not Assigned(RecPrior) then continue;

    case RecPrior.RelationType of
      pre_PrevDspPri: if     Back and     HasPriority then continue;
      pre_PrevDspStp: if     Back and not HasPriority then continue;
      pre_NextDspPri: if not Back and     HasPriority then continue;
      pre_NextDspStp: if not Back and not HasPriority then continue;
    else
      continue
    end;

    if tDet.CheckJobsOnPlan(ErrList) then
      Result := true;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqHdr.CheckDependencyNotOnPlan(Prev: boolean; RecPtr, ResPtr: Pointer; ErrList: TStrings): boolean;
var
  tDet: TSCProdReqDet;
begin
  Result := false;
  if not Assigned(m_list) then exit;

  if Prev then
    tDet := TSCProdReqDet(m_list[m_list.Count-1])
  else
    tDet := TSCProdReqDet(m_list[0]);

  if tDet.CheckDependencyNotOnPlan(RecPtr, ResPtr, ErrList) then
    Result := true;
end;

//----------------------------------------------------------------------------//

function TSCProdReqHdr.GetPrecStepToSched(StepId: integer): TSCProdReqDet;
var
  i: integer;
  tDet: TSCProdReqDet;
begin
  Result := nil;
  for i := 0 to m_list.Count-1 do
  begin
    tDet := TSCProdReqDet(m_list[i]);
    if tDet.m_StepToSched and (tDet.m_nextStep = StepId) then
    begin
      Result := tDet;
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqHdr.GetNextStepToSched(StepId: integer): TSCProdReqDet;
var
  i: integer;
  tDet: TSCProdReqDet;
begin
  Result := nil;
  for i := 0 to m_list.Count-1 do
  begin
    tDet := TSCProdReqDet(m_list[i]);
    if tDet.m_StepToSched and (tDet.m_prevStep = StepId) then
    begin
      Result := tDet;
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqHdr.ClearLinkedRequest;
var
  I : Integer;
begin
  for i := 0 to m_PrecLinkedReqList.Count-1 do
    Dispose(PTLinkReqRec(m_PrecLinkedReqList[i]));
  m_PrecLinkedReqList.clear;

  for i := 0 to m_NextLinkedReqList.Count-1 do
    Dispose(PTLinkReqRec(m_NextLinkedReqList[i]));
  m_NextLinkedReqList.clear;
end;


//----------------------------------------------------------------------------//
// TSCProdReqDet
//----------------------------------------------------------------------------//

constructor TSCProdReqDet.Create;
begin
  inherited Create;
  m_hdr            := nil;
  m_LeadTimePrev   := 0;
  m_LeadTimeNext   := 0;
  m_LeadTimePrevBatch := 0;
  m_LeadTimeNextBatch := 0;
  m_batch_ContinuesTime := false;
  m_Continues_Parallel := false;
  m_SplitFromMcmToMqmAndAlterWorkCenter  := false;
  m_IgnoreProgress := false;
  m_NewSpeed := -1;
  m_IsSpeedChanged := false;
  m_list           := TList.Create;
  m_StepTimeList   := TList.Create;
  m_SplitInfoList_FromMcmToMqm := TList.Create;
  m_propList       := TProperties.Create;
  m_PriorStepList  := TStringlist.Create;
  m_MacSetupList   := TMQMMacSetupList.Create;
  m_BchUMList      := TMQMBchUMList.Create;
  m_toBeSched      := CSX_NotCached
end;

//----------------------------------------------------------------------------//

destructor TSCProdReqDet.Destroy;
var
  i: integer;
begin
  try
    m_propList.Free;

    for i := 0 to m_PriorStepList.Count - 1 do
      TSCProdReqDet(m_PriorStepList.Objects[i]).Free;
    m_PriorStepList.Free;

    for i := 0 to m_list.Count-1 do
      TSCProdReqDet(m_list[i]).Free;
    m_list.Free;

    for i := 0 to m_StepTimeList.Count-1 do
      Dispose(PTRecTiming(m_StepTimeList[i]));
    m_StepTimeList.Free;

    for i := 0 to m_SplitInfoList_FromMcmToMqm.Count-1 do
      Dispose(PTMQMSplitInfoFromMcm(m_SplitInfoList_FromMcmToMqm[i]));
    m_SplitInfoList_FromMcmToMqm.Free;

    for i := 0 to m_MacSetupList.p_count - 1 do
      TSCProdReqDet(m_MacSetupList.p_Item[i]).Free;

    m_BchUMList.Free;

    m_MacSetupList.Free;

    inherited Destroy;
  except
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.GetRealCount: integer;
var
  I : Integer;
  tJob : TSCProdSched;
begin
  Result := 0;
  for I := 0 to m_list.Count - 1 do
  begin
    tJob := TSCProdSched(m_list[I]);
    if tJob.m_isDeleted then
      Continue
    else
      Inc(Result);
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.GetNewSpeed: double;
begin
  Result := m_NewSpeed
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqDet.SetNewSpeed(speed: double);
begin
  m_NewSpeed := speed;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.GetNewSetup: double;
begin
  Result := m_NewSetup
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqDet.SetNewSetup(setup: double);
begin
  m_NewSetup := setup;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.GetStrId: string;
begin
  Result := _('Header') + ' (' + m_hdr.m_code + ') - ' + _('details:') + ' ' + IntToStr(m_code)
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.FindJobFromCode(jobCode, ReprocNo: integer): TSCProdSched;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to m_list.Count-1 do
    if (TSCProdSched(m_list[i]).m_code = jobCode)
    and (TSCProdSched(m_list[i]).m_reprocNo = ReprocNo) and not (TSCProdSched(m_list[i]).m_isdeleted) then
    begin
      Result := TSCProdSched(m_list[i]);
      exit
    end
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.ToBeSched(ErrList: TStrings): CScToBeSched;
begin
  if Assigned(ErrList) then
    m_toBeSched := CSX_NotCached;

  if m_toBeSched = CSX_NotCached then
  begin
    if not CheckDependencyToSched(nil, ErrList) then
      m_toBeSched := CSX_WaitDep
    else
      if not CheckPriorityToSched(ErrList) then
        m_toBeSched := CSX_WaitPri
      else
        m_toBeSched := CSX_Yes;
  end;

  Result := m_toBeSched
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqDet.InvalidateToBeSched;
begin
  m_toBeSched := CSX_NotCached
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.CheckPriorityToSched(ErrList: TStrings): boolean;
var
  SelfRecPrior, RecPrior: PTWkcPriority;
  SelfChkStepsPri, ChkStepsPri: boolean;
  i, pd, ps: integer;
  tDet, LeadtDet : TSCProdReqDet;
  tHdr: TSCProdReqHdr;
  tjob : TSCProdSched;
  PriorOnly: boolean;
  vOk, CheckLeadStep : boolean;
begin
  Result := true;
  CheckLeadStep := true;
  SelfRecPrior := nil;

  if (m_hdr.m_LeadStepForSplit <> -1) and (m_hdr.m_LeadStepForSplit <> m_code) then
  begin
    for pd := 0 to m_hdr.m_list.Count-1 do
    begin
      tDet := TSCProdReqDet(m_hdr.m_list[pd]);
      for ps := 0 to tDet.m_list.Count - 1 do
      begin
        tjob := TSCProdSched(tDet.m_list[ps]);
        if tJob.m_isDeleted then
          continue;
        if (CProgress(p_sc.IsProgressed(tJob.m_id)) <> prg_none) then
        begin
          CheckLeadStep := false;
          break;
        end;
      end;
    end;
  end;

  if (m_hdr.m_LeadStepForSplit <> -1) and (m_hdr.m_LeadStepForSplit <> m_code) then
  begin
    for I := 0 to m_hdr.m_list.Count - 1 do
    begin
      if (m_hdr.m_LeadStepForSplit = TSCProdReqDet(m_hdr.m_list[I]).m_code) then
      begin
        if not CheckLeadStep then break;

        LeadtDet := TSCProdReqDet(m_hdr.m_list[I]);

        if (LeadtDet.GetRealCount > 1)  then
        begin
          LeadtDet.CheckJobsForLeadStep(ErrList, 's');
          Result := false;
          exit;
        end;

        // Lead step not scheduled allow scheduling, only block splitting
        // if not Assigned(TSCProdSched(LeadtDet.m_list[0]).m_srvPtr) then
        // begin
        //   LeadtDet.CheckJobsForLeadStep(ErrList, 'u');
        //   Result := false;
        //   exit;
        // end;

        vOk := false;
        if (p_sc.GetSchedType(TSCProdSched(LeadtDet.m_list[0]).m_id) = '2')
        or (m_hdr.m_ConfLevels = '1') then
          vOk := true
        else
          if (p_sc.GetSchedType(TSCProdSched(LeadtDet.m_list[0]).m_id) >= m_hdr.m_ConfLevels) then
            vOk := true;

        if not vOk then
        begin
          if LeadtDet.CheckJobsForLeadStep(ErrList, m_hdr.m_ConfLevels) then
            exit;
        end;
      end;
    end;
  end;

  if assigned(m_PlanWrkCtrPtr) then
     if assigned(TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList) then
        if m_planWkctrProc <> '' then
           if Assigned(TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[m_planWkctrProc]) then
          // This is the priority record of OUR step

           SelfRecPrior := TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[m_planWkctrProc].RecPriority;
           SelfChkStepsPri := Assigned(SelfRecPrior) and SelfRecPrior.PriorInDispo;
  //This loops over all steps of the production request and checks
  //if there is a priority over our step
  for i := 0 to m_hdr.m_list.Count-1 do
  begin
    RecPrior := nil;
    tDet := m_hdr.m_list[i];
    if not assigned(tDet.m_PlanWrkCtrPtr) or (tDet = self) then continue;

    if assigned(m_PlanWrkCtrPtr) then
     if assigned(TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList) then
       if tDet.m_planWkctrProc <> '' then
         if assigned(TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList) then
           if TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcCount > 0 then
             if Assigned(TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[tDet.m_planWkctrProc]) then
               if Assigned(TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[tDet.m_planWkctrProc].RecPriority) then
         RecPrior := TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[tDet.m_planWkctrProc].RecPriority;
    ChkStepsPri := Assigned(RecPrior) and RecPrior.PriorInDispo;

    //if Check Step Sequence is checked ,then first must plan the previous step
    if (DBAppGlobals.CheckStepSeq) and
//        not(not assigned(RecPrior) and Assigned(SelfRecPrior)) then    //don't use check sequence with a priority step
       (ChkStepsPri or not SelfChkStepsPri) then    //don't use check sequence with a priority step
    begin
      if m_prevStep = tDet.m_code then
      begin
        if tDet.CheckJobsNotOnPlan(ErrList) then
          Result := false;
        continue;
      end;
    end;
    //If both steps have a priority and the other step priority is higher
    //than ours then it must precede our step
    if ChkStepsPri and SelfChkStepsPri
    and (RecPrior.PrioritySeq < SelfRecPrior.PrioritySeq) then
    begin
      if tDet.CheckJobsNotOnPlan(ErrList) then
        Result := false;
    end;
    //If our step (SelfRecPrior) has no priority and the other step has some
    //Then the other step (RecPrior) must come first
    if ChkStepsPri and not SelfChkStepsPri then
    begin
      if tDet.CheckJobsNotOnPlan(ErrList) then
        Result := false;
    end;
  end;

  if not Assigned(SelfRecPrior) then exit;

  case SelfRecPrior.RelationType of
  pre_PrevDspPri,
  pre_PrevDspStp: begin
                    //This loops over all steps of the previous connected production request and checks
                    //if there is a priority over our step
                    for i := 0 to m_hdr.m_PrecLinkedReqList.Count -1 do
                    begin
                      tHdr := PTLinkReqRec(m_hdr.m_PrecLinkedReqList[i]).Request;
                      PriorOnly := (SelfRecPrior.RelationType = pre_PrevDspPri);
                      if tHdr.CheckJobsNotOnPlan(PriorOnly, ErrList) then
                        Result := false
                    end
                  end;
  pre_NextDspPri,
  pre_NextDspStp: begin
                    //This loops over all steps of the next connected production request and checks
                    //if there is a priority over our step
                    for i := 0 to m_hdr.m_NextLinkedReqList.Count -1 do
                    begin
                      tHdr := PTLinkReqRec(m_hdr.m_NextLinkedReqList[i]).Request;
                      PriorOnly := (SelfRecPrior.RelationType = pre_NextDspPri);
                      if tHdr.CheckJobsNotOnPlan(PriorOnly, ErrList) then
                        Result := false
                    end
                  end;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.CheckPriorityToUnsched(ErrList: TStrings): boolean;
var
  SelfRecPrior, RecPrior: PTWkcPriority;
  i: integer;
  tDet: TSCProdReqDet;
  tHdr: TSCProdReqHdr;
  SelfChkStepsPri, ChkStepsPri: boolean;
begin
  Result := true;
  SelfRecPrior := nil;
  tDet := self;

  try
    if assigned(m_PlanWrkCtrPtr) then
     if assigned(TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList) then
       if tDet.m_planWkctrProc <> '' then
        if Assigned(tDet.m_PlanWrkCtrPtr) then
           if assigned(TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList) then
             if TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcCount > 0 then
               if Assigned(TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[tDet.m_planWkctrProc]) then
                 if Assigned(TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[tDet.m_planWkctrProc].RecPriority) then

  // This is the priority record of OUR step
  SelfRecPrior := TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[m_planWkctrProc].RecPriority;
  SelfChkStepsPri := Assigned(SelfRecPrior) and SelfRecPrior.PriorInDispo;

  //This loops over all steps of the production request and checks
  //if there is a priority over our step
  for i := 0 to m_hdr.m_list.Count-1 do
  begin
    tDet := m_hdr.m_list[i];
    if (tDet = self) then continue;

    if (tDet.m_PlanWrkCtrPtr = nil) then continue; // avi to ask

{    if assigned(m_PlanWrkCtrPtr) then
     if assigned(TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList) then
       if tDet.m_planWkctrProc <> '' then
         if assigned(TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList) then
           if TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcCount > 0 then
             if Assigned(TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[tDet.m_planWkctrProc]) then
               if Assigned(TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[tDet.m_planWkctrProc].RecPriority) then
}


    RecPrior := TMqmWrkCtr(tDet.m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[tDet.m_planWkctrProc].RecPriority;
    ChkStepsPri := Assigned(RecPrior) and RecPrior.PriorInDispo;

    //if Check Step Sequence is checked ,then first must plan the previous step
    if (DBAppGlobals.CheckStepSeq) and
//        not(not assigned(RecPrior) and Assigned(SelfRecPrior)) then    //don't use check sequence with a priority step
       (ChkStepsPri or not SelfChkStepsPri) then    //don't use check sequence with a priority step
    begin
      if m_prevStep = tDet.m_code then
      begin
        if not CheckJobsOnPlan(ErrList) then
          Result := false;
        continue;
      end;
    end;
    //If both steps have a priority and the other step priority is lower
    //than ours then it precedes our step
    if ChkStepsPri and SelfChkStepsPri
    and (RecPrior.PrioritySeq > SelfRecPrior.PrioritySeq) then
    begin
      if tDet.CheckJobsOnPlan(ErrList) then
        Result := false;
    end;
    //If our step (CurrRecPrior) has priority and the other step has not
    //Then the our step (RecPrior) must come first
    if not ChkStepsPri and SelfChkStepsPri then
    begin
      if tDet.CheckJobsOnPlan(ErrList) then
        Result := false;
    end;
  end;

  //This loops over all steps of the previous connected production request and checks
  //if there is a priority over our step
  for i := 0 to m_hdr.m_PrecLinkedReqList.Count -1 do
  begin
    tHdr := PTLinkReqRec(m_hdr.m_PrecLinkedReqList[i]).Request;
    if tHdr.CheckJobsOnPlan(true, SelfChkStepsPri, ErrList) then
      Result := false
  end;

  //This loops over all steps of the next connected production request and checks
  //if there is a priority over our step
  for i := 0 to m_hdr.m_NextLinkedReqList.Count -1 do
  begin
    tHdr := PTLinkReqRec(m_hdr.m_NextLinkedReqList[i]).Request;
    if tHdr.CheckJobsOnPlan(false, SelfChkStepsPri, ErrList) then
      Result := false
  end

  except
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.CheckDependencyToSched(ResPtr: pointer; ErrList: TStrings): boolean;
var
{$ifdef ARO}
  z: integer;
  ProdArtToBeCheck : PTProdArt;
  ArtToBeCheck: TMQMArticle;
{$endif}
  k: integer;
  DepList: TWkcDepList;
  RecDep: PTWkcDependency;
  tHdr: TSCProdReqHdr;
  tDet: TSCProdReqDet;
  tJob: TSCProdSched;
  Res: TMqmRes;
  JobOnGantt: integer;

  procedure checkDepList;
  var
    i, j: integer;
  begin
    for i := 0 to DepList.GetCount -1 do
    begin
      RecDep := DepList.GetDepRec(i);

      case RecDep.DependOn of
      dre_PrevStep   :  begin
                          tDet := m_hdr.GetPrecStepToSched(m_code);
                          if Assigned(tDet) and tDet.CheckDependencyNotOnPlan(RecDep, Res, ErrList) then
                            Result := false
                        end;
      dre_PrevConnReq:  begin
                          for j := 0 to m_hdr.m_PrecLinkedReqList.Count -1 do
                          begin
                            tHdr := PTLinkReqRec(m_hdr.m_PrecLinkedReqList[j]).Request;
                            if tHdr.CheckDependencyNotOnPlan(true,RecDep, Res, ErrList) then
                              Result := false
                          end;
                        end;
      dre_NextStep   :  begin
                          tDet := m_hdr.GetNextStepToSched(m_code);
                          if Assigned(tDet) and tDet.CheckDependencyNotOnPlan(RecDep, Res, ErrList) then
                            Result := false
                        end;
      dre_NextConnReq:  begin
                          for j := 0 to m_hdr.m_NextLinkedReqList.Count -1 do
                          begin
                            tHdr := PTLinkReqRec(m_hdr.m_NextLinkedReqList[j]).Request;
                            if tHdr.CheckDependencyNotOnPlan(false,RecDep, Res, ErrList) then
                              Result := false
                          end;
                        end;
      end;
    end;
  end;
begin
  Result := true;
  DepList := nil;

  if Assigned(m_PlanWrkCtrPtr) then
    if assigned(TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList) then
       if m_planWkctrProc <> '' then
          if assigned(TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[m_planWkctrProc]) then

  DepList := TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[m_planWkctrProc].DependencyList;

  if Assigned(DepList) then
  begin
    JobOnGantt := 0;

    if Assigned(ResPtr) then
    begin
      Res := TMqmRes(ResPtr);
      checkDepList;
    end else
    begin
      for k := 0 to m_list.Count -1 do
      begin
        tJob := TSCProdSched(m_list[k]);
        if not Assigned(tJob.m_srvPtr) then continue;
        inc(JobOnGantt);
        Res := TMqmRes(TMqmActArea(tJob.m_srvPtr).p_Res);
        checkDepList;
      end;

      if JobOnGantt = 0 then
      begin
        Res := nil;
        checkDepList;
      end
    end;
  end;

{$ifdef ARO}
  for k := 0 to m_hdr.m_NextLinkedReqList.Count -1 do
  begin
    tHdr := PTLinkReqRec(m_hdr.m_NextLinkedReqList[k]).Request;
    tDet := tHdr.m_list[0];
    tJob := tDet.m_list[0];

    ArtToBeCheck := nil;

    for z := 0 to m_hdr.m_ProdArtList.p_count -1 do
    begin
      ProdArtToBeCheck := PTProdArt(m_hdr.m_ProdArtList.p_Item[z]);
      if ProdArtToBeCheck.ArtOnBalance = aob_DisplayOnly then
      begin
        ArtToBeCheck := ProdArtToBeCheck.Article;
        break;
      end;
    end;

    if not Assigned(ArtToBeCheck) then exit;

    if Assigned(tJob.m_srvPtr) and
       (not tDet.CheckIfUseMatOfReqConnected(ArtToBeCheck, TMQMActArea(tJob.m_srvPtr).p_Res, tJob.m_MachSetupCode)) then
    begin
      Result := false;
      if Assigned(errList) then
        ErrList.Add(_('There are dependent jobs already scheduled'));
      exit
    end;
  end;
{$endif}
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.CheckIfUseMatOfReqConnected(ArtToBeCheck: TMQMArticle; ResPtr: Pointer; MacSetupCode: string): boolean;
var
  IssuedArt: PTIssuedArt;
  i : integer;
  ContinueCheck: boolean;
  MacSetupRec: TMacSetup;
  Res: TMQMRes;
  IssArtList : TMQMIssuedArtList;
begin

  Result := false;
  ContinueCheck := false;

  if Assigned(ResPtr) then
  begin
    Res := TMQMRes(ResPtr)
  end else
  begin
    Result := true;
    exit
  end;

  MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;
  MacSetupRec.ResCat     := Res.p_ResCat.p_ResCatCode;
  MacSetupRec.ResCode    := Res.p_ResCode;
  MacSetupRec.MachineSetupCode := MacSetupCode;

  IssArtList := TMQMIssuedArtList.Create(true);
  m_MacSetupList.GetIssuedArtList(MacSetupRec, IssArtList);

  for i := 0 to IssArtList.p_count -1 do
  begin
    IssuedArt := PTIssuedArt(IssArtList.p_Item[i]);
    if IssuedArt.ArtOnBalance = aob_ReqNumber then
    begin
      ContinueCheck := true;
      break;
    end;
  end;

  if not ContinueCheck then exit;

  for i := 0 to IssArtList.p_count -1 do
  begin
    IssuedArt := PTIssuedArt(IssArtList.p_Item[i]);
    if (IssuedArt.ArtOnBalance = aob_DisplayOnly) and
       (IssuedArt.Article.p_ArtCode = ArtToBeCheck.p_ArtCode) then
    begin
      Result := true;
      exit;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.CheckDependencyOnRes(ResPtr: Pointer; ErrList: TStrings): boolean;
var
{$ifdef ARO}
  k, z: integer;
//  tHdr: TSCProdReqHdr;
//  tDet: TSCProdReqDet;
  tJob, SelfJob: TSCProdSched;
  ArtToBeCheck: TMQMArticle;
  ProdArtToBeCheck : PTProdArt;
  MacSetupCode: string;
  TmpStrLst : TStringList;
{$endif ARO}
  tHdr: TSCProdReqHdr;
  tDet: TSCProdReqDet;
  i,j: integer;
  DepList: TWkcDepList;
  RecDep: PTWkcDependency;
begin
  Result := true;

  DepList := nil;

  if Assigned(m_PlanWrkCtrPtr) then
    if assigned(TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList) then
       if m_planWkctrProc <> '' then
          if assigned(TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[m_planWkctrProc]) then

  DepList := TMqmWrkCtr(m_PlanWrkCtrPtr).P_WkcProcList.p_ProcByName[m_planWkctrProc].DependencyList;

  if Assigned(DepList) then
  begin
    for i := 0 to DepList.GetCount -1 do
    begin
      RecDep := DepList.GetDepRec(i);
      case RecDep.DependOn of
      dre_PrevStep   :  begin
                          tDet := m_hdr.GetPrecStepToSched(m_code);
                          if Assigned(tDet) and tDet.CheckDependencyNotOnPlan(RecDep, ResPtr, ErrList) then
                            Result := false
                        end;
      dre_PrevConnReq:  begin
                          for j := 0 to m_hdr.m_PrecLinkedReqList.Count -1 do
                          begin
                            tHdr := PTLinkReqRec(m_hdr.m_PrecLinkedReqList[j]).Request;
                            if tHdr.CheckDependencyNotOnPlan(true,RecDep, ResPtr, ErrList) then
                              Result := false
                          end;
                        end;
      dre_NextStep   :  begin
                          tDet := m_hdr.GetNextStepToSched(m_code);
                          if Assigned(tDet) and tDet.CheckDependencyNotOnPlan(RecDep, ResPtr, ErrList) then
                            Result := false
                        end;
      dre_NextConnReq:  begin
                          for j := 0 to m_hdr.m_NextLinkedReqList.Count -1 do
                          begin
                            tHdr := PTLinkReqRec(m_hdr.m_NextLinkedReqList[j]).Request;
                            if tHdr.CheckDependencyNotOnPlan(false,RecDep, ResPtr, ErrList) then
                              Result := false
                          end;
                        end;
      end;
//      if CheckDependencyNotOnPlan(RecDep, ResPtr, nil) then
//        Result := false
    end
  end;

{$ifdef ARO}
  for k := 0 to m_hdr.m_PrecLinkedReqList.Count -1 do
  begin
    tHdr := PTLinkReqRec(m_hdr.m_PrecLinkedReqList[k]).Request;
    tDet := tHdr.m_list[0];
    tJob := tDet.m_list[0];

    ArtToBeCheck := nil;

    for z := 0 to tHdr.m_ProdArtList.p_count -1 do
    begin
      ProdArtToBeCheck := PTProdArt(tHdr.m_ProdArtList.p_Item[z]);
      if ProdArtToBeCheck.ArtOnBalance = aob_DisplayOnly then
      begin
        ArtToBeCheck := ProdArtToBeCheck.Article;
        break;
      end;
    end;

    if not Assigned(ArtToBeCheck) then exit;

    SelfJob := m_list[0];
    MacSetupCode := SelfJob.m_MachSetupCode;

    if MacSetupCode = '' then
    begin
      TmpStrLst := TStringList.Create;
      p_pl.SetTmgTargetRes(ResPtr);
      p_pl.GetTmgDescList(TmpStrLst);
      if TmpStrLst.Count > 0 then
        MacSetupCode := TmpStrLst[0];
      TmpStrLst.Free;
    end;

    if (not CheckIfUseMatOfReqConnected(ArtToBeCheck, ResPtr, MacSetupCode))
    and Assigned(tJob.m_srvPtr) then
    begin
      Result := false;
      if Assigned(errList) then
        ErrList.Add(_('There are dependent jobs already scheduled'));
      exit
    end;
  end;
{$endif}
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.CheckJobsNotOnPlan(ErrList: TStrings): boolean;
var
  i: integer;
  tJob: TSCProdSched;
begin
  Result := false;
  for i := 0 to m_list.Count -1 do
  begin
    tJob := TSCProdSched(m_list[i]);
    if  not Assigned(tJob.m_srvPtr)
    and (tJob.m_status <> CSS_del)
    and (not tJob.m_reqDet.m_stepClosed)
    and (not tJob.m_isDeleted) then
    begin
      Result := true;
      if Assigned(ErrList) then
        ErrList.Add(_('Request')   + ' ' + m_hdr.m_code + ' ' +
                    _('Step')      + ' ' + IntToStr(m_code) + ' ' +
                    _('SubStep')   + ' ' + IntToStr(tJob.m_code) + ' ' +
                    _('Reprocess') + ' ' + IntToStr(tJob.m_reprocNo) + ' ' +
                    _('must be scheduled before this job because of priority'));
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.CheckJobsForLeadStep(ErrList: TStrings; ConfirmationLvl : string): boolean;
var
  i: integer;
  tJob: TSCProdSched;
  ConfirmLvl : string;
begin
  Result := false;
  for i := 0 to m_list.Count -1 do
  begin
    tJob := TSCProdSched(m_list[i]);

    // Closed step check moved to CheckHostLeadStepSplit
    // if Assigned(ErrList) and tJob.m_reqDet.m_stepClosed then
    // begin
    //   Result := true;
    //   ErrList.Add(_('Leading step ' + IntToStr(m_code) + ' is closed'));
    //   exit;
    // end;

    if Assigned(ErrList)
    and (tJob.m_status <> CSS_del)
    and (not tJob.m_isDeleted) then
    begin

      if ConfirmationLvl = 's' then
      begin
        Result := true;
        ErrList.Add(_('Leading step is split'));
        exit;
      end;

      if ConfirmationLvl = 'u' then
      begin
        Result := true;
        ErrList.Add(_('Leading step is not scheduled'));
        exit;
      end;

      if ConfirmationLvl = '3' then
         ConfirmLvl := _('Confirmation level 1')

      else if ConfirmationLvl = '1' then
         ConfirmLvl := _('Initial')

      else if ConfirmationLvl = '2' then
         ConfirmLvl := _('Final')

      else if ConfirmationLvl = '4' then
         ConfirmLvl := _('Confirmation level 2')

      else if ConfirmationLvl = '5' then
         ConfirmLvl := _('Confirmation level 3')

      else if ConfirmationLvl = '6' then
         ConfirmLvl := _('Confirmation level 4')

      else if ConfirmationLvl = '7' then
         ConfirmLvl := _('Confirmation level 5');

      Result := true;
      ErrList.Add(_('Request')   + ' ' + m_hdr.m_code + ' ' +
                    _('Step')      + ' ' + IntToStr(m_code) + ' ' +
                   // _('SubStep')   + ' ' + IntToStr(tJob.m_code) + ' ' +
                   // _('Reprocess') + ' ' + IntToStr(tJob.m_reprocNo) + ' ' +
                  //  _('must be scheduled before this job because as leading step for spliting the request, is either have more then one sub step or not scheduled as final '));
                   _('must be scheduled before this job because as leading step for spliting the request, is either have more then one sub step or not scheduled as ') + ConfirmLvl);
      exit;

    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.CheckJobsOnPlan(ErrList: TStrings): boolean;
var
  i: integer;
  tJob: TSCProdSched;
begin
  Result := false;
  for i := 0 to m_list.Count -1 do
  begin
    tJob := TSCProdSched(m_list[i]);
    if Assigned(tJob.m_srvPtr) then
    begin
      Result := true;
      if Assigned(ErrList) then
        ErrList.Add(_('Request')   + ' ' + m_hdr.m_code + ' ' +
                    _('Step')      + ' ' + IntToStr(m_code) + ' ' +
                    _('SubStep')   + ' ' + IntToStr(tJob.m_code) + ' ' +
                    _('Reprocess') + ' ' + IntToStr(tJob.m_reprocNo) + ' ' +
                    _('must be unscheduled before this job because of priority'));
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.CheckDependencyNotOnPlan(RecPtr, ResPtr: Pointer; ErrList: TStrings): boolean;
var
  i: integer;
  tJob: TSCProdSched;
  RecDep: PTWkcDependency;
  Res, JobRes: TMqmRes;

  procedure AddMsg;
  begin
    if Assigned(ErrList) then
      ErrList.Add(_('This job is dependent on') + ' ' +
                  _('Request')   + ' ' + m_hdr.m_code + ' ' +
                  _('Step')      + ' ' + IntToStr(m_code) + ' ' +
                  _('SubStep')   + ' ' + IntToStr(tJob.m_code) + ' ' +
                  _('Reprocess') + ' ' + IntToStr(tJob.m_reprocNo));
  end;
begin
  Result := false;
  RecDep := RecPtr;
  Res := TMqmRes(ResPtr);

  for i := 0 to m_list.Count -1 do
  begin
    tJob := TSCProdSched(m_list[i]);
    if not Assigned(tJob.m_srvPtr) then continue;

    JobRes := TMqmRes(TMqmActArea(tJob.m_srvPtr).p_Res);
         //if it is shcheduled on...
    if ((RecDep.DepSchedOnWC <> '')     and (RecDep.DepSchedOnWC     <> TMqmWrkCtr(JobRes.p_WrkCtr).p_WrkCtrCode))
    or ((RecDep.DepSchedOnResCat <> '') and (RecDep.DepSchedOnResCat <> JobRes.p_ResCat.p_ResCatCode))
    or ((RecDep.DepSchedOnRes <> '')    and (RecDep.DepSchedOnRes    <> JobRes.p_ResCode)) then
      continue;

//    if not Assigned(Res) then continue;

    if not Assigned(Res) then
    begin
      if  (RecDep.NotAlwdWC <> '')
      or (RecDep.NotAlwdResCat <> '')
      or (RecDep.NotAlwdRes <> '') then
        continue;
    end else
    begin
          //...then don't allow to schedule on
      if ((RecDep.NotAlwdWC <> '')     and (RecDep.NotAlwdWC     <> TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode))
      or ((RecDep.NotAlwdResCat <> '') and (RecDep.NotAlwdResCat <> Res.p_ResCat.p_ResCatCode))
      or ((RecDep.NotAlwdRes <> '')    and (RecDep.NotAlwdRes    <> Res.p_ResCode)) then
        continue;
    end;

    Result := true;
    AddMsg;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.GetGrpSequence: string;
begin
  result := m_Grp_Sequence
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.GetLearningCurveType : CSCurveType;
begin
  Result := m_CurveType
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqDet.SetGrpSequence(GrpSequence: string);
begin
  m_Grp_Sequence := GrpSequence
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.GetLeadTimePrev: double;
begin
  Result := m_LeadTimePrev
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqDet.SetLeadTimePrev(LeadTimePrev: double);
begin
  m_LeadTimePrev := LeadTimePrev;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.GetLeadTimeNext: double;
begin
  Result := m_LeadTimeNext;
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqDet.SetLeadTimeNext(LeadTimeNext: double);
begin
  m_LeadTimeNext := LeadTimeNext;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.GetLeadTimePrevBatch: double;
begin
  Result := m_LeadTimePrevBatch
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqDet.SetLeadTimePrevBatch(LeadTimePrevBatch: double);
begin
  m_LeadTimePrevBatch := LeadTimePrevBatch;
end;

//----------------------------------------------------------------------------//

function TSCProdReqDet.GetLeadTimeNextBatch: double;
begin
  Result := m_LeadTimeNextBatch;
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqDet.SetLeadTimeNextBatch(LeadTimeNextBatch: double);
begin
  m_LeadTimeNextBatch := LeadTimeNextBatch;
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqDet.SetLearningCurveType(CurveType : CSCurveType);
begin
  m_CurveType := CurveType
end;

//----------------------------------------------------------------------------//

procedure TSCProdReqDet.SetMaxStartingDateAutoSeq(MaxDate : TDateTime);
begin
  m_MaxStartingDateAutoSeq := MaxDate;
end;

//----------------------------------------------------------------------------//
// TSCProdGroup
//----------------------------------------------------------------------------//

constructor TSCProdGroup.Create;
begin
  inherited Create;
  m_list     := TList.Create;
  m_Job_Sequence := 0;
  m_NewSpeed := -1;
  m_IsSpeedChanged := false;
  m_propList := nil;
  m_RealoadProperties := true;
end;

//----------------------------------------------------------------------------//

destructor TSCProdGroup.Destroy;
begin
  if Assigned(m_propList) then
    m_propList.Free;
  if Assigned(m_list) then
    m_list.Free;
  if Assigned(m_ListOfSequence) then
     m_ListOfSequence.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetStrId: string;
begin
  if m_code < 0 then
    Result := IntToStr((-1)* m_code) + '(-Host)'
  else
    Result := IntToStr(m_code) ;
  if m_list.Count = 1 then Result := Result + ' - Request ' +
    (TSCProdSched(m_list.Items[0])).m_reqDet.m_hdr.m_code;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetActualTime: double;
var
  sc : TSCProdSched;
  OldGrpSeq : string;
  Cal: TPGCALObj;
  ActArea : TMqmActArea;
begin
  Result := 0;
  ActArea := nil;
  sc := TSCProdSched(m_list[0]);
  OldGrpSeq := sc.m_Grp_Sequence;
  if assigned(sc.m_srvPtr) then
    ActArea := TMqmActArea(m_srvPtr);
  if not assigned(ActArea) then exit;
  Cal := ActArea.GetCalendar;
  if not assigned(cal) then exit;

  if p_schedEnd <= p_schedStart then
    Result := 0
  else if (p_schedEnd - p_schedStart) <= (2/24/60/60) then  // up to 2 seconds - skip calendar calc
    Result := (p_schedEnd - p_schedStart) * 24 * 60
  else
    Result := cal.DiffWH(p_schedStart, p_schedEnd , ActArea.m_CrossDownTmList)*60;
{  Result := sc.p_GetActualTime; //cal.DiffWH(sc.p_schedStart, sc.p_schedEnd , ActArea.m_CrossDownTmList)*60;

  for I := 1 to m_List.Count - 1 do
  begin
    sc := TSCProdSched(m_list[i]);
    if (OldGrpSeq = '') or (sc.m_Grp_Sequence = '') or (OldGrpSeq <> sc.m_Grp_Sequence) then
    begin
      Result := Result + cal.DiffWH(sc.p_schedStart, sc.p_schedEnd , ActArea.m_CrossDownTmList)*60;
      OldGrpSeq := sc.m_Grp_Sequence;
    end;
  end;  }
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetBarStr(isJobBar: boolean; LineNumber : Integer) : string;
var
  sc: TSCProdSched;
  WC : string;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  sc := TSCProdSched(m_list[0]);
  WC := p_sc.GetFldDescr(m_id, CSC_WkctCode, false);
  result := getBarString(Wc,sc,true,isJobBar,LineNumber);
//  result := getBarString(sc.GetWorkCenter,sc,true,isJobBar,LineNumber);
end;

function TSCProdGroup.GetLineNum(isJobBar:boolean): Integer;
var
  sc: TSCProdSched;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  sc := TSCProdSched(m_list[0]);
  result := getLineNumber(sc.GetWorkCenter,isJobBar);

end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetLastScheudleChange: TDateTime;
var
  sc: TSCProdSched;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  sc := TSCProdSched(m_list[0]);
  result := sc.p_LastScheudleChange;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetSavedScheduleDate: TDateTime;
var
  sc: TSCProdSched;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  sc := TSCProdSched(m_list[0]);
  result := sc.p_SavedScheudleDate;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetOrigStartDate: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).m_schedStart;

  for i := 1 to m_list.Count-1 do
    if Result > TSCProdSched(m_list[i]).m_schedStart then
      Result := TSCProdSched(m_list[i]).m_schedStart;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.UpdateBalance(VisResPtr: pointer; CalcMat : boolean);
var
  i : integer;
begin
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  for i := 0 to m_list.Count-1 do
  begin
//    Assert(Assigned(TSCProdSched(m_list[i]).m_srvPtr));
    TSCProdSched(m_list[i]).UpdateBalance(VisResPtr,CalcMat)
  end;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.ClearBalance;
var
  i : integer;
begin
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  for i := 0 to m_list.Count-1 do
    TSCProdSched(m_list[i]).ClearBalance
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetStartDate: TDateTime;
var
  i: integer;
begin
  //Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;

  Result := TSCProdSched(m_list[0]).p_schedStart;

  for i := 1 to m_list.Count-1 do
    if ((TSCProdSched(m_list[i]).p_schedStart > 0) and (Result > TSCProdSched(m_list[i]).p_schedStart))
       or ((Result = 0) and (TSCProdSched(m_list[i]).p_schedStart > 0)) then
      Result := TSCProdSched(m_list[i]).p_schedStart;

//  for i := 1 to m_list.Count-1 do
//    if (TSCProdSched(m_list[i]).p_schedStart > 0) and (Result > TSCProdSched(m_list[i]).p_schedStart) then
//      Result := TSCProdSched(m_list[i]).p_schedStart;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetSchedStartOfJobInContGroup: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).m_SchedStartOfJobInContGroup;
  for i := 1 to m_list.Count-1 do
    if Result > TSCProdSched(m_list[i]).m_SchedStartOfJobInContGroup then
      Result := TSCProdSched(m_list[i]).m_SchedStartOfJobInContGroup;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetSchedEndOfJobInContGroup: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).m_SchedEndOfJobInContGroup;
  //take the highest end date
  for i := 1 to m_list.Count-1 do
    if Result < TSCProdSched(m_list[i]).m_SchedEndOfJobInContGroup then
      Result := TSCProdSched(m_list[i]).m_SchedEndOfJobInContGroup;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetStartDate(StDate: TDateTime);
var
  i: integer;
begin
  //Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
//  if TSCProdSched(m_list[0]).m_reqDet.m_stepType = CST_batch then
    for i := 0 to m_list.Count-1 do
      TSCProdSched(m_list[i]).p_schedStart := StDate;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetOrigEndDate: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).m_schedEnd;

  //take the highest end date
  for i := 1 to m_list.Count-1 do
    if Result < TSCProdSched(m_list[i]).m_schedEnd then
      Result := TSCProdSched(m_list[i]).m_schedEnd;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetSetupEndDate: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).p_SetupEndDate;

  //take the highest end date
  for i := 1 to m_list.Count-1 do
    if Result < TSCProdSched(m_list[i]).p_SetupEndDate then
      Result := TSCProdSched(m_list[i]).p_SetupEndDate;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetEndDate: TDateTime;
var
  i, J: integer;
  AtLeast1ChildProgressed : boolean;
  HighestPrgCurDt : TDateTime;
  tJob : TSCProdSched;
  ActArea : TMqmActArea;
  Cal: TPGCALObj;
//  supMinReal : double;
  SumRemTimeGrp, TmpRemTime : double;
  SunExecAndSetUp : double;
  HighestPrgEd, HighestPrgGeneric : TDateTime;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  AtLeast1ChildProgressed := false;
  SumRemTimeGrp := 0;
  ActArea := nil;
  Cal     := nil;

  Result := TSCProdSched(m_list[0]).p_schedEnd;

  //take the highest end date
  for i := 1 to m_list.Count-1 do
    if Result < TSCProdSched(m_list[i]).p_schedEnd then
      Result := TSCProdSched(m_list[i]).p_schedEnd;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetLastScheudleChange(StDate: TDateTime);
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  for i := 0 to m_list.Count-1 do
    TSCProdSched(m_list[i]).p_LastScheudleChange := StDate;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetSavedScheduleDate(StDate: TDateTime);
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  for i := 0 to m_list.Count-1 do
    TSCProdSched(m_list[i]).p_SavedScheudleDate := StDate;
end;

//----------------------------------------------------------------------------//
procedure TSCProdGroup.SetEndDate(EndDate: TDateTime);
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  for i := 0 to m_list.Count-1 do
    TSCProdSched(m_list[i]).p_schedEnd := EndDate;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetProgToClose(EndDate: TDateTime);
var
  i : integer;
begin
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  for i := 0 to m_list.Count-1 do
    TSCProdSched(m_list[i]).SetProgToClose(EndDate);
end;

//----------------------------------------------------------------------------//

{function SortGroupCompare(Job1 : TSCProdSched; Job2 : TSCProdSched): integer;
var
  Job1Progress, Job2Progress : integer;
begin
  Job1Progress := 0;
  Job2Progress := 0;
  if (Job1.m_ProgType <> '') and (Job2.m_ProgType = '') then
     Job2Progress := 1;
  if (Job1.m_ProgType = '') and (Job2.m_ProgType <> '') then
     Job1Progress := 1;
  if (Job1.m_ProgType <> '') and (Job2.m_ProgType <> '') and
     (Job1.m_PrgSt <> Job2.m_PrgSt) then
  begin
    if Job1.m_PrgSt > Job2.m_PrgSt then
       Job1Progress := 1
    else
       Job2Progress := 1
  end;

  result := 0;

  if Job1Progress > Job2Progress then
     Result := 1
  else if Job1Progress < Job2Progress then
     Result := -1
  else
  begin
    if Job1.m_Grp_Sequence > Job2.m_Grp_Sequence then
       Result := 1
    else if Job1.m_Grp_Sequence < Job2.m_Grp_Sequence then
       Result := -1
    else
    begin
      if Job1.m_reqDet.m_lowStartTimeLimit > Job2.m_reqDet.m_lowStartTimeLimit then
         Result := 1
      else if Job1.m_reqDet.m_lowStartTimeLimit < Job2.m_reqDet.m_lowStartTimeLimit then
         Result := -1
      else
      begin
        if Job1.m_reqDet.m_hdr.m_code > Job2.m_reqDet.m_hdr.m_code then
           Result := 1
        else if Job1.m_reqDet.m_hdr.m_code < Job2.m_reqDet.m_hdr.m_code then
           Result := -1
        else
        begin
          if Job1.m_reqDet.m_code > Job2.m_reqDet.m_code then
             Result := 1
          else if Job1.m_reqDet.m_code < Job2.m_reqDet.m_code then
             Result := -1
          else
          begin
            if Job1.m_code > Job2.m_code then
               Result := 1
            else if Job1.m_code < Job2.m_code then
               Result := -1
          end;
        end;
      end;
    end;
  end;

end;
//----------------------------------------------------------------------------//

function SortGroupOld(Item1, Item2: Pointer): integer;
var
  Job1 , Job2: TSCProdSched;
begin
  Job1 := TSCProdSched(Item1);
  Job2 := TSCProdSched(Item2);
  result := SortGroupCompare(Job1, Job2);
end; }

//----------------------------------------------------------------------------//

function TSCProdGroup.GetExeMin: double;
var
  i : integer;
  GrpSeqHandled : TStringlist;
  Grp_Sequence  : String;
  StepType : CScSchedType;
  batch_ContinuesTime : boolean;
  StartDateTimeAfterSetup, SchedStartOfJobInContGroup : TDateTime;
  ActArea : TMqmActArea;
  Cal: TPGCALObj;
begin
  Result := 0;
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  GrpSeqHandled := TStringList.Create;
  StepType := TSCProdSched(m_list[0]).m_reqDet.m_stepType;
  batch_ContinuesTime := TSCProdSched(m_list[0]).m_reqDet.m_batch_ContinuesTime;

  if (StepType = CST_Continuous) and batch_ContinuesTime then
  begin
    if not Assigned(m_srvPtr) then
      Exit;
    ActArea := TMqmActArea(m_srvPtr);
    if Assigned(ActArea) then
      Cal := ActArea.GetCalendar;
    if Assigned(Cal) then
    begin
      SchedStartOfJobInContGroup := GetSchedStartOfJobInContGroup;
      cal.OfsByWH(GetSupMinReal/60, true, SchedStartOfJobInContGroup, StartDateTimeAfterSetup, ActArea.m_CrossDownTmList);
      Result := cal.DiffWH(StartDateTimeAfterSetup, GetSchedEndOfJobInContGroup , ActArea.m_CrossDownTmList)*60;
    end;
    Exit;
  end;

  for i := 0 to m_list.Count-1 do
  begin
    if (StepType = CST_Continuous) and not batch_ContinuesTime then
    begin
      Grp_Sequence := TSCProdSched(m_list[I]).m_Grp_Sequence;
      if (Grp_Sequence <> '') then
      begin
        if GrpSeqHandled.IndexOf(Grp_Sequence) <> -1 then continue;
        GrpSeqHandled.add(Grp_Sequence);
      end;
      Result := result + TSCProdSched(m_list[i]).p_ExeMinIgnoreProgress;
      continue;
    end;
    // Batch
    if result < TSCProdSched(m_list[i]).p_ExeMinIgnoreProgress then
       result := TSCProdSched(m_list[i]).p_ExeMinIgnoreProgress;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetExeMinIgnoreProgress: double;
begin
  Result := 0;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetExeMin(ExeMin: double);
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType = CST_batch) or
     TSCProdSched(m_list[0]).m_reqDet.m_batch_ContinuesTime then
  begin
    for i := 0 to m_list.Count-1 do
      TSCProdSched(m_list[i]).p_exeMin := ExeMin;
  end
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.CheckProgressed : boolean;
begin
  Result := false;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetLoadQuantSched(QuantSched: double);
begin

end;

procedure TSCProdGroup.SetProgQtyToDate;
begin

end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetSupMinBase: double;
var
  i: integer;
begin
  Result := 0;
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType <> CST_batch) then
    Result := TSCProdSched(m_list[0]).p_supMinBase
  else
    //Get the highest setup
    for i := 0 to m_list.Count-1 do
      if Result < TSCProdSched(m_list[i]).p_supMinBase then
        Result := TSCProdSched(m_list[i]).p_supMinBase;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetSupMinBase(SupMinBase: double);
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
//  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType = CST_batch) then
    for i := 0 to m_list.Count-1 do
      TSCProdSched(m_list[i]).p_supMinBase := SupMinBase;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetSupMinReal: double;
var
  i: integer;
begin
  Result := 0;
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType <> CST_batch) then
    Result := TSCProdSched(m_list[0]).p_supMinReal
  else
    //Get the highest setup
    for i := 0 to m_list.Count-1 do
      if Result < TSCProdSched(m_list[i]).p_supMinReal then
        Result := TSCProdSched(m_list[i]).p_supMinReal;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetSupMinReal(SupMinReal: double);
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType <> CST_batch) then
    TSCProdSched(m_list[0]).p_supMinReal := SupMinReal
  else
    for i := 0 to m_list.Count-1 do
      TSCProdSched(m_list[i]).p_supMinReal := SupMinReal;
end;

//----------------------------------------------------------------------------//

function SortContinueGroup(Item1, Item2: Pointer): integer;
var
  Job1Progress, Job2Progress : integer;
  Job1 : TSCProdSched;
  Job2 : TSCProdSched;
begin

  Job1 := TSCProdSched(Item1);
  Job2 := TSCProdSched(Item2);

  Job1Progress := 0;
  Job2Progress := 0;
  if (Job1.m_ProgType <> '') and (Job2.m_ProgType = '') then
     Job2Progress := 1;
  if (Job1.m_ProgType = '') and (Job2.m_ProgType <> '') then
     Job1Progress := 1;
  if (Job1.m_ProgType <> '') and (Job2.m_ProgType <> '') and
     (Job1.m_PrgSt <> Job2.m_PrgSt) then
  begin
    if Job1.m_PrgSt > Job2.m_PrgSt then
       Job1Progress := 1
    else
       Job2Progress := 1
  end;

  result := 0;

  if Job1Progress > Job2Progress then
     Result := 1
  else if Job1Progress < Job2Progress then
     Result := -1
  else
  begin
    if Job1.m_reqDet.m_Grp_Sequence > Job2.m_reqDet.m_Grp_Sequence then
       Result := 1
    else if Job1.m_reqDet.m_Grp_Sequence < Job2.m_reqDet.m_Grp_Sequence then
       Result := -1
    else
    begin
      if Job1.m_reqDet.m_lowStartTimeLimit > Job2.m_reqDet.m_lowStartTimeLimit then
         Result := 1
      else if Job1.m_reqDet.m_lowStartTimeLimit < Job2.m_reqDet.m_lowStartTimeLimit then
         Result := -1
      else
      begin

        if Job1.m_GroupAutomaticInternalSortingSequence > Job2.m_GroupAutomaticInternalSortingSequence then
           Result := 1
        else if Job1.m_GroupAutomaticInternalSortingSequence < Job2.m_GroupAutomaticInternalSortingSequence then
           Result := -1
        else
        begin
          if Job1.m_reqDet.m_hdr.m_code > Job2.m_reqDet.m_hdr.m_code then
             Result := 1
          else if Job1.m_reqDet.m_hdr.m_code < Job2.m_reqDet.m_hdr.m_code then
             Result := -1
          else
          begin
            if Job1.m_reqDet.m_code > Job2.m_reqDet.m_code then
               Result := 1
            else if Job1.m_reqDet.m_code < Job2.m_reqDet.m_code then
               Result := -1
            else
            begin
              if Job1.m_code > Job2.m_code then
                 Result := 1
              else if Job1.m_code < Job2.m_code then
                 Result := -1
            end;
          end;

        end;

      end;

    end;
  end;

end;

//----------------------------------------------------------------------------//

function SortBatchGroup(Item1, Item2: Pointer): integer;
begin
  Result := 1
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SortGroup;
var
  PrevSeq : String;
  I : integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
//  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType = CST_batch) then
//    m_list.sort(SortBatchGroup)
  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType = CST_Continuous) then
  begin
    m_list.sort(SortContinueGroup);

    if GetEnableGroupAutomaticInternalSortingSequence then
      for I := 0 to m_list.Count - 1 do
        TSCProdSched(m_list[I]).m_GroupAutomaticInternalSortingSequence := I;

    TSCProdSched(m_list[0]).m_IgnorExeTimeWhenGrp := false;
    PrevSeq := TSCProdSched(m_list[0]).m_reqDet.m_Grp_Sequence;
    for I := 1 to m_list.Count - 1 do
    begin
      if (PrevSeq <> '') and (TSCProdSched(m_list[I]).m_reqDet.m_Grp_Sequence = PrevSeq) then
        TSCProdSched(m_list[I]).m_IgnorExeTimeWhenGrp := true
      else
        TSCProdSched(m_list[I]).m_IgnorExeTimeWhenGrp := false;
      PrevSeq := TSCProdSched(m_list[I]).m_reqDet.m_Grp_Sequence;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetSchedResourceAsProgress(Resource : string);
var
  I : Integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;

  for I := 0 to m_list.Count - 1 do
  begin
    if (TSCProdSched(m_list[I]).m_rscCode <> Resource) then
       TSCProdSched(m_list[I]).m_rscCode := Resource
  end;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetNewSpeed(speed: double);
begin
  // only for contiuoes group
  m_NewSpeed := speed
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetNewSpeed: double;
begin
  result := m_NewSpeed
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetNewSetup(setup: double);
begin
  // only for contiuoes group
  m_NewSetup := setup
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetNewSetup: double;
begin
  result := m_NewSetup
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetNewJobSetup(Setup: double);
begin
  m_NewJobSetup := Setup
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetNewJobSetup: double;
begin
  result := m_NewJobSetup
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetSupMinOvlp: double;
var
  i: integer;
begin
  Result := 0;
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType <> CST_batch) then
    Result := TSCProdSched(m_list[0]).p_supMinOvlp
  else
    //Get the highest setup
    for i := 0 to m_list.Count-1 do
      if Result < TSCProdSched(m_list[i]).p_supMinOvlp then
        Result := TSCProdSched(m_list[i]).p_supMinOvlp;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetSupMinOvlp(SupMinOvlp: double);
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType <> CST_batch) then
    TSCProdSched(m_list[0]).p_supMinOvlp := SupMinOvlp
  else
    for i := 0 to m_list.Count-1 do
      TSCProdSched(m_list[i]).p_supMinOvlp := SupMinOvlp;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetQuantSched: double;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := 0;

  for i := 0 to m_list.Count-1 do
    Result := Result + TSCProdSched(m_list[i]).p_quantSched;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetQuantSched(QuantSched: double);
begin
  //Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  //no possible to set quantity for groups
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetFinalQuant: double;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := 0;

  for i := 0 to m_list.Count-1 do
    Result := Result + TSCProdSched(m_list[i]).p_FinalQuant;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetQtySchdWithoutChg: double;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := 0;

  for i := 0 to m_list.Count-1 do
    Result := Result + TSCProdSched(m_list[i]).p_qtySchdWithoutChg;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetDeliveryDate: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).p_DeliveryDate;
  //Get the lowest delivery date between all jobs
  for i := 1 to m_list.Count-1 do
    if Result > TSCProdSched(m_list[i]).p_DeliveryDate then
      Result := TSCProdSched(m_list[i]).p_DeliveryDate;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetPlannedStrDate: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).p_PlannedStrDate;
  //Get the highest planned start date between all jobs
  for i := 1 to m_list.Count-1 do
    if Result < TSCProdSched(m_list[i]).p_PlannedStrDate then
      Result := TSCProdSched(m_list[i]).p_PlannedStrDate;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetPlannedEndDate: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).p_PlannedEndDate;
  //Get the lowest planned end date between all jobs
  for i := 1 to m_list.Count-1 do
    if Result > TSCProdSched(m_list[i]).p_PlannedEndDate then
      Result := TSCProdSched(m_list[i]).p_PlannedEndDate;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetLowStartDate: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).p_LowStartDate;

  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType = CST_Continuous) then
  begin
    for i := 1 to m_list.Count-1 do
      if TSCProdSched(m_list[i]).p_LowStartDate < Result then
        Result := TSCProdSched(m_list[i]).p_LowStartDate;
  end
  else
  begin
    //Get the highest lowest start date between all jobs
    for i := 1 to m_list.Count-1 do
      if Result < TSCProdSched(m_list[i]).p_LowStartDate then
        Result := TSCProdSched(m_list[i]).p_LowStartDate;
  end;

end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetHighEndDate: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).p_HighEndDate;

  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType = CST_Continuous)
     and (not TSCProdSched(m_list[0]).m_reqDet.m_batch_ContinuesTime) then
  begin
    for i := 1 to m_list.Count-1 do
      if TSCProdSched(m_list[i]).p_HighEndDate > Result then
        Result := TSCProdSched(m_list[i]).p_HighEndDate;
  end
  else
  begin
    //Get the lowest highest end date between all jobs
    for i := 1 to m_list.Count-1 do
      if Result > TSCProdSched(m_list[i]).p_HighEndDate then
        Result := TSCProdSched(m_list[i]).p_HighEndDate;
  end;

end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetHighEndDateTemp: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).p_HighEndDateTemp;
  //Get the lowest highest end date between all jobs
  for i := 1 to m_list.Count-1 do
    if Result > TSCProdSched(m_list[i]).p_HighEndDateTemp then
      Result := TSCProdSched(m_list[i]).p_HighEndDateTemp;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetApprovalDate: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).p_ApprovalDate;
  //Get the highest lowest start date between all jobs
  for i := 1 to m_list.Count-1 do
    if Result < TSCProdSched(m_list[i]).p_ApprovalDate then
      Result := TSCProdSched(m_list[i]).p_ApprovalDate;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetMatArrDate: TDateTime;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := TSCProdSched(m_list[0]).p_MatArrDate;
  //Get the highest material arrival end date between all jobs
  for i := 1 to m_list.Count-1 do
    if Result < TSCProdSched(m_list[i]).p_MatArrDate then
      Result := TSCProdSched(m_list[i]).p_MatArrDate;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetMinIdInGroup : TSchediD;
var
  I : Integer;
begin
  Result := TSCProdSched(m_list[0]).m_id;
  for I := 1 to m_list.Count - 1 do
  begin
    if TSCProdSched(m_list[i]).m_id < Result then
      Result := TSCProdSched(m_list[i]).m_id;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetMinMatArrDate(ResPtr: pointer; ProdNature: SetArProdNature; var NoAvailList: TList;
                      PrmSupMinBase, PrmDur, PrmSetupNeedMat : double; ByProduct : boolean) : Tlist;
var
  i: integer;
  Res: TMQMRes;
  VisRes : TMQMVisibleRes;
  components, ResComp : integer;
  TmgDescr, TmgMSC : string;
  MatDateTime : TDateTime;
  SupMinBase, Duration : double;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Res := TMQMRes(ResPtr);
  VisRes := TMqmVisibleRes(res.p_VisRes[0]);
  if PrmDur >= 0 then
  begin
    SupMinBase := PrmSupMinBase;
    Duration := PrmDur;
  end
  else
  begin
    components := 1;
    p_pl.SetTmgTargetRes(Res);
    p_pl.GetMainTimings(supMinBase, Duration, TmgDescr, TmgMSC);
    if Res.p_isMultiRes then
    begin
      if p_sc.GetRscComponentFromJobOrStep(m_id) > 0 then
        ResComp := p_sc.GetRscComponentFromJobOrStep(m_id)
      else
        ResComp := Res.p_ResComp;
      components := ResComp;
    end;
   // CalcDur(m_Id, Duration, components);
  end;

  Result := TSCProdSched(m_list[0]).GetMinMatArrDate(ResPtr, ProdNature, NoAvailList, SupMinBase, Duration, PrmSetupNeedMat, ByProduct);
  //Get the highest material arrival end date between all jobs
//  for i := 1 to m_list.Count-1 do
//    MatDateTime := TSCProdSched(m_list[i]).GetMinMatArrDate(ResPtr, ProdNature, NoAvailList, AddResEndSetUpNoMat, AddResEndSetUp, AddResEndExec, AddResStartSetUpNoMat, AddResStartSetUp, AddResStartExec,
//                                                         SupMinBase, Duration, PrmSetupNeedMat);
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.GetStepBalanceLimits(VisResPtr: pointer; out LowLimit, HighLimit: TDateTime; OvlpChk : TypeOvlpChk; Setup, Duration : double);
var
  i: integer;
  TmpLeftDate, TmpRightDate: TDateTime;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  LowLimit  := 0;
  HighLimit := 0;

  TSCProdSched(m_list[0]).GetStepBalanceLimits(VisResPtr, LowLimit, HighLimit, OvlpChk, Setup, Duration);
  //Get the highest material arrival end date between all jobs
  for i := 1 to m_list.Count-1 do
  begin
 //   LowLimit  := 0;
 //   HighLimit := 0;
    TSCProdSched(m_list[i]).GetStepBalanceLimits(VisResPtr, TmpLeftDate, TmpRightDate, OvlpChk, Setup, Duration);
    if (TmpLeftDate > 0) and (TmpLeftDate > LowLimit) then
      LowLimit := TmpLeftDate;
    if (TmpRightDate > 0) and (TmpRightDate < HighLimit) then
      HighLimit := TmpRightDate;
  end;

end;

//----------------------------------------------------------------------------//

function TSCProdGroup.CheckEnoughMatAtDateMain(ApaPtr: pointer; ProdNature: SetArProdNature;
                              StrDate: TDateTime; var ListMatNotAvail: TList; var ListOfLeadTime: TList): boolean;
type
 TMaterialsAlreadyChecked = record
   ArtType       : String;
   NetGroupCode  : String;
   ArtCode       : String;
 end;
 PTMaterialsAlreadyChecked = ^TMaterialsAlreadyChecked;
var
  i: integer;
  MaterialsAlreadyChecked : Tlist;
  CheckForTheGroup : boolean;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := true;

  if (TSCProdSched(m_list[0]).m_reqDet.m_stepType = CST_Continuous)
  and (not TSCProdSched(m_list[0]).m_reqDet.m_batch_ContinuesTime)
  and (not TSCProdSched(m_list[0]).m_reqDet.m_Continues_Parallel) then
  begin
    CheckForTheGroup := false;
    MaterialsAlreadyChecked := nil;
  end
  else
  begin
    CheckForTheGroup := true;
    MaterialsAlreadyChecked := Tlist.Create;
  end;

  for i := 0 to m_list.Count-1 do
  begin
    if not TSCProdSched(m_list[i]).CheckEnoughMatAtDate(ApaPtr, ProdNature, StrDate, ListMatNotAvail, ListOfLeadTime, MaterialsAlreadyChecked, CheckForTheGroup) then
    begin
      Result := false;
      break
    end;
  end;

  if CheckForTheGroup then
  begin
    for i := 0 to MaterialsAlreadyChecked.Count-1 do
      Dispose(PTMaterialsAlreadyChecked(MaterialsAlreadyChecked[i]));
    MaterialsAlreadyChecked.Free;
  end;

end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetQuantManualChg(ManualChange: double);
begin
  //Nothing to implement - gets the manual change from the job
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetQuantManualChg: double;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := 0;

  for i := 1 to m_list.Count-1 do
    Result := Result + TSCProdSched(m_list[0]).p_quantManualChg;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.SetQtyChgSchedNet(ManualChange: double);
begin
  //Nothing to implement - gets the manual change from the job
end;

//----------------------------------------------------------------------------//

function TSCProdGroup.GetQtyChgSchedNet: double;
var
  i: integer;
begin
//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  Result := 0;

  for i := 1 to m_list.Count-1 do
    Result := Result + TSCProdSched(m_list[0]).p_qtyChgSchedNet;
end;


//----------------------------------------------------------------------------//

procedure TSCProdGroup.UpdateBalanceEntries(VisResPtr: pointer; CalcMat : boolean);
var
  sc: TSCProdSched;
  i : integer;
begin
  // Warning!!! this procedure is made in this way only for ARO.
  // I think must be changed for standard version...
  // See Appendix B page 15 - fp

//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  for i := 0 to m_list.Count -1 do
  begin
    sc := TSCProdSched(m_list[i]);
    sc.UpdateBalanceEntries(VisResPtr, CalcMat);
  end;
end;

//----------------------------------------------------------------------------//

procedure TSCProdGroup.UpdateBalanceIssues(VisResPtr: pointer; CalcMat : boolean);
var
  sc: TSCProdSched;
  i : integer;
begin
  // Warning!!! this procedure is made in this way only for ARO.
  // I think must be changed for standard version...
  // See Appendix C page 19 - fp

//  Assert(m_list.count > 0);
  if (not assigned(m_list)) or (m_list.count = 0) then exit;
  for i := 0 to m_list.Count -1 do
  begin
    sc := TSCProdSched(m_list[i]);
    sc.UpdateBalanceIssues(VisResPtr, CalcMat);
  end;
end;


//----------------------------------------------------------------------------//
// TSCProdSched
//----------------------------------------------------------------------------//

constructor TSCProdSched.Create;
begin
  inherited Create;
  m_fromPD  := true;
  m_NewSetup := -1;
  m_srvPtr  := nil;
  m_grp     := nil;
  m_grpRemovedReason := '';
  m_deleteReason := '';
  m_reqDet  := nil;
  m_mtr     := nil;
  m_HaltedTime := 0;
  m_Backup_Saved := false;
  m_CurveCodeOccToOcc := '';
  m_SavedMachineCode_AUTOSEQ := '';
  m_SavedScheduledDateTime_AUTOSEQ := 0;
  m_ActualStartDate_ORIGINAL := 0;
  m_ActualEndDate_ORIGINAL   := 0;
  m_GroupAutomaticInternalSortingSequence := 0;
  m_ProdSched_ID_FromDatabase := -1
end;

//----------------------------------------------------------------------------//

destructor TSCProdSched.Destroy;
begin
  inherited Destroy
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetStrId: string;
begin
  Result := _('Job') + ' ';

  if not Assigned(m_reqDet) then
    Result := Result + _('detail data not found')
  else if not Assigned(m_reqDet.m_hdr) then
    Result := Result + _('header data not found')
  else
    Result := m_reqDet.m_hdr.m_code +
              ' - ' + _('Step') + ' ' + IntToStr(m_reqDet.m_code) +
              ' - ' + _('Sub step') + ' ' + IntToStr(m_code) +
              ' - ' + _('Reprocess') + ' ' + IntTostr(m_reprocNo);
end;
//----------------------------------------------------------------------------//

function TSCProdSched.GetBarStr(isJobBar:boolean; LineNumber : Integer): string;
begin
  result := getBarString(GetWorkCenter,self,false, isJobBar, LineNumber);
end;

function TSCProdSched.GetLineNum(isJobBar:boolean): Integer;
begin
   result := getLineNumber(GetWorkCenter, isJobBar);
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetWorkCenter : string;
begin
  Result := m_PlanWkCtrCode;
  if Trim(m_PlanWkCtrCode) = '' then
    Result := m_reqDet.m_planWkctr;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetWorkCenter(Wc: String);
begin
  m_PlanWkCtrCode := Wc;
  if (Wc = '') or (Wc = ' ') then m_ChangedWkCtr := nil;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetWrkCtrPtr : pointer;
begin
  if Assigned(m_ChangedWkCtr) then
    Result := m_ChangedWkCtr
  else
    Result := m_reqDet.m_PlanWrkCtrPtr;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.ClearBalance;
var
  i, z : integer;
  ProdArt: PTProdArt;
  IssuedArt: PTIssuedArt;
  MacSetup: TMQMMachineSetup;
begin
  m_reqDet.m_hdr.m_RequestBalList.ClearBalanceForJob(m_Id);

  for i := 0 to m_reqDet.m_hdr.m_ProdArtList.p_count - 1 do
  begin
    ProdArt := PTProdArt(m_reqDet.m_hdr.m_ProdArtList.p_Item[i]);
//    ProdArt.NetGroup.m_BalanceList.ClearBalanceForJob(m_Id);
    ProdArt.NetGroup.ClearBalanceForJob(m_Id);
  end;

  for i := 0 to m_reqDet.m_MacSetupList.p_count - 1 do
  begin
    MacSetup := m_reqDet.m_MacSetupList.p_Item[i];
    for z := 0 to MacSetup.m_IssuedArtList.p_count -1 do
    begin
      IssuedArt := PTIssuedArt(MacSetup.m_IssuedArtList.p_Item[z]);
//      IssuedArt.NetGroup.m_BalanceList.ClearBalanceForJob(m_Id);
      if assigned(IssuedArt) and assigned(IssuedArt.NetGroup) then
        IssuedArt.NetGroup.ClearBalanceForJob(m_Id);
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.GetStepBalanceLimits(VisResPtr: pointer; out LowLimit, HighLimit: TDateTime; OvlpChk : TypeOvlpChk; Setup, Duration : double);
var
//  JobsLowLimitList, JobsHighLimitList : TMSchedList;
  ResBatchType : boolean;
  OvlRules: TMQMOvlpRule;
  Res: TMqmRes;
  isDefault, CalcMat: boolean;
  LowLimitWithoutLeadTime, HighLimitWithoutLeadTime, ExpireDateHighLimit, ExpireDateLowLimit : TDateTime;
begin
  CalcMat := false;
//  if Assigned(m_srvPtr) then CalcMat := true;  // ERAN19101963 - Only overlap check is needed
  UpdateBalance(VisResPtr, CalcMat);
  LowLimit := GetOvlpLowLimit(VisResPtr, OvlpChk, setup, Duration, ExpireDateHighLimit);
  HighLimit := GetOvlpHighLimit(VisResPtr,OvlpChk, setup, Duration, ExpireDateLowLimit);
  if (ExpireDateLowLimit > 0) and (ExpireDateLowLimit > LowLimit) then
  begin
    LowLimit := ExpireDateLowLimit;
    m_MinOvlpDate := ExpireDateLowLimit;
  end;
  if (ExpireDateHighLimit > 0) and ((HighLimit = 0) or (ExpireDateHighLimit < HighLimit)) then
  begin
    HighLimit := ExpireDateHighLimit;
    m_MaxOvlpDate := ExpireDateHighLimit;
  end;

  Res := TMqmRes(TMqmVisibleRes(VisResPtr).p_Father);
  ResBatchType := Res.p_ProcessType = CST_batch;
  OvlRules := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);

{  Cal := nil;
  if (trim(m_reqDet.m_calCod) <> '') then
    Cal := ObjPGCAL_ByKey(m_reqDet.m_calCod, TPGCALObjMqm);   }

  if (GetPrevStepToSched(m_reqDet.m_code) = nil) then
  begin
    LowLimitWithoutLeadTime := 0;
    CheckPrevConnReqLastStepJobs(LowLimit, LowLimitWithoutLeadTime, true,OvlRules,ResBatchType);
    {JobsLowLimitList := TMSchedList.Create(Self);
    p_sc.GetPrevConnReqLastStepJobs(m_id, JobsLowLimitList);
    for i := 0 to JobsLowLimitList.GetLinkCount - 1 do
    begin
      HighestEnd := JobsLowLimitList.GetEndDate(i);
      if HighestEnd > 0 then
      begin
        p_sc.CanOverLap(JobsLowLimitList.GetLink(i),WaitEntirePrvQty,CanDeliverPartial,LeadTimePrev,LeadTimeNext);
        if (not CanDeliverPartial) or (ResBatchType) or (OvlRules.m_WaitEntirePrvQty) then
        begin
          SumLeadTime := LeadTimeNext + (m_quantSched*p_LeadTimePrev/24/60);
          if SumLeadTime > 0 then
          begin
            if Assigned(Cal) then
              cal.OfsByWH(SumLeadTime * 24, true, HighestEnd, HighestEnd, nil)
            else
              HighestEnd := HighestEnd + SumLeadTime;
          end;
          RoundDateTime(HighestEnd);
          if ((HighestEnd > LowLimit) or (LowLimit = 0)) then LowLimit := HighestEnd;
        end;
      end;
    end;
    JobsLowLimitList.Free; }
  end;

  if (GetNextStepToSched(m_reqDet.m_code) = nil) then
  begin
    HighLimitWithoutLeadTime := 0;
    CheckConnReqFirstStepJobs(HighLimit,HighLimitWithoutLeadTime,true,OvlRules,ResBatchType);
   { JobsHighLimitList := TMSchedList.Create(Self);
    p_sc.GetNextConnReqFirstStepJobs(m_id, JobsHighLimitList);
    for i := 0 to JobsHighLimitList.GetLinkCount - 1 do
    begin
      LowestStart := JobsHighLimitList.GetStartDate(i);
      if LowestStart > 0 then
      begin
        p_sc.CanOverLap(JobsHighLimitList.GetLink(i),WaitEntirePrvQty,CanDeliverPartial,LeadTimePrev,LeadTimeNext);
        if WaitEntirePrvQty or (ResBatchType) or (not OvlRules.m_CanDeliverPartial) then
        begin
          SumLeadTime := LeadTimePrev - (m_quantSched*p_LeadTimeNext/24/60);
          if SumLeadTime > 0 then
          begin
            if Assigned(Cal) then
              cal.OfsByWH(-(SumLeadTime)*24, false, LowestStart, LowestStart, nil)
            else
              LowestStart := LowestStart - SumLeadTime;
          end;
          RoundDateTime(LowestStart);
          if ((LowestStart < HighLimit) or (HighLimit = 0)) then HighLimit := LowestStart;
        end;
      end;
    end;
    JobsHighLimitList.Free;   }
  end;

 // if LowLimit > 0 then
 //    LowLimit := LowLimit + m_quantSched*p_LeadTimePrev/24/60;

 // if HighLimit > 0 then
 //    HighLimit := HighLimit - m_quantSched*p_LeadTimeNext/24/60;

  UpdateBalance(nil, CalcMat);
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.CheckPrevConnReqLowestStart(var LowLimit : TDateTime; var LowLimit_WithoutLeadTime : TDateTime; IncludOvrlRules : boolean; OvlRules: TMQMOvlpRule; ResBatchType : boolean);
var
  I : Integer;
  JobsLowLimitList : TMSchedList;
//  HighestEnd, HighestEnd_WithoutLeadTime : TDateTime;
  LowestStart, Loweststart_WithoutLeadTime : TDateTime;
  WaitEntirePrvQty,CanDeliverPartial : boolean;
  LeadTimePrev, LeadTimeNext, LeadTimePrevBatch, LeadTimeNextBatch, SumLeadTime : double;
  dataType: CBinColValType;
  FieldVal : variant;
begin
  LeadTimePrev := 0;
  LeadTimeNext := 0;

  JobsLowLimitList := TMSchedList.Create(Self);
  p_sc.GetPrevConnReqLastStepJobs(m_id, JobsLowLimitList);
  for i := 0 to JobsLowLimitList.GetLinkCount - 1 do
  begin
   // HighestEnd := JobsLowLimitList.GetEndDate(i);
   // HighestEnd_WithoutLeadTime := HighestEnd;

    Loweststart := JobsLowLimitList.GetStartDate(i);
   // HighestEnd_WithoutLeadTime := HighestEnd;


    //if HighestEnd > 0 then
    if Loweststart > 0 then
    begin

   //   if IncludOvrlRules then
   //     p_sc.CanOverLap(JobsLowLimitList.GetLink(i),WaitEntirePrvQty,CanDeliverPartial,LeadTimePrev,LeadTimeNext);

      if (not IncludOvrlRules) or (not CanDeliverPartial) or (ResBatchType) or (OvlRules.m_WaitEntirePrvQty) then
      begin

        LeadTimePrev := m_reqDet.p_LeadTimePrev;
        LeadTimeNext := p_sc.GetLeadTimeNextForId(JobsLowLimitList.GetLink(i));
        LeadTimePrevBatch := m_reqDet.p_LeadTimePrevBatch;
        LeadTimeNextBatch := p_sc.GetLeadTimeNextForIdBatch(JobsLowLimitList.GetLink(i));

        p_sc.GetFldValue(JobsLowLimitList.GetLink(i), CSC_QtyToSched, FieldVal, dataType);

        SumLeadTime := ((LeadTimeNext*FieldVal) + (LeadTimePrev*m_quantSched) + (LeadTimePrevBatch) + (LeadTimeNextBatch)) / 24 / 60;
        if SumLeadTime > 0 then
        begin
         // HighestEnd := HighestEnd + SumLeadTime;
          Loweststart := Loweststart + SumLeadTime;
        end;

      end;

{      RoundDateTime(HighestEnd);
      if ((HighestEnd > LowLimit) or (LowLimit = 0)) then LowLimit := HighestEnd;

      RoundDateTime(HighestEnd_WithoutLeadTime);
      if ((HighestEnd_WithoutLeadTime > LowLimit_WithoutLeadTime) or (LowLimit_WithoutLeadTime = 0)) then LowLimit_WithoutLeadTime := HighestEnd_WithoutLeadTime;  }

      RoundDateTime(Loweststart);
      if ((Loweststart < LowLimit) or (LowLimit = 0)) then LowLimit := Loweststart;

      RoundDateTime(Loweststart_WithoutLeadTime);
      if ((Loweststart_WithoutLeadTime > LowLimit_WithoutLeadTime) or (LowLimit_WithoutLeadTime = 0)) then LowLimit_WithoutLeadTime := Loweststart_WithoutLeadTime;



    end;
  end;
  JobsLowLimitList.Free;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.CheckPrevConnReqLastStepJobs(var LowLimit : TDateTime; var LowLimit_WithoutLeadTime : TDateTime; IncludOvrlRules : boolean; OvlRules: TMQMOvlpRule; ResBatchType : boolean);
var
  I : Integer;
  JobsLowLimitList : TMSchedList;
  HighestEnd, HighestEnd_WithoutLeadTime : TDateTime;
  WaitEntirePrvQty,CanDeliverPartial : boolean;
  LeadTimePrev, LeadTimeNext, LeadTimePrevBatch, LeadTimeNextBatch, SumLeadTime : double;
  dataType: CBinColValType;
  FieldVal : variant;
begin
  LeadTimePrev := 0;
  LeadTimeNext := 0;

  JobsLowLimitList := TMSchedList.Create(Self);
  p_sc.GetPrevConnReqLastStepJobs(m_id, JobsLowLimitList);
  for i := 0 to JobsLowLimitList.GetLinkCount - 1 do
  begin
    HighestEnd := JobsLowLimitList.GetEndDate(i);
    HighestEnd_WithoutLeadTime := HighestEnd;

    if HighestEnd > 0 then
    begin

      //if IncludOvrlRules then
      //  p_sc.CanOverLap(JobsLowLimitList.GetLink(i),WaitEntirePrvQty,CanDeliverPartial,LeadTimePrev,LeadTimeNext);

      if (not IncludOvrlRules) or (not CanDeliverPartial) or (ResBatchType) or (OvlRules.m_WaitEntirePrvQty) then
      begin

        LeadTimePrev := m_reqDet.p_LeadTimePrev;
        LeadTimeNext := p_sc.GetLeadTimeNextForId(JobsLowLimitList.GetLink(i));
        LeadTimePrevBatch := m_reqDet.p_LeadTimePrevBatch;
        LeadTimeNextBatch := p_sc.GetLeadTimeNextForIdBatch(JobsLowLimitList.GetLink(i));

        p_sc.GetFldValue(JobsLowLimitList.GetLink(i), CSC_QtyToSched, FieldVal, dataType);

        SumLeadTime := ((LeadTimeNext*FieldVal) + (LeadTimePrev*m_quantSched) + (LeadTimePrevBatch) + (LeadTimeNextBatch)) / 24 / 60;
        if SumLeadTime > 0 then
        begin
          HighestEnd := HighestEnd + SumLeadTime;
        end;

      end;

      RoundDateTime(HighestEnd);
      if ((HighestEnd > LowLimit) or (LowLimit = 0)) then LowLimit := HighestEnd;

      RoundDateTime(HighestEnd_WithoutLeadTime);
      if ((HighestEnd_WithoutLeadTime > LowLimit_WithoutLeadTime) or (LowLimit_WithoutLeadTime = 0)) then LowLimit_WithoutLeadTime := HighestEnd_WithoutLeadTime;

    end;
  end;
  JobsLowLimitList.Free;

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.CheckConnReqHighestEnd(var HighLimit : TDatetime; var HighLimit_WithoutLeadTime : TDatetime; IncludOvrlRules : boolean; OvlRules: TMQMOvlpRule; ResBatchType : boolean);
var
  I : Integer;
  JobsHighLimitList : TMSchedList;
//  LowestStart, LowestStart_WithoutLeadTime : TDateTime;
  HighestEnd, HighestEnd_WithoutLeadTime : TDateTime;
  WaitEntirePrvQty,CanDeliverPartial : boolean;
  LeadTimePrev, LeadTimeNext, LeadTimePrevBatch, LeadTimeNextBatch, SumLeadTime : double;
  dataType: CBinColValType;
  FieldVal : variant;
begin
  LeadTimePrev := 0;
  LeadTimeNext := 0;

  JobsHighLimitList := TMSchedList.Create(Self);
  p_sc.GetNextConnReqFirstStepJobs(m_id, JobsHighLimitList);
  for i := 0 to JobsHighLimitList.GetLinkCount - 1 do
  begin
   // LowestStart := JobsHighLimitList.GetStartDate(i);
   // LowestStart_WithoutLeadTime := LowestStart;

    HighestEnd := JobsHighLimitList.GetEndDate(i);
    HighestEnd_WithoutLeadTime := HighestEnd;

  //  if LowestStart > 0 then
    if HighestEnd > 0 then
    begin

     // if IncludOvrlRules then
     //   p_sc.CanOverLap(JobsHighLimitList.GetLink(i),WaitEntirePrvQty,CanDeliverPartial,LeadTimePrev,LeadTimeNext);

      if (not IncludOvrlRules) or (not CanDeliverPartial) or (ResBatchType) or (OvlRules.m_WaitEntirePrvQty) then
      begin

        LeadTimeNext := m_reqDet.p_LeadTimeNext;
        LeadTimePrev := p_sc.GetLeadTimePrevForId(JobsHighLimitList.GetLink(i));
        LeadTimeNextBatch := m_reqDet.p_LeadTimeNextBatch;
        LeadTimePrevBatch := p_sc.GetLeadTimePrevForIdBatch(JobsHighLimitList.GetLink(i));
        p_sc.GetFldValue(JobsHighLimitList.GetLink(i), CSC_QtyToSched, FieldVal, dataType);

        SumLeadTime := ((LeadTimePrev*FieldVal) + (LeadTimeNext*m_quantSched) + LeadTimeNextBatch + LeadTimePrevBatch) / 24 / 60;
        if SumLeadTime > 0 then
        begin
         // LowestStart := LowestStart - SumLeadTime;
          HighestEnd := HighestEnd - SumLeadTime;
        end;

      end;

{      RoundDateTime(LowestStart);
      if ((LowestStart < HighLimit) or (HighLimit = 0)) then HighLimit := LowestStart;

      RoundDateTime(LowestStart_WithoutLeadTime);
      if ((LowestStart_WithoutLeadTime < HighLimit_WithoutLeadTime) or (HighLimit_WithoutLeadTime = 0)) then HighLimit_WithoutLeadTime := LowestStart_WithoutLeadTime; }

      RoundDateTime(HighestEnd);
      if ((HighestEnd > HighLimit) or (HighLimit = 0)) then HighLimit := HighestEnd;

      RoundDateTime(HighestEnd_WithoutLeadTime);
      if ((HighestEnd_WithoutLeadTime < HighLimit_WithoutLeadTime) or (HighLimit_WithoutLeadTime = 0)) then HighLimit_WithoutLeadTime := HighestEnd_WithoutLeadTime;


    end;
  end;
  JobsHighLimitList.Free;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.CheckConnReqFirstStepJobs(var HighLimit : TDatetime; var HighLimit_WithoutLeadTime : TDatetime; IncludOvrlRules : boolean; OvlRules: TMQMOvlpRule; ResBatchType : boolean);
var
  I : Integer;
  JobsHighLimitList : TMSchedList;
  LowestStart, LowestStart_WithoutLeadTime : TDateTime;
  WaitEntirePrvQty,CanDeliverPartial : boolean;
  LeadTimePrev, LeadTimeNext, LeadTimePrevBatch, LeadTimeNextBatch, SumLeadTime : double;
  dataType: CBinColValType;
  FieldVal : variant;

//  Cal: TPGCALObj;
begin
  LeadTimePrev := 0;
  LeadTimeNext := 0;

  JobsHighLimitList := TMSchedList.Create(Self);
  p_sc.GetNextConnReqFirstStepJobs(m_id, JobsHighLimitList);
  for i := 0 to JobsHighLimitList.GetLinkCount - 1 do
  begin
    LowestStart := JobsHighLimitList.GetStartDate(i);
    LowestStart_WithoutLeadTime := LowestStart;

    if LowestStart > 0 then
    begin

     // if IncludOvrlRules then
     //   p_sc.CanOverLap(JobsHighLimitList.GetLink(i),WaitEntirePrvQty,CanDeliverPartial,LeadTimePrev,LeadTimeNext);

      if (not IncludOvrlRules) or (not CanDeliverPartial) or (ResBatchType) or (OvlRules.m_WaitEntirePrvQty) then
      begin

        LeadTimeNext := m_reqDet.p_LeadTimeNext;
        LeadTimePrev := p_sc.GetLeadTimePrevForId(JobsHighLimitList.GetLink(i));
        LeadTimeNextBatch := m_reqDet.p_LeadTimeNextBatch;
        LeadTimePrevBatch := p_sc.GetLeadTimePrevForIdBatch(JobsHighLimitList.GetLink(i));
        p_sc.GetFldValue(JobsHighLimitList.GetLink(i), CSC_QtyToSched, FieldVal, dataType);

        SumLeadTime := ((LeadTimePrev*FieldVal) + (LeadTimeNext*m_quantSched) + LeadTimeNextBatch + LeadTimePrevBatch) / 24 / 60;
        if SumLeadTime > 0 then
        begin
          LowestStart := LowestStart - SumLeadTime;
        end;

      end;

      RoundDateTime(LowestStart);
      if ((LowestStart < HighLimit) or (HighLimit = 0)) then HighLimit := LowestStart;

      RoundDateTime(LowestStart_WithoutLeadTime);
      if ((LowestStart_WithoutLeadTime < HighLimit_WithoutLeadTime) or (HighLimit_WithoutLeadTime = 0)) then HighLimit_WithoutLeadTime := LowestStart_WithoutLeadTime;


    end;
  end;
  JobsHighLimitList.Free;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.CanOverLap(var WaitEntirePrvQty : boolean; var CanDeliverPartial : boolean ; var LeadTimePrev : double ; var LeadTimeNext : double);
var
  Res : TMQMRes;
  OvlpRule : TMQMOvlpRule;
  isDefault : boolean;
begin
  WaitEntirePrvQty := true;
  CanDeliverPartial := false;

  LeadTimePrev := (m_quantSched*m_reqDet.p_LeadTimePrev + m_reqDet.p_LeadTimePrevBatch) /24/60;
  LeadTimeNext := (m_quantSched*m_reqDet.p_LeadTimeNext + m_reqDet.p_LeadTimeNextBatch) /24/60;

  Res := TMQMRes(TMQMActArea(m_srvPtr).p_Res);
  if (Res.p_ProcessType <> CST_batch) then
  begin
    OvlpRule := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);
    if assigned(OvlpRule) then
    begin
      WaitEntirePrvQty := OvlpRule.m_WaitEntirePrvQty;
      CanDeliverPartial := OvlpRule.m_CanDeliverPartial;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetOvlpLowLimit(VisResPtr: pointer; OvlpChk : TypeOvlpChk; RealSetup, Duration : double; out ExpireDateHighLimit : TDateTime): TDateTime;
var
  Descr : string;
  MSC, DummyStr : string;
  PrecStep: TSCProdReqDet;
  BalRec: PTReqBalance;
  i, pos : Integer;
  Temp1,Temp2 : currency;
  NegativeBalance : double;
  StartQty: Double;
  Res : TMQMRes;
  Execution, Setup : double;
  DurAlreadyCalculated, CurveAlreadyCalculated : double;
  LastBalancePointDate, TmpDate, FirstExpirationDate, LastExpirationDate : TdateTime;
  SecondsDifference : LongInt;
  DateDirection, ResComp : Integer;
  prevID : TSchedId;
  ActArea : TMqmActArea;
  overlap, DummyDbl1, DummyDbl2 : double;
  scP : TSCProdSched;
  LearningCurveCode : string;
  Cal: TPGCALObj;

  //--------

  procedure CheckBalanceForDate(Date: TDateTime; Setup, Execution : double; var NegativeBalance: double);
  var
    i1 : integer;
    IDBalRec: PTReqBalance;
    NegativeQuantity: Double;
    TmpQty: Double;
  begin
    if OvlpChk = OvlpChk_OnSchedPoint then
       CalculateIssuesPrevStep(VisResPtr, Date, false, true, Setup, Execution, TmpQty)
    else
       CalculateIssuesPrevStep(VisResPtr, Date, false, false, Setup, Execution, TmpQty);

    for i1 := 0 to m_reqDet.m_hdr.m_RequestBalList.p_count-1 do
    begin
      IDBalRec := (m_reqDet.m_hdr.m_RequestBalList.p_Item[i1]);
      if (IDBalRec.JobID = m_id) then continue;
      if (IDBalRec.Step <> PrecStep.m_code) then continue;
      AddToBalancePoints(IDBalRec.JobID, IDBalRec.BalanceType, IDBalRec.DueDate, IDBalRec.Quantity);
    end;
    SortBalancePoints;
    if OvlpChk = OvlpChk_OnSchedPoint then
      FindNegativeBalance(m_id, Cbm_JobEntriesOnly, NegativeQuantity, false)
    else
      FindNegativeBalance(m_id, Cbm_FromFirstJobEntry, NegativeQuantity, false);
    NegativeBalance := NegativeQuantity;
  end;

begin
  Result := 0;
  BalRec := nil;
  ExpireDateHighLimit := 0;

  if (m_srvPtr <> nil) and (RealSetup = -1) then
  begin
    ActArea := TMqmActArea(m_srvPtr);
    prevID := ActArea.GetPrecObj(m_schedStart , m_id);
    if prevID <> CSchedIDnull then
    begin
      CalcSetup(m_id, prevID, actArea , p_supMinBase, RealSetup, overlap, DummyStr, DummyDbl1, DummyDbl2, LearningCurveCode);
      RealSetup := RealSetup - overlap;
    end;
  end;

  PrecStep := GetPrevStepToSched(m_reqDet.m_code);
  if not Assigned(PrecStep) then exit;
  if not Assigned(m_reqDet.m_PlanWrkCtrPtr) then exit;

  if m_reqDet.p_OverlapWithOtherSteps
  or not PrecStep.CheckJobsOnPlan(nil)
  or not Assigned(PrecStep.m_PlanWrkCtrPtr)
  or PrecStep.p_OverlapWithOtherSteps then
  begin
    PrecStep := m_reqDet;

    if m_reqDet.p_OverlapWithOtherSteps and (m_reqDet.p_ResOccupation <> CSResOcc_Border) then
    begin
      while true do
      begin
        PrecStep := GetPrevStepToSched(PrecStep.m_code);
        if not Assigned(PrecStep) then exit;
        if not Assigned(PrecStep.m_PlanWrkCtrPtr) then continue;
        if not PrecStep.CheckJobsOnPlan(nil) then continue;
        if PrecStep.p_OverlapWithOtherSteps then continue;
        for I := 0 to PrecStep.m_list.Count - 1 do
        begin
          scP := TSCProdSched(PrecStep.m_list[i]);
          if (scP.p_rscCode = '') then continue;
          if Result = 0 then
            result := scP.p_schedEnd
          else if (result < scP.p_schedEnd) then
            result := scP.p_schedEnd;
        end;
        m_MinOvlpDate := result;
        break;
      end;
      exit;
    end;

    while true do
    begin
      PrecStep := GetPrevStepToSched(PrecStep.m_code);
      if not Assigned(PrecStep) then exit;
      if not Assigned(PrecStep.m_PlanWrkCtrPtr) then continue;
      if not PrecStep.CheckJobsOnPlan(nil) then continue;
      if (m_reqDet.p_ResOccupation = CSResOcc_Border)
      and (PrecStep.p_ResOccupation = CSResOcc_Occupy) then continue;
      for I := 0 to PrecStep.m_list.Count - 1 do
      begin
        scP := TSCProdSched(PrecStep.m_list[i]);
        if (scP.p_rscCode = '') then continue;
        if Result = 0 then
          result := scP.p_schedEnd
        else if (result < scP.p_schedEnd) then
          result := scP.p_schedEnd;
      end;
      m_MinOvlpDate := result;
      if not PrecStep.p_OverlapWithOtherSteps then break;
    end;

    exit;
  end;

  m_reqDet.m_hdr.m_RequestBalList.SortBalanceList;
  m_reqDet.m_hdr.m_RequestBalList.UpdateBalanceTotals(PrecStep.m_code, m_id);

  if OvlpChk = OvlpChk_OnSchedPoint then
  begin
    CheckBalanceForDate(p_StartWithMat, m_supMinReal - m_supMinOvlp, p_exeMin, negativebalance);
    if (negativebalance > 0) then Result := 999999;
    exit;
  end;

  // Get the correct setup and execution time for that job on the resource checked
  Res := TMqmRes(TMQMVisibleRes(VisResPtr).p_father);
  if (Duration >=0) then
    Execution := Duration
  else
  begin
    if assigned(m_grp) and (m_reqDet.m_stepType = CST_Continuous) and (TSCProdGroup(m_grp).m_id = p_pl.GetCompatModeInPlanId) then
      Execution := UpdContGrpTimingsForSingleJob(TSCProdGroup(m_grp).m_id, m_id, Res, VisResPtr, setup)
    else
    begin
      p_pl.SetTmgTargetRes(Res);
      p_pl.GetMainTimings(Setup, Execution, Descr, MSC);

      if p_sc.GetRscComponentFromJobOrStep(m_id) > 0 then
        ResComp := p_sc.GetRscComponentFromJobOrStep(m_id)
      else
        ResComp := TMQMVisibleRes(VisResPtr).p_ResComp;
      if (ResComp > 0)  then
        execution := execution / ResComp;
      if (m_reqDet.m_stepType <> CST_batch) then
        execution := execution * (p_qtyChgSchedNet / m_reqDet.m_quantInit);
    end;
  end;
  if RealSetup >= 0 then
    setup := RealSetup;

  // Find the starting quantity
  CalculateIssuesPrevStep(VisResPtr, now, false, false, Setup, Execution, StartQty);
  if StartQty = 0 then exit; // no net
  Temp2 := StartQty;

  // Search from the balance of starting quantity, where there is enough quantity
  Result := 999999;
  LastBalancePointDate := 0;
  for i := 0 to m_reqDet.m_hdr.m_RequestBalList.p_count-1 do
  begin
    BalRec := (m_reqDet.m_hdr.m_RequestBalList.p_Item[i]);
    if (BalRec.JobID = m_id) then continue;
    if (BalRec.Step <> PrecStep.m_code) then continue;
    Temp1 := BalRec.TotalBal;
    if (Temp1 < Temp2) then continue;
    CheckBalanceForDate(BalRec.DueDate, Setup, Execution, negativebalance);
    if NegativeBalance > 0 then
    begin
      LastBalancePointDate := BalRec.DueDate;
      continue;
    end;
    Result := BalRec.DueDate + (p_QtyChgSchedNet*m_reqDet.p_LeadTimePrev + m_reqDet.p_LeadTimePrevBatch)/24/60;
    RoundDateTime(Result);
    m_MinOvlpDate := result;
    break;
  end;
  if Result = 999999 then exit;

  if LastBalancePointDate <> 0 then
  begin
    // Try to find betrween 2 balance point the best date
    SecondsDifference := Trunc((BalRec.DueDate - LastBalancePointDate) * 24 * 60 * 60);
    DateDirection := (-1);
    TmpDate := BalRec.DueDate;
    while True do
    begin
      if SecondsDifference < 2 then break;
      SecondsDifference := Trunc(SecondsDifference / 2);
      TmpDate := TmpDate + ((SecondsDifference / 60 / 60 / 24) * DateDirection);
      if TmpDate <= LastBalancePointDate then exit;
      if TmpDate >= BalRec.DueDate then exit;
      CheckBalanceForDate(TmpDate, Setup, Execution, negativebalance);
      if NegativeBalance > 0 then
        DateDirection := 1
      else
      Begin
        DateDirection := (-1);
        Result := TmpDate + (p_QtyChgSchedNet*m_reqDet.p_LeadTimePrev + m_reqDet.p_LeadTimePrevBatch)/24/60;
      end
    end;
    RoundDateTime(Result);
    m_MinOvlpDate := result;
  end;

  // Check if there expired balances
  FirstExpirationDate := 0;
  LastExpirationDate := 0;
  for i := 0 to m_reqDet.m_hdr.m_RequestBalList.p_count-1 do
  begin
    BalRec := (m_reqDet.m_hdr.m_RequestBalList.p_Item[i]);
    if (BalRec.JobID = m_id) then continue;
    if (BalRec.Step <> PrecStep.m_code) then continue;
    if BalRec.BalanceType <> bt_Expiration then continue;
    if (FirstExpirationDate = 0) or (FirstExpirationDate > BalRec.DueDate) then
      FirstExpirationDate := BalRec.DueDate;
    if LastExpirationDate < BalRec.DueDate then
      LastExpirationDate := BalRec.DueDate;
  end;

  if FirstExpirationDate <> 0 then
  begin
    ActArea := TMqmActArea(TMqmVisibleRes(VisResPtr).FindActForDate(Result));
    Cal := ActArea.GetCalendar;
    if (RealSetup > 0) then  // More correct is to use is Ovelap not RealSetup but RealSetup is good enough - ERAN
      cal.OfsByWH(-(RealSetup / 60), false, FirstExpirationDate, ExpireDateHighLimit, ActArea.m_CrossDownTmList)
    else
      ExpireDateHighLimit := FirstExpirationDate;
    SecondsDifference := (Trunc((LastExpirationDate - FirstExpirationDate) * 24 * 60 * 60)) * 2;
    DateDirection := 0;
    TmpDate := LastExpirationDate;
    while True do
    begin
      if SecondsDifference < 2 then break;
      SecondsDifference := Trunc(SecondsDifference / 2);
      TmpDate := TmpDate + ((SecondsDifference / 60 / 60 / 24) * DateDirection);
      CheckBalanceForDate(TmpDate, Setup, Execution, negativebalance);
      if NegativeBalance >= 0 then
        DateDirection := (-1)
      else
      Begin
        DateDirection := 1;
        ExpireDateHighLimit := TmpDate - (p_QtyChgSchedNet*m_reqDet.p_LeadTimePrev + m_reqDet.p_LeadTimePrevBatch)/24/60;
      end
    end;
    RoundDateTime(ExpireDateHighLimit);
    cal.OfsByWH((Setup + Execution) / 60, true, ExpireDateHighLimit, ExpireDateHighLimit, ActArea.m_CrossDownTmList);
  end;

end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetOvlpHighLimit(VisResPtr: pointer; OvlpChk : TypeOvlpChk; RealSetup, Duration : double;  out ExpireDateLowLimit : TDateTime): TDateTime;
var
  NextStep: TSCProdReqDet;
  BalRec: PTReqBalance;
  i, FirstMinus : Integer;
  NegativeBalance : double;
  StartDate, TmpStartDate, PrevBalancedDate, TmpDateOfSt, ResultBeforeMinWait : TDateTime;
  Res : TMQMRes;
  Execution, Setup : double;
  TmpDur : double;
  Cal: TPGCALObj;
  ActArea:  TMqmActArea;
  LastBalanceFoundDate, TmpDate, TmpEndDateLeft, TmpEndDateRight : TdateTime;
  SecondsDifference : LongInt;
  DateDirection, ResComp : Integer;
  Descr : string;
  MSC: string;
  scP : TSCProdSched;
  isDefault : boolean;
  OvlpRule : TMQMOvlpRule;

  //--------

procedure CheckBalanceForDate(Date: TDateTime; Setup, Execution : double; var NegativeBalance: double; IgnoreExpire : boolean);
var
  i1 : integer;
  IDBalRec: PTReqBalance;
  NegativeQuantity: Double;
begin
  CalculateEntriesNextStep(VisResPtr, Date, false, Setup, Execution);
  for i1 := 0 to m_reqDet.m_hdr.m_RequestBalList.p_count-1 do
  begin
    IDBalRec := (m_reqDet.m_hdr.m_RequestBalList.p_Item[i1]);
    if (IDBalRec.JobID = m_id) then continue;
    if (IDBalRec.Step <> m_reqDet.m_code) then continue;
    AddToBalancePoints(IDBalRec.JobID, IDBalRec.BalanceType, IDBalRec.DueDate, IDBalRec.Quantity);
  end;
  SortBalancePoints;
  if OvlpChk = OvlpChk_OnSchedPoint then
    FindNegativeBalance(m_id, Cbm_JobEntriesOnly, NegativeQuantity, IgnoreExpire)
  else
    FindNegativeBalance(CSchedIDnull, Cbm_FromFirstEntry, NegativeQuantity, IgnoreExpire);
  NegativeBalance := NegativeQuantity;
end;


begin
  Result := 0;
  cal := nil;
  ExpireDateLowLimit := 0;

  NextStep := GetNextStepToSched(m_reqDet.m_code);
  if not Assigned(NextStep) then exit;
  if not Assigned(m_reqDet.m_PlanWrkCtrPtr) then exit;

  if m_reqDet.p_OverlapWithOtherSteps
  or not NextStep.CheckJobsOnPlan(nil)
  or not Assigned(NextStep.m_PlanWrkCtrPtr)
  or NextStep.p_OverlapWithOtherSteps then
  begin
    NextStep := m_reqDet;

    if m_reqDet.p_OverlapWithOtherSteps then
    begin
      while true do
      begin
        NextStep := GetNextStepToSched(NextStep.m_code);
        if not Assigned(NextStep) then exit;
        if not Assigned(NextStep.m_PlanWrkCtrPtr) then continue;
        if not NextStep.CheckJobsOnPlan(nil) then continue;
        if NextStep.p_OverlapWithOtherSteps then continue;
        for I := 0 to NextStep.m_list.Count - 1 do
        begin
          scP := TSCProdSched(NextStep.m_list[i]);
          if (scP.p_rscCode = '') then continue;
          if Result = 0 then
            result := scP.p_schedStart
          else if (result > scP.p_schedStart) then
            result := scP.p_schedStart;
        end;
        m_MaxOvlpDate := result;
        break;
      end;
      exit;
    end;

    while true do
    begin
      NextStep := GetNextStepToSched(NextStep.m_code);
      if not Assigned(NextStep) then exit;
      if not Assigned(NextStep.m_PlanWrkCtrPtr) then continue;
      if not NextStep.CheckJobsOnPlan(nil) then continue;
      if (m_reqDet.p_ResOccupation = CSResOcc_Occupy)
      and (NextStep.p_ResOccupation = CSResOcc_Border) then continue;
      for I := 0 to NextStep.m_list.Count - 1 do
      begin
        scP := TSCProdSched(NextStep.m_list[i]);
        if (scP.p_rscCode = '') then continue;
        if Result = 0 then
          result := scP.p_schedStart
        else if (result > scP.p_schedStart) then
          result := scP.p_schedStart;
      end;
      m_MaxOvlpDate := result;
      if not NextStep.p_OverlapWithOtherSteps then break;
    end;

    exit;
  end;

  m_reqDet.m_hdr.m_RequestBalList.SortBalanceList;
  m_reqDet.m_hdr.m_RequestBalList.UpdateBalanceTotals(m_reqDet.m_code, m_id);

  if OvlpChk = OvlpChk_OnSchedPoint then
  begin
    CheckBalanceForDate(p_StartWithMat, m_supMinReal - m_supMinOvlp, p_exeMin, negativebalance, true);
    if (negativebalance > 0) then Result := p_StartWithMat;
    exit;
  end;

  // Get the correct setup and execution time for that job on the resource checked
  Res := TMqmRes(TMQMVisibleRes(VisResPtr).p_father);
  if (Duration >=0) then
    Execution := Duration
  else
  begin
    if assigned(m_grp) and (m_reqDet.m_stepType = CST_Continuous) and (TSCProdGroup(m_grp).m_id = p_pl.GetCompatModeInPlanId) then
      Execution := UpdContGrpTimingsForSingleJob(TSCProdGroup(m_grp).m_id, m_id, Res, VisResPtr, setup)
    else
    begin
      p_pl.SetTmgTargetRes(Res);
      p_pl.GetMainTimings(Setup, Execution, Descr, MSC);
      if p_sc.GetRscComponentFromJobOrStep(m_id) > 0 then
        ResComp := p_sc.GetRscComponentFromJobOrStep(m_id)
      else
        ResComp := TMQMVisibleRes(VisResPtr).p_ResComp;
      if (ResComp > 0)  then
        execution := execution / ResComp;
      if (m_reqDet.m_stepType <> CST_batch) then
        execution := execution * (p_qtyChgSchedNet / m_reqDet.m_quantInit);
    end;
  end;
  if RealSetup >= 0 then
    setup := RealSetup;

  // Search for the first minus quantity
  FirstMinus := -1;
  BalRec := nil;
  for i := 0 to m_reqDet.m_hdr.m_RequestBalList.p_count-1 do
  begin
    BalRec := (m_reqDet.m_hdr.m_RequestBalList.p_Item[i]);
    if (BalRec.JobID = m_id) then continue;
    if (BalRec.Step <> m_reqDet.m_code) then continue;
    if BalRec.TotalBal >= 0 then continue;
    FirstMinus := i;
    break;
  end;
  if FirstMinus = -1 then exit;

  Result := BalRec.DueDate;
  PrevBalancedDate := BalRec.DueDate;
  ActArea := TMqmActArea(TMqmVisibleRes(VisResPtr).FindActForDate(BalRec.DueDate));
  if not assigned(ActArea) then exit;

  OvlpRule := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);
  TmpDur := (Setup + Execution) / 60;

  LastBalanceFoundDate := 0;
  for i := FirstMinus to m_reqDet.m_hdr.m_RequestBalList.p_count-1 do
  begin
    BalRec := (m_reqDet.m_hdr.m_RequestBalList.p_Item[i]);
    if (BalRec.JobID = m_id) then continue;
    if (BalRec.Step <> m_reqDet.m_code) then continue;
    ActArea := TMqmActArea(TMqmVisibleRes(VisResPtr).FindActForDate(BalRec.DueDate));
    if not assigned(ActArea) then exit;
    Cal := ActArea.GetCalendar;
    TmpDateOfSt := BalRec.DueDate;
    cal.OfsByWH(-TmpDur, false, TmpDateOfSt, StartDate, ActArea.m_CrossDownTmList);
    if assigned(OvlpRule) and (OvlpRule.m_WaitAtLeastMin > 0) then
      StartDate := StartDate - (OvlpRule.m_WaitAtLeastMin / 60 / 24);
    CheckBalanceForDate(StartDate, Setup, Execution, negativebalance, true);
    LastBalanceFoundDate := BalRec.DueDate;
    if NegativeBalance > 0 then break;
    PrevBalancedDate := BalRec.DueDate;
    Result := BalRec.DueDate;
  end;

  // Try to find betrween 2 balance point the best date
  SecondsDifference := Trunc((LastBalanceFoundDate - PrevBalancedDate) * 24 * 60 * 60);
  DateDirection := (-1);
  TmpDate := LastBalanceFoundDate;
  while True do
  begin
    if SecondsDifference < 2 then break;
    SecondsDifference := Trunc(SecondsDifference / 2);
    TmpDate := TmpDate + ((SecondsDifference / 60 / 60 / 24) * DateDirection);
    if TmpDate >= LastBalanceFoundDate then exit;
    if TmpDate <= PrevBalancedDate then exit;
    TmpDateOfSt := TmpDate;
    cal.OfsByWH(-TmpDur, false, TmpDateOfSt, TmpStartDate, ActArea.m_CrossDownTmList);
    if assigned(OvlpRule) and (OvlpRule.m_WaitAtLeastMin > 0) then
      TmpStartDate := TmpStartDate - (OvlpRule.m_WaitAtLeastMin / 60 / 24);
    CheckBalanceForDate(TmpStartDate, Setup, Execution, negativebalance, true);
    if NegativeBalance > 0 then
      DateDirection := (-1)
    else
    Begin
      DateDirection := 1;
      Result := TmpDate;
    end
  end;

  RoundDateTime(Result);
  ResultBeforeMinWait := Result;
  if assigned(OvlpRule) and (OvlpRule.m_WaitAtLeastMin > 0) then
  begin
    Result := Result - (OvlpRule.m_WaitAtLeastMin/60/24);
    RoundDateTime(Result);
  end;
  m_MaxOvlpDate := Result;

  if assigned(OvlpRule) and (OvlpRule.m_WaitAtMostMin > 0) and (OvlpRule.m_WaitAtLeastMin < OvlpRule.m_WaitAtMostMin) then
  begin
    TmpEndDateRight := ResultBeforeMinWait;
    TmpDateOfSt := ResultBeforeMinWait;
    cal.OfsByWH(-OvlpRule.m_WaitAtMostMin/60, false, TmpDateOfSt, TmpEndDateLeft, ActArea.m_CrossDownTmList);
    SecondsDifference := Trunc((TmpEndDateRight - TmpEndDateLeft) * 24 * 60 * 60) * 2;
    TmpDate := TmpEndDateLeft;
    DateDirection := (0);
    while True do
    begin
      if SecondsDifference < 2 then break;
      SecondsDifference := Trunc(SecondsDifference / 2);
      TmpDate := TmpDate + ((SecondsDifference / 60 / 60 / 24) * DateDirection);
      if TmpDate > ResultBeforeMinWait then exit;
      TmpDateOfSt := TmpDate;
      cal.OfsByWH(-TmpDur, false, TmpDateOfSt, TmpStartDate, ActArea.m_CrossDownTmList);
      if assigned(OvlpRule) and (OvlpRule.m_WaitAtLeastMin > 0) then
        TmpStartDate := TmpStartDate - (OvlpRule.m_WaitAtLeastMin / 60 / 24);
      CheckBalanceForDate(TmpStartDate, Setup, Execution, negativebalance, false);
      if NegativeBalance > 0 then
        DateDirection := 1
      else
      Begin
        DateDirection := (-1);
        ExpireDateLowLimit := TmpStartDate;
        if assigned(OvlpRule) and (OvlpRule.m_WaitAtLeastMin > 0) then
          ExpireDateLowLimit := ExpireDateLowLimit - (OvlpRule.m_WaitAtLeastMin/60/24);
        RoundDateTime(ExpireDateLowLimit);
      end
    end;
  end;


end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.CopyDataFromJobToJob(NewJob : TSCProdSched);
var
  I : Integer;
  PropIdJob : TPropId;
  RscCode   : string;
  jobPropVal : variant;
begin
  NewJob.m_srvPtr := self.m_srvPtr;
  NewJob.m_schedStart := self.m_schedStart;
  NewJob.m_schedEnd   := self.m_schedEnd;
  NewJob.m_exeMin     := self.m_exeMin;
  NewJob.m_supMinBase := self.m_supMinBase;
  NewJob.m_supMinReal := self.m_supMinReal;
  NewJob.m_supMinOvlp := self.m_supMinOvlp;
  NewJob.m_quantSched := self.m_quantSched;
  NewJob.m_manualChange := self.m_manualChange;
  NewJob.m_QtyChgSchedNet := self.m_QtyChgSchedNet;
  NewJob.m_rscCode        := self.m_rscCode;
  NewJob.m_OldrscCode     := self.m_OldrscCode;
  NewJob.m_schedType      := self.m_schedType;
  NewJob.m_wkcCodeTimingFile := self.m_wkcCodeTimingFile;
  NewJob.m_wkcProcTimingFile := self.m_wkcProcTimingFile;
  NewJob.m_resCodeTimingFile := self.m_resCodeTimingFile;
  NewJob.m_resCatTimingFile  := self.m_resCatTimingFile;
  NewJob.m_MsgFromHost       := self.m_MsgFromHost;
  NewJob.m_ChangedWkCtr      := self.m_ChangedWkCtr;
  NewJob.m_PlanWkCtrCode     := self.m_PlanWkCtrCode;
  NewJob.m_PlanWrkCtrProc    := self.m_PlanWrkCtrProc;
  NewJob.p_WrkCtrPtr         := self.p_WrkCtrPtr;
  NewJob.m_subLinRscId       := self.m_subLinRscId;
  NewJob.m_numOfRscComp      := self.m_numOfRscComp;
  NewJob.m_comment           := self.m_comment;
  NewJob.p_quantSched        := NewJob.m_reqDet.m_quantInit;
  NewJob.p_CurveCode         := self.p_CurveCode;
  NewJob.m_GroupAutomaticInternalSortingSequence := self.m_GroupAutomaticInternalSortingSequence;

  for I := 0 to m_reqDet.m_propList.p_PropCount - 1 do
  begin
    jobPropVal := m_reqDet.m_propList.GetProperty(i, PropIdJob, RscCode);
    if not IsPropPlanner(PropIdJob) then continue;
    NewJob.m_reqDet.m_propList.AddProperty(GetPropCodeFromID(PropIdJob), '', jobPropVal);
    UpdateMainListPropChange(NewJob.m_Id, GetPropCodeFromID(PropIdJob), jobPropVal, false);
  end;
  NewJob.p_quantManualChg    := 0;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.UpdateBalance(VisResPtr: pointer; CalcMat : boolean);
//var
//  VisRes: TMQMVisibleRes;
//  Cal: TPGCALObj;
begin
  if CalcMat and p_sc.P_DoNotCalcMatBalance then
    exit;

  // ERAN1910if 1963
  // ClearBalance;
  if CalcMat then
    ClearBalance
  else
    m_reqDet.m_hdr.m_RequestBalList.ClearBalanceForJob(m_Id);
  // ERAN19101963

  if Assigned(VisResPtr) then
  begin
//    VisRes := VisResPtr;
//    Cal := VisRes.GetCalendar;
    UpdateBalanceIssues(VisResPtr, CalcMat);
    UpdateBalanceEntries(VisResPtr, CalcMat);
  end else
    if Assigned(m_srvPtr) then
    begin
//      VisRes := TMQMVisibleRes(TMqmActArea(m_srvPtr).p_Father);
//      Cal := VisRes.GetCalendar;
      UpdateBalanceIssues(TMqmActArea(m_srvPtr).p_Father, CalcMat);
      UpdateBalanceEntries(TMqmActArea(m_srvPtr).p_Father, CalcMat);
    end;

end;

//----------------------------------------------------------------------------//

function TSCProdSched.CalcQtyFinnalProg : double;
var
  Cal: TPGCALObj;
  ActArea:  TMqmActArea;
  dur   : double;
begin
  if not Assigned(m_srvPtr) then
  begin
    Result := 0;
    exit
  end;
  ActArea := TMqmActArea(m_srvPtr);
  Cal := ActArea.GetCalendar;
  dur := trunc(cal.DiffWH(m_PrgSt, m_PrgEd , ActArea.m_CrossDownTmList)*60);
  if  m_exeMin = 0 then
      result := 0
  else
      Result := ((dur - m_supMinBase) * m_reqDet.m_quantInit) / m_exeMin;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetLearningCurveSaved : string;
begin
  Result := m_CurveCode
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetLearningCurve : string;
begin
  if m_CurveCodeOccToOcc <> '' then
    Result := m_CurveCodeOccToOcc
  else
    Result := m_CurveCode
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetLearningCurve(CurveCode : string);
begin
  m_CurveCode := CurveCode;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetLearningCurveByOccToOcc : string;
begin
  Result := m_CurveCodeOccToOcc;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetLearningCurveByOccToOcc(CurveCode : string);
begin
  m_CurveCodeOccToOcc := CurveCode
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetGrpSequence : string;
begin
  result := m_Grp_Sequence
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetGrpSequence(GrpSequence : string);
begin
  m_Grp_Sequence := GrpSequence
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetWrkCtrPtr(WC: pointer);
begin
  m_ChangedWkCtr := WC;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetProcess : string;
begin
  Result := m_PlanWrkCtrProc;
  if m_PlanWrkCtrProc = '' then
    Result := m_reqDet.m_planWkctrProc
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetProcess(Process : String);
begin
  m_PlanWrkCtrProc := Process;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetStartDate: TDateTime;
begin
  if m_PrgSt = 0 then
    Result := m_schedStart
  else
    Result := m_PrgSt;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetOrigStartDate: TDateTime;
begin
  Result := m_schedStart
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetStartDate(StDate: TDateTime);
begin
//  Assert(m_ProgType = '');
  m_schedStart := StDate;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetOrigEndDate: TDateTime;
begin
  Result := m_schedEnd
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSetupEndDate: TDateTime;
var
  Cal: TPGCALObj;
  ActArea:  TMqmActArea;
  TmpStart: TDateTime;
begin
  if (m_ProgType <> '')
  or not Assigned(m_srvPtr) then
  begin
    Result := p_schedStart;
    exit
  end;

  ActArea := TMqmActArea(m_srvPtr);
  Cal := ActArea.GetCalendar;
  TmpStart := p_schedStart;
  cal.OfsByWH((m_supMinReal)/60, true, TmpStart, Result, ActArea.m_CrossDownTmList)

end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetEndDate: TDateTime;
var
  TmpRemTime, Duration, Setup : double;
  Cal: TPGCALObj;
  ActArea:  TMqmActArea;
  DummyDate, TmpEnd: TDateTime;
  ProgressedTime, TimeToAdd : double;
begin
  TimeToAdd := 0;
  if (m_ProgType = '') then
  begin
    Result := m_schedEnd;
    exit
  end;

  if ((m_grp <> nil) and (m_reqDet.m_stepType = CST_Continuous)) then
  begin
    if (m_ProgType = '1') or (m_ProgType = '2') then
    begin
      Result := m_schedEnd;
      exit
    end;
  end;

//  Assert(Assigned(m_srvPtr));
  if not Assigned(m_srvPtr) then
  begin
    Result := 0;
    exit
  end;

  ActArea := TMqmActArea(m_srvPtr);
  Cal := ActArea.GetCalendar;

  if (m_PrgEd > 0) then
    Result := m_PrgEd
  else
  begin
    if (m_PrgCurDt <= 0) then
      m_PrgCurDt := p_schedStart;

    if (m_PrgRemTime > 0) then
      TmpRemTime := m_PrgRemTime
    else
    begin
      if (m_quantSched - m_PrgQty <= 0) then
        TmpRemTime := 0
      else
      begin
        if  (p_sc.GetLearningCurveType(m_Id) <> CSC_No)
        and (p_sc.GetLearningCurveCode(m_Id) <> '') then
        begin
          p_sc.GetIdTimes(m_Id,'','','',false,Duration,Setup,true);
        {  ProgressedTime :=  (m_PrgQty/m_quantSched) * Duration;
          TimeToAdd := GetCurveTime(ActArea, m_PrgSt, m_Id , duration, true, ProgressedTime);
          TmpRemTime := (m_quantSched - m_PrgQty)*duration/m_quantSched + TimeToAdd; }
         TmpRemTime := (m_quantSched - m_PrgQty)*duration/m_quantSched;
         ProgressedTime := cal.DiffWH(p_schedStart, m_PrgCurDt , ActArea.m_CrossDownTmList)*60;
         TimeToAdd := GetCurveTime(ActArea, m_PrgSt, m_Id , TmpRemTime, true, ProgressedTime);
         TmpRemTime := TmpRemTime + TimeToAdd;
        end
        else
        begin
          TmpRemTime := (m_quantSched - m_PrgQty)*m_exeMin/m_quantSched;
        end;
      end;
    end;

    if (m_ProgType = '1') then
//      cal.OfsByWH((m_supMinReal + TmpRemTime)/60, true, m_PrgCurDt, TmpEnd, ActArea.m_CrossDownTmList)
      cal.OfsByWH(TmpRemTime/60, true, m_PrgCurDt, TmpEnd, ActArea.m_CrossDownTmList)
    else
      if TmpRemTime > 0 then
        begin
          DummyDate := m_PrgCurDt;
          cal.OfsByWH(TmpRemTime/60, true, DummyDate, TmpEnd, ActArea.m_CrossDownTmList);
        end
      else
        TmpEnd := m_PrgCurDt;
    Result := TmpEnd;
  end;

  if Result <= p_schedStart then
    Result := m_schedEnd;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetProgEndOrig: TDateTime;
var
  TmpRemTime, Duration, Setup : double;
  Cal: TPGCALObj;
  ActArea:  TMqmActArea;
  DummyDate, TmpEnd, CurDt: TDateTime;
  ProgressedTime, TimeToAdd : double;
begin
  // Mirror of GetEndDate, but computed from the *Orig progress fields. Used to show the
  // "original" progress end of an ignored job (CSC_ProgEnd_Ignored). For a type '2'
  // (general) progress the stored DB progress-end is stale/meaningless, so — unlike
  // GetEndDate, which trusts any m_PrgEd > 0 — we only trust m_PrgEdOrig when it is
  // actually later than m_PrgStOrig; otherwise we recalculate exactly like GetEndDate.
  // A local CurDt is used so we don't mutate the persisted m_PrgCurDtOrig (re-apply).
  TimeToAdd := 0;
  if (m_ProgTypeOrig = '') then
  begin
    Result := m_PrgEdOrig;
    exit
  end;

  // NOTE: GetEndDate short-circuits a continuous-group type '1'/'2' job to m_schedEnd.
  // We must NOT do that here: for an ignored job m_schedEnd is the *post-ignore* schedule
  // (rescheduled earlier, without progress), so it would yield a value before m_PrgStOrig
  // ("strange number"). Instead we always compute the original end from the orig progress
  // fields + calendar, exactly like the live progress placement does.

  if not Assigned(m_srvPtr) then
  begin
    Result := m_PrgEdOrig;
    exit
  end;

  ActArea := TMqmActArea(m_srvPtr);
  Cal := ActArea.GetCalendar;

  if (m_PrgEdOrig > m_PrgStOrig) then
    Result := m_PrgEdOrig
  else
  begin
    CurDt := m_PrgCurDtOrig;
    if (CurDt <= 0) then
      CurDt := m_PrgStOrig;

    if (m_PrgRemTimeOrig > 0) then
      TmpRemTime := m_PrgRemTimeOrig
    else
    begin
      if (m_quantSched - m_PrgQtyOrig <= 0) then
        TmpRemTime := 0
      else
      begin
        if  (p_sc.GetLearningCurveType(m_Id) <> CSC_No)
        and (p_sc.GetLearningCurveCode(m_Id) <> '') then
        begin
          p_sc.GetIdTimes(m_Id,'','','',false,Duration,Setup,true);
          TmpRemTime := (m_quantSched - m_PrgQtyOrig)*duration/m_quantSched;
          ProgressedTime := cal.DiffWH(p_schedStart, CurDt , ActArea.m_CrossDownTmList)*60;
          TimeToAdd := GetCurveTime(ActArea, m_PrgStOrig, m_Id , TmpRemTime, true, ProgressedTime);
          TmpRemTime := TmpRemTime + TimeToAdd;
        end
        else
        begin
          TmpRemTime := (m_quantSched - m_PrgQtyOrig)*m_exeMin/m_quantSched;
        end;
      end;
    end;

    if (m_ProgTypeOrig = '1') then
      cal.OfsByWH(TmpRemTime/60, true, CurDt, TmpEnd, ActArea.m_CrossDownTmList)
    else
      if TmpRemTime > 0 then
        begin
          DummyDate := CurDt;
          cal.OfsByWH(TmpRemTime/60, true, DummyDate, TmpEnd, ActArea.m_CrossDownTmList);
        end
      else
        TmpEnd := CurDt;
    Result := TmpEnd;
  end;

  // Do NOT clamp to the live schedule here (GetEndDate uses p_schedStart/m_schedEnd, but
  // for an ignored/re-applying job m_schedEnd is the post-ignore schedule = wrong/earlier).
  // The original progress end can only be at or after the original progress start.
  if Result < m_PrgStOrig then
    Result := m_PrgStOrig;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetProgEnd: TDateTime;
var
  TmpRemTime, Duration, Setup : double;
  Cal: TPGCALObj;
  ActArea:  TMqmActArea;
  DummyDate, TmpEnd, CurDt: TDateTime;
  ProgressedTime, TimeToAdd : double;
begin
  // Current-fields twin of GetProgEndOrig: computes the progress end the same way GetEndDate
  // does, but WITHOUT GetEndDate's continuous-group short-circuit to m_schedEnd. Used only for
  // the Actual-End field of a progressed continuous-group job, where GetEndDate would return
  // the raw m_schedEnd instead of the calculated progress end. GetEndDate itself is untouched.
  TimeToAdd := 0;
  if (m_ProgType = '') then
  begin
    Result := m_schedEnd;
    exit
  end;

  if not Assigned(m_srvPtr) then
  begin
    Result := m_PrgEd;
    exit
  end;

  ActArea := TMqmActArea(m_srvPtr);
  Cal := ActArea.GetCalendar;

  if (m_PrgEd > 0) then
    Result := m_PrgEd
  else
  begin
    CurDt := m_PrgCurDt;
    if (CurDt <= 0) then
      CurDt := p_schedStart;

    if (m_PrgRemTime > 0) then
      TmpRemTime := m_PrgRemTime
    else
    begin
      if (m_quantSched - m_PrgQty <= 0) then
        TmpRemTime := 0
      else
      begin
        if  (p_sc.GetLearningCurveType(m_Id) <> CSC_No)
        and (p_sc.GetLearningCurveCode(m_Id) <> '') then
        begin
          p_sc.GetIdTimes(m_Id,'','','',false,Duration,Setup,true);
          TmpRemTime := (m_quantSched - m_PrgQty)*duration/m_quantSched;
          ProgressedTime := cal.DiffWH(p_schedStart, CurDt , ActArea.m_CrossDownTmList)*60;
          TimeToAdd := GetCurveTime(ActArea, m_PrgSt, m_Id , TmpRemTime, true, ProgressedTime);
          TmpRemTime := TmpRemTime + TimeToAdd;
        end
        else
        begin
          TmpRemTime := (m_quantSched - m_PrgQty)*m_exeMin/m_quantSched;
        end;
      end;
    end;

    if (m_ProgType = '1') then
      cal.OfsByWH(TmpRemTime/60, true, CurDt, TmpEnd, ActArea.m_CrossDownTmList)
    else
      if TmpRemTime > 0 then
        begin
          DummyDate := CurDt;
          cal.OfsByWH(TmpRemTime/60, true, DummyDate, TmpEnd, ActArea.m_CrossDownTmList);
        end
      else
        TmpEnd := CurDt;
    Result := TmpEnd;
  end;

  if (m_PrgSt <> 0) and (Result < m_PrgSt) then
    Result := m_PrgSt;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetLastScheudleChange(StDate: TDateTime);
var
  I : Integer;
begin
  m_CurrentSchedDate := StDate;
  if assigned(m_grp) then
  for I := 0 to self.m_grp.m_list.Count - 1 do
    TSCProdSched(self.m_grp.m_list[I]).m_CurrentSchedDate := StDate;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetSavedScheduleDate(StDate: TDateTime);
var
  I : Integer;
begin
  m_SavedScheduleDate := StDate;
  if assigned(m_grp) then
  for I := 0 to self.m_grp.m_list.Count - 1 do
    TSCProdSched(self.m_grp.m_list[I]).m_SavedScheduleDate := StDate;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetLastScheudleChange_ORIGINAL(LastSchedDate: TDateTime);
begin
  m_LastScheudleChange_ORIGINAL := LastSchedDate;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetEndDate(EndDate: TDateTime);
begin
//  Assert(m_ProgType = '');    // avi
  m_schedEnd := EndDate;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetProgToClose(EndDate: TDateTime);
begin
  m_PrgCurDt := EndDate;
  m_PrgEd := EndDate;
  if EndDate - (1/24/60/60) < m_PrgSt then
    m_PrgSt := EndDate - (1/24/60/60);
  m_ProgType := '3';
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetExeMin: double;
var
  Cal: TPGCALObj;
  ActArea:  TMqmActArea;
begin
  if (m_ProgType = '')
  or  not Assigned(m_srvPtr) then
  begin
    Result := m_exeMin;
    if m_reqDet.p_ResOccupation = CSResOcc_Border then
      result := (GetHighEndDate - GetLowStartDate)*24*60;
  end
  else
  begin
    ActArea := TMqmActArea(m_srvPtr);
    Cal := ActArea.GetCalendar;
    if p_schedEnd <= p_schedStart then
      Result := 0
    else if (p_schedEnd - p_schedStart) <= (2/24/60/60) then  // up to 2 seconds - skip calendar calc
      Result := (p_schedEnd - p_schedStart) * 24 * 60
    else
      Result := Cal.DiffWH(p_schedStart, p_schedEnd, ActArea.m_CrossDownTmList)*60;
  end;
end;

//----------------------------------------------------------------------------//
function TSCProdSched.GetExeMinForSave: double;
var
  Cal: TPGCALObj;
  TmpStart, TmpEnd : TDateTime;
  ActArea : TMqmActArea;
begin
  Result := 0;
  if not Assigned(m_srvPtr) then exit;
  if p_schedStart >= p_schedEnd then exit;
  ActArea := TMqmActArea(m_srvPtr);
  if not assigned(ActArea) then exit;
  Cal := ActArea.GetCalendar;
  if not assigned(cal) then exit;
  Result := Cal.DiffWH(p_schedStart, p_schedEnd, ActArea.m_CrossDownTmList)*60;
  if (Result > 999999) then exit;
  if (Result < 0) then exit;
  result := trunc(result*100)/100;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetExeMinIgnoreProgress: double;
begin
  Result := m_exeMin;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetActualTime : double;
var
  Cal: TPGCALObj;
  TmpStart, TmpEnd : TDateTime;
  ActArea : TMqmActArea;
begin
  Result := 0;
  ActArea := nil;
  if (m_ProgType = '') then
  begin
    if m_PrgSt = 0 then
      if Assigned(m_srvPtr) then
        result := m_exeMin + m_supMinReal
  end
  else
  begin
    if assigned(m_srvPtr) then
      ActArea := TMqmActArea(m_srvPtr);
    if not assigned(ActArea) then exit;
    Cal := ActArea.GetCalendar;
    if not assigned(cal) then exit;
    TmpStart := m_PrgSt;
    TmpEnd := GetEndDate;
    if TmpEnd <= TmpStart then
      Result := 0
    else if (TmpEnd - TmpStart) <= (2/24/60/60) then  // up to 2 seconds - skip calendar calc
      Result := (TmpEnd - TmpStart) * 24 * 60
    else
      Result := cal.DiffWH(TmpStart, TmpEnd , ActArea.m_CrossDownTmList)*60;
  end;
end;
//----------------------------------------------------------------------------//

procedure TSCProdSched.SetExeMin(ExeMin: double);
begin
  m_exeMin := ExeMin;
end;

//----------------------------------------------------------------------------//

Procedure TSCProdSched.SetNewSetupChanged(NewSetup : boolean);
begin
  m_NewSetupChanged := NewSetup;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetNewSetupChanged: boolean;
begin
  Result := m_NewSetupChanged;
end;

//----------------------------------------------------------------------------//

Procedure TSCProdSched.SetNewSetup(NewSetup : Double);
begin
  m_NewSetup := NewSetup;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetNewSetup: double;
begin
  Result := m_NewSetup;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSupMinBase: double;
begin
  if m_NewSetupChanged then
    Result := m_NewSetup
  else
    Result := m_supMinBase;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetSupMinBase(SupMinBase: double);
begin
  if m_NewSetupChanged then
    m_supMinBase := m_NewSetup
  else
    m_supMinBase := SupMinBase;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSupMinReal: double;
begin
  Result := m_supMinReal
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetSupMinReal(SupMinReal: double);
begin
  m_supMinReal := SupMinReal;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSupMinOvlp: double;
begin
  Result := m_supMinOvlp
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetSupMinOvlp(SupMinOvlp: double);
begin
  m_supMinOvlp := SupMinOvlp;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetQuantSched: double;
begin
  //Result := m_quantSched

  if m_quantSched < 0 then
    result := (m_quantSched + m_manualChange) +  m_manualChange
  else
   Result := m_quantSched + m_manualChange
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetQuantSched(QuantSched: double);
begin
//  {$ifdef Big}

{  if m_manualChange <= 0 then
  begin
    if (m_code > 0) and (m_quantSched < m_reqDet.m_quantInit) and (QuantSched = m_reqDet.m_quantInit) then
    begin
      showmessage('Quantity of Request' + ' ' + m_reqDet.m_hdr.m_code + ' ' + _('Step') + ' ' + IntToStr(m_reqDet.m_code) +
                      ' ' + _('SubStep') + ' '  + IntToStr(m_code) + ' ' + ' have been changed' + #13#10 +
                      ' Please imform datatex the current operation that caused this message'   +  #13#10 +
                      ' manualChange :' + FloatToStr(m_manualChange));
    end;
    m_quantSched := QuantSched + abs(m_manualChange)
  end
  else
  begin
    if (m_code > 0) and (m_quantSched < m_reqDet.m_quantInit) and (QuantSched = m_reqDet.m_quantInit) then
    begin
      showmessage('Quantity of Request' + ' ' + m_reqDet.m_hdr.m_code + ' ' + _('Step') + ' ' + IntToStr(m_reqDet.m_code) +
                      ' ' + _('SubStep') + ' '  + IntToStr(m_code) + ' ' + ' have been changed' + #13#10 +
                      ' Please imform datatex the current operation that caused this message'   +  #13#10 +
                      ' manualChange :' + FloatToStr(m_manualChange));
    end;

    m_quantSched := QuantSched - m_manualChange

  end;  }

  if m_manualChange <= 0 then
    m_quantSched := QuantSched + abs(m_manualChange);
 // else
 //   m_quantSched := QuantSched - m_manualChange ;

  if  m_quantSched = 0 then
    m_quantSched := QuantSched;

 // if m_quantSched <> QuantSched then exit;

//  {$endif}


end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetLoadQuantSched(QuantSched: double);
begin
//  {$ifdef Big}

{    if (m_code > 0) and (m_quantSched > 0) and (m_quantSched < m_reqDet.m_quantInit) and (QuantSched = m_reqDet.m_quantInit) then
  //  if (m_code > 0) and (QuantSched = m_reqDet.m_quantInit) then
    begin
      showmessage('Quantity of Request' + ' ' + m_reqDet.m_hdr.m_code + ' ' + _('Step') + ' ' + IntToStr(m_reqDet.m_code) +
                      ' ' + _('SubStep') + ' '  + IntToStr(m_code) + ' ' + ' have been changed' + #13#10 +
                      ' Please imform datatex the current operation that caused this message'   +  #13#10 +
                      ' manualChange :' + FloatToStr(m_manualChange));
    end;


  m_quantSched := QuantSched;

            }
//  {$else}
  m_quantSched := QuantSched;
//  {$endif}
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetFinalQuant: double;
begin
  if m_reqDet.m_quantInit = 0 then
    Result := 0
  else
    Result := m_reqDet.m_quantFinl*p_quantSched/m_reqDet.m_quantInit;
end;

//----------------------------------------------------------------------------//
//return the qty sched without manual changes
function TSCProdSched.GetQtySchdWithoutChg: double;
begin
  result :=  m_quantSched;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetDeliveryDate: TDateTime;
begin
  Result := m_reqDet.m_hdr.m_prodDelivDate
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetPlannedStrDate: TDateTime;
begin
  Result := m_reqDet.m_planStart
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetPlannedEndDate: TDateTime;
begin
  Result := m_reqDet.m_planEnd
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetLowStartDate: TDateTime;
var
  tDet : TSCProdReqDet;
  tJob : TSCProdSched;
  I : Integer;
  StepNumber : Integer;
begin
  Result := 0;

  if m_reqDet.p_ResOccupation = CSResOcc_Border then
  begin
    StepNumber := m_reqDet.m_code;
    while true do
    begin
      tDet := m_reqDet.m_hdr.GetPrecStepToSched(StepNumber);
      if not Assigned(tDet) then break;
      if tDet.p_ResOccupation <> CSResOcc_Occupy then break;
      for I := 0 to tDet.m_list.Count - 1 do
      begin
        tJob := TSCProdSched(tDet.m_list[I]);
        if tJob.m_isDeleted then
          Continue
        else
        if (tJob.m_schedStart > 0) and ((tJob.m_schedStart < Result) or (Result = 0)) then
           Result := tJob.m_schedStart;
      end;
      StepNumber := tDet.m_code
    end;
  end;
  if Result = 0 then
     Result := m_reqDet.m_lowStartTimeLimit;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetHighEndDate: TDateTime;
var
 tDet : TSCProdReqDet;
 tJob : TSCProdSched;
 I : Integer;
 StepNumber : Integer;
begin
  Result := 0;
  if m_reqDet.p_ResOccupation = CSResOcc_Border then
  begin
    StepNumber := m_reqDet.m_code;
    while true do
    begin
      tDet := m_reqDet.m_hdr.GetPrecStepToSched(StepNumber);
      if not Assigned(tDet) then break;
      if tDet.p_ResOccupation <> CSResOcc_Occupy then break;
      for I := 0 to tDet.m_list.Count - 1 do
      begin
        tJob := TSCProdSched(tDet.m_list[I]);
        if tJob.m_isDeleted then
          Continue
        else
        if tJob.m_schedEnd > Result then
           Result := tJob.m_schedEnd;
      end;
      StepNumber := tDet.m_code
    end;

  end;
  if Result = 0 then
     Result := m_reqDet.m_highEndTimeLimit;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetHighEndDateTemp: TDateTime;
begin
  Result := m_reqDet.m_highEndTimeLimitTemp
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetApprovalDate: TDateTime;
begin
  Result := m_reqDet.m_Approvaldate;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetMatArrDate: TDateTime;
begin
  Result := m_reqDet.m_materialArrivDate
end;

//----------------------------------------------------------------------------//

function SortAvailList(Item1, Item2: Pointer): integer;
var
  pd1, pd2: PTAvailRec;
begin
  pd1 := PTAvailRec(Item1);
  pd2 := PTAvailRec(Item2);

  if pd1.Date = pd2.Date then
  begin
    if pd1.BalanceType = pd2.BalanceType then
      Result :=  0
    else
      if pd1.BalanceType > pd2.BalanceType then
        Result := -1
      else
        Result :=  1
  end else
    if pd1.Date < pd2.Date then
      Result := -1
    else
      Result :=  1
end;

//----------------------------------------------------------------------------//

function SortSubStep(Item1, Item2: Pointer): integer;
var
  Job1 , Job2: TSCProdSched;
begin
  Job1 := TSCProdSched(Item1);
  Job2 := TSCProdSched(Item2);

  if Job1.m_code = Job2.m_code then
    Result := 0
  else if Job1.m_code > Job2.m_code then
    Result := 1
  else
    Result := -1;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.InitializeListForBallance(ArtList: TMQMIssuedArtList; ProdNature: SetArProdNature;
                                         var ListToFill: TList; CalcBalanceTotal : boolean);
//Fill the list with the materials to be checked
var
  i: integer;
  TmpIssArt: PTIssuedArt;
  Rec: PTLocRec;
begin
  if(ArtList.p_count = 0) then
    exit;

  for i := 0 to ArtList.p_count-1 do
  begin
    TmpIssArt := PTIssuedArt(ArtList.p_Item[i]);
    if (TmpIssArt.AternativeCode <> m_AlternativeCode)
    or not (TmpIssArt.Article.p_Nature in ProdNature)
    or (TmpIssArt.Article.p_Nature = Ar_NotBalance)
    or (TmpIssArt.ArtOnBalance = aob_DisplayOnly) then
      continue;

    new(Rec);
    ListToFill.Add(Rec);
    Rec.IssArt := ArtList.p_Item[i];

    if CalcBalanceTotal then
      Rec.IssArt.NetGroup.UpdateBalanceTotals(m_reqDet.m_hdr.m_code, m_id);

    Rec.LastAvail := false;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetMinMatArrDate(ResPtr: pointer; ProdNature: SetArProdNature; var NoAvailList: TList;
                      PrmSupMinBase, PrmDur, PrmSetupNeedMat : double; ByProduct : boolean) : Tlist;
type
  TNotAvailType = record
    ToPos : integer;
    Nature : ArProdNature;
    AddResStart : ArResTime;
    AddResEnd : ArResTime;
    HoursToDownFromMachine : integer;
    Index : integer; // For automatic sequence internal need
end;
  PTNotAvailType = ^TNotAvailType;
var
  I, J : integer;
  MacSetupRec: TMacSetup;
  Res: TMQMRes;
  IssArtList, OneProductList : TMQMIssuedArtList;
  TmpIssArt: PTIssuedArt;
  NoAvailListTemp: TList;
  PNotAvailType : PTNotAvailType;
begin
  Result := nil;
  Res := TMQMRes(ResPtr);
  MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;
  MacSetupRec.ResCat     := Res.p_ResCat.p_ResCatCode;
  MacSetupRec.ResCode    := Res.p_ResCode;
  MacSetupRec.MachineSetupCode := m_MachSetupCode;

  IssArtList := TMQMIssuedArtList.Create(true);
  m_reqDet.m_MacSetupList.GetIssuedArtList(MacSetupRec, IssArtList);

  if not ByProduct then
  begin
    GetMinMatArrDateForPrdList(ResPtr, IssArtList, ProdNature, NoAvailList, PrmSupMinBase, PrmDur, PrmSetupNeedMat);
    IssArtList.Free;
    exit;
  end;

  OneProductList := TMQMIssuedArtList.Create(true);
  NoAvailListTemp := Tlist.Create;
  Result := Tlist.Create;
  for I := 0 to IssArtList.p_count - 1 do
  begin
    TmpIssArt := PTIssuedArt(IssArtList.p_Item[i]);
    OneProductList.AddItem(TmpIssArt);
    GetMinMatArrDateForPrdList(ResPtr, OneProductList, ProdNature, NoAvailListTemp, PrmSupMinBase, PrmDur, PrmSetupNeedMat);
    OneProductList.CleanList;
    if NoAvailListTemp.Count = 0 then continue;
    for J := 0 to NoAvailListTemp.Count - 1 do
    begin
      NoAvailList.Add(NoAvailListTemp[J]);
    end;
    new(PNotAvailType);
    PNotAvailType.ToPos := NoAvailList.Count;
    PNotAvailType.Nature := TmpIssArt.Article.p_Nature;
    PNotAvailType.AddResStart := TmpIssArt.Article.p_AddResStart;
    PNotAvailType.AddResEnd := TmpIssArt.Article.p_AddResEnd;
    PNotAvailType.HoursToDownFromMachine := TmpIssArt.Article.P_HoursToDownFromMachine;
    PNotAvailType.Index := 0;
    Result.Add(PNotAvailType);
    NoAvailListTemp.Clear;
  end;
  NoAvailListTemp.Free;
  OneProductList.Free;
  IssArtList.Free;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.GetMinMatArrDateForPrdList(ResPtr: pointer; IssArtList : TMQMIssuedArtList; ProdNature: SetArProdNature;
                                         var NoAvailList: TList;
                                         PrmSupMinBase, PrmDur, PrmSetupNeedMat : double);
var
  Rec, RecGrp : PTLocRec;
  MaterialsToCheck,MaterialsToCheckGrpSon : TList;
  MacSetupRec: TMacSetup;
  i,j,G,m,T, DurInt : integer;
//  MinstartStdPurcOrd, MaxEndStdPurcOrd : TDateTime;
  Res: TMQMRes;
  TmpAvailList, OneProductAvailList : TList;
  RecNoMat: PTRecNoMatDate;
  AvaliRec, NewAvaliRec : PTAvailRec;
  LastStatus: boolean;
  AllTrue: boolean;
  IssArtListGrpSon : TMQMIssuedArtList;
  TmpStrLst: TStringList;
  ReservedQty, ReqQty, UsedQty, ReservedQtyTmp, ReqQtyTmp, UsedQtyTmp, AvailQty : Double;
  QtyInteger : Integer;
  JobSon : TSCProdSched;
  ByGroup : Boolean;
  TolleranceQuantity : double;
  Found : boolean;
  HighestPurcOrProdTime : Integer;
//  HigestDueDate : TDateTime;
  FoundNotAvailbleMatAndNoLeadTime, Available : boolean;
  CheckPurchaseOrderLeadTime : boolean;
  OvlpRule : TMQMOvlpRule;

  isDefault, ResBatchType, HandlePartialIssue, FirstPartialCalculation : boolean;
  FoundEnoughQty, FoundEnoughQtyAllBalances, NegativeQtyFound : boolean;
  OvlpRuleDet: PTOvlpRuleDet;
  SupMinBase, Duration, RealSetup, Setup, Overlap, DurTemp, DummyDbl1, DummyDbl2 : double;
  TempQtyCurrency : Currency;
  ActArea : TMqmActArea;
  LastPrevID, PrevID, GrpId : TSchedId;
  DummyStr, LearningCurveCode, TmgDescr, TmgMSC : string;
  Cal: TPGCALObj;
  EndDate, NextAvailDate, StartDate, TempDate : TDateTime;
  VisRes : TMQMVisibleRes;
  ProductBalanceList  : TList;
  ProductBalance : PTProductBalance;
  components, ResComp : integer;
  QuantSched : double;
  DecimalRounding : Integer;
begin
  IssArtListGrpSon := nil;
  MaterialsToCheckGrpSon := nil;
  Res := TMQMRes(ResPtr);
  MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;
  MacSetupRec.ResCat     := Res.p_ResCat.p_ResCatCode;
  MacSetupRec.ResCode    := Res.p_ResCode;
  MacSetupRec.MachineSetupCode := m_MachSetupCode;
  if assigned(self.m_grp) then
    GrpId := p_sc.GetGroup(m_id);
  ResBatchType := TMqmRes(Res).p_ProcessType = CST_batch;
  VisRes := TMqmVisibleRes(res.p_VisRes[0]);
  ActArea := TMqmActArea(VisRes.p_ActArea[0]);
  Cal := ActArea.GetCalendar;
  OvlpRule := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);
  OneProductAvailList := TList.Create;
  ProductBalanceList := TList.Create;
  FirstPartialCalculation := true;

  MaterialsToCheck := Tlist.Create;
  InitializeListForBallance(IssArtList, ProdNature, MaterialsToCheck, false);

  TmpAvailList := TList.Create;

  for i := 0 to MaterialsToCheck.Count-1 do
  begin
    Rec := MaterialsToCheck[i];

    ReqQty := 0;
    UsedQty := 0;
    ReservedQty := 0;

    ByGroup := true;
    if not assigned(self.m_grp) then
      ByGroup := false;
    if (ByGroup) then
    begin
      if (Rec.IssArt.Article.p_Nature = Ar_AddRes)
      or (Rec.IssArt.Article.p_Nature = Ar_AddRes_ManPower) then
        ByGroup := false;
    end;

    DecimalRounding := NumberOfDecimalRounding(Rec.IssArt.Article.p_NumberOfDecimal);

    if not ByGroup then
    begin
      QuantSched := self.m_quantSched;
      if not Rec.IssArt.ClosedIssue then
      begin
        ReservedQty := Rec.IssArt.RequiredQty;
        UsedQty := Rec.IssArt.IssuedQty + Rec.IssArt.AllocatedQty;
      end;
      if  (Rec.IssArt.Article.p_Nature <> Ar_AddRes)
      and (Rec.IssArt.Article.p_Nature <> Ar_AddRes_ManPower) then
      begin
        TempQtyCurrency := (DecimalRounding * self.m_quantSched / self.m_reqDet.m_quantInit * ReservedQty);
        TempQtyCurrency := trunc(TempQtyCurrency);
        ReservedQty := TempQtyCurrency / DecimalRounding;
        TempQtyCurrency := (DecimalRounding * self.m_quantSched / self.m_reqDet.m_quantInit * UsedQty);
        TempQtyCurrency := trunc(TempQtyCurrency);
        if self.m_quantSched <> m_reqDet.m_quantInit then
          TempQtyCurrency := TempQtyCurrency + 1;
        UsedQty := TempQtyCurrency / DecimalRounding;
      end;
    end
    else
    begin

      IssArtListGrpSon := TMQMIssuedArtList.Create(true);
      MaterialsToCheckGrpSon := Tlist.Create;
      QuantSched := 0;

      for G := 0 to self.m_grp.m_list.Count - 1 do
      begin

        JobSon := TSCProdSched(self.m_grp.m_list[G]);
        QuantSched := QuantSched + JobSon.m_quantSched;
        IssArtListGrpSon.CleanList;

        JobSon.m_reqDet.m_MacSetupList.GetIssuedArtList(MacSetupRec, IssArtListGrpSon);

        MaterialsToCheckGrpSon.Clear;
        InitializeListForBallance(IssArtListGrpSon, ProdNature, MaterialsToCheckGrpSon, false);

        for M := 0 to MaterialsToCheckGrpSon.Count - 1 do
        begin
          RecGrp := MaterialsToCheckGrpSon[M];

          if (RecGrp.IssArt.Article.p_ArtType = Rec.IssArt.Article.p_ArtType) and
             (RecGrp.IssArt.NetGroup.m_Code = Rec.IssArt.NetGroup.m_Code) and
             (RecGrp.IssArt.Article.p_ArtCode = Rec.IssArt.Article.p_ArtCode) then
          begin
            ReservedQtyTmp := 0;
            UsedQtyTmp := 0;
            if not RecGrp.IssArt.ClosedIssue then
            begin
              ReservedQtyTmp := RecGrp.IssArt.RequiredQty;
              UsedQtyTmp := RecGrp.IssArt.IssuedQty + RecGrp.IssArt.AllocatedQty;
            end;
            if (Rec.IssArt.Article.p_Nature <> Ar_AddRes)
                and (Rec.IssArt.Article.p_Nature <> Ar_AddRes_ManPower) then
            begin
              TempQtyCurrency := (DecimalRounding * JobSon.m_quantSched / JobSon.m_reqDet.m_quantInit * ReservedQtyTmp);
              TempQtyCurrency := trunc(TempQtyCurrency);
              ReservedQtyTmp := TempQtyCurrency / DecimalRounding;
              TempQtyCurrency := (DecimalRounding * JobSon.m_quantSched / JobSon.m_reqDet.m_quantInit * UsedQtyTmp);
              TempQtyCurrency := trunc(TempQtyCurrency);
              if self.m_quantSched <> m_reqDet.m_quantInit then
                TempQtyCurrency := TempQtyCurrency + 1;
              UsedQtyTmp := TempQtyCurrency / DecimalRounding;
            end;
            ReservedQty := ReservedQty + ReservedQtyTmp;
            UsedQty := UsedQty + UsedQtyTmp;
          end;
        end;
      end;

    end;

    TolleranceQuantity := rec.IssArt.Article.GetTolleranceQuantity(ReservedQty);
    ReqQty := ReservedQty - UsedQty;
    if TolleranceQuantity < ReqQty then
      ReqQty := ReqQty - TolleranceQuantity
    else
      ReqQty := 0;

    if (ReqQty < 0) then
       ReqQty := 0;

    HandlePartialIssue := false;
    if Rec.IssArt.Article.p_Nature = Ar_AddRes_Capacity then // rec.IssArt.Article.p_AddResStart must be Ar_Day
    begin
      HandlePartialIssue := true;
      if PrmDur >=0 then
        Duration := PrmDur
      else
      begin
        components := 1;
        p_pl.SetTmgTargetRes(Res);
        p_pl.GetMainTimings(supMinBase, duration, TmgDescr, TmgMSC);
        if Res.p_isMultiRes then
        begin
          if p_sc.GetRscComponentFromJobOrStep(m_id) > 0 then
             ResComp := p_sc.GetRscComponentFromJobOrStep(m_id)
          //if m_reqDet.p_RscComp > 0 then
          //   ResComp := m_reqDet.p_RscComp
          else
             ResComp := VisRes.p_ResComp;
          components := ResComp;
          CalcDur(ActArea, AvaliRec.Date, m_Id, Duration, components, true);
        end;
      end;

      ReqQtyTmp := 0; // The availability is handled here

      if Assigned(self.m_grp) then
        Rec.IssArt.NetGroup.GetListNotAvailPos(self.m_grp.m_list,m_Id,OneProductAvailList, Rec, ReqQtyTmp, Rec.IssArt.Article.p_StdPurcOrProdTime)
      else
        Rec.IssArt.NetGroup.GetListNotAvailPos(nil,m_Id,OneProductAvailList, Rec, ReqQtyTmp, Rec.IssArt.Article.p_StdPurcOrProdTime);

      NegativeQtyFound := false;
      for T := 0 to OneProductAvailList.Count - 1 do
      begin
        AvaliRec := OneProductAvailList[T];
        AvaliRec.Avail := false;
        if AvaliRec.UpToDateQuantity < 0 then
          NegativeQtyFound := true;
      end;

      T := -1;
      if not NegativeQtyFound then
      begin
        while true do
        begin
          inc(T);
          if T = OneProductAvailList.Count then break;
          AvaliRec := OneProductAvailList[T];
          if AvaliRec.Date = 0 then continue;
          if AvaliRec.UpToDateQuantity >= ReqQty then
            DurTemp := Duration
          else
          begin
            DurInt := trunc(AvaliRec.UpToDateQuantity / ReqQty * Duration * 60);
            DurTemp := DurInt / 60;
          end;
          if DurTemp > (24 * 60) then
            DurTemp := (24 * 60);
          TempDate := AvaliRec.Date + 1;
          if DurTemp > 0 then
            cal.OfsByWH(-(DurTemp / 60), false, TempDate, StartDate, ActArea.m_CrossDownTmList)
          else
            StartDate := TempDate;
          if StartDate < AvaliRec.Date then
            StartDate := AvaliRec.Date;

          if (StartDate > AvaliRec.Date) and (AvaliRec.UpToDateQuantity < ReqQty) then // Quantity available does not cover a full day
          begin
            DurInt := trunc((ReqQty - AvaliRec.UpToDateQuantity) / ReqQty * Duration * 60);
            DurTemp := (DurInt - 1) / 3600; // If we start 1 second after cover the exact quantity - we will not have enough
            cal.OfsByWH(-(DurTemp), false, AvaliRec.Date, TempDate, ActArea.m_CrossDownTmList);
            for G := T downto 0 do
            begin
              AvaliRec := OneProductAvailList[G];
              if TempDate >= AvaliRec.Date then break;
            end;
            if TempDate >= AvaliRec.Date then
              inc(G);
            if TempDate = AvaliRec.Date then
              TempDate := TempDate + 1/24/60/60;
            if G > 0 then
            begin
              new(NewAvaliRec);
              NewAvaliRec.LocRec := AvaliRec.LocRec;
              NewAvaliRec.Date := TempDate;
              NewAvaliRec.Avail := false;
              NewAvaliRec.UpToDateQuantity := AvaliRec.UpToDateQuantity;
              NewAvaliRec.StdPurcOrProdTime := AvaliRec.StdPurcOrProdTime;
              OneProductAvailList.insert(G, NewAvaliRec);
              inc(T);
            end;
            AvaliRec := OneProductAvailList[T];
          end;

          if AvaliRec.UpToDateQuantity = 0 then continue;

          NextAvailDate := AvaliRec.Date + 1;
          cal.OfsByWH((duration / 60), true, StartDate, EndDate, ActArea.m_CrossDownTmList);
          Available := true;
          AvailQty := AvaliRec.UpToDateQuantity;
          G := T;
          while NextAvailDate <= trunc(EndDate) do
          begin
            while True do
            begin
              AvaliRec := OneProductAvailList[G];
              if AvaliRec.Date < NextAvailDate then
              begin
                if G = (OneProductAvailList.Count - 1) then break;
                inc(G);
                continue;
              end;
              if AvaliRec.Date = NextAvailDate then
                AvailQty := AvaliRec.UpToDateQuantity;
              break;
            end;
            if NextAvailDate = trunc(EndDate) then
              DurTemp := cal.DiffWH(NextAvailDate, EndDate , ActArea.m_CrossDownTmList)*60
            else
              DurTemp := cal.DiffWH(NextAvailDate, (NextAvailDate + 1) , ActArea.m_CrossDownTmList)*60;
            ReqQtyTmp := DurTemp / Duration * ReqQty;
            if ReqQtyTmp > AvailQty then
            begin
              Available := false;
              break;
            end;
            NextAvailDate := NextAvailDate + 1;
          end;
          if Available then
          begin
            AvaliRec := OneProductAvailList[T];
            AvaliRec.Avail := true;
            if StartDate > AvaliRec.Date then
              AvaliRec.Date := StartDate;
          end;
        end;
      end;
    end;

    if (Rec.IssArt.Article.p_Nature = Ar_Material) and not ResBatchType and assigned(ActArea) and assigned(OvlpRule) then
    begin
      OvlpRuleDet := OvlpRule.GetDet(Rec.IssArt.Article.p_ArtType.p_ArtTypeCode, Rec.IssArt.IssueTransType);
      if Assigned(OvlpRuleDet) and OvlpRuleDet.SearchBalance and not OvlpRuleDet.WaitEntireMatQty then
      begin
        HandlePartialIssue := true;
        if Assigned(self.m_grp) then
          Rec.IssArt.NetGroup.GetListNotAvailPos(self.m_grp.m_list,m_Id,OneProductAvailList, Rec, ReqQty, Rec.IssArt.Article.p_StdPurcOrProdTime)
        else
          Rec.IssArt.NetGroup.GetListNotAvailPos(nil,m_Id,OneProductAvailList, Rec, ReqQty, Rec.IssArt.Article.p_StdPurcOrProdTime);
        for T := 0 to OneProductAvailList.Count - 1 do
        begin
          AvaliRec := OneProductAvailList[T];
          if AvaliRec.Avail then continue;
          if AvaliRec.UpToDateQuantity < OvlpRuleDet.MinMatQty then continue;
          NextAvailDate := 0;
          for G := T to OneProductAvailList.Count - 1 do
          begin
            AvaliRec := OneProductAvailList[G];
            if not AvaliRec.Avail then continue;
            NextAvailDate := AvaliRec.Date;
            Break;
          end;
          if NextAvailDate = 0 then
            break;
          AvaliRec := OneProductAvailList[T];
          if FirstPartialCalculation then
          begin
            if PrmDur >=0 then
            begin
              supMinBase := PrmSupMinBase;
              Duration := PrmDur;
            end
            else
            begin
              components := 1;
              p_pl.SetTmgTargetRes(Res);
              p_pl.GetMainTimings(supMinBase, duration, TmgDescr, TmgMSC);
              if Res.p_isMultiRes then
              begin
                if p_sc.GetRscComponentFromJobOrStep(m_id) > 0 then
                  ResComp := p_sc.GetRscComponentFromJobOrStep(m_id)
                //if m_reqDet.p_RscComp > 0 then
                //  ResComp := m_reqDet.p_RscComp
                else
                  ResComp := VisRes.p_ResComp;
                components := ResComp;
              end;
              CalcDur(ActArea, AvaliRec.Date, m_Id, Duration, components, true);
            end;
          end;
          if PrmSetupNeedMat >= 0 then
            RealSetup := PrmSetupNeedMat
          else
          begin
            if Assigned(self.m_grp) then
              prevID := ActArea.GetPrecObj(AvaliRec.Date , GrpId)
            else
              prevID := ActArea.GetPrecObj(AvaliRec.Date , m_id);
            if LastPrevID <> prevID  then
            begin
              if prevID = CSchedIDnull then
                RealSetup := supMinBase
              else
              begin
                if Assigned(self.m_grp) then
                  CalcSetup(GrpId, PrevID, actArea , supMinBase, Setup, overlap, DummyStr, DummyDbl1, DummyDbl2, LearningCurveCode)
                else
                  CalcSetup(m_id, PrevID, actArea , supMinBase, Setup, overlap, DummyStr, DummyDbl1, DummyDbl2, LearningCurveCode);
                RealSetup := Setup - overlap;
              end;
            end;
          end;
          FirstPartialCalculation := false;
          cal.OfsByWH(((RealSetup+duration) / 60), true, AvaliRec.Date, EndDate, ActArea.m_CrossDownTmList);
          if (EndDate < NextAvailDate) then
            continue;
          for G := 0 to ProductBalanceList.Count -1 do
            Dispose(ProductBalanceList.Items[G]);
          ProductBalanceList.Clear;
          CalculateIssues(VisRes, Rec.IssArt.NetGroup,
                         OvlpRuleDet.WaitEntireMatQty, OvlpRuleDet.UpdEveryHours,
                         AvaliRec.Date, EndDate,
                         duration, OvlpRuleDet.MinMatQty, 0, ReservedQty, UsedQty, QuantSched,
                         1, 0, ProductBalanceList);
          FoundEnoughQtyAllBalances := true;
          for G := 0 to ProductBalanceList.Count -1 do
          begin
            FoundEnoughQty := false;
            ProductBalance := ProductBalanceList[G];
            for M := T to OneProductAvailList.Count - 1 do
            begin
              AvaliRec := OneProductAvailList[M];
              if AvaliRec.Date > ProductBalance.Date then
                break;
              if AvaliRec.UpToDateQuantity >= ProductBalance.UpToDateQuantity then
                FoundEnoughQty := true;
            end;
            if not FoundEnoughQty then
            begin
              FoundEnoughQtyAllBalances := false;
              break;
            end;
            end;
          AvaliRec := OneProductAvailList[T];
          if FoundEnoughQtyAllBalances then
            AvaliRec.Avail := true;
          end;
        end;

      end;

    if HandlePartialIssue then
    begin
      for M := 0 to OneProductAvailList.Count - 1 do
      begin
        AvaliRec := OneProductAvailList[M];
        TmpAvailList.Add(AvaliRec);
      end;
      OneProductAvailList.Clear;
    end
    else
    begin
    if Assigned(self.m_grp) then
      Rec.IssArt.NetGroup.GetListNotAvailPos(self.m_grp.m_list,m_Id,TmpAvailList, Rec, ReqQty, Rec.IssArt.Article.p_StdPurcOrProdTime)
    else
      Rec.IssArt.NetGroup.GetListNotAvailPos(nil,m_Id,TmpAvailList, Rec, ReqQty, Rec.IssArt.Article.p_StdPurcOrProdTime);
    end;

  end;

  TmpAvailList.Sort(SortAvailList);

  LastStatus := false;
  RecNoMat := nil;
  HighestPurcOrProdTime := 0;
//  HigestDueDate := 0;
  FoundNotAvailbleMatAndNoLeadTime := false;
  CheckPurchaseOrderLeadTime := false;

  if TmpAvailList.Count > 0 then
  begin
    New(RecNoMat);
    RecNoMat.m_start := 0;
    RecNoMat.m_end   := 0;
    RecNoMat.m_StdPurcOrProdTime := 0;
    NoAvailList.Add(RecNoMat);
  end;

  for i := 0 to TmpAvailList.Count -1 do
  begin
    AvaliRec := TmpAvailList[i];
    AvaliRec.LocRec.LastAvail := AvaliRec.Avail;

    if AvaliRec.StdPurcOrProdTime > 0 then
       CheckPurchaseOrderLeadTime := true;

    if (not AvaliRec.Avail) and (AvaliRec.StdPurcOrProdTime > HighestPurcOrProdTime) then
       HighestPurcOrProdTime := AvaliRec.StdPurcOrProdTime;

//    if AvaliRec.Avail and (AvaliRec.date > 0) and (AvaliRec.date > HigestDueDate) then
//      HigestDueDate := AvaliRec.date;

    if not FoundNotAvailbleMatAndNoLeadTime and not AvaliRec.Avail and (AvaliRec.StdPurcOrProdTime = 0) then
      FoundNotAvailbleMatAndNoLeadTime := true;

    AllTrue := true;

    for j := 0 to MaterialsToCheck.Count-1 do
    begin
      Rec := MaterialsToCheck[j];
      if not Rec.LastAvail then
      begin
        AllTrue := false;
        break
      end;
    end;

    if LastStatus then //Searching for a Negative front
    begin
      if not AllTrue then
      begin
        New(RecNoMat);
        RecNoMat.m_start := AvaliRec.Date;
        RecNoMat.m_end := AvaliRec.Date;
        RecNoMat.m_StdPurcOrProdTime := AvaliRec.StdPurcOrProdTime;
        NoAvailList.Add(RecNoMat);
        LastStatus := false
      end;
    end else  //Searching for a Positive front
    begin
      if AllTrue then
      begin
        RecNoMat.m_end := AvaliRec.Date;
        RecNoMat.m_StdPurcOrProdTime := AvaliRec.StdPurcOrProdTime;
        LastStatus := true
      end;
    end;
  end;

  if not LastStatus
  and Assigned(RecNoMat) then
  begin
    RecNoMat.m_end := 90000;
//    if HigestDueDate > 0 then
//      CheckPurchaseOrderLeadTime := false;
  end;

  if assigned(IssArtListGrpSon) then
     IssArtListGrpSon.Free;

  OneProductAvailList.Free;
  OneProductAvailList := nil;
  for i := 0 to ProductBalanceList.Count -1 do
    Dispose(ProductBalanceList.Items[i]);
  ProductBalanceList.Free;
  ProductBalanceList := nil;

  for i := 0 to TmpAvailList.Count -1 do
    Dispose(TmpAvailList.Items[i]);
  TmpAvailList.Free;
  TmpAvailList := nil;

  for i := 0 to MaterialsToCheck.Count -1 do
    Dispose(MaterialsToCheck.Items[i]);
  MaterialsToCheck.Free;

  if assigned(MaterialsToCheckGrpSon) then
  begin
    for i := 0 to MaterialsToCheckGrpSon.Count -1 do
      Dispose(MaterialsToCheckGrpSon.Items[i]);
    MaterialsToCheckGrpSon.Free;
  end;

  if not CheckPurchaseOrderLeadTime then exit;
  if FoundNotAvailbleMatAndNoLeadTime then exit;

  for I := 0 to NoAvailList.count - 1 do
  begin
    RecNoMat := PTRecNoMatDate(NoAvailList[I]);

    //if (HigestDueDate > 0) then
    //  RecNoMat.m_end := HigestDueDate;
    RecNoMat.m_StdPurcOrProdTime := HighestPurcOrProdTime;

    if RecNoMat.m_StdPurcOrProdTime > 0 then
    begin
      if Trunc(now + RecNoMat.m_StdPurcOrProdTime) < RecNoMat.m_end then
      begin
        if RecNoMat.m_end <= 90000 then
        begin
          RecNoMat.m_startStdPurcOrd := Trunc(now + RecNoMat.m_StdPurcOrProdTime);
          RecNoMat.m_EndStdPurcOrd := RecNoMat.m_end;
          RecNoMat.m_end :=  RecNoMat.m_startStdPurcOrd
        end;
      end;
    end;

  end;

end;

//----------------------------------------------------------------------------//

function TSCProdSched.CheckEnoughMatAtDateMain(ApaPtr: pointer; ProdNature: SetArProdNature;
                              StrDate: TDateTime; var ListMatNotAvail: TList; var ListOfLeadTime: TList): boolean;
var
  MaterialsAlreadyChecked : Tlist;
begin
  MaterialsAlreadyChecked := nil;
  Result := CheckEnoughMatAtDate(ApaPtr, ProdNature, StrDate, ListMatNotAvail, ListOfLeadTime, MaterialsAlreadyChecked, false);
end;

//----------------------------------------------------------------------------//

function TSCProdSched.CheckEnoughMatAtDate(ApaPtr: pointer; ProdNature: SetArProdNature;
                              StrDate: TDateTime; var ListMatNotAvail: TList; var ListOfLeadTime: TList;
                              var MaterialsAlreadyChecked : Tlist; CheckForTheGroup : boolean): boolean;
type
 TStepsInGroup = record
   Request  : String;
   Step  : integer;
   ReqQty : double;
   Tollerance : double;
 end;
 PTStepsInGroup = ^TStepsInGroup;
 TMaterialsAlreadyChecked = record
   ArtType       : String;
   NetGroupCode  : String;
   ArtCode       : String;
 end;
 PTMaterialsAlreadyChecked = ^TMaterialsAlreadyChecked;
var
  i, J, G,m,T: integer;
  MacSetupRec: TMacSetup;
  OvlpRule: TMQMOvlpRule;
  Res: TMQMRes;
  TmpAvailList : TList; //NoAvailList,
  MaterialsToCheck, MaterialsToCheckGrpSon, StepsInGroup : TList;
  Rec, RecGrp: PTLocRec;
  AvaliRec: PTAvailRec;
  IssArtList, IssArtListTmp, IssArtListGrpSon : TMQMIssuedArtList;
  isDefault, ExistArtToCheck: boolean;
  ProductNatureMaterial : Boolean;
  TmpIssArt: PTIssuedArt;
  TolleranceQuantity : double;
  ReqQty,ReqQtyTemp : Double;
  QtyInteger : Integer;
  ByGroup : Boolean;
  JobSon : TSCProdSched;
  Found : boolean;
  PStepsInGroup : PTStepsInGroup;
  RecNoMat: PTRecNoMatDate;
  LastStatus: boolean;
  AllTrue: boolean;
  MinstartStdPurcOrd : TDateTime;
  MaxEndStdPurcOrd   : TDateTime;
  HighestPurcOrProdTime : Integer;
//  HigestDueDate : TDateTime;
  FoundNotAvailbleMatAndNoLeadTime : boolean;
  CheckPurchaseOrderLeadTime : boolean;
  PMaterialsAlreadyChecked : PTMaterialsAlreadyChecked;
  DecimalRounding : Integer;

//  str : TStringList;
//  FieldValReq, FieldValStep, FieldValSubStep : variant;
//  dataType: CBinColValType;
//  PrevHaveEnoughBalance : boolean;
//  TempNature : string;

begin

  // FP - WARNING!!!!
  // Waiting refactoring please don't exit from these loops
  // at the first false result because this function is used also
  // for show ALL materials not enough in the job details form
  result := true;
  ByGroup := CheckForTheGroup;
  MaterialsToCheckGrpSon := nil;
  IssArtListGrpSon := nil;
  TmpAvailList := nil;
  StepsInGroup := nil;

  Res := TMQMRes(TMQMActArea(m_srvPtr).p_Res);
  OvlpRule := Res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);
  if not Assigned(OvlpRule) then exit;

  MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;
  MacSetupRec.ResCat     := Res.p_ResCat.p_ResCatCode;
  MacSetupRec.ResCode    := p_rscCode;
  MacSetupRec.MachineSetupCode := m_MachSetupCode;

  IssArtListTmp := TMQMIssuedArtList.Create(true);
  m_reqDet.m_MacSetupList.GetIssuedArtList(MacSetupRec, IssArtListTmp);

  IssArtList := TMQMIssuedArtList.Create(false);
  ExistArtToCheck := false;

  for I := 0 to IssArtListTmp.p_count - 1 do
  begin
    TmpIssArt := PTIssuedArt(IssArtListTmp.p_Item[I]).IssuedArtPointer;
    if not (TmpIssArt.Article.p_Nature in ProdNature) then continue;
    if (TmpIssArt.ArtOnBalance = aob_DisplayOnly) then continue;
    IssArtList.AddItem(IssArtListTmp.p_Item[I]);
    ExistArtToCheck := true
  end;

  if not ExistArtToCheck then
  begin
    IssArtListTmp.Free;
    IssArtList.free;
    exit;
  end;

  MaterialsToCheck := Tlist.Create;
  InitializeListForBallance(IssArtList, ProdNature, MaterialsToCheck, false);

  ProductNatureMaterial := false;
  if ProdNature = [Ar_MatWithDet, Ar_Material] then ProductNatureMaterial := true;

  if assigned(ListOfLeadTime) then
    TmpAvailList := TList.Create;

  for i := 0 to MaterialsToCheck.Count-1 do
  begin
    Rec := MaterialsToCheck[i];
    DecimalRounding := NumberOfDecimalRounding(Rec.IssArt.Article.p_NumberOfDecimal);

    TmpIssArt := Rec.IssArt.IssuedArtPointer;

    TolleranceQuantity := rec.IssArt.Article.GetTolleranceQuantity(rec.IssArt.RequiredQty);

    // This check is done
    TmpIssArt.HaveEnoughBalance := true;
    if not Rec.IssArt.NetGroup.EnoughMatForJobOrFamily(m_reqDet.m_hdr.m_code, m_id, ProductNatureMaterial, TolleranceQuantity) then
    begin
      if Assigned(ListMatNotAvail) then ListMatNotAvail.Add(Rec.IssArt);
      Result := false;
      TmpIssArt.HaveEnoughBalance := false;
    end;

    TmpIssArt.lastTimeBalanceChecked := now;

    if not assigned(ListOfLeadTime) then continue;

    if CheckForTheGroup then
    begin
      Found := false;
      for G := 0 to MaterialsAlreadyChecked.Count-1 do
      begin
        if  (Rec.IssArt.Article.p_ArtType.p_ArtTypeCode = PTMaterialsAlreadyChecked(MaterialsAlreadyChecked[G]).ArtType)
        and (Rec.IssArt.NetGroup.m_Code = PTMaterialsAlreadyChecked(MaterialsAlreadyChecked[G]).NetGroupCode)
        and (Rec.IssArt.Article.p_ArtCode = PTMaterialsAlreadyChecked(MaterialsAlreadyChecked[G]).ArtCode) then
        begin
          Found := true;
          break;
        end;
      end;
      if Found then continue;
      New(PMaterialsAlreadyChecked);
      PMaterialsAlreadyChecked.ArtType := Rec.IssArt.Article.p_ArtType.p_ArtTypeCode;
      PMaterialsAlreadyChecked.NetGroupCode := Rec.IssArt.NetGroup.m_Code;
      PMaterialsAlreadyChecked.ArtCode := Rec.IssArt.Article.p_ArtCode;
      MaterialsAlreadyChecked.add(PMaterialsAlreadyChecked);
    end;

    ReqQty := 0;

//    if not assigned(self.m_grp) then
    if not ByGroup then
    begin
      if not Rec.IssArt.ClosedIssue then
      begin
        ReqQty := Rec.IssArt.RequiredQty - Rec.IssArt.IssuedQty - Rec.IssArt.AllocatedQty;
      end;
//      if (ProdNature <> [Ar_AddRes, Ar_AddRes_ManPower]) then
      if  (Rec.IssArt.Article.p_Nature <> Ar_AddRes)
      and (Rec.IssArt.Article.p_Nature <> Ar_AddRes_ManPower) then
      begin
        QtyInteger := Trunc(DecimalRounding * self.m_quantSched / self.m_reqDet.m_quantInit * ReqQty);
        ReqQty := QtyInteger / DecimalRounding;
      end;
      TolleranceQuantity := rec.IssArt.Article.GetTolleranceQuantity(rec.IssArt.RequiredQty);
      if TolleranceQuantity < ReqQty then
        ReqQty := ReqQty - TolleranceQuantity
      else
        ReqQty := 0;
    end
    else
    begin

      IssArtListGrpSon := TMQMIssuedArtList.Create(true);
      MaterialsToCheckGrpSon := Tlist.Create;
      StepsInGroup := Tlist.Create;

      for G := 0 to self.m_grp.m_list.Count - 1 do
      begin

        JobSon := TSCProdSched(self.m_grp.m_list[G]);

        IssArtListGrpSon.CleanList;

        JobSon.m_reqDet.m_MacSetupList.GetIssuedArtList(MacSetupRec, IssArtListGrpSon);

        MaterialsToCheckGrpSon.Clear;
       //Select the materials to check
        InitializeListForBallance(IssArtListGrpSon, ProdNature, MaterialsToCheckGrpSon, false);

        for M := 0 to MaterialsToCheckGrpSon.Count - 1 do
        begin

          ReqQtyTemp := 0;
          RecGrp := MaterialsToCheckGrpSon[M];
          DecimalRounding := NumberOfDecimalRounding(RecGrp.IssArt.Article.p_NumberOfDecimal);

          if (RecGrp.IssArt.Article.p_ArtType = Rec.IssArt.Article.p_ArtType) and
             (RecGrp.IssArt.NetGroup.m_Code = Rec.IssArt.NetGroup.m_Code) and
             (RecGrp.IssArt.Article.p_ArtCode = Rec.IssArt.Article.p_ArtCode) then
          begin

            if not RecGrp.IssArt.ClosedIssue then
            begin
              ReqQtyTemp := RecGrp.IssArt.RequiredQty - RecGrp.IssArt.IssuedQty - RecGrp.IssArt.AllocatedQty;
            end;

            //if (ProdNature <> [Ar_AddRes, Ar_AddRes_ManPower]) then
            if (Rec.IssArt.Article.p_Nature <> Ar_AddRes)
                and (Rec.IssArt.Article.p_Nature <> Ar_AddRes_ManPower) then
            begin
              QtyInteger := Trunc(DecimalRounding * JobSon.m_quantSched / JobSon.m_reqDet.m_quantInit * ReqQtyTemp);
              ReqQtyTemp := QtyInteger / DecimalRounding;
            end;

            Found := false;
            for T := 0 to StepsInGroup.Count - 1 do
            begin
              PStepsInGroup := PTStepsInGroup(StepsInGroup[T]);
              if (PStepsInGroup.Step = Self.m_reqDet.m_code) and (PStepsInGroup.Request = Self.m_reqDet.m_hdr.m_code) then
              begin
                Found := true;
                PStepsInGroup.ReqQty := PStepsInGroup.ReqQty + ReqQtyTemp;
                break
              end;
            end;
            if not Found then
            begin
              New(PStepsInGroup);
              PStepsInGroup.Request := Self.m_reqDet.m_hdr.m_code;
              PStepsInGroup.Step    := Self.m_reqDet.m_code;
              PStepsInGroup.ReqQty  := ReqQtyTemp;
              PStepsInGroup.Tollerance := rec.IssArt.Article.GetTolleranceQuantity(RecGrp.IssArt.RequiredQty);
              StepsInGroup.add(PStepsInGroup)
            end;

          end;
        end;

      end;

      for T := 0 to StepsInGroup.Count - 1 do
      begin
        PStepsInGroup := PTStepsInGroup(StepsInGroup[T]);
        if PStepsInGroup.Tollerance < PStepsInGroup.ReqQty then
          ReqQty := ReqQty + PStepsInGroup.ReqQty - PStepsInGroup.Tollerance;
        Dispose(PTStepsInGroup(StepsInGroup[T]));
      end;
      StepsInGroup.Free;

    end;

    if (ReqQty < 0) then
       ReqQty := 0;

    if Assigned(self.m_grp) then
      Rec.IssArt.NetGroup.GetListNotAvailPos(self.m_grp.m_list,m_Id,TmpAvailList, Rec, ReqQty, Rec.IssArt.Article.p_StdPurcOrProdTime)
    else
      Rec.IssArt.NetGroup.GetListNotAvailPos(nil,m_Id,TmpAvailList, Rec, ReqQty, Rec.IssArt.Article.p_StdPurcOrProdTime);

  end;

  IssArtListTmp.Free;
  IssArtList.free;

  if not Assigned(ListOfLeadTime) then
  begin
    for i := 0 to MaterialsToCheck.Count -1 do
      Dispose(MaterialsToCheck.Items[i]);
    MaterialsToCheck.Free;
    exit;
  end;

  TmpAvailList.Sort(SortAvailList);

  LastStatus := false;
  RecNoMat := nil;
  HighestPurcOrProdTime := 0;
//  HigestDueDate := 0;
  FoundNotAvailbleMatAndNoLeadTime := false;
  CheckPurchaseOrderLeadTime := false;

  if TmpAvailList.Count > 0 then
  begin
    New(RecNoMat);
    RecNoMat.m_start := 0;
    RecNoMat.m_end   := 0;
    RecNoMat.m_StdPurcOrProdTime := 0;
    ListOfLeadTime.Add(RecNoMat);
  end;

  for i := 0 to TmpAvailList.Count -1 do
  begin
    AvaliRec := TmpAvailList[i];
    AvaliRec.LocRec.LastAvail := AvaliRec.Avail;

    if AvaliRec.StdPurcOrProdTime > 0 then
       CheckPurchaseOrderLeadTime := true;

    if (not AvaliRec.Avail) and (AvaliRec.StdPurcOrProdTime > HighestPurcOrProdTime) then
       HighestPurcOrProdTime := AvaliRec.StdPurcOrProdTime;

//    if AvaliRec.Avail and (AvaliRec.date > 0) and (AvaliRec.date > HigestDueDate) then
//      HigestDueDate := AvaliRec.date;

    if not FoundNotAvailbleMatAndNoLeadTime and not AvaliRec.Avail and (AvaliRec.StdPurcOrProdTime = 0) then
      FoundNotAvailbleMatAndNoLeadTime := true;

    AllTrue := true;

    for j := 0 to MaterialsToCheck.Count-1 do
    begin
      Rec := MaterialsToCheck[j];
      if not Rec.LastAvail then
      begin
        AllTrue := false;
        break
      end;
    end;

    if LastStatus then //Searching for a Negative front
    begin
      if not AllTrue then
      begin
        New(RecNoMat);
        RecNoMat.m_start := AvaliRec.Date;
        RecNoMat.m_end := AvaliRec.Date;
        RecNoMat.m_StdPurcOrProdTime := AvaliRec.StdPurcOrProdTime;
        ListOfLeadTime.Add(RecNoMat);
        LastStatus := false
      end;
    end else  //Searching for a Positive front
    begin
      if AllTrue then
      begin
        RecNoMat.m_end := AvaliRec.Date;
        RecNoMat.m_StdPurcOrProdTime := AvaliRec.StdPurcOrProdTime;
        LastStatus := true
      end;
    end;
  end;

  if not LastStatus
  and Assigned(RecNoMat) then
  begin
    RecNoMat.m_end := 90000;
//    if HigestDueDate > 0 then
//      CheckPurchaseOrderLeadTime := false;
  end;

  for i := 0 to TmpAvailList.Count -1 do
    Dispose(TmpAvailList.Items[i]);
  TmpAvailList.Free;
  TmpAvailList := nil;

  if assigned(IssArtListGrpSon) then
     IssArtListGrpSon.Free;

  if assigned(MaterialsToCheckGrpSon) then
  begin
    for i := 0 to MaterialsToCheckGrpSon.Count -1 do
      Dispose(MaterialsToCheckGrpSon.Items[i]);
    MaterialsToCheckGrpSon.Free;
  end;

  for i := 0 to MaterialsToCheck.Count -1 do
    Dispose(MaterialsToCheck.Items[i]);
  MaterialsToCheck.Free;

  if not CheckPurchaseOrderLeadTime then exit;
  if FoundNotAvailbleMatAndNoLeadTime then exit;

  for I := 0 to ListOfLeadTime.count - 1 do
  begin
    RecNoMat := PTRecNoMatDate(ListOfLeadTime[I]);

//    if (HigestDueDate > 0) then
//      RecNoMat.m_end := HigestDueDate;
    RecNoMat.m_StdPurcOrProdTime := HighestPurcOrProdTime;

    if RecNoMat.m_StdPurcOrProdTime > 0 then
    begin
      if Trunc(now + RecNoMat.m_StdPurcOrProdTime) < RecNoMat.m_end then
      begin
        if RecNoMat.m_end <= 90000 then
        begin
          RecNoMat.m_startStdPurcOrd := Trunc(now + RecNoMat.m_StdPurcOrProdTime);
          RecNoMat.m_EndStdPurcOrd := RecNoMat.m_end;
          RecNoMat.m_end :=  RecNoMat.m_startStdPurcOrd
        end;
      end;
    end;

  end;

end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetRscCode: string;
begin
  if (m_ProgType = '')
  or (m_ProgRsc = '') then
    Result := m_rscCode
  else
    Result := m_ProgRsc;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetRscCode(RscCode: string);
begin
//  Assert(m_ProgType = '');  // avi
  m_rscCode := RscCode;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetOldRscCode : string;
begin
  Result := m_OldrscCode;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetOldRscCode(OldRscCode: string);
begin
  m_OldrscCode := OldRscCode;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetQuantManualChg(ManualChange: double);
begin
  m_manualChange := ManualChange;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetQuantManualChg: double;
begin
  result := m_manualChange;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetQtyChgSchedNet(ManualChange: double);
begin
  m_QtyChgSchedNet := m_quantSched + m_manualChange;// - m_NetQuantity;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetQtyChgSchedNet: double;
begin
  result := m_quantSched + m_manualChange;// - m_NetQuantity;//m_QtyChgSchedNet;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetProgQtyToDate;
begin
  m_QtyProgToDate := p_sc.GetJobQtyAtDate(m_Id, nil, now);
  m_pcntOfInitQty := ( m_QtyProgToDate/m_quantSched)*100;
end;


//----------------------------------------------------------------------------//

function TSCProdSched.GetPrevStepToSched(Step : integer) : TSCProdReqDet;
begin
  Result := m_reqDet.m_hdr.GetPrecStepToSched(step);
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetNextStepToSched(Step : integer) : TSCProdReqDet;
begin
  Result := m_reqDet.m_hdr.GetNextStepToSched(Step);
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.UpdateBalanceIssues(VisResPtr: pointer; CalcMat : boolean);
var
 // dRatioPrevStep,
  Dur : double;
  TempCurQty, TempRemainQty : currency;
  TempCurrentDate, TempEndingDate : TDate;
  TempDateTime : TDateTime;
  i, ii, J : integer;
  Res : TMQMRes;
  OvlpRule : TMQMOvlpRule;
  MacSetup: TMQMMachineSetup;
  MacSetupRec: TMacSetup;
  IssArt: PTIssuedArt;
  OvlpRuleDet: PTOvlpRuleDet;
  ProdArt: PTProdArt;
  StartDTime, EndDTime, AddResStDate, AddResEdDate : TDateTime;
  MacSetupList: TList;
  isDefault: boolean;
  QtyInteger : Integer;
  ActArea    : TMqmActArea;
  TempRecDownTime: PTRecCalDownTime;
  TmpQty, Setup, Execution : double;
  TempQtyCurrency : Currency;
//  Year,Month,Day,Hour,Minute,Second,MilliSecond : Word;
  RequiredQty, Qty1, Qty2 : currency;
  Duration : double;
  DecimalRounding : Integer;

  function GetHoursTillEndDayOrJob(RefDate : TDateTime) : double;
  var
    TempEndDateTime : TDateTime;
    Cal: TPGCALObj;
    ActArea:  TMqmActArea;
    Year,Month,Day,Hour,Minute,Second,MilliSecond : Word;
  begin
    Result := -1;
    if not Assigned(m_srvPtr) then exit;
//    DecodeDateTime(RefDate,Year,Month,Day,Hour,Minute,Second,MilliSecond);
//    Hour := 23;
//    Minute := 59;
//    Second := 00;
//    MilliSecond := 00;
//    TempEndDateTime := EncodeDateTime(Year, Month, Day, Hour, Minute, Second, MilliSecond);
    TempEndDateTime := trunc(RefDate) + 1;
    if p_schedEnd < TempEndDateTime then TempEndDateTime := p_schedEnd;
    ActArea := TMqmActArea(m_srvPtr);
    Cal := ActArea.GetCalendar;
    Result := trunc(cal.DiffWH(RefDate, TempEndDateTime , ActArea.m_CrossDownTmList)*3600)/60;
  end;

begin
  Res := TMqmRes(TMQMVisibleRes(VisResPtr).p_father);
  OvlpRule := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);

  if m_reqDet.m_hdr.GetPrecStepToSched(m_reqDet.m_code) <> nil then
  begin
    if Assigned(m_srvPtr) then
    begin
      StartDTime   := p_StartWithMat;
      setUp        := m_supMinReal - m_supMinOvlp; // eran fix 30/8/2007;
      Execution    := p_exeMin;
      CalculateIssuesPrevStep(VisResPtr, StartDTime, true, true, Setup, Execution, TmpQty);
    end;
  end;

  if m_reqDet.m_stepClosed then exit;
  if not CalcMat then exit;

  MacSetupRec.WrkCtrCode       := TMQMWrkctr(Res.p_WrkCtr).p_WrkCtrCode;
  MacSetupRec.ResCat           := Res.m_ResCat.p_ResCatCode;
  MacSetupRec.ResCode          := p_rscCode;
  MacSetupRec.MachineSetupCode := m_MachSetupCode;

  MacSetupList := TList.Create;

  m_reqDet.m_MacSetupList.GetMacSetup(MacSetupRec, MacSetupList);

  for i := 0 to MacSetupList.Count-1 do
  begin
    MacSetup := MacSetupList[i];

    if not Assigned(MacSetup) then exit;

    for ii := 0 to MacSetup.m_IssuedArtList.p_count-1 do
    begin
      IssArt := MacSetup.m_IssuedArtList.p_Item[ii];
      DecimalRounding := NumberOfDecimalRounding(IssArt.Article.p_NumberOfDecimal);

      if IssArt.ArtOnBalance = aob_DisplayOnly then
        continue;
      if IssArt.ClosedIssue then continue;

      RequiredQty := IssArt.RequiredQty;
      // If tool or manpower and batch type , we write the consumption only to one id, for convinience, we write to the smallest
      // It does not handle continues group with sequences inside
      if Assigned(m_grp)
      and ((m_reqDet.m_stepType = CST_batch) or (m_reqDet.m_batch_ContinuesTime))
      and ((IssArt.Article.p_Nature = Ar_AddRes) or (IssArt.Article.p_Nature = Ar_AddRes_ManPower)) then
      begin
        QtyInteger := trunc(DecimalRounding*IssArt.RequiredQty/m_grp.m_list.Count);
        RequiredQty := QtyInteger / DecimalRounding;
        if m_grp.GetMinIdInGroup = m_id then
        begin
          RequiredQty := RequiredQty + (IssArt.RequiredQty - (RequiredQty * m_grp.m_list.Count));
        end;
      end;
      if RequiredQty = 0 then
        continue;

      case IssArt.Article.p_Nature  of
        Ar_NotBalance : Continue;
        Ar_AddRes, Ar_AddRes_Capacity :
          begin

            if IssArt.Article.p_Nature = Ar_AddRes_Capacity then
            begin
              RequiredQty := DecimalRounding * self.m_quantSched / m_reqDet.m_quantInit * IssArt.RequiredQty;
              QtyInteger := trunc(RequiredQty);
              RequiredQty := QtyInteger / DecimalRounding;
            end;

            if (issart.Article.p_AddResStart = Ar_Day) then
            begin
              AddResStDate := GetAddResStDate(Ar_Exec, 0);
              TempCurrentDate := trunc(AddResStDate);
              TempEndingDate := trunc(p_schedEnd);
              if TempEndingDate < TempCurrentDate then
                continue;
              TempRemainQty := RequiredQty;
              Dur := GetHoursTillEndDayOrJob(AddResStDate);
              while true do
              begin
                if TempCurrentDate = TempEndingDate then
                begin
                if dur < 1 then // If dur < 1 minute - because of inaccuracy - give ignore the remaining
                  TempRemainQty := 0;
                  Qty1 := TempRemainQty;
                  QtyInteger := trunc(Qty1 * DecimalRounding);
                  Qty1 := QtyInteger / DecimalRounding;
                end
                else
                begin
                  TempRemainQty := TempRemainQty - (Dur / p_exeMin * RequiredQty);
                  QtyInteger := trunc(DecimalRounding * (Dur / p_exeMin) * RequiredQty);
                  TempCurQty := QtyInteger / DecimalRounding;
                  Qty1 := TempCurQty;
                end;
                if (Qty1 > 0) then
                begin
                  TempDateTime := TempCurrentDate;
                  BalIssueWritingForMat(IssArt.NetGroup, bt_Issue,
                    GetAddResStDate(issart.Article.p_AddResStart, TempDateTime), 0, Qty1);
                  BalIssueWritingForMat(IssArt.NetGroup, bt_Entry,
                    GetAddResEndDate(issart.Article.p_AddResEnd, TempDateTime), 0, Qty1);
                end;
                if TempCurrentDate = TempEndingDate then
                begin
                  Break;
                end;
                TempCurrentDate := TempCurrentDate + 1;
                TempDateTime := TempCurrentDate;
                Dur := GetHoursTillEndDayOrJob(TempDateTime)
              end;
              continue;
            end;

            AddResStDate := GetAddResStDate(issart.Article.p_AddResStart, 0);
            AddResEdDate := GetAddResEndDate(issart.Article.p_AddResEnd, 0);
            if AddResStDate = AddResEdDate then continue;
            BalIssueWritingForMat(IssArt.NetGroup, bt_Issue,AddResStDate, 0, RequiredQty);
			      AddResEdDate := AddResEdDate + (issart.Article.P_HoursToDownFromMachine/24);
            BalIssueWritingForMat(IssArt.NetGroup, bt_Entry,AddResEdDate, 0, RequiredQty);
            Continue;
          end;


        Ar_AddRes_ManPower :
           begin
             AddResStDate := GetAddResStDate(issart.Article.p_AddResStart, 0);
             AddResEdDate := GetAddResEndDate(issart.Article.p_AddResEnd, 0);
             BalIssueWritingForMat(IssArt.NetGroup, bt_Issue, AddResStDate, 0, RequiredQty);
             BalIssueWritingForMat(IssArt.NetGroup, bt_Entry, AddResEdDate, 0, RequiredQty);
             ActArea      := TMqmActArea(TMqmVisibleRes(VisResPtr).FindActForDate(AddResStDate));
             if Assigned(ActArea) then
             begin
               if Assigned(ActArea.m_CrossDownTmList) then
                 for J := 0 to ActArea.m_CrossDownTmList.count - 1 do
                 begin
                   TempRecDownTime := ActArea.m_CrossDownTmList[j];
                   if (TempRecDownTime.DowntimeStart >= AddResStDate) and (TempRecDownTime.DowntimeEnd <= AddResEdDate) then
                   begin
                     BalIssueWritingForMat(IssArt.NetGroup, bt_Entry, TempRecDownTime.DowntimeStart, 0, RequiredQty);
                     BalIssueWritingForMat(IssArt.NetGroup, bt_Issue, TempRecDownTime.DowntimeEnd ,0, RequiredQty);
                   end;
                 end;
             end;
             Continue;
           end;

      end;

      // handle materiales

      OvlpRuleDet := OvlpRule.GetDet(IssArt.Article.p_ArtType.p_ArtTypeCode, IssArt.IssueTransType);

      if not Assigned(OvlpRuleDet)
      or not OvlpRuleDet.SearchBalance then
        Continue;

      if ((IssArt.SeqIssuedTo = '' )
           Or (IssArt.SeqIssuedTo <> '')) then
     // Eran *** The condition "Or (IssArt.SeqIssueTo <> ''))" was added
     // Temporarily because the else that was meant to be issue per sequence is
     // completely different the the origional analysis and must be re-written !!

      begin
        TempQtyCurrency := (DecimalRounding * self.m_quantSched / m_reqDet.m_quantInit * IssArt.RequiredQty);
        TempQtyCurrency := trunc(TempQtyCurrency);
        Qty1 := TempQtyCurrency / DecimalRounding;
        TempQtyCurrency := (DecimalRounding * self.m_quantSched / m_reqDet.m_quantInit) * (IssArt.IssuedQty + IssArt.AllocatedQty);
        TempQtyCurrency := trunc(TempQtyCurrency);
        if self.m_quantSched <> m_reqDet.m_quantInit then
          TempQtyCurrency := TempQtyCurrency + 1;
        Qty2 := TempQtyCurrency / DecimalRounding;

        if Assigned(m_grp) and (m_reqDet.m_stepType = CST_Continuous) and (not m_reqDet.m_batch_ContinuesTime) then
        begin
          StartDTime := m_grp.p_StartWithMat;
          EndDTime := m_grp.p_schedEnd;
          Duration := m_grp.p_exeMin;
        end
        else
        begin
          StartDTime := p_StartWithMat;
          EndDTime := p_schedEnd;
          Duration := p_exeMin;
        end;
        CalculateIssues( VisResPtr, IssArt.NetGroup,
                         OvlpRuleDet.WaitEntireMatQty, OvlpRuleDet.UpdEveryHours,
                         StartDTime, EndDTime,
                         Duration, OvlpRuleDet.MinMatQty, 0, qty1, qty2, p_quantSched,
                         1, 0, nil)
      end
      else
      begin
        ProdArt := m_reqDet.m_hdr.m_ProdArtList.FindProdArtBySeq(IssArt.SeqIssuedTo);

        if not Assigned(ProdArt) then Continue;

        StartDTime := p_sc.GetDateToCompleteQty(m_Id, VisResPtr, ProdArt.StartQty);
        EndDTime := p_sc.GetDateToCompleteQty(m_Id, VisResPtr, ProdArt.EndQty);

        CalculateIssues( VisResPtr, IssArt.NetGroup,
                         OvlpRuleDet.WaitEntireMatQty, OvlpRuleDet.UpdEveryHours,
                         StartDTime, EndDTime,
                         p_exeMin, OvlpRuleDet.MinMatQty, ProdArt.StartQty ,
                         IssArt.RequiredQty, (IssArt.IssuedQty + IssArt.AllocatedQty), p_quantSched,
                         1, 0, nil)
      end;
    end;
  end;
  MacSetupList.Clear;
  MacSetupList.Free;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.CalculateIssuesPrevStep(VisResPtr: Pointer; dtStartDTime : TDateTime;
                           dWriteBalance, dConsiderLeadTime : Boolean; setUp, Execution : Double; var FirstBalanceQuantity : double);
// dtStartDTime is the start time already need materials
var
  LeadTime: double;
  RatioPrevStep : Double;
  StartQuantity: double;
  RemainingQuantity : double;
  QuantityPerUpdate : double;
  UpdateMinutes: double;
  CurrentDate, TmpDateOfSt : TDateTime;
  TmpInteger : Longint;
  OvlpRule : TMQMOvlpRule;
  Res : TMQMRes;
  isDefault: boolean;
  TmpDur : double;
  TmpQty : double;
  Cal: TPGCALObj;
  ActArea:  TMqmActArea;

begin
  cal := nil;
  FirstBalanceQuantity := 0;
  ClearBalancePoints;
  Res := TMqmRes(TMQMVisibleRes(VisResPtr).p_father);
  ActArea := TMqmActArea(TMqmVisibleRes(VisResPtr).FindActForDate(dtStartDTime));
  if assigned(ActArea) then Cal := ActArea.GetCalendar;

  OvlpRule := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);

  RatioPrevStep := m_reqDet.m_hdr.GetPrecStepToSched(m_reqDet.m_code).m_quantFinl / m_reqDet.m_quantInit;
  if RatioPrevStep = 0 then RatioPrevStep := 1;

  LeadTime := 0;
  if dConsiderLeadTime then LeadTime := m_reqDet.p_LeadTimePrev * p_qtyChgSchedNet + m_reqDet.p_LeadTimePrevBatch;
  dtStartDTime := dtStartDTime - LeadTime / 60 / 24;
  LeadTime := 0;

  UpdateMinutes := OvlpRule.m_UpdIssFromPrvStpHour * 60;
  CurrentDate := dtStartDTime;

  if  (not assigned(OvlpRule)) or (not assigned(ActArea)) or
      OvlpRule.m_WaitEntirePrvQty or
      (m_reqDet.m_stepType = CST_batch) or
      (OvlpRule.m_MinQtyFromPrvStp >= p_qtyChgSchedNet) or
      (UpdateMinutes = 0) or
      (UpdateMinutes >= Execution) then
  begin
    TmpQty := trunc(100 * p_qtyChgSchedNet * RatioPrevStep);
    TmpQty := TmpQty / 100;
    FirstBalanceQuantity := TmpQty;
    CalculateIssuesPrevStepWriting(TmpQty, (CurrentDate - LeadTime/60/24), dWriteBalance);
    exit;
  end;

  QuantityPerUpdate := (p_qtyChgSchedNet / Execution) * UpdateMinutes;

  StartQuantity := OvlpRule.m_MinQtyFromPrvStp;
  if StartQuantity = 0 then StartQuantity := QuantityPerUpdate;

  TmpQty := trunc(100 * StartQuantity * RatioPrevStep);
  TmpQty := TmpQty / 100;

  FirstBalanceQuantity := TmpQty;
  CalculateIssuesPrevStepWriting(TmpQty, (CurrentDate - LeadTime/60/24), dWriteBalance);

  TmpDur := (Setup + Execution*StartQuantity/p_qtyChgSchedNet) / 60;
  TmpDateOfSt := dtStartDTime;
  cal.OfsByWH(TmpDur, true, TmpDateOfSt, CurrentDate, ActArea.m_CrossDownTmList);

  RemainingQuantity := p_qtyChgSchedNet - StartQuantity;

  if QuantityPerUpdate < StartQuantity then QuantityPerUpdate := StartQuantity;
  if QuantityPerUpdate > StartQuantity then
  begin
    TmpInteger := trunc(QuantityPerUpdate / StartQuantity);
    QuantityPerUpdate := TmpInteger * StartQuantity;
  end;

  while true do
  begin

   if RemainingQuantity <= QuantityPerUpdate then
   begin
     TmpQty := trunc(100 * RemainingQuantity * RatioPrevStep);
     TmpQty := TmpQty / 100;
     CalculateIssuesPrevStepWriting(TmpQty, (CurrentDate - LeadTime/60/24), dWriteBalance);
     break;
   end;

   TmpQty := trunc(100 * QuantityPerUpdate * RatioPrevStep);
   TmpQty := TmpQty / 100;
   CalculateIssuesPrevStepWriting(TmpQty, (CurrentDate - LeadTime/60/24), dWriteBalance);

   RemainingQuantity := RemainingQuantity - QuantityPerUpdate;
   TmpDur := (Execution*QuantityPerUpdate/p_qtyChgSchedNet) / 60;
   cal.OfsByWH(TmpDur, true, CurrentDate, CurrentDate, ActArea.m_CrossDownTmList);

  end;

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.CalculateIssuesPrevStepWriting(BWQuantity : double; BWDate: TDateTime; BWWriteBalance : Boolean);

begin

  if BWWriteBalance then
     m_reqDet.m_hdr.m_RequestBalList.AddBalance(m_id, m_reqDet.m_prevStep, bt_Issue, BWDate, BWQuantity)
   else
     AddToBalancePoints(m_id, bt_Issue, BWDate, BWQuantity);

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.CalculateIssues(Res: Pointer; NetGroup: TMQMNetGroup;
                                       bWaitAllQty: boolean;
                                       iUpdateHours: integer;
                                       dtStartDTime, dtEndDTime: TDateTime;
                                       ExecusionMinutes, dMinQty, dStartQty, dQuantity, dQuantityIssued, dSchedQty,
                                       dRadioToPrevStep, dLeadTime:Double; ProductBalanceList : Tlist);
var
  ResBatchType: boolean;
  dRemainQtyIss: double;
  dTmpIssBalance, dIssBalance, dPrevBalance: double;
  DateTimeBalance, dtNextDateTime, TmpDateOfSt: TDateTime;
  LocUpdDays: double;
  Cal: TPGCALObj;
  ActArea: TMqmActArea;
  BalanceType: CBalanceType;
  Execusion : double;
begin
//  dSchedQty      := p_quantSched;
  dRemainQtyIss  := dQuantityIssued;
  Execusion := ExecusionMinutes / 60;

  BalanceType := bt_issue;
  if dQuantity < 0 then
  begin
    dQuantity := dQuantity * -1;
    BalanceType := bt_Entry;
  end;

  ResBatchType := TMqmRes(TMQMVisibleRes(Res).p_father).p_ProcessType = CST_batch;

  Cal := nil;
  ActArea := nil;
  if Assigned(m_srvPtr)
  and (Res = TMqmActArea(m_srvPtr).p_Father) then
  begin
    Cal := TMQMVisibleRes(Res).GetCalendar;
    ActArea := TMqmActArea(m_srvPtr);
  end
  else
  begin
  if assigned(Res) then
    begin
      ActArea := TMqmActArea(TMQMVisibleRes(Res).p_ActArea[0]);
      Cal := TMQMVisibleRes(Res).GetCalendar;
    end;
  end;

  LocUpdDays := 1 / 24 * iUpdateHours;
//  TmpDateOfSt := dtStartDTime; Eran 18/04/2019
  dtNextDateTime := dtEndDTime; // Eran 18/04/2019
  if (Execusion - iUpdateHours) > 0 then // Eran 18/04/2019
  begin
    if Assigned(Cal) then
//    Cal.OfsByWH(iUpdateHours, true, TmpDateOfSt, dtNextDateTime, ActArea.m_CrossDownTmList) Eran 18/04/2019
      Cal.OfsByWH((iUpdateHours - Execusion) , false, dtEndDTime, dtNextDateTime, ActArea.m_CrossDownTmList)
    else
//      dtNextDateTime := dtStartDTime + LocUpdDays; Eran 18/04/2019
      dtNextDateTime := dtEndDTime - ((Execusion - iUpdateHours) / 1 / 24); // Eran 18/04/2019
  end;

  if ( bWaitAllQty or ResBatchType ) or
     ( dMinQty >= dQuantity ) or
     ( dtNextDateTime >= dtEndDTime ) or
     ( LocUpdDays = 0 ) then
  begin
    DateTimeBalance := dtStartDTime - ( dSchedQty * dLeadTime )/24/60;
    dIssBalance     := dQuantity;

    BalanceIssueWriting(ActArea, NetGroup, DateTimeBalance, LocUpdDays,
                        dIssBalance, 0, dRemainQtyIss, dRadioToPrevStep, BalanceType, ProductBalanceList, dtEndDTime);
  end else
  begin
//eran    dPrevBalance := dMinQty;
    dPrevBalance := 0; //eran
    dIssBalance  := 0; //for the warning is correct??

    if dMinQty > 0 then
    begin
      DateTimeBalance := dtStartDTime - ( dSchedQty * dLeadTime )/24/60;
      dIssBalance := dMinQty;
      //eran dPrevBalance := dIssBalance;
      dRemainQtyIss := BalanceIssueWriting(ActArea, NetGroup, DateTimeBalance, LocUpdDays, dIssBalance,
                                           dPrevBalance, dRemainQtyIss,dRadioToPrevStep, BalanceType, ProductBalanceList,
                                           dtEndDTime);
      dPrevBalance := dIssBalance; //eran
    end;

    DateTimeBalance := dtStartDTime; // + setupTime Need Material
//SavCal    dtNextDateTime := dtStartDTime + LocUpdDays; // + setupTime Need Material

    while not ((dtNextDateTime >= dtEndDTime) or (dIssBalance >= dQuantity))   do
    begin
      if Assigned(Cal) then
      begin
        DateTimeBalance := dtNextDateTime;
//        Cal.OfsByWH(iUpdateHours, true, DateTimeBalance, DateTimeBalance, ActArea.m_CrossDownTmList); // + setupTime Need Material  //SavCal
        Cal.OfsByWH(iUpdateHours, true, dtNextDateTime, dtNextDateTime, ActArea.m_CrossDownTmList); // + setupTime Need Material  //SavCal
      end else
      begin
        DateTimeBalance := DateTimeBalance + LocUpdDays;
        dtNextDateTime  := dtNextDateTime +  LocUpdDays;
      end;

      if dtNextDateTime >= dtEndDTime then
        dIssBalance := dQuantity
      else
      begin
        dIssBalance := (p_sc.GetJobQtyAtDateForMaterials(m_id, res, dtStartDTime, DateTimeBalance, dtEndDTime, dSchedQty) - dStartQty)/
                       dSchedQty * dQuantity;
        if dMinQty > 0 then
        begin
          dTmpIssBalance := Trunc(dIssBalance / dMinQty);
          dIssBalance    := (dTmpIssBalance + 1) * dMinQty;

          if dIssBalance > dQuantity then
            dIssBalance := dQuantity;
        end;
      end;

      dRemainQtyIss := BalanceIssueWriting(ActArea, NetGroup, DateTimeBalance-(dSchedQty*dLeadTime)/24/60, LocUpdDays, dIssBalance,
                                           dPrevBalance, dRemainQtyIss, dRadioToPrevStep, BalanceType, ProductBalanceList,
                                           dtEndDTime);
      dPrevBalance := dIssBalance;

    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.BalanceIssueWriting(ActArea: Pointer; NetGroup: TMQMNetGroup;
                                 dtDateTimeBalance : TDateTime; UpdateHours,
                                 dIssueBalance, dPrevBalance,dRemainQtyIssued,
                                 dRadioToPrevStep: Double; BalanceType: CBalanceType; ProductBalanceList: Tlist;
                                 EndDate : TDateTime): Double;
var
  dQtyBalance : double;
  dtRoundDtBalance, dtDtTmEndBalance : TDateTime;
  Hour,Min,Sec,MSec: Word;
  ProductBalance : PTProductBalance;
  PrevBalance : Double;
begin

  dQtyBalance := dIssueBalance - dPrevBalance;

  if dQtyBalance > 0 then
  begin
    if dRemainQtyIssued >= dQtyBalance then
    begin
      dRemainQtyIssued := dRemainQtyIssued - dQtyBalance;
      result := dRemainQtyIssued;
      Exit;
    end;

    dQtyBalance := dQtyBalance - dRemainQtyIssued;
    dRemainQtyIssued := 0;
    dQtyBalance := dQtyBalance * dRadioToPrevStep;

    dtRoundDtBalance := dtDateTimeBalance;

    DecodeTime(dtRoundDtBalance,Hour,Min,Sec,MSec);

    dtRoundDtBalance := Trunc(dtRoundDtBalance) + EncodeTime(Hour,Min,0,0);

    if UpdateHours = 0 then
      dtDtTmEndBalance := EndDate
    else

    if Assigned(ActArea) then
      TMqmActArea(ActArea).GetCalendar.OfsByWH(UpdateHours, true, dtRoundDtBalance, dtDtTmEndBalance, TMqmActArea(ActArea).m_CrossDownTmList) // + setupTime Need Material  //SavCal
    else
      dtDtTmEndBalance := dtRoundDtBalance + UpdateHours;

    if Assigned(ProductBalanceList) then
    begin
      PrevBalance := 0;
      if ProductBalanceList.Count > 0 then
      begin
        ProductBalance := ProductBalanceList[ProductBalanceList.Count - 1];
        PrevBalance := ProductBalance.UpToDateQuantity;
      end;
      new(ProductBalance);
      ProductBalance.UpToDateQuantity := PrevBalance + dQtyBalance;
      ProductBalance.Date := dtDtTmEndBalance;
      ProductBalanceList.Add(ProductBalance);
    end
    else
    BalIssueWritingForMat(NetGroup, BalanceType, dtRoundDtBalance,
                          dtDtTmEndBalance, dQtyBalance);
  end;

  result := dRemainQtyIssued;

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.BalIssueWritingForMat(NetGroup: TMQMNetGroup; BalanceType: CBalanceType;
                                           dtStBalance, dtEndBalance, dQty: double);
begin
  NetGroup.AddBalance(m_Id, BalanceType, dtStBalance, dtEndBalance, dQty);
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.BalIssueWritingForStep(BalanceType: CBalanceType;
                                              dtBalance, dQty: double);
var
  Step: integer;
begin
  case BalanceType of
    bt_Expiration,
    bt_Issue,
    bt_IssueByAlloc : Step := m_reqDet.m_prevStep;
  else
    Step := m_reqDet.m_code;
  end;

  m_reqDet.m_hdr.m_RequestBalList.AddBalance(m_id, Step, BalanceType, dtBalance, dQty);
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetAddResStDate(DateType: ArResTime; ReferenceDate : TDateTime): TDateTime;
var
  ActArea: TMqmActArea;
  Cal: TPGCALObj;
  TmpDateTime: TDateTime;
  Year, Month, Day: Word;
begin
  case DateType of
    Ar_No:          Result := 0;
    Ar_NoMatSetup:  Result := p_schedStart;
    Ar_MatSetup:    Result := p_StartWithMat;
    Ar_Exec:        begin
                      if (not Assigned(m_srvPtr)) or (p_sc.IsProgressed(m_Id) <> prg_none) then
                      begin
                        Result := p_schedStart;
                        Exit
                      end;
                      ActArea := TMqmActArea(m_srvPtr);
                      Cal := ActArea.GetCalendar;
                      TmpDateTime := p_schedStart;
                      if m_supMinReal > 0 then
                        cal.OfsByWH(m_supMinReal/60, true, TmpDateTime, Result, ActArea.m_CrossDownTmList)
                      else
                        Result := TmpDateTime;
                    end;
    Ar_Day:       begin
                      DecodeDate(ReferenceDate, Year, Month, Day);
                      Result := EncodeDate(Year, Month, Day);
                    end;

  else
    Result := 0;
  end
end;

//----------------------------------------------------------------------------//

function  TSCProdSched.GetAddResEndDate(DateType: ArResTime; ReferenceDate : TDateTime): TDateTime;
var
  ActArea: TMqmActArea;
  Cal: TPGCALObj;
  TmpDateTime: TDateTime;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
begin
  case DateType of
    Ar_No:          Result := 0;
    Ar_NoMatSetup:  Result := p_StartWithMat;
    Ar_MatSetup:    begin
                     if (not Assigned(m_srvPtr)) or (p_sc.IsProgressed(m_Id) <> prg_none) then
                     begin
                       Result := p_schedStart;
                       Exit
                     end;
                       ActArea := TMqmActArea(m_srvPtr);
                       Cal := ActArea.GetCalendar;
                       TmpDateTime := p_schedStart;
                       if m_supMinReal > 0 then
                         cal.OfsByWH(m_supMinReal/60, true, TmpDateTime, Result, ActArea.m_CrossDownTmList)
                       else
                         Result := TmpDateTime;
                    end;
    Ar_Exec:        Result := p_schedEnd;

    Ar_Day:       begin
                      AHour := 00;
                      AMinute := 00;
                      ASecond := 00;
                      AMilliSecond := 00;
                      DecodeDate(ReferenceDate, AYear, AMonth, ADay);
                      Result := 1 + EncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
                    end;
  else
    Result := 0;
  end
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetRscCode_ORIGINAL : string;
begin
  Result := m_rscCode_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetRscCode_ORIGINAL(RscCode: string);
begin
  m_rscCode_ORIGINAL := RscCode
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetAlternativeCode_ORIGINAL: string;
begin
  result := m_AlternativeCode_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetAlternativeCode_ORIGINAL(AltCode: string);
begin
  m_AlternativeCode_ORIGINAL := AltCode
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetWorkCenterCode_ORIGINAL: string;
begin
  Result := m_WorkCenterCode_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetWorkCenterCode_ORIGINAL(WcCode: string);
begin
  m_WorkCenterCode_ORIGINAL := WcCode
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetProcessCode_ORIGINAL: string;
begin
  result := m_ProcessCode_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetProcessCode_ORIGINAL(ProcessCode: string);
begin
  m_ProcessCode_ORIGINAL := ProcessCode
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetGroupCode_ORIGINAL: integer;
begin
  result := m_GroupCode_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetGroupCode_ORIGINAL(GroupCode: integer);
begin
  m_GroupCode_ORIGINAL := GroupCode
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSchedType_ORIGINAL: string;
begin
  Result := m_SchedType_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetSchedType_ORIGINAL(SchedTypeCode: string);
begin
  m_SchedType_ORIGINAL := SchedTypeCode
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetNumSubRscComponents_ORIGINAL: integer;
begin
  Result := m_NumSubRscComponents_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetNumSubRscComponents_ORIGINAL(NumOfComp: integer);
begin
  m_NumSubRscComponents_ORIGINAL := NumOfComp
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSubLinRscId_ORIGINAL: integer;
begin
  result := m_SubLinRscId_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetsubLinRscId_ORIGINAL(SubLinRsc: integer);
begin
  m_SubLinRscId_ORIGINAL := SubLinRsc
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetMachSetupCode_ORIGINAL: string;
begin
  result := m_MachSetupCode_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetMachSetupCode_ORIGINAL(MachSetupCode: string);
begin
  m_MachSetupCode_ORIGINAL := MachSetupCode
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetStartDate_ORIGINAL : TDateTime;
begin
  result := m_schedStart_ORIGINAL
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSchedStartOfJobInContGroup: TDateTime;
begin
  Result := m_SchedStartOfJobInContGroup
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetStartDate_ORIGINAL(StDate: TDateTime);
begin
  m_schedStart_ORIGINAL := StDate
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetSchedStartOfJobInContGroup(StDate: TDateTime);
begin
   m_SchedStartOfJobInContGroup := StDate;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetEndDate_ORIGINAL: TDateTime;
begin
  Result := m_schedEnd_ORIGINAL
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSchedEndOfJobInContGroup: TDateTime;
begin
  Result := m_SchedEndOfJobInContGroup;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetEndDate_ORIGINAL(EndDate: TDateTime);
begin
  m_schedEnd_ORIGINAL := EndDate
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetSchedEndOfJobInContGroup(EndDate: TDateTime);
begin
   m_SchedEndOfJobInContGroup := EndDate;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetExeMin_ORIGINAL: double;
begin
  Result := m_exeMin_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetExeMin_ORIGINAL(ExeMin: double);
begin
  m_exeMin_ORIGINAL := ExeMin;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSupMinBase_ORIGINAL: double;
begin
  Result := m_supMinBase_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetSupMinBase_ORIGINAL(SupMinBase: double);
begin
  m_supMinBase_ORIGINAL := SupMinBase
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSupMinReal_ORIGINAL: double;
begin
  result := m_supMinReal_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetSupMinReal_ORIGINAL(SupMinReal: double);
begin
  m_supMinReal_ORIGINAL := SupMinReal
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSupMinOvlp_ORIGINAL: double;
begin
  Result := m_supMinOvlp_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetSupMinOvlp_ORIGINAL(SupMinOvlp: double);
begin
  m_supMinOvlp_ORIGINAL := SupMinOvlp
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetQuantSched_ORIGINAL: double;
begin
  Result := m_quantSched_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetQuantSched_ORIGINAL(QuantSched: double);
begin
  m_quantSched_ORIGINAL := QuantSched
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetQuantManualChg_ORIGINAL: double;
begin
  result := m_manualChange_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetQuantManualChg_ORIGINAL(ManualChange: double);
begin
  m_manualChange_ORIGINAL := ManualChange
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetComment_ORIGINAL : string;
begin
  Result := m_Comment_ORIGINAL
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetLastScheudleChange : TDateTime;
var
  sc: TSCProdSched;
begin
  Result := m_CurrentSchedDate;
  if Assigned(m_grp) then
  begin
    sc := TSCProdSched(m_grp.m_list[0]);
    result := sc.m_CurrentSchedDate;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetSavedScheduleDate : TDateTime;
var
  sc: TSCProdSched;
begin
  Result := m_SavedScheduleDate;
  if Assigned(m_grp) then
  begin
    sc := TSCProdSched(m_grp.m_list[0]);
    result := sc.m_SavedScheduleDate;
  end;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetLastScheudleChange_ORIGINAL: TDateTime;
begin
  Result := m_LastScheudleChange_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetComment_ORIGINAL(Comment : string);
begin
  m_Comment_ORIGINAL := Comment;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetLearningCurve_ORIGINAL : string;
begin
  Result := m_CurveCode_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.setLearningCurve_ORIGINAL(CurveCode : string);
begin
  m_CurveCode_ORIGINAL := CurveCode
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetActualStartDate_ORIGINAL : TDateTime;
begin
  Result := m_ActualStartDate_ORIGINAL
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetActualStartDate_ORIGINAL(StDate: TDateTime);
begin
  m_ActualStartDate_ORIGINAL := StDate;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.GetActualEndDate_ORIGINAL : TDateTime;
begin
  Result := m_ActualEndDate_ORIGINAL;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.SetActualEndDate_ORIGINAL(EndDate: TDateTime);
begin
  m_ActualEndDate_ORIGINAL := EndDate;
end;

//----------------------------------------------------------------------------//

function TSCProdSched.CheckProgressed : boolean;
begin
  Result := false;
  if m_PrgSt > 0  then
     Result := true;
end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.UpdateBalanceEntries(VisResPtr: pointer; CalcMat : boolean);
var
  i : integer;
  ProdArt: PTProdArt;
  StartDTime, EndDTime: TDateTime;
  ArtStartQty, ArtEndQty, ArtProducedQty : double;
  Setup, Execution : double;
  Is_batch_ContinuesTime : boolean;
  GroupQty, JobQty, JobPercentInAGroup : double;
begin
  if GetNextStepToSched(m_reqDet.m_code) <> nil then
  begin
    if Assigned(m_srvPtr) then
    begin
      StartDTime   := p_StartWithMat;
      setUp        := m_supMinReal - m_supMinOvlp; // eran fix 30/08/07
      Execution    := p_exeMin;

      if m_ProgType <> '' then
      begin
        setUp := 0;
        Execution := GetActualTime;
      end;

      CalculateEntriesNextStep(VisResPtr, StartDTime, true, setUp, Execution);
    end;

  end else
  begin
    if not CalcMat then exit;

    Is_batch_ContinuesTime := self.m_reqDet.m_batch_ContinuesTime;
    if Is_batch_ContinuesTime and Assigned(m_grp) then
    begin
      JobQty := p_quantSched;
      GroupQty := TSCProdGroup(m_grp).p_quantSched;
      JobPercentInAGroup := JobQty / GroupQty;
    end
    else
      JobPercentInAGroup := 1;

    for i := 0 to m_reqDet.m_hdr.m_ProdArtList.p_count - 1 do
    begin
      ProdArt := PTProdArt(m_reqDet.m_hdr.m_ProdArtList.p_Item[i]);

      if (ProdArt.Article.p_Nature = Ar_NotBalance)
      or (ProdArt.ArtOnBalance = aob_DisplayOnly)
      or (prodArt.Closed)
      or (m_reqDet.m_stepClosed and (ProdArt.ArtOnBalance <> aob_ReqNumber)) then
        continue;

      ArtStartQty := ProdArt.StartQty  * p_quantSched / m_reqDet.m_quantInit;
      ArtEndQty := ProdArt.EndQty * p_quantSched / m_reqDet.m_quantInit;
      ArtProducedQty := ProdArt.ProducedQty * p_quantSched / m_reqDet.m_quantInit;
      EndDTime := p_schedEnd;
      ProduceBalanceCalc(VisResPtr, ArtStartQty, ArtEndQty, EndDTime, ProdArt.Sequence, ProdArt.NetGroup,
                         JobPercentInAGroup, ArtProducedQty);

    end;
  end;
end;
//----------------------------------------------------------------------------//

procedure TSCProdSched.CalculateEntriesNextStep(VisResPtr: Pointer; dtStartDTime : TDateTime;
                           dWriteBalance : Boolean; setUp, Execution : Double);
var
  RatioInitialToFinal, RatioFinalToInitial : Double;
  RemainingQuantity : double;
  QuantityPerUpdate : double;
  TmpQty : Double;
  FinalQuantity : Double;
  UpdateMinutes: double;
  CurrentDate, EndDate, WaitAtLeast, WaitAtMost, TmpDateOfSt : TDateTime;
  TmpInteger : Longint;
  OvlpRule : TMQMOvlpRule;
  Res : TMQMRes;
  isDefault: boolean;
  TmpDur : double;
  Cal: TPGCALObj;
  ActArea:  TMqmActArea;

begin
  cal := nil;
  ClearBalancePoints;
  Res := TMqmRes(TMQMVisibleRes(VisResPtr).p_father);
  ActArea := TMqmActArea(TMqmVisibleRes(VisResPtr).FindActForDate(dtStartDTime));
  if assigned(ActArea) then Cal := ActArea.GetCalendar;

  OvlpRule := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);

  WaitAtLeast := 0;
  WaitAtMost := 0;
  if assigned(OvlpRule) then
  begin
    if (OvlpRule.m_WaitAtLeastMin < OvlpRule.m_WaitAtMostMin) or (OvlpRule.m_WaitAtMostMin = 0) then
    begin
      WaitAtLeast := OvlpRule.m_WaitAtLeastMin/60/24;
      WaitAtMost := OvlpRule.m_WaitAtMostMin/60/24;
    end;
  end;

  RatioFinalToInitial := m_reqDet.m_quantInit / m_reqDet.m_quantFinl;
  if RatioFinalToInitial = 0 then RatioFinalToInitial := 1;
  RatioInitialToFinal := m_reqDet.m_quantFinl / m_reqDet.m_quantInit;
  if RatioInitialToFinal = 0 then RatioInitialToFinal := 1;
  TmpQty := p_qtyChgSchedNet * RatioInitialToFinal;
  FinalQuantity := trunc(100 * TmpQty) / 100;
  if FinalQuantity < TmpQty then FinalQuantity := FinalQuantity + 0.01;

  UpdateMinutes := OvlpRule.m_UpdBalEveryHour * 60;

  EndDate := dtStartDTime;
  TmpDur := (setup + execution) / 60;
  TmpDateOfSt := dtStartDTime;
  if assigned(ActArea) then cal.OfsByWH(TmpDur, true, TmpDateOfSt, EndDate, ActArea.m_CrossDownTmList);

  if (not assigned(OvlpRule)) or (not assigned(ActArea)) or
      (not OvlpRule.m_CanDeliverPartial) or
      (m_reqDet.m_stepType = CST_batch) or
      (OvlpRule.m_MinQtyPassNxtStp >= FinalQuantity) or
      (Execution = 0) or
      ((UpdateMinutes = 0) and (OvlpRule.m_UpdBalEveryQty = 0)) then
  begin
    CalculateEntriesNextStepWriting(FinalQuantity, EndDate, WaitAtLeast, WaitAtMost, dWriteBalance);
    exit;
  end;

  TmpDur := setup / 60;
  TmpDateOfSt := dtStartDTime;
  cal.OfsByWH(TmpDur, true, TmpDateOfSt, CurrentDate, ActArea.m_CrossDownTmList);

  if OvlpRule.m_MinQtyPassNxtStp < 0 then OvlpRule.m_MinQtyPassNxtStp := 0;
  if OvlpRule.m_MinQtyPassNxtStp > 0 then
  begin
   TmpDur := (Execution*(OvlpRule.m_MinQtyPassNxtStp*RatioFinalToInitial)/p_qtyChgSchedNet) / 60;
   cal.OfsByWH(TmpDur, true, CurrentDate, CurrentDate, ActArea.m_CrossDownTmList);
   CalculateEntriesNextStepWriting(OvlpRule.m_MinQtyPassNxtStp, CurrentDate, WaitAtLeast, WaitAtMost, dWriteBalance);
  end;

  RemainingQuantity := FinalQuantity - OvlpRule.m_MinQtyPassNxtStp;

  QuantityPerUpdate := OvlpRule.m_UpdBalEveryQty;
  if OvlpRule.m_UpdBalEveryQty = 0 then
    QuantityPerUpdate := trunc(100 * p_qtyChgSchedNet / Execution * UpdateMinutes * RatioInitialToFinal) / 100;

  if QuantityPerUpdate < OvlpRule.m_MinQtyPassNxtStp then QuantityPerUpdate := OvlpRule.m_MinQtyPassNxtStp;
  if (QuantityPerUpdate > OvlpRule.m_MinQtyPassNxtStp) and (OvlpRule.m_MinQtyPassNxtStp > 0) then
  begin
    TmpInteger := trunc(QuantityPerUpdate / OvlpRule.m_MinQtyPassNxtStp);
    QuantityPerUpdate := TmpInteger * OvlpRule.m_MinQtyPassNxtStp;
  end;

  while true do
  begin

    if RemainingQuantity <= QuantityPerUpdate then
    begin
      CalculateEntriesNextStepWriting(RemainingQuantity, EndDate, WaitAtLeast, WaitAtMost, dWriteBalance);
      break;
    end;

    TmpDur := (Execution*(QuantityPerUpdate*RatioFinalToInitial)/p_qtyChgSchedNet) / 60;
    cal.OfsByWH(TmpDur, true, CurrentDate, CurrentDate, ActArea.m_CrossDownTmList);
    CalculateEntriesNextStepWriting(QuantityPerUpdate, CurrentDate, WaitAtLeast, WaitAtMost, dWriteBalance);
    RemainingQuantity := RemainingQuantity - QuantityPerUpdate;

  end;

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.CalculateEntriesNextStepWriting(BWQuantity : double; BWDate : TDateTime; BWWaitAtLeast : TDateTime; BWWaitAtMost : TDateTime;  BWWriteBalance : Boolean);

begin
  if BWWaitAtMost > 0 then
  begin
    if BWWriteBalance then
    begin
      m_reqDet.m_hdr.m_RequestBalList.AddBalance(m_id, m_reqDet.m_code, bt_EntryExp, BWDate + BWWaitAtLeast, BWQuantity);
      m_reqDet.m_hdr.m_RequestBalList.AddBalance(m_id, m_reqDet.m_code, bt_Expiration, BWDate + BWWaitAtMost, BWQuantity);
    end else
    begin
      AddToBalancePoints(m_id, bt_EntryExp, BWDate + BWWaitAtLeast, BWQuantity);
      AddToBalancePoints(m_id, bt_Expiration, BWDate + BWWaitAtMost, BWQuantity);
    end;
  end else
  begin
    if BWWriteBalance then
      m_reqDet.m_hdr.m_RequestBalList.AddBalance(m_id, m_reqDet.m_code, bt_Entry, BWDate + BWWaitAtLeast, BWQuantity)
    else
      AddToBalancePoints(m_id, bt_Entry, BWDate + BWWaitAtLeast, BWQuantity);
  end;

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.ProduceBalanceCalc(VisResPtr: Pointer; StartQty, EndQty: double;
                                          EndDTime: TDateTime; Sequence: string; NetGroup: TMQMNetGroup;
                                          JobPercentInAGroup, QuantityAlreadyInStock : Double);
var
  Res: TMqmRes;
  OvlRules: TMQMOvlpRule;
  CurrentQty,
  ProducedQty,
  PreviousProdQty : double;
  CurrentDTime,
  ProducedDTime: TDateTime;
  ResBatchType : boolean;
  isDefault: boolean;
  ActArea: TMqmActArea;
  Cal: TPGCALObj;
  LocUpdDays: double;
begin
  ProducedQty := 0;
  PreviousProdQty := QuantityAlreadyInStock;
  ProducedDTime   := 0;

  Res := TMqmRes(TMqmVisibleRes(VisResPtr).p_Father);
  ResBatchType := Res.p_ProcessType = CST_batch;

  Cal := nil;
  ActArea := nil;
  if Assigned(m_srvPtr)
  and (VisResPtr = TMqmActArea(m_srvPtr).p_Father) then
  begin
    Cal := TMQMVisibleRes(VisResPtr).GetCalendar;
    ActArea := TMqmActArea(m_srvPtr);
  end;

  // Get if rule is not Partial Deliver
  OvlRules := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);

  if ResBatchType or (not OvlRules.m_CanDeliverPartial) then
  begin
    QuantityTimeProduced(VisResPtr, StartQty, EndQty, EndQty, EndDTime, EndDTime,
                         ProducedQty, ProducedDTime, JobPercentInAGroup);
    BalanceEntriesWriting(VisResPtr, ProducedQty, PreviousProdQty, ProducedDTime, Sequence, NetGroup);
    exit;
  end;

  CurrentQty := StartQty + (OvlRules.m_MinQtyPassNxtStp * JobPercentInAGroup);

  if (CurrentQty > 0) and (CurrentQty < EndQty) then
  begin
    QuantityTimeProduced(VisResPtr, StartQty, CurrentQty, EndQty, 0, EndDTime,
                         ProducedQty, ProducedDTime, JobPercentInAGroup);
    BalanceEntriesWriting(VisResPtr, ProducedQty, PreviousProdQty, ProducedDTime, Sequence, NetGroup);
    if PreviousProdQty < ProducedQty then
      PreviousProdQty := ProducedQty;
  end;

  if OvlRules.m_UpdBalEveryQty > 0 then
  begin
    CurrentQty := StartQty;
    // Loop
    while not (CurrentQty >= EndQty) do
    begin
      CurrentQty := CurrentQty + (OvlRules.m_UpdBalEveryQty * JobPercentInAGroup);
      if (CurrentQty >= EndQty) then
        break;
      QuantityTimeProduced(VisResPtr, StartQty, CurrentQty, EndQty, 0, EndDTime,
                           ProducedQty, ProducedDTime, JobPercentInAGroup);
      if not (ProducedQty <= PreviousProdQty) then
      begin
        BalanceEntriesWriting(VisResPtr, ProducedQty, PreviousProdQty, ProducedDTime, Sequence, NetGroup);
        PreviousProdQty := ProducedQty;
      end;
    end;
  end; // if OvlRules.m_UpdBalEveryQty > 0

  if OvlRules.m_UpdBalEveryHour > 0 then
  begin
    LocUpdDays := 1 / 24 * OvlRules.m_UpdBalEveryHour;
    CurrentDTime := p_sc.GetDateToCompleteQty(m_Id, VisResPtr, StartQty);

    while true do
    begin
      if Assigned(Cal) then
        Cal.OfsByWH(OvlRules.m_UpdBalEveryHour, true, CurrentDTime, CurrentDTime, ActArea.m_CrossDownTmList)
      else
        CurrentDTime := CurrentDTime + LocUpdDays;

      if not (CurrentDTime >= EndDTime) then
      begin
        QuantityTimeProduced(VisResPtr, StartQty, 0, EndQty, CurrentDTime, EndDTime,
                             ProducedQty, ProducedDTime, JobPercentInAGroup);
        if not (ProducedQty <= PreviousProdQty) then
        begin
          BalanceEntriesWriting(VisResPtr, ProducedQty, PreviousProdQty, ProducedDTime, Sequence, NetGroup);
          PreviousProdQty := ProducedQty;
        end;
      end else
        break
    end;
  end;

  QuantityTimeProduced(VisResPtr, StartQty, EndQty, EndQty, EndDTime, EndDTime,
                       ProducedQty, ProducedDTime, JobPercentInAGroup);

  if not (ProducedQty <= PreviousProdQty) then
    BalanceEntriesWriting(VisResPtr, ProducedQty, PreviousProdQty, ProducedDTime, Sequence, NetGroup);

  if EndQty > ProducedQty then    //eran 18/6/07 - When rule = 3000 every 1 hour, qty=23333.33  = bug
     BalanceEntriesWriting(VisResPtr, EndQty, ProducedQty, EndDTime, Sequence, NetGroup);

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.QuantityTimeProduced(VisResPtr: pointer; StartQty, CurrQty, EndQty: double;
                                            CurrDTime, EndDTime: TDateTime;
                                            var ProducedQty: double; var ProducedDTime: TDateTime;
                                            JobPercentInAGroup : Double);
var
  OvlRules: TMQMOvlpRule;
  Res: TMqmRes;
  TempQty : double;
  isDefault: boolean;
begin
  ProducedQty := 0;
  ProducedDTime := 0;

  Res := TMqmRes(TMqmVisibleRes(VisResPtr).p_Father);

  // Get if rule is not Partial Deliver
  OvlRules := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);

  if (
     (CurrQty = 0) and (CurrDTime = 0)
     ) or (CurrQty > EndQty) then
    exit;

//  if CurrDTime = 0 then
//    CurrDTime := p_sc.GetDateToCompleteQty(m_Id, VisResPtr, StartDTime, CurrQty, true);

//  if (CurrDTime <= StartDTime) or (CurrDTime > EndDTime) then
//    exit;

  if CurrQty = 0 then
    CurrQty := p_sc.GetJobQtyAtDate(m_Id, VisResPtr, CurrDTime) * EndQty / m_reqDet.m_quantInit;

  ProducedQty := CurrQty;

  if (ProducedQty = 0) then
    exit;

  if  (OvlRules.m_MinQtyPassNxtStp > 0) and (ProducedQty > (OvlRules.m_MinQtyPassNxtStp * JobPercentInAGroup))
  and (CurrQty <> EndQty) then
  begin
    ProducedQty := Trunc(ProducedQty / (OvlRules.m_MinQtyPassNxtStp * JobPercentInAGroup));
    ProducedQty := ProducedQty * OvlRules.m_MinQtyPassNxtStp * JobPercentInAGroup;
  end;

  // An assumption is made here that one job produces one product - that is the current situation for all customers.
  // Temp quanitty is the "Final" quanitty converted to the step initial quantity
  TempQty := ProducedQty * m_reqDet.m_quantInit / EndQty;

  ProducedDTime := p_sc.GetDateToCompleteQty(m_Id, VisResPtr, TempQty);
  ProducedDTime := ProducedDTime + OvlRules.m_WaitAtLeastMin/60/24;
  ProducedDTime := ProducedDTime + (((m_reqDet.p_LeadTimeNext * TempQty) + m_reqDet.p_LeadTimeNextBatch) / 24 / 60);
  ProducedQty := ProducedQty - StartQty;

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.BalanceEntriesWriting(VisResPtr: pointer; ProdQty, PrevProdQty: double;
                                             BalanceDTime: TDateTime; Sequence: string; NetGroup: TMQMNetGroup);
var
  QtyBalance : double;
//  PercArt,     // % Article
//  ArtTotProduce: double;   // Article Total Produce
//  i : integer;
//  ProdArt: PTProdArt;
//  InitialToFinalRatio : double;
begin

  QtyBalance := ProdQty - PrevProdQty;
  if QtyBalance <= 0 then exit;

{  if GetNextStepToSched(m_reqDet.m_code) <> nil then
  begin
    BalanceEntriesWriteForStep(VisResPtr, QtyBalance, BalanceDTime);
    exit
  end;

  InitialToFinalRatio := m_reqDet.m_quantFinl / m_reqDet.m_quantInit;

  for i := 0 to m_reqDet.m_hdr.m_ProdArtList.p_count - 1 do
  begin
    ProdArt := PTProdArt(m_reqDet.m_hdr.m_ProdArtList.p_Item[i]);

    if ProdArt.Article.p_Nature = Ar_NotBalance then continue;
    if not (ProdArt.RequiredQty >= ProdQty) then continue;

    PercArt := ProdArt.RequiredQty / ((ProdArt.EndQty - ProdArt.StartQty) * InitialToFinalRatio);
    ArtTotProduce := ProdQty * PercArt;
    QtyBalance := ArtTotProduce - ProdArt.ProducedQty - PrevProdQty * PercArt;

    if QtyBalance > 0 then
      BalanceEntriesWriteForMat(VisResPtr, ProdArt.NetGroup, QtyBalance, BalanceDTime);
  end;       }

  if QtyBalance > 0 then
    BalanceEntriesWriteForMat(VisResPtr, NetGroup, QtyBalance, BalanceDTime);

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.BalanceEntriesWriteForStep(VisResPtr: pointer; QtyBalance: double;
                                                  BalanceDTime: TDateTime);
var
  Res: TMqmRes;
  OvlRules: TMQMOvlpRule;
//  RecTArtBal : PTArtBalance;
  RecTArtBal : PTReqBalance;
  TmpQty, TmpLeadTime,
  ExpireDateTime, RoundDTimeBalance, TmpDateOfSt : TDateTime;
  FinalToInitialRatio : double;
  Hour, Min, Sec, MSec: Word;
  isDefault: boolean;
  ActArea: TMqmActArea;
  Cal: TPGCALObj;
  LocWaitAtMostHours,
  LocWaitAtMostDays: double;
begin
  FinalToInitialRatio := m_reqDet.m_quantInit / m_reqDet.m_quantFinl;
//  Res := TMqmRes(TMqmActArea(m_srvPtr).p_Res);
  Res := TMqmRes(TMqmVisibleRes(VisResPtr).p_Father);
  OvlRules := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);

  Cal := nil;
  ActArea := nil;
  if Assigned(m_srvPtr)
  and (VisResPtr = TMqmActArea(m_srvPtr).p_Father) then
  begin
    Cal := TMQMVisibleRes(VisResPtr).GetCalendar;
    ActArea := TMqmActArea(m_srvPtr);
  end;

  TmpQty := QtyBalance * FinalToInitialRatio;
  TmpLeadTime := (m_reqDet.p_LeadTimeNext * TmpQty) + m_reqDet.p_LeadTimeNextBatch;

  if GetNextStepToSched(m_reqDet.m_code) <> nil then
    RoundDTimeBalance := BalanceDTime
  else
  begin
    TmpLeadTime := TmpLeadTime / 1 / 24 / 60;
    BalanceDTime := BalanceDTime + TmpLeadTime;
    DecodeTime(BalanceDTime,Hour,Min,Sec,MSec);

//    RoundDTimeBalance := Trunc(BalanceDTime) + EncodeTime(Hour,0,0,0); //Round hour not good for ARO
    RoundDTimeBalance := Trunc(BalanceDTime) + EncodeTime(Hour,Min,0,0);

  {  if RoundDTimeBalance < DBAppGlobals.CurrDtTime then
      RoundDTimeBalance := DBAppGlobals.CurrDtTime; }
  end;

////////////////////  ENTRY
  New(RecTArtBal);

  if OvlRules.m_WaitAtMostMin > 0 then
    RecTArtBal.BalanceType := bt_EntryExp
  else
    RecTArtBal.BalanceType := bt_Entry;

  RecTArtBal.JobID := m_Id;
  RecTArtBal.Step := m_reqDet.m_code;
  RecTArtBal.DueDate := RoundDTimeBalance; //TDateTime;
  RoundDateTime(RecTArtBal.DueDate);
//  RecTArtBal.BobinCode := ''; //string;          //occupy
//  RecTArtBal.Description := ''; //string;
  RecTArtBal.Quantity := QtyBalance; //Double;
//  RecTArtBal.RecType := brt_NoDet; //CBalRecType;       //if find on BD = withDet also NoDet
//  RecTArtBal.ToRequest := ''; //string;          //''
  RecTArtBal.TotalBal := 0; //double;           //0
  RecTArtBal.TotExpBal := 0; //double;          //0
  RecTArtBal.TotExpUsed := 0; //double;          //0
  RecTArtBal.RealQty := 0; //double;          //0

  m_reqDet.m_hdr.m_RequestBalList.AddItem(RecTArtBal);
///////////////////

  if (OvlRules.m_WaitAtMostMin <= 0) then exit;

  LocWaitAtMostHours := OvlRules.m_WaitAtMostMin/60;
  LocWaitAtMostDays  := OvlRules.m_WaitAtMostMin/60/24;

  if GetNextStepToSched(m_reqDet.m_code) <> nil then
  begin
    TmpDateOfSt := RoundDTimeBalance;
    if Assigned(Cal) then
      Cal.OfsByWH(LocWaitAtMostHours, true, TmpDateOfSt, ExpireDateTime, ActArea.m_CrossDownTmList)
    else
      ExpireDateTime := RoundDTimeBalance + LocWaitAtMostDays
  end else
  begin
    TmpDateOfSt := RoundDTimeBalance;
    if Assigned(Cal) then
      Cal.OfsByWH(LocWaitAtMostHours, true, TmpDateOfSt, ExpireDateTime, ActArea.m_CrossDownTmList)
    else
      ExpireDateTime := RoundDTimeBalance + LocWaitAtMostDays;
    DecodeTime(ExpireDateTime,Hour,Min,Sec,MSec);
//    ExpireDateTime := Trunc(ExpireDateTime) + EncodeTime(Hour + 1,0,0,0);
    ExpireDateTime := Trunc(ExpireDateTime) + EncodeTime(Hour, Min,0,0);  // not good for ARO
  end;

////////////////////  EXPIRE
  New(RecTArtBal);

  RecTArtBal.JobID := m_Id;
  RecTArtBal.Step := m_reqDet.m_code;
  RecTArtBal.BalanceType := bt_Expiration;
  RecTArtBal.DueDate := ExpireDateTime; //TDateTime;
  RoundDateTime(RecTArtBal.DueDate);
//  RecTArtBal.BobinCode := ''; //string;          //occupy
//  RecTArtBal.Description := ''; //string;
  RecTArtBal.Quantity := QtyBalance; //Double;
//  RecTArtBal.RecType := brt_NoDet; //CBalRecType;       //if find on BD = withDet also NoDet
//  RecTArtBal.ToRequest := ''; //string;          //''
  RecTArtBal.TotalBal := 0; //double;           //0
  RecTArtBal.TotExpBal := 0; //double;          //0
  RecTArtBal.TotExpUsed := 0; //double;          //0
  RecTArtBal.RealQty := 0; //double;          //0

  m_reqDet.m_hdr.m_RequestBalList.AddItem(RecTArtBal);
///////////////////

end;

//----------------------------------------------------------------------------//

procedure TSCProdSched.BalanceEntriesWriteForMat(VisResPtr: pointer; NetGroup: TMQMNetGroup; QtyBalance: double;
                                                  BalanceDTime: TDateTime);
var
  Res: TMqmRes;
  OvlRules: TMQMOvlpRule;
  RecTArtBal : PTArtBalance;
//  TmpQty, TmpLeadTime,
  ExpireDateTime, RoundDTimeBalance, TmpDateOfSt : TDateTime;
  FinalToInitialRatio : double;
  Hour, Min, Sec, MSec: Word;
  isDefault: boolean;
  ActArea: TMqmActArea;
  Cal: TPGCALObj;
  LocWaitAtMostHours,
  LocWaitAtMostDays: double;
begin
  FinalToInitialRatio := m_reqDet.m_quantInit / m_reqDet.m_quantFinl;
//  Res := TMqmRes(TMqmActArea(m_srvPtr).p_Res);
  Res := TMqmRes(TMqmVisibleRes(VisResPtr).p_Father);
  OvlRules := res.GetOvlpRule(m_reqDet.m_hdr.m_prodType, p_Process, isDefault);

  Cal := nil;
  ActArea := nil;
  if Assigned(m_srvPtr)
  and (VisResPtr = TMqmActArea(m_srvPtr).p_Father) then
  begin
    Cal := TMQMVisibleRes(VisResPtr).GetCalendar;
    ActArea := TMqmActArea(m_srvPtr);
  end;

//  TmpQty := QtyBalance * FinalToInitialRatio;
//  TmpLeadTime := (m_reqDet.p_LeadTimeNext * TmpQty) + m_reqDet.p_LeadTimeNextBatch;

//  TmpLeadTime := TmpLeadTime / 1 / 24 / 60;
//  BalanceDTime := BalanceDTime + TmpLeadTime;
  DecodeTime(BalanceDTime,Hour,Min,Sec,MSec);
//  RoundDTimeBalance := Trunc(BalanceDTime) + EncodeTime(Hour,0,0,0);
  RoundDTimeBalance := Trunc(BalanceDTime) + EncodeTime(Hour,Min,0,0); // not good for ARO - fp

 { if RoundDTimeBalance < DBAppGlobals.CurrDtTime then
    RoundDTimeBalance := DBAppGlobals.CurrDtTime; }

////////////////////  ENTRY
  New(RecTArtBal);

//  if OvlRules.m_WaitAtMostMin > 0 then
//    RecTArtBal.BalanceType := bt_Entry
//  else
//    RecTArtBal.BalanceType := bt_EntryExp;

  if OvlRules.m_WaitAtMostMin > 0 then
    RecTArtBal.BalanceType := bt_EntryExp
  else
    RecTArtBal.BalanceType := bt_Entry;

  RecTArtBal.JobID := m_Id;
  RecTArtBal.DueDate := RoundDTimeBalance; //TDateTime;
  RoundDateTime(RecTArtBal.DueDate);
  RecTArtBal.BobinCode := ''; //string;          //occupy
  RecTArtBal.Description := ''; //string;
  RecTArtBal.Quantity := QtyBalance; //Double;
  RecTArtBal.RecType := brt_NoDet; //CBalRecType;       //if find on BD = withDet also NoDet
  RecTArtBal.ToRequest := ''; //string;          //''
  RecTArtBal.TotalBal := 0; //double;           //0
  RecTArtBal.TotExpBal := 0; //double;          //0
  RecTArtBal.TotExpUsed := 0; //double;          //0
  RecTArtBal.RealQty := 0; //double;          //0

  NetGroup.m_BalanceList.AddItem(RecTArtBal);
///////////////////

  if (OvlRules.m_WaitAtMostMin <= 0) then exit;

  LocWaitAtMostHours := OvlRules.m_WaitAtMostMin/60;
  LocWaitAtMostDays  := OvlRules.m_WaitAtMostMin/60/24;

  TmpDateOfSt := RoundDTimeBalance;
  if Assigned(Cal) then
    Cal.OfsByWH(LocWaitAtMostHours, true, TmpDateOfSt, ExpireDateTime, ActArea.m_CrossDownTmList)
  else
    ExpireDateTime := RoundDTimeBalance + LocWaitAtMostDays;

////////////////////  EXPIRE
  New(RecTArtBal);

  RecTArtBal.JobID := m_Id;
  RecTArtBal.BalanceType := bt_Expiration;
  RecTArtBal.DueDate := ExpireDateTime; //TDateTime;
  RoundDateTime(RecTArtBal.DueDate);
  RecTArtBal.BobinCode := ''; //string;          //occupy
  RecTArtBal.Description := ''; //string;
  RecTArtBal.Quantity := QtyBalance; //Double;
  RecTArtBal.RecType := brt_NoDet; //CBalRecType;       //if find on BD = withDet also NoDet
  RecTArtBal.ToRequest := ''; //string;          //''
  RecTArtBal.TotalBal := 0; //double;           //0
  RecTArtBal.TotExpBal := 0; //double;          //0
  RecTArtBal.TotExpUsed := 0; //double;          //0
  RecTArtBal.RealQty := 0; //double;          //0

  NetGroup.m_BalanceList.AddItem(RecTArtBal);
///////////////////

end;

//----------------------------------------------------------------------------//

{ TSCMaterialSched }

procedure TSCMaterialSched.SetLinkedRequestToWarp(request: string; step: integer);
var
  I : Integer;
  FoundReqStep : boolean;
begin
  FoundReqStep := false;
  for I := 0 to m_LinkedRequestList.Count - 1 do
  begin
    if (m_LinkedRequestList.Strings[I] = request) and (m_LinkedStepList.Strings[I] = IntToStr(step)) then
    begin
      FoundReqStep := true;
      break
    end;
  end;

  if not FoundReqStep then
  begin
    m_LinkedToRequest := true;
    m_LinkedRequestList.Add(request);
    m_LinkedStepList.Add(IntToStr(step));
  end;

end;

//----------------------------------------------------------------------------//

function TSCMaterialSched.CheckLinkRequest(Request : string; Step : Integer) : boolean;
var
  I : Integer;
begin
  result := false;
  for I := 0 to m_LinkedRequestList.Count - 1 do
  begin
    if (Request = m_LinkedRequestList.Strings[I]) and (IntToStr(step) = m_LinkedStepList.Strings[I]) then
    begin
      Result := true;
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSCMaterialSched.FillLinkRequestStep(LinkReqStep : TStrings);
var
  I : Integer;
begin
  for I := 0 to m_LinkedRequestList.Count - 1 do
    LinkReqStep.Add(m_LinkedRequestList.Strings[I] + '       ' + m_LinkedStepList.Strings[I])
end;

//----------------------------------------------------------------------------//

constructor TSCMaterialSched.Create;
begin
  inherited Create;
  m_propList := TProperties.Create;
  m_LinkedRequestList := TStringList.Create;
  m_LinkedStepList    := TStringList.Create;
  m_LinkedToRequest   := false;
  m_MqmActArea    := nil;
  m_WarpObj   := nil;
  m_schedType := ''
end;

//----------------------------------------------------------------------------//

destructor TSCMaterialSched.Destroy;
begin
  m_propList.Free;
  m_LinkedRequestList.free;
  m_LinkedStepList.free;
  inherited Destroy;
end;

end.
