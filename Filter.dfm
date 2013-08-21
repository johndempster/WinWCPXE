object FilterFrm: TFilterFrm
  Left = 292
  Top = 168
  BorderStyle = bsDialog
  Caption = 'Filter Records'
  ClientHeight = 259
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object GroupBox3: TGroupBox
    Left = 4
    Top = 4
    Width = 149
    Height = 245
    Caption = ' Match criteria '
    TabOrder = 0
    object rbAllRecords: TRadioButton
      Left = 16
      Top = 16
      Width = 81
      Height = 17
      Caption = 'All Records'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = rbAllRecordsClick
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 38
      Width = 134
      Height = 195
      TabOrder = 1
      object lbChannels: TLabel
        Left = 20
        Top = 58
        Width = 18
        Height = 14
        Caption = 'Ch.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 16
        Top = 87
        Width = 26
        Height = 14
        Caption = 'Type'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object rbVariable: TRadioButton
        Left = 8
        Top = 8
        Width = 73
        Height = 17
        Caption = 'Variable'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnClick = rbVariableClick
      end
      object cbVariables: TComboBox
        Left = 24
        Top = 26
        Width = 100
        Height = 23
        TabOrder = 1
        Text = 'cbVariables'
      end
      object cbChannels: TComboBox
        Left = 48
        Top = 58
        Width = 76
        Height = 23
        TabOrder = 2
        Text = 'cbVariables'
      end
      object cbMatchType: TComboBox
        Left = 48
        Top = 87
        Width = 76
        Height = 23
        TabOrder = 3
        Text = 'cbVariables'
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 116
        Width = 116
        Height = 73
        Caption = ' Var. Limits '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object Label1: TLabel
          Left = 8
          Top = 45
          Width = 16
          Height = 16
          Caption = '<='
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label2: TLabel
          Left = 8
          Top = 21
          Width = 16
          Height = 16
          Caption = '>='
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edUpperLimit: TValidatedEdit
          Left = 32
          Top = 45
          Width = 78
          Height = 20
          AutoSize = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Text = ' 0 '
          Scale = 1.000000000000000000
          NumberFormat = '%g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
        object edLowerLimit: TValidatedEdit
          Left = 32
          Top = 21
          Width = 78
          Height = 20
          AutoSize = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Text = ' 0 '
          Scale = 1.000000000000000000
          NumberFormat = '%g'
          LoLimit = -1.000000015047466E30
          HiLimit = 1.000000015047466E30
        end
      end
    end
  end
  object bApply: TButton
    Left = 159
    Top = 136
    Width = 65
    Height = 20
    Caption = 'Apply'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = bApplyClick
  end
  object bCancel: TButton
    Left = 159
    Top = 162
    Width = 57
    Height = 17
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
  end
  object GroupBox5: TGroupBox
    Left = 159
    Top = 4
    Width = 135
    Height = 125
    Caption = ' Action on match '
    TabOrder = 3
    object GroupBox2: TGroupBox
      Left = 8
      Top = 12
      Width = 113
      Height = 53
      Caption = 'Set record status '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object rbAccepted: TRadioButton
        Left = 30
        Top = 16
        Width = 73
        Height = 17
        Caption = 'Accepted'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object rbRejected: TRadioButton
        Left = 30
        Top = 32
        Width = 73
        Height = 17
        Caption = 'Rejected'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object ckSetRecordStatus: TCheckBox
        Left = 8
        Top = 12
        Width = 17
        Height = 17
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = ckSetRecordStatusClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 68
      Width = 113
      Height = 45
      Caption = ' Set record type '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object cbRecordType: TComboBox
        Left = 30
        Top = 15
        Width = 73
        Height = 22
        TabOrder = 0
        Text = 'cbVariables'
      end
      object ckSetRecordType: TCheckBox
        Left = 8
        Top = 12
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = ckSetRecordTypeClick
      end
    end
  end
end
