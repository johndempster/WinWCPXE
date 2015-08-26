unit Simhh;
{ ==================================================================
  WinWCP - Voltage-activated current simulation (c) J. Dempster 1996-99
  14/7/99 V3.0 .... Converted to 32 bit
  4/9/99 ... Display grid added
  30/10/99 ... NewFile method added
  24/1/99 .... Inactivation kinetics fixed
  25/2/02 .... Display now updated during simulation
               Progress is reported on main status bar
  24.6.03 ... No. of display grid lines can be changed
  04.12.05 .. New equation parameter input table
  18.05.10 .. Activation and inactivation parameter time constants
              now determined by time constant equation. Default represents
              transient outward current (Ito) in atrial myocytes
  17.06.10 .. Settings now stored in Settings. and in INI file
  16.11.11 .. No. Samples box added to control panel
  09.08.13 .. ADC now allocated by GetMem()
  ================================================================== }
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, TabNotBk, ExtCtrls, Global, Shared, FileIO, maths,
  ValEdit, ScopeDisplay, ComCtrls, math, ValidatedEdit, HTMLLabel, seslabio, strutils ;

type
  TVClampSim = class(TForm)
    QuantumGrp: TGroupBox;
    Label9: TLabel;
    GroupBox1: TGroupBox;
    bStart: TButton;
    bAbort: TButton;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    GroupBox7: TGroupBox;
    rbNoLeakSubtraction: TRadioButton;
    rbLeakSubtraction: TRadioButton;
    scDisplay: TScopeDisplay;
    edVHold: TValidatedEdit;
    edVStep: TValidatedEdit;
    edNumSteps: TValidatedEdit;
    edLeakDivBy: TValidatedEdit;
    edNoiseRMS: TValidatedEdit;
    EquationGrp: TGroupBox;
    GroupBox4: TGroupBox;
    edGMax: TValidatedEdit;
    edGLeak: TValidatedEdit;
    edGSeries: TValidatedEdit;
    edVRev: TValidatedEdit;
    edPower: TValidatedEdit;
    edCm: TValidatedEdit;
    HTMLLabel1: THTMLLabel;
    HTMLLabel2: THTMLLabel;
    HTMLLabel3: THTMLLabel;
    HTMLLabel4: THTMLLabel;
    HTMLLabel5: THTMLLabel;
    HTMLLabel6: THTMLLabel;
    HTMLLabel7: THTMLLabel;
    MGroup: TGroupBox;
    HTMLLabel11: THTMLLabel;
    GroupBox6: TGroupBox;
    HTMLLabel15: THTMLLabel;
    ckInactivation: TCheckBox;
    GroupBox3: TGroupBox;
    HTMLLabel8: THTMLLabel;
    HTMLLabel9: THTMLLabel;
    edMInfVHalf: TValidatedEdit;
    edMinfVSlope: TValidatedEdit;
    GroupBox5: TGroupBox;
    HTMLLabel10: THTMLLabel;
    edMTauVhalf: TValidatedEdit;
    HTMLLabel16: THTMLLabel;
    edMTauVSlope: TValidatedEdit;
    HTMLLabel17: THTMLLabel;
    edMtauMin: TValidatedEdit;
    HTMLLabel18: THTMLLabel;
    edMTauMax: TValidatedEdit;
    GroupBox8: TGroupBox;
    HTMLLabel12: THTMLLabel;
    HTMLLabel13: THTMLLabel;
    edHinfVhalf: TValidatedEdit;
    edHinfVslope: TValidatedEdit;
    GroupBox9: TGroupBox;
    HTMLLabel14: THTMLLabel;
    HTMLLabel19: THTMLLabel;
    HTMLLabel20: THTMLLabel;
    HTMLLabel21: THTMLLabel;
    edHtauVhalf: TValidatedEdit;
    edHtauVslope: TValidatedEdit;
    edHtauMin: TValidatedEdit;
    edHtauMax: TValidatedEdit;
    HTMLLabel22: THTMLLabel;
    HTMLLabel23: THTMLLabel;
    HTMLLabel24: THTMLLabel;
    HTMLLabel25: THTMLLabel;
    GroupBox10: TGroupBox;
    Label12: TLabel;
    edNumSamples: TValidatedEdit;
    procedure bStartClick(Sender: TObject);
    procedure bAbortClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure edVRevKeyPress(Sender: TObject; var Key: Char);
    procedure edGMaxKeyPress(Sender: TObject; var Key: Char);
    procedure edGLeakKeyPress(Sender: TObject; var Key: Char);
    procedure edTauMKeyPress(Sender: TObject; var Key: Char);
    procedure edTauHKeyPress(Sender: TObject; var Key: Char);
    procedure edNumSamplesKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    ADC : PSmallIntarray ;
    procedure UpdateDisplayScale ;
    function TauFunction(
          V : Single ;
          TauMin : Single ;
          TauMax : Single ;
          TauVhalf : Single ;
          TauVslope : single ) : Single ;
    function Boltz( V, VHalf, VSlope : Single ) : Single ;
    procedure EditFieldsToSettings ;
    function CheckNewDataFileNeeded : Boolean ;
  public
    { Public declarations }
    procedure ChangeDisplayGrid ;
    procedure ZoomOut ;
    procedure NewFile ;
  end;

var
  VClampSim: TVClampSim;

implementation

uses mdiform ;

{$R *.DFM}
const
     ChIm = 0 ;
     ChVm = 1 ;
    VMax = 0.2 ; { Note in volts}

procedure TVClampSim.FormShow(Sender: TObject);
{ --------------------------------------
  Initialisations when form is displayed
  --------------------------------------}
begin

     edNumSamples.Value := Settings.NumSamples ;
     edNumSteps.Value := Settings.VClampSim.NumSteps ;
     edGMax.Value := Settings.VClampSim.GMax ;
     edGLeak.Value := Settings.VClampSim.GLeak  ;
     edGSeries.Value := Settings.VClampSim.GSeries ;
     edCm.Value := Settings.VClampSim.Cm ;
     edVRev.Value := Settings.VClampSim.VRev ;
     edVHold.Value := Settings.VClampSim.VHold ;
     edVStep.Value := Settings.VClampSim.VStep ;
     edNoiseRMS.Value := Settings.VClampSim.NoiseRMS ;

     { Activation gate (m) parameters }
     edMInfVHalf.Value := Settings.VClampSim.m.VHalf ;
     edMInfVSlope.Value := Settings.VClampSim.m.VSlope ;
     edMTauMin.Value := Settings.VClampSim.m.TauMin ;
     edMTauMax.Value := Settings.VClampSim.m.TauMax ;
     edMTauVhalf.Value := Settings.VClampSim.m.TauVHalf ;
     edMTauVslope.Value := Settings.VClampSim.m.TauVslope ;
     edPower.Value := Settings.VClampSim.m.P ;

     // Inactivation gate
     ckInActivation.Checked := Settings.VClampSim.UseInactivation ;
     edHInfVHalf.Value := Settings.VClampSim.h.VHalf ;
     edHInfVSlope.Value := Settings.VClampSim.h.VSlope ;
     edHTauMin.Value := Settings.VClampSim.h.TauMin ;
     edHTauMax.Value := Settings.VClampSim.h.TauMax ;
     edHTauVhalf.Value := Settings.VClampSim.h.TauVHalf ;
     edHTauVslope.Value := Settings.VClampSim.h.TauVslope ;
     Settings.VClampSim.h.P := 1. ;

     { Initialise control buttons }
     bStart.Enabled := True ;
     bAbort.Enabled := False ;

     { Initialise display/controls }
     NewFile ;
     Resize ;
     UpdateDisplayScale ;

     end ;


procedure TVClampSim.NewFile ;
{ ---------------------------------------------------------
  Update controls/display to account for change of data file
  ---------------------------------------------------------}
var
   ch,i : Integer ;
begin

     if RawFH.NumRecords = 0 then begin
        RawFH.NumChannels := 2 ;
        RawFH.NumSamples := Settings.NumSamples ;
        end;

     { Set up scope display }
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;

     scDisplay.DisplayGrid := Settings.DisplayGrid ;

     scDisplay.MaxPoints := Settings.NumSamples ;
     scDisplay.NumPoints := Settings.NumSamples ;
     scDisplay.NumChannels := 2 ;

     { Set channel information }
     for ch := 0 to scDisplay.NumChannels-1 do begin
         Channel[ch].ChannelOffset := ch ;
         scDisplay.ChanOffsets[ch] := Channel[ch].ChannelOffset ;
         scDisplay.ChanUnits[ch] := Channel[Ch].ADCUnits ;
         scDisplay.ChanName[ch] := Channel[Ch].ADCName ;
         scDisplay.ChanScale[ch] := Channel[Ch].ADCScale ;
         Channel[Ch].yMin := scDisplay.MinADCValue ;
         Channel[Ch].yMax := scDisplay.MaxADCValue ;
         scDisplay.yMin[ch] := Channel[ch].yMin ;
         scDisplay.yMax[ch] := Channel[ch].yMax ;
         scDisplay.ChanVisible[ch] := True ;
         end ;

     scDisplay.xMin := 0 ;
     scDisplay.xMax := Settings.NumSamples - 1 ;
     scDisplay.xOffset := 0 ;
     scDisplay.TScale := RawFH.dt*1000.0 ;
     scDisplay.TUnits := Settings.TUnits ;

     // Reallocate A/D sample buffer
     if ADC <> Nil then FreeMem(ADC) ;
     GetMem( ADC, Max(Settings.NumSamples*scDisplay.NumChannels*2,1024) ) ;
     for i := 0 to Settings.NumSamples*scDisplay.NumChannels-1 do ADC^[i] := 0 ;
     scDisplay.SetDataBuf( ADC ) ;

     end;

procedure TVClampSim.EditFieldsToSettings ;
// ------------------------------
// Save settings from edit fields
// ------------------------------
begin

     Settings.NumSamples := Min(Round(edNumSamples.Value),Main.SESLabIO.ADCBufferLimit) ;
     Settings.NumSamples := 256*Max(Settings.NumSamples div 256,1) ;
     edNumSamples.Value := Settings.NumSamples ;

     Settings.VClampSim.NumSteps := Round(edNumSteps.Value) ;
     Settings.VClampSim.GMax := edGMax.Value ;
     Settings.VClampSim.GLeak := edGLeak.Value ;
     Settings.VClampSim.GSeries := edGSeries.Value ;
     Settings.VClampSim.Cm := edCm.Value ;
     Settings.VClampSim.VRev := edVRev.Value ;
     Settings.VClampSim.VHold := edVHold.Value ;
     Settings.VClampSim.VStep := edVStep.Value ;
     Settings.VClampSim.NoiseRMS := edNoiseRMS.Value ;

     Settings.VClampSim.m.VHalf := edMInfVHalf.Value ;
     Settings.VClampSim.m.VSlope := edMInfVSlope.Value ;
     Settings.VClampSim.m.TauMin := edMTauMin.Value ;
     Settings.VClampSim.m.TauMax := edMTauMax.Value ;
     Settings.VClampSim.m.TauVHalf := edMTauVhalf.Value ;
     Settings.VClampSim.m.TauVslope := edMTauVslope.Value ;
     Settings.VClampSim.m.P := edPower.Value ;

     { Inactivation gate (h) parameters }
     Settings.VClampSim.UseInactivation := ckInActivation.Checked ;
     Settings.VClampSim.h.VHalf := edHInfVHalf.Value ;
     Settings.VClampSim.h.VSlope := edHInfVSlope.Value ;
     Settings.VClampSim.h.TauMin := edHTauMin.Value ;
     Settings.VClampSim.h.TauMax := edHTauMin.Value ;
     Settings.VClampSim.h.TauVHalf := edHTauVhalf.Value ;
     Settings.VClampSim.h.TauVslope := edHTauVslope.Value ;

     Settings.VClampSim.h.P := 1. ;

     end ;


procedure TVClampSim.bStartClick(Sender: TObject);
{ ---------------------------------------------------------
  Generate a file of simulated voltage-activated currents
  --------------------------------------------------------- }
var
   i,j,ch,iStart,iEnd : Integer ;
   Vm,Im,x,Gm : single ;
   NumRecordsDone,GroupNumber,NumPulses : Integer ;
   Rec : Integer ;
   FirstRecord : Boolean ;
   RH : TRecHeader ; { Record header }
   TauC,Ic,ITot : Single ;
   VOld,IMax,IScale,VScale,VTest,VLeak,Vp,TauV: Single ;
   Tau,TauMax,V : Single ;
   m,h,h0 : Single ;
   Done : Boolean ;
begin

     bStart.Enabled := False ;
     bAbort.Enabled := True ;

     // Copy settings from edit fields to Settings.VClampSim
     EditFieldsToSettings ;

     if not CheckNewDataFileNeeded then Exit ;

     WriteToLogFile( 'Hodgkin-Huxley Voltage Clamp Simulation ' ) ;
     WriteToLogFile( 'GMax = ' + edGMax.text ) ;
     WriteToLogFile( 'GLeak = ' + edGLeak.text ) ;
     WriteToLogFile( 'GSeries = ' + edGSeries.text ) ;
     WriteToLogFile( 'Cm = ' + edCm.text ) ;
     WriteToLogFile( 'VRev = ' + edVRev.text ) ;
     WriteToLogFile( 'm V.half = ' + edMInfVHalf.text ) ;
     WriteToLogFile( 'm V.slope = ' + edMInfVSlope.text ) ;
     WriteToLogFile( 'm Tau.min = ' + edMTauMin.text ) ;
     WriteToLogFile( 'm Tau.max = ' + edMTauMax.text ) ;
     WriteToLogFile( 'm Tau.vhalf = ' + edMTauVHalf.text ) ;
     WriteToLogFile( 'm Tau.vslope = ' + edMTauVslope.text ) ;
     WriteToLogFile( 'm Power factor = ' + edPower.text ) ;
     WriteToLogFile( 'h V.half = ' + edHInfVHalf.text ) ;
     WriteToLogFile( 'h Tau.min = ' + edHTauMin.text ) ;
     WriteToLogFile( 'h Tau.max = ' + edHTauMax.text ) ;
     WriteToLogFile( 'h Tau.vhalf = ' + edHTauVHalf.text ) ;
     WriteToLogFile( 'h Tau.vslope = ' + edHTauVslope.text ) ;

     Settings.VClampSim.h.P := 1. ;

     { Capacity current time constant }
     TauC := Settings.VClampSim.Cm / Settings.VClampSim.GSeries ;

     { Set channel parameters }

     { If this is the first record in the file create
     an appropriate scaling factor }
     if RawfH.NumRecords = 0 then begin

        NewFile ;

        UpdateDisplayScale ;

        Channel[ChIm].ADCScale := scDisplay.ChanScale[ChIm];
        RH.ADCVoltageRange[ChIm] := 10. ;
        Channel[ChIm].ADCCalibrationFactor := RH.ADCVoltageRange[ChIm] /
                                  ( Channel[ChIm].ADCScale * (Main.SESLabIO.ADCMaxValue+1) ) ;

        { Set voltage channel scaling factor }
        Channel[ChVm].ADCScale := scDisplay.ChanScale[ChVm];
        scDisplay.ChanScale[ChVm] := Channel[ChVm].ADCScale ;
        RH.ADCVoltageRange[ChVm] := 10. ;
        Channel[ChVm].ADCCalibrationFactor := RH.ADCVoltageRange[ChVm] /
                                  ( Channel[ChVm].ADCScale * (Main.SESLabIO.ADCMaxValue+1) ) ;

        // Determine longest transient time course
        TauMax := 0.0 ;
        for i := 0 to Settings.VClampSim.NumSteps-1 do begin
            V := edVHold.Value + edVStep.Value*i ;
            Tau := TauFunction( V,
                                Settings.VClampSim.m.TauMin,
                                Settings.VClampSim.m.TauMax,
                                Settings.VClampSim.m.TauVHalf,
                                Settings.VClampSim.m.TauVSlope) ;
            TauMax := Max(Tau,TauMax) ;
            if ckInactivation.Checked then
               Tau := TauFunction( V,
                                   Settings.VClampSim.h.TauMin,
                                   Settings.VClampSim.h.TauMax,
                                   Settings.VClampSim.h.TauVHalf,
                                   Settings.VClampSim.h.TauVSlope) ;
            TauMax := Max(Tau,TauMax) ;
            end ;
        RawFH.dt := TauMax*5.0 / RawFH.NumSamples ;

        end
     else begin
        GetRecordHeaderOnly( RawfH, RH, RawfH.NumRecords ) ;
        GroupNumber := Round(RH.Number) ;
        end ;

     IMax := Channel[ChIm].ADCScale*Main.SESLabIO.ADCMaxValue*nAToAmps ;

     { Set channel magnification }
     for ch := 0 to RawfH.NumChannels-1 do begin
         Channel[Ch].ADCZero := 0 ;
         Channel[Ch].xMin := 0 ;
         Channel[Ch].xMax := RawfH.NumSamples-1 ;
         Channel[Ch].yMin := Main.SESLabIO.ADCMinValue ;
         Channel[Ch].yMax := Main.SESLabIO.ADCMaxValue ;
         Channel[Ch].InUse := True ;
         end ;

     Channel[CHVm].ADCName := 'Vm' ;
     Channel[CHVm].ADCUnits := 'mV' ;
     Channel[CHIm].ADCName := 'Im' ;
     Channel[CHIm].ADCUnits := 'nA' ;

     // Set A/D sample range
     RawFH.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     RawFH.MinADCValue := Main.SESLabIO.ADCMinValue ;

     GroupNumber := 0 ;

     { Set voltage channel to fixed zero level }
     Channel[ChVm].ADCZeroAt := -1 ;
     CHannel[ChVm].ADCZero := 0 ;
     { Current channel zero level calculated frm samples 0..19}
     Channel[ChIm].ADCZeroAt := 0 ;
     SaveHeader( RawFH ) ;
     FirstRecord := False ;

     { Volts --> bits scale factor }
     VScale := Channel[ChVm].ADCScale / VoltsTomV ;
     { Amps --> bits scale factor }
     IScale := Channel[ChIm].ADCScale / AmpsTonA ;

     // Command voltage time constant 0.1 ms
     TauV := 1E-4/RawFH.dt ;

     NumRecordsDone := 0 ;
     Done := False ;
     while not Done do begin

        VTest := (NumRecordsDone+1)*Settings.VClampSim.VStep ;
        iStart := RawFH.NumSamples div 10 ;
        iEnd := RawFH.NumSamples - iStart ;
        Inc(GroupNumber) ;

        { ** Create leak subtraction pulse ** }

        if rbLeakSubtraction.checked then begin
           { ** P/N leak subtraction ** }
           NumPulses := Round(edLeakDivBy.Value)  ;
           If (NumPulses = 0) or (Abs(NumPulses)>200) then NumPulses := -4 ;
           VLeak := VTest / NumPulses ;

           {Create leak pulse record }
           VOld := Settings.VClampSim.VHold ;
           x := 0. ;
           Ic := 0. ;
           for i := 0 to RawFH.NumSamples-1 do begin

               if (i < iStart) then vp := Settings.VClampSim.VHold
               else if (i < iEnd) then vp := Settings.VClampSim.VHold + VLeak
               else vp := Settings.VClampSim.VHold ;

               {Voltage channel }
               j := i*RawFH.NumChannels + ChVm ;
               ADC^[j] := Round( Vp/VScale ) ;

               { Find membrane potential after voltage drop along
               pipette series resistance }
               Vm := Vp / ( 1. + Settings.VClampSim.GLeak/Settings.VClampSim.GSeries ) ;

               { Current channel }
               Im := (Vm * Settings.VClampSim.GLeak) + RandG(0.0,Settings.VClampSim.NoiseRMS) /
                            sqrt(Max(Abs(NumPulses),1)) ;

               { Add capacity current }
               if Vp <> VOld then begin
                  Ic := (Vp - Vold) * Settings.VClampSim.GSeries * 0.1 ;
                  x := 0. ;
                  end ;
               VOld := Vp ;
               Im := Im + Ic*exp( -x/TauC ) ;

               { Keep within display limits }
               Im := Max(Min(Im,IMax),-IMax) ;
               x := x + RawFH.dt ;

               j := i*RawFH.NumChannels + ChIm ;
               ADC^[j] := Round( Im/IScale ) ;
               end ;

           { Save leak record to file }
           Inc(RawFH.NumRecords) ;
           RH.Status := 'ACCEPTED' ;
           RH.RecType := 'LEAK' ;
           RH.Number := GroupNumber ;
           RH.Time := RH.Number ;
           RH.dt := RawfH.dt ;
           RH.EqnType := None ;
           RH.AnalysisAvailable := False ;
           RH.Ident := ' ' ;
           PutRecord( RawfH, RH, RawfH.NumRecords, ADC^ ) ;
           end ;

        { ** Create test pulse ** }

        x := 0. ;
        Gm := Settings.VClampSim.GLeak ;
        Vm := Settings.VClampSim.VHold / ( 1. + Gm/Settings.VClampSim.GSeries ) ;
        { Initial values of m and h parameters }
        m := Boltz( Vm,
                    Settings.VClampSim.m.VHalf,
                    Settings.VClampSim.m.VSlope ) ;
        h := Boltz( Vm,
                    Settings.VClampSim.h.VHalf,
                    Settings.VClampSim.h.VSlope ) ;
        Ic := 0. ;
        VOld := Settings.VClampSim.VHold ;

        for i := 0 to RawFH.NumSamples-1 do begin

            if i < iStart then vp := Settings.VClampSim.VHold
            else if i < iEnd then vp := Settings.VClampSim.VHold + VTest
            else vp := Settings.VClampSim.VHold ;

            {Voltage channel }
            j := i*RawFH.NumChannels + ChVm ;

            { Find membrane potential after voltage drop along
            pipette series resistance }

            Vm := Vp / ( 1. + Gm/Settings.VClampSim.GSeries ) ;
            ADC^[j] := Round( Vp/VScale ) ;
            { Current channel }
            { ACTIVATION KINETICS }
            {Calculate m.zero & m.infinity from Boltzmann function }
            Settings.VClampSim.m.Inf := Boltz( Vm,
                                               Settings.VClampSim.m.VHalf,
                                               Settings.VClampSim.m.VSlope ) ;
            { Calculate time constant }
            Settings.VClampSim.m.Tau := TauFunction( Vm,
                                                     Settings.VClampSim.m.TauMin,
                                                     Settings.VClampSim.m.TauMax,
                                                     Settings.VClampSim.m.TauVhalf,
                                                     Settings.VClampSim.m.TauVslope) ;
            { Calculate value of activation parameter }
            m := Settings.VClampSim.m.Inf - (Settings.VClampSim.m.Inf - m)*
                 exp( -RawFH.dt/Settings.VClampSim.m.Tau ) ;
            { Calculate conductance }
            Gm := Settings.VClampSim.GMax*Power(m,Settings.VClampSim.m.p) ;

            { INACTIVATION KINETICS }
            if Settings.VClampSim.UseInactivation then begin
               Settings.VClampSim.h.Inf := Boltz( Vm,
                                                  Settings.VClampSim.h.VHalf,
                                                  Settings.VClampSim.h.Vslope ) ;
               Settings.VClampSim.h.Tau := TauFunction( Vm,
                                  Settings.VClampSim.h.TauMin,
                                  Settings.VClampSim.h.TauMax,
                                  Settings.VClampSim.h.TauVhalf,
                                  Settings.VClampSim.h.TauVslope) ;
               h := Settings.VClampSim.h.Inf -
                          (Settings.VClampSim.h.Inf -
                          h)*
                          exp( -RawFH.dt/Settings.VClampSim.h.Tau ) ;
               Gm := Gm*h ;
               end ;

            { Add leak conductance }
            Gm := Gm + Settings.VClampSim.GLeak ;
            { Calculate current }
            Im := (Vm - Settings.VClampSim.VRev)*Gm +
                  RandG(0.0,Settings.VClampSim.NoiseRMS) ;

            { Add capacity current }
            if Vp <> VOld then begin
               Ic := (Vp - Vold) * Settings.VClampSim.GSeries * 0.1 ;
               x := 0. ;
               end ;
            VOld := Vp ;

            Im := Im + Ic*exp( -x/TauC ) ;
            {Keep within display limits }
            Im := Max(Min(Im,IMax),-IMax) ;
            x := x + RawFH.dt ;

            j := i*RawFH.NumChannels + ChIm ;
            ADC^[j] :=  Round( Im/IScale ) ;
            end ;

        { Force a display of new sweep }
        scDisplay.TScale := RawFH.dt*Settings.TScale ;
        scDisplay.SetDataBuf( ADC ) ;

        { Save Record to file }
        Inc(RawFH.NumRecords) ;
        RH.Status := 'ACCEPTED' ;
        RH.RecType := 'TEST' ;
        RH.Number := GroupNumber ;
        RH.Time := RH.Number ;
        RH.dt := RawfH.dt ;
        RH.EqnType := None ;
        RH.Ident := ' ' ;

        PutRecord( RawfH, RH, RawfH.NumRecords, ADC^ ) ;

        Inc(NumRecordsDone) ;
        { Terminate when all records done }
        Main.StatusBar.SimpleText := format(
        'Voltage-activated Currents Simulation : Record %d/%d created.',
        [NumRecordsDone,Settings.VClampSim.NumSteps] ) ;

        if (NumRecordsDone >= Settings.VClampSim.NumSteps) or bStart.Enabled then Done := True ;

        { Allow other activities during loop }
        scDisplay.Invalidate ;
        Application.ProcessMessages ;

        end ;

     { Save file header data }
     SaveHeader(RawFH) ;

     Main.StatusBar.SimpleText := format(
     ' Voltage-activated Currents Simulation : %d records created.',
     [NumRecordsDone] ) ;


     bStart.Enabled := True ;
     bAbort.Enabled := False ;

     end ;

procedure TVClampSim.UpdateDisplayScale ;
// ----------------------
// Update display scaling
// ----------------------
var
    IMax : Single ;
    GMax : Single ;
    GLeak : Single ;
    VRev : Single ;
begin

     GMax := edGMax.Value ;
     VRev := edVRev.Value ;
     GLeak := edGLeak.Value ;

     IMax := Max((0.05*VMax*edGSeries.Value),GMax*(VMax-VRev) + GLeak*VMax) ;
     if IMax = 0. then IMax := 1E-9 ;

     scDisplay.ChanScale[ChIm] := AmpsTonA*IMax / (Main.SESLabIO.ADCMaxValue+1) ;
     scDisplay.ChanScale[ChVm] := (VMax*VoltsTomV) / (Main.SESLabIO.ADCMaxValue+1) ;

     scDisplay.TScale := RawFH.dt*Settings.TScale ;
     scDisplay.TUnits := Settings.TUnits ;

     scDisplay.Invalidate ;

     end ;


procedure TVClampSim.bAbortClick(Sender: TObject);
{ --------------------
  Abort simulation run
  -------------------- }
begin
     bStart.Enabled := True ;
     bAbort.Enabled := False ;
     end;

function TVClampSim.TauFunction(
          V : Single ;
          TauMin : Single ;
          TauMax : Single ;
          TauVhalf : Single ;
          TauVslope : single ) : Single ;
// --------------------------------------------------
// Gating parameter time constant vs voltage function
// --------------------------------------------------
var
    X : single ;
begin
    X := (V - TauVHalf)/TauVSlope ;
    Result := TauMin + (TauMax-TauMin)*exp(-X*X) ;
    end ;

function TVClampSim.Boltz( V, VHalf, VSlope : Single ) : Single ;
begin
     Boltz := 1. / ( 1. + Exp( (V - VHalf)/VSlope ) ) ;
     end ;


procedure TVClampSim.FormClose(Sender: TObject; var Action: TCloseAction);
{ ----------------------
  Close and destroy form
  ---------------------- }
begin

     // Copy settings from edit fields to Settings.VClampSim
     EditFieldsToSettings ;

     if RawFH.NumRecords > 0 then begin
        Main.mnShowRaw.Enabled := True ;
        Main.mnShowRaw.Click ;
        Main.mnZoomOutAll.Click ;
        end ;

     Action := caFree ;
     end;


procedure TVClampSim.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
     if not bStart.Enabled then CanClose := False
                           else CanClose := True ;
     end;

procedure TVClampSim.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin
    ADC := Nil ;
    end;

procedure TVClampSim.FormDestroy(Sender: TObject);
// ------------------------------
// Tidy up when form is destroyed
// ------------------------------
begin
    if ADC <> Nil then FreeMem(ADC) ;
    end;

procedure TVClampSim.FormResize(Sender: TObject);
{ ------------------------------------------------------
  Adjust size/position of controls when form is re-sized
  ------------------------------------------------------ }
begin
      EquationGrp.Top := ClientHeight - EquationGrp.Height - 5 ;
      EquationGrp.Width := Max( ClientWidth - EquationGrp.Left - 5, 2 ) ;
      scDisplay.Height := Max( EquationGrp.Top - scDisplay.Top - 5, 2 ) ;
      scDisplay.Width := Max( ClientWidth - scDisplay.Left - 5, 2 ) ;
      end;


procedure TVClampSim.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;

     scDisplay.Invalidate ;
     end ;


procedure  TVClampSim.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;
     scDisplay.ZoomOut ;
     end ;

procedure TVClampSim.scDisplayCursorChange(Sender: TObject);
var
   ch : Integer ;
begin
     { Update channel descriptors with any changes to display }
     for ch := 0 to scDisplay.NumChannels-1 do if Channel[ch].InUse then begin
         Channel[Ch].yMin := scDisplay.YMin[Ch] ;
         Channel[Ch].yMax := scDisplay.YMax[Ch] ;
         end ;
     end;


procedure TVClampSim.edVRevKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then UpdateDisplayScale ;
     end;

procedure TVClampSim.edGMaxKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then UpdateDisplayScale ;
     end;

procedure TVClampSim.edGLeakKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then UpdateDisplayScale ;
     end;

procedure TVClampSim.edTauMKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then UpdateDisplayScale ;
     end;

procedure TVClampSim.edTauHKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then UpdateDisplayScale ;
     end;

procedure TVClampSim.edNumSamplesKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then EditFieldsToSettings ;
    end;


function TVClampSim.CheckNewDataFileNeeded : Boolean ;
// ------------------------------------------------------------
// Check record size and created a new file if size has changed
// ------------------------------------------------------------
var
    NewFileName,Stem : String ;
    n : Integer ;
begin

     NewFileName := '' ;

     // Create a new file if none open
     if RawFH.FileHandle <= 0 then begin
        // No file open .. open new one
        NewFileName := Main.CreateIndexedFileName( RawFH.FileName ) ;
        end
     else if (RawFH.NumRecords > 0) and
        ((RawFH.NumChannels <> 2) or (RawFH.NumSamples <> Round(edNumSamples.Value))) then begin
        // No. channels or samples changed .. create .nn.wcp file
        // Extract stem of file name
        Stem := ANSIReplaceText( RawFH.FileName, '.wcp', '.' ) ;
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
        RawFH.NumChannels := 2 ;
        RawFH.NumSamples := Round(edNumSamples.Value) ;
        Main.CreateNewDataFile( NewFileName ) ;
        Result := True ;
        end
     else Result := True ;

     end ;



end.
