unit FilePropsUnit;
// ---------------------------------------
// Display / Edit WCP data file properties
// ---------------------------------------
// 25.07.06
// 14.05.10 No. records/channels and other data added, complete file header text displayed
// 15.09.11 Displays now have scroll bars
// 25.07.13 Updated to compile under both Delphi XE2/3 and 7
// 26.08.13 No. of sign. figure increased in scale factor table
// 27.08.13 Recording start date now displayed
// 20.09.15 Displays WinWCP program version which created file.
// 03.06.20 Total record size, data block and analysis block size now dispkayed

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, maths, ComCtrls ;

type
  TFilePropsDlg = class(TForm)
    bCancel: TButton;
    bOK: TButton;
    PageControl1: TPageControl;
    TabProperties: TTabSheet;
    TabCalTable: TTabSheet;
    TabFileHeader: TTabSheet;
    meProperties: TMemo;
    ChannelTable: TStringGrid;
    meFileHeader: TMemo;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FilePropsDlg: TFilePropsDlg;

implementation

uses MDIForm, WCPFIleUnit;

const
     ChNum = 0 ;
     ChName = 1 ;
     ChCal = 2 ;
     ChUnits = 3 ;

{$R *.dfm}

procedure TFilePropsDlg.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
var
    ch : Integer ;
    Header : TStringList ;
    pANSIBuf : PANSIChar ;
    ANSIHeader : ANSIString ;

begin

     { Set channel calibration table }
     ChannelTable.cells[ChNum,0] := 'Ch.' ;
     ChannelTable.colwidths[ChNum] := ChannelTable.DefaultColWidth div 2 ;
     ChannelTable.cells[ChName,0] := 'Name' ;
     ChannelTable.colwidths[ChName] := ChannelTable.DefaultColWidth ;
     ChannelTable.cells[ChCal,0] := 'V/Units' ;
     ChannelTable.colwidths[ChCal] := (5*ChannelTable.DefaultColWidth) div 4 ;
     ChannelTable.cells[ChUnits,0] := 'Units' ;
     ChannelTable.colwidths[ChUnits] := ChannelTable.DefaultColWidth ;
     ChannelTable.RowCount := WCPFile.RawFH.NumChannels + 1;
     ChannelTable.options := [goEditing,goHorzLine,goVertLine] ;

     for ch := 0 to WCPFile.RawFH.NumChannels-1 do begin
         ChannelTable.cells[ChNum,ch+1] := IntToStr(ch) ;
         ChannelTable.cells[ChName,ch+1] := WCPFile.Channel[ch].ADCName ;
         ChannelTable.cells[ChCal,ch+1] := Format( '%.6g',[WCPFile.Channel[ch].ADCCalibrationFactor] ) ;
         ChannelTable.cells[ChUnits,ch+1] := WCPFile.Channel[ch].ADCUnits ;
         end ;

     // Display file properties
     meProperties.Lines.Clear ;
     meProperties.Lines.Add(format('File version: %.2f',[WCPFile.RawFH.Version])) ;
     meProperties.Lines.Add(format('WinWCP version: %s',[WCPFile.RawFH.ProgVersion])) ;
     meProperties.Lines.Add(format('Date Created: %s',[WCPFile.RawFH.CreationTime])) ;
     if WCPFile.RawFH.RecordingStartTimeSecs > 0.0 then
        meProperties.Lines.Add(format('Recording started at: %s',[WCPFile.RawFH.RecordingStartTime])) ;
     meProperties.Lines.Add(format('ID: %s',[WCPFile.RawFH.IdentLine])) ;

     meProperties.Lines.Add(format('No. of records: %d',[WCPFile.RawFH.NumRecords])) ;
     meProperties.Lines.Add(format('No. of channels: %d',[WCPFile.RawFH.NumChannels])) ;
     meProperties.Lines.Add(format('No. of samples/channels: %d',[WCPFile.RawFH.NumSamples])) ;
     meProperties.Lines.Add(format('File header size (bytes): %d',[WCPFile.RawFH.NumBytesInHeader])) ;
     meProperties.Lines.Add(format('Record size (bytes): %d',
                                   [WCPFile.RawFH.NumAnalysisBytesPerRecord+2*WCPFile.RawFH.NumChannels*WCPFile.RawFH.NumSamples])) ;
     meProperties.Lines.Add(format('Record analysis block size (bytes): %d',[WCPFile.RawFH.NumAnalysisBytesPerRecord])) ;
     meProperties.Lines.Add(format('Record data block size (bytes): %d',[2*WCPFile.RawFH.NumChannels*WCPFile.RawFH.NumSamples])) ;
     meProperties.Lines.Add(format('Sample value range: %d to %d',[-WCPFile.RawFH.MaxADCValue-1,WCPFile.RawFH.MaxADCValue])) ;

     // Display file header
     FileSeek( WCPFile.RawFH.FileHandle, 0, 0 ) ;
     pANSIBuf := AllocMem( WCPFile.RawFH.NumBytesInHeader ) ;
     FileRead(WCPFile.RawFH.FileHandle, pANSIBuf^, WCPFile.RawFH.NumBytesInHeader ) ;
     pANSIBuf[WCPFile.RawFH.NumBytesInHeader-1] := #0 ;
     ANSIHeader := ANSIString( pANSIBuf ) ;
     meFileHeader.Lines.Text := String(ANSIHeader) ;
     FreeMem( pANSIBuf ) ;

     end;

procedure TFilePropsDlg.bOKClick(Sender: TObject);
// -------------------------------
// Update changes to file settings
// -------------------------------
var
    ch : Integer ;
begin

     { Channel calibration }
     for ch := 0 to WCPFile.RawFH.NumChannels-1 do
         begin
         WCPFile.Channel[ch].ADCName := ChannelTable.cells[ChName,ch+1] ;
         WCPFile.Channel[ch].ADCCalibrationFactor := ExtractFloat(
                                             ChannelTable.cells[ChCal,ch+1],
                                             WCPFile.Channel[ch].ADCCalibrationFactor);
         WCPFile.Channel[ch].ADCUnits := ChannelTable.cells[ChUnits,ch+1] ;
         end ;

     // Save to file header
     WCPFile.SaveHeader( WCPFile.RawFH ) ;

     Main.NewFileUpdate ;

     Close ;

     end;


procedure TFilePropsDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     Action := caFree ;
     end;

procedure TFilePropsDlg.bCancelClick(Sender: TObject);
begin
     Close ;
     end;

end.
