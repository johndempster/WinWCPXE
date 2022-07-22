unit Log;
{ ====================================================
  WinWCP - Display log file text (c) J. Dempster 1996
  ====================================================
  5/12/01 ... Log text can now be copied to clipboard }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls ;

type
  TLogFrm = class(TForm)
    mmText: TMemo;
    AddGrp: TGroupBox;
    meAdd: TMemo;
    bAddNote: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure bAddNoteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CopyToClipboard ;
  end;

var
  LogFrm: TLogFrm;

implementation

{$R *.DFM}
uses MdiForm , WCPFIleUnit;


procedure TLogFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     { Enable "Inspect Log File" option of "File" menu}
     Action := caFree ;
     end;

procedure TLogFrm.FormActivate(Sender: TObject);
begin
     Caption := 'Log File ' + WCPFile.LogFileName ;
     WCPFile.CloseLogFile ;
     mmText.Lines.LoadFromFile( WCPFile.LogFileName ) ;
     WCPFile.OpenLogFile ;
     end;


procedure TLogFrm.FormDeactivate(Sender: TObject);
begin
     WCPFile.CloseLogFile ;
     mmText.Lines.SaveToFile( WCPFile.LogFileName ) ;
     WCPFile.OpenLogFile ;
     end;


procedure TLogFrm.FormCreate(Sender: TObject);
begin
     { Disable "Inspect Log File" option of "File" menu}
     Resize ;
     end;

procedure TLogFrm.FormResize(Sender: TObject);
// -------------------------------------
// Update controls on form after re-size
// -------------------------------------
begin
     mmText.Width := ClientWidth - 2*mmText.Left ;
     mmText.Height := ClientHeight - 2*mmText.Top ;

     mmText.Height := AddGrp.Top - mmText.Top - 2 ;
     AddGrp.Top := ClientHeight - AddGrp.Height - 5 ;
     AddGrp.Width := mmText.Width ;
     meAdd.Width := AddGrp.ClientWidth - meAdd.Left - 5 ;

     end;


procedure TLogFrm.CopyToClipboard ;
//
// Copy selected log text to clipboard
//
begin
     mmText.CopyToClipboard ;
     end ;


procedure TLogFrm.bAddNoteClick(Sender: TObject);
// ---------------
// Add note to log
// ---------------
var
    i : Integer ;
begin

    // Add note to log file
    for i := 0 to meAdd.Lines.Count-1 do WCPFile.WriteToLogFile( meAdd.Lines[i] ) ;

    // CLear note
    meAdd.Lines.Clear ;

    // Update log file display
    WCPFile.CloseLogFile ;
    mmText.Lines.LoadFromFile( WCPFile.LogFileName ) ;
    WCPFile.OpenLogFile ;

    end;

procedure TLogFrm.FormShow(Sender: TObject);
//
// Initialisations when form is first displayed
//
begin
     Resize ;
     end;

end.
