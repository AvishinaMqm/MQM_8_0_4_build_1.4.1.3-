object FOORulesCase: TFOORulesCase
  Left = 0
  Top = 248
  Caption = 'Cases found'
  ClientHeight = 210
  ClientWidth = 965
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 965
    Height = 169
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TbsAfter
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TbsBefore: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Before'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TbsAfter: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'After'
      ImageIndex = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 965
    Height = 41
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 1
    object LlbClacSetupTime: TLabel
      Left = 17
      Top = 10
      Width = 63
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Setup time'
    end
    object StCalcsetupTime: TStaticText
      Left = 160
      Top = 10
      Width = 100
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = 14803425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
  end
end
