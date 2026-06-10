object FSrvSettingsIni: TFSrvSettingsIni
  Left = 355
  Top = 210
  Caption = 'Mqm local table '
  ClientHeight = 235
  ClientWidth = 254
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object PanBtn: TPanel
    Left = 0
    Top = 184
    Width = 254
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 0
    object BtnOk: TBitBtn
      Left = 17
      Top = 10
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnCanc: TBitBtn
      Left = 140
      Top = 10
      Width = 95
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object RadioGroupConnectionType: TRadioGroup
    Left = 8
    Top = 8
    Width = 380
    Height = 177
    ItemIndex = 0
    Items.Strings = (
      'Interbase'
      'Db2'
      'Oracle')
    TabOrder = 1
  end
end
