object TritonPanelFrm: TTritonPanelFrm
  Left = 598
  Top = 11
  Caption = 'Tecella Patch Clamp '
  ClientHeight = 910
  ClientWidth = 545
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ControlsGrp: TGroupBox
    Left = 8
    Top = 0
    Width = 321
    Height = 697
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 8
      Top = 301
      Width = 305
      Height = 311
      Caption = ' Compensation '
      TabOrder = 0
      object AutoCompPage: TPageControl
        Left = 8
        Top = 17
        Width = 289
        Height = 288
        ActivePage = AutoPage
        TabOrder = 0
        object AutoPage: TTabSheet
          Caption = 'Auto'
          object GroupBox6: TGroupBox
            Left = 8
            Top = 56
            Width = 265
            Height = 201
            TabOrder = 0
            object Label17: TLabel
              Left = 56
              Top = 168
              Width = 142
              Height = 14
              Caption = 'Compensation coefficient'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label18: TLabel
              Left = 10
              Top = 114
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
            object Label19: TLabel
              Left = 122
              Top = 114
              Width = 34
              Height = 14
              Caption = 'T hold'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label20: TLabel
              Left = 10
              Top = 138
              Width = 33
              Height = 14
              Caption = 'V test'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label21: TLabel
              Left = 122
              Top = 138
              Width = 32
              Height = 14
              Caption = 'T test'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ckUseAnalogLeakCompensation: TCheckBox
              Left = 8
              Top = 12
              Width = 200
              Height = 17
              Hint = 
                'Use analog leak current compensation circuits during autocompens' +
                'ation'
              Caption = 'Use analog leak subtraction '
              Checked = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 0
              OnClick = ckUseAnalogLeakCompensationClick
            end
            object ckUseDigitalLeakCompensation: TCheckBox
              Left = 8
              Top = 28
              Width = 225
              Height = 17
              Hint = 'Use digital leak current subtraction during auto compensation'
              Caption = 'Use digital leak compensation'
              Checked = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 1
              OnClick = ckUseDigitalLeakCompensationClick
            end
            object ckUseDigitalArtefactSubtraction: TCheckBox
              Left = 8
              Top = 44
              Width = 200
              Height = 17
              Hint = 'Use digital artefact removal during auto compensation'
              Caption = 'Use digital artefact removal'
              Checked = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 2
              OnClick = ckUseDigitalArtefactSubtractionClick
            end
            object edCompensationCoeff: TValidatedEdit
              Left = 8
              Top = 168
              Width = 41
              Height = 21
              Hint = 
                '0=full compensation, >0 = under-compensation, <0 = over-compensa' +
                'tion'
              OnKeyPress = edCompensationCoeffKeyPress
              ShowHint = True
              Text = ' 0 '
              Scale = 1.000000000000000000
              NumberFormat = '%.4g'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
            object ckUseCSlowA: TCheckBox
              Left = 8
              Top = 76
              Width = 100
              Height = 17
              Hint = 'Use C slowA component during auto compensation '
              Caption = 'Use C slowA'
              Checked = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 4
              OnClick = ckUseCSlowAClick
            end
            object ckUseCSlowB: TCheckBox
              Left = 8
              Top = 92
              Width = 100
              Height = 17
              Hint = 'Use C slowB component during auto compensation '
              Caption = 'Use C slowB'
              Checked = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 5
              OnClick = ckUseCSlowBClick
            end
            object ckUseCSlowC: TCheckBox
              Left = 112
              Top = 76
              Width = 100
              Height = 17
              Hint = 'Use C slowC component during auto compensation '
              Caption = 'Use C slowC'
              Checked = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 6
              OnClick = ckUseCSlowCClick
            end
            object ckUseCSlowD: TCheckBox
              Left = 112
              Top = 92
              Width = 100
              Height = 17
              Hint = 'Use C slowD component during auto compensation '
              Caption = 'Use C slowD'
              Checked = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 7
              OnClick = ckUseCSlowDClick
            end
            object ckUseCFast: TCheckBox
              Left = 8
              Top = 60
              Width = 177
              Height = 17
              Hint = 'Use C slowA component during auto compensation '
              Caption = 'Use C fast'
              Checked = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 8
              OnClick = ckUseCFastClick
            end
            object edVHold: TValidatedEdit
              Left = 50
              Top = 116
              Width = 63
              Height = 21
              Hint = 'Holding voltage during auto compensation'
              OnKeyPress = edVHoldKeyPress
              ShowHint = True
              Text = ' -90 mV'
              Value = -0.090000003576278690
              Scale = 1000.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -0.200000002980232200
              HiLimit = 0.200000002980232200
            end
            object edTHold: TValidatedEdit
              Left = 162
              Top = 116
              Width = 63
              Height = 21
              Hint = 'Time at holding voltage during auto compensation'
              OnKeyPress = edTHoldKeyPress
              ShowHint = True
              Text = ' 20 ms'
              Value = 0.019999999552965160
              Scale = 1000.000000000000000000
              Units = 'ms'
              NumberFormat = '%.4g'
              LoLimit = 0.001000000047497451
              HiLimit = 1.000000000000000000
            end
            object edVStep: TValidatedEdit
              Left = 50
              Top = 140
              Width = 63
              Height = 21
              Hint = 'Auto compensation test pulse amplitude'
              OnKeyPress = edVStepKeyPress
              ShowHint = True
              Text = ' 10 mV'
              Value = 0.009999999776482582
              Scale = 1000.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -0.200000002980232200
              HiLimit = 0.200000002980232200
            end
            object edTStep: TValidatedEdit
              Left = 162
              Top = 140
              Width = 63
              Height = 21
              Hint = 'Auto compensation test pulse duration'
              OnKeyPress = edTStepKeyPress
              ShowHint = True
              Text = ' 20 ms'
              Value = 0.019999999552965160
              Scale = 1000.000000000000000000
              Units = 'ms'
              NumberFormat = '%.4g'
              LoLimit = 0.001000000047497451
              HiLimit = 1.000000000000000000
            end
          end
          object bAutoCompensate: TButton
            Left = 8
            Top = 8
            Width = 129
            Height = 17
            Hint = 'Automatically compensate for cell capacity and leak conductance'
            Caption = 'Auto Compensate'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = bAutoCompensateClick
          end
          object bClearCompensation: TButton
            Left = 8
            Top = 32
            Width = 129
            Height = 17
            Hint = 'Clear all capacity and leak conductance compensation'
            Caption = 'Clear Compensation'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = bClearCompensationClick
          end
          object bAutoJunctionNull: TButton
            Left = 144
            Top = 8
            Width = 129
            Height = 17
            Hint = 'Automatically compensate for junction potential offsets'
            Caption = 'Junct. Pot. Auto Zero'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = bAutoJunctionNullClick
          end
          object ckCompensateAllChannels: TCheckBox
            Left = 144
            Top = 30
            Width = 100
            Height = 17
            Hint = 'Apply compensation to all channels'
            Caption = 'All channels'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 4
            OnClick = ckCompensateAllChannelsClick
          end
        end
        object CapacityPage: TTabSheet
          Caption = 'Capacity'
          ImageIndex = 1
          object panCFast: TPanel
            Left = 1
            Top = 0
            Width = 280
            Height = 24
            BevelOuter = bvNone
            Caption = ' '
            TabOrder = 0
            object Label2: TLabel
              Left = 0
              Top = 0
              Width = 32
              Height = 14
              Caption = 'C fast'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object tbCFast: TTrackBar
              Left = 85
              Top = 0
              Width = 88
              Height = 20
              Max = 100
              Frequency = 10
              TabOrder = 0
              ThumbLength = 12
              OnChange = tbCFastChange
            end
            object edCFast: TValidatedEdit
              Left = 175
              Top = 0
              Width = 81
              Height = 23
              OnKeyPress = edCFastKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Text = ' 0.0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
          end
          object panCSlowA: TPanel
            Left = 1
            Top = 30
            Width = 280
            Height = 24
            BevelOuter = bvNone
            TabOrder = 1
            object Label3: TLabel
              Left = 0
              Top = 0
              Width = 83
              Height = 14
              Caption = 'C slowA (10us)'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ckCslowA: TCheckBox
              Left = 262
              Top = 0
              Width = 17
              Height = 17
              Caption = 'ckCfast'
              Checked = True
              State = cbChecked
              TabOrder = 0
              OnClick = ckCslowAClick
            end
            object tbCSlowA: TTrackBar
              Left = 85
              Top = 0
              Width = 88
              Height = 20
              Max = 100
              Frequency = 10
              TabOrder = 1
              ThumbLength = 12
              OnChange = tbCSlowAChange
            end
            object edCSlowA: TValidatedEdit
              Left = 175
              Top = 0
              Width = 81
              Height = 23
              OnKeyPress = edCSlowAKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Text = ' 0.0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
          end
          object panCSlowB: TPanel
            Left = 1
            Top = 60
            Width = 280
            Height = 24
            BevelOuter = bvNone
            TabOrder = 2
            object Label4: TLabel
              Left = 0
              Top = 0
              Width = 82
              Height = 14
              Caption = 'C slowB (33us)'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ckCslowB: TCheckBox
              Left = 262
              Top = 0
              Width = 17
              Height = 17
              Caption = 'ckCfast'
              Checked = True
              State = cbChecked
              TabOrder = 0
              OnClick = ckCslowBClick
            end
            object tbCSlowB: TTrackBar
              Left = 85
              Top = 0
              Width = 88
              Height = 20
              Max = 100
              Frequency = 10
              TabOrder = 1
              ThumbLength = 12
              OnChange = tbCSlowBChange
            end
            object edCSlowB: TValidatedEdit
              Left = 175
              Top = 0
              Width = 81
              Height = 23
              OnKeyPress = edCSlowBKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Text = ' 0.0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
          end
          object panCSlowC: TPanel
            Left = 1
            Top = 90
            Width = 280
            Height = 24
            BevelOuter = bvNone
            TabOrder = 3
            object Label5: TLabel
              Left = 0
              Top = 0
              Width = 89
              Height = 14
              Caption = 'C slowC (100us)'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ckCslowC: TCheckBox
              Left = 262
              Top = 0
              Width = 17
              Height = 17
              Caption = 'ckCfast'
              Checked = True
              State = cbChecked
              TabOrder = 0
              OnClick = ckCslowCClick
            end
            object tbCSlowC: TTrackBar
              Left = 85
              Top = -1
              Width = 88
              Height = 20
              Max = 100
              Frequency = 10
              TabOrder = 1
              ThumbLength = 12
              OnChange = tbCSlowCChange
            end
            object edCSlowC: TValidatedEdit
              Left = 175
              Top = 0
              Width = 81
              Height = 23
              OnKeyPress = edCSlowCKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Text = ' 0.0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
          end
          object panCSlowD: TPanel
            Left = 1
            Top = 119
            Width = 280
            Height = 24
            BevelOuter = bvNone
            TabOrder = 4
            object Label6: TLabel
              Left = 0
              Top = 0
              Width = 88
              Height = 14
              Caption = 'C slowD (330us)'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ckCslowD: TCheckBox
              Left = 262
              Top = 0
              Width = 17
              Height = 17
              Caption = 'ckCfast'
              Checked = True
              State = cbChecked
              TabOrder = 0
              OnClick = ckCslowDClick
            end
            object tbCSlowD: TTrackBar
              Left = 85
              Top = 0
              Width = 88
              Height = 20
              Max = 100
              Frequency = 10
              TabOrder = 1
              ThumbLength = 12
              OnChange = tbCSlowDChange
            end
            object edCSlowD: TValidatedEdit
              Left = 175
              Top = 0
              Width = 81
              Height = 23
              OnKeyPress = edCSlowDKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Text = ' 0.0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
          end
        end
        object ResistancePage: TTabSheet
          Caption = 'Resistance'
          ImageIndex = 2
          object panRLeak: TPanel
            Left = 1
            Top = 30
            Width = 280
            Height = 26
            BevelOuter = bvNone
            TabOrder = 0
            object Label9: TLabel
              Left = 0
              Top = 0
              Width = 33
              Height = 14
              Caption = 'R leak'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ckRleak: TCheckBox
              Left = 262
              Top = 0
              Width = 17
              Height = 17
              Caption = 'ckCfast'
              Checked = True
              State = cbChecked
              TabOrder = 0
              OnClick = ckRleakClick
            end
            object tbRLeak: TTrackBar
              Left = 85
              Top = 0
              Width = 88
              Height = 20
              Max = 100
              Frequency = 10
              TabOrder = 1
              ThumbLength = 12
              OnChange = tbRLeakChange
            end
            object edRLeak: TValidatedEdit
              Left = 175
              Top = 0
              Width = 81
              Height = 23
              OnKeyPress = edRLeakKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Text = ' 0.0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
          end
          object panRLeakFine: TPanel
            Left = 1
            Top = 60
            Width = 280
            Height = 26
            BevelOuter = bvNone
            TabOrder = 1
            object Label14: TLabel
              Left = 0
              Top = 0
              Width = 65
              Height = 14
              Caption = 'R leak (fine)'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ckRLeakFine: TCheckBox
              Left = 262
              Top = -1
              Width = 17
              Height = 17
              Caption = 'ckCfast'
              Checked = True
              State = cbChecked
              TabOrder = 0
              OnClick = ckRLeakFineClick
            end
            object tbRLeakFine: TTrackBar
              Left = 85
              Top = 0
              Width = 88
              Height = 20
              Max = 100
              Frequency = 10
              TabOrder = 1
              ThumbLength = 12
              OnChange = tbRLeakFineChange
            end
            object edRLeakFine: TValidatedEdit
              Left = 175
              Top = 0
              Width = 81
              Height = 23
              OnKeyPress = edRLeakFineKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Text = ' 0.0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
          end
          object panRSeries: TPanel
            Left = 1
            Top = 2
            Width = 280
            Height = 26
            BevelOuter = bvNone
            TabOrder = 2
            object Label7: TLabel
              Left = 0
              Top = 0
              Width = 46
              Height = 14
              Caption = 'R series'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ckRseries: TCheckBox
              Left = 262
              Top = 0
              Width = 17
              Height = 17
              Caption = 'ckCfast'
              Checked = True
              State = cbChecked
              TabOrder = 0
              OnClick = ckRseriesClick
            end
            object tbRSeries: TTrackBar
              Left = 85
              Top = 0
              Width = 88
              Height = 20
              Max = 100
              Frequency = 10
              TabOrder = 1
              ThumbLength = 12
              OnChange = tbRSeriesChange
            end
            object edRSeries: TValidatedEdit
              Left = 175
              Top = 0
              Width = 81
              Height = 23
              OnKeyPress = edRSeriesKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Text = ' 0.0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
          end
        end
        object JunctionPotPage: TTabSheet
          Caption = 'Junction Pot.'
          ImageIndex = 3
          object panJunctionPot: TPanel
            Left = 1
            Top = 2
            Width = 280
            Height = 24
            BevelOuter = bvNone
            TabOrder = 0
            object Label8: TLabel
              Left = 0
              Top = 0
              Width = 70
              Height = 14
              Caption = 'J. P. (coarse)'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ckJunctionPot: TCheckBox
              Left = 262
              Top = 5
              Width = 17
              Height = 17
              Caption = 'ckCfast'
              Checked = True
              State = cbChecked
              TabOrder = 0
              OnClick = ckJunctionPotClick
            end
            object tbJunctionPot: TTrackBar
              Left = 85
              Top = 0
              Width = 88
              Height = 20
              Max = 100
              Frequency = 10
              TabOrder = 1
              ThumbLength = 12
              OnChange = tbJunctionPotChange
            end
            object edJunctionPot: TValidatedEdit
              Left = 175
              Top = 0
              Width = 81
              Height = 23
              OnKeyPress = edJunctionPotKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Text = ' 0.0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
          end
          object panJunctionPotFIne: TPanel
            Left = 1
            Top = 30
            Width = 280
            Height = 24
            BevelOuter = bvNone
            TabOrder = 1
            object Label12: TLabel
              Left = 0
              Top = 0
              Width = 53
              Height = 14
              Caption = 'J. P. (fine)'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ckJunctionPotFine: TCheckBox
              Left = 262
              Top = 0
              Width = 17
              Height = 17
              Caption = 'ckCfast'
              Checked = True
              State = cbChecked
              TabOrder = 0
              OnClick = ckJunctionPotFineClick
            end
            object tbJunctionPotFine: TTrackBar
              Left = 85
              Top = 0
              Width = 88
              Height = 20
              Max = 100
              Frequency = 10
              TabOrder = 1
              ThumbLength = 12
              OnChange = tbJunctionPotFineChange
            end
            object edJunctionPotFine: TValidatedEdit
              Left = 175
              Top = 0
              Width = 81
              Height = 23
              OnKeyPress = edJunctionPotFineKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Text = ' 0.0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
          end
        end
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 40
      Width = 297
      Height = 45
      Caption = ' Select Channel'
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 45
        Height = 14
        Caption = 'Channel'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbChannel: TComboBox
        Left = 56
        Top = 16
        Width = 57
        Height = 21
        TabOrder = 0
        Text = 'cbChannel'
        OnChange = cbChannelChange
      end
      object bUpdateAllChannels: TButton
        Left = 120
        Top = 16
        Width = 169
        Height = 18
        Hint = 'Update all channels with the same settings'
        Caption = 'Update All Channels'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = bUpdateAllChannelsClick
      end
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 88
      Width = 297
      Height = 161
      Caption = ' Amplifier '
      TabOrder = 2
      object Label10: TLabel
        Left = 160
        Top = 16
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
      object lbSource: TLabel
        Left = 16
        Top = 16
        Width = 28
        Height = 14
        Alignment = taRightJustify
        Caption = 'Input'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 8
        Top = 42
        Width = 36
        Height = 14
        Alignment = taRightJustify
        Caption = 'Config'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbGain: TComboBox
        Left = 192
        Top = 16
        Width = 97
        Height = 21
        Hint = 'Amplifier gain / headstage feedback resistance'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'cbGain'
        OnChange = cbGainChange
      end
      object cbSource: TComboBox
        Left = 48
        Top = 16
        Width = 97
        Height = 21
        Hint = 'Input channel'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'cbGain'
        OnChange = cbSourceChange
      end
      object cbUserConfig: TComboBox
        Left = 48
        Top = 42
        Width = 241
        Height = 21
        Hint = 'Amplifer voltage/current clamp mode'
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnChange = cbUserConfigChange
      end
      object bCalibrate: TButton
        Left = 48
        Top = 132
        Width = 241
        Height = 18
        Hint = 
          'Start amplifier gain calibration procedure (may take 30-60 secon' +
          'ds)'
        Caption = 'Calibrate Amplifier'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = bCalibrateClick
      end
      object gpCurrentStimulus: TGroupBox
        Left = 48
        Top = 62
        Width = 241
        Height = 65
        Caption = ' Current Stimulus '
        TabOrder = 4
        object Label22: TLabel
          Left = 135
          Top = 16
          Width = 88
          Height = 14
          Hint = 
            'Current offset used to correct for stimulus bias current of Pico' +
            ' amplifiier'
          Caption = 'Zero Correction'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ckICLAMPOn: TCheckBox
          Left = 8
          Top = 16
          Width = 117
          Height = 17
          Caption = 'Enable Stimulus'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = ckICLAMPOnClick
        end
        object edCurrentStimulusBias: TValidatedEdit
          Left = 135
          Top = 34
          Width = 86
          Height = 21
          Hint = 'Stimulus bias current offset to correct current zero '
          OnKeyPress = edCurrentStimulusBiasKeyPress
          ShowHint = True
          Text = ' 0 pA'
          Scale = 1.000000000000000000
          Units = 'pA'
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
      end
    end
    object GroupBox5: TGroupBox
      Left = 8
      Top = 255
      Width = 297
      Height = 43
      Caption = ' Filters '
      TabOrder = 3
      object Label11: TLabel
        Left = 16
        Top = 14
        Width = 83
        Height = 14
        Caption = 'Low pass filter'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edFilter: TEdit
        Left = 198
        Top = 16
        Width = 73
        Height = 20
        Hint = 'Low pass filtter cut-off frequency '
        AutoSize = False
        Ctl3D = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Text = 'edCFast'
      end
      object tbFilter: TTrackBar
        Left = 104
        Top = 14
        Width = 88
        Height = 20
        Hint = 'Select low pass filer cut-off'
        Max = 100
        ParentShowHint = False
        Frequency = 10
        ShowHint = True
        TabOrder = 1
        ThumbLength = 12
        OnChange = tbFilterChange
      end
    end
    object edModel: TEdit
      Left = 8
      Top = 16
      Width = 297
      Height = 21
      ReadOnly = True
      TabOrder = 4
      Text = 'edModel'
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 613
      Width = 305
      Height = 53
      TabOrder = 5
      object Label15: TLabel
        Left = 96
        Top = 14
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
      object Label16: TLabel
        Left = 216
        Top = 14
        Width = 21
        Height = 14
        Caption = 'Dur.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object bZap: TButton
        Left = 8
        Top = 12
        Width = 81
        Height = 17
        Hint = 'Apply high voltage shock to cell'
        Caption = 'Zap Cell'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = bZapClick
      end
      object edZapDuration: TValidatedEdit
        Left = 156
        Top = 14
        Width = 49
        Height = 21
        Text = ' 1 V'
        Value = 1.000000000000000000
        Scale = 1.000000000000000000
        Units = 'V'
        NumberFormat = '%.4g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edZapAmplitude: TValidatedEdit
        Left = 240
        Top = 14
        Width = 49
        Height = 21
        Text = ' 0.1 s'
        Value = 0.100000001490116100
        Scale = 1.000000000000000000
        Units = 's'
        NumberFormat = '%.4g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object ckZapAllChannels: TCheckBox
        Left = 8
        Top = 32
        Width = 105
        Height = 17
        Caption = 'All Channels'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
    end
    object ckEnableDACStreaming: TCheckBox
      Left = 8
      Top = 669
      Width = 193
      Height = 17
      Hint = 'Select streaming stimulus mode (stimuli defined point by point)'
      Caption = 'Stimulus streaming enabled'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = ckEnableDACStreamingClick
    end
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 312
    Top = 112
  end
end
