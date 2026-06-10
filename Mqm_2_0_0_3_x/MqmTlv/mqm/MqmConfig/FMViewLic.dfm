object FViewLic: TFViewLic
  Left = 300
  Top = 217
  Caption = 'FViewLic'
  ClientHeight = 335
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PanBtn: TPanel
    Left = 0
    Top = 284
    Width = 616
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 0
    object BtnOk: TBitBtn
      Left = 482
      Top = 10
      Width = 93
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BtnViewCurr: TButton
      Left = 266
      Top = 10
      Width = 139
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'View current'
      TabOrder = 1
      OnClick = BtnViewCurrClick
    end
    object BtnInstall: TButton
      Left = 148
      Top = 10
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Install'
      TabOrder = 2
      OnClick = BtnInstallClick
    end
    object BtnLoad: TButton
      Left = 20
      Top = 10
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Load'
      TabOrder = 3
      OnClick = BtnLoadClick
    end
  end
  object MmLic: TMemo
    Left = 0
    Top = 0
    Width = 616
    Height = 284
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object OpenLic: TOpenDialog
    DefaultExt = 'mlc'
    FileName = 'MQMlic.mlc'
    Filter = 'MQM licence|*.mlc|MQM lock|*.lck'
    Left = 104
    Top = 208
  end
end
