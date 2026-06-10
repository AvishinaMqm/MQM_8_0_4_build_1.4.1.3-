object FViewHtml: TFViewHtml
  Left = 635
  Top = 189
  Caption = 'HTML Dynamic Schedule Report Rreview'
  ClientHeight = 646
  ClientWidth = 1184
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -9
  Font.Name = 'Montserrat'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 11
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1184
    Height = 99
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = 1
    ExplicitTop = 3
    ExplicitWidth = 853
    object BtnPrintPreview: TcxButton
      Left = 14
      Top = 16
      Width = 93
      Height = 25
      Caption = 'Print preview'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BtnPrintPreviewClick
    end
    object BtnPrint: TcxButton
      Left = 16
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Print page'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = BtnPrintClick
    end
    object BtnPageSetup: TcxButton
      Left = 113
      Top = 17
      Width = 79
      Height = 25
      Caption = 'Page setup'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = BtnPageSetupClick
    end
    object BtnPrintAll: TcxButton
      Left = 207
      Top = 17
      Width = 108
      Height = 25
      Caption = 'Print all pages'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = BtnPrintAllClick
    end
    object BtnSave: TcxButton
      Left = 145
      Top = 50
      Width = 170
      Height = 25
      Caption = 'Export as one page'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = BtnSaveClick
    end
    object GroupBox1: TGroupBox
      Left = 321
      Top = 3
      Width = 784
      Height = 91
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      object Label1: TLabel
        Left = 26
        Top = 5
        Width = 109
        Height = 14
        Caption = 'Rows per split page'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
      end
      object LblCurrentPage: TLabel
        Left = 430
        Top = 69
        Width = 81
        Height = 14
        Caption = 'Current page'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
      end
      object LabGroupFields: TLabel
        Left = 8
        Top = 51
        Width = 162
        Height = 14
        Caption = 'Sort fields to cause a break'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
      end
      object LabJumpFields: TLabel
        Left = 192
        Top = 10
        Width = 164
        Height = 14
        Caption = 'Sort fields to change a page'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
      end
      object BtnPrevPage: TcxButton
        Left = 431
        Top = 7
        Width = 104
        Height = 25
        Caption = 'Previous page'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BtnPrevPageClick
      end
      object BtnNextPage: TcxButton
        Left = 541
        Top = 7
        Width = 101
        Height = 25
        Caption = 'Next page'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = BtnNextPageClick
      end
      object BtnFirstPage: TcxButton
        Left = 431
        Top = 38
        Width = 104
        Height = 25
        Caption = 'First page'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = BtnFirstPageClick
      end
      object EditRowsPerPage: TEdit
        Left = 48
        Top = 23
        Width = 59
        Height = 22
        TabOrder = 3
        OnChange = EditRowsPerPageExit
      end
      object STCurrentPage: TStaticText
        Left = 521
        Top = 67
        Width = 65
        Height = 17
        Alignment = taCenter
        AutoSize = False
        Color = clInfoBk
        ParentColor = False
        TabOrder = 4
      end
      object CBDowntime: TCheckBox
        Left = 195
        Top = 53
        Width = 200
        Height = 17
        Caption = 'Include Downtime in statistics'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = CBDowntimeClick
      end
      object CBNewPagePerRes: TCheckBox
        Left = 195
        Top = 34
        Width = 186
        Height = 17
        Caption = 'New page for new resource'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnClick = CBNewPagePerResClick
      end
      object BtnLastPage: TcxButton
        Left = 541
        Top = 38
        Width = 101
        Height = 25
        Caption = 'Last page'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnClick = BtnLastPageClick
      end
      object CBUnschedJobs: TCheckBox
        Left = 195
        Top = 72
        Width = 177
        Height = 17
        Caption = 'Include Unscheduled Jobs'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        Visible = False
        OnClick = CBUnschedJobsClick
      end
      object ComBoxSortCrits: TComboBox
        Left = 49
        Top = 68
        Width = 50
        Height = 22
        TabOrder = 9
        OnChange = ComBoxSortCritsChange
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4')
      end
      object ComBoxJumps: TComboBox
        Left = 364
        Top = 9
        Width = 50
        Height = 22
        TabOrder = 10
        OnChange = ComBoxJumpsChange
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4')
      end
    end
  end
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 201
    Width = 1184
    Height = 445
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 999
    ControlData = {
      4C0000005F7A0000FE2D00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 99
    Width = 1184
    Height = 102
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    ExplicitWidth = 792
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 1182
      Height = 100
      Align = alClient
      Caption = 'Font Settings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 2
      object LabComment: TLabel
        Left = 73
        Top = 71
        Width = 56
        Height = 14
        Caption = 'Comment'
      end
      object LabRedField: TLabel
        Left = 683
        Top = 8
        Width = 3
        Height = 14
        Color = clRed
        ParentColor = False
        Visible = False
      end
      object CBBinCaption: TCheckBox
        Left = 1
        Top = 20
        Width = 104
        Height = 17
        Caption = 'Bin caption'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = CBBinCaptionClick
      end
      object CBSelection: TCheckBox
        Left = 145
        Top = 29
        Width = 133
        Height = 17
        Caption = 'Selection criteria'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = CBSelectionClick
      end
      object EditComment: TEdit
        Left = 145
        Top = 70
        Width = 203
        Height = 20
        TabOrder = 2
        OnChange = EditCommentChange
        OnExit = EditCommentExit
      end
      object BtnRefresh: TcxButton
        Left = 931
        Top = 17
        Width = 84
        Height = 25
        Caption = 'Refresh'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = BtnRefreshClick
      end
      object BtnFontBin: TcxButton
        Left = 15
        Top = 40
        Width = 66
        Height = 25
        Caption = 'Font'
        TabOrder = 4
        OnClick = BtnFontBinClick
      end
      object BtnFontCriteria: TcxButton
        Left = 462
        Top = 17
        Width = 59
        Height = 25
        Caption = 'Font'
        TabOrder = 5
        Visible = False
        OnClick = BtnFontCriteriaClick
      end
      object BtnFontComment: TcxButton
        Left = 371
        Top = 67
        Width = 59
        Height = 25
        Caption = 'Font'
        TabOrder = 6
        OnClick = BtnFontCommentClick
      end
      object BtnFontColumns: TcxButton
        Left = 544
        Top = 17
        Width = 128
        Height = 25
        Caption = 'Font Column Titles'
        TabOrder = 7
        OnClick = BtnFontColumnsClick
      end
      object BtnFontData: TcxButton
        Left = 544
        Top = 48
        Width = 128
        Height = 25
        Caption = 'Font Data Lines'
        TabOrder = 8
        OnClick = BtnFontDataClick
      end
      object BtnBgColors: TcxButton
        Left = 692
        Top = 17
        Width = 164
        Height = 25
        Caption = 'Background Colors'
        TabOrder = 9
        OnClick = BtnBgColorsClick
      end
      object BtnClose: TcxButton
        Left = 931
        Top = 48
        Width = 84
        Height = 25
        Caption = 'Close'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 10
        OnClick = BtnCloseClick
      end
      object BtnPrColors: TcxButton
        Left = 683
        Top = 46
        Width = 207
        Height = 27
        Caption = 'Set Printer-friendly Colors'
        TabOrder = 11
        OnClick = BtnPrColorsClick
      end
      object CBResources: TCheckBox
        Left = 145
        Top = 13
        Width = 148
        Height = 17
        Caption = 'Resource in heading'
        Checked = True
        State = cbChecked
        TabOrder = 12
        OnClick = CBResourcesClick
      end
      object CBShowCrits: TCheckBox
        Left = 145
        Top = 45
        Width = 150
        Height = 17
        Caption = 'Show sort field data'
        Checked = True
        State = cbChecked
        TabOrder = 13
        OnClick = CBShowCritsClick
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 656
    Top = 74
  end
end
