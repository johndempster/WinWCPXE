object Form1: TForm1
  Left = 487
  Top = 439
  Width = 615
  Height = 459
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object XMultiYPlot1: TXMultiYPlot
    Left = 184
    Top = 8
    Width = 409
    Height = 417
    PlotNum = 0
    MaxPointsPerLine = 4096
    XAxisMax = 1.000000000000000000
    XAxisTick = 0.200000002980232200
    XAxisLaw = axLinear
    XAxisLabel = 'X Axis'
    XAxisAutoRange = False
    YAxisMax = 1.000000000000000000
    YAxisTick = 0.200000002980232200
    YAxisLaw = axLinear
    YAxisLabel = 'Y Axis'
    YAxisAutoRange = True
    YAxisLabelAtTop = False
    ScreenFontName = 'Arial'
    ScreenFontSize = 10
    LineWidth = 1
    MarkerSize = 10
    ShowLines = True
    ShowMarkers = True
    HistogramFullBorders = False
    HistogramFillColor = clWhite
    HistogramFillStyle = bsClear
    HistogramCumulative = False
    HistogramPercentage = False
    PrinterFontSize = 10
    PrinterFontName = 'Arial'
    PrinterLineWidth = 1
    PrinterMarkerSize = 5
    PrinterLeftMargin = 24
    PrinterRightMargin = 24
    PrinterTopMargin = 24
    PrinterBottomMargin = 24
    PrinterDisableColor = False
    MetafileWidth = 500
    MetafileHeight = 400
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 417
    Caption = 'GroupBox1'
    TabOrder = 0
    object cbPlotVar: TComboBox
      Left = 8
      Top = 32
      Width = 121
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'cbPlotVar'
    end
    object bAddPlot: TButton
      Left = 8
      Top = 56
      Width = 121
      Height = 17
      Caption = 'Add Plot'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object Button1: TButton
      Left = 8
      Top = 80
      Width = 121
      Height = 17
      Caption = 'Clear Plots'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
end
