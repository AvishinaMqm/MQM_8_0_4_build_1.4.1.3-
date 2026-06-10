object FOptions: TFOptions
  Left = 468
  Top = 180
  Caption = 'Configuration'
  ClientHeight = 657
  ClientWidth = 896
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Label2: TLabel
    Left = 36
    Top = 428
    Width = 58
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'count limit'
  end
  object PanBtn: TPanel
    Left = 0
    Top = 607
    Width = 896
    Height = 50
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelInner = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      896
      50)
    object BtnOk: TcxButton
      Left = 661
      Top = 9
      Width = 102
      Height = 31
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnAbort: TcxButton
      Left = 769
      Top = 9
      Width = 95
      Height = 31
      Anchors = [akRight, akBottom]
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnAbortClick
    end
  end
  object PGCconfig: TPageControl
    Left = 0
    Top = 0
    Width = 896
    Height = 607
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TbsPref
    Align = alClient
    TabOrder = 1
    object TbsPref: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Preferences'
      ImageIndex = 3
      object Label1: TLabel
        Left = 85
        Top = 12
        Width = 148
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Confirmation levels'
      end
      object LabelRoundDec: TLabel
        Left = 382
        Top = 19
        Width = 213
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Split jobs number of decimals'
      end
      object ShowJobQtyOnStatusBar: TLabel
        Left = 382
        Top = 268
        Width = 401
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Number of decimal for showing job quantity on status bar'
      end
      object ChkBxSequece: TCheckBox
        Left = 10
        Top = 282
        Width = 369
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Check step sequence'
        TabOrder = 0
      end
      object RGFixTemp: TRadioGroup
        Left = 10
        Top = 44
        Width = 315
        Height = 102
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Default schedule level'
        Columns = 2
        Items.Strings = (
          'Temporary'
          'Final')
        TabOrder = 1
      end
      object ChkCenterStartOnMove: TCheckBox
        Left = 10
        Top = 312
        Width = 369
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Center planned start date on move'
        TabOrder = 2
      end
      object ChkWarnOnMoveFinal: TCheckBox
        Left = 10
        Top = 375
        Width = 592
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Warn when final scheduled job needs to be moved'
        TabOrder = 3
      end
      object ChkBxShowInBinOnMove: TCheckBox
        Left = 10
        Top = 343
        Width = 369
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show job in bin during move'
        TabOrder = 4
      end
      object SpinEdit1: TExSpinEdit
        Left = 36
        Top = 9
        Width = 39
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ArrowColor = 15972184
        Color = 14803425
        MaxValue = 6
        MinValue = 0
        TabOrder = 5
        Value = 0
        OnChange = SpinEdit1Change
      end
      object CBShowBinToolBar: TCheckBox
        Left = 10
        Top = 252
        Width = 369
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show bin tool bar'
        TabOrder = 6
        OnClick = CBShowBinToolBarClick
      end
      object RGBinHandling: TRadioGroup
        Left = 10
        Top = 150
        Width = 315
        Height = 61
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Bin handling'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          'Single cell '
          'Full row')
        TabOrder = 7
        OnClick = RGBinHandlingClick
      end
      object ChkBxRefreshBinButton: TCheckBox
        Left = 10
        Top = 410
        Width = 592
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'BIN is filtered and sorted only when BIN blue button is pressed'
        TabOrder = 8
      end
      object CBJobMoveWithoutConfirmation: TCheckBox
        Left = 10
        Top = 222
        Width = 369
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Job move without confirmation'
        TabOrder = 9
      end
      object GroupBox2: TGroupBox
        Left = 382
        Top = 55
        Width = 321
        Height = 205
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Split from this point with defaults'
        TabOrder = 10
        object Lbl2PreDefinedTime: TLabel
          Left = 16
          Top = 169
          Width = 129
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Pre-Defined-Time'
        end
        object RadioGroupRoundingCriteria: TRadioGroup
          Left = 15
          Top = 26
          Width = 241
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Rounding Criteria'
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Up'
            'Down')
          TabOrder = 0
        end
        object RGpSplitOnPreDefineTime: TRadioGroup
          Left = 15
          Top = 96
          Width = 299
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Split on a pre-defined time '
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'No '
            'Only '
            'Also')
          TabOrder = 1
        end
        object DateTimePickerTime: TDateTimePicker
          Left = 181
          Top = 165
          Width = 128
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Date = 40757.000000000000000000
          Time = 40757.000000000000000000
          Color = 14803425
          DateMode = dmUpDown
          Kind = dtkTime
          TabOrder = 2
          StyleName = 'datatex1'
        end
      end
      object CBRound: TComboBox
        Left = 603
        Top = 16
        Width = 61
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 11
        Text = '0'
        Items.Strings = (
          '0'
          '1'
          '2'
          '')
      end
      object CBWhenMoveShowErrorIfExists: TCheckBox
        Left = 10
        Top = 445
        Width = 562
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Position on error tab if error exists when job moves'
        TabOrder = 12
      end
      object CBDoNotAllowOverLapOnManual: TCheckBox
        Left = 10
        Top = 477
        Width = 562
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Do not allow overlap on manual scheduling'
        TabOrder = 13
      end
      object RGUnscheduleClosedJobs: TRadioGroup
        Left = 382
        Top = 300
        Width = 487
        Height = 65
        Caption = 'Automatically unschedule closed step jobs not  progressed'
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          'None'
          'All'
          'Sched. after today')
        TabOrder = 14
      end
      object CBNumOfDecimalForJobQtyOnStatusBar: TComboBox
        Left = 824
        Top = 268
        Width = 45
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 15
        Text = '0'
        Items.Strings = (
          '0'
          '1'
          '2')
      end
      object CBWarningWhenResCompChange: TCheckBox
        Left = 10
        Top = 509
        Width = 562
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 
          'Show Warning when maximum number of components is changed when j' +
          'ob moves'
        TabOrder = 16
      end
      object cbCapRes: TCheckBox
        Left = 10
        Top = 537
        Width = 562
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Capacity reservation/Downtime defined by Start/End'
        TabOrder = 17
      end
    end
    object TbsInfo: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Information displayed'
      ImageIndex = 4
      object GroupBox1: TGroupBox
        Left = 10
        Top = 146
        Width = 641
        Height = 131
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Display status and indication columns'
        TabOrder = 0
        OnClick = GroupBox1Click
        object ChkBCompat: TCheckBox
          Left = 10
          Top = 25
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Compatibility'
          TabOrder = 0
          StyleName = 'datatex1'
        end
        object ChKBLowDate: TCheckBox
          Left = 10
          Top = 54
          Width = 196
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Crossing earliest start date'
          TabOrder = 1
          StyleName = 'datatex1'
        end
        object ChkBHighDate: TCheckBox
          Left = 10
          Top = 84
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Crossing latest end date'
          TabOrder = 2
          StyleName = 'datatex1'
        end
        object ChKBOverlaps: TCheckBox
          Left = 215
          Top = 54
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Material warnings'
          TabOrder = 3
          StyleName = 'datatex1'
        end
        object ChkBMaterialDate: TCheckBox
          Left = 10
          Top = 107
          Width = 235
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Materials planned date - disabled !'
          TabOrder = 4
          Visible = False
          StyleName = 'datatex1'
        end
        object ChkBDeliveryDate: TCheckBox
          Left = 215
          Top = 25
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Crossing delivery date'
          TabOrder = 5
          StyleName = 'datatex1'
        end
        object ChkBStatus: TCheckBox
          Left = 215
          Top = 84
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Status'
          TabOrder = 6
          StyleName = 'datatex1'
        end
        object ChkBDatesWarn: TCheckBox
          Left = 411
          Top = 25
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Date warnings'
          TabOrder = 7
          StyleName = 'datatex1'
        end
        object CheckBJobMsg: TCheckBox
          Left = 411
          Top = 54
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Job messages'
          TabOrder = 8
          StyleName = 'datatex1'
        end
        object CBxShowBinPropColors: TCheckBox
          Left = 411
          Top = 85
          Width = 184
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'BIN property colors'
          TabOrder = 9
          StyleName = 'datatex1'
        end
      end
      object GBErrors: TGroupBox
        Left = 10
        Top = 17
        Width = 641
        Height = 117
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Display warnings'
        TabOrder = 1
        object ChkBDelDateW: TCheckBox
          Left = 215
          Top = 25
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Delivery date'
          TabOrder = 0
          StyleName = 'datatex1'
        end
        object ChkBMaterialsW: TCheckBox
          Left = 10
          Top = 25
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Materials'
          TabOrder = 1
          StyleName = 'datatex1'
        end
        object ChkBPrevStepQtyW: TCheckBox
          Left = 10
          Top = 54
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Steps overlap'
          TabOrder = 2
          StyleName = 'datatex1'
        end
        object ChkBLowestStartW: TCheckBox
          Left = 215
          Top = 54
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Earliest start date'
          TabOrder = 3
          StyleName = 'datatex1'
        end
        object ChkBOvlpW: TCheckBox
          Left = 411
          Top = 86
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Linked request overlap'
          TabOrder = 4
          Visible = False
          StyleName = 'datatex1'
        end
        object ChkBAddResW: TCheckBox
          Left = 10
          Top = 84
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Additional resources'
          TabOrder = 5
          StyleName = 'datatex1'
        end
        object ChkBHighEndW: TCheckBox
          Left = 215
          Top = 84
          Width = 191
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Latest end date'
          TabOrder = 6
          StyleName = 'datatex1'
        end
      end
      object RadioGroupReportFormat: TRadioGroup
        Left = 18
        Top = 289
        Width = 600
        Height = 74
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Report time format'
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          'Days:Hours:Minutes'
          'Minutes')
        TabOrder = 2
      end
      object RGCalDayFormat: TRadioGroup
        Left = 18
        Top = 372
        Width = 239
        Height = 83
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Calendar header day format'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Day'
          'Day/DD'
          'DD/MM'
          'MM/DD')
        TabOrder = 3
      end
      object GrpBoxMultiLineTabs: TGroupBox
        Left = 18
        Top = 463
        Width = 267
        Height = 59
        Caption = 'Multiline tabs'
        TabOrder = 4
        object CBGantt: TCheckBox
          Left = 12
          Top = 26
          Width = 101
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Gantt'
          TabOrder = 0
          StyleName = 'datatex1'
        end
        object CBbin: TCheckBox
          Left = 130
          Top = 26
          Width = 97
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Bin'
          TabOrder = 1
          StyleName = 'datatex1'
        end
      end
      object GroupBox7: TGroupBox
        Left = 264
        Top = 372
        Width = 577
        Height = 85
        Caption = 'Slot Display'
        TabOrder = 5
        StyleName = 'datatex1'
        object Label4: TLabel
          Left = 208
          Top = 28
          Width = 157
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Quantity multiplier property'
        end
        object LabelPropCustomeSymbol: TLabel
          Left = 416
          Top = 28
          Width = 103
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Symbol selection'
        end
        object rbQty: TRadioButton
          Left = 5
          Top = 28
          Width = 198
          Height = 17
          Caption = 'Total Scheduled Quantity'
          TabOrder = 0
          StyleName = 'datatex1'
          OnClick = rbQtyClick
        end
        object rbPerc: TRadioButton
          Left = 5
          Top = 51
          Width = 102
          Height = 21
          Caption = 'Percent'
          TabOrder = 1
          StyleName = 'datatex1'
          OnClick = rbPercClick
        end
        object cbQtyMultiProp: TComboBox
          Left = 210
          Top = 52
          Width = 151
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 2
          StyleName = 'datatex1'
        end
        object EditPropCustomSymbol: TEdit
          Left = 416
          Top = 52
          Width = 63
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          MaxLength = 3
          TabOrder = 3
        end
      end
      object rgFontSize: TRadioGroup
        Left = 292
        Top = 464
        Width = 205
        Height = 58
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Form'#39's font size'
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          'Small'
          'Big')
        TabOrder = 6
        OnClick = rgFontSizeClick
      end
    end
    object TabSheetCompetibleInBinFunction: TTabSheet
      Caption = 'Compatible in bin function'
      ImageIndex = 6
      object GBBinCompatible: TGroupBox
        Left = 3
        Top = 3
        Width = 483
        Height = 530
        Caption = 'Compatible in bin function'
        TabOrder = 0
        object Label5: TLabel
          Left = 20
          Top = 27
          Width = 333
          Height = 16
          AutoSize = False
          Caption = 'New tab for compatibles - suggested title name '
        end
        object RGCreateBewBinTabForCompatibles: TRadioGroup
          Left = 3
          Top = 92
          Width = 457
          Height = 154
          Caption = 'Create new bin tab for compatibles'
          ItemIndex = 0
          Items.Strings = (
            'No'
            'Yes - Show only compatibles and only "to schedule" jobs'
            'Yes - Mark the compatibles and show only "to schedule" jobs'
            'Yes - Show only compatibles')
          TabOrder = 0
        end
        object RGShowCompatibleInExistingBINS: TRadioGroup
          Left = 3
          Top = 270
          Width = 457
          Height = 134
          Caption = 'Show compatible In existing BINS'
          ItemIndex = 1
          Items.Strings = (
            'No'
            'Yes - Mark the compatibles'
            'Yes - Show only compatibles')
          TabOrder = 1
        end
        object MiJobSequenceTabNameSuggested: TEdit
          Left = 20
          Top = 50
          Width = 170
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 2
        end
        object RGWhowScheduledOfSelectedResource: TRadioGroup
          Left = 3
          Top = 426
          Width = 457
          Height = 86
          Caption = 'Show scheduled jobs of the selected resource'
          ItemIndex = 0
          Items.Strings = (
            'No'
            'Yes ')
          TabOrder = 3
        end
      end
    end
    object TBSBinProp: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Properties selection'
      object PageControlProperty: TPageControl
        Left = 0
        Top = 0
        Width = 888
        Height = 576
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ParentCustomHint = False
        ActivePage = TsViewProperty
        Align = alClient
        OwnerDraw = True
        TabOrder = 0
        OnChange = PageControlPropertyChange
        object TsViewProperty: TTabSheet
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Bin properties for the work station'
        end
        object TsPropertyAsDate: TTabSheet
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Input as date properties for all'
          ImageIndex = 1
          ParentShowHint = False
          ShowHint = False
        end
        object TsPropertyAsRGB: TTabSheet
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Input as RGB properties for all'
          ImageIndex = 2
        end
        object TSAssignedProperty: TTabSheet
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Assigned properties '
          ImageIndex = 2
          object LblPropAsApprovalDate: TLabel
            Left = 38
            Top = 199
            Width = 156
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Property as approval date'
          end
          object LblAssignedBooleanProp1: TLabel
            Left = 38
            Top = 263
            Width = 109
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Selection property'
          end
          object GBAssignedLimitGrpByCount1: TGroupBox
            Left = 17
            Top = 20
            Width = 345
            Height = 162
            Caption = 'Limit group by count 1'
            TabOrder = 0
            object LblAssignedLimitCount1: TLabel
              Left = 16
              Top = 28
              Width = 60
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Count limit'
            end
            object LblPropertyForValueCompare1: TLabel
              Left = 16
              Top = 91
              Width = 162
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Property for value compare'
            end
            object CBAssignedLimitCount1: TComboBox
              Left = 16
              Top = 52
              Width = 179
              Height = 24
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              Color = 14803425
              TabOrder = 0
              StyleName = 'datatex1'
            end
            object CBAssignedForValueCompareGrpLimit1: TComboBox
              Left = 16
              Top = 114
              Width = 179
              Height = 24
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              Color = 14803425
              TabOrder = 1
              StyleName = 'datatex1'
            end
            object BtnAssignedLimitCount1: TcxButton
              Left = 210
              Top = 52
              Width = 92
              Height = 31
              Caption = 'Clear'
              TabOrder = 2
              OnClick = BtnAssignedLimitCountClick
            end
            object BtnAssignedForValueCompareGrpLimit1: TcxButton
              Left = 210
              Top = 114
              Width = 92
              Height = 31
              Caption = 'Clear'
              TabOrder = 3
              OnClick = BtnAssignedForValueCompareGrpLimitClick
            end
          end
          object GBAssignedLimitGrpByCount2: TGroupBox
            Left = 391
            Top = 20
            Width = 345
            Height = 162
            Caption = 'Limit group by count 2'
            TabOrder = 1
            object LblAssignedLimitCount2: TLabel
              Left = 16
              Top = 28
              Width = 60
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Count limit'
            end
            object LblPropertyForValueCompare2: TLabel
              Left = 16
              Top = 91
              Width = 162
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Property for value compare'
            end
            object CBAssignedLimitCount2: TComboBox
              Left = 14
              Top = 52
              Width = 179
              Height = 24
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              Color = 14803425
              TabOrder = 0
              StyleName = 'datatex1'
            end
            object CBAssignedForValueCompareGrpLimit2: TComboBox
              Left = 16
              Top = 114
              Width = 179
              Height = 24
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              Color = 14803425
              TabOrder = 1
              StyleName = 'datatex1'
            end
            object BtnAssignedLimitCount2: TcxButton
              Left = 210
              Top = 52
              Width = 92
              Height = 31
              Caption = 'Clear'
              TabOrder = 2
              OnClick = BtnAssignedLimitCountClick
            end
            object BtnAssignedForValueCompareGrpLimit2: TcxButton
              Left = 210
              Top = 114
              Width = 92
              Height = 31
              Caption = 'Clear'
              TabOrder = 3
              OnClick = BtnAssignedForValueCompareGrpLimitClick
            end
          end
          object CBApprovalDateProp: TComboBox
            Left = 33
            Top = 226
            Width = 179
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = csDropDownList
            Color = 14803425
            TabOrder = 2
          end
          object CBAssignedBooleanProp1: TComboBox
            Left = 33
            Top = 285
            Width = 179
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = csDropDownList
            Color = 14803425
            TabOrder = 3
          end
          object ButtonCBAssignedBooleanProp1: TcxButton
            Left = 227
            Top = 285
            Width = 92
            Height = 31
            Caption = 'Clear'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            Font.Quality = fqClearType
            ParentFont = False
            TabOrder = 5
            OnClick = ButtonCBAssignedBooleanProp1Click
          end
          object ButtonApprovalDateProp: TcxButton
            Left = 227
            Top = 285
            Width = 92
            Height = 31
            Caption = 'Clear'
            TabOrder = 4
            OnClick = ButtonApprovalDatePropClick
          end
        end
        object TSHighestEndOverride: TTabSheet
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Highest end date override'
          ImageIndex = 4
          object LblCalculatedHighestEnd: TLabel
            Left = 21
            Top = 10
            Width = 136
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Calculated highest end'
          end
          object CBCalculatedHighestEnd: TComboBox
            Left = 18
            Top = 37
            Width = 179
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = csDropDownList
            Color = 14803425
            TabOrder = 0
          end
          object GBSetjobslimitdates: TGroupBox
            Left = 17
            Top = 82
            Width = 286
            Height = 98
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Set jobs limit dates using : '
            TabOrder = 1
            object LblCapacity: TLabel
              Left = 22
              Top = 30
              Width = 68
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Capacity %'
            end
            object LblSecureNumberDays: TLabel
              Left = 23
              Top = 70
              Width = 138
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Secure number of days'
            end
            object EdtCapacity: TEdit
              Left = 195
              Top = 28
              Width = 63
              Height = 24
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Color = 14803425
              MaxLength = 3
              TabOrder = 0
              OnKeyPress = EdtCapacityKeyPress
            end
            object EdtScureNumberOfDays: TEdit
              Left = 194
              Top = 64
              Width = 64
              Height = 24
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Color = 14803425
              MaxLength = 3
              TabOrder = 1
              OnKeyPress = EdtCapacityKeyPress
            end
          end
          object BtnCalculatedHighestEnd: TcxButton
            Left = 218
            Top = 37
            Width = 92
            Height = 31
            Caption = 'Clear'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            Font.Quality = fqClearType
            ParentFont = False
            TabOrder = 2
            OnClick = BtnCalculatedHighestEndClick
          end
        end
      end
    end
    object TBSresFilter: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resource filter'
      ImageIndex = 2
      object ChkSort: TCheckBox
        Left = 20
        Top = 30
        Width = 257
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Sort when moving jobs on plan'
        TabOrder = 0
      end
      object GPBfilter: TGroupBox
        Left = 10
        Top = 128
        Width = 543
        Height = 159
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Filter selection'
        TabOrder = 1
        object ChkFilterRead: TCheckBox
          Left = 10
          Top = 30
          Width = 363
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Don'#39't show read-only resources'
          TabOrder = 0
        end
        object ChkWorkcenter: TCheckBox
          Left = 10
          Top = 59
          Width = 363
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Don'#39't show workcenter not compatible'
          TabOrder = 1
        end
        object ChkNoTimings: TCheckBox
          Left = 10
          Top = 89
          Width = 363
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Don'#39't show no timings resources'
          TabOrder = 2
        end
        object ChkNoCompat: TCheckBox
          Left = 10
          Top = 118
          Width = 363
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Don'#39't show not compatible resources'
          TabOrder = 3
        end
      end
      object ChkKeepSort: TCheckBox
        Left = 20
        Top = 69
        Width = 208
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Keep sorting'
        TabOrder = 2
      end
    end
    object TabSheet1: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Automatic operation'
      ImageIndex = 5
      object GroupBox3: TGroupBox
        Left = 373
        Top = 10
        Width = 208
        Height = 218
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Enter a new set'
        TabOrder = 0
        object LblNewSetName: TLabel
          Left = 30
          Top = 59
          Width = 147
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Enter new set name:'
        end
        object EditNewSetName: TEdit
          Left = 30
          Top = 89
          Width = 148
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 0
        end
        object BtnSaveNewSet: TcxButton
          Left = 30
          Top = 120
          Width = 147
          Height = 30
          Caption = 'Create new set'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 1
          OnClick = BtnSaveNewSetClick
        end
      end
      object GroupBox4: TGroupBox
        Left = 20
        Top = 10
        Width = 316
        Height = 218
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Available sets'
        TabOrder = 1
        object LBListOfSets: TListBox
          Left = 30
          Top = 20
          Width = 148
          Height = 178
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 0
        end
        object BitDeleteSet: TcxButton
          Left = 194
          Top = 30
          Width = 93
          Height = 30
          Caption = 'Delete set'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 1
          OnClick = BitDeleteSetClick
        end
        object BitOpenSet: TcxButton
          Left = 194
          Top = 66
          Width = 93
          Height = 30
          Caption = 'Open set'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 2
          OnClick = BitOpenSetClick
        end
      end
    end
    object TabSheetMailInfo: TTabSheet
      Caption = 'Mail settings'
      ImageIndex = 5
      object GrBMailConfig: TGroupBox
        Left = 3
        Top = 16
        Width = 775
        Height = 495
        Caption = 'Configuration'
        TabOrder = 0
        object LblSMTPServer: TLabel
          Left = 21
          Top = 44
          Width = 92
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'SMTP Server'
        end
        object LblPort: TLabel
          Left = 21
          Top = 82
          Width = 81
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Port'
        end
        object EditSmtpServer: TEdit
          Left = 115
          Top = 40
          Width = 184
          Height = 24
          Color = 14803425
          TabOrder = 0
        end
        object EditPort: TEdit
          Left = 115
          Top = 78
          Width = 184
          Height = 24
          Color = 14803425
          TabOrder = 1
        end
        object CBLoginSecureAutenthication: TCheckBox
          Left = 337
          Top = 41
          Width = 361
          Height = 22
          Caption = 'Login with secure password authentication '
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object CB_TLS_SSL_Enabled: TCheckBox
          Left = 337
          Top = 78
          Width = 162
          Height = 20
          Caption = 'TLS SSL Enabled'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object PageControlMailList: TPageControl
          Left = 12
          Top = 315
          Width = 752
          Height = 128
          TabOrder = 4
        end
        object TPanel
          Left = 57
          Top = 128
          Width = 110
          Height = 30
          BevelOuter = bvNone
          Caption = 'Create new set'
          Color = 15972184
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentBackground = False
          ParentFont = False
          TabOrder = 5
          OnClick = BtnSaveNewSetClick
        end
      end
      object GroupBox5: TGroupBox
        Left = 374
        Top = 139
        Width = 236
        Height = 187
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Enter a new set mail'
        TabOrder = 1
        object Label3: TLabel
          Left = 15
          Top = 29
          Width = 119
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Enter new set name:'
        end
        object EditMailSet: TEdit
          Left = 15
          Top = 59
          Width = 170
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 0
        end
        object NewSetMailList: TcxButton
          Left = 15
          Top = 90
          Width = 170
          Height = 30
          Caption = 'Create new mail set'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 1
          OnClick = NewSetMailListClick
        end
      end
      object GroupBox6: TGroupBox
        Left = 19
        Top = 138
        Width = 316
        Height = 189
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Available sets'
        TabOrder = 2
        object ListBoxCodeMail: TListBox
          Left = 30
          Top = 20
          Width = 148
          Height = 153
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 0
          OnClick = ListBoxCodeMailClick
        end
        object BitBtnDltMAilSet: TcxButton
          Left = 194
          Top = 32
          Width = 93
          Height = 30
          Caption = 'Delete set'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 1
          OnClick = BitBtnDltMAilSetClick
        end
        object BitBtOpenSetMail: TcxButton
          Left = 194
          Top = 68
          Width = 93
          Height = 30
          Caption = 'Open set'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 2
          OnClick = BitBtOpenSetMailClick
        end
      end
      object ButtonCheckMail: TcxButton
        Left = 15
        Top = 513
        Width = 155
        Height = 30
        Caption = 'Test send email'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 3
        OnClick = ButtonCheckMailClick
      end
    end
    object TabSheetPopupItems: TTabSheet
      Caption = 'Menu'#39's'
      ImageIndex = 7
      object Splitter2: TSplitter
        Left = 349
        Top = 0
        Height = 576
        ExplicitLeft = 519
        ExplicitTop = -3
        ExplicitHeight = 559
      end
      object Splitter3: TSplitter
        Left = 161
        Top = 0
        Height = 576
        ExplicitLeft = 154
        ExplicitTop = -16
        ExplicitHeight = 559
      end
      object Splitter4: TSplitter
        Left = 600
        Top = 0
        Height = 576
        ExplicitLeft = 535
        ExplicitTop = -3
        ExplicitHeight = 559
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 161
        Height = 576
        Align = alLeft
        Caption = 'Panel1'
        TabOrder = 0
        object clbRes: TCheckListBox
          Left = 1
          Top = 25
          Width = 159
          Height = 550
          Align = alClient
          TabOrder = 0
          OnClickCheck = clbResClickCheck
        end
        object Panel4: TPanel
          Left = 1
          Top = 1
          Width = 159
          Height = 24
          Align = alTop
          Caption = 'Resource'
          TabOrder = 1
        end
      end
      object Panel5: TPanel
        Left = 352
        Top = 0
        Width = 248
        Height = 576
        Align = alLeft
        Caption = 'Panel1'
        TabOrder = 1
        object clbActArea: TCheckListBox
          Left = 1
          Top = 25
          Width = 246
          Height = 550
          Align = alClient
          TabOrder = 0
          OnClickCheck = clbResClickCheck
        end
        object Panel6: TPanel
          Left = 1
          Top = 1
          Width = 246
          Height = 24
          Align = alTop
          Caption = 'Gantt'
          TabOrder = 1
        end
      end
      object Panel9: TPanel
        Left = 603
        Top = 0
        Width = 285
        Height = 576
        Align = alClient
        TabOrder = 2
        object Panel10: TPanel
          Left = 1
          Top = 1
          Width = 283
          Height = 24
          Align = alTop
          Caption = 'Bin'
          TabOrder = 0
        end
        object clbBin: TCheckListBox
          Left = 1
          Top = 25
          Width = 283
          Height = 550
          Align = alClient
          TabOrder = 1
          OnClickCheck = clbResClickCheck
        end
      end
      object Panel11: TPanel
        Left = 164
        Top = 0
        Width = 185
        Height = 576
        Align = alLeft
        Caption = 'Panel11'
        TabOrder = 3
        object Panel7: TPanel
          Left = 1
          Top = 1
          Width = 183
          Height = 574
          Align = alClient
          Caption = 'Panel1'
          TabOrder = 0
          object clbJob: TCheckListBox
            Left = 1
            Top = 25
            Width = 181
            Height = 548
            Align = alClient
            TabOrder = 0
            OnClickCheck = clbResClickCheck
          end
          object Panel8: TPanel
            Left = 1
            Top = 1
            Width = 181
            Height = 24
            Align = alTop
            Caption = 'Job'
            TabOrder = 1
          end
        end
      end
    end
  end
end
