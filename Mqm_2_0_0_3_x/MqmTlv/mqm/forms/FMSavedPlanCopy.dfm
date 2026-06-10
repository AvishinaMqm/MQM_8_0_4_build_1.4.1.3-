object SavedPlanCopy: TSavedPlanCopy
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Save steps daily buckets'
  ClientHeight = 189
  ClientWidth = 615
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Montserrat'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    615
    189)
  TextHeight = 14
  object Label1: TLabel
    Left = 6
    Top = 2
    Width = 72
    Height = 14
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    AutoSize = False
    Caption = 'From date:'
  end
  object LableName: TLabel
    Left = 6
    Top = 117
    Width = 78
    Height = 11
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Saved name'
    ExplicitTop = 70
  end
  object Label2: TLabel
    Left = 7
    Top = 50
    Width = 71
    Height = 14
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    AutoSize = False
    Caption = 'To date:'
  end
  object Label3: TLabel
    Left = 165
    Top = 117
    Width = 78
    Height = 11
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Description'
  end
  object Panel1: TPanel
    Left = 0
    Top = 158
    Width = 615
    Height = 31
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alBottom
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      615
      31)
    object BtnOk: TcxButton
      Left = 478
      Top = 5
      Width = 66
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Save'
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnAbo: TcxButton
      Left = 547
      Top = 5
      Width = 61
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Abort'
      TabOrder = 1
      OnClick = BtnAboClick
    end
  end
  object dtFrom: TDateTimePicker
    Left = 6
    Top = 19
    Width = 155
    Height = 22
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Date = 45503.000000000000000000
    Time = 0.470459942131128600
    Kind = dtkDateTime
    TabOrder = 1
    OnChange = dtFromChange
  end
  object EditName: TEdit
    Left = 6
    Top = 133
    Width = 120
    Height = 22
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akBottom]
    Color = 14803425
    MaxLength = 50
    TabOrder = 2
  end
  object dtTo: TDateTimePicker
    Left = 7
    Top = 68
    Width = 154
    Height = 22
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Date = 45503.000000000000000000
    Time = 0.470459942131128600
    Kind = dtkDateTime
    TabOrder = 3
  end
  object sgMain: TStringGrid
    Left = 165
    Top = 2
    Width = 428
    Height = 100
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ColCount = 4
    DefaultColWidth = 56
    DefaultRowHeight = 12
    FixedCols = 0
    RowCount = 6
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goFixedRowDefAlign]
    PopupMenu = PopupMenu1
    TabOrder = 4
  end
  object eDesc: TEdit
    Left = 165
    Top = 133
    Width = 284
    Height = 22
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akBottom]
    Color = 14803425
    MaxLength = 100
    TabOrder = 5
  end
  object PopupMenu1: TPopupMenu
    Left = 248
    Top = 56
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Button1Click
    end
  end
end
