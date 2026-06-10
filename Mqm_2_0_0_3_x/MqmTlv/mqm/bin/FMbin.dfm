object FBin: TFBin
  Left = 195
  Top = 349
  Caption = 'Bin'
  ClientHeight = 610
  ClientWidth = 1006
  Color = clWhite
  DockSite = True
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseMove = FormMouseMove
  PixelsPerInch = 120
  TextHeight = 16
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 1006
    Height = 26
    Cursor = crHandPoint
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = True
    Bands = <
      item
        Control = ToolBarBin
        ImageIndex = -1
        MinHeight = 22
        Width = 1000
      end>
    DockSite = True
    OnContextPopup = CoolBar1ContextPopup
    object ToolBarBin: TToolBar
      Left = 11
      Top = 0
      Width = 508
      Height = 22
      Cursor = crHandPoint
      Align = alNone
      AutoSize = True
      Caption = 'Bin toolbar'
      DragKind = dkDock
      DragMode = dmAutomatic
      EdgeInner = esNone
      EdgeOuter = esNone
      Images = BinIcons
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      object TBTmpFin: TToolButton
        Left = 0
        Top = 0
        Hint = 'Set Final/Temp.'
        Caption = 'Set to final'
        ImageIndex = 15
        MenuItem = MISetFin
        ParentShowHint = False
        ShowHint = True
      end
      object TBMoveToBin: TToolButton
        Left = 23
        Top = 0
        Hint = 'Unschedule'
        Caption = 'Current'
        ImageIndex = 25
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object TBMoveAllJobstobin: TToolButton
        Left = 46
        Top = 0
        Hint = 'Unschedule jobs in current bin'
        Caption = 'All in bin'
        ImageIndex = 26
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object ToolButton1: TToolButton
        Left = 69
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object TBJobMsg: TToolButton
        Left = 77
        Top = 0
        Hint = 'new Messages'
        Caption = 'TBJobMsg'
        ImageIndex = 10
        ParentShowHint = False
        ShowHint = True
      end
      object SPSelection: TToolButton
        Left = 100
        Top = 0
        Width = 8
        Caption = 'SPSelection'
        ImageIndex = 34
        Style = tbsSeparator
      end
      object TBShowOnPlan: TToolButton
        Left = 108
        Top = 0
        Hint = 'Show on plan'
        Caption = 'Show on plan'
        ImageIndex = 9
        MenuItem = MIShowOnPlan
        ParentShowHint = False
        ShowHint = True
      end
      object TBJobHandling: TToolButton
        Left = 131
        Top = 0
        Hint = 'Step jobs handling'
        Caption = 'Step jobs handling'
        ImageIndex = 27
        MenuItem = MIJobHandling
        ParentShowHint = False
        ShowHint = True
      end
      object TBShowMaterials: TToolButton
        Left = 154
        Top = 0
        Hint = 'Show requirements'
        Caption = 'Show requirements'
        ImageIndex = 17
        MenuItem = MIShowrequirements
        ParentShowHint = False
        ShowHint = True
      end
      object TBStartAutoSched: TToolButton
        Left = 177
        Top = 0
        Hint = 'Automatic sequencing'
        Caption = 'Run automatic sequencing by'
        ImageIndex = 6
        MenuItem = MIAutoSched
        ParentShowHint = False
        ShowHint = True
        OnMouseDown = TBStartAutoSchedMouseDown
      end
      object ToolButton2: TToolButton
        Left = 200
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 5
        Style = tbsSeparator
      end
      object ToolButton3: TToolButton
        Left = 208
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 6
        Style = tbsSeparator
      end
      object TBJobDetails: TToolButton
        Left = 216
        Top = 0
        Hint = 'Job details'
        Caption = 'Job details'
        ImageIndex = 5
        MenuItem = MiJobDetails
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton4: TToolButton
        Left = 239
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 8
        Style = tbsSeparator
      end
      object TBAutoGrouping: TToolButton
        Left = 247
        Top = 0
        Hint = 'Automatic grouping'
        Caption = 'Automatic grouping'
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object TBAddToGroup: TToolButton
        Left = 270
        Top = 0
        Hint = 'Add to group'
        Caption = 'Add to group'
        ImageIndex = 19
        MenuItem = MIAddToGroup
        ParentShowHint = False
        ShowHint = True
      end
      object TBModiGrp: TToolButton
        Left = 293
        Top = 0
        Hint = 'Group handling'
        Caption = 'Group handling'
        ImageIndex = 22
        MenuItem = MIModiGrp
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton5: TToolButton
        Left = 316
        Top = 0
        Width = 8
        Caption = 'ToolButton5'
        ImageIndex = 12
        Style = tbsSeparator
      end
      object TBBinTab: TToolButton
        Left = 324
        Top = 0
        Hint = 'Bin tab'
        Caption = 'Edit existing tab'
        ImageIndex = 18
        MenuItem = MIBinTab
        ParentShowHint = False
        ShowHint = True
      end
      object TBShowtabtotals: TToolButton
        Left = 347
        Top = 0
        Hint = 'Tab totals'
        Caption = 'Tab totals'
        ImageIndex = 29
        MenuItem = MIShowtabtotals
        ParentShowHint = False
        ShowHint = True
      end
      object TBPosReqOnBin: TToolButton
        Left = 370
        Top = 0
        Hint = 'Position request on Bin'
        Caption = 'TBPosReqOnBin'
        ImageIndex = 31
        ParentShowHint = False
        ShowHint = True
        Visible = False
        OnClick = TBPosReqOnBinClick
      end
      object TBPosColumnOnBin: TToolButton
        Left = 393
        Top = 0
        Hint = 'Position column value on Bin'
        Caption = 'TBPosColumnOnBin'
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = TBPosColumnOnBinClick
      end
      object TBRefresh: TToolButton
        Left = 416
        Top = 0
        Hint = 'Filter/Sort'
        Caption = 'TBRefresh'
        ImageIndex = 0
        ParentShowHint = False
        ShowHint = True
        OnClick = TBRefreshClick
      end
      object TBUpOrder: TToolButton
        Left = 439
        Top = 0
        Hint = 'Ascending column'
        Caption = 'TBUpOrder'
        ImageIndex = 12
        ParentShowHint = False
        ShowHint = True
        OnClick = TBUpDownOrderClick
      end
      object TBDownOrder: TToolButton
        Left = 462
        Top = 0
        Hint = 'Descending column'
        Caption = 'TBDownOrder'
        ImageIndex = 13
        ParentShowHint = False
        ShowHint = True
        OnClick = TBUpDownOrderClick
      end
      object TBReport: TToolButton
        Left = 485
        Top = 0
        Hint = 'Bin inquiry'
        Caption = 'TBReport'
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = TBReportClick
      end
    end
  end
  object CoolBar2: TCoolBar
    Left = 969
    Top = 26
    Width = 37
    Height = 547
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alRight
    AutoSize = True
    Bands = <>
    DockSite = True
    Vertical = True
  end
  object CoolBar3: TCoolBar
    Left = 0
    Top = 26
    Width = 37
    Height = 547
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alLeft
    AutoSize = True
    Bands = <>
    DockSite = True
    Vertical = True
  end
  object CoolBar4: TCoolBar
    Left = 0
    Top = 573
    Width = 1006
    Height = 37
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    AutoSize = True
    BandBorderStyle = bsNone
    Bands = <>
    DockSite = True
  end
  object PopUpBin: TPopupMenu
    AutoHotkeys = maManual
    Images = BinIcons
    OnPopup = PopUpBinPopup
    Left = 92
    Top = 48
    object MIMoveOnPlan: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Move on plan'
      Hint = 'Move on plan'
      ImageIndex = 16
      Visible = False
      OnClick = MIMoveOnPlanClick
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object MINextLevel: TMenuItem
      Caption = 'Set to next confermation level'
      OnClick = MINextLevelClick
    end
    object MISetFin: TMenuItem
      Caption = 'Set to final'
      Hint = 'Set Final/Temp.'
      ImageIndex = 15
      OnClick = MISetFinClick
    end
    object MISetConfirmLevelTo: TMenuItem
      Caption = 'Set confirmation level to...'
      ImageIndex = 24
      object MiConfInitial: TMenuItem
        Caption = 'Initial'
        OnClick = MISetConfLevelToClick
        OnDrawItem = DrawItemPopUp
      end
      object MiConfLevel1: TMenuItem
        Caption = 'Level 1'
        OnClick = MISetConfLevelToClick
        OnDrawItem = DrawItemPopUp
      end
      object MiConfLevel2: TMenuItem
        Caption = 'Level 2'
        OnClick = MISetConfLevelToClick
        OnDrawItem = DrawItemPopUp
      end
      object MiConfLevel3: TMenuItem
        Caption = 'Level 3'
        OnClick = MISetConfLevelToClick
        OnDrawItem = DrawItemPopUp
      end
      object MiConfLevel4: TMenuItem
        Caption = 'Level 4'
        OnClick = MISetConfLevelToClick
        OnDrawItem = DrawItemPopUp
      end
      object MiConfLevel5: TMenuItem
        Caption = 'Level 5'
        OnClick = MISetConfLevelToClick
        OnDrawItem = DrawItemPopUp
      end
      object MiConfFinal: TMenuItem
        Caption = 'Final'
        OnClick = MISetConfLevelToClick
        OnDrawItem = DrawItemPopUp
      end
    end
    object MiRemoveJobsCalculatedLimitDates: TMenuItem
      Caption = 'Remove jobs calculated limit dates'
      OnClick = MiRemoveJobsCalculatedLimitDatesClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object MIUnschedule: TMenuItem
      Caption = 'Unschedule'
      OnClick = MIUnscheduleClick
    end
    object MIUnscheduleSelectedAndForwardLinkedJobs: TMenuItem
      Caption = 'Unschedule selected and forward linked jobs'
      Visible = False
      OnClick = MIUnscheduleSelectedAndForwardLinkedJobsClick
    end
    object MiLastOnGantt: TMenuItem
      Caption = 'Unschedule all in bin that are last on gantt'
      Visible = False
      OnClick = MiLastOnGanttClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object MIJobHandling: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Step jobs handling'
      Hint = 'Step jobs handling'
      ImageIndex = 27
      OnClick = MIJobHandlingClick
    end
    object MIShowOnPlan: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Show on plan'
      Hint = 'Show on plan'
      ImageIndex = 9
      OnClick = MIShowOnPlanClick
    end
    object MIShowrequirements: TMenuItem
      Caption = 'Show requirements'
      Hint = 'Show requirements'
      ImageIndex = 17
      OnClick = MIShowrequiermentsClick
    end
    object MIStockDetails: TMenuItem
      Caption = 'Stock details'
      OnClick = MIStockDetailsClick
    end
    object N3: TMenuItem
      AutoHotkeys = maManual
      Caption = '-'
    end
    object MIAutoSched: TMenuItem
      Caption = 'Run automatic sequencing by'
      Hint = 'Automatic sequencing'
      ImageIndex = 6
      OnClick = MIAutoSchedClick
      object MIStartAutoSchedCurrentCfg: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Current configuration'
        Hint = 'Automatic sequencing'
        OnClick = MIStartAutoSchedCurrentCfgClick
        OnDrawItem = DrawItemPopUp
      end
      object MiAutoSeqBySelectedCfg: TMenuItem
        Caption = 'Selected configuration'
        OnClick = MiAutoSeqBySelectedCfgClick
        OnDrawItem = DrawItemPopUp
      end
      object MIStartAutoSchedWcCfg: TMenuItem
        Caption = 'Work center configuration'
        OnClick = MIStartAutoSchedWcCfgClick
        OnDrawItem = DrawItemPopUp
      end
      object MIAutoSchedPlusGeneric: TMenuItem
        Caption = 'Rebuild generic plan first'
        OnClick = MIAutoSchedPlusGenericClick
        OnDrawItem = DrawItemPopUp
      end
      object MiSelectedJobOverridingParams: TMenuItem
        Caption = 'Overriding parameters'
        OnClick = MiSelectedJobOverridingParamsClick
        OnDrawItem = DrawItemPopUp
      end
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object MiRepositionJobsToRealMachines: TMenuItem
      Caption = 'Try to reposition all jobs to real machines'
      ImageIndex = 37
      OnClick = MiRepositionJobsToRealMachinesClick
    end
    object N4: TMenuItem
      AutoHotkeys = maManual
      Caption = '-'
    end
    object MiJobDetails: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Job details'
      Hint = 'Job details'
      ImageIndex = 5
      OnClick = MiJobDetailsClick
    end
    object MICopy: TMenuItem
      Caption = 'Copy'
      OnClick = MICopyClick
    end
    object N1: TMenuItem
      AutoHotkeys = maManual
      Caption = '-'
    end
    object MINewGroup: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Create group'
      Hint = 'Create group'
      ImageIndex = 21
      OnClick = MINewGroupClick
    end
    object MIAutoUnGroupingSelection: TMenuItem
      Caption = 'Ungroup'
      ImageIndex = 40
      OnClick = MIAutoUnGroupingSelectionClick
    end
    object MIAutoGroupingSelection: TMenuItem
      Caption = 'Automatic grouping'
      ImageIndex = 20
      OnClick = MIAutoGroupingSelectionClick
    end
    object MIAddToGroup: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Add to group'
      Hint = 'Add to group'
      ImageIndex = 19
      OnClick = MIAddToGroupClick
    end
    object MIModiGrp: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Group handling'
      Hint = 'Group handling'
      ImageIndex = 22
      OnClick = MIModiGrpClick
    end
    object N2: TMenuItem
      AutoHotkeys = maManual
      Caption = '-'
    end
    object MiSearchBySelectedCellInGroupedBy: TMenuItem
      Caption = 'Search by selected cell group by'
      ImageIndex = 31
      OnClick = MiSearchBySelectedCellInGroupedByClick
    end
    object MiSearchBySelectedCell: TMenuItem
      Caption = 'Search by selected cell'
      ImageIndex = 31
      OnClick = MiSearchBySelectedCellClick
    end
    object MINewTabMain: TMenuItem
      Caption = 'Create new tab '
      OnClick = MINewTabMainClick
      object MIWarpTab: TMenuItem
        Caption = 'Warp'
        OnClick = MIWarpTabClick
        OnDrawItem = DrawItemPopUp
      end
      object MINewTab: TMenuItem
        AutoHotkeys = maManual
        Caption = 'New'
        OnClick = MINewTabClick
        OnDrawItem = DrawItemPopUp
      end
      object MIDftValProdReq: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Using current job values'
        OnClick = MIDftValProdReqClick
        OnDrawItem = DrawItemPopUp
      end
      object MICopyCnfg: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Using current bin configuration'
        OnClick = MICopyCnfgClick
        OnDrawItem = DrawItemPopUp
      end
      object MICreateBinUsingCurentCell: TMenuItem
        Caption = 'Using current cell '
        Visible = False
        OnClick = MICreateBinUsingCurentCellClick
        OnDrawItem = DrawItemPopUp
      end
      object MiCreateTabForGroupByDetailsKeepFilter: TMenuItem
        Caption = 'Group details add on current filter'
        OnClick = MiCreateTabForGroupByDetailsKeepFilterClick
        OnDrawItem = DrawItemPopUp
      end
      object MiSearchAndCreateNewTab: TMenuItem
        Caption = 'By column value input'
        OnDrawItem = DrawItemPopUp
        object MISearchCrtProdReq: TMenuItem
          Caption = 'Production request'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiSearchStep: TMenuItem
          Caption = 'Step'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiSearchSubStep: TMenuItem
          Caption = 'Sub step'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiSearchGroupNumber: TMenuItem
          Caption = 'Group number'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiSearchResource: TMenuItem
          Caption = 'Resource'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiSearchQty: TMenuItem
          Caption = 'Quantity'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiSearchProductionFamily: TMenuItem
          Caption = 'Product family'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiSearchMaterialFamily: TMenuItem
          Caption = 'Material family'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiProductiondeliverydate: TMenuItem
          Caption = 'Production delivery date '
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiPlanStart: TMenuItem
          Caption = 'Planned start date'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiScheduledstartdate: TMenuItem
          Caption = 'Actual start date'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiLatestendingdate: TMenuItem
          Caption = 'Latest end'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiLowStartTimeLimit: TMenuItem
          Caption = 'Earliest start date'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiProductionearliestdate: TMenuItem
          Caption = 'Prod.req earliest date'
          OnClick = MISearchCrtTabClick
          OnDrawItem = DrawItemPopUp
        end
        object MiSearchProperty: TMenuItem
          Caption = 'Properties'
          OnClick = MiSearchPropertyClick
          OnDrawItem = DrawItemPopUp
        end
      end
    end
    object MiDrillDown: TMenuItem
      Caption = 'Drill down'
    end
    object MIBinTab: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Edit existing tab'
      Hint = 'Bin tab'
      ImageIndex = 18
      object EditTab: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Edit'
        OnClick = EditTabClick
        OnDrawItem = DrawItemPopUp
      end
      object MiBinCong: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Configuration'
        OnClick = MiBinCongClick
        OnDrawItem = DrawItemPopUp
      end
      object MIClose: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Delete'
        OnClick = MICloseClick
        OnDrawItem = DrawItemPopUp
      end
    end
    object MIShowtabtotals: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Tab totals'
      Hint = 'Tab totals'
      ImageIndex = 29
      OnClick = MIShowTabTotalsClick
    end
    object MIWCenterHandle: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Work center'
      Hint = 'Work center'
      Visible = False
      object MiChangeWcToAlljobsListedInCurrentBin: TMenuItem
        Caption = 'All jobs listed in current bin '
        OnDrawItem = DrawItemPopUp
        object MiSetWcPlant: TMenuItem
          Caption = 'Alter planned work center by plant '
          OnClick = MiSetWcPlantClick
          OnDrawItem = DrawItemPopUp
        end
        object MiReturnOriginalPlantWc: TMenuItem
          Caption = 'Return to original work center'
          OnClick = MiReturnOriginalPlantWcClick
          OnDrawItem = DrawItemPopUp
        end
      end
      object MiChangeWcOnlySelectedJob: TMenuItem
        Caption = 'Only selected job'
        OnDrawItem = DrawItemPopUp
        object MIChangeWC: TMenuItem
          AutoHotkeys = maManual
          Caption = 'Change planned work center'
          OnClick = MIChangeWCClick
          OnDrawItem = DrawItemPopUp
        end
        object MIReturnWCOriginal: TMenuItem
          AutoHotkeys = maManual
          Caption = 'Return to original work center'
          OnClick = MIReturnWCOriginalClick
          OnDrawItem = DrawItemPopUp
        end
      end
    end
    object MIClearAllMsgHost: TMenuItem
      Caption = 'Clear all job messages from host'
      OnClick = MIClearAllMsgHostClick
    end
    object MIClearJobHostMsg: TMenuItem
      Caption = 'Clear job message from host'
      OnClick = MIClearJobHostMsgClick
    end
    object MIAlterWorkCenterAndSplitAccordingToMcm: TMenuItem
      Caption = 'Alter work center and split according to mcm '
      OnClick = MIAlterWorkCenterAndSplitAccordingToMcmClick
    end
    object MISplitJobsByStepNumberOfMachines: TMenuItem
      Caption = 'Split jobs by step number of machines'
      OnClick = MISplitJobsByStepNumberOfMachinesClick
    end
    object MIJoinAll: TMenuItem
      Caption = 'Join all not scheduled sub steps in bin'
      OnClick = MIJoinAllClick
    end
    object MiBalanceStep: TMenuItem
      Caption = 'Balance step'
      OnClick = MiBalanceStepClick
    end
    object MiBalanceImbalanceInBin: TMenuItem
      Caption = 'Balance Imbalanced steps in bin'
      OnClick = MiBalanceImbalanceInBinClick
    end
    object MiLearningCurveChange: TMenuItem
      Caption = 'Learning curve'
      object MiChangingCurveCode: TMenuItem
        Caption = 'Change'
        OnClick = MiChangingCurveCodeClick
        OnDrawItem = DrawItemPopUp
      end
      object MiRemoveCurveCode: TMenuItem
        Caption = 'Remove Code'
        OnClick = MiRemoveCurveCodeClick
        OnDrawItem = DrawItemPopUp
      end
    end
    object MIMsgJobHandle: TMenuItem
      Caption = 'Job messages'
      OnClick = MIMsgJobHandleClick
    end
    object MiAssignedBooleanProp1: TMenuItem
      Caption = 'Set bin jobs selection property to'
      OnClick = MiAssignedBooleanProp1Click
      object MiSettAllJobsAssgnedJobFalse: TMenuItem
        Caption = 'No'
        OnClick = MiSettAllJobsAssgnedJobFalseClick
        OnDrawItem = DrawItemPopUp
      end
      object MiSettAllJobsAssgnedJobTrue: TMenuItem
        Caption = 'Yes'
        OnClick = MiSettAllJobsAssgnedJobTrueClick
        OnDrawItem = DrawItemPopUp
      end
      object MiSettAllJobsAssgnedJobFalseAndServingCode: TMenuItem
        Caption = 'No (also to related serving code jobs) '
        OnClick = MiSettAllJobsAssgnedJobFalseAndServingCodeClick
        OnDrawItem = DrawItemPopUp
      end
      object MiSettAllJobsAssgnedJobTrueAndServingCode: TMenuItem
        Caption = 'Yes (also to related serving code jobs)'
        OnClick = MiSettAllJobsAssgnedJobTrueAndServingCodeClick
        OnDrawItem = DrawItemPopUp
      end
      object Copyselectionpropertyfromcurrentsteptoprevstep: TMenuItem
        Caption = 'Copy selection property from current step to prev step'
        OnClick = CopyselectionpropertyfromcurrentsteptoprevstepClick
        OnDrawItem = DrawItemPopUp
      end
      object Copyselectionpropertyfromcurrentsteptonextstep: TMenuItem
        Caption = 'Copy selection property from current step to next step'
        OnClick = CopyselectionpropertyfromcurrentsteptonextstepClick
        OnDrawItem = DrawItemPopUp
      end
      object Copyselectionpropertyfromcurrentsteptoprevsteps: TMenuItem
        Caption = 'Copy selection property from current step to prev steps'
        OnClick = CopyselectionpropertyfromcurrentsteptoprevstepsClick
        OnDrawItem = DrawItemPopUp
      end
      object Copyselectionpropertyfromcurrentsteptonextsteps: TMenuItem
        Caption = 'Copy selection property from current step to next steps'
        OnClick = CopyselectionpropertyfromcurrentsteptonextstepsClick
        OnDrawItem = DrawItemPopUp
      end
      object MiSetlinkedStepsPropertyValueFromJobSelection: TMenuItem
        Caption = 'Copy selection property from current step to prev and next step'
        OnClick = MiSetlinkedStepsPropertyValueFromJobSelectionClick
        OnDrawItem = DrawItemPopUp
      end
      object MiSettAllCopyValueFromNextLinkedReq: TMenuItem
        Caption = 'Copy selection property from next linked step'
        OnClick = MiSettAllCopyValueFromNextLinkedReqClick
        OnDrawItem = DrawItemPopUp
      end
    end
    object MIPropPlannerdef: TMenuItem
      Caption = 'Job Properties definition'
      OnClick = MIPropPlannerdefClick
    end
    object MISplitOnHost: TMenuItem
      Caption = 'Split also on host'
      OnClick = MISplitOnHostClick
    end
    object MiSeedChange: TMenuItem
      Caption = 'Modify execution/setup'
      OnClick = MiSeedChangeClick
    end
    object MiJoinAndSplitAccordingNextStep: TMenuItem
      Caption = 'Join and split all according next step'
      OnClick = MiJoinAndSplitAccordingNextStepClick
    end
    object MiCreateVersioning: TMenuItem
      Caption = 'Versioning'
      object Create1: TMenuItem
        Caption = 'Create'
        OnClick = MiCreateVersioningClick
      end
      object Returntosavedversion1: TMenuItem
        Caption = 'Return to saved version'
        OnClick = Returntosavedversion1Click
      end
      object CleanVersion: TMenuItem
        Caption = 'Clean'
        OnClick = CleanVersionClick
      end
    end
    object MiFormularesult: TMenuItem
      Caption = 'Summarized view'
    end
    object MiReApplyIgnoreProgress: TMenuItem
      Caption = 'Re-apply ignore progress'
      OnClick = MiReApplyIgnoreProgressClick
    end
  end
  object ImageListBin: TImageList
    Left = 40
    Top = 40
    Bitmap = {
      494C010134006801040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000E0000000010020000000000000E0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000077777700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFCC
      CC00FFCCCC00FFCCCC00FFFFFF00FFFFFF00CC999900CC999900000000007777
      7700777777000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00000808000008080000000
      00000000000000000000000000000000000000000000CC999900CC999900FFCC
      CC00FFCCCC00FFCCCC00FFFFFF00FFFFFF00CC999900CC999900CC999900CC99
      9900777777007777770000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00000808000008080000080
      800000808000000000000000000000000000CC999900CC999900CC9999000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000CC999900CC99
      9900CC9999007777770000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000C0C0C00000808000008080000080
      800000808000008080000080800000000000CC99990000000000FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000CC9999007777770077777700000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000C0C0C00000808000008080000080
      80000080800000808000008080000000000000000000FFFFFF0000000000FF99
      9900FF999900FF999900FF999900FF999900FF999900FF99990000000000FFFF
      FF00000000007777770077777700000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000C0C0C00000808000008080000080
      800000808000008080000080800000000000FFFFFF0000000000FF999900FF99
      9900FF999900FF999900FF999900FF999900FF999900FF999900996666000000
      0000FFFFFF007777770077777700000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000FFFF00000000
      000000000000000000000000000000000000C0C0C00000000000000000000080
      800000808000008080000080800000000000FFFFFF0000000000CC999900FF99
      9900FFFFFF0099666600996666009966660099666600FF999900CC9999000000
      0000FFFFFF007777770000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000C0C0C00000808000008080000080
      80000080800000808000008080000000000000000000FFFFFF0000000000CC99
      9900CC999900CC999900CC999900CC999900CC999900CC99990000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000C0C0C00000808000008080000080
      8000008080000080800000808000000000000000000000000000FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000777777000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000C0C0C00000808000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000C0C0
      C00000000000777777000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      000000000000000000000000000080808000C0C0C00000808000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C0C0
      C000000000000000000077777700000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800000000000C0C0C0000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007777
      7700111111000000000000000000777777000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080000000
      0000C0C0C0000080800000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000777777001111110000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      80008080800000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007777770011111100000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C00084848400C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000FF00000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF00C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C00084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C000C0C0C0008080800000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C00084848400FFFFFF00000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C000808080008080800000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C00084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00C6C6C600000000000000000000000000000000000000
      0000C66B1800BD5A0800C65A0800BD5A0800BD5A0800BD5A0800B5520800EFCE
      BD00000000000000000000000000000000000000000080800000C0C0C000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008080800080808000C0C0C00000000000C0C0C000C0C0C000C0C0C000C0C0
      C00000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00C0C0C000C0C0C000C0C0C000C0C0C00084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF00C6C6C6000000FF00C6C6
      C6000000FF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000EF8C0000F78C0000EF8C0000EF840000E7840000E77B0000DE730000BD63
      1800000000000000000000000000000000000000000080800000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF008080
      800080808000C0C0C000FF00000000000000C0C0C000C0C0C000C0C0C00000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00C0C0C000C0C0C000C0C0C00084848400FFFFFF00FFFFFF00FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000FF940000FF940000FF940000F7940000F78C0000EF840000E77B0000C663
      1800000000000000000000000000000000000000000080800000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C0C0C000FFFFFF00FF00000000000000C0C0C000C0C0C00000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF00C0C0C000C0C0C00084848400FFFFFF00FF000000FF00
      0000FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FFFFFF00C6C6C600000000000000000000000000000000000000
      0000FF9C1000FFA52100FFA51800FF9C0800FF940000F78C0000E7840000C663
      180000000000000000000000000000000000C0C0C00080800000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FF00000000000000C0C0C00000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00C0C0C000C0C0C00084848400FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF00000084840000C6C6
      C60084840000FFFFFF00C6C6C600000000000000000000000000000000000000
      0000FFAD3100FFAD4200FFAD4200FFA52900FF9C0800F7940000EF840000C66B
      180000000000000000000000000000000000FFFFFF0080800000FFFFFF008080
      000080800000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080800000FF00000000000000C0C0C00000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00C0C0C00084848400FF000000FF000000FF00
      0000FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000FFB54A00FFBD6300FFBD6300FFAD3900FFA51800FF940000EF8C0000C66B
      180000000000000000000000000000000000FFFFFF0080800000FFFFFF008080
      000080800000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080800000FF00000000000000C0C0C00000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF00C0C0C00084848400FF000000FF000000FF00
      0000FF000000FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF00
      0000FF000000FFFFFF00C6C6C600000000000000000000000000000000000000
      0000FFB55200FFBD6B00FFBD6300FFAD4200FFA51800FF940000F78C0000C66B
      180000000000000000000000000000000000FFFFFF0080800000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000C0C0C00000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00C0C0C00084848400FF000000FF000000FF00
      0000FF000000FF000000FFFFFF00FFFFFF00FF000000FF00000000FF0000C6C6
      C60000FF0000FFFFFF00C6C6C600000000000000000000000000000000000000
      0000FFA53100FFB55200FFB54A00FFAD3100FF9C1000FF940000EF840000CE7B
      310000000000000000000000000000000000FFFFFF0080800000808000008080
      00008080000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00080800000000000000000000000000000C0C0C00000FFFF0000FFFF0000FF
      FF0000FFFF0000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF00C0C0C00084848400FF000000FF000000FFFF
      FF00FFFFFF00FF000000FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0080800000808000008080
      0000808000008080000000000000C0C0C000C0C0C000C0C0C000000000008080
      000080800000000000000000000000000000C0C0C000C0C0C00000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF00C0C0C000C0C0C0008484840084848400FF000000FF00
      0000FFFFFF00FFFFFF00FFFFFF00FF000000FF00000084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C00000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00C0C0C000C0C0C000C0C0C000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080000080800000808000008080
      000080800000808000008080000080800000808000008080000080800000FF00
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080000080800000808000008080
      000080800000808000008080000080800000808000008080000080800000FF00
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C6000000000000000000C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400000000000000000000000000000000000000000084848400848484008484
      84008484840084848400000000000000000000000000C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000C6C6C600C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00848484008484840000FF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000FFFF00848484008484840000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6C6008484
      8400000000008484840000000000000000000000000000000000000000008484
      84008484840084848400000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C60000000000C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600000000008484840084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600FFFFFF0000000000C6C6C600FFFFFF00000000000000
      0000C6C6C6008484840084848400000000000000000000000000C6C6C600C6C6
      C60000000000C6C6C600C6C6C6000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00000000000000000000FFFF0000FFFF0000FFFF0000FFFF000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600FFFF
      FF00C6C6C600FFFFFF00C6C6C600FFFFFF000000000000000000FFFFFF00C6C6
      C600FFFFFF00C6C6C60084848400000000000000000000000000000000000000
      0000C6C6C60000000000000000000000000000000000C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600000000000000
      000000000000000000000000000000000000000000007B7B7B000000FF000000
      FF0000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000C6C6C600FFFFFF00000000000000000000000000C6C6C600FFFF
      FF00C6C6C600FFFFFF00C6C6C600000000008484840000000000000000000000
      FF00848484000000FF00000000000000000000000000C6C6C600FFFFFF000000
      00000000000000000000000000000000000000000000000000000000FF008484
      84000000FF00000000000000000000000000C6C6C600FFFFFF00000000000000
      0000000000000000000000000000000000007B7B7B000000FF00000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF00000000000000000000000000C6C6C600FFFFFF0000000000C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      FF000000FF000000FF00000000000000000000000000FFFFFF00C6C6C6000000
      000000000000C6C6C60000000000C6C6C60000000000000000000000FF000000
      FF000000FF00000000000000000000000000FFFFFF00C6C6C600000000000000
      0000C6C6C60000000000C6C6C600000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000000000C6C6C600FFFFFF00C6C6C600FFFFFF000000
      0000C6C6C6000000000000000000000000008484840000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000008400000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000084000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000000000C6C6C600FFFFFF00C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000840000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000084000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF000000000000000000C6C6C600FFFFFF0000000000000000000000
      0000000000000000000000000000000000008484840084848400000000008484
      8400C6C6C6008484840000000000000000000000000000000000000000000000
      000000000000000000000084000000000000000000000000000084848400C6C6
      C600848484000000000000000000000000000000000000000000000000000000
      0000000000000084000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000008484840084848400848484008484
      840000000000848484000000000084848400000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B000000FF0000000000000000000000000000000000000000000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400000000008484
      8400000000008484840000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000848484000000
      0000848484000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400000000008484840000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C600C6C6C6000000000000000000C6C6C600C6C6
      C60000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000C6C6C6000000000000000000C6C6C600C6C6
      C6000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C6000000000084848400C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00000000000000000000000000C6C6C600C6C6C600000000000000
      00000000000000000000000000000000000084848400FFFFFF00000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000000000000000000000FFFF00848484008484840000FFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000848484008484840000FFFF000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FFFF000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FF00
      0000FF000000FF000000FF000000FF0000000000FF00C6C6C6000000FF00C6C6
      C6000000FF00FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000000000000000000000FFFF0000FFFF0000FFFF000000
      00000000000000000000000000000000000084848400FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000008484840000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000FF00C6C6C6000000FF00C6C6
      C6000000FF00FFFFFF00C6C6C6000000000000000000C6C6C600C6C6C6000000
      0000C6C6C600C6C6C6000000000000FFFF0000FFFF0000FFFF0000FFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00000000000000000000FFFF0000FFFF0000FFFF0000FFFF000000
      00000000000000000000000000000000000084848400FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C60000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C600C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FFFFFF00FF000000FF000000FF000000FF000000FF000000FF000000C6C6
      C60084840000FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FFFFFF00C6C6C6000000000000000000000000000000FF008484
      84000000FF00000000000000000000000000C6C6C600FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000000000FF008484
      84000000FF00000000000000000000000000C6C6C600FFFFFF00000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084840000C6C6C60084840000C6C6C60084840000C6C6
      C60084840000FFFFFF00C6C6C6000000000000000000000000000000FF000000
      FF000000FF00000000000000000000000000FFFFFF00C6C6C600000000000000
      0000C6C6C60000000000C6C6C6000000000000000000000000000000FF000000
      FF000000FF00000000000000000000000000FFFFFF00C6C6C600000000000000
      0000C6C6C60000000000C6C6C60000000000FF000000FF000000FF000000FFFF
      FF00FF000000FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF00
      0000FF000000FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C6000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      00000000000000840000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000008400000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FFFFFF00FFFFFF00FF000000FF000000FF000000C6C6
      C60000FF0000FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00C6C6C600000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000084000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000008400000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FFFFFF00FF000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF00C6C6
      C60000FF0000C6C6C60000FF0000C6C6C60000FF0000C6C6C60000FF0000C6C6
      C60000FF0000FFFFFF00C6C6C60000000000000000000000000084848400C6C6
      C600848484000000000000000000000000000000000000000000000000000000
      000000000000008400000000000000000000000000000000000084848400C6C6
      C600848484000000000000000000000000000000000000000000000000000000
      00000000000000840000000000000000000084848400FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000848484008484
      84008484840084848400848484000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C60000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000084848400000000008484840000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00008484840000000000848484000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000848484000000
      0000848484000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000848484000000
      0000848484000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000084840000000000000000000000
      0000008484000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600C6C6C600C6C6
      C600FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600C6C6C600000000000000000000000000C6C6
      C600FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084840000FFFFFF00FFFFFF00FFFFFF0084840000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484000084840000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      00008400000084000000840000000000000084848400FFFFFF00FFFFFF008484
      8400848484008484840084848400FFFFFF000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000FF0000000000C6C6
      C600FFFFFF000000000000000000000000000000000000000000848400008484
      0000848400008484000084848400848400008484000084840000848484008484
      00008484000084840000848400000000000084840000FFFFFF00848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      00008484000084840000840000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000084840000000000000000000000
      0000008484000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000C6C6C600FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084840000FFFFFF00FFFFFF00FFFFFF0084840000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000084840000FFFF0000848400000000
      0000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFF
      FF00C6C6C60000000000840000000000000084848400FFFFFF00FFFFFF008484
      8400848484008484840084848400FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000C6C6C600FFFFFF00FFFFFF00C6C6C600C6C6C600C6C6
      C600FFFFFF000000000000000000000000000000000000000000848400008484
      0000848400008484000084848400848400008484000084840000848484008484
      00008484000084840000848400000000000084840000FFFFFF00848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      00008484000084840000840000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000084840084848400848484008484
      8400848484000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000C6C6C600C6C6C600000000000000000000000000C6C6
      C600FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084840000FFFFFF00FFFFFF00FFFFFF0084840000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000084840000FFFF0000848400000000
      0000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF0000000000840000000000000084848400FFFFFF00FFFFFF008484
      8400848484008484840084848400FFFFFF000084840000FFFF0000FFFF00C6C6
      C600000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000FF000000000000C6C6
      C600FFFFFF000000000000000000000000000000000000000000848400008484
      0000848400008484000084848400848400008484000084840000848484008484
      00008484000084840000848400000000000084840000FFFFFF00848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      00008484000084840000840000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084848400000000000084840000FFFF0000FFFF0000FF
      FF00C6C6C6000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000C6C6C600C6C6C600000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084840000FFFFFF00FFFFFF00FFFFFF0084840000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000084840000FFFF000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600848400008484
      00008484000084840000840000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00840000000000000000FFFF0000FF
      FF0000FFFF00C6C6C600000000000000000000000000FFFFFF00C6C6C600C6C6
      C600000000000000000000000000C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      00008484000084840000848400000000000084840000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600848400008484
      00008484000084840000840000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00C6C6C60000000000000000000000000000848400848484000000000000FF
      FF0000FFFF0000FFFF00000000000000000000000000FFFFFF00000000000000
      00000000000000FFFF0000000000C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000084840000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000848400008484
      0000848400008484000084000000000000008484840084848400848484008484
      8400848484000000000000FFFF0000FFFF00C6C6C6008484840084848400C6C6
      C60000FFFF0000FFFF00000000000000000000000000FFFFFF0000000000C6C6
      C600000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084840000FFFFFF00FFFF0000FFFF
      FF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF00FFFF0000FFFFFF0084840000000000000000000000000000000000000000
      0000000000000084840000FFFF0000FFFF0000FFFF00008484000084840000FF
      FF0000FFFF0000FFFF00000000000000000000000000FFFFFF0000000000C6C6
      C600C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400008484000084840000000000000000000000000000000000000000
      000000000000000000000084840000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00C6C6C60084848400000000000000000000000000000000000000
      0000C6C6C6000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000084840000FFFF0000FFFF0000FFFF0000FF
      FF00C6C6C6000084840000000000000000000000000000000000FFFF00000000
      0000C6C6C6000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400C6C6C6000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000FFFF00008484
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      00000000000000000000000000000000000084848400C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C60000008400C6C6C6000000FF000000
      840000000000C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      00000000000000000000000000000000000084000000FFFF000084840000FF00
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF0084840000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000008400C6C6C6000000FF00000084000000
      0000FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400C6C6
      C600C6C6C600C6C6C600C6C6C60084000000FFFF000084840000FF000000C6C6
      C600C6C6C6000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000008484000084840000848484008484
      00008484000084840000848400000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000008400C6C6C6000000FF000000840000000000FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF0084000000FFFF000084840000FF000000C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF0084840000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000084848400FFFFFF00000000008484
      84000000000000000000FFFFFF000000FF000000840000000000000000000000
      000000000000FFFFFF00C6C6C60000000000848484000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000848484000000
      00000000000084848400FFFFFF0084840000FF000000C6C6C600C6C6C600FFFF
      FF00C6C6C60000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000008484000084840000848484008484
      00008484000084840000848400000000000084848400C6C6C60084848400C6C6
      C600FFFF0000C6C6C600C6C6C600000000008484000084840000848400008484
      000084840000FFFFFF00C6C6C60000000000000000000000000084848400FFFF
      FF0000000000000000000000000000000000FFFFFF000000000000000000FFFF
      FF00C6C6C6000000000000000000000000000000000084848400C6C6C600FFFF
      0000C6C6C60000000000C6C6C60000000000C6C6C600C6C6C600FFFFFF00FFFF
      FF00C6C6C60000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FFFFFF00FF000000FF000000FFFFFF00FFFFFF0084840000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000084848400C6C6C600FFFFFF00FFFF
      0000C6C6C600FFFF0000C6C6C60000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000008484840084848400000000008484
      8400FFFFFF000000FF000000FF000000FF000000FF00FFFFFF000000FF000000
      FF00FFFFFF0000000000000000000000000084848400FFFFFF00FFFF0000C6C6
      C600FFFF0000C6C6C60000000000C6C6C600C6C6C600FFFFFF00FFFFFF00FFFF
      FF00C6C6C600000000000000000000000000FF000000FF000000FF000000FF00
      0000848400008484000084848400FF0000008484000084840000848484008484
      0000848400008484000084840000000000008484840084848400FFFF0000FFFF
      FF00FFFF0000C6C6C600FFFF0000000000000000000000000000FFFFFF000000
      000000000000FFFFFF00C6C6C600000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000084848400FFFF0000FFFFFF00FFFF
      0000C6C6C600FFFF000000000000C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C600000000000000000000000000FF000000FF000000FF000000FF00
      0000FFFFFF00FFFFFF0084840000FFFFFF00FFFFFF00FFFFFF0084840000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484840084848400848484008484
      840084848400FFFF0000C6C6C600000000000000FF000000FF00FFFFFF000000
      FF000000FF00FFFFFF00C6C6C600000000008484840084848400000000008484
      8400FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      0000FFFFFF00C6C6C600000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFF0000C6C6C60000000000C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C600000000000000000000000000FF000000FF000000FF000000FF00
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400008484000084840000000000008484840084848400848484008484
      840084848400C6C6C60000000000C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      000084848400FFFFFF0000FF000000FF000000FF0000FFFFFF0000FF000000FF
      000000FF0000FFFFFF0000000000000000000000000084848400FFFFFF00FFFF
      0000C6C6C60000000000C6C6C600C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C60000000000000000000000000000000000FF000000FF000000FF00
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000084848400FFFFFF00C6C6C6008484
      84008484840084848400C6C6C60000000000FFFFFF0000000000000000000000
      000000000000FFFFFF00C6C6C600000000008484840084848400848484000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000848484008484
      840000000000C6C6C600C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600C6C6C60000000000000000000000000000000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF0000FF000000FF
      000000FF000000FF000000FF000000FF0000FFFFFF0000FF000000FF000000FF
      000000FF0000FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400848484008484
      840084848400848484008484840000000000000000000000000084848400C6C6
      C600C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF0084848400000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000008400
      00000000000000000000000000000000000084848400C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C6000000000084848400C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF00000000000000FF000000FF0000000000
      00000000000000000000000000000000000084848400FFFFFF00FF000000FF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C6000000000084848400FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000008400000084000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000FF000000FF00
      00000000000000000000000000000000000084848400FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C6000000000084848400FFFFFF00FF000000FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000008400000084000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000084848400FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF00FF00
      0000FF000000FF000000FF000000FF000000FFFFFF0000000000000000000000
      000000000000FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF00000084000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FF000000FFFFFF000000FF000000FF000000FF000000
      FF000000FF00FFFFFF00C6C6C6000000000084848400FFFFFF00FF000000FF00
      0000FF000000FF000000FF000000FF0000000000FF000000FF000000FF000000
      FF000000FF00FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C6000000000084848400FFFFFF00FF000000FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000FF000000FF00000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000084848400FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      000000000000FFFFFF00C6C6C6000000000084848400FF000000FF000000FF00
      0000FF000000FFFFFF00FF000000FF000000FFFFFF0000000000000000000000
      000000000000FFFFFF00C6C6C600000000000000000000000000000000000000
      0000FF000000FF00000084000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000008400
      00000000000000000000000000000000000084848400FF000000FF000000FF00
      0000FF000000FF000000FF000000848400008484000084840000848400008484
      000084840000FFFFFF00C6C6C6000000000084848400FF000000FF000000FF00
      0000FFFFFF008484000084840000FF0000008484000084840000848400008484
      000084840000FFFFFF00C6C6C60000000000000000000000000000000000FF00
      0000FF00000000000000840000008400000000000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF00000000000000000000008400
      00000000000000000000000000000000000084848400FFFFFF00FF000000FF00
      0000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C6000000000084848400FFFFFF00FF000000FF00
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C60000000000000000000000000000000000FF00
      0000FF00000000000000840000008400000000000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF00000000000000FF000000FF000000FF0000000000
      00000000000000000000000000000000000084848400FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      000000000000FFFFFF00C6C6C6000000000084848400FFFFFF00FF000000FF00
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FFFFFF00C6C6C60000000000000000000000000000000000FF00
      0000000000000000000084000000840000000000000000000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000FF000000FF000000FF000000FF000000FF
      000000FF0000FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF00FF00
      0000FF000000FFFFFF0000FF000000FF000000FF000000FF000000FF000000FF
      000000FF0000FFFFFF00C6C6C60000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C6000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C60000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000000000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000FF000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF00000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000000000008400000000000000FF000000FF000000FF0000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF00000000000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008400000000000000FF000000FF000000FF0000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000084000000FF000000FF00000000000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000FF000000FF00000000000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000084000000FF000000FF000000FF000000FF0000000000
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000084000000FF000000FF000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000FF000000FF000000FF000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000084000000FF0000000000000000000000FF0000000000
      0000840000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000008400000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000840000008400000000000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF0000008400000000000000FF000000FF000000000000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF000000FF000000FF0000000000000000000000FF000000FF00
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000084000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000840000008400000000000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF0000008400000000000000FF000000FF000000FF0000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF000000FF000000FF0000000000000000000000FF000000FF00
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF00000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000840000008400000000000000FF000000FF000000000000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008400000084000000FF00000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      00000000000000000000FF000000FF000000840000000000000000000000FF00
      0000FF0000008400000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000084000000840000000000000000000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008400000084000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000FF000000FF00
      00008400000000000000FF000000FF0000008400000084000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000FF00000000000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000084000000840000000000000000000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000840000008400000000000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000840000000000000000000000FF000000000000008400000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF0000008400000000000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000084000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF00000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      00008400000084000000FF000000FF000000FF00000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000840000008400000000000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000008400000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF00000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000FF0000008400000000000000FF000000FF000000FF000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000008400000084000000FF000000FF00000000000000FF0000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF00000000000000FF000000FF000000FF0000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF00000084000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF00000000000000FF000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      00000000000084000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000FF00000084000000FF00000000000000FF000000FF000000FF0000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000FF00000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000FF000000FF00
      000000000000840000008400000000000000FF000000FF00000000000000FF00
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000FF0000008400000000000000FF000000FF00000000000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF00000000000000FF000000FF000000FF0000008400
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF0000008400000000000000FF000000FF000000FF000000FF000000FF00
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF00000000000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF00000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF00000000000000FF000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF00000000000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF00000000000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000FF000000FF000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000008400
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF0000008400000000000000FF000000FF0000008400
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF0000000000000000000000FF000000FF0000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000FF000000FF000000FF000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      00008400000000000000FF000000FF00000000000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF0000008400000000000000FF000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF00000000000000FF000000FF000000FF0000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      000084000000FF000000FF000000FF00000000000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF0000008400000000000000FF000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF00000084000000FF000000FF000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF0000000000000000000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF00000000000000FF000000FF000000840000008400
      0000000000000000000000000000000000000000000000000000FF000000FF00
      00000000000084000000FF000000FF000000FF000000FF000000FF000000FF00
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000084000000FF000000FF000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF00000000000000FF000000FF000000840000008400
      0000000000000000000000000000000000000000000000000000FF000000FF00
      000000000000840000008400000000000000FF000000FF00000000000000FF00
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000000000008400000000000000FF000000FF000000000000000000
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF0000000000000000000000FF000000FF000000840000008400
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF0000008400000000000000FF000000FF000000FF000000FF000000FF00
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF00000000000000840000000000000000000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF0000008400000000000000FF00000000000000FF0000008400
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF00000000000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF00000084000000840000000000000000000000FF000000FF000000FF00
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008400000084000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF00000000000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000008400000084000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      00000000000084000000840000008400000000000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000084000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF00000000000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000000000000FF000000FF00000000000000840000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF00000000000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000FF000000FF000000FF000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000008400000000000000FF000000FF00000084000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF0000008400000000000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000084000000FF000000FF0000000000000084000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF0000008400000000000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF0000008400000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000000000000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000008400000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF00000000000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF00000000000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000084000000FF000000FF000000FF00000000000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000840000008400000000000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      00000000000084000000840000000000000000000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF00000000000000FF000000FF0000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF00000084000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000000000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF00000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF0000008400000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF00000000000000FF000000FF000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008400000000000000FF000000FF000000000000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF0000008400000000000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008400000000000000FF000000FF000000000000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF00000000000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF00000000000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000000000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF00000000000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF00000084000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000008400000000000000FF000000FF0000000000000000000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000084000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF0000008400000000000000FF000000FF0000008400
      0000000000000000000000000000000000000000000000000000FF000000FF00
      000000000000840000008400000000000000FF000000FF000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000000000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF0000008400000000000000FF000000FF000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000008400
      0000840000000000000000000000000000000000000000000000FF000000FF00
      0000000000008400000084000000FF000000FF000000FF000000FF0000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000000000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF00000000000000FF000000FF000000FF00
      0000840000000000000000000000000000000000000000000000FF000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000FF000000FF00000000000000FF0000000000
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF00000000000000FF000000FF000000FF0000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008400000084000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000840000008400000000000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000FF0000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000000000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF00000000000000FF00000000000000FF000000FF00
      0000840000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000000000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF00000000000000FF000000FF0000008400
      0000840000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF00000000000000FF000000FF000000840000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF00000000000000FF000000FF000000FF00
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000FF00000000000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF00000000000000FF000000FF000000840000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000084000000FF000000FF000000FF0000000000000000000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008400000084000000FF000000FF000000000000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000FF000000FF00000000000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000008400000084000000FF00000000000000FF000000000000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008400000000000000FF000000FF00000000000000FF00
      0000840000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000084000000FF000000FF00000000000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF00000000000000FF000000FF000000FF0000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000840000008400000084000000FF000000FF000000FF0000008400
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000084000000840000008400
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000FF000000FF00000000000000FF000000FF00
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000084000000FF000000FF000000FF000000FF000000FF00
      000084000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF00000000000000FF000000FF000000FF00
      0000FF000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF00000000000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF00000000000000FF00000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000FF000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000E00000000100010000000000000700000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFF03FFFFFFFFFFF3FC007FC3FFE7F
      FF0F8003FC3FFC3FFF030003FC3FF81FFC000001FC3FF00FEC000001FC3FE007
      CC000001FC3FC00380000003FC3FFC3F00000007FC3FFC3F00008007C003FC3F
      8000E003E007FC3FCC00FF81F00FFC3FEC00FFC0F81FFC3FFC00FFE0FC3FFC3F
      FC00FFF0FE7FFC3FFC00FFF9FFFFFFFF0000FFFFFFFF00000000FFFFE0010000
      0000FFFFE00000000000FFFFE00000000000F00F800100000000F00F80010000
      0000F00F800100000000F00F000100000000F00F000100000000F00F00010000
      0000F00F000700000000F00F000700000000FFFF000700000000FFFF000F0000
      E0FFFFFF000F0000FFFFFFFF000F0000FFFFF83FFFFFFFCFFE07C00FFFFFFF07
      8207800FF9FFFC03FE07000FF0FFF001E207000FF0FFC000FE07A00FE07F8000
      C007C00FC07F8000C00F801F843F8000419F833F1E3F8001C1088211FE1F8003
      41088211FF1F0007E398C731FF8F001F23F8C7F1FFC7C27FE308C7F1FFE3C3FF
      23F8C7F1FFF8C3FFFF88FFF1FFFFFFFF0000FFFFFFFFC3FF00000000FC0FC20F
      00000000FC0F000F00000000FC0F000F00000000FC0F000F00000000FC0F000F
      00000000800FC20F00000000801F801F00000000833F833F0000000082118211
      000000008211821100000000C731C73100000000C7F1C7F100000000C7F1C7F1
      803F0000C7F1C7F1E0FFFFFFFFF1FFF1FFFFFFFF003F8003FFFFFFFF00078003
      80008001000780038000000000078003800000000007800380000000003F8003
      8000000000078003800000000007800380000000000380038000000000018003
      8000000000018003800000000001800380000000F8018003FFFF8001FC018003
      FFFFFFFFFE038003FFFFFFFFFF078003FFFFFFCFFFFFFFCF00FF0000FFFFFF87
      80000000FFFFC00380000000FFFFC00380000000C007C003800000004007C003
      80000000C0038003800000002003000300000000E00300030000000020010003
      00000000F0018003800000001001C00380000000F801C003C7FF0000FFFFC007
      E3FF0000FFFFC00FF9FFFFFFFFFFC01FFFFFFFDFFFFFFFFFFC7FFF0F00000000
      F83FFC0700000000F83FF00700000000F83FE00700000000F83FE01F00000000
      F83FE07F00000000F03FF03F00000000F01FF81F00000000E00FFC0F00000000
      E007F80700000000E007E00700000000C08FE00700000000C0FFE01F00000000
      C1FFE07F00000000E3FFF1FFFFFFFFFFFFFFFFFFFF9FFFDFFC3FFC7FFE0FFF0F
      F01FF03FFA0FFE07E00FF01FE007F207E007F01FE007C00FC007F01FE007C00F
      C007F00FC007E01FC107E00FC003F01FC107E00FC003F83FC107E007C003F01F
      C107E007C003F00FC107C087C027E007C18FC0DF803FE00FC1FFC0FF827FC0BF
      E1FFE1FF83FFC1FFF7FFF7FFC7FFE3FFFFBFFF9FFFFFFFFFFF9FFE0FFC3FFC7F
      FE0FFE07F81FF83FF807E207F00FF83FF007C007E00FF83FE007C007E007F83F
      C007C00FE007F83FC007C00FE00FF81FC007C00FE00FF80FC007C00FE007F807
      C007C00FE007E007C007C00FE00FE007C00FC01FE00FE00FE00FC03FF01FE03F
      F01FE07FF87FF0FFF87FF1FFFFFFFBFFFFDFFFDFFFFFFFFFFF0FFF0FFE7FFFFF
      FC07FE07F81FF1FFF007E207F00FE03FC007C007E007E01FC007C007C007E00F
      C007C007C007E00FC007C007C007E007C007C007C007E007C007C007C007E007
      C007C007C007E00FC007C007C00FE00FC08FC007E00FE01FC1FFC0DFF01FE07F
      C1FFE0FFF87FF1FFE3FFF3FFFFFFFFFFFFFFFFFFFFDFFF3FFEFFFE7FFF0FFC1F
      F87FF83FFE07F00FF83FF01FF207E00FF81FF00FC007E00FF81FE00FC00FE03F
      F81FE00FC00FE0FFF81FE00FC01FE0FFF81FE00FC01FE0FFF81FF00FC03FE0FF
      F81FFA0FC01FE0FFF81FFE0FC00FE0FFF81FFF0FC10FE0FFFC3FFF9FC1BFE0FF
      FEFFFFFFE1FFE0FFFFFFFFFFF3FFF1FFFF9FFFFFFF9FFFDFFE0FFDFFFF0FFF0F
      F807F0FFF807FF07E007F05FF007F307E007F00FE007E107E00FF007E007E007
      E00FF007C007E007E00FF007C007E007E00FF007C00FE007E00FF003C007E007
      E007F003C007E007E007F003C00FE007E007F00FC00FE087E01FF03FE01FE0DF
      E07FF8FFF03FE0FFF1FFFFFFF8FFF1FFFFCFFE3FFFFFFE3FFF07F81FFE3FF81F
      FF03E00FF81FE00FF603C007F00FC007C003C007E007C007C007C007E007C003
      C007C007E007C003E007C00FC00FC003E007C007C007C003E00FC007C007C007
      F00FC007C007C007F00FC007E007C007F81FC00FE00FC00FF81FC01FF01FC01F
      FC1FE07FF83FE07FFE7FF1FFFFFFF1FF00000000000000000000000000000000
      000000000000}
  end
  object RefreshTimer: TTimer
    Enabled = False
    Left = 200
    Top = 240
  end
  object RefreshBin: TTimer
    Enabled = False
    OnTimer = RefreshBinTimer
    Left = 144
    Top = 48
  end
  object TimerJobMsg: TTimer
    Enabled = False
    OnTimer = TimerJobMsgTimer
    Left = 197
    Top = 48
  end
  object BinIcons: TImageList
    Left = 552
    Top = 192
    Bitmap = {
      494C010120007800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000009000000001002000000000000090
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FAFEFF00FAFDFF00FFFFFE00FFFE
      FF00FFFDFF00FFFDF300EDD39D00FADC9B00FFFFDF00FFFFED00FFFCFD00FFFC
      FF00FFFBFF00FDFFFF00F7FDFC00F8FFFE00856C5EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF856C5EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000077777700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCFDFF00FFFEFF00FFFFFE00FFFF
      FF00FDFDFF00FFFFF300DFC18A00D0AD6D00C6AB7F00FFFFE800FFFEFE00FFFB
      FF00FFFDFF00FEFEFE00FBFFFE00F8FFFA006C4E3EFF715344FF8F786CFF8F78
      6CFF856C5EFF6C4E3EFF7A5F51FF8F786CFF8F786CFF7A5F51FF6C4E3EFF856C
      5EFF8F786CFF8F786CFF715344FF6C4E3EFF000000000000000000000000FFCC
      CC00FFCCCC00FFCCCC000000000000000000CC999900CC999900000000007777
      770077777700000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000FF00000000000000FFFFFE00FFFFFE00FFFFFE00FCFC
      FC00F9FDFE00FFFFF200EBC68E00D4AA6700B0996900FFFFEB00FFFBFE00FFF9
      FF00FFFDFF00FFFDFA00FFFFFB00FBFFF9006C4E3EFF7E6355FFFFFFFFFFFFFF
      FFFFD4CBC7FF6C4E3EFFA9978EFFFFFFFFFFFFFFFFFFA9978EFF6C4E3EFFD4CB
      C7FFFFFFFFFFFFFFFFFF7E6355FF6C4E3EFF00000000CC999900CC999900FFCC
      CC00FFCCCC00FFCCCC000000000000000000CC999900CC999900CC999900CC99
      990077777700777777000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C000C0C0C0008080800000000000FFFFFC00FFFEFD00FFFFFF00FFFE
      FF00FCFEFE00FFFFF000ECC68C00D7AC6900B8A06C00FFFFEA00FFFBFC00FFFB
      FF00FFFDFF00FFFCF900FCFEF800FDFFFB006C4E3EFF7E6355FFFFFFFFFFFFFF
      FFFFD4CBC7FF6C4E3EFFA9978EFFFFFFFFFFFFFFFFFFA9978EFF6C4E3EFFD4CB
      C7FFFFFFFFFFFFFFFFFF7E6355FF6C4E3EFFCC999900CC999900CC9999000000
      0000000000000000000000000000000000000000000000000000CC999900CC99
      9900CC999900777777000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C000808080008080800000000000FFFFFE00FDFDFD00FFFEFF00FFFE
      FF00FFFFFE00FFFFEE00E6C38B00D1A76400B69A6400FFFFE300FFFFFB00FDFD
      FF00FFFCFE00FFFEFF00FCFCFC00FBFFFF006C4E3EFF7E6355FFFFFFFFFFFFFF
      FFFFD4CBC7FF6C4E3EFFA9978EFFFFFFFFFFFFFFFFFFA9978EFF6C4E3EFFD4CB
      C7FFFFFFFFFFFFFFFFFF7E6355FF6C4E3EFFCC99990000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CC9999007777770077777700000000000000000080800000C0C0C000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008080800080808000C0C0C00000000000FBFFFF00FDFFFF00FFFDFF00FFFC
      FE00FFFFFE00FFFFED00ECC88C00D6AD6800BD9E6900FFFFE700FFFFF900F8FB
      FF00FFFDFE00FFFEFF00FCFEFF00FAFDFF006C4E3EFF7E6355FFFFFFFFFFFFFF
      FFFFD4CBC7FF6C4E3EFFA9978EFFFFFFFFFFFFFFFFFFA9978EFF6C4E3EFFD4CB
      C7FFFFFFFFFFFFFFFFFF7E6355FF6C4E3EFF000000000000000000000000FF99
      9900FF999900FF999900FF999900FF999900FF999900FF999900000000000000
      0000000000007777770077777700000000000000000080800000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF008080
      800080808000C0C0C000FF00000000000000F7FCFF00FDFFFF00FFFDFF00FFFE
      FF00FFFFFC00FFFFE800EAC37E00D8AC5F00B9996800FFFFE900FFFFF900FDFF
      FF00FFFFFE00FFFEFD00FBFDFE00FAFFFF006C4E3EFF7E6355FFFFFFFFFFFFFF
      FFFFD4CBC7FF6C4E3EFFA9978EFFFFFFFFFFFFFFFFFFA9978EFF6C4E3EFFD4CB
      C7FFFFFFFFFFFFFFFFFF7E6355FF6C4E3EFF0000000000000000FF999900FF99
      9900FF999900FF999900FF999900FF999900FF999900FF999900996666000000
      0000000000007777770077777700000000000000000080800000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C0C0C000FFFFFF00FF00000000000000FBFEFF00FFFEFF00FFFDFD00FFFF
      F800FFFFF200FFFFDC00F0C47700E4B25F00C6A06600FFFBD700FFFFF200FFFF
      FB00FFFDFA00FFFFFE00FFFFFF00FAFFFF006C4E3EFF7E6355FFFFFFFFFFFFFF
      FFFFD4CBC7FF6C4E3EFFA9978EFFFFFFFFFFFFFFFFFFA9978EFF6C4E3EFFD4CB
      C7FFFFFFFFFFFFFFFFFF7E6355FF6C4E3EFF0000000000000000CC999900FF99
      99000000000099666600996666009966660099666600FF999900CC9999000000
      000000000000777777000000000000000000C0C0C00080800000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FF00000000000000FCFBFF00FFFEFF00FFFCF900FFFF
      F000FFFFD200E9C78500EAB46100EDB35A00E6B16100D4AB6D00FFEFCF00FFFF
      F400FFFEFC00FFFFFE00FDFEFA00FBFFFB006C4E3EFF7E6355FFFFFFFFFFFFFF
      FFFFD4CBC7FF6C4E3EFFA9978EFFFFFFFFFFFFFFFFFFA9978EFF6C4E3EFFD4CB
      C7FFFFFFFFFFFFFFFFFF7E6355FF6C4E3EFF000000000000000000000000CC99
      9900CC999900CC999900CC999900CC999900CC999900CC999900000000000000
      000000000000000000000000000000000000FFFFFF0080800000FFFFFF008080
      000080800000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080800000FF00000000000000FDFDFF00FFFBFC00FFFFF500FFFF
      DC00DDBA7B00E1B26100F1B66000F3B45800F3B65900E8B36300D1A77200FFEB
      CC00FFFFF400FFFFFC00FFFFF700FFFFF8006C4E3EFF7E6355FFFFFFFFFFFFFF
      FFFFD4CBC7FF6C4E3EFFA9978EFFFFFFFFFFFFFFFFFFA9978EFF6C4E3EFFD4CB
      C7FFFFFFFFFFFFFFFFFF7E6355FF6C4E3EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000077777700000000000000000000000000FFFFFF0080800000FFFFFF008080
      000080800000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080800000FF00000000000000FCFCFC00FFFFF700FFFCDE00E1BA
      8600E4B26A00EDB45F00F6B75F00F2B35900F5B75900F0B45A00EBB36200DAAE
      7100FFEDD100FFFFF700FFFDF600FFFFF9006C4E3EFF725546FFA08D83FFA08D
      83FF917A6EFF6C4E3EFF82685BFFA08D83FFA08D83FF82685BFF6C4E3EFF917A
      6EFFA08D83FFA08D83FF725546FF6C4E3EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C00000000000777777000000000000000000FFFFFF0080800000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFF700FFFFEB00E0BF9200DCAD
      7000E8B06900E9AF6300E8AF6000E8B05F00EAB26000EAB15C00EFB66000E0B1
      6700D7B98A00FFF8DE00FFFFF800FFFFFE006C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000000000007777770000000000FFFFFF0080800000808000008080
      00008080000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00080800000000000000000000000000000FFFFEA00CAB79100BD965F00C998
      5A00C9975D00C6955D00C0945900C1985A00BE955700C4995A00C1975000C59D
      5500C69E5D00D6B88900FFFEF200FFFCFF006C4E3EFF7A5E50FFDDD6D2FFDDD6
      D2FFBCAEA7FF6C4E3EFF9B867BFFDDD6D2FFDDD6D2FF9B867BFF6C4E3EFFBCAE
      A7FFDDD6D2FFDDD6D2FF795E4FFF6C4E3EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007777
      770011111100000000000000000077777700FFFFFF0080800000808000008080
      0000808000008080000000000000C0C0C000C0C0C000C0C0C000000000008080
      000080800000000000000000000000000000FFFFE500AC986F00C8A46E00E0B5
      7C00E2B88900E5C09400EDCC9F00E7C99A00EACB9E00E4C49300E0C18A00DAB8
      7C00C6A26200B2946300FFFCF000FFFEFF006C4E3EFF7E6355FFFFFFFFFFFFFF
      FFFFD4CBC7FF6C4E3EFFA9978EFFFFFFFFFFFFFFFFFFA9978EFF6C4E3EFFD4CB
      C7FFFFFFFFFFFFFFFFFF7E6355FF6C4E3EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000077777700111111000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00
      000000000000000000000000000000000000FFFFEE00C1AF9200F5DFB500FFF2
      C400FFF2CA00FFF1CD00FFEFCD00FFF0CC00FFEDC800FFF4CC00FFEFCC00FFEB
      C600F9E0B800C7B89800FEFAEF00FAFDFB006C4E3EFF6E5141FF7E6355FF7E63
      55FF795D4EFF6C4E3EFF735748FF7E6355FF7E6355FF735748FF6C4E3EFF795D
      4EFF7E6355FF7E6355FF6E5141FF6C4E3EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007777770011111100000000008080000080800000808000008080
      000080800000808000008080000080800000808000008080000080800000FF00
      000000000000000000000000000000000000FFFFF100F7E7D000CFBF9B00BBAA
      8300BBA98400BEAB8A00BBA68A00C4B09100C6B08D00C1AB8800C5AD9100C8B1
      9700D0BFA400EBE4CB00FFFFF800FBFFFC00937C70FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF937C70FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080000080800000808000008080
      000080800000808000008080000080800000808000008080000080800000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFDFF00FFFDFE00FFFFFF00FBFE
      FC00FBFFFE00FDFFFF00FFFCFF00FFF8FF00FFF9FF00FFFCFF00FFFAFF00FFFA
      FF00FFFCFE00FDFFFE00FAFFFC00F8FFFC0080808000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      000000000000000000000000000000000000FFFDFE00FFFEFF00FFFEFF00FEFE
      FE00FDFFFE00FDFFFF00FFFDFF00FFFDFF00827C7D00FFFDFE00FFFBFF00FFFD
      FF00FFFFFF00FDFFFE00FBFFFE00F9FEFC0080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C0000000000080808000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C0000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      000000000000000000000000000000000000FBFFFE00FDFFFF00FFFDFF00FFFD
      FF00FEFCFC00FBFCFA00FEFFFB00FFFFFA0044423A00FFFFFB00FFFAF700FFFF
      FE00FFFFFC00FEFFFD00FFFFFF00FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C0000000000080808000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000808000000000
      000000000000000000000000000000000000FAFFFB00ECF1F200E8E5F400EDE8
      FD00EAE8FC00EAE8FB00E8EAF500E8EBF0003D3B3B00EBE9E900F2EEF900EAE7
      F600E7E7F500EBE8F700EEEAF600F0EAF50080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00C0C0C000000000008080800000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000008080000080800000808080008080
      000080800000808000008080000000000000FBFEF500BDC0C500999BBD009293
      C500938FCA009692CD009394C6009798BE003A324900A299B3009A96C0009591
      C5009993C8009F97C6009B95B8009D98B50080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF00C0C0C0000000FF00C0C0
      C0000000FF00FFFFFF00C0C0C00000000000808080000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000808000000000
      000000000000000000000000000000000000FFFFF900BBBABE00A2A4C3009D9C
      CE009B95CE009B98D000999BCB00A09FC600392E4800ACA0BC009F9CCA009F9C
      D3009D97CE00A49CCB00A9A1C600ABA3C20080808000FFFFFF00FFFFFF00FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000000000008080800000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000FF000000FF000000FF000000
      FF000000FF0000000000C0C0C0000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000008080000080800000808080008080
      000080800000808000008080000000000000FFFBF700C8BEBE00DFD5E100ECE2
      F300EAE1F500E7E2F100E2E3ED00E7E4ED0044394300ECDFED00E5E1F400DFDE
      F200E1DFF200EAE4F500E7DCEC00B8ABB90080808000FFFFFF00FF000000FF00
      0000FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FFFFFF00C0C0C000000000008080800000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      00000000000000000000C0C0C0000000000000000000FF000000FF000000FF00
      0000FF00000000000000FF000000FF0000000000000000000000808000000000
      000000000000000000000000000000000000FFFFF900CABBB800EBDBDC00F3E5
      E600EDE7E200E6EAE400DAECE500D9EAE600373B3C00E6E9EE00D8E8EF00D0E7
      EF00D3ECF000D3E7E800DFE8EB00AEB2B30080808000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF00000080800000C0C0
      C00080800000FFFFFF00C0C0C0000000000080808000FF000000FF000000FF00
      0000FF00000000000000FF000000FF0000000000000000000000000000000000
      00000000000000000000C0C0C00000000000FF000000FF000000FF000000FF00
      0000808000008080000080808000FF0000008080000080800000808080008080
      000080800000808000008080000000000000FFFEF7009C8C8500634F4A004C3E
      38003F433800829D9300A2D9D6009DD6D7001B3F3F00AFD3D9009BD2E1008CD1
      E20090D8E0009ADBDC00A3D5D10094BEB70080808000FF000000FF000000FF00
      0000FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C0000000000080808000FF000000FF000000FF00
      0000000000008080000080800000FF0000008080000080800000808000008080
      00008080000000000000C0C0C00000000000FF000000FF000000FF000000FF00
      0000000000000000000080800000000000000000000000000000808000000000
      000000000000000000000000000000000000E3D1C6005C494100604A44006154
      4C008A8B8100E5FDF300669795008AC0C100183C3C0097BCC00086BDCC0080C3
      D2007AC0C7007DBFBE008DC3BC0082B1A80080808000FF000000FF000000FF00
      0000FF000000FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF00
      0000FF000000FFFFFF00C0C0C000000000008080800000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C00000000000FF000000FF000000FF000000FF00
      0000808000008080000080800000808000008080000080800000808000008080
      0000808000008080000080800000000000008A6F6100654C420097837E00C8B9
      B600FFFFFB0098948F0042454300F4F9F8003F3F3F00F5F8FC00EEFDFF00E1F4
      F700E8FDFB00E8FEF900E9FDF800E9FEF60080808000FF000000FF000000FF00
      0000FF000000FF000000FFFFFF00FFFFFF00FF000000FF00000000FF0000C0C0
      C00000FF0000FFFFFF00C0C0C000000000008080800000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C0000000000000000000FF000000FF000000FF00
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000073594B006C544800B7A49D00D1BE
      B900D4BEB800634D47004E3A3500FFFEFB004A3D3B00FFFCFC00FFFEFD00FFFE
      FD00FFFEFB00FFFFFA00FDFFFC00F9FFFB0080808000FF000000FF000000FFFF
      FF00FFFFFF00FF000000FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C00000000000808080000000000000000000FF00
      0000FF0000000000000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000000000C0C0C0000000000000000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000807168005E4C4100674E4400C5A9
      9E009F7E6F006A4D3F006A575000FFFFFB004C433A00FFFEF700FFFDFE00FFFE
      FF00FFFFFE00FFFFFC00FBFFFE00F5FEFB008080800080808000FF000000FF00
      0000FFFFFF00FFFFFF00FFFFFF00FF000000FF00000080808000808080008080
      8000808080008080800080808000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D4CEC700594E4600644D4500664A
      3F006D4F3E00694F4100C3B5AF00FFFEFB0042403800FFFFFB00FFFEFF00FDF8
      FA00FFFEFF00FFFFFE00F7FCFB00F8FFFF00FFFFFF00FFFFFF00FFFFFF00FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800080808000808080008080800000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFBFA00D4CFCC007E6F6C006957
      500082736A00D6CBC300FFFFFE00FAFCFC00A0A5A400FCFEFE00FFFEFF00FFFD
      FE00FFFFFE00FFFEFD00FDFCFF00FDFDFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFFFF00FFFFFE00FFFDFD00FFFE
      FA00FFFFF900FFFFFA00FCFEFE00F8FFFF00F8FFFF00F7FCFD00FFFEFF00FFFE
      FF00FFFFFE00FFFEFD00FFFDFF00FFFAFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EEECEB17AAA19D710000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DED6D37BB4A7
      9EFFB5A89FFFB5A89FFFB2A49BFFFDFDFD060000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFF00000000000000000000000000000000000000000000
      00000000000000000000E0DDDA2A64554DCF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F9F8F809CBC5C246C8C2BE4BC1B8B1A1D7D0
      CAFFEBE8E4FFEBE8E4FFB5A89FFFFDFDFD0680808000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000000000000000000000000000000000B2A4
      9BFF5252EBFF5252EBFF5252EBFF5252EBFF5252EBFF5252EBFF5252EBFF5252
      EBFF5252EBFFB2A49BFF00000000000000000000000000000000ECE7E547B2A4
      9BFFB2A49BFFB2A49BFF9F9087FF56433AFFB2A49BFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFECE7E54700000000000000000000000000000000000000000000
      00000000000000000000000000006A5B54C78C7F799B8F847E96A4968FC8DCBB
      C0FFEDC5D0FFEDC5D0FFB7A69EFFFDFDFD0680808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C00000000000000000000000000000000000B2A4
      9BFFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8
      E4FFEBE8E4FFB2A49BFF00000000000000000000000000000000ECE7E547908C
      D5FF5252EBFF5252EBFF4F4CCAFF443449FF5252EBFF5252EBFF5252EBFF5252
      EBFF908CD5FFECE7E54700000000000000000000000000000000000000000000
      00000000000000000000FAFAF8075D4C42DA0000000000000000DED6D37BDF89
      A3FFEB779FFFEB779FFFBAA09CFFFDFDFD0680808000FFFFFF00000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C00000000000000000000000000000000000B2A4
      9BFF00CFF0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF00CF
      F0FF00CFF0FFB2A49BFF00000000000000000000000000000000ECE7E547CFC6
      BFFFEBE8E4FFEBE8E4FFCFC9C4FF615047FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8
      E4FFCFC6BFFFECE7E54700000000000000000000000000000000000000000000
      00000000000000000000FAFAF8075D4C42DA0000000000000000ECE8E645D0C8
      C19FD0C8C19FD0C8C19FD0C8C19FFFFEFE0380808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00C0C0C00000000000000000000000000000000000B2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFF00000000000000000000000000000000ECE7E54767CB
      D7FF00CFF0FF00CFF0FF0BB4CEFF354B4AFF00CFF0FF00CFF0FF00CFF0FF00CF
      F0FF67CBD7FFECE7E547000000000000000000000000E8E6E29DE5E2DCBCE5E2
      DCBCE5E2DCBCEFEFEA6BFAFAF8075D4C42DA0000000000000000F8F8F713F2EF
      EE30F2EFEE30F2EFEE30F2EFEE30FFFFFF0180808000FFFFFF00FFFFFF00FF00
      0000FF000000FF000000FF000000FF0000000000FF00C0C0C0000000FF00C0C0
      C0000000FF00FFFFFF00C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000ECE7E547B2A4
      9BFFB2A49BFFB2A49BFF9F9087FF56433AFFB2A49BFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFECE7E547000000000000000000000000DFDBD4E9DBD7CFFFDBD7
      CFFFDBD7CFFFE7E5DFA5FAFAF8075D4C42DA0000000000000000DED6D37BC1B6
      AEFFC9C0B9FFC9C0B9FFB3A69DFFFDFDFD0680808000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C0000000000000000000F8F7F51800000000C7BD
      B5BBC7BDB5BBFFFFFF01F8F7F5180000000000000000B2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFF0000000000000000000000000000
      00000000000000000000E0DDDA2A64554DCF0000000000000000000000000000
      00000000000000000000000000000000000000000000DFDBD4E9DBD7CFFFDBD7
      CFFFDBD7CFFFC0BAB3D958453CE1443127FA58453CE158453CE187776EEFD7D0
      CAFFEBE8E4FFEBE8E4FFB5A89FFFFDFDFD0680808000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FFFFFF00C0C0C00000000000F8F6F519B7AAA0F0C9BEB9B4B5A8
      A1F2B5A8A1F2C9BEB9B4B7AAA0F0F8F7F51800000000B2A49BFFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFB2A49BFF00000000C5BBB75D705B4EDD583F
      34F9574439EE9F928D8AE0DDDA2A64554DCFECE7E547B2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFECE7E54700000000DFDBD4E9DBD7CFFFDBD7
      CFFFDBD7CFFFE7E5DFA5FAFAF8075D4C42DA0000000000000000DED6D37B7ED0
      D9FF60D9EBFF60D9EBFFA8AAA4FFFDFDFD06FF000000FF000000FF000000FF00
      0000FFFFFF00FF000000FF000000FF000000FF000000FF000000FF000000C0C0
      C00080800000FFFFFF00C0C0C0000000000000000000C9BEB9B4BAACA5E7E3DE
      DA5CE5DFDD59BBADA5E3C9BEB9B40000000000000000B2A49BFFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFB2A49BFFD4CAC74B6C4D3EFF6C4E3EFF9B86
      7CFF6B4E3DFF523A2EFF92837D9D64554DCFECE7E547CFC6BFFFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFCFC6BFFFECE7E54700000000EAE9E58FE7E3DFADE7E3
      DFADE7E3DFADF2F0ED61FAFAF8075D4C42DA0000000000000000DED6D37B8EB9
      BAFF7EC1C7FF7EC1C7FFABA79FFFFDFDFD06FF000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00C0C0C00000000000C7BDB5BBB5A8A1F2E1DCD8637869
      62B5786A63B4E5DFDD59B5A8A1F2C7BDB5BB00000000B2A49BFFB07821FFB078
      21FFB07821FFB07821FFB07821FFB2A49BFF897266CB6C4E3EFF6C4E3EFFCFC6
      C0FF6C4E3EFF6B4E3DFF554136F164554DCFECE7E547CFC6BFFFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFCFC6BFFFECE7E5470000000000000000000000000000
      00000000000000000000FAFAF8075D4C42DA0000000000000000F8F8F713F2EE
      EE2EF2EEEE2EF2EEEE2EF2EEEE2EFFFFFF01FF000000FF000000FF000000FFFF
      FF00FF000000FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF00
      0000FF000000FFFFFF00C0C0C00000000000C7BDB5BBB5A8A1F2E1DBD7667869
      62B5786962B5E2DEDA5DB5A8A1F2C7BDB5BB00000000B2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFF725748F3B1A198FFCFC6C0FFF0EC
      EBFFCFC6C0FF9B867CFF573E34FA64554DCFECE7E547BF9F70FFB07821FFB078
      21FFB07821FFB07821FFBF9F70FFECE7E5470000000000000000000000000000
      00000000000000000000FBFBFA065D4C42DA0000000000000000E6E2DE58C4BA
      B3C3C4BAB3C3C4BAB3C3C4BAB3C3FDFDFD04FF000000FF000000FF000000FF00
      0000FF000000FF000000FFFFFF00FFFFFF00FF000000FF000000FF000000C0C0
      C00000FF0000FFFFFF00C0C0C0000000000000000000C9BEB9B4B8ACA2EBE1DB
      D766E1DCD863BAACA5E7C9BEB9B4000000000000000000000000000000000000
      000000000000000000000000000000000000897266CB6C4E3EFF6C4E3EFFCFC6
      C0FF6C4E3EFF6C4E3EFF6B5449E364554DCFECE7E547B2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFECE7E5470000000000000000000000000000
      000000000000000000000000000075655FBA7B6D66B17E7169AD9C8D85D4CFC5
      BFFFDDD8D3FFDDD8D3FFB5A79EFFFDFDFD06FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FFFFFF00FF000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00C0C0C00000000000F8F6F519B7A8A1F1C9BEB9B4B5A8
      A1F2B5A8A1F2C9BEB9B4B7AAA0F0F8F7F5180000000000000000000000000000
      000000000000000000000000000000000000D4CAC74B6C4E3EFF6C4E3EFFB1A1
      98FF6C4E3EFF6C4D3EFFB2A59F7764554DCF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFE02DBD8D530D9D4D234CAC2BC95D7D0
      CAFFEBE8E4FFEBE8E4FFB5A89FFFFDFDFD0680808000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000808080008080
      80008080800080808000808080000000000000000000F8F7F51800000000C7BD
      B5BBC7BDB5BB00000000F8F7F518000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D4CAC74B897266CB7257
      48F3897266CBD4CAC74BF2F1F012BAB3AF5D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DED6D37BBC95
      59FFB37E2DFFB37E2DFFB5A291FFFDFDFD06FFFFFF00FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E0D9D572B7AA
      A0F0B7AAA0F0B7AAA0F0B7AAA0F0FEFEFE05FFFFFF00FFFFFF00FFFFFF00FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80736CFFC6C0BDFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FDFE00FFFFEC00FBD19000EAB4
      5D00E8B36200E5B36700DEAF6B00DFB36C00DAB46200E0B76200E7B66600E5B1
      6500E2AF6600DCB37500FDDFBC00FFFFEB00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      00000000000000000000EEECEB17AAA19D710000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFF00CFF0FF00CFF0FF00CF
      F0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF2C6367FF149EB2FF00CF
      F0FFE1FAFEFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFF00FFFFF000DBB37800F8C7
      7B00F5CF8F00F2D09A00ECC99700E9C99400EDCE8F00EBCB8900F2CD9100F6CE
      9400FBCF9200DFB78200E7CBA800FFFFE600FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      00000000000000000000E0DDDA2A64554DCF0000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFF6BE4F7FF6BE4F7FF6BE4
      F7FF6BE4F7FF6BE4F7FF6BE4F7FF6BE4F7FF6BE4F7FF506A6AFF5FADB7FF6BE4
      F7FFEEFCFEFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFD00FFFFEE00D1AD7D00FFE9
      B400FFF7DC00F5F4E600FFFAED00FFF7E700FFFDE300FFFADE00FFF8E500FFF8
      E100FFF9D600EAC9A200DFC6A400FFFFE700E1DED7FFDFDBD4FFDFDBD4FFDFDB
      D4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDCD5FFF9F8F7FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000ECE7E547B2A4
      9BFFB2A49BFFB2A49BFF9F9087FF56433AFFB2A49BFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFECE7E5470000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFFFFC7C7F9FF6D606AFF9F99B9FFC7C7
      F9FFF7F7FEFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFF00FFFFF400CBAA7D00FFE5
      B900F2F6EB00C4D4DA00E7F1F800EFF3F400F5F1EC00FBF5EE00F4F2F100FBF3
      EC00FFFAE400E4C8A900D9C6A500FFFFE600DEDAD3FFDBD7CFFFDBD7CFFFDBD7
      CFFFDBD7CFFFDBD7CFFFDBD7CFFFDBD7CFFFDCD8D0FFF8F7F6FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000ECE7E547908C
      D5FF5252EBFF5252EBFF4F4CCAFF443449FF5252EBFF5252EBFF5252EBFF5252
      EBFF908CD5FFECE7E5470000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1FEFF5252EBFF473A65FF4D47AFFF5252
      EBFFE2E2FCFFFFFFFFFFFFFFFFFFFFFFFFFFF8FFFF00FFFEF100CBAD7E00FEE4
      B500F3F7EB00C5D9DE00AEC1C800E5F1F500ABACAA00A5A09D00A49F9C00D4CB
      C100FFF7DD00DFCCAB00D8C9A900FFFFE500FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000ECE7E547CFC6
      BFFFEBE8E4FFEBE8E4FFCFC9C4FF615047FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8
      E4FFCFC6BFFFECE7E5470000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFFFFD4D4FAFF71646AFFA8A2BAFFD4D4
      FAFFF9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFF6FCFF00FFFFF500CEB07F00FCE3
      B100F3FAED00C0D6DC00D8F1F500DDF0F300ECF1EF00FBF6F300F3EFEA00FEF5
      EB00FFFBE100D6C7A700D9CCAC00FFFFE800E1DED7FFDFDBD4FFDFDBD4FFDFDB
      D4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDCD5FFF9F8F7FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000ECE7E54767CB
      D7FF00CFF0FF00CFF0FF0BB4CEFF354B4AFF00CFF0FF00CFF0FF00CFF0FF00CF
      F0FF67CBD7FFECE7E5470000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFCEACEFFF8D59DFFF8D59DFFF8D59DFF7E654CFFC1A378FFF8D5
      9DFFF8D59DFFF8D59DFFF8D59DFFF8D59DFFFAFFFF00FFFFF400CDAE7B00FFE8
      B600EEF4E900C4DCE200A9C5C500E1F7F200A7ABA500A29F9700A3A09B00D1CD
      C200FFF6DE00DACBAB00D8C6A700FFFFE700DEDAD3FFDBD7CFFFDBD7CFFFDBD7
      CFFFDBD7CFFFDBD7CFFFDBD7CFFFDBD7CFFF908680FFD2D7DDFFF8FAFCFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000ECE7E547B2A4
      9BFFB2A49BFFB2A49BFF9F9087FF56433AFFB2A49BFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFECE7E5470000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFADCADFFF4B85AFFF4B85AFFF4B85AFF7C5B35FFBF8F4AFFF4B8
      5AFFF4B85AFFF4B85AFFF4B85AFFF4B85AFFF9FDFE00FFFFF200CDAC7A00FFE7
      B600F4F5EB00C0D4D900D7F1F100E0F6F100F0F4EE00F9F7EF00F4F5EC00F5F4
      E600FFFAE400DCCAAD00D9C4A500FFFFE700FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3E8EEFFC2D0DFFF54C1D5FFA9E2
      EBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      00000000000000000000E0DDDA2A64554DCF0000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80736CFFC6C0BDFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFEFE00FFFFF200D2AC7C00FFE2
      B400FCF6E900CBD7DB00B2C7C900DEF1F400A5AAAB009F9E9A00A0A19700D0CC
      BA00FFF7E100E1CAB000E2C6A800FFFFE600E1DED7FFDFDBD4FFDFDBD4FFDFDB
      D4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDDD7FF57DCF2FF40C5DAFF06AB
      C5FFA9E2EBFFFFFFFFFFFFFFFFFFFFFFFFFFF7F5F51CB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFDAD3D086E0DDDA2A64554DCFECE7E547B2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFECE7E547FFFFFFFFC0B3ACFF786052FF6449
      3AFF694F41FFB0A199FFFFFFFFFFFFFFFFFFFFFFFFFF80736CFFB0BEBDFF2DE5
      FEFF2DE5FEFF2DE5FEFF58EAFEFFFFFFFFFFFCFFFD00FFFFF100CFAA7E00FFE7
      BB00FEF3E500EEF6F600DDECEF00E6F2F600EFF2F600F0EEED00F9F8EE00FBF7
      E500FFFAE500D7C0A600E7CBAD00FFFFE500DEDAD3FFDBD7CFFFDBD7CFFFDBD7
      CFFFDBD7CFFFDBD7CFFFDBD7CFFFDBD7CFFFDCD8D0FFACECF5FF07D1F1FF40C5
      DAFF06ABC5FFA9E2EBFFFFFFFFFFFFFFFFFFF7F5F51CC4BAB3FFEBE8E4FFEBE8
      E4FFD9D2CCFFDAD3D086E0DDDA2A64554DCFECE7E547CFC6BFFFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFCFC6BFFFECE7E547D4CBC6FF6C4E3EFF6C4E3EFF7D62
      54FF7C6354FF604435FFB1A49CFFFFFFFFFFFFFFFFFF80736CFFB7BFBDFF68EC
      FEFF68ECFEFF68ECFEFF88F0FEFFFFFFFFFFFBFFFC00FFFFF200C8AA8100FFE1
      BA00FFF4E600F6F6F600EDF2F100F1F6F500F3F1F000FDFAF600F4F3E900FCF7
      E800FFFBE500DDCAAF00D9C3A700FFFFE600FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB0F1FBFF07D1
      F1FF40C5DAFF06ABC5FFB2DDE4FFFFFFFFFFF7F5F51CC4BAB3FFEBE8E4FFEBE8
      E4FFD9D2CCFFDAD3D086E0DDDA2A64554DCFECE7E547CFC6BFFFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFCFC6BFFFECE7E5478A7366FF6E5141FF795D4FFF876F
      62FFDFD8D5FF7C6153FF6A5042FFFDEED7FFFDEED7FF7F6D5FFFC4B4A1FFFDEF
      D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFB00FFFFF100CAAF8300FFE6
      BA00F8EAD800DDD9D400DCD9D400DCD9D400DBD7D200DCD9D100DFDBD000E9E2
      CF00FFF0D300D8C5A400E0CCAD00FFFFE900F5C374FFF5BF69FFF5BF69FFF5BF
      69FFF5BF69FFF5BF69FFF5BF69FFF5BF69FFF5BF6AFFFDF3E2FFFFFFFFFFB0F1
      FBFF07D1F1FF59BCCAFF483B33FFBFB8B4FFF7F5F51CD399A7FFF3528DFFF352
      8DFFEA7BA1FFDAD3D086E0DDDA2A64554DCFECE7E547BF9F70FFB07821FFB078
      21FFB07821FFB07821FFBF9F70FFECE7E547735748FF947E72FFCEC4BEFFCEC4
      BEFFF3F1EFFFA18E84FF674B3CFFF3B758FFF3B758FF7C5B34FFBD8D48FFF4B9
      5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF700FFFFEE00CDAE7B00F1D2
      9D00EBDCC200BEB5AB00B8B2A700B8B2A500B7B4A600BAB4A700BBB3A600CFC1
      AA00F9E1B700DDC59700DCCBAA00FFFFE700F3B758FFF3B758FFF3B758FFF3B7
      58FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFFCEDD4FFFFFFFFFFFFFF
      FFFFBBECF3FF725F51FF77665DFF71625BFFF7F5F51CB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFDAD3D086E0DDDA2A64554DCFECE7E547B2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFECE7E5478B7367FF6C4E3EFF6C4E3EFF8C74
      68FFBBADA6FF6C4E3EFF7A6153FFFBE7C8FFFBE7C8FF7E6B59FFC3AF96FFFCE8
      CAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB00FFFFF000F4DBB300DCC4
      9A00A4988000B4AEA100B0A89B00B9B1A400B2AFA000B2AFA000B7AEA100B8A9
      9600B9A37F00D1BC9600F2E7CC00FFFFF000F4BC63FFF3B758FFF3B758FFF3B7
      58FFF3B758FFF3B758FFF3B758FFF3B758FFF4B85AFFFDF1DDFFFFFFFFFFFFFF
      FFFFFFFFFFFFD3C9C4FF947E73FFEEECEAFF0000000000000000000000000000
      00000000000000000000E0DDDA2A64554DCF0000000000000000000000000000
      000000000000000000000000000000000000D5CCC7FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFFC5B9B3FFFFFFFFFFFFFFFFFF80736CFFC6C0BDFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFF00FFFAFA00FFFFF700FFFD
      F000FFFFF400D5D5C900DAD3CA00B6AFA600D3D3C700C3C2B800CFC9C200E9DF
      D800FFFFF800FFFFF700FFFFF800FFFFF700FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      00000000000000000000F2F1F012BAB3AF5D0000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFD5CDC8FF8C7568FF765A
      4BFF8D7569FFD7CECAFFFFFFFFFFFFFFFFFFFFFFFFFFB6AFABFFDFDBDAFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFF00FFFCFF00FFFDFF00FDFF
      FF00FCFFF800FFFFF700FFFEF700DFD9D200C0BFB500E7E8DF00FFFFFC00FFFE
      FF00FFFDFF00FFFCFF00FDFEFC00FFFFFC00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF7E6355FF7B5E4FFFA18A7EFFFAF8F8FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFB1A198FF83695AFFC7BAB3FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDED7D3FFB4A7
      9EFFB5A89FFFB5A89FFFB2A49BFFFDFDFDFF0000000000000000000000000000
      0000FDFCFC24F1EFEDAFEEECE9DCECE8E5F8ECE9E5FCEEEBE7E3EEEDEACDF6F4
      F17D00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7B5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB09F95FF6E4F3FFF7A5E4FFF907567FFC3B5ADFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F8F8FFCBC6C3FFC8C2BFFFC2B8B2FFD7D0
      CAFFEBE8E4FFEBE8E4FFB5A89FFFFDFDFDFF0000000000000000000000000000
      0000F0EDEAC6F1DCBBFFF1C682FFF2C37AFFF4C57DFFF5C882FFF4D29EFFEBE6
      DFFFF9F9F64C000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7B5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFB09F95FF6E4F3FFF6C4E3EFF7A5E4FFF907567FF907567FFC3B5ADFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF6B5C54FF8C807AFF90847EFFA59790FFDCBB
      C0FFEDC5D0FFEDC5D0FFB7A69EFFFDFDFDFF0000000000000000000000000000
      0000ECE9E4FDF3BB65FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFEFD9
      B6FFF5F3F17C000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7B5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB09E
      94FF6E4F3FFF6C4E3EFF6C4E3EFF7A5E4FFF907567FF907567FF907567FFC3B5
      ADFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFAFAF9FF5D4C43FFFFFFFFFFFFFFFFFFDED7D3FFDF89
      A3FFEB779FFFEB779FFFBAA09CFFFDFDFDFF0000000000000000000000000000
      0000EBE8E4FFF3B759FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF3D5
      AAFFF4F3F180000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7B5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB09E94FF6E4F
      3FFF6C4E3EFF6C4E3EFF6C4E3EFF7A5E4FFF907567FF907567FF907567FF9075
      67FFC3B5ADFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFAFAF9FF5D4C43FFFFFFFFFFFFFFFFFFECE8E6FFD0C8
      C2FFD0C8C2FFD0C8C2FFD0C8C2FFFFFEFEFF0000000000000000000000000000
      0000EBE8E4FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF4D7
      AAFFF4F3F180000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7B5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB1A198FF6E4F3FFF6C4E
      3EFF6C4E3EFF725546FF6C4E3EFF7A5E4FFF907567FF9E867AFF907567FF9075
      67FF907567FFC4B6AEFFFFFFFFFFFFFFFFFFFFFFFFFFE9E7E2FFE5E2DCFFE5E2
      DCFFE5E2DCFFF0EFEBFFFAFAF9FF5D4C43FFFFFFFFFFFFFFFFFFF9F9F8FFF2EF
      EEFFF2EFEEFFF2EFEEFFF2EFEEFFFFFFFFFF0000000000000000000000000000
      0000EBE8E4FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF4D6
      A9FFF4F3F180000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7A5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF715444FF6C4E3EFF6C4E
      3EFF745748FFDCD5D0FF6C4E3EFF7A5E4FFF907567FFE4DDD9FFAC988EFF9075
      67FF907567FF917668FFF8F6F5FFFFFFFFFFFFFFFFFFDFDBD4FFDBD7CFFFDBD7
      CFFFDBD7CFFFE8E6E0FFFAFAF9FF5D4C43FFFFFFFFFFFFFFFFFFDED7D3FFC1B6
      AEFFC9C0B9FFC9C0B9FFB3A69DFFFDFDFDFF0000000000000000000000000000
      0000EBE8E4FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF2D4
      A6FFF4F3F180000000000000000000000000FFFFFFFFFFFFFFFFD6CCC7FFF6F4
      F3FFFFFFFFFFF7F5F4FF6C4E3EFF7A5E4FFF907567FFE8E3E0FFFFFFFFFFFEFE
      FEFFEAE4E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9C877CFF6C4E3EFF7457
      48FFE6E0DCFFF7F5F4FF6C4E3EFF7A5E4FFF907567FFE8E3E0FFFBFAFAFFAC98
      8EFF907567FFB5A299FFFFFFFFFFFFFFFFFFFFFFFFFFDFDBD4FFDBD7CFFFDBD7
      CFFFDBD7CFFFC1BBB3FF58463DFF453127FF58463DFF58463DFF88776FFFD7D0
      CAFFEBE8E4FFEBE8E4FFB5A89FFFFDFDFDFF0000000000000000000000000000
      0000EBE8E4FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF3D5
      A8FFF4F3F180000000000000000000000000FFFFFFFF9C877CFF6C4E3EFF7457
      48FFE6E0DCFFF7F5F4FF6C4E3EFF7A5E4FFF907567FFE8E3E0FFFBFAFAFFAD99
      8EFF907567FFB5A299FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6CCC7FFF6F4
      F3FFFFFFFFFFF7F5F4FF6C4E3EFF7A5E4FFF907567FFE8E3E0FFFFFFFFFFFEFE
      FEFFEAE4E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDBD4FFDBD7CFFFDBD7
      CFFFDBD7CFFFE8E6E0FFFAFAF9FF5D4C43FFFFFFFFFFFFFFFFFFDED7D3FF7ED0
      D9FF60D9EBFF60D9EBFFA8AAA4FFFDFDFDFF0000000000000000000000000000
      0000EBE8E4FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF4D7
      AAFFF4F3F180000000000000000000000000FFFFFFFF715444FF6C4E3EFF6C4E
      3EFF745748FFDCD5D0FF6C4E3EFF7A5E4FFF907567FFE4DDD9FFAC988EFF9075
      67FF907567FF917668FFF8F6F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7A5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBE9E5FFE7E4DFFFE7E4
      DFFFE7E4DFFFF2F0EDFFFAFAF9FF5D4C43FFFFFFFFFFFFFFFFFFDED7D3FF8EB9
      BAFF7EC1C7FF7EC1C7FFABA79FFFFDFDFDFF00000000BCB1AB686C574BDF553D
      32FA554035FFA37944FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF4D7
      AAFFF4F3F180000000000000000000000000FFFFFFFFB1A198FF6E4F3FFF6C4E
      3EFF6C4E3EFF725546FF6C4E3EFF7A5E4FFF907567FF9E867AFF907567FF9075
      67FF907567FFC4B6AEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7B5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFAFAF9FF5D4C43FFFFFFFFFFFFFFFFFFF9F9F8FFF2EF
      EEFFF2EFEEFFF2EFEEFFF2EFEEFFFFFFFFFFD4CAC74B6B4D3DFF6C4E3EFF6C4E
      3EFF694C3DFF4F372BFFA37944FFF3B758FFF3B758FFF3B758FFF3B758FFF2D4
      A7FFF4F3F180000000000000000000000000FFFFFFFFFFFFFFFFB09E94FF6E4F
      3FFF6C4E3EFF6C4E3EFF6C4E3EFF7A5E4FFF907567FF907567FF907567FF9075
      67FFC3B5ADFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7B5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFBFBFAFF5D4C43FFFFFFFFFFFFFFFFFFE7E2DFFFC5BA
      B3FFC5BAB3FFC5BAB3FFC5BAB3FFFEFEFEFF897266CB745748FFD4CBC6FFD0C6
      C1FF715444FF694C3DFF553D2CFFF3B758FFF3B758FFF3B758FFF3B758FFF2D5
      A7FFF4F3F180000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFAF9E
      95FF6E4F3FFF6C4E3EFF6C4E3EFF7A5E4FFF907567FF907567FF907567FFC3B5
      ADFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7B5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF75665FFF7C6E67FF7F716AFF9C8E86FFCFC5
      BFFFDDD8D3FFDDD8D3FFB5A79EFFFDFDFDFF725748F3BDAFA8FF8E766AFF947F
      73FFD3CAC6FF715445FF543C2FFFF6CE8EFFF1C888FFF1C887FFF5CC8DFFF3DF
      C0FFF6F4F27F000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFAF9E95FF6E4F3FFF6C4E3EFF7A5E4FFF907567FF907567FFC3B5ADFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7B5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFDCD8D6FFD9D5D3FFCBC2BDFFD7D0
      CAFFEBE8E4FFEBE8E4FFB5A89FFFFDFDFDFF897266CB6C4E3EFF6C4E3EFF6C4E
      3EFF937D72FFC0B3ACFF6C564AFFECEAE6FFEFEDE9FFFDFCFCFFFDFDFDFFEEEB
      E8FFF7F7F460000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFAF9E95FF6E4F3FFF7A5E4FFF907567FFC3B5ADFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF7F5F4FF6C4E3EFF7B5E4FFF907567FFE8E3E0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDED7D3FFBC95
      59FFB37E2DFFB37E2DFFB5A291FFFDFDFDFFD4CAC74B6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6B4D3DFFB1A59DFFEDEBE7FFEEEBE8FFEDEBE7FFEBE8E4FFEFEE
      EBC1FFFFFF07000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFB1A198FF84695BFFC7BAB3FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF7E6355FF7B5E4FFFA18A7EFFFAF8F8FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE0DAD6FFB7AA
      A1FFB7AAA1FFB7AAA1FFB7AAA1FFFEFEFEFF00000000D4CAC74B897266CB7257
      48F3897266CBD3CAC652FCFCFB28FCFCFB28FCFCFB28FCFCFB28FDFDFC1E0000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE0FAFE1FDFF8FD20DFF8FD20DFF8
      FD20DFF8FD20DFF8FD20DFF8FD20DFF8FD2076716CB4AFBBBB64DFF8FD20FBFF
      FF04FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F8F7FFB3A39BFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80736CFFC6C0BDFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF877A74FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01D0F1FE00CFF0FF00CFF0FF00CF
      F0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF2C6368FF149DB1FF00CFF0FFDFF8
      FD20FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F8C81FF6C4E3EFFAF9F
      96FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00CFF0FF00CFF0FF00CF
      F0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF2C6367FF149EB2FF00CF
      F0FFE1FAFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF513F36FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8CE9F9738BEAF9748BEAF9748BEA
      F9748BEAF9748BEAF9748BEAF9748BEAF9745B6C6BD074B0B79E8BEAF974F1FD
      FF0EFFFFFF00FFFFFF00FFFFFF00FFFFFF00FEFEFEFFB6A79FFF907A6DFF8F77
      6BFF8F776BFF8F776BFF8F776BFF8F776BFF8A7265FF6C4E3EFF6C4E3EFF6C4E
      3EFF8C7467FF917A6EFFB6A79FFFFEFEFEFFFFFFFFFF6BE4F7FF6BE4F7FF6BE4
      F7FF6BE4F7FF6BE4F7FF6BE4F7FF6BE4F7FF6BE4F7FF506A6AFF5FADB7FF6BE4
      F7FFEEFCFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F3F1FFEFECEAFFEFEC
      EAFFEFECEAFFEFECEAFFEFECEAFFEFECEAFF503D34FFEFECEAFFEFECEAFFEFEC
      EAFFEFECEAFFEFECEAFFEFECEAFFEFECEAFFF1F1FD14B2B2F562FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FAFAFF08B0B0F573675869D08E88B59DB0B0F573F1F1
      FD14FFFFFF00FFFFFF00FFFFFF00FFFFFF00C9BEB8FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFFCDC3BEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFFFFC7C7F9FF6D606AFF9F99B9FFC7C7
      F9FFF7F7FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7BEB8FF9D96C0FF9B94
      C5FF9B94C5FF9B94C5FF9B94C5FF9B94C5FF483631FF9B94C5FF9B94C5FF9B94
      C5FF9B94C5FF9B94C5FF9B94C5FFACA0A8FF8888F2AE2626DFFFA5A5F272FFFF
      FF00FFFFFF00FFFFFF00F3F3FE135252EBFF473966FF4C46AEFF5252EBFFE1E1
      FC2DFFFFFF00FFFFFF00FFFFFF00FFFFFF00AF9E96FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFFB6A79FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1FEFF5252EBFF473A65FF4D47AFFF5252
      EBFFE2E2FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7BEB8FF9794E2FF9190
      E8FF9190E8FF9190E8FF9190E8FF9190E8FF473534FF9190E8FF9190E8FF9190
      E8FF9190E8FF9190E8FF9190E8FFADA3B5FF9797F4983737E3FF4949E5DAFFFF
      FF00FFFFFF00FFFFFF00FEFEFF02EAEAFC207A6C6CB4B6B0B964EAEAFC20FCFC
      FF05FFFFFF00FFFFFF00FFFFFF00FFFFFF00AE9E95FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFFB5A69EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFFFFD4D4FAFF71646AFFA8A2BAFFD4D4
      FAFFF9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7BEB8FFE2DDD8FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FF4F3D33FFEBE8E4FFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFBFB3ABFFD1D1FA454949E9FF2121DEFDFAFA
      FF07FBE6C45BF7CC87B7F7CC87B7F7CC87B77E6245E7BE9B68CDF7CC87B7F7CC
      87B7F7CC87B7F7CC87B7F7CC87B7F7CC89B4AE9E95FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF8B7366FF90796DFF90796DFF90796DFF8E77
      6BFF6E5141FF6C4E3EFF6C4E3EFFB5A69EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFCEACEFFF8D59DFFF8D59DFFF8D59DFF7E654CFFC1A378FFF8D5
      9DFFF8D59DFFF8D59DFFF8D59DFFF8D59DFFFFFFFFFFC7BEB8FFE2DDD8FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FF4F3D33FFEBE8E4FFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFBFB3ABFFFDFDFF045F5FEDED2D2DDEFAD7D7
      FA34F9E1B86DF4C06EDCF4C06EDCF4C06EDC7E5D3CF3BE9358E6F4C06EDCF4C0
      6EDCF4C06EDCF4C06EDCF4C06EDCF4C170D9AE9E95FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF725647FFE3DDDAFFFFFFFFFFFFFFFFFFFFFFFFFFE6E1
      DFFF866D60FF6C4E3EFF6C4E3EFFB5A69EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFADCADFFF4B85AFFF4B85AFFF4B85AFF7C5B35FFBF8F4AFFF4B8
      5AFFF4B85AFFF4B85AFFF4B85AFFF4B85AFFFFFFFFFF9B8C82FF5B5249FF523E
      32FF4E4037FF6D9B9DFF60D9EBFF60D9EBFF433B34FF60D9EBFF60D9EBFF60D9
      EBFF60D9EBFF60D9EBFF60D9EBFF9FB8B6FFFFFFFF00EFEFFE19766154D57E6C
      63BD9788819AECE9E81DFFFFFF00FFFFFF0081736DAAC4BFBC4EF5FEFF0BF5FE
      FF0BF5FEFF0BF8FFFF08FFFFFF00FFFFFF00AE9E95FF6C4E3EFF6C4E3EFF6C4E
      3EFF725546FF745849FF745849FF745849FF745849FF745849FF745849FF7458
      49FF6C4E3EFF6C4E3EFF6C4E3EFFB5A69EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80736CFFC6C0BDFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD5CCC7FF6B4D3DFF6C4E3EFF6C4E
      3EFF9F8B82FFFAF9F9FF7E9290FF7EC1C7FF463931FF7EC1C7FF7EC1C7FF7EC1
      C7FF7EC1C7FF7EC1C7FF7EC1C7FFA3ACA8FFF9F9F9098F776CC38A7669FFBBB4
      ADFF9F948CFF4A372CFACFC7C548FFFFFF0081736DAAADBCBC681BE2FDFF1BE2
      FDFF1BE2FDFF49E7FECCFFFFFF00FFFFFF00AE9E95FF6C4E3EFF6C4E3EFF7A5F
      50FFFCFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFA8968DFF6C4E3EFF6C4E3EFFB5A69EFFFFFFFFFFC0B3ACFF786052FF6449
      3AFF694F41FFB0A199FFFFFFFFFFFFFFFFFFFFFFFFFF80736CFFB0BEBDFF2DE5
      FEFF2DE5FEFF2DE5FEFF58EAFEFFFFFFFFFF8B7367FF6C4E3EFF968176FFC9BF
      B9FFFDFCFCFFA6958CFF584338FFF9F8F7FF513F36FFF9F8F7FFF9F8F7FFF9F8
      F7FFF9F8F7FFF9F8F7FFF9F8F7FFF9F8F7FFB2A198879E8A7FFFEBE8E4FFDDD9
      D2FFDBD7CFFFC7C1BAFF564037EEFFFFFF0081736DAABABEBB5B85EFFD8985EF
      FD8985EFFD899DF3FF6DFFFFFF00FFFFFF00AE9E95FF6C4E3EFF6C4E3EFF6C4E
      3EFF6E5141FF705344FF705344FF705344FF705344FF705344FF705344FF7053
      44FF6C4E3EFF6C4E3EFF6C4E3EFFB5A69EFFD4CBC6FF6C4E3EFF6C4E3EFF7D62
      54FF7C6354FF604435FFB1A49CFFFFFFFFFFFFFFFFFF80736CFFB7BFBDFF68EC
      FEFF68ECFEFF68ECFEFF88F0FEFFFFFFFFFF735748FF6C4E3EFFB6A79FFFCABF
      BAFFC9BFB9FF6C4E3EFF574034FFFFFFFFFF513F36FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF866D60D3D6CEC9FFEBE8E4FFE2DF
      D9FFDBD7CFFFDBD7CFFF544339FFEFD9B868806A58C9C1AD918FFBE6C45BFFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AE9E95FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFFB5A69EFF8A7366FF6E5141FF795D4FFF876F
      62FFDFD8D5FF7C6153FF6A5042FFFDEED7FFFDEED7FF7F6D5FFFC4B4A1FFFDEF
      D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8A7366FF6C4E3EFF6C4E3EFFB7A8
      A1FF937D71FF6C4E3EFF6F594DFFFFFFFFFF513F36FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF887063CDD4CDC6FFEBE8E4FFE8E4
      DFFFDBD7CFFFDBD7CFFF544138FFE2AA54FF7D5B35FFBC8D48FFF4B85BF9FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AE9E95FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFFB5A69EFF735748FF947E72FFCEC4BEFFCEC4
      BEFFF3F1EFFFA18E84FF674B3CFFF3B758FFF3B758FF7C5B34FFBD8D48FFF4B9
      5DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD4CBC6FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6B4D3DFFBCB3ACFFFFFFFFFF513F36FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB6A9A07D988477FFEAE7E3FFEBE8
      E4FFDDD9D1FFC3BCB4FF594237EFFCF1DC35806F62BBC3B6A572FDF1DE33FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B6A79FFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFFBDAFA8FF8B7367FF6C4E3EFF6C4E3EFF8C74
      68FFBBADA6FF6C4E3EFF7A6153FFFBE7C8FFFBE7C8FF7E6B59FFC3AF96FFFCE8
      CAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD4CBC6FF8A7366FF7357
      48FF8B7367FFD5CCC7FFFFFFFFFFFFFFFFFFACA39FFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F909978278B3856D5FFFA695
      8AFF8E7D73FF4B352BF9DCD8D434FFFFFF0081736DAAC4BFBC4EFFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00ECE8E6FF795E4FFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFF7C6153FFF0EDEBFFD5CCC7FF6C4E3EFF6C4E3EFF6C4E
      3EFF6C4E3EFF6C4E3EFFC5B9B3FFFFFFFFFFFFFFFFFF80736CFFC6C0BDFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFF01DAD4D03FBEB2
      AB70C4B9B461F9F8F809FFFFFF00FFFFFF00C6C1BE4CE5E3E023FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFFFFF9F7F6FFE0DAD7FFDFD8
      D4FFDFD8D4FFDFD8D4FFDFD8D4FFDFD8D4FFDFD8D4FFDFD8D4FFDFD8D4FFDFD8
      D4FFDFD8D4FFE1DBD7FFFAF9F8FFFFFFFFFFFFFFFFFFD5CDC8FF8C7568FF765A
      4BFF8D7569FFD7CECAFFFFFFFFFFFFFFFFFFFFFFFFFFB6AFABFFDFDBDAFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCDC7C5FFCDC7C5FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE7E3E0FFB2A49BFFD5CDC8FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCCC7FF6C5D
      55FF73655DFFD4D0CDFFFFFFFFFFEFD6AFFF85694AFF7C6145FFEED2A8FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFA39995FFA39995FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF5F3F2FFBEB2ABFFE1DBD8FFD6CEC9FFB2A49BFFC5BBB4FFECE9E6FFBDB1
      A9FFE9E4E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFBFF988E85FF7263
      5BFF75665EFF978C85FFFFFFFFFFCE9D52FF816A53FF7D6750FFCE9F55FFFFF8
      EBFFFFFAF0FFFFFDF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2A4
      9BFF5252EBFF5252EBFF5252EBFF5252EBFF5252EBFF5252EBFF5252EBFF5252
      EBFF5252EBFFB2A49BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFA39995FFA39995FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFE3DEDBFFB2A49BFFB2A49BFFB2A49BFFB6A9A0FFB2A49BFFB2A49BFFB2A4
      9BFFD0C7C2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFAFAFFAAA398FFA49B
      92FFA49B92FFABA499FFFFFFFFFFE8AF56FFDFA953FFDFA953FFE6AE55FFFFE4
      B9FFFFE7C0FFFFE9C5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2A4
      9BFFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8
      E4FFEBE8E4FFB2A49BFFFFFFFFFFFFFFFFFFCAC1BAFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFF7B6A61FF7B6A61FFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFC4B9B2FFB6A9A0FFEBE7E5FFFBFBFAFFF6F4F3FFC2B6AFFFB4A7
      9EFFFDFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFAFAFFB5AFA3FFB5AF
      A3FFB5AFA3FFB5AFA3FFFFFFFFFFF3B758FFF3B758FFF3B758FFF3B758FFFFE4
      B9FFFFE7C0FFFFE7C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2A4
      9BFF00CFF0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF00CFF0FF00CF
      F0FF00CFF0FFB2A49BFFFFFFFFFFFFFFFFFFCAC1BAFF6B6AE7FF5252EBFF5252
      EBFF5252EBFF5252EBFF5252EBFF4A408AFF4A408AFF5252EBFF5252EBFF5252
      EBFF5252EBFF5252EBFF5252EBFFA99FB4FFFFFFFFFFFFFFFFFFFFFFFFFFE1DB
      D8FFC0B5AEFFB2A49BFFD7CFCBFFBFB8B4FF47342AFF958A84FFEDEAE8FFB2A4
      9BFFBDB1A9FFD2C9C4FFFFFFFFFFFFFFFFFFFFFFFFFFFBFAFAFFB5AFA3FFB5AF
      A3FFB5AFA3FFB5AFA3FFFFFFFFFFF3B758FFF3B758FFF3B758FFF3B758FFFFE4
      B9FFFFE7C0FFFFE7C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFFFFFFFFFFFFFFFFFCAC1BAFFE1DCD7FFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FF988D87FF988D87FFEBE8E4FFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFBCB0A8FFFFFFFFFFFFFFFFFFFFFFFFFFD4CC
      C7FFB2A49BFFB2A49BFFDDD7D3FF9A8F8AFF412D23FF6B5C54FFF4F2F0FFB2A4
      9BFFB2A49BFFC2B6AFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFAFAFFB5AFA3FFB5AF
      A3FFB5AFA3FFB5AFA3FFFFFFFFFFF3B758FFF3B758FFF3B758FFF3B758FFFFE4
      B9FFFFE7C0FFFFE7C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCAC1BAFFE1DCD7FFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FF988D87FF988D87FFEBE8E4FFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFBCB0A8FFFFFFFFFFFFFFFFFFFFFFFFFFFBFA
      FAFFEFEDEBFFBFB3ACFFC0B4ADFFF3F1F0FFB6AFABFFE8E6E5FFD3CBC5FFB4A6
      9DFFECE8E6FFF7F6F5FFFFFFFFFFFFFFFFFFFFFFFFFFFBFAFAFFB5AFA3FFB5AF
      A3FFB5AFA3FFB5AFA3FFFFFFFFFFF3B758FFF3B758FFF3B758FFF3B758FFFFE4
      B9FFFFE7C0FFFFE7C0FFFFFFFFFFFFFFFFFFFFFFFFFFF8F7F6FFFFFFFFFFC7BD
      B6FFC7BDB6FFFFFFFFFFF8F7F6FFFFFFFFFFFFFFFFFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFCAC1BAFFE1DCD7FFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FF988D87FF988D87FFEBE8E4FFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFBCB0A8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF2F0EEFFB7AAA2FFB2A49BFFBCAFA7FFD0C8C2FFC3B8B1FFB2A49BFFB2A4
      9BFFE4DFDCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFAFAFFB5AFA3FFB5AF
      A3FFB5AFA3FFB5AFA3FFFFFFFFFFF3B758FFF3B758FFF3B758FFF3B758FFFFE4
      B9FFFFE7C0FFFFE7C0FFFFFFFFFFFFFFFFFFF8F7F6FFB7AAA1FFC9BFB9FFB6A9
      A1FFB6A9A1FFC9BFB9FFB7AAA1FFF8F7F6FFFFFFFFFFB2A49BFFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFB2A49BFFCAC1BAFF27D1EBFF00CFF0FF00CF
      F0FF00CFF0FF00CFF0FF00CFF0FF20808DFF20808DFF00CFF0FF00CFF0FF00CF
      F0FF00CFF0FF00CFF0FF00CFF0FF9AB5B5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFE6E1DEFFB2A49BFFC5BAB3FFC3B8B1FFB2A49BFFBAADA5FFCEC5BFFFB2A4
      9BFFD3CBC6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFAFAFFB5AFA3FFB5AF
      A3FFB5AFA3FFB5AFA3FFFFFFFFFFF3B758FFF3B758FFF3B758FFF3B758FFFFE4
      B9FFFFE7C0FFFFE7C0FFFFFFFFFFFFFFFFFFFFFFFFFFC9BFB9FFBAADA5FFE4DF
      DBFFE5E0DDFFBBAEA6FFC9BFB9FFFFFFFFFFFFFFFFFFB2A49BFFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFEBE8E4FFB2A49BFFCAC1BAFFC0A588FFD9A95FFFDAA6
      54FFD3A155FFCCA56CFFB2A49BFF7B6A61FF7B6A61FFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFFFFFFFFFFFFFFFFFFFFFFFFFFAF9
      F8FFDFD9D6FFEDEAE8FFEEE9E7FFE3DDDAFFB2A49BFFCFC7C1FFFFFFFFFFECE9
      E6FFFFFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFAFAFFB5AFA3FFB5AF
      A3FFB5AFA3FFB5AFA3FFFFFFFFFFF3B758FFF3B758FFF3B758FFF3B758FFFFE4
      B9FFFFE7C0FFFFE7C0FFFFFFFFFFFFFFFFFFC7BDB6FFB6A9A1FFE2DCD9FF796A
      63FF796B64FFE5E0DDFFB6A9A1FFC7BDB6FFFFFFFFFFB2A49BFFB07821FFB078
      21FFB07821FFB07821FFB07821FFB2A49BFFFEF5E7FFF3BA5EFFF3B758FFF8D8
      A6FFF2B657FFDBA652FFE5C087FFA39995FFA39995FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F5F4FFEEEB
      E9FFB2A49BFFC9BFB9FFB4A69DFFF3F1EFFFE2DCD9FFF2EFEEFFFFFFFFFFE7E4
      E3FFA29994FF5E4D44FFC9C3C1FFFFFFFFFFFFFFFFFFFBFAFAFFB5AFA3FFB5AF
      A3FFB5AFA3FFB5AFA3FFFFFFFFFFF3B758FFF3B758FFF3B758FFF3B758FFFFE4
      B9FFFFE7C0FFFFE7C0FFFFFFFFFFFFFFFFFFC7BDB6FFB6A9A1FFE1DBD7FF796A
      63FF796A63FFE3DEDBFFB6A9A1FFC7BDB6FFFFFFFFFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFB2A49BFFF8D399FFF3B758FFF3B758FFF8DA
      A9FFF3B759FFF3B657FFD5A354FFA39993FFA39995FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3B7B0FFB3A5
      9CFFD2C9C4FFE3DEDBFFB9ADA5FFCDC4BEFFEFECEAFFFFFFFFFFFFFFFFFFFFFF
      FFFF625249FF412D23FF83766FFFFFFFFFFFFFFFFFFFFBFAFAFFB5AFA3FFB5AF
      A3FFB5AFA3FFB5AFA3FFFFFFFFFFF3B758FFF3B758FFF3B758FFF3B758FFFFE4
      B9FFFAD394FFFAD497FFFFFFFFFFFFFFFFFFFFFFFFFFC9BFB9FFB9ACA3FFE1DB
      D7FFE2DCD9FFBAADA5FFC9BFB9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6C87EFFF3B758FFF3B758FFF9E0
      B8FFFCEFDBFFF3B759FFDEA953FFB19D89FFA39995FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBE7E4FFC0B4
      ADFFA59C97FF5B4941FFDED8D4FFBFB3ACFFEFEDEBFFFFFFFFFFFFFFFFFFD8D4
      D2FF47332AFF64534BFFA39995FFFCFBFBFFFFFFFFFFFBFAFAFFB5AFA3FFB5AF
      A3FFB5AFA3FFB5AFA3FFFFFFFFFFF3B758FFF3B758FFF3B758FFF3B758FFFFE4
      B9FFF6C472FFFFF9F1FFFFFFFFFFFFFFFFFFF8F7F6FFB7A9A1FFC9BFB9FFB6A9
      A1FFB6A9A1FFC9BFB9FFB7AAA1FFF8F7F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8D398FFF3B758FFF9DDB1FFF6C9
      83FFFCF0DDFFF3BA60FFE4AE5AFFA39994FFA39995FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFB5A79FFFB6A9
      A0FFD2CCC9FFB4ACA8FFCBC1BBFFC0B5AEFFF7F6F5FFE7E4E3FF90847EFF4835
      2BFF56453CFFDEDAD9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB5AFA3FFB5AF
      A3FFB5AFA3FFB6B0A5FFFFFFFFFFF4B85AFFF3B758FFF3B758FFF3B758FFFFF1
      DCFFFEF7E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F7F6FFFFFFFFFFC7BD
      B6FFC7BDB6FFFFFFFFFFF8F7F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEF4E6FFF4BA5EFFF4C170FFFAE2
      BDFFF7D298FFF3B758FFF1D19FFFD7D2D0FFD7D2D0FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F2F1FFCFC6
      C1FFB5A89FFFBAADA5FFC4B9B2FFCFC6C0FFFAF9F8FFFFFFFFFFE8E5E4FFDFDC
      DAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCD9D3FF9F96
      8CFFA39A90FFDFDCD7FFFFFFFFFFFAE0B5FFCEA05CFFCA9C58FFFADCAEFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDF1DFFFF7CA84FFF4BB
      62FFF5C374FFFBE2BBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9D2
      CDFFDED8D4FFCDC4BEFFD6CEC9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F83
      7DFF9C928DFFFFFFFFFFFFFFFFFFFFFFFFFF9C928DFF8F837DFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFEFF00FAFDFF00FFFFFE00FFFE
      FF00FFFDFF00FFFDF300EDD39D00FADC9B00FFFFDF00FFFFED00FFFCFD00FFFC
      FF00FFFBFF00FDFFFF00F7FDFC00F8FFFE00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9999F2FF2222DEFF3C3CE3FFE8E8
      FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFEEEDECFFABA29EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFDFF00FFFEFF00FFFFFE00FFFF
      FF00FDFDFF00FFFFF300DFC18A00D0AD6D00C6AB7F00FFFFE800FFFEFE00FFFB
      FF00FFFDFF00FEFEFE00FBFFFE00F8FFFA00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D5DEDFF3535E3FF1C1CDCFF3030
      E1FFE8E8FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFE0DDDBFF65554DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE00FFFFFE00FFFFFE00FCFC
      FC00F9FDFE00FFFFF200EBC68E00D4AA6700B0996900FFFFEB00FFFBFE00FFF9
      FF00FFFDFF00FFFDFA00FFFFFB00FBFFF900FFFFFFFFE1DED7FFDFDBD4FFDFDB
      D4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDCD5FFF9F8F7FFFFFF
      FFFFFFFFFFFFF3F3FEFF4E4EE6FFBDBDF8FF7E7EF1FF5252EBFF3535E3FF1C1C
      DCFF3030E1FFE8E8FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECE8E6FFB2A4
      9BFFB2A49BFFB2A49BFF9F9087FF56433AFFB2A49BFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFECE8E6FFFFFFFFFFFFFFFFFFFFFFFC00FFFEFD00FFFFFF00FFFE
      FF00FCFEFE00FFFFF000ECC68C00D7AC6900B8A06C00FFFFEA00FFFBFC00FFFB
      FF00FFFDFF00FFFCF900FCFEF800FDFFFB00FFFFFFFFDEDAD3FFDBD7CFFFDBD7
      CFFFDBD7CFFFDBD7CFFFDBD7CFFFDBD7CFFFDBD7CFFFDCD8D0FFF8F7F6FFFFFF
      FFFFFFFFFFFF8080EDFF2B2BE0FF7C7CF0FFF1F1FEFF7070EFFF5252EBFF3535
      E3FF1C1CDCFF3030E1FFE8E8FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECE8E6FF908C
      D5FF5252EBFF5252EBFF4F4CCAFF443449FF5252EBFF5252EBFF5252EBFF5252
      EBFF908CD5FFECE8E6FFFFFFFFFFFFFFFFFFFFFFFE00FDFDFD00FFFEFF00FFFE
      FF00FFFFFE00FFFFEE00E6C38B00D1A76400B69A6400FFFFE300FFFFFB00FDFD
      FF00FFFCFE00FFFEFF00FCFCFC00FBFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF3C3CE3FF3C3CE5FFA7A7F5FFFFFFFFFFF1F1FEFF7070EFFF5252
      EBFF3535E3FF1C1CDCFF6F6FEBFFFFFFFFFFFFFFFFFFDDD8D5FFBEB4AFFFEFEC
      EBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECE8E6FFCFC6
      BFFFEBE8E4FFEBE8E4FFCFC9C4FF615047FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8
      E4FFCFC6BFFFECE8E6FFFFFFFFFFFFFFFFFFFBFFFF00FDFFFF00FFFDFF00FFFC
      FE00FFFFFE00FFFFED00ECC88C00D6AD6800BD9E6900FFFFE700FFFFF900F8FB
      FF00FFFDFE00FFFEFF00FCFEFF00FAFDFF00FFFFFFFFE1DED7FFDFDBD4FFDFDB
      D4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDCD5FFF9F8F7FFFFFF
      FFFFEAEAFDFF1F1FDEFF4D4DE9FFE0E0FCFFFFFFFFFFFFFFFFFFF1F1FEFF7070
      EFFF5252EBFF433DC1FFBFB6B7FF93847DFF473228FF412D23FF412D23FF422E
      24FF513D32FFC7BEB9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECE8E6FF67CB
      D7FF00CFF0FF00CFF0FF0BB4CEFF354B4AFF00CFF0FF00CFF0FF00CFF0FF00CF
      F0FF67CBD7FFECE8E6FFFFFFFFFFFFFFFFFFF7FCFF00FDFFFF00FFFDFF00FFFE
      FF00FFFFFC00FFFFE800EAC37E00D8AC5F00B9996800FFFFE900FFFFF900FDFF
      FF00FFFFFE00FFFEFD00FBFDFE00FAFFFF00FFFFFFFFDEDAD3FFDBD7CFFFDBD7
      CFFFDBD7CFFFDBD7CFFFDBD7CFFFDBD7CFFFDBD7CFFFDCD8D0FFF8F7F6FFFFFF
      FFFFF8F8FFFF5550C3FF8F8FF1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1
      FEFFADADF6FFDAD2D1FF5B4135FF412D23FF7B6E65FFBEB7B0FFCBC6BEFFB3AB
      A3FF57453CFF432F25FF998C84FFFFFFFFFFFFFFFFFFFFFFFFFFECE8E6FFB2A4
      9BFFB2A49BFFB2A49BFF9F9087FF56433AFFB2A49BFFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFECE8E6FFFFFFFFFFFFFFFFFFFBFEFF00FFFEFF00FFFDFD00FFFF
      F800FFFFF200FFFFDC00F0C47700E4B25F00C6A06600FFFBD700FFFFF200FFFF
      FB00FFFDFA00FFFFFE00FFFFFF00FAFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA39790FF523D
      33FF463226FF6A5246FFDCD5D1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFC5B9B2FF6C4E3EFFAA9E96FFDBD7CFFFDBD7CFFFDBD7CFFFDBD7
      CFFFDBD7D0FF7B6E65FF442F26FFDAD5D3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFE0DDDBFF65554DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFBFF00FFFEFF00FFFCF900FFFF
      F000FFFFD200E9C78500EAB46100EDB35A00E6B16100D4AB6D00FFEFCF00FFFF
      F400FFFEFC00FFFFFE00FDFEFA00FBFFFB00FFFFFFFFE1DED7FFDFDBD4FFDFDB
      D4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDBD4FFDFDBD4FF8D7E74FF6C5D54FFD4CF
      C8FFDBD7D0FFC5BBB3FF7B5F51FFDDD6D2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF775C4DFF877062FFEAE7E3FFE2DFD9FFDBD7CFFFDBD7CFFFDBD7
      CFFFDBD7CFFFD9D6CEFF49352CFF6C594FFFF8F6F5FFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFDBD4D0FFE0DDDBFF65554DFFECE8E6FFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFECE8E6FFFDFDFF00FFFBFC00FFFFF500FFFF
      DC00DDBA7B00E1B26100F1B66000F3B45800F3B65900E8B36300D1A77200FFEB
      CC00FFFFF400FFFFFC00FFFFF700FFFFF800FFFFFFFFDEDAD3FFDBD7CFFFDBD7
      CFFFDBD7CFFFDBD7CFFFDBD7CFFFDBD7CFFFDBD7CFFF49352AFFD8D4CCFFDBD7
      CFFFDEDAD4FFEBE8E4FFC3B8B0FF947E72FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFECE8E6FF6C4E3EFFB4A59BFFEBE8E4FFEBE8E4FFE2DFD9FFDBD7CFFFDBD7
      CFFFDBD7CFFFDBD7CFFF82746DFF503B31FFF8F6F5FFC4BAB3FFEBE8E4FFEBE8
      E4FFD9D2CCFFDBD4D0FFE0DDDBFF65554DFFECE8E6FFCFC6BFFFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFCFC6BFFFECE8E6FFFCFCFC00FFFFF700FFFCDE00E1BA
      8600E4B26A00EDB45F00F6B75F00F2B35900F5B75900F0B45A00EBB36200DAAE
      7100FFEDD100FFFFF700FFFDF600FFFFF900FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F4F3FF513E35FFDBD7CFFFDBD7
      CFFFE4E0DBFFEBE8E4FFE2DDD8FF7A5F51FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFDBD3CFFF6C4E3EFFC2B7AEFFEBE8E4FFEBE8E4FFEBE8E4FFE2DFD9FFDBD7
      CFFFDBD7CFFFDBD7CFFF9C9189FF463127FFF8F6F5FFC4BAB3FFEBE8E4FFEBE8
      E4FFD9D2CCFFDBD4D0FFE0DDDBFF65554DFFECE8E6FFCFC6BFFFEBE8E4FFEBE8
      E4FFEBE8E4FFEBE8E4FFCFC6BFFFECE8E6FFFFFFF700FFFFEB00E0BF9200DCAD
      7000E8B06900E9AF6300E8AF6000E8B05F00EAB26000EAB15C00EFB66000E0B1
      6700D7B98A00FFF8DE00FFFFF800FFFFFE00FFFFFFFFF5C374FFF5BF69FFF5BF
      69FFF5BF69FFF5BF69FFF5BF69FFF5BF69FFF5BF69FF483328FFDAD6CEFFDBD7
      CFFFE9E5E1FFEBE8E4FFCAC0B9FF8D766AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF3F1F0FF6C4E3EFFAC9D93FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8E4FFE2DF
      D9FFDBD7CFFFDBD7CFFF73665CFF564137FFF8F6F5FFD399A7FFF3528DFFF352
      8DFFEA7BA1FFDBD4D0FFE0DDDBFF65554DFFECE8E6FFBF9F70FFB07821FFB078
      21FFB07821FFB07821FFBF9F70FFECE8E6FFFFFFEA00CAB79100BD965F00C998
      5A00C9975D00C6955D00C0945900C1985A00BE955700C4995A00C1975000C59D
      5500C69E5D00D6B88900FFFEF200FFFCFF00FFFFFFFFF3B758FFF3B758FFF3B7
      58FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FF86633BFF7E7167FFD8D5
      CDFFEBE8E4FFD2CAC4FF7E6356FFD4CBC6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF866D60FF795D4EFFE3DED9FFEBE8E4FFEBE8E4FFEBE8E4FFEBE8
      E4FFE2DFD9FFD0CBC4FF412D23FF7D6C63FFF8F6F5FFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFDBD4D0FFE0DDDBFF65554DFFECE8E6FFB2A49BFFB2A49BFFB2A4
      9BFFB2A49BFFB2A49BFFB2A49BFFECE8E6FFFFFFE500AC986F00C8A46E00E0B5
      7C00E2B88900E5C09400EDCC9F00E7C99A00EACB9E00E4C49300E0C18A00DAB8
      7C00C6A26200B2946300FFFCF000FFFEFF00FFFFFFFFF4BC63FFF3B758FFF3B7
      58FFF3B758FFF3B758FFF3B758FFF3B758FFF3B758FFF4B85AFF8B7869FF644C
      3FFF725545FF836A5CFFCEC4BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFDED7D4FF6E5040FF8B7466FFDCD5D0FFEBE8E4FFEBE8E4FFEBE8
      E4FFC5BAB3FF675144FF4B362BFFF4F2F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFE0DDDBFF65554DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEE00C1AF9200F5DFB500FFF2
      C400FFF2CA00FFF1CD00FFEFCD00FFF0CC00FFEDC800FFF4CC00FFEFCC00FFEB
      C600F9E0B800C7B89800FEFAEF00FAFDFB00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFCFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFC3B7B0FF715445FF715444FF8D7669FF9B877BFF856C
      5EFF6C4E3EFF81675AFFD3CDC9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFF2F1F0FFBAB3AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF100F7E7D000CFBF9B00BBAA
      8300BBA98400BEAB8A00BBA68A00C4B09100C6B08D00C1AB8800C5AD9100C8B1
      9700D0BFA400EBE4CB00FFFFF800FBFFFC00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFEAE5E3FFA28F85FF846B5EFF745848FF8E77
      6AFFB5A59DFFFAF9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF424D3E000000000000003E000000
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000F03FFFFF00000000C307E001
      000000008303E000000000000F83E00000000000306180010000000040118001
      000000008009800100000000880B0001000000004017000100000000B0670001
      00000000EF83000700000000FFA1000700000000FFC0000700000000FFE0000F
      00000000FFF0000F00000000FFF9000FFFFFFFFFFFFF00000001000000FF0000
      04010000800000003E0100FC80DE000004F940FC800000000001608480DE0000
      0001400480000000000140FC84DE00000001048400000000000108040DDE0000
      00014FFC0000000000014C0480000000000164048000000000017FFCC7FF0000
      00000000E3FF00000000FFFFF9FF0000FFFFFCFFFFC0FFFFE003FCFFFE000001
      E003C003FE000401E003C003FCC03E01E003C003FCC004F9E003C00380C00001
      FFFFC00380C00001A180FCFF800000010080800080C000018180000080C00001
      00800000FCC0000100800000FCC0000181FF0000FE00000100FF00FFFE000001
      A5FF80FFFFC00000FFFFFFFFFFC00000000000000000FCFF000000000000FCFF
      000000000000C003000000000000C003000000000000C003000000000000C003
      000000000000C003000000000000FCFF00000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FCFF
      000000000000FCFF000000000000FFFF000000000000F00F000000000000F007
      000000000000F007000000000000F007000000000000F007000000000000F007
      000000000000F007000000000000F007000000000000F0070000000000008007
      0000000000000007000000000000000700000000000000070000000000000007
      0000000000000007000000000000801F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object MatPopUp: TPopupMenu
    Images = BinIcons
    OnPopup = PopUpMatPopup
    Left = 304
    Top = 56
    object MiMatUnschedule: TMenuItem
      Caption = 'Unschedule'
      OnClick = MiMatUnscheduleClick
    end
    object MiShowOnPlanMat: TMenuItem
      Caption = 'Show on plan'
      OnClick = MiShowOnPlanMatClick
    end
    object MiMatCopy: TMenuItem
      Caption = 'Copy'
      OnClick = MiMatCopyClick
    end
    object CreateNewtab1: TMenuItem
      Caption = 'Create New tab'
      object Warp1: TMenuItem
        Caption = 'Warp'
        OnClick = MIWarpTabClick
        OnDrawItem = DrawItemPopUp
      end
      object New1: TMenuItem
        Caption = 'New'
        OnClick = MINewTabClick
        OnDrawItem = DrawItemPopUp
      end
    end
    object CreateNewtab2: TMenuItem
      Caption = 'Edit existing tab'
      ImageName = '18'
      object Edit1: TMenuItem
        Caption = 'Edit'
        OnClick = EditTabClick
        OnDrawItem = DrawItemPopUp
      end
      object Configuration1: TMenuItem
        Caption = 'Configuration'
        OnClick = MiBinCongClick
        OnDrawItem = DrawItemPopUp
      end
      object Delete1: TMenuItem
        Caption = 'Delete'
        OnClick = MICloseClick
        OnDrawItem = DrawItemPopUp
      end
    end
    object MiModifySpeedSetupWarp: TMenuItem
      Caption = 'Modify execution/setup'
      OnClick = MiModifySpeedSetupWarpClick
    end
    object MIClearJobWarpHostMsg: TMenuItem
      Caption = 'Clear job message from host'
      OnClick = MIClearJobWarpHostMsgClick
    end
  end
  object cxHintStyleController1: TcxHintStyleController
    HintStyleClassName = 'TcxHintStyle'
    HintStyle.CaptionFont.Charset = DEFAULT_CHARSET
    HintStyle.CaptionFont.Color = clWindowText
    HintStyle.CaptionFont.Height = -12
    HintStyle.CaptionFont.Name = 'Segoe UI'
    HintStyle.CaptionFont.Style = []
    HintStyle.Color = clWhite
    HintStyle.Font.Charset = DEFAULT_CHARSET
    HintStyle.Font.Color = 16744448
    HintStyle.Font.Height = -15
    HintStyle.Font.Name = 'Montserrat'
    HintStyle.Font.Style = []
    HintStyle.Rounded = True
    LookAndFeel.NativeStyle = False
    LookAndFeel.ScrollMode = scmClassic
    Left = 96
    Top = 152
  end
end
