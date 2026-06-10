object SearchSet: TSearchSet
  Left = 382
  Top = 301
  Width = 238
  Height = 237
  Caption = 'SearchSet'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 162
    Width = 230
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 0
      OnClick = BitBtn1Click
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 136
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
