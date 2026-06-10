object FBarConfigSets: TFBarConfigSets
  Left = 144
  Top = 126
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 1
  Caption = 'Bar sets'
  ClientHeight = 257
  ClientWidth = 547
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object GroupBox1: TGroupBox
    Left = 316
    Top = 0
    Width = 231
    Height = 257
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Caption = 'Enter a new set'
    TabOrder = 0
    ExplicitWidth = 225
    ExplicitHeight = 240
    object LblNewSetName: TLabel
      Left = 30
      Top = 59
      Width = 119
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Enter new set name:'
    end
    object EditNewSetName: TEdit
      Left = 30
      Top = 89
      Width = 148
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 0
    end
    object BtnSaveNewSet: TcxButton
      Left = 30
      Top = 120
      Width = 148
      Height = 30
      Caption = 'Create new set'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnSaveNewSetClick
    end
    object BtnAbo: TcxButton
      Left = 30
      Top = 156
      Width = 148
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
      OnClick = BtnAboClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 316
    Height = 257
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alLeft
    Caption = 'Available sets'
    TabOrder = 1
    ExplicitHeight = 240
    object LBListOfSets: TListBox
      Left = 39
      Top = 20
      Width = 148
      Height = 178
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 0
      OnDblClick = LBListOfSetsDblClick
    end
    object BitDeleteSet: TcxButton
      Left = 194
      Top = 42
      Width = 93
      Height = 30
      Caption = 'Delete set'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BitDeleteSetClick
    end
    object BitOpenSet: TcxButton
      Left = 194
      Top = 78
      Width = 93
      Height = 30
      Caption = 'Open set'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 2
      OnClick = BitOpenSetClick
    end
  end
end
