object InputChannelSetupFrm: TInputChannelSetupFrm
  Left = 475
  Top = 118
  BorderStyle = bsDialog
  Caption = 'Input Channels & Amplifiers Setup'
  ClientHeight = 529
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl: TPageControl
    Left = 8
    Top = 0
    Width = 345
    Height = 497
    ActivePage = AmplifiersPage
    TabOrder = 0
    OnChange = PageControlChange
    OnChanging = PageControlChanging
    object ChannelsPage: TTabSheet
      Caption = 'Input Channels '
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ChannelTable: TStringGrid
        Left = 0
        Top = 2
        Width = 321
        Height = 351
        Hint = 'Input channel scaling factors and calibration units'
        ColCount = 6
        DefaultColWidth = 44
        DefaultRowHeight = 18
        FixedColor = clInfoBk
        RowCount = 128
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        OnKeyPress = ChannelTableKeyPress
        ColWidths = (
          44
          44
          44
          44
          44
          44)
        RowHeights = (
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
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
      object GroupBox3: TGroupBox
        Left = 5
        Top = 360
        Width = 316
        Height = 81
        Caption = ' Display Grid'
        TabOrder = 1
        object TUnitsGrp: TGroupBox
          Left = 8
          Top = 18
          Width = 89
          Height = 55
          Caption = ' Time units '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object rbTmsecs: TRadioButton
            Left = 8
            Top = 16
            Width = 57
            Height = 17
            Caption = 'msecs.'
            Checked = True
            TabOrder = 0
            TabStop = True
            OnClick = rbTmsecsClick
          end
          object rbTSecs: TRadioButton
            Left = 8
            Top = 32
            Width = 49
            Height = 17
            Caption = 'secs.'
            TabOrder = 1
            OnClick = rbTSecsClick
          end
        end
      end
    end
    object AmplifiersPage: TTabSheet
      Caption = ' Amplifiers'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object AmplifiersTab: TTabControl
        Left = 0
        Top = 0
        Width = 326
        Height = 30
        MultiLine = True
        TabOrder = 0
        Tabs.Strings = (
          'Amplifier #1'
          'Amplifier #2'
          'Amplifier #3'
          'Amplifier #4')
        TabIndex = 2
        OnChange = AmplifiersTabChange
        OnChanging = AmplifiersTabChanging
      end
      object AmpPanel: TPanel
        Left = 5
        Top = 24
        Width = 329
        Height = 433
        TabOrder = 1
        object cbAmplifier: TComboBox
          Left = 8
          Top = 12
          Width = 313
          Height = 23
          Hint = 'Patch/Voltage clamp amplifier attached to channels 0 and 1'
          Style = csDropDownList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = cbAmplifierChange
        end
        object ModeGrp: TGroupBox
          Left = 8
          Top = 36
          Width = 313
          Height = 205
          Caption = ' Input Channels '
          TabOrder = 1
          object rbIClamp: TRadioButton
            Left = 88
            Top = 16
            Width = 73
            Height = 17
            Hint = 'Primary & secondary channels scaling in current-clamp mode'
            Caption = 'IClamp'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = rbIClampClick
          end
          object rbVClamp: TRadioButton
            Left = 16
            Top = 16
            Width = 70
            Height = 17
            Hint = 'Primary & secondary channels scaling in voltage-clamp mode'
            Caption = 'VClamp'
            Checked = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            TabStop = True
            OnClick = rbVClampClick
          end
          object PrimaryChannelGrp: TGroupBox
            Left = 8
            Top = 34
            Width = 297
            Height = 80
            Caption = ' Primary Channel '
            TabOrder = 2
            object Label3: TLabel
              Left = 9
              Top = 18
              Width = 64
              Height = 15
              Alignment = taRightJustify
              Caption = 'Scale factor'
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label10: TLabel
              Left = 207
              Top = 18
              Width = 29
              Height = 15
              Alignment = taRightJustify
              Caption = 'Units'
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object edPrimaryChannelScaleFactor: TValidatedEdit
              Left = 80
              Top = 18
              Width = 105
              Height = 23
              Hint = 'Primary channel scaling factor at X1 gain (Units/V)'
              OnKeyPress = edPrimaryChannelScaleFactorKeyPress
              ShowHint = True
              Text = ' 0 V/V'
              Scale = 1.000000000000000000
              Units = 'V/V'
              NumberFormat = '%.4g'
              LoLimit = -1.000000015047466E30
              HiLimit = 1.000000015047466E30
            end
            object edPrimaryChannelUnits: TEdit
              Left = 240
              Top = 18
              Width = 49
              Height = 23
              Hint = 'Primary channel units'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              Text = 'edPrimaryChannelUnits'
              OnChange = edPrimaryChannelUnitsChange
            end
            object Panel1: TPanel
              Left = 120
              Top = 44
              Width = 170
              Height = 25
              BevelOuter = bvNone
              TabOrder = 2
              object Label1: TLabel
                Left = 0
                Top = 0
                Width = 87
                Height = 15
                Alignment = taCenter
                Caption = 'On analog input'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
              end
              object cbPrimaryAnalogInput: TComboBox
                Left = 93
                Top = 0
                Width = 77
                Height = 23
                Hint = 'Lab. interface analog input for secondary channel'
                Style = csDropDownList
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
              end
            end
          end
          object SecondaryChannelGrp: TGroupBox
            Left = 8
            Top = 120
            Width = 297
            Height = 75
            Caption = ' Secondary Channel '
            TabOrder = 3
            object Label5: TLabel
              Left = 9
              Top = 18
              Width = 64
              Height = 15
              Alignment = taRightJustify
              Caption = 'Scale factor'
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label11: TLabel
              Left = 207
              Top = 18
              Width = 29
              Height = 15
              Alignment = taRightJustify
              Caption = 'Units'
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object edSecondaryChannelScaleFactor: TValidatedEdit
              Left = 80
              Top = 18
              Width = 105
              Height = 23
              Hint = 'Secondary channel scaling factor at X1 gain (Units/V)'
              OnKeyPress = edSecondaryChannelScaleFactorKeyPress
              ShowHint = True
              Text = ' 0 V/V'
              Scale = 1.000000000000000000
              Units = 'V/V'
              NumberFormat = '%.4g'
              LoLimit = -1.000000015047466E30
              HiLimit = 1.000000015047466E30
            end
            object edSecondaryChannelUnits: TEdit
              Left = 240
              Top = 18
              Width = 49
              Height = 23
              Hint = 'Secondary channel units'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              Text = 'edCurrentOutputUnits'
              OnChange = edSecondaryChannelUnitsChange
            end
            object pnSecondaryInputCC: TPanel
              Left = 121
              Top = 44
              Width = 170
              Height = 25
              BevelOuter = bvNone
              TabOrder = 2
              object Label6: TLabel
                Left = 0
                Top = 0
                Width = 87
                Height = 15
                Alignment = taCenter
                Caption = 'On analog input'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
              end
              object cbSecondaryAnalogInputCC: TComboBox
                Left = 93
                Top = 0
                Width = 77
                Height = 23
                Hint = 'Lab. interface analog input for secondary channel'
                Style = csDropDownList
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnChange = cbSecondaryAnalogInputCCChange
              end
            end
            object pnSecondaryInputVC: TPanel
              Left = 121
              Top = 44
              Width = 170
              Height = 25
              BevelOuter = bvNone
              TabOrder = 3
              object Label7: TLabel
                Left = 0
                Top = 0
                Width = 87
                Height = 15
                Alignment = taCenter
                Caption = 'On analog input'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
              end
              object cbSecondaryAnalogInputVC: TComboBox
                Left = 93
                Top = 0
                Width = 77
                Height = 23
                Hint = 'Lab. interface analog input for secondary channel'
                Style = csDropDownList
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
              end
            end
          end
        end
        object VoltageCommandGrp: TGroupBox
          Left = 8
          Top = 242
          Width = 313
          Height = 49
          Caption = ' Voltage-clamp command channel'
          TabOrder = 2
          object Label2: TLabel
            Left = 192
            Top = 18
            Width = 36
            Height = 15
            Alignment = taRightJustify
            Caption = 'Output'
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label4: TLabel
            Left = 9
            Top = 18
            Width = 64
            Height = 15
            Alignment = taRightJustify
            Caption = 'Scale factor'
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object cbVoltageCommandChannel: TComboBox
            Left = 230
            Top = 18
            Width = 77
            Height = 23
            Hint = 'Lab. interface analog output for voltage clamp command signals'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
          object edVoltageCommandScaleFactor: TValidatedEdit
            Left = 80
            Top = 18
            Width = 89
            Height = 23
            Hint = 'Voltage clamp command scaling factor'
            ShowHint = True
            Text = ' 0 V/V'
            Scale = 1.000000000000000000
            Units = 'V/V'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
        end
        object CurrentCommandGrp: TGroupBox
          Left = 8
          Top = 292
          Width = 313
          Height = 49
          Caption = ' Current-clamp command channel '
          TabOrder = 3
          object Label8: TLabel
            Left = 192
            Top = 16
            Width = 36
            Height = 15
            Alignment = taRightJustify
            Caption = 'Output'
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label9: TLabel
            Left = 9
            Top = 16
            Width = 64
            Height = 15
            Alignment = taRightJustify
            Caption = 'Scale factor'
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object cbCurrentCommandChannel: TComboBox
            Left = 230
            Top = 16
            Width = 77
            Height = 23
            Hint = 'Lab. interface analog output for current clamp command signals'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
          object edCurrentCommandScaleFactor: TValidatedEdit
            Left = 80
            Top = 16
            Width = 89
            Height = 23
            Hint = 'Current clamp command scaling factor'
            ShowHint = True
            Text = ' 0 A/V'
            Scale = 1.000000000000000000
            Units = 'A/V'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
        end
        object TelegraphChannelsGrp: TGroupBox
          Left = 8
          Top = 346
          Width = 313
          Height = 77
          Caption = ' Telegraph channels '
          TabOrder = 4
          object GainTelegraphPanel: TPanel
            Left = 2
            Top = 16
            Width = 306
            Height = 28
            BevelOuter = bvNone
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            object lbGainTelegraph: TLabel
              Left = 193
              Top = 0
              Width = 29
              Height = 15
              Alignment = taRightJustify
              Caption = 'Gain '
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object cbGainTelegraphChannel: TComboBox
              Left = 230
              Top = 0
              Width = 77
              Height = 23
              Style = csDropDownList
              TabOrder = 0
            end
          end
          object ModeTelegraphPanel: TPanel
            Left = 2
            Top = 44
            Width = 306
            Height = 28
            BevelOuter = bvNone
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            object lbModeTelegraph: TLabel
              Left = 69
              Top = 0
              Width = 153
              Height = 15
              Alignment = taRightJustify
              Caption = 'Voltage/current clamp mode'
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object cbModeTelegraphChannel: TComboBox
              Left = 230
              Top = 0
              Width = 77
              Height = 23
              Style = csDropDownList
              TabOrder = 0
            end
          end
        end
      end
    end
  end
  object bLoadDefaultSettings: TButton
    Left = 244
    Top = 502
    Width = 110
    Height = 17
    Caption = 'Default Settings'
    TabOrder = 1
    OnClick = bLoadDefaultSettingsClick
  end
  object bSaveSettings: TButton
    Left = 126
    Top = 502
    Width = 110
    Height = 17
    Caption = 'Save Settings'
    TabOrder = 2
    OnClick = bSaveSettingsClick
  end
  object bLoadSettings: TButton
    Left = 10
    Top = 502
    Width = 110
    Height = 17
    Caption = 'Load Settings'
    TabOrder = 3
    OnClick = bLoadSettingsClick
  end
  object OpenDialog: TOpenDialog
    Left = 352
    Top = 104
  end
  object SaveDialog: TSaveDialog
    Left = 352
    Top = 144
  end
end
