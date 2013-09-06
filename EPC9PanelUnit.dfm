object EPC9PanelFrm: TEPC9PanelFrm
  Left = 0
  Top = 0
  Caption = 'EPC-9/10 Patch Clamp'
  ClientHeight = 517
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ControlsGrp: TGroupBox
    Left = 8
    Top = 0
    Width = 305
    Height = 513
    TabOrder = 0
    object GroupBox3: TGroupBox
      Left = 8
      Top = 13
      Width = 290
      Height = 45
      Caption = ' Select Channel'
      TabOrder = 0
      object cbChannel: TComboBox
        Left = 13
        Top = 16
        Width = 57
        Height = 21
        TabOrder = 0
        Text = 'cbChannel'
      end
      object edModel: TEdit
        Left = 76
        Top = 16
        Width = 205
        Height = 21
        ReadOnly = True
        TabOrder = 1
        Text = 'edModel'
      end
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 64
      Width = 129
      Height = 120
      Caption = ' Amplifier '
      TabOrder = 1
      object Label10: TLabel
        Left = 8
        Top = 15
        Width = 35
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
      object cbGain: TComboBox
        Left = 8
        Top = 35
        Width = 105
        Height = 21
        Hint = 'Amplifier gain / headstage feedback resistance'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'cbGain'
        OnChange = cbGainChange
      end
    end
    object GroupBox5: TGroupBox
      Left = 8
      Top = 186
      Width = 290
      Height = 74
      Caption = ' Filters '
      TabOrder = 2
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
      object edFilter1Bandwidth: TValidatedEdit
        Left = 176
        Top = 40
        Width = 105
        Height = 21
        OnKeyPress = edFilter1BandwidthKeyPress
        Text = ' 0 kHz'
        Scale = 0.001000000047497451
        Units = 'kHz'
        NumberFormat = '%.4g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object Zapgrp: TGroupBox
      Left = 8
      Top = 380
      Width = 290
      Height = 73
      Caption = ' Zap Cell '
      TabOrder = 3
      object Label14: TLabel
        Left = 5
        Top = 16
        Width = 57
        Height = 14
        Caption = 'Amplitude'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label15: TLabel
        Left = 5
        Top = 40
        Width = 46
        Height = 14
        Caption = 'Duration'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edZapAmplitude: TValidatedEdit
        Left = 100
        Top = 16
        Width = 70
        Height = 21
        OnKeyPress = edCfastKeyPress
        Text = ' 0 pF'
        Scale = 999999995904.000000000000000000
        Units = 'pF'
        NumberFormat = '%.4g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edZapDuration: TValidatedEdit
        Left = 100
        Top = 40
        Width = 70
        Height = 21
        OnKeyPress = edCfastTauKeyPress
        Text = ' 0 us'
        Scale = 1000000.000000000000000000
        Units = 'us'
        NumberFormat = '%.4g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object bZap: TButton
        Left = 224
        Top = 16
        Width = 57
        Height = 17
        Caption = 'Zap Cell'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
    end
    object PageControl1: TPageControl
      Left = 8
      Top = 265
      Width = 290
      Height = 113
      ActivePage = VpipTab
      TabOrder = 4
      object CfastTab: TTabSheet
        Caption = 'Cfast'
        ExplicitWidth = 292
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
          Width = 90
          Height = 21
          OnKeyPress = edCfastKeyPress
          Text = ' 0 pF'
          Scale = 999999995904.000000000000000000
          Units = 'pF'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edCfastTau: TValidatedEdit
          Left = 120
          Top = 28
          Width = 90
          Height = 21
          OnKeyPress = edCfastTauKeyPress
          Text = ' 0 us'
          Scale = 1000000.000000000000000000
          Units = 'us'
          NumberFormat = '%.4g'
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
      end
      object CslowTab: TTabSheet
        Caption = 'Cslow'
        ImageIndex = 1
        ExplicitWidth = 292
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
          Width = 90
          Height = 21
          OnKeyPress = edCSlowKeyPress
          Text = ' 0 pF'
          Scale = 999999995904.000000000000000000
          Units = 'pF'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edGSeries: TValidatedEdit
          Left = 120
          Top = 53
          Width = 90
          Height = 21
          OnKeyPress = edGSeriesKeyPress
          Text = ' 0 nS'
          Scale = 1000000000.000000000000000000
          Units = 'nS'
          NumberFormat = '%.4g'
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
      end
      object RSCompTab: TTabSheet
        Caption = 'Rs Compensation'
        ImageIndex = 2
        ExplicitWidth = 292
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
          Width = 90
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
      end
      object LeakTab: TTabSheet
        Caption = 'Leak'
        ImageIndex = 3
        ExplicitWidth = 292
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
          Width = 90
          Height = 21
          OnKeyPress = edGLeakKeyPress
          Text = ' 0 nS'
          Scale = 1000000000.000000000000000000
          Units = 'nS'
          NumberFormat = '%.4g'
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
        object Button2: TButton
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
          OnClick = Button2Click
        end
      end
      object VpipTab: TTabSheet
        Caption = 'Vpipette'
        ImageIndex = 4
        ExplicitWidth = 292
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
          Width = 90
          Height = 21
          OnKeyPress = edVPOffsetKeyPress
          Text = ' 0 mV'
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edVLiquidJunction: TValidatedEdit
          Left = 120
          Top = 28
          Width = 90
          Height = 21
          OnKeyPress = edVLiquidJunctionKeyPress
          Text = ' 0 mV'
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.4g'
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
          Width = 90
          Height = 21
          OnKeyPress = edVHoldKeyPress
          Text = ' 0 mV'
          Scale = 1000.000000000000000000
          Units = 'mV'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
      end
    end
    object ModeGrp: TGroupBox
      Left = 143
      Top = 64
      Width = 155
      Height = 120
      Caption = ' Mode '
      TabOrder = 5
      object Label13: TLabel
        Left = 8
        Top = 43
        Width = 50
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
        Width = 50
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
      end
      object cbCCTrackTau: TComboBox
        Left = 55
        Top = 70
        Width = 85
        Height = 21
        TabOrder = 2
        Text = 'cbChannel'
      end
      object CheckBox1: TCheckBox
        Left = 16
        Top = 97
        Width = 80
        Height = 17
        Caption = 'Gently'
        TabOrder = 3
      end
    end
  end
end
