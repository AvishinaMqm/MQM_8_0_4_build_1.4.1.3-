object HtmlBackColors: THtmlBackColors
  Left = 1180
  Top = 307
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'HTML Background Colors'
  ClientHeight = 209
  ClientWidth = 231
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabBack: TLabel
    Left = 24
    Top = 16
    Width = 153
    Height = 20
    Alignment = taCenter
    Caption = 'Formular Background'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = LabBackClick
  end
  object LabTitle: TLabel
    Left = 24
    Top = 56
    Width = 108
    Height = 20
    Alignment = taCenter
    Caption = 'Table Title Row'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = LabTitleClick
  end
  object LabEven: TLabel
    Left = 24
    Top = 96
    Width = 123
    Height = 20
    Alignment = taCenter
    Caption = 'Even Table Rows'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = LabEvenClick
  end
  object LabOdd: TLabel
    Left = 24
    Top = 136
    Width = 117
    Height = 20
    Alignment = taCenter
    Caption = 'Odd Table Rows'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = LabOddClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 167
    Width = 231
    Height = 42
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object BtnOk: TcxButton
      Left = 13
      Top = 8
      Width = 91
      Height = 25
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnCancel: TcxButton
      Left = 123
      Top = 8
      Width = 95
      Height = 25
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnCancelClick
    end
  end
  object ColorDialog1: TColorDialog
  end
end
