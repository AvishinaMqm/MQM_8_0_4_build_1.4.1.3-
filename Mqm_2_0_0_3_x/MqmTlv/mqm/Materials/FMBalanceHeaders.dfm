object MBalanceHeadersForm: TMBalanceHeadersForm
  Left = 0
  Top = 0
  Caption = 'Host Balances'
  ClientHeight = 539
  ClientWidth = 689
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SGRowDetailsBalanceHdr: TStringGrid
    Left = 0
    Top = 129
    Width = 689
    Height = 410
    Align = alClient
    ColCount = 6
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnDblClick = SGRowDetailsBalanceHdrDblClick
    OnSelectCell = SGRowDetailsBalanceHdrSelectCell
    ColWidths = (
      36
      188
      98
      133
      108
      115)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 689
    Height = 129
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object Bevel1: TBevel
      Left = 13
      Top = 8
      Width = 265
      Height = 108
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
    end
    object Label1: TLabel
      Left = 28
      Top = 10
      Width = 43
      Height = 16
      Caption = 'Column'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 151
      Top = 10
      Width = 33
      Height = 16
      Caption = 'Order'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Bevel2: TBevel
      Left = 334
      Top = 8
      Width = 296
      Height = 108
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
    end
    object Label3: TLabel
      Left = 361
      Top = 12
      Width = 43
      Height = 16
      Caption = 'Column'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 485
      Top = 12
      Width = 87
      Height = 16
      Caption = 'Contains String'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object CBSort1: TComboBox
      Left = 24
      Top = 30
      Width = 112
      Height = 21
      Style = csDropDownList
      Color = 14803425
      TabOrder = 0
      OnChange = CBSort1Change
    end
    object CBSort1Type: TComboBox
      Left = 151
      Top = 30
      Width = 112
      Height = 21
      Style = csDropDownList
      Color = 14803425
      TabOrder = 1
      OnChange = CBSort1TypeChange
    end
    object CBFilt1: TComboBox
      Left = 347
      Top = 32
      Width = 112
      Height = 21
      Style = csDropDownList
      Color = 14803425
      TabOrder = 2
      OnChange = CBSort1Change
    end
    object EditFilt1: TEdit
      Left = 474
      Top = 32
      Width = 142
      Height = 21
      Color = 14803425
      TabOrder = 3
    end
    object CBFilt2: TComboBox
      Left = 347
      Top = 61
      Width = 112
      Height = 21
      Style = csDropDownList
      Color = 14803425
      TabOrder = 4
      OnChange = CBSort1Change
    end
    object EditFilt2: TEdit
      Left = 474
      Top = 60
      Width = 142
      Height = 21
      Color = 14803425
      TabOrder = 5
    end
    object SpdBtnsSort: TcxButton
      Left = 151
      Top = 86
      Width = 82
      Height = 30
      Caption = 'Sort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 6
      OnClick = SpdBtnsSortClick
    end
    object SpdBtnFilter: TcxButton
      Left = 474
      Top = 87
      Width = 64
      Height = 30
      Caption = 'Filter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 7
      OnClick = SpdBtnFilterClick
    end
    object SpdBnFiltShowAll: TcxButton
      Left = 544
      Top = 87
      Width = 73
      Height = 30
      Caption = 'Show all'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 8
      OnClick = SpdBnFiltShowAllClick
    end
  end
  object CBSort2: TComboBox
    Left = 24
    Top = 58
    Width = 112
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 2
    OnChange = CBSort2Change
  end
  object CBSort2Type: TComboBox
    Left = 151
    Top = 59
    Width = 112
    Height = 21
    Style = csDropDownList
    Color = 14803425
    TabOrder = 3
    OnChange = CBSort2TypeChange
  end
  object PopupMenu1: TPopupMenu
    Left = 144
    Top = 160
    object MIBalanceChange: TMenuItem
      Caption = 'Modify'
      OnClick = MIBalanceChangeClick
    end
  end
end
