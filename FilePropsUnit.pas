unit FilePropsUnit;
// ---------------------------------------
// Display / Edit WCP data file properties
// ---------------------------------------
// 25.07.06
// 14.05.10 No. records/channels and other data added, complete file header text displayed
// 15.09.11 Displays now have scroll bars
// 25.03.13 Updated to compile under both Delphi XE2/3 and 7

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, global, maths, fileio, ComCtrls ;

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

uses MDIForm;

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
    Header : array[1..MaxBytesInFileHeader] of ANSIchar ;
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
     ChannelTable.RowCount := RawFH.NumChannels + 1;
     ChannelTable.options := [goEditing,goHorzLine,goVertLine] ;

     for ch := 0 to RawfH.NumChannels-1 do begin
         ChannelTable.cells[ChNum,ch+1] := IntToStr(ch) ;
         ChannelTable.cells[ChName,ch+1] := Channel[ch].ADCName ;
         ChannelTable.cells[ChCal,ch+1] := Format( '%5.4g',[Channel[ch].ADCCalibrationFactor] ) ;
         ChannelTable.cells[ChUnits,ch+1] := Channel[ch].ADCUnits ;
         end ;

     // Display file properties
     meProperties.Lines.Clear ;
     meProperties.Lines.Add(format('File version: %.2f',[RawFH.Version])) ;
     meProperties.Lines.Add(format('Date Created: %s',[RawFH.CreationTime])) ;
     meProperties.Lines.Add(format('ID: %s',[RawFH.IdentLine])) ;

     meProperties.Lines.Add(format('No. of records: %d',[RawFH.NumRecords])) ;
     meProperties.Lines.Add(format('No. of channels: %d',[RawFH.NumChannels])) ;
     meProperties.Lines.Add(format('No. of samples/channels: %d',[RawFH.NumSamples])) ;
     meProperties.Lines.Add(format('File header size (bytes): %d',[RawFH.NumBytesInHeader])) ;
     meProperties.Lines.Add(format('Record analysis block size (bytes): %d',[RawFH.NumAnalysisBytesPerRecord])) ;
     meProperties.Lines.Add(format('Record data block size (bytes): %d',
                                   [RawFH.NumAnalysisBytesPerRecord+2*RawFH.NumChannels*RawFH.NumSamples])) ;
     meProperties.Lines.Add(format('Sample value range: %d - %d',[-RawFH.MaxADCValue-1,RawFH.MaxADCValue])) ;

     // Display file header

     FileSeek( RawFH.FileHandle, 0,0) ;
     FillChar( Header, Sizeof(Header), 0) ;
     FileRead( RawFH.FileHandle, Header, SizeOf(Header) ) ;
     meFileHeader.Lines.Clear ;
     meFileHeader.Lines.Text := Header ;

     end;

procedure TFilePropsDlg.bOKClick(Sender: TObject);
// -------------------------------
// Update changes to file settings
// -------------------------------
var
    ch : Integer ;
begin

     { Channel calibration }
     for ch := 0 to RawFH.NumChannels-1 do begin
         Channel[ch].ADCName := ChannelTable.cells[ChName,ch+1] ;
         Channel[ch].ADCCalibrationFactor := ExtractFloat(
                                             ChannelTable.cells[ChCal,ch+1],
                                             Channel[ch].ADCCalibrationFactor);
         Channel[ch].ADCUnits := ChannelTable.cells[ChUnits,ch+1] ;
         end ;

     // Save to file header
     SaveHeader( RawFH ) ;

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
