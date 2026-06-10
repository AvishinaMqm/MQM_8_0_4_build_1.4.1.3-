program MQM;

uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  EDebugExports,
  EDebugJCL,
  EFixSafeCallException,
  EMapWin32,
  EAppVCL,
  EDialogWinAPIMSClassic,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  ExceptionLog7,
  {$ENDIF EurekaLog}
  ELogBuilder,
  EEvents,
  ELogManager,
  gnugettext in '..\Internationalization\gnugettext.pas',
  Forms,
  Dialogs,
  Windows,
  SysUtils,
  StdCtrls,
  Classes,
  UMRes in '..\plan\UMRes.pas',
  UMPlanObj in '..\plan\UMPlanObj.pas',
  UMResCat in '..\plan\UMResCat.pas',
  UMDurObj in '..\plan\UMDurObj.pas',
  UMPlan in '..\plan\UMPlan.pas',
  UMSchedCont in '..\plan\UMSchedCont.pas',
  DMsrvPc in '..\db\DMsrvPc.pas' {DMib: TDataModule},
  UMTblDesc in '..\db\UMTblDesc.pas',
  UGregItf in '..\..\lib\UGregItf.pas',
  UMCompatSrv in '..\lib\UMCompatSrv.pas',
  UMCompat in '..\lib\UMCompat.pas',
  UMPlanGraph in '..\plan\UMPlanGraph.pas',
  UMActArea in '..\plan\UMActArea.pas',
  UMpgCal in '..\lib\UMpgCal.pas',
  UGshiftCal in '..\..\lib\UGshiftCal.pas',
  UMCommon in '..\lib\UMCommon.pas',
  UMProdLine in '..\plan\UMProdLine.pas',
  UGganttPanel in '..\..\lib\UGganttPanel.pas',
  UMWkCtr in '..\plan\UMWkCtr.pas',
  UMProdLineActPer in '..\plan\UMProdLineActPer.pas',
  UMPlanTbs in '..\lib\UMPlanTbs.pas',
  UMViewTbs in '..\lib\UMViewTbs.pas',
  UMTabcfg in '..\lib\UMTabcfg.pas',
  UMViewPage in '..\lib\UMViewPage.pas',
  UMCapRes in '..\plan\UMCapRes.pas',
  FMbin in '..\bin\FMbin.pas' {FBin},
  UMbinGrid in '..\bin\UMbinGrid.pas',
  UMBinFunc in '..\bin\UMBinFunc.pas',
  UMBinTbs in '..\bin\UMBinTbs.pas',
  UGObjListSrv in '..\..\lib\UGObjListSrv.pas',
  UMBinPanel in '..\bin\UMBinPanel.pas',
  FMcfgBin in '..\bin\FMcfgBin.pas' {FConfigBin},
  UMObjCont in '..\lib\UMObjCont.pas',
  FMBinFiltTabs in '..\forms\FMBinFiltTabs.pas' {TBinFilter},
  UGPropComp in '..\..\lib\UGPropComp.pas',
  FMEditTabsBin in '..\bin\FMEditTabsBin.pas' {EditTabsBin},
  UGconvert in '..\..\lib\UGconvert.pas',
  FMresFilter in '..\forms\FMresFilter.pas' {FResFilter},
  FMworkstation in '..\forms\FMworkstation.pas' {MWkst},
  UMCmp in '..\plan\UMCmp.pas',
  FMsplash in '..\lib\FMsplash.pas' {SplashForm},
  UGshapeMan in '..\..\lib\UGshapeMan.pas',
  UGHdrMan in '..\..\lib\UGHdrMan.pas',
  UMhdrMan in 'UMhdrMan.pas',
  UGcal in '..\..\lib\UGcal.pas',
  UGbaseCal in '..\..\lib\UGbaseCal.pas',
  UGprogCtrl in '..\..\lib\UGprogCtrl.pas',
  UMCompatRules in '..\lib\UMCompatRules.pas',
  UMStoredProc in '..\db\UMStoredProc.pas',
  UMSchedObjMover in '..\plan\UMSchedObjMover.pas',
  UMOpStack in '..\plan\UMOpStack.pas',
  FMOccMov in '..\forms\FMOccMov.pas' {FMOccMove},
  FMWkcDetails in '..\forms\FMWkcDetails.pas' {FWkcDetails},
  FMResDetails in '..\forms\FMResDetails.pas' {FResDetails},
  FMCrtDownTime in '..\forms\FMCrtDownTime.pas' {FCrtDownTime},
  UGglobal in '..\..\lib\UGglobal.pas',
  UMCapResMover in '..\plan\UMCapResMover.pas',
  UMCompatClr in '..\lib\UMCompatClr.pas',
  FMGroupDetail in '..\forms\FMGroupDetail.pas' {TGroupDetail},
  UMSchedView in '..\lib\UMSchedView.pas',
  FMStepDetails in '..\forms\FMStepDetails.pas' {FStepDetails},
  UMDevPropComp in '..\lib\UMDevPropComp.pas',
  FMRORulesCase in '..\forms\FMRORulesCase.pas' {FRORulesCase},
  UMRulesComp in '..\lib\UMRulesComp.pas',
  FGinfo in '..\..\lib\FGinfo.pas' {InfoForm},
  FMCreateCapRes in '..\forms\FMCreateCapRes.pas' {FMCrtCapRes},
  FMColors in '..\forms\FMColors.pas' {FColors},
  UMCalcTimings in '..\plan\UMCalcTimings.pas',
  FMOORulesCase in '..\forms\FMOORulesCase.pas' {FOORulesCase},
  FMOptions in '..\forms\FMOptions.pas' {FOptions},
  FMMainPlan in 'FMMainPlan.pas' {FMQMPlan},
  UMDbFunc in '..\db\UMDbFunc.pas',
  UMPriorities in '..\plan\UMPriorities.pas',
  UMStatus in '..\lib\UMStatus.pas',
  UMProdInfo in '..\plan\UMProdInfo.pas',
  UMBatchQtyConv in '..\lib\UMBatchQtyConv.pas',
  UMDescUm in '..\lib\UMDescUm.pas',
  UMPropComp in '..\lib\UMPropComp.pas',
  UMUsrPropComp in '..\lib\UMUsrPropComp.pas',
  UMPlanFunc in '..\plan\UMPlanFunc.pas',
  UMWkCtrDesc in '..\lib\UMWkCtrDesc.pas',
  UGgraph in '..\..\lib\UGgraph.pas',
  UMGridComptClr in '..\lib\UMGridComptClr.pas',
  UGLicensing in '..\..\lib\UGLicensing.pas',
  FMJobHandle in '..\forms\FMJobHandle.pas' {FJobHandle},
  UGDrawGrid in '..\..\lib\UGDrawGrid.pas',
  UMSearchFunc in '..\lib\UMSearchFunc.pas',
  UMSchedOnPlan in '..\plan\UMSchedOnPlan.pas',
  UMSchedContFunc in '..\plan\UMSchedContFunc.pas',
  UMSchedList in '..\plan\UMSchedList.pas',
  FMAutoSchedCfg in '..\forms\FMAutoSchedCfg.pas' {FAutoSchedCfg},
  UMAutoSched in '..\lib\UMAutoSched.pas',
  FMAutoSched in '..\forms\FMAutoSched.pas' {FAutoSched},
  UMRank in '..\lib\UMRank.pas',
  FMAutoSchedReport in '..\forms\FMAutoSchedReport.pas' {FAutoSchedRpt},
  FMEditCal in '..\forms\FMEditCal.pas' {MEditCal},
  UMCalDbInterface in '..\db\UMCalDbInterface.pas',
  FMChangeWC in '..\forms\FMChangeWC.pas' {ChangeWc},
  FMCapResDescription in '..\forms\FMCapResDescription.pas' {FormCapResDesc},
  FmBinTotals in '..\forms\FmBinTotals.pas' {FrmBintotals},
  FMProdImage in '..\forms\FMProdImage.pas' {ProdImage},
  UMArticle in '..\lib\UMArticle.pas',
  UMBinDefault in '..\bin\UMBinDefault.pas',
  mxNativeExcel in '..\..\lib\Excel\mxNativeExcel.pas',
  FMBarConfig in '..\forms\FMBarConfig.pas' {FBarConfig},
  FMMsgDlgSim in '..\forms\FMMsgDlgSim.pas' {FMsgDlgSim},
  UMProdArt in '..\Materials\UMProdArt.pas',
  UMArticles in '..\Materials\UMArticles.pas',
  UMBalance in '..\Materials\UMBalance.pas',
  UMIssuedArt in '..\Materials\UMIssuedArt.pas',
  UMOverlap in '..\Materials\UMOverlap.pas',
  UGCustomList in '..\..\lib\UGCustomList.pas',
  UMBobbins in '..\plan\UMBobbins.pas',
  FMShowMaterials in '..\forms\FMShowMaterials.pas' {FShowMaterials},
  UMBinChkBox in '..\lib\UMBinChkBox.pas',
  UMAutoSchedCfg in '..\lib\UMAutoSchedCfg.pas',
  FMBarConfigSets in '..\forms\FMBarConfigSets.pas' {FBarConfigSets},
  UMCalcOverlaps in '..\plan\UMCalcOverlaps.pas',
  FMAbout in '..\forms\FMAbout.pas' {FAbout},
  FMRequirements in '..\Materials\FMRequirements.pas' {FMaterialReq},
  FMRequirementsChild in '..\Materials\FMRequirementsChild.pas' {FReqChild},
  FMRequirementsStepChild in '..\Materials\FMRequirementsStepChild.pas' {FPrevNextStepDetails},
  FMViewHtml in '..\forms\FMViewHtml.pas' {FViewHtml},
  FMWait in '..\forms\FMWait.pas' {FWait},
  UMglobal in '..\lib\UMglobal.pas',
  FMReportHtmlBackColors in '..\forms\FMReportHtmlBackColors.pas' {HtmlBackColors},
  FMResourceReport in '..\forms\FMResourceReport.pas' {FResourceReport},
  FMExcelReport in '..\forms\FMExcelReport.pas' {FExcelReport},
  UMReports in '..\bin\UMReports.pas',
  UMReportExport in '..\bin\UMReportExport.pas',
  FMcfgResList in '..\forms\FMcfgResList.pas' {FConfigResList},
  FMServerStatus in '..\forms\FMServerStatus.pas' {FServerStatus},
  FMBucketReport in '..\forms\FMBucketReport.pas' {FBucketReport},
  FMGroupAll in '..\forms\FMGroupAll.pas' {TGroupAllLines},
  FMShowColorsBar in '..\forms\FMShowColorsBar.pas' {ShowColor},
  FMlearningCurve in '..\forms\FMlearningCurve.pas' {learningCurve},
  FMBalanceChange in '..\Materials\FMBalanceChange.pas' {FBalanceChange},
  FMBalanceHeaders in '..\Materials\FMBalanceHeaders.pas' {MBalanceHeadersForm},
  FMSearchAndFocuse in '..\forms\FMSearchAndFocuse.pas' {SearchAndFocuse},
  FMSearchAndCreateTab in '..\bin\FMSearchAndCreateTab.pas' {SearchAndCreateTab},
  FMMsgJobHandler in '..\forms\FMMsgJobHandler.pas' {MsgJobHandling},
  FMCustomizeDates in '..\forms\FMCustomizeDates.pas' {DatesCustomize},
  FMPlannerPropDefine in '..\forms\FMPlannerPropDefine.pas' {PlannerPropDefine},
  FMStockDetails in '..\Materials\FMStockDetails.pas' {StockDetails},
  FMStockDetailsChild in '..\Materials\FMStockDetailsChild.pas' {StockDetailsChild},
  FmCalShiftEffic in '..\..\lib\FmCalShiftEffic.pas' {CalShiftEffic},
  FmEditCapacity in '..\..\lib\FmEditCapacity.pas' {EditCapacity},
  FMCalendarUserEnter in '..\forms\FMCalendarUserEnter.pas' {Calendar},
  FMSplitBySelectedDateTime in '..\forms\FMSplitBySelectedDateTime.pas' {SplitBySelectedDateTime},
  FMAutoSchedOverridingParams in '..\forms\FMAutoSchedOverridingParams.pas' {AutoSeqOverridingParams},
  FMCustomizeDatesGap in '..\forms\FMCustomizeDatesGap.pas' {DatesCustomizeGap},
  UMGenericSchedulePrevStep in '..\plan\UMGenericSchedulePrevStep.pas',
  FmAutoRunDefinition in '..\forms\FmAutoRunDefinition.pas' {AutoRunDefinition},
  FmAutoRunSet in '..\forms\FmAutoRunSet.pas' {FRowDetailsSet},
  UMAutoSchedSimulation in '..\lib\UMAutoSchedSimulation.pas',
  FMAutoSchedReportSimulation in '..\forms\FMAutoSchedReportSimulation.pas' {FAutoSchedRptSimulation},
  FMGrpSplit in '..\forms\FMGrpSplit.pas' {GrpSplit},
  UGWorkCentersPlanControl in '..\..\lib\UGWorkCentersPlanControl.pas',
  UGWorkCentersPlanDraw in '..\..\lib\UGWorkCentersPlanDraw.pas',
  UGSlotCal in '..\..\lib\UGSlotCal.pas',
  UGWorkCentersPlanShot in '..\..\lib\UGWorkCentersPlanShot.pas',
  UGWorkCentersDrawSlot in '..\..\lib\UGWorkCentersDrawSlot.pas',
  FMGroupedByFieldsConfig in '..\forms\FMGroupedByFieldsConfig.pas' {FGroupedByFieldsConfig},
  FMGroupedByFieldsSet in '..\forms\FMGroupedByFieldsSet.pas' {FGroupedByFieldsSet},
  FMWorkCenterCategoryCapacity in '..\forms\FMWorkCenterCategoryCapacity.pas' {WorkCenterCategoryCapacity},
  DateSelectorForm in '..\forms\DateSelectorForm.pas' {DateSelectorFrm},
  UMMessageFilter in '..\bin\UMMessageFilter.pas',
  FMAutoSchedWorkCenterCfg in '..\forms\FMAutoSchedWorkCenterCfg.pas' {FAutoSchedWcCfg},
  FMStatistics in '..\forms\FMStatistics.pas' {FStatistics},
  UMStatisticCalculation in '..\plan\UMStatisticCalculation.pas',
  UMDashboardHtml in '..\plan\UMDashboardHtml.pas',
  FMStatisticsDetails in '..\forms\FMStatisticsDetails.pas' {StatisticsDetails},
  UMSrvConfig in '..\MqmSrv\UMSrvConfig.pas',
  FMCapResDynamicDetails in '..\forms\FMCapResDynamicDetails.pas' {CapResDynamicDetails},
  FMCapResDynamic in '..\forms\FMCapResDynamic.pas' {CapResDynamic},
  FMCapResDynamicCreate in '..\forms\FMCapResDynamicCreate.pas' {CapResDynamicCreate},
  FMCapResDynamicDetailChild in '..\forms\FMCapResDynamicDetailChild.pas' {CapResDynamicDetailChild},
  Vcl.Themes,
  Vcl.Styles,
  UReShape in 'UReShape.pas',
  FMSpeedMachine in '..\forms\FMSpeedMachine.pas' {SpeedMachine},
  FMBinFiltTabsMaterial in '..\forms\FMBinFiltTabsMaterial.pas' {TBinFilterMaterial},
  UMbinGridMaterial in '..\bin\UMbinGridMaterial.pas',
  UMBinMatDefault in '..\bin\UMBinMatDefault.pas',
  FMCreateWarp in '..\forms\FMCreateWarp.pas' {FCreateWarp},
  UMWarp in '..\plan\UMWarp.pas',
  UMWarpMover in '..\plan\UMWarpMover.pas',
  FMGroupBucket in '..\forms\FMGroupBucket.pas' {FGroupBucket},
  UMConnectionClientThread in '..\db\UMConnectionClientThread.pas',
  FMAppendix in '..\forms\FMAppendix.pas' {FAppendix},
  FMTotalViews in '..\forms\FMTotalViews.pas' {FTotalViews},
  FMVersioning in '..\forms\FMVersioning.pas' {FVersioning},
  UMMaths in '..\lib\UMMaths.pas',
  UMExternalDatabaseOperation in '..\plan\UMExternalDatabaseOperation.pas',
  FireDAC.Phys.ODBCWrapper in '..\db\FireDAC.Phys.ODBCWrapper.pas',
  FireDAC.Phys.ODBCBase in '..\db\FireDAC.Phys.ODBCBase.pas',
  FireDAC.Phys.ODBCMeta in '..\db\FireDAC.Phys.ODBCMeta.pas',
  FMChangeWkstPass in '..\forms\FMChangeWkstPass.pas' {FChgWkstPass},
  FMSavedPlanCopy in '..\forms\FMSavedPlanCopy.pas' {SavedPlanCopy},
  FMCompareSavedBuckets in '..\forms\FMCompareSavedBuckets.pas',
  FMSlotInfo in '..\forms\FMSlotInfo.pas' {SlotInfo},
  FMAvailablityReport in '..\forms\FMAvailablityReport.pas' {FAvailablityReport},
  FMWaitCommunication in '..\forms\FMWaitCommunication.pas' {FWaitCommunication},
  FMBinReport in '..\forms\FMBinReport.pas' {FBinRep},
  cxTextStorage in '..\bin\cxTextStorage.pas';

  procedure AddCustomData(const ACustom: Pointer;
                    AExceptionInfo: TEurekaExceptionInfo;
                    ALogBuilder: TBaseLogBuilder;
                    ADataFields: TStrings;
                    var ACallNextHandler: Boolean);
begin
  ADataFields.Values['Version'] := DBAppGlobals.MqmVersion;
  ADataFields.Values['Workstation'] := IniAppGlobals.WkstCode + ' - ' + IniAppGlobals.WkstDesc;
end;

{DMAS400: TDataModule}

{$R *.RES}

var
  errStr:     string;
  mainDbCode: integer;
  cfgDbCode:  integer;
  CurrDate :  TDateTime;

 begin
  RegisterEventCustomDataRequest(nil, AddCustomData);
  Application.Initialize;
  GlobLoadIniValues;
  TStyleManager.TrySetStyle('Datatex1');
  Application.Title := 'MQM';

  Application.CreateForm(TDMib, DMib);
  TSplashForm.Create(Application);
  SplashForm.Show;
  Application.ProcessMessages;

  errStr := '';

  {$ifdef MCM}
    DBAppGlobals.MCM_App := true;
  {$endif};

  if DBAppGlobals.MCM_App then
    Application.Title := 'MCM'
  else
    Application.Title := 'MQM';

  try
    LocalDbConnect(true);
    Application.ProcessMessages;
    RegisterEvent(true);
    Application.ProcessMessages;
    except
    on E: Exception do
    begin
      ShowMessage('Connection is not defined ...' + E.Message);
      exit
    end;
  end;

  if DBAppGlobals.MCM_App then
    if not LoadLicenceMCM(errStr) then ShowMessage(errStr);

  if not DBAppGlobals.MCM_App then
    if not LoadLicenceMQM(errStr) then ShowMessage(errStr);

//  if errStr = '' then
//    if not CheckLicence(errStr) then
//    begin
//      ShowMessage(errStr);
//      s_suicide := true
//    end;
  SplashForm.Update;

  if not s_suicide then
  begin
    if (not WaitToConnect) or (not GetPassword) then
    begin
      s_suicide := true;
    end
    else
    begin
      SplashForm.Update;
      InitializeObjects;
      GlobLoadDbValues(SplashForm.ProgBar, TStaticText(SplashForm.StStatus));
      GlobLoadSettingsValues;
      GlobLoadIniValuesFromDB;
      UseLanguage(DBAppGlobals.Language);

      if IsCalendarLoaded = false then
        if MessageDlg(_('No calendars have been loaded. Do you wish to abort or ignore ?'), mtWarning, [mbAbort,mbIgnore], 0) = idAbort then
          s_suicide := true;

      if (errStr = '') and not CheckLicenceForMain(errStr) then
      begin
        showmessage(errStr);
        s_suicide := true;
      end;

      if not s_suicide and not IS_STATION_CLOSED(IniAppGlobals.WkstCode) then
      begin
        if IS_STATION_RESPONDING(IniAppGlobals.WkstCode) then
        begin
          if MessageDlg(_('Workstation unavailable. Do you want to reset this station?'),
            mtConfirmation, [mbYes, mbNo], 0) = idYes then
          begin
            RESET_STATION_RECORD(IniAppGlobals.WkstCode);
          end
          else
          begin
            errStr    := _('workstation unavailable');
            s_suicide := true;
          end;
        end;
      end;
        {if not SP_CONNECT(IniAppGlobals.WkstCode, CurrDate) then
        begin
          errStr    := _('workstation unavailable');
          showmessage(errStr);
          s_suicide := true
        end
        else
          IniAppGlobals.Curr_Date_Signed := CurrDate; }
     // IniAppGlobals.Curr_Date_Signed := CurrDate;

      if not s_suicide then
      begin
        LoadAutoSchedCfgFromDB(SplashForm.ProgBar, TStaticText(SplashForm.StStatus));
        if LoadPlanFromDB(SplashForm.ProgBar, TStaticText(SplashForm.StStatus)) then
        begin
          Application.CreateForm(TFMQMPlan, FMQMPlan);
          SplashForm.free;
        end else
        begin
          s_suicide := true;
          CLOSE_STATION(IniAppGlobals.WkstCode);
        end;
      end
    end
  end;

  try
    Application.Run;
  finally
   // if (ParamCount > 0) then
   //    s_suicide := true;
    if s_suicide then
    begin
      SplashForm.free;
     // KillTask(ExtractFileName(Application.ExeName))
    end
    else
    begin
      try // in case no connection are available
        if DMib.m_MainDB.ping then
        begin
          CLOSE_STATION(IniAppGlobals.WkstCode);
          {if IniAppGlobals.DownloadTo = '2' then
          begin
            FMQMPlan.GetPlanCfg.StoreToDatabase;
            SaveAutoSchedCfgToDB;
            GlobSaveValues;
            GlobSaveIniValues;
            if fbin <> nil then FBin.SaveStatus;
          end; }
        end;
      except

      end;

      if DBAppGlobals.m_ClientConnectionCriticalRepaired then
         KillTask(ExtractFileName(Application.ExeName))

    end
  end;
end.







