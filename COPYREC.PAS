unit Copyrec;
{ ========================================================
  WinWCP - Setup form for copying image of  signal records
  (called by REPLAY module)
  2/5/97 ... Calibration bar values only shown for enabled channels
  1/2/98 ... Font size and line width now text boxes
  ========================================================}
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Spin, Grids, sysutils, maths;

type
  TCopyRecDlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edWidth: TEdit;
    edHeight: TEdit;
    GroupBox2: TGroupBox;
    CalibrationBarTable: TStringGrid;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    GroupBox4: TGroupBox;
    FontLab: TLabel;
    Label6: TLabel;
    cbFonts: TComboBox;
    GroupBox5: TGroupBox;
    ckShowZeroLevels: TCheckBox;
    ckShowLabels: TCheckBox;
    bOK: TButton;
    bCancel: TButton;
    ckUseColors: TCheckBox;
    EdPointSize: TEdit;
    EdLineThickness: TEdit;
    bDefaultSettings: TButton;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure EdPointSizeKeyPress(Sender: TObject; var Key: Char);
    procedure edWidthKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CopyRecDlg: TCopyRecDlg;

implementation

{$R *.DFM}

uses WCPFIleUnit;

procedure TCopyRecDlg.FormShow(Sender: TObject);
{ -------------------------------
  Initialise Copy Record(s) form
  -------------------------------}
var
   ch,n,Row : Integer ;
begin
     { Fill Fonts list with typefaces available to printer }
     cbFonts.items := screen.fonts ;
     cbFonts.itemindex := cbFonts.items.indexof(WCPFile.Settings.Plot.FontName) ;
     if cbFonts.itemindex < 0 then  cbFonts.itemindex := 0 ;
     edPointSize.text := format( ' %d pts ', [WCPFile.Settings.Plot.FontSize]) ;

     edWidth.text := format( ' %d pixels', [WCPFile.Settings.BitmapWidth] ) ;
     edHeight.text := format( ' %d pixels', [WCPFile.Settings.BitmapHeight] ) ;

     ckShowLabels.checked := WCPFile.Settings.ShowLabels ;
     ckShowZeroLevels.checked := WCPFile.Settings.ShowZeroLevels ;
     ckUseColors.checked := WCPFile.Settings.Plot.UseColor ;

     { Fill calibration bar table }

     { Set Column widths }
     CalibrationBarTable.colwidths[0] := Canvas.TextWidth('XXXXX') ;
     CalibrationBarTable.colwidths[1] := Canvas.TextWidth('XXXXXXXXX') ;

     CalibrationBarTable.options := [goEditing,goHorzLine,goVertLine] ;
     CalibrationBarTable.RowCount := WCPFile.fH.NumChannels + 1 ;
     CalibrationBarTable.cells[0,0] := 'Time ';

     CalibrationBarTable.cells[1,0] := Format( ' %.1f %s',
                                       [WCPFile.Settings.TimeBarValue*WCPFile.Settings.TScale,
                                        WCPFile.Settings.TUnits]);

    { Adjust number of rows to number of enabled channels }
      n := 1 ;
      for ch := 0 to WCPFile.fH.NumChannels-1 do if WCPFile.Channel[ch].InUse then Inc(n) ;
      CalibrationBarTable.RowCount := n ;
     { Fill table with calibration bar data }
     Row := 1 ;
     for ch := 0 to WCPFile.fH.NumChannels-1 do if WCPFile.Channel[ch].InUse then begin
         CalibrationBarTable.cells[0,Row] := WCPFile.Channel[ch].ADCName ;
         CalibrationBarTable.cells[1,Row] := Format( '%.1f %s',
                                              [WCPFile.Settings.BarValue[ch],
                                               WCPFile.Channel[ch].ADCUnits]) ;
         Inc(Row) ;
         end ;

     CalibrationBarTable.SetFocus ;

     end;

procedure TCopyRecDlg.bOKClick(Sender: TObject);
{ -----------------------
  Update global settings
  ----------------------}
var
   Row,ch : Integer ;

begin
     { Set printer typeface and size }
     WCPFile.Settings.BitmapWidth := IntLimitTo( ExtractInt(edWidth.text),
                                         BitmapsMinSize, BitmapsMaxSize );
     WCPFile.Settings.BitmapHeight := IntLimitTo( ExtractInt(edHeight.text),
                                          BitmapsMinSize, BitmapsMaxSize );

     WCPFile.Settings.Plot.LineThickness := ExtractInt( edLineThickness.text )  ;

     WCPFile.Settings.Plot.FontName := cbFonts.text ;
     WCPFile.Settings.Plot.FontSize := ExtractInt( edPointSize.text ) ;

     WCPFile.Settings.ShowLabels := ckShowLabels.checked ;
     WCPFile.Settings.ShowZeroLevels := ckShowZeroLevels.checked ;
     WCPFile.Settings.Plot.UseColor := ckUseColors.checked  ;

     { Set calibration bars }
      WCPFile.Settings.TimeBarValue := ExtractFloat(CalibrationBarTable.cells[1,0], 1. )
                              * WCPFile.Settings.TUnscale ;
     Row := 1 ;
     for ch := 0 to WCPFile.fH.NumChannels-1 do if WCPFile.Channel[ch].InUse then begin
         WCPFile.Settings.BarValue[ch] := ExtractFloat(CalibrationBarTable.Cells[1,Row],10. ) ;
         Inc(Row) ;
         end ;

     end ;


procedure TCopyRecDlg.EdPointSizeKeyPress(Sender: TObject; var Key: Char);
{ ----------------
  Check font size
  ---------------}
begin
     if key = chr(13) then TEdit(Sender).text := format( ' %d pts',
                           [IntLimitTo(ExtractInt(TEdit(Sender).text),1,64)] ) ;
     end;

procedure TCopyRecDlg.edWidthKeyPress(Sender: TObject; var Key: Char);
{ ----------------
  Check image size
  ---------------}
begin
     if key = chr(13) then TEdit(Sender).text := format( ' %d pixels',
                           [IntLimitTo(ExtractInt(TEdit(Sender).text),100,10000)] ) ;
     end;

end.
