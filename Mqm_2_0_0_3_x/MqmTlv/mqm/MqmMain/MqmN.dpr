program MQM;

uses
  gnugettext in '..\Internationalization\gnugettext.pas',
  Forms,
  Dialogs,
  Windows,
  SysUtils,
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
  FMDispoDet in '..\forms\FMDispoDet.pas' {DispoDet},
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
  FMRankReport in '..\forms\FMRankReport.pas' {FRankReport},
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
  UMSimulations in '..\plan\UMSimulations.pas',
  FMSimulations in '..\forms\FMSimulations.pas' {FSimulations},
  FMMsgDlgSim in '..\forms\FMMsgDlgSim.pas' {FMsgDlgSim},
  UMProdArt in '..\Materials\UMProdArt.pas',
  UMArticles in '..\Materials\UMArticles.pas',
  UMBalance in '..\Materials\UMBalance.pas',
  UMIssuedArt in '..\Materials\UMIssuedArt.pas',
  UMOverlap in '..\Materials\UMOverlap.pas',
  UGCustomList in '..\..\lib\UGCustomList.pas',
  UMBobbins in '..\plan\UMBobbins.pas',
  UMReport in '..\Report\UMReport.pas',
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
  UMIBEvents in '..\db\UMIBEvents.pas';

{DMAS400: TDataModule}

{$R *.RES}

var
  errStr:     string;
  mainDbCode: integer;
  cfgDbCode:  integer;
  CurrDate :  TDateTime;

begin
  Application.Initialize;
  GlobLoadIniValues;
  Application.Title := 'MQM';
  Application.CreateForm(TDMib, DMib);
  //GlobLoadIniValuesFromDB;
  TSplashForm.Create(Application);
  SplashForm.Show;

  errStr := '';

  if not CheckServerConnection then
  begin
    errStr    := _('bad server connection');
    s_suicide := true;
  end
  else
  begin
    if not LoadLicence(true, errStr, mainDbCode, cfgDbCode) then ShowMessage(errStr);
    if not IsCompatibleWithDb(mainDbCode, cfgDbCode, errStr) then
      s_suicide := true
    else
    begin
      SplashForm.Update;
      DMib.RegisterEvents(false);
      //SP_ASK_POLL;
      //Sleep(5000);
      //SP_CHECK_POLL;
      //if not CheckLicenceForMain(errStr) then
      //   s_suicide := true;

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
          GlobLoadDbValues;
          GlobLoadSettingsValues;
          GlobLoadIniValuesFromDB;
          UseLanguage(DBAppGlobals.Language);

          if IsCalendarLoaded = false then
            if MessageDlg(_('No calendars have been loaded. Do you wish to abort or ignore ?'), mtWarning, [mbAbort,mbIgnore], 0) = idAbort then
              s_suicide := true;

          if not CheckLicenceForMain(errStr) then
            s_suicide := true;

          if not s_suicide and not SP_CONNECT(IniAppGlobals.WkstCode, CurrDate) then
          begin
            if not CHECK_STATION_POLLING(IniAppGlobals.WkstCode) then
            begin
              if SP_ACTIVE_WRKST(IniAppGlobals.WkstCode) then
                SP_DISCONNECT(IniAppGlobals.WkstCode);
            end;
            if not SP_CONNECT(IniAppGlobals.WkstCode, CurrDate) then
            begin
              errStr    := _('workstation unavailable');
              s_suicide := true
            end
            else
              IniAppGlobals.Curr_Date_Signed := CurrDate;
          end
          else
            IniAppGlobals.Curr_Date_Signed := CurrDate;

          if not s_suicide then
          begin
            if LoadPlanFromDB(SplashForm.ProgBar, SplashForm.StStatus) then
            begin
              Application.CreateForm(TFMQMPlan, FMQMPlan);
              LoadAutoSchedCfgFromDB;
              SplashForm.free;
            end else
            begin
              s_suicide := true;
              SP_DISCONNECT(IniAppGlobals.WkstCode)
            end;
          end
        end
      end
    end
  end;

  try
    Application.Run;
  finally
    if (ParamCount > 0) then
       s_suicide := true;
    if s_suicide then
    begin
      SplashForm.free;
      if errStr <> '' then ShowMessage(errStr)
    end
    else
    begin
      if reCheckServerConnection then
  	  begin
        SaveAutoSchedCfgToDB;
        GlobSaveValues;
        GlobSaveIniValues;
        SP_DISCONNECT(IniAppGlobals.WkstCode)
      end;
    end
  end;
end.
