unit UMTblDescNow;

interface

type

  dbOp = (dbo_none, dbo_ins, dbo_del, dbo_modi);

  dbType  = (db_short, db_int, db_varCh, db_ch, db_date, db_tmStp, db_dec);

  table   = (
              tbl_add_res,
              tbl_alt_wkc,
              tbl_article_type,
              tbl_cal,
              tbl_calendar,
              tbl_download_time,
              tbl_machine_setup_code,
              tbl_proc,
              tbl_prop,
              tbl_prop_capres,
              tbl_prop_res,
              tbl_res,
              tbl_rescat,
              tbl_res_apa,
              tbl_res_sub,
              tbl_rule_occ_to_occ,
              tbl_rule_res_to_occ,
              tbl_unit,
              tbl_wkc,
              tbl_wkc_dependency,
              tbl_wkc_priority,
              tbl_wkc_proc,
              tbl_wkc_prod_line,
              tbl_wkst,
              tbl_wks_wkc,
            	tbl_ext_info,
              tbl_ext_infoHdr,
              tbl_ext_connection,
              tbl_prod_reqConnection,
              tbl_prod_info,
              tbl_prop_prod,
              tbl_prod_req,
              tbl_prod_step,
              tbl_prod_reqHdr,
              tbl_step_batchSize,
              tbl_step_times,
              tbl_sched_progress,
              tbl_nowProgress,
              tbl_material,
              tbl_produced_article,
              tbl_products,
              tbl_balance_header,
              tbl_balance_detail,
              tbl_control,
              tbl_routing_STT,
              tbl_production_DT,
              tbl_production_req_no,
              tbl_logical_warehouse,
              tbl_material_sup_header,
              tbl_material_sup_detail,
              tbl_now_table_names,
              tbl_now_tables_columns,
              tbl_now_Related_table_columns,
              tbl_property_rtv_value,
              tbl_wkc_category,
              tbl_category_dates_info,
              tbl_wkc_penalties,
              tbl_workcenter_and_operation_attributes,
              tbl_production_times_level,
              tbl_production_times,
              tbl_productionProgressTemplate,
              tbl_prod_sched,
              tbl_productionDemandCounter,
              tbl_ProjectNumber,
              tbl_Property_Upload,
              tbl_itemTypeTemplate,
              tbl_alt_warehouse,
              tbl_item_type_logical_warehouse,
              tbl_Now_Download_Entity_Date,
              tbl_LearningCurve,
              tbl_StockDetails,
              tbl_GrpCodeIndex
             );

  domain  = (dom_ProdReq,   // Production Req cod   (12,A)
             dom_longId,    // long identifier      (11,0)
             dom_midId,     // medium identifier    (5,0)
             dom_shortId,   // short identifier     (3,0)
             dom_shtstId,   // shortest identifier  (2,0)
             dom_quant,     // quantity             (9,2)
             dom_longChId,  // character identifier (6,A)
             dom_shortChId, // character identifier (4,A)
             dom_code,      // workstation code     (10,A)
             dom_CodeWrcr,  // work center code     (5,A)
             dom_usr,       // user name            (10,A)
             Dom_Cal,       // Calander Code        (3,A)
             dom_durMin,    // duration in minutes  (9,2)
             dom_durMinLong, // duration Long       (12,5)
             dom_durMinMulti, // time multiplier    (9,4)
             dom_timing,    // timing information   (timestamp)
             dom_text30,    // 30 characters of text (30,A)
             dom_text35,    // 35 characters of text (35,A)
             dom_text40,    // 40 characters of text (40,A)
             dom_text50,    // 50 characters of text (50,A)
             dom_text110,   // 110 characters of text (110,A)
             dom_text250,   // 250 characters of text (250,A)
             dom_txt14,     // 14 characters of text (14,A)
             dom_txt28,     // 14 characters of text (28,A)
             dom_txt20,     // 20 characters of text (20,A)
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
             dom_flag,           // 1 char flag domain (1A)
             don_Hours,          // don_Hours (4,1)
{$ifdef ARO }
             dom_Text15,          // text 15
{$endif}
             dom_Text1024,       // text 1024
             dom_Text8,          // 8 characters of Text (8,A)
             dom_Text100,        // 100 characters of Text (100,A)
             dom_Text15,         // 15 characters of Text (15,A)
             dom_Text6,          // 6 characters of Text (6,A)
             dom_Text4,          // 4 characters of Text (4,A)
             dom_Text111,        // 111 characters of Text (111,A)
             dom_Text14,         // 14 characters of Text (14,A)
             dom_Text3,          // 3 characters of Text (3,A)
             dom_Numeric15_5,     // numeric       (15,5)
             dom_Numeric4_0,      // numeric       (4,0)
             dom_Text2,          // 2 characters of Text (2,A)
             dom_Text20,          // 20 characters of Text (20,A)
             dom_Numeric11_2,     // numeric       (11,2)
             dom_Numeric15_0,     // numeric       (15,0)
             dom_Text70,           // 70 characters of Text (70,A)
             dom_Text25,           // 25 characters of Text (25,A)
             dom_Numeric9_2,     // numeric       (9,2)
             dom_Text5,          // 5 characters of Text (5,A)
             dom_Numeric14_4,     // numeric       (14,4)
             dom_Numeric7_2,     // numeric       (7,2)
             dom_Numeric5_0,     // numeric       (5,0)
             dom_Numeric9_4,      // numeric       (9,4)
             dom_Numeric9_3,      // numeric       (9,3)
             dom_Numeric6_3,      // numeric       (6,3)
             dom_Numeric11_9,     // numeric       (11,9)
             dom_Numeric11_3,      // numeric       (11,3)
             dom_Text9,          // 9 characters of Text (9,A)
             dom_Text60,         // 60 characters of Text (60,A)
             dom_Numeric10_5,    // numeric       (10,5)
             dom_Numeric5_2,    // numeric       (5,2)
             dom_Numeric18_2,    // numeric       (18,2)
             dom_Text16,         // 16 characters of Text (16,A)
             dom_text12    // 12 characters of text (12,A)
            );

  fldId   =  (fli_ArtType,    fli_Group,  fli_ForcedGroup, fli_ForcedGroupNo, fli_StepIsGrouped ,
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
              fli_divCode, fli_dispoCode,
              fli_BinColField, fli_BinColTitle, fli_BinColPos,
              fli_BinColWidth, fli_BinColVisibl, fli_BinColOrder , fli_TabVis, fli_CategorySDesc,
              fli_CategoryLDesc, fli_Sequence, fli_SeqAlpha, fli_AlterWC,  fli_AlterWCProces, fli_DateBegin,
              fli_DateEnd, fli_ProdLine, fli_SubRsc, fli_NumSubRscComponents, fli_multipToBatchUm,
              fli_Comment, fli_PropertyCode, fli_PropSDesc, fli_PropLDesc , fli_PropType,
              fli_ChgPropValCauseResched, fli_PropValTakeForMergeDemands,
              fli_DecNum,
              //fli_CalDate,
              fli_Prog_Wrk_Hr, fli_ChangeType,
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
              fli_PropSetUpOverlappTimeMult, fli_CanBeSameGroup, Fli_AddiRsc,
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
              fli_qtyProduced, fli_sequenceChar, fli_ProductsNature,fli_occupyCode, fli_StartConsumPoint, fli_EndConsumPoint, //
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
              fli_DateScoreWeight, fli_CompScoreWeight,

              //ADD_RES
              fli_ARAdd_Code, fli_ARS_Descr, fli_ARL_Descr, fli_ARConsum_Zone,

              //ALT_WKC
              fli_AWWkCnter, fli_AWWkct_Proc, fli_AWAltern_Wc, fli_AWAltern_Wc_Proces,

              //ARTICLE_TYPE
              fli_ATArt_Type, fli_ATS_Descr, fli_ATL_Descr, fli_ATBalHandledByMqm,
              fli_ATAddDataColumnName, fli_ATProductTypeNature, fli_ATResTimeBeginning,
              fli_ATResTimeEnding, fli_lastPrimaryNR,

              //CAL
              fli_CCal, fli_CS_Descr,

              //CALENDAR
              fli_CaCal, fli_CaCal_Date, fli_CaProg_Wrk_Hr, fli_CaSh1_Start,
              fli_CaSh1_End, fli_CaSh2_Start, fli_CaSh2_End, fli_CaSh3_Start,
              fli_CaSh3_End, fli_CaSh4_Start, fli_CaSh5_End,

              //DOWNLOAD_TIME
              fli_DTDownload_Date_Time,

              //MACHINE_SETUP_CODE
              fli_MSRes_Cat_Code, fli_MSWkcnter, fli_MSWkct_Proc, fli_MSRsc_Code,
              fli_MSDescription, fli_MSMAchine_Setup_Code, fli_MSUsr_Namecr,
              fli_MSUsr_Timecr, fli_MSUsr_Namecg, fli_MSUsr_Timecg,

              //PROC
              fli_PWkct_Proc, fli_PS_Descr,

              //PROP
              fli_PrProperty, fli_PrS_Desc, fli_PrL_Desc, fli_PrType,
              fli_PrProp_Len, fli_PrNum_Of_Dec, fli_PrCng_Prop_Val_Cause_Resched, fli_PrPropValTakeForMergeDemands,
              fli_PrRp_Conn_Lev_Main, fli_PrRp_Add_Wc_Proc, fli_PrRo_Cmpat_Chk,
              fli_PrRo_Conn_Lev_Main, fli_PrRo__Add_Wc_Proc, fli_PrRo_Prod_Typ,
              fli_PrOo_Cmpat_Chk, fli_PrOo_Conn_Lev_Main, fli_PrOo_Add_Wc_Proc,
              fli_PrOo_Prod_Typ, fli_PrMqmrelevance, fli_PrMcmrelevance,
              fli_PrContainsNowProductionOrder,

              //PROP_CAPRES
              fli_PCCapacty_Resrv, fli_PCProperty, fli_PCValue,
              fli_PCUsr_Namecg, fli_PCUsr_Timecg,

              //PROP_RES
              fli_PResWkcnter, fli_PResRes_Category, fli_PResWc_Process,
              fli_PResRsc_Code, fli_PResProperty, fli_PResPropty_Value,
              fli_PResPropty_Calculated_Value, fli_PResAdd_Rsc_Occ, fli_PResVal_Add,
              fli_PResVal_Take_For_Group, fli_PResDft_Case_Rsc_Occ_Ruls,
              fli_PResDft_Case_Occ_Occ_Ruls, fli_PResDft_Same_Grp_Occ_Occ_Ruls,
              fli_PResUsr_Namecr, fli_PResUsr_Timecr, fli_PResUsr_Namecg,
              fli_PResUsr_Timecg,

              //RES
              fli_ResRsc_Code, fli_ResS_Descr, fli_ResL_Descr, fli_ResProces_Type,
              fli_ResWkcnter, fli_ResRes_Category, fli_ResStandrd_Bch_Size,
              fli_ResBch_Um, fli_ResCal, fli_ResRsc_Type, fli_ResNum_Rsc_Comp,
              fli_ResMin_Bch_Size, fli_ResMax_Bch_Size, fli_ResDisplayText1,
              fli_ResDisplayText2,

              //RESCAT
              fli_RCRes_Category, fli_RCDesc, fli_RCLong_Desc,

              //RES_APA
              fli_RARsc_Code, fli_RASub_Rsc, fli_RADate_Begin, fli_RADate_End,
              fli_RANum_Rsc_Comp, fli_RAUsr_Namecr, fli_RAUsr_Timecr,
              fli_RAUsr_Namecg, fli_RAUsr_Timecg,

              //RES_SUB
              fli_RSRsc_Code,  fli_RSSub_Rsc, fli_RSCal, fli_RSProd_Line,
              fli_RSComment, fli_RSNum_Rsc_Comp, fli_RSUsr_Namecr,
              fli_RSUsr_Timecr, fli_RSUsr_Namecg, fli_RSUsr_Timecg,

              //RULE_OCC_TO_OCC
              fli_ROOWkcnter, fli_ROORsc_Code, fli_ROORes_Category,
              fli_ROOWc_Process, fli_ROOProperty, fli_ROOType_Prod,
              fli_ROOLine_Number, fli_ROOSequence, fli_ROODep_On_Curr,
              fli_ROODep_Value, fli_ROORule_Const, fli_ROOOperand,
              fli_ROOCase, fli_ROOSetup_Type, fli_ROOSetup_Time,
              fli_ROOSetup_Overlapping_Time, fli_ROOSetup_Time_Mult,
              fli_ROOOverlapping_Time_Mult, fli_ROOCan_Be_Same_Group,
              fli_ROOUsr_Namecr, fli_ROOUsr_Timecr, fli_ROOUsr_Namecg,
              fli_ROOUsr_Timecg,

              //RULE_RES_TO_OCC
              fli_RROWkcnter, fli_RRORsc_Code, fli_RRORes_Category,
              fli_RROWc_Process, fli_RROProperty, fli_RROType_Prod,
              fli_RROLine_Number, fli_RROSequence, fli_RROOperand,
              fli_RRODep_On_Curr, fli_RRODep_Value, fli_RROCase,
              fli_RROUsr_Namecr, fli_RROUsr_Timecr, fli_RROUsr_Namecg,
              fli_RROUsr_Timecg,

              //UNIT
              fli_UUm, fli_US_Descr, fli_UL_Descr,

              //WKC
              fli_WWkcnter, fli_WWk_Cnter_Group, fli_WS_Descr,
              fli_WL_Descr, fli_WTyp_Opration, fli_WTyp_Process,
              fli_WHandledByMQM, fli_WHandledByMCM, fli_HandledLearningCurve, fli_wkcADForLearningCurveCode,

              //WKC_DEPENDENCY
              fli_WDSched_Wkc, fli_WDSched_Wkc_Proc, fli_WDDepend_On,
              fli_WDDep_Is_Schd_Rsc_Cat, fli_WDDep_Is_Schd_Wkc,
              fli_WDDep_Is_Schd_Rsc, fli_WDNo_Sched_Rsc_Cat, fli_WDNo_Sched_Wkc,
              fli_WDNo_Sched_Rsc, fli_WDUsr_Namecr, fli_WDUsr_Timecr,
              fli_WDUsr_Namecg, fli_WDUsr_Timecg,

              //WKC_PRIORITY
              fli_WPWkcnter, fli_WPWkct_Proc, fli_WPSeq_Depend,
              fli_WPSeqalpha, fli_WPPriority_Ralation, fli_WPMach_Setup_Code_Level,
              fli_WPUsr_Namecr, fli_WPUsr_Timecr, fli_WPUsr_Namecg,
              fli_WPUsr_Timecg,

              //WKC_PROC
              fli_WPrWkcnter, fli_WPrWkct_Proc, fli_WPrS_Descr, fli_WPrL_Descr,
              fli_isNowPrdOrd_MQMGroup, fli_CanBeGroupedInMQM, fli_wkcDefaultForAllowedSplit,
              fli_wkcADForAllowedSplit, fli_wkcADForSplitFamilyCode, fli_wkcProcType, fli_BatchStandTime,

              //WKC_PROD_LINE
              fli_WPDLWkcnter, fli_WPDLProd_Line, fli_WPLDate_Begin, fli_WPLDate_End,
              fli_WPLRes_Num_Pln,

              //WKST
              fli_WSWkst_Code, fli_WSWkdescr, fli_WSWkpasswd, fli_WSUsr_Namecr,
              fli_WSUsr_Timecr, fli_WSUsr_Namecg, fli_WSUsr_Timecg, fli_WSWorkstationtype,

              //WKS_WKC
              fli_WWWkst_Code, fli_WWWkcnter, fli_WWTypeusd, fli_WWVisible,
              fli_WWUsr_Namecr, fli_WWUsr_Timecr, fli_WWUsr_Namecg,
              fli_WWUsr_Timecg,

              //EXT_INFO
              fli_EIConne_Key, fli_EIInfo_Line_Num, fli_EIInfo_Area,
              fli_EIUsr_Namecg, fli_EIUsr_Timecg,
              //fli_EIConnectedKey, fli_EIInformationLineNo, fli_EIInformationArea,
              //fli_EIUserNameChanged, fli_EIDateChanged,

              //EXT_INFO_HDR
              fli_EHConne_Key, fli_EHConne_Type, fli_EHDue_Date,
              fli_EHUsr_Namecg, fli_EHUsr_Timecg,
              //fli_EIHConnectedKey, fli_EIHConnectionType, fli_EIHDueDate,
              //fli_EIHUserNameChanged, fli_EIHDateChanged,

              //EXT_CONNECTION
              fli_ECPreq_No, fli_ECConne_Key, fli_ECNum_Levels,
              fli_ECConn_Certent_Level, fli_ECUsr_Namecg, fli_ECUsr_Timecg,
              //fli_ECProductionRequestNo, fli_ECConnectedKey, fli_ECNumberOfLevels,
              //fli_ECConnectionVertaintyLevel, fli_ECUserNameChanged,
              //fli_ECDateChanged,

              //PROD_REQCONN
              fli_ICPreq_No, fli_ICPrev_Preq_No, fli_ICUsr_Namecg,
              fli_ICUsr_Timecg,
              //fli_PRCProductionRequestNo, fli_PRCPreviousProductionNo,
              //fli_PRCConnectionType, fli_PRCUserNameChanged, fli_PRCDateChanged,

              //PROD_INFO
              fli_PIPreq_No, fli_PIInfo_Type, fli_PIPstep_Id,
              fli_PIInfo_Line_Num, fli_PIInfo_Area, fli_PIUsr_Namecg,
              fli_PIUsr_Timecg,
              //fli_PIDefault, fli_PIProductRequestNo, fli_PIProductionStep,
              //fli_PIInfoType, fli_PIInformationLineNo, fli_PIInformationArea,
              //fli_PIUserNameChanged, fli_PIDateChanged,

              //PROP_PROD
              fli_PPPreq_No, fli_PPPStep_Id, fli_PPProperty,
              fli_PPRsc_Code, fli_PPValue, fli_PPUsr_Namecg, fli_PPUsr_Timecg, fli_PPNumericVal,
              //fli_PPDefault, fli_PPProductRequestNo, fli_PPProductionStep,
              //fli_PPResourceCode, fli_PPPropertyCode, fli_PPPropertyValue,
              //fli_PPUserNameChanged, fli_PPDateChanged,

              //PROD_REQ
              fli_PRDiv_Code, fli_PRDsp_Code, fli_PRBch_Code,
              fli_PRReproc_No, fli_PRPreq_No, fli_PRHistorical_Req,
              fli_PRUsr_Namecg, fli_PRUsr_Timecg, fli_PRModulehandle,
              fli_PRMqm_Historic_Date, fli_PRTemplateCode, fli_PRFamilyCode, fli_PRIsFamily,

              //PROD_STEP
              fli_PDPreq_No, fli_PDPstep_Id, fli_PDUpd_Code,
              fli_PDToSched, fli_PDPrv_Step_Sched, fli_PDPrv_Step_True,
              fli_PDNex_Step_Sched, fli_PDNex_Step_True, fli_PDStepType,
              fli_PDMat_Arrv_Date, fli_PDFrc_Mat_Date, fli_PDPlan_Start,
              fli_PDLow_Limit_Time_Strt, fli_PDFrc_Low_Date,
              fli_PDPlan_End, fli_PDHigh_Limit_Timeend, fli_PDFrc_High_date,
              fli_PDWkcnter, fli_PDWkct_Proc, fli_PDInit_Quent,
              fli_PDFin_Quent, fli_PDWeight, fli_PDDesc_um, fli_PDCal,
              fli_PDSetup_Time_Stp, fli_PDExc_Time_Stp, fli_PDRes_Num_Pln,
              fli_PDAllow_Split,  fli_PDStep_Handle_Reproces,
              fli_PDStep_Part_Gen_Plan, fli_PDStep_Can_Group,
              fli_PDForced_Grp_No,fli_PDForced_Grp_No_Str, fli_GroupStepNumber, fli_PDConn_Type_Prev_Step_Split,
              fli_PDFrc_Overlapp, fli_PDStep_Closed, fli_PDUsr_Namecg,
              fli_PDUsr_Timecg, fli_PDMcmapplydatepenalty,
              fli_PDMcmleadqueuetimeprevstep, fli_PDMcmmaxjobsgap,
              fli_PDMcmmaxstepsgap, fli_PDSchdule_By_Mcm, fli_PDSplitFamaly,
              fli_LearningCurveCode, fli_PDLearningCurveType, fli_PDApprovalDate,

              //PROD_REQHDR
              fli_PHPreq_No, fli_PHUpd_Code, fli_PHHistorical_Req,
              fli_PHReq_Origin, fli_PHProd_Line, fli_PHType_Prod, fli_PHProd_Family,
              fli_PHMaterial_Family, fli_PHProd_Um, fli_PHProd_Low_Time_Strt,
              fli_PHProd_Delivy_Date, fli_PHFrc_Del_Date, fli_PHUsr_Namecg,
              fli_PHUsr_Timecg, fli_PHMcm_Requesttype, fli_PHMcm_Capacitysearch,
              fli_PHMcm_Materialsearch, fli_PHMcm_Requesteddate,
              fli_PHMcm_Requesteddatetype, fli_PHMcm_Priority, fli_PHMcm_Loaderdays,
              fli_PHModulehandle, fli_PHSplitConfLevels, fli_PHLead_Step_Splited,
              fli_PHServing_Code, fli_PHServed_Code,
              //fli_PHSplitStartPosition, fli_PHSplitEndPosition, fli_PHMqmSplitId,

              //PROD_STEP_BATCH_SIZE
              fli_SBPreq_No, fli_SBPStep_Id, fli_SBBch_Um, fli_SBMultipilr_To_Batch,
              //fli_SBProductionRequestNo, fli_SBProductionStep, fli_SBBatchSizeUM,
              //fli_SBMultiplier,

              //PROD_STEP_TIMES
              fli_STPreq_No, fli_STPstep_Id, fli_STWkcnter, fli_STWkct_Proc,
              fli_STRes_Category, fli_STRsc_Code, fli_STMachine_Setup_Code,
              fli_STSetup_Time_Job, fli_STExc_Time_Init_Qty,
              //fli_STProductionRequestNo, fli_STProductionStep, fli_STWorkCenter,
              //fli_STWorkCenterProcess, fli_STResourceCategoryCode, fli_STResourceCode,
              //fli_STResourceSetupCode, fli_STSetupTimePlanned, fli_STExecutionTimePlanned,

              //PROD_SCHED_PROGRESS
              fli_SPPreq_No, fli_SPPstep_Id, fli_SPPsubst_Id, fli_SPReproc_No,
              fli_SPLast_Prog_Type, fli_SPRsc_Code, fli_SPProgresed_Group,
              fli_SPProgrstart, fli_SPCurr_Prg_Date, fli_SPProgrend,
              fli_SPQty, fli_SPRemain_Time, fli_SPLast_Prog_Type_Host,
              fli_SPRsc_Code_Host, fli_SPProgrstart_Host,
              fli_SPCurr_Prg_Date_Host, fli_SPProgend_Host, fli_SPQty_Host,
              fli_SPRemain_Time_Host,

              //NowProgress - local data

              fli_NP_ProgressNumber,  //8
              fli_NP_ProgressTemplateCode,
              fli_NP_DemandCounterCode,  //8
              fli_NP_DemandCode,         // 15
              fli_NP_DemandStep,         // 5 decimal
              fli_NP_DemandTemplateCode,       // 3
              fli_NP_OriginalEndDate,    //  datetime
              fli_NP_StartDate,
              fli_NP_EndDate,
              fli_NP_ResourceCode,
              fli_NP_PrimaryQty,
              fli_NP_PrimaryUOmCode,    // 3
              fli_NP_SecondaryQty,
              fli_NP_SecondaryUOmCode, // 3
              fli_NP_PackagingQty,
              fli_NP_PackagingUOmCode, // 3
              fli_NP_PercentInProgress,
              fli_NP_FinalToInitialDivider, //11,9
              fli_NP_ClosedStep,
              fli_NP_BasePrimaryUoMCode,
              fli_NP_MultiplierToBasePrimaryUoMCode,

              //fli_SPProductionRequestNo, fli_SPProductionStep, fli_SPSubStep,
              //fli_SPReprocess, fli_SPUpdatedProgressStatus, fli_SPResourceCode,
              //fli_SPStepGroup, fli_SPStartDate, fli_SPCurrentDate,
              //fli_SPEndDate, fli_SPProgressedQuantity, fli_SPRemainingTime,

              //MATERIAL
              fli_MTPreq_No, fli_MTPstep_Id, fli_MTOrg_Step, fli_MTWkcnter,
              fli_MTRes_Cat_Code, fli_MTRsc_Code, fli_MTMachine_Setup_Code,
              fli_MTAlternative_Code, fli_MTType_Prod, fli_MTProduct_Code,
              fli_MTNet_Group_Code, fli_MTIssue_Code, fli_MTSeq_Issued,
              fli_MTMat_Balance, fli_MTQty_Alloc, fli_MTHigh_Date_Alloc,
              fli_MTSearch_Mat_Alloc, fli_MTSettled, fli_MTQuantity_Issue,
              fli_MTReq_Quantity,
              //fli_MDefault, fli_MProductionRequestNo, fli_MTargetStep,
              //fli_MProductionStep, fli_MWorkCenter, fli_MResourceCategoryCode,
              //fli_MResourceCode, fli_MResourceSetupCode, fli_MAlternativeCode,
              //fli_MProductType, fli_MProductCode, fli_MNetGroupCode,
              //fli_MIssueCode, fli_MSequenceIssuedTo, fli_MRequiredQuantity,
              //fli_MQuantityIssued, fli_MAllocatedQuantity, fli_MSettled,
              //fli_MMaxDateAllocatedBy, fli_MSearchMaterialsOnlyByAllocation,
              //fli_MMaterialBalance, fli_MUserNameChanged, fli_MDateChanged,

              //PRODUCED_ARTICLE
              fli_PAPreq_No, fli_PASequence, fli_PAProduct_Code,
              fli_PANet_Group_Code, fli_PAAlloc_Req, fli_PAProd_Balance,
              fli_PARsc_Code, fli_PASettled, fli_PAReq_Quantity,
              fli_PAQty_Produced, fli_PAQty_Alloc,
              //fli_PADefault, fli_PAProductionRequestNo, fli_PASequenceOfLine,
              //fli_PAProductCode, fli_PANetGroupCode, fli_PAAllocatedToRequestNo,
              //fli_PAClosed, fli_PAResource, fli_PARequiredQuantity,
              //fli_PAProducedQuantity, fli_PAAllocatedQuantity, fli_PAMaterialBalance,
              //fli_PAUserNameChanged, fli_PADateChanged,

              //PRODUCTS
              fli_PARType_Prod, fli_PARProduct_Code, fli_PARProduct_Nature,
              fli_PARStr_Cons_Point, fli_PAREnd_Cons_Point, fli_PARInfo_Area,
              fli_PARStdpurcorprodtime,
              //fli_ProductDefault, fli_ProductType, fli_ProductCode,
              //fli_ProductNature, fli_ProductAdditionalResourceStartsFrom,
              //fli_ProductAdditionalResourceEndsAfter, fli_ProductDescription,
              //fli_ProductUserNameChanged, fli_ProductDateChanged,

              //BALANCE_HEADER
              fli_BHType_Prod, fli_BHProduct_Code, fli_BHNet_Group_Code,
              fli_BHDue_Date, fli_BHQty, fli_BHInfo_Area, fli_BHUsr_Namecg,
              fli_BHUsr_Timecg,
              //fli_BHProductType, fli_BHProductCode, fli_BHNettingCode,
              //fli_BHDueDate, fli_BHQuantity, fli_BHDescription,
              //fli_BHUserNameChanged, fli_BHDateChanged,

              //BALANCE_DETAIL
              fli_BDType_Prod, fli_BDProduct_Code, fli_BDNet_Group_Code,
              fli_BDDue_Date, fli_BDOccupy_Code, fli_BDInfo_Area,
              fli_BDQty, fli_BDUsr_Namecg, fli_BDUsr_Timecg,
              //fli_BDProductType, fli_BDProductCode, fli_BDNettingCode,
              //fli_BDDueDate, fli_BDOccupyCode, fli_BDQuantity,
              //fli_BDDescription, fli_BDUserNameChanged, fli_BDDateChanged,

              // MQMCN00F
              fli_ControlServerStatus, fli_ControlServerStarted, fli_ControlServerEnded,
              fli_ControlClientStatus, fli_ControlClientStarted, fli_ControlClientEnded,
              fli_ControlClientLastOperation, fli_ControlClientLastUploadSuccess,
              fli_ControlServerCanUpdate, fli_ControlServerUpdateTime,

              // WCMAC00F
              fli_WorkCenterDefault, fli_WorkCenterCode, fli_WorkCenterGroup,
              fli_WorkCenterShortDesc, fli_WorkCenterLongDesc,
              fli_WorkCenterBatchContFlag, fli_WorkCenterDummyField, fli_HandledByMQM,

              // TABLE00F
              fli_ITDefault, fli_ITTable, fli_ITKey, fli_ITData,

              // WCPRO00F
              fli_WCODefault, fli_WCOWorkCenterCode, fli_WCOWorkCenterOperationCode,
              fli_WCOWorkCenterShortDesc, fli_WCOWorkCenterLongDesc,

              //PGTUR00F
              fli_CalDefault, fli_CalCode, fli_CalDate, fli_CalProgressiveHours,
              fli_CalFirstShiftStart, fli_CalFirstShiftEnd, fli_CalSecondShiftStart,
              fli_CalSecondShiftEnd, fli_CalThirdShiftStart, fli_CalThirdShiftEnd,
              fli_CalFourthShiftStart, fli_CalFourthShiftEnd, fli_CalUserNameChanged,
              fli_CalDateChanged,

              //ROUTINGSTEPTIMETYPE
              fli_RSTTCode, fli_RSTTShortDescription, fli_RSTTType,
              fli_RSTTApply, fli_RSTTApplyTypeCode,

              //PRODUCTIONDEMANDTEMPLATE
              fli_PDTCode, fli_PDTShortDesc, fli_PDTHandledByMQM, fli_PDTHandledByMCM,
              fli_PDTApplyDatePenalty, fli_PDTMaxGapBtwEndDates, fli_PDTMaxGapBtwEndStrDates,
              fli_PDTMcmRequestType, fli_PDTSearchCapacity, fli_PDTCapAddDataTableName,
              fli_PDTCapAddDataColumnName, fli_PDTSearchMaterial, fli_PDTMatAddDataTableName,
              fli_PDTMatAddDataColumnName, fli_PDTRequestDateType, fli_PDTLoadPriority,
              fli_PDTPriAddDataTableName, fli_PDTPriAddDataColumnName, fli_PDTAutoLoaderDays,
              fli_PDTDaysToKeepHistory, fli_PDTDemandKeyLinkAdditionalData, fli_PDServedCodeTableName,
              fli_PDServedCodeColumName, fli_PDServingCodeTableName, fli_PDServingCodeColumName,
              fli_PDServingDefinition, fli_PDServedDefinition, fli_PDServedItemType,

              //PRODUCTION_REQ_NO
              fli_PRNProductionRequestNo,

              //LOGICALWAREHOUSE
              fli_LWCode, fli_LWShortDesc, fli_LWMqmGroupCode,

              //MATERIAL_SUP_HEADER
              fli_MSHWkcnter, fli_MSHWkct_Proc, fli_MSHRes_Cat_Code,
              fli_MSHRsc_Code, fli_MSHType_Prod, fli_MSHWait_Prev_Qty,
              fli_MSHMin_Qty_Pass_Nxt, fli_MSHMin_Qty_Prev_Stp,
              fli_MSHMin_Del_Wait_Days, fli_MSHMin_Del_Wait_Hrs,
              fli_MSHMin_Del_Wait_Min, fli_MSHMax_Del_Wait_Days,
              fli_MSHMax_Del_Wait_Hrs, fli_MSHMax_Del_Wait_Min,
              fli_MSHPart_Del, fli_MSHUpd_Bal_Hrs, fli_MSHUpd_Bal_Qty,
              fli_MSHUpd_Req_Prev_Stp_Hrs, fli_MSModulerule,

              //MATERIAL_SUP_DETAIL
              fli_MSDWkcnter, fli_MSDWkct_Proc, fli_MSDRes_Cat_Code,
              fli_MSDRsc_Code, fli_MSDType_Prod, fli_MSDSearch_Balance,
              fli_MSDWait_Entire_Mat, fli_MSDIssue_Trans_Mat, fli_MSDMinQty,
              fli_MSDUpd_Req_Hrs, fli_MSDMat_Prod_Type, fli_MSDModulerule,

              //NOW_TABLE_NAMES
              fli_NTNTable_Name,

              //NOW_TABLES_COLUMNS
              fli_NTCTable_Name, fli_NTCColumn_Name, fli_NTCType_Name,
              fli_NTCLength, fli_NTCScale, fli_NTCRelatedEntityClassName,

              //PROPERTY_RTV_VALUE
              fli_PRVProperty, fli_PRVItemType, fli_PRVTable_Name,
              fli_PRVColumn_Name, fli_PRVRelated_ColumName, fli_PRVFromPosition, fli_PRVLength,

              //WKC_CATEGORY
              fli_WCAWkcnter, fli_WCACategory, fli_WCAMixresgroups, fli_WCACal,
              fli_WCAUsr_Namecg, fli_WCAUsr_Timecg,

              //CATEGORY_DATES_INFO
              fli_CDWkcnter, fli_CDCategory, fli_CDDate_Begin, fli_CDNum_Of_Machines,
              fli_CDFinitecapacity, fli_CDUsr_Namecg, fli_CDUsr_Timecg,

              //WKC_PENALTIES
              fli_PNPlan_Wkct_Code, fli_PNPlan_Wkct_Proc, fli_PNCompcasenum,
              fli_PNDayspanelty, fli_PNUsr_Namecg, fli_PNUsr_Timecg,

              //WORKCENTERANDOPERATTRIBUTES
              fli_WOAWorkcenterCode, fli_WOAOperationCode, fli_WOACode,
              fli_WOAShortDescription,
              fli_WOAStandardStepQuantity, fli_WOAStandardStepQtyUomCode,
              fli_WOAStepEfficiencyApply, fli_WOAStepEfficiency,
              fli_WOATimeType1Code, fli_WOATime1, fli_WOATimeUnit1,
              fli_WOATimeRefQty1, fli_WOATimeRefUom1Code, fli_WOATimeType2Code,
              fli_WOATime2, fli_WOATimeUnit2, fli_WOATimeRefQty2,
              fli_WOATimeRefUom2Code, fli_WOATimeType3Code,
              fli_WOATime3, fli_WOATimeUnit3, fli_WOATimeRefQty3,
              fli_WOATimeRefUom3Code, fli_WOATimeType4Code, fli_WOATime4,
              fli_WOATimeUnit4, fli_WOATimeRefQty4, fli_WOATimeRefUom4Code,
              fli_WOATimeType5Code, fli_WOATime5, fli_WOATimeUnit5,
              fli_WOATimeRefQty5, fli_WOATimeRefUom5Code,

              //PRODUCTION_TIMES_LEVEL
              fli_PTLWorkCenterCode, fli_PTLOperation, fli_PTLProductType,
              fli_PTLHandle_Times_By, fli_PTLTableName1, fli_PTLColumnName1,
              fli_PTLTableName2, fli_PTLColumnName2, fli_PTLTableName3,
              fli_PTLColumnName3, fli_PTLTableName4, fli_PTLColumnName4,
              fli_PTLTableName5, fli_PTLColumnName5, fli_PTLTableName6,
              fli_PTLColumnName6, fli_PTLTableName7, fli_PTLColumnName7,
              fli_PTLTableName8, fli_PTLColumnName8, fli_PTLTableName9,
              fli_PTLColumnName9, fli_PTLTableName10, fli_PTLColumnName10,

              //PRODUCTION_TIMES
              fli_PTKey, fli_PTWorkCenter, fli_PTOperation, fli_PTProductType,
              fli_PTTableName1ColumnName1Value, fli_PTTableName1ColumnName2Value,
              fli_PTTableName1ColumnName3Value, fli_PTTableName1ColumnName4Value,
              fli_PTTableName1ColumnName5Value, fli_PTTableName1ColumnName6Value,
              fli_PTTableName1ColumnName7Value, fli_PTTableName1ColumnName8Value,
              fli_PTTableName1ColumnName9Value, fli_PTTableName1ColumnName10Value,
              fli_PTResourceCategory, fli_PTResource,
              fli_PTSetupTime, fli_PTBatchTime, fli_PTContinuousTime,
              fli_PTContinuousOpUM, fli_PTConsiderStepEfficiency, fli_PTCode,
              fli_PTSetupTimeMultiplier, fli_PTOperationTimeMultiplier,

              //PRODUCTIONPROGRESSTEMPLATE
              fli_PPTCode, fli_PPTS_Descr, fli_PPTL_Descr, fli_PPTHandledByMQM,
              fli_PPTHandledByMCM, fli_PPTQuantityType,

              //PROD_SCHED
              fli_PSPreqNo, fli_PSPStepId, fli_PSPsubstId, fli_PSReprecNo,
              fli_PSVersNo, fli_PSUpdCode, fli_PSUpdOp, fli_PSTypeProd,
              fli_PSProdLine, fli_PSProdUm, fli_PSStepType, fli_PSInitQuent,
              fli_PSStGroup, fli_PSStepIsGrped, fli_PSSchedType,  fli_PSWkcnter,
              fli_PSWkctProc, fli_PSAlternativeCode, fli_PSRscCode, fli_PSProdSublinRsc,
              fli_PSNumRscComponents, fli_PSQty, fli_PSSupBase, fli_PSSupReal,
              fli_PSSupOverlap, fli_PSExeMin, fli_PSSchStart, fli_PSSchEnd,
              fli_PSComment, fli_PSFwdSubstep, fli_PSFwdReprocSubstep,
              fli_PSBkwSubstep, fli_PSBkwReprocSubstep, fli_PSSavesAtLeastOnesFinnal,
              fli_PSNettedQuantity, fli_PSChangedQuantity, fli_PSMachineSetupCode,
              fli_PSUsr_Namecr, fli_PSUsr_Timecr, fli_PSUsr_Namecg, fli_PSUsr_Timecg,
              fli_PSBinSel, fli_PSProgOverrideType, fli_PSEkcnterKetSt, fli_PSWcProcessKeySt,
              fli_PSResKeySt, fli_PSResCatKeySt, fli_NewPreqUniqId, fli_PSSplitFamaly,

              //PRODUCTIONDEMANDCOUNTER
              fli_PDCCode, fli_PDCShortDesc, fli_PDCFamilyCodeEndPosition,

              //ProjectNumber
              fli_PNProjectCode,
              fli_PNNumber,

              //ITEMTYPETEMPLATE
              fli_ITTItemTypeCode, fli_ITTProductionDemandTemplateCode,
              fli_ITTHostSplitConfirmLevel, fli_ITTWorkcenterForSplit,
              fli_ITTOperationForSplit,

              //ALTERNATIVEWAREHOUSE
              fli_AWHWkcenter, fli_AWHAltern_Wc, fli_AWHNet_Group_Code,
              fli_AWHIssueItemType, fli_AWHAltern_Net_Group_Code,

              //ITEMTYPELOGICALWAREHOUSE
              fli_ITLWItemTypeCode, fli_ITLWLogicalWarehouseCode,
              fli_ITLWNetGroupReservationTableName, fli_ITLWNetGroupReservationColumnName,
              fli_ITLWNetGroupDemandTableName, fli_ITLWNetGroupDemandColumnName, fli_ITLWConnBtwStockAndResrv,
              fli_ITLWSeparetBtwAttributes, fli_ITLW1stcolumn,
              fli_ITLWdspBeforecolumn2, fli_ITLW2stcolumn, fli_ITLWdspBeforecolumn3, fli_ITLW3stcolumn, fli_ITLWdspBeforecolumn4, fli_ITLW4stcolumn,
              fli_ITLWdspBeforecolumn5, fli_ITLW5stcolumn, fli_ITLWdspBeforecolumn6, fli_ITLW6stcolumn,

              //NowDownloadEntityDate
              fli_NDEntityName, fli_NDDate,

              // LearningCurve
              fli_LearningCurveDesc,
              fli_CurveFirstHours, fli_CurveFirstEffic,
              fli_CurveSecondHours, fli_CurveSecondEffic,
              fli_CurveThirdHours, fli_CurveThirdEffic,
              fli_CurveForthHours, fli_CurveForthEffic,
              fli_CurveFifthhHours, fli_CurveFifthEffic,

              // StockDetails

              fli_Details, fli_used, fli_BalanceIdentifier,







             // GrpCodeIndex
              fli_GrpIndex, fli_GrpCode

  );


  TInfoStruct = record
    fInfo  : fldId;
    nrkey  : byte;
    notnull: boolean;
    defval : shortint;
  end;

  structOut = array[0..800] of TInfoStruct;

  TTblInfo = record
    PCname: string;
    ASname: string;
    pfx   : string;
//    struct: array of TInfoStruct; not compile in Tokio (delphi 10.23).
    struct: ^structOut;
    nrfld : integer;
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

  struct_tbl_add_res : array[1..4] of TInfoStruct = (
    (fInfo: fli_ARAdd_Code;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ARS_Descr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ARL_Descr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ARConsum_Zone;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_alt_wkc : array[1..4] of TInfoStruct = (
    (fInfo: fli_AWWkcnter;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_AWWkct_Proc;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_AWAltern_Wc;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_AWAltern_Wc_Proces;                nrkey: 0;   notnull: false;    defval : -1)
  );

  struct_tbl_article_type : array[1..9] of TInfoStruct = (
    (fInfo: fli_ATArt_Type;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ATS_Descr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ATL_Descr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ATBalHandledByMqm;                 nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_ATAddDataColumnName;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ATProductTypeNature;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ATResTimeBeginning;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ATResTimeEnding;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_lastPrimaryNR;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_cal : array[1..2] of TInfoStruct = (
    (fInfo: fli_CCal;                              nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CS_Descr;                          nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_calendar : array[1..11] of TInfoStruct = (
    (fInfo: fli_CaCal;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CaCal_Date;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CaProg_Wrk_Hr;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CaSh1_Start;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CaSh1_End;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CaSh2_Start;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CaSh2_End;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CaSh3_Start;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CaSh3_End;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CaSh4_Start;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CaSh5_End;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_download_time : array[1..1] of TInfoStruct = (
    (fInfo: fli_DTDownload_Date_Time;              nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_machine_setup_code : array[1..10] of TInfoStruct = (
    (fInfo: fli_MSRes_Cat_Code;                   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSWkcnter;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSWkct_Proc;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSRsc_Code;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSDescription;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSMAchine_Setup_Code;             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSUsr_Namecr;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSUsr_Timecr;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSUsr_Namecg;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSUsr_Timecg;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_proc : array[1..2] of TInfoStruct = (
    (fInfo: fli_PWkct_Proc;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PS_Descr;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prop : array[1..21] of TInfoStruct = (
    (fInfo: fli_PrProperty;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PrS_Desc;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrL_Desc;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrType;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrProp_Len;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrNum_Of_Dec;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrCng_Prop_Val_Cause_Resched;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrPropValTakeForMergeDemands;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrRp_Conn_Lev_Main;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrRp_Add_Wc_Proc;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrRo_Cmpat_Chk;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrRo_Conn_Lev_Main;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrRo__Add_Wc_Proc;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrRo_Prod_Typ;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrOo_Cmpat_Chk;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrOo_Conn_Lev_Main;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrOo_Add_Wc_Proc;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrOo_Prod_Typ;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrMqmrelevance;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrMcmrelevance;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PrContainsNowProductionOrder;     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prop_capres : array[1..5] of TInfoStruct = (
    (fInfo: fli_PCCapacty_Resrv;                  nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PCProperty;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PCValue;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PCUsr_Namecg;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PCUsr_Timecg;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prop_res : array[1..17] of TInfoStruct = (
    (fInfo: fli_PResWkcnter;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PResRes_Category;                   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PResWc_Process;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PResRsc_Code;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PResProperty;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PResPropty_Value;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResPropty_Calculated_Value;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResAdd_Rsc_Occ;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResVal_Add;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResVal_Take_For_Group;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResDft_Case_Rsc_Occ_Ruls;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResDft_Case_Occ_Occ_Ruls;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResDft_Same_Grp_Occ_Occ_Ruls;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResUsr_Namecr;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResUsr_Timecr;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResUsr_Namecg;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PResUsr_Timecg;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_res : array[1..15] of TInfoStruct = (
    (fInfo: fli_ResRsc_Code;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ResS_Descr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResL_Descr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResProces_Type;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResWkcnter;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResRes_Category;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResStandrd_Bch_Size;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResBch_Um;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResCal;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResRsc_Type;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResNum_Rsc_Comp;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResMin_Bch_Size;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResMax_Bch_Size;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResDisplayText1;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ResDisplayText2;                    nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_rescat : array[1..3] of TInfoStruct = (
    (fInfo: fli_RCRes_Category;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RCDesc;                             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RCLong_Desc;                        nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_res_apa : array[1..9] of TInfoStruct = (
    (fInfo: fli_RARsc_Code;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RASub_Rsc;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RADate_Begin;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RADate_End;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RANum_Rsc_Comp;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RAUsr_Namecr;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RAUsr_Timecr;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RAUsr_Namecg;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RAUsr_Timecg;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_res_sub : array[1..10] of TInfoStruct = (
    (fInfo: fli_RSRsc_Code;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RSSub_Rsc;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RSCal;                              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSProd_Line;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSComment;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSNum_Rsc_Comp;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSUsr_Namecr;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSUsr_Timecr;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSUsr_Namecg;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSUsr_Timecg;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_rule_occ_to_occ : array[1..23] of TInfoStruct = (
    (fInfo: fli_ROOWkcnter;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ROORsc_Code;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ROORes_Category;                    nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ROOWc_Process;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ROOProperty;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ROOType_Prod;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ROOLine_Number;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ROOSequence;                        nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_ROODep_On_Curr;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROODep_Value;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROORule_Const;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOOperand;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOCase;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOSetup_Type;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOSetup_Time;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOSetup_Overlapping_Time;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOSetup_Time_Mult;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOOverlapping_Time_Mult;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOCan_Be_Same_Group;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOUsr_Namecr;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOUsr_Timecr;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOUsr_Namecg;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ROOUsr_Timecg;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_rule_res_to_occ : array[1..16] of TInfoStruct = (
    (fInfo: fli_RROWkcnter;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RRORsc_Code;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RRORes_Category;                    nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RROWc_Process;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RROProperty;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RROType_Prod;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RROLine_Number;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RROSequence;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RROOperand;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RRODep_On_Curr;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RRODep_Value;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RROCase;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RROUsr_Namecr;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RROUsr_Timecr;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RROUsr_Namecg;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RROUsr_Timecg;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_unit : array[1..3] of TInfoStruct = (
    (fInfo: fli_UUm;                                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_US_Descr;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_UL_Descr;                           nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc : array[1..10] of TInfoStruct = (
    (fInfo: fli_WWkcnter;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WWk_Cnter_Group;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WS_Descr;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WL_Descr;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WTyp_Opration;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WTyp_Process;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WHandledByMQM;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WHandledByMCM;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_HandledLearningCurve;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcADForLearningCurveCode;          nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_dependency : array[1..13] of TInfoStruct = (
    (fInfo: fli_WDSched_Wkc;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WDSched_Wkc_Proc;                   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WDDepend_On;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WDDep_Is_Schd_Rsc_Cat;              nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WDDep_Is_Schd_Wkc;                  nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WDDep_Is_Schd_Rsc;                  nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WDNo_Sched_Rsc_Cat;                 nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WDNo_Sched_Wkc;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WDNo_Sched_Rsc;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WDUsr_Namecr;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WDUsr_Timecr;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WDUsr_Namecg;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WDUsr_Timecg;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_priority : array[1..10] of TInfoStruct = (
    (fInfo: fli_WPWkcnter;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WPWkct_Proc;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WPSeq_Depend;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WPSeqalpha;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WPPriority_Ralation;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WPMach_Setup_Code_Level;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WPUsr_Namecr;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WPUsr_Timecr;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WPUsr_Namecg;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WPUsr_Timecg;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_proc : array[1..11] of TInfoStruct = (
    (fInfo: fli_WPrWkcnter;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WPrWkct_Proc;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WPrS_Descr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WPrL_Descr;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_isNowPrdOrd_MQMGroup;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CanBeGroupedInMQM;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcDefaultForAllowedSplit;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcADForAllowedSplit;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcADForSplitFamilyCode;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_wkcProcType;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BatchStandTime;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_prod_line : array[1..5] of TInfoStruct = (
    (fInfo: fli_WPDLWkcnter;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WPDLProd_Line;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WPLDate_Begin;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WPLDate_End;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WPLRes_Num_Pln;                      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkst : array[1..8] of TInfoStruct = (
    (fInfo: fli_WSWkst_Code;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WSWkdescr;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WSWkpasswd;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WSUsr_Namecr;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WSUsr_Timecr;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WSUsr_Namecg;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WSUsr_Timecg;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WSWorkstationtype;                   nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wks_wkc : array[1..8] of TInfoStruct = (
    (fInfo: fli_WWWkst_Code;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WWWkcnter;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WWTypeusd;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WWVisible;                           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WWUsr_Namecr;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WWUsr_Timecr;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WWUsr_Namecg;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WWUsr_Timecg;                        nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ext_info : array[1..5] of TInfoStruct = (
    (fInfo: fli_EIConne_Key;       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_EIInfo_Line_Num;   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_EIInfo_Area;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_EIUsr_Namecg;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_EIUsr_Timecg;      nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ext_infoHdr : array[1..5] of TInfoStruct = (
    (fInfo: fli_EHConne_Key;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_EHConne_Type;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_EHDue_Date;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_EHUsr_Namecg;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_EHUsr_Timecg;                        nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_ext_connection : array[1..6] of TInfoStruct = (
    (fInfo: fli_ECPreq_No;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ECConne_Key;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ECNum_Levels;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ECConn_Certent_Level;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ECUsr_Namecg;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ECUsr_Timecg;                        nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_reqConnection : array[1..4]of TInfoStruct = (
    (fInfo: fli_ICPreq_No;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ICPrev_Preq_No;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ICUsr_Namecg;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ICUsr_Timecg;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_info : array[1..7] of TInfoStruct = (
    (fInfo: fli_PIPreq_No;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PIInfo_Type;                        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PIPstep_Id;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PIInfo_Line_Num;                    nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PIInfo_Area;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PIUsr_Namecg;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PIUsr_Timecg;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prop_prod : array[1..8] of TInfoStruct = (
    (fInfo: fli_PPPreq_No;                          nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PPPStep_Id;                         nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PPProperty;                         nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PPRsc_Code;                         nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PPValue;                            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PPUsr_Namecg;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PPUsr_Timecg;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PPNumericVal;                       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_req : array[1..12] of TInfoStruct = (
    (fInfo: fli_PRDiv_Code;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRDsp_Code;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRBch_Code;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRReproc_No;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRPreq_No;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PRHistorical_Req;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRUsr_Namecg;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRUsr_Timecg;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRModulehandle;                     nrkey: 0;   notnull: false;   defval : -1),
//    (fInfo: fli_PRMqm_Historic_Date;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRTemplateCode;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRFamilyCode;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRIsFamily;                         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_step : array[1..48] of TInfoStruct = (
    (fInfo: fli_PDPreq_No;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PDPstep_Id;                    nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PDUpd_Code;                    nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_PDToSched;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDPrv_Step_Sched;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDPrv_Step_True;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDNex_Step_Sched;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDNex_Step_True;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDStepType;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDMat_Arrv_Date;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDFrc_Mat_Date;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDPlan_Start;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDLow_Limit_Time_Strt;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDFrc_Low_Date;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDPlan_End;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDHigh_Limit_Timeend;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDFrc_High_date;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDWkcnter;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDWkct_Proc;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDInit_Quent;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDFin_Quent;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDWeight;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDDesc_um;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDCal;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDSetup_Time_Stp;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDExc_Time_Stp;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDRes_Num_Pln;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDAllow_Split;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDStep_Handle_Reproces;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDStep_Part_Gen_Plan;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDStep_Can_Group;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDForced_Grp_No;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDConn_Type_Prev_Step_Split;   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDFrc_Overlapp;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDStep_Closed;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDUsr_Namecg;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDUsr_Timecg;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDMcmapplydatepenalty;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDMcmleadqueuetimeprevstep;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDMcmmaxjobsgap;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDMcmmaxstepsgap;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDSchdule_By_Mcm;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDSplitFamaly;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LearningCurveCode;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDLearningCurveType;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDApprovalDate;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDForced_Grp_No_str;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_GroupStepNumber;               nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_reqHdr : array[1..27] of TInfoStruct = (
    (fInfo: fli_PHPreq_No;                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PHUpd_Code;               nrkey: 0;   notnull: true;    defval :  0),
    (fInfo: fli_PHHistorical_Req;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHReq_Origin;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHProd_Line;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHType_Prod;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHProd_Family;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHMaterial_Family;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHProd_Um;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHProd_Low_Time_Strt;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHProd_Delivy_Date;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHFrc_Del_Date;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHUsr_Namecg;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHUsr_Timecg;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHMcm_Requesttype;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHMcm_Capacitysearch;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHMcm_Materialsearch;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHMcm_Requesteddate;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHMcm_Requesteddatetype;  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHMcm_Priority;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHMcm_Loaderdays;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHModulehandle;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHSplitConfLevels;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHLead_Step_Splited;      nrkey: 0;   notnull: false;   defval : -1),
  //  (fInfo: fli_PHSplitStartPosition;     nrkey: 0;   notnull: false;   defval : -1),
  //  (fInfo: fli_PHSplitEndPosition;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHServing_Code;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PHServed_Code;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NewPreqUniqId;            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_step_batchSize : array[1..4] of TInfoStruct = (
    (fInfo: fli_SBPreq_No;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SBPStep_Id;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SBBch_Um;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_SBMultipilr_To_Batch;               nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_step_times : array[1..9] of TInfoStruct = (
    (fInfo: fli_STPreq_No;              nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_STPstep_Id;             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_STWkcnter;              nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_STWkct_Proc;            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_STRes_Category;         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_STRsc_Code;             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_STMachine_Setup_Code;   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_STSetup_Time_Job;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_STExc_Time_Init_Qty;    nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_sched_progress : array[1..19] of TInfoStruct = (
    (fInfo: fli_SPPreq_No;             nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_SPPstep_Id;            nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_SPPsubst_Id;           nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_SPReproc_No;           nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_SPLast_Prog_Type;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPRsc_Code;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPProgresed_Group;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPProgrstart;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPCurr_Prg_Date;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPProgrend;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPQty;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPRemain_Time;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPLast_Prog_Type_Host; nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPRsc_Code_Host;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPProgrstart_Host;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPCurr_Prg_Date_Host;  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPProgend_Host;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPQty_Host;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPRemain_Time_Host;    nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_nowProgress : array[1..21] of TInfoStruct = (
    (fInfo: fli_NP_ProgressNumber;        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NP_ProgressTemplateCode;  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_DemandCounterCode;     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NP_DemandCode;            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NP_DemandStep;            nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NP_DemandTemplateCode;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_OriginalEndDate;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_StartDate;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_EndDate;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_ResourceCode;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_PrimaryQty;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_PrimaryUOmCode;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_SecondaryQty;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_SecondaryUOmCode;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_PackagingQty;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_PackagingUOmCode;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_PercentInProgress;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_FinalToInitialDivider; nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_ClosedStep;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_BasePrimaryUoMCode;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NP_MultiplierToBasePrimaryUoMCode;  nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_Material : array[1..20] of TInfoStruct = (
    (fInfo: fli_MTPreq_No;              nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTPstep_Id;             nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTOrg_Step;             nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTWkcnter;              nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTRes_Cat_Code;         nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTRsc_Code;             nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTMachine_Setup_Code;   nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTAlternative_Code;     nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTType_Prod;            nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTProduct_Code;         nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTNet_Group_Code;       nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTIssue_Code;           nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTSeq_Issued;           nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_MTMat_Balance;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MTQty_Alloc;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MTHigh_Date_Alloc;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MTSearch_Mat_Alloc;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MTSettled;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MTQuantity_Issue;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MTReq_Quantity;         nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_produced_article : array[1..11] of TInfoStruct = (
    (fInfo: fli_PAPreq_No;          nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_PASequence;         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_PAProduct_Code;     nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_PANet_Group_Code;   nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_PAAlloc_Req;        nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_PAProd_Balance;     nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_PARsc_Code;         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_PASettled;          nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_PAReq_Quantity;     nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_PAQty_Produced;     nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_PAQty_Alloc;        nrkey: 0;   notnull: false;    defval : -1)
  );

  struct_tbl_product : array[1..7] of TInfoStruct = (
    (fInfo: fli_PARType_Prod;         nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_PARProduct_Code;      nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_PARProduct_Nature;    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_PARStr_Cons_Point;    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_PAREnd_Cons_Point;    nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_PARInfo_Area;         nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_PARStdpurcorprodtime; nrkey: 0;   notnull: false;    defval : -1)
  );

  struct_tbl_balance_header : array[1..8] of TInfoStruct = (
    (fInfo: fli_BHType_Prod;        nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_BHProduct_Code;     nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_BHNet_Group_Code;   nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_BHDue_Date;         nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_BHQty;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BHInfo_Area;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BHUsr_Namecg;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BHUsr_Timecg;       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_balance_detail : array[1..9] of TInfoStruct = (
    (fInfo: fli_BDType_Prod;        nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_BDProduct_Code;     nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_BDNet_Group_Code;   nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_BDDue_Date;         nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_BDOccupy_Code;      nrkey: 0;   notnull: true;    defval : -1),
    (fInfo: fli_BDInfo_Area;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BDQty;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BDUsr_Namecg;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_BDUsr_Timecg;       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_Control : array[1..10] of TInfoStruct = (
    (fInfo: fli_ControlServerStatus;              nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ControlServerStarted;             nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ControlServerEnded;               nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ControlClientStatus;              nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ControlClientStarted;             nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ControlClientEnded;               nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ControlClientLastOperation;       nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ControlClientLastUploadSuccess;   nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ControlServerCanUpdate;           nrkey: 0;   notnull: true;     defval : -1),
    (fInfo: fli_ControlServerUpdateTime;          nrkey: 0;   notnull: true;     defval : -1)
  );

{
  struct_tbl_WorkCenter : array[1..8] of TInfoStruct = (
    (fInfo: fli_WorkCenterDefault;                nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_WorkCenterCode;                   nrkey: 1;   notnull: true;     defval : -1),
    (fInfo: fli_WorkCenterGroup;                  nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_WorkCenterShortDesc;              nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_WorkCenterLongDesc;               nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_WorkCenterBatchContFlag;          nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_WorkCenterDummyField;             nrkey: 0;   notnull: false;    defval : -1),
    (fInfo: fli_HandleByMQM;                      nrkey: 0;   notnull: false;    defval : -1)
  );



  struct_tbl_ItemType : array[1..4] of TInfoStruct = (
    (fInfo: fli_ITDefault;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_ITTable;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ITKey;                             nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_ITData;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_workcenter_operation : array[1..5] of TInfoStruct = (
    (fInfo: fli_WCODefault;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WCOWorkCenterCode;                 nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WCOWorkCenterOperationCode;        nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WCOWorkCenterShortDesc;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WCOWorkCenterLongDesc;             nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_calendar_2 : array[1..14] of TInfoStruct = (
    (fInfo: fli_CalDefault;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalCode;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalDate;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CalProgressiveHours;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalFirstShiftStart;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalFirstShiftEnd;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalSecondShiftStart;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalSecondShiftEnd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalThirdShiftStart;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalThirdShiftEnd;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalFourthShiftStart;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalFourthShiftEnd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalUserNameChanged;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CalDateChanged;                    nrkey: 0;   notnull: false;   defval : -1)
  );
}
  struct_tbl_routing_STT : array[1..5] of TInfoStruct = (
    (fInfo: fli_RSTTCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_RSTTShortDescription;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSTTType;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSTTApply;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_RSTTApplyTypeCode;                 nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_production_DT : array[1..28] of TInfoStruct = (
    (fInfo: fli_PDTCode;                          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PDTShortDesc;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTHandledByMQM;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTHandledByMCM;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTApplyDatePenalty;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTMaxGapBtwEndDates;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTMaxGapBtwEndStrDates;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTMcmRequestType;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTSearchCapacity;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTCapAddDataTableName;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTCapAddDataColumnName;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTSearchMaterial;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTMatAddDataTableName;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTMatAddDataColumnName;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTRequestDateType;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTLoadPriority;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTPriAddDataTableName;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTPriAddDataColumnName;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTAutoLoaderDays;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTDaysToKeepHistory;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDTDemandKeyLinkAdditionalData;   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDServedCodeTableName;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDServedCodeColumName;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDServingCodeTableName;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDServingCodeColumName;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDServingDefinition;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDServedDefinition;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDServedItemType;                 nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_production_req_no : array[1..1] of TInfoStruct = (
    (fInfo: fli_PRNProductionRequestNo;           nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_logical_warehouse : array[1..3] of TInfoStruct = (
    (fInfo: fli_LWCode;                           nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_LWShortDesc;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_LWMqmGroupCode;                   nrkey: 0;   notnull: false;  defval : -1)
  );

  struct_tbl_material_sup_header : array[1..19] of TInfoStruct = (
    (fInfo: fli_MSHWkcnter;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSHWkct_Proc;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSHRes_Cat_Code;                  nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSHRsc_Code;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSHType_Prod;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSHWait_Prev_Qty;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHMin_Qty_Pass_Nxt;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHMin_Qty_Prev_Stp;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHMin_Del_Wait_Days;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHMin_Del_Wait_Hrs;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHMin_Del_Wait_Min;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHMax_Del_Wait_Days;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHMax_Del_Wait_Hrs;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHMax_Del_Wait_Min;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHPart_Del;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHUpd_Bal_Hrs;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHUpd_Bal_Qty;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSHUpd_Req_Prev_Stp_Hrs;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSModulerule;                     nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_material_sup_detail : array[1..12] of TInfoStruct = (
    (fInfo: fli_MSDWkcnter;                       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSDWkct_Proc;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSDRes_Cat_Code;                  nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSDRsc_Code;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSDType_Prod;                     nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSDSearch_Balance;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSDWait_Entire_Mat;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSDIssue_Trans_Mat;               nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSDMinQty;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSDUpd_Req_Hrs;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MSDMat_Prod_Type;                 nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MSDModulerule;                    nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_now_table_names : array[1..1] of TInfoStruct = (
    (fInfo: fli_NTNTable_Name;                    nrkey: 1;   notnull: true;    defval : -1)
  );

  struct_tbl_now_tables_columns : array[1..6] of TInfoStruct = (
    (fInfo: fli_NTCTable_Name;                    nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NTCColumn_Name;                   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NTCType_Name;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NTCLength;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NTCScale;                         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NTCRelatedEntityClassName;        nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_now_Related_table_columns : array[1..2] of TInfoStruct = (
    (fInfo: fli_NTCRelatedEntityClassName;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NTCColumn_Name;                   nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_property_rtv_value : array[1..7] of TInfoStruct = (
    (fInfo: fli_PRVProperty;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PRVItemType;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PRVTable_Name;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRVColumn_Name;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRVRelated_ColumName;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRVFromPosition;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PRVLength;                        nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_category : array[1..6] of TInfoStruct = (
    (fInfo: fli_WCAWkcnter;          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WCACategory;         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WCAMixresgroups;     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WCACal;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WCAUsr_Namecg;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WCAUsr_Timecg;       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_category_dates_info : array[1..7] of TInfoStruct = (
    (fInfo: fli_CDWkcnter;          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CDCategory;         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CDDate_Begin;       nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_CDNum_Of_Machines;  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CDFinitecapacity;   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CDUsr_Namecg;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_CDUsr_Timecg;       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_wkc_penalties : array[1..6] of TInfoStruct = (
    (fInfo: fli_PNPlan_Wkct_Code;   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PNPlan_Wkct_Proc;   nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PNCompcasenum;      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PNDayspanelty;      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PNUsr_Namecg;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PNUsr_Timecg;       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_workcenter_and_operation_attributes : array[1..33] of TInfoStruct = (
    (fInfo: fli_WOAWorkcenterCode;               nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WOAOperationCode;                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WOACode;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_WOAShortDescription;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOAStandardStepQuantity;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOAStandardStepQtyUomCode;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOAStepEfficiencyApply;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOAStepEfficiency;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeType1Code;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATime1;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeUnit1;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeRefQty1;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeRefUom1Code;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeType2Code;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATime2;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeUnit2;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeRefQty2;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeRefUom2Code;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeType3Code;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATime3;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeUnit3;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeRefQty3;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeRefUom3Code;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeType4Code;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATime4;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeUnit4;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeRefQty4;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeRefUom4Code;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeType5Code;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATime5;                        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeUnit5;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeRefQty5;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_WOATimeRefUom5Code;              nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_production_times_level : array[1..24] of TInfoStruct = (
    (fInfo: fli_PTLWorkCenterCode;               nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PTLOperation;                    nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PTLProductType;                  nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PTLHandle_Times_By;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLTableName1;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLColumnName1;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLTableName2;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLColumnName2;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLTableName3;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLColumnName3;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLTableName4;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLColumnName4;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLTableName5;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLColumnName5;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLTableName6;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLColumnName6;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLTableName7;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLColumnName7;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLTableName8;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLColumnName8;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLTableName9;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLColumnName9;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLTableName10;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTLColumnName10;                 nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_production_times : array[1..24] of TInfoStruct = (
    (fInfo: fli_PTKey;                           nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PTWorkCenter;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTOperation;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTProductType;                   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTTableName1ColumnName1Value;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTTableName1ColumnName2Value;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTTableName1ColumnName3Value;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTTableName1ColumnName4Value;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTTableName1ColumnName5Value;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTTableName1ColumnName6Value;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTTableName1ColumnName7Value;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTTableName1ColumnName8Value;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTTableName1ColumnName9Value;    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTTableName1ColumnName10Value;   nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTResourceCategory;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTResource;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTSetupTime;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTBatchTime;                     nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTContinuousTime;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTContinuousOpUM;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTConsiderStepEfficiency;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTCode;                          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTSetupTimeMultiplier;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PTOperationTimeMultiplier;       nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_productionProgressTemplate : array[1..6] of TInfoStruct = (
    (fInfo: fli_PPTCode;                         nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PPTS_Descr;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PPTL_Descr;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PPTHandledByMQM;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PPTHandledByMCM;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PPTQuantityType;                 nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_prod_sched : array[1..49] of TInfoStruct = (
    (fInfo: fli_PSPreqNo;                 nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PSPStepId;                nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PSPsubstId;               nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PSReprecNo;               nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_PSVersNo;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSUpdCode;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSUpdOp;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSTypeProd;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSProdLine;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSProdUm;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSStepType;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSInitQuent;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSStGroup;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSStepIsGrped;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSSchedType;              nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSWkcnter;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSWkctProc;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSAlternativeCode;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSRscCode;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSProdSublinRsc;          nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSNumRscComponents;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSQty;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSSupBase;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSSupReal;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSSupOverlap;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSExeMin;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSSchStart;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSSchEnd;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSComment;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSFwdSubstep;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSFwdReprocSubstep;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSBkwSubstep;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSBkwReprocSubstep;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSSavesAtLeastOnesFinnal; nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSNettedQuantity;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSChangedQuantity;        nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSMachineSetupCode;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSUsr_Namecr;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSUsr_Timecr;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSUsr_Namecg;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSUsr_Timecg;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSBinSel;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSProgOverrideType;       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSEkcnterKetSt;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSWcProcessKeySt;         nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSResKeySt;               nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSResCatKeySt;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_NewPreqUniqId;            nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PSSplitFamaly;            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_productionDemandCounter : array[1..3] of TInfoStruct = (
    (fInfo: fli_PDCCode;                           nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PDCShortDesc;                      nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_PDCFamilyCodeEndPosition;          nrkey: 0;   notnull: false;  defval : -1)
  );

  struct_tbl_ProjectNumber : array[1..2] of TInfoStruct = (
    (fInfo: fli_PNProjectCode;                         nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PNNumber;                          nrkey: 0;   notnull: false;  defval : -1)
  );

  struct_tbl_Property_Upload : array[1..6] of TInfoStruct = (
    (fInfo: fli_PPPreq_No;                          nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PPPStep_Id;                         nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PPProperty;                         nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_PPValue;                            nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_PPUsr_Namecg;                       nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_PPUsr_Timecg;                       nrkey: 0;   notnull: false;  defval : -1)
  );

  struct_tbl_itemTypeTemplate : array[1..5] of TInfoStruct = (
    (fInfo: fli_ITTItemTypeCode;                   nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ITTProductionDemandTemplateCode;   nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ITTHostSplitConfirmLevel;          nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITTWorkcenterForSplit;             nrkey: 1;   notnull: true;  defval : -1),
    (fInfo: fli_ITTOperationForSplit;              nrkey: 1;   notnull: true;  defval : -1)
  );

  struct_tbl_alt_warehouse : array[1..5] of TInfoStruct = (
    (fInfo: fli_AWHWkcenter;                       nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_AWHAltern_Wc;                      nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_AWHNet_Group_Code;                 nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_AWHIssueItemType;                  nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_AWHAltern_Net_Group_Code;          nrkey: 0;   notnull: false;  defval : -1)
  );

  struct_tbl_item_type_logical_warehouse : array[1..19] of TInfoStruct = (
    (fInfo: fli_ITLWItemTypeCode;                  nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ITLWLogicalWarehouseCode;          nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_ITLWNetGroupReservationTableName;  nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLWNetGroupReservationColumnName; nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLWNetGroupDemandTableName;       nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLWNetGroupDemandColumnName;      nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLWConnBtwStockAndResrv;          nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLWSeparetBtwAttributes;          nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLW1stcolumn;                     nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLWdspBeforecolumn2;              nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLW2stcolumn;                     nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLWdspBeforecolumn3;              nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLW3stcolumn;                     nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLWdspBeforecolumn4;              nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLW4stcolumn;                     nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLWdspBeforecolumn5;              nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLW5stcolumn;             nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLWdspBeforecolumn6;              nrkey: 0;   notnull: false;  defval : -1),
    (fInfo: fli_ITLW6stcolumn;             nrkey: 0;   notnull: false;  defval : -1)
  );

  struct_tbl_Now_Download_Entity_Date : array[1..2] of TInfoStruct = (
    (fInfo: fli_NDEntityName;                      nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_NDDate;                            nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_LearningCurve : array[1..12] of TInfoStruct = (
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
    (fInfo: fli_CurveFifthEffic;                    nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_StockDetails : array[1..10] of TInfoStruct = (
    (fInfo: fli_BalanceIdentifier;          nrkey: 1;   notnull: true;    defval : -1),
    (fInfo: fli_MTType_Prod;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MTProduct_Code;             nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_MTNet_Group_Code;           nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_Details;                    nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_used;                       nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPPreq_No;                  nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPPstep_Id;                 nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPPsubst_Id;                nrkey: 0;   notnull: false;   defval : -1),
    (fInfo: fli_SPReproc_No;                nrkey: 0;   notnull: false;   defval : -1)
  );

  struct_tbl_GrpCodeIndex : array[1..2] of TInfoStruct = (
    (fInfo: fli_GrpIndex;                          nrkey: 1;   notnull: true;   defval : -1),
    (fInfo: fli_GrpCode;                           nrkey: 1;   notnull: true;   defval : -1)
  );

  tblInfo : array[table] of TTblInfo = (
    (PCname: 'ADD_RES';                     ASname: '';                              pfx: 'AR_';  struct: @struct_tbl_add_res;                             nrfld: High(struct_tbl_add_res);                             group: 1; arc: 1), //  tbl_add_res
    (PCname: 'ALT_WKC';                     ASname: '';                              pfx: 'AW_';  struct: @struct_tbl_alt_wkc;                             nrfld: High(struct_tbl_alt_wkc);                             group: 1; arc: 1), //  tbl_alt_wkc
    (PCname: 'ARTICLE_TYPE';                ASname: 'ITEMTYPE';                      pfx: 'AT_';  struct: @struct_tbl_article_type;                        nrfld: High(struct_tbl_article_type);                        group: 1; arc: 1), //  tbl_article_type
    (PCname: 'CAL';                         ASname: '';                              pfx: 'CL_';  struct: @struct_tbl_cal;                                 nrfld: High(struct_tbl_cal);                                 group: 1; arc: 1), //  tbl_cal
    (PCname: 'CALENDAR';                    ASname: 'CALENDARSHIFTDAILYINFORMATION'; pfx: 'CA_';  struct: @struct_tbl_calendar;                            nrfld: High(struct_tbl_calendar);                            group: 1; arc: 1), //  tbl_calendar
    (PCname: 'DOWNLOAD_TIME';               ASname: '';                              pfx: 'DD_';  struct: @struct_tbl_download_time;                       nrfld: High(struct_tbl_download_time);                       group: 1; arc: 1), //  tbl_download_time
    (PCname: 'MACHINE_SETUP_CODE';          ASname: '';                              pfx: 'MS_';  struct: @struct_tbl_machine_setup_code;                  nrfld: High(struct_tbl_machine_setup_code);                  group: 1; arc: 1), //  tbl_machine_setup_code
    (PCname: 'PROC';                        ASname: 'OPERATION';                     pfx: 'PR_';  struct: @struct_tbl_proc;                                nrfld: High(struct_tbl_proc);                                group: 1; arc: 1), //  tbl_proc
    (PCname: 'PROP';                        ASname: '';                              pfx: 'PY_';  struct: @struct_tbl_prop;                                nrfld: High(struct_tbl_prop);                                group: 1; arc: 1), //  tbl_prop
    (PCname: 'PROP_CAPRES';                 ASname: '';                              pfx: 'CP_';  struct: @struct_tbl_prop_capres;                         nrfld: High(struct_tbl_prop_capres);                         group: 1; arc: 1), //  tbl_prop_capres
    (PCname: 'PROP_RES';                    ASname: '';                              pfx: 'RP_';  struct: @struct_tbl_prop_res;                            nrfld: High(struct_tbl_prop_res);                            group: 1; arc: 1), //  tbl_prop_res
    (PCname: 'RES';                         ASname: 'RESOURCES';                     pfx: 'RS_';  struct: @struct_tbl_res;                                 nrfld: High(struct_tbl_res);                                 group: 1; arc: 1), //  tbl_res
    (PCname: 'RESCAT';                      ASname: '';                              pfx: 'CT_';  struct: @struct_tbl_rescat;                              nrfld: High(struct_tbl_rescat);                              group: 1; arc: 1), //  tbl_rescat
    (PCname: 'RES_APA';                     ASname: '';                              pfx: 'RD_';  struct: @struct_tbl_res_apa;                             nrfld: High(struct_tbl_res_apa);                             group: 1; arc: 1), //  tbl_res_apa
    (PCname: 'RES_SUB';                     ASname: '';                              pfx: 'DH_';  struct: @struct_tbl_res_sub;                             nrfld: High(struct_tbl_res_sub);                             group: 1; arc: 1), //  tbl_res_sub
    (PCname: 'RULE_OCC_TO_OCC';             ASname: '';                              pfx: 'OO_';  struct: @struct_tbl_rule_occ_to_occ;                     nrfld: High(struct_tbl_rule_occ_to_occ);                     group: 1; arc: 1), //  tbl_rule_occ_to_occ
    (PCname: 'RULE_RES_TO_OCC';             ASname: '';                              pfx: 'RO_';  struct: @struct_tbl_rule_res_to_occ;                     nrfld: High(struct_tbl_rule_res_to_occ);                     group: 1; arc: 1), //  tbl_rule_res_to_occ
    (PCname: 'UNIT';                        ASname: 'UNITOFMEASURE';                 pfx: 'UM_';  struct: @struct_tbl_unit;                                nrfld: High(struct_tbl_unit);                                group: 1; arc: 1), //  tbl_unit
    (PCname: 'WKC';                         ASname: 'WORKCENTER';                    pfx: 'WC_';  struct: @struct_tbl_wkc;                                 nrfld: High(struct_tbl_wkc);                                 group: 1; arc: 1), //  tbl_wkc
    (PCname: 'WKC_DEPENDENCY';              ASname: '';                              pfx: 'WD_';  struct: @struct_tbl_wkc_dependency;                      nrfld: High(struct_tbl_wkc_dependency);                      group: 1; arc: 1), //  tbl_wkc_dependency
    (PCname: 'WKC_PRIORITY';                ASname: '';                              pfx: 'WP_';  struct: @struct_tbl_wkc_priority;                        nrfld: High(struct_tbl_wkc_priority);                        group: 1; arc: 1), //  tbl_wkc_priority
    (PCname: 'WKC_PROC';                    ASname: 'WORKCENTERANDOPERATTRIBUTES';   pfx: 'WP_';  struct: @struct_tbl_wkc_proc;                            nrfld: High(struct_tbl_wkc_proc);                            group: 1; arc: 1), //  tbl_wkc_proc
    (PCname: 'WKC_PROD_LINE';               ASname: '';                              pfx: 'PL_';  struct: @struct_tbl_wkc_prod_line;                       nrfld: High(struct_tbl_wkc_prod_line);                       group: 1; arc: 1), //  tbl_wkc_prod_line
    (PCname: 'WKST';                        ASname: '';                              pfx: 'WK_';  struct: @struct_tbl_wkst;                                nrfld: High(struct_tbl_wkst);                                group: 1; arc: 1), //  tbl_wkst
    (PCname: 'WKS_WKC';                     ASname: '';                              pfx: 'WW_';  struct: @struct_tbl_wks_wkc;                             nrfld: High(struct_tbl_wks_wkc);                             group: 1; arc: 1), //  tbl_wks_wkc
    (PCname: 'EXT_INFO';                    ASname: '';                              pfx: 'EI_';  struct: @struct_tbl_ext_info;                            nrfld: High(struct_tbl_ext_info);                            group: 1; arc: 1), //  tbl_ext_info
    (PCname: 'EXT_INFO_HDR';                ASname: '';                              pfx: 'EH_';  struct: @struct_tbl_ext_infoHdr;                         nrfld: High(struct_tbl_ext_infoHdr);                         group: 1; arc: 1), //  tbl_ext_infoHdr
    (PCname: 'EXT_CONNECTION';              ASname: '';                              pfx: 'EC_';  struct: @struct_tbl_ext_connection;                      nrfld: High(struct_tbl_ext_connection);                      group: 1; arc: 1), //  tbl_ext_connection
    (PCname: 'PROD_REQCONN';                ASname: '';                              pfx: 'IC_';  struct: @struct_tbl_prod_reqConnection;                  nrfld: High(struct_tbl_prod_reqConnection);                  group: 1; arc: 1), //  tbl_prod_reqConnection
    (PCname: 'PROD_INFO';                   ASname: '';                              pfx: 'PI_';  struct: @struct_tbl_prod_info;                           nrfld: High(struct_tbl_prod_info);                           group: 1; arc: 1), //  tbl_prod_info
    (PCname: 'PROP_PROD';                   ASname: '';                              pfx: 'PP_';  struct: @struct_tbl_prop_prod;                           nrfld: High(struct_tbl_prop_prod);                           group: 1; arc: 1), //  tbl_prop_prod
    (PCname: 'PROD_REQ';                    ASname: '';                              pfx: 'PR_';  struct: @struct_tbl_prod_req;                            nrfld: High(struct_tbl_prod_req);                            group: 1; arc: 1), //  tbl_prod_req
    (PCname: 'PROD_STEP';                   ASname: '';                              pfx: 'PD_';  struct: @struct_tbl_prod_step;                           nrfld: High(struct_tbl_prod_step);                           group: 1; arc: 1), //  tbl_prod_step
    (PCname: 'PROD_REQHDR';                 ASname: '';                              pfx: 'PH_';  struct: @struct_tbl_prod_reqHdr;                         nrfld: High(struct_tbl_prod_reqHdr);                         group: 1; arc: 1), //  tbl_prod_reqHdr
    (PCname: 'PROD_STEP_BATCH_SIZE';        ASname: '';                              pfx: 'SB_';  struct: @struct_tbl_step_batchSize;                      nrfld: High(struct_tbl_step_batchSize);                      group: 1; arc: 1), //  tbl_step_batchSize
    (PCname: 'PROD_STEP_TIMES';             ASname: '';                              pfx: 'ST_';  struct: @struct_tbl_step_times;                          nrfld: High(struct_tbl_step_times);                          group: 1; arc: 1), //  tbl_step_times
    (PCname: 'PROD_SCHED_PROGRESS';         ASname: '';                              pfx: 'SP_';  struct: @struct_tbl_sched_progress;                      nrfld: High(struct_tbl_sched_progress);                      group: 1; arc: 1), //  tbl_sched_progress
    (PCname: 'NOW_PROGRESS';                ASname: '';                              pfx: 'NP_';  struct: @struct_tbl_nowProgress;                         nrfld: High(struct_tbl_nowProgress);                      group: 1; arc: 1), //  tbl_sched_progress
    (PCname: 'MATERIAL';                    ASname: '';                              pfx: 'MT_';  struct: @struct_tbl_Material;                            nrfld: High(struct_tbl_Material);                            group: 1; arc: 1), //  tbl_Material
    (PCname: 'PRODUCED_ARTICLE';            ASname: '';                              pfx: 'PA_';  struct: @struct_tbl_produced_article;                    nrfld: High(struct_tbl_produced_article);                    group: 1; arc: 1), //  tbl_produced_article
    (PCname: 'PRODUCTS';                    ASname: '';                              pfx: 'PAR_'; struct: @struct_tbl_product;                             nrfld: High(struct_tbl_product);                             group: 1; arc: 1), //  tbl_products
    (PCname: 'BALANCE_HEADER';              ASname: '';                              pfx: 'BH_';  struct: @struct_tbl_balance_header;                      nrfld: High(struct_tbl_balance_header);                      group: 1; arc: 1), //  tbl_balance_header
    (PCname: 'BALANCE_DETAIL';              ASname: '';                              pfx: 'BD_';  struct: @struct_tbl_balance_detail;                      nrfld: High(struct_tbl_balance_detail);                      group: 1; arc: 1), //  tbl_balance_detail
    (PCname: 'MQMCN00F';                    ASname: '';                              pfx: '';     struct: @struct_tbl_control;                             nrfld: High(struct_tbl_control);                             group: 1; arc: 1), //  tbl_Control
    (PCname: 'ROUTINGSTEPTIMETYPE';         ASname: 'ROUTINGSTEPTIMETYPE';           pfx: '';     struct: @struct_tbl_routing_STT;                         nrfld: High(struct_tbl_routing_STT);                         group: 1; arc: 1), //  tbl_routing_STT
    (PCname: 'PRODUCTIONDEMANDTEMPLATE';    ASname: 'PRODUCTIONDEMANDTEMPLATE';      pfx: '';     struct: @struct_tbl_production_DT;                       nrfld: High(struct_tbl_production_DT);                       group: 1; arc: 1), //  tbl_production_DT
    (PCname: 'PRODUCTION_REQEST_NO';        ASname: 'PRODUCTION_REQUEST_NO';         pfx: '';     struct: @struct_tbl_production_req_no;                   nrfld: High(struct_tbl_production_req_no);                   group: 1; arc: 1), //  tbl_production_req_no
    (PCname: 'LOGICALWAREHOUSE';            ASname: 'LOGICALWAREHOUSE';              pfx: '';     struct: @struct_tbl_logical_warehouse;                   nrfld: High(struct_tbl_logical_warehouse);                   group: 1; arc: 1), //  tbl_logical_warehouse
    (PCname: 'MATERIAL_SUP_DETAIL';         ASname: 'MATERIAL_SUP_DETAIL';           pfx: 'MD_';  struct: @struct_tbl_material_sup_detail;                 nrfld: High(struct_tbl_material_sup_detail);                 group: 1; arc: 1), //  tbl_Material_sup_detail
    (PCname: 'MATERIAL_SUP_HEADER';         ASname: 'MATERIAL_SUP_HEADER';           pfx: 'MH_';  struct: @struct_tbl_material_sup_header;                 nrfld: High(struct_tbl_material_sup_header);                 group: 1; arc: 1), //  tbl_Material_sup_header
    (PCname: 'NOW_TABLE_NAMES';             ASname: '';                              pfx: '';     struct: @struct_tbl_now_table_names;                     nrfld: High(struct_tbl_now_table_names);                     group: 1; arc: 1), //  tbl_now_table_names
    (PCname: 'NOW_TABLES_COLUMNS';          ASname: 'SYSCAT.COLUMNS';                pfx: '';     struct: @struct_tbl_now_tables_columns;                  nrfld: High(struct_tbl_now_tables_columns);                  group: 1; arc: 1), //  tbl_now_tables_columns
    (PCname: 'NOW_RELATED_TABLE_COLUMNS';   ASname: '';                              pfx: '';     struct: @struct_tbl_now_Related_table_columns;           nrfld: High(struct_tbl_now_Related_table_columns);           group: 1; arc: 1), //  tbl_now_Related_table_columns
    (PCname: 'PROPERTY_RTV_VALUE';          ASname: '';                              pfx: '';     struct: @struct_tbl_property_rtv_value;                  nrfld: High(struct_tbl_property_rtv_value);                  group: 1; arc: 1), //  tbl_property_rtv_value
    (PCname: 'WKC_CATEGORY';                ASname: '';                              pfx: 'CA_';  struct: @struct_tbl_wkc_category;                        nrfld: High(struct_tbl_wkc_category);                        group: 1; arc: 1), //  tbl_wkc_category
    (PCname: 'CATEGORY_DATES_INFO';         ASname: '';                              pfx: 'CD_';  struct: @struct_tbl_category_dates_info;                 nrfld: High(struct_tbl_category_dates_info);                 group: 1; arc: 1), //  tbl_category_dates_info
    (PCname: 'WKC_PENALTIES';               ASname: '';                              pfx: 'PN_';  struct: @struct_tbl_wkc_penalties;                       nrfld: High(struct_tbl_wkc_penalties);                       group: 1; arc: 1), //  tbl_wkc_penalties
    (PCname: 'WORKCENTERANDOPERATTRIBUTES'; ASname: 'WORKCENTERANDOPERATTRIBUTES';   pfx: '';     struct: @struct_tbl_workcenter_and_operation_attributes; nrfld: High(struct_tbl_workcenter_and_operation_attributes); group: 1; arc: 1), //  tbl_workcenter_and_operation_attributes
    (PCname: 'PRODUCTION_TIMES_LEVEL';      ASname: '';                              pfx: '';     struct: @struct_tbl_production_times_level;              nrfld: High(struct_tbl_production_times_level);              group: 1; arc: 1), //  tbl_production_times_level
    (PCname: 'PRODUCTION_TIMES';            ASname: '';                              pfx: '';     struct: @struct_tbl_production_times;                    nrfld: High(struct_tbl_production_times);                    group: 1; arc: 1), //  tbl_production_times
    (PCname: 'PRODUCTIONPROGRESSTEMPLATE';  ASname: 'PRODUCTIONPROGRESSTEMPLATE';    pfx: '';     struct: @struct_tbl_productionProgressTemplate;          nrfld: High(struct_tbl_productionProgressTemplate);          group: 1; arc: 1), //  tbl_productionProgressTemplate
    (PCname: 'PROD_SCHED';                  ASname: '';                              pfx: 'PS_';  struct: @struct_tbl_prod_sched;                          nrfld: High(struct_tbl_prod_sched);                          group: 1; arc: 1), //  tbl_prod_sched
    (PCname: 'PRODUCTIONDEMANDCOUNTER';     ASname: 'COUNTER';                       pfx: '';     struct: @struct_tbl_productionDemandCounter;             nrfld: High(struct_tbl_productionDemandCounter);             group: 1; arc: 1), //  tbl_productionDemandCounter
    (PCname: 'PROJECT_NUMBER';              ASname: '';                              pfx: '';     struct: @struct_tbl_projectNumber;                       nrfld: High(struct_tbl_projectNumber);                       group: 1; arc: 1), //  tbl_projectNumber
    (PCname: 'PROPERTY_UPLOAD';             ASname: '';                              pfx: 'PU_';  struct: @struct_tbl_Property_Upload;                     nrfld: High(struct_tbl_Property_Upload);                     group: 1; arc: 1), //  tbl_Property Upload
    (PCname: 'ITEMTYPETEMPLATE';            ASname: '';                              pfx: '';     struct: @struct_tbl_itemTypeTemplate;                    nrfld: High(struct_tbl_itemTypeTemplate);                    group: 1; arc: 1), //  tbl_itemTypeTemplate
    (PCname: 'ALTERNATIVEWAREHOUSE';        ASname: '';                              pfx: '';     struct: @struct_tbl_alt_warehouse;                       nrfld: High(struct_tbl_alt_warehouse);                       group: 1; arc: 1), //  tbl_alt_warehouse
    (PCname: 'ITEMTYPELOGICALWAREHOUSE';    ASname: '';                              pfx: '';     struct: @struct_tbl_item_type_logical_warehouse;         nrfld: High(struct_tbl_item_type_logical_warehouse);         group: 1; arc: 1), //  tbl_item_type_logical_warehouse
    (PCname: 'LEARNING_CURVE';              ASname: '';                              pfx: 'LC_';  struct: @struct_tbl_LearningCurve;                       nrfld: High(struct_tbl_LearningCurve);                       group: 1; arc: 1), //  tbl_LearningCurve
    (PCname: 'NOW_DOWNLOAD_ENTITY_NAME';    ASname: '';                              pfx: 'ND_';  struct: @struct_tbl_Now_Download_Entity_Date;            nrfld: High(struct_tbl_Now_Download_Entity_Date);            group: 1; arc: 1), //  tbl_Now_Download_Entity_Date
    (PCname: 'STOCKDETAILS';                ASname: '';                              pfx: 'SD_';  struct: @struct_tbl_StockDetails;                        nrfld: High(struct_tbl_StockDetails);                        group: 1; arc: 1), //  struct_tbl_StockDetails
    (PCname: 'GROUP_INDEX_CODE';            ASname: '';                              pfx: 'GI_';  struct: @struct_tbl_GrpCodeIndex;                        nrfld: High(struct_tbl_GrpCodeIndex);                        group: 1; arc: 1)  //  tbl_GrpCodeIndex

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
    (typ: db_dec;   len:  12;  dec: 5),  // dom_durMinLong
    (typ: db_dec;   len:  9;   dec: 4),  // dom_durMinMulti
    (typ: db_tmStp; len:  0;   dec: 0),  // dom_timing
    (typ: db_varch; len: 30;   dec: 0),  // dom_text30
    (typ: db_varch; len: 35;   dec: 0),  // dom_text35
    (typ: db_varch; len: 40;   dec: 0),  // dom_text40
    (typ: db_varch; len: 50;   dec: 0),  // dom_text50
    (typ: db_varch; len: 110;  dec: 0),  // dom_text120
    (typ: db_varch; len: 250;  dec: 0),  // dom_text250
    (typ: db_varch; len: 14;   dec: 0),  // dom_text14
    (typ: db_varch; len: 28;   dec: 0),  // dom_text28
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
    (typ: db_dec;   len: 4;    dec: 1),  // don_Hours
{$ifdef ARO }
    (typ: db_varch; len: 15;   dec: 0),  // text 1024
{$endif}
    (typ: db_varch; len:1024;  dec: 0),  // text 1024
    (typ: db_varch; len:8;  dec: 0),  // text 8
    (typ: db_varch; len:100;  dec: 0),  // text 100
    (typ: db_varch; len:15;  dec: 0),  // text 15
    (typ: db_varch; len:6;  dec: 0),  // text 6
    (typ: db_varch; len:4;  dec: 0),  // text 4
    (typ: db_varch; len:111;  dec: 0),  // text 111
    (typ: db_varch; len:14;  dec: 0),  // text 14
    (typ: db_varch; len:3;  dec: 0),  // text 3
    (typ: db_dec;   len:15;   dec: 5),  // dom_numeric15_5
    (typ: db_dec;   len:4;   dec: 0),  // dom_numeric4_0
    (typ: db_varch; len:2;  dec: 0),  // text 2
    (typ: db_varch; len:20;  dec: 0),  // text 20
    (typ: db_dec;   len:11;  dec: 2), // dom_Numeric11_2
    (typ: db_dec;   len:15;   dec: 0),  // dom_numeric15_0
    (typ: db_varch; len:70;   dec: 0),  // text 70
    (typ: db_varch; len:25;   dec: 0),  // text 25
    (typ: db_dec;   len:9;   dec: 2),  // dom_Numeric9_2
    (typ: db_varch; len:5;   dec: 0),  // text 5
    (typ: db_dec;   len:14;   dec: 4),  // dom_Numeric14_4
    (typ: db_dec;   len:7;   dec: 2),  // dom_Numeric7_2
    (typ: db_dec;   len:5;   dec: 0),  // dom_Numeric5_0
    (typ: db_dec;   len:9;   dec: 4),  // dom_Numeric9_4
    (typ: db_dec;   len:9;   dec: 3),  // dom_Numeric9_3
    (typ: db_dec;   len:6;   dec: 3),  // dom_Numeric6_3
    (typ: db_dec;   len:11;   dec: 9),  // dom_Numeric11_9
    (typ: db_dec;   len:11;   dec: 3),  // dom_Numeric11_3
    (typ: db_varch; len:9;   dec: 0),  // text 9
    (typ: db_varch; len:60;   dec: 0),  // text 60
    (typ: db_dec;   len:10;   dec: 5),  // dom_Numeric10_5
    (typ: db_dec;   len:5;   dec: 2),  // dom_Numeric5_2
    (typ: db_dec;   len:18;   dec: 2),  // dom_Numeric18_2
    (typ: db_varch; len:16;   dec: 0),  // text 16
    (typ: db_varch; len:12;   dec: 0)  // text 12
    );


  fldInfo : array[fldId] of TFldInfo = (
({$ifdef DEVELOP}fInfo: fli_ArtType;  {$endif}                              name: 'ART_TYPE';                    dom: dom_ProdType),
({$ifdef DEVELOP}fInfo: fli_Group;{$endif}                                  name: 'GROUP';                    dom: dom_longId),
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
({$ifdef DEVELOP}fInfo: fli_rsc;{$endif}                                    name: 'RSC_CODE';                    dom: dom_text8),
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
({$ifdef DEVELOP}fInfo: fli_SDescr;{$endif}                                 name: 'S_DESCR';                     dom: dom_txt28),
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
({$ifdef DEVELOP}fInfo: fli_PropValTakeForMergeDemands;{$endif}             name: 'PROP_VAL_TAKE_FOR_MERGE';     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_DecNum;{$endif}                                 name: 'NUM_OF_DEC';                  dom: dom_DecNum),
//({$ifdef DEVELOP}fInfo: fli_CalDate;{$endif}                                name: 'CAL_DATE';                    dom: dom_timing),
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
({$ifdef DEVELOP}fInfo: fli_AllocReq;{$endif}                               name: 'ALLOC_REQ';                   dom: dom_text12),
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
({$ifdef DEVELOP}fInfo: fli_CompScoreWeight;{$endif}                        name: 'CompScoreWeight';              dom: dom_shortId),


//ADD_RES
({$ifdef DEVELOP}fInfo: fli_ARAdd_Code;{$endif}                             name: 'ADD_CODE';                     dom: dom_Text5),
({$ifdef DEVELOP}fInfo: fli_ARS_Descr;{$endif}                              name: 'S_DESCR';                      dom: dom_Txt28),
({$ifdef DEVELOP}fInfo: fli_ARL_Descr;{$endif}                              name: 'L_DESCR';                      dom: dom_Text60),
({$ifdef DEVELOP}fInfo: fli_ARConsum_Zone;{$endif}                          name: 'CONSUM_ZONE';                  dom: dom_Type),

//ALT_WKC
({$ifdef DEVELOP}fInfo: fli_AWWkcenter;{$endif}                             name: 'WKCNTER';                      dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_AWWkctProc;{$endif}                             name: 'WKCT_PROC';                    dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_AWAltern_Wc;{$endif}                            name: 'ALTERN_WC';                    dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_AWAlternWcProces;{$endif}                       name: 'ALTERN_WC_PROCES';             dom: dom_Text8),

//ARTICLE_TYPE
({$ifdef DEVELOP}fInfo: fli_ATArtType;{$endif}                              name: 'ART_TYPE';                     dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_ATS_Descr;{$endif}                              name: 'S_DESCR';                      dom: dom_Txt28),
({$ifdef DEVELOP}fInfo: fli_ATL_Descr;{$endif}                              name: 'L_DESCR';                      dom: dom_Text60),
({$ifdef DEVELOP}fInfo: fli_ATBalHandledByMqm;{$endif}                      name: 'BalHandledByMQM';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ATAddDataColumnName;{$endif}                    name: 'AddDataColumnName';            dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_ATProductTypeNature;{$endif}                    name: 'ProductTypeNature';            dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ATResTimeBeginning;{$endif}                     name: 'ResTimeBeginning';             dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ATResTimeEnding;{$endif}                        name: 'ResTimeEnding';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_lastPrimaryNR;{$endif}                          name: 'lastPrimaryNR';                dom: dom_shortId),

//CAL
({$ifdef DEVELOP}fInfo: fli_CCal;{$endif}                                   name: 'CAL';                          dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_CS_Descr;{$endif}                               name: 'S_DESCR';                      dom: dom_Txt28),

//CALENDAR
({$ifdef DEVELOP}fInfo: fli_CaCal;{$endif}                                  name: 'CAL';                          dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_CaCal_Date;{$endif}                             name: 'CAL_DATE';                     dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_CaProg_Wrk_Hr;{$endif}                          name: 'PROG_WRK_HR';                  dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_CaSh1_Start;{$endif}                            name: 'SH1_START';                    dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_CaSh1_End;{$endif}                              name: 'SH1_END';                      dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_CaSh2_Start;{$endif}                            name: 'SH2_START';                    dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_CaSh2_End;{$endif}                              name: 'SH2_END';                      dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_CaSh3_Start;{$endif}                            name: 'SH3_START';                    dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_CaSh3_End;{$endif}                              name: 'SH3_END';                      dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_CaSh4_Start;{$endif}                            name: 'SH4_START';                    dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_CaSh4_End;{$endif}                              name: 'SH4_END';                      dom: dom_shtstId),

//DOWNLOAD_TIME
({$ifdef DEVELOP}fInfo: fli_DTDownload_Date_Time;{$endif}                   name: 'DOWNLOAD_DATE_TIME';           dom: dom_Timing),

//MACHINE_SETUP_CODE
({$ifdef DEVELOP}fInfo: fli_MSRes_Cat_Code;{$endif}                         name: 'RES_CAT_CODE';                 dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_MSWkcnter;{$endif}                              name: 'WKCNTER';                      dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_MSWkct_Proc;{$endif}                            name: 'WKCT_PROC';                    dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_MSRsc_Code;{$endif}                             name: 'RSC_CODE';                     dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_MSDescription;{$endif}                          name: 'DESCRIPTION';                  dom: dom_Text70),
({$ifdef DEVELOP}fInfo: fli_MSMAchine_Setup_Code;{$endif}                   name: 'MACHINE_SETUP_CODE';           dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_MSUsr_Namecr;{$endif}                           name: 'USR_NAMECR';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_MSUsr_Timecr;{$endif}                           name: 'USR_TIMECR';                   dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_MSUsr_Namecg;{$endif}                           name: 'USR_NAMECG';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_MSUsr_Timecg;{$endif}                           name: 'USR_TIMECG';                   dom: dom_Timing),

//PROC
({$ifdef DEVELOP}fInfo: fli_PWkct_Proc;{$endif}   name: 'WKCT_PROC';   dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PS_Descr;{$endif}     name: 'S_DESCR';     dom: dom_Txt28),

//PROP
({$ifdef DEVELOP}fInfo: fli_PrProperty;{$endif}                             name: 'PROPERTY';                     dom: dom_Text5),
({$ifdef DEVELOP}fInfo: fli_PrS_Desc;{$endif}                               name: 'S_DESC';                       dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PrL_Desc;{$endif}                               name: 'L_DESC';                       dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PrType;{$endif}                                 name: 'TYPE';                         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrProp_Len;{$endif}                             name: 'PROP_LEN';                     dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PrNum_Of_Dec;{$endif}                           name: 'NUM_OF_DEC';                   dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PrCng_Prop_Val_Cause_Resched;{$endif}           name: 'CNG_PROP_VAL_CAUSE_RESCHED';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrPropValTakeForMergeDemands;{$endif}           name: 'PROP_VAL_TAKE_FOR_MERGE';     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrRp_Conn_Lev_Main;{$endif}                     name: 'RP_CONN_LEV_MAIN';             dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrRp_Add_Wc_Proc;{$endif}                       name: 'RP_ADD_WC_PROC';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrRo_Cmpat_Chk;{$endif}                         name: 'RO_CMPAT_CHK';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrRo_Conn_Lev_Main;{$endif}                     name: 'RO_CONN_LEV_MAIN';             dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrRo__Add_Wc_Proc;{$endif}                      name: 'RO__ADD_WC_PROC';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrRo_Prod_Typ;{$endif}                          name: 'RO_PROD_TYP';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrOo_Cmpat_Chk;{$endif}                         name: 'OO_CMPAT_CHK';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrOo_Conn_Lev_Main;{$endif}                     name: 'OO_CONN_LEV_MAIN';             dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrOo_Add_Wc_Proc;{$endif}                       name: 'OO_ADD_WC_PROC';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrOo_Prod_Typ;{$endif}                          name: 'OO_PROD_TYP';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrMqmrelevance;{$endif}                         name: 'MQMRELEVANCE';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrMcmrelevance;{$endif}                         name: 'MCMRELEVANCE';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PrContainsNowProductionOrder;{$endif}           name: 'CONTAINSNOWPRODUCTIONORDER';   dom: dom_Type),


//PROP_CAPRES
({$ifdef DEVELOP}fInfo: fli_PCCapacty_Resrv;{$endif}                        name: 'CAPACTY_RESRV';                dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_PCProperty;{$endif}                             name: 'PROPERTY';                     dom: dom_Text5),
({$ifdef DEVELOP}fInfo: fli_PCValue;{$endif}                                name: 'VALUE';                        dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_PCUsr_Namecg;{$endif}                           name: 'USR_NAMECG';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PCUsr_Timecg;{$endif}                           name: 'USR_TIMECG';                   dom: dom_Timing),

//PROP_RES
({$ifdef DEVELOP}fInfo: fli_PResWkcnter;{$endif}                            name: 'WKCNTER';                      dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PResRes_Category;{$endif}                       name: 'RES_CATEGORY';                 dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PResWc_Process;{$endif}                         name: 'WC_PROCESS';                   dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PResRsc_Code;{$endif}                           name: 'RSC_CODE';                     dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_PResProperty;{$endif}                           name: 'PROPERTY';                     dom: dom_Text5),
({$ifdef DEVELOP}fInfo: fli_PResPropty_Value;{$endif}                       name: 'PROPTY_VALUE';                 dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_PResPropty_Calculated_Value;{$endif}            name: 'PROPTY_VALUE_CALC';            dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_PResAdd_Rsc_Occ;{$endif}                        name: 'ADD_RSC_OCC';                  dom: dom_Text5),
({$ifdef DEVELOP}fInfo: fli_PResVal_Add;{$endif}                            name: 'VAL_ADDED';                    dom: dom_Numeric14_4),
({$ifdef DEVELOP}fInfo: fli_PResVal_Take_For_Group;{$endif}                 name: 'VAL_TAKE_FOR_GROUP';           dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PResDft_Case_Rsc_Occ_Ruls;{$endif}              name: 'DFT_CASE_RSC_OCC_RULS';        dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_PResDft_Case_Occ_Occ_Ruls;{$endif}              name: 'DFT_CASE_OCC_OCC_RULS';        dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_PResDft_Same_Grp_Occ_Occ_Ruls;{$endif}          name: 'DFT_SAME_GRP_OCC_OCC_RULS';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PResUsr_Namecr;{$endif}                         name: 'USR_NAMECR';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PResUsr_Timecr;{$endif}                         name: 'USR_TIMECR';                   dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PResUsr_Namecg;{$endif}                         name: 'USR_NAMECG';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PResUsr_Timecg;{$endif}                         name: 'USR_TIMECG';                   dom: dom_Timing),

//RES
({$ifdef DEVELOP}fInfo: fli_ResRsc_Code;{$endif}                            name: 'RSC_CODE';                     dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_ResS_Descr;{$endif}                             name: 'S_DESCR';                      dom: dom_Txt28),
({$ifdef DEVELOP}fInfo: fli_ResL_Descr;{$endif}                             name: 'L_DESCR';                      dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_ResProces_Type;{$endif}                         name: 'PROCES_TYPE';                  dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ResWkcnter;{$endif}                             name: 'WKCNTER';                      dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_ResCategory;{$endif}                            name: 'RES_CATEGORY';                 dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_ResStandrd_Bch_Size;{$endif}                    name: 'STANDRD_BCH_SIZE';             dom: dom_Numeric7_2),
({$ifdef DEVELOP}fInfo: fli_ResBch_Um;{$endif}                              name: 'BCH_UM';                       dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_ResCal;{$endif}                                 name: 'CAL';                          dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_ResRsc_Type;{$endif}                            name: 'RSC_TYPE';                     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ResNum_Rsc_Comp;{$endif}                        name: 'NUM_RSC_COMP';                 dom: dom_Numeric5_0),
({$ifdef DEVELOP}fInfo: fli_ResMin_Bch_Size;{$endif}                        name: 'MIN_BCH_SIZE';                 dom: dom_Numeric7_2),
({$ifdef DEVELOP}fInfo: fli_ResMax_Bch_Size;{$endif}                        name: 'MAX_BCH_SIZE';                 dom: dom_Numeric7_2),
({$ifdef DEVELOP}fInfo: fli_ResDisplayText1;{$endif}                        name: 'TEXT1';                        dom: dom_text12),
({$ifdef DEVELOP}fInfo: fli_ResDisplayText2;{$endif}                        name: 'TEXT2';                        dom: dom_text12),

//RESCAT
({$ifdef DEVELOP}fInfo: fli_RCRes_Category;{$endif}                         name: 'RES_CATEGORY';                 dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_RCDesc;{$endif}                                 name: 'DESC';                         dom: dom_Text14),
({$ifdef DEVELOP}fInfo: fli_RCLong_Desc;{$endif}                            name: 'LONG_DESC';                    dom: dom_Text30),

//RES_APA
({$ifdef DEVELOP}fInfo: fli_RARsc_Code;{$endif}                             name: 'RSC_CODE';                     dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_RASub_Rsc;{$endif}                              name: 'SUB_RSC';                      dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_RADate_Begin;{$endif}                           name: 'DATE_BEGIN';                   dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_RADate_End;{$endif}                             name: 'DATE_END';                     dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_RANum_Rsc_Comp;{$endif}                         name: 'NUM_RSC_COMP';                 dom: dom_Numeric5_0),
({$ifdef DEVELOP}fInfo: fli_RAUsr_Namecr;{$endif}                           name: 'USR_NAMECR';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_RAUsr_Timecr;{$endif}                           name: 'USR_TIMECR';                   dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_RAUsr_Namecg;{$endif}                           name: 'USR_NAMECG';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_RAUsr_Timecg;{$endif}                           name: 'USR_TIMECG';                   dom: dom_Timing),

//RES_SUB
({$ifdef DEVELOP}fInfo: fli_RSRsc_Code;{$endif}                             name: 'RSC_CODE';                     dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_RSSub_Rsc;{$endif}                              name: 'SUB_RSC';                      dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_RSCal;{$endif}                                  name: 'CAL';                          dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_RSProd_Line;{$endif}                            name: 'PROD_LINE';                    dom: dom_Text4),
({$ifdef DEVELOP}fInfo: fli_RSComment;{$endif}                              name: 'COMMENT';                      dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_RSNum_Rsc_Comp;{$endif}                         name: 'NUM_RSC_COMPONENTS';           dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_RSUsr_Namecr;{$endif}                           name: 'USR_NAMECR';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_RSUsr_Timecr;{$endif}                           name: 'USR_TIMECR';                   dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_RSUsr_Namecg;{$endif}                           name: 'USR_NAMECG';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_RSUsr_Timecg;{$endif}                           name: 'USR_TIMECG';                   dom: dom_Timing),

//RULE_OCC_TO_OCC
({$ifdef DEVELOP}fInfo: fli_ROOWkcnter;{$endif}                  name: 'WKCNTER';                  dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_ROORsc_Code;{$endif}                 name: 'RSC_CODE';                 dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_ROORes_Category;{$endif}             name: 'RES_CATEGORY';             dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_ROOWc_Process;{$endif}               name: 'WC_PROCESS';               dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_ROOProperty;{$endif}                 name: 'PROPERTY';                 dom: dom_Text5),
({$ifdef DEVELOP}fInfo: fli_ROOType_Prod;{$endif}                name: 'TYPE_PROD';                dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_ROOLine_Number;{$endif}              name: 'LINE_NUMBER';              dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_ROOSequence;{$endif}                 name: 'SEQUENCE';                 dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_ROODep_On_Curr;{$endif}              name: 'DEP_ON_CURR';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ROODep_Value;{$endif}                name: 'DEP_VALUE';                dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_ROORule_Const;{$endif}               name: 'RULE_CONST';               dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_ROOOperand;{$endif}                  name: 'OPERAND';                  dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_ROOCase;{$endif}                     name: 'CASE';                     dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_ROOSetup_Type;{$endif}               name: 'SETUP_TYPE';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ROOSetup_Time;{$endif}               name: 'SETUP_TIME';               dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_ROOSetup_Overlapping_Time;{$endif}   name: 'SETUP_OVERLAPPING_TIME';   dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_ROOSetup_Time_Mult;{$endif}          name: 'SETUP_TIME_MULT';          dom: dom_Numeric9_4),
({$ifdef DEVELOP}fInfo: fli_ROOOverlapping_Time_Mult;{$endif}    name: 'OVERLAPPING_TIME_MULT';    dom: dom_Numeric9_4),
({$ifdef DEVELOP}fInfo: fli_ROOCan_Be_Same_Group;{$endif}        name: 'CAN_BE_SAME_GROUP';        dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ROOUsr_Namecr;{$endif}               name: 'USR_NAMECR';               dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_ROOUsr_Timecr;{$endif}               name: 'USR_TIMECR';               dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_ROOUsr_Namecg;{$endif}               name: 'USR_NAMECG';               dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_ROOUsr_Timecg;{$endif}               name: 'USR_TIMECG';               dom: dom_Timing),

//RULE_RES_TO_OCC
({$ifdef DEVELOP}fInfo: fli_RROWkcnter;{$endif}        name: 'WKCNTER';        dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_RRORsc_Code;{$endif}       name: 'RSC_CODE';       dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_RRORes_Category;{$endif}   name: 'RES_CATEGORY';   dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_RROWc_Process;{$endif}     name: 'WC_PROCESS';     dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_RROProperty;{$endif}       name: 'PROPERTY';       dom: dom_Text5),
({$ifdef DEVELOP}fInfo: fli_RROType_Prod;{$endif}      name: 'TYPE_PROD';      dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_RROLine_Number;{$endif}    name: 'LINE_NUMBER';    dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_RROSequence;{$endif}       name: 'SEQUENCE';       dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_RROOperand;{$endif}        name: 'OPERAND';        dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_RRODep_On_Curr;{$endif}    name: 'DEP_ON_CURR';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_RRODep_Value;{$endif}      name: 'DEP_VALUE';      dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_RROCase;{$endif}           name: 'CASE';           dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_RROUsr_Namecr;{$endif}     name: 'USR_NAMECR';     dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_RROUsr_Timecr;{$endif}     name: 'USR_TIMECR';     dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_RROUsr_Namecg;{$endif}     name: 'USR_NAMECG';     dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_RROUsr_Timecg;{$endif}     name: 'USR_TIMECG';     dom: dom_Timing),

//UNIT
({$ifdef DEVELOP}fInfo: fli_UUm;{$endif}        name: 'UM';        dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_US_Descr;{$endif}   name: 'S_DESCR';   dom: dom_Txt28),
({$ifdef DEVELOP}fInfo: fli_UL_Descr;{$endif}   name: 'L_DESCR';   dom: dom_Text60),

//WKC
({$ifdef DEVELOP}fInfo: fli_WWkcnter;{$endif}          name: 'WKCNTER';          dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WWk_Cnter_Group;{$endif}   name: 'WK_CNTER_GROUP';   dom: dom_Text4),
({$ifdef DEVELOP}fInfo: fli_WS_Descr;{$endif}          name: 'S_DESCR';          dom: dom_Txt28),
({$ifdef DEVELOP}fInfo: fli_WL_Descr;{$endif}          name: 'L_DESCR';          dom: dom_Text60),
({$ifdef DEVELOP}fInfo: fli_WTyp_Opration;{$endif}     name: 'TYP_OPRATION';     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WTyp_Process;{$endif}      name: 'TYP_PROCESS';      dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WHandledByMQM;{$endif}     name: 'HandledByMQM';     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WHandledByMCM;{$endif}     name: 'HandledByMCM';     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_HandledLearningCurve;{$endif}         name: 'Handle_LearningCurve';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_wkcADForLearningCurveCode;{$endif}    name: 'AD_LearningCurve_Code';   dom: dom_text30),

//WKC_DEPENDENCY
({$ifdef DEVELOP}fInfo: fli_WDSched_Wkc;{$endif}             name: 'SCHED_WKC';             dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WDSched_Wkc_Proc;{$endif}        name: 'SCHED_WKC_PROC';        dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WDDepend_On;{$endif}             name: 'DEPEND_ON';             dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WDDep_Is_Schd_Rsc_Cat;{$endif}   name: 'DEP_IS_SCHD_RSC_CAT';   dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WDDep_Is_Schd_Wkc;{$endif}       name: 'DEP_IS_SCHD_WKC';       dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WDDep_Is_Schd_Rsc;{$endif}       name: 'DEP_IS_SCHD_RSC';       dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WDNo_Sched_Rsc_Cat;{$endif}      name: 'NO_SCHED_RSC_CAT';      dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WDNo_Sched_Wkc;{$endif}          name: 'NO_SCHED_WKC';          dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WDNo_Sched_Rsc;{$endif}          name: 'NO_SCHED_RSC';          dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WDUsr_Namecr;{$endif}            name: 'USR_NAMECR';            dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WDUsr_Timecr;{$endif}            name: 'USR_TIMECR';            dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_WDUsr_Namecg;{$endif}            name: 'USR_NAMECG';            dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WDUsr_Timecg;{$endif}            name: 'USR_TIMECG';            dom: dom_Timing),

//WKC_PRIORITY
({$ifdef DEVELOP}fInfo: fli_WPWkcnter;{$endif}                 name: 'WKCNTER';                 dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WPWkct_Proc;{$endif}               name: 'WKCT_PROC';               dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WPSeq_Depend;{$endif}              name: 'SEQ_DEPEND';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WPSeqalpha;{$endif}                name: 'SEQALPHA';                dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WPPriority_Ralation;{$endif}       name: 'PRIORITY_RALATION';       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WPMach_Setup_Code_Level;{$endif}   name: 'MACH_SETUP_CODE_LEVEL';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WPUsr_Namecr;{$endif}              name: 'USR_NAMECR';              dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WPUsr_Timecr;{$endif}              name: 'USR_TIMECR';              dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_WPUsr_Namecg;{$endif}              name: 'USR_NAMECG';              dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WPUsr_Timecg;{$endif}              name: 'USR_TIMECG';              dom: dom_Timing),

//WKC_PROC
({$ifdef DEVELOP}fInfo: fli_WPrWkcnter;{$endif}                             name: 'WKCNTER';                      dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WPrWkct_Proc;{$endif}                           name: 'WKCT_PROC';                    dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WPrS_Descr;{$endif}                             name: 'S_DESCR';                      dom: dom_Txt28),
({$ifdef DEVELOP}fInfo: fli_WPrL_Descr;{$endif}                             name: 'L_DESCR';                      dom: dom_Text60),
({$ifdef DEVELOP}fInfo: fli_isNowPrdOrd_MQMGroup;{$endif}                   name: 'IsNowPrdOrd_MQMGroup';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_CanBeGroupedInMQM;{$endif}                      name: 'CanBeGroupedInMQM';            dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_wkcDefaultForAllowedSplit;{$endif}              name: 'DefaultForAllowedSplit';       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_wkcADForAllowedSplit;{$endif}                   name: 'ADForAllowedSplit';            dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_wkcADForSplitFamilyCode;{$endif}                name: 'ADForSplitFamilyCode';         dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_wkcProcType;{$endif}                            name: 'TYPE';                         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_BatchStandTime;{$endif}                         name: 'BatchStandardTime';            dom: dom_Type),

//WKC_PROD_LINE
({$ifdef DEVELOP}fInfo: fli_WPDLWkcnter;{$endif}      name: 'WKCNTER';       dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WPDLProd_Line;{$endif}    name: 'PROD_LINE';     dom: dom_Text4),
({$ifdef DEVELOP}fInfo: fli_WPLDate_Begin;{$endif}    name: 'DATE_BEGIN';    dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_WPLDate_End;{$endif}      name: 'DATE_END';      dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_WPLRes_Num_Pln;{$endif}   name: 'RES_NUM_PLN';   dom: dom_Numeric9_3),

//WKST
({$ifdef DEVELOP}fInfo: fli_WSWkst_Code;{$endif}                            name: 'WKST_CODE';                    dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WSWkdescr;{$endif}                              name: 'WKDESCR';                      dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_WSWkpasswd;{$endif}                             name: 'WKPASSWD';                     dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WSUsr_Namecr;{$endif}                           name: 'USR_NAMECR';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WSUsr_Timecr;{$endif}                           name: 'USR_TIMECR';                   dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_WSUsr_Namecg;{$endif}                           name: 'USR_NAMECG';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WSUsr_Timecg;{$endif}                           name: 'USR_TIMECG';                   dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_WSWorkstationtype;{$endif}                      name: 'WORKSTATIONTYPE';              dom: dom_Type),

//WKS_WKC
({$ifdef DEVELOP}fInfo: fli_WWWkst_Code;{$endif}    name: 'WKST_CODE';    dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WWWkcnter;{$endif}      name: 'WKCNTER';      dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WWTypeusd;{$endif}      name: 'TYPEUSED';     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WWVisible;{$endif}      name: 'VISIBLE';      dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WWUsr_Namecr;{$endif}   name: 'USR_NAMECR';   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WWUsr_Timecr;{$endif}   name: 'USR_TIMECR';   dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_WWUsr_Namecg;{$endif}   name: 'USR_NAMECG';   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WWUsr_Timecg;{$endif}   name: 'USR_TIMECG';   dom: dom_Timing),

//EXT_INFO
//({$ifdef DEVELOP}fInfo: fli_EIConne_Key;{$endif}                            name: 'CONNE_KEY';                    dom: dom_Text25),
({$ifdef DEVELOP}fInfo: fli_EIConne_Key;{$endif}                            name: 'CONNE_KEY';                    dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_EIInfo_Line_Num;{$endif}                        name: 'INFO_LINE_NUM';                dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_EIInfo_Area;{$endif}                            name: 'INFO_AREA';                    dom: dom_Text70),
({$ifdef DEVELOP}fInfo: fli_EIUsr_Namecg;{$endif}                           name: 'USR_NAMECG';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_EIUsr_Timecg;{$endif}                           name: 'USR_TIMECG';                   dom: dom_Timing),

//EXT_INFO_HDR
//({$ifdef DEVELOP}fInfo: fli_EHConne_Key;{$endif}                            name: 'CONNE_KEY';                    dom: dom_Text25),
({$ifdef DEVELOP}fInfo: fli_EHConne_Key;{$endif}                            name: 'CONNE_KEY';                    dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_EHConne_Type;{$endif}                           name: 'CONNE_TYPE';                   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_EHDue_Date;{$endif}                             name: 'DUE_DATE';                     dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_EHUsr_Namecg;{$endif}                           name: 'USR_NAMECG';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_EHUsr_Timecg;{$endif}                           name: 'USR_TIMECG';                   dom: dom_Timing),

//EXT_CONNECTION
({$ifdef DEVELOP}fInfo: fli_ECPreq_No;{$endif}                              name: 'PREQ_NO';                      dom: dom_Text30),
//({$ifdef DEVELOP}fInfo: fli_ECConne_Key;{$endif}                            name: 'CONNE_KEY';                    dom: dom_Text25),
({$ifdef DEVELOP}fInfo: fli_ECConne_Key;{$endif}                            name: 'CONNE_KEY';                    dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_ECNum_Levels;{$endif}                           name: 'NUM_LEVELS';                   dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_ECConn_Certent_Level;{$endif}                   name: 'CONN_CERTENT_LEVEL';           dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ECUsr_Namecg;{$endif}                           name: 'USR_NAMECG';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_ECUsr_Timecg;{$endif}                           name: 'USR_TIMECG';                   dom: dom_Timing),

//PROD_REQCONN
({$ifdef DEVELOP}fInfo: fli_ICPreq_No;{$endif}        name: 'PREQ_NO';        dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_ICPrev_Preq_No;{$endif}   name: 'PREV_PREQ_NO';   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_ICUsr_Namecg;{$endif}     name: 'USR_NAMECG';     dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_ICUsr_Timecg;{$endif}     name: 'USR_TIMECG';     dom: dom_Timing),
//({$ifdef DEVELOP}fInfo: fli_PRCProductionRequestNo;{$endif}   name: 'CPRREQ';                       dom: dom_Text30),
//({$ifdef DEVELOP}fInfo: fli_PRCPreviousProductionNo;{$endif}  name: 'CPRPRD';                       dom: dom_Text30),
//({$ifdef DEVELOP}fInfo: fli_PRCConnectionType;{$endif}        name: 'CCNNTP';                       dom: dom_Text2),
//({$ifdef DEVELOP}fInfo: fli_PRCUserNameChanged;{$endif}       name: 'CUSRCH';                       dom: dom_Text15),
//({$ifdef DEVELOP}fInfo: fli_PRCDateChanged;{$endif}           name: 'CDTOCH';                       dom: dom_Timing),

//PROD_INFO
({$ifdef DEVELOP}fInfo: fli_PIPreq_No;{$endif}         name: 'PREQ_NO';         dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PIInfo_Type;{$endif}       name: 'INFO_TYPE';       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PIPstep_Id;{$endif}        name: 'PSTEP_ID';        dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_PIInfo_Line_Num;{$endif}   name: 'INFO_LINE_NUM';   dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PIInfo_Area;{$endif}       name: 'INFO_AREA';       dom: dom_Text70),
({$ifdef DEVELOP}fInfo: fli_PIUsr_Namecg;{$endif}      name: 'USR_NAMECG';      dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PIUsr_Timecg;{$endif}      name: 'USR_TIMECG';      dom: dom_Timing),
//({$ifdef DEVELOP}fInfo: fli_PIDefault;{$endif}                name: 'NANNUL';                       dom: dom_Type),
//({$ifdef DEVELOP}fInfo: fli_PIProductRequestNo;{$endif}       name: 'NPRREQ';                       dom: dom_Text30),
//({$ifdef DEVELOP}fInfo: fli_PIProductionStep;{$endif}         name: 'NPRSTP';                       dom: dom_midId),
//({$ifdef DEVELOP}fInfo: fli_PIInfoType;{$endif}               name: 'NINFTY';                       dom: dom_Type),
//({$ifdef DEVELOP}fInfo: fli_PIInformationLineNo;{$endif}      name: 'NINFLN';                       dom: dom_shortId),
//({$ifdef DEVELOP}fInfo: fli_PIInformationArea;{$endif}        name: 'NINFAR';                       dom: dom_Text70),
//({$ifdef DEVELOP}fInfo: fli_PIUserNameChanged;{$endif}        name: 'NUSRCH';                       dom: dom_Text15),
//({$ifdef DEVELOP}fInfo: fli_PIDateChanged;{$endif}            name: 'NDTOCH';                       dom: dom_Timing),

//PROP_PROD
({$ifdef DEVELOP}fInfo: fli_PPPreq_No;{$endif}      name: 'PREQ_NO';      dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PPPStep_Id;{$endif}     name: 'PSTEP_ID';     dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_PPProperty;{$endif}     name: 'PROPERTY';     dom: dom_Text5),
({$ifdef DEVELOP}fInfo: fli_PPRsc_Code;{$endif}     name: 'RSC_CODE';     dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_PPValue;{$endif}        name: 'VALUE';        dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_PPUsr_Namecg;{$endif}   name: 'USR_NAMECG';   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PPUsr_Timecg;{$endif}   name: 'USR_TIMECG';   dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PPNumericVal;{$endif}   name: 'NUMERIC_VALUE';   dom: dom_Numeric18_2),


//PROD_REQ
({$ifdef DEVELOP}fInfo: fli_PRDiv_Code;{$endif}                             name: 'DIV_CODE';                     dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PRDsp_Code;{$endif}                             name: 'DSP_CODE';                     dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_PRBch_Code;{$endif}                             name: 'BCH_CODE';                     dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_PRReproc_No;{$endif}                            name: 'REPROC_NO';                    dom: dom_ShtstId),
({$ifdef DEVELOP}fInfo: fli_PRPreq_No;{$endif}                              name: 'PREQ_NO';                      dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PRHistorical_Req;{$endif}                       name: 'HISTORICAL_REQ';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PRUsr_Namecg;{$endif}                           name: 'USR_NAMECG';                   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PRUsr_Timecg;{$endif}                           name: 'USR_TIMECG';                   dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PRModulehandle;{$endif}                         name: 'MODULEHANDLE';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PRMqm_Historic_Date;{$endif}                    name: 'MQM_HISTORIC_DATE';            dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PRTemplateCode;{$endif}                         name: 'TEMPLATECODE';                 dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PRFamilyCode;{$endif}                           name: 'FAMILYCODE';                   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PRIsFamily;{$endif}                             name: 'ISFAMILY';                     dom: dom_Type),

//PROD_STEP
({$ifdef DEVELOP}fInfo: fli_PDPreq_No;{$endif}                     name: 'PREQ_NO';                     dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PDPstep_Id;{$endif}                    name: 'PSTEP_ID';                    dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_PDUpd_Code;{$endif}                    name: 'UPD_CODE';                    dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_PDToSched;{$endif}                     name: 'TO_SCHED';                    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDPrv_Step_Sched;{$endif}              name: 'PRV_STEP_SCHED';              dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_PDPrv_Step_True;{$endif}               name: 'PRV_STEP_TRUE';               dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_PDNex_Step_Sched;{$endif}              name: 'NEX_STEP_SCHED';              dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_PDNex_Step_True;{$endif}               name: 'NEX_STEP_TRUE';               dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_PDStepType;{$endif}                    name: 'STEP_TYP';                    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDMat_Arrv_Date;{$endif}               name: 'MAT_ARRV_DATE';               dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PDFrc_Mat_Date;{$endif}                name: 'FRC_MAT_DATE';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDPlan_Start;{$endif}                  name: 'PLAN_START';                  dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PDLow_Limit_Time_Strt;{$endif}         name: 'LOW_LIMIT_TIME_STRT';         dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PDFrc_Low_Date;{$endif}                name: 'FRC_LOW_DATE';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDPlan_End;{$endif}                    name: 'PLAN_END';                    dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PDHigh_Limit_Timeend;{$endif}          name: 'HIGH_LIMIT_TIMEND';           dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PDFrc_High_date;{$endif}               name: 'FRC_HIGH_DATE';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDWkcnter;{$endif} 	                   name: 'WKCNTER';                     dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PDWkct_Proc;{$endif}                   name: 'WKCT_PROC';                   dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PDInit_Quent;{$endif}                  name: 'INIT_QUENT';                  dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_PDFin_Quent;{$endif}                   name: 'FIN_QUENT';                   dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_PDWeight;{$endif}                      name: 'WEIGHT';                      dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_PDDesc_um;{$endif}                     name: 'DESC_UM';                     dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PDCal;{$endif}                         name: 'CAL';                         dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PDSetup_Time_Stp;{$endif}              name: 'SETUP_TIME_STP';              dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_PDExc_Time_Stp;{$endif}                name: 'EXC_TIME_STP';                dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_PDRes_Num_Pln;{$endif}                 name: 'RES_NUM_PLN';                 dom: dom_Numeric9_3),
({$ifdef DEVELOP}fInfo: fli_PDAllow_Split;{$endif}                 name: 'ALLOW_SPLIT';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDStep_Handle_Reproces;{$endif}        name: 'STEP_HANDLE_REPROCES';        dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDStep_Part_Gen_Plan;{$endif}          name: 'STEP_PART_GEN_PLAN';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDStep_Can_Group;{$endif}              name: 'STEP_CAN_GROUP';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDForced_Grp_No;{$endif}               name: 'FORCED_GRP_NO';               dom: dom_LongId),
({$ifdef DEVELOP}fInfo: fli_PDForced_Grp_No_Str;{$endif}           name: 'FORCED_GRP_NO_Str';           dom: dom_Text16),
({$ifdef DEVELOP}fInfo: fli_GroupStepNumber;{$endif}               name: 'GROUPSTEPNUMBER';             dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_PDConn_Type_Prev_Step_Split;{$endif}   name: 'CONN_TYPE_PREV_STEP_SPLIT';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDFrc_Overlapp;{$endif}                name: 'FRC_OVERLAPP';                dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDStep_Closed;{$endif}                 name: 'STEP_CLOSED';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDUsr_Namecg;{$endif}                  name: 'USR_NAMECG';                  dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PDUsr_Timecg;{$endif}                  name: 'USR_TIMECG';                  dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PDMcmapplydatepenalty;{$endif}         name: 'MCMAPPLYDATEPENALTY';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDMcmleadqueuetimeprevstep;{$endif}    name: 'MCMLEADQUEUETIMEPREVSTEP';    dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PDMcmmaxjobsgap;{$endif}               name: 'MCMMAXJOBSGAP';               dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PDMcmmaxstepsgap;{$endif}              name: 'MCMMAXSTEPSGAP';              dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PDSchdule_By_Mcm;{$endif}              name: 'SCHDULE_BY_MCM';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDSplitFamaly;{$endif}                 name: 'SPLITED_FAMILY';              dom: dom_text12),
({$ifdef DEVELOP}fInfo: fli_PDLearningCurveCode;{$endif}           name: 'LEARNING_CURVE_CODE';         dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_PDLearningCurveType;{$endif}           name: 'LEARNING_CURVE_TYPE';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDApprovalDate;{$endif}                name: 'APPROVAL_DATE';         dom: dom_timing),

//PROD_REQHDR
({$ifdef DEVELOP}fInfo: fli_PHPreq_No;{$endif}               name: 'PREQ_NO';               dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PHUpd_Code;{$endif}              name: 'UPD_CODE';              dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PHHistorical_Req;{$endif}        name: 'HISTORICAL_REQ';        dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PHReq_Origin;{$endif}            name: 'REQ_ORIGIN';            dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_PHProd_Line;{$endif}             name: 'PROD_LINE';             dom: dom_Text4),
({$ifdef DEVELOP}fInfo: fli_PHType_Prod;{$endif}             name: 'TYPE_PROD';             dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PHProd_Family;{$endif}           name: 'PROD_FAMILY';           dom: dom_Text110),
({$ifdef DEVELOP}fInfo: fli_PHMaterial_Family;{$endif}       name: 'MATERIAL_FAMILY';       dom: dom_Text110),
({$ifdef DEVELOP}fInfo: fli_PHProd_Um;{$endif}               name: 'PROD_UM';               dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PHProd_Low_Time_Strt;{$endif}    name: 'PROD_LOW_TIME_STRT';    dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PHProd_Delivy_Date;{$endif}      name: 'PROD_DELIVY_DATE';      dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PHFrc_Del_Date;{$endif}          name: 'FRC_DEL_DATE';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PHUsr_Namecg;{$endif}            name: 'USR_NAMECG';            dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PHUsr_Timecg;{$endif}            name: 'USR_TIMECG';            dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PHMcm_Requesttype;{$endif}       name: 'MCM_REQUESTTYPE';       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PHMcm_Capacitysearch;{$endif}    name: 'MCM_CAPACITYSEARCH';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PHMcm_Materialsearch;{$endif}    name: 'MCM_MATERIALSEARCH';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PHMcm_Requesteddate;{$endif}     name: 'MCM_REQUESTEDDATE';     dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PHMcm_Requesteddatetype;{$endif} name: 'MCM_REQUESTEDDATETYPE'; dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PHMcm_Priority;{$endif}          name: 'MCM_PRIORITY';          dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PHMcm_Loaderdays;{$endif}        name: 'MCM_LOADERDAYS';        dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PHModulehandle;{$endif}          name: 'MODULEHANDLE';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PHSplitConfLevels;{$endif}       name: 'SPLITCONFLEVELS';       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PHLead_Step_Splited;{$endif}     name: 'LEAD_STEP_SPLITED';     dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PHServing_Code;{$endif}          name: 'SERVING_CODE';          dom: dom_Text25),
({$ifdef DEVELOP}fInfo: fli_PHServed_Code;{$endif}           name: 'SERVED_CODE';           dom: dom_Text25),

//({$ifdef DEVELOP}fInfo: fli_PHSplitStartPosition;{$endif}    name: 'SPLITSTARTPOSITION';    dom: dom_shtstId),
//({$ifdef DEVELOP}fInfo: fli_PHSplitEndPosition;{$endif}      name: 'SPLITENDPOSITION';      dom: dom_shtstId),
//({$ifdef DEVELOP}fInfo: fli_MqmSplitId;{$endif}              name: 'MQM_SPLIT_ID';          dom: dom_text10),

//PROD_STEP_BATCH_SIZE
({$ifdef DEVELOP}fInfo: fli_SBPreq_No;{$endif}              name: 'PREQ_NO';                 dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_SBPStep_Id;{$endif}             name: 'PSTEP_ID';                dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_SBBch_Um;{$endif}               name: 'BCH_UM';                  dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_SBMultipilr_To_Batch;{$endif}   name: 'MULTIPILR_TO_BATCH_UM';   dom: dom_Numeric14_4),

//PROD_STEP_TIMES
({$ifdef DEVELOP}fInfo: fli_STPreq_No;{$endif}              name: 'PREQ_NO';              dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_STPstep_Id;{$endif}             name: 'PSTEP_ID';             dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_STWkcnter;{$endif}              name: 'WKCNTER';              dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_STWkct_Proc;{$endif}            name: 'WKCT_PROC';            dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_STRes_Category;{$endif}         name: 'RES_CATEGORY';         dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_STRsc_Code;{$endif}             name: 'RSC_CODE';             dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_STMachine_Setup_Code;{$endif}   name: 'MACHINE_SETUP_CODE';   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_STSetup_Time_Job;{$endif}       name: 'SETUP_TIME_JOB';       dom: dom_Numeric11_3),
({$ifdef DEVELOP}fInfo: fli_STExc_Time_Init_Qty;{$endif}    name: 'EXC_TIME_INIT_QTY';    dom: dom_Numeric11_3),

//PROD_SCHED_PROGRESS
({$ifdef DEVELOP}fInfo: fli_SPPreq_No;{$endif}               name: 'PREQ_NO';               dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_SPPstep_Id;{$endif}              name: 'PSTEP_ID';              dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_SPPsubst_Id;{$endif}             name: 'PSUBST_ID';             dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_SPReproc_No;{$endif}             name: 'REPROC_NO';             dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_SPLast_Prog_Type;{$endif}        name: 'LAST_PROG_TYPE';        dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_SPRsc_Code;{$endif}              name: 'RSC_CODE';              dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_SPProgresed_Group;{$endif}       name: 'PROGRESED_GROUP';       dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_SPProgrstart;{$endif}            name: 'PROGRSTART';            dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_SPCurr_Prg_Date;{$endif}         name: 'CURR_PRG_DATE';         dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_SPProgrend;{$endif}              name: 'PROGREND';              dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_SPQty;{$endif}                   name: 'QTY';                   dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_SPRemain_Time;{$endif}           name: 'REMAIN_TIME';           dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_SPLast_Prog_Type_Host;{$endif}   name: 'LAST_PROG_TYPE_HOST';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_SPRsc_Code_Host;{$endif}         name: 'RSC_CODE_HOST';         dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_SPProgrstart_Host;{$endif}       name: 'PROGRSTART_HOST';       dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_SPCurr_Prg_Date_Host;{$endif}    name: 'CURR_PRG_DATE_HOST';    dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_SPProgend_Host;{$endif}          name: 'PROGREND_HOST';         dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_SPQty_Host;{$endif}              name: 'QTY_HOST';              dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_SPRemain_Time_Host;{$endif}      name: 'REMAIN_TIME_HOST';      dom: dom_Numeric9_2),

//   NowProgress

({$ifdef DEVELOP}fInfo: fli_NP_ProgressNumber;{$endif}       name: 'PROGRESS_NUMBER';       dom: dom_Text15),
({$ifdef DEVELOP}fInfo: fli_NP_ProgressTemplateCode;{$endif} name: 'PROGRESS_TAMPLATECODE'; dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_NP_DemandCounterCode;{$endif}    name: 'DEMAND_COUNTER_CODE';   dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_NP_DemandCode;{$endif}           name: 'DEMAND_CODE';           dom: dom_Text15),
({$ifdef DEVELOP}fInfo: fli_NP_DemandStep;{$endif}           name: 'DEMAND_STEP';           dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_NP_TemplateCode;{$endif}         name: 'DEMAND_TEMPLATE_CODE';  dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_NP_OriginalEndDate;{$endif}      name: 'ORIG_END_DATE';         dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_NP_StartDate;{$endif}            name: 'START_DATE_TIME';            dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_NP_EndDate;{$endif}              name: 'END_DATE_TIME';              dom: dom_timing),
({$ifdef DEVELOP}fInfo: fli_NP_ResourceCode;{$endif}         name: 'RESOURCE_CODE';         dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_NP_PrimaryQty;{$endif}           name: 'PRIMARY_QTY';           dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_NP_PrimaryUOmCode;{$endif}       name: 'PRIMARY_UM_CODE';       dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_NP_SecondaryQty;{$endif}         name: 'SECONDARY_QTY';         dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_NP_SecondaryUOmCode;{$endif}     name: 'SECONDARY_UM_CODE';     dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_NP_PackagingQty;{$endif}         name: 'PACKAGING_QTY';         dom: dom_quant),
({$ifdef DEVELOP}fInfo: fli_NP_PackagingUOmCode;{$endif}     name: 'PACKAGING_UM_CODE';     dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_NP_PercentInProgress;{$endif}    name: 'PERCENT_IN_PROGRESS';   dom: dom_Numeric6_3),
({$ifdef DEVELOP}fInfo: fli_NP_FinalToInitialDivider;{$endif}name: 'FINAL_TO_INITIAL_DIVIDER';   dom: dom_Numeric11_9),
({$ifdef DEVELOP}fInfo: fli_NP_ClosedStep;{$endif}           name: 'CLOSED_STEP';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_NP_BasePrimaryUoMCode;{$endif}    name: 'BASE_PRIMARY_UM_CODE';   dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_NP_MultiplierToBasePrimaryUoMCode;{$endif} name: 'MULT_TO_BASE_PRIMARY_UMCODE';   dom: dom_Numeric15_5),

//MATERIAL
({$ifdef DEVELOP}fInfo: fli_MTPreq_No;{$endif}              name: 'PREQ_NO';              dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_MTPstep_Id;{$endif}             name: 'PSTEP_ID';             dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_MTOrg_Step;{$endif}             name: 'ORG_STEP';             dom: dom_midId),
({$ifdef DEVELOP}fInfo: fli_MTWkcnter;{$endif}              name: 'WKCNTER';              dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_MTRes_Cat_Code;{$endif}         name: 'RES_CAT_CODE';         dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_MTRsc_Code;{$endif}             name: 'RSC_CODE';             dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_MTMachine_Setup_Code;{$endif}   name: 'MACHINE_SETUP_CODE';   dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_MTAlternative_Code;{$endif}     name: 'ALTERNATIVE_CODE';     dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_MTType_Prod;{$endif}            name: 'TYPE_PROD';            dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_MTProduct_Code;{$endif}         name: 'PRODUCT_CODE';         dom: dom_Text110),
({$ifdef DEVELOP}fInfo: fli_MTNet_Group_Code;{$endif}       name: 'NET_GROUP_CODE';       dom: dom_Text16),
({$ifdef DEVELOP}fInfo: fli_MTIssue_Code;{$endif}           name: 'ISSUE_CODE';           dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_MTSeq_Issued;{$endif}           name: 'SEQ_ISSUED';           dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_MTMat_Balance;{$endif}          name: 'MAT_BALANCE';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MTQty_Alloc;{$endif}            name: 'QTY_ALLOC';            dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_MTHigh_Date_Alloc;{$endif}      name: 'HIGH_DATE_ALLOC';      dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_MTSearch_Mat_Alloc;{$endif}     name: 'SEARCH_MAT_ALLOC';     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MTSettled;{$endif}              name: 'SETTLED';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MTQuantity_Issue;{$endif}       name: 'QUANTITY_ISSUE';       dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_MTReq_Quantity;{$endif}         name: 'REQ_QUANTITY';         dom: dom_Numeric11_2),

//PRODUCED_ARTICLE
({$ifdef DEVELOP}fInfo: fli_PAPreq_No;{$endif}          name: 'PREQ_NO';          dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PASequence;{$endif}         name: 'SEQUENCE';         dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PAProduct_Code;{$endif}     name: 'PRODUCT_CODE';     dom: dom_Text110),
({$ifdef DEVELOP}fInfo: fli_PANet_Group_Code;{$endif}   name: 'NET_GROUP_CODE';   dom: dom_Text16),
({$ifdef DEVELOP}fInfo: fli_PAAlloc_Req;{$endif}        name: 'ALLOC_REQ';        dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PAProd_Balance;{$endif}     name: 'PROD_BALANCE';     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PARsc_Code;{$endif}         name: 'RSC_CODE';         dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_PASettled;{$endif}          name: 'SETTLED';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PAReq_Quantity;{$endif}     name: 'REQ_QUANTITY';     dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_PAQty_Produced;{$endif}     name: 'QTY_PRODUCED';     dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_PAQty_Alloc;{$endif}        name: 'QTY_ALLOC';        dom: dom_Numeric11_2),

//PRODUCTS
({$ifdef DEVELOP}fInfo: fli_PARType_Prod;{$endif}        name: 'TYPE_PROD';        dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PARProduct_Code;{$endif}     name: 'PRODUCT_CODE';     dom: dom_Text110),
({$ifdef DEVELOP}fInfo: fli_PARProduct_Nature;{$endif}   name: 'PRODUT_NATURE';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PARStr_Cons_Point;{$endif}   name: 'STR_CONS_POINT';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PAREnd_Cons_Point;{$endif}   name: 'END_CONS_POINT';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PARInfo_Area;{$endif}        name: 'INFO_AREA';        dom: dom_Text70),
({$ifdef DEVELOP}fInfo: fli_PARStdpurcorprodtime;{$endif}name: 'STDPURCORPRODTIME';dom: dom_shtstId),

//BALANCE_HEADER
({$ifdef DEVELOP}fInfo: fli_BHType_Prod;{$endif}        name: 'TYPE_PROD';        dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_BHProduct_Code;{$endif}     name: 'PRODUCT_CODE';     dom: dom_Text110),
({$ifdef DEVELOP}fInfo: fli_BHNet_Group_Code;{$endif}   name: 'NET_GROUP_CODE';   dom: dom_Text16),
({$ifdef DEVELOP}fInfo: fli_BHDue_Date;{$endif}         name: 'DUE_DATE';         dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_BHQty;{$endif}              name: 'QTY';              dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_BHInfo_Area;{$endif}        name: 'INFO_AREA';        dom: dom_Text70),
({$ifdef DEVELOP}fInfo: fli_BHUsr_Namecg;{$endif}       name: 'USR_NAMECG';       dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_BHUsr_Timecg;{$endif}       name: 'USR_TIMECG';       dom: dom_Timing),

//BALANCE_DETAIL
({$ifdef DEVELOP}fInfo: fli_BDType_Prod;{$endif}        name: 'TYPE_PROD';        dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_BDProduct_Code;{$endif}     name: 'PRODUCT_CODE';     dom: dom_Text110),
({$ifdef DEVELOP}fInfo: fli_BDNet_Group_Code;{$endif}   name: 'NET_GROUP_CODE';   dom: dom_Text16),
({$ifdef DEVELOP}fInfo: fli_BDDue_Date;{$endif}         name: 'DUE_DATE';         dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_BDOccupy_Code;{$endif}      name: 'OCCUPY_CODE';      dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_BDInfo_Area;{$endif}        name: 'INFO_AREA';        dom: dom_Text70),
({$ifdef DEVELOP}fInfo: fli_BDQty;{$endif}              name: 'QTY';              dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_BDUsr_Namecg;{$endif}       name: 'USR_NAMECG';       dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_BDUsr_Timecg;{$endif}       name: 'USR_TIMECG';       dom: dom_Timing),

//MQMCN00F
({$ifdef DEVELOP}fInfo: fli_ControlServerStatus;{$endif}                    name: 'KSRSTT';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ControlServerStarted;{$endif}                   name: 'KSRSTR';                       dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_ControlServerEnded;{$endif}                     name: 'KSREND';                       dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_ControlClientStatus;{$endif}                    name: 'KCLSTT';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ControlClientStarted;{$endif}                   name: 'KCLSTR';                       dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_ControlClientEnded;{$endif}                     name: 'KCLEND';                       dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_ControlClientLastOperation;{$endif}             name: 'KCLOPR';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ControlClientLastUploadSuccess;{$endif}         name: 'KCLUPL';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ControlServerCanUpdate;{$endif}                 name: 'KSRUPD';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ControlServerUpdateTime;{$endif}                name: 'KUPDAT';                       dom: dom_Timing),

//WCMAC00F
({$ifdef DEVELOP}fInfo: fli_WorkCenterDefault;{$endif}                      name: 'MANNUL';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WorkCenterCode;{$endif}                         name: 'MCDMAC';                       dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WorkCenterGroup;{$endif}                        name: 'MCDMAG';                       dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WorkCenterShortDesc;{$endif}                    name: 'MDESCR';                       dom: dom_Text40),
({$ifdef DEVELOP}fInfo: fli_WorkCenterLongDesc;{$endif}                     name: 'MSUPDS';                       dom: dom_Text100),
({$ifdef DEVELOP}fInfo: fli_WorkCenterBatchContFlag;{$endif}                name: 'MBCFLG';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WorkCenterDummyField;{$endif}                   name: 'MMACOP';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WorkCenterHandledByMQM;{$endif}                 name: 'HandledByMQM';                 dom: dom_Type),

//TABLE00F
({$ifdef DEVELOP}fInfo: fli_TDefault;{$endif}                               name: 'ANNUL';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_TName;{$endif}                                  name: '"TABLE"';                      dom: dom_Text4),
({$ifdef DEVELOP}fInfo: fli_TKey;{$endif}                                   name: '"KEY"';                        dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_TData;{$endif}                                  name: 'DATA';                         dom: dom_Text111),

//WCPRO00F
({$ifdef DEVELOP}fInfo: fli_WCODefault;{$endif}                             name: 'AANNUL';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WCOWorkCenterCode;{$endif}                      name: 'ACDMAC';                       dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WCOWorkCenterOperationCode;{$endif}             name: 'ACDMAP';                       dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WCOWorkCenterShortDesc;{$endif}                 name: 'ADESCR';                       dom: dom_Text14),
({$ifdef DEVELOP}fInfo: fli_WCOWorkCenterLongDesc;{$endif}                  name: 'ASUPDS';                       dom: dom_Text30),

//PGTUR00F
({$ifdef DEVELOP}fInfo: fli_CalDefault;{$endif}                             name: 'KANNUL';                       dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_CalCode;{$endif}                                name: 'KCDCAL';                       dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_CalDate;{$endif}                                name: 'KCALDT';                       dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_CalProgressiveHours;{$endif}                    name: 'KPRGWH';                       dom: dom_Numeric15_5),
({$ifdef DEVELOP}fInfo: fli_CalFirstShiftStart;{$endif}                     name: 'KINZT1';                       dom: dom_Numeric4_0),
({$ifdef DEVELOP}fInfo: fli_CalFirstShiftEnd;{$endif}                       name: 'KFINT1';                       dom: dom_Numeric4_0),
({$ifdef DEVELOP}fInfo: fli_CalSecondShiftStart;{$endif}                    name: 'KINZT2';                       dom: dom_Numeric4_0),
({$ifdef DEVELOP}fInfo: fli_CalSecondShiftEnd;{$endif}                      name: 'KFINT2';                       dom: dom_Numeric4_0),
({$ifdef DEVELOP}fInfo: fli_CalThirdShiftStart;{$endif}                     name: 'KINZT3';                       dom: dom_Numeric4_0),
({$ifdef DEVELOP}fInfo: fli_CalThirdShiftEnd;{$endif}                       name: 'KFINT3';                       dom: dom_Numeric4_0),
({$ifdef DEVELOP}fInfo: fli_CalFourthShiftStart;{$endif}                    name: 'KINZT4';                       dom: dom_Numeric4_0),
({$ifdef DEVELOP}fInfo: fli_CalFourthShiftEnd;{$endif}                      name: 'KFINT4';                       dom: dom_Numeric4_0),
({$ifdef DEVELOP}fInfo: fli_CalUserNameChanged;{$endif}                     name: 'KUSRNM';                       dom: dom_Text15),
({$ifdef DEVELOP}fInfo: fli_CalDateChanged;{$endif}                         name: 'KDTORA';                       dom: dom_Timing),

//ROUTINGSTEPTIMETYPE
({$ifdef DEVELOP}fInfo: fli_RSTTCode{$endif}                                name: 'CODE';                         dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_RSTTShortDescription{$endif}                    name: 'SHORTDESCRIPTION';             dom: dom_Text40),
({$ifdef DEVELOP}fInfo: fli_RSTTType{$endif}                                name: '"TYPE"';                       dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_RSTTApply{$endif}                               name: 'APPLY';                        dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_RSTTApplyTypeCode{$endif}                       name: 'APPLYTYPECODE';                dom: dom_Text20),

//PRODUCTIONDEMANDTEMPLATE
({$ifdef DEVELOP}fInfo: fli_PDTCode{$endif}                                 name: 'CODE';                         dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PDTShortDesc{$endif}                            name: 'SHORTDESCRIPTION';             dom: dom_Text40),
({$ifdef DEVELOP}fInfo: fli_PDTHandledByMQM{$endif}                         name: 'HandledByMQM';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDTHandledByMCM{$endif}                         name: 'HandledByMCM';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDTApplyDatePenalty{$endif}                     name: 'APPLYDATEPENALTY';             dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDTMaxGapBtwEndDates{$endif}                    name: 'MAXGAPBTWENDDATES';            dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_PDTMaxGapBtwEndStrDates{$endif}                 name: 'MAXGAPBTWENDSTRDATES';         dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_PDTMcmRequestType{$endif}                       name: 'MCMREQUESTTYPE';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDTSearchCapacity{$endif}                       name: 'SEARCHCAPACITY';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDTCapAddDataTableName{$endif}                  name: 'CAPADDDATATABLENAME';          dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PDTCapAddDataColumnName{$endif}                 name: 'CAPADDDATACOLUMNNAME';         dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PDTSearchMaterial{$endif}                       name: 'SEARCHMATERIAL';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDTMatAddDataTableName{$endif}                  name: 'MATADDDATATABLENAME';          dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PDTMatAddDataColumnName{$endif}                 name: 'MATADDDATACOLUMNNAME';         dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PDTRequestDateType{$endif}                      name: 'REQUESTDATETYPE';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDTLoadPriority{$endif}                         name: 'LOADPRIORITY';                 dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_PDTPriAddDataTableName{$endif}                  name: 'PRIADDDATATABLENAME';          dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PDTPriAddDataColumnName{$endif}                 name: 'PRIADDDATACOLUMNNAME';         dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PDTAutoLoaderDays{$endif}                       name: 'AUTOLOADERDAYS';               dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PDTDaysToKeepHistory{$endif}                    name: 'DAYSTOKEEPHISTORY';            dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PDTDemandKeyLinkAdditionalData{$endif}          name: 'DEMANDKEYLINKADDITIONALDATA';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PDServedCodeTableName{$endif}                   name: 'SERVEDCODETABLENAME';          dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PDServedCodeColumName{$endif}                   name: 'SERVEDCODECOLUMNAME';          dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PDServingCodeTableName{$endif}                  name: 'SERVINGCODETABLENAME';         dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PDServingCodeColumName{$endif}                  name: 'SERVINGCODECOLUMNAME';         dom: dom_text30),
({$ifdef DEVELOP}fInfo: fli_PDServingDefinition{$endif}                     name: 'SERVINGCODEDEFNITION';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDServedDefinition{$endif}                      name: 'SERVEDCODEDEFNITION';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PDServedItemType{$endif}                        name: 'ITEMTYPESERVED';               dom: dom_text3),

//PRODUCTION_REQ_NO
({$ifdef DEVELOP}fInfo: fli_PRNProductionRequestNo{$endif}                  name: 'MPRREQ';                       dom: dom_Text30),

//LOGICALWAREHOUSE
({$ifdef DEVELOP}fInfo: fli_LWCode{$endif}                                  name: 'CODE';                         dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_LWShortDesc{$endif}                             name: 'SHORTDESCRIPTION';             dom: dom_Text40),
({$ifdef DEVELOP}fInfo: fli_LWMqmGroupCode{$endif}                          name: 'MQMGROUPCODE';                 dom: dom_Text8),

//MATERIAL_SUP_HEADER
({$ifdef DEVELOP}fInfo: fli_MSHWkcnter{$endif}                name: 'WKCNTER';                dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_MSHWkct_Proc{$endif}              name: 'WKCT_PROC';              dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_MSHRes_Cat_Code{$endif}           name: 'RES_CAT_CODE';           dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_MSHRsc_Code{$endif}               name: 'RSC_CODE';               dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_MSHType_Prod{$endif}              name: 'TYPE_PROD';              dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_MSHWait_Prev_Qty{$endif}          name: 'WAIT_PREV_QTY';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MSHMin_Qty_Pass_Nxt{$endif}       name: 'MIN_QTY_PASS_NXT';       dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_MSHMin_Qty_Prev_Stp{$endif}       name: 'MIN_QTY_PREV_STP';       dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_MSHMin_Del_Wait_Days{$endif}      name: 'MIN_DEL_WAIT_DAYS';      dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MSHMin_Del_Wait_Hrs{$endif}       name: 'MIN_DEL_WAIT_HRS';       dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MSHMin_Del_Wait_Min{$endif}       name: 'MIN_DEL_WAIT_MIN';       dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MSHMax_Del_Wait_Days{$endif}      name: 'MAX_DEL_WAIT_DAYS';      dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MSHMax_Del_Wait_Hrs{$endif}       name: 'MAX_DEL_WAIT_HRS';       dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MSHMax_Del_Wait_Min{$endif}       name: 'MAX_DEL_WAIT_MIN';       dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MSHPart_Del{$endif}               name: 'PART_DEL';               dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MSHUpd_Bal_Hrs{$endif}            name: 'UPD_BAL_HRS';            dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MSHUpd_Bal_Qty{$endif}            name: 'UPD_BAL_QTY';            dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_MSHUpd_Req_Prev_Stp_Hrs{$endif}   name: 'UPD_REQ_PREV_STP_HRS';   dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MSModulerule{$endif}              name: 'MODULERULE';             dom: dom_Type),


//MATERIAL_SUP_DETAIL
({$ifdef DEVELOP}fInfo: fli_MSDWkcnter{$endif}           name: 'WKCNTER';           dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_MSDWkct_Proc{$endif}         name: 'WKCT_PROC';         dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_MSDRes_Cat_Code{$endif}      name: 'RES_CAT_CODE';      dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_MSDRsc_Code{$endif}          name: 'RSC_CODE';          dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_MSDType_Prod{$endif}         name: 'TYPE_PROD';         dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_MSDSearch_Balance{$endif}    name: 'SEARCH_BALANCE';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MSDWait_Entire_Mat{$endif}   name: 'WAIT_ENTIRE_MAT';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_MSDIssue_Trans_Mat{$endif}   name: 'ISSUE_TRANS_MAT';   dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_MSDMinQty{$endif}            name: 'MINQTY';            dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_MSDUpd_Req_Hrs{$endif}       name: 'UPD_REQ_HRS';       dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_MSDMat_Prod_Type{$endif}     name: 'MAT_PROD_TYPE';     dom: dom_ProdType),
({$ifdef DEVELOP}fInfo: fli_MSDModulerule{$endif}        name: 'MODULERULE';        dom: dom_Type),

//NOW_TABLE_NAMES
({$ifdef DEVELOP}fInfo: fli_NTNTable_Name{$endif}        name: 'TABLE_NAME';        dom: dom_Text30),

//NOW_TABLES_COLUMNS
({$ifdef DEVELOP}fInfo: fli_NTCTable_Name{$endif}             name: 'TABLE_NAME';             dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_NTCColumn_Name{$endif}            name: 'COLUMN_NAME';            dom: dom_Text50),
({$ifdef DEVELOP}fInfo: fli_NTCType_Name{$endif}              name: 'TYPE_NAME';              dom: dom_Text9),
({$ifdef DEVELOP}fInfo: fli_NTCLength{$endif}                 name: '"LENGTH"';               dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_NTCScale{$endif}                  name: 'SCALE';                  dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_NTCRelatedEntityClassName{$endif} name: 'RELATEDCLASSENTITYNAME'; dom: dom_Text50),

//PROPERTY_RTV_VALUE
({$ifdef DEVELOP}fInfo: fli_PRVProperty{$endif}          name: 'PROPERTY';          dom: dom_Text5),
({$ifdef DEVELOP}fInfo: fli_PRVItemType{$endif}          name: 'ITEMTYPE';          dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PRVTable_Name{$endif}        name: 'TABLE_NAME';        dom: dom_Text50),
({$ifdef DEVELOP}fInfo: fli_PRVColumn_Name{$endif}       name: 'COLUMN_NAME';       dom: dom_Text50),
({$ifdef DEVELOP}fInfo: fli_PRVRelated_ColumName{$endif} name: 'RELATED_COLUMN_NAME'; dom: dom_Text50),
({$ifdef DEVELOP}fInfo: fli_PRVFromPosition{$endif}      name: 'From_Position';     dom: dom_shortId),
({$ifdef DEVELOP}fInfo: fli_PRVLength{$endif}            name: 'Length_From_Pos';             dom: dom_shortId),

//WKC_CATEGORY
({$ifdef DEVELOP}fInfo: fli_WCAWkcnter{$endif}           name: 'WKCNTER';           dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WCACategory{$endif}          name: 'CATEGORY';          dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WCAMixresgroups{$endif}      name: 'MIXREGROUPS';       dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WCACal{$endif}               name: 'CAL';               dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WCAUsr_Namecg;{$endif}       name: 'USR_NAMECG';        dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_WCAUsr_Timecg;{$endif}       name: 'USR_TIMECG';        dom: dom_Timing),

//CATEGORY_DATES_INFO
({$ifdef DEVELOP}fInfo: fli_CDWkcnter{$endif}           name: 'WKCNTER';           dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_CDCategory{$endif}          name: 'CATEGORY';          dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_CDDate_Begin{$endif}        name: 'DATE_BEGIN';        dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_CDNum_Of_Machines{$endif}   name: 'NUM_OF_MACHINES';   dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_CDFinitecapacity{$endif}    name: 'FINITECAPACITY';    dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_CDUsr_Namecg;{$endif}       name: 'USR_NAMECG';        dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_CDUsr_Timecg;{$endif}       name: 'USR_TIMECG';        dom: dom_Timing),

//WKC_PENALTIES
({$ifdef DEVELOP}fInfo: fli_PNPlan_Wkct_Code{$endif}    name: 'PLAN_WKCT_CODE';    dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PNPlan_Wkct_Proc{$endif}    name: 'PLAN_WKCT_PROC';    dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PNCompcasenum{$endif}       name: 'COMPCASENUM';       dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_PNDayspanelty{$endif}       name: 'DAYSPANELTY';       dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PNUsr_Namecg;{$endif}       name: 'USR_NAMECG';        dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PNUsr_Timecg;{$endif}       name: 'USR_TIMECG';        dom: dom_Timing),

//WORKCENTERANDOPERATTRIBUTES
({$ifdef DEVELOP}fInfo: fli_WOAWorkcenterCode{$endif}               name: 'WORKCENTERCODE';               dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WOAOperationCode{$endif}                name: 'OPERATIONCODE';                dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_WOACode{$endif}                         name: 'CODE';                         dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_WOAShortDescription{$endif}             name: 'SHORTDESCRIPTION';             dom: dom_Text40),
({$ifdef DEVELOP}fInfo: fli_WOAStandardStepQuantity{$endif}         name: 'STANDARDSTEPQUANTITY';         dom: dom_Numeric15_5),
({$ifdef DEVELOP}fInfo: fli_WOAStandardStepQtyUomCode{$endif}       name: 'STANDARDSTEPQTYUOMCODE';       dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WOAStepEfficiencyApply{$endif}          name: 'STEPEFFICIENCYAPPLY';          dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_WOAStepEfficiency{$endif}               name: 'STEPEFFICIENCY';               dom: dom_Numeric5_2),
({$ifdef DEVELOP}fInfo: fli_WOATimeType1Code{$endif}                name: 'TIMETYPE1CODE';                dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WOATime1{$endif}                        name: 'TIME1';                        dom: dom_Numeric10_5),
({$ifdef DEVELOP}fInfo: fli_WOATimeUnit1{$endif}                    name: 'TIMEUNIT1';                    dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_WOATimeRefQty1{$endif}                  name: 'TIMEREFQTY1';                  dom: dom_Numeric15_5),
({$ifdef DEVELOP}fInfo: fli_WOATimeRefUom1Code{$endif}              name: 'TIMEREFUOM1CODE';              dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WOATimeType2Code{$endif}                name: 'TIMETYPE2CODE';                dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WOATime2{$endif}                        name: 'TIME2';                        dom: dom_Numeric10_5),
({$ifdef DEVELOP}fInfo: fli_WOATimeUnit2{$endif}                    name: 'TIMEUNIT2';                    dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_WOATimeRefQty2{$endif}                  name: 'TIMEREFQTY2';                  dom: dom_Numeric15_5),
({$ifdef DEVELOP}fInfo: fli_WOATimeRefUom2Code{$endif}              name: 'TIMEREFUOM2CODE';              dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WOATimeType3Code{$endif}                name: 'TIMETYPE3CODE';                dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WOATime3{$endif}                        name: 'TIME3';                        dom: dom_Numeric10_5),
({$ifdef DEVELOP}fInfo: fli_WOATimeUnit3{$endif}                    name: 'TIMEUNIT3';                    dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_WOATimeRefQty3{$endif}                  name: 'TIMEREFQTY3';                  dom: dom_Numeric15_5),
({$ifdef DEVELOP}fInfo: fli_WOATimeRefUom3Code{$endif}              name: 'TIMEREFUOM3CODE';              dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WOATimeType4Code{$endif}                name: 'TIMETYPE4CODE';                dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WOATime4{$endif}                        name: 'TIME4';                        dom: dom_Numeric10_5),
({$ifdef DEVELOP}fInfo: fli_WOATimeUnit4{$endif}                    name: 'TIMEUNIT4';                    dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_WOATimeRefQty4{$endif}                  name: 'TIMEREFQTY4';                  dom: dom_Numeric15_5),
({$ifdef DEVELOP}fInfo: fli_WOATimeRefUom4Code{$endif}              name: 'TIMEREFUOM4CODE';              dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WOATimeType5Code{$endif}                name: 'TIMETYPE5CODE';                dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_WOATime5{$endif}                        name: 'TIME5';                        dom: dom_Numeric10_5),
({$ifdef DEVELOP}fInfo: fli_WOATimeUnit5{$endif}                    name: 'TIMEUNIT5';                    dom: dom_Text2),
({$ifdef DEVELOP}fInfo: fli_WOATimeRefQty5{$endif}                  name: 'TIMEREFQTY5';                  dom: dom_Numeric15_5),
({$ifdef DEVELOP}fInfo: fli_WOATimeRefUom5Code{$endif}              name: 'TIMEREFUOM5CODE';              dom: dom_Text3),

//PRODUCTION_TIMES_LEVEL
({$ifdef DEVELOP}fInfo: fli_PTLWorkCenterCode{$endif}               name: 'WORK_CENTER_CODE';             dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PTLOperation{$endif}                    name: 'OPERATION';                    dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PTLProductType{$endif}                  name: 'PRODUCT_TYPE';                 dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PTLHandle_Times_By{$endif}              name: 'HANDLE_TIMES_BY';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PTLTableName1{$endif}                   name: 'TABLENAME1';                   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLColumnName1{$endif}                  name: 'COLUMNNAME1';                  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLTableName2{$endif}                   name: 'TABLENAME2';                   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLColumnName2{$endif}                  name: 'COLUMNNAME2';                  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLTableName3{$endif}                   name: 'TABLENAME3';                   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLColumnName3{$endif}                  name: 'COLUMNNAME3';                  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLTableName4{$endif}                   name: 'TABLENAME4';                   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLColumnName4{$endif}                  name: 'COLUMNNAME4';                  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLTableName5{$endif}                   name: 'TABLENAME5';                   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLColumnName5{$endif}                  name: 'COLUMNNAME5';                  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLTableName6{$endif}                   name: 'TABLENAME6';                   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLColumnName6{$endif}                  name: 'COLUMNNAME6';                  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLTableName7{$endif}                   name: 'TABLENAME7';                   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLColumnName7{$endif}                  name: 'COLUMNNAME7';                  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLTableName8{$endif}                   name: 'TABLENAME8';                   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLColumnName8{$endif}                  name: 'COLUMNNAME8';                  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLTableName9{$endif}                   name: 'TABLENAME9';                   dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLColumnName9{$endif}                  name: 'COLUMNNAME9';                  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLTableName10{$endif}                  name: 'TABLENAME10';                  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTLColumnName10{$endif}                 name: 'COLUMNNAME10';                 dom: dom_Text30),

//PRODUCTION_TIMES
({$ifdef DEVELOP}fInfo: fli_PTKey{$endif}                           name: 'INDEX_FLD';                     dom: dom_LongId),
({$ifdef DEVELOP}fInfo: fli_PTWorkCenter{$endif}                    name: 'WORK_CENTER';                   dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PTOperation{$endif}                     name: 'OPERATION';                     dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PTProductType{$endif}                   name: 'PRODUCT_TYPE';                  dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PTTableName1ColumnName1Value{$endif}    name: 'TABLENAME1_COLUMNNAME1_VALUE';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTTableName1ColumnName2Value{$endif}    name: 'TABLENAME1_COLUMNNAME2_VALUE';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTTableName1ColumnName3Value{$endif}    name: 'TABLENAME1_COLUMNNAME3_VALUE';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTTableName1ColumnName4Value{$endif}    name: 'TABLENAME1_COLUMNNAME4_VALUE';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTTableName1ColumnName5Value{$endif}    name: 'TABLENAME1_COLUMNNAME5_VALUE';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTTableName1ColumnName6Value{$endif}    name: 'TABLENAME1_COLUMNNAME6_VALUE';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTTableName1ColumnName7Value{$endif}    name: 'TABLENAME1_COLUMNNAME7_VALUE';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTTableName1ColumnName8Value{$endif}    name: 'TABLENAME1_COLUMNNAME8_VALUE';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTTableName1ColumnName9Value{$endif}    name: 'TABLENAME1_COLUMNNAME9_VALUE';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTTableName1ColumnName10Value{$endif}   name: 'TABLENAME1_COLUMNNAME10_VALUE'; dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PTResourceCategory{$endif}              name: 'RESOURCE_CATEGORY';             dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PTResource{$endif}                      name: 'RESOURCE';                      dom: dom_Text6),
({$ifdef DEVELOP}fInfo: fli_PTSetupTime{$endif}                     name: 'SETUP_TIME';                    dom: dom_durMin),
({$ifdef DEVELOP}fInfo: fli_PTBatchTime{$endif}                     name: 'BATCH_TIME';                    dom: dom_durMinLong),
({$ifdef DEVELOP}fInfo: fli_PTContinuousTime{$endif}                name: 'CONTINUOUS_TIME';               dom: dom_durMinLong),
({$ifdef DEVELOP}fInfo: fli_PTContinuousOpUM{$endif}                name: 'CONTINUOUS_OPERATION_UM';       dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PTConsiderStepEfficiency{$endif}        name: 'CONSIDER_STEP_EFFICIENCY';      dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PTCode{$endif}                          name: 'CODE';                          dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_PTSetupTimeMultiplier{$endif}           name: 'SETUP_TIME_MULTIPLIER';         dom: dom_multiToBatchUm),
({$ifdef DEVELOP}fInfo: fli_PTOperationTimeMultiplier{$endif}       name: 'OPERATION_TIME_MULTIPLIER';     dom: dom_multiToBatchUm),

//PRODUCTIONPROGRESSTEMPLATE
({$ifdef DEVELOP}fInfo: fli_PPTCode{$endif}         name: 'CODE';         dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PPTS_Descr{$endif}      name: 'S_DESCR';      dom: dom_Text14),
({$ifdef DEVELOP}fInfo: fli_PPTL_Descr{$endif}      name: 'L_DESCR';      dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PPTHandledByMQM{$endif} name: 'HandledByMQM'; dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PPTHandledByMCM{$endif} name: 'HandledByMCM'; dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PPTQuantityType{$endif} name: 'QuantityType'; dom: dom_Type),

//PROD_SCHED
({$ifdef DEVELOP}fInfo: fli_PSPreqNo{$endif}                 name: 'PREQ_NO';                    dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PSPStepId{$endif}                name: 'PSTEP_ID';                   dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSPsubstId{$endif}               name: 'PSUBST_ID';                  dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSReprecNo{$endif}               name: 'REPROC_NO';                  dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSVersNo{$endif}                 name: 'VERS_NO';                    dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSUpdCode{$endif}                name: 'UPD_CODE';                   dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSUpdOp{$endif}                  name: 'UPD_OP';                     dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PSTypeProd{$endif}               name: 'TYPE_PROD';                  dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PSProdLine{$endif}               name: 'PROD_LINE';                  dom: dom_Text4),
({$ifdef DEVELOP}fInfo: fli_PSProdUm{$endif}                 name: 'PROD_UM';                    dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_PSStepType{$endif}               name: 'STEP_TYP';                   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PSInitQuent{$endif}              name: 'INIT_QUENT';                 dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_PSStGroup{$endif}                name: 'ST_GROUP';                   dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_PSStepIsGrped{$endif}            name: 'STEP_IS_GRPED';              dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PSSchedType{$endif}              name: 'SCHED_TYPE';                 dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PSWkcnter{$endif}                name: 'WKCNTER';                    dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PSWkctProc{$endif}               name: 'WKCT_PROC';                  dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PSAlternativeCode{$endif}        name: 'ALTERNATIVE_CODE';           dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PSRscCode{$endif}                name: 'RSC_CODE';                   dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PSProdSublinRsc{$endif}          name: 'PROD_SUBLIN_RSC';            dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSNumRscComponents{$endif}       name: 'NUM_RSC_COMPONENTS';         dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSQty{$endif}                    name: 'QTY';                        dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_PSSupBase{$endif}                name: 'SUP_BASE';                   dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_PSSupReal{$endif}                name: 'SUP_REAL';                   dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_PSSupOverlap{$endif}             name: 'SUP_OVERLAP';                dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_PSExeMin{$endif}                 name: 'EXE_MIN';                    dom: dom_Numeric9_2),
({$ifdef DEVELOP}fInfo: fli_PSSchStart{$endif}               name: 'SCH_START';                  dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PSSchEnd{$endif}                 name: 'SCH_END';                    dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PSComment{$endif}                name: 'COMMENT';                    dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PSFwdSubstep{$endif}             name: 'FWD_SUBSTEP';                dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSFwdReprocSubstep{$endif}       name: 'FWD_REPROC_SUBSTEP';         dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSBkwSubstep{$endif}             name: 'BKW_SUBSTEP';                dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSBkwReprocSubstep{$endif}       name: 'BKW_REPROC_SUBSTEP';         dom: dom_shtstId),
({$ifdef DEVELOP}fInfo: fli_PSSavesAtLeastOnesFinnal{$endif} name: 'SAVES_AT_LEAST_ONES_FINNAL'; dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PSNettedQuantity{$endif}         name: 'NETTED_QUANTITY';            dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_PSChangedQuantity{$endif}        name: 'CHANGED_QUANTITY';           dom: dom_Numeric11_2),
({$ifdef DEVELOP}fInfo: fli_PSMachineSetupCode{$endif}       name: 'MACHINE_SETUP_CODE';         dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PSUsr_Namecr{$endif}             name: 'USR_NAMECR';                 dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PSUsr_Timecr{$endif}             name: 'USR_TIMECR';                 dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PSUsr_Namecg{$endif}             name: 'USR_NAMECG';                 dom: dom_Text10),
({$ifdef DEVELOP}fInfo: fli_PSUsr_Timecg{$endif}             name: 'USR_TIMECG';                 dom: dom_Timing),
({$ifdef DEVELOP}fInfo: fli_PSBinSel{$endif}                 name: 'BIN_SEL';                    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PSProgOverrideType{$endif}       name: 'PROG_OVERRIDE_TYPE';         dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_PSEkcnterKetSt{$endif}           name: 'WKCNTER_KEY_ST';             dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PSWcProcessKeySt{$endif}         name: 'WC_PROCESS_KEY_ST';          dom: dom_Text4),
({$ifdef DEVELOP}fInfo: fli_PSResKeySt{$endif}               name: 'RES_KEY_ST';                 dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PSResCatKeySt{$endif}            name: 'RES_CAT_KEY_ST';             dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_NewPreqUniqId{$endif}            name: 'NEW_PREQ_UNIQ_ID';           dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_PSSplitFamaly;{$endif}           name: 'SPLITED_FAMILY';             dom: dom_text12),

//PRODUCTIONDEMANDCOUNTER
({$ifdef DEVELOP}fInfo: fli_PDCCode{$endif}                  name: 'CODE';                  dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_PDCShortDesc{$endif}             name: 'S_DESCR';               dom: dom_Text60),
({$ifdef DEVELOP}fInfo: fli_PDCFamilyCodeEndPosition{$endif} name: 'FAMILYCODEENDPOSITION'; dom: dom_shtstId),

//ProjectNumber
({$ifdef DEVELOP}fInfo: fli_PNProjectCode{$endif}            name: 'CODE';                  dom: dom_Text20),
({$ifdef DEVELOP}fInfo: fli_PNNumber{$endif}                 name: 'NUMBER';                dom: dom_longId),

//ITEMTYPETEMPLATE
({$ifdef DEVELOP}fInfo: fli_ITTItemTypeCode{$endif}                 name: 'ITEMTYPECODE';                 dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_ITTProductionDemandTemplateCode{$endif} name: 'PRODUCTIONDEMANDTEMPLATECODE'; dom: dom_Text40),
({$ifdef DEVELOP}fInfo: fli_ITTHostSplitConfirmLevel{$endif}        name: 'HOSTSPLITCONFIRMLEVEL';        dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ITTWorkcenterForSplit{$endif}           name: 'WORKCENTERFORSPLIT';           dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_ITTOperationForSplit{$endif}            name: 'OPERATIONFORSPLIT';            dom: dom_Text8),

//ALTERNATIVEWAREHOUSE
({$ifdef DEVELOP}fInfo: fli_AWHWkcenter{$endif}                      name: 'WKCNTER';               dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_AWHAltern_Wc{$endif}                     name: 'ALTERN_WC';             dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_AWHNet_Group_Code;{$endif}               name: 'NET_GROUP_CODE';        dom: dom_Text16),
({$ifdef DEVELOP}fInfo: fli_AWHIssueItemType;{$endif}                name: 'ISSUE_ITEM_TYPE';       dom: dom_Text3),
({$ifdef DEVELOP}fInfo: fli_AWHAltern_Net_Group_Code;{$endif}        name: 'ALTERN_NET_GROUP_CODE'; dom: dom_Text16),

//ITEMTYPELOGICALWAREHOUSE
({$ifdef DEVELOP}fInfo: fli_ITLWItemTypeCode;{$endif}                  name: 'ITEMTYPECODE';          dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_ITLWLogicalWarehouseCode;{$endif}          name: 'LOGICALWAREHOUSECODE';  dom: dom_Text8),
({$ifdef DEVELOP}fInfo: fli_ITLWNetGroupReservationTableName;{$endif}  name: 'RESERVATIONTABLENAME';  dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_ITLWNetGroupReservationColumnName;{$endif} name: 'RESERVATIONCOLUMNNAME'; dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_ITLWNetGroupDemandTableName;{$endif}       name: 'DEMANDTABLENAME';       dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_ITLWNetGroupDemandColumnName;{$endif}      name: 'DEMANDCOLUMNNAME';      dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_ITLWConnBtwStockAndResrv;{$endif}          name: 'CONN_BTW_STOCK_AND_RESRV'; dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ITLWSeparetBtwAttributes;{$endif}          name: 'SEPARATE_BTW_ATTRIBUTE';   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ITLW1stcolumn;{$endif}                     name: 'IW_1ST_COLUMN';               dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_ITLWdspBeforecolumn2;{$endif}              name: 'DSP_BEFORE_2ST_COLUMN';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ITLW2stcolumn;{$endif}                     name: 'IW_2ST_COLUMN';               dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_ITLWdspBeforecolumn3;{$endif}              name: 'DSP_BEFORE_3ST_COLUMN';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ITLW3stcolumn;{$endif}                     name: 'IW_3ST_COLUMN';               dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_ITLWdspBeforecolumn4;{$endif}              name: 'DSP_BEFORE_4ST_COLUMN';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ITLW4stcolumn;{$endif}                     name: 'IW_4ST_COLUMN';               dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_ITLWdspBeforecolumn5;{$endif}              name: 'DSP_BEFORE_5ST_COLUMN';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ITLW5stcolumn;{$endif}                     name: 'IW_5ST_COLUMN';               dom: dom_text50),
({$ifdef DEVELOP}fInfo: fli_ITLWdspBeforecolumn6;{$endif}              name: 'DSP_BEFORE_6ST_COLUMN';    dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_ITLW6stcolumn;{$endif}                     name: 'IW_6ST_COLUMN';               dom: dom_text50),

//  Now_Download_Entity_Date
({$ifdef DEVELOP}fInfo: fli_NDEntityName;{$endif}                      name: 'ENTITY_NAME';            dom: dom_Text15),
({$ifdef DEVELOP}fInfo: fli_NDDate;{$endif}                            name: 'DATE';                   dom: dom_timing),

// Learning curve
//({$ifdef DEVELOP}fInfo: fli_LearningCurveCode;{$endif}      name: 'LEARNING_CURVE_CODE';    dom: dom_longChId),
({$ifdef DEVELOP}fInfo: fli_LearningCurveDesc;{$endif}      name: 'LEARNING_CURVE_DESC';    dom: dom_Text30),
({$ifdef DEVELOP}fInfo: fli_CurveFirstHours;{$endif}        name: 'CURVE_FIRST_HOURS';      dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveFirstEffic;{$endif}        name: 'CURVE_FIRST_EFFIC';      dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveSecondHours;{$endif}       name: 'CURVE_SECOND_HOURS';     dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveSecondEffic;{$endif}       name: 'CURVE_SECOND_EFFIC';     dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveThirdHours;{$endif}        name: 'CURVE_THIRD_HOURS';      dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveThirdEffic;{$endif}        name: 'CURVE_THIRD_EFFIC';      dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveForthHours;{$endif}        name: 'CURVE_FORTH_HOURS';      dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveForthEffic;{$endif}        name: 'CURVE_FORTH_EFFIC';      dom: dom_intCode),
({$ifdef DEVELOP}fInfo: fli_CurveFifthhHours;{$endif}       name: 'CURVE_FIFTH_HOURS';      dom: don_Hours),
({$ifdef DEVELOP}fInfo: fli_CurveFifthEffic;{$endif}        name: 'CURVE_FIFTH_EFFIC';      dom: dom_intCode),

({$ifdef DEVELOP}fInfo: fli_Details;{$endif}                name: 'DETAILS';                dom: dom_text110),
({$ifdef DEVELOP}fInfo: fli_used;{$endif}                   name: 'USED';                   dom: dom_Type),
({$ifdef DEVELOP}fInfo: fli_BalanceIdentifier;{$endif}      name: 'BALANCEID';              dom: dom_longId),

({$ifdef DEVELOP}fInfo: fli_GrpIndex;{$endif}               name: 'GROUP_INDEX';            dom: dom_longId),
({$ifdef DEVELOP}fInfo: fli_GrpCode;{$endif}                name: 'GROUP_CODE';             dom: dom_code)

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











