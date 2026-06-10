object EditCapacity: TEditCapacity
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'Edit capacity'
  ClientHeight = 440
  ClientWidth = 738
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  TextHeight = 17
  object SGRowDetails: TStringGrid
    Left = 0
    Top = 0
    Width = 738
    Height = 394
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    ColCount = 14
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnSelectCell = SGRowDetailsSelectCell
    ColWidths = (
      126
      69
      61
      82
      78
      64
      64
      64
      64
      64
      64
      64
      64
      64)
    RowHeights = (
      24
      24)
  end
  object PanBtn: TPanel
    Left = 0
    Top = 394
    Width = 738
    Height = 46
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object BtnOk: TcxButton
      Left = 623
      Top = 7
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
      TabOrder = 0
      OnClick = BtnOkClick
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
