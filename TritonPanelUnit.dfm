object TritonPanelFrm: TTritonPanelFrm
  Left = 598
  Top = 11
  Caption = 'Tecella Patch Clamp '
  ClientHeight = 667
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object gControls: TGroupBox
    Left = 8
    Top = 0
    Width = 356
    Height = 657
    TabOrder = 0
    object gCompensation: TGroupBox
      Left = 8
      Top = 278
      Width = 340
      Height = 311
      Caption = ' Compensation '
      TabOrder = 0
      object AutoCompPage: TPageControl
        Left = 3
        Top = 22
        Width = 320
        Height = 288
        ActivePage = AutoPage
        TabOrder = 0
        object AutoPage: TTabSheet
          Caption = 'Auto'
          object ckCompensateAllChannels: TCheckBox
            Left = 167
            Top = 240
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
            TabOrder = 0
            OnClick = ckCompensateAllChannelsClick
          end
          object gAutoCapacityComp: TGroupBox
            Left = 3
            Top = 3
            Width = 148
            Height = 110
            Caption = ' Cell Capacity '
            TabOrder = 1
            object bCFastAutoComp: TButton
              Left = 8
              Top = 15
              Width = 130
              Height = 17
              Hint = 'Automatically compensate for fast component of cell capacity'
              Caption = 'Compensate Cfast'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = bCFastAutoCompClick
            end
            object bCSlowAutoComp: TButton
              Left = 8
              Top = 38
              Width = 130
              Height = 17
              Hint = 'Automatically compensate for slow component of cell capacity'
              Caption = 'Compensate Cslow'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = bCSlowAutoCompClick
            end
            object bClearCompensation: TButton
              Left = 8
              Top = 82
              Width = 130
              Height = 17
              Hint = 'Clear fast and slow capacity compensation'
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
            object bAutoCompArtefact: TButton
              Left = 8
              Top = 59
              Width = 130
              Height = 17
              Hint = 
                'Remove any arterfact current remaining after capacity compensati' +
                'on'
              Caption = 'Compensate Artefact'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = bAutoCompArtefactClick
            end
          end
          object gAutoJPComp: TGroupBox
            Left = 156
            Top = 3
            Width = 148
            Height = 65
            Caption = ' Junction Potential '
            TabOrder = 2
            object bAutoCompJunctionPot: TButton
              Left = 15
              Top = 18
              Width = 130
              Height = 17
              Hint = 'Automatically compensate for junction potential offsets'
              Caption = 'Compensate J. Pot.'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = bAutoCompJunctionPotClick
            end
            object bClearJPComp: TButton
              Left = 8
              Top = 41
              Width = 130
              Height = 17
              Hint = 'Clear junction potential compensation'
              Caption = 'Clear Compensation'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = bClearJPCompClick
            end
          end
          object gAutoLeakComp: TGroupBox
            Left = 156
            Top = 74
            Width = 148
            Height = 65
            Caption = ' Leak Conductance '
            TabOrder = 3
            object bAutoLeakComp: TButton
              Left = 15
              Top = 17
              Width = 130
              Height = 17
              Hint = 'Automatically subtract leak conductance'
              Caption = ' Compensate Leak'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = bAutoLeakCompClick
            end
            object bClearLeakComp: TButton
              Left = 15
              Top = 40
              Width = 130
              Height = 17
              Hint = 'Clear leak conductance compensation'
              Caption = 'Clear Compensation'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = bClearLeakCompClick
            end
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
              Max = 1000
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
            object ckCFast: TCheckBox
              Left = 263
              Top = 7
              Width = 17
              Height = 17
              Hint = 'Check to enable compensation'
              Caption = 'ckCfast'
              Checked = True
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 2
              OnClick = ckCFastClick
            end
          end
          object panCTotal: TPanel
            Left = 3
            Top = 159
            Width = 280
            Height = 24
            BevelOuter = bvNone
            TabOrder = 1
          end
          object panCSlowTotal: TPanel
            Left = 1
            Top = 26
            Width = 280
            Height = 24
            BevelOuter = bvNone
            TabOrder = 2
            object Label24: TLabel
              Left = 0
              Top = 0
              Width = 38
              Height = 14
              Caption = 'C slow'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object edCSlowTotal: TValidatedEdit
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
              Text = ' 0.0 pF'
              Scale = 1.000000000000000000
              Units = 'pF'
              NumberFormat = '%.1f'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
            object ckCSlow: TCheckBox
              Left = 262
              Top = 8
              Width = 17
              Height = 17
              Hint = 'Check to enable compensation'
              Caption = 'ckCfast'
              Checked = True
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 1
              OnClick = ckCSlowClick
            end
            object CheckBox2: TCheckBox
              Left = 8
              Top = 24
              Width = 25
              Height = 1
              Caption = 'CheckBox2'
              TabOrder = 2
            end
          end
          object pCSlowComponents: TPanel
            Left = 1
            Top = 80
            Width = 281
            Height = 105
            BevelOuter = bvNone
            TabOrder = 3
            object panCSlowD: TPanel
              Left = 0
              Top = 78
              Width = 280
              Height = 24
              BevelOuter = bvNone
              TabOrder = 0
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
                Hint = 'Check to enable compensation'
                Caption = 'ckCfast'
                Checked = True
                ParentShowHint = False
                ShowHint = True
                State = cbChecked
                TabOrder = 0
                OnClick = ckCslowDClick
              end
              object tbCSlowD: TTrackBar
                Left = 85
                Top = 0
                Width = 88
                Height = 20
                Max = 1000
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
            object panCSlowC: TPanel
              Left = 0
              Top = 52
              Width = 280
              Height = 24
              BevelOuter = bvNone
              TabOrder = 1
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
                Hint = 'Check to enable compensation'
                Caption = 'ckCfast'
                Checked = True
                ParentShowHint = False
                ShowHint = True
                State = cbChecked
                TabOrder = 0
                OnClick = ckCslowCClick
              end
              object tbCSlowC: TTrackBar
                Left = 85
                Top = -1
                Width = 88
                Height = 20
                Max = 1000
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
            object panCSlowB: TPanel
              Left = 0
              Top = 26
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
                Hint = 'Check to enable compensation'
                Caption = 'ckCfast'
                Checked = True
                ParentShowHint = False
                ShowHint = True
                State = cbChecked
                TabOrder = 0
                OnClick = ckCslowBClick
              end
              object tbCSlowB: TTrackBar
                Left = 85
                Top = 0
                Width = 88
                Height = 20
                Max = 1000
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
            object panCSlowA: TPanel
              Left = 0
              Top = 0
              Width = 280
              Height = 24
              BevelOuter = bvNone
              TabOrder = 3
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
                Hint = 'Check to enable compensation'
                Caption = 'ckCfast'
                Checked = True
                ParentShowHint = False
                ShowHint = True
                State = cbChecked
                TabOrder = 0
                OnClick = ckCslowAClick
              end
              object tbCSlowA: TTrackBar
                Left = 85
                Top = 0
                Width = 88
                Height = 20
                Max = 1000
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
          end
          object ckShowCSlowComponents: TCheckBox
            Left = 0
            Top = 55
            Width = 184
            Height = 17
            Caption = 'Show C slow components'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
            OnClick = ckShowCSlowComponentsClick
          end
        end
        object ResistancePage: TTabSheet
          Caption = 'Resistance'
          ImageIndex = 2
          object panRSeries: TPanel
            Left = 1
            Top = 2
            Width = 280
            Height = 26
            BevelOuter = bvNone
            TabOrder = 0
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
              Top = 5
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
              Top = 2
              Width = 88
              Height = 20
              Max = 1000
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
              Hint = 'Series resistance compensation setting'
              OnKeyPress = edRSeriesKeyPress
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ShowHint = True
              Text = ' 0 mV'
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -1000000.000000000000000000
              HiLimit = 1000000.000000000000000000
            end
          end
          object pRLeakComponents: TPanel
            Left = 1
            Top = 86
            Width = 297
            Height = 83
            BevelOuter = bvNone
            TabOrder = 1
            object panRLeakAnalog: TPanel
              Left = 0
              Top = 0
              Width = 280
              Height = 26
              BevelOuter = bvNone
              TabOrder = 0
              object Label9: TLabel
                Left = 0
                Top = 0
                Width = 81
                Height = 14
                Caption = 'G leak (analog)'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object ckRleakAnalog: TCheckBox
                Left = 262
                Top = 2
                Width = 17
                Height = 17
                Caption = 'ckCfast'
                Checked = True
                State = cbChecked
                TabOrder = 0
                OnClick = ckRleakAnalogClick
              end
              object tbRLeakAnalog: TTrackBar
                Left = 85
                Top = 0
                Width = 88
                Height = 20
                Max = 1000
                Frequency = 10
                TabOrder = 1
                ThumbLength = 12
                OnChange = tbRLeakAnalogChange
              end
              object edRLeakAnalog: TValidatedEdit
                Left = 175
                Top = 0
                Width = 81
                Height = 23
                Hint = 'Leak conductance compensation setting (coarse)'
                OnKeyPress = edRLeakAnalogKeyPress
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = []
                ShowHint = True
                Text = ' 0 mV'
                Scale = 1.000000000000000000
                Units = 'mV'
                NumberFormat = '%.4g'
                LoLimit = -1000.000000000000000000
                HiLimit = 1000.000000000000000000
              end
            end
            object panRLeakFineAnalog: TPanel
              Left = 1
              Top = 26
              Width = 280
              Height = 26
              BevelOuter = bvNone
              TabOrder = 1
              object Label14: TLabel
                Left = 0
                Top = 0
                Width = 82
                Height = 14
                Caption = 'G leak fine (an)'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object ckRLeakFineAnalog: TCheckBox
                Left = 262
                Top = 2
                Width = 17
                Height = 17
                Caption = 'ckCfast'
                Checked = True
                State = cbChecked
                TabOrder = 0
                OnClick = ckRLeakFineAnalogClick
              end
              object tbRLeakFineAnalog: TTrackBar
                Left = 85
                Top = 0
                Width = 88
                Height = 20
                Max = 1000
                Frequency = 10
                TabOrder = 1
                ThumbLength = 12
                OnChange = tbRLeakFineAnalogChange
              end
              object edRLeakFineAnalog: TValidatedEdit
                Left = 175
                Top = 0
                Width = 81
                Height = 23
                Hint = 'Leak conductance compensation setting (fine)'
                OnKeyPress = edRLeakFineAnalogKeyPress
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = []
                ShowHint = True
                Text = ' 0 mV'
                Scale = 1.000000000000000000
                Units = 'mV'
                NumberFormat = '%.4g'
                LoLimit = -1000.000000000000000000
                HiLimit = 1000.000000000000000000
              end
            end
            object panRleakDigital: TPanel
              Left = 0
              Top = 52
              Width = 280
              Height = 24
              BevelOuter = bvNone
              TabOrder = 2
              object Label18: TLabel
                Left = 0
                Top = 0
                Width = 78
                Height = 14
                Caption = 'G leak (digital)'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object edRLeakDigital: TValidatedEdit
                Left = 175
                Top = 0
                Width = 81
                Height = 23
                Hint = 'Leak conductance compensation setting (digital)'
                OnKeyPress = edCSlowDKeyPress
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = []
                ShowHint = True
                Text = ' 0 nS'
                Scale = 1000.000000000000000000
                Units = 'nS'
                NumberFormat = '%.4g'
                LoLimit = -1000.000000000000000000
                HiLimit = 1000.000000000000000000
              end
              object ckRLeakDigital: TCheckBox
                Left = 262
                Top = 3
                Width = 17
                Height = 17
                Hint = 'Check to enable compensation'
                Caption = 'ckCfast'
                Checked = True
                ParentShowHint = False
                ShowHint = True
                State = cbChecked
                TabOrder = 1
                OnClick = ckRLeakDigitalClick
              end
              object CheckBox3: TCheckBox
                Left = 8
                Top = 24
                Width = 25
                Height = 1
                Caption = 'CheckBox2'
                TabOrder = 2
              end
            end
          end
          object Panel1: TPanel
            Left = 1
            Top = 28
            Width = 280
            Height = 24
            BevelOuter = bvNone
            TabOrder = 2
            object Label19: TLabel
              Left = 0
              Top = 0
              Width = 34
              Height = 14
              Caption = 'G leak'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object edRLeakTotal: TValidatedEdit
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
              Text = ' 0 nS'
              Scale = 1000.000000000000000000
              Units = 'nS'
              NumberFormat = '%.4g'
              LoLimit = -1000.000000000000000000
              HiLimit = 1000.000000000000000000
            end
            object ckRLeak: TCheckBox
              Left = 262
              Top = 8
              Width = 17
              Height = 17
              Hint = 'Check to enable compensation'
              Caption = 'ckCfast'
              Checked = True
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 1
              OnClick = ckRLeakClick
            end
            object CheckBox4: TCheckBox
              Left = 8
              Top = 24
              Width = 25
              Height = 1
              Caption = 'CheckBox2'
              TabOrder = 2
            end
          end
          object ckShowRLeakComponents: TCheckBox
            Left = 8
            Top = 63
            Width = 184
            Height = 17
            Caption = 'Show G leak components'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            OnClick = ckShowRLeakComponentsClick
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
        object AdvancedTab: TTabSheet
          Caption = 'Adv.'
          ImageIndex = 4
          object GroupBox6: TGroupBox
            Left = 3
            Top = 29
            Width = 300
            Height = 201
            TabOrder = 0
            object Label17: TLabel
              Left = 59
              Top = 36
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
            object edCompensationCoeff: TValidatedEdit
              Left = 8
              Top = 36
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
            object ckEnableDACStreaming: TCheckBox
              Left = 8
              Top = 13
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
              TabOrder = 1
              OnClick = ckEnableDACStreamingClick
            end
          end
          object bCalibrate: TButton
            Left = 3
            Top = 6
            Width = 300
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
            TabOrder = 1
            OnClick = bCalibrateClick
          end
        end
      end
    end
    object gChannel: TGroupBox
      Left = 8
      Top = 40
      Width = 340
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
    object gAmplifier: TGroupBox
      Left = 8
      Top = 88
      Width = 340
      Height = 137
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
      object gpCurrentStimulus: TGroupBox
        Left = 48
        Top = 62
        Width = 241
        Height = 65
        Caption = ' Current Stimulus '
        TabOrder = 3
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
    object gFilter: TGroupBox
      Left = 8
      Top = 228
      Width = 340
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
      Width = 340
      Height = 21
      ReadOnly = True
      TabOrder = 4
      Text = 'edModel'
    end
    object gZap: TGroupBox
      Left = 8
      Top = 594
      Width = 340
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
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 312
    Top = 112
  end
end
