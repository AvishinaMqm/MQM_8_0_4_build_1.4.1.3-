object FTotalViews: TFTotalViews
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Total Views'
  ClientHeight = 526
  ClientWidth = 655
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Montserrat'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 655
    Height = 478
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 631
    ExplicitHeight = 420
    object pnWKC: TPanel
      Left = 1
      Top = 1
      Width = 653
      Height = 476
      Align = alClient
      Caption = 'pnWKC'
      TabOrder = 0
      ExplicitWidth = 629
      ExplicitHeight = 418
      object CLBWorkCenters: TCheckListBox
        Left = 1
        Top = 1
        Width = 651
        Height = 474
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ItemHeight = 14
        TabOrder = 0
        ExplicitWidth = 627
        ExplicitHeight = 416
      end
    end
    object pnGrp: TPanel
      Left = 1
      Top = 1
      Width = 653
      Height = 476
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 629
      ExplicitHeight = 418
    end
    object pnFormula: TPanel
      Left = 1
      Top = 1
      Width = 653
      Height = 476
      Align = alClient
      TabOrder = 2
      ExplicitWidth = 629
      ExplicitHeight = 418
      object sgFormula: TStringGrid
        Left = 1
        Top = 1
        Width = 651
        Height = 474
        Align = alClient
        ColCount = 6
        FixedCols = 0
        RowCount = 21
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goFixedRowClick, goFixedRowDefAlign]
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnDrawCell = sgFormulaDrawCell
        OnFixedCellClick = sgFormulaFixedCellClick
        OnKeyDown = sgFormulaKeyDown
        OnKeyPress = sgFormulaKeyPress
        OnSelectCell = sgFormulaSelectCell
        ExplicitLeft = 2
        ExplicitTop = -3
        ExplicitWidth = 627
        ExplicitHeight = 416
      end
      object cbAtt: TComboBox
        Left = 376
        Top = 176
        Width = 145
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 1
        OnChange = cbAttChange
        OnExit = cbAttExit
      end
      object cbProp: TComboBox
        Left = 376
        Top = 224
        Width = 145
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 2
        OnChange = cbPropChange
        OnExit = cbPropExit
      end
    end
  end
  object pnLow: TPanel
    Left = 0
    Top = 478
    Width = 655
    Height = 48
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 420
    ExplicitWidth = 631
    DesignSize = (
      655
      48)
    object Button1: TcxButton
      Left = 12
      Top = 16
      Width = 75
      Height = 25
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TcxButton
      Left = 569
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
      ExplicitLeft = 545
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 169
    Top = 185
    object Movedown1: TMenuItem
      Caption = 'Move down'
      OnClick = Movedown1Click
    end
  end
end
