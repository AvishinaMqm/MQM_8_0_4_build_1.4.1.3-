object DMFireDacConnection: TDMFireDacConnection
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 376
  Width = 522
  object OpenDialogDB: TOpenDialog
    DefaultExt = 'gdb'
    Left = 48
    Top = 248
  end
  object FDQuery1: TFDQuery
    Left = 248
    Top = 240
  end
  object FDConnection1: TFDConnection
    Left = 240
    Top = 136
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 192
    Top = 312
  end
  object FDTransaction1: TFDTransaction
    Connection = FDConnection1
    Left = 344
    Top = 248
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 136
    Top = 208
  end
  object FDPhysIBDriverLink1: TFDPhysIBDriverLink
    Left = 72
    Top = 136
  end
end
