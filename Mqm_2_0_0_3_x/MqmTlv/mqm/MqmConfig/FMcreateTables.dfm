object CreateTables: TCreateTables
  Left = 570
  Top = 115
  BorderStyle = bsDialog
  Caption = 'Create local tables'
  ClientHeight = 188
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 273
    Height = 188
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object Gauge1: TGauge
      Left = 10
      Top = 165
      Width = 252
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ForeColor = clHighlight
      Progress = 0
      Visible = False
    end
    object lbStep: TLabel
      Left = 10
      Top = 148
      Width = 39
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'lbStep'
      Visible = False
    end
    object CrtMainDB: TButton
      Left = 44
      Top = 47
      Width = 185
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Create main database'
      TabOrder = 0
      OnClick = CrtMainDBClick
    end
    object CrtCfgDB: TButton
      Left = 44
      Top = 15
      Width = 185
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Create cfg database'
      TabOrder = 1
      OnClick = CrtCfgDBClick
    end
    object UpdMainDB: TButton
      Left = 44
      Top = 116
      Width = 185
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Update main database'
      TabOrder = 2
      OnClick = UpdMainDBClick
    end
    object UpdCfgDB: TButton
      Left = 44
      Top = 84
      Width = 185
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Update cfg database'
      TabOrder = 3
      OnClick = UpdCfgDBClick
    end
  end
end
