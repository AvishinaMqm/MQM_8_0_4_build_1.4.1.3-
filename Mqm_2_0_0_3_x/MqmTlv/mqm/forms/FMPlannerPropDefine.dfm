object PlannerPropDefine: TPlannerPropDefine
  Left = 0
  Top = 0
  Caption = 'PlannerPropDefine'
  ClientHeight = 456
  ClientWidth = 786
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 17
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 786
    Height = 388
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Caption = 'Panel1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
  object BtnOk: TcxButton
    Left = 549
    Top = 412
    Width = 102
    Height = 36
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object BtnAbo: TcxButton
    Left = 666
    Top = 412
    Width = 95
    Height = 36
    Caption = 'Abort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 2
    OnClick = BtnAboClick
  end
end
