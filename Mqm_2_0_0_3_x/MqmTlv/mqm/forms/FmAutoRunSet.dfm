object FRowDetailsSet: TFRowDetailsSet
  Left = 0
  Top = 0
  Caption = 'Row Details for Set  :'
  ClientHeight = 441
  ClientWidth = 816
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 17
  object SGRowDetailsSet: TStringGrid
    Left = 0
    Top = 0
    Width = 816
    Height = 387
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    ColCount = 6
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnSelectCell = SGRowDetailsSetSelectCell
    ColWidths = (
      87
      178
      124
      120
      140
      130)
    RowHeights = (
      24
      24)
  end
  object PanBtn: TPanel
    Left = 0
    Top = 387
    Width = 816
    Height = 54
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      816
      54)
    object btnOK: TcxButton
      Left = 678
      Top = 7
      Width = 114
      Height = 33
      ParentCustomHint = False
      Anchors = [akRight, akBottom]
      BiDiMode = bdLeftToRight
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 216
    Top = 136
    object MiUpdate: TMenuItem
      Caption = 'Update'
      OnClick = MiUpdateClick
    end
    object MiInsert: TMenuItem
      Caption = 'Insert'
      OnClick = MiInsertClick
    end
    object MIDelete: TMenuItem
      Caption = 'Delete'
      OnClick = MIDeleteClick
    end
  end
end
