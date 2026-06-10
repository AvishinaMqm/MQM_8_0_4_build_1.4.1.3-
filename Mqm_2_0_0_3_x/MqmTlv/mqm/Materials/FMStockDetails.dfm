object StockDetails: TStockDetails
  Left = 0
  Top = 0
  Caption = 'Requested materials'
  ClientHeight = 501
  ClientWidth = 915
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
  object Splitter1: TSplitter
    Left = 10
    Top = 77
    Width = 750
    Height = 4
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alNone
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 915
    Height = 75
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblReq: TLabel
      Left = 31
      Top = 10
      Width = 61
      Height = 33
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
      Left = 258
      Top = 10
      Width = 61
      Height = 33
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
      Left = 410
      Top = 10
      Width = 70
      Height = 33
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
      Left = 580
      Top = 10
      Width = 85
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Alignment = taCenter
      AutoSize = False
      Caption = 'Re process'
      Layout = tlCenter
    end
    object STProd: TStaticText
      Left = 99
      Top = 16
      Width = 148
      Height = 22
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
      TabOrder = 0
    end
    object Ststep: TStaticText
      Left = 312
      Top = 16
      Width = 78
      Height = 22
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
      TabOrder = 1
    end
    object StSubStep: TStaticText
      Left = 482
      Top = 16
      Width = 78
      Height = 22
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
      TabOrder = 2
    end
    object StReProcess: TStaticText
      Left = 670
      Top = 16
      Width = 78
      Height = 22
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
      TabOrder = 3
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 75
    Width = 915
    Height = 426
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Caption = 'Panel3'
    TabOrder = 1
    object Bevel2: TBevel
      Left = 0
      Top = 368
      Width = 915
      Height = 58
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Shape = bsTopLine
      ExplicitLeft = 1
      ExplicitTop = 367
      ExplicitWidth = 913
    end
    object SGRequirements: TStringGrid
      Left = 0
      Top = 0
      Width = 915
      Height = 368
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      ColCount = 6
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowSelect]
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnDblClick = SGRequirementsDblClick
      OnMouseDown = SGRequirementsMouseDown
      OnSelectCell = SGRequirementsSelectCell
      ColWidths = (
        69
        144
        149
        97
        78
        143)
      RowHeights = (
        24
        24
        24
        24
        24)
    end
    object BtnOk: TcxButton
      Left = 688
      Top = 384
      Width = 97
      Height = 30
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnOkClick
    end
    object BtnAbo: TcxButton
      Left = 802
      Top = 384
      Width = 95
      Height = 30
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 2
      OnClick = BtnAboClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 144
    Top = 200
    object MDeleteConnection: TMenuItem
      Caption = 'Delete connection'
      OnClick = MDeleteConnectionClick
    end
  end
end
