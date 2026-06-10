object FAutoSchedRpt: TFAutoSchedRpt
  Left = 44
  Top = 0
  Caption = 'Automatic sequencing results'
  ClientHeight = 543
  ClientWidth = 764
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 273
    Top = 0
    Height = 506
  end
  object TVReport: TTreeView
    Left = 0
    Top = 0
    Width = 273
    Height = 506
    Align = alLeft
    Indent = 19
    ReadOnly = True
    TabOrder = 0
    ToolTips = False
    OnChange = TVReportChange
  end
  object LVReport: TListView
    Left = 276
    Top = 0
    Width = 488
    Height = 506
    Align = alClient
    Columns = <>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PupMnu
    TabOrder = 1
    ViewStyle = vsReport
    OnCustomDrawItem = LVReportCustomDrawItem
    OnSelectItem = LVReportSelectItem
  end
  object PnlBtm: TPanel
    Left = 0
    Top = 506
    Width = 764
    Height = 37
    Align = alBottom
    BevelInner = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    object BtnOk: TcxButton
      Left = 557
      Top = 6
      Width = 93
      Height = 24
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
      Left = 656
      Top = 6
      Width = 95
      Height = 24
      Caption = 'Abort'
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
  end
  object PupMnu: TPopupMenu
    Left = 304
    Top = 72
    object JobDetail1: TMenuItem
      Caption = 'Job details'
      OnClick = JobDetail1Click
    end
  end
end
