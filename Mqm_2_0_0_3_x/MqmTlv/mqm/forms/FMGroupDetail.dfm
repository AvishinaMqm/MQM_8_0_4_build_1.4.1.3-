object TGroupDetail: TTGroupDetail
  Left = 230
  Top = 186
  BorderIcons = []
  Caption = 'Group detail'
  ClientHeight = 637
  ClientWidth = 864
  Color = clWhite
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
  PixelsPerInch = 96
  TextHeight = 16
  object PanInfo: TPanel
    Left = 0
    Top = 0
    Width = 864
    Height = 44
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblGrpNo: TLabel
      Left = 20
      Top = 14
      Width = 85
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Group number'
    end
    object LblGrpQty: TLabel
      Left = 275
      Top = 14
      Width = 48
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Quantity'
    end
    object LblQuantityAlt: TLabel
      Left = 494
      Top = 14
      Width = 68
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Quantity alt.'
    end
    object StGrpNo: TStaticText
      Left = 119
      Top = 14
      Width = 110
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = 14803425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
    object StGrpQty: TStaticText
      Left = 337
      Top = 12
      Width = 110
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = 14803425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
    object STQuantityAlt: TStaticText
      Left = 585
      Top = 12
      Width = 110
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = 14803425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 2
    end
  end
  object PanBtn: TPanel
    Left = 0
    Top = 581
    Width = 864
    Height = 56
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      864
      56)
    object BtnOk: TcxButton
      Left = 650
      Top = 13
      Width = 91
      Height = 30
      ParentCustomHint = False
      Anchors = [akRight, akBottom]
      BiDiMode = bdLeftToRight
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnAbo: TcxButton
      Left = 747
      Top = 13
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
      OnClick = BtnAboClick
    end
    object BtnMove: TcxButton
      Left = 338
      Top = 13
      Width = 130
      Height = 30
      ParentCustomHint = False
      BiDiMode = bdLeftToRight
      Caption = 'Move on plan'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnClick = BtnMoveClick
    end
    object BtnShowRequiremants: TcxButton
      Left = 164
      Top = 13
      Width = 161
      Height = 30
      ParentCustomHint = False
      BiDiMode = bdLeftToRight
      Caption = 'Show requirements'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 3
      OnClick = BtnShowRequiremantsClick
    end
    object BtnShowComp: TcxButton
      Left = 4
      Top = 13
      Width = 149
      Height = 30
      ParentCustomHint = False
      BiDiMode = bdLeftToRight
      Caption = 'Show compatible'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 4
      OnClick = BtnShowCompClick
    end
    object ButtonAppendix: TcxButton
      Left = 478
      Top = 13
      Width = 155
      Height = 30
      ParentCustomHint = False
      BiDiMode = bdLeftToRight
      Caption = 'Formula result'
      DropDownMenu = PopupMenuAppendix
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 5
    end
  end
  object PgcGrp: TPageControl
    Left = 0
    Top = 298
    Width = 864
    Height = 283
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TBsValues
    Align = alClient
    TabOrder = 2
    object TBSched: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Jobs'
      object PanOp: TPanel
        Left = 667
        Top = 0
        Width = 189
        Height = 252
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alRight
        BevelOuter = bvLowered
        TabOrder = 0
        object BtnRemove: TcxButton
          Left = 27
          Top = 15
          Width = 144
          Height = 30
          ParentCustomHint = False
          BiDiMode = bdLeftToRight
          Caption = 'Remove'
              Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentBiDiMode = False
              ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = BtnRemoveClick
        end
        object BtnSelected: TcxButton
          Left = 27
          Top = 56
          Width = 144
          Height = 30
          ParentCustomHint = False
          BiDiMode = bdLeftToRight
          Caption = 'Details selected'
              Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentBiDiMode = False
              ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = BtnSelectedClick
        end
        object BtnChgQtyJobs: TcxButton
          Left = 27
          Top = 98
          Width = 144
          Height = 30
          ParentCustomHint = False
          BiDiMode = bdLeftToRight
          Caption = 'Change quantity'
              Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentBiDiMode = False
              ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 2
          OnClick = BtnChgQtyJobsClick
        end
        object BtnJobMsg: TcxButton
          Left = 27
          Top = 138
          Width = 144
          Height = 30
          ParentCustomHint = False
          BiDiMode = bdLeftToRight
          Caption = 'Job messages'
              Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentBiDiMode = False
              ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 3
          OnClick = BtnJobMsgClick
        end
        object BtnSplitGroup: TcxButton
          Left = 27
          Top = 177
          Width = 144
          Height = 30
          ParentCustomHint = False
          BiDiMode = bdLeftToRight
          Caption = 'Split'
              Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentBiDiMode = False
              ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 4
          OnClick = BtnSplitGroupClick
        end
        object BtnSplitGroupByAlternativeUM: TcxButton
          Left = 27
          Top = 213
          Width = 144
          Height = 30
          ParentCustomHint = False
          BiDiMode = bdLeftToRight
          Caption = 'Split'
              Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Font.Quality = fqClearType
          ParentBiDiMode = False
              ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 5
          OnClick = BtnSplitGroupClick
        end
      end
    end
    object TBProp: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Properties'
      ImageIndex = 1
    end
    object TBsValues: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Values'
      ImageIndex = 2
      object GPBtgtRes: TGroupBox
        Left = 0
        Top = 0
        Width = 856
        Height = 149
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Target resource'
        TabOrder = 0
        object Label5: TLabel
          Left = 10
          Top = 21
          Width = 72
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Work center'
        end
        object Label6: TLabel
          Left = 138
          Top = 15
          Width = 59
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Resource'
        end
        object LblSubRes: TLabel
          Left = 394
          Top = 15
          Width = 80
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Sub resource'
        end
        object StTgtWkc: TStaticText
          Left = 10
          Top = 39
          Width = 109
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          BorderStyle = sbsSunken
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
        object StTgtRes: TStaticText
          Left = 138
          Top = 39
          Width = 168
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          BorderStyle = sbsSunken
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
        object StTgtSubRes: TStaticText
          Left = 394
          Top = 39
          Width = 139
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          BorderStyle = sbsSunken
          Color = 14803425
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 2
        end
        object PanBch: TPanel
          Left = 2
          Top = 70
          Width = 852
          Height = 77
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alBottom
          TabOrder = 3
          object GroupBox2: TGroupBox
            Left = 230
            Top = 1
            Width = 360
            Height = 75
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Caption = 'Standard batch'
            TabOrder = 0
            object LblStdAvail: TLabel
              Left = 139
              Top = 23
              Width = 56
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'available'
            end
            object StBchStdLev: TStaticText
              Left = 16
              Top = 44
              Width = 105
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Color = 14803425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clInfoText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 0
            end
            object StBchStdToLev: TStaticText
              Left = 144
              Top = 44
              Width = 105
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Color = 14803425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clInfoText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 1
            end
          end
          object GroupBox3: TGroupBox
            Left = 1
            Top = 1
            Width = 229
            Height = 75
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alLeft
            Caption = 'Minimum batch'
            TabOrder = 1
            object StBchMinLev: TStaticText
              Left = 4
              Top = 44
              Width = 104
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Color = 14803425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clInfoText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 0
            end
            object StBchMinToLev: TStaticText
              Left = 116
              Top = 44
              Width = 105
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Color = 14803425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clInfoText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 1
            end
          end
          object GroupBox4: TGroupBox
            Left = 590
            Top = 1
            Width = 261
            Height = 75
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alRight
            Caption = 'Maximum batch '
            TabOrder = 2
            object LblMaxAvail: TLabel
              Left = 142
              Top = 23
              Width = 56
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'available'
            end
            object StBchMaxLev: TStaticText
              Left = 16
              Top = 44
              Width = 105
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Color = 14803425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clInfoText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 0
            end
            object StBchMaxToLev: TStaticText
              Left = 139
              Top = 44
              Width = 105
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Color = 14803425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clInfoText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              TabOrder = 1
            end
          end
        end
      end
    end
  end
  object PnlSplit: TPanel
    Left = 0
    Top = 44
    Width = 864
    Height = 254
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelInner = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    DesignSize = (
      864
      254)
    object LblSplitNo: TLabel
      Left = 12
      Top = 153
      Width = 107
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Number of groups'
    end
    object LblQtyPerJob: TLabel
      Left = 12
      Top = 180
      Width = 109
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Quantity per group'
    end
    object LblCurrGroupQty: TLabel
      Left = 303
      Top = 73
      Width = 129
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Current group quantity'
    end
    object LblNrOfNewGroup: TLabel
      Left = 303
      Top = 103
      Width = 127
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Number of new group'
    end
    object LblQtyEachGroup: TLabel
      Left = 303
      Top = 133
      Width = 160
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Quantity of each new group'
    end
    object LblSplitErr: TLabel
      Left = 12
      Top = 215
      Width = 36
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Errors'
    end
    object StCurrGrpQty: TStaticText
      Left = 518
      Top = 74
      Width = 150
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'StCurrGrpQty'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
    end
    object EdtQtyPerJob: TEdit
      Left = 147
      Top = 180
      Width = 149
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 1
    end
    object StNrOfNewGrp: TStaticText
      Left = 516
      Top = 103
      Width = 150
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'StNrOfNewGrp'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
    end
    object StQtyEachGrp: TStaticText
      Left = 516
      Top = 133
      Width = 150
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'StQtyEachGrp'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
    end
    object RgSplitType: TRadioGroup
      Left = 12
      Top = 7
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
      TabOrder = 4
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
      TabOrder = 5
    end
    object EdtQtyToSplit: TEdit
      Left = 135
      Top = 96
      Width = 149
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 6
    end
    object SEdtNumOfGroups: TExSpinEdit
      Left = 147
      Top = 148
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
      TabOrder = 7
      Value = 0
    end
    object EdtSplitError: TEdit
      Left = 55
      Top = 212
      Width = 482
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 8
    end
    object BtnCalcSplit: TcxButton
      Left = 311
      Top = 177
      Width = 128
      Height = 28
      ParentCustomHint = False
      BiDiMode = bdLeftToRight
      Caption = 'Calculate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 9
      OnClick = BtnCalcSplitClick
    end
    object BtnSplit: TcxButton
      Left = 445
      Top = 177
      Width = 128
      Height = 28
      ParentCustomHint = False
      BiDiMode = bdLeftToRight
      Caption = 'Split'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 10
      OnClick = BtnSplitClick
    end
    object STStCurrUmHandled: TStaticText
      Left = 676
      Top = 74
      Width = 65
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'StCurrUmHandled'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 11
    end
  end
  object PopupMenuAppendix: TPopupMenu
    Left = 484
    Top = 412
  end
end
