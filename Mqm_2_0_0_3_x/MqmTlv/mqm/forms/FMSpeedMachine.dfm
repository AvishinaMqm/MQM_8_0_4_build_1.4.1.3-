object SpeedMachine: TSpeedMachine
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Modify execution and setup'
  ClientHeight = 300
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  Position = poScreenCenter
  TextHeight = 13
  object PageControlSpeedChange: TPageControl
    Left = 0
    Top = 0
    Width = 674
    Height = 300
    ActivePage = TabSheetJobSpeed
    Align = alClient
    TabOrder = 0
    object TabSheetJobSpeed: TTabSheet
      Caption = 'Speed/Setup'
      DesignSize = (
        666
        272)
      object BtnAbort: TcxButton
        Left = 589
        Top = 241
        Width = 70
        Height = 28
        Anchors = [akRight, akBottom]
        Caption = 'Abort'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Montserrat'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 0
        OnClick = BtnAbortClick
      end
      object BtnOk: TcxButton
        Left = 518
        Top = 241
        Width = 65
        Height = 28
        Anchors = [akRight, akBottom]
        Caption = 'OK'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 1
        OnClick = BtnOkClick
      end
      object BtnRmvOveridn: TcxButton
        Left = 3
        Top = 205
        Width = 188
        Height = 28
        Caption = 'Back to standard'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 2

        OnClick = BtnOkClick
      end
      object GroupBoxSetUpStep: TGroupBox
        Left = 361
        Top = 3
        Width = 297
        Height = 113
        Caption = 'Setup for Step'
        TabOrder = 3
        object LblChangedSetup: TLabel
          Left = 18
          Top = 83
          Width = 111
          Height = 13
          Caption = 'Already changed setup'
        end
        object LblCurrentSetup: TLabel
          Left = 18
          Top = 54
          Width = 108
          Height = 13
          Caption = 'Standard setup (Min'#39's)'
        end
        object LblSetUp: TLabel
          Left = 18
          Top = 25
          Width = 88
          Height = 13
          Caption = 'New setup in min'#39's'
        end
        object EditNewSetup: TEdit
          Left = 153
          Top = 22
          Width = 120
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 0
          OnKeyPress = EditNewSpeedKeyPress
        end
        object EdtChangedSetup: TEdit
          Left = 153
          Top = 80
          Width = 120
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          Enabled = False
          TabOrder = 1
        end
        object EdtCurrentSetup: TEdit
          Left = 153
          Top = 51
          Width = 120
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          Enabled = False
          TabOrder = 2
        end
      end
      object GroupBoxSetUpJob: TGroupBox
        Left = 361
        Top = 122
        Width = 297
        Height = 114
        Caption = 'Setup for step/Job'
        TabOrder = 4
        object Label2: TLabel
          Left = 18
          Top = 28
          Width = 85
          Height = 13
          Caption = 'New setup (Min'#39's)'
        end
        object Label3: TLabel
          Left = 16
          Top = 57
          Width = 111
          Height = 13
          Caption = 'Already changed setup'
        end
        object eJobNewSetup: TEdit
          Left = 153
          Top = 25
          Width = 120
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 0
          OnKeyPress = EditNewSpeedKeyPress
        end
        object eJobSetupChanged: TEdit
          Left = 151
          Top = 54
          Width = 120
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          Enabled = False
          TabOrder = 1
        end
      end
      object GroupBoxSpeedStep: TGroupBox
        Left = 3
        Top = 3
        Width = 337
        Height = 113
        Caption = 'Speed for Step'
        TabOrder = 5
        object LblUN: TLabel
          Left = 3
          Top = 25
          Width = 104
          Height = 13
          Caption = 'New speed in Minutes'
        end
        object LblUM: TLabel
          Left = 112
          Top = 25
          Width = 15
          Height = 13
          Caption = 'UM'
        end
        object LblChangedSpead: TLabel
          Left = 3
          Top = 83
          Width = 113
          Height = 13
          Caption = 'Already changed speed'
        end
        object LblCurrentSpead: TLabel
          Left = 3
          Top = 54
          Width = 76
          Height = 13
          Caption = 'Standard speed'
        end
        object EditNewSpeed: TEdit
          Left = 199
          Top = 22
          Width = 118
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 0
          OnKeyPress = EditNewSpeedKeyPress
        end
        object EdtCurrentSpeed: TEdit
          Left = 160
          Top = 51
          Width = 118
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          Enabled = False
          TabOrder = 1
        end
        object EdtChangedSpeed: TEdit
          Left = 160
          Top = 80
          Width = 120
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          Enabled = False
          TabOrder = 2
        end
      end
    end
    object TabSheetWarpSpeed: TTabSheet
      Caption = 'Warp Speed/Setup'
      ImageIndex = 1
      object Label1: TLabel
        Left = 85
        Top = 22
        Width = 3
        Height = 13
      end
      object LabelWarpSpeed: TLabel
        Left = 12
        Top = 22
        Width = 104
        Height = 13
        Caption = 'New speed in Minutes'
      end
      object LabelWarpStandardSpeed: TLabel
        Left = 16
        Top = 64
        Width = 76
        Height = 13
        Caption = 'Standard speed'
      end
      object LblChangedSpeadWarp: TLabel
        Left = 246
        Top = 64
        Width = 113
        Height = 13
        Caption = 'Already changed speed'
      end
      object LblWarpUm: TLabel
        Left = 124
        Top = 22
        Width = 30
        Height = 13
        Caption = 'fill um '
      end
      object LabelWarpStandardSetup: TLabel
        Left = 17
        Top = 95
        Width = 74
        Height = 13
        Caption = 'Standard setup'
      end
      object LblChangedSetUpWarp: TLabel
        Left = 248
        Top = 95
        Width = 111
        Height = 13
        Caption = 'Already changed setup'
      end
      object LblNewSetupWarp: TLabel
        Left = 340
        Top = 22
        Width = 51
        Height = 13
        Caption = 'New setup'
      end
      object EditNewSpeedWarp: TEdit
        Left = 163
        Top = 19
        Width = 128
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 0
        OnKeyPress = EditNewSpeedKeyPress
      end
      object EditStandardSpeedWarp: TEdit
        Left = 99
        Top = 60
        Width = 131
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        Enabled = False
        TabOrder = 1
      end
      object EditChangedSpeedWarp: TEdit
        Left = 366
        Top = 60
        Width = 120
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        Enabled = False
        TabOrder = 2
      end
      object ButtonWarpOk: TcxButton
        Left = 421
        Top = 160
        Width = 65
        Height = 28
        Caption = 'OK'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 3
        OnClick = BtnWarpOkClick
      end
      object ButtonWarpAbort: TcxButton
        Left = 492
        Top = 160
        Width = 70
        Height = 28
        Caption = 'Abort'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Montserrat'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 4
        OnClick = BtnAbortClick
      end
      object BtnRmvOveridnSpeedWarp: TcxButton
        Left = 17
        Top = 126
        Width = 188
        Height = 28
        Caption = 'Back to standard speed'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 5

        OnClick = BtnWarpOkClick
      end
      object EditStandardSetUpWarp: TEdit
        Left = 98
        Top = 91
        Width = 131
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        Enabled = False
        TabOrder = 6
      end
      object EditChangedSetUpWarp: TEdit
        Left = 366
        Top = 91
        Width = 120
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        Enabled = False
        TabOrder = 7
      end
      object EditNewSetupWarp: TEdit
        Left = 415
        Top = 20
        Width = 128
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 8
        OnKeyPress = EditNewSpeedKeyPress
      end
      object BtnRmvOveridnSetupWarp: TcxButton
        Left = 17
        Top = 160
        Width = 188
        Height = 28
        Caption = 'Back to standard setup'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 9

        OnClick = BtnWarpOkClick
      end
    end
  end
end
