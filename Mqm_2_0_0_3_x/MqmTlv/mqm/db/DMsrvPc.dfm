object DMib: TDMib
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 470
  Width = 653
  PixelsPerInch = 120
  object OpenDialogDB: TOpenDialog
    DefaultExt = 'gdb'
    Left = 470
    Top = 40
  end
  object FDQuery1: TFDQuery
    Left = 410
    Top = 310
  end
  object FDConnection1: TFDConnection
    Left = 300
    Top = 110
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 370
    Top = 390
  end
  object FDTransaction1: TFDTransaction
    Connection = FDConnection1
    Left = 520
    Top = 310
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 240
    Top = 260
  end
  object FDPhysIBDriverLink1: TFDPhysIBDriverLink
    Left = 71
    Top = 261
  end
  object FDPhysDB2DriverLink1: TFDPhysDB2DriverLink
    Left = 90
    Top = 80
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 480
    Top = 190
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    Left = 70
    Top = 180
  end
  object FDStoredProc1: TFDStoredProc
    Connection = FDConnection1
    Left = 310
    Top = 200
  end
  object FDEventAlerter1: TFDEventAlerter
    Connection = FDConnection1
    Left = 240
    Top = 40
  end
end
