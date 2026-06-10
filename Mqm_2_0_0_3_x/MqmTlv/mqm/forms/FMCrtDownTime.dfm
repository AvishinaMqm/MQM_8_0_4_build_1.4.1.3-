object FCrtDownTime: TFCrtDownTime
  Left = 276
  Top = 412
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Downtime'
  ClientHeight = 431
  ClientWidth = 299
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 384
    Width = 299
    Height = 47
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object CBCrossDntime: TCheckBox
      Left = 5
      Top = 12
      Width = 152
      Height = 21
      Caption = 'Crossing downtime'
      Color = clWhite
      ParentColor = False
      TabOrder = 0
      OnClick = CBCrossDntimeClick
    end
    object BtnOk: TcxButton
      Left = 154
      Top = 6
      Width = 65
      Height = 28
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnOkClick
    end
    object BtnAbort: TcxButton
      Left = 227
      Top = 6
      Width = 70
      Height = 28
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Montserrat'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 2
      OnClick = BtnAbortClick
    end
  end
  object GBStDate: TGroupBox
    Left = 0
    Top = 0
    Width = 299
    Height = 65
    Align = alTop
    Caption = 'Start date'
    TabOrder = 1
    object LblStDate: TLabel
      Left = 17
      Top = 16
      Width = 49
      Height = 13
      AutoSize = False
      Caption = 'Date'
    end
    object LblStTime: TLabel
      Left = 142
      Top = 16
      Width = 49
      Height = 13
      AutoSize = False
      Caption = 'Time'
    end
    object DTPStDate: TDateTimePicker
      Left = 16
      Top = 30
      Width = 113
      Height = 27
      Date = 38420.000000000000000000
      Time = 0.638900092599215000
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      StyleName = 'datatex1'
      OnChange = DTPStDateChange
    end
    object DTPStTime: TDateTimePicker
      Left = 142
      Top = 30
      Width = 123
      Height = 27
      Date = 38420.000000000000000000
      Time = 0.640211400510452200
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Montserrat'
      Font.Style = []
      Kind = dtkTime
      ParentFont = False
      TabOrder = 1
      StyleName = 'datatex1'
      OnChange = DTPStTimeChange
    end
  end
  object GBEndDate: TGroupBox
    Left = 0
    Top = 136
    Width = 299
    Height = 66
    Align = alTop
    Caption = 'End date'
    TabOrder = 2
    object LblEndDate: TLabel
      Left = 18
      Top = 15
      Width = 39
      Height = 13
      AutoSize = False
      Caption = 'Date'
    end
    object LblEndTime: TLabel
      Left = 142
      Top = 15
      Width = 49
      Height = 13
      AutoSize = False
      Caption = 'Time'
    end
    object DTPEndDate: TDateTimePicker
      Left = 17
      Top = 30
      Width = 112
      Height = 27
      Date = 38420.000000000000000000
      Time = 0.638900092599215000
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      StyleName = 'datatex1'
      OnChange = DTPEndDateChange
    end
    object DTPEndTime: TDateTimePicker
      Left = 142
      Top = 30
      Width = 123
      Height = 27
      Date = 38420.000000000000000000
      Time = 0.640211400510452200
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Montserrat'
      Font.Style = []
      Kind = dtkTime
      ParentFont = False
      TabOrder = 1
      StyleName = 'datatex1'
      OnChange = DTPEndTimeChange
    end
  end
  object GBDuration: TGroupBox
    Left = 0
    Top = 65
    Width = 299
    Height = 71
    Align = alTop
    Caption = 'Duration'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object LblDays: TLabel
      Left = 17
      Top = 15
      Width = 64
      Height = 16
      AutoSize = False
      Caption = 'Days'
    end
    object LblHours: TLabel
      Left = 108
      Top = 15
      Width = 28
      Height = 13
      Caption = 'Hours'
    end
    object LblMinutes: TLabel
      Left = 215
      Top = 15
      Width = 66
      Height = 13
      AutoSize = False
      Caption = 'Minutes'
    end
    object SEDays: TExSpinEdit
      Left = 16
      Top = 33
      Width = 50
      Height = 26
      ArrowColor = 15972184
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 0
      MinValue = 0
      ParentFont = False
      TabOrder = 0
      Value = 0
      OnChange = SEDaysChange
      OnKeyUp = SEDaysKeyUp
    end
    object SEHours: TExSpinEdit
      Left = 107
      Top = 35
      Width = 50
      Height = 26
      ArrowColor = 15972184
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 1111
      MinValue = 0
      ParentFont = False
      TabOrder = 1
      Value = 0
      OnKeyUp = SEHoursKeyUp
    end
    object SEMinutes: TExSpinEdit
      Left = 215
      Top = 37
      Width = 50
      Height = 26
      ArrowColor = 15972184
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 59
      MinValue = 0
      ParentFont = False
      TabOrder = 2
      Value = 0
      OnKeyUp = SEMinutesKeyUp
    end
  end
  object GroupBox5: TGroupBox
    Left = 0
    Top = 202
    Width = 299
    Height = 182
    Align = alClient
    Caption = 'Comment'
    TabOrder = 4
    object EdtComment: TEdit
      Left = 2
      Top = 15
      Width = 295
      Height = 165
      Align = alClient
      Color = clWhite
      MaxLength = 30
      TabOrder = 0
      ExplicitHeight = 21
    end
  end
end
