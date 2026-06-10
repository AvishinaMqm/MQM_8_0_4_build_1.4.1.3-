object FPrevNextStepDetails: TFPrevNextStepDetails
  Left = 100
  Top = 24
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Step details'
  ClientHeight = 574
  ClientWidth = 737
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 16
  object LblReq: TLabel
    Left = 0
    Top = 0
    Width = 57
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    Caption = 'Request'
    Layout = tlCenter
  end
  object LblStep: TLabel
    Left = 144
    Top = 0
    Width = 57
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    Caption = 'Step'
    Layout = tlCenter
  end
  object LblSubStep: TLabel
    Left = 286
    Top = 0
    Width = 70
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    Caption = 'Sub step'
    Layout = tlCenter
  end
  object LblRePrc: TLabel
    Left = 433
    Top = 0
    Width = 80
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    Caption = 'Re process'
    Layout = tlCenter
  end
  object SGRowDetails: TStringGrid
    Left = 0
    Top = 39
    Width = 740
    Height = 533
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alCustom
    ColCount = 4
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 0
    ColWidths = (
      140
      61
      72
      316)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object STProd: TStaticText
    Left = 66
    Top = 5
    Width = 74
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'STProd'
    Color = 14803425
    ParentColor = False
    TabOrder = 1
  end
  object Ststep: TStaticText
    Left = 202
    Top = 5
    Width = 74
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'Ststep'
    Color = 14803425
    ParentColor = False
    TabOrder = 2
  end
  object StSubStep: TStaticText
    Left = 357
    Top = 5
    Width = 74
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'StSubStep'
    Color = 14803425
    ParentColor = False
    TabOrder = 3
  end
  object StReProcess: TStaticText
    Left = 512
    Top = 5
    Width = 74
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'StReProcess'
    Color = 14803425
    ParentColor = False
    TabOrder = 4
  end
end
