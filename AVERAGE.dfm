object AvgFrm: TAvgFrm
  Left = 299
  Top = 132
  Caption = 'Signal Averager'
  ClientHeight = 302
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object scDisplay: TScopeDisplay
    Left = 144
    Top = 6
    Width = 289
    Height = 265
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
    Top = 0
    Width = 129
    Height = 113
    Caption = ' Record'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 8
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
    object cbRecordType: TComboBox
      Left = 40
      Top = 60
      Width = 81
      Height = 23
      Hint = 'Type of record currently on display'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = cbRecordTypeChange
    end
    object ckBadRecord: TCheckBox
      Left = 8
      Top = 88
      Width = 81
      Height = 17
      Hint = 'Rejected records are excluded from the average'
      Caption = 'Rejected'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = ckBadRecordClick
    end
    object sbRecordNum: TScrollBar
      Left = 8
      Top = 38
      Width = 113
      Height = 17
      PageSize = 0
      TabOrder = 2
      OnChange = sbRecordNumChange
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
  object AverageGrp: TGroupBox
    Left = 4
    Top = 112
    Width = 129
    Height = 193
    Caption = ' Average '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label5: TLabel
      Left = 16
      Top = 60
      Width = 37
      Height = 15
      Caption = 'Range'
    end
    object Label7: TLabel
      Left = 8
      Top = 112
      Width = 25
      Height = 15
      Caption = 'Type'
    end
    object Label6: TLabel
      Left = 14
      Top = 84
      Width = 62
      Height = 15
      Caption = 'In blocks of'
    end
    object Label8: TLabel
      Left = 7
      Top = 138
      Width = 90
      Height = 15
      Caption = 'Alignment mode'
    end
    object bDoAverages: TButton
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Hint = 'Compute averaged record(s)'
      Caption = 'Do Averages'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = bDoAveragesClick
    end
    object cbRecTypeToBeAveraged: TComboBox
      Left = 40
      Top = 112
      Width = 81
      Height = 23
      Hint = 'Type of record(s) to be included in average'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object bAbort: TButton
      Left = 8
      Top = 36
      Width = 49
      Height = 18
      Hint = 'Abort averaging'
      Caption = 'Abort'
      Enabled = False
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
    object cbAlignMode: TComboBox
      Left = 8
      Top = 155
      Width = 113
      Height = 23
      Hint = 
        'Determines whether records are aligned by the mid-points of thei' +
        'r leading edges before averaging'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Items.Strings = (
        'No alignment'
        'On Positive Rise'
        'On Negative Rise')
    end
    object edRange: TRangeEdit
      Left = 56
      Top = 60
      Width = 65
      Height = 20
      AutoSize = False
      Text = ' 0 - 1.00000001504746624E30 '
      HiValue = 1.000000015047466E30
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.0f - %.0f'
    end
    object edBlockSize: TValidatedEdit
      Left = 80
      Top = 84
      Width = 41
      Height = 23
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
  end
  object ckFixedZeroLevels: TCheckBox
    Left = 142
    Top = 276
    Width = 102
    Height = 17
    Caption = 'Fix Zero Levels'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = ckFixedZeroLevelsClick
  end
end
