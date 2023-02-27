unit Rec;
{ ==============================================================================
  WinWCP - Analogue Recording module (c) J. Dempster 1996, All Rights Reserved.
  8/9/97 ... Event detector Pretrigger % can now be set by user V1.7b
  31/5/98 ... GetInterfaceInfo put into Create method to force initialisation
              of lab. interface before timed events start
              DAC buffer now locked into memory to fix intermittent 0V glitches
              between cycles of D/A waveforms
  14/8/99 ... 32 bit version
  4/9/99 ... Display grid added
  11/12/99 ... TimeStart changed Settings.TimeRecordingStarted
  20/12/01 ... D/A and digital default values now set using Main.WriteOutputPorts (V3.2.1)
  17/3/02 .... Empty buffers now filled with pairs of positive/negative empty flags
               to avoid hang ups when buffer was filled with A/D values equal
               to empty flag.
               Channel Units/Div scaling information added to display
  15.7.02 .... Voltage pulse timing procedures moved to SESLABIO
  13.2.03 .... Display time calibration now correctly updated when sweep duration
               changes occur while in storage mode
  16.4.03 .... Sweep now terminates correctly when A/D input = emptyflag
  24.6.03 ... No. of display grid lines can be changed
  6.9.03 .... Erase screen button enabled
  18.03.04 .. A/D resolution now checked for compatibility with data in file
              before form is opened
  30.07.04 .. StartRecording & StopRecording states now replaced with
              StartSweep & StopSweep procedures. Recording sweeps can now                         c0
              be acquired at 10 sweeps/second
  02.08.04 .. ADCDisplay buffer added to ensure trace remains displayed correctly
              between sweeps
  04.08.04 .. Channel calibration factor and units now updated automatically
              from Amplifier module as well as gain. Switches between current & voltage
              clamp mode can be handled (UpdateSettings)
  04.05.06 .. Storage display mode now working again
  25.07.06 Recording channel settings now stored in RecChannel (global.pas)
  03.07.06 .. NumChannels, NumSamples, ADCVoltageIndex & RecordDuration now stored in settings (not RawFH)
              EndOfSweepCount now used to detect completion of sweep
  19.08.06 .. Storage display mode now working again
  21.08.06 .. Record time stamp now derived from master Windows tick count
              (rather than stimulus tick counter)
  17.09.06 .. .ZoomOut now sets RecChannel YMin/YMax properties
  29.10.07 .. Stimulus wavceforms now always recreated before each sweep
              (Previously waveform was not recreated when pulse were repeated.
               which caused duration errors with NIDAQ-MX and repeated waveforms)
  28.11.07 .. Stimulus program selected when recording started now restored at stop of recording
              Stimulus program name now included in status bar
  08.02.08 .. Bug in event detector which produced incorrect sampling intervals
              and number of samples / record fixed
  05.08.08 .. Now possible to magnify display on X axis as well as Y
  16.09.08 .. Leak waveform now re-created in leak mode to avoid different
              leak pulse duration
  11.02.09 .. Stimulus protocol folder can now be set by user.
  13.05.09 .. Empty flags now replaced by last recorded samplewhen recording sweep
              is prematurely terminated bu user
  13.05.10 .. Channel display visibility setting now preserved in RecChannel[].InUse
  22.07.10 .. Time of record acquisition (RH.Time) now set when record is saved
              to provide consistent time for all trigger modes. Fixes bug with
              external trigger mode where first record had T=0 and 2nd record
              record had incorrectly long time.
  06.01.11 .. TritonPanelFrm opened automatically when record form is displayed
              when a Tecella amplifier is in use.
  09.02.11 .. Second pair of cursors added for on-line analysis
  27.05.11 .. Recording mode now selected from drop-down menu
              No. records and no. samples/record now set in record window (not setup)
  20.07.11 .. Protocol execution list added
  17.08.11 .. Protocol file names now local to selected protocol folder so linked
              protocols continue to work when folders renamed
  12.09.11 .. Stimulator.Prot.NumAOChannels now used to set number of AO channels in use
              All 4 AO channels of CED Power 1401 now work. DO0 and DO1 also checked and OK
  14.09.11 .. Display Y ranges now updated on exit
  20.09.11 .. Main.SESLabIO.ADCVoltageRangeIndex now set from Settings.ADCVoltageRangeIndex
              every time .StartADC is called
  13.03.12 .. VCLAMP/ICLAMP mode of amplifiers now indicated/set in recording window
  16.04.12 .. Stimulus output channels now limited to number of available DAC channels
              Global display channel vertical limits and enabled/disabled settings
              now updated whenever changed.
              Changes to recording parameters now disabled when recording in progress
              Record display window (if open) now updated with number of records as they are collected
  15.06.12 .. Prot.RecordDuration no longer updated after Stimulator.SetADCDAC
              to avoid changes record duration during protocol due to adjustment
              of A/D update interval by interface board
  30.08.12 .. "Incl. stim protocol in file name" option added. Creates new file every time Record is started
              or a protocol changes and appends protocol name and sequence number to data file name.
              New files forced by changes in recording settings are now indicated .XX.wcp sequence number
              rather than appended pluses.
  31.08.12 .. Empty record no longer written to file when recording sweeps are aborted by pressing Stop button
  29.07.13 .. Include Stim Protocol in File Name check box setting now stored in INI file
              file name with appended stimulus protocol updated to handle stimuli with ".." in names
              Recording window can now be opened without an open data file.
              Correct stimulus protocol names now appended to file name for linked protocols
              Record acquisition time now acquired at start of recording sweep (with 50ms accuracy)
  26.08.13 .. CheckNewDataFileNeeded() now permits 1E-4 difference in channel gains without requiring
              a new file to be opened to allow for loss of precision when data written/read from fiel header
  06.09.13 .. EPC9PanelFrm opened if EPC9/10 patch clamp in use.
  23.09.13 .. Recording start time now encoded in en-GB format
  25.06.14 .. From Record zero level can now be set in recording window
  15.10.14 .. Stimulus protocol status now updated during sweep and shows time till next stimulus
  23.03.15 .. Incrementing of dynamic clamp Gmax added
  10.04.15 .. Zero level now correctly set to fixed level rather than From Record
  15.06.15 .. No. of samples/record now adjusted to maintain constant record duration
              when sampling interval changed.
  14.08.15 .. LeakSum buffer no longer allocated and deallocated during leak subtraction records
              fixing spurious values which appeared in first samples of leak subtracted records
  24.08.15 .. cbdetectEvents menu now set from SESLabIO, not ChannelNames
              ADCDisplay buffer now only reallocated if size has changed, allowing recorded traces
              from previous linked protocols to remain on display.
  05.11.15 .. Marker Add button removed. Marker text now added automatically to record
  05.11.15 HekaEPC9USB interface added
  8.11.15 .. TMeasureFrmCursors.Base removed since use was redundant.
  16.03.16 .. scDisplay.recordnumber incremented after SaveSweep to make storage mode work correctly
  11.07.16 .. UpdateChannelSettings() removed from SaveSweep() to speed it up allow 5 HZ repeat
              rates. Now called by brecord.click and when a protocol loaded
  10.08.16 .. TImer interval reduced to 30ms to make reading of data from NIDAQ boards faster
  30.08.16 .. RH.ADCVoltageRange now updated in SaveSweep() to account for changes
              in amplifier gain (previously done by UpdateChannelSettings() which
              was removed from SaveSweep() to speed up saving to file.
  12.01.17 .. .VerticalCursors() now single type and converted to integer by round()
  27.02.17 .. UpdateDisplay now called during .bOpenOLAWindowClick to ensure
              window duration is valid when on-line window opened.
  01.03.17 .. Display time scaling no longer changes between and within sweeps.
  17.03.17 .. Main.SESLabIO.StimulusStartFlag now cleared in StartSweep() in
              all recording modes other than rmProtocol to avoid generation of
              unwanted stimulus from previous protocol in first sweep following
              a stimulus protocol sweep
  19.07.17 .. Amplifier.GetChannelSettings() now returns ADCInput, so
              secondary channel analogue input for be changed in CC mode
              for Axopatch 200 and AMS-2400
  13.12.17 .. Real-time plot cursors now updated from settinfs.recplot within UpdateDisplay() to ensure cursors
              remain on screen if number of samples/record change
  05.11.18 .. LEAK records can now be excluded from on-line plot.
  02.06.20 .. Record duration and sampling interval no longer change slightly when set repeatedly to same number
              Values saved to settings. No. of samples no longer limited to powers of 2.
  27.08.21 .. .StopSweep renamed .StopADCandDAC for compatibility with WinEDR

  ==============================================================================}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,
  maths, math, ValEdit, ScopeDisplay, SESLabIO, mmsystem, ValidatedEdit,
  ComCtrls, strutils, UITypes, WCPFIleUnit ;

const
     rmProtocol = 0 ;
     rmFreeRun = 1 ;
     rmExtTrig = 2 ;
     rmDetect = 3 ;
    DCL_None = 0 ;
    DCL_Initialise = 1 ;
    DCL_NextRecord = 2 ;
    DCL_NextProtocol = 3 ;


type

    TDet = record
         StartAt : Integer ;
         EndAt : Integer ;
         PreTriggerPoints : Integer ;
         Baseline : Integer ;
         Threshold : Integer ;
         Polarity : Integer ;
         Pointer : Integer ;
         EndOfBuf : Integer ;
         Chan : Integer ;
         LastChan : Integer ;
         ChanSelected : Integer ;
         EventDetected : boolean ;
         TimeDetected : single ;
         BufferCycles : Integer ;
         end ;

    TStopwatch = record
               ElapsedTime : TDateTime ;
               Hour : Word ;
               Minute : Word ;
               Second : Word ;
               MSec : Word ;
               TickStart : single ;
               OldSeconds : single ;
               end ;


  TState = ( Idle, SweepInProgress ) ;
  TRecordFrm = class(TForm)
    ControlGrp: TGroupBox;
    bRecord: TButton;
    bStop: TButton;
    ckSaveRecords: TCheckBox;
    Timer: TTimer;
    DisplayGrp: TGroupBox;
    edStatus: TEdit;
    edIdent: TEdit;
    Label4: TLabel;
    TimerGrp: TGroupBox;
    edTimeOfDay: TEdit;
    bResetTimer: TButton;
    bErase: TButton;
    OnLineAnalysisGrp: TGroupBox;
    ckFixedZeroLevels: TCheckBox;
    bOpenOLAWindow: TButton;
    bCloseOLAWindow: TButton;
    edMarker: TEdit;
    Label6: TLabel;
    Label8: TLabel;
    Bevel4: TBevel;
    RecordModeGrp: TGroupBox;
    cbRecordingMode: TComboBox;
    RecordParametersPanel: TPanel;
    edNumRecords: TValidatedEdit;
    Label3: TLabel;
    Label10: TLabel;
    edNumSamples: TValidatedEdit;
    Label11: TLabel;
    edNumChannels: TValidatedEdit;
    Label12: TLabel;
    edSamplingInterval: TValidatedEdit;
    Label13: TLabel;
    edRecordDuration: TValidatedEdit;
    panAmplifierGain0: TPanel;
    lbAmplifier: TLabel;
    edAmplifierGain0: TValidatedEdit;
    panAmplifierGain1: TPanel;
    Label14: TLabel;
    edAmplifierGain1: TValidatedEdit;
    panAmplifierGain2: TPanel;
    Label15: TLabel;
    edAmplifierGain2: TValidatedEdit;
    panAmplifierGain3: TPanel;
    Label16: TLabel;
    edAmplifierGain3: TValidatedEdit;
    panProtocol: TPanel;
    rbSingleProtocol: TRadioButton;
    rbProtocolList: TRadioButton;
    panProtocolList: TPanel;
    Label17: TLabel;
    cbProtocolList: TComboBox;
    meProtocolList: TMemo;
    bAddProtocolToList: TButton;
    bNewProtocolList: TButton;
    edNewProtocolListName: TEdit;
    bDeleteProtocolList: TButton;
    panSingleProtocol: TPanel;
    Label18: TLabel;
    cbPulseProgram: TComboBox;
    bSetStimFolder: TButton;
    ExtTriggerGrp: TGroupBox;
    rbExtTriggerHigh: TRadioButton;
    rbExttriggerLow: TRadioButton;
    DetectGrp: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    cbDetectChannel: TComboBox;
    edDetectionThreshold: TValidatedEdit;
    edPreTrigger: TValidatedEdit;
    OpenDialog: TOpenDialog;
    scDisplay: TScopeDisplay;
    rbVCLAMP0: TRadioButton;
    rbICLAMP0: TRadioButton;
    rbVCLAMP1: TRadioButton;
    RBICLAMP1: TRadioButton;
    rbVCLAMP2: TRadioButton;
    RBICLAMP2: TRadioButton;
    rbVCLAMP3: TRadioButton;
    rbICLAMP3: TRadioButton;
    ckNewFileOnRecord: TCheckBox;
    bFindCursors: TButton;
    procedure TimerTimer(Sender: TObject);
    procedure bRecordClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure cbPulseProgramChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bResetTimerClick(Sender: TObject);
    procedure EdDetectionThresholdKeyPress(Sender: TObject; var Key: Char);
    procedure FormDeactivate(Sender: TObject);
    procedure edIdentKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bEraseClick(Sender: TObject);
    procedure edPreTriggerKeyPress(Sender: TObject; var Key: Char);
    procedure cbDetectChannelChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure rbExtTriggerHighClick(Sender: TObject);
    procedure rbExttriggerLowClick(Sender: TObject);
    procedure ckFixedZeroLevelsClick(Sender: TObject);
    procedure edAmplifierGain0KeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure bOpenOLAWindowClick(Sender: TObject);
    procedure bCloseOLAWindowClick(Sender: TObject);
    procedure bSetStimFolderClick(Sender: TObject);
    procedure cbRecordingModeChange(Sender: TObject);
    procedure edNumChannelsKeyPress(Sender: TObject; var Key: Char);
    procedure edNumSamplesKeyPress(Sender: TObject; var Key: Char);
    procedure edRecordDurationKeyPress(Sender: TObject; var Key: Char);
    procedure edNumRecordsKeyPress(Sender: TObject; var Key: Char);
    procedure edSamplingIntervalKeyPress(Sender: TObject; var Key: Char);
    procedure rbSingleProtocolClick(Sender: TObject);
    procedure rbProtocolListClick(Sender: TObject);
    procedure cbProtocolListChange(Sender: TObject);
    procedure bAddProtocolToListClick(Sender: TObject);
    procedure bDeleteProtocolListClick(Sender: TObject);
    procedure bNewProtocolListClick(Sender: TObject);
    procedure rbVCLAMP0Click(Sender: TObject);
    procedure rbICLAMP0Click(Sender: TObject);
    procedure scDisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ckNewFileOnRecordClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bFindCursorsClick(Sender: TObject);
  private
    { Private declarations }

   ADC : PSmallIntArray ;          // A/D sample data buffer
   DAC : PSmallIntArray ;          // A/D waveform data buffer
   DigBuf : PSmallIntArray ;       // Digital port output array
   ADCCircular : PSmallIntArray ;  // A/D sample data buffer circular

   ADCCopy : PSmallIntArray ;
   ADCDetected : PSmallIntArray ;
   ADCDisplay : PSmallIntArray ;

   LeakSum : PIntArray ;           // Summation buffer used to average LEAK records

   Det : TDet ;

   EndOfBuf : Integer ;
   RH : TRecHeader ;
   NumRecordsDone,EndAtRecord : Integer ;
   NextBlock : Integer ;
   DIGActive : Boolean ; { Digital port sub-system active }
   NewSweep : Boolean ;
   GroupNumber : Integer ; { Group of TEST and LEAK records produced by same
                            voltage program waveform }
   OldStepCounter : Integer ; { Previous voltage program step number }
   Stopwatch : TStopwatch ;
   StatusCounter : Integer ;
   EndOfSweep : boolean ;
   EndOfSweepCount : Integer ;
   AbortRecording : boolean ;
   EraseScreen : boolean ;
   NumBlocksDone : Integer ;
   EmptyFlag : Integer ;
    NewAmplifierGain : Boolean ;

    C0Cursor : Integer ;
    C1Cursor : Integer ;
    C2Cursor : Integer ;
    C3Cursor : Integer ;
    C4Cursor : Integer ;

    StartingPulseProgramIndex : Integer ; // Pulse program index at start of recording
    ProtocolCount : Integer ;           // Protocol execution list index counter
    ProtocolFileName : String ;         // Currently selected stimulus protocol file

    DataFileIndex : Integer ;

    DCLAMPAction : Integer ;            // Dynamic clamp action required

    procedure SaveSweep ;
    procedure InitialiseEventDetector ;
    procedure DetectEvent ;
    procedure StartVoltageProgram ;
    procedure RestoreIdleState ;

    procedure UpdateStopwatch ;
    procedure ShutDownLabInterface ;
    procedure MainMenus( Enabled : Boolean ) ;
    procedure UpdateChannelSettings ;
    procedure UpdateAmplifierGain ;
    procedure SetRecordingMode(iMode : Integer ) ;
    function GetRecordingMode : Integer ;
    function GetStimulusProtocol : String ;
    procedure SetStimulusProtocol( Value : String ) ;
    function GetRunning : Boolean ;
    function GetRecording : Boolean ;
    procedure UpdateSamplingInterval ;
    procedure UpdateAmplifierGains ;
    procedure ShowAmplifierGains ;
    function UpdateVProgramFileName( NewName : String ) : String ;
    function CheckNewDataFileNeeded : Boolean ;
    procedure CreateProtocolListList( var cbList : TComboBox ) ;
    function LoadProtocolList : Boolean ;
    function SaveProtocolList( FileName : String ) : Boolean ;
    function LoadStimulusProtocol(
             Initialise : Boolean              // True = Initialise protocol counter
             ) : Boolean ;
    procedure DisplayClampMode ;
    procedure AddOLAWCursors ;

  public
    { Public declarations }
    TimerBusy : boolean ;
    State : TState ;   // Current operational state of module


    procedure SetStoreMode( StorageMode : Boolean ) ;
    procedure ChangeDisplayGrid ;
    procedure ZoomOutAll ;
    procedure ZoomIn( ChanNum : Integer ) ;
    procedure ZoomOut( ChanNum : Integer ) ;

    procedure StartSweep ;
    procedure StopADCandDAC ;

    procedure UpdateStimulusProtocolList ;
    procedure UpdateDisplay( Clear : Boolean ) ;

    procedure StartRecording ;
    procedure StopRecording ;

    property RecordingMode : Integer read GetRecordingMode write SetRecordingMode ;
    property StimulusProtocol : String
             read GetStimulusProtocol write SetStimulusProtocol ;
    property Running : Boolean read GetRunning ;
    property Recording : Boolean read GetRecording ;

  end;


var
  RecordFrm: TRecordFrm;

implementation

{$R *.DFM}

uses MDiform, AmpModule, StimModule , RecPlotUnit, Sealtest,
  TritonPanelUnit, DirectorySelectUnit, Replay, Zero, DCLAMPUnit ;

procedure TRecordFrm.FormShow(Sender: TObject);
{ ------------------------------------
  Initialisation when form is created
  ----------------------------------- }
var
    i : Integer ;
begin

     // Set position of form
     Left := 20 ;
     Top := 20 ;
     Height := Main.StatusBar.Top - Top - 10 ;
     Width := Main.ClientWidth - Left - 20 ;

     if WCPFile.RawFH.FileHandle >= 0 then Caption := 'Record ' + WCPFile.RawFH.FileName
                              else Caption := 'Record No File' ;

     { Make sure event timer is off }
     Timer.Enabled := False ;

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

     { Allocate memory buffers }

     { Get locations of A/D, D/A and digital I/O buffers from lab. interface }
     Main.SESLabIO.GetADCBuffer( ADC ) ;
     Main.SESLabIO.GetDACBuffer( DAC ) ;
     Main.SESLabIO.GetDIGBuffer( DigBuf ) ;
     EmptyFlag := Main.SESLabIO.ADCEmptyFlag ;

     { Check that the selected hardware/software is available }
     if not Main.SESLabIO.LabInterfaceAvailable then begin
        ShowMessage( 'Laboratory interface not available!' ) ;
        Close ;
        Exit ;
        end ;

     { Set size of window }
     ClientHeight := TimerGrp.Top + TimerGrp.Height + 5 ;
     //ClientWidth := scDisplay.Width  + 5 ;
     edIdent.text := WCPFile.RawFH.IdentLine ;
     RH.dt := Main.SESLabIO.ADCSamplingInterval ;
     DigActive := False ;
     EraseScreen := False ;
     ckNewFileOnRecord.Checked := WCPFile.Settings.OpenNewFileOnRecord ;

     { Fill combo box with list of available command voltage programs }
     UpdateStimulusProtocolList ;

     // Recording mode selection box
     cbRecordingMode.Clear ;
     cbRecordingMode.Items.Add('Stimulus protocol') ;
     cbRecordingMode.Items.Add('Free run') ;
     cbRecordingMode.Items.Add('Ext. triggered') ;
     cbRecordingMode.Items.Add('Detect events') ;
     cbRecordingMode.ItemIndex := WCPFile.Settings.RecordingMode ;
     SetRecordingMode( cbRecordingMode.ItemIndex ) ;

     // Set external trigger polarity
     Main.SESLabIO.ADCExternalTriggerActiveHigh := WCPFile.Settings.ExternalTriggerActiveHigh ;
     rbExtTriggerHigh.Checked := Main.SESLabIO.ADCExternalTriggerActiveHigh ;

     { Set event detector }
     edDetectionThreshold.Value := WCPFile.Settings.EventDetector.Threshold ;
     edPreTrigger.Value := WCPFile.Settings.EventDetector.PreTrigger ;

     OldStepCounter := -1 ;

     { Initialise stopwatch }
     Stopwatch.TickStart := GetTickCount ;
     Stopwatch.OldSeconds := 0. ;

     ShowAmplifierGains ;

     { If a CED 1902 is in use, update its settings }
     for i := 0 to MaxAmplifiers-1 do begin
         if Amplifier.AmplifierType[i] = amCED1902 then Amplifier.SetCED1902 ;
         end ;

     edNumRecords.Value := WCPFile.Settings.NumRecordsRequired ;
     edRecordDuration.Value := WCPFile.Settings.RecordDuration ;
     edNumSamples.Value := WCPFile.Settings.NumSamples ;
     edNumChannels.Value := WCPFile.Settings.NumChannels ;
     UpdateSamplingInterval ;

     edStatus.font.color := clBlack ;
     TimerBusy := False ;
     State := Idle ;
     EndofSweep := False ;
     StartingPulseProgramIndex := 0 ;

     // Set recording mode to force update of signal display to current settings
     SetRecordingMode( cbRecordingMode.ItemIndex ) ;

     Timer.Enabled := True ;

     end ;


procedure TRecordFrm.ShowAmplifierGains ;
// --------------------------------------
// Show gain values for amplifiers in use
// --------------------------------------
begin
     if Amplifier.AmplifierType[0] = amNone then panAmplifierGain0.Visible := False
                                      else panAmplifierGain0.Visible := True ;
     if Amplifier.AmplifierType[1] = amNone then panAmplifierGain1.Visible := False
                                      else panAmplifierGain1.Visible := True ;
     if Amplifier.AmplifierType[2] = amNone then panAmplifierGain2.Visible := False
                                      else panAmplifierGain2.Visible := True ;
     if Amplifier.AmplifierType[3] = amNone then panAmplifierGain3.Visible := False
                                      else panAmplifierGain3.Visible := True ;

     if PanAmplifierGain3.Visible then begin
        DisplayGrp.ClientHeight := PanAmplifierGain3.Top
                                   + PanAmplifierGain3.Height + 5 ;
        end
     else if PanAmplifierGain2.Visible then begin
        DisplayGrp.ClientHeight := PanAmplifierGain2.Top
                                   + PanAmplifierGain2.Height + 5 ;
        end
     else if PanAmplifierGain1.Visible then begin
        DisplayGrp.ClientHeight := PanAmplifierGain1.Top
                                   + PanAmplifierGain1.Height + 5 ;
        end
     else begin
        DisplayGrp.ClientHeight := PanAmplifierGain0.Top
                                   + PanAmplifierGain0.Height + 5 ;
        end ;

     end ;


procedure TRecordFrm.UpdateStimulusProtocolList ;
// ----------------------------------
// Update list of stimulus protocols
// ----------------------------------
begin

     { Fill combo box with list of available command voltage programs }
     Stimulator.CreateProtocolList( cbPulseProgram ) ;

     if (WCPFile.Settings.VProgramFileName = '') or
        ANSIContainsText(WCPFile.Settings.VProgramFileName,'\ .') then begin
        cbPulseProgram.ItemIndex := 0 ;
        end
     else begin
        cbPulseProgram.ItemIndex := cbPulseProgram.Items.IndexOf(
                                    WCPFile.ExtractFileNameOnly(WCPFile.Settings.VProgramFileName))
        end ;

     // Update list of protocol lists
     CreateProtocolListList( cbProtocolList ) ;
     if (WCPFile.Settings.ProtocolListFileName = '') or
        ANSIContainsText(WCPFile.Settings.ProtocolListFileName,'\ .') then begin
        cbProtocolList.ItemIndex := 0 ;
        meProtocolList.Clear ;
        end
     else begin
        cbProtocolList.ItemIndex := cbProtocolList.Items.IndexOf(
                                    WCPFile.ExtractFileNameOnly(WCPFile.Settings.ProtocolListFileName)) ;
        LoadProtocolList ;
        end ;

     end ;


procedure TRecordFrm.UpdateDisplay(
          Clear : Boolean            // True = clear display
          ) ;
{ -----------------------------------------------
  Re-initialise display when data file is changed
  ----------------------------------------------- }
var
   i,ch : Integer ;
   BufferChanged : Boolean ;
begin

     if cbRecordingMode.ItemIndex = rmProtocol then begin
        // Stimulus protocol recording mode
        if (ProtocolFileName <> '') and
           FileExists(ProtocolFileName) then begin
           Stimulator.LoadProtocol(ProtocolFileName) ;
           end ;
        end
     else begin
        // All other recording modes
        Main.SESLabIO.ADCNumChannels := WCPFile.Settings.NumChannels ;
        Main.SESLabIO.ADCNumSamples := WCPFile.Settings.NumSamples ;
        Main.SESLabIO.ADCSamplingInterval := WCPFile.Settings.RecordDuration / WCPFile.Settings.NumSamples ;
        WCPFile.Settings.RecordDuration := Main.SESLabIO.ADCSamplingInterval*Main.SESLabIO.ADCNumSamples ;
        end ;

     // Determine of buffer size has changed
     if ((scDisplay.NumChannels <> Main.SESLabIO.ADCNumChannels) or
        (scDisplay.MaxPoints <> Main.SESLabIO.ADCNumSamples)) or
        (ADCDisplay = Nil) then BufferChanged := True
                           else BufferChanged := False ;

     // Set detect events channel selection menu
     cbDetectChannel.Clear ;
     for ch := 0 to Main.SESLabIO.ADCNumChannels-1 do
         cbDetectChannel.items.Add(format('Ch.%d %s',[ch,Main.SESLabIO.ADCChannelName[ch]])) ;
     cbDetectChannel.ItemIndex := IntLimitTo(WCPFile.Settings.EventDetector.Channel,
                                  0,Main.SESLabIO.ADCNumChannels-1) ;

     { Set up the number of channels/points in the 'scope display }
     scDisplay.NumChannels := Main.SESLabIO.ADCNumChannels ;
     scDisplay.ChanZeroAvg := Main.SESLabIO.ADCChannelNumZero ;
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;

     scDisplay.MaxPoints := Main.SESLabIO.ADCNumSamples ;
     scDisplay.xMin := 0 ;
     scDisplay.xMax := Main.SESLabIO.ADCNumSamples - 1 ;

     {Set channel information }
     for ch := 0 to scDisplay.NumChannels-1 do begin
         scDisplay.ChanOffsets[ch] := Main.SESLabIO.ADCChannelOffset[ch] ;
         scDisplay.ChanUnits[ch] := Main.SESLabIO.ADCChannelUnits[ch] ;
         scDisplay.ChanName[ch] := Main.SESLabIO.ADCChannelName[ch] ;
         scDisplay.ChanScale[ch] := Main.SESLabIO.ADCChannelUnitsPerBit[ch] ;
         scDisplay.yMin[ch] := Main.SESLabIO.ADCChannelYMin[ch] ;
         scDisplay.yMax[ch] := Main.SESLabIO.ADCChannelYMax[ch] ;
         scDisplay.ChanVisible[ch] := Main.SESLabIO.ADCChannelVisible[ch] ;
         end ;

     { Create a set of zero level cursors }
     scDisplay.ClearHorizontalCursors ;
     for ch := 0 to scDisplay.NumChannels-1 do begin
         scDisplay.AddHorizontalCursor(ch,WCPFile.Settings.Colors.Cursors,True,'z' ) ;
         scDisplay.HorizontalCursors[ch] := Main.SESLabIO.ADCChannelZero[ch] ;
         WCPFile.Channel[ch].ADCZeroAt := Main.SESLabIO.ADCChannelZeroAt[ch] ;
         WCPFile.Channel[ch].ADCZero := Main.SESLabIO.ADCChannelZero[ch] ;
         scDisplay.ChanZeroAt[ch] := Main.SESLabIO.ADCChannelZeroAt[ch] ;
         end ;

     scDisplay.TScale := Main.SESLabIO.ADCSamplingInterval*WCPFile.Settings.TScale ;
     scDisplay.TUnits := WCPFile.Settings.TUnits ;

     SetStoreMode(Main.mnStoreTraces.Checked) ;

     { Set A/D buffer to zero }
     EndofBuf := (Main.SESLabIO.ADCNumSamples*Main.SESLabIO.ADCNumChannels) - 1;
     for i := 0 to EndOfBuf do ADC^[i] := 0 ;

     // Re-allocate buffer if size has changed
     if BufferChanged or Clear then begin
        if ADCDisplay <> Nil then FreeMem( ADCDisplay ) ;
        GetMem( ADCDisplay, scDisplay.NumChannels*scDisplay.MaxPoints*2 ) ;
        scDisplay.SetDataBuf( ADCDisplay ) ;
        scDisplay.NumPoints := 0 ;
        end ;

     { Make sure event detector channel is within valid limits }
     cbDetectChannel.Clear ;
     for ch := 0 to Main.SESLabIO.ADCNumChannels-1 do
         cbDetectChannel.items.Add(format('Ch.%d %s',[ch,Main.SESLabIO.ADCChannelName[ch]])) ;
     cbDetectChannel.ItemIndex := IntLimitTo(WCPFile.Settings.EventDetector.Channel,
                                  0,Main.SESLabIO.ADCNumChannels-1) ;

     if not bOpenOLAWindow.Enabled then begin
        scDisplay.VerticalCursors[C0Cursor] := Round(WCPFile.Settings.RecPlot.Cursor0*scDisplay.MaxPoints) ;
        scDisplay.VerticalCursors[C1Cursor] := Round(WCPFile.Settings.RecPlot.Cursor1*scDisplay.MaxPoints) ;
        scDisplay.VerticalCursors[C2Cursor] := Round(WCPFile.Settings.RecPlot.Cursor2*scDisplay.MaxPoints) ;
        scDisplay.VerticalCursors[C3Cursor] := Round(WCPFile.Settings.RecPlot.Cursor3*scDisplay.MaxPoints) ;
        scDisplay.VerticalCursors[C4Cursor] := Round(WCPFile.Settings.RecPlot.Cursor4*scDisplay.MaxPoints) ;
        end ;

     end ;


function TRecordFrm.UpdateVProgramFileName( NewName : String ) : String ;
begin

    Result := WCPFile.Settings.VProtDirectory + NewName + '.xml' ;
    if ANSIContainsText(Result,'\.') or
       ANSIContainsText(Result,'\ .') then Result := '' ;
    end ;


procedure TRecordFrm.TimerTimer(Sender: TObject);
{ ---------------------
  Timed Event scheduler
  ---------------------}
var
   i,i0,i1 : integer ;
   Done : Boolean ;
begin

     if not TimerBusy then begin

        TimerBusy := True ;

        Case State of

          { **** Update display during recording sweep **** }
          SweepInProgress : Begin

               { Get new A/D samples }
               Main.SESLabIO.ADCBufferRefresh ;

               { Check event detection buffer for signal }
               if cbRecordingMode.ItemIndex = rmDetect then DetectEvent ;

               { Determine how many samples have been acquired }
               Done := False ;
               if NextBlock > EndOfBuf then Done := True ;
               While not Done do begin
                   if Odd(Nextblock) then begin
                      // End of multi-channel sample block is odd
                      if (ADC^[NextBlock] = -EmptyFlag) and
                         (ADC^[NextBlock-1] = EmptyFlag) then Done := True
                      else begin
                         i0 := NumBlocksDone*Main.SESLabIO.ADCNumChannels ;
                         i1 :=  i0 + Main.SESLabIO.ADCNumChannels - 1 ;
                         for i := i0 to i1 do ADCDisplay^[i] := ADC^[i] ;
                         Inc(NumBlocksDone) ;
                         NextBlock := NextBlock + Main.SESLabIO.ADCNumChannels ;
                         end ;
                      end
                   else begin
                      // End of multi-channel sample block is even
                      if (ADC^[NextBlock] = EmptyFlag) and
                         (ADC^[NextBlock-1] = -EmptyFlag) then Done := True
                      else begin
                         i0 := NumBlocksDone*Main.SESLabIO.ADCNumChannels ;
                         i1 :=  i0 + Main.SESLabIO.ADCNumChannels - 1 ;
                         for i := i0 to i1 do ADCDisplay^[i] := ADC^[i] ;
                         Inc(NumBlocksDone) ;
                         NextBlock := NextBlock + Main.SESLabIO.ADCNumChannels ;
                         end ;
                      end ;
                   // Exit loop if at end of buffer
                   if NextBlock > EndOfBuf then Done := True ;
                   end ;

               // Determine if all samples have been acquired
               if ADC[EndOfBuf] <> -EmptyFlag then Inc(EndOfSweepCount) ;
               if ADC[EndOfBuf-1] <> EmptyFlag then Inc(EndOfSweepCount) ;
               if EndOfSweepCount >= 2 then EndOfSweep := True ;

               { Erase old display now that new sweep has started }
               if (NextBlock >= (2*Main.SESLabIO.ADCNumChannels)) and NewSweep then begin
                   // Get time of start of sweep
                   RH.Time := GetTickCount*mStoSecs ;
                   if WCPFile.RawFH.NumRecords <= 0 then begin
                      WCPFile.RawFH.RecordingStartTime := Main.DateToStr(Now) ;
                      WCPFile.RawFH.RecordingStartTimeSecs := RH.Time ;
                      end;

                   { Erase display once sweep has started (if required) }
                   scDisplay.SetDataBuf( ADCDisplay ) ;
                   scDisplay.NumPoints := 0 ;

//                   scDisplay.TScale := Main.SESLabIO.ADCSamplingInterval*WCPFile.Settings.TScale ;
//                   1.3.17 Removed because it was changing display scaling slightly between
//                   and during sweeps with some lab. interfaces

                   if (not scDisplay.StorageMode) or
                      (Abs(Main.SESLabIO.ADCSamplingInterval - rH.dt) > 1E-5) or
                      EraseScreen then scDisplay.Invalidate ;

                   EraseScreen := False ;
                   NewSweep := False ;
                   end ;

               { Display sample record on screen}
               if NumBlocksDone > (2*Main.SESLabIO.ADCNumChannels) then
                  scDisplay.DisplayNewPoints( NumBlocksDone-1 ) ;

               { End of sweep processing }
               if EndOfSweep then begin
    //              t0 := timegettime ;

                   if Main.SESLabIO.DACActive then begin
                     Main.SESLabIO.DACStop ;
                     end ;

                  { Stop A/D conversion ... unless in detect event mode }
                  if cbRecordingMode.ItemIndex <> rmDetect then begin
                     Main.SESLabIO.ADCStop ;
                     end ;

                  { Save sweep data to file }
                  SaveSweep ;

                  scDisplay.RecordNumber := scDisplay.RecordNumber + 1 ;

                  // If Dynamic clamp in use, inform it that a record has been collected
                  if Main.FormExists('DCLAMPFrm') then DCLAMPAction := DCL_NextRecord ;

                  { If in repeated sweep modes request another sweep
                    (unless recording aborted by user) }


                  if AbortRecording then begin
                     StopADCandDAC ;
                     end
                  else if cbRecordingMode.ItemIndex = rmProtocol then begin
                     { Voltage pulse mode }

                     // Increment to next waveform
                     Stimulator.NextWaveform ;

                     if Stimulator.EndOfProtocol then begin

                        // If Dynamic clamp in use, update to next Gmax value
                        if Main.FormExists('DCLAMPFrm') then DCLAMPAction := DCL_NextProtocol ;

                        // Update channel scaling factors in case amplifier gain has changed
                        UpdateChannelSettings ;

                        { If at the end of the current set of voltage pulses
                          for the current protocol either load and begin
                          the next protocol in a linked sequence or list OR
                          stop recording if no new protocol available }
                        if LoadStimulusProtocol(False) then begin
                           if CheckNewdataFileNeeded then StartSweep
                                                     else StopADCandDAC ;
                           end
                        else StopADCandDAC ;
                        end
                     else StartSweep ;
                     end
                  else begin
                     { Other modes }
                     Inc(NumRecordsDone) ;
                     if (NumRecordsDone >= WCPFile.Settings.NumRecordsRequired) then StopADCandDAC
                                                                        else StartSweep ; ;
                     end ;
                  end ;

               End ;


          Idle : begin

              { ** Procedures when recording is in idle mode ** }

              if (edNumRecords.text = '')
                 and (cbRecordingMode.ItemIndex <> rmProtocol ) then
                 edNumRecords.text := IntToStr( WCPFile.Settings.NumRecordsRequired ) ;

              // Update channel scaling factors in case amplifier gain has changed
              UpdateChannelSettings ;

              if not Main.FormExists( 'RecPlotFrm' ) and bCloseOLAWindow.Enabled then begin
                 bCloseOLAWindow.Click ;
                 end ;

              end ;

          end ;

        case DCLAMPAction of
             DCL_Initialise : begin
               DCLAMPFrm.Initialise ;
               DCLAMPAction := DCL_None ;
               end;
             DCL_NextRecord : Begin
               DCLAMPFrm.NextRecord ;
               DCLAMPAction := DCL_None ;
               end;
             DCL_NextProtocol : Begin
               DCLAMPFrm.NextProtocol ;
               DCLAMPAction := DCL_None ;
               end;
             end;

        UpdateStopwatch ;
        TimerBusy := False ;
        if (Main.SESLabIO.StimulusStartFlag = True) and
           (not Main.SESLabIO.DACActive) and
           (not bRecord.enabled) then begin
//           outputdebugstring(pchar('stimulus started'));
           Main.SESLabIO.StartStimulus ;
           end ;

        if not bOpenOLAWindow.Enabled then begin
           if not Main.FormExists( 'RecPlotFrm' ) then bCloseOLAWindow.Click ;
           end ;

        // Display stimulus protocol status
        if NOT bRecord.Enabled and (Main.SESLabIO.ADCTriggerMode = tmWaveGen) then begin
           Inc(StatusCounter) ;
           if (StatusCounter >= 10) and (Main.SesLabIO.TimerPeriod >= 0.0) then begin
              edStatus.text := format( 'Rec %d %s (Next stim. %.1f/%.1fs)',
                                      [WCPFile.RawFH.NumRecords,
                                       Stimulator.ProtocolStatus,
                                       Main.SesLabIO.TimerTime,Main.SesLabIO.TimerPeriod ]) ;
              StatusCounter := 0 ;
              end;
           end ;
        end ;
     end ;


procedure TRecordFrm.StartSweep ;
// ----------------------------
// Start A/D acquisition sweep
// ----------------------------
var
    ch : Integer ;
begin

     { Start recording sweep }

     // Set A/D acquisition mode

     case cbRecordingMode.ItemIndex of

        // Detect events mode
        rmDetect : begin
          InitialiseEventDetector ;
          WCPFile.RawFH.NumSamples := WCPFile.Settings.NumSamples ;
          end ;

        // Pulse generation mode
        rmProtocol : begin
          Main.SESLabIO.GetADCBuffer( ADC ) ;
          if Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
          Main.SESLabIO.ADCTriggerMode := tmWaveGen ;
          Main.SESLabIO.ADCExternalTriggerActiveHigh := False ;
          // Set A/D and D/A update intervals
          Main.SESLabIO.ADCNumChannels := Stimulator.Prot.NumADCChannels ;
          Main.SESLabIO.ADCNumSamples := Stimulator.Prot.NumADCSamplesPerChannel ;
          Stimulator.SetADCDACUpdateIntervals( Stimulator.Prot ) ;

          //Stimulator.Prot.RecordDuration := Main.SESLabIO.ADCNumSamples*Main.SESLabIO.ADCSamplingInterval ;
          // Removed 15.6.12
          Main.SESLabIO.ADCCircularBuffer := False ;
          EndofBuf := (Main.SESLabIO.ADCNumSamples*Main.SESLabIO.ADCNumChannels) - 1;
          WCPFile.RawFH.NumSamples := Main.SESLabIO.ADCNumSamples ;
          Main.SESLabIO.ADCStart ;
          end ;

        // Wait for external trigger
        rmExtTrig : begin
          Main.SESLabIO.GetADCBuffer( ADC ) ;
          if Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
          Main.SESLabIO.ADCTriggerMode := tmExtTrigger ;
          Main.SESLabIO.ADCExternalTriggerActiveHigh := rbExtTriggerHigh.checked ;
          Main.SESLabIO.ADCNumChannels := WCPFile.Settings.NumChannels ;
          Main.SESLabIO.ADCNumSamples := WCPFile.Settings.NumSamples ;
          Main.SESLabIO.ADCSamplingInterval := WCPFile.Settings.RecordDuration / WCPFile.Settings.NumSamples ;
          Main.SESLabIO.ADCCircularBuffer := False ;
          EndofBuf := (Main.SESLabIO.ADCNumSamples*Main.SESLabIO.ADCNumChannels) - 1;
          WCPFile.RawFH.NumSamples := Main.SESLabIO.ADCNumSamples ;
          Main.SESLabIO.ADCStart ;
          end ;

        // Free run mode
        else begin
          Main.SESLabIO.GetADCBuffer( ADC ) ;
          if Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
          Main.SESLabIO.ADCTriggerMode := tmFreeRun ;
          Main.SESLabIO.ADCNumChannels := WCPFile.Settings.NumChannels ;
          Main.SESLabIO.ADCNumSamples := WCPFile.Settings.NumSamples ;
          Main.SESLabIO.ADCSamplingInterval := WCPFile.Settings.RecordDuration / WCPFile.Settings.NumSamples ;
          WCPFile.RawFH.NumSamples := Main.SESLabIO.ADCNumSamples ;
          Main.SESLabIO.ADCCircularBuffer := False ;
          EndofBuf := (Main.SESLabIO.ADCNumSamples*Main.SESLabIO.ADCNumChannels) - 1;
          WCPFile.RawFH.NumSamples := Main.SESLabIO.ADCNumSamples ;
          Main.SESLabIO.ADCStart ;
          end ;

        end ;

     // Initialise recording sweep pointers/flags
     NextBlock := (2*Main.SESLabIO.ADCNumChannels)-1 ;
     NumBlocksDone := 0 ;
     EndOfSweepCount := 0 ;
     NewSweep := True ;
     EndOfSweep := False ;

     // Update file header information

     WCPFile.RawFH.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     WCPFile.RawFH.MinADCValue := -WCPFile.RawFH.MaxADCValue -1 ;

     WCPFile.RawFH.NumChannels := Main.SESLabIO.ADCNumChannels ;
     WCPFile.RawFH.NumSamplesPerRecord := WCPFile.RawFH.NumSamples*WCPFile.RawFH.NumChannels ;
     WCPFile.RawFH.NumDataBytesPerRecord := WCPFile.RawFH.NumSamplesPerRecord*2 ;
     WCPFile.RawFH.NumBytesPerRecord := WCPFile.RawFH.NumDataBytesPerRecord + WCPFile.NumAnalysisBytesPerRecord(WCPFile.RawFH.NumChannels) ;
     WCPFile.RawFH.NumBytesInHeader := WCPFile.NumBytesInFileHeader(WCPFile.RawFH.NumChannels) ;
     WCPFile.RawFH.ADCVoltageRange := Main.SESLabIO.ADCVoltageRange ;
     WCPFile.RawfH.dt := Main.SESLabIO.ADCSamplingInterval ;
     scDisplay.TScale := Main.SESLabIO.ADCSamplingInterval*WCPFile.Settings.TScale ;

     // Update file channel settings with recording settings
     for ch := 0 to Main.SESLabIO.ADCNumChannels-1 do begin
        WCPFile.Channel[ch].ADCName := Main.SESLabIO.ADCChannelName[ch] ;
        WCPFile.Channel[ch].ChannelOffset := Main.SESLabIO.ADCChannelOffset[ch] ;
        WCPFile.Channel[ch].ADCUnits := Main.SESLabIO.ADCChannelUnits[ch] ;
        WCPFile.Channel[ch].ADCCalibrationFactor := Main.SESLabIO.ADCChannelVoltsPerUnit[ch] ;
        WCPFile.Channel[ch].ADCAmplifierGain := Main.SESLabIO.ADCChannelGain[ch] ;
        WCPFile.Channel[ch].ADCZero := Main.SESLabIO.ADCChannelZero[ch] ;
        WCPFile.Channel[ch].InUse := Main.SESLabIO.ADCChannelVisible[ch] ;
        WCPFile.Channel[ch].yMin := Main.SESLabIO.ADCChannelYMin[ch] ;
        WCPFile.Channel[ch].yMax := Main.SESLabIO.ADCChannelYMax[ch] ;
        end ;

     if not bOpenOLAWindow.Enabled then begin
        scDisplay.VerticalCursors[C0Cursor] := Round(WCPFile.Settings.RecPlot.Cursor0*scDisplay.MaxPoints) ;
        scDisplay.VerticalCursors[C1Cursor] := Round(WCPFile.Settings.RecPlot.Cursor1*scDisplay.MaxPoints) ;
        scDisplay.VerticalCursors[C2Cursor] := Round(WCPFile.Settings.RecPlot.Cursor2*scDisplay.MaxPoints) ;
        scDisplay.VerticalCursors[C3Cursor] := Round(WCPFile.Settings.RecPlot.Cursor3*scDisplay.MaxPoints) ;
        scDisplay.VerticalCursors[C4Cursor] := Round(WCPFile.Settings.RecPlot.Cursor4*scDisplay.MaxPoints) ;
        end ;

     { Start voltage/digital output program (if needed) }
     if cbRecordingMode.ItemIndex = rmProtocol then StartVoltageProgram
     else begin
         edStatus.text := format( 'Rec %d ( %d/%d ) ',
                          [WCPFile.RawFH.NumRecords,
                           NumRecordsDone,WCPFile.Settings.NumRecordsRequired] ) ;
         Main.StatusBar.Panels[0].Text :=  edStatus.Text ;
         Main.SESLabIO.StimulusStartFlag := False ;
         end ;

     State := SweepInProgress ;
     EndofSweep := False ;

     end ;


procedure TRecordFrm.StopADCandDAC ;
// --------------------
// Stop recording sweep
// --------------------
var
    ch : Integer ;
begin
    { Stop recording and return to idle state }

    if Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
    if Main.SESLabIO.DACActive then Main.SESLabIO.DACStop ;

    { Return voltage command to holding voltage and Sync. O/P to OFF }
    for ch := 0 to Main.SESLabIO.DACMaxChannels-1 do
        Main.SESLabIO.DACHoldingVoltage[ch] := Main.SESLabIO.DACHoldingVoltage[ch] ;
    Main.SESLabIO.DIGHoldingLevel := Main.SESLabIO.DIGHoldingLevel ;

    RestoreIdleState ;

    // If Dynamic clamp in use, Reset to initial settings
    if Main.FormExists('DCLAMPFrm') then DCLAMPAction := DCL_Initialise ;

    end ;


procedure TRecordFrm.RestoreIdleState ;
{ --------------------------------------
  Restore recording module to idle state
  -------------------------------------- }
begin

     { Disable A/D and D/A sub-systems and restore default outputs }
     ShutDownLabInterface ;

     if State <> Idle then begin
        edStatus.font.color := clBlack ;
        edStatus.text := format( 'Stopped %d records in file',
                                [WCPFile.RawFH.NumRecords] ) ;
        Main.StatusBar.Panels[0].Text :=  edStatus.Text ;

        WCPFile.WriteToLogFile( format('Stopped (%d records)',[WCPFile.RawFH.NumRecords])) ;

        State := Idle ;
        bRecord.enabled := True ;
        bStop.enabled := False ;
        RecordParametersPanel.Enabled := True ;
        Main.SetMenus ;

        if WCPFile.RawFH.NumRecords > 0 then Main.mnShowRaw.enabled := True ;
        WCPFile.RawFH.IdentLine := edIdent.text ;

        { Save header block }
        WCPFile.SaveHeader( WCPFile.RawfH ) ;
        { Set file header in use to raw file header }
        WCPFile.FH := WCPFile.RawFH ;
        WCPFile.GetHeader(WCPFile.fH) ;

        // Restore pulse program selected when recording started
        if cbPulseProgram.ItemIndex < cbPulseProgram.Items.Count then
           cbPulseProgram.ItemIndex := StartingPulseProgramIndex ;

        end ;

     end ;


procedure TRecordFrm.InitialiseEventDetector ;
{ -------------------------
  Initialise event detector
  ------------------------- }
var
   i,j : Integer ;
begin

     if not Main.SESLabIO.ADCActive then begin

        { Get pointer to A/D input buffer }
        Main.SESLabIO.GetADCBuffer( ADCCircular ) ;

        { Set up continuous sampling into a circulating buffer, ensuring
          that it is a multiple of the no. of channels
          Note that buffer size may vary with different lab. interfaces }
//        Det.EndofBuf := Min( WCPFile.Settings.NumSamples*WCPFile.Settings.NumChannels*4,
//                             Main.SESLabIO.ADCBufferLimit)  ;
        Det.EndofBuf := ((Main.SESLabIO.ADCBufferLimit div WCPFile.Settings.NumChannels)*WCPFile.Settings.NumChannels) - 1 ;
        if  ADCDetected = Nil then FreeMem(ADCDetected) ;
        GetMem(ADCDetected, (Det.EndofBuf+1)*2 ) ;
        ADC := ADCDetected ;
        if  ADCCopy = Nil then FreeMem(ADCCopy) ;
        GetMem(ADCCopy, (Det.EndofBuf+1)*2 ) ;

        { Set channel counter }
        Det.LastChan := WCPFile.Settings.NumChannels - 1 ;
        Det.Chan := 0 ;
        Det.ChanSelected := Main.SESLabIO.ADCChannelOffset[cbDetectChannel.ItemIndex] ;

        { Set event detection threshold and polarity }
        WCPFile.Settings.EventDetector.Threshold := edDetectionThreshold.Value ;
        Det.Threshold := Round( 2.0*Main.SESLabIO.ADCMaxValue
                                *WCPFile.Settings.EventDetector.Threshold ) ;
        if Det.Threshold >= 0 then begin
           Det.Polarity := 1 ;
           { Note ... baseline set to maximum value to prevent
           event triggering when the recording starts }
           Det.Baseline := Main.SESLabIO.ADCMaxValue ;
           end
        else begin
           Det.Polarity := -1 ;
           Det.Baseline := -(Main.SESLabIO.ADCMaxValue + 1) ;
           end ;
        Det.Threshold := Abs(Det.Threshold) ;

        { Initialise sample pointer }
        Det.Pointer := 0 ;
        { Number of pre-trigger points }
        WCPFile.Settings.EventDetector.PreTrigger := edPreTrigger.Value ;
        Det.PreTriggerPoints :=  Round ( WCPFile.Settings.NumSamples*WCPFile.Settings.EventDetector.PreTrigger
                                         *WCPFile.Settings.NumChannels ) ;

        { Start continous sampling into circular buffer }

        //if  Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
        Main.SESLabIO.ADCNumChannels := WCPFile.Settings.NumChannels ;
        Main.SESLabIO.ADCNumSamples := (Det.EndofBuf+1) div WCPFile.Settings.NumChannels ;
        Main.SESLabIO.ADCSamplingInterval := WCPFile.Settings.RecordDuration / WCPFile.Settings.NumSamples ;
        Main.SESLabIO.ADCTriggerMode := tmFreeRun ;
        Main.SESLabIO.ADCCircularBuffer := True ;
        Main.SESLabIO.ADCStart ;
        end ;

     { Initialise O/P buffer with empty flag }
     j := 0 ;
     for i := 1 to (WCPFile.Settings.NumChannels*WCPFile.Settings.NumSamples) div 2 do begin
         ADCDetected^[j] := EmptyFlag ;
         Inc(j) ;
         ADCDetected^[j] := -EmptyFlag ;
         Inc(j) ;
         end ;

     Det.EventDetected := False ;
     end ;


procedure TRecordFrm.DetectEvent ;
{ ---------------------------------------
  Monitor circular A/D buffer for signals
  --------------------------------------- }
var
   PointerPlus1,iY,i,j,EFlag : Integer ;
   Done : Boolean ;
begin

     Main.SESLabIO.ADCBufferRefresh ;

     { Scan circular A/D buffer for an event }

     { Initialise pointers }
     PointerPlus1 := Det.Pointer + 1 ;
     if PointerPlus1 > Det.EndOfBuf then PointerPlus1 := 0 ;

     if Odd(PointerPlus1) then EFlag := -EmptyFlag
                          else EFlag := EmptyFlag ;
     if ADCCircular^[PointerPlus1] = EFlag then Done := True
                                           else Done := False ;

     { Check new A/D samples in buffer }
     while not Done do begin
        { Extract sample from A/D data buffer }
        iY := ADCCircular^[Det.Pointer] ;
        ADCCopy^[Det.Pointer] := iY ;
        if Odd(Det.Pointer) then ADCCircular^[Det.Pointer] := -EmptyFlag
                            else ADCCircular^[Det.Pointer] := EmptyFlag ;

        if not Det.EventDetected then begin

           { No event detected yet ... check sample against threshold }
           if Det.Chan = Det.ChanSelected then begin
              if Det.Polarity*(iY - Det.Baseline) > Det.Threshold then begin
                 { Event detected ... Store location/time of detected event }
                 Det.EventDetected := True ;
                 { Get segment of buffer to be extracted }
                 Det.StartAt := Det.Pointer - Det.PreTriggerPoints ;
                 if Det.StartAt < 0 then Det.StartAt := Det.StartAt + (Det.EndofBuf+1) ;
                 Det.StartAt := (Det.StartAt div WCPFile.Settings.NumChannels)*WCPFile.Settings.NumChannels ;
                 Det.EndAt := Det.StartAt + WCPFile.Settings.NumSamples*WCPFile.Settings.NumChannels -1 ;
                 if Det.EndAt > Det.EndofBuf then Det.EndAt := Det.EndAt - (Det.EndofBuf+1) ;
                 { Time of detection }
                 Det.TimeDetected := Det.BufferCycles ;
                 Det.TimeDetected := Main.SESLabIO.ADCSamplingInterval *((Det.TimeDetected*(Det.EndOfBuf+1)
                                     + Det.Pointer ) / WCPFile.Settings.NumChannels) ;
                 end ;
              end ;
           end
        else begin
           { Event detected ... Wait till all samples have been collected,
                                then transfer the samples to ADC buffer }
           if Det.Pointer = Det.EndAt then begin
               j := Det.StartAt ;
               for i := 0 to (WCPFile.Settings.NumSamples*WCPFile.Settings.NumChannels)-1 do begin
                   ADCDetected^[i] := ADCCopy^[j] ;
                   Inc(j) ;
                   if j > Det.EndOfBuf then j := 0 ;
                   end ;
               Det.EventDetected := False ;
               Done := True ;
               end ;
           end ;

        { Update baseline level with 30 point running mean }
        if Det.Chan = Det.ChanSelected then begin
           Det.Baseline := (iY + 30*Det.Baseline) div 31 ;
           end ;

        { Increment sample pointers }
        Inc( Det.Pointer ) ;
        if Det.Pointer > Det.EndofBuf then begin
           Inc(Det.BufferCycles) ;
           Det.Pointer := 0 ;
           Done := True ;
           end ;

        Inc( PointerPlus1 ) ;
        if PointerPlus1 > Det.EndofBuf then PointerPlus1 := 0 ;

        { Increment channel pointer }
        Inc(Det.Chan) ;
        if Det.Chan > Det.LastChan then Det.Chan := 0 ;

        { Exit loop if no samples left }
        if Odd(PointerPlus1) then EFlag := -EmptyFlag
                             else EFlag := EmptyFlag ;
        if ADCCircular^[PointerPlus1] = EFlag then Done := True ;

        end ;

     end ;


procedure TRecordFrm.StartVoltageProgram ;
{ ------------------------------------------------------------
  Create and output a voltage/digital program to D/A converter
  ------------------------------------------------------------ }
var
    NumAOChannels : Integer ;
begin

     { Show which step/repeat is being recorded }

     Main.StatusBar.Panels[0].Text := edStatus.Text ;

     if OldStepCounter <> Stimulator.Increment then Inc(GroupNumber) ;
     OldStepCounter := Stimulator.Increment ;

     if Stimulator.LeakRecord then begin
        // Create leak waveform
        edStatus.text := format( 'Rec %d %s',
                                 [WCPFile.RawFH.NumRecords,
                                 Stimulator.ProtocolStatus ]) ;
        NumAOChannels :=  Min( Stimulator.Prot.NumAOChannels,
                               Main.SESLabIO.DACMaxChannels ) ;
        Main.SESLabIO.DACNumSamples := Stimulator.CreateWaveform( DAC^,
                                                                  DigBuf^,
                                                                  NumAOChannels ) ;
        Main.SESLabIO.DACUpdateInterval := Stimulator.DACUpdateInterval ;
        Main.SESLabIO.DACNumSamples := Stimulator.CreateLeakWaveform( DAC^, NumAOChannels ) ;
        Main.SESLabIO.DigitalStimulusEnabled := False ;
        end
      else begin
        // Create TEST voltage program waveform
        edStatus.text := format( 'Rec %d %s',
                                 [WCPFile.RawFH.NumRecords,
                                 Stimulator.ProtocolStatus ]) ;
        NumAOChannels :=  Min( Stimulator.Prot.NumAOChannels,
                               Main.SESLabIO.DACMaxChannels ) ;
        Main.SESLabIO.DACNumSamples := Stimulator.CreateWaveform( DAC^,
                                                                  DigBuf^,
                                                                  NumAOChannels ) ;
        Main.SESLabIO.DACUpdateInterval := Stimulator.DACUpdateInterval ;
        Main.SESLabIO.DigitalStimulusEnabled := Stimulator.DigitalOutputsInUse ;
        end ;

     { Set up D/A conversion  }
     Main.SESLabIO.DACNumChannels := NumAOChannels ;
     { Set voltage stimulus pulse interval }
     if Stimulator.Prot.ExtTrigger then begin
        // Externally triggered stimuli
        Main.SESLabIO.TimerPeriod := StimulusExtTriggerFlag ;
        end
     else begin
        // Periodic stimuli
        Main.SESLabIO.TimerPeriod := Stimulator.Prot.StimulusPeriod ;
        end ;
     Main.StatusBar.Panels[1].Text := '' ;

     if not Main.SESLabIO.TimerActive then begin
        Main.SESLabIO.StartTimer ;
        end ;

     end ;


procedure TRecordFrm.ShutDownLabInterface ;
{ ---------------------------------------------
  Shut down A/D, D/A and digital O/P subsystems
  ---------------------------------------------}
var
    ch : Integer ;
begin

     { Stop periodic stimulus pulse timer }
     Main.SESLabIO.StopTimer ;

     { Disable A/D }
     if  Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;

     { Disable D/A waveform generation }
     if Main.SESLabIO.DACActive then Main.SESLabIO.DACStop ;

     { Return voltage command to holding voltage and Sync. O/P to 5V }
    { Return voltage command to holding voltage and Sync. O/P to OFF }
    for ch := 0 to Main.SESLabIO.DACMaxChannels-1 do
        Main.SESLabIO.DACHoldingVoltage[ch] := Main.SESLabIO.DACHoldingVoltage[ch] ;
    Main.SESLabIO.DIGHoldingLevel := Main.SESLabIO.DIGHoldingLevel ;

    Main.SESLabIO.ADCNumSamples := WCPFile.Settings.NumSamples ;
    MainMenus( Enable ) ;
    end ;


procedure TRecordFrm.SaveSweep ;
{ ---------------------------
  Save recording sweep to file
  --------------------------- }
var
   ch,i,j,i0,i1,NumAvg,iStart : Integer ;
   Done,SaveRecord,EmptyRecord : Boolean ;
   ZeroSum : Single ;

begin
     { Replace any Empty flags in the buffer with the most recently
       recorded sample for that channel }
     Done := False ;
     i := EndOfBuf ;
     while (not Done) do begin
        if (ADC^[i] = -EmptyFlag) and (ADC^[i-1] = EmptyFlag) then i := i - 2
                                                              else Done := True ;
        if i < 1 then Done := True ;
        end ;
     if i < (EndOfBuf div 10) then  EmptyRecord := True
                              else  EmptyRecord := False ;


     if i < EndofBuf then begin
        iStart := ((i - WCPFile.Settings.NumChannels) div Main.SESLabIO.ADCNumChannels)*Main.SESLabIO.ADCNumChannels ;
        iStart := Max(iStart,0) ;
        for i := iStart to EndOfBuf do
            ADC^[i] := ADC^[iStart + (i mod Main.SESLabIO.ADCNumChannels)] ;
        end ;

     { Special processing if this is a leak current record }
     if Stimulator.LeakRecord then begin

        // Clear leak average if first leak record
        if Stimulator.RepeatCounter = 0 then begin
           if LeakSum <> Nil then FreeMem(LeakSum) ;
           GetMem( LeakSum, (EndOfBuf+1)*4 ) ;
           for i := 0 to EndOfBuf do LeakSum^[i] := 0 ;
           end;

        // Add leak record to average
        if LeakSum <> Nil then begin
           for i := 0 to EndOfBuf do LeakSum^[i] := LeakSum^[i] + ADC^[i] ;
           end;

        // Calculate average leak record (and request to be saved)
        if Stimulator.RepeatCounter >= Abs(Stimulator.Prot.NumLeakSubtractionRecords)-1 then begin
           NumAvg := Max( Stimulator.Prot.NumLeakSubtractionRecords,1 ) ;
           if LeakSum <> Nil then begin
              for i := 0 to EndOfBuf do ADC^[i] := LeakSum^[i] div NumAvg ;
              end;
           rH.RecType := 'LEAK' ;
           SaveRecord := True ;
           FreeMem(LeakSum) ;
           LeakSum := Nil ;
           end
        else SaveRecord := False ;
        end
     else begin
        rH.RecType := 'TEST' ;
        SaveRecord := True ;
        end ;

     { *** Save data to file *** (unless in leak mode) }
     if SaveRecord and (not EmptyRecord) then begin

       //   UpdateChannelSettings (removed to reduce inter-sweep dead time);
       // Update record voltage range to reflect gain change in amplifier
        for ch := 0 to  Main.SESLabIO.ADCNumChannels-1 do
            RH.ADCVoltageRange[ch] := Main.SESLabIO.ADCVoltageRange /
                                      Main.SESLabIO.ADCChannelGain[ch] ;

        WCPFile.RawfH.NumRecords := WCPFile.RawfH.NumRecords + 1 ;
        WCPFile.RawFH.CurrentRecord := WCPFile.RawFH.NumRecords ;
        rH.Status := 'ACCEPTED' ;
        if cbRecordingMode.itemIndex = rmProtocol then rH.Number := GroupNumber
                                                  else rH.Number := WCPFile.RawfH.NumRecords ;
        rH.dt := Main.SESLabIO.ADCSamplingInterval ;

        { Update time that record was collected }
        if cbRecordingMode.itemIndex = rmDetect then rH.Time := Det.TimeDetected ;

        { Make time relative to the first record acquired }
        rH.Time := rH.Time - WCPFile.RawFH.RecordingStartTimeSecs ;

        // If dynamic clamp in use, add conductance to record ident field.
        if Main.FormExists('DCLAMPFrm') then begin
           Rh.Ident := DCLAMPFrm.Status ; //format('Gmax=%.4g nS',[DCLAMPFrm.GMax]);
           end
        else begin
           // Add user-entered marker
           Rh.Ident := edmarker.Text ;
           scDisplay.ClearMarkers ;
           scDisplay.AddMarker( 0, EdMarker.text );
           end;

        rH.AnalysisAvailable := false ;
        rH.EqnType := None ;

        WCPFile.PutRecord( WCPFile.RawfH, rH, WCPFile.RawfH.NumRecords, ADC^ ) ;

        // Calculate zero levels
        for ch := 0 to  Main.SESLabIO.ADCNumChannels-1 do begin
            if Main.SESLabIO.ADCChannelZeroAt[ch] >= 0 then begin
               i0 := Min(Max( Main.SESLabIO.ADCChannelZeroAt[ch],0 ), Main.SESLabIO.ADCNumSamples-1 ) ;
               i1 := i0 + Main.SESLabIO.ADCChannelNumZero - 1 ;
               i1 := Min(Max( i1,0 ),Main.SESLabIO.ADCNumSamples-1 ) ;
               ZeroSum := 0 ;
               j := i0*Main.SESLabIO.ADCNumChannels + Main.SESLabIO.ADCChannelOffset[ch] ;
               for i := i0 to i1 do begin
                  ZeroSum := ZeroSum + ADC^[j] ;
                  j := j + Main.SESLabIO.ADCNumChannels ;
                  end;
               Main.SESLabIO.ADCChannelZero[ch] := Round( ZeroSum / (i1-i0+1) );
               scDisplay.HorizontalCursors[ch] := Main.SESLabIO.ADCChannelZero[ch] ;
               WCPFile.Channel[ch].ADCZero := Main.SESLabIO.ADCChannelZero[ch] ;
               end ;
            end ;

        rH.Ident := '' ;

        if (not ckSaveRecords.checked) then begin
              WCPFile.RawfH.NumRecords := WCPFile.RawfH.NumRecords - 1 ;
              edStatus.text := 'Records not saved!' ;
              Main.StatusBar.Panels[0].Text :=  edStatus.Text ;
              end ;

        if Main.FormExists( 'RecPlotFrm' ) and (not AbortRecording) then begin
           RecPlotFrm.UpdatePlot( ADC^,
                                  Round(scDisplay.VerticalCursors[C0Cursor]),
                                  Round(scDisplay.VerticalCursors[C1Cursor]),
                                  Round(scDisplay.VerticalCursors[C2Cursor]),
                                  Round(scDisplay.VerticalCursors[C3Cursor]),
                                  Round(scDisplay.VerticalCursors[C4Cursor]),
                                  cbPulseProgram.Text,
                                  WCPFile.RawfH.NumRecords,
                                  RH.RecType ) ;
           end ;

        // Update file header
        WCPFile.SaveHeader( WCPFile.RawfH ) ;

        // Update replay form if it is open
        if Main.FormExists('ReplayFrm') then begin
           Main.mnShowRaw.Click ;
           end ;

        end ;

     End ;


procedure TRecordFrm.UpdateChannelSettings ;
// ----------------------------------------------------------------------
// Update channel scaling factors in case amplifier gain/mode has changed
// ----------------------------------------------------------------------
var
    ch : Integer ;
    Changed : Boolean ;
    OldValue : Single ;
    OldUnits : String ;
    OldName : String ;
    Name,Units : string ;
    VPU,Gain : Single ;
    ADCInput : Integer ;
begin

     Changed := False ;
     for ch := 0 to Main.SESLabIO.ADCNumChannels-1 do begin

         OldValue := RH.ADCVoltageRange[ch] ;
         OldUnits := Main.SESLabIO.ADCChannelUnits[ch] ;
         OldName := Main.SESLabIO.ADCChannelName[ch] ;

         // Update channel scaling factors
         ADCInput := Main.SESLabIO.ADCChannelInputNumber[ch] ;
         Amplifier.GetChannelSettings( ch,Name,Units,VPU,Gain,ADCInput ) ;
         Main.SESLabIO.ADCChannelName[ch] := Name ;
         Main.SESLabIO.ADCChannelUnits[ch] := Units ;
         Main.SESLabIO.ADCChannelVoltsPerUnit[ch] := VPU ;
         Main.SESLabIO.ADCChannelGain[ch] := Gain ;
         Main.SESLabIO.ADCChannelInputNumber[ch] := ADCInput ;

         RH.ADCVoltageRange[ch] := Main.SESLabIO.ADCVoltageRange /
                                   Main.SESLabIO.ADCChannelGain[ch] ;

         if (OldValue <> RH.ADCVoltageRange[ch]) or
            (OldUnits <> Units ) or
            (OldName <> Name) then Changed := True ;

         end ;

     UpdateAmplifierGain ;

     // Update current/voltage clamp state
     DisplayClampMode ;

     // Update display readout scaling factors
     for ch := 0 to Main.SESLabIO.ADCNumChannels-1 do begin
         scDisplay.ChanScale[ch] := Main.SESLabIO.ADCChannelUnitsPerBit[ch] ;
         scDisplay.ChanUnits[ch] := Main.SESLabIO.ADCChannelUnits[ch] ;
         scDisplay.ChanName[ch] := Main.SESLabIO.ADCChannelName[ch] ;
         end ;

     // Force display display update if factors changed
     if Changed then scDisplay.Invalidate ;

     end ;


procedure TRecordFrm.UpdateAmplifierGain ;
// ------------------------------
// Update amplifier gain readouts
// ------------------------------
begin

    if panAmplifierGain0.Visible and
       (Amplifier.GainTelegraphAvailable[0] or NewAmplifierGain) then begin
       edAmplifierGain0.Units := 'V/' + Amplifier.PrimaryChannelUnits[0,Amplifier.ClampMode[0]] ;
       edAmplifierGain0.Value := Amplifier.PrimaryChannelScaleFactor[0] ;
       end ;

    if panAmplifierGain1.Visible and
       (Amplifier.GainTelegraphAvailable[1] or NewAmplifierGain) then begin
       edAmplifierGain1.Units := 'V/' + Amplifier.PrimaryChannelUnits[1,Amplifier.ClampMode[1]] ;
       edAmplifierGain1.Value := Amplifier.PrimaryChannelScaleFactor[1] ;
       end ;

    if panAmplifierGain2.Visible and
       (Amplifier.GainTelegraphAvailable[2] or NewAmplifierGain) then begin
       edAmplifierGain2.Units := 'V/' + Amplifier.PrimaryChannelUnits[2,Amplifier.ClampMode[2]] ;
       edAmplifierGain2.Value := Amplifier.PrimaryChannelScaleFactor[2] ;
       end ;

    if panAmplifierGain3.Visible and
       (Amplifier.GainTelegraphAvailable[3] or NewAmplifierGain) then begin
       edAmplifierGain3.Units := 'V/' + Amplifier.PrimaryChannelUnits[3,Amplifier.ClampMode[3]] ;
       edAmplifierGain3.Value := Amplifier.PrimaryChannelScaleFactor[3] ;
       end ;

     NewAmplifierGain := False ;

     end ;


procedure TRecordFrm.bRecordClick(Sender: TObject);
{ -----------------------
  Start recording sesson
  ----------------------- }
begin

     if Main.FormExists( 'SealTestFrm' ) then begin
        SealTestFrm.StopADCandDAC ;
        end ;

     // Update amplifier gains (in case they have been changed by user)
     UpdateAmplifierGains ;

     AbortRecording := False ;
     bRecord.Enabled := False ;
     bStop.Enabled := True ;
     edStatus.font.color := clRed ;
     RecordParametersPanel.Enabled := False ;

     // Keep current setting of pulse program list
     StartingPulseProgramIndex := cbPulseProgram.ItemIndex ;

     MainMenus( Disable ) ;

     WCPFile.WriteToLogFile( 'Recording Started ' ) ;

     // Update channel scaling factors in case amplifier gain has changed
     UpdateChannelSettings ;

     // Stop timer
     // (Forces a call to Main.SESLabIO.StartTimer in PulseProgram
     //  trigger mode which ensures first pulse is generated immediately)
     if Main.SESLabIO.TimerActive then Main.SESLabIO.StopTimer ;

     { Set number of recording sweeps to be collected }
     UpdateSamplingInterval ; // Ensure sampling interval is in supported range

     WCPFile.Settings.NumRecordsRequired := Round(edNumRecords.Value) ;
     WCPFile.Settings.NumChannels := Round(edNumChannels.Value) ;
     WCPFile.Settings.RecordDuration := edRecordDuration.Value ;
     WCPFile.Settings.NumSamples := Round(edNumSamples.Value) ;

     EndAtRecord := WCPFile.RawFH.NumRecords + WCPFile.Settings.NumRecordsRequired ;
     NumRecordsDone := 0 ;

     { Get last group number used }
     if WCPFile.RawFH.NumRecords > 0 then begin
        WCPFile.GetRecordHeaderOnly( WCPFile.RawfH, rH, WCPFile.RawfH.NumRecords ) ;
        GroupNumber := Round(rH.Number) + 1
        end
     else begin
        { Reset group number for a new file }
        GroupNumber := 1 ;
        {Set event detector buffer cycle count to zero
         when recording starts in a new file }
        Det.BufferCycles := 0 ;
        end ;

     { Load voltage program (if in Stimulus Protocol mode) }
     if cbRecordingMode.ItemIndex = rmProtocol then begin
        if not LoadStimulusProtocol( True ) then begin
           ShowMessage( ' No Stimulus Protocol - Recording Aborted! ' ) ;
           State := Idle ;
           bRecord.Enabled := True ;
           bStop.Enabled := False ;
           MainMenus( Enable ) ;
           Exit ;
           end ;
        OldStepCounter := 0 ;
        end ;

     // Update display with new settings
     UpdateDisplay(true) ;

     // Check if a new data file is need due to changes in data file record size
     // or calibration factors etc. and create file if required

     if not CheckNewDataFileNeeded then begin
        // Stop if unable to create file
        State := Idle ;
        bRecord.Enabled := True ;
        bStop.Enabled := False ;
        MainMenus( Enable ) ;
        Exit ;
        end ;

     // If Dynamic clamp in use, Select first Gmax value in sequence
     if Main.FormExists('DCLAMPFrm') then begin
  //      DCLAMPFrm.Initialise ;
        end;

     StartSweep ;

     if State = Idle then begin
        bRecord.Enabled := True ;
        bStop.Enabled := False ;
        MainMenus( Enable ) ;
        end ;

     StatusCounter := 0 ;
     //scDisplay.RecordNumber := 0 ;
     end;


function TRecordFrm.LoadStimulusProtocol(
         Initialise : Boolean              // True = Initialise protocol counter
         ) : Boolean ;
// ----------------------
// Load stimulus protocol
// ----------------------
begin

    if Initialise then ProtocolCount := 0 ;

    Result := False ;

    if rbSingleProtocol.Checked then begin
       // Load a single protocol (or subsequent linked protocols)
       if ProtocolCount < 1 then begin
          // Load initial protocol from list
          ProtocolFileName := cbPulseProgram.Text ;
          WCPFile.Settings.VProgramFileName := UpdateVProgramFileName(ProtocolFileName) ;
          end
       else begin
          // Load linked protocol (if it exists)
          ProtocolCount := 0 ;
          ProtocolFileName := WCPFile.ExtractFileNameOnly(Stimulator.Prot.NextProtocolFileName) ;
          if FileExists(UpdateVProgramFileName(ProtocolFileName)) then begin
             if Main.SESLabIO.DACActive then Main.SESLabIO.DACStop ;
             end
          else ProtocolFileName := '' ;
          end ;
       end
    else begin
       // Get protocol from execution list
       if ProtocolCount < meProtocolList.Lines.Count then begin
          ProtocolFileName := meProtocolList.Lines[ProtocolCount] ;
          end
       else ProtocolFileName := ''
       end ;

    if (ProtocolFileName = '') or (ProtocolFileName = ' ') then begin
       Exit ;
       end ;

    ProtocolFileName := UpdateVProgramFileName(ProtocolFileName) ;

    if FileExists( ProtocolFileName ) then begin
       Stimulator.LoadProtocol(ProtocolFileName) ;
       WCPFile.WriteToLogFile( 'Stimulus Protocol: ' + ProtocolFileName ) ;
       Result := True ;
       end
    else Exit ;

    Inc( ProtocolCount ) ;

    end ;


function TRecordFrm.CheckNewDataFileNeeded : Boolean ;
// ------------------------------------------------------------
// Check record size and created a new file if size has changed
// ------------------------------------------------------------
var
    NewFileNeeded : Boolean ;
    ch,iNum,n : Integer ;
    NewFileName,StimName,Stem : String ;

begin

     Result := True ;

     if WCPFile.RawFH.FileHandle <= 0 then begin
        // Create a new file if none open
        WCPFile.CreateNewDataFile( WCPFile.CreateIndexedFileName( WCPFile.RawFH.FileName )) ;
        end ;

     if ckNewFileOnRecord.Checked then begin
        // Create a new file (with stimulus protocol/sequence no. appended)
        // ----------------------------------------------------------------
        if cbRecordingMode.ItemIndex = rmProtocol then
           StimName := WCPFile.ExtractFileNameOnly(Stimulator.FileName) + '.'
        else StimName := '' ;

        // Extract stem of file name
        Stem := ANSIReplaceText( WCPFile.RawFH.FileName, '.wcp', '.' ) ;
        n := Pos( '.', Stem ) ;
        if n > 0 then Stem := LeftStr(Stem,n) ;

        iNum := 1 ;
        repeat
           NewFileName := Stem + StimName + format('%d.wcp',[iNum]) ;
           Inc(iNum) ;
           until not FileExists(NewFileName) ;

        // Delete existing data file if it is empty
        if (WCPFile.RawFH.NumRecords = 0) and (WCPFile.RawFH.FileHandle >= 0) then begin
           FileClose( WCPFile.RawFH.FileHandle ) ;
           WCPFile.RawFH.FileHandle := -1 ;
           DeleteFile( PChar(WCPFile.RawFH.FileName) ) ;
           end ;

        WCPFile.CreateNewDataFile( NewFileName ) ;

        end
     else begin
        // Create a new file if recording settings have changed
        // --------------------------------------------------
        NewFileNeeded := False ;

        if WCPFile.RawFH.NumChannels <> Main.SESLabIO.ADCNumChannels then NewFileNeeded := True ;
        if WCPFile.RawFH.NumSamples <> Main.SESLabIO.ADCNumSamples then NewFileNeeded := True ;
        for ch := 0 to Main.SESLabIO.ADCNumChannels-1 do begin
            if WCPFile.Channel[ch].ADCName <> Main.SESLabIO.ADCChannelName[ch] then NewFileNeeded := True ;
            if WCPFile.Channel[ch].ADCUnits <> Main.SESLabIO.ADCChannelUnits[ch] then NewFileNeeded := True ;
            if (Abs(WCPFile.Channel[ch].ADCCalibrationFactor/Main.SESLabIO.ADCChannelVoltsPerUnit[ch])-1.0)
               > 1.0E-4 then NewFileNeeded := True ;
            end ;
        if WCPFile.RawFH.NumRecords <= 0 then NewFileNeeded := False ;

        if NewFileNeeded then begin

           // Extract stem of file name
           Stem := ANSIReplaceText( WCPFile.RawFH.FileName, '.wcp', '.' ) ;
           n := Pos( '.', Stem ) ;
           if n > 0 then Stem := LeftStr(Stem,n) ;

           n := 1 ;
           repeat
              NewFileName := Stem + format('%d.wcp',[n]) ;
              Inc(n) ;
              until not FileExists(NewFileName) ;
           WCPFile.CreateNewDataFile( NewFileName ) ;
           end ;
        end ;

     UpdateDisplay(false) ;

     Main.UpdateRecentFilesList ;

     end ;


procedure TRecordFrm.FormResize(Sender: TObject);
{ ------------------------------------------
  Adjust components when display is re-sized
  ------------------------------------------ }
begin

     ckFixedZeroLevels.Top := ClientHeight - ckFixedZeroLevels.Height - 5 ;
     edStatus.Top := ckFixedZeroLevels.Top - EdStatus.Height - 2 ;
     TimerGrp.Top := ClientHeight - TimerGrp.Height - 5 ;

     OnLineAnalysisGrp.Top := TimerGrp.Top - OnLineAnalysisGrp.Height - 2 ;

     DisplayGrp.Top := OnLineAnalysisGrp.Top - DisplayGrp.Height - 2 ;

     RecordModeGrp.Height := Max(DisplayGrp.Top - RecordModeGrp.Top - 2,2) ;

     scDisplay.Height := Max( edStatus.Top - scDisplay.Top  - 5, 2) ;
     scDisplay.Width := Max( ClientWidth - scDisplay.Left - 5, 2)  ;

     // Adjust width of ident boxes to match display area
     edIdent.Width := scDisplay.Left + scDisplay.Width - edIdent.Left ;
     edStatus.Width := scDisplay.Left + scDisplay.Width - edStatus.Left ;

     end;


procedure TRecordFrm.bStopClick(Sender: TObject);
{ ---------------
  Stop recording
  --------------- }
begin
     if (State = SweepInProgress) then EndofSweep := True
                                  else StopADCandDAC ;

     bRecord.enabled := True ;
     bStop.enabled := False ;
     AbortRecording := True ;
     RecordParametersPanel.Enabled := True ;
     end;


procedure TRecordFrm.cbPulseProgramChange(Sender: TObject);
{ ---------------------------
  Load a new voltage program
  --------------------------}
begin
     { Update voltage program file name stored in 'settings' when
       program combo box is changed }
     if cbPulseProgram.ItemIndex > 0 then begin
        WCPFile.Settings.VProgramFileName := UpdateVProgramFileName(cbPulseProgram.text) ;
        if FileExists( WCPFile.Settings.VProgramFileName ) then begin
           Stimulator.LoadProtocol(WCPFile.Settings.VProgramFileName) ;
           // Update display with new settings
           UpdateDisplay(true) ;
           end ;
        end
     else WCPFile.Settings.VProgramFileName := '' ;

     end;


procedure TRecordFrm.FormClose(Sender: TObject; var Action: TCloseAction);
// ---------------------------
// Tidy up when form is closed
// ---------------------------
begin

     { Shut down Lab. interface hardware ... essential to avoid program crash }
     RestoreIdleState ;
     Action := caFree ;
     end;


procedure TRecordFrm.UpdateStopwatch ;
var
   Seconds : single ;
begin

        Seconds := (GetTickCount - Stopwatch.TickStart) / 1000. ;
        if (Seconds - Stopwatch.OldSeconds) > 1. then begin
           Stopwatch.OldSeconds := Seconds ;

           Stopwatch.Minute := Trunc(Seconds / 60. ) ;
           Stopwatch.Second := Trunc( Seconds - Stopwatch.Minute*60. ) ;
           Stopwatch.Hour := Stopwatch.Minute div 60 ;
           Stopwatch.Minute := Stopwatch.Minute mod 60 ;
           Stopwatch.MSec := 0 ;
           edTimeofDay.text := format(' %2dh:%2dm:%2ds ',[Stopwatch.Hour,
                                                          Stopwatch.Minute,
                                                          Stopwatch.Second]) ;

           end ;
        end ;


procedure TRecordFrm.bResetTimerClick(Sender: TObject);
{ Reset elapsed time counter on stopwatch
  ---------------------------------------}
begin
     Stopwatch.TickStart := (GetTickCount*1. ) ;
     Stopwatch.OldSeconds := 0. ;

     end;

procedure TRecordFrm.FormDeactivate(Sender: TObject);
{ ---------------------------------------
  Actions to be taken if form loses focus
  ---------------------------------------}
begin
     { Shut down lab. interface and return to idle state }
     //RestoreIdleState ;
     end;


procedure TRecordFrm.FormDestroy(Sender: TObject);
begin
    if ADCCopy <> Nil then FreeMem(ADCCopy);
    if ADCDetected <> Nil then FreeMem(ADCDetected);
    if ADCDisplay <> Nil then FreeMem(ADCDisplay) ;
    if LeakSum <> Nil then FreeMem(LeakSum) ;

    end;

procedure TRecordFrm.edIdentKeyPress(Sender: TObject; var Key: Char);
begin
     { Update ident line if it is changed }
     WCPFile.RawFH.IdentLine := edIdent.text ;
     { Only save to file if recording is not in progress }
     if bRecord.Enabled then begin
        WCPFile.SaveHeader(WCPFile.RawFH) ;
        if key = chr(13) then WCPFile.WriteToLogFile( WCPFile.RawFH.IdentLine ) ;
        end ;
     end;


procedure TRecordFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{ --------------
  Function keys
  -------------}
begin
     case Key of
          { F1 starts recording }
          VK_F1 : if bRecord.enabled then bRecord.Click ;
          { F2 stops recording }
          VK_F2 : if bStop.enabled then bStop.click ;
          end ;
     end;


procedure TRecordFrm.bEraseClick(Sender: TObject);
{ -------------------------
  Erase the display screen
  ------------------------}
begin
     if bRecord.Enabled then begin
        { Erase screen immediately if not recording }
        scDisplay.NumPoints := 0 ;
        if scDisplay.StorageMode then
           begin
           scDisplay.StorageMode := False ;
           scDisplay.StorageMode := True ;
           end;
        scDisplay.Invalidate ;
        end
     else begin
        { Request that the screen be erased at the beginning of the next sweep }
        EraseScreen := True ;
        if scDisplay.StorageMode then
           begin
           scDisplay.StorageMode := False ;
           scDisplay.StorageMode := True ;
           end;
        end ;
     end;


procedure TRecordFrm.bFindCursorsClick(Sender: TObject);
// -------------------------------------------------------------
// Move on-line analysis cursors to default locations on display
// -------------------------------------------------------------
begin
    WCPFile.Settings.RecPlot.Cursor0 := 0.01 ;
    WCPFile.Settings.RecPlot.Cursor1 := 0.05 ;
    WCPFile.Settings.RecPlot.Cursor2 := 0.8 ;
    WCPFile.Settings.RecPlot.Cursor3 := 0.9 ;
    WCPFile.Settings.RecPlot.Cursor4 := 0.95 ;
    if Main.FormExists( 'RecPlotFrm' ) then AddOLAWCursors ;

    end;


procedure TRecordFrm.edPreTriggerKeyPress(Sender: TObject; var Key: Char);
{ ----------------------------------
  Get event detection pre-trigger %
  ---------------------------------- }
begin
     if key = chr(13) then WCPFile.Settings.EventDetector.PreTrigger := edPreTrigger.Value ;
     end ;


procedure TRecordFrm.EdDetectionThresholdKeyPress(Sender: TObject;
  var Key: Char);
{ -------------------------------------
  Get event detection threshold level
  -----------------------------------}
begin
     if key = chr(13) then WCPFile.Settings.EventDetector.Threshold := edDetectionThreshold.Value ;
     end ;


procedure TRecordFrm.SetStoreMode(
          StorageMode : Boolean
          ) ;
{ --------------------------------------------
  Set oscilloscope display storage mode on/off
  -------------------------------------------- }
begin
     scDisplay.StorageMode := StorageMode ;
     end ;


procedure TRecordFrm.cbDetectChannelChange(Sender: TObject);
{ --------------------------------------
  Store change to event detector channel
  -------------------------------------- }
begin
     WCPFile.Settings.EventDetector.Channel := IntLimitTo(cbDetectChannel.ItemIndex,
                                       0,WCPFile.Settings.NumChannels-1) ;
     end;


procedure TRecordFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
     CanClose := not (Main.SESLabIO.ADCActive or Main.SESLabIO.DACActive) ;
     end;


procedure TRecordFrm.MainMenus( Enabled : Boolean ) ;
begin
     Main.File1.Enabled := Enabled ;
     Main.View.Enabled := True ;//Enabled ;
     Main.Analysis.Enabled := Enabled ;
     Main.Edit.Enabled := Enabled ;
     Main.Setup.Enabled := True ;
     Main.Simulations1.Enabled := Enabled ;
     end ;


procedure TRecordFrm.scDisplayCursorChange(Sender: TObject);
var
   ch : Integer ;
begin

     { Update channel descriptors with any changes to display }
     for ch := 0 to scDisplay.NumChannels-1 do {if Channel[ch].InUse then} begin
         Main.SESLabIO.ADCChannelYMin[ch] := scDisplay.YMin[Ch] ;
         Main.SESLabIO.ADCChannelYMax[ch] := scDisplay.YMax[Ch] ;
         Main.SESLabIO.ADCChannelVisible[ch] := scDisplay.ChanVisible[ch] ;

         if WCPFile.Settings.FixedZeroLevels or (Main.SESLabIO.ADCChannelZeroAt[ch] >= 0) then begin
            if scDisplay.HorizontalCursors[ch] <> Main.SESLabIO.ADCChannelZero[ch] then begin
               scDisplay.HorizontalCursors[ch] := Main.SESLabIO.ADCChannelZero[ch] ;
               end ;
            end
         else Main.SESLabIO.ADCChannelZero[ch] := Round(scDisplay.HorizontalCursors[ch]) ;
         scDisplay.ChanZeroAt[ch] := Main.SESLabIO.ADCChannelZeroAt[ch] ;
         WCPFile.Channel[ch].ADCZeroAt := Main.SESLabIO.ADCChannelZeroAt[ch] ;
         WCPFile.Channel[ch].ADCZero := Main.SESLabIO.ADCChannelZero[ch] ;
         end ;

     // Readout cursors
     if not bOpenOLAWindow.Enabled then begin
        WCPFile.Settings.RecPlot.Cursor0 := scDisplay.VerticalCursors[C0Cursor]/scDisplay.MaxPoints ;
        WCPFile.Settings.RecPlot.Cursor1 := scDisplay.VerticalCursors[C1Cursor]/scDisplay.MaxPoints ;
        WCPFile.Settings.RecPlot.Cursor2 := scDisplay.VerticalCursors[C2Cursor]/scDisplay.MaxPoints ;
        WCPFile.Settings.RecPlot.Cursor3 := scDisplay.VerticalCursors[C3Cursor]/scDisplay.MaxPoints ;
        WCPFile.Settings.RecPlot.Cursor4 := scDisplay.VerticalCursors[C4Cursor]/scDisplay.MaxPoints ;
        end ;

     end;


procedure TRecordFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
var
    ch : Integer ;
begin
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;

     for ch := 0 to scDisplay.NumChannels-1 do begin
         scDisplay.ChanVisible[ch] := Main.SESLabIO.ADCChannelVisible[ch] ; ;
         end ;

     scDisplay.Invalidate ;
     end ;


procedure  TRecordFrm.ZoomOutAll ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
var
    i : Integer ;
begin
     scDisplay.MaxADCValue := Main.SESLabIO.ADCMaxValue ;
     scDisplay.MinADCValue := Main.SESLabIO.ADCMinValue ;
     scDisplay.ZoomOut ;
     for i := 0 to Main.SESLabIO.ADCNumChannels-1 do begin
         Main.SESLabIO.ADCChannelYMin[i] := Main.SESLabIO.ADCMinValue ;
         Main.SESLabIO.ADCChannelYMax[i] := Main.SESLabIO.ADCMaxValue ;
         end ;
     end ;


procedure TRecordFrm.ZoomOut(
          ChanNum : Integer ) ;
// ------------------------------------
// Magnify selected A/D channel display
// ------------------------------------
begin
     scDisplay.YZoom( ChanNum, 50.0 ) ;
     end ;


procedure TRecordFrm.ZoomIn( ChanNum : Integer ) ;
// ------------------------------------
// Reduce selected A/D channel display
// ------------------------------------
begin
     scDisplay.YZoom( ChanNum, -50.0 ) ;
     end ;



procedure TRecordFrm.rbExtTriggerHighClick(Sender: TObject);
// ----------------------------------------
// Ext. Trigger Active High option selected
// ----------------------------------------
begin

     WCPFile.Settings.ExternalTriggerActiveHigh := rbExtTriggerHigh.Checked ;
     Main.SESLabIO.ADCExternalTriggerActiveHigh := WCPFile.Settings.ExternalTriggerActiveHigh ;
     rbExtTriggerHigh.Checked := Main.SESLabIO.ADCExternalTriggerActiveHigh ;

     end;

procedure TRecordFrm.rbExttriggerLowClick(Sender: TObject);
// ----------------------------------------
// Ext. Trigger Active Low option selected
// ----------------------------------------
begin
     WCPFile.Settings.ExternalTriggerActiveHigh := rbExtTriggerHigh.Checked ;
     Main.SESLabIO.ADCExternalTriggerActiveHigh := WCPFile.Settings.ExternalTriggerActiveHigh ;
     rbExtTriggerHigh.Checked := Main.SESLabIO.ADCExternalTriggerActiveHigh ;
     end;


procedure TRecordFrm.ckFixedZeroLevelsClick(Sender: TObject);
begin
     WCPFile.Settings.FixedZeroLevels := ckFixedZeroLevels.Checked ;
     end;


procedure TRecordFrm.ckNewFileOnRecordClick(Sender: TObject);
begin
    WCPFile.Settings.OpenNewFileOnRecord := ckNewFileOnRecord.Checked ;
    end;

procedure TRecordFrm.edAmplifierGain0KeyPress(Sender: TObject;
  var Key: Char);
// ---------------------------------------
// Amplifier gain changed - update display
// ---------------------------------------
begin
     if Key = #13 then UpdateAmplifierGains ;
     end;


procedure TRecordFrm.UpdateAmplifierGains ;
// -----------------------------------------------
// Update amplifier gains with user-entered values
// -----------------------------------------------
begin
    if panAmplifierGain0.Visible then
       Amplifier.PrimaryChannelScaleFactor[0] := edAmplifierGain0.Value ;
    if panAmplifierGain1.Visible then
       Amplifier.PrimaryChannelScaleFactor[1] := edAmplifierGain1.Value ;
    if panAmplifierGain2.Visible then
       Amplifier.PrimaryChannelScaleFactor[2] := edAmplifierGain2.Value ;
    if panAmplifierGain3.Visible then
       Amplifier.PrimaryChannelScaleFactor[3] := edAmplifierGain3.Value ;
    NewAmplifierGain := True ;
    end ;


function TRecordFrm.GetRecordingMode : Integer ;
// ----------------
// Get recording mode
// ----------------
begin
     Result := cbRecordingMode.ItemIndex ;
     end ;


procedure TRecordFrm.StartRecording ;
// -------------------------------
// Start recording (external call)
// -------------------------------
begin
     bRecord.Click ;
     end ;


procedure TRecordFrm.StopRecording ;
// -------------------------------
// Stop recording (external call)
// -------------------------------
begin
     bStop.Click ;
     end ;


function TRecordFrm.GetStimulusProtocol : String ;
// -------------------------------------------
// Return currently selected stimulus protocol
// -------------------------------------------
begin
    Result := cbPulseProgram.Text ;
    end ;


procedure TRecordFrm.SetStimulusProtocol( Value : String ) ;
// ----------------------
// Set stimulus protocol
// ----------------------
var
    idx : Integer ;
begin

    idx := cbPulseProgram.Items.IndexOf(Value) ;
    if (idx > 0) and (idx < cbPulseProgram.Items.Count) then begin
       cbPulseProgram.ItemIndex := idx ;
       WCPFile.Settings.VProgramFileName := UpdateVProgramFileName(cbPulseProgram.text) ;
       end
    else begin
       cbPulseProgram.ItemIndex := 0 ;
       WCPFile.Settings.VProgramFileName := '' ;
       end ;

    end ;


function TRecordFrm.GetRunning : Boolean ;
// -----------------------------------------
// Return TRUE if digitising analogue signal
// -----------------------------------------
begin
    Result := Timer.Enabled ;
    end ;


function TRecordFrm.GetRecording : Boolean ;
// -----------------------------------------
// Return TRUE if recording analogue signal
// -----------------------------------------
begin
    Result := bStop.Enabled ;
    end ;


procedure TRecordFrm.FormActivate(Sender: TObject);
begin

     // Ensure display channels visibility is updated
     ChangeDisplayGrid ;
     ckFixedZeroLevels.Checked := WCPFile.Settings.FixedZeroLevels ;

     // Stop seal test recording form if it is open
     if Main.FormExists( 'SealTestFrm') then SealTestFrm.StopADCandDAC ;

     ShowAmplifierGains ;
     NewAmplifierGain := True ;

     end;

procedure TRecordFrm.bOpenOLAWindowClick(Sender: TObject);
// ----------------------------
// Open on-line analysis window
// ----------------------------
begin

     // Update display to ensure window duration is valid
     UpdateDisplay(False) ;

     // Add cursors
     AddOLAWCursors ;

     if not Main.FormExists( 'RecPlotFrm' ) then begin
        RecPlotFrm := TRecPlotFrm.Create(Self) ;
        // Make space for on-line window
        RecordFrm.Width := Min( (Main.ClientWidth*2) div 3, RecordFrm.Width) ;
        RecPlotFrm.Width :=  Main.ClientWidth - RecordFrm.Left - RecordFrm.Width - 5 ;
        RecPlotFrm.Left := RecordFrm.Left + RecordFrm.Width + 2 ;
        RecPlotFrm.Top := 10 ;
        end ;

     bCloseOLAWindow.Enabled := True ;
     bFindCursors.Enabled := True ;
     bOpenOLAWindow.Enabled := False ;

     end;


procedure TRecordFrm.AddOLAWCursors ;
// ----------------------------
// Add on-line analysis cursors
// ----------------------------
begin

     scDisplay.ClearVerticalCursors ;

     C0Cursor := scDisplay.AddVerticalCursor(-1,clOlive,'0') ;
     if WCPFile.Settings.RecPlot.Cursor0 < 0 then WCPFile.Settings.RecPlot.Cursor0 := 1/scDisplay.MaxPoints ;
     scDisplay.VerticalCursors[C0Cursor] := Round(WCPFile.Settings.RecPlot.Cursor0*scDisplay.MaxPoints) ;

     C1Cursor := scDisplay.AddVerticalCursor(-1,clGreen,'1') ;
     if WCPFile.Settings.RecPlot.Cursor1 < 0 then WCPFile.Settings.RecPlot.Cursor1 := 0.05 ;
     scDisplay.VerticalCursors[C1Cursor] := Round(WCPFile.Settings.RecPlot.Cursor1*scDisplay.MaxPoints) ;

     C2Cursor := scDisplay.AddVerticalCursor(-1,clGreen,'2') ;
     if WCPFile.Settings.RecPlot.Cursor2 < 0 then WCPFile.Settings.RecPlot.Cursor2 := 0.8 ;
     scDisplay.VerticalCursors[C2Cursor] := Round(WCPFile.Settings.RecPlot.Cursor2*scDisplay.MaxPoints) ;
     scDisplay.LinkVerticalCursors(C1Cursor,C2Cursor) ;

     C3Cursor := scDisplay.AddVerticalCursor(-1,clGreen,'3') ;
     if WCPFile.Settings.RecPlot.Cursor3 < 0 then WCPFile.Settings.RecPlot.Cursor3 := 0.9 ;
     scDisplay.VerticalCursors[C3Cursor] := Round(WCPFile.Settings.RecPlot.Cursor3*scDisplay.MaxPoints) ;

     C4Cursor := scDisplay.AddVerticalCursor(-1,clGreen,'4') ;
     if WCPFile.Settings.RecPlot.Cursor4 < 0 then WCPFile.Settings.RecPlot.Cursor4 := 0.95 ;
     scDisplay.VerticalCursors[C4Cursor] := Round(WCPFile.Settings.RecPlot.Cursor4*scDisplay.MaxPoints) ;
     scDisplay.LinkVerticalCursors(C3Cursor,C4Cursor) ;

     scDisplay.Invalidate ;

     end;


procedure TRecordFrm.bCloseOLAWindowClick(Sender: TObject);
// -----------------------------
// Close on-line analysis window
// -----------------------------
begin
     scDisplay.ClearVerticalCursors ;
     scDisplay.Invalidate ;

     if Main.FormExists( 'RecPlotFrm' ) then begin
        RecPlotFrm.Close  ;
        end ;

     bCloseOLAWindow.Enabled := False ;
     bFindCursors.Enabled := False ;
     bOpenOLAWindow.Enabled := True ;

     end ;


procedure TRecordFrm.bSetStimFolderClick(Sender: TObject);
// -----------------------------
//  Set voltage protocol file folder
// -----------------------------
begin
    DirectorySelectFrm.Directory := WCPFile.Settings.VProtDirectory ;
    DirectorySelectFrm.Left := Main.Left +
                               RecordFrm.Left +
                               bSetStimFolder.Left +
                               bSetStimFolder.Width + 20 ;
    DirectorySelectFrm.Top := Main.Top +
                              RecordFrm.Top +
                              bSetStimFolder.Top + 10 ;

    DirectorySelectFrm.ShowModal ;
    if DirectorySelectFrm.ModalResult = mrOK then begin
       WCPFile.Settings.VProtDirectory := DirectorySelectFrm.Directory ;
       UpdateStimulusProtocolList ;
       end ;
     end ;

     
procedure TRecordFrm.cbRecordingModeChange(Sender: TObject);
// ----------------------
// Recording mode changed
// ----------------------
begin
    SetRecordingMode( cbRecordingMode.ItemIndex ) ;
    end;


procedure TRecordFrm.SetRecordingMode( iMode : Integer ) ;
// -------------------------
// Set recording mode panels
// -------------------------
begin

     cbRecordingMode.ItemIndex := iMode ;

     { Set trigger mode }

     // detect mode not available with Tecella
     if (Main.SESLabIO.LabInterfaceType = Triton) and
        (cbRecordingMode.ItemIndex = rmDetect) then cbRecordingMode.ItemIndex := rmProtocol ;

     WCPFile.Settings.RecordingMode := cbRecordingMode.ItemIndex ;

     case cbRecordingMode.ItemIndex of
        rmProtocol : Begin
            RecordParametersPanel.Visible := False ;
            panProtocol.Visible := True ;
            panSingleProtocol.Visible := rbSingleProtocol.Checked ;
            panProtocolList.Visible := rbProtocolList.Checked ;
            LoadProtocolList ;
            WCPFile.Settings.VProgramFileName := UpdateVProgramFileName(cbPulseProgram.text) ;
            if FileExists( WCPFile.Settings.VProgramFileName ) then
               Stimulator.LoadProtocol(WCPFile.Settings.VProgramFileName) ;
            end ;
        rmFreeRun : Begin
            RecordParametersPanel.Visible := True ;
            panProtocol.Visible := False ;
            ExtTriggerGrp.Visible := False ;
            DetectGrp.Visible := False ;
            end ;
        rmExtTrig : Begin
            RecordParametersPanel.Visible := True ;
            panProtocol.Visible := False ;
            ExtTriggerGrp.Visible := True ;
            DetectGrp.Visible := False ;
            end ;
        rmDetect : Begin
            RecordParametersPanel.Visible := True ;
            panProtocol.Visible := False ;
            ExtTriggerGrp.Visible := False ;
            DetectGrp.Visible := True ;
            end ;
        end ;

     UpdateDisplay(true) ;

     end ;


procedure TRecordFrm.edNumChannelsKeyPress(Sender: TObject; var Key: Char);
// -----------------------
// No. of channels changed
// -----------------------
begin
     if Key = #13 then
        begin
        UpdateSamplingInterval ;
        UpdateDisplay(true) ;
        end ;
     end;


procedure TRecordFrm.edNumSamplesKeyPress(Sender: TObject; var Key: Char);
// ------------------------------
// No. of samples/channel changed
// ------------------------------
begin
     if Key = #13 then
        begin
        UpdateSamplingInterval ;
        UpdateDisplay(true) ;
        end ;
     end;


procedure TRecordFrm.UpdateSamplingInterval ;
{ ----------------------------
  Update A/D sampling interval (and ensure a valid value is in used)
  ---------------------------- }
begin

     // No. channels
     Main.SESLabIO.ADCNumChannels := Round(edNumChannels.Value) ;
     edNumChannels.Value := Main.SESLabIO.ADCNumChannels ;
     WCPFile.Settings.NumChannels := Main.SESLabIO.ADCNumChannels ;

     // No. samples / channel (must be multipe of 256)
     Main.SESLabIO.ADCNumSamples := Round(edNumSamples.Value) ;
     Main.SESLabIO.ADCNumSamples := Max(Main.SESLabIO.ADCNumSamples div 256,1)*256 ;
     edNumSamples.Value := Main.SESLabIO.ADCNumSamples ;
     WCPFile.Settings.NumSamples := Main.SESLabIO.ADCNumSamples ;

     // Compute sampling interval from record duration
     Main.SESLabIO.ADCSamplingInterval := edRecordDuration.Value / WCPFile.Settings.NumSamples ;

     // Get validated interval back from interface
     edSamplingInterval.Value := Main.SESLabIO.ADCSamplingInterval ;

     edRecordDuration.Value := edSamplingInterval.Value*WCPFile.Settings.NumSamples ;
     WCPFile.Settings.RecordDuration := edRecordDuration.Value ;

     end ;


procedure TRecordFrm.edRecordDurationKeyPress(Sender: TObject;
  var Key: Char);
begin
     if Key = #13 then
        begin
        UpdateSamplingInterval ;
        UpdateDisplay(true) ;
        end ;
     end;


procedure TRecordFrm.edNumRecordsKeyPress(Sender: TObject; var Key: Char);
// ----------------------------
// No. records required changed
// ----------------------------
begin
     if Key = #13 then begin
        WCPFile.Settings.NumRecordsRequired := Round(edNumRecords.Value) ;
        end ;
     end;


procedure TRecordFrm.edSamplingIntervalKeyPress(Sender: TObject;
  var Key: Char);
// -------------------------
// Sampling interval changed
// -------------------------
begin
     if Key = #13 then
        begin
        Main.SESLabIO.ADCNumChannels := Round(edNumChannels.Value) ;
        edNumChannels.Value := Main.SESLabIO.ADCNumChannels ;
        WCPFile.Settings.NumChannels := Main.SESLabIO.ADCNumChannels ;
        // No. samples / channel
        Main.SESLabIO.ADCNumSamples := Round(edNumSamples.Value) ;
        edNumSamples.Value := Main.SESLabIO.ADCNumSamples ;
        WCPFile.Settings.NumSamples := Main.SESLabIO.ADCNumSamples ;
        // Ensure valid sampling interval
        Main.SESLabIO.ADCSamplingInterval := edSamplingInterval.Value ;
        edSamplingInterval.Value := Main.SESLabIO.ADCSamplingInterval ;
        edRecordDuration.Value := edSamplingInterval.Value*edNumSamples.Value ;
        WCPFile.Settings.RecordDuration := edRecordDuration.Value ;
        UpdateDisplay(true) ;
        end ;
     end;


procedure TRecordFrm.rbSingleProtocolClick(Sender: TObject);
begin
    SetRecordingMode( cbRecordingMode.ItemIndex ) ;
    end;

procedure TRecordFrm.rbProtocolListClick(Sender: TObject);
begin
    SetRecordingMode( cbRecordingMode.ItemIndex ) ;
    end;


procedure TRecordFrm.CreateProtocolListList(
          var cbList : TComboBox
          ) ;
{ --------------------------------------------
  Compile a list of protocol list (*.lst) files in the protocol directory
  and put the file names into a combo box
  --------------------------------------------------------------}
var
   SearchRec : TSearchRec ;
   First : Boolean ;
   FileFound : Integer ;
begin

     First := True ;
     cbList.Clear ;
     cbList.items.add( ' ' ) ;
     repeat
        { Find file }
        if First then
           FileFound := FindFirst( WCPFile.Settings.VProtDirectory + '*.lst',
                                   faAnyFile,
                                   SearchRec )
        else
           FileFound := FindNext( SearchRec ) ;

        { Add file name (no extension or path) to list }
        if FileFound = 0 then cbList.items.Add(WCPFile.ExtractFileNameOnly(SearchRec.Name))
                        else FindClose(SearchRec.FindHandle) ;
        First := False ;
        Until FileFound <> 0 ;

     end ;


function TRecordFrm.LoadProtocolList ;
// ----------------------------------------------------
// Load list of protocols to be executed from .LST file
// ----------------------------------------------------
var
    F: TextFile;
    s : String ;
begin

     Result := False ;

     if (cbProtocolList.ItemIndex <= 0) or (cbProtocolList.Items.Count <= 0) then begin
        meProtocolList.Clear ;
        WCPFile.Settings.ProtocolListFileName := '' ;
        Exit ;
        end ;

     WCPFile.Settings.ProtocolListFileName := cbProtocolList.Items[cbProtocolList.ItemIndex] ;
     if (WCPFile.Settings.ProtocolListFileName = '') or
        (WCPFile.Settings.ProtocolListFileName = ' ') then begin
        meProtocolList.Clear ;
        WCPFile.Settings.ProtocolListFileName := '' ;
        Exit ;
        end ;

     WCPFile.Settings.ProtocolListFileName := WCPFile.Settings.VProtDirectory +
                                      ExtractFileName(ChangeFileExt(WCPFile.Settings.ProtocolListFileName,'.lst')) ;

     if not FileExists(WCPFile.Settings.ProtocolListFileName) then begin
        meProtocolList.Clear ;
        WCPFile.Settings.ProtocolListFileName := '' ;
        Exit ;
        end ;

     // Open text input file
     AssignFile(F, WCPFile.Settings.ProtocolListFileName);
     Reset(F);

     meProtocolList.Lines.Clear ;
     repeat
         // Read line
         ReadLn( F, s ) ;
         meProtocolList.Lines.Add(ChangeFileExt(ExtractFileName(s),'')) ;
         until EOF(F)  ;

    CloseFile(F) ;

    Result := True ;

    end ;


function TRecordFrm.SaveProtocolList(
         FileName : String
         ) : Boolean ;
// --------------------------------------------------
// Save list of protocols to be executed to .LST file
// --------------------------------------------------
var
    F: TextFile;
    i : Integer ;
begin

     if FileName = '' then begin
        Result := False ;
        Exit ;
        end ;

     FileName := WCPFile.Settings.VProtDirectory + ExtractFileName(ChangeFileExt(FileName,'.lst')) ;

     // Open text file for output
     AssignFile(F, FileName);
     Rewrite(F);

     for i := 0 to meProtocolList.Lines.Count-1 do begin
         WriteLn( F, meProtocolList.Lines[i] ) ;
         end ;

    CloseFile(F) ;

    Result := True ;

    end ;


procedure TRecordFrm.cbProtocolListChange(Sender: TObject);
// ---------------------
// Protocol list changed
// ---------------------
begin
    LoadProtocolList ;
    end;

    
procedure TRecordFrm.bAddProtocolToListClick(Sender: TObject);
// --------------------
// Add protocol to list
// --------------------
begin
     OpenDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     OpenDialog.FileName := '*.xml' ;//ExtractFileName( SaveDialog.FileName ) ;
     OpenDialog.InitialDir := WCPFile.Settings.VProtDirectory ;
     SetCurrentDir(WCPFile.Settings.VProtDirectory);
     OpenDialog.Title := 'Add Stimulus Protocol to List' ;
     if OpenDialog.execute then begin
        meProtocolList.Lines.Add('') ;
        meProtocolList.Lines[meProtocolList.Lines.Count-2] :=
           ChangeFileExt(ExtractFileName(OpenDialog.FileName),'') ;
        SaveProtocolList(cbProtocolList.Text) ;
        end ;
     end ;


procedure TRecordFrm.bDeleteProtocolListClick(Sender: TObject);
// --------------------
// Delete protocol list
// --------------------
var
    FileName : String ;
begin
     FileName := cbProtocolList.Text ;
     if FileName = '' then Exit ;
     FileName := WCPFile.Settings.VProtDirectory + ChangeFileExt(FileName,'.lst') ;
     if FileExists(FileName) then begin
        DeleteFile(PChar(FileName)) ;
        cbProtocolList.ItemIndex := 0 ;
        meProtocolList.Clear ;
        UpdateStimulusProtocolList ;
        end ;
     end;


procedure TRecordFrm.bNewProtocolListClick(Sender: TObject);
// -------------------------------------------
// Create new stimulus protocol execution list
// -------------------------------------------
var
    FileName : String ;
    OK : Boolean ;
begin
     FileName := edNewProtocolListName.Text ;
     if FileName = '' then Exit ;
     FileName := WCPFile.Settings.VProtDirectory + ExtractFileName(ChangeFileExt(FileName,'.lst')) ;

     OK := True ;
     if FileExists(FileName) then begin
        if MessageDlg( 'Protocol list already exists! Overwrite it?', mtConfirmation,
          [mbYes,mbNo], 0 ) = mrNo then OK := False ;
        end ;

     if OK then begin
        meProtocolList.Clear ;
        SaveProtocolList( FileName ) ;
        cbProtocolList.Items.Add(edNewProtocolListName.Text);
        cbProtocolList.ItemIndex := cbProtocolList.Items.Count-1 ;
        LoadProtocolList ;
        end ;

     end ;

procedure TRecordFrm.DisplayClampMode ;
// ----------------------------------
// Display current/voltage clamp mode
// ----------------------------------
begin

     if Amplifier.ClampMode[0] = amVoltageClamp then begin
        rbVClamp0.Checked := True ;
        rbIClamp0.Checked := False ;
        end
     else begin
        rbVClamp0.Checked := False ;
        rbIClamp0.Checked := True ;
        end ;

     if Amplifier.ClampMode[1] = amVoltageClamp then begin
        rbVClamp1.Checked := True ;
        rbIClamp1.Checked := False ;
        end
     else begin
        rbVClamp1.Checked := False ;
        rbIClamp1.Checked := True ;
        end ;

     if Amplifier.ClampMode[2] = amVoltageClamp then begin
        rbVClamp2.Checked := True ;
        rbIClamp2.Checked := False ;
        end
     else begin
        rbVClamp2.Checked := False ;
        rbIClamp2.Checked := True ;
        end ;

     if Amplifier.ClampMode[3] = amVoltageClamp then begin
        rbVClamp3.Checked := True ;
        rbIClamp3.Checked := False ;
        end
     else begin
        rbVClamp3.Checked := False ;
        rbIClamp3.Checked := True ;
        end ;

     end ;


procedure TRecordFrm.rbVCLAMP0Click(Sender: TObject);
begin
     Amplifier.ClampMode[TRadioButton(Sender).tag] := amVoltageClamp ;
     DisplayClampMode ;
     end;

procedure TRecordFrm.rbICLAMP0Click(Sender: TObject);
begin
     Amplifier.ClampMode[TRadioButton(Sender).tag] := amCurrentClamp ;
     DisplayClampMode ;
     end;

procedure TRecordFrm.scDisplayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if (Button = mbRight) and (scDisplay.ActiveHorizontalCursor >=0) then begin
        // If right-mouse button down, display zero baseline level selection dialog box
        ZeroFrm.EnableFromRecord := True ;
        ZeroFrm.Chan := scDisplay.ActiveHorizontalCursor ;
        ZeroFrm.Level := Main.SESLabIO.ADCChannelZero[ZeroFrm.Chan] ;
        ZeroFrm.ChanName := Main.SESLabIO.ADCChannelName[ZeroFrm.Chan] ;
        ZeroFrm.NewZeroAt := Round(scDisplay.ScreenCoordToX( ZeroFrm.Chan, X )) ;
        ZeroFrm.OldZeroAt := Main.SESLabIO.ADCChannelZeroAt[ZeroFrm.Chan] ;
        ZeroFrm. NumSamplesPerRecord := scDisplay.MaxPoints ;
        ZeroFrm.NumZeroAveraged := Main.SESLabIO.ADCChannelNumZero ;
        ZeroFrm.MaxValue := Main.SESLabIO.ADCMaxValue ;
        ZeroFrm.Left := Self.Left + Main.Left + 10 + scDisplay.Left + X;
        ZeroFrm.Top := Self.Top + Main.Top + 10 + scDisplay.Top + Y ;
        ZeroFrm.ShowModal ;
        Main.SESLabIO.ADCChannelZero[ZeroFrm.Chan] := ZeroFrm.Level ;
        Main.SESLabIO.ADCChannelZeroAt[ZeroFrm.Chan] := ZeroFrm.NewZeroAt ;
        WCPFile.Channel[ZeroFrm.Chan].ADCZeroAt := ZeroFrm.NewZeroAt ;
        Main.SESLabIO.ADCChannelNumZero := ZeroFrm.NumZeroAveraged ;

        scDisplay.HorizontalCursors[ZeroFrm.Chan] := Main.SESLabIO.ADCChannelZero[ZeroFrm.Chan] ;
        scDisplay.ChanZeroAt[ZeroFrm.Chan] :=  Main.SESLabIO.ADCChannelZeroAt[ZeroFrm.Chan] ;
        end

   end;


procedure TRecordFrm.FormCreate(Sender: TObject);
begin
     DataFileIndex := 0 ;

    ADC := Nil ;
    DAC := Nil ;
    ADCCopy := Nil ;
    ADCDetected := Nil ;
    ADCCircular := Nil ;
    ADCDisplay := Nil ;
    LeakSum := Nil ;
    DCLAMPAction := DCL_None ;
    end;


end.
