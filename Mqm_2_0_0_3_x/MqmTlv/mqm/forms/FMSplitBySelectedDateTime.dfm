object SplitBySelectedDateTime: TSplitBySelectedDateTime
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Split By Selected Date Time'
  ClientHeight = 306
  ClientWidth = 428
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object LabelRoundDec: TLabel
    Left = 18
    Top = 97
    Width = 186
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Number of decimals to round  '
  end
  object CBxRejoinStepsJob: TCheckBox
    Left = 18
    Top = 230
    Width = 268
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Re-Join step jobs moved back to bin ?'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object DateTimePickerDate: TDateTimePicker
    Left = 18
    Top = 38
    Width = 244
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Date = 44050.000000000000000000
    Time = 0.837262002314673700
    Color = 14803425
    DateFormat = dfLong
    TabOrder = 1
  end
  object DateTimePickerTime: TDateTimePicker
    Left = 286
    Top = 38
    Width = 131
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Date = 38837.000000000000000000
    Time = 38837.000000000000000000
    Color = 14803425
    Kind = dtkTime
    TabOrder = 2
  end
  object CBRound: TComboBox
    Left = 319
    Top = 93
    Width = 64
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = 14803425
    TabOrder = 3
    Text = '0'
    Items.Strings = (
      '0'
      '1'
      '2'
      '')
  end
  object RadioGroupRoundingCriteria: TRadioGroup
    Left = 18
    Top = 135
    Width = 242
    Height = 64
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Rounding Criteria'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Up'
      'Down')
    TabOrder = 4
  end
  object BitBtn1: TcxButton
    Left = 18
    Top = 266
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
    TabOrder = 5
    OnClick = BitBtn1Click
  end
  object BtnAbo: TcxButton
    Left = 325
    Top = 266
    Width = 95
    Height = 33
    Caption = 'Abort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 6
    OnClick = BtnAboClick
  end
end
