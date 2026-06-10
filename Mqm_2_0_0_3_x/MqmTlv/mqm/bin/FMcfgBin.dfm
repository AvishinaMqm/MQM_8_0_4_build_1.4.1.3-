object FConfigBin: TFConfigBin
  Left = 159
  Top = 69
  BorderIcons = [biSystemMenu]
  Caption = 'Bin configuration'
  ClientHeight = 663
  ClientWidth = 861
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Montserrat'
  Font.Style = []
  KeyPreview = True
  Menu = mnuReload
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 144
  TextHeight = 14
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 861
    Height = 3
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alTop
    Shape = bsTopLine
    ExplicitWidth = 1245
  end
  object grbColPos: TGroupBox
    Left = 0
    Top = 3
    Width = 861
    Height = 115
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alTop
    Caption = 'Position/Width columns'
    TabOrder = 0
    DesignSize = (
      861
      115)
    object grdColPos: TStringGrid
      Left = 27
      Top = 30
      Width = 812
      Height = 71
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Anchors = [akLeft, akTop, akRight, akBottom]
      ColCount = 51
      DefaultColWidth = 80
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Montserrat'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goColMoving, goRowSelect, goThumbTracking]
      ParentFont = False
      TabOrder = 0
      OnColumnMoved = grdColPosColumnMoved
      OnMouseDown = grdColPosMouseDown
      OnMouseUp = grdColPosMouseUp
    end
    object btnRestoreColPos: TcxButton
      Left = 793
      Top = 87
      Width = 165
      Height = 46
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'Restore position'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Visible = False
      OnClick = btnRestoreColPosClick
    end
    object btnRestoreVColWidth: TcxButton
      Left = 801
      Top = 30
      Width = 162
      Height = 45
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'Restore width'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnClick = btnRestoreVColWidthClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 118
    Width = 861
    Height = 495
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 281
      Top = 1
      Width = 5
      Height = 493
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      ExplicitLeft = 408
      ExplicitTop = 2
      ExplicitHeight = 679
    end
    object Splitter2: TSplitter
      Left = 594
      Top = 1
      Width = 6
      Height = 493
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alRight
      ExplicitLeft = 794
      ExplicitTop = 2
      ExplicitHeight = 679
    end
    object grbColLabel: TGroupBox
      Left = 1
      Top = 1
      Width = 280
      Height = 493
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alLeft
      Caption = 'Title columns'
      TabOrder = 0
      DesignSize = (
        280
        493)
      object lblIntMaxChar: TLabel
        Left = 22
        Top = 373
        Width = 258
        Height = 27
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = 'Title (max 16 characters)'
        ExplicitTop = 317
      end
      object lboxColLabel: TListBox
        Left = 20
        Top = 27
        Width = 252
        Height = 344
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = 14803425
        ExtendedSelect = False
        ItemHeight = 14
        TabOrder = 0
        OnClick = lboxColLabelClick
      end
      object EdtColLabel: TEdit
        Left = 20
        Top = 392
        Width = 225
        Height = 25
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Color = 14803425
        MaxLength = 16
        TabOrder = 1
      end
      object btnRefColLabel: TcxButton
        Left = 144
        Top = 431
        Width = 100
        Height = 29
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Anchors = [akLeft, akBottom]
        Caption = 'Apply'
        TabOrder = 2
        OnClick = btnRefColLabelClick
      end
      object btnRestoreColLabel: TcxButton
        Left = 20
        Top = 431
        Width = 101
        Height = 29
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Anchors = [akLeft, akBottom]
        Caption = 'Restore'
        TabOrder = 3
        OnClick = btnRestoreColLabelClick
      end
    end
    object grbVisibleCol: TGroupBox
      Left = 286
      Top = 1
      Width = 308
      Height = 493
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alClient
      Caption = 'Visible columns'
      TabOrder = 1
      DesignSize = (
        308
        493)
      object cboxColVis: TCheckListBox
        Left = 14
        Top = 20
        Width = 280
        Height = 460
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = 14803425
        StyleName = 'datatex1'
        TabOrder = 0
        OnClickCheck = cboxColVisClickCheck
      end
    end
    object PageControl1: TPageControl
      Left = 600
      Top = 1
      Width = 260
      Height = 493
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      ActivePage = TabSheet1
      Align = alRight
      OwnerDraw = True
      TabOrder = 2
      OnDrawTab = PageControl1DrawTab
      object TabSheet1: TTabSheet
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Caption = 'Sort order'
        object grbColOrder: TGroupBox
          Left = 0
          Top = 0
          Width = 252
          Height = 409
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alClient
          Caption = 'Sort'
          TabOrder = 0
          object grdOrdCol: TStringGrid
            Left = 2
            Top = 16
            Width = 248
            Height = 391
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alClient
            ColCount = 2
            DefaultColWidth = 335
            DefaultRowHeight = 16
            FixedRows = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowMoving, goRowSelect, goThumbTracking]
            TabOrder = 0
            OnColumnMoved = grdOrdColRowMoved
            OnMouseDown = grdOrdColMouseDown
            OnMouseUp = grdOrdColMouseUp
            OnRowMoved = grdOrdColRowMoved
            ColWidths = (
              335
              335)
          end
        end
        object Panel1: TPanel
          Left = 0
          Top = 409
          Width = 252
          Height = 55
          Margins.Left = 6
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          Align = alBottom
          TabOrder = 1
          object Label1: TLabel
            Left = 2
            Top = 14
            Width = 141
            Height = 14
            Margins.Left = 6
            Margins.Top = 6
            Margins.Right = 6
            Margins.Bottom = 6
            Caption = 'Number of colums sorted'
          end
          object SpinEdtNumberofcolumnSorted: TExSpinEdit
            Left = 175
            Top = 10
            Width = 50
            Height = 23
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 8
            ArrowColor = 15972184
            MaxLength = 3
            MaxValue = 999
            MinValue = 0
            ParentColor = True
            TabOrder = 0
            Value = 0
            OnChange = SpinEdtNumberofcolumnSortedChange
          end
        end
      end
      object TabSheet2: TTabSheet
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Caption = 'Descending selection'
        ImageIndex = 1
        object ChkBoxSortType: TCheckListBox
          Left = 0
          Top = 0
          Width = 252
          Height = 464
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alClient
          Color = 14803425
          TabOrder = 0
          OnClick = ChkBoxSortTypeClick
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 613
    Width = 861
    Height = 50
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      861
      50)
    object bbtnAbort: TcxButton
      Left = 628
      Top = 6
      Width = 105
      Height = 33
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Anchors = [akRight, akBottom]
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Montserrat'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = bbtnAbortClick
    end
    object bbtnOk: TcxButton
      Left = 745
      Top = 6
      Width = 106
      Height = 33
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Montserrat'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bbtnOkClick
    end
    object btnRestoreColVis: TcxButton
      Left = 23
      Top = 4
      Width = 123
      Height = 39
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Anchors = [akLeft, akBottom]
      Caption = 'Restore'
      TabOrder = 2
      Visible = False
      OnClick = btnRestoreColVisClick
    end
  end
  object mnuReload: TMainMenu
    Left = 184
    Top = 384
    object MiRestore: TMenuItem
      Caption = '&Restore'
      object MIDefaultConfig: TMenuItem
        Caption = '&Default configuration'
        OnClick = MIDefaultConfigClick
      end
    end
  end
end
