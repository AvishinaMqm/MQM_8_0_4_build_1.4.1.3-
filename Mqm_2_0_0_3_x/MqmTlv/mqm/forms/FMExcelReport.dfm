object FExcelReport: TFExcelReport
  Left = 1064
  Top = 433
  Caption = 'Excel Report Settings'
  ClientHeight = 404
  ClientWidth = 698
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 352
    Width = 698
    Height = 52
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object BtnClose: TcxButton
      Left = 499
      Top = 7
      Width = 95
      Height = 30
      Caption = 'Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BtnCloseClick
    end
    object BtnSave: TcxButton
      Left = 6
      Top = 7
      Width = 93
      Height = 30
      Caption = 'Save'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnSaveClick
    end
    object BitOk: TcxButton
      Left = 105
      Top = 7
      Width = 93
      Height = 30
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 2
      OnClick = BitOkClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 698
    Height = 352
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TabSheetSettings
    Align = alClient
    TabOrder = 1
    object TabSheetSettings: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Settings'
      object LabTitle: TLabel
        Left = 30
        Top = 31
        Width = 26
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Title'
      end
      object LabelSortCrit: TLabel
        Left = 21
        Top = 71
        Width = 153
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Number of grouping fields'
      end
      object LblColumn: TLabel
        Left = 272
        Top = 209
        Width = 45
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Column'
      end
      object CBBinCaption: TCheckBox
        Left = 21
        Top = 129
        Width = 182
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show Bin Caption'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = CBBinCaptionClick
      end
      object EditTitle: TEdit
        Left = 62
        Top = 27
        Width = 296
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 1
        OnChange = EditTitleChange
      end
      object CBSelection: TCheckBox
        Left = 21
        Top = 160
        Width = 182
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show Selection Criteria'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = CBSelectionClick
      end
      object CBUnschedJobs: TCheckBox
        Left = 21
        Top = 185
        Width = 188
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Include Unscheduled Jobs'
        TabOrder = 3
        Visible = False
        OnClick = CBUnschedJobsClick
      end
      object CBDowntime: TCheckBox
        Left = 211
        Top = 160
        Width = 226
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Include Downtimes in statistics'
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = CBDowntimeClick
      end
      object ComBoxSortCrits: TComboBox
        Left = 194
        Top = 66
        Width = 50
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 5
        OnChange = ComBoxSortCritsChange
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4')
      end
      object CBResources: TCheckBox
        Left = 211
        Top = 129
        Width = 173
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Resource in heading'
        Checked = True
        State = cbChecked
        TabOrder = 6
        OnClick = CBResourcesClick
      end
      object CBNewPagePerRes: TCheckBox
        Left = 21
        Top = 98
        Width = 182
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Break for new resource'
        TabOrder = 7
        OnClick = CBNewPagePerResClick
      end
      object CBGroups: TCheckBox
        Left = 211
        Top = 98
        Width = 188
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show group attributes'
        TabOrder = 8
        OnClick = CBGroupsClick
      end
      object CckBxPrintComments: TCheckBox
        Left = 21
        Top = 209
        Width = 236
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Include comments/instructions'
        TabOrder = 9
        OnClick = CBUnschedJobsClick
      end
      object CmbBxColumn: TComboBox
        Left = 324
        Top = 204
        Width = 60
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        ItemIndex = 1
        MaxLength = 2
        TabOrder = 10
        Text = '1'
        OnChange = ComBoxSortCritsChange
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4')
      end
      object CBShowColumnsCaptions: TCheckBox
        Left = 445
        Top = 129
        Width = 176
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show Columns captions'
        Checked = True
        State = cbChecked
        TabOrder = 11
        OnClick = CBShowColumnsCaptionsClick
      end
      object CBShowTotal: TCheckBox
        Left = 445
        Top = 160
        Width = 122
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show totals'
        Checked = True
        State = cbChecked
        TabOrder = 12
        OnClick = CBShowTotalClick
      end
      object GBHeadingConcatenation: TGroupBox
        Left = 313
        Top = 236
        Width = 277
        Height = 69
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Concatenation Heading'
        TabOrder = 13
        object LblHeadingSeparator: TLabel
          Left = 158
          Top = 30
          Width = 60
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Separator'
        end
        object CBHeadingConcatenation: TCheckBox
          Left = 18
          Top = 28
          Width = 119
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Concatenate'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CBHeadingConcatenationClick
        end
        object EditHeadingSeparator: TEdit
          Left = 225
          Top = 25
          Width = 31
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          MaxLength = 1
          TabOrder = 1
          OnChange = EditHeadingSeparatorChange
          OnClick = EditSeparatorClick
        end
      end
      object GBConcatenation: TGroupBox
        Left = 11
        Top = 236
        Width = 277
        Height = 69
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Concatenation'
        TabOrder = 14
        object LblSeparator: TLabel
          Left = 158
          Top = 30
          Width = 60
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Separator'
        end
        object CBContcatenation: TCheckBox
          Left = 18
          Top = 28
          Width = 119
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Concatenate'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CBContcatenationClick
        end
        object EditSeparator: TEdit
          Left = 225
          Top = 25
          Width = 31
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          MaxLength = 1
          TabOrder = 1
          OnChange = EditSeparatorChange
          OnClick = EditSeparatorClick
        end
      end
    end
    object TabSheetFixedColumn: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Fixed columns'
      ImageIndex = 1
      object CBBinColumn1: TComboBox
        Left = 11
        Top = 17
        Width = 243
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Color = 14803425
        TabOrder = 0
      end
      object CBBinColumn2: TComboBox
        Left = 11
        Top = 62
        Width = 243
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Color = 14803425
        TabOrder = 1
      end
      object CBBinColumn3: TComboBox
        Left = 11
        Top = 105
        Width = 243
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Color = 14803425
        TabOrder = 2
      end
      object CBBinColumn4: TComboBox
        Left = 11
        Top = 148
        Width = 243
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Color = 14803425
        TabOrder = 3
      end
      object CBBinColumn5: TComboBox
        Left = 10
        Top = 192
        Width = 242
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Color = 14803425
        TabOrder = 4
      end
      object CBBinColumn6: TComboBox
        Left = 361
        Top = 17
        Width = 218
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Color = 14803425
        TabOrder = 5
      end
      object CBBinColumn7: TComboBox
        Left = 361
        Top = 62
        Width = 218
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Color = 14803425
        TabOrder = 6
      end
      object CBBinColumn8: TComboBox
        Left = 361
        Top = 105
        Width = 218
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Color = 14803425
        TabOrder = 7
      end
      object CBBinColumn9: TComboBox
        Left = 361
        Top = 148
        Width = 218
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Color = 14803425
        TabOrder = 8
      end
      object CBBinColumn10: TComboBox
        Left = 359
        Top = 192
        Width = 219
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Color = 14803425
        TabOrder = 9
      end
      object BTnClearBinColumn1: TcxButton
        Left = 261
        Top = 17
        Width = 93
        Height = 30
        Caption = 'Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 10
        OnClick = BTnClearBinColumn1Click
      end
      object BTnClearBinColumn2: TcxButton
        Left = 261
        Top = 62
        Width = 93
        Height = 30
        Caption = 'Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 11
        OnClick = BTnClearBinColumn1Click
      end
      object BTnClearBinColumn3: TcxButton
        Left = 261
        Top = 105
        Width = 93
        Height = 30
        Caption = 'Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 12
        OnClick = BTnClearBinColumn1Click
      end
      object BTnClearBinColumn4: TcxButton
        Left = 261
        Top = 148
        Width = 93
        Height = 30
        Caption = 'Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 13
        OnClick = BTnClearBinColumn1Click
      end
      object BTnClearBinColumn5: TcxButton
        Left = 259
        Top = 192
        Width = 93
        Height = 30
        Caption = 'Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 14
        OnClick = BTnClearBinColumn1Click
      end
      object BTnClearBinColumn6: TcxButton
        Left = 586
        Top = 17
        Width = 93
        Height = 30
        Caption = 'Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 15
        OnClick = BTnClearBinColumn1Click
      end
      object BTnClearBinColumn7: TcxButton
        Left = 586
        Top = 62
        Width = 93
        Height = 30
        Caption = 'Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 16
        OnClick = BTnClearBinColumn1Click
      end
      object BTnClearBinColumn8: TcxButton
        Left = 586
        Top = 105
        Width = 93
        Height = 30
        Caption = 'Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 17
        OnClick = BTnClearBinColumn1Click
      end
      object BTnClearBinColumn9: TcxButton
        Left = 586
        Top = 148
        Width = 93
        Height = 30
        Caption = 'Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 18
        OnClick = BTnClearBinColumn1Click
      end
      object BTnClearBinColumn10: TcxButton
        Left = 585
        Top = 192
        Width = 93
        Height = 30
        Caption = 'Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 19
        OnClick = BTnClearBinColumn1Click
      end
    end
    object Tabattributes: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Attributes selection'
      ImageIndex = 2
      TabVisible = False
      object ComBoAttribute: TComboBox
        Left = 27
        Top = 27
        Width = 239
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        TabOrder = 0
      end
    end
    object TabSheetPeriodMachine: TTabSheet
      Caption = 'Period machine'
      ImageIndex = 3
      object Label1: TLabel
        Left = 26
        Top = 21
        Width = 26
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Title'
      end
      object LabelPeriod: TLabel
        Left = 27
        Top = 75
        Width = 40
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Period'
      end
      object LabelFrom: TLabel
        Left = 27
        Top = 123
        Width = 31
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'From'
      end
      object Label2: TLabel
        Left = 27
        Top = 171
        Width = 111
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Number of periods'
      end
      object LblFileNameByAutoRun: TLabel
        Left = 27
        Top = 256
        Width = 198
        Height = 16
        Caption = 'File name for automatic operation'
      end
      object LBLTodayMinusDays: TLabel
        Left = 243
        Top = 123
        Width = 113
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Today Minus Days'
      end
      object EditPeriodMachineTitle: TEdit
        Left = 62
        Top = 16
        Width = 341
        Height = 24
        Color = 14803425
        TabOrder = 0
        Text = 'Resource period report'
      end
      object CBoxPeriod: TComboBox
        Left = 78
        Top = 70
        Width = 145
        Height = 24
        Style = csDropDownList
        Color = 14803425
        ItemIndex = 1
        TabOrder = 1
        Text = 'Week'
        OnChange = CBoxPeriodChange
        Items.Strings = (
          'Day'
          'Week'
          'Month')
      end
      object CBoxFrom: TComboBox
        Left = 78
        Top = 120
        Width = 145
        Height = 24
        Style = csDropDownList
        Color = 14803425
        ItemIndex = 0
        TabOrder = 2
        Text = 'Today'
        OnClick = CBoxFromClick
        Items.Strings = (
          'Today'
          'Next Period')
      end
      object EditNumberOfPeriods: TEdit
        Left = 153
        Top = 167
        Width = 41
        Height = 24
        Color = 14803425
        MaxLength = 2
        TabOrder = 3
        Text = '3'
        OnKeyPress = EditNumberOfPeriodsKeyPress
      end
      object CBShowFromTo: TCheckBox
        Left = 26
        Top = 217
        Width = 210
        Height = 17
        Caption = 'Show from/to date header  '
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object EditMachinePeriodFileName: TEdit
        Left = 27
        Top = 278
        Width = 159
        Height = 24
        Color = 14803425
        MaxLength = 25
        TabOrder = 5
        Text = 'Resource period '
      end
      object EditTodayMinusDays: TEdit
        Left = 377
        Top = 121
        Width = 41
        Height = 24
        Color = 14803425
        MaxLength = 2
        TabOrder = 6
        Text = '0'
        OnKeyPress = EditNumberOfPeriodsKeyPress
      end
    end
  end
end
