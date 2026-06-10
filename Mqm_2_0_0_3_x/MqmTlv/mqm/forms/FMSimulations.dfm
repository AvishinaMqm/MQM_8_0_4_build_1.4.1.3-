object FSimulations: TFSimulations
  Left = 73
  Top = 187
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Simulations'
  ClientHeight = 189
  ClientWidth = 692
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    692
    189)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 692
    Height = 137
    Align = alTop
    Shape = bsFrame
    Style = bsRaised
  end
  object LblSimSaved: TLabel
    Left = 10
    Top = 8
    Width = 85
    Height = 13
    Caption = 'Saved simulations'
  end
  object LblCode: TLabel
    Left = 167
    Top = 43
    Width = 25
    Height = 13
    Caption = 'Code'
  end
  object LblDescr: TLabel
    Left = 167
    Top = 91
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object EdtSimCode: TEdit
    Left = 167
    Top = 60
    Width = 129
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 10
    TabOrder = 0
    OnChange = EdtSimCodeChange
    OnKeyPress = EdtSimCodeKeyPress
  end
  object EdtSimDesc: TEdit
    Left = 167
    Top = 108
    Width = 409
    Height = 21
    MaxLength = 50
    TabOrder = 1
  end
  object BtnDelete: TcxButton
    Left = 596
    Top = 104
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Delete'
    TabOrder = 3
    OnClick = BtnDeleteClick
  end
  object LBSimsSaved: TListBox
    Left = 10
    Top = 24
    Width = 145
    Height = 105
    ItemHeight = 13
    TabOrder = 4
    OnClick = LBSimsSavedClick
  end
  object btnSave: TcxButton
    Left = 596
    Top = 64
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Save'
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object btnOpen: TcxButton
    Left = 596
    Top = 24
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Open'
    TabOrder = 5
    OnClick = btnOpenClick
  end
  object btnClose: TBitBtn
    Left = 600
    Top = 152
    Width = 75
    Height = 25
    DoubleBuffered = True
    Kind = bkClose
    ParentDoubleBuffered = False
    TabOrder = 6
    Visible = False
  end
end
