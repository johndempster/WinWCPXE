object ReplayFrm: TReplayFrm
  Left = 604
  Top = 367
  Caption = '0ol;;-;;;l0oo'
  ClientHeight = 557
  ClientWidth = 761
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
  object Label3: TLabel
    Left = 152
    Top = 8
    Width = 30
    Height = 15
    Caption = 'Ident:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object scDisplay: TScopeDisplay
    Left = 152
    Top = 34
    Width = 545
    Height = 121
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
  object CursorGrp: TGroupBox
    Left = 4
    Top = 299
    Width = 142
    Height = 145
    Caption = ' Cursor '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object bSaveCursor: TButton
      Left = 8
      Top = 60
      Width = 128
      Height = 17
      Hint = 
        'Save cursor reading to log file. (Select  File/Inspect Log File ' +
        'to view saved results.)'
      Caption = 'Save (F1)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = bSaveCursorClick
    end
    object bFindCursor: TButton
      Left = 8
      Top = 16
      Width = 128
      Height = 17
      Caption = 'Get Cursor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bFindCursorClick
    end
    object ZeroGrp: TGroupBox
      Left = 7
      Top = 80
      Width = 128
      Height = 57
      Caption = ' Zero Level '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object rbBaseline: TRadioButton
        Left = 8
        Top = 16
        Width = 73
        Height = 17
        Caption = 'Baseline'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnClick = rbBaselineClick
      end
      object rbUseC0CursorasZero: TRadioButton
        Left = 8
        Top = 32
        Width = 81
        Height = 17
        Caption = 'c0 cursor'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = rbUseC0CursorasZeroClick
      end
    end
    object Button1: TButton
      Left = 8
      Top = 38
      Width = 128
      Height = 17
      Caption = 'Get c0 Cursor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object RecordGrp: TGroupBox
    Left = 4
    Top = 0
    Width = 142
    Height = 209
    Caption = ' Record '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label2: TLabel
      Left = 35
      Top = 129
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
      Left = 8
      Top = 61
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
    object Group: TLabel
      Left = 16
      Top = 158
      Width = 44
      Height = 15
      Alignment = taRightJustify
      Caption = 'Group #'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 23
      Top = 104
      Width = 37
      Height = 15
      Alignment = taRightJustify
      Caption = 'Marker'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object cbRecordType: TComboBox
      Left = 64
      Top = 129
      Width = 74
      Height = 23
      Hint = 'Record type currently on display'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = cbRecordTypeChange
    end
    object ckBadRecord: TCheckBox
      Left = 64
      Top = 186
      Width = 74
      Height = 17
      Hint = 'Rejected records are excluded from analysis'
      Alignment = taLeftJustify
      Caption = 'Rejected'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = ckBadRecordClick
    end
    object sbRecordNum: TScrollBar
      Left = 8
      Top = 38
      Width = 128
      Height = 17
      Hint = 'Move slider to display records'
      PageSize = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnChange = sbRecordNumChange
    end
    object edRecordNum: TRangeEdit
      Left = 8
      Top = 16
      Width = 128
      Height = 20
      OnKeyPress = edRecordNumKeyPress
      AutoSize = False
      Text = ' 0 / 1.00000001504746622E30 '
      HiValue = 1.000000015047466E30
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.0f / %.0f'
    end
    object EdRecordIdent: TEdit
      Left = 64
      Top = 104
      Width = 74
      Height = 20
      Hint = 'Record information box'
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Text = ' '
      OnChange = EdRecordIdentChange
      OnKeyPress = EdRecordIdentKeyPress
    end
    object edGroup: TValidatedEdit
      Left = 64
      Top = 160
      Width = 74
      Height = 20
      AutoSize = False
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.4g'
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
    end
    object metime: TMemo
      Left = 40
      Top = 61
      Width = 97
      Height = 37
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '0'
        '1')
      ParentFont = False
      TabOrder = 6
    end
  end
  object FilterGrp: TGroupBox
    Left = 4
    Top = 212
    Width = 142
    Height = 81
    Caption = ' Low pass filter '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object lbLPFilter: TLabel
      Left = 8
      Top = 35
      Width = 96
      Height = 15
      Caption = 'Cut-off Frequency'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edLPFilter: TValidatedEdit
      Left = 8
      Top = 53
      Width = 97
      Height = 20
      OnKeyPress = edLPFilterKeyPress
      AutoSize = False
      Text = ' 0 Hz'
      Scale = 1.000000000000000000
      Units = 'Hz'
      NumberFormat = '%.6g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object ckLPFilterInUse: TCheckBox
      Left = 8
      Top = 16
      Width = 57
      Height = 17
      Caption = 'Active'
      TabOrder = 1
      OnClick = ckLPFilterInUseClick
    end
  end
  object edIdent: TEdit
    Left = 188
    Top = 8
    Width = 327
    Height = 20
    Hint = 'Experiment indentification line'
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Text = 'edIdent'
    OnKeyPress = edIdentKeyPress
  end
  object ckFixedZeroLevels: TCheckBox
    Left = 152
    Top = 161
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
