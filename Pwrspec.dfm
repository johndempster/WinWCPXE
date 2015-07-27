object PwrSpecFrm: TPwrSpecFrm
  Left = 856
  Top = 302
  Caption = 'Non-stationary Variance Analysis'
  ClientHeight = 537
  ClientWidth = 698
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDesigned
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Page: TPageControl
    Left = 4
    Top = 0
    Width = 585
    Height = 513
    ActivePage = DataTab
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = PageChange
    object DataTab: TTabSheet
      Caption = 'Data Record'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object scDisplay: TScopeDisplay
        Left = 144
        Top = 6
        Width = 385
        Height = 337
        OnMouseUp = scDisplayMouseUp
        OnCursorChange = scDisplayCursorChange
        CursorChangeInProgress = False
        NumChannels = 1
        NumPoints = 1024
        MaxPoints = 1024
        XMin = 511
        XMax = 0
        XOffset = 0
        CursorsEnabled = True
        TScale = 1.000000000000000000
        TUnits = 's'
        TCalBar = -1.000000000000000000
        ZoomDisableHorizontal = True
        ZoomDisableVertical = False
        DisableChannelVisibilityButton = False
        PrinterFontSize = 0
        PrinterPenWidth = 0
        PrinterLeftMargin = 0
        PrinterRightMargin = 0
        PrinterTopMargin = 0
        PrinterBottomMargin = 0
        PrinterDisableColor = False
        PrinterShowLabels = True
        PrinterShowZeroLevels = True
        MetafileWidth = 0
        MetafileHeight = 0
        StorageMode = False
        RecordNumber = -1
        DisplayGrid = True
        MaxADCValue = 2047
        MinADCValue = -2048
        NumBytesPerSample = 2
        FixZeroLevels = False
        DisplaySelected = False
        FontSize = 8
      end
      object ControlGrp: TGroupBox
        Left = 0
        Top = 0
        Width = 137
        Height = 113
        Caption = ' Records '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label10: TLabel
          Left = 24
          Top = 64
          Width = 25
          Height = 15
          Caption = 'Type'
        end
        object sbRecord: TScrollBar
          Left = 8
          Top = 38
          Width = 121
          Height = 17
          PageSize = 0
          TabOrder = 0
          OnChange = sbRecordChange
        end
        object ckRejected: TCheckBox
          Left = 56
          Top = 88
          Width = 73
          Height = 17
          Caption = ' Rejected'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = ckRejectedClick
        end
        object cbRecordType: TComboBox
          Left = 56
          Top = 60
          Width = 73
          Height = 23
          Style = csDropDownList
          TabOrder = 2
          OnChange = cbRecordTypeChange
          Items.Strings = (
            'Test'
            'Background')
        end
        object edRecord: TRangeEdit
          Left = 8
          Top = 16
          Width = 121
          Height = 20
          OnKeyPress = edRecordKeyPress
          AutoSize = False
          Text = ' 1 / 1 '
          LoValue = 1.000000000000000000
          HiValue = 1.000000000000000000
          LoLimit = 1.000000000000000000
          HiLimit = 1.000000015047466E30
          Scale = 1.000000000000000000
          NumberFormat = '%.0f / %.0f'
        end
      end
      object AverageGrp: TGroupBox
        Left = 0
        Top = 112
        Width = 137
        Height = 297
        Caption = ' Analysis '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 16
          Width = 47
          Height = 15
          Caption = 'Channel'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 36
          Top = 56
          Width = 25
          Height = 15
          Caption = 'Type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object GroupBox1: TGroupBox
          Left = 8
          Top = 82
          Width = 121
          Height = 73
          TabOrder = 0
          object rbAllRecords: TRadioButton
            Left = 8
            Top = 8
            Width = 81
            Height = 18
            Hint = 'Analysis all record in the data file'
            Caption = 'All records'
            Checked = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TabStop = True
            OnClick = rbAllRecordsClick
          end
          object rbRange: TRadioButton
            Left = 8
            Top = 24
            Width = 81
            Height = 17
            Hint = 'Analysis a limited range of records within the data file'
            Caption = 'Range'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = rbAllRecordsClick
          end
          object edRecRange: TRangeEdit
            Left = 24
            Top = 40
            Width = 89
            Height = 20
            OnKeyPress = edRecRangeKeyPress
            AutoSize = False
            Text = ' 0 - 1 '
            HiValue = 1.000000000000000000
            HiLimit = 1.000000015047466E30
            Scale = 1.000000000000000000
            NumberFormat = '%.0f - %.0f'
          end
        end
        object GroupBox4: TGroupBox
          Left = 8
          Top = 184
          Width = 121
          Height = 105
          Caption = ' Average '
          TabOrder = 1
          object Label12: TLabel
            Left = 7
            Top = 18
            Width = 90
            Height = 15
            Caption = 'Alignment mode'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object cbAlignMode: TComboBox
            Left = 8
            Top = 34
            Width = 105
            Height = 23
            Hint = 
              'Determines whether records are aligned by the mid-points of thei' +
              'r leading edges before averaging'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnChange = cbAlignModeChange
            Items.Strings = (
              'No alignment'
              'On Positive Rise'
              'On Negative Rise')
          end
          object rbScaleToPeak: TRadioButton
            Left = 8
            Top = 64
            Width = 97
            Height = 17
            Caption = 'Scale to peak'
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            TabStop = True
            OnClick = rbScaleToPeakClick
          end
          object rbNoScale: TRadioButton
            Left = 8
            Top = 80
            Width = 97
            Height = 17
            Caption = 'No Scaling'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = rbNoScaleClick
          end
        end
        object cbChannel: TComboBox
          Left = 8
          Top = 30
          Width = 121
          Height = 23
          TabOrder = 2
          Text = 'cbChannel'
          OnChange = cbChannelChange
        end
        object cbTypeToBeAnalysed: TComboBox
          Left = 64
          Top = 56
          Width = 65
          Height = 23
          Hint = 'Type of record to be used in analysis'
          Style = csDropDownList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnChange = cbTypeToBeAnalysedChange
        end
      end
      object ckFixedZeroLevels: TCheckBox
        Left = 142
        Top = 348
        Width = 102
        Height = 17
        Caption = 'Fix Zero Levels'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = ckFixedZeroLevelsClick
      end
    end
    object VarianceTab: TTabSheet
      Caption = 'X/Y Plot'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object plVarPlot: TXYPlotDisplay
        Left = 142
        Top = 6
        Width = 417
        Height = 273
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
        YAxisAutoRange = False
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
      end
      object Shape2: TShape
        Left = 192
        Top = 305
        Width = 145
        Height = 0
      end
      object VarGrp: TGroupBox
        Left = 0
        Top = 0
        Width = 137
        Height = 425
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object GroupBox5: TGroupBox
          Left = 8
          Top = 104
          Width = 121
          Height = 113
          Caption = ' Plot '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object Label9: TLabel
            Left = 8
            Top = 60
            Width = 31
            Height = 15
            Caption = 'Y Axis'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label8: TLabel
            Left = 8
            Top = 16
            Width = 31
            Height = 15
            Caption = 'X Axis'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object cbVarYAxis: TComboBox
            Left = 8
            Top = 76
            Width = 105
            Height = 23
            Style = csDropDownList
            TabOrder = 0
            Items.Strings = (
              'Sample No.'
              'Time'
              'Mean'
              'St. Dev.'
              'Variance')
          end
          object cbVarXAxis: TComboBox
            Left = 8
            Top = 32
            Width = 105
            Height = 23
            Style = csDropDownList
            TabOrder = 1
            Items.Strings = (
              'Sample No.'
              'Time'
              'Mean'
              'St. Dev.'
              'Variance'
              '')
          end
        end
        object bDoVariance: TButton
          Left = 8
          Top = 16
          Width = 121
          Height = 17
          Caption = 'New Plot'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = bDoVarianceClick
        end
        object bVarSetAxes: TButton
          Left = 8
          Top = 36
          Width = 121
          Height = 17
          Caption = 'Set Axes'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = bVarSetAxesClick
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 56
          Width = 121
          Height = 49
          TabOrder = 3
          object lbPlotRecordRange: TLabel
            Left = 8
            Top = 12
            Width = 69
            Height = 15
            Caption = 'Records 1-n'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lbPlotSampleRange: TLabel
            Left = 8
            Top = 28
            Width = 76
            Height = 15
            Caption = 'samples : 1-n'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object BaselineVarGrp: TGroupBox
          Left = 8
          Top = 224
          Width = 121
          Height = 73
          Caption = ' Baseline Variance '
          TabOrder = 4
          object bCalcBaselineVariance: TButton
            Left = 8
            Top = 18
            Width = 105
            Height = 17
            Caption = 'Calc. Variance'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            OnClick = bCalcBaselineVarianceClick
          end
          object edBaselineVariance: TEdit
            Left = 8
            Top = 40
            Width = 105
            Height = 23
            TabOrder = 1
          end
        end
      end
      object VarFitGrp: TGroupBox
        Left = 144
        Top = 315
        Width = 417
        Height = 158
        Caption = ' Analysis '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object bVarFit: TButton
          Left = 8
          Top = 16
          Width = 105
          Height = 17
          Caption = 'Fit Curve'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = bVarFitClick
        end
        object cbVarEquation: TComboBox
          Left = 8
          Top = 36
          Width = 105
          Height = 23
          Style = csDropDownList
          TabOrder = 1
          Items.Strings = (
            'None'
            'Linear'
            'Parabola'
            'Exponential')
        end
        object erVarResults: TRichEdit
          Left = 128
          Top = 16
          Width = 289
          Height = 129
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 2
        end
      end
    end
    object SpectrumTab: TTabSheet
      Caption = 'Spectral Analysis'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object plSpecPlot: TXYPlotDisplay
        Left = 152
        Top = 8
        Width = 417
        Height = 257
        MaxPointsPerLine = 8192
        XAxisMax = 1.000000000000000000
        XAxisTick = 0.200000002980232200
        XAxisLaw = axLinear
        XAxisLabel = 'X Axis'
        XAxisAutoRange = False
        YAxisMax = 1.000000000000000000
        YAxisTick = 0.200000002980232200
        YAxisLaw = axLinear
        YAxisLabel = 'Y Axis'
        YAxisAutoRange = False
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
      end
      object specGrp: TGroupBox
        Left = 0
        Top = 0
        Width = 137
        Height = 433
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object GroupBox8: TGroupBox
          Left = 8
          Top = 64
          Width = 121
          Height = 81
          Caption = ' Time window '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 16
            Width = 56
            Height = 15
            Caption = 'No. points'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object rbNoWindow: TRadioButton
            Left = 8
            Top = 40
            Width = 89
            Height = 17
            Caption = 'Rectangular'
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            TabStop = True
          end
          object rbCosineWindow: TRadioButton
            Left = 8
            Top = 56
            Width = 89
            Height = 17
            Caption = ' 10% Cosine'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object edNumFFTPoints: TValidatedEdit
            Left = 64
            Top = 16
            Width = 49
            Height = 20
            AutoSize = False
            Text = ' 128 '
            Value = 128.000000000000000000
            Scale = 1.000000000000000000
            NumberFormat = '%.0f'
            LoLimit = 128.000000000000000000
            HiLimit = 8192.000000000000000000
          end
        end
        object bDoSpectrum: TButton
          Left = 8
          Top = 16
          Width = 121
          Height = 17
          Caption = 'New Spectrum'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = bDoSpectrumClick
        end
        object bSpecSetAxes: TButton
          Left = 8
          Top = 36
          Width = 121
          Height = 17
          Caption = 'Set Axes'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = bSpecSetAxesClick
        end
        object GroupBox10: TGroupBox
          Left = 8
          Top = 200
          Width = 121
          Height = 97
          Caption = ' Freq. Averaging '
          TabOrder = 3
          object Label11: TLabel
            Left = 16
            Top = 68
            Width = 57
            Height = 17
            AutoSize = False
            Caption = 'No. Freqs.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object rbNoFreqAveraging: TRadioButton
            Left = 8
            Top = 16
            Width = 57
            Height = 17
            Caption = ' None'
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            TabStop = True
          end
          object rbLogFreqAveraging: TRadioButton
            Left = 8
            Top = 32
            Width = 97
            Height = 17
            Caption = ' Logarithmic'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object rbLinFreqAveraging: TRadioButton
            Left = 8
            Top = 48
            Width = 57
            Height = 17
            Caption = ' Linear'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
          end
          object edNumFreqAveraged: TValidatedEdit
            Left = 72
            Top = 68
            Width = 41
            Height = 20
            AutoSize = False
            Text = ' 1.00 '
            Value = 1.000000000000000000
            Scale = 1.000000000000000000
            NumberFormat = '%.f'
            LoLimit = 1.000000000000000000
            HiLimit = 1.000000015047466E30
          end
        end
        object GroupBox11: TGroupBox
          Left = 8
          Top = 144
          Width = 121
          Height = 57
          Caption = ' Options '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          object ckSubtractTrends: TCheckBox
            Left = 8
            Top = 16
            Width = 105
            Height = 17
            Caption = ' Subtr'#39't Trends'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object ckSubtract50Hz: TCheckBox
            Left = 8
            Top = 32
            Width = 105
            Height = 17
            Caption = ' Subtr'#39't 50Hz'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
        end
      end
      object SpecFitGrp: TGroupBox
        Left = 144
        Top = 323
        Width = 417
        Height = 158
        Caption = ' Curve fitting '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object bFitLorentzian: TButton
          Left = 8
          Top = 16
          Width = 105
          Height = 17
          Caption = 'Fit Curve'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = bFitLorentzianClick
        end
        object cbSpecEquation: TComboBox
          Left = 8
          Top = 36
          Width = 105
          Height = 23
          Style = csDropDownList
          TabOrder = 1
          Items.Strings = (
            'None'
            'Lorentzian'
            'Lorentzian + 1/f'
            '2 Lorentzians'
            'MEPC Noise')
        end
        object erSpecResults: TRichEdit
          Left = 120
          Top = 16
          Width = 289
          Height = 129
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 2
        end
      end
    end
  end
end
