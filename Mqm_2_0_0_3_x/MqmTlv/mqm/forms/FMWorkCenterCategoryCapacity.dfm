object WorkCenterCategoryCapacity: TWorkCenterCategoryCapacity
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'WorkCenterCategoryCapacity'
  ClientHeight = 484
  ClientWidth = 884
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object PanelMain1: TPanel
    Left = 0
    Top = 0
    Width = 884
    Height = 439
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    Caption = 'PanelMain1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 0
      Top = 0
      Width = 884
      Height = 4
      Cursor = crVSplit
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      ExplicitTop = 90
      ExplicitWidth = 753
    end
    object PanelTop1: TPanel
      Left = 0
      Top = 0
      Width = 974
      Height = 90
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 974
        Height = 90
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        VertScrollBar.Visible = False
        Align = alTop
        BevelInner = bvNone
        BevelOuter = bvRaised
        BevelKind = bkSoft
        BorderStyle = bsNone
        Color = clWhite
        ParentColor = False
        TabOrder = 0
        object LblCategory: TLabel
          Left = 242
          Top = 13
          Width = 51
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Category'
        end
        object LblWkCnter: TLabel
          Left = 115
          Top = 13
          Width = 70
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Work center'
        end
        object Label1: TLabel
          Left = 599
          Top = 14
          Width = 257
          Height = 16
          Caption = 'Number of machines to suspend or add (-/+)'
        end
        object Panel4: TPanel
          Left = 354
          Top = 9
          Width = 215
          Height = 65
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          BevelInner = bvLowered
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          DesignSize = (
            215
            65)
          object LbeDateBegin: TLabeledEdit
            Left = 14
            Top = 29
            Width = 147
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Anchors = [akLeft, akTop, akRight]
            Color = 14803425
            EditLabel.Width = 61
            EditLabel.Height = 16
            EditLabel.Margins.Left = 4
            EditLabel.Margins.Top = 4
            EditLabel.Margins.Right = 4
            EditLabel.Margins.Bottom = 4
            EditLabel.Caption = 'Date begin'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
        end
        object cbxCategory: TComboBox
          Left = 242
          Top = 38
          Width = 86
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 1
        end
        object cbxWkCnter: TComboBox
          Left = 113
          Top = 38
          Width = 108
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 2
        end
        object SEdtNumMachinSuspended: TExSpinEdit
          Left = 604
          Top = 38
          Width = 68
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          MaxLength = 6
          MaxValue = 10000
          MinValue = -10000
          TabOrder = 3
          Value = 0
        end
        object BitBtn1: TBitBtn
          Left = 530
          Top = 37
          Width = 23
          Height = 25
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '...'
          TabOrder = 4
          TabStop = False
          OnClick = BitBtn2Click
        end
      end
    end
    object PanelBottom1: TPanel
      Left = 0
      Top = 94
      Width = 974
      Height = 345
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object SGRowDetails: TStringGrid
        Left = 0
        Top = 0
        Width = 974
        Height = 345
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 4
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnDrawCell = SGRowDetailsDrawCell
        OnSelectCell = SGRowDetailsSelectCell
        ColWidths = (
          238
          217
          182
          234)
        RowHeights = (
          24
          24)
      end
    end
  end
  object BitbtnCancel2: TcxButton
    Left = 781
    Top = 447
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
    TabOrder = 1
    OnClick = BitbtnCancel2Click
  end
  object BitBtnDel1: TcxButton
    Left = 144
    Top = 447
    Width = 113
    Height = 30
    Caption = 'Delete'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 2
    OnClick = MIDeleteClick
  end
  object BitBtn2: TcxButton
    Left = 8
    Top = 447
    Width = 113
    Height = 30
    Caption = 'Save ->'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    PopupMenu = PopupMenu2
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 224
    Top = 208
    object MIDelete: TMenuItem
      Caption = 'Delete'
      OnClick = MIDeleteClick
    end
  end
  object PopupMenu2: TPopupMenu
    OnPopup = PopupMenu2Popup
    Left = 440
    Top = 208
    object MenuItemSave: TMenuItem
      Caption = 'Save record'
      OnClick = MenuItemSaveClick
      OnDrawItem = MenuItemSaveDrawItem
    end
    object MenuItemSaveAsNew: TMenuItem
      Caption = 'Save as new record'
      OnClick = MenuItemSaveAsNewClick
    end
  end
end
