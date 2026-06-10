object GrpSplit: TGrpSplit
  Left = 0
  Top = 0
  Caption = 'New groups created '
  ClientHeight = 291
  ClientWidth = 616
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
  object PgcGrp: TPageControl
    Left = 0
    Top = 0
    Width = 616
    Height = 233
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 0
  end
  object PanOp: TPanel
    Left = 0
    Top = 233
    Width = 616
    Height = 58
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object BtnOk: TcxButton
      Left = 392
      Top = 12
      Width = 91
      Height = 33
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnCanc: TcxButton
      Left = 508
      Top = 12
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
      OnClick = BtnCancClick
    end
  end
end
