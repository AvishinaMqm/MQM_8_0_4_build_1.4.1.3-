object DatesCustomizeGap: TDatesCustomizeGap
  Left = 0
  Top = 0
  Caption = 'Customized dates gap'
  ClientHeight = 311
  ClientWidth = 422
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 13
  object Label1: TLabel
    Left = 30
    Top = 28
    Width = 95
    Height = 18
    AutoSize = False
    Caption = 'Date column'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 31
    Top = 57
    Width = 110
    Height = 18
    AutoSize = False
    Caption = 'Minus'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 30
    Top = 86
    Width = 135
    Height = 18
    Caption = 'Date type property  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 30
    Top = 198
    Width = 89
    Height = 18
    AutoSize = False
    Caption = 'Result type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 30
    Top = 237
    Width = 109
    Height = 18
    AutoSize = False
    Caption = 'Absolute value'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 26
    Top = 158
    Width = 93
    Height = 18
    AutoSize = False
    Caption = ' Date column '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 30
    Top = 122
    Width = 71
    Height = 18
    AutoSize = False
    Caption = 'Or Minus'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 100
    Top = 122
    Width = 261
    Height = 18
    AutoSize = False
    Caption = ' (When property value is not valid) '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object CBField1: TComboBox
    Left = 131
    Top = 27
    Width = 183
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 0
  end
  object CBPropType: TComboBox
    Left = 169
    Top = 87
    Width = 145
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 1
  end
  object CBTimeType: TComboBox
    Left = 146
    Top = 199
    Width = 91
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 2
  end
  object CBABSVal: TComboBox
    Left = 146
    Top = 234
    Width = 70
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 3
  end
  object CBField2: TComboBox
    Left = 146
    Top = 157
    Width = 168
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 4
  end
  object BtnOk: TcxButton
    Left = 217
    Top = 273
    Width = 93
    Height = 30
    Caption = 'OK'
    TabOrder = 5
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    OnClick = BtnOkClick
  end
  object BtnAbo: TcxButton
    Left = 316
    Top = 273
    Width = 95
    Height = 30
    Caption = 'Abort'
    TabOrder = 6
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    OnClick = BtnAboClick
  end
  object Button1: TcxButton
    Left = 336
    Top = 27
    Width = 75
    Height = 23
    Caption = 'Clear'
    TabOrder = 7
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    OnClick = Button1Click
  end
  object Button2: TcxButton
    Left = 336
    Top = 157
    Width = 75
    Height = 23
    Caption = 'Clear'
    TabOrder = 8
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    OnClick = Button2Click
  end
  object Button3: TcxButton
    Left = 336
    Top = 87
    Width = 75
    Height = 23
    Caption = 'Clear'
    TabOrder = 9
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    OnClick = Button3Click
  end
end
