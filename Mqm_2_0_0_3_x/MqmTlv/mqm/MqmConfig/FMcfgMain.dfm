object MainForm: TMainForm
  Left = 431
  Top = 349
  Caption = 'MQM configuration'
  ClientHeight = 132
  ClientWidth = 493
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  Position = poDesktopCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 16
  object LblMainDb: TLabel
    Left = 10
    Top = 20
    Width = 60
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Database'
  end
  object LblLicenseMqm: TLabel
    Left = 9
    Top = 67
    Width = 80
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'License mqm'
  end
  object LblLicenseMcm: TLabel
    Left = 8
    Top = 100
    Width = 79
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'License mcm'
  end
  object StLicenseMqm: TStaticText
    Left = 104
    Top = 63
    Width = 333
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    BorderStyle = sbsSunken
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    Transparent = False
  end
  object Panel1: TPanel
    Left = 96
    Top = 205
    Width = 185
    Height = 41
    Caption = 'Panel1'
    Color = clFuchsia
    ParentBackground = False
    TabOrder = 1
  end
  object StDatabase: TStaticText
    Left = 79
    Top = 17
    Width = 226
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    BorderStyle = sbsSunken
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    Transparent = False
  end
  object StLicenseMcm: TStaticText
    Left = 104
    Top = 96
    Width = 333
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    BorderStyle = sbsSunken
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    Transparent = False
  end
  object MainMenu: TMainMenu
    Left = 352
    Top = 9
    object IFile: TMenuItem
      Caption = '&File'
      object IExit: TMenuItem
        Caption = 'Exit'
        OnClick = IExitClick
      end
      object IResExchg: TMenuItem
        Caption = 'Reset DB lock'
        Visible = False
      end
    end
    object IConfig: TMenuItem
      Caption = '&Configuration'
      object MiConnections: TMenuItem
        Caption = 'Connection'
        OnClick = MiConnectionsClick
      end
      object Languages1: TMenuItem
        Caption = 'Languages'
        object MIEnglish: TMenuItem
          Caption = 'English'
          OnClick = MIEnglishClick
        end
        object MiChinese: TMenuItem
          Caption = 'Chinese'
          OnClick = MiChineseClick
        end
        object MIItalian: TMenuItem
          Caption = 'Italian'
          OnClick = MIItalianClick
        end
        object MISpanish: TMenuItem
          Caption = 'Spanish'
          OnClick = MISpanishClick
        end
        object MiTurkish: TMenuItem
          Caption = 'Turkish'
          OnClick = MiTurkishClick
        end
      end
      object ReadIni1: TMenuItem
        Caption = 'Read Ini'
        Visible = False
        OnClick = ReadIni1Click
      end
    end
    object ICreate: TMenuItem
      Caption = 'C&reate'
      object IDatabase: TMenuItem
        Caption = 'Database'
        OnClick = IDatabaseClick
      end
      object MICrtStored: TMenuItem
        Caption = 'Stored procedures'
        OnClick = MICrtStoredClick
      end
      object CiCreateView: TMenuItem
        Caption = 'Create View'
        OnClick = CiCreateViewClick
      end
      object UpdateInterbasedates1: TMenuItem
        Caption = 'Update Interbase dates'
        Visible = False
      end
    end
    object ILicence: TMenuItem
      Caption = '&Licencing'
      object IVMqm: TMenuItem
        Caption = 'MQM'
        object ICreateLock: TMenuItem
          Caption = 'Create lock'
          OnClick = ICreateLockClick
        end
        object IViewLic: TMenuItem
          Caption = 'View license'
          OnClick = IViewMQMLicClick
        end
      end
      object IVMCM: TMenuItem
        Caption = 'MCM'
        object ICreateLockMCM: TMenuItem
          Caption = 'Create lock'
          OnClick = ICreateLockClick
        end
        object IViewLicMCM: TMenuItem
          Caption = 'View license'
          OnClick = IViewMCMLicClick
        end
      end
    end
    object ITools: TMenuItem
      Caption = '&Tools'
      object IDataBase1: TMenuItem
        Caption = 'DataBase'
        Visible = False
        object IBackupRestore: TMenuItem
          Caption = 'Backup/Restore'
          OnClick = IBackupRestoreClick
        end
      end
      object EnDecrypt1: TMenuItem
        Caption = 'EnDecrypt'
        OnClick = ReadIni1Click
      end
      object MiClearMqmSrvLoadRecord: TMenuItem
        Caption = 'Clear MqmSrvLoad record'
        Visible = False
        OnClick = MiClearMqmSrvLoadRecordClick
      end
      object MiForceMqmScheduleDetailsToMCM: TMenuItem
        Caption = 'Force Mqm schedule details to MCM'
        Visible = False
        OnClick = MiForceMqmScheduleDetailsToMCMClick
      end
      object SQL1: TMenuItem
        Caption = 'SQL'
        OnClick = SQL1Click
      end
    end
  end
  object SDlock: TSaveDialog
    DefaultExt = 'lck'
    FileName = 'mqmLock'
    Filter = 'lock file|lck'
    Left = 288
    Top = 8
  end
end
