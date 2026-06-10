object ReourceGroupSet: TReourceGroupSet
  Left = 0
  Top = 0
  Caption = 'Reource group setting'
  ClientHeight = 474
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 535
    Height = 474
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 31
      Top = 413
      Width = 73
      Height = 13
      Caption = 'Group counter.'
    end
    object LblResForGroup: TLabel
      Left = 31
      Top = 19
      Width = 3
      Height = 13
      Caption = ' '
    end
    object Label3: TLabel
      Left = 292
      Top = 19
      Width = 50
      Height = 13
      Caption = 'Resources'
    end
    object ListResGroup: TListBox
      Left = 28
      Top = 41
      Width = 217
      Height = 360
      ItemHeight = 13
      TabOrder = 0
      OnDblClick = ListResGroupDblClick
    end
    object ListBoxAllRes: TListBox
      Left = 289
      Top = 40
      Width = 225
      Height = 361
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 1
      OnDblClick = ListBoxAllResDblClick
    end
    object BitOK: TBitBtn
      Left = 409
      Top = 428
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      DoubleBuffered = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 2
      OnClick = BitOKClick
    end
    object BitAbort: TBitBtn
      Left = 296
      Top = 428
      Width = 75
      Height = 25
      DoubleBuffered = True
      Kind = bkAbort
      ParentDoubleBuffered = False
      TabOrder = 3
      OnClick = BitAbortClick
    end
    object EditNumberOfScheduleCounter: TEdit
      Left = 31
      Top = 432
      Width = 98
      Height = 21
      MaxLength = 5
      TabOrder = 4
      Text = '0'
      OnKeyPress = EditNumberOfScheduleCounterKeyPress
    end
    object BtnRight: TcxButton
      Left = 254
      Top = 142
      Width = 25
      Height = 25
      Caption = '>>'
      TabOrder = 5
      OnClick = BtnRightClick
    end
    object BtnLeft: TcxButton
      Left = 254
      Top = 99
      Width = 25
      Height = 25
      Caption = '<<'
      TabOrder = 6
      OnClick = BtnLeftClick
    end
  end
end
