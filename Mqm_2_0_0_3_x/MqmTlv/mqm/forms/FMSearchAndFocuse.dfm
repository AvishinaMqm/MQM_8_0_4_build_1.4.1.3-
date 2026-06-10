object SearchAndFocuse: TSearchAndFocuse
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Position for selected cell on bin'
  ClientHeight = 110
  ClientWidth = 432
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object EditSearch: TEdit
    Left = 13
    Top = 10
    Width = 179
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = 14803425
    TabOrder = 1
    OnKeyPress = EditSearchKeyPress
  end
  object BitBtn3: TcxButton
    Left = 169
    Top = 69
    Width = 111
    Height = 33
    Caption = 'Find Next'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 2
    OnClick = BitBtnFindNextClick
  end
  object BitBtn2: TcxButton
    Left = 320
    Top = 69
    Width = 95
    Height = 33
    Caption = 'Abort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn2Click
  end
  object BitBtn1: TcxButton
    Left = 12
    Top = 69
    Width = 108
    Height = 33
    Caption = 'Find first'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 0
    OnClick = BitBtn1Click
  end
end
