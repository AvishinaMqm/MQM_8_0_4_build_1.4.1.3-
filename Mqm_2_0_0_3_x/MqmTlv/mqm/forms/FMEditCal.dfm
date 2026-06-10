object MEditCal: TMEditCal
  Left = 142
  Top = 35
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 1
  Caption = 'Edit calendar'
  ClientHeight = 501
  ClientWidth = 953
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  TextHeight = 13
  object grbActual: TGroupBox
    Left = 0
    Top = 160
    Width = 885
    Height = 104
    Caption = 'Actual values'
    TabOrder = 0
    object grbActual1: TGroupBox
      Left = 8
      Top = 24
      Width = 185
      Height = 73
      Caption = 'First shift'
      TabOrder = 0
      object lblFrom: TLabel
        Left = 11
        Top = 21
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label2: TLabel
        Left = 11
        Top = 45
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object stActual1From: TStaticText
        Left = 60
        Top = 21
        Width = 110
        Height = 17
        AutoSize = False
        Caption = 'stActual1From'
        TabOrder = 0
      end
      object stActual1To: TStaticText
        Left = 60
        Top = 45
        Width = 110
        Height = 17
        AutoSize = False
        Caption = 'stActual1To'
        TabOrder = 1
      end
    end
    object grbActual2: TGroupBox
      Left = 200
      Top = 24
      Width = 185
      Height = 73
      Caption = 'Second shift'
      TabOrder = 1
      object Label3: TLabel
        Left = 11
        Top = 21
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label5: TLabel
        Left = 11
        Top = 45
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object stActual2From: TStaticText
        Left = 60
        Top = 21
        Width = 110
        Height = 17
        AutoSize = False
        Caption = 'stActual2From'
        TabOrder = 0
      end
      object stActual2To: TStaticText
        Left = 60
        Top = 45
        Width = 110
        Height = 17
        AutoSize = False
        Caption = 'stActual2To'
        TabOrder = 1
      end
    end
    object grbActual3: TGroupBox
      Left = 392
      Top = 24
      Width = 185
      Height = 73
      Caption = 'Third shift'
      TabOrder = 2
      object Label6: TLabel
        Left = 11
        Top = 21
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label7: TLabel
        Left = 11
        Top = 45
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object stActual3From: TStaticText
        Left = 60
        Top = 21
        Width = 110
        Height = 17
        AutoSize = False
        Caption = 'stActual3From'
        TabOrder = 0
      end
      object stActual3To: TStaticText
        Left = 60
        Top = 45
        Width = 110
        Height = 17
        AutoSize = False
        Caption = 'stActual3To'
        TabOrder = 1
      end
    end
    object grbActual4: TGroupBox
      Left = 584
      Top = 24
      Width = 185
      Height = 73
      Caption = 'Fourth shift'
      TabOrder = 3
      object Label8: TLabel
        Left = 11
        Top = 21
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label9: TLabel
        Left = 11
        Top = 45
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object stActual4From: TStaticText
        Left = 60
        Top = 21
        Width = 110
        Height = 17
        AutoSize = False
        Caption = 'stActual4From'
        TabOrder = 0
      end
      object stActual4To: TStaticText
        Left = 60
        Top = 45
        Width = 110
        Height = 17
        AutoSize = False
        Caption = 'stActual4To'
        TabOrder = 1
      end
    end
  end
  object grbNew: TGroupBox
    Left = 0
    Top = 288
    Width = 885
    Height = 169
    Caption = 'New values'
    TabOrder = 1
    object grbNew1: TGroupBox
      Left = 8
      Top = 24
      Width = 185
      Height = 73
      Caption = 'First shift'
      TabOrder = 0
      object Label10: TLabel
        Left = 11
        Top = 23
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label11: TLabel
        Left = 11
        Top = 47
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object dtmNew1From: TDateTimePicker
        Left = 60
        Top = 18
        Width = 110
        Height = 21
        Date = 38259.000000000000000000
        Format = 'HH:mm:ss'
        Time = 38259.000000000000000000
        Color = 14803425
        Kind = dtkTime
        TabOrder = 0
        StyleName = 'datatex1'
      end
      object dtmNew1To: TDateTimePicker
        Left = 60
        Top = 45
        Width = 110
        Height = 21
        Date = 38259.000000000000000000
        Format = 'HH:mm:ss'
        Time = 38259.000000000000000000
        Color = 14803425
        Kind = dtkTime
        TabOrder = 1
        StyleName = 'datatex1'
      end
    end
    object grbNew2: TGroupBox
      Left = 200
      Top = 24
      Width = 185
      Height = 73
      Caption = 'Second shift'
      TabOrder = 1
      object Label12: TLabel
        Left = 11
        Top = 23
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label13: TLabel
        Left = 11
        Top = 47
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object dtmNew2From: TDateTimePicker
        Left = 60
        Top = 18
        Width = 110
        Height = 21
        Date = 38259.000000000000000000
        Format = 'HH:mm:ss'
        Time = 38259.000000000000000000
        Color = 14803425
        Kind = dtkTime
        TabOrder = 0
        StyleName = 'datatex1'
      end
      object dtmNew2To: TDateTimePicker
        Left = 60
        Top = 45
        Width = 110
        Height = 21
        Date = 38259.000000000000000000
        Format = 'HH:mm:ss'
        Time = 38259.000000000000000000
        Color = 14803425
        Kind = dtkTime
        TabOrder = 1
        StyleName = 'datatex1'
      end
    end
    object grbNew3: TGroupBox
      Left = 392
      Top = 24
      Width = 185
      Height = 73
      Caption = 'Third shift'
      TabOrder = 2
      object Label14: TLabel
        Left = 11
        Top = 23
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label15: TLabel
        Left = 11
        Top = 47
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object dtmNew3From: TDateTimePicker
        Left = 60
        Top = 21
        Width = 110
        Height = 21
        Date = 38259.000000000000000000
        Format = 'HH:mm:ss'
        Time = 38259.000000000000000000
        Color = 14803425
        Kind = dtkTime
        TabOrder = 0
        StyleName = 'datatex1'
      end
      object dtmNew3To: TDateTimePicker
        Left = 60
        Top = 45
        Width = 110
        Height = 21
        Date = 38259.000000000000000000
        Format = 'HH:mm:ss'
        Time = 38259.000000000000000000
        Color = 14803425
        Kind = dtkTime
        TabOrder = 1
        StyleName = 'datatex1'
      end
    end
    object grbNew4: TGroupBox
      Left = 584
      Top = 24
      Width = 185
      Height = 73
      Caption = 'Fourth shift'
      TabOrder = 3
      object Label16: TLabel
        Left = 11
        Top = 23
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label17: TLabel
        Left = 11
        Top = 47
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object dtmNew4From: TDateTimePicker
        Left = 60
        Top = 21
        Width = 110
        Height = 21
        Date = 38259.000000000000000000
        Format = 'HH:mm:ss'
        Time = 38259.000000000000000000
        Color = 14803425
        Kind = dtkTime
        TabOrder = 0
        StyleName = 'datatex1'
      end
      object dtmNew4To: TDateTimePicker
        Left = 60
        Top = 45
        Width = 110
        Height = 21
        Date = 38259.000000000000000000
        Format = 'HH:mm:ss'
        Time = 38259.000000000000000000
        Color = 14803425
        Kind = dtkTime
        TabOrder = 1
        StyleName = 'datatex1'
      end
    end
    object rgTypeWorkDay: TRadioGroup
      Left = 8
      Top = 104
      Width = 761
      Height = 50
      Caption = 'Type of working day'
      Columns = 3
      Items.Strings = (
        'Totally not working day'
        'Totally working day'
        'Partially working day')
      TabOrder = 4
      OnClick = rgTypeWorkDayClick
    end
  end
  object grbCalInfo: TGroupBox
    Left = 0
    Top = 9
    Width = 401
    Height = 145
    Caption = 'Calendar information'
    TabOrder = 2
    object Label4: TLabel
      Left = 8
      Top = 69
      Width = 83
      Height = 13
      Caption = 'Select date (from)'
    end
    object Label18: TLabel
      Left = 207
      Top = 69
      Width = 72
      Height = 13
      Caption = 'Select date (to)'
    end
    object Label1: TLabel
      Left = 113
      Top = 16
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = 'Calendar code'
    end
    object Label20: TLabel
      Left = 109
      Top = 39
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Caption = 'Resource code'
    end
    object dtmDateCalFrom: TDateTimePicker
      Left = 8
      Top = 84
      Width = 185
      Height = 21
      Date = 38257.000000000000000000
      Time = 0.642260995402466500
      Color = 14803425
      DateFormat = dfLong
      TabOrder = 0
      StyleName = 'datatex1'
      OnClick = dtmDateCalFromClick
      OnCloseUp = dtmDateCalFromClick
      OnChange = dtmDateCalFromChange
    end
    object dtmDateCalTo: TDateTimePicker
      Left = 207
      Top = 84
      Width = 182
      Height = 21
      Date = 38257.000000000000000000
      Time = 0.642260995402466500
      Color = 14803425
      DateFormat = dfLong
      TabOrder = 1
      StyleName = 'datatex1'
    end
    object StCalCode: TStaticText
      Left = 207
      Top = 16
      Width = 96
      Height = 17
      AutoSize = False
      Caption = 'StCalCode'
      TabOrder = 2
    end
    object chbModEndCal: TCheckBox
      Left = 207
      Top = 112
      Width = 161
      Height = 20
      Caption = 'End of calendar'
      TabOrder = 3
      OnClick = chbModEndCalClick
    end
    object StResCode: TStaticText
      Left = 207
      Top = 39
      Width = 96
      Height = 17
      AutoSize = False
      Caption = 'StResCode'
      TabOrder = 4
    end
  end
  object grbCalOpt: TGroupBox
    Left = 399
    Top = 0
    Width = 184
    Height = 154
    Caption = 'Options'
    TabOrder = 3
    object Label19: TLabel
      Left = 8
      Top = 16
      Width = 119
      Height = 13
      Caption = 'Do not modify these days'
    end
    object clstBoxOptDays: TCheckListBox
      Left = 12
      Top = 35
      Width = 139
      Height = 116
      ItemHeight = 13
      Items.Strings = (
        'Monday'
        'Tuesday'
        'Wednesday'
        'Thursday'
        'Friday'
        'Saturday'
        'Sunday')
      TabOrder = 0
    end
  end
  object rgOptNotWorkDay: TRadioGroup
    Left = 857
    Top = 160
    Width = 161
    Height = 145
    Caption = 'Not working day option'
    ItemIndex = 0
    Items.Strings = (
      'Exclude'
      'Include')
    TabOrder = 4
    Visible = False
  end
  object BtnOk: TcxButton
    Left = 676
    Top = 463
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
    TabOrder = 5
    OnClick = BtnOkClick
  end
  object BtnAbo: TcxButton
    Left = 790
    Top = 463
    Width = 95
    Height = 30
    Caption = 'Abort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 6
    OnClick = BtnAboClick
  end
  object rgCalRes: TRadioGroup
    Left = 595
    Top = 0
    Width = 314
    Height = 154
    Caption = 'Modify all resources with the same calendar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Montserrat'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'No'
      'Yes'
      'Same work center'
      'Same work center or alternative'
      'Resources in active Gantt')
    ParentFont = False
    TabOrder = 7
    WordWrap = True
  end
end
