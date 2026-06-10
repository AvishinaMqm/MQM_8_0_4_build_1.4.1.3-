object FAutoSchedCfg: TFAutoSchedCfg
  Left = 181
  Top = 90
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Automatic sequencing configuration'
  ClientHeight = 755
  ClientWidth = 1002
  Color = clBtnFace
  Constraints.MinHeight = 715
  Constraints.MinWidth = 827
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object TLabel
    Left = 255
    Top = 210
    Width = 116
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Configuration group'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1002
    Height = 169
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Label4: TLabel
      Left = 12
      Top = 5
      Width = 159
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Saved configurations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lbEdtCfgName: TLabel
      Left = 206
      Top = 50
      Width = 88
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LblNextConfig: TLabel
      Left = 449
      Top = 50
      Width = 382
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Next configuration to try when job schedule fails'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lbEdtCfgDesc: TLabel
      Left = 206
      Top = 109
      Width = 115
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lbEdtCfgGroup: TLabel
      Left = 449
      Top = 112
      Width = 142
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Group code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object LBConfigs: TListBox
      Left = 9
      Top = 29
      Width = 179
      Height = 129
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Montserrat'
      Font.Style = []
      ItemHeight = 15
      ParentFont = False
      TabOrder = 0
      OnClick = LBConfigsClick
    end
    object EdtCfgName: TEdit
      Left = 206
      Top = 74
      Width = 158
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      CharCase = ecUpperCase
      Color = 14803425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 14
      ParentFont = False
      TabOrder = 1
      OnChange = EdtCfgNameChange
    end
    object EdtCfgDesc: TEdit
      Left = 206
      Top = 133
      Width = 224
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 50
      ParentFont = False
      TabOrder = 2
    end
    object EdtCfgGroup: TEdit
      Left = 449
      Top = 133
      Width = 224
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 50
      ParentFont = False
      TabOrder = 3
      Visible = False
    end
    object CBNextConfig: TComboBox
      Left = 449
      Top = 74
      Width = 179
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = csDropDownList
      Color = 14803425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object btnDelete: TcxButton
      Left = 872
      Top = 127
      Width = 113
      Height = 30
      Caption = 'Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 5
      OnClick = BtnDeleteClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 702
    Width = 1002
    Height = 53
    Align = alBottom
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      1002
      53)
    object BtnRstAll: TcxButton
      Left = 13
      Top = 15
      Width = 113
      Height = 30
      Caption = 'Restore all'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BtnRstAllClick
    end
    object BtnOk: TcxButton
      Left = 792
      Top = 15
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
      TabOrder = 1
      OnClick = BtnOkClick
    end
    object btnAbo: TcxButton
      Left = 891
      Top = 15
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
      TabOrder = 2
      OnClick = btnAboClick
    end
    object btnOk1: TBitBtn
      Left = 690
      Top = 15
      Width = 93
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      Enabled = False
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 3
      Visible = False
      OnClick = BtnOk1Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 169
    Width = 1002
    Height = 533
    Align = alClient
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 1000
      Height = 531
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ActivePage = TSSplitJobs
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Montserrat'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object TbsCompLimits: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Compatibility limits'
        DesignSize = (
          992
          502)
        object GBMinComp: TGroupBox
          Left = 0
          Top = 0
          Width = 992
          Height = 110
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Minimum compatibility levels allowed'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object LblMinToResComp: TLabel
            Left = 12
            Top = 28
            Width = 129
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Job to resource (1-98)'
          end
          object LblMinToJobComp: TLabel
            Left = 288
            Top = 28
            Width = 95
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Job to job (1-98)'
          end
          object LblMinToCapResComp: TLabel
            Left = 554
            Top = 28
            Width = 197
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Job to capacity reservation (1-98)'
          end
          object SEdtMinToResComp: TExSpinEdit
            Left = 14
            Top = 57
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 2
            MaxValue = 98
            MinValue = 0
            ParentFont = False
            TabOrder = 0
            Value = 0
          end
          object SEdtMinToJobComp: TExSpinEdit
            Left = 289
            Top = 57
            Width = 61
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 2
            MaxValue = 98
            MinValue = 0
            ParentFont = False
            TabOrder = 1
            Value = 0
          end
          object SEdtMinToCapResComp: TExSpinEdit
            Left = 555
            Top = 57
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 2
            MaxValue = 98
            MinValue = 0
            ParentFont = False
            TabOrder = 2
            Value = 0
          end
        end
        object BtnRstCompLimits: TBitBtn
          Left = 667
          Top = 465
          Width = 142
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Restore'
          Glyph.Data = {
            F2010000424DF201000000000000760000002800000024000000130000000100
            0400000000007C01000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
            3333333333388F3333333333000033334224333333333333338338F333333333
            0000333422224333333333333833338F33333333000033422222243333333333
            83333338F3333333000034222A22224333333338F33F33338F33333300003222
            A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
            38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
            2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
            0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
            333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
            33333A2224A2233333333338F338F83300003333333333A2224A333333333333
            8F338F33000033333333333A222433333333333338F338F30000333333333333
            A224333333333333338F38F300003333333333333A223333333333333338F8F3
            000033333333333333A3333333333333333383330000}
          NumGlyphs = 2
          TabOrder = 1
        end
      end
      object TbsWeights: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Weights'
        ImageIndex = 1
        DesignSize = (
          992
          502)
        object Bevel5: TBevel
          Left = 6
          Top = 55
          Width = 74
          Height = 207
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
        end
        object LblDate: TLabel
          Left = 15
          Top = 62
          Width = 54
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Alignment = taCenter
          AutoSize = False
          Caption = 'Date'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblDelDate: TLabel
          Left = 52
          Top = 32
          Width = 70
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Alignment = taRightJustify
          Caption = 'Target date'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblEffic: TLabel
          Left = 145
          Top = 32
          Width = 57
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Efficiency'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Bevel4: TBevel
          Left = 187
          Top = 55
          Width = 612
          Height = 207
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
        end
        object LblToResComp: TLabel
          Left = 193
          Top = 62
          Width = 129
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Alignment = taCenter
          AutoSize = False
          Caption = 'Job to resource comp.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblToJobComp: TLabel
          Left = 348
          Top = 62
          Width = 123
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Alignment = taCenter
          AutoSize = False
          Caption = 'Job to job comp.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblToCapResComp: TLabel
          Left = 484
          Top = 62
          Width = 172
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Alignment = taCenter
          AutoSize = False
          Caption = 'Job to capacity reserv. comp.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 670
          Top = 62
          Width = 123
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Alignment = taCenter
          AutoSize = False
          Caption = 'Setup change'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object TBarDate: TTrackBar
          Left = 18
          Top = 75
          Width = 56
          Height = 182
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Orientation = trVertical
          ParentShowHint = False
          PageSize = 1
          ShowHint = True
          TabOrder = 0
          TickMarks = tmBoth
          OnChange = TBarChange
        end
        object TrackBar1: TTrackBar
          Left = 86
          Top = 58
          Width = 92
          Height = 55
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Max = 1
          Min = -1
          PageSize = 1
          TabOrder = 1
          TickMarks = tmTopLeft
        end
        object TBarToResComp: TTrackBar
          Left = 231
          Top = 79
          Width = 56
          Height = 182
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Orientation = trVertical
          ParentShowHint = False
          PageSize = 1
          ShowHint = True
          TabOrder = 2
          TickMarks = tmBoth
          OnChange = TBarChange
        end
        object TBarToJobComp: TTrackBar
          Left = 383
          Top = 79
          Width = 55
          Height = 182
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Orientation = trVertical
          ParentShowHint = False
          PageSize = 1
          ShowHint = True
          TabOrder = 3
          TickMarks = tmBoth
          OnChange = TBarChange
        end
        object TBarToCapResComp: TTrackBar
          Left = 543
          Top = 79
          Width = 55
          Height = 182
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Orientation = trVertical
          ParentShowHint = False
          PageSize = 1
          ShowHint = True
          TabOrder = 4
          TickMarks = tmBoth
          OnChange = TBarChange
        end
        object BtnRstWeights: TBitBtn
          Left = 667
          Top = 465
          Width = 142
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Restore'
          Glyph.Data = {
            F2010000424DF201000000000000760000002800000024000000130000000100
            0400000000007C01000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
            3333333333388F3333333333000033334224333333333333338338F333333333
            0000333422224333333333333833338F33333333000033422222243333333333
            83333338F3333333000034222A22224333333338F33F33338F33333300003222
            A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
            38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
            2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
            0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
            333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
            33333A2224A2233333333338F338F83300003333333333A2224A333333333333
            8F338F33000033333333333A222433333333333338F338F30000333333333333
            A224333333333333338F38F300003333333333333A223333333333333338F8F3
            000033333333333333A3333333333333333383330000}
          NumGlyphs = 2
          TabOrder = 5
        end
        object TBarSetup: TTrackBar
          Left = 704
          Top = 79
          Width = 55
          Height = 182
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Orientation = trVertical
          ParentShowHint = False
          PageSize = 1
          ShowHint = True
          TabOrder = 6
          TickMarks = tmBoth
          OnChange = TBarChange
        end
      end
      object TbsDateDef: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Date definitions'
        ImageIndex = 4
        DesignSize = (
          992
          502)
        object GBDateLimits: TGroupBox
          Left = 0
          Top = 57
          Width = 992
          Height = 398
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'Limits'
          TabOrder = 0
          object LblTollAfterDelDate: TLabel
            Left = 490
            Top = 154
            Width = 207
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Tolerance in days for delivery date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object LblTollAfterHighEnd: TLabel
            Left = 490
            Top = 91
            Width = 217
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Tolerance in days for latest end date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object LblTollBeforeLowStart: TLabel
            Left = 490
            Top = 30
            Width = 231
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Tolerance in days for earliest start date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object LblStDate: TLabel
            Left = 15
            Top = 220
            Width = 139
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Do not schedule before'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object SEdtTollAfterDelDate: TExSpinEdit
            Left = 490
            Top = 172
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 100
            MinValue = 0
            ParentFont = False
            TabOrder = 0
            Value = 0
          end
          object SEdtTollAfterHighEnd: TExSpinEdit
            Left = 490
            Top = 110
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 100
            MinValue = 0
            ParentFont = False
            TabOrder = 1
            Value = 0
          end
          object SEdtTollBeforeLowStart: TExSpinEdit
            Left = 490
            Top = 48
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 100
            MinValue = 0
            ParentFont = False
            TabOrder = 2
            Value = 0
          end
          object RGBeforeLowStart: TRadioGroup
            Left = 12
            Top = 22
            Width = 468
            Height = 56
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Schedule before earliest start date'
            Columns = 3
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            Items.Strings = (
              'Allowed'
              'Within tolerance'
              'Not allowed')
            ParentFont = False
            TabOrder = 3
          end
          object RGAfterHighEnd: TRadioGroup
            Left = 12
            Top = 84
            Width = 468
            Height = 55
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Schedule after latest end date'
            Columns = 3
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            Items.Strings = (
              'Allowed'
              'Within tolerance'
              'Not allowed')
            ParentFont = False
            TabOrder = 4
          end
          object RGAfterDelDate: TRadioGroup
            Left = 12
            Top = 145
            Width = 468
            Height = 56
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Schedule after delivery date'
            Columns = 3
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            Items.Strings = (
              'Allowed'
              'Within tolerance'
              'Not allowed')
            ParentFont = False
            TabOrder = 5
          end
          object DTPStDate: TDateTimePicker
            Left = 199
            Top = 217
            Width = 111
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 38420.000000000000000000
            Time = 0.638900092599215000
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 6
          end
        end
        object RGPrefTgtDate: TRadioGroup
          Left = 0
          Top = 0
          Width = 992
          Height = 57
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Target date'
          Columns = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Items.Strings = (
            'Earliest start date'
            'Planned start date'
            'Planned end date'
            'Latest end date')
          ParentFont = False
          TabOrder = 1
        end
        object BtnRstDateDef: TBitBtn
          Left = 667
          Top = 465
          Width = 142
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Restore'
          Glyph.Data = {
            F2010000424DF201000000000000760000002800000024000000130000000100
            0400000000007C01000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
            3333333333388F3333333333000033334224333333333333338338F333333333
            0000333422224333333333333833338F33333333000033422222243333333333
            83333338F3333333000034222A22224333333338F33F33338F33333300003222
            A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
            38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
            2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
            0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
            333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
            33333A2224A2233333333338F338F83300003333333333A2224A333333333333
            8F338F33000033333333333A222433333333333338F338F30000333333333333
            A224333333333333338F38F300003333333333333A223333333333333338F8F3
            000033333333333333A3333333333333333383330000}
          NumGlyphs = 2
          TabOrder = 2
        end
      end
      object TabSheet1: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Entities'
        ImageIndex = 7
        DesignSize = (
          992
          502)
        object LblDays: TLabel
          Left = 524
          Top = 174
          Width = 30
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'days'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 14
          Top = 84
          Width = 273
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Allow to move the following confirmation levels'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object RGMoveObjs: TRadioGroup
          Left = 12
          Top = 10
          Width = 491
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Move already scheduled entities'
          Columns = 3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Items.Strings = (
            'Allowed'
            'Upto latest end date'
            'Not allowed')
          ParentFont = False
          TabOrder = 0
        end
        object BtnRstEntitiesDef: TBitBtn
          Left = 667
          Top = 465
          Width = 142
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Restore'
          Glyph.Data = {
            F2010000424DF201000000000000760000002800000024000000130000000100
            0400000000007C01000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
            3333333333388F3333333333000033334224333333333333338338F333333333
            0000333422224333333333333833338F33333333000033422222243333333333
            83333338F3333333000034222A22224333333338F33F33338F33333300003222
            A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
            38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
            2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
            0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
            333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
            33333A2224A2233333333338F338F83300003333333333A2224A333333333333
            8F338F33000033333333333A222433333333333338F338F30000333333333333
            A224333333333333338F38F300003333333333333A223333333333333338F8F3
            000033333333333333A3333333333333333383330000}
          NumGlyphs = 2
          TabOrder = 1
        end
        object CLBAllowToMove: TCheckListBox
          Left = 12
          Top = 105
          Width = 787
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          Columns = 7
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
      end
      object tbsMaterials: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Materials'
        ImageIndex = 6
        DesignSize = (
          992
          502)
        object BtnRstMaterials: TBitBtn
          Left = 667
          Top = 465
          Width = 142
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Restore'
          Glyph.Data = {
            F2010000424DF201000000000000760000002800000024000000130000000100
            0400000000007C01000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
            3333333333388F3333333333000033334224333333333333338338F333333333
            0000333422224333333333333833338F33333333000033422222243333333333
            83333338F3333333000034222A22224333333338F33F33338F33333300003222
            A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
            38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
            2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
            0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
            333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
            33333A2224A2233333333338F338F83300003333333333A2224A333333333333
            8F338F33000033333333333A222433333333333338F338F30000333333333333
            A224333333333333338F38F300003333333333333A223333333333333338F8F3
            000033333333333333A3333333333333333383330000}
          NumGlyphs = 2
          TabOrder = 0
        end
        object RGSchedWOMat: TRadioGroup
          Left = 12
          Top = 11
          Width = 315
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Schedule without materials'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Items.Strings = (
            'Allowed'
            'Not allowed')
          ParentFont = False
          TabOrder = 1
        end
        object RGSchedWOAddRes: TRadioGroup
          Left = 12
          Top = 149
          Width = 315
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Schedule without additional resources'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Items.Strings = (
            'Allowed'
            'Not allowed')
          ParentFont = False
          TabOrder = 2
        end
      end
      object TbsAlgorithm: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Algorithm'
        ImageIndex = 2
        DesignSize = (
          992
          502)
        object GBGradients: TGroupBox
          Left = 0
          Top = 0
          Width = 992
          Height = 228
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Algorithm gradients'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object LblGradBfrTollLSD: TLabel
            Left = 14
            Top = 20
            Width = 218
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Before tolerance of earliest start date'
          end
          object LblGradBtwToll_LSD: TLabel
            Left = 398
            Top = 20
            Width = 242
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Between tolerance and earliest start date'
          end
          object LblGradBtwLSD_TGTD: TLabel
            Left = 12
            Top = 71
            Width = 250
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Between earliest start date and target date'
          end
          object LblGradBtwTollHED_Del: TLabel
            Left = 398
            Top = 123
            Width = 309
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Between latest end date tolerance and delivery date'
          end
          object LblGradBtwTGTD_HED: TLabel
            Left = 398
            Top = 71
            Width = 236
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Between target date and latest end date'
          end
          object LblGradBtwHED_Toll: TLabel
            Left = 11
            Top = 123
            Width = 244
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Between latest end date and its tolerance'
          end
          object LblGradBtwDel_Toll: TLabel
            Left = 11
            Top = 172
            Width = 234
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Between delivery date and its tolerance'
          end
          object LblGradAftTollDel: TLabel
            Left = 398
            Top = 172
            Width = 167
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'After delivery date tolerance'
          end
          object SEdtGradBfrTollLSD: TExSpinEdit
            Left = 14
            Top = 38
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 999
            MinValue = 0
            ParentFont = False
            TabOrder = 0
            Value = 1
          end
          object SEdtGradBtwToll_LSD: TExSpinEdit
            Left = 398
            Top = 38
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 999
            MinValue = 0
            ParentFont = False
            TabOrder = 1
            Value = 1
          end
          object SEdtGradBtwLSD_TGTD: TExSpinEdit
            Left = 12
            Top = 90
            Width = 61
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 999
            MinValue = 0
            ParentFont = False
            TabOrder = 2
            Value = 1
          end
          object SEdtGradBtwTollHED_Del: TExSpinEdit
            Left = 398
            Top = 142
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 999
            MinValue = 0
            ParentFont = False
            TabOrder = 5
            Value = 1
          end
          object SEdtGradBtwTGTD_HED: TExSpinEdit
            Left = 398
            Top = 90
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 999
            MinValue = 0
            ParentFont = False
            TabOrder = 3
            Value = 1
          end
          object SEdtGradBtwHED_Toll: TExSpinEdit
            Left = 11
            Top = 142
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 999
            MinValue = 0
            ParentFont = False
            TabOrder = 4
            Value = 1
          end
          object SEdtGradBtwDel_Toll: TExSpinEdit
            Left = 11
            Top = 191
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 999
            MinValue = 0
            ParentFont = False
            TabOrder = 6
            Value = 1
          end
          object SEdtGradAftTollDel: TExSpinEdit
            Left = 398
            Top = 191
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            MaxValue = 999
            MinValue = 0
            ParentFont = False
            TabOrder = 7
            Value = 1
          end
        end
        object BtnRstGradients: TBitBtn
          Left = 667
          Top = 465
          Width = 142
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Restore'
          Glyph.Data = {
            F2010000424DF201000000000000760000002800000024000000130000000100
            0400000000007C01000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
            3333333333388F3333333333000033334224333333333333338338F333333333
            0000333422224333333333333833338F33333333000033422222243333333333
            83333338F3333333000034222A22224333333338F33F33338F33333300003222
            A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
            38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
            2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
            0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
            333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
            33333A2224A2233333333338F338F83300003333333333A2224A333333333333
            8F338F33000033333333333A222433333333333338F338F30000333333333333
            A224333333333333338F38F300003333333333333A223333333333333338F8F3
            000033333333333333A3333333333333333383330000}
          NumGlyphs = 2
          TabOrder = 1
        end
      end
      object TbsGroupingSetup: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Grouping Setup'
        ImageIndex = 5
        DesignSize = (
          992
          502)
        object CBoxBAllowGroupsOneJob: TCheckBox
          Left = 30
          Top = 39
          Width = 306
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Allow groups with one job'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object BtnRstGroupSetup: TBitBtn
          Left = 667
          Top = 441
          Width = 142
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Restore'
          Glyph.Data = {
            F2010000424DF201000000000000760000002800000024000000130000000100
            0400000000007C01000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
            3333333333388F3333333333000033334224333333333333338338F333333333
            0000333422224333333333333833338F33333333000033422222243333333333
            83333338F3333333000034222A22224333333338F33F33338F33333300003222
            A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
            38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
            2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
            0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
            333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
            33333A2224A2233333333338F338F83300003333333333A2224A333333333333
            8F338F33000033333333333A222433333333333338F338F30000333333333333
            A224333333333333338F38F300003333333333333A223333333333333338F8F3
            000033333333333333A3333333333333333383330000}
          NumGlyphs = 2
          TabOrder = 1
        end
      end
      object TbsOthers: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Other'
        ImageIndex = 3
        DesignSize = (
          992
          502)
        object LblSleep: TLabel
          Left = 79
          Top = 132
          Width = 214
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Waiting time for each position tested'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SEdtSleep: TExSpinEdit
          Left = 10
          Top = 127
          Width = 60
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 3
          MaxValue = 100
          MinValue = 0
          ParentFont = False
          TabOrder = 0
          Value = 0
        end
        object CBoxRankReport: TCheckBox
          Left = 10
          Top = 170
          Width = 464
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show the rank report of the last scheduled object'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object CBoxLoopErrors: TCheckBox
          Left = 10
          Top = 15
          Width = 287
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Cycle until no priority errors'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object BtnRstOther: TBitBtn
          Left = 667
          Top = 465
          Width = 142
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Restore'
          Glyph.Data = {
            F2010000424DF201000000000000760000002800000024000000130000000100
            0400000000007C01000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
            3333333333388F3333333333000033334224333333333333338338F333333333
            0000333422224333333333333833338F33333333000033422222243333333333
            83333338F3333333000034222A22224333333338F33F33338F33333300003222
            A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
            38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
            2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
            0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
            333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
            33333A2224A2233333333338F338F83300003333333333A2224A333333333333
            8F338F33000033333333333A222433333333333338F338F30000333333333333
            A224333333333333338F38F300003333333333333A223333333333333338F8F3
            000033333333333333A3333333333333333383330000}
          NumGlyphs = 2
          TabOrder = 3
        end
        object RGTempFinal: TRadioGroup
          Left = 10
          Top = 41
          Width = 789
          Height = 75
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Schedule type'
          Columns = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Items.Strings = (
            'Temporary'
            'Final')
          ParentFont = False
          TabOrder = 4
        end
        object CboxGraph: TCheckBox
          Left = 10
          Top = 199
          Width = 464
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show graph on move'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
      end
      object tbsPreferences: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Preferences'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -14
        Font.Name = 'Montserrat'
        Font.Style = [fsBold]
        ImageIndex = 8
        ParentFont = False
        object RGJobSchedDate: TRadioGroup
          Left = 11
          Top = 18
          Width = 697
          Height = 57
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Target date'
          Columns = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          Items.Strings = (
            'Left green line'
            'Right green line'
            'Today '
            'Approval date')
          ParentFont = False
          TabOrder = 0
          OnClick = RGJobSchedDateClick
        end
        object RGAlreadySchedEnt: TRadioGroup
          Left = 12
          Top = 116
          Width = 795
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 
            'Move already scheduled entities displaying all resulting excepti' +
            'ons'
          Columns = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          Items.Strings = (
            'Allowed'
            'Up to latest end date'
            'latest end plus tolerance           '
            'Not allowed')
          ParentFont = False
          TabOrder = 1
          OnClick = RGAlreadySchedEntClick
        end
        object GBAllowEntConfLevel: TGroupBox
          Left = 10
          Top = 182
          Width = 789
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Allow moving entities with the following confirmation levels'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object CLBConLevelsToMove: TCheckListBox
            Left = 10
            Top = 26
            Width = 769
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            Columns = 7
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object RGResSchedType: TRadioGroup
          Left = 11
          Top = 249
          Width = 556
          Height = 66
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Resulting schedule type'
          Columns = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          Items.Strings = (
            'Temporary'
            'Final')
          ParentFont = False
          TabOrder = 3
        end
        object CBoxShowRankReport: TCheckBox
          Left = 12
          Top = 459
          Width = 350
          Height = 23
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show the rank report of the last scheduled object'
          TabOrder = 4
        end
        object RadGrpResLoaded: TRadioGroup
          Left = 716
          Top = 18
          Width = 173
          Height = 57
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Prefer to load  resources'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemIndex = 0
          Items.Strings = (
            'No'
            'Yes')
          ParentFont = False
          TabOrder = 5
        end
        object CBStopOnFirstNotSchedJob: TCheckBox
          Left = 12
          Top = 425
          Width = 541
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 
            'Stop on the first not scheduled job when other jobs under the sa' +
            'me step are scheduled'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object RGLog: TRadioGroup
          Left = 12
          Top = 353
          Width = 408
          Height = 62
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Log information after scheduling'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object EditLogLocation: TEdit
          Left = 255
          Top = 378
          Width = 152
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object CBAllowSchedBeforeNoneMovedConfLevl: TCheckBox
          Left = 12
          Top = 324
          Width = 446
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Allow scheduling before non movable confirmation level'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object CBTextLog: TCheckBox
          Left = 32
          Top = 380
          Width = 215
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Create text file log / location :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          Visible = False
          OnClick = CBTextLogClick
        end
        object CBPrevOrNextLinkedJobIsTheTgtDateWhenScheduled: TCheckBox
          Left = 15
          Top = 82
          Width = 616
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Previous or next linked job is the target date when scheduled'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
        end
        object btnRstPreferences: TcxButton
          Left = 667
          Top = 410
          Width = 113
          Height = 30
          Caption = 'Restore'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 12
          OnClick = btnRstPreferencesClick
        end
      end
      object tbsRequirements: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Requirements'
        ImageIndex = 9
        object RGSchedWOMaterials: TRadioGroup
          Left = 22
          Top = 31
          Width = 315
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Schedule without materials'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          Items.Strings = (
            'Allowed'
            'Not allowed')
          ParentFont = False
          TabOrder = 0
        end
        object RGLinkedRequests: TRadioGroup
          Left = 22
          Top = 228
          Width = 315
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Schedule before or after the linked requests'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          Items.Strings = (
            'Allowed'
            'Not allowed')
          ParentFont = False
          TabOrder = 2
          Visible = False
        end
        object RGSchedWOAddResources: TRadioGroup
          Left = 22
          Top = 129
          Width = 315
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Schedule without additional resources'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          Items.Strings = (
            'Allowed'
            'Not allowed')
          ParentFont = False
          TabOrder = 1
        end
        object RGIgnoreRightOverlapping: TRadioGroup
          Left = 374
          Top = 31
          Width = 315
          Height = 59
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Ignore right overlapping'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          Items.Strings = (
            'No'
            'Yes')
          ParentFont = False
          TabOrder = 3
        end
        object RGIgnoreLeftOverlapping: TRadioGroup
          Left = 374
          Top = 130
          Width = 315
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Ignore left overlapping'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          Items.Strings = (
            'No'
            'Yes')
          ParentFont = False
          TabOrder = 4
        end
        object btnRstRequirements: TcxButton
          Left = 667
          Top = 409
          Width = 113
          Height = 30
          Caption = 'Restore'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 5
          OnClick = btnRstRequirementsClick
        end
      end
      object tbsSchedLimits1: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Schedule Limits'
        ImageIndex = 10
        object GBMinimComp: TGroupBox
          Left = 4
          Top = 15
          Width = 967
          Height = 88
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Compatibility levels allowed'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          object Label5: TLabel
            Left = 4
            Top = 22
            Width = 172
            Height = 15
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Max job to resource case (0-98)'
          end
          object Label6: TLabel
            Left = 245
            Top = 22
            Width = 157
            Height = 15
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Job to job case range  (0-98)'
          end
          object LblJobToCap: TLabel
            Left = 554
            Top = 22
            Width = 201
            Height = 15
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Max job to capacity reservation (1-98)'
          end
          object Label3: TLabel
            Left = 316
            Top = 49
            Width = 6
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '/'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -20
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object SEdtMinCompJobToRes: TExSpinEdit
            Left = 14
            Top = 50
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 2
            MaxValue = 98
            MinValue = 0
            ParentFont = False
            TabOrder = 0
            Value = 0
          end
          object SEdtMaxCompJobToJob: TExSpinEdit
            Left = 340
            Top = 50
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 2
            MaxValue = 98
            MinValue = 0
            ParentFont = False
            TabOrder = 1
            Value = 0
          end
          object SEdtMinCompJobToResComp: TExSpinEdit
            Left = 555
            Top = 50
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 2
            MaxValue = 98
            MinValue = 0
            ParentFont = False
            TabOrder = 2
            Value = 0
          end
          object SEdtMinCompJobToJob: TExSpinEdit
            Left = 246
            Top = 50
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 2
            MaxValue = 98
            MinValue = 0
            ParentFont = False
            TabOrder = 3
            Value = 0
          end
        end
        object GBSchedRange: TGroupBox
          Left = 4
          Top = 106
          Width = 967
          Height = 148
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Schedule Range'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -14
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object Label9: TLabel
            Left = 490
            Top = 78
            Width = 335
            Height = 15
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Tolerance in days/hours/minutes for latest date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            ParentFont = False
          end
          object LBlBeforeErliestDayTolerance: TLabel
            Left = 490
            Top = 15
            Width = 335
            Height = 15
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Tolerance in days/hours/minutes for earliest date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            ParentFont = False
          end
          object SEdtAfterLatDays: TExSpinEdit
            Left = 490
            Top = 98
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 3
            MaxValue = 1000
            MinValue = 0
            ParentFont = False
            TabOrder = 3
            Value = 0
          end
          object SEdtBefEarlDays: TExSpinEdit
            Left = 490
            Top = 37
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 3
            MaxValue = 1000
            MinValue = 0
            ParentFont = False
            TabOrder = 1
            Value = 0
          end
          object RGBeforeEarlDate: TRadioGroup
            Left = 14
            Top = 20
            Width = 468
            Height = 56
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Before approval date if exists or before left green line'
            Columns = 3
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            Items.Strings = (
              'Allowed'
              'Within tolerance'
              'Not allowed')
            ParentFont = False
            TabOrder = 0
            OnClick = RGBeforeEarlDateClick
          end
          object RGAfterLatDate: TRadioGroup
            Left = 12
            Top = 84
            Width = 468
            Height = 55
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'After latest date'
            Columns = 3
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            Items.Strings = (
              'Allowed'
              'Within tolerance'
              'Not allowed')
            ParentFont = False
            TabOrder = 2
            OnClick = RGAfterLatDateClick
          end
          object SEdtBefEarlHours: TExSpinEdit
            Left = 578
            Top = 37
            Width = 61
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 3
            MaxValue = 24
            MinValue = 0
            ParentFont = False
            TabOrder = 4
            Value = 0
          end
          object SEdtBefEarlMinutes: TExSpinEdit
            Left = 667
            Top = 37
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 3
            MaxValue = 60
            MinValue = 0
            ParentFont = False
            TabOrder = 5
            Value = 0
          end
          object SEdtAfterLatHours: TExSpinEdit
            Left = 578
            Top = 98
            Width = 61
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 3
            MaxValue = 24
            MinValue = 0
            ParentFont = False
            TabOrder = 6
            Value = 0
          end
          object SEdtAfterLatMinutes: TExSpinEdit
            Left = 667
            Top = 98
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 3
            MaxValue = 60
            MinValue = 0
            ParentFont = False
            TabOrder = 7
            Value = 0
          end
        end
        object SEdtLimitDaysGapBtwnSubSteps: TExSpinEdit
          Left = 500
          Top = 315
          Width = 60
          Height = 23
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          MaxLength = 3
          MaxValue = 100
          MinValue = 0
          TabOrder = 2
          Value = 0
        end
        object SEdtLimitHoursGapBtwnSubSteps: TExSpinEdit
          Left = 588
          Top = 315
          Width = 61
          Height = 23
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          MaxLength = 3
          MaxValue = 24
          MinValue = 0
          TabOrder = 3
          Value = 0
        end
        object SEdtLimitMinGapBtwnSubSteps: TExSpinEdit
          Left = 677
          Top = 315
          Width = 60
          Height = 23
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          MaxLength = 3
          MaxValue = 60
          MinValue = 0
          TabOrder = 4
          Value = 0
        end
      end
      object ScheduleLimits2: TTabSheet
        Caption = 'Schedule Limits 2'
        ImageIndex = 17
        object GroupBoxLatestDateOfScheduleAllowed: TGroupBox
          Left = 3
          Top = 135
          Width = 983
          Height = 202
          Caption = 'Latest date of schedule allowed'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object Label7: TLabel
            Left = 273
            Top = 146
            Width = 149
            Height = 15
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Number of days'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            ParentFont = False
          end
          object Label10: TLabel
            Left = 15
            Top = 146
            Width = 44
            Height = 15
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            ParentFont = False
          end
          object RadioGroupLatestDateLimit: TRadioGroup
            Left = 9
            Top = 22
            Width = 477
            Height = 45
            Caption = 'Latest date limit'
            Columns = 3
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Montserrat'
            Font.Style = []
            ItemIndex = 0
            Items.Strings = (
              'N/A'
              'Starting date'
              'Ending date')
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
          end
          object ExSpinEditLatestDateOfScheduleNbrOfDays: TExSpinEdit
            Left = 273
            Top = 169
            Width = 61
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 3
            MaxValue = 100
            MinValue = 0
            ParentFont = False
            TabOrder = 1
            Value = 0
          end
          object RadioGroupDateLimitType: TRadioGroup
            Left = 3
            Top = 73
            Width = 958
            Height = 67
            Caption = 'Date limit type'
            Columns = 2
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Montserrat'
            Font.Style = []
            ItemIndex = 1
            Items.Strings = (
              'Specific Date'
              'Number of days from current date'
              'Number of days from "start schedule from"')
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
          end
          object DateTimePickerLatestDateOfSchedule: TDateTimePicker
            Left = 15
            Top = 169
            Width = 115
            Height = 23
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            StyleName = 'datatex1'
          end
        end
        object GBStartScheduleFrom: TGroupBox
          Left = 4
          Top = 4
          Width = 967
          Height = 124
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Start schedule from'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Visible = False
          object LblDateTime: TLabel
            Left = 21
            Top = 69
            Width = 68
            Height = 15
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            ParentFont = False
            Visible = False
          end
          object LblNumDaysFromCurrDate: TLabel
            Left = 272
            Top = 69
            Width = 249
            Height = 15
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Number of days from current date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            ParentFont = False
            Visible = False
          end
          object lblTime: TLabel
            Left = 140
            Top = 69
            Width = 68
            Height = 15
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Time'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            ParentFont = False
            Visible = False
          end
          object RGStartScheduleFrom: TRadioGroup
            Left = 14
            Top = 16
            Width = 855
            Height = 45
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Columns = 3
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            ItemIndex = 0
            Items.Strings = (
              'Current date time '
              'Specific date time'
              'Number of days from current date')
            ParentFont = False
            TabOrder = 0
            Visible = False
            OnClick = RGStartScheduleFromClick
          end
          object DatePicker: TDateTimePicker
            Left = 20
            Top = 88
            Width = 112
            Height = 23
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Visible = False
            StyleName = 'datatex1'
          end
          object TimePicker: TDateTimePicker
            Left = 140
            Top = 88
            Width = 98
            Height = 23
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            Kind = dtkTime
            ParentFont = False
            TabOrder = 2
            Visible = False
            StyleName = 'datatex1'
          end
          object SpinEdtNumDays: TExSpinEdit
            Left = 272
            Top = 88
            Width = 61
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Montserrat'
            Font.Style = []
            MaxLength = 3
            MaxValue = 100
            MinValue = 0
            ParentFont = False
            TabOrder = 3
            Value = 0
            Visible = False
          end
        end
      end
      object tbsSchedScore: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Schedule Score'
        ImageIndex = 11
        object GBPenaltyCompat: TGroupBox
          Left = 15
          Top = 167
          Width = 831
          Height = 154
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Penalty for compatibility discrepancy'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object Label16: TLabel
            Left = 20
            Top = 34
            Width = 93
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Job to resource'
          end
          object Label17: TLabel
            Left = 20
            Top = 98
            Width = 161
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Job to capacity reservation'
          end
          object Label18: TLabel
            Left = 167
            Top = 20
            Width = 78
            Height = 96
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Fixed penalty when schedule without a capacity reservation'
            WordWrap = True
          end
          object EdtJobToRes: TEdit
            Left = 20
            Top = 54
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 6
            ParentFont = False
            TabOrder = 0
            OnExit = EdtEarlBeforeExit
            OnKeyPress = EdtEarlBeforeKeyPress
          end
          object EdtJobToCapRes: TEdit
            Left = 20
            Top = 118
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 6
            ParentFont = False
            TabOrder = 1
            OnExit = EdtEarlBeforeExit
            OnKeyPress = EdtEarlBeforeKeyPress
          end
          object EdtJobNotCapRes: TEdit
            Left = 167
            Top = 54
            Width = 71
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 6
            ParentFont = False
            TabOrder = 2
            OnExit = EdtEarlBeforeExit
            OnKeyPress = EdtEarlBeforeKeyPress
          end
          object GroupBox1: TGroupBox
            Left = 463
            Top = 20
            Width = 316
            Height = 129
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Job to Job'
            TabOrder = 3
            object Label14: TLabel
              Left = 20
              Top = 74
              Width = 77
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Compatibility'
            end
            object Label15: TLabel
              Left = 156
              Top = 74
              Width = 143
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Setup change (per hour)'
            end
            object rgJobOrSetup: TRadioGroup
              Left = 10
              Top = 20
              Width = 277
              Height = 50
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Compatibility or Setup change'
              Columns = 2
              Items.Strings = (
                'Compatibility'
                'Setup change')
              TabOrder = 0
              OnClick = rgJobOrSetupClick
            end
            object EdtJobToJob: TEdit
              Left = 20
              Top = 94
              Width = 60
              Height = 24
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Color = 14803425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -14
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              MaxLength = 6
              ParentFont = False
              TabOrder = 1
              OnExit = EdtEarlBeforeExit
              OnKeyPress = EdtEarlBeforeKeyPress
            end
            object EdtSetupPen: TEdit
              Left = 156
              Top = 94
              Width = 61
              Height = 24
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Color = 14803425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -14
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              MaxLength = 6
              ParentFont = False
              TabOrder = 2
              OnExit = EdtEarlBeforeExit
              OnKeyPress = EdtEarlBeforeKeyPress
            end
          end
        end
        object GBPenaltyDays: TGroupBox
          Left = 15
          Top = 4
          Width = 886
          Height = 155
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Penalty for each day when not scheduled on time'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object Label8: TLabel
            Left = 20
            Top = 30
            Width = 176
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Before earliest date tolerance'
          end
          object Label11: TLabel
            Left = 250
            Top = 30
            Width = 172
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Within earliest date tolerance'
          end
          object Label12: TLabel
            Left = 20
            Top = 98
            Width = 151
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'After latest date tolerance'
          end
          object Label13: TLabel
            Left = 250
            Top = 98
            Width = 160
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Within latest date tolerance'
          end
          object LblPenaltyNew1: TLabel
            Left = 469
            Top = 30
            Width = 273
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Help selecting position after last job by penaly'
          end
          object LblPenaltyNew2: TLabel
            Left = 469
            Top = 50
            Width = 256
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'gap between lowest possible end date and'
          end
          object LblPenaltyNew3: TLabel
            Left = 469
            Top = 70
            Width = 161
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'position checked end date.'
          end
          object LblCalendarForDatesPenalty: TLabel
            Left = 696
            Top = 98
            Width = 187
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Calendar for dates penalty'
          end
          object LblCalBalnk: TLabel
            Left = 766
            Top = 122
            Width = 79
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '(blank = 24/7)'
          end
          object EdtEarlBefore: TEdit
            Left = 20
            Top = 54
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 6
            ParentFont = False
            TabOrder = 0
            OnExit = EdtEarlBeforeExit
            OnKeyPress = EdtEarlBeforeKeyPress
          end
          object EdtEarlWith: TEdit
            Left = 250
            Top = 49
            Width = 61
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 6
            ParentFont = False
            TabOrder = 1
            OnExit = EdtEarlBeforeExit
            OnKeyPress = EdtEarlBeforeKeyPress
          end
          object EdtAfterLatest: TEdit
            Left = 20
            Top = 118
            Width = 104
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 10
            ParentFont = False
            TabOrder = 2
            OnExit = EdtEarlBeforeExit
            OnKeyPress = CheckKeyPress
          end
          object EdtAfterWith: TEdit
            Left = 250
            Top = 118
            Width = 104
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 6
            ParentFont = False
            TabOrder = 3
            OnExit = EdtEarlBeforeExit
            OnKeyPress = CheckKeyPress
          end
          object EditScheduleToPossibleStartPenalty: TEdit
            Left = 473
            Top = 118
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 6
            ParentFont = False
            TabOrder = 4
            OnExit = EdtEarlBeforeExit
            OnKeyPress = EdtEarlBeforeKeyPress
          end
          object EditCalendarForDatesPenalty: TEdit
            Left = 696
            Top = 118
            Width = 60
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = 14803425
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 3
            ParentFont = False
            TabOrder = 5
          end
        end
        object GBWeight: TGroupBox
          Left = 15
          Top = 327
          Width = 602
          Height = 74
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '"Date" : "Compatibility discrepancy" balance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object Label19: TLabel
            Left = 20
            Top = 16
            Width = 107
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Date score weight'
          end
          object Label20: TLabel
            Left = 286
            Top = 16
            Width = 232
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Compatibility discrepancy score weight'
          end
          object Label21: TLabel
            Left = 89
            Top = 37
            Width = 18
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '%'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -20
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label22: TLabel
            Left = 354
            Top = 37
            Width = 18
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '%'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -20
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object SEdtDateScore: TExSpinEdit
            Left = 20
            Top = 36
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            EditorEnabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 2
            MaxValue = 100
            MinValue = 0
            ParentFont = False
            TabOrder = 0
            Value = 80
            OnChange = SEdtDateScoreChange
          end
          object SEdtCompScore: TExSpinEdit
            Left = 286
            Top = 36
            Width = 60
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            EditorEnabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 2
            MaxValue = 100
            MinValue = 0
            ParentFont = False
            TabOrder = 1
            Value = 20
            OnChange = SEdtCompScoreChange
          end
        end
        object btnRestSchedScore: TcxButton
          Left = 664
          Top = 410
          Width = 113
          Height = 30
          Caption = 'Restore'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 3
          OnClick = btnRestSchedScoreClick
        end
      end
      object TabSheet2: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Score addition'
        ImageIndex = 12
        object DBNavigator2: TDBNavigator
          Left = 345
          Top = 37
          Width = 270
          Height = 31
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          DataSource = DataSource2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object DBGrid2: TDBGrid
          Left = 4
          Top = 177
          Width = 488
          Height = 148
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          DataSource = DataSource2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -14
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = [fsBold]
          Columns = <
            item
              Expanded = False
              FieldName = 'AJ_FROM_CASE'
              Width = 81
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'AJ_TO_CASE'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'AJ_ADD_TO_SCORE'
              Visible = True
            end>
        end
      end
      object tbsOther: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Others'
        ImageIndex = 12
        DesignSize = (
          992
          502)
        object Label23: TLabel
          Left = 246
          Top = 73
          Width = 254
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Waiting time (secs) for each position tested'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SEdtSleepTime: TExSpinEdit
          Left = 246
          Top = 97
          Width = 60
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 3
          MaxValue = 100
          MinValue = 0
          ParentFont = False
          TabOrder = 0
          Value = 0
        end
        object cboxShowGraph: TCheckBox
          Left = 246
          Top = 180
          Width = 316
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show graph on move'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object btnRstOthers: TBitBtn
          Left = 667
          Top = 465
          Width = 142
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Restore'
          Glyph.Data = {
            F2010000424DF201000000000000760000002800000024000000130000000100
            0400000000007C01000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
            3333333333388F3333333333000033334224333333333333338338F333333333
            0000333422224333333333333833338F33333333000033422222243333333333
            83333338F3333333000034222A22224333333338F33F33338F33333300003222
            A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
            38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
            2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
            0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
            333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
            33333A2224A2233333333338F338F83300003333333333A2224A333333333333
            8F338F33000033333333333A222433333333333338F338F30000333333333333
            A224333333333333338F38F300003333333333333A223333333333333338F8F3
            000033333333333333A3333333333333333383330000}
          NumGlyphs = 2
          TabOrder = 2
          OnClick = btnRstOthersClick
        end
      end
      object TSSplitJobs: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Split preferences'
        ImageIndex = 13
        object RGLastSpitCanGoMinMachin: TRadioGroup
          Left = 11
          Top = 392
          Width = 378
          Height = 60
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Last split can go under the smallest machine minimum size'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ItemIndex = 1
          Items.Strings = (
            'Yes'
            'No')
          ParentFont = False
          TabOrder = 0
        end
        object RGAutoSplitByBtach: TRadioGroup
          Left = 11
          Top = 15
          Width = 789
          Height = 211
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Split method for jobs that must split'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ItemIndex = 0
          Items.Strings = (
            'By machines optimum'
            'By equal quantity'
            'Balancing occupation percent'
            
              'Split by machine optimum and join (When no machine size defined,' +
              ' machine optimum = daily production)'
            
              'By machine optimum - Try to split even if a matching machine fou' +
              'nd'
            
              'Split a non grouped continues job and keep the longest duration ' +
              'possible in the best place found ')
          ParentFont = False
          TabOrder = 1
        end
        object RGCreteriaOfRes: TRadioGroup
          Left = 11
          Top = 274
          Width = 791
          Height = 110
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 
            'When trying to schedule a quantity that equals one of the resour' +
            'ces standard batch size, which resources will be tested'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ItemIndex = 0
          Items.Strings = (
            'Any resource'
            
              'Only those with the same standard batch size except from the rem' +
              'aining quantity'
            
              'Only those with the same standard batch size, smallest batch siz' +
              'e will be tested also on any resource')
          ParentFont = False
          TabOrder = 2
        end
      end
      object TbSSortbin: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Sort'
        ImageIndex = 14
        object CBField1: TComboBox
          Left = 27
          Top = 90
          Width = 179
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object CBField2: TComboBox
          Left = 27
          Top = 134
          Width = 179
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object CBField3: TComboBox
          Left = 27
          Top = 177
          Width = 179
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object CBField4: TComboBox
          Left = 27
          Top = 220
          Width = 179
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object CBField5: TComboBox
          Left = 26
          Top = 263
          Width = 178
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object RGroupSortbeforeschedule: TRadioGroup
          Left = 26
          Top = 21
          Width = 278
          Height = 55
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Special jobs sort for automatic sequence ?'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemIndex = 0
          Items.Strings = (
            'No'
            'Yes')
          ParentFont = False
          TabOrder = 5
        end
        object BTnClear1: TcxButton
          Left = 213
          Top = 90
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
          TabOrder = 6
          OnClick = BitBtnClearClick
        end
        object BTnClear2: TcxButton
          Left = 213
          Top = 134
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
          TabOrder = 7
          OnClick = BitBtnClearClick
          object Panel5: TcxButton
            Left = 0
            Top = 24
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
            TabOrder = 0
            OnClick = BitBtnClearClick
          end
        end
        object BTnClear3: TcxButton
          Left = 213
          Top = 177
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
          TabOrder = 8
          OnClick = BitBtnClearClick
        end
        object BTnClear4: TcxButton
          Left = 213
          Top = 220
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
          TabOrder = 9
          OnClick = BitBtnClearClick
        end
        object BTnClear5: TcxButton
          Left = 213
          Top = 263
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
          TabOrder = 10
          OnClick = BitBtnClearClick
        end
      end
      object TbsServingGroup: TTabSheet
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Serving group'
        ImageIndex = 16
        object LblHoursToleranceOfGapBetweenJobs: TLabel
          Left = 20
          Top = 27
          Width = 269
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Hours tolerance of gap between jobs'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
        end
        object LblPenaltyScoreWithinTol: TLabel
          Left = 20
          Top = 65
          Width = 243
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Penalty score within tolerance '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
        end
        object LblPenaltyScoreAfterTol: TLabel
          Left = 20
          Top = 110
          Width = 243
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Penalty score after tolerance '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
        end
        object SpinEdtHoursToleranceOfGapBetweenJobs: TExSpinEdit
          Left = 288
          Top = 22
          Width = 60
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 3
          MaxValue = 999
          MinValue = 0
          ParentFont = False
          TabOrder = 0
          Value = 0
        end
        object EdtPenaltyScoreWithinTol: TEdit
          Left = 288
          Top = 60
          Width = 60
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 6
          ParentFont = False
          TabOrder = 1
          OnExit = EdtEarlBeforeExit
          OnKeyPress = EdtEarlBeforeKeyPress
        end
        object EdtPenaltyScoreAfterTol: TEdit
          Left = 288
          Top = 106
          Width = 60
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 6
          ParentFont = False
          TabOrder = 2
          OnExit = EdtEarlBeforeExit
          OnKeyPress = EdtEarlBeforeKeyPress
        end
        object CBunscheduleEarliesJobWhenAboveTolerance: TCheckBox
          Left = 18
          Top = 149
          Width = 360
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Unschedule earlies job when above tolerance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = CBunscheduleEarliesJobWhenAboveToleranceClick
        end
        object CBForceSameWcPlantToServingGroup: TCheckBox
          Left = 18
          Top = 192
          Width = 372
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'All serving group jobs should have the same plant / line'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Montserrat'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
      end
    end
  end
  object DataSource2: TDataSource
    DataSet = FDTable2
    Left = 903
    Top = 385
  end
  object FDTable2: TFDTable
    AfterInsert = FDTable2AfterInsert
    AfterPost = FDTable2AfterPost
    Left = 852
    Top = 420
  end
  object FDTransaction1: TFDTransaction
    Left = 852
    Top = 388
  end
end
