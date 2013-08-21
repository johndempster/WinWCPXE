unit Simnoise;
{ ============================================================
  WinCDR - SimNoise.pas -Ion channel noise simulation
  (c) J. Dempster, University of Strathclyde 1998
  ============================================================
  29/6/98 Close button disabled during simulation run to avoid
          GPF due to closing form while Start button method running
  30/1/99 ... Now uses TScopeDisplay and TValidatedEdit custom controls
  25/8/99 ... Revised
  }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,
  global, shared, maths, fileio, ValEdit, ScopeDisplay, math, ComCtrls ;

type
  TSimNoiseFrm = class(TForm)
    GroupBox1: TGroupBox;
    bStart: TButton;
    bAbort: TButton;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    Label11: TLabel;
    IonCurrentGrp: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RecCondGrp: TGroupBox;
    Label9: TLabel;
    Label6: TLabel;
    scDisplay: TScopeDisplay;
    edBackGroundTime: TValidatedEdit;
    edTransientTime: TValidatedEdit;
    edSteadyStateTime: TValidatedEdit;
    edUnitCurrent: TValidatedEdit;
    edNumChannels: TValidatedEdit;
    edPOpen: TValidatedEdit;
    edTauOPen: TValidatedEdit;
    edNoiseRMS: TValidatedEdit;
    edLPFilter: TValidatedEdit;
    ProgressGrp: TGroupBox;
    prProgress: TProgressBar;
    procedure bStartClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bAbortClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure scDisplayCursorChange(Sender: TObject);
  private
    { Private declarations }
    procedure HeapBuffers( Operation : THeapBufferOp ) ;
  public
    { Public declarations }
     procedure ChangeDisplayGrid ;
     procedure ZoomOut ;
  end;

var
  SimNoiseFrm: TSimNoiseFrm;

implementation

{$R *.DFM}

uses mdiform ;

const
     NumSamplesPerBuffer = 512 ;
     ChSim = 0 ;
     MaxChannels = 100 ;
type
    TChannelState = (Open,Closed) ;
    TChannelRecord = record
                  Time : Single ;
                  State : TChannelState ;
                  end ;
    TSim = record
         BackgroundTime : single ;
         TransientTime : single ;
         SteadyStateTime : single ;
         UnitCurrent : single ;
         NumChannels : Integer ;
         POpen : single ;
         TauOpen : single ;
         TauClosed : single ;
         NoiseRMS : Single ;
         LPFilter : single ;
         LPFilterFirstCall : Boolean ;
         t : double ;
         EndTime : double ;
         Channel : Array[0..MaxChannels-1] of TChannelRecord ;
         end ;
var
   ADC : ^TSmallIntArray ; { Digitised signal buffer }
   Sim : TSim ;
   BuffersAllocated : boolean ;{ Indicates if memory buffers have been allocated }


procedure TSimNoiseFrm.HeapBuffers( Operation : THeapBufferOp ) ;
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


procedure TSimNoiseFrm.FormShow(Sender: TObject);
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
     scDisplay.MaxPoints := NumSamplesPerBuffer ;
     scDisplay.NumPoints := NumSamplesPerBuffer ;
     scDisplay.NumChannels := CdrFH.NumChannels ;
     { Set channel information }
     for ch := 0 to CdrFH.NumChannels-1 do begin
         scDisplay.ChanUnits[ch] := Channel[Ch].ADCUnits ;
         scDisplay.ChanName[ch] := Channel[Ch].ADCName ;
         scDisplay.yMin[ch] := Channel[Ch].yMin ;
         scDisplay.yMax[ch] := Channel[Ch].yMax ;
         if ch = ChSim then scDisplay.ChanVisible[ch] := True
                       else scDisplay.ChanVisible[ch] := False ;
         end ;

     scDisplay.xMin := 0 ;
     scDisplay.xMax := NumSamplesPerBuffer-1  ;
     scDisplay.HorizontalCursors[0] := Channel[ChSim].ADCZero ;

     scDisplay.TScale := CdrFH.dt ;
     scDisplay.TFormat := ' %.2f s ' ;

     { Clear all channels }
     for i := 0 to CdrFH.NumChannels*NumSamplesPerBuffer-1 do ADC^[i] := 0 ;

     scDisplay.SetDataBuf( ADC^ ) ;

     scDisplay.AddHorizontalCursor(0,clGray) ;

     end ;


procedure TSimNoiseFrm.bStartClick(Sender: TObject);
{ -------------------------
  Create simulated currents
  -------------------------}
var
   TBuffer : single ;
   Alpha, Beta, p : single ;
   NumOpenChannels,iZeroLevel,i,j,iCh : Integer ;
   NumBytesToWrite : LongInt ;
   Done,FirstTime : Boolean ;
begin

     { Set buttons to be active during simulation run }
     bStart.Enabled := False ;
     bAbort.Enabled := True ;

     { Get parameters from edit boxes }
     Sim.BackgroundTime := edBackgroundTime.Value ;
     Sim.TransientTime := edTransientTime.Value ;
     Sim.SteadyStateTime := edSteadyStateTime.Value ;
     Sim.UnitCurrent := edUnitCurrent.Value ;
     Sim.NumChannels := Round(edNumChannels.Value) ;
     Sim.POpen := edPOpen.Value ;
     Sim.TauOpen := edTauOpen.Value ;
     Sim.NoiseRMS := edNoiseRMS.Value ;
     Sim.LPFilter := edLPFilter.Value ;

     { Total simulation time }
     Sim.EndTime := Sim.BackgroundTime + Sim.TransientTime + Sim.SteadyStateTime ;

     { Set scaling factor if this is an empty file }
     if CdrFH.NumSamplesInFile = 0 then begin
        cdrFH.NumChannels := 1 ;
        Channel[ChSim].ADCCalibrationFactor := 1. ;
        Channel[ChSim].ADCScale := Abs(Sim.UnitCurrent*Sim.NumChannels*1.25) / MaxADCValue ;
        CdrFH.ADCVoltageRange :=  Channel[ChSim].ADCCalibrationFactor
                                  * ( Channel[ChSim].ADCScale * (MaxADCValue+1) ) ;

        if Sim.UnitCurrent > 0.0 then Channel[ChSim].ADCZero := -1024
                                 else Channel[ChSim].ADCZero := 1024 ;
        end ;

     Channel[ChSim].ChannelOffset := 0 ;

     { Position data file pointer at end of data in file }
     CdrFH.FilePointer := (CdrFH.NumSamplesInFile*2*CdrFH.NumChannels)
                          + CdrFH.NumBytesInHeader ;
     CdrFH.FilePointer := FileSeek(CdrFH.FileHandle,0,2) ;

     { *** Ion channel simulation loop *** }

     Done := False ;
     FirstTime := True ;
     TBuffer := NumSamplesPerBuffer*CdrFH.dt ;
     iZeroLevel := Channel[ChSim].ADCZero ;
     prProgress.Position := 0 ;
     prProgress.Min := 0 ;
     prProgress.Max := Round(Sim.EndTime/TBuffer);
     Sim.t := 0.0 ;
     while (not Done) do begin

         { Background noise }
         j := Channel[ChSim].ChannelOffset ;
         for i := 0 to NumSamplesPerBuffer do begin
             ADC^[j] := Round( RandG(0.0,Sim.NoiseRMS)
                               /Channel[ChSim].ADCScale ) + iZeroLevel ;
             j := j + CdrFH.NumChannels ;
             end ;

         { Ion channel noise }
         if Sim.t >= Sim.BackgroundTime then begin

            { Open channel probability for this time point }
            p := (1.0 - exp( -(Sim.t - Sim.BackgroundTime)/(Sim.TransientTime*0.25)))
                 * Sim.POPen ;

            { Calculate channel mean open and closed dwell times }
            Alpha := 1.0 / Sim.TauOpen ;
            if p > 0.0 then begin
               Beta :=(Alpha*p)/(1.0 - p) ;
               Sim.TauClosed := 1.0 / Beta ;
               end
            else Sim.TauClosed := 1E10 ;

            if FirstTime then begin
                 { Set all channels to closed }
                 for iCh := 0 to Sim.NumChannels-1 do begin
                     Sim.Channel[iCh].State := Closed ;
                     Sim.Channel[iCh].Time := 0.0 ;
                     Sim.Channel[iCh].Time := -Sim.TauClosed*ln(Random) ;
                     end ;
                 FirstTime := False ;
                 end ;

            { Calculate ionic current for each sample point in buffer }
            j := Channel[ChSim].ChannelOffset ;
            for i := 0 to NumSamplesPerBuffer do begin
                NumOPenChannels := 0 ;
                for iCh := 0 to Sim.NumChannels-1 do begin
                    { If at end dwell time in current channel state,
                      flip to other state and obtain a new dwell time }
                    if Sim.Channel[iCh].Time <= 0.0 then begin
                       if Sim.Channel[iCh].State = Open then begin
                          { Change to closed state }
                          Sim.Channel[iCh].Time := -Sim.TauClosed*ln(Random) ;
                          Sim.Channel[iCh].State := Closed ;
                          end
                       else begin
                          { Change to open state }
                          Sim.Channel[iCh].Time := -Sim.TauOpen*ln(Random) ;
                          Sim.Channel[iCh].State := Open ;
                          end ;
                       end
                    else begin
                         { Decrement time in this state }
                         Sim.Channel[iCh].Time := Sim.Channel[iCh].Time - CdrFH.dt ;
                         end ;
                    { If channel is open add it to open count }
                    if Sim.Channel[iCh].State = Open then Inc(NumOpenChannels) ;
                    end ;
                ADC^[j] := ADC^[j] + Round( (NumOpenChannels*Sim.UnitCurrent) /
                                             Channel[ChSim].ADCScale ) ;
                j := j + CdrFH.NumChannels ;
                end ;
            end ;


         { Save data to file }
         NumBytesToWrite := NumSamplesPerBuffer*CdrFH.NumChannels*2 ;
         if FileWrite(CdrFH.FileHandle,ADC^,NumBytesToWrite)
            <> NumBytesToWrite then
            MessageDlg( ' File write file failed',mtWarning, [mbOK], 0 ) ;

         CdrFH.NumSamplesInFile := CdrFH.NumSamplesInFile
                                   + NumSamplesPerBuffer*CdrFH.NumChannels ;

         scDisplay.xOffset := Round( Sim.t /CdrFH.dt ) ;
         scDisplay.Invalidate ;

         Sim.t := Sim.t + TBuffer ;
         if Sim.t > Sim.EndTime then Done := True ;
         if bStart.Enabled = True then Done := True ;

         prProgress.Position := prProgress.Position + 1 ;
         Application.ProcessMessages ;

         end ;

     { Close form if simulation has not been aborted }
     bStart.Enabled := True ;
     bAbort.Enabled := False ;

     end;


procedure TSimNoiseFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
{ ------------------------
  Tidy up when form closed
  ------------------------}
begin

     HeapBuffers( Deallocate ) ;
     { Re-enable item in "Simulation" menu }
     Main.mnSimNoise.enabled := true ;
     SaveCDRHeader( CdrFH ) ;

     Main.UpdateMDIWindows ;
     Action := caFree ;

     end;


procedure TSimNoiseFrm.bAbortClick(Sender: TObject);
{ ------------------------------------
  ABORT button - Aborts simulation run
  ------------------------------------}
begin
     bStart.Enabled := True ;
     bAbort.Enabled := False ;
     end;





procedure TSimNoiseFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
     { Prevent form being closed if a simulation is running (Start button disabled) }
     if bStart.Enabled then CanClose := True
                       else CanClose := False ;
     end;

procedure TSimNoiseFrm.FormResize(Sender: TObject);
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



procedure TSimNoiseFrm.scDisplayCursorChange(Sender: TObject);
begin
     Channel[ChSim].yMin := scDisplay.YMin[ChSim] ;
     Channel[ChSim].yMax := scDisplay.YMax[ChSim] ;
     end;


procedure TSimNoiseFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
    scDisplay.MaxADCValue := MaxADCValue ;
     scDisplay.MinADCValue := MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;
     scDisplay.Invalidate ;
     end ;


procedure  TSimNoiseFrm.ZoomOut ;
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
