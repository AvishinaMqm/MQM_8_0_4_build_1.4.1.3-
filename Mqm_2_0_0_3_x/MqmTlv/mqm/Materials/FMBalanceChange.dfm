object FBalanceChange: TFBalanceChange
  Left = 0
  Top = 0
  Caption = 'Modify'
  ClientHeight = 110
  ClientWidth = 471
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 471
    Height = 110
    Align = alClient
    BevelKind = bkFlat
    BevelWidth = 5
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 75
      Top = 15
      Width = 46
      Height = 13
      Caption = 'Date time'
    end
    object Label2: TLabel
      Left = 204
      Top = 15
      Width = 42
      Height = 13
      Caption = 'Quantity'
    end
    object Label3: TLabel
      Left = 286
      Top = 15
      Width = 32
      Height = 13
      Caption = 'Details'
    end
    object DatePicker: TDateTimePicker
      Left = 26
      Top = 35
      Width = 79
      Height = 21
      Date = 37886.000000000000000000
      Time = 0.680019166698912200
      Checked = False
      Color = 14803425
      DateMode = dmUpDown
      TabOrder = 0
    end
    object TimePicker: TDateTimePicker
      Left = 111
      Top = 35
      Width = 67
      Height = 21
      Date = 37886.000000000000000000
      Time = 0.680019166698912200
      Checked = False
      Color = 14803425
      DateMode = dmUpDown
      Kind = dtkTime
      TabOrder = 1
    end
    object StaticQuantity: TStaticText
      Left = 206
      Top = 38
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Quantity'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
    end
    object StaticDetailsDesc: TStaticText
      Left = 284
      Top = 39
      Width = 167
      Height = 17
      AutoSize = False
      Caption = 'Details desc'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
    end
    object BtnOk: TcxButton
      Left = 289
      Top = 62
      Width = 81
      Height = 30
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 4
      OnClick = BtnOkClick
    end
    object BtnAbort: TcxButton
      Left = 376
      Top = 62
      Width = 75
      Height = 30
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 5
      OnClick = BtnAbortClick
    end
  end
end
