unit PrintTableUnit;
// --------------------------------------
// Print data stored in string grid table
// --------------------------------------
// 8.05.09 Created

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ValidatedEdit, grids, global, printers ;

type
  TPrintTableFrm = class(TForm)
    FontGrp: TGroupBox;
    Label7: TLabel;
    cbFontName: TComboBox;
    edFontSize: TValidatedEdit;
    PrinterGrp: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edLeftMargin: TValidatedEdit;
    edBottomMargin: TValidatedEdit;
    edTopMargin: TValidatedEdit;
    bOK: TButton;
    bCancel: TButton;
    GroupBox1: TGroupBox;
    edPrinterName: TEdit;
    bPrinterSetup: TButton;
    PrinterSetupDialog: TPrinterSetupDialog;
    procedure bOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bPrinterSetupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function GetCurrentPrinterName : string ;
  public
    { Public declarations }
    Table : TStringGrid ;
    Title : String ;
  end;

var
  PrintTableFrm: TPrintTableFrm;

implementation

{$R *.dfm}



procedure TPrintTableFrm.FormShow(Sender: TObject);
{ --------------------------------------------
  Initialise edit boxes when form is displayed
  -------------------------------------------- }
begin

     // Display selected printer
     edPrinterName.Text := GetCurrentPrinterName ;

     // Margins
     edTopMargin.Value := Settings.Plot.TopMargin ;
     edBottomMargin.Value := Settings.Plot.BottomMargin ;
     edLeftMargin.Value := Settings.Plot.LeftMargin ;

     { Fill Fonts list with typefaces available to printer }
     cbFontName.items := printer.fonts ;
     edFontSize.Value := Settings.Plot.FontSize ;
     cbFontName.itemindex := cbFontName.items.indexof(Settings.Plot.FontName) ;
     if cbFontName.itemindex < 0 then  cbFontName.itemindex := 0 ;

     end;


procedure TPrintTableFrm.bOKClick(Sender: TObject);
{ -----------------------------------------------
  Print the contents of a string grid spreadsheet
  -----------------------------------------------}
var
   CharWidth,CharHeight,ColHeight,Row,Col,w : Integer ;
   PageLeft,PageTop,PageBottom,Line,ColLeft,PageNum,LastPage : Integer ;
   ColWidth : Array[0..20] of Integer ;
   mmToPixels : Single ;
begin

     if Table = Nil then Exit ;

     Screen.Cursor := crHourglass ;

     Settings.Plot.TopMargin := edTopMargin.Value ;
     Settings.Plot.BottomMargin := edBottomMargin.Value ;
     Settings.Plot.LeftMargin:= edLeftMargin.Value  ;
     Settings.Plot.FontName := cbFontName.text ;
     Settings.Plot.FontSize := Round(edFontSize.Value) ;

     Printer.BeginDoc ;

     { Set print font and size }
     Printer.Canvas.Font.Name := Settings.Plot.FontName ;
     Printer.Canvas.font.Size := Settings.Plot.FontSize ;

     mmToPixels := Printer.Canvas.Font.PixelsPerInch/25.4 ;

     CharWidth := Printer.canvas.TextWidth('X') ;
     CharHeight := Printer.canvas.TextHeight('X') ;
     PageTop := Round(Settings.Plot.TopMargin*mmToPixels) ;
     PageBottom := printer.PageHeight - Round(Settings.Plot.BottomMargin*mmToPixels) ;
     PageLeft := Round(Settings.Plot.LeftMargin*mmToPixels) ;

     { Calculate column widths of table}
     for col := 0 to Table.ColCount-1 do begin
         ColWidth[Col] := 0 ;
         for row := 0 to Table.RowCount-1 do begin
             w := Printer.canvas.TextWidth(Table.cells[Col,Row]) ;
             if ColWidth[Col] < w then ColWidth[Col] := w ;
             end ;
         end ;
     for col := 0 to Table.ColCount-1 do ColWidth[Col] := ColWidth[Col] +
                                           2*CharWidth ;

     ColHeight := (12*Printer.canvas.TextHeight(Table.cells[0,0])) div 10 ;

     { Calculate number of pages to be printed }
     LastPage := 0 ;
     PageNum := 1 ;
     for row := 0 to Table.RowCount-1 do begin
         if LastPage <> PageNum then begin
            Line := PageTop + ColHeight*3 ;
            LastPage := PageNum ;
            end ;
         Line := Line + ColHeight ;
         if Line > PageBottom then Inc(PageNum) ;
         end ;

     { Print table
       ===========}

     PageNum := -1 ;
     for row := 0 to Table.RowCount-1 do begin
         {Print header lines on each new page }
         if Printer.PageNumber <> PageNum then begin
            PageNum := Printer.PageNumber ;
            Line := PageTop ;

            printer.canvas.textout( PageLeft,Line,
                                    format('%s Printed %s. Page %d/%d. ',
                                    [Title,DateTimeToStr(Now),PageNum,LastPage])) ;
            Line := Line + ColHeight ;

            printer.canvas.textout(PageLeft,Line,
                                      'File ... ' + fH.FileName) ;
            Line := Line + ColHeight ;

            printer.canvas.textout(PageLeft,Line,
                                      'Created: ' + fH.CreationTime) ;
            Line := Line + ColHeight ;

            printer.canvas.textout(PageLeft,Line, fH.IdentLine) ;
            Line := Line + ColHeight*2 ;
            end ;

         { Print row }
         ColLeft := PageLeft ;
         Printer.Canvas.Pen.Width := 1 ;
         for col := 0 to Table.ColCount-1 do begin
             printer.canvas.textout( ColLeft + CharWidth,
                                     Line + CharHeight div 10,
                                     Table.cells[Col,Row] ) ;
             ColLeft := ColLeft + ColWidth[Col] ;
             end ;

         { New page when line crosses bottom margin }
         Line := Line + ColHeight ;
         if Line > PageBottom then Printer.NewPage ;

         end ;

     Printer.EndDoc ;

     Screen.Cursor := crDefault ;

     end ;



procedure TPrintTableFrm.bPrinterSetupClick(Sender: TObject);
// -----------------------------
// Select printer / change setup
// -----------------------------
begin
     PrinterSetupDialog.Execute ;
     edPrinterName.Text := GetCurrentPrinterName ;
     end ;

procedure TPrintTableFrm.FormCreate(Sender: TObject);
// --------------------------------
// Initialisarion when form created
// --------------------------------
begin
     Table := Nil ;
     end;


function TPrintTableFrm.GetCurrentPrinterName : string ;
// --------------------------------------
// Get name of current default printer
// --------------------------------------
const
    MaxSize = 256 ;
var
   DeviceName,DeviceDriver,Port : PChar ;
   DeviceMode : THandle ;
begin
        GetMem( DeviceName, MaxSize*SizeOf(Char) ) ;
        GetMem( DeviceDriver, MaxSize*SizeOf(Char) ) ;
        GetMem( Port, MaxSize*SizeOf(Char) ) ;
        {$IF CompilerVersion > 7.0}
        Printer.GetPrinter( DeviceName, DeviceDriver,Port,DeviceMode );
        {$ELSE}
        Printer.GetPrinter( DeviceName, DeviceDriver,Port, DeviceMode );
        {$IFEND}

        Result := String(DeviceName) ;
        FreeMem(DeviceName) ;
        FreeMem(DeviceDriver) ;
        FreeMem(Port) ;
        end ;



end.
