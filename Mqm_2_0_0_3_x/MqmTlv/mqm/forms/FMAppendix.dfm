object FAppendix: TFAppendix
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  BorderWidth = 1
  Caption = 'Appendix'
  ClientHeight = 249
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 345
    Height = 249
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alLeft
    Caption = 'Available sets'
    TabOrder = 0
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
    end
    object BitDeleteSet: TcxButton
      Left = 194
      Top = 42
      Width = 127
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
      Width = 127
      Height = 30
      Caption = 'W.c'#8217's selection'
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
    object Button1: TcxButton
      Left = 194
      Top = 114
      Width = 127
      Height = 30
      Caption = 'Group by'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TcxButton
      Left = 194
      Top = 150
      Width = 127
      Height = 30
      Caption = 'Formula content'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 4
      OnClick = Button2Click
    end
  end
  object GroupBox1: TGroupBox
    Left = 345
    Top = 0
    Width = 198
    Height = 249
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Caption = 'Enter a new set'
    TabOrder = 1
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
end
