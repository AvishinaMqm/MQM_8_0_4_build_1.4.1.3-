object FJobHandle: TFJobHandle
  Left = 567
  Top = 248
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Job handling'
  ClientHeight = 592
  ClientWidth = 789
  Color = clWhite
  Constraints.MinHeight = 492
  Constraints.MinWidth = 646
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 789
    Height = 159
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelInner = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblWorkCenterDesc: TLabel
      Left = 10
      Top = 81
      Width = 72
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Work center'
    end
    object LblResDesc: TLabel
      Left = 10
      Top = 106
      Width = 59
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resource'
    end
    object LblResSubLine: TLabel
      Left = 398
      Top = 106
      Width = 109
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resource sub-line'
    end
    object LblQuantityIniStepAlt: TLabel
      Left = 11
      Top = 130
      Width = 113
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Step ini. alt quantity'
    end
    object LblQuantityProg: TLabel
      Left = 398
      Top = 130
      Width = 121
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Quantity progressed'
    end
    object LblWCProcessDesc: TLabel
      Left = 398
      Top = 81
      Width = 80
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'W.C. process'
    end
    object LblProdReq: TLabel
      Left = 10
      Top = 8
      Width = 51
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Request'
    end
    object LblStepnum: TLabel
      Left = 398
      Top = 8
      Width = 28
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Step'
    end
    object LblSubStep: TLabel
      Left = 10
      Top = 57
      Width = 53
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Sub step'
    end
    object LblRePro: TLabel
      Left = 398
      Top = 57
      Width = 70
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Re process'
    end
    object LblStpIniQty: TLabel
      Left = 10
      Top = 32
      Width = 96
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Step ini. quantity'
    end
    object LblTotJobs: TLabel
      Left = 398
      Top = 32
      Width = 122
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Total number of jobs'
    end
    object STWorkCenter: TStaticText
      Left = 203
      Top = 81
      Width = 158
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STWorkCenter'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
    end
    object STRes: TStaticText
      Left = 203
      Top = 106
      Width = 158
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STRes'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 1
    end
    object STResSubLine: TStaticText
      Left = 573
      Top = 106
      Width = 179
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STResSubLine'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
    end
    object STQuantityIniAlternative: TStaticText
      Left = 206
      Top = 130
      Width = 158
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STQuantityIniAlternative'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
    end
    object STQuantityProg: TStaticText
      Left = 573
      Top = 130
      Width = 179
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STQuantityProg'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 4
    end
    object STWCProcess: TStaticText
      Left = 573
      Top = 81
      Width = 179
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STWCProcess'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 5
    end
    object StProdReq: TStaticText
      Left = 203
      Top = 7
      Width = 158
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'StProdReq'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 6
    end
    object StStepNum: TStaticText
      Left = 573
      Top = 7
      Width = 179
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'StStepNum'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 7
    end
    object STSubStep: TStaticText
      Left = 203
      Top = 56
      Width = 158
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STSubStep'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 8
    end
    object STRePro: TStaticText
      Left = 573
      Top = 57
      Width = 179
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STRePro'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 9
    end
    object STIniQty: TStaticText
      Left = 203
      Top = 31
      Width = 158
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STIniQty'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 10
    end
    object STTotJobs: TStaticText
      Left = 573
      Top = 31
      Width = 179
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STTotJobs'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 11
    end
  end
  object PgCtrl: TPageControl
    Left = 0
    Top = 159
    Width = 789
    Height = 433
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TbsSplit
    Align = alClient
    MultiLine = True
    TabOrder = 1
    object TbsSchedList: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Job list'
      object PanelBtns: TPanel
        Left = 0
        Top = 322
        Width = 781
        Height = 80
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 0
        DesignSize = (
          781
          80)
        object BtnOk: TcxButton
          Left = 431
          Top = 44
          Width = 91
          Height = 31
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
        object BtnCanc: TcxButton
          Left = 653
          Top = 45
          Width = 118
          Height = 31
          Caption = 'Cancel'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 1
          OnClick = BtnCancClick
        end
        object BtnUndo: TcxButton
          Left = 653
          Top = 9
          Width = 118
          Height = 30
          Caption = 'Undo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 2
          OnClick = BtnUndoClick
        end
        object BtnFixQty: TcxButton
          Left = 431
          Top = 8
          Width = 162
          Height = 30
          Caption = 'Balance quantity'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 3
          OnClick = BtnFixQtyClick
        end
        object BtnReproc: TcxButton
          Left = 258
          Top = 9
          Width = 132
          Height = 30
          Caption = 'Reprocess'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 4
          Visible = False
          OnClick = BtnReprocClick
        end
        object BtnCorrectQty: TcxButton
          Left = 259
          Top = 45
          Width = 151
          Height = 30
          Caption = 'Correct Quantities'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 5
          Visible = False
          OnClick = BtnCorrectQtyClick
        end
        object BtnJoin: TcxButton
          Left = 303
          Top = 9
          Width = 107
          Height = 30
          Caption = 'Join'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 6
          OnClick = BtnJoinClick
        end
        object BtnJoinFamily: TcxButton
          Left = 135
          Top = 45
          Width = 106
          Height = 30
          Caption = 'Join family'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 7
          Visible = False
          OnClick = BtnJoinFamilyClick
        end
        object BtnSplit: TcxButton
          Left = 7
          Top = 8
          Width = 106
          Height = 31
          Caption = 'Split'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 8
          OnClick = BtnSplitClick
        end
        object BtnDetails: TcxButton
          Left = 7
          Top = 43
          Width = 106
          Height = 31
          Caption = 'Details'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 9
          OnClick = BtnDetailsClick
        end
        object BitBtn1: TBitBtn
          Left = 529
          Top = 45
          Width = 64
          Height = 31
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Kind = bkOK
          NumGlyphs = 2
          TabOrder = 10
          Visible = False
        end
        object BtnSplitUM: TcxButton
          Left = 135
          Top = 8
          Width = 106
          Height = 31
          Caption = 'Split'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 11
          OnClick = BtnSplitClick
        end
      end
      object BtnConnectPrev: TcxButton
        Left = 458
        Top = 175
        Width = 103
        Height = 30
        Caption = 'Connect prev.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 1
        OnClick = BtnConnectPrevClick
      end
      object BtnConnectNext: TcxButton
        Left = 458
        Top = 211
        Width = 103
        Height = 30
        Caption = 'Connect next'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 2
        OnClick = BtnConnectNextClick
      end
    end
    object TbsSplit: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Split'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 356
        Width = 781
        Height = 46
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 0
        object BtnCalcSplit: TcxButton
          Left = 10
          Top = 7
          Width = 103
          Height = 31
          Caption = 'Calculate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 0
          OnClick = BtnCalcSplitClick
        end
        object BtnSplitBack: TcxButton
          Left = 135
          Top = 7
          Width = 103
          Height = 31
          Caption = '<<-- Back'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 1
          OnClick = BtnSplitBackClick
        end
        object BtnSplitfamily: TcxButton
          Left = 420
          Top = 7
          Width = 103
          Height = 31
          Caption = 'Split Family'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 2
          Visible = False
          OnClick = BtnSplitfamilyClick
        end
        object BtnSplitBalance: TcxButton
          Left = 526
          Top = 7
          Width = 141
          Height = 31
          Caption = 'Split and Balance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 3
          OnClick = BtnSplitBalanceClick
        end
        object BtnConfirmSplit: TcxButton
          Left = 673
          Top = 7
          Width = 103
          Height = 31
          Caption = 'Split'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 4
          OnClick = BtnConfirmSplitClick
        end
      end
      object PnlSplit: TPanel
        Left = 0
        Top = 41
        Width = 781
        Height = 315
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelInner = bvLowered
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        DesignSize = (
          781
          315)
        object LblSplitNo: TLabel
          Left = 12
          Top = 153
          Width = 91
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Number of jobs'
        end
        object LblSplitErr: TLabel
          Left = 11
          Top = 259
          Width = 36
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Errors'
          ExplicitTop = 256
        end
        object LblQtyPerJob: TLabel
          Left = 12
          Top = 182
          Width = 93
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Quantity per job'
        end
        object LblCurrJobQty: TLabel
          Left = 303
          Top = 73
          Width = 113
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Current job quantity'
        end
        object LblNrOfNewJob: TLabel
          Left = 303
          Top = 103
          Width = 118
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Number of new jobs'
        end
        object LblQtyEachJob: TLabel
          Left = 303
          Top = 133
          Width = 144
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Quantity of each new job'
        end
        object StSplitErr: TStaticText
          Left = 11
          Top = 281
          Width = 604
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          AutoSize = False
          Caption = 'Errors'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
        object StCurrJobQty: TStaticText
          Left = 491
          Top = 73
          Width = 150
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'StCurrJobQty'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
        end
        object EdtQtyPerJob: TEdit
          Left = 135
          Top = 177
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 2
          OnChange = CheckDecimal
          OnKeyPress = EdtQtyToSplitKeyPress
        end
        object StNrOfNewJob: TStaticText
          Left = 491
          Top = 102
          Width = 150
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'StNrOfNewJob'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
        end
        object StQtyEachJob: TStaticText
          Left = 491
          Top = 132
          Width = 150
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'StQtyEachJob'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 4
        end
        object RgSplitType: TRadioGroup
          Left = 13
          Top = 8
          Width = 602
          Height = 50
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Split type'
          Color = clWhite
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'By number of jobs'
            'By quantity'
            'By both')
          ParentBackground = False
          ParentColor = False
          TabOrder = 5
          OnClick = RgSplitTypeClick
        end
        object RGQtyType: TRadioGroup
          Left = 10
          Top = 69
          Width = 119
          Height = 70
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Quantity to'
          Color = clWhite
          ItemIndex = 0
          Items.Strings = (
            'Split'
            'Keep')
          ParentBackground = False
          ParentColor = False
          TabOrder = 6
        end
        object EdtQtyToSplit: TEdit
          Left = 137
          Top = 96
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 7
          OnChange = CheckDecimal
          OnKeyPress = EdtQtyToSplitKeyPress
        end
        object SEdtNumOfJobs: TExSpinEdit
          Left = 135
          Top = 145
          Width = 53
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ArrowColor = 15972184
          Color = 14803425
          MaxLength = 3
          MaxValue = 999
          MinValue = 0
          TabOrder = 8
          Value = 0
        end
        object STUmCode: TStaticText
          Left = 653
          Top = 73
          Width = 104
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'STUmCode'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 9
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 781
        Height = 41
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Split'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
    object TbsReproc: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Reprocess'
      ImageIndex = 2
      object Panel3: TcxButton
        Left = 0
        Top = 0
        Width = 781
        Height = 41
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Reprocess'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object Panel4: TPanel
        Left = 0
        Top = 356
        Width = 781
        Height = 46
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 1
        object BtnReprocBack: TcxButton
          Left = 353
          Top = 7
          Width = 103
          Height = 31
          Caption = '<<-- Back'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 0
          OnClick = BtnReprocBackClick
        end
        object BtnConfirmReproc: TcxButton
          Left = 476
          Top = 7
          Width = 139
          Height = 31
          Caption = 'Reprocess'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 1
          OnClick = BtnConfirmReprocClick
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 41
        Width = 781
        Height = 315
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelInner = bvLowered
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
        DesignSize = (
          781
          315)
        object LblQtytoReproc: TLabel
          Left = 10
          Top = 33
          Width = 126
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Quantity to reprocess'
        end
        object LblReprocErr: TLabel
          Left = 11
          Top = 274
          Width = 36
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          Caption = 'Errors'
          ExplicitTop = 271
        end
        object EdtQtyReproc: TEdit
          Left = 143
          Top = 27
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 0
        end
        object STReprocErr: TStaticText
          Left = 11
          Top = 290
          Width = 604
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akLeft, akBottom]
          AutoSize = False
          Caption = 'Errors'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
        end
      end
    end
    object TbsConnect: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Step connection'
      ImageIndex = 3
      object Splitter1: TSplitter
        Left = 0
        Top = 170
        Width = 781
        Height = 2
        Cursor = crVSplit
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        ExplicitWidth = 779
      end
      object PnlConnHead: TcxButton
        Left = 0
        Top = 0
        Width = 781
        Height = 33
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Step connection'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object Panel7: TPanel
        Left = 0
        Top = 356
        Width = 781
        Height = 46
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 1
        object BtnConnBack: TcxButton
          Left = 273
          Top = 7
          Width = 103
          Height = 31
          Caption = '<<-- Back'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 0
          OnClick = BtnConnBackClick
        end
        object BtnConnect: TcxButton
          Left = 396
          Top = 7
          Width = 139
          Height = 31
          Caption = 'Confirm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 1
          OnClick = BtnConnectClick
        end
      end
      object GBConn: TGroupBox
        Left = 0
        Top = 172
        Width = 781
        Height = 184
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Caption = 'Connected'
        TabOrder = 2
      end
      object GBToConn: TGroupBox
        Left = 0
        Top = 33
        Width = 781
        Height = 137
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Not connected'
        TabOrder = 3
      end
    end
    object TbSBalanceQty: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Balance quantity'
      ImageIndex = 5
      object Panel10: TPanel
        Left = 0
        Top = 0
        Width = 781
        Height = 361
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Caption = 'Panel10'
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object LblReproc: TLabel
          Left = 118
          Top = 49
          Width = 70
          Height = 32
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Reprocess number'
          WordWrap = True
        end
        object LblSubstp: TLabel
          Left = 30
          Top = 49
          Width = 80
          Height = 32
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Sub step number'
          WordWrap = True
        end
        object LblQty: TLabel
          Left = 207
          Top = 49
          Width = 61
          Height = 32
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Initial quantity'
          WordWrap = True
        end
        object LblAllInAll: TLabel
          Left = 89
          Top = 269
          Width = 79
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Jobs quantity'
        end
        object LblManchgQty: TLabel
          Left = 276
          Top = 49
          Width = 50
          Height = 32
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Change qty. by'
          WordWrap = True
        end
        object LblStepQty: TLabel
          Left = 89
          Top = 299
          Width = 77
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Step quantity'
        end
        object LlbProgrQty: TLabel
          Left = 438
          Top = 49
          Width = 74
          Height = 32
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Progressed quantity'
          WordWrap = True
        end
        object Label2: TLabel
          Left = 354
          Top = 49
          Width = 57
          Height = 32
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Alignment = taCenter
          AutoSize = False
          Caption = 'Manually chg.qty.'
          WordWrap = True
        end
        object LblFinalQty: TLabel
          Left = 534
          Top = 49
          Width = 59
          Height = 32
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'Current quantity'
          WordWrap = True
        end
        object SBFrames: TScrollBox
          Left = 22
          Top = 89
          Width = 584
          Height = 152
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          HorzScrollBar.Visible = False
          Color = clWhite
          ParentColor = False
          TabOrder = 0
        end
        object STInitQty2: TStaticText
          Left = 205
          Top = 269
          Width = 88
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          TabOrder = 1
        end
        object STStepQty: TStaticText
          Left = 205
          Top = 299
          Width = 88
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          TabOrder = 2
        end
        object Panel12: TPanel
          Left = 1
          Top = 1
          Width = 779
          Height = 41
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Balance change'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
      end
      object Panel11: TPanel
        Left = 0
        Top = 361
        Width = 781
        Height = 41
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        BevelInner = bvLowered
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object BtnBalanceQtyBack: TcxButton
          Left = 257
          Top = 7
          Width = 103
          Height = 31
          Caption = '<<-- Back'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 0
          OnClick = BtnBalanceQtyBackClick
        end
        object BtnBalanceQty: TcxButton
          Left = 380
          Top = 7
          Width = 139
          Height = 31
          Caption = 'Confirm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentFont = False
          TabOrder = 1
          OnClick = BtnBalanceQtyClick
        end
      end
    end
  end
  object PUpToConn: TPopupMenu
    Left = 276
    Top = 324
    object MIConnect: TMenuItem
      Caption = 'Connect'
      OnClick = MIConnectClick
    end
  end
  object PUpConn: TPopupMenu
    Left = 316
    Top = 325
    object MIDisconnect: TMenuItem
      Caption = 'Disconnect'
      OnClick = MIDisconnectClick
    end
  end
end
