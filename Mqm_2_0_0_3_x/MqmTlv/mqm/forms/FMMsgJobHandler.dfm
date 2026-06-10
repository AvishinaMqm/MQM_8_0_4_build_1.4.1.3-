object MsgJobHandling: TMsgJobHandling
  Left = 0
  Top = 0
  Caption = 'Job messages'
  ClientHeight = 511
  ClientWidth = 789
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 17
  object PageCntrlMsg: TPageControl
    Left = 0
    Top = 0
    Width = 789
    Height = 551
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TbMain
    Align = alTop
    TabOrder = 0
    OnChange = PageCntrlMsgChange
    ExplicitWidth = 783
    object TbMain: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Main'
      object Memo1: TMemo
        Left = 18
        Top = 26
        Width = 407
        Height = 361
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object CheckListBoxWS: TCheckListBox
        Left = 469
        Top = 26
        Width = 278
        Height = 361
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        ItemHeight = 17
        TabOrder = 1
      end
      object BitBtnSndClose: TcxButton
        Left = 18
        Top = 419
        Width = 131
        Height = 33
        Caption = 'Send and close'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 2
        OnClick = BitBtnSndCloseClick
      end
      object BitBtnAbort: TcxButton
        Left = 652
        Top = 419
        Width = 95
        Height = 33
        Caption = 'Abort'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Font.Quality = fqClearType
        ParentFont = False
        TabOrder = 3
        OnClick = BitBtnAbortClick
      end
    end
  end
end
