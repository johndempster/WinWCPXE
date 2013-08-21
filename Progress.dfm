object ProgressFrm: TProgressFrm
  Left = 334
  Top = 245
  BorderStyle = bsToolWindow
  Caption = 'Progress'
  ClientHeight = 101
  ClientWidth = 185
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bStop: TButton
    Left = 132
    Top = 80
    Width = 49
    Height = 17
    Caption = 'Stop'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = bStopClick
  end
  object prBar: TProgressBar
    Left = 4
    Top = 80
    Width = 121
    Height = 17
    TabOrder = 1
  end
  object reInfo: TRichEdit
    Left = 4
    Top = 8
    Width = 176
    Height = 65
    TabOrder = 2
  end
end
