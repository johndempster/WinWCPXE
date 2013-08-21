object ImportRawFrm: TImportRawFrm
  Left = 251
  Top = 182
  Caption = 'Raw Binary Import'
  ClientHeight = 293
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object GroupBox2: TGroupBox
    Left = 8
    Top = 7
    Width = 225
    Height = 250
    Caption = ' File Description '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label7: TLabel
      Left = 8
      Top = 16
      Width = 127
      Height = 15
      Caption = 'File header size (bytes)'
    end
    object Label9: TLabel
      Left = 71
      Top = 40
      Width = 106
      Height = 15
      Alignment = taRightJustify
      Caption = 'No. Input Channels'
    end
    object Label2: TLabel
      Left = 32
      Top = 64
      Width = 129
      Height = 15
      Alignment = taRightJustify
      Caption = 'No. Samples/Channels'
    end
    object edNumFileHeaderBytes: TValidatedEdit
      Left = 144
      Top = 16
      Width = 73
      Height = 20
      Hint = 'No. of bytes in file header (to be skipped )'
      AutoSize = False
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edNumChannelsPerScan: TValidatedEdit
      Left = 184
      Top = 40
      Width = 33
      Height = 20
      Hint = 'No. of signal channels '
      OnKeyPress = edNumChannelsPerScanKeyPress
      AutoSize = False
      ShowHint = True
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 16.000000000000000000
    end
    object GroupBox4: TGroupBox
      Left = 32
      Top = 176
      Width = 185
      Height = 65
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object lbSamplingInterval: TLabel
        Left = 8
        Top = 10
        Width = 95
        Height = 15
        Caption = 'Sampling interval'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object rbmsecs: TRadioButton
        Left = 8
        Top = 40
        Width = 57
        Height = 17
        Caption = 'msecs'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = rbmsecsClick
      end
      object rbSecs: TRadioButton
        Left = 72
        Top = 40
        Width = 57
        Height = 17
        Caption = 'secs'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = rbmsecsClick
      end
      object rbMins: TRadioButton
        Left = 120
        Top = 40
        Width = 57
        Height = 17
        Caption = 'mins'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = rbmsecsClick
      end
      object edScanInterval: TValidatedEdit
        Left = 112
        Top = 13
        Width = 65
        Height = 20
        Hint = 'Time interval between multi-channel sample scans '
        AutoSize = False
        ShowHint = True
        Text = ' 0 '
        Scale = 1.000000000000000000
        NumberFormat = '%.4g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object edNumScansPerRecord: TValidatedEdit
      Left = 168
      Top = 64
      Width = 49
      Height = 23
      Hint = 'No. of samples / channel / record '
      ShowHint = True
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E29
    end
  end
  object bOK: TButton
    Left = 8
    Top = 264
    Width = 57
    Height = 25
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 72
    Top = 264
    Width = 57
    Height = 17
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 240
    Top = 7
    Width = 217
    Height = 249
    Caption = ' Channels '
    TabOrder = 3
    object ChannelTable: TStringGrid
      Left = 8
      Top = 16
      Width = 201
      Height = 177
      Hint = 'Input channel scaling factors and calibration units'
      ColCount = 4
      DefaultColWidth = 50
      DefaultRowHeight = 18
      RowCount = 9
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 0
      RowHeights = (
        18
        18
        18
        18
        18
        18
        18
        18
        18)
    end
  end
  object GroupBox3: TGroupBox
    Left = 64
    Top = 90
    Width = 161
    Height = 91
    Caption = ' Sample Format'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object lbMaxADCValue: TLabel
      Left = 24
      Top = 61
      Width = 53
      Height = 14
      Caption = 'Max. Value'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 16
      Top = 38
      Width = 96
      Height = 14
      Caption = 'No. of bytes/sample'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object rbFloat: TRadioButton
      Left = 8
      Top = 16
      Width = 49
      Height = 17
      Caption = 'Float'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = rbFloatClick
    end
    object rbInteger: TRadioButton
      Left = 64
      Top = 16
      Width = 65
      Height = 17
      Caption = 'Integer'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = rbFloatClick
    end
    object edMaxADCValue: TValidatedEdit
      Left = 88
      Top = 61
      Width = 65
      Height = 20
      Hint = 'Upper limit of sample values '
      OnKeyPress = edMaxADCValueKeyPress
      AutoSize = False
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
    end
    object edNumBytesPerSample: TValidatedEdit
      Left = 120
      Top = 38
      Width = 33
      Height = 20
      Hint = 'Size (bytes) of sample data  points in file'
      OnKeyPress = edNumBytesPerSampleKeyPress
      AutoSize = False
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 16.000000000000000000
    end
  end
end
