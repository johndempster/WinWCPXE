object EPC9PanelFrm: TEPC9PanelFrm
  Left = 0
  Top = 0
  Caption = 'EPC-9/10 Patch Clamp'
  ClientHeight = 403
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ControlsGrp: TGroupBox
    Left = 8
    Top = 0
    Width = 305
    Height = 393
    TabOrder = 0
    object GroupBox4: TGroupBox
      Left = 8
      Top = 8
      Width = 129
      Height = 120
      Caption = ' Amplifier '
      TabOrder = 0
      object Label10: TLabel
        Left = 8
        Top = 39
        Width = 24
        Height = 14
        Alignment = taRightJustify
        Caption = 'Gain'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label20: TLabel
        Left = 8
        Top = 19
        Width = 49
        Height = 14
        Alignment = taRightJustify
        Caption = 'Amp. No.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbGain: TComboBox
        Left = 43
        Top = 43
        Width = 83
        Height = 21
        Hint = 'Amplifier gain / headstage feedback resistance'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'cbGain'
        OnChange = cbGainChange
      end
      object cbChannel: TComboBox
        Left = 69
        Top = 16
        Width = 57
        Height = 21
        TabOrder = 1
        Text = 'cbChannel'
        OnChange = cbChannelChange
      end
    end
    object GroupBox5: TGroupBox
      Left = 8
      Top = 128
      Width = 290
      Height = 74
      Caption = ' Filters '
      TabOrder = 1
      object Label11: TLabel
        Left = 8
        Top = 16
        Width = 37
        Height = 14
        Caption = 'Filter 2'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 8
        Top = 40
        Width = 37
        Height = 14
        Caption = 'Filter 1'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbFilter1: TComboBox
        Left = 50
        Top = 40
        Width = 120
        Height = 21
        Hint = 'Input channel'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'cbGain'
        OnChange = cbFilter1Change
      end
      object cbFilter2: TComboBox
        Left = 50
        Top = 16
        Width = 120
        Height = 21
        Hint = 'Input channel'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'cbGain'
        OnChange = cbFilter2Change
      end
      object edFilter2Bandwidth: TValidatedEdit
        Left = 175
        Top = 16
        Width = 105
        Height = 21
        OnKeyPress = edFilter2BandwidthKeyPress
        Text = ' 0 kHz'
        Scale = 0.001000000047497451
        Units = 'kHz'
        NumberFormat = '%.4g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object PageControl1: TPageControl
      Left = 8
      Top = 208
      Width = 290
      Height = 113
      ActivePage = CfastTab
      TabOrder = 2
      object CfastTab: TTabSheet
        Caption = 'Cfast'
        object Label3: TLabel
          Left = 4
          Top = 3
          Width = 46
          Height = 14
          Caption = 'Capacity'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 4
          Top = 28
          Width = 79
          Height = 14
          Caption = 'Time constant'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edCfast: TValidatedEdit
          Left = 120
          Top = 3
          Width = 75
          Height = 21
          OnKeyPress = edCfastKeyPress
          Text = ' 0 pF'
          Scale = 999999995904.000000000000000000
          Units = 'pF'
          NumberFormat = '%.5g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edCfastTau: TValidatedEdit
          Left = 120
          Top = 28
          Width = 75
          Height = 21
          OnKeyPress = edCfastTauKeyPress
          Text = ' 0 us'
          Scale = 1000000.000000000000000000
          Units = 'us'
          NumberFormat = '%.5g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object bAutoCfast: TButton
          Left = 220
          Top = 3
          Width = 57
          Height = 17
          Caption = 'Auto'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = bAutoCfastClick
        end
        object cCfastClear: TButton
          Left = 220
          Top = 24
          Width = 57
          Height = 17
          Caption = 'Clear'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = cCfastClearClick
        end
        object udCFast: TUpDown
          Left = 195
          Top = 1
          Width = 16
          Height = 24
          Min = -1000000
          Max = 1000000
          TabOrder = 4
          OnChangingEx = udCFastChangingEx
        end
        object udCFastTau: TUpDown
          Left = 195
          Top = 27
          Width = 16
          Height = 24
          Min = -1000000
          Max = 1000000
          TabOrder = 5
          OnChangingEx = udCFastTauChangingEx
        end
      end
      object CslowTab: TTabSheet
        Caption = 'Cslow'
        ImageIndex = 1
        object Label7: TLabel
          Left = 4
          Top = 3
          Width = 34
          Height = 14
          Caption = 'Range'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label5: TLabel
          Left = 4
          Top = 28
          Width = 46
          Height = 14
          Caption = 'Capacity'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 4
          Top = 53
          Width = 47
          Height = 14
          Caption = 'G series'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cbCslowRange: TComboBox
          Left = 120
          Top = 3
          Width = 90
          Height = 21
          Hint = 'Input channel'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = 'cbGain'
          OnChange = cbCslowRangeChange
        end
        object edCSlow: TValidatedEdit
          Left = 120
          Top = 28
          Width = 75
          Height = 21
          OnKeyPress = edCSlowKeyPress
          Text = ' 0 pF'
          Scale = 999999995904.000000000000000000
          Units = 'pF'
          NumberFormat = '%.5g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edGSeries: TValidatedEdit
          Left = 120
          Top = 53
          Width = 75
          Height = 21
          OnKeyPress = edGSeriesKeyPress
          Text = ' 0 nS'
          Scale = 1000000000.000000000000000000
          Units = 'nS'
          NumberFormat = '%.5g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object bAutoCSlow: TButton
          Left = 220
          Top = 3
          Width = 57
          Height = 17
          Caption = 'Auto'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = bAutoCSlowClick
        end
        object bClearCslow: TButton
          Left = 220
          Top = 24
          Width = 57
          Height = 17
          Caption = 'Clear'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          OnClick = bClearCslowClick
        end
        object udCSLow: TUpDown
          Left = 195
          Top = 27
          Width = 16
          Height = 24
          Max = 1000000
          TabOrder = 5
          OnChangingEx = udCSLowChangingEx
        end
        object udGSeries: TUpDown
          Left = 195
          Top = 53
          Width = 16
          Height = 24
          Max = 1000000
          TabOrder = 6
          OnChangingEx = udGSeriesChangingEx
        end
      end
      object RSCompTab: TTabSheet
        Caption = 'Rs Compensation'
        ImageIndex = 2
        object Label8: TLabel
          Left = 5
          Top = 3
          Width = 35
          Height = 14
          Caption = 'Speed'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label9: TLabel
          Left = 5
          Top = 28
          Width = 93
          Height = 14
          Caption = '% Compensation'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cbRSSpeed: TComboBox
          Left = 120
          Top = 3
          Width = 90
          Height = 21
          Hint = 'Input channel'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = 'cbGain'
          OnChange = cbRSSpeedChange
        end
        object edRSCompensation: TValidatedEdit
          Left = 120
          Top = 28
          Width = 75
          Height = 21
          OnKeyPress = edRSCompensationKeyPress
          Text = ' 0 %'
          Scale = 100.000000000000000000
          Units = '%'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object bAutoRSCompensation: TButton
          Left = 220
          Top = 3
          Width = 57
          Height = 17
          Caption = 'Auto'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = bAutoRSCompensationClick
        end
        object bClearRSCompensation: TButton
          Left = 220
          Top = 24
          Width = 57
          Height = 17
          Caption = 'Clear'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = bClearRSCompensationClick
        end
        object udRSCompensation: TUpDown
          Left = 194
          Top = 26
          Width = 16
          Height = 24
          Min = -1000000
          Max = 1000000
          TabOrder = 4
          OnChangingEx = udRSCompensationChangingEx
        end
      end
      object LeakTab: TTabSheet
        Caption = 'Leak'
        ImageIndex = 3
        object Label12: TLabel
          Left = 4
          Top = 3
          Width = 102
          Height = 14
          Caption = 'Leak Conductance'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edGLeak: TValidatedEdit
          Left = 120
          Top = 3
          Width = 75
          Height = 21
          OnKeyPress = edGLeakKeyPress
          Text = ' 0 nS'
          Scale = 1000000000.000000000000000000
          Units = 'nS'
          NumberFormat = '%.5g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object bAutoLeakSubtract: TButton
          Left = 220
          Top = 3
          Width = 57
          Height = 17
          Caption = 'Auto'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = bAutoLeakSubtractClick
        end
        object bCLearLeakSubtract: TButton
          Left = 220
          Top = 24
          Width = 57
          Height = 17
          Caption = 'Clear'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = bCLearLeakSubtractClick
        end
        object udGLeak: TUpDown
          Left = 195
          Top = 1
          Width = 16
          Height = 24
          Min = -1000000
          Max = 1000000
          TabOrder = 3
          OnChangingEx = udGLeakChangingEx
        end
      end
      object VpipTab: TTabSheet
        Caption = 'Vpipette'
        ImageIndex = 4
        object Label1: TLabel
          Left = 1
          Top = 3
          Width = 50
          Height = 14
          Caption = 'V pipette'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label16: TLabel
          Left = 0
          Top = 28
          Width = 88
          Height = 14
          Caption = 'V liquid junction'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label17: TLabel
          Left = 3
          Top = 54
          Width = 35
          Height = 14
          Caption = 'V hold'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edVPOffset: TValidatedEdit
          Left = 120
          Top = 3
          Width = 75
          Height = 21
          OnKeyPress = edVPOffsetKeyPress
          Text = ' 0 mV'
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.5g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edVLiquidJunction: TValidatedEdit
          Left = 120
          Top = 28
          Width = 75
          Height = 21
          OnKeyPress = edVLiquidJunctionKeyPress
          Text = ' 0 mV'
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.5g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object bAutoVPipette: TButton
          Left = 220
          Top = 3
          Width = 57
          Height = 17
          Caption = 'Auto'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = bAutoVPipetteClick
        end
        object bClearVPOffset: TButton
          Left = 220
          Top = 24
          Width = 57
          Height = 17
          Caption = 'Clear'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = bClearVPOffsetClick
        end
        object edVHold: TValidatedEdit
          Left = 120
          Top = 54
          Width = 75
          Height = 21
          OnKeyPress = edVHoldKeyPress
          Text = ' 0 mV'
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.5g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object udVHold: TUpDown
          Left = 195
          Top = 53
          Width = 16
          Height = 24
          Min = -1000000
          Max = 10000000
          TabOrder = 5
          OnChangingEx = udVHoldChangingEx
        end
        object udVPOffset: TUpDown
          Left = 195
          Top = 1
          Width = 16
          Height = 24
          Min = -1000000
          Max = 10000000
          TabOrder = 6
          OnChangingEx = udVPOffsetChangingEx
        end
        object udVLiquidJunction: TUpDown
          Left = 195
          Top = 27
          Width = 16
          Height = 24
          Min = -1000000
          Max = 10000000
          TabOrder = 7
          OnChangingEx = udVLiquidJunctionChangingEx
        end
      end
    end
    object ModeGrp: TGroupBox
      Left = 140
      Top = 8
      Width = 155
      Height = 120
      Caption = ' Mode '
      TabOrder = 3
      object Label13: TLabel
        Left = 8
        Top = 43
        Width = 43
        Height = 14
        Caption = 'CC Gain'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label18: TLabel
        Left = 8
        Top = 63
        Width = 38
        Height = 14
        Caption = 'CC Tau'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbMode: TComboBox
        Left = 8
        Top = 16
        Width = 129
        Height = 21
        Hint = 'Amplifer voltage/current clamp mode'
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = cbModeChange
      end
      object cbCCGain: TComboBox
        Left = 55
        Top = 43
        Width = 85
        Height = 21
        TabOrder = 1
        Text = 'cbChannel'
        OnChange = cbCCGainChange
      end
      object cbCCTrackTau: TComboBox
        Left = 55
        Top = 70
        Width = 85
        Height = 21
        TabOrder = 2
        Text = 'cbChannel'
        OnChange = cbCCTrackTauChange
      end
      object ckChangeModeGently: TCheckBox
        Left = 8
        Top = 97
        Width = 144
        Height = 17
        Caption = 'Gentle Mode Change'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = ckChangeModeGentlyClick
      end
    end
    object StimGrp: TGroupBox
      Left = 8
      Top = 327
      Width = 289
      Height = 51
      Caption = ' Command Stimulus '
      TabOrder = 4
      object Label19: TLabel
        Left = 4
        Top = 16
        Width = 55
        Height = 14
        Alignment = taRightJustify
        Caption = 'Input Path'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbExtStimPath: TComboBox
        Left = 65
        Top = 16
        Width = 88
        Height = 21
        Hint = 'Amplifier gain / headstage feedback resistance'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'cbGain'
        OnChange = cbExtStimPathChange
      end
      object ckEnableStimFilter: TCheckBox
        Left = 173
        Top = 16
        Width = 113
        Height = 28
        Caption = 'Enable Stimulus Filter'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        WordWrap = True
        OnClick = ckEnableStimFilterClick
      end
    end
  end
end
