object FSrvLoad: TFSrvLoad
  Left = 288
  Top = 208
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 286
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PGCmain: TPageControl
    Left = 0
    Top = 0
    Width = 433
    Height = 271
    ActivePage = TBSctrl
    Align = alClient
    TabOrder = 0
    object TBSctrl: TTabSheet
      Caption = 'Control'
      object PanLoad: TPanel
        Left = 0
        Top = 0
        Width = 426
        Height = 48
        Align = alTop
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
        object ShFromHost: TShape
          Left = 8
          Top = 8
          Width = 40
          Height = 32
          Brush.Color = clRed
          Pen.Width = 2
          Shape = stCircle
        end
        object STfromHost: TStaticText
          Left = 71
          Top = 14
          Width = 127
          Height = 20
          Caption = 'Loading from host'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object PanSend: TPanel
        Left = 0
        Top = 97
        Width = 426
        Height = 48
        Align = alTop
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 1
        object ShToHost: TShape
          Left = 8
          Top = 8
          Width = 40
          Height = 32
          Brush.Color = clRed
          Pen.Width = 2
          Shape = stCircle
        end
        object StToHost: TStaticText
          Left = 71
          Top = 14
          Width = 111
          Height = 20
          Caption = 'Sending to host'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object PanBtn: TPanel
        Left = 0
        Top = 145
        Width = 426
        Height = 101
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          425
          98)
        object LblTable: TLabel
          Left = 6
          Top = 38
          Width = 414
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          ExplicitWidth = 415
        end
        object LabelDownOp: TLabel
          Left = 6
          Top = 6
          Width = 414
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          ExplicitWidth = 415
        end
      end
      object PanLocal: TPanel
        Left = 0
        Top = 48
        Width = 425
        Height = 49
        Align = alTop
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 3
        ExplicitWidth = 426
        object ShLocal: TShape
          Left = 8
          Top = 8
          Width = 40
          Height = 32
          Brush.Color = clRed
          Pen.Width = 2
          Shape = stCircle
        end
        object StLocal: TStaticText
          Left = 71
          Top = 14
          Width = 177
          Height = 20
          Caption = 'Updating production files'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object TBSerrRepo: TTabSheet
      Caption = 'Error report'
      ImageIndex = 1
      object MmErrors: TMemo
        Left = 0
        Top = 0
        Width = 425
        Height = 243
        Align = alClient
        Lines.Strings = (
          '')
        TabOrder = 0
        ExplicitWidth = 426
        ExplicitHeight = 246
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 271
    Width = 433
    Height = 15
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Panels = <
      item
        Width = 200
      end
      item
        Width = 160
      end>
  end
  object MainMenu: TMainMenu
    Left = 256
    Top = 8
    object IConfig: TMenuItem
      Caption = '&Configure'
      OnClick = IConfigClick
    end
    object IService: TMenuItem
      Caption = '&Manual service'
      OnClick = IServiceClick
      object MenualTransfer: TMenuItem
        Caption = '&Manual transfer'
        object MiDonwUpload: TMenuItem
          Caption = 'Download / Upload'
          OnClick = MiDonwUploadClick
        end
        object MiUploadDonw: TMenuItem
          Caption = 'Upload / Download'
          OnClick = MiUploadDonwClick
        end
        object ILoadManual: TMenuItem
          Caption = 'Download'
          OnClick = ILoadManualClick
        end
        object MiUpload: TMenuItem
          Caption = 'UpLoad'
          OnClick = MiUploadClick
        end
        object MiDloadPS: TMenuItem
          Caption = 'Download scheduled only'
          Visible = False
          OnClick = MiDloadPSClick
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object ArchivesDownload: TMenuItem
        Caption = 'Archive download'
        object MiArchive: TMenuItem
          Caption = 'Archives'
          OnClick = MiArchiveClick
        end
        object MICalendars: TMenuItem
          Caption = 'Calendar'
          OnClick = MICalendarsClick
        end
      end
    end
    object info1: TMenuItem
      Caption = 'Info'
      OnClick = info1Click
      OnDrawItem = info1DrawItem
    end
    object IExit: TMenuItem
      Caption = '&Exit'
      OnClick = IExitClick
    end
    object N2: TMenuItem
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 332
    Top = 243
  end
end
