object SelectResetstation: TSelectResetstation
  Left = 361
  Top = 238
  Caption = 'Station List'
  ClientHeight = 111
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object ListBoxStation: TCheckListBox
    Left = 0
    Top = 0
    Width = 137
    Height = 111
    Align = alLeft
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 155
    Top = 24
    Width = 107
    Height = 25
    Caption = 'Reset station'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 156
    Top = 76
    Width = 104
    Height = 25
    Kind = bkAbort
    NumGlyphs = 2
    TabOrder = 2
  end
end
