object FSettings: TFSettings
  Left = 334
  Top = 258
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 126
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PanBtn: TPanel
    Left = 0
    Top = 85
    Width = 314
    Height = 41
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 0
    object BtnOk: TBitBtn
      Left = 151
      Top = 8
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BtnCanc: TBitBtn
      Left = 231
      Top = 8
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 314
    Height = 85
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 1
    object CBoxCapRes: TCheckBox
      Left = 16
      Top = 16
      Width = 185
      Height = 17
      Caption = 'Disable capacity reservations'
      TabOrder = 0
    end
    object Button1: TButton
      Left = 72
      Top = 54
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
