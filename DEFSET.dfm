object DefSetFrm: TDefSetFrm
  Left = 476
  Top = 282
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Default Output Settings'
  ClientHeight = 216
  ClientWidth = 329
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
  object DACGroup: TGroupBox
    Left = 8
    Top = 90
    Width = 185
    Height = 121
    Caption = ' Analog Output Holding Levels '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object panAO0: TPanel
      Left = 16
      Top = 16
      Width = 164
      Height = 25
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object lbAO0: TLabel
        Left = 0
        Top = 0
        Width = 36
        Height = 14
        Caption = 'Voltage'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edLevelAO0: TValidatedEdit
        Left = 60
        Top = 0
        Width = 97
        Height = 20
        OnKeyPress = edLevelAO0KeyPress
        AutoSize = False
        Text = ' 0 mV'
        Scale = 1000.000000000000000000
        Units = 'mV'
        NumberFormat = '%.5g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object panAO1: TPanel
      Left = 16
      Top = 42
      Width = 164
      Height = 25
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object lbAO1: TLabel
        Left = 0
        Top = 0
        Width = 36
        Height = 14
        Caption = 'Voltage'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edLevelAO1: TValidatedEdit
        Left = 60
        Top = 0
        Width = 97
        Height = 20
        OnKeyPress = edLevelAO0KeyPress
        AutoSize = False
        Text = ' 0 mV'
        Scale = 1000.000000000000000000
        Units = 'mV'
        NumberFormat = '%.5g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object panAO2: TPanel
      Left = 16
      Top = 68
      Width = 164
      Height = 25
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object lbAO2: TLabel
        Left = 0
        Top = 0
        Width = 36
        Height = 14
        Caption = 'Voltage'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edLevelAO2: TValidatedEdit
        Left = 60
        Top = 0
        Width = 97
        Height = 20
        OnKeyPress = edLevelAO0KeyPress
        AutoSize = False
        Text = ' 0 mV'
        Scale = 1000.000000000000000000
        Units = 'mV'
        NumberFormat = '%.5g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
    object panAo3: TPanel
      Left = 16
      Top = 93
      Width = 164
      Height = 25
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object lbAO3: TLabel
        Left = 0
        Top = 0
        Width = 36
        Height = 14
        Caption = 'Voltage'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edLevelAO3: TValidatedEdit
        Left = 60
        Top = 0
        Width = 97
        Height = 20
        OnKeyPress = edLevelAO0KeyPress
        AutoSize = False
        Text = ' 0 mV'
        Scale = 1000.000000000000000000
        Units = 'mV'
        NumberFormat = '%.3g'
        LoLimit = -1.000000015047466E30
        HiLimit = 1.000000015047466E30
      end
    end
  end
  object DIGGroup: TGroupBox
    Left = 8
    Top = 4
    Width = 313
    Height = 81
    Caption = ' Digital Outputs '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 32
      Width = 15
      Height = 14
      Caption = 'On'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 50
      Width = 16
      Height = 14
      Caption = 'Off'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox2: TGroupBox
      Left = 64
      Top = 16
      Width = 30
      Height = 57
      Caption = ' 1 '
      TabOrder = 0
      object rbOn1: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        TabOrder = 0
        OnClick = rbOn0Click
      end
      object rbOff1: TRadioButton
        Left = 8
        Top = 32
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = rbOn0Click
      end
    end
    object GroupBox5: TGroupBox
      Left = 128
      Top = 16
      Width = 30
      Height = 57
      Caption = ' 3 '
      TabOrder = 1
      object rbOn3: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        Caption = 'rbOn3'
        TabOrder = 0
        OnClick = rbOn0Click
      end
      object rboff3: TRadioButton
        Left = 8
        Top = 32
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = rbOn0Click
      end
    end
    object GroupBox6: TGroupBox
      Left = 160
      Top = 16
      Width = 30
      Height = 57
      Caption = ' 4 '
      TabOrder = 2
      object rbon4: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        TabOrder = 0
        OnClick = rbOn0Click
      end
      object rboff4: TRadioButton
        Left = 8
        Top = 32
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = rbOn0Click
      end
    end
    object GroupBox7: TGroupBox
      Left = 192
      Top = 16
      Width = 30
      Height = 57
      Caption = ' 5 '
      TabOrder = 3
      object rbon5: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        TabOrder = 0
        OnClick = rbOn0Click
      end
      object rboff5: TRadioButton
        Left = 8
        Top = 32
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = rbOn0Click
      end
    end
    object GroupBox8: TGroupBox
      Left = 224
      Top = 16
      Width = 30
      Height = 57
      Caption = ' 6 '
      TabOrder = 4
      object rbon6: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        TabOrder = 0
        OnClick = rbOn0Click
      end
      object rboff6: TRadioButton
        Left = 8
        Top = 32
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = rbOn0Click
      end
    end
    object GroupBox9: TGroupBox
      Left = 256
      Top = 16
      Width = 30
      Height = 57
      Caption = ' 7 '
      TabOrder = 5
      object rbon7: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        TabOrder = 0
        OnClick = rbOn0Click
      end
      object rboff7: TRadioButton
        Left = 8
        Top = 32
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = rbOn0Click
      end
    end
    object GroupBox1: TGroupBox
      Left = 96
      Top = 16
      Width = 30
      Height = 57
      Caption = ' 2 '
      TabOrder = 6
      object rbOn2: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        Caption = 'rbOn2'
        TabOrder = 0
        OnClick = rbOn0Click
      end
      object rbOff2: TRadioButton
        Left = 8
        Top = 32
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = rbOn0Click
      end
    end
    object Dig0: TGroupBox
      Left = 32
      Top = 16
      Width = 30
      Height = 57
      Caption = ' 0 '
      TabOrder = 7
      object rbOn0: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        Caption = 'rbOn0'
        TabOrder = 0
        OnClick = rbOn0Click
      end
      object rbOff0: TRadioButton
        Left = 8
        Top = 32
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = rbOn0Click
      end
    end
  end
  object bOK: TButton
    Left = 199
    Top = 186
    Width = 49
    Height = 17
    Caption = 'Apply'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = bOKClick
  end
  object GroupBox3: TGroupBox
    Left = 199
    Top = 90
    Width = 122
    Height = 90
    Caption = ' Default File Name  '
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 41
      Width = 28
      Height = 14
      Caption = 'Prefix'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edFileNamePrefix: TEdit
      Left = 8
      Top = 58
      Width = 105
      Height = 20
      TabOrder = 0
    end
    object ckFileNameIncludeDate: TCheckBox
      Left = 8
      Top = 18
      Width = 95
      Height = 17
      Caption = 'Include Date'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 1
    end
  end
end
