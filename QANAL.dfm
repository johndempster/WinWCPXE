object QuantFrm: TQuantFrm
  Left = 543
  Top = 243
  Width = 553
  Height = 484
  Caption = 'Quantal Analysis'
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
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object ControlGrp: TGroupBox
    Left = 8
    Top = 0
    Width = 121
    Height = 73
    Caption = ' Analysis '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object bDoAnalysis: TButton
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Hint = 'Start quantal content analysis'
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
    object rbPoisson: TRadioButton
      Left = 8
      Top = 34
      Width = 105
      Height = 17
      Hint = 'Use Poisson distribution statistics in analysis'
      Caption = 'Poisson'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object rbBinomial: TRadioButton
      Left = 8
      Top = 48
      Width = 89
      Height = 17
      Hint = 'Use binomial distribution statistics in analysis'
      Caption = 'Binomial '
      Checked = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TabStop = True
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 176
    Width = 121
    Height = 49
    Caption = ' Evoked event '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label5: TLabel
      Left = 8
      Top = 24
      Width = 26
      Height = 15
      Caption = 'Type'
    end
    object cbEvokedType: TComboBox
      Left = 40
      Top = 19
      Width = 73
      Height = 23
      Hint = 'Record type which contains stimulus-evoked synaptic signals'
      ItemHeight = 15
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'cbEvokedType'
    end
  end
  object MiniGrp: TGroupBox
    Left = 8
    Top = 224
    Width = 121
    Height = 169
    Caption = ' Quantum event '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 26
      Height = 15
      Caption = 'Type'
    end
    object Label3: TLabel
      Left = 40
      Top = 80
      Width = 55
      Height = 15
      Caption = 'Amplitude'
    end
    object Label4: TLabel
      Left = 32
      Top = 120
      Width = 77
      Height = 15
      Caption = 'Standard Dev.'
    end
    object cbMiniType: TComboBox
      Left = 40
      Top = 35
      Width = 73
      Height = 23
      Hint = 
        'Record type  containing spontaneous single-quantum synaptic sign' +
        'als'
      ItemHeight = 15
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'cbEvokedType'
    end
    object rbMiniEventsAvailable: TRadioButton
      Left = 8
      Top = 16
      Width = 105
      Height = 17
      Hint = 
        'The data file contains records with single quantum "mini" signal' +
        '. Use them in the analysis'
      Caption = 'Events in file'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = True
      OnClick = rbMiniEventsAvailableClick
    end
    object rbUserEntered: TRadioButton
      Left = 8
      Top = 64
      Width = 105
      Height = 17
      Hint = 
        'Use a manually-entered value for the amplitude of the single-qua' +
        'ntum signal'
      Caption = 'User entered'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = rbUserEnteredClick
    end
    object edMiniAmplitude: TValidatedEdit
      Left = 32
      Top = 96
      Width = 81
      Height = 20
      AutoSize = False
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edMiniStDev: TValidatedEdit
      Left = 32
      Top = 136
      Width = 81
      Height = 20
      AutoSize = False
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
  end
  object ModeGrp: TGroupBox
    Left = 136
    Top = 304
    Width = 321
    Height = 89
    Caption = ' Mode '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Label1: TLabel
      Left = 88
      Top = 24
      Width = 65
      Height = 41
      AutoSize = False
      Caption = 'Resting potential'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label6: TLabel
      Left = 160
      Top = 24
      Width = 65
      Height = 33
      AutoSize = False
      Caption = 'Reversal potential'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label7: TLabel
      Left = 232
      Top = 24
      Width = 65
      Height = 33
      AutoSize = False
      Caption = 'Correction Factor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object rbCurrent: TRadioButton
      Left = 8
      Top = 16
      Width = 73
      Height = 17
      Hint = 'Synaptic currents are to be analysed '
      Caption = 'Currents'
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
      OnClick = rbCurrentClick
    end
    object rbPotentials: TRadioButton
      Left = 8
      Top = 32
      Width = 73
      Height = 17
      Hint = 
        'Synaptic potentials are to analysed (use non-linear summation co' +
        'rrection)'
      Caption = 'Potentials'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = rbPotentialsClick
    end
    object edVRest: TValidatedEdit
      Left = 88
      Top = 53
      Width = 65
      Height = 20
      AutoSize = False
      Text = ' -90.0 mV'
      Value = -90.000000000000000000
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%.1f'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edVRev: TValidatedEdit
      Left = 160
      Top = 53
      Width = 65
      Height = 20
      AutoSize = False
      Text = ' 0.0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%.1f'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edCorrectionFactor: TValidatedEdit
      Left = 232
      Top = 53
      Width = 57
      Height = 20
      AutoSize = False
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000000000000000
    end
  end
  object mmResults: TMemo
    Left = 136
    Top = 8
    Width = 321
    Height = 289
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object GroupBox8: TGroupBox
    Left = 8
    Top = 72
    Width = 121
    Height = 105
    Caption = ' Record Range '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object Label8: TLabel
      Left = 8
      Top = 72
      Width = 19
      Height = 15
      Caption = 'Ch.'
    end
    object rbAllRecords: TRadioButton
      Left = 8
      Top = 16
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
    object rbRange: TRadioButton
      Left = 8
      Top = 32
      Width = 81
      Height = 17
      Hint = 'Analysis a limited range of records within the data file'
      Caption = 'Range'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object cbChannel: TComboBox
      Left = 32
      Top = 72
      Width = 81
      Height = 23
      Hint = 'Input channel to be analysed'
      ItemHeight = 15
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = 'cbChannel'
      OnChange = cbChannelChange
    end
    object edRecRange: TRangeEdit
      Left = 24
      Top = 48
      Width = 89
      Height = 23
      Text = ' 0 - 1.00000001504746624E30 '
      HiValue = 1.000000015047466E30
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.f - %.f'
    end
  end
end
