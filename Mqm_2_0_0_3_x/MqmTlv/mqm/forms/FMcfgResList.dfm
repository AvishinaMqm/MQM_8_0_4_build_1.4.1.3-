object FConfigResList: TFConfigResList
  Left = 159
  Top = 69
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Resource sequence'
  ClientHeight = 463
  ClientWidth = 341
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  TextHeight = 13
  object GrbResList: TGroupBox
    Left = 0
    Top = 0
    Width = 341
    Height = 412
    Align = alClient
    Caption = 'Resource List'
    TabOrder = 0
    ExplicitWidth = 275
    ExplicitHeight = 420
    object StrGrdResList: TStringGrid
      Left = 2
      Top = 15
      Width = 337
      Height = 395
      Align = alClient
      ColCount = 3
      DefaultColWidth = 80
      DefaultRowHeight = 16
      FixedCols = 2
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowMoving, goRowSelect, goThumbTracking]
      TabOrder = 0
      OnMouseDown = StrGrdResListMouseDown
      OnMouseUp = StrGrdResListMouseUp
      ExplicitWidth = 341
      ExplicitHeight = 404
      RowHeights = (
        16
        16
        16
        16
        16)
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 412
    Width = 341
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 40
    ExplicitTop = 420
    ExplicitWidth = 231
    object BtnAbort: TcxButton
      Left = 245
      Top = 6
      Width = 83
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Abort'
      TabOrder = 0
      OnClick = BtnAbortClick
    end
    object BtnOk: TcxButton
      Left = 3
      Top = 6
      Width = 77
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'OK'
      TabOrder = 1
      OnClick = BtnOkClick
    end
    object BtnResetList: TcxButton
      Left = 125
      Top = 6
      Width = 85
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Undo all'
      TabOrder = 2
      OnClick = BtnResetListClick
    end
  end
end
