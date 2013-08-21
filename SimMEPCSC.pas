unit SimMEPCSC;
{ ============================================================
  WinWCP - SimmEPSC.pas
           Miniature excitatory postsynaptic current simulation
           (c) J. Dempster, University of Strathclyde 1999
  ============================================================
  12/9/99 }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,
  global, shared, maths, fileio, ValEdit, ScopeDisplay, math, ComCtrls,
  ValidatedEdit ;

type
  TSimMEPSCFrm = class(TForm)
    GroupBox1: TGroupBox;
    bStart: TButton;
    bAbort: TButton;
    IonCurrentGrp: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RecCondGrp: TGroupBox;
    Label9: TLabel;
    Label6: TLabel;
    scDisplay: TScopeDisplay;
    edUnitCurrent: TValidatedEdit;
    edNumChannelsAvg: TValidatedEdit;
    edNumChannelsStDev: TValidatedEdit;
    edTauOPen: TValidatedEdit;
    edNoiseRMS: TValidatedEdit;
    edLPFilter: TValidatedEdit;
    ProgressGrp: TGroupBox;
    prProgress: TProgressBar;
    edNumRecords: TValidatedEdit;
    procedure bStartClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bAbortClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure edSteadyStateTimeKeyPress(Sender: TObject; var Key: Char);
    procedure edTauOPenKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure HeapBuffers( Operation : THeapBufferOp ) ;
  public
    { Public declarations }
     procedure ChangeDisplayGrid ;
     procedure ZoomOut ;
  end;

var
  SimMEPSCFrm: TSimMEPSCFrm;

implementation

{$R *.DFM}

uses mdiform ;

const
     ChSim = 0 ;
     MaxChannels = 100 ;
type
    TSim = record
         NumRecords : Integer ;
         NumRecordsDone : Integer ;
         UnitCurrent : single ;
         NumChannels : Integer ;
         TauOpen : single ;
         NoiseRMS : Single ;
         LPFilter : single ;
         LPFilterFirstCall : Boolean ;
         t : double ;
         end ;
var
   ADC : ^TSmallIntArray ; { Digitised signal buffer }
   Sim : TSim ;
   BuffersAllocated : boolean ;{ Indicates if memory buffers have been allocated }


procedure TSimMEPSCFrm.HeapBuffers( Operation : THeapBufferOp ) ;
{ -----------------------------------------------
  Allocate/deallocation dynamic buffers from heap
  -----------------------------------------------}
begin
     case Operation of
          Allocate : begin
             if not BuffersAllocated then begin
                New(ADC) ;
                BuffersAllocated := True ;
                end ;
             end ;
          Deallocate : begin
             if BuffersAllocated then begin
                Dispose(ADC) ;
                BuffersAllocated := False ;
                end ;
             end ;
          end ;
     end ;


procedure TSimMEPSCFrm.FormShow(Sender: TObject);
{ --------------------------------------
  Initialisations when form is displayed
  --------------------------------------}
var
   ch,i : Integer ;
begin

     { Disable menu option to prevent user starting another instance }
     Main.mnSimNoise.Enabled := False ;

     { Create buffers }
     HeapBuffers( Allocate ) ;

     bStart.Enabled := True ;
     bAbort.Enabled := False ;

     Channel[ChSim].ADCUnits := 'pA' ;
     Channel[ChSim].ADCName := 'Im' ;
     Channel[ChSim].ADCZero := 0 ;
     Channel[ChSim].InUse := True ;

     { Set up Display }
     scDisplay.MaxADCValue := MaxADCValue ;
     scDisplay.MinADCValue := MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;
     scDisplay.MaxPoints := RawFH.NumSamples ;
     scDisplay.NumPoints := RawFH.NumSamples ;
     scDisplay.NumChannels := RawFH.NumChannels ;
     { Set channel information }
     for ch := 0 to RawFH.NumChannels-1 do begin
         scDisplay.ChanUnits[ch] := Channel[Ch].ADCUnits ;
         scDisplay.ChanName[ch] := Channel[Ch].ADCName ;
         scDisplay.yMin[ch] := Channel[Ch].yMin ;
         scDisplay.yMax[ch] := Channel[Ch].yMax ;
         if ch = ChSim then scDisplay.ChanVisible[ch] := True
                       else scDisplay.ChanVisible[ch] := False ;
         end ;

     scDisplay.xMin := 0 ;
     scDisplay.xMax := RawFH.NumSamples - 1  ;
     scDisplay.HorizontalCursors[0] := Channel[ChSim].ADCZero ;

     scDisplay.TScale := RawFH.dt ;
     scDisplay.TFormat := ' %.2f s ' ;

     { Clear all channels }
     for i := 0 to RawFH.NumChannels*RawFH.NumSamples-1 do ADC^[i] := 0 ;

     scDisplay.SetDataBuf( ADC^ ) ;

     scDisplay.AddHorizontalCursor(0,Settings.Colors.Cursors) ;

     end ;


procedure TSimMEPSCFrm.bStartClick(Sender: TObject);
{ -------------------------
  Create simulated currents
  -------------------------}
var
   iZeroLevel,i,j,iCh,iStart : Integer ;
   Done : Boolean ;
begin

     { Set buttons to be active during simulation run }
     bStart.Enabled := False ;
     bAbort.Enabled := True ;

     { Get parameters from edit boxes }
     Sim.NumRecords := Round(edNumRecords.Value) ;
     Sim.UnitCurrent := edUnitCurrent.Value ;
     Sim.NumChannelsAvg := edNumChannelsAvg.Value ;
     Sim.NumChannelsStDev := edNumChannelsStDev.Value ;
     Sim.TauOpen := edTauOpen.Value ;
     Sim.NoiseRMS := edNoiseRMS.Value ;
     Sim.LPFilter := edLPFilter.Value ;

     { Set scaling factor if this is an empty file }
     if RawFH.NumSamplesInFile = 0 then begin
        Channel[ChSim].ADCCalibrationFactor := 1. ;
        Channel[ChSim].ADCScale := Abs(Sim.UnitCurrent*Sim.NumChannels*1.25) / MaxADCValue ;
        RawFH.ADCVoltageRange :=  Channel[ChSim].ADCCalibrationFactor
                                  * ( Channel[ChSim].ADCScale * (MaxADCValue+1) ) ;

        if Sim.UnitCurrent > 0.0 then Channel[ChSim].ADCZero := -1024
                                 else Channel[ChSim].ADCZero := 1024 ;
        end ;

     Channel[ChSim].ChannelOffset := 0 ;

     { *** mEPSC simulation loop *** }

     Done := False ;
     iZeroLevel := Channel[ChSim].ADCZero ;
     prProgress.Position := 0 ;
     prProgress.Min := 0 ;
     prProgress.Max := Sim.NumRecords + 1;
     while (not Done) do begin

        { Number of ion channels in mEPSC }
        Sum.NumChannels := Round( RandG( edNumChannelsAvg.Value,
                                         edNumChannelsStDev.Value )) ;

        { Compute dwell time for each channel }
        for Chan := 0 to Sim.NumChannels-1 do
            DwellTime[Chan] := -Sim.TauOpen*ln(random) ;

        { Generate current record }
        j := Channel[ChSim].ChannelOffset ;
        Sim.t := 0.0 ;
        iStart := RawFH.NumSamples div 5 ;
        for i := 0 to RawFH.NumSamples-1 do begin

            { Background noise }
            ADC^[j] := Round( RandG(0.0,Sim.NoiseRMS)
                               /Channel[ChSim].ADCScale ) + iZeroLevel ;

            { Miniature postsynaptic current }
            if i >= iStart then begin
               Current := 0.0 ;
               for Chan := 0 to Sim.NumChannels-1 do if t <= DwellTime[Chan] then
                   Current := Current + Sim.UnitCurrent ;
               ADC^[j] := ADC^[j] + Round(Current/Channel[ChSim].ADCScale) ;
               Sim.t := Sim.t + RawFH.dt ;
               end ;
            j := j + RawFH.NumChannels ;
            end ;

        { Save Record to file }
         Inc(RawFH.NumRecords) ;
         RH.Status := 'ACCEPTED' ;
         RH.RecType := 'TEST' ;
         RH.Number := RawfH.NumRecords ;
         RH.Time := RH.Number ;
         RH.dt := RawfH.dt ;
         RH.Equation.Available := False ;
         RH.Analysis.Available := False ;
         RH.Ident := ' ' ;
         PutRecord( RawfH, RH, RawfH.NumRecords, ADC^ ) ;

         scDisplay.Invalidate ;

         Inc(Sim.NumRecordsDone) ;
         if (Sim.NumRecordsDone > Sim.NumRecords) or bStart.Enabled then Done := True ;

         prProgress.Position := prProgress.Position + 1 ;
         Application.ProcessMessages ;

         end ;

     { Close form if simulation has not been aborted }
     bStart.Enabled := True ;
     bAbort.Enabled := False ;

     end;


procedure TSimMEPSCFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
{ ------------------------
  Tidy up when form closed
  ------------------------}
begin

     HeapBuffers( Deallocate ) ;
     { Re-enable item in "Simulation" menu }
     Main.mnSimNoise.enabled := true ;
     SaveHeader( RawFH ) ;

     Main.UpdateMDIWindows ;
     Action := caFree ;

     end;


procedure TSimMEPSCFrm.bAbortClick(Sender: TObject);
{ ------------------------------------
  ABORT button - Aborts simulation run
  ------------------------------------}
begin
     bStart.Enabled := True ;
     bAbort.Enabled := False ;
     end;





procedure TSimMEPSCFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
     { Prevent form being closed if a simulation is running (Start button disabled) }
     if bStart.Enabled then CanClose := True
                       else CanClose := False ;
     end;

procedure TSimMEPSCFrm.FormResize(Sender: TObject);
{ ------------------------------------------------------
  Adjust size/position of controls when form is re-sized
  ------------------------------------------------------ }
begin
      IonCurrentGrp.Top := ClientHeight - IonCurrentGrp.Height - 5 ;
      RecCondGrp.Top := ClientHeight - RecCondGrp.Height - 5 ;
      RecCondGrp.Width := ClientWidth - RecCondGrp.Left - 5 ;
      scDisplay.Height := RecCondGrp.Top - scDisplay.Top - 10 ;
      scDisplay.Width := ClientWidth - scDisplay.Left - 5 ;
      end;



procedure TSimMEPSCFrm.scDisplayCursorChange(Sender: TObject);
begin
     Channel[ChSim].yMin := scDisplay.YMin[ChSim] ;
     Channel[ChSim].yMax := scDisplay.YMax[ChSim] ;
     end;


procedure TSimMEPSCFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
     scDisplay.MaxADCValue := MaxADCValue ;
     scDisplay.MinADCValue := MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;
     scDisplay.Invalidate ;
     end ;


procedure  TSimMEPSCFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := MaxADCValue ;
     scDisplay.MinADCValue := MinADCValue ;
     scDisplay.ZoomOut ;
     end ;



initialization
     BuffersAllocated := False ;

end.
