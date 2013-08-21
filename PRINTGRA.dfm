object PrintGraphFrm: TPrintGraphFrm
  Left = 347
  Top = 282
  BorderStyle = bsDialog
  Caption = 'Print Graph'
  ClientHeight = 209
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object PrinterSelectGrp: TGroupBox
    Left = 3
    Top = 0
    Width = 326
    Height = 43
    TabOrder = 0
    object edPrinterName: TEdit
      Left = 8
      Top = 12
      Width = 249
      Height = 24
      ReadOnly = True
      TabOrder = 0
      Text = 'edPrinterName'
    end
    object bPrinterSetup: TButton
      Left = 260
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
  object SettingsPan: TPanel
    Left = 0
    Top = 48
    Width = 345
    Height = 153
    BevelOuter = bvNone
    TabOrder = 1
    object FontGrp: TGroupBox
      Left = 4
      Top = 0
      Width = 205
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
        Left = 88
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
        Width = 185
        Height = 23
        TabOrder = 0
        Text = 'cbFontName'
      end
      object edFontSize: TValidatedEdit
        Left = 144
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
    object Page: TNotebook
      Left = 208
      Top = 0
      Width = 129
      Height = 129
      TabOrder = 1
      object TPage
        Left = 0
        Top = 0
        Caption = 'Printer'
        object PrinterGrp: TGroupBox
          Left = 4
          Top = 0
          Width = 117
          Height = 121
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
            Top = 64
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
            Left = 8
            Top = 40
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
            Left = 8
            Top = 88
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
            Left = 44
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
          object edRightMargin: TValidatedEdit
            Left = 44
            Top = 40
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
            Left = 44
            Top = 64
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
            Left = 44
            Top = 88
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
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Metafile'
        object MetafileGrp: TGroupBox
          Left = 4
          Top = 0
          Width = 121
          Height = 121
          Caption = ' Image Size '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object Label6: TLabel
            Left = 8
            Top = 16
            Width = 30
            Height = 14
            Caption = ' Width'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label9: TLabel
            Left = 8
            Top = 56
            Width = 30
            Height = 14
            Caption = 'Height'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object edBitmapWidth: TValidatedEdit
            Left = 8
            Top = 32
            Width = 81
            Height = 23
            Text = ' 500 pixels'
            Value = 500.000000000000000000
            Scale = 1.000000000000000000
            Units = 'pixels'
            NumberFormat = '%.0f'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
          object edBitmapHeight: TValidatedEdit
            Left = 8
            Top = 72
            Width = 81
            Height = 23
            Text = ' 1000 pixels'
            Value = 1000.000000000000000000
            Scale = 1.000000000000000000
            Units = 'pixels'
            NumberFormat = '%.0f'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
        end
      end
    end
    object GroupBox3: TGroupBox
      Left = 4
      Top = 72
      Width = 205
      Height = 49
      Caption = ' Lines '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object Label5: TLabel
        Left = 64
        Top = 13
        Width = 72
        Height = 14
        Alignment = taRightJustify
        Caption = 'Line Thickness'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edLineThickness: TValidatedEdit
        Left = 144
        Top = 13
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
    object bOK: TButton
      Left = 4
      Top = 128
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
      TabOrder = 3
      OnClick = bOKClick
    end
    object bCancel: TButton
      Left = 64
      Top = 128
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
      TabOrder = 4
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 144
    Top = 176
  end
end
