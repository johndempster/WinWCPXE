object LogFrm: TLogFrm
  Left = 497
  Top = 135
  Caption = 'Log '
  ClientHeight = 399
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object mmText: TMemo
    Left = 8
    Top = 8
    Width = 465
    Height = 289
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'mmText')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object AddGrp: TGroupBox
    Left = 8
    Top = 296
    Width = 465
    Height = 97
    Caption = ' Add Note '
    TabOrder = 1
    object meAdd: TMemo
      Left = 4
      Top = 16
      Width = 453
      Height = 50
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '')
      ParentFont = False
      TabOrder = 0
    end
    object bAddNote: TButton
      Left = 8
      Top = 72
      Width = 57
      Height = 17
      Caption = 'Add'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bAddNoteClick
    end
  end
end
