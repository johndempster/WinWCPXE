object ExportFrm: TExportFrm
  Left = 453
  Top = 181
  BorderStyle = bsDialog
  Caption = ' Export File'
  ClientHeight = 347
  ClientWidth = 247
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox8: TGroupBox
    Left = 8
    Top = 68
    Width = 129
    Height = 159
    Caption = ' Record Range '
    TabOrder = 0
    object rbAllRecords: TRadioButton
      Left = 8
      Top = 16
      Width = 81
      Height = 18
      Hint = 'Analysis all record in the data file'
      Caption = 'Whole file'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      OnClick = rbAllRecordsClick
    end
    object rbRange: TRadioButton
      Left = 8
      Top = 32
      Width = 57
      Height = 17
      Hint = 'Analysis a limited range of records within the data file'
      Caption = 'Range'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = rbRangeClick
    end
    object edRange: TRangeEdit
      Left = 24
      Top = 48
      Width = 97
      Height = 20
      OnKeyPress = edRangeKeyPress
      AutoSize = False
      Text = ' 1 - 1.00000001504746624E30  '
      LoValue = 1.000000000000000000
      HiValue = 1.000000015047466E30
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
      Scale = 1.000000000000000000
      NumberFormat = '%.0f - %.0f '
    end
  end
  object ChannelsGrp: TGroupBox
    Left = 8
    Top = 227
    Width = 233
    Height = 89
    Caption = ' Channels '
    TabOrder = 1
    object ckCh0: TCheckBox
      Left = 8
      Top = 16
      Width = 81
      Height = 17
      Caption = 'ckCh0'
      TabOrder = 0
    end
    object ckCh1: TCheckBox
      Left = 8
      Top = 32
      Width = 81
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 1
    end
    object ckCh2: TCheckBox
      Left = 8
      Top = 48
      Width = 81
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 2
    end
    object ckCh3: TCheckBox
      Left = 8
      Top = 64
      Width = 81
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 3
    end
    object ckCh4: TCheckBox
      Left = 112
      Top = 16
      Width = 89
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 4
    end
    object ckCh5: TCheckBox
      Left = 112
      Top = 32
      Width = 81
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 5
    end
    object ckCh6: TCheckBox
      Left = 112
      Top = 48
      Width = 81
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 6
    end
    object ckCh7: TCheckBox
      Left = 112
      Top = 64
      Width = 81
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 7
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 0
    Width = 233
    Height = 65
    Caption = ' Output file '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object edFileName: TEdit
      Left = 8
      Top = 16
      Width = 217
      Height = 21
      AutoSize = False
      Color = clMenuBar
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = 'edFileName'
    end
    object bChangeName: TButton
      Left = 8
      Top = 40
      Width = 121
      Height = 17
      Caption = 'Change File  Name'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bChangeNameClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 143
    Top = 68
    Width = 97
    Height = 159
    Caption = ' Output  Format  '
    TabOrder = 3
    object rbABF: TRadioButton
      Left = 8
      Top = 16
      Width = 57
      Height = 17
      Caption = 'Axon'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = rbABFClick
    end
    object rbCFS: TRadioButton
      Left = 8
      Top = 30
      Width = 57
      Height = 19
      Caption = 'CED'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = rbCFSClick
    end
    object rbASCII: TRadioButton
      Left = 8
      Top = 46
      Width = 57
      Height = 17
      Caption = 'Text'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = rbASCIIClick
    end
    object rbEDR: TRadioButton
      Left = 8
      Top = 62
      Width = 57
      Height = 17
      Caption = 'EDR'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = rbEDRClick
    end
    object rbWCP: TRadioButton
      Left = 8
      Top = 78
      Width = 57
      Height = 17
      Caption = 'WCP'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = rbWCPClick
    end
    object rbIGOR: TRadioButton
      Left = 8
      Top = 94
      Width = 57
      Height = 17
      Caption = 'IGOR'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = rbIGORClick
    end
    object rbMAT: TRadioButton
      Left = 8
      Top = 110
      Width = 57
      Height = 17
      Caption = 'MAT'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = rbMATClick
    end
    object ckCombineRecords: TCheckBox
      Left = 24
      Top = 128
      Width = 65
      Height = 25
      Caption = 'Combine Records'
      TabOrder = 7
      WordWrap = True
    end
  end
  object bOK: TButton
    Left = 8
    Top = 322
    Width = 50
    Height = 20
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 4
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 64
    Top = 322
    Width = 50
    Height = 17
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 5
  end
  object SaveDialog: TSaveDialog
    Left = 152
    Top = 328
  end
  object ExportFile: TADCDataFile
    NumChannelsPerScan = 1
    NumBytesPerSample = 2
    NumScansPerRecord = 512
    FloatingPointSamples = False
    MaxADCValue = 2047
    MinADCValue = -2048
    RecordNum = 0
    NumFileHeaderBytes = 0
    WCPNumZeroAvg = 0
    WCPRecordAccepted = False
    ABFAcquisitionMode = ftGapFree
    EDREventDetectorChannel = 0
    EDREventDetectorRecordSize = 0
    EDRVarianceRecordSize = 0
    EDRVarianceRecordOverlap = 0
    EDRBackedUp = False
    ASCIISeparator = #9
    ASCIITimeDataInCol0 = False
    ASCIITimeUnits = 's'
    ASCIITitleLines = 2
    ASCIIFixedRecordSize = False
    Left = 120
    Top = 328
  end
end
