object FMSeleTab: TFMSeleTab
  Left = 109
  Top = 268
  BorderStyle = bsDialog
  Caption = 'Select tabsheet'
  ClientHeight = 254
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object LstTabs: TCheckListBox
    Left = 40
    Top = 32
    Width = 201
    Height = 153
    ItemHeight = 13
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 48
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
end
