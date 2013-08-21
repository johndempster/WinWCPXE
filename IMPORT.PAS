unit Import;
{ ==============================================================
  WinWCP - General purpose Binary/ASCII data file import module
  (c) J. Dempster, University of Strathclyde, 1997
  15/12/97
  1/11/01 Multiple ASCII record files now imported correctly
  22.5.02 ASCII text file now closed after importing ended
 12.2.03 Corrections suggested by magura@serv.biph.kiev.ua added  
  ==============================================================}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, TabNotBk, maths, shared, global, fileio,
  ComCtrls, ValEdit, ValidatedEdit;

type
  TImportFrm = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    Page: TPageControl;
    ASCIITab: TTabSheet;
    BinaryTab: TTabSheet;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    cbTUnitsBinary: TComboBox;
    edNumFileHeaderBytes: TValidatedEdit;
    edNumRecordHeaderBytes: TValidatedEdit;
    edNumChannelsBinary: TValidatedEdit;
    edNumSamplesBinary: TValidatedEdit;
    edScaleBy: TValidatedEdit;
    edOffsetBy: TValidatedEdit;
    edDTBinary: TValidatedEdit;
    mePreview: TMemo;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    cbTUnits: TComboBox;
    edIgnore: TValidatedEdit;
    edNumChannels: TValidatedEdit;
    edNumSamples: TValidatedEdit;
    edTimeColumn: TValidatedEdit;
    edDT: TValidatedEdit;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure cbTUnitsChange(Sender: TObject);
  private
    { Private declarations }
    procedure InspectASCIIFile ;
    procedure ImportASCIIData ;
    procedure ImportBinaryData ;
  public
    { Public declarations }
    FileName : string ;
  end;

var
  ImportFrm: TImportFrm;

implementation

uses Mdiform;

{$R *.DFM}

var
   MaxValues : Array[0..20] of single ;

procedure TImportFrm.FormShow(Sender: TObject);
{ -----------------------------------
  Display first 10 lines of data file
  -----------------------------------}
begin

     cbTUnits.Clear ;
     cbTUnits.Items.Add('s') ;
     cbTUnits.Items.Add('ms') ;
     cbTUnits.Items.Add('us') ;
     cbTUnits.ItemIndex := 1 ;

     cbTUnitsBinary.Clear ;
     cbTUnitsBinary.Items.Add('s') ;
     cbTUnitsBinary.Items.Add('ms') ;
     cbTUnitsBinary.Items.Add('us') ;
     cbTUnitsBinary.ItemIndex := 1 ;

     InspectASCIIFile ;
     end ;


procedure TImportFrm.InspectASCIIFile ;
{ ----------------------------------------------
  Inspect the data file assuming an ASCII format
  ----------------------------------------------}
var
   F : TextFile ;
   Col,nCols,nColsOld,nSamples,MaxSamples : Integer ;
   nLines : LongInt ;
   T,TOld : single ;
   Values : Array[0..20] of Single ;
   s : string ;
begin

     { Open file for reading as text }
     AssignFile( F, ImportFrm.FileName ) ;
     Reset(F) ;

     { Initialise counters }
     for Col := 0 to High(MaxValues) do MaxValues[Col] := -1E30 ;
     nSamples := 0 ;
     MaxSamples := 0 ;
     nLines := 0 ;
     nColsOld := 0 ;

     mePreview.Clear ;
     while not EOF(F) do begin
         { Read a line of text from file }
         ReadLn( F,s ) ;
         { Display first 10 lines into memo box }
         if nLines < 10 then mePreview.Lines.Add( s ) ;
         Inc(nLines) ;

         { Number of columns }
         nCols := ExtractListOfFloats( s, Values, False ) ;
         if nCols = nColsOld then begin
            edNumChannels.Value := nCols-1 ;
            end ;
         nColsOld := nCols ;

         { Determine maximum absolute values within data columns }
         for Col := 0 to nCols-1 do begin
              MaxValues[Col] := MaxFlt( [Abs(Values[Col]),MaxValues[Col]] ) ;
              end ;

         { Sampling interval }
         if nCols > 1 then begin
            Inc(nSamples) ;
            MaxSamples := MaxInt( [nSamples,MaxSamples] ) ;
            T := Values[0] ;
            if T < Told then nSamples := 0
                        else edDT.Value := T-TOld ;
            TOld := T ;
            edTimeColumn.Value := 1 ;
            end ;

         end ;

     edNumChannels.Value := nCols-1 ;
     MaxSamples := MakeMultiple( MaxSamples, 256, 1 ) ;
     edNumSamples.Value := MaxSamples ;

     CloseFile(F) ;
     end;


procedure TImportFrm.bOKClick(Sender: TObject);
{ ---------------------
  Import data from file
  ---------------------}
begin

     if Page.ActivePage = ASCIITab then ImportASCIIData
                                   else ImportBinaryData ;
     end;


procedure TImportFrm.ImportASCIIData ;
{ ----------------------
  Import ASCII data file
  ----------------------}
var
   F : TextFile ;
   Values,Scale : Array[0..20] of Single ;
   s : string ;
   Col,nCols,TCol,n,nSamples,NumSamplesPerRecord,ch,i : Word ;
   T,TOld,TScale : single ;
   RH : ^TRecHeader ;
   Buf : ^TIntArray ;
   OK,SaveRecord : Boolean ;
begin

     OK := True ;

     { Create buffer to hold samples }
     New(Buf) ;
     New(RH) ;

     try

        { Close existing WCP data file }
        FileCloseSafe( RawFH.FileHandle ) ;

        { Create name of WCP file to hold ASCII data file }
        RawFH.FileName := ChangeFileExt( ImportFrm.FileName, '.wcp' ) ;

        { Create a new WCP file to hold converted data }
        RawFH.FileHandle := FileCreate( RawFH.FileName ) ;
        if RawFH.FileHandle < 0 then begin
           OK := False ;
           end ;

        { Define size of WCP record }
        if OK then begin
           RawFH.NumRecords := 0 ;
           RawFH.NumSamples := Round(edNumSamples.Value) ;
           { Number of signal channels }
           RawFH.NumChannels := Round(edNumChannels.Value) ;
           if RawFH.NumChannels > (ChannelLimit+1) then begin
              MessageDlg( format(' Only %d channels allowed',[ChannelLimit+1]),
                           mtWarning, [mbOK], 0 ) ;
              RawFH.NumChannels := ChannelLimit+1 ;
              end ;

           { Number of samples / channel }
           NumSamplesPerRecord := RawFH.NumSamples*RawFH.NumChannels ;
           if NumSamplesPerRecord > (MaxTBuf+1) then begin
              RawFH.NumSamples := (MaxTBuf+1) div RawFH.NumChannels ;
              RawFH.NumSamples := MakeMultiple( RawFH.NumSamples, 256, 0 ) ;
              NumSamplesPerRecord := RawFH.NumSamples*RawFH.NumChannels ;
              MessageDlg(
              format(' Record size exceeded. Samples/channel=%d',[RawFH.NumSamples]),
                           mtWarning, [mbOK], 0 ) ;
              end ;

           { Open file for reading as text }
           AssignFile( F, ImportFrm.FileName ) ;
           Reset(F) ;

           nCols := RawFH.NumChannels + 1 ;
           TCol := Round(edTimeColumn.Value) - 1 ;
           if TCol >= 0 then Inc(nCols) ;

           RawFH.ADCVoltageRange := 1.0 ;
           Ch := 0 ;
           for Col := 0 to nCols-1 do if Col <> TCol then begin
               if MaxValues[Col] <> 0.0 then Scale[Col] := MaxADCValue / (1.1*MaxValues[Col])
                                        else Scale[Col] := 1.0 ;
               Channel[Ch].ADCScale := 1.0 / Scale[Col] ;
               Channel[ch].ADCCalibrationFactor := RawFH.ADCVoltageRange /
                          ( Channel[ch].ADCScale * (MaxADCValue+1) ) ;
               Inc(Ch) ;
               end ;

           { Channel calibration and scale factor settings }
           for ch := 0 to RawFH.NumChannels-1 do begin
               Channel[ch].ChannelOffset := ch ;
               Channel[ch].ADCAmplifierGain := 1. ;
               Channel[ch].ADCZero := 0 ;
               Channel[ch].ADCUnits := '' ;
               Channel[ch].ADCName := Format( 'Ch.%d', [ch] ) ;
               end ;

           { Set time conversion factor }
           if cbTUnits.Items[cbTUnits.ItemIndex] = 's' then TScale := 1.0
           else if cbTUnits.Items[cbTUnits.ItemIndex] = 'ms' then TScale := 1E-3
           else TScale := 1E-6 ;

           RawFH.dt := edDT.Value*TScale ;

           { Import ASCII data into .WCP file format }
           Reset(F) ;
           nSamples := 0 ;
           TOld := 0. ;
           for i := 0 to NumSamplesPerRecord-1 do Buf^[i] := 0 ;
           SaveRecord := False ;

           while (not EOF(F)) do begin

               { Read in a row of text }
               ReadLn( F,s ) ;
               { Extract samples from  row }
               nCols := ExtractListOfFloats( s, Values, False ) ;

               { Determine if a new record is needed based upon time column }
               if TCol >= 0 then begin
                  T := Values[TCol] ;
                  {If time value has decreased, create a new record }
                  if T < Told then SaveRecord := True ;
                  TOld := T ;
                  end ;

               { If at end of file, put last samples into buffer and request save }
               if EOF(F) then begin
                  for Col := 0 to nCols-1 do if (Col <> TCol) then begin
                      Buf^[nSamples] := Trunc( Values[Col]*Scale[Col] ) ;
                      Inc(nSamples) ;
                      end ;
                  SaveRecord := True ;
                  end ;

               { Save record to file when requested }
               if SaveRecord then begin
                  Inc(RawFH.NumRecords) ;
                  rH^.Status := 'ACCEPTED' ;
                  rH^.RecType := 'TEST' ;
                  rH^.Number := RawFH.NumRecords ;
                  rH^.Time := rH^.Number ;
                  rH^.dt := RawfH.dt ;
                  rH^.Ident := ' ' ;
                  for ch := 0 to RawFH.NumChannels-1 do rH^.ADCVoltageRange[ch] :=
                                                   RawFH.ADCVoltageRange ;
                  rH^.Equation.Available := False ;
                  rH^.Analysis.Available := False ;

                  PutRecord( RawfH, rH^, RawfH.NumRecords, Buf^ ) ;
                  { Clear buffer }
                  for i := 0 to NumSamplesPerRecord-1 do Buf^[i] := 0 ;
                  nSamples := 0 ;
                  SaveRecord := False ;

                  Main.StatusBar.SimpleText := format(
                  ' Importing record %d from %s (ASCII format)',
                  [RawFH.NumRecords,ImportFrm.FileName]) ;

                  end ;

               { Normal update of binary data buffer }
               if nCols =( RawFH.NumChannels + 1) then begin
               for Col := 0 to nCols-1 do if (Col <> TCol) then begin
                   Buf^[nSamples] := Trunc( Values[Col]*Scale[Col] ) ;
                   Inc(nSamples) ;
                   end ;
                   end ;

               { Request a new record when record is full }
               if (nSamples >= NumSamplesPerRecord) then SaveRecord := True ;

               end ;

           SaveHeader(RawFH) ;
           { Close WCP file }
           FileCloseSafe( RawFH.FileHandle ) ;

           // Close ASCII file
           CloseFile(F) ;

           Main.StatusBar.SimpleText := format(
           ' Import: %d records imported from %s (ASCII format)',
           [RawFH.NumRecords,ImportFrm.FileName]) ;

           WriteToLogFile( 'ASCII Data File : ' + ImportFrm.FileName ) ;
           WriteToLogFile( 'converted to WCP file : ' + RawFH.FileName ) ;
           end ;

     finally
          Dispose(Buf) ;
          Dispose(RH) ;
          end ;

     if not OK then MessageDlg( ' Unable to import ' + FileName,mtWarning, [mbOK], 0 ) ;
     ModalResult := mrOK ;

     end ;


procedure TImportFrm.ImportBinaryData ;
{ ----------------------
  Import binary data file
  ----------------------}
var
   NumSamplesPerRecord,NumBytesPerRecord,ch,i : Word ;
   Filehandle : Integer ;
   FilePointer, StartAt,NumRecordHeaderBytes : LongInt ;
   TScale,ScaleBy,OffsetBy : single ;
   RH : ^TRecHeader ;
   Buf : ^TIntArray ;
   OK,Done : Boolean ;
begin

     OK := True ;

     { Create buffer to hold samples }
     New(Buf) ;
     New(RH) ;

     try

        { Close existing WCP data file }
        FileCloseSafe( RawFH.FileHandle ) ;

        { Create name of WCP file to hold binary data }
        RawFH.FileName := ChangeFileExt( ImportFrm.FileName, '.wcp' ) ;

        { Create a new WCP file to hold converted data }
        RawFH.FileHandle := FileCreate( RawFH.FileName ) ;
        if RawFH.FileHandle < 0 then begin
           OK := False ;
           end ;

        { Define size of WCP record }
        if OK then begin
           RawFH.NumRecords := 0 ;
           RawFH.NumSamples := Round(edNumSamplesBinary.Value) ;
          { Number of signal channels }
          RawFH.NumChannels := Round(edNumChannelsBinary.Value) ;
          if RawFH.NumChannels > (ChannelLimit+1) then begin
             MessageDlg( format(' Only %d channels allowed',[ChannelLimit+1]),
                            mtWarning, [mbOK], 0 ) ;
             RawFH.NumChannels := ChannelLimit+1 ;
             end ;

          NumSamplesPerRecord := RawFH.NumSamples*RawFH.NumChannels ;
          NumBytesPerRecord := NumSamplesPerRecord*2 ;

          RawFH.ADCVoltageRange := 1.0 ;

          { Channel calibration and scale factor settings }
          for ch := 0 to RawFH.NumChannels-1 do begin
              Channel[ch].ChannelOffset := ch ;
              Channel[Ch].ADCScale := 1.0 ;
              Channel[ch].ADCAmplifierGain := 1. ;
              Channel[ch].ADCCalibrationFactor := RawFH.ADCVoltageRange /
                          ( Channel[ch].ADCScale * (MaxADCValue+1) ) ;
              Channel[ch].ADCZero := 0 ;
              Channel[ch].ADCUnits := '' ;
              Channel[ch].ADCName := Format( 'Ch.%d', [ch] ) ;
              end ;

          { Set sampling interval }
          if cbTUnitsBinary.Items[cbTUnits.ItemIndex] = 's' then TScale := 1.0
          else if cbTUnitsBinary.Items[cbTUnits.ItemIndex] = 'ms' then TScale := 1E-3
          else TScale := 1E-6 ;
          RawFH.dt := edDTBinary.Value*TScale ;

          { Open import file }
          FileHandle := FileOpen( ImportFrm.FileName, fmOpenRead ) ;
          if FileHandle < 0 then begin
             OK := False ;
             end ;
          end ;

        if OK then begin
           StartAt := Round(edNumFileHeaderBytes.Value) ;
           FileSeek( FileHandle, StartAt, 0 ) ;

           { Import records }
           ScaleBy := edScaleBy.Value ;
           OffsetBy := edOffsetBy.Value ;
           NumRecordHeaderBytes := Round(edNumRecordHeaderBytes.Value) ;

           Done := False ;
           while not Done do begin

              { Skip over record header block }
              FileSeek( FileHandle, NumRecordHeaderBytes, 1 ) ;
              { Read sample data }
              if FileRead(FileHandle,Buf^,NumBytesPerRecord)
                 = NumBytesPerRecord then begin

                 { Do scaling and offset }
                 for i := 0 to NumSamplesPerRecord-1 do
                     Buf^[i] := Trunc(Buf^[i]*ScaleBy + OffsetBy) ;

                 { Save record to .WCP file }
                 Inc(RawFH.NumRecords) ;
                 rH^.Status := 'ACCEPTED' ;
                 rH^.RecType := 'TEST' ;
                 rH^.Number := RawFH.NumRecords ;
                 rH^.Time := rH^.Number ;
                 rH^.dt := RawfH.dt ;
                 rH^.Ident := ' ' ;
                 for ch := 0 to RawFH.NumChannels-1 do rH^.ADCVoltageRange[ch] :=
                                                       RawFH.ADCVoltageRange ;
                 rH^.Equation.Available := False ;
                 rH^.Analysis.Available := False ;

                 PutRecord( RawfH, rH^, RawfH.NumRecords, Buf^ ) ;

                 Main.StatusBar.SimpleText := format(
                 ' Importing record %d from %s (binary format)',
                 [RawFH.NumRecords,ImportFrm.FileName]) ;

                 end
              else Done := True ;
              end ;

           { Close import file }
           FileCloseSafe( FileHandle ) ;

           SaveHeader(RawFH) ;

           { Close WCP file }
           FileCloseSafe( RawFH.FileHandle ) ;

           Main.StatusBar.SimpleText := format(
           ' Import: %d records imported from %s (binary format)',
           [RawFH.NumRecords,ImportFrm.FileName]) ;

           WriteToLogFile( 'Binary Data File : ' + ImportFrm.FileName ) ;
           WriteToLogFile( 'converted to WCP file : ' + RawFH.FileName ) ;
           end ;

     finally
          Dispose(Buf) ;
          Dispose(RH) ;
          end ;

     if not OK then MessageDlg( ' Unable to import ' + FileName,mtWarning, [mbOK], 0 ) ;
     ModalResult := mrOK ;

     end ;


procedure TImportFrm.cbTUnitsChange(Sender: TObject);
var
   dt : single ;
begin
     dt := edDT.Value ;
     edDT.Value := dt ;
     end;

end.
