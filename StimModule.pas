unit StimModule;
{ =============================================

  WinWCP -Analogue & Digital Waveform Generator
  12/12/97 DAC update interval can now go down to 0.1 ms
  13/4/98 Bug which caused -10411 NIDAQ errors fixed
          by using faster DAC update intervals
  14/8/99 32 bit version
  23/11/01 Functions in Wavrun.pas moved to proper data module
           Wrap-round when DAC value exceed upper limit
           of DAC binary range fixed (FillDACBuf)
  18/3/02  Prog.RecordDuration fix added for Instrutech support
  19.7.02  Time shift of digital pulses after first sweep in a series
           with CED 1401 interfaces fixed (by ensuring that last point
           output to sync. channel is always Trigger Off)
  23.7.02  DAC update interval limited to 50 ms
           to avoid -10411 error with Lab-PC boards (23.7.02)
  29.11.02 DAC update interval adjusted to avoid DAC buffer overflow
           error with long-lasting pulse waveforms
           DAC buffer overflow error now appears in status bar
  05.02.04 DAC 1 Trigger pulse can now be inverted by
           Settings.DACInvertTriggerLevel flag.
           Stimulus waveforms can now be started by external trigger pulse
           when record interval is set to StimulusExtTriggerFlag = -1.0
  05.11.04 New CreateWaveform method 2 DAC channels supported
  19.07.05 Time course of user defined waveforms now adapted to to DAC update interval
  04.11.05 .NumDACPoints now kept within available buffer limits
  03.08.06 References to RawFh removed
           8000 point limit removed from protocol
  05.06.07 Update interval now set correctly when using digital outputs
           SetADCDACUpdateIntervals now called again
           DAC update interval adjusted to avoid exceeding DAC buffer
           DigitalOutputsInUse function added
  25.06.10 DAC update interval now set to 1% of short pulse in protocol
  29.07.10 MinPulseDuration() now initialised to recording sweep
           duration to avoid FP divide error when no waveforms in protocol
  24/08/10 Leak subtraction pulses now produced and averaged correctly when
           no. of waveform repetitions are greater than one.
  15/06/11 Up to 4 D/A channels now supported with new XML protocol files
  05/07/11 .ExtTrigger added to prot
  11/07/11 Blank external waveform file names now handled correctly
  15/08/11 Corrupted VPR files no longer converted to XML
  22/12/11 To avoid OLE exceptions and access violations,
           LoadProtocolFromXML/SaveProtocolToXML now Coinitialise/Codeinitialize COM system before after creation of
           XMLDoc. XMLDOC now an IXMLDocument rather than a TXMLDocument.
  16.01.12 GetElementFloat() now handles both ',' and '.' decimal separators
           Leak subtraction option now correctly divides AO0 waveform.
  113.03.12 .ADCSamplingIntervalKeepFixed added to protocol
            ADCSAMPLINGINTERVAL and ADCSAMPLINGINTERVALKEEPFIXED added to XML file
            A/D sampling interval added to recording protocol settings and can now
            be set to a fixed value. D/A and A/D sampling intervals can now be set to same value
  18.09.12 FillDigBuf now Round()s rather than Trunc()s time interval to NumPoints, so that
           time duration of digital pulses same as DAC
  06.07.13 Global stimulus protocol variables feature added
  15.06.15 When .ADCSamplingIntervalKeepFixed=True,  no. of samples per channel
           now adjusted to keep constant duration when sampling interval changed (or vice versa)
  28.07.15 Pulse train with frequency incrementing added
  09.02.17 DigWave added. Scale/Offset parameters added to Wave
           SetADCDACUpdateIntervals() now sets D/A update to digWave user-def. waveforms.
  01.03.17 FillDigWave() function added. TScale & TUnits now set in FormShow()
  31.05.18 Sine wave protocol added.
  06.02.20 PulseStaircase waveform type producing a series of pulses on a rising staircase added.
  09.12.22 Frequency increment of wvWave sine waves caan now act as a multiplier as well as an additive increment
           MULTIPLIERFLAG= added to waveform parameter records and spFrequencyMultiplierFlag added to protocol parameter list
  05.08.24 FindClose(SearchRec.FileHandle) change to FindClose(SearchRec) to fix variable type error which arose when compiled with Delphi 11.1
  =============================================}

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, maths, winprocs, math, seslabio,
  xmldoc, xmlintf, extctrls, strutils, ActiveX ;

const

    MaxAOChannels = 4 ;
    MaxDOChannels = 8 ;
    MaxStimChannels = MaxAOChannels + MaxDOChannels ;
    MaxStimElementsPerChannels = 10 ;
    AOElementsStart = 0 ;
    DOElementsStart = MaxAOChannels*MaxStimElementsPerChannels ;

    // Waveform shapes
    wvNone = 0 ;      // None
    wvStep0 = 1 ;     // Single step
    wvStep1 = 2 ;     // Family of amplitude incremented steps
    wvStep2 = 3 ;     // Family of duration incremented steps
    wvRamp = 4 ;      // Ramp
    wvpTrain = 5 ;    // Pulse train
    wvWave = 6 ;      // Externally defined waveform
    wvDigStep0 = 7 ;  // Single digital step
    wvDigStep1 = 8 ;  //  Family of duration incremented digital steps
    wvDigTrain = 9 ;  // Digital pulse train
    wvDigNone = 10 ;  // No digital pulse
    wvpTrainHz = 11 ;
    wvDigTrainHz = 12 ;
    wvDigWave = 13 ;     // User defined digital pattern
    wvSine = 14 ;        // Sine wave protocol
    wvPulseStaircase = 15 ; // Pulse staircase protocol

    spNone = -1 ;
    spDelay = 0 ;
    spDelayInc = 1 ;
    spStartAmplitude = 2 ;
    spStartAmplitudeInc = 3 ;
    spEndAmplitude = 4 ;
    spEndAmplitudeInc = 5 ;
    spDuration = 6 ;
    spDurationInc = 7 ;
    spNumRepeats = 8 ;
    spNumRepeatsInc = 9 ;
    spRepeatPeriod = 10 ;
    spRepeatPeriodInc = 11 ;
    spDigAmplitude = 12 ;
    spDigAmplitudeInc = 13 ;
    spDACUpdateInterval = 14 ;
    spFileName = 15 ;
    spNumPoints = 16 ;
    spNumPointsInc = 17 ;
    spFrequency = 18 ;
    spFrequencyInc = 19 ;
    spScale = 20 ;
    spScaleInc = 21 ;
    spOffset = 22 ;
    spOffsetInc = 23 ;
    spFrequencyMultiplierFlag = 24 ;
    MaxPars = 24 ;
    MaxRecordingPars = 5 ;

     // Old .VPR protocol file constants

     DigShapes = 10 ; { First digital waveform shape }
     MaxWaveShapes = 28 ;
     MaxOldWaveShapes = 18 ;
     MaxProtocolShapes = 28 ;
     MaxWaveBufPoints = 1024 ;

     // DAC0 shape #s
     DAC0Start = 0 ;
     DAC0End = 9 ;
     // Digital shape #s
     DigStart = 10 ;
     DigEnd = 17 ;
     // DAC1 shape #s
     DAC1Start = 18 ;
     DAC1End = 27 ;
     DAC0 = 0 ;
     DAC1 = 1 ;

     MaxStimGlobalVars = 5 ;

type

// Stimulator waveform types
// Old waveform definition record (pre-V3.5.2)
TWaveformOld = packed record
          Shape : Array[0..17] of Byte ;
          Amplitude :     Array[0..17] of Single ;
          Duration :      Array[0..17] of Single ;
          Increment :     Array[0..17] of Single ;
          RampStart :     Array[0..17] of Single ;
          RampEnd :       Array[0..17] of Single ;
          PulseInterval : Array[0..17] of Single ;
          NumPulses : Array[0..17] of LongInt ;
          Period :        Array[0..17] of Single ;
          Delay :         Array[0..17] of Single ;
          Invert :        Array[0..17] of Boolean ;
          HoldingVoltage : Single ;
          VMin : Single ;
          VMax : Single ;
          RecordInterval : Single ;
          RecordDuration : Single ;
          RecordDelay : Single ;
          RecordDelayIncrement : Single ;
          NumSteps : LongInt ;
          NumRepeats : LongInt ;
          dt : Single ;
          DACdt : Single ;
          FileName : string[255] ;
          ExtWaveData : Array[0..1023] of single ;
          ExtEndOfData : SmallInt ;
          ExtDACdt : single ;
          NextFile : string[255] ;
          StepCounter : LongInt ;
          RepeatCounter : LongInt ;
          NumDACPoints : LongInt ;
          NotInUse : LongInt ;
          LeakCounter : longint ;
          NumLeaks : LongInt ;
          DigitalInUse : Boolean ;
          DigitalPortValue : LongInt ;
          RecordingStart : LongInt ;
          InUse : Boolean ;
          Saved : Boolean ;
          RecordIntervalChanged : boolean ;
          LeakScale : LongInt ;
          NextProtocolFileName : string[255] ;
          end ;

// Waveform definition record
TWaveform = packed record
          Shape : Array[0..MaxWaveShapes-1] of BYte ;
          Amplitude :     Array[0..MaxWaveShapes-1] of Single ;
          Duration :      Array[0..MaxWaveShapes-1] of Single ;
          Increment :     Array[0..MaxWaveShapes-1] of Single ;
          RampStart :     Array[0..MaxWaveShapes-1] of Single ;
          RampEnd :       Array[0..MaxWaveShapes-1] of Single ;
          PulseInterval : Array[0..MaxWaveShapes-1] of Single ;
          NumPulses : Array[0..MaxWaveShapes-1] of LongInt ;
          Period :        Array[0..MaxWaveShapes-1] of Single ;
          Delay :         Array[0..MaxWaveShapes-1] of Single ;
          Invert :        Array[0..MaxWaveShapes-1] of Boolean ;
          HoldingVoltage : Array[DAC0..DAC1] of Single ;
          VMin : Single ;
          VMax : Single ;
          RecordInterval : Single ;
          RecordDuration : Single ;
          NumSteps : LongInt ;
          NumRepeats : LongInt ;
          dt : Single ;
          DACdt : Single ;
          FileName : string[255] ;
          ExtWaveData : Array[0..1023] of single ;
          ExtNumPointsOld : SmallInt ;
          ExtDACdt : single ;
          NextFile : string[255] ;
          StepCounter : LongInt ;
          RepeatCounter : LongInt ;
          NumDACPoints : LongInt ;
          ExtNumPoints : LongInt ;
          LeakCounter : longint ;
          NumLeaks : LongInt ;
          DigitalInUse : Boolean ;
          DigitalPortValue : LongInt ;
          RecordingStart : LongInt ;
          InUse : Boolean ;
          Saved : Boolean ;
          RecordIntervalChanged : boolean ;
          LeakScale : LongInt ;
          NextProtocolFileName : string[255] ;
          end ;

  TStimulusParameter = record
      Text : string ;
      Value : Single ;
      Exists : Boolean ;
      end ;
  TStimulusElement = record
      WaveShape : Integer ;
      Control : TImage ;
      Parameters : Array[0..MaxPars] of TStimulusParameter ;
      FileName : string ;
      Buf : PSingleArray ;
      NumPointsInBuf : Integer ;
      end ;

  TStimulusProtocol = packed record
     Stimulus : Array[0..(MaxStimElementsPerChannels*MaxStimChannels)-1] of TStimulusElement ;
     RecordDuration : Single ;
     StimulusPeriod : Single ;
     NumRecords : Integer ;
     NumRepeatsPerIncrement : Integer ;
     NumADCChannels : Integer ;
     NumADCSamplesPerChannel : Integer ;
     ADCSamplingInterval : Single ;
     ADCSamplingIntervalKeepFixed : Boolean ;
     LeakSubtractionEnabled : Boolean ;
     NumLeakSubtractionRecords : Integer ;
     LeakSubtractionDivideFactor : Integer ;
     ExtTrigger : Boolean ;

     NumAOChannels : Integer ;
     NumDOChannels : Integer ;
     AOStimType : Array[0..MaxAOChannels-1] of Integer ;
     AOChannelUnits : Array[0..MaxAOChannels-1] of string ;
     AOHoldingLevel : Array[0..MaxAOChannels-1] of single ;
     AOScale : Array[0..MaxAOChannels-1] of single ;
     AOUpdateInterval : Single ;
     AOUpdateIntervalFixed : Single ;
     AOUpdateIntervalKeepFixed : Boolean ;
     DOHoldingLevel : Array[0..MaxDOChannels-1] of Integer ;

     NextProtocolFileName : String ;
     Saved : Boolean ;
     end ;

  TStimulator = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private

    Prog : TWaveform ;

    procedure FillDACBuf(
          Chan : Integer ;
          NumDACChannels : Integer ;
          StartValue : Single ;
          EndValue : Single ;
          Time : Single ;
          var Buf : Array of SmallInt ;
          var DACCounter : Integer
          ) ;

    procedure FillDACBufWave(
          Chan : Integer ;                    // Voltage O/P channel to be updated
          NumDACChannels : Integer ;          // No. D/A channels
          var VBuf : Array of Single ;         // Voltage waveform to be added
          StartAt : Integer ;                 // Start at buffer point
          EndAt : Integer ;                   // End at buffer point
          Scale : single ;                    // Scaling factor
          Offset : single ;                   // DC Offset
          var Buf : Array of SmallInt ;       // Output buffer
          var DACCounter : Integer
          ) ;

    procedure FillDigBuf(
          DigChannel : Integer ;   // Digital O/P channel
          BitState : Integer ;     // Bit state
          Time : Single ;          // Duration of fill
          var Buf : Array of SmallInt ; // Digital waveform buffer
          var DigCounter : Integer    // Current pointer position in Buf
          ) ;

    procedure FillDigBufWave(
          DigChannel : Integer ;                    // Digital channel to be updated
          var VBuf : Array of Single ;        // Digital waveform to be added
          StartAt : Integer ;                 // Start at buffer point
          EndAt : Integer ;                   // End at buffer point
          var Buf : Array of SmallInt ;       // Output buffer
          var DigCounter : Integer
          ) ;

      procedure SetElement(
          var Prot : TStimulusProtocol ;
          iElem : Integer ;
          iPar : Integer ;
          Value : Single ) ;

      procedure SetElementText(
          var Prot : TStimulusProtocol ;
          iElem : Integer ;
          iPar : Integer ;
          Value : String ) ;

    function LoadVPRProgram(
              var Prog : TWaveform ;
              const Name : string ;
              var ExtVBuf : PSingleArray
              ) : Boolean ;

    procedure ClearWaveformElements ;

    procedure LoadProtocolFromXMLFile1(
          var Prot : TStimulusProtocol ;           // Protocol record to be loaded
          FileName : String                    // XML protocol file
          ) ;

    procedure SaveProtocolToXMLFile1(
              var Prot : TStimulusProtocol ;           // Protocol record to be loaded
              FileName : String
              ) ;

  public
    { Public declarations }
    FileName : String ;

    Prot : TStimulusProtocol ;     // Stimulus protocol in use

    DACUpdateInterval : Single ;   // D/A update interval (s)
    NumDACPoints : Integer ;       // No. D/A points in waveform
    Increment : Integer ;          // Increment counter
    RepeatCounter : Integer ;      // Repeat counter
    GlobalVar : array[0..MaxStimGlobalVars-1] of Single ;
    GlobalVarFlag : array[0..MaxStimGlobalVars-1] of Single ;

    procedure LoadProtocolFromXMLFile(
          var Prot : TStimulusProtocol ;           // Protocol record to be loaded
          FileName : String                    // XML protocol file
          ) ;

    procedure SaveProtocolToXMLFile(
              var Prot : TStimulusProtocol ;           // Protocol record to be loaded
              FileName : String
              ) ;

    procedure ClearProtocol(
              var Prot : TStimulusProtocol ) ;

    function CreateWaveform(
         var Buf : Array of SmallInt ;
         var DigBuf : Array of SmallInt ;
         NumDACChannels : Integer
         ) : Integer ;

    procedure SubstituteGlobalVariables(
              var Prot : TStimulusProtocol
              ) ;

    procedure NextWaveform ;
    function EndOfProtocol : Boolean ;
    function LeakRecord : Boolean ;
    function ProtocolStatus : String ;

    procedure SetADCDACUpdateIntervals(
              var Prot : TStimulusProtocol  // Protocol
              ) ;
    function CreateLeakWaveform(
             var Buf : Array of SmallInt ;
             NumDACChannels : Integer
             ) : Integer ;
    procedure CreateProtocolList(
              var cbList : TComboBox ) ;

    procedure ConvertProtocolsVPRtoXML ;

    procedure LoadProtocol(
              const Name : string ) ;

    function ProtocolMinPulseDuration(
             Prot : TStimulusProtocol
             ) : Single ;

    function DigitalOutputsInUse : Boolean ;

    function DACScaleFactor( Chan : Integer ) : Single ;

    procedure AddElementFloat(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Single
              ) ;
    function GetElementFloat(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Single
              ) : Boolean ;
    procedure AddElementInt(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Integer
              ) ;
    function GetElementInt(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Integer
              ) : Boolean ;
    procedure AddElementBool(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Boolean
              ) ;
    function GetElementBool(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Boolean
              ) : Boolean ;

    procedure AddElementText(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : String
              ) ;
    function GetElementText(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : String
              ) : Boolean ;

    procedure AddWaveformParameter(
          ParentNode : IXMLNode ;                 // Parent node
          ParameterName : string ;                // Element name
          iValue : Integer ;                      // Parameter value index # in ParList
          iIncrement : Integer ;                  // Parameter increment index # in ParList
          iMultiplierFlag : Integer ;             // Use Parameter increment as multipler index # in ParList
          ParList : Array of TStimulusParameter   // Parameter array
          ) ;

    procedure AddWaveformParameterText(
          ParentNode : IXMLNode ;                 // Parent node
          ParameterName : string ;                // Element name
          iValue : Integer ;                      // Parameter value index # in ParList
          ParList : Array of TStimulusParameter   // Parameter array
          ) ;

    procedure GetWaveformParameter(
          ParentNode : IXMLNode ;                 // Parent node
          ParameterName : string ;                // Element name
          iValue : Integer ;                      // Parameter value index # in ParList
          iIncrement : Integer ;                  // Parameter increment index # in ParList
          iMultiplierFlag : Integer ;             // Use Parameter increment as multipler index # in ParList
          var ParList : Array of TStimulusParameter   // Parameter array
          ) ;

    procedure GetWaveformParameterText(
          ParentNode : IXMLNode ;                 // Parent node
          ParameterName : string ;                // Element name
          iValue : Integer ;                      // Parameter value index # in ParList
          var ParList : Array of TStimulusParameter   // Parameter array
          ) ;

    function FindXMLNode(
         const ParentNode : IXMLNode ;  // Node to be searched
         NodeName : String ;            // Element name to be found
         var ChildNode : IXMLNode ;     // Child Node of found element
         var NodeIndex : Integer        // ParentNode.ChildNodes Index #
                          // Starting index on entry, found index on exit
         ) : Boolean ;

    function LoadWaveformFromTextFile(
              var Prot : TStimulusProtocol ;           // Protocol record to be loaded
              iElement : Integer ;                     // Element to be loaded
              FileName : String
              ) : Boolean ;
    function LoadWaveformFromDATFile(
              var Prot : TStimulusProtocol ;           // Protocol record to be loaded
              iStimElement : Integer
              ) : Boolean ;

    procedure SaveWaveformToDATFile(
              var Prot : TStimulusProtocol ;           // Protocol record
              iStimElement : Integer                   // Element to be saved
              ) ;


  end;

var
  Stimulator: TStimulator;

implementation

uses Mdiform, AmpModule, Rec, Sealtest, WCPFIleUnit;

{$R *.DFM}


function TStimulator.CreateWaveform(
         var Buf : Array of SmallInt ;
         var DigBuf : Array of SmallInt ;
         NumDACChannels : Integer
         ) : Integer ;
{ -----------------------------------------------------
  Create command voltage waveforms defined by protocol
  ----------------------------------------------------}
var
    ii,i,j,g,sh,iElem,iInc :Integer ;

    DisplayDuration : Single ;

    AONum,DONum : Integer ;
    DACScale : Single ;
    DACValue : Integer ;
    // Y Axes range and labels
    Y,YMax,YMin,dT,YStart,YEnd : Single ;
    TMax : Single ;
    StartAmplitude,EndAmplitude : Single ;
    Delay,Duration,PulsePeriod : Single ;
    NumPulses,iPulse : Integer ;
    StimulusDuration : Single ;
    NumIncrements : Integer ;
    State : Integer ;
    DigWord,Bit : Integer ;
    DACCounter,DigCounter : Integer ;
    StartAt,EndAt,NumPoints : Integer ;
    Scale,Offset,T,ScaleToPhaseAngle : single ;
    np : Integer ;
    VBuf : PSingleArray ;
    FReq : single ;
begin

     // Calculate DAC update interval
     // (taking into account hardware constraints)
     SetADCDACUpdateIntervals( Prot ) ;

     // Determine number of points in protocol
     // (Keep within available buffer)
     NumDACPoints := Round(Prot.RecordDuration/DACUpdateInterval) ;
     if NumDACPoints > (Main.SESLabIO.DACBufferLimit div 2) then
        begin
        NumDACPoints := Main.SESLabIO.DACBufferLimit div 2 ;
        Main.StatusBar.SimpleText :=
        ' WARNING! D/A buffer overflow! Stimulus waveform may be truncated. '  ;
        WCPFile.WriteToLogFile( Main.StatusBar.SimpleText ) ;
        end ;

     { Create a digital D/A waveform from protocol list }

     // Fill DAC buffers with holding potential
     for AONum := 0 to NumDACChannels-1 do
         begin
         // Set V->DAC scaling factor
         DACScale := DACScaleFactor(AONum) ;
         // Calculate DAC value
         if AONum < Prot.NumAOChannels then
            begin
            DACValue := Round( DACScale*Prot.AOHoldingLevel[AONum] ) ;
            end
         else DACValue := Round( DACScale*Main.SESLabIO.DACHoldingVoltage[AONum] ) ;
         if DACValue > Main.SESLabIO.DACMaxValue then DACValue := Main.SESLabIO.DACMaxValue ;
         if DACValue < Main.SESLabIO.DACMinValue then DACValue := Main.SESLabIO.DACMinValue ;
         // Update buffer
         j := AONum ;
         for i := 0 to NumDACPoints-1 do
             begin
             Buf[j] := DACValue ;
             j := j + NumDACChannels ;
             end ;
         end ;

     { Set default digital output buffer bit WCPFile.Settings}
     Bit := 1 ;
     DigWord := WCPFile.Settings.DigitalPort.Value ;
     for i := 0 to Prot.NumDOChannels-1 do
         begin
         DigWord := DigWord and (not Bit) ;
         if Prot.DOHoldingLevel[i] <> 0 then DigWord := DigWord or Bit ;
         Bit := Bit shl 1 ;
         end ;
     for i := 0 to NumDACPoints-1 do DigBuf[i] := DigWord ;

     // Substitute
     SubstituteGlobalVariables( Prot ) ;

     dT := 0.0 ;
     for AONum := 0 to Prot.NumAOChannels-1 do
         begin

         // Draw stimulus waveforms
         StimulusDuration := Prot.RecordDuration ;

         // Initialise D/A buffer counter
         DACCounter := 0 ;

         for i := 0 to MaxStimElementsPerChannels-1 do
             begin

             iElem := i + AONum*MaxStimElementsPerChannels ;

             if Prot.Stimulus[iElem].WaveShape = Ord(wvNone) then Continue ;

             // Delay (at holding level)
             if Prot.Stimulus[iElem].Parameters[spDelay].Exists then
                begin
                Delay := Prot.Stimulus[iElem].Parameters[spDelay].Value ;
                if Prot.Stimulus[iElem].Parameters[spDelayInc].Exists then
                   begin
                   Delay := Delay + (Increment*
                            Prot.Stimulus[iElem].Parameters[spDelayInc].Value) ;
                   end ;
                end
             else Delay := 0.0 ;

             // Pulse Duration
             if Prot.Stimulus[iElem].Parameters[spDuration].Exists then begin
                Duration := Prot.Stimulus[iElem].Parameters[spDuration].Value ;
                if Prot.Stimulus[iElem].Parameters[spDurationInc].Exists then
                   begin
                   Duration := Duration + (Increment*
                               Prot.Stimulus[iElem].Parameters[spDurationInc].Value);
                   end ;
                end
             else Duration := 0.0 ;

             // Pulse train
             if Prot.Stimulus[iElem].Parameters[spNumRepeats].Exists then begin
                NumPulses := Round(Prot.Stimulus[iElem].Parameters[spNumRepeats].Value) + 1 ;
                if Prot.Stimulus[iElem].Parameters[spNumRepeatsInc].Exists then
                      begin
                      NumPulses := NumPulses + (Increment*
                                   Round(Prot.Stimulus[iElem].Parameters[spNumRepeatsInc].Value));
                      end ;
                end
             else NumPulses := 1 ;

             // Pulse period
             if Prot.Stimulus[iElem].Parameters[spRepeatPeriod].Exists then
                begin

                PulsePeriod := Prot.Stimulus[iElem].Parameters[spRepeatPeriod].Value ;
                if Prot.Stimulus[iElem].Parameters[spRepeatPeriodInc].Exists then
                   begin
                   PulsePeriod := PulsePeriod + (Increment*
                                  Prot.Stimulus[iElem].Parameters[spRepeatPeriodInc].Value) ;
                   end ;

                end
             else if Prot.Stimulus[iElem].Parameters[spFrequency].Exists then
                begin

                Freq := Prot.Stimulus[iElem].Parameters[spFrequency].Value ;

                if Prot.Stimulus[iElem].Parameters[spFrequencyInc].Exists then
                   begin

                   if Prot.Stimulus[iElem].Parameters[spFrequencyMultiplierFlag].Exists and
                      (Prot.Stimulus[iElem].Parameters[spFrequencyMultiplierFlag].Value = 1.0) then
                      begin
                      // Multiply by increment
                      Freq := Prot.Stimulus[iElem].Parameters[spFrequency].Value ;
                      for iInc := 1 to Increment do Freq := Freq*Prot.Stimulus[iElem].Parameters[spFrequencyInc].Value ;
                      end
                   else
                      begin
                      // Add increment
                      Freq := Prot.Stimulus[iElem].Parameters[spFrequency].Value +
                              Prot.Stimulus[iElem].Parameters[spFrequencyInc].Value*Increment ;
                      end;
                   PulsePeriod := 1.0 / Max(Freq,1E-6) ;
                   end ;

                end
             else PulsePeriod := 0 ;

             // Start amplitude
             if Prot.Stimulus[iElem].Parameters[spStartAmplitude].Exists then
                begin
                StartAmplitude := Prot.Stimulus[iElem].Parameters[spStartAmplitude].Value ;
                if Prot.Stimulus[iElem].Parameters[spStartAmplitudeInc].Exists then
                   begin
                   StartAmplitude := StartAmplitude + (Increment*
                                     Prot.Stimulus[iElem].Parameters[spStartAmplitudeInc].Value) ;
                   end ;
                end
             else StartAmplitude := 0.0 ;

             // End amplitude
             if Prot.Stimulus[iElem].Parameters[spEndAmplitude].Exists then
                begin
                EndAmplitude := Prot.Stimulus[iElem].Parameters[spEndAmplitude].Value ;
                if Prot.Stimulus[iElem].Parameters[spEndAmplitudeInc].Exists then
                   begin
                   EndAmplitude := EndAmplitude + (Increment*
                                   Prot.Stimulus[iElem].Parameters[spEndAmplitudeInc].Value) ;
                   end
                end
             else EndAmplitude := StartAmplitude ;

             // D/A update interval (Note All elements must have the same update interval
             if (Prot.Stimulus[iElem].Parameters[spDACUpdateInterval].Exists) and
                   (dT = 0.0) then
                   begin
                   dT := Prot.Stimulus[iElem].Parameters[spDACUpdateInterval].Value ;
                   end ;

             // Delay (at holding level)
             if Delay <> 0.0 then
                begin
                FillDACBuf( AONum,
                            NumDACChannels,
                            Prot.AOHoldingLevel[AONum],
                            Prot.AOHoldingLevel[AONum],
                            Delay,
                            Buf,
                            DACCounter) ;
                end ;

             if (Prot.Stimulus[iElem].WaveShape = Ord(wvSine)) then
                begin
                // ----------------
                // Create sine wave
                // ----------------
                VBuf := AllocMem( (Round(Duration/DACUpdateInterval) + 1)*SizeOf(Single) ) ;
                T := 0.0 ;
                np := 0 ;
                ScaleToPhaseAngle := (2.0*pi()) / PulsePeriod ;
                while t <= Duration do
                    begin
                    VBuf^[np] := Prot.AOHoldingLevel[AONum] + StartAmplitude*sin(ScaleToPhaseAngle*T);
                    T := T + DACUpdateInterval ;
                    Inc(np) ;
                    end ;

                FillDACBufWave( AONum,
                                NumDACChannels,
                                VBuf^,
                                0,
                                np,
                                1.0,
                                0,
                                Buf,
                                DACCounter) ;

                FreeMem(VBuf) ;

                end
             else begin
                // ---------------------
                // Create step waveforms
                // ---------------------
                for iPulse := 0 to NumPulses-1 do
                    begin

                    if iPulse > 0 then
                       begin
                       // Inter-pulse period
                       Y := Prot.AOHoldingLevel[AONum] ;
                       if (Prot.Stimulus[iElem].WaveShape = Ord(wvPulseStaircase)) then Y := Y + EndAmplitude*iPulse ;
                       FillDACBuf( AONum,
                                   NumDACChannels,
                                   Y,
                                   Y,
                                   PulsePeriod - Duration,
                                   Buf,
                                   DACCounter) ;
                       end ;

                    // Pulse
                    if (Prot.Stimulus[iElem].WaveShape = Ord(wvPulseStaircase)) then
                       begin
                       // Special treatment for pulse staircase waveform
                       YStart := Prot.AOHoldingLevel[AONum] + StartAmplitude + EndAmplitude*iPulse ;
                       YEnd := YStart ;
                       end
                     else
                       begin
                       YStart := Prot.AOHoldingLevel[AONum] + StartAmplitude ;
                       YEnd := Prot.AOHoldingLevel[AONum] + EndAmplitude ;
                       end;
                    FillDACBuf( AONum,
                                NumDACChannels,
                                YStart,
                                YEnd,
                                Duration,
                                Buf,
                                DACCounter) ;
                    end ;
                end ;

             // Create user-defined waveform
             if (Prot.Stimulus[iElem].WaveShape = Ord(wvWave)) and
                (Prot.Stimulus[iElem].Buf <> Nil) then
                begin

                // No. points in waveform to be plotted and starting point in waveform buffer
                if Prot.Stimulus[iElem].Parameters[spNumPoints].Exists then
                   begin
                   NumPoints := Round(Prot.Stimulus[iElem].Parameters[spNumPoints].Value) ;
                   if Prot.Stimulus[iElem].Parameters[spNumPointsInc].Exists then
                      begin
                      StartAt := Round(Prot.Stimulus[iElem].Parameters[spNumPointsInc].Value*Increment) ;
                      end
                   else StartAt := 0 ;
                   end
                else
                   begin
                   StartAt := 0 ;
                   NumPoints := Prot.Stimulus[iElem].NumPointsInBuf ;
                   end ;

                // Scaling applied to user defined waveform
                Scale := 1.0 ;
                if Prot.Stimulus[iElem].Parameters[spScale].Exists then
                   Scale := Prot.Stimulus[iElem].Parameters[spScale].Value ;
                if Prot.Stimulus[iElem].Parameters[spScaleInc].Exists then
                   Scale := Scale + Prot.Stimulus[iElem].Parameters[spScaleInc].Value*Increment ;

                // Offset applied to user defined waveform
                Offset := 0.0 ;
                if Prot.Stimulus[iElem].Parameters[spOffset].Exists then
                   Offset := Prot.Stimulus[iElem].Parameters[spOffset].Value ;
                if Prot.Stimulus[iElem].Parameters[spOffsetInc].Exists then
                   Offset := Offset + Prot.Stimulus[iElem].Parameters[spOffsetInc].Value*Increment ;

                // Section of waveform to output
                StartAt := Min(Max(StartAt,0),Prot.Stimulus[iElem].NumPointsInBuf-1) ;
                EndAt := Min(Max(StartAt + NumPoints - 1,0),Prot.Stimulus[iElem].NumPointsInBuf-1) ;

                FillDACBufWave( AONum,
                                NumDACChannels,
                                Prot.Stimulus[iElem].Buf^,
                                StartAt,
                                EndAt,
                                Scale,
                                Offset,
                                Buf,
                                DACCounter) ;
                end ;
             end ;

         end ;

     // Display digital waveforms

     for DONum := 0 to Prot.NumDOChannels-1 do begin

         // Initialise DigBuf counter
         DigCounter := 0 ;

         for i := 0 to MaxStimElementsPerChannels-1 do
             begin

             iElem := i + DONum*MaxStimElementsPerChannels + DOElementsStart ;

             if Prot.Stimulus[iElem].WaveShape = Ord(wvDigNone) then Continue ;

             // Delay (at holding level)
             if Prot.Stimulus[iElem].Parameters[spDelay].Exists then
                begin
                Delay := Prot.Stimulus[iElem].Parameters[spDelay].Value ;
                if Prot.Stimulus[iElem].Parameters[spDelayInc].Exists then
                   begin
                   Delay := Delay +
                            Prot.Stimulus[iElem].Parameters[spDelayInc].Value*Increment ;
                   end ;
                end
             else Delay := 0.0 ;

             // Pulse Duration
             if Prot.Stimulus[iElem].Parameters[spDuration].Exists then
                begin
                Duration := Prot.Stimulus[iElem].Parameters[spDuration].Value ;
                if Prot.Stimulus[iElem].Parameters[spDurationInc].Exists then
                   begin
                   Duration := Duration +
                               Prot.Stimulus[iElem].Parameters[spDurationInc].Value*Increment ;
                   end ;
                end
             else Duration := 0.0 ;

             // Pulse train
             if Prot.Stimulus[iElem].Parameters[spNumRepeats].Exists then
                begin
                NumPulses := Round(Prot.Stimulus[iElem].Parameters[spNumRepeats].Value) + 1 ;
                if Prot.Stimulus[iElem].Parameters[spNumRepeatsInc].Exists then
                   begin
                   NumPulses := NumPulses +
                                Round(Prot.Stimulus[iElem].Parameters[spNumRepeatsInc].Value)
                   end ;
                end
             else NumPulses := 1 ;

             // Pulse period
             if Prot.Stimulus[iElem].Parameters[spRepeatPeriod].Exists then
                begin

                PulsePeriod := Prot.Stimulus[iElem].Parameters[spRepeatPeriod].Value ;
                if Prot.Stimulus[iElem].Parameters[spRepeatPeriodInc].Exists then
                   begin
                   PulsePeriod := PulsePeriod +
                                  Prot.Stimulus[iElem].Parameters[spRepeatPeriodInc].Value*Increment ;
                   end ;
                end
             else if Prot.Stimulus[iElem].Parameters[spFrequency].Exists then
                begin

                Freq := Prot.Stimulus[iElem].Parameters[spFrequency].Value ;

                if Prot.Stimulus[iElem].Parameters[spFrequencyInc].Exists then
                   begin

                   if Prot.Stimulus[iElem].Parameters[spFrequencyMultiplierFlag].Exists and
                      (Prot.Stimulus[iElem].Parameters[spFrequencyMultiplierFlag].Value = 1.0) then
                      begin
                      // Multiply by increment
                      Freq := Prot.Stimulus[iElem].Parameters[spFrequency].Value ;
                      for iInc := 1 to Increment do Freq := Freq*Prot.Stimulus[iElem].Parameters[spFrequencyInc].Value ;
                      end
                   else
                      begin
                      // Add increment
                      Freq := Prot.Stimulus[iElem].Parameters[spFrequency].Value +
                              Prot.Stimulus[iElem].Parameters[spFrequencyInc].Value*Increment ;
                      end;
                   PulsePeriod := 1.0 / Max(Freq,1E-6) ;
                   end ;
                end
             else PulsePeriod := 0 ;

             // Pulse state (1/0)
             if Prot.Stimulus[iElem].Parameters[spDigAmplitude].Exists then begin
                State := Round(Prot.Stimulus[iElem].Parameters[spDigAmplitude].Value) ;
                end
             else State := Prot.DOHoldingLevel[DONum] ;

             // Delay (at holding level)
             if Delay <> 0.0 then begin
                FillDigBuf( DONum,Prot.DOHoldingLevel[DONum],Delay,DigBuf,DigCounter) ;
                end ;

             for iPulse := 0 to NumPulses-1 do begin

                 if iPulse > 0 then begin
                    // Inter-pulse period
                    FillDigBuf( DONum,Prot.DOHoldingLevel[DONum],
                                PulsePeriod - Duration,DigBuf,DigCounter) ;
                    end ;

                 // Pulse
                 FillDigBuf( DONum,State,Duration,DigBuf,DigCounter) ;

                 end ;

             // Output user-defined waveform
             if (Prot.Stimulus[iElem].WaveShape = Ord(wvDigWave)) and
                (Prot.Stimulus[iElem].Buf <> Nil) then
                begin

                // No. points in waveform to be plotted and starting point in waveform buffer
                if Prot.Stimulus[iElem].Parameters[spNumPoints].Exists then begin
                   NumPoints := Round(Prot.Stimulus[iElem].Parameters[spNumPoints].Value) ;
                   if Prot.Stimulus[iElem].Parameters[spNumPointsInc].Exists then begin
                      StartAt := Round(Prot.Stimulus[iElem].Parameters[spNumPointsInc].Value*Increment) ;
                      end
                   else StartAt := 0 ;
                   end
                else begin
                   StartAt := 0 ;
                   NumPoints := Prot.Stimulus[iElem].NumPointsInBuf ;
                   end ;

                // Section of waveform to output
                StartAt := Min(Max(StartAt,0),Prot.Stimulus[iElem].NumPointsInBuf-1) ;
                EndAt := Min(Max(StartAt + NumPoints - 1,0),Prot.Stimulus[iElem].NumPointsInBuf-1) ;

                FillDigBufWave( DONum,
                                Prot.Stimulus[iElem].Buf^,
                                StartAt,
                                EndAt,
                                DigBuf,
                                DigCounter) ;
                end ;

             end ;

         end ;

     Result := NumDACPoints ;

     end ;

procedure TStimulator.SubstituteGlobalVariables(
          var Prot : TStimulusProtocol
          ) ;
// ---------------------------------------------------------
// Substitute global variable value for global variable flag
// ---------------------------------------------------------
var
    i,j,g : Integer ;
begin
    for i := 0 to High(Prot.Stimulus) do
        for j := 0 to High(Prot.Stimulus[i].Parameters) do
        for g := 0 to High(Stimulator.GlobalVarFlag) do
            if Prot.Stimulus[i].Parameters[j].Value = GlobalVarFlag[g] then
               begin
               Prot.Stimulus[i].Parameters[j].Value := GlobalVar[g] ;
               end ;
    end ;


procedure TStimulator.NextWaveform ;
// -------------------------------------
// Increment to next stimulator waveform
// -------------------------------------
var
    EndCount : Integer ;
begin

    Inc(RepeatCounter) ;
    EndCount := Prot.NumRepeatsPerIncrement ;
    if Prot.LeakSubtractionEnabled then EndCount := EndCount + Prot.NumLeakSubtractionRecords ;

    if RepeatCounter >= EndCount then
       begin
       Inc(Increment) ;      // Next step
       RepeatCounter := 0 ;  // Clear repeat counter
       end ;
    end ;


function TStimulator.ProtocolStatus : String ;
// -----------------------------------------------------
// Return string containing current waveform in progress
// -----------------------------------------------------
var
    LeakOffset : Integer ;
begin

    if LeakRecord then
       begin
       Result := format( 'Stim: %s Step %d/%d Leak %d/%d ',
                 [ANSIReplaceText(ExtractFileName(FileName),'.xml',''),
                 Increment+1,Stimulator.Prot.NumRecords div Max(Stimulator.Prot.NumRepeatsPerIncrement,1),
                  Stimulator.RepeatCounter+1,Stimulator.Prot.NumLeakSubtractionRecords]) ;
       end
    else
       begin
       if Prot.LeakSubtractionEnabled then LeakOffset := Prot.NumLeakSubtractionRecords
                                      else LeakOffset := 0 ;
       Result := format( 'Stim: %s Step %d/%d Repeat %d/%d ',
                 [ANSIReplaceText(ExtractFileName(FileName),'.xml',''),
                  Increment+1,Stimulator.Prot.NumRecords div Max(Stimulator.Prot.NumRepeatsPerIncrement,1),
                  Stimulator.RepeatCounter+1-LeakOffset,
                  Stimulator.Prot.NumRepeatsPerIncrement]) ;
       end ;
    end ;


function TStimulator.EndOfProtocol : Boolean ;
// ---------------------
// Query end of protocol
// ---------------------
begin
    if Increment >= (Prot.NumRecords div Prot.NumRepeatsPerIncrement) then Result := True
                                                                      else Result := False ;

    end ;

function TStimulator.LeakRecord : Boolean ;
// ---------------------
// Query leak record
// ---------------------
begin
    if Prot.LeakSubtractionEnabled and
       (RepeatCounter < Abs(Stimulator.Prot.NumLeakSubtractionRecords)) then
       begin
       Result := True ;
       end
    else Result := False ;
    end ;


function TStimulator.DigitalOutputsInUse : Boolean ;
// -------------------------------------------------
// Return TRUE if a digital outputs used in protocol
// -------------------------------------------------
var
    DONum,i,iElem : Integer ;
begin
     Result := False ;
     { Determine if a digital channel is in use }
     for DONum := 0 to Prot.NumDOChannels-1 do
         begin
         for i := 0 to MaxStimElementsPerChannels-1 do
             begin
             iElem := i + DONum*MaxStimElementsPerChannels + DOElementsStart ;
             if Prot.Stimulus[iElem].WaveShape <> Ord(wvDigNone) then Result := True ;
             end ;
         end ;
     end ;


procedure TStimulator.SetADCDACUpdateIntervals(
          var Prot : TStimulusProtocol  // Protocol
          ) ;
// -----------------------------
// Calculate DAC update interval
// -----------------------------
var
    i,AONum,DONum,iElem : Integer ;
    dt,MinDACdt : Single ;
    MaxDACPoints : Integer ;
begin

     Main.SESLabIO.DigitalStimulusEnabled := DigitalOutputsInUse ;
     if Main.SESLabIO.DigitalStimulusEnabled then MinDACdt := Main.SESLabIO.DigMinUpdateInterval
                                             else MinDACdt := Main.SESLabIO.DACMinUpdateInterval ;

     // Set A/D sampling interval

     if Prot.ADCSamplingIntervalKeepFixed then
        begin
        // Set record duration from sampling interval & samples/channel
        Main.SESLabIO.ADCNumChannels := Prot.NumADCChannels ;
        Main.SESLabIO.ADCSamplingInterval := Prot.ADCSamplingInterval ;
        Prot.ADCSamplingInterval := Main.SESLabIO.ADCSamplingInterval ;
        Prot.NumADCSamplesPerChannel := Round(Prot.RecordDuration/Prot.ADCSamplingInterval) ;
        Prot.NumADCSamplesPerChannel := Max(Prot.NumADCSamplesPerChannel div 256,1)*256 ;
        if ((Prot.ADCSamplingInterval*Prot.NumADCSamplesPerChannel)/Prot.RecordDuration) < 0.99 then
           Prot.NumADCSamplesPerChannel := Prot.NumADCSamplesPerChannel + 256 ;
        Prot.NumADCSamplesPerChannel := Min( Prot.NumADCSamplesPerChannel,
                                             Main.SESLabIO.ADCBUfferLimit div Prot.NumADCChannels ) ;
        Prot.NumADCSamplesPerChannel := Max(Prot.NumADCSamplesPerChannel div 256,1)*256 ;
        Prot.RecordDuration := Prot.ADCSamplingInterval* Prot.NumADCSamplesPerChannel ;
        end
     else
        begin
        // Set sampling interval from requested duration and samples/channel
        Main.SESLabIO.ADCNumChannels := Prot.NumADCChannels ;
        Main.SESLabIO.ADCSamplingInterval := Prot.RecordDuration / Max(Prot.NumADCSamplesPerChannel,1) ;
        Prot.ADCSamplingInterval := Main.SESLabIO.ADCSamplingInterval ;
        end ;

     // Find an optimum D/A update interval

     // Maximum number of DAC points in waveform
     MaxDACPoints := Main.SESLabIO.DACBufferLimit div
                     Max(Min(Prot.NumAOChannels,Main.SESLabIO.DACMaxChannels),1) ;

     // Set D/A update interval same as A/D update
     DACUpdateInterval := Prot.RecordDuration / Max(Prot.NumADCSamplesPerChannel,1) ;

     // If very small pulses in waveform adjust
     if ProtocolMinPulseDuration(Prot) < DACUpdateInterval then
        begin
        DACUpdateInterval := ProtocolMinPulseDuration(Prot)*0.1 ;
        end ;

     // If an externally defined waveform is in use ... its DAC update
     // interval over-rides the internal setting
     dt := 0.0 ;
     for AONum := 0 to Prot.NumAOChannels-1 do
         begin
         for i := 0 to MaxStimElementsPerChannels-1 do
             begin
             iElem := i + AONum*MaxStimElementsPerChannels ;
             if (Prot.Stimulus[iElem].WaveShape = Ord(wvWave)) and
                Prot.Stimulus[iElem].Parameters[spDACUpdateInterval].Exists and
                (dT = 0.0) then begin
                dT := Prot.Stimulus[iElem].Parameters[spDACUpdateInterval].Value ;
                end ;
             end ;
         end ;

     for DONum := 0 to Prot.NumDOChannels-1 do
         begin
         for i := 0 to MaxStimElementsPerChannels-1 do
             begin
             iElem := i + DONum*MaxStimElementsPerChannels  + DOElementsStart ;
             if (Prot.Stimulus[iElem].WaveShape = Ord(wvDigWave)) and
                Prot.Stimulus[iElem].Parameters[spDACUpdateInterval].Exists and
                (dT = 0.0) then begin
                dT := Prot.Stimulus[iElem].Parameters[spDACUpdateInterval].Value ;
                end ;
             end ;
         end ;

      if dt <> 0.0 then DACUpdateInterval := dt ;

     // If fixed (user set) D/A update interval flag set, over-ride with fixed value
     if Prot.AOUpdateIntervalKeepFixed then
        begin
        DACUpdateInterval := Prot.AOUpdateIntervalFixed ;
        end ;

     // Make it a multiple of the smallest interval
     //DACUpdateInterval := Max( Round(DACUpdateInterval/MinDACdt)*MinDACdt,MinDACdt) ;
     // Removed 13.3.12 since not needed. Setting and reading Main.SESLabIO.DACUpdateInterval does same function

     // Ensure it doesn't exceed buffer limit
     if Round(Prot.RecordDuration/Max(DACUpdateInterval,MinDACdt)) > MaxDACPoints then
        DACUpdateInterval := 2.0*Max(DACUpdateInterval,MinDACdt) ;

     // Ensure update interval is no longer than 50 ms
     // to avoid -10411 error with Lab-PC boards (23.7.02)
     DACUpdateInterval := Min(DACUpdateInterval,0.05) ;

     { These calls made for the benefit of the Digidata 132X and similar
       interfaces where D/A update and A/D sampling intervals must be the same }
     Main.SESLabIO.DACUpdateInterval := DACUpdateInterval ;
     DACUpdateInterval := Main.SESLabIO.DACUpdateInterval ;

     Prot.AOUpdateInterval := DACUpdateInterval ;

     end ;


function TStimulator.CreateLeakWaveform(
         var Buf : Array of SmallInt ;    // D/A output buffer containing test waveform
         NumDACChannels : Integer         // No. of output channels in Buf
          ) : Integer ;
{ -------------------------------------------------------------------------
  Create leak pulse waveform by dividing down test waveform by Prog.NumLeaks
  -------------------------------------------------------------------------}
var
   i,j : Integer ;
   iHold : Integer ;
   VScale : single ;
begin
     if Prot.NumLeakSubtractionRecords <> 0 then
        begin
        iHold := Buf[0] ;
        if Prot.LeakSubtractionDivideFactor <> 0 then VScale := 1./Prot.LeakSubtractionDivideFactor
                                                 else VScale := 1. ;
        j := 0 ;
        for i := 0 to NumDACPoints-1 do
            begin
            Buf[j] := Round((Buf[j] - iHold)*VScale) + iHold ;
            j := j + NumDACChannels ;
            end ;
        end ;
   Result := NumDACPoints ;
   end ;


procedure TStimulator.FillDACBuf(
          Chan : Integer ;             // D/A channel
          NumDACChannels : Integer ;   // No. D/A channels
          StartValue : Single ;        // Starting D/A value
          EndValue : Single ;          // End D/A value
          Time : Single ;              // Duration
          var Buf : Array of SmallInt ;// D/A buffer
          var DACCounter : Integer        // D/A buffer pointer
          ) ;
{ -------------------------------------------------------------
  Copy a series of NumPoints D/A values of amplitude Value into
  channel Chan of a D/A output buffer Buf, starting at point BufPointer
  ---------------------------------------------------------------------
  23/11/01 DAC buffer binary wrap-round error fixed}
var
   i,j : Integer ;
   iDACValue : Integer ;
   DACValue,DACIncrement,DACScale : Single ;
   NumPoints : Integer ;
   jLimit,iDACMin,iDACMax : Integer ;
begin

     if Time <= 0.0 then Exit ;

     DACScale := DACScaleFactor( Chan ) ;

     iDACMax := Main.SESLabIO.DACMaxValue ;
     iDACMin := Main.SESLabIO.DACMinValue ;

     NumPoints := Max( Round(Time/DACUpdateInterval),1) ;

     jLimit := Main.SESLabIO.ADCBufferLimit ;
     j := DACCounter*NumDACChannels + Chan ;
     DACValue := StartValue ;
     DACIncrement := (EndValue - StartValue) / NumPoints ;
     for i := 1 to NumPoints do if j < jLimit then
         begin
         iDACValue := Round(DACScale*DACValue) ;
         if iDACValue < iDACMin then iDACValue := iDACMin ;
         if iDACValue > iDACMax then iDACValue := iDACMax ;
         Buf[j] := iDACValue ;
         j := j + NumDACChannels ;
         DACValue := DACValue + DACIncrement ;
         end ;

     DACCounter := DACCounter + NumPoints ;

     end ;


function TStimulator.DACScaleFactor( Chan : Integer ) : Single ;
// -----------------------------------
// Get D/A output channel scale factor
// -----------------------------------
var
     AmplifierDivideFactor : Single ;
begin

     // Get amplifier stimulus scaling factor
     if ANSIContainsText(Prot.AOChannelUnits[Chan],'V') then
        begin
        // Voltage stimulus
        AmplifierDivideFactor := Amplifier.VoltageCommandScaleFactor[Chan] ;
        end
     else
        begin
        // Current stimulus
        AmplifierDivideFactor := Amplifier.CurrentCommandScaleFactor[Chan] ;
        end ;

     // Set DAC scaling factor
     Result := Main.SESLabIO.DACMaxValue/
               (AmplifierDivideFactor*Main.SESLabIO.DACVoltageRange[Chan]) ;
     if Prot.AOScale[Chan] = 0.0 then Prot.AOScale[Chan] := 1.0 ;
     if Chan < Prot.NumAOChannels then Result := Result/Prot.AOScale[Chan] ;
     end ;


procedure TStimulator.DataModuleCreate(Sender: TObject);
// -----------------------------------
// Initialisations when module created
// -----------------------------------
var
    i : Integer ;
begin

    // Init global variable to zero
    for i :=  0 to MaxStimGlobalVars-1 do
        begin
        GlobalVar[i] := 0.0 ;
        GlobalVarFlag[i] := (i+1)*1.0E8 ;
        end;
    end;

procedure TStimulator.FillDACBufWave(
          Chan : Integer ;                    // Voltage O/P channel to be updated
          NumDACChannels : Integer ;          // No. D/A channels
          var VBuf : Array of Single ;         // Voltage waveform to be added
          StartAt : Integer ;                 // Start at buffer point
          EndAt : Integer ;                   // End at buffer point
          Scale : single ;                    // Scaling factor
          Offset : single ;                   // DC Offset
          var Buf : Array of SmallInt ;       // Output buffer
          var DACCounter : Integer
          ) ;
// -----------------------
// Add waveform to buffer
// -----------------------
var
   i,j : Integer ;
   DACValue : Integer ;
   DACScale : Single ;
   DACBufLimit : Integer ;
begin

     // Set DAC scaling factor
     DACScale := DACScaleFactor(Chan) ;

     // Load waveform
     j := DACCounter*NumDACChannels + Chan ;
     DACBufLimit := Main.SESLabIO.ADCBufferLimit ;
     for i := StartAt to EndAt do if j <= DACBufLimit then
         begin
         DACValue := Round(DACScale*(Scale*VBuf[i] + Offset + Prot.AOHoldingLevel[Chan])) ;
         DACValue := Max( Min( DACValue, Main.SESLabIO.DACMaxValue ),
                                        -Main.SESLabIO.DACMaxValue-1 ) ;
         Buf[j] := DACValue ;
         j := j + NumDACChannels ;
         Inc(DACCounter) ;
         end ;

     end ;


procedure TStimulator.FillDigBuf(
          DigChannel : Integer ;   // Digital O/P channel
          BitState : Integer ;     // Bit state
          Time : Single ;          // Duration of fill
          var Buf : Array of SmallInt ; // Digital waveform buffer
          var DigCounter : Integer     // Current pointer position in Buf
          ) ;
// -------------------------------------------------------------------
// Add a segment of duration <Time> seconds at level <BitState>
// to digital channel # <DigChannel> in digital waveform buffer <Buf>
// -------------------------------------------------------------------
var
   i : Integer ;
   Bit : SmallInt ;
   BitMask : SmallInt ;
   NumPoints : Integer ;
   EndOfBuf : Integer ;
begin

     if Time <= 0.0 then Exit ;

     NumPoints := Max( Round(Time/DACUpdateInterval ),1 ) ;
     EndOfBuf := Main.SESLabIO.DACBufferLimit -1 ;

     { Clear the bit defined by BitMask, all other bits left untouched }
     Bit := 1 shl DigChannel ;
     BitMask := not Bit ;
     for i := 1 to NumPoints do if DigCounter <= EndOfBuf then begin
         Buf[DigCounter] := Buf[DigCounter] and BitMask ;
         if BitState <> 0 then Buf[DigCounter] := Buf[DigCounter] or Bit ;
         Inc(DigCounter) ;
         end ;

    end ;


procedure TStimulator.FillDigBufWave(
          DigChannel : Integer ;                    // Digital channel to be updated
          var VBuf : Array of Single ;        // Digital waveform to be added
          StartAt : Integer ;                 // Start at buffer point
          EndAt : Integer ;                   // End at buffer point
          var Buf : Array of SmallInt ;       // Output buffer
          var DigCounter : Integer
          ) ;
// ------------------------------
// Add digital waveform to buffer
// ------------------------------
var
   i : Integer ;
   Bit : SmallInt ;
   BitMask : SmallInt ;
   DACBufLimit : Integer ;
begin

     Bit := 1 shl DigChannel ;
     BitMask := not Bit ;

     // Load waveform
     DACBufLimit := Main.SESLabIO.ADCBufferLimit ;
     for i := StartAt to EndAt do if DigCounter <= DACBufLimit then begin
         Buf[DigCounter] := Buf[DigCounter] and BitMask ;
         if VBuf[i] <> 0.0 then Buf[DigCounter] := Buf[DigCounter] or Bit ;
         Inc(DigCounter) ;
         end ;

     end ;


procedure TStimulator.LoadProtocol(
          const Name : string     { Voltage program file path }
          ) ;
{ --------------------------------
  Load a voltage protocol from file
  --------------------------------}
begin

    // Open stimulus protocol file
    FileName := ChangeFileExt( Name, '.xml' ) ;
    LoadProtocolFromXMLFile( Prot, FileName ) ;

    // Set laboratory interface
    Main.SESLabIO.ADCNumChannels := Prot.NumADCChannels ;
    Main.SESLabIO.ADCNumSamples := Prot.NumADCSamplesPerChannel ;
    SetADCDACUpdateIntervals( Prot ) ;
    Main.SESLabIO.ADCSamplingInterval := Prot.RecordDuration/Main.SESLabIO.ADCNumSamples ;

    { Initialise counters in preparation for use }
    Increment := 0 ;
    RepeatCounter := 0 ;

    Prot.Saved := True ;

    end ;


function TStimulator.LoadVPRProgram(
         var Prog : TWaveform ;
         const Name : string ;    { Voltage program file path }
         var ExtVBuf : PSingleArray  // Pointer to extended user-defined waveform buffer
         ) : Boolean ;               // Return TRUE if file loaded
{ --------------------------------
  Load a voltage program from file
  --------------------------------}

var
   FileHandle : Integer ;
   OldProg : TWaveformOld ;
   i, j : Integer ;
   NumBytes : Integer ;
   FileName : String ;
begin

    Result := True ;

    // Open stimulus protocol file
    FileName := ChangeFileExt( Name, '.vpr' ) ;
    Prog.FileName := FileName ;
    FileHandle := FileOpen(  FileName, fmOpenReadWrite ) ;

    NumBytes := FileSeek( FileHandle, 0, 2 ) ;

    if NumBytes >= SizeOf(Prog) then begin
       // Load protocol file
       // ------------------
       FileSeek( FileHandle, 0, 0 ) ;
       if FileRead(FileHandle,Prog,Sizeof(Prog)) <> Sizeof(Prog) then begin
          ShowMessage(format( 'LoadProgram : Unable to read %s ',[FileName])) ;
          Result := False ;
          end ;

       // Copy to new external number of sample points and disable old
       if Prog.ExtNumPointsOld >= 0 then begin
          Prog.ExtNumPoints := Prog.ExtNumPointsOld ;
          Prog.ExtNumPointsOld := -1 ;
          end ;

       // Allocate extended buffer
       if ExtVBuf <> Nil then FreeMem(ExtVBuf) ;
       GetMem( ExtVBuf, Max(Prog.ExtNumPoints,1)*4 ) ;

       if Prog.ExtNumPoints > MaxWaveBufPoints then begin
          // Load buffer from extended area at end of file
          FileRead(FileHandle,ExtVBuf^,Prog.ExtNumPoints*4) ;
          end
       else if Prog.ExtNumPoints > 0 then begin
            // Copy from existing ExtWaveData buffer
            for i := 0 to Prog.ExtNumPoints-1 do ExtVBuf^[i] := Prog.ExtWaveData[i] ;
            end ;

       end
    else begin
       // Load old format protocol file
       // -----------------------------
       FileSeek( FileHandle, 0, 0 ) ;
       if FileRead(FileHandle,OldProg,Sizeof(OldProg)) <> Sizeof(OldProg) then
          ShowMessage(format( 'LoadProgram : Unable to read %s ',[FileName])) ;

       // Clear all waveshapes
       ClearWaveformElements ;

       // Copy to new format
       for i := 0 to MaxOldWaveShapes-1 do begin
           // Swap wvDigNone for wvNone in digital elements
           Prog.Shape[i] := OldProg.Shape[i] ;
           if (i >= 10) and (OldProg.Shape[i] = wvNone) then
              Prog.Shape[i] := wvDigNone ;
           Prog.Amplitude[i] := OldProg.Amplitude[i] ;
           Prog.Duration[i] := OldProg.Duration[i] ;
           Prog.Increment[i] := OldProg.Increment[i] ;
           Prog.RampStart[i] := OldProg.RampStart[i] ;
           Prog.RampEnd[i] := OldProg.RampEnd[i] ;
           Prog.PulseInterval[i] := OldProg.PulseInterval[i] ;
           Prog.NumPulses[i] := OldProg.NumPulses[i] ;
           Prog.Period[i] := OldProg.Period[i] ;
           Prog.Delay[i] := OldProg.Delay[i] ;
           Prog.Invert[i] := OldProg.Invert[i] ;
           end ;
       Prog. HoldingVoltage[0] := OldProg. HoldingVoltage ;
       Prog. HoldingVoltage[1] := 0.0 ;
       Prog.RecordInterval := OldProg.RecordInterval ;
       Prog.RecordDuration := OldProg.RecordDuration ;
       Prog.NumSteps := OldProg.NumSteps ;
       Prog.NumRepeats := OldProg.NumRepeats ;
       Prog.dt := OldProg.dt ;
       Prog.DACdt := OldProg.DACdt ;

       for j := 0 to High(Prog.ExtWaveData) do
           Prog.ExtWaveData[j] := OldProg.ExtWaveData[j] ;
       Prog.ExtNumPoints := OldProg.ExtEndOfData ;
       Prog.ExtDACdt := OldProg.ExtDACdt ;
       Prog.FileName := OldProg.FileName ;
       Prog.NextFile := OldProg.NextFile ;
       Prog.NumDACPoints := OldProg.NumDACPoints ;
       Prog.ExtNumPoints := OldProg.NotInUse ;
       Prog.NumLeaks := OldProg.NumLeaks ;
       Prog.DigitalInUse := OldProg.DigitalInUse ;
       Prog.DigitalPortValue := OldProg.DigitalPortValue ;
       Prog.RecordingStart := OldProg.RecordingStart ;
       Prog.InUse := OldProg.InUse ;
       Prog.Saved := OldProg.Saved ;
       Prog.RecordIntervalChanged := OldProg.RecordIntervalChanged ;
       Prog.LeakScale := OldProg.LeakScale ;
       Prog.NextProtocolFileName := OldProg.NextProtocolFileName ;

       // Save as new format
       FileSeek( FileHandle, 0, 0 ) ;
       if FileWrite(FileHandle,OldProg,Sizeof(OldProg)) <> Sizeof(OldProg) then begin
          ShowMessage(format( 'LoadProgram : Unable to write to %s ',[FileName])) ;
          Result := False ;
          end ;

       end ;

    if FileHandle >=0 then FileClose( FileHandle ) ;

    { Initialise counters in preparation for use }
    Prog.StepCounter := 0 ;
    Prog.RepeatCounter := 0 ;
    Prog.LeakCounter := 0 ;

    // If waveform shapes are invalid return FALSE
    for i := 0 to MaxOldWaveShapes-1 do
        if (Prog.Shape[i] < 0) or (Prog.Shape[i] > 10) then Result := False ;

    end ;


procedure TStimulator.CreateProtocolList(
          var cbList : TComboBox
          ) ;
{ --------------------------------------------
  Cmpile a list of protocol files in the directory \winwcp\vprot
  and put the file names into a combo box
  --------------------------------------------------------------}
var
   SearchRec : TSearchRec ;
   First : Boolean ;
   FileFound : Integer ;
begin

     // If any VPR files exist in directory, convert to XML
     ConvertProtocolsVPRtoXML ;

     First := True ;
     cbList.Clear ;
     cbList.items.add( ' ' ) ;
     repeat
        { Find file }
        if First then
           FileFound := FindFirst( WCPFile.Settings.VProtDirectory + '*.xml',
                                   faAnyFile,
                                   SearchRec )
        else
           FileFound := FindNext( SearchRec ) ;

        { Add file name (no extension or path) to list }
        if FileFound = 0 then cbList.items.Add(WCPFile.ExtractFileNameOnly(SearchRec.Name))
                        else FindClose(SearchRec) ;
        First := False ;
        Until FileFound <> 0 ;

     end ;


procedure TStimulator.ConvertProtocolsVPRtoXML ;
// --------------------------------------
// Convert VPR protocols to XML protocols
// --------------------------------------
var
   SearchRec : TSearchRec ;
   First : Boolean ;
   FileFound : Integer ;
   Prot : ^TStimulusProtocol ;
   VPRProg : TWaveform ;
   i,j,iElem : Integer ;
   Amp : Single ;
   VPRFileName,XMLFileName,BAKFileName : String ;
   ExtVBuf : PSingleArray ; // Pointer to extended user-defined waveform buffer
begin

     // Allocate protocol record and clear to zero
     Prot := AllocMem( SizeOf(TStimulusProtocol) ) ;
     ExtVBuf := Nil ;

     First := True ;
     repeat
        { Find file }
        if First then
           FileFound := FindFirst( WCPFile.Settings.VProtDirectory + '*.vpr',
                                   faAnyFile,
                                   SearchRec )
        else FileFound := FindNext( SearchRec ) ;

        { Add file name (no extension or path) to list }

        // Copy VPR to XML file

        if FileFound = 0 then
           begin

           // Load VPR Protocol
           VPRFileName := WCPFile.Settings.VProtDirectory + SearchRec.Name ;

           if LoadVPRProgram(VPRProg,VPRFileName,ExtVBuf) then
              begin
              // Clear XML protocol
              ClearProtocol(Prot^) ;

              // Copy data
              Prot^.RecordDuration := VPRProg.RecordDuration ;
              if VPRProg.RecordInterval < 0.0 then Prot^.ExtTrigger := True
                                              else Prot^.ExtTrigger := False ;
              Prot^.StimulusPeriod := Abs(VPRProg.RecordInterval) ;
              Prot^.NumRecords := VPRProg.NumSteps*VPRProg.NumRepeats ;
              Prot^.NumRepeatsPerIncrement := VPRProg.NumRepeats ;
              Prot^.NumADCChannels := 2 ;
              Prot^.NumADCSamplesPerChannel := 2048 ;
              Prot^.ADCSamplingInterval := Prot^.RecordDuration / Prot^.NumADCSamplesPerChannel ;
              if VPRProg.NumLeaks > 0 then
                 begin
                 Prot^.NumLeakSubtractionRecords := VPRProg.NumLeaks ;
                 Prot^.LeakSubtractionDivideFactor := VPRProg.LeakScale ;
                 Prot^.LeakSubtractionEnabled := True ;
                 end
              else
                 begin
                 Prot^.LeakSubtractionEnabled := False ;
                 Prot^.NumLeakSubtractionRecords := 4 ;
                 Prot^.LeakSubtractionDivideFactor := 4 ;
                 end ;

              Prot^.NextProtocolFileName := VPRProg.NextProtocolFileName ;

              Prot^.NumAOChannels := 1 ;
              Prot^.NumDOChannels := 1 ;

              // Holding voltage levels
              for i := 0 to High(Prot^.AOStimType) do Prot^.AOStimType[i] := 0 ;
              for i := 0 to High(Prot^.AOChannelUnits) do Prot^.AOChannelUnits[i] := 'mV' ;
              for i := 0 to High(Prot^.AOHoldingLevel) do begin
                  if i <= 1 then Prot^.AOHoldingLevel[i] := VPRProg.HoldingVoltage[i]
                            else  Prot^.AOHoldingLevel[i] := 0.0 ;
                  end ;

              for i := 0 to High(Prot^.AOScale) do Prot^.AOScale[i] := 1E3 ;
              Prot^.AOUpdateIntervalFixed := 1E-3 ;
              Prot^.AOUpdateIntervalKeepFixed := False ;

              // Digital holding levels
              for i := 0 to High(Prot^.DOHoldingLevel) do begin
                  if (VPRProg.DigitalPortValue and (1 shl i)) <> 0 then Prot^.DOHoldingLevel[i] := 1
                                                                   else Prot^.DOHoldingLevel[i] := 0 ;
                  end ;

              // Waveform elements

              for i := 0 to High(VPRProg.Shape) do
                  if (VPRProg.Shape[i] <> wvNone) and (VPRProg.Shape[i] <> wvDigNone)
                  then begin

                  // Map old waveshapes to new
                  case i of
                    0..9 : begin
                        iElem := i ;        // DAC 0
                        Prot^.NumAOChannels := Max(Prot^.NumAOChannels,1) ;
                        end ;
                    18..27 : begin
                        iElem := i - 8 ; // DAC 1
                        Prot^.NumAOChannels := Max(Prot^.NumAOChannels,2) ;
                        end ;

                    10..17 : begin
                         iElem := DOElementsStart + (i-10)*MaxStimElementsPerChannels ;
                         Prot^.NumDOChannels := Max(Prot^.NumDOChannels,i-9) ;
                         end ;
                    else iElem := 0 ;
                    end ;

                  Prot^.Stimulus[iElem].Waveshape := Ord(VPRProg.Shape[i]) ;

                  // Delay
                  case Prot^.Stimulus[iElem].Waveshape of
                     wvStep0, wvStep1, wvStep2, wvRamp, wvpTrain, wvWave, wvSine,
                     wvDigStep0,wvDigStep1, wvDigTrain : begin
                        SetElement(Prot^, iElem,spDelay,VPRProg.Delay[i]) ;
                        end ;
                     end ;

                  // Duration
                  case Prot^.Stimulus[iElem].Waveshape of
                     wvStep0, wvStep1, wvStep2, wvRamp, wvpTrain,wvSine,
                     wvDigStep0,wvDigStep1, wvDigTrain : begin
                        SetElement(Prot^, iElem,spDuration,VPRProg.Duration[i]) ;
                        end ;
                     end ;

                  // Amplitude
                  case Prot^.Stimulus[iElem].Waveshape of
                     wvStep0, wvStep1, wvStep2, wvpTrain,wvSine : begin
                        SetElement(Prot^, iElem,spStartAmplitude,VPRProg.Amplitude[i]*1E3) ;
                        end ;
                     end ;

                  // Digital pulse amplitude
                  case Prot^.Stimulus[iElem].Waveshape of
                     wvDigStep0,wvDigStep1,wvDigTrain : begin
                         if VPRProg.Invert[i] then Amp := 0.0
                                              else Amp := 1.0 ;
                         SetElement(Prot^, iElem,spDigAmplitude,Amp) ;
                         end ;
                     end ;

                  // Ramp
                  case Prot^.Stimulus[iElem].Waveshape of
                     wvRamp : begin
                        SetElement(Prot^,iElem,spStartAmplitude,VPRProg.RampStart[i]*1E3) ;
                        SetElement(Prot^,iElem,spEndAmplitude,VPRProg.RampEnd[i]*1E3) ;
                        end ;
                     end ;

                  // Amplitude increment
                  case Prot^.Stimulus[iElem].Waveshape of
                      wvStep1 : begin
                         SetElement(Prot^,iElem,spStartAmplitudeInc,VPRProg.Increment[i]*1E3) ;
                         end ;
                      end ;

                  // Duration increment
                  case Prot^.Stimulus[iElem].Waveshape of
                     wvStep2,wvDigStep1 : begin
                         SetElement(Prot^,iElem,spDurationInc,VPRProg.Increment[i]) ;
                         end ;
                     end ;

                  // Repeat pulse interval
                  case Prot^.Stimulus[iElem].Waveshape of
                     wvpTrain,wvDigTrain,wvSine : begin
                        SetElement(Prot^,iElem,spRepeatPeriod,VPRProg.PulseInterval[i]) ;
                        SetElement(Prot^,iElem,spNumRepeats,VPRProg.NumPulses[i]) ;
                        end ;
                     end ;

                  // External waveform
                  case Prot^.Stimulus[iElem].Waveshape of
                      wvWave : begin
                         SetElementText(Prot^,iElem,spFileName,VPRFileName) ;
                         SetElement(Prot^,iElem,spDACUpdateInterval,VPRProg.ExtDACdt) ;
                         SetElement(Prot^,iElem,spNumPoints,VPRProg.ExtNumPoints) ;
                         SetElement(Prot^,iElem,spNumPointsInc,0) ;
                         Prot^.Stimulus[iElem].NumPointsInBuf := VPRProg.ExtNumPoints ;
                         if Prot^.Stimulus[iElem].Buf <> Nil then FreeMem(Prot^.Stimulus[iElem].Buf) ;
                         GetMem( Prot^.Stimulus[iElem].Buf,Max(1,VPRProg.ExtNumPoints)*SizeOf(Single)) ;
                         for j := 0 to VPRProg.ExtNumPoints-1 do begin
                             Prot^.Stimulus[iElem].Buf[j] := ExtVBuf^[j]*1000.0 ;
                             end ;
                         SaveWaveformToDATFile( Prot^, iElem ) ;
                         end ;
                      end ;

                  end ;

              // Save to new protocol
              XMLFileName := ChangeFileExt(VPRFileName,'.xml') ;
              Main.StatusBar.SimpleText := format('Converting %s to %s',
                                        [ExtractFileName(VPRFileName),
                                         ExtractFileName(XMLFileName)]) ;
              WCPFile.WriteToLogFile( format('Stimulus protocol %s converted to %s',
                                        [ExtractFileName(VPRFileName),
                                         ExtractFileName(XMLFileName)])) ;
              SaveProtocolToXMLFile( Prot^, XMLFileName) ;
              end
           else begin
              Main.StatusBar.SimpleText := format('Stimulus protocol %s file damaged (not converted)',
                                        [ExtractFileName(VPRFileName)]) ;
              WCPFile.WriteToLogFile( Main.StatusBar.SimpleText ) ;
              end ;

           Application.ProcessMessages ;

           // Rename VPR file
           BAKFileName := VPRFileName + '.bak' ;
           if FileExists( BAKFileName ) then DeleteFile( PChar(BAKFileName) ) ;
           RenameFile( VPRFileName, BAKFileName ) ;

           end ;

        First := False ;
        Until FileFound <> 0 ;

     FindClose(SearchRec) ;

     FreeMem( Prot ) ;
     if ExtVBuf <> Nil then FreeMem(ExtVBuf) ;

     end ;


procedure TStimulator.SetElement(
          var Prot : TStimulusProtocol ;
          iElem : Integer ;
          iPar : Integer ;
          Value : Single ) ;
// ------------------------------
// Set stimulus element parameter
// ------------------------------
begin
      Prot.Stimulus[iElem].Parameters[iPar].Exists := True ;
      Prot.Stimulus[iElem].Parameters[iPar].Value := Value ;
      end ;


procedure TStimulator.SetElementText(
          var Prot : TStimulusProtocol ;
          iElem : Integer ;
          iPar : Integer ;
          Value : String ) ;
// ------------------------------
// Set stimulus element parameter
// ------------------------------
begin
      Prot.Stimulus[iElem].Parameters[iPar].Exists := True ;
      Prot.Stimulus[iElem].Parameters[iPar].Text := Value ;
      end ;


function TStimulator.ProtocolMinPulseDuration(
         Prot : TStimulusProtocol
         ) : Single ;
{ --------------------------------------------
  Calculate smallest duration of pulse in voltage protocol
  --------------------------------------------}
var
   iElem,NumIncrements : Integer ;
   T,TMin : Single ;

begin

    // Substitute global flags for global values
    SubstituteGlobalVariables(Prot) ;

    TMin := Prot.RecordDuration ;
    NumIncrements := Prot.NumRecords div Max(Prot.NumRepeatsPerIncrement,1) ;

    for iElem := 0 to High(Prot.Stimulus) do
        begin
        if (Prot.Stimulus[iElem].WaveShape = Ord(wvNone)) or
           (Prot.Stimulus[iElem].WaveShape = Ord(wvDigNone)) then Continue ;

        // Delay
        if Prot.Stimulus[iElem].Parameters[spDelay].Exists then
           begin
           T := Prot.Stimulus[iElem].Parameters[spDelay].Value ;
           if T <> 0.0 then
              begin
              TMin := Min(TMin,T) ;
              if Prot.Stimulus[iElem].Parameters[spDelayInc].Exists then begin
                 T := T + ((NumIncrements-1)*
                           Prot.Stimulus[iElem].Parameters[spDelayInc].Value) ;
                 TMin := Min(TMin,T) ;
                 end ;
              end ;
           end ;

        // Pulse Duration
        if Prot.Stimulus[iElem].Parameters[spDuration].Exists then
           begin
           T := Prot.Stimulus[iElem].Parameters[spDuration].Value ;
           if T <> 0.0 then
              begin
              TMin := Min(TMin,T) ;
              if Prot.Stimulus[iElem].Parameters[spDurationInc].Exists then
                 begin
                 T := T + ((NumIncrements-1)*
                           Prot.Stimulus[iElem].Parameters[spDurationInc].Value);
                 TMin := Min(TMin,T) ;
                 end ;
              end ;
           end ;
        end ;

     Result := TMin ;
     end ;


procedure TStimulator.ClearWaveformElements ;
// ---------------------------
// Clear all waveform elements
// ---------------------------
var
    i : Integer ;
begin
     { Set DAC0 elements to none }
     for i := DAC0Start to DAC0End do
         begin
         Stimulator.Prog.Shape[i] := wvNone ;
         Stimulator.Prog.Delay[i] := 0. ;
         Stimulator.Prog.Duration[i] := 0. ;
         Stimulator.Prog.NumPulses[i] := 1 ;
         end ;

     { Set DAC1 elements to none }
     for i := DAC1Start to DAC1End do
         begin
         Stimulator.Prog.Shape[i] := wvNone ;
         Stimulator.Prog.Delay[i] := 0. ;
         Stimulator.Prog.Duration[i] := 0. ;
         Stimulator.Prog.NumPulses[i] := 1 ;
         end ;

     { Set digital elements to none }
     for i := DigStart to DigEnd do
         begin
         Stimulator.Prog.Shape[i] := wvDigNone ;
         Stimulator.Prog.Delay[i] := 0. ;
         Stimulator.Prog.Duration[i] := 0. ;
         Stimulator.Prog.NumPulses[i] := 1 ;
         end ;

     end ;


procedure TStimulator.ClearProtocol(
          var Prot : TStimulusProtocol ) ;
// --------------
// Clear protocol
// --------------
var
    i,j : Integer ;
begin

    for i := 0 to High(Prot.Stimulus) do
        begin
        if i < DOElementsStart then Prot.Stimulus[i].WaveShape := Ord(wvNone)
                               else Prot.Stimulus[i].WaveShape := Ord(wvDigNone) ;
        Prot.Stimulus[i].NumPointsInBuf := 0 ;
        for j := 0 to High(Prot.Stimulus[i].Parameters) do
            begin
            Prot.Stimulus[i].Parameters[j].Exists := False ;
            end ;
        if Prot.Stimulus[i].Buf <> Nil then
           begin
           FreeMem(Prot.Stimulus[i].Buf) ;
           Prot.Stimulus[i].Buf := Nil ;
           end ;
        end ;

     Prot.NextProtocolFileName := '' ;

    end;


procedure TStimulator.SaveProtocolToXMLFile(
           var Prot : TStimulusProtocol ;           // Protocol record to be loaded
           FileName : String
           ) ;
// -------------------------------------------------
// Save stimulus protocol to XML file (public method)
// -------------------------------------------------
begin
    CoInitialize(Nil) ;
    SaveProtocolToXMLFile1( Prot, FileName ) ;
    CoUnInitialize ;
    end ;


procedure TStimulator.SaveProtocolToXMLFile1(
           var Prot : TStimulusProtocol ;           // Protocol record to be loaded
           FileName : String
           ) ;
// ----------------------------------
// Save stimulus protocol to XML file
// ----------------------------------
var
   iNode,ProtNode : IXMLNode;
   i,iStart,OutChan : Integer ;
   s : TStringList ;
   XMLDoc : IXMLDocument ;
begin

    if FileName = '' then Exit ;

    XMLDoc := TXMLDocument.Create(Self);
    XMLDoc.Active := True ;

    // Clear document
    XMLDoc.ChildNodes.Clear ;

    // Add record name
    ProtNode := XMLDoc.AddChild( 'STIMULUSPROTOCOL' ) ;

    // General
    AddElementFloat( ProtNode, 'DURATION', Prot.RecordDuration ) ;
    AddElementFloat( ProtNode, 'ADCSAMPLINGINTERVAL', Prot.ADCSamplingInterval ) ;
    AddElementFloat( ProtNode, 'PERIOD', Prot.StimulusPeriod ) ;
    AddElementInt( ProtNode, 'NUMRECORDS', Prot.NumRecords ) ;
    AddElementInt( ProtNode, 'NUMREPEATSPERINCREMENT', Prot.NumRepeatsPerIncrement ) ;

    Prot.NumADCChannels := Min( Prot.NumADCChannels,
                                Main.SESLabIO.ADCMaxChannels) ;
    AddElementInt( ProtNode, 'NUMADCCHANNELS', Prot.NumADCChannels ) ;

    Prot.NumADCSamplesPerChannel := Min( Prot.NumADCSamplesPerChannel,
                                         Main.SESLabIO.ADCBUfferLimit div
                                         Prot.NumADCChannels ) ;
    AddElementInt( ProtNode, 'NUMADCSAMPLESPERCHANNEL', Prot.NumADCSamplesPerChannel ) ;

    AddElementBool( ProtNode, 'LEAKSUBTRACTIONENABLED', Prot.LeakSubtractionEnabled ) ;
    AddElementInt( ProtNode, 'NUMLEAKSUBTRACTIONRECORDS', Prot.NumLeakSubtractionRecords ) ;
    AddElementInt( ProtNode, 'LEAKSUBTRACTIONDIVIDEFACTOR', Prot.LeakSubtractionDivideFactor ) ;
    AddElementFloat( ProtNode, 'AOUPDATEINTERVALFIXED', Prot.AOUpdateIntervalFixed ) ;
    AddElementBool( ProtNode, 'AOUPDATEINTERVALKEEPFIXED', Prot.AOUpdateIntervalKeepFixed ) ;
    AddElementBool( ProtNode, 'EXTTRIGGER', Prot.ExtTrigger ) ;
    AddElementText( ProtNode, 'NEXTPROTOCOLFILENAME', Prot.NextProtocolFileName ) ;
    AddElementBool( ProtNode, 'ADCSAMPLINGINTERVALKEEPFIXED', Prot.ADCSamplingIntervalKeepFixed ) ;

    // Analog output channels
    for i := 0 to Prot.NumAOChannels-1 do
        begin
        iNode := ProtNode.AddChild( 'ANALOGOUTPUTCHANNEL' ) ;
        AddElementInt( iNode, 'NUMBER', i ) ;
        AddElementInt( iNode, 'STIMTYPE', Prot.AOStimType[i] ) ;
        AddElementText( iNode, 'UNITS', Prot.AOChannelUnits[i] ) ;
        AddElementFloat( iNode, 'HOLDINGLEVEL', Prot.AOHoldingLevel[i] ) ;
        AddElementFloat( iNode, 'SCALINGFACTOR', Prot.AOScale[i] ) ;
        end ;

    // Digital output channels
    for i := 0 to Prot.NumDOChannels-1 do
        begin
        iNode := ProtNode.AddChild( 'DIGITALOUTPUTCHANNEL' ) ;
        AddElementInt( iNode, 'NUMBER', i ) ;
        AddElementFloat( iNode, 'HOLDINGLEVEL', Prot.DOHoldingLevel[i] ) ;
        end ;

    // Analog waveform elements
    for OutChan := 0 to Prot.NumAOChannels-1 do
        begin
        iStart := OutChan*MaxStimElementsPerChannels ;
        for i := iStart to iStart + MaxStimElementsPerChannels do begin
           if Prot.Stimulus[i].WaveShape > 0 then
              begin
              iNode := ProtNode.AddChild( 'WAVEFORMELEMENT' ) ;
              AddElementText( iNode, 'OUTPUTCHANNELTYPE', 'ANALOG' ) ;
              AddElementInt( iNode, 'OUTPUTCHANNELNUMBER', OutChan ) ;
              AddElementInt( iNode, 'ORDER', i - iStart );
              // Waveform shape
              AddElementInt( iNode, 'WAVESHAPE', Prot.Stimulus[i].WaveShape ) ;
              // Parameters
              AddWaveformParameter( iNode, 'DELAY', spDelay, spDelayInc,spNone,
                                    Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'STARTAMPLITUDE', spStartAmplitude, spStartAmplitudeInc,spNone,
                                    Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'ENDAMPLITUDE', spEndAmplitude, spEndAmplitudeInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'DURATION', spDuration, spDurationInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'NUMREPEATS', spNumRepeats, spNumRepeatsInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'REPEATPERIOD', spRepeatPeriod, spRepeatPeriodInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'FREQUENCY', spFrequency, spFrequencyInc,spFrequencyMultiplierFlag,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameterText( iNode, 'FILENAME', spFileName,
                                        Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'DACUPDATEINTERVAL', spDACUpdateInterval, spNone,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'NUMPOINTS', spNumPoints, spNumPointsInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'SCALE', spScale, spScaleInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'OFFSET', spOffset, spOffsetInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;

              end ;
           end ;
        end ;

    // Digital waveform elements
    for OutChan := 0 to Prot.NumDOChannels-1 do
        begin
        iStart := OutChan*MaxStimElementsPerChannels + DOElementsStart ;
        for i := iStart to iStart + MaxStimElementsPerChannels - 1 do
           begin
           if Prot.Stimulus[i].WaveShape > 0 then
              begin
              iNode := ProtNode.AddChild( 'WAVEFORMELEMENT' ) ;
              AddElementText( iNode, 'OUTPUTCHANNELTYPE', 'DIGITAL' ) ;
              AddElementInt( iNode, 'OUTPUTCHANNELNUMBER', OutChan ) ;
              AddElementInt( iNode, 'ORDER', i - iStart );
              // Waveform shape
              AddElementInt( iNode, 'WAVESHAPE', Prot.Stimulus[i].WaveShape ) ;
              // Parameters
              AddWaveformParameter( iNode, 'DELAY', spDelay, spDelayInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'DIGITALLEVEL', spDigAmplitude, spDigAmplitudeInc,spNone,
                                  Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'DURATION', spDuration, spDurationInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'NUMREPEATS', spNumRepeats, spNumRepeatsInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'REPEATPERIOD', spRepeatPeriod, spRepeatPeriodInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'FREQUENCY', spFrequency, spFrequencyInc,spFrequencyMultiplierFlag,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameterText( iNode, 'FILENAME', spFileName,
                                        Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'NUMPOINTS', spNumPoints, spNumPointsInc,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              AddWaveformParameter( iNode, 'DACUPDATEINTERVAL', spDACUpdateInterval, spNone,spNone,
                                 Prot.Stimulus[i].Parameters ) ;
              end ;
           end ;
        end ;


     s := TStringList.Create;
     s.Assign(xmlDoc.XML) ;
     //sl.Insert(0,'<!DOCTYPE ns:mys SYSTEM "myXML.dtd">') ;
     s.Insert(0,'<?xml version="1.0"?>') ;
     s.SaveToFile( FileName ) ;
     s.Free ;
     XMLDoc.Active := False ;
     XMLDoc := Nil ;

     Prot.Saved := True ;

    end ;



procedure TStimulator.LoadProtocolFromXMLFile(
          var Prot : TStimulusProtocol ;           // Protocol record to be loaded
          FileName : String                    // XML protocol file
          ) ;
// ----------------------------------
// Load stimulus protocol from XML file
// ----------------------------------
begin
    CoInitialize(Nil) ;
    LoadProtocolFromXMLFile1( Prot, FileName ) ;
    CoUnInitialize ;
    end ;


procedure TStimulator.LoadProtocolFromXMLFile1(
          var Prot : TStimulusProtocol ;           // Protocol record to be loaded
          FileName : String                    // XML protocol file
          ) ;
// ----------------------------------
// Load stimulus protocol from XML file
// ----------------------------------
var
   iNode,ProtNode : IXMLNode;
   ChanNum,iElement : Integer ;

   NodeIndex : Integer ;
   ChanType : String ;
   Order : Integer ;
   XMLDoc : IXMLDocument ;
   OK : Boolean ;
   WaveFileName : String ;
begin

    // Clear protocol record
    ClearProtocol( Prot ) ;

    if not FileExists(FileName) then Exit ;

    XMLDoc := TXMLDocument.Create(Self) ;

    XMLDOC.Active := False ;

    XMLDOC.LoadFromFile( FileName ) ;
    XMLDoc.Active := True ;

    //for i := 0 to  xmldoc.DocumentElement.ChildNodes.Count-1 do
        //OutputDebugString( PChar(String(xmldoc.DocumentElement.ChildNodes[i].NodeName))) ;

    ProtNode := xmldoc.DocumentElement ;

    // General
    GetElementFloat( ProtNode, 'DURATION', Prot.RecordDuration ) ;
    GetElementFloat( ProtNode, 'ADCSAMPLINGINTERVAL', Prot.ADCSamplingInterval ) ;
    GetElementFloat( ProtNode, 'PERIOD', Prot.StimulusPeriod ) ;
    GetElementInt( ProtNode, 'NUMRECORDS', Prot.NumRecords ) ;
    GetElementInt( ProtNode, 'NUMREPEATSPERINCREMENT', Prot.NumRepeatsPerIncrement ) ;

    GetElementInt( ProtNode, 'NUMADCCHANNELS', Prot.NumADCChannels ) ;
    Prot.NumADCChannels := Min(Max(Prot.NumADCChannels,1),Main.SESLabIO.ADCMaxChannels) ;

    GetElementInt( ProtNode, 'NUMADCSAMPLESPERCHANNEL', Prot.NumADCSamplesPerChannel ) ;
    Prot.NumADCSamplesPerChannel := Min( Prot.NumADCSamplesPerChannel,
                                         Main.SESLabIO.ADCBufferLimit div Prot.NumADCChannels) ;
    Prot.NumADCSamplesPerChannel := Max(Prot.NumADCSamplesPerChannel,256) ;

    GetElementBool( ProtNode, 'LEAKSUBTRACTIONENABLED', Prot.LeakSubtractionEnabled ) ;
    GetElementInt( ProtNode, 'NUMLEAKSUBTRACTIONRECORDS', Prot.NumLeakSubtractionRecords ) ;
    GetElementInt( ProtNode, 'LEAKSUBTRACTIONDIVIDEFACTOR', Prot.LeakSubtractionDivideFactor ) ;
    GetElementFloat( ProtNode, 'AOUPDATEINTERVALFIXED', Prot.AOUpdateIntervalFixed ) ;
    GetElementBool( ProtNode, 'AOUPDATEINTERVALKEEPFIXED', Prot.AOUpdateIntervalKeepFixed ) ;
    GetElementBool( ProtNode, 'EXTTRIGGER', Prot.ExtTrigger ) ;
    GetElementText( ProtNode, 'NEXTPROTOCOLFILENAME', Prot.NextProtocolFileName ) ;
    GetElementBool( ProtNode, 'ADCSAMPLINGINTERVALKEEPFIXED', Prot.ADCSamplingIntervalKeepFixed ) ;

    NodeIndex := 0 ;
    Prot.NumAOChannels := 0 ;
    ChanNum := 0 ;
    While FindXMLNode(ProtNode,'ANALOGOUTPUTCHANNEL',iNode,NodeIndex) do
        begin
        ChanNum := Prot.NumAOChannels ;
        GetElementInt( iNode, 'NUMBER', ChanNum ) ;
        if (ChanNum >= 0) and (ChanNum <= High(Prot.AOChannelUnits)) then
           begin
           GetElementInt( iNode, 'STIMTYPE', Prot.AOStimType[ChanNum] ) ;
           GetElementText( iNode, 'UNITS', Prot.AOChannelUnits[ChanNum] ) ;
           GetElementFloat( iNode, 'HOLDINGLEVEL', Prot.AOHoldingLevel[ChanNum] ) ;
           GetElementFloat( iNode, 'SCALINGFACTOR', Prot.AOScale[ChanNum] ) ;
           Inc(Prot.NumAOChannels) ;
           end ;
        Inc(ChanNum) ;
        Inc(NodeIndex) ;
        end ;
    Prot.NumAOChannels := Min( Prot.NumAOChannels, MaxAOChannels ) ;

    // Digital output channels
    Prot.NumDOChannels := 0 ;
    NodeIndex := 0 ;
    ChanNum := 0 ;
    While FindXMLNode(ProtNode,'DIGITALOUTPUTCHANNEL',iNode,NodeIndex) do
        begin
        //ChanNum := Prot.NumDOChannels ;
        GetElementInt( iNode, 'NUMBER', ChanNum ) ;
        if (ChanNum >= 0) and (ChanNum <= High(Prot.DOHoldingLevel)) then
           begin
           GetElementInt( iNode, 'HOLDINGLEVEL', Prot.DOHoldingLevel[ChanNum] ) ;
           Inc(Prot.NumDOChannels) ;
           end ;
        Inc(ChanNum) ;
        Inc(NodeIndex) ;
        end ;
    Prot.NumDOChannels := Min( Prot.NumDOChannels, MaxDOChannels ) ;

    // Waveform elements

    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'WAVEFORMELEMENT',iNode,NodeIndex) do
        begin

        GetElementText( iNode, 'OUTPUTCHANNELTYPE', ChanType ) ;
        GetElementInt( iNode, 'OUTPUTCHANNELNUMBER', ChanNum ) ;
        GetElementInt( iNode, 'ORDER', Order );

        if ANSIContainsText( ChanType, 'ANALOG' ) then begin
           // Analog channel
           iElement := ChanNum*MaxStimElementsPerChannels + Order ;
           end
        else begin
           // Digital channel
           iElement := ChanNum*MaxStimElementsPerChannels + Order + DOElementsStart ;
           end ;

        iElement := Min( Max( iElement,0 ), High(Prot.Stimulus)) ;

        GetElementInt( iNode, 'WAVESHAPE', Prot.Stimulus[iElement].WaveShape ) ;

           // Parameters
        GetWaveformParameter( iNode, 'DELAY', spDelay, spDelayInc,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;
        GetWaveformParameter( iNode, 'STARTAMPLITUDE', spStartAmplitude, spStartAmplitudeInc,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;
        GetWaveformParameter( iNode, 'ENDAMPLITUDE', spEndAmplitude, spEndAmplitudeInc,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;
        GetWaveformParameter( iNode, 'DIGITALLEVEL', spDigAmplitude, spDigAmplitudeInc,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;
        GetWaveformParameter( iNode, 'DURATION', spDuration, spDurationInc,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;
        GetWaveformParameter( iNode, 'NUMREPEATS', spNumRepeats, spNumRepeatsInc,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;
        GetWaveformParameter( iNode, 'REPEATPERIOD', spRepeatPeriod, spRepeatPeriodInc,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;
        GetWaveformParameter( iNode, 'FREQUENCY', spFREQUENCY, spFREQUENCYInc,spFrequencyMultiplierFlag,
                              Prot.Stimulus[iElement].Parameters ) ;

        GetWaveformParameterText( iNode, 'FILENAME', spFileName,
                                  Prot.Stimulus[iElement].Parameters ) ;

        GetWaveformParameter( iNode, 'DACUPDATEINTERVAL', spDACUpdateInterval, spNone,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;

        GetWaveformParameter( iNode, 'NUMPOINTS', spNumPoints, spNumPointsInc,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;

        GetWaveformParameter( iNode, 'SCALE', spScale, spScaleInc,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;

        GetWaveformParameter( iNode, 'OFFSET', spOffset, spOffsetInc,spNone,
                              Prot.Stimulus[iElement].Parameters ) ;

        // Load user-defined waveform
        if (Prot.Stimulus[iElement].WaveShape = Ord(wvWave)) or
           (Prot.Stimulus[iElement].WaveShape = Ord(wvDigWave)) then
           begin

           // Get file name of .dat file
           WaveFileName := ExtractFileName(Prot.Stimulus[iElement].Parameters[spFileName].Text) ;
           WaveFileName := ChangeFileExt( WaveFileName, '.dat' ) ;
           WaveFileName := WCPFile.Settings.VProtDirectory + WaveFileName ;

           OK := True ;
           // Check for blank file name
           if WaveFileName = '' then OK := False ;

           // Check that waveform text file exists
           if OK then begin
              OK := FileExists( WaveFileName ) ;
              if not OK then ShowMessage('Stimulus Protocol: Unable to load ' + WaveFileName ) ;
              end ;

           // Load DAT file
           if OK then OK := LoadWaveformFromDATFile(Prot,iElement) ;

           if not OK then Prot.Stimulus[iElement].NumPointsInBuf := 0 ;

           end ;

        Inc(NodeIndex) ;

        end ;

    XMLDoc.Active := False ;
    XMLDoc := Nil ;

    end ;


function TStimulator.LoadWaveformFromTextFile(
          var Prot : TStimulusProtocol ;           // Protocol record to be loaded
          iElement : Integer ;                     // Element to be loaded
          FileName : String
          ) : Boolean ;                             // TRUE if successful load
// ----------------------------
// Load waveform from text file
// ----------------------------
var
    F: TextFile;
    BinFileName : String ;
    iFileHandle : Integer ;
    dt,TOld : single ;
    nValues : Integer ;
    Values : Array[0..10] of single ;
    s : String ;
    NumPoints : Integer ;
begin

     Result := False ;

     if not FileExists(FileName) then Exit ;

     // Create binary output file
     BinFileName := WCPFile.Settings.VProtDirectory +
                    ChangeFileExt(ExtractFileName(FileName),'.DAT') ;

     // Open text input file
     AssignFile(F, FileName);
     Reset(F);

     iFileHandle := FileCreate( BinFileName ) ;
     if iFileHandle < 0 then begin
        ShowMessage('Unable to create' + BinFileName ) ;
        Exit ;
        end ;

     NumPoints := 0 ;
     TOld := 0.0 ;
     dt := 1.0 ;
     repeat
            // Read line
            ReadLn( F, s ) ;

            { Extract number from row }
            nValues := ExtractListOfFloats( s, Values, False ) ;

            if nValues > 1 then begin
               // ( >1 column, use 1st column as time, 2nd as waveform amplitud
               if NumPoints = 0 then TOld := Values[0]
               else if NumPoints = 1 then dt := Values[0] - TOld ;
               FileWrite( iFileHandle, Values[1], SizeOf(Single) ) ;
               end
            else begin
               // One column of data (use as waveform amplitude)
               FileWrite( iFileHandle, Values[0], SizeOf(Single) ) ;
               end ;

            Inc(NumPoints) ;

            until EOF(F)  ;

     // Close files
     FileClose( iFileHandle ) ;
     CloseFile(F) ;

     // Save D/A update interval and file name in protocol element
     Prot.Stimulus[iElement].Parameters[spDACUpdateInterval].Value := dt ;
     Prot.Stimulus[iElement].Parameters[spFileName].Text := ExtractFileName(FileName) ;
     Prot.Stimulus[iElement].Parameters[spNumPoints].Value := NumPoints ;
     Prot.Stimulus[iElement].Parameters[spNumPointsInc].Value := 0 ;

     // Load waveform from DAT file
     Result := LoadWaveformFromDATFile(Prot,iElement) ;

     end;


function TStimulator.LoadWaveformFromDATFile(
          var Prot : TStimulusProtocol ;           // Protocol record to be loaded
          iStimElement : Integer
          ) : Boolean ;
// ------------------------------
// Load waveform from binary file
// ------------------------------
var
    FileHandle : Integer ;
    NumBytes : Integer ;
    FileName : String ;
begin

     Result := False ;

     // Exit if this stimulus is not an externally defined wave
     if  (Prot.Stimulus[iStimElement].WaveShape <> Ord(wvWave)) and
         (Prot.Stimulus[iStimElement].WaveShape <> Ord(wvDigWave)) then begin
         //Prot.Stimulus[iStimElement].NumPoints := 0 ;
         Exit ;
         end ;

     // Exit if file name blank
     FileName := Prot.Stimulus[iStimElement].Parameters[spFileName].Text ;
     if FileName = '' then begin
        Prot.Stimulus[iStimElement].NumPointsInBuf := 0 ;
        Exit ;
        end ;

     // Exit if unable to find file
     FileName := WCPFile.Settings.VProtDirectory + ChangeFileExt( ExtractFileName(FileName), '.dat' ) ;
     if not FileExists(FileName) then begin
        ShowMessage('Stimulus Protocol: Unable to load ' + FileName ) ;
        Prot.Stimulus[iStimElement].NumPointsInBuf := 0 ;
        Exit ;
        end ;

     // Open DAT file

     FileHandle := FileOpen( FileName, fmOpenRead ) ;
     if FileHandle < 0 then begin
        ShowMessage('Stimulus Protocol: Unable to load ' + FileName ) ;
        Prot.Stimulus[iStimElement].NumPointsInBuf := 0 ;
        Exit ;
        end ;

     // Determine size of file / no. points in it
     NumBytes := FileSeek( FileHandle, 0, 2 ) ;
     Prot.Stimulus[iStimElement].NumPointsInBuf := NumBytes div SizeOf(Single) ;

     // Allocate buffer
     if Prot.Stimulus[iStimElement].Buf <> Nil then begin
        FreeMem(Prot.Stimulus[iStimElement].Buf) ;
        end ;
     GetMem( Prot.Stimulus[iStimElement].Buf, NumBytes ) ;

     // Copy waveform data into buffer
     FileSeek( FileHandle, 0, 0 ) ;
     FileRead( FileHandle, Prot.Stimulus[iStimElement].Buf^, NumBytes ) ;

     // Close file
     FileClose( FileHandle ) ;

     Result := True ;

     end ;


procedure TStimulator.SaveWaveformToDATFile(
          var Prot : TStimulusProtocol ;           // Protocol record
          iStimElement : Integer                   // Element to be saved
          ) ;
// ------------------------------
// Save waveform to binary file
// ------------------------------
var
    FileHandle : Integer ;
    FileName : String ;
begin

     // Exit if this stimulus is not an externally defined wave
     if  (Prot.Stimulus[iStimElement].WaveShape <> Ord(wvWave)) and
         (Prot.Stimulus[iStimElement].WaveShape <> Ord(wvDigWave)) then begin
         Exit ;
         end ;

     if Prot.Stimulus[iStimElement].Buf = Nil then Exit ;

     // Create DAT file
     FileName := WCPFile.Settings.VProtDirectory + ChangeFileExt(ExtractFileName(
                 Prot.Stimulus[iStimElement].Parameters[spFileName].Text),'.DAT') ;
     FileHandle := FileCreate( FileName ) ;
     if FileHandle < 0 then begin
        ShowMessage('Unable to create ' + FileName ) ;
        Exit ;
        end ;

     // Write waveform to file
     FileSeek( FileHandle, 0, 0 ) ;
     FileWrite( FileHandle, Prot.Stimulus[iStimElement].Buf^,
                Prot.Stimulus[iStimElement].NumPointsInBuf*SizeOf(Single) ) ;

     // Close file
     FileClose( FileHandle ) ;

     end ;


procedure TStimulator.AddWaveformParameter(
          ParentNode : IXMLNode ;                 // Parent node
          ParameterName : string ;                // Element name
          iValue : Integer ;                      // Parameter value index # in ParList
          iIncrement : Integer ;                  // Parameter increment index # in ParList
          iMultiplierFlag : Integer ;             // Use Parameter increment as multipler index # in ParList
          ParList : Array of TStimulusParameter   // Parameter array
          ) ;
var
    iNode : IXMLNode ;
begin

     if ParList[iValue].Exists then
        begin

        iNode := ParentNode.AddChild( ParameterName ) ;

        AddElementFloat( iNode, 'VALUE', ParList[iValue].Value ) ;

        if iIncrement >= 0 then
           begin
           if ParList[iIncrement].Exists then begin
              AddElementFloat( iNode, 'INCREMENT', ParList[iIncrement].Value ) ;
              end ;
           end ;

        if iMultiplierFlag >= 0 then
           begin
           if ParList[iMultiplierFlag].Exists then
              begin
              AddElementFloat( iNode, 'MULTIPLIERFLAG', ParList[iMultiplierFlag].Value ) ;
              end ;
           end ;
        end ;

end ;


procedure TStimulator.AddWaveformParameterText(
          ParentNode : IXMLNode ;                 // Parent node
          ParameterName : string ;                // Element name
          iValue : Integer ;                      // Parameter value index # in ParList
          ParList : Array of TStimulusParameter   // Parameter array
          ) ;
var
    iNode : IXMLNode ;
begin

     if ParList[iValue].Exists then
        begin
        iNode := ParentNode.AddChild( ParameterName ) ;
        AddElementText( iNode, 'VALUE', ParList[iValue].Text ) ;
        end ;

end ;


procedure TStimulator.GetWaveformParameter(
          ParentNode : IXMLNode ;                 // Parent node
          ParameterName : string ;                // Element name
          iValue : Integer ;                      // Parameter value index # in ParList
          iIncrement : Integer ;                  // Parameter increment index # in ParList
          iMultiplierFlag : Integer ;        // Use Parameter increment as multipler index # in ParList
          var ParList : Array of TStimulusParameter   // Parameter array
          ) ;
// ------------------------------
// Get waveform element parameter
// ------------------------------
var
    ChildNode : IXMLNode ;
    NodeIndex : Integer ;
    Value : Single ;
begin

    ParList[iValue].Exists := False ;
    if iIncrement >= 0 then ParList[iIncrement].Exists := False ;

    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,ParameterName,ChildNode,NodeIndex) then
       begin

       // Get value
       if GetElementFloat( ChildNode, 'VALUE', Value ) then
          begin
          ParList[iValue].Value := Value ;
          ParList[iValue].Exists := True ;
          end ;

       // Get increment (if required)
       if iIncrement >= 0 then
          begin
          if GetElementFloat( ChildNode, 'INCREMENT', Value ) then
             begin
             ParList[iIncrement].Value := Value ;
             ParList[iIncrement].Exists := True ;
             end ;
          end ;

       // Get multipler flag (1.0=TRUE) (if required)
       if iMultiplierFlag >= 0 then
          begin
          if GetElementFloat( ChildNode, 'MULTIPLIERFLAG', Value ) then
             begin
             ParList[iMultiplierFlag].Value := Value ;
             ParList[iMultiplierFlag].Exists := True ;
             end ;
          end ;

       end;

     end ;


procedure TStimulator.GetWaveformParameterText(
          ParentNode : IXMLNode ;                 // Parent node
          ParameterName : string ;                // Element name
          iValue : Integer ;                      // Parameter value index # in ParList
          var ParList : Array of TStimulusParameter   // Parameter array
          ) ;
// ------------------------------
// Get waveform element parameter
// ------------------------------
var
    ChildNode : IXMLNode ;
    NodeIndex : Integer ;
    Value : String ;
begin

    ParList[iValue].Exists := False ;

    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,ParameterName,ChildNode,NodeIndex) then begin
       // Get value
       if GetElementText( ChildNode, 'VALUE', Value ) then begin
          ParList[iValue].Text := Value ;
          ParList[iValue].Exists := True ;
          end ;
       end ;

     end ;


procedure TStimulator.AddElementFloat(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Single
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := format('%.10g',[Value]) ;

    end ;


function TStimulator.GetElementFloat(
         ParentNode : IXMLNode ;
         NodeName : String ;
         var Value : Single
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   OldValue : Single ;
   NodeIndex : Integer ;
   s,dsep : string ;
begin
    Result := False ;
    OldValue := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       { Correct for use of comma/period as decimal separator }
       s := ChildNode.Text ;
      { Correct for use of comma/period as decimal separator }
      {$IF CompilerVersion > 7.0} dsep := formatSettings.DECIMALSEPARATOR ;
      {$ELSE} dsep := DECIMALSEPARATOR ;
      {$IFEND}
      if dsep = '.' then s := ANSIReplaceText(s ,',',dsep);
      if dsep = ',' then s := ANSIReplaceText(s, '.',dsep);
       try
          Value := StrToFloat(s) ;
          Result := True ;
       except
          Value := OldValue ;
          Result := False ;
          end ;
       end ;

    end ;


procedure TStimulator.AddElementInt(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Integer
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := format('%d',[Value]) ;

    end ;


function TStimulator.GetElementInt(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : Integer
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
   OldValue : Integer ;
begin
    Result := False ;
    OldValue := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       try
          Value := StrToInt(ChildNode.Text) ;
          Result := True ;
       except
          Value := OldValue ;
          Result := False ;
          end ;
       end ;
    end ;


procedure TStimulator.AddElementBool(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Boolean
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    if Value = True then ChildNode.Text := 'T'
                    else ChildNode.Text := 'F' ;

    end ;


function TStimulator.GetElementBool(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : Boolean
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
begin
    Result := False ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       if ANSIContainsText(ChildNode.Text,'T') then Value := True
                                               else  Value := False ;
       Result := True ;
       end ;

    end ;


procedure TStimulator.AddElementText(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : String
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := Value ;

    end ;


function TStimulator.GetElementText(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : String
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
begin

    Result := False ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       Value := ChildNode.Text ;
       Result := True ;
       end ;

    end ;


function TStimulator.FindXMLNode(
         const ParentNode : IXMLNode ;  // Node to be searched
         NodeName : String ;            // Element name to be found
         var ChildNode : IXMLNode ;     // Child Node of found element
         var NodeIndex : Integer        // ParentNode.ChildNodes Index #
                                        // Starting index on entry, found index on exit
         ) : Boolean ;
// -------------
// Find XML node
// -------------
var
    i : Integer ;
begin

    Result := False ;
    for i := NodeIndex to ParentNode.ChildNodes.Count-1 do begin
      if ParentNode.ChildNodes[i].NodeName = WideString(NodeName) then begin
         Result := True ;
         ChildNode := ParentNode.ChildNodes[i] ;
         NodeIndex := i ;
         Break ;
         end ;
      end ;
    end ;



end.
