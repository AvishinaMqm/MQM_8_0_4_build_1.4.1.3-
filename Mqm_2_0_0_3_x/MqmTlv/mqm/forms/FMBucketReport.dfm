object FBucketReport: TFBucketReport
  Left = 514
  Top = 318
  Caption = 'Excel Bucket Report'
  ClientHeight = 522
  ClientWidth = 529
  Color = clBtnFace
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
  object Label5: TLabel
    Left = 47
    Top = 286
    Width = 70
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Bucket type'
  end
  object Panel1: TPanel
    Left = 0
    Top = 470
    Width = 529
    Height = 52
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 446
    object BtnCreate: TcxButton
      Left = 18
      Top = 12
      Width = 93
      Height = 30
      Caption = 'Create'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BtnExcelBucketReportClick
    end
    object BitBtn1: TcxButton
      Left = 380
      Top = 7
      Width = 95
      Height = 30
      Caption = 'Close'
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
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 529
    Height = 470
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 5
    object Label1: TLabel
      Left = 18
      Top = 6
      Width = 79
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Work centers'
    end
    object Label2: TLabel
      Left = 289
      Top = 6
      Width = 66
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resources'
    end
    object LblFromDate: TLabel
      Left = 18
      Top = 226
      Width = 61
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'From date'
    end
    object Label3: TLabel
      Left = 18
      Top = 286
      Width = 70
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Bucket type'
    end
    object Label4: TLabel
      Left = 184
      Top = 286
      Width = 115
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Number of buckets '
    end
    object Label6: TLabel
      Left = 185
      Top = 353
      Width = 179
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Round quantity (power of ten)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object LabelSortCrit: TLabel
      Left = 380
      Top = 353
      Width = 118
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Number of grouping fields'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label7: TLabel
      Left = 18
      Top = 353
      Width = 159
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Calendar to calculate last bucket'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object ChkLstBoxRsc: TCheckListBox
      Left = 289
      Top = 30
      Width = 209
      Height = 188
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 0
    end
    object ChkLstBoxWkc: TCheckListBox
      Left = 18
      Top = 30
      Width = 207
      Height = 188
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 1
      OnClickCheck = ChkLstBoxWkcClickCheck
    end
    object DateTimePickerDate: TDateTimePicker
      Left = 18
      Top = 250
      Width = 207
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 44050.000000000000000000
      Time = 0.837262002314673700
      Color = 14803425
      DateFormat = dfLong
      TabOrder = 2
      StyleName = 'datatex1'
    end
    object DateTimePickerTime: TDateTimePicker
      Left = 289
      Top = 254
      Width = 123
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 38837.000000000000000000
      Time = 38837.000000000000000000
      Color = 14803425
      Kind = dtkTime
      TabOrder = 3
      StyleName = 'datatex1'
    end
    object CBBucketType: TComboBox
      Left = 18
      Top = 310
      Width = 99
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 4
      Text = 'Monthly'
      OnChange = CBBucketTypeChange
      Items.Strings = (
        'Monthly'
        'Weekly'
        'Daily'
        'Hourly'
        'Shift')
    end
    object EditBucketNumber: TEdit
      Left = 196
      Top = 310
      Width = 70
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 5
      Text = '1'
      OnChange = EditBucketNumberChange
    end
    object ComboBoxCalList: TComboBox
      Left = 18
      Top = 393
      Width = 99
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BiDiMode = bdLeftToRight
      Color = 14803425
      ParentBiDiMode = False
      TabOrder = 6
      Visible = False
    end
    object ComBoxSortCrits: TComboBox
      Left = 380
      Top = 393
      Width = 51
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 7
      Items.Strings = (
        '0'
        '1'
        '2'
        '3'
        '4')
    end
  end
  object CBRound: TComboBox
    Left = 206
    Top = 393
    Width = 60
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    Color = 14803425
    ItemIndex = 0
    TabOrder = 2
    Text = '0'
    Items.Strings = (
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9')
  end
end
