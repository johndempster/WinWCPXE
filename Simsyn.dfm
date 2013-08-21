object SynapseSim: TSynapseSim
  Left = 529
  Top = 187
  Caption = 'Nerve-evoked EPSC Simulation'
  ClientHeight = 509
  ClientWidth = 560
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object scDisplay: TScopeDisplay
    Left = 222
    Top = 6
    Width = 323
    Height = 193
    OnCursorChange = scDisplayCursorChange
    CursorChangeInProgress = False
    NumChannels = 1
    NumPoints = 1024
    MaxPoints = 1024
    XMin = 0
    XMax = 1023
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
  object REleasegrp: TGroupBox
    Left = 8
    Top = 264
    Width = 209
    Height = 73
    Caption = ' Transmitter Release '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label6: TLabel
      Left = 44
      Top = 24
      Width = 92
      Height = 15
      Alignment = taRightJustify
      Caption = 'Release pool (n)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbP: TLabel
      Left = 40
      Top = 48
      Width = 96
      Height = 15
      Alignment = taRightJustify
      Caption = 'Release prob. (p)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edPoolSize: TValidatedEdit
      Left = 144
      Top = 21
      Width = 57
      Height = 20
      OnKeyPress = edPoolSizeKeyPress
      AutoSize = False
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
    end
    object edReleaseProbability: TValidatedEdit
      Left = 144
      Top = 45
      Width = 57
      Height = 20
      AutoSize = False
      Text = ' 1.000 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.3f'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000000000000000
    end
  end
  object QuantumGrp: TGroupBox
    Left = 8
    Top = 344
    Width = 537
    Height = 145
    Caption = ' Quantal event properties '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object GroupBox3: TGroupBox
      Left = 328
      Top = 16
      Width = 201
      Height = 113
      Caption = ' Decay phase '
      TabOrder = 0
      object Label3: TLabel
        Left = 13
        Top = 16
        Width = 111
        Height = 15
        Alignment = taRightJustify
        Caption = 'Decay time constant'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object ckDoubleExponentialDecay: TCheckBox
        Left = 16
        Top = 40
        Width = 177
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Double exponential decay'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = ckDoubleExponentialDecayClick
      end
      object edTau1: TValidatedEdit
        Left = 128
        Top = 16
        Width = 65
        Height = 20
        AutoSize = False
        Text = ' 10 ms'
        Value = 0.009999999776482582
        Scale = 1000.000000000000000000
        Units = 'ms'
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object SlowPanel: TPanel
        Left = 24
        Top = 58
        Width = 169
        Height = 49
        BevelOuter = bvNone
        TabOrder = 2
        object lbTau2: TLabel
          Left = 49
          Top = 1
          Width = 57
          Height = 15
          Alignment = taRightJustify
          Caption = 'Tau (slow)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object lbRatio: TLabel
          Left = 28
          Top = 26
          Width = 78
          Height = 15
          Alignment = taRightJustify
          Caption = '% Slow Decay'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object edTau2: TValidatedEdit
          Left = 112
          Top = 1
          Width = 57
          Height = 20
          AutoSize = False
          Text = ' 50 ms'
          Value = 0.050000000745058060
          Scale = 1000.000000000000000000
          Units = 'ms'
          NumberFormat = '%.3g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edSlowDecayFraction: TValidatedEdit
          Left = 112
          Top = 25
          Width = 57
          Height = 20
          AutoSize = False
          Text = ' 10 %'
          Value = 0.100000001490116100
          Scale = 100.000000000000000000
          Units = '%'
          NumberFormat = '%.3g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000000000000000
        end
      end
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 16
      Width = 161
      Height = 113
      Caption = ' Amplitude '
      TabOrder = 1
      object Label1: TLabel
        Left = 62
        Top = 16
        Width = 28
        Height = 15
        Alignment = taRightJustify
        Caption = 'Peak'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 50
        Top = 40
        Width = 40
        Height = 15
        Alignment = taRightJustify
        Caption = 'St. Dev.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 8
        Top = 64
        Width = 82
        Height = 41
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Background noise (R.M.S.)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object edQuantumAmplitude: TValidatedEdit
        Left = 96
        Top = 13
        Width = 57
        Height = 20
        OnKeyPress = edQuantumAmplitudeKeyPress
        AutoSize = False
        Text = ' 1 pA'
        Value = 1.000000000000000000
        Scale = 1.000000000000000000
        Units = 'pA'
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edQuantumStDev: TValidatedEdit
        Left = 96
        Top = 37
        Width = 57
        Height = 20
        AutoSize = False
        Text = ' 0 '
        Scale = 1.000000000000000000
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edNoiseRMS: TValidatedEdit
        Left = 96
        Top = 61
        Width = 57
        Height = 20
        AutoSize = False
        Text = ' 0.1 '
        Value = 0.100000001490116100
        Scale = 1.000000000000000000
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object GroupBox5: TGroupBox
      Left = 176
      Top = 16
      Width = 145
      Height = 113
      Caption = ' Rising phase '
      TabOrder = 2
      object Label11: TLabel
        Left = 20
        Top = 24
        Width = 57
        Height = 15
        Alignment = taRightJustify
        Caption = 'Tau (Rise)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 8
        Top = 48
        Width = 68
        Height = 33
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Latency variability'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object edTauRise: TValidatedEdit
        Left = 80
        Top = 21
        Width = 57
        Height = 20
        AutoSize = False
        Text = ' 0.2 ms'
        Value = 0.000200000009499490
        Scale = 1000.000000000000000000
        Units = 'ms'
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edLatency: TValidatedEdit
        Left = 80
        Top = 45
        Width = 57
        Height = 20
        AutoSize = False
        Text = ' 0 ms'
        Scale = 1000.000000000000000000
        Units = 'ms'
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 209
    Height = 257
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object GroupBox2: TGroupBox
      Left = 8
      Top = 182
      Width = 193
      Height = 65
      TabOrder = 0
      object Label8: TLabel
        Left = 8
        Top = 24
        Width = 97
        Height = 33
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Resting/holding potential'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object rbPotentials: TRadioButton
        Left = 80
        Top = 8
        Width = 73
        Height = 17
        Hint = 'Create simulated potentials (with non-linear summation)'
        Caption = 'Potentials'
        TabOrder = 0
        OnClick = rbPotentialsClick
      end
      object rbCurrents: TRadioButton
        Left = 8
        Top = 8
        Width = 73
        Height = 17
        Hint = 'Create simulated currents'
        Caption = 'Currents'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
        OnClick = rbCurrentsClick
      end
      object edVRest: TValidatedEdit
        Left = 112
        Top = 29
        Width = 76
        Height = 20
        AutoSize = False
        Text = ' 0.0 mV'
        Scale = 1.000000000000000000
        Units = 'mV'
        NumberFormat = '%.1f'
        LoLimit = -200.000000000000000000
        HiLimit = 200.000000000000000000
      end
    end
    object bStart: TButton
      Left = 8
      Top = 12
      Width = 193
      Height = 20
      Hint = 'Start generating simulated records'
      Caption = 'Start Simulation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = bStartClick
    end
    object bAbort: TButton
      Left = 8
      Top = 36
      Width = 65
      Height = 17
      Hint = 'Abort simulation run'
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = bAbortClick
    end
    object GroupBox6: TGroupBox
      Left = 8
      Top = 60
      Width = 193
      Height = 117
      TabOrder = 3
      object Label7: TLabel
        Left = 39
        Top = 16
        Width = 69
        Height = 15
        Alignment = taRightJustify
        Caption = 'No. Records'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 18
        Top = 40
        Width = 90
        Height = 15
        Alignment = taRightJustify
        Caption = 'Record Duration'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 27
        Top = 88
        Width = 81
        Height = 15
        Alignment = taRightJustify
        Caption = 'Display Range'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 36
        Top = 64
        Width = 72
        Height = 15
        Alignment = taRightJustify
        Caption = 'No. Samples'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edNumRecords: TValidatedEdit
        Left = 112
        Top = 16
        Width = 75
        Height = 20
        AutoSize = False
        Text = ' 100 '
        Value = 100.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%g'
        LoLimit = 1.000000000000000000
        HiLimit = 1.000000015047466E30
      end
      object edRecordDuration: TValidatedEdit
        Left = 112
        Top = 40
        Width = 75
        Height = 20
        AutoSize = False
        Text = ' 100 ms'
        Value = 0.100000001490116100
        Scale = 1000.000000000000000000
        Units = 'ms'
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edDisplayRange: TValidatedEdit
        Left = 112
        Top = 88
        Width = 75
        Height = 20
        OnKeyPress = edDisplayRangeKeyPress
        AutoSize = False
        Text = ' 10 pA'
        Value = 10.000000000000000000
        Scale = 1.000000000000000000
        Units = 'pA'
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edNumSamples: TValidatedEdit
        Left = 112
        Top = 64
        Width = 75
        Height = 20
        Hint = 'No. of sample points per record'
        OnKeyPress = edNumSamplesKeyPress
        AutoSize = False
        Text = ' 512 '
        Value = 512.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%.0f'
        LoLimit = 256.000000000000000000
        HiLimit = 1.000000015047466E30
      end
    end
  end
end
