unit ImportASCIIUnit;
// ----------------------------------
// ASCII file import setup dialog box
// ----------------------------------
// 21.11.03
// 19.02.04 ... Data exchanged using ImportFile public object
//              Channel name/units can now be set
// 02.06.07 ... Title lines at beginning of file can now be ignored

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ValidatedEdit, ADCDataFile, Grids, ExtCtrls ;

type
  TImportASCIIFrm = class(TForm)
    bCancel: TButton;
    bOK: TButton;
    GroupBox3: TGroupBox;
    ChannelTable: TStringGrid;
    meText: TMemo;
    GroupBox6: TGroupBox;
    edNumTitleLines: TValidatedEdit;
    Label2: TLabel;
    GroupBox5: TGroupBox;
    rbTab: TRadioButton;
    rbComma: TRadioButton;
    rbSpace: TRadioButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbTimeUnits: TComboBox;
    GroupBox2: TGroupBox;
    edRecordSize: TValidatedEdit;
    GroupBox4: TGroupBox;
    rbSampleTimesAvailable: TRadioButton;
    rbNoSampleTimes: TRadioButton;
    ckFixedRecordSize: TCheckBox;
    SamplingIntervalPanel: TPanel;
    Label3: TLabel;
    edScanInterval: TValidatedEdit;  procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure rbSampleTimesAvailableClick(Sender: TObject);
    procedure cbTimeUnitsChange(Sender: TObject);
    procedure rbNoSampleTimesClick(Sender: TObject);
    procedure ckFixedRecordSizeClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateTimeUnits ;
  public
    { Public declarations }
    ImportFile : TADCDataFile ;
    FileName : String ;

  end;

var
  ImportASCIIFrm: TImportASCIIFrm;

implementation

{$R *.dfm}

uses MDIForm;

const
     ChNum = 0 ;
     ChName = 1 ;
     ChUnits = 2 ;

const
    MSecScale = 1000.0 ;
    SecScale = 1.0 ;
    MinScale = 1.0/60.0 ;

procedure TImportASCIIFrm.FormShow(Sender: TObject);
// ---------------------------------------
// Initialise controls when form displayed
// ---------------------------------------
var
    ch : Integer ;
    Row : Integer ;
    F: TextFile;
    s : String ;
begin

     Top := Main.Top + 60 ;
     Left := Main.Left + 20 ;

     cbTimeUnits.Clear ;
     cbTimeUnits.Items.Add('msecs') ;
     cbTimeUnits.Items.Add('secs') ;
     cbTimeUnits.Items.Add('mins') ;

     if ImportFile.ASCIITimeUnits = 'ms' then begin
        cbTimeUnits.ItemIndex := 0 ;
        end
     else if ImportFile.ASCIITimeUnits = 's' then begin
        cbTimeUnits.ItemIndex := 1 ;
        end
     else begin
        cbTimeUnits.ItemIndex := 2 ;
        end ;
     UpdateTimeUnits ;

     // Column separating character
     if ImportFile.ASCIISeparator = ',' then rbComma.Checked := True
     else if ImportFile.ASCIISeparator = ' ' then rbSpace.Checked := True
     else rbTab.Checked := True ;

     rbSampleTimesAvailable.Checked := True ;
     rbNoSampleTimes.Checked := not rbSampleTimesAvailable.Checked ;
     ckFixedRecordSize.Checked := rbNoSampleTimes.Checked ;
     SamplingIntervalPanel.Visible := not rbSampleTimesAvailable.Checked ;
     edRecordSize.Visible := ckFixedRecordSize.Checked ;

     edScanInterval.Value := ImportFile.ScanInterval ;

     { Set channel calibration table }
     ChannelTable.cells[ChNum,0] := 'Ch.' ;
     ChannelTable.colwidths[ChNum] := ChannelTable.DefaultColWidth div 2 ;
     ChannelTable.cells[ChName,0] := 'Name' ;
     ChannelTable.colwidths[ChName] := ChannelTable.DefaultColWidth ;
     ChannelTable.cells[ChUnits,0] := 'Units' ;
     ChannelTable.colwidths[ChUnits] := ChannelTable.DefaultColWidth ;
     ChannelTable.RowCount := WCPMaxChannels;
     ChannelTable.options := [goEditing,goHorzLine,goVertLine] ;

     { Add details for new channels to table }
     for Row := 1 to ChannelTable.RowCount-1 do begin
         ch := Row-1 ;
         ChannelTable.cells[ChNum,Row] := format('%d',[ch]) ;
         ChannelTable.cells[ChName,Row] := ImportFile.ChannelName[ch] ;
         ChannelTable.cells[ChUnits,Row] := ImportFile.ChannelUnits[ch] ;
         end ;

     // Display first 10 lines of file
     AssignFile( F, FileName ) ;
     Reset(F);
     meText.Clear ;
     While (not EOF(F)) and (meText.Lines.Count < 10) do begin
         Readln(F, s);
         meText.Lines.Add( s ) ;
         end ;
     CloseFile(F) ;

     end;


procedure TImportASCIIFrm.bOKClick(Sender: TObject);
// ------------------
// Exit and hide form
// ------------------
var
     ch : Integer ;
     Row : Integer ;
begin

     ImportFile.ASCIITimeDataInCol0 := rbSampleTimesAvailable.Checked ;
     ImportFile.ASCIITitleLines := Round(edNumTitleLines.Value) ;

     // Fixed record size if selected by user or if no time data available
     ImportFile.ASCIIFixedRecordSize := ckFixedRecordSize.Checked ;
     // Get record size
     if ImportFile.ASCIIFixedRecordSize then ImportFile.NumScansPerRecord := Round(edRecordSize.Value) ;
     // Get sampling interval
     if not ImportFile.ASCIITimeDataInCol0 then ImportFile.ScanInterval := edScanInterval.Value ;

     // Column separator
     if rbComma.Checked then ImportFile.ASCIISeparator := ','
     else if rbSpace.Checked then ImportFile.ASCIISeparator := ' '
     else ImportFile.ASCIISeparator := #9 ;

     { Add details for new channels to table }
     for Row := 1 to ChannelTable.RowCount-1 do begin
         ch := Row-1 ;
         ImportFile.ChannelName[ch] := ChannelTable.cells[ChName,Row] ;
         ImportFile.ChannelUnits[ch] := ChannelTable.cells[ChUnits,Row] ;
         end ;

     end;


procedure TImportASCIIFrm.rbSampleTimesAvailableClick(Sender: TObject);
// ----------------------------------------------
// Sample time available in first column of table
// ----------------------------------------------
begin
     ckFixedRecordSize.Checked := False ;
     edRecordSize.Visible := False ;
     SamplingIntervalPanel.Visible := False ;
     end;


procedure TImportASCIIFrm.cbTimeUnitsChange(Sender: TObject);
begin
    UpdateTimeUnits ;
    end ;


procedure TImportASCIIFrm.UpdateTimeUnits ;
begin
     if cbTimeUnits.ItemIndex = 0 then begin
        ImportFile.ASCIITimeUnits := 'ms' ;
        edScanInterval.Units := 'ms' ;
        end
     else if cbTimeUnits.ItemIndex = 1 then begin
        ImportFile.ASCIITimeUnits := 's' ;
        edScanInterval.Units := 's' ;
        end
     else begin
        ImportFile.ASCIITimeUnits := 'm' ;
        edScanInterval.Units := 'm' ;
        end ;
     end ;


procedure TImportASCIIFrm.rbNoSampleTimesClick(Sender: TObject);
// --------------------------------------
// User-defined time data option selected
// --------------------------------------
begin
     ckFixedRecordSize.Checked := True ;
     edRecordSize.Visible := True ;
     SamplingIntervalPanel.Visible := True ;
     end;


procedure TImportASCIIFrm.ckFixedRecordSizeClick(Sender: TObject);
// --------------------------------
// Fixed record size option changed
// --------------------------------
begin

     edRecordSize.Visible := ckFixedRecordSize.Checked ;
     SamplingIntervalPanel.Visible := rbNoSampleTimes.Checked ;

     end ;

end.
