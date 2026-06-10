object EditTabsBin: TEditTabsBin
  Left = 282
  Top = 189
  Caption = 'Edit bin tabs'
  ClientHeight = 275
  ClientWidth = 198
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 198
    Height = 275
    Align = alClient
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 15
      Top = 232
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 110
      Top = 232
      Width = 75
      Height = 25
      Kind = bkAbort
      NumGlyphs = 2
      TabOrder = 1
    end
    object StringgrdOrdTabs: TStringGrid
      Left = 7
      Top = 16
      Width = 183
      Height = 198
      ColCount = 2
      DefaultColWidth = 178
      DefaultRowHeight = 16
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowMoving, goRowSelect, goThumbTracking]
      ParentFont = False
      TabOrder = 2
      ColWidths = (
        178
        178)
      RowHeights = (
        16
        16
        16
        16
        16)
    end
  end
end
