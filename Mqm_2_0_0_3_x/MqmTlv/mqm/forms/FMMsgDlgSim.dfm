object FMsgDlgSim: TFMsgDlgSim
  Left = 216
  Top = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Simulation - Confirm Plan'
  ClientHeight = 239
  ClientWidth = 434
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblWarning: TLabel
    Left = 0
    Top = 16
    Width = 425
    Height = 33
    Alignment = taCenter
    AutoSize = False
    Caption = 'Warning!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblRow1: TLabel
    Left = 0
    Top = 56
    Width = 425
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'With this operation the main plan will be lost.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblRow2: TLabel
    Left = 0
    Top = 72
    Width = 425
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'The active simulation override all the data.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblRow3: TLabel
    Left = 8
    Top = 104
    Width = 425
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'Select your choice'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 0
    Top = 128
    Width = 433
    Height = 9
    Shape = bsTopLine
  end
  object bbtnOvrAll: TcxButton
    Left = 8
    Top = 150
    Width = 281
    Height = 33
    Caption = 'Override and delete all simulations'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 0
    OnClick = bbtnOvrAllClick
  end
  object btnAbort: TcxButton
    Left = 322
    Top = 192
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
    OnClick = btnAbortClick
  end
  object bbtnOvrDelSim: TcxButton
    Left = 8
    Top = 192
    Width = 281
    Height = 33
    Caption = 'Override and delete current Simulation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 2
    OnClick = bbtnOvrDelSimClick
  end
end
