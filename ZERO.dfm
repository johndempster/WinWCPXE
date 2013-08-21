object ZeroFrm: TZeroFrm
  Left = 623
  Top = 156
  BorderStyle = bsDialog
  Caption = 'Zero Level'
  ClientHeight = 202
  ClientWidth = 151
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object TypeGrp: TGroupBox
    Left = 8
    Top = 32
    Width = 137
    Height = 137
    Caption = 'Zero level modes'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 40
      Width = 48
      Height = 14
      Caption = 'At sample'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 24
      Top = 64
      Width = 46
      Height = 14
      Caption = 'No. avgd.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 48
      Top = 104
      Width = 26
      Height = 14
      Caption = 'Level'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object rbFromRecord: TRadioButton
      Left = 8
      Top = 24
      Width = 97
      Height = 17
      Hint = 
        'Calculate signal zero level for each record from a defined regio' +
        'n of the record'
      Caption = 'From Record'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = rbFromRecordClick
    end
    object rbFixed: TRadioButton
      Left = 8
      Top = 88
      Width = 89
      Height = 17
      Hint = 'Zero level fixed at a constant level for all records'
      Caption = 'Fixed Level'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = rbFixedClick
    end
    object edNumAveraged: TValidatedEdit
      Left = 80
      Top = 64
      Width = 49
      Height = 23
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
    end
    object edAtSample: TValidatedEdit
      Left = 80
      Top = 40
      Width = 49
      Height = 23
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
    end
    object edFixedLevel: TValidatedEdit
      Left = 80
      Top = 104
      Width = 49
      Height = 23
      Text = ' 1 '
      Value = 1.000000000000000000
      Scale = 1.000000000000000000
      NumberFormat = '%.0f'
      LoLimit = 1.000000000000000000
      HiLimit = 1.000000015047466E30
    end
  end
  object edChannel: TEdit
    Left = 8
    Top = 8
    Width = 137
    Height = 23
    ReadOnly = True
    TabOrder = 1
    Text = 'edChannel'
  end
  object bOK: TButton
    Left = 8
    Top = 176
    Width = 49
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
    Top = 176
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
    TabOrder = 3
  end
end
