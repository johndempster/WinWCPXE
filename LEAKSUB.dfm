object LeakSubFrm: TLeakSubFrm
  Left = 467
  Top = 141
  Caption = 'Leak current subtraction'
  ClientHeight = 370
  ClientWidth = 618
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
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
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object scDisplay: TScopeDisplay
    Left = 139
    Top = 9
    Width = 385
    Height = 233
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
    Top = 2
    Width = 129
    Height = 137
    Caption = ' Record'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 24
      Top = 64
      Width = 25
      Height = 15
      Caption = 'Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 88
      Width = 34
      Height = 15
      Caption = 'Group'
    end
    object cbRecordType: TComboBox
      Left = 56
      Top = 64
      Width = 65
      Height = 23
      Hint = 'Type of record'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = cbRecordTypeChange
    end
    object ckBadRecord: TCheckBox
      Left = 8
      Top = 112
      Width = 81
      Height = 17
      Hint = 'Rejected records are excluded from the leak subtraction'
      Caption = 'Rejected'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = ckBadRecordClick
    end
    object sbRecordNum: TScrollBar
      Left = 8
      Top = 40
      Width = 113
      Height = 17
      Hint = 'Move slider to display records'
      PageSize = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnChange = sbRecordNumChange
    end
    object edGroup: TValidatedEdit
      Left = 56
      Top = 88
      Width = 65
      Height = 23
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edRecordNum: TRangeEdit
      Left = 8
      Top = 16
      Width = 113
      Height = 20
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
    Top = 144
    Width = 129
    Height = 209
    Caption = ' Average '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 64
      Width = 87
      Height = 15
      Caption = 'Voltage channel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 104
      Width = 88
      Height = 15
      Caption = 'Current channel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 16
      Top = 152
      Width = 37
      Height = 15
      Caption = 'Range'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object bDoSubtraction: TButton
      Left = 8
      Top = 16
      Width = 113
      Height = 20
      Hint = 'Start leak subtraction'
      Caption = 'Do Subtraction'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = bDoSubtractionClick
    end
    object bAbort: TButton
      Left = 8
      Top = 40
      Width = 49
      Height = 18
      Hint = 'Abort leak subtraction'
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
    object cbVoltage: TComboBox
      Left = 8
      Top = 80
      Width = 113
      Height = 23
      Hint = 'Input channel containing cell membrane potential signal'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnChange = cbVoltageChange
    end
    object cbCurrent: TComboBox
      Left = 8
      Top = 120
      Width = 113
      Height = 23
      Hint = 'Input channel containing cell membrane current signal'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnChange = cbCurrentChange
    end
    object edRange: TRangeEdit
      Left = 56
      Top = 152
      Width = 65
      Height = 20
      AutoSize = False
      Text = ' 0 - 1.00000001504746624E30 '
      HiValue = 1.000000015047466E30
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.0f - %.0f'
    end
  end
  object ModeGrp: TGroupBox
    Left = 144
    Top = 271
    Width = 137
    Height = 80
    Caption = ' Leak records '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object rbGroupMode: TRadioButton
      Left = 8
      Top = 16
      Width = 89
      Height = 17
      Hint = 'Use when each recording group has its own leak current record(s)'
      Caption = 'From group'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      OnClick = rbGroupModeClick
    end
    object rbFileMode: TRadioButton
      Left = 8
      Top = 32
      Width = 105
      Height = 17
      Hint = 'Use when leak current records are separate from recording group'
      Caption = 'From whole file'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = rbFileModeClick
    end
    object ckSaveLeaks: TCheckBox
      Left = 8
      Top = 50
      Width = 121
      Height = 25
      Caption = 'Save Leak records'
      TabOrder = 2
    end
  end
  object ScalingGrp: TGroupBox
    Left = 288
    Top = 271
    Width = 113
    Height = 80
    Caption = ' Scaling '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object rbAutoScaling: TRadioButton
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Hint = 'Calculate leak current scaling factor from voltage channel'
      Caption = ' From voltage'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      OnClick = rbAutoScalingClick
    end
    object rbFixedScaling: TRadioButton
      Left = 8
      Top = 34
      Width = 57
      Height = 17
      Hint = 'Use a fixed leak current scaling factor'
      Caption = 'Fixed'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = rbFixedScalingClick
    end
    object edIScale: TValidatedEdit
      Left = 58
      Top = 36
      Width = 39
      Height = 20
      AutoSize = False
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
  end
  object SubtractGrp: TGroupBox
    Left = 408
    Top = 271
    Width = 121
    Height = 80
    Caption = ' Subtract '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object rbSubtractWholeLeakCurrent: TRadioButton
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Hint = 'Subtract both ionic and capacity components of leak current'
      Caption = 'I(cap) + I(leak)'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
    end
    object rbSubtractILeakOnly: TRadioButton
      Left = 8
      Top = 34
      Width = 105
      Height = 17
      Hint = 'Subtract ionic component of leak current only'
      Caption = 'I(leak)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object ckFixedZeroLevels: TCheckBox
    Left = 142
    Top = 244
    Width = 102
    Height = 17
    Caption = 'Fix Zero Levels'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = ckFixedZeroLevelsClick
  end
end
