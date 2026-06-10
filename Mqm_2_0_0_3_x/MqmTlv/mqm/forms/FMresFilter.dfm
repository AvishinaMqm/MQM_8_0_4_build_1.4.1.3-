object FResFilter: TFResFilter
  Left = 188
  Top = 110
  BorderIcons = []
  Caption = 'Resource filter'
  ClientHeight = 511
  ClientWidth = 788
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 16
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 788
    Height = 43
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Color = clWhite
    Constraints.MinHeight = 43
    Constraints.MinWidth = 677
    ParentBackground = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 1
      Width = 39
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
    end
    object StaticText1: TStaticText
      Left = 25
      Top = 10
      Width = 133
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = 'Work centers'
      Color = 14803425
      ParentColor = False
      TabOrder = 0
    end
    object StaticText2: TStaticText
      Left = 295
      Top = 10
      Width = 148
      Height = 22
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = 'Category'
      Color = 14803425
      ParentColor = False
      TabOrder = 1
    end
    object StaticText3: TStaticText
      Left = 534
      Top = 10
      Width = 148
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = 'Resources'
      Color = 14803425
      ParentColor = False
      TabOrder = 2
    end
    object CBWcSelectdeselectAll: TCheckBox
      Left = 165
      Top = 13
      Width = 16
      Height = 17
      Hint = 'Select / Deselect All'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 3
      OnClick = CBWcSelectdeselectAllClick
    end
    object CBResSelectdeselectAll: TCheckBox
      Left = 692
      Top = 13
      Width = 16
      Height = 17
      Hint = 'Select / Deselect All'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 4
      Visible = False
      OnClick = CBResSelectdeselectAllClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 440
    Width = 788
    Height = 71
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    Constraints.MinHeight = 50
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      788
      71)
    object LableName: TLabel
      Left = 10
      Top = 37
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
    object LabelSort: TLabel
      Left = 10
      Top = 8
      Width = 191
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'Default resource sequence'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 227
      Top = 40
      Width = 142
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'Add summarized line'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EditTabName: TEdit
      Left = 73
      Top = 36
      Width = 140
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Color = 14803425
      TabOrder = 0
      Text = 'Plan view'
    end
    object CBSort: TComboBox
      Left = 196
      Top = 7
      Width = 269
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      Color = 14803425
      TabOrder = 1
      Items.Strings = (
        'Work center'
        'Resource code'
        'Category and  resource code'
        'Work center and resource code'
        'Work center category and resource'
        'Sequence')
    end
    object BtnAbo: TcxButton
      Left = 692
      Top = 29
      Width = 95
      Height = 31
      Anchors = [akRight, akBottom]
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
    object BtnOk: TcxButton
      Left = 584
      Top = 29
      Width = 102
      Height = 31
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Font.Quality = fqClearType
      ParentFont = False
      TabOrder = 3
      OnClick = BtnOkClick
    end
    object cbGroup: TComboBox
      Left = 380
      Top = 37
      Width = 180
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      Color = 14803425
      TabOrder = 4
      OnSelect = cbGroupSelect
      Items.Strings = (
        'No'
        'By Work center group'
        'By Plant'
        'By Division')
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 43
    Width = 788
    Height = 397
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Caption = 'Panel2'
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 282
      Top = 1
      Width = 1
      Height = 395
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExplicitLeft = 393
    end
    object Splitter2: TSplitter
      Left = 519
      Top = 1
      Width = 4
      Height = 395
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExplicitLeft = 238
      ExplicitHeight = 467
    end
    object Splitter3: TSplitter
      Left = 278
      Top = 1
      Width = 4
      Height = 395
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExplicitHeight = 467
    end
    object CLBres: TCheckListBox
      Left = 523
      Top = 1
      Width = 264
      Height = 395
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Color = 14803425
      TabOrder = 0
      OnClickCheck = CLBresClickCheck
    end
    object CLBcat: TCheckListBox
      Left = 283
      Top = 1
      Width = 236
      Height = 395
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      Color = 14803425
      TabOrder = 1
      OnClickCheck = CLBcatClickCheck
    end
    object CLBwc: TCheckListBox
      Left = 1
      Top = 1
      Width = 277
      Height = 395
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      Color = 14803425
      TabOrder = 2
      OnClickCheck = CLBwcClickCheck
    end
  end
end
