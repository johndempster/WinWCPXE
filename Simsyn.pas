unit Simsyn;
{ ==================================================================
  WinWCP ... Synaptic current simulation module (c) J. Dempster 1996-97
  13/7/99 ... V3.0 32 bit version
  4/9/99 ... Display grid added
  30/10/99 ... NewFile method added
  18/5/01 .... FP Zero Divide error when QC=0 fixed
  25/2/02 .... Display now updated during simulation
               Progress is reported on main status bar
  24.6.03 ... No. of display grid lines can be changed
  17.03.04 .. SESLABIO.ADCMaxValue replaced with MaxADCValue
  01.01.04 .. Out of memory error blocked when windows resized to tiny size
  06.09.05 .. Record duration can now be specified
              Slow phase % decay now specified rather than fast/slow ratio
              ADC buffer now allocated statically
  10.02.09 .. Display range now set correctly when EPC amplitude is negative
  18.02.10 .. Non-linear summation scaling of potentials now correct
              Settings now saved in INI file
  16.11.11 .. No. Samples box added to control panel
  09.08.13 .. ADC,Buf now allocated by GetMem()
  03.03.17 .. .Close form event now terminates bStart.Click event before
              closing form to prevent access violation
  16.11.21 .. Evoked signal amplitudes now calculated by summing quantal amplitudes with gaussian noise.
              Non-linear summation of potentials now correct, using correct formula and based upon
              peak of quantal waveform rather than exponential amplitude set by user.
  ==================================================================}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, maths,
  ValEdit, ScopeDisplay, math, ComCtrls, ValidatedEdit, seslabio, strutils ;

type
  TSynapseSim = class(TForm)
    REleasegrp: TGroupBox;
    Label6: TLabel;
    lbP: TLabel;
    QuantumGrp: TGroupBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    rbPotentials: TRadioButton;
    rbCurrents: TRadioButton;
    bStart: TButton;
    bAbort: TButton;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    ckDoubleExponentialDecay: TCheckBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label9: TLabel;
    GroupBox5: TGroupBox;
    Label11: TLabel;
    Label10: TLabel;
    edVRest: TValidatedEdit;
    edPoolSize: TValidatedEdit;
    edReleaseProbability: TValidatedEdit;
    edQuantumAmplitude: TValidatedEdit;
    edQuantumStDev: TValidatedEdit;
    edNoiseRMS: TValidatedEdit;
    edTauRise: TValidatedEdit;
    edLatency: TValidatedEdit;
    edTau1: TValidatedEdit;
    GroupBox6: TGroupBox;
    Label7: TLabel;
    edNumRecords: TValidatedEdit;
    Label4: TLabel;
    edRecordDuration: TValidatedEdit;
    SlowPanel: TPanel;
    lbTau2: TLabel;
    lbRatio: TLabel;
    edTau2: TValidatedEdit;
    edSlowDecayFraction: TValidatedEdit;
    Label5: TLabel;
    edDisplayRange: TValidatedEdit;
    scDisplay: TScopeDisplay;
    Label12: TLabel;
    edNumSamples: TValidatedEdit;
    procedure bStartClick(Sender: TObject);
    procedure bAbortClick(Sender: TObject);
    procedure ckDoubleExponentialDecayClick(Sender: TObject);
    procedure rbCurrentsClick(Sender: TObject);
    procedure rbPotentialsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure edPoolSizeKeyPress(Sender: TObject; var Key: Char);
    procedure edQuantumAmplitudeKeyPress(Sender: TObject; var Key: Char);
    procedure edDisplayRangeKeyPress(Sender: TObject; var Key: Char);
    procedure edNumSamplesKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    ADC : PSmallIntArray ;
    CloseFormASAP : Boolean ;

    procedure SetUnits( Units : string ) ;
    procedure EditFieldsToSettings ;
    function CheckNewDataFileNeeded : Boolean ;
    function EPCTimeCourse( x : single ;            // Time since transmitter release
                            Amplitude : single ;    // Amplitude
                            A1 : single ;           // Fast decay fraction
                            A2 : single ) : Single ; // Slow decay fraction

  public
    { Public declarations }
    procedure ChangeDisplayGrid ;
    procedure ZoomOut ;
    procedure NewFile ;
  end;
function binomial( pIn, n : Single ) : Single ;
function gammln( xx : Single ) : Single ;

var
  SynapseSim: TSynapseSim;

implementation
uses
    MDIForm , WCPFIleUnit;
{$R *.DFM}

const
    ChSim = 0 ;

procedure TSynapseSim.FormShow(Sender: TObject);
{ --------------------------------------
  Initialisations when form is displayed
  --------------------------------------}
begin

      edNumRecords.Value:= WCPFile.Settings.SynapseSim.NumRecords ;
      edRecordDuration.Value := WCPFile.Settings.SynapseSim.RecordDuration ;
      edNumSamples.Value := WCPFile.Settings.NumSamples ;
      edTauRise.Value := WCPFile.Settings.SynapseSim.TauRise ;
      edTau1.Value := WCPFile.Settings.SynapseSim.Tau1 ;
      edLatency.Value := WCPFile.Settings.SynapseSim.Latency ;
      ckDoubleExponentialDecay.Checked := WCPFile.Settings.SynapseSim.DoubleExponentialDecay ;
      edTau2.Value := WCPFile.Settings.SynapseSim.Tau2 ;
      edSlowDecayFraction.Value := WCPFile.Settings.SynapseSim.A2Fraction ;
      edQuantumAmplitude.Value := WCPFile.Settings.SynapseSim.QuantumAmplitude ;
      edQuantumStDev.Value := WCPFile.Settings.SynapseSim.QuantumStDev ;
      edPoolSize.Value := WCPFile.Settings.SynapseSim.n ;
      edReleaseProbability.Value := WCPFile.Settings.SynapseSim.p ;
      edNoiseRMS.Value := WCPFile.Settings.SynapseSim.NoiseRMS ;
      edDisplayRange.Value := WCPFile.Settings.SynapseSim.DisplayRange ;
      edVRest.Value := WCPFile.Settings.SynapseSim.VRest ;
      setUnits(  WCPFile.Settings.SynapseSim.Units ) ;

     bStart.Enabled := True ;
     bAbort.Enabled := False ;
     CloseFormASAP := False ;

     rbCurrents.checked := True ;

     SlowPanel.Visible := ckDoubleExponentialDecay.Checked ;

     SetUnits('nA') ;

     { Initialise display/controls }
     NewFile ;
     Resize ;

     end ;


procedure TSynapseSim.NewFile ;
{ ---------------------------------------------------------
  Update controls/display to account for change of data file
  ---------------------------------------------------------}
var
   ch,i : Integer ;
begin


     { Set number of channels = 1 (only if file is empty) }
     if WCPFile.RawFH.NumRecords = 0 then begin
        WCPFile.RawFH.NumChannels := 1 ;
        WCPFile.Channel[0].ChannelOffset := 0 ;
        end ;

     { Display simulated record }
     scDisplay.MaxADCValue :=  Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := -Main.SESLabIO.ADCMaxValue -1 ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;

     scDisplay.MaxPoints := WCPFile.Settings.NumSamples ;
     scDisplay.NumPoints := WCPFile.Settings.NumSamples ;
     scDisplay.NumChannels := 1 ;

     WCPFile.Channel[ChSim].ADCScale := Abs(edDisplayRange.Value) / Main.SESLabIO.ADCMaxValue ;
     scDisplay.ChanScale[ChSim] := WCPFile.Channel[ChSim].ADCScale ;

     { Set channel information }
     for ch := 0 to scDisplay.NumChannels-1 do begin
         scDisplay.ChanOffsets[ch] := WCPFile.Channel[ch].ChannelOffset ;
         scDisplay.ChanUnits[ch] := WCPFile.Channel[Ch].ADCUnits ;
         scDisplay.ChanName[ch] := WCPFile.Channel[Ch].ADCName ;
         scDisplay.ChanScale[ch] := WCPFile.Channel[ch].ADCScale ;
         WCPFile.Channel[Ch].yMin := scDisplay.MinADCValue ;
         WCPFile.Channel[Ch].yMax := scDisplay.MaxADCValue ;
         scDisplay.yMin[ch] := WCPFile.Channel[Ch].yMin ;
         scDisplay.yMax[ch] := WCPFile.Channel[Ch].yMax ;
         scDisplay.ChanVisible[ch] := True
         end ;

     scDisplay.xMin := 0 ;
     scDisplay.xMax := WCPFile.Settings.NumSamples ;
     scDisplay.xOffset := 0 ;
     scDisplay.TScale := WCPFile.RawFH.dt*WCPFile.Settings.TScale ;
     scDisplay.TUnits := WCPFile.Settings.TUnits ;

     // Reallocate A/D sample buffer
     if ADC <> Nil then FreeMem(ADC) ;
     GetMem( ADC, Max(WCPFile.Settings.NumSamples*WCPFile.RawFH.NumChannels*2,1024) ) ;
     { Clear all channels }
     for i := 0 to WCPFile.Settings.NumSamples*WCPFile.RawFH.NumChannels-1 do ADC^[i] := 0 ;
     scDisplay.SetDataBuf( ADC ) ;

     end ;


procedure TSynapseSim.SetUnits( Units : string ) ;
begin
     edQuantumAmplitude.Units := Units ;
     edQuantumStDev.Units := Units ;
     edNoiseRMS.Units := Units ;
     edDisplayRange.Units := Units ;
     WCPFile.Channel[ChSim].ADCUnits := Units ;
     scDisplay.ChanUnits[ChSim] := WCPFile.Channel[ChSim].ADCUnits ;
     scDisplay.Invalidate ;
     WCPFile.Settings.SynapseSim.Units := Units ;

     end ;


procedure TSynapseSim.EditFieldsToSettings ;
// ------------------------------
// Save settings from edit fields
// ------------------------------
begin

    WCPFile.Settings.NumSamples := Min(Round(edNumSamples.Value),Main.SESLabIO.ADCBufferLimit) ;
    WCPFile.Settings.NumSamples := 256*Max(WCPFile.Settings.NumSamples div 256,1) ;
    edNumSamples.Value := WCPFile.Settings.NumSamples ;

     WCPFile.Settings.SynapseSim.NumRecords := Round(edNumRecords.Value) ;
     WCPFile.Settings.SynapseSim.RecordDuration := edRecordDuration.Value ;
     WCPFile.Settings.SynapseSim.TauRise := edTauRise.Value ;
     WCPFile.Settings.SynapseSim.Tau1 := edTau1.Value ;
     WCPFile.Settings.SynapseSim.Latency := edLatency.Value ;
     WCPFile.Settings.SynapseSim.Tau2 := edTau2.Value ;
     WCPFile.Settings.SynapseSim.A2Fraction := edSlowDecayFraction.Value ;
     WCPFile.Settings.SynapseSim.QuantumAmplitude := edQuantumAmplitude.Value ;
     WCPFile.Settings.SynapseSim.QuantumStDev := edQuantumStDev.Value ;
     WCPFile.Settings.SynapseSim.n := edPoolSize.Value ;
     WCPFile.Settings.SynapseSim.p := edReleaseProbability.Value ;
     WCPFile.Settings.SynapseSim.NoiseRMS := edNoiseRMS.Value ;
     WCPFile.Settings.SynapseSim.DisplayRange := edDisplayRange.Value ;
     WCPFile.Settings.SynapseSim.VRest := edVRest.Value ;
     WCPFile.Settings.SynapseSim.DoubleExponentialDecay := ckDoubleExponentialDecay.Checked ;

     end ;


procedure TSynapseSim.bStartClick(Sender: TObject);
{ ---------------------------------------------------------
  Generate a file of simulated synaptic currents/potentials
  --------------------------------------------------------- }
var
   i,j,ch,NumRecordsDone,iStartEPC : Integer ;
   A1,A2,Amplitude : Single  ;
   ySig,QuantalContent : Single ;
   x,y,yPeak,yNlsScale,EPCPeakScale,QuantumPeak : single ;
   Done : Boolean ;
   RH : TRecHeader ; { Record header }
begin

     EditFieldsToSettings ;

     if not CheckNewDataFileNeeded then Exit ;

     bStart.Enabled := False ;
     bAbort.Enabled := True ;
     CloseFormASAP := False ;
     NumRecordsDone := 0 ;

     WCPFile.Channel[ChSim].ADCUnits := WCPFile.Settings.SynapseSim.Units ;
     if WCPFile.Channel[ChSim].ADCUnits = 'mV' then WCPFile.Channel[ChSim].ADCName := 'Vm'
                                       else WCPFile.Channel[ChSim].ADCName := 'Im' ;

     WCPFile.Channel[ChSim].ADCZero := 0 ;
     WCPFile.Channel[ChSim].xMin := 0 ;
     WCPFile.Channel[ChSim].xMax := WCPFile.Settings.NumSamples-1 ;
     WCPFile.Channel[ChSim].yMin := Main.SESLabIO.ADCMinValue ;
     WCPFile.Channel[ChSim].yMax := Main.SESLabIO.ADCMaxValue ;
     WCPFile.Channel[ChSim].InUse := True ;
     WCPFile.RawFH.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     WCPFile.RawFH.MinADCValue := Main.SESLabIO.ADCMinValue ;

     WCPFile.WriteToLogFile( 'Synaptic current simulation') ;
     WCPFile.WriteToLogFile( 'Tau(rise) = ' + edTauRise.text ) ;
     WCPFile.WriteToLogFile( 'Tau(1) = ' + edTau1.text ) ;
     WCPFile.WriteToLogFile( 'Latency = ' + edLatency.text ) ;
     WCPFile.WriteToLogFile( 'Quantum amplitude = ' + edQuantumAmplitude.text ) ;
     WCPFile.WriteToLogFile( 'Quantum st. dev. = ' + edQuantumStDev.text ) ;
     WCPFile.WriteToLogFile( 'Pool Size = ' + edPoolSize.text ) ;
     WCPFile.WriteToLogFile( 'Release Probability = ' + edReleaseProbability.text ) ;
     WCPFile.WriteToLogFile( 'Noise RMS = ' + edNoiseRMS.text ) ;

     { Sampling interval }
     WCPFile.Settings.NumSamples := Round(edNumSamples.Value) ;
     WCPFile.RawFH.NumSamples := WCPFile.Settings.NumSamples ;
     WCPFile.RawFH.NumChannels := 1 ;

     // Reallocate A/D sample buffer
     if ADC <> Nil then FreeMem(ADC) ;
     GetMem( ADC, Max(WCPFile.RawFH.NumSamples*WCPFile.RawFH.NumChannels*2,1024) ) ;
     scDisplay.SetDataBuf( ADC ) ;

     WCPFile.RawFH.dt := WCPFile.Settings.SynapseSim.RecordDuration / WCPFile.Settings.NumSamples ;
     if ckDoubleExponentialDecay.checked then begin
        { Time constant for 2nd decay exponential }
        WCPFile.WriteToLogFile( 'Tau(2) = ' + edTau2.text ) ;
        A2 := WCPFile.Settings.SynapseSim.A2Fraction ;
        WCPFile.WriteToLogFile( 'Slow amplitude fraction = ' + edTau2.text ) ;
        A1 := 1. - A2 ;
        end
     else begin
        A1 := 1.0 ;
        A2 := 0.0 ;
        end ;

     { Set channel parameters }
     { Estimate maximal quantal content of 100 trials }
     QuantalContent := 0. ;
     for i := 1 to 100 do
         QuantalContent := Max(QuantalContent,Binomial(WCPFile.Settings.SynapseSim.p,WCPFile.Settings.SynapseSim.n));

     if WCPFile.RawFH.NumRecords <= 0 then
        begin
        // Set calibration factor if file is empty
        WCPFile.Channel[ChSim].ADCScale := Abs(WCPFile.Settings.SynapseSim.DisplayRange) / (Main.SESLabIO.ADCMaxValue + 1);
        RH.ADCVoltageRange[ChSim] := 10.0 ;
        WCPFile.Channel[ChSim].ADCCalibrationFactor := RH.ADCVoltageRange[ChSim] /
                                              ( WCPFile.Channel[ChSim].ADCScale * (Main.SESLabIO.ADCMaxValue +1) ) ;
        end
     else begin
        // Set RH.ADCVoltageRange to account for any changes in current scaling
        // if records already exist
        WCPFile.Channel[ChSim].ADCScale := Abs(edDisplayRange.Value) / (Main.SESLabIO.ADCMaxValue + 1);
        RH.ADCVoltageRange[ChSim] := WCPFile.Channel[ChSim].ADCCalibrationFactor *
                                     WCPFile.Channel[ChSim].ADCScale * (Main.SESLabIO.ADCMaxValue +1) ;
        end ;


//   Determine amplitude of miniature synaptic waveform and scaling factor for nls calculation

     x := 0. ;
     yPeak := 0.0 ;
     iStartEPC := WCPFile.RawFH.NumSamples div 10 + Round(-(WCPFile.Settings.SynapseSim.Latency*ln(random))/WCPFile.RawFH.dt);
     for i := 0 to WCPFile.RawFH.NumSamples-1 do
         begin
         if i >= iStartEPC then
            begin
            y  := EPCTimeCourse( x, edQuantumAmplitude.Value, A1, A2 ) ;
            x := x + WCPFile.Rawfh.dt ;
            end ;

         // Determine peak amplitude
         if y >= Abs(yPeak) then yPeak := y ;

         end ;
     QuantumPeak := yPeak ;
     EPCPeakScale := yPeak / edQuantumAmplitude.Value ;

     Done := False ;
     while not Done do begin

         // Ensure display channel scaling factor is up to date
         scDisplay.ChanScale[ChSim] := WCPFile.Channel[ChSim].ADCScale ;

         { Clear all channels }
         for ch := 0 to scDisplay.NumChannels-1 do
             for i := 0 to WCPFile.RawFH.NumSamples-1 do ADC[i] := 0 ;

         { Create simulated synaptic current }

         { Set EPC amplitude }
         QuantalContent := Binomial( WCPFile.Settings.SynapseSim.p, WCPFile.Settings.SynapseSim.n ) ;
         Amplitude := 0.0 ;
         for i := 1 to Round(QuantalContent) do
             begin
             Amplitude := Amplitude + edQuantumAmplitude.Value + RandG(0.0, WCPFile.Settings.SynapseSim.QuantumStDev) ;
             end;

         x := 0. ;
         iStartEPC := WCPFile.RawFH.NumSamples div 10 + Round(-(WCPFile.Settings.SynapseSim.Latency*ln(random))/WCPFile.RawFH.dt);
         j := WCPFile.Channel[ChSim].ChannelOffset ;

         // Calculate NLS scaling factor
         if Abs(QuantalContent*QuantumPeak) > 0.001 then
            begin
            yNlsScale := (Abs(edVRest.Value) / (1.0 + (Abs(edVRest.Value)/(QuantalContent*QuantumPeak)))) /
                         (Amplitude*EPCPeakScale) ;
            end
         else yNlsScale := 1.0 ;

         for i := 0 to WCPFile.RawFH.NumSamples-1 do
             begin

             { Create background noise with gaussian distribution }
             y := RandG(0.0, WCPFile.Settings.SynapseSim.NoiseRMS) ;

             if i >= iStartEPC then
                begin
                y  := y + EPCTimeCourse( x, Amplitude, A1, A2 ) ;
                x := x + WCPFile.Rawfh.dt ;
                end ;

            // Scale for non-linear summation if potentials
            if rbPotentials.Checked then y := y*yNlsScale ;

             // Keep within display range

             y := Min(Max(y,Main.SESLabIO.ADCMinValue*WCPFile.Channel[ChSim].ADCScale),
                            Main.SESLabIO.ADCMaxValue*WCPFile.Channel[ChSim].ADCScale);

             // Write to buffer
             ADC^[j] := Round(y/WCPFile.Channel[ChSim].ADCScale) + WCPFile.Channel[ChSim].ADCZero ;

             j := j + WCPFile.RawFH.NumChannels ;
             end ;

         scDisplay.TScale := WCPFile.RawFH.dt*WCPFile.Settings.TScale ;
         scDisplay.TUnits := WCPFile.Settings.TUnits ;

         { Save Record to file }
         Inc(WCPFile.RawFH.NumRecords) ;
         RH.Status := 'ACCEPTED' ;
         if (WCPFile.Settings.SynapseSim.n = 1. )
            and (WCPFile.Settings.SynapseSim.p = 1. ) then RH.RecType := 'MINI'
                                              else RH.RecType := 'EVOK' ;

         RH.Number := WCPFile.RawfH.NumRecords ;
         RH.Time := RH.Number ;
         RH.dt := WCPFile.RawfH.dt ;
         RH.EqnType := None ;
         RH.AnalysisAvailable := False ;
         RH.Ident := ' ' ;
         WCPFile.PutRecord( WCPFile.RawfH, RH, WCPFile.RawfH.NumRecords, ADC^ ) ;

         { Terminate when all records done (or abort button pressed) }
         Inc(NumRecordsDone) ;

         Main.StatusBar.SimpleText := format(
         'Nerve-evoked EPSC simulation : Record %d/%d created.',
         [NumRecordsDone,WCPFile.Settings.SynapseSim.NumRecords] ) ;

         if (NumRecordsDone >= WCPFile.Settings.SynapseSim.NumRecords) or bStart.Enabled then Done := True ;

         scDisplay.Invalidate ;
         Application.ProcessMessages ;

         if CloseFormASAP then Done := True ;

         end ;

     WCPFile.SaveHeader( WCPFile.RawFH ) ;

     Main.StatusBar.SimpleText := format(
                                  'Nerve-evoked EPSC simulation : %d records created.',
                                  [NumRecordsDone] ) ;

     bStart.Enabled := True ;
     bAbort.Enabled := False ;

     // Close form if requested
     if CloseFormASAP then Close ;

     end;

function TSynapseSim.EPCTimeCourse( x : single ;            // Time since transmitter release
                                    Amplitude : single ;    // Amplitude
                                    A1 : single ;           // Fast decay fraction
                                    A2 : single ) : Single ; // Slow decay fraction
// --------------------------------------
// Calculate endplate current time course
// --------------------------------------
var
    y : single ;
begin
     y := Amplitude*(A1*exp(-x/ WCPFile.Settings.SynapseSim.Tau1))  ;
     if ckDoubleExponentialDecay.checked then
        y := y + Amplitude*(A2*exp(-x/ WCPFile.Settings.SynapseSim.Tau2)) ;
     if WCPFile.Settings.SynapseSim.TauRise > 0.0 then
        y := y*0.5*(1.+erf( (x/WCPFile.Settings.SynapseSim.TauRise)-3. ) ) ;
     Result := y ;
end;



function TSynapseSim.CheckNewDataFileNeeded : Boolean ;
// ------------------------------------------------------------
// Check record size and created a new file if size has changed
// ------------------------------------------------------------
var
    NewFileName,Stem : String ;
    n : Integer ;
begin

     NewFileName := '' ;

     // Create a new file if none open
     if WCPFile.RawFH.FileHandle <= 0 then begin
        // No file open .. open new one
        NewFileName := WCPFIle.CreateIndexedFileName( WCPFile.RawFH.FileName ) ;
        end
     else if (WCPFile.RawFH.NumRecords > 0) and
        ((WCPFile.RawFH.NumChannels <> 1) or (WCPFile.RawFH.NumSamples <> Round(edNumSamples.Value))) then begin
        // No. channels or samples changed .. create .nn.wcp file
        // Extract stem of file name
        Stem := ANSIReplaceText( WCPFile.RawFH.FileName, '.wcp', '.' ) ;
        n := Pos( '.', Stem ) ;
        if n > 0 then Stem := LeftStr(Stem,n) ;

        n := 1 ;
        repeat
           NewFileName := Stem + format('%d.wcp',[n]) ;
           Inc(n) ;
           until not FileExists(NewFileName) ;
        end ;

     // Create new file (if required)
     if NewFileName <> '' then begin
        WCPFile.RawFH.NumChannels := 1 ;
        WCPFile.RawFH.NumSamples := Round(edNumSamples.Value) ;
        WCPFile.CreateNewDataFile( NewFileName ) ;
        Result := True ;
        end
     else Result := True ;

     end ;


procedure TSynapseSim.bAbortClick(Sender: TObject);
{ --------------------
  Abort simulation run
  -------------------- }
begin
     bStart.Enabled := True ;
     bAbort.Enabled := False ;
     end;


procedure TSynapseSim.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := -Main.SESLabIO.ADCMaxValue -1 ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;

     scDisplay.Invalidate ;
     end ;


procedure  TSynapseSim.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := -Main.SESLabIO.ADCMaxValue -1 ;
     scDisplay.ZoomOut ;
     end ;



function binomial( pIn, n : Single ) : Single ;
{ --------------------------------------------
  Binomial random number generator
  Returns a number from the distribution B(pIn,n)
  where pIn = probability, n = number of items
  (Base on Numerical Recipes code)
  --------------------------------------------}
var
   p,mean,r,em,g,t,oldg,pc,pclog,y,plog,sq,zz : Single ;
   i : Integer ;
   quit : Boolean ;
begin

	if pIn > 0.5 then p := 1. - pIn
                     else p := pIn ;

	mean := n*p ;
	if n <= 25.  then begin
	    r := 0. ;
	    for i := 1 to Round(n) do if random < p then r := r + 1. ;
            end
	else if mean < 1. then begin
	    g := exp(-mean) ;
	    t := 1. ;
	    r := 0. ;
	    while( (r<n) and (t<g) ) do begin
		t := t*random ;
		r := r + 1. ;
                end ;
            end
	else begin
	   oldg := gammln(n+1. ) ;
	   pc := 1. - p ;
	   plog := ln(p) ;
	   pclog := ln(pc) ;
	   sq := sqrt(2.*mean*pc) ;

	   quit := False ;
	   while( not quit ) do begin
         { Make sure TAN(infinity) is not calculated }
         repeat zz := random until (Abs(zz-0.5)>0.001) ;
	       y := sin(zz*Pi) / cos(zz*Pi) ;
	       em := sq*y + mean ;
	       if (em >= 0. ) and (em < n+1. ) then begin
		        em := Int(em) ;
		        t := 1.2*sq*(1.+y*y)*exp(oldg-gammln(em+1. ) -
     		          gammln(n-em+1. ) + em*plog + (n-em)*pclog) ;
		        if( random <= t ) then quit := True ;
            end ;
         end ;
	    r := em ;
	    end ;

	if ( p <> pIn ) then r := n - r ;
	binomial := r ;
        end ;

function gammln( xx : Single ) : Single ;
var
   stp,x,tmp,ser : Double ;
   cof : Array[1..7] of Double ;
   i : Integer ;
begin
	cof[1] := 76.18009173 ;
	cof[2] := -86.50532033 ;
	cof[3] := 24.01409822 ;
	cof[4] := -1.231739516 ;
	cof[5] := 0.120858003E-2 ;
	cof[6] := -0.536382E-5 ;
	stp := 2.50662827465 ;

	x := (xx - 1. ) ;
	tmp := x + 5.5 ;
	tmp := ( x + 0.5)*ln(tmp) - tmp;
	ser := 1. ;
	for i := 1 to 6 do begin
	    x := x + 1. ;
	    ser := ser + cof[i]/x ;
	    end ;
	tmp := tmp + ln(stp*ser) ;
	gammln := tmp ;
        end ;


procedure TSynapseSim.ckDoubleExponentialDecayClick(Sender: TObject);
begin
     SlowPanel.Visible := ckDoubleExponentialDecay.Checked ;
     end;

procedure TSynapseSim.rbCurrentsClick(Sender: TObject);
begin
     SetUnits('nA') ;
     end;

procedure TSynapseSim.rbPotentialsClick(Sender: TObject);
begin
     SetUnits('mV')
     end;


procedure TSynapseSim.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     if WCPFile.RawFH.NumRecords > 0 then begin
        Main.mnShowRaw.Enabled := True ;
        Main.mnShowRaw.Click ;
        Main.mnZoomOutAll.Click ;
        end ;

     Action := caFree ;

     end;

procedure TSynapseSim.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
     if not bStart.Enabled then CanClose := False
                           else CanClose := True ;
     CloseFormASAP := True ;
     end;

procedure TSynapseSim.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin
    ADC := Nil ;
    end;

procedure TSynapseSim.FormDestroy(Sender: TObject);
// ------------------------------
// Tidy up when form is destroyed
// ------------------------------
begin
    if ADC <> Nil then FreeMem(ADC) ;
    end;


procedure TSynapseSim.FormResize(Sender: TObject);
{ ------------------------------------------------------
  Adjust size/position of controls when form is re-sized
  ------------------------------------------------------ }
begin
      QuantumGrp.Top := ClientHeight - QuantumGrp.Height - 5 ;
      QuantumGrp.Width := ClientWidth - 2*QuantumGrp.Left ;
      scDisplay.Height := MaxInt( [QuantumGrp.Top - scDisplay.Top - 10,2]) ;
      scDisplay.Width := MaxInt( [QuantumGrp.Width + QuantumGrp.Left - scDisplay.Left,2]) ;
      end;

procedure TSynapseSim.scDisplayCursorChange(Sender: TObject);
var
   ch : Integer ;
begin
     { Update channel descriptors with any changes to display }
     for ch := 0 to scDisplay.NumChannels-1 do if WCPFile.Channel[ch].InUse then begin
         WCPFile.Channel[Ch].yMin := scDisplay.YMin[Ch] ;
         WCPFile.Channel[Ch].yMax := scDisplay.YMax[Ch] ;
         end ;
     end;

procedure TSynapseSim.edPoolSizeKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then begin
        edDisplayRange.Value := Abs( edPoolSize.Value*edReleaseProbability.Value
                                     *edQuantumAmplitude.Value*2.0) ;
        end ;
    end;

procedure TSynapseSim.edQuantumAmplitudeKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key = #13 then begin
        edDisplayRange.Value := Abs( edPoolSize.Value*edReleaseProbability.Value
                                     *edQuantumAmplitude.Value*2.0) ;
        end ;
    end;

procedure TSynapseSim.edDisplayRangeKeyPress(Sender: TObject;
  var Key: Char);
// ---------------------
// Display range changed
// ---------------------
begin
     if key = #13 then begin
        WCPFile.Channel[ChSim].ADCScale := Abs(edDisplayRange.Value) / Main.SESLabIO.ADCMaxValue ;
        scDisplay.ChanScale[ChSim] := WCPFile.Channel[ChSim].ADCScale ;
        scDisplay.Invalidate ;
        end ;
     end;

procedure TSynapseSim.edNumSamplesKeyPress(Sender: TObject; var Key: Char);
begin
     if key = #13 then EditFieldsToSettings ;
     end;

end.
