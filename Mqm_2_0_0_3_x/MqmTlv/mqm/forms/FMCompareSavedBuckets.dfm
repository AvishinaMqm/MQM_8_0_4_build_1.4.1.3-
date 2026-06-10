object FCompareSaved: TFCompareSaved
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Compare saved plan buckets'
  ClientHeight = 155
  ClientWidth = 949
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Montserrat'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 14
  object Label1: TLabel
    Left = 95
    Top = 107
    Width = 29
    Height = 14
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Type:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 125
    Width = 949
    Height = 30
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alBottom
    TabOrder = 0
    ExplicitWidth = 679
    DesignSize = (
      949
      30)
    object Button1: TcxButton
      Left = 830
      Top = 3
      Width = 53
      Height = 22
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Anchors = [akTop, akRight]
      Caption = 'OK'
      TabOrder = 0
      OnClick = Button1Click
      ExplicitLeft = 560
    end
    object Button2: TcxButton
      Left = 887
      Top = 3
      Width = 55
      Height = 22
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Anchors = [akTop, akRight]
      Caption = 'Abort'
      TabOrder = 1
      OnClick = Button2Click
      ExplicitLeft = 617
    end
  end
  object cbPlan: TCheckBox
    Left = 471
    Top = 107
    Width = 123
    Height = 14
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Current plan'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = cbPlanClick
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 949
    Height = 18
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alTop
    TabOrder = 2
    ExplicitWidth = 679
    object Label3: TLabel
      Left = 204
      Top = 2
      Width = 26
      Height = 14
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Set 1'
    end
    object Label4: TLabel
      Left = 685
      Top = 2
      Width = 28
      Height = 14
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Set 2'
    end
  end
  object cbType: TComboBox
    Left = 132
    Top = 103
    Width = 66
    Height = 22
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Style = csDropDownList
    ItemIndex = 1
    TabOrder = 3
    Text = 'Step'
    Items.Strings = (
      'Resource'
      'Step')
  end
  object sgMain: TStringGrid
    Left = 0
    Top = 22
    Width = 457
    Height = 81
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ColCount = 4
    DefaultColWidth = 45
    DefaultRowHeight = 10
    FixedCols = 0
    RowCount = 6
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goFixedRowDefAlign]
    TabOrder = 4
  end
  object sgSec: TStringGrid
    Left = 471
    Top = 22
    Width = 471
    Height = 81
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ColCount = 4
    DefaultColWidth = 45
    DefaultRowHeight = 10
    Enabled = False
    FixedCols = 0
    RowCount = 6
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goFixedRowDefAlign]
    TabOrder = 5
  end
end
