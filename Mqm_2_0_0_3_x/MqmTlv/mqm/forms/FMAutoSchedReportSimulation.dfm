object FAutoSchedRptSimulation: TFAutoSchedRptSimulation
  Left = 0
  Top = 0
  Caption = 'Automatic scheduling report'
  ClientHeight = 473
  ClientWidth = 639
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
  object PnlBtm: TPanel
    Left = 0
    Top = 425
    Width = 639
    Height = 48
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelInner = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object BtnOk: TcxButton
      Left = 437
      Top = 7
      Width = 93
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
    object BtnCanc: TcxButton
      Left = 536
      Top = 7
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
      OnClick = BtnCancClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 639
    Height = 425
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 1
  end
end
