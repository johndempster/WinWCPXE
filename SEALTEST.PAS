unit Sealtest;
{ ==================================================
  WinEDR - Patch clamp pipette seal test module
  (c) J. Dempster, University of Strathclyde 1996-97
  3/6/98 ... V1.1 Modified from WinWCP V2.1
             (Includes fix for 0V glitches with digidata 1200)
  22/3/99 ... TScopeDisplay now used to display signal
  9/6/99 ...  Now uses WinRT device driver for Digidata 1200
  19/8/99 ... Incorporated into WinWCP V3.0
  1/9/99 ... ChangeDisplayGrid added
  4/9/99 ... Problems with -10080 error when A/D converter voltage range invalid
             now fixed
  14/9/00 ... Resistance now switches MOhm/Gohm
  23/11/00 ... Scaling error in Holding Voltage #3 fixed
  19/1/01 ... Error in calculation of IPulse corrected
  31/2/02 ... Cell access resistance now calculated
  19/02/01 ... Capacity measurement nearly fixed
  14/8/01 .... Elapsed timer added
               FP errors when pulse step is small now trapped
               Window is now resizable
               FP error when maximised now fixed
  20/12/01 ... D/A and digital default values now set using Main.WriteOutputPorts (V3.2.1)
  13/2/02 .... Intermittent floating point errors with Windows 2000 fixed
               Resistance and other readouts only updated if they have
               valid data now
  18/3/02 .... A/D buffer empty flags now alternate positive and negative
               to avoid potential hang-up when 16 A/D resolution value
               equals empty flag value.
  16.4.03 .... Sweep now terminates correctly when A/D input = emptyflag
  28.4.03 .... Seal test pulse should now start automatically
  24.6.03 ... No. of display grid lines can be changed
  25.8.03 ... Auto-Display magnification now different for each channel
  7.9.03 .... Lo limits now specific for current, voltage and membrane parameters
  10.9.03 ... edGaccess FP error fixed
  05.02.04 .. DAC 1 Trigger pulse can now be inverted
  10.03.04 .. Floating point errors now trapped in AnalyseTestPulse
  11.06.04 .. Cell parameters LP filter now faster (0.1/0.9)
  08.08.04 .. Current and voltage channels now set automatically
              when channel units switch.
  01.10.04 .. Pulse #1..#3 now set correctly when seal test window opened
              Cell parameters can now be written to log file
  16.12.04 .. Manual display scale settings now updated correctly when form opened
  15.04.05 .. Voltage pulses no longer wrap round at high/low voltages
  10.09.05 .. Manual gain entry now works for both Amplifier 1 and 2
  04.11.05 .. Gaccess now estimated from initial amplitude of exponential
              fit to decaying capacity current
  09.12.05 .. Holding potentials now set for Amplifier #2
              TestPulseAmplitude, HoldingVoltage can now be set via properties
  13.12.05 .. Readout smoothing factor can now be changed (.SmoothingFactor property added)
  14.12.05 .. Window can now made smaller
  16.06.06 .. Now updates display when channel name changed
  25.07.06 .. Recording channel settings now stored in RecChannel and Settings (global.pas)
  15.08.06 .. Displayed trace maintained on screen until next one is available
  05.09.06 .. Im/Vm readout selection list now updated on first sweep
  06.04.07 .. Amplifier gain factor now updated correct when Amplifier= None or Manual
              Channel[].ADCAmplifierGain setting no longer altered
  14.08.07 .. Display magnification now controlled with buttons when
              autoscale turned off.
  28.01.08 .. Test pulse can now be switched between DAC 0 and DAC 1
  02.06.08 .. Gain settings of both amplifiers now displayed
              Activation of seal test form now disables record form (and vice versa)
  10.07.08 .. Pulse #3 now includes a test pulse
              Seal test pulse selection updated. Selected pulse remembered correctly
              when returning to Seal Test window
              Display traces can be sized vertically and disabled
              Display ticks now chosen from 1,2, or 5 unit steps
  24.05.10 .. Channel visibility setting now preserved in RecChannel[].InUse when window closer
  25.06.10 .. DAC update interval no longer fixed at 1 ms.
  06.01.11 .. TritonPanelFrm opened automatically when record form is displayed
              when a Tecella amplifier is in use.
  03.06.11 .. Supports up to 4 amplifiers and current and voltage stimuli
  16.01.12 .. Duration of stimulus pulse now determined from ChIm in Iclamp mode and ChVm in Vclamp mode
  24.01.12 .. Pulse amplitudes in seal test now located correctly when holding potential non-zero
              Fixes bug introduced 16.01.12
  14.03.12 .. Output channels for test pulse now selected by check box and pulse can be
              applied to additional channels by ticking boxes.
  17.04.12 .. No. of input channels displayed can now be selected from menu.
  06.09.13 .. EPC9PanelFrm opened if EPC9/10 patch clamp in use.
  21.01.14 .. Sweep shuts down on FormDeactivate to avoid access violations
              when EPC9PanelFrm title bar held down.
  09.07.15 .. DACScale arrays increased to cope with up to 128 analog output channels
  02.10.15 .. Zap pulse added to panel
  05.11.15 .. HekaEPC9USB interface added
  05.08.16 .. Holding potential setting in use now updated with default holding potential of selected amplifier
              (Change to SetCLampMode)
  20.07.17 .. Sweep now goes into idle mode if A/D conversion fails to become active
              Amplifier.GetChannelSettings() now returns ADCInput, so
              secondary channel analogue input for be changed in CC mode
              for Axopatch 200 and AMS-2400
  27.04.18 .. Holding levels now calculated from 5% of sweep preceding test pulse (rather than 1st 5%)
              to avoid errors created when transition exists at beginning
  03.09.18 .. End of holding level calculation range now shifted DacDT earlier
              to prevent it extending into test pulse interval when
              DACDT greater than A/D sampling interval
  17.04.19    Reset Avg. button added to reset pipette reistance readout
              StartADCandDAC() now also resets readout average
  20.05.19    Cell parameter averages now computed using ring buffer instead of smoothing factor
  22.05.19    Pipette Resistance and cell parameters now have separate averaging counter
              Large incorrect measurements of Ga,Gm,Cm due to noise/interference now excluded
              from average and average restricted to most recent <n> measurements. G access computation mode
              (from peak or exponential amplitude) option setting now preserved in INI file and can be set
              by .SealTestGaFromPeak Active X command. No. of cell parameter measurements averaged can now be set by
              .SealTestNumAverages command. Ga,Gm,Cm etc. now displayed as 0 if no data available.

  ==================================================}

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, global, shared, SysUtils, Spin,
  math, maths, dialogs,
  ValEdit, ScopeDisplay, SESLabIO, ComCtrls, ValidatedEdit, FileIO,ampmodule, strutils ;

const
    Idle = 0 ;
    StartSweep = 1 ;
    SweepInProgress = 2;
    EndofSweep = 3 ;
    MaxAverage = 100 ;
type
  //TState = ( Idle, StartSweep, SweepInProgress, EndofSweep ) ;

  TTestPulse = record
               Duration : single ;
               TStart : single ;
               TEnd : Single ;
               RecordLength : single ;
               RepeatPeriod : single ;
               end ;

  TSealTestFrm = class(TForm)
    AmplifierGrp: TGroupBox;
    cbCurrentChannel: TComboBox;
    Label1: TLabel;
    cbVoltageChannel: TComboBox;
    Label2: TLabel;
    VoltsGrp: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    CurrentGrp: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    CellGrp: TGroupBox;
    Timer: TTimer;
    PulseGrp: TGroupBox;
    rbUseHoldingVoltage1: TRadioButton;
    rbUseHoldingVoltage2: TRadioButton;
    Label3: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label4: TLabel;
    rbUseHoldingVoltage3: TRadioButton;
    Label13: TLabel;
    Shape1: TShape;
    edHoldingVoltage1: TValidatedEdit;
    edPulseHeight1: TValidatedEdit;
    edHoldingVoltage2: TValidatedEdit;
    edPulseHeight2: TValidatedEdit;
    edHoldingVoltage3: TValidatedEdit;
    edPulseWidth: TValidatedEdit;
    edVHold: TValidatedEdit;
    edVPulse: TValidatedEdit;
    edIHold: TValidatedEdit;
    edIPulse: TValidatedEdit;
    scDisplay: TScopeDisplay;
    CellParametersPage: TPageControl;
    PipetteTab: TTabSheet;
    Label9: TLabel;
    edResistance: TValidatedEdit;
    CellTab: TTabSheet;
    Label15: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    edGaccess: TValidatedEdit;
    edGmembrane: TValidatedEdit;
    edCmembrane: TValidatedEdit;
    TimerGrp: TGroupBox;
    edTimer: TEdit;
    bResetTimer: TButton;
    bSaveToLog: TButton;
    GroupBox2: TGroupBox;
    rbGaFromPeak: TRadioButton;
    rbGaFromExp: TRadioButton;
    ckAutoScale: TCheckBox;
    edPulseheight3: TValidatedEdit;
    Label20: TLabel;
    cbAmplifier: TComboBox;
    lbAmplifier1: TLabel;
    edAmplifierGain: TValidatedEdit;
    GroupBox3: TGroupBox;
    rbIclamp: TRadioButton;
    rbVclamp: TRadioButton;
    GroupBox4: TGroupBox;
    ckPulseToAO0: TCheckBox;
    ckPulseToAO1: TCheckBox;
    ckPulseToAO2: TCheckBox;
    ckPulseToAO3: TCheckBox;
    ChannelsGrp: TGroupBox;
    cbNumChannels: TComboBox;
    Label10: TLabel;
    CellRTab: TTabSheet;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    edRAccess: TValidatedEdit;
    edRMembrane: TValidatedEdit;
    edCMembrane1: TValidatedEdit;
    edNumAverages: TValidatedEdit;
    Label22: TLabel;
    ZapGrp: TGroupBox;
    bzap: TButton;
    edZapAmplitude: TValidatedEdit;
    edZapDuration: TValidatedEdit;
    Label23: TLabel;
    Label24: TLabel;
    bResetAverage: TButton;
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edHoldingVoltage1KeyPress(Sender: TObject; var Key: Char);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edHoldingVoltage2KeyPress(Sender: TObject; var Key: Char);
    procedure rbUseHoldingVoltage1Click(Sender: TObject);
    procedure rbUseHoldingVoltage2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure edPulseHeight1KeyPress(Sender: TObject; var Key: Char);
    procedure edPulseheight2KeyPress(Sender: TObject; var Key: Char);
    procedure edPulseWidthKeyPress(Sender: TObject; var Key: Char);
    procedure rbUseHoldingVoltage3Click(Sender: TObject);
    procedure EdHoldingVoltage3KeyPress(Sender: TObject; var Key: Char);
    procedure bResetTimerClick(Sender: TObject);
    procedure cbCurrentChannelChange(Sender: TObject);
    procedure bSaveToLogClick(Sender: TObject);
    procedure edAmplifierGainKeyPress(Sender: TObject; var Key: Char);
    procedure rbGaFromPeakClick(Sender: TObject);
    procedure rbGaFromExpClick(Sender: TObject);
    procedure edPulseheight3KeyPress(Sender: TObject; var Key: Char);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure cbAmplifierChange(Sender: TObject);
    procedure rbVclampClick(Sender: TObject);
    procedure rbIclampClick(Sender: TObject);
    procedure cbNumChannelsChange(Sender: TObject);
    procedure edNumAveragesKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure bzapClick(Sender: TObject);
    procedure edZapAmplitudeKeyPress(Sender: TObject; var Key: Char);
    procedure edZapDurationKeyPress(Sender: TObject; var Key: Char);
    procedure bResetAverageClick(Sender: TObject);
  private
    { Private declarations }
  Initialised : Boolean ;
  ADC : PSmallIntArray ;
  DAC : PSmallIntArray ;
  EndOfBuf : Integer ;
  ChangeDisplayScaling : Boolean ;
  EndOfSweepCount : Integer ;
  FirstSweep : Boolean ;
  ResetReadout : Boolean ;
  NumTestChannels : Integer ;
  TestPulse : TTestPulse ;
  DACScale : Array[0..MaxDACChannels-1] of single ;
  DACdt : Single ;
  TestDAC : Integer ;                      // DAC channel with seal test
  TimerBusy : boolean ;
  EmptyFlag : Integer ;
  nDACValues : Integer ;
  TimerStarted : Integer ;
  NewAmplifierGain : Boolean ;
  ClampMode : Array[0..MaxAmplifiers-1] of Integer ;

  DisplayScale : Array[0..WCPMaxChannels-1] of Integer ;

  // Cell parameter averaging arrays
  iResistance : Integer ;                            // Averaging buffer pointer
  NumResistances : Integer ;                         // No. averages available
  Resistance : Array[0..MaxAverage-1] of Single ;
  iAverage : Integer ;                            // Averaging buffer pointer
  NumAverages : Integer ;                         // No. averages available
  GAccess : Array[0..MaxAverage-1] of Single ;
  GMembrane : Array[0..MaxAverage-1] of Single ;
  Capacity : Array[0..MaxAverage-1] of Single ;

    procedure CreateTestPulse ;
    procedure AnalyseTestPulse ;
    procedure UpdateChannelLists ;
    procedure SetClampMode ;

    procedure SetPulseOutChannel( AOChan : Integer ) ;
    function OutChannelSelected( AOChan : Integer ) : Boolean ;

    procedure SetTestPulseAmplitude( i : Integer ; Value : Single ) ;
    function  GetTestPulseAmplitude( i : Integer ) : Single ;
    procedure SetHoldingVoltage( i : Integer ; Value : Single ) ;
    function  GetHoldingVoltage( i : Integer ) : Single ;
    procedure SetTestPulseWidth( Value : Single ) ;
    function  GetTestPulseWidth : Single ;
    procedure SetTestPulseNumber( Value : Integer ) ;
    function  GetTestPulseNumber : Integer ;
    procedure SetSmoothingFactor( Value : Single ) ;
    function  GetSmoothingFactor : Single ;
    function GetRunning : Boolean ;

    procedure InitialiseDisplay ;
    procedure ChangeUnits( var EditBox : TValidatedEdit ;
              NewUnits : String ;
              NewScale : Single ) ;
    procedure DisplayClampMode ;

    function Average(
          Buf : Array of Single ; // Array of measurements to be averaged
          NumPoints : Integer ;   // No. of points to average
          OldAverage : single      // Previous avg. (returned when NumAverage = 0)
          ) : single ;


  public
    { Public declarations }
    t0 : integer ;
    t0max : integer ;
    State : Integer ;
    LoadEPC9Panel : Boolean ;
    procedure StopADCandDAC ;
    procedure StartADCandDAC ;
    procedure ChangeDisplayGrid ;
    procedure ZoomOut ;
    Property TestPulseAmplitude[i : Integer] : Single read GetTestPulseAmplitude
                                                      write SetTestPulseAmplitude ;
    Property HoldingVoltage[i : Integer] : Single read GetHoldingVoltage
                                                  write SetHoldingVoltage ;
    Property TestPulseWidth : Single read GetTestPulseWidth
                                     write SetTestPulseWidth ;
    Property TestPulseNumber : Integer read GetTestPulseNumber
                                       write SetTestPulseNumber ;
    Property SmoothingFactor : Single read GetSmoothingFactor
                                      write SetSmoothingFactor ;
    Property Running : Boolean read GetRunning ;

  end ;
var
  SealTestFrm: TSealTestFrm;

implementation

{$R *.DFM}

uses Mdiform, mmsystem , Rec, TritonPanelUnit, EPC9PanelUnit;

const
     //NumDACChannels = 2 ;
     NumTestSamples = 512 ;
     MinDACInterval = 0.0002 ;
     MinPulseWidth = 0.0001 ;
     MaxPulseWidth = 1.0 ;
     MinTestChannels = 2 ;
     CurrentClampUnits = 'pA' ;
     CurrentClampScale = 1E12 ;
     VoltageClampUnits = 'mV' ;
     VoltageClampScale = 1E3 ;

procedure TSealTestFrm.FormShow(Sender: TObject);
{ ----------------
  Initialise form
  ---------------}
var
   i,ch : Integer ;
begin
     t0 := 0 ;
     t0Max := 0 ;
     // Exit if no interface selected
     if (Main.SESLabIO.LabInterfaceType = NoInterface12) or
        (Main.SESLabIO.LabInterfaceType = NoInterface16) then begin
        ShowMessage( 'No laboratory interface selected!' ) ;
        Close ;
        Exit ;
        end ;

     // Display Triton control panel if it is not open
     case Main.SESLabIO.LabInterfaceType of
          Triton : begin
             if not Main.FormExists( 'TritonPanelFrm' ) then begin
                Main.mnTriton.Enabled := True ;
                Main.mnTriton.Click ;
                end ;
             end ;
          HekaEPC9,HekaEPC10,HekaEPC10Plus,HekaEPC10USB,HekaEPC9USB : begin
             if not Main.FormExists( 'EPC9PanelFrm' ) then begin
                Main.mnEPC9Panel.Enabled := True ;
                Main.mnEPC9Panel.Click ;
                end ;
             end ;
          end;

     ClientWidth := ZapGrp.Left + ZapGrp.Width + 5 ;

     { Get pointers to start of lab. interface A/D and D/A buffer }
     Main.SESLabIO.GetADCBuffer( ADC ) ;
     Main.SESLabIO.GetDACBuffer( DAC ) ;
     EmptyFlag := Main.SESLabIO.ADCEmptyFlag ;

     { Check that the selected hardware/software is available }
     if not Main.SESLabIO.LabInterfaceAvailable then begin
        ShowMessage( 'Laboratory interface not available!' ) ;
        Close ;
        Exit ;
        end ;

     { Stop laboratory interface activity }
     if Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
     if Main.SESLabIO.DACActive then Main.SESLabIO.DACStop ;

     // Amplifier
     cbAmplifier.Clear ;
     for i := 0 to MaxAmplifiers-1 do begin
         cbAmplifier.Items.Add(format('#%d. %s',[i+1,Amplifier.ModelName[i]])) ;
         end ;
     cbAmplifier.ItemIndex := 0 ;

     // No. of display channels
     NumTestChannels := 2 ;
     for i := 1 to MaxAmplifiers-1 do if Amplifier.AmplifierType[i] <> amNone then
        NumTestChannels := NumTestChannels + 2 ;
     cbNumChannels.Clear ;
     for i := 1 to Main.SESLabIO.ADCMaxChannels do begin
         cbNumChannels.Items.Add(format(' %d',[i]));
         end ;
     cbNumChannels.ItemIndex := NumTestChannels-1 ;

     scDisplay.ClearHorizontalCursors ;
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;
     for ch := 0 to NumTestChannels-1 do begin
         Main.SESLabIO.ADCChannelZero[ch] := 0 ;
         { Create horizontal cursors }
         scDisplay.AddHorizontalCursor(ch,Settings.Colors.Cursors,True,'z') ;
         scDisplay.yMax[ch] := Main.SESLabIO.ADCMaxValue ;
         scDisplay.yMin[ch] := Main.SESLabIO.ADCMinValue ;
         end ;

     // Ensure no. of cell parameter averages is valid
     Settings.SealTest.NumAverages := Min(Max(Settings.SealTest.NumAverages,1),MaxAverage) ;
     edNumAverages.Value := Settings.SealTest.NumAverages ;

     // Gaccess calculation mode
     rbGaFromPeak.Checked := Settings.SealTest.GaFromPeak ;
     rbGaFromExp.Checked := not Settings.SealTest.GaFromPeak ;

     scDisplay.xMin := 0 ;
     scDisplay.xMax := NumTestSamples-1  ;

     scDisplay.TUnits := Settings.TUnits ;

     // Show available output channels
     ckPulseToAO0.Visible := False ;
     ckPulseToAO1.Visible := False ;
     ckPulseToAO2.Visible := False ;
     ckPulseToAO3.Visible := False ;
     if Main.SESLabIO.DACMaxChannels >= 1 then ckPulseToAO0.Visible := True ;
     if Main.SESLabIO.DACMaxChannels >= 2 then ckPulseToAO1.Visible := True ;
     if Main.SESLabIO.DACMaxChannels >= 3 then ckPulseToAO2.Visible := True ;
     if Main.SESLabIO.DACMaxChannels >= 4 then ckPulseToAO3.Visible := True ;

     { Set current channel selection combo boxes }
     UpdateChannelLists ;

     // Select amplifier #1
     SetClampMode ;

     { Test pulse amplitude & width }
     edPulseHeight1.Value := Settings.SealTest.PulseHeight1 ;
     edPulseHeight2.Value := Settings.SealTest.PulseHeight2 ;
     edPulseHeight3.Value := Settings.SealTest.PulseHeight3 ;
     edPulseWidth.Value := Settings.SealTest.PulseWidth ;

     { Update holding potential text boxes }


     edHoldingVoltage1.Value := Settings.SealTest.HoldingVoltage1 ;
     edHoldingVoltage2.Value := Settings.SealTest.HoldingVoltage2 ;
     edHoldingVoltage3.Value := Settings.SealTest.HoldingVoltage3 ;

     edZapAmplitude.Value := Settings.SealTest.ZapAmplitude ;
     edZapDuration.Value := Settings.SealTest.ZapDuration ;

     { Select test pulse to use }
     case Settings.SealTest.Use of
          2 : rbUseHoldingVoltage2.checked := True ;
          3 : rbUseHoldingVoltage3.checked := True ;
          else rbUseHoldingVoltage1.checked := True ;
          end ;

     // Auto/manual display scaling
     ckAutoScale.checked := True ;

     ChangeDisplayScaling := True ;

     // Set no. of horizontal/vertical lines in display grid
     ChangeDisplayGrid ;

     // Initialise elapsed time readout
     TimerStarted := TimeGetTime ;

     Timer.Enabled := True ;
     TimerBusy := False ;
     ResetReadout := True ;
     FirstSweep := True ;
     State := idle ;//StartSweep ;
     NewAmplifierGain := True ;
     iAverage := 0 ;
     NumAverages := 0 ;
     iResistance := 0 ;
     NumResistances := 0 ;
     edGAccess.Value := 0.0 ;
     edGMembrane.Value := 0.0 ;
     edCMembrane.Value := 0.0 ;
     edRMembrane.Value := 0.0 ;


     // Clear display
     InitialiseDisplay ;
     for ch := 0 to scDisplay.NumChannels-1 do begin
         scDisplay.ChanVisible[ch] := Main.SESLabIO.ADCChannelVisible[ch] ;
         end ;

     Resize ;
     State := StartSweep ;
     Initialised := True ;
     end ;


procedure TSealTestFrm.UpdateChannelLists ;
// --------------------------------------
// Update current & voltage channel lists
// --------------------------------------
var
    ch : Integer ;
begin

     { Fill current & voltage channel selection combo boxes }
     cbCurrentChannel.Clear ;
     cbVoltageChannel.Clear ;
     for ch := 0 to NumTestChannels-1 do begin
         cbCurrentChannel.Items.Add(format('Ch.%d %s',
                                    [ch,Main.SESLabIO.ADCChannelName[ch]]));
         cbVoltageChannel.Items.Add(format('Ch.%d %s',
                                    [ch,Main.SESLabIO.ADCChannelName[ch]]));
         end ;
     cbCurrentChannel.ItemIndex := 0 ;
     cbVoltageChannel.ItemIndex := Max(1,NumTestChannels-1) ;

     // Set
     for ch := NumTestChannels-1 downto 0 do begin
         // Current channel (units = pA,nA,uA)
         if ANSIContainsText(Main.SESLabIO.ADCChannelUnits[ch],'A') then
            cbCurrentChannel.ItemIndex := ch ;
         // Voltage channel (units= mV)
         if ANSIContainsText(Main.SESLabIO.ADCChannelUnits[ch],'V') then
            cbVoltageChannel.ItemIndex := ch ;
         end ;

     end ;


procedure TSealTestFrm.TimerTimer(Sender: TObject);
{ ---------------------
  Timed Event scheduler
  ---------------------}

var
   ch,T : Integer ;
   OldADCUnits : Array[0..WCPMaxChannels-1] of String ;
   OldADCName : Array[0..WCPMaxChannels-1] of String ;
   Changed : Boolean ;
   Name,Units : string ;
   VPU,Gain : Single ;
   ADCInput : Integer ;
begin

     if not TimerBusy then begin
          TimerBusy := True ;

          if LoadEPC9Panel then begin
               Main.mnEPC9Panel.Enabled := True ;
                Main.mnEPC9Panel.Click ;
                LoadEPC9Panel := False ;
                end ;
          case State of

               StartSweep : Begin
//                   if t0 = 0 then t0 := timegettime;
//                   t0max := Max(timegettime-t0,t0max) ;
//                   outputdebugstring(pchar(format('%d %d',[timegettime-t0, t0max])));
//                   t0 := timegettime ;

                   { Start recording sweep(s) }

                   if cbCurrentChannel.ItemIndex >= 0 then
                      Settings.SealTest.CurrentChannel := cbCurrentChannel.ItemIndex ;
                   if cbVoltageChannel.ItemIndex >= 0 then
                      Settings.SealTest.VoltageChannel := cbVoltageChannel.ItemIndex ;

                   // Save old channel units
                   for ch := 0 to NumTestChannels-1 do begin
                       OldADCUnits[ch] := Main.SESLabIO.ADCChannelUnits[ch] ;
                       OldADCName[ch] := Main.SESLabIO.ADCChannelName[ch] ;
                       end ;

                   // Update channel scaling factors in case amplifier gain has changed
                   for ch := 0 to NumTestChannels-1 do begin
                       Name := Main.SESLabIO.ADCChannelName[ch] ;
                       Units := Main.SESLabIO.ADCChannelUnits[ch] ;
                       VPU := Main.SESLabIO.ADCChannelVoltsPerUnit[ch] ;
                       Gain := Main.SESLabIO.ADCChannelGain[ch] ;
                       ADCInput := Main.SESLabIO.ADCChannelInputNumber[ch] ;
                       Amplifier.GetChannelSettings( ch,Name,Units,VPU,Gain,ADCInput ) ;
                       Main.SESLabIO.ADCChannelName[ch] := Name ;
                       Main.SESLabIO.ADCChannelUnits[ch] := Units ;
                       Main.SESLabIO.ADCChannelVoltsPerUnit[ch] := VPU ;
                       Main.SESLabIO.ADCChannelGain[ch] := Gain ;
                       Main.SESLabIO.ADCChannelInputNumber[ch] := ADCInput ;
                       end ;

                   // If units have changed, update current/voltage channels
                   Changed := False ;
                   for ch := 0 to NumTestChannels-1 do begin
                       if OldADCUnits[ch] <> Main.SESLabIO.ADCChannelUnits[ch] then Changed := True ;
                       if OldADCName[ch] <> Main.SESLabIO.ADCChannelName[ch] then Changed := True ;
                       end ;
                   if Changed or FirstSweep then UpdateChannelLists ;

                   // Update Amplifier #1 gain display

//                   ich := cbCurrentChannel.ItemIndex ;
                   if ClampMode[cbAmplifier.ItemIndex] <>
                      Amplifier.ClampMode[cbAmplifier.ItemIndex] then SetClampMode ;

                   // Update current gain (if telegraphs available)
                   if Amplifier.GainTelegraphAvailable[cbAmplifier.ItemIndex] or
                      NewAmplifierGain then begin
                      // Display current amplifier gain
//                      if Main.SESLabIO.LabInterfaceType = Triton then iCh := 1
//                                                                 else iCh := 0 ;
                      edAmplifierGain.Units := 'V/' + Amplifier.PrimaryChannelUnits[cbAmplifier.ItemIndex,ClampMode[cbAmplifier.ItemIndex]] ;
                      edAmplifierGain.Value := Amplifier.PrimaryChannelScaleFactor[cbAmplifier.ItemIndex] ;
                      NewAmplifierGain := False ;
                      end ;

                   { A/D sampling interval }
                   EndofBuf := (NumTestChannels*NumTestSamples) - 1;
                   // Stop any existing A/D sweep
                   if Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
                   // Set no. of A/D channels and samples
                   Main.SESLabIO.ADCNumChannels := NumTestChannels ;
                   Main.SESLabIO.ADCNumSamples := NumTestSamples ;
                   // A/D input voltage range

                   // Set A/D sweep triggering
                   Main.SESLabIO.ADCTriggerMode := tmWaveGen ;

                   Main.SESLabIO.ADCCircularBuffer := False ;

                   CreateTestPulse ;

                   { Start D/A waveform output }
                   Main.SESLabIO.DACNumChannels := Main.SESLabIO.DACMaxChannels ;
                   Main.SESLabIO.DACNumSamples := nDACValues ;
                   Main.SESLabIO.DACUpdateInterval := DACdt ;
                   EndOfSweepCount := 0 ;

                   Main.SESLabIO.ADCStart ;
                   Main.SESLabIO.DACStart ;
                   if Main.SESLabIO.ADCActive then State := SweepInProgress
                                              else State := Idle ;
                   End ;

               SweepInProgress : Begin
                   { Erase display & Draw horizontal zero level cursor(s) }

                   { Update A/D buffer with samples from interface }
                   Main.SESLabIO.ADCBufferRefresh ;

                   // if all samples have been acquired, display on screen
                   if ADC[EndOfBuf] <> -EmptyFlag then Inc(EndOfSweepCount) ;
                   if ADC[EndOfBuf-1] <> EmptyFlag then Inc(EndOfSweepCount) ;
                   if EndOfSweepCount >= 2 then begin
                      // Clear display
                      InitialiseDisplay ;
                      // Update with new points
                      scDisplay.DisplayNewPoints( NumTestSamples ) ;
                      // Stop recording
                      if Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
                      if Main.SESLabIO.DACActive then Main.SESLabIO.DACStop ;
                      State := EndOfSweep ;
                      end ;

                   { Procedure to be done when recording sweep completes }
                   if State = EndOfSweep then begin
                       { Analyse and display test pulse results }
                       Main.SESLabIO.DACStop ;
                       Main.SESLabIO.ADCStop ;
                       AnalyseTestPulse ;

                       FirstSweep := False ;

                       { Do another sweep }
                       State := StartSweep ;
                       end ;

                   end ;

               Idle : begin
                    { Procedures when recording is in idle mode }
                    end ;
               end ;

          //Update elapsed time readout
          T := (TimeGetTime - TimerStarted) div 1000 ;
          edTimer.Text := format( ' %.2d:%.2d',[T div 60, T mod 60]) ;

          TimerBusy := False ;
          end ;
     end ;


procedure TSealTestFrm.SetClampMode ;
// --------------
// Set clamp mode
// --------------
var
    Units : String ;
    Scale : Single ;
begin

    ClampMode[cbAmplifier.ItemIndex] := Amplifier.ClampMode[cbAmplifier.ItemIndex] ;

    cbCurrentChannel.ItemIndex := Amplifier.CurrentChannel[cbAmplifier.ItemIndex] ;
    cbVoltageChannel.ItemIndex := Amplifier.VoltageChannel[cbAmplifier.ItemIndex] ;

    If ClampMode[cbAmplifier.ItemIndex] = amCurrentClamp then begin
       rbIClamp.Checked := True ;
       Units := CurrentClampUnits ;
       Scale := CurrentClampScale*Amplifier.CommandScaleFactor[cbAmplifier.ItemIndex] ;
       SetPulseOutChannel( Amplifier.CurrentCommandChannel[cbAmplifier.ItemIndex] ) ;
       end
    else begin
       rbVClamp.Checked := True ;
       Units := VoltageClampUnits ;
       Scale := VoltageClampScale*Amplifier.CommandScaleFactor[cbAmplifier.ItemIndex] ;
       SetPulseOutChannel( Amplifier.VoltageCommandChannel[cbAmplifier.ItemIndex] ) ;
       end ;

    ChangeUnits( edHoldingVoltage1, Units, Scale ) ;
    ChangeUnits( edHoldingVoltage2, Units, Scale ) ;
    ChangeUnits( edHoldingVoltage3, Units, Scale ) ;

    ChangeUnits( edPulseHeight1, Units, Scale ) ;
    ChangeUnits( edPulseHeight2, Units, Scale ) ;
    ChangeUnits( edPulseHeight3, Units, Scale ) ;
    ChangeUnits( edZapAmplitude, Units, Scale ) ;

    // Use current default holding potential for selected AO channel
    TestDAC := Min(Max(TestDAC,0),Main.SESLabIO.DACNumChannels-1) ;
    case Settings.SealTest.Use of
          2 : begin
             Settings.SealTest.HoldingVoltage2 :=  Main.SESLabIO.DACHoldingVoltage[TestDAC] ;
             edHoldingVoltage2.Value := Settings.SealTest.HoldingVoltage2 ;
              end ;
          3 : begin
              Settings.SealTest.HoldingVoltage3 :=  Main.SESLabIO.DACHoldingVoltage[TestDAC] ;
              edHoldingVoltage3.Value := Settings.SealTest.HoldingVoltage3 ;
              end ;
          else begin
              Settings.SealTest.HoldingVoltage1 :=  Main.SESLabIO.DACHoldingVoltage[TestDAC] ;
              edHoldingVoltage1.Value := Settings.SealTest.HoldingVoltage1 ;
              end ;
          end ;

    end ;


procedure TSealTestFrm.SetPulseOutChannel(
          AOChan : Integer
          ) ;
// ---------------------------------
// Set output channel for test pulse
// ---------------------------------
begin
      ckPulseTOAO0.checked := False ;
      ckPulseTOAO1.checked := False ;
      ckPulseTOAO2.checked := False ;
      ckPulseTOAO3.checked := False ;

      if AOChan = 0 then ckPulseToAO0.checked := True ;
      if AOChan = 1 then ckPulseToAO1.checked := True ;
      if AOChan = 2 then ckPulseToAO2.checked := True ;
      if AOChan = 3 then ckPulseToAO3.checked := True ;

      TestDAC := AOChan ;

      end ;


function TSealTestFrm.OutChannelSelected(
         AOChan : Integer
         ) : Boolean ;
// ---------------------------------------------------
// Return TRUE if AO channel selected for pulse output
// ---------------------------------------------------
begin
    Result := False ;
    if (AOChan = 0) and ckPulseToAO0.checked then Result := True ;
    if (AOChan = 1) and ckPulseToAO1.checked then Result := True ;
    if (AOChan = 2) and ckPulseToAO2.checked then Result := True ;
    if (AOChan = 3) and ckPulseToAO3.checked then Result := True ;
    end ;

procedure TSealTestFrm.ChangeUnits(
          var EditBox : TValidatedEdit ;
          NewUnits : String ;
          NewScale : Single ) ;
var
    Temp : Single ;
begin
    Temp := EditBox.Value ;
    EditBox.Units := NewUnits ;
    EditBox.Scale := NewScale ;
    EditBox.Value := Temp ;
    end ;


procedure TSealTestFrm.InitialiseDisplay ;
// ---------------------------------
// Setup oscilloscope display window
// ---------------------------------
var
    ch : Integer ;
begin

     scDisplay.MaxPoints := NumTestSamples ;
     scDisplay.NumPoints := 0 ;
     scDisplay.NumChannels := NumTestChannels ;
     //scDisplay.xMax := NumTestSamples-1 ;
     //scDisplay.xMin := 0 ;
     { Set channel information }
     for ch := 0 to NumTestChannels-1 do begin
         scDisplay.ChanOffsets[ch] := Main.SESLabIO.ADCChannelOffset[ch] ;
         scDisplay.ChanUnits[ch] := Main.SESLabIO.ADCChannelUnits[ch] ;
         scDisplay.ChanScale[ch] := Main.SESLabIO.ADCChannelUnitsPerBit[ch] ;
         scDisplay.ChanName[ch] := Main.SESLabIO.ADCChannelName[ch] ;
         scDisplay.HorizontalCursors[ch] := Main.SESLabIO.ADCChannelZero[ch] ;
         end ;
     scDisplay.TScale := Main.SESLabIO.ADCSamplingInterval*1000.0 ;
     scDisplay.SetDataBuf( ADC ) ;
     end ;


procedure TSealTestFrm.CreateTestPulse ;
{ ----------------------------
  Create test pulse waveform
  ----------------------------}
var
   i,j,ch,iStart,iEnd,iOffLevel,iOnLevel : Integer ;
   HoldDACLevel : Array[0..MaxAmplifiers-1] of Integer ;
begin

     { Select test pulse to use }
     case Settings.SealTest.Use of
          2 : begin
              Main.SESLabIO.DACHoldingVoltage[TestDAC] := Settings.SealTest.HoldingVoltage2 ;
              Settings.SealTest.PulseHeight := Settings.SealTest.PulseHeight2 ;
              end ;
          3 : begin
              Main.SESLabIO.DACHoldingVoltage[TestDAC] := Settings.SealTest.HoldingVoltage3 ;
              Settings.SealTest.PulseHeight := Settings.SealTest.PulseHeight3 ;
              end ;
          else begin
              Main.SESLabIO.DACHoldingVoltage[TestDAC] := Settings.SealTest.HoldingVoltage1 ;
              Settings.SealTest.PulseHeight := Settings.SealTest.PulseHeight1 ;
              end ;
          end ;

     if not bZap.Enabled then begin
        Settings.SealTest.PulseHeight := edZapAmplitude.Value ;
        end;

     { D/A channel voltage -> bits scaling factors }
     for ch := 0 to Main.SESLabIO.DACMaxChannels-1 do begin
         DACScale[ch] := Main.SESLabIO.DACMaxValue/Main.SESLabIO.DACVoltageRange[ch] ;
         end ;

     { Test pulse duration and recording sweep length }
     TestPulse.Duration := Settings.SealTest.PulseWidth ;

     if not bZap.Enabled then begin
        TestPulse.Duration := edZapDuration.Value ;
        bZap.Enabled := True ;
        end;

     TestPulse.TStart := Max(TestPulse.Duration*0.15,0.002) ;
     TestPulse.TEnd := TestPulse.TStart + TestPulse.Duration ;
     TestPulse.RecordLength := TestPulse.TEnd + TestPulse.TStart*1.5 ;

     { Test pulse repeat period }
     TestPulse.RepeatPeriod := Max(TestPulse.RecordLength,0.1 ) ;

     { No. of A/D samples & sampling interval MUST be set up here [Digidata 132X] }
     Main.SESLabIO.ADCNumChannels := NumTestChannels ;
     Main.SESLabIO.ADCSamplingInterval := TestPulse.RecordLength / NumTestSamples ;

     { Set D/A update interval }
     DACdt := Max( TestPulse.RepeatPeriod/NumTestSamples,MinDACInterval ) ;
     //DACdt := 1E-3 ;
     Main.SESLabIO.DACUpdateInterval := DACdt ;
     Main.SESLabIO.DACNumChannels := Main.SESLabIO.DACMaxChannels ; ;
     DACdt := Main.SESLabIO.DACUpdateInterval ;
     { Note that interval may be changed due to limitations of lab. interface.
       E.g. Digidata 132X update rate always the same as A/D sampling interval }

     { No. of D/A values in buffer }
     nDacValues := Round( TestPulse.RecordLength / DACdt ) ;

     { Create test pulse waveform }
     iStart := Max(Round(TestPulse.TStart/DACdt),1 ) ;
     iEnd := Max(Round(TestPulse.TEnd/DACdt),1 ) ;

     // Seal test On and off pulse levels for selected DAC output
     iOffLevel := Max(Main.SESLabIO.DACMinValue,
                  Min(Main.SESLabIO.DACMaxValue,Round(DACScale[TestDAC]*
                  Main.SESLabIO.DACHoldingVoltage[TestDAC]))) ;
     iOnLevel :=  Max(Main.SESLabIO.DACMinValue,
                  Min(Main.SESLabIO.DACMaxValue,Round(DACScale[TestDAC]*
                  (Main.SESLabIO.DACHoldingVoltage[TestDAC] + Settings.SealTest.PulseHeight)))) ;

     // Set holding levels
     for ch := 0 to Main.SESLabIO.DACMaxChannels-1 do begin
         HoldDACLevel[ch] := Max(Main.SESLabIO.DACMinValue,
                             Min(Main.SESLabIO.DACMaxValue,Round(
                             Main.SESLabIO.DACHoldingVoltage[ch]*DACScale[ch]))) ;
         end ;

     // Create DAC waveform buffer
     j := 0 ;
     for i := 0 to nDacValues-1 do begin
         // Seal test DAC channel
         for ch := 0 to Main.SESLabIO.DACMaxChannels-1 do begin
             if OutChannelSelected(ch) then begin
                if (i >= iStart) and (i<iEnd) then DAC^[j] := iOnLevel
                                              else DAC^[j] := iOffLevel ;
                end
             else  DAC^[j] := HoldDACLevel[ch] ;
             Inc(j) ;
             end ;
         end ;

     end ;


procedure TSealTestFrm.AnalyseTestPulse ;
{ --------------------------------------------------------------------
  Calculate and display seal test pulse amplitudes and seal properties
  --------------------------------------------------------------------}
const
    LoVoltageLimit = 1E-6 ;  // Smallest valid test voltage (1uV)
    LoCurrentLimit = 1E-13 ; // Smallest valid current (0.1 pA)
    LoLimit = 1E-15 ;
var
   i,j,ch,iStart,iEnd,n : Integer ;
   iAvgStart,iAvgEnd,nAvg,NumSamplesIn : Integer ;
   NewDisplayScale,NewDisplayRange,HalfRange,Mid : Integer ;
   ChIm,ChVm,ChOffset,ChStim,yADC : Integer ;
   HoldLevel,VThreshold,iOffLevel,iOnLevel,PeakAt : Integer ;
   YMin,YMax : Array[0..WCPMaxChannels-1] of Integer ;
   VHold,VPulse,IHold,IPulse,Avg,Sum,IPeak,IValue : single ;
   Voltage,SteadyCurrent,PeakCurrent : single ;
   TauC,Slope,YIntercept,SteadyStateLevel,dt : single ;
   x,y : Array[0..NumTestSamples] of Single ;
   OK,Done : Boolean ;
   VOffset,IOffset : Integer ;
   VZero,IZero : Integer ;
   VScale,IScale : Single ;
   VUnits,IUnits : String ;
   ScaleToVolts,ScaleToAmps : Single ;
begin

     try

     // Reset cell parameter averaging count and pointers
     if ResetReadout then
        begin
        iAverage := 0 ;
        NumAverages := 0 ;
        iResistance := 0 ;
        NumResistances := 0 ;
        edGAccess.Value := 0.0 ;
        edGMembrane.Value := 0.0 ;
        edCMembrane.Value := 0.0 ;
        edRAccess.Value := 0.0 ;
        edRMembrane.Value := 0.0 ;
        edCMembrane1.Value := 0.0 ;
        edResistance.Value := 0.0 ;
        ResetReadout := False ;
        end;

     // Current and voltage channels
     ChIm := cbCurrentChannel.ItemIndex ;
     ChVm := cbVoltageChannel.ItemIndex ;
     VOffset := Main.SESLabIO.ADCChannelOffset[chVm] ;
     IOffset := Main.SESLabIO.ADCChannelOffset[chIm] ;
     VZero := Main.SESLabIO.ADCChannelZero[chVm] ;
     IZero := Main.SESLabIO.ADCChannelZero[chIm] ;
     VScale := Main.SESLabIO.ADCChannelUnitsPerBit[chVm] ;
     IScale := Main.SESLabIO.ADCChannelUnitsPerBit[chIm] ;
     VUnits := Main.SESLabIO.ADCChannelUnits[chVm] ;
     IUnits := Main.SESLabIO.ADCChannelUnits[chIm] ;

     { Find Min./Max. limits of voltage and current }
     for ch := 0 to NumTestChannels-1 do begin
         YMax[ch] := Main.SESLabIO.ADCMinValue ;
         YMin[ch] := Main.SESLabIO.ADCMaxValue ;
         j := Main.SESLabIO.ADCChannelOffset[ch] ;
         for i := 0 to NumTestSamples-1 do begin
             yADC := ADC^[j] ;
             if YMax[ch] <= yADC then YMax[ch] := yADC ;
             if YMin[ch] >= yADC then YMin[ch] := yADC ;
             j := j + NumTestChannels ;
             end ;
         end ;

     { Get current display magnification setting }
     for ch := 0 to NumTestChannels-1 do
         DisplayScale[ch] := Min(Max(DisplayScale[ch],1),100);

     { If in auto-scale mode ... determine whether a new magnification is needed }
     if ckAutoScale.Checked or FirstSweep then begin
        for ch := 0 to NumTestChannels-1 do begin
            NewDisplayRange := Max( YMax[Ch] - YMin[Ch] + 20,50) ;
            NewDisplayScale := (Main.SESLabIO.ADCMaxValue -Main.SESLabIO.ADCMinValue)
                               div NewDisplayRange ;
            NewDisplayScale := Max(NewDisplayScale,1) ;
            if (NewDisplayScale < DisplayScale[ch]) or
               (NewDisplayScale >= (8*DisplayScale[ch])) or
               FirstSweep then begin
               DisplayScale[ch] := NewDisplayScale ;
               end ;
            end ;
        ChangeDisplayScaling := True ;
        //FirstSweep := False ;
        end ;

     { Update display scaling if either the user has manually
       change the scale OR auto-scale is in use }
     if  ChangeDisplayScaling = True then begin
        for ch := 0 to NumTestChannels-1 do begin
            HalfRange := (Main.SESLabIO.ADCMaxValue - Main.SESLabIO.ADCMinValue) div
                          DisplayScale[ch] ;
            Mid := (YMax[Ch] + YMin[Ch]) div 2 ;
           scDisplay.yMax[ch] := Min( Mid+HalfRange, Main.SESLabIO.ADCMaxValue ) ;
            scDisplay.yMin[ch] := Max( Mid-HalfRange, Main.SESLabIO.ADCMinValue) ;
            end ;
         ChangeDisplayScaling := False ;
         end ;

     // Calculate current/voltage test pulse amplitudes
     // -----------------------------------------------

     // Holding average region (5% preceding test pulse)
     // Note. subtraction of DacDT interval to ensure range is before pulse start
     iEnd := Max( Round((TestPulse.TStart-DacDt)/Main.SESLabIO.ADCSamplingInterval)-1,0 ) ;
     iStart := Max(iEnd div 2,0) ;

     // Holding voltage
     Sum := 0. ;
     for i := iStart to iEnd do begin
         j := i*NumTestChannels + VOffset ;
         Sum := Sum + ADC^[j] ;
         end ;
     Avg := Sum/(iEnd - iStart +1) ;
     HoldLevel := Round(Avg) ;
     VHold := (Avg - VZero)*VScale ;

     // Holding current
     Sum := 0. ;
     for i := iStart to iEnd do begin
         j := i*NumTestChannels + IOffset ;
         Sum := Sum + ADC^[j] ;
         end ;
     Avg := Sum/(iEnd - iStart +1) ;
     IHold := (Avg - IZero)*IScale ;

     // Find start / end of test pulse
     if rbIClamp.Checked then begin
        ChStim := ChIm ;
        HoldLevel := Round(IHold/iScale) + IZero ;
        end
     else begin
        ChStim := ChVm ;
        HoldLevel := Round(VHold/VScale) + VZero ;
        end ;

     // 22.02.19 End of analysis area determined from time of pulse end
     // rather than from 50% transition threshold for better
     // accuracy when trailing edge of pulse is rounded
     iStart := Max( Round((TestPulse.TStart-DacDt)/Main.SESLabIO.ADCSamplingInterval)-1,0 ) ;
     iEnd := Max( Round((TestPulse.TEnd-DacDt)/Main.SESLabIO.ADCSamplingInterval)-1,0 ) ;

     { Calculate amplitude of voltage pulse (from last half of pulse) }
     nAvg := Max( (iEnd - iStart + 1) div 2, 1 ) ;
     iAvgStart := Max( iEnd - nAvg + 1,iStart ) ;
     iAvgEnd := Max( iEnd - 2,iAvgStart ) ;
     Sum := 0. ;
     for i := iAvgStart to iAvgEnd do begin
         j := i*NumTestChannels + VOffset ;
         Sum := Sum + ADC^[j] ;
         end ;
     if (iAvgEnd-iAvgStart+1) <> 0 then Avg := Sum / (iAvgEnd-iAvgStart+1)
                                   else Avg := 0.0 ;

     VPulse := (Avg-VZero)*VScale ;
     VPulse := VPulse - VHold ;

     { Calculate steady-state amplitude of current pulse (from last half of pulse) }
     Sum := 0. ;
     for i := iAvgStart to iAvgEnd do begin
         j := i*NumTestChannels + IOffset ;
         Sum := Sum + ADC^[j] ;
         end ;
     if (iAvgEnd-iAvgStart+1) <> 0 then Avg := Sum / (iAvgEnd-iAvgStart+1)
                                   else Avg := 0.0 ;

     SteadyStateLevel := Avg ;
     IPulse := (Avg - IZero )*IScale ;
     IPulse := IPulse - IHold ;

     edVHold.Units := VUnits ;
     edVHold.Value := VHold ;
     edVPulse.Units := VUnits ;
     EdVPulse.Value := VPulse ;
     edIHold.Units := IUnits ;
     edIHold.Value := IHold ;
     edIPulse.Units := IUnits ;
     EdIPulse.Value := IPulse ;

     // Calculate pipette/cell parameters
     // ---------------------------------

     { Set scaling factors to convert current and voltage from user's
       units to Volts and Amps }
     if ANSIContainsText(VUnits,'mV') then ScaleToVolts := 1E-3
                                      else ScaleToVolts := 1. ;
     if ANSIContainsText(IUnits,'pA') then ScaleToAmps := 1E-12
     else if ANSIContainsText(IUnits,'nA') then ScaleToAmps := 1E-9
     else if ANSIContainsText(IUnits,'uA') then ScaleToAmps := 1E-6
     else if ANSIContainsText(IUnits,'mA') then ScaleToAmps := 1E-3
     else ScaleToAmps := 1. ;

     // Holding voltage and current
     Main.Vm := ScaleToVolts*VHold ;
     Main.Im := ScaleToAmps*IHold ;

     // Voltage and current pulse amplitude in Volts and Amps
     Voltage := VPulse*ScaleToVolts ;
     SteadyCurrent := IPulse*ScaleToAmps ;

     // Abort calculations if voltages are too small
     if Abs(Voltage) < LoVoltageLimit then Exit ;
     if Abs(SteadyCurrent) < LoCurrentLimit then Exit ;

     // Calculate seal resistance
     Resistance[iResistance] := Voltage/SteadyCurrent ;
     if Resistance[iResistance] < 0.0 then begin
        outputdebugstring(pchar('negative resistance'));
        Exit ;
        end;

     edResistance.Value := Average( Resistance, NumResistances, edResistance.Value ) ;
     iResistance := iResistance + 1 ;
     if iResistance >= Round(EdNumAverages.Value) then iResistance := 0 ;
     NumResistances := Min(NumResistances + 1,Round(EdNumAverages.Value));

     Main.RSeal := EdResistance.Value ;

     { Calculate peak current from first half of pulse }
     PeakCurrent := 0. ;
     PeakAt := 0 ;
     for i := 0 to iAvgStart do begin
         j := i*NumTestChannels + IOffset ;
         IValue := ((ADC^[j] - IZero)*IScale - IHold)*ScaleToAmps ;
         if Abs(IValue) > Abs(PeakCurrent) then begin
            PeakCurrent := IValue ;
            PeakAt := i ;
            end ;
         end ;
     if Abs(PeakCurrent) < LoCurrentLimit then Exit ;

     // Calculate decay time constant of capacity current
     dt := Main.SESLabIO.ADCSamplingInterval ;
     Done := False ;
     i := PeakAt ;
     n := 0 ;
     while not Done do begin
         j := i*NumTestChannels + IOffset ;
         IValue := ((ADC^[j] - IZero)*IScale - IHold)*ScaleToAmps - SteadyCurrent ;
         // Invert value if negative peak
         if PeakCurrent < 0.0 then IValue := -IValue ;
         if (IValue > LoCurrentLimit) and (i < iAvgStart) then begin
            x[n] := (i-((iStart + PeakAt) div 2))*dt ;
            y[n] := Ln(IValue) ;
            Inc(n) ;
            Inc(i) ;
            end
         else Done := True ;
         end ;
     OK := LinearRegression( x, y, n, Slope, YIntercept ) ;
     if (not OK) or (Abs(Slope) <= (1.0/(dt*NumTestSamples)) ) or (Abs(Slope) > (10.0/dt) ) then Exit ;

     // Calculate Access conductance (Ga)
     // See Gillis K.D. p. 161 Single-channel recording (Neher & Sakmann)
     if rbGaFromPeak.Checked then begin
        GAccess[iAverage] := PeakCurrent/Voltage ;
        end
     else begin
        // Quit if Y intercept too different from peak value measurement
        if Abs( YIntercept - ln(abs(PeakCurrent))) > 2.0 then Exit ;
        GAccess[iAverage] := exp(YIntercept)*sign(PeakCurrent)/Voltage ;
        end ;
     if GAccess[iAverage] < 0.0 then Exit ;

     // Calculate membrane conductance (Gm)
     if Abs(Voltage - (SteadyCurrent/GAccess[iAverage])) > LoVoltageLimit then begin
        GMembrane[iAverage] := SteadyCurrent/(Voltage - (SteadyCurrent/GAccess[iAverage])) ;
        end
     else Exit ;
     if GMembrane[iAverage] < 0.0 then Exit ;

     // Calculate membrane capacity
     TauC := -1.0 / Slope ;
     outputdebugstring(pchar(format('Tau=%.4g',[TauC])));
     Capacity[iAverage] := TauC*(GAccess[iAverage] + GMembrane[iAverage]) ;
     if Capacity[iAverage] < 0.0 then Exit ;

     iAverage := iAverage + 1 ;
     if iAverage >= Round(edNumAverages.Value) then iAverage := 0 ;
     NumAverages := Min(NumAverages + 1, Round(edNumAverages.Value) ) ;

     edGAccess.Value := Average( GAccess, NumAverages, edGAccess.Value ) ;
     if Abs(edGAccess.Value) > 1E-20 then  edRAccess.Value := 1.0 / edGAccess.Value ;
     Main.Ga := edGAccess.Value ;

     edGMembrane.Value := Average( GMembrane, NumAverages, edGMembrane.Value ) ;
     if Abs(edGmembrane.Value) > 1E-20 then edRmembrane.Value := 1.0 / edGmembrane.Value ;
     Main.Gm := edGmembrane.Value ;

     EdCmembrane.Value := Average( Capacity, NumAverages, EdCmembrane.Value ) ;
     EdCmembrane1.Value := EdCmembrane.Value ;
     Main.Cm := EdCmembrane.Value ;

     except
        Main.StatusBar.SimpleText := 'SealTest: Floating Point Error' ;
        end ;

     end ;


function TSealTestFrm.Average(
          Buf : Array of Single ; // Array of measurements to be averaged
          NumPoints : Integer ;   // No. of points to average
          OldAverage : single      // Previous avg. (returned when NumAverage = 0)
          ) : single ;
// ------------------------------------
// Return average of data points in Buf
// ------------------------------------
var
    Sum : single ;
    i : Integer ;
begin

     if NumPoints > 0 then
        begin
        Sum := 0.0 ;
        for i := 0 to NumPoints-1 do Sum := Sum + Buf[i] ;
        Result := Sum / NumPoints ;
        if Result < 0.0 then Result := OldAverage ;
        end
      else Result := OldAverage ;
end;


procedure TSealTestFrm.StopADCandDAC ;
{ ---------------------------------
  Shut down A/D and D/A sub-systems
  ---------------------------------}
var
    ch : Integer ;
begin

    if not Initialised then exit ;
    if State <> SweepInProgress then Exit ;

    Timer.Enabled := False ;

    if Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
    if Main.SESLabIO.DACActive then Main.SESLabIO.DACStop ;

    { Return voltage command to holding voltage and Sync. O/P to OFF }
    for ch := 0 to Main.SESLabIO.DACMaxChannels-1 do
        Main.SESLabIO.DACHoldingVoltage[ch] := Main.SESLabIO.DACHoldingVoltage[ch] ;
    Main.SESLabIO.DIGHoldingLevel := Main.SESLabIO.DIGHoldingLevel ;

    Timer.Enabled := False ;

    end ;

procedure TSealTestFrm.StartADCandDAC ;
{ ---------------------------------
  Start A/D + D/A sweeps
  ---------------------------------}
begin

     if not Initialised then exit ;

     // Ensure display channels visibility is updated
     ChangeDisplayGrid ;

     // Stop record form if it is open
     if Main.FormExists( 'RecordFrm') then RecordFrm.StopSweep ;

     { Start seal test pulses when form gains focus }

     Timer.enabled := True ;
     TimerBusy := False ;
     State := StartSweep ;
     ResetReadout := True ;

     end;



procedure TSealTestFrm.edHoldingVoltage1KeyPress(Sender: TObject; var Key: Char);
{ ------------------------------------
  Set Voltage clamp holding voltage #1
  ------------------------------------}
begin
     if key = #13 then begin
         Settings.SealTest.HoldingVoltage1 := edHoldingVoltage1.Value ;
        ResetReadout := True ;
        end ;

     end;


procedure TSealTestFrm.edHoldingVoltage2KeyPress(Sender: TObject; var Key: Char);
{ ------------------------------------
  Set Voltage clamp holding voltage #2
  ------------------------------------}
begin
     if key = #13 then begin
        Settings.SealTest.HoldingVoltage2 := edHoldingVoltage2.Value ;
        ResetReadout := True ;
        end ;

     end;


procedure TSealTestFrm.EdHoldingVoltage3KeyPress(Sender: TObject;
  var Key: Char);
{ ------------------------------------
  Set Voltage clamp holding voltage #3
  ------------------------------------}
begin
     if key = #13 then begin
        Settings.SealTest.HoldingVoltage3 := edHoldingVoltage3.Value ;
        ResetReadout := True ;
        end ;
     end ;


procedure TSealTestFrm.rbUseHoldingVoltage1Click(Sender: TObject);
{ ---------------------------------
  Set holding voltage to voltage #1
  ---------------------------------}
begin
     { Set holding voltage and pulse height to group #1 }
     Settings.SealTest.Use := 1 ;
     Settings.SealTest.HoldingVoltage1 := edHoldingVoltage1.Value ;
     Settings.SealTest.PulseHeight1 := edPulseHeight1.Value ;
     end;


procedure TSealTestFrm.rbUseHoldingVoltage2Click(Sender: TObject);
{ ---------------------------------
  Set holding voltage to voltage #2
  ---------------------------------}
begin
     { Set holding voltage and pulse height to group #2 }
     Settings.SealTest.Use := 2 ;
     Settings.SealTest.HoldingVoltage2 := edHoldingVoltage2.Value ;
     Settings.SealTest.PulseHeight2 := edPulseHeight2.Value ;
     end;


procedure TSealTestFrm.rbUseHoldingVoltage3Click(Sender: TObject);
{ ---------------------------------
  Set holding voltage to voltage #3
  Note. No pulse with this option
  ---------------------------------}
begin
     { Set holding voltage and pulse height to group #3 }
     Settings.SealTest.Use := 3 ;
     Settings.SealTest.HoldingVoltage3 := edHoldingVoltage3.Value ;
     Settings.SealTest.PulseHeight3 :=edPulseHeight3.Value ;
     end;


procedure TSealTestFrm.edPulseHeight1KeyPress(Sender: TObject;
  var Key: Char);
{ -------------------------------
  Set test pulse amplitude #1
  -------------------------------}
begin
     if key = char(13) then begin
        Settings.SealTest.PulseHeight1 := edPulseHeight1.Value ;
        ResetReadout := True ;
        end ;
     end;


procedure TSealTestFrm.edPulseheight2KeyPress(Sender: TObject;
  var Key: Char);
  { -----------------------------
    Set test pulse amplitude #2
    -----------------------------}
begin
     if key = char(13) then begin
        Settings.SealTest.PulseHeight2 := edPulseHeight2.Value ;
        ResetReadout := True ;
        end ;
     end;


procedure TSealTestFrm.edPulseWidthKeyPress(Sender: TObject; var Key: Char);
{ ----------------------------
  Set width of seal test pulse
  ----------------------------}
begin
     if key = #13 then begin
        Settings.SealTest.PulseWidth := edPulseWidth.Value ;
        { Note. Force a re-start of D/A waveform so that D/A cycle
          time is updated }
        if Main.SESLabIO.DACActive then Main.SESLabIO.DACStop ;
        scDisplay.xMax := NumTestSamples-1 ;
        scDisplay.xMin := 0 ;
        State := StartSweep ;
        ResetReadout := True ;
        end ;
     end ;


procedure TSealTestFrm.FormDeactivate(Sender: TObject);
{ -----------------------------------------
  Called when focus moves to another window
  -----------------------------------------}
begin
     { Terminate seal test pulses if form loses focus }
 //    Timer.enabled := false ;
     StopADCandDAC ;
     State := Idle ;
     end;


procedure TSealTestFrm.FormActivate(Sender: TObject);
{ -------------------------------------------
  Called when focus moves to seal test window
  -------------------------------------------}
begin

     StartADCandDAC ;
     //outputdebugstring(pchar('sealtest activate'));
     end;


procedure TSealTestFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
{ -----------------------------
  Called when window is closed
  -----------------------------}
begin

     { Shut down A/D and D/A sub-systems }
     StopADCandDAC ;
     { Note. If A/D and D/A sub-systems are still active when the
       form is closed the program will crash. }

     Timer.enabled := false ;
     { Close the form }
     Action := caFree ;

     end;


procedure TSealTestFrm.FormCreate(Sender: TObject);
begin
     Timer.Enabled := False ;
     LoadEPC9Panel := False ;
     Initialised := False ;
     State := Idle ;
     end;

procedure TSealTestFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{ --------------
  Function keys
  -------------}
begin
     case Key of
          { F3 selects holding voltage #1 }
          VK_F3 : begin
               rbUseHoldingVoltage1.checked := True ;
               end ;
          { F4 selects holding voltage #2 }
          VK_F4 : begin
               rbUseHoldingVoltage2.checked := True ;
               end ;
          { F5 selects holding voltage #3 }
          VK_F5 : begin
               rbUseHoldingVoltage3.checked := True ;
               end ;
          end ;
     end;


procedure TSealTestFrm.FormResize(Sender: TObject);
{ ----------------------------------
  Called when window size is changed
  ----------------------------------}
begin

     // Stop sweep
     StopADCandDAC ;

     TimerGrp.Top := ClientHeight - TimerGrp.Height - 5 ;
     PulseGrp.Height := TimerGrp.Top - PulseGrp.Top - 2 ;
     VoltsGrp.Top := ClientHeight - VoltsGrp.Height - 5 ;
     CurrentGrp.Top := VoltsGrp.Top ;
     CellGrp.Top := VoltsGrp.Top ;
     ZapGrp.Top := VoltsGrp.Top ;

     ckAutoScale.Top := VoltsGrp.Top - ckAutoScale.Height - 5 ;
     scDisplay.Width := Max(ClientWidth - scDisplay.Left - 5,2) ;
     scDisplay.Height := Max( ckAutoScale.Top - scDisplay.Top - 2,2) ;

     //State := StartSweep ;
     StartADCandDAC ;
     //Timer.Enabled := True ;

     end;


procedure TSealTestFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
var
    ch : Integer ;
begin
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;

     scDisplay.DisplayGrid := Settings.DisplayGrid ;

     // Update visible channels
     for ch := 0 to scDisplay.NumChannels-1 do begin
         scDisplay.ChanVisible[ch] := Main.SESLabIO.ADCChannelVisible[ch] ;
         end ;

     scDisplay.Invalidate ;
     end ;


procedure  TSealTestFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;
     scDisplay.ZoomOut ;
     end ;


procedure TSealTestFrm.bResetAverageClick(Sender: TObject);
// ------------------------------------------------------
// Reset averaging for pipette reistance/capacity readout
// ------------------------------------------------------
begin
    ResetReadout := True ;
end;


procedure TSealTestFrm.bResetTimerClick(Sender: TObject);
begin
    // Initialise elapsed time readout
    TimerStarted := TimeGetTime ;
    end;


procedure TSealTestFrm.cbCurrentChannelChange(Sender: TObject);
begin
     ResetReadout := True ;
     end;

procedure TSealTestFrm.bSaveToLogClick(Sender: TObject);
// --------------------------------
// Save cell parameters to log file
// --------------------------------
begin

     if CellParametersPage.ActivePage = CellTab then begin
        WriteToLogFile( format( 'Gaccess= %.5g %s',
                     [edGAccess.Value*edGAccess.Scale,edGAccess.Units])) ;
        WriteToLogFile( format( 'Gmembrane= %.5g %s',
                     [edGMembrane.Value*edGMembrane.Scale,edGMembrane.Units])) ;
        WriteToLogFile( format( 'Cmembrane= %.5g %s',
                     [edCMembrane.Value*edCMembrane.Scale,edCMembrane.Units])) ;
        end
     else begin
        WriteToLogFile( format( 'Pipette Resistance= %.5g %s',
                     [edResistance.Value*edResistance.Scale,edResistance.Units])) ;
        end ;
     end;


procedure TSealTestFrm.bzapClick(Sender: TObject);
//
/// Zap button clicked
begin
    bZap.Enabled := False ;
    end;

procedure TSealTestFrm.edAmplifierGainKeyPress(Sender: TObject;
  var Key: Char);
begin
     if Key = #13 then begin
        Amplifier.PrimaryChannelScaleFactor[cbAmplifier.ItemIndex] := edAmplifierGain.Value ;
        end ;
     end;

procedure TSealTestFrm.rbGaFromPeakClick(Sender: TObject);
// ----------------------------------------------------
// Select Ga calculated from capacity current peak mode
// ----------------------------------------------------
begin
     Settings.SealTest.GaFromPeak := True ;
     ResetReadout := True ;
     end;

procedure TSealTestFrm.rbGaFromExpClick(Sender: TObject);
// ----------------------------------------------------
// Select Ga calculated from exponential amplitude mode
// ----------------------------------------------------
begin
     Settings.SealTest.GaFromPeak := False ;
     ResetReadout := True ;
     end;


procedure TSealTestFrm.SetTestPulseAmplitude(
          i : Integer ;
          Value : Single
          ) ;
// -----------------------------
// Set seal test pulse amplitude
// -----------------------------
begin
    case i of
        1 : begin
            edPulseHeight1.Value := Value ;
            Settings.SealTest.PulseHeight1 := Value ;
           if rbUseHoldingVoltage1.checked then begin
              Settings.SealTest.PulseHeight := edPulseHeight1.Value ;
              ResetReadout := True ;
              end ;
           end ;

        2 : begin
            edPulseHeight2.Value := Value ;
            Settings.SealTest.PulseHeight2 := Value ;
           if rbUseHoldingVoltage2.checked then begin
              Settings.SealTest.PulseHeight := edPulseHeight2.Value ;
              ResetReadout := True ;
              end ;
            end ;
        end ;
    end ;


function  TSealTestFrm.GetTestPulseAmplitude( i : Integer ) : Single ;
// -----------------------------
// Set seal test pulse amplitude
// -----------------------------
begin
    Result := 0.0 ;
    case i of
        1 : Result := edPulseHeight1.Value ;
        2 : Result := edPulseHeight2.Value ;
        end ;
    end ;


procedure TSealTestFrm.SetHoldingVoltage( i : Integer ; Value : Single ) ;
// -----------------------------
// Set holding potential
// -----------------------------
begin
    case i of
        1 : begin
            edHoldingVoltage1.Value := Value ;
            Settings.SealTest.HoldingVoltage1 := Value ;
            if rbUseHoldingVoltage1.checked then begin
               Main.SESLabIO.DACHoldingVoltage[TestDAC] := edHoldingVoltage1.Value ;
               ResetReadout := True ;
               end ;
            end ;

        2 : begin
            edHoldingVoltage2.Value := Value ;
            Settings.SealTest.HoldingVoltage2 := Value ;
            if rbUseHoldingVoltage1.checked then begin
               Main.SESLabIO.DACHoldingVoltage[TestDAC] := edHoldingVoltage2.Value ;
               ResetReadout := True ;
               end ;
            end ;
        3 : begin
            edHoldingVoltage3.Value := Value ;
            Settings.SealTest.HoldingVoltage3 := Value ;
            if rbUseHoldingVoltage1.checked then begin
               Main.SESLabIO.DACHoldingVoltage[TestDAC] := edHoldingVoltage3.Value ;
               ResetReadout := True ;
               end ;
            end ;
        end ;
    end ;


function  TSealTestFrm.GetHoldingVoltage( i : Integer ) : Single ;
// -----------------------------
// Set seal test pulse amplitude
// -----------------------------
begin
    Result := 0.0 ;
    case i of
        1 : Result := edHoldingVoltage1.Value ;
        2 : Result := edHoldingVoltage2.Value ;
        3 : Result := edHoldingVoltage3.Value ;
        end ;
    end ;


procedure TSealTestFrm.SetTestPulseWidth( Value : Single ) ;
// --------------------
// Set test pulse width
// --------------------
begin
     edPulseWidth.Value := Value ;
     Settings.SealTest.PulseWidth :=  Value ;

     end ;


function  TSealTestFrm.GetTestPulseWidth : Single ;
// --------------------
// Get test pulse width
// --------------------
begin
     Result := edPulseWidth.Value ;
     end ;


procedure TSealTestFrm.SetTestPulseNumber( Value : Integer ) ;
// ----------------------------
// Set test pulse number (1-3)
// ---------------------------
begin
     case Value of
        1 : rbUseHoldingVoltage1.Checked := True ;
        2 : rbUseHoldingVoltage2.Checked := True ;
        3 : rbUseHoldingVoltage3.Checked := True ;
        end ;
     end ;


function  TSealTestFrm.GetTestPulseNumber : Integer ;
// --------------------
// Get test pulse number
// --------------------
begin
     Result := Settings.SealTest.Use ;
     end ;


procedure TSealTestFrm.SetSmoothingFactor( Value : Single ) ;
// -----------------------------------
// Set cell parameter smoothing factor
// -----------------------------------
begin
     Settings.SealTest.NumAverages := Min(Max(Round(Value),1),MaxAverage) ;
     edNumAverages.Value := Settings.SealTest.NumAverages ;
     end ;


function  TSealTestFrm.GetSmoothingFactor : Single ;
// -----------------------------------
// Get cell parameter smoothing factor
// -----------------------------------
begin
     Result := Settings.SealTest.NumAverages ;
     end ;


function  TSealTestFrm.GetRunning : Boolean ;
// -----------------------------------
// Return TRUE if seal test is running
// -----------------------------------
begin
     Result := Timer.Enabled ;
     end ;

procedure TSealTestFrm.edPulseheight3KeyPress(Sender: TObject;
  var Key: Char);
  { -----------------------------
    Set test pulse amplitude #3
    -----------------------------}
begin
     if key = char(13) then begin
        Settings.SealTest.PulseHeight3 := edPulseHeight3.Value ;
        if rbUseHoldingVoltage3.checked then begin
           Settings.SealTest.PulseHeight := edPulseHeight3.Value ;
           end ;
        ResetReadout := True ;
        end ;
     end;

procedure TSealTestFrm.scDisplayCursorChange(Sender: TObject);
// ---------------
// Display changed
// ---------------
var
    ch : Integer ;
begin
     // Update channel visibility setting
     for ch := 0 to scDisplay.NumChannels do
         Main.SESLabIO.ADCChannelVisible[ch] := scDisplay.ChanVisible[ch] ;

     end;

procedure TSealTestFrm.cbAmplifierChange(Sender: TObject);
// --------------------------------
// Change amplifier under seal test
// --------------------------------
begin
     SetClampMode ;
     NewAmplifierGain := True ;
     end;

procedure TSealTestFrm.rbVclampClick(Sender: TObject);
begin
     Amplifier.ClampMode[cbAmplifier.ItemIndex] := amVoltageClamp ;
     DisplayClampMode ;
     end;

procedure TSealTestFrm.rbIclampClick(Sender: TObject);
begin
     Amplifier.ClampMode[cbAmplifier.ItemIndex] := amCurrentClamp ;
     DisplayClampMode ;
     end;


procedure TSealTestFrm.DisplayClampMode ;
begin
     if Amplifier.ClampMode[cbAmplifier.ItemIndex] = amVoltageClamp then begin
        rbVClamp.Checked := True ;
        rbIClamp.Checked := False ;
        end
     else begin
        rbVClamp.Checked := False ;
        rbIClamp.Checked := True ;
        end ;
     end ;

procedure TSealTestFrm.cbNumChannelsChange(Sender: TObject);
// --------------------------------
// No. of display channels changed
// --------------------------------
begin
     NumTestChannels := Max( cbNumChannels.ItemIndex + 1,1) ;
     UpdateChannelLists ;
     end;


procedure TSealTestFrm.edNumAveragesKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key = #13 then begin
       Settings.SealTest.NumAverages := Round(edNumAverages.Value)
       end ;
     end;

procedure TSealTestFrm.edZapAmplitudeKeyPress(Sender: TObject; var Key: Char);
// ---------------------
// Zap amplitude changed
// ---------------------
begin
     if key = #13 then begin
        Settings.SealTest.ZapAmplitude := edZapAmplitude.Value ;
        end ;
     end;

procedure TSealTestFrm.edZapDurationKeyPress(Sender: TObject; var Key: Char);
// ---------------------
// Zap duration changed
// ---------------------
begin
     if key = #13 then begin
        Settings.SealTest.ZapDuration := edZapDuration.Value ;
        end ;
     end;

end.
