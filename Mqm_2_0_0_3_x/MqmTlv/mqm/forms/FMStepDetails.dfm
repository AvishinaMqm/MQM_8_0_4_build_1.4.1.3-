object FStepDetails: TFStepDetails
  Left = 145
  Top = 152
  Caption = 'Job details'
  ClientHeight = 622
  ClientWidth = 907
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
  TextHeight = 16
  object PGStepDetails: TPageControl
    Left = 0
    Top = 41
    Width = 907
    Height = 581
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TbConnectedReq
    Align = alClient
    MultiLine = True
    TabOrder = 1
    object TBHeader: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Header'
      object LblDelDate: TLabel
        Left = 20
        Top = 14
        Width = 117
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Delivery date'
      end
      object LblProdType: TLabel
        Left = 15
        Top = 54
        Width = 117
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Product type'
      end
      object LblUmdesc: TLabel
        Left = 20
        Top = 95
        Width = 117
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Um'
      end
      object LblProductFam: TLabel
        Left = 15
        Top = 137
        Width = 117
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Product family'
      end
      object LblMaterialsFam: TLabel
        Left = 15
        Top = 183
        Width = 117
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Materials family'
      end
      object LblLowestDate: TLabel
        Left = 15
        Top = 224
        Width = 117
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Earliest date'
      end
      object LblProdLine: TLabel
        Left = 15
        Top = 266
        Width = 117
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Production line'
      end
      object STDeldate: TStaticText
        Left = 140
        Top = 14
        Width = 190
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STDeldate'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
      end
      object STProdType: TStaticText
        Left = 140
        Top = 54
        Width = 179
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STProdType'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
      end
      object STUmDesc: TStaticText
        Left = 140
        Top = 95
        Width = 202
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STUmDesc'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
      end
      object STProdFamily: TStaticText
        Left = 140
        Top = 138
        Width = 526
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STProdFamily'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
      end
      object STMaterialsFam: TStaticText
        Left = 140
        Top = 183
        Width = 191
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STMaterialsFam'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
      end
      object STLowestDate: TStaticText
        Left = 140
        Top = 226
        Width = 169
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STLowestDate'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 5
      end
      object STProdLine: TStaticText
        Left = 140
        Top = 264
        Width = 157
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STProdLine'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
      end
    end
    object TbGenInfo: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'General'
      ImageIndex = 4
      object StringGridGen: TStringGrid
        Left = 0
        Top = 0
        Width = 899
        Height = 529
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 1
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        OnDrawCell = StringGridGenDrawCell
        ColWidths = (
          665)
        RowHeights = (
          24)
      end
    end
    object TBProductsInfo: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Products'
      ImageIndex = 1
      object StringGridProd: TStringGrid
        Left = 0
        Top = 0
        Width = 899
        Height = 529
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 10
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing]
        TabOrder = 0
        ColWidths = (
          92
          86
          129
          238
          165
          121
          85
          65
          88
          64)
        RowHeights = (
          24
          24)
      end
    end
    object TBmaterials: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Materials'
      ImageIndex = 2
      object StringGridMat: TStringGrid
        Left = 0
        Top = 0
        Width = 899
        Height = 529
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 19
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing]
        TabOrder = 0
        ColWidths = (
          104
          91
          120
          185
          118
          121
          83
          82
          76
          46
          64
          64
          64
          64
          64
          64
          64
          64
          64)
        RowHeights = (
          24
          24)
      end
    end
    object TBInstructionInfo: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Instruction'
      ImageIndex = 3
      object StringGridInstr: TStringGrid
        Left = 0
        Top = 0
        Width = 899
        Height = 529
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 1
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        OnDrawCell = StringGridInstrDrawCell
        ColWidths = (
          665)
        RowHeights = (
          24)
      end
    end
    object TbCommentsInfo: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Comments'
      ImageIndex = 5
      object StringGridComment: TStringGrid
        Left = 0
        Top = 0
        Width = 899
        Height = 529
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 1
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        OnDrawCell = StringGridCommentDrawCell
        ColWidths = (
          665)
        RowHeights = (
          24)
      end
    end
    object TbOthersInfo: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Others'
      ImageIndex = 6
      object StringGridOther: TStringGrid
        Left = 0
        Top = 0
        Width = 899
        Height = 529
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 1
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        OnDrawCell = StringGridOtherDrawCell
        OnSelectCell = StringGridOtherSelectCell
        ColWidths = (
          665)
        RowHeights = (
          24)
      end
    end
    object TbConnectedReq: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Connected request'
      ImageIndex = 7
      object SGConnectedReq: TStringGrid
        Left = 0
        Top = 0
        Width = 899
        Height = 529
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 16
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        ColWidths = (
          153
          151
          126
          119
          126
          119
          110
          116
          124
          128
          115
          121
          123
          120
          117
          130)
        RowHeights = (
          24
          24)
      end
    end
    object TbSchedDetails: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Schedule details'
      ImageIndex = 8
      object LblGroupNumber: TLabel
        Left = 414
        Top = 68
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Group number'
      end
      object LlbScheduleType: TLabel
        Left = 14
        Top = 70
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Schedule type'
      end
      object LblWorkStation: TLabel
        Left = 414
        Top = 9
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Work station'
      end
      object LblWorkCenterDesc: TLabel
        Left = 413
        Top = 41
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Work center'
      end
      object LblWCProcessDesc: TLabel
        Left = 14
        Top = 100
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'W.C. process'
      end
      object LblResDesc: TLabel
        Left = 14
        Top = 129
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Resource'
      end
      object LblResSubLine: TLabel
        Left = 14
        Top = 159
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Resource sub line'
      end
      object LblResComp: TLabel
        Left = 414
        Top = 156
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Resource components'
      end
      object LblSetupTime: TLabel
        Left = 14
        Top = 255
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Setup time'
      end
      object LblQuantity: TLabel
        Left = 14
        Top = 218
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Quantity'
      end
      object LblExecTime: TLabel
        Left = 14
        Top = 296
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Execution time'
      end
      object LblSchedStart: TLabel
        Left = 14
        Top = 11
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Scheduled start'
      end
      object LblSchedEnd: TLabel
        Left = 14
        Top = 41
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Scheduled end'
      end
      object LblProgStart: TLabel
        Left = 14
        Top = 330
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Progress start'
      end
      object LblProgEnd: TLabel
        Left = 412
        Top = 330
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Progress end'
      end
      object LblQuantityProg: TLabel
        Left = 414
        Top = 218
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Quantity progressed'
      end
      object LabelActualTime: TLabel
        Left = 414
        Top = 296
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Actual Time'
      end
      object LblComment: TLabel
        Left = 14
        Top = 397
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Comment'
      end
      object LblPrevConnSubStep: TLabel
        Left = 14
        Top = 188
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Previous conn. sub-step'
      end
      object LblPrevConnReProcess: TLabel
        Left = 413
        Top = 188
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Previous conn. re-process'
      end
      object LblErrorInfo: TLabel
        Left = 15
        Top = 436
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Warnings information'
      end
      object LblSetupTimeWithOutMaterials: TLabel
        Left = 412
        Top = 255
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Setup time without materials'
      end
      object LabelActualStart: TLabel
        Left = 15
        Top = 368
        Width = 184
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Actual Start'
      end
      object LabelActualEnd: TLabel
        Left = 412
        Top = 368
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Actual End'
      end
      object LblLearningCurveCode: TLabel
        Left = 414
        Top = 97
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Learning Curve Code'
      end
      object CurveFamily: TLabel
        Left = 414
        Top = 127
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Curve fumily'
      end
      object STGroupNumber: TStaticText
        Left = 648
        Top = 68
        Width = 211
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STGroupNumber'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
      end
      object STScheduleType: TStaticText
        Left = 206
        Top = 68
        Width = 180
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STScheduleType'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
      end
      object STWorkStation: TStaticText
        Left = 648
        Top = 9
        Width = 213
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STWorkStation'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
      end
      object STWorkCenter: TStaticText
        Left = 648
        Top = 38
        Width = 210
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STWorkCenter'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
      end
      object STWCProcess: TStaticText
        Left = 206
        Top = 97
        Width = 184
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STWCProcess'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
      end
      object STRes: TStaticText
        Left = 206
        Top = 127
        Width = 189
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Color = clBtnFace
        ParentColor = False
        TabOrder = 5
      end
      object STResSubLine: TStaticText
        Left = 206
        Top = 156
        Width = 174
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STResSubLine'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
      end
      object STResComp: TStaticText
        Left = 648
        Top = 157
        Width = 209
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STResComp'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 7
      end
      object STQuantity: TStaticText
        Left = 206
        Top = 218
        Width = 192
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STQuantity'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 8
      end
      object STSetupTime: TStaticText
        Left = 206
        Top = 256
        Width = 190
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STSetupTime'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 9
      end
      object STExecTime: TStaticText
        Left = 206
        Top = 294
        Width = 188
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STExecTime'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 10
      end
      object STSchedStart: TStaticText
        Left = 206
        Top = 9
        Width = 180
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STSchedStart'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 11
      end
      object STSchedEnd: TStaticText
        Left = 206
        Top = 38
        Width = 177
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STSchedEnd'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 12
      end
      object STProgStart: TStaticText
        Left = 206
        Top = 330
        Width = 190
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STProgStart'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 13
      end
      object STProgEnd: TStaticText
        Left = 650
        Top = 330
        Width = 220
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STProgEnd'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 14
      end
      object STQuantityProg: TStaticText
        Left = 646
        Top = 222
        Width = 215
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STQuantityProg'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 15
      end
      object STActualTime: TStaticText
        Left = 649
        Top = 296
        Width = 215
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STActualTime'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 16
      end
      object STComment: TStaticText
        Left = 206
        Top = 397
        Width = 572
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STComment'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 17
      end
      object STPrevConnSubStep: TStaticText
        Left = 206
        Top = 186
        Width = 187
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STPrevConnSubStep'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 18
      end
      object STPrevConnReProcess: TStaticText
        Left = 648
        Top = 186
        Width = 216
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STPrevConnReProcess'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 19
      end
      object STSetupTimeWithoutMaterials: TStaticText
        Left = 648
        Top = 256
        Width = 222
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STSetupTime without materials'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 20
      end
      object GBTimeBar: TGroupBox
        Left = 0
        Top = 480
        Width = 899
        Height = 49
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        Caption = 'Time bar'
        TabOrder = 21
        object ShapeSetupTimeWOMaterials: TShape
          Left = 10
          Top = 20
          Width = 21
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Brush.Color = clYellow
          ParentShowHint = False
          ShowHint = True
        end
        object ShapeSetupTime: TShape
          Left = 49
          Top = 20
          Width = 21
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Brush.Color = clRed
          ParentShowHint = False
          ShowHint = True
        end
        object ShapeExecTime: TShape
          Left = 89
          Top = 20
          Width = 21
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Brush.Color = clBlue
          ParentShowHint = False
          ShowHint = True
        end
      end
      object MemErrors: TMemo
        Left = 207
        Top = 436
        Width = 573
        Height = 47
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Color = 14803425
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 22
      end
      object STActualStart: TStaticText
        Left = 206
        Top = 366
        Width = 190
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STActualStart'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 23
      end
      object STActualEnd: TStaticText
        Left = 648
        Top = 366
        Width = 220
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STActualEnd'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 24
      end
      object STLearningCurveCode: TStaticText
        Left = 648
        Top = 97
        Width = 211
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'StLearningCurveCode'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 25
      end
      object STLearningCurveFamily: TStaticText
        Left = 648
        Top = 127
        Width = 211
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'StLearningCurveCode'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 26
      end
    end
    object TbStepDetails: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Step details'
      ImageIndex = 9
      object LblPlannedWorkStation: TLabel
        Left = 14
        Top = 14
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Planned work station'
      end
      object LblStepType: TLabel
        Left = 14
        Top = 43
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Step type'
      end
      object LblMaterialsArrivalDate: TLabel
        Left = 14
        Top = 107
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Materials planned date'
      end
      object LblPlannedStartingDate: TLabel
        Left = 14
        Top = 137
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Planned starting date'
      end
      object LblLowestStartingDatePoss: TLabel
        Left = 14
        Top = 166
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Earliest starting'
      end
      object LblLowestSchedStartingDate: TLabel
        Left = 14
        Top = 196
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Earliest scheduled start'
      end
      object LblPlannedEndingDate: TLabel
        Left = 14
        Top = 225
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Planned ending date'
      end
      object LblHighestEndingDatePos: TLabel
        Left = 14
        Top = 255
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Latest ending'
      end
      object LblHighestSchedEndingDate: TLabel
        Left = 14
        Top = 284
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Latest scheduled end'
      end
      object LblPlannedWorkCenter: TLabel
        Left = 14
        Top = 314
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Planned work center'
      end
      object LblPlannedWCProcess: TLabel
        Left = 14
        Top = 343
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Planned w.c. process'
      end
      object LblInitialQuantity: TLabel
        Left = 14
        Top = 375
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Initial quantity'
      end
      object LblFinalQuantity: TLabel
        Left = 454
        Top = 378
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Final quantity'
      end
      object LblWeight: TLabel
        Left = 457
        Top = 43
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Weight'
      end
      object LblWeighUMDescription: TLabel
        Left = 457
        Top = 76
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Weigh UM description'
      end
      object LblScheduledQuantity: TLabel
        Left = 14
        Top = 407
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Scheduled quantity'
      end
      object LblCalCode: TLabel
        Left = 454
        Top = 107
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Calendar code'
      end
      object LblTotalPlannedSetupTime: TLabel
        Left = 454
        Top = 135
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Total planned setup time'
      end
      object LblTotalPlannedExecTime: TLabel
        Left = 455
        Top = 166
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Total planned execution time'
      end
      object LblPlannedNumberOfRes: TLabel
        Left = 457
        Top = 196
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Planned number of resources'
      end
      object LblRuleToConnectToPrevJob: TLabel
        Left = 454
        Top = 225
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Rule to connect to prev. step'
      end
      object LblProgressedCalculated: TLabel
        Left = 457
        Top = 314
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Calculated progress type'
      end
      object LblClosed: TLabel
        Left = 457
        Top = 14
        Width = 202
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Closed'
      end
      object LabelAlloedsplit: TLabel
        Left = 454
        Top = 284
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Allowed Split'
      end
      object LblApprovalDate: TLabel
        Left = 14
        Top = 76
        Width = 196
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Approval Date'
      end
      object LblGenericPlan: TLabel
        Left = 457
        Top = 406
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Handle prior step generc plan'
      end
      object LblOriginalHighestEndingDatePos: TLabel
        Left = 454
        Top = 255
        Width = 197
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Original Latest ending '
      end
      object LabelLblProgressedHost: TLabel
        Left = 455
        Top = 347
        Width = 203
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Host progress type'
      end
      object LabelOverriddenSpeedPerUm: TLabel
        Left = 12
        Top = 442
        Width = 196
        Height = 23
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Overridden speed per um '
      end
      object LblOveriddenSetup: TLabel
        Left = 455
        Top = 442
        Width = 196
        Height = 23
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'Overridden setup'
      end
      object STPlannedWorkStation: TStaticText
        Left = 215
        Top = 14
        Width = 203
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STPlannedWorkStation'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
      end
      object STStepType: TStaticText
        Left = 215
        Top = 43
        Width = 195
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STStepType'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
      end
      object STMaterialsArrivalDate: TStaticText
        Left = 215
        Top = 107
        Width = 199
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STMaterialsArrivalDate'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
      end
      object STPlannedStartingDate: TStaticText
        Left = 215
        Top = 137
        Width = 199
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STPlannedStartingDate'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
      end
      object STLowestStartingDatePos: TStaticText
        Left = 218
        Top = 166
        Width = 202
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STLowestStartingDatePos'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
      end
      object STLowestSchedStartingDate: TStaticText
        Left = 215
        Top = 196
        Width = 199
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STLowestSchedStartingDate'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 5
      end
      object STPlannedEndingDate: TStaticText
        Left = 215
        Top = 225
        Width = 202
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STPlannedEndingDate'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
      end
      object STHighestEndingDatePos: TStaticText
        Left = 215
        Top = 255
        Width = 203
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STHighestEndingDatePos'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 7
      end
      object STHighestSchedEndingDate: TStaticText
        Left = 215
        Top = 284
        Width = 203
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STHighestSchedEndingDate'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 8
      end
      object STPlannedWorkCenter: TStaticText
        Left = 215
        Top = 314
        Width = 202
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STPlannedWorkCenter'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 9
      end
      object STPlannedWCProcess: TStaticText
        Left = 215
        Top = 343
        Width = 204
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STPlannedWCProcess'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 10
      end
      object STInitialQuantity: TStaticText
        Left = 218
        Top = 378
        Width = 198
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STInitialQuantity'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 11
      end
      object STFinalQuantity: TStaticText
        Left = 671
        Top = 379
        Width = 206
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STFinalQuantity'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 12
      end
      object STWeight: TStaticText
        Left = 671
        Top = 46
        Width = 209
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STWeight'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 13
      end
      object STWeighUMDescription: TStaticText
        Left = 671
        Top = 76
        Width = 206
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STWeighUMDescription'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 14
      end
      object STScheduledQuantity: TStaticText
        Left = 218
        Top = 407
        Width = 196
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STScheduledQuantity'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 15
      end
      object STCalCode: TStaticText
        Left = 671
        Top = 107
        Width = 204
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STCalCode'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 16
      end
      object STTotalPlannedSetupTime: TStaticText
        Left = 671
        Top = 137
        Width = 211
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STTotalPlannedSetupTime'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 17
      end
      object STTotalPlannedExecTime: TStaticText
        Left = 671
        Top = 166
        Width = 207
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STTotalPlannedExecTime'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 18
      end
      object STPlannedNumberOfRes: TStaticText
        Left = 671
        Top = 196
        Width = 208
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STPlannedNumberOfRes'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 19
      end
      object STRuleToConnectToPrevJob: TStaticText
        Left = 671
        Top = 225
        Width = 208
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STRuleToConnectToPrevJob'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 20
      end
      object STProgressedCalculated: TStaticText
        Left = 671
        Top = 315
        Width = 209
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STProgressedCalculated'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 21
      end
      object STClosed: TStaticText
        Left = 671
        Top = 14
        Width = 197
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STClosed'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 22
      end
      object STAlloweSplit: TStaticText
        Left = 671
        Top = 284
        Width = 209
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STAllowedSplit'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 23
      end
      object STApprovaldate: TStaticText
        Left = 215
        Top = 76
        Width = 199
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STApproval Date'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 24
      end
      object STGenericPlan: TStaticText
        Left = 672
        Top = 408
        Width = 206
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STGenericPlan'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 25
      end
      object STOriginalHighestEndingDatePos: TStaticText
        Left = 671
        Top = 255
        Width = 207
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STOriginalHighestEndingDatePos'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 26
      end
      object STProgressedHost: TStaticText
        Left = 670
        Top = 348
        Width = 209
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'STProgressedHost'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 27
      end
      object STOverriddenSpeedPerUm: TStaticText
        Left = 216
        Top = 442
        Width = 196
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'OverriddenSpeedPerUm '
        Color = clBtnFace
        ParentColor = False
        TabOrder = 28
      end
      object StaticTexOverriddenSetup: TStaticText
        Left = 671
        Top = 442
        Width = 145
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        Caption = 'OverriddenSetup'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 29
      end
    end
    object TbStepProperties: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Step properties'
      ImageIndex = 10
    end
    object TBRelatedOrders: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Related orders'
      ImageIndex = 11
      object SGRelatedOrders: TStringGrid
        Left = 0
        Top = 0
        Width = 899
        Height = 529
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        ColWidths = (
          188
          176
          159
          180
          452)
        RowHeights = (
          24
          24)
      end
    end
    object Tb: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Steps view'
      ImageIndex = 12
      object SGStepsView: TStringGrid
        Left = 0
        Top = 0
        Width = 899
        Height = 529
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 16
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        ParentFont = False
        TabOrder = 0
        ColWidths = (
          155
          163
          170
          179
          178
          119
          110
          116
          124
          128
          115
          121
          123
          125
          104
          111)
        RowHeights = (
          24
          24)
      end
    end
    object TabSheet1: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Jobs view'
      ImageIndex = 13
      object SGJobsView: TStringGrid
        Left = 0
        Top = 0
        Width = 899
        Height = 529
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColCount = 14
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        ColWidths = (
          159
          173
          151
          140
          126
          119
          110
          116
          124
          128
          115
          121
          123
          125)
        RowHeights = (
          24
          24)
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 907
    Height = 41
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblProdReq: TLabel
      Left = 16
      Top = 14
      Width = 51
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Request'
    end
    object LblStepnum: TLabel
      Left = 331
      Top = 14
      Width = 28
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Step'
    end
    object LblSubStep: TLabel
      Left = 459
      Top = 14
      Width = 53
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Sub step'
    end
    object LblRePro: TLabel
      Left = 655
      Top = 14
      Width = 70
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Re process'
    end
    object StProdReq: TStaticText
      Left = 86
      Top = 12
      Width = 231
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'StProdReq'
      Color = 14803425
      ParentColor = False
      TabOrder = 0
    end
    object StStepNum: TStaticText
      Left = 374
      Top = 12
      Width = 69
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'StStepNum'
      Color = 14803425
      ParentColor = False
      TabOrder = 1
    end
    object STSubStep: TStaticText
      Left = 524
      Top = 12
      Width = 82
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STSubStep'
      Color = 14803425
      ParentColor = False
      TabOrder = 2
    end
    object STRePro: TStaticText
      Left = 739
      Top = 13
      Width = 55
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'STRePro'
      Color = 14803425
      ParentColor = False
      TabOrder = 3
    end
  end
end
