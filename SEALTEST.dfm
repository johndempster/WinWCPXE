object SealTestFrm: TSealTestFrm
  Left = 433
  Top = 186
  Caption = 'Pipette Seal Test / Signal Monitor'
  ClientHeight = 655
  ClientWidth = 730
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object scDisplay: TScopeDisplay
    Left = 160
    Top = 6
    Width = 425
    Height = 289
    OnCursorChange = scDisplayCursorChange
    CursorChangeInProgress = False
    NumChannels = 1
    NumPoints = 1024
    MaxPoints = 1024
    XMin = 0
    XMax = 1023
    XOffset = 0
    CursorsEnabled = True
    TScale = 1000.000000000000000000
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
  object AmplifierGrp: TGroupBox
    Left = 8
    Top = 40
    Width = 145
    Height = 185
    Caption = ' Amplifier '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 44
      Width = 41
      Height = 15
      Caption = 'Current'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 70
      Width = 40
      Height = 15
      Caption = 'Voltage'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbAmplifier1: TLabel
      Left = 8
      Top = 143
      Width = 77
      Height = 15
      Caption = 'Amplifier Gain'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object cbCurrentChannel: TComboBox
      Left = 56
      Top = 44
      Width = 81
      Height = 23
      Hint = 'Channel containing current signal'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = cbCurrentChannelChange
    end
    object cbVoltageChannel: TComboBox
      Left = 56
      Top = 70
      Width = 81
      Height = 23
      Hint = 'Channel containing voltage signal'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnChange = cbCurrentChannelChange
    end
    object cbAmplifier: TComboBox
      Left = 8
      Top = 16
      Width = 129
      Height = 23
      TabOrder = 2
      Text = 'cbAmplifier'
      OnChange = cbAmplifierChange
    end
    object edAmplifierGain: TValidatedEdit
      Left = 8
      Top = 158
      Width = 129
      Height = 20
      OnKeyPress = edAmplifierGainKeyPress
      AutoSize = False
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.5g'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 96
      Width = 129
      Height = 41
      Caption = 'Clamp Mode '
      TabOrder = 4
      object rbIclamp: TRadioButton
        Left = 66
        Top = 16
        Width = 60
        Height = 17
        Caption = 'Iclamp'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = rbIclampClick
      end
      object rbVclamp: TRadioButton
        Left = 4
        Top = 16
        Width = 60
        Height = 17
        Caption = 'Vclamp'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = rbVclampClick
      end
    end
  end
  object VoltsGrp: TGroupBox
    Left = 160
    Top = 402
    Width = 118
    Height = 240
    Caption = ' Voltage '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label5: TLabel
      Left = 8
      Top = 18
      Width = 43
      Height = 15
      Caption = 'Holding'
    end
    object Label6: TLabel
      Left = 8
      Top = 59
      Width = 32
      Height = 15
      Caption = 'Pulse'
    end
    object edVHold: TValidatedEdit
      Left = 8
      Top = 34
      Width = 102
      Height = 20
      OnKeyPress = EdHoldingVoltage3KeyPress
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = '   0.0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%5.1f'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
    object edVPulse: TValidatedEdit
      Left = 8
      Top = 74
      Width = 102
      Height = 20
      OnKeyPress = EdHoldingVoltage3KeyPress
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = '   0.0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%5.1f'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
  end
  object CurrentGrp: TGroupBox
    Left = 285
    Top = 402
    Width = 118
    Height = 240
    Caption = ' Current '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label7: TLabel
      Left = 8
      Top = 18
      Width = 43
      Height = 15
      Caption = 'Holding'
    end
    object Label8: TLabel
      Left = 8
      Top = 59
      Width = 32
      Height = 15
      Caption = 'Pulse'
    end
    object edIHold: TValidatedEdit
      Left = 8
      Top = 34
      Width = 102
      Height = 20
      OnKeyPress = EdHoldingVoltage3KeyPress
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = '   0.0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%5.1f'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
    object edIPulse: TValidatedEdit
      Left = 8
      Top = 74
      Width = 102
      Height = 20
      OnKeyPress = EdHoldingVoltage3KeyPress
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = '   0.0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%5.1f'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
  end
  object CellGrp: TGroupBox
    Left = 410
    Top = 402
    Width = 159
    Height = 240
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Label22: TLabel
      Left = 8
      Top = 191
      Width = 91
      Height = 14
      Alignment = taRightJustify
      Caption = 'Sweeps Averaged'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object CellParametersPage: TPageControl
      Left = 4
      Top = 12
      Width = 149
      Height = 105
      ActivePage = PipetteTab
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object PipetteTab: TTabSheet
        Caption = 'Pipette'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        object Label9: TLabel
          Left = 4
          Top = 16
          Width = 64
          Height = 15
          Caption = 'Resistance'
        end
        object edResistance: TValidatedEdit
          Left = 4
          Top = 34
          Width = 125
          Height = 31
          OnKeyPress = EdHoldingVoltage3KeyPress
          AutoSize = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Text = ' 0 MOhm'
          Scale = 0.000000999999997475
          Units = 'MOhm'
          NumberFormat = '%.5g'
          LoLimit = -1.000000015047466E29
          HiLimit = 1.000000015047466E29
        end
      end
      object CellTab: TTabSheet
        Caption = 'Cell (G)'
        object Label15: TLabel
          Left = 12
          Top = 4
          Width = 16
          Height = 15
          Alignment = taRightJustify
          Caption = 'Ga'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label17: TLabel
          Left = 8
          Top = 28
          Width = 20
          Height = 15
          Alignment = taRightJustify
          Caption = 'Gm'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label16: TLabel
          Left = 8
          Top = 52
          Width = 20
          Height = 15
          Alignment = taRightJustify
          Caption = 'Cm'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object edGaccess: TValidatedEdit
          Left = 30
          Top = 4
          Width = 99
          Height = 20
          OnKeyPress = EdHoldingVoltage3KeyPress
          AutoSize = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Text = ' 0 nS'
          Scale = 1000000000.000000000000000000
          Units = 'nS'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edGmembrane: TValidatedEdit
          Left = 30
          Top = 28
          Width = 99
          Height = 20
          OnKeyPress = EdHoldingVoltage3KeyPress
          AutoSize = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Text = ' 0 nS'
          Scale = 1000000000.000000000000000000
          Units = 'nS'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edCmembrane: TValidatedEdit
          Left = 30
          Top = 52
          Width = 99
          Height = 20
          OnKeyPress = EdHoldingVoltage3KeyPress
          AutoSize = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Text = ' 0 pF'
          Scale = 999999995904.000000000000000000
          Units = 'pF'
          NumberFormat = '%0.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
      end
      object CellRTab: TTabSheet
        Caption = 'Cell (R)'
        ImageIndex = 2
        object Label18: TLabel
          Left = 12
          Top = 4
          Width = 16
          Height = 15
          Alignment = taRightJustify
          Caption = 'Ra'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label19: TLabel
          Left = 8
          Top = 28
          Width = 20
          Height = 15
          Alignment = taRightJustify
          Caption = 'Rm'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label21: TLabel
          Left = 8
          Top = 52
          Width = 20
          Height = 15
          Alignment = taRightJustify
          Caption = 'Cm'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object edRAccess: TValidatedEdit
          Left = 30
          Top = 4
          Width = 99
          Height = 20
          OnKeyPress = EdHoldingVoltage3KeyPress
          AutoSize = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Text = ' 0 MOhm'
          Scale = 0.000000999999997475
          Units = 'MOhm'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edRMembrane: TValidatedEdit
          Left = 30
          Top = 28
          Width = 99
          Height = 20
          OnKeyPress = EdHoldingVoltage3KeyPress
          AutoSize = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Text = ' 0 MOhm'
          Scale = 0.000000999999997475
          Units = 'MOhm'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edCMembrane1: TValidatedEdit
          Left = 30
          Top = 52
          Width = 99
          Height = 20
          OnKeyPress = EdHoldingVoltage3KeyPress
          AutoSize = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Text = ' 0 pF'
          Scale = 999999995904.000000000000000000
          Units = 'pF'
          NumberFormat = '%0.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
      end
    end
    object bSaveToLog: TButton
      Left = 7
      Top = 120
      Width = 146
      Height = 18
      Caption = 'Save to Log'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bSaveToLogClick
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 144
      Width = 145
      Height = 41
      Caption = ' Ga estimate from'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object rbGaFromPeak: TRadioButton
        Left = 8
        Top = 16
        Width = 49
        Height = 17
        Caption = 'Peak'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = rbGaFromPeakClick
      end
      object rbGaFromExp: TRadioButton
        Left = 64
        Top = 16
        Width = 73
        Height = 17
        Caption = 'Exp. Amp.'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = rbGaFromExpClick
      end
    end
    object edSmoothingFactor: TValidatedEdit
      Left = 112
      Top = 190
      Width = 41
      Height = 23
      Hint = 'Readout smoothing factor (1=minimum, 10=maximum)'
      OnKeyPress = edSmoothingFactorKeyPress
      ShowHint = True
      Text = '   5 '
      Value = 5.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%3g'
      LoLimit = 1.000000000000000000
      HiLimit = 10.000000000000000000
    end
    object bResetAverage: TButton
      Left = 8
      Top = 208
      Width = 81
      Height = 17
      Hint = 'Reset calculated pipette resistance/capacity averaging counter'
      Caption = 'Reset Avg.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = bResetAverageClick
    end
  end
  object PulseGrp: TGroupBox
    Left = 8
    Top = 314
    Width = 145
    Height = 277
    Caption = ' Test Pulse '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object Label3: TLabel
      Left = 11
      Top = 58
      Width = 55
      Height = 15
      Alignment = taRightJustify
      Caption = 'Amplitude'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 30
      Top = 34
      Width = 36
      Height = 15
      Alignment = taRightJustify
      Caption = 'V Hold'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 30
      Top = 106
      Width = 36
      Height = 15
      Alignment = taRightJustify
      Caption = 'V Hold'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 11
      Top = 130
      Width = 55
      Height = 15
      Alignment = taRightJustify
      Caption = 'Amplitude'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 244
      Width = 64
      Height = 15
      Alignment = taRightJustify
      Caption = 'Pulse width'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 30
      Top = 180
      Width = 36
      Height = 15
      Alignment = taRightJustify
      Caption = 'V Hold'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Shape1: TShape
      Left = 8
      Top = 236
      Width = 130
      Height = 1
    end
    object Label20: TLabel
      Left = 11
      Top = 204
      Width = 55
      Height = 15
      Alignment = taRightJustify
      Caption = 'Amplitude'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object rbUseHoldingVoltage1: TRadioButton
      Left = 8
      Top = 16
      Width = 89
      Height = 17
      Hint = 'Select test pulse #1 (F3)'
      Caption = 'Pulse #1 (F3)'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      OnClick = rbUseHoldingVoltage1Click
    end
    object rbUseHoldingVoltage2: TRadioButton
      Left = 8
      Top = 88
      Width = 89
      Height = 17
      Hint = 'Select test pulse #2 (F4)'
      Caption = 'Pulse #2 (F4)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = rbUseHoldingVoltage2Click
    end
    object rbUseHoldingVoltage3: TRadioButton
      Left = 8
      Top = 160
      Width = 89
      Height = 17
      Hint = 'Select test pulse #3 (No pulse) (F5)'
      Caption = 'Pulse #3 (F5)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = rbUseHoldingVoltage3Click
    end
    object edHoldingVoltage1: TValidatedEdit
      Left = 72
      Top = 34
      Width = 65
      Height = 20
      Hint = 'Pulse #1: holding voltage'
      OnKeyPress = edHoldingVoltage1KeyPress
      AutoSize = False
      Text = ' 0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
    object edPulseHeight1: TValidatedEdit
      Left = 72
      Top = 58
      Width = 65
      Height = 20
      Hint = 'Pulse #1: Amplitude'
      OnKeyPress = edPulseHeight1KeyPress
      AutoSize = False
      ShowHint = True
      Text = ' 0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
    object edHoldingVoltage2: TValidatedEdit
      Left = 72
      Top = 106
      Width = 65
      Height = 20
      Hint = 'Pulse #2: holding voltage'
      OnKeyPress = edHoldingVoltage2KeyPress
      AutoSize = False
      Text = ' 0 mV'
      Scale = 1000.000000000000000000
      Units = 'mV'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
    object edPulseHeight2: TValidatedEdit
      Left = 72
      Top = 130
      Width = 65
      Height = 20
      Hint = 'Pulse #2: Amplitude'
      OnKeyPress = edPulseheight2KeyPress
      AutoSize = False
      ShowHint = True
      Text = ' 0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
    object edHoldingVoltage3: TValidatedEdit
      Left = 72
      Top = 178
      Width = 65
      Height = 20
      Hint = 'Pulse #3: holding voltage'
      OnKeyPress = EdHoldingVoltage3KeyPress
      AutoSize = False
      Text = ' 0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
    object edPulseWidth: TValidatedEdit
      Left = 78
      Top = 243
      Width = 57
      Height = 20
      Hint = 'Pulse duration'
      OnKeyPress = edPulseWidthKeyPress
      AutoSize = False
      ShowHint = True
      Text = ' 100 ms'
      Value = 0.100000001490116100
      Scale = 1000.000000000000000000
      Units = 'ms'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E29
    end
    object edPulseheight3: TValidatedEdit
      Left = 72
      Top = 204
      Width = 65
      Height = 20
      Hint = 'Pulse #3: Amplitude'
      OnKeyPress = edPulseheight3KeyPress
      AutoSize = False
      ShowHint = True
      Text = ' 0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
  end
  object TimerGrp: TGroupBox
    Left = 8
    Top = 594
    Width = 145
    Height = 49
    Caption = ' Timer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object edTimer: TEdit
      Left = 64
      Top = 16
      Width = 73
      Height = 25
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'edTimer'
    end
    object bResetTimer: TButton
      Left = 8
      Top = 16
      Width = 49
      Height = 17
      Caption = 'Reset'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bResetTimerClick
    end
  end
  object ckAutoScale: TCheckBox
    Left = 160
    Top = 300
    Width = 89
    Height = 12
    Hint = 'Automatic display magification adjustment'
    Caption = ' Auto scale'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 224
    Width = 145
    Height = 89
    Caption = ' Send Test Pulse To '
    TabOrder = 7
    object ckPulseToAO0: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = 'AO 0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object ckPulseToAO1: TCheckBox
      Left = 8
      Top = 32
      Width = 97
      Height = 17
      Caption = 'AO 1'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object ckPulseToAO2: TCheckBox
      Left = 8
      Top = 48
      Width = 97
      Height = 17
      Caption = 'AO 2'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object ckPulseToAO3: TCheckBox
      Left = 8
      Top = 64
      Width = 97
      Height = 17
      Caption = 'AO 3'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
  end
  object ChannelsGrp: TGroupBox
    Left = 8
    Top = 0
    Width = 145
    Height = 41
    TabOrder = 8
    object Label10: TLabel
      Left = 8
      Top = 12
      Width = 73
      Height = 15
      Caption = 'No. channels'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object cbNumChannels: TComboBox
      Left = 88
      Top = 12
      Width = 50
      Height = 23
      Hint = 'No. of input channels displayed'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'cbNumChannels'
      OnChange = cbNumChannelsChange
    end
  end
  object ZapGrp: TGroupBox
    Left = 575
    Top = 402
    Width = 89
    Height = 240
    Caption = ' Zap '
    TabOrder = 9
    object Label23: TLabel
      Left = 8
      Top = 41
      Width = 55
      Height = 15
      Caption = 'Amplitude'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label24: TLabel
      Left = 8
      Top = 84
      Width = 64
      Height = 15
      Caption = 'Pulse width'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object bzap: TButton
      Left = 8
      Top = 18
      Width = 73
      Height = 17
      Hint = 'Apply zap pulse to perforate membrane and form whole-cell patch'
      Caption = 'Zap'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = bzapClick
    end
    object edZapAmplitude: TValidatedEdit
      Left = 8
      Top = 58
      Width = 72
      Height = 20
      Hint = 'Zap pulse amplitude'
      OnKeyPress = edZapAmplitudeKeyPress
      AutoSize = False
      ShowHint = True
      Text = ' 0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
    end
    object edZapDuration: TValidatedEdit
      Left = 8
      Top = 100
      Width = 72
      Height = 20
      Hint = 'Zap pulse width'
      OnKeyPress = edZapDurationKeyPress
      AutoSize = False
      ShowHint = True
      Text = ' 0 ms'
      Scale = 1000.000000000000000000
      Units = 'ms'
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E29
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 55
    OnTimer = TimerTimer
    Left = 168
    Top = 16
  end
end
