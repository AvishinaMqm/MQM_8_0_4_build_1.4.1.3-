unit UMTblDesc;

interface

type

  dbOp = (dbo_none, dbo_ins, dbo_del, dbo_modi);

  dbType  = (db_short, db_int, db_varCh, db_ch, db_date, db_tmStp, db_dec, db_Blob, db_bigInt);

  table   = (
             tbl_cfg_McmTabConfig,
             tbl_ResCal,
             tbl_Filters,
             tbl_Filters_col,
             tbl_Identifiers,
             tbl_Archive_To_Host,
             tbl_GeneratorNumber,
             tbl_addRes,
             tbl_wkc_alt,
             tbl_alt_warehouse,
             tbl_cfg_AppGlobSettings,
             tbl_cfg_appGlob,
             tbl_cfg_appIni,
             tbl_cfg_appSettings,
             tbl_cfg_AutoSched,
             tbl_cfg_AutoSchedWorkCenter,
             tbl_cfg_AutoRunDefinition,
             tbl_arty,
             tbl_Material_Tollerance_Types,
             tbl_cfg_bin_showProp,
             tbl_prop_capRes,
             tbl_capRes,
             tbl_capRes_Host,
             tbl_capRes_DynamicPerRes,
             tbl_capRes_DynamicPerDate,
             tbl_capRes_DynamicPerResDateProp,
             tbl_cfg_clrCapToJob,
             tbl_resCat,
             tbl_calendar,
             tbl_calShiftEffic,
             tbl_cfg_planTab_det,
             tbl_cfg_planTab_master,
             tbl_cfg_exchg_glob,
             tbl_cfg_exchg_wkst,
             tbl_cfg_exchg_SrvLoad,
             tbl_cfg_SrvLoad_Log,
             tbl_ext_info,
             tbl_ext_infoHdr,
             tbl_ext_connection,
             tbl_cfg_binFilter,
             tbl_prod_schedForce,
             tbl_res_sub,
             tbl_cfg_colorStatus,
             tbl_cfg_colorDateWarn,
             tbl_cfg_colorMatWarn,
             tbl_cfg_colorJobToRes,
             tbl_cfg_colorJobToJob,
             tbl_prod_reqConnection,
             tbl_ruleOccToOcc,
             tbl_GroupByPropertyRules,
             tbl_prod_info,
             tbl_wkc_prodLine,
             tbl_prop_prod,
             tbl_prod_req,
             tbl_prod_step,
             tbl_prod_reqHdr,
             tbl_prod_sched,
             tbl_prod_sched_mcm,
             tbl_prod_sched_shared_data,
             tbl_prop,
             tbl_PROP_PROD_PLANNER,
             tbl_cfg_Prop_Show_Color,
             tbl_cfg_clrRes,
             tbl_cfg_clrCapRes,
             tbl_res,
             tbl_res_apa,
             tbl_Req_Change,
             tbl_CapRsc_Change,
             tbl_ruleResToOcc,
             tbl_prop_res,
             tbl_step_batchSize,
             tbl_step_times,
             tbl_sched_progress,
             tbl_sched_progress_override,
             tbl_cfg_binTab_col,
             btl_customizedDateColumn,
             btl_customizedDateGap,
             tbl_unit,
             tbl_wkc_group,
             tbl_wkc,
             tbl_wkc_proc,
             tbl_wkst,
             tbl_wkst_wkc,
             tbl_wkc_priority,
             tbl_wkc_cat_capacity,
             //keep in alphabetical order!!!!!!!!

             tbl_cfg_text_display_set_fields,
             tbl_cfg_text_display_set_wkc,
             tbl_cfg_Mail_set_List,
             tbl_GroupedByFields,
             tbl_wkc_Change,
             tbl_Rsc_Change,
             tbl_Proc, // Matthias
             tbl_Cal,   // Matthias
      			 tbl_Licence,
             tbl_Licence2,
             tbl_machine_setup_code,
             tbl_wkc_dependency,
             tbl_material,
             tbl_material_sup_detail,
             tbl_material_sup_header,
             tbl_produced_article,
             tbl_products,
             tbl_balance_header,
             tbl_balance_detail,
             tbl_download_time,
             tbl_Job_Massages,
             // DB TEMP
           //  tbl_mst_simulations,
             // DB for QEPORT
           //  tbl_report,
             // for mcm
          {   tbl_wkc_Category,
             tbl_CategoryDatesInfo,
             tbl_wkc_Penalties,
             tbl_MCM_Changes_List,
             tbl_MCM_CAP_CHANGES,
             tbl_MCM_OUT_SCHED,
             tbl_MCM_QUEUE_DET,
             tbl_MCM_QUEUE_HDR,
             tbl_MCM_SUBCAT_DET,
             tbl_MCM_SUBCAT_HDR,
             tbl_MCM_WKC_SUBCATEGORY,  }
             tbl_LearningCurve,
             tbl_ItemsStock,
             tbl_ItemsStockChanges,
             tbl_ItemsStockExceptions,
             tbl_GroupResDefinition,
             tbl_StockDetails,
             tbl_AutoSeq_ScoreAddition,
             tbl_AutoSeqJobToJobDefinitions,
             tbl_PropAsDate,
             tbl_PropAsRGB,
             tbl_PropAssigned,
             tbl_Log,
             tbl_OverrideStepParameters,
             tbl_cfg_binMaterialFilter,
             tbl_ProductProperties,
             tbl_MaterialDetailSchedule,
             tbl_MaterialDetailchedule_Link,
             tbl_SchedulesDownloadWarpRSV,
             tbl_TotalsView,
             tbl_TotalsViewWorkCenters,
             tbl_TotalsViewGroupByColumns,
             tbl_TotalsViewContent,
             tbl_CustomMenu,
             tbl_SavedPlanCopyHeader,
             tbl_SavedPlanCopy
             );

  domain  = (dom_ProdReq,   // Production Req cod   (12,A)
             dom_longId,    // long identifier      (11,0)
             dom_midId,     // medium identifier    (5,0)
             dom_shortId,   // short identifier     (3,0)
             dom_shtstId,   // shortest identifier  (2,0)
             dom_quant,     // quantity             (15,5)
             dom_quant_material, // quantity_material (14,4)
             dom_speed,     // speed                (9,4)
             dom_longChId,  // character identifier (6A)
             dom_shortChId, // character identifier (4A)
             dom_smallChId,  // character identifier (2A)
             dom_codeWS,    // workstation code     (10,A)
             dom_CodeRes,   // Resource code        (8,A)
             dom_CodeWrcr,  // work center code     (8,A)
             dom_CodeNetGrp,// Net group code       (10,A)
             dom_CodeGrpByPropRule,// GroupByPropertyRules (10,A)
             dom_usr,       // user name            (10,A)
             Dom_Cal,       // Calander Code        (3,A)
             dom_txt3,      //                      (3,A)
             dom_durMin,    // duration in minutes  (9,2)
             dom_durMinMulti, // time multiplier    (9,4)
             dom_timing,    // timing information   (timestamp)
             dom_text30,    // 30 characters of text (30,A)
             dom_text35,    // 35 characters of text (35,A)
             dom_text40,    // 40 characters of text (40,A)
             dom_text50,    // 50 characters of text (50,A)
             dom_text60,    // 60 characters of text (60,A)
             dom_text120,   // 120 characters of text (120,A)
             dom_text250,   // 250 characters of text (250,A)
             dom_txt14,     // 14 characters of text (14,A)
             dom_txt28,     // 28 characters of text (28,A)
             dom_txt12,     // 14 characters of text (12,A)
             dom_txt20,     // 15 characters of text (20,A)
             dom_txt25,     // characters of text    (25,A)
             dom_text10,    // 10 characters of text (10,A)
             dom_Info,      // 70 char Infor Area    (70,A)
             dom_family,    // 35 char Area          (35,A)
             dom_Category,  // Category Resource     (3,A)
             dom_Mixregrp,  // dom_Mixregrp          (3,A)
             dom_intCode,   // integer code
             dom_Weight,    // Weight                (9,2)
             dom_UM,        // UM                    (3,A)
             Dom_2Char,     // General 2 char def for number (2,A);
             dom_ReqOrig,   // OrigReq               (2,A)
             dom_BchCode,   // BchCode               (2,A)
             dom_propVal,   // Property inherited values (20,A)
             dom_Type,       // Type options (1-2-3) (1,A)
             dom_bch_Size,   // Batch Size           (7,2)
             dom_div,         // Division Code       (2,A)
             dom_Cntr_Group,  // work center group   (4,A)
             dom_Prod_LineCode, // production Line   (4,A)
             dom_PropertyCode,  // Property code     (5,A)
             dom_DecNum,        // Decimal number    (1,0)
             dom_PropBaseValue, // base value prop   (20,A)
             dom_PropValueAdd,  // value addi rsc    (14,4)
             dom_PropRules,     // property rules    (2,A)
             dom_ProdType,      // 1-3 Prod Type     (3,A)
             dom_ConnKey,       // Connection key    (30,A)
             dom_NumOfLevel,    // Num of Level      (2,0)
             dom_CompCaseNum,   // dom_compatibility case number (5,0)
             dom_NumRscComp,    // Num Rsc Comp      (5,0)
             dom_NumResPlan,    // Number Of Resource(9,3)
             dom_TimeSteps,     // Times steps       (11,3)
             dom_AddiCode,       // Additinal code    (5,A)
             dom_multiToBatchUm, // Multiplier to batch size UM (14,4)
             dom_flag,            // 1 char flag domain (1A)
             don_Hours,          // don_Hours (4,1)
             dom_Text15,          // text 15
             dom_Text1024,       // text 1024
             dom_BLOB ,           // blob
             dom_Text2000,       // text 2000
             dom_Text100,        // 100 characters of Text (100,A)
             dom_Text12,        // 12 characters of Text (12,A)
             dom_Text4,         // 4 characters of Text (4,A)
             dom_Text7,
             dom_Text8,
             dom_BigInt         //Bigint
            );

  fldId   =  (fli_ArtType, fli_stGroup, fli_stGroupFrom, fli_stGroupTo, fli_ForcedGroup, fli_ForcedGroupNo, fli_StepIsGrouped ,
              fli_ConnForwardSubStep, fli_ConnForwardReProcess, fli_ConnBackwardSubStep,
              fli_ConnBackwardReProcess, fli_SaveAtLeastOnesAsFinnal, fli_index,
              fli_quant,      fli_quantHost,   fli_StartingQty, fli_ProgressReApplied,  fli_subLinRscId, fli_Operation,
              fli_vers,       fli_rsc, fli_rsc_cal, fli_rsc_To,   fli_rscHost,     fli_bch,        fli_usrCr,
              fli_usrTmCr,    fli_usrCg,        fli_usrTmCg,    fli_supMin,
              fli_exeMin,     fli_ColorIndex,    fli_schedStart,   fli_schedEnd,   fli_planStart, fli_ActualStart, fli_ActualEnd,
              fli_FirstScheduleResource, fli_FirstScheduleStart, fli_FirstScheduleEnd,
              fli_VersionIdentifier ,fli_VersionScheduleResource , fli_VersionScheduleStart, fli_VersionScheduleEnd, fli_Mqm_environment,
              fli_schedType,  fli_planEnd,      fli_ganntStart, fli_ganntEnd,
              fli_preqNo,     fli_NewPreqUniqId, fli_Serving_Code, fli_Served_Code, fli_CurveFamilyIdCode,  fli_preqNo_To, fli_PrevProdNum,  fli_preqStatus,
              fli_HistoriclReq, fli_ReqOrigin,  fli_HistoriclData, fli_ProdUMCode,fli_ProdFamily,   fli_MaterialFamily, fli_um,
              fli_pstepId,    fli_pstepId_To , fli_LeadpstepIdForSplit, fli_pstepId_From, fli_infoLineNum,  fli_InfoArea,    fli_infoType,
              fli_ConnKey,    fli_ConnType,     fli_psubstId,   fli_psubstId_To, fli_NumOfLevel,
              fli_ConnLevel,  fli_ConnCertentyLevel, fli_DueDate, fli_orig_duedate, fli_reprocNo, fli_reprocNo_From , fli_wkcProc, fli_wkcProc_To,
              fli_ProgressType, fli_Prog_Override_Type, fli_ProgressTypeHost, fli_progrStart, fli_progrStartHost , fli_progrEnd,
              fli_progrEndHost, fli_ProgressGroup, fli_prgCurrDate, fli_prgCurrDateHost, fli_prgRemTime, fli_prgRemTimeHost,
              fli_wkstCode, fli_wkDescr, fli_wkPasswd,  fli_wkCtrCode, fli_WCProcess, fli_wkCtrCode_To,
              fli_SchedwkCtrCode, fli_SchedWCProcess,  fli_wkCtrGroup, fli_PlantCode,fli_MCMSequence, fli_WarpHandle, fli_Ignoreprogress, fli_Division, fli_RuleForGroupingMQM, fli_RuleForGroupingMCM,
              fli_CreateDateTimeUTC, fli_CrtOrUpdateDateTimeUTC, fli_MainWC, fli_TypOprtion,
              fli_TypProcess, fli_CalCod, fli_EfficiencyOnWcOrResLevel, fli_TypeOfUse, fli_SDescr, fli_StepWorkCenter, fli_StepWorkCenterProcess,
              fli_wkCtrCodeKeyFileST, fli_WCProcessKeyFileST, fli_rscKeyFileST, fli_ResCatKeyFileST,
              fli_LDescr, fli_Text, fli_DisplayText1, fli_DisplayText2, fli_rscCat, fli_addiCode, fli_ConsumingZone, fli_GeneratorCode, fli_GeneratorNum,
              fli_ProcesType,  fli_Standrd_bch_Size,fli_BchUM,   fli_Min_bch_size,
              fli_Max_bch_Size,fli_rscType, fli_NumOfRsc, fli_WorkAsOneBatchMachineGroupCode, fli_Rsc_PLanType, fli_OneBatchMachineGrouptype,
              fli_LineWithinPlant, fli_PropOptimumMaxMultiplier, fli_PropMinMultiplier, fli_ForceOutsideLimitQty, fli_ForceOccToResCase99,
              fli_TabsCode, fli_TabsDesc, fli_ActiveOnPc, fli_ToBeSched, fli_PrevLeadTime_mqm , fli_NextLeadTime_mqm, fli_PrevLeadTimeBatch_mqm, fli_NextLeadTimeBatch_mqm,
              fli_PrevLeadTime_Mcm, fli_NextLeadTime_Mcm, fli_PrevLeadTimeBatch_Mcm, fli_NextLeadTimeBatch_Mcm,
              fli_BatchSizePerStep, fli_MinBatchSize, fli_OptimumBatchSize, fli_MaxBatchSize, fli_OverlapWithOtherSteps,
              fli_StepType ,  fli_MaterialArrivDate, fli_prevStep , fli_SetUpTimJob,
              fli_FrcMatDate, fli_FrcLowestDate, fli_FrcHighestDate, fli_FrcOverlapp, fli_FrcDelDate, fli_ReactivateReq,
              fli_ExecTimeInitQty, fli_CapUsed, fli_NextStep, fli_prevStepSched_Mqm, fli_NextStepSched_Mqm, fli_prevStepTrue, fli_NextStepTrue,
              fli_prevStepSched_Mcm, fli_NextStepSched_Mcm, fli_NextStepTimeLimit, fli_prevStepTimeLimit,
              fli_InitialPlanScheduledDateTime, fli_FinalPlanScheduledDateTime, fli_HighEndTimeLimit , fli_AllowSplit , fli_SplitFamaly,
              fli_LowStartTimeLimit, fli_ProdLowDataTime,  fli_ProdDelivDate,    fli_quantInit , fli_quantFinl,
              fli_Weight , fli_DescUM , fli_SetupTimStep,  fli_excTimeStep, fli_Visible,
              fli_NumResPlan, fli_Tbl_Name, fli_Tbl_Host,
              fli_CanStepOverlap, fli_CanOverlapNonWrkingHours, fli_MinQtyPassNextStp, fli_StepCanBeOverlapped, fli_StepHandleReProc,
              fli_StepPartGenralPlan, fli_STepCanGroup, fli_GroupType, fli_UseAllResourceParts, fli_ResOccupation, fli_NumMachinesTosuspend,
              fli_MinQtyToStart, fli_ConnTypToPrevStepSplit, fli_StepClosed, fli_MaxStartDateAutoSeq, fli_alternative_Qty, fli_alternative_UM, fli_Alternative_um_handled,
              fli_divCode, fli_dispoCode, fli_BinColField, fli_BinColTitle, fli_BinColPos,
              fli_BinColWidth, fli_BinColVisibl,fli_BinColOrder , fli_BinColDescending, fli_BinColNumColSorted, fli_TabVis, fli_CategorySDesc,
              fli_CategoryLDesc, fli_AdditionalCapacity, fli_IDENTIFIER, fli_Sequence, fli_GroupInternalSortSeq, fli_NewSetup, fli_GrpContinueSeq, fli_SeqAlpha,
              fli_AlterWC, fli_AlterWCProces, fli_DateBegin, fli_DateEnd, fli_ProdLine, fli_SubRsc, fli_NumSubRscComponents, fli_multipToBatchUm,
              fli_Comment, fli_PropertyCode, fli_PropSDesc, fli_PropLDesc , fli_PropType, fli_PropIsdate, fli_LastScheudleChange, fli_AssignedProp,
              fli_ChgPropValCauseResched, fli_PropInstanceCounter, fli_PropValueInstanceCounter, fli_LearningCurveCode, fli_LearningCurveCodeByOccToOcc , fli_LearningCurveType, fli_ApprovalDate,
              fli_DecNum, fli_BalanceDecNum, fli_CalDate, fli_Prog_Wrk_Hr, fli_ChangeType,
              fli_SH1_start, fli_SH1_end, fli_SH2_start, fli_SH2_end,
              fli_SH3_start, fli_SH3_end, fli_SH4_start, fli_SH4_end,
              fli_RP_MainLevel ,fli_RP_Add_WC_Proc,fli_RO_CompatChekType, fli_RO_MainLevel,
              fli_RO_Add_WC_Proc, fli_RO_Add_ProdType ,fli_OO_CompatChekType,fli_OO_MainLevel,
              fli_OO_Add_WC_Proc ,  fli_OO_Add_ProdType ,
              fli_PropBaseValue, fli_Propty_Calculated_Value,
              fli_PropAddRscOfOcc, fli_PropAddValToAddiRsc, fli_PropDftCaseRsc_Occ_Ruls, fli_PropDftCaseOcc_Occ_Ruls,
              fli_PropDftSameGroupForOcc_Occ_Ruls, fli_PropValTakeForGroup,
              fli_ProdType, fli_PropLineNum, fli_PropValue, fli_PropOperand, fli_DepOnCurr,
              fli_DepValue, fli_RuleConst, fli_ManPropValue, fli_ManChg,
              fli_PropCase, fli_PropSetupTyp, fli_PropSetUpTime, fli_PropSetUpOverlappTime,  fli_PropSetUpTimeMult,
              fli_PropSetUpOverlappTimeMult, fli_CanBeSameGroup, fli_teoreticl_wc,
              fli_duration, fli_LeadTime, fli_RuleOccFrom, fli_RuleOccLength, fli_RuleOccForPartialPropVal, fli_WhenOkNextSeq, Fli_AddiRsc,
              fli_NumHourBforSetup, fli_NumHourAfterSetup, fli_ValAddAddiRscBeforSetup,
              fli_ValAddAddiRscWhileSetup, fli_ValAddAddiRscAfterSetup, fli_CapacyResrv, fli_CapacyResrvStatus,
              fli_CapacyResTyp, fli_Capacity_To_Job,
              fli_Zoom, fli_HZoom, fli_SZoom, fli_SlotGroup, fli_supMinBase, fli_supMinReal, fli_supMinOvlp,

              // Cal_Shift_effic
              fli_CalStartDate , fli_CalEndDate, fli_SH1_EFFIC, fli_SH2_EFFIC, fli_SH3_EFFIC, fli_SH4_EFFIC,

              // Application Global
              fli_EnvDescr, fli_Customer, fli_MqmVersion, fli_MonthBefore, fli_StDateForPlan,
              fli_Language, fli_CurrTScale, fli_CurrDtTime, fli_ShowCal, fli_CurrRscSort,
              fli_ShowZoom, fli_RscOrderType, fli_RscOrderItem,
              fli_wdwPlanLeft, fli_wdwPlanTop, fli_wdwPlanWidth, fli_wdwPlanHeight,
              fli_wdwPlanstate, fli_wdwBinDock, fli_wdwBinLeft,   fli_wdwBinTop,
              fli_wdwBinWidth,  fli_wdwBinHeight, fli_wdwBinState, fli_wdwBinSplitter,
              // mcm
              fli_MCMcNumMaxPrd,
              fli_MCMcMaxPrd1,
              fli_MCMcMaxPrd2,
              fli_MCMCatViewWcHoursPerc,
              fli_MCMPropertyViewWcHoursPerc,


              //  AppGlobSettings
              fli_AppGlobSettings,

              // Application Settings
              fli_AppSettings,

              // Application Ini

              fli_FieldName, fli_value,

              // Application Preferences
              fli_CheckStepSeq, fli_CenterStartOnMove, fli_WarnOnMoveFinal,
              fli_DefSchedType, fli_ShowColorJobMode, fli_ConfLevels, fli_SplitConfLevels, fli_MoveOption,fli_ActAutoSchedCode, fli_UnscheduleClosedJobsOnStart,
              fli_SlotDisplay, fli_CustomSlotDisplay, fli_CustomPROPDisplay, fli_CustomPROPSymbol,
              // BinFilters
              fli_FiltConfLevels_final, fli_FiltConfLevels_Ini, fli_FiltConfLevel1, fli_FiltConfLevel2, fli_FiltConfLevel3,
              fli_FiltConfLevel4,fli_FiltConfLevel5, fli_FiltCustomerDateConfirmed, fli_FiltCustomerDateCalculated, fli_FiltCustomerDateRequested, fli_FiltConfLevNewLog,
              fli_MinQty, fli_MaxQty, fli_MinutAddAftrStp, fli_MaxMinutBfrNxtStp , fli_propLen, fli_Bin_ReadOnly,
              fli_DelivDate_From, fli_DelivDate_To,
              fli_ProdLowDate_From, fli_ProdLowDate_To, fli_PlanStartDate_From , fli_PlanStartDate_To,

              fli_PlanStartDateToday_From, fli_PlanStartDateToday_To, fli_PlanEndDate_From, fli_PlanEndDate_To, fli_PlanEndDateToday_From, fli_PlanEndDateToday_To,
              fli_NextStartDate_From, fli_NextStartDate_to, fli_NextStartDateToday_From, fli_NextStartDateToday_To, fli_PrevEndDate_From, fli_PrevEndDate_to,
              fli_PrevEndDateToday_From, fli_PrevEndDateToday_To,

              fli_LowStartDate_From, fli_LowStartDate_To, fli_LatestEndingDate_From, fli_LatestEndingDate_To,  fli_ShowAlternative, fli_Wkcr_FromPlan,
              fli_FiltPropCode, fli_FiltPropRes, fli_filtPropValueFrom, fli_filtPropValueTo,
              fli_FiltSchedJobs, fli_FiltWarpLvl, fli_FiltFltJobsOnGantt, fli_FiltClosedJobs,
              fli_Bin_OnlyReadOnly, fli_FiltOnlySchedJobs, fli_FiltOnlyClosedJobs, fli_FiltGroups, fli_FiltOnlyGroups,
              fli_SchedStartDate_From, fli_SchedStartDate_To, fli_ScheduledJobsCrossesDateTime_From, fli_ScheduledJobsCrossesDateTime_To,
              fli_FiltTemporary, fli_FiltPriority,fli_FiltProgress, fli_FiltOnlyProgress,
              fli_FiltAfterDeliveryDay, fli_FiltAfterDeliveryInDays,
              fli_FiltBeforeEarliestStart, fli_FiltBeforeEarliestStartInDays, fli_FiltAfterLatestEnd,
              fli_FiltAfterLatestEndInDays, fli_FiltShouldBeScheduled, fli_FiltShouldBeScheduledIndays,
              fli_FiltMissingmaterials, fli_FiltMissingAddRes, fli_FiltOveridePrevious,fli_FiltOverideNext,
              fli_FiltCompWithPrevJob, fli_FiltCompWithPrevJobInCase, fli_FiltCompWithRes,
              fli_FiltCompWithResInCase, fli_FiltJobMsg, fli_FiltImbalancedSteps, fli_DaysFromToday_From, fli_DaysFromToday_To, fli_DaysFromToday_ToTime,
              fli_FiltShowFirstGrplineInBin, fli_FiltAutoGroupSingleJob, fli_FiltShowBatchGroupLinesInBin, fli_FiltShowContinueGroupLinesInBin,
              fli_FiltPropCode1, fli_FiltPropRes1, fli_filtPropValueFrom1, fli_filtPropValueTo1,
              fli_FiltPropCode2, fli_FiltPropRes2, fli_filtPropValueFrom2, fli_filtPropValueTo2,
              fli_FiltPropCode3, fli_FiltPropRes3, fli_filtPropValueFrom3, fli_filtPropValueTo3,
              fli_FiltPropCode4, fli_FiltPropRes4, fli_filtPropValueFrom4, fli_filtPropValueTo4,
              fli_FiltPropCode5, fli_FiltPropRes5, fli_filtPropValueFrom5, fli_filtPropValueTo5,
              fli_FiltPropCode6, fli_FiltPropRes6, fli_filtPropValueFrom6, fli_filtPropValueTo6,
              fli_FiltPropCode7, fli_FiltPropRes7, fli_filtPropValueFrom7, fli_filtPropValueTo7,
              fli_FiltPropCode8, fli_FiltPropRes8, fli_filtPropValueFrom8, fli_filtPropValueTo8,
              fli_FiltPropCode9, fli_FiltPropRes9, fli_filtPropValueFrom9, fli_filtPropValueTo9,
              fli_FiltPropCode10, fli_FiltPropRes10, fli_filtPropValueFrom10, fli_filtPropValueTo10,
              fli_FiltPropCode11, fli_FiltPropRes11, fli_filtPropValueFrom11, fli_filtPropValueTo11,
              fli_FiltPropCode12, fli_FiltPropRes12, fli_filtPropValueFrom12, fli_filtPropValueTo12,
              fli_FiltPropCode13, fli_FiltPropRes13, fli_filtPropValueFrom13, fli_filtPropValueTo13,
              fli_FiltPropCode14, fli_FiltPropRes14, fli_filtPropValueFrom14, fli_filtPropValueTo14,
              fli_FiltPropCode15, fli_FiltPropRes15, fli_filtPropValueFrom15, fli_filtPropValueTo15,
              fli_FiltPropCode16, fli_FiltPropRes16, fli_filtPropValueFrom16, fli_filtPropValueTo16,
              fli_FiltPropCode17, fli_FiltPropRes17, fli_filtPropValueFrom17, fli_filtPropValueTo17,
              fli_FiltPropCode18, fli_FiltPropRes18, fli_filtPropValueFrom18, fli_filtPropValueTo18,
              fli_FiltPropCode19, fli_FiltPropRes19, fli_filtPropValueFrom19, fli_filtPropValueTo19,
              fli_FiltPropCode20, fli_FiltPropRes20, fli_filtPropValueFrom20, fli_filtPropValueTo20,
              fli_FiltPropCode21, fli_FiltPropRes21, fli_filtPropValueFrom21, fli_filtPropValueTo21,
              fli_FiltPropCode22, fli_FiltPropRes22, fli_filtPropValueFrom22, fli_filtPropValueTo22,
              fli_FiltPropCode23, fli_FiltPropRes23, fli_filtPropValueFrom23, fli_filtPropValueTo23,
              fli_FiltPropCode24, fli_FiltPropRes24, fli_filtPropValueFrom24, fli_filtPropValueTo24,
              fli_FiltPropCode25, fli_FiltPropRes25, fli_filtPropValueFrom25, fli_filtPropValueTo25,
              fli_FiltPropCode26, fli_FiltPropRes26, fli_filtPropValueFrom26, fli_filtPropValueTo26,
              fli_FiltPropCode27, fli_FiltPropRes27, fli_filtPropValueFrom27, fli_filtPropValueTo27,
              fli_FiltPropCode28, fli_FiltPropRes28, fli_filtPropValueFrom28, fli_filtPropValueTo28,
              fli_FiltPropCode29, fli_FiltPropRes29, fli_filtPropValueFrom29, fli_filtPropValueTo29,
              fli_FiltPropCode30, fli_FiltPropRes30, fli_filtPropValueFrom30, fli_filtPropValueTo30,
              fli_FiltPropCode31, fli_FiltPropRes31, fli_filtPropValueFrom31, fli_filtPropValueTo31,
              fli_FiltPropCode32, fli_FiltPropRes32, fli_filtPropValueFrom32, fli_filtPropValueTo32,
              fli_FiltPropCode33, fli_FiltPropRes33, fli_filtPropValueFrom33, fli_filtPropValueTo33,
              fli_FiltPropCode34, fli_FiltPropRes34, fli_filtPropValueFrom34, fli_filtPropValueTo34,
              fli_FiltPropCode35, fli_FiltPropRes35, fli_filtPropValueFrom35, fli_filtPropValueTo35,
              fli_FiltPropCode36, fli_FiltPropRes36, fli_filtPropValueFrom36, fli_filtPropValueTo36,
              fli_FiltPropCode37, fli_FiltPropRes37, fli_filtPropValueFrom37, fli_filtPropValueTo37,
              fli_FiltPropCode38, fli_FiltPropRes38, fli_filtPropValueFrom38, fli_filtPropValueTo38,
              fli_FiltPropCode39, fli_FiltPropRes39, fli_filtPropValueFrom39, fli_filtPropValueTo39,
              fli_FiltPropCode40, fli_FiltPropRes40, fli_filtPropValueFrom40, fli_filtPropValueTo40,
              fli_FiltPropCode41, fli_FiltPropRes41, fli_filtPropValueFrom41, fli_filtPropValueTo41,
              fli_FiltPropCode42, fli_FiltPropRes42, fli_filtPropValueFrom42, fli_filtPropValueTo42,
              fli_FiltPropCode43, fli_FiltPropRes43, fli_filtPropValueFrom43, fli_filtPropValueTo43,
              fli_FiltPropCode44, fli_FiltPropRes44, fli_filtPropValueFrom44, fli_filtPropValueTo44,
              fli_FiltPropCode45, fli_FiltPropRes45, fli_filtPropValueFrom45, fli_filtPropValueTo45,
              fli_FiltPropCode46, fli_FiltPropRes46, fli_filtPropValueFrom46, fli_filtPropValueTo46,
              fli_FiltPropCode47, fli_FiltPropRes47, fli_filtPropValueFrom47, fli_filtPropValueTo47,
              fli_FiltPropCode48, fli_FiltPropRes48, fli_filtPropValueFrom48, fli_filtPropValueTo48,
              fli_FiltPropCode49, fli_FiltPropRes49, fli_filtPropValueFrom49, fli_filtPropValueTo49,
              fli_FiltPropCode50, fli_FiltPropRes50, fli_filtPropValueFrom50, fli_filtPropValueTo50,
              fli_FiltPropCode51, fli_FiltPropRes51, fli_filtPropValueFrom51, fli_filtPropValueTo51,
              fli_FiltPropCode52, fli_FiltPropRes52, fli_filtPropValueFrom52, fli_filtPropValueTo52,
              fli_FiltPropCode53, fli_FiltPropRes53, fli_filtPropValueFrom53, fli_filtPropValueTo53,
              fli_FiltPropCode54, fli_FiltPropRes54, fli_filtPropValueFrom54, fli_filtPropValueTo54,
              fli_FiltPropCode55, fli_FiltPropRes55, fli_filtPropValueFrom55, fli_filtPropValueTo55,
              fli_FiltPropCode56, fli_FiltPropRes56, fli_filtPropValueFrom56, fli_filtPropValueTo56,
              fli_FiltPropCode57, fli_FiltPropRes57, fli_filtPropValueFrom57, fli_filtPropValueTo57,
              fli_FiltPropCode58, fli_FiltPropRes58, fli_filtPropValueFrom58, fli_filtPropValueTo58,
              fli_FiltPropCode59, fli_FiltPropRes59, fli_filtPropValueFrom59, fli_filtPropValueTo59,
              fli_FiltPropCode60, fli_FiltPropRes60, fli_filtPropValueFrom60, fli_filtPropValueTo60,
              fli_filtFixedEarlistDateFrom, fli_filtFixedEarlistDateTo, fli_filtFixedEarlistDateInDaysFrom
              ,fli_filtFixedEarlistDateInDaysTo, fli_filtIgnoredProgress,
              fli_FiltResCatCode,

              fli_OverriddenTab,
              fli_FiltDependingOnNextHandledStep, fli_FiltDependingOnPrevHandledStep, fli_filtDependingOnNextHandledLinkedRequest, fli_filtDependingOnPrevHandledLinkedRequest,
              // grouped by fields
              fli_GroupedByCode, fli_GroupedByProdReq,fli_GroupedByProdFamily, fli_GroupedByPropCode1, fli_GroupedByPropCode2,
              fli_GroupedByPropCode3, fli_GroupedByPropCode4, fli_GroupedByPropCode5, fli_GroupedByPropCode6,
              fli_GroupedByPropCode7, fli_GroupedByPropCode8, fli_GroupedByPropCode9, fli_GroupedByPropCode10,
              // colors
              fli_ValFrom, fli_ValTo, fli_intColor, fli_bdrColor, fli_txtColor, fli_txtDescription, fli_LineNum, fli_Selected, fli_RscColDesc,
              fli_JobPropColor, fli_DftColor, fli_PropValFrom, fli_PropValTo,
              // exchange
              fli_excOpCode,
              fli_updCode,
              fli_updOp, fli_TimeDescr,
              //Bar text config
              fli_SetName, fli_SetDesc, fli_setIndex, fli_SetType, fli_fieldType,
              fli_WorkStation, fli_title,
              fli_orgTitle,fli_checked, fli_fromPos, fli_toPos, fli_IsResExpanded,
              fli_LineSeq,
              // AutoRunDefinition
              fli_AutomaticRunCode, fli_LineNumber, fli_OperationCode, fli_Bin, fli_Gantt, fli_OperationDetail ,

              // Job massages

              fli_To_WorkStation, fli_From_WorkStation , fli_Messages, fli_DateTime, fli_Status, fli_JobMsgEvent,
              // CustomizedDateColumn

              // GroupByPropertyRules
              fli_CodeRuleForGrouping,
              fli_PropertyCode1, fli_PropertyCode2, fli_PropertyCode3, fli_PropertyCode4,
              fli_PropertyCode5, fli_PropertyCode6, fli_PropertyCode7, fli_PropertyCode8,

              fli_TimeType,
              fli_StartingDateColumn,
              fli_PropertyDateColumn,
              fli_BinDateColumn,
              fli_ABSolute_Value,
              fli_ColumnNum,

              // Mail_set_List

              fli_MailGroupName,
              fli_User_Id,
              fli_Password,
              fli_Recipient,

              // licence
              fli_Lic, fli_LicUpd, fli_Ver,
              //tbl_cfg_exchg_glob
              fli_LAST_UPD, fli_SL_OP, fli_SL_ON,
              //
              fli_CONNECT, fli_OP, fli_POLL, fli_COUNTER, fli_MachineNumber,
              //tbl_wkc_priority
              fli_Mach_stp_code_lvl,
              fli_SequenceDepend,
              fli_PriorityRelation,
              //tbl_machine_setup_code
              fli_ResCatcode , fli_Desc, fli_ResSetupCode,
              //tbl_Wkc_dependency
              fli_SchedWkc, fli_SchedWkCtrProc, fli_DependOn,
              fli_DepIsSchedRscCat, fli_DepIsSchedWkc, fli_DepIsSchedRsc,
              fli_NoSchedRscCat, fli_NoSchedWkc, fli_NoSchedRsc,
              //tbl_material
            //  fli_MaterialDetailCode, fli_Material_product_sub_detail,
              fli_highDateAlloc, fli_SearchMatByAlloc,fli_settled,fli_AllocQty, fli_AllocQty_Mat, fli_AllocReq, fli_Prod_Balance,
              fli_issueCode,fli_quantityIssue,fli_netGroupCode,fli_ProdCode,fli_IssueItemType, fli_AWHAltern_Net_Group_Code,
              fli_orgStep, fli_reqQuant, fli_reqQuant_mat, fli_seqIssued, fli_MatBalance,
              fli_MachSetupCode, fli_AlternativCode,
              //tbl_material_sup_detail
              fli_searchBalance, fli_waitEntireMat, fli_issueTransType,
              fli_updReqHrs, fli_MatProdType,
              //tbl_material_sup_header
              //fli_ResCatcode ,fli_wkcProc, fli_wkCtrCode, fli_ResCode, fli_prodtype , fli_minQty
              fli_waitPrevQty,fli_MinQtyPassNxt, fli_MinQtyPrevStp, fli_MinDelWaitDays,
              fli_MinDelWaitHrs, fli_MinDelWaitMin, fli_MaxDelWaitDays, fli_MaxDelWaitHrs,
              fli_MaxDelWaitMin, fli_PartDel, fli_UpdBalHrs, fli_UpdBalQty,
              fli_UpdReqPrevStpHrs,
              //tbl_produced_article
              fli_qtyProduced, fli_sequenceChar, fli_ProductNature,fli_occupyCode, fli_StartConsumPoint, fli_EndConsumPoint, fli_HoursToDownFromMachine,
              fli_MaterialSchedule, fli_MaterialStandardSetupMinutes, fli_MaterialStandardSpeed,
             //tbl_MaterialDetailSchedule
              fli_Sub_Detail,
              fli_Detail_Code,
              fli_OverridenSpeed,
              fli_OverridenSetupTime,
              fli_FirstJobQuantityIncluded,
              fli_LastJobQuantityIncluded,
              fli_HostItemIndentifier,
              fli_HostWarehouse,
              fli_SubDetailHostType,
              fli_DetailCodeType,

           // tbl_SchedulesDownloadWarpRSV
              fli_Environment, fli_CompanyCode, fli_CounterCode, fli_Code, fli_Reservationline,

              // tbl_products
        //      fli_description,
              // tbl ps new fields
              fli_NettedQuantity,
              fli_ChangedQuantity,
              fli_downloadType,

              fli_downloadTime,

              //Tool bar Bin
              fli_ToolBarDock, fli_ToolBarLeft,fli_ToolBarTop, fli_ToolBarWidth,
              fli_ToolBarHeight, fli_ToolBarState,
              //AutoSched
              fli_CfgName, fli_CfgDesc, fli_MinJobResComp, fli_MinJobJobComp, fli_MaxJobJobComp, fli_MinJobCapResComp, fli_IgnorMaterialCheck, fli_CfgNextName,
//              fli_DateWgth, fli_JobResCompWgth, fli_JobJobCompWgth, fli_JobCapResCompWgth, fli_JobSetupChange,
//              fli_AfterDelDate, fli_TollAfterDelDate,
              fli_LimitGapBtwnSubSteps, fli_ToleranceDaysGapBtwnSubSteps,fli_ToleranceHoursGapBtwnSubSteps, fli_ToleranceMinGapBtwnSubSteps,
              fli_AfterHighLimit, fli_TollAfterHighLimit, fli_TollAfterHighLimitHours,
              fli_TollAfterHighLimitMinutes, fli_BeforeLowLimit, fli_TollBeforeLowLimit,
              fli_TollBeforeLowLimitHours, fli_TollBeforeLowLimitMinutes, fli_LoadedResource, fli_LoadedOnSameResCat,fli_StopOnFirstNotSchedJob, fli_SortBeforeSchedule,
              fli_BinColField1, fli_BinColField2, fli_BinColField3,fli_BinColField4,fli_BinColField5,
              fli_PrefTgtDate, fli_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled, fli_MoveObjsAllowed, fli_MoveFinalObjsAlwd, fli_AutoSplitByStdBtchSize, fli_LastSplitCanGoUnderMinMac,
              fli_CreteriaOfResForBachZise , fli_MoveInitialObjsAlwd, fli_MoveLevel1ObjsAlwd, fli_MoveLevel2ObjsAlwd,
              fli_MoveLevel3ObjsAlwd, fli_MoveLevel4ObjsAlwd, fli_MoveLevel5ObjsAlwd, fli_MinStartDateOffset,
//              fli_GradBfrTollLSD, fli_GradBtwToll_LSD, fli_GradBtwLSD_TGTD, fli_GradBtwTGTD_HED,
//              fli_GradBtwHED_Toll, fli_GradBtwTollHED_Del, fli_GradBtwDel_Toll, fli_GradAftTollDel,
              fli_PriorErrLoop, fli_TempFinal, fli_Sleep, fli_RankRep, fli_GroupAllowOneJob,
              fli_MatWOMaterials, fli_OneRequestAtTime, fli_MatLinkReq, fli_MatWOAddRes, fli_CompactEntities,
              fli_NextDays, fli_GraphOnMove, fli_StdPurcOrProdTime, fli_ModuleRule, {fli_MCM_RequestType, fli_MCM_CapacitySearch,
              fli_MCM_MaterialSearch, fli_MCM_RequestedDate, fli_MCM_RequestedDateType, fli_MCM_Priority, fli_MCM_LoaderDays, }
              fli_WorkStationType, fli_Category, fli_MixRegroups, fli_NumOfMachines, fli_CompCaseNum, fli_DaysPanelty,
              fli_FiniteCapacity, fli_MQMRelevance, fli_MCMRelevance, fli_SchedulByMcm, fli_SchedulByMqm, fli_ModulHandled,
              fli_StartDownloadDateTime,
              // AutoSched work center configuration
              fli_StandardSlotDuration,

              // AutoSched New fields
              fli_SortResource, fli_ResourceToSchedule, fli_AllowSchedBeforeNoneConfLevl,
              fli_BefEarlDateTol, fli_WithEarlDateTol, fli_AfterLatDateTol, fli_WithLatDateTol,
              fli_ScheduleToPossibleStartPenalty, fli_CfgGroup, fli_AutoSeq_RunningMode, fli_StartSchedFrom, fli_StartSched_SpecificDateTime, fli_StartSched_NumberOfDaysFromCurrentDate,
              fli_PenJobToJob, fli_PenSetupMin, fli_PenJobToRes, fli_PenJobToCapRes, fli_PenJobNotCapRes,
              fli_DateScoreWeight, fli_CompScoreWeight,
              fli_HoursToleranceOfGapBetweenJobs, fli_RescheduleErlierJobsWhenTolerance, fli_PenaltyScoreWithinTolerance, fli_PenaltyScoreAfterTolerance,
              fli_IgnoreRightOverlapping, fli_IgnoreLeftOverlapping, fli_LatestDateLimit, fli_DateLimitType, fli_NumberOfdaysFromStartingPoint,
              fli_DateFromStartPointAllowed, fli_forceSameWcPlantToServingGroup, fli_CalendarForDatesPenalty,
              fli_SubCategory, fli_SubCategoryDesc,
              fli_PROGR, fli_DELTAPERC, fli_CONFLEV, fli_MCMREQGROUP, fli_FIRSTPRIORITY, fli_SECPRIORITY,
              fli_WRITTENBY, fli_QUEUE_STATUS, fli_ERRORTXT, fli_PRIORITY, fli_PROPVALUEFROM, fli_PROPVALUETO,
                            // LearningCurve
              fli_LearningCurveDesc,
              fli_CurveFirstHours, fli_CurveFirstEffic,
              fli_CurveSecondHours, fli_CurveSecondEffic,
              fli_CurveThirdHours, fli_CurveThirdEffic,
              fli_CurveForthHours, fli_CurveForthEffic,
              fli_CurveFifthhHours, fli_CurveFifthEffic,
              fli_CurveSixthHours, fli_CurveSixthEffic,
              fli_CurveSevenThHours, fli_CurveSevenThEffic,
              fli_CurveEighthHours, fli_CurveEighthEffic,

              //tbl_ItemsStock,
              fli_ItemType,
              fli_Stock,
              fli_ItemCode,
              fli_Date,

              //tbl_ItemsStockExceptions,
              fli_DayInWeek,
              fli_fromTime,
              fli_ToTime,
              fli_StockDifference,

              //tbl_capRes_DynamicPerRes,
              fli_ToDateLimit,
              //tbl_capRes_DynamicPerDate
              fli_NumberOfHours,
              fli_Color,

              // GroupResDefinition
              fli_NumberOfScheduleCounter,

              // StockDetails

              fli_Details, fli_used, fli_BalanceIdentifier,

              // tbl_AutoSeq_ScoreAddition
              fli_From_Job_to_Prior_Job_case, fli_To_Job_to_Prior_Job_case,
              fli_From_Job_to_Follow_Job_case, fli_To_Job_to_Follow_Job_case,
              fli_From_Job_to_resource_case, fli_To_Job_to_resource_case,
              fli_From_number_of_days_delay, fli_To_number_of_days_delay,
              fli_From_number_of_days_early, fli_To_number_of_days_early,
              fli_From_number_minutes_setup_add, fli_To_number_minutes_setup_add,
              fli_Add_to_score, fli_Double_Direction,

              // tbl_AutoSeqJobToJobDefinitions
              fli_From_Case, fli_ToCase,

              // log
              fli_LogOrigin,
              fli_ScheduleInfo,
              fli_Reason,

              // OVERRIDE_STEP_PARAM
              fli_speed,
              fli_setup,

              //tbl_Material_Tollerance_Types
              fli_Material_Tollerance_Types_Code,
              fli_Material_Tollerance_Types_Desc,
              fli_TillQty1,
              fli_TillQty1Percent,
              fli_TillQty2,
              fli_TillQty2Percent,
              fli_TillQty3,
              fli_TillQty3Percent,
              fli_TillQty4,
              fli_TillQty4Percent,
              fli_TillQty5,
              fli_TillQty5Percent,

              //Filters
              fli_Id, fli_CTABLE, fli_BACTIVE, fli_CSQL, fli_CLOCK, fli_CCAPTION,

              //filters_col
               fli_ID_TABLE, fli_CCOLUMN, fli_CCOND, fli_CVALUES, fli_BVISIBLE,

              //totalsView
              fli_TotalCode, fli_OwnerWorkstation,

              //TotalsViewContent
              fli_ArgumentNumber, fli_Attribute, fli_Formula, fli_NumberOfDecimals,

              fli_ABSUniqueID , fli_MenuCode, fli_MenuCaption,

              //SavedPlanCopy
              fli_BucketType, fli_BucketQty , fli_BucketDate ,

              //2nd warp level
              fli_ItemType2,fli_ProdCode2,

              //mcmtabconfig
              fli_SlotScnLevel, fli_WkcScnLevel, fli_IsSlotExpanded, fli_IsWkcExpanded

  );


  TInfoStruct = record
    fInfo  : fldId;
    nrkey  : byte;
    notnull: boolean;
    defval : shortint;
  end;

  structOut = array[0..800] of TInfoStruct;

  TTblInfo = record
    HostName: string;
    IBname: string;
    PCname: string;
    ASname: string;
    pfx   : string;
    struct: ^structOut;
    nrfld : integer;
   // group : shortint; // Main_db=1 Cfg_Db=2 Both=3
    group : shortint;
    arc   : shortint; // ARCHIVE = 0, OTHER,1
    function GetTableName : string;
    function GetLicTableName(Cfg : boolean) : string;
  end;
  PTblInfo = ^TTblInfo;

  TDomInfo = record
    typ:     dbType;
    len:     integer;
    dec:     integer;
  end;

  TFldInfo = record
{$ifdef DEVELOP}
    fInfo: fldId;
{$endif}
    name:  string;
    dom:   domain;
  end;

  function  CreateFldDef(pfx: string; fld: fldId): string;
  function  CreateFld(pfx: string; fld: fldId): string;
  procedure SetFldPfx(pfx: string);
  function  CreatePfxFldDef(fld: fldId): string;
  function  CreatePfxFld(fld: fldId): string;
  function  CreateFldType(fld: fldId): string;
  function  DBopToChar(op: dbOp): string;
  function  CharToDBop(ch: string): dbOp;

const

  CVoidCharStr = '';
  CVoidCharChk = '<> '' ''';
  CAnnulFilter = '='' ''';

  CHistorical  = '<> ''2''';

  struct_tbl_arty : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ArtType;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BalanceDecNum;                      nrkey: 0;   notnull: true;    defval : 2)
    );

  struct_Material_Tollerance_Types : array[1..13] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Material_Tollerance_Types_Code;    nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Material_Tollerance_Types_Desc;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TillQty1;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TillQty1Percent;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TillQty2;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TillQty2Percent;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TillQty3;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TillQty3Percent;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TillQty4;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TillQty4Percent;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TillQty5;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TillQty5Percent;                   nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_unit : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Um;                                 nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DecNum;                             nrkey: 0;   notnull: false;   defval : 0)
    );

  struct_tbl_calendar : array[1..12] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalCod;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalDate;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Prog_Wrk_Hr;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH1_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH1_end;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH2_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH2_end;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH3_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH3_end;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH4_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH4_end;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_calShiftEffic : array[1..17] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalCod;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalStartDate;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalEndDate;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH1_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH1_end;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH1_EFFIC;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH2_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH2_end;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH2_EFFIC;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH3_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH3_end;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH3_EFFIC;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH4_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH4_end;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH4_EFFIC;                          nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkst : array[1..9] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkDescr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkPasswd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WorkStationType;                    nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkst_wkc : array[1..9] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TypeOfUse;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Visible;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_group : array[1..4] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrGroup;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PlantCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MainWC;                             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc : array[1..14] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrGroup;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TypOprtion;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TypProcess;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumResPlan;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalCod;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlantCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MCMSequence;                        nrkey: 0;   notnull: false;   defval :  0),
    (fInfo: fli_WarpHandle;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Ignoreprogress;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Division;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_proc : array[1..8] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResOccupation;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupType;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_UseAllResourceParts;                nrkey: 0;   notnull: false;   defval : -1)
   );

  struct_tbl_Licence : array[1..3] of TInfoStruct = (
    (fInfo: fli_Lic;                                nrkey: 0;   notnull: true;    defval : 0),
    (fInfo: fli_Ver;                                nrkey: 0;   notnull: true;    defval : 1),
    (fInfo: fli_LicUpd;                             nrkey: 0;   notnull: false;   defval : 1)
  );

  struct_tbl_Licence2 : array[1..3]of TInfoStruct = (
    (fInfo: fli_Lic;                                nrkey: 0;   notnull: true;    defval : 0),
    (fInfo: fli_Ver;                                nrkey: 0;   notnull: true;    defval : 2),
    (fInfo: fli_LicUpd;                             nrkey: 0;   notnull: false;   defval : 1)
  );

  struct_tbl_wkc_alt : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_AlterWC;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_AlterWCProces;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_alt_warehouse : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_AlterWC;                            nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_netGroupCode;                       nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_IssueItemType;                      nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_AWHAltern_Net_Group_Code;           nrkey: 0;   notnull: false;  defval : -1)
  );

  struct_tbl_wkc_prodLine : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ProdLine;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DateBegin;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DateEnd;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumResPlan;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_priority : array[1..11] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SequenceDepend;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SeqAlpha;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PriorityRelation;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Mach_stp_code_lvl;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_cat_capacity : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Category;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DateBegin;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NumMachinesTosuspend;               nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_res : array[1..24] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProcesType;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RscCat;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Standrd_bch_Size;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BchUM;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalCod;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rscType;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumOfRsc;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Min_bch_size;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Max_bch_size;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DisplayText1;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DisplayText2;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WorkAsOneBatchMachineGroupCode;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Rsc_PLanType;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OneBatchMachineGrouptype;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LineWithinPlant;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropOptimumMaxMultiplier;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropMinMultiplier;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ForceOutsideLimitQty;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ForceOccToResCase99;                nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_res_sub : array[1..11] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SubRsc;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalCod;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLine;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Comment;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumSubRscComponents;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_res_apa : array[1..10] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SubRsc;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DateBegin;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DateEnd;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumOfRsc;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_resCat : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RscCat;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CategorySDesc;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CategoryLDesc;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AdditionalCapacity;                 nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_Identifiers : array[1..2] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_Archive_To_Host : array[1..3] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Tbl_Name;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Tbl_Host;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_GeneratorNumber : array[1..3] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_GeneratorCode;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_GeneratorNum;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_addRes : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_addiCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConsumingZone;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prop_res : array[1..18] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RscCat;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WCProcess;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropBaseValue;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Propty_Calculated_Value;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropAddRscOfOcc;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropAddValToAddiRsc;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropValTakeForGroup;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropDftCaseRsc_Occ_Ruls;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropDftCaseOcc_Occ_Ruls;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropDftSameGroupForOcc_Occ_Ruls;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ruleResToOcc : array[1..17] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RscCat;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WCProcess;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ProdType;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropLineNum;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Sequence;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropOperand;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DepOnCurr;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DepValue;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropCase;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ruleOccToOcc : array[1..33] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RscCat;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WCProcess;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ProdType;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropLineNum;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Sequence;                           nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_DepOnCurr;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DepValue;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RuleConst;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropOperand;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropCase;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropSetupTyp;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropSetUpTime;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropSetUpOverlappTime;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropSetUpTimeMult;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropSetUpOverlappTimeMult;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CanBeSameGroup;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_teoreticl_wc;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_duration;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LeadTime;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RuleOccFrom;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RuleOccLength;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RuleOccForPartialPropVal;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WhenOkNextSeq;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DecNum;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LearningCurveCode;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_GroupByPropertyRules : array[1..11] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CodeRuleForGrouping;                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode1;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode2;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode3;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode4;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode5;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode6;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode7;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode8;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prop : array[1..23]of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropSDesc;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropLDesc;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropLen;                            nrkey: 0;   notnull: false;   defval : -1), // (1A)  1=alfa  2=Numeric
    (fInfo: fli_DecNum;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ChgPropValCauseResched;             nrkey: 0;   notnull: false;   defval : -1), // (1A)  0=no  1=yes
    (fInfo: fli_RP_MainLevel;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RP_Add_WC_Proc;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RO_CompatChekType;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RO_MainLevel;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RO_Add_WC_Proc;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RO_Add_ProdType;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OO_CompatChekType;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OO_MainLevel;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OO_Add_WC_Proc;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OO_Add_ProdType;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MQMRelevance;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MCMRelevance;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropInstanceCounter;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropValueInstanceCounter;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropIsdate;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_PROP_PROD_PLANNER : array[1..8] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropValue;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_Prop_Show_Color : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropValFrom;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropValTo;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_JobPropColor;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DftColor;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prop_prod : array[1..11] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropValue;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ABSUniqueID;                        nrkey: 0;   notnull: True;    defval :  0),
    (fInfo: fli_CreateDateTimeUTC;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_tmp_prod_prop : array[1..9] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_PropValue;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_req : array[1..11] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_divCode;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_dispoCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bch;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_reprocNo;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_HistoriclReq;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ModulHandled;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ABSUniqueID;                        nrkey: 0;   notnull: True;    defval :  0)
  );

  struct_tbl_prod_reqHdr : array[1..25] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_HistoriclReq;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ReqOrigin;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLine;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdFamily;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaterialFamily;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdUMCode;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLowDataTime;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdDelivDate;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcDelDate;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ModulHandled;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SplitConfLevels;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LeadpstepIdForSplit;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NewPreqUniqId;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Serving_Code;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Served_Code;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveFamilyIdCode;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ABSUniqueID;                        nrkey: 0;   notnull: True;    defval :  0),
    (fInfo: fli_CreateDateTimeUTC;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_tmp_prod_reqHdr : array[1..14] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_HistoriclReq;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ReqOrigin;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLine;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdFamily;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaterialFamily;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdUMCode;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLowDataTime;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdDelivDate;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcDelDate;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );
  struct_tbl_prod_info : array[1..8] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_infoType;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_infoLineNum;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_InfoArea;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_reqConnection : array[1..8]of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PrevProdNum;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ABSUniqueID;                        nrkey: 0;   notnull: True;    defval :  0),
    (fInfo: fli_CreateDateTimeUTC;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ext_info : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ConnKey;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_infoLineNum;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_InfoArea;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ext_infoHdr : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ConnKey;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ConnType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DueDate;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ext_connection : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ConnKey;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NumOfLevel;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnCertentyLevel;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_step : array[1..69] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_ToBeSched;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prevStepSched_Mqm;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prevStepTrue;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStepSched_Mqm;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStepTrue;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaterialArrivDate;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcMatDate;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_planStart;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LowStartTimeLimit;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcLowestDate;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_planEnd;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_HighEndTimeLimit;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcHighestDate;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_InitialPlanScheduledDateTime;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FinalPlanScheduledDateTime;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantInit;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantFinl;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Weight;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DescUM;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalCod;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SetupTimStep;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_excTimeStep;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumResPlan;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AllowSplit;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepHandleReProc;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepPartGenralPlan;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepCanGroup;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ForcedGroupNo;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnTypToPrevStepSplit;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcOverlapp;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepClosed;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SchedulByMcm;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SchedulByMqm;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SplitFamaly;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LearningCurveCode;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LearningCurveType;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ApprovalDate;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GrpContinueSeq;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrevLeadtime_mqm;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextLeadtime_mqm;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrevLeadTimeBatch_mqm;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextLeadTimeBatch_mqm;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BatchSizePerStep;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MinBatchSize;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OptimumBatchSize;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaxBatchSize;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OverlapWithOtherSteps;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prevStepSched_Mcm;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStepSched_Mcm;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrevLeadTime_Mcm;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextLeadTime_Mcm;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrevLeadTimeBatch_Mcm;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextLeadTimeBatch_Mcm;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumSubRscComponents;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaxStartDateAutoSeq;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_alternative_Qty;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_alternative_UM;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ABSUniqueID;                        nrkey: 0;   notnull: True;    defval :  0),
    (fInfo: fli_CreateDateTimeUTC;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_tmp_prod_reqDet : array[1..37] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ToBeSched;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prevStepSched_mqm;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prevStepTrue;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStepSched_mqm;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStepTrue;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaterialArrivDate;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcMatDate;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_planStart;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LowStartTimeLimit;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcLowestDate;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_planEnd;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_HighEndTimeLimit;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcHighestDate;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantInit;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantFinl;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Weight;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DescUM;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalCod;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SetupTimStep;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_excTimeStep;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumResPlan;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AllowSplit;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepHandleReProc;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepPartGenralPlan;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepCanGroup;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ForcedGroupNo;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnTypToPrevStepSplit;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcOverlapp;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepClosed;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_step_batchSize : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_BchUM;                              nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_multipToBatchUm;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CreateDateTimeUTC;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_step_times : array[1..15] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RscCat;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MachSetupCode;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetUpTimJob;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ExecTimeInitQty;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CapUsed;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConfLev;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ABSUniqueID;                        nrkey: 0;   notnull: True;    defval :  0),
    (fInfo: fli_CreateDateTimeUTC;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_sched : array[1..70] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_psubstId;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_reprocNo;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_vers;                               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_updOp;                              nrkey: 0;   notnull: false;   defval : -1), //DBopToChar(dbo_none) = ' '
    (fInfo: fli_ProdType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLine;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdUMCode;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantInit;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_stGroup;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepIsGrouped;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedType;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AlternativCode;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rsc;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_subLinRscId;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumSubRscComponents;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quant;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_supMinBase;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_supMinReal;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_supMinOvlp;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_exeMin;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedStart;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedEnd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Comment;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnForwardSubStep;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnForwardReProcess;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnBackwardSubStep;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnBackwardReProcess;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SaveAtLeastOnesAsFinnal;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NettedQuantity;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ChangedQuantity;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MachSetupCode;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
//    (fInfo: fli_BinSel;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Prog_Override_Type;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCodeKeyFileST;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WCProcessKeyFileST;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rscKeyFileST;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResCatKeyFileST;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NewPreqUniqId;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SplitFamaly;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LearningCurveCode;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LearningCurveCodeByOccToOcc;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GrpContinueSeq;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LastScheudleChange;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ActualStart;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ActualEnd;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Mqm_environment;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FirstScheduleResource;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FirstScheduleStart;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FirstScheduleEnd;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_VersionIdentifier;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_VersionScheduleResource;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_VersionScheduleStart;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_VersionScheduleEnd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ABSUniqueID;                        nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_StepWorkCenter;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepWorkCenterProcess;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ForcedGroupNo;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupInternalSortSeq;               nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_NewSetup;                           nrkey: 0;   notnull: true;    defval :  0)
  );

  struct_tbl_prod_sched_mcm : array[1..70] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_psubstId;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_reprocNo;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_vers;                               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_updOp;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLine;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdUMCode;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantInit;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_stGroup;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepIsGrouped;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedType;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AlternativCode;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rsc;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_subLinRscId;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumSubRscComponents;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quant;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_supMinBase;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_supMinReal;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_supMinOvlp;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_exeMin;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedStart;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedEnd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Comment;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnForwardSubStep;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnForwardReProcess;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnBackwardSubStep;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnBackwardReProcess;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SaveAtLeastOnesAsFinnal;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NettedQuantity;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ChangedQuantity;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MachSetupCode;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
//    (fInfo: fli_BinSel;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Prog_Override_Type;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCodeKeyFileST;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WCProcessKeyFileST;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rscKeyFileST;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResCatKeyFileST;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NewPreqUniqId;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SplitFamaly;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LearningCurveCode;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LearningCurveCodeByOccToOcc;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GrpContinueSeq;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LastScheudleChange;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ActualStart;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ActualEnd;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Mqm_environment;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FirstScheduleResource;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FirstScheduleStart;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FirstScheduleEnd;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_VersionIdentifier;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_VersionScheduleResource;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_VersionScheduleStart;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_VersionScheduleEnd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ABSUniqueID;                        nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_StepWorkCenter;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepWorkCenterProcess;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ForcedGroupNo;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupInternalSortSeq;               nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_NewSetup;                           nrkey: 0;   notnull: true;    defval :  0)
  );

  struct_tbl_prod_sched_shared_data : array[1..11] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_psubstId;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_reprocNo;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Comment;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_schedForce : array[1..35] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_psubstId;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_reprocNo;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_ProdType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLine;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdUMCode;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantInit;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_stGroup;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepIsGrouped;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedType;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rsc;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_subLinRscId;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumSubRscComponents;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quant;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_supMin;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_exeMin;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedStart;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedEnd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Comment;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnForwardSubStep;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnForwardReProcess;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnBackwardSubStep;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnBackwardReProcess;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SaveAtLeastOnesAsFinnal;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TimeDescr;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_sched_progress : array[1..24] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_psubstId;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_reprocNo;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ProgressType;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rsc;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProgressGroup;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_progrStart;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prgCurrDate;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_progrEnd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quant;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StartingQty;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prgRemTime;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProgressTypeHost;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rscHost;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_progrStartHost;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prgCurrDateHost;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_progrEndHost;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantHost;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prgRemTimeHost;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ABSUniqueID;                        nrkey: 0;   notnull: True;    defval :  0),
    (fInfo: fli_CreateDateTimeUTC;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_sched_progress_override : array[1..16] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_psubstId;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_reprocNo;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ProgressType;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rsc;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProgressGroup;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_progrStart;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prgCurrDate;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_progrEnd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quant;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StartingQty;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prgRemTime;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Prog_Override_Type;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProgressReApplied;                  nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_capRes: array[1..18] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CapacyResrv;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_subLinRscId;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WCProcess;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CapacyResTyp;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Capacity_To_Job;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Comment;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedStart;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedEnd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ColorIndex;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_exeMin;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CapacyResrvStatus;                  nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_capRes_Host : array[1..17] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CapacyResrv;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_subLinRscId;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WCProcess;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CapacyResTyp;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Capacity_To_Job;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Comment;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedStart;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedEnd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ColorIndex;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_exeMin;                             nrkey: 0;   notnull: false;   defval : -1)// temporary , shoul be removed (Avi)
  );

  struct_tbl_capRes_DynamicPerRes : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DateBegin;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_fromTime;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ToDateLimit;                        nrkey: 0;   notnull: false;   defval : -1)
  );
  struct_tbl_capRes_DynamicPerDate : array[1..10] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DateBegin;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_fromTime;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Sequence;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NumberOfHours;                      nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_Color;                              nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_Desc;                               nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_CompCaseNum;                        nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_Comment;                            nrkey: 0;   notnull: false;    defval : -1)
  );

  struct_tbl_capRes_DynamicPerResDateProp : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DateBegin;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_fromTime;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Sequence;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropValue;                          nrkey: 0;   notnull: false;    defval : -1)
  );

  struct_tbl_prop_capRes : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CapacyResrv;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropValue;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_Proc : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Alternative_um_handled;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RuleForGroupingMQM;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RuleForGroupingMCM;                 nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_Cal : array[1..4] of TInfoStruct  =(
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalCod;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_EfficiencyOnWcOrResLevel;           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_Change : array[1..3] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_rsc_Change : array[1..3] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_Req_Change : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ChangeType;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ReactivateReq;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_CapRsc_Change : array[1..4] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CapacyResrv;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ChangeType;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_AppGlobSettings : array[1..1] of TInfoStruct = (
    (fInfo: fli_AppGlobSettings;                    nrkey: 0;   notnull: false;   defval : -1) // environement description
  );

  //Cfg
  struct_tbl_cfg_appGlob : array[1..47] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_EnvDescr;                           nrkey: 0;   notnull: false;   defval : -1), // environement description
    (fInfo: fli_Customer;                           nrkey: 0;   notnull: false;   defval : -1), // Customer
    (fInfo: fli_MqmVersion;                         nrkey: 0;   notnull: false;   defval : -1), // Mqm Version
    (fInfo: fli_MonthBefore;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StDateForPlan;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Language;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurrTScale;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurrDtTime;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ShowCal;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurrRscSort;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ShowZoom;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RscOrderType;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RscOrderItem;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wdwPlanLeft;                        nrkey: 0;   notnull: false;   defval : -1), // left position
    (fInfo: fli_wdwPlanTop;                         nrkey: 0;   notnull: false;   defval : -1), // top position
    (fInfo: fli_wdwPlanWidth;                       nrkey: 0;   notnull: false;   defval : -1), // width
    (fInfo: fli_wdwPlanHeight;                      nrkey: 0;   notnull: false;   defval : -1), // height
    (fInfo: fli_wdwPlanState;                       nrkey: 0;   notnull: false;   defval : -1), // maximized or not
    (fInfo: fli_wdwBinDock;                         nrkey: 0;   notnull: false;   defval : -1), // 0/1/-1 = undocked/right/bottom
    (fInfo: fli_wdwBinLeft;                         nrkey: 0;   notnull: false;   defval : -1), // left position
    (fInfo: fli_wdwBinTop;                          nrkey: 0;   notnull: false;   defval : -1), // top position
    (fInfo: fli_wdwBinWidth;                        nrkey: 0;   notnull: false;   defval : -1), // width
    (fInfo: fli_wdwBinHeight;                       nrkey: 0;   notnull: false;   defval : -1), // height
    (fInfo: fli_wdwBinState;                        nrkey: 0;   notnull: false;   defval : -1), // state
    (fInfo: fli_wdwBinSplitter;                     nrkey: 0;   notnull: false;   defval : -1), // splitter position

    (fInfo: fli_ToolBarDock;                        nrkey: 0;   notnull: false;   defval : -1), // 0/1/-1 = undocked/right/bottom
    (fInfo: fli_ToolBarLeft;                        nrkey: 0;   notnull: false;   defval : -1), // left position
    (fInfo: fli_ToolBarTop;                         nrkey: 0;   notnull: false;   defval : -1), // top position
    (fInfo: fli_ToolBarWidth;                       nrkey: 0;   notnull: false;   defval : -1), // width
    (fInfo: fli_ToolBarHeight;                      nrkey: 0;   notnull: false;   defval : -1), // height
    (fInfo: fli_ToolBarState;                       nrkey: 0;   notnull: false;   defval : -1), // state

    (fInfo: fli_CheckStepSeq;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CenterStartOnMove;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WarnOnMoveFinal;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DefSchedType;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MoveOption;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ActAutoSchedCode;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConfLevels;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ShowColorJobMode;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_UnscheduleClosedJobsOnStart;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SlotDisplay;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CustomSlotDisplay;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CustomPROPDisplay;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CustomPROPSymbol;                   nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_appIni : array[1..4] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_FieldName;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_value;                              nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_appSettings : array[1..3] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_appSettings;                        nrkey: 0;   notnull: false;   defval : -1)// string for settings
  );

  struct_tbl_cfg_AutoSched : array[1..88] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CfgName;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CfgDesc;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MinJobResComp;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MinJobJobComp;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaxJobJobComp;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MinJobCapResComp;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AfterHighLimit;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TollAfterHighLimit;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TollAfterHighLimitHours;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TollAfterHighLimitMinutes;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BeforeLowLimit;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TollBeforeLowLimit;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TollBeforeLowLimitHours;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TollBeforeLowLimitMinutes;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrefTgtDate;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled; nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MoveObjsAllowed;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MoveFinalObjsAlwd;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MoveInitialObjsAlwd;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MoveLevel1ObjsAlwd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MoveLevel2ObjsAlwd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MoveLevel3ObjsAlwd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MoveLevel4ObjsAlwd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MoveLevel5ObjsAlwd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MinStartDateOffset;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PriorErrLoop;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TempFinal;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Sleep;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RankRep;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupAllowOneJob;                   nrkey: 0;   notnull: false;   defval : -1),
    // this files is not in used
    (fInfo: fli_MatWOMaterials;                     nrkey: 0;   notnull: false;   defval : -1),
    ////////////////////////////////////////////////////////////////////////////////////////////
    (fInfo: fli_OneRequestAtTime;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MatLinkReq;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MatWOAddRes;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CompactEntities;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextDays;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GraphOnMove;                        nrkey: 0;   notnull: false;   defval : -1),
     // New fields
    (fInfo: fli_BefEarlDateTol;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WithEarlDateTol;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AfterLatDateTol;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WithLatDateTol;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PenJobToJob;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PenSetupMin;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PenJobToRes;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PenJobToCapRes;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PenJobNotCapRes;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DateScoreWeight;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CompScoreWeight;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AutoSplitByStdBtchSize;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LastSplitCanGoUnderMinMac;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CreteriaOfResForBachZise;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LoadedResource;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SortBeforeSchedule;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColField1;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColField2;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColField3;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColField4;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColField5;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LoadedOnSameResCat;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StopOnFirstNotSchedJob;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LimitGapBtwnSubSteps;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ToleranceDaysGapBtwnSubSteps;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ToleranceHoursGapBtwnSubSteps;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ToleranceMinGapBtwnSubSteps;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CfgNextName;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SortResource;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResourceToSchedule;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AllowSchedBeforeNoneConfLevl;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ScheduleToPossibleStartPenalty;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CfgGroup;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AutoSeq_RunningMode;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StartSchedFrom;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StartSched_SpecificDateTime;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StartSched_NumberOfDaysFromCurrentDate; nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_HoursToleranceOfGapBetweenJobs;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RescheduleErlierJobsWhenTolerance;  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PenaltyScoreWithinTolerance;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PenaltyScoreAfterTolerance;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_IgnoreRightOverlapping;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_IgnoreLeftOverlapping;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_forceSameWcPlantToServingGroup;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalendarForDatesPenalty;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LatestDateLimit;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DateLimitType;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumberOfdaysFromStartingPoint;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DateFromStartPointAllowed;          nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_AutoSchedWorkCenter : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CfgName;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StandardSlotDuration;               nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_AutoRunDefinition : array[1..10] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_AutomaticRunCode;                   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_LineNumber;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Sequence;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OperationCode;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Bin;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Gantt;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OperationDetail;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MailGroupName;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_binFilter : array[1..359] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsDesc;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TabVis;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MinQty;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaxQty;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rsc;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rsc_To;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLowDate_From;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLowDate_To;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DelivDate_From;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DelivDate_To;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanStartDate_From;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanStartDate_To;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanStartDateToday_From;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanStartDateToday_To;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanEndDate_From;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanEndDate_To;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanEndDateToday_From;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanEndDateToday_To;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStartDate_From;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStartDate_to;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStartDateToday_From;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStartDateToday_To;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrevEndDate_From;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrevEndDate_to;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrevEndDateToday_From;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrevEndDateToday_To;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LowStartDate_From;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LowStartDate_To;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SchedStartDate_From;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SchedStartDate_To;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DaysFromToday_From;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DaysFromToday_To;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DaysFromToday_ToTime;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ScheduledJobsCrossesDateTime_From;  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ScheduledJobsCrossesDateTime_To;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltTemporary;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Bin_ReadOnly;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCode_To;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcProc_To;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ShowAlternative;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Wkcr_FromPlan;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_preqNo_To;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdFamily;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaterialFamily;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltSchedJobs;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltFltJobsOnGantt;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltClosedJobs;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Bin_OnlyReadOnly;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltOnlySchedJobs;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltOnlyClosedJobs;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltGroups;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltOnlyGroups;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPriority;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltProgress;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltOnlyProgress;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltAfterDeliveryDay;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltAfterDeliveryInDays;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltBeforeEarliestStart;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltBeforeEarliestStartInDays;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltAfterLatestEnd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltAfterLatestEndInDays;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltShouldBeScheduled;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltShouldBeScheduledIndays;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltMissingmaterials;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltMissingAddRes;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltOveridePrevious;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltOverideNext;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltCompWithPrevJob;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltCompWithPrevJobInCase;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltCompWithRes;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltCompWithResInCase;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LatestEndingDate_From;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LatestEndingDate_To;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltJobMsg;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltImbalancedSteps;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_pstepId_To;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_stGroupFrom;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_stGroupTo;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_psubstId;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_psubstId_To;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltConfLevels_final;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltConfLevels_Ini;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltConfLevel1;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltConfLevel2;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltConfLevel3;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltConfLevel4;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltConfLevel5;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltCustomerDateConfirmed;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltCustomerDateCalculated;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltCustomerDateRequested;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltConfLevNewLog;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByCode;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltShowFirstGrplineInBin;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltAutoGroupSingleJob;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltShowBatchGroupLinesInBin;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltShowContinueGroupLinesInBin;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OverriddenTab;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltDependingOnNextHandledStep;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltDependingOnPrevHandledStep;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtDependingOnNextHandledLinkedRequest; nrkey: 0; notnull: false; defval : -1),
    (fInfo: fli_FiltDependingOnPrevHandledLinkedRequest; nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode1;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes1;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom1;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo1;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode2;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes2;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom2;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo2;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode3;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes3;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom3;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo3;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode4;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes4;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom4;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo4;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode5;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes5;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom5;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo5;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode6;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes6;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom6;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo6;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode7;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes7;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom7;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo7;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode8;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes8;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom8;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo8;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode9;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes9;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom9;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo9;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode10;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes10;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom10;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo10;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode11;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes11;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom11;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo11;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode12;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes12;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom12;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo12;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode13;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes13;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom13;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo13;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode14;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes14;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom14;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo14;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode15;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes15;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom15;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo15;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode16;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes16;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom16;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo16;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode17;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes17;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom17;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo17;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode18;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes18;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom18;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo18;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode19;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes19;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom19;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo19;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode20;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes20;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom20;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo20;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode21;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes21;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom21;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo21;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode22;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes22;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom22;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo22;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode23;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes23;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom23;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo23;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode24;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes24;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom24;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo24;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode25;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes25;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom25;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo25;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode26;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes26;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom26;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo26;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode27;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes27;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom27;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo27;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode28;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes28;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom28;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo28;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode29;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes29;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom29;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo29;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode30;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes30;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom30;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo30;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode31;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes31;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom31;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo31;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode32;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes32;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom32;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo32;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode33;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes33;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom33;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo33;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode34;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes34;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom34;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo34;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode35;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes35;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom35;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo35;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode36;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes36;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom36;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo36;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode37;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes37;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom37;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo37;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode38;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes38;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom38;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo38;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode39;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes39;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom39;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo39;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode40;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes40;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom40;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo40;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode41;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes41;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom41;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo41;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode42;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes42;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom42;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo42;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode43;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes43;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom43;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo43;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode44;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes44;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom44;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo44;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode45;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes45;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom45;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo45;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode46;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes46;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom46;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo46;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode47;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes47;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom47;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo47;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode48;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes48;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom48;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo48;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode49;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes49;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom49;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo49;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode50;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes50;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom50;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo50;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode51;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes51;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom51;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo51;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode52;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes52;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom52;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo52;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode53;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes53;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom53;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo53;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode54;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes54;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom54;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo54;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode55;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes55;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom55;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo55;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode56;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes56;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom56;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo56;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode57;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes57;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom57;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo57;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode58;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes58;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom58;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo58;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode59;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes59;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom59;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo59;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode60;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropRes60;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom60;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo60;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtFixedEarlistDateFrom;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtFixedEarlistDateTo;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtFixedEarlistDateInDaysFrom;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtFixedEarlistDateInDaysTo;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtIgnoredProgress;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltResCatCode;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrGroup;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlantCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Division;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_binTab_col : array[1..13] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_BinColField;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_BinColTitle;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColPos;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColWidth;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColVisibl;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColOrder;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColDescending;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColNumColSorted;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TypeOfUse;                          nrkey: 0;   notnull: false;   defval : 0)
  );

  struct_btl_customizedDateColumn : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_BinColField;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_FiltPropCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TypOprtion;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TimeType;                           nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_btl_CustomizedDateGap : array[1..9] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ColumnNum;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_StartingDateColumn;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TypOprtion;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyDateColumn;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinDateColumn;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TimeType;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ABSolute_Value;                    nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_planTab_master : array[1..18] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TypeOfUse;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TabsDesc;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Zoom;                               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurrTScale;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurrDtTime;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ShowColorJobMode;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MCMcNumMaxPrd;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MCMcMaxPrd1;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MCMcMaxPrd2;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MCMCatViewWcHoursPerc;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MCMPropertyViewWcHoursPerc;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_HZoom;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SZoom;                              nrkey: 0;   notnull: false;   defval : 20),
    (fInfo: fli_SlotGroup;                          nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_planTab_det : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_toPos;                              nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_IsResExpanded;                      nrkey: 0;   notnull: true;    defval :  1)
  );

  struct_tbl_cfg_exchg_glob : array[1..4] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_LAST_UPD;                           nrkey: 0;   notnull: false;   defval :  0),
    (fInfo: fli_SL_OP;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SL_ON;                              nrkey: 0;   notnull: false;   defval :  0)
  );

  struct_tbl_cfg_exchg_wkst : array[1..8] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CONNECT;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LAST_UPD;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OP;                                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_POLL;                               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_COUNTER;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MachineNumber;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_exchg_SrvLoad : array[1..3] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 0;   notnull: false;   defval : 0),
    (fInfo: fli_wkstCode;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_downloadType;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_SrvLoad_Log : array[1..4] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_CurrDtTime;                         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_Operation;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Text;                               nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_bin_showProp : array[1..62] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_FiltPropCode1;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode2;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode3;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode4;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode5;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode6;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode7;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode8;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode9;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode10;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode11;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode12;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode13;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode14;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode15;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode16;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode17;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode18;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode19;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode20;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode21;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode22;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode23;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode24;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode25;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode26;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode27;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode28;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode29;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode30;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode31;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode32;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode33;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode34;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode35;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode36;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode37;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode38;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode39;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode40;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode41;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode42;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode43;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode44;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode45;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode46;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode47;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode48;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode49;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode50;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode51;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode52;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode53;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode54;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode55;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode56;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode57;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode58;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode59;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode60;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_colorStatus : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtDescription;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_colorDateWarn : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtDescription;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_colorMatWarn : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtDescription;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_colorJobToRes : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_colorJobToJob : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_clrCapToJob : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_tbl_cfg_clrRes : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtDescription;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_clrCapRes : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtDescription;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_text_display_set_fields : array[1..14] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : 0),
    (fInfo: fli_workstation;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetName;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetType;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_fieldType;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_title;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_orgTitle;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_checked;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_fromPos;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_toPos;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FieldName;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LineSeq;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LineNumber;                              nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_text_display_set_wkc : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : 0),
    (fInfo: fli_workstation;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetName;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetType;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_cfg_Mail_set_List : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_workstation;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MailGroupName;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_User_Id;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Password;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Recipient;                          nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_GroupedByFields : array[1..15] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_GroupedByCode;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_GroupedByProdReq;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByProdFamily;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByPropCode1;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByPropCode2;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByPropCode3;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByPropCode4;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByPropCode5;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByPropCode6;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByPropCode7;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByPropCode8;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByPropCode9;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupedByPropCode10;                nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_machine_setup_code : array[1..11] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ResCatcode;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Desc;                               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MachSetupCode;                      nrkey: 1;   notnull: true;    defval : -1),
 //   (fInfo: fli_preqNo;                             nrkey: 0;   notnull: false;   defval : -1),
 //   (fInfo: fli_SequenceChar;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_Wkc_dependency : array[1..14] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SchedWkc;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SchedWkCtrProc;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DependOn;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DepIsSchedRscCat;                   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DepIsSchedWkc;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DepIsSchedRsc;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NoSchedRscCat;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NoSchedWkc;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NoSchedRsc;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_Material : array[1..24] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                       nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_preqNo;                           nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_pstepId;                          nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_orgStep;                          nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_wkCtrCode;                        nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ResCatcode;                       nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_rsc;                              nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_MachSetupCode;                    nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_AlternativCode;                   nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_prodtype;                         nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_netGroupCode;                     nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_issueCode;                        nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_seqIssued;                        nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_MatBalance;                       nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_AllocQty_Mat;                     nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_highDateAlloc;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_SearchMatByAlloc;                 nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_settled;                          nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_quantityIssue;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_reqQuant_mat;                     nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_ABSUniqueID;                      nrkey: 0;   notnull: True;     defval :  0),
    (fInfo: fli_CreateDateTimeUTC;                nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;           nrkey: 0;   notnull: false;    defval : -1)
  );

  struct_tbl_material_sup_detail : array[1..13] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_wkCtrCode;                        nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_wkcProc;                          nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ResCatcode;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_rsc;                              nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_prodtype;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_searchBalance;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_waitEntireMat;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_issueTransType;                   nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_minQty;                           nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_updReqHrs;                        nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MatProdType;                      nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ModuleRule;                       nrkey: 0;   notnull: false;    defval : -1)
   );

  struct_tbl_material_sup_header : array[1..20] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_wkCtrCode;                        nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_wkcProc;                          nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ResCatcode;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_rsc;                              nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_prodtype;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_waitPrevQty;                      nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MinQtyPassNxt;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MinQtyPrevStp;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MinDelWaitDays;                   nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MinDelWaitHrs;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MinDelWaitMin;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MaxDelWaitDays;                   nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MaxDelWaitHrs;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MaxDelWaitMin;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_PartDel;                          nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_UpdBalHrs;                        nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_UpdBalQty;                        nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_UpdReqPrevStpHrs;                 nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_ModuleRule;                       nrkey: 0;   notnull: false;    defval : -1)
   );

  struct_tbl_produced_article : array[1..15] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                           nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_sequenceChar;                     nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_netGroupCode;                     nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_AllocReq;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_Prod_Balance;                     nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_rsc;                              nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_settled;                          nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_reqQuant;                         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_qtyProduced;                      nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_AllocQty;                         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_ABSUniqueID;                      nrkey: 0;   notnull: True;     defval :  0),
    (fInfo: fli_CreateDateTimeUTC;                nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_CrtOrUpdateDateTimeUTC;           nrkey: 0;   notnull: false;    defval : -1)
    );

  struct_tbl_products : array[1..15] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdType;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProductNature;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_StartConsumPoint;                 nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_EndConsumPoint;                   nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_InfoArea;                         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_StdPurcOrProdTime;                nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_IgnorMaterialCheck;               nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_Material_Tollerance_Types_Code;   nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_HoursToDownFromMachine;           nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MaterialSchedule;                 nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MaterialStandardSetupMinutes;     nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_MaterialStandardSpeed;            nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_ABSUniqueID;                      nrkey: 0;   notnull: True;     defval :  0)
   );

  struct_tbl_balance_header : array[1..12] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdType;                         nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_netgroupcode;                     nrkey: 0;   notnull: true;     defval : -1),
//    (fInfo: fli_occupyCode;                       nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_dueDate;                          nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_quant;                            nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_InfoArea;                         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_usrCg;                            nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_usrTmCg;                          nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_orig_duedate;                     nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_index;                            nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ABSUniqueID;                      nrkey: 0;   notnull: True;     defval :  0)
  );

  struct_tbl_balance_detail : array[1..10] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdType;                         nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode ;                        nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_netgroupcode;                     nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_dueDate;                          nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_occupyCode;                       nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_InfoArea;                         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_quant;                            nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_usrCg;                            nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_usrTmCg;                          nrkey: 0;   notnull: false;    defval : -1)
   );

  struct_tbl_download_time : array[1..2] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_downloadTime;                     nrkey: 1;   notnull: true;    defval : -1)
   );

  struct_tbl_Job_Massages : array[1..12] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_psubstId;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_reprocNo;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_index;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_To_WorkStation;                   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_From_WorkStation;                 nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Messages;                         nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_DateTime;                         nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_Status;                           nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_JobMsgEvent;                      nrkey: 0;   notnull: true;    defval : -1)
   );

  struct_tbl_LearningCurve : array[1..19] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_LearningCurveCode;                  nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_LearningCurveDesc;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveFirstHours;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveFirstEffic;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveSecondHours;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveSecondEffic;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveThirdHours;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveThirdEffic;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveForthHours;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveForthEffic;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveFifthhHours;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveFifthEffic;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveSixthHours;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveSixthEffic;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveSevenThHours;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveSevenThEffic;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveEighthHours;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurveEighthEffic;                   nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ItemsStock : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                          nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ItemType;                            nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_netGroupCode;                        nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ItemCode;                            nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_stock;                               nrkey: 0;   notnull: false;  defval : -1)
  );

  struct_tbl_ItemsStockChanges : array[1..8] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                          nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ItemType;                            nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_netGroupCode;                        nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ItemCode;                            nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_DayInWeek;                           nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_fromTime;                            nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ToTime;                              nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_StockDifference;                     nrkey: 0;   notnull: false;  defval : -1)
  );

  struct_tbl_ItemsStockExceptions : array[1..8] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                          nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ItemType;                            nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_netGroupCode;                        nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ItemCode;                            nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_Date;                                nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_fromTime;                            nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ToTime;                              nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_StockDifference;                     nrkey: 0;   notnull: false;  defval : -1)
  );

  struct_tbl_GroupResDefinition : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_workstation;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetName;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NumberOfScheduleCounter;            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_StockDetails : array[1..11] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                 nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_BalanceIdentifier;          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_prodtype;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdCode;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_netGroupCode;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Details;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_used;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_preqNo;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_pstepId;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_psubstId;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_reprocNo;                   nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_AutoSeq_ScoreAddition : array[1..18] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                     nrkey: 1;  notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                       nrkey: 1;  notnull: true;    defval : -1),
    (fInfo: fli_CfgName;                        nrkey: 1;  notnull: true;    defval : -1),
    (fInfo: fli_Sequence;                       nrkey: 1;  notnull: true;    defval : -1),
    (fInfo: fli_From_Job_to_Prior_Job_case;     nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_To_Job_to_Prior_Job_case;       nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_From_Job_to_Follow_Job_case;    nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_To_Job_to_Follow_Job_case;      nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_From_Job_to_resource_case;      nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_To_Job_to_resource_case;        nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_From_number_of_days_delay;      nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_To_number_of_days_delay;        nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_From_number_of_days_early;      nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_To_number_of_days_early;        nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_From_number_minutes_setup_add;  nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_To_number_minutes_setup_add;    nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_Add_to_score;                   nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_Double_Direction;               nrkey: 0;  notnull: false;   defval : -1)
  );

  struct_tbl_AutoSeqJobToJobDefinitions : array[1..6] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_wkstCode;                  nrkey: 1;  notnull: true;    defval : -1),
    (fInfo: fli_CfgName;                   nrkey: 1;  notnull: true;    defval : -1),
    (fInfo: fli_From_Case;                 nrkey: 1;  notnull: true;    defval : -1),
    (fInfo: fli_ToCase;                    nrkey: 0;  notnull: false;   defval : -1),
    (fInfo: fli_Add_to_score;              nrkey: 0;  notnull: false;   defval : -1)
  );

  struct_tbl_PropAsDate : array[1..2] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;              nrkey: 1;   notnull: true;   defval : -1)
  );

  struct_tbl_PropAsRGB : array[1..2] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                    nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PropertyCode;                  nrkey: 1;   notnull: true;   defval : -1)
  );

  struct_tbl_PropAssigned : array[1..3] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                    nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_AssignedProp;                  nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PropertyCode;                  nrkey: 1;   notnull: true;   defval : -1)
  );

  struct_tbl_Log : array[1..16] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_DateTime;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LogOrigin;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_preqNo;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_pstepId;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_psubstId;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_reprocNo;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Operation;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ScheduleInfo;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rsc;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quant;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedStart;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedEnd;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Reason;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedType;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Mqm_environment;           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_OverrideStepParameters : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                    nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_speed;                     nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_setup;                     nrkey: 0;   notnull: true;    defval : -2)
  );

  struct_tbl_Filters : array[1..7] of TInfoStruct = (
    (fInfo: fli_Id;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CTABLE;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BACTIVE;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CSQL;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CLOCK;                   nrkey: 0;   notnull: false;   defval :  0),
    (fInfo: fli_CCAPTION;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_IDENTIFIER;              nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_Filters_COL : array[1..7] of TInfoStruct = (
    (fInfo: fli_ID_TABLE;                 nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CCOLUMN;                  nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CCAPTION;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CCOND;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CVALUES;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BVISIBLE;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_IDENTIFIER;               nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_cfg_McmTabConfig : array[1..9] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SlotGroup;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SlotScnLevel;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WkcScnLevel;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_isSlotExpanded;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_IsWkcExpanded;                      nrkey: 0;   notnull: false;   defval : -1)
  );

    struct_tbl_ResCal : array[1..13] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalCod;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalDate;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc_cal;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Prog_Wrk_Hr;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH1_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH1_end;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH2_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH2_end;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH3_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH3_end;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH4_start;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SH4_end;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_binMaterialFilter : array[1..193] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsDesc;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ItemType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdCode;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_netGroupCode;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Detail_Code;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Sub_Detail;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltSchedJobs;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltWarpLvl;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode1;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom1;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo1;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode2;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom2;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo2;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode3;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom3;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo3;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode4;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom4;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo4;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode5;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom5;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo5;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode6;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom6;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo6;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode7;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom7;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo7;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode8;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom8;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo8;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode9;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom9;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo9;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode10;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom10;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo10;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode11;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom11;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo11;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode12;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom12;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo12;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode13;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom13;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo13;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode14;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom14;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo14;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode15;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom15;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo15;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode16;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom16;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo16;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode17;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom17;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo17;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode18;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom18;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo18;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode19;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom19;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo19;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode20;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom20;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo20;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode21;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom21;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo21;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode22;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom22;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo22;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode23;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom23;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo23;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode24;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom24;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo24;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode25;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom25;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo25;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode26;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom26;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo26;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode27;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom27;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo27;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode28;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom28;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo28;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode29;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom29;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo29;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode30;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom30;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo30;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode31;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom31;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo31;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode32;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom32;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo32;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode33;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom33;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo33;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode34;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom34;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo34;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode35;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom35;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo35;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode36;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom36;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo36;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode37;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom37;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo37;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode38;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom38;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo38;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode39;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom39;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo39;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode40;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom40;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo40;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode41;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom41;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo41;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode42;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom42;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo42;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode43;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom43;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo43;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode44;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom44;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo44;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode45;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom45;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo45;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode46;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom46;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo46;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode47;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom47;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo47;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode48;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom48;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo48;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode49;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom49;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo49;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode50;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom50;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo50;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode51;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom51;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo51;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode52;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom52;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo52;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode53;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom53;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo53;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode54;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom54;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo54;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode55;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom55;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo55;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode56;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom56;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo56;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode57;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom57;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo57;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode58;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom58;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo58;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode59;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom59;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo59;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode60;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueFrom60;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_filtPropValueTo60;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ItemType2;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdCode2;                          nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ProductProperties : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdType;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_PropertyCode;                     nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_PropValue;                        nrkey: 0;   notnull: false;    defval : -1)
  );

  struct_tbl_MaterialDetailSchedule : array[1..22] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdType;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_Sub_Detail;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_Detail_Code;                      nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_preqNo;                           nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_quant;                            nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_netGroupCode;                     nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_rsc;                              nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_OverridenSpeed;                   nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_OverridenSetupTime;               nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_schedStart;                       nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_schedEnd;                         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_FirstJobQuantityIncluded;         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_LastJobQuantityIncluded;          nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_HostItemIndentifier;              nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_updCode;                          nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_schedType;                        nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_HostWarehouse;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_SubDetailHostType;                nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_DetailCodeType;                   nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_ProdUMCode;                       nrkey: 0;   notnull: false;    defval : -1)
   );

  struct_tbl_MaterialDetailSchedule_link : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdType;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_Sub_Detail;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_Detail_Code;                      nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_preqNo;                           nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_pstepId;                          nrkey: 1;   notnull: true;     defval : -1)
   );

  struct_tbl_SCHEDULES_DOWNLOAD_WARPRSV : array[1..5] of TInfoStruct = (
    (fInfo: fli_Environment;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CompanyCode;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CounterCode;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Code;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Reservationline;                  nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_TotalsView : array[1..4] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TotalCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_OwnerWorkStation;                   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1)
    );

  struct_tbl_TotalsViewWorkCenters : array[1..3] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TotalCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1)
    );

  struct_tbl_TotalsViewGroupByColumns : array[1..4] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TotalCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Sequence;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 0;   notnull: false;   defval : -1)
    );

  struct_tbl_TotalsViewContent : array[1..8] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TotalCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ArgumentNumber;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Attribute;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Formula;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumberofDecimals;                   nrkey: 0;   notnull: false;   defval : -1)
    );

  struct_tbl_CustomMenu : array[1..5] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MenuCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MenuCaption;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Visible;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_SavedPlanCopyHeader : array[1..7] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetName;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetDesc;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalStartDate;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalEndDate;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_SavedPlanCopy : array[1..14] of TInfoStruct = (
    (fInfo: fli_IDENTIFIER;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetName;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_psubstId;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_reprocNo;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rsc;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BucketType;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_BucketDate;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_BucketQty;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedStart;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedEnd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_exeMin;                             nrkey: 0;   notnull: false;   defval : -1)
  );

  tblInfo : array[table] of TTblInfo = (
    (HostName: 'SCDC_MCMTABCONFIG';             IBname: 'MCMTABCONFIG';              PCname: 'MCMTABCONFIG';         ASname: '';          pfx: 'MTC_';    struct: @struct_tbl_cfg_McmTabConfig;   nrfld: High(struct_tbl_cfg_McmTabConfig);   group: 2;   arc: 0),     //  tbl_cfg_McmTabConfig
    (HostName: 'SCDM_RESCAL';                   IBname: 'RESCAL';                    PCname: 'RESCAL';               ASname: '';          pfx: 'RCA_';    struct: @struct_tbl_ResCal;             nrfld: High(struct_tbl_ResCal);             group: 1;   arc: 0),     //  tbl_Rescal
    (HostName: 'SCDM_FILTERS';                  IBname: 'FILTERS';                   PCname: '';                     ASname: '';          pfx: '';        struct: @struct_tbl_FILTERS;            nrfld: High(struct_tbl_FILTERS);            group: 1; arc: 1), //  tbl_filters
    (HostName: 'SCDM_FILTERS_COL';              IBname: 'FILTERS_COL';               PCname: '';                     ASname: '';          pfx: '';        struct: @struct_tbl_FILTERS_COL;        nrfld: High(struct_tbl_FILTERS_COL);        group: 1; arc: 1), //  tbl_filters_col
    (HostName: 'SCDM_IDENTIFIERS';              IBname: 'IDENTIFIERS';               PCname: 'IDENTIFIERS';          ASname: '';          pfx: '';        struct: @struct_tbl_Identifiers;        nrfld: High(struct_tbl_Identifiers);        group: 1;   arc: 0),     //  tbl_Identifiers
    (HostName: 'SCDC_TABLES_UPLOAD_HOST';       IBname: 'TABLES_UPLOAD_HOST';        PCname: 'TABLES_UPLOAD_HOST';   ASname: '';          pfx: 'TH_';     struct: @struct_tbl_Archive_To_Host;    nrfld: High(struct_tbl_Archive_To_Host);    group: 2;   arc: 1),     //  tbl_tbl_Archive_To_Host
    (HostName: 'SCDM_GENERATE_NUM';             IBname: 'GENERATE_NUM';              PCname: 'GENERATE_NUM';         ASname: '';          pfx: 'GN_';     struct: @struct_tbl_GeneratorNumber;    nrfld: High(struct_tbl_GeneratorNumber);    group: 1;   arc: 1),     //  tbl_addRes
    (HostName: 'SCDM_ADD_RES';                  IBname: 'ADD_RES';                   PCname: 'ADD_RES';              ASname: '';          pfx: 'AR_';     struct: @struct_tbl_addRes;             nrfld: High(struct_tbl_addRes);             group: 1;   arc: 1),     //  tbl_addRes
    (HostName: 'SCDM_ALT_WKC';                  IBname: 'ALT_WKC';                   PCname: 'ALT_WKC';              ASname: 'DISPM00F';  pfx: 'AW_';     struct: @struct_tbl_wkc_alt;            nrfld: High(struct_tbl_wkc_alt);            group: 1;   arc: 0),     //  tbl_wkc_alt
    (HostName: 'SCDM_ALTERNATIVEWAREHOUSE';     IBname: 'ALTERNATIVEWAREHOUSE';      PCname: 'ALTERNATIVEWAREHOUSE'; ASname: ' ';         pfx: '';        struct: @struct_tbl_alt_warehouse;      nrfld: High(struct_tbl_alt_warehouse);      group: 1;   arc: 0),     //  alt_warehouse
    (HostName: 'SCDC_APP_GLOBALSETTINGS';       IBname: 'APP_GLOBALSETTINGS';        PCname: 'APP_GLOBALSETTINGS';   ASname: '';          pfx: 'GS_';     struct: @struct_tbl_cfg_AppGlobSettings;  nrfld: High(struct_tbl_cfg_AppGlobSettings);        group: 2;   arc: 1),     //  tbl_cfg_AppGlobSettings
    (HostName: 'SCDC_APP_GLOBALS';              IBname: 'APP_GLOBALS';               PCname: 'APP_GLOBALS';          ASname: '';          pfx: 'AG_';     struct: @struct_tbl_cfg_appGlob;        nrfld: High(struct_tbl_cfg_appGlob);        group: 2;   arc: 1),     //  tbl_cfg_appGlob
    (HostName: 'SCDC_APP_INI';                  IBname: 'APP_INI';                   PCname: 'APP_INI';              ASname: '';          pfx: 'AI_';     struct: @struct_tbl_cfg_appIni;        nrfld: High(struct_tbl_cfg_appIni);        group: 2;   arc: 1), //  tbl_cfg_appGlob
    (HostName: 'SCDC_APP_SETTINGS';             IBname: 'APP_SETTINGS';              PCname: 'APP_SETTINGS';         ASname: '';          pfx: 'AS_';     struct: @struct_tbl_cfg_appSettings;    nrfld: High(struct_tbl_cfg_appSettings);    group: 2;   arc: 1),     //  tbl_cfg_appSettings
    (HostName: 'SCDC_AUTO_SCHED';               IBname: 'AUTO_SCHED';                PCname: 'AUTO_SCHED';           ASname: '';          pfx: 'ASC_';    struct: @struct_tbl_cfg_AutoSched;      nrfld: High(struct_tbl_cfg_AutoSched);      group: 2;   arc: 1),     //  tbl_cfg_AutoSched
    (HostName: 'SCDC_AUTO_SCHED_WC_CFG';        IBname: 'AUTO_SCHED_WC_CFG';         PCname: 'AUTO_SCHED_WC_CFG';    ASname: '';          pfx: 'ASW_';    struct: @struct_tbl_cfg_AutoSchedWorkCenter;   nrfld: High(struct_tbl_cfg_AutoSchedWorkCenter);      group: 2;   arc: 1),     //  struct_tbl_cfg_AutoSchedWorkCenter
    (HostName: 'SCDC_AUTO_RUN_DEFINITION';      IBname: 'AUTO_RUN_DEFINITION';       PCname: 'AUTO_RUN_DEFINITION';  ASname: '';          pfx: 'ARD_';    struct: @struct_tbl_cfg_AutoRunDefinition; nrfld: High(struct_tbl_cfg_AutoRunDefinition); group: 2;   arc: 1),     //  tbl_cfg_AutoRunDefinition
    (HostName: 'SCDM_ARTICLE_TYPE';             IBname: 'ARTICLE_TYPE';              PCname: 'ARTICLE_TYPE';         ASname: 'TABLE00F';  pfx: 'AT_';     struct: @struct_tbl_arty;               nrfld: High(struct_tbl_arty);               group: 1;   arc: 0),     //  tbl_arty
    (HostName: 'SCDM_Material_Tolerance_Type';  IBname: 'Material_Tolerance_Type';   PCname: 'Material_Tolerance_Type'; ASname: '';       pfx: 'MTT_';    struct: @struct_Material_Tollerance_Types; nrfld: High(struct_Material_Tollerance_Types); group: 1;   arc: 0),     //  struct_Material_Tollerance_Types
    (HostName: 'SCDC_BIN_SHOW_PROP';            IBname: 'BIN_SHOW_PROP';             PCname: 'BIN_SHOW_PROP';        ASname: '';          pfx: 'BP_';     struct: @struct_tbl_cfg_bin_showProp;   nrfld: High(struct_tbl_cfg_bin_showProp);   group: 2;   arc: 1),     //  tbl_cfg_bin_showProp
    (HostName: 'SCDM_PROP_CAPRES';              IBname: 'PROP_CAPRES';               PCname: 'PROP_CAPRES';          ASname: 'MQMCP00F';  pfx: 'CP_';     struct: @struct_tbl_prop_capRes;        nrfld: High(struct_tbl_prop_capRes);        group: 1;   arc: 0),     //  tbl_prop_capRes
    (HostName: 'SCDM_CAPRES';                   IBname: 'CAPRES';                    PCname: 'CAPRES';               ASname: 'MQMCR00F';  pfx: 'CR_';     struct: @struct_tbl_capRes;             nrfld: High(struct_tbl_capRes);             group: 1;   arc: 0),     //  tbl_capRes
    (HostName: 'SCDM_CAPRES_HOST';              IBname: 'CAPRES_HOST';               PCname: 'CAPRES_HOST';          ASname: '';          pfx: 'CH_';     struct: @struct_tbl_capRes_Host;        nrfld: High(struct_tbl_capRes_Host);        group: 1;   arc: 0),     //  tbl_capRes
    (HostName: 'SCDM_CAPRES_DYNAMICPERRES';     IBname: 'CAPRES_DYNAMICPERRES';      PCname: 'CAPRES_DYNAMICPERRES'; ASname: '';          pfx: 'CRR_';    struct: @struct_tbl_capRes_DynamicPerRes;  nrfld: High(struct_tbl_capRes_DynamicPerRes); group: 1;   arc: 0), // capRes_DynamicPerRes
    (HostName: 'SCDM_CAPRES_DYNAMICPERDATE';    IBname: 'CAPRES_DYNAMICPERDATE';     PCname: 'CAPRES_DYNAMICPERDATE'; ASname: '';         pfx: 'CRD_';    struct: @struct_tbl_capRes_DynamicPerDate; nrfld: High(struct_tbl_capRes_DynamicPerDate); group: 1;   arc: 0), // capRes_DynamicPerdate
    (HostName: 'SCDM_CAPRES_DYNAMICPERPROP';    IBname: 'CAPRES_DYNAMICPERPROP';     PCname: 'CAPRES_DYNAMICPERPROP'; ASname: '';         pfx: 'CRP_';    struct: @struct_tbl_capRes_DynamicPerResDateProp; nrfld: High(struct_tbl_capRes_DynamicPerResDateProp); group: 1;   arc: 0), // capRes_DynamicPerResdateProp
    (HostName: 'SCDC_CLR_CAP_TO_JOB';           IBname: 'CLR_CAP_TO_JOB';            PCname: 'CLR_CAP_TO_JOB';       ASname: '';          pfx: 'CJ_';     struct: @struct_tbl_cfg_clrCapToJob;    nrfld: High(struct_tbl_cfg_clrCapToJob);    group: 2;   arc: 1),     //  tbl_cfg_clrCapToJob
    (HostName: 'SCDM_RESCAT';                   IBname: 'RESCAT';                    PCname: 'RESCAT';   ASname: 'TABLE00F';  pfx: 'CT_';     struct: @struct_tbl_resCat;             nrfld: High(struct_tbl_resCat);             group: 1;   arc: 0),     //  tbl_resCat
    (HostName: 'SCDM_CALENDAR';                 IBname: 'CALENDAR';                  PCname: 'CALENDAR'; ASname: 'PGTUR00F';  pfx: 'CA_';     struct: @struct_tbl_calendar;           nrfld: High(struct_tbl_calendar);           group: 1;   arc: 0),     //  tbl_calendar
    (HostName: 'SCDM_CAL_SHIFT_EFFIC';          IBname: 'CAL_SHIFT_EFFIC';           PCname: 'CAL_SHIFT_EFFIC';      ASname: '';          pfx: 'CSE_';    struct: @struct_tbl_calShiftEffic;      nrfld: High(struct_tbl_calShiftEffic);      group: 1;   arc: 0),     //  tbl_calendar_shift_effic
    (HostName: 'SCDC_PLAN_TAB_DET';             IBname: 'PLAN_TAB_DET';              PCname: 'PLAN_TAB_DET';         ASname: '';          pfx: 'PVD_';    struct: @struct_tbl_cfg_planTab_det;    nrfld: High(struct_tbl_cfg_planTab_det);    group: 2;   arc: 1),     //  tbl_cfg_planTab_det
    (HostName: 'SCDC_PLAN_TAB_MASTER';          IBname: 'PLAN_TAB_MASTER';           PCname: 'PLAN_TAB_MASTER';      ASname: '';          pfx: 'PVM_';    struct: @struct_tbl_cfg_planTab_master; nrfld: High(struct_tbl_cfg_planTab_master); group: 2;   arc: 1),     //  tbl_plan_tbs_master
    (HostName: 'SCDC_EXCG_GLOB';                IBname: 'EXCG_GLOB';                 PCname: 'EXCG_GLOB';            ASname: '';          pfx: 'CEG_';    struct: @struct_tbl_cfg_exchg_glob;     nrfld: High(struct_tbl_cfg_exchg_glob);     group: 2;   arc: 1),     //  tbl_cfg_exchg_glob
    (HostName: 'SCDC_EXCG_WKST';                IBname: 'EXCG_WKST';                 PCname: 'EXCG_WKST';            ASname: '';          pfx: 'CEW_';    struct: @struct_tbl_cfg_exchg_wkst;     nrfld: High(struct_tbl_cfg_exchg_wkst);     group: 2;   arc: 1),     //  tbl_cfg_exchg_wkst
    (HostName: 'SCDC_EXCG_WKST_SRVLOAD';        IBname: 'EXCG_WKST_SRVLOAD';         PCname: 'EXCG_WKST_SRVLOAD';    ASname: '';          pfx: 'SRV_';    struct: @struct_tbl_cfg_exchg_SrvLoad;  nrfld: High(struct_tbl_cfg_exchg_SrvLoad);  group: 2;   arc: 1),     //  tbl_cfg_exchg_wkst
    (HostName: 'SCDC_SRVLOAD_LOG';              IBname: 'SRVLOAD_LOG';               PCname: 'SRVLOAD_LOG';          ASname: '';          pfx: 'SLO_';    struct: @struct_tbl_cfg_SrvLoad_Log;    nrfld: High(struct_tbl_cfg_SrvLoad_Log);    group: 2;   arc: 1),     //  tbl_cfg_SrvLoad_Log
    (HostName: 'SCDM_EXT_INFO';                 IBname: 'EXT_INFO';                  PCname: 'EXT_INFO';             ASname: 'MQMEI00F';  pfx: 'EI_';     struct: @struct_tbl_ext_info;           nrfld: High(struct_tbl_ext_info);           group: 1;   arc: 1),     //  tbl_ext_info
    (HostName: 'SCDM_EXT_INFO_HDR';             IBname: 'EXT_INFO_HDR';              PCname: 'EXT_INFO_HDR';         ASname: 'MQMEH00F';  pfx: 'EH_';     struct: @struct_tbl_ext_infoHdr;        nrfld: High(struct_tbl_ext_infoHdr);        group: 1;   arc: 1),     //  tbl_ext_infoHdr
    (HostName: 'SCDM_EXT_CONNECTION';           IBname: 'EXT_CONNECTION';            PCname: 'EXT_CONNECTION';       ASname: 'MQMEC00F';  pfx: 'EC_';     struct: @struct_tbl_ext_connection;     nrfld: High(struct_tbl_ext_connection);     group: 1;   arc: 1),     //  tbl_ext_connection
    (HostName: 'SCDC_BIN_FILTER';               IBname: 'BIN_FILTER';                PCname: 'BIN_FILTER';           ASname: '';          pfx: 'BF_';     struct: @struct_tbl_cfg_binFilter;      nrfld: High(struct_tbl_cfg_binFilter);      group: 2;   arc: 1),     //  tbl_cfg_binFilter
    (HostName: 'SCDM_SCHED_FORCE';              IBname: 'SCHED_FORCE';               PCname: 'SCHED_FORCE';          ASname: 'MQMFS00F';  pfx: 'FS_';     struct: @struct_tbl_prod_schedForce;    nrfld: High(struct_tbl_prod_schedForce);    group: 1;   arc: 0),     //  tbl_prod_schedForce
    (HostName: 'SCDM_RES_SUB';                  IBname: 'RES_SUB';                   PCname: 'RES_SUB';              ASname: 'MQMDH00F';  pfx: 'DH_';     struct: @struct_tbl_res_sub;            nrfld: High(struct_tbl_res_sub);            group: 1;   arc: 0),     //  tbl_res_sub
    (HostName: 'SCDC_CLR_JOB_STATUS';           IBname: 'CLR_JOB_STATUS';            PCname: 'CLR_JOB_STATUS';       ASname: '';          pfx: 'JS_';     struct: @struct_tbl_cfg_colorStatus;    nrfld: High(struct_tbl_cfg_colorStatus);    group: 2;   arc: 1),     //  tbl_cfg_colorErr
    (HostName: 'SCDC_CLR_JOB_DATE_WRN';         IBname: 'CLR_JOB_DATE_WRN';          PCname: 'CLR_JOB_DATE_WRN';     ASname: '';          pfx: 'JD_';     struct: @struct_tbl_cfg_colorDateWarn;  nrfld: High(struct_tbl_cfg_colorDateWarn);  group: 2;   arc: 1),     //  tbl_cfg_colorErr
    (HostName: 'SCDC_CLR_JOB_MAT_WRN';          IBname: 'CLR_JOB_MAT_WRN';           PCname: 'CLR_JOB_MAT_WRN';      ASname: '';          pfx: 'JM_';     struct: @struct_tbl_cfg_colorMatWarn;    nrfld: High(struct_tbl_cfg_colorMatWarn);  group: 2;   arc: 1),     //  tbl_cfg_colorErr
    (HostName: 'SCDC_CLR_JOB_TO_RES';           IBname: 'CLR_JOB_TO_RES';            PCname: 'CLR_JOB_TO_RES';       ASname: '';          pfx: 'JR_';     struct: @struct_tbl_cfg_colorJobToRes;  nrfld: High(struct_tbl_cfg_colorJobToRes);  group: 2;   arc: 1),     //  tbl_cfg_colorJobToRes
    (HostName: 'SCDC_CLR_JOB_TO_JOB';           IBname: 'CLR_JOB_TO_JOB';            PCname: 'CLR_JOB_TO_JOB';       ASname: '';          pfx: 'JJ_';     struct: @struct_tbl_cfg_colorJobToJob;  nrfld: High(struct_tbl_cfg_colorJobToJob);  group: 2;   arc: 1),     //  tbl_cfg_clrJobToJob
    (HostName: 'SCDM_PROD_REQCONN';             IBname: 'PROD_REQCONN';              PCname: 'PROD_REQCONN';         ASname: 'MQMIC00F';  pfx: 'IC_';     struct: @struct_tbl_prod_reqConnection; nrfld: High(struct_tbl_prod_reqConnection); group: 1;   arc: 1),     //  tbl_prod_reqConnection
    (HostName: 'SCDM_RULE_OCC_TO_OCC';          IBname: 'RULE_OCC_TO_OCC';           PCname: 'RULE_OCC_TO_OCC';      ASname: 'MQMOO00F';  pfx: 'OO_';     struct: @struct_tbl_ruleOccToOcc;       nrfld: High(struct_tbl_ruleOccToOcc);       group: 1;   arc: 0),     //  tbl_ruleOccToOcc
    (HostName: 'SCDM_GROUPBY_PROP_RULES';       IBname: 'GROUPBY_PROP_RULES';        PCname: 'GROUPBY_PROP_RULES';   ASname: '';          pfx: 'GR_';     struct: @struct_tbl_GroupByPropertyRules; nrfld: High(struct_tbl_GroupByPropertyRules); group: 1;   arc: 0), //  tbl_GroupByPropertyRules
    (HostName: 'SCDM_PROD_INFO';                IBname: 'PROD_INFO';                 PCname: 'PROD_INFO';            ASname: 'MQMPI00F';  pfx: 'PI_';     struct: @struct_tbl_prod_info;          nrfld: High(struct_tbl_prod_info);          group: 1;   arc: 1),     //  tbl_prod_info
    (HostName: 'SCDM_WKC_PROD_LINE';            IBname: 'WKC_PROD_LINE';             PCname: 'WKC_PROD_LINE';        ASname: 'WCMAC10F';  pfx: 'PL_';     struct: @struct_tbl_wkc_prodLine;       nrfld: High(struct_tbl_wkc_prodLine);       group: 1;   arc: 0),     //  tbl_wkc_prodLine
    (HostName: 'SCDM_PROP_PROD';                IBname: 'PROP_PROD';                 PCname: 'PROP_PROD';            ASname: 'MQMPP00F';  pfx: 'PP_';     struct: @struct_tbl_prop_prod;          nrfld: High(struct_tbl_prop_prod);          group: 1;   arc: 1),     //  tbl_prop_prod
    (HostName: 'SCDM_PROD_REQ';                 IBname: 'PROD_REQ';                  PCname: 'PROD_REQ';             ASname: 'MQMPR00F';  pfx: 'PR_';     struct: @struct_tbl_prod_req;           nrfld: High(struct_tbl_prod_req);           group: 1;   arc: 1),     //  tbl_prod_req
    (HostName: 'SCDM_PROD_STEP';                IBname: 'PROD_STEP';                 PCname: 'PROD_STEP';            ASname: 'MQMPD00F';  pfx: 'PD_';     struct: @struct_tbl_prod_step;          nrfld: High(struct_tbl_prod_step);          group: 1;   arc: 1),     //  tbl_prod_step
    (HostName: 'SCDM_PROD_REQHDR';              IBname: 'PROD_REQHDR';               PCname: 'PROD_REQHDR';          ASname: 'MQMPH00F';  pfx: 'PH_';     struct: @struct_tbl_prod_reqHdr;        nrfld: High(struct_tbl_prod_reqHdr);        group: 1;   arc: 1),     //  tbl_prod_reqHdr

  {$ifdef Mcm }
    (HostName: 'SCDM_PROD_SCHED_MCM';           IBname: 'PROD_SCHED_MCM';            PCname: 'PROD_SCHED_MCM';       ASname: 'MQMPS10F';  pfx: 'MS_';     struct: @struct_tbl_prod_sched_mcm;         nrfld: High(struct_tbl_prod_sched_mcm);         group: 1;   arc: 1),     //  tbl_prod_sched
{$else}
    (HostName: 'SCDM_PROD_SCHED';               IBname: 'PROD_SCHED';                PCname: 'PROD_SCHED';           ASname: 'MQMPS10F';  pfx: 'PS_';     struct: @struct_tbl_prod_sched;         nrfld: High(struct_tbl_prod_sched);         group: 1;   arc: 1),     //  tbl_prod_sched
{$endif}

    (HostName: 'SCDM_PROD_SCHED_MCM';           IBname: 'PROD_SCHED_MCM';            PCname: 'PROD_SCHED_MCM';       ASname: '';          pfx: 'MS_';     struct: @struct_tbl_prod_sched_mcm;     nrfld: High(struct_tbl_prod_sched_mcm);     group: 1;   arc: 1),     //  tbl_prod_sched_mcm
    (HostName: 'SCDM_PROD_SCHED_SHARED_DATA';   IBname: 'PROD_SCHED_SHARED_DATA';    PCname: 'PROD_SCHED_SHARED_DATA';  ASname: '';       pfx: 'PSD_';    struct: @struct_tbl_prod_sched_shared_data; nrfld: High(struct_tbl_prod_sched_shared_data); group: 1;   arc: 1),     //  tbl_prod_sched_shered_data
    (HostName: 'SCDM_PROP';                     IBname: 'PROP';                      PCname: 'PROP';                 ASname: 'TABLE00F';  pfx: 'PY_';     struct: @struct_tbl_prop;               nrfld: High(struct_tbl_prop);               group: 1;   arc: 0),     //  tbl_prop
    (HostName: 'SCDM_PROP_PROD_PLANNER';        IBname: 'PROP_PROD_PLANNER';         PCname: 'PROP_PROD_PLANNER';    ASname: '';          pfx: 'PPR_';    struct: @struct_tbl_PROP_PROD_PLANNER; nrfld: High(struct_tbl_PROP_PROD_PLANNER);  group: 1;   arc: 0),     //  tbl_PROP_PROD_PLANNER
    (HostName: 'SCDC_PROP_SHOW_COLOR';          IBname: 'PROP_SHOW_COLOR';           PCname: 'PROP_SHOW_COLOR';      ASname: '';          pfx: 'PC_';     struct: @struct_tbl_cfg_Prop_Show_Color;    nrfld: High(struct_tbl_cfg_Prop_Show_Color);    group: 2;   arc: 0),     //  tbl_prop_show_color
    (HostName: 'SCDC_CLR_RES';                  IBname: 'CLR_RES';                   PCname: 'CLR_RES';              ASname: '';          pfx: 'RC_';     struct: @struct_tbl_tbl_cfg_clrRes;     nrfld: High(struct_tbl_tbl_cfg_clrRes);     group: 2;   arc: 1),     //  tbl_cfg_clrRes
    (HostName: 'SCDC_CLR_CAP_RES';              IBname: 'CLR_CAP_RES';               PCname: 'CLR_CAP_RES';          ASname: '';          pfx: 'CRC_';    struct: @struct_tbl_cfg_clrCapRes;      nrfld: High(struct_tbl_cfg_clrCapRes);      group: 2;   arc: 1),     //  tbl_cfg_clrCapRes
    (HostName: 'SCDM_RES';                      IBname: 'RES';                       PCname: 'RES';                  ASname: 'VPLRS00F';  pfx: 'RS_';     struct: @struct_tbl_res;                nrfld: High(struct_tbl_res);                group: 1;   arc: 0),     //  tbl_res
    (HostName: 'SCDM_RES_APA';                  IBname: 'RES_APA';                   PCname: 'RES_APA';              ASname: 'MQMRD00F';  pfx: 'RD_';     struct: @struct_tbl_res_apa;            nrfld: High(struct_tbl_res_apa);            group: 1;   arc: 0),     //  tbl_res_apa
    (HostName: 'SCDM_REQ_CHANGE';               IBname: 'REQ_CHANGE';                PCname: 'REQ_CHANGE';           ASname: '';          pfx: 'RC_';     struct: @struct_tbl_Req_Change;         nrfld: High(struct_tbl_Req_Change);         group: 1;   arc: 1),     //  tbl_Req_Change
    (HostName: 'SCDM_CAP_RSC_CHANGE';           IBname: 'CAP_RSC_CHANGE';            PCname: 'CAP_RSC_CHANGE';       ASname: '';          pfx: 'CRG_';    struct: @struct_tbl_CapRsc_Change;      nrfld: High(struct_tbl_caprsc_Change);      group: 1;   arc: 1),     //  tbl_Caprsc_Change
    (HostName: 'SCDM_RULE_RES_TO_OCC';          IBname: 'RULE_RES_TO_OCC';           PCname: 'RULE_RES_TO_OCC';      ASname: 'MQMRO00F';  pfx: 'RO_';     struct: @struct_tbl_ruleResToOcc;       nrfld: High(struct_tbl_ruleResToOcc);       group: 1;   arc: 0),     //  tbl_ruleResToOcc
    (HostName: 'SCDM_PROP_RES';                 IBname: 'PROP_RES';                  PCname: 'PROP_RES';             ASname: 'MQMRP00F';  pfx: 'RP_';     struct: @struct_tbl_prop_res;           nrfld: High(struct_tbl_prop_res);           group: 1;   arc: 0),     //  tbl_prop_res
    (HostName: 'SCDM_PROD_STEP_BATCH_SIZE';     IBname: 'PROD_STEP_BATCH_SIZE';      PCname: 'PROD_STEP_BATCH_SIZE'; ASname: 'MQMSB00F';  pfx: 'SB_';     struct: @struct_tbl_step_batchSize;     nrfld: High(struct_tbl_step_batchSize);     group: 1;   arc: 1),     //  tbl_step_batchSize
    (HostName: 'SCDM_PROD_STEP_TIMES';          IBname: 'PROD_STEP_TIMES';           PCname: 'PROD_STEP_TIMES';      ASname: 'MQMST00F';  pfx: 'ST_';     struct: @struct_tbl_step_times;         nrfld: High(struct_tbl_step_times);         group: 1;   arc: 1),     //  tbl_step_times
    (HostName: 'SCDM_PROD_SCHED_PROGRESS';      IBname: 'PROD_SCHED_PROGRESS';       PCname: 'PROD_SCHED_PROGRESS';  ASname: 'MQMSP00F';  pfx: 'SP_';     struct: @struct_tbl_sched_progress;     nrfld: High(struct_tbl_sched_progress);     group: 1;   arc: 1),     //  tbl_sched_progress
    (HostName: 'SCDM_PROD_SCHED_PROGRESS_OVRD'; IBname: 'PROD_SCHED_PROGRESS_OVRD';  PCname: 'PROD_SCHED_PROGRESS_OVRD';  ASname: ''; pfx: 'SPO_';    struct: @struct_tbl_sched_progress_override;  nrfld: High(struct_tbl_sched_progress_override); group: 1;   arc: 1),   //  tbl_sched_progress_Override
    (HostName: 'SCDC_BIN_TAB_COL';              IBname: 'BIN_TAB_COL';               PCname: 'BIN_TAB_COL';          ASname: '';          pfx: 'BC_';     struct: @struct_tbl_cfg_binTab_col;     nrfld: High(struct_tbl_cfg_binTab_col);     group: 2;   arc: 1),     //  tbl_cfg_binTab_col
    (HostName: 'SCDC_Custom_Date_Column';       IBname: 'Custom_Date_Column';        PCname: 'Custom_Date_Column';   ASname: '';          pfx: 'CD_';     struct: @struct_btl_customizedDateColumn;  nrfld: High(struct_btl_customizedDateColumn); group: 2;   arc: 1),     //  struct_btl_customizedDateColumn
    (HostName: 'SCDC_Custom_Dates_Gap_Column';  IBname: 'Custom_Dates_Gap_Column';   PCname: 'Custom_Dates_Gap_Column';  ASname: '';       pfx: 'CDG_';    struct: @struct_btl_customizedDateGap;  nrfld: High(struct_btl_customizedDateGap);  group: 2;   arc: 1),     //  struct_btl_customizedDateGap
    (HostName: 'SCDM_UNIT';                     IBname: 'UNIT';                      PCname: 'UNIT';                 ASname: 'TABLE00F';  pfx: 'UM_';     struct: @struct_tbl_unit;               nrfld: High(struct_tbl_unit);               group: 1;   arc: 0),     //  tbl_unit
    (HostName: 'SCDM_WKC_GROUP';                IBname: 'WKC_GROUP';                 PCname: 'WKC_GROUP';            ASname: 'TABLE00F';  pfx: 'WG_';     struct: @struct_tbl_wkc_group;                nrfld: High(struct_tbl_wkc_group);    group: 1;   arc: 0),     //  tbl_wkc_group
    (HostName: 'SCDM_WKC';                      IBname: 'WKC';                       PCname: 'WKC';                  ASname: 'WCMAC00F';  pfx: 'WC_';     struct: @struct_tbl_wkc;                nrfld: High(struct_tbl_wkc);                group: 1;   arc: 0),     //  tbl_wkc
    (HostName: 'SCDM_WKC_PROC';                 IBname: 'WKC_PROC';                  PCname: 'WKC_PROC';             ASname: 'WCPRO00F';  pfx: 'WP_';     struct: @struct_tbl_wkc_proc;           nrfld: High(struct_tbl_wkc_proc);           group: 1;   arc: 0),     //  tbl_wkc_proc
    (HostName: 'SCDM_WKST';                     IBname: 'WKST';                      PCname: 'WKST';                 ASname: 'MQMWS00F';  pfx: 'WK_';     struct: @struct_tbl_wkst;               nrfld: High(struct_tbl_wkst);               group: 1;   arc: 0),     //  tbl_wkst
    (HostName: 'SCDM_WKS_WKC';                  IBname: 'WKS_WKC';                   PCname: 'WKS_WKC';              ASname: 'MQMWW00F';  pfx: 'WW_';     struct: @struct_tbl_wkst_wkc;           nrfld: High(struct_tbl_wkst_wkc);           group: 1;   arc: 0),     //  tbl_wkst_wkc
    (HostName: 'SCDM_WKC_PRIORITY';             IBname: 'WKC_PRIORITY';              PCname: 'WKC_PRIORITY';         ASname: 'MQMWC00F';  pfx: 'WP_';     struct: @struct_tbl_wkc_priority;       nrfld: High(struct_tbl_wkc_priority);       group: 1;   arc: 0),     //  tbl_wkc_priority
    (HostName: 'SCDM_WKC_CAT_CAPACITY';         IBname: 'WKC_CAT_CAPACITY';          PCname: 'WKC_CAT_CAPACITY';     ASname: '';          pfx: 'WCC_';    struct: @struct_tbl_wkc_cat_capacity;   nrfld: High(struct_tbl_wkc_cat_capacity);  group: 1;   arc: 0),     //  tbl_wkc_cat_capacity
    (HostName: 'SCDC_TEXT_DISPLAY_SET_FIELDS';  IBname: 'TEXT_DISPLAY_SET_FIELDS';   PCname: 'TEXT_DISPLAY_SET_FIELDS'; ASname: '';       pfx: 'TDF_';    struct: @struct_tbl_cfg_text_display_set_fields;    nrfld: High(struct_tbl_cfg_text_display_set_fields);  group: 2;   arc: 1),     //  tbl_cfg_text_display_set_fields
    (HostName: 'SCDC_TEXT_DISPLAY_SET_WKC';     IBname: 'TEXT_DISPLAY_SET_WKC';      PCname: 'TEXT_DISPLAY_SET_WKC'; ASname: '';          pfx: 'TDW_';    struct: @struct_tbl_cfg_text_display_set_wkc;       nrfld: High(struct_tbl_cfg_text_display_set_wkc);     group: 2;   arc: 1),     //  tbl_cfg_text_display_set_wkc
    (HostName: 'SCDC_MAIL_SET_LIST';            IBname: 'MAIL_SET_LIST';             ASname: '';                                          pfx: 'MSL_';    struct: @struct_tbl_cfg_Mail_set_List;       nrfld: High(struct_tbl_cfg_Mail_set_List);     group: 2;   arc: 1),     //  struct_tbl_cfg_Mail_set_List
    (HostName: 'SCDC_Grouped_By_Fields';        IBname: 'Grouped_By_Fields';         PCname: 'Grouped_By_Fields';    ASname: '';          pfx: 'GB_';     struct: @struct_tbl_GroupedByFields;    nrfld: High(struct_tbl_GroupedByFields);    group: 2;   arc: 1),     //  tbl_Grouped_by_fields
    (HostName: 'SCDM_WKC_Change';               IBname: 'WKC_Change';                PCname: 'WKC_Change';           ASname: '';          pfx: 'WG_';     struct: @struct_tbl_wkc_Change;         nrfld: High(struct_tbl_wkc_Change);         group: 1;   arc: 1),     //  tbl_wkc_Change
    (HostName: 'SCDM_RSC_Change';               IBname: 'RSC_Change';                PCname: 'RSC_Change';           ASname: '';          pfx: 'RG_';     struct: @struct_tbl_rsc_Change;         nrfld: High(struct_tbl_rsc_Change);         group: 1;   arc: 1),     //  tbl_rsc_Change
    (HostName: 'SCDM_PROC';                     IBname: 'PROC';                      PCname: 'PROC';                 ASname: '';          pfx: 'PR_';     struct: @struct_tbl_Proc;               nrfld: High(struct_tbl_Proc);               group: 1;   arc: 1),     //  tbl_Proc
    (HostName: 'SCDM_CAL';                      IBname: 'CAL';                       PCname: 'CAL';                  ASname: '';          pfx: 'CL_';     struct: @struct_tbl_Cal;                nrfld: High(struct_tbl_Cal);                group: 1;   arc: 1),     //  tbl_Cal
    (HostName: 'SCDM_LICENCE';                  IBname: 'LICENCE';                   PCname: 'LICENCE';              ASname: '';          pfx: 'LIC_';    struct: @struct_tbl_licence;            nrfld: High(struct_tbl_licence);            group: 1;  arc: 0),     //  tbl_licence
    (HostName: 'SCDM_LICENCE2';                 IBname: 'LICENCE2';                  PCname: 'LICENCE2';             ASname: '';          pfx: 'LIC_';    struct: @struct_tbl_licence2;           nrfld: High(struct_tbl_licence2);           group: 1;  arc: 0),     //  tbl_licence2
    (HostName: 'SCDM_MACHINE_SETUP_CODE';       IBname: 'MACHINE_SETUP_CODE';        PCname: 'MACHINE_SETUP_CODE';   ASname: 'MQMMS00F';  pfx: 'MS_';     struct: @struct_tbl_machine_setup_code; nrfld: High(struct_tbl_machine_setup_code); group: 1;   arc: 1),     //  tbl_machine_setup_code
    (HostName: 'SCDM_WKC_DEPENDENCY';           IBname: 'WKC_DEPENDENCY';            PCname: 'WKC_DEPENDENCY';       ASname: 'MQMWD00F';  pfx: 'WD_';     struct: @struct_tbl_Wkc_dependency;     nrfld: High(struct_tbl_Wkc_dependency);     group: 1;   arc: 0),     //  tbl_Wkc_dependency
    (HostName: 'SCDM_MATERIAL';                 IBname: 'MATERIAL';                  PCname: 'MATERIAL';             ASname: 'MQMMT00F';  pfx: 'MT_';     struct: @struct_tbl_Material;           nrfld: High(struct_tbl_Material);           group: 1;   arc: 1),     //  tbl_Material
    (HostName: 'SCDM_MATERIAL_SUP_DETAIL';      IBname: 'MATERIAL_SUP_DETAIL';       PCname: 'MATERIAL_SUP_DETAIL';  ASname: 'MQMMD00F';  pfx: 'MD_';     struct: @struct_tbl_material_sup_detail;nrfld: High(struct_tbl_material_sup_detail);group: 1;   arc: 0),     //  tbl_Material_sup_detail
    (HostName: 'SCDM_MATERIAL_SUP_HEADER';      IBname: 'MATERIAL_SUP_HEADER';       PCname: 'MATERIAL_SUP_HEADER';  ASname: 'MQMMH00F';  pfx: 'MH_';     struct: @struct_tbl_material_sup_header;nrfld: High(struct_tbl_material_sup_header);group: 1;   arc: 0),      //  tbl_Material_sup_header
    (HostName: 'SCDM_PRODUCED_ARTICLE';         IBname: 'PRODUCED_ARTICLE';          PCname: 'PRODUCED_ARTICLE';     ASname: 'MQMPA00F';  pfx: 'PA_';     struct: @struct_tbl_produced_article;   nrfld: High(struct_tbl_produced_article);   group: 1;   arc: 1),      //  tbl_produced_article
    (HostName: 'SCDM_PRODUCTS';                 IBname: 'PRODUCTS';                  PCname: 'PRODUCTS';             ASname: 'MQMAR00F';  pfx: 'PAR_';    struct: @struct_tbl_products;           nrfld: High(struct_tbl_products);           group: 1;   arc: 1),      //  tbl_products
    (HostName: 'SCDM_BALANCE_HEADER';           IBname: 'BALANCE_HEADER';            PCname: 'BALANCE_HEADER';       ASname: 'MQMBH00F';  pfx: 'BH_';     struct: @struct_tbl_balance_header;     nrfld: High(struct_tbl_balance_header);     group: 1;   arc: 1),      //  tbl_balance_header
    (HostName: 'SCDM_BALANCE_DETAIL';           IBname: 'BALANCE_DETAIL';            PCname: 'BALANCE_DETAIL';       ASname: 'MQMBD00F';  pfx: 'BD_';     struct: @struct_tbl_balance_detail;     nrfld: High(struct_tbl_balance_detail);     group: 1;   arc: 1),      //  tbl_balance_detail
    (HostName: 'SCDM_DOWNLOAD_TIME';            IBname: 'DOWNLOAD_TIME';             PCname: 'DOWNLOAD_TIME';        ASname: 'MQMDD00F';  pfx: 'DD_';     struct: @struct_tbl_download_time;      nrfld: High(struct_tbl_download_time);      group: 1;   arc: 1),      //  tbl_balance_detail
    (HostName: 'SCDM_JOB_MESSAGES';             IBname: 'JOB_MESSAGES';              PCname: 'JOB_MESSAGES';         ASname: '';          pfx: 'JM_';     struct: @struct_tbl_Job_Massages;       nrfld: High(struct_tbl_Job_Massages);       group: 1;   arc: 1),      //  tbl_balance_detail
    (HostName: 'SCDM_LEARNING_CURVE';           IBname: 'LEARNING_CURVE';            PCname: 'LEARNING_CURVE';       ASname: 'MQMLC00f';  pfx: 'LC_';     struct: @struct_tbl_LearningCurve;      nrfld: High(struct_tbl_LearningCurve);      group: 1;   arc: 1),  //  tbl_LearningCurve
    (HostName: 'ITEMSSTOCK';                    IBname: 'ITEMSSTOCK';                PCname: 'ITEMSSTOCK';           ASname: '';          pfx:  '';       struct: @struct_tbl_ItemsStock;         nrfld: High(struct_tbl_ItemsStock);         group: 1;   arc: 1), //  tbl_ItemsStock
    (HostName: 'ITEMSSTOCKCHANGES';             IBname: 'ITEMSSTOCKCHANGES';         PCname: 'ITEMSSTOCKCHANGES';    ASname: '';          pfx: 'ITC_';    struct: @struct_tbl_ItemsStockChanges;  nrfld: High(struct_tbl_ItemsStockChanges);  group: 1; arc: 1), //  tbl_ItemsStockChanges
    (HostName: 'ITEMSSTOCKEXCEPTIONS';          IBname: 'ITEMSSTOCKEXCEPTIONS';      PCname: 'ITEMSSTOCKEXCEPTIONS'; ASname: '';          pfx: 'ITE_';    struct: @struct_tbl_ItemsStockExceptions; nrfld: High(struct_tbl_ItemsStockExceptions); group: 1; arc: 1), //  tbl_ItemsStockExceptions
    (HostName: 'SCDC_GROUP_RES_DEFINITION';     IBname: 'GROUP_RES_DEFINITION';      PCname: 'GROUP_RES_DEFINITION'; ASname: '';          pfx: 'GR_';     struct: @struct_tbl_GroupResDefinition; nrfld: High(struct_tbl_GroupResDefinition); group: 2;   arc: 1),
    (HostName: 'SCDM_STOCKDETAILS';             IBname: 'STOCKDETAILS';              PCname: 'STOCKDETAILS';         ASname: '';          pfx: 'SD_';     struct: @struct_tbl_StockDetails;       nrfld: High(struct_tbl_StockDetails);       group: 1;   arc: 1), //  struct_tbl_StockDetails
    (HostName: 'SCDC_AUTO_SEQ_SCORE_ADDITION';  IBname: 'AUTO_SEQ_SCORE_ADDITION';    PCname: 'AUTO_SEQ_SCORE_ADDITION';  ASname: '';      pfx: 'AU_';     struct: @struct_tbl_AutoSeq_ScoreAddition;  nrfld: High(struct_tbl_AutoSeq_ScoreAddition);  group: 2;   arc: 1), //  AutoSeq_ScoreAddition,
    (HostName: 'SCDC_AUTO_SEQ_JOBTOJOB_DEFINE'; IBname: 'AUTO_SEQ_JOBTOJOB_DEFINE'; PCname: 'AUTO_SEQ_JOBTOJOB_DEFINE';  ASname: ''; pfx: 'AJ_';     struct: @struct_tbl_AutoSeqJobToJobDefinitions;  nrfld: High(struct_tbl_AutoSeqJobToJobDefinitions);  group: 2;   arc: 1), //  tbl_AutoSeqJobToJobDefinitions,
    (HostName: 'SCDM_PROPERTY_AS_DATE';         IBname: 'PROPERTY_AS_DATE';          PCname: 'PROPERTY_AS_DATE';     ASname: '';          pfx: 'PD_';     struct: @struct_tbl_PropAsDate;         nrfld: High(struct_tbl_PropAsDate);         group: 1;   arc: 1),  // PropAsDate
    (HostName: 'SCDM_PROPERTY_AS_RGB';          IBname: 'PROPERTY_AS_RGB';           PCname: 'PROPERTY_AS_RGB';      ASname: '';          pfx: 'PRGB_';   struct: @struct_tbl_PropAsRGB;         nrfld: High(struct_tbl_PropAsRGB);           group: 1;   arc: 1),  // PropAsRGB
    (HostName: 'SCDM_ASSIGNED_PROPERTIES';      IBname: 'ASSIGNED_PROPERTIES';       PCname: 'ASSIGNED_PROPERTIES';  ASname: '';          pfx: 'PA_';     struct: @struct_tbl_PropAssigned;       nrfld: High(struct_tbl_PropAssigned);       group: 1;   arc: 1),  // PropAssigned
    (HostName: 'SCDM_LOG';                      IBname: 'LOG';                       PCname: 'LOG';                  ASname: '';          pfx: 'LG_';     struct: @struct_tbl_Log;                nrfld: High(struct_tbl_Log);                group: 1;   arc: 1),  //
    (HostName: 'SCDM_OVERRIDE_STEP_PARAMETERS'; IBname: 'OVERRIDE_STEP_PARAMETERS';  PCname: 'OVERRIDE_STEP_PARAMETERS';  ASname: '';     pfx: 'PDO_';    struct: @struct_tbl_OverrideStepParameters;  nrfld: High(struct_tbl_OverrideStepParameters);  group: 1;   arc: 1),  // struct_tbl_speed_machine
    (HostName: 'SCDC_BIN_MATERIAL_FILTER';      IBname: 'BIN_MATERIAL_FILTER';       PCname: 'BIN_MATERIAL_FILTER';           ASname: ''; pfx: 'MF_';     struct: @struct_tbl_cfg_binMaterialFilter;      nrfld: High(struct_tbl_cfg_binMaterialFilter); group: 2; arc: 1), //  cfg_binMaterialFilter
    (HostName: 'SCDM_PRODUCT_PPROPERTIES';      IBname: 'PRODUCT_PPROPERTIES';      PCname: 'PRODUCT_PPROPERTIES';    ASname: '';        pfx: 'PDP_';     struct: @struct_tbl_ProductProperties; nrfld: High(struct_tbl_ProductProperties);  group: 1;   arc: 0),     //  tbl_ProductProperties
    (HostName: 'SCDM_Material_Detail_Schedule'; IBname: 'Material_Detail_Schedule'; PCname: 'Material_Detail_Schedule'; ASname: '';      pfx: 'MDS_';     struct: @struct_tbl_MaterialDetailSchedule; nrfld: High(struct_tbl_MaterialDetailSchedule);  group: 1;   arc: 1),
    (HostName: 'SCDM_Material_Det_Sched_Link';  IBname: 'Material_Det_Sched_Link';  PCname: 'Material_Det_Sched_Link'; ASname: '';       pfx: 'MDSL_';     struct: @struct_tbl_MaterialDetailSchedule_link; nrfld: High(struct_tbl_MaterialDetailSchedule_link);  group: 1;   arc: 1),
    (HostName: 'SCDM_SCHED_DOWNLOAD_WARPRSV';   IBname: 'SCHED_DOWNLOAD_WARPRSV';   PCname: 'SCHED_DOWNLOAD_WARPRSV'; ASname: '';        pfx: 'SDW_';     struct: @struct_tbl_SCHEDULES_DOWNLOAD_WARPRSV;       nrfld: High(struct_tbl_SCHEDULES_DOWNLOAD_WARPRSV);     group: 1;   arc: 1),
    (HostName: 'SCDM_TotalsView';               IBname: 'TotalsView';               PCname: 'TotalsView';             ASname: '';        pfx: 'TV_';      struct: @struct_tbl_TotalsView; nrfld: High(struct_tbl_TotalsView);  group: 1;   arc: 0),      //  tbl_totalsView
    (HostName: 'SCDM_TotalsViewWorkCenters';    IBname: 'TotalsViewWorkCenters';    PCname: 'TotalsViewWorkCenters';  ASname: '';        pfx: 'TVWC_';    struct: @struct_tbl_TotalsViewWorkCenters; nrfld: High(struct_tbl_TotalsViewWorkCenters);  group: 1;   arc: 0),      //  tbl_TotalsViewWorkCenters
    (HostName: 'SCDM_TotalsViewGroupByColumns'; IBname: 'TotalsViewGroupByColumns'; PCname: 'TotalsViewGroupByColumns';  ASname: '';     pfx: 'TVGC_';    struct: @struct_tbl_TotalsViewGroupByColumns; nrfld: High(struct_tbl_TotalsViewGroupByColumns);  group: 1;   arc: 0),      //  tbl_TotalsViewGroupByColumns
    (HostName: 'SCDM_TotalsViewContent';        IBname: 'TotalsViewContent';        PCname: 'TotalsViewContent';      ASname: '';        pfx: 'TVC_';     struct: @struct_tbl_TotalsViewContent; nrfld: High(struct_tbl_TotalsViewContent);  group: 1;   arc: 0),      //  tbl_TotalsViewContent
    (HostName: 'SCDC_CUSTOM_MENU';              IBname: 'CUSTOM_MENU';              PCname: 'CUSTOM_MENU';            ASname: '';        pfx: 'CM_';      struct: @struct_tbl_CustomMenu;       nrfld: High(struct_tbl_CustomMenu);     group: 2;   arc: 0),     //  struct_tbl_cfg_Menu
    (HostName: 'SCDM_SavedPlanCopyHeader';      IBname: 'SavedPlanCopyHeader';      PCname: 'SavedPlanCopyHeader';    ASname: '';        pfx: 'CPH_';     struct: @struct_tbl_SavedPlanCopyHeader;       nrfld: High(struct_tbl_SavedPlanCopyHeader);     group: 1;   arc: 1),      //  struct_tbl_cfg_Menu
    (HostName: 'SCDM_SavedPlanCopy';            IBname: 'SavedPlanCopy';            PCname: 'SavedPlanCopy';          ASname: '';        pfx: 'CP_';      struct: @struct_tbl_SavedPlanCopy;       nrfld: High(struct_tbl_SavedPlanCopy);     group: 1;   arc: 1)      //  struct_tbl_cfg_Menu
  );

  domInfo : array [domain] of TDomInfo = (
    (typ: db_varch; len: 30;   dec: 0),  // dom_ProdReq
    (typ: db_int;   len:  0;   dec: 0),  // dom_longId
    (typ: db_short; len:  0;   dec: 0),  // dom_midId   Avi - shoul be  len = 5
    (typ: db_short; len:  0;   dec: 0),  // dom_shortId  Avi - should be len = 3
    (typ: db_short; len:  0;   dec: 0),  // dom_shtstId
    (typ: db_dec;   len: 15;   dec: 5),  // dom_quant
    (typ: db_dec;   len: 14;   dec: 4),  // dom_quant_material
    (typ: db_dec;   len:  9;   dec: 4),  // dom_speed
    (typ: db_varch; len:  6;   dec: 0),  // dom_longChId
    (typ: db_varch; len:  4;   dec: 0),  // dom_shortChId
    (typ: db_varch; len:  2;   dec: 0),  // dom_smallChId
    (typ: db_varch; len: 10;   dec: 0),  // dom_codeWS
    (typ: db_varch; len:  8;   dec: 0),  // dom_codeRes
    (typ: db_varch; len:  8;   dec: 0),  // dom_codeWctr
    (typ: db_varch; len: 16;   dec: 0),  // dom_codeNetGrp
    (typ: db_varch; len: 10;   dec: 0),  // dom_CodeGrpByPropRule
    (typ: db_varch; len: 10;   dec: 0),  // dom_usr
    (typ: db_varch; len:  3;   dec: 0),  // dom_Dom_Cal
    (typ: db_varch; len:  3;   dec: 0), //  dom_3 char
    (typ: db_dec;   len: 11;   dec: 2),  // dom_durMin
    (typ: db_dec;   len:  9;   dec: 4),  // dom_durMinMulti
    (typ: db_tmStp; len:  0;   dec: 0),  // dom_timing
    (typ: db_varch; len: 30;   dec: 0),  // dom_text30
    (typ: db_varch; len: 35;   dec: 0),  // dom_text35
    (typ: db_varch; len: 40;   dec: 0),  // dom_text40
    (typ: db_varch; len: 50;   dec: 0),  // dom_text50
    (typ: db_varch; len: 60;   dec: 0),  // dom_text60
    (typ: db_varch; len: 120;  dec: 0),  // dom_text120
    (typ: db_varch; len: 250;  dec: 0),  // dom_text250
    (typ: db_varch; len: 14;   dec: 0),  // dom_text14
    (typ: db_varch; len: 28;   dec: 0),  // dom_text28
    (typ: db_varch; len: 12;   dec: 0),  // dom_text12
    (typ: db_varch; len: 20;   dec: 0),  // dom_text20
    (typ: db_varch; len: 25;   dec: 0),  // dom_text25
    (typ: db_varch; len: 10;   dec: 0),  // dom_text10
    (typ: db_varch; len: 120;  dec: 0),  // dom_Info
    (typ: db_varch; len: 35;   dec: 0),  // dom_family
    (typ: db_varch; len:  3;   dec: 0),  // dom_Category
    (typ: db_varch; len:  3;   dec: 0),  // dom_Mixregrp
    (typ: db_short; len:  0;   dec: 0),  // dom_intCode
    (typ: db_int;   len:  0;   dec: 0),  // dom_Weight
    (typ: db_varch; len:  3;   dec: 0),  // dom_UM
    (typ: db_varch; len:  2;   dec: 0),  // Dom_2Char
    (typ: db_varch; len:  2;   dec: 0),  // dom_ReqOrig
    (typ: db_varch; len:  2;   dec: 0),  // dom_BchCode
    (typ: db_varch; len: 90;   dec: 0),  // dom_propVal - property value
    (typ: db_ch;    len:  1;   dec: 0),  // Type options (1-2-3)
    (typ: db_dec;   len:  7;   dec: 2),  // Type Batch Size
    (typ: db_varch; len:  3;   dec: 0),  // dom_Div
    (typ: db_varch; len:  4;   dec: 0),  // work Center Group
    (typ: db_varch; len:  4;   dec: 0),  // Production Line
    (typ: db_varch; len:  5;   dec: 0),  // Property Code
    (typ: db_short; len:  0;   dec: 0),  // Decimal Number   Avi Should be len = (1,0)
    (typ: db_varch; len: 90;   dec: 0),  // property base value
    (typ: db_dec;   len: 14;   dec: 4),  // Value to add rsc
    (typ: db_varch; len:  2;   dec: 0),  // Property Rules
    (typ: db_varch; len:  3;   dec: 0),  // Prod Type
    (typ: db_varch; len: 30;   dec: 0),  // dom_ConnKey
    (typ: db_short; len:  0;   dec: 0),  // dom_NumOfLevel
    (typ: db_short; len:  0;   dec: 0),  // dom_CompCaseNum
    (typ: db_dec  ; len:  5;   dec: 0),  // dom_NumRscComp
    (typ: db_dec  ; len:  9;   dec: 3),  // dom_NumResPlan
    (typ: db_dec  ; len: 11;   dec: 3),  // dom_TimeSteps
    (typ: db_varch; len: 5;    dec: 0),  // dom_AddiCode
    (typ: db_dec;   len: 14;   dec: 4),  // dom_multiToBatchUm
    (typ: db_ch;    len: 1;    dec: 0),  // dom_Flag
    (typ: db_dec;   len: 4;    dec: 1),  // don_Hours
    (typ: db_varch; len: 15;   dec: 0),  //
    (typ: db_varch; len: 2000;  dec: 0),  // text 2000
    (typ: db_varch; len: 40;   dec: 0),  // dom_text40
    (typ: db_varch; len: 1024;  dec: 0),  // text 1024
    (typ: db_varch; len: 100;   dec: 0),  // text 100
    (typ: db_varch; len: 15;    dec: 0),  // text 15
    (typ: db_varch; len: 12;    dec: 0),  // text 12
    (typ: db_varch; len: 7;    dec: 0),    // text 7
    (typ: db_varch; len: 8;    dec: 0),    // text 8
    (typ: db_bigInt;len: 0;   dec: 0)   //bigint
    );


  fldInfo : array[fldId] of TFldInfo = (
({$ifdef DEVELOP}fInfo: fli_ArtType;  {$endif}                              name: 'ART_TYPE';                    dom: dom_ProdType),
({$ifdef DEVELOP}fInfo: fli_stGroup;{$endif}                                name: 'ST_GROUP';                    dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_stGroupFrom;{$endif}                            name: 'ST_GROUP_FROM';               dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_stGroupTo;{$endif}                              name: 'ST_GROUP_TO';                 dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_ForcedGroup;{$endif}                            name: 'GRP_FORCED';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ForcedGroupNo;{$endif}                          name: 'FORCED_GRP_NO';               dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_StepIsGrouped;{$endif}                          name: 'STEP_IS_GRPED';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ConnForwardSubStep;{$endif}                     name: 'FWD_SUBSTEP';                 dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_ConnForwardReProcess;{$endif}                   name: 'FWD_REPROC_SUBSTEP';          dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_ConnBackwardSubStep;{$endif}                    name: 'BKW_SUBSTEP';                 dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_ConnBackwardReProcess;{$endif}                  name: 'BKW_REPROC_SUBSTEP';          dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_SaveAtLeastOnesAsFinnal;{$endif}                name: 'SAVES_AT_LEAST_ONES_FINNAL';  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_index;{$endif}                                  name: 'TABLE_INDEX';                 dom: dom_LongId),
({$ifdef DEVELOP}fInfo: fli_quant;{$endif}                                  name: 'QTY';                         dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_quantHost;{$endif}                              name: 'QTY_HOST';                    dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_StartingQty;{$endif}                            name: 'START_QTY';                   dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_ProgressReApplied;{$endif}                      name: 'ProgressReApplied';           dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_subLinRscId;{$endif}                            name: 'PROD_SUBLIN_RSC';             dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Operation;{$endif}                              name: 'OPERATION';                   dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_vers;{$endif}                                   name: 'VERS_NO';                     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_rsc;{$endif}                                    name: 'RSC_CODE';                    dom: dom_CodeRes),
({$ifdef DEVELOP}fInfo: fli_rsc_cal;{$endif}                                name: 'RSC_CODE';                    dom: dom_txt12),
({$ifdef DEVELOP}fInfo: fli_rsc_To;{$endif}                                 name: 'RSC_CODE_TO';                 dom: dom_CodeRes),
({$ifdef DEVELOP}fInfo: fli_rscHost;{$endif}                                name: 'RSC_CODE_HOST';               dom: dom_CodeRes),
({$ifdef DEVELOP}fInfo: fli_bch;{$endif}                                    name: 'BCH_CODE';                    dom: dom_BchCode),
({$ifdef DEVELOP}fInfo: fli_usrCr;{$endif}                                  name: 'USR_NAMECR';                  dom: dom_usr),
({$ifdef DEVELOP}fInfo: fli_usrTmCr;{$endif}                                name: 'USR_TIMECR';                  dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_usrCg;{$endif}                                  name: 'USR_NAMECG';                  dom: dom_usr),
({$ifdef DEVELOP}fInfo: fli_usrTmCg;{$endif}                                name: 'USR_TIMECG';                  dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_supMin;{$endif}                                 name: 'SETUP_MIN';                   dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_exeMin;{$endif}                                 name: 'EXE_MIN';                     dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_ColorIndex;{$endif}                             name: 'COLOR_INDEX';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_schedStart;{$endif}                             name: 'SCH_START';                   dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_schedEnd;{$endif}                               name: 'SCH_END';                     dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_planStart;{$endif}                              name: 'PLAN_START';                  dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ActualStart;{$endif}                            name: 'ACTUAL_START';                dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ActualEnd;{$endif}                              name: 'ACTUAL_END';                  dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_FirstScheduleResource;{$endif}                  name: 'FirstScheduleResource';       dom: dom_CodeRes),
({$ifdef DEVELOP}fInfo: fli_FirstScheduleStart;{$endif}                     name: 'FirstScheduleStart';          dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_FirstScheduleEnd;{$endif}                       name: 'FirstScheduleEnd';            dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_VersionIdentifier;{$endif}                      name: 'Identifier_Version';          dom: dom_text10),
({$ifdef DEVELOP}fInfo: fli_VersionScheduleResource;{$endif}                name: 'ScheduleResource_Version';    dom: dom_CodeRes),
({$ifdef DEVELOP}fInfo: fli_VersionScheduleStart;{$endif}                   name: 'ScheduleStart_Version';       dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_VersionScheduleEnd;{$endif}                     name: 'ScheduleEnd_Version';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_Mqm_environment;{$endif}                        name: 'MQM_ENV';                     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_schedType;{$endif}                              name: 'SCHED_TYPE';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_planEnd;{$endif}                                name: 'PLAN_END';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ganntStart;{$endif}                             name: 'GNTSTART';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ganntEnd;{$endif}                               name: 'GNTEND';                      dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_preqNo;{$endif}                                 name: 'PREQ_NO';                     dom: dom_ProdReq),
({$ifdef DEVELOP}fInfo: fli_NewPreqUniqId;{$endif}                          name: 'NEW_PREQ_UNIQ_ID';            dom: dom_text10),
({$ifdef DEVELOP}fInfo: fli_Serving_Code;{$endif}                           name: 'SERVING_CODE';                dom: dom_txt25),
({$ifdef DEVELOP}fInfo: fli_Served_Code;{$endif}                            name: 'SERVED_CODE';                 dom: dom_txt25),
({$ifdef DEVELOP}fInfo: fli_CurveFamilyIdCode;{$endif}                      name: 'Curve_Family_Id_Code';        dom: dom_txt25),
({$ifdef DEVELOP}fInfo: fli_preqNo_To;{$endif}                              name: 'PREQ_NO_TO';                  dom: dom_ProdReq),
({$ifdef DEVELOP}fInfo: fli_PrevProdNum;{$endif}                            name: 'PREV_PREQ_NO';                dom: dom_ProdReq),
({$ifdef DEVELOP}fInfo: fli_preqStatus;{$endif}                             name: 'PROD_STATUS';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_HistoriclReq;{$endif}                           name: 'HISTORICAL_REQ';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ReqOrigin;{$endif}                              name: 'REQ_ORIGIN';                  dom: dom_ReqOrig),
({$ifdef DEVELOP}fInfo: fli_HistoriclData;{$endif}                          name: 'HISTORICAL_DATE';             dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ProdUMCode;{$endif}                             name: 'PROD_UM';                     dom: dom_UM),
({$ifdef DEVELOP}fInfo: fli_ProdFamily;{$endif}                             name: 'PROD_FAMILY';                 dom: dom_text120),
({$ifdef DEVELOP}fInfo: fli_MaterialFamily;{$endif}                         name: 'MATERIAL_FAMILY';             dom: dom_text120),
({$ifdef DEVELOP}fInfo: fli_um;{$endif}                                     name: 'UM';                          dom: dom_Um),
({$ifdef DEVELOP}fInfo: fli_pstepId;{$endif}                                name: 'PSTEP_ID';                    dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_pstepId_To;{$endif}                             name: 'PSTEP_ID_TO';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_LeadpstepIdForSplit;{$endif}                    name: 'LEAD_STEP_SPLITED';           dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_pstepId_From;{$endif}                           name: 'PSTEP_ID_FROM';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_infoLineNum;{$endif}                            name: 'INFO_LINE_NUM';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_InfoArea;{$endif}                               name: 'INFO_AREA';                   dom: dom_Info),
({$ifdef DEVELOP}fInfo: fli_infoType;{$endif}                               name: 'INFO_TYPE';                   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ConnKey;{$endif}                                name: 'CONNE_KEY';                   dom: dom_ConnKey),
({$ifdef DEVELOP}fInfo: fli_ConnType;{$endif}                               name: 'CONNE_TYPE';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_psubstId;{$endif}                               name: 'PSUBST_ID';                   dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_psubstId_To;{$endif}                            name: 'PSUBST_ID_TO';                dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_NumOfLevel;{$endif}                             name: 'NUM_LEVELS';                  dom: dom_NumOfLevel),
({$ifdef DEVELOP}fInfo: fli_ConnLevel;{$endif}                              name: 'CONN_LEVEL';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ConnCertentyLevel;{$endif}                      name: 'CONN_CERTENT_LEVEL';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_DueDate;{$endif}                                name: 'DUE_DATE';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_orig_duedate;{$endif}                           name: 'ORIG_DUE_DATE';               dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_reprocNo;{$endif}                               name: 'REPROC_NO';                   dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_reprocNo_From;{$endif}                          name: 'REPROC_NO_FROM';              dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_wkcProc;{$endif}                                name: 'WKCT_PROC';                   dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_wkcProc_To;{$endif}                             name: 'WKCT_PROC_TO';                dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_ProgressType;{$endif}                           name: 'LAST_PROG_TYPE';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_Prog_Override_Type;{$endif}                     name: 'PROG_OVERRIDE_TYPE';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ProgressTypeHost;{$endif}                       name: 'LAST_PROG_TYPE_HOST';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_progrStart;{$endif}                             name: 'PROGRSTART';                  dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_progrStartHost;{$endif}                         name: 'PROGRSTART_HOST';             dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_progrEnd;{$endif}                               name: 'PROGREND';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_progrEndHost;{$endif}                           name: 'PROGREND_HOST';               dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ProgressGroup;{$endif}                          name: 'PROGRESED_GROUP';             dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_prgCurrDate;{$endif}                            name: 'CURR_PRG_DATE';               dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_prgCurrDateHost;{$endif}                        name: 'CURR_PRG_DATE_HOST';          dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_prgRemTime;{$endif}                             name: 'REMAIN_TIME';                 dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_prgRemTimeHost;{$endif}                         name: 'REMAIN_TIME_HOST';            dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_wkstCode;{$endif}                               name: 'WKST_CODE';                   dom: dom_codeWS),
({$ifdef DEVELOP}fInfo: fli_wkDescr;{$endif}                                name: 'WKDESCR';                     dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_wkPasswd;{$endif}                               name: 'WKPASSWD';                    dom: dom_text10),
({$ifdef DEVELOP}fInfo: fli_wkCtrCode;{$endif}                              name: 'WKCNTER';                     dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_WCProcess;{$endif}                              name: 'WC_PROCESS';                  dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_wkCtrCode_To;{$endif}                           name: 'WKCNTER_To';                  dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_SchedwkCtrCode;{$endif}                         name: 'SCHED_WCNTER';                dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_SchedWCProcess;{$endif}                         name: 'SCHED_WPROCESS';              dom: dom_shortChId),
({$ifdef DEVELOP}fInfo: fli_wkCtrGroup;{$endif}                             name: 'WK_CNTER_GROUP';              dom: dom_Cntr_Group),
({$ifdef DEVELOP}fInfo: fli_PlantCode;{$endif}                              name: 'PLANT_CODE';                  dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_MCMSequence;{$endif}                            name: 'MCM_SEQUENCE';                dom: dom_shortid),
({$ifdef DEVELOP}fInfo: fli_WarpHandle;{$endif}                             name: 'WARP_HANDLE';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_Ignoreprogress;{$endif}                         name: 'IGNOREPROGRESS';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_Division;{$endif}                               name: 'DIVISION_CODE';               dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_RuleForGroupingMQM;{$endif}                     name: 'RULE_FOR_GROUPING_MQM';       dom: dom_CodeGrpByPropRule),
({$ifdef DEVELOP}fInfo: fli_RuleForGroupingMCM;{$endif}                     name: 'RULE_FOR_GROUPING_MCM';       dom: dom_CodeGrpByPropRule),
({$ifdef DEVELOP}fInfo: fli_CreateDateTimeUTC;{$endif}                      name: 'CREATE_DATE_TIME_UTC';        dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_CrtOrUpdateDateTimeUTC;{$endif}                 name: 'UPDATED_DATE_TIME_UTC';       dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_MainWC;{$endif}                                 name: 'MAIN_WC';                     dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_TypOprtion;{$endif}                             name: 'TYP_OPRATION';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_TypProcess;{$endif}                             name: 'TYP_PROCESS';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_CalCod;{$endif}                                 name: 'CAL';                         dom: dom_Cal),
({$ifdef DEVELOP}fInfo: fli_EfficiencyOnWcOrResLevel;{$endif}               name: 'EFFICIENCYON_WC_OR_RES_LVL';  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_TypeOfUse;{$endif}                              name: 'TYPEUSED';                    dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_SDescr;{$endif}                                 name: 'S_DESCR';                     dom: dom_txt28),
({$ifdef DEVELOP}fInfo: fli_StepWorkCenter;{$endif}                         name: 'StepWorkCenter';              dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_StepWorkCenterProcess;{$endif}                  name: 'StepWorkCenterProcess';       dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_wkCtrCodeKeyFileST;{$endif}                     name: 'WKCNTER_KEY_ST';              dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_WCProcessKeyFileST;{$endif}                     name: 'WC_PROCESS_KEY_ST';           dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_rscKeyFileST;{$endif}                           name: 'RES_KEY_ST';                  dom: dom_CodeRes),
({$ifdef DEVELOP}fInfo: fli_ResCatKeyFileST;{$endif}                        name: 'RES_CAT_KEY_ST';              dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_LDescr;{$endif}                                 name: 'L_DESCR';                     dom: dom_text60),
({$ifdef DEVELOP}fInfo: fli_Text;{$endif}                                   name: 'TEXT';                        dom: dom_text250),
({$ifdef DEVELOP}fInfo: fli_DisplayText1;{$endif}                           name: 'TEXT1';                       dom: dom_txt12),
({$ifdef DEVELOP}fInfo: fli_DisplayText2;{$endif}                           name: 'TEXT2';                       dom: dom_txt12),
({$ifdef DEVELOP}fInfo: fli_RscCat;{$endif}                                 name: 'RES_CATEGORY';                dom: Dom_Category),
({$ifdef DEVELOP}fInfo: fli_addiCode;{$endif}                               name: 'ADD_CODE';                    dom: dom_AddiCode),
({$ifdef DEVELOP}fInfo: fli_ConsumingZone;{$endif}                          name: 'CONSUM_ZONE';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: tbl_GeneratorCode;{$endif}                          name: 'GenCode';                     dom: dom_txt12),
({$ifdef DEVELOP}fInfo: tbl_GeneratorNum;{$endif}                           name: 'GenNumber';                   dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_ProcesType;{$endif}                             name: 'PROCES_TYPE';                 dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_Standrd_bch_Size;{$endif}                       name: 'STANDRD_BCH_SIZE';            dom: dom_bch_Size),
({$ifdef DEVELOP}fInfo: fli_BchUM;{$endif}                                  name: 'BCH_UM';                      dom: dom_UM),
({$ifdef DEVELOP}fInfo: fli_Min_bch_size;{$endif}                           name: 'MIN_BCH_SIZE';                dom: dom_bch_Size),
({$ifdef DEVELOP}fInfo: fli_Max_bch_size;{$endif}                           name: 'MAX_BCH_SIZE';                dom: dom_bch_Size),
({$ifdef DEVELOP}fInfo: fli_rscType;{$endif}                                name: 'RSC_TYPE';                    dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_NumOfRsc;{$endif}                               name: 'NUM_RSC_COMP';                dom: dom_NumRscComp),
({$ifdef DEVELOP}fInfo: fli_WorkAsOneBatchMachineGroupCode;{$endif}         name: 'ONE_BATCH_MACHINE_GRP_CODE';  dom: dom_txt12),
({$ifdef DEVELOP}fInfo: fli_Rsc_PLanType;{$endif}                           name: 'RSC_PLAN_TYPE';               dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_OneBatchMachineGrouptype;{$endif}               name: 'One_Batch_Machine_GRP_type';  dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_LineWithinPlant;{$endif}                        name: 'Line_Within_Plant';           dom: dom_txt3),
({$ifdef DEVELOP}fInfo: fli_PropOptimumMaxMultiplier;{$endif}               name: 'OptimumMaxMultiplier';        dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropMinMultiplier;{$endif}                      name: 'MinMultiplier';               dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_ForceOutsideLimitQty;{$endif}                   name: 'FORCE_OUTSIDE_LIMIT_QTY';     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ForceOccToResCase99;{$endif}                    name: 'FORCE_OCC_TO_RES_CASE_99';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_TabsCode;{$endif}                               name: 'TABCODE';                     dom: Dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TabsDesc;{$endif}                               name: 'TABDESC';                     dom: dom_text40),
({$ifdef DEVELOP}fInfo: fli_ActiveOnPc;{$endif}                             name: 'ACTIVONPC';                   dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_ToBeSched;{$endif}                              name: 'TO_SCHED';                    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrevLeadTime_mqm;{$endif}                       name: 'PREV_LEAD_TIME_MQM';          dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_NextLeadTime_mqm;{$endif}                       name: 'NEXT_LEAD_TIME_MQM';          dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PrevLeadTimeBatch_mqm;{$endif}                  name: 'PREV_LEAD_TIME_BATCH_MQM';    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_NextLeadTimeBatch_mqm;{$endif}                  name: 'NEXT_LEAD_TIME_BATCH_MQM';    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PrevLeadTime_Mcm;{$endif}                       name: 'PREV_LEAD_TIME_MCM';          dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_NextLeadTime_Mcm;{$endif}                       name: 'NEXT_LEAD_TIME_MCM';          dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PrevLeadTimeBatch_Mcm;{$endif}                  name: 'PREV_LEAD_TIME_BATCH_MCM';    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_NextLeadTimeBatch_Mcm;{$endif}                  name: 'NEXT_LEAD_TIME_BATCH_MCM';    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_BatchSizePerStep;{$endif}                       name: 'BATCH_SIZE_PER_STEP';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MinBatchSize;{$endif}                           name: 'MIN_BATCH_SIZE';              dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_OptimumBatchSize;{$endif}                       name: 'OPTIMUM_BATCH_SIZE';          dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_MaxBatchSize;{$endif}                           name: 'MAX_BATCH_SIZE';          dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_OverlapWithOtherSteps;{$endif}                  name: 'OVERLAP_WITH_OTHER_STEPS';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StepType;{$endif}                               name: 'STEP_TYP';                    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MaterialArrivDate;{$endif}                      name: 'MAT_ARRV_DATE';               dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_prevStep;{$endif}                               name: 'PRV_STEP';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_SetUpTimJob;{$endif}                            name: 'SETUP_TIME_JOB';              dom: dom_TimeSteps),
({$ifdef DEVELOP}fInfo: fli_FrcMatDate;{$endif}                             name: 'FRC_MAT_DATE';                dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_FrcLowestDate;{$endif}                          name: 'FRC_LOW_DATE';                dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_FrcHighestDate;{$endif}                         name: 'FRC_HIGH_DATE';               dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_FrcOverlapp;{$endif}                            name: 'FRC_OVERLAPP';                dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_FrcDelDate;{$endif}                             name: 'FRC_DEL_DATE';                dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_ReactivateReq;{$endif}                          name: 'REACTIVATE';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ExecTimeInitQty;{$endif}                        name: 'EXC_TIME_INIT_QTY';           dom: dom_TimeSteps),
({$ifdef DEVELOP}fInfo: fli_CapUsed;{$endif}                                name: 'CAPUSED';                     dom: dom_TimeSteps),
({$ifdef DEVELOP}fInfo: fli_NextStep;{$endif}                               name: 'NEX_STEP';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_prevStepSched_mqm;{$endif}                      name: 'PRV_STEP_SCHED_MQM';          dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_NextStepSched_mqm;{$endif}                      name: 'NEX_STEP_SCHED_MQM';          dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_prevStepTrue;{$endif}                           name: 'PRV_STEP_TRUE';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NextStepTrue;{$endif}                           name: 'NEX_STEP_TRUE';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_prevStepSched_Mcm;{$endif}                      name: 'PRV_STEP_SCHED_MCM';          dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NextStepSched_Mcm;{$endif}                      name: 'NEX_STEP_SCHED_MCM';          dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NextStepTimeLimit;{$endif}                      name: 'NEX_STEP_LIMIT_TIME';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_prevStepTimeLimit;{$endif}                      name: 'PRV_STEP_LIMIT_TIME';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_InitialPlanScheduledDateTime;{$endif}           name: 'INI_PLAN_SCHED_DATE_TIME';    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_FinalPlanScheduledDateTime;{$endif}             name: 'FIN_PLAN_SCHED_DATE_TIME';    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_HighEndTimeLimit;{$endif}                       name: 'HIGH_LIMIT_TIMEND';           dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_AllowSplit;{$endif}                             name: 'ALLOW_SPLIT';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_SplitFamaly;{$endif}                            name: 'SPLITED_FAMILY';              dom: dom_txt12),
({$ifdef DEVELOP}fInfo: fli_LowStartTimeLimit;{$endif}                      name: 'LOW_LIMIT_TIME_STRT';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ProdLowDataTime;{$endif}                        name: 'PROD_LOW_TIME_STRT';          dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ProdDelivDate;{$endif}                          name: 'PROD_DELIVY_DATE';            dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_quantInit;{$endif}                              name: 'INIT_QUENT';                  dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_quantFinl;{$endif}                              name: 'FIN_QUENT';                   dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_Weight;{$endif}                                 name: 'WEIGHT';                      dom: Dom_Weight),
({$ifdef DEVELOP}fInfo: fli_DescUM;{$endif}                                 name: 'DESC_UM';                     dom: Dom_UM),
({$ifdef DEVELOP}fInfo: fli_SetupTimStep;{$endif}                           name: 'SETUP_TIME_STP';              dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_excTimeStep;{$endif}                            name: 'EXC_TIME_STP';                dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_Visible;{$endif}                                name: 'VISIBLE';                     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_NumResPlan;{$endif}                             name: 'RES_NUM_PLN';                 dom: dom_NumResPlan),
({$ifdef DEVELOP}fInfo: fli_Tbl_Name;{$endif}                               name: 'TABLE_LOCAL_NAME';            dom: dom_txt20),
({$ifdef DEVELOP}fInfo: fli_Tbl_Host;{$endif}                               name: 'TABLE_HOST_NAME';             dom: dom_txt20),
({$ifdef DEVELOP}fInfo: fli_CanStepOverlap;{$endif}                         name: 'CAN_STEP_OVERLAP';            dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_CanOverlapNonWrkingHours;{$endif}               name: 'CAN_OVERLAP_NON_WORKING_H';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MinQtyPassNextStp;{$endif}                      name: 'MIN_QTY_PASS_NEXT_STP';       dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_StepCanBeOverlapped;{$endif}                    name: 'CAN_STEP_OVERLAPPED';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StepHandleReProc;{$endif}                       name: 'STEP_HANDLE_REPROCES';        dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StepPartGenralPlan;{$endif}                     name: 'STEP_PART_GEN_PLAN';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StepCanGroup;{$endif}                           name: 'STEP_CAN_GROUP';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_GroupType;{$endif}                              name: 'GROUP_TYPE';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_UseAllResourceParts;{$endif}                    name: 'UseAllResourceParts';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ResOccupation;{$endif}                          name: 'RESOURCEOCCUPATION';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_NumMachinesTosuspend;{$endif}                   name: 'NUM_MACHINE_SUSPEND';         dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_MinQtyToStart;{$endif}                          name: 'MIN_QTY_TO_START';            dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_ConnTypToPrevStepSplit;{$endif}                 name: 'CONN_TYPE_PREV_STEP_SPLIT';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StepClosed;{$endif}                             name: 'STEP_CLOSED';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MaxStartDateAutoSeq;{$endif}                    name: 'Max_StartDate_AutoSeq';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_alternative_Qty;{$endif}                        name: 'AlternativeQty';              dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_alternative_UM;{$endif}                         name: 'AlternativeUM';               dom: dom_UM),
({$ifdef DEVELOP}fInfo: fli_Alternative_um_handled;{$endif}                 name: 'Alternative_UM_Handled';      dom: dom_Type),

//({$ifdef DEVELOP}fInfo: fli_OverlapQtyUM;{$endif}                           name: 'OVERLAP_QTY_UM';              dom: dom_UM),
({$ifdef DEVELOP}fInfo: fli_divCode;{$endif}                                name: 'DIV_CODE';                    dom: dom_Div),
({$ifdef DEVELOP}fInfo: fli_dispoCode;{$endif}                              name: 'DSP_CODE';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_BinColField;{$endif}                            name: 'BIN_COL_FIELD';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_BinColTitle;{$endif}                            name: 'BIN_COL_TITLE';               dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_BinColPos;{$endif}                              name: 'BIN_COL_POS';                 dom: Dom_intCode),
({$ifdef DEVELOP}fInfo: fli_BinColWidth;{$endif}                            name: 'BIN_COL_WIDTH';               dom: Dom_intCode),
({$ifdef DEVELOP}fInfo: fli_BinColVisibl;{$endif}                           name: 'BIN_COL_VIS';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_BinColOrder;{$endif}                            name: 'BIN_COL_ORD';                 dom: Dom_intCode),
({$ifdef DEVELOP}fInfo: fli_BinColDescending;{$endif}                       name: 'BIN_COL_DESCENDING';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_BinColNumColSorted;{$endif}                     name: 'BIN_COL_NUM_COL_SORTED';      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_TabVis;{$endif}                                 name: 'TABVIS';                      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_CategorySDesc;{$endif}                          name: 'DESC';                        dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_CategoryLDesc;{$endif}                          name: 'LONG_DESC';                   dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_AdditionalCapacity;{$endif}                     name: 'ADDITIONAL_CAPACITY';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_IDENTIFIER;{$endif}                             name: 'IDENTIFIER';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Sequence;{$endif}                               name: 'SEQUENCE';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_GroupInternalSortSeq;{$endif}                   name: 'GROUP_INTERNAL_SORT_SEQ';     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NewSetup;{$endif}                              name: 'NEW_SETUP';                   dom: dom_speed),
({$ifdef DEVELOP}fInfo: fli_GrpContinueSeq;{$endif}                         name: 'GRP_SEQUENCE';                dom: dom_smallChId),
({$ifdef DEVELOP}fInfo: fli_SeqAlpha;{$endif}                               name: 'SEQALPHA';                    dom: dom_prodType),
({$ifdef DEVELOP}fInfo: fli_AlterWC;{$endif}                                name: 'ALTERN_WC';                   dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_AlterWCProces;{$endif}                          name: 'ALTERN_WC_PROCES';            dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_DateBegin;{$endif}                              name: 'DATE_BEGIN';                  dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_DateEnd;{$endif}                                name: 'DATE_END';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ProdLine;{$endif}                               name: 'PROD_LINE';                   dom: dom_Prod_LineCode),
({$ifdef DEVELOP}fInfo: fli_SubRsc;{$endif}                                 name: 'SUB_RSC';                     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NumSubRscComponents;{$endif}                    name: 'NUM_RSC_COMPONENTS';          dom: dom_midId),  // Avi not in use ... to check
({$ifdef DEVELOP}fInfo: fli_multipToBatchUm;{$endif}                        name: 'MULTIPILR_To_BATCH_UM';       dom: dom_multiToBatchUm),
({$ifdef DEVELOP}fInfo: fli_Comment;{$endif}                                name: 'COMMENT';                     dom: dom_text120),
({$ifdef DEVELOP}fInfo: fli_PropertyCode;{$endif}                           name: 'PROPERTY';                    dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropSDesc;{$endif}                              name: 'S_DESC';                      dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PropLDesc;{$endif}                              name: 'L_DESC';                      dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PropType;{$endif}                               name: 'TYPE';                        dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PropIsdate;{$endif}                             name: 'PROP_IS_DATE';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_LastScheudleChange;{$endif}                     name: 'LAST_SCHEDULE_CHANGED';       dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_AssignedProp;{$endif}                           name: 'Assigned_Prop';               dom: dom_txt20),
({$ifdef DEVELOP}fInfo: fli_ChgPropValCauseResched;{$endif}                 name: 'CNG_PROP_VAL_CAUSE_RESCHED';  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PropInstanceCounter;{$endif}                    name: 'PROP_INSTANCE_COUNTER';       dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropValueInstanceCounter;{$endif}               name: 'PROPVAL_INSTANCE_COUNTER';    dom: dom_propVal),
({$ifdef DEVELOP}fInfo: fli_LearningCurveCode;{$endif}                      name: 'LEARNING_CURVE_CODE';         dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_LearningCurveCodeByOccToOcc;{$endif}            name: 'LEARNING_CURVE_CODE_OCC_OCC'; dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_LearningCurveType;{$endif}                      name: 'LEARNING_CURVE_TYPE';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ApprovalDate;{$endif}                           name: 'Approval_Date';               dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_DecNum;{$endif}                                 name: 'NUM_OF_DEC';                  dom: dom_DecNum),
({$ifdef DEVELOP}fInfo: fli_BalanceDecNum;{$endif}                          name: 'BalanceNumberOfDecimals';     dom: dom_DecNum),
({$ifdef DEVELOP}fInfo: fli_CalDate;{$endif}                                name: 'CAL_DATE';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_Prog_Wrk_Hr;{$endif}                            name: 'Prog_Wrk_Hr';                 dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_ChangeType;{$endif}                             name: 'Change_Type';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_SH1_start;{$endif}                              name: 'SH1_start';                   dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_SH1_end;{$endif}                                name: 'SH1_end';                     dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_SH2_start;{$endif}                              name: 'SH2_start';                   dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_SH2_end;{$endif}                                name: 'SH2_end';                     dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_SH3_start;{$endif}                              name: 'SH3_start';                   dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_SH3_end;{$endif}                                name: 'SH3_end';                     dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_SH4_start;{$endif}                              name: 'SH4_start';                   dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_SH4_end;{$endif}                                name: 'SH4_end';                     dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_RP_MainLevel;{$endif}                           name: 'RP_CONN_LEV_MAIN';            dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_RP_Add_WC_Proc;{$endif}                         name: 'RP_ADD_WC_PROC';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_RO_CompatChekType;{$endif}                      name: 'RO_CMPAT_CHK';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_RO_MainLevel;{$endif}                           name: 'RO_CONN_LEV_Main';            dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_RO_Add_WC_Proc;{$endif}                         name: 'RO__Add_WC_Proc';             dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_RO_Add_ProdType;{$endif}                        name: 'RO_PROD_TYP';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_OO_CompatChekType;{$endif}                      name: 'OO_CMPAT_CHK';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_OO_MainLevel;{$endif}                           name: 'OO_CONN_LEV_MAIN';            dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_OO_Add_WC_Proc;{$endif}                         name: 'OO_Add_WC_Proc';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_OO_Add_ProdType;{$endif}                        name: 'OO_PROD_TYP';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PropBaseValue;{$endif}                          name: 'PROPTY_VALUE';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_Propty_Calculated_Value;{$endif}                name: 'PROPTY_VALUE_CALC';           dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_PropAddRscOfOcc;{$endif}                        name: 'Add_RSC_OCC';                 dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropAddValToAddiRsc;{$endif}                    name: 'VAL_ADDED';                   dom: dom_PropValueAdd),
({$ifdef DEVELOP}fInfo: fli_PropDftCaseRsc_Occ_Ruls;{$endif}                name: 'DFT_CASE_RSC_OCC_RULS';       dom: dom_PropRules),
({$ifdef DEVELOP}fInfo: fli_PropDftCaseOcc_Occ_Ruls;{$endif}                name: 'DFT_CASE_OCC_OCC_RULS';       dom: dom_PropRules),
({$ifdef DEVELOP}fInfo: fli_PropDftSameGroupForOcc_Occ_Ruls;{$endif}        name: 'DFT_SAME_GRP_OCC_OCC_RULS';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PropValTakeForGroup;{$endif}                    name: 'VAL_TAKE_FOR_GROUP';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ProdType;{$endif}                               name: 'TYPE_PROD';                   dom: dom_ProdType),
({$ifdef DEVELOP}fInfo: fli_PropLineNum;{$endif}                            name: 'LINE_NUMBER';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PropValue;{$endif}                              name: 'VALUE';                       dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_PropOperand;{$endif}                            name: 'OPERAND';                     dom: dom_PropRules),
({$ifdef DEVELOP}fInfo: fli_DepOnCurr;{$endif}                              name: 'DEP_ON_CURR';                 dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_DepValue;{$endif}                               name: 'DEP_VALUE';                   dom: dom_PropVal),
({$ifdef DEVELOP}fInfo: fli_RuleConst;{$endif}                              name: 'RULE_CONST';                  dom: dom_PropVal),
({$ifdef DEVELOP}fInfo: fli_ManPropValue;{$endif}                           name: 'MAN_VALUE';                   dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_ManChg;{$endif}                                 name: 'MAN_CHG';                     dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_PropCase;{$endif}                               name: 'CASE';                        dom: dom_PropRules),
({$ifdef DEVELOP}fInfo: fli_PropSetupTyp;{$endif}                           name: 'SETUP_TYPE';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PropSetUpTime;{$endif}                          name: 'SETUP_TIME';                  dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PropSetUpOverlappTime;{$endif}                  name: 'SETUP_OVERLAPPING_TIME';      dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PropSetUpTimeMult;{$endif}                      name: 'SETUP_TIME_MULT';             dom: dom_durMinMulti),
({$ifdef DEVELOP}fInfo: fli_PropSetUpOverlappTimeMult;{$endif}              name: 'OVERLAPPING_TIME_MULT';       dom: dom_durMinMulti),
({$ifdef DEVELOP}fInfo: fli_CanBeSameGroup;{$endif}                         name: 'CAN_BE_SAME_GROUP';           dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_teoreticl_wc;{$endif}                           name: 'TEORETIC_WC';                 dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_duration;{$endif}                               name: 'DURATION';                    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_LeadTime;{$endif}                               name: 'LEAD_TIME';                   dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_RuleOccFrom;{$endif}                            name: 'FROM_POS';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_RuleOccLength;{$endif}                          name: 'LENGTH';                      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_RuleOccForPartialPropVal;{$endif}               name: 'PARTIAL_PROP_VAL';            dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WhenOkNextSeq;{$endif}                          name: 'NEXT_SEQ_WHEN_OK';            dom: dom_shortId),
({$ifdef DEVELOP}fInfo: Fli_AddiRsc;{$endif}                                name: 'ADD_RSC';                     dom: dom_AddiCode),
({$ifdef DEVELOP}fInfo: fli_NumHourBforSetup;{$endif}                       name: 'H_BEFOR_SETUP';               dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_NumHourAfterSetup;{$endif}                      name: 'H_AFTER_SETUP';               dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_ValAddAddiRscBeforSetup;{$endif}                name: 'VAL_ADD_ADDIRSC_BEFOR_SETUP'; dom: dom_PropValueAdd),
({$ifdef DEVELOP}fInfo: fli_ValAddAddiRscWhileSetup;{$endif}                name: 'VAL_ADD_ADDIRSC_WHIL_SETUP';  dom: dom_PropValueAdd),
({$ifdef DEVELOP}fInfo: fli_ValAddAddiRscAfterSetup;{$endif}                name: 'VAL_ADD_ADDIRSC_AFTER_SETUP'; dom: dom_PropValueAdd),
({$ifdef DEVELOP}fInfo: fli_CapacyResrv;{$endif}                            name: 'CAPACTY_RESRV';               dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_CapacyResrvStatus;{$endif}                      name: 'STATUS';                      dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_CapacyResTyp;{$endif}                           name: 'CAPACITY_TYPE';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_Capacity_To_Job;{$endif}                        name: 'CAPACITY_TO_JOB';             dom: dom_PropRules),
({$ifdef DEVELOP}fInfo: fli_Zoom;{$endif}                                   name: 'Zoom';                        dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_HZoom;{$endif}                                  name: 'HZoom';                       dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_SZoom;{$endif}                                  name: 'SZoom';                       dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_SlotGroup;{$endif}                              name: 'SlotGroup';                   dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_supMinBase;{$endif}                             name: 'SUP_BASE';                    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_supMinReal;{$endif}                             name: 'SUP_REAL';                    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_supMinOvlp;{$endif}                             name: 'SUP_Overlap';                 dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_CalStartDate;{$endif}                           name: 'START_DATE';                  dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_CalEndDate;{$endif}                             name: 'END_DATE';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_SH1_EFFIC;{$endif}                              name: 'SH1_EFFIC';                   dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_SH2_EFFIC;{$endif}                              name: 'SH2_EFFIC';                   dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_SH3_EFFIC;{$endif}                              name: 'SH3_EFFIC';                   dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_SH4_EFFIC;{$endif}                              name: 'SH4_EFFIC';                   dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_EnvDescr;{$endif}                               name: 'EnvDescr';                    dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_Customer;{$endif}                               name: 'Customer';                    dom: dom_text35),
({$ifdef DEVELOP}fInfo: fli_MqmVersion;{$endif}                             name: 'MqmVersion';                  dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_MonthBefore;{$endif}                            name: 'MonthBefore';                 dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_StDateForPlan;{$endif}                          name: 'StDateForPlan';               dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_Language;{$endif}                               name: 'Language';                    dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_CurrTScale;{$endif}                             name: 'CurrTScale';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_CurrDtTime;{$endif}                             name: 'CurrDtTime';                  dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ShowCal;{$endif}                                name: 'ShowCal';                     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_CurrRscSort;{$endif}                            name: 'CurrRscSort';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_ShowZoom;{$endif}                               name: 'ShowZoom';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_RscOrderType;{$endif}                           name: 'RscOrderType';                dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_RscOrderItem;{$endif}                           name: 'RscOrderItem';                dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_wdwPlanLeft;{$endif}                            name: 'wdwPlanLeft';                 dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwPlanTop;{$endif}                             name: 'wdwPlanTop';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwPlanWidth;{$endif}                           name: 'wdwPlanWidth';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwPlanHeight;{$endif}                          name: 'wdwPlanHeight';               dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwPlanstate;{$endif}                           name: 'wdwPlanState';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwBinDock;{$endif}                             name: 'wdwBinDock';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwBinLeft;{$endif}                             name: 'wdwBinLeft';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwBinTop;{$endif}                              name: 'wdwBinTop';                   dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwBinWidth;{$endif}                            name: 'wdwBinWidth';                 dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwBinHeight;{$endif}                           name: 'wdwBinHeight';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwBinState;{$endif}                            name: 'wdwBinState';                 dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_wdwBinSplitter;{$endif}                         name: 'wdwBinSplitter';              dom: dom_intCode),

({$ifdef DEVELOP}fInfo: fli_MCMcNumMaxPrd;{$endif}                          name: 'MCMMaxPrdNum';                   dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_MCMcMaxPrd1;{$endif}                            name: 'MCMMaxPrd1';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_MCMcMaxPrd2;{$endif}                            name: 'MCMMaxPrd2';                dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_MCMCatViewWcHoursPerc;{$endif}                  name: 'MCMCatViewWcHoursPerc';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_MCMPropertyViewWcHoursPerc;{$endif}             name: 'MCMPropViewWcHoursPerc';              dom: dom_shortId),


({$ifdef DEVELOP}fInfo: fli_AppGlobSettings;{$endif}                        name: 'GLOBALSETTINGS';              dom: dom_Text1024),
({$ifdef DEVELOP}fInfo: fli_appSettings;{$endif}                            name: 'sett';                        dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_FieldName;{$endif}                              name: 'FieldName';                   dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_value;{$endif}                                  name: 'Value';                       dom: dom_text120),
({$ifdef DEVELOP}fInfo: fli_CheckStepSeq;{$endif}                           name: 'CheckStepSeq';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CenterStartOnMove;{$endif}                      name: 'CenterStartOnMove';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_WarnOnMoveFinal;{$endif}                        name: 'WarnOnMoveFinal';             dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_DefSchedType;{$endif}                           name: 'DefSchedType';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ShowColorJobMode;{$endif}                       name: 'ShowColorJobMode';            dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ConfLevels;{$endif}                             name: 'ConfLevels';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_SplitConfLevels;{$endif}                        name: 'SplitConfLevels';             dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_MoveOption;{$endif}                             name: 'MoveOption';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ActAutoSchedCode;{$endif}                       name: 'ActAutoSchedCode';            dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_UnscheduleClosedJobsOnStart;{$endif}            name: 'UnscheduleClosedJobsOnStart'; dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_SlotDisplay;{$endif}                            name: 'SlotDisplay';                 dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CustomSlotDisplay;{$endif}                      name: 'CustomSlotDisplay';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CustomPROPDisplay;{$endif}                      name: 'CustomPropDisplay';           dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_CustomPROPSymbol;{$endif}                       name: 'CustomPropSymbol';            dom: dom_txt3),
({$ifdef DEVELOP}fInfo: fli_FiltConfLevels_final;{$endif}                   name: 'Conf_Lvl_Final';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltConfLevels_Ini;{$endif}                     name: 'Conf_Lvl_Ini';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltConfLevel1;{$endif}                         name: 'Conf_Lvl_1';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltConfLevel2;{$endif}                         name: 'Conf_Lvl_2';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltConfLevel3;{$endif}                         name: 'Conf_Lvl_3';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltConfLevel4;{$endif}                         name: 'Conf_Lvl_4';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltConfLevel5;{$endif}                         name: 'Conf_Lvl_5';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltCustomerDateConfirmed;{$endif}              name: 'Customer_Date_Conf';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltCustomerDateCalculated;{$endif}             name: 'Customer_Date_Calc';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltCustomerDateRequested;{$endif}              name: 'Customer_Date_Requestd';      dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltConfLevNewLog;{$endif}                      name: 'Conf_ConLvl_New';             dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MinQty;{$endif}                                 name: 'MinQty';                      dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_MaxQty;{$endif}                                 name: 'MaxQty';                      dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_MinutAddAftrStp;{$endif}                        name: 'Min_Add_Aftr_Stp';            dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_MaxMinutBfrNxtStp;{$endif}                      name: 'Max_Min_bfr_Next_Stp';        dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_propLen;{$endif}                                name: 'PROP_LEN';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Bin_ReadOnly;{$endif}                           name: 'READ_ONLY';                   dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_DelivDate_From;{$endif}                         name: 'DelivDate_From';              dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_DelivDate_To;{$endif}                           name: 'DelivDate_To';                dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ProdLowDate_From;{$endif}                       name: 'ProdLowData_From';            dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ProdLowDate_To;{$endif}                         name: 'ProdLowData_To';              dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_PlanStartDate_From;{$endif}                     name: 'PlanStartDate_From';          dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_PlanStartDate_To;{$endif}                       name: 'PlanStartDate_To';            dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_PlanStartDateToday_From;{$endif}                name: 'PlanStartDateToday_From';     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PlanStartDateToday_To;{$endif}                  name: 'PlanStartDateToday_To';       dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PlanEndDate_From;{$endif}                       name: 'PlanEndDate_From';            dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_PlanEndDate_To;{$endif}                         name: 'PlanEndtDate_To';             dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_PlanEndDateToday_From;{$endif}                  name: 'PlanEndDateToday_From';       dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PlanEndDateToday_To;{$endif}                    name: 'PlanEndDateToday_To';         dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NextStartDate_From;{$endif}                     name: 'NextStartDate_From';          dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_NextStartDate_To;{$endif}                       name: 'NextStartDate_To';            dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_NextStartDateToday_From;{$endif}                name: 'NextStartDateToday_From';     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NextStartDateToday_To;{$endif}                  name: 'NextStartDateToday_To';       dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PrevEndDate_From;{$endif}                       name: 'PrevEndDate_From';            dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_PrevEndDate_To;{$endif}                         name: 'PrevEndDate_To';              dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_PrevEndDateToday_From;{$endif}                  name: 'PrevEndDateToday_From';       dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PrevEndDateToday_To;{$endif}                    name: 'PrevEndDateToday_To';         dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_LowStartDate_From;{$endif}                      name: 'LowStartDate_From';           dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_LowStartDate_To;{$endif}                        name: 'LowStartDate_To';             dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_LatestEndingDate_From;{$endif}                  name: 'LatestEndingDate_From';       dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_LatestEndingDate_To;{$endif}                    name: 'LatestEndingDate_To';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ShowAlternative;{$endif}                        name: 'SHOW_ALTERNATIVE';            dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Wkcr_FromPlan;{$endif}                          name: 'WC_FROM_PLAN';                dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode;{$endif}                           name: 'PropCode';                    dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes;{$endif}                            name: 'PropRes';                     dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom;{$endif}                      name: 'PropVal_From';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo;{$endif}                        name: 'PropVal_To';                  dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltSchedJobs;{$endif}                          name: 'Sched_Jobs';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltWarplvl;{$endif}                            name: 'Warp_level';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltFltJobsOnGantt;{$endif}                     name: 'FltJobsOnGantt';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltClosedJobs;{$endif}                         name: 'Closed_Jobs';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Bin_OnlyReadOnly;{$endif}                       name: 'Only_ReadOnly';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltOnlySchedJobs;{$endif}                      name: 'Only_Sched';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltOnlyClosedJobs;{$endif}                     name: 'Only_Closed';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltGroups;{$endif}                             name: 'Groups';                      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltOnlyGroups;{$endif}                         name: 'Only_Groups';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_SchedStartDate_From;{$endif}                    name: 'SchedStartDate_From';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_SchedStartDate_To;{$endif}                      name: 'SchedStartDate_To';           dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ScheduledJobsCrossesDateTime_From;{$endif}      name: 'SchedCrossDate_From';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ScheduledJobsCrossesDateTime_To;{$endif}        name: 'SchedCrossDate_To';           dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_FiltTemporary;{$endif}                          name: 'FiltTemporary';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltPriority;{$endif}                           name: 'Priorities';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltProgress;{$endif}                           name: 'Progress';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltOnlyProgress;{$endif}                       name: 'OnlyProgress';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltAfterDeliveryDay;{$endif}                   name: 'AfterDeliveryDay';           dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltAfterDeliveryInDays;{$endif}                name: 'AfterDeliveryInDays';        dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltBeforeEarliestStart;{$endif}                name: 'BeforeEarliestStart';        dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltBeforeEarliestStartInDays;{$endif}          name: 'BeforeEarliestStartInDays';  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltAfterLatestEnd;{$endif}                     name: 'AfterLatestEnd';             dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltAfterLatestEndInDays;{$endif}               name: 'AfterLatestEndInDays';       dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltShouldBeScheduled;{$endif}                  name: 'ShouldBeScheduled';          dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltShouldBeScheduledIndays;{$endif}            name: 'ShouldBeScheduledIndays';    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltMissingMaterials;{$endif}                   name: 'MissingMaterials';           dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltMissingAddRes;{$endif}                      name: 'MissingAddRes';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltOveridePrevious;{$endif}                    name: 'OveridePrevious';            dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltOverideNext;{$endif}                        name: 'OverideNext';                dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltCompWithPrevJob;{$endif}                    name: 'CompWithPrevJob';            dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltCompWithPrevJobInCase;{$endif}              name: 'CompWithPrevJobInCase';      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltCompWithRes;{$endif}                        name: 'CompWithRes';                dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltCompWithResInCase;{$endif}                  name: 'CompWithResInCase';          dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltJobMsg;{$endif}                             name: 'JobMsg';                     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltImbalancedSteps;{$endif}                    name: 'ImbalancedStep';             dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_DaysFromToday_From;{$endif}                     name: 'DaysFromToday_From';         dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_DaysFromToday_To;{$endif}                       name: 'DaysFromToday_To';           dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_DaysFromToday_ToTime;{$endif}                   name: 'DaysFromToday_To_Time';      dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_FiltShowFirstGrplineInBin;{$endif}              name: 'ShowFirstGrplineInBin';      dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltAutoGroupSingleJob;{$endif}                 name: 'AutoGrpSingleJob';           dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltShowBatchGroupLinesInBin;{$endif}           name: 'ShowBtcGrpLinesInBin';       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltShowContinueGroupLinesInBin;{$endif}        name: 'ShowContinueGrpLinesInBin';  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode1;{$endif}                          name: 'PropCode1';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes1;{$endif}                           name: 'PropRes1';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom1;{$endif}                     name: 'PropVal_From1';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo1;{$endif}                       name: 'PropVal_To1';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode2;{$endif}                          name: 'PropCode2';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes2;{$endif}                           name: 'PropRes2';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom2;{$endif}                     name: 'PropVal_From2';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo2;{$endif}                       name: 'PropVal_To2';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode3;{$endif}                          name: 'PropCode3';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes3;{$endif}                           name: 'PropRes3';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom3;{$endif}                     name: 'PropVal_From3';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo3;{$endif}                       name: 'PropVal_To3';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode4;{$endif}                          name: 'PropCode4';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes4;{$endif}                           name: 'PropRes4';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom4;{$endif}                     name: 'PropVal_From4';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo4;{$endif}                       name: 'PropVal_To4';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode5;{$endif}                          name: 'PropCode5';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes5;{$endif}                           name: 'PropRes5';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom5;{$endif}                     name: 'PropVal_From5';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo5;{$endif}                       name: 'PropVal_To5';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode6;{$endif}                          name: 'PropCode6';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes6;{$endif}                           name: 'PropRes6';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom6;{$endif}                     name: 'PropVal_From6';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo6;{$endif}                       name: 'PropVal_To6';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode7;{$endif}                          name: 'PropCode7';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes7;{$endif}                           name: 'PropRes7';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom7;{$endif}                     name: 'PropVal_From7';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo7;{$endif}                       name: 'PropVal_To7';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode8;{$endif}                          name: 'PropCode8';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes8;{$endif}                           name: 'PropRes8';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom8;{$endif}                     name: 'PropVal_From8';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo8;{$endif}                       name: 'PropVal_To8';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode9;{$endif}                          name: 'PropCode9';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes9;{$endif}                           name: 'PropRes9';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom9;{$endif}                     name: 'PropVal_From9';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo9;{$endif}                       name: 'PropVal_To9';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode10;{$endif}                         name: 'PropCode10';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes10;{$endif}                          name: 'PropRes10';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom10;{$endif}                    name: 'PropVal_From10';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo10;{$endif}                      name: 'PropVal_To10';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode11;{$endif}                         name: 'PropCode11';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes11;{$endif}                          name: 'PropRes11';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom11;{$endif}                    name: 'PropVal_From11';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo11;{$endif}                      name: 'PropVal_To11';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode12;{$endif}                         name: 'PropCode12';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes12;{$endif}                          name: 'PropRes12';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom12;{$endif}                    name: 'PropVal_From12';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo12;{$endif}                      name: 'PropVal_To12';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode13;{$endif}                         name: 'PropCode13';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes13;{$endif}                          name: 'PropRes13';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom13;{$endif}                    name: 'PropVal_From13';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo13;{$endif}                      name: 'PropVal_To13';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode14;{$endif}                         name: 'PropCode14';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes14;{$endif}                          name: 'PropRes14';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom14;{$endif}                    name: 'PropVal_From14';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo14;{$endif}                      name: 'PropVal_To14';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode15;{$endif}                         name: 'PropCode15';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes15;{$endif}                          name: 'PropRes15';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom15;{$endif}                    name: 'PropVal_From15';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo15;{$endif}                      name: 'PropVal_To15';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode16;{$endif}                         name: 'PropCode16';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes16;{$endif}                          name: 'PropRes16';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom16;{$endif}                    name: 'PropVal_From16';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo16;{$endif}                      name: 'PropVal_To16';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode17;{$endif}                         name: 'PropCode17';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes17;{$endif}                          name: 'PropRes17';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom17;{$endif}                    name: 'PropVal_From17';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo17;{$endif}                      name: 'PropVal_To17';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode18;{$endif}                         name: 'PropCode18';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes18;{$endif}                          name: 'PropRes18';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom18;{$endif}                    name: 'PropVal_From18';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo18;{$endif}                      name: 'PropVal_To18';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode19;{$endif}                         name: 'PropCode19';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes19;{$endif}                          name: 'PropRes19';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom19;{$endif}                    name: 'PropVal_From19';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo19;{$endif}                      name: 'PropVal_To19';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode20;{$endif}                         name: 'PropCode20';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes20;{$endif}                          name: 'PropRes20';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom20;{$endif}                    name: 'PropVal_From20';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo20;{$endif}                      name: 'PropVal_To20';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode21;{$endif}                         name: 'PropCode21';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes21;{$endif}                          name: 'PropRes21';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom21;{$endif}                    name: 'PropVal_From21';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo21;{$endif}                      name: 'PropVal_To21';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode22;{$endif}                         name: 'PropCode22';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes22;{$endif}                          name: 'PropRes22';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom22;{$endif}                    name: 'PropVal_From22';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo22;{$endif}                      name: 'PropVal_To22';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode23;{$endif}                         name: 'PropCode23';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes23;{$endif}                          name: 'PropRes23';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom23;{$endif}                    name: 'PropVal_From23';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo23;{$endif}                      name: 'PropVal_To23';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode24;{$endif}                         name: 'PropCode24';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes24;{$endif}                          name: 'PropRes24';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom24;{$endif}                    name: 'PropVal_From24';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo24;{$endif}                      name: 'PropVal_To24';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode25;{$endif}                         name: 'PropCode25';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes25;{$endif}                          name: 'PropRes25';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom25;{$endif}                    name: 'PropVal_From25';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo25;{$endif}                      name: 'PropVal_To25';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode26;{$endif}                         name: 'PropCode26';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes26;{$endif}                          name: 'PropRes26';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom26;{$endif}                    name: 'PropVal_From26';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo26;{$endif}                      name: 'PropVal_To26';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode27;{$endif}                         name: 'PropCode27';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes27;{$endif}                          name: 'PropRes27';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom27;{$endif}                    name: 'PropVal_From27';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo27;{$endif}                      name: 'PropVal_To27';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode28;{$endif}                         name: 'PropCode28';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes28;{$endif}                          name: 'PropRes28';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom28;{$endif}                    name: 'PropVal_From28';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo28;{$endif}                      name: 'PropVal_To28';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode29;{$endif}                         name: 'PropCode29';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes29;{$endif}                          name: 'PropRes29';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom29;{$endif}                    name: 'PropVal_From29';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo29;{$endif}                      name: 'PropVal_To29';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode30;{$endif}                         name: 'PropCode30';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes30;{$endif}                          name: 'PropRes30';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom30;{$endif}                    name: 'PropVal_From30';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo30;{$endif}                      name: 'PropVal_To30';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode31;{$endif}                         name: 'PropCode31';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes31;{$endif}                          name: 'PropRes31';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom31;{$endif}                    name: 'PropVal_From31';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo31;{$endif}                      name: 'PropVal_To31';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode32;{$endif}                         name: 'PropCode32';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes32;{$endif}                          name: 'PropRes32';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom32;{$endif}                    name: 'PropVal_From32';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo32;{$endif}                      name: 'PropVal_To32';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode33;{$endif}                         name: 'PropCode33';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes33;{$endif}                          name: 'PropRes33';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom33;{$endif}                    name: 'PropVal_From33';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo33;{$endif}                      name: 'PropVal_To33';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode34;{$endif}                         name: 'PropCode34';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes34;{$endif}                          name: 'PropRes34';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom34;{$endif}                    name: 'PropVal_From34';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo34;{$endif}                      name: 'PropVal_To34';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode35;{$endif}                         name: 'PropCode35';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes35;{$endif}                          name: 'PropRes35';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom35;{$endif}                    name: 'PropVal_From35';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo35;{$endif}                      name: 'PropVal_To35';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode36;{$endif}                         name: 'PropCode36';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes36;{$endif}                          name: 'PropRes36';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom36;{$endif}                    name: 'PropVal_From36';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo36;{$endif}                      name: 'PropVal_To36';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode37;{$endif}                         name: 'PropCode37';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes37;{$endif}                          name: 'PropRes37';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom37;{$endif}                    name: 'PropVal_From37';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo37;{$endif}                      name: 'PropVal_To37';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode38;{$endif}                         name: 'PropCode38';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes38;{$endif}                          name: 'PropRes38';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom38;{$endif}                    name: 'PropVal_From38';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo38;{$endif}                      name: 'PropVal_To38';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode39;{$endif}                         name: 'PropCode39';                   dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes39;{$endif}                          name: 'PropRes39';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom39;{$endif}                    name: 'PropVal_From39';               dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo39;{$endif}                      name: 'PropVal_To39';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode40;{$endif}                         name: 'PropCode40';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes40;{$endif}                          name: 'PropRes40';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom40;{$endif}                    name: 'PropVal_From40';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo40;{$endif}                      name: 'PropVal_To40';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode41;{$endif}                         name: 'PropCode41';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes41;{$endif}                          name: 'PropRes41';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom41;{$endif}                    name: 'PropVal_From41';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo41;{$endif}                      name: 'PropVal_To41';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode42;{$endif}                         name: 'PropCode42';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes42;{$endif}                          name: 'PropRes42';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom42;{$endif}                    name: 'PropVal_From42';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo42;{$endif}                      name: 'PropVal_To42';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode43;{$endif}                         name: 'PropCode43';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes43;{$endif}                          name: 'PropRes43';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom43;{$endif}                    name: 'PropVal_From43';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo43;{$endif}                      name: 'PropVal_To43';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode44;{$endif}                         name: 'PropCode44';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes44;{$endif}                          name: 'PropRes44';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom44;{$endif}                    name: 'PropVal_From44';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo44;{$endif}                      name: 'PropVal_To44';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode45;{$endif}                         name: 'PropCode45';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes45;{$endif}                          name: 'PropRes45';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom45;{$endif}                    name: 'PropVal_From45';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo45;{$endif}                      name: 'PropVal_To45';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode46;{$endif}                         name: 'PropCode46';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes46;{$endif}                          name: 'PropRes46';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom46;{$endif}                    name: 'PropVal_From46';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo46;{$endif}                      name: 'PropVal_To46';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode47;{$endif}                         name: 'PropCode47';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes47;{$endif}                          name: 'PropRes47';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom47;{$endif}                    name: 'PropVal_From47';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo47;{$endif}                      name: 'PropVal_To47';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode48;{$endif}                         name: 'PropCode48';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes48;{$endif}                          name: 'PropRes48';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom48;{$endif}                    name: 'PropVal_From48';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo48;{$endif}                      name: 'PropVal_To48';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode49;{$endif}                         name: 'PropCode49';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes49;{$endif}                          name: 'PropRes49';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom49;{$endif}                    name: 'PropVal_From49';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo49;{$endif}                      name: 'PropVal_To49';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode50;{$endif}                         name: 'PropCode50';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes50;{$endif}                          name: 'PropRes50';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom50;{$endif}                    name: 'PropVal_From50';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo50;{$endif}                      name: 'PropVal_To50';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode51;{$endif}                         name: 'PropCode51';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes51;{$endif}                          name: 'PropRes51';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom51;{$endif}                    name: 'PropVal_From51';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo51;{$endif}                      name: 'PropVal_To51';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode52;{$endif}                         name: 'PropCode52';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes52;{$endif}                          name: 'PropRes52';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom52;{$endif}                    name: 'PropVal_From52';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo52;{$endif}                      name: 'PropVal_To52';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode53;{$endif}                         name: 'PropCode53';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes53;{$endif}                          name: 'PropRes53';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom53;{$endif}                    name: 'PropVal_From53';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo53;{$endif}                      name: 'PropVal_To53';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode54;{$endif}                         name: 'PropCode54';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes54;{$endif}                          name: 'PropRes54';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom54;{$endif}                    name: 'PropVal_From54';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo54;{$endif}                      name: 'PropVal_To54';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode55;{$endif}                         name: 'PropCode55';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes55;{$endif}                          name: 'PropRes55';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom55;{$endif}                    name: 'PropVal_From55';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo55;{$endif}                      name: 'PropVal_To55';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode56;{$endif}                         name: 'PropCode56';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes56;{$endif}                          name: 'PropRes56';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom56;{$endif}                    name: 'PropVal_From56';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo56;{$endif}                      name: 'PropVal_To56';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode57;{$endif}                         name: 'PropCode57';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes57;{$endif}                          name: 'PropRes57';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom57;{$endif}                    name: 'PropVal_From57';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo57;{$endif}                      name: 'PropVal_To57';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode58;{$endif}                         name: 'PropCode58';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes58;{$endif}                          name: 'PropRes58';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom58;{$endif}                    name: 'PropVal_From58';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo58;{$endif}                      name: 'PropVal_To58';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode59;{$endif}                         name: 'PropCode59';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes59;{$endif}                          name: 'PropRes59';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom59;{$endif}                    name: 'PropVal_From59';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo59;{$endif}                      name: 'PropVal_To59';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode60;{$endif}                         name: 'PropCode60';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes60;{$endif}                          name: 'PropRes60';                   dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom60;{$endif}                    name: 'PropVal_From60';              dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo60;{$endif}                      name: 'PropVal_To60';                dom: dom_PropBaseValue),

({$ifdef DEVELOP}fInfo: fli_filtFixedEarlistDateFrom;{$endif}               name: 'FixedEarlistDate_From';       dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_filtFixedEarlistDateTo;{$endif}                 name: 'FixedEarlistDate_To';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_filtFixedEarlistDateInDaysFrom;{$endif}         name: 'FixedEarlistDateInDays_From'; dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_filtFixedEarlistDateInDaysTo;{$endif}           name: 'FixedEarlistDateInDays_To';   dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_filtIgnoredProgress;{$endif}                    name: 'Progress_Ignored';                      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltResCatCode;{$endif}                        name: 'ResCatCode';                            dom: dom_Type),

//
({$ifdef DEVELOP}fInfo: fli_OverriddenTab;{$endif}                          name: 'OVERRIDDEN_TAB';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_FiltDependingOnNextHandledStep;{$endif}          name: 'DependOnNextHandledStep';     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltDependingOnPrevHandledStep;{$endif}          name: 'DependOnPrevHandledStep';     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_filtDependingOnNextHandledLinkedRequest;{$endif} name: 'DependOnNxtHandledLinkedReq'; dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_filtDependingOnPrevHandledLinkedRequest;{$endif} name: 'DependOnPrvHandledLinkedReq'; dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_GroupedByCode;{$endif}                          name: 'GROUPEDBY_CODE';              dom: dom_txt20),
({$ifdef DEVELOP}fInfo: fli_GroupedByProdReq;{$endif}                       name: 'PROD_REQ';                    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_GroupedByProdFamily;{$endif}                    name: 'PROD_FAMILY';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_GroupedByPropCode1;{$endif}                     name: 'PROP_CODE1';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_GroupedByPropCode2;{$endif}                     name: 'PROP_CODE2';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_GroupedByPropCode3;{$endif}                     name: 'PROP_CODE3';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_GroupedByPropCode4;{$endif}                     name: 'PROP_CODE4';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_GroupedByPropCode5;{$endif}                     name: 'PROP_CODE5';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_GroupedByPropCode6;{$endif}                     name: 'PROP_CODE6';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_GroupedByPropCode7;{$endif}                     name: 'PROP_CODE7';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_GroupedByPropCode8;{$endif}                     name: 'PROP_CODE8';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_GroupedByPropCode9;{$endif}                     name: 'PROP_CODE9';                  dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_GroupedByPropCode10;{$endif}                    name: 'PROP_CODE10';                 dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_ValFrom;{$endif}                                name: 'VALUE_FROM';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_ValTo;{$endif}                                  name: 'VALUE_TO';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_intColor;{$endif}                               name: 'INT_COLOR';                   dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_bdrColor;{$endif}                               name: 'BDR_COLOR';                   dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_txtColor;{$endif}                               name: 'TXT_COLOR';                   dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_txtDescription;{$endif}                         name: 'TXT_Description';             dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_LineNum;{$endif}                                name: 'LineNum';                     dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_Selected;{$endif}                               name: 'Selected';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_RscColDesc;{$endif}                             name: 'RscColDesc';                  dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_JobPropColor;{$endif}                           name: 'JOB_PROP_COLOR';              dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_DftColor;{$endif}                               name: 'DFT_COLOR';                   dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_PropValFrom;{$endif}                            name: 'PropValFrom';                 dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_PropValTo;{$endif}                              name: 'PropValTo';                   dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_excOpCode;{$endif}                              name: 'EXC_OP';                      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_updCode;{$endif}                                name: 'UPD_CODE';                    dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_updOp;{$endif}                                  name: 'UPD_OP';                      dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_TimeDescr;{$endif}                              name: 'TIME_DESCR';                  dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_SetName;{$endif}                                name: 'SET_NAME';                    dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_SetDesc;{$endif}                               name:  'SET_DESC';                    dom: dom_Text100),
({$ifdef DEVELOP}fInfo: fli_setIndex;{$endif}                               name: 'SET_INDEX';                   dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_setType;{$endif}                                name: 'SET_TYPE';                    dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_fieldType;{$endif}                              name: 'FIELD';                       dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_WorkStation;{$endif}                            name: 'Workstation';                 dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_title;{$endif}                                  name: 'TITLE';                       dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_orgTitle;{$endif}                               name: 'ORG_TITLE';                   dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_checked;{$endif}                                name: 'CHECKED';                     dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_fromPos;{$endif}                                name: 'FROMPOS';                     dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_toPos;{$endif}                                  name: 'TOPOS';                       dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_IsResExpanded;{$endif}                          name: 'ISRESEXPANDED';               dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_LineSeq;{$endif}                                name: 'LINE_SEQ';                    dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_AutomaticRunCode;{$endif}                       name: 'AUTO_RUN_CODE';               dom: dom_text40),
({$ifdef DEVELOP}fInfo: fli_LineNumber;{$endif}                             name: 'LINE_NUMBER';                 dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_OperationCode;{$endif}                          name: 'OPERATION_CODE';              dom: dom_smallChId),
({$ifdef DEVELOP}fInfo: fli_Bin;{$endif}                                    name: 'BIN';                         dom: dom_text40),
({$ifdef DEVELOP}fInfo: fli_Gantt;{$endif}                                  name: 'GANTT';                       dom: dom_text40),
({$ifdef DEVELOP}fInfo: fli_OperationDetail;{$endif}                        name: 'OPERATION_DETAILS';           dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_To_WorkStation;{$endif}                         name: 'TO_WK_STATION';               dom: dom_codeWS),
({$ifdef DEVELOP}fInfo: fli_From_WorkStation;{$endif}                       name: 'FROM_WK_STATION';             dom: dom_codeWS),
({$ifdef DEVELOP}fInfo: fli_Messages;{$endif}                               name: 'MESSAGES';                    dom: dom_Text1024),
({$ifdef DEVELOP}fInfo: fli_DateTime;{$endif}                               name: 'DATE_TIME';                   dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_Status;{$endif}                                 name: 'STATUS';                      dom: dom_Info),
({$ifdef DEVELOP}fInfo: fli_JobMsgEvent;{$endif}                            name: 'JOB_MSG_EVNT';                dom: dom_Info),

({$ifdef DEVELOP}fInfo: fli_CodeRuleForGrouping;{$endif}                    name: 'CODE';                        dom: dom_CodeGrpByPropRule),
({$ifdef DEVELOP}fInfo: fli_PropertyCode1;{$endif}                          name: 'PropertyCode1';               dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropertyCode2;{$endif}                          name: 'PropertyCode2';               dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropertyCode3;{$endif}                          name: 'PropertyCode3';               dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropertyCode4;{$endif}                          name: 'PropertyCode4';               dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropertyCode5;{$endif}                          name: 'PropertyCode5';               dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropertyCode6;{$endif}                          name: 'PropertyCode6';               dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropertyCode7;{$endif}                          name: 'PropertyCode7';               dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropertyCode8;{$endif}                          name: 'PropertyCode8';               dom: dom_PropertyCode),

({$ifdef DEVELOP}fInfo: fli_TimeType;{$endif}                               name: 'TIME_TYPE';                   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StartingDateColumn;{$endif}                     name: 'STARTING_DATE_COLUMN';        dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PropertyDateColumn;{$endif}                     name: 'PROPERTY_DATE_COLUMN';        dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_BinDateColumn;{$endif}                          name: 'BIN_DATE_COLUMN';             dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_ABSolute_Value;{$endif}                         name: 'ABSOLUTE_VALUE';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ColumnNum;{$endif}                              name: 'COLUMN_NUM';             dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_MailGroupName;{$endif}                          name: 'MAIL_GROUP_NAME';             dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_User_Id;{$endif}                                name: 'USER_ID';                     dom: dom_text120),
({$ifdef DEVELOP}fInfo: fli_Password;{$endif}                               name: 'Password';                    dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_Recipient;{$endif}                              name: 'Recipient';                   dom: dom_Text1024),
({$ifdef DEVELOP}fInfo: fli_Lic;{$endif}                                    name: 'LIC_STR';                     dom: dom_text1024),
({$ifdef DEVELOP}fInfo: fli_LicUpd;{$endif}                                 name: 'LIC_STR_UPD';                 dom: dom_text1024),
({$ifdef DEVELOP}fInfo: fli_Ver;{$endif}                                    name: 'VER_NUM';                     dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_LAST_UPD;{$endif}                               name: 'LAST_UPD';                    dom: dom_intCode), //smallint - Vince
({$ifdef DEVELOP}fInfo: fli_SL_OP;{$endif}                                  name: 'SL_OP';                       dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_SL_ON;{$endif}                                  name: 'SL_ON';                       dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_CONNECT;{$endif}                                name: 'CONNECT';                     dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_OP;{$endif}                                     name: 'OP';                          dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_POLL;{$endif}                                   name: 'POLL';                        dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_COUNTER;{$endif}                                name: 'COUNTER';                     dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_MachineNumber;{$endif}                          name: 'MacNumber';                     dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_Mach_stp_code_lvl;{$endif}                      name: 'MACH_SETUP_CODE_LEVEL';       dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_SequenceDepend;{$endif}                         name: 'SEQ_DEPEND';                  dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_PriorityRelation;{$endif}                       name: 'PRIORITY_RALATION';           dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_ResCatcode;{$endif}                             name: 'RES_CAT_CODE';                dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_Desc;{$endif}                                   name: 'DESCRIPTION';                 dom: dom_Info),
({$ifdef DEVELOP}fInfo: fli_ResSetupCode;{$endif}                           name: 'RES_SETUP_CODE';              dom: dom_ProdReq),
({$ifdef DEVELOP}fInfo: fli_SchedWkc;{$endif}                               name: 'SCHED_WKC';                   dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_SchedWkCtrProc;{$endif}                         name: 'SCHED_WKC_PROC';              dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_DependOn;{$endif}                               name: 'DEPEND_ON';                   dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_DepIsSchedRscCat;{$endif}                       name: 'DEP_IS_SCHD_RSC_CAT';         dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_DepIsSchedWkc;{$endif}                          name: 'DEP_IS_SCHD_WKC';             dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_DepIsSchedRsc;{$endif}                          name: 'DEP_IS_SCHD_RSC';             dom: dom_CodeRes),
({$ifdef DEVELOP}fInfo: fli_NoSchedRscCat;{$endif}                          name: 'NO_SCHED_RSC_CAT';            dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_NoSchedWkc;{$endif}                             name: 'NO_SCHED_WKC';                dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_NoSchedRsc;{$endif}                             name: 'NO_SCHED_RSC';                dom: dom_CodeRes),
({$ifdef DEVELOP}fInfo: fli_highDateAlloc;{$endif}                          name: 'HIGH_DATE_ALLOC';             dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_SearchMatByAlloc;{$endif}                       name: 'SEARCH_MAT_ALLOC';            dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_settled;{$endif}                                name: 'SETTLED';                     dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_AllocQty;{$endif}                               name: 'QTY_ALLOC';                   dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_AllocQty_Mat;{$endif}                           name: 'QTY_ALLOC';                   dom: dom_quant_material),
({$ifdef DEVELOP}fInfo: fli_AllocReq;{$endif}                               name: 'ALLOC_REQ';                   dom: dom_ProdReq),
({$ifdef DEVELOP}fInfo: fli_Prod_Balance;{$endif}                           name: 'PROD_BALANCE';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_issueCode;{$endif}                              name: 'ISSUE_CODE';                  dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_quantityIssue;{$endif}                          name: 'QUANTITY_ISSUE';              dom: dom_quant_material),
({$ifdef DEVELOP}fInfo: fli_netGroupCode;{$endif}                           name: 'NET_GROUP_CODE';              dom: dom_codeNetGrp),
({$ifdef DEVELOP}fInfo: fli_ProdCode;{$endif}                               name: 'PRODUCT_CODE';                dom: dom_text120),
({$ifdef DEVELOP}fInfo: fli_IssueItemType;{$endif}                          name: 'ISSUE_ITEM_TYPE';             dom: dom_codeNetGrp),
({$ifdef DEVELOP}fInfo: fli_AWHAltern_Net_Group_Code;{$endif}               name: 'ALTERN_NET_GROUP_CODE';       dom: dom_text120),
({$ifdef DEVELOP}fInfo: fli_orgStep;{$endif}                                name: 'ORG_STEP';                    dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_reqQuant;{$endif}                               name: 'REQ_QUANTITY';                dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_reqQuant_mat;{$endif}                           name: 'REQ_QUANTITY';                dom: dom_quant_material),
({$ifdef DEVELOP}fInfo: fli_seqIssued;{$endif}                              name: 'SEQ_ISSUED';                  dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_MatBalance;{$endif}                             name: 'MAT_BALANCE';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MachSetupCode;{$endif}                          name: 'MACHINE_SETUP_CODE';          dom: dom_text10),
({$ifdef DEVELOP}fInfo: fli_AlternativCode;{$endif}                         name: 'ALTERNATIVE_CODE';            dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_searchBalance;{$endif}                          name: 'SEARCH_BALANCE';              dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_waitEntireMat;{$endif}                          name: 'WAIT_ENTIRE_MAT';             dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_issueTransType;{$endif}                         name: 'ISSUE_TRANS_MAT';             dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_updReqHrs;{$endif}                              name: 'UPD_REQ_HRS';                 dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MatProdType;{$endif}                            name: 'MAT_PROD_TYPE';               dom: dom_ProdType),
({$ifdef DEVELOP}fInfo: fli_waitPrevQty;{$endif}                            name: 'WAIT_PREV_QTY';               dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_MinQtyPassNxt;{$endif}                          name: 'MIN_QTY_PASS_NXT';            dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_MinQtyPrevStp;{$endif}                          name: 'MIN_QTY_PREV_STP';            dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_MinDelWaitDays;{$endif}                         name: 'MIN_DEL_WAIT_DAYS';           dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MinDelWaitHrs;{$endif}                          name: 'MIN_DEL_WAIT_HRS';            dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MinDelWaitMin;{$endif}                          name: 'MIN_DEL_WAIT_MIN';            dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MaxDelWaitDays;{$endif}                         name: 'MAX_DEL_WAIT_DAYS';           dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MaxDelWaitHrs;{$endif}                          name: 'MAX_DEL_WAIT_HRS';            dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MaxDelWaitMin;{$endif}                          name: 'MAX_DEL_WAIT_MIN';            dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PartDel;{$endif}                                name: 'PART_DEL';                    dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_UpdBalHrs;{$endif}                              name: 'UPD_BAL_HRS';                 dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_UpdBalQty;{$endif}                              name: 'UPD_BAL_QTY';                 dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_UpdReqPrevStpHrs;{$endif}                       name: 'UPD_REQ_PREV_STP_HRS';        dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_qtyProduced;{$endif}                            name: 'QTY_PRODUCED';                dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_sequenceChar;{$endif}                           name: 'SEQUENCE';                    dom: dom_ProdType),
({$ifdef DEVELOP}fInfo: fli_ProductNature;{$endif}                          name: 'PRODUT_NATURE';               dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_occupyCode;{$endif}                             name: 'OCCUPY_CODE';                 dom: dom_txt20),
({$ifdef DEVELOP}fInfo: fli_StartConsumPoint;{$endif}                       name: 'STR_CONS_POINT';              dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_EndConsumPoint;{$endif}                         name: 'END_CONS_POINT';              dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_HoursToDownFromMachine;{$endif}                 name: 'HOURSTODOWNFROMMACHINE';      dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MaterialSchedule;{$endif}                       name: 'Mat_Schedule_Type';           dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_MaterialStandardSetupMinutes;{$endif}           name: 'Mat_Standard_SetMin';         dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_MaterialStandardSpeed;{$endif}                  name: 'Mat_Standard_Speed';          dom: dom_speed),
({$ifdef DEVELOP}fInfo: fli_Sub_Detail;{$endif}                             name: 'Sub_Detail';                  dom: dom_text40),
({$ifdef DEVELOP}fInfo: fli_Detail_Code;{$endif}                            name: 'Detail_Code';                 dom: dom_Text15),
({$ifdef DEVELOP}fInfo: fli_OverridenSpeed;{$endif}                         name: 'OverridenSpeed';              dom: dom_speed),
({$ifdef DEVELOP}fInfo: fli_OverridenSetupTime;{$endif}                     name: 'OverridenSetupTime';          dom: dom_speed),
({$ifdef DEVELOP}fInfo: fli_FirstJobQuantityIncluded;{$endif}               name: 'FirstJobQuantityIncluded';    dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_LastJobQuantityIncluded;{$endif}                name: 'LastJobQuantityIncluded';     dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_HostItemIndentifier;{$endif}                    name: 'HostItemIndentifier';         dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_HostWarehouse;{$endif}                          name: 'HostWarehouse';               dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_SubDetailHostType;{$endif}                      name: 'SubDetailHostType';           dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_DetailCodeType;{$endif}                         name: 'DetailCodeType';              dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_Environment;{$endif}                            name: 'Environment';                 dom: dom_txt3),
({$ifdef DEVELOP}fInfo: fli_CompanyCode;{$endif}                            name: 'CompanyCode';                 dom: dom_txt3),
({$ifdef DEVELOP}fInfo: fli_CounterCode;{$endif}                            name: 'CounterCode';                 dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_Code;{$endif}                                   name: 'Code';                        dom: dom_Text15),
({$ifdef DEVELOP}fInfo: fli_Reservationline;{$endif}                        name: 'Reservationline';             dom: dom_Text7),
({$ifdef DEVELOP}fInfo: fli_NettedQuantity;{$endif}                         name: 'NETTED_QUANTITY';             dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_ChangedQuantity;{$endif}                        name: 'CHANGED_QUANTITY';            dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_downloadType;{$endif}                           name: 'DOWNLOAD_TYPE';               dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_downloadTime;{$endif}                           name: 'DOWNLOAD_DATE_TIME';          dom: dom_timing),
// DB TEMP
//({$ifdef DEVELOP}fInfo: fli_simWkstCode;{$endif}                            name: 'WKST_CODE';                   dom: dom_codeWS),
//({$ifdef DEVELOP}fInfo: fli_simCode;{$endif}                                name: 'CODE';                        dom: dom_codeWS),
//({$ifdef DEVELOP}fInfo: fli_simDesc;{$endif}                                name: 'DESC';                        dom: dom_text35),
//({$ifdef DEVELOP}fInfo: fli_simUsrTmCr;{$endif}                             name: 'DT_CREATE';                   dom: dom_timing),
//({$ifdef DEVELOP}fInfo: fli_simUsrTmCg;{$endif}                             name: 'DT_CHANGE';                   dom: dom_timing),
//({$ifdef DEVELOP}fInfo: fli_simActive;{$endif}                              name: 'ACTIVE';                      dom: dom_flag),

//DBReport
//({$ifdef DEVELOP}fInfo: fli_AWCLDescr;{$endif}                              name: 'AWCL_DESCR';                   dom: dom_text30),
//({$ifdef DEVELOP}fInfo: fli_APRLDescr;{$endif}                              name: 'APRL_DESCR';                   dom: dom_text30),
//({$ifdef DEVELOP}fInfo: fli_PWCLDescr;{$endif}                              name: 'PWCL_DESCR';                   dom: dom_text30),
//({$ifdef DEVELOP}fInfo: fli_PPRLDescr;{$endif}                              name: 'PPRL_DESCR';                   dom: dom_text30),
//({$ifdef DEVELOP}fInfo: fli_PTLDescr;{$endif}                               name: 'PTLL_DESCR';                   dom: dom_text30),
//({$ifdef DEVELOP}fInfo: fli_UMLDescr;{$endif}                               name: 'UML_DESCR';                    dom: dom_text30),
//({$ifdef DEVELOP}fInfo: fli_RSLDescr;{$endif}                               name: 'RSL_DESCR';                    dom: dom_text30),
//({$ifdef DEVELOP}fInfo: fli_ARSLDescr;{$endif}                              name: 'ARSL_DESCR';                   dom: dom_text30),
//({$ifdef DEVELOP}fInfo: fli_PlanWkctCode;{$endif}                           name: 'PLAN_WKCT_CODE';               dom: dom_CodeWrcr),
//({$ifdef DEVELOP}fInfo: fli_PlanWkctProc;{$endif}                           name: 'PLAN_WKCT_PROC';               dom: dom_CodeWrcr),
//({$ifdef DEVELOP}fInfo: fli_ProdLineLDescr;{$endif}                         name: 'PROD_LNL_DESCR';               dom: dom_text30),
//({$ifdef DEVELOP}fInfo: fli_ProgRsc;{$endif}                                name: 'PROG_RSC_CODE';                dom: dom_longChId),
//({$ifdef DEVELOP}fInfo: fli_LowestPlanStart;{$endif}                        name: 'LOW_PLAN_LIMIT_TIME_STRT';     dom: dom_timing),
//({$ifdef DEVELOP}fInfo: fli_Desc_Prog_Type;{$endif}                         name: 'DESC_PROG_TYPE';               dom: dom_Info),
//({$ifdef DEVELOP}fInfo: fli_SchedID;{$endif}                                name: 'SCHED_ID';                     dom: dom_longId),
//({$ifdef DEVELOP}fInfo: fli_DescArt;{$endif}                                name: 'DESC_ART';                     dom: dom_Info),
//({$ifdef DEVELOP}fInfo: fli_MatCode;{$endif}                                name: 'MAT_CODE';                     dom: dom_Info),
//({$ifdef DEVELOP}fInfo: fli_BinSel;{$endif}                                 name: 'BIN_SEL';                      dom: dom_flag),

({$ifdef DEVELOP}fInfo: fli_ToolBarDock;{$endif}                            name: 'ToolBarDock';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ToolBarLeft ;{$endif}                           name: 'ToolBarLeft';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ToolBarTop;{$endif}                             name: 'ToolBarTop';                   dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ToolBarWidth;{$endif}                           name: 'ToolBarWidth';                 dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ToolBarHeight;{$endif}                          name: 'ToolBarHeight';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ToolBarState ;{$endif}                          name: 'ToolBarState';                 dom: dom_intCode),
//AutoSchedCfg
({$ifdef DEVELOP}fInfo: fli_CfgName;{$endif}                                name: 'CfgName';                      dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_CfgDesc;{$endif}                                name: 'CfgDesc';                      dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_MinJobResComp;{$endif}                          name: 'MinJobResComp';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MinJobJobComp;{$endif}                          name: 'MinJobJobComp';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MaxJobJobComp;{$endif}                          name: 'MaxJobJobComp';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MinJobCapResComp;{$endif}                       name: 'MinJobCapResComp';             dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_IgnorMaterialCheck;{$endif}                     name: 'Ignor_Mat_Check';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_CfgNextName;{$endif}                            name: 'CfgNextName';                  dom: dom_txt14),


//({$ifdef DEVELOP}fInfo: fli_DateWgth;{$endif}                               name: 'DateWgth';                     dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_JobResCompWgth;{$endif}                         name: 'JobResCompWgth';               dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_JobJobCompWgth;{$endif}                         name: 'JobJobCompWgth';               dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_JobCapResCompWgth;{$endif}                      name: 'JobCapResCompWgth';            dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_JobSetupChange;{$endif}                         name: 'JobSetupChange';               dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_AfterDelDate;{$endif}                           name: 'AfterDelDate';                 dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_TollAfterDelDate;{$endif}                       name: 'TollAfterDelDate';             dom: dom_intCode),

({$ifdef DEVELOP}fInfo: fli_LimitGapBtwnSubSteps;{$endif}                   name: 'LimitGapBtwnSubSteps';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ToleranceDaysGapBtwnSubSteps;{$endif}           name: 'TolDaysGapBtwSubSteps';        dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ToleranceHoursGapBtwnSubSteps;{$endif}          name: 'TolHoursGapBtwnSubSteps';      dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ToleranceMinGapBtwnSubSteps;{$endif}            name: 'TolMinGapBtwnSubSteps';        dom: dom_intCode),

({$ifdef DEVELOP}fInfo: fli_AfterHighLimit;{$endif}                         name: 'AfterHighLimit';               dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollAfterHighLimit;{$endif}                     name: 'TollAfterHighLimit';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollAfterHighLimitHours;{$endif}                name: 'TollAfterHighLimitHours';      dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollAfterHighLimitMinutes;{$endif}              name: 'TollAfterHighLimitMinutes';    dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_BeforeLowLimit;{$endif}                         name: 'BeforeLowLimit';               dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollBeforeLowLimit;{$endif}                     name: 'TollBeforeLowLimit';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollBeforeLowLimitHours;{$endif}                name: 'TollBeforeLowLimitHours';      dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollBeforeLowLimitMinutes;{$endif}              name: 'TollBeforeLowLimitMinutes';    dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_LoadedResource;{$endif}                         name: 'Loadedresource';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_LoadedOnSameResCat;{$endif}                     name: 'LoadedOnSameResCat';           dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StopOnFirstNotSchedJob;{$endif}                 name: 'StopOnFirstNotSchedJob';       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_SortBeforeSchedule;{$endif}                     name: 'SortBeforeSchedule';           dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_BinColField1;{$endif}                           name: 'BinSortFieldId1';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_BinColField2;{$endif}                           name: 'BinSortFieldId2';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_BinColField3;{$endif}                           name: 'BinSortFieldId3';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_BinColField4;{$endif}                           name: 'BinSortFieldId4';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_BinColField5;{$endif}                           name: 'BinSortFieldId5';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PrefTgtDate;{$endif}                            name: 'PrefTgtDate';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled;{$endif}    name: 'PrvOrNxtLinkedJobTgtDate'; dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MoveObjsAllowed;{$endif}                        name: 'MoveObjsAllowed';              dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MoveFinalObjsAlwd;{$endif}                      name: 'MoveFinalObjsAlwd';            dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_AutoSplitByStdBtchSize;{$endif}                 name: 'AutoSplitByStdBtchSize';       dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_LastSplitCanGoUnderMinMac;{$endif}              name: 'LastSplitCanGoUnderMinMac';    dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CreteriaOfResForBachZise;{$endif}               name: 'CreteriaOfResForBachZise';     dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MoveInitialObjsAlwd;{$endif}                    name: 'MoveInitialObjsAlwd';          dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MoveLevel1ObjsAlwd;{$endif}                     name: 'MoveLevel1ObjsAlwd';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MoveLevel2ObjsAlwd;{$endif}                     name: 'MoveLevel2ObjsAlwd';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MoveLevel3ObjsAlwd;{$endif}                     name: 'MoveLevel3ObjsAlwd';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MoveLevel4ObjsAlwd;{$endif}                     name: 'MoveLevel4ObjsAlwd';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MoveLevel5ObjsAlwd;{$endif}                     name: 'MoveLevel5ObjsAlwd';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MinStartDateOffset;{$endif}                     name: 'MinStartDateOffset';           dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_GradBfrTollLSD;{$endif}                         name: 'GradBfrTollLSD';               dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_GradBtwToll_LSD;{$endif}                        name: 'GradBtwToll_LSD';              dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_GradBtwLSD_TGTD;{$endif}                        name: 'GradBtwLSD_TGTD';              dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_GradBtwTGTD_HED;{$endif}                        name: 'GradBtwTGTD_HED';              dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_GradBtwHED_Toll;{$endif}                        name: 'GradBtwHED_Toll';              dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_GradBtwTollHED_Del;{$endif}                     name: 'GradBtwTollHED_Del';           dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_GradBtwDel_Toll;{$endif}                        name: 'GradBtwDel_Toll';              dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_GradAftTollDel;{$endif}                         name: 'GradAftTollDel';               dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_PriorErrLoop;{$endif}                           name: 'PriorErrLoop';                 dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_TempFinal;{$endif}                              name: 'TempFinal';                    dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_Sleep;{$endif}                                  name: 'Sleep';                        dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_RankRep;{$endif}                                name: 'RankRep';                      dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_GroupAllowOneJob;{$endif}                       name: 'GroupAllowOneJob';             dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_MatWOMaterials;{$endif}                         name: 'MatWOMaterials';               dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_OneRequestAtTime;{$endif}                       name: 'OneStepAtTime';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MatLinkReq;{$endif}                             name: 'MatLinkReq';                   dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MatWOAddRes;{$endif}                            name: 'MatWOAddRes';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CompactEntities;{$endif}                        name: 'CompactEntities';              dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_NextDays;{$endif}                               name: 'NextDays';                     dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_GraphOnMove;{$endif}                            name: 'GraphOnMove';                  dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_StdPurcOrProdTime;{$endif}                      name: 'StdPurcOrProdTime';            dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_ModuleRule;{$endif}                             name: 'ModuleRule';                   dom: dom_Type),
//({$ifdef DEVELOP}fInfo: fli_MCM_RequestType;{$endif}                        name: 'MCM_RequestType';              dom: dom_Type),
//({$ifdef DEVELOP}fInfo: fli_MCM_CapacitySearch;{$endif}                     name: 'MCM_CapacitySearch';           dom: dom_Type),
//({$ifdef DEVELOP}fInfo: fli_MCM_MaterialSearch;{$endif}                     name: 'MCM_MaterialSearch';           dom: dom_Type),
//({$ifdef DEVELOP}fInfo: fli_MCM_RequestedDate;{$endif}                      name: 'MCM_RequestedDate';            dom: dom_timing),
//({$ifdef DEVELOP}fInfo: fli_MCM_RequestedDateType;{$endif}                  name: 'MCM_RequestedDateType';        dom: dom_type),
//({$ifdef DEVELOP}fInfo: fli_MCM_Priority;{$endif}                           name: 'MCM_Priority';                 dom: dom_shtstId),
//({$ifdef DEVELOP}fInfo: fli_MCM_LoaderDays;{$endif}                         name: 'MCM_LoaderDays';               dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_WorkStationType;{$endif}                        name: 'WorkStationType';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_Category;{$endif}                               name: 'Category';                     dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_MixRegroups;{$endif}                            name: 'MixReGroups';                  dom: dom_Mixregrp),
({$ifdef DEVELOP}fInfo: fli_NumOfMachines;{$endif}                          name: 'Num_Of_Machines';              dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_CompCaseNum;{$endif}                            name: 'CompCaseNum';                  dom: dom_CompCaseNum),
({$ifdef DEVELOP}fInfo: fli_DaysPanelty;{$endif}                            name: 'DaysPanelty';                  dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_FiniteCapacity;{$endif}                         name: 'FiniteCapacity';               dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MQMRelevance;{$endif}                           name: 'MQMRelevance';                 dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_MCMRelevance;{$endif}                           name: 'MCMRelevance';                 dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_SchedulByMcm;{$endif}                           name: 'SCHDULE_BY_MCM';               dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_SchedulByMqm;{$endif}                           name: 'SCHDULE_BY_MQM';               dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_ModulHandled;{$endif}                           name: 'ModuleHandle';                 dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_StartDownloadDateTime;{$endif}                  name: 'Start_Download_time';          dom: dom_timing),
//AutoSchedCfg New fileds
({$ifdef DEVELOP}fInfo: fli_StandardSlotDuration;{$endif}                   name: 'Standard_Slot_Dur';            dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_SortResource;{$endif}                           name: 'Sort_Res';                     dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_ResourceToSchedule;{$endif}                     name: 'Res_ToSched';                  dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_AllowSchedBeforeNoneConfLevl;{$endif}           name: 'AllowSchedBeforeNoneCnfLvl';   dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_BefEarlDateTol;{$endif}                         name: 'BefEarlDateTol';               dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_WithEarlDateTol;{$endif}                        name: 'WithEarlDateTol';              dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_AfterLatDateTol;{$endif}                        name: 'AfterLatDateTol';              dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_WithLatDateTol;{$endif}                         name: 'WithLatDateTol';               dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_ScheduleToPossibleStartPenalty;{$endif}         name: 'SchedToPosibleStartPenalty'; dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_CfgGroup;{$endif}                               name: 'Cfg_Group';                    dom: dom_text10),
({$ifdef DEVELOP}fInfo: fli_AutoSeq_RunningMode;{$endif}                    name: 'Running_Mode';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StartSchedFrom;{$endif}                         name: 'Start_Sched_From';             dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StartSched_SpecificDateTime;{$endif}            name: 'Specific_DateTime';            dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_StartSched_NumberOfDaysFromCurrentDate;{$endif} name: 'Num_Days_From_Current';dom:    dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PenJobToJob;{$endif}                            name: 'PenJobToJob';                  dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PenSetupMin;{$endif}                            name: 'PenSetupMin';                  dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PenJobToRes;{$endif}                            name: 'PenJobToRes';                  dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PenJobToCapRes;{$endif}                         name: 'PenJobToCapRes';               dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PenJobNotCapRes;{$endif}                        name: 'PenJobNotCapRes';              dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_DateScoreWeight;{$endif}                        name: 'DateScoreWeight';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_CompScoreWeight;{$endif}                        name: 'CompScoreWeight';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_HoursToleranceOfGapBetweenJobs;{$endif}         name: 'HoursToleranceOfGapBtwJobs';   dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_RescheduleErlierJobsWhenTolerance;{$endif}      name: 'ReschedErlierJobsWhenTolrc';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PenaltyScoreWithinTolerance;{$endif}            name: 'PenaltyScoreBeforeToleranc';    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PenaltyScoreAfterTolerance;{$endif}             name: 'PenaltyScoreAfterTolerance';   dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_IgnoreRightOverlapping;{$endif}                 name: 'IgnoreRightOverlapping';       dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_IgnoreLeftOverlapping;{$endif}                  name: 'IgnoreLeftOverlapping';        dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_LatestDateLimit;{$endif}                        name: 'LatestDateLimit';              dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_DateLimitType;{$endif}                          name: 'DateLimitType';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_NumberOfdaysFromStartingPoint;{$endif}          name: 'NumOfdaysFromStartPoint';      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_DateFromStartPointAllowed;{$endif}              name: 'DateFromStartPointALLOW';      dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_forceSameWcPlantToServingGroup;{$endif}         name: 'SameWcPlantToServingGroup';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_CalendarForDatesPenalty;{$endif}                name: 'CalendarForDatesPenalty';      dom: Dom_Cal),
({$ifdef DEVELOP}fInfo: fli_SubCategory;{$endif}                            name: 'SUBCATEGORY';                  dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_SubCategoryDesc;{$endif}                        name: 'SUBCATDESC';                   dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PROGR;{$endif}                                  name: 'PROGR';                        dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_DELTAPERC;{$endif}                              name: 'DELTAPERC';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_CONFLEV;{$endif}                                name: 'CONFLEV';                      dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_MCMREQGROUP;{$endif}                            name: 'MCMREQGROUP';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FIRSTPRIORITY;{$endif}                          name: 'FIRSTPRIORITY';                dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_SECPRIORITY;{$endif}                            name: 'SECPRIORITY';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_WRITTENBY;{$endif}                              name: 'WRITTENBY';                    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_QUEUE_STATUS;{$endif}                           name: 'STATUS';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ERRORTXT;{$endif}                               name: 'ERRORTXT';                     dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_PRIORITY;{$endif}                               name: 'PRIORITY';                     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PROPVALUEFROM;{$endif}                          name: 'PROPVALUEFROM';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_PROPVALUETO;{$endif}                            name: 'PROPVALUETO';                  dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_LearningCurveDesc;{$endif}                      name: 'LEARNING_CURVE_DESC';          dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_CurveFirstHours;{$endif}                        name: 'CURVE_FIRST_HOURS';            dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveFirstEffic;{$endif}                        name: 'CURVE_FIRST_EFFIC';            dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveSecondHours;{$endif}                       name: 'CURVE_SECOND_HOURS';           dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveSecondEffic;{$endif}                       name: 'CURVE_SECOND_EFFIC';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveThirdHours;{$endif}                        name: 'CURVE_THIRD_HOURS';            dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveThirdEffic;{$endif}                        name: 'CURVE_THIRD_EFFIC';            dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveForthHours;{$endif}                        name: 'CURVE_FORTH_HOURS';            dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveForthEffic;{$endif}                        name: 'CURVE_FORTH_EFFIC';            dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveFifthhHours;{$endif}                       name: 'CURVE_FIFTH_HOURS';            dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveFifthEffic;{$endif}                        name: 'CURVE_FIFTH_EFFIC';            dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveSixthHours;{$endif}        name: 'CURVE_SIXTH_HOURS';      dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveSixthEffic;{$endif}        name: 'CURVE_SIXTH_EFFIC';      dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveSevenThHours;{$endif}      name: 'CURVE_SEVENTH_HOURS';    dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveSevenThEffic;{$endif}      name: 'CURVE_SEVENTH_EFFIC';    dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveEighthHours;{$endif}       name: 'CURVE_EIGHTH_HOURS';     dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveEighthEffic;{$endif}       name: 'CURVE_EIGHTH_EFFIC';     dom: dom_intCode),

//tbl_ItemsStock,

({$ifdef DEVELOP}fInfo: fli_ItemType;          {$endif}                     name: 'ITEMTYPE';                     dom: dom_ProdType),
({$ifdef DEVELOP}fInfo: fli_Stock;          {$endif}                        name: 'STOCK';                        dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_ItemCode;   {$endif}                            name: 'ITEMCODE';                     dom: dom_text120),
({$ifdef DEVELOP}fInfo: fli_Date;   {$endif}                                name: 'DATE';                         dom: dom_timing),

//tbl_ItemsStockExceptions,

({$ifdef DEVELOP}fInfo: fli_DayInWeek;       {$endif}                       name: 'DAYINWEEK';                    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_fromTime;       {$endif}                        name: 'FROMTIME';                     dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_ToTime;         {$endif}                        name: 'TOTIME';                       dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_StockDifference;  {$endif}                      name: 'STOCKDIFFERENCE';              dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_ToDateLimit;  {$endif}                          name: 'TODATELIMIT';                  dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_NumberOfHours;  {$endif}                        name: 'NUMBEROFHOURS';                dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_Color;  {$endif}                                name: 'COLOR';                        dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_NumberOfScheduleCounter;{$endif}                name: 'NUM_SCHED_COUNTER';            dom: dom_shortId),

({$ifdef DEVELOP}fInfo: fli_Details;{$endif}                                name: 'DETAILS';                      dom: dom_text120),
({$ifdef DEVELOP}fInfo: fli_used;{$endif}                                   name: 'USED';                         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_BalanceIdentifier;{$endif}                      name: 'BALANCEID';                    dom: dom_longId),

// AutoSeq_ScoreAddition,
({$ifdef DEVELOP}fInfo: fli_From_Job_to_Prior_Job_case;{$endif}             name: 'From_Job_to_Prior_Job_case';   dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_To_Job_to_Prior_Job_case;{$endif}               name: 'To_Job_to_Prior_Job_case';     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_From_Job_to_Follow_Job_case;{$endif}            name: 'From_Job_to_Follow_Job_case';  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_To_Job_to_Follow_Job_case;{$endif}              name: 'To_Job_to_Follow_Job_case';    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_From_Job_to_resource_case;{$endif}              name: 'From_Job_to_resource_case';    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_To_Job_to_resource_case;{$endif}                name: 'To_Job_to_resource_case';      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_From_number_of_days_delay;{$endif}              name: 'From_number_of_days_delay';    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_To_number_of_days_delay;{$endif}                name: 'To_number_of_days_delay';      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_From_number_of_days_early;{$endif}              name: 'From_number_of_days_early';    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_To_number_of_days_early;{$endif}                name: 'To_number_of_days_early';        dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_From_number_minutes_setup_add;{$endif}          name: 'From_number_mints_setup_add';  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_To_number_minutes_setup_add;{$endif}            name: 'To_number_mints_setup_add';    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Add_to_score;{$endif}                           name: 'Add_to_score';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Double_Direction;{$endif}                       name: 'Double_direction';             dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_From_Case;{$endif}                              name: 'FROM_CASE';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_ToCase;{$endif}                                 name: 'TO_CASE';                      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_LogOrigin;{$endif}                              name: 'LOG_ORIGIN';                   dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_ScheduleInfo;{$endif}                           name: 'SCHEDULE_INFO';                dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_reason;{$endif}                                 name: 'REASON';                       dom: dom_text250),
({$ifdef DEVELOP}fInfo: fli_speed;{$endif}                                  name: 'SPEED';                        dom: dom_speed),
({$ifdef DEVELOP}fInfo: fli_setup;{$endif}                                  name: 'SETUP';                        dom: dom_speed),

//Material_Tollerance_Types
({$ifdef DEVELOP}fInfo: fli_Material_Tollerance_Types_Code;{$endif}         name: 'MATERIAL_TOLLERANCE_CODE';     dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_Material_Tollerance_Types_Desc;{$endif}         name: 'DESCR';                        dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_TillQty1;{$endif}                               name: 'TillQty1';                     dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_TillQty1Percent;{$endif}                        name: 'TillQty1Percent';              dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TillQty2;{$endif}                               name: 'TillQty2';                     dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_TillQty2Percent;{$endif}                        name: 'TillQty2Percent';              dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TillQty3;{$endif}                               name: 'TillQty3';                     dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_TillQty3Percent;{$endif}                        name: 'TillQty3Percent';              dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TillQty4;{$endif}                               name: 'TillQty4';                     dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_TillQty4Percent;{$endif}                        name: 'TillQty4Percent';              dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TillQty5;{$endif}                               name: 'TillQty5';                     dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_TillQty5Percent;{$endif}                        name: 'TillQty5Percent';              dom: dom_intCode),

// Filters

({$ifdef DEVELOP}fInfo: fli_Id;{$endif}                                     name: 'ID';                          dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_CTABLE;{$endif}                                 name: 'CTABLE';                      dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_BACTIVE;{$endif}                                name: 'BACTIVE';                     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_CSQL;{$endif}                                   name: 'CSQL';                        dom: dom_Text2000),
({$ifdef DEVELOP}fInfo: fli_CLOCK;{$endif}                                  name: 'CLOCK';                       dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_CCAPTION;{$endif}                               name: 'CCAPTION';                    dom: dom_text100),
// Filters_col

({$ifdef DEVELOP}fInfo: fli_ID_TABLE;{$endif}                               name: 'ID_TABLE';                    dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_CCOLUMN;{$endif}                                name: 'CCOLUMN';                     dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_CCOND;{$endif}                                  name: 'CCOND';                       dom: dom_Text4),
({$ifdef DEVELOP}fInfo: fli_CVALUES;{$endif}                                name: 'CVALUES';                     dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_BVISIBLE;{$endif}                               name: 'BVISIBLE';                    dom: dom_shortId),

// TotalsView

({$ifdef DEVELOP}fInfo: fli_TotalCode;{$endif}                              name: 'Code';                        dom: dom_text10),
({$ifdef DEVELOP}fInfo: fli_OwnerWorkStation;{$endif}                       name: 'OwnerWorkStation';            dom: dom_text10),

//TotalsViewContent
({$ifdef DEVELOP}fInfo: fli_ArgumentNumber;{$endif}                         name: 'ArgumentNumber';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Attribute;{$endif}                              name: 'Attribute';                   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_Formula;{$endif}                                name: 'Formula';                     dom: dom_Text15),
({$ifdef DEVELOP}fInfo: fli_NumberOfDecimals;{$endif}                       name: 'NumberOfDecimals';            dom: dom_shortId),

({$ifdef DEVELOP}fInfo: fli_ABSUniqueID;{$endif}                            name: 'ABSUNIQUEID';                 dom: dom_BigInt),
({$ifdef DEVELOP}fInfo: fli_MenuCode;{$endif}                               name: 'MenuCode';                    dom: dom_Text50),
({$ifdef DEVELOP}fInfo: fli_MenuCaption;{$endif}                            name: 'MenuCaption';                 dom: dom_Text100),

// SavedPlanCopy
({$ifdef DEVELOP}fInfo: fli_BucketType;{$endif}                             name: 'Bucket_Type';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_BucketQty;{$endif}                              name: 'Bucket_Qty';                  dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_BucketDate;{$endif}                             name: 'Bucket_Date';                 dom: dom_timing),


//2nd warp level
({$ifdef DEVELOP}fInfo: fli_ItemType2;          {$endif}                     name: 'ITEMTYPE2';                     dom: dom_ProdType),
({$ifdef DEVELOP}fInfo: fli_ProdCode2;{$endif}                               name: 'PRODUCT_CODE2';                dom: dom_text120),

//mcmtabconfig
({$ifdef DEVELOP}fInfo: fli_SlotScnLevel;{$endif}                            name: 'SlotSecondLvl';               dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_WkcScnLevel;{$endif}                             name: 'WkcSecondLvl';                dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_IsSlotExpanded;{$endif}                          name: 'IsSlotExpanded';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_IsWkcExpanded;{$endif}                           name: 'IsWkcExpanded';               dom: dom_Type)
);

  typToStr : array[dbType] of string = (
    'SMALLINT',
    'INTEGER',
    'VARCHAR',
    'CHAR',
    'DATE',
    'TIMESTAMP',
    'DECIMAL',
    'BLOB',
    'INTEGER'
    );

  typToStrOracle : array[dbType] of string = (
    'NUMBER',
    'NUMBER',
    'VARCHAR',
    'CHAR',
    'DATE',
    'TIMESTAMP',
    'DECIMAL',
    'BLOB',
    'NUMBER'
    );

implementation

uses
  SysUtils, UMGlobal;

var
  s_pfx: string;

//----------------------------------------------------------------------------//

procedure SetFldPfx(pfx: string);
begin
  s_pfx := UpperCase(pfx)
end;

//----------------------------------------------------------------------------//

function CreateFldDef(pfx: string; fld: fldId): string;
begin
{$ifdef DEVELOP}
    Assert(fldInfo[fld].fInfo = fld);
{$endif}

  with domInfo[fldInfo[fld].dom] do
  begin
    if IniAppGlobals.DownloadTo = '1' then
      Result := pfx + fldInfo[fld].name + ' ' + typToStrOracle[typ]
    else
      Result := pfx + fldInfo[fld].name + ' ' + typToStr[typ];
    if len <> 0 then
      if dec = 0 then
        Result := Result + '(' + IntToStr(len) + ')'
      else
        Result := Result + '(' + IntToStr(len)+ ',' + IntToStr(dec) + ')';

    Result := UpperCase(result);
  end
end;

//----------------------------------------------------------------------------//

function CreateFld(pfx: string; fld: fldId): string;
begin
{$ifdef DEVELOP}
    Assert(fldInfo[fld].fInfo = fld);
{$endif}

  Result := UpperCase(pfx + fldInfo[fld].name);
end;

//----------------------------------------------------------------------------//

function CreatePfxFldDef(fld: fldId): string;
begin
  Result := CreateFldDef(s_pfx, fld)
end;

//----------------------------------------------------------------------------//

function CreatePfxFld(fld: fldId): string;
begin
  Result := CreateFld(s_pfx, fld)
end;

//----------------------------------------------------------------------------//

function CreateFldType(fld: fldId): string;
begin

  if IniAppGlobals.DownloadTo = '2' then
  begin
    with domInfo[fldInfo[fld].dom] do
    begin
      Result := typToStr[typ];
      if len <> 0 then
        if dec = 0 then
          Result := Result + '(' + IntToStr(len) + ')'
        else
          Result := Result + '(' + IntToStr(len)+ ',' + IntToStr(dec) + ')';

      Result := UpperCase(Result);
    end
  end
  else
  begin
    with domInfo[fldInfo[fld].dom] do
    begin
      if IniAppGlobals.DownloadTo = '1' then
        Result := typToStrOracle[typ]
      else
        Result := typToStr[typ];
      if Result = 'DECIMAL' then
      begin
        if len <> 0 then
          if dec = 0 then
            Result := Result + '(' + IntToStr(len) + ',' + IntToStr(0) + ')'
          else
            Result := Result + '(' + IntToStr(len)+ ',' + IntToStr(dec) + ')';
      end
      else
      begin
        if len <> 0 then
          if dec = 0 then
            Result := Result + '(' + IntToStr(len) + ')'
          else
            Result := Result + '(' + IntToStr(len)+ ',' + IntToStr(dec) + ')';
      end;
      Result := UpperCase(Result);
    end
  end;

end;

//----------------------------------------------------------------------------//

function DBopToChar(op: dbOp): string;
begin
  Result := ' ';
  case op of
  dbo_ins:  Result := 'I';
  dbo_del:  Result := 'D';
  dbo_modi: Result := 'M';
  end
end;

//----------------------------------------------------------------------------//

function CharToDBop(ch: string): dbOp;
begin
  if      ch = ' ' then
    Result := dbo_none
  else if ch = 'I' then
    Result := dbo_ins
  else if ch = 'D' then
    Result := dbo_del
  else
    Result := dbo_modi
end;

//----------------------------------------------------------------------------//

{ TTblInfo }

function TTblInfo.GetTableName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
  begin
    Result := IBName;
    exit
  end
  else
    Result := HostName;
end;

//----------------------------------------------------------------------------//

function TTblInfo.GetLicTableName(Cfg : boolean) : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
  begin
    Result := IBName;
    exit
  end
  else
  begin
    if Cfg then
      Result := 'SCDC_' + IBName
    else
      Result := 'SCDM_' + IBName
  end;

end;

initialization

  s_pfx := ''

//----------------------------------------------------------------------------//
end.











