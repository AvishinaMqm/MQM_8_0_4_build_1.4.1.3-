object FBarConfig: TFBarConfig
  Left = 128
  Top = 104
  BorderIcons = [biSystemMenu]
  Caption = 'Configuration of bar text '
  ClientHeight = 571
  ClientWidth = 950
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Montserrat'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 16
  object LblSetName: TLabel
    Left = 9
    Top = 0
    Width = 926
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taCenter
    AutoSize = False
    Caption = 'asd'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 950
    Height = 59
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Shape = bsFrame
    ExplicitTop = 40
    ExplicitWidth = 944
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 59
    Width = 950
    Height = 471
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Caption = 'Set fields'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Montserrat'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 737
      Top = 18
      Height = 451
      Align = alRight
      ExplicitLeft = 688
      ExplicitTop = 176
      ExplicitHeight = 100
    end
    object GroupBox2: TGroupBox
      Left = 740
      Top = 18
      Width = 208
      Height = 451
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      Caption = 'Apply set to the following'
      TabOrder = 0
      object CLBWorkCenters: TCheckListBox
        Left = 2
        Top = 18
        Width = 204
        Height = 431
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 0
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 18
      Width = 735
      Height = 451
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Label1: TLabel
        Left = 585
        Top = 6
        Width = 72
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Sequence'
      end
      object Label2: TLabel
        Left = 202
        Top = 6
        Width = 71
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Heading'
      end
      object Label3: TLabel
        Left = 344
        Top = 6
        Width = 73
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Position'
      end
      object Label4: TLabel
        Left = 507
        Top = 6
        Width = 38
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Line'
      end
      object Labell: TLabel
        Left = 58
        Top = 6
        Width = 30
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taCenter
        AutoSize = False
        Caption = 'Field'
      end
      object SB_Frames: TScrollBox
        Left = 1
        Top = 42
        Width = 733
        Height = 408
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Montserrat'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnMouseWheel = SB_FramesMouseWheel
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 530
    Width = 950
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    OnClick = Panel1Click
    DesignSize = (
      950
      41)
    object BitAbort: TcxButton
      Left = 827
      Top = 7
      Width = 95
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 0
      OnClick = BitCloseClick
    end
    object BitOK: TcxButton
      Left = 728
      Top = 7
      Width = 93
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 1
      OnClick = BtnSaveChangesClick
    end
  end
end
