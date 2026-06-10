object ChangeWc: TChangeWc
  Left = 371
  Top = 213
  Caption = 'Change work center'
  ClientHeight = 182
  ClientWidth = 455
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object LabelWc: TLabel
    Left = 14
    Top = 18
    Width = 81
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Work center : '
  end
  object LabelProcess: TLabel
    Left = 223
    Top = 20
    Width = 59
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Process : '
  end
  object Label1: TLabel
    Left = 20
    Top = 48
    Width = 70
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Alternatives'
  end
  object StaticWC: TStaticText
    Left = 103
    Top = 17
    Width = 40
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = '            '
    TabOrder = 0
  end
  object CBAltWc: TComboBox
    Left = 12
    Top = 73
    Width = 427
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    Color = 14803425
    TabOrder = 1
  end
  object StaticProcess: TStaticText
    Left = 290
    Top = 18
    Width = 40
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = '            '
    TabOrder = 2
  end
  object BitBtn1: TcxButton
    Left = 8
    Top = 119
    Width = 93
    Height = 31
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object BitBtn2: TcxButton
    Left = 344
    Top = 119
    Width = 95
    Height = 31
    Caption = 'Abort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 4
    OnClick = BitBtn2Click
  end
end
