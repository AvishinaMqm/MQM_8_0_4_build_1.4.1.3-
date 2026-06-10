object CapResDynamicDetails: TCapResDynamicDetails
  Left = 0
  Top = 0
  Caption = 'Capacity reservation details'
  ClientHeight = 256
  ClientWidth = 560
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object SGCapRes: TStringGrid
    Left = 0
    Top = 0
    Width = 560
    Height = 202
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
    OnDblClick = MiUpdateClick
    OnSelectCell = SGCapResSelectCell
    ColWidths = (
      107
      97
      134
      107)
    RowHeights = (
      24
      24)
  end
  object PanBtn: TPanel
    Left = 0
    Top = 202
    Width = 560
    Height = 54
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      560
      54)
    object BtnOk: TcxButton
      Left = 339
      Top = 15
      Width = 93
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
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnAbort: TcxButton
      Left = 449
      Top = 15
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
      TabOrder = 1
      OnClick = BtnAbortClick
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
