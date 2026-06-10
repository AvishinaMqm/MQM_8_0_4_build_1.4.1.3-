object FrmBintotals: TFrmBintotals
  Left = 211
  Top = 132
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bin totals'
  ClientHeight = 204
  ClientWidth = 758
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 758
    Height = 204
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ParentCustomHint = False
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'All'
      object LblSched: TLabel
        Left = 10
        Top = 43
        Width = 65
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Scheduled'
      end
      object LblJobs: TLabel
        Left = 118
        Top = 17
        Width = 78
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Jobs/Groups'
      end
      object LblNotSched: TLabel
        Left = 10
        Top = 87
        Width = 87
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Not scheduled'
      end
      object LblQty: TLabel
        Left = 233
        Top = 17
        Width = 48
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Quantity'
      end
      object Label1: TLabel
        Left = 389
        Top = 17
        Width = 63
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Setup time'
      end
      object Label2: TLabel
        Left = 546
        Top = 17
        Width = 86
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Execution time'
      end
      object StTxtRecNo: TStaticText
        Left = 118
        Top = 43
        Width = 77
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'StTxtRecNo'
        TabOrder = 0
      end
      object StTxtRecNo2: TStaticText
        Left = 118
        Top = 87
        Width = 84
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'StTxtRecNo2'
        TabOrder = 1
      end
      object StTxtQty2: TStaticText
        Left = 234
        Top = 87
        Width = 61
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'StTxtQty2'
        TabOrder = 2
      end
      object StTxtQty: TStaticText
        Left = 234
        Top = 43
        Width = 54
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'StTxtQty'
        TabOrder = 3
      end
      object StTxtSetup: TStaticText
        Left = 393
        Top = 43
        Width = 69
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'StTxtSetup'
        TabOrder = 4
      end
      object StTxtExe: TStaticText
        Left = 550
        Top = 43
        Width = 57
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'StTxtExe'
        TabOrder = 5
      end
    end
    object TabSheet2: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'By date'
      ImageIndex = 1
      object LabelFrom: TLabel
        Left = 14
        Top = 18
        Width = 31
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'From'
      end
      object LabelTo: TLabel
        Left = 289
        Top = 18
        Width = 17
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'To'
      end
      object LblTab2: TLabel
        Left = 9
        Top = 82
        Width = 65
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Scheduled'
      end
      object LblJobsGroupSched: TLabel
        Left = 117
        Top = 58
        Width = 78
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Jobs/Groups'
      end
      object LblQtySched: TLabel
        Left = 231
        Top = 58
        Width = 48
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Quantity'
      end
      object LblSetUpSched: TLabel
        Left = 388
        Top = 58
        Width = 63
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Setup time'
      end
      object LblExecSched: TLabel
        Left = 545
        Top = 58
        Width = 86
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Execution time'
      end
      object DatePickerFrom: TDateTimePicker
        Left = 52
        Top = 12
        Width = 118
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Date = 37886.000000000000000000
        Time = 0.680019166698912200
        Checked = False
        Color = 14803425
        DateMode = dmUpDown
        TabOrder = 0
      end
      object TimePickerFrom: TDateTimePicker
        Left = 180
        Top = 12
        Width = 101
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Date = 37886.000000000000000000
        Time = 0.680019166698912200
        Checked = False
        Color = 14803425
        DateMode = dmUpDown
        Kind = dtkTime
        TabOrder = 1
      end
      object DatePickerTo: TDateTimePicker
        Left = 320
        Top = 12
        Width = 118
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Date = 37886.000000000000000000
        Time = 0.680019166698912200
        Checked = False
        Color = 14803425
        DateMode = dmUpDown
        TabOrder = 2
      end
      object TimePickerTo: TDateTimePicker
        Left = 446
        Top = 12
        Width = 93
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Date = 37886.000000000000000000
        Time = 0.680019166698912200
        Checked = False
        Color = 14803425
        DateMode = dmUpDown
        Kind = dtkTime
        TabOrder = 3
      end
      object StaticTextCountSched: TStaticText
        Left = 117
        Top = 82
        Width = 77
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'StTxtRecNo'
        TabOrder = 4
      end
      object StaticTextQtySched: TStaticText
        Left = 231
        Top = 82
        Width = 54
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'StTxtQty'
        TabOrder = 5
      end
      object StaticTextSetUpSched: TStaticText
        Left = 391
        Top = 82
        Width = 69
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'StTxtSetup'
        TabOrder = 6
      end
      object StaticTextExecSched: TStaticText
        Left = 549
        Top = 82
        Width = 57
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'StTxtExe'
        TabOrder = 7
      end
      object CBxDateType: TComboBox
        Left = 576
        Top = 12
        Width = 167
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 8
      end
      object BitBtnReCalc: TcxButton
        Left = 529
        Top = 126
        Width = 93
        Height = 33
        Caption = 'Re-Calc'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 9
        OnClick = BitBtnReCalcClick
      end
      object BitBtnAbort: TcxButton
        Left = 639
        Top = 126
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
        TabOrder = 10
        OnClick = BitBtnAbortClick
      end
      object BitBtn1: TcxButton
        Left = 401
        Top = 126
        Width = 112
        Height = 33
        Caption = 'Show job list'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 11
        OnClick = BitBtn1Click
      end
    end
  end
end
