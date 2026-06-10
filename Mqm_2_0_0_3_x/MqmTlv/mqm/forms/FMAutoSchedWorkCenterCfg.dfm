object FAutoSchedWcCfg: TFAutoSchedWcCfg
  Left = 0
  Top = 0
  Width = 589
  Height = 548
  Anchors = [akLeft, akTop, akRight, akBottom]
  AutoScroll = True
  AutoSize = True
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'Auto sched work center configuration'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object GroupBox3: TGroupBox
    Left = 0
    Top = 0
    Width = 573
    Height = 509
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
    DesignSize = (
      573
      509)
    object LblWorkCnter: TLabel
      Left = 46
      Top = 19
      Width = 84
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Alignment = taCenter
      Caption = 'Work center'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblAutoSchedCfg: TLabel
      Left = 202
      Top = 18
      Width = 92
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Configuration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 340
      Top = 19
      Width = 153
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Standard slot duration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SB_Frames: TScrollBox
      Left = 16
      Top = 51
      Width = 544
      Height = 400
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      TabOrder = 0
    end
    object BitBtn1: TcxButton
      Left = 366
      Top = 466
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
      TabOrder = 1
      OnClick = BitBtn1Click
    end
    object BitAbort: TcxButton
      Left = 465
      Top = 466
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
      TabOrder = 2
      OnClick = BitAbortClick
    end
  end
end
