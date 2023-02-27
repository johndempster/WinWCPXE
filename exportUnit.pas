unit exportUnit;
{ ================================================================
  WinWCP (c) J. Dempster, University of Strathclyde, 1998-99
  Data file export module
  ================================================================
  5/2/00
  28/2/00 ... Change File Name now works, channel captions updated
  9/2/02 ... V2.2.6 ASCII text export added
  26/2/02 ... V2.3.0 ASCII text export now works properly
              Progress reported to main status bar
  14/08/02 ... Bug which prevented export when output file did not exist fixed  (V2.3.4)
  1/12/03 .... Export now uses TADCDataFile component
  19/04/03 ... Modified for use by WinWCP
  22/04/04 ... IGOR export added
  19/10/06 ... Now exports average and leak-subtracted as well as raw records
  18/12/06 ... Export to IGOR Binary Wave format files now works
  01/02/06 ... Exports to EDR files now scaled correctly
               A/D Voltage range differences stored within WCP records
               stored in .ChannelGain
  05.09.07 ... Bugs in export file naming fixed.
               Files can now be exported to folders with '.' in name
               new function used CreateExportFileName
  27.01.08 ... Sampling interval for export file now derived from record header
               of selected series of records. If sampling interval varies within
               exported series, a warning message is displayed
  30.05.08 ... FP Errors when RH.ADCVoltageRange = 0 fixed
  05.08.13 ... MAT file export added. Compiled under Delphi XE
  11.02.15 ... No. of exportable channels increased to 32
  04.06.15 ... Multiple files can be exported. Format now selected from drop-down liat.
  30.06.15 ... IGOR IBW files can now be exported as individual records
  13.07.15 ... WordWrap set to False to prevent file names being split across lines in
               export file selection list.
  14.08.15 ... Export of average, leak subtracted and driving function now works
  16.07.19 ... Multiple records can now be saved in columns in ASCII file output
               instead of as a series of rows.
  25.09.19 ... Combine Records option now works correctly for IGOR IBW file export.
  21.02.23 ... ExportFile.ChannelGain[chOut] now set to 1.0 to prevent double compensation
               of non-unitary channel gains when exporting. Export now terminated when
               channel gain changes within a WCP file.
               Size of export file list box increased to display more of file names
  27.02.23 ... Now uses glocal WCFFile.FH file header record rather than internal FH
               to avoid initial empty export list when records are not displayed.
  }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RangeEdit, ADCDataFile, maths, strutils, SESLabIO, MatFileWriterUnit, math, UITypes, WCPFIleUnit ;

type
  TExportFrm = class(TForm)
    GroupBox8: TGroupBox;
    rbAllRecords: TRadioButton;
    rbRange: TRadioButton;
    edRange: TRangeEdit;
    ChannelsGrp: TGroupBox;
    ckCh0: TCheckBox;
    ckCh1: TCheckBox;
    ckCh2: TCheckBox;
    ckCh3: TCheckBox;
    ckCh4: TCheckBox;
    ckCh5: TCheckBox;
    ckCh6: TCheckBox;
    ckCh7: TCheckBox;
    GroupBox3: TGroupBox;
    GroupBox2: TGroupBox;
    bChangeName: TButton;
    bOK: TButton;
    bCancel: TButton;
    ExportFile: TADCDataFile;
    ckCombineRecords: TCheckBox;
    ckCh8: TCheckBox;
    ckCh9: TCheckBox;
    ckCh10: TCheckBox;
    ckCh11: TCheckBox;
    ckCh12: TCheckBox;
    ckCh13: TCheckBox;
    ckCh14: TCheckBox;
    ckCh15: TCheckBox;
    ckCh16: TCheckBox;
    ckCh17: TCheckBox;
    ckCh18: TCheckBox;
    ckCh19: TCheckBox;
    ckCh20: TCheckBox;
    ckCh21: TCheckBox;
    ckCh22: TCheckBox;
    ckCh23: TCheckBox;
    ckCh24: TCheckBox;
    ckCh25: TCheckBox;
    ckCh26: TCheckBox;
    ckCh27: TCheckBox;
    ckCh28: TCheckBox;
    ckCh29: TCheckBox;
    ckCh30: TCheckBox;
    ckCh31: TCheckBox;
    meFileList: TMemo;
    cbExportFormat: TComboBox;
    OpenDialog: TOpenDialog;
    ckASCIIRecordsInColumns: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure bChangeNameClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure cbExportFormatChange(Sender: TObject);
  private
    { Private declarations }

    ExportExtension : Array[0..100] of String ;
    KeepFileName : String ;
    procedure SetChannel( CheckBox : TCheckBox ; ch : Integer ) ;
    function CreateExportFileName(FileName : string ) : String ;
    procedure ExportToFile( FileName : string ) ;
    procedure ExportToIGORFile( FileName : string ) ;
    procedure ExportToMATFile( FileName : string ) ;
    function UseChannel( chan : Integer ) : Boolean ;
    procedure UpdateChannelSelectionList ;
    procedure OpenDataFile( FileName : string ) ;

  public
    { Public declarations }
  end;

var
  ExportFrm: TExportFrm;

implementation

uses Mdiform ;

{$R *.DFM}


procedure TExportFrm.FormShow(Sender: TObject);
// ------------------------------
// Initialise form when displayed
// ------------------------------
begin

     Top := Main.Top + 60 ;
     Left := Main.Left + 20 ;

   //  FH := WPCFile.FH ;
     KeepFileName := WCPFile.FH.FileName ;

     { Set block of WCP file to be exported }
     edRange.LoValue := 1.0 ;
     edRange.HiLimit := WCPFile.FH.NumRecords ;
     edRange.HiValue := edRange.HiLimit ;

     // Export formats
     cbExportFormat.Clear ;
     cbExportFormat.Items.AddObject('Axon ABF V1.6',TObject(ftAxonABF)) ;
     ExportExtension[cbExportFormat.Items.Count-1] := '.abf' ;

     cbExportFormat.Items.AddObject('CED CFS',TObject(ftCFS)) ;
     ExportExtension[cbExportFormat.Items.Count-1] := '.cfs' ;

     cbExportFormat.Items.AddObject('ASCII Text',TObject(ftASC)) ;
     ExportExtension[cbExportFormat.Items.Count-1] := '.txt' ;
     cbExportFormat.Items.AddObject('Strathclyde WCP',TObject(ftWCP)) ;
     ExportExtension[cbExportFormat.Items.Count-1] := '.wcp' ;

     cbExportFormat.Items.AddObject('Strathclyde EDR',TObject(ftEDR)) ;
     ExportExtension[cbExportFormat.Items.Count-1] := '.edr' ;

     cbExportFormat.Items.AddObject('Wavemetrics IGOR IBW',TObject(ftIBW)) ;
     ExportExtension[cbExportFormat.Items.Count-1] := '.ibw' ;

     cbExportFormat.Items.AddObject('Matlab MAT',TObject(ftMAT)) ;
     ExportExtension[cbExportFormat.Items.Count-1] := '.mat' ;

     cbExportFormat.ItemIndex := 0 ;

     { Update O/P file name channel selection options }
     meFileList.Clear ;
     meFileList.Lines[0] := WCPFile.FH.FileName ;
     ckCombineRecords.Visible := False ;
     ckASCIIRecordsInColumns.Visible := False ;

     UpdateChannelSelectionList ;

     end;

procedure TExportFrm.SetChannel(
          CheckBox : TCheckBox ;
          ch : Integer
          ) ;
// ---------------------------
// Set channel selection state
// ---------------------------
begin
     if ch < WCPFile.FH.NumChannels then begin
        CheckBox.Visible := True ;
        CheckBox.Checked := WCPFile.Channel[ch].InUse ;
        CheckBox.Caption := WCPFile.Channel[ch].ADCName ;
        end
     else CheckBox.Visible := False ;
     end ;


procedure TExportFrm.ExportToFile(
          FileName : string        // Name of file to export
          ) ;
// -------------------------------------------------
// Copy selected section of data file to export file
// -------------------------------------------------
type
    TSmallIntArray1 = Array[0..9999999] of SmallInt ;
var
   StartAt,EndAt,ch,i,j : Integer ;
//   UseChannel : Array[0..WCPMaxChannels-1] of Boolean ; // Channels to be exported
   NumBytesPerBuf : Integer ;       // Buffer size
   InBuf : ^TSmallIntArray1 ;       // Source data buffer
   OutBuf : ^TSmallIntArray1 ;      // Output data buffer
   chOut : Integer ;
   iRec : Integer ;                 // Record counter
   RH : TRecHeader ;                // WCP record header
   NumRecordsExported : Integer ;
   ExportType : TADCDataFileType ;
   ExportFileName : String ;
   ScanIntervalChanged : Boolean ;
   ErrMsg : String ;
   CalFactor : Array[0..MaxChannels] of Single ;
begin

     if rbAllRecords.Checked then
        begin
        StartAt := 1 ;
        EndAt := WCPFile.FH.NumRecords ;
        end
     else
        begin
        StartAt := Min(Round(edRange.LoValue),WCPFile.FH.NumRecords) ;
        EndAt := Min(Round(edRange.HiValue),WCPFile.FH.NumRecords) ;
        end ;

     // Add record range to file name
     ExportFileName := CreateExportFileName(FileName) ;

     // If destination file already exists, allow user to abort
     if FileExists( ExportFileName ) then
        begin
        if MessageDlg( ExportFileName + ' exists! Overwrite?!',
           mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit ;
        end ;

     // Create empty export data file
     ExportType := TADCDataFileType(cbExportFormat.Items.objects[cbExportFormat.ItemIndex]);
     ExportFile.CreateDataFile( ExportFileName,ExportType ) ;

     // Set file parameters
     ExportFile.NumScansPerRecord := WCPFile.FH.NumSamples ;
     ExportFile.MaxADCValue := WCPFile.FH.MaxADCValue ;
     ExportFile.MinADCValue := WCPFile.FH.MinADCValue ;
     ExportFile.ScanInterval := WCPFile.FH.dt ;
     ExportFile.IdentLine := WCPFile.FH.IdentLine ;
     ExportFile.ABFAcquisitionMode := ftEpisodic ;
     ExportFile.ASCIISaveRecordsinColumns := ckASCIIRecordsinColumns.Checked ;

     NumBytesPerBuf := WCPFile.FH.NumSamples*WCPFile.FH.NumChannels*2 ;
     GetMem( InBuf, NumBytesPerBuf ) ;
     GetMem( OutBuf, NumBytesPerBuf ) ;

     Try

     chOut := 0 ;
     for ch := 0 to WCPFile.FH.NumChannels-1 do if UseChannel(ch) then
         begin
         ExportFile.ChannelOffset[chOut] := chOut ;
         ExportFile.ChannelADCVoltageRange[chOut] := WCPFile.FH.ADCVoltageRange ;
         ExportFile.ChannelName[chOut] := WCPFile.Channel[ch].ADCName ;
         ExportFile.ChannelUnits[chOut] := WCPFile.Channel[ch].ADCUnits ;
         ExportFile.ChannelScale[chOut] := WCPFile.Channel[ch].ADCSCale ;
         ExportFile.ChannelCalibrationFactor[chOut] := WCPFile.Channel[ch].ADCCalibrationFactor ;
         ExportFile.ChannelGain[chOut] := 1.0 ; //WCPFile.Channel[ch].ADCAmplifierGain ;
         Inc(chOut) ;
         end ;
     ExportFile.NumChannelsPerScan := chOut ;

     { Copy records }
     NumRecordsExported := 0 ;
     ScanIntervalChanged := False ;
     for ch := 0 to High(CalFactor) do CalFactor[ch] := 0.0 ;
     ExportFile.ScanInterval :=  WCPFile.FH.dt ;
     for iRec := StartAt to EndAt do
         begin

         // Read record
         WCPFile.GetRecord(WCPFile.FH,RH,iRec,InBuf^) ;

         // Skip if record rejected
         if not ANSIContainsText(RH.Status,'ACCEPTED') then continue ;

         // Copy required channels
         j := 0 ;
         for i := 0 to WCPFile.FH.NumSamples-1 do
             begin
             for ch := 0 to WCPFile.FH.NumChannels-1 do if UseChannel(ch) then
                 begin
                 OutBuf^[j] := InBuf^[(i*WCPFile.FH.NumChannels)+WCPFile.Channel[ch].ChannelOffset] ;
                 Inc(j) ;
                 end ;
             end ;

         Inc(NumRecordsExported) ;
         ExportFile.RecordNum := NumRecordsExported ;

         // Use last know dt value if record header dt invalid
         if RH.dt <= 0.0 then RH.dt := ExportFile.ScanInterval ;

         // Get time interval between channel scans
         if iRec <> StartAt then
            begin
            if ExportFile.ScanInterval <> RH.dt then ScanIntervalChanged := True ;
            end ;
         ExportFile.ScanInterval := RH.dt ;

         if ExportType = ftWCP then
            begin
            // Update record header (WCP file only)
            chOut := 0 ;
            for ch := 0 to WCPFile.FH.NumChannels-1 do if UseChannel(ch) then begin
                if RH.ADCVoltageRange[ch] = 0.0 then
                   RH.ADCVoltageRange[ch] := WCPFile.FH.ADCVoltageRange ;
                ExportFile.ChannelGain[chOut] := WCPFile.FH.ADCVoltageRange / RH.ADCVoltageRange[ch] ;
                Inc(chOut) ;
                end ;

            ExportFile.WCPNumZeroAvg := 20 ;
            ExportFile.WCPRecordAccepted := True ;
            ExportFile.WCPRecordType := 'TEST' ;
            ExportFile.WCPRecordNumber := iRec ; ;
            ExportFile.WCPRecordTime := RH.time ;

            end
         else begin
            // Adjust calibration factor for variations in channel gain (all other formats)
            chOut := 0 ;
            for ch := 0 to WCPFile.FH.NumChannels-1 do if UseChannel(ch) then
                begin
                if RH.ADCVoltageRange[ch] = 0.0 then RH.ADCVoltageRange[ch] := WCPFile.FH.ADCVoltageRange ;
                ExportFile.ChannelCalibrationFactor[chOut] := WCPFile.Channel[ch].ADCCalibrationFactor *
                                                              (WCPFile.FH.ADCVoltageRange/RH.ADCVoltageRange[ch]) ;

                // If channel gain has changed, terminate export
                if CalFactor[chOut] = 0.0 then CalFactor[chOut] := ExportFile.ChannelCalibrationFactor[chOut] ;
                if CalFactor[chOut] <> ExportFile.ChannelCalibrationFactor[chOut] then
                   begin
                   EndAt := iRec ;
                   ErrMsg := format('Warning: Ch.%d gain changed. Exported terminated at Rec.%d',[ch,iRec]) ;
                   ShowMessage( ErrMsg ) ;
                   WCPFIle.WriteToLogFile( ErrMsg ) ;
                   end;

                Inc(chOut) ;
                end ;
            end ;

         // Write to export file
         ExportFile.SaveADCBuffer( 0, WCPFile.FH.NumSamples, OutBuf^ ) ;

         // Report progress
         Main.StatusBar.SimpleText := format(
         ' EXPORT: Exporting record %d/%d to %s ',
         [iRec,EndAt,ExportFileName]) ;

         end ;

     // Close export data file
     ExportFile.CloseDataFile ;

     // Final Report
     Main.StatusBar.SimpleText := format(
     ' EXPORT: %d records exported from %s to %s ',
     [EndAt-StartAt+1,FileName,ExportFileName]) ;
     WCPFile.WriteToLogFile( Main.StatusBar.SimpleText ) ;

     if ScanIntervalChanged then begin
        ErrMsg := 'Warning: time calibration errors in exported file! Sampling interval varies within exported records.' ;
        ShowMessage( ErrMsg ) ;
        WCPFIle.WriteToLogFile( ErrMsg ) ;
        end ;

     Finally
        // Free allocated buffers
        FreeMem( InBuf ) ;
        FreeMem( OutBuf ) ;
        end ;

     end;


procedure TExportFrm.ExportToIGORFile(
          FileName : string        // Name of file to export
          ) ;
// -----------------------------------------------------------
// Copy selected section of data file to IGOR Binary Wave file
// -----------------------------------------------------------
type
    TSmallIntArray1 = Array[0..9999999] of SmallInt ;
var
   StartAt,EndAt,ch,i,j : Integer ;
//   UseChannel : Array[0..WCPMaxChannels-1] of Boolean ; // Channels to be exported
   NumBytesPerBuf : Integer ;       // Buffer size
   InBuf : ^TSmallIntArray1 ;       // Source data buffer
   OutBuf : ^TSmallIntArray1 ;      // Output data buffer
   iRec : Integer ;                 // Record counter
   RH : TRecHeader ;                // WCP record header
   NumRecordsExported : Integer ;
   ExportFileName : String ;
begin

     if rbAllRecords.Checked then begin
        StartAt := 1 ;
        EndAt := WCPFile.FH.NumRecords ;
        end
     else begin
        StartAt := Min(Round(edRange.LoValue),WCPFile.FH.NumRecords) ;
        EndAt := Min(Round(edRange.HiValue),WCPFile.FH.NumRecords) ;
        end ;

     // Set file parameters
     ExportFile.NumScansPerRecord := WCPFile.FH.NumSamples ;
     ExportFile.MaxADCValue := WCPFile.FH.MaxADCValue ;
     ExportFile.MinADCValue := WCPFile.FH.MinADCValue ;
     ExportFile.ScanInterval := WCPFile.FH.dt ;
     ExportFile.IdentLine := WCPFile.FH.IdentLine ;
     ExportFile.ABFAcquisitionMode := ftEpisodic ;

     NumBytesPerBuf := WCPFile.FH.NumSamples*WCPFile.FH.NumChannels*2 ;
     GetMem( InBuf, NumBytesPerBuf ) ;
     GetMem( OutBuf, NumBytesPerBuf ) ;

     Try

     for ch := 0 to WCPFile.FH.NumChannels-1 do if UseChannel(ch) then begin

         // Create export file name
         ExportFileName := CreateExportFileName(FileName) ;

         // Add channel
         ExportFileName := ANSIReplaceText( ExportFileName,
                                            '.ibw',
                                            format( '[%s].ibw',[WCPFile.Channel[ch].ADCName])) ;

         // If destination file already exists, allow user to abort
         if FileExists( ExportFileName ) then begin
            if MessageDlg( ExportFileName + ' exists! Overwrite?!',
               mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Break ;
            end ;

         //{ Copy records }
         NumRecordsExported := 0 ;
         for iRec := StartAt to EndAt do begin

             if ckCombineRecords.checked and (iRec = StartAt) then begin
                ExportFile.CreateDataFile( ExportFileName, ftIBW ) ;
                NumRecordsExported := 0 ;
                end
             else if not ckCombineRecords.checked then begin
                // Create empty export data file
                if iRec > StartAt then ExportFile.CloseDataFile ;
                ExportFile.CreateDataFile( ANSIReplaceText( ExportFileName,'.ibw',
                                                   format( '.%d.ibw',[iRec])), ftIBW ) ;
                NumRecordsExported := 0 ;
                end;

             // Set file parameters
             ExportFile.NumChannelsPerScan := 1 ;
             ExportFile.NumScansPerRecord := EndAt - StartAt + 1 ;
             ExportFile.MaxADCValue := WCPFile.FH.MaxADCValue ;
             ExportFile.MinADCValue := WCPFile.FH.MinADCValue ;
             ExportFile.ScanInterval := WCPFile.FH.dt ;
             ExportFile.IdentLine := WCPFile.FH.IdentLine ;
             ExportFile.RecordNum := 1 ;
             ExportFile.ABFAcquisitionMode := ftGapFree ;
             ExportFile.NumChannelsPerScan := 1 ;

             ExportFile.ChannelOffset[0] := 0 ;
             ExportFile.ChannelADCVoltageRange[0] := WCPFile.FH.ADCVoltageRange ;
             ExportFile.ChannelName[0] := WCPFile.Channel[ch].ADCName ;
             ExportFile.ChannelUnits[0] := WCPFile.Channel[ch].ADCUnits ;
             ExportFile.ChannelScale[0] := WCPFile.Channel[ch].ADCSCale ;
             ExportFile.ChannelCalibrationFactor[0] := WCPFile.Channel[ch].ADCCalibrationFactor ;
             ExportFile.ChannelGain[0] := WCPFile.Channel[ch].ADCAmplifierGain ;

             // Read record
            WCPFile.GetRecord(WCPFile.FH,RH,iRec,InBuf^) ;

            // Copy required channel
            j := WCPFile.Channel[ch].ChannelOffset ;
            for i := 0 to WCPFile.FH.NumSamples-1 do begin
                OutBuf^[i] := InBuf^[j] ;
                 j := j + WCPFile.FH.NumChannels ;
                 end ;

            Inc(NumRecordsExported) ;
            ExportFile.RecordNum := NumRecordsExported ;

            // Adjust calibration factor for variations in channel gain (all other formats)
            ExportFile.ChannelCalibrationFactor[0] := WCPFile.Channel[ch].ADCCalibrationFactor *
                                                      (WCPFile.FH.ADCVoltageRange/RH.ADCVoltageRange[ch]) ;
            ExportFile.ScanInterval := RH.dt ;

            // Write to export file
            ExportFile.SaveADCBuffer( 0, WCPFile.FH.NumSamples, OutBuf^ ) ;

            // Report progress
            Main.StatusBar.SimpleText := format(
            ' EXPORT: Exporting record %d/%d to %s ',
            [iRec,EndAt,FileName]) ;
            end ;

         // Close export data file
         ExportFile.CloseDataFile ;

         // Final Report
         Main.StatusBar.SimpleText := format(
         ' EXPORT: %d records exported from %s to %s ',
         [EndAt-StartAt+1,FileName,ExportFileName]) ;
         WCPFile.WriteToLogFile( Main.StatusBar.SimpleText ) ;

         end ;

     Finally
        // Free allocated buffers
        FreeMem( InBuf ) ;
        FreeMem( OutBuf ) ;
        end ;

     end;


procedure TExportFrm.ExportToMATFile(
          FileName : string        // Name of file to export
          ) ;
// -------------------------------------------------
// Copy selected records to MATLab .MAT file
// -------------------------------------------------
var
   ch,i,iT,iY : Integer ;
   InBuf : PSmallIntArray ;       // Source data buffer
   YBuf : PDoubleArray ;      // Output data buffer
   TBuf : PDoubleArray ;      // Output data buffer
   iRec,StartAt,EndAt : Integer ;                 // Record counter
   NumRecordsToExport,NumChannelsToExport,NumRecordsExported,NumChannelsExported : Integer ;
   Writer : TMATFileWriter ;
   NumSamplesPerBuf : Integer ;
   ExportFileName : String ;
   RH : TRecHeader ;                // WCP record header
begin

     if rbAllRecords.Checked then begin
        StartAt := 1 ;
        EndAt := WCPFile.FH.NumRecords ;
        end
     else begin
        StartAt := Min(Round(edRange.LoValue),WCPFile.FH.NumRecords) ;
        EndAt := Min(Round(edRange.HiValue),WCPFile.FH.NumRecords) ;
        end ;

     // Add record range to file name
     ExportFileName := CreateExportFileName(FileName) ;

     // Get no. of channels exported
     NumChannelsToExport := 0 ;
     for ch := 0 to WCPFile.FH.NumChannels-1 do if UseChannel(ch) then Inc(NumChannelsToExport) ;

     if ckCombineRecords.Checked then begin
        NumRecordsToExport := 0 ;
        for iRec := StartAt to EndAt do begin
            WCPFile.GetRecordHeaderOnly(WCPFile.FH,RH,iRec) ;
           if ANSIContainsText(RH.Status,'ACCEPTED') then Inc(NumRecordsToExport) ;
            end ;
        end
     else begin
        NumRecordsToExport := 1 ;
        end ;

     NumSamplesPerBuf := WCPFile.FH.NumSamplesPerRecord*WCPFile.FH.NumChannels ;
     GetMem( InBuf, NumSamplesPerBuf*2 ) ;
     GetMem( YBuf, NumSamplesPerBuf*8*NumRecordsToExport ) ;
     GetMem( TBuf, (NumSamplesPerBuf div WCPFile.FH.NumChannels)*8*NumRecordsToExport ) ;

     Writer := TMATFileWriter.Create();
     Writer.OpenMATFile( ExportFileName ) ;
     Writer.WriteFileHeader;

     Try

     { Copy records }
     NumRecordsExported := 0 ;
     iT := 0 ;
     //iY := 0 ;
     for iRec := StartAt to EndAt do begin

         // Read record
         WCPFile.GetRecord(WCPFile.FH,RH,iRec,InBuf^) ;

         // Skip if record rejected
         if not ANSIContainsText(RH.Status,'ACCEPTED') then continue ;

         // Write time vector
         if not ckCombineRecords.Checked then iT := 0 ;
         for i := 0 to WCPFile.FH.NumSamples-1 do begin
             TBuf^[iT] := iT*RH.dt ;
             Inc(iT) ;
             end ;
         if not ckCombineRecords.Checked then begin
            Writer.WriteDoubleMatrixHeader(format('T%d',[iRec]),WCPFile.FH.NumSamples,1);
            Writer.WriteDoubleMatrixValues( TBuf^, WCPFile.FH.NumSamples,1) ;
            NumRecordsExported := 0 ;
            end ;

         // Copy required channels
         NumChannelsExported := 0 ;
         for ch := 0 to WCPFile.FH.NumChannels-1 do if UseChannel(ch) then begin
             iY := (NumRecordsExported + NumChannelsExported*NumRecordsToExport)*WCPFile.FH.NumSamples ;
             for i := 0 to WCPFile.FH.NumSamples-1 do begin
                 YBuf^[iY] := (InBuf^[(i*WCPFile.FH.NumChannels)+WCPFile.Channel[ch].ChannelOffset]
                                - WCPFile.Channel[ch].ADCZero)*WCPFile.Channel[ch].ADCSCale ;
                 Inc(iY) ;
                 end ;
             Inc(NumChannelsExported) ;
             end ;

         if not ckCombineRecords.Checked then begin
            Writer.WriteDoubleMatrixHeader( format('Y%d',[iRec]),
                                            WCPFile.FH.NumSamples,NumChannelsToExport);
            Writer.WriteDoubleMatrixValues( YBuf^, WCPFile.FH.NumSamples,NumChannelsToExport) ;
            end ;

         // Report progress
         Main.StatusBar.SimpleText := format(
         ' EXPORT: Exporting record %d/%d to %s ',
         [iRec,EndAt,ExportFileName]) ;

         Inc(NumRecordsExported) ;

         end ;

     if ckCombineRecords.Checked then begin
        Writer.WriteDoubleMatrixHeader('T',WCPFile.FH.NumSamples*NumRecordsToExport,1);
        Writer.WriteDoubleMatrixValues( TBuf^,WCPFile.FH.NumSamples*NumRecordsToExport,1) ;
        Writer.WriteDoubleMatrixHeader('Y',WCPFile.FH.NumSamples*NumRecordsToExport,NumChannelsToExport);
        Writer.WriteDoubleMatrixValues( YBuf^, WCPFile.FH.NumSamples*NumRecordsToExport,NumChannelsToExport) ;
        end ;

     // Final Report
     Main.StatusBar.SimpleText := format(
     ' EXPORT: %d records exported from %s to %s ',
     [EndAt-StartAt+1,FileName,ExportFileName]) ;
     WCPFile.WriteToLogFile( Main.StatusBar.SimpleText ) ;

     Finally
        // Free allocated buffers
        FreeMem( InBuf ) ;
        FreeMem( YBuf ) ;
        FreeMem( TBuf ) ;
        // Close export data file
        Writer.CloseMATFile;
        end ;

     end;


procedure TExportFrm.bChangeNameClick(Sender: TObject);
{ ------------------------
  Select files for export
  ------------------------ }
begin

     OpenDialog.DefaultExt := '.wcp' ;
     OpenDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist,ofAllowMultiSelect] ;
     OpenDialog.Filter := ' Files (*' + OpenDialog.DefaultExt + ')|*' +
                            OpenDialog.DefaultExt + '|' ;

     //OpenDialog.FileName := ChangeFileExt(BaseExportFileName,ExportFileExt) ;
     OpenDialog.Title := 'Select Files to Export ' ;
     if WCPFile.Settings.DataDirectory <> '' then begin
        SetCurrentDir(WCPFile.Settings.DataDirectory);
        OpenDialog.InitialDir := WCPFile.Settings.DataDirectory ;
        end;

     if OpenDialog.Execute then begin
        meFileList.Lines.Assign(OpenDialog.Files);
        UpdateChannelSelectionList ;
        end;

     end;


function TExportFrm.CreateExportFileName(
         FileName : string
         ) : String ;
// ---------------------------------------------------
// Update control WCPFile.Settings when export format changed
// ---------------------------------------------------
var
    StartAt,EndAt,ch : Integer ;
    s : string ;
begin

     // Add record range to file name
     if rbAllRecords.Checked then begin
        StartAt := 1 ;
        EndAt := WCPFile.FH.NumRecords ;
        end
     else begin
        StartAt := Round(edRange.LoValue) ;
        EndAt := Round(edRange.HiValue) ;
        end ;

     // Set file extension to .tmp to locate end of file later
     FileName := ChangeFileExt( FileName, '.tmp' ) ;

    // Add raw/average/leak subtraction/driving function
    if Main.mnShowAveraged.checked then
       FileName := ANSIReplaceText( FileName,'.tmp','[AVG].tmp' )
    else if Main.mnShowLeakSubtracted.checked then
       FileName := ANSIReplaceText( FileName,'.tmp','[SUB].tmp' )
    else if Main.mnShowDrivingFunction.checked then
       FileName := ANSIReplaceText( FileName,'.tmp','[DFN].tmp' ) ;

     // Add record range
     FileName := ANSIReplaceText( FileName,
                                  '.tmp',
                                  format('[%d-%d].tmp',[StartAt,EndAt]) ) ;

     // Add channels for ASCII text export
     if TADCDataFileType(cbExportFormat.Items.objects[cbExportFormat.ItemIndex])=ftASC then begin
        s := '[' ;
        for ch := 0 to WCPFile.FH.NumChannels-1 do if UseChannel(ch) then begin
            s := s + WCPFile.Channel[ch].ADCName + ',' ;
            end;
        s := LeftStr(s,Length(s)-1)+'].tmp' ;
        FileName := ANSIReplaceText( FileName,'.tmp',s);
        end;

     FileName := ChangeFileExt( FileName, ExportExtension[cbExportFormat.ItemIndex] ) ;

     Result := FileName ;

     end ;


procedure TExportFrm.bOKClick(Sender: TObject);
// ----------------------
// Export to output file
// ----------------------
var
    ExportType : TADCDataFileType ;
    FileName : string ;
    i : Integer ;
begin

    ExportType := TADCDataFileType(cbExportFormat.Items.objects[cbExportFormat.ItemIndex]);

    // Close currently open data file
    WCPFile.CloseAllDataFiles ;

    for i := 0 to meFileList.Lines.Count-1 do begin

        FileName := meFileList.Lines[i] ;
        OpenDataFile(FileName) ;

        case ExportType of
             ftIBW : ExportToIGORFile(FileName) ;
             ftMAT : ExportToMATFile(FileName) ;
             else ExportToFile(FileName) ;
             end ;

        WCPFile.CloseAllDataFiles ;

        end;

    OpenDataFile(KeepFileName) ;

    end ;


procedure TExportFrm.OpenDataFile(
          FileName : string        // Name of file to open
          ) ;
// --------------
// Open data file
// --------------
begin
     WCPFile.OpenAssociateFile(WCPFIle.RawFH,FileName,'.wcp') ;
     WCPFile.OpenAssociateFile(WCPFIle.AvgFH,FileName,'.avg') ;
     WCPFile.OpenAssociateFile(WCPFIle.LeakFH,FileName,'.sub') ;
     WCPFile.OpenAssociateFile(WCPFIle.DrvFH,FileName,'.dfn') ;
     if Main.mnShowRaw.checked then WCPFile.FH := WCPFIle.RawFH ;
     if Main.mnShowAveraged.checked then WCPFile.FH := WCPFIle.AvgFH ;
     if Main.mnShowDrivingFunction.checked then WCPFile.FH := WCPFIle.DrvFH ;
     if Main.mnShowLeakSubtracted.checked then WCPFile.FH := WCPFIle.LeakFH ;
     end;


procedure TExportFrm.cbExportFormatChange(Sender: TObject);
// ---------------------
// Output format changed
// ---------------------
var
    ExportType : TADCDataFileType ;
begin

   ExportType := TADCDataFileType(cbExportFormat.Items.objects[cbExportFormat.ItemIndex]);
   case ExportType of
     ftMat,ftIBW : begin
       ckCombineRecords.Visible := true ;
       ckASCIIRecordsInColumns.Visible := False ;
       end;
     ftASC : begin
       ckCombineRecords.Visible := true ;
       ckASCIIRecordsInColumns.Visible := True ;
       end;
     else begin
       ckCombineRecords.Visible := False ;
       ckASCIIRecordsInColumns.Visible := False ;
       end;
     end ;
   end;


function TExportFrm.UseChannel( chan : Integer ) : Boolean ;
// ---------------------------------------------
// Return TRUE if channel is selected for export
// ---------------------------------------------
begin
    case Chan of
      0 : Result := ckCh0.Checked or (not ckCh0.Visible) ;
      1 : Result := ckCh1.Checked or (not ckCh1.Visible) ;
      2 : Result := ckCh2.Checked or (not ckCh2.Visible) ;
      3 : Result := ckCh3.Checked or (not ckCh3.Visible) ;
      4 : Result := ckCh4.Checked or (not ckCh4.Visible) ;
      5 : Result := ckCh5.Checked or (not ckCh5.Visible) ;
      6 : Result := ckCh6.Checked or (not ckCh6.Visible) ;
      7 : Result := ckCh7.Checked or (not ckCh7.Visible) ;
      8 : Result := ckCh8.Checked or (not ckCh8.Visible) ;
      9 : Result := ckCh9.Checked or (not ckCh9.Visible) ;
      10 : Result := ckCh10.Checked or (not ckCh10.Visible) ;
      11 : Result := ckCh11.Checked or (not ckCh11.Visible) ;
      12 : Result := ckCh12.Checked or (not ckCh12.Visible) ;
      13 : Result := ckCh13.Checked or (not ckCh13.Visible) ;
      14 : Result := ckCh14.Checked or (not ckCh14.Visible) ;
      15 : Result := ckCh15.Checked or (not ckCh15.Visible) ;
      16 : Result := ckCh16.Checked or (not ckCh16.Visible) ;
      17 : Result := ckCh17.Checked or (not ckCh17.Visible) ;
      18 : Result := ckCh18.Checked or (not ckCh18.Visible) ;
      19 : Result := ckCh19.Checked or (not ckCh19.Visible) ;
      20 : Result := ckCh20.Checked or (not ckCh20.Visible) ;
      21 : Result := ckCh21.Checked or (not ckCh21.Visible) ;
      22 : Result := ckCh22.Checked or (not ckCh22.Visible) ;
      23 : Result := ckCh23.Checked or (not ckCh23.Visible) ;
      24 : Result := ckCh24.Checked or (not ckCh24.Visible) ;
      25 : Result := ckCh25.Checked or (not ckCh25.Visible) ;
      26 : Result := ckCh26.Checked or (not ckCh26.Visible) ;
      27 : Result := ckCh27.Checked or (not ckCh27.Visible) ;
      28 : Result := ckCh28.Checked or (not ckCh28.Visible) ;
      29 : Result := ckCh29.Checked or (not ckCh29.Visible) ;
      30 : Result := ckCh30.Checked or (not ckCh30.Visible) ;
      31 : Result := ckCh31.Checked or (not ckCh31.Visible) ;
      Else Result := True ;
      end;
    end;


procedure TExportFrm.UpdateChannelSelectionList ;
// --------------------------------------
// Update list of channel selection boxes
// --------------------------------------
begin

     WCPFile.CloseAllDataFiles ;
     OpenDataFile( meFileList.Lines[0] ) ;

     SetChannel( ckCh0, 0 ) ;
     SetChannel( ckCh1, 1 ) ;
     SetChannel( ckCh2, 2 ) ;
     SetChannel( ckCh3, 3 ) ;
     SetChannel( ckCh4, 4 ) ;
     SetChannel( ckCh5, 5 ) ;
     SetChannel( ckCh6, 6 ) ;
     SetChannel( ckCh7, 7 ) ;
     SetChannel( ckCh8, 8 ) ;
     SetChannel( ckCh9, 9 ) ;
     SetChannel( ckCh10, 10 ) ;
     SetChannel( ckCh11, 11 ) ;
     SetChannel( ckCh12, 12 ) ;
     SetChannel( ckCh13, 13 ) ;
     SetChannel( ckCh14, 14 ) ;
     SetChannel( ckCh15, 15 ) ;
     SetChannel( ckCh16, 16 ) ;
     SetChannel( ckCh17, 17 ) ;
     SetChannel( ckCh18, 18 ) ;
     SetChannel( ckCh19, 19 ) ;
     SetChannel( ckCh20, 20 ) ;
     SetChannel( ckCh21, 21 ) ;
     SetChannel( ckCh22, 22 ) ;
     SetChannel( ckCh23, 23 ) ;
     SetChannel( ckCh24, 24 ) ;
     SetChannel( ckCh25, 25 ) ;
     SetChannel( ckCh26, 26 ) ;
     SetChannel( ckCh27, 27 ) ;
     SetChannel( ckCh28, 28 ) ;
     SetChannel( ckCh29, 29 ) ;
     SetChannel( ckCh30, 30 ) ;
     SetChannel( ckCh31, 31 ) ;

     WCPFile.CloseAllDataFiles ;
     OpenDataFile(KeepFileName) ;

     end ;

end.
