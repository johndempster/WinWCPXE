object MeasureFrm: TMeasureFrm
  Left = 829
  Top = 41
  Caption = 'Waveform Analysis '
  ClientHeight = 634
  ClientWidth = 758
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
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Page: TPageControl
    Left = 2
    Top = 2
    Width = 639
    Height = 631
    ActivePage = XYPlotTab
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = PageChange
    object AnalysisTab: TTabSheet
      Caption = 'Analysis'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object scDisplay: TScopeDisplay
        Left = 148
        Top = 6
        Width = 461
        Height = 305
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
        FixZeroLevels = False
        DisplaySelected = False
        FontSize = 8
      end
      object RecordGrp: TGroupBox
        Left = 4
        Top = 4
        Width = 135
        Height = 108
        Caption = ' Record'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label2: TLabel
          Left = 33
          Top = 60
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
        object cbRecordType: TComboBox
          Left = 64
          Top = 60
          Width = 65
          Height = 23
          Hint = 'Type of record currently on display'
          Style = csDropDownList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = cbRecordTypeChange
        end
        object ckBadRecord: TCheckBox
          Left = 8
          Top = 84
          Width = 81
          Height = 17
          Hint = 'Rejected records are exclude from the analysis'
          Caption = 'Rejected'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = ckBadRecordClick
        end
        object sbRecordNum: TScrollBar
          Left = 8
          Top = 38
          Width = 120
          Height = 17
          PageSize = 0
          TabOrder = 2
          OnChange = sbRecordNumChange
        end
        object edRecordNum: TRangeEdit
          Left = 8
          Top = 16
          Width = 120
          Height = 20
          OnKeyPress = edRecordNumKeyPress
          AutoSize = False
          Text = ' 0 / 1.00000001504746624E30 '
          HiValue = 1.000000015047466E30
          HiLimit = 1.000000015047466E30
          Scale = 1.000000000000000000
          NumberFormat = '%.0f / %.0f'
        end
      end
      object AnalysisGrp: TGroupBox
        Left = 4
        Top = 116
        Width = 135
        Height = 485
        Caption = ' Analyse '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object bDoAnalysis: TButton
          Left = 8
          Top = 16
          Width = 120
          Height = 19
          Hint = 'Start waveform analysis'
          Caption = 'Do Analysis'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = bDoAnalysisClick
        end
        object bAbort: TButton
          Left = 8
          Top = 37
          Width = 49
          Height = 17
          Caption = 'Abort'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = bAbortClick
        end
        object GroupBox8: TGroupBox
          Left = 8
          Top = 54
          Width = 120
          Height = 85
          TabOrder = 2
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
          end
          object rbThisRecord: TRadioButton
            Left = 8
            Top = 24
            Width = 81
            Height = 17
            Hint = 'Analyse the currently displayed record only'
            Caption = 'This record'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
          end
          object rbRange: TRadioButton
            Left = 8
            Top = 40
            Width = 81
            Height = 17
            Hint = 'Analysis a limited range of records within the data file'
            Caption = 'Range'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
          end
          object edRecRange: TRangeEdit
            Left = 24
            Top = 56
            Width = 89
            Height = 20
            AutoSize = False
            Text = ' 0.00 - 1.00000001504746624E30 '
            HiValue = 1.000000015047466E30
            HiLimit = 1.000000015047466E30
            Scale = 1.000000000000000000
            NumberFormat = '%.f - %.f'
          end
        end
        object GroupBox4: TGroupBox
          Left = 8
          Top = 182
          Width = 121
          Height = 65
          Caption = ' Peak  '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          object Label4: TLabel
            Left = 17
            Top = 40
            Width = 66
            Height = 15
            Alignment = taRightJustify
            Caption = 'Points Avgd.'
          end
          object cbPeakMode: TComboBox
            Left = 6
            Top = 13
            Width = 107
            Height = 23
            Hint = 
              'Type of peak amplitude to be searched for during waveform analys' +
              'is'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnChange = cbPeakModeChange
            Items.Strings = (
              'Absolute'
              'Positive'
              'Negative')
          end
          object edPeakAvg: TValidatedEdit
            Left = 88
            Top = 40
            Width = 25
            Height = 20
            Hint = 'No. of points to be averaged  at signal peak amplitude'
            OnKeyPress = edPeakAvgKeyPress
            AutoSize = False
            Text = ' 0 '
            Scale = 1.000000000000000000
            NumberFormat = '%.0f'
            LoLimit = -20.000000000000000000
            HiLimit = 20.000000000000000000
          end
        end
        object GroupBox5: TGroupBox
          Left = 8
          Top = 248
          Width = 121
          Height = 44
          Caption = ' Rate of rise '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          object cbRateofRiseMode: TComboBox
            Left = 6
            Top = 16
            Width = 107
            Height = 23
            Hint = 'Algorithm used to compute rate of rise'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnChange = cbRateofRiseModeChange
            Items.Strings = (
              'Forward Diff.'
              'Quadratic (5)'
              'Quadratic (7)')
          end
        end
        object GroupBox6: TGroupBox
          Left = 8
          Top = 140
          Width = 121
          Height = 41
          Caption = ' Type '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          object cbTypeToBeAnalysed: TComboBox
            Left = 8
            Top = 13
            Width = 105
            Height = 23
            Hint = 'Type of record to be used in analysis'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
        end
        object GroupBox7: TGroupBox
          Left = 8
          Top = 296
          Width = 121
          Height = 44
          Caption = ' Rise time '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          object edRiseTime: TRangeEdit
            Left = 8
            Top = 16
            Width = 105
            Height = 20
            Hint = 'Fraction of signal rising edge used to calculated rise time'
            AutoSize = False
            ShowHint = True
            Text = '  10.00 - 90.00 %'
            LoValue = 0.100000001490116100
            HiValue = 0.899999976158142100
            HiLimit = 100.000000000000000000
            Scale = 100.000000000000000000
            Units = '%'
            NumberFormat = ' %.f - %.f'
          end
        end
        object GroupBox9: TGroupBox
          Left = 8
          Top = 344
          Width = 121
          Height = 45
          Caption = ' T.x% decay time '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          object Label1: TLabel
            Left = 33
            Top = 16
            Width = 16
            Height = 15
            Alignment = taRightJustify
            Caption = 'x%'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object edDecayTimePercentage: TValidatedEdit
            Left = 56
            Top = 16
            Width = 57
            Height = 20
            Hint = 'Wave decay time end-point (% fall from peak amplitude'
            OnKeyPress = edDecayTimePercentageKeyPress
            AutoSize = False
            ShowHint = True
            Text = ' 1.0 %'
            Value = 1.000000000000000000
            Scale = 1.000000000000000000
            Units = '%'
            NumberFormat = '%.1f'
            LoLimit = 1.000000000000000000
            HiLimit = 90.000000000000000000
          end
        end
        object GroupBox12: TGroupBox
          Left = 8
          Top = 392
          Width = 121
          Height = 81
          Caption = ' Cursors '
          TabOrder = 8
          object bGetCursors: TButton
            Left = 8
            Top = 16
            Width = 105
            Height = 19
            Hint = 'Move all cursors on to displayed region of signal record'
            Caption = 'Get Cursors'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = bGetCursorsClick
          end
          object ckLockChannelCursors: TCheckBox
            Left = 8
            Top = 38
            Width = 105
            Height = 17
            Hint = 'Lock cursors for all input channels together'
            Caption = 'Lock Channels'
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 1
            OnClick = ckLockChannelCursorsClick
          end
        end
      end
      object ResultsGrp: TGroupBox
        Left = 148
        Top = 320
        Width = 465
        Height = 201
        Caption = ' Results '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object sgResults: TStringGrid
          Left = 8
          Top = 16
          Width = 449
          Height = 177
          ColCount = 7
          DefaultColWidth = 80
          DefaultRowHeight = 16
          RowCount = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          RowHeights = (
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16)
        end
      end
      object ckFixedZeroLevels: TCheckBox
        Left = 224
        Top = 310
        Width = 102
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
        Left = 152
        Top = 8
        Width = 401
        Height = 137
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
        Width = 135
        Height = 585
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
          Width = 119
          Height = 17
          Hint = 'Plot a new graph'
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
          Top = 136
          Width = 121
          Height = 81
          Hint = 'Waveform measurement to be plotted along X axis'
          Caption = ' X Axis '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          object Label15: TLabel
            Left = 8
            Top = 44
            Width = 19
            Height = 15
            Caption = 'Ch.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object cbXVariable: TComboBox
            Left = 8
            Top = 16
            Width = 105
            Height = 23
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
          end
          object cbXChannel: TComboBox
            Left = 32
            Top = 44
            Width = 81
            Height = 23
            Hint = 'Input channel'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
          end
        end
        object YGroup: TGroupBox
          Left = 8
          Top = 220
          Width = 121
          Height = 269
          Hint = 'Waveform measurement to be plotted along Y axis'
          Caption = ' Y Axis '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          object cbYVariable: TComboBox
            Left = 8
            Top = 16
            Width = 105
            Height = 23
            Style = csDropDownList
            TabOrder = 0
            OnChange = cbYVariableChange
          end
          object PanConductance: TPanel
            Left = 8
            Top = 44
            Width = 105
            Height = 221
            BevelOuter = bvNone
            TabOrder = 1
            object Label3: TLabel
              Left = 2
              Top = 2
              Width = 69
              Height = 15
              Caption = 'Current from'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 2
              Top = 48
              Width = 19
              Height = 15
              Caption = 'Ch.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 2
              Top = 74
              Width = 68
              Height = 15
              Caption = 'Voltage from'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label7: TLabel
              Left = 2
              Top = 120
              Width = 19
              Height = 15
              Caption = 'Ch.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 2
              Top = 150
              Width = 73
              Height = 15
              Caption = 'Reversal Pot.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label9: TLabel
              Left = 24
              Top = 194
              Width = 29
              Height = 15
              Alignment = taRightJustify
              Caption = 'Units'
            end
            object cbCondIVar: TComboBox
              Left = 2
              Top = 18
              Width = 102
              Height = 23
              Hint = 'Input channel'
              Style = csDropDownList
              ParentShowHint = False
              ShowHint = False
              TabOrder = 0
            end
            object cbCondIChan: TComboBox
              Left = 24
              Top = 48
              Width = 78
              Height = 23
              Hint = 'Input channel'
              Style = csDropDownList
              ParentShowHint = False
              ShowHint = False
              TabOrder = 1
            end
            object cbCondVVar: TComboBox
              Left = 2
              Top = 90
              Width = 102
              Height = 23
              Hint = 'Input channel'
              Style = csDropDownList
              ParentShowHint = False
              ShowHint = False
              TabOrder = 2
            end
            object cbCondVChan: TComboBox
              Left = 24
              Top = 120
              Width = 78
              Height = 23
              Hint = 'Input channel'
              Style = csDropDownList
              ParentShowHint = False
              ShowHint = False
              TabOrder = 3
            end
            object edVRev: TValidatedEdit
              Left = 2
              Top = 168
              Width = 102
              Height = 21
              AutoSize = False
              Text = ' 0 mV'
              Scale = 1000.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -1.000000015047466E30
              HiLimit = 1.000000015047466E30
            end
            object cbCondUnits: TComboBox
              Left = 56
              Top = 194
              Width = 49
              Height = 23
              Style = csDropDownList
              ItemIndex = 1
              TabOrder = 5
              Text = 'nS'
              Items.Strings = (
                'pS'
                'nS'
                'uS'
                'mS'
                'S')
            end
          end
          object PanVar: TPanel
            Left = 8
            Top = 44
            Width = 105
            Height = 41
            BevelOuter = bvNone
            TabOrder = 2
            object Label16: TLabel
              Left = 2
              Top = 2
              Width = 19
              Height = 15
              Caption = 'Ch.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object cbYChannel: TComboBox
              Left = 24
              Top = 2
              Width = 78
              Height = 23
              Hint = 'Input channel'
              Style = csDropDownList
              ParentShowHint = False
              ShowHint = False
              TabOrder = 0
            end
          end
        end
        object bSetPlotAxes: TButton
          Left = 8
          Top = 112
          Width = 119
          Height = 17
          Hint = 'Set X and Y axes type, range and labels'
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
          Top = 498
          Width = 121
          Height = 47
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
            Width = 105
            Height = 17
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
      object XYFitGrp: TGroupBox
        Left = 152
        Top = 177
        Width = 417
        Height = 168
        Caption = ' Analysis '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object bXYFit: TButton
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
          OnClick = bXYFitClick
        end
        object cbXYEquation: TComboBox
          Left = 8
          Top = 36
          Width = 105
          Height = 23
          Style = csDropDownList
          TabOrder = 1
          Items.Strings = (
            'None'
            'Gaussian'
            '2 Gaussians'
            '3 Gaussians')
        end
        object erXYResults: TRichEdit
          Left = 120
          Top = 16
          Width = 289
          Height = 145
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '')
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 2
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
        Left = 152
        Top = 8
        Width = 449
        Height = 193
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
      object HistGrp: TGroupBox
        Left = 4
        Top = 4
        Width = 135
        Height = 457
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
          Width = 113
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
          Width = 121
          Height = 273
          Caption = ' Histogram  '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          object Label10: TLabel
            Left = 8
            Top = 43
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
          object Label11: TLabel
            Left = 22
            Top = 88
            Width = 46
            Height = 15
            Alignment = taRightJustify
            Caption = 'No. bins'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object cbHistVariable: TComboBox
            Left = 8
            Top = 19
            Width = 105
            Height = 23
            Hint = 'Waveform measurement to used to compile histogram'
            Style = csDropDownList
            TabOrder = 0
            OnChange = cbHistVariableChange
          end
          object cbHistChannel: TComboBox
            Left = 8
            Top = 59
            Width = 105
            Height = 23
            Hint = 'Input channel to take measurement from'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
          end
          object edNumBins: TValidatedEdit
            Left = 72
            Top = 88
            Width = 41
            Height = 20
            AutoSize = False
            Text = ' 50 '
            Value = 50.000000000000000000
            Scale = 1.000000000000000000
            NumberFormat = '%.0f'
            LoLimit = 2.000000000000000000
            HiLimit = 1024.000000000000000000
          end
          object ckPercentage: TCheckBox
            Left = 8
            Top = 232
            Width = 97
            Height = 17
            Caption = 'Percentage'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
          object ckCumulative: TCheckBox
            Left = 8
            Top = 248
            Width = 81
            Height = 17
            Caption = 'Cumulative'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
          object GroupBox10: TGroupBox
            Left = 8
            Top = 112
            Width = 105
            Height = 113
            Caption = ' Range '
            TabOrder = 5
            object Label18: TLabel
              Left = 8
              Top = 18
              Width = 56
              Height = 14
              Caption = 'Lower Limit'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label19: TLabel
              Left = 8
              Top = 60
              Width = 49
              Height = 14
              Caption = 'Upper limit'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object edHistMin: TValidatedEdit
              Left = 8
              Top = 33
              Width = 89
              Height = 20
              AutoSize = False
              Text = ' 0 '
              Scale = 1.000000000000000000
              NumberFormat = '%.4g'
              LoLimit = -1.000000015047466E30
              HiLimit = 1.000000015047466E30
            end
            object edHistMax: TValidatedEdit
              Left = 8
              Top = 77
              Width = 89
              Height = 20
              AutoSize = False
              Text = ' 0 '
              Scale = 1.000000000000000000
              NumberFormat = '%.4g'
              LoLimit = -1.000000015047466E30
              HiLimit = 1.000000015047466E30
            end
          end
        end
        object bSetHistAxes: TButton
          Left = 8
          Top = 112
          Width = 113
          Height = 17
          Hint = 'Set X and Y axes type, range and labels'
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
      object HistFitGrp: TGroupBox
        Left = 152
        Top = 289
        Width = 417
        Height = 168
        Caption = ' Analysis '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object bHistFit: TButton
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
          OnClick = bHistFitClick
        end
        object cbHistEquation: TComboBox
          Left = 8
          Top = 36
          Width = 105
          Height = 23
          Style = csDropDownList
          TabOrder = 1
          Items.Strings = (
            'None'
            'Gaussian'
            '2 Gaussians'
            '3 Gaussians')
        end
        object erHistResults: TRichEdit
          Left = 120
          Top = 16
          Width = 289
          Height = 145
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '')
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 2
        end
      end
    end
    object SummaryTab: TTabSheet
      Caption = 'Summary'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SummaryGrp: TGroupBox
        Left = 4
        Top = 4
        Width = 135
        Height = 409
        ParentCustomHint = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object VariablesGrp: TGroupBox
          Left = 8
          Top = 88
          Width = 121
          Height = 313
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
          TabOrder = 0
          object ckVariable0: TCheckBox
            Left = 8
            Top = 48
            Width = 97
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = ckVariable0Click
          end
          object ckVariable1: TCheckBox
            Tag = 1
            Left = 8
            Top = 64
            Width = 97
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = ckVariable0Click
          end
          object ckVariable2: TCheckBox
            Tag = 2
            Left = 8
            Top = 80
            Width = 97
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 2
            OnClick = ckVariable0Click
          end
          object ckVariable3: TCheckBox
            Tag = 3
            Left = 8
            Top = 96
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
            Top = 112
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
            Top = 128
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
            Top = 144
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
            Top = 160
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
            Top = 176
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 8
            OnClick = ckVariable0Click
          end
          object ckVariable9: TCheckBox
            Left = 8
            Top = 192
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
            Top = 208
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 10
            OnClick = ckVariable0Click
          end
          object ckVariable11: TCheckBox
            Left = 8
            Top = 224
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 11
            OnClick = ckVariable0Click
          end
          object ckVariable12: TCheckBox
            Left = 8
            Top = 240
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 12
            OnClick = ckVariable0Click
          end
          object ckVariable13: TCheckBox
            Left = 8
            Top = 256
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 13
            OnClick = ckVariable0Click
          end
          object cbSummaryChannel: TComboBox
            Left = 8
            Top = 18
            Width = 105
            Height = 23
            Hint = 'Input channel to be summarised'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 14
            Text = 'cbSummaryChannel'
            OnChange = cbSummaryChannelChange
          end
          object ckVariable14: TCheckBox
            Left = 8
            Top = 272
            Width = 89
            Height = 17
            Caption = 'ckVariable14'
            Checked = True
            State = cbChecked
            TabOrder = 15
            OnClick = ckVariable0Click
          end
        end
      end
      object Summary: TStringGrid
        Left = 145
        Top = 3
        Width = 449
        Height = 313
        DefaultRowHeight = 18
        FixedCols = 0
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
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
    end
    object TablesTab: TTabSheet
      Caption = 'Tables'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Table: TStringGrid
        Left = 145
        Top = 4
        Width = 453
        Height = 305
        Hint = 'Double-click at top of a column to change its contents'
        ColCount = 1
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
        ColWidths = (
          95)
      end
      object GroupBox2: TGroupBox
        Left = 4
        Top = 4
        Width = 135
        Height = 517
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object bClearTable: TButton
          Left = 6
          Top = 464
          Width = 122
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
          Left = 6
          Top = 89
          Width = 122
          Height = 369
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
            Top = 48
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
            Top = 64
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
            Top = 80
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
            Top = 96
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
            Top = 112
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
            Top = 128
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
            Top = 144
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
            Top = 160
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
            Top = 176
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
            Top = 192
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
            Top = 208
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 10
            OnClick = ckVariable0Click
          end
          object ckTabVar11: TCheckBox
            Left = 8
            Top = 224
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 11
            OnClick = ckVariable0Click
          end
          object ckTabVar12: TCheckBox
            Left = 8
            Top = 240
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 12
            OnClick = ckVariable0Click
          end
          object ckTabVar13: TCheckBox
            Left = 8
            Top = 256
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 13
            OnClick = ckVariable0Click
          end
          object bAddVariable: TButton
            Left = 8
            Top = 300
            Width = 106
            Height = 18
            Caption = 'Add Variable'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 14
            OnClick = bAddVariableClick
          end
          object cbTableChannel: TComboBox
            Left = 8
            Top = 18
            Width = 89
            Height = 23
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 15
          end
          object bClearAllTableVariables: TButton
            Left = 8
            Top = 322
            Width = 106
            Height = 18
            Caption = 'Clear All'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 16
            OnClick = bClearAllTableVariablesClick
          end
          object bSet: TButton
            Left = 8
            Top = 344
            Width = 106
            Height = 18
            Caption = 'Set All'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 17
            OnClick = bSetClick
          end
          object ckTabVar14: TCheckBox
            Tag = 14
            Left = 8
            Top = 272
            Width = 89
            Height = 17
            Caption = 'ckVariable0'
            Checked = True
            State = cbChecked
            TabOrder = 18
            OnClick = ckVariable0Click
          end
        end
        object bSaveTableToFile: TButton
          Left = 6
          Top = 488
          Width = 122
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
    Left = 176
    Top = 368
    Width = 121
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
      Left = 41
      Top = 41
      Width = 25
      Height = 15
      Alignment = taRightJustify
      Caption = 'Type'
    end
    object edPlotRecType: TEdit
      Left = 72
      Top = 41
      Width = 41
      Height = 20
      AutoSize = False
      ReadOnly = True
      TabOrder = 0
      Text = 'edRecordType'
    end
    object edPlotRange: TRangeEdit
      Left = 8
      Top = 16
      Width = 105
      Height = 20
      OnKeyPress = edPlotRangeKeyPress
      AutoSize = False
      Text = ' 1.00 - 1.00000001504746624E30 '
      LoValue = 1.000000000000000000
      HiValue = 1.000000015047466E30
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.f - %.f'
    end
  end
  object SaveDialog: TSaveDialog
    Left = 152
    Top = 576
  end
end
