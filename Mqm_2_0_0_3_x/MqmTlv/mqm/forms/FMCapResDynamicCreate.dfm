object CapResDynamicCreate: TCapResDynamicCreate
  Left = 0
  Top = 0
  Caption = 'Capacity resrvation dynamic creatation'
  ClientHeight = 152
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 436
    Height = 152
    Align = alClient
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 22
      Top = 16
      Width = 57
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Start date'
    end
    object Lblfromtime: TLabel
      Left = 149
      Top = 16
      Width = 59
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'From time'
    end
    object Label2: TLabel
      Left = 299
      Top = 16
      Width = 72
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'To date limit'
    end
    object DatePickerStart: TDateTimePicker
      Left = 20
      Top = 40
      Width = 103
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 37886.000000000000000000
      Time = 0.680019166698912200
      Checked = False
      DateMode = dmUpDown
      TabOrder = 0
    end
    object TimePicker1Start: TDateTimePicker
      Left = 152
      Top = 40
      Width = 91
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 37886.000000000000000000
      Time = 37886.000000000000000000
      Checked = False
      DateMode = dmUpDown
      Kind = dtkTime
      TabOrder = 1
    end
    object DateTimePickerToDatelimit: TDateTimePicker
      Left = 297
      Top = 40
      Width = 103
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 37886.000000000000000000
      Time = 0.680019166698912200
      Checked = False
      DateMode = dmUpDown
      TabOrder = 2
    end
    object BtnOk: TcxButton
      Left = 22
      Top = 102
      Width = 93
      Height = 30
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 3
      OnClick = BtnOkClick
    end
    object BtnAbort: TcxButton
      Left = 305
      Top = 102
      Width = 95
      Height = 30
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 4
      OnClick = BtnAbortClick
    end
  end
end
