object RecPlotFrm: TRecPlotFrm
  Left = 613
  Top = 229
  Caption = 'On-Line Analysis'
  ClientHeight = 547
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object plPlot: TXMultiYPlot
    Left = 160
    Top = 8
    Width = 313
    Height = 289
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
    MarkerSize = 6
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
    PrinterLeftMargin = 0
    PrinterRightMargin = 0
    PrinterTopMargin = 0
    PrinterBottomMargin = 0
    PrinterDisableColor = False
    MetafileWidth = 500
    MetafileHeight = 400
    ShowLineLabels = True
  end
  object ControlsGrp: TGroupBox
    Left = 8
    Top = 0
    Width = 145
    Height = 545
    TabOrder = 0
    object mePlotList: TMemo
      Left = 8
      Top = 368
      Width = 129
      Height = 105
      Lines.Strings = (
        'mePlotList')
      ReadOnly = True
      TabOrder = 0
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 480
      Width = 129
      Height = 57
      Caption = ' Zero Level '
      TabOrder = 1
      object rbZeroLevelC0: TRadioButton
        Left = 8
        Top = 16
        Width = 89
        Height = 21
        Hint = 'Use signal level at cursor 0 as zero reference'
        Caption = 'at 0 cursor'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TabStop = True
      end
      object rbZeroLevelZ: TRadioButton
        Left = 8
        Top = 32
        Width = 105
        Height = 23
        Hint = 'Use horizontal z cursor to define signal zero level'
        Caption = 'at Z cursor'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 8
      Width = 129
      Height = 353
      Caption = ' Measurements '
      TabOrder = 2
      object Label2: TLabel
        Left = 8
        Top = 42
        Width = 31
        Height = 14
        Caption = 'Chan.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 10
        Top = 240
        Width = 98
        Height = 14
        Caption = 'For Stim. Protocol'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Shape1: TShape
        Left = 8
        Top = 214
        Width = 113
        Height = 1
      end
      object cbPlotVar: TComboBox
        Left = 8
        Top = 16
        Width = 113
        Height = 21
        Hint = 'Waveform measurement to be plotted'
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = cbPlotVarChange
      end
      object cbPlotChan: TComboBox
        Left = 48
        Top = 40
        Width = 73
        Height = 21
        Hint = 'Signal input channel to be measured'
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object bAddPlot: TButton
        Left = 8
        Top = 220
        Width = 113
        Height = 17
        Hint = 'Add selected waveform measurement to plot'
        Caption = 'Add to Plot'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = bAddPlotClick
      end
      object panPolarity: TPanel
        Left = 8
        Top = 88
        Width = 115
        Height = 41
        BevelOuter = bvNone
        TabOrder = 3
        object Label3: TLabel
          Left = 2
          Top = 0
          Width = 41
          Height = 14
          Caption = 'Polarity'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cbPolarity: TComboBox
          Left = 2
          Top = 16
          Width = 110
          Height = 21
          Hint = 'Polarity of waveform: positive-going, negative-going, or both.'
          Style = csDropDownList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
      object panRateofRiseSmooth: TPanel
        Left = 8
        Top = 128
        Width = 113
        Height = 41
        BevelOuter = bvNone
        TabOrder = 4
        object Label4: TLabel
          Left = 2
          Top = 2
          Width = 60
          Height = 14
          Caption = 'Smoothing'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cbRateofRiseSmooth: TComboBox
          Left = 2
          Top = 16
          Width = 110
          Height = 21
          Hint = 'No. of points over which rate of change is smoothed'
          Style = csDropDownList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
      object panCursors: TPanel
        Left = 8
        Top = 65
        Width = 113
        Height = 26
        BevelOuter = bvNone
        TabOrder = 5
        object Label5: TLabel
          Left = 1
          Top = 0
          Width = 69
          Height = 14
          Caption = 'Points Avgd.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edNumAveraged: TValidatedEdit
          Left = 71
          Top = 0
          Width = 41
          Height = 21
          Text = ' 10 '
          Value = 10.000000000000000000
          Scale = 1.000000000000000000
          NumberFormat = '%.4g'
          LoLimit = 1.000000000000000000
          HiLimit = 100.000000000000000000
        end
      end
      object cbPulseProgram: TComboBox
        Left = 8
        Top = 256
        Width = 113
        Height = 21
        Hint = 'Plot only when selected stimulus protocol is in use'
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object Button1: TButton
        Left = 8
        Top = 282
        Width = 113
        Height = 17
        Hint = 'Erase plot and clear measurements list'
        Caption = 'Clr. Measurements'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = Button1Click
      end
      object bClearPoints: TButton
        Left = 8
        Top = 304
        Width = 113
        Height = 17
        Hint = 'Erase plot'
        Caption = 'Clear Plots'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = bClearPointsClick
      end
      object bCopyToClipboard: TButton
        Left = 8
        Top = 328
        Width = 113
        Height = 17
        Hint = 'Copy plot data to clipboard'
        Caption = 'Copy to Clipboard'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = bCopyToClipboardClick
      end
      object panCursorSet: TPanel
        Left = 8
        Top = 65
        Width = 113
        Height = 26
        BevelOuter = bvNone
        TabOrder = 10
        object Label6: TLabel
          Left = 8
          Top = 0
          Width = 46
          Height = 14
          Caption = 'Cursors'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cbCursorSet: TComboBox
          Left = 56
          Top = 0
          Width = 57
          Height = 21
          Hint = 
            'Cursor pair  defining waveform measurement region in recording s' +
            'weep'
          Style = csDropDownList
          ItemIndex = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = '1-2'
          Items.Strings = (
            '1-2'
            '3-4')
        end
      end
      object PanRiseTime: TPanel
        Left = 8
        Top = 170
        Width = 113
        Height = 41
        BevelOuter = bvNone
        TabOrder = 11
        object Label7: TLabel
          Left = 2
          Top = 2
          Width = 92
          Height = 14
          Caption = 'Rise Time Range'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edRiseTimeRange: TRangeEdit
          Left = 0
          Top = 16
          Width = 113
          Height = 21
          Text = ' 10.00 - 90.00 %'
          LoValue = 0.100000001490116100
          HiValue = 0.899999976158142100
          HiLimit = 100.000000000000000000
          Scale = 100.000000000000000000
          Units = '%'
          NumberFormat = '%.f - %.f'
        end
      end
    end
  end
end
