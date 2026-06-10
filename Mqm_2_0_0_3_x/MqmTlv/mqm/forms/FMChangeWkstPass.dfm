object FChgWkstPass: TFChgWkstPass
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Change workstation password'
  ClientHeight = 169
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 25
    Width = 101
    Height = 15
    AutoSize = False
    Caption = 'Old password:'
  end
  object Label2: TLabel
    Left = 16
    Top = 52
    Width = 109
    Height = 15
    AutoSize = False
    Caption = 'New password:'
  end
  object Label3: TLabel
    Left = 16
    Top = 82
    Width = 120
    Height = 15
    AutoSize = False
    Caption = 'Repeat password:'
  end
  object Button1: TcxButton
    Left = 164
    Top = 120
    Width = 121
    Height = 33
    Caption = 'Change'
    TabOrder = 0
    OnClick = Button1Click
  end
  object eOld: TEdit
    Left = 164
    Top = 21
    Width = 121
    Height = 23
    PasswordChar = '*'
    TabOrder = 1
  end
  object eNew: TEdit
    Left = 164
    Top = 50
    Width = 121
    Height = 23
    PasswordChar = '*'
    TabOrder = 2
  end
  object eNew2: TEdit
    Left = 164
    Top = 79
    Width = 121
    Height = 23
    PasswordChar = '*'
    TabOrder = 3
  end
end
