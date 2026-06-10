object FResDetails: TFResDetails
  Left = 218
  Top = 179
  Caption = 'Resource details'
  ClientHeight = 453
  ClientWidth = 777
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  TextHeight = 16
  object PanBtn: TPanel
    Left = 0
    Top = 405
    Width = 777
    Height = 48
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvLowered
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Montserrat'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    ExplicitTop = 366
    ExplicitWidth = 775
    DesignSize = (
      777
      48)
    object BtnOk: TBitBtn
      Left = 810
      Top = 10
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 808
    end
    object BtnCanc: TcxButton
      Left = 668
      Top = 7
      Width = 95
      Height = 33
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Montserrat'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnCancClick
      ExplicitLeft = 666
    end
  end
  object PGCres: TPageControl
    Left = 0
    Top = 41
    Width = 777
    Height = 364
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TBgen
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 775
    ExplicitHeight = 325
    object TBgen: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'General'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object LblWcCode: TLabel
        Left = 7
        Top = 48
        Width = 103
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'W.center code'
      end
      object LblWcSDescCode: TLabel
        Left = 7
        Top = 16
        Width = 128
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Short description  '
      end
      object LblWcLDescCode: TLabel
        Left = 7
        Top = 80
        Width = 99
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Resource cat.'
      end
      object LblWcLDesc: TLabel
        Left = 327
        Top = 49
        Width = 80
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Description'
      end
      object LblCatDesc: TLabel
        Left = 327
        Top = 81
        Width = 80
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Description'
      end
      object LblCalCod: TLabel
        Left = 7
        Top = 111
        Width = 64
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Calendar'
      end
      object LblStndBachSize: TLabel
        Left = 7
        Top = 142
        Width = 142
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Standard batch size'
      end
      object Label1: TLabel
        Left = 7
        Top = 171
        Width = 101
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Min batch size'
      end
      object LblMaxBatchSize: TLabel
        Left = 327
        Top = 143
        Width = 73
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Max batch'
      end
      object LblBatchSizeUm: TLabel
        Left = 327
        Top = 113
        Width = 68
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Batch um'
      end
      object LblNumResCompo: TLabel
        Left = 7
        Top = 201
        Width = 178
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Nr. resource components'
      end
      object LblBatchGroupCode: TLabel
        Left = 327
        Top = 202
        Width = 225
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Dual machine batch group code'
      end
      object LblSingleMaxBatch: TLabel
        Left = 327
        Top = 172
        Width = 217
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Single machine max batch size'
      end
      object LBLPropOptimumMaxMultiplier: TLabel
        Left = 7
        Top = 264
        Width = 264
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Property Optimum/maximum/multiplier'
      end
      object Label2: TLabel
        Left = 7
        Top = 233
        Width = 192
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Property Minimum/multiplier'
      end
      object STWcCod: TStaticText
        Left = 197
        Top = 49
        Width = 119
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 0
      end
      object STResCatCod: TStaticText
        Left = 196
        Top = 81
        Width = 119
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 1
      end
      object STWcLDesc: TStaticText
        Left = 465
        Top = 50
        Width = 132
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 2
      end
      object STSDesc: TStaticText
        Left = 197
        Top = 16
        Width = 119
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 3
      end
      object STCalCod: TStaticText
        Left = 197
        Top = 113
        Width = 118
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 4
      end
      object STStndBachSize: TStaticText
        Left = 197
        Top = 143
        Width = 117
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 5
      end
      object STMinBatchSize: TStaticText
        Left = 196
        Top = 172
        Width = 117
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 6
      end
      object STMaxBatchSize: TStaticText
        Left = 463
        Top = 142
        Width = 117
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 7
      end
      object STBatchUm: TStaticText
        Left = 463
        Top = 111
        Width = 85
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 8
      end
      object STBachUmDesc: TStaticText
        Left = 559
        Top = 111
        Width = 85
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 9
      end
      object STNumResCompo: TStaticText
        Left = 238
        Top = 201
        Width = 75
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 10
      end
      object STResCatCodDesc: TStaticText
        Left = 465
        Top = 82
        Width = 132
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 11
      end
      object StTxBatchGroupCode: TStaticText
        Left = 589
        Top = 199
        Width = 128
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 12
      end
      object StTxSingleMaxBatch: TStaticText
        Left = 589
        Top = 170
        Width = 128
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 13
      end
      object StaticPropOptimumMaxMultiplier: TStaticText
        Left = 313
        Top = 262
        Width = 112
        Height = 23
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 14
      end
      object StaticPropMinMultiplier: TStaticText
        Left = 313
        Top = 231
        Width = 112
        Height = 23
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Color = 14803425
        ParentColor = False
        TabOrder = 15
      end
    end
    object TBprop: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Properties'
      ImageIndex = 1
    end
    object TBrulesRtoO: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Rules R to O'
      Enabled = False
      ImageIndex = 2
      TabVisible = False
    end
    object TBrulesOtoO: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Rules O to O'
      Enabled = False
      ImageIndex = 3
      TabVisible = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 777
    Height = 41
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvLowered
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Montserrat'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    ExplicitWidth = 775
    object LblResCode: TLabel
      Left = 23
      Top = 16
      Width = 61
      Height = 15
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
    end
    object LblResDescr: TLabel
      Left = 276
      Top = 16
      Width = 130
      Height = 15
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Long description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
    end
    object StCode: TStaticText
      Left = 92
      Top = 14
      Width = 149
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = 14803425
      ParentColor = False
      TabOrder = 0
    end
    object STLDescr: TStaticText
      Left = 414
      Top = 14
      Width = 150
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = 14803425
      ParentColor = False
      TabOrder = 1
    end
  end
end
