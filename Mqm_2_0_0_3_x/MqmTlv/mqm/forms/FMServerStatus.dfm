object FServerStatus: TFServerStatus
  Left = 201
  Top = 221
  Caption = 'Server Status'
  ClientHeight = 387
  ClientWidth = 682
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  TextHeight = 13
  object LabDateTime: TLabel
    Left = 48
    Top = 6
    Width = 97
    Height = 19
    AutoSize = False
    Caption = 'Date/Time'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object LabOperation: TLabel
    Left = 164
    Top = 6
    Width = 93
    Height = 19
    AutoSize = False
    Caption = 'Operation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object LabDesc: TLabel
    Left = 284
    Top = 6
    Width = 102
    Height = 20
    AutoSize = False
    Caption = 'Description'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object LogMemo: TMemo
    Left = 8
    Top = 30
    Width = 675
    Height = 313
    Color = 14803425
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object BtnOk: TcxButton
    Left = 284
    Top = 349
    Width = 102
    Height = 33
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 1
    OnClick = BtnOkClick
  end
end
