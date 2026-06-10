object FCreateWarp: TFCreateWarp
  Left = 0
  Top = 0
  Caption = 'FCreateWarp'
  ClientHeight = 275
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object PageControlWarp: TPageControl
    Left = 0
    Top = 39
    Width = 508
    Height = 199
    ActivePage = tbsParams
    Align = alClient
    OwnerDraw = True
    TabOrder = 0
    object tbsParams: TTabSheet
      Caption = 'Parameters'
      object GBLinkedRequest: TGroupBox
        Left = 261
        Top = 129
        Width = 261
        Height = 42
        Align = alLeft
        Caption = 'Linked requests'
        TabOrder = 0
        object CBLinkRequest: TComboBox
          Left = 11
          Top = 18
          Width = 220
          Height = 21
          Style = csDropDownList
          TabOrder = 0
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 65
        Width = 500
        Height = 64
        Align = alTop
        TabOrder = 1
        object LblResource: TLabel
          Left = 9
          Top = 9
          Width = 45
          Height = 13
          Caption = 'Resource'
        end
        object LblUpToCase: TLabel
          Left = 17
          Top = 81
          Width = 107
          Height = 13
          Caption = 'Compatibility case limit'
        end
        object LBQty: TLabel
          Left = 176
          Top = 9
          Width = 42
          Height = 13
          Caption = 'Quantity'
        end
        object SpEdtUpToCase: TExSpinEdit
          Left = 17
          Top = 99
          Width = 41
          Height = 22
          ArrowColor = 15972184
          Color = 14803425
          MaxValue = 98
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
        object StaticResCode: TStaticText
          Left = 9
          Top = 31
          Width = 134
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'STResCode'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
        end
        object STqty: TStaticText
          Left = 177
          Top = 31
          Width = 134
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = False
          Caption = 'STQty'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 500
        Height = 65
        Align = alTop
        TabOrder = 2
        object GBDuration: TGroupBox
          Left = 335
          Top = 1
          Width = 164
          Height = 63
          Align = alRight
          Caption = 'Duration'
          TabOrder = 0
          object STExecTime: TStaticText
            Left = 11
            Top = 27
            Width = 188
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'STExecTime'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
          end
        end
        object GBEndDate: TGroupBox
          Left = 175
          Top = 1
          Width = 160
          Height = 63
          Align = alClient
          Caption = 'End date'
          TabOrder = 1
          object STSchedEnd: TStaticText
            Left = 10
            Top = 27
            Width = 170
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'STSchedEnd'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
          end
        end
        object GBStDate: TGroupBox
          Left = 1
          Top = 1
          Width = 174
          Height = 63
          Align = alLeft
          Caption = 'Start date'
          TabOrder = 2
          object STSchedStart: TStaticText
            Left = 8
            Top = 27
            Width = 174
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'STSchedStart'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
          end
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 129
        Width = 261
        Height = 42
        Align = alLeft
        Caption = 'Comment'
        TabOrder = 3
        object EdtComment: TEdit
          Left = 7
          Top = 18
          Width = 246
          Height = 21
          Color = 14803425
          MaxLength = 30
          TabOrder = 0
        end
      end
    end
    object TabProp: TTabSheet
      Caption = 'Properties'
      ImageIndex = 1
    end
    object TbsErrors: TTabSheet
      Caption = 'Errors'
      ImageIndex = 2
      object MemErrors: TMemo
        Left = 0
        Top = 0
        Width = 500
        Height = 171
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Color = 14803425
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 238
    Width = 508
    Height = 37
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      508
      37)
    object BtnOk: TcxButton
      Left = 300
      Top = 6
      Width = 93
      Height = 25
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
      Left = 399
      Top = 6
      Width = 84
      Height = 25
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
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 508
    Height = 39
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelInner = bvLowered
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Montserrat'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    OnClick = Panel3Click
    object lblID: TLabel
      Left = 534
      Top = 13
      Width = 25
      Height = 14
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'lblID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object LblIDWarp: TLabel
      Left = 457
      Top = 15
      Width = 57
      Height = 14
      Caption = 'LblIDWarp'
      Visible = False
    end
    object StWarpProduct: TStaticText
      Left = 13
      Top = 11
      Width = 429
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSingle
      Color = clActiveBorder
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -11
      Font.Name = 'Montserrat'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
  end
end
