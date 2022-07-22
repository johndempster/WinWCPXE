unit SimMEPSC;
{ ============================================================
  WinWCP - SimmEPSC.pas
           Miniature excitatory postsynaptic current simulation
           (c) J. Dempster, University of Strathclyde 1999
  ============================================================
  12/9/99
  30/10/99 ... NewFile method added
  3/12/00 ... Double exponential decay, LP filter and drifting added
  9/1/01 .... MEPC now simulated using multi-state channel model
              A + R <-> AR <-> AR* + B <-> ARB
  20/5/01 ... Binding rate can now be set, ion channel model graphic added
  24.6.03 ... No. of display grid lines can be changed
  01.01.04 .. Out of memory error blocked when windows resized to tiny size
  24.04.06 .. Record duration now set within dialog box
  21.06.10 .. Parameters now stored in Settings.MEPSCSim and winwcp.INI file
  16.11.11 .. No. Samples box added to control panel
  09.08.13 .. ADC now allocated by AllocMem()
  03.03.17 .. .Close form event now terminates bStart.Click event before
              closing form to prevent access violation
  }


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,
  maths, ValEdit, ScopeDisplay, math, ComCtrls,
  ValidatedEdit, seslabio, strutils ;

type
  TSimMEPSCFrm = class(TForm)
    GroupBox1: TGroupBox;
    bStart: TButton;
    bAbort: TButton;
    IonCurrentGrp: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    edUnitCurrent: TValidatedEdit;
    edNumChannelsAvg: TValidatedEdit;
    edNumChannelsStDev: TValidatedEdit;
    edNumRecords: TValidatedEdit;
    ModelGrp: TGroupBox;
    edOpenRate: TValidatedEdit;
    edCloseRate: TValidatedEdit;
    edUnbindRate: TValidatedEdit;
    edBlockRate: TValidatedEdit;
    edUnblockRate: TValidatedEdit;
    Image1: TImage;
    RecCondGrp: TGroupBox;
    Label9: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    edNoiseRMS: TValidatedEdit;
    edLPFilter: TValidatedEdit;
    edDrift: TValidatedEdit;
    rbLPFilterOn: TRadioButton;
    rbLPFilterOff: TRadioButton;
    edBindRate: TValidatedEdit;
    Shape1: TShape;
    edTransmitterDecayTime: TValidatedEdit;
    Label3: TLabel;
    Label5: TLabel;
    edRecordDuration: TValidatedEdit;
    scDisplay: TScopeDisplay;
    Label12: TLabel;
    edNumSamples: TValidatedEdit;
    procedure bStartClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bAbortClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure edNumSamplesKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    ADC : PSmallIntArray ; { Digitised signal buffer }
    CloseFormASAP : Boolean ;
    procedure EditFieldsToSettings ;
    function CheckNewDataFileNeeded : Boolean ;

  public
    { Public declarations }
     procedure ChangeDisplayGrid ;
     procedure ZoomOut ;
     procedure NewFile ;
  end;

var
  SimMEPSCFrm: TSimMEPSCFrm;

implementation

{$R *.DFM}

uses mdiform , WCPFIleUnit;

const
     ChSim = 0 ;

procedure TSimMEPSCFrm.FormShow(Sender: TObject);
{ --------------------------------------
  Initialisations when form is displayed
  --------------------------------------}
begin

     bStart.Enabled := True ;
     bAbort.Enabled := False ;
     CloseFormASAP := False ;

     edNumSamples.Value := WCPFile.Settings.NumSamples ;
     edNumRecords.Value := WCPFile.Settings.MEPSCSim.NumRecords ;
     edRecordDuration.Value := WCPFile.Settings.MEPSCSim.RecordDuration ;
     edUnitCurrent.Value := WCPFile.Settings.MEPSCSim.UnitCurrent ;
     edTransmitterDecayTime.Value := WCPFile.Settings.MEPSCSim.TransmitterDecayTime ;
     edBindRate.Value := WCPFile.Settings.MEPSCSim.BindingRate ;
     edOpenRate.Value := WCPFile.Settings.MEPSCSim.OpenRate ;
     edCloseRate.Value := WCPFile.Settings.MEPSCSim.CloseRate ;
     edUnbindRate.Value := WCPFile.Settings.MEPSCSim.UnbindRate ;
     edBlockRate.Value := WCPFile.Settings.MEPSCSim.BlockRate ;
     edNoiseRMS.Value := WCPFile.Settings.MEPSCSim.NoiseRMS ;
     edLPFilter.Value := WCPFile.Settings.MEPSCSim.LPFilter ;
     rbLPFilterOn.Checked := WCPFile.Settings.MEPSCSim.LPFilterInUse ;
     edDrift.Value := WCPFile.Settings.MEPSCSim.Drift ;

     NewFile ;

     Resize ;
     end ;


procedure TSimMEPSCFrm.NewFile ;
{ ---------------------------------------------------------
  Update controls/display to account for change of data file
  ---------------------------------------------------------}
var
   ch,i : Integer ;
   dt : Single ;
begin

     WCPFile.Channel[ChSim].InUse := True ;
     if WCPFile.RawFH.NumRecords = 0 then
        begin
        WCPFile.Channel[ChSim].ADCUnits := 'pA' ;
        WCPFile.Channel[ChSim].ADCName := 'Im' ;
        WCPFile.Channel[ChSim].ADCZero := 0 ;
        WCPFile.Channel[ChSim].ChannelOffset := 0 ;
        WCPFile.RawFH.NumChannels := 1 ;
        end ;

     { Set up Display }
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;

     scDisplay.MaxPoints := WCPFile.Settings.NumSamples ;
     scDisplay.NumPoints := WCPFile.Settings.NumSamples ;
     scDisplay.NumChannels := 1 ;
     { Set channel information }
     for ch := 0 to scDisplay.NumChannels-1 do
         begin
         scDisplay.ChanOffsets[ch] := WCPFile.Channel[ch].ChannelOffset ;
         scDisplay.ChanUnits[ch] := WCPFile.Channel[Ch].ADCUnits ;
         scDisplay.ChanName[ch] := WCPFile.Channel[Ch].ADCName ;
         scDisplay.ChanScale[ch] := WCPFile.Channel[ch].ADCScale ;
         WCPFile.Channel[Ch].yMin := scDisplay.MinADCValue ;
         WCPFile.Channel[Ch].yMax := scDisplay.MaxADCValue ;
         scDisplay.yMin[ch] := WCPFile.Channel[Ch].yMin ;
         scDisplay.yMax[ch] := WCPFile.Channel[Ch].yMax ;
         if ch = ChSim then scDisplay.ChanVisible[ch] := True
                       else scDisplay.ChanVisible[ch] := False ;
         end ;

     scDisplay.xMin := 0 ;
     scDisplay.xMax := WCPFile.Settings.NumSamples - 1  ;
     scDisplay.HorizontalCursors[0] := WCPFile.Channel[ChSim].ADCZero ;

     dt := edRecordDuration.Value / WCPFile.Settings.NumSamples ;
     scDisplay.TScale := dt*WCPFile.Settings.TScale ;
     scDisplay.TUnits := WCPFile.Settings.TUnits ;

     edUnitCurrent.Units := WCPFile.Channel[ChSim].ADCUnits ;

     // Reallocate A/D sample buffer
     if ADC <> Nil then FreeMem(ADC) ;
     GetMem( ADC, Max(WCPFile.Settings.NumSamples*WCPFile.RawFH.NumChannels*2,1024) ) ;
     for i := 0 to WCPFile.Settings.NumSamples*WCPFile.RawFH.NumChannels-1 do ADC^[i] := 0 ;
     { Clear all channels }
     scDisplay.SetDataBuf( ADC ) ;

     scDisplay.AddHorizontalCursor(0,WCPFile.Settings.Colors.Cursors,True,'z') ;

     Resize ;

     end ;


procedure TSimMEPSCFrm.bStartClick(Sender: TObject);
{ -------------------------
  Create simulated currents
  -------------------------}
type
    TState = (Unbound,Closed,Open,Blocked) ;
var
   i,j,Ch,iStart,Chan : Integer ;
   Done : Boolean ;
   Current,Drift,TEnd,TDwell,t : single ;
   State : TState ;
   RH : TRecHeader ;
begin

     { Set buttons to be active during simulation run }
     bStart.Enabled := False ;
     bAbort.Enabled := True ;
     CloseFormASAP := False ;

     // Get WCPFile.Settings
     EditFieldsToSettings ;
     if not CheckNewDataFileNeeded then Exit ;

     WCPFile.RawFH.NumSamples := WCPFile.Settings.NumSamples ;
     WCPFile.RawFH.NumChannels := scDisplay.NumChannels ;
     WCPFile.RawFH.dt := edRecordDuration.Value / WCPFile.RawFH.NumSamples ;

     { Set scaling factor if this is an empty file }
     if WCPFile.RawFH.NumRecords = 0 then
        begin
        WCPFile.Channel[ChSim].ADCCalibrationFactor := 1. ;
        WCPFile.Channel[ChSim].ADCScale := Abs( WCPFile.Settings.MEPSCSim.UnitCurrent*
                                        (edNumChannelsAvg.Value +
                                         5.0*edNumChannelsStDev.Value)
                                         + 5.0*WCPFile.Settings.MEPSCSim.NoiseRMS ) / Main.SESLabIO.ADCMaxValue ;
        if WCPFile.Channel[ChSim].ADCScale = 0.0 then
           WCPFile.Channel[ChSim].ADCScale := 1./Main.SESLabIO.ADCMaxValue ;
        WCPFile.RawFH.ADCVoltageRange := 5.0 ;
        WCPFile.Channel[ChSim].ADCCalibrationFactor := WCPFile.RawFH.ADCVoltageRange /
                          ( WCPFile.Channel[ChSim].ADCScale * (Main.SESLabIO.ADCMaxValue+1) ) ;

        WCPFile.RawFH.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
        WCPFile.RawFH.MinADCValue := -Main.SESLabIO.ADCMaxValue -1 ;
        end ;

     if WCPFile.Settings.MEPSCSim.UnitCurrent > 0.0 then
        WCPFile.Channel[ChSim].ADCZero := Main.SESLabIO.ADCMinValue div 2
     else WCPFile.Channel[ChSim].ADCZero := Main.SESLabIO.ADCMaxValue div 2 ;
     scDisplay.HorizontalCursors[0] := WCPFile.Channel[ChSim].ADCZero ;
     WCPFile.Channel[ChSim].ChannelOffset := 0 ;

     // Ensure display channel scaling factor is up to date
     scDisplay.ChanScale[ChSim] := WCPFile.Channel[ChSim].ADCScale ;

     { *** Simulation loop *** }

     Done := False ;
     WCPFile.Settings.MEPSCSim.NumRecordsDone := 0 ;
     while (not Done) do
        begin

        { Number of ion channels in mEPSC }
        WCPFile.Settings.MEPSCSim.NumChannels := Round( RandG( edNumChannelsAvg.Value,
                                         edNumChannelsStDev.Value )) ;

        { Initialise signal record to zero level }
        j := WCPFile.Channel[ChSim].ChannelOffset ;
        for i := 0 to WCPFile.RawFH.NumSamples-1 do
            begin
            ADC^[j] := WCPFile.Channel[ChSim].ADCZero ;
            j := j + WCPFile.RawFH.NumChannels ;
            end ;

        { Add open/close current sequence for each ion channel }
        iStart := WCPFile.RawFH.NumSamples div 10 ;
        for Chan := 0 to WCPFile.Settings.MEPSCSim.NumChannels-1 do
           begin

           { Initial starting point of MEPC }
           j := iStart*WCPFile.RawFH.NumChannels + WCPFile.Channel[ChSim].ChannelOffset ;

           { Initial state at start of MEPC ... agonist is bound, channel closed }
           State := Unbound ;

           TEnd := 0.0 ;
           t := 0.0 ;
           while j < (WCPFile.RawFH.NumSamples*WCPFile.RawFH.NumChannels) do begin

               case State of
                Unbound : begin
                   Current := 0.0 ;
                   if t < (WCPFile.Settings.MEPSCSim.TransmitterDecayTime*10.0) then
                      TDwell := -ln(random)/WCPFile.Settings.MEPSCSim.BindingRate*exp(-t/WCPFile.Settings.MEPSCSim.TransmitterDecayTime)
                   else TDwell := WCPFile.RawFH.NumSamples*WCPFile.RawFH.dt ;
                   State := Closed ;
                   end ;
                { Close state processing }
                Closed : begin
                   Current := 0.0 ;
                   TDwell := -WCPFile.Settings.MEPSCSim.TClosed*ln(random) ;
                   if Random <= WCPFile.Settings.MEPSCSim.PUnbind then State := Unbound
                                            else State := Open ;
                   end ;
                { Open state processing }
                Open : begin
                   Current := WCPFile.Settings.MEPSCSim.UnitCurrent ;
                   TDwell := -WCPFile.Settings.MEPSCSim.TOpen*ln(random) ;
                   if Random <= WCPFile.Settings.MEPSCSim.PClose then State := Closed
                                           else State := Blocked ;
                   end ;
                Blocked : begin
                   Current := 0.0 ;
                   TDwell := -WCPFile.Settings.MEPSCSim.TBlocked*ln(random) ;
                   State := Open ;
                   end ;
                end ;

               TEnd := TEnd + TDwell ;
               while (t <= TEnd) and (j < (WCPFile.RawFH.NumSamples*WCPFile.RawFH.NumChannels)) do begin
                    ADC^[j] := ADC^[j] + Round(Current/WCPFile.Channel[ChSim].ADCScale) ;
                    t := t + WCPFile.RawFH.dt ;
                    j := j + WCPFile.RawFH.NumChannels ;
                    end ;
               end ;
            end ;

        { Add Background noise & Drift }
        j := WCPFile.Channel[ChSim].ChannelOffset ;
        Drift := (2.0*(Random - 0.5)*edDrift.Value)/WCPFile.RawFH.NumSamples ;
        for i := 0 to WCPFile.RawFH.NumSamples-1 do
            begin
            ADC^[j] := ADC^[j] +
                       Round( (RandG(0.0,WCPFile.Settings.MEPSCSim.NoiseRMS)+Drift*i)
                               /WCPFile.Channel[ChSim].ADCScale ) ;
            j := j + WCPFile.RawFH.NumChannels ;
            end ;

        { Low pass filter signal (if required) }
        if rbLPFilterOn.Checked and (edLPFilter.Value > 0.0) then
           WCPFile.GaussianFilter( WCPFile.RawFH, ADC^, edLPFilter.Value*WCPFile.RawFH.dt ) ;

        { Save Record to file }
        Inc(WCPFile.RawFH.NumRecords) ;
        RH.Status := 'ACCEPTED' ;
        RH.RecType := 'TEST' ;
        RH.Number := WCPFile.RawFH.NumRecords ;
        RH.Time := RH.Number ;
        RH.dt := WCPFile.RawFH.dt ;
        for ch := 0 to WCPFile.RawFH.NumChannels-1 do
             RH.ADCVoltageRange[Ch] := WCPFile.RawFH.ADCVoltageRange ;
        RH.Value[vFitEquation] := 0.0 ;
        RH.AnalysisAvailable := False ;
        RH.Ident := ' ' ;
        WCPFile.PutRecord( WCPFile.RawFH, RH, WCPFile.RawFH.NumRecords, ADC^ ) ;

        scDisplay.Invalidate ;

        Inc(WCPFile.Settings.MEPSCSim.NumRecordsDone) ;
        if (WCPFile.Settings.MEPSCSim.NumRecordsDone >= WCPFile.Settings.MEPSCSim.NumRecords) or bStart.Enabled then Done := True ;

        // Report progress
        Main.StatusBar.SimpleText := format(
        ' Miniature EPSC Simulation : %d/%d records done ',
        [WCPFile.Settings.MEPSCSim.NumRecordsDone,WCPFile.Settings.MEPSCSim.NumRecords] ) ;

        Application.ProcessMessages ;

        if CloseFormASAP then Done := True ;

        end ;

     { Close form if WCPFile.Settings.MEPSCSim.lation has not been aborted }

     // Final report
     Main.StatusBar.SimpleText := format(
     ' Miniature Simulation : %d records created ',
     [WCPFile.Settings.MEPSCSim.NumRecordsDone] ) ;

     bStart.Enabled := True ;
     bAbort.Enabled := False ;
     WCPFile.SaveHeader( WCPFile.RawFH ) ;

     WCPFile.WriteToLogFile(format('%d Simulated mEPSCs created',[WCPFile.Settings.MEPSCSim.NumRecords])) ;
     WCPFile.WriteToLogFile(format('Avg. number of channels %.0f',[edNumChannelsAvg.Value])) ;
     WCPFile.WriteToLogFile(format('Standard deviation %.0f',[edNumChannelsStDev.Value])) ;
     WCPFile.WriteToLogFile(format('Unitary current %.f',[edUnitCurrent.Value])) ;
     WCPFile.WriteToLogFile(format('Channel opening rate %.0f',[edOpenRate.Value])) ;
     WCPFile.WriteToLogFile(format('Channel closing rate %.0f',[edCloseRate.Value])) ;
     WCPFile.WriteToLogFile(format('Agonist unbinding rate %.0f',[edUnbindRate.Value])) ;
     WCPFile.WriteToLogFile(format('Channel blocking rate %.0f',[edBlockRate.Value])) ;
     WCPFile.WriteToLogFile(format('Channel unblocking rate %.0f',[edUnblockRate.Value])) ;

     // Close form if requested
     if CloseFormASAP then Close ;

     end;


procedure TSimMEPSCFrm.EditFieldsToSettings ;
// ------------------------------
// Save settings from edit fields
// ------------------------------
begin

     { Get parameters from edit boxes }

     WCPFile.Settings.NumSamples := Min(Round(edNumSamples.Value),Main.SESLabIO.ADCBufferLimit) ;
     WCPFile.Settings.NumSamples := 256*Max(WCPFile.Settings.NumSamples div 256,1) ;
     edNumSamples.Value := WCPFile.Settings.NumSamples ;

     WCPFile.Settings.MEPSCSim.NumRecords := Round(edNumRecords.Value) ;
     WCPFile.Settings.MEPSCSim.RecordDuration := edRecordDuration.Value ;
     WCPFile.Settings.MEPSCSim.UnitCurrent := edUnitCurrent.Value ;
     WCPFile.Settings.MEPSCSim.TransmitterDecayTime := edTransmitterDecayTime.Value ;

     WCPFile.Settings.MEPSCSim.BindingRate :=  edBindRate.Value ;
     WCPFile.Settings.MEPSCSim.OpenRate := edOpenRate.Value ;
     WCPFile.Settings.MEPSCSim.CloseRate :=  edCloseRate.Value ;
     WCPFile.Settings.MEPSCSim.UnbindRate :=  edUnbindRate.Value ;
     WCPFile.Settings.MEPSCSim.BlockRate := edBlockRate.Value ;
     WCPFile.Settings.MEPSCSim.UnBlockRate := edUnBlockRate.Value ;

     WCPFile.Settings.MEPSCSim.BindingRate := edBindRate.Value ;
     WCPFile.Settings.MEPSCSim.TClosed := 1.0/(edOpenRate.Value + edUnbindRate.Value) ;
     WCPFile.Settings.MEPSCSim.TOpen := 1.0 / (edCloseRate.Value + edBlockRate.Value) ;
     WCPFile.Settings.MEPSCSim.PUnbind := edUnbindRate.Value / (edUnbindRate.Value + edOpenRate.Value) ;
     WCPFile.Settings.MEPSCSim.TBlocked := 1.0 / edUnBlockRate.Value ;
     WCPFile.Settings.MEPSCSim.PClose := edCloseRate.Value / (edCloseRate.Value + edBlockRate.Value) ;

     WCPFile.Settings.MEPSCSim.NoiseRMS := edNoiseRMS.Value ;
     WCPFile.Settings.MEPSCSim.LPFilter := edLPFilter.Value ;

     WCPFile.Settings.MEPSCSim.LPFilterInUse := rbLPFilterOn.Checked ;
     WCPFile.Settings.MEPSCSim.Drift := edDrift.Value ;

     end ;


procedure TSimMEPSCFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
{ ------------------------
  Tidy up when form closed
  ------------------------}
begin

     // Copy WCPFile.Settings from edit fields into WCPFile.Settings record
     EditFieldsToSettings ;

     WCPFile.SaveHeader( WCPFile.RawFH ) ;

     if WCPFile.RawFH.NumRecords > 0 then begin
        Main.mnShowRaw.Enabled := True ;
        Main.mnShowRaw.Click ;
        Main.mnZoomOutAll.Click ;
        end ;

     Action := caFree ;

     end;


procedure TSimMEPSCFrm.bAbortClick(Sender: TObject);
{ ------------------------------------
  ABORT button - Aborts WCPFile.Settings.MEPSCSim.lation run
  ------------------------------------}
begin
     bStart.Enabled := True ;
     bAbort.Enabled := False ;
     end;


procedure TSimMEPSCFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
     { Prevent form being closed if a WCPFile.Settings.MEPSCSim.lation is running (Start button disabled) }
     if bStart.Enabled then CanClose := True
                       else CanClose := False ;
     CloseFormASAP := True ;
     end;

procedure TSimMEPSCFrm.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin
    ADC := Nil ;
    end;


procedure TSimMEPSCFrm.FormDestroy(Sender: TObject);
// ------------------------------
// Tidy up when form is destroyed
// ------------------------------
begin
    if ADC <> Nil then FreeMem(ADC) ;
    end;

procedure TSimMEPSCFrm.FormResize(Sender: TObject);
{ ------------------------------------------------------
  Adjust size/position of controls when form is re-sized
  ------------------------------------------------------ }
begin
      RecCondGrp.Top := ClientHeight - RecCondGrp.Height - 5 ;
      ModelGrp.Top := RecCondGrp.Top ;
      ModelGrp.Width := ClientWidth - ModelGrp.Left - 5 ;
      scDisplay.Height := MaxInt( [ModelGrp.Top - scDisplay.Top - 10,2]) ;
      scDisplay.Width := MaxInt( [ModelGrp.Width,2]) ;
      end;



procedure TSimMEPSCFrm.scDisplayCursorChange(Sender: TObject);
begin
     WCPFile.Channel[ChSim].yMin := scDisplay.YMin[ChSim] ;
     WCPFile.Channel[ChSim].yMax := scDisplay.YMax[ChSim] ;
     end;


procedure TSimMEPSCFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;

     scDisplay.Invalidate ;
     end ;


procedure  TSimMEPSCFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;
     scDisplay.ZoomOut ;
     end ;

function TSimMEPSCFrm.CheckNewDataFileNeeded : Boolean ;
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
        NewFileName := WCPFile.CreateIndexedFileName( WCPFile.RawFH.FileName ) ;
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


procedure TSimMEPSCFrm.edNumSamplesKeyPress(Sender: TObject;
  var Key: Char);
begin
     if Key = #13 then EditFieldsToSettings ;
     end;

end.
