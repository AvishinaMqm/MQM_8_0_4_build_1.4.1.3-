object SearchAndFocuseColumn: TSearchAndFocuseColumn
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'SearchAndFocuseColumn'
  ClientHeight = 88
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object EditSearch: TEdit
    Left = 10
    Top = 8
    Width = 161
    Height = 21
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 50
    Width = 103
    Height = 25
    Caption = 'Find first'
    DoubleBuffered = True
    Kind = bkOK
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object BitBtn3: TBitBtn
    Left = 130
    Top = 50
    Width = 103
    Height = 25
    Caption = 'Find next'
    DoubleBuffered = True
    Kind = bkOK
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = BitBtn3Click
  end
  object BitBtn2: TBitBtn
    Left = 247
    Top = 50
    Width = 75
    Height = 25
    DoubleBuffered = True
    Kind = bkAbort
    ParentDoubleBuffered = False
    TabOrder = 3
    OnClick = BitBtn2Click
  end
end
