object CED1902Frm: TCED1902Frm
  Left = 360
  Top = 165
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'CED 1902 Amplifier'
  ClientHeight = 231
  ClientWidth = 270
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Label11: TLabel
    Left = 176
    Top = 144
    Width = 56
    Height = 15
    Caption = 'Com. Port'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 152
    Top = 200
    Width = 27
    Height = 28
    Alignment = taRightJustify
    Caption = 'Com. Port'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object CED1902Group: TGroupBox
    Left = 152
    Top = 56
    Width = 113
    Height = 137
    Caption = ' Filters '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label9: TLabel
      Left = 8
      Top = 16
      Width = 80
      Height = 15
      Caption = 'Low Pass (Hz)'
    end
    object Label10: TLabel
      Left = 8
      Top = 64
      Width = 83
      Height = 15
      Caption = 'High Pass (Hz)'
    end
    object ckCED1902NotchFilter: TCheckBox
      Left = 8
      Top = 112
      Width = 89
      Height = 17
      Caption = '50Hz Notch'
      TabOrder = 0
      OnClick = ckCED1902NotchFilterClick
    end
    object cbCED1902LPFilter: TComboBox
      Left = 8
      Top = 32
      Width = 97
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      OnChange = cbCED1902LPFilterChange
    end
    object cbCED1902HPFilter: TComboBox
      Left = 8
      Top = 80
      Width = 97
      Height = 23
      Style = csDropDownList
      TabOrder = 2
      OnChange = cbCED1902HPFilterChange
    end
  end
  object InputGrp: TGroupBox
    Left = 8
    Top = 28
    Width = 137
    Height = 185
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label7: TLabel
      Left = 8
      Top = 16
      Width = 27
      Height = 15
      Caption = 'Input'
    end
    object Label8: TLabel
      Left = 8
      Top = 64
      Width = 95
      Height = 15
      Caption = 'Amplifier Gain (X)'
    end
    object lbDCOffset: TLabel
      Left = 8
      Top = 136
      Width = 53
      Height = 15
      Caption = 'DC Offset'
    end
    object cbCED1902Input: TComboBox
      Left = 8
      Top = 32
      Width = 121
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbCED1902InputChange
    end
    object cbCED1902Gain: TComboBox
      Left = 8
      Top = 80
      Width = 121
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      OnChange = cbCED1902GainChange
    end
    object ckCED1902ACCoupled: TCheckBox
      Left = 8
      Top = 112
      Width = 113
      Height = 17
      Caption = 'AC Coupled'
      TabOrder = 2
      OnClick = ckCED1902ACCoupledClick
    end
    object edDCOffset: TValidatedEdit
      Left = 8
      Top = 152
      Width = 73
      Height = 20
      AutoSize = False
      Text = ' 0 mV'
      Scale = 1000.000000000000000000
      Units = 'mV'
      NumberFormat = '%.4g'
      LoLimit = -32767.000000000000000000
      HiLimit = 32767.000000000000000000
    end
  end
  object cbCED1902ComPort: TComboBox
    Left = 184
    Top = 200
    Width = 81
    Height = 23
    Style = csDropDownList
    TabOrder = 2
    OnChange = cbCED1902ComPortChange
  end
  object bCheck1902: TButton
    Left = 152
    Top = 34
    Width = 105
    Height = 18
    Caption = 'Reset CED 1902'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = bCheck1902Click
  end
  object edCED1902Type: TEdit
    Left = 8
    Top = 6
    Width = 257
    Height = 20
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
  end
end
