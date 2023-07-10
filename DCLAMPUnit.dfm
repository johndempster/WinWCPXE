object DCLAMPFrm: TDCLAMPFrm
  Left = 0
  Top = 0
  Caption = 'DCLAMP - Dynamic Clamp Control Panel'
  ClientHeight = 597
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Page: TPageControl
    Left = 8
    Top = 0
    Width = 769
    Height = 594
    ActivePage = ControlsTab
    TabOrder = 0
    OnChange = PageChange
    object ControlsTab: TTabSheet
      Caption = 'Controls '
      object GroupBox1: TGroupBox
        Left = 3
        Top = 0
        Width = 749
        Height = 534
        TabOrder = 0
        object Label4: TLabel
          Left = 195
          Top = 434
          Width = 102
          Height = 14
          Alignment = taRightJustify
          Caption = 'DCLAMP COM Port'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object GroupBox4: TGroupBox
          Left = 392
          Top = 12
          Width = 345
          Height = 174
          Caption = ' Parameter Incrementing '
          TabOrder = 0
          object edNumRecords: TValidatedEdit
            Left = 104
            Top = 66
            Width = 33
            Height = 21
            Hint = 'No. of records to acquire before incrementing parameters'
            ShowHint = True
            Text = ' 1 '
            Value = 1.000000000000000000
            Scale = 1.000000000000000000
            NumberFormat = '%.0f'
            LoLimit = 1.000000000000000000
            HiLimit = 1000000.000000000000000000
          end
          object sgSteps: TStringGrid
            Left = 162
            Top = 16
            Width = 175
            Height = 150
            Hint = 'Parameter step size table'
            ColCount = 2
            DefaultRowHeight = 20
            RowCount = 4
            FixedRows = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnKeyPress = sgStepsKeyPress
            ColWidths = (
              64
              64)
            RowHeights = (
              20
              20
              20
              20)
          end
          object rbNoIncrements: TRadioButton
            Left = 8
            Top = 18
            Width = 129
            Height = 17
            Hint = 'Parameter incrementing off'
            Caption = 'Off'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            TabStop = True
          end
          object rbIncrementAfterProtocol: TRadioButton
            Left = 8
            Top = 33
            Width = 129
            Height = 17
            Hint = 'Increment parameters at end of stimulus protocol'
            Caption = 'At End of Protocol'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
          end
          object rbIncrementAfterRecord: TRadioButton
            Left = 8
            Top = 49
            Width = 129
            Height = 17
            Hint = 'Increment parameters after specified number of records acquired'
            Caption = 'After No. of Records'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
          end
        end
        object GroupBox5: TGroupBox
          Left = 8
          Top = 12
          Width = 97
          Height = 174
          Caption = ' Conductance '
          TabOrder = 1
          object rbOff: TRadioButton
            Left = 8
            Top = 16
            Width = 81
            Height = 17
            Hint = 'Simulaed conductance off'
            Caption = 'Off'
            Checked = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TabStop = True
            OnClick = rbOffClick
          end
          object rbAdd: TRadioButton
            Left = 8
            Top = 32
            Width = 73
            Height = 17
            Hint = 'Add simulated conductance'
            Caption = 'Add'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = rbAddClick
          end
          object rbSubtract: TRadioButton
            Left = 8
            Top = 48
            Width = 81
            Height = 17
            Hint = 'Subtract simulated conductance'
            Caption = 'Subtract'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = rbSubtractClick
          end
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 192
          Width = 360
          Height = 233
          Caption = ' Activation Parameter (m) '
          TabOrder = 2
          object Label16: TLabel
            Left = 225
            Top = 199
            Width = 71
            Height = 14
            Caption = 'Power factor'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object edmPower: TValidatedEdit
            Left = 302
            Top = 199
            Width = 46
            Height = 21
            OnKeyPress = edmPowerKeyPress
            Text = ' 1 '
            Value = 1.000000000000000000
            Scale = 1.000000000000000000
            NumberFormat = '%.4g'
            LoLimit = 1.000000000000000000
            HiLimit = 3.000000000000000000
          end
          object GroupBox7: TGroupBox
            Left = 8
            Top = 14
            Width = 340
            Height = 73
            Caption = ' Steady state '
            TabOrder = 1
            object HTMLLabel1: THTMLLabel
              Left = 8
              Top = 16
              Width = 257
              Height = 25
              Caption = 
                'm<sub>inf</sub>(V) = 1/(1 + exp(-(V-V<sub>'#189'</sub>)/V<sub>slp</su' +
                'b>))'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel8: THTMLLabel
              Left = 210
              Top = 40
              Width = 26
              Height = 25
              Caption = 'V<sub>slp</sub>'
              Alignment = taCenter
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel9: THTMLLabel
              Left = 65
              Top = 40
              Width = 50
              Height = 25
              Caption = 'V<sub>'#189'</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object edMSSVhalf: TValidatedEdit
              Left = 110
              Top = 40
              Width = 73
              Height = 21
              Hint = 'Activation parameter half-maximal voltage'
              OnKeyPress = edMSSVhalfKeyPress
              ShowHint = True
              Text = ' -20 mV'
              Value = -20.000000000000000000
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -1.000000015047466E30
              HiLimit = 1.000000015047466E30
            end
            object edMSSVslope: TValidatedEdit
              Left = 256
              Top = 40
              Width = 73
              Height = 21
              Hint = 'Activation parameter slope factor'
              OnKeyPress = edMSSVslopeKeyPress
              ShowHint = True
              Text = ' -10 mV'
              Value = -10.000000000000000000
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -1.000000015047466E30
              HiLimit = 1.000000015047466E30
            end
          end
          object GroupBox8: TGroupBox
            Left = 8
            Top = 88
            Width = 340
            Height = 105
            Caption = 'Time constant '
            TabOrder = 2
            object HTMLLabel2: THTMLLabel
              Left = 8
              Top = 16
              Width = 325
              Height = 25
              Caption = 
                'tau(V) = tau<sub>mn</sub>+(tau<sub>mx</sub>-tau<sub>mn</sub>)exp' +
                '(-((V-V<sub>pk</sub>)/V<sub>slp</sub>)<sup>2</sup>)'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel3: THTMLLabel
              Left = 65
              Top = 40
              Width = 45
              Height = 25
              Caption = 'Tau<sub>mn</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel4: THTMLLabel
              Left = 210
              Top = 40
              Width = 45
              Height = 25
              Caption = 'Tau<sub>mx</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel5: THTMLLabel
              Left = 65
              Top = 68
              Width = 45
              Height = 25
              Caption = 'V<sub>pk</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel6: THTMLLabel
              Left = 210
              Top = 68
              Width = 45
              Height = 25
              Caption = 'V<sub>slp</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object edMTauMin: TValidatedEdit
              Left = 110
              Top = 40
              Width = 73
              Height = 21
              Hint = 'Activation time constant (mininum)'
              OnKeyPress = edMTauMinKeyPress
              ShowHint = True
              Text = ' 0.1 ms'
              Value = 0.100000001490116100
              Scale = 1.000000000000000000
              Units = 'ms'
              NumberFormat = '%.4g'
              LoLimit = 0.100000001490116100
              HiLimit = 100000.000000000000000000
            end
            object edMTauMax: TValidatedEdit
              Left = 256
              Top = 40
              Width = 73
              Height = 21
              Hint = 'Activation time constant (maxinum)'
              OnKeyPress = edMTauMaxKeyPress
              ShowHint = True
              Text = ' 3500 ms'
              Value = 3500.000000000000000000
              Scale = 1.000000000000000000
              Units = 'ms'
              NumberFormat = '%.4g'
              LoLimit = 0.100000001490116100
              HiLimit = 100000.000000000000000000
            end
            object edMTauVhalf: TValidatedEdit
              Left = 110
              Top = 68
              Width = 73
              Height = 21
              Hint = 'Activation time constant peak voltage'
              OnKeyPress = edMTauVhalfKeyPress
              ShowHint = True
              Text = ' 0.1 mV'
              Value = 0.100000001490116100
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -500.000000000000000000
              HiLimit = 500.000000000000000000
            end
            object edMTauVSlope: TValidatedEdit
              Left = 256
              Top = 68
              Width = 73
              Height = 21
              Hint = 'Activation time constant slope factor'
              OnKeyPress = edMTauVSlopeKeyPress
              ShowHint = True
              Text = ' 0.0295 mV'
              Value = 0.029500000178813930
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -500.000000000000000000
              HiLimit = 500.000000000000000000
            end
          end
        end
        object GroupBox9: TGroupBox
          Left = 374
          Top = 192
          Width = 363
          Height = 333
          Caption = ' Inactivation Parameter (h) '
          TabOrder = 3
          object Label8: TLabel
            Left = 196
            Top = 305
            Width = 70
            Height = 14
            Alignment = taRightJustify
            Caption = 'Fast Fraction'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object GroupBox10: TGroupBox
            Left = 8
            Top = 14
            Width = 340
            Height = 73
            Caption = ' Steady state '
            TabOrder = 0
            object HTMLLabel10: THTMLLabel
              Left = 8
              Top = 16
              Width = 257
              Height = 25
              Caption = 
                'h<sub>inf</sub>(V) = 1/(1 + exp(-(V-V<sub>'#189'</sub>)/V<sub>slp</su' +
                'b>))'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel11: THTMLLabel
              Left = 210
              Top = 40
              Width = 40
              Height = 25
              Caption = 'V<sub>slp</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel12: THTMLLabel
              Left = 65
              Top = 40
              Width = 50
              Height = 25
              Caption = 'V<sub>'#189'</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object edHSSVhalf: TValidatedEdit
              Left = 110
              Top = 40
              Width = 73
              Height = 21
              Hint = 'Inactivation parameter half-maximal voltage'
              OnKeyPress = edHSSVhalfKeyPress
              ShowHint = True
              Text = ' 4000 mV'
              Value = 4000.000000000000000000
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -1.000000015047466E30
              HiLimit = 1.000000015047466E30
            end
            object edHSSVslope: TValidatedEdit
              Left = 256
              Top = 40
              Width = 73
              Height = 21
              Hint = 'Inactivation parameter slope factor'
              OnKeyPress = edHSSVslopeKeyPress
              ShowHint = True
              Text = ' -0.035 mV'
              Value = -0.035000000149011610
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -1.000000015047466E30
              HiLimit = 1.000000015047466E30
            end
          end
          object GroupBox11: TGroupBox
            Left = 8
            Top = 88
            Width = 340
            Height = 105
            Caption = 'Time constant (fast) '
            TabOrder = 1
            object HTMLLabel13: THTMLLabel
              Left = 8
              Top = 16
              Width = 329
              Height = 25
              Caption = 
                'tau(V) = tau<sub>mn</sub>+(tau<sub>mx</sub> - tau<sub>mn</sub>)e' +
                'xp(((V-V<sub>pk</sub>)/V<sub>slp</sub>)<sup>2</sup>)'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel14: THTMLLabel
              Left = 65
              Top = 40
              Width = 45
              Height = 25
              Caption = 'Tau<sub>mn</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel15: THTMLLabel
              Left = 210
              Top = 40
              Width = 45
              Height = 25
              Caption = 'Tau<sub>mx</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel16: THTMLLabel
              Left = 65
              Top = 68
              Width = 45
              Height = 25
              Caption = 'V<sub>pk</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel17: THTMLLabel
              Left = 210
              Top = 71
              Width = 45
              Height = 25
              Caption = 'V<sub>slp</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object edHTauFMin: TValidatedEdit
              Left = 110
              Top = 40
              Width = 73
              Height = 21
              Hint = 'Fast inactivation time constant (mininum)'
              OnKeyPress = edHTauFMinKeyPress
              ShowHint = True
              Text = ' 0.1 ms'
              Value = 0.100000001490116100
              Scale = 1.000000000000000000
              Units = 'ms'
              NumberFormat = '%.4g'
              LoLimit = 0.100000001490116100
              HiLimit = 1000000000.000000000000000000
            end
            object edHTauFMax: TValidatedEdit
              Left = 256
              Top = 40
              Width = 73
              Height = 21
              Hint = 'Fast inactivation time constant (maxinum)'
              OnKeyPress = edHTauFMaxKeyPress
              ShowHint = True
              Text = ' 3500 ms'
              Value = 3500.000000000000000000
              Scale = 1.000000000000000000
              Units = 'ms'
              NumberFormat = '%.4g'
              LoLimit = 0.100000001490116100
              HiLimit = 1000000000.000000000000000000
            end
            object edHTauFVhalf: TValidatedEdit
              Left = 116
              Top = 67
              Width = 73
              Height = 21
              Hint = 
                'Fast inactivation time constant slope factorInactivation time co' +
                'nstant peak voltage'
              OnKeyPress = edHTauFVhalfKeyPress
              ShowHint = True
              Text = ' 0.1 mV'
              Value = 0.100000001490116100
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -1000000.000000000000000000
              HiLimit = 1000000.000000000000000000
            end
            object edHTauFVslope: TValidatedEdit
              Left = 256
              Top = 68
              Width = 73
              Height = 21
              Hint = 'Fast inactivation time constant slope factor'
              OnKeyPress = edHTauFVslopeKeyPress
              ShowHint = True
              Text = ' 0.0295 mV'
              Value = 0.029500000178813930
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -1000000.000000000000000000
              HiLimit = 1000000.000000000000000000
            end
          end
          object GroupBox3: TGroupBox
            Left = 8
            Top = 196
            Width = 340
            Height = 105
            Caption = 'Time constant (slow) '
            TabOrder = 2
            object HTMLLabel18: THTMLLabel
              Left = 13
              Top = 17
              Width = 324
              Height = 25
              Caption = 
                'tau(V) = tau<sub>mn</sub>+(tau<sub>mx</sub> - tau<sub>mn</sub>)e' +
                'xp(((V-V<sub>pk</sub>)/V<sub>slp</sub>)<sup>2</sup>)'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel19: THTMLLabel
              Left = 65
              Top = 39
              Width = 45
              Height = 25
              Caption = 'Tau<sub>mn</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel20: THTMLLabel
              Left = 210
              Top = 40
              Width = 45
              Height = 25
              Caption = 'Tau<sub>mx</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel21: THTMLLabel
              Left = 65
              Top = 67
              Width = 45
              Height = 25
              Caption = 'V<sub>pk</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object HTMLLabel22: THTMLLabel
              Left = 210
              Top = 68
              Width = 45
              Height = 25
              Caption = 'V<sub>slp</sub>'
              Alignment = taLeftJustify
              LineSpacing = 1.000000000000000000
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
            end
            object edHTauSMin: TValidatedEdit
              Left = 110
              Top = 40
              Width = 73
              Height = 21
              Hint = 
                'Slow inactivation time constant slope factorInactivation time co' +
                'nstant peak voltage'
              OnKeyPress = edHTauSMinKeyPress
              ShowHint = True
              Text = ' 0.1 ms'
              Value = 0.100000001490116100
              Scale = 1.000000000000000000
              Units = 'ms'
              NumberFormat = '%.4g'
              LoLimit = 0.100000001490116100
              HiLimit = 100000.000000000000000000
            end
            object edHTauSMax: TValidatedEdit
              Left = 256
              Top = 41
              Width = 73
              Height = 21
              Hint = 'Slow inactivation time constant (maxinum)'
              OnKeyPress = edHTauSMaxKeyPress
              ShowHint = True
              Text = ' 3500 ms'
              Value = 3500.000000000000000000
              Scale = 1.000000000000000000
              Units = 'ms'
              NumberFormat = '%.4g'
              LoLimit = 0.100000001490116100
              HiLimit = 100000.000000000000000000
            end
            object edHTauSVHalf: TValidatedEdit
              Left = 110
              Top = 68
              Width = 73
              Height = 21
              OnKeyPress = edHTauSVHalfKeyPress
              Text = ' 0.1 mV'
              Value = 0.100000001490116100
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -500.000000000000000000
              HiLimit = 500.000000000000000000
            end
            object edHTauSVSlope: TValidatedEdit
              Left = 256
              Top = 68
              Width = 73
              Height = 21
              Hint = 'Slow inactivation time constant slope factor'
              OnKeyPress = edHTauSVSlopeKeyPress
              ShowHint = True
              Text = ' 0.0295 mV'
              Value = 0.029500000178813930
              Scale = 1.000000000000000000
              Units = 'mV'
              NumberFormat = '%.4g'
              LoLimit = -500.000000000000000000
              HiLimit = 500.000000000000000000
            end
          end
          object edHFastFraction: TValidatedEdit
            Left = 272
            Top = 305
            Width = 73
            Height = 21
            Hint = 'Fraction of inactivation which is fast'
            OnKeyPress = edHFastFractionKeyPress
            ShowHint = True
            Text = ' 0.5 '
            Value = 0.500000000000000000
            Scale = 1.000000000000000000
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000000000000000
          end
        end
        object GroupBox6: TGroupBox
          Left = 112
          Top = 12
          Width = 275
          Height = 174
          TabOrder = 4
          object Label3: TLabel
            Left = 55
            Top = 16
            Width = 135
            Height = 14
            Alignment = taRightJustify
            Caption = 'Reversal Potential (Vrev)'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label7: TLabel
            Left = 17
            Top = 64
            Width = 172
            Height = 14
            Alignment = taRightJustify
            Caption = 'Current Command Scale Factor'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label1: TLabel
            Left = 118
            Top = 40
            Width = 72
            Height = 14
            Alignment = taRightJustify
            Caption = 'Conductance'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object ckEnableInhibitInput: TCheckBox
            Left = 113
            Top = 91
            Width = 153
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Enable Inhibit Input (AI2)'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object edVrev: TValidatedEdit
            Left = 196
            Top = 16
            Width = 70
            Height = 21
            Hint = 'Ionic current reversal potential'
            OnKeyPress = edVrevKeyPress
            ShowHint = True
            Text = ' 0 mV'
            Scale = 1.000000000000000000
            Units = 'mV'
            NumberFormat = '%.4g'
            LoLimit = -200.000000000000000000
            HiLimit = 200.000000000000000000
          end
          object edCurrentCommandScaleFactor: TValidatedEdit
            Left = 195
            Top = 64
            Width = 70
            Height = 21
            Hint = 'Current command voltage scaling factor'
            OnKeyPress = edCurrentCommandScaleFactorKeyPress
            ShowHint = True
            Text = ' 1E-008 A/V'
            Value = 0.000000009999999939
            Scale = 1.000000000000000000
            Units = 'A/V'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
          object edGMax: TValidatedEdit
            Left = 196
            Top = 40
            Width = 70
            Height = 21
            Hint = 'Maximum conductance'
            OnKeyPress = edGMaxKeyPress
            ShowHint = True
            Text = ' 10 nS'
            Value = 10.000000000000000000
            Scale = 1.000000000000000000
            Units = 'nS'
            NumberFormat = '%.4g'
            LoLimit = -1.000000015047466E30
            HiLimit = 1.000000015047466E30
          end
        end
        object bReset: TButton
          Left = 16
          Top = 451
          Width = 153
          Height = 17
          Hint = 'Update settings in dynamic clamp controller unit'
          Caption = 'Update Dynamic Clamp'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = bResetClick
        end
        object bLoadSettings: TButton
          Left = 16
          Top = 474
          Width = 153
          Height = 17
          Hint = 'Load dynamic clamp conductance settings'
          Caption = 'Load Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = bLoadSettingsClick
        end
        object bSaveSettings: TButton
          Left = 16
          Top = 497
          Width = 153
          Height = 17
          Hint = 'Save dynamic clamp conductance settings'
          Caption = 'Save Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnClick = bSaveSettingsClick
        end
        object cbComPort: TComboBox
          Left = 303
          Top = 431
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 8
          Text = 'COM 1'
          Items.Strings = (
            'COM 1'
            'COM 2'
            'COM 3'
            'COM 4')
        end
      end
      object edStatus: TEdit
        Left = 3
        Top = 540
        Width = 750
        Height = 21
        TabOrder = 1
      end
    end
    object GraphsTab: TTabSheet
      Caption = 'Graphs'
      ImageIndex = 1
      object plPlot: TXYPlotDisplay
        Left = 8
        Top = 40
        Width = 745
        Height = 449
        MaxPointsPerLine = 4096
        XAxisMax = 1.000000000000000000
        XAxisTick = 0.200000002980232200
        XAxisLaw = axLinear
        XAxisLabel = 'X Axis'
        XAxisAutoRange = False
        YAxisMax = 1.000000000000000000
        YAxisTick = 0.200000002980232200
        YAxisLaw = axLinear
        YAxisLabel = 'Y Axis'
        YAxisAutoRange = False
        YAxisLabelAtTop = False
        ScreenFontName = 'Arial'
        ScreenFontSize = 10
        LineWidth = 1
        MarkerSize = 6
        ShowLines = True
        ShowMarkers = True
        HistogramFullBorders = False
        HistogramFillColor = clWhite
        HistogramFillStyle = bsClear
        HistogramCumulative = False
        HistogramPercentage = False
        PrinterFontSize = 10
        PrinterFontName = 'Arial'
        PrinterLineWidth = 1
        PrinterMarkerSize = 5
        PrinterLeftMargin = 0
        PrinterRightMargin = 0
        PrinterTopMargin = 0
        PrinterBottomMargin = 0
        PrinterDisableColor = False
        MetafileWidth = 500
        MetafileHeight = 400
      end
      object cbPlot: TComboBox
        Left = 8
        Top = 8
        Width = 273
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = cbPlotChange
      end
      object bCopyToClipboard: TButton
        Left = 288
        Top = 8
        Width = 121
        Height = 17
        Caption = 'Copy to Clipboard'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = bCopyToClipboardClick
      end
    end
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 32
    Top = 512
  end
  object OpenDialog: TOpenDialog
    Left = 120
    Top = 536
  end
  object SaveDialog: TSaveDialog
    Left = 168
    Top = 536
  end
end
