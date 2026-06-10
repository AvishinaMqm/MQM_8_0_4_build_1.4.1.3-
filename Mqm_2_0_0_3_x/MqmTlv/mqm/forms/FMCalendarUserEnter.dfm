object Calendar: TCalendar
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Calendar'
  ClientHeight = 101
  ClientWidth = 215
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DateTimePicker1: TDateTimePicker
    Left = 8
    Top = 0
    Width = 202
    Height = 21
    Date = 40729.000000000000000000
    Time = 40729.000000000000000000
    Color = 14803425
    TabOrder = 0
  end
  object BtnAbort1: TBitBtn
    Left = 122
    Top = 27
    Width = 75
    Height = 25
    Kind = bkAbort
    NumGlyphs = 2
    TabOrder = 1
    Visible = False
    OnClick = BtnAbort1Click
  end
  object BtnOk1: TBitBtn
    Left = 8
    Top = 27
    Width = 74
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
    Visible = False
  end
  object BtnOk: TcxButton
    Left = 8
    Top = 58
    Width = 74
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
    OnClick = BtnOkClick
  end
  object BtnAbort: TcxButton
    Left = 122
    Top = 58
    Width = 75
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
    OnClick = BtnAbort1Click
  end
end
