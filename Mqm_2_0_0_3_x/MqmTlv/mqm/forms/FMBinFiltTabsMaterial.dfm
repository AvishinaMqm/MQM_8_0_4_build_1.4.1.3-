object TBinFilterMaterial: TTBinFilterMaterial
  Left = 0
  Top = 0
  Caption = 'Bin Filter Material'
  ClientHeight = 600
  ClientWidth = 1077
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 144
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 526
    Width = 1077
    Height = 74
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alBottom
    BevelInner = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      1077
      74)
    object TabName: TLabel
      Left = 34
      Top = 28
      Width = 58
      Height = 16
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Anchors = [akLeft, akBottom]
      Caption = 'Tab name'
    end
    object EditTabName: TEdit
      Left = 121
      Top = 25
      Width = 236
      Height = 24
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Anchors = [akLeft, akBottom]
      Color = 14803425
      TabOrder = 0
    end
    object BtnAbo: TcxButton
      Left = 798
      Top = 22
      Width = 115
      Height = 34
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Anchors = [akRight, akBottom]
      Caption = 'Abort'
      TabOrder = 1
      OnClick = BtnAboClick
    end
    object BtnOk: TcxButton
      Left = 932
      Top = 22
      Width = 120
      Height = 34
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 2
      OnClick = BtnOkClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1077
    Height = 526
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ActivePage = TabFiltervalues
    Align = alClient
    TabOrder = 1
    object TabFiltervalues: TTabSheet
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'General'
      ImageIndex = 4
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 1069
        Height = 495
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alClient
        TabOrder = 0
        DesignSize = (
          1065
          491)
        object bClearall: TcxButton
          Left = 1314
          Top = 676
          Width = 120
          Height = 35
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Anchors = [akRight, akBottom]
          Caption = 'Clear all'
          TabOrder = 0
          OnClick = bClearallClick
        end
        object rgSched: TRadioGroup
          Left = 6
          Top = 266
          Width = 322
          Height = 76
          Margins.Left = 6
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          Caption = 'Show scheduled'
          Columns = 3
          ItemIndex = 1
          Items.Strings = (
            'No'
            'Also'
            'Only')
          TabOrder = 1
          StyleElements = []
        end
        object rgWarplvl: TRadioGroup
          Left = 6
          Top = 354
          Width = 322
          Height = 74
          Margins.Left = 6
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          Caption = 'Warp level'
          Columns = 3
          ItemIndex = 2
          Items.Strings = (
            'Basic'
            'Second'
            'Both')
          TabOrder = 2
          StyleElements = []
        end
        object gbFirst: TGroupBox
          Left = 6
          Top = 11
          Width = 524
          Height = 90
          Caption = 'First Level'
          TabOrder = 3
          object eItemType: TLabeledEdit
            Left = 88
            Top = 23
            Width = 158
            Height = 24
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            AutoSize = False
            EditLabel.Width = 54
            EditLabel.Height = 16
            EditLabel.Margins.Left = 6
            EditLabel.Margins.Top = 6
            EditLabel.Margins.Right = 6
            EditLabel.Margins.Bottom = 6
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = 'Item type'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpLeft
            LabelSpacing = 10
            TabOrder = 0
            Text = ''
          end
          object eProdCode: TLabeledEdit
            Left = 113
            Top = 54
            Width = 400
            Height = 24
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            AutoSize = False
            EditLabel.Width = 74
            EditLabel.Height = 16
            EditLabel.Margins.Left = 6
            EditLabel.Margins.Top = 6
            EditLabel.Margins.Right = 6
            EditLabel.Margins.Bottom = 6
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = 'Product code'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpLeft
            LabelSpacing = 10
            TabOrder = 1
            Text = ''
          end
        end
        object gbSecond: TGroupBox
          Left = 550
          Top = 11
          Width = 503
          Height = 90
          Caption = 'Second Level'
          TabOrder = 4
          object eItemtype2: TLabeledEdit
            Left = 88
            Top = 23
            Width = 182
            Height = 24
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            AutoSize = False
            EditLabel.Width = 54
            EditLabel.Height = 16
            EditLabel.Margins.Left = 6
            EditLabel.Margins.Top = 6
            EditLabel.Margins.Right = 6
            EditLabel.Margins.Bottom = 6
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = 'Item type'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpLeft
            LabelSpacing = 10
            TabOrder = 0
            Text = ''
          end
          object eProdCode2: TLabeledEdit
            Left = 113
            Top = 54
            Width = 379
            Height = 24
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            AutoSize = False
            EditLabel.Width = 74
            EditLabel.Height = 16
            EditLabel.Margins.Left = 6
            EditLabel.Margins.Top = 6
            EditLabel.Margins.Right = 6
            EditLabel.Margins.Bottom = 6
            EditLabel.BiDiMode = bdRightToLeft
            EditLabel.Caption = 'Product code'
            EditLabel.ParentBiDiMode = False
            LabelPosition = lpLeft
            LabelSpacing = 10
            TabOrder = 1
            Text = ''
          end
        end
        object eMatCodeSubDet: TLabeledEdit
          Left = 180
          Top = 183
          Width = 356
          Height = 24
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          AutoSize = False
          EditLabel.Width = 136
          EditLabel.Height = 16
          EditLabel.Margins.Left = 6
          EditLabel.Margins.Top = 6
          EditLabel.Margins.Right = 6
          EditLabel.Margins.Bottom = 6
          EditLabel.BiDiMode = bdRightToLeft
          EditLabel.Caption = 'Material code sub detail'
          EditLabel.ParentBiDiMode = False
          LabelPosition = lpLeft
          LabelSpacing = 10
          TabOrder = 5
          Text = ''
        end
        object eNetGrpCode: TLabeledEdit
          Left = 131
          Top = 145
          Width = 356
          Height = 24
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          AutoSize = False
          EditLabel.Width = 87
          EditLabel.Height = 16
          EditLabel.Margins.Left = 6
          EditLabel.Margins.Top = 6
          EditLabel.Margins.Right = 6
          EditLabel.Margins.Bottom = 6
          EditLabel.BiDiMode = bdRightToLeft
          EditLabel.Caption = 'Net group code'
          EditLabel.ParentBiDiMode = False
          LabelPosition = lpLeft
          LabelSpacing = 10
          TabOrder = 6
          Text = ''
        end
        object eMatCode: TLabeledEdit
          Left = 118
          Top = 108
          Width = 356
          Height = 24
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          AutoSize = False
          EditLabel.Width = 77
          EditLabel.Height = 16
          EditLabel.Margins.Left = 6
          EditLabel.Margins.Top = 6
          EditLabel.Margins.Right = 6
          EditLabel.Margins.Bottom = 6
          EditLabel.BiDiMode = bdRightToLeft
          EditLabel.Caption = 'Material code'
          EditLabel.ParentBiDiMode = False
          LabelPosition = lpLeft
          LabelSpacing = 10
          TabOrder = 7
          Text = ''
        end
      end
    end
    object TabProperty: TTabSheet
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'Properties '
      ImageIndex = 1
    end
  end
end
