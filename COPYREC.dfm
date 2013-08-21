object CopyRecDlg: TCopyRecDlg
  Left = 312
  Top = 139
  BorderStyle = bsDialog
  Caption = 'Copy Image'
  ClientHeight = 287
  ClientWidth = 306
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 216
    Width = 177
    Height = 65
    Caption = ' Image Size  '
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
      Width = 31
      Height = 15
      Caption = 'Width'
    end
    object Label2: TLabel
      Left = 96
      Top = 16
      Width = 36
      Height = 15
      Caption = 'Height'
    end
    object edWidth: TEdit
      Left = 8
      Top = 32
      Width = 81
      Height = 23
      TabOrder = 0
      Text = '500 pixels'
      OnKeyPress = edWidthKeyPress
    end
    object edHeight: TEdit
      Left = 96
      Top = 32
      Width = 73
      Height = 23
      TabOrder = 1
      Text = '500 pixels'
      OnKeyPress = edWidthKeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 129
    Height = 209
    Caption = ' Calibration Bars '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object CalibrationBarTable: TStringGrid
      Left = 8
      Top = 16
      Width = 113
      Height = 161
      ColCount = 2
      DefaultColWidth = 45
      DefaultRowHeight = 18
      RowCount = 1
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object bDefaultSettings: TButton
      Left = 8
      Top = 184
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
    end
  end
  object GroupBox3: TGroupBox
    Left = 144
    Top = 96
    Width = 153
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
      Left = 8
      Top = 16
      Width = 84
      Height = 15
      Caption = 'Line Thickness'
    end
    object EdLineThickness: TEdit
      Left = 96
      Top = 16
      Width = 49
      Height = 23
      TabOrder = 0
      Text = ' 1 pts '
      OnKeyPress = EdPointSizeKeyPress
    end
  end
  object GroupBox4: TGroupBox
    Left = 144
    Top = 8
    Width = 153
    Height = 89
    Caption = ' Printer Typeface '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object FontLab: TLabel
      Left = 8
      Top = 16
      Width = 61
      Height = 15
      Caption = 'Font Name'
    end
    object Label6: TLabel
      Left = 24
      Top = 57
      Width = 50
      Height = 15
      Caption = 'Font Size'
    end
    object cbFonts: TComboBox
      Left = 8
      Top = 32
      Width = 137
      Height = 19
      Style = csOwnerDrawFixed
      ItemHeight = 13
      TabOrder = 0
    end
    object EdPointSize: TEdit
      Left = 80
      Top = 56
      Width = 65
      Height = 23
      TabOrder = 1
      Text = 'EdPointSize'
      OnKeyPress = EdPointSizeKeyPress
    end
  end
  object GroupBox5: TGroupBox
    Left = 144
    Top = 144
    Width = 153
    Height = 73
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object ckShowZeroLevels: TCheckBox
      Left = 8
      Top = 32
      Width = 129
      Height = 17
      Alignment = taLeftJustify
      Caption = ' Show zero levels'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object ckShowLabels: TCheckBox
      Left = 8
      Top = 16
      Width = 121
      Height = 17
      Caption = 'Show labels'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object ckUseColors: TCheckBox
      Left = 8
      Top = 48
      Width = 129
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Use colours'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object bOK: TButton
    Left = 192
    Top = 224
    Width = 65
    Height = 17
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 5
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 192
    Top = 248
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
    TabOrder = 6
  end
end
