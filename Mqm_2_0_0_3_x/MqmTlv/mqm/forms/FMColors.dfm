object FColors: TFColors
  Left = -1
  Top = 119
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Colors'
  ClientHeight = 453
  ClientWidth = 947
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
  TextHeight = 16
  object PGCmain: TPageControl
    Left = 0
    Top = 0
    Width = 947
    Height = 402
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TbsBinIcons
    Align = alClient
    TabOrder = 1
    object TBJobtCmpt: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Compatibility'
      ImageIndex = 1
      object LblJobToJob: TLabel
        Left = 102
        Top = 4
        Width = 59
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Job to job'
      end
      object LblJobToRes: TLabel
        Left = 678
        Top = 4
        Width = 175
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Job/Capacity res. to resource'
      end
      object LblJobToCap: TLabel
        Left = 364
        Top = 4
        Width = 161
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Job to capacity reservation'
      end
      object PanelJobToJob: TPanel
        Left = 0
        Top = 23
        Width = 306
        Height = 343
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        BevelWidth = 2
        TabOrder = 0
      end
      object PanelJobToCap: TPanel
        Left = 315
        Top = 23
        Width = 307
        Height = 343
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        BevelWidth = 2
        TabOrder = 1
      end
      object PanelJobCapToRes: TPanel
        Left = 630
        Top = 23
        Width = 307
        Height = 343
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        BevelWidth = 2
        TabOrder = 2
      end
    end
    object TbsJobStatus: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Job status'
      ImageIndex = 2
      object PnlJobStatus: TPanel
        Left = 0
        Top = 0
        Width = 941
        Height = 379
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 0
      end
    end
    object TbsDateWarnings: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Job schedule'
      ImageIndex = 5
      object PnlDateWarnings: TPanel
        Left = 0
        Top = 0
        Width = 941
        Height = 379
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 0
      end
    end
    object TbsMaterialsWarnings: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Job requirements'
      ImageIndex = 6
      object PnlMaterialsWarning: TPanel
        Left = 0
        Top = 0
        Width = 941
        Height = 379
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 0
      end
    end
    object TabResColor: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resource'
      ImageIndex = 3
      object PanelResColr: TPanel
        Left = 0
        Top = 0
        Width = 941
        Height = 379
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 0
      end
    end
    object TabCapResColor: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Capacity reservation'
      ImageIndex = 3
      object PnlCapRes: TPanel
        Left = 0
        Top = 0
        Width = 941
        Height = 379
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 0
      end
    end
    object TbsBinIcons: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Status and indications'
      ImageIndex = 4
      object GBStatus: TGroupBox
        Left = 630
        Top = 105
        Width = 297
        Height = 252
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 0
      end
      object GBWarnings: TGroupBox
        Left = 348
        Top = 105
        Width = 274
        Height = 252
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 1
      end
      object GBOverlaps: TGroupBox
        Left = 0
        Top = 102
        Width = 340
        Height = 252
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 2
      end
      object GBDelFrc: TGroupBox
        Left = 630
        Top = 7
        Width = 297
        Height = 87
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 3
      end
      object GBHighFrc: TGroupBox
        Left = 348
        Top = 7
        Width = 274
        Height = 87
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 4
      end
      object GBLowFrc: TGroupBox
        Left = 1
        Top = 7
        Width = 339
        Height = 87
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 5
      end
    end
  end
  object PanBtn: TPanel
    Left = 0
    Top = 402
    Width = 947
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object BtnOk: TcxButton
      Left = 728
      Top = 12
      Width = 93
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
      Left = 827
      Top = 12
      Width = 95
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
  end
end
