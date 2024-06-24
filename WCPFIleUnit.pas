unit WCPFIleUnit ;
// ========================
// WCP Data File I/O Module
// ========================
// 06.07.22 Functions from filio.pas and records from global.pas collected here

{/(c) J.Dempster, University of Strathclyde 1996-2022. All Rights Reserved

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
  07.07.19 ... FORMTOP= FORMLEFT=, FORMWIDTH=, FORMHEIGHT= added to INI file saving location of main form on screen
  30.07.19 ... 'TRISELO=', fHDR.RiseTimeLo, 'TRISEHi=', fHDR.RiseTimeHi added to WCP header
  14.08.19 ... 'LATPERC=', fHDR.LatencyPercentage added to WCP header
  16.11.21 ... Quantal analysis (qanal.pas) settinfs added
  04.07.22 ... 'TXLEV=', fHDR.DecayTimeLevel ), 'TXTOLEV=', fHDR.DecayTimeToLevel added to file header
  08.11.22 ... Initial Main form position now set in DataModuleCreate (rather than Main.FormShow())
               FH.PeakMode now saved in file header
               Unnecessary '=' removed from KEY in AddKeyValue()
               Waveform measurement cursors now saved in file header (up to max. of 16 channels)
  06.07.23 ... '=' removed from Keywords to avoid '==' in settings text files
  22.06.24 ... Channel # no longer included in channel name unless name is blank
  23.06.24 ... Curve fit parameters now stored in Value array at RH.FitPar0
               cursor settings in EqnType,FitCursor0,FitCursor1,FitCursor2,FitChan,FitPar0
  }


interface



uses
  System.SysUtils, System.Classes, Winapi.Windows, seslabio, maths, Graphics, VCL.Stdctrls ;

const
     FileVersion = 9.0 ;                 // Increased from 8.0 to 9.0 4/3/10
     DataFileExtension = '.WCP' ;
     Enable = True ;
     Disable = False ;
     MinDT = 1.5E-5 ;
     MaxChannels = 128 ;

     { Signal analysis variable constants }
     vRecord = 0 ;
     vGroup = 1 ;
     vTime = 2 ;
     vAverage = 3 ;
     vArea = 4 ;
     vPeak = 5 ;
     vVariance = 6 ;
     vRiseTime = 7 ;
     vRateofRise = 8 ;
     vLatency = 9 ;
     vTDecay = 10 ;
     vT90 = 11 ;
     vInterval = 12 ;
     vBaseline = 13 ;
     vConductance = 14 ;
     vQuantile = 15 ;
     vAbsArea = 16 ;
     vTimeofDay = 17 ;
     LastMeasureVariable = 17 ;

     PositivePeaks = 1 ;
     NegativePeaks = 2 ;
     AbsPeaks = 0 ;
     PeakPeaks = 3 ;

     // Curve fitting variable
 //    vFitEquation = LastMeasureVariable+1 ;
    vFitChan = LastMeasureVariable+2 ;
   {  vFitCursor0 =  LastMeasureVariable+3 ;
     vFitCursor1 = LastMeasureVariable+4 ;
     vFitCursor2 = LastMeasureVariable+5 ;
     vFitResSD = LastMeasureVariable+6 ;
     vFitNumIterations = LastMeasureVariable+7 ;
     vFitDegF = LastMeasureVariable+8 ;
     vFitAvg = LastMeasureVariable+9 ;}
     vFitPar = LastMeasureVariable+ 3 ;
{     vFitParSD = LastMeasureVariable+11 ;}

     FitVarLimit = 11 ;
     VoltsTomV = 1000. ;
     mVToVolts = 1E-3 ;
     AmpsTonA = 1E9 ;
     nAToAmps = 1E-9 ;
     nSToSeimens = 1E-9 ;
     msToSecs = 1E-3 ;
     SecsToms = 1E3 ;
     pFToFarad = 1E-12 ;
     FaradTopF = 1E12 ;
     MinSingle = 1.5E-45 ;

     MaxAnalysisVariables = 28 ;

     BitMapsMinSize = 16 ;
     BitMapsMaxSize = 10000 ;

     MaxOnLinePlots = 10 ;

type

// Data record header block (Updated 6/5/10)
TRecHeader = packed record
           Status : String ;
           RecType : String ;
           Number : Single ;
           Time : Single ;
           dt : Single ;
           ADCVoltageRange : array[0..MaxChannels-1] of Single ;
           Ident : string ;
           Value : array[0..MaxChannels*MaxAnalysisVariables-1] of single ;
           EqnType : TEqnType ;
           FitCursor0 : Integer ;
           FitCursor1 : Integer ;
           FitCursor2 : Integer ;
           FitChan : Integer ;
           FitPar0 : Integer ;
           AnalysisAvailable : boolean ;
           end ;

{ Data file header block }
TFileHeader = packed record
            FileName : string ;
            FileHandle : integer ;
            NumSamples : LongInt ;
            NumChannels : LongInt ;
            NumSamplesPerRecord : LongInt ;
            NumBytesPerRecord : LongInt ;
            NumDataBytesPerRecord : LongInt ;
            NumAnalysisBytesPerRecord : LongInt ;
            NumBytesInHeader : LongInt ;
            NumRecords : LongInt ;
            MaxADCValue : Integer ;
            MinADCValue : Integer ;
            RecordNum : LongInt ;
            dt : single ;
            ADCVoltageRange : single ;
            ADCMaxBits : single ;
            NumZeroAvg : LongInt ;
            IdentLine : string ;
            Version : Single ;
            ProgVersion : string ;
            CurrentRecord : LongInt ;
            // Measurement settings
            DecayTimePercentage : Single ;          // Selected T(x%) decay percentage value
            DecayTimeLevel : Single ;               // Selected T(x) decay time level threshold
            DecayTimeToLevel : Boolean ;            // TRUE = Measure decay from peak to fixed threshold
            PeakMode : Integer ;                    // Peak measurement mode
            RateOfRiseMode : Integer ;              // Rate of rise measurement mode
            NumPointsAveragedAtPeak : Integer ;     // No. of sample point averaged at peak
            RiseTimeLo : Single ;                   // Rise time lower limit (fraction of peak)
            RiseTimeHi : Single ;                   // Rise time upper limit (fraction of peak)
            QuantilePercentage : Single ;           // Quantile % value
            LatencyPercentage : Single ;            // Latency time to % peak value
            T0Cursor : Integer ;                    // T=0 zero cursor
            C0Cursor : Array[0..MaxChannels-1] of Integer ;    // Start of analysis area
            C1Cursor : Array[0..MaxChannels-1] of Integer ;    // End of analysis area

            // Non-stationary variance analysis parameters
            NSVChannel : Integer ;          // Current channel to be analysed
            NSVType : Integer ;             // Type of record to analyse
            NSVAlignmentMode : Integer ;   // Alignment mode for averaging
            NSVScaleToPeak : Boolean ;     // Scale to peak selected
            NSVAnalysisCursor0 : Integer ; // Variance-mean plot selection cursor 0
            NSVAnalysisCursor1 : Integer ; // Variance-mean plot selection cursor 1
            SaveHeader : Boolean ;
            CreationTime : String ;
            RecordingStartTime : string ;  // Date/time of start of recording
            RecordingStartTimeSecs : Single ; // Time in seconds (since last boot) of start of recording
            end ;

TString4 = string[4] ;
TString6 = string[6] ;
TString8 = string[8] ;
TChannel = record
         xMin : single ;
         xMax : single ;
         yMin : single ;
         yMax : single ;
         xScale : single ;
         yScale : single ;
         Left : LongInt ;
         Right : LongInt ;
         Top : LongInt ;
         Bottom : LongInt ;
         TimeZero : single ;
         ADCZero : LongInt ;
         ADCZeroAt : LongInt ;
         ADCSCale : single ;
         ADCCalibrationFactor : single ;
         ADCCalibrationValue : single ;
         ADCAmplifierGain : single ;
         ADCUnits : string ;
         ADCName : string ;
         InUse : Boolean ;
         ChannelOffset : LongInt ;
         CursorIndex : LongInt ;
         ZeroIndex : LongInt ;
         CursorTime : single ;
         CursorValue : single ;
         Cursor0 : Integer ;
         Cursor1 : Integer ;
         TZeroCursor : Integer ;
         color : TColor ;
         end ;

TSealTest = record
          CurrentChannel : LongInt ;
          VoltageChannel : LongInt ;
          HoldingVoltage1 : single ;
          HoldingVoltage2 : single ;
          HoldingVoltage3 : single ;
          PulseHeight : single ;
          PulseHeight1 : single ;
          PulseHeight2 : single ;
          PulseHeight3 : single ;
          PulseWidth : single ;
          Use : LongInt ;
          AutoScale : Boolean ;
          DisplayScale : LongInt ;
          FreeRun : Boolean ;
          FirstSweep : Boolean ;
          NumAverages : Integer ;
          ZapAmplitude : single ;
          ZapDuration : single ;
          GaFromPeak : Boolean ;
          end ;



THHParameter = record
                 Inf : single ;
                 Tau : single ;
                 p : single ;
                 VSlope : Single ;
                 VHalf : Single ;
                 TauMin : Single ;
                 TauMax : Single ;
                 TauVhalf : Single ;
                 TauVslope : single ;
                 end ;

TVClampSimParameters = record
    m: THHParameter ;
    h : THHParameter ;
    UseInactivation : Boolean ;
    GMax : Single ;
    GLeak : Single ;
    GSeries : Single ;
    VRev : Single ;
    VHold : Single ;
    VStep : Single ;
    NoiseRMS : Single ;
    Cm : Single ;
    NumSteps : Integer ;
    end ;

TSynapseSimParameters = record
     NumRecords : Integer ;
     RecordDuration : Single ;
     DisplayRange : Single ;
     TauRise : Single ;
     Tau1 : Single ;
     Latency : Single ;
     DoubleExponentialDecay : Boolean ;
     A2Fraction : Single ;
     Tau2 : Single ;
     QuantumAmplitude : Single ;
     QuantumStDev : Single ;
     n : Single ;
     p : Single ;
     NoiseRMS : Single ;
     VRest : Single ;
     Units : String ;
     end ;

    TMEPSCSimParameters = record
         NumRecords : Integer ;
         RecordDuration : Single ;
         NumRecordsDone : Integer ;
         UnitCurrent : single ;
         NumChannels : Integer ;
         BindingRate : single ;
         TransmitterDecayTime : single ;
         OpenRate : single ;
         CloseRate : single ;
         BindRate : single ;
         UnbindRate : single ;
         BlockRate : single ;
         unBlockRate : single ;
         TOpen : single ;
         TClosed : single ;
         TBlocked : single ;
         PUnbind : single ;
         PClose : single ;
         NoiseRMS : Single ;
         LPFilter : single ;
         LPFilterInUse : Boolean ;
         LPFilterFirstCall : Boolean ;
         Drift : Single ;
         t : double ;
         end ;

  TRecPlotData = Record
      PlotNum : Integer ;
      LineNum : Integer ;
      VarNum : Integer ;
      ChanNum : Integer ;
      YLabel : String ;
      ListEntry : String ;
      Polarity : Integer ;
      RateofRiseSmoothing : Integer ;
      CursorSet : Integer ;
      StimProtocol : String ;
      end ;

TRecPlotSettings = Record
    Plot : Array[0..MaxOnLinePlots-1] of TRecPlotData ;
    NumPlots : Integer ;
    // On-line analysis measurement cursor positions (fraction of recordin sweep)
    Cursor0 : Single ;
    Cursor1 : Single ;
    Cursor2 : Single ;
    Cursor3 : Single ;
    Cursor4 : Single ;
    IgnoreLeakRecords : Boolean ;
    End;

TQuantalAnalysis = record
    EvokedType : string ;
    MiniType : string ;
    Potentials : Boolean ;
    end;

TVCommand = record
          DivideFactor : single ;
          HoldingVoltage : single ;
          end ;

TDigitalPort = record
             Value : LongInt ;
             end ;
TEventDetector = record
               Channel : LongInt ;
               Threshold : single ;
               PreTrigger : single ;
               end ;
TPageSettings = record
              FontName : string ;
              FontSize : LongInt ;
              LineThickness : LongInt ;
              ShowLines : boolean ;
              MarkerSize : LongInt ;
              ShowMarkers : boolean ;
              LeftMargin : single ;
              RightMargin : single ;
              TopMargin : single ;
              BottomMargin : single ;
              MetafileWidth : Integer ;
              MetafileHeight : Integer ;
              UseColor : boolean ;
              end ;


TColors = record
        Cursors : TColor ;
        Grid : TColor ;
        end ;



TSettings = record
          Resolution16Bit : Boolean ;
          NumChannels : Integer ;
          NumSamples : Integer ;
          //ADCVoltageRangeIndex : Integer ;
          RecordDuration : Single ;

          RecordingMode : Integer ;
          EventDetector : TEventDetector ;
          AutoErase : Boolean ;
          NumRecordsRequired : LongInt ;
          VProgramFileName : string ;
          ProtocolListFileName : String ;
          //DAC : Array[0..1] of TVCommand ;
          DigitalPort : TDigitalPort ;
          UpdateOutputs : boolean ;
          DACInvertTriggerLevel : Boolean ;
          TopMargin : LongInt ;
          TopLine : LongInt ;
          BottomMargin : LongInt ;
          LeftMargin : LongInt ;
          RightMargin : LongInt ;
          Plot : TPageSettings ;
          ZeroLevels : boolean ;
          FixedZeroLevels : boolean ;
          BarValue : array[0..MaxChannels-1] of single ;
          TimeBarValue : single ;
          ShowLabels : boolean ;
          ShowZeroLevels : boolean ;
          CutOffFrequency : single ;
          MinDACInterval : single ;
          MinSamplingInterval : single ;
          MaxSamplingInterval : single ;
          SealTest : TSealTest ;
          TUnits : string ;
          TScale : single ;
          TUnScale : single ;
          BitmapWidth : LongInt ;
          BitmapHeight : LongInt ;
          DataDirectory : string ;
          ProgDirectory : string ;
          VProtDirectory : string ;
          FileNameIncludeDate : Boolean ;
          FileNamePrefix : string ;
          WavGenNoDisplay : boolean ;
          LaboratoryInterface : LongInt ;
          DeviceNumber : Integer ;
          ADCInputMode : Integer ;

          NoINIFile : Boolean ;
          RecentFiles : Array[0..3] of string ;
          RecentFilesPointer : Integer ;
          DisplayGrid : Boolean ;
          Colors : TColors ;
          //TimeRecordingStarted : single ;
          // Waveform measurement module
          DifferentiationMode : Integer ;         // Rate of change differentiation mode
          LockChannelCursors : Boolean ;
          Amplifier : Integer ;
          GainTelegraphChannel : Integer ;
          ExternalTriggerActiveHigh : Boolean ;
          ResetDisplayMagnification : Boolean ;
          VClampSim : TVClampSimParameters ;
          SynapseSim : TSynapseSimParameters ;
          MEPSCSim : TMEPSCSimParameters ;
          RecPlot : TRecPlotSettings ;
          OpenNewFileOnRecord : Boolean ;
          QuantalAnalysis : TQuantalAnalysis ;
          end ;



  TWCPFile = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    LogFile : TextFile ;





    function ANSIArrayToString( const CharArray : Array of ANSIChar ) : string ;
    Function AppendStringToANSIArray(
             var Dest : array of ANSIChar ; // Destination to append to
             Source : string                // Source to copy from
            ) : Boolean ;                  // TRUE = append successful  procedure CopyANSIArrayToString(

    Function CopyStringToANSIArray(
             var Dest : array of ANSIChar ; // Destination to append to
             Source : string                // Source to copy from
             ) : Boolean ;                  // TRUE = copy successful  procedure CopyANSIArrayToString(

    procedure CopyANSIArrayToString(
          var Dest : string ;
          var Source : array of ANSIchar ) ;

    function GetSpecialFolder(const ASpecialFolderID: Integer): string;
  public
    ProgVersion : string ;
    { Public declarations }
    SettingsDirectory : String ;  // Settings folder
    SettingsFileName : String ;   // Settings file name
    LogFileName : string ;        // Activity log file name
    LogFileAvailable : boolean ;

 { ProgVersion : string ;}
  fH : TFileHeader ;
  RawfH : TFileHeader ;             // Raw data file
  AvgfH : TFileHeader ;             // Averages file
  LeakfH : TFileHeader ;            // Leak subtracted data file
  DrvFH : TFileHeader ;             // Driving function file

  // File channel calibration
    Channel : array[0..MaxChannels-1] of TChannel ;
  // Recording channel settings
  //RecChannel : array[0..WCPMaxChannels-1] of TChannel ;
    RecordTypes : TStringList ;
    ChannelNames : TStringList ;
    Settings : TSettings ;

 // MaxDACValue : Integer ;
 // MinDACValue : Integer ;

    { Public declarations }
    function NumAnalysisBytesPerRecord( NumChannels : Integer ) : Integer ;
    function NumBytesInFileHeader( NumChannels : Integer ) : Integer ;
    procedure SaveHeader( fHDR : TFileHeader ) ;
    procedure GetHeader( var fHDR : TFileHeader ) ;

    procedure LoadDataFiles( FileName : string ) ;
    function OpenAssociateFile( var FileHeader : TFileHeader ;
                                const FileName : string ;
                                const FileExtension : string ) : boolean ;


    procedure SaveInitializationFile( const IniFileName : string ) ;
    procedure LoadInitializationFile( const IniFileName : string ) ;

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

    procedure GetRecordHeaderOnlyWCPV8( var fHDR : TFileHeader;      { Data file header }
                                        var rH : TRecHeader ;        { Record header }
                                        RecordNum : Integer          { Record number }
                                        ) ;

    Function AppendWCPfile( const FileName : string ) : Boolean ;
    Function InterleaveWCPfile( const FileName : string ) : Boolean ;

    function ConvertWCPPreV62toV9( FileName : string ) : Boolean ;
    function ConvertWCPV8toV9(
          FileName : string   { Name of file to be converted }
          ) : Boolean ;

function CalibFactorToADCScale( var RH : TRecHeader ; Ch : Integer ) : single ;

function CreateNewDataFile(
         FileName : String
         ) : Boolean ;

function CreateIndexedFileName(
         FileName : String ) : String ;


procedure UpdateFileHeaderBlocks ;
procedure DeleteRecord ;
procedure DeleteRejected ;
procedure CloseAllDataFiles ;
procedure UpdateChannelScalingFactors(
          var RH : TRecHeader ) ;


procedure OpenLogFile ;
procedure WriteToLogFile( Line : string ) ;
procedure WriteToLogFileNoDate( Line : string ) ;
procedure CloseLogFile ;
procedure FileCloseSafe( var FileHandle : Integer ) ;

procedure GaussianFilter( const FHdr : TFileHeader ;
                           Var Buf : Array of SmallInt ;
                           CutOffFrequency : single ) ;

function FileOverwriteCheck( var FileName : string ) : boolean ;



    procedure AddKeyValue( List : TStringList ;  // List for Key=Value pairs
                           Keyword : string ;    // Key
                           Value : single        // Value
                           ) ; Overload ;

    procedure AddKeyValue( List : TStringList ;  // List for Key=Value pairs
                           Keyword : string ;    // Key
                           Value : Integer        // Value
                           ) ; Overload ;

    procedure AddKeyValue( List : TStringList ;  // List for Key=Value pairs
                           Keyword : string ;    // Key
                           Value : NativeInt        // Value
                           ) ; Overload ;

    procedure AddKeyValue( List : TStringList ;  // List for Key=Value pairs
                           Keyword : string ;    // Key
                           Value : String        // Value
                           ) ; Overload ;

    procedure AddKeyValue( List : TStringList ;  // List for Key=Value pairs
                           Keyword : string ;    // Key
                           Value : Boolean        // Value
                           ) ; Overload ;


   function GetKeyValue( List : TStringList ;  // List for Key=Value pairs
                         KeyWord : string ;   // Key
                         Value : single       // Value
                         ) : Single ; Overload ;        // Return value

   function GetKeyValue( List : TStringList ;  // List for Key=Value pairs
                         KeyWord : string ;   // Key
                         Value : Integer       // Value
                         ) : Integer ; Overload ;        // Return value

   function GetKeyValue( List : TStringList ;  // List for Key=Value pairs
                         KeyWord : string ;   // Key
                         Value : NativeInt       // Value
                         ) : NativeInt ; Overload ;        // Return value

   function GetKeyValue( List : TStringList ;  // List for Key=Value pairs
                         KeyWord : string ;   // Key
                         Value : string       // Value
                         ) : string ; Overload ;        // Return value

   function GetKeyValue( List : TStringList ;  // List for Key=Value pairs
                         KeyWord : string ;   // Key
                         Value : Boolean       // Value
                         ) : Boolean ; Overload ;        // Return value


  function ExtractFloat ( CBuf : string ; Default : Single ) : extended ;
  function ExtractInt ( CBuf : string ) : longint ;
  function ExtractFileNameOnly( FilePath : string ) : string ;
  procedure UpdateScrollBar(
            SB : TScrollBar ;
            Value : Integer ;
            LoLimit : Integer ;
            HiLimit : Integer
            ) ;


  end;

var
    WCPFIle : TWCPFIle ;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses AmpModule, MDIForm, StimModule, math, System.STrUtils, VCL.Dialogs, shlobj, System.UITypes, VCL.Forms ;

{$R *.dfm}

const
    NumBytesPerSector = 512 ;
    MaxRecordIdentChars = 16 ;
    MaxRecordStatusChars = 8 ;
    MaxRecordTypeChars = 4 ;

     { - for ConvertOldToNewWCP - }
     OldChannelLimit = 5 ;
     OldVarLimit = 13 ;
     OldLastParameter = 6 ;



function TWCPFile.CreateNewDataFile(
         FileName : String
         ) : Boolean ;
// --------------------------------
// Create new (and empty) data file
// --------------------------------
var
     ch : Integer ;
     TempFile : String ;
begin

     { Close any existing data file }
     CloseAllDataFiles ;

     { Open new and empty data file }
     RawFH.FileName := FileName ;
     RawFH.FileName := ChangeFileExt( RawFH.FileName, '.wcp' ) ;
     RawFH.FileHandle := FileCreate( RawFH.FileName ) ;
     if RawFH.FileHandle >= 0 then begin
        // Re-open allowing read only sharing
        FileClose( RawFH.FileHandle ) ;
        RawFH.FileHandle := FileOpen(  RawFH.FileName, fmOpenReadWrite or fmShareDenyWrite ) ;
        end ;

     // Time created
     RawFH.CreationTime := DateToStr(Now) ;
     RawFH.ProgVersion := ProgVersion ;    // WinWCP program version
     RawFH.NumRecords := 0 ;

     { Set No. of bytes in analysis record to default value }
     RawFH.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(RawFH.NumChannels) ;
     for ch := 0 to RawFH.NumChannels-1 do Channel[ch].InUse := True ;
     WCPFile.SaveHeader( RawFH ) ;

     { Delete averages file (if it exists) }
     TempFile := ChangeFileExt( RawFH.FileName, '.avg' ) ;
     if FileExists(TempFile) then DeleteFile(PChar(TempFile)) ;
     { Delete leak subtraction file (if it exists) }
     TempFile := ChangeFileExt( RawFH.FileName, '.sub' ) ;
     if FileExists(TempFile) then DeleteFile(PChar(TempFile)) ;
     TempFile := ChangeFileExt( RawFH.FileName, '.dfn' ) ;
     if FileExists(TempFile) then DeleteFile(PChar(TempFile)) ;

     { Re-load empty data file }
     LoadDataFiles( RawFH.FileName ) ;

     WriteToLogFile( 'New data file: ' + RawFH.FileName + ' created.' ) ;
     Result := True ;

     end ;


procedure TWCPFile.SaveHeader(
          fHDR : TFileHeader
          ) ;
{ ---------------------------------------
  Save file header data to WCP data file
  ---------------------------------------}
var
   Header : TStringList ;
   pANSIBuf : pANSIChar ;
   NumSectors : Integer ;
   ch,i : Integer ;
   s : string ;
begin

     // Create file header Name=Value string list
     Header := TStringList.Create ;

     // Set file header size if no records stored
     fHDR.NumBytesInHeader := NumBytesInFileHeader(fHDR.NumChannels) ;
     fHDR.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(fHDR.NumChannels) ;

     fHDR.Version := FileVersion ;
     AddKeyValue( Header, 'VER',fHDR.Version );

     AddKeyValue( Header, 'VERPROG',fHDR.ProgVersion );

     // Time file created
     AddKeyValue( Header, 'CTIME', fHDR.CreationTime ) ;

     // Time recording started (s)
     AddKeyValue( Header, 'RTIMESECS', fHDR.RecordingStartTimeSecs ) ;

     // Date/time of start of recording
     AddKeyValue( Header, 'RTIME', fHDR.RecordingStartTime ) ;

     AddKeyValue( Header, 'NBH', fHDR.NumBytesInHeader ) ;

     // 13/2/02 Added to distinguish between 12 and 16 bit data files
     AddKeyValue( Header, 'ADCMAX', fHDR.MaxADCValue ) ;

     AddKeyValue( Header, 'NC', fHDR.NumChannels ) ;
     fHDR.NumDataBytesPerRecord := fHDR.NumSamples*fHDR.NumChannels*2;
     fHDR.NumBytesPerRecord := fHDR.NumAnalysisBytesPerRecord +
                               fHDR.NumDataBytesPerRecord  ;
     NumSectors := fHDR.NumAnalysisBytesPerRecord div NumBytesPerSector ;
     AddKeyValue( Header, 'NBA', NumSectors ) ;
     NumSectors := fHDR.NumDataBytesPerRecord div NumBytesPerSector ;
     AddKeyValue( Header, 'NBD', NumSectors ) ;

     AddKeyValue( Header, 'AD', fHDR.ADCVoltageRange ) ;

     AddKeyValue( Header, 'NR', fHDR.NumRecords ) ;
     AddKeyValue( Header, 'DT',fHDR.dt );

     fHDR.NumZeroAvg := Max(fHDR.NumZeroAvg,1) ;
     AddKeyValue( Header, 'NZ', fHDR.NumZeroAvg ) ;

     for ch := 0 to fHDR.NumChannels-1 do
         begin
         AddKeyValue( Header, format('YO%d',[ch]), Channel[ch].ChannelOffset) ;
         AddKeyValue( Header, format('YU%d',[ch]), Channel[ch].ADCUnits ) ;
         AddKeyValue( Header, format('YN%d',[ch]), Channel[ch].ADCName ) ;
         AddKeyValue( Header, format('YG%d',[ch]), Channel[ch].ADCCalibrationFactor ) ;
         AddKeyValue( Header, format('YZ%d',[ch]), Channel[ch].ADCZero) ;
         AddKeyValue( Header, format('YR%d',[ch]), Channel[ch].ADCZeroAt) ;
         end ;

     // T.(x%) waveform measurement percentage decay time
     AddKeyValue( Header, 'TXPERC', fHDR.DecayTimePercentage ) ;
     AddKeyValue( Header, 'TXLEV', fHDR.DecayTimeLevel ) ;
     AddKeyValue( Header, 'TXTOLEV', fHDR.DecayTimeToLevel ) ;

     // Peak mode and points averaged at peak
     AddKeyValue( Header, 'PKMODE', fHDR.PeakMode ) ;
     AddKeyValue( Header, 'PKPAVG', fHDR.NumPointsAveragedAtPeak ) ;

     // Quantile percentage measurement in use
     AddKeyValue( Header, 'QUPERC', fHDR.QuantilePercentage ) ;
     // Latency percentage measurement in use
     AddKeyValue( Header, 'LATPERC', fHDR.LatencyPercentage ) ;

     AddKeyValue( Header, 'TRISELO', fHDR.RiseTimeLo ) ;
     AddKeyValue( Header, 'TRISEHI', fHDR.RiseTimeHi ) ;

     // Measurement cursors
     AddKeyValue( Header, 'T0CURS', fHDR.T0Cursor ) ;
     for ch := 0 to Min(fHDR.NumChannels-1,15) do
         begin
         AddKeyValue( Header, format('C0CURS%d',[ch]), fHDR.C0Cursor[ch] ) ;
         AddKeyValue( Header, format('C1CURS%d',[ch]), fHDR.C1Cursor[ch] ) ;
         end;

     // Non-stationary variance analysis settings
     AddKeyValue( Header, 'NSVCHAN', fHDR.NSVChannel ) ;
     AddKeyValue( Header, 'NSVALIGN', fHDR.NSVAlignmentMode ) ;
     AddKeyValue( Header, 'NSVTYPR', fHDR.NSVType ) ;
     AddKeyValue( Header, 'NSVS2P', fHDR.NSVScaleToPeak ) ;
     AddKeyValue( Header, 'NSVCUR0', fHDR.NSVAnalysisCursor0 ) ;
     AddKeyValue( Header, 'NSVCUR1', fHDR.NSVAnalysisCursor1 ) ;

     { Experiment identification line }
     AddKeyValue( Header, 'ID', fHDR.IdentLine ) ;

     // Get ANSIstring copy of header text and write to file
     pANSIBuf := AllocMem( fHDR.NumBytesInHeader ) ;
     for i := 1 to Min(Length(Header.Text),fHDR.NumBytesInHeader-1) do
         begin
         pAnsiBuf[i-1] := ANSIChar(Header.Text[i]);
         end;

     if Length(Header.Text) >= fHDR.NumBytesInHeader then
        begin
        ShowMessage( fHDR.FileName + ' File header full!' ) ;
        end;

     // Write header to start of WCP data file
     FileSeek( fHDR.FileHandle, 0, 0 ) ;
     FileWrite( fHDR.FileHandle, pANSIBuf^, fHDR.NumBytesInHeader ) ;

     { Add Names of channels to list }
     ChannelNames.Clear ;
     for ch := 0 to fHDR.NumChannels-1 do
         begin
         s := Channel[ch].ADCName ;
         if s = '' then s := format('Ch.%d ',[ch]) ;
         ChannelNames.Add( s ) ;
         end;


     Header.Free ;
     FreeMem( pANSIBuf ) ;

     end ;


procedure TWCPFile.GetHeader(
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
//   Header : array[1..MaxBytesInFileHeader] of ANSIchar ;
   Header : TStringList ;
   pANSIBuf : PANSIChar ;
   ANSIHeader : ANSIString ;
   RecordStatusArray : array[0..3] of ANSIchar ;
   RecordStatus : string ;
   NumBytesInFile,NumRecords,FilePointer,ch,RecordCounter : Integer ;
   Done : Boolean ;
   i,NumSectors : Integer ;
   ResetDisplayMagnification : Boolean ;
   OldValue : Integer ;
   s : string ;
begin

     // Create header parameter list
     Header := TStringList.Create ;

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

     // Read ANSI text from file header and load into Header StringList
     FileSeek( fHDR.FileHandle, 0, 0 ) ;
     pANSIBuf := AllocMem( fHDR.NumBytesInHeader ) ;
     FileRead(fHDR.FileHandle, pANSIBuf^, fHDR.NumBytesInHeader ) ;
     pANSIBuf[fHDR.NumBytesInHeader-1] := #0 ;
     ANSIHeader := ANSIString( pANSIBuf ) ;
     Header.Text := String(ANSIHeader) ;

     for i := 0 to Header.Count-1 do Header[i] := ReplaceText( Header[i], '==','=');
     for i := 0 to Header.Count-1 do outputdebugstring(pchar(Header[i]));

     fHDR.Version := GetKeyValue( Header, 'VER',fHDR.Version );
     fHDR.ProgVersion := GetKeyValue( Header, 'VERPROG',fHDR.ProgVersion );
     fHDR.CreationTime := GetKeyValue( Header, 'CTIME', fHDR.CreationTime ) ;

     // Time recording started (ms)
     fHDR.RecordingStartTimeSecs := 0.0 ;
     fHDR.RecordingStartTimeSecs := GetKeyValue( Header, 'RTIMESECS', fHDR.RecordingStartTimeSecs ) ;

     // Time recording started (s)
     fHDR.RecordingStartTime := '' ;
     fHDR.RecordingStartTime := GetKeyValue( Header, 'RTIME', fHDR.RecordingStartTime ) ;

     OldValue := fHDR.NumChannels ;
     fHDR.NumChannels := GetKeyValue( Header, 'NC', fHDR.NumChannels ) ;
     if fHDR.NumChannels <> OldValue then ResetDisplayMagnification := True ;

     OldValue := fHDR.MaxADCValue ;
     fHDR.MaxADCValue := 0 ;
     fHDR.MaxADCValue := GetKeyValue( Header, 'ADCMAX', fHDR.MaxADCValue ) ;
     if fHDR.MaxADCValue = 0 then fHDR.MaxADCValue := 2047 ;
     fHDR.MinADCValue := -fHDR.MaxADCValue -1 ;
     if OldValue <> fHDR.MaxADCValue then ResetDisplayMagnification := True ;

     // Analysis block size
     NumSectors := fHDR.NumAnalysisBytesPerRecord div NumBytesPerSector ;
     NumSectors := GetKeyValue( Header, 'NBA', NumSectors ) ;
     fHDR.NumAnalysisBytesPerRecord := NumSectors*NumBytesPerSector ;

     NumSectors := fHDR.NumDataBytesPerRecord div NumBytesPerSector ;
     NumSectors := GetKeyValue( Header, 'NBD', NumSectors ) ;
     fHDR.NumDataBytesPerRecord := NumSectors*NumBytesPerSector ;
     fHDR.NumBytesPerRecord := fHDR.NumDataBytesPerRecord + fHDR.NumAnalysisBytesPerRecord  ;

     fHDR.NumSamplesPerRecord := fHDR.NumDataBytesPerRecord div 2 ;
     OldValue := fHDR.NumSamples ;
     fHDR.NumSamples := fHDR.NumSamplesPerRecord div fHDR.NumChannels ;
     if OldValue <> fHDR.NumSamples then ResetDisplayMagnification := True ;

     fHDR.ADCVoltageRange := GetKeyValue( Header, 'AD',fHDR.ADCVoltageRange);

     fHDR.NumRecords := GetKeyValue( Header, 'NR', fHDR.NumRecords ) ;

     { Fix files which accidentally lost their record count }
     if fHDR.NumRecords = 0 then
        begin
        NumBytesInFile := FileSeek( FHDR.FileHandle, 0, 2 ) ;
        NumRecords := (NumBytesInFile - SizeOf(Header)) div fHDR.NumBytesPerRecord ;
        if NumRecords > 0 then
           begin
           ShowMessage( ' Number of records in file corrected.' ) ;
           fHDR.NumRecords := NumRecords ;
           end ;
        end ;

      fHDR.dt := GetKeyValue( Header, 'DT', fHDR.dt );

      fHDR.NumZeroAvg := GetKeyValue( Header, 'NZ', fHDR.NumZeroAvg ) ;
      fHDR.NumZeroAvg := Max(fHDR.NumZeroAvg,1) ;

      { Read channel scaling data }

      for ch := 0 to fHDR.NumChannels-1 do
          begin

          { Channels are mapped in ascending order by WCP for DOS (Version<6.0)
            and descending order by WinWCP. Data file Versions 6.1 and later
            have channel mapping explicitly saved in YO0= ... YO1 etc parameter}
          if (fHdr.Version >= 6.0) or (fHdr.Version = 0.0) then
             Channel[ch].ChannelOffset := fHDR.NumChannels - 1 - ch
           else
             Channel[ch].ChannelOffset := ch ;

          Channel[ch].ChannelOffset := GetKeyValue( Header, format('YO%d',[ch]), Channel[ch].ChannelOffset) ;

          Channel[ch].ADCUnits := '' ;
          Channel[ch].ADCUnits := GetKeyValue( Header, format('YU%d',[ch]) , Channel[ch].ADCUnits ) ;
          { Fix to avoid strings with #0 in them }
          if Length(Channel[ch].ADCUnits) >= 1 then
             if Channel[ch].ADCUnits[1] = chr(0) then Channel[ch].ADCUnits := ' ' ;

          Channel[ch].ADCName := 'Ch.' + IntToStr(ch) ;
          Channel[ch].ADCName := GetKeyValue( Header, format('YN%d',[ch]), Channel[ch].ADCName ) ;
          { Fix to avoid strings with #0 in them }
          if Length(Channel[ch].ADCName) >= 1 then
             if Channel[ch].ADCName[1] = chr(0) then Channel[ch].ADCName := ' ' ;

          Channel[ch].ADCCalibrationFactor := GetKeyValue( Header, format('YG%d',[ch]), Channel[ch].ADCCalibrationFactor) ;

          { Zero level (in fixed mode) }
          Channel[ch].ADCZero := GetKeyValue( Header, format('YZ%d',[ch]), Channel[ch].ADCZero) ;
          { Start of zero level reference samples (-1 = fixed zero) }
          Channel[ch].ADCZeroAt := GetKeyValue( Header, format('YR%d',[ch]), Channel[ch].ADCZeroAt) ;

          { Special treatment for old WCP for DOS data files}
          if fHDR.Version < 6.0 then
             begin
             { Remove 2048 offset from zero level }
             Channel[ch].ADCZero := Channel[ch].ADCZero {- 2048} ;
             { Decrement reference position because WinWCP samples start at 0}
             Dec(Channel[ch].ADCZeroAt) ;
             end ;

          // Reset display magnification (if required)
          if ResetDisplayMagnification then
             begin
             Channel[ch].yMax := fHDR.MaxADCValue ;
             Channel[ch].yMin := fHDR.MinADCValue ;
             Channel[0].xMin := 0 ;
             Channel[0].xMax := fHDR.NumSamples-1 ;
             end ;

          end ;

      // T.(x%) waveform measurement percentage decay time
      fHDR.DecayTimePercentage := 50.0 ; // Default value
      fHDR.DecayTimePercentage := GetKeyValue( Header, 'TXPERC', fHDR.DecayTimePercentage ) ;
      fHDR.DecayTimeLevel := GetKeyValue( Header, 'TXLEV', fHDR.DecayTimeLevel ) ;
      fHDR.DecayTimeToLevel := False ;
      fHDR.DecayTimeToLevel := GetKeyValue( Header, 'TXTOLEV', fHDR.DecayTimeToLevel ) ;

     // Peak mode and points averaged at peak
      fHDR.PeakMode := GetKeyValue( Header, 'PKMODE', fHDR.PeakMode ) ;
      fHDR.NumPointsAveragedAtPeak := GetKeyValue( Header, 'PKPAVG', fHDR.NumPointsAveragedAtPeak ) ;

      // Quantile percentage measurement in use
      fHDR.QuantilePercentage := GetKeyValue( Header, 'QUPERC', fHDR.QuantilePercentage ) ;
      // Latency percentage measurement in use
      fHDR.LatencyPercentage := GetKeyValue( Header, 'LATPERC', fHDR.LatencyPercentage ) ;

      // Rise time limits
      fHDR.RiseTimeLo := GetKeyValue( Header, 'TRISELO', fHDR.RiseTimeLo ) ;
      fHDR.RiseTimeHi := GetKeyValue( Header, 'TRISEHI', fHDR.RiseTimeHi ) ;

     // Measurement cursors
     fHDR.T0Cursor := 0 ;
     fHDR.T0Cursor := GetKeyValue( Header, 'T0CURS', fHDR.T0Cursor ) ;
     for ch := 0 to Min(fHDR.NumChannels-1,15) do
         begin
         fHDR.C0Cursor[ch] := 0 ;
         fHDR.C0Cursor[ch] := GetKeyValue( Header, format('C0CURS%d',[ch]), fHDR.C0Cursor[ch] ) ;
         fHDR.C1Cursor[ch] := 0 ;
         fHDR.C1Cursor[ch] := GetKeyValue( Header, format('C1CURS%d',[ch]), fHDR.C1Cursor[ch] ) ;
         end;

      // Non-stationary variance analysis settings
      fHDR.NSVChannel := GetKeyValue( Header, 'NSVCHAN', fHDR.NSVChannel ) ;
      fHDR.NSVType := GetKeyValue( Header, 'NSVTYPR', fHDR.NSVType ) ;
      fHDR.NSVAlignmentMode := GetKeyValue( Header, 'NSVALIGN', fHDR.NSVAlignmentMode ) ;
      fHDR.NSVScaleToPeak := GetKeyValue( Header, 'NSVS2P', fHDR.NSVScaleToPeak ) ;
      fHDR.NSVAnalysisCursor0 := GetKeyValue( Header, 'NSVCUR0', fHDR.NSVAnalysisCursor0 ) ;
      fHDR.NSVAnalysisCursor1 := GetKeyValue( Header, 'NSVCUR1', fHDR.NSVAnalysisCursor1 ) ;

      { Experiment identification line }
      fHDR.IdentLine := GetKeyValue( Header, 'ID', fHDR.IdentLine ) ;

      { Add names of channels to list }
      ChannelNames.Clear ;
      for ch := 0 to fHDR.NumChannels-1 do
          begin
          s := Channel[ch].ADCName ;
          if s = '' then s := format('Ch.%d ',[ch]) ;
          ChannelNames.Add( s ) ;
          end;

      Header.Free ;
      FreeMem(pANSIBuf) ;

     end ;


procedure TWCPFile.LoadInitializationFile( const IniFileName : string ) ;
{ ---------------------------------------------------------
  Read Initialization file to get initial program settings,
  e.g. the name of the last data file used
  ---------------------------------------------------------}
var
   Header : TStringList ;
   i,ch : Integer ;
   AmpType, GainChannel, ModeChannel : Integer ;
begin

     if not FileExists( IniFileName ) then EXit ;

     // Create file header Name=Value string list
     Header := TStringList.Create ;

     // Load list from file
     Header.LoadFromFile( IniFileName ) ;
     outputdebugstring(pchar(Header[0]));
     outputdebugstring(pchar(format('Count=%d',[Header.Count])));


     { Last raw data file used }
     RawFH.FileName := GetKeyValue( Header, 'FILE', RawFH.FileName ) ;
     { Last averages data file used }
     AvgFH.Filename := '' ;
     AvgFH.FileName := GetKeyValue( Header, 'FILEAVG', AvgFH.FileName ) ;
     { Last leak subtracted data file used }
     LeakFH.Filename := '' ;
     LeakFH.FileName := GetKeyValue( Header, 'LEAKAVG', LeakFH.FileName ) ;

           // Get default recording settings
     Settings.NumChannels := GetKeyValue( Header, 'NC', Settings.NumChannels ) ;
     Settings.NumChannels := Max( 1,Settings.NumChannels ) ;
     Settings.NumSamples := GetKeyValue( Header, 'NSAMP', Settings.NumSamples ) ;
     Settings.RecordDuration := GetKeyValue( Header, 'RECDUR', Settings.RecordDuration ) ;

           { CED 1902 amplifier settings }
     Amplifier.CED1902.Input := GetKeyValue( Header, 'CEDI', Amplifier.CED1902.Input ) ;
     Amplifier.CED1902.Gain := GetKeyValue( Header, 'CEDG', Amplifier.CED1902.Gain ) ;
     Amplifier.CED1902.GainValue := GetKeyValue( Header, 'CEDGV', Amplifier.CED1902.GainValue ) ;
     Amplifier.CED1902.LPFilter := GetKeyValue( Header, 'CEDLP', Amplifier.CED1902.LPFilter ) ;
     Amplifier.CED1902.HPFilter := GetKeyValue( Header, 'CEDHP', Amplifier.CED1902.HPFilter ) ;
     Amplifier.CED1902.ACCoupled := GetKeyValue( Header, 'CEDAC', Amplifier.CED1902.ACCoupled ) ;
     Amplifier.CED1902.DCOffset := GetKeyValue( Header, 'CEDDCO', Amplifier.CED1902.DCOffset ) ;
     Amplifier.CED1902.NotchFilter := GetKeyValue( Header, 'CEDNF', Amplifier.CED1902.NotchFilter ) ;
     Amplifier.CED1902.ComPort := GetKeyValue( Header, 'CEDPO', Amplifier.CED1902.ComPort ) ;

     // Patch clamp amplifier data
     // Note. V4.3.2+ Settings now stored in 'amplifier settings.xml'
     // and only loaded from INI file if XML file does not exist
     if not Amplifier.SettingsFileExists then begin
        ModeChannel := -1 ;
        AmpType := amNone ;
        AmpType := GetKeyValue( Header, 'AMP',AmpType ) ;
        GainChannel := 7 ;
        GainChannel := GetKeyValue( Header, 'AMPCH',GainChannel ) ;
        Amplifier.AmplifierType[0] := AmpType ;
        Amplifier.GainTelegraphChannel[0] := GainChannel ;
        Amplifier.ModeTelegraphChannel[0] := ModeChannel ;

        AmpType := GetKeyValue( Header, 'AMP1',AmpType ) ;
        GainChannel := GetKeyValue( Header, 'AMP1CH',GainChannel ) ;
        GainChannel := GetKeyValue( Header, 'AMP1GAINCH',GainChannel ) ;
        ModeChannel := GetKeyValue( Header, 'AMP1MODECH',ModeChannel ) ;
        Amplifier.AmplifierType[0] := AmpType ;
        Amplifier.GainTelegraphChannel[0] := GainChannel ;
        Amplifier.ModeTelegraphChannel[0] := ModeChannel ;

        AmpType := amNone ;
        AmpType := GetKeyValue( Header, 'AMP2',AmpType ) ;
        GainChannel := GetKeyValue( Header, 'AMP2CH',GainChannel ) ;
        GainChannel := GetKeyValue( Header, 'AMP2GAINCH',GainChannel ) ;
        ModeChannel := GetKeyValue( Header, 'AMP2MODECH',ModeChannel ) ;
        Amplifier.AmplifierType[1] := AmpType ;
        Amplifier.GainTelegraphChannel[1] := GainChannel ;
        Amplifier.ModeTelegraphChannel[1] := ModeChannel ;
        end ;

     { Send new values to CED 1902 }
     { if Amplifier.CED1902.InUse then SetCED1902(Amplifier.CED1902) ;}

     { Read global settings }

           { Get No. channels & No samples/channel }
     RawFH.NumChannels := GetKeyValue( Header, 'NC', RawFH.NumChannels ) ;
     RawFH.NumChannels := Max( 1,RawFH.NumChannels ) ;
     RawFH.NumDataBytesPerRecord := GetKeyValue( Header, 'NBD', RawFH.NumDataBytesPerRecord ) ;
     RawFH.NumDataBytesPerRecord := RawFH.NumDataBytesPerRecord * NumBytesPerSector ;
     RawFH.NumSamplesPerRecord := RawFH.NumDataBytesPerRecord div 2 ;
     RawFH.NumSamples := RawFH.NumSamplesPerRecord div RawFH.NumChannels ;

     {GetKeyValue( Header, 'NBA', i ) ;}
     RawFH.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(RawFH.NumChannels) ;

     RawFH.NumBytesPerRecord := RawFH.NumDataBytesPerRecord + RawFH.NumAnalysisBytesPerRecord ;

     { *** Recording settings *** }
     { Recording trigger mode }
     Settings.RecordingMode := GetKeyValue( Header, 'RECMODE', Settings.RecordingMode ) ;
     { Event detector, channel and % threshold level }
     Settings.EventDetector.Channel := GetKeyValue( Header, 'DETCH', Settings.EventDetector.Channel ) ;
     Settings.EventDetector.Threshold := GetKeyValue( Header, 'DETTH', Settings.EventDetector.Threshold ) ;
     Settings.EventDetector.PreTrigger := GetKeyValue( Header, 'DETPT', Settings.EventDetector.PreTrigger ) ;
     Settings.ExternalTriggerActiveHigh := GetKeyValue( Header, 'EXTTRIGAH', Settings.ExternalTriggerActiveHigh ) ;

     { Display auto-erase mode }
     Settings.AutoErase := GetKeyValue( Header, 'AER', Settings.AutoErase ) ;
     { Number of records required (in free run/ext. trigger/detect modes}
     Settings.NumRecordsRequired := GetKeyValue( Header, 'NRQ', Settings.NumRecordsRequired ) ;
     { Currently selected voltage program }
     Settings.VProgramFileName := GetKeyValue( Header, 'FILEVPR', Settings.VProgramFileName ) ;

     { Default voltage clamp holding potential setting }
     Main.SESLabIO.DACHoldingVoltage[0] := GetKeyValue( Header, 'VCHOLD', Main.SESLabIO.DACHoldingVoltage[0] ) ;
     for ch := 0 to MaxAmplifiers-1 do
         begin
         Main.SESLabIO.DACHoldingVoltage[ch] := GetKeyValue( Header, format('VCHOLD%d',[ch]), Main.SESLabIO.DACHoldingVoltage[ch] ) ;
         end ;

     { Default digital control port output byte setting }
     Settings.DigitalPort.Value := GetKeyValue( Header, 'DIGPORT', Settings.DigitalPort.Value ) ;
     Settings.UpdateOutputs := True ;
     { Display digital low pass filter setting }
     Settings.CutOffFrequency := GetKeyValue( Header, 'CUTOFF', Settings.CutOffFrequency ) ;

     // Invert recording sweep trigger pulse flag
     Settings.DACInvertTriggerLevel := GetKeyValue( Header, 'DACINVTRIG', Settings.DACInvertTriggerLevel ) ;

           { Load time units (ms or s) }
     Settings.TUnits := GetKeyValue( Header, 'TUNITS', Settings.TUnits ) ;
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
     Settings.SealTest.PulseHeight := GetKeyValue( Header, 'STPH', Settings.SealTest.PulseHeight ) ;
     Settings.SealTest.PulseHeight1 := GetKeyValue( Header, 'STPH1', Settings.SealTest.PulseHeight1 ) ;
     Settings.SealTest.PulseHeight2 :=  GetKeyValue( Header, 'STPH2', Settings.SealTest.PulseHeight2 ) ;
     Settings.SealTest.PulseHeight3 := GetKeyValue( Header, 'STPH3', Settings.SealTest.PulseHeight3 ) ;
     Settings.SealTest.HoldingVoltage1 := GetKeyValue( Header, 'STHV1', Settings.SealTest.HoldingVoltage1 ) ;
     Settings.SealTest.HoldingVoltage2 := GetKeyValue( Header, 'STHV2', Settings.SealTest.HoldingVoltage2 ) ;
     Settings.SealTest.HoldingVoltage3 := GetKeyValue( Header, 'STHV3', Settings.SealTest.HoldingVoltage3 ) ;
     Settings.SealTest.PulseWidth := GetKeyValue( Header, 'STPW', Settings.SealTest.PulseWidth ) ;
     Settings.SealTest.CurrentChannel := GetKeyValue( Header, 'STCCH', Settings.SealTest.CurrentChannel ) ;
     Settings.SealTest.VoltageChannel := GetKeyValue( Header, 'STVCH', Settings.SealTest.VoltageChannel ) ;
     Settings.SealTest.Use := GetKeyValue( Header, 'STUSE', Settings.SealTest.Use ) ;
     Settings.SealTest.DisplayScale := GetKeyValue( Header, 'STDSC', Settings.SealTest.DisplayScale ) ;
     Settings.SealTest.AutoScale := GetKeyValue( Header, 'STASC', Settings.SealTest.AutoScale ) ;
     Settings.SealTest.FreeRun := GetKeyValue( Header, 'STFRU', Settings.SealTest.FreeRun ) ;
     Settings.SealTest.NumAverages := GetKeyValue( Header, 'STNAV', Settings.SealTest.NumAverages ) ;
     Settings.SealTest.ZapAmplitude := GetKeyValue( Header, 'STZAPA', Settings.SealTest.ZapAmplitude ) ;
     Settings.SealTest.ZapDuration := GetKeyValue( Header, 'STZAPD', Settings.SealTest.ZapDuration ) ;
     Settings.SealTest.GaFromPeak := GetKeyValue( Header, 'STGAP', Settings.SealTest.GaFromPeak ) ;

           { Note. For compatibility with older Strathclyde
             programs 'ADCVoltageRange' is written to file
             as VOLTS but is mV internally' }
     RawFH.ADCVoltageRange := GetKeyValue( Header, 'AD',RawFH.ADCVoltageRange);

     RawFH.dt := GetKeyValue( Header, 'DT', RawFH.dt );

           { Plotting page settings }
     Settings.Plot.TopMargin := GetKeyValue( Header, 'PLTPM',Settings.Plot.TopMargin ) ;
     Settings.Plot.BottomMargin := GetKeyValue( Header, 'PLBTM',Settings.Plot.BottomMargin ) ;
     Settings.Plot.LeftMargin := GetKeyValue( Header, 'PLLFM',Settings.Plot.LeftMargin ) ;
     Settings.Plot.RightMargin := GetKeyValue( Header, 'PLRTM',Settings.Plot.RightMargin ) ;
     Settings.Plot.FontName :=  GetKeyValue( Header, 'PLFNT',Settings.Plot.FontName ) ;
     Settings.Plot.FontSize := GetKeyValue( Header, 'PLFSI',Settings.Plot.FontSize ) ;
     Settings.Plot.LineThickness := GetKeyValue( Header, 'PLLTH',Settings.Plot.LineThickness ) ;
     Settings.Plot.ShowLines := GetKeyValue( Header, 'PLSHL',Settings.Plot.ShowLines ) ;
     Settings.Plot.MarkerSize := GetKeyValue( Header, 'PLMKS',Settings.Plot.MarkerSize ) ;
     Settings.Plot.ShowMarkers := GetKeyValue( Header, 'PLSHM',Settings.Plot.ShowMarkers ) ;
     Settings.Plot.UseColor := GetKeyValue( Header, 'PLCOL',Settings.Plot.UseColor ) ;
           { Width/height of clipboard metafiles }
     Settings.Plot.MetafileWidth := GetKeyValue( Header, 'PLMFW', Settings.Plot.MetafileWidth ) ;
     Settings.Plot.MetafileHeight := GetKeyValue( Header, 'PLMFH', Settings.Plot.MetafileHeight ) ;

           // Calibration bar settings
     Settings.TimeBarValue := GetKeyValue( Header, 'TBVAL',Settings.TimeBarValue ) ;
     for ch := 0 to MaxChannels-1 do
         Settings.BarValue[ch] := GetKeyValue( Header, format('BVAL%d',[ch]),Settings.BarValue[ch] ) ;

           //GetKeyValue( Header, 'SRT',Settings.SectorWriteTime ) ;

     Settings.DataDirectory := GetKeyValue( Header, 'DDIR', Settings.DataDirectory ) ;
     if not DirectoryExists(Settings.DataDirectory) then
        begin
        Settings.DataDirectory := Settings.ProgDirectory + 'data\' ;
        end;

     Settings.VprotDirectory := GetKeyValue( Header, 'VPDIR', Settings.VprotDirectory ) ;
     if not DirectoryExists(Settings.VprotDirectory) then begin
        Settings.VProtDirectory := Settings.ProgDirectory + 'vprot\' ;
        end;

     Settings.ProtocolListFileName := GetKeyValue( Header, 'PLNAME', Settings.ProtocolListFileName ) ;

     Settings.FileNameIncludeDate := GetKeyValue( Header, 'FNINCDATE', Settings.FileNameIncludeDate ) ;
     Settings.FileNamePrefix := GetKeyValue( Header, 'FNPREFIX', Settings.FileNamePrefix ) ;

     for i := 0 to High(Settings.RecentFiles) do Settings.RecentFiles[i] := '' ;
     Settings.RecentFiles[0] := GetKeyValue( Header, 'RF0', Settings.RecentFiles[0] ) ;
     Settings.RecentFiles[1] := GetKeyValue( Header, 'RF1', Settings.RecentFiles[1] ) ;
     Settings.RecentFiles[2] := GetKeyValue( Header, 'RF2', Settings.RecentFiles[2] ) ;
     Settings.RecentFiles[3] := GetKeyValue( Header, 'RF3', Settings.RecentFiles[3] ) ;

           { Laboratory interface }
           // Only load settings from INI file if SESLabIOinternal settings file does not exist
     if not Main.SESLabIO.SettingsFileExists then
        begin
        Main.SESLabIO.LabInterfaceType := GetKeyValue( Header, 'LABINT',Main.SESLabIO.LabInterfaceType ) ;
        // Lab. interface device #
        Main.SESLabIO.DeviceNumber := GetKeyValue( Header, 'LABDEV',Main.SESLabIO.DeviceNumber ) ;
        // Lab. Interface A/D input mode
//        Main.SESLabIO.ADCInputMode := GetKeyValue( Header, 'LABADIP',Main.SESLabIO.ADCInputMode ) ;
        end ;

     { Waveform generator No Display check box setting }
     Settings.WavGenNoDisplay := GetKeyValue( Header, 'WGNDSP', Settings.WavGenNoDisplay ) ;

//           { Time first record in current data file was recorded }
//           GetKeyValue( Header, 'TRS',Settings.TimeRecordingStarted ) ;

     Settings.DifferentiationMode := GetKeyValue( Header, 'DIFFM', Settings.DifferentiationMode ) ;

     Settings.LockChannelCursors := GetKeyValue( Header,'LOCKCHC', Settings.LockChannelCursors ) ;

           { Display autoerase flag }
     Settings.AutoErase := GetKeyValue( Header, 'AUTOERASE', Settings.AutoErase ) ;

           { Display grid }
     Settings.DisplayGrid := GetKeyValue( Header, 'DISPGRID', Settings.DisplayGrid ) ;

     { Get channel names, units, scale factors }
     for ch := 0 to RawFH.NumChannels-1 do
         begin
         // Units
         Main.SESLabIO.ADCChannelUnits[ch] := GetKeyValue( Header, format('YU%d',[ch]),Main.SESLabIO.ADCChannelUnits[ch] ) ;
         // Name
         Main.SESLabIO.ADCChannelName[ch] := GetKeyValue( Header, format('YN%d',[ch]), Main.SESLabIO.ADCChannelName[ch] ) ;
         // Scale factor
         Main.SESLabIO.ADCChannelVoltsPerUnit[ch] := GetKeyValue( Header, format('YG%d',[ch]), Main.SESLabIO.ADCChannelVoltsPerUnit[ch] ) ;
         { Zero level (in fixed mode) }
         Main.SESLabIO.ADCChannelZero[ch] := GetKeyValue( Header, format('YZ%d',[ch]), Main.SESLabIO.ADCChannelZero[ch] ) ;
         { Start of zero level reference samples (-1 = fixed zero) }
         Main.SESLabIO.ADCChannelZeroAt[ch] := GetKeyValue( Header, format('YR%d',[ch]),Main.SESLabIO.ADCChannelZeroAt[ch]) ;
         end ;

          // Save voltage clamp simulation settings (VCLAMPSim)
     Settings.VClampSim.NumSteps := GetKeyValue( Header, 'VCSIMNS', Settings.VClampSim.NumSteps );
     Settings.VClampSim.GMax :=  GetKeyValue( Header, 'VCSIMGMAX', Settings.VClampSim.GMax );
     Settings.VClampSim.GLeak := GetKeyValue( Header, 'VCSIMGLEAK', Settings.VClampSim.GLeak );
     Settings.VClampSim.GSeries := GetKeyValue( Header, 'VCSIMGSERIES', Settings.VClampSim.GSeries );
     Settings.VClampSim.Cm := GetKeyValue( Header, 'VCSIMCM', Settings.VClampSim.Cm );
     Settings.VClampSim.VRev := GetKeyValue( Header, 'VCSIMVREV', Settings.VClampSim.VRev );
     Settings.VClampSim.VHold := GetKeyValue( Header, 'VCSIMVHOLD', Settings.VClampSim.VHold );
     Settings.VClampSim.VStep := GetKeyValue( Header, 'VCSIMVSTEP', Settings.VClampSim.VStep );

          { Activation gate (m) parameters }
     Settings.VClampSim.m.VHalf := GetKeyValue( Header, 'VCSIMMSSVH', Settings.VClampSim.m.VHalf );
     Settings.VClampSim.m.VSlope := GetKeyValue( Header, 'VCSIMMSSVS', Settings.VClampSim.m.VSlope );
     Settings.VClampSim.m.TauMin := GetKeyValue( Header, 'VCSIMMTAUMIN', Settings.VClampSim.m.TauMin  );
     Settings.VClampSim.m.TauMax := GetKeyValue( Header, 'VCSIMMTAUMAX', Settings.VClampSim.m.TauMax );
     Settings.VClampSim.m.TauVHalf := GetKeyValue( Header, 'VCSIMMTAUVH', Settings.VClampSim.m.TauVHalf  );
     Settings.VClampSim.m.TauVslope := GetKeyValue( Header, 'VCSIMMTAUVS', Settings.VClampSim.m.TauVslope  );
     Settings.VClampSim.m.P := GetKeyValue( Header, 'VCSIMPFAC', Settings.VClampSim.m.P  );

          { Inactivation gate (h) parameters }
     Settings.VClampSim.UseInactivation := GetKeyValue( Header, 'VCSIMHUSE', Settings.VClampSim.UseInactivation  );
     Settings.VClampSim.h.VHalf := GetKeyValue( Header, 'VCSIMHSSVH', Settings.VClampSim.h.VHalf  );
     Settings.VClampSim.h.VSlope :=     GetKeyValue( Header, 'VCSIMHSSVS', Settings.VClampSim.h.VSlope  );
     Settings.VClampSim.h.TauMin := GetKeyValue( Header, 'VCSIMHTAUMIN', Settings.VClampSim.h.TauMin  );
     Settings.VClampSim.h.TauMax := GetKeyValue( Header, 'VCSIMHTAUMAX', Settings.VClampSim.h.TauMax  );
     Settings.VClampSim.h.TauVHalf := GetKeyValue( Header, 'VCSIMHTAUVH', Settings.VClampSim.h.TauVHalf  );
     Settings.VClampSim.h.TauVslope := GetKeyValue( Header, 'VCSIMHTAUVS', Settings.VClampSim.h.TauVslope  );

          // Save synapse simulation settings (SynapseSim)
     Settings.SynapseSim.NumRecords := GetKeyValue( Header, 'SYSIMNRECS',Settings.SynapseSim.NumRecords ) ;
     Settings.SynapseSim.RecordDuration := GetKeyValue( Header, 'SYSIMDUR',Settings.SynapseSim.RecordDuration ) ;
     Settings.SynapseSim.TauRise := GetKeyValue( Header, 'SYSIMTAURISE',Settings.SynapseSim.TauRise ) ;
     Settings.SynapseSim.Tau1 := GetKeyValue( Header, 'SYSIMTAU1',Settings.SynapseSim.Tau1 ) ;
     Settings.SynapseSim.Latency := GetKeyValue( Header, 'SYSIMLATENCY',Settings.SynapseSim.Latency ) ;
     Settings.SynapseSim.Tau2 := GetKeyValue( Header, 'SYSIMTAU2',Settings.SynapseSim.Tau2 ) ;
     Settings.SynapseSim.DoubleExponentialDecay := GetKeyValue( Header, 'SYSSIMDEXP',Settings.SynapseSim.DoubleExponentialDecay ) ;
     Settings.SynapseSim.A2Fraction:= GetKeyValue( Header, 'SYSIMA2F',Settings.SynapseSim.A2Fraction ) ;
     Settings.SynapseSim.QuantumAmplitude := GetKeyValue( Header, 'SYSIMQAMP',Settings.SynapseSim.QuantumAmplitude ) ;
     Settings.SynapseSim.QuantumStDev := GetKeyValue( Header, 'SYSIMQSTD',Settings.SynapseSim.QuantumStDev ) ;
     Settings.SynapseSim.n := GetKeyValue( Header, 'SYSIMN',Settings.SynapseSim.n ) ;
     Settings.SynapseSim.p := GetKeyValue( Header, 'SYSIMP',Settings.SynapseSim.p ) ;
     Settings.SynapseSim.NoiseRMS := GetKeyValue( Header, 'SYSIMNOISE',Settings.SynapseSim.NoiseRMS ) ;
     Settings.SynapseSim.DisplayRange := GetKeyValue( Header, 'SYSIMDRANGE',Settings.SynapseSim.DisplayRange ) ;
     Settings.SynapseSim.VRest := GetKeyValue( Header, 'SYSIMVREST',Settings.SynapseSim.VRest ) ;

          // MEPSCSim settings
     Settings.MEPSCSim.NumRecords := GetKeyValue( Header, 'MEPSIMNR',Settings.MEPSCSim.NumRecords) ;
     Settings.MEPSCSim.RecordDuration := GetKeyValue( Header, 'MEPSIMDUR',Settings.MEPSCSim.RecordDuration) ;
     Settings.MEPSCSim.UnitCurrent := GetKeyValue( Header, 'MEPSIMUC',Settings.MEPSCSim.UnitCurrent) ;
     Settings.MEPSCSim.TransmitterDecayTime := GetKeyValue( Header, 'MEPSIMTDEC',Settings.MEPSCSim.TransmitterDecayTime) ;

     Settings.MEPSCSim.BindingRate := GetKeyValue( Header, 'MEPSIMBIR',Settings.MEPSCSim.BindingRate) ;
     Settings.MEPSCSim.OpenRate := GetKeyValue( Header, 'MEPSIMOPR',Settings.MEPSCSim.OpenRate) ;
     Settings.MEPSCSim.CloseRate := GetKeyValue( Header, 'MEPSIMCLR',Settings.MEPSCSim.CloseRate) ;
     Settings.MEPSCSim.UnbindRate := GetKeyValue( Header, 'MEPSIMUBR',Settings.MEPSCSim.UnbindRate) ;
     Settings.MEPSCSim.BlockRate := GetKeyValue( Header, 'MEPSIMBLR',Settings.MEPSCSim.BlockRate) ;
     Settings.MEPSCSim.UnBlockRate := GetKeyValue( Header, 'MEPSIMUBR',Settings.MEPSCSim.UnBlockRate) ;

     Settings.MEPSCSim.NoiseRMS := GetKeyValue( Header, 'MEPSIMNOI',Settings.MEPSCSim.NoiseRMS) ;
     Settings.MEPSCSim.LPFilter := GetKeyValue( Header, 'MEPSIMLPF',Settings.MEPSCSim.LPFilter) ;

     Settings.MEPSCSim.LPFilterInUse := GetKeyValue( Header, 'MEPSIMLPFIU',Settings.MEPSCSim.LPFilterInUse) ;
     Settings.MEPSCSim.Drift := GetKeyValue( Header, 'MEPSIMDRI',Settings.MEPSCSim.Drift) ;

     Settings.FixedZeroLevels := GetKeyValue( Header, 'FIXZERO', Settings.FixedZeroLevels) ;

     Settings.OpenNewFileOnRecord := GetKeyValue( Header, 'NEWFILEONREC', Settings.OpenNewFileOnRecord) ;

         // On-line analysis settings
     Settings.RecPlot.NumPlots := GetKeyValue( Header, 'RECPNPLOTS',Settings.RecPlot.NumPlots ) ;
     for i := 0 to Settings.RecPlot.NumPlots-1 do
         begin
           Settings.RecPlot.Plot[i].VarNum := GetKeyValue( Header, format('RECPVAR%d',[i]),Settings.RecPlot.Plot[i].VarNum ) ;
           Settings.RecPlot.Plot[i].ChanNum := GetKeyValue( Header, format('RECPCHAN%d',[i]),Settings.RecPlot.Plot[i].ChanNum ) ;
           Settings.RecPlot.Plot[i].YLabel := GetKeyValue( Header, format('RECPYLAB%d',[i]),Settings.RecPlot.Plot[i].YLabel ) ;
           Settings.RecPlot.Plot[i].ListEntry := GetKeyValue( Header, format('RECPLE%d',[i]),Settings.RecPlot.Plot[i].ListEntry ) ;
           Settings.RecPlot.Plot[i].Polarity := GetKeyValue( Header, format('RECPPOL%d',[i]),Settings.RecPlot.Plot[i].Polarity ) ;
           Settings.RecPlot.Plot[i].RateofRiseSmoothing := GetKeyValue( Header, format('RECPRRS%d',[i]),Settings.RecPlot.Plot[i].RateofRiseSmoothing ) ;
           Settings.RecPlot.Plot[i].CursorSet := GetKeyValue( Header, format('RECPCS%d',[i]),Settings.RecPlot.Plot[i].CursorSet ) ;
           Settings.RecPlot.Plot[i].StimProtocol := GetKeyValue( Header, format('RECPSTIM%d',[i]),Settings.RecPlot.Plot[i].StimProtocol ) ;
           end;

     Settings.RecPlot.Cursor0 :=  GetKeyValue( Header, 'RECPCURS0',Settings.RecPlot.Cursor0) ;
     Settings.RecPlot.Cursor1 :=  GetKeyValue( Header, 'RECPCURS1',Settings.RecPlot.Cursor1) ;
     Settings.RecPlot.Cursor2 :=  GetKeyValue( Header, 'RECPCURS2',Settings.RecPlot.Cursor2) ;
     Settings.RecPlot.Cursor3 :=  GetKeyValue( Header, 'RECPCURS3',Settings.RecPlot.Cursor3) ;
     Settings.RecPlot.Cursor4 :=  GetKeyValue( Header, 'RECPCURS4',Settings.RecPlot.Cursor4) ;
     Settings.RecPlot.IgnoreLeakRecords := GetKeyValue( Header, 'RECPIGLEAK', Settings.RecPlot.IgnoreLeakRecords ) ;

         // Quantal analysis settings
     Settings.QuantalAnalysis.EvokedType := GetKeyValue( Header, 'QAEVTYPE', Settings.QuantalAnalysis.EvokedType ) ;
     Settings.QuantalAnalysis.MiniType := GetKeyValue( Header, 'QAMITYPE', Settings.QuantalAnalysis.MiniType ) ;
     Settings.QuantalAnalysis.Potentials := GetKeyValue( Header, 'QUPOT', Settings.QuantalAnalysis.Potentials ) ;

          // Read stimulator global variables
     for i := 0 to MaxStimGlobalVars-1 do
         begin
         Stimulator.GlobalVar[i] := GetKeyValue( Header, format('GVAR%d',[i+1]),Stimulator.GlobalVar[i]) ;
         end;

     // Save main form size and position
     Main.Width := GetKeyValue( Header, 'FORMWIDTH', Main.Width ) ;
     Main.Height := GetKeyValue( Header, 'FORMHEIGHT', Main.Height ) ;
     Main.Top := GetKeyValue( Header, 'FORMTOP',Main.Top ) ;
     Main.Left := GetKeyValue( Header, 'FORMLEFT', Main.Left ) ;

     Header.Free ;

     end ;

procedure TWCPFile.SaveInitializationFile( const IniFileName : string ) ;
{ --------------------------------------------
  Save program settings to Initialization file
  --------------------------------------------}
type
    TKeyword = string[6] ;
var
   Header : TStringList ;
   i,ch : Integer ;
begin

     // Create file header Name=Value string list
     Header := TStringList.Create ;

     { Last raw data file used }
     AddKeyValue( Header, 'FILE', RawFH.FileName ) ;
     { Last averages data file used }
     if AvgFH.Filename <> '' then
           AddKeyValue( Header, 'FILEAVG', AvgFH.FileName ) ;
     { Last leak subtracted data file used }
     if LeakFH.Filename <> '' then
           AddKeyValue( Header, 'LEAKAVG', LeakFH.FileName ) ;

     // SAve default recording settings
     AddKeyValue( Header, 'NC', Settings.NumChannels ) ;
     AddKeyValue( Header, 'NSAMP', Settings.NumSamples ) ;
     AddKeyValue( Header, 'RECDUR', Settings.RecordDuration ) ;

     AddKeyValue( Header, 'CEDI', Amplifier.CED1902.Input ) ;
     AddKeyValue( Header, 'CEDG', Amplifier.CED1902.Gain ) ;
     AddKeyValue( Header, 'CEDGV', Amplifier.CED1902.GainValue ) ;
     AddKeyValue( Header, 'CEDLP', Amplifier.CED1902.LPFilter ) ;
     AddKeyValue( Header, 'CEDHP', Amplifier.CED1902.HPFilter ) ;
     AddKeyValue( Header, 'CEDAC', Amplifier.CED1902.ACCoupled ) ;
     AddKeyValue( Header, 'CEDDCO', Amplifier.CED1902.DCOffset ) ;
     AddKeyValue( Header, 'CEDNF', Amplifier.CED1902.NotchFilter ) ;
     AddKeyValue( Header, 'CEDPO', Amplifier.CED1902.ComPort ) ;

     // Patch clamp amplifier data
     AddKeyValue( Header, 'AMP1',Amplifier.AmplifierType[0] ) ;
     AddKeyValue( Header, 'AMP1GAINCH',Amplifier.GainTelegraphChannel[0] ) ;
     AddKeyValue( Header, 'AMP1MODECH',Amplifier.ModeTelegraphChannel[0] ) ;
     AddKeyValue( Header, 'AMP2',Amplifier.AmplifierType[1] ) ;
     AddKeyValue( Header, 'AMP2GAINCH',Amplifier.GainTelegraphChannel[1] ) ;
     AddKeyValue( Header, 'AMP2MODECH',Amplifier.ModeTelegraphChannel[1] ) ;

     { Read record settings }
     AddKeyValue( Header, 'RECMODE', Settings.RecordingMode ) ;
     { Event detector, channel and % threshold level }
     AddKeyValue( Header, 'DETCH', Settings.EventDetector.Channel ) ;
     AddKeyValue( Header, 'DETTH', Settings.EventDetector.Threshold ) ;
     AddKeyValue( Header, 'DETPT', Settings.EventDetector.PreTrigger ) ;
     AddKeyValue( Header, 'EXTTRIGAH', Settings.ExternalTriggerActiveHigh ) ;

     AddKeyValue( Header, 'AER', Settings.AutoErase ) ;
     AddKeyValue( Header, 'NRQ', Settings.NumRecordsRequired ) ;
     AddKeyValue( Header, 'FILEVPR', Settings.VProgramFileName ) ;

     AddKeyValue( Header, 'VCHOLD', Main.SESLabIO.DACHoldingVoltage[0] ) ;
     for ch := 0 to MaxAmplifiers-1 do begin
         AddKeyValue( Header, format('VCHOLD%d',[ch]),Main.SESLabIO.DACHoldingVoltage[ch] ) ;
         end ;

     AddKeyValue( Header, 'DIGPORT', Settings.DigitalPort.Value ) ;

     // Invert recording sweep trigger pulse flag
     AddKeyValue( Header, 'DACINVTRIG', Settings.DACInvertTriggerLevel ) ;

     AddKeyValue( Header, 'CUTOFF', Settings.CutOffFrequency ) ;
     AddKeyValue( Header, 'TUNITS', Settings.TUnits ) ;

     { Pipette seal test settings }
     AddKeyValue( Header, 'STPH', Settings.SealTest.PulseHeight ) ;
     AddKeyValue( Header, 'STPH1', Settings.SealTest.PulseHeight1 ) ;
     AddKeyValue( Header, 'STPH2', Settings.SealTest.PulseHeight2 ) ;
     AddKeyValue( Header, 'STPH3', Settings.SealTest.PulseHeight3 ) ;
     AddKeyValue( Header, 'STHV1', Settings.SealTest.HoldingVoltage1 ) ;
     AddKeyValue( Header, 'STHV2', Settings.SealTest.HoldingVoltage2 ) ;
     AddKeyValue( Header, 'STHV3', Settings.SealTest.HoldingVoltage3 ) ;
     AddKeyValue( Header, 'STPW', Settings.SealTest.PulseWidth ) ;
     AddKeyValue( Header, 'STCCH', Settings.SealTest.CurrentChannel ) ;
     AddKeyValue( Header, 'STVCH', Settings.SealTest.VoltageChannel ) ;
     AddKeyValue( Header, 'STUSE', Settings.SealTest.Use ) ;
     AddKeyValue( Header, 'STDSC', Settings.SealTest.DisplayScale ) ;
     AddKeyValue( Header, 'STASC', Settings.SealTest.AutoScale ) ;
     AddKeyValue( Header, 'STFRU', Settings.SealTest.FreeRun ) ;
     AddKeyValue( Header, 'STNAV', Settings.SealTest.NumAverages ) ;
     AddKeyValue( Header, 'STZAPA', Settings.SealTest.ZapAmplitude ) ;
     AddKeyValue( Header, 'STZAPD', Settings.SealTest.ZapDuration ) ;
     AddKeyValue( Header, 'STGAP', Settings.SealTest.GaFromPeak ) ;

     AddKeyValue( Header, 'NC', RawFH.NumChannels ) ;

     RawFH.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(RawFH.NumChannels) ;

     i := 1 ;
     AddKeyValue( Header, 'NBA', i ) ;

     i := ((RawFH.NumSamples*RawFH.NumChannels*2) div 512 ) ;
     AddKeyValue(Header,'NBD', i) ;

     AddKeyValue( Header, 'AD', RawFH.ADCVoltageRange ) ;

     AddKeyValue( Header, 'DT',RawFH.dt );

     { Plotting page settings }
     AddKeyValue( Header, 'PLTPM',Settings.Plot.TopMargin ) ;
     AddKeyValue( Header, 'PLBTM',Settings.Plot.BottomMargin ) ;
     AddKeyValue( Header, 'PLLFM',Settings.Plot.LeftMargin ) ;
     AddKeyValue( Header, 'PLRTM',Settings.Plot.RightMargin ) ;
     AddKeyValue( Header, 'PLFNT',Settings.Plot.FontName ) ;
     AddKeyValue( Header, 'PLFSI',Settings.Plot.FontSize ) ;
     AddKeyValue( Header, 'PLLTH',Settings.Plot.LineThickness ) ;
     AddKeyValue( Header, 'PLSHL',Settings.Plot.ShowLines ) ;
     AddKeyValue( Header, 'PLMKS',Settings.Plot.MarkerSize ) ;
     AddKeyValue( Header, 'PLSHM',Settings.Plot.ShowMarkers ) ;
     AddKeyValue( Header, 'PLCOL',Settings.Plot.UseColor ) ;
     { Width/height of clipboard metafiles }
     AddKeyValue( Header, 'PLMFW', Settings.Plot.MetafileWidth ) ;
     AddKeyValue( Header, 'PLMFH', Settings.Plot.MetafileHeight ) ;

     // Calibration bar settings
     AddKeyValue( Header, 'TBVAL',Settings.TimeBarValue ) ;
     for ch := 0 to MaxChannels-1 do
         AddKeyValue( Header, format('BVAL%d',[ch]),
                      Settings.BarValue[ch] ) ;

     //AddKeyValue( Header, 'SRT',Settings.SectorWriteTime ) ;

     AddKeyValue( Header, 'DDIR', Settings.DataDirectory ) ;

     AddKeyValue( Header, 'VPDIR', Settings.VprotDirectory ) ;

     AddKeyValue( Header, 'PLNAME', Settings.ProtocolListFileName ) ;

     AddKeyValue( Header, 'FNINCDATE', Settings.FileNameIncludeDate ) ;
     AddKeyValue( Header, 'FNPREFIX', Settings.FileNamePrefix ) ;

     AddKeyValue( Header, 'RF0', Settings.RecentFiles[0] ) ;
     AddKeyValue( Header, 'RF1', Settings.RecentFiles[1] ) ;
     AddKeyValue( Header, 'RF2', Settings.RecentFiles[2] ) ;
     AddKeyValue( Header, 'RF3', Settings.RecentFiles[3] ) ;

     AddKeyValue( Header, 'LABINT',Settings.LaboratoryInterface ) ;
     AddKeyValue( Header, 'LABDEV',Settings.DeviceNumber ) ;
     AddKeyValue( Header, 'LABADIP',Settings.ADCInputMode ) ;

     { Waveform generator No Display check box setting }
     AddKeyValue( Header, 'WGNDSP', Settings.WavGenNoDisplay ) ;

//     { Time first record in current data file was recorded }
//     AddKeyValue( Header, 'TRS',Settings.TimeRecordingStarted ) ;

     { Differentiation mode for waveform measurements }
     AddKeyValue( Header, 'DIFFM', Settings.DifferentiationMode ) ;

     // Lock waveform measurements analysis cursors flag (measurefrm)
     AddKeyValue( Header,'LOCKCHC', Settings.LockChannelCursors ) ;

     { Display autoerase flag }
     AddKeyValue( Header, 'AUTOERASE', Settings.AutoErase ) ;

     { Display grid flag }
     AddKeyValue( Header, 'DISPGRID', Settings.DisplayGrid ) ;

     for ch := 0 to RawFH.NumChannels-1 do
         begin
         AddKeyValue( Header, format('YU%d',[ch]), Main.SESLabIO.ADCChannelUnits[ch] ) ;
         AddKeyValue( Header, format('YN%d',[ch]), Main.SESLabIO.ADCChannelName[ch] ) ;
         AddKeyValue( Header, format('YG%d',[ch]),
                      Main.SESLabIO.ADCChannelVoltsPerUnit[ch] ) ;
         { Zero level (in fixed mode) }
         AddKeyValue( Header, format('YZ%d',[ch]), Main.SESLabIO.ADCChannelZero[ch]) ;
         { Start of zero level reference samples (-1 = fixed zero) }
         AddKeyValue( Header, format('YR%d',[ch]), Main.SESLabIO.ADCChannelZeroAt[ch]) ;
         end ;

     // Save voltage clamp simulation settings (VCLAMPSim)
     AddKeyValue( Header, 'VCSIMNS', Settings.VClampSim.NumSteps );
     AddKeyValue( Header, 'VCSIMGMAX', Settings.VClampSim.GMax );
     AddKeyValue( Header, 'VCSIMGLEAK', Settings.VClampSim.GLeak );
     AddKeyValue( Header, 'VCSIMGSERIES', Settings.VClampSim.GSeries );
     AddKeyValue( Header, 'VCSIMCM', Settings.VClampSim.Cm );
     AddKeyValue( Header, 'VCSIMVREV', Settings.VClampSim.VRev );
     AddKeyValue( Header, 'VCSIMVHOLD', Settings.VClampSim.VHold );
     AddKeyValue( Header, 'VCSIMVSTEP', Settings.VClampSim.VStep );

     { Activation gate (m) parameters }
     AddKeyValue( Header, 'VCSIMMSSVH', Settings.VClampSim.m.VHalf );
     AddKeyValue( Header, 'VCSIMMSSVS', Settings.VClampSim.m.VSlope );
     AddKeyValue( Header, 'VCSIMMTAUMIN', Settings.VClampSim.m.TauMin  );
     AddKeyValue( Header, 'VCSIMMTAUMAX', Settings.VClampSim.m.TauMax );
     AddKeyValue( Header, 'VCSIMMTAUVH', Settings.VClampSim.m.TauVHalf  );
     AddKeyValue( Header, 'VCSIMMTAUVS', Settings.VClampSim.m.TauVslope  );
     AddKeyValue( Header, 'VCSIMPFAC', Settings.VClampSim.m.P  );

     { Inactivation gate (h) parameters }
     AddKeyValue( Header, 'VCSIMHUSE', Settings.VClampSim.UseInactivation  );
     AddKeyValue( Header, 'VCSIMHSSVH', Settings.VClampSim.h.VHalf  );
     AddKeyValue( Header, 'VCSIMHSSVS', Settings.VClampSim.h.VSlope  );
     AddKeyValue( Header, 'VCSIMHTAUMIN', Settings.VClampSim.h.TauMin  );
     AddKeyValue( Header, 'VCSIMHTAUMAX', Settings.VClampSim.h.TauMax  );
     AddKeyValue( Header, 'VCSIMHTAUVH', Settings.VClampSim.h.TauVHalf  );
     AddKeyValue( Header, 'VCSIMHTAUVS', Settings.VClampSim.h.TauVslope  );

     // Synapse simulation settings (SynapseSim)
     AddKeyValue( Header, 'SYSIMNRECS',Settings.SynapseSim.NumRecords ) ;
     AddKeyValue( Header, 'SYSIMDUR',Settings.SynapseSim.RecordDuration ) ;
     AddKeyValue( Header, 'SYSIMTAURISE',Settings.SynapseSim.TauRise ) ;
     AddKeyValue( Header, 'SYSIMTAU1',Settings.SynapseSim.Tau1 ) ;
     AddKeyValue( Header, 'SYSIMLATENCY',Settings.SynapseSim.Latency ) ;
     AddKeyValue( Header, 'SYSIMTAU2',Settings.SynapseSim.Tau2 ) ;
     AddKeyValue( Header, 'SYSSIMDEXP',Settings.SynapseSim.DoubleExponentialDecay ) ;
     AddKeyValue( Header, 'SYSIMA2F',Settings.SynapseSim.A2Fraction ) ;
     AddKeyValue( Header, 'SYSIMQAMP',Settings.SynapseSim.QuantumAmplitude ) ;
     AddKeyValue( Header, 'SYSIMQSTD',Settings.SynapseSim.QuantumStDev ) ;
     AddKeyValue( Header, 'SYSIMN',Settings.SynapseSim.n ) ;
     AddKeyValue( Header, 'SYSIMP',Settings.SynapseSim.p ) ;
     AddKeyValue( Header, 'SYSIMNOISE',Settings.SynapseSim.NoiseRMS ) ;
     AddKeyValue( Header, 'SYSIMDRANGE',Settings.SynapseSim.DisplayRange ) ;
     AddKeyValue( Header, 'SYSIMVREST',Settings.SynapseSim.VRest ) ;

     // MEPSCSim settings
     AddKeyValue( Header, 'MEPSIMNR',Settings.MEPSCSim.NumRecords) ;
     AddKeyValue( Header, 'MEPSIMDUR',Settings.MEPSCSim.RecordDuration) ;
     AddKeyValue( Header, 'MEPSIMUC',Settings.MEPSCSim.UnitCurrent) ;
     AddKeyValue( Header, 'MEPSIMTDEC',Settings.MEPSCSim.TransmitterDecayTime) ;

     AddKeyValue( Header, 'MEPSIMBIR',Settings.MEPSCSim.BindingRate) ;
     AddKeyValue( Header, 'MEPSIMOPR',Settings.MEPSCSim.OpenRate) ;
     AddKeyValue( Header, 'MEPSIMCLR',Settings.MEPSCSim.CloseRate) ;
     AddKeyValue( Header, 'MEPSIMUBR',Settings.MEPSCSim.UnbindRate) ;
     AddKeyValue( Header, 'MEPSIMBLR',Settings.MEPSCSim.BlockRate) ;
     AddKeyValue( Header, 'MEPSIMUBR',Settings.MEPSCSim.UnBlockRate) ;

     AddKeyValue( Header, 'MEPSIMNOI',Settings.MEPSCSim.NoiseRMS) ;
     AddKeyValue( Header, 'MEPSIMLPF',Settings.MEPSCSim.LPFilter) ;

     AddKeyValue( Header, 'MEPSIMLPFIU',Settings.MEPSCSim.LPFilterInUse) ;
     AddKeyValue( Header, 'MEPSIMDRI',Settings.MEPSCSim.Drift) ;

     AddKeyValue( Header, 'FIXZERO', Settings.FixedZeroLevels) ;
     AddKeyValue( Header, 'NEWFILEONREC', Settings.OpenNewFileOnRecord) ;

     // On-line analysis settings
     AddKeyValue( Header, 'RECPNPLOTS',Settings.RecPlot.NumPlots ) ;
     for i := 0 to Settings.RecPlot.NumPlots-1 do
         begin
         AddKeyValue( Header, format('RECPVAR%d',[i]),Settings.RecPlot.Plot[i].VarNum ) ;
         AddKeyValue( Header, format('RECPCHAN%d',[i]),Settings.RecPlot.Plot[i].ChanNum ) ;
         AddKeyValue( Header, format('RECPYLAB%d',[i]),Settings.RecPlot.Plot[i].YLabel ) ;
         AddKeyValue( Header, format('RECPLE%d',[i]),Settings.RecPlot.Plot[i].ListEntry ) ;
         AddKeyValue( Header, format('RECPPOL%d',[i]),Settings.RecPlot.Plot[i].Polarity ) ;
         AddKeyValue( Header, format('RECPRRS%d',[i]),Settings.RecPlot.Plot[i].RateofRiseSmoothing ) ;
         AddKeyValue( Header, format('RECPCS%d',[i]),Settings.RecPlot.Plot[i].CursorSet ) ;
         AddKeyValue( Header, format('RECPSTIM%d',[i]),Settings.RecPlot.Plot[i].StimProtocol ) ;
         end;

     AddKeyValue( Header, 'RECPCURS0',Settings.RecPlot.Cursor0) ;
     AddKeyValue( Header, 'RECPCURS1',Settings.RecPlot.Cursor1) ;
     AddKeyValue( Header, 'RECPCURS2',Settings.RecPlot.Cursor2) ;
     AddKeyValue( Header, 'RECPCURS3',Settings.RecPlot.Cursor3) ;
     AddKeyValue( Header, 'RECPCURS4',Settings.RecPlot.Cursor4) ;
     AddKeyValue( Header, 'RECPIGLEAK', Settings.RecPlot.IgnoreLeakRecords ) ;

     // Save stimulator global variables
     for i := 0 to MaxStimGlobalVars-1 do
         begin
         AddKeyValue( Header, format('GVAR%d',[i+1]),Stimulator.GlobalVar[i]) ;
         end;

     // Save main form size and position
     AddKeyValue( Header, 'FORMTOP',Main.Top ) ;
     AddKeyValue( Header, 'FORMLEFT',Main.Left ) ;
     AddKeyValue( Header, 'FORMWIDTH',Main.Width ) ;
     AddKeyValue( Header, 'FORMHEIGHT',Main.Height ) ;

     // Quantal analysis settings
     AddKeyValue( Header, 'QAEVTYPE', Settings.QuantalAnalysis.EvokedType ) ;
     AddKeyValue( Header, 'QAMITYPE', Settings.QuantalAnalysis.MiniType ) ;
     AddKeyValue( Header, 'QUPOT', Settings.QuantalAnalysis.Potentials ) ;

     // Save Name=Value list to INI file
     Header.SaveToFile( IniFileName ) ;

     // Free List
     Header.Free ;

     end ;


function TWCPFile.CreateIndexedFileName(
         FileName : String ) : String ;
// ---------------------------------------------------
// Append an (incremented) index number to end of file
// ---------------------------------------------------
var
     i : Integer ;
     ExtensionStart : Integer ;
     IndexNumberStart : Integer ;
     IndexNum : Integer ;
     sDate,NewFileName : String ;
     FileStem : String ;
begin

     // Create new file name based on date

     DateTimeToString( sDate, 'yymmdd', Date() ) ;
     FileName := WCPFile.Settings.DataDirectory  + WCPFile.Settings.FileNamePrefix ;
     if WCPFile.Settings.FileNameIncludeDate then FileName := FileName + sDate ;
     FileName := FileName + '.wcp' ;

     // Find '_nnn' index number (if it exists)
     i := Length(FileName) ;
     ExtensionStart := Length(FileName)+1 ;
     IndexNumberStart := -1 ;
     While (i > 0) do begin
         if FileName[i] = '.' then ExtensionStart := i ;
         if FileName[i] = '_' then begin
            IndexNumberStart := i ;
            Break ;
            end ;
         Dec(i) ;
         end ;

     if ((ExtensionStart - IndexNumberStart) > 4)
        or (ExtensionStart < 5) then IndexNumberStart := -1 ;

     // Find next available (lowest) index number for this file name

     FileStem :=  '' ;
     if IndexNumberStart > 0 then begin
        for i := 1 to IndexNumberStart-1 do
            FileStem :=  FileStem + FileName[i] ;
        end
     else begin
        for i := 1 to ExtensionStart-1 do
            FileStem :=  FileStem + FileName[i] ;
        end ;

     IndexNum := 0 ;
     repeat
          Inc(IndexNum) ;
          NewFileName := FileStem + format('_%.3d',[IndexNum]) ;
          for i := ExtensionStart to Length(FileName) do
              NewFileName := NewFileName + FileName[i] ;
          until not FileExists(NewFileName) ;

     // Return name
     Result := NewFileName ;

     end ;


procedure TWCPFile.AddKeyValue( List : TStringList ;  // List for Key=Value pairs
                                KeyWord : string ;    // Key
                                Value : single        // Value
                                 ) ;
// ---------------------
// Add Key=Single Value to List
// ---------------------
begin
     Keyword := ReplaceText( Keyword,'=','') ;
     List.Add( Keyword + format('=%.4g',[Value]) ) ;
end;


procedure TWCPFile.AddKeyValue( List : TStringList ;  // List for Key=Value pairs
                                KeyWord : string ;    // Key
                                Value : Integer        // Value
                                 ) ;
// ---------------------
// Add Key=Integer Value to List
// ---------------------
begin
     Keyword := ReplaceText( Keyword,'=','') ;
     List.Add( Keyword + format('=%d',[Value]) ) ;
end;

procedure TWCPFile.AddKeyValue( List : TStringList ;  // List for Key=Value pairs
                                KeyWord : string ;    // Key
                                Value : NativeInt        // Value
                                 ) ;
// ---------------------
// Add Key=NativeInt Value to List
// ---------------------
begin
     Keyword := ReplaceText( Keyword,'=','') ;
     List.Add( Keyword + format('=%d',[Value] )) ;
end;


procedure TWCPFile.AddKeyValue( List : TStringList ;  // List for Key=Value pairs
                                KeyWord : string ;    // Key
                                Value : string        // Value
                                 ) ;
// ---------------------
// Add Key=string Value to List
// ---------------------
begin
     Keyword := ReplaceText( Keyword,'=','') ;
     List.Add( Keyword + '=' + Value ) ;
end;


procedure TWCPFile.AddKeyValue( List : TStringList ;  // List for Key=Value pairs
                                KeyWord : string ;    // Key
                                Value : Boolean        // Value
                                 ) ;
// ---------------------
// Add Key=boolean Value to List
// ---------------------
begin
     Keyword := ReplaceText( Keyword,'=','') ;
     if Value then List.Add( Keyword + '= T' )
              else List.Add( Keyword + '= F' ) ;
end;



procedure TWCPFile.DataModuleCreate(Sender: TObject);
// --------------------------------------
// Initialisations when module is created
// --------------------------------------
var
    ch : Integer ;
  I: Integer;
begin


      { Get directory which contains WinWCP program }
      Settings.ProgDirectory := ExtractFilePath(ParamStr(0)) ;

     // Create settings directory
      SettingsDirectory := GetSpecialFolder(CSIDL_COMMON_DOCUMENTS) + '\WinWCP\';
     if not System.SysUtils.DirectoryExists(SettingsDirectory) then begin
        if System.SysUtils.ForceDirectories(SettingsDirectory) then
           WriteToLogFile( 'Settings folder ' + SettingsDirectory + ' created.')
        else WriteToLogFile( 'Unable to create settings folder' + SettingsDirectory) ;
        end ;
      SettingsFileName := SettingsDirectory + 'winwcp.ini' ;

     { Open log file (contains log of program activity) }
     OpenLogFile ;
     WriteToLogFile( 'WinWCP Started' ) ;

     // Stimulus protocols folder
     Settings.VProtDirectory := GetSpecialFolder(CSIDL_COMMON_DOCUMENTS) + '\WinWCP\Vprot\';
      if not System.SysUtils.DirectoryExists(Settings.VProtDirectory) then begin
         if System.SysUtils.ForceDirectories(Settings.VProtDirectory) then
            WriteToLogFile( 'Protocols folder ' + Settings.VProtDirectory + ' created.')
         else WriteToLogFile( 'Unable to create protocols folder' + Settings.VProtDirectory) ;
         end ;

      // Create default data directory (in My Documents)
      Settings.DataDirectory := GetSpecialFolder(CSIDL_PERSONAL) + '\WinWCP Data\';
      if not System.SysUtils.DirectoryExists(Settings.DataDirectory) then begin
         if System.SysUtils.ForceDirectories(Settings.DataDirectory) then
            WriteToLogFile( 'Data folder ' + Settings.DataDirectory + ' created.')
         else WriteToLogFile( 'Unable to create data folder' + Settings.DataDirectory) ;
         end ;


    { Initialise to no laboratory interface }
     Settings.LaboratoryInterface := 0 ;
     Settings.DeviceNumber := 1 ;

     Settings.NumChannels := 1 ;
     Settings.NumSamples := 4096 ;
     Settings.RecordDuration := 1.0 ;

     Settings.RecordingMode := 0 ;
     Settings.EventDetector.Channel := 0 ;
     Settings.EventDetector.Threshold := 0.1 ;
     Settings.EventDetector.PreTrigger := 0.1 ;
     Settings.ExternalTriggerActiveHigh := False ;

     Settings.AutoErase := True ;
     Settings.DisplayGrid := True ;
     Settings.ResetDisplayMagnification := True ;

     Settings.Colors.Cursors := clBlue ;
     Settings.Colors.Grid := clAqua ;
     Settings.FixedZeroLevels := False ;

     Settings.NumRecordsRequired := 1 ;
     Settings.CutOffFrequency := 0. ;
     { Minimum interval for updating D/A converters when
       generating command voltage waveforms }
     Settings.MinDACInterval := 0.0001 ;

     Settings.TUnits := 'ms' ;
     Settings.TScale := SecsToMs ;
     Settings.TUnScale := MsToSecs ;

     { Name of command voltage protocol file in current use }
     Settings.VProgramFileName := '' ;
     Settings.VProgramFileName := '' ;

     { Divide factor that the patch/voltage clamp applies to its
       command voltage input. The D/A output voltage is thus scaled up
       by this factor }

     Settings.DACInvertTriggerLevel := False ;
     Settings.DigitalPort.Value := 0 ;
     Settings.UpdateOutputs := True ;

     { Default settings for seal test pulse }
     Settings.SealTest.Use := 1 ;
     Settings.SealTest.PulseHeight1 := 0.01 ;
     Settings.SealTest.HoldingVoltage1 := 0. ;
     Settings.SealTest.PulseHeight2 := 0.01 ;
     Settings.SealTest.HoldingVoltage2 := 0. ;
     Settings.SealTest.PulseHeight3 := 0.0 ;
     Settings.SealTest.HoldingVoltage3 := 0. ;

     Settings.SealTest.PulseWidth:= 0.03 ;
     Settings.SealTest.CurrentChannel := 0 ;
     Settings.SealTest.VoltageChannel := 1 ;
     Settings.SealTest.AutoScale := True ;
     Settings.SealTest.DisplayScale := 1 ;
     Settings.SealTest.NumAverages := 1 ;

     Settings.SealTest.ZapAmplitude := 0.2 ;
     Settings.SealTest.ZapDuration := 0.1 ;

     { Set flag indicating this is the first sweep, to force an autoscale }
     Settings.SealTest.FirstSweep := True ;

     Settings.Plot.TopMargin := 25.0 ;
     Settings.Plot.LeftMargin := 25.0 ;
     Settings.Plot.BottomMargin := 5.0 ;
     Settings.Plot.RightMargin := 25.0;
     Settings.Plot.FontName := 'Arial' ;
     Settings.Plot.FontSize := 12 ;
     Settings.Plot.LineThickness := 2 ;
     Settings.Plot.MarkerSize := 5 ;
     Settings.Plot.ShowLines := True ;
     Settings.Plot.ShowMarkers := True ;
     Settings.Plot.MetafileWidth := 600 ;
     Settings.Plot.MetafileHeight := 600 ;

     { Bitmap size for images copied to clipboard }
     Settings.BitmapWidth := 600 ;
     Settings.BitmapHeight := 500 ;

     // Voltage clamp simulation  settings
     Settings.VClampSim.NumSteps := 16 ;
     Settings.VClampSim.GMax :=20E-9 ;
     Settings.VClampSim.GLeak := 1E-9 ;
     Settings.VClampSim.GSeries := 200E-9 ;
     Settings.VClampSim.Cm := 30E-12 ;
     Settings.VClampSim.VRev := -100E-3 ;
     Settings.VClampSim.VHold := -90E-3 ;
     Settings.VClampSim.VStep := 10E-3 ;

     { Activation gate (m) parameters }
     Settings.VClampSim.m.VHalf := -1E-3 ;
     Settings.VClampSim.m.VSlope := -11E-3 ;
     Settings.VClampSim.m.TauMin := 1.5E-3 ;
     Settings.VClampSim.m.TauMax := 3.5E-3 ;
     Settings.VClampSim.m.TauVHalf := 0.0 ;
     Settings.VClampSim.m.TauVslope := 30E-3 ;
     Settings.VClampSim.m.P := 1 ;

     { Inactivation gate (h) parameters }
     Settings.VClampSim.UseInactivation := false ;

     Settings.VClampSim.h.VHalf := -45E-3 ;
     Settings.VClampSim.h.VSlope := 11.5E-3 ;
     Settings.VClampSim.h.TauMin := 14E-3 ;
     Settings.VClampSim.h.TauMax := 482.6E-3 ;
     Settings.VClampSim.h.TauVHalf := -52.5E-3 ;
     Settings.VClampSim.h.TauVslope := 15E-3 ;
     Settings.VClampSim.h.P := 1. ;

     // Synaptic current simulation settings
     Settings.SynapseSim.NumRecords := 100 ;
     Settings.SynapseSim.RecordDuration := 1E-1 ;
     Settings.SynapseSim.TauRise := 2E-4 ;
     Settings.SynapseSim.Tau1 := 1E-2 ;
     Settings.SynapseSim.Latency := 0.0 ;
     Settings.SynapseSim.Tau2 := 5E-2 ;
     Settings.SynapseSim.A2Fraction := 0.1 ;
     Settings.SynapseSim.QuantumAmplitude := 1.0 ;
     Settings.SynapseSim.QuantumStDev := 0.0 ;
     Settings.SynapseSim.n := 1.0 ;
     Settings.SynapseSim.p := 1.0 ;
     Settings.SynapseSim.NoiseRMS := 0.1 ;
     Settings.SynapseSim.DisplayRange := 10.0 ;
     Settings.SynapseSim.VRest := -90.0 ;
     Settings.SynapseSim.DoubleExponentialDecay := False ;

     // MEPSC simulation parameters
     Settings.MEPSCSim.NumRecords := 100 ;
     Settings.MEPSCSim.RecordDuration := 0.1 ;
     Settings.MEPSCSim.UnitCurrent := 1.0 ;
     Settings.MEPSCSim.TransmitterDecayTime := 100E-6 ;

     Settings.MEPSCSim.BindingRate :=  2E5 ;
     Settings.MEPSCSim.OpenRate := 1E4 ;
     Settings.MEPSCSim.CloseRate :=  1E3 ;
     Settings.MEPSCSim.UnbindRate :=  1E3 ;
     Settings.MEPSCSim.BlockRate := 0.0 ;
     Settings.MEPSCSim.UnBlockRate := 0.0 ;

     Settings.MEPSCSim.NoiseRMS := 0. ;
     Settings.MEPSCSim.LPFilter := 1000.0 ;
     Settings.MEPSCSim.LPFilterInUse := False ;
     Settings.MEPSCSim.Drift := 0.0 ;

     { Time taken to write one sector to hard disk }
     { Zero forces a write test to be made within wavgen module }
     //Settings.SectorWriteTime := 0. ;

     Settings.ProtocolListFileName := '' ;

     Settings.FileNameIncludeDate := True ;  // Include date in auto-created file names
     Settings.FileNamePrefix := '' ;          // Add prefix to name

     { Settings for record hard copy plots }
     Settings.TimeBarValue := -1. ;
     for ch := 0 to MaxChannels-1 do Settings.BarValue[ch] := -1. ;
     Settings.ShowLabels := True ;
     Settings.ShowZeroLevels := True ;

     Settings.DifferentiationMode := 0 ;
     Settings.LockChannelCursors := True ;

     Settings.WavGenNoDisplay := False ; {Display waveform check box settings
                                          for Waveform Generator }

     // On-line analysis cursor positions
     Settings.OpenNewFileOnRecord := False ;
     Settings.RecPlot.Cursor0 := -1 ;
     Settings.RecPlot.Cursor1 := -1 ;
     Settings.RecPlot.Cursor2 := -1 ;
     Settings.RecPlot.Cursor3 := -1 ;
     Settings.RecPlot.Cursor4 := -1 ;

     // Quantal analysis default settings
     Settings.QuantalAnalysis.EvokedType := 'TEST' ;
     Settings.QuantalAnalysis.MiniType := 'MINI' ;
     Settings.QuantalAnalysis.Potentials := false ;

     { Set the file names and handles for all header blocks to null }
     RawFH.FileHandle := -1 ;
     RawFH.FileName := '' ;
     AvgFH.FileHandle := -1 ;
     AvgFH.FileName := '' ;
     LeakFH.FileHandle := -1 ;
     LeakFH.FileName := '' ;
     DrvFH.FileHandle := -1 ;
     DrvFH.FileName := '' ;
     RawFH.RecordingStartTime := '' ;

     { Minimum/maximum of binary A/D and D/A data samples }
     RawFH.MinADCValue := -2048 ;
     RawFH.MaxADCValue := 2047 ;
  //   MinDACValue := -2048 ;
  //   MaxDACVAlue := 2047 ;

     RawFH.CreationTime := '' ;
     RawFH.NumChannels := 1 ;
     RawFH.NumSamples := 512 ;
     RawFH.NumAnalysisBytesPerRecord := 512 ;
     RawFH.NumDataBytesPerRecord := RawFH.NumSamples*RawFH.NumChannels*2 ;
     RawFH.NumBytesPerRecord := RawFH.NumDataBytesPerRecord
                                + RawFH.NumAnalysisBytesPerRecord ;
     RawFH.NumBytesInHeader := NumBytesInFileHeader(RawFH.NumChannels) ;
     RawFH.ADCVoltageRange := 5. ;
     RawFH.NumZeroAvg := 20  ;
     RawFH.dt := 0.001 ;
     RawFH.Version := 8.0 ;
     RawFH.ProgVersion := ProgVersion ;
     RawFH.NumPointsAveragedAtPeak := 1 ;
     RawFH.LatencyPercentage := 10.0 ;

     // Set all measurement cursors to zero indicating they have not been set
     for i := 0 to High(FH.C0Cursor) do FH.C0Cursor[i] := 0 ;
     for i := 0 to High(FH.C1Cursor) do FH.C1Cursor[i] := 0 ;
     FH.T0Cursor := 0 ;

      { Create default set of record types }
      RecordTypes := TStringList.Create ;
      RecordTypes.Add( 'ALL' ) ;
      RecordTypes.Add( 'EVOK' ) ;
      RecordTypes.Add( 'MINI' ) ;
      RecordTypes.Add( 'FAIL' ) ;
      RecordTypes.Add( 'TEST' ) ;
      RecordTypes.Add( 'LEAK' ) ;
      RecordTypes.Add( 'TYP1' ) ;
      RecordTypes.Add( 'TYP2' ) ;
      RecordTypes.Add( 'TYP3' ) ;
      RecordTypes.Add( 'TYP4' ) ;

      { Create channel names list }
      ChannelNames := TStringList.Create ;

     { Default values for channels }
     for ch := 0 to MaxChannels-1 do
         begin
         Channel[ch].TimeZero := 1. ;
         Channel[ch].ADCScale := 1. ;
         Channel[ch].CursorIndex := 128 ;
         Channel[ch].ZeroIndex := 0 ;
         Channel[ch].Cursor0 := 0 ;
         Channel[ch].Cursor1 := RawFH.NumSamples div 2 ;
         { Zero levels fixed at hardware zero }
         Channel[ch].ADCZero := 0 ;
         Channel[ch].ADCZeroAt := -1 ;
         Channel[ch].ADCCalibrationFactor := 0.001 ;
         Channel[ch].ADCAmplifierGain := 1. ;
         Channel[ch].ADCUnits := 'mV' ;
         Channel[ch].ADCName := format('Ch.%d',[ch]);
         Channel[ch].color:= clBlue ;
         Channel[ch].xMin := 0. ;
         Channel[ch].xMax := RawfH.NumSamples-1 ;
         Channel[ch].yMin := RawfH.MinADCValue ;
         Channel[ch].yMax := RawfH.MaxADCValue ;
         Channel[ch].InUse := True ;
         end ;

      // Initialise location of main program window
      Main.Top := 20 ;
      Main.Left := 20 ;
      Main.Width := Screen.Width - Main.Left - 20 ;
      Main.Height := Screen.Height - Main.Top - 50 ;

     { Load initialization file to get name of last data file used }
     if not Settings.NoINIFile then WCPFile.LoadInitializationFile( SettingsFileName ) ;

end;


procedure TWCPFile.DataModuleDestroy(Sender: TObject);
// ------------------------------
// Tidy up when form is destroyed
// --------------------------------
begin

        { Close data files }
        WCPFile.CloseAllDataFiles ;

        { Close log file }
        CloseLogFile ;

        { Save initialization file }
        SaveInitializationFile( SettingsFileName ) ;

        RecordTypes.Free ;
        ChannelNames.Free ;

end;

procedure TWCPFile.PutRecord(
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


procedure TWCPFile.PutRecordHeaderOnly(
          var fHDR : TFileHeader;    { Data file header }
          var rH : TRecHeader ;    { Record header }
          RecordNum : Integer ) ;    { Record number }
{ -------------------------------------------------------
  Write a WCP format digital signal record header to file
  -------------------------------------------------------}
var
   cBuf : Array[0..255] of ANSIchar ;
   StartFPtr,EndFptr : Integer ;
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
//     RH.Value[vFitEquation] := Integer(RH.EqnType) ;
  {   RH.Value[vFitCursor0] := RH.FitCursor0 ;
     RH.Value[vFitCursor1] := RH.FitCursor1 ;
     RH.Value[vFitCursor2] := RH.FitCursor2 ;
     RH.Value[vFitChan] := RH.FitChan ;}

     { Write record header block to file }
     StartFPtr := FileSeek( FHDR.FileHandle,
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

     { Write fitted equation data }
     FileWrite( FHDR.FileHandle, rH.EqnType, sizeof(rH.EqnType) ) ;
     FileWrite( FHDR.FileHandle, rH.FitCursor0, sizeof(rH.FitCursor0) ) ;
     FileWrite( FHDR.FileHandle, rH.FitCursor1, sizeof(rH.FitCursor1) ) ;
     FileWrite( FHDR.FileHandle, rH.FitCursor2, sizeof(rH.FitCursor2) ) ;
     FileWrite( FHDR.FileHandle, rH.FitChan, sizeof(rH.FitChan) ) ;

     EndFPtr := FileSeek( FHDR.FileHandle, 0, 1 ) ;
     outputdebugstring(pchar(format('Bytes written to header: %d Space in header: %d',[EndFPtr-StartFPtr,fHDR.NumAnalysisBytesPerRecord])));

     end ;


procedure TWCPFile.GetRecord(
          var fHDR : TFileHeader;      { Data file header }
          var rH : TRecHeader ;        { Record header }
          RecordNum : Integer ;        { Record number }
          var dBuf : Array of SmallInt { A/D data array }
          ) ;
{ --------------------------------------------------
  Read a WCP format digital signal record from file
  --------------------------------------------------}
var
   i,ch,i0,i1,Sum,ChOffset : Integer ;
begin

     { Get record header data and store in analysis block RH }
     GetRecordHeaderOnly( fHDR, RH, RecordNum ) ;

     { Read A/D samples from record data block on file }
     fHDR.RecordNum := RecordNum ;
     fHDR.NumDataBytesPerRecord := fHDR.NumSamples*fHDR.NumChannels*2 ;
     fHDR.NumBytesPerRecord := fHDR.NumDataBytesPerRecord +
                               fHDR.NumAnalysisBytesPerRecord  ;

     { Move file pointer to start of record data block }
     FileSeek( FHDR.FileHandle,
               fHDR.NumBytesInHeader + fHDR.NumBytesPerRecord*(RecordNum-1) + fHDR.NumAnalysisBytesPerRecord,
               0 ) ;

     { Read data block }
     if FileRead( FHDR.FileHandle, dBuf, FHDR.NumDataBytesPerRecord ) <> FHDR.NumDataBytesPerRecord then
        begin
        WriteToLogFilenoDate( format('Error reading file %s, Rec=%d',[fHDR.FileName,fHDR.RecordNum])) ;
        end ;

     {Apply digital filter}
     if Settings.CutOffFrequency > 0.0 then
        GaussianFilter( FHDR, dBuf, Settings.CutOffFrequency ) ;

     { Calculate zero level for each channel }
     for ch := 0 to FHDR.NumChannels - 1 do
         begin
         ChOffset := Channel[Ch].ChannelOffset ;
         if Channel[ch].ADCZeroAt >= 0 then
            begin
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


procedure TWCPFile.GetRecordWCPV8(
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


procedure TWCPFile.GetRecord32(
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


procedure TWCPFile.PutRecord32(
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



procedure TWCPFile.GetRecordHeaderOnly(
          var fHDR : TFileHeader;      { Data file header }
          var rH : TRecHeader ;        { Record header }
          RecordNum : Integer          { Record number }
          ) ;
{ --------------------------------------------------------
  Read a WCP format digital signal record header from file
  --------------------------------------------------------}
var
   ch,i,vStart : Integer ;
   cRecID : array[0..MaxRecordIdentChars-1] of ANSIchar ;
   cStatus : Array[0..MaxRecordStatusChars-1] of ANSIchar ;
   cRecType : Array[0..MaxRecordTypeChars-1] of ANSIchar ;
   OK : Boolean ;
begin

     fHDR.RecordNum := RecordNum ;
     fHDR.NumDataBytesPerRecord := fHDR.NumSamples*fHDR.NumChannels*2 ;
     fHDR.NumBytesPerRecord := fHDR.NumDataBytesPerRecord + fHDR.NumAnalysisBytesPerRecord  ;

     { Move file pointer to start of record header block }
     FileSeek( FHDR.FileHandle,
               (RecordNum-1)*fHDR.NumBytesPerRecord + fHDR.NumBytesInHeader,
               0 ) ;

     { Read record header data }
     FileRead( FHDR.FileHandle, cStatus, SizeOf(cStatus));

     if ANSIContainsText(cStatus,'acce') or ANSIContainsText(cStatus,'reje') then
        begin

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
        for Ch := 0 to FHDR.NumChannels-1 do
            begin
            if (fHDR.Version < 6.0) or (rH.ADCVoltageRange[ch]=0.0) then rH.ADCVoltageRange[ch] := rH.ADCVoltageRange[0] ;
            Channel[ch].ADCScale := CalibFactorToADCScale( RH, ch ) ;
            end ;

        { Read record ident text }
        FileRead( FHDR.FileHandle, cRecID, SizeOf(cRecID) );
        RH.Ident := cRecID ;

        { Read Analysis block }
        FileRead( FHDR.FileHandle, rH.Value,sizeof(single)*Max(FHDR.NumChannels,8)*MaxAnalysisVariables ) ;

        if RH.Value[0] > 0.0 then rH.AnalysisAvailable := True
                             else rH.AnalysisAvailable := False ;

        // Get fitted equation data
        FileRead( FHDR.FileHandle, rH.EqnType, sizeof(rH.EqnType) ) ;
        FileRead( FHDR.FileHandle, rH.FitCursor0, sizeof(rH.FitCursor0) ) ;
        FileRead( FHDR.FileHandle, rH.FitCursor1, sizeof(rH.FitCursor1) ) ;
        FileRead( FHDR.FileHandle, rH.FitCursor2, sizeof(rH.FitCursor2) ) ;
        FileRead( FHDR.FileHandle, rH.FitChan, sizeof(rH.FitChan) ) ;
        RH.FitPar0 := vFitPar ;
     {   RH.FitCursor0 := Min(Max(Round(RH.Value[vFitCursor0]),0),FHDR.NumSamples-1) ;
        RH.FitCursor1 := Min(Max(Round(RH.Value[vFitCursor1]),0),FHDR.NumSamples-1) ;
        RH.FitCursor2 := Min(Max(Round(RH.Value[vFitCursor2]),0),FHDR.NumSamples-1) ;
        RH.FitChan := Min(Max(Round(RH.Value[vFitChan]),0), FHDR.NumChannels-1) ;}

        // Copy record number,group,time into Values array
        vStart := 0 ;
        for Ch := 0 to FHDR.NumChannels-1 do
            begin
            // Copy record details into values array
            RH.Value[vStart+vRecord] := FHDR.RecordNum ;
            RH.Value[vStart+vTime] := RH.Time ;
            RH.Value[vStart+vTimeofDay] := RH.Time + FHDR.RecordingStartTimeSecs ;
            RH.Value[vStart+vGroup] := RH.Number ;
            vStart := vStart + MaxAnalysisVariables ;
            end ;

        end
     else begin
        // Invalid analysis block - Fill record with default values
        rH.Status := 'ACCE' ;
        rH.RecType := 'TEST' ;
        rH.Number := RecordNum ;
        rH.dt := fHDR.dt ;
        rH.Time := (fHDR.NumSamples*rH.dt)*(rH.Number-1.0) ;
        rH.Ident := 'Error' ;
        for Ch := 0 to FHDR.NumChannels-1 do
            begin
            RH.ADCVoltageRange[ch] := fHDR.ADCVoltageRange ;
            Channel[ch].ADCScale := CalibFactorToADCScale( RH, ch ) ;
            end ;

        rH.AnalysisAvailable := False ;
        for i := 0 to High(RH.Value) do RH.Value[i] := 0.0 ;

        // Save changes to file
        PutRecordHeaderOnly( fHDR, RH, RecordNum ) ;

        end ;

     end ;


procedure TWCPFile.GetRecordHeaderOnlyWCPV8(
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


function TWCPFile.CalibFactorToADCScale(
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

function TWCPFile.NumAnalysisBytesPerRecord(
         NumChannels : Integer ) : Integer ;
begin
     Result := (((NumChannels-1) div 8)+1)*1024 ;
     end ;

function TWCPFile.NumBytesInFileHeader(
         NumChannels : Integer ) : Integer ;
begin
     Result := (((NumChannels-1) div 8)+1)*1024 ;
     end ;


procedure TWCPFile.OpenLogFile ;
{ -------------
  Open log file
  ------------- }
begin

     { Create a log file using current date }
    {$IF CompilerVersion > 7.0} formatsettings.DateSeparator := '-';
     {$ELSE} DateSeparator := '-';
     {$IFEND}

     LogFileName := SettingsDirectory + DateToStr(Date)+'.log' ;
     LogFileAvailable := True ;
     AssignFile( LogFile, LogFileName ) ;
     try
           if FileExists( LogFileName ) then Append(LogFile)
                                        else ReWrite(LogFile) ;
     except
           on EInOutError do begin
              //MessageDlg( ' WinWCP - Cannot create Log File', mtWarning, [mbOK], 0 ) ;
              LogFileAvailable := False ;
              end ;
           end ;

     end ;


procedure TWCPFile.WriteToLogFile( Line : string ) ;
{ ---------------------------------------------
  Write a date-stamped line of text to log file
  --------------------------------------------- }
begin
     if LogFileAvailable then WriteLn( LogFile, TimeToStr(Time) + ' ' + Line ) ;
     end ;


procedure TWCPFile.WriteToLogFileNoDate( Line : string ) ;
{ --------------------------------
  Write a line of text to log file
  -------------------------------- }
begin
     if LogFileAvailable then WriteLn( LogFile, Line ) ;
     end ;


procedure TWCPFile.CloseLogFile ;
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


procedure TWCPFile.GaussianFilter(
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
   i,i1,j,j1,nc,Ch : Integer ;
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
//             ChOffset := GetChannelOffset(Ch,FHdr.NumChannels) ;
             i1 := Ch ;
             EndOfData := FHdr.NumSamples -1 ;
             for i := 0 to EndOfData do begin
	         sum := 0. ;
	         for j := -nc to nc do begin
                     j1 := j+i ;
                     if j1 < 0 then j1 := 0 ;
                     if j1 > EndofData then j1 := EndofData ;
                     j1 := j1*FHdr.NumChannels + Ch ;
	             sum := sum + (Work^[j1])*a[j] ;
                     end ;
                 Buf[i1] := Trunc(sum) ;
                 i1 := i1 + FHdr.NumChannels ;
                 end ;
             end ;

      Dispose(Work) ;

      end ;

procedure TWCPFile.UpdateFileHeaderBlocks ;
{ --------------------------------------------------------------------
  Update original copies of file header blocks when changed made to FH
  --------------------------------------------------------------------}
begin
       if FH.FileName = RawFH.FileName then RawFH := FH
       else if FH.FileName = AvgFH.FileName then AvgFH := FH
       else if FH.FileName = LeakFH.FileName then LeakFH := FH
       else if FH.FileName = DrvFH.FileName then DrvFH := FH ;
       end ;


procedure TWCPFile.DeleteRecord ;
{ - Menu Item -----------------------------------------------
  Delete a signal record from the data file
  31/5/98 File header blocks updated when a record is deleted
  -----------------------------------------------------------}
var
   RH : TRecHeader ;
   i,iDelete : Integer ;
   TempFH : TFileHeader ;
   ADC : ^TSmallIntArray ;
   OK : Boolean ;
begin
    OK := True ;
    New(ADC) ;

    try

       OK := True ;
       { Create temporary file }
       if OK then begin
          TempFH := FH ;
          TempFH.FileName := ChangeFileExt( FH.FileName, '.tmp' ) ;
          TempFH.FileHandle := FileCreate( TempFH.FileName ) ;
          if TempFH.FileHandle < 0 then begin
             ShowMessage( ' Unable to open ' + TempFH.FileName ) ;
             OK := False ;
             end ;
          end ;

       { Copy all records except the current one to the temp. file }
       if OK then begin
          TempFH.NumRecords := 0 ;
          iDelete := FH.RecordNum ;
          for i := 1 to FH.NumRecords do begin
              GetRecord(FH,RH,i,ADC^) ;
              if i <> iDelete then begin
                 Inc(TempFH.NumRecords) ;
                 PutRecord(TempFH,RH,TempFH.NumRecords,ADC^) ;
                 end ;
              end ;
         SaveHeader( TempFH ) ;

          { Close temporary and original file }
          FileCloseSafe( TempFH.FileHandle) ;
          FileCloseSafe( FH.FileHandle ) ;

          { Delete original file }
          DeleteFile( PChar(FH.FileName) ) ;
          { Rename temp. file }
          if not RenameFile( TempFH.FileName, FH.FileName ) then
             ShowMessage( ' Renaming of' + TempFH.FileName + ' failed' ) ;
          { Re-open file }
          FH.FileHandle := FileOpen( FH.FileName, fmOpenReadWrite  or fmShareDenyWrite) ;
          GetHeader( FH ) ;

          { Update data file header (added 31/5/98) }
          UpdateFileHeaderBlocks ;
          // Display next record after deleted
          FH.RecordNum := Min(iDelete,FH.NumRecords) ;
          { Refresh child windows }
          Main.UpdateMDIWindows ;

          end ;

       finally
          Dispose(ADC) ;
          end ;
    end ;



procedure TWCPFile.DeleteRejected ;
{ - Menu Item ------------------------------
  Delete rejected records from the data file
  ------------------------------------------}
var
   i : Integer ;
   TempFH : TFileHeader ;
   RH : TRecHeader ;
   ADC : ^TSmallIntArray ;
   OK : Boolean ;
begin

     OK := True ;
     New(ADC) ;

     try
         OK := True ;
        if OK then begin
           { Create temporary file }
           TempFH := FH ;
           TempFH.FileName := ChangeFileExt( FH.FileName, '.tmp' ) ;
           TempFH.FileHandle := FileCreate( TempFH.FileName ) ;
           if TempFH.FileHandle < 0 then begin
              ShowMessage( ' Unable to open ' + TempFH.FileName ) ;
              OK := False ;
              end ;
          end ;

        { Copy all records except rejected one to the temp. file }
        if OK then begin
           TempFH.NumRecords := 0 ;
           for i := 1 to FH.NumRecords do begin
               GetRecord(FH,RH,i,ADC^) ;
               if RH.Status = 'ACCEPTED' then begin
                  Inc(TempFH.NumRecords) ;
                  PutRecord(TempFH,RH,TempFH.NumRecords,ADC^) ;
                  end ;
               end ;
           SaveHeader( TempFH ) ;

           { Close temporary and original file }
           FileCloseSafe( TempFH.FileHandle) ;
           FileCloseSafe( FH.FileHandle ) ;
           { Delete original file }
           DeleteFile( PChar(FH.FileName) ) ;

           { Rename temp. file }
           if not RenameFile( PChar(TempFH.FileName), FH.FileName ) then
              ShowMessage( ' Renaming of' + TempFH.FileName + ' failed' ) ;

           { Re-open file }
           FH.FileHandle := FileOpen( FH.FileName, fmOpenReadWrite  or fmShareDenyWrite) ;
           GetHeader( FH ) ;

           { Update file header blocks with changes made to FH }
           UpdateFileHeaderBlocks ;

           end ;

     finally
        Dispose(ADC) ;
        end ;
     end;


procedure TWCPFile.LoadDataFiles( FileName : string ) ;
{ -------------------------------------------------
  Load .WCP and any associated .AVG,.SUB data files
  -------------------------------------------------}
var
   ch : Integer ;
begin

     { Close existing data file(s) }
     CloseAllDataFiles ;

     { Open original 'raw' data file }
     if not OpenAssociateFile(RawFH,FileName,'.wcp') then Exit ;

     // Select raw for display
     FH := RawFH ;

     Main.Caption := 'WinWCP : ' + WCPFile.RawFH.FileName ;
     { Save data directory }
     Settings.DataDirectory := ExtractFilePath( RawFH.FileName ) ;

     { Open averages file (if one exists)}
     OpenAssociateFile(AvgFH,FileName,'.avg') ;

     {Open a leak subtracted file (if one exists) }
     OpenAssociateFile(LeakFH,FileName,'.sub') ;

     { Open a driving function file (if one exists) }
     OpenAssociateFile(DrvFH,FileName,'.dfn') ;

     { Make sure all channels are visible }
     for ch := 0 to RawFH.NumChannels-1 do Channel[ch].InUse := True ;

     { Open view form if one doesn't exist }
//     if (RawfH.NumRecords > 0) and not FormExists('ReplayFrm') then
//        ReplayFrm := TReplayFrm.Create(Self) ;

     { Inform all open forms that data file(s) have changed }
     Main.NewFileUpdate ;

     { Set display magnification to minimum }
     if WCPFile.fH.NumRecords > 0 then begin
        //if OldNumSamples <> RawFH.NumSamples then mnZoomOut.Click ;
        Main.mnShowRaw.Click ;
        end ;

     Main.SetMenus ;

     end ;


function TWCPFile.OpenAssociateFile(
         var FileHeader : TFileHeader ;  { File header of this file }
         const FileName : string ;       { Name of data file }
         const FileExtension : string    { Extension to be added }
         ) : boolean ;                   { =True if file opened succcessfully }
{ -------------------------------------
  Open an associated file (if it exists)
  -------------------------------------}
var
   OK : Boolean ;
begin

     Result := False ;

     { Close existing file }
     FileCloseSafe( FileHeader.FileHandle ) ;

     { Check that file exists }
     FileHeader.FileName := ChangeFileExt( FileName, FileExtension ) ;
     if not FileExists( FileHeader.FileName ) then Exit ;

     { Open file }
     FileHeader.FileHandle := FileOpen( FileHeader.FileName, fmOpenReadWrite or fmShareDenyWrite) ;
     if FileHeader.FileHandle < 0 then Exit ;

     { Load the data file details }
     GetHeader( FileHeader ) ;

     { If it is an old file format convert it to new format }

     if (FileHeader.NumAnalysisBytesPerRecord < 1024 ) or
        (FileHeader.NumBytesInHeader < 1024) then begin
        // Convert pre WCP V6.2 to V9 format
        FileCloseSafe( FileHeader.FileHandle ) ;
        OK := ConvertWCPPreV62toV9(FileHeader.FileName) ;
        if OK then begin
           FileHeader.FileHandle := FileOpen(FileHeader.FileName,fmOpenReadWrite or fmShareDenyWrite) ;
           GetHeader( FileHeader ) ;
           end
        else Exit ;
        end
     else if FileHeader.Version < 9.0 then begin
        // Convert WCP V6.2 - V8 to V9 format
        FileCloseSafe( FileHeader.FileHandle ) ;
        OK := ConvertWCPV8toV9(FileHeader.FileName) ;
        if OK then begin
           FileHeader.FileHandle := FileOpen(FileHeader.FileName,fmOpenReadWrite or fmShareDenyWrite) ;
           GetHeader( FileHeader ) ;
           end
        else Exit ;
        end ;

     Result := True ;

     end ;



procedure TWCPFile.CloseAllDataFiles ;
{ -------------------------
  Close all open data files
  -------------------------}
begin

     if  RawFH.FileHandle >= 0 then begin
         { Close raw data file }
         FileCloseSafe( RawFH.FileHandle) ;
         end ;

     { Close averages file }
     FileCloseSafe( AvgFH.FileHandle) ;

     { Close leak subtracted file }
     FileCloseSafe( LeakFH.FileHandle) ;

     { Close driving function file }
     FileCloseSafe( DrvFH.FileHandle) ;

     end ;



procedure TWCPFile.FileCloseSafe( var FileHandle : Integer ) ;
// -------------------------
// Safe close file procedure
// -------------------------
begin
     // Close file (if it is open)
     if FileHandle >= 0 then FileClose( FileHandle ) ;
     // File handle = -1 indicates closed file
     FileHandle := -1 ;
     end ;


procedure TWCPFile.UpdateChannelScalingFactors(
          var RH : TRecHeader ) ;
// ------------------------------
// Update channel scaling factors
// ------------------------------
var
   ch : Integer ;
begin
     for ch := 0 to WCPFile.RawFH.NumChannels-1 do begin

         // Ensure that calibration factor is non-zero
         if Channel[ch].ADCCalibrationFactor = 0.0 then
            Channel[ch].ADCCalibrationFactor := 0.001 ;

         // Calculate bits->units scaling factor
         Channel[ch].ADCScale := Abs(RH.ADCVoltageRange[ch]) /
                                (Channel[ch].ADCCalibrationFactor
                                 *(Main.SESLabIO.ADCMaxValue+1) ) ;
         end ;
     end ;



function TWCPFile.FileOverwriteCheck(
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


Function TWCPFile.AppendWCPfile(
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
   KeepChannel : Array[0..MaxChannels-1] of TChannel ;
   YScale : Array[0..MaxChannels-1] of Single ;
   ScaleFrom,ScaleTo : Single ;
   AppFH : TFileHeader ;
   s : string ;
begin
     { Create buffers }
     Result := False ;
     New(RecHeader) ;
     New(Buf) ;

     { Save signal channel settings for currently open file }
     for ch := 0 to WCPFile.RawFH.NumChannels-1 do KeepChannel[ch] := Channel[ch] ;

     { Open file to be appended }
     AppFH.FileName := FileName ;
     AppFH.FileHandle := FileOpen( AppFH.FileName, fmOpenReadWrite ) ;
     if AppFH.FileHandle < 0 then begin
        MessageDlg( 'Unable to append ' + FileName,mtWarning, [mbOK], 0 ) ;
        Exit ;
        end ;

     WCPFile.GetHeader( AppFH ) ;
     if (AppFH.NumSamples <> WCPFile.RawFH.NumSamples)
        or (AppFH.NumChannels <> WCPFile.RawFH.NumChannels ) then begin
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
     StartAt := WCPFile.RawFH.NumRecords + 1 ;
     for Rec := 1 to AppFH.NumRecords do begin

         { Read from source file }
         WCPFile.GetRecord( AppfH, RecHeader^, Rec, Buf^ ) ;
         { Re-scale calibration }
         for ch := 0 to AppFH.NumChannels-1 do
             RecHeader^.ADCVoltageRange[ch] := RecHeader^.ADCVoltageRange[ch] *YScale[ch] ;

         { Write to destination file }
         if RecHeader^.Status = 'ACCEPTED' then begin
            Inc( WCPFile.RawFH.NumRecords ) ;
            WCPFile.PutRecord( WCPFile.RawFH, RecHeader^, WCPFile.RawFH.NumRecords, Buf^ ) ;
            end ;

         // Report progress
         Main.StatusBar.SimpleText := format(
                                      'Appending records %d/%d from %s',
                                      [Rec,AppFH.NumRecords,FileName] ) ;

         end ;


     s := AppFH.FileName + ' appended to ' + WCPFile.RawFH.FileName ;
     Main.StatusBar.SimpleText := s ;
     WriteToLogFile( s ) ;
     WriteToLogFile( format( 'Records %d - %d added (%d)',
                     [StartAt,WCPFile.RawFH.NumRecords,WCPFile.RawFH.NumRecords-StartAt+1]));

     { Update destination file header }
     WCPFile.SaveHeader( WCPFile.RawFH ) ;

     { Restore signal channel settings for currently open file }
     for ch := 0 to WCPFile.RawFH.NumChannels-1 do Channel[ch] := KeepChannel[ch] ;

     // Dispose of buffers }
     Dispose(RecHeader) ;
     Dispose(Buf) ;
     { Close source file }
     FileCloseSafe( AppFH.FileHandle ) ;

     Result := True ;

     end ;


Function TWCPFile.InterleaveWCPfile(
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
     if FileExists(In2FH.FileName) then DeleteFile(PChar(In2FH.FileName)) ;
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
            PutRecord( RawFH, RecHeader2^, RawFH.NumRecords, Buf2^ ) ;
            Inc( RawFH.NumRecords ) ;
            RecHeader1^.Number := GroupNum ;
            // Make records from #1 file TEST
            RecHeader1^.RecType := 'LEAK' ;
            PutRecord( RawFH, RecHeader1^, RawFH.NumRecords, Buf1^ ) ;
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


function TWCPFile.ConvertWCPPreV62toV9(
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
     WCPFile.GetHeader( InFH ) ;

     { Check for WinWCP V3.0 files which have incorrect file version and prevent conversion }
     if (InFH.Version < 6.2) then begin
        BinaryData := False ;
        OffsetBinaryData := False ;
        for Rec := 1 to InFH.NumRecords do begin
            WCPFile.GetRecord( InFH, RH, Rec, Buf^ ) ;
            for i := 0 to (Round(InFH.NumDataBytesPerRecord) div 2)-1 do begin
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
     OutFH.NumBytesInHeader := NumBytesInFileHeader(InFH.NumChannels) ;
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
         WCPFile.GetRecord( InFH, RH, Rec, Buf^ ) ;

         for ChOut := 0 to InFH.NumChannels-1 do begin
             { Keep input channel within old limits }
             ChIn := Min(ChOut,OldChannelLimit) ;
             { A/D converter voltage range for channel }
             RH.ADCVoltageRange[ChOut] := RH.ADCVoltageRange[ChIn] ;
             { Ensure that voltage range has a valid setting }
             if RH.ADCVoltageRange[ChOut] <= 0.0 then
                RH.ADCVoltageRange[ChOut] := RH.ADCVoltageRange[0] ;
             end ;

         // Differences between old and new equations prevent
         // the equation being carried over from the old format
         RH.AnalysisAvailable := False ;
         RH.EqnType := None ; // Value[vFitEquation] := 0.0 ;

         { Write data to new record }
         Inc( OutFH.NumRecords ) ;
         { Subtract 2048 offset that was added to WCP data previous to V8.0 }
         if InFH.Version < 8.0 then begin
            for i := 0 to (Round(OutFH.NumDataBytesPerRecord) div 2)-1 do
                Buf^[i] := Buf^[i] - 2048 ;
            RH.dt := RH.dt*0.001 ;
            end ;

         WCPFile.PutRecord( OutFH, RH, OutFH.NumRecords, Buf^ ) ;

         // Report progress
         Main.StatusBar.SimpleText := format(
                                      'Converted %s to WinWCP V3.x format %d/%d',
                                      [FileName,Rec,InFH.NumRecords] ) ;

         end ;

     { Save file header and close files }
     WCPFile.SaveHeader( OutFH ) ;

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
        else DeleteFile( PChar(FileName) ) ;
        end
     else begin
        { Delete other auxiliary files }
        DeleteFile( PCHar(FileName) ) ;
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


function TWCPFile.ConvertWCPV8toV9(
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
     WCPFile.GetHeader( InFH ) ;

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
         WCPFile.GetRecordWCPV8( InFH, RH, Rec, Buf^ ) ;

         for ChOut := 0 to InFH.NumChannels-1 do begin
             { Keep input channel within old limits }
             ChIn := Min(ChOut,OldChannelLimit) ;
             { A/D converter voltage range for channel }
             RH.ADCVoltageRange[ChOut] := RH.ADCVoltageRange[ChIn] ;
             { Ensure that voltage range has a valid setting }
             if RH.ADCVoltageRange[ChOut] <= 0.0 then
                RH.ADCVoltageRange[ChOut] := RH.ADCVoltageRange[0] ;
             end ;

         // Differences between old and new equations prevent
         // the equation being carried over from the old format
         RH.AnalysisAvailable := False ;
         RH.EqnType := None ; //RH.Value[vFitEquation] := 0.0 ;

         { Write data to new record }
         Inc( OutFH.NumRecords ) ;

         WCPFile.PutRecord( OutFH, RH, OutFH.NumRecords, Buf^ ) ;

         // Report progress
         Main.StatusBar.SimpleText := format(
                                      'Converted %s to WCP V9.0 format %d/%d',
                                      [FileName,Rec,InFH.NumRecords] ) ;

         end ;

     { Save file header and close files }
     WCPFile.SaveHeader( OutFH ) ;

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
        else DeleteFile( PChar(FileName) ) ;
        end
     else begin
        { Delete other auxiliary files }
        DeleteFile( PChar(FileName) ) ;
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


function TWCPFile.GetKeyValue( List : TStringList ;  // List for Key=Value pairs
                               KeyWord : string ;   // Key
                               Value : single       // Value
                               ) : Single ;         // Return value
// ------------------------------
// Get Key=Single Value from List
// ------------------------------
var
    istart,idx : Integer ;
    s : string ;
begin

     // Remove any '=' in keyword
     Keyword := ReplaceText( Keyword, '=', '' ) ;

     idx := List.IndexOfName( Keyword ) ;
     if idx >= 0 then
        begin
        s := List[idx] ;
        // Find key=value separator and remove key
        istart := Pos( '=', s ) ;
        if istart > 0 then Delete( s, 1, istart ) ;
        Result := ExtractFloat( s, Value ) ;
        end
     else Result := Value ;

end;


function TWCPFile.GetKeyValue( List : TStringList ;  // List for Key=Value pairs
                               KeyWord : string ;   // Key
                               Value : Integer       // Value
                               ) : Integer ;        // Return value
// ------------------------------
// Get Key=Integer Value from List
// ------------------------------
var
    istart,idx : Integer ;
    s : string ;
begin

     // Remove any '=' in keyword
     Keyword := ReplaceText( Keyword, '=', '' ) ;

     idx := List.IndexOfName( Keyword ) ;
     if idx >= 0 then
        begin
        s := List[idx] ;
        // Find key=value separator and remove key
        istart := Pos( '=', s ) ;
        if istart > 0 then Delete( s, 1, istart ) ;
        Result := STrToInt( s ) ;
        end
     else Result := Value ;

end;


function TWCPFile.GetKeyValue( List : TStringList ;  // List for Key=Value pairs
                               KeyWord : string ;   // Key
                               Value : NativeInt       // Value
                               ) : NativeInt ;        // Return value
// ------------------------------
// Get Key=Integer Value from List
// ------------------------------
var
    istart,idx : Integer ;
    s : string ;
begin

     // Remove any '=' in keyword
     Keyword := ReplaceText( Keyword, '=', '' ) ;

     idx := List.IndexOfName( Keyword ) ;
     if idx >= 0 then
        begin
        s := List[idx] ;
        // Find key=value separator and remove key
        istart := Pos( '=', s ) ;
        if istart > 0 then Delete( s, 1, istart ) ;
        Result := STrToInt( s ) ;
        end
     else Result := Value ;

end;


function TWCPFile.GetKeyValue( List : TStringList ;  // List for Key=Value pairs
                               KeyWord : string ;   // Key
                               Value : string       // Value
                               ) : string ;        // Return value
// ------------------------------
// Get Key=Integer Value from List
// ------------------------------
var
    istart,idx : Integer ;
    s : string ;
begin

     // Remove any '=' in keyword
     Keyword := ReplaceText( Keyword, '=', '' ) ;

      idx := List.IndexOfName( Keyword ) ;
     if idx >= 0 then
        begin
        s := List[idx] ;
        // Find key=value separator and remove key
        istart := Pos( '=', s ) ;
        if istart > 0 then Delete( s, 1, istart ) ;
        Result := s ;
        end
     else Result := Value ;

end;


function TWCPFile.GetKeyValue( List : TStringList ;  // List for Key=Value pairs
                               KeyWord : string ;   // Key
                               Value : Boolean       // Value
                               ) : Boolean ;        // Return value
// ------------------------------
// Get Key=Boolean Value from List
// ------------------------------
var
    istart,idx : Integer ;
    s : string ;
begin

     // Remove any '=' in keyword
     Keyword := ReplaceText( Keyword, '=', '' ) ;

     idx := List.IndexOfName( Keyword ) ;
     if idx >= 0 then
        begin
        s := List[idx] ;
        // Find key=value separator and remove key
        istart := Pos( '=', s ) ;
        if istart > 0 then Delete( s, 1, istart ) ;
        if ContainsText(s,'T') then Result := True
                               else Result := False ;
        end
     else Result := Value ;

end;



function TWCPFile.ExtractFloat ( CBuf : string ; Default : Single ) : extended ;
{ Extract a floating point number from a string which
  may contain additional non-numeric text }

var CNum : string ;
i : SmallInt ;

begin
     CNum := ' ' ;
     for i := 1 to length(CBuf) do begin
         if CharInSet( CBuf[i], ['0'..'9', 'E', 'e', '+', '-', '.', ',' ] ) then
            CNum := CNum + CBuf[i]
         else CNum := CNum + ' ' ;
         end ;

     { Correct for use of comma/period as decimal separator }
     if (formatsettings.DECIMALSEPARATOR = '.') and (Pos(',',CNum) <> 0) then
        CNum[Pos(',',CNum)] := formatsettings.DECIMALSEPARATOR ;
     if (formatsettings.DECIMALSEPARATOR = ',') and (Pos('.',CNum) <> 0) then
        CNum[Pos('.',CNum)] := formatsettings.DECIMALSEPARATOR ;

     try
        ExtractFloat := StrToFloat( CNum ) ;
     except
        on E : EConvertError do ExtractFloat := Default ;
        end ;
     end ;

function TWCPFile.ExtractInt ( CBuf : string ) : longint ;
{ Extract a 32 bit integer number from a string which
  may contain additional non-numeric text }
Type
    TState = (RemoveLeadingWhiteSpace, ReadNumber) ;
var
   CNum : string ;
   i : integer ;
   Quit : Boolean ;
   State : TState ;

begin
     CNum := '' ;
     i := 1;
     Quit := False ;
     State := RemoveLeadingWhiteSpace ;
     while not Quit do begin

           case State of

           { Ignore all non-numeric ansicharacters before number }
           RemoveLeadingWhiteSpace : begin
               if CharInSet( CBuf[i], ['0'..'9','E','e','+','-','.'] ) then State := ReadNumber
                                                            else i := i + 1 ;
               end ;

           { Copy number into string CNum }
           ReadNumber : begin
                { End copying when a non-numeric ansicharacter
                or the end of the string is encountered }
                if CharInSet( CBuf[i], ['0'..'9','E','e','+','-','.'] ) then begin
                   CNum := CNum + CBuf[i] ;
                   i := i + 1 ;
                   end
                else Quit := True ;
                end ;
           else end ;

           if i > Length(CBuf) then Quit := True ;
           end ;
     try
        ExtractInt := StrToInt( CNum ) ;
     except
        ExtractInt := 1 ;
        end ;
     end ;


function TWCPFile.ANSIArrayToString(
         const CharArray : Array of ANSIChar
         ) : string ;
// --------------------------------------
// Copy ANSI character array to string
// --------------------------------------
var
   i : Integer ;
   s : string ;
begin
     s := '' ;
     for i := 0 to High(CharArray) do
         begin
         if CharArray[i] = #0 then break ;
         s := s + CharArray[i] ;
         end ;
     Result := s ;
     end ;


function TWCPFile.CopyStringToANSIArray(
         var Dest : array of ANSIChar ; // Destination to append to
         Source : string                // Source to copy from
         ) : Boolean ;                  // TRUE = append successful
{ Copy a string variable to character array
  NOTE. array MUST have been filled with 0 characters before
        using the function }
var
   i : Integer ;
begin

     // Set to #0
     FillChar( Dest, High(Dest)+1,0) ;

     for i := 1 to Min( Length(Source),High(Dest)+1) do begin
         Dest[i-1] := ANSIChar(Source[i]) ;
         end ;
     if Length(Source) <= (High(Dest)+1) then Result := True
                                         else  Result := False ;
     end ;


procedure TWCPFile.CopyANSIArrayToString(
          var Dest : string ;
          var Source : array of ANSIchar ) ;
var
   i : Integer ;
begin
     Dest := '' ;
     for i := 0 to High(Source) do begin
         if Source[i] = #0 then break ;
         Dest := Dest + Source[i] ;
         end ;
     end ;


function TWCPFile.AppendStringToANSIArray(
         var Dest : array of ANSIChar ; // Destination to append to
         Source : string                // Source to copy from
         ) : Boolean ;                  // TRUE = append successful
{ Copy a string variable to character array
  NOTE. array MUST have been filled with 0 characters before
        using the function }

var
   i,j : Integer ;
begin

     { Find end of character array }
     j := 0 ;
     while (Dest[j] <> #0) and (j < High(Dest) ) do Inc(j) ;

     // Append Source to end
     if (j + length(Source)) < High(Dest) then begin
          for i := 1 to length(Source) do begin
               Dest[j] := ANSIChar(Source[i]) ;
               Inc(j) ;
               end ;
          Result := True ;
          end
     else begin
//         HeaderArrayFull := True ;
         Result := False ;
         end ;

     end ;


function TWCPFile.GetSpecialFolder(const ASpecialFolderID: Integer): string;
// --------------------------
// Get Windows special folder
// --------------------------
var
  //vSFolder :  pItemIDList;
  vSpecialPath : array[0..MAX_PATH] of Char;
begin

    SHGetFolderPath( 0, ASpecialFolderID, 0,0,vSpecialPath) ;
//  SHGetSpecialFolderLocation(0, ASpecialFolderID, vSFolder);

//  SHGetPathFromIDList(vSFolder, vSpecialPath);

  Result := StrPas(vSpecialPath);

  end;


function TWCPFile.ExtractFileNameOnly( FilePath : string ) : string ;
{ -----------------------------------------------------
  Extract file name (without extension) from file path
  ----------------------------------------------------}
var
   FileName : string ;
   FileExt : string[6] ;
begin
     FileName := ExtractFileName(FilePath) ;
     FileExt := ExtractFileExt(FileName) ;
     Delete( FileName,Pos(FileExt,FileName),Length(FileExt) ) ;
     ExtractFileNameOnly := FileName ;
     end ;

procedure TWCPFile.UpdateScrollBar(
          SB : TScrollBar ;
          Value : Integer ;
          LoLimit : Integer ;
          HiLimit : Integer
          ) ;
{ ----------------------------------
  Set scroll bar position and limits
  ---------------------------------- }
begin

        if Value > HiLimit then Value := HiLimit ;
        if Value < LoLimit then Value := LoLimit ;
        SB.Max := High(HiLimit) ;
        SB.Min := 0 ;
        SB.Max := HiLimit ;
        SB.Min := LoLimit ;
        SB.Enabled := True ;
        SB.Position := Value ;
        end ;



end.
