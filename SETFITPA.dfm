object SetFitParsFrm: TSetFitParsFrm
  Left = 417
  Top = 164
  BorderStyle = bsDialog
  Caption = 'Set Fitting Parameters'
  ClientHeight = 219
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object ParametersGrp: TGroupBox
    Left = 2
    Top = 0
    Width = 327
    Height = 161
    Hint = 
      'Initial parameter values to start curve fitting.  Fixed paramete' +
      'rs are held constant during curve fitting.'
    Caption = ' Parameters '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object Label2: TLabel
      Left = 112
      Top = 16
      Width = 29
      Height = 15
      Caption = 'Fixed'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 288
      Top = 16
      Width = 29
      Height = 15
      Caption = 'Fixed'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object ckFixed0: TCheckBox
      Left = 126
      Top = 32
      Width = 25
      Height = 17
      Hint = 'Keep parameter fixed at initial value during fitting'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object ckFixed1: TCheckBox
      Left = 126
      Top = 56
      Width = 25
      Height = 17
      Hint = 'Keep parameter fixed at initial value during fitting'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
    end
    object ckFixed2: TCheckBox
      Left = 126
      Top = 80
      Width = 25
      Height = 17
      Hint = 'Keep parameter fixed at initial value during fitting'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
    end
    object ckFixed3: TCheckBox
      Left = 126
      Top = 104
      Width = 25
      Height = 17
      Hint = 'Keep parameter fixed at initial value during fitting'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 3
    end
    object ckFixed4: TCheckBox
      Left = 126
      Top = 128
      Width = 17
      Height = 17
      Hint = 'Keep parameter fixed at initial value during fitting'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 4
    end
    object ckFixed5: TCheckBox
      Left = 288
      Top = 32
      Width = 17
      Height = 17
      Hint = 'Keep parameter fixed at initial value during fitting'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 5
    end
    object ckFixed6: TCheckBox
      Left = 288
      Top = 56
      Width = 17
      Height = 17
      Hint = 'Keep parameter fixed at initial value during fitting'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 6
    end
    object ckFixed7: TCheckBox
      Left = 288
      Top = 80
      Width = 17
      Height = 17
      ParentShowHint = False
      ShowHint = False
      TabOrder = 7
    end
    object edPar0: TValidatedEdit
      Left = 40
      Top = 32
      Width = 85
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edPar1: TValidatedEdit
      Left = 40
      Top = 56
      Width = 85
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edPar2: TValidatedEdit
      Left = 40
      Top = 80
      Width = 85
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edPar3: TValidatedEdit
      Left = 40
      Top = 104
      Width = 85
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edPar4: TValidatedEdit
      Left = 40
      Top = 128
      Width = 85
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edPar5: TValidatedEdit
      Left = 200
      Top = 32
      Width = 85
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edPar6: TValidatedEdit
      Left = 200
      Top = 56
      Width = 85
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object edPar7: TValidatedEdit
      Left = 200
      Top = 80
      Width = 85
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object erPar0: TRichEdit
      Left = 4
      Top = 32
      Width = 33
      Height = 17
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clInactiveBorder
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'par0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 16
      Zoom = 100
    end
    object erPar1: TRichEdit
      Left = 4
      Top = 56
      Width = 33
      Height = 17
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clInactiveBorder
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'par0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 17
      Zoom = 100
    end
    object erpar2: TRichEdit
      Left = 4
      Top = 80
      Width = 33
      Height = 17
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clInactiveBorder
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'par0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 18
      Zoom = 100
    end
    object erpar3: TRichEdit
      Left = 4
      Top = 104
      Width = 33
      Height = 17
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clInactiveBorder
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'par0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 19
      Zoom = 100
    end
    object erpar4: TRichEdit
      Left = 4
      Top = 128
      Width = 33
      Height = 17
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clInactiveBorder
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'par0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 20
      Zoom = 100
    end
    object erpar5: TRichEdit
      Left = 160
      Top = 32
      Width = 33
      Height = 17
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clInactiveBorder
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'par0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 21
      Zoom = 100
    end
    object erpar6: TRichEdit
      Left = 160
      Top = 56
      Width = 33
      Height = 17
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clInactiveBorder
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'par0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 22
      Zoom = 100
    end
    object erpar7: TRichEdit
      Left = 160
      Top = 80
      Width = 33
      Height = 17
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clInactiveBorder
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'par0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 23
      Zoom = 100
    end
    object erpar8: TRichEdit
      Left = 160
      Top = 104
      Width = 33
      Height = 17
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clInactiveBorder
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'par0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 24
      Zoom = 100
    end
    object edpar8: TValidatedEdit
      Left = 200
      Top = 104
      Width = 85
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object ckfixed8: TCheckBox
      Left = 288
      Top = 104
      Width = 17
      Height = 17
      Caption = 'ckfixed8'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 26
    end
    object erpar9: TRichEdit
      Left = 160
      Top = 128
      Width = 33
      Height = 17
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clInactiveBorder
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'par0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 27
      Zoom = 100
    end
    object edpar9: TValidatedEdit
      Left = 200
      Top = 128
      Width = 85
      Height = 20
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Text = ' 0 '
      Scale = 1.000000000000000000
      NumberFormat = '%.3g'
      LoLimit = -1.000000015047466E30
      HiLimit = 1.000000015047466E30
    end
    object ckfixed9: TCheckBox
      Left = 288
      Top = 128
      Width = 17
      Height = 17
      Caption = 'ckfixed8'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 29
    end
  end
  object bOK: TButton
    Left = 8
    Top = 168
    Width = 57
    Height = 20
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 8
    Top = 192
    Width = 49
    Height = 17
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
    OnClick = bCancelClick
  end
  object GroupBox1: TGroupBox
    Left = 184
    Top = 160
    Width = 145
    Height = 57
    Caption = ' Parameter Initialisation  '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object rbAutomaticGuess: TRadioButton
      Left = 16
      Top = 16
      Width = 81
      Height = 17
      Caption = 'Automatic'
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
    object rbManual: TRadioButton
      Left = 16
      Top = 32
      Width = 65
      Height = 17
      Caption = 'Manual'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object bInitialise: TButton
      Left = 80
      Top = 34
      Width = 57
      Height = 17
      Caption = 'Initialise'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = bInitialiseClick
    end
  end
end
