unit Fileio;
{/(c) J.Dempster, University of Strathclyde 1996-97. All Rights Reserved

  4/6/97 Error in retaining Seal test amplitude fixed
  7/6/97 ADCAmplifierGain now correctly included in scale factor
  16/16/97 ... WriteToLogFileNoDate added
  25/6/97 V1.6 Extra sealtest settings added to support 3 pulses
  27/6/97 V1.6c SealTest.AutoScale & SealTest.DisplayScale added
                to INI file
  8/7/97 V1.6e ADCAmplifierGain now handled correctly when scaling signals
  8/9/97 V1.7b EventDetector.PreTrigger added to INI file
  6/1/98 V1.8a LogFIleAvailable initialised to FALSE
  20/1/98 V1.8b Seal Test Free run status included in INI file
  26/2/98 V1.8c ... Zero levels from WCP for DOS files now retained
  5/5/98 V2.0b Size of array increased in SaveInitializationFile and
         LoadInitializationFile to avoids Array Full error when
         6 channels are used.
  25/6/99 V2.3a ADCVoltageRange = 0.0 trapped and corrected
          Problem arises when WinWCP files are analysed by WCP for DOS
  14/7/99 V3.0 Converted to 32 bit
  4/8/99 ... 2048 offset removed from WCP data files
             GetRecord/PutRecord now use GetRecordHeaderOnly/PutRecordHeaderOnly
             to retrieve/store record header information
  14/8/99 ... Normalisation error in light gaussian filtering fixed
              record sampling interval (RH.dt) now stored in (s) rather than (ms)
  17/8/99 ... BMAPW and BMAPH replaced by PLMFW and PLMFH
  12/3/00 ... Settings.DifferentiationMode added to INI file
  19/7/00 ... scDisplay.ADCScale now updated every time record is changed.
  14/9/00 ... GetHeader updated (error reading single record files fixed)
  13/2/01 ... ADC data range now adjusted automatically when 12/16 bit WCP data files
              are opened. Lab. interface may be disabled as a consequence.
  3/9/01 .... Fixed/From record zero level settings now saved in initialisation file
  12/2/3 .... Settings.TimeCalBar & Settings.BarValues added to INI file
              FileCloseSafe() procedure added
  24/06/03 .. NumHorizontalGridLines & NumVerticalGridLines added to INI file
  03.02.04 .. DACInvertTriggerLevel settings to INI file (DACINVTRIG)
  17.03.04 .. GetHeader & SaveHeader now load/save MaxADCValue (not SESLabIO.ADCMaxValue)
  27.07.04 ... Settings.ExternalTriggerActiveHigh added to initialisation file
  11.12.04 ... GetHeader modified to correctly detect file header length of V2.3 WCP files
  04.07.05 ... Display zoom min/max ranges now only changed when A/D resolution,
               no. of samples or channels changed
  29/7/5 ..... Settings.ADCInputMode (LABADIP=) added to ini file
  03/08/06 ... Settings.NumChannels Settings.NumSamples, Settings.ADCVoltageRangeIndex
               Settings.RecordDuration added to INI file
  07/12/06 ... GetRecord32 function added
  05/9/07 ... No. longer reports that the log file cannot be opened
              File header array full warning only given once
  16/12/8 ... Memory violation error prevented check for 0 character made
              on zero length channel name or unit strings. Blank channel names and units now possible
  10/02/9 ... winwcp.ini file size increased to 10000 bytes to avoid "Header Full" error
              when long data file paths used.
  11/02/9 ... Settings.VProtDirectory added (Settings.SectorWriteTime removed)
  07/12/9 ... Non-stationary variance settings added to WCP file header
  25/03/10 ... File and record header sizes now increase with no. of channels
  21/6/10 ...  Try/Finally removed from GaussianFilter
               NumAnalysisBytesPerRecord now correctly set for no. of channels
  02/09/10 .
  17.09.10 ... RH.FitChan and RH.FitCursors kept within valid limits when read
  16.06.11 ... Tecella TRITON settings removed from INI file
  20.07.11 ... 'PLNAME=', Settings.ProtocolListFileName added to INI file
  22.09.11 ... 'ADCVRI=', Settings.ADCVoltageRangeIndex removed from INI file
  29.12.12 ... fHDR.NumZeroAvg now forced to be at least 1.
  16.01.13 ... char & pchar replaced with PANSIChar & ANSIChar
               GetRecordHeaderOnly() Record type now checked and set to TEST
               if entry not a valid record type
               'STSMF=', Settings.SealTest.SmoothingFactor added to INI file
  18.02.13 ... GetRecordHeaderOnly() Corrupted record headers now filled with default values
               fHDR.NumBytesPerRecord no longer estimated by locating start of 2nd record header
               to allow loading of files with corrupted analysis blocks
  25.03.13 ... Updated to compile under both Delphi XE2/3 and 7
               'PKPAVG=', fHDR.NumPointsAveragedAtPeak added to header
  29.07.13     'NEWFILEONREC=', Settings.OpenNewFileOnRecord added to INI file
               'RECCURS0=',Settings.RecCursor0 .. Settings.RecCursor4 added to INI file
  01.08.13 ... Settings.VProtDirectory and Settings.DataDirectory now set to default
               by LoadInitialisationFile() if directories in WinWCP.INI don't exist
               'GVAR%d=',Stimulator.GlobalVar[i] added to INI file
  26.08.13     Settings.TimeRecordingStarted removed from winwcp.ini
               'RSTIME=', fHDR.RecordingStartTime added to WCP header
  27.08.13 ... RTIMESECS=', fHDR.RecordingStartTimeSecs added
               'RSTIME=', fHDR.RecordingStartTime now date string
  26.06.14 ...
  20.03.15 ... VERPROG= added (WinWCP program version which created file)
  24.03.15 ... 'FNINCDATE=', Settings.FileNameIncludeDate 'FNPREFIX=', Settings.FileNamePrefix added
  02/10/15 ..  'STZAPA=', Settings.SealTest.ZapAmplitude'STZAPD=', Settings.SealTest.ZapDuration added to INI file
  28/02/17 ... On line analysis settings for RecPlotFrm now stored in Settings.RecPlot and saved in INI file
               'QUPERC=', fHDR.QuantilePercentage added to WCP header
  05.11.18 ... 'RECPIGLEAK=', Settings.RecPlot.IgnoreLeakRecords added to INI
  22.05.19 ... 'STGAP=', Settings.SealTest.GaFromPeak added to INI
               'STNAV=', Settings.SealTest.NumAverages added to INI
               'STSMF=', Settings.SealTest.Smoothing factor removed from INI

  }


interface

uses shared,global,sysUtils,dialogs, maths, math, seslabio, strutils,windows ;

procedure SaveHeader( fHDR : TFileHeader ) ;
procedure GetHeader( var fHDR : TFileHeader ) ;
procedure LoadInitializationFile( const IniFileName : string ) ;
procedure SaveInitializationFile( const IniFileName : string ) ;
procedure PutRecord ( var fHDR : TFileHeader;
                     var rH : TRecHeader ;
                     RecordNum : Integer ;
                     var dBuf : Array of SmallInt ) ;
procedure PutRecord32(
          var fHDR : TFileHeader;      { Data file header }
          var rH : TRecHeader ;        { Record header }
          RecordNum : Integer ;        { Record number }
          var dBuf : Array of Integer { A/D data array }
          ) ;
procedure PutRecordHeaderOnly( var fHDR : TFileHeader;
                               var rH : TRecHeader ;
                               RecordNum : Integer ) ;
procedure GetRecord( var fHDR : TFileHeader;
                     var rH : TRecHeader ;
                     RecordNum : Integer ;
                     var dBuf : Array of SmallInt ) ;

procedure GetRecordWCPV8( var fHDR : TFileHeader;
                     var rH : TRecHeader ;
                     RecordNum : Integer ;
                     var dBuf : Array of SmallInt ) ;


procedure GetRecord32( var fHDR : TFileHeader;
                       var rH : TRecHeader ;
                       RecordNum : Integer ;
                       var dBuf : Array of Integer ) ;

procedure GetRecordHeaderOnly( var fHDR : TFileHeader;
                               var rH : TRecHeader ;
                               RecordNum : Integer ) ;

procedure GetRecordHeaderOnlyWCPV8(
          var fHDR : TFileHeader;      { Data file header }
          var rH : TRecHeader ;        { Record header }
          RecordNum : Integer          { Record number }
          ) ;

function CalibFactorToADCScale( var RH : TRecHeader ; Ch : Integer ) : single ;

procedure OpenLogFile ;
procedure WriteToLogFile( Line : string ) ;
procedure WriteToLogFileNoDate( Line : string ) ;
procedure CloseLogFile ;
procedure FileCloseSafe( var FileHandle : Integer ) ;

procedure GaussianFilter( const FHdr : TFileHeader ;
                           Var Buf : Array of SmallInt ;
                           CutOffFrequency : single ) ;

function FileOverwriteCheck( var FileName : string ) : boolean ;

function NumAnalysisBytesPerRecord(
         NumChannels : Integer ) : Integer ;

function NumBytesInFileHeader(
         NumChannels : Integer ) : Integer ;

implementation

uses mdiform, AmpModule, stimModule ;

const
    INIFileSize = 10240 ;
    MaxRecordIdentChars = 16 ;
    MaxRecordStatusChars = 8 ;
    MaxRecordTypeChars = 4 ;

var
   LogFile : TextFile ;
   LogFileAvailable : boolean ;


procedure SaveHeader(
          fHDR : TFileHeader
          ) ;
{ ---------------------------------------
  Save file header data to WCP data file
  ---------------------------------------}
var
   Header : array[1..MaxBytesInFileHeader] of ANSIchar ;
   s : string ;
   i : Integer ;
   ch : Integer ;
begin

     // Set file header size if no records stored
     fHDR.NumBytesInHeader := NumBytesInFileHeader(fHDR.NumChannels) ;
     fHDR.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(fHDR.NumChannels) ;

     { Initialise empty header buffer with zero bytes }
     for i := 1 to sizeof(Header) do Header[i] := chr(0) ;
     HeaderArrayFull := False ;

     fHDR.Version := FileVersion ;
     AppendFloat( Header, 'VER=',fHDR.Version );

     AppendString( Header, 'VERPROG=',fHDR.ProgVersion );

     // Time file created
     AppendString( Header, 'CTIME=', fHDR.CreationTime ) ;

     // Time recording started (s)
     AppendFloat( Header, 'RTIMESECS=', fHDR.RecordingStartTimeSecs ) ;

     // Date/time of start of recording
     AppendString( Header, 'RTIME=', fHDR.RecordingStartTime ) ;

     AppendInt( Header, 'NBH=', fHDR.NumBytesInHeader ) ;

     // 13/2/02 Added to distinguish between 12 and 16 bit data files
     AppendInt( Header, 'ADCMAX=', fHDR.MaxADCValue ) ;

     AppendInt( Header, 'NC=', fHDR.NumChannels ) ;
     fHDR.NumDataBytesPerRecord := fHDR.NumSamples*fHDR.NumChannels*2;
     fHDR.NumBytesPerRecord := fHDR.NumAnalysisBytesPerRecord +
                               fHDR.NumDataBytesPerRecord  ;
     AppendInt( Header, 'NBA=', fHDR.NumAnalysisBytesPerRecord div 512 ) ;
     AppendInt( Header, 'NBD=', fHDR.NumDataBytesPerRecord div 512 ) ;

     AppendFloat( Header, 'AD=', fHDR.ADCVoltageRange ) ;

     AppendInt( Header, 'NR=', fHDR.NumRecords ) ;
     AppendFloat( Header, 'DT=',fHDR.dt );

     fHDR.NumZeroAvg := Max(fHDR.NumZeroAvg,1) ;
     AppendInt( Header, 'NZ=', fHDR.NumZeroAvg ) ;

     for ch := 0 to fHDR.NumChannels-1 do begin
         AppendInt( Header, format('YO%d=',[ch]), Channel[ch].ChannelOffset) ;
         AppendString( Header, format('YU%d=',[ch]), Channel[ch].ADCUnits ) ;
         AppendString( Header, format('YN%d=',[ch]), Channel[ch].ADCName ) ;
         AppendFloat( Header, format('YG%d=',[ch]), Channel[ch].ADCCalibrationFactor ) ;
         AppendInt( Header, format('YZ%d=',[ch]), Channel[ch].ADCZero) ;
         AppendInt( Header, format('YR%d=',[ch]), Channel[ch].ADCZeroAt) ;
         end ;

     // T.(x%) waveform measurement percentage decay time
     AppendFloat( Header, 'TXPERC=', fHDR.DecayTimePercentage ) ;
     AppendInt( Header, 'PKPAVG=', fHDR.NumPointsAveragedAtPeak ) ;
     // Quantile percentage measurement in use
     AppendFloat( Header, 'QUPERC=', fHDR.QuantilePercentage ) ;

     // Non-stationary variance analysis settings
     AppendInt( Header, 'NSVCHAN=', fHDR.NSVChannel ) ;
     AppendInt( Header, 'NSVALIGN=', fHDR.NSVAlignmentMode ) ;
     AppendInt( Header, 'NSVTYPR=', fHDR.NSVType ) ;
     AppendLogical( Header, 'NSVS2P=', fHDR.NSVScaleToPeak ) ;
     AppendInt( Header, 'NSVCUR0=', fHDR.NSVAnalysisCursor0 ) ;
     AppendInt( Header, 'NSVCUR1=', fHDR.NSVAnalysisCursor1 ) ;

     { Experiment identification line }
     AppendString( Header, 'ID=', fHDR.IdentLine ) ;

     FileSeek( fHDR.FileHandle, 0, 0 ) ;
     if FileWrite( fHDR.FileHandle, Header, fHDR.NumBytesInHeader )
        <> fHDR.NumBytesInHeader then ShowMessage( ' File Header Write - Failed ' ) ;

     { Add Names of channels to list }
     ChannelNames.Clear ;
     for ch := 0 to fHDR.NumChannels-1 do
         ChannelNames.Add( format('Ch.%d %s',[ch,Channel[ch].ADCName]) ) ;

     if HeaderArrayFull then
        ShowMessage( fHDR.FileName + ' File header parameter array full!' ) ;

     end ;


procedure GetHeader(
          var fHDR : TFileHeader
          ) ;
{ -----------------------------------------------------------
  Read file header block from data file,
  decode parameter list, and put into FileHeader record
  26/2/98 ... Zero levels from WCP for DOS files now retained
  -----------------------------------------------------------}

const
     NumBytesPerSector = 512 ;
var
   Header : array[1..MaxBytesInFileHeader] of ANSIchar ;
   RecordStatusArray : array[0..3] of ANSIchar ;
   s,RecordStatus : string ;
   i,NumBytesInFile,NumRecords,FilePointer,ch,RecordCounter : Integer ;
   Done : Boolean ;
   NumSectors : Integer ;
   ResetDisplayMagnification : Boolean ;
   OldValue : Integer ;
begin

     ResetDisplayMagnification :=False ;

     // Default file header/analysis block sizes
     fHDR.NumBytesInHeader := 1024 ;
     fHDR.NumAnalysisBytesPerRecord := 1024 ;
     // Set bytes/record to 0 to force calculation later
     fHDR.NumBytesPerRecord := 0 ;

     { Determine size of file header }
     FilePointer := 0 ;
     RecordCounter := 0 ;
     Done := False ;
     while not Done do begin

         { Get WCP 8 byte data record status field }
         FileSeek( fHDR.FileHandle, FilePointer, 0 ) ;
         FileRead( fHDR.FileHandle, RecordStatusArray, 4 ) ;
         RecordStatus := ANSIArrayToString(RecordStatusArray) ;
         { Is it a record status field }
         if ANSIContainsText(RecordStatus,'acce') or
            ANSIContainsText(RecordStatus,'reje') then begin
            Inc(RecordCounter) ;
            if RecordCounter = 1 then begin
               fHDR.NumBytesInHeader := FilePointer ;
               fHDR.NumBytesPerRecord := FileSeek(fHDR.FileHandle,0,2) - fHDR.NumBytesInHeader ;
               end
            else if  RecordCounter = 2 then begin
               fHDR.NumBytesPerRecord := FilePointer - fHDR.NumBytesInHeader  ;
               Done := True ;
               end ;
            end ;
         { Exit if end of file reached }
         FilePointer := FilePointer + NumBytesPerSector ;
         if FilePointer > FileSeek(fHDR.FileHandle,0,2) then Done := True ;
         end ;

     { Read file header }
     FileSeek( fHDR.FileHandle, 0, 0 ) ;
     for i := 0 to High(Header) do Header[i] := #0 ;
     if FileRead( fHDR.FileHandle, Header, fHDR.NumBytesInHeader )
        = fHDR.NumBytesInHeader then begin

          ReadFloat( Header, 'VER=',fHDR.Version );
          ReadString( Header, 'VERPROG=',fHDR.ProgVersion );
          ReadString( Header, 'CTIME=', fHDR.CreationTime ) ;

          // Time recording started (ms)
          fHDR.RecordingStartTimeSecs := 0.0 ;
          ReadFloat( Header, 'RTIMESECS=', fHDR.RecordingStartTimeSecs ) ;

          // Time recording started (s)
          fHDR.RecordingStartTime := '' ;
          ReadString( Header, 'RTIME=', fHDR.RecordingStartTime ) ;

          OldValue := fHDR.NumChannels ;
          ReadInt( Header, 'NC=', fHDR.NumChannels ) ;
          if fHDR.NumChannels <> OldValue then ResetDisplayMagnification := True ;

          OldValue := fHDR.MaxADCValue ;
          fHDR.MaxADCValue := 0 ;
          ReadInt( Header, 'ADCMAX=', fHDR.MaxADCValue ) ;
          if fHDR.MaxADCValue = 0 then fHDR.MaxADCValue := 2047 ;
          fHDR.MinADCValue := -fHDR.MaxADCValue -1 ;
          if OldValue <> fHDR.MaxADCValue then ResetDisplayMagnification := True ;

          // Analysis block size
          NumSectors := fHDR.NumAnalysisBytesPerRecord div 512 ;
          ReadInt( Header, 'NBA=', NumSectors ) ;
          fHDR.NumAnalysisBytesPerRecord := NumSectors*512 ;

          ReadInt( Header, 'NBD=', fHDR.NumDataBytesPerRecord ) ;
          fHDR.NumDataBytesPerRecord := fHDR.NumDataBytesPerRecord*NumBytesPerSector ;
          fHDR.NumBytesPerRecord := fHDR.NumDataBytesPerRecord + fHDR.NumAnalysisBytesPerRecord  ;

          fHDR.NumSamplesPerRecord := fHDR.NumDataBytesPerRecord div 2 ;
          OldValue := fHDR.NumSamples ;
          fHDR.NumSamples := fHDR.NumSamplesPerRecord div fHDR.NumChannels ;
          if OldValue <> fHDR.NumSamples then ResetDisplayMagnification := True ;

          ReadFloat( Header, 'AD=',fHDR.ADCVoltageRange);

          ReadInt( Header, 'NR=', fHDR.NumRecords ) ;

          { Fix files which accidentally lost their record count }
          if fHDR.NumRecords = 0 then begin
             NumBytesInFile := FileSeek( FHDR.FileHandle, 0, 2 ) ;
             NumRecords := (NumBytesInFile - SizeOf(Header)) div fHDR.NumBytesPerRecord ;
             if NumRecords > 0 then begin
                ShowMessage( ' Number of records in file corrected.' ) ;
                fHDR.NumRecords := NumRecords ;
                end ;
             end ;

          ReadFloat( Header, 'DT=', fHDR.dt );

          ReadInt( Header, 'NZ=', fHDR.NumZeroAvg ) ;
          fHDR.NumZeroAvg := Max(fHDR.NumZeroAvg,1) ;

          { Read channel scaling data }

          for ch := 0 to fHDR.NumChannels-1 do begin

              { Channels are mapped in ascending order by WCP for DOS (Version<6.0)
                and descending order by WinWCP. Data file Versions 6.1 and later
                have channel mapping explicitly saved in YO0= ... YO1 etc parameter}
              if (fHdr.Version >= 6.0) or (fHdr.Version = 0.0) then
                 Channel[ch].ChannelOffset := fHDR.NumChannels - 1 - ch
              else
                 Channel[ch].ChannelOffset := ch ;

              ReadInt( Header, format('YO%d=',[ch]), Channel[ch].ChannelOffset) ;

              Channel[ch].ADCUnits := '' ;
              ReadString( Header, format('YU%d=',[ch]) , Channel[ch].ADCUnits ) ;
              { Fix to avoid strings with #0 in them }
              if Length(Channel[ch].ADCUnits) >= 1 then
                 if Channel[ch].ADCUnits[1] = chr(0) then Channel[ch].ADCUnits := ' ' ;
              Channel[ch].ADCName := 'Ch.' + IntToStr(ch) ;

              ReadString( Header, format('YN%d=',[ch]), Channel[ch].ADCName ) ;
              { Fix to avoid strings with #0 in them }
              if Length(Channel[ch].ADCName) >= 1 then
                 if Channel[ch].ADCName[1] = chr(0) then Channel[ch].ADCName := ' ' ;

              ReadFloat( Header, format('YG%d=',[ch]), Channel[ch].ADCCalibrationFactor) ;

              { Zero level (in fixed mode) }
              ReadInt( Header, format('YZ%d=',[ch]), Channel[ch].ADCZero) ;
              { Start of zero level reference samples (-1 = fixed zero) }
              ReadInt( Header, format('YR%d=',[ch]), Channel[ch].ADCZeroAt) ;

              { Special treatment for old WCP for DOS data files}
              if fHDR.Version < 6.0 then begin
                 { Remove 2048 offset from zero level }
                 Channel[ch].ADCZero := Channel[ch].ADCZero {- 2048} ;
                 { Decrement reference position because WinWCP samples start at 0}
                 Dec(Channel[ch].ADCZeroAt) ;
                 end ;

              // Reset display magnification (if required)
              if ResetDisplayMagnification then begin
                 Channel[ch].yMax := fHDR.MaxADCValue ;
                 Channel[ch].yMin := fHDR.MinADCValue ;
                 Channel[0].xMin := 0 ;
                 Channel[0].xMax := fHDR.NumSamples-1 ;
                 end ;

              end ;

          // T.(x%) waveform measurement percentage decay time
          fHDR.DecayTimePercentage := 50.0 ; // Default value
          ReadFloat( Header, 'TXPERC=', fHDR.DecayTimePercentage ) ;
          ReadInt( Header, 'PKPAVG=', fHDR.NumPointsAveragedAtPeak ) ;

          // Quantile percentage measurement in use
          ReadFloat( Header, 'QUPERC=', fHDR.QuantilePercentage ) ;

          // Non-stationary variance analysis settings
          ReadInt( Header, 'NSVCHAN=', fHDR.NSVChannel ) ;
          ReadInt( Header, 'NSVTYPR=', fHDR.NSVType ) ;
          ReadInt( Header, 'NSVALIGN=', fHDR.NSVAlignmentMode ) ;
          ReadLogical( Header, 'NSVS2P=', fHDR.NSVScaleToPeak ) ;
          ReadInt( Header, 'NSVCUR0=', fHDR.NSVAnalysisCursor0 ) ;
          ReadInt( Header, 'NSVCUR1=', fHDR.NSVAnalysisCursor1 ) ;

          { Experiment identification line }
          ReadString( Header, 'ID=', fHDR.IdentLine ) ;

           { Add names of channels to list }
          ChannelNames.Clear ;
          for ch := 0 to fHDR.NumChannels-1 do
              ChannelNames.Add( format('Ch.%d %s',[ch,Channel[ch].ADCName] )) ;

          end
     else
          ShowMessage( ' File Header Read - Failed ' ) ;

     end ;


procedure LoadInitializationFile( const IniFileName : string ) ;
{ ---------------------------------------------------------
  Read Initialization file to get initial program settings,
  e.g. the name of the last data file used
  ---------------------------------------------------------}
var
   Header : array[1..INIFileSize] of ANSIchar ;
   i,ch,IniFileHandle : Integer ;
   AmpType, GainChannel, ModeChannel : Integer ;
   Value,fValue : Single ;
   iValue : Integer ;
   sValue : String ;
begin
     if FileExists( IniFileName ) then begin
        IniFileHandle := FileOpen( IniFileName, fmOpenReadWrite ) ;

        if FileRead(IniFileHandle,Header,Sizeof(Header)) > 0 then begin
           { Last raw data file used }
           ReadString( Header, 'FILE=', RawFH.FileName ) ;
           { Last averages data file used }
           AvgFH.Filename := '' ;
           ReadString( Header, 'FILEAVG=', AvgFH.FileName ) ;
           { Last leak subtracted data file used }
           LeakFH.Filename := '' ;
           ReadString( Header, 'LEAKAVG=', LeakFH.FileName ) ;

           // Get default recording settings
           ReadInt( Header, 'NC=', Settings.NumChannels ) ;
           Settings.NumChannels := Max( 1,Settings.NumChannels ) ;
           ReadInt( Header, 'NSAMP=', Settings.NumSamples ) ;
           ReadFloat( Header, 'RECDUR=', Settings.RecordDuration ) ;

           { CED 1902 amplifier settings }
           ReadInt( Header, 'CEDI=', Amplifier.CED1902.Input ) ;
           ReadInt( Header, 'CEDG=', Amplifier.CED1902.Gain ) ;
           ReadFloat( Header, 'CEDGV=', Amplifier.CED1902.GainValue ) ;
           ReadInt( Header, 'CEDLP=', Amplifier.CED1902.LPFilter ) ;
           ReadInt( Header, 'CEDHP=', Amplifier.CED1902.HPFilter ) ;
           ReadInt( Header, 'CEDAC=', Amplifier.CED1902.ACCoupled ) ;
           ReadInt( Header, 'CEDDCO=', Amplifier.CED1902.DCOffset ) ;
           ReadInt( Header, 'CEDNF=', Amplifier.CED1902.NotchFilter ) ;
           ReadInt( Header, 'CEDPO=', Amplifier.CED1902.ComPort ) ;

           // Patch clamp amplifier data
           // Note. V4.3.2+ Settings now stored in 'amplifier settings.xml'
           // and only loaded from INI file if XML file does not exist
           if not Amplifier.SettingsFileExists then begin
              ModeChannel := -1 ;
              AmpType := amNone ;
              ReadInt( Header, 'AMP=',AmpType ) ;
              ReadInt( Header, 'AMPCH=',GainChannel ) ;
              Amplifier.AmplifierType[0] := AmpType ;
              Amplifier.GainTelegraphChannel[0] := GainChannel ;
              Amplifier.ModeTelegraphChannel[0] := ModeChannel ;

              ReadInt( Header, 'AMP1=',AmpType ) ;
              ReadInt( Header, 'AMP1CH=',GainChannel ) ;
              ReadInt( Header, 'AMP1GAINCH=',GainChannel ) ;
              ReadInt( Header, 'AMP1MODECH=',ModeChannel ) ;
              Amplifier.AmplifierType[0] := AmpType ;
              Amplifier.GainTelegraphChannel[0] := GainChannel ;
              Amplifier.ModeTelegraphChannel[0] := ModeChannel ;

              AmpType := amNone ;
              ReadInt( Header, 'AMP2=',AmpType ) ;
              ReadInt( Header, 'AMP2CH=',GainChannel ) ;
              ReadInt( Header, 'AMP2GAINCH=',GainChannel ) ;
              ReadInt( Header, 'AMP2MODECH=',ModeChannel ) ;
              Amplifier.AmplifierType[1] := AmpType ;
              Amplifier.GainTelegraphChannel[1] := GainChannel ;
              Amplifier.ModeTelegraphChannel[1] := ModeChannel ;
              end ;

           { Send new values to CED 1902 }
          { if Amplifier.CED1902.InUse then SetCED1902(Amplifier.CED1902) ;}

           { Read global settings }

           { Get No. channels & No samples/channel }
           ReadInt( Header, 'NC=', RawFH.NumChannels ) ;
           RawFH.NumChannels := MaxInt( [1,RawFH.NumChannels] ) ;
           ReadInt( Header, 'NBD=', RawFH.NumDataBytesPerRecord ) ;
           RawFH.NumDataBytesPerRecord := RawFH.NumDataBytesPerRecord * 512 ;
           RawFH.NumSamplesPerRecord := RawFH.NumDataBytesPerRecord div 2 ;
           RawFH.NumSamples := RawFH.NumSamplesPerRecord div RawFH.NumChannels ;

           {ReadInt( Header, 'NBA=', i ) ;}
           RawFH.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(RawFH.NumChannels) ;

           RawFH.NumBytesPerRecord := RawFH.NumDataBytesPerRecord
                                     + RawFH.NumAnalysisBytesPerRecord ;

           { *** Recording settings *** }
           { Recording trigger mode }
           ReadInt( Header, 'RECMODE=', Settings.RecordingMode ) ;
           { Event detector, channel and % threshold level }
           ReadInt( Header, 'DETCH=', Settings.EventDetector.Channel ) ;
           ReadFloat( Header, 'DETTH=', Settings.EventDetector.Threshold ) ;
           ReadFloat( Header, 'DETPT=', Settings.EventDetector.PreTrigger ) ;
           ReadLogical( Header, 'EXTTRIGAH=', Settings.ExternalTriggerActiveHigh ) ;

           { Display auto-erase mode }
           ReadLogical( Header, 'AER=', Settings.AutoErase ) ;
           { Number of records required (in free run/ext. trigger/detect modes}
           ReadInt( Header, 'NRQ=', Settings.NumRecordsRequired ) ;
           { Currently selected voltage program }
           ReadString( Header, 'FILEVPR=', Settings.VProgramFileName ) ;

           { Default voltage clamp holding potential setting }
           ReadFloat( Header, 'VCHOLD=', Value ) ;
           Main.SESLabIO.DACHoldingVoltage[0] := Value ;
           for ch := 0 to MaxAmplifiers-1 do begin
               ReadFloat( Header, format('VCHOLD%d=',[ch]), Value ) ;
               Main.SESLabIO.DACHoldingVoltage[ch] := Value ;
               end ;

           { Default digital control port output byte setting }
           ReadInt( Header, 'DIGPORT=', Settings.DigitalPort.Value ) ;
           Settings.UpdateOutputs := True ;
           { Display digital low pass filter setting }
           ReadFloat( Header, 'CUTOFF=', Settings.CutOffFrequency ) ;

           // Invert recording sweep trigger pulse flag
           ReadLogical( Header, 'DACINVTRIG=', Settings.DACInvertTriggerLevel ) ;

           { Load time units (ms or s) }
           ReadString( Header, 'TUNITS=', Settings.TUnits ) ;
           if Settings.TUnits = 's' then begin
              Settings.TScale := 1. ;
              Settings.TUnScale := 1. ;
              end
           else begin
              Settings.TUnits := 'ms' ;
              Settings.TScale := SecsToms ;
              Settings.TUnScale := MsToSecs ;
              end ;

           { Seal test pulse settings }
           ReadFloat( Header, 'STPH=', Settings.SealTest.PulseHeight ) ;
           ReadFloat( Header, 'STPH1=', Settings.SealTest.PulseHeight1 ) ;
           ReadFloat( Header, 'STPH2=', Settings.SealTest.PulseHeight2 ) ;
           ReadFloat( Header, 'STPH3=', Settings.SealTest.PulseHeight3 ) ;
           ReadFloat( Header, 'STHV1=', Settings.SealTest.HoldingVoltage1 ) ;
           ReadFloat( Header, 'STHV2=', Settings.SealTest.HoldingVoltage2 ) ;
           ReadFloat( Header, 'STHV3=', Settings.SealTest.HoldingVoltage3 ) ;
           ReadFloat( Header, 'STPW=', Settings.SealTest.PulseWidth ) ;
           ReadInt( Header, 'STCCH=', Settings.SealTest.CurrentChannel ) ;
           ReadInt( Header, 'STVCH=', Settings.SealTest.VoltageChannel ) ;
           ReadInt( Header, 'STUSE=', Settings.SealTest.Use ) ;
           ReadInt( Header, 'STDSC=', Settings.SealTest.DisplayScale ) ;
           ReadLogical( Header, 'STASC=', Settings.SealTest.AutoScale ) ;
           ReadLogical( Header, 'STFRU=', Settings.SealTest.FreeRun ) ;
           ReadInt( Header, 'STNAV=', Settings.SealTest.NumAverages ) ;
           ReadFloat( Header, 'STZAPA=', Settings.SealTest.ZapAmplitude ) ;
           ReadFloat( Header, 'STZAPD=', Settings.SealTest.ZapDuration ) ;
           ReadLogical( Header, 'STGAP=', Settings.SealTest.GaFromPeak ) ;

           { Note. For compatibility with older Strathclyde
             programs 'ADCVoltageRange' is written to file
             as VOLTS but is mV internally' }
           ReadFloat( Header, 'AD=',RawFH.ADCVoltageRange);

           ReadFloat( Header, 'DT=', RawFH.dt );

           { Plotting page settings }
           ReadFloat( Header, 'PLTPM=',Settings.Plot.TopMargin ) ;
           ReadFloat( Header, 'PLBTM=',Settings.Plot.BottomMargin ) ;
           ReadFloat( Header, 'PLLFM=',Settings.Plot.LeftMargin ) ;
           ReadFloat( Header, 'PLRTM=',Settings.Plot.RightMargin ) ;
           ReadString( Header, 'PLFNT=',Settings.Plot.FontName ) ;
           ReadInt( Header, 'PLFSI=',Settings.Plot.FontSize ) ;
           ReadInt( Header, 'PLLTH=',Settings.Plot.LineThickness ) ;
           ReadLogical( Header, 'PLSHL=',Settings.Plot.ShowLines ) ;
           ReadInt( Header, 'PLMKS=',Settings.Plot.MarkerSize ) ;
           ReadLogical( Header, 'PLSHM=',Settings.Plot.ShowMarkers ) ;
           ReadLogical( Header, 'PLCOL=',Settings.Plot.UseColor ) ;
           { Width/height of clipboard metafiles }
           ReadInt( Header, 'PLMFW=', Settings.Plot.MetafileWidth ) ;
           ReadInt( Header, 'PLMFH=', Settings.Plot.MetafileHeight ) ;

           // Calibration bar settings
           ReadFloat( Header, 'TBVAL=',Settings.TimeBarValue ) ;
           for ch := 0 to WCPMaxChannels-1 do
               ReadFloat( Header, format('BVAL%d=',[ch]),
                          Settings.BarValue[ch] ) ;

           //ReadFloat( Header, 'SRT=',Settings.SectorWriteTime ) ;

           ReadString( Header, 'DDIR=', Settings.DataDirectory ) ;
           if not DirectoryExists(Settings.DataDirectory) then begin
              Settings.DataDirectory := Settings.ProgDirectory + 'data\' ;
              end;

           ReadString( Header, 'VPDIR=', Settings.VprotDirectory ) ;
           if not DirectoryExists(Settings.VprotDirectory) then begin
              Settings.VProtDirectory := Settings.ProgDirectory + 'vprot\' ;
              end;

           ReadString( Header, 'PLNAME=', Settings.ProtocolListFileName ) ;

           ReadLogical( Header, 'FNINCDATE=', Settings.FileNameIncludeDate ) ;
           ReadString( Header, 'FNPREFIX=', Settings.FileNamePrefix ) ;

           for i := 0 to High(Settings.RecentFiles) do Settings.RecentFiles[i] := '' ;
           ReadString( Header, 'RF0=', Settings.RecentFiles[0] ) ;
           ReadString( Header, 'RF1=', Settings.RecentFiles[1] ) ;
           ReadString( Header, 'RF2=', Settings.RecentFiles[2] ) ;
           ReadString( Header, 'RF3=', Settings.RecentFiles[3] ) ;

           { Laboratory interface }
           // Only load settings from INI file if SESLabIOinternal settings file does not exist
           if not Main.SESLabIO.SettingsFileExists then begin
              iValue := Main.SESLabIO.LabInterfaceType ;
              ReadInt( Header, 'LABINT=',iValue ) ;
              Main.SESLabIO.LabInterfaceType := iValue ;
              // Lab. interface device #
              iValue := Main.SESLabIO.DeviceNumber ;
              ReadInt( Header, 'LABDEV=',iValue ) ;
              Main.SESLabIO.DeviceNumber := iValue ;
              // Lab. Interface A/D input mode
              iValue := Main.SESLabIO.ADCInputMode ;
              ReadInt( Header, 'LABADIP=',iValue ) ;
              //Main.SESLabIO.ADCInputMode := iValue ;
              end ;

           { Waveform generator No Display check box setting }
           ReadLogical( Header, 'WGNDSP=', Settings.WavGenNoDisplay ) ;

//           { Time first record in current data file was recorded }
//           ReadFloat( Header, 'TRS=',Settings.TimeRecordingStarted ) ;

           ReadInt( Header, 'DIFFM=', Settings.DifferentiationMode ) ;

           ReadLogical( Header,'LOCKCHC=', Settings.LockChannelCursors ) ;

           { Display autoerase flag }
           ReadLogical( Header, 'AUTOERASE=', Settings.AutoErase ) ;

           { Display grid }
           ReadLogical( Header, 'DISPGRID=', Settings.DisplayGrid ) ;

           { Get channel names, units, scale factors }
           for ch := 0 to RawFH.NumChannels-1 do begin
              // Units
              sValue := Main.SESLabIO.ADCChannelUnits[ch] ;
              ReadString( Header, format('YU%d=',[ch]), sValue ) ;
              Main.SESLabIO.ADCChannelUnits[ch] := sValue ;
              // Namee
              sValue := Main.SESLabIO.ADCChannelName[ch] ;
              ReadString( Header, format('YN%d=',[ch]), sValue ) ;
              Main.SESLabIO.ADCChannelName[ch] := sValue ;

              fValue := Main.SESLabIO.ADCChannelVoltsPerUnit[ch] ;
              ReadFloat( Header, format('YG%d=',[ch]), fValue ) ;
              Main.SESLabIO.ADCChannelVoltsPerUnit[ch] := fValue ;

              { Zero level (in fixed mode) }
              iValue := Main.SESLabIO.ADCChannelZero[ch] ;
              ReadInt( Header, format('YZ%d=',[ch]), iValue ) ;
              Main.SESLabIO.ADCChannelZero[ch] := iValue ;

              { Start of zero level reference samples (-1 = fixed zero) }
              iValue := Main.SESLabIO.ADCChannelZeroAt[ch] ;
              ReadInt( Header, format('YR%d=',[ch]), iValue) ;
              Main.SESLabIO.ADCChannelZeroAt[ch] := iValue ;

              end ;

          // Save voltage clamp simulation settings (VCLAMPSim)
          ReadInt( Header, 'VCSIMNS=', Settings.VClampSim.NumSteps );
          ReadFloat( Header, 'VCSIMGMAX=', Settings.VClampSim.GMax );
          ReadFloat( Header, 'VCSIMGLEAK=', Settings.VClampSim.GLeak );
          ReadFloat( Header, 'VCSIMGSERIES=', Settings.VClampSim.GSeries );
          ReadFloat( Header, 'VCSIMCM=', Settings.VClampSim.Cm );
          ReadFloat( Header, 'VCSIMVREV=', Settings.VClampSim.VRev );
          ReadFloat( Header, 'VCSIMVHOLD=', Settings.VClampSim.VHold );
          ReadFloat( Header, 'VCSIMVSTEP=', Settings.VClampSim.VStep );

          { Activation gate (m) parameters }
          ReadFloat( Header, 'VCSIMMSSVH=', Settings.VClampSim.m.VHalf );
          ReadFloat( Header, 'VCSIMMSSVS=', Settings.VClampSim.m.VSlope );
          ReadFloat( Header, 'VCSIMMTAUMIN=', Settings.VClampSim.m.TauMin  );
          ReadFloat( Header, 'VCSIMMTAUMAX=', Settings.VClampSim.m.TauMax );
          ReadFloat( Header, 'VCSIMMTAUVH=', Settings.VClampSim.m.TauVHalf  );
          ReadFloat( Header, 'VCSIMMTAUVS=', Settings.VClampSim.m.TauVslope  );
          ReadFloat( Header, 'VCSIMPFAC=', Settings.VClampSim.m.P  );

          { Inactivation gate (h) parameters }
          ReadLogical( Header, 'VCSIMHUSE=', Settings.VClampSim.UseInactivation  );
          ReadFloat( Header, 'VCSIMHSSVH=', Settings.VClampSim.h.VHalf  );
          ReadFloat( Header, 'VCSIMHSSVS=', Settings.VClampSim.h.VSlope  );
          ReadFloat( Header, 'VCSIMHTAUMIN=', Settings.VClampSim.h.TauMin  );
          ReadFloat( Header, 'VCSIMHTAUMAX=', Settings.VClampSim.h.TauMax  );
          ReadFloat( Header, 'VCSIMHTAUVH=', Settings.VClampSim.h.TauVHalf  );
          ReadFloat( Header, 'VCSIMHTAUVS=', Settings.VClampSim.h.TauVslope  );

          // Save synapse simulation settings (SynapseSim)
          ReadInt( Header, 'SYSIMNRECS=',Settings.SynapseSim.NumRecords ) ;
          ReadFloat( Header, 'SYSIMDUR=',Settings.SynapseSim.RecordDuration ) ;
          ReadFloat( Header, 'SYSIMTAURISE=',Settings.SynapseSim.TauRise ) ;
          ReadFloat( Header, 'SYSIMTAU1=',Settings.SynapseSim.Tau1 ) ;
          ReadFloat( Header, 'SYSIMLATENCY=',Settings.SynapseSim.Latency ) ;
          ReadFloat( Header, 'SYSIMTAU2=',Settings.SynapseSim.Tau2 ) ;
          ReadLogical( Header, 'SYSSIMDEXP=',Settings.SynapseSim.DoubleExponentialDecay ) ;
          ReadFloat( Header, 'SYSIMA2F=',Settings.SynapseSim.A2Fraction ) ;
          ReadFloat( Header, 'SYSIMQAMP=',Settings.SynapseSim.QuantumAmplitude ) ;
          ReadFloat( Header, 'SYSIMQSTD=',Settings.SynapseSim.QuantumStDev ) ;
          ReadFloat( Header, 'SYSIMN=',Settings.SynapseSim.n ) ;
          ReadFloat( Header, 'SYSIMP=',Settings.SynapseSim.p ) ;
          ReadFloat( Header, 'SYSIMNOISE=',Settings.SynapseSim.NoiseRMS ) ;
          ReadFloat( Header, 'SYSIMDRANGE=',Settings.SynapseSim.DisplayRange ) ;
          ReadFloat( Header, 'SYSIMVREST=',Settings.SynapseSim.VRest ) ;

          // MEPSCSim settings
          ReadInt( Header, 'MEPSIMNR=',Settings.MEPSCSim.NumRecords) ;
          ReadFloat( Header, 'MEPSIMDUR=',Settings.MEPSCSim.RecordDuration) ;
          ReadFloat( Header, 'MEPSIMUC=',Settings.MEPSCSim.UnitCurrent) ;
          ReadFloat( Header, 'MEPSIMTDEC=',Settings.MEPSCSim.TransmitterDecayTime) ;

          ReadFloat( Header, 'MEPSIMBIR=',Settings.MEPSCSim.BindingRate) ;
          ReadFloat( Header, 'MEPSIMOPR=',Settings.MEPSCSim.OpenRate) ;
          ReadFloat( Header, 'MEPSIMCLR=',Settings.MEPSCSim.CloseRate) ;
          ReadFloat( Header, 'MEPSIMUBR=',Settings.MEPSCSim.UnbindRate) ;
          ReadFloat( Header, 'MEPSIMBLR=',Settings.MEPSCSim.BlockRate) ;
          ReadFloat( Header, 'MEPSIMUBR=',Settings.MEPSCSim.UnBlockRate) ;

          ReadFloat( Header, 'MEPSIMNOI=',Settings.MEPSCSim.NoiseRMS) ;
          ReadFloat( Header, 'MEPSIMLPF=',Settings.MEPSCSim.LPFilter) ;

          ReadLogical( Header, 'MEPSIMLPFIU=',Settings.MEPSCSim.LPFilterInUse) ;
          ReadFloat( Header, 'MEPSIMDRI=',Settings.MEPSCSim.Drift) ;

          ReadLogical( Header, 'MEPSIMLPFIU=',Settings.MEPSCSim.LPFilterInUse) ;

          ReadLogical( Header, 'FIXZERO=', Settings.FixedZeroLevels) ;

          ReadLogical( Header, 'NEWFILEONREC=', Settings.OpenNewFileOnRecord) ;

         // On-line analysis settings
         ReadInt( Header, 'RECPNPLOTS=',Settings.RecPlot.NumPlots ) ;
         for i := 0 to Settings.RecPlot.NumPlots-1 do
           begin
           ReadInt( Header, format('RECPVAR%d=',[i]),Settings.RecPlot.Plot[i].VarNum ) ;
           ReadInt( Header, format('RECPCHAN%d=',[i]),Settings.RecPlot.Plot[i].ChanNum ) ;
           ReadString( Header, format('RECPYLAB%d=',[i]),Settings.RecPlot.Plot[i].YLabel ) ;
           ReadString( Header, format('RECPLE%d=',[i]),Settings.RecPlot.Plot[i].ListEntry ) ;
           ReadInt( Header, format('RECPPOL%d=',[i]),Settings.RecPlot.Plot[i].Polarity ) ;
           ReadInt( Header, format('RECPRRS%d=',[i]),Settings.RecPlot.Plot[i].RateofRiseSmoothing ) ;
           ReadInt( Header, format('RECPCS%d=',[i]),Settings.RecPlot.Plot[i].CursorSet ) ;
           ReadString( Header, format('RECPSTIM%d=',[i]),Settings.RecPlot.Plot[i].StimProtocol ) ;
           end;

         ReadFloat( Header, 'RECPCURS0=',Settings.RecPlot.Cursor0) ;
         ReadFloat( Header, 'RECPCURS1=',Settings.RecPlot.Cursor1) ;
         ReadFloat( Header, 'RECPCURS2=',Settings.RecPlot.Cursor2) ;
         ReadFloat( Header, 'RECPCURS3=',Settings.RecPlot.Cursor3) ;
         ReadFloat( Header, 'RECPCURS4=',Settings.RecPlot.Cursor4) ;
         ReadLogical( Header, 'RECPIGLEAK=', Settings.RecPlot.IgnoreLeakRecords ) ;

          // Read stimulator global variables
          for i := 0 to MaxStimGlobalVars-1 do begin
              ReadFloat( Header, format('GVAR%d=',[i+1]),Stimulator.GlobalVar[i]) ;
              end;


          end ;

        FileCloseSafe( IniFileHandle ) ;

        end ;


     end ;


procedure SaveInitializationFile( const IniFileName : string ) ;
{ --------------------------------------------
  Save program settings to Initialization file
  --------------------------------------------}
type
    TKeyword = string[6] ;
var
   Header : array[1..INIFileSize] of ANSIchar ;
   i,ch : Integer ;
   IniFileHandle : Integer ;
begin

     IniFileHandle := FileCreate( IniFileName ) ;

     HeaderArrayFull := False ;
     { Initialise empty buffer with zero bytes }
     for i := 1 to sizeof(Header) do Header[i] := chr(0) ;

     { Last raw data file used }
     AppendString( Header, 'FILE=', RawFH.FileName ) ;
     { Last averages data file used }
     if AvgFH.Filename <> '' then
           AppendString( Header, 'FILEAVG=', AvgFH.FileName ) ;
     { Last leak subtracted data file used }
     if LeakFH.Filename <> '' then
           AppendString( Header, 'LEAKAVG=', LeakFH.FileName ) ;

     // SAve default recording settings
     AppendInt( Header, 'NC=', Settings.NumChannels ) ;
     AppendInt( Header, 'NSAMP=', Settings.NumSamples ) ;
     AppendFloat( Header, 'RECDUR=', Settings.RecordDuration ) ;

     AppendInt( Header, 'CEDI=', Amplifier.CED1902.Input ) ;
     AppendInt( Header, 'CEDG=', Amplifier.CED1902.Gain ) ;
     AppendFloat( Header, 'CEDGV=', Amplifier.CED1902.GainValue ) ;
     AppendInt( Header, 'CEDLP=', Amplifier.CED1902.LPFilter ) ;
     AppendInt( Header, 'CEDHP=', Amplifier.CED1902.HPFilter ) ;
     AppendInt( Header, 'CEDAC=', Amplifier.CED1902.ACCoupled ) ;
     AppendInt( Header, 'CEDDCO=', Amplifier.CED1902.DCOffset ) ;
     AppendInt( Header, 'CEDNF=', Amplifier.CED1902.NotchFilter ) ;
     AppendInt( Header, 'CEDPO=', Amplifier.CED1902.ComPort ) ;

     // Patch clamp amplifier data
     AppendInt( Header, 'AMP1=',Amplifier.AmplifierType[0] ) ;
     AppendInt( Header, 'AMP1GAINCH=',Amplifier.GainTelegraphChannel[0] ) ;
     AppendInt( Header, 'AMP1MODECH=',Amplifier.ModeTelegraphChannel[0] ) ;
     AppendInt( Header, 'AMP2=',Amplifier.AmplifierType[1] ) ;
     AppendInt( Header, 'AMP2GAINCH=',Amplifier.GainTelegraphChannel[1] ) ;
     AppendInt( Header, 'AMP2MODECH=',Amplifier.ModeTelegraphChannel[1] ) ;

     { Read record settings }
     AppendInt( Header, 'RECMODE=', Settings.RecordingMode ) ;
     { Event detector, channel and % threshold level }
     AppendInt( Header, 'DETCH=', Settings.EventDetector.Channel ) ;
     AppendFloat( Header, 'DETTH=', Settings.EventDetector.Threshold ) ;
     AppendFloat( Header, 'DETPT=', Settings.EventDetector.PreTrigger ) ;
     AppendLogical( Header, 'EXTTRIGAH=', Settings.ExternalTriggerActiveHigh ) ;

     AppendLogical( Header, 'AER=', Settings.AutoErase ) ;
     AppendInt( Header, 'NRQ=', Settings.NumRecordsRequired ) ;
     AppendString( Header, 'FILEVPR=', Settings.VProgramFileName ) ;

     AppendFloat( Header, 'VCHOLD=', Main.SESLabIO.DACHoldingVoltage[0] ) ;
     for ch := 0 to MaxAmplifiers-1 do begin
         AppendFloat( Header, format('VCHOLD%d=',[ch]),Main.SESLabIO.DACHoldingVoltage[ch] ) ;
         end ;

     AppendInt( Header, 'DIGPORT=', Settings.DigitalPort.Value ) ;

     // Invert recording sweep trigger pulse flag
     AppendLogical( Header, 'DACINVTRIG=', Settings.DACInvertTriggerLevel ) ;

     AppendFloat( Header, 'CUTOFF=', Settings.CutOffFrequency ) ;
     AppendString( Header, 'TUNITS=', Settings.TUnits ) ;

     { Pipette seal test settings }
     AppendFloat( Header, 'STPH=', Settings.SealTest.PulseHeight ) ;
     AppendFloat( Header, 'STPH1=', Settings.SealTest.PulseHeight1 ) ;
     AppendFloat( Header, 'STPH2=', Settings.SealTest.PulseHeight2 ) ;
     AppendFloat( Header, 'STPH3=', Settings.SealTest.PulseHeight3 ) ;
     AppendFloat( Header, 'STHV1=', Settings.SealTest.HoldingVoltage1 ) ;
     AppendFloat( Header, 'STHV2=', Settings.SealTest.HoldingVoltage2 ) ;
     AppendFloat( Header, 'STHV3=', Settings.SealTest.HoldingVoltage3 ) ;
     AppendFloat( Header, 'STPW=', Settings.SealTest.PulseWidth ) ;
     AppendInt( Header, 'STCCH=', Settings.SealTest.CurrentChannel ) ;
     AppendInt( Header, 'STVCH=', Settings.SealTest.VoltageChannel ) ;
     AppendInt( Header, 'STUSE=', Settings.SealTest.Use ) ;
     AppendInt( Header, 'STDSC=', Settings.SealTest.DisplayScale ) ;
     AppendLogical( Header, 'STASC=', Settings.SealTest.AutoScale ) ;
     AppendLogical( Header, 'STFRU=', Settings.SealTest.FreeRun ) ;
     AppendInt( Header, 'STNAV=', Settings.SealTest.NumAverages ) ;
     AppendFloat( Header, 'STZAPA=', Settings.SealTest.ZapAmplitude ) ;
     AppendFloat( Header, 'STZAPD=', Settings.SealTest.ZapDuration ) ;
     AppendLogical( Header, 'STGAP=', Settings.SealTest.GaFromPeak ) ;

     AppendInt( Header, 'NC=', RawFH.NumChannels ) ;

     RawFH.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(RawFH.NumChannels) ;
     AppendInt( Header, 'NBA=', 1 ) ;
     AppendInt(Header,'NBD=',((RawFH.NumSamples*RawFH.NumChannels*2) div 512 )) ;

     AppendFloat( Header, 'AD=', RawFH.ADCVoltageRange ) ;

     AppendFloat( Header, 'DT=',RawFH.dt );

     { Plotting page settings }
     AppendFloat( Header, 'PLTPM=',Settings.Plot.TopMargin ) ;
     AppendFloat( Header, 'PLBTM=',Settings.Plot.BottomMargin ) ;
     AppendFloat( Header, 'PLLFM=',Settings.Plot.LeftMargin ) ;
     AppendFloat( Header, 'PLRTM=',Settings.Plot.RightMargin ) ;
     AppendString( Header, 'PLFNT=',Settings.Plot.FontName ) ;
     AppendInt( Header, 'PLFSI=',Settings.Plot.FontSize ) ;
     AppendInt( Header, 'PLLTH=',Settings.Plot.LineThickness ) ;
     AppendLogical( Header, 'PLSHL=',Settings.Plot.ShowLines ) ;
     AppendInt( Header, 'PLMKS=',Settings.Plot.MarkerSize ) ;
     AppendLogical( Header, 'PLSHM=',Settings.Plot.ShowMarkers ) ;
     AppendLogical( Header, 'PLCOL=',Settings.Plot.UseColor ) ;
     { Width/height of clipboard metafiles }
     AppendInt( Header, 'PLMFW=', Settings.Plot.MetafileWidth ) ;
     AppendInt( Header, 'PLMFH=', Settings.Plot.MetafileHeight ) ;

     // Calibration bar settings
     AppendFloat( Header, 'TBVAL=',Settings.TimeBarValue ) ;
     for ch := 0 to WCPMaxChannels-1 do
         AppendFloat( Header, format('BVAL%d=',[ch]),
                      Settings.BarValue[ch] ) ;

     //AppendFloat( Header, 'SRT=',Settings.SectorWriteTime ) ;

     AppendString( Header, 'DDIR=', Settings.DataDirectory ) ;

     AppendString( Header, 'VPDIR=', Settings.VprotDirectory ) ;

     AppendString( Header, 'PLNAME=', Settings.ProtocolListFileName ) ;

     AppendLogical( Header, 'FNINCDATE=', Settings.FileNameIncludeDate ) ;
     AppendString( Header, 'FNPREFIX=', Settings.FileNamePrefix ) ;

     AppendString( Header, 'RF0=', Settings.RecentFiles[0] ) ;
     AppendString( Header, 'RF1=', Settings.RecentFiles[1] ) ;
     AppendString( Header, 'RF2=', Settings.RecentFiles[2] ) ;
     AppendString( Header, 'RF3=', Settings.RecentFiles[3] ) ;

     AppendInt( Header, 'LABINT=',Settings.LaboratoryInterface ) ;
     AppendInt( Header, 'LABDEV=',Settings.DeviceNumber ) ;
     AppendInt( Header, 'LABADIP=',Settings.ADCInputMode ) ;

     { Waveform generator No Display check box setting }
     AppendLogical( Header, 'WGNDSP=', Settings.WavGenNoDisplay ) ;

//     { Time first record in current data file was recorded }
//     AppendFloat( Header, 'TRS=',Settings.TimeRecordingStarted ) ;

     { Differentiation mode for waveform measurements }
     AppendInt( Header, 'DIFFM=', Settings.DifferentiationMode ) ;

     // Lock waveform measurements analysis cursors flag (measurefrm)
     AppendLogical( Header,'LOCKCHC=', Settings.LockChannelCursors ) ;

     { Display autoerase flag }
     AppendLogical( Header, 'AUTOERASE=', Settings.AutoErase ) ;

     { Display grid flag }
     AppendLogical( Header, 'DISPGRID=', Settings.DisplayGrid ) ;

     for ch := 0 to RawFH.NumChannels-1 do begin
         AppendString( Header, format('YU%d=',[ch]), Main.SESLabIO.ADCChannelUnits[ch] ) ;
         AppendString( Header, format('YN%d=',[ch]), Main.SESLabIO.ADCChannelName[ch] ) ;
         AppendFloat( Header, format('YG%d=',[ch]),
                      Main.SESLabIO.ADCChannelVoltsPerUnit[ch] ) ;
         { Zero level (in fixed mode) }
         AppendInt( Header, format('YZ%d=',[ch]), Main.SESLabIO.ADCChannelZero[ch]) ;
         { Start of zero level reference samples (-1 = fixed zero) }
         AppendInt( Header, format('YR%d=',[ch]), Main.SESLabIO.ADCChannelZeroAt[ch]) ;
         end ;

     // Save voltage clamp simulation settings (VCLAMPSim)
     AppendInt( Header, 'VCSIMNS=', Settings.VClampSim.NumSteps );
     AppendFloat( Header, 'VCSIMGMAX=', Settings.VClampSim.GMax );
     AppendFloat( Header, 'VCSIMGLEAK=', Settings.VClampSim.GLeak );
     AppendFloat( Header, 'VCSIMGSERIES=', Settings.VClampSim.GSeries );
     AppendFloat( Header, 'VCSIMCM=', Settings.VClampSim.Cm );
     AppendFloat( Header, 'VCSIMVREV=', Settings.VClampSim.VRev );
     AppendFloat( Header, 'VCSIMVHOLD=', Settings.VClampSim.VHold );
     AppendFloat( Header, 'VCSIMVSTEP=', Settings.VClampSim.VStep );

     { Activation gate (m) parameters }
     AppendFloat( Header, 'VCSIMMSSVH=', Settings.VClampSim.m.VHalf );
     AppendFloat( Header, 'VCSIMMSSVS=', Settings.VClampSim.m.VSlope );
     AppendFloat( Header, 'VCSIMMTAUMIN=', Settings.VClampSim.m.TauMin  );
     AppendFloat( Header, 'VCSIMMTAUMAX=', Settings.VClampSim.m.TauMax );
     AppendFloat( Header, 'VCSIMMTAUVH=', Settings.VClampSim.m.TauVHalf  );
     AppendFloat( Header, 'VCSIMMTAUVS=', Settings.VClampSim.m.TauVslope  );
     AppendFloat( Header, 'VCSIMPFAC=', Settings.VClampSim.m.P  );

     { Inactivation gate (h) parameters }
     AppendLogical( Header, 'VCSIMHUSE=', Settings.VClampSim.UseInactivation  );
     AppendFloat( Header, 'VCSIMHSSVH=', Settings.VClampSim.h.VHalf  );
     AppendFloat( Header, 'VCSIMHSSVS=', Settings.VClampSim.h.VSlope  );
     AppendFloat( Header, 'VCSIMHTAUMIN=', Settings.VClampSim.h.TauMin  );
     AppendFloat( Header, 'VCSIMHTAUMAX=', Settings.VClampSim.h.TauMax  );
     AppendFloat( Header, 'VCSIMHTAUVH=', Settings.VClampSim.h.TauVHalf  );
     AppendFloat( Header, 'VCSIMHTAUVS=', Settings.VClampSim.h.TauVslope  );

     // Synapse simulation settings (SynapseSim)
     AppendInt( Header, 'SYSIMNRECS=',Settings.SynapseSim.NumRecords ) ;
     AppendFloat( Header, 'SYSIMDUR=',Settings.SynapseSim.RecordDuration ) ;
     AppendFloat( Header, 'SYSIMTAURISE=',Settings.SynapseSim.TauRise ) ;
     AppendFloat( Header, 'SYSIMTAU1=',Settings.SynapseSim.Tau1 ) ;
     AppendFloat( Header, 'SYSIMLATENCY=',Settings.SynapseSim.Latency ) ;
     AppendFloat( Header, 'SYSIMTAU2=',Settings.SynapseSim.Tau2 ) ;
     AppendLogical( Header, 'SYSSIMDEXP=',Settings.SynapseSim.DoubleExponentialDecay ) ;
     AppendFloat( Header, 'SYSIMA2F=',Settings.SynapseSim.A2Fraction ) ;
     AppendFloat( Header, 'SYSIMQAMP=',Settings.SynapseSim.QuantumAmplitude ) ;
     AppendFloat( Header, 'SYSIMQSTD=',Settings.SynapseSim.QuantumStDev ) ;
     AppendFloat( Header, 'SYSIMN=',Settings.SynapseSim.n ) ;
     AppendFloat( Header, 'SYSIMP=',Settings.SynapseSim.p ) ;
     AppendFloat( Header, 'SYSIMNOISE=',Settings.SynapseSim.NoiseRMS ) ;
     AppendFloat( Header, 'SYSIMDRANGE=',Settings.SynapseSim.DisplayRange ) ;
     AppendFloat( Header, 'SYSIMVREST=',Settings.SynapseSim.VRest ) ;

     // MEPSCSim settings
     AppendInt( Header, 'MEPSIMNR=',Settings.MEPSCSim.NumRecords) ;
     AppendFloat( Header, 'MEPSIMDUR=',Settings.MEPSCSim.RecordDuration) ;
     AppendFloat( Header, 'MEPSIMUC=',Settings.MEPSCSim.UnitCurrent) ;
     AppendFloat( Header, 'MEPSIMTDEC=',Settings.MEPSCSim.TransmitterDecayTime) ;

     AppendFloat( Header, 'MEPSIMBIR=',Settings.MEPSCSim.BindingRate) ;
     AppendFloat( Header, 'MEPSIMOPR=',Settings.MEPSCSim.OpenRate) ;
     AppendFloat( Header, 'MEPSIMCLR=',Settings.MEPSCSim.CloseRate) ;
     AppendFloat( Header, 'MEPSIMUBR=',Settings.MEPSCSim.UnbindRate) ;
     AppendFloat( Header, 'MEPSIMBLR=',Settings.MEPSCSim.BlockRate) ;
     AppendFloat( Header, 'MEPSIMUBR=',Settings.MEPSCSim.UnBlockRate) ;

     AppendFloat( Header, 'MEPSIMNOI=',Settings.MEPSCSim.NoiseRMS) ;
     AppendFloat( Header, 'MEPSIMLPF=',Settings.MEPSCSim.LPFilter) ;

     AppendLogical( Header, 'MEPSIMLPFIU=',Settings.MEPSCSim.LPFilterInUse) ;
     AppendFloat( Header, 'MEPSIMDRI=',Settings.MEPSCSim.Drift) ;

     AppendLogical( Header, 'FIXZERO=', Settings.FixedZeroLevels) ;
     AppendLogical( Header, 'NEWFILEONREC=', Settings.OpenNewFileOnRecord) ;

     // On-line analysis settings
     AppendInt( Header, 'RECPNPLOTS=',Settings.RecPlot.NumPlots ) ;
     for i := 0 to Settings.RecPlot.NumPlots-1 do
         begin
         AppendInt( Header, format('RECPVAR%d=',[i]),Settings.RecPlot.Plot[i].VarNum ) ;
         AppendInt( Header, format('RECPCHAN%d=',[i]),Settings.RecPlot.Plot[i].ChanNum ) ;
         AppendString( Header, format('RECPYLAB%d=',[i]),Settings.RecPlot.Plot[i].YLabel ) ;
         AppendString( Header, format('RECPLE%d=',[i]),Settings.RecPlot.Plot[i].ListEntry ) ;
         AppendInt( Header, format('RECPPOL%d=',[i]),Settings.RecPlot.Plot[i].Polarity ) ;
         AppendInt( Header, format('RECPRRS%d=',[i]),Settings.RecPlot.Plot[i].RateofRiseSmoothing ) ;
         AppendInt( Header, format('RECPCS%d=',[i]),Settings.RecPlot.Plot[i].CursorSet ) ;
         AppendString( Header, format('RECPSTIM%d=',[i]),Settings.RecPlot.Plot[i].StimProtocol ) ;
         end;

     AppendFloat( Header, 'RECPCURS0=',Settings.RecPlot.Cursor0) ;
     AppendFloat( Header, 'RECPCURS1=',Settings.RecPlot.Cursor1) ;
     AppendFloat( Header, 'RECPCURS2=',Settings.RecPlot.Cursor2) ;
     AppendFloat( Header, 'RECPCURS3=',Settings.RecPlot.Cursor3) ;
     AppendFloat( Header, 'RECPCURS4=',Settings.RecPlot.Cursor4) ;
     AppendLogical( Header, 'RECPIGLEAK=', Settings.RecPlot.IgnoreLeakRecords ) ;

     // Save stimulator global variables
     for i := 0 to MaxStimGlobalVars-1 do begin
         AppendFloat( Header, format('GVAR%d=',[i+1]),Stimulator.GlobalVar[i]) ;
         end;

     if FileWrite( IniFileHandle, Header, Sizeof(Header) ) <> Sizeof(Header) then
        ShowMessage( IniFileName + ' Write - Failed!' ) ;
     FileCloseSafe( IniFileHandle ) ;

     if HeaderArrayFull then
        ShowMessage( INIFileName + ' File header parameter array full!' ) ;

     end ;


procedure PutRecord(
          var fHDR : TFileHeader;         { File header block }
          var rH : TRecHeader ;           { Record header block }
          RecordNum : Integer ;           { Record number }
          var dBuf : Array of SmallInt    { A/D data buffer }
          ) ;
{ -------------------------------------------------
  Write a WCP format digital signal record to file
  -------------------------------------------------}
begin

     // Set file and record header sizes if no records in file
     fHDR.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(fHDR.NumChannels) ;
     fHDR.NumBytesInHeader := NumBytesInFileHeader(fHDR.NumChannels) ;

     fHDR.RecordNum := RecordNum ;
     fHDR.NumDataBytesPerRecord := fHDR.NumSamples*fHDR.NumChannels*2 ;
     fHDR.NumBytesPerRecord := fHDR.NumDataBytesPerRecord +
                               fHDR.NumAnalysisBytesPerRecord  ;

     { Write data to record analysis block }
     PutRecordHeaderOnly( fHDR, RH, RecordNum ) ;

     { Move file pointer to start of record data block }
     FileSeek( FHDR.FileHandle,
               fHDR.NumBytesInHeader +
               fHDR.NumBytesPerRecord*(RecordNum-1) +
               fHDR.NumAnalysisBytesPerRecord,
               0 ) ;

     { Write A/D samples to data file }
     if FileWrite( FHDR.FileHandle, dBuf, FHDR.NumDataBytesPerRecord )
        <> FHDR.NumDataBytesPerRecord then
        WriteToLogFileNoDate( format('Error writing Rec=%d to %s',
                                     [FHDR.RecordNum,FHDR.FileName]) ) ;

     end ;


procedure PutRecordHeaderOnly(
          var fHDR : TFileHeader;    { Data file header }
          var rH : TRecHeader ;    { Record header }
          RecordNum : Integer ) ;    { Record number }
{ -------------------------------------------------------
  Write a WCP format digital signal record header to file
  -------------------------------------------------------}
var
   cBuf : Array[0..255] of ANSIchar ;
begin

     // Set file and record header sizes if no records in file
     fHDR.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(fHDR.NumChannels) ;
     fHDR.NumBytesInHeader := NumBytesInFileHeader(fHDR.NumChannels) ;

     fHDR.RecordNum := RecordNum ;
     fHDR.NumDataBytesPerRecord := fHDR.NumSamples*fHDR.NumChannels*2 ;
     fHDR.NumBytesPerRecord := fHDR.NumDataBytesPerRecord +
                               fHDR.NumAnalysisBytesPerRecord  ;

     // Copy record details in values array
     RH.Value[vRecord] := RecordNum ;
     RH.Value[vGroup] := RH.Number ;
     RH.Value[vTime] := RH.Time ;

     // Copy equation data to values table
     RH.Value[vFitEquation] := Integer(RH.EqnType) ;
     RH.Value[vFitCursor0] := RH.FitCursor0 ;
     RH.Value[vFitCursor1] := RH.FitCursor1 ;
     RH.Value[vFitCursor2] := RH.FitCursor2 ;
     RH.Value[vFitChan] := RH.FitChan ;

     { Write record header block to file }
     FileSeek( FHDR.FileHandle,
               (RecordNum-1)*FHDR.NumBytesPerRecord + FHDR.NumBytesInHeader,
               0 ) ;

     // Record ACCEPTED/REJECTED status string (8 chars)
     CopyStringToANSIArray(cBuf,LeftStr(RH.Status,MaxRecordStatusChars)) ;
     FileWrite( FHDR.FileHandle, cBuf, MaxRecordStatusChars ) ;

     // Record type string (4 chars)
     CopyStringToANSIArray( cBuf, LeftStr(RH.RecType,MaxRecordTypeChars) ) ;
     FileWrite( FHDR.FileHandle, cBuf, MaxRecordTypeChars ) ;

     FileWrite( FHDR.FileHandle, rH.Number, sizeof(rH.Number) ) ;
     FileWrite( FHDR.FileHandle, rH.Time, sizeof(rH.Time) ) ;
     FileWrite( FHDR.FileHandle, rH.dt, sizeof(rH.dt) ) ;

     { Write A/D voltage range for each channel }
     FileWrite(FHDR.FileHandle,rH.ADCVoltageRange,sizeof(single)*FHDR.NumChannels) ;

     { Write record ident line }
     CopyStringToANSIArray( cBuf, LeftStr(RH.Ident,MaxRecordIdentChars) ) ;
     FileWrite( FHDR.FileHandle, cBuf, MaxRecordIdentChars ) ;

     { Write Analysis variables }
     FileWrite( FHDR.FileHandle, rH.Value,sizeof(single)*Max(FHDR.NumChannels,8)*MaxAnalysisVariables ) ;

     end ;


procedure GetRecord(
          var fHDR : TFileHeader;      { Data file header }
          var rH : TRecHeader ;        { Record header }
          RecordNum : Integer ;        { Record number }
          var dBuf : Array of SmallInt { A/D data array }
          ) ;
{ --------------------------------------------------
  Read a WCP format digital signal record from file
  --------------------------------------------------}
var
   i,ch,i0,i1,Sum,ChOffset,FilePointer : Integer ;
begin

     { Get record header data and store in analysis block RH }
     GetRecordHeaderOnly( fHDR, RH, RecordNum ) ;

     { Read A/D samples from record data block on file }
     fHDR.RecordNum := RecordNum ;
     fHDR.NumDataBytesPerRecord := fHDR.NumSamples*fHDR.NumChannels*2 ;
     fHDR.NumBytesPerRecord := fHDR.NumDataBytesPerRecord +
                               fHDR.NumAnalysisBytesPerRecord  ;

     { Move file pointer to start of record data block }
     FilePointer := FileSeek( FHDR.FileHandle,
               fHDR.NumBytesInHeader +
               fHDR.NumBytesPerRecord*(RecordNum-1) +
               fHDR.NumAnalysisBytesPerRecord,
               0 ) ;

     { Read data block }
     if FileRead( FHDR.FileHandle, dBuf, FHDR.NumDataBytesPerRecord )
        <> FHDR.NumDataBytesPerRecord then begin
        WriteToLogFilenoDate( format('Error reading file %s, Rec=%d',
                              [fHDR.FileName,fHDR.RecordNum])) ;
        end ;

     {Apply digital filter}
     if Settings.CutOffFrequency > 0.0 then
        GaussianFilter( FHDR, dBuf, Settings.CutOffFrequency ) ;

     { Calculate zero level for each channel }
     for ch := 0 to FHDR.NumChannels - 1 do begin
         ChOffset := Channel[Ch].ChannelOffset ;
         if Channel[ch].ADCZeroAt >= 0 then begin
            i0 := Channel[ch].ADCZeroAt ;
            i0 := Min(Max( i0,0 ),FHDR.NumSamples-1 ) ;
            i1 := i0 + FHDR.NumZeroAvg - 1 ;
            i1 := Min(Max( i1,0 ),FHDR.NumSamples-1 ) ;
            Sum := 0 ;
            for i := i0 to i1 do Sum := Sum + dBuf[i*FHDR.NumChannels + ChOffset] ;
            Channel[ch].ADCZero := Sum div (i1-i0+1) ;
            end ;
         end ;
     end ;


procedure GetRecordWCPV8(
          var fHDR : TFileHeader;      { Data file header }
          var rH : TRecHeader ;        { Record header }
          RecordNum : Integer ;        { Record number }
          var dBuf : Array of SmallInt { A/D data array }
          ) ;
{ --------------------------------------------------
  Read a WCP V8 format digital signal record from file
  --------------------------------------------------}
begin

     { Get record header data and store in analysis block RH }
     GetRecordHeaderOnlyWCPV8( fHDR, RH, RecordNum ) ;

     { Read A/D samples from record data block on file }
     fHDR.RecordNum := RecordNum ;
     fHDR.NumDataBytesPerRecord := fHDR.NumSamples*fHDR.NumChannels*2 ;
     fHDR.NumBytesPerRecord := fHDR.NumDataBytesPerRecord +
                               fHDR.NumAnalysisBytesPerRecord  ;

     { Move file pointer to start of record data block }
     FileSeek( FHDR.FileHandle,
               fHDR.NumBytesInHeader +
               fHDR.NumBytesPerRecord*(RecordNum-1) +
               fHDR.NumAnalysisBytesPerRecord,
               0 ) ;

     { Read data block }
     if FileRead( FHDR.FileHandle, dBuf, FHDR.NumDataBytesPerRecord )
        <> FHDR.NumDataBytesPerRecord then begin
        WriteToLogFilenoDate( format('Error reading file %s, Rec=%d',
                              [fHDR.FileName,fHDR.RecordNum])) ;
        end ;

     end ;


procedure GetRecord32(
          var fHDR : TFileHeader;      { Data file header }
          var rH : TRecHeader ;        { Record header }
          RecordNum : Integer ;        { Record number }
          var dBuf : Array of Integer { A/D data array }
          ) ;
// --------------------------------------------
// Load A/D data from record into 32 bit buffer
// --------------------------------------------
var
    i : Integer ;
    dBuf16 : PSmallIntArray ;
begin

    GetMem( dBuf16, FH.NumSamples*fh.NumChannels*2) ;

    // Read data from file
    GetRecord( fHDR, rH, RecordNum, dBuf16^ ) ;

    for i := 0 to fHDR.NumSamples*fHDR.NumChannels-1 do dBuf[i] := dBuf16[i] ;

    FreeMem(dBuf16) ; // Free buffer

    end ;


procedure PutRecord32(
          var fHDR : TFileHeader;      { Data file header }
          var rH : TRecHeader ;        { Record header }
          RecordNum : Integer ;        { Record number }
          var dBuf : Array of Integer { A/D data array }
          ) ;
// --------------------------------------------
// Save A/D data from record into 32 bit buffer
// --------------------------------------------
var
    i : Integer ;
    dBuf16 : PSmallIntArray ;
begin

    GetMem( dBuf16, FH.NumSamples*fh.NumChannels*2) ;

    for i := 0 to fHDR.NumSamples*fHDR.NumChannels-1 do dBuf16[i] := dBuf[i]  ;

    // Read data from file
    PutRecord( fHDR, rH, RecordNum, dBuf16^ ) ;

    FreeMem(dBuf16) ; // Free buffer

    end ;



procedure GetRecordHeaderOnly(
          var fHDR : TFileHeader;      { Data file header }
          var rH : TRecHeader ;        { Record header }
          RecordNum : Integer          { Record number }
          ) ;
{ --------------------------------------------------------
  Read a WCP format digital signal record header from file
  --------------------------------------------------------}
var
   ch,i,FilePointer : Integer ;
   cRecID : array[0..MaxRecordIdentChars-1] of ANSIchar ;
   cStatus : Array[0..MaxRecordStatusChars-1] of ANSIchar ;
   cRecType : Array[0..MaxRecordTypeChars-1] of ANSIchar ;
   OK : Boolean ;
begin

     fHDR.RecordNum := RecordNum ;
     fHDR.NumDataBytesPerRecord := fHDR.NumSamples*fHDR.NumChannels*2 ;
     fHDR.NumBytesPerRecord := fHDR.NumDataBytesPerRecord +
                               fHDR.NumAnalysisBytesPerRecord  ;

     { Move file pointer to start of record header block }
     FilePointer := FileSeek( FHDR.FileHandle,
                    (RecordNum-1)*fHDR.NumBytesPerRecord + fHDR.NumBytesInHeader,
                    0 ) ;

     { Read record header data }

     FileRead( FHDR.FileHandle, cStatus, SizeOf(cStatus));

     if ANSIContainsText(cStatus,'acce') or
        ANSIContainsText(cStatus,'reje') then begin

        // If status of record is valid, read rest of record from file

        rH.Status := cStatus ;
        // Read record header data
        FileRead( FHDR.FileHandle, cRecType, SizeOf(cRecType) ) ;
        rH.RecType := cRecType ;
        // Ensure valid record type
        OK := False ;
        for i := 0 to RecordTypes.Count-1 do
            if RecordTypes.Strings[i] = UpperCase(rH.RecType) then OK := True ;
        if not OK then rH.RecType := 'TEST' ;

        FileRead( FHDR.FileHandle, rH.Number, sizeof(rH.Number) ) ;
        FileRead( FHDR.FileHandle, rH.Time, sizeof(rH.Time) ) ;
        FileRead( FHDR.FileHandle, rH.dt, sizeof(rH.dt) ) ;

        { Read channel A/D converter voltage range }
        FileRead(FHDR.FileHandle,rH.ADCVoltageRange,sizeof(single)*FHDR.NumChannels ) ;
        { Ensure all channels have a valid voltage range }
        for Ch := 0 to FHDR.NumChannels-1 do begin
            if (fHDR.Version < 6.0) or (rH.ADCVoltageRange[ch]=0.0) then
               rH.ADCVoltageRange[ch] := rH.ADCVoltageRange[0] ;
            Channel[ch].ADCScale := CalibFactorToADCScale( RH, ch ) ;
            end ;

        { Read record ident text }
        FileRead( FHDR.FileHandle, cRecID, SizeOf(cRecID) );
        RH.Ident := cRecID ;

        { Read Analysis block }
        FileRead( FHDR.FileHandle, rH.Value,sizeof(single)*Max(FHDR.NumChannels,8)*MaxAnalysisVariables ) ;

        if RH.Value[0] > 0.0 then rH.AnalysisAvailable := True
                             else rH.AnalysisAvailable := False ;

        // Get type of fitted equation
        RH.EqnType := TEqnType(Min(Max(Round(RH.Value[vFitEquation]),0),99)) ;
        RH.FitCursor0 := Min(Max(Round(RH.Value[vFitCursor0]),0),FHDR.NumSamples-1) ;
        RH.FitCursor1 := Min(Max(Round(RH.Value[vFitCursor1]),0),FHDR.NumSamples-1) ;
        RH.FitCursor2 := Min(Max(Round(RH.Value[vFitCursor2]),0),FHDR.NumSamples-1) ;
        RH.FitChan := Min(Max(Round(RH.Value[vFitChan]),0), FHDR.NumChannels-1) ;

        // Copy record details in values array
        RH.Value[vRecord] := RecordNum ;
        RH.Value[vGroup] := RH.Number ;
        RH.Value[vTime] := RH.Time ;

        end
     else begin
        // Invalid analysis block - Fill record with default values
        rH.Status := 'ACCE' ;
        rH.RecType := 'TEST' ;
        rH.Number := RecordNum ;
        rH.dt := fHDR.dt ;
        rH.Time := (fHDR.NumSamples*rH.dt)*(rH.Number-1.0) ;
        rH.Ident := 'Error' ;
        for Ch := 0 to FHDR.NumChannels-1 do begin
            RH.ADCVoltageRange[ch] := fHDR.ADCVoltageRange ;
            Channel[ch].ADCScale := CalibFactorToADCScale( RH, ch ) ;
            end ;

        rH.AnalysisAvailable := False ;
        for i := 0 to High(RH.Value) do RH.Value[i] := 0.0 ;

        // Save changes to file
        PutRecordHeaderOnly( fHDR, RH, RecordNum ) ;

        end ;

     end ;


procedure GetRecordHeaderOnlyWCPV8(
          var fHDR : TFileHeader;      { Data file header }
          var rH : TRecHeader ;        { Record header }
          RecordNum : Integer          { Record number }
          ) ;
{ --------------------------------------------------------
  Read a WCP V8 format digital signal record header from file
  --------------------------------------------------------}
const
    MaxChannelsWCPV8 = 8 ;
    MaxVariablesWCPV8 = 14 ;
var
   i,ch : Integer ;
   cRecID : array[0..MaxRecordIdentChars-1] of ANSIchar ;
   cStatus : Array[0..MaxRecordStatusChars-1] of ANSIchar ;
   cRecType : Array[0..MaxRecordTypeChars-1] of ANSIchar ;

begin

     fHDR.RecordNum := RecordNum ;
     fHDR.NumDataBytesPerRecord := fHDR.NumSamples*fHDR.NumChannels*2 ;
     fHDR.NumBytesPerRecord := fHDR.NumDataBytesPerRecord +
                               fHDR.NumAnalysisBytesPerRecord  ;

     { Move file pointer to start of record header block }
     FileSeek( FHDR.FileHandle,
               (RecordNum-1)*fHDR.NumBytesPerRecord + fHDR.NumBytesInHeader,
               0 ) ;

     { Read record header data }

     FileRead( FHDR.FileHandle, cStatus, SizeOf(cStatus));
     rH.Status := cStatus ;

     FileRead( FHDR.FileHandle, cRecType, SizeOf(cRecType) ) ;
     rH.RecType := cRecType ;

     FileRead( FHDR.FileHandle, rH.Number, sizeof(rH.Number) ) ;
     FileRead( FHDR.FileHandle, rH.Time, sizeof(rH.Time) ) ;
     FileRead( FHDR.FileHandle, rH.dt, sizeof(rH.dt) ) ;

     { Read channel A/D converter voltage range }
     FileRead(FHDR.FileHandle,rH.ADCVoltageRange,sizeof(Single)*MaxChannelsWCPV8 ) ;
     { Ensure all channels have a valid voltage range }
     for Ch := 0 to FHDR.NumChannels-1 do begin
         if (fHDR.Version < 6.0) or (rH.ADCVoltageRange[ch]=0.0) then
            rH.ADCVoltageRange[ch] := rH.ADCVoltageRange[0] ;
         Channel[ch].ADCScale := CalibFactorToADCScale( RH, ch ) ;
         end ;

     // Skip waveform analysis and fit data
     FileSeek( FHDR.FileHandle,
               1 {RH.Available}
               + MaxVariablesWCPV8*MaxChannelsWCPV8*SizeOf(Single) {RH.Values}
               + 163 {RD.Equation}
               ,1) ;

     // Initialise RH.Values arrays
     for i := 0 to High(RH.Value) do RH.Value[i] := 0.0 ;

     { Read record ident text }
     FileRead( FHDR.FileHandle, cRecID, SizeOf(cRecID) );
     RH.Ident := cRecID ;

     end ;


function CalibFactorToADCScale(
         var RH : TRecHeader ;
         Ch : Integer
         ) : single ;
begin
     try
        if Channel[ch].ADCCalibrationFactor = 0.0 then Channel[ch].ADCCalibrationFactor := 0.001 ;
        Result := Abs(RH.ADCVoltageRange[ch]) /
                 (Channel[ch].ADCCalibrationFactor*(RawFH.MaxADCValue+1) ) ;
     except
        on EInvalidOP do Result := 1.0 ;
        end ;
     end ;

function NumAnalysisBytesPerRecord(
         NumChannels : Integer ) : Integer ;
begin
     Result := (((NumChannels-1) div 8)+1)*1024 ;
     end ;

function NumBytesInFileHeader(
         NumChannels : Integer ) : Integer ;
begin
     Result := (((NumChannels-1) div 8)+1)*1024 ;
     end ;


procedure OpenLogFile ;
{ -------------
  Open log file
  ------------- }
begin

     { Create a log file using current date }
    {$IF CompilerVersion > 7.0} formatsettings.DateSeparator := '-';
     {$ELSE} DateSeparator := '-';
     {$IFEND}

     Main.LogFileName := Main.SettingsDirectory + DateToStr(Date)+'.log' ;
     LogFileAvailable := True ;
     AssignFile( LogFile, Main.LogFileName ) ;
     try
           if FileExists( Main.LogFileName ) then Append(LogFile)
                                        else ReWrite(LogFile) ;
     except
           on EInOutError do begin
              //MessageDlg( ' WinWCP - Cannot create Log File', mtWarning, [mbOK], 0 ) ;
              LogFileAvailable := False ;
              end ;
           end ;
     { If file doesn't exist ... disable access }
     Main.InspectLogFile.Enabled := LogFileAvailable ;
     end ;


procedure WriteToLogFile( Line : string ) ;
{ ---------------------------------------------
  Write a date-stamped line of text to log file
  --------------------------------------------- }
begin
     if LogFileAvailable then WriteLn( LogFile, TimeToStr(Time) + ' ' + Line ) ;
     end ;


procedure WriteToLogFileNoDate( Line : string ) ;
{ --------------------------------
  Write a line of text to log file
  -------------------------------- }
begin
     if LogFileAvailable then WriteLn( LogFile, Line ) ;
     end ;


procedure CloseLogFile ;
{ --------------
  Close log file
  -------------- }
begin
     if LogFileAvailable then begin
        try
           CloseFile(LogFile) ;
        except
              on EInOutError do begin
              ShowMessage( ' WinWCP - Error closing Log File') ;
              LogFileAvailable := False ;
              end ;
           end ;
        end ;
     end ;


procedure GaussianFilter(
          const FHdr : TFileHeader ;     { Header of file to be filtered }
          Var Buf : Array of SmallInt ;  { Data to be filtered }
          CutOffFrequency : single       { Filter cut-off frequency (Hz) }
          ) ;
{ --------------------------------------------------
  Gaussian digital filter. (based on Sigworth, 1983)
  --------------------------------------------------}
const
     MaxCoeff = 54 ;
var
   a : Array[-MaxCoeff..MaxCoeff] of single ;
   Temp,sum,b,sigma : single ;
   i,i1,j,j1,nc,Ch,ChOffset : Integer ;
   EndofData : Integer ;
   Work : ^TLongIntArray ;
begin

      New(Work) ;

      { Generate filter coefficients }
      sigma := 0.132505/CutOffFrequency ;
      if  sigma >= 0.62  then begin

	     b := -1./(2.*sigma*sigma) ;
	     nc := 0 ;
	     a[0] := 1. ;
	     sum := 1. ;
	     temp := 1. ;
	     while (temp >= 10.*MinSingle) and (nc < MaxCoeff) do begin
	           Inc(nc) ;
	           temp := exp( nc*nc*b ) ;
	           a[nc] := temp ;
                   a[-nc] := Temp ;
	           sum := sum + 2.*temp ;
                   end ;

             { Normalise coefficients so that they summate to 1. }
	     for i := -nc to nc do a[i] := a[i]/sum ;
             end
         else begin
            { Special case for very light filtering
              (See Colquhoun & Sigworth, 1983) }
            a[1] := (sigma*sigma)/2.0 ;
            a[-1] := a[1] ;
	    a[0] := 1.0 - 2.0*a[1] ;
	    nc := 1 ;
            end ;

         { Copy data into work array }
         for i := 0 to (FHdr.NumSamples*FHdr.NumChannels)-1 do Work^[i] := Buf[i] ;

         { Apply filter to each channel }
         for Ch := 0 to FHdr.NumChannels-1 do begin

             { Apply gaussian filter to each point
               and store result back in buffer }
             ChOffset := GetChannelOffset(Ch,FHdr.NumChannels) ;
             i1 := ChOffset ;
             EndOfData := FHdr.NumSamples -1 ;
             for i := 0 to EndOfData do begin
	         sum := 0. ;
	         for j := -nc to nc do begin
                     j1 := j+i ;
                     if j1 < 0 then j1 := 0 ;
                     if j1 > EndofData then j1 := EndofData ;
                     j1 := j1*FHdr.NumChannels + ChOffset ;
	             sum := sum + (Work^[j1])*a[j] ;
                     end ;
                 Buf[i1] := Trunc(sum) ;
                 i1 := i1 + FHdr.NumChannels ;
                 end ;
             end ;

      Dispose(Work) ;

      end ;

procedure FileCloseSafe( var FileHandle : Integer ) ;
// -------------------------
// Safe close file procedure
// -------------------------
begin
     // Close file (if it is open)
     if FileHandle >= 0 then FileClose( FileHandle ) ;
     // File handle = -1 indicates closed file
     FileHandle := -1 ;
     end ;


function FileOverwriteCheck(
         var FileName : string 
         ) : boolean ;
{ ----------------------------------------------------------------------
  To avoid overwriting an existing data file, check whether the file
  "FileName" exists and give the user the chance to change the name or
  abandon the operation.
  Returns FALSE if the user has chosen to abandon the operation
  ---------------------------------------------------------------------}
const
     OK = True ;
begin
     { Check whether file exists }
     if FileExists(FileName) then begin
          { If it exists, let user change it's name }
          Main.SaveDialog.options := [ofHideReadOnly,ofPathMustExist] ;
          Main.SaveDialog.DefaultExt := DataFileExtension ;
          Main.SaveDialog.FileName := ExtractFileName( FileName ) ;
          Main.SaveDialog.Filter := format( ' WCP Files (*%s)|*%s',
                                    [DataFileExtension,DataFileExtension]) ;
          Main.SaveDialog.Title := ExtractFileName(FileName)
                                   + ' already exists! Change Name? ';

          if Main.SaveDialog.execute then begin
             { Save data directory }
             Settings.DataDirectory := ExtractFilePath( Main.SaveDialog.FileName ) ;
             { Use new file name entered by user }
             FileName := Main.SaveDialog.FileName ;
             { User has clicked OK, tell calling routine to go ahead }
             Result := OK ;
             end
          else begin
               { User has clicked CANCEL, tell calling routine to give up }
               Result := not OK ;
               end ;
          end
     else begin
          { File doesn't exist, no overwrite possible }
          Result := OK ;
          end ;
     end ;





initialization
    LogFileAvailable := False ;

end.
