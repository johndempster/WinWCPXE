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

  }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RangeEdit, global, ADCDataFile, maths, strutils, SESLabIO, MatFileWriterUnit, math, UITypes ;

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
    edFileName: TEdit;
    GroupBox2: TGroupBox;
    rbABF: TRadioButton;
    rbCFS: TRadioButton;
    bChangeName: TButton;
    bOK: TButton;
    bCancel: TButton;
    SaveDialog: TSaveDialog;
    rbASCII: TRadioButton;
    rbEDR: TRadioButton;
    ExportFile: TADCDataFile;
    rbWCP: TRadioButton;
    rbIGOR: TRadioButton;
    rbMAT: TRadioButton;
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
    procedure FormShow(Sender: TObject);
    procedure bChangeNameClick(Sender: TObject);
    procedure rbABFClick(Sender: TObject);
    procedure rbLDTClick(Sender: TObject);
    procedure rbCFSClick(Sender: TObject);
    procedure rbASCIIClick(Sender: TObject);
    procedure rbEDRClick(Sender: TObject);
    procedure k(Sender: TObject);
    procedure rbIGORClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure rbRangeClick(Sender: TObject);
    procedure rbAllRecordsClick(Sender: TObject);
    procedure edRangeKeyPress(Sender: TObject; var Key: Char);
    procedure rbWCPClick(Sender: TObject);
    procedure rbMATClick(Sender: TObject);
  private
    { Private declarations }
    BaseExportFileName : string ;
    procedure SetChannel( CheckBox : TCheckBox ; ch : Integer ) ;
    function CreateExportFileName(FileName : string ) : String ;

    procedure ExportToFile;
    procedure ExportToIGORFile;
    procedure ExportToMATFile ;
  public
    { Public declarations }
  end;

var
  ExportFrm: TExportFrm;

implementation

uses Mdiform, fileio ;

{$R *.DFM}


procedure TExportFrm.FormShow(Sender: TObject);
// ------------------------------
// Initialise form when displayed
// ------------------------------
begin

     Top := Main.Top + 60 ;
     Left := Main.Left + 20 ;

     { Set block of EDR file to be exported }
     edRange.LoValue := 1.0 ;
     edRange.HiLimit := FH.NumRecords ;
     edRange.HiValue := edRange.HiLimit ;

     { Update O/P file name channel selection options }
     BaseExportFileName := FH.FileName ;
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     ChannelsGrp.Enabled := True ;
     ckCombineRecords.Visible := rbMat.Checked ;

     end;


procedure TExportFrm.SetChannel(
          CheckBox : TCheckBox ;
          ch : Integer
          ) ;
// ---------------------------
// Set channel selection state
// ---------------------------
begin
     if ch < FH.NumChannels then begin
        CheckBox.Visible := True ;
        CheckBox.Checked := Channel[ch].InUse ;
        CheckBox.Caption := Channel[ch].ADCName ;
        end
     else CheckBox.Visible := False ;
     end ;


procedure TExportFrm.ExportToFile;
// -------------------------------------------------
// Copy selected section of data file to export file
// -------------------------------------------------
type
    TSmallIntArray1 = Array[0..9999999] of SmallInt ;
var
   StartAt,EndAt,ch,i,j : Integer ;
   UseChannel : Array[0..WCPMaxChannels-1] of Boolean ; // Channels to be exported
   NumBytesPerBuf : Integer ;       // Buffer size
   InBuf : ^TSmallIntArray1 ;       // Source data buffer
   OutBuf : ^TSmallIntArray1 ;      // Output data buffer
   chOut : Integer ;
   iRec : Integer ;                 // Record counter
   RH : TRecHeader ;                // WCP record header
   NumRecordsExported : Integer ;
   ExportType : TADCDataFileType ;
   FileName : String ;
   ScanIntervalChanged : Boolean ;
   ErrMsg : String ;
begin

     if rbAllRecords.Checked then begin
        StartAt := 1 ;
        EndAt := FH.NumRecords ;
        end
     else begin
        StartAt := Round(edRange.LoValue) ;
        EndAt := Round(edRange.HiValue) ;
        end ;

     // Channels to be exported
     UseChannel[0] :=  ckCh0.Checked ;
     UseChannel[1] :=  ckCh1.Checked ;
     UseChannel[2] :=  ckCh2.Checked ;
     UseChannel[3] :=  ckCh3.Checked ;
     UseChannel[4] :=  ckCh4.Checked ;
     UseChannel[5] :=  ckCh5.Checked ;
     UseChannel[6] :=  ckCh6.Checked ;
     UseChannel[7] :=  ckCh7.Checked ;
     UseChannel[8] :=  ckCh8.Checked ;
     UseChannel[9] :=  ckCh9.Checked ;
     UseChannel[10] :=  ckCh10.Checked ;
     UseChannel[11] :=  ckCh11.Checked ;
     UseChannel[12] :=  ckCh12.Checked ;
     UseChannel[13] :=  ckCh13.Checked ;
     UseChannel[14] :=  ckCh14.Checked ;
     UseChannel[15] :=  ckCh15.Checked ;
     UseChannel[16] :=  ckCh16.Checked ;
     UseChannel[17] :=  ckCh17.Checked ;
     UseChannel[18] :=  ckCh18.Checked ;
     UseChannel[19] :=  ckCh19.Checked ;
     UseChannel[20] :=  ckCh20.Checked ;
     UseChannel[21] :=  ckCh21.Checked ;
     UseChannel[22] :=  ckCh22.Checked ;
     UseChannel[23] :=  ckCh23.Checked ;
     UseChannel[24] :=  ckCh24.Checked ;
     UseChannel[25] :=  ckCh25.Checked ;
     UseChannel[26] :=  ckCh26.Checked ;
     UseChannel[27] :=  ckCh27.Checked ;
     UseChannel[28] :=  ckCh28.Checked ;
     UseChannel[29] :=  ckCh29.Checked ;
     UseChannel[30] :=  ckCh30.Checked ;
     UseChannel[31] :=  ckCh31.Checked ;

     // Add record range to file name
     FileName := CreateExportFileName(BaseExportFileName) ;

     // If destination file already exists, allow user to abort
     if FileExists( FileName ) then begin
        if MessageDlg( FileName + ' exists! Overwrite?!',
           mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit ;
        end ;

     // Export file type
     if rbABF.Checked then ExportType := ftAxonABF
     else if rbASCII.Checked then ExportType := ftASC
     else if rbCFS.Checked then ExportType := ftCFS
     else if rbEDR.Checked then ExportType := ftEDR
     else ExportType := ftWCP ;

     // Create empty export data file
     ExportFile.CreateDataFile( FileName,
                                ExportType ) ;

     // Set file parameters
     ExportFile.NumScansPerRecord := FH.NumSamples ;
     ExportFile.MaxADCValue := FH.MaxADCValue ;
     ExportFile.MinADCValue := FH.MinADCValue ;
     ExportFile.ScanInterval := FH.dt ;
     ExportFile.IdentLine := FH.IdentLine ;
     ExportFile.ABFAcquisitionMode := ftEpisodic ;

     NumBytesPerBuf := FH.NumSamples*FH.NumChannels*2 ;
     GetMem( InBuf, NumBytesPerBuf ) ;
     GetMem( OutBuf, NumBytesPerBuf ) ;

     Try

     chOut := 0 ;
     for ch := 0 to FH.NumChannels-1 do if UseChannel[ch] then begin
         ExportFile.ChannelOffset[chOut] := chOut ;
         ExportFile.ChannelADCVoltageRange[chOut] := FH.ADCVoltageRange ;
         ExportFile.ChannelName[chOut] := Channel[ch].ADCName ;
         ExportFile.ChannelUnits[chOut] := Channel[ch].ADCUnits ;
         ExportFile.ChannelScale[chOut] := Channel[ch].ADCSCale ;
         ExportFile.ChannelCalibrationFactor[chOut] := Channel[ch].ADCCalibrationFactor ;
         ExportFile.ChannelGain[chOut] := Channel[ch].ADCAmplifierGain ;
         Inc(chOut) ;
         end ;
     ExportFile.NumChannelsPerScan := chOut ;

     { Copy records }
     NumRecordsExported := 0 ;
     ScanIntervalChanged := False ;
     ExportFile.ScanInterval :=  FH.dt ;
     for iRec := StartAt to EndAt do begin

         // Read record
         GetRecord(FH,RH,iRec,InBuf^) ;

         // Skip if record rejected
         if not ANSIContainsText(RH.Status,'ACCEPTED') then continue ;

         // Copy required channels
         j := 0 ;
         for i := 0 to FH.NumSamples-1 do begin
             for ch := 0 to FH.NumChannels-1 do if UseChannel[ch] then begin
                 OutBuf^[j] := InBuf^[(i*FH.NumChannels)+Channel[ch].ChannelOffset] ;
                 Inc(j) ;
                 end ;
             end ;

         Inc(NumRecordsExported) ;
         ExportFile.RecordNum := NumRecordsExported ;

         // Use last know dt value if record header dt invalid
         if RH.dt <= 0.0 then RH.dt := ExportFile.ScanInterval ;

         // Get time interval between channel scans
         if iRec <> StartAt then begin
            if ExportFile.ScanInterval <> RH.dt then ScanIntervalChanged := True ;
            end ;
         ExportFile.ScanInterval := RH.dt ;

         if ExportType = ftWCP then begin
            // Update record header (WCP file only)
            chOut := 0 ;
            for ch := 0 to FH.NumChannels-1 do if UseChannel[ch] then begin
                if RH.ADCVoltageRange[ch] = 0.0 then
                   RH.ADCVoltageRange[ch] := FH.ADCVoltageRange ;
                ExportFile.ChannelGain[chOut] := FH.ADCVoltageRange /
                                                 RH.ADCVoltageRange[ch] ;
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
            for ch := 0 to FH.NumChannels-1 do if UseChannel[ch] then begin
                if RH.ADCVoltageRange[ch] = 0.0 then RH.ADCVoltageRange[ch] := FH.ADCVoltageRange ;
                ExportFile.ChannelCalibrationFactor[chOut] := Channel[ch].ADCCalibrationFactor *
                                                              (FH.ADCVoltageRange/RH.ADCVoltageRange[ch]) ;
                Inc(chOut) ;
                end ;
            end ;

         // Write to export file
         ExportFile.SaveADCBuffer( 0, FH.NumSamples, OutBuf^ ) ;

         // Report progress
         Main.StatusBar.SimpleText := format(
         ' EXPORT: Exporting record %d/%d to %s ',
         [iRec,EndAt,FileName]) ;

         end ;

     // Close export data file
     ExportFile.CloseDataFile ;

     // Final Report
     Main.StatusBar.SimpleText := format(
     ' EXPORT: %d records exported to %s ',
     [EndAt-StartAt+1,FileName]) ;
     WriteToLogFile( Main.StatusBar.SimpleText ) ;

     if ScanIntervalChanged then begin
        ErrMsg := 'Warning: time calibration errors in exported file! Sampling interval varies within exported records.' ;
        ShowMessage( ErrMsg ) ;
        WriteToLogFile( ErrMsg ) ;
        end ;

     Finally
        // Free allocated buffers
        FreeMem( InBuf ) ;
        FreeMem( OutBuf ) ;
        end ;

     end;


procedure TExportFrm.ExportToIGORFile;
// -----------------------------------------------------------
// Copy selected section of data file to IGOR Binary Wave file
// -----------------------------------------------------------
type
    TSmallIntArray1 = Array[0..9999999] of SmallInt ;
var
   StartAt,EndAt,ch,i,j : Integer ;
   UseChannel : Array[0..WCPMaxChannels-1] of Boolean ; // Channels to be exported
   NumBytesPerBuf : Integer ;       // Buffer size
   InBuf : ^TSmallIntArray1 ;       // Source data buffer
   OutBuf : ^TSmallIntArray1 ;      // Output data buffer
   iRec : Integer ;                 // Record counter
   RH : TRecHeader ;                // WCP record header
   NumRecordsExported : Integer ;
   FileName : String ;
begin


     if rbAllRecords.Checked then begin
        StartAt := 1 ;
        EndAt := FH.NumRecords ;
        end
     else begin
        StartAt := Round(edRange.LoValue) ;
        EndAt := Round(edRange.HiValue) ;
        end ;

     // Channels to be exported
     UseChannel[0] :=  ckCh0.Checked ;
     UseChannel[1] :=  ckCh1.Checked ;
     UseChannel[2] :=  ckCh2.Checked ;
     UseChannel[3] :=  ckCh3.Checked ;
     UseChannel[4] :=  ckCh4.Checked ;
     UseChannel[5] :=  ckCh5.Checked ;
     UseChannel[6] :=  ckCh6.Checked ;
     UseChannel[7] :=  ckCh7.Checked ;
     UseChannel[8] :=  ckCh8.Checked ;
     UseChannel[9] :=  ckCh9.Checked ;
     UseChannel[10] :=  ckCh10.Checked ;
     UseChannel[11] :=  ckCh11.Checked ;
     UseChannel[12] :=  ckCh12.Checked ;
     UseChannel[13] :=  ckCh13.Checked ;
     UseChannel[14] :=  ckCh14.Checked ;
     UseChannel[15] :=  ckCh15.Checked ;
     UseChannel[16] :=  ckCh16.Checked ;
     UseChannel[17] :=  ckCh17.Checked ;
     UseChannel[18] :=  ckCh18.Checked ;
     UseChannel[19] :=  ckCh19.Checked ;
     UseChannel[20] :=  ckCh20.Checked ;
     UseChannel[21] :=  ckCh21.Checked ;
     UseChannel[22] :=  ckCh22.Checked ;
     UseChannel[23] :=  ckCh23.Checked ;
     UseChannel[24] :=  ckCh24.Checked ;
     UseChannel[25] :=  ckCh25.Checked ;
     UseChannel[26] :=  ckCh26.Checked ;
     UseChannel[27] :=  ckCh27.Checked ;
     UseChannel[28] :=  ckCh28.Checked ;
     UseChannel[29] :=  ckCh29.Checked ;
     UseChannel[30] :=  ckCh30.Checked ;
     UseChannel[31] :=  ckCh31.Checked ;

     // Set file parameters
     ExportFile.NumScansPerRecord := FH.NumSamples ;
     ExportFile.MaxADCValue := FH.MaxADCValue ;
     ExportFile.MinADCValue := FH.MinADCValue ;
     ExportFile.ScanInterval := FH.dt ;
     ExportFile.IdentLine := FH.IdentLine ;
     ExportFile.ABFAcquisitionMode := ftEpisodic ;

     NumBytesPerBuf := FH.NumSamples*FH.NumChannels*2 ;
     GetMem( InBuf, NumBytesPerBuf ) ;
     GetMem( OutBuf, NumBytesPerBuf ) ;

     Try

     for ch := 0 to FH.NumChannels-1 do if UseChannel[ch] then begin

         // Create export file name
         FileName := CreateExportFileName(BaseExportFileName) ;

         // Add channel
         FileName := ANSIReplaceText( FileName,
                                      '.ibw',
                                     format( '[%s].ibw',[Channel[ch].ADCName])) ;

         // If destination file already exists, allow user to abort
         if FileExists( FileName ) then begin
            if MessageDlg( FileName + ' exists! Overwrite?!',
               mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Break ;
            end ;

         // Create empty export data file
         ExportFile.CreateDataFile( FileName, ftIBW ) ;

         // Set file parameters
         ExportFile.NumChannelsPerScan := 1 ;
         ExportFile.NumScansPerRecord := EndAt - StartAt + 1 ;
         ExportFile.MaxADCValue := FH.MaxADCValue ;
         ExportFile.MinADCValue := FH.MinADCValue ;
         ExportFile.ScanInterval := FH.dt ;
         ExportFile.IdentLine := FH.IdentLine ;
         ExportFile.RecordNum := 1 ;
         ExportFile.ABFAcquisitionMode := ftGapFree ;
         ExportFile.NumChannelsPerScan := 1 ;

         ExportFile.ChannelOffset[0] := 0 ;
         ExportFile.ChannelADCVoltageRange[0] := FH.ADCVoltageRange ;
         ExportFile.ChannelName[0] := Channel[ch].ADCName ;
         ExportFile.ChannelUnits[0] := Channel[ch].ADCUnits ;
         ExportFile.ChannelScale[0] := Channel[ch].ADCSCale ;
         ExportFile.ChannelCalibrationFactor[0] := Channel[ch].ADCCalibrationFactor ;
         ExportFile.ChannelGain[0] := Channel[ch].ADCAmplifierGain ;

         //{ Copy records }
         NumRecordsExported := 0 ;
         for iRec := StartAt to EndAt do begin

             // Read record
            GetRecord(FH,RH,iRec,InBuf^) ;

            // Copy required channel
            j := Channel[ch].ChannelOffset ;
            for i := 0 to FH.NumSamples-1 do begin
                OutBuf^[i] := InBuf^[j] ;
                 j := j + FH.NumChannels ;
                 end ;

            Inc(NumRecordsExported) ;
            ExportFile.RecordNum := NumRecordsExported ;

            // Adjust calibration factor for variations in channel gain (all other formats)
            ExportFile.ChannelCalibrationFactor[0] := Channel[ch].ADCCalibrationFactor *
                                                      (FH.ADCVoltageRange/RH.ADCVoltageRange[ch]) ;
            ExportFile.ScanInterval := RH.dt ;

            // Write to export file
            ExportFile.SaveADCBuffer( 0, FH.NumSamples, OutBuf^ ) ;

            // Report progress
            Main.StatusBar.SimpleText := format(
            ' EXPORT: Exporting record %d/%d to %s ',
            [iRec,EndAt,FileName]) ;
            end ;

         // Close export data file
         ExportFile.CloseDataFile ;

         // Final Report
         Main.StatusBar.SimpleText := format(
         ' EXPORT: %d records exported to %s ',
         [EndAt-StartAt+1,FileName]) ;
         WriteToLogFile( Main.StatusBar.SimpleText ) ;

         end ;

     Finally
        // Free allocated buffers
        FreeMem( InBuf ) ;
        FreeMem( OutBuf ) ;
        end ;

     end;


procedure TExportFrm.ExportToMATFile ;
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
   FileName : String ;
   RH : TRecHeader ;                // WCP record header
begin

     if rbAllRecords.Checked then begin
        StartAt := 1 ;
        EndAt := FH.NumRecords ;
        end
     else begin
        StartAt := Round(edRange.LoValue) ;
        EndAt := Round(edRange.HiValue) ;
        end ;

     // Add record range to file name
     FileName := CreateExportFileName(BaseExportFileName) ;

     // Get no. of channels exported
     NumChannelsToExport := 0 ;
     for ch := 0 to FH.NumChannels-1 do
         if TCheckBox(ChannelsGrp.Controls[ch]).Checked then Inc(NumChannelsToExport) ;

     if ckCombineRecords.Checked then begin
        NumRecordsToExport := 0 ;
        for iRec := StartAt to EndAt do begin
            GetRecordHeaderOnly(FH,RH,iRec) ;
           if ANSIContainsText(RH.Status,'ACCEPTED') then Inc(NumRecordsToExport) ;
            end ;
        end
     else begin
        NumRecordsToExport := 1 ;
        end ;

     NumSamplesPerBuf := fh.NumSamplesPerRecord*fH.NumChannels ;
     GetMem( InBuf, NumSamplesPerBuf*2 ) ;
     GetMem( YBuf, NumSamplesPerBuf*8*NumRecordsToExport ) ;
     GetMem( TBuf, (NumSamplesPerBuf div FH.NumChannels)*8*NumRecordsToExport ) ;

     Writer := TMATFileWriter.Create();
     Writer.OpenMATFile( FileName ) ;
     Writer.WriteFileHeader;

     Try

     { Copy records }
     NumRecordsExported := 0 ;
     iT := 0 ;
     //iY := 0 ;
     for iRec := StartAt to EndAt do begin

         // Read record
         GetRecord(FH,RH,iRec,InBuf^) ;

         // Skip if record rejected
         if not ANSIContainsText(RH.Status,'ACCEPTED') then continue ;

         // Write time vector
         if not ckCombineRecords.Checked then iT := 0 ;
         for i := 0 to FH.NumSamples-1 do begin
             TBuf^[iT] := iT*RH.dt ;
             Inc(iT) ;
             end ;
         if not ckCombineRecords.Checked then begin
            Writer.WriteDoubleMatrixHeader(format('T%d',[iRec]),FH.NumSamples,1);
            Writer.WriteDoubleMatrixValues( TBuf^, FH.NumSamples,1) ;
            NumRecordsExported := 0 ;
            end ;

         // Copy required channels
         NumChannelsExported := 0 ;
         for ch := 0 to FH.NumChannels-1 do
             if TCheckBox(ChannelsGrp.Controls[ch]).Checked then begin
             iY := (NumRecordsExported + NumChannelsExported*NumRecordsToExport)*FH.NumSamples ;
             for i := 0 to FH.NumSamples-1 do begin
                 YBuf^[iY] := (InBuf^[(i*FH.NumChannels)+Channel[ch].ChannelOffset]
                                - Channel[ch].ADCZero)*Channel[ch].ADCSCale ;
                 Inc(iY) ;
                 end ;
             Inc(NumChannelsExported) ;
             end ;

         if not ckCombineRecords.Checked then begin
            Writer.WriteDoubleMatrixHeader( format('Y%d',[iRec]),
                                            FH.NumSamples,NumChannelsToExport);
            Writer.WriteDoubleMatrixValues( YBuf^, FH.NumSamples,NumChannelsToExport) ;
            end ;

         // Report progress
         Main.StatusBar.SimpleText := format(
         ' EXPORT: Exporting record %d/%d to %s ',
         [iRec,EndAt,FileName]) ;

         Inc(NumRecordsExported) ;

         end ;

     if ckCombineRecords.Checked then begin
        Writer.WriteDoubleMatrixHeader('T',FH.NumSamples*NumRecordsToExport,1);
        Writer.WriteDoubleMatrixValues( TBuf^,FH.NumSamples*NumRecordsToExport,1) ;
        Writer.WriteDoubleMatrixHeader('Y',FH.NumSamples*NumRecordsToExport,NumChannelsToExport);
        Writer.WriteDoubleMatrixValues( YBuf^, FH.NumSamples*NumRecordsToExport,NumChannelsToExport) ;
        end ;

     // Final Report
     Main.StatusBar.SimpleText := format(
     ' EXPORT: %d records exported to %s ',
     [EndAt-StartAt+1,FileName]) ;
     WriteToLogFile( Main.StatusBar.SimpleText ) ;

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
{ ------------------------------------------
  Change name/location of export destination
  ------------------------------------------ }
var
   ExportFileExt : string ;
begin

     ExportFileExt := ExtractFileExt(CreateExportFileName(BaseExportFileName )) ;

     SaveDialog.DefaultExt := ExportFileExt ;
     SaveDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     SaveDialog.Filter := ' Files (*' + SaveDialog.DefaultExt + ')|*' +
                            SaveDialog.DefaultExt + '|' ;

     SaveDialog.FileName := ChangeFileExt(BaseExportFileName,ExportFileExt) ;
     SaveDialog.Title := 'Export File ' ;
     if Settings.DataDirectory <> '' then begin
        SetCurrentDir(Settings.DataDirectory);
        SaveDialog.InitialDir := Settings.DataDirectory ;
        end;

     if SaveDialog.Execute then BaseExportFileName := SaveDialog.FileName ;

     edFileName.text := CreateExportFileName(BaseExportFileName) ;

     end;


procedure TExportFrm.rbABFClick(Sender: TObject);
// ---------------------------------
// Axon Binary File option selected
// ---------------------------------
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     ChannelsGrp.Enabled := True ;
     ckCombineRecords.Visible := False ;
     end;


procedure TExportFrm.rbLDTClick(Sender: TObject);
// ---------------------------------
// Qub data file option selected
// ---------------------------------
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     ChannelsGrp.Enabled := True ;
     ckCombineRecords.Visible := False ;
     end;


procedure TExportFrm.rbMATClick(Sender: TObject);
// ---------------------------------
// MatLAB File option selected
// ---------------------------------
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     ChannelsGrp.Enabled := True ;
     ckCombineRecords.Visible := True ;
     end;

procedure TExportFrm.rbCFSClick(Sender: TObject);
// ---------------------------------
// CED Filing System option selected
// ---------------------------------
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     ChannelsGrp.Enabled := True ;
     ckCombineRecords.Visible := False ;
     end;


function TExportFrm.CreateExportFileName(
         FileName : string
         ) : String ;
// ---------------------------------------------------
// Update control settings when export format changed
// ---------------------------------------------------
var
    StartAt,EndAt : Integer ;
begin

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

     ChangeFileExt( FileName, '.tmp' ) ;

     // Add record range to file name
     if rbAllRecords.Checked then begin
        StartAt := 1 ;
        EndAt := FH.NumRecords ;
        end
     else begin
        StartAt := Round(edRange.LoValue) ;
        EndAt := Round(edRange.HiValue) ;
        end ;

     // Set file extension to .tmp to locate end of file later
     FileName := ChangeFileExt( FileName, '.tmp' ) ;

     // Add record range
     FileName := ANSIReplaceText( FileName,
                                  '.tmp',
                                  format('[%d-%d].tmp',[StartAt,EndAt]) ) ;

     if rbABF.Checked then FileName := ChangeFileExt( FileName, '.abf' ) ;
     if rbCFS.Checked then FileName := ChangeFileExt( FileName, '.cfs' ) ;
     if rbASCII.Checked then FileName := ChangeFileExt( FileName, '.txt' ) ;
     if rbEDR.Checked then FileName := ChangeFileExt( FileName, '.edr' ) ;
     if rbIGOR.Checked then FileName := ChangeFileExt( FileName, '.ibw' ) ;
     if rbWCP.Checked then FileName := ChangeFileExt( FileName, '.wcp' ) ;
     if rbMAT.Checked then FileName := ChangeFileExt( FileName, '.mat' ) ;

     Result := FileName ;
     edFileName.Text := FileName ;

     end ;


procedure TExportFrm.rbASCIIClick(Sender: TObject);
// ---------------------------------
// ASCII text file option selected
// ---------------------------------
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     ChannelsGrp.Enabled := False ;
     ckCombineRecords.Visible := False ;
     end;


procedure TExportFrm.rbEDRClick(Sender: TObject);
// ---------------------------------
// WinEDR file option selected
// ---------------------------------
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     ChannelsGrp.Enabled := True ;
     ckCombineRecords.Visible := False ;
     end;


procedure TExportFrm.k(Sender: TObject);
// ---------------------------------
// Axon Binary File option selected
// ---------------------------------
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     ChannelsGrp.Enabled := False ;
     end;


procedure TExportFrm.rbIGORClick(Sender: TObject);
// ---------------------------------
// IGOR Binary File option selected
// ---------------------------------
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     ChannelsGrp.Enabled := True ;
     ckCombineRecords.Visible := False ;
     end;


procedure TExportFrm.bOKClick(Sender: TObject);
// ----------------------
// Export to output file
// ----------------------
begin

    if rbIGOR.Checked then ExportToIGORFile
    else if rbMAT.Checked then ExportToMATFile
    else ExportToFile ;

    end ;


procedure TExportFrm.rbRangeClick(Sender: TObject);
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     end;


procedure TExportFrm.rbAllRecordsClick(Sender: TObject);
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     end;



procedure TExportFrm.edRangeKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then begin
        edFileName.Text := CreateExportFileName(BaseExportFileName) ;
        end;
     end;

procedure TExportFrm.rbWCPClick(Sender: TObject);
// ---------------------------------
// WCP File option selected
// ---------------------------------
begin
     edFileName.Text := CreateExportFileName(BaseExportFileName) ;
     ChannelsGrp.Enabled := True ;
     ckCombineRecords.Visible := False ;
     end;

end.
