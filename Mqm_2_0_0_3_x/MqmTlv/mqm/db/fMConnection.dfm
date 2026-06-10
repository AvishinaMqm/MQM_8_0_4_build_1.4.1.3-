object FConnection: TFConnection
  Left = 355
  Top = 210
  Caption = 'Settings'
  ClientHeight = 613
  ClientWidth = 841
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poDesktopCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 16
  object PanBtn: TPanel
    Left = 0
    Top = 568
    Width = 841
    Height = 45
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 0
    object BtnOk: TBitBtn
      Left = 22
      Top = 7
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnOkClick
    end
    object BtnCanc: TBitBtn
      Left = 718
      Top = 7
      Width = 92
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = BtnCancClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 271
    Width = 841
    Height = 297
    Align = alClient
    TabOrder = 1
    object RadioGroupLocalConnection: TRadioGroup
      Left = 8
      Top = 8
      Width = 377
      Height = 45
      Caption = 'Local database'
      Columns = 3
      Ctl3D = True
      ItemIndex = 0
      Items.Strings = (
        'Db2'
        'Oracle'
        'Interbase')
      ParentCtl3D = False
      TabOrder = 0
      OnClick = RadioGroupLocalConnectionClick
    end
    object BtnCheckConnectionLocal: TcxButton
      Left = 409
      Top = 18
      Width = 155
      Height = 32
      Caption = 'Check connection'
      TabOrder = 1
      OnClick = BtnCheckConnectionLocalClick
    end
    object ServrIBname: TEdit
      Left = 161
      Top = 265
      Width = 116
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 2
    end
    object StaticTextIBServerIp: TStaticText
      Left = 13
      Top = 268
      Width = 118
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Interbase Server IP'
      TabOrder = 3
    end
    object EditPathIP2: TEdit
      Left = 278
      Top = 265
      Width = 16
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 4
      Text = '\'
    end
    object EditPathIP1: TEdit
      Left = 141
      Top = 265
      Width = 19
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 5
      Text = '\\'
    end
    object Panel6: TPanel
      Left = 8
      Top = 56
      Width = 312
      Height = 202
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BorderWidth = 3
      TabOrder = 6
      object GroupBox1: TGroupBox
        Left = 14
        Top = 17
        Width = 295
        Height = 199
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'DB2 Connection parameters'
        TabOrder = 0
        object StaticText5: TStaticText
          Left = 15
          Top = 36
          Width = 101
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Database name'
          TabOrder = 0
        end
        object StaticText6: TStaticText
          Left = 15
          Top = 67
          Width = 59
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Server IP'
          TabOrder = 1
        end
        object EditNOWDB2DataSourceLocal: TEdit
          Left = 130
          Top = 31
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 2
        end
        object EditNOWDB2SrvIPLocal: TEdit
          Left = 130
          Top = 62
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 3
        end
        object StaticText8: TStaticText
          Left = 15
          Top = 126
          Width = 67
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Username'
          TabOrder = 4
        end
        object StaticText13: TStaticText
          Left = 15
          Top = 160
          Width = 64
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Password'
          TabOrder = 5
        end
        object EditNOWDB2UserNameLocal: TEdit
          Left = 130
          Top = 124
          Width = 150
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 6
        end
        object EditNOWDB2PasswordLocal: TEdit
          Left = 129
          Top = 156
          Width = 150
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          PasswordChar = '*'
          TabOrder = 7
        end
        object EditPortLocal: TEdit
          Left = 129
          Top = 93
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 8
        end
        object StaticText14: TStaticText
          Left = 14
          Top = 96
          Width = 28
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Port'
          TabOrder = 9
        end
      end
    end
    object Panel7: TPanel
      Left = 327
      Top = 56
      Width = 277
      Height = 202
      TabOrder = 7
      object GroupBox3: TGroupBox
        Left = 9
        Top = 19
        Width = 260
        Height = 166
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Oracle connection parameters'
        TabOrder = 0
        object EditNOWOracleUserNameLocal: TEdit
          Left = 96
          Top = 62
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 0
        end
        object EditNOWOraclePasswordLocal: TEdit
          Left = 96
          Top = 93
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          PasswordChar = '*'
          TabOrder = 1
        end
        object StaticText15: TStaticText
          Left = 15
          Top = 67
          Width = 67
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Username'
          TabOrder = 2
        end
        object StaticText16: TStaticText
          Left = 15
          Top = 97
          Width = 64
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Password'
          TabOrder = 3
        end
        object StaticText17: TStaticText
          Left = 15
          Top = 36
          Width = 69
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'TNS name'
          TabOrder = 4
        end
        object EditNOWOracleTNSNameLocal: TEdit
          Left = 96
          Top = 31
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 5
        end
        object StaticText18: TStaticText
          Left = 16
          Top = 142
          Width = 22
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'IP :'
          TabOrder = 6
          Visible = False
        end
        object EditOracleIPLocal: TEdit
          Left = 96
          Top = 138
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 7
          Visible = False
        end
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 841
    Height = 271
    Align = alTop
    TabOrder = 2
    object RadioGroupHostDatabase: TRadioGroup
      Left = 8
      Top = 8
      Width = 377
      Height = 43
      Caption = 'Host database'
      Columns = 3
      Ctl3D = True
      ItemIndex = 0
      Items.Strings = (
        'Db2'
        'Oracle'
        'ODBC')
      ParentCtl3D = False
      TabOrder = 0
    end
    object BtnCheckConnection: TcxButton
      Left = 409
      Top = 19
      Width = 155
      Height = 32
      Caption = 'Check connection'
      TabOrder = 1
      OnClick = BtnCheckConnectionHostClick
    end
    object Panel5: TPanel
      Left = 1
      Top = 56
      Width = 317
      Height = 207
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BorderWidth = 3
      TabOrder = 2
      object GBDb2ConnectionHost: TGroupBox
        Left = 10
        Top = 10
        Width = 295
        Height = 192
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'DB2 Connection parameters'
        TabOrder = 0
        object StaticText11: TStaticText
          Left = 15
          Top = 36
          Width = 101
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Database name'
          TabOrder = 0
        end
        object StaticText12: TStaticText
          Left = 15
          Top = 67
          Width = 59
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Server IP'
          TabOrder = 1
        end
        object EditNOWDB2DataSourceHost: TEdit
          Left = 130
          Top = 31
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 2
        end
        object EditNOWDB2SrvIPHost: TEdit
          Left = 130
          Top = 62
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 3
        end
        object StaticText9: TStaticText
          Left = 15
          Top = 126
          Width = 67
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Username'
          TabOrder = 4
        end
        object StaticText10: TStaticText
          Left = 15
          Top = 160
          Width = 64
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Password'
          TabOrder = 5
        end
        object EditNOWDB2UserName: TEdit
          Left = 130
          Top = 401
          Width = 150
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 6
        end
        object EditNOWDB2PasswordHost: TEdit
          Left = 129
          Top = 156
          Width = 150
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          PasswordChar = '*'
          TabOrder = 7
        end
        object EditPortHost: TEdit
          Left = 129
          Top = 93
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 8
        end
        object StaticTextPort: TStaticText
          Left = 14
          Top = 96
          Width = 28
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Port'
          TabOrder = 9
        end
        object EditNOWDB2UserNameHost: TEdit
          Left = 129
          Top = 125
          Width = 150
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 10
        end
      end
    end
    object Panel2: TPanel
      Left = 320
      Top = 56
      Width = 281
      Height = 207
      TabOrder = 3
      object GBOracleConnectionHost: TGroupBox
        Left = 8
        Top = 10
        Width = 260
        Height = 166
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Oracle connection parameters'
        TabOrder = 0
        object EditNOWOracleUserNameHost: TEdit
          Left = 96
          Top = 62
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 0
        end
        object EditNOWOraclePasswordHost: TEdit
          Left = 96
          Top = 93
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          PasswordChar = '*'
          TabOrder = 1
        end
        object StaticText3: TStaticText
          Left = 15
          Top = 67
          Width = 67
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Username'
          TabOrder = 2
        end
        object StaticText4: TStaticText
          Left = 15
          Top = 97
          Width = 64
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Password'
          TabOrder = 3
        end
        object StaticText7: TStaticText
          Left = 15
          Top = 36
          Width = 69
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'TNS name'
          TabOrder = 4
        end
        object EditNOWOracleTNSNameHost: TEdit
          Left = 96
          Top = 31
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 5
        end
        object StaticTextIpOra: TStaticText
          Left = 16
          Top = 142
          Width = 22
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'IP :'
          TabOrder = 6
          Visible = False
        end
        object EditOracleIPHost: TEdit
          Left = 96
          Top = 138
          Width = 149
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 7
          Visible = False
        end
      end
    end
    object ODBCConnectionHost: TPanel
      Left = 604
      Top = 56
      Width = 230
      Height = 206
      TabOrder = 4
      object GBOdbc: TGroupBox
        Left = 10
        Top = 13
        Width = 199
        Height = 94
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'ODBC connection selection'
        TabOrder = 0
        object ConnectionComboBox: TComboBox
          Left = 14
          Top = 27
          Width = 155
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          TabOrder = 0
        end
        object CBOdbcDriver: TComboBox
          Left = 15
          Top = 59
          Width = 138
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          TabOrder = 1
          Items.Strings = (
            ''
            'Db2'
            'Oracle'
            'As-400'
            'Db2 on As-400')
        end
      end
      object EditNOWODBCUserName: TEdit
        Left = 98
        Top = 127
        Width = 110
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 1
      end
      object EditNOWODBCPassword: TEdit
        Left = 98
        Top = 164
        Width = 110
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        PasswordChar = '*'
        TabOrder = 2
      end
      object StaticText1: TStaticText
        Left = 17
        Top = 129
        Width = 67
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Username'
        TabOrder = 3
      end
      object StaticText2: TStaticText
        Left = 17
        Top = 165
        Width = 64
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Password'
        TabOrder = 4
      end
    end
  end
end
