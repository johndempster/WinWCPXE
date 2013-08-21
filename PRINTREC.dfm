object PrintRecFrm: TPrintRecFrm
  Left = 775
  Top = 253
  BorderStyle = bsDialog
  Caption = 'Print Record'
  ClientHeight = 326
  ClientWidth = 349
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 4
    Top = 42
    Width = 149
    Height = 241
    Caption = ' Calibration Bars '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object CalibrationBarTable: TStringGrid
      Left = 8
      Top = 16
      Width = 129
      Height = 185
      Hint = 'Size of vertical and horizontal calibration bars'
      ColCount = 2
      DefaultColWidth = 45
      DefaultRowHeight = 18
      RowCount = 1
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnKeyPress = CalibrationBarTableKeyPress
    end
    object bDefaultSettings: TButton
      Left = 8
      Top = 208
      Width = 105
      Height = 17
      Caption = 'Set to 10% range '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bDefaultSettingsClick
    end
  end
  object GroupBox5: TGroupBox
    Left = 162
    Top = 114
    Width = 183
    Height = 97
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label5: TLabel
      Left = 48
      Top = 13
      Width = 50
      Height = 14
      Alignment = taRightJustify
      Caption = 'Line Width'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object ckShowZeroLevels: TCheckBox
      Left = 64
      Top = 40
      Width = 113
      Height = 17
      Hint = 'Show signal zero levels as dotted line(s) on plots'
      Alignment = taLeftJustify
      Caption = 'Show zero levels'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 0
    end
    object ckShowLabels: TCheckBox
      Left = 64
      Top = 72
      Width = 113
      Height = 17
      Hint = 'Show channel names and calibration bar values on plot'
      Alignment = taLeftJustify
      Caption = 'Show labels'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 1
    end
    object ckUseColor: TCheckBox
      Left = 64
      Top = 56
      Width = 113
      Height = 17
      Hint = 'Plot signal waveforms in colour'
      Alignment = taLeftJustify
      Caption = 'Use colour'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 2
    end
    object edLineThickness: TValidatedEdit
      Left = 104
      Top = 13
      Width = 73
      Height = 20
      AutoSize = False
      Text = ' 1.00  pts'
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      Units = 'pts'
      NumberFormat = '%.f '
      LoLimit = 1.000000000000000000
      HiLimit = 100.000000000000000000
    end
  end
  object bPrint: TButton
    Left = 4
    Top = 291
    Width = 57
    Height = 20
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
    OnClick = bPrintClick
  end
  object bCancel: TButton
    Left = 64
    Top = 291
    Width = 52
    Height = 17
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 3
  end
  object FontGrp: TGroupBox
    Left = 162
    Top = 42
    Width = 183
    Height = 73
    Caption = ' Typeface '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object Label7: TLabel
      Left = 80
      Top = 45
      Width = 21
      Height = 14
      Alignment = taRightJustify
      Caption = 'Size'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object cbFontName: TComboBox
      Left = 8
      Top = 16
      Width = 169
      Height = 23
      TabOrder = 0
      Text = 'cbFontName'
    end
    object edFontSize: TValidatedEdit
      Left = 107
      Top = 45
      Width = 70
      Height = 20
      AutoSize = False
      Text = ' 1.00  pts'
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      Units = 'pts'
      NumberFormat = '%.f '
      LoLimit = 1.000000000000000000
      HiLimit = 100.000000000000000000
    end
  end
  object Page: TNotebook
    Left = 160
    Top = 216
    Width = 193
    Height = 105
    PageIndex = 1
    TabOrder = 5
    object TPage
      Left = 0
      Top = 0
      Caption = 'Print'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 4
        Top = 2
        Width = 181
        Height = 95
        Caption = ' Page Margins '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 16
          Width = 19
          Height = 14
          Caption = 'Left'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 8
          Top = 52
          Width = 20
          Height = 14
          Caption = 'Top '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 98
          Top = 16
          Width = 27
          Height = 14
          Caption = 'Right '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 98
          Top = 52
          Width = 33
          Height = 14
          Caption = 'Bottom'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object edLeftMargin: TValidatedEdit
          Left = 8
          Top = 30
          Width = 73
          Height = 20
          AutoSize = False
          Text = ' 0.1 cm'
          Value = 1.000000000000000000
          Scale = 0.100000001490116100
          Units = 'cm'
          NumberFormat = '%.1f'
          LoLimit = 1.000000000000000000
          HiLimit = 100.000000000000000000
        end
        object edTopMargin: TValidatedEdit
          Left = 8
          Top = 66
          Width = 73
          Height = 20
          AutoSize = False
          Text = ' 0.1 cm'
          Value = 1.000000000000000000
          Scale = 0.100000001490116100
          Units = 'cm'
          NumberFormat = '%.1f'
          LoLimit = 1.000000000000000000
          HiLimit = 100.000000000000000000
        end
        object edRightMargin: TValidatedEdit
          Left = 98
          Top = 30
          Width = 71
          Height = 20
          AutoSize = False
          Text = ' 0.1 cm'
          Value = 1.000000000000000000
          Scale = 0.100000001490116100
          Units = 'cm'
          NumberFormat = '%.1f'
          LoLimit = 1.000000000000000000
          HiLimit = 100.000000000000000000
        end
        object edBottomMargin: TValidatedEdit
          Left = 98
          Top = 66
          Width = 71
          Height = 20
          AutoSize = False
          Text = ' 0.1 cm'
          Value = 1.000000000000000000
          Scale = 0.100000001490116100
          Units = 'cm'
          NumberFormat = '%.1f'
          LoLimit = 1.000000000000000000
          HiLimit = 100.000000000000000000
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Clipboard'
      object GroupBox4: TGroupBox
        Left = 4
        Top = 2
        Width = 181
        Height = 95
        Caption = ' Image size'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label6: TLabel
          Left = 53
          Top = 16
          Width = 27
          Height = 14
          Alignment = taRightJustify
          Caption = 'Width'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 50
          Top = 40
          Width = 30
          Height = 14
          Alignment = taRightJustify
          Caption = 'Height'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object edWidth: TValidatedEdit
          Left = 82
          Top = 16
          Width = 90
          Height = 20
          AutoSize = False
          Text = ' 500 pixels'
          Value = 500.000000000000000000
          Scale = 1.000000000000000000
          Units = 'pixels'
          NumberFormat = '%.5g'
          LoLimit = 100.000000000000000000
          HiLimit = 1000000.000000000000000000
        end
        object edHeight: TValidatedEdit
          Left = 82
          Top = 40
          Width = 90
          Height = 20
          AutoSize = False
          Text = ' 400 pixels'
          Value = 400.000000000000000000
          Scale = 1.000000000000000000
          Units = 'pixels'
          NumberFormat = '%.5g'
          LoLimit = 100.000000000000000000
          HiLimit = 1000000.000000000000000000
        end
      end
    end
  end
  object PrinterSelectGrp: TGroupBox
    Left = 3
    Top = 0
    Width = 341
    Height = 43
    TabOrder = 6
    object edPrinterName: TEdit
      Left = 8
      Top = 12
      Width = 257
      Height = 21
      ReadOnly = True
      TabOrder = 0
      Text = 'edPrinterName'
    end
    object bPrinterSetup: TButton
      Left = 276
      Top = 12
      Width = 57
      Height = 17
      Caption = 'Setup'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bPrinterSetupClick
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 168
    Top = 112
  end
end
