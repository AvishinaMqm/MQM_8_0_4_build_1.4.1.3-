object FLicHdl: TFLicHdl
  Left = 354
  Top = 227
  Caption = 'License handling'
  ClientHeight = 54
  ClientWidth = 239
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu: TMainMenu
    Left = 24
    Top = 8
    object IHandle: TMenuItem
      Caption = 'Handle'
      object ILicCreate: TMenuItem
        Caption = 'Create license'
        OnClick = ILicCreateClick
      end
    end
  end
end
