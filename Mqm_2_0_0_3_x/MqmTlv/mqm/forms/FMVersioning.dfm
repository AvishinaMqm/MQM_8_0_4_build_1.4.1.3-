object FVersioning: TFVersioning
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Versioning settings'
  ClientHeight = 116
  ClientWidth = 230
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 5
    Width = 84
    Height = 13
    Caption = 'Version identifier:'
  end
  object EditVersing: TEdit
    Left = 9
    Top = 25
    Width = 195
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = 14803425
    TabOrder = 0
  end
  object BitBtn2: TcxButton
    Left = 115
    Top = 74
    Width = 89
    Height = 28
    Caption = 'Abort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 1
    OnClick = BitBtn2Click
  end
  object BitBtn1: TcxButton
    Left = 8
    Top = 74
    Width = 90
    Height = 28
    Caption = 'Save'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 2
    OnClick = BitBtn1Click
  end
end
