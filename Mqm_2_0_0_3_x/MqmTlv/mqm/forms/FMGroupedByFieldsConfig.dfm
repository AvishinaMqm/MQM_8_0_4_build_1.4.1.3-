object FGroupedByFieldsConfig: TFGroupedByFieldsConfig
  Left = 0
  Top = 0
  Caption = 'FGroupedByFieldsConfig'
  ClientHeight = 483
  ClientWidth = 876
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 876
    Height = 50
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Shape = bsFrame
    ExplicitTop = -7
    ExplicitWidth = 335
  end
  object LblSetName: TLabel
    Left = 44
    Top = 8
    Width = 114
    Height = 32
    Caption = 'Set name'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 50
    Width = 876
    Height = 433
    Align = alClient
    Caption = 'Grouped by'
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 19
      Width = 37
      Height = 16
      Caption = 'Fields '
    end
    object CBFieldList: TCheckListBox
      Left = 3
      Top = 41
      Width = 238
      Height = 328
      ParentColor = True
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 258
      Top = 19
      Width = 615
      Height = 350
      ParentColor = True
      TabOrder = 1
    end
    object BitOK: TcxButton
      Left = 674
      Top = 385
      Width = 91
      Height = 35
      Caption = 'OK'
      TabOrder = 2
      OnClick = BitOKClick
    end
    object BitAbort: TcxButton
      Left = 771
      Top = 385
      Width = 95
      Height = 35
      Caption = 'Abort'
      TabOrder = 3
      OnClick = BitAbortClick
    end
  end
end
