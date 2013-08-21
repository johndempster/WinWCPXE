object FilePropsDlg: TFilePropsDlg
  Left = 448
  Top = 240
  BorderStyle = bsDialog
  Caption = 'File Properties'
  ClientHeight = 443
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bCancel: TButton
    Left = 64
    Top = 414
    Width = 45
    Height = 16
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 0
    OnClick = bCancelClick
  end
  object bOK: TButton
    Left = 8
    Top = 414
    Width = 49
    Height = 25
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = bOKClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 297
    Height = 393
    ActivePage = TabProperties
    TabOrder = 2
    object TabProperties: TTabSheet
      Caption = 'Properties'
      object meProperties: TMemo
        Left = 8
        Top = 8
        Width = 273
        Height = 353
        Lines.Strings = (
          'meProperties')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabCalTable: TTabSheet
      Caption = 'Calibration Table'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ChannelTable: TStringGrid
        Left = 8
        Top = 8
        Width = 217
        Height = 353
        Hint = 'Input channel scaling factors and calibration units'
        ColCount = 4
        DefaultColWidth = 50
        DefaultRowHeight = 18
        RowCount = 9
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 0
        ColWidths = (
          50
          50
          50
          50)
        RowHeights = (
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
    end
    object TabFileHeader: TTabSheet
      Caption = 'File Header'
      ImageIndex = 2
      object meFileHeader: TMemo
        Left = 8
        Top = 8
        Width = 273
        Height = 353
        Lines.Strings = (
          'meProperties')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
end
