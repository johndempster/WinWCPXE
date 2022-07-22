unit PrintRec;
{ =================================================================
  WinEDR - Printer page/font setup form for printing signal records
  2/5/97 ... Calibration bar values only shown for enabled channels
  26/6/98 ... Text boxes updates now grouped together in UpdateSettings
  30/8/99 ... Display object (Scope or Chart) now updated by PrintRec
  12/2/04 ... Only TScopeDisplay objects now supported
  19/5/05 ... Width of label area in calibration table increased
  =================================================================}
// 11.05.09 Printer can now be selected
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,Printers, Grids, SysUtils, Spin,
  ValEdit,  ScopeDisplay, ValidatedEdit, Dialogs ;

type
  TDestination = (dePrinter,deClipboard) ;
  TPrintRecFrm = class(TForm)
    GroupBox2: TGroupBox;
    CalibrationBarTable: TStringGrid;
    GroupBox5: TGroupBox;
    ckShowZeroLevels: TCheckBox;
    ckShowLabels: TCheckBox;
    bPrint: TButton;
    bCancel: TButton;
    ckUseColor: TCheckBox;
    FontGrp: TGroupBox;
    Label7: TLabel;
    cbFontName: TComboBox;
    Page: TNotebook;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    Label8: TLabel;
    edWidth: TValidatedEdit;
    edHeight: TValidatedEdit;
    edLeftMargin: TValidatedEdit;
    edTopMargin: TValidatedEdit;
    edRightMargin: TValidatedEdit;
    edBottomMargin: TValidatedEdit;
    edFontSize: TValidatedEdit;
    Label5: TLabel;
    edLineThickness: TValidatedEdit;
    bDefaultSettings: TButton;
    PrinterSelectGrp: TGroupBox;
    edPrinterName: TEdit;
    bPrinterSetup: TButton;
    PrinterSetupDialog: TPrinterSetupDialog;
    procedure bPrintClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CalibrationBarTableKeyPress(Sender: TObject; var Key: Char);
    procedure bDefaultSettingsClick(Sender: TObject);
    procedure bPrinterSetupClick(Sender: TObject);
  private
    { Private declarations }
    function GetCurrentPrinterName : string ;
  public
    { Public declarations }

    Destination : TDestination ;
    DisplayObj : TScopeDisplay ;
  end;



var
  PrintRecFrm: TPrintRecFrm;

implementation

{$R *.DFM}
uses MDIform, maths , WCPFIleUnit;

procedure TPrintRecFrm.FormShow(Sender: TObject);
{ --------------------------------
  Initialise Print Record(s) form
  -------------------------------}
var
   n,ch,Row : Integer ;
begin

     // Display selected printer
     edPrinterName.Text := GetCurrentPrinterName ;

     { Select appropriate settings page }
     if Destination = dePrinter then begin
        Caption := ' Print ' ;
        Page.PageIndex := 0 ;
        edFontSize.Units := 'pts' ;
        edLineThickness.Units := 'pts' ;
        PrinterSelectGrp.Visible := True ;
        end
     else begin
        Caption := ' Copy Image ' ;
        Page.PageIndex := 1 ;
        edFontSize.Units := 'pixels' ;
        edLineThickness.Units := 'pixels' ;
        PrinterSelectGrp.Visible := False ;
        end ;


     { Fill Fonts list with typefaces available to printer }
     cbFontName.items := printer.fonts ;

     { Set Column widths }
     CalibrationBarTable.colwidths[0] := Canvas.TextWidth('XXXXXXX') ;
     CalibrationBarTable.colwidths[1] := Canvas.TextWidth('XXXXXXXXX') ;

     CalibrationBarTable.options := [goEditing,goHorzLine,goVertLine] ;
     CalibrationBarTable.RowCount := WCPFile.fH.NumChannels + 1 ;
     CalibrationBarTable.cells[0,0] := 'Time ';

     { Adjust number of rows to number of enabled channels }
      n := 1 ;
      for ch := 0 to WCPFile.fH.NumChannels-1 do if WCPFile.Channel[ch].InUse then Inc(n) ;
      CalibrationBarTable.RowCount := n ;

      { Update text box settings }
      edLeftMargin.Value := WCPFile.Settings.Plot.LeftMargin ;
      edRightMargin.Value := WCPFile.Settings.Plot.RightMargin ;
      edTopMargin.Value := WCPFile.Settings.Plot.TopMargin ;
      edBottomMargin.Value := WCPFile.Settings.Plot.BottomMargin ;
      edWidth.Value := WCPFile.Settings.Plot.MetafileWidth ;
      edHeight.Value := WCPFile.Settings.Plot.MetafileHeight ;
      edFontSize.Value := WCPFile.Settings.Plot.FontSize ;
      edLineThickness.Value := WCPFile.Settings.Plot.LineThickness ;
      cbFontName.itemindex := cbFontName.items.indexof(WCPFile.Settings.Plot.FontName) ;
      if cbFontName.itemindex < 0 then  cbFontName.itemindex := 0 ;
      ckShowLabels.checked := WCPFile.Settings.ShowLabels ;
      ckShowZeroLevels.checked := WCPFile.Settings.ShowZeroLevels ;
      ckUseColor.checked := WCPFile.Settings.Plot.UseColor ;

      if WCPFile.Settings.TimeBarValue <= 0.0 then begin
        WCPFile.Settings.TimeBarValue := (DisplayObj.xMax -
                                 DisplayObj.xMin)*
                                 DisplayObj.TScale*0.1 ;
        end ;

      CalibrationBarTable.cells[1,0] := Format( '%.4g %s',
                                       [WCPFile.Settings.TimeBarValue,
                                        WCPFile.Settings.TUnits])  ;

      { Channel calibration bars }
      Row := 1 ;
      for ch := 0 to WCPFile.fH.NumChannels-1 do if WCPFile.Channel[ch].InUse then begin
         if WCPFile.Channel[ch].ADCCalibrationValue = 0.0 then
            WCPFile.Channel[ch].ADCCalibrationValue := (WCPFile.Channel[ch].yMax - WCPFile.Channel[ch].yMin)
                                             *WCPFile.Channel[ch].ADCScale*0.1 ;
         CalibrationBarTable.cells[0,Row] := WCPFile.Channel[ch].ADCName ;
         CalibrationBarTable.cells[1,Row] := Format( '%.4g %s',
                                              [WCPFile.Settings.BarValue[ch],
                                               WCPFile.Channel[ch].ADCUnits]) ;
         Inc(Row) ;
         end ;

      { Ensure calibration bars have focus when dialog box opens }
      CalibrationBarTable.SetFocus ;

     end;


procedure TPrintRecFrm.bPrintClick(Sender: TObject);
{ -----------------------
  Update global settings
  ----------------------}
var
   row,ch : Integer ;
begin

      { Update settings from text boxes }
      WCPFile.Settings.Plot.LeftMargin := edLeftMargin.Value ;
      WCPFile.Settings.Plot.RightMargin := edRightMargin.Value ;
      WCPFile.Settings.Plot.TopMargin := edTopMargin.Value ;
      WCPFile.Settings.Plot.BottomMargin := edBottomMargin.Value ;
      WCPFile.Settings.Plot.MetafileWidth := Round(edWidth.Value) ;
      WCPFile.Settings.Plot.MetafileHeight := Round(edHeight.Value) ;
      WCPFile.Settings.Plot.FontSize := Round(edFontSize.Value) ;
      WCPFile.Settings.Plot.LineThickness := Round(edLineThickness.Value) ;
      WCPFile.Settings.Plot.FontName :=  cbFontName.text ;

      WCPFile.Settings.ShowLabels := ckShowLabels.checked ;
      WCPFile.Settings.ShowZeroLevels := ckShowZeroLevels.checked ;
      WCPFile.Settings.Plot.UseColor := ckUseColor.checked ;

      { Time calibration }
      WCPFile.Settings.TimeBarValue := ExtractFloat(CalibrationBarTable.cells[1,0], 1. ) ;

      { Channel calibration bars }
      Row := 1 ;
      for ch := 0 to WCPFile.fH.NumChannels-1 do if WCPFile.Channel[ch].InUse then begin
         WCPFile.Channel[ch].ADCCalibrationValue := ExtractFloat(
                                  CalibrationBarTable.Cells[1,Row],10. ) ;
         WCPFile.Settings.BarValue[ch] := WCPFile.Channel[ch].ADCCalibrationValue ;

         Inc(Row) ;
         end ;

      { Copy data into display object }
      DisplayObj.PrinterLeftMargin := Round(WCPFile.Settings.Plot.LeftMargin) ;
      DisplayObj.PrinterRightMargin := Round(WCPFile.Settings.Plot.RightMargin) ;
      DisplayObj.PrinterTopMargin := Round(WCPFile.Settings.Plot.TopMargin) ;
      DisplayObj.PrinterBottomMargin := Round(WCPFile.Settings.Plot.BottomMargin) ;
      DisplayObj.PrinterFontName := WCPFile.Settings.Plot.FontName ;
      DisplayObj.PrinterFontSize := WCPFile.Settings.Plot.FontSize ;
      DisplayObj.PrinterPenWidth := WCPFile.Settings.Plot.LineThickness ;
      DisplayObj.MetafileWidth := WCPFile.Settings.Plot.MetaFileWidth ;
      DisplayObj.MetafileHeight := WCPFile.Settings.Plot.MetaFileHeight ;
      DisplayObj.PrinterShowZeroLevels := WCPFile.Settings.ShowZeroLevels ;
      DisplayObj.PrinterShowLabels := WCPFile.Settings.ShowLabels ;
      DisplayObj.PrinterDisableColor := not WCPFile.Settings.Plot.UseColor ;

      for ch := 0 to DisplayObj.NumChannels-1 do
          DisplayObj.ChanCalBar[ch] := WCPFile.Channel[ch].ADCCalibrationValue ;
      DisplayObj.TCalBar := WCPFile.Settings.TimeBarValue /
                                           DisplayObj.TScale ;

     end ;


procedure TPrintRecFrm.CalibrationBarTableKeyPress(
          Sender: TObject;
          var Key: Char);
var
   Value : single ;
   ch,Row : Integer ;
begin
     if key = chr(13) then begin
         { Time calibration bar }
         Value := ExtractFloat( CalibrationBarTable.cells[1,0], 1. ) ;
         CalibrationBarTable.cells[1,0] := Format( '%.4g %s',
                                       [Value,WCPFile.Settings.TUnits])  ;

         { Channel calibration bars }
         Row := 1 ;
         for ch := 0 to WCPFile.fH.NumChannels-1 do if WCPFile.Channel[ch].InUse then begin
             Value := ExtractFloat(CalibrationBarTable.Cells[1,Row],10. ) ;
             CalibrationBarTable.cells[0,Row] := WCPFile.Channel[ch].ADCName ;
             CalibrationBarTable.cells[1,Row] := Format( '%.4g %s',
                                                 [Value,WCPFile.Channel[ch].ADCUnits]) ;
             Inc(Row) ;
             end ;
         end ;

     end;


procedure TPrintRecFrm.bDefaultSettingsClick(Sender: TObject);
// ---------------------------------------------------------
// Set calibration values to default settings (10% of range)
// ---------------------------------------------------------
var
     ch,Row : Integer ;
begin

      WCPFile.Settings.TimeBarValue := (DisplayObj.xMax -
                                DisplayObj.xMin)*
                                DisplayObj.TScale*0.1 ;

      CalibrationBarTable.cells[1,0] := Format( '%.4g %s',
                                       [WCPFile.Settings.TimeBarValue,
                                        WCPFile.Settings.TUnits])  ;

      Row := 1 ;
      for ch := 0 to WCPFile.fH.NumChannels-1 do if WCPFile.Channel[ch].InUse then begin
          WCPFile.Channel[ch].ADCCalibrationValue := (WCPFile.Channel[ch].yMax - WCPFile.Channel[ch].yMin)
                                             *WCPFile.Channel[ch].ADCScale*0.1 ;
          WCPFile.Settings.BarValue[ch] := WCPFile.Channel[ch].ADCCalibrationValue ;
          CalibrationBarTable.cells[0,Row] := WCPFile.Channel[ch].ADCName ;
          CalibrationBarTable.cells[1,Row] := Format( '%.4g %s',
                                              [WCPFile.Settings.BarValue[ch],
                                               WCPFile.Channel[ch].ADCUnits]) ;
         Inc(Row) ;
         end ;
end;

procedure TPrintRecFrm.bPrinterSetupClick(Sender: TObject);
// -----------------------------
// Select printer / change setup
// -----------------------------
begin
     PrinterSetupDialog.Execute ;
     edPrinterName.Text := GetCurrentPrinterName ;
     end ;


function TPrintRecFrm.GetCurrentPrinterName : string ;
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
        Printer.GetPrinter( DeviceName, DeviceDriver,Port, DeviceMode );
        {$ELSE}
        Printer.GetPrinter( DeviceName, DeviceDriver,Port, DeviceMode );
        {$ENDIF}

        Result := String(DeviceName) ;
        FreeMem(DeviceName) ;
        FreeMem(DeviceDriver) ;
        FreeMem(Port) ;
        end ;


end.
