object RecordFrm: TRecordFrm
  Left = 1170
  Top = 253
  Caption = 'Record to Disk'
  ClientHeight = 726
  ClientWidth = 830
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
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
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 218
    Top = 8
    Width = 32
    Height = 16
    Caption = 'Ident.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object scDisplay: TScopeDisplay
    Left = 218
    Top = 32
    Width = 529
    Height = 313
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
    MaxADCValue = 32768
    MinADCValue = -32768
    NumBytesPerSample = 2
    FloatingPointSamples = False
    FixZeroLevels = False
    DisplaySelected = False
    FontSize = 8
  end
  object ControlGrp: TGroupBox
    Left = 4
    Top = 1
    Width = 208
    Height = 88
    Caption = ' Record '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object bRecord: TButton
      Left = 8
      Top = 15
      Width = 129
      Height = 17
      Hint = 'Start Recording (F1)'
      Caption = 'Record'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = bRecordClick
    end
    object bStop: TButton
      Left = 144
      Top = 15
      Width = 57
      Height = 17
      Hint = 'Stop Recording (F2)'
      Caption = 'Stop'
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
      OnClick = bStopClick
    end
    object ckSaveRecords: TCheckBox
      Left = 112
      Top = 38
      Width = 88
      Height = 17
      Caption = 'Save to File'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 2
    end
    object bErase: TButton
      Left = 8
      Top = 36
      Width = 89
      Height = 17
      Hint = 'Erase trace(s) from display screen'
      Caption = 'Erase Screen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = bEraseClick
    end
    object ckNewFileOnRecord: TCheckBox
      Left = 8
      Top = 56
      Width = 193
      Height = 17
      Hint = 'Stimulus protocol included in file name'
      Caption = 'Incl. stim protocol in file name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = ckNewFileOnRecordClick
    end
  end
  object DisplayGrp: TGroupBox
    Left = 4
    Top = 398
    Width = 208
    Height = 67
    Caption = ' Amplifier Gain / Mode  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object panAmplifierGain0: TPanel
      Left = 4
      Top = 16
      Width = 202
      Height = 44
      BevelOuter = bvNone
      TabOrder = 0
      object lbAmplifier: TLabel
        Left = 0
        Top = 0
        Width = 47
        Height = 15
        Caption = '1. (Ch.0)'
      end
      object edAmplifierGain0: TValidatedEdit
        Left = 56
        Top = 0
        Width = 137
        Height = 20
        OnKeyPress = edAmplifierGain0KeyPress
        AutoSize = False
        Text = ' 0 '
        Scale = 1.000000000000000000
        NumberFormat = '%.6g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object rbVCLAMP0: TRadioButton
        Left = 56
        Top = 21
        Width = 63
        Height = 20
        Caption = 'VClamp'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = rbVCLAMP0Click
      end
      object rbICLAMP0: TRadioButton
        Left = 124
        Top = 21
        Width = 73
        Height = 20
        Caption = 'IClamp'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = rbICLAMP0Click
      end
    end
    object panAmplifierGain1: TPanel
      Left = 4
      Top = 64
      Width = 202
      Height = 44
      BevelOuter = bvNone
      TabOrder = 1
      object Label14: TLabel
        Left = 0
        Top = 0
        Width = 47
        Height = 15
        Caption = '2. (Ch.2)'
      end
      object edAmplifierGain1: TValidatedEdit
        Left = 56
        Top = 0
        Width = 137
        Height = 20
        OnKeyPress = edAmplifierGain0KeyPress
        AutoSize = False
        Text = ' 0 '
        Scale = 1.000000000000000000
        NumberFormat = '%.6g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object rbVCLAMP1: TRadioButton
        Tag = 1
        Left = 56
        Top = 21
        Width = 63
        Height = 20
        Caption = 'VClamp'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = rbVCLAMP0Click
      end
      object RBICLAMP1: TRadioButton
        Tag = 1
        Left = 124
        Top = 21
        Width = 73
        Height = 20
        Caption = 'IClamp'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = rbICLAMP0Click
      end
    end
    object panAmplifierGain2: TPanel
      Left = 4
      Top = 112
      Width = 202
      Height = 44
      BevelOuter = bvNone
      TabOrder = 2
      object Label15: TLabel
        Left = 0
        Top = 0
        Width = 47
        Height = 15
        Caption = '3. (Ch.4)'
      end
      object edAmplifierGain2: TValidatedEdit
        Left = 56
        Top = 0
        Width = 137
        Height = 20
        OnKeyPress = edAmplifierGain0KeyPress
        AutoSize = False
        Text = ' 0 '
        Scale = 1.000000000000000000
        NumberFormat = '%.6g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object rbVCLAMP2: TRadioButton
        Tag = 2
        Left = 56
        Top = 21
        Width = 63
        Height = 20
        Caption = 'VClamp'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = rbVCLAMP0Click
      end
      object RBICLAMP2: TRadioButton
        Tag = 2
        Left = 124
        Top = 21
        Width = 73
        Height = 20
        Caption = 'IClamp'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = rbICLAMP0Click
      end
    end
    object panAmplifierGain3: TPanel
      Left = 4
      Top = 160
      Width = 202
      Height = 44
      BevelOuter = bvNone
      TabOrder = 3
      object Label16: TLabel
        Left = 0
        Top = 0
        Width = 47
        Height = 15
        Caption = '4. (Ch.6)'
      end
      object edAmplifierGain3: TValidatedEdit
        Left = 56
        Top = 0
        Width = 137
        Height = 20
        OnKeyPress = edAmplifierGain0KeyPress
        AutoSize = False
        Text = ' 0 '
        Scale = 1.000000000000000000
        NumberFormat = '%.6g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object rbVCLAMP3: TRadioButton
        Tag = 3
        Left = 56
        Top = 21
        Width = 63
        Height = 20
        Caption = 'VClamp'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = rbVCLAMP0Click
      end
      object rbICLAMP3: TRadioButton
        Tag = 3
        Left = 124
        Top = 21
        Width = 73
        Height = 20
        Caption = 'IClamp'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = rbICLAMP0Click
      end
    end
  end
  object edStatus: TEdit
    Left = 218
    Top = 360
    Width = 321
    Height = 20
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
  object edIdent: TEdit
    Left = 255
    Top = 8
    Width = 369
    Height = 20
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnKeyPress = edIdentKeyPress
  end
  object TimerGrp: TGroupBox
    Left = 4
    Top = 514
    Width = 208
    Height = 79
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object Label6: TLabel
      Left = 8
      Top = 12
      Width = 28
      Height = 15
      Caption = 'Time'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 144
      Top = 12
      Width = 37
      Height = 15
      Caption = 'Marker'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel4: TBevel
      Left = 130
      Top = 12
      Width = 1
      Height = 60
    end
    object edTimeOfDay: TEdit
      Left = 6
      Top = 28
      Width = 107
      Height = 22
      AutoSize = False
      ReadOnly = True
      TabOrder = 0
      Text = 'edTimeOfDay'
    end
    object bResetTimer: TButton
      Left = 6
      Top = 54
      Width = 107
      Height = 18
      Hint = 'Set elapsed time to zero'
      Caption = 'Reset'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = bResetTimerClick
    end
    object edMarker: TEdit
      Left = 144
      Top = 28
      Width = 57
      Height = 22
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = ' '
    end
  end
  object OnLineAnalysisGrp: TGroupBox
    Left = 4
    Top = 470
    Width = 208
    Height = 43
    Caption = ' On-line Analysis Window '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object bOpenOLAWindow: TButton
      Left = 8
      Top = 18
      Width = 113
      Height = 17
      Caption = 'Open'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = bOpenOLAWindowClick
    end
    object bCloseOLAWindow: TButton
      Left = 128
      Top = 18
      Width = 73
      Height = 17
      Caption = 'Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bCloseOLAWindowClick
    end
  end
  object ckFixedZeroLevels: TCheckBox
    Left = 218
    Top = 388
    Width = 129
    Height = 16
    Hint = 'Keep measurement zero levels fixed at true zero'
    Caption = 'Fix Zero Levels'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = ckFixedZeroLevelsClick
  end
  object RecordModeGrp: TGroupBox
    Left = 4
    Top = 92
    Width = 208
    Height = 305
    Caption = ' Recording Mode '
    TabOrder = 7
    object cbRecordingMode: TComboBox
      Left = 8
      Top = 16
      Width = 192
      Height = 24
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbRecordingModeChange
    end
    object RecordParametersPanel: TPanel
      Left = 8
      Top = 48
      Width = 192
      Height = 249
      BevelOuter = bvNone
      TabOrder = 1
      object Label3: TLabel
        Left = 2
        Top = 2
        Width = 106
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'No. records'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label10: TLabel
        Left = 2
        Top = 80
        Width = 106
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'No. samples'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label11: TLabel
        Left = 2
        Top = 54
        Width = 106
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'No. input channels'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 2
        Top = 106
        Width = 106
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Sampling interval'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label13: TLabel
        Left = 2
        Top = 28
        Width = 106
        Height = 17
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Record duration'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object edNumRecords: TValidatedEdit
        Left = 110
        Top = 2
        Width = 82
        Height = 22
        OnKeyPress = edNumRecordsKeyPress
        AutoSize = False
        Text = ' 1 '
        Value = 1.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%.4g'
        LoLimit = 1.000000000000000000
        HiLimit = 1.000000015047466E30
      end
      object edNumSamples: TValidatedEdit
        Left = 110
        Top = 80
        Width = 82
        Height = 22
        OnKeyPress = edNumSamplesKeyPress
        AutoSize = False
        Text = '      256 '
        Value = 256.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%8.0f'
        LoLimit = 256.000000000000000000
        HiLimit = 1.000000015047466E30
      end
      object edNumChannels: TValidatedEdit
        Left = 110
        Top = 54
        Width = 82
        Height = 22
        OnKeyPress = edNumChannelsKeyPress
        AutoSize = False
        Text = ' 1 '
        Value = 1.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%.4g'
        LoLimit = 1.000000000000000000
        HiLimit = 1.000000015047466E30
      end
      object edSamplingInterval: TValidatedEdit
        Left = 110
        Top = 106
        Width = 82
        Height = 22
        OnKeyPress = edSamplingIntervalKeyPress
        AutoSize = False
        Text = ' 0 ms'
        Scale = 1000.000000000000000000
        Units = 'ms'
        NumberFormat = '%.4g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edRecordDuration: TValidatedEdit
        Left = 110
        Top = 28
        Width = 82
        Height = 22
        OnKeyPress = edRecordDurationKeyPress
        AutoSize = False
        Text = ' 0 ms'
        Scale = 1000.000000000000000000
        Units = 'ms'
        NumberFormat = '%.6g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object ExtTriggerGrp: TGroupBox
        Left = 0
        Top = 128
        Width = 190
        Height = 57
        Caption = ' Trigger Level'
        TabOrder = 5
        object rbExtTriggerHigh: TRadioButton
          Left = 8
          Top = 18
          Width = 140
          Height = 15
          Hint = 'Trigger on a 0V to 5V transition'
          Caption = 'Active High (5V)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = rbExtTriggerHighClick
        end
        object rbExttriggerLow: TRadioButton
          Left = 8
          Top = 34
          Width = 140
          Height = 15
          Hint = 'Trigger on a 5V to 0V transition'
          Caption = 'Active Low (0V)'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TabStop = True
          OnClick = rbExttriggerLowClick
        end
      end
      object DetectGrp: TGroupBox
        Left = 0
        Top = 128
        Width = 192
        Height = 105
        TabOrder = 6
        object Label1: TLabel
          Left = 26
          Top = 17
          Width = 47
          Height = 15
          Alignment = taRightJustify
          Caption = 'Channel'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 68
          Top = 48
          Width = 56
          Height = 15
          Alignment = taRightJustify
          Caption = 'Threshold'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 67
          Top = 72
          Width = 54
          Height = 15
          Alignment = taRightJustify
          Caption = 'Pretrigger'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object cbDetectChannel: TComboBox
          Left = 80
          Top = 17
          Width = 105
          Height = 24
          Hint = 'Event detection channel'
          Style = csDropDownList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = cbDetectChannelChange
        end
        object edDetectionThreshold: TValidatedEdit
          Left = 127
          Top = 48
          Width = 57
          Height = 20
          OnKeyPress = EdDetectionThresholdKeyPress
          AutoSize = False
          Text = ' 0 %'
          Scale = 100.000000000000000000
          Units = '%'
          NumberFormat = '%.3g'
          LoLimit = -1.000000000000000000
          HiLimit = 1.000000000000000000
        end
        object edPreTrigger: TValidatedEdit
          Left = 127
          Top = 72
          Width = 57
          Height = 20
          OnKeyPress = edPreTriggerKeyPress
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
    object panProtocol: TPanel
      Left = 8
      Top = 48
      Width = 196
      Height = 250
      BevelOuter = bvNone
      TabOrder = 2
      object rbSingleProtocol: TRadioButton
        Left = 0
        Top = 0
        Width = 65
        Height = 17
        Hint = 'Select to execute a single stimulus protocol'
        Caption = 'Single'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        TabStop = True
        OnClick = rbSingleProtocolClick
      end
      object rbProtocolList: TRadioButton
        Left = 72
        Top = 0
        Width = 65
        Height = 17
        Hint = 
          'Select to execute a series of stimulus protocols from execution ' +
          'list'
        Caption = 'List'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = rbProtocolListClick
      end
      object panProtocolList: TPanel
        Left = 0
        Top = 20
        Width = 196
        Height = 225
        BevelOuter = bvNone
        TabOrder = 2
        object Label17: TLabel
          Left = 0
          Top = 0
          Width = 68
          Height = 15
          Caption = 'Protocol List'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object cbProtocolList: TComboBox
          Left = 0
          Top = 16
          Width = 192
          Height = 24
          Hint = 'Select voltage pulse program'
          Style = csDropDownList
          Sorted = True
          TabOrder = 0
          OnChange = cbProtocolListChange
        end
        object meProtocolList: TMemo
          Left = 0
          Top = 44
          Width = 193
          Height = 101
          ReadOnly = True
          TabOrder = 1
        end
        object bAddProtocolToList: TButton
          Left = 0
          Top = 152
          Width = 193
          Height = 17
          Hint = 'Add stimulus protocol to protocol execution list'
          Caption = 'Add Protocol to List'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = bAddProtocolToListClick
        end
        object bNewProtocolList: TButton
          Left = 0
          Top = 196
          Width = 65
          Height = 17
          Hint = 'Create new protocol execution list'
          Caption = 'New List'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = bNewProtocolListClick
        end
        object edNewProtocolListName: TEdit
          Left = 72
          Top = 196
          Width = 121
          Height = 22
          Hint = 'New protocol execution list name'
          AutoSize = False
          TabOrder = 4
          Text = 'List Name #1'
        end
        object bDeleteProtocolList: TButton
          Left = 0
          Top = 174
          Width = 193
          Height = 17
          Hint = 'Delete currently selected protocol execution list'
          Caption = 'Delete List'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          OnClick = bDeleteProtocolListClick
        end
      end
      object panSingleProtocol: TPanel
        Left = 0
        Top = 20
        Width = 196
        Height = 81
        BevelOuter = bvNone
        TabOrder = 3
        object Label18: TLabel
          Left = 0
          Top = 0
          Width = 45
          Height = 15
          Caption = 'Protocol'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object cbPulseProgram: TComboBox
          Left = 0
          Top = 16
          Width = 192
          Height = 24
          Hint = 'Select voltage pulse program'
          Style = csDropDownList
          Sorted = True
          TabOrder = 0
          OnChange = cbPulseProgramChange
        end
        object bSetStimFolder: TButton
          Left = 0
          Top = 48
          Width = 193
          Height = 17
          Caption = 'Set Stimulus Protocol Folder'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = bSetStimFolderClick
        end
      end
    end
  end
  object Timer: TTimer
    Interval = 30
    OnTimer = TimerTimer
    Left = 360
    Top = 432
  end
  object OpenDialog: TOpenDialog
    Left = 320
    Top = 432
  end
end
