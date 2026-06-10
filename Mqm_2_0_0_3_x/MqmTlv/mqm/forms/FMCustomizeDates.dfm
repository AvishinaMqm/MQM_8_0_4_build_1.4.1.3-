object DatesCustomize: TDatesCustomize
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Customize column 1'
  ClientHeight = 218
  ClientWidth = 366
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 27
    Width = 82
    Height = 18
    Caption = 'Date column'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 109
    Width = 137
    Height = 18
    Caption = 'Time type property  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 68
    Width = 63
    Height = 18
    Caption = 'Operation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object CBField1: TComboBox
    Left = 96
    Top = 28
    Width = 192
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 0
  end
  object CBPropType: TComboBox
    Left = 8
    Top = 133
    Width = 205
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 1
  end
  object CBTimeType: TComboBox
    Left = 219
    Top = 133
    Width = 121
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 2
  end
  object CBOperation: TComboBox
    Left = 98
    Top = 69
    Width = 44
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 3
  end
  object BtnOk: TcxButton
    Left = 49
    Top = 175
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
    TabOrder = 4
    OnClick = BtnOkClick
  end
  object BtnAbo: TcxButton
    Left = 219
    Top = 175
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
    TabOrder = 5
    OnClick = BtnAboClick
  end
  object Button1: TcxButton
    Left = 294
    Top = 27
    Width = 64
    Height = 23
    Caption = 'Clear'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 6
    OnClick = Button1Click
  end
end
