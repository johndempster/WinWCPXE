unit Convert;
{ =============================================================================
  WinWCP - File importing module (c) J Dempster, 1996-2001, All Rights Reserved
  7/6/97 ... AppendWCPFile added
  10/6/97 ... WCPTopCLAMP added
  24/8/97 ... ImportFromDataFile and CFSToWCP added
  27/5/99 ... Updated to support ABF V1.5
  9/8/99  ... 32 bit version
  14/12/99 ... ConvertOldToNewWCP Channel Calibration factor scaling now correct
  22/2/00 .... Axon files containing floating point samples now importable
  19/7/00 ...  ConvertOldToNewWCP modified
  10/5/01 ... ConvertOldToNewWCP Now handles 32 bit WinWCP V3.0 files with incorrect file version no.
  17/7/01 ... Minor changes to ConvertOldToNewWCP (progress form)
              Bugs in AppendWCPfile fixed
  11/12/04 ... ProgressFrm no longer used
  12/05/10 ... ConvertOldToNewWCP name changed to ConvertWCPPreV62toV9
               ConvertWCPV8toV9 added

  ========================================================================== }
interface

uses global,fileio,SysUtils,shared,Dialogs,Messages,forms,controls, maths, seslabio ;

const
     { - for ConvertOldToNewWCP - }
     OldChannelLimit = 5 ;
     OldVarLimit = 13 ;
     OldLastParameter = 6 ;
     { -------------------------- }


Function AppendWCPfile( const FileName : string ) : Boolean ;
Function InterleaveWCPfile( const FileName : string ) : Boolean ;

function ConvertWCPPreV62toV9( FileName : string ) : Boolean ;
function ConvertWCPV8toV9(
          FileName : string   { Name of file to be converted }
          ) : Boolean ;


implementation

uses mdiform ;


Function AppendWCPfile(
         const FileName : string
         ) : Boolean ;
{ ----------------------------------------------------------
  Append the records from a WCP data file to the current one
  ----------------------------------------------------------}
var
   Buf : ^TSmallIntArray ;
   RecHeader : ^TRecHeader ;
   ch : Integer ;
   Rec,StartAt : Integer ;
   KeepChannel : Array[0..WCPMaxChannels-1] of TChannel ;
   YScale : Array[0..WCPMaxChannels-1] of Single ;
   ScaleFrom,ScaleTo : Single ;
   AppFH : TFileHeader ;
   s : string ;
begin
     { Create buffers }
     Result := False ;
     New(RecHeader) ;
     New(Buf) ;

     { Save signal channel settings for currently open file }
     for ch := 0 to RawFH.NumChannels-1 do KeepChannel[ch] := Channel[ch] ;

     { Open file to be appended }
     AppFH.FileName := FileName ;
     AppFH.FileHandle := FileOpen( AppFH.FileName, fmOpenReadWrite ) ;
     if AppFH.FileHandle < 0 then begin
        MessageDlg( 'Unable to append ' + FileName,mtWarning, [mbOK], 0 ) ;
        Exit ;
        end ;

     GetHeader( AppFH ) ;
     if (AppFH.NumSamples <> RawFH.NumSamples)
        or (AppFH.NumChannels <> RawFH.NumChannels ) then begin
        ShowMessage('File ' + FileName + 'No. samples/record or channels mismatch!') ;
        { Dispose of buffers & files}
        Dispose(RecHeader) ;
        Dispose(Buf) ;
        FileCloseSafe( AppFH.FileHandle ) ;
        Exit ;
        end ;

     { if the calibration factors of the appended file are different
           apply a correction factor to the A/D voltage range in each record }
           { Adjust for possible differences in channel calibration factors }
     for ch := 0 to AppFH.NumChannels-1 do begin
         ScaleFrom := Channel[ch].ADCCalibrationFactor ;
         ScaleTo := KeepChannel[ch].ADCCalibrationFactor ;
         YScale[ch] := ScaleTo / ScaleFrom ;
         end ;

     { Append records to end of current data file }
     StartAt := RawFH.NumRecords + 1 ;
     for Rec := 1 to AppFH.NumRecords do begin

         { Read from source file }
         GetRecord( AppfH, RecHeader^, Rec, Buf^ ) ;
         { Re-scale calibration }
         for ch := 0 to AppFH.NumChannels-1 do
             RecHeader^.ADCVoltageRange[ch] := RecHeader^.ADCVoltageRange[ch] *YScale[ch] ;

         { Write to destination file }
         if RecHeader^.Status = 'ACCEPTED' then begin
            Inc( RawFH.NumRecords ) ;
            PutRecord( RawfH, RecHeader^, RawFH.NumRecords, Buf^ ) ;
            end ;

         // Report progress
         Main.StatusBar.SimpleText := format(
                                      'Appending records %d/%d from %s',
                                      [Rec,AppFH.NumRecords,FileName] ) ;

         end ;


     s := AppFH.FileName + ' appended to ' + RawFH.FileName ;
     Main.StatusBar.SimpleText := s ;
     WriteToLogFile( s ) ;
     WriteToLogFile( format( 'Records %d - %d added (%d)',
                     [StartAt,RawFH.NumRecords,RawFH.NumRecords-StartAt+1]));

     { Update destination file header }
     SaveHeader( RawFH ) ;

     { Restore signal channel settings for currently open file }
     for ch := 0 to RawFH.NumChannels-1 do Channel[ch] := KeepChannel[ch] ;

     // Dispose of buffers }
     Dispose(RecHeader) ;
     Dispose(Buf) ;
     { Close source file }
     FileCloseSafe( AppFH.FileHandle ) ;

     Result := True ;

     end ;


Function InterleaveWCPfile(
         const FileName : string
         ) : Boolean ;
{ ----------------------------------------------------------------
  Interleave the records from a WCP data file with the current one
  ----------------------------------------------------------------
  15/7/01}
var
   Rec,GroupNum : Integer ;
   In1FH : TFileHeader ;      // Input file header #1
   Buf1 : ^TSmallIntArray ;        // Input buffer #1
   RecHeader1 : ^TRecHeader ;  // Input record header #1

   In2FH : TFileHeader ;      // Input file header #2
   Buf2 : ^TSmallIntArray ;        // Input buffer #2
   RecHeader2 : ^TRecHeader ;  // Input record header #1

begin

     Result := False ;

     // Open file #1 to be interleaved
     In1FH.FileName := FileName ;
     In1FH.FileHandle := FileOpen( In1FH.FileName, fmOpenReadWrite ) ;
     if In1FH.FileHandle < 0 then begin
        Exit ;
        end ;

     GetHeader( In1FH ) ;
     if In1FH.NumSamples <> RawFH.NumSamples then begin
         ShowMessage('File ' + FileName + 'Not compatible. Samples/record mismatched!') ;
         Exit ;
         end ;

     if In1FH.NumChannels <> RawFH.NumChannels then begin
        ShowMessage('File ' + FileName
                   + 'Not compatible. No. channels mismatched!') ;
        Exit ;
        end ;

     if In1FH.NumRecords <> RawFH.NumRecords then begin
        ShowMessage('File ' + FileName + 'Not compatible. No. records mismatched!') ;
        Exit ;
        end ;

     // Create buffers
     New(RecHeader1) ;
     New(Buf1) ;
     New(RecHeader2) ;
     New(Buf2) ;

     // Close currently active data file and rename as .BAK
     FileCloseSafe( RawFH.FileHandle ) ;
     In2FH.FileName := ChangeFileExt( RawFH.FileName, '.bak' ) ;
     if FileExists(In2FH.FileName) then DeleteFile(In2FH.FileName) ;
     if not RenameFile( RawFH.FileName, In2FH.FileName ) then
        MessageDlg( 'Unable to rename ' + RawFH.FileName + ' to ' + In2FH.FileName,
                    mtWarning, [mbOK], 0 ) ;

     // Re-open it as 2nd input file
     In2FH.FileHandle := FileOpen( In2FH.FileName, fmOpenReadWrite ) ;
     GetHeader( In2FH ) ;

     // Create empty output file for merged data
     RawFH.FileHandle := FileCreate( RawFH.FileName ) ;
     RawFH.NumRecords := 0 ;

     { Append records to end of current data file }
     GroupNum := 1 ;
     for Rec := 1 to In1FH.NumRecords do begin

         { Read from input file #1 file }
         GetRecord( In1fH, RecHeader1^, Rec, Buf1^ ) ;

         { Read from input file #2 file }
         GetRecord( In2fH, RecHeader2^, Rec, Buf2^ ) ;

         { Write to destination file }
         if (RecHeader1^.Status = 'ACCEPTED') and
            (RecHeader2^.Status = 'ACCEPTED') then begin
            Inc( RawFH.NumRecords ) ;
            RecHeader2^.Number := GroupNum ;
            // Make records from #2 file TEST
            RecHeader2^.RecType := 'TEST' ;
            PutRecord( RawfH, RecHeader2^, RawFH.NumRecords, Buf2^ ) ;
            Inc( RawFH.NumRecords ) ;
            RecHeader1^.Number := GroupNum ;
            // Make records from #1 file TEST
            RecHeader1^.RecType := 'LEAK' ;
            PutRecord( RawfH, RecHeader1^, RawFH.NumRecords, Buf1^ ) ;
            Inc(GroupNum) ;
            end ;

         // Report progress
         Main.StatusBar.SimpleText := format(
                                      'Interleaving %s with %s %d/%d',
                                      [FileName,RawFH.FileName,Rec,In1FH.NumRecords] ) ;

         end ;

     Main.StatusBar.SimpleText := format(
                                      'File %s interleaved with %s',
                                      [FileName,RawFH.FileName] ) ;
     WriteToLogFile( In1FH.FileName + ' interleaved with ' + RawFH.FileName ) ;

     { Update destination file header }
     SaveHeader( RawFH ) ;

     { Dispose of buffers }
     Dispose(RecHeader1) ;
     Dispose(Buf1) ;
     Dispose(RecHeader2) ;
     Dispose(Buf2) ;

     { Close source files }
     FileCloseSafe( In1FH.FileHandle ) ;
     FileCloseSafe( In2FH.FileHandle ) ;

     Result := True ;

     end ;


function ConvertWCPPreV62toV9(
          FileName : string   { Name of file to be converted }
          ) : Boolean ;
{ ----------------------------------------------------------
  Convert from old 16 bit to new 32 bit WCP data file format
  24/1/99 ... Now reports conversion in .LOG file
  10/5/01 ... Now handles 32 bit WinWCP V3.0 files with incorrect file version no.
  ---------------------------------------------------------- }
var
   InFH : TFileHeader ;
   OutFH : TFileHeader ;
   RH : TRecHeader ;
   i,Ch,ChIn,ChOut,Rec : Integer ;
   RawDataFile,BinaryData,OffsetBinaryData : Boolean ;
   Buf : ^TSmallIntArray ;
   s : String ;
begin

     Result := False ;

     New(Buf) ;

     { Determine from file extension (=.wcp) whether the file
     is a raw data file which must be backed up or an auxiliary
     file which can be deleted }
     if ExtractFileExt(FileName) = '.wcp' then RawDataFile := True
                                          else RawDataFile := False ;

     { Open old WCP file to be converted }
     InFH.Filename := FileName ;
     InFH.FileHandle := FileOpen( InFH.FileName, fmOpenReadWrite ) ;
     if InFH.FileHandle < 0 then begin
        Dispose(Buf) ;
        Exit ;
        end ;

     { Read file header }
     GetHeader( InFH ) ;

     { Check for WinWCP V3.0 files which have incorrect file version and prevent conversion }
     if (InFH.Version < 6.2) then begin
        BinaryData := False ;
        OffsetBinaryData := False ;
        for Rec := 1 to InFH.NumRecords do begin
            GetRecord( InFH, RH, Rec, Buf^ ) ;
            for i := 0 to (InFH.NumDataBytesPerRecord div 2)-1 do begin
                if Buf^[i] < 0 then BinaryData := True ;
                if (Buf^[i] >= 2048) and  (Buf^[i] < 4097)then OffsetBinaryData := True ;
                end ;
            end ;
        if BinaryData then InFH.Version := 8.0 ;
        if OffsetBinaryData then InFH.Version := 6.1 ;
        end ;

     { Re-scale calibration factor }
     if (InFH.Version < 6.2) then begin
        for ch := 0 to InFH.NumChannels-1 do
            Channel[ch].ADCCalibrationFactor := Channel[ch].ADCCalibrationFactor/1000.0 ;
        InFH.dt := InFH.dt*0.001 ;
        end ;

     { Copy details from old to new file header }
     OutFH := InFH ;

     OutFH.NumAnalysisBytesPerRecord := (((InFH.NumChannels-1) div 8)+1)*1024 ;
     OutFH.NumBytesInHeader := MaxBytesInFileHeader ;
     OutFH.NumBytesPerRecord := OutFH.NumAnalysisBytesPerRecord
                                + OutFH.NumDataBytesPerRecord ;

     { Create output file to hold converted records }
     OutFH.Filename := ChangeFileExt( InFH.FileName, '.TMP' ) ;
     OutFH.FileHandle := FileCreate( OutFH.FileName ) ;
     if OutFH.FileHandle < 0 then begin
        FileCloseSafe( InFH.FileHandle ) ;
        Dispose(Buf) ;
        Exit ;
        end ;

     { Copy records to new file }
     OutFH.NumRecords := 0 ;
     for Rec := 1 to InFH.NumRecords do begin

         { Read old record }
         GetRecord( InFH, RH, Rec, Buf^ ) ;

         for ChOut := 0 to InFH.NumChannels-1 do begin
             { Keep input channel within old limits }
             ChIn := MinInt([ChOut,OldChannelLimit]) ;
             { A/D converter voltage range for channel }
             RH.ADCVoltageRange[ChOut] := RH.ADCVoltageRange[ChIn] ;
             { Ensure that voltage range has a valid setting }
             if RH.ADCVoltageRange[ChOut] <= 0.0 then
                RH.ADCVoltageRange[ChOut] := RH.ADCVoltageRange[0] ;
             end ;

         // Differences between old and new equations prevent
         // the equation being carried over from the old format
         RH.AnalysisAvailable := False ;
         RH.Value[vFitEquation] := 0.0 ;

         { Write data to new record }
         Inc( OutFH.NumRecords ) ;
         { Subtract 2048 offset that was added to WCP data previous to V8.0 }
         if InFH.Version < 8.0 then begin
            for i := 0 to (OutFH.NumDataBytesPerRecord div 2)-1 do
                Buf^[i] := Buf^[i] - 2048 ;
            RH.dt := RH.dt*0.001 ;
            end ;

         PutRecord( OutFH, RH, OutFH.NumRecords, Buf^ ) ;

         // Report progress
         Main.StatusBar.SimpleText := format(
                                      'Converted %s to WinWCP V3.x format %d/%d',
                                      [FileName,Rec,InFH.NumRecords] ) ;

         end ;

     { Save file header and close files }
     SaveHeader( OutFH ) ;

     { Close files }
     FileCloseSafe( OutFH.FileHandle ) ;
     FileCloseSafe( InFH.FileHandle ) ;
     { Get rid of buffer }
     Dispose(Buf) ;

     { Give new file the same name as old and keep old as backup }

     if RawDataFile then begin
        { Keep old raw data file as backup with a .BAK extension }
        if RenameFile(InFH.FileName,ChangeFileExt(InFH.FileName,'.bak')) then begin
           InFH.FileName := ChangeFileExt(InFH.FileName,'.bak') ;
           end
        else DeleteFile( FileName ) ;
        end
     else begin
        { Delete other auxiliary files }
        DeleteFile( FileName ) ;
        end ;

     { Transfer the original name to converted file }
     if not RenameFile( OutFH.FileName, FileName ) then
        MessageDlg( ' Unable to rename ' + OutFH.FileName,mtWarning, [mbOK], 0 ) ;

     OutFH.FileName := FileName ;

     s := format( 'File %s converted to WinWCP V3.x format (Old file = %s)',
                  [FileName,ChangeFileExt(FileName,'.bak')] ) ;
     Main.StatusBar.SimpleText := s ;
     WriteToLogFile(s) ;
     Result := True ;

     end ;


function ConvertWCPV8toV9(
          FileName : string   { Name of file to be converted }
          ) : Boolean ;
// --------------------------------------------
// Converts a WCP V8 format file into V9 format
// --------------------------------------------
var
   InFH : TFileHeader ;
   OutFH : TFileHeader ;
   RH : TRecHeader ;
   ChIn,ChOut,Rec : Integer ;
   RawDataFile : Boolean ;
   Buf : ^TSmallIntArray ;
   s : String ;
begin

     Result := False ;

     { Determine from file extension (=.wcp) whether the file
     is a raw data file which must be backed up or an auxiliary
     file which can be deleted }
     if ExtractFileExt(FileName) = '.wcp' then RawDataFile := True
                                          else RawDataFile := False ;

     { Open WCP V8 file to be converted }
     InFH.Filename := FileName ;
     InFH.FileHandle := FileOpen( InFH.FileName, fmOpenReadWrite ) ;
     if InFH.FileHandle < 0 then begin
        Exit ;
        end ;

     { Read file header }
     GetHeader( InFH ) ;

     { Copy details from old to new file header }
     OutFH := InFH ;

     // Set size of analysis block based on number of channels in file
     OutFH.NumBytesInHeader := NumBytesInFileHeader(OutFH.NumChannels) ;
     OutFH.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(OutFH.NumChannels) ;
     OutFH.NumBytesPerRecord := OutFH.NumAnalysisBytesPerRecord
                                + OutFH.NumDataBytesPerRecord ;

     { Create output file to hold converted records }
     OutFH.Filename := ChangeFileExt( InFH.FileName, '.TMP' ) ;
     OutFH.FileHandle := FileCreate( OutFH.FileName ) ;
     if OutFH.FileHandle < 0 then begin
        FileCloseSafe( InFH.FileHandle ) ;
        Exit ;
        end ;

     { Copy records to new file }
     OutFH.NumRecords := 0 ;
     New(Buf) ;
     for Rec := 1 to InFH.NumRecords do begin

         { Read old record }
         GetRecordWCPV8( InFH, RH, Rec, Buf^ ) ;

         for ChOut := 0 to InFH.NumChannels-1 do begin
             { Keep input channel within old limits }
             ChIn := MinInt([ChOut,OldChannelLimit]) ;
             { A/D converter voltage range for channel }
             RH.ADCVoltageRange[ChOut] := RH.ADCVoltageRange[ChIn] ;
             { Ensure that voltage range has a valid setting }
             if RH.ADCVoltageRange[ChOut] <= 0.0 then
                RH.ADCVoltageRange[ChOut] := RH.ADCVoltageRange[0] ;
             end ;

         // Differences between old and new equations prevent
         // the equation being carried over from the old format
         RH.AnalysisAvailable := False ;
         RH.Value[vFitEquation] := 0.0 ;

         { Write data to new record }
         Inc( OutFH.NumRecords ) ;

         PutRecord( OutFH, RH, OutFH.NumRecords, Buf^ ) ;

         // Report progress
         Main.StatusBar.SimpleText := format(
                                      'Converted %s to WCP V9.0 format %d/%d',
                                      [FileName,Rec,InFH.NumRecords] ) ;

         end ;

     { Save file header and close files }
     SaveHeader( OutFH ) ;

     { Close files }
     FileCloseSafe( OutFH.FileHandle ) ;
     FileCloseSafe( InFH.FileHandle ) ;

     { Get rid of buffer }
     Dispose(Buf) ;

     { Give new file the same name as old and keep old as backup }

     if RawDataFile then begin
        { Keep old raw data file as backup with a .BAK extension }
        if RenameFile(InFH.FileName,ChangeFileExt(InFH.FileName,'.bak')) then begin
           InFH.FileName := ChangeFileExt(InFH.FileName,'.bak') ;
           end
        else DeleteFile( FileName ) ;
        end
     else begin
        { Delete other auxiliary files }
        DeleteFile( FileName ) ;
        end ;

     { Transfer the original name to converted file }
     if not RenameFile( OutFH.FileName, FileName ) then
        ShowMessage( ' Unable to rename ' + OutFH.FileName ) ;

     OutFH.FileName := FileName ;

     s := format( 'File %s converted to WCP V9.0 format (Old file = %s)',
                  [FileName,ChangeFileExt(FileName,'.bak')] ) ;
     Main.StatusBar.SimpleText := s ;
     WriteToLogFile(s) ;
     Result := True ;

     end ;



end.
