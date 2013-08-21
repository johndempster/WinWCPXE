object PrintTableFrm: TPrintTableFrm
  Left = 330
  Top = 125
  BorderStyle = bsDialog
  Caption = 'Print Table'
  ClientHeight = 152
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FontGrp: TGroupBox
    Left = 4
    Top = 42
    Width = 213
    Height = 73
    Caption = ' Typeface '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label7: TLabel
      Left = 96
      Top = 45
      Width = 47
      Height = 14
      Alignment = taRightJustify
      Caption = 'Point Size'
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
      Width = 193
      Height = 23
      TabOrder = 0
      Text = 'cbFontName'
    end
    object edFontSize: TValidatedEdit
      Left = 152
      Top = 45
      Width = 49
      Height = 23
      Text = ' 1.00  pts'
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      Units = 'pts'
      NumberFormat = '%.f '
      LoLimit = 1.000000000000000000
      HiLimit = 100.000000000000000000
    end
  end
  object PrinterGrp: TGroupBox
    Left = 220
    Top = 42
    Width = 125
    Height = 103
    Caption = ' Page Margins '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 29
      Top = 16
      Width = 19
      Height = 14
      Alignment = taRightJustify
      Caption = 'Left'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 28
      Top = 44
      Width = 20
      Height = 14
      Alignment = taRightJustify
      Caption = 'Top '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 15
      Top = 72
      Width = 33
      Height = 14
      Alignment = taRightJustify
      Caption = 'Bottom'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edLeftMargin: TValidatedEdit
      Left = 52
      Top = 16
      Width = 65
      Height = 23
      Text = ' 0.0 cm'
      Scale = 0.100000001490116100
      Units = 'cm'
      NumberFormat = '%.1f'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edBottomMargin: TValidatedEdit
      Left = 52
      Top = 72
      Width = 65
      Height = 23
      Text = ' 0.0 cm'
      Scale = 0.100000001490116100
      Units = 'cm'
      NumberFormat = '%.1f'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edTopMargin: TValidatedEdit
      Left = 52
      Top = 44
      Width = 65
      Height = 23
      Text = ' 0.0 cm'
      Scale = 0.100000001490116100
      Units = 'cm'
      NumberFormat = '%.1f'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
  end
  object bOK: TButton
    Left = 4
    Top = 120
    Width = 53
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
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 64
    Top = 120
    Width = 57
    Height = 17
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 0
    Width = 341
    Height = 43
    TabOrder = 4
    object edPrinterName: TEdit
      Left = 8
      Top = 12
      Width = 257
      Height = 22
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
