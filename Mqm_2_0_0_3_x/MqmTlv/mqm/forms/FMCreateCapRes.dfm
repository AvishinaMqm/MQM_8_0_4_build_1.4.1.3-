object FCreateCapRes: TFCreateCapRes
  Left = 245
  Top = 202
  BorderIcons = []
  Caption = 'Capacity reservation'
  ClientHeight = 365
  ClientWidth = 660
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 660
    Height = 328
    ActivePage = tbsParams
    Align = alClient
    OwnerDraw = True
    TabOrder = 0
    OnDrawTab = PageControl1DrawTab
    object tbsParams: TTabSheet
      Caption = 'Parameters'
      object GroupBox5: TGroupBox
        Left = 0
        Top = 252
        Width = 652
        Height = 48
        Align = alBottom
        Caption = 'Comment'
        TabOrder = 0
        object EdtComment: TEdit
          Left = 7
          Top = 18
          Width = 525
          Height = 21
          Color = 14803425
          MaxLength = 30
          TabOrder = 0
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 65
        Width = 652
        Height = 187
        Align = alClient
        TabOrder = 1
        object LblResource: TLabel
          Left = 17
          Top = 76
          Width = 46
          Height = 13
          Caption = 'Resource'
        end
        object LblWrkCtr: TLabel
          Left = 201
          Top = 75
          Width = 59
          Height = 13
          Caption = 'Work center'
        end
        object LblClrDesc: TLabel
          Left = 201
          Top = 31
          Width = 78
          Height = 13
          Caption = 'Color description'
        end
        object LblUpToCase: TLabel
          Left = 17
          Top = 121
          Width = 104
          Height = 13
          Caption = 'Compatibility case limit'
        end
        object LblProcess: TLabel
          Left = 16
          Top = 32
          Width = 38
          Height = 13
          Caption = 'Process'
        end
        object CBProcess: TComboBox
          Left = 16
          Top = 49
          Width = 145
          Height = 21
          Color = 14803425
          Enabled = False
          TabOrder = 0
        end
        object CBResource: TComboBox
          Left = 16
          Top = 93
          Width = 145
          Height = 21
          Color = 14803425
          TabOrder = 1
        end
        object CBClrDesc: TComboBox
          Left = 200
          Top = 48
          Width = 209
          Height = 19
          Style = csOwnerDrawFixed
          Color = 14803425
          ItemHeight = 13
          TabOrder = 2
          OnChange = CBClrDescChange
          OnDrawItem = CBClrDescDrawItem
        end
        object CBWrkCtr: TComboBox
          Left = 200
          Top = 93
          Width = 145
          Height = 21
          Color = 14803425
          TabOrder = 3
          OnChange = CBWrkCtrChange
        end
        object SpEdtUpToCase: TExSpinEdit
          Left = 17
          Top = 139
          Width = 41
          Height = 22
          ArrowColor = 15972184
          Color = 14803425
          MaxValue = 98
          MinValue = 0
          TabOrder = 4
          Value = 0
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 652
        Height = 65
        Align = alTop
        TabOrder = 2
        object GBDuration: TGroupBox
          Left = 231
          Top = 1
          Width = 178
          Height = 63
          Align = alClient
          Caption = 'Duration'
          TabOrder = 0
          object LblDays: TLabel
            Left = 7
            Top = 15
            Width = 24
            Height = 13
            Caption = 'Days'
          end
          object LblHours: TLabel
            Left = 62
            Top = 15
            Width = 28
            Height = 13
            Caption = 'Hours'
          end
          object LblMinutes: TLabel
            Left = 117
            Top = 15
            Width = 37
            Height = 13
            Caption = 'Minutes'
          end
          object SEDays: TExSpinEdit
            Left = 6
            Top = 30
            Width = 50
            Height = 22
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 0
            MinValue = 0
            TabOrder = 0
            Value = 0
            OnChange = SEDaysChange
          end
          object SEHours: TExSpinEdit
            Left = 61
            Top = 30
            Width = 50
            Height = 22
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 1
            Value = 0
            OnChange = SEHoursChange
          end
          object SEMinutes: TExSpinEdit
            Left = 116
            Top = 30
            Width = 50
            Height = 22
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 59
            MinValue = 0
            TabOrder = 2
            Value = 0
            OnChange = SEMinutesChange
          end
        end
        object GBEndDate: TGroupBox
          Left = 409
          Top = 1
          Width = 242
          Height = 63
          Align = alRight
          Caption = 'End date'
          TabOrder = 1
          object LblEndDate: TLabel
            Left = 9
            Top = 15
            Width = 23
            Height = 13
            Caption = 'Date'
          end
          object LblEndTime: TLabel
            Left = 128
            Top = 11
            Width = 23
            Height = 13
            Caption = 'Time'
          end
          object DTPEndDate: TDateTimePicker
            Left = 7
            Top = 30
            Width = 111
            Height = 21
            Date = 38420.000000000000000000
            Time = 0.638900092599215000
            Color = 14803425
            DoubleBuffered = True
            ParentDoubleBuffered = False
            TabOrder = 0
            StyleName = 'datatex1'
            OnCloseUp = DTPEndDateChange
          end
          object DTPEndTime: TDateTimePicker
            Left = 128
            Top = 30
            Width = 89
            Height = 21
            Date = 38420.000000000000000000
            Time = 0.640211400510452200
            Color = 14803425
            Kind = dtkTime
            TabOrder = 1
            StyleName = 'datatex1'
            OnChange = DTPEndTimeChange
          end
        end
        object GBStDate: TGroupBox
          Left = 1
          Top = 1
          Width = 230
          Height = 63
          Align = alLeft
          Caption = 'Start date'
          TabOrder = 2
          object LblStDate: TLabel
            Left = 9
            Top = 15
            Width = 23
            Height = 13
            Caption = 'Date'
          end
          object LblStTime: TLabel
            Left = 135
            Top = 15
            Width = 23
            Height = 13
            Caption = 'Time'
          end
          object DTPStDate: TDateTimePicker
            Left = 7
            Top = 30
            Width = 122
            Height = 21
            Date = 38420.000000000000000000
            Time = 0.638900092599215000
            Color = 14803425
            TabOrder = 0
            StyleName = 'datatex1'
            OnChange = DTPStDateChange
          end
          object DTPStTime: TDateTimePicker
            Left = 135
            Top = 30
            Width = 89
            Height = 21
            Date = 38420.000000000000000000
            Time = 0.640211400510452200
            Color = 14803425
            Kind = dtkTime
            TabOrder = 1
            StyleName = 'datatex1'
            OnChange = DTPStTimeChange
          end
        end
      end
    end
    object TabProp: TTabSheet
      Caption = 'Properties'
      ImageIndex = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 328
    Width = 660
    Height = 37
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      660
      37)
    object BtnOk: TcxButton
      Left = 452
      Top = 6
      Width = 93
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnAbort: TcxButton
      Left = 551
      Top = 6
      Width = 95
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnAbortClick
    end
    object BtnDetach: TcxButton
      Left = 8
      Top = 6
      Width = 93
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Detach'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 2
      OnClick = BtnDetachClick
    end
  end
end
