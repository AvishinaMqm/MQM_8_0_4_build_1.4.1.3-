unit UMTblDesc;

interface

type

  dbOp = (dbo_none, dbo_ins, dbo_del, dbo_modi);

  dbType  = (db_short, db_int, db_varCh, db_ch, db_date, db_tmStp, db_dec);

  table   = (
             tbl_Archive_To_Host,
             tbl_addRes,
             tbl_wkc_alt,
             tbl_cfg_appGlob,
             tbl_cfg_appSettings,
             tbl_cfg_AutoSched,
             tbl_arty,
             tbl_cfg_bin_showProp,
             tbl_prop_capRes,
             tbl_capRes,
             tbl_capRes_Host,
             tbl_cfg_clrCapToJob,
             tbl_resCat,
             tbl_calendar,
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
             tbl_prod_info,
             tbl_wkc_prodLine,
             tbl_prop_prod,
             tbl_prod_req,
             tbl_prod_step,
             tbl_prod_reqHdr,
             tbl_prod_sched,
             tbl_prop,
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
             tbl_unit,
             tbl_wkc,
             tbl_wkc_proc,
             tbl_wkst,
             tbl_wkst_wkc,
             tbl_wkc_priority,
             //keep in alphabetical order!!!!!!!!

             tbl_cfg_text_display_set_fields,
             tbl_cfg_text_display_set_wkc,
             tbl_wkc_Change,
             tbl_Rsc_Change,
             tbl_Proc, // Matthias
             tbl_Cal,   // Matthias
      			 tbl_Licence,
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
             // DB TEMP
             tbl_mst_simulations,
             // DB for QEPORT
             tbl_report
             );

  domain  = (dom_ProdReq,   // Production Req cod   (12,A)
             dom_longId,    // long identifier      (11,0)
             dom_midId,     // medium identifier    (5,0)
             dom_shortId,   // short identifier     (3,0)
             dom_shtstId,   // shortest identifier  (2,0)
             dom_quant,     // quantity             (9,2)
             dom_longChId,  // character identifier (6A)
             dom_shortChId, // character identifier (4A)
             dom_code,      // workstation code     (10,A)
             dom_CodeWrcr,  // work center code     (5,A)
             dom_usr,       // user name            (10,A)
             Dom_Cal,       // Calander Code        (3,A)
             dom_durMin,    // duration in minutes  (9,2)
             dom_durMinMulti, // time multiplier    (9,4)
             dom_timing,    // timing information   (timestamp)
             dom_text30,    // 30 characters of text (30,A)
             dom_text35,    // 35 characters of text (35,A)
             dom_text40,    // 40 characters of text (40,A)
             dom_text50,    // 50 characters of text (50,A)
             dom_text110,   // 110 characters of text (110,A)
             dom_text250,   // 250 characters of text (250,A)
             dom_txt14,     // 14 characters of text (14,A)
             dom_txt20,     // 15 characters of text (20,A)
             dom_text10,    // 10 characters of text (10,A)
             dom_Info,      // 70 char Infor Area    (70,A)
             dom_family,    // 35 char Area          (35,A)
             dom_Category,  // Category Resource     (3,A)
             dom_intCode,   // integer code
             dom_Weight,    // Weight                (9,2)
             dom_UM,        // UM                    (2,A)
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
             dom_ConnKey,       // Connection key    (20,A)
             dom_NumOfLevel,    // Num of Level      (2,0)
             dom_NumRscComp,    // Num Rsc Comp      (5,0)
             dom_NumResPlan,    // Number Of Resource(9,3)
             dom_TimeSteps,     // Times steps       (11,3)
             dom_AddiCode,       // Additinal code    (5,A)
             dom_multiToBatchUm, // Multiplier to batch size UM (14,4)
             dom_flag,            // 1 char flag domain (1A)
{$ifdef ARO }
             dom_Text15,          // text 15
{$endif}
             dom_Text1024       // text 1024
            );

  fldId   =  (fli_ArtType,    fli_stGroup,  fli_ForcedGroup, fli_ForcedGroupNo, fli_StepIsGrouped ,
              fli_ConnForwardSubStep, fli_ConnForwardReProcess, fli_ConnBackwardSubStep,
              fli_ConnBackwardReProcess, fli_SaveAtLeastOnesAsFinnal,
              fli_quant,      fli_quantHost,    fli_subLinRscId, fli_Operation,
              fli_vers,       fli_rsc,          fli_rscHost,     fli_bch,        fli_usrCr,
              fli_usrTmCr,    fli_usrCg,        fli_usrTmCg,    fli_supMin,
              fli_exeMin,     fli_ColorIndex,    fli_schedStart,   fli_schedEnd,   fli_planStart,
              fli_schedType,  fli_planEnd,      fli_ganntStart, fli_ganntEnd,
              fli_preqNo,     fli_preqNo_From,   fli_PrevProdNum,  fli_preqStatus, fli_HistoriclReq, fli_ReqOrigin,
              fli_HistoriclData, fli_ProdUMCode,fli_ProdFamily,   fli_MaterialFamily, fli_um,
              fli_pstepId,    fli_pstepId_From, fli_infoLineNum,  fli_InfoArea,    fli_infoType,
              fli_ConnKey,    fli_ConnType,     fli_psubstId,   fli_psubstId_From, fli_NumOfLevel,
              fli_ConnLevel,  fli_ConnCertentyLevel, fli_DueDate, fli_reprocNo, fli_reprocNo_From , fli_wkcProc,
              fli_ProgressType, fli_Prog_Override_Type, fli_ProgressTypeHost, fli_progrStart, fli_progrStartHost , fli_progrEnd,
              fli_progrEndHost, fli_ProgressGroup, fli_prgCurrDate, fli_prgCurrDateHost, fli_prgRemTime, fli_prgRemTimeHost,
              fli_wkstCode, fli_wkDescr, fli_wkPasswd,  fli_wkCtrCode, fli_WCProcess,  //fli_OrgwkCtrCode,  fli_OrgWCProcess,
              fli_SchedwkCtrCode, fli_SchedWCProcess,  fli_wkCtrGroup, fli_TypOprtion, //fli_OrgSetup, fli_OrgExc,
              fli_TypProcess, fli_CalCod,       fli_TypeOfUse,  fli_SDescr,
              fli_LDescr, fli_Text,  fli_rscCat, fli_addiCode, fli_ConsumingZone,
              fli_ProcesType,  fli_Standrd_bch_Size,fli_BchUM,   fli_Min_bch_size,
              fli_Max_bch_Size,fli_rscType,     fli_NumOfRsc,   fli_TabsCode,
              fli_TabsDesc,   fli_ActiveOnPc,   fli_ToBeSched,  fli_splitNextStep,
              fli_StepType ,  fli_MaterialArrivDate, fli_prevStep , fli_SetUpTimJob,
              fli_FrcMatDate, fli_FrcLowestDate, fli_FrcHighestDate, fli_FrcOverlapp, fli_FrcDelDate, fli_ReactivateReq,
              fli_ExecTimeInitQty, fli_NextStep, fli_prevStepSched, fli_NextStepSched, fli_prevStepTrue, fli_NextStepTrue,
              fli_NextStepTimeLimit, fli_prevStepTimeLimit, fli_HighEndTimeLimit , fli_AllowSplit ,
              fli_LowStartTimeLimit, fli_ProdLowDataTime,  fli_ProdDelivDate,    fli_quantInit , fli_quantFinl,
              fli_Weight , fli_DescUM , fli_SetupTimStep,  fli_excTimeStep, fli_Visible,
              fli_NumResPlan, fli_Tbl_Name, fli_Tbl_Host,
              fli_CanStepOverlap, fli_CanOverlapNonWrkingHours, fli_MinQtyPassNextStp, fli_StepCanBeOverlapped, fli_StepHandleReProc,
              fli_StepPartGenralPlan, fli_STepCanGroup,
              fli_MinQtyToStart, fli_ConnTypToPrevStepSplit, fli_StepClosed, fli_OverlapQtyUM,
              fli_divCode, fli_dispoCode, fli_BinColField, fli_BinColTitle, fli_BinColPos,
              fli_BinColWidth, fli_BinColVisibl, fli_BinColOrder , fli_TabVis, fli_CategorySDesc,
              fli_CategoryLDesc, fli_Sequence, fli_SeqAlpha, fli_AlterWC,  fli_AlterWCProces, fli_DateBegin,
              fli_DateEnd, fli_ProdLine, fli_SubRsc, fli_NumSubRscComponents, fli_multipToBatchUm,
              fli_Comment, fli_PropertyCode, fli_PropSDesc, fli_PropLDesc , fli_PropType,
              fli_ChgPropValCauseResched,
              fli_DecNum, fli_CalDate, fli_Prog_Wrk_Hr, fli_ChangeType,
              fli_SH1_start, fli_SH1_end, fli_SH2_start, fli_SH2_end,
              fli_SH3_start, fli_SH3_end, fli_SH4_start, fli_SH4_end,
              fli_RP_MainLevel ,fli_RP_Add_WC_Proc,fli_RO_CompatChekType, fli_RO_MainLevel,
              fli_RO_Add_WC_Proc, fli_RO_Add_ProdType ,fli_OO_CompatChekType,fli_OO_MainLevel,
              fli_OO_Add_WC_Proc ,  fli_OO_Add_ProdType ,
              fli_PropBaseValue,
              fli_PropAddRscOfOcc, fli_PropAddValToAddiRsc, fli_PropDftCaseRsc_Occ_Ruls, fli_PropDftCaseOcc_Occ_Ruls,
              fli_PropDftSameGroupForOcc_Occ_Ruls, fli_PropValTakeForGroup,
              fli_ProdType, fli_PropLineNum, fli_PropValue, fli_PropOperand, fli_DepOnCurr,
              fli_DepValue, fli_RuleConst, fli_ManPropValue, fli_ManChg,
              fli_PropCase, fli_PropSetupTyp, fli_PropSetUpTime, fli_PropSetUpOverlappTime,  fli_PropSetUpTimeMult,
              fli_PropSetUpOverlappTimeMult, fli_CanBeSameGroup,  Fli_AddiRsc,
              fli_NumHourBforSetup, fli_NumHourAfterSetup, fli_ValAddAddiRscBeforSetup,
              fli_ValAddAddiRscWhileSetup, fli_ValAddAddiRscAfterSetup, fli_CapacyResrv,
              fli_CapacyResTyp, fli_Capacity_To_Job,
              fli_Zoom, fli_supMinBase, fli_supMinReal, fli_supMinOvlp,
              // Application Global
              fli_EnvDescr, fli_Customer, fli_MqmVersion, fli_MonthBefore, fli_StDateForPlan,
              fli_Language, fli_CurrTScale, fli_CurrDtTime, fli_ShowCal, fli_CurrRscSort,
              fli_ShowZoom, fli_RscOrderType, fli_RscOrderItem,
              fli_wdwPlanLeft, fli_wdwPlanTop, fli_wdwPlanWidth, fli_wdwPlanHeight,
              fli_wdwPlanstate, fli_wdwBinDock, fli_wdwBinLeft,   fli_wdwBinTop,
              fli_wdwBinWidth,  fli_wdwBinHeight, fli_wdwBinState, fli_wdwBinSplitter,
              // Application Settings
              fli_AppSettings,
              // Application Preferences
              fli_CheckStepSeq, fli_CenterStartOnMove, fli_WarnOnMoveFinal,
              fli_DefSchedType, fli_ConfLevels, fli_MoveOption,fli_ActAutoSchedCode,
              // BinFilters
              fli_MinQty, fli_MaxQty, fli_MinutAddAftrStp, fli_MaxMinutBfrNxtStp , fli_propLen, fli_Bin_ReadOnly,
              fli_DelivDate_From, fli_DelivDate_To,
              fli_ProdLowDate_From, fli_ProdLowDate_To, fli_PlanStartDate_From , fli_PlanStartDate_To,
              fli_LowStartDate_From, fli_LowStartDate_To, fli_ShowAlternative, fli_Wkcr_FromPlan,
              fli_FiltPropCode, fli_FiltPropRes, fli_filtPropValueFrom, fli_filtPropValueTo,
              fli_FiltSchedJobs, fli_FiltFltJobsOnGantt, fli_FiltClosedJobs,
              fli_Bin_OnlyReadOnly, fli_FiltOnlySchedJobs, fli_FiltOnlyClosedJobs, fli_FiltGroups, fli_FiltOnlyGroups,
              fli_SchedStartDate_From, fli_SchedStartDate_To,
              fli_FiltTemporary, fli_FiltPriority,fli_FiltProgress, fli_FiltOnlyProgress,
              fli_FiltAfterDeliveryDay, fli_FiltAfterDeliveryInDays,
              fli_FiltBeforeEarliestStart, fli_FiltBeforeEarliestStartInDays, fli_FiltAfterLatestEnd,
              fli_FiltAfterLatestEndInDays, fli_FiltShouldBeScheduled, fli_FiltShouldBeScheduledIndays,
              fli_FiltMissingmaterials, fli_FiltMissingAddRes, fli_FiltOveridePrevious,fli_FiltOverideNext,
              fli_FiltCompWithPrevJob, fli_FiltCompWithPrevJobInCase, fli_FiltCompWithRes,
              fli_FiltCompWithResInCase,
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
              // colors
              fli_ValFrom, fli_ValTo, fli_intColor, fli_bdrColor, fli_txtColor, fli_txtDescription, fli_LineNum, fli_Selected, fli_RscColDesc,
              // exchange
              fli_excOpCode,
              fli_updCode,
              fli_updOp, fli_TimeDescr,
              //Bar text config
              fli_SetName, fli_setIndex, fli_SetType, fli_fieldType,
              fli_WorkStation, fli_title,
              fli_orgTitle,fli_checked, fli_fromPos, fli_toPos,
              // licence
              fli_Lic, fli_Ver,
              //tbl_cfg_exchg_glob
              fli_LAST_UPD, fli_SL_OP, fli_SL_ON,
              //
              fli_CONNECT, fli_OP, fli_POLL,
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
              fli_highDateAlloc, fli_SearchMatByAlloc,fli_settled,fli_AllocQty,fli_AllocReq, fli_Prod_Balance,
              fli_issueCode,fli_quantityIssue,fli_netGroupCode,fli_ProdCode,
              fli_orgStep, fli_reqQuant, fli_seqIssued, fli_MatBalance,
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
              fli_qtyProduced, fli_sequenceChar, fli_ProductNature,fli_occupyCode, fli_StartConsumPoint, fli_EndConsumPoint, //
              // tbl_products
        //      fli_description,
              // tbl ps new fields
              fli_NettedQuantity,
              fli_ChangedQuantity,
              fli_downloadType,

              //tbl_balance_details
              //fli_netgroupcode, fli_ProdCode, fli_ProdType, fli_dueDate
//              fli_details,fli_quantity,
              //tbl_download_time
              fli_downloadTime,
{$ifdef ARO }
              fli_material,
{$endif}
              // tbl_mst_simulations
              fli_simWkstCode, fli_simcode, fli_simDesc, fli_simUsrTmCr, fli_simUsrTmCg, fli_simActive,
              //DBReport
              fli_AWCLDescr, fli_APRLDescr, fli_PWCLDescr, fli_PPRLDescr, fli_PTLDescr,
              fli_UMLDescr, fli_RSLDescr, fli_ARSLDescr, fli_PlanWkctCode, fli_PlanWkctProc,
              fli_ProdLineLDescr, fli_ProgRsc, fli_LowestPlanStart,
              fli_Desc_Prog_Type, fli_SchedID, fli_DescArt, fli_MatCode,
              //check bin
              fli_BinSel,
              //Tool bar Bin
              fli_ToolBarDock, fli_ToolBarLeft,fli_ToolBarTop, fli_ToolBarWidth,
              fli_ToolBarHeight, fli_ToolBarState,
              //AutoSched
              fli_CfgName, fli_CfgDesc, fli_MinJobResComp, fli_MinJobJobComp, fli_MinJobCapResComp,
//              fli_DateWgth, fli_JobResCompWgth, fli_JobJobCompWgth, fli_JobCapResCompWgth, fli_JobSetupChange,
//              fli_AfterDelDate, fli_TollAfterDelDate,
              fli_AfterHighLimit, fli_TollAfterHighLimit, fli_TollAfterHighLimitHours,
              fli_TollAfterHighLimitMinutes, fli_BeforeLowLimit, fli_TollBeforeLowLimit,
              fli_TollBeforeLowLimitHours, fli_TollBeforeLowLimitMinutes,
              fli_PrefTgtDate, fli_MoveObjsAllowed, fli_MoveFinalObjsAlwd,
              fli_MoveInitialObjsAlwd, fli_MoveLevel1ObjsAlwd, fli_MoveLevel2ObjsAlwd,
              fli_MoveLevel3ObjsAlwd, fli_MoveLevel4ObjsAlwd, fli_MoveLevel5ObjsAlwd, fli_MinStartDateOffset,
//              fli_GradBfrTollLSD, fli_GradBtwToll_LSD, fli_GradBtwLSD_TGTD, fli_GradBtwTGTD_HED,
//              fli_GradBtwHED_Toll, fli_GradBtwTollHED_Del, fli_GradBtwDel_Toll, fli_GradAftTollDel,
              fli_PriorErrLoop, fli_TempFinal, fli_Sleep, fli_RankRep, fli_GroupAllowOneJob,
              fli_MatWOMaterials, fli_OneRequestAtTime, fli_MatLinkReq, fli_MatWOAddRes, fli_CompactEntities,
              fli_NextDays, fli_GraphOnMove,
              // AutoSched New fields
              fli_BefEarlDateTol, fli_WithEarlDateTol, fli_AfterLatDateTol, fli_WithLatDateTol,
              fli_PenJobToJob, fli_PenSetupMin, fli_PenJobToRes, fli_PenJobToCapRes, fli_PenJobNotCapRes,
              fli_DateScoreWeight, fli_CompScoreWeight

  );


  TInfoStruct = record
    fInfo  : fldId;
    nrkey  : byte;
    notnull: boolean;
    defval : shortint;
  end;

  TTblInfo = record
    PCname: string;
    ASname: string;
    pfx   : string;
    struct: array of TInfoStruct;
    nrfld : integer;
   // group : shortint; // Main_db=1 Cfg_Db=2 Both=3
    group : shortint;
    arc   : shortint; // ARCHIVE = 0, OTHER,1
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

  struct_tbl_arty : array[1..3] of TInfoStruct = (
    (fInfo: fli_ArtType;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1)
    );

  struct_tbl_unit : array[1..3] of TInfoStruct = (
    (fInfo: fli_Um;                                 nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1)
    );

  struct_tbl_calendar : array[1..11] of TInfoStruct = (
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

  struct_tbl_wkst : array[1..7] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkDescr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkPasswd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkst_wkc : array[1..8] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TypeOfUse;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Visible;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc : array[1..6] of TInfoStruct = (
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrGroup;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TypOprtion;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TypProcess;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_proc : array[1..4] of TInfoStruct = (
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1)
   );

  struct_tbl_Licence : array[1..2] of TInfoStruct = (
    (fInfo: fli_Lic;                                nrkey: 0;   notnull: true;    defval : 0),
    (fInfo: fli_Ver;                                nrkey: 0;   notnull: true;    defval : 1)//CcfgDbCode)
  );

  struct_tbl_wkc_alt : array[1..4] of TInfoStruct = (
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_AlterWC;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_AlterWCProces;                      nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_wkc_prodLine : array[1..5] of TInfoStruct = (
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ProdLine;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DateBegin;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_DateEnd;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumResPlan;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_priority : array[1..10] of TInfoStruct = (
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

  struct_tbl_res : array[1..13] of TInfoStruct = (
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
    (fInfo: fli_Max_bch_size;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_res_sub : array[1..10] of TInfoStruct = (
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

  struct_tbl_res_apa : array[1..9] of TInfoStruct = (
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

  struct_tbl_resCat : array[1..3] of TInfoStruct = (
    (fInfo: fli_RscCat;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CategorySDesc;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CategoryLDesc;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_Archive_To_Host : array[1..2] of TInfoStruct = (
    (fInfo: fli_Tbl_Name;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Tbl_Host;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_addRes : array[1..4] of TInfoStruct = (
    (fInfo: fli_addiCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConsumingZone;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prop_res : array[1..16] of TInfoStruct = (
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_RscCat;                             nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_WCProcess;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_Rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropBaseValue;                      nrkey: 0;   notnull: false;   defval : -1),
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

  struct_tbl_ruleResToOcc : array[1..16] of TInfoStruct = (
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

  struct_tbl_ruleOccToOcc : array[1..23] of TInfoStruct = (
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
    (fInfo: fli_usrCr;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prop : array[1..17]of TInfoStruct = (
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
    (fInfo: fli_OO_Add_ProdType;                    nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prop_prod : array[1..7] of TInfoStruct = (
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropValue;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_tmp_prod_prop : array[1..8] of TInfoStruct = (
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_PropValue;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_req : array[1..8] of TInfoStruct = (
    (fInfo: fli_divCode;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_dispoCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bch;                                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_reprocNo;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_HistoriclReq;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_reqHdr : array[1..14] of TInfoStruct = (
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
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_tmp_prod_reqHdr : array[1..13] of TInfoStruct = (
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
  struct_tbl_prod_info : array[1..7] of TInfoStruct = (
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_infoType;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_infoLineNum;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_InfoArea;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );
{$ifdef ARO }
  struct_tbl_prod_reqConnection : array[1..5]of TInfoStruct = (
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PrevProdNum;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MachSetupCode;                      nrkey: 0;   notnull: false;   defval : -1)
{$else}
  struct_tbl_prod_reqConnection : array[1..4]of TInfoStruct = (
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PrevProdNum;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
{$endif}
  );

  struct_tbl_ext_infoHdr : array[1..5] of TInfoStruct = (
    (fInfo: fli_ConnKey;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ConnType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DueDate;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ext_info : array[1..5] of TInfoStruct = (
    (fInfo: fli_ConnKey;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_infoLineNum;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_InfoArea;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ext_connection : array[1..6] of TInfoStruct = (
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ConnKey;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NumOfLevel;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnCertentyLevel;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_step : array[1..37] of TInfoStruct = (
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_ToBeSched;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prevStepSched;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prevStepTrue;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStepSched;                      nrkey: 0;   notnull: false;   defval : -1),
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

  struct_tbl_tmp_prod_reqDet : array[1..36] of TInfoStruct = (
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ToBeSched;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prevStepSched;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prevStepTrue;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NextStepSched;                      nrkey: 0;   notnull: false;   defval : -1),
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

  struct_tbl_step_batchSize : array[1..4] of TInfoStruct = (
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_BchUM;                              nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_multipToBatchUm;                    nrkey: 0;   notnull: false;   defval : -1)
  );

{$ifdef ARO }
  struct_tbl_step_times : array[1..11] of TInfoStruct = (
{$else}
  struct_tbl_step_times : array[1..9] of TInfoStruct = (
{$endif}
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RscCat;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
   // (fInfo: fli_Sequence;                           nrkey: 1;   notnull: true;    defval : -1),
   // (fInfo: fli_TimeDescr;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MachSetupCode;                      nrkey: 1;   notnull: true;    defval : -1),
{$ifdef ARO }
    (fInfo: fli_sequencechar;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetUpTimJob;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ExecTimeInitQty;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_material;                           nrkey: 0;   notnull: false;   defval : -1)
{$else }
    (fInfo: fli_SetUpTimJob;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ExecTimeInitQty;                    nrkey: 0;   notnull: false;   defval : -1)
{$endif}
  );

  struct_tbl_prod_sched : array[1..43] of TInfoStruct = (
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
    (fInfo: fli_BinSel;                             nrkey: 0;   notnull: true;    defval :  1),
    (fInfo: fli_Prog_Override_Type;                 nrkey: 0;   notnull: false;   defval :  1)
  );

  struct_tbl_prod_schedForce : array[1..34] of TInfoStruct = (
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

  struct_tbl_sched_progress : array[1..19] of TInfoStruct = (
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
    (fInfo: fli_prgRemTime;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProgressTypeHost;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rscHost;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_progrStartHost;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prgCurrDateHost;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_progrEndHost;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantHost;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_prgRemTimeHost;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_sched_progress_override : array[1..13] of TInfoStruct = (
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
    (fInfo: fli_prgRemTime;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Prog_Override_Type;                 nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_capRes: array[1..16] of TInfoStruct = (
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

  struct_tbl_capRes_Host : array[1..16] of TInfoStruct = (
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

  struct_tbl_prop_capRes : array[1..5] of TInfoStruct = (
    (fInfo: fli_CapacyResrv;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropertyCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PropValue;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrCg;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_usrTmCg;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_Proc : array[1..2] of TInfoStruct = (
    (fInfo: fli_wkcProc;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1)
  );


  struct_tbl_Cal : array[1..2] of TInfoStruct  =(
    (fInfo: fli_CalCod;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SDescr;                             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_Change : array[1..2] of TInfoStruct = (
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_rsc_Change : array[1..2] of TInfoStruct = (
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_Req_Change : array[1..5] of TInfoStruct = (
    (fInfo: fli_preqNo;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_pstepId;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ChangeType;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ReactivateReq;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_CapRsc_Change : array[1..3] of TInfoStruct = (
    (fInfo: fli_CapacyResrv;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_updCode;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ChangeType;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  //Cfg
  struct_tbl_cfg_appGlob : array[1..39] of TInfoStruct = (
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
    (fInfo: fli_ConfLevels;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_appSettings : array[1..2] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_appSettings;                        nrkey: 0;   notnull: false;   defval : -1)// string for settings
  );

  struct_tbl_cfg_AutoSched : array[1..47] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CfgName;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CfgDesc;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MinJobResComp;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MinJobJobComp;                      nrkey: 0;   notnull: false;   defval : -1),
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
    (fInfo: fli_CompScoreWeight;                    nrkey: 0;   notnull: false;   defval : -1)

  );

  struct_tbl_cfg_binFilter : array[1..177] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsDesc;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TabVis;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MinQty;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaxQty;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLine;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLowDate_From;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLowDate_To;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DelivDate_From;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DelivDate_To;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanStartDate_From;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanStartDate_To;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LowStartDate_From;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LowStartDate_To;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SchedStartDate_From;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SchedStartDate_To;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltTemporary;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_preqNo;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Bin_ReadOnly;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcProc;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ShowAlternative;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Wkcr_FromPlan;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_stGroup;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_reprocNo;                           nrkey: 0;   notnull: false;   defval : -1),
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
    (fInfo: fli_filtPropValueTo30;                  nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_binTab_col : array[1..9] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_BinColField;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_BinColTitle;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColPos;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColWidth;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColVisibl;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BinColOrder;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropCode;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_planTab_master : array[1..7] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TypeOfUse;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_TabsDesc;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Zoom;                               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurrTScale;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CurrDtTime;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_planTab_det : array[1..4] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_TabsCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_rsc;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_toPos;                              nrkey: 0;   notnull: true;    defval : -1)
  );

  struct_tbl_cfg_exchg_glob : array[1..3] of TInfoStruct = (
    (fInfo: fli_LAST_UPD;                           nrkey: 0;   notnull: false;   defval :  0),
    (fInfo: fli_SL_OP;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SL_ON;                              nrkey: 0;   notnull: false;   defval :  0)
  );

  struct_tbl_cfg_exchg_wkst : array[1..5] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CONNECT;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LAST_UPD;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_OP;                                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_POLL;                               nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_exchg_SrvLoad : array[1..2] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_downloadType;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_SrvLoad_Log : array[1..3] of TInfoStruct = (
    (fInfo: fli_CurrDtTime;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Operation;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Text;                               nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_bin_showProp : array[1..31] of TInfoStruct = (
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
    (fInfo: fli_FiltPropCode30;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_colorStatus : array[1..6] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtDescription;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_colorDateWarn : array[1..6] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtDescription;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_colorMatWarn : array[1..6] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtDescription;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_colorJobToRes : array[1..5] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_colorJobToJob : array[1..5] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_clrCapToJob : array[1..5] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_tbl_cfg_clrRes : array[1..6] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtDescription;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_clrCapRes : array[1..6] of TInfoStruct = (
    (fInfo: fli_wkstCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ValFrom;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_intColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_bdrColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtColor;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_txtDescription;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_text_display_set_fields : array[1..9] of TInfoStruct = (
    (fInfo: fli_workstation;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetName;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetType;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_fieldType;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_title;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_orgTitle;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_checked;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_fromPos;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_toPos;                              nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cfg_text_display_set_wkc : array[1..4] of TInfoStruct = (
    (fInfo: fli_workstation;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetName;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetType;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_wkCtrCode;                          nrkey: 1;   notnull: true;    defval : -1)
  );

{
  struct_tbl_cfg_text_display_set_hdr : array[1..3] of TInfoStruct = (
    (fInfo: fli_WorkStation;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetName;                            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SetType;                            nrkey: 0;   notnull: false;   defval : -1)

  );

 }
  struct_tbl_machine_setup_code : array[1..10] of TInfoStruct = (
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

  struct_tbl_Wkc_dependency : array[1..13] of TInfoStruct = (
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

  struct_tbl_Material : array[1..20] of TInfoStruct = (
    (fInfo: fli_preqNo;                           nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_pstepId;                          nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_orgStep;                          nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_wkCtrCode;                        nrkey: 1;   notnull: true;     defval : -1),
//    (fInfo: fli_wkcProc;                          nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ResCatcode;                       nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_rsc;                              nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_MachSetupCode;                    nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_AlternativCode;                   nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_prodtype;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_netGroupCode;                     nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_issueCode;                        nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_seqIssued;                        nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_MatBalance;                       nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_AllocQty;                         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_highDateAlloc;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_SearchMatByAlloc;                 nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_settled;                          nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_quantityIssue;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_reqQuant;                         nrkey: 0;   notnull: false;    defval : -1)
  );

  struct_tbl_material_sup_detail : array[1..11] of TInfoStruct = (
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
    (fInfo: fli_MatProdType;                      nrkey: 1;   notnull: true;     defval : -1)
   );

  struct_tbl_material_sup_header : array[1..18] of TInfoStruct = (
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
    (fInfo: fli_UpdReqPrevStpHrs;                 nrkey: 0;   notnull: false;    defval : -1)
   );

  struct_tbl_produced_article : array[1..11] of TInfoStruct = (
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
    (fInfo: fli_AllocQty;                         nrkey: 0;   notnull: false;    defval : -1)
    );

  struct_tbl_products : array[1..6] of TInfoStruct = (
    (fInfo: fli_ProdType;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_ProductNature;                    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_StartConsumPoint;                 nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_EndConsumPoint;                   nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_InfoArea;                         nrkey: 0;   notnull: false;    defval : -1)
   );

  struct_tbl_balance_header : array[1..8] of TInfoStruct = (
    (fInfo: fli_ProdType;                         nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_netgroupcode;                     nrkey: 0;   notnull: true;     defval : -1),
//    (fInfo: fli_occupyCode;                       nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_dueDate;                          nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_quant;                            nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_InfoArea;                         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_usrCg;                            nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_usrTmCg;                          nrkey: 0;   notnull: false;    defval : -1)
  );

  struct_tbl_balance_detail : array[1..9] of TInfoStruct = (
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

{  struct_tbl_Article_Occ_Code : array[1..4] of TInfoStruct = (
    (fInfo: fli_ProdType;                         nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ProdCode;                         nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_occupyCode;                       nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_InfoArea;                         nrkey: 0;   notnull: false;    defval : -1)
    (fInfo: fli_usrCg;                            nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_usrTmCg;                          nrkey: 0;   notnull: false;    defval : -1)
   );  }

  struct_tbl_download_time : array[1..1] of TInfoStruct = (
    (fInfo: fli_downloadTime;                     nrkey: 1;   notnull: true;    defval : -1)
   );


////////// TEMP DB

  struct_tbl_mst_simulations : array[1..6] of TInfoStruct = (
    (fInfo: fli_simWkstCode;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_simcode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_simDesc;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_simUsrTmCr;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_simUsrTmCg;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_simActive;                         nrkey: 0;   notnull: false;   defval : -1)
   );

  struct_tbl_report: array[1..92] of TInfoStruct = (
    (fInfo: fli_WkstCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Desc;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_preqNo;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_pstepId;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_psubstId;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_reprocNo;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_stGroup;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkCtrCode;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_AWCLDescr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WCProcess;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_APRLDescr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanWkctCode;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PWCLDescr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PlanWkctProc;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PPRLDescr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ArtType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLDescr;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLine;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdFamily;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaterialFamily;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdUMCode;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LDescr;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Comment;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LowStartTimeLimit;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdDelivDate;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_StepType;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaterialArrivDate;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_planStart;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LowestPlanStart;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProdLowDataTime;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_planEnd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalCod;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantInit;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quantFinl;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Weight;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SetupTimStep;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_excTimeStep;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NumResPlan;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnTypToPrevStepSplit;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_quant;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_exeMin;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_supMinReal;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_rsc;                               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSLDescr;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SchedStart;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedEnd;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_progrStart;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_progrEnd;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MaxQty;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Desc_Prog_Type;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ProgRsc;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ARSLDescr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnForwardSubStep;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnForwardReProcess;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnBackwardSubStep;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ConnBackwardReProcess;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom1;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom2;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom3;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom4;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom5;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom6;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom7;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom8;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom9;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom10;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom11;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom12;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom13;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom14;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom15;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom16;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom17;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom18;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom19;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom20;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom21;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom22;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom23;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom24;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom25;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom26;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom27;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom28;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom29;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FiltPropValueFrom30;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_InfoArea;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_FrcDelDate;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_schedType;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SchedID;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_DescArt;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MatCode;                           nrkey: 0;   notnull: false;   defval : -1)
   );

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

  tblInfo : array[table] of TTblInfo = (
    (PCname: 'Tables_Upload_Host';   ASname: '';          pfx: 'TH_';     struct: @struct_tbl_Archive_To_Host;    nrfld: High(struct_tbl_Archive_To_Host);    group: 2;   arc: 1),     //  tbl_tbl_Archive_To_Host
    (PCname: 'ADD_RES';              ASname: '';          pfx: 'AR_';     struct: @struct_tbl_addRes;             nrfld: High(struct_tbl_addRes);             group: 1;   arc: 1),     //  tbl_addRes
    (PCname: 'ALT_WKC';              ASname: 'DISPM00F';  pfx: 'AW_';     struct: @struct_tbl_wkc_alt;            nrfld: High(struct_tbl_wkc_alt);            group: 1;   arc: 0),     //  tbl_wkc_alt
    (PCname: 'APP_GLOBALS';          ASname: '';          pfx: 'AG_';     struct: @struct_tbl_cfg_appGlob;        nrfld: High(struct_tbl_cfg_appGlob);        group: 2;   arc: 1),     //  tbl_cfg_appGlob
    (PCname: 'APP_SETTINGS';         ASname: '';          pfx: 'AS_';     struct: @struct_tbl_cfg_appSettings;    nrfld: High(struct_tbl_cfg_appSettings);    group: 2;   arc: 1),     //  tbl_cfg_appSettings
    (PCname: 'AUTO_SCHED';           ASname: '';          pfx: 'ASC_';    struct: @struct_tbl_cfg_AutoSched;      nrfld: High(struct_tbl_cfg_AutoSched);      group: 2;   arc: 1),     //  tbl_cfg_AutoSched
    (PCname: 'ARTICLE_TYPE';         ASname: 'TABLE00F';  pfx: 'AT_';     struct: @struct_tbl_arty;               nrfld: High(struct_tbl_arty);               group: 1;   arc: 0),     //  tbl_arty
    (PCname: 'BIN_SHOW_PROP';        ASname: '';          pfx: 'BP_';     struct: @struct_tbl_cfg_bin_showProp;   nrfld: High(struct_tbl_cfg_bin_showProp);   group: 2;   arc: 1),     //  tbl_cfg_bin_showProp
    (PCname: 'PROP_CAPRES';          ASname: 'MQMCP00F';  pfx: 'CP_';     struct: @struct_tbl_prop_capRes;        nrfld: High(struct_tbl_prop_capRes);        group: 1;   arc: 0),     //  tbl_prop_capRes
    (PCname: 'CAPRES';               ASname: 'MQMCR00F';  pfx: 'CR_';     struct: @struct_tbl_capRes;             nrfld: High(struct_tbl_capRes);             group: 1;   arc: 0),     //  tbl_capRes
    (PCname: 'CAPRES_HOST';          ASname: '';          pfx: 'CH_';     struct: @struct_tbl_capRes_Host;        nrfld: High(struct_tbl_capRes_Host);        group: 1;   arc: 0),     //  tbl_capRes
    (PCname: 'CLR_CAP_TO_JOB';       ASname: '';          pfx: 'CJ_';     struct: @struct_tbl_cfg_clrCapToJob;    nrfld: High(struct_tbl_cfg_clrCapToJob);    group: 2;   arc: 1),     //  tbl_cfg_clrCapToJob
    (PCname: 'RESCAT';               ASname: 'TABLE00F';  pfx: 'CT_';     struct: @struct_tbl_resCat;             nrfld: High(struct_tbl_resCat);             group: 1;   arc: 0),     //  tbl_resCat
    (PCname: 'CALENDAR';             ASname: 'PGTUR00F';  pfx: 'CA_';     struct: @struct_tbl_calendar;           nrfld: High(struct_tbl_calendar);           group: 1;   arc: 0),     //  tbl_calendar
    (PCname: 'PLAN_TAB_DET';         ASname: '';          pfx: 'PVD_';    struct: @struct_tbl_cfg_planTab_det;    nrfld: High(struct_tbl_cfg_planTab_det);    group: 2;   arc: 1),     //  tbl_cfg_planTab_det
    (PCname: 'PLAN_TAB_MASTER';      ASname: '';          pfx: 'PVM_';    struct: @struct_tbl_cfg_planTab_master; nrfld: High(struct_tbl_cfg_planTab_master); group: 2;   arc: 1),     //  tbl_plan_tbs_master
    (PCname: 'EXCG_GLOB';            ASname: '';          pfx: 'CEG_';    struct: @struct_tbl_cfg_exchg_glob;     nrfld: High(struct_tbl_cfg_exchg_glob);     group: 2;   arc: 1),     //  tbl_cfg_exchg_glob
    (PCname: 'EXCG_WKST';            ASname: '';          pfx: 'CEW_';    struct: @struct_tbl_cfg_exchg_wkst;     nrfld: High(struct_tbl_cfg_exchg_wkst);     group: 2;   arc: 1),     //  tbl_cfg_exchg_wkst
    (PCname: 'EXCG_WKST_SRVLOAD';    ASname: '';          pfx: 'SRV_';    struct: @struct_tbl_cfg_exchg_SrvLoad;  nrfld: High(struct_tbl_cfg_exchg_SrvLoad);  group: 2;   arc: 1),     //  tbl_cfg_exchg_wkst
    (PCname: 'SRVLOAD_LOG';          ASname: '';          pfx: 'SLO_';    struct: @struct_tbl_cfg_SrvLoad_Log;    nrfld: High(struct_tbl_cfg_SrvLoad_Log);    group: 2;   arc: 1),     //  tbl_cfg_SrvLoad_Log
    (PCname: 'EXT_INFO';             ASname: 'MQMEI00F';  pfx: 'EI_';     struct: @struct_tbl_ext_info;           nrfld: High(struct_tbl_ext_info);           group: 1;   arc: 1),     //  tbl_ext_info
    (PCname: 'EXT_INFO_HDR';         ASname: 'MQMEH00F';  pfx: 'EH_';     struct: @struct_tbl_ext_infoHdr;        nrfld: High(struct_tbl_ext_infoHdr);        group: 1;   arc: 1),     //  tbl_ext_infoHdr
    (PCname: 'EXT_CONNECTION';       ASname: 'MQMEC00F';  pfx: 'EC_';     struct: @struct_tbl_ext_connection;     nrfld: High(struct_tbl_ext_connection);     group: 1;   arc: 1),     //  tbl_ext_connection
    (PCname: 'BIN_FILTER';           ASname: '';          pfx: 'BF_';     struct: @struct_tbl_cfg_binFilter;      nrfld: High(struct_tbl_cfg_binFilter);      group: 2;   arc: 1),     //  tbl_cfg_binFilter
    (PCname: 'SCHED_FORCE';          ASname: 'MQMFS00F';  pfx: 'FS_';     struct: @struct_tbl_prod_schedForce;    nrfld: High(struct_tbl_prod_schedForce);    group: 1;   arc: 0),     //  tbl_prod_schedForce
    (PCname: 'RES_SUB';              ASname: 'MQMDH00F';  pfx: 'DH_';     struct: @struct_tbl_res_sub;            nrfld: High(struct_tbl_res_sub);            group: 1;   arc: 0),     //  tbl_res_sub
    (PCname: 'CLR_JOB_STATUS';       ASname: '';          pfx: 'JS_';     struct: @struct_tbl_cfg_colorStatus;    nrfld: High(struct_tbl_cfg_colorStatus);    group: 2;   arc: 1),     //  tbl_cfg_colorErr
    (PCname: 'CLR_JOB_DATE_WRN';     ASname: '';          pfx: 'JD_';     struct: @struct_tbl_cfg_colorDateWarn;  nrfld: High(struct_tbl_cfg_colorDateWarn);  group: 2;   arc: 1),     //  tbl_cfg_colorErr
    (PCname: 'CLR_JOB_MAT_WRN';      ASname: '';          pfx: 'JM_';     struct: @struct_tbl_cfg_colorMatWarn;    nrfld: High(struct_tbl_cfg_colorMatWarn);    group: 2;   arc: 1),     //  tbl_cfg_colorErr
    (PCname: 'CLR_JOB_TO_RES';       ASname: '';          pfx: 'JR_';     struct: @struct_tbl_cfg_colorJobToRes;  nrfld: High(struct_tbl_cfg_colorJobToRes);  group: 2;   arc: 1),     //  tbl_cfg_colorJobToRes
    (PCname: 'CLR_JOB_TO_JOB';       ASname: '';          pfx: 'JJ_';     struct: @struct_tbl_cfg_colorJobToJob;  nrfld: High(struct_tbl_cfg_colorJobToJob);  group: 2;   arc: 1),     //  tbl_cfg_clrJobToJob
    (PCname: 'PROD_REQCONN';         ASname: 'MQMIC00F';  pfx: 'IC_';     struct: @struct_tbl_prod_reqConnection; nrfld: High(struct_tbl_prod_reqConnection); group: 1;   arc: 1),     //  tbl_prod_reqConnection
    (PCname: 'RULE_OCC_TO_OCC';      ASname: 'MQMOO00F';  pfx: 'OO_';     struct: @struct_tbl_ruleOccToOcc;       nrfld: High(struct_tbl_ruleOccToOcc);       group: 1;   arc: 0),     //  tbl_ruleOccToOcc
    (PCname: 'PROD_INFO';            ASname: 'MQMPI00F';  pfx: 'PI_';     struct: @struct_tbl_prod_info;          nrfld: High(struct_tbl_prod_info);          group: 1;   arc: 1),     //  tbl_prod_info
    (PCname: 'WKC_PROD_LINE';        ASname: 'WCMAC10F';  pfx: 'PL_';     struct: @struct_tbl_wkc_prodLine;       nrfld: High(struct_tbl_wkc_prodLine);       group: 1;   arc: 0),     //  tbl_wkc_prodLine
    (PCname: 'PROP_PROD';            ASname: 'MQMPP00F';  pfx: 'PP_';     struct: @struct_tbl_prop_prod;          nrfld: High(struct_tbl_prop_prod);          group: 1;   arc: 1),     //  tbl_prop_prod
//    (PCname: 'PROP_PROD_COPY';       ASname: 'MQMPP10F';  pfx: 'PP_';     struct: @struct_tbl_prop_prod_copy;     nrfld: High(struct_tbl_prop_prod_copy);    group: 1;   arc: 1),     //  tbl_prop_prod_copy
    (PCname: 'PROD_REQ';             ASname: 'MQMPR00F';  pfx: 'PR_';     struct: @struct_tbl_prod_req;           nrfld: High(struct_tbl_prod_req);           group: 1;   arc: 1),     //  tbl_prod_req
    (PCname: 'PROD_STEP';            ASname: 'MQMPD00F';  pfx: 'PD_';     struct: @struct_tbl_prod_step;          nrfld: High(struct_tbl_prod_step);          group: 1;   arc: 1),     //  tbl_prod_step
    (PCname: 'PROD_REQHDR';          ASname: 'MQMPH00F';  pfx: 'PH_';     struct: @struct_tbl_prod_reqHdr;        nrfld: High(struct_tbl_prod_reqHdr);        group: 1;   arc: 1),     //  tbl_prod_reqHdr
    (PCname: 'PROD_SCHED';           ASname: 'MQMPS10F';  pfx: 'PS_';     struct: @struct_tbl_prod_sched;         nrfld: High(struct_tbl_prod_sched);         group: 1;   arc: 1),     //  tbl_prod_sched
//    (PCname: 'PROD_STEP_COPY';       ASname: 'MQMSC00F';  pfx: 'SC_';     struct: @struct_tbl_prod_step_copy;     nrfld: High(struct_tbl_prod_step_copy);    group: 1;   arc: 1),     //  tbl_prod_step_copy
    (PCname: 'PROP';                 ASname: 'TABLE00F';  pfx: 'PY_';     struct: @struct_tbl_prop;               nrfld: High(struct_tbl_prop);               group: 1;   arc: 0),     //  tbl_prop
    (PCname: 'CLR_RES';              ASname: '';          pfx: 'RC_';     struct: @struct_tbl_tbl_cfg_clrRes;     nrfld: High(struct_tbl_tbl_cfg_clrRes);     group: 2;   arc: 1),     //  tbl_cfg_clrRes
    (PCname: 'CLR_CAP_RES';          ASname: '';          pfx: 'CRC_';    struct: @struct_tbl_cfg_clrCapRes;      nrfld: High(struct_tbl_cfg_clrCapRes);      group: 2;   arc: 1),     //  tbl_cfg_clrCapRes
    (PCname: 'RES';                  ASname: 'VPLRS00F';  pfx: 'RS_';     struct: @struct_tbl_res;                nrfld: High(struct_tbl_res);                group: 1;   arc: 0),     //  tbl_res
    (PCname: 'RES_APA';              ASname: 'MQMRD00F';  pfx: 'RD_';     struct: @struct_tbl_res_apa;            nrfld: High(struct_tbl_res_apa);            group: 1;   arc: 0),     //  tbl_res_apa
    (PCname: 'REQ_CHANGE';           ASname: '';          pfx: 'RC_';     struct: @struct_tbl_Req_Change;         nrfld: High(struct_tbl_Req_Change);         group: 1;   arc: 1),     //  tbl_Req_Change
    (PCname: 'CAP_RSC_CHANGE';       ASname: '';          pfx: 'CRG_';    struct: @struct_tbl_CapRsc_Change;      nrfld: High(struct_tbl_caprsc_Change);      group: 1;   arc: 1),     //  tbl_Caprsc_Change
    (PCname: 'RULE_RES_TO_OCC';      ASname: 'MQMRO00F';  pfx: 'RO_';     struct: @struct_tbl_ruleResToOcc;       nrfld: High(struct_tbl_ruleResToOcc);       group: 1;   arc: 0),     //  tbl_ruleResToOcc
    (PCname: 'PROP_RES';             ASname: 'MQMRP00F';  pfx: 'RP_';     struct: @struct_tbl_prop_res;           nrfld: High(struct_tbl_prop_res);           group: 1;   arc: 0),     //  tbl_prop_res
//    (PCname: 'ADDRES_SETUP';         ASname: 'MQMSA00F';  pfx: 'SA_';     struct: @struct_tbl_addRes_setup;       nrfld: High(struct_tbl_addRes_setup);       group: 1;   arc: 0),     //  tbl_addRes_setup
    (PCname: 'PROD_STEP_BATCH_SIZE'; ASname: 'MQMSB00F';  pfx: 'SB_';     struct: @struct_tbl_step_batchSize;     nrfld: High(struct_tbl_step_batchSize);     group: 1;   arc: 1),     //  tbl_step_batchSize
    (PCname: 'PROD_STEP_TIMES';      ASname: 'MQMST00F';  pfx: 'ST_';     struct: @struct_tbl_step_times;         nrfld: High(struct_tbl_step_times);         group: 1;   arc: 1),     //  tbl_step_times
    (PCname: 'PROD_SCHED_PROGRESS';  ASname: 'MQMSP00F';  pfx: 'SP_';     struct: @struct_tbl_sched_progress;     nrfld: High(struct_tbl_sched_progress);     group: 1;   arc: 1),     //  tbl_sched_progress
    (PCname: 'PROD_SCHED_PROGRESS_OVERRIDE';  ASname: ''; pfx: 'SPO_';    struct: @struct_tbl_sched_progress_override;  nrfld: High(struct_tbl_sched_progress_override); group: 1;   arc: 1),   //  tbl_sched_progress_Override
    (PCname: 'BIN_TAB_COL';          ASname: '';          pfx: 'BC_';     struct: @struct_tbl_cfg_binTab_col;     nrfld: High(struct_tbl_cfg_binTab_col);     group: 2;   arc: 1),     //  tbl_cfg_binTab_col
    (PCname: 'UNIT';                 ASname: 'TABLE00F';  pfx: 'UM_';     struct: @struct_tbl_unit;               nrfld: High(struct_tbl_unit);               group: 1;   arc: 0),     //  tbl_unit
    (PCname: 'WKC';                  ASname: 'WCMAC00F';  pfx: 'WC_';     struct: @struct_tbl_wkc;                nrfld: High(struct_tbl_wkc);                group: 1;   arc: 0),     //  tbl_wkc
    (PCname: 'WKC_PROC';             ASname: 'WCPRO00F';  pfx: 'WP_';     struct: @struct_tbl_wkc_proc;           nrfld: High(struct_tbl_wkc_proc);           group: 1;   arc: 0),     //  tbl_wkc_proc
    (PCname: 'WKST';                 ASname: 'MQMWS00F';  pfx: 'WK_';     struct: @struct_tbl_wkst;               nrfld: High(struct_tbl_wkst);               group: 1;   arc: 0),     //  tbl_wkst
    (PCname: 'WKS_WKC';              ASname: 'MQMWW00F';  pfx: 'WW_';     struct: @struct_tbl_wkst_wkc;           nrfld: High(struct_tbl_wkst_wkc);           group: 1;   arc: 0),     //  tbl_wkst_wkc
    (PCname: 'WKC_PRIORITY';         ASname: 'MQMWC00F';  pfx: 'WP_';     struct: @struct_tbl_wkc_priority;       nrfld: High(struct_tbl_wkc_priority);       group: 1;   arc: 0),     //  tbl_wkc_priority
//    (PCname: 'TMP_PROD_PROP';        ASname: 'MQMPP00F';  pfx: 'TMPPP_';  struct: @struct_tbl_tmp_prod_prop;      nrfld: High(struct_tbl_tmp_prod_prop);     group: 1;   arc: 1),     //  tbl_tmp_prod_prop
//    (PCname: 'TMP_PROD_REQDET';      ASname: 'MQMPD00F';  pfx: 'TMPPD_';  struct: @struct_tbl_tmp_prod_reqDet;    nrfld: High(struct_tbl_tmp_prod_reqDet);   group: 1;   arc: 1),     //  tbl_tmp_prod_reqDet
//    (PCname: 'TMP_PROD_REQHDR';      ASname: 'MQMPH00F';  pfx: 'TMPPH_';  struct: @struct_tbl_tmp_prod_reqHdr;    nrfld: High(struct_tbl_tmp_prod_reqHdr);   group: 1;   arc: 1),     //  tbl_tmp_prod_reqHdr
    (PCname: 'TEXT_DISPLAY_SET_FIELDS';   ASname: '';          pfx: 'TDF_';    struct: @struct_tbl_cfg_text_display_set_fields;    nrfld: High(struct_tbl_cfg_text_display_set_fields);  group: 2;   arc: 1),     //  tbl_cfg_text_display_set_fields
    (PCname: 'TEXT_DISPLAY_SET_WKC';      ASname: '';          pfx: 'TDW_';    struct: @struct_tbl_cfg_text_display_set_wkc;       nrfld: High(struct_tbl_cfg_text_display_set_wkc);     group: 2;   arc: 1),     //  tbl_cfg_text_display_set_wkc
//    (PCname: 'TEXT_DISPLAY_SET_HDR';      ASname: '';          pfx: 'TDH_';    struct: @struct_tbl_cfg_text_display_set_hdr;       nrfld: High(struct_tbl_cfg_text_display_set_hdr);     group: 2;   arc: 1),     //  tbl_cfg_bar_set_wkc
    (PCname: 'WKC_Change';           ASname: '';          pfx: 'WG_';     struct: @struct_tbl_wkc_Change;         nrfld: High(struct_tbl_wkc_Change);         group: 1;   arc: 1),     //  tbl_wkc_Change
    (PCname: 'RSC_Change';           ASname: '';          pfx: 'RG_';     struct: @struct_tbl_rsc_Change;         nrfld: High(struct_tbl_rsc_Change);         group: 1;   arc: 1),     //  tbl_rsc_Change
    (PCname: 'PROC';                 ASname: '';          pfx: 'PR_';     struct: @struct_tbl_Proc;               nrfld: High(struct_tbl_Proc);               group: 1;   arc: 1),     //  tbl_Proc
    (PCname: 'CAL';                  ASname: '';          pfx: 'CL_';     struct: @struct_tbl_Cal;                nrfld: High(struct_tbl_Cal);                group: 1;   arc: 1),     //  tbl_Cal
    (PCname: 'LICENCE';              ASname: '';          pfx: 'LIC_';    struct: @struct_tbl_licence;            nrfld: High(struct_tbl_licence);            group: 3;   arc: 1),     //  tbl_licence
    (PCname: 'MACHINE_SETUP_CODE';   ASname: 'MQMMS00F';  pfx: 'MS_';     struct: @struct_tbl_machine_setup_code; nrfld: High(struct_tbl_machine_setup_code); group: 1;   arc: 1),     //  tbl_machine_setup_code
    (PCname: 'WKC_DEPENDENCY';       ASname: 'MQMWD00F';  pfx: 'WD_';     struct: @struct_tbl_Wkc_dependency;     nrfld: High(struct_tbl_Wkc_dependency);     group: 1;   arc: 0),     //  tbl_Wkc_dependency
    (PCname: 'MATERIAL';             ASname: 'MQMMT00F';  pfx: 'MT_';     struct: @struct_tbl_Material;           nrfld: High(struct_tbl_Material);           group: 1;   arc: 1),     //  tbl_Material
    (PCname: 'MATERIAL_SUP_DETAIL';  ASname: 'MQMMD00F';  pfx: 'MD_';     struct: @struct_tbl_material_sup_detail;nrfld: High(struct_tbl_material_sup_detail);group: 1;   arc: 0),     //  tbl_Material_sup_detail
    (PCname: 'MATERIAL_SUP_HEADER';  ASname: 'MQMMH00F';  pfx: 'MH_';     struct: @struct_tbl_material_sup_header;nrfld: High(struct_tbl_material_sup_header);group: 1;   arc: 0),      //  tbl_Material_sup_header
    (PCname: 'PRODUCED_ARTICLE';     ASname: 'MQMPA00F';  pfx: 'PA_';     struct: @struct_tbl_produced_article;   nrfld: High(struct_tbl_produced_article);   group: 1;   arc: 1),      //  tbl_produced_article
    (PCname: 'PRODUCTS';             ASname: 'MQMAR00F';  pfx: 'PAR_';    struct: @struct_tbl_products;           nrfld: High(struct_tbl_products);           group: 1;   arc: 1),      //  tbl_products
    (PCname: 'BALANCE_HEADER';       ASname: 'MQMBH00F';  pfx: 'BH_';     struct: @struct_tbl_balance_header;     nrfld: High(struct_tbl_balance_header);     group: 1;   arc: 1),      //  tbl_balance_header
    (PCname: 'BALANCE_DETAIL';       ASname: 'MQMBD00F';  pfx: 'BD_';     struct: @struct_tbl_balance_detail;     nrfld: High(struct_tbl_balance_detail);     group: 1;   arc: 1),      //  tbl_balance_detail
//    (PCname: 'ARTICLE_OCC_CODE';     ASname: 'MQMAO00F';  pfx: 'AO_';     struct: @struct_tbl_Article_Occ_Code;   nrfld: High(struct_tbl_Article_Occ_Code);    group: 1;   arc: 1),      //  tbl_Art_Occ_Code
    (PCname: 'DOWNLOAD_TIME';        ASname: 'MQMDD00F';  pfx: 'DD_';     struct: @struct_tbl_download_time;      nrfld: High(struct_tbl_download_time);      group: 1;   arc: 1),      //  tbl_balance_detail
    // DB TEMP
    (PCname: 'MST_SIMULATIONS';      ASname: '';          pfx: 'SIM_';    struct: @struct_tbl_mst_simulations;    nrfld: High(struct_tbl_mst_simulations);    group: 9;   arc: 1),      //  tbl_mst_simulations
    (PCname: 'REPORT';               ASname: '';          pfx: 'QR_';     struct: @struct_tbl_report;             nrfld: High(struct_tbl_report);             group: 9;   arc: 1)      //  tbl_report
  );

  domInfo : array [domain] of TDomInfo = (
    (typ: db_varch; len: 12;   dec: 0),  // dom_ProdReq
    (typ: db_int;   len:  0;   dec: 0),  // dom_longId
    (typ: db_short; len:  0;   dec: 0),  // dom_midId   Avi - shoul be  len = 5
    (typ: db_short; len:  0;   dec: 0),  // dom_shortId  Avi - should be len = 3
    (typ: db_short; len:  0;   dec: 0),  // dom_shtstId
    (typ: db_dec;   len:  9;   dec: 2),  // dom_quant
    (typ: db_varch; len:  6;   dec: 0),  // dom_longChId
    (typ: db_varch; len:  4;   dec: 0),  // dom_shortChId
    (typ: db_varch; len: 10;   dec: 0),  // dom_code
    (typ: db_varch; len:  5;   dec: 0),  // dom_codeWctr
    (typ: db_varch; len: 10;   dec: 0),  // dom_usr
    (typ: db_varch; len:  3;   dec: 0),  // dom_Dom_Cal
    (typ: db_dec;   len:  9;   dec: 2),  // dom_durMin
    (typ: db_dec;   len:  9;   dec: 4),  // dom_durMinMulti
    (typ: db_tmStp; len:  0;   dec: 0),  // dom_timing
    (typ: db_varch; len: 30;   dec: 0),  // dom_text30
    (typ: db_varch; len: 35;   dec: 0),  // dom_text35
    (typ: db_varch; len: 40;   dec: 0),  // dom_text40
    (typ: db_varch; len: 50;   dec: 0),  // dom_text50
    (typ: db_varch; len: 110;  dec: 0),  // dom_text110
    (typ: db_varch; len: 250;  dec: 0),  // dom_text250
    (typ: db_varch; len: 14;   dec: 0),  // dom_text14
    (typ: db_varch; len: 20;   dec: 0),  // dom_text20
    (typ: db_varch; len: 10;   dec: 0),  // dom_text10
    (typ: db_varch; len: 70;   dec: 0),  // dom_Info
    (typ: db_varch; len: 35;   dec: 0),  // dom_family
    (typ: db_varch; len:  3;   dec: 0),  // dom_Category
    (typ: db_short; len:  0;   dec: 0),  // dom_intCode
    (typ: db_int;   len:  0;   dec: 0),  // dom_Weight
    (typ: db_varch; len:  2;   dec: 0),  // dom_UM
    (typ: db_varch; len: 20;   dec: 0),  // dom_propVal - property value
    (typ: db_ch;    len:  1;   dec: 0),  // Type options (1-2-3)
    (typ: db_dec;   len:  7;   dec: 2),  // Type Batch Size
    (typ: db_varch; len:  2;   dec: 0),  // dom_Div
    (typ: db_varch; len:  4;   dec: 0),  // work Center Group
    (typ: db_varch; len:  4;   dec: 0),  // Production Line
    (typ: db_varch; len:  5;   dec: 0),  // Property Code
    (typ: db_short; len:  0;   dec: 0),  // Decimal Number   Avi Should be len = (1,0)
    (typ: db_varch; len: 20;   dec: 0),  // property base value
    (typ: db_dec;   len: 14;   dec: 4),  // Value to add rsc
    (typ: db_varch; len:  2;   dec: 0),  // Property Rules
    (typ: db_varch; len:  3;   dec: 0),  // Prod Type
    (typ: db_varch; len: 20;   dec: 0),  // dom_ConnKey
    (typ: db_short; len:  0;   dec: 0),  // dom_NumOfLevel
    (typ: db_dec  ; len:  5;   dec: 0),  // dom_NumRscComp
    (typ: db_dec  ; len:  9;   dec: 3),  // dom_NumResPlan
    (typ: db_dec  ; len: 11;   dec: 3),  // dom_TimeSteps
    (typ: db_varch; len: 5;    dec: 0),  // dom_AddiCode
    (typ: db_dec;   len: 14;   dec: 4),  // dom_multiToBatchUm
    (typ: db_ch;    len: 1;    dec: 0),  // dom_Flag
{$ifdef ARO }
    (typ: db_varch; len: 15;   dec: 0),  // text 1024
{$endif}
    (typ: db_varch; len:1024;  dec: 0)  // text 1024

    );


  fldInfo : array[fldId] of TFldInfo = (
({$ifdef DEVELOP}fInfo: fli_ArtType;  {$endif}                              name: 'ART_TYPE';                    dom: dom_ProdType),
({$ifdef DEVELOP}fInfo: fli_stGroup;{$endif}                                name: 'ST_GROUP';                    dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_ForcedGroup;{$endif}                            name: 'GRP_FORCED';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ForcedGroupNo;{$endif}                          name: 'FORCED_GRP_NO';               dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_StepIsGrouped;{$endif}                          name: 'STEP_IS_GRPED';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ConnForwardSubStep;{$endif}                     name: 'FWD_SUBSTEP';                 dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_ConnForwardReProcess;{$endif}                   name: 'FWD_REPROC_SUBSTEP';          dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_ConnBackwardSubStep;{$endif}                    name: 'BKW_SUBSTEP';                 dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_ConnBackwardReProcess;{$endif}                  name: 'BKW_REPROC_SUBSTEP';          dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_SaveAtLeastOnesAsFinnal;{$endif}                name: 'SAVES_AT_LEAST_ONES_FINNAL';  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_quant;{$endif}                                  name: 'QTY';                         dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_quantHost;{$endif}                              name: 'QTY_HOST';                    dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_subLinRscId;{$endif}                            name: 'PROD_SUBLIN_RSC';             dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Operation;{$endif}                              name: 'OPERATION';                   dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_vers;{$endif}                                   name: 'VERS_NO';                     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_rsc;{$endif}                                    name: 'RSC_CODE';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_rscHost;{$endif}                                name: 'RSC_CODE_HOST';               dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_bch;{$endif}                                    name: 'BCH_CODE';                    dom: dom_UM),
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
({$ifdef DEVELOP}fInfo: fli_schedType;{$endif}                              name: 'SCHED_TYPE';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_planEnd;{$endif}                                name: 'PLAN_END';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ganntStart;{$endif}                             name: 'GNTSTART';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ganntEnd;{$endif}                               name: 'GNTEND';                      dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_preqNo;{$endif}                                 name: 'PREQ_NO';                     dom: dom_ProdReq),
({$ifdef DEVELOP}fInfo: fli_preqNo_From;{$endif}                            name: 'PREQ_NO_FROM';                dom: dom_ProdReq),
({$ifdef DEVELOP}fInfo: fli_PrevProdNum;{$endif}                            name: 'PREV_PREQ_NO';                dom: dom_ProdReq),
({$ifdef DEVELOP}fInfo: fli_preqStatus;{$endif}                             name: 'PROD_STATUS';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_HistoriclReq;{$endif}                           name: 'HISTORICAL_REQ';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ReqOrigin;{$endif}                              name: 'REQ_ORIGIN';                  dom: dom_UM),
({$ifdef DEVELOP}fInfo: fli_HistoriclData;{$endif}                          name: 'HISTORICAL_DATE';             dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ProdUMCode;{$endif}                             name: 'PROD_UM';                     dom: dom_UM),
({$ifdef DEVELOP}fInfo: fli_ProdFamily;{$endif}                             name: 'PROD_FAMILY';                 dom: dom_text110),
({$ifdef DEVELOP}fInfo: fli_MaterialFamily;{$endif}                         name: 'MATERIAL_FAMILY';             dom: dom_text110),
({$ifdef DEVELOP}fInfo: fli_um;{$endif}                                     name: 'UM';                          dom: dom_Um),
({$ifdef DEVELOP}fInfo: fli_pstepId;{$endif}                                name: 'PSTEP_ID';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_pstepId_From;{$endif}                           name: 'PSTEP_ID_FROM';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_infoLineNum;{$endif}                            name: 'INFO_LINE_NUM';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_InfoArea;{$endif}                               name: 'INFO_AREA';                   dom: dom_Info),
({$ifdef DEVELOP}fInfo: fli_infoType;{$endif}                               name: 'INFO_TYPE';                   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ConnKey;{$endif}                                name: 'CONNE_KEY';                   dom: dom_ConnKey),
({$ifdef DEVELOP}fInfo: fli_ConnType;{$endif}                               name: 'CONNE_TYPE';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_psubstId;{$endif}                               name: 'PSUBST_ID';                   dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_psubstId_From;{$endif}                          name: 'PSUBST_ID_FROM';              dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_NumOfLevel;{$endif}                             name: 'NUM_LEVELS';                  dom: dom_NumOfLevel),
({$ifdef DEVELOP}fInfo: fli_ConnLevel;{$endif}                              name: 'CONN_LEVEL';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ConnCertentyLevel;{$endif}                      name: 'CONN_CERTENT_LEVEL';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_DueDate;{$endif}                                name: 'DUE_DATE';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_reprocNo;{$endif}                               name: 'REPROC_NO';                   dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_reprocNo_From;{$endif}                          name: 'REPROC_NO_FROM';              dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_wkcProc;{$endif}                                name: 'WKCT_PROC';                   dom: dom_shortChId),
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
({$ifdef DEVELOP}fInfo: fli_wkstCode;{$endif}                               name: 'WKST_CODE';                   dom: dom_code),
({$ifdef DEVELOP}fInfo: fli_wkDescr;{$endif}                                name: 'WKDESCR';                     dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_wkPasswd;{$endif}                               name: 'WKPASSWD';                    dom: dom_text10),
({$ifdef DEVELOP}fInfo: fli_wkCtrCode;{$endif}                              name: 'WKCNTER';                     dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_WCProcess;{$endif}                              name: 'WC_PROCESS';                  dom: dom_shortChId),
({$ifdef DEVELOP}fInfo: fli_SchedwkCtrCode;{$endif}                         name: 'SCHED_WCNTER';                dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_SchedWCProcess;{$endif}                         name: 'SCHED_WPROCESS';              dom: dom_shortChId),
({$ifdef DEVELOP}fInfo: fli_wkCtrGroup;{$endif}                             name: 'WK_CNTER_GROUP';              dom: dom_Cntr_Group),
({$ifdef DEVELOP}fInfo: fli_TypOprtion;{$endif}                             name: 'TYP_OPRATION';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_TypProcess;{$endif}                             name: 'TYP_PROCESS';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_CalCod;{$endif}                                 name: 'CAL';                         dom: dom_Cal),
({$ifdef DEVELOP}fInfo: fli_TypeOfUse;{$endif}                              name: 'TYPEUSED';                    dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_SDescr;{$endif}                                 name: 'S_DESCR';                     dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_LDescr;{$endif}                                 name: 'L_DESCR';                     dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_Text;{$endif}                                   name: 'TEXT';                        dom: dom_text250),
({$ifdef DEVELOP}fInfo: fli_RscCat;{$endif}                                 name: 'RES_CATEGORY';                dom: Dom_Category),
({$ifdef DEVELOP}fInfo: fli_addiCode;{$endif}                               name: 'ADD_CODE';                    dom: dom_AddiCode),
({$ifdef DEVELOP}fInfo: fli_ConsumingZone;{$endif}                          name: 'CONSUM_ZONE';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ProcesType;{$endif}                             name: 'PROCES_TYPE';                 dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_Standrd_bch_Size;{$endif}                       name: 'STANDRD_BCH_SIZE';            dom: dom_bch_Size),
({$ifdef DEVELOP}fInfo: fli_BchUM;{$endif}                                  name: 'BCH_UM';                      dom: dom_UM),
({$ifdef DEVELOP}fInfo: fli_Min_bch_size;{$endif}                           name: 'MIN_BCH_SIZE';                dom: dom_bch_Size),
({$ifdef DEVELOP}fInfo: fli_Max_bch_size;{$endif}                           name: 'MAX_BCH_SIZE';                dom: dom_bch_Size),
({$ifdef DEVELOP}fInfo: fli_rscType;{$endif}                                name: 'RSC_TYPE';                    dom: dom_type),
({$ifdef DEVELOP}fInfo: fli_NumOfRsc;{$endif}                               name: 'NUM_RSC_COMP';                dom: dom_NumRscComp),
({$ifdef DEVELOP}fInfo: fli_TabsCode;{$endif}                               name: 'TABCODE';                     dom: Dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TabsDesc;{$endif}                               name: 'TABDESC';                     dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_ActiveOnPc;{$endif}                             name: 'ACTIVONPC';                   dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_ToBeSched;{$endif}                              name: 'TO_SCHED';                    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_splitNextStep;{$endif}                          name: 'SPLIT_NEX_STEP';              dom: dom_Type),
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
({$ifdef DEVELOP}fInfo: fli_NextStep;{$endif}                               name: 'NEX_STEP';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_prevStepSched;{$endif}                          name: 'PRV_STEP_SCHED';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NextStepSched;{$endif}                          name: 'NEX_STEP_SCHED';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_prevStepTrue;{$endif}                           name: 'PRV_STEP_TRUE';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NextStepTrue;{$endif}                           name: 'NEX_STEP_TRUE';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NextStepTimeLimit;{$endif}                      name: 'NEX_STEP_LIMIT_TIME';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_prevStepTimeLimit;{$endif}                      name: 'PRV_STEP_LIMIT_TIME';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_HighEndTimeLimit;{$endif}                       name: 'HIGH_LIMIT_TIMEND';           dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_AllowSplit;{$endif}                             name: 'ALLOW_SPLIT';                 dom: dom_Type),
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
({$ifdef DEVELOP}fInfo: fli_Tbl_Name;{$endif}                               name: 'TABLE_LOCAL_NAME';                  dom: dom_text10),
({$ifdef DEVELOP}fInfo: fli_Tbl_Host;{$endif}                               name: 'TABLE_HOST_NAME';            dom: dom_text10),
({$ifdef DEVELOP}fInfo: fli_CanStepOverlap;{$endif}                         name: 'CAN_STEP_OVERLAP';            dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_CanOverlapNonWrkingHours;{$endif}               name: 'CAN_OVERLAP_NON_WORKING_H';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MinQtyPassNextStp;{$endif}                      name: 'MIN_QTY_PASS_NEXT_STP';       dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_StepCanBeOverlapped;{$endif}                    name: 'CAN_STEP_OVERLAPPED';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StepHandleReProc;{$endif}                       name: 'STEP_HANDLE_REPROCES';        dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StepPartGenralPlan;{$endif}                     name: 'STEP_PART_GEN_PLAN';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StepCanGroup;{$endif}                           name: 'STEP_CAN_GROUP';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MinQtyToStart;{$endif}                          name: 'MIN_QTY_TO_START';            dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_ConnTypToPrevStepSplit;{$endif}                 name: 'CONN_TYPE_PREV_STEP_SPLIT';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_StepClosed;{$endif}                             name: 'STEP_CLOSED';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_OverlapQtyUM;{$endif}                           name: 'OVERLAP_QTY_UM';              dom: dom_UM),
({$ifdef DEVELOP}fInfo: fli_divCode;{$endif}                                name: 'DIV_CODE';                    dom: dom_Div),
({$ifdef DEVELOP}fInfo: fli_dispoCode;{$endif}                              name: 'DSP_CODE';                    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_BinColField;{$endif}                            name: 'BIN_COL_FIELD';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_BinColTitle;{$endif}                            name: 'BIN_COL_TITLE';               dom: dom_text40),
({$ifdef DEVELOP}fInfo: fli_BinColPos;{$endif}                              name: 'BIN_COL_POS';                 dom: Dom_intCode),
({$ifdef DEVELOP}fInfo: fli_BinColWidth;{$endif}                            name: 'BIN_COL_WIDTH';               dom: Dom_intCode),
({$ifdef DEVELOP}fInfo: fli_BinColVisibl;{$endif}                           name: 'BIN_COL_VIS';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_BinColOrder;{$endif}                            name: 'BIN_COL_ORD';                 dom: Dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TabVis;{$endif}                                 name: 'TABVIS';                      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_CategorySDesc;{$endif}                          name: 'DESC';                        dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_CategoryLDesc;{$endif}                          name: 'LONG_DESC';                   dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_Sequence;{$endif}                               name: 'SEQUENCE';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_SeqAlpha;{$endif}                               name: 'SEQALPHA';                    dom: dom_prodType),
({$ifdef DEVELOP}fInfo: fli_AlterWC;{$endif}                                name: 'ALTERN_WC';                   dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_AlterWCProces;{$endif}                          name: 'ALTERN_WC_PROCES';            dom: dom_shortChId),
({$ifdef DEVELOP}fInfo: fli_DateBegin;{$endif}                              name: 'DATE_BEGIN';                  dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_DateEnd;{$endif}                                name: 'DATE_END';                    dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ProdLine;{$endif}                               name: 'PROD_LINE';                   dom: dom_Prod_LineCode),
({$ifdef DEVELOP}fInfo: fli_SubRsc;{$endif}                                 name: 'SUB_RSC';                     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_NumSubRscComponents;{$endif}                    name: 'NUM_RSC_COMPONENTS';          dom: dom_midId),  // Avi not in use ... to check
({$ifdef DEVELOP}fInfo: fli_multipToBatchUm;{$endif}                        name: 'MULTIPILR_To_BATCH_UM';       dom: dom_multiToBatchUm),
({$ifdef DEVELOP}fInfo: fli_Comment;{$endif}                                name: 'COMMENT';                     dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PropertyCode;{$endif}                           name: 'PROPERTY';                    dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_PropSDesc;{$endif}                              name: 'S_DESC';                      dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PropLDesc;{$endif}                              name: 'L_DESC';                      dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PropType;{$endif}                               name: 'TYPE';                        dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ChgPropValCauseResched;{$endif}                 name: 'CNG_PROP_VAL_CAUSE_RESCHED';  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_DecNum;{$endif}                                 name: 'NUM_OF_DEC';                  dom: dom_DecNum),
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
({$ifdef DEVELOP}fInfo: Fli_AddiRsc;{$endif}                                name: 'ADD_RSC';                     dom: dom_AddiCode),
({$ifdef DEVELOP}fInfo: fli_NumHourBforSetup;{$endif}                       name: 'H_BEFOR_SETUP';               dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_NumHourAfterSetup;{$endif}                      name: 'H_AFTER_SETUP';               dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_ValAddAddiRscBeforSetup;{$endif}                name: 'VAL_ADD_ADDIRSC_BEFOR_SETUP'; dom: dom_PropValueAdd),
({$ifdef DEVELOP}fInfo: fli_ValAddAddiRscWhileSetup;{$endif}                name: 'VAL_ADD_ADDIRSC_WHIL_SETUP';  dom: dom_PropValueAdd),
({$ifdef DEVELOP}fInfo: fli_ValAddAddiRscAfterSetup;{$endif}                name: 'VAL_ADD_ADDIRSC_AFTER_SETUP'; dom: dom_PropValueAdd),
({$ifdef DEVELOP}fInfo: fli_CapacyResrv;{$endif}                            name: 'CAPACTY_RESRV';               dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_CapacyResTyp;{$endif}                           name: 'CAPACITY_TYPE';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_Capacity_To_Job;{$endif}                        name: 'CAPACITY_TO_JOB';             dom: dom_PropRules),
({$ifdef DEVELOP}fInfo: fli_Zoom;{$endif}                                   name: 'Zoom';                        dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_supMinBase;{$endif}                             name: 'SUP_BASE';                    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_supMinReal;{$endif}                             name: 'SUP_REAL';                    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_supMinOvlp;{$endif}                             name: 'SUP_Overlap';                 dom: dom_durMin),
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
({$ifdef DEVELOP}fInfo: fli_appSettings;{$endif}                            name: 'sett';                        dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_CheckStepSeq;{$endif}                           name: 'CheckStepSeq';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CenterStartOnMove;{$endif}                      name: 'CenterStartOnMove';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_WarnOnMoveFinal;{$endif}                        name: 'WarnOnMoveFinal';             dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_DefSchedType;{$endif}                           name: 'DefSchedType';                dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ConfLevels;{$endif}                             name: 'ConfLevels';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MoveOption;{$endif}                             name: 'MoveOption';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_ActAutoSchedCode;{$endif}                       name: 'ActAutoSchedCode';            dom: dom_txt14),
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
({$ifdef DEVELOP}fInfo: fli_LowStartDate_From;{$endif}                      name: 'LowStartDate_From';           dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_LowStartDate_To;{$endif}                        name: 'LowStartDate_To';             dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_ShowAlternative;{$endif}                        name: 'SHOW_ALTERNATIVE';            dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Wkcr_FromPlan;{$endif}                          name: 'WC_FROM_PLAN';                dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltPropCode;{$endif}                           name: 'PropCode';                    dom: dom_PropertyCode),
({$ifdef DEVELOP}fInfo: fli_FiltPropRes;{$endif}                            name: 'PropRes';                     dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_filtPropValueFrom;{$endif}                      name: 'PropVal_From';                dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_filtPropValueTo;{$endif}                        name: 'PropVal_To';                  dom: dom_PropBaseValue),
({$ifdef DEVELOP}fInfo: fli_FiltSchedJobs;{$endif}                          name: 'Sched_Jobs';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltFltJobsOnGantt;{$endif}                     name: 'FltJobsOnGantt';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltClosedJobs;{$endif}                         name: 'Closed_Jobs';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_Bin_OnlyReadOnly;{$endif}                       name: 'Only_ReadOnly';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltOnlySchedJobs;{$endif}                      name: 'Only_Sched';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltOnlyClosedJobs;{$endif}                     name: 'Only_Closed';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltGroups;{$endif}                             name: 'Groups';                      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_FiltOnlyGroups;{$endif}                         name: 'Only_Groups';                 dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_SchedStartDate_From;{$endif}                    name: 'SchedStartDate_From';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_SchedStartDate_To;{$endif}                      name: 'SchedStartDate_To';           dom: dom_timing),
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
({$ifdef DEVELOP}fInfo: fli_ValFrom;{$endif}                                name: 'VALUE_FROM';                  dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_ValTo;{$endif}                                  name: 'VALUE_TO';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_intColor;{$endif}                               name: 'INT_COLOR';                   dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_bdrColor;{$endif}                               name: 'BDR_COLOR';                   dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_txtColor;{$endif}                               name: 'TXT_COLOR';                   dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_txtDescription;{$endif}                         name: 'TXT_Description';             dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_LineNum;{$endif}                                name: 'LineNum';                     dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_Selected;{$endif}                               name: 'Selected';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_RscColDesc;{$endif}                             name: 'RscColDesc';                  dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_excOpCode;{$endif}                              name: 'EXC_OP';                      dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_updCode;{$endif}                                name: 'UPD_CODE';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_updOp;{$endif}                                  name: 'UPD_OP';                      dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_TimeDescr;{$endif}                              name: 'TIME_DESCR';                  dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_SetName;{$endif}                                name: 'SET_NAME';                    dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_setIndex;{$endif}                               name: 'SET_INDEX';                   dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_setType;{$endif}                                name: 'SET_TYPE';                    dom: dom_txt14),
({$ifdef DEVELOP}fInfo: fli_fieldType;{$endif}                              name: 'FIELD';                       dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_WorkStation;{$endif}                            name: 'Workstation';                 dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_title;{$endif}                                  name: 'TITLE';                       dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_orgTitle;{$endif}                               name: 'ORG_TITLE';                   dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_checked;{$endif}                                name: 'CHECKED';                     dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_fromPos;{$endif}                                name: 'FROMPOS';                     dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_toPos;{$endif}                                  name: 'TOPOS';                       dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_Lic;{$endif}                                    name: 'LIC_STR';                     dom: dom_text1024),
({$ifdef DEVELOP}fInfo: fli_Ver;{$endif}                                    name: 'VER_NUM';                     dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_LAST_UPD;{$endif}                               name: 'LAST_UPD';                    dom: dom_intCode), //smallint - Vince
({$ifdef DEVELOP}fInfo: fli_SL_OP;{$endif}                                  name: 'SL_OP';                       dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_SL_ON;{$endif}                                  name: 'SL_ON';                       dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_CONNECT;{$endif}                                name: 'CONNECT';                     dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_OP;{$endif}                                     name: 'OP';                          dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_POLL;{$endif}                                   name: 'POLL';                        dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_Mach_stp_code_lvl;{$endif}                      name: 'MACH_SETUP_CODE_LEVEL';       dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_SequenceDepend;{$endif}                         name: 'SEQ_DEPEND';                  dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_PriorityRelation;{$endif}                       name: 'PRIORITY_RALATION';           dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_ResCatcode;{$endif}                             name: 'RES_CAT_CODE';                dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_Desc;{$endif}                                   name: 'DESCRIPTION';                 dom: dom_Info),
({$ifdef DEVELOP}fInfo: fli_ResSetupCode;{$endif}                           name: 'RES_SETUP_CODE';              dom: dom_ProdReq),
({$ifdef DEVELOP}fInfo: fli_SchedWkc;{$endif}                               name: 'SCHED_WKC';                   dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_SchedWkCtrProc;{$endif}                         name: 'SCHED_WKC_PROC';              dom: dom_shortChId),
({$ifdef DEVELOP}fInfo: fli_DependOn;{$endif}                               name: 'DEPEND_ON';                   dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_DepIsSchedRscCat;{$endif}                       name: 'DEP_IS_SCHD_RSC_CAT';         dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_DepIsSchedWkc;{$endif}                          name: 'DEP_IS_SCHD_WKC';             dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_DepIsSchedRsc;{$endif}                          name: 'DEP_IS_SCHD_RSC';             dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_NoSchedRscCat;{$endif}                          name: 'NO_SCHED_RSC_CAT';            dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_NoSchedWkc;{$endif}                             name: 'NO_SCHED_WKC';                dom: dom_CodeWrcr),
({$ifdef DEVELOP}fInfo: fli_NoSchedRsc;{$endif}                             name: 'NO_SCHED_RSC';                dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_highDateAlloc;{$endif}                          name: 'HIGH_DATE_ALLOC';             dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_SearchMatByAlloc;{$endif}                       name: 'SEARCH_MAT_ALLOC';            dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_settled;{$endif}                                name: 'SETTLED';                     dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_AllocQty;{$endif}                               name: 'QTY_ALLOC';                   dom: dom_Quant),
({$ifdef DEVELOP}fInfo: fli_AllocReq;{$endif}                               name: 'ALLOC_REQ';                   dom: dom_ProdReq),
({$ifdef DEVELOP}fInfo: fli_Prod_Balance;{$endif}                           name: 'PROD_BALANCE';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_issueCode;{$endif}                              name: 'ISSUE_CODE';                  dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_quantityIssue;{$endif}                          name: 'QUANTITY_ISSUE';              dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_netGroupCode;{$endif}                           name: 'NET_GROUP_CODE';              dom: dom_code),
({$ifdef DEVELOP}fInfo: fli_ProdCode;{$endif}                               name: 'PRODUCT_CODE';                dom: dom_text110),
({$ifdef DEVELOP}fInfo: fli_orgStep;{$endif}                                name: 'ORG_STEP';                    dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_reqQuant;{$endif}                               name: 'REQ_QUANTITY';                dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_seqIssued;{$endif}                              name: 'SEQ_ISSUED';                  dom: dom_Category),
({$ifdef DEVELOP}fInfo: fli_MatBalance;{$endif}                             name: 'MAT_BALANCE';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MachSetupCode;{$endif}                          name: 'MACHINE_SETUP_CODE';          dom: dom_text10),
({$ifdef DEVELOP}fInfo: fli_AlternativCode;{$endif}                         name: 'ALTERNATIVE_CODE';            dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_searchBalance;{$endif}                          name: 'SEARCH_BALANCE';              dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_waitEntireMat;{$endif}                          name: 'WAIT_ENTIRE_MAT';             dom: dom_flag),
({$ifdef DEVELOP}fInfo: fli_issueTransType;{$endif}                         name: 'ISSUE_TRANS_MAT';             dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_updReqHrs;{$endif}                              name: 'UPD_REQ_HRS';                 dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MatProdType;{$endif}                            name: 'MAT_PROD_TYPE';               dom: dom_Type),
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
({$ifdef DEVELOP}fInfo: fli_NettedQuantity;{$endif}                         name: 'NETTED_QUANTITY';             dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_ChangedQuantity;{$endif}                        name: 'CHANGED_QUANTITY';            dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_downloadType;{$endif}                           name: 'DOWNLOAD_TYPE';               dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_downloadTime;{$endif}                           name: 'DOWNLOAD_DATE_TIME';          dom: dom_timing),
{$ifdef ARO }
({$ifdef DEVELOP}fInfo: fli_material;{$endif}                               name: 'MATERIAL';                    dom: dom_text15),
{$endif}
// DB TEMP
({$ifdef DEVELOP}fInfo: fli_simWkstCode;{$endif}                            name: 'WKST_CODE';                   dom: dom_code),
({$ifdef DEVELOP}fInfo: fli_simCode;{$endif}                                name: 'CODE';                        dom: dom_code),
({$ifdef DEVELOP}fInfo: fli_simDesc;{$endif}                                name: 'DESC';                        dom: dom_text35),
({$ifdef DEVELOP}fInfo: fli_simUsrTmCr;{$endif}                             name: 'DT_CREATE';                   dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_simUsrTmCg;{$endif}                             name: 'DT_CHANGE';                   dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_simActive;{$endif}                              name: 'ACTIVE';                      dom: dom_flag),

//DBReport
({$ifdef DEVELOP}fInfo: fli_AWCLDescr;{$endif}                              name: 'AWCL_DESCR';                   dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_APRLDescr;{$endif}                              name: 'APRL_DESCR';                   dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PWCLDescr;{$endif}                              name: 'PWCL_DESCR';                   dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PPRLDescr;{$endif}                              name: 'PPRL_DESCR';                   dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PTLDescr;{$endif}                               name: 'PTLL_DESCR';                   dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_UMLDescr;{$endif}                               name: 'UML_DESCR';                    dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_RSLDescr;{$endif}                               name: 'RSL_DESCR';                    dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_ARSLDescr;{$endif}                              name: 'ARSL_DESCR';                   dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PlanWkctCode;{$endif}                           name: 'PLAN_WKCT_CODE';               dom: dom_code),
({$ifdef DEVELOP}fInfo: fli_PlanWkctProc;{$endif}                           name: 'PLAN_WKCT_PROC';               dom: dom_shortChId),
({$ifdef DEVELOP}fInfo: fli_ProdLineLDescr;{$endif}                         name: 'PROD_LNL_DESCR';               dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_ProgRsc;{$endif}                                name: 'PROG_RSC_CODE';                dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_LowestPlanStart;{$endif}                        name: 'LOW_PLAN_LIMIT_TIME_STRT';     dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_Desc_Prog_Type;{$endif}                         name: 'DESC_PROG_TYPE';               dom: dom_Info),
({$ifdef DEVELOP}fInfo: fli_SchedID;{$endif}                                name: 'SCHED_ID';                     dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_DescArt;{$endif}                                name: 'DESC_ART';                     dom: dom_Info),
({$ifdef DEVELOP}fInfo: fli_MatCode;{$endif}                                name: 'MAT_CODE';                     dom: dom_Info),
({$ifdef DEVELOP}fInfo: fli_BinSel;{$endif}                                 name: 'BIN_SEL';                      dom: dom_flag),

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
({$ifdef DEVELOP}fInfo: fli_MinJobCapResComp;{$endif}                       name: 'MinJobCapResComp';             dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_DateWgth;{$endif}                               name: 'DateWgth';                     dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_JobResCompWgth;{$endif}                         name: 'JobResCompWgth';               dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_JobJobCompWgth;{$endif}                         name: 'JobJobCompWgth';               dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_JobCapResCompWgth;{$endif}                      name: 'JobCapResCompWgth';            dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_JobSetupChange;{$endif}                         name: 'JobSetupChange';               dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_AfterDelDate;{$endif}                           name: 'AfterDelDate';                 dom: dom_intCode),
//({$ifdef DEVELOP}fInfo: fli_TollAfterDelDate;{$endif}                       name: 'TollAfterDelDate';             dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_AfterHighLimit;{$endif}                         name: 'AfterHighLimit';               dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollAfterHighLimit;{$endif}                     name: 'TollAfterHighLimit';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollAfterHighLimitHours;{$endif}                name: 'TollAfterHighLimitHours';      dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollAfterHighLimitMinutes;{$endif}              name: 'TollAfterHighLimitMinutes';    dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_BeforeLowLimit;{$endif}                         name: 'BeforeLowLimit';               dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollBeforeLowLimit;{$endif}                     name: 'TollBeforeLowLimit';           dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollBeforeLowLimitHours;{$endif}                name: 'TollBeforeLowLimitHours';      dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_TollBeforeLowLimitMinutes;{$endif}              name: 'TollBeforeLowLimitMinutes';    dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_PrefTgtDate;{$endif}                            name: 'PrefTgtDate';                  dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MoveObjsAllowed;{$endif}                        name: 'MoveObjsAllowed';              dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_MoveFinalObjsAlwd;{$endif}                      name: 'MoveFinalObjsAlwd';            dom: dom_intCode),
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
//AutoSchedCfg New fileds
({$ifdef DEVELOP}fInfo: fli_BefEarlDateTol;{$endif}                         name: 'BefEarlDateTol';               dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_WithEarlDateTol;{$endif}                        name: 'WithEarlDateTol';              dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_AfterLatDateTol;{$endif}                        name: 'AfterLatDateTol';              dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_WithLatDateTol;{$endif}                         name: 'WithLatDateTol';               dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PenJobToJob;{$endif}                            name: 'PenJobToJob';                  dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PenSetupMin;{$endif}                            name: 'PenSetupMin';                  dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PenJobToRes;{$endif}                            name: 'PenJobToRes';                  dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PenJobToCapRes;{$endif}                         name: 'PenJobToCapRes';               dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PenJobNotCapRes;{$endif}                        name: 'PenJobNotCapRes';              dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_DateScoreWeight;{$endif}                        name: 'DateScoreWeight';              dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_CompScoreWeight;{$endif}                        name: 'CompScoreWeight';              dom: dom_shortId)

);

  typToStr : array[dbType] of string = (
    'SMALLINT',
    'INTEGER',
    'VARCHAR',
    'CHAR',
    'DATE',
    'TIMESTAMP',
    'DECIMAL'
    );

implementation

uses
  SysUtils;

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
{$ifdef DEVELOP}
  Assert(fldInfo[fld].fInfo = fld);
{$endif}

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

initialization

  s_pfx := ''

//----------------------------------------------------------------------------//
end.











