object FDbConf: TFDbConf
  Left = 371
  Top = 210
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Database configuration'
  ClientHeight = 228
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object GPBserver: TGroupBox
    Left = 0
    Top = 0
    Width = 406
    Height = 57
    Align = alTop
    Caption = 'Server'
    TabOrder = 0
    object StName: TStaticText
      Left = 13
      Top = 18
      Width = 41
      Height = 20
      Caption = 'Name'
      TabOrder = 0
    end
    object EdSrvName: TEdit
      Left = 64
      Top = 16
      Width = 121
      Height = 21
      AutoSize = False
      TabOrder = 1
    end
  end
  object GPBmain: TGroupBox
    Left = 0
    Top = 57
    Width = 406
    Height = 64
    Align = alTop
    Caption = 'Main database'
    TabOrder = 1
    object LblMainPath: TLabel
      Left = 16
      Top = 28
      Width = 27
      Height = 16
      Caption = 'Path'
    end
    object EdMainPath: TEdit
      Left = 64
      Top = 24
      Width = 329
      Height = 21
      AutoSize = False
      TabOrder = 0
    end
  end
  object GPBconfig: TGroupBox
    Left = 0
    Top = 121
    Width = 406
    Height = 66
    Align = alClient
    Caption = 'Configuration database'
    TabOrder = 2
    object LblCfgPath: TLabel
      Left = 16
      Top = 27
      Width = 27
      Height = 16
      Caption = 'Path'
    end
    object EdCfgPath: TEdit
      Left = 64
      Top = 23
      Width = 329
      Height = 21
      AutoSize = False
      TabOrder = 0
    end
  end
  object PanBtn: TPanel
    Left = 0
    Top = 187
    Width = 406
    Height = 41
    Align = alBottom
    TabOrder = 3
    object BtnOk: TBitBtn
      Left = 240
      Top = 8
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnCanc: TBitBtn
      Left = 320
      Top = 8
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object OpnDlg: TOpenDialog
    Filter = 'Interbase|*.gdb'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 8
    Top = 88
  end
end
