object AutoSeqOverridingParams: TAutoSeqOverridingParams
  Left = 0
  Top = 0
  Caption = 'Overriding parameters'
  ClientHeight = 638
  ClientWidth = 976
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 17
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 976
    Height = 584
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TabSheetRules
    Align = alClient
    TabOrder = 0
    object TabSheetRules: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Rules'
      object LblLimitToWorkCenter: TLabel
        Left = 21
        Top = 55
        Width = 143
        Height = 17
        Caption = 'Limit to work center   : '
      end
      object GBSchedRange: TGroupBox
        Left = 16
        Top = 209
        Width = 920
        Height = 159
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Schedule Range'
        TabOrder = 0
        object Label9: TLabel
          Left = 595
          Top = 94
          Width = 287
          Height = 17
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Tolerance in days/hours/minutes for latest date'
        end
        object Label10: TLabel
          Left = 595
          Top = 27
          Width = 296
          Height = 17
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Tolerance in days/hours/minutes for earliest date'
        end
        object SEdtAfterLatDays: TExSpinEdit
          Left = 595
          Top = 116
          Width = 65
          Height = 27
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          MaxLength = 3
          MaxValue = 100
          MinValue = 0
          TabOrder = 3
          Value = 0
        end
        object SEdtBefEarlDays: TExSpinEdit
          Left = 595
          Top = 51
          Width = 65
          Height = 27
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          MaxLength = 3
          MaxValue = 100
          MinValue = 0
          TabOrder = 1
          Value = 0
        end
        object RGBeforeEarlDate: TRadioGroup
          Left = 16
          Top = 25
          Width = 570
          Height = 56
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Before earliest date'
          Columns = 4
          ItemIndex = 0
          Items.Strings = (
            'Default settings'
            'Allowed'
            'Within tolerance'
            'Not allowed')
          TabOrder = 0
          OnClick = RGBeforeEarlDateClick
        end
        object RGAfterLatDate: TRadioGroup
          Left = 15
          Top = 90
          Width = 571
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'After latest date'
          Columns = 4
          ItemIndex = 0
          Items.Strings = (
            'Default settings'
            'Allowed'
            'Within tolerance'
            'Not allowed')
          TabOrder = 2
          OnClick = RGAfterLatDateClick
        end
        object SEdtBefEarlHours: TExSpinEdit
          Left = 690
          Top = 51
          Width = 64
          Height = 27
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          MaxLength = 3
          MaxValue = 24
          MinValue = 0
          TabOrder = 4
          Value = 0
        end
        object SEdtBefEarlMinutes: TExSpinEdit
          Left = 784
          Top = 51
          Width = 64
          Height = 27
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          MaxLength = 3
          MaxValue = 60
          MinValue = 0
          TabOrder = 5
          Value = 0
        end
        object SEdtAfterLatHours: TExSpinEdit
          Left = 690
          Top = 116
          Width = 64
          Height = 27
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          MaxLength = 3
          MaxValue = 24
          MinValue = 0
          TabOrder = 6
          Value = 0
        end
        object SEdtAfterLatMinutes: TExSpinEdit
          Left = 784
          Top = 116
          Width = 64
          Height = 27
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          MaxLength = 3
          MaxValue = 60
          MinValue = 0
          TabOrder = 7
          Value = 0
        end
      end
      object CBUnscheduleBefore: TCheckBox
        Left = 183
        Top = 20
        Width = 189
        Height = 17
        Caption = 'Unschedule before'
        TabOrder = 1
      end
      object CBInfiniteCapacity: TCheckBox
        Left = 17
        Top = 20
        Width = 160
        Height = 17
        Caption = 'Infinite capacity'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object GroupBox1: TGroupBox
        Left = 16
        Top = 373
        Width = 920
        Height = 173
        Caption = 'Requirements'
        TabOrder = 3
        object RGSchedWOMaterials: TRadioGroup
          Left = 8
          Top = 25
          Width = 399
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Schedule without materials'
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Default settings'
            'Allowed'
            'Not allowed')
          TabOrder = 0
        end
        object RGSchedWOAddResources: TRadioGroup
          Left = 8
          Top = 92
          Width = 399
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Schedule without additional resources'
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Default settings'
            'Allowed'
            'Not allowed')
          TabOrder = 1
        end
        object RGIgnoreRightOverlapping: TRadioGroup
          Left = 421
          Top = 25
          Width = 412
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Ignore right overlapping'
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Default settings'
            'No'
            'Yes')
          TabOrder = 2
        end
        object RGIgnoreLeftOverlapping: TRadioGroup
          Left = 421
          Top = 92
          Width = 412
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Ignore left overlapping'
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Default settings'
            'No'
            'Yes')
          TabOrder = 3
        end
      end
      object GBForcedDateSelection: TGroupBox
        Left = 17
        Top = 94
        Width = 828
        Height = 118
        Caption = 'Dates'
        TabOrder = 4
        object LblFrameBegin: TLabel
          Left = 13
          Top = 27
          Width = 75
          Height = 17
          Caption = 'Frame begin'
        end
        object LblFrameEnd: TLabel
          Left = 13
          Top = 55
          Width = 65
          Height = 17
          Caption = 'Frame end'
        end
        object CBScheduleWithinTheFram: TCheckBox
          Left = 417
          Top = 27
          Width = 261
          Height = 17
          Caption = 'Schedule jobs within the frame ?'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CBScheduleWithinTheFramClick
        end
        object DatePickerWcFrom: TDateTimePicker
          Left = 101
          Top = 23
          Width = 144
          Height = 25
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Date = 40794.000000000000000000
          Time = 0.526865069441555500
          Color = 14803425
          TabOrder = 1
        end
        object CBShorterJobsEndAfterFramEnd: TCheckBox
          Left = 417
          Top = 57
          Width = 344
          Height = 17
          Caption = 'Shorter jobs can end after the frame end ? '
          TabOrder = 2
        end
        object DateWcPickerToDate: TDateTimePicker
          Left = 101
          Top = 55
          Width = 144
          Height = 25
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Date = 40794.000000000000000000
          Time = 0.526865069441555500
          Color = 14803425
          TabOrder = 3
        end
        object TimeWcFromPicker: TDateTimePicker
          Left = 254
          Top = 23
          Width = 130
          Height = 25
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Date = 38837.000000000000000000
          Time = 38837.000000000000000000
          Color = 14803425
          Kind = dtkTime
          TabOrder = 4
        end
        object TimePickerWcTo: TDateTimePicker
          Left = 254
          Top = 56
          Width = 130
          Height = 25
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Date = 38837.000000000000000000
          Time = 0.999988425923220300
          Color = 14803425
          Kind = dtkTime
          TabOrder = 5
        end
        object CBLargerJobsCanStartAfterFrameBegins: TCheckBox
          Left = 417
          Top = 87
          Width = 340
          Height = 17
          Caption = 'Larger jobs can start after frame begins ?'
          TabOrder = 6
        end
      end
      object CBSelectedWc: TCheckBox
        Left = 183
        Top = 56
        Width = 170
        Height = 17
        Caption = 'Work center selected'
        TabOrder = 5
        OnClick = CBSelectedWcClick
      end
      object GBAutoSeqConfig: TGroupBox
        Left = 424
        Top = 4
        Width = 260
        Height = 93
        Caption = 'Automatic sequencing configurations'
        TabOrder = 6
        object CombBoxCfg: TComboBox
          Left = 16
          Top = 26
          Width = 189
          Height = 25
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          TabOrder = 0
          OnChange = CombBoxCfgChange
        end
        object CBWorkCenterConfiguration: TCheckBox
          Left = 15
          Top = 63
          Width = 225
          Height = 17
          Caption = 'By work center configuration'
          TabOrder = 1
          OnClick = CBWorkCenterConfigurationClick
          OnMouseLeave = CBWorkCenterConfigurationMouseLeave
        end
      end
      object CBLinkedReq: TCheckBox
        Left = 706
        Top = 71
        Width = 215
        Height = 17
        Caption = 'Allowed move linked request'
        TabOrder = 7
        OnClick = CBLinkedReqClick
      end
      object cbWCList: TcxListBox
        Left = 183
        Top = 55
        Width = 154
        Height = 40
        ItemHeight = 17
        TabOrder = 8
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 584
    Width = 976
    Height = 54
    Align = alBottom
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      976
      54)
    object BtnAbo: TBitBtn
      Left = 676
      Top = 4
      Width = 97
      Height = 36
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Kind = bkAbort
      NumGlyphs = 2
      TabOrder = 0
      Visible = False
    end
    object BitBtn1: TBitBtn
      Left = 570
      Top = 8
      Width = 98
      Height = 36
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      Visible = False
    end
    object BtnOk: TcxButton
      Left = 16
      Top = 7
      Width = 93
      Height = 36
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 2
      OnClick = BtnOkClick
    end
    object btnAbort: TcxButton
      Left = 134
      Top = 7
      Width = 95
      Height = 36
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 3
      OnClick = btnAbortClick
    end
  end
end
