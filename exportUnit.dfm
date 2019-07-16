object ExportFrm: TExportFrm
  Left = 453
  Top = 181
  BorderStyle = bsDialog
  Caption = ' Export File'
  ClientHeight = 390
  ClientWidth = 425
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
    Top = 108
    Width = 158
    Height = 85
    Caption = ' Record Range '
    TabOrder = 0
    object rbAllRecords: TRadioButton
      Left = 8
      Top = 16
      Width = 81
      Height = 18
      Hint = 'Export all record in the data file'
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
    end
    object rbRange: TRadioButton
      Left = 8
      Top = 32
      Width = 57
      Height = 17
      Hint = 'Export a limited range of records within the data file'
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
    end
    object edRange: TRangeEdit
      Left = 26
      Top = 50
      Width = 119
      Height = 20
      AutoSize = False
      Text = ' 1 - 1.00000001504746622E30  '
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
    Top = 199
    Width = 409
    Height = 153
    Hint = 'Select channels to be exported'
    Caption = ' Channels '
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object ckCh0: TCheckBox
      Left = 8
      Top = 16
      Width = 70
      Height = 17
      Caption = 'ckCh0'
      TabOrder = 0
    end
    object ckCh1: TCheckBox
      Left = 8
      Top = 32
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 1
    end
    object ckCh2: TCheckBox
      Left = 8
      Top = 48
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 2
    end
    object ckCh3: TCheckBox
      Left = 8
      Top = 64
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 3
    end
    object ckCh4: TCheckBox
      Left = 8
      Top = 81
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 4
    end
    object ckCh5: TCheckBox
      Left = 8
      Top = 97
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 5
    end
    object ckCh6: TCheckBox
      Left = 8
      Top = 112
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 6
    end
    object ckCh7: TCheckBox
      Left = 8
      Top = 128
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 7
    end
    object ckCh8: TCheckBox
      Left = 88
      Top = 16
      Width = 70
      Height = 17
      Caption = 'ckCh0'
      TabOrder = 8
    end
    object ckCh9: TCheckBox
      Left = 88
      Top = 32
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 9
    end
    object ckCh10: TCheckBox
      Left = 88
      Top = 48
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 10
    end
    object ckCh11: TCheckBox
      Left = 88
      Top = 64
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 11
    end
    object ckCh12: TCheckBox
      Left = 88
      Top = 81
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 12
    end
    object ckCh13: TCheckBox
      Left = 88
      Top = 97
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 13
    end
    object ckCh14: TCheckBox
      Left = 88
      Top = 112
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 14
    end
    object ckCh15: TCheckBox
      Left = 88
      Top = 128
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 15
    end
    object ckCh16: TCheckBox
      Left = 168
      Top = 16
      Width = 70
      Height = 17
      Caption = 'ckCh0'
      TabOrder = 16
    end
    object ckCh17: TCheckBox
      Left = 168
      Top = 32
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 17
    end
    object ckCh18: TCheckBox
      Left = 168
      Top = 48
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 18
    end
    object ckCh19: TCheckBox
      Left = 168
      Top = 64
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 19
    end
    object ckCh20: TCheckBox
      Left = 168
      Top = 81
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 20
    end
    object ckCh21: TCheckBox
      Left = 168
      Top = 97
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 21
    end
    object ckCh22: TCheckBox
      Left = 168
      Top = 112
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 22
    end
    object ckCh23: TCheckBox
      Left = 168
      Top = 128
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 23
    end
    object ckCh24: TCheckBox
      Left = 248
      Top = 16
      Width = 70
      Height = 17
      Caption = 'ckCh0'
      TabOrder = 24
    end
    object ckCh25: TCheckBox
      Left = 248
      Top = 32
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 25
    end
    object ckCh26: TCheckBox
      Left = 248
      Top = 48
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 26
    end
    object ckCh27: TCheckBox
      Left = 248
      Top = 64
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 27
    end
    object ckCh28: TCheckBox
      Left = 248
      Top = 81
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 28
    end
    object ckCh29: TCheckBox
      Left = 248
      Top = 97
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 29
    end
    object ckCh30: TCheckBox
      Left = 248
      Top = 112
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 30
    end
    object ckCh31: TCheckBox
      Left = 248
      Top = 128
      Width = 70
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 31
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 0
    Width = 409
    Height = 106
    Caption = ' Files '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object bChangeName: TButton
      Left = 8
      Top = 82
      Width = 121
      Height = 17
      Caption = 'Select Files'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = bChangeNameClick
    end
    object meFileList: TMemo
      Left = 8
      Top = 17
      Width = 312
      Height = 59
      Lines.Strings = (
        'meFileList')
      TabOrder = 1
      WordWrap = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 172
    Top = 108
    Width = 245
    Height = 85
    Caption = ' Output  Format  '
    TabOrder = 3
    object ckCombineRecords: TCheckBox
      Left = 8
      Top = 38
      Width = 146
      Height = 25
      Caption = 'Combine Records'
      TabOrder = 0
      WordWrap = True
    end
    object cbExportFormat: TComboBox
      Left = 8
      Top = 16
      Width = 153
      Height = 22
      Hint = 'Select export file data format'
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnChange = cbExportFormatChange
    end
    object ckASCIIRecordsInColumns: TCheckBox
      Left = 8
      Top = 57
      Width = 161
      Height = 25
      Caption = 'Save Records as Columns'
      TabOrder = 2
      WordWrap = True
    end
  end
  object bOK: TButton
    Left = 8
    Top = 358
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
    Top = 358
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
    Left = 128
    Top = 356
  end
  object OpenDialog: TOpenDialog
    Left = 208
    Top = 352
  end
end
