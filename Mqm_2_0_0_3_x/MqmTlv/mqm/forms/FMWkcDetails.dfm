object FWkcDetails: TFWkcDetails
  Left = 235
  Top = 233
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Workcenter details'
  ClientHeight = 356
  ClientWidth = 664
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PanBtn: TPanel
    Left = 0
    Top = 305
    Width = 664
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 322
    ExplicitWidth = 670
    DesignSize = (
      664
      51)
    object BtnOk: TcxButton
      Left = 569
      Top = 7
      Width = 91
      Height = 33
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BtnOkClick
      ExplicitLeft = 575
    end
  end
  object PGCres: TPageControl
    Left = 0
    Top = 41
    Width = 664
    Height = 264
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TBgen
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 670
    ExplicitHeight = 281
    object TBgen: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'General'
      object LblWcCode: TLabel
        Left = 17
        Top = 14
        Width = 33
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Code'
      end
      object LblWcSDescCode: TLabel
        Left = 17
        Top = 54
        Width = 106
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Short description  '
      end
      object LblWcLDescCode: TLabel
        Left = 17
        Top = 94
        Width = 99
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Long description'
      end
      object STWcCod: TStaticText
        Left = 145
        Top = 12
        Width = 148
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
      object STWcSDesc: TStaticText
        Left = 145
        Top = 50
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
        TabOrder = 1
      end
      object STWcLDesc: TStaticText
        Left = 145
        Top = 94
        Width = 149
        Height = 20
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
    end
    object TbAlt: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Alternatives'
      ImageIndex = 4
      object TreeViewProces: TTreeView
        Left = 0
        Top = 0
        Width = 656
        Height = 233
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        ExplicitWidth = 662
        ExplicitHeight = 250
      end
    end
    object TBprop: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Properties'
      ImageIndex = 1
      TabVisible = False
      object StringGrid1: TStringGrid
        Left = 0
        Top = 0
        Width = 656
        Height = 233
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 6
        FixedCols = 0
        TabOrder = 0
        ExplicitWidth = 662
        ExplicitHeight = 250
        ColWidths = (
          80
          78
          76
          97
          79
          93)
        RowHeights = (
          24
          24
          24
          24
          24)
      end
    end
    object TBrulesRtoO: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Rules R to O'
      ImageIndex = 2
      TabVisible = False
    end
    object TBrulesOtoO: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Rules O to O'
      ImageIndex = 3
      TabVisible = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 664
    Height = 41
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    ExplicitWidth = 670
    object LblResCode: TLabel
      Left = 14
      Top = 14
      Width = 93
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resource code'
    end
    object LblResDescr: TLabel
      Left = 299
      Top = 14
      Width = 128
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resource description'
    end
    object StResCode: TStaticText
      Left = 124
      Top = 15
      Width = 148
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
    object StResDescr: TStaticText
      Left = 454
      Top = 12
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
      TabOrder = 1
    end
  end
end
