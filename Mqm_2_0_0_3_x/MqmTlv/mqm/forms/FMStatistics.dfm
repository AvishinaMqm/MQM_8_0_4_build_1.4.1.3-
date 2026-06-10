object FStatistics: TFStatistics
  Left = 0
  Top = 0
  Caption = 'Statistics results'
  ClientHeight = 580
  ClientWidth = 1030
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 509
    Width = 1030
    Height = 71
    Align = alBottom
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      1030
      71)
    object LableName: TLabel
      Left = 19
      Top = 25
      Width = 47
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EditStatisticName: TEdit
      Left = 94
      Top = 24
      Width = 156
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Color = 14803425
      TabOrder = 0
      OnChange = EditStatisticNameChange
    end
    object BtnOk: TcxButton
      Left = 814
      Top = 14
      Width = 102
      Height = 33
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnOkClick
    end
    object BtnAbo: TcxButton
      Left = 922
      Top = 14
      Width = 95
      Height = 33
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 2
      OnClick = BtnAboClick
    end
  end
end
