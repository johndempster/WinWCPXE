object DirectorySelectFrm: TDirectorySelectFrm
  Left = 933
  Top = 168
  BorderStyle = bsDialog
  Caption = 'Select Folder'
  ClientHeight = 339
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object DriveComboBox: TDriveComboBox
    Left = 8
    Top = 8
    Width = 297
    Height = 21
    TabOrder = 0
    OnChange = DriveComboBoxChange
  end
  object bSelectFolder: TButton
    Left = 8
    Top = 312
    Width = 97
    Height = 17
    Caption = 'Select Folder'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = bSelectFolderClick
  end
  object DirectoryListBox: TDirectoryListBox
    Left = 8
    Top = 32
    Width = 297
    Height = 273
    ItemHeight = 16
    TabOrder = 2
  end
end
