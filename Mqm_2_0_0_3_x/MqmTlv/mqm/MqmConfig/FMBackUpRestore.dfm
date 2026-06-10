object BackUpRestore: TBackUpRestore
  Left = 276
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Backup/Restore'
  ClientHeight = 249
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 249
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object cbDatabase: TRadioGroup
      Left = 10
      Top = 10
      Width = 424
      Height = 124
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Database'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Items.Strings = (
        'Backup '
        'Restore')
      ParentFont = False
      TabOrder = 0
      OnClick = cbDatabaseClick
    end
    object btExecute: TBitBtn
      Left = 463
      Top = 15
      Width = 147
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Backup/Restore'
      Enabled = False
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003333330B7FFF
        FFB0333333777F3333773333330B7FFFFFB0333333777F3333773333330B7FFF
        FFB0333333777F3333773333330B7FFFFFB03FFFFF777FFFFF77000000000077
        007077777777777777770FFFFFFFF00077B07F33333337FFFF770FFFFFFFF000
        7BB07F3FF3FFF77FF7770F00F000F00090077F77377737777F770FFFFFFFF039
        99337F3FFFF3F7F777FF0F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btExecuteClick
    end
    object btClose: TBitBtn
      Left = 463
      Top = 49
      Width = 147
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 2
    end
    object GBWokingDir: TGroupBox
      Left = 10
      Top = 134
      Width = 602
      Height = 99
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Working file'
      TabOrder = 3
      object SBOpen: TSpeedButton
        Left = 561
        Top = 25
        Width = 29
        Height = 27
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Enabled = False
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          55555555FFFFFFFFFF55555000000000055555577777777775F55500B8B8B8B8
          B05555775F555555575F550F0B8B8B8B8B05557F75F555555575550BF0B8B8B8
          B8B0557F575FFFFFFFF7550FBF0000000000557F557777777777500BFBFBFBFB
          0555577F555555557F550B0FBFBFBFBF05557F7F555555FF75550F0BFBFBF000
          55557F75F555577755550BF0BFBF0B0555557F575FFF757F55550FB700007F05
          55557F557777557F55550BFBFBFBFB0555557F555555557F55550FBFBFBFBF05
          55557FFFFFFFFF7555550000000000555555777777777755555550FBFB055555
          5555575FFF755555555557000075555555555577775555555555}
        NumGlyphs = 2
        OnClick = SBOpenClick
      end
      object SBSave: TSpeedButton
        Left = 561
        Top = 59
        Width = 29
        Height = 27
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Enabled = False
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          55555555FFFFFFFFFF55555000000000055555577777777775F55500B8B8B8B8
          B05555775F555555575F550F0B8B8B8B8B05557F75F555555575550BF0B8B8B8
          B8B0557F575FFFFFFFF7550FBF0000000000557F557777777777500BFBFBFBFB
          0555577F555555557F550B0FBFBFBFBF05557F7F555555FF75550F0BFBFBF000
          55557F75F555577755550BF0BFBF0B0555557F575FFF757F55550FB700007F05
          55557F557777557F55550BFBFBFBFB0555557F555555557F55550FBFBFBFBF05
          55557FFFFFFFFF7555550000000000555555777777777755555550FBFB055555
          5555575FFF755555555557000075555555555577775555555555}
        NumGlyphs = 2
        OnClick = SBSaveClick
      end
      object LEOpenFile: TLabeledEdit
        Left = 118
        Top = 25
        Width = 440
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        EditLabel.Width = 53
        EditLabel.Height = 16
        EditLabel.Margins.Left = 4
        EditLabel.Margins.Top = 4
        EditLabel.Margins.Right = 4
        EditLabel.Margins.Bottom = 4
        EditLabel.Caption = 'Open file'
        Enabled = False
        LabelPosition = lpLeft
        LabelSpacing = 25
        TabOrder = 0
      end
      object LESaveFile: TLabeledEdit
        Left = 118
        Top = 59
        Width = 440
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        EditLabel.Width = 52
        EditLabel.Height = 16
        EditLabel.Margins.Left = 4
        EditLabel.Margins.Top = 4
        EditLabel.Margins.Right = 4
        EditLabel.Margins.Bottom = 4
        EditLabel.Caption = 'Save file'
        Enabled = False
        LabelPosition = lpLeft
        LabelSpacing = 25
        TabOrder = 1
        OnChange = LESaveFileChange
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 436
    Top = 68
  end
  object OpenDialog1: TOpenDialog
    Left = 468
    Top = 68
  end
end
