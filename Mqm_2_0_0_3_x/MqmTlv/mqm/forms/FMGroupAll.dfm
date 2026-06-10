object TGroupAllLines: TTGroupAllLines
  Left = 440
  Top = 293
  BorderIcons = [biSystemMenu]
  Caption = 'Jobs in group'
  ClientHeight = 290
  ClientWidth = 742
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  TextHeight = 16
  object GroupBox1: TGroupBox
    Left = 11
    Top = 7
    Width = 360
    Height = 224
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Limit Group quantity'
    TabOrder = 0
    object LblResUm: TLabel
      Left = 148
      Top = 121
      Width = 91
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resource UoM'
    end
    object LblMinQty: TLabel
      Left = 17
      Top = 158
      Width = 102
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Minimum quantity'
    end
    object LblMaxQty: TLabel
      Left = 213
      Top = 158
      Width = 106
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Maximum quantity'
    end
    object ConvertJobQtyUm: TRadioGroup
      Left = 20
      Top = 39
      Width = 286
      Height = 56
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Convert job quantity to resource UoM'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'No'
        'Yes')
      TabOrder = 0
    end
    object ResUmList: TComboBox
      Left = 20
      Top = 116
      Width = 114
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = csDropDownList
      Color = 14803425
      TabOrder = 1
    end
    object EditMinQty: TEdit
      Left = 20
      Top = 182
      Width = 149
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      MaxLength = 9
      TabOrder = 2
      Text = '0'
      OnKeyPress = EditQtyKeyPress
    end
    object EditMaxQty: TEdit
      Left = 215
      Top = 182
      Width = 136
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      MaxLength = 9
      TabOrder = 3
      Text = '999999999'
      OnKeyPress = EditQtyKeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 378
    Top = 72
    Width = 355
    Height = 90
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Limit number of jobs in a group '
    TabOrder = 1
    object LblMinNumberOfJob: TLabel
      Left = 17
      Top = 22
      Width = 53
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Minimum'
    end
    object LblMaxNumberJobs: TLabel
      Left = 183
      Top = 22
      Width = 57
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Maximum'
    end
    object EditMaxNumberJobs: TEdit
      Left = 183
      Top = 48
      Width = 122
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      MaxLength = 5
      TabOrder = 0
      Text = '200'
      OnKeyPress = EditQtyKeyPress
    end
    object EditMinNumberJobs: TEdit
      Left = 17
      Top = 48
      Width = 135
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      MaxLength = 5
      TabOrder = 1
      Text = '0'
      OnKeyPress = EditQtyKeyPress
    end
  end
  object GroupBox3: TGroupBox
    Left = 378
    Top = 4
    Width = 355
    Height = 68
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Number of different material families in the group'
    TabOrder = 2
    object EditNumOfMatFamiliyInGroup: TEdit
      Left = 17
      Top = 27
      Width = 149
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      MaxLength = 5
      TabOrder = 0
      Text = '0'
      OnKeyPress = EditQtyKeyPress
    end
  end
  object GroupBox5: TGroupBox
    Left = 378
    Top = 165
    Width = 354
    Height = 62
    Caption = 'Tolerance in days for latest end date'
    TabOrder = 3
    OnClick = GroupBox5Click
    object SEdtBefLatestlDays: TExSpinEdit
      Left = 17
      Top = 26
      Width = 60
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ArrowColor = 15972184
      Color = 14803425
      MaxLength = 3
      MaxValue = 100
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
  end
  object BitBtn2: TcxButton
    Left = 11
    Top = 252
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
    TabOrder = 4
    OnClick = BitBtn2Click
  end
  object BitBtn1: TcxButton
    Left = 637
    Top = 252
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
    TabOrder = 5
    OnClick = BitBtn1Click
  end
end
