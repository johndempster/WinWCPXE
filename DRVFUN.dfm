object DrvFunFrm: TDrvFunFrm
  Left = 856
  Top = 190
  Caption = 'Driving function analysis'
  ClientHeight = 452
  ClientWidth = 542
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
    Left = 130
    Top = 6
    Width = 383
    Height = 215
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
    Width = 121
    Height = 89
    Caption = ' Record'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object ckBadRecord: TCheckBox
      Left = 8
      Top = 64
      Width = 81
      Height = 17
      Caption = 'Rejected'
      TabOrder = 0
      OnClick = ckBadRecordClick
    end
    object sbRecordNum: TScrollBar
      Left = 8
      Top = 40
      Width = 105
      Height = 17
      PageSize = 0
      TabOrder = 1
      OnChange = sbRecordNumChange
    end
    object edRecordNum: TRangeEdit
      Left = 8
      Top = 16
      Width = 105
      Height = 20
      AutoSize = False
      Text = ' 1 / 1.00000001504746624E30 '
      LoValue = 1.000000000000000000
      HiValue = 1.000000015047466E30
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.0f / %.0f'
    end
  end
  object EqnGrp: TGroupBox
    Left = 130
    Top = 248
    Width = 289
    Height = 177
    Caption = ' Equation '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object EdEquation: TEdit
      Left = 8
      Top = 16
      Width = 273
      Height = 20
      AutoSize = False
      TabOrder = 0
    end
    object ParametersTable: TStringGrid
      Left = 8
      Top = 40
      Width = 273
      Height = 89
      ColCount = 3
      DefaultRowHeight = 16
      ScrollBars = ssVertical
      TabOrder = 1
      RowHeights = (
        16
        16
        16
        16
        16)
    end
    object ckUserSetParameters: TCheckBox
      Left = 8
      Top = 136
      Width = 153
      Height = 17
      Caption = ' Keep parameters fixed'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object ckReconvolution: TCheckBox
      Left = 8
      Top = 152
      Width = 161
      Height = 17
      Caption = 'Reconvolute waveform'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 88
    Width = 121
    Height = 193
    Caption = 'Analysis '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label4: TLabel
      Left = 16
      Top = 60
      Width = 19
      Height = 15
      Caption = 'Ch.'
    end
    object GroupBox8: TGroupBox
      Left = 8
      Top = 88
      Width = 105
      Height = 97
      Caption = ' Range '
      TabOrder = 0
      object rbAllRecords: TRadioButton
        Left = 8
        Top = 16
        Width = 81
        Height = 18
        Caption = 'All records'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object rbThisRecord: TRadioButton
        Left = 8
        Top = 32
        Width = 81
        Height = 17
        Caption = 'This record'
        TabOrder = 1
      end
      object rbRange: TRadioButton
        Left = 8
        Top = 48
        Width = 81
        Height = 17
        Caption = 'Range'
        TabOrder = 2
      end
      object edRecRange: TRangeEdit
        Left = 24
        Top = 64
        Width = 65
        Height = 20
        AutoSize = False
        Text = ' 1.00 - 1.00000001504746624E30 '
        LoValue = 1.000000000000000000
        HiValue = 1.000000015047466E30
        LoLimit = 1.000000000000000000
        HiLimit = 1.000000015047466E30
        Scale = 1.000000000000000000
        NumberFormat = '%.f - %.f'
      end
    end
    object cbChannel: TComboBox
      Left = 40
      Top = 60
      Width = 73
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      OnChange = cbChannelChange
      Items.Strings = (
        '')
    end
    object bDoTransforms: TButton
      Left = 8
      Top = 16
      Width = 105
      Height = 17
      Caption = 'Do Transforms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = bDoTransformsClick
    end
    object bAbort: TButton
      Left = 8
      Top = 36
      Width = 41
      Height = 20
      Caption = 'Abort'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
  end
  object PotGrp: TGroupBox
    Left = 4
    Top = 288
    Width = 121
    Height = 105
    Caption = ' Potentials '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 93
      Height = 15
      Caption = 'Holding potential'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label3: TLabel
      Left = 8
      Top = 56
      Width = 99
      Height = 15
      Caption = 'Reversal potential'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object edVHold: TValidatedEdit
      Left = 8
      Top = 32
      Width = 97
      Height = 20
      AutoSize = False
      Text = ' 0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edVRev: TValidatedEdit
      Left = 8
      Top = 72
      Width = 97
      Height = 20
      AutoSize = False
      Text = ' 0 mV'
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
  end
  object ckFixedZeroLevels: TCheckBox
    Left = 142
    Top = 228
    Width = 102
    Height = 17
    Caption = 'Fix Zero Levels'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = ckFixedZeroLevelsClick
  end
end
