object VP500PanelFrm: TVP500PanelFrm
  Left = 280
  Top = 132
  Width = 512
  Height = 499
  Caption = 'VP500 Control Panel'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 137
    Height = 81
    Caption = ' Clamp Mode '
    TabOrder = 0
    object lbClampSpeed: TLabel
      Left = 15
      Top = 44
      Width = 36
      Height = 15
      Alignment = taRightJustify
      Caption = 'Speed'
    end
    object cbClampMode: TComboBox
      Left = 8
      Top = 16
      Width = 121
      Height = 26
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 18
      ParentFont = False
      TabOrder = 0
      OnChange = cbClampModeChange
      Items.Strings = (
        'V-Clamp'
        'I=0'
        'I-Clamp')
    end
    object cbClampSpeed: TComboBox
      Left = 55
      Top = 44
      Width = 74
      Height = 26
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 18
      ItemIndex = 0
      ParentFont = False
      TabOrder = 1
      Text = 'Slow'
      OnChange = cbClampSpeedChange
      Items.Strings = (
        'Slow'
        'Medium'
        'Fast')
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 176
    Width = 137
    Height = 57
    Caption = ' Low Pass Filter '
    TabOrder = 1
    object cbLPFilter: TComboBox
      Left = 8
      Top = 20
      Width = 121
      Height = 25
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 17
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = '100 Hz'
      OnChange = cbLPFilterChange
      Items.Strings = (
        '100 Hz'
        '200 Hz'
        '500 hz'
        '1 kHz'
        '2 kHz'
        '5 kHz'
        '10 kHz'
        '20 kHz'
        '50 kHz')
    end
  end
  object GroupBox5: TGroupBox
    Left = 8
    Top = 80
    Width = 137
    Height = 97
    Caption = ' Current Gain  '
    TabOrder = 2
    object cbAmplifierGain: TComboBox
      Left = 8
      Top = 17
      Width = 121
      Height = 26
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 18
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = 'X1'
      OnChange = cbAmplifierGainChange
      Items.Strings = (
        'X1'
        'X2'
        'X5'
        'X10'
        'X20'
        'X50'
        'X100'
        'X200'
        'X500')
    end
    object GroupBox3: TGroupBox
      Left = 6
      Top = 47
      Width = 123
      Height = 42
      Caption = ' Head Stage '
      TabOrder = 1
      object cbLowHeadstageGain: TRadioButton
        Left = 8
        Top = 14
        Width = 49
        Height = 25
        Caption = 'Low'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnClick = cbLowHeadstageGainClick
      end
      object rbHeadStageGain: TRadioButton
        Left = 56
        Top = 14
        Width = 49
        Height = 25
        Caption = 'High'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = cbLowHeadstageGainClick
      end
    end
  end
  object HoldingVIGrp: TGroupBox
    Left = 8
    Top = 232
    Width = 137
    Height = 73
    Caption = ' Holding Voltage '
    TabOrder = 3
    object edHoldingVI: TValidatedEdit
      Left = 8
      Top = 16
      Width = 121
      Height = 25
      OnKeyPress = edHoldingVIKeyPress
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 mV'
      LoLimit = -200.000000000000000000
      HiLimit = 200.000000000000000000
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%.4g'
    end
    object bApplyHoldingIV: TButton
      Left = 8
      Top = 47
      Width = 57
      Height = 18
      Caption = 'Apply'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bApplyHoldingIVClick
    end
  end
  object GroupBox7: TGroupBox
    Left = 8
    Top = 312
    Width = 137
    Height = 89
    Caption = ' Junction Potential '
    TabOrder = 4
    object edJunctionPotential: TValidatedEdit
      Left = 8
      Top = 18
      Width = 100
      Height = 27
      OnKeyPress = edJunctionPotentialKeyPress
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 mV'
      LoLimit = -1.000000015047466E29
      HiLimit = 200.000000000000000000
      Scale = 1.000000000000000000
      Units = 'mV'
      NumberFormat = '%.4g'
    end
    object bApplyJunction: TButton
      Left = 8
      Top = 49
      Width = 57
      Height = 18
      Caption = 'Apply'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bApplyJunctionClick
    end
    object spJunctionPotential: TSpinButton
      Left = 110
      Top = 17
      Width = 20
      Height = 31
      DownGlyph.Data = {
        0E010000424D0E01000000000000360000002800000009000000060000000100
        200000000000D800000000000000000000000000000000000000008080000080
        8000008080000080800000808000008080000080800000808000008080000080
        8000008080000080800000808000000000000080800000808000008080000080
        8000008080000080800000808000000000000000000000000000008080000080
        8000008080000080800000808000000000000000000000000000000000000000
        0000008080000080800000808000000000000000000000000000000000000000
        0000000000000000000000808000008080000080800000808000008080000080
        800000808000008080000080800000808000}
      TabOrder = 2
      UpGlyph.Data = {
        0E010000424D0E01000000000000360000002800000009000000060000000100
        200000000000D800000000000000000000000000000000000000008080000080
        8000008080000080800000808000008080000080800000808000008080000080
        8000000000000000000000000000000000000000000000000000000000000080
        8000008080000080800000000000000000000000000000000000000000000080
        8000008080000080800000808000008080000000000000000000000000000080
        8000008080000080800000808000008080000080800000808000000000000080
        8000008080000080800000808000008080000080800000808000008080000080
        800000808000008080000080800000808000}
      OnDownClick = spJunctionPotentialDownClick
      OnUpClick = spJunctionPotentialUpClick
    end
  end
  object GroupBox10: TGroupBox
    Left = 152
    Top = 0
    Width = 151
    Height = 185
    Caption = ' Compensation '
    TabOrder = 5
    object GroupBox9: TGroupBox
      Left = 8
      Top = 96
      Width = 136
      Height = 57
      TabOrder = 0
      object Label4: TLabel
        Left = 5
        Top = 8
        Width = 49
        Height = 30
        Alignment = taRightJustify
        Caption = 'Cell Capacity'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object edPercentBoost: TValidatedEdit
        Left = 61
        Top = 11
        Width = 65
        Height = 25
        OnKeyPress = edPercentBoostKeyPress
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Text = ' 0 %'
        LoLimit = -1.000000015047466E29
        HiLimit = 1.000000015047466E29
        Scale = 1.000000000000000000
        Units = '%'
        NumberFormat = '%.4g'
      end
    end
    object GroupBox8: TGroupBox
      Left = 8
      Top = 14
      Width = 136
      Height = 83
      TabOrder = 1
      object Label1: TLabel
        Left = 15
        Top = 8
        Width = 40
        Height = 30
        Alignment = taRightJustify
        Caption = 'Series Res.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label3: TLabel
        Left = 28
        Top = 42
        Width = 31
        Height = 15
        Caption = 'Delay'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edPercentRs: TValidatedEdit
        Left = 61
        Top = 11
        Width = 65
        Height = 25
        OnKeyPress = edPercentRsKeyPress
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Text = ' 0 %'
        LoLimit = -1.000000015047466E29
        HiLimit = 1.000000015047466E29
        Scale = 1.000000000000000000
        Units = '%'
        NumberFormat = '%.4g'
      end
      object cbTauPercentRs: TComboBox
        Left = 61
        Top = 42
        Width = 65
        Height = 23
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        ItemIndex = 0
        ParentFont = False
        TabOrder = 1
        Text = '1 us'
        OnChange = cbTauPercentRsChange
        Items.Strings = (
          '1 us'
          '3 us'
          '7 us'
          '10 us'
          '20 us'
          '30 us'
          '60 us'
          '100 us')
      end
    end
    object bAppyCompensation: TButton
      Left = 85
      Top = 160
      Width = 57
      Height = 17
      Caption = 'Apply'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = bAppyCompensationClick
    end
  end
  object GroupBox11: TGroupBox
    Left = 309
    Top = 0
    Width = 189
    Height = 401
    Caption = ' Neutralisation  '
    TabOrder = 6
    object Label5: TLabel
      Left = 8
      Top = 40
      Width = 30
      Height = 30
      Caption = 'Tau (fast)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object GroupBox13: TGroupBox
      Left = 8
      Top = 14
      Width = 175
      Height = 91
      TabOrder = 0
      object Label6: TLabel
        Left = 31
        Top = 12
        Width = 41
        Height = 15
        Alignment = taRightJustify
        Caption = 'C (fast)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label7: TLabel
        Left = 20
        Top = 40
        Width = 54
        Height = 15
        Alignment = taRightJustify
        Caption = 'Tau (fast)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object edCFast: TValidatedEdit
        Left = 77
        Top = 12
        Width = 89
        Height = 25
        OnKeyPress = edCFastKeyPress
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Text = ' 0 pF'
        LoLimit = -1.000000015047466E29
        HiLimit = 1.000000015047466E29
        Scale = 1.000000000000000000
        Units = 'pF'
        NumberFormat = '%.4g'
      end
      object edTauFast: TValidatedEdit
        Left = 77
        Top = 40
        Width = 89
        Height = 25
        OnKeyPress = edCFastKeyPress
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Text = ' 0 us'
        LoLimit = -1.000000015047466E29
        HiLimit = 1.000000015047466E29
        Scale = 1.000000000000000000
        Units = 'us'
        NumberFormat = '%.4g'
      end
      object bCFastNeutralise: TButton
        Left = 93
        Top = 68
        Width = 73
        Height = 17
        Caption = 'Neutralise'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = bCFastNeutraliseClick
      end
    end
    object GroupBox12: TGroupBox
      Left = 8
      Top = 105
      Width = 175
      Height = 91
      TabOrder = 1
      object Label8: TLabel
        Left = 26
        Top = 12
        Width = 46
        Height = 15
        Alignment = taRightJustify
        Caption = 'C (slow)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label9: TLabel
        Left = 13
        Top = 40
        Width = 59
        Height = 15
        Alignment = taRightJustify
        Caption = 'Tau (slow)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object edCSlow: TValidatedEdit
        Left = 77
        Top = 12
        Width = 89
        Height = 25
        OnKeyPress = edCFastKeyPress
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Text = ' 0 pF'
        LoLimit = -1.000000015047466E29
        HiLimit = 1.000000015047466E29
        Scale = 1.000000000000000000
        Units = 'pF'
        NumberFormat = '%.4g'
      end
      object edTauSlow: TValidatedEdit
        Left = 77
        Top = 40
        Width = 89
        Height = 25
        OnKeyPress = edCFastKeyPress
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Text = ' 0 ms'
        LoLimit = -1.000000015047466E29
        HiLimit = 1.000000015047466E29
        Scale = 1.000000000000000000
        Units = 'ms'
        NumberFormat = '%.4g'
      end
      object bCSlowNeutralise: TButton
        Left = 93
        Top = 68
        Width = 73
        Height = 17
        Caption = 'Neutralise'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = bCSlowNeutraliseClick
      end
    end
    object GroupBox14: TGroupBox
      Left = 8
      Top = 198
      Width = 175
      Height = 115
      TabOrder = 2
      object Label10: TLabel
        Left = 33
        Top = 12
        Width = 39
        Height = 15
        Alignment = taRightJustify
        Caption = 'C (cell)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label11: TLabel
        Left = 21
        Top = 40
        Width = 52
        Height = 15
        Alignment = taRightJustify
        Caption = 'Tau (cell)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object edCCell: TValidatedEdit
        Left = 77
        Top = 12
        Width = 89
        Height = 25
        OnKeyPress = edCFastKeyPress
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Text = ' 0 pF'
        LoLimit = -1.000000015047466E29
        HiLimit = 1.000000015047466E29
        Scale = 1.000000000000000000
        Units = 'pF'
        NumberFormat = '%.4g'
      end
      object edTauCell: TValidatedEdit
        Left = 77
        Top = 40
        Width = 89
        Height = 25
        OnKeyPress = edCFastKeyPress
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Text = ' 0 ms'
        LoLimit = -1.000000015047466E29
        HiLimit = 1.000000015047466E29
        Scale = 1.000000000000000000
        Units = 'ms'
        NumberFormat = '%.4g'
      end
      object bCCellNeutralise: TButton
        Left = 93
        Top = 88
        Width = 73
        Height = 17
        Caption = 'Neutralise'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = bCCellNeutraliseClick
      end
      object ckNeutraliseLeak: TCheckBox
        Left = 56
        Top = 65
        Width = 109
        Height = 24
        Alignment = taLeftJustify
        Caption = 'Neutralise Leak '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
    end
    object GroupBox16: TGroupBox
      Left = 7
      Top = 312
      Width = 176
      Height = 59
      TabOrder = 3
      object bInitialise: TButton
        Left = 5
        Top = 36
        Width = 165
        Height = 17
        Caption = 'Re-initialise Neutralisation'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = bInitialiseClick
      end
      object bOptimiseNeutralisation: TButton
        Left = 7
        Top = 13
        Width = 163
        Height = 17
        Caption = 'Optimise Neutralisation'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = bOptimiseNeutralisationClick
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 152
    Top = 192
    Width = 151
    Height = 73
    Caption = ' Seal Resistance '
    TabOrder = 7
    object edSealResistance: TValidatedEdit
      Left = 21
      Top = 16
      Width = 121
      Height = 25
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 MOhm'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
      Scale = 1.000000000000000000
      Units = 'MOhm'
      NumberFormat = '%.4g'
    end
    object bCalcSealResistance: TButton
      Left = 77
      Top = 49
      Width = 65
      Height = 18
      Caption = 'Calculate'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bCalcSealResistanceClick
    end
  end
  object GroupBox6: TGroupBox
    Left = 152
    Top = 272
    Width = 151
    Height = 129
    Caption = ' Cell Parameters '
    TabOrder = 8
    object Label2: TLabel
      Left = 21
      Top = 16
      Width = 23
      Height = 18
      Caption = 'Rm'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 21
      Top = 40
      Width = 23
      Height = 18
      Caption = 'Cm'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 21
      Top = 64
      Width = 19
      Height = 18
      Caption = 'Rs'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edRm: TValidatedEdit
      Left = 45
      Top = 16
      Width = 97
      Height = 25
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 MOhm'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
      Scale = 1.000000000000000000
      Units = 'MOhm'
      NumberFormat = '%.4g'
    end
    object edCm: TValidatedEdit
      Left = 45
      Top = 44
      Width = 97
      Height = 25
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 pF'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
      Scale = 1.000000000000000000
      Units = 'pF'
      NumberFormat = '%.4g'
    end
    object edRs: TValidatedEdit
      Left = 45
      Top = 72
      Width = 97
      Height = 25
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 MOhm'
      LoLimit = -1.000000015047466E29
      HiLimit = 1.000000015047466E29
      Scale = 1.000000000000000000
      Units = 'MOhm'
      NumberFormat = '%.4g'
    end
    object bCalcCellParameters: TButton
      Left = 77
      Top = 104
      Width = 65
      Height = 17
      Caption = 'Calculate'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = bCalcCellParametersClick
    end
  end
  object GroupBox15: TGroupBox
    Left = 309
    Top = 404
    Width = 189
    Height = 60
    Caption = ' Zap Cell '
    TabOrder = 9
    object Label14: TLabel
      Left = 101
      Top = 12
      Width = 82
      Height = 15
      Alignment = taRightJustify
      Caption = 'Pulse Duration'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object bZap: TButton
      Left = 8
      Top = 16
      Width = 57
      Height = 17
      Caption = 'Zap'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = bZapClick
    end
    object edZapDuration: TValidatedEdit
      Left = 109
      Top = 29
      Width = 73
      Height = 23
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0.1 ms'
      Value = 100.000000000000000000
      LoLimit = 10.000000000000000000
      HiLimit = 1500.000000000000000000
      Scale = 0.001000000047497451
      Units = 'ms'
      NumberFormat = '%.4g'
    end
  end
  object GroupBox17: TGroupBox
    Left = 7
    Top = 404
    Width = 298
    Height = 60
    Caption = ' Errors '
    TabOrder = 10
    object edStatus: TEdit
      Left = 7
      Top = 16
      Width = 282
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'edStatus'
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 256
    Top = 432
  end
end
