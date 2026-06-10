object TBinFilter: TTBinFilter
  Left = 384
  Top = 123
  Caption = 'Edit tab'
  ClientHeight = 701
  ClientWidth = 876
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 13
  object xxx: TLabel
    Left = 251
    Top = 149
    Width = 100
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'xxxxxxxxxxxxxxxxxxxx'
  end
  object Label16: TLabel
    Left = 308
    Top = 409
    Width = 67
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Minimum case'
  end
  object Bevel4: TBevel
    Left = 370
    Top = 215
    Width = 692
    Height = 74
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object Label21: TLabel
    Left = 377
    Top = 256
    Width = 37
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'From'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label22: TLabel
    Left = 554
    Top = 257
    Width = 18
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'To'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 876
    Height = 651
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TabFiltervalues
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    ExplicitLeft = -9
    ExplicitTop = 9
    object TabFiltGen: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Indications'
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 868
        Height = 623
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 0
        object LblFieldsSet: TLabel
          Left = 516
          Top = 349
          Width = 44
          Height = 13
          Caption = 'Fields set'
        end
        object RadioGroupSched: TRadioGroup
          Left = 14
          Top = 124
          Width = 394
          Height = 50
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show scheduled'
          Columns = 3
          ItemIndex = 1
          Items.Strings = (
            'No'
            'Also'
            'Only')
          TabOrder = 0
        end
        object RadioGroupClosed: TRadioGroup
          Left = 14
          Top = 283
          Width = 394
          Height = 49
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show closed'
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'No'
            'Also'
            'Only')
          TabOrder = 1
        end
        object RadioGroupReadOnly: TRadioGroup
          Left = 429
          Top = 72
          Width = 280
          Height = 49
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show read-only jobs'
          Columns = 3
          ItemIndex = 1
          Items.Strings = (
            'No'
            'Also'
            'Only')
          TabOrder = 2
        end
        object RadioGroupGroups: TRadioGroup
          Left = 429
          Top = 21
          Width = 281
          Height = 48
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show groups'
          Columns = 3
          ItemIndex = 1
          Items.Strings = (
            'No'
            'Also'
            'Only')
          TabOrder = 3
        end
        object RadioGroupReProcess: TRadioGroup
          Left = 429
          Top = 124
          Width = 281
          Height = 50
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show only re-process'
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'No'
            'Yes')
          TabOrder = 4
        end
        object RadioGroupAlternativeWc: TRadioGroup
          Left = 14
          Top = 72
          Width = 394
          Height = 49
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Include jobs with a matching alternative W.center'
          Columns = 3
          ItemIndex = 1
          Items.Strings = (
            'No'
            'Yes')
          TabOrder = 5
        end
        object RadioGroupActivWcFromGantt: TRadioGroup
          Left = 14
          Top = 21
          Width = 394
          Height = 49
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Filter by work center shown on current Gantt '
          Columns = 3
          ItemIndex = 1
          Items.Strings = (
            'No'
            'Yes')
          TabOrder = 6
          StyleElements = []
        end
        object RGFltJobsOnGantt: TRadioGroup
          Left = 14
          Top = 230
          Width = 394
          Height = 49
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Apply filter also on scheduled jobs'
          Columns = 3
          ItemIndex = 1
          Items.Strings = (
            'No'
            'Yes')
          TabOrder = 7
        end
        object RadioGroupPriority: TRadioGroup
          Left = 429
          Top = 174
          Width = 280
          Height = 49
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show only jobs that can be scheduled'
          Columns = 3
          ItemIndex = 1
          Items.Strings = (
            'No'
            'Yes')
          TabOrder = 8
        end
        object RadioGroupProgress: TRadioGroup
          Left = 14
          Top = 174
          Width = 394
          Height = 49
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show Progressed'
          Columns = 3
          ItemIndex = 1
          Items.Strings = (
            'No'
            'Also'
            'Only')
          TabOrder = 9
        end
        object GroupBxConfirmLevel: TGroupBox
          Left = 429
          Top = 231
          Width = 282
          Height = 68
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Confirmation level'
          TabOrder = 10
        end
        object CLBConLevelsToMove: TCheckListBox
          Left = 429
          Top = 255
          Width = 282
          Height = 42
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Columns = 4
          ItemHeight = 13
          TabOrder = 11
          OnClickCheck = CLBConLevelsToMoveClickCheck
        end
        object GroupBox1: TGroupBox
          Left = 748
          Top = 307
          Width = 213
          Height = 89
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Customer date'
          TabOrder = 12
          Visible = False
          object CBCustomerDate: TCheckListBox
            Left = 4
            Top = 28
            Width = 198
            Height = 59
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Columns = 1
            ItemHeight = 13
            Items.Strings = (
              'Confirmed'
              'Calculated'
              'Requested')
            TabOrder = 0
            OnClickCheck = CLBConLevelsToMoveClickCheck
          end
        end
        object CBGroupedBy: TComboBox
          Left = 598
          Top = 345
          Width = 140
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          TabOrder = 13
          OnChange = ComboBoxWCChange
        end
        object CBOverriddenExistingTab: TCheckBox
          Left = 516
          Top = 379
          Width = 208
          Height = 22
          Caption = 'Overridden existing tab'
          TabOrder = 14
        end
        object RG_ShowDependingOnNextHandledStep: TRadioGroup
          Left = 15
          Top = 343
          Width = 476
          Height = 57
          Caption = 'Show the job depending on the next step handled '
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Always'
            'When not scheduled'
            'When scheduled')
          TabOrder = 15
        end
        object RG_ShowDependingOnPreviousHandledStep: TRadioGroup
          Left = 14
          Top = 406
          Width = 477
          Height = 55
          Caption = 'Show the job depending on the previous step handled '
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Always'
            'When not scheduled'
            'When scheduled')
          TabOrder = 16
        end
        object RG_ShowDependingOnNextHandledLinkedRequest: TRadioGroup
          Left = 15
          Top = 467
          Width = 476
          Height = 55
          Caption = 'Show the job depending on the next handled request linked '
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Always'
            'When not scheduled'
            'When scheduled')
          TabOrder = 17
        end
        object RG_ShowDependingOnPreviuosHandledLinkedRequest: TRadioGroup
          Left = 14
          Top = 528
          Width = 477
          Height = 57
          Caption = 'Show the job depending on the previous handled request linked'
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Always'
            'When not scheduled'
            'When scheduled')
          TabOrder = 18
        end
      end
    end
    object TabFiltervalues: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'General'
      ImageIndex = 4
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 868
        Height = 623
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 0
        ExplicitTop = -4
        object LblProdReq: TLabel
          Left = 28
          Top = 27
          Width = 134
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Production request'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblProdType: TLabel
          Tag = 1
          Left = 28
          Top = 71
          Width = 89
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Product type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblStepType: TLabel
          Left = 28
          Top = 116
          Width = 72
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Step type '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LabelWctr: TLabel
          Left = 28
          Top = 187
          Width = 86
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Work center'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LabelProcces: TLabel
          Left = 28
          Top = 230
          Width = 57
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Process'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LabelProdFamily: TLabel
          Left = 28
          Top = 508
          Width = 124
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Production family '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LabelMaterialFamily: TLabel
          Left = 28
          Top = 555
          Width = 100
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Material family'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LabelMinStp: TLabel
          Left = 28
          Top = 467
          Width = 134
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Min / Max quantity  '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LabelTo: TLabel
          Left = 364
          Top = 30
          Width = 18
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'To'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label20: TLabel
          Left = 367
          Top = 414
          Width = 18
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'To'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblResource: TLabel
          Left = 28
          Top = 416
          Width = 69
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Resource'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label24: TLabel
          Left = 364
          Top = 188
          Width = 18
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'To'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label25: TLabel
          Left = 364
          Top = 231
          Width = 18
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'To'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label26: TLabel
          Left = 366
          Top = 469
          Width = 18
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'To'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblStep: TLabel
          Left = 28
          Top = 277
          Width = 34
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Step'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblGrpNumber: TLabel
          Left = 28
          Top = 368
          Width = 103
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Group number'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label23: TLabel
          Left = 367
          Top = 277
          Width = 18
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'To'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label27: TLabel
          Left = 367
          Top = 368
          Width = 18
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'To'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object LblSubstep: TLabel
          Left = 28
          Top = 327
          Width = 67
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Sub Step'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label29: TLabel
          Left = 366
          Top = 325
          Width = 18
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'To'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblWrkGrpoup: TLabel
          Left = 28
          Top = 150
          Width = 137
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Work center group'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label61: TLabel
          Left = 374
          Top = 153
          Width = 36
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Plant'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label65: TLabel
          Left = 562
          Top = 154
          Width = 54
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Division'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object CheckProdReq: TCheckBox
          Left = 5
          Top = 27
          Width = 20
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 20
        end
        object EditProdReqFrom: TEdit
          Left = 204
          Top = 26
          Width = 125
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 0
        end
        object ComboBoxProdType: TComboBox
          Left = 204
          Top = 69
          Width = 63
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          TabOrder = 2
        end
        object CheckProdTyp: TCheckBox
          Tag = 1
          Left = 5
          Top = 71
          Width = 20
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 24
        end
        object CBStepType: TComboBox
          Left = 204
          Top = 113
          Width = 95
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          TabOrder = 3
        end
        object CheckStepType: TCheckBox
          Tag = 2
          Left = 5
          Top = 114
          Width = 20
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 21
        end
        object CheckWC: TCheckBox
          Tag = 3
          Left = 5
          Top = 186
          Width = 20
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 22
        end
        object ComboBoxWC: TComboBox
          Left = 204
          Top = 186
          Width = 103
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          TabOrder = 4
          OnChange = ComboBoxWCChange
        end
        object ComboBoxProcess: TComboBox
          Left = 204
          Top = 229
          Width = 139
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          TabOrder = 6
        end
        object CheckProcess: TCheckBox
          Tag = 4
          Left = 5
          Top = 229
          Width = 20
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 23
        end
        object CheckProdFamily: TCheckBox
          Tag = 5
          Left = 5
          Top = 510
          Width = 20
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 25
        end
        object EditProdFamily: TEdit
          Left = 203
          Top = 510
          Width = 147
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 18
        end
        object EditMaterialFamily: TEdit
          Left = 204
          Top = 552
          Width = 147
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 19
        end
        object CheckMatFamily: TCheckBox
          Tag = 6
          Left = 5
          Top = 554
          Width = 20
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 26
        end
        object EditMinStep: TEdit
          Left = 203
          Top = 464
          Width = 113
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 16
          OnKeyPress = CheckNumeric
        end
        object EditMaxStep: TEdit
          Left = 417
          Top = 465
          Width = 103
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 17
          OnKeyPress = CheckNumeric
        end
        object CheckQty: TCheckBox
          Tag = 8
          Left = 5
          Top = 466
          Width = 20
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 27
        end
        object EditProdReqTo: TEdit
          Left = 417
          Top = 26
          Width = 125
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 1
        end
        object ComboBoxWCTo: TComboBox
          Left = 417
          Top = 186
          Width = 104
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          TabOrder = 5
          OnChange = ComboBoxWCToChange
        end
        object ComboBoxProcessTo: TComboBox
          Left = 417
          Top = 229
          Width = 139
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = csDropDownList
          Color = 14803425
          TabOrder = 7
        end
        object CheckResource: TCheckBox
          Tag = 7
          Left = 5
          Top = 416
          Width = 20
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 28
        end
        object EdtResource: TEdit
          Left = 203
          Top = 414
          Width = 147
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 14
        end
        object EdtResourceTo: TEdit
          Left = 417
          Top = 416
          Width = 147
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 15
        end
        object CheckStep: TCheckBox
          Tag = 5
          Left = 5
          Top = 275
          Width = 20
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 29
        end
        object EdtStep: TEdit
          Left = 204
          Top = 274
          Width = 111
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 8
          OnKeyPress = EdtStepKeyPress
        end
        object EdtGrpNumber: TEdit
          Left = 204
          Top = 365
          Width = 147
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 12
          OnKeyPress = EdtStepKeyPress
        end
        object CheckGrpNumber: TCheckBox
          Tag = 6
          Left = 5
          Top = 368
          Width = 19
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 30
        end
        object EdtStepTo: TEdit
          Left = 417
          Top = 274
          Width = 111
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 9
          OnKeyPress = EdtStepKeyPress
        end
        object EdtGrpNumberTo: TEdit
          Left = 417
          Top = 365
          Width = 147
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 13
          OnKeyPress = EdtStepKeyPress
        end
        object CheckSubStep: TCheckBox
          Tag = 5
          Left = 5
          Top = 326
          Width = 20
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 31
        end
        object EdtSubstep: TEdit
          Left = 204
          Top = 322
          Width = 111
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 10
          OnKeyPress = EdtStepKeyPress
        end
        object EdtSubStepTo: TEdit
          Left = 417
          Top = 322
          Width = 111
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Color = 14803425
          TabOrder = 11
          OnKeyPress = EdtStepKeyPress
        end
        object CheckWkcGrp: TCheckBox
          Tag = 3
          Left = 5
          Top = 150
          Width = 20
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabOrder = 32
        end
        object cbWkcGrp: TComboBox
          Left = 204
          Top = 154
          Width = 138
          Height = 21
          Style = csDropDownList
          TabOrder = 33
        end
        object cbPlant: TComboBox
          Left = 417
          Top = 154
          Width = 138
          Height = 21
          Style = csDropDownList
          TabOrder = 34
        end
        object cbDivision: TComboBox
          Left = 623
          Top = 154
          Width = 138
          Height = 21
          Style = csDropDownList
          TabOrder = 35
        end
      end
    end
    object TabProperty: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Properties '
      ImageIndex = 1
    end
    object TabSheetDates: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Dates '
      ImageIndex = 2
      object ScrollBox3: TScrollBox
        Left = 0
        Top = 0
        Width = 868
        Height = 623
        Align = alClient
        TabOrder = 0
        OnMouseWheel = ScrollBox3MouseWheel
        object GroupBox2: TGroupBox
          Left = 0
          Top = 0
          Width = 847
          Height = 75
          Align = alTop
          TabOrder = 0
          StyleName = 'datatex1'
          object LabelFromProdLDT: TLabel
            Left = 9
            Top = 40
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object LabelToProdLDT: TLabel
            Left = 197
            Top = 42
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object LblFromProdHDT: TLabel
            Left = 392
            Top = 38
            Width = 45
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From  '
            StyleName = 'datatex1'
          end
          object LblProdHDT: TLabel
            Left = 470
            Top = 10
            Width = 176
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Production delivery date :'
            StyleName = 'datatex1'
          end
          object LblProdLDT: TLabel
            Left = 135
            Top = 10
            Width = 175
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Production earliest date :'
            StyleName = 'datatex1'
          end
          object LblToProdHDT: TLabel
            Left = 576
            Top = 40
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object CheckDelivDate_From: TCheckBox
            Left = 434
            Top = 36
            Width = 19
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 0
            StyleName = 'datatex1'
          end
          object CheckDelivDate_To: TCheckBox
            Left = 599
            Top = 38
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 1
            StyleName = 'datatex1'
          end
          object CheckLowDate_From: TCheckBox
            Left = 54
            Top = 37
            Width = 20
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 2
            StyleName = 'datatex1'
          end
          object CheckLowDate_To: TCheckBox
            Left = 223
            Top = 38
            Width = 20
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 3
            StyleName = 'datatex1'
          end
          object DatePickDelivDate_From: TDateTimePicker
            Left = 461
            Top = 38
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 4
            StyleName = 'datatex1'
            OnChange = DatePickDelivDate_FromChange
          end
          object DatePickDelivDate_To: TDateTimePicker
            Left = 628
            Top = 38
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 5
            StyleName = 'datatex1'
            OnChange = DatePickDelivDate_ToChange
          end
          object DatePickLowDate_From: TDateTimePicker
            Left = 81
            Top = 38
            Width = 108
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 6
            StyleName = 'datatex1'
            OnChange = DatePickLowDate_FromChange
          end
          object DatePickLowDate_To: TDateTimePicker
            Left = 251
            Top = 38
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 7
            StyleName = 'datatex1'
            OnChange = DatePickLowDate_ToChange
          end
        end
        object GroupBox3: TGroupBox
          Left = 0
          Top = 75
          Width = 847
          Height = 75
          Align = alTop
          TabOrder = 1
          object Label30: TLabel
            Left = 392
            Top = 40
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object Label32: TLabel
            Left = 571
            Top = 40
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object Label45: TLabel
            Left = 95
            Top = 7
            Width = 82
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Fixed dates'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            StyleName = 'datatex1'
          end
          object LblDaysFromPlanStart: TLabel
            Left = 500
            Top = 12
            Width = 115
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Days from today'
            StyleName = 'datatex1'
          end
          object LblFromPlannedSDT: TLabel
            Left = 9
            Top = 39
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object LblPlannedSDT: TLabel
            Left = 209
            Top = 7
            Width = 172
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Planned start date/time :'
            StyleName = 'datatex1'
          end
          object LblToPlannedSDT: TLabel
            Left = 197
            Top = 39
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object CbDaysFromTodayPlanStartfrom: TCheckBox
            Left = 434
            Top = 40
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 0
            StyleName = 'datatex1'
          end
          object CbDaysToPlanStartTo: TCheckBox
            Left = 594
            Top = 39
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 1
            StyleName = 'datatex1'
          end
          object CheckStartDate_From: TCheckBox
            Left = 54
            Top = 39
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 2
            StyleName = 'datatex1'
          end
          object CheckStartDate_To: TCheckBox
            Left = 223
            Top = 39
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 3
            StyleName = 'datatex1'
          end
          object DatePickStartDate_From: TDateTimePicker
            Left = 81
            Top = 37
            Width = 108
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 4
            StyleName = 'datatex1'
            OnChange = DatePickStartDate_FromChange
          end
          object DatePickStartDate_To: TDateTimePicker
            Left = 251
            Top = 37
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 5
            StyleName = 'datatex1'
            OnChange = DatePickStartDate_ToChange
          end
          object SpinEditDaysFromTodayPlanStartfrom: TExSpinEdit
            Left = 463
            Top = 37
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 6
            Value = 0
            OnChange = SpinEditDaysFromTodayPlanStartfromChange
          end
          object SpinEditDaysToPlanStartTo: TExSpinEdit
            Left = 623
            Top = 37
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 7
            Value = 0
            OnClick = SpinEditDaysToPlanStartToClick
          end
        end
        object GroupBox4: TGroupBox
          Left = 0
          Top = 150
          Width = 847
          Height = 75
          Align = alTop
          TabOrder = 2
          object Label31: TLabel
            Left = 215
            Top = 7
            Width = 167
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Planned end date/time :'
            StyleName = 'datatex1'
          end
          object Label33: TLabel
            Left = 9
            Top = 36
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object Label34: TLabel
            Left = 197
            Top = 35
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object Label35: TLabel
            Left = 392
            Top = 35
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object Label36: TLabel
            Left = 500
            Top = 7
            Width = 115
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Days from today'
            StyleName = 'datatex1'
          end
          object Label37: TLabel
            Left = 571
            Top = 34
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object Label46: TLabel
            Left = 95
            Top = 7
            Width = 82
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Fixed dates'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            StyleName = 'datatex1'
          end
          object CbDaysFromPlanEndTodayFrom: TCheckBox
            Left = 434
            Top = 34
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 0
            StyleName = 'datatex1'
          end
          object CbDaysToPlanEndTodayTo: TCheckBox
            Left = 594
            Top = 34
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 1
            StyleName = 'datatex1'
          end
          object CheckEndDate_From: TCheckBox
            Left = 54
            Top = 34
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 2
            StyleName = 'datatex1'
          end
          object CheckEndDate_To: TCheckBox
            Left = 225
            Top = 34
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 3
            StyleName = 'datatex1'
          end
          object DatePickEndDate_From: TDateTimePicker
            Left = 81
            Top = 31
            Width = 108
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 4
            StyleName = 'datatex1'
            OnChange = DatePickEndDate_FromChange
          end
          object DatePickEndDate_To: TDateTimePicker
            Left = 251
            Top = 31
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 5
            StyleName = 'datatex1'
            OnChange = DatePickEndDate_ToChange
          end
          object SpinEditDaysFromTodayPlanEndFrom: TExSpinEdit
            Left = 463
            Top = 31
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 6
            Value = 0
            OnChange = SpinEditDaysFromTodayPlanEndFromChange
          end
          object SpinEditDaysToPlanEndTo: TExSpinEdit
            Left = 623
            Top = 31
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 7
            Value = 0
            OnChange = SpinEditDaysToPlanEndToChange
          end
        end
        object GroupBox5: TGroupBox
          Left = 0
          Top = 225
          Width = 847
          Height = 75
          Align = alTop
          TabOrder = 3
          object LabelLatestendingDate: TLabel
            Left = 515
            Top = 7
            Width = 141
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Latest ending date :'
            StyleName = 'datatex1'
          end
          object LabelLatestEndingDate_From: TLabel
            Left = 392
            Top = 33
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object LabelLatestEndingDate_To: TLabel
            Left = 576
            Top = 33
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object LblFromLowestSDT: TLabel
            Left = 9
            Top = 35
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object LblLowestSDT: TLabel
            Left = 135
            Top = 6
            Width = 167
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Earliest start date/time :'
            StyleName = 'datatex1'
          end
          object LblToLowestSDT: TLabel
            Left = 196
            Top = 35
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object CheckLatestEndingDate_From: TCheckBox
            Left = 432
            Top = 33
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 0
            StyleName = 'datatex1'
          end
          object CheckLatestEndingDate_To: TCheckBox
            Left = 599
            Top = 32
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 1
            StyleName = 'datatex1'
          end
          object CheckLowStartDate_From: TCheckBox
            Left = 54
            Top = 34
            Width = 20
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 2
            StyleName = 'datatex1'
          end
          object CheckLowStartDate_To: TCheckBox
            Left = 224
            Top = 34
            Width = 20
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 3
            StyleName = 'datatex1'
          end
          object DatePickerLatestEndingDate_From: TDateTimePicker
            Left = 461
            Top = 30
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 4
            StyleName = 'datatex1'
            OnChange = DatePickerLatestEndingDate_FromChange
          end
          object DatePickerLatestEndingDate_To: TDateTimePicker
            Left = 628
            Top = 30
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 5
            StyleName = 'datatex1'
            OnChange = DatePickerLatestEndingDate_ToChange
          end
          object DatePickLowStartDate_From: TDateTimePicker
            Left = 81
            Top = 31
            Width = 108
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 6
            StyleName = 'datatex1'
            OnChange = DatePickLowStartDate_FromChange
          end
          object DatePickLowStartDate_To: TDateTimePicker
            Left = 251
            Top = 31
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 7
            StyleName = 'datatex1'
            OnChange = DatePickLowStartDate_ToChange
          end
        end
        object GroupBox6: TGroupBox
          Left = 0
          Top = 300
          Width = 847
          Height = 75
          Align = alTop
          TabOrder = 4
          object Label54: TLabel
            Left = 500
            Top = 4
            Width = 115
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Days from today'
            StyleName = 'datatex1'
          end
          object Label55: TLabel
            Left = 392
            Top = 32
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object Label56: TLabel
            Left = 571
            Top = 32
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object Label57: TLabel
            Left = 9
            Top = 33
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object Label58: TLabel
            Left = 95
            Top = 4
            Width = 82
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Fixed dates'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            StyleName = 'datatex1'
          end
          object Label59: TLabel
            Left = 197
            Top = 33
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object Label60: TLabel
            Left = 209
            Top = 4
            Width = 167
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Earliest start date/time :'
            StyleName = 'datatex1'
          end
          object cbDaysfromEarliest_from: TCheckBox
            Left = 432
            Top = 32
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 0
            StyleName = 'datatex1'
          end
          object seDaysfromEarliest_from: TExSpinEdit
            Left = 461
            Top = 29
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 1
            Value = 0
            OnChange = seDaysfromEarliest_fromChange
          end
          object cbDaysfromEarliest_to: TCheckBox
            Left = 594
            Top = 31
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 2
            StyleName = 'datatex1'
          end
          object seDaysfromEarliest_to: TExSpinEdit
            Left = 623
            Top = 29
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 3
            Value = 0
            OnChange = seDaysfromEarliest_toChange
          end
          object cbFixedDateEarliest_from: TCheckBox
            Left = 54
            Top = 32
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 4
            StyleName = 'datatex1'
          end
          object dtFixedDateEarliest_from: TDateTimePicker
            Left = 81
            Top = 29
            Width = 108
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 5
            StyleName = 'datatex1'
            OnChange = dtFixedDateEarliest_fromChange
          end
          object cbFixedDateEarliest_to: TCheckBox
            Left = 223
            Top = 32
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 6
            StyleName = 'datatex1'
          end
          object dtFixedDateEarliest_To: TDateTimePicker
            Left = 251
            Top = 29
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 7
            StyleName = 'datatex1'
            OnChange = dtFixedDateEarliest_ToChange
          end
        end
        object GroupBox7: TGroupBox
          Left = 0
          Top = 375
          Width = 847
          Height = 75
          Align = alTop
          TabOrder = 5
          object LblDateTimeSchedCrosses: TLabel
            Left = 258
            Top = 10
            Width = 242
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Date/Time scheduled jobs crosses'
            StyleName = 'datatex1'
          end
          object LBlScheduledJobsCrossesFrom: TLabel
            Left = 9
            Top = 41
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object LBlScheduledJobsCrossesTo: TLabel
            Left = 392
            Top = 38
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object CBScheduledJobsCrosses_From: TCheckBox
            Left = 54
            Top = 38
            Width = 20
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 0
            StyleName = 'datatex1'
          end
          object CBScheduledJobsCrosses_To: TCheckBox
            Left = 432
            Top = 38
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 1
            StyleName = 'datatex1'
          end
          object PickerDateScheduledJobsCrosses_From: TDateTimePicker
            Left = 81
            Top = 35
            Width = 108
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 2
            StyleName = 'datatex1'
            OnChange = PickerDateScheduledJobsCrosses_FromChange
          end
          object PickerDateScheduledJobsCrosses_To: TDateTimePicker
            Left = 461
            Top = 35
            Width = 106
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 3
            StyleName = 'datatex1'
            OnChange = PickerDateScheduledJobsCrosses_ToChange
          end
          object PickerTimeScheduledJobsCrosses_From: TDateTimePicker
            Left = 251
            Top = 35
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 38837.000000000000000000
            Time = 38837.000000000000000000
            Color = 14803425
            Kind = dtkTime
            TabOrder = 4
            StyleName = 'datatex1'
            OnChange = PickerDateScheduledJobsCrosses_FromChange
          end
          object PickerTimeScheduledJobsCrosses_To: TDateTimePicker
            Left = 623
            Top = 35
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 38837.000000000000000000
            Time = 38837.000000000000000000
            Color = 14803425
            Kind = dtkTime
            TabOrder = 5
            StyleName = 'datatex1'
            OnChange = PickerDateScheduledJobsCrosses_ToChange
          end
        end
        object GroupBox8: TGroupBox
          Left = 0
          Top = 450
          Width = 847
          Height = 75
          Align = alTop
          TabOrder = 6
          object LabelFromSchedulStart: TLabel
            Left = 9
            Top = 41
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object LabelToSchedulStart: TLabel
            Left = 197
            Top = 39
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object LblActualStartDateRange: TLabel
            Left = 230
            Top = 11
            Width = 162
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Actual start date range'
            StyleName = 'datatex1'
          end
          object LblDaysFromDodayTo: TLabel
            Left = 571
            Top = 36
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object LblDaysFromToday: TLabel
            Left = 500
            Top = 5
            Width = 115
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Days from today'
            StyleName = 'datatex1'
          end
          object LblDaysFromTodayFrom: TLabel
            Left = 392
            Top = 39
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object LblFixedDate: TLabel
            Left = 95
            Top = 7
            Width = 82
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Fixed dates'
            StyleName = 'datatex1'
          end
          object CbDaysFromTodayFrom: TCheckBox
            Left = 432
            Top = 37
            Width = 19
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 0
            StyleName = 'datatex1'
          end
          object CbDaysFromTodayTo: TCheckBox
            Left = 594
            Top = 37
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 1
            StyleName = 'datatex1'
          end
          object CheckSchedStartDate_From: TCheckBox
            Left = 54
            Top = 38
            Width = 20
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 2
            StyleName = 'datatex1'
          end
          object CheckSchedStartDate_To: TCheckBox
            Left = 223
            Top = 38
            Width = 20
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 3
            StyleName = 'datatex1'
          end
          object DatePickSchedStartDate_From: TDateTimePicker
            Left = 81
            Top = 34
            Width = 108
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 4
            StyleName = 'datatex1'
            OnChange = DatePickSchedStartDate_FromChange
          end
          object DatePickSchedStartDate_To: TDateTimePicker
            Left = 251
            Top = 35
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 5
            StyleName = 'datatex1'
            OnChange = DatePickSchedStartDate_ToChange
          end
          object DateTimePickerDaysFromTodayTo_time: TDateTimePicker
            Left = 680
            Top = 33
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 38837.000000000000000000
            Time = 38837.000000000000000000
            Color = 14803425
            Kind = dtkTime
            TabOrder = 6
            StyleName = 'datatex1'
          end
          object SpinEditDaysFromTodayFrom: TExSpinEdit
            Left = 461
            Top = 33
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 7
            Value = 0
            OnChange = SpinEditDaysFromTodayFromChange
          end
          object SpinEditDaysFromTodayTo: TExSpinEdit
            Left = 623
            Top = 33
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 8
            Value = 0
            OnChange = SpinEditDaysFromTodayToChange
          end
        end
        object GroupBox9: TGroupBox
          Left = 0
          Top = 600
          Width = 847
          Height = 75
          Align = alTop
          TabOrder = 7
          object Label47: TLabel
            Left = 88
            Top = 10
            Width = 82
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Fixed dates'
            StyleName = 'datatex1'
          end
          object Label48: TLabel
            Left = 230
            Top = 10
            Width = 169
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Previous end date/time :'
            StyleName = 'datatex1'
          end
          object Label49: TLabel
            Left = 500
            Top = 10
            Width = 115
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Days from today'
            StyleName = 'datatex1'
          end
          object Label50: TLabel
            Left = 571
            Top = 39
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object Label51: TLabel
            Left = 392
            Top = 38
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object Label52: TLabel
            Left = 197
            Top = 38
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object Label53: TLabel
            Left = 9
            Top = 39
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object CheckBoxPrevEndDate_From: TCheckBox
            Left = 54
            Top = 38
            Width = 20
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 0
            StyleName = 'datatex1'
          end
          object CheckBoxPrevEndDate_To: TCheckBox
            Left = 225
            Top = 36
            Width = 20
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 1
            StyleName = 'datatex1'
          end
          object CheckBoxPrevEndDaysTo: TCheckBox
            Left = 594
            Top = 36
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 2
            StyleName = 'datatex1'
          end
          object CheckBoxPrevEndFromToday: TCheckBox
            Left = 432
            Top = 36
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 3
            StyleName = 'datatex1'
          end
          object DateTimePickerPrevEndDate_From: TDateTimePicker
            Left = 81
            Top = 38
            Width = 108
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 4
            StyleName = 'datatex1'
            OnChange = DateTimePickerPrevEndDate_FromChange
          end
          object DateTimePickerPrevEndDate_To: TDateTimePicker
            Left = 251
            Top = 35
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 5
            StyleName = 'datatex1'
            OnChange = DateTimePickerPrevEndDate_ToChange
          end
          object SpinEditPrevEndDaysFromToday: TExSpinEdit
            Left = 463
            Top = 33
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 6
            Value = 0
            OnChange = SpinEditPrevEndDaysFromTodayChange
          end
          object SpinEditPrevEndDaysTo: TExSpinEdit
            Left = 623
            Top = 33
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 7
            Value = 0
            OnChange = SpinEditPrevEndDaysToChange
          end
        end
        object GroupBox10: TGroupBox
          Left = 0
          Top = 525
          Width = 847
          Height = 75
          Align = alTop
          TabOrder = 8
          object Label38: TLabel
            Left = 230
            Top = 8
            Width = 146
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Next start date/time :'
            StyleName = 'datatex1'
          end
          object Label39: TLabel
            Left = 9
            Top = 38
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object Label40: TLabel
            Left = 197
            Top = 37
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object Label41: TLabel
            Left = 392
            Top = 37
            Width = 37
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'From'
            StyleName = 'datatex1'
          end
          object Label42: TLabel
            Left = 571
            Top = 37
            Width = 18
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'To'
            StyleName = 'datatex1'
          end
          object Label43: TLabel
            Left = 500
            Top = 3
            Width = 115
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Days from today'
            StyleName = 'datatex1'
          end
          object Label44: TLabel
            Left = 88
            Top = 7
            Width = 82
            Height = 20
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            AutoSize = False
            Caption = 'Fixed dates'
            StyleName = 'datatex1'
          end
          object SpinEditNextstartDaysFromToday: TExSpinEdit
            Left = 463
            Top = 31
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 0
            Value = 0
            OnChange = SpinEditNextstartDaysFromTodayChange
          end
          object SpinEditNextstartDaysTo: TExSpinEdit
            Left = 623
            Top = 31
            Width = 49
            Height = 22
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ArrowColor = 15972184
            Color = 14803425
            MaxValue = 99
            MinValue = 0
            TabOrder = 1
            Value = 0
            OnChange = SpinEditNextstartDaysToChange
          end
          object CheckBoxNextstartDate_From: TCheckBox
            Left = 54
            Top = 36
            Width = 20
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 2
            StyleName = 'datatex1'
          end
          object CheckBoxNextstartDaysTo: TCheckBox
            Left = 594
            Top = 36
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 3
            StyleName = 'datatex1'
          end
          object CheckBoxNextstartFromToday: TCheckBox
            Left = 432
            Top = 36
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 4
            StyleName = 'datatex1'
          end
          object CheckBoxNextsttartDate_To: TCheckBox
            Left = 224
            Top = 36
            Width = 20
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 5
            StyleName = 'datatex1'
          end
          object DateTimePickerNextStartDate_From: TDateTimePicker
            Left = 81
            Top = 33
            Width = 108
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 6
            StyleName = 'datatex1'
            OnChange = DateTimePickerNextStartDate_FromChange
          end
          object DateTimePickerNextStartDate_To: TDateTimePicker
            Left = 251
            Top = 33
            Width = 105
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Date = 37886.000000000000000000
            Time = 0.680019166698912200
            Checked = False
            Color = 14803425
            DateMode = dmUpDown
            TabOrder = 7
            StyleName = 'datatex1'
            OnChange = DateTimePickerNextStartDate_ToChange
          end
        end
      end
    end
    object TabSheetWarnings: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Warnings and messages'
      ImageIndex = 3
      object LabelBeforeEarliestStart: TLabel
        Left = 455
        Top = 92
        Width = 24
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Days'
      end
      object LabelAfterLatestEnd: TLabel
        Left = 456
        Top = 137
        Width = 24
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Days'
      end
      object Label1: TLabel
        Left = 303
        Top = 50
        Width = 59
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'At least over'
      end
      object Label2: TLabel
        Left = 10
        Top = 12
        Width = 310
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 
          'Display job when at least one of the the following warnings occu' +
          'rs'
      end
      object Label4: TLabel
        Left = 10
        Top = 49
        Width = 138
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Scheduled over delivery date'
      end
      object Label3: TLabel
        Left = 10
        Top = 92
        Width = 124
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Scheduled over latest end'
      end
      object Label5: TLabel
        Left = 455
        Top = 50
        Width = 24
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Days'
      end
      object Label6: TLabel
        Left = 303
        Top = 91
        Width = 59
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'At least over'
      end
      object Label7: TLabel
        Left = 10
        Top = 135
        Width = 143
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Scheduled before earliest start'
      end
      object Label8: TLabel
        Left = 301
        Top = 135
        Width = 68
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'At least before'
      end
      object Label9: TLabel
        Left = 10
        Top = 215
        Width = 79
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Missing materials'
      end
      object Label10: TLabel
        Left = 10
        Top = 256
        Width = 132
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Missing additional resources'
      end
      object Label11: TLabel
        Left = 10
        Top = 297
        Width = 125
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Overlapping with previous '
      end
      object Label12: TLabel
        Left = 10
        Top = 337
        Width = 102
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Overlapping with next'
      end
      object Label13: TLabel
        Left = 10
        Top = 377
        Width = 166
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Compatibility case with previous job'
      end
      object Label14: TLabel
        Left = 303
        Top = 378
        Width = 67
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Minimum case'
      end
      object Label15: TLabel
        Left = 10
        Top = 416
        Width = 158
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Compatibility case to the resource'
      end
      object Label17: TLabel
        Left = 303
        Top = 417
        Width = 67
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Minimum case'
      end
      object Label18: TLabel
        Left = 10
        Top = 176
        Width = 100
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Should be scheduled'
      end
      object Label19: TLabel
        Left = 302
        Top = 177
        Width = 142
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Number of days before to alert'
      end
      object LabelMsg: TLabel
        Left = 10
        Top = 492
        Width = 67
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Job messages'
      end
      object Label28: TLabel
        Left = 10
        Top = 458
        Width = 112
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show imbalanced steps'
      end
      object CBAfterDeliveryDate: TCheckBox
        Left = 258
        Top = 46
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 0
      end
      object SpinEditAfterDeliveryDateInDays: TExSpinEdit
        Left = 401
        Top = 46
        Width = 43
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ArrowColor = 15972184
        Color = 14803425
        MaxValue = 99
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object CBbeforeEarliestStart: TCheckBox
        Left = 258
        Top = 132
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 2
      end
      object SpinEditBeforeEarliestStartIndays: TExSpinEdit
        Left = 401
        Top = 131
        Width = 43
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ArrowColor = 15972184
        Color = 14803425
        MaxValue = 99
        MinValue = 0
        TabOrder = 3
        Value = 0
      end
      object CBAfterLatestEnd: TCheckBox
        Left = 258
        Top = 89
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 4
        StyleName = 'datatex1'
      end
      object SpinEditAfterlLatestEndInDays: TExSpinEdit
        Left = 401
        Top = 87
        Width = 43
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ArrowColor = 15972184
        Color = 14803425
        MaxValue = 99
        MinValue = 0
        TabOrder = 5
        Value = 0
      end
      object CBMaterials: TCheckBox
        Left = 258
        Top = 212
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 6
      end
      object CBAdditionalres: TCheckBox
        Left = 258
        Top = 253
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 7
      end
      object CBOveridePrevious: TCheckBox
        Left = 258
        Top = 294
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 8
      end
      object CBOverideNext: TCheckBox
        Left = 258
        Top = 334
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 9
      end
      object CBCompWithPrevJob: TCheckBox
        Left = 258
        Top = 374
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 10
      end
      object SpinEditCompPrevWithJobMin: TExSpinEdit
        Left = 410
        Top = 373
        Width = 49
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ArrowColor = 15972184
        Color = 14803425
        MaxValue = 99
        MinValue = 0
        TabOrder = 11
        Value = 0
      end
      object CBCompWithRes: TCheckBox
        Left = 258
        Top = 413
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 12
      end
      object CBShouldBeSched: TCheckBox
        Left = 258
        Top = 173
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 13
      end
      object SpinEditCompWithResMin: TExSpinEdit
        Left = 410
        Top = 413
        Width = 49
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ArrowColor = 15972184
        Color = 14803425
        MaxValue = 99
        MinValue = 0
        TabOrder = 14
        Value = 0
      end
      object SpinEditShouldBeSched: TExSpinEdit
        Left = 506
        Top = 173
        Width = 43
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ArrowColor = 15972184
        Color = 14803425
        MaxValue = 99
        MinValue = 0
        TabOrder = 15
        Value = 0
      end
      object CBoxJobMsg: TCheckBox
        Left = 258
        Top = 481
        Width = 21
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 16
      end
      object CBShowImbalancedSteps: TCheckBox
        Left = 258
        Top = 450
        Width = 21
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 17
      end
      object LabelHalted: TLabel
        Left = 10
        Top = 524
        Width = 80
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Ignored Progress'
      end
      object cbIgnoredProgress: TCheckBox
        Left = 258
        Top = 519
        Width = 21
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 18
      end
    end
    object TabSheetGroup: TTabSheet
      Caption = 'Group settings'
      ImageIndex = 5
      object CBoxBAllowGroupsOneJob: TCheckBox
        Left = 13
        Top = 238
        Width = 345
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Group also one job in automatic grouping '
        TabOrder = 0
      end
      object ChkBxShowFirstGrplineInBin: TCheckBox
        Left = 13
        Top = 212
        Width = 348
        Height = 18
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show first job data when no group value'
        TabOrder = 1
      end
      object GrpBxShowGrpLinesInBib: TGroupBox
        Left = 4
        Top = 17
        Width = 317
        Height = 171
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show group lines in Bin'
        TabOrder = 2
        object RadioContGrpGroupLines: TRadioGroup
          Left = 4
          Top = 56
          Width = 309
          Height = 100
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Continuous operation'
          ItemIndex = 0
          Items.Strings = (
            'No'
            'Yes'
            'Yes, but those with the same sequence.')
          TabOrder = 0
        end
        object CBoxBatchGroupLines: TCheckBox
          Left = 20
          Top = 27
          Width = 267
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Batch operation'
          TabOrder = 1
        end
      end
    end
    object TSWarp: TTabSheet
      Caption = 'Warp'
      ImageIndex = 6
      object LblItemTypeCodeBaseWarp: TLabel
        Left = 10
        Top = 22
        Width = 151
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'Item Type base Warp'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object LblItemProductCodeBaseWarp: TLabel
        Left = 10
        Top = 51
        Width = 175
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'Product code base Warp'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object LblItemTypeCodeSecondWarp: TLabel
        Left = 10
        Top = 80
        Width = 168
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'Item Type second Warp'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object LblItemProductCodeSecondWarp: TLabel
        Left = 10
        Top = 109
        Width = 170
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        Caption = 'Prod code second Warp'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object EditItemTypeCodeBaseWarp: TEdit
        Left = 232
        Top = 21
        Width = 147
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 0
      end
      object EditProductCodeBaseWarp: TEdit
        Left = 232
        Top = 50
        Width = 371
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 1
      end
      object EditItemTypeCodeSecondWarp: TEdit
        Left = 232
        Top = 79
        Width = 147
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 2
      end
      object EditProductCodeSecondWarp: TEdit
        Left = 232
        Top = 108
        Width = 371
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        TabOrder = 3
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 651
    Width = 876
    Height = 50
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelInner = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      876
      50)
    object TabName: TLabel
      Left = 22
      Top = 15
      Width = 48
      Height = 13
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Tab name'
    end
    object BtnOk1: TBitBtn
      Left = 444
      Top = 11
      Width = 92
      Height = 28
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      Visible = False
      OnClick = BtnOk1Click
    end
    object BtnAbo1: TBitBtn
      Left = 555
      Top = 11
      Width = 93
      Height = 29
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Kind = bkAbort
      NumGlyphs = 2
      TabOrder = 2
      Visible = False
    end
    object EditTabName: TEdit
      Left = 101
      Top = 11
      Width = 158
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Color = 14803425
      TabOrder = 0
    end
    object BtnOk: TcxButton
      Left = 659
      Top = 7
      Width = 93
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 3
      OnClick = BtnOk1Click
    end
    object BtnAbo: TcxButton
      Left = 758
      Top = 7
      Width = 95
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Abort'
      TabOrder = 4
      OnClick = BtnAboClick
    end
  end
end
