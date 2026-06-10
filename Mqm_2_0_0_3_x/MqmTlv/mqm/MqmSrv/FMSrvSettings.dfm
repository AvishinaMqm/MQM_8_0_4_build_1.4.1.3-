object FSrvSettings: TFSrvSettings
  Left = 355
  Top = 207
  Caption = 'Settings'
  ClientHeight = 336
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PGCset: TPageControl
    Left = 0
    Top = 0
    Width = 454
    Height = 296
    ActivePage = TBOper
    Align = alClient
    TabOrder = 0
    object TBOper: TTabSheet
      Caption = 'Mqm data transfer'
      object SpeedButton1: TSpeedButton
        Left = 357
        Top = 28
        Width = 22
        Height = 22
        Caption = '. . .'
        OnClick = SpeedButton1Click
      end
      object StDataPreparationName: TStaticText
        Left = 12
        Top = 32
        Width = 167
        Height = 17
        Caption = 'Data preparation Execution Name '
        TabOrder = 0
      end
      object EditPraperationName: TEdit
        Left = 178
        Top = 28
        Width = 166
        Height = 21
        ReadOnly = True
        TabOrder = 1
        OnDblClick = EditPraperationNameDblClick
      end
      object GBoxCopyDemndFromMqm: TGroupBox
        Left = 12
        Top = 107
        Width = 259
        Height = 162
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Copy MQM schedules to MCM'
        TabOrder = 2
        object SpinEdtHoursToleranceOfGapBetweenJobs: TSpinEdit
          Left = 168
          Top = 15
          Width = 48
          Height = 22
          MaxLength = 3
          MaxValue = 999
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnChange = SpinEdtHoursToleranceOfGapBetweenJobsChange
        end
        object CBConfirmationLvlCopyFromMqm: TCheckBox
          Left = 3
          Top = 38
          Width = 159
          Height = 14
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'Copy from confirmation level'
          TabOrder = 1
        end
        object CBNumOfDaysCopyFromMqm: TCheckBox
          Left = 3
          Top = 18
          Width = 159
          Height = 13
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'Number of days from today'
          TabOrder = 2
        end
        object RGConfLvl: TRadioGroup
          Left = 3
          Top = 57
          Width = 235
          Height = 99
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
      object StaticTextDaysKeepHistory: TStaticText
        Left = 12
        Top = 58
        Width = 102
        Height = 17
        Caption = 'Days to keep History'
        TabOrder = 3
      end
      object SEdtDaysToKeepHistory: TSpinEdit
        Left = 178
        Top = 56
        Width = 44
        Height = 22
        MaxLength = 2
        MaxValue = 21
        MinValue = 0
        TabOrder = 4
        Value = 14
      end
      object CBForceMqmScheduleDetails: TCheckBox
        Left = 12
        Top = 84
        Width = 270
        Height = 14
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Force Mqm schedule details to MCM'
        TabOrder = 5
      end
    end
    object TBTimings: TTabSheet
      Caption = 'Timings'
      ImageIndex = 2
      object CBUploadDwndTillProcFinish: TCheckBox
        Left = 15
        Top = 206
        Width = 411
        Height = 25
        Caption = 
          'Wait till upload process is done  (Active only when Upload/Downl' +
          'oad selection)'
        TabOrder = 0
        OnClick = CBUploadDwndTillProcFinishClick
      end
      object GroupBox1: TGroupBox
        Left = 2
        Top = 9
        Width = 356
        Height = 192
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        TabOrder = 1
        object Label1: TLabel
          Left = 94
          Top = 166
          Width = 118
          Height = 13
          Caption = 'Stop operation after time '
        end
        object RadioGroupTimeScalAuto: TRadioGroup
          Left = 8
          Top = 35
          Width = 179
          Height = 121
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            '1/2 Min'
            '1 Min'
            '2 Min'
            '3 Min'
            '4 Min'
            '5 Min'
            '6 Min')
          TabOrder = 0
        end
        object CBWaitAfterSend: TCheckBox
          Left = 8
          Top = 8
          Width = 342
          Height = 25
          Caption = 'Ongoing cycle  (Active only when Download/Upload selection)'
          TabOrder = 1
          OnClick = CBWaitAfterSendClick
        end
        object TimePicker: TDateTimePicker
          Left = 8
          Top = 164
          Width = 76
          Height = 21
          Date = 37886.000000000000000000
          Time = 0.680019166698912200
          Checked = False
          DateMode = dmUpDown
          Kind = dtkTime
          TabOrder = 2
        end
      end
    end
  end
  object PanBtn: TPanel
    Left = 0
    Top = 296
    Width = 454
    Height = 40
    Align = alBottom
    TabOrder = 1
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
  object OpenDialog1: TOpenDialog
    Left = 88
    Top = 8
  end
end
