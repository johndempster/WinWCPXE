unit ABFFiles;
{ ---------------------------------------------------
  Axon Instruments ABF data file import/export module
  ---------------------------------------------------
  23/7/00
  18/2/00 Modified to allow import into 16 bit format WCP files
  15/5/02 Importing progress now reported in main status bar
  207/03  When ABF episode is shorter than WCP record last samples
          are used to extend record
  21/7/03 FileCloseSafe function now used to close files
          (to avoid exception when invalid handles closed        }

interface

uses global,fileio,SysUtils,shared,Dialogs,Messages,forms,controls, maths,
     Import,Progress ;

type
    TpClampV5 = packed record
	par : Array[0..79] of single ;
	Comment : Array[1..77] of char ;
        Labels : Array[1..80] of char ;
        Reserved : Array[1..35] of char ;
        Pulse : Array[1..64] of char ;
	ParExt : Array[0..15] of single ;
	ADCOffset : Array[0..15] of single ;
	ADCGain : Array[0..15] of single ;
        ADCAmplification : Array[0..15] of single ;
	ADCShift : Array[0..15] of single ;
	Units : Array[0..15,1..8] of char ;
        end ;

    TABF = packed record
         { Group #1 }
         FileType : Array[1..4] of char ;
         FileVersionNumber : single ;
	 OperationMode : SmallInt ;
	 ActualAcqLength : LongInt ;
	 NumPointsIgnored : SmallInt ;
	 ActualEpisodes : LongInt ;
	 FileStartDate : LongInt ;
	 FileStartTime : LongInt ;
	 StopwatchTime : LongInt ;
	 HeaderVersionNumber : single ;
	 nFileType : SmallInt ;
	 MSBinFormat : SmallInt ;
         { Group #2 }
	 DataSectionPtr : LongInt ;
	 TagSectionPtr : LongInt ;
	 NumTagEntries : LongInt ;
	 ScopeConfigPtr : LongInt ;
	 NumScopes : LongInt ;
	 DACFilePtr : LongInt ;
	 DACFileNumEpisodes : LongInt ;
	 Unused68 : Array[1..4] of char ;
	 DeltaArrayPtr : LongInt ;
	 NumDeltas : LongInt ;
	 VoiceTagPtr : LongInt ;
	 VoiceTagEntries : LongInt ;
         Unused88 : LongInt ;
	 SynchArrayPtr : LongInt ;
	 SynchArraySize : LongInt ;
         DataFormat : SmallInt ;
         SimultaneousScan : SmallInt ;
         StatisticsConfigPtr : LongInt ;
	 Unused108 : Array[1..12] of char ;
         { Group #3 }
	 ADCNumChannels : SmallInt ;
	 ADCSampleInterval : single ;
	 ADCSecondSampleInterval : single ;
	 SynchTimeUnit : single ;
	 SecondsPerRun : single ;
	 NumSamplesPerEpisode : LongInt ;
	 PreTriggerSamples : LongInt ;
	 EpisodesPerRun : LongInt ;
	 RunsPerTrial : LongInt ;
	 NumberOfTrials : LongInt ;
	 AveragingMode  : SmallInt ;
	 UndoRunCount : SmallInt ;
	 FirstEpisodeInRun : SmallInt ;
	 TriggerThreshold : single ;
	 TriggerSource : SmallInt ;
	 TriggerAction : SmallInt ;
	 TriggerPolarity : SmallInt ;
	 ScopeOutputInterval : single ;
	 EpisodeStartToStart : single ;
	 RunStartToStart : single ;
	 TrialStartToStart : single ;
	 AverageCount : LongInt ;
         ClockChange : LongInt ;
         nAutoTriggerStrategy : SmallInt ;
         { Group #4 }
	 DrawingStrategy : SmallInt ;
	 TiledDisplay : SmallInt ;
	 nEraseStrategy : SmallInt ;
	 DataDisplayMode : SmallInt ;
	 DisplayAverageUpdate : LongInt ;
	 ChannelStatsStrategy : SmallInt ;
	 CalculationPeriod : LongInt ;
	 SamplesPerTrace : LongInt ;
	 StartDisplayNum : LongInt ;
	 FinishDisplayNum : LongInt ;
	 MultiColor : SmallInt ;
	 ShowPNRawData : SmallInt ;
         StatisticsPeriod : single ;
         StatisticsMeasurements : LongInt ;
         StatisticsSaveStrategy : SmallInt ;
         { Group #5}
	 ADCRange : single ;
	 DACRange : single ;
	 ADCResolution : LongInt ;
	 DACResolution : LongInt ;
         { Group #6 }
	 ExperimentType : SmallInt ;
	 AutosampleEnable : SmallInt ;
	 AutosampleADCNum : SmallInt ;
	 AutosampleInstrument : SmallInt ;
	 AutosampleAdditGain : single ;
	 AutosampleFilter : single ;
	 AutosampleMembraneCap : single ;
	 ManualInfoStrategy : SmallInt ;
	 CellID1 : single ;
	 CellID2 : single ;
	 CellID3 : single ;
	 CreatorInfo : Array[1..16] of char ;
	 FileComment : Array[1..56] of char ;
         FileStartMillisecs : SmallInt ;
	 Unused338 : Array[1..10] of char ;
         { Group #7 }
	 ADCPtoLChannelMap : Array[0..15] of SmallInt ;
	 ADCSamplingSeq : Array[0..15] of SmallInt ;
	 ADCChannelName : Array[0..15,1..10] of char ;
	 ADCUnits: Array[0..15,1..8] of char ;
	 ProgrammableGain : Array[0..15] of  single ;
	 DisplayAmplification : Array[0..15] of  single ;
	 DisplayOffset : Array[0..15] of  single ;
	 InstrumentScaleFactor : Array[0..15] of  single ;
	 InstrumentOffset : Array[0..15] of  single ;
	 SignalGain : Array[0..15] of  single ;
	 SignalOffset : Array[0..15] of  single ;
	 SignalLowPassFilter : Array[0..15] of  single ;
	 SignalHighPassFilter : Array[0..15] of  single ;

         DACChannelName : Array[0..3,1..10] of char ;
         DACChannelUnits : Array[0..3,1..8] of char ;
         DACScaleFactor : Array[0..3] of single ;
         DACHoldingLevel : Array[0..3] of single ;
         SignalType : SmallInt ;
         Unused1412 : Array[1..10] of char ;
         { Group #8 }
         OutEnable : SmallInt ;
         SampleNumberOUT1 : SmallInt ;
         SampleNumberOUT2 : SmallInt ;
         FirstEpisodeOUT : SmallInt ;
         LastEpisodeOut : SmallInt ;
         PulseSamplesOUT1 : SmallInt ;
         PulseSamplesOUT2 : SmallInt ;
         { group #9 }
         DigitalEnable : SmallInt ;
         WaveformSource : SmallInt ;
         ActiveDACChannel : SmallInt ;
         InterEpisodeLevel : SmallInt ;
         EpochType : Array[0..9] of SmallInt ;
         EpochInitLevel : Array[0..9] of single ;
         EpochLevelInc : Array[0..9] of single ;
         EpochInitDuration : Array[0..9] of SmallInt ;
         EpochDurationInc : Array[0..9] of SmallInt ;
         DigitalHolding : SmallInt ;
         DigitalInterEpisode : SmallInt ;
         DigitalValue : Array[0..9] of SmallInt ;
         Unavailable : Array[1..4] of char ;
         Unused1612 : Array[1..8] of char ;
         { Group 10 }
         DACFileStatus : single ;
         DACFileOffset : single ;
         Unused1628 : Array[1..2] of char ;
         DACFileEpisodeNum : SmallInt ;
         DACFileADCNum : SmallInt ;
         DACFilePath : Array[1..84] of char ;
         { Group 11 }
         ConditEnable : SmallInt ;
         ConditChannel : SmallInt ;
         ConditNumPulses : LongInt ;
         BaselineDuration : single ;
         BaselineLevel : single ;
         StepDuration : single ;
         StepLevel : single ;
         PostTrainPeriod : single ;
         PostTrainLevel : single ;
         Unused1750 : array[1..12] of char ;
         { Group 12 }
         ParamToVary : SmallInt ;
         ParamValueList : Array[1..80] of char ;
         { Group 13 }
         AutoPeakEnable : SmallInt ;
         AutoPeakPolarity : SmallInt ;
         AutoPeakADCNum : SmallInt ;
         AutoPeakSearchMode : SmallInt ;
         AutoPeakStart : LongInt ;
         AutoPeakEnd : LongInt ;
         AutoPeakSmoothing : SmallInt ;
         AutoPeakBaseline : SmallInt ;
         AutoPeakAverage : SmallInt ;
         Unavailable1866 : array[1..2] of char ;
         AutopeakBaselineStart : LongInt ;
         AutopeakBaselineEnd : LongInt ;
         AutopeakMeasurements : LongInt ;
         { Group #14 }
         ArithmeticEnable : SmallInt ;
         ArithmeticUpperLimit : single ;
         ArithmeticLowerLimit : single ;
         ArithmeticADCNumA : SmallInt ;
         ArithmeticADCNumB : SmallInt ;
         ArithmeticK1 : single ;
         ArithmeticK2  : single ;
         ArithmeticK3 : single ;
         ArithmeticK4 : single ;
         ArithmeticOperator : Array[1..2] of char ;
         ArithmeticUnits : Array[1..8] of char ;
         ArithmeticK5 : single ;
         ArithmeticK6 : single ;
         ArithmeticExpression : SmallInt ;
         Unused1930 : array[1..2] of char ;
         { Group #15 }
         PNEnable : SmallInt ;
         PNPosition : SmallInt ;
         PNPolarity : SmallInt ;
         PNNumPulses : SmallInt ;
         PNADCNum : SmallInt ;
         PNHoldingLevel : single ;
         PNSettlingTime : single ;
         PNInterPulse : single ;
         Unused1954 : array[1..12] of char ;
         { Group #16 }
         ListEnable : SmallInt ;
         BellEnable : Array[0..1] of SmallInt ;
         BellLocation : Array[0..1] of SmallInt ;
         BellRepetitions : Array[0..1] of SmallInt ;
         LevelHysteresis : SmallInt ;
         TimeHysteresis : LongInt ;
         AllowExternalTags : SmallInt ;
         LowpassFilterType : Array[0..15] of char ;
         HighpassFilterType : Array[0..15] of char ;
         AverageAlgorithm : SmallInt ;
         AverageWeighting : single ;
         UndoPromptStrategy : SmallInt ;
         TrialTriggerSource : SmallInt ;
         StatisticsDisplayStrategy : SmallInt ;
         ExternalTagType : SmallInt ;
         Unused2034 : Array[1..14] of char ;

         end ;


function ConvertAxonToWCP( FileName : string ) : Boolean ;


implementation

uses mdiform ;

function ConvertAxonToWCP(
         FileName : string      { Name of file to be converted }
         ) : Boolean ;          { Returns TRUE if successful }
{ -------------------------------------------------------
  Convert an Axon Instruments ABF data file into WCP data file
  ------------------------------------------------------- }
var
   DataStartsAtByte,NumDataBytes,FilePointer,NumRecordsToCopy : Integer ;
   NumBytesPerRecord : Integer ;   // No. of bytes per ABF episode
   NumSamplesPerRecord : Integer ; // No. of A/D samples in ABF episode
   Rec : Integer ;
   FileHandle,pcChan,i,j : Integer ;
   ADCScale : single ;
   OK,pClampV6,FloatingPointData : boolean ;
   ch : Integer ;
   AxonFileType,FileType : string ;
   Buf : ^TIntArray ;
   FBuf : ^TSingleArray ;
   rH : ^TRecHeader ;
   PC6Header : ^TABF ;
   PC5Header : ^TpClampV5 ;
   Done : Boolean ;

begin
     OK := True ;

     New(Buf) ;
     New(FBuf) ;
     New(rH) ;
     New(pc6Header) ;
     New(pc5Header);

     try

        { Close existing WCP data file }
        FileCloseSafe( RawFH.FileHandle ) ;

        { Create name of WCP file to hold Axon file }
        RawFH.FileName := ChangeFileExt( FileName, '.wcp' ) ;

        { Open Axon file }
        FileHandle := FileOpen( FileName, fmOpenRead ) ;
        if FileHandle < 0 then begin
           OK := False ;
           Main.StatusBar.SimpleText :=
           'Import : Unable to open ' + FileName ;
           end ;

        { Read header block of file }
        if OK then begin
           { Read header block as ABF file header (PClamp V6 and later) }
           FileSeek( FileHandle, 0, 0 ) ;
           if FileRead(FileHandle,pc6Header^,Sizeof(pc6Header^))
              <> Sizeof(pc6Header^) then begin
              OK := False ;
              Main.StatusBar.SimpleText :=
              'Import : Unable to open '
              + FileName
              + ' Axon data file header too small!'

              end ;
           end ;

        { Determine what kind of Axon data file it is }

        if OK then begin
           pClampV6 := False ;

           { Check file type }
           FileType := '' ;
           for i := 1 to 4 do FileType := FileType + pc6Header^.FileType[i] ;
           if (FileType = 'ABF ') or (FileType = 'CPLX')
              or (FileType = 'FTCX') then pClampV6 := True ;

           { If this is not a pClamp V6 (Axon Binary File), try as pClamp V5 }
           if not pClampV6 then begin
              { Read header block as pClamp 5 file }
              FileSeek( FileHandle, 0, 0 ) ;
              if FileRead(FileHandle,pc5Header^,Sizeof(pc5Header^))
              <> Sizeof(pc5Header^) then OK := False ;
              if pc5Header^.par[0] = 1.0 then FileType := 'CLPX'
              else if pc5Header^.par[0] = 10.0 then FileType := 'FTCX'
              else OK := False ;
              end ;
           end ;

       { Extract data from pCLAMP header block }

        if OK then begin
          if pClampV6 then begin
             { pClamp V6 data file }
             AxonFileType := format('Axon %s %.2f',[FileType,pc6Header^.FileVersionNumber]) ;
             RawFH.NumChannels := MaxInt([pc6Header^.ADCNumChannels,1]) ;
             if pc6Header^.NumSamplesPerEpisode <= 0 then
                pc6Header^.NumSamplesPerEpisode := 512 ;
             NumSamplesPerRecord := pc6Header^.NumSamplesPerEpisode ;
             NumBytesPerRecord := NumSamplesPerRecord*2 ;

             { Set WCP record size large enough to hold imported record }
             RawFH.NumSamples := 256 ;
             while RawFH.NumSamples <
                  (pc6Header^.NumSamplesPerEpisode div RawFH.NumChannels) do
                  RawFH.NumSamples := RawFH.NumSamples + 256 ;

             NumRecordsToCopy := pc6Header^.ActualAcqLength div
     	                         pc6Header^.NumSamplesPerEpisode ;
             RawFH.dt := pc6Header^.ADCSampleInterval*1E-6*RawFH.NumChannels ;
             RawFH.ADCVoltageRange := pc6Header^.ADCRange ;
             ADCScale := (2.*pc6Header^.ADCResolution) / ((Main.SESLabIO.ADCMaxValue+1)*2.0) ;
             RawFH.IdentLine := '' ;
             for i := 1 to 56 do RawFH.IdentLine := RawFH.IdentLine
                                                    + pc6Header^.FileComment[i] ;

             { Channel scaling/units information }

             for ch := 0 to RawFH.NumChannels-1 do begin

                { Get PClamp physical channel number for this channel }
                pcChan := pc6Header^.ADCSamplingSeq[ch] ;

     	        Channel[ch].ADCCalibrationFactor := pc6Header^.InstrumentScaleFactor[pcChan]
                                                    * pc6Header^.SignalGain[pcChan] ;

                { Add "AddIt" gain if in use for this channel }
                if pc6Header^.AutoSampleADCNum = pcChan then
                   Channel[ch].ADCCalibrationFactor := Channel[ch].ADCCalibrationFactor
                                                       * pc6Header^.AutosampleAdditGain ;

                if Channel[ch].ADCCalibrationFactor = 0. then
                   Channel[ch].ADCCalibrationFactor := 1. ;

                Channel[ch].ADCAmplifierGain := 1. ;
	        Channel[ch].ADCZero := 0 ;
                Channel[ch].ADCUnits := '' ;

                for i := 1 to 4 do Channel[ch].ADCUnits := Channel[ch].ADCUnits +
                                                        pc6Header^.ADCUnits[pcChan,i] ;
                Channel[ch].ADCName := '' ;
	        for i := 1 to 4 do Channel[ch].ADCName := Channel[ch].ADCName +
                                                    pc6Header^.ADCChannelName[pcChan,i] ;

                Channel[ch].ChannelOffset := ch ;
                end ;

             { Get byte offset of data section }
             DataStartsAtByte := pc6Header^.DataSectionPtr*512 ;
             { Determine whether data is integer or floating point }
             NumDataBytes := FileSeek( FileHandle, 0, 2 ) - DataStartsAtByte ;
             if NumDataBytes >= pc6Header^.ActualAcqLength*4 then begin
                FloatingPointData := True ;
                NumBytesPerRecord := pc6Header^.NumSamplesPerEpisode*4 ;
                end
             else begin
                FloatingPointData := False ;
                NumBytesPerRecord := pc6Header^.NumSamplesPerEpisode*2 ;
                end ;

             end
          else begin
             { pCLAMP V5 data file }
             AxonFileType := 'AXON PCLAMP V5' ;
     	       RawFH.NumChannels := MaxInt([Trunc(pc5Header^.par[1]),1]) ;
             RawFH.NumSamples := Trunc(pc5Header^.par[2]) div RawFH.NumChannels ;
             NumSamplesPerRecord := Trunc(pc5Header^.par[2]) ;
             NumBytesPerRecord := NumSamplesPerRecord*2 ;
	           NumRecordsToCopy := Trunc(pc5Header^.par[3]) ;
	           RawFH.dt := pc5Header^.par[4]*1E-6*RawFH.NumChannels ;
             RawFH.ADCVoltageRange := pc5Header^.par[52] ;
             ADCScale := Power(2.,pc5Header^.par[54]) / ((Main.SESLabIO.ADCMaxValue+1)*2.0) ;
             if ADCScale = 0. then ADCScale := 1. ;
	           RawFH.IdentLine := '' ;
             for i := 1 to 76 do RawFH.IdentLine := RawFH.IdentLine
                                                    + pc5Header^.Comment[i] ;

             { Channel scaling/units information }
             pcChan := Trunc ( pc5Header^.par[31] ) ;

             for ch := 0 to RawFH.NumChannels-1 do begin
                 Channel[ch].ChannelOffset := ch ;
                 Channel[ch].ADCAmplifierGain := 1. ;
                 Channel[ch].ADCCalibrationFactor := pc5Header^.ADCGain[pcChan] ;
	         Channel[ch].ADCZero := 0 ;
                 Channel[ch].ADCUnits := '' ;
                 for i := 1 to 4 do Channel[ch].ADCUnits := Channel[ch].ADCUnits
                                                      + pc5Header^.Units[pcChan,i] ;
                 Channel[ch].ADCName := Format( 'Ch.%d', [ch] ) ;
                 Inc(pcChan) ;
                 end ;
             DataStartsAtByte := 2*512 ;
             FloatingPointData := False ;
             end ;
          end ;

        { Copy signal records from pCLAMP to WCP data file }

        if OK then begin
           { Create a new WCP file to hold converted data }
           RawFH.FileHandle := FileCreate( RawFH.FileName ) ;
           RawFH.NumRecords := 0 ;

           { Move file pointer to data section of pClamp file }
           FileSeek( FileHandle, DataStartsAtByte, 0 ) ;

           { Copy records }

           Rec := 1 ;
           Done := False ;
           while not Done do begin

               { Read A/D samples from Axon file }

               if FloatingPointData then begin
                  { Data in floating point format }

                  { Clear buffer }
                  for i := 0 to (RawFH.NumSamples*RawFH.NumChannels)-1 do FBuf^[i] := 0.0 ;

                  { Read buffer from file }
                  FilePointer := FileSeek( FileHandle,
                                 DataStartsAtByte+(Rec-1)*NumBytesPerRecord,
                                 0 ) ;
                  if FileRead(FileHandle,FBuf^,NumBytesPerRecord) <> NumBytesPerRecord then
                     WriteToLogFileNoDate( format( 'Error reading %s %d bytes at %d',
                                           [FileName,FilePointer,NumBytesPerRecord] )) ;

                  { Re-scale data }
                  for ch := 0 to RawFH.NumChannels-1 do begin
                      rH^.ADCVoltageRange[ch] := RawFH.ADCVoltageRange ;
                      Channel[ch].ADCScale := CalibFactorToADCScale( rH^, ch ) ;
                      j := Channel[ch].ChannelOffset ;
                      for i := 0 to RawFH.NumSamples-1 do begin
                          Buf^[j] := Round( FBuf^[j]/Channel[ch].ADCScale ) ;
                          j := j + RawFH.NumChannels ;
                          end ;
                      end ;
                  end

               else begin
                  { *** Data in integer (2 byte) format *** }

                  { Clear buffer }
                  for i := 0 to (RawFH.NumSamples*RawFH.NumChannels)-1 do Buf^[i] := 0 ;

                  FileSeek( FileHandle,
                            DataStartsAtByte+(Rec-1)*NumBytesPerRecord,
                            0 ) ;
                  if FileRead(FileHandle,Buf^,NumBytesPerRecord) <> NumBytesPerRecord then
                     WriteToLogFileNoDate( format( 'Error reading %s %d bytes at %d',
                                           [FileName,FilePointer,NumBytesPerRecord] )) ;

                  i := NumSamplesPerRecord - RawFH.NumChannels ;
                  j := i ;
                  while i < RawFH.NumSamples do begin
                       Buf^[i] := Buf^[j] ;
                       Inc(i) ;
                       Inc(j) ;
                       if j >= NumSamplesPerRecord then
                          j := NumSamplesPerRecord - RawFH.NumChannels ;
                       end ;

                  { Re-scale data }
                  for i := 0 to (RawFH.NumSamples*RawFH.NumChannels)-1 do
                      Buf^[i] := Round( Buf^[i]/ADCScale ) ;

                  end ;

               { Save record to file }
               Inc(RawFH.NumRecords) ;
               rH^.Status := 'ACCEPTED' ;
               rH^.RecType := 'TEST' ;
               rH^.Number := RawFH.NumRecords ;
               rH^.Time := rH^.Number ;
               rH^.dt := RawfH.dt ;
               rH^.Ident := ' ' ;
               for ch := 0 to RawFH.NumChannels do rH^.ADCVoltageRange[ch] :=
                                                   RawFH.ADCVoltageRange ;
               rH^.Equation.Available := False ;
               rH^.Analysis.Available := False ;
               PutRecord( RawfH, rH^, RawfH.NumRecords, Buf^ ) ;

               { Show progress of conversion }
               Main.StatusBar.SimpleText := format(
               'Import : Record %d/%d from %s (%s)',
               [Rec,NumRecordsToCopy,FileName,AxonFileType] ) ;
               Inc(Rec) ;

               if FloatingPointData then
               Main.StatusBar.SimpleText := Main.StatusBar.SimpleText
                                            + ' (floating point values)' ;

               if Rec > NumRecordsToCopy then Done := True ;

               end ;

           { Save file header }
           SaveHeader( RawFH ) ;
           { Close WCP file }
           FileCloseSafe( RawFH.FileHandle ) ;

           { Final report  }
           Main.StatusBar.SimpleText := format(
           'Import : %d records imported from %s (%s)',
           [RawFH.NumRecords,FileName,AxonFileType] ) ;
           { Report to log file }
           WriteToLogFile( AxonFileType + ' : ' + FileName ) ;
           WriteToLogFile( 'converted to WCP file : ' + RawFH.FileName ) ;

           end ;

     finally
        { Close Axon data file }
        FileCloseSafe( FileHandle ) ;

        Dispose(pc5Header) ;
        Dispose(pc6Header) ;
        Dispose(rH) ;
        Dispose(FBuf) ;
        Dispose(Buf) ;
        end ;

     if not OK then MessageDlg( 'Unable to convert ' + FileName,mtWarning, [mbOK], 0 ) ;
     Result := OK ;
     end ;




end.
