object ResGroupDefinition: TResGroupDefinition
  Left = 0
  Top = 0
  Caption = 'Resource group definition'
  ClientHeight = 248
  ClientWidth = 572
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 24
    Top = 24
    Width = 161
    Height = 145
    ItemHeight = 13
    TabOrder = 0
  end
  object GroupBoxGrpSett: TGroupBox
    Left = 16
    Top = 8
    Width = 305
    Height = 192
    Caption = 'Group sets'
    TabOrder = 1
    object BitDeleteSet: TBitBtn
      Left = 158
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Delete group'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = BitDeleteSetClick
    end
    object BitOpenSet: TBitBtn
      Left = 158
      Top = 70
      Width = 75
      Height = 25
      Caption = 'Open group'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
    end
    object LBListOfGroupSets: TListBox
      Left = 21
      Top = 16
      Width = 121
      Height = 165
      ItemHeight = 13
      TabOrder = 2
      OnDblClick = LBListOfGroupSetsDblClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 384
    Top = 8
    Width = 169
    Height = 192
    TabOrder = 2
    object LblNewSetName: TLabel
      Left = 24
      Top = 48
      Width = 113
      Height = 13
      Caption = 'Enter new group name:'
    end
    object EditNewGroupSetName: TEdit
      Left = 24
      Top = 72
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object BtnSaveNewSet: TcxButton
      Left = 40
      Top = 112
      Width = 89
      Height = 25
      Caption = 'Create group'
      TabOrder = 1
      OnClick = BtnSaveNewSetClick
    end
  end
  object BitAbort: TBitBtn
    Left = 365
    Top = 213
    Width = 75
    Height = 25
    DoubleBuffered = True
    Kind = bkAbort
    ParentDoubleBuffered = False
    TabOrder = 3
  end
  object BitOK: TBitBtn
    Left = 478
    Top = 213
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
    TabOrder = 4
    OnClick = BitOKClick
  end
end
