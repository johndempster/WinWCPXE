object AvgFrm: TAvgFrm
  Left = 299
  Top = 132
  Caption = 'Signal Averager'
  ClientHeight = 378
  ClientWidth = 520
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
    Left = 163
    Top = 8
    Width = 289
    Height = 339
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
    Width = 153
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
      Left = 64
      Top = 64
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
      Width = 137
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
      Width = 137
      Height = 17
      PageSize = 0
      TabOrder = 2
      OnChange = sbRecordNumChange
    end
    object edRecordNum: TRangeEdit
      Left = 8
      Top = 16
      Width = 137
      Height = 20
      AutoSize = False
      Text = ' 0 / 1.00000001504746622E30 '
      HiValue = 1.000000015047466E30
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.0f / %.0f'
    end
  end
  object AverageGrp: TGroupBox
    Left = 4
    Top = 112
    Width = 153
    Height = 257
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
      Top = 181
      Width = 25
      Height = 15
      Caption = 'Type'
    end
    object Label8: TLabel
      Left = 8
      Top = 206
      Width = 90
      Height = 15
      Caption = 'Alignment mode'
    end
    object bDoAverages: TButton
      Left = 8
      Top = 16
      Width = 137
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
      Left = 48
      Top = 177
      Width = 98
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
      Top = 224
      Width = 137
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
      Width = 89
      Height = 20
      AutoSize = False
      Text = ' 0 - 1.00000001504746622E30 '
      HiValue = 1.000000015047466E30
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.0f - %.0f'
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 86
      Width = 137
      Height = 89
      Caption = 'Record Grouping '
      TabOrder = 5
      object Label6: TLabel
        Left = 8
        Top = 18
        Width = 65
        Height = 15
        Caption = 'In groups of'
      end
      object edBlockSize: TValidatedEdit
        Left = 88
        Top = 18
        Width = 41
        Height = 23
        Hint = 'No. of records to be averaged (n)'
        ShowHint = True
        Text = ' 1 '
        Value = 1.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%g'
        LoLimit = 1.000000000000000000
        HiLimit = 1.000000015047466E30
      end
      object rbSequentialRecords: TRadioButton
        Left = 8
        Top = 40
        Width = 121
        Height = 17
        Hint = 'Average groups of n sequential records (i,i+1,..i+n-1) '
        ParentCustomHint = False
        Caption = 'Sequential'
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
      end
      object rbInterleavedRecords: TRadioButton
        Left = 8
        Top = 58
        Width = 121
        Height = 17
        Hint = 'Average groups of interleaved records (i,i+n,i+2n..)'
        Caption = 'Interleaved'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
    end
  end
  object ckFixedZeroLevels: TCheckBox
    Left = 163
    Top = 353
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
