object FitFrm: TFitFrm
  Left = 786
  Top = 84
  Caption = 'Curve Fit'
  ClientHeight = 546
  ClientWidth = 693
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
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Page: TPageControl
    Left = 8
    Top = 2
    Width = 649
    Height = 543
    ActivePage = CurveFitTab
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = PageChange
    object CurveFitTab: TTabSheet
      Caption = 'Fit Curves'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object scDisplay: TScopeDisplay
        Left = 176
        Top = 6
        Width = 329
        Height = 273
        OnMouseUp = scDisplayMouseUp
        OnCursorChange = scDisplayCursorChange
        CursorChangeInProgress = False
        NumChannels = 1
        NumPoints = 1
        MaxPoints = 1024
        XMin = 0
        XMax = 1023
        XOffset = 0
        CursorsEnabled = True
        TScale = 1.000000000000000000
        TUnits = 's'
        TCalBar = -1.000000000000000000
        ZoomDisableHorizontal = False
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
        FloatingPointSamples = False
        FixZeroLevels = False
        DisplaySelected = False
        FontSize = 8
      end
      object RecordGrp: TGroupBox
        Left = 4
        Top = 0
        Width = 161
        Height = 113
        Caption = ' Record'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object Label2: TLabel
          Left = 40
          Top = 64
          Width = 25
          Height = 15
          Alignment = taRightJustify
          Caption = 'Type'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object ckBadRecord: TCheckBox
          Left = 8
          Top = 88
          Width = 81
          Height = 17
          Hint = 'Reject currently displayed recorded from analysis'
          Caption = 'Rejected'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = ckBadRecordClick
        end
        object sbRecordNum: TScrollBar
          Left = 8
          Top = 40
          Width = 145
          Height = 17
          Hint = 'Move slider to display records'
          PageSize = 0
          TabOrder = 1
          OnChange = sbRecordNumChange
        end
        object cbRecordType: TComboBox
          Left = 72
          Top = 64
          Width = 81
          Height = 23
          Hint = 'Type of record'
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnChange = cbRecordTypeChange
        end
        object edRecordNum: TRangeEdit
          Left = 8
          Top = 18
          Width = 145
          Height = 20
          OnKeyPress = edRecordNumKeyPress
          AutoSize = False
          Text = ' 1 / 1.00000001504746622E30 '
          LoValue = 1.000000000000000000
          HiValue = 1.000000015047466E30
          LoLimit = 1.000000000000000000
          HiLimit = 1.000000015047466E30
          Scale = 1.000000000000000000
          NumberFormat = '%.0f / %.0f'
        end
      end
      object AnalysisGrp: TGroupBox
        Left = 4
        Top = 113
        Width = 161
        Height = 392
        Caption = ' Analyse '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object bDoFit: TButton
          Left = 8
          Top = 16
          Width = 89
          Height = 17
          Hint = 'Start curve fitting'
          Caption = 'Do Fit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = bDoFitClick
        end
        object bAbort: TButton
          Left = 104
          Top = 16
          Width = 49
          Height = 17
          Hint = 'Abort curve fitting'
          Caption = 'Abort'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = bAbortClick
        end
        object bSetParameters: TButton
          Left = 8
          Top = 216
          Width = 145
          Height = 17
          Hint = 'Set parameters as fixed/variable and initial fitting values'
          Caption = 'Set Parameters'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = bSetParametersClick
        end
        object CursorsGrp: TGroupBox
          Left = 8
          Top = 240
          Width = 145
          Height = 121
          Caption = ' Data Cursors '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          object Label1: TLabel
            Left = 8
            Top = 75
            Width = 34
            Height = 15
            Caption = 'Limits'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object cbDataLimitCursors: TComboBox
            Left = 8
            Top = 50
            Width = 129
            Height = 23
            Hint = 'Region of waveform selected for automatic cursor placement'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            Items.Strings = (
              'On Rise'
              'On Decay'
              'Rise+Decay')
          end
          object rbManualCursors: TRadioButton
            Left = 8
            Top = 18
            Width = 89
            Height = 12
            Hint = 'Fit data cursors to be placed manually'
            Caption = 'Manual'
            Checked = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            TabStop = True
          end
          object rbAutoCursors: TRadioButton
            Left = 8
            Top = 32
            Width = 81
            Height = 17
            Hint = 'Fitting data cursors to be placed automatically'
            Caption = 'Automatic'
            TabOrder = 2
          end
          object edLimits: TRangeEdit
            Left = 8
            Top = 90
            Width = 129
            Height = 20
            AutoSize = False
            Text = ' 5.0-95.0 %'
            LoValue = 0.050000000745058060
            HiValue = 0.949999988079071000
            HiLimit = 1.000000000000000000
            Scale = 100.000000000000000000
            Units = '%'
            NumberFormat = '%.1f-%.1f'
          end
        end
        object RangeGrp: TGroupBox
          Left = 8
          Top = 60
          Width = 145
          Height = 149
          Caption = ' Records '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          object Label7: TLabel
            Left = 43
            Top = 122
            Width = 25
            Height = 15
            Alignment = taRightJustify
            Caption = 'Type'
          end
          object Label6: TLabel
            Left = 8
            Top = 90
            Width = 47
            Height = 15
            Caption = 'Channel'
          end
          object rbThisRecord: TRadioButton
            Left = 8
            Top = 32
            Width = 97
            Height = 17
            Hint = 'Do curve fit only on the currently displayed record'
            Caption = ' This Record'
            Checked = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TabStop = True
          end
          object rbRecordRange: TRadioButton
            Left = 8
            Top = 48
            Width = 65
            Height = 17
            Caption = 'Range'
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
          end
          object cbTypeToBeAnalysed: TComboBox
            Left = 72
            Top = 120
            Width = 65
            Height = 23
            Hint = 'Use only records of this type'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
          end
          object cbFitChannel: TComboBox
            Left = 64
            Top = 90
            Width = 73
            Height = 23
            Hint = 'Channel selected for curve fitting'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnChange = cbFitChannelChange
            Items.Strings = (
              '')
          end
          object rbAllRecords: TRadioButton
            Left = 8
            Top = 16
            Width = 81
            Height = 17
            Hint = 'Do curve fit on all record in file'
            Caption = 'All records'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
          end
          object edRecRange: TRangeEdit
            Left = 24
            Top = 64
            Width = 113
            Height = 20
            AutoSize = False
            Text = ' 0.00 - 1.00000001504746622E30 '
            HiValue = 1.000000015047466E30
            HiLimit = 1.000000015047466E30
            Scale = 1.000000000000000000
            NumberFormat = '%.f - %.f'
          end
        end
        object cbEquation: TComboBox
          Left = 8
          Top = 36
          Width = 145
          Height = 23
          TabOrder = 5
          Text = 'cbEquation'
          OnChange = cbEquationChange
        end
        object bGetCursors: TButton
          Left = 8
          Top = 367
          Width = 145
          Height = 17
          Caption = 'Get Cursors'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          OnClick = bGetCursorsClick
        end
      end
      object ResultsGrp: TGroupBox
        Left = 176
        Top = 272
        Width = 433
        Height = 177
        Caption = ' Results '
        TabOrder = 2
        object erResults: TRichEdit
          Left = 8
          Top = 16
          Width = 417
          Height = 153
          Lines.Strings = (
            'erResults')
          TabOrder = 0
          Zoom = 100
        end
      end
      object ckFixedZeroLevels: TCheckBox
        Left = 470
        Top = 252
        Width = 147
        Height = 17
        Caption = 'Fix Zero Levels'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = ckFixedZeroLevelsClick
      end
    end
    object XYPlotTab: TTabSheet
      Caption = 'X/Y Plot'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object plPlot: TXYPlotDisplay
        Left = 176
        Top = 8
        Width = 433
        Height = 329
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
      object XYPlotGrp: TGroupBox
        Left = 4
        Top = 4
        Width = 161
        Height = 417
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object bNewXYPlot: TButton
          Left = 8
          Top = 92
          Width = 145
          Height = 17
          Hint = 'Create a new X/Y plot'
          Caption = 'New Plot'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = bNewXYPlotClick
        end
        object XGroup: TGroupBox
          Left = 8
          Top = 140
          Width = 145
          Height = 57
          Caption = ' X Axis '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object cbXVariable: TComboBox
            Left = 8
            Top = 19
            Width = 129
            Height = 23
            Hint = 'Variable to be plotted on X axis'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
        end
        object YGroup: TGroupBox
          Left = 8
          Top = 200
          Width = 145
          Height = 57
          Caption = ' Y Axis '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object cbYVariable: TComboBox
            Left = 8
            Top = 19
            Width = 129
            Height = 23
            Hint = 'Variable to be plotted on Y axis'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
        end
        object bSetPlotAxes: TButton
          Left = 8
          Top = 112
          Width = 145
          Height = 17
          Hint = 'Change X & Y axes range and labels'
          Caption = 'Set Axes'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = bSetPlotAxesClick
        end
        object GroupBox1: TGroupBox
          Left = 8
          Top = 263
          Width = 145
          Height = 49
          Caption = ' Filter records '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          object bFilter: TButton
            Left = 8
            Top = 18
            Width = 129
            Height = 20
            Caption = 'Filter'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            OnClick = bFilterClick
          end
        end
      end
    end
    object HistogramTab: TTabSheet
      Caption = 'Histogram'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object plHist: TXYPlotDisplay
        Left = 176
        Top = 8
        Width = 449
        Height = 305
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
        PrinterLeftMargin = 0
        PrinterRightMargin = 0
        PrinterTopMargin = 0
        PrinterBottomMargin = 0
        PrinterDisableColor = False
        MetafileWidth = 500
        MetafileHeight = 400
      end
      object HistGrp: TGroupBox
        Left = 4
        Top = 4
        Width = 161
        Height = 425
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object bNewHistogram: TButton
          Left = 8
          Top = 92
          Width = 145
          Height = 17
          Hint = 'Plot a new histogram'
          Caption = 'New Histogram'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = bNewHistogramClick
        end
        object GroupBox3: TGroupBox
          Left = 8
          Top = 136
          Width = 145
          Height = 177
          Caption = ' Histogram  '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object Label11: TLabel
            Left = 32
            Top = 48
            Width = 59
            Height = 15
            Alignment = taRightJustify
            Caption = 'No. of bins'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label18: TLabel
            Left = 24
            Top = 88
            Width = 34
            Height = 15
            Alignment = taRightJustify
            Caption = 'Lower'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label19: TLabel
            Left = 24
            Top = 112
            Width = 34
            Height = 15
            Alignment = taRightJustify
            Caption = 'Upper'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label8: TLabel
            Left = 48
            Top = 72
            Width = 37
            Height = 15
            Caption = 'Range'
          end
          object cbHistVariable: TComboBox
            Left = 8
            Top = 19
            Width = 129
            Height = 23
            Hint = 'Variable to be used to compile histogram'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnChange = cbHistVariableChange
          end
          object edNumBins: TValidatedEdit
            Left = 96
            Top = 48
            Width = 41
            Height = 20
            AutoSize = False
            Text = ' 50 '
            Value = 50.000000000000000000
            Scale = 1.000000000000000000
            NumberFormat = '%.0f'
            LoLimit = 2.000000000000000000
            HiLimit = 512.000000000000000000
          end
          object edHistMin: TValidatedEdit
            Left = 64
            Top = 88
            Width = 73
            Height = 20
            AutoSize = False
            Text = ' 0 '
            Scale = 1.000000000000000000
            NumberFormat = '%.3g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
          object edHistMax: TValidatedEdit
            Left = 64
            Top = 112
            Width = 73
            Height = 20
            AutoSize = False
            Text = ' 0 '
            Scale = 1.000000000000000000
            NumberFormat = '%.3g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
          object ckPercentage: TCheckBox
            Left = 8
            Top = 136
            Width = 97
            Height = 17
            Caption = 'Percentage'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
          object ckCumulative: TCheckBox
            Left = 8
            Top = 152
            Width = 81
            Height = 17
            Caption = 'Cumulative'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
          end
        end
        object bSetHistAxes: TButton
          Left = 8
          Top = 112
          Width = 145
          Height = 17
          Hint = 'Set X & Y axis range and labels'
          Caption = 'Set Axes'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = bSetHistAxesClick
        end
      end
    end
    object SummaryTab: TTabSheet
      Caption = 'Summary'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Summary: TStringGrid
        Left = 171
        Top = 4
        Width = 449
        Height = 313
        DefaultRowHeight = 18
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ColWidths = (
          64
          64
          64
          64
          64)
        RowHeights = (
          18
          18
          18
          18
          18)
      end
      object SummaryGrp: TGroupBox
        Left = 4
        Top = 4
        Width = 161
        Height = 401
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object VariablesGrp: TGroupBox
          Left = 8
          Top = 96
          Width = 145
          Height = 241
          Hint = 'Variables to be included in summary'
          Caption = ' Variables '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          object ckVariable0: TCheckBox
            Left = 8
            Top = 16
            Width = 97
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = ckVariable0Click
          end
          object ckVariable1: TCheckBox
            Left = 8
            Top = 32
            Width = 97
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = ckVariable0Click
          end
          object ckVariable2: TCheckBox
            Left = 8
            Top = 48
            Width = 97
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 2
            OnClick = ckVariable0Click
          end
          object ckVariable3: TCheckBox
            Left = 8
            Top = 64
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 3
            OnClick = ckVariable0Click
          end
          object ckVariable4: TCheckBox
            Left = 8
            Top = 80
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 4
            OnClick = ckVariable0Click
          end
          object ckVariable5: TCheckBox
            Left = 8
            Top = 96
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 5
            OnClick = ckVariable0Click
          end
          object ckVariable6: TCheckBox
            Left = 8
            Top = 112
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 6
            OnClick = ckVariable0Click
          end
          object ckVariable7: TCheckBox
            Left = 8
            Top = 128
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 7
            OnClick = ckVariable0Click
          end
          object ckVariable8: TCheckBox
            Left = 8
            Top = 144
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 8
          end
          object ckVariable9: TCheckBox
            Left = 8
            Top = 160
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 9
            OnClick = ckVariable0Click
          end
          object ckVariable10: TCheckBox
            Left = 8
            Top = 176
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 10
            OnClick = ckVariable0Click
          end
        end
      end
    end
    object TablesTab: TTabSheet
      Caption = 'Tables'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Table: TStringGrid
        Left = 172
        Top = 4
        Width = 561
        Height = 337
        ColCount = 8
        DefaultColWidth = 100
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 20
        FixedRows = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnMouseDown = TableMouseDown
        ColWidths = (
          92
          100
          100
          100
          100
          100
          100
          100)
        RowHeights = (
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18)
      end
      object GroupBox2: TGroupBox
        Left = 4
        Top = 4
        Width = 161
        Height = 497
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object bClearTable: TButton
          Left = 8
          Top = 448
          Width = 145
          Height = 17
          Caption = 'ClearTable'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = bClearTableClick
        end
        object GroupBox11: TGroupBox
          Left = 8
          Top = 80
          Width = 145
          Height = 361
          Hint = 'Waveform measurements to be included in summary'
          Caption = ' Variables '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          object ckTabVar0: TCheckBox
            Left = 8
            Top = 16
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = ckVariable0Click
          end
          object ckTabVar1: TCheckBox
            Tag = 1
            Left = 8
            Top = 32
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = ckVariable0Click
          end
          object ckTabVar2: TCheckBox
            Tag = 2
            Left = 8
            Top = 48
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 2
            OnClick = ckVariable0Click
          end
          object ckTabVar3: TCheckBox
            Tag = 3
            Left = 8
            Top = 64
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 3
            OnClick = ckVariable0Click
          end
          object ckTabVar4: TCheckBox
            Left = 8
            Top = 80
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 4
            OnClick = ckVariable0Click
          end
          object ckTabVar5: TCheckBox
            Left = 8
            Top = 96
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 5
            OnClick = ckVariable0Click
          end
          object ckTabVar6: TCheckBox
            Left = 8
            Top = 112
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 6
            OnClick = ckVariable0Click
          end
          object ckTabVar7: TCheckBox
            Left = 8
            Top = 128
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 7
            OnClick = ckVariable0Click
          end
          object ckTabVar8: TCheckBox
            Left = 8
            Top = 144
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 8
            OnClick = ckVariable0Click
          end
          object ckTabVar9: TCheckBox
            Left = 8
            Top = 160
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 9
            OnClick = ckVariable0Click
          end
          object ckTabVar10: TCheckBox
            Left = 8
            Top = 176
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 10
            OnClick = ckVariable0Click
          end
          object bAddVariable: TButton
            Left = 8
            Top = 204
            Width = 129
            Height = 18
            Caption = 'Add Variables'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 11
            OnClick = bAddVariableClick
          end
          object bClearAllTableVariables: TButton
            Left = 8
            Top = 226
            Width = 60
            Height = 18
            Caption = 'Clear All'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 12
            OnClick = bClearAllTableVariablesClick
          end
          object bSet: TButton
            Left = 8
            Top = 248
            Width = 60
            Height = 18
            Caption = 'Set All'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 13
            OnClick = bSetClick
          end
          object BadFitsGrp: TGroupBox
            Left = 12
            Top = 272
            Width = 125
            Height = 80
            Caption = ' Bad fits '
            TabOrder = 14
            object Label3: TLabel
              Left = 9
              Top = 34
              Width = 72
              Height = 15
              Caption = 'Bad data flag'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object ckIncludeBadFits: TCheckBox
              Left = 8
              Top = 12
              Width = 65
              Height = 23
              Caption = 'Include'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object edBadFitFlag: TValidatedEdit
              Left = 8
              Top = 50
              Width = 49
              Height = 20
              AutoSize = False
              Text = ' 0.0 '
              Scale = 1.000000000000000000
              NumberFormat = '%.1f'
              LoLimit = -1.000000015047466E30
              HiLimit = 1.000000015047466E30
            end
          end
        end
        object bSaveTableToFile: TButton
          Left = 8
          Top = 472
          Width = 145
          Height = 17
          Caption = 'Save to File'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = bSaveTableToFileClick
        end
      end
    end
  end
  object RecordsGrp: TGroupBox
    Left = 22
    Top = 32
    Width = 147
    Height = 73
    Caption = ' Records '
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    object Label12: TLabel
      Left = 49
      Top = 46
      Width = 25
      Height = 15
      Alignment = taRightJustify
      Caption = 'Type'
    end
    object edPlotRecType: TEdit
      Left = 80
      Top = 46
      Width = 57
      Height = 20
      AutoSize = False
      ReadOnly = True
      TabOrder = 0
      Text = 'edRecordType'
    end
    object edPlotRange: TRangeEdit
      Left = 8
      Top = 20
      Width = 129
      Height = 20
      OnKeyPress = edPlotRangeKeyPress
      AutoSize = False
      Text = ' 0.00 - 1.00000001504746622E30 '
      HiValue = 1.000000015047466E30
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.f - %.f'
    end
  end
  object SaveDialog: TSaveDialog
    Left = 8
    Top = 552
  end
end
