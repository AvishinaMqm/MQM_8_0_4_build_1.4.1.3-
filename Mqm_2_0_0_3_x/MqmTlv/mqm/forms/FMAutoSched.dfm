object FAutoSched: TFAutoSched
  Left = 311
  Top = 161
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Automatic sequencing'
  ClientHeight = 261
  ClientWidth = 443
  Color = clBtnShadow
  TransparentColorValue = clTeal
  Constraints.MinHeight = 240
  Constraints.MinWidth = 449
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poDesktopCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 261
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelInner = bvSpace
    BevelWidth = 10
    BorderWidth = 10
    BorderStyle = bsSingle
    TabOrder = 0
    OnClick = Panel1Click
    DesignSize = (
      439
      257)
    object Bevel1: TBevel
      Left = 96
      Top = 112
      Width = 201
      Height = 27
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = bsRaised
    end
    object GObj: TGauge
      Left = 87
      Top = 106
      Width = 213
      Height = 34
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight]
      ForeColor = 15972184
      Progress = 0
    end
    object LblElapsedT: TLabel
      Left = 169
      Top = 197
      Width = 104
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'ddd'
    end
    object LblElapsed: TLabel
      Left = 64
      Top = 197
      Width = 85
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Elapsed time :'
    end
    object LblRemainT: TLabel
      Left = 368
      Top = 180
      Width = 24
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'ggg'
      Visible = False
    end
    object AutoSeqCfgName: TLabel
      Left = 110
      Top = 51
      Width = 132
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Automatic sequencing'
    end
    object LblNumTry: TLabel
      Left = 57
      Top = 75
      Width = 15
      Height = 16
      Caption = '(1)'
      Visible = False
    end
    object BtnAbo: TBitBtn
      Left = 150
      Top = 143
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Abort'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnAboClick
      ExplicitTop = 160
    end
  end
end
