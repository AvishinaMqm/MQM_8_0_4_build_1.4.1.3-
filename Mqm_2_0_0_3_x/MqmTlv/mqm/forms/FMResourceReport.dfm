object FResourceReport: TFResourceReport
  Left = 1065
  Top = 439
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Resource report generator'
  ClientHeight = 396
  ClientWidth = 419
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 345
    Width = 419
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object BtnCreate: TcxButton
      Left = 47
      Top = 7
      Width = 91
      Height = 33
      Caption = 'Create'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BtnCreateClick
    end
    object BitClose: TcxButton
      Left = 310
      Top = 7
      Width = 95
      Height = 33
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BitCloseClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 419
    Height = 345
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 48
      Top = 6
      Width = 79
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Work centers'
    end
    object Label2: TLabel
      Left = 254
      Top = 6
      Width = 66
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resources'
    end
    object LbltoDate: TLabel
      Left = 47
      Top = 283
      Width = 47
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'To date'
    end
    object LblFromDate: TLabel
      Left = 47
      Top = 226
      Width = 61
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'From date'
    end
    object ChkLstBoxRsc: TCheckListBox
      Left = 254
      Top = 30
      Width = 148
      Height = 188
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = 14803425
      TabOrder = 0
    end
    object ChkLstBoxWkc: TCheckListBox
      Left = 48
      Top = 30
      Width = 149
      Height = 188
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      OnClickCheck = ChkLstBoxWkcClickCheck
      Color = 14803425
      TabOrder = 1
    end
    object DatePickerFromDate: TDateTimePicker
      Left = 47
      Top = 247
      Width = 229
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 44050.000000000000000000
      Time = 0.837262002314673700
      Color = 14803425
      DateFormat = dfLong
      TabOrder = 2
    end
    object DatePickerToDate: TDateTimePicker
      Left = 47
      Top = 304
      Width = 229
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 44050.000000000000000000
      Time = 0.837433622684329700
      Color = 14803425
      DateFormat = dfLong
      TabOrder = 3
    end
    object DateTimePicker_FromTime: TDateTimePicker
      Left = 282
      Top = 247
      Width = 123
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 38837.000000000000000000
      Time = 38837.000000000000000000
      Color = 14803425
      Kind = dtkTime
      TabOrder = 4
    end
    object DateTimePicker_ToTime: TDateTimePicker
      Left = 282
      Top = 304
      Width = 123
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Date = 38837.000000000000000000
      Time = 0.999988425930496300
      Color = 14803425
      Kind = dtkTime
      TabOrder = 5
    end
  end
end
