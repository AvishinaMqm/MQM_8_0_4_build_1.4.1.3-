object FCreateLic: TFCreateLic
  Left = 186
  Top = 119
  Caption = 'Licence creation'
  ClientHeight = 447
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object LblIssuer: TLabel
    Left = 30
    Top = 30
    Width = 36
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Issuer'
  end
  object LblCust: TLabel
    Left = 30
    Top = 65
    Width = 57
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Customer'
  end
  object LblReleDate: TLabel
    Left = 30
    Top = 101
    Width = 82
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Release date'
  end
  object LblLock: TLabel
    Left = 30
    Top = 137
    Width = 77
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Lock number'
  end
  object LblInst: TLabel
    Left = 30
    Top = 171
    Width = 92
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Installation type'
  end
  object LblMax: TLabel
    Left = 30
    Top = 207
    Width = 113
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Concurrent viewers'
  end
  object LblMaxCont: TLabel
    Left = 30
    Top = 242
    Width = 119
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Concurrent planners'
  end
  object LblExpDate: TLabel
    Left = 28
    Top = 278
    Width = 67
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Expiry date'
  end
  object LblConfig: TLabel
    Left = 30
    Top = 319
    Width = 115
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Config enable level'
  end
  object LblMqmMcm: TLabel
    Left = 30
    Top = 352
    Width = 73
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'MQM / MCM'
  end
  object BtnOk: TBitBtn
    Left = 39
    Top = 404
    Width = 93
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 0
    OnClick = BtnOkClick
  end
  object EdIssuer: TEdit
    Left = 226
    Top = 25
    Width = 258
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    TabOrder = 1
  end
  object EdCustomer: TEdit
    Left = 226
    Top = 60
    Width = 258
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    TabOrder = 2
  end
  object EdLock: TEdit
    Left = 226
    Top = 132
    Width = 130
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    TabOrder = 3
  end
  object DTPrele: TDateTimePicker
    Left = 226
    Top = 96
    Width = 140
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Date = 38138.000000000000000000
    Time = 0.729065393497876400
    TabOrder = 4
  end
  object CBinst: TComboBox
    Left = 226
    Top = 166
    Width = 179
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    ItemIndex = 2
    TabOrder = 5
    Text = 'everything allowed'
    Items.Strings = (
      'no save for nw PS'
      'no save'
      'everything allowed')
  end
  object EdMaxSupp: TEdit
    Left = 226
    Top = 202
    Width = 61
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    TabOrder = 6
  end
  object EdMaxCont: TEdit
    Left = 226
    Top = 238
    Width = 61
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    TabOrder = 7
  end
  object BtnImpLock: TcxButton
    Left = 197
    Top = 404
    Width = 92
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Import lock'
    TabOrder = 8
    OnClick = BtnImpLockClick
  end
  object EdCfgLev: TEdit
    Left = 226
    Top = 314
    Width = 61
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    TabOrder = 9
    Text = '1'
  end
  object DTPexpDate: TDateTimePicker
    Left = 226
    Top = 274
    Width = 140
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Time = 0.729065393497876000
    TabOrder = 10
  end
  object ChkExpDate: TCheckBox
    Left = 374
    Top = 276
    Width = 120
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Checked = True
    State = cbChecked
    TabOrder = 11
  end
  object CBMqmMcm: TComboBox
    Left = 226
    Top = 348
    Width = 87
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    TabOrder = 12
    Items.Strings = (
      'MQM'
      'MCM')
  end
  object SaveLic: TSaveDialog
    DefaultExt = 'mlc'
    FileName = 'MQMlic'
    Filter = 'MQM licence|*.mlc'
    Left = 272
    Top = 248
  end
  object ODkey: TOpenDialog
    DefaultExt = 'lck'
    FileName = 'MQMlock'
    Filter = 'MQM lock|*.lck'
    Left = 312
    Top = 248
  end
end
