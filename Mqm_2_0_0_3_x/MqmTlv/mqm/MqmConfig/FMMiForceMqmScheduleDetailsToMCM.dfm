object ForceMqmScheduleDetailsToMCM: TForceMqmScheduleDetailsToMCM
  Left = 0
  Top = 0
  Caption = 'Force Mqm Schedule Details To MCM'
  ClientHeight = 300
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object CBForceMqmScheduleDetails: TCheckBox
    Left = 19
    Top = 22
    Width = 270
    Height = 14
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Force Mqm schedule details to MCM'
    TabOrder = 0
  end
  object GBoxCopyDemndFromMqm: TGroupBox
    Left = 9
    Top = 58
    Width = 374
    Height = 193
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Copy MQM schedules to MCM'
    TabOrder = 1
    object SpinEdtHoursToleranceOfGapBetweenJobs: TSpinEdit
      Left = 203
      Top = 21
      Width = 48
      Height = 24
      MaxLength = 3
      MaxValue = 999
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object CBConfirmationLvlCopyFromMqm: TCheckBox
      Left = 10
      Top = 47
      Width = 193
      Height = 14
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Copy from confirmation level'
      TabOrder = 1
    end
    object CBNumOfDaysCopyFromMqm: TCheckBox
      Left = 10
      Top = 25
      Width = 182
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Number of days from today'
      TabOrder = 2
    end
    object RGConfLvl: TRadioGroup
      Left = 2
      Top = 72
      Width = 303
      Height = 112
      Caption = 'Default schedule level'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Final'
        'Initial '
        'Confirmation level 1'
        'Confirmation level 2'
        'Confirmation level 3'
        'Confirmation level 4'
        'Confirmation level 5')
      TabOrder = 3
    end
  end
  object PanBtn: TPanel
    Left = 0
    Top = 260
    Width = 424
    Height = 40
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 244
    ExplicitWidth = 414
    object BtnOk: TBitBtn
      Left = 227
      Top = 8
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnCanc: TBitBtn
      Left = 307
      Top = 8
      Width = 74
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
