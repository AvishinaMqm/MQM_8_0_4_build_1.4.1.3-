object DateSelectorFrm: TDateSelectorFrm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Choose date'
  ClientHeight = 203
  ClientWidth = 175
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 162
    Width = 175
    Height = 41
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 0
    object okButton: TBitBtn
      Left = 10
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Ok'
      DoubleBuffered = True
      Kind = bkYes
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = okButtonClick
    end
    object cancelButton: TBitBtn
      Left = 91
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Cancel'
      DoubleBuffered = True
      Kind = bkCancel
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = cancelButtonClick
    end
  end
  object selectDateMonthCalendar: TMonthCalendar
    Left = 0
    Top = 0
    Width = 175
    Height = 162
    Align = alClient
    Date = 39397.590212777780000000
    MaxSelectRange = 1
    TabOrder = 1
  end
end
