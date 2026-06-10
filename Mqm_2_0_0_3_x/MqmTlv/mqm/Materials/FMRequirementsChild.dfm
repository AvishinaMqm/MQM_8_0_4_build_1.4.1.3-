object FReqChild: TFReqChild
  Left = 101
  Top = 24
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Material Details'
  ClientHeight = 590
  ClientWidth = 740
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object LblProduct: TLabel
    Left = 0
    Top = 39
    Width = 49
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    Caption = 'Product '
  end
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
    Left = 238
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
    Left = 375
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
    Left = 534
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
    Top = 69
    Width = 740
    Height = 523
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ColCount = 4
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 0
    OnDblClick = SGRowDetailsDblClick
    OnDrawCell = SGRowDetailsDrawCell
    OnSelectCell = SGRowDetailsSelectCell
    ColWidths = (
      126
      69
      61
      340)
    RowHeights = (
      24
      24)
  end
  object StProduct: TStaticText
    Left = 185
    Top = 39
    Width = 504
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'StProduct'
    Color = 14803425
    ParentColor = False
    TabOrder = 1
  end
  object STProd: TStaticText
    Left = 66
    Top = 5
    Width = 169
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
    TabOrder = 2
  end
  object Ststep: TStaticText
    Left = 292
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
    TabOrder = 3
  end
  object StSubStep: TStaticText
    Left = 446
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
    TabOrder = 4
  end
  object StReProcess: TStaticText
    Left = 613
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
    TabOrder = 5
  end
  object StProductType: TStaticText
    Left = 53
    Top = 39
    Width = 123
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'StProduct'
    Color = 14803425
    ParentColor = False
    TabOrder = 6
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 144
    Top = 160
    object MIBalanceChange: TMenuItem
      Caption = 'Modify'
      OnClick = MIBalanceChangeClick
    end
  end
end
