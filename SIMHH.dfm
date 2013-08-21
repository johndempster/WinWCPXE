object VClampSim: TVClampSim
  Left = 682
  Top = 84
  Caption = 'Voltage-activated Currents Simulation'
  ClientHeight = 649
  ClientWidth = 718
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
    Left = 184
    Top = 6
    Width = 497
    Height = 265
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
  object QuantumGrp: TGroupBox
    Left = 8
    Top = 214
    Width = 169
    Height = 57
    Caption = ' Noise '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label9: TLabel
      Left = 8
      Top = 16
      Width = 97
      Height = 33
      AutoSize = False
      Caption = 'Background noise (R.M.S.)'
      WordWrap = True
    end
    object edNoiseRMS: TValidatedEdit
      Left = 96
      Top = 13
      Width = 65
      Height = 20
      AutoSize = False
      Text = ' 0.02 nA'
      Value = 0.000000000020000000
      Scale = 1000000000.000000000000000000
      Units = 'nA'
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 6
    Width = 169
    Height = 57
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object bStart: TButton
      Left = 8
      Top = 12
      Width = 153
      Height = 17
      Caption = 'Start Simulation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = bStartClick
    end
    object bAbort: TButton
      Left = 8
      Top = 32
      Width = 57
      Height = 17
      Caption = 'Abort'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bAbortClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 58
    Width = 169
    Height = 89
    Caption = ' Voltage protocol '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label8: TLabel
      Left = 8
      Top = 16
      Width = 89
      Height = 17
      AutoSize = False
      Caption = 'Holding voltage'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object TLabel
      Left = 24
      Top = 40
      Width = 67
      Height = 15
      Caption = 'Voltage step'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object TLabel
      Left = 24
      Top = 64
      Width = 66
      Height = 15
      Caption = 'No. of steps'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edVHold: TValidatedEdit
      Left = 96
      Top = 16
      Width = 65
      Height = 20
      AutoSize = False
      Text = ' -90.0 mV'
      Value = -0.090000003576278690
      Scale = 1000.000000000000000000
      Units = 'mV'
      NumberFormat = '%.1f'
      LoLimit = -0.200000002980232200
      HiLimit = 0.200000002980232200
    end
    object edVStep: TValidatedEdit
      Left = 96
      Top = 40
      Width = 65
      Height = 20
      AutoSize = False
      Text = ' 10.0 mV'
      Value = 0.009999999776482582
      Scale = 1000.000000000000000000
      Units = 'mV'
      NumberFormat = '%.1f'
      LoLimit = -0.200000002980232200
      HiLimit = 0.200000002980232200
    end
    object edNumSteps: TValidatedEdit
      Left = 96
      Top = 64
      Width = 65
      Height = 20
      AutoSize = False
      Text = ' 16 '
      Value = 16.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%g'
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
    end
  end
  object GroupBox7: TGroupBox
    Left = 8
    Top = 148
    Width = 169
    Height = 65
    Caption = ' Leak subtraction '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object rbNoLeakSubtraction: TRadioButton
      Left = 8
      Top = 16
      Width = 65
      Height = 17
      Caption = 'None'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
    end
    object rbLeakSubtraction: TRadioButton
      Left = 8
      Top = 32
      Width = 89
      Height = 17
      Caption = 'Divide by N'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object edLeakDivBy: TValidatedEdit
      Left = 96
      Top = 32
      Width = 33
      Height = 20
      AutoSize = False
      Text = ' 4 '
      Value = 4.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
  end
  object EquationGrp: TGroupBox
    Left = 8
    Top = 316
    Width = 713
    Height = 329
    TabOrder = 4
    object GroupBox4: TGroupBox
      Left = 6
      Top = 8
      Width = 175
      Height = 313
      Caption = ' Conductance '
      TabOrder = 0
      object HTMLLabel1: THTMLLabel
        Left = 40
        Top = 40
        Width = 50
        Height = 25
        Caption = 'G<sub>max</sub>'
        Alignment = taLeftJustify
        LineSpacing = 1.000000000000000000
      end
      object HTMLLabel2: THTMLLabel
        Left = 40
        Top = 68
        Width = 50
        Height = 25
        Caption = 'G<sub>leak</sub>'
        Alignment = taLeftJustify
        LineSpacing = 1.000000000000000000
      end
      object HTMLLabel3: THTMLLabel
        Left = 40
        Top = 96
        Width = 50
        Height = 25
        Caption = 'G<sub>series</sub>'
        Alignment = taLeftJustify
        LineSpacing = 1.000000000000000000
      end
      object HTMLLabel4: THTMLLabel
        Left = 8
        Top = 16
        Width = 158
        Height = 20
        Caption = 
          ' I<sub>m</sub> = G<sub>max</sub> x  m<sup>p</sup> x h (V - V<sub' +
          '>rev</sub>)'
        Alignment = taLeftJustify
        LineSpacing = 1.000000000000000000
        Color = clActiveBorder
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
      end
      object HTMLLabel5: THTMLLabel
        Left = 56
        Top = 128
        Width = 32
        Height = 25
        Caption = 'V<sub>rev</sub>'
        Alignment = taLeftJustify
        LineSpacing = 1.000000000000000000
      end
      object HTMLLabel6: THTMLLabel
        Left = 56
        Top = 156
        Width = 32
        Height = 25
        Caption = 'P'
        Alignment = taLeftJustify
        LineSpacing = 1.000000000000000000
      end
      object HTMLLabel7: THTMLLabel
        Left = 56
        Top = 184
        Width = 32
        Height = 25
        Caption = 'C<sub>m</sub>'
        Alignment = taLeftJustify
        LineSpacing = 1.000000000000000000
      end
      object edGMax: TValidatedEdit
        Left = 88
        Top = 40
        Width = 80
        Height = 20
        Hint = 'Maximum conductance'
        OnKeyPress = edGMaxKeyPress
        AutoSize = False
        ShowHint = True
        Text = ' 20 nS'
        Value = 0.000000019999999878
        Scale = 1000000000.000000000000000000
        Units = 'nS'
        NumberFormat = '%.5g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edGLeak: TValidatedEdit
        Left = 88
        Top = 68
        Width = 80
        Height = 20
        Hint = 'Leak conductance'
        OnKeyPress = edGLeakKeyPress
        AutoSize = False
        ShowHint = True
        Text = ' 1 nS'
        Value = 0.000000000999999972
        Scale = 1000000000.000000000000000000
        Units = 'nS'
        NumberFormat = '%.5g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edGSeries: TValidatedEdit
        Left = 88
        Top = 96
        Width = 80
        Height = 20
        Hint = 'Pipette series conductance'
        AutoSize = False
        ShowHint = True
        Text = ' 200 nS'
        Value = 0.000000200000002337
        Scale = 1000000000.000000000000000000
        Units = 'nS'
        NumberFormat = '%.5g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edVRev: TValidatedEdit
        Left = 88
        Top = 128
        Width = 80
        Height = 20
        Hint = 'Reversal potential'
        OnKeyPress = edVRevKeyPress
        AutoSize = False
        ShowHint = True
        Text = ' -100.0 mV'
        Value = -0.100000001490116100
        Scale = 1000.000000000000000000
        Units = 'mV'
        NumberFormat = '%.1f'
        LoLimit = -0.200000002980232200
        HiLimit = 0.200000002980232200
      end
      object edPower: TValidatedEdit
        Left = 88
        Top = 156
        Width = 80
        Height = 20
        Hint = 'm-gate power factor'
        AutoSize = False
        ShowHint = True
        Text = ' 1 '
        Value = 1.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%.0f'
        LoLimit = 1.000000000000000000
        HiLimit = 10.000000000000000000
      end
      object edCm: TValidatedEdit
        Left = 88
        Top = 184
        Width = 80
        Height = 20
        Hint = 'Cell capacitance'
        AutoSize = False
        ShowHint = True
        Text = ' 30 pF'
        Value = 0.000000000029999999
        Scale = 999999995904.000000000000000000
        Units = 'pF'
        NumberFormat = '%.5g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object MGroup: TGroupBox
      Left = 186
      Top = 8
      Width = 257
      Height = 313
      Caption = ' Activation (m) '
      TabOrder = 1
      object HTMLLabel11: THTMLLabel
        Left = 16
        Top = 16
        Width = 225
        Height = 20
        Caption = 
          ' m = (m<sub>inf</sub>{V} - m<sub>inf</sub>{V<sub>h</sub>}) exp(-' +
          't/tau{V})'
        Alignment = taLeftJustify
        LineSpacing = 1.000000000000000000
        Color = clActiveBorder
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 40
        Width = 241
        Height = 94
        Caption = ' m.inf (V) '
        TabOrder = 0
        object HTMLLabel8: THTMLLabel
          Left = 88
          Top = 40
          Width = 44
          Height = 25
          Caption = 'V<sub>1/2</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel9: THTMLLabel
          Left = 88
          Top = 64
          Width = 44
          Height = 24
          Caption = 'V<sub>slope</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel22: THTMLLabel
          Left = 8
          Top = 16
          Width = 225
          Height = 20
          Caption = ' m<sub>inf</sub>=1/(1+exp((V-V<sub>1/2</sub>)/V<sub>slope</sub>)'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
          Color = clActiveBorder
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
        end
        object edMInfVHalf: TValidatedEdit
          Left = 152
          Top = 40
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' -1.0 mV'
          Value = -0.001000000047497451
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edMinfVSlope: TValidatedEdit
          Left = 152
          Top = 64
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' -11.0 mV'
          Value = -0.010999999940395360
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 136
        Width = 241
        Height = 145
        Caption = ' tau(V) '
        TabOrder = 1
        object HTMLLabel10: THTMLLabel
          Left = 104
          Top = 88
          Width = 44
          Height = 25
          Caption = 'V<sub>1/2</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel16: THTMLLabel
          Left = 104
          Top = 112
          Width = 44
          Height = 24
          Caption = 'V<sub>slope</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel17: THTMLLabel
          Left = 104
          Top = 40
          Width = 44
          Height = 25
          Caption = '<Font face=symbol>t</Font><sub>min</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel18: THTMLLabel
          Left = 104
          Top = 64
          Width = 44
          Height = 29
          Caption = '<Font face=symbol>t</Font><sub>max</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel24: THTMLLabel
          Left = 8
          Top = 16
          Width = 225
          Height = 20
          Caption = 
            '<Font face=symbol>t</Font>=<Font face=symbol>t</Font><sub>min</s' +
            'ub>+(<Font face=symbol>t</Font><sub>max</sub>-<Font face=symbol>' +
            't</Font><sub>min</sub>)exp(-(V-V<sub>1/2</sub>)/V<sub>slope</sub' +
            '>)<sup>2</sup>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
          Color = clActiveBorder
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
        end
        object edMTauVhalf: TValidatedEdit
          Left = 152
          Top = 88
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' 0.0 mV'
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edMTauVSlope: TValidatedEdit
          Left = 152
          Top = 112
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' 30.0 mV'
          Value = 0.029999999329447750
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edMtauMin: TValidatedEdit
          Left = 152
          Top = 40
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' 1.5 ms'
          Value = 0.001500000013038516
          Scale = 1000.000000000000000000
          Units = 'ms'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edMTauMax: TValidatedEdit
          Left = 152
          Top = 64
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' 3.5 ms'
          Value = 0.003500000108033419
          Scale = 1000.000000000000000000
          Units = 'ms'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
      end
    end
    object GroupBox6: TGroupBox
      Left = 446
      Top = 8
      Width = 257
      Height = 313
      Caption = ' Inactivation (h) '
      TabOrder = 2
      object HTMLLabel15: THTMLLabel
        Left = 16
        Top = 16
        Width = 193
        Height = 20
        Caption = 
          ' h = (h<sub>inf</sub>{V} - h<sub>inf</sub>{V<sub>h</sub>}) exp(-' +
          't/tau{V})'
        Alignment = taLeftJustify
        LineSpacing = 1.000000000000000000
        Color = clActiveBorder
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
      end
      object ckInactivation: TCheckBox
        Left = 8
        Top = 280
        Width = 113
        Height = 25
        Caption = 'Use Inactivation'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object GroupBox8: TGroupBox
        Left = 8
        Top = 40
        Width = 241
        Height = 94
        Caption = ' h.inf (V) '
        TabOrder = 1
        object HTMLLabel12: THTMLLabel
          Left = 88
          Top = 40
          Width = 44
          Height = 25
          Caption = 'V<sub>1/2</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel13: THTMLLabel
          Left = 88
          Top = 64
          Width = 44
          Height = 24
          Caption = 'V<sub>slope</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel23: THTMLLabel
          Left = 8
          Top = 16
          Width = 225
          Height = 20
          Caption = ' h<sub>inf</sub>=1/(1+exp((V-V<sub>1/2</sub>)/V<sub>slope</sub>)'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
          Color = clActiveBorder
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
        end
        object edHinfVhalf: TValidatedEdit
          Left = 152
          Top = 40
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' -45.0 mV'
          Value = -0.045000001788139340
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edHinfVslope: TValidatedEdit
          Left = 152
          Top = 64
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' 11.5 mV'
          Value = 0.011500000022351740
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
      end
      object GroupBox9: TGroupBox
        Left = 8
        Top = 136
        Width = 241
        Height = 145
        Caption = ' tau(V) '
        TabOrder = 2
        object HTMLLabel14: THTMLLabel
          Left = 104
          Top = 88
          Width = 44
          Height = 25
          Caption = 'V<sub>1/2</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel19: THTMLLabel
          Left = 104
          Top = 112
          Width = 44
          Height = 24
          Caption = 'V<sub>slope</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel20: THTMLLabel
          Left = 104
          Top = 40
          Width = 44
          Height = 25
          Caption = '<Font face=symbol>t</Font><sub>min</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel21: THTMLLabel
          Left = 104
          Top = 64
          Width = 44
          Height = 29
          Caption = '<Font face=symbol>t</Font><sub>max</sub>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
        end
        object HTMLLabel25: THTMLLabel
          Left = 8
          Top = 16
          Width = 225
          Height = 20
          Caption = 
            '<Font face=symbol>t</Font>=<Font face=symbol>t</Font><sub>min</s' +
            'ub>+(<Font face=symbol>t</Font><sub>max</sub>-<Font face=symbol>' +
            't</Font><sub>min</sub>)exp(-(V-V<sub>1/2</sub>)/V<sub>slope</sub' +
            '>)<sup>2</sup>'
          Alignment = taLeftJustify
          LineSpacing = 1.000000000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
        end
        object edHtauVhalf: TValidatedEdit
          Left = 152
          Top = 88
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' -52.5 mV'
          Value = -0.052499998360872270
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edHtauVslope: TValidatedEdit
          Left = 152
          Top = 112
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' 15.0 mV'
          Value = 0.014999999664723870
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edHtauMin: TValidatedEdit
          Left = 152
          Top = 40
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' 14.0 ms'
          Value = 0.014000000432133670
          Scale = 1000.000000000000000000
          Units = 'ms'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edHtauMax: TValidatedEdit
          Left = 152
          Top = 64
          Width = 80
          Height = 20
          AutoSize = False
          Text = ' 482.6 ms'
          Value = 0.482600003480911300
          Scale = 1000.000000000000000000
          Units = 'ms'
          NumberFormat = '%.1f'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
      end
    end
  end
  object GroupBox10: TGroupBox
    Left = 8
    Top = 272
    Width = 169
    Height = 41
    TabOrder = 5
    object Label12: TLabel
      Left = 17
      Top = 12
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
    object edNumSamples: TValidatedEdit
      Left = 96
      Top = 12
      Width = 65
      Height = 20
      Hint = 'No. of sample points per record'
      OnKeyPress = edNumSamplesKeyPress
      AutoSize = False
      ShowHint = True
      Text = ' 512 '
      Value = 512.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 256.000000000000000000
      HiLimit = 1.000000015047466E30
    end
  end
end
