unit Global;
{ =========================
  WinWCP - Global variables
  4/12/01 MaxTBuf increased to 32767
  =========================
  12/2/03 vt50 changed to vtDecay
  30/11/04 MaxTBuf increased to 131071
  07/12/9 ... Non-stationary variance settings added to WCP file header
  24/3/10 ... Now supports 128 channels, file and record headers increased to 10Kbytes byte
  22/8/11 ... Settings.NumHorizontalGridLines & NumVerticalGridLines removed
  02/10/15 .. ZapAmplitude & ZapDuration added to TSealTest
  28/02/17 .. On line analysis settings for RecPlotFrm now stored in Settings.RecPlot and saved in INI file
              vQuantile measurement variable added
  12/08/19 .. vAbsArea measurement variable added
}

interface

uses sysUtils, Graphics, Classes, maths, wintypes, seslabio ;

const
     FileVersion = 9.0 ;                 // Increased from 8.0 to 9.0 4/3/10
     DataFileExtension = '.WCP' ;
     Enable = True ;
     Disable = False ;
     MinDT = 1.5E-5 ;
     WCPMaxChannels = 128 ;
//     MaxAnalysisBytesPerRecord = 10240 ; // Increased from 1024 to 10240 24/3/10
     MaxBytesInFileHeader = 10240 ;      // Increased from 1024 to 10240 24/3/10

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
     LastMeasureVariable = 16 ;

     // Curve fitting variable
     vFitEquation = LastMeasureVariable+1 ;
     vFitChan = LastMeasureVariable+2 ;
     vFitCursor0 =  LastMeasureVariable+3 ;
     vFitCursor1 = LastMeasureVariable+4 ;
     vFitCursor2 = LastMeasureVariable+5 ;
     vFitResSD = LastMeasureVariable+6 ;
     vFitNumIterations = LastMeasureVariable+7 ;
     vFitDegF = LastMeasureVariable+8 ;
     vFitAvg = LastMeasureVariable+9 ;
     vFitPar = LastMeasureVariable+10 ;
     vFitParSD = LastMeasureVariable+11 ;

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
    TDestination = (ToPrinter,ToClipboard) ;

    TADCRange = string[20] ;

// Data record header block (Updated 6/5/10)
TRecHeader = packed record
           Status : String ;
           RecType : String ;
           Number : Single ;
           Time : Single ;
           dt : Single ;
           ADCVoltageRange : array[0..WCPMaxChannels-1] of Single ;
           Ident : string ;
           Value : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
           EqnType : TEqnType ;
           FitCursor0 : Integer ;
           FitCursor1 : Integer ;
           FitCursor2 : Integer ;
           FitChan : Integer ;
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
            PeakMode : Integer ;                    // Peak measurement mode
            RateOfRiseMode : Integer ;              // Rate of rise measurement mode
            NumPointsAveragedAtPeak : Integer ;     // No. of sample point averaged at peak
            RiseTimeLo : Single ;                   // Rise time lower limit (fraction of peak)
            RiseTimeHi : Single ;                   // Rise time upper limit (fraction of peak)
            QuantilePercentage : Single ;           // Quantile % value
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

    { Histogram record }
    TBin = record
         Lo : Single ;
         Mid : Single ;
         Hi :  Single ;
         y : Single ;
         end ;

THistogram = class(TObject)
              StartAt : LongInt ;
              EndAt : LongInt ;
              RecordStart : LongInt ;
              RangeLo : single ;
              RangeHi : Single ;
              NumBins : Integer ;
              NumLogBinsPerDecade : Integer ;
              MaxBin : Integer ;
              Bins : Array[0..2048] of TBin ;
              TotalCount : single ;
              Available : Boolean ;
            {  Equation : TEquation ;}
{              UnitCursor : THistCursorPos ;}
              yHi : Single ;
              BinWidth : single ;
              BinScale : single ;
              TMin : single ;
              NewPlot : Boolean ;
              end ;


TAxis = record
      Lo : Single ;
      Hi : Single ;
      Lo1 : Single ;
      Hi1 : Single ;
      Tic : Single ;
      Min : Single ;
      Max : single ;
      Position : LongInt ;
      Scale : single ;
      Log : Boolean ;
      Lab : string ;
      AutoRange : Boolean ;
      end ;

TPlot = record
      Left : LongInt ;
      Right : LongInt ;
      Top : LongInt ;
      Bottom : LongInt ;
      XAxis : TAxis ;
      YAxis : TAxis ;
      Title : string ;
      FontName : string ;
      FontSize : LongInt ;
      NumGraphs : LongInt ;
      BinBorders : Boolean ;
      BinFillStyle : TBrushStyle ;
      BinFillColor : TColor ;
      LineThickness : LongInt ;
      MarkerSize : LongInt ;
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
          BarValue : array[0..WCPMaxChannels-1] of single ;
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

          end ;


TBuf = class(TObject)
     Buf : array[0..MaxADCSamples-1] of Integer ;
     end ;

Txy = record
    x : Single ;
    y : Single ;
    end ;

TMarkerShape = ( SquareMarker, CircleMarker ) ;
TxyBuf = class(TObject)
         NumPoints : LongInt ;
         x : array[0..6000] of Single ;
         y : array[0..6000] of Single ;
         MarkerShape : TMarkerShape ;
         MarkerSize : LongInt ;
         MarkerSolid : Boolean ;
         Color : TColor ;
         end ;


THistBuf = class(TObject)
         NumBins : LongInt ;
         Bin : array[0..1000] of TBin ;
         yHi : Single ;
         BinWidth : Single ;
         end ;

{ Global Variables }
var
ProgVersion : string ;
fH : TFileHeader ;
RawfH : TFileHeader ;
AvgfH : TFileHeader ;
LeakfH : TFileHeader ;
DrvFH : TFileHeader ;
HeaderArrayFull : Boolean ;     // File header parameter array full flag

// File channel calibration
Channel : array[0..WCPMaxChannels-1] of TChannel ;
// Recording channel settings
//RecChannel : array[0..WCPMaxChannels-1] of TChannel ;
RecordTypes : TStringList ;
ChannelNames : TStringList ;
Settings : TSettings ;

MaxDACValue : Integer ;
MinDACValue : Integer ;


implementation


end.
