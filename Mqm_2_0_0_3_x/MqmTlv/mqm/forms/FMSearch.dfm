object Search: TSearch
  Left = 179
  Top = 100
  Width = 621
  Height = 466
  Caption = 'Search'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PgCtrl: TPageControl
    Left = 0
    Top = 0
    Width = 613
    Height = 432
    ActivePage = TabMain
    Align = alClient
    TabOrder = 0
    object TabMain: TTabSheet
      Caption = 'TabMain'
      ImageIndex = 1
      object PanelBtns: TPanel
        Left = 0
        Top = 339
        Width = 605
        Height = 65
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 0
        object BtnOk: TBitBtn
          Left = 19
          Top = 35
          Width = 76
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'OK'
          ModalResult = 1
          TabOrder = 0
          OnClick = BtnOkClick
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
          NumGlyphs = 2
        end
        object BtnCanc: TBitBtn
          Left = 506
          Top = 27
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          TabOrder = 1
          Kind = bkCancel
        end
        object BtnSearch: TcxButton
          Left = 22
          Top = 3
          Width = 73
          Height = 25
          Caption = ' Search >>'
          TabOrder = 2
          OnClick = BtnSearchClick
        end
        object BtnSearchJob: TcxButton
          Left = 238
          Top = 3
          Width = 139
          Height = 25
          Caption = ' Search  with job data >>'
          TabOrder = 3
          OnClick = BtnSearchJobClick
        end
        object BtnNewSearch: TcxButton
          Left = 118
          Top = 3
          Width = 99
          Height = 25
          Caption = 'New search >>'
          TabOrder = 4
          OnClick = BtnNewSearchClick
        end
      end
      object PanelMain: TPanel
        Left = 0
        Top = 55
        Width = 605
        Height = 284
        Align = alBottom
        TabOrder = 1
        object PanelTitleMain: TPanel
          Left = 1
          Top = 1
          Width = 603
          Height = 40
          Align = alTop
          TabOrder = 0
          object LabelMainTitleFields: TLabel
            Left = 54
            Top = 16
            Width = 64
            Height = 13
            Caption = 'Search fields'
          end
          object LabelMainTitleProperty: TLabel
            Left = 327
            Top = 16
            Width = 47
            Height = 13
            Caption = 'Properties'
          end
        end
      end
    end
    object TabSearch: TTabSheet
      Caption = 'TabSearch'
      ImageIndex = 2
      object Panel3: TPanel
        Left = 0
        Top = 336
        Width = 605
        Height = 68
        Align = alBottom
        TabOrder = 0
        object Bitsearch: TBitBtn
          Left = 496
          Top = 24
          Width = 75
          Height = 25
          Caption = 'Search'
          TabOrder = 0
          Kind = bkOK
        end
        object BtnSplitBack: TcxButton
          Left = 27
          Top = 23
          Width = 108
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '<<-- Back'
          Default = True
          TabOrder = 1
          OnClick = BtnSplitBackClick
        end
      end
      object ScrollBox: TScrollBox
        Left = 0
        Top = 41
        Width = 605
        Height = 295
        Align = alClient
        TabOrder = 1
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 605
        Height = 41
        Align = alTop
        TabOrder = 2
        object LblFieldDesc: TLabel
          Left = 32
          Top = 10
          Width = 80
          Height = 20
          Caption = 'Description'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblCond: TLabel
          Left = 179
          Top = 11
          Width = 67
          Height = 20
          Caption = 'Condition'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblFrom: TLabel
          Left = 306
          Top = 11
          Width = 45
          Height = 20
          Caption = 'Value '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblTo: TLabel
          Left = 428
          Top = 11
          Width = 59
          Height = 20
          Caption = 'To value'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
      end
    end
  end
end
