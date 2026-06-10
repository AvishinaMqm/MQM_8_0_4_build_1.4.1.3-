object FMaterialReq: TFMaterialReq
  Left = 169
  Top = 39
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Materials requirement'
  ClientHeight = 512
  ClientWidth = 792
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
  object Panel1: TPanel
    Left = 0
    Top = 462
    Width = 792
    Height = 50
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object BtnPrevStepBal: TcxButton
      Left = 22
      Top = 10
      Width = 316
      Height = 30
      Caption = 'Balance details to previous step'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BtnPrevStepBalClick
    end
    object BtnNextStepBalance: TcxButton
      Left = 344
      Top = 10
      Width = 316
      Height = 30
      Caption = 'Balance details to next step'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnNextStepBalanceClick
    end
    object BtnAbort: TcxButton
      Left = 685
      Top = 10
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
      OnClick = BtnAbortClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 139
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object LblReq: TLabel
      Left = 30
      Top = 10
      Width = 56
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
      Left = 262
      Top = 10
      Width = 56
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
      Left = 397
      Top = 10
      Width = 66
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
      Top = 10
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
    object STProd: TStaticText
      Left = 93
      Top = 15
      Width = 167
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
      TabOrder = 0
    end
    object Ststep: TStaticText
      Left = 309
      Top = 15
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
      TabOrder = 1
    end
    object StSubStep: TStaticText
      Left = 463
      Top = 15
      Width = 49
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
      TabOrder = 2
    end
    object StReProcess: TStaticText
      Left = 619
      Top = 15
      Width = 49
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
      TabOrder = 3
    end
    object GroupBox1: TGroupBox
      Left = 30
      Top = 49
      Width = 523
      Height = 80
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Step balances'
      TabOrder = 4
      object LblPrevstepBal: TLabel
        Left = 30
        Top = 25
        Width = 104
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'To previous step:'
        Enabled = False
        Layout = tlBottom
      end
      object LblPrevBal: TLabel
        Left = 148
        Top = 25
        Width = 50
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Balance'
        Enabled = False
        Layout = tlBottom
      end
      object LblPrevShort: TLabel
        Left = 295
        Top = 25
        Width = 81
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        Caption = 'Max shortage'
        Enabled = False
        Layout = tlCenter
      end
      object LblMaxNextShort: TLabel
        Left = 295
        Top = 54
        Width = 81
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        Caption = 'Max shortage'
        Enabled = False
        Layout = tlCenter
      end
      object LblNextBal: TLabel
        Left = 148
        Top = 54
        Width = 50
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Balance'
        Enabled = False
        Layout = tlBottom
      end
      object LblNextstepBal: TLabel
        Left = 30
        Top = 54
        Width = 76
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'To next step:'
        Enabled = False
        Layout = tlBottom
      end
      object StBalancePrev: TStaticText
        Left = 204
        Top = 20
        Width = 74
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        Enabled = False
        ParentColor = False
        TabOrder = 0
      end
      object StPrevShort: TStaticText
        Left = 382
        Top = 20
        Width = 73
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        Enabled = False
        ParentColor = False
        TabOrder = 1
      end
      object StNextShort: TStaticText
        Left = 382
        Top = 49
        Width = 73
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        Enabled = False
        ParentColor = False
        TabOrder = 2
      end
      object StNextBal: TStaticText
        Left = 204
        Top = 49
        Width = 74
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        Enabled = False
        ParentColor = False
        TabOrder = 3
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 139
    Width = 792
    Height = 323
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Caption = 'Panel3'
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    object SGRequirements: TStringGrid
      Left = 1
      Top = 1
      Width = 790
      Height = 321
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      ColCount = 7
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowSelect]
      TabOrder = 0
      OnContextPopup = SGRequirementsContextPopup
      OnDblClick = MIShowmaterialsClick
      OnSelectCell = SGRequirementsSelectCell
      ColWidths = (
        69
        144
        149
        97
        78
        143
        64)
      RowHeights = (
        24
        24
        24
        24
        24)
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 144
    Top = 200
    object MIShowmaterials: TMenuItem
      Caption = 'Show materials'
      OnClick = MIShowmaterialsClick
    end
  end
end
