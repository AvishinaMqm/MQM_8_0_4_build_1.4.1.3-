object FShowMaterials: TFShowMaterials
  Left = 85
  Top = 75
  Caption = 'Show materials'
  ClientHeight = 548
  ClientWidth = 849
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 57
    Width = 849
    Height = 491
    ActivePage = tbsMaterials
    Align = alClient
    TabOrder = 0
    object tbsMaterials: TTabSheet
      Caption = 'Materials'
      object sgrdBalance: TStringGrid
        Left = 0
        Top = 0
        Width = 841
        Height = 422
        Align = alClient
        ColCount = 6
        DefaultRowHeight = 17
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        PopupMenu = popShowArrivalDate
        TabOrder = 0
        ColWidths = (
          281
          100
          109
          102
          64
          64)
        RowHeights = (
          17
          17
          17
          17
          17)
      end
      object Panel1: TPanel
        Left = 0
        Top = 422
        Width = 841
        Height = 41
        Align = alBottom
        BevelOuter = bvLowered
        TabOrder = 1
        object btnSaveToFile: TcxButton
          Left = 14
          Top = 6
          Width = 102
          Height = 30
          Caption = 'Save to file'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 0
          OnClick = btnSaveToFileClick
        end
      end
    end
    object tbsPositions: TTabSheet
      Caption = 'Positions'
      ImageIndex = 1
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sgrPos: TStringGrid
        Left = 0
        Top = 0
        Width = 841
        Height = 463
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 17
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        PopupMenu = popShowArrivalDate
        TabOrder = 0
        ColWidths = (
          281
          100
          97)
        RowHeights = (
          17
          17
          17
          17
          17)
      end
    end
    object tbsAvailable: TTabSheet
      Caption = 'Movements'
      ImageIndex = 2
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sgrMov: TStringGrid
        Left = 0
        Top = 0
        Width = 841
        Height = 463
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 17
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        PopupMenu = popShowArrivalDate
        TabOrder = 0
        ColWidths = (
          144
          128
          97)
        RowHeights = (
          17
          17
          17
          17
          17)
      end
    end
    object TbsSteps: TTabSheet
      Caption = 'Steps'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SGReqBalance: TStringGrid
        Left = 0
        Top = 0
        Width = 841
        Height = 422
        Align = alClient
        ColCount = 7
        DefaultRowHeight = 17
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        PopupMenu = popShowArrivalDate
        TabOrder = 0
        ColWidths = (
          281
          100
          109
          102
          64
          64
          64)
        RowHeights = (
          17
          17
          17
          17
          17)
      end
      object Panel2: TPanel
        Left = 0
        Top = 422
        Width = 841
        Height = 41
        Align = alBottom
        BevelOuter = bvLowered
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        object btnSaveReqToFile: TcxButton
          Left = 9
          Top = 8
          Width = 137
          Height = 25
          Caption = 'Save to file'
          TabOrder = 0
          OnClick = btnSaveReqToFileClick
        end
      end
    end
  end
  object PnlTop: TPanel
    Left = 0
    Top = 0
    Width = 849
    Height = 57
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 1
    object Label1: TLabel
      Left = 10
      Top = 8
      Width = 57
      Height = 13
      Caption = 'Article types'
    end
    object Label2: TLabel
      Left = 146
      Top = 8
      Width = 34
      Height = 13
      Caption = 'Articles'
    end
    object Label3: TLabel
      Left = 330
      Top = 8
      Width = 52
      Height = 13
      Caption = 'Net groups'
    end
    object cboxArtType: TComboBox
      Left = 10
      Top = 24
      Width = 121
      Height = 21
      Style = csDropDownList
      Color = 14803425
      TabOrder = 0
      OnClick = cboxArtTypeClick
    end
    object cboxArticles: TComboBox
      Left = 146
      Top = 24
      Width = 169
      Height = 21
      Style = csDropDownList
      Color = 14803425
      TabOrder = 1
      OnClick = cboxArticlesClick
    end
    object cboxNetGroups: TComboBox
      Left = 330
      Top = 24
      Width = 169
      Height = 21
      Style = csDropDownList
      Color = 14803425
      TabOrder = 2
      OnClick = cboxNetGroupsClick
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Txt file|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 672
    Top = 8
  end
  object popShowArrivalDate: TPopupMenu
    OnPopup = popShowArrivalDatePopup
    Left = 740
    Top = 16
    object MIShowPos: TMenuItem
      Caption = 'Show list of position'
      OnClick = MIShowPosClick
    end
  end
end
