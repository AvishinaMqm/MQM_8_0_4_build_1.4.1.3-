object MWkst: TMWkst
  Left = 421
  Top = 388
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 140
  ClientWidth = 341
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 144
  DesignSize = (
    341
    140)
  TextHeight = 17
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 341
    Height = 140
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alClient
    ExplicitLeft = -2
    ExplicitWidth = 484
    ExplicitHeight = 239
  end
  object LblSelect: TLabel
    Left = 21
    Top = 11
    Width = 283
    Height = 24
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    AutoSize = False
    Caption = 'workstation code'
    StyleName = 'datatex1'
  end
  object LblPassword: TLabel
    Left = 21
    Top = 78
    Width = 234
    Height = 24
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'aaaaaaaa'
    ExplicitTop = 111
  end
  object LblIdentifier: TLabel
    Left = 235
    Top = 73
    Width = 101
    Height = 24
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    AutoSize = False
    Caption = 'Environment'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object EdPswd: TEdit
    Left = 21
    Top = 100
    Width = 316
    Height = 25
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akBottom]
    Color = 16513785
    PasswordChar = '*'
    TabOrder = 0
    OnKeyPress = cboxListWrkstKeyPress
    ExplicitTop = 117
  end
  object cboxListWrkst: TComboBox
    Left = 21
    Top = 31
    Width = 196
    Height = 25
    Cursor = crIBeam
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 1
    Text = 'cboxListWrkst'
    StyleName = 'Datatex1'
    OnKeyPress = cboxListWrkstKeyPress
  end
  object ElComboBoxIdentifier: TComboBox
    Left = 21
    Top = 70
    Width = 196
    Height = 25
    Cursor = crIBeam
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = 'AVI012'
    OnChange = ElComboBoxIdentifierChange
    OnKeyPress = cboxListWrkstKeyPress
  end
  object BtnApply: TcxButton
    Left = 227
    Top = 29
    Width = 110
    Height = 33
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'BtnApply'
    TabOrder = 3
    OnClick = BtnApplyClick
  end
  object Timer: TTimer
    Left = 136
    Top = 57
  end
end
