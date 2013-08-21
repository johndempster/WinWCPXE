unit DirectorySelectUnit;
// ======================================
// Display drive/directory selection tree
// ======================================
// 14.10.11 Error when initial directory does not exist fixed

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, Grids, Outline, DirOutln, strutils ;

type
  TDirectorySelectFrm = class(TForm)
    DriveComboBox: TDriveComboBox;
    bSelectFolder: TButton;
    DirectoryListBox: TDirectoryListBox;
    procedure DriveComboBoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bSelectFolderClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Directory : String ;
  end;

var
  DirectorySelectFrm: TDirectorySelectFrm;

implementation

{$R *.dfm}

procedure TDirectorySelectFrm.DriveComboBoxChange(Sender: TObject);
begin
     DirectoryListBox.Drive := DriveComboBox.Drive ;
     end;

procedure TDirectorySelectFrm.FormShow(Sender: TObject);
// -----------------------------------
// Initialisations when form displayed
// -----------------------------------
var
    Drive : String ;
begin

    if DirectoryExists(Directory) then begin
       Drive := ExtractFileDrive(Directory) ;
       DriveComboBox.Drive := Drive[1] ;
       DirectoryListBox.Drive := Drive[1] ;
       DirectoryListBox.Directory := Directory ;
       end
    else ShowMessage('Folder ' + Directory + ' does not exist!') ;

    end;


procedure TDirectorySelectFrm.bSelectFolderClick(Sender: TObject);
begin
     Directory := DirectoryListBox.Directory + '\' ;
     end;

end.
