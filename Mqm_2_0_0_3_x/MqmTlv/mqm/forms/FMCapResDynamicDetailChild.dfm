object CapResDynamicDetailChild: TCapResDynamicDetailChild
  Left = 0
  Top = 0
  Caption = 'CapResDynamicDetailChild'
  ClientHeight = 416
  ClientWidth = 678
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 371
    Width = 678
    Height = 45
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      678
      45)
    object BtnOk: TcxButton
      Left = 437
      Top = 7
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
      Top = 7
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
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 678
    Height = 371
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = tbsParams
    Align = alClient
    TabOrder = 1
    object tbsParams: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Parameters'
      object GBStDate: TGroupBox
        Left = 0
        Top = 0
        Width = 222
        Height = 80
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alLeft
        Caption = 'Start date'
        TabOrder = 0
        object LblStDate: TLabel
          Left = 11
          Top = 18
          Width = 26
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Date'
        end
        object LblStTime: TLabel
          Left = 126
          Top = 18
          Width = 29
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Time'
        end
        object DTPStDate: TDateTimePicker
          Left = 9
          Top = 37
          Width = 110
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Date = 38420.000000000000000000
          Time = 0.638900092599215000
          Color = 14803425
          Enabled = False
          TabOrder = 0
        end
        object DTPStTime: TDateTimePicker
          Left = 123
          Top = 37
          Width = 86
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Date = 38420.000000000000000000
          Time = 0.640211400510452200
          Color = 14803425
          Enabled = False
          Kind = dtkTime
          TabOrder = 1
        end
      end
      object GBDuration: TGroupBox
        Left = 222
        Top = 0
        Width = 227
        Height = 80
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Caption = 'Duration'
        TabOrder = 1
        object LblDays: TLabel
          Left = 11
          Top = 18
          Width = 27
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Days'
        end
        object SEDays: TExSpinEdit
          Left = 10
          Top = 37
          Width = 61
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
      end
      object GBEndDate: TGroupBox
        Left = 449
        Top = 0
        Width = 221
        Height = 80
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alRight
        Caption = 'End date'
        TabOrder = 2
        object LblEndDate: TLabel
          Left = 11
          Top = 18
          Width = 26
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Date'
        end
        object DTPEndDate: TDateTimePicker
          Left = 9
          Top = 37
          Width = 110
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Date = 38420.000000000000000000
          Time = 0.638900092599215000
          Color = 14803425
          Enabled = False
          TabOrder = 0
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 80
        Width = 670
        Height = 260
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        TabOrder = 3
        object LblResource: TLabel
          Left = 14
          Top = 16
          Width = 53
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Resource'
        end
        object LblClrDesc: TLabel
          Left = 221
          Top = 18
          Width = 96
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Color description'
        end
        object LblUpToCase: TLabel
          Left = 217
          Top = 73
          Width = 131
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Compatibility case limit'
        end
        object LblSequence: TLabel
          Left = 12
          Top = 73
          Width = 56
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Sequence'
        end
        object CBResource: TComboBox
          Left = 11
          Top = 36
          Width = 178
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          Enabled = False
          TabOrder = 0
        end
        object CBClrDesc: TComboBox
          Left = 219
          Top = 39
          Width = 259
          Height = 19
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csOwnerDrawFixed
          Color = 14803425
          ItemHeight = 13
          TabOrder = 1
          OnDrawItem = CBClrDescDrawItem
        end
        object SpEdtUpToCase: TExSpinEdit
          Left = 217
          Top = 96
          Width = 51
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          MaxValue = 98
          MinValue = 0
          TabOrder = 2
          Value = 0
        end
        object GroupBox5: TGroupBox
          Left = 2
          Top = 199
          Width = 666
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alBottom
          Caption = 'Comment'
          TabOrder = 3
          object EdtComment: TEdit
            Left = 9
            Top = 22
            Width = 646
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            MaxLength = 30
            TabOrder = 0
          end
        end
        object SEdtSequence: TExSpinEdit
          Left = 14
          Top = 96
          Width = 49
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
          TabOrder = 4
          Value = 0
        end
      end
    end
    object TabProp: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Properties'
      ImageIndex = 1
    end
  end
end
