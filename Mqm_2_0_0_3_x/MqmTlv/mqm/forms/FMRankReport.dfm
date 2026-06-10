object FRankReport: TFRankReport
  Left = 50
  Top = 70
  Caption = 'Automatic schedulation results'
  ClientHeight = 582
  ClientWidth = 913
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel2: TBevel
    Left = 0
    Top = 540
    Width = 913
    Height = 42
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    Shape = bsTopLine
  end
  object Splitter1: TSplitter
    Left = 0
    Top = 178
    Width = 913
    Height = 4
    Cursor = crVSplit
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
  end
  object ChartScore: TChart
    Left = 0
    Top = 182
    Width = 913
    Height = 358
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdLeftRight
    Legend.Alignment = laBottom
    Legend.LegendStyle = lsSeries
    MarginBottom = 2
    MarginLeft = 1
    MarginRight = 2
    MarginTop = 3
    Title.Text.Strings = (
      '')
    Zoom.Pen.Mode = pmNotXor
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clWhite
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TBarSeries
      BarBrush.Gradient.Visible = True
      Marks.Style = smsValue
      SeriesColor = clYellow
      Title = 'Discrepancy'
      BarStyle = bsRectGradient
      Gradient.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
    object Series2: TBarSeries
      BarBrush.Gradient.EndColor = clBlue
      BarBrush.Gradient.Visible = True
      Marks.Style = smsValue
      SeriesColor = clBlue
      Title = 'Penalty'
      BarStyle = bsRectGradient
      Gradient.EndColor = clBlue
      Gradient.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
    object Series3: TBarSeries
      BarBrush.Gradient.EndColor = 10708548
      BarBrush.Gradient.Visible = True
      Marks.Style = smsValue
      Title = 'Score'
      BarStyle = bsRectGradient
      Gradient.EndColor = 10708548
      Gradient.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object GBPosRank: TGroupBox
    Left = 0
    Top = 0
    Width = 913
    Height = 178
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Caption = 'Valid positions rank'
    TabOrder = 1
    object SGRank: TStringGrid
      Left = 2
      Top = 18
      Width = 909
      Height = 158
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      ColCount = 4
      DefaultColWidth = 130
      DefaultRowHeight = 17
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect, goThumbTracking]
      TabOrder = 0
      OnDrawCell = SGRankDrawCell
      OnSelectCell = SGRankSelectCell
      ColWidths = (
        130
        130
        130
        130)
      RowHeights = (
        17
        17)
    end
  end
  object BtnOk: TPanel
    Left = 677
    Top = 547
    Width = 102
    Height = 30
    BevelOuter = bvNone
    Caption = 'OK'
    Color = 15972184
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    OnClick = BtnOkClick
  end
  object BtnAbo: TPanel
    Left = 794
    Top = 547
    Width = 95
    Height = 30
    BevelOuter = bvNone
    Caption = 'Abort'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Font.Quality = fqClearType
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    OnClick = BtnAboClick
  end
end
