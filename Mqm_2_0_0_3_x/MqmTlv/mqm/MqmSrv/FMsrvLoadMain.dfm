object FSrvLoad: TFSrvLoad
  Left = 444
  Top = 238
  Width = 312
  Height = 210
  Caption = 'Server load'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu: TMainMenu
    Left = 56
    Top = 56
    object ILoad: TMenuItem
      Caption = 'Load'
      object ICalendar: TMenuItem
        Caption = 'Calendar'
        OnClick = ICalendarClick
      end
    end
  end
  object IBDatabase: TIBDatabase
    DatabaseName = 'D:\Environments\Mqm\Mqm.gdb'
    Params.Strings = (
      'password=masterkey'
      'USER_NAME=SYSDBA')
    LoginPrompt = False
    DefaultTransaction = IBTransaction
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 112
    Top = 8
  end
  object IBTransaction: TIBTransaction
    Active = False
    DefaultDatabase = IBDatabase
    AutoStopAction = saNone
    Left = 200
    Top = 40
  end
  object DBAs400: TDatabase
    AliasName = 'VIP2DB2'
    DatabaseName = 'SRV_DBAS400'
    LoginPrompt = False
    SessionName = 'Default'
    Left = 200
    Top = 104
  end
end
