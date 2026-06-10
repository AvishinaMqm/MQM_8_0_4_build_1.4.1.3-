unit UMSchedContFunc;

interface

uses
  UMCompatSrv;

type
  TSchedID = integer;
  CProgress = (prg_none, prg_Starting, prg_General, prg_Final, prg_FinalSplit);
  CProgressIgnor = (prg_non, Prg_NotIgnored, Prg_Ignored, Prg_IgnoredAndSave, Prg_ReApplied, Prg_ReAppliedAndSave);
  CScSchedType = (CST_undef, CST_batch, CST_Continuous, CST_printing);
  CScResPlanType = (RPT_Real, RPT_OverCapacity, RPT_InfiniteCapacity);
  CScShowContinueGroupLinesInBin = (CsSCG_No, CsSCG_Yes, CsSCG_YesSameSequence);
  CScShowDependingOnHandledStepOrLinkRequest = (CsAlways, CsWhenNotScheduled,
    CsWhenScheduled);
  CProgressTypeIgnored = (Ign_Ignored_Initial, Ign_Ignored_Generic, Ign_Ignored_Final);
  CSCustomerDateType = (CSD_Confirmed, CSD_Calculated, CSD_Requested);
  CScErrors = (CSE_NoError, CSE_DelDate, CSE_Materials, CSE_AddRes,
    CSE_AddRes_ManPower, CSE_HighEndDate, CSE_LowStrDate, CSE_ApprovalDate,
    CSE_LeftOvlp, CSE_RightOvlp, CSE_BothOvlp, CSE_Temp, CSE_Level1, CSE_Level2,
    CSE_Level3, CSE_Level4, CSE_Level5, CSE_Final, CSE_NotFinProg, CSE_FinProg,
    CSE_Closed, CSE_Imbalance, CSE_Ignored_Initial, CSE_Ignored_Generic, CSE_Ignored_Final);
  CScErrGroups = (CSEG_All, CSEG_None, CSEG_Dates, CSEG_Materials);
  CScStatus = (CSS_none, CSS_new, CSS_modi, CSS_del, CSS_From_PG,
    CSS_AfterInsert);
  CScBinView = (CSB_Normal, CSB_ReadOnly, CSB_NotVisible);
  CScSplitAllow = (CSB_No, CSB_Yes, CSB_Son, CSB_Father);
  CScFrcDate = (CSF_No, CSF_Forceable, CSF_Yes, CSF_Forceable2, CSF_Yes2,
    CSF_RequestedHighesEndDate);
  CScToBeSched = (CSX_NotCached, CSX_No, CSX_WaitPri, CSX_WaitDep, CSX_Yes);
  CScMsgFromHost = (CSH_No_Chg, CSH_New_request, CSH_Historical,
    CSH_Jobs_deleted, CSH_Jobs_unscheduled, CSH_Minor_change, CSH_New_step);
  CScFlags = (CSF_selected, CSF_compInBin, CSF_moveSelect,
    CSF_FilterJobsInDynamicGantt);

  CSearchTabs = (CSR_New, CSR_NewWarp, CSR_FullProdReq, CSR_Prod_Req, CSR_Prod_Type,
    CSR_Step_Type, CSR_WorkCntr, CSR_Process, CSR_Prod_Family, CSR_Mat_Family,
    CSR_Rsc, CSR_Qty, CSR_GroupedBy, CSR_GroupedByKeepFilter);
  CScOverlap = (CSO_Unlimited, CSO_Limited, CSO_NotAllowed, CSO_Unknown);

  CScMovementResult = (CSM_No, CSM_Forced, CSM_Yes, CSM_Continue,
    CSM_Not_Compatible, NumComponentsExceeded);

  CSCurveType = (CSC_No, CSC_Forced_By_Host, CSC_Managed);
  TPlanType = (PNormal, PDynamic);

  CGroupingType = (No_grp, FromOtherStep_grp, Single_grp, MultiStepForward_grp,
    MultiStepBackward_grp, MultiStepForwardBackward_grp);
  CSResOccupation = (CSResOcc_No, CSResOcc_Border, CSResOcc_Occupy);

  CScGroupTypeCreate = (CSM_Manual, CSM_Automatic);

  CCategoryTypePrecent = (Cp_WorkCenterAvailhours, Cp_WorkcenterUsedhours);
  CPropTypePrecent = (pp_WorkCenterAvailhours, pp_WorkcenterUsedhours);
  CEfficiencyOnLevel = (EffLvl_Non, EffLvl_Wc, EffLvl_Res, Eff_And_Cal_Both_Lvl_Res);

  CBinColId = (CSC_ProdReq, CSC_ProdStep, CSC_ProdSubStep, CSC_PlanWkctCode,
    CSC_PlanWkctDesc, CSC_ReprocNo, CSC_GroupNo, CSC_WkctCode, CSC_WkctCodeDesc,
    CSC_WkctGrp,CSC_WkctPlant,CSC_WkctDivision,
    CSC_PlanWkctProc, CSC_PlanWkctProcDesc, CSC_Non, CSC_WkctProc,
    CSC_WkctProcDesc, CSC_ProdType, CSC_ProdTypeDesc, CSC_ProdLine,
    CSC_ProdFamily, CSC_ProdMatFamily, CSC_ProdUM, CSC_WeightUM,
    CSC_WeightWithUM, CSC_ProdUMDesc, CSC_Comment, CSC_LowStartTimeLimit,
    CSC_ProdDlvDate, CSC_MsgFromHost, CSC_StepType, CSC_MatArrivalDate,
    CSC_PlanStartDate, CSC_StepGroupType, CSC_ApprovalDate, CSC_LowStartDate,
    CSC_PlanEndDate, CSC_HighEndLimit, CSC_OrigHighEndLimit, CSC_Calendar,
    CSC_IniQty, CSC_FinQty, CSC_Sequence, CSC_Customized_column1,
    CSC_Customized_column2, CSC_Customized_column3, CSC_Weight, CSC_PlanSetup,
    CSC_PlanSetup_Float, CSC_ExeTime, CSC_ExeTime_Float, CSC_Case_with_prev_job,
    CSC_NumOfRscPlan, CSC_NoResComp, CSC_MinAfterStep, CSC_MaxBeforeNext,
    CSC_CanStepBeOverlapped, CSC_MinQtyPasNextStep, CSC_ConnTypePrvStep,
    CSC_SplitFamily, CSC_QtyToSched, CSC_QtyToSchedIni, CSC_Rsc, CSC_RscDesc,
    CSC_SubLineRsc, CSC_ExeTimeSched, CSC_SupTimeSched, CSC_Calculated,
    CSC_SupOvlpSched, CSC_FwdConnSubStp, CSC_Closed, CSC_FwdConnReProcs,
    CSC_PrvHighestDate, CSC_NxtLowestDate, CSC_PrvLowestStartDate,
    CSC_NxtHighiestEndDate, CSC_LastScheudleChange, CSC_BkwConnSubStp,
    CSC_BkwConnReProcs, CSC_SchedStart, CSC_SharedComment, CSC_CustomerDate,
    CSC_SavedScheduleDate, CSC_SchedEnd, CSC_ProgStart, CSC_ProgStart_Ignored,
    CSC_PrvActualEnd, CSC_NxtActualStart, CSC_GenericPlanWC, CSC_GenericPlanDur,
    CSC_GenericPlanLeadTime, CSC_GenericPlanMachineNum,
    CSC_GenericPlanStartDate, CSC_GenericPlanEndDate, CSC_ServingGroupCode,
    CSC_ServingGroupLowestDate, CSC_ProgEnd, CSC_ProgEnd_Ignored, CSC_ProgQty, CSC_ProgSetupTime,
    CSC_ProgCurDt, CSC_ProgRemTime, CSC_ProgRsc, CSC_ProgRscDesc,
    CSC_ActualTime, CSC_ProgType, CSC_ProgType_Host, CSC_supAdj, CSC_supConst, CSC_Overlapping,
    CSC_NotSorted, CSC_batch_ContinuesTime, CSC_Continues_parallel, CSC_CurveCode,
    CSC_SchedSeq, CSC_SeqCB,
    CSC_FirstScheduleResource, CSC_FirstScheduleStart, CSC_FirstScheduleEnd, CSC_VersionIdentifier,
    CSC_VersionScheduleResource, CSC_VersionScheduleStart, CSC_VersionScheduleEnd, CSC_ProductDescription, CSC_ModifiedSpeed,
    CSC_JobComponents, CSC_MachineComponents, CSC_Halted_Time,
    // material bin columns
    CSC_Mat_Item_Type, CSC_Mat_PRODUCT_CODE,
    CSC_Mat_NET_GROUP_CODE, CSC_Mat_Detail_Code, CSC_Mat_MATERIAL_CODE_SUB_DET,
    CSC_Mat_Request_number, CSC_Mat_Sub_Detail, CSC_Mat_Resource_code, CSC_Mat_Quantity,
    CSC_Mat_SpeedInminutePerUoM, CSC_Mat_m_Standard_Setup, CSC_Mat_Execution_Time,
    CSC_Mat_Overriden_Setup_Time, CSC_Mat_Overriden_Speed, CSC_Mat_Schedule_Start, CSC_Mat_Schedule_End, CSC_Warp_level,
    //
    // CSC_Mat_Balance_Id,
    //

    CSC_property1, CSC_property2, CSC_property3, CSC_property4, CSC_property5, CSC_property6,
    CSC_property7, CSC_property8, CSC_property9, CSC_property10, CSC_property11,
    CSC_property12, CSC_property13, CSC_property14, CSC_property15,
    CSC_property16, CSC_property17, CSC_property18, CSC_property19,
    CSC_property20, CSC_property21, CSC_property22, CSC_property23,
    CSC_property24, CSC_property25, CSC_property26, CSC_property27,
    CSC_property28, CSC_property29, CSC_property30, CSC_property31,
    CSC_property32, CSC_property33, CSC_property34, CSC_property35,
    CSC_property36, CSC_property37, CSC_property38, CSC_property39,
    CSC_property40, CSC_property41, CSC_property42, CSC_property43,
    CSC_property44, CSC_property45, CSC_property46, CSC_property47,
    CSC_property48, CSC_property49, CSC_property50, CSC_property51,
    CSC_property52, CSC_property53, CSC_property54, CSC_property55,
    CSC_property56, CSC_property57, CSC_property58, CSC_property59,
    CSC_property60);

  CBinColValType = (CBT_date, CBT_integer, CBT_float, CBT_string,
    CBT_bool, CBT_dur);
  CAlignOpt = (Al_ToDate, Al_Erliest, Al_Latest, Al_LowStart, Al_PlanStart,
    Al_PlanEnd, Al_HighEnd);
  TypeOvlpChk = (OvlpChk_OnSchedPoint, OvlpChk_OptimumLimits);

  TLinkJobFunc = procedure(link: string; id: TSchedID; ptr: pointer) of Object;
  TUpdLinkJobFunc = procedure(link: string; id: TSchedID; ptr: pointer)
    of Object;
  TGetEventType = function: boolean;
  TRslvPtrFunc = function(ptr: pointer): string of Object;
  TGrpPropFunc = function(id: TSchedID; ptr: pointer): TProperties;
  TGrpAddFunc = function(job, grp: TSchedID; out ErrDesc: string): boolean;
  TFindWrkCtrFunc = function(WkcCode: string): pointer of Object;
  TCheckIfJobDeletedFromHost = function(ProdReq: string; ProdStep: integer;
    var UnSchedule: boolean): boolean of Object;

  TLinkType = (LT_ConnJob, LT_SameStep, LT_DiffStep, LT_ConnReq);

  CSetOptsMover = (OM_ObjsMoved, OM_ObjsMovedUpToLatest, OM_FinalObjsMoved,
    OM_InitialObjsMoved, OM_Level1ObjsMoved, OM_Level2ObjsMoved,
    OM_Level3ObjsMoved, OM_Level4ObjsMoved, OM_Level5ObjsMoved, OM_ObjsDelayed,
    OM_Materials, OM_AddRes, OM_Overlap, OM_ObjsOverlapped, OM_ObjsMaterials,
    OM_ObjsAddRes);

  SetOptsMover = set of CSetOptsMover;
  SetOfErrors = set of CScErrors;

  TLink = record
    LK_StObj: pointer;
    LK_EndObj: pointer;
    LK_Type: TLinkType;
  end;

  PTLink = ^TLink;

function GetWorstError(Errors: SetOfErrors): CScErrors;

const
  CSchedIDnull: TSchedID = -1;

implementation

function GetWorstError(Errors: SetOfErrors): CScErrors;
begin
  if CSE_AddRes in Errors then
    Result := CSE_AddRes
  else if CSE_Materials in Errors then
    Result := CSE_Materials
  else if CSE_DelDate in Errors then
    Result := CSE_DelDate
  else if CSE_BothOvlp in Errors then
    Result := CSE_BothOvlp
  else if CSE_LeftOvlp in Errors then
    Result := CSE_LeftOvlp
  else if CSE_RightOvlp in Errors then
    Result := CSE_RightOvlp
  else if CSE_HighEndDate in Errors then
    Result := CSE_HighEndDate
  else if CSE_LowStrDate in Errors then
    Result := CSE_LowStrDate
  else
    Result := CSE_NoError;
end;

end.
