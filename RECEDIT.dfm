object EditFrm: TEditFrm
  Left = 337
  Top = 138
  Caption = ' Edit Record'
  ClientHeight = 447
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDesigned
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
    Left = 168
    Top = 6
    Width = 305
    Height = 155
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
    FloatingPointSamples = False
    FixZeroLevels = False
    DisplaySelected = False
    FontSize = 8
  end
  object RecordGrp: TGroupBox
    Left = 4
    Top = 0
    Width = 153
    Height = 249
    Caption = ' Record '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 32
      Top = 96
      Width = 25
      Height = 15
      Alignment = taRightJustify
      Caption = 'Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 37
      Top = 124
      Width = 28
      Height = 15
      Alignment = taRightJustify
      Caption = 'Time'
    end
    object Group: TLabel
      Left = 31
      Top = 148
      Width = 34
      Height = 15
      Alignment = taRightJustify
      Caption = 'Group'
    end
    object Label3: TLabel
      Left = 22
      Top = 198
      Width = 59
      Height = 15
      Alignment = taRightJustify
      Caption = 'A/D Range'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label7: TLabel
      Left = 10
      Top = 172
      Width = 55
      Height = 15
      Alignment = taRightJustify
      Caption = 'Samp. Int.'
      WordWrap = True
    end
    object Label4: TLabel
      Left = 22
      Top = 64
      Width = 19
      Height = 15
      Alignment = taRightJustify
      Caption = 'Ch.'
    end
    object cbRecordType: TComboBox
      Left = 64
      Top = 96
      Width = 81
      Height = 23
      Hint = 'Record type'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = cbRecordTypeChange
    end
    object ckBadRecord: TCheckBox
      Left = 8
      Top = 224
      Width = 81
      Height = 17
      Hint = 'Rejected records are excluded from analysis'
      Caption = 'Rejected'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = ckBadRecordClick
    end
    object sbRecordNum: TScrollBar
      Left = 8
      Top = 40
      Width = 137
      Height = 17
      PageSize = 0
      TabOrder = 2
      OnChange = sbRecordNumChange
    end
    object edADCVoltageRange: TValidatedEdit
      Left = 88
      Top = 198
      Width = 57
      Height = 20
      OnKeyPress = edADCVoltageRangeKeyPress
      AutoSize = False
      Text = ' 0 V'
      Scale = 1.000000000000000000
      Units = 'V'
      NumberFormat = '%.5g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edGroup: TValidatedEdit
      Left = 72
      Top = 148
      Width = 73
      Height = 20
      OnKeyPress = edGroupKeyPress
      AutoSize = False
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edTime: TValidatedEdit
      Left = 72
      Top = 124
      Width = 73
      Height = 20
      AutoSize = False
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edRecordNum: TRangeEdit
      Left = 8
      Top = 16
      Width = 137
      Height = 23
      OnKeyPress = edRecordNumKeyPress
      Text = ' 1 / 1.00000001504746622E30 '
      LoValue = 1.000000000000000000
      HiValue = 1.000000015047466E30
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.0f / %.0f'
    end
    object edSamplingInterval: TValidatedEdit
      Left = 72
      Top = 172
      Width = 73
      Height = 20
      OnKeyPress = edGroupKeyPress
      AutoSize = False
      Text = ' 0 ms'
      Scale = 1000.000000000000000000
      Units = 'ms'
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object cbChannel: TComboBox
      Left = 48
      Top = 64
      Width = 97
      Height = 23
      Hint = 'Channel to be edited'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnChange = cbChannelChange
    end
  end
  object EditGrp: TGroupBox
    Left = 4
    Top = 252
    Width = 489
    Height = 149
    Caption = ' Edit Options '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object HorGrp: TGroupBox
      Left = 152
      Top = 16
      Width = 169
      Height = 41
      Caption = ' X Shift '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object bLeft: TButton
        Left = 8
        Top = 16
        Width = 25
        Height = 20
        Hint = 'Shift signal to the left'
        Caption = #239
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Wingdings'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = bLeftClick
      end
      object Button1: TButton
        Left = 134
        Top = 16
        Width = 25
        Height = 20
        Hint = 'Shift signal to the right'
        Caption = #240
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Wingdings'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = Button1Click
      end
      object edXShift: TValidatedEdit
        Left = 40
        Top = 13
        Width = 89
        Height = 20
        AutoSize = False
        Text = ' 0 '
        Scale = 1.000000000000000000
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object VertGrp: TGroupBox
      Left = 152
      Top = 56
      Width = 169
      Height = 41
      Caption = ' Y Shift '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object bUp: TButton
        Left = 8
        Top = 16
        Width = 25
        Height = 20
        Hint = 'Shift signal level up'
        Caption = #241
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Wingdings'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = bUpClick
      end
      object bDown: TButton
        Left = 134
        Top = 16
        Width = 25
        Height = 20
        Hint = 'Shift signal level down'
        Caption = #242
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Wingdings'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = bDownClick
      end
      object edYShift: TValidatedEdit
        Left = 40
        Top = 13
        Width = 89
        Height = 20
        AutoSize = False
        Text = ' 0 '
        Scale = 1.000000000000000000
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object YScaleGrp: TGroupBox
      Left = 152
      Top = 96
      Width = 169
      Height = 41
      Caption = ' Y Scale '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object bScale: TButton
        Left = 6
        Top = 16
        Width = 59
        Height = 20
        Hint = 'Scale signal '
        Caption = 'Scale by'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = bScaleClick
      end
      object edYScale: TValidatedEdit
        Left = 72
        Top = 16
        Width = 57
        Height = 20
        AutoSize = False
        Text = ' 0 '
        Scale = 1.000000000000000000
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object GroupBox8: TGroupBox
      Left = 8
      Top = 16
      Width = 137
      Height = 89
      TabOrder = 3
      object rbAllRecords: TRadioButton
        Left = 8
        Top = 8
        Width = 81
        Height = 18
        Hint = 'Analysis all record in the data file'
        Caption = 'All records'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object rbThisRecord: TRadioButton
        Left = 8
        Top = 24
        Width = 81
        Height = 17
        Hint = 'Analyse the currently displayed record only'
        Caption = 'This record'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
      end
      object rbRange: TRadioButton
        Left = 8
        Top = 40
        Width = 81
        Height = 17
        Hint = 'Analysis a limited range of records within the data file'
        Caption = 'Range'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object edRecRange: TRangeEdit
        Left = 24
        Top = 56
        Width = 105
        Height = 20
        AutoSize = False
        Text = ' 0.00 - 1.00000001504746622E30 '
        HiValue = 1.000000015047466E30
        HiLimit = 1.000000015047466E30
        Scale = 1.000000000000000000
        NumberFormat = '%.f - %.f'
      end
    end
    object GroupBox1: TGroupBox
      Left = 328
      Top = 16
      Width = 129
      Height = 121
      Caption = ' Artefact Removal  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      object Label6: TLabel
        Left = 8
        Top = 16
        Width = 91
        Height = 15
        Caption = 'Selected Region'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 8
        Top = 60
        Width = 31
        Height = 30
        Caption = 'Blank Value'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object edSetValue: TValidatedEdit
        Left = 48
        Top = 61
        Width = 73
        Height = 20
        Hint = 'Blanking level'
        AutoSize = False
        Text = ' 0 '
        Scale = 1.000000000000000000
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
      object edRegion: TRangeEdit
        Left = 8
        Top = 32
        Width = 113
        Height = 20
        Hint = 'Region of record to be set to Blank Value'
        OnKeyPress = edRegionKeyPress
        AutoSize = False
        ShowHint = True
        Text = ' 1 - 1 '
        LoValue = 1.000000000000000000
        HiValue = 1.000000000000000000
        HiLimit = 1.000000015047466E30
        Scale = 1.000000000000000000
        NumberFormat = '%.3g - %.3g'
      end
      object bSetRegion: TButton
        Left = 8
        Top = 96
        Width = 113
        Height = 17
        Hint = 'Replace selected segment of record with Blank Value level.'
        Caption = 'Remove Artefact'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = bSetRegionClick
      end
    end
    object bUndo: TButton
      Left = 8
      Top = 112
      Width = 137
      Height = 17
      Hint = 'Restore original file from backup, un-doing all edits.'
      Caption = 'Undo All Edits'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = bUndoClick
    end
  end
  object ckFixedZeroLevels: TCheckBox
    Left = 166
    Top = 164
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
