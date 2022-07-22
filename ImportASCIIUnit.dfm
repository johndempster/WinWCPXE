object ImportASCIIFrm: TImportASCIIFrm
  Left = 234
  Top = 161
  BorderStyle = bsDialog
  Caption = 'ASCII Import'
  ClientHeight = 439
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object bCancel: TButton
    Left = 56
    Top = 411
    Width = 57
    Height = 17
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 0
  end
  object bOK: TButton
    Left = 8
    Top = 411
    Width = 45
    Height = 20
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = bOKClick
  end
  object GroupBox3: TGroupBox
    Left = 224
    Top = 112
    Width = 177
    Height = 281
    Caption = ' Channels '
    TabOrder = 2
    object ChannelTable: TStringGrid
      Left = 8
      Top = 16
      Width = 161
      Height = 257
      Hint = 'Input channel scaling factors and calibration units'
      ColCount = 3
      DefaultColWidth = 50
      DefaultRowHeight = 18
      RowCount = 9
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      ColWidths = (
        50
        50
        50)
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
  object meText: TMemo
    Left = 8
    Top = 0
    Width = 393
    Height = 105
    Lines.Strings = (
      'meText')
    TabOrder = 3
  end
  object GroupBox6: TGroupBox
    Left = 8
    Top = 112
    Width = 209
    Height = 89
    TabOrder = 4
    object Label2: TLabel
      Left = 8
      Top = 16
      Width = 135
      Height = 15
      Caption = 'No. of title lines to ignore'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edNumTitleLines: TValidatedEdit
      Left = 160
      Top = 16
      Width = 41
      Height = 22
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.4g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object GroupBox5: TGroupBox
      Left = 8
      Top = 40
      Width = 193
      Height = 41
      Caption = ' Column Separator '
      TabOrder = 1
      object rbTab: TRadioButton
        Left = 8
        Top = 12
        Width = 49
        Height = 25
        Caption = 'Tab'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = True
      end
      object rbComma: TRadioButton
        Left = 56
        Top = 12
        Width = 65
        Height = 25
        Caption = 'Comma'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object rbSpace: TRadioButton
        Left = 128
        Top = 12
        Width = 57
        Height = 25
        Caption = 'Space'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 207
    Width = 209
    Height = 198
    Caption = ' Time Data '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object Label1: TLabel
      Left = 66
      Top = 160
      Width = 58
      Height = 15
      Alignment = taRightJustify
      Caption = 'Time units'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object cbTimeUnits: TComboBox
      Left = 131
      Top = 160
      Width = 65
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbTimeUnitsChange
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 79
      Width = 193
      Height = 73
      TabOrder = 1
      object edRecordSize: TValidatedEdit
        Left = 112
        Top = 16
        Width = 73
        Height = 20
        AutoSize = False
        Text = ' 512 '
        Value = 512.000000000000000000
        Scale = 1.000000000000000000
        NumberFormat = '%.4g'
        LoLimit = 1.000000000000000000
        HiLimit = 1.000000015047466E29
      end
      object ckFixedRecordSize: TCheckBox
        Left = 8
        Top = 16
        Width = 105
        Height = 17
        Caption = 'Set record size'
        TabOrder = 1
        OnClick = ckFixedRecordSizeClick
      end
      object SamplingIntervalPanel: TPanel
        Left = 4
        Top = 40
        Width = 184
        Height = 25
        BevelOuter = bvNone
        TabOrder = 2
        object Label3: TLabel
          Left = 8
          Top = 0
          Width = 95
          Height = 15
          Alignment = taRightJustify
          Caption = 'Sampling Interval'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object edScanInterval: TValidatedEdit
          Left = 108
          Top = 0
          Width = 73
          Height = 20
          AutoSize = False
          Text = ' 0 '
          Scale = 1.000000000000000000
          NumberFormat = '%.4g'
          LoLimit = -1.000000015047466E29
          HiLimit = 1.000000015047466E29
        end
      end
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 18
      Width = 193
      Height = 56
      TabOrder = 2
      object rbSampleTimesAvailable: TRadioButton
        Left = 8
        Top = 4
        Width = 177
        Height = 25
        Caption = 'Sample times in 1st column'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnClick = rbSampleTimesAvailableClick
      end
      object rbNoSampleTimes: TRadioButton
        Left = 8
        Top = 22
        Width = 121
        Height = 23
        Caption = 'No sample times'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = rbNoSampleTimesClick
      end
    end
  end
end
