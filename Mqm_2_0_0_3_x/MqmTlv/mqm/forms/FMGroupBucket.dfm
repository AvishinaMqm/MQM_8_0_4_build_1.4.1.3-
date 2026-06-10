object FGroupBucket: TFGroupBucket
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Group Bucket'
  ClientHeight = 745
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Montserrat'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 144
  TextHeight = 18
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 533
    Height = 676
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 755
    object Label3: TLabel
      Left = 21
      Top = 444
      Width = 86
      Height = 18
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'Bucket type'
    end
    object Label4: TLabel
      Left = 21
      Top = 514
      Width = 141
      Height = 18
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'Number of buckets '
    end
    object Label1: TLabel
      Left = 260
      Top = 444
      Width = 99
      Height = 18
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'Starting Date '
    end
    object LblFromDate: TLabel
      Left = 260
      Top = 612
      Width = 73
      Height = 18
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'From date'
    end
    object lbStart: TLabel
      Left = 356
      Top = 612
      Width = 48
      Height = 18
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'lbStart'
    end
    object Label2: TLabel
      Left = 260
      Top = 642
      Width = 52
      Height = 18
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'To date'
    end
    object lbEnd: TLabel
      Left = 356
      Top = 642
      Width = 48
      Height = 18
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'lbStart'
    end
    object Label6: TLabel
      Left = 21
      Top = 575
      Width = 164
      Height = 60
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      AutoSize = False
      Caption = 'Round quantity (power of ten)'
      WordWrap = True
    end
    object EditBucketNumber: TEdit
      Left = 21
      Top = 540
      Width = 53
      Height = 26
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Color = 14803425
      NumbersOnly = True
      TabOrder = 1
      Text = '10'
      OnChange = EditBucketNumberChange
    end
    object CBBucketType: TComboBox
      Left = 21
      Top = 470
      Width = 164
      Height = 26
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Style = csDropDownList
      Color = 14803425
      ItemIndex = 1
      TabOrder = 0
      Text = 'Weekly'
      OnChange = CBBucketTypeChange
      Items.Strings = (
        'Monthly'
        'Weekly'
        'Daily')
    end
    object cboxColVis: TCheckListBox
      Left = 1
      Top = 1
      Width = 531
      Height = 432
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      Color = 14803425
      ItemHeight = 20
      TabOrder = 2
      OnClickCheck = cboxColVisClickCheck
    end
    object cbStartingDate: TComboBox
      Left = 260
      Top = 470
      Width = 163
      Height = 26
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Style = csDropDownList
      Color = 14803425
      ItemIndex = 0
      TabOrder = 3
      Text = 'Current period'
      OnChange = cbStartingDateChange
      Items.Strings = (
        'Current period'
        'Current date'
        'Next period')
    end
    object CBRound: TComboBox
      Left = 21
      Top = 629
      Width = 90
      Height = 26
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Style = csDropDownList
      Color = 14803425
      ItemIndex = 2
      TabOrder = 4
      Text = '2'
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
    object GroupBox1: TGroupBox
      Left = 248
      Top = 513
      Width = 223
      Height = 88
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Bucket content'
      TabOrder = 5
      StyleElements = [seFont, seClient]
      object cbQty: TCheckBox
        Left = 24
        Top = 26
        Width = 146
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Quantity'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object cbNumofMac: TCheckBox
        Left = 24
        Top = 59
        Width = 195
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Num. of Machines'
        TabOrder = 1
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 676
    Width = 533
    Height = 69
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 755
    object BitBtn1: TcxButton
      Left = 341
      Top = 10
      Width = 126
      Height = 44
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Close'
      TabOrder = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Montserrat'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BitBtn1Click
    end
    object BtnCreate: TcxButton
      Left = 21
      Top = 10
      Width = 112
      Height = 44
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Create'
      TabOrder = 1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      OnClick = BtnCreateClick
    end
  end
end
