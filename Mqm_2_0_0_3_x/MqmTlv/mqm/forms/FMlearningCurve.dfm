object learningCurve: TlearningCurve
  Left = 0
  Top = 0
  Caption = 'Change learning Curve'
  ClientHeight = 242
  ClientWidth = 407
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LblCurveCodeList: TLabel
    Left = 17
    Top = 8
    Width = 83
    Height = 13
    Caption = 'Curve Code List :'
  end
  object ListBoxCurveCode: TListBox
    Left = 14
    Top = 30
    Width = 236
    Height = 143
    Color = 14803425
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBoxCurveCodeClick
  end
  object STCurrentCode: TStaticText
    Left = 278
    Top = 46
    Width = 107
    Height = 18
    AutoSize = False
    Caption = 'STCurrentCode'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
  end
  object BitBtn1: TcxButton
    Left = 222
    Top = 210
    Width = 82
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object BitBtn2: TcxButton
    Left = 309
    Top = 210
    Width = 76
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Abort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn2Click
  end
end
