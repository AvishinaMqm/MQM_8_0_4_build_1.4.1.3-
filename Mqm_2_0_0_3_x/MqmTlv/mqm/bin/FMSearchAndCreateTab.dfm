object SearchAndCreateTab: TSearchAndCreateTab
  Left = 0
  Top = 0
  Caption = 'SearchAndCreateTab'
  ClientHeight = 194
  ClientWidth = 450
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 17
  object TabName: TLabel
    Left = 75
    Top = 71
    Width = 80
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Tab name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LblFrom: TLabel
    Left = 13
    Top = 25
    Width = 42
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'From'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LBlTo: TLabel
    Left = 225
    Top = 26
    Width = 21
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'To'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object EditTabName: TEdit
    Left = 75
    Top = 99
    Width = 137
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 4
  end
  object EditFrom: TEdit
    Left = 75
    Top = 25
    Width = 132
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
    Visible = False
    OnKeyPress = EditFromKeyPress
  end
  object EditTo: TEdit
    Left = 276
    Top = 24
    Width = 132
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 1
    Visible = False
    OnKeyPress = EditFromKeyPress
  end
  object DatePickDelivDate_From: TDateTimePicker
    Left = 77
    Top = 26
    Width = 123
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Date = 37886.000000000000000000
    Time = 0.680019166698912200
    Checked = False
    DateMode = dmUpDown
    TabOrder = 2
    Visible = False
  end
  object DatePickDelivDate_To: TDateTimePicker
    Left = 284
    Top = 25
    Width = 114
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Date = 37886.000000000000000000
    Time = 0.680019166698912200
    Checked = False
    DateMode = dmUpDown
    TabOrder = 3
    Visible = False
  end
  object ComboBoxTo: TComboBox
    Left = 276
    Top = 25
    Width = 110
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    TabOrder = 5
    Visible = False
  end
  object ComboBoxFrom: TComboBox
    Left = 75
    Top = 25
    Width = 112
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    TabOrder = 6
    Visible = False
  end
  object BtnOk: TcxButton
    Left = 225
    Top = 150
    Width = 102
    Height = 36
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 7
    OnClick = BtnOkClick
  end
  object BtnAbo: TcxButton
    Left = 347
    Top = 150
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
    TabOrder = 8
    OnClick = BtnAboClick
  end
end
