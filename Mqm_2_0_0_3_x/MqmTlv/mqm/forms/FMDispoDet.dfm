object DispoDet: TDispoDet
  Left = 279
  Top = 261
  Caption = 'Dispo details'
  ClientHeight = 191
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 250
    Height = 191
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 320
    ExplicitHeight = 249
    object LblProdreq: TLabel
      Left = 22
      Top = 14
      Width = 124
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Production request    '
    end
    object LblWcSDispoCode: TLabel
      Left = 178
      Top = 74
      Width = 85
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Division code '
    end
    object LblDispoCode: TLabel
      Left = 26
      Top = 74
      Width = 70
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Dispo code'
    end
    object LblBatchCode: TLabel
      Left = 23
      Top = 148
      Width = 68
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Batch code'
    end
    object LblBatchRePro: TLabel
      Left = 178
      Top = 148
      Width = 108
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Batch re - process'
    end
    object STProdReq: TStaticText
      Left = 21
      Top = 34
      Width = 124
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = clInfoBk
      ParentColor = False
      TabOrder = 0
    end
    object STDiv: TStaticText
      Left = 176
      Top = 96
      Width = 118
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = clInfoBk
      ParentColor = False
      TabOrder = 1
    end
    object STDisCod: TStaticText
      Left = 22
      Top = 96
      Width = 122
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = clInfoBk
      ParentColor = False
      TabOrder = 2
    end
    object STBachCod: TStaticText
      Left = 22
      Top = 170
      Width = 128
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = clInfoBk
      ParentColor = False
      TabOrder = 3
    end
    object STBatchRePro: TStaticText
      Left = 176
      Top = 170
      Width = 121
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      BorderStyle = sbsSunken
      Color = clInfoBk
      ParentColor = False
      TabOrder = 4
    end
    object BitBtn1: TBitBtn
      Left = 204
      Top = 210
      Width = 93
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 5
    end
  end
end
