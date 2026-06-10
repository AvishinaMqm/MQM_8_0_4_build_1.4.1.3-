object FormCapResDesc: TFormCapResDesc
  Left = 233
  Top = 216
  Caption = 'Description entry'
  ClientHeight = 99
  ClientWidth = 263
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LblDescription: TLabel
    Left = 8
    Top = 8
    Width = 100
    Height = 13
    Caption = 'Enter the description:'
  end
  object EditDescription: TEdit
    Left = 8
    Top = 32
    Width = 249
    Height = 21
    Color = 14803425
    TabOrder = 0
  end
  object BitBtn11: TBitBtn
    Left = 8
    Top = 66
    Width = 75
    Height = 25
    Caption = 'OK'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      555555555555555555555555555555555555555555FF55555555555559055555
      55555555577FF5555555555599905555555555557777F5555555555599905555
      555555557777FF5555555559999905555555555777777F555555559999990555
      5555557777777FF5555557990599905555555777757777F55555790555599055
      55557775555777FF5555555555599905555555555557777F5555555555559905
      555555555555777FF5555555555559905555555555555777FF55555555555579
      05555555555555777FF5555555555557905555555555555777FF555555555555
      5990555555555555577755555555555555555555555555555555}
    NumGlyphs = 2
    TabOrder = 1
    Visible = False
  end
  object BitBtn1: TcxButton
    Left = 181
    Top = 66
    Width = 74
    Height = 25
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentFont = False
    TabOrder = 2
    OnClick = BitBtn1Click
  end
end
