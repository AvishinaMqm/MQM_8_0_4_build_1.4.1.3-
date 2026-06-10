object StockDetailsChild: TStockDetailsChild
  Left = 0
  Top = 0
  Caption = 'Stock details'
  ClientHeight = 487
  ClientWidth = 757
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  DesignSize = (
    757
    487)
  PixelsPerInch = 96
  TextHeight = 17
  object Bevel2: TBevel
    Left = 0
    Top = 430
    Width = 757
    Height = 57
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    Shape = bsTopLine
    ExplicitTop = 438
  end
  object SGRequirements: TStringGrid
    Left = 0
    Top = 148
    Width = 757
    Height = 282
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    ColCount = 1
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowSelect]
    TabOrder = 0
    OnDblClick = SGRequirementsDblClick
    OnSelectCell = SGRequirementsSelectCell
    ColWidths = (
      519)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 757
    Height = 148
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
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
      Left = 244
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
      Left = 390
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
      Left = 549
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
      Left = 98
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
      Left = 299
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
      Left = 462
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
      Left = 633
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
    object GBxRequestedMaterials: TGroupBox
      Left = 31
      Top = 52
      Width = 633
      Height = 75
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Requested Materials'
      TabOrder = 4
      object LblMatType: TLabel
        Left = 25
        Top = 30
        Width = 77
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Material type'
        Layout = tlBottom
      end
      object LblMaterialCode: TLabel
        Left = 231
        Top = 30
        Width = 81
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        Caption = 'Material Code'
        Layout = tlCenter
      end
      object LblNetGroup: TLabel
        Left = 422
        Top = 29
        Width = 63
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Net Group'
        Layout = tlBottom
      end
      object StMatType: TStaticText
        Left = 129
        Top = 29
        Width = 79
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 0
      end
      object StMatCode: TStaticText
        Left = 331
        Top = 29
        Width = 78
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 1
      end
      object StNetGroup: TStaticText
        Left = 505
        Top = 29
        Width = 93
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 2
      end
    end
  end
  object BtnOk: TcxButton
    Left = 551
    Top = 445
    Width = 97
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 2
    OnClick = BtnOkClick
  end
  object BtnAbo: TcxButton
    Left = 654
    Top = 445
    Width = 95
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Abort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 3
    OnClick = BtnAboClick
  end
end
