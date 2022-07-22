unit DCLAMPUnit;
                               //
// Dynamic Clamp Control Panel
// ---------------------------
// V1.1 05.10.08
// V1.2 21.05.10 Settings now preserved in INI file and in DCS settings files
//               Error which set M.beta parameters to M.alpha values fixed
// V1.3 22-07-10 Parameters now updated when Reset pressed
//               Error in sending alpha V slope fixed
// V1.4 23-07-10
// V1.4.1 28-3-11 Parameter update time increased to 0.4s to allow HTL=
//                parameter update to complete. (Vslope of inactivation
//                was not being updated during batch update of parameters
//                Dynamic clamp now updated automatically when parameter
//                is loaded from file
// V2.0 9-7-14    Now uses National Instruments cRIO-9076 controller unit
// V2.0.1 17-9-14   Current scale factor now expressed as A/V (same as WinWCP)
// 23-3-15        Incorporated into WinWCP
// 30-5-15        Activation and inactivation Vhalf and time constants can now be incremented.
// 17.06.15       Incremented dynamic clamp settings reports in log file and stored in settings
// 18.06.15       Negative steps of activation V1/2 now work
// 25.09.15       Steady-state and Tau V1/2 can now be incremented separately
// 29.09.15       DCLAMP Increments now take place either at end of protocol
//                or after Nth record
//                Updating time now reported in status bar
// 05.08.16       DCLAMP parameters now updated when form opened
// 15.07.22       SaveSettings() and LoadSettings() now use TStringList to hold KEY=Value pairs

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, XYPlotDisplay,
  Vcl.StdCtrls, HTMLLabel, ValidatedEdit, Vcl.ComCtrls, math, Vcl.Grids, system.character ;

const
    SteadyStatesPlot = 0 ;
    TimeConstantsPlot = 1 ;
    ActivationRatesPlot = 2 ;
    InactivationRatesPlot = 3 ;

    HeaderSize = 1024 ;

type
  TDCLAMPFrm = class(TForm)
    Page: TPageControl;
    ControlsTab: TTabSheet;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    rbOff: TRadioButton;
    rbAdd: TRadioButton;
    rbSubtract: TRadioButton;
    GroupBox2: TGroupBox;
    Label16: TLabel;
    edmPower: TValidatedEdit;
    GroupBox7: TGroupBox;
    HTMLLabel1: THTMLLabel;
    HTMLLabel8: THTMLLabel;
    HTMLLabel9: THTMLLabel;
    edMSSVhalf: TValidatedEdit;
    edMSSVslope: TValidatedEdit;
    GroupBox8: TGroupBox;
    HTMLLabel2: THTMLLabel;
    HTMLLabel3: THTMLLabel;
    HTMLLabel4: THTMLLabel;
    HTMLLabel5: THTMLLabel;
    HTMLLabel6: THTMLLabel;
    edMTauMin: TValidatedEdit;
    edMTauMax: TValidatedEdit;
    edMTauVhalf: TValidatedEdit;
    edMTauVSlope: TValidatedEdit;
    GroupBox9: TGroupBox;
    Label8: TLabel;
    GroupBox10: TGroupBox;
    HTMLLabel10: THTMLLabel;
    HTMLLabel11: THTMLLabel;
    HTMLLabel12: THTMLLabel;
    edHSSVhalf: TValidatedEdit;
    edHSSVslope: TValidatedEdit;
    GroupBox11: TGroupBox;
    HTMLLabel13: THTMLLabel;
    HTMLLabel14: THTMLLabel;
    HTMLLabel15: THTMLLabel;
    HTMLLabel16: THTMLLabel;
    HTMLLabel17: THTMLLabel;
    edHTauFMin: TValidatedEdit;
    edHTauFMax: TValidatedEdit;
    edHTauFVhalf: TValidatedEdit;
    edHTauFVslope: TValidatedEdit;
    GroupBox3: TGroupBox;
    HTMLLabel18: THTMLLabel;
    HTMLLabel19: THTMLLabel;
    HTMLLabel20: THTMLLabel;
    HTMLLabel21: THTMLLabel;
    HTMLLabel22: THTMLLabel;
    edHTauSMin: TValidatedEdit;
    edHTauSMax: TValidatedEdit;
    edHTauSVHalf: TValidatedEdit;
    edHTauSVSlope: TValidatedEdit;
    edHFastFraction: TValidatedEdit;
    GroupBox6: TGroupBox;
    ckEnableInhibitInput: TCheckBox;
    bReset: TButton;
    GraphsTab: TTabSheet;
    plPlot: TXYPlotDisplay;
    cbPlot: TComboBox;
    Timer1: TTimer;
    Label3: TLabel;
    edVrev: TValidatedEdit;
    Label7: TLabel;
    edCurrentCommandScaleFactor: TValidatedEdit;
    bLoadSettings: TButton;
    bSaveSettings: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Label1: TLabel;
    edGMax: TValidatedEdit;
    edNumRecords: TValidatedEdit;
    sgSteps: TStringGrid;
    bCopyToClipboard: TButton;
    edStatus: TEdit;
    cbComPort: TComboBox;
    Label4: TLabel;
    rbNoIncrements: TRadioButton;
    rbIncrementAfterProtocol: TRadioButton;
    rbIncrementAfterRecord: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure edGMaxKeyPress(Sender: TObject; var Key: Char);
    procedure edVrevKeyPress(Sender: TObject; var Key: Char);
    procedure edCurrentCommandScaleFactorKeyPress(Sender: TObject;
      var Key: Char);
    procedure edMSSVhalfKeyPress(Sender: TObject; var Key: Char);
    procedure edMSSVslopeKeyPress(Sender: TObject; var Key: Char);
    procedure edHSSVhalfKeyPress(Sender: TObject; var Key: Char);
    procedure edHSSVslopeKeyPress(Sender: TObject; var Key: Char);
    procedure edMTauMinKeyPress(Sender: TObject; var Key: Char);
    procedure edMTauMaxKeyPress(Sender: TObject; var Key: Char);
    procedure edHTauFMinKeyPress(Sender: TObject; var Key: Char);
    procedure edHTauFMaxKeyPress(Sender: TObject; var Key: Char);
    procedure edMTauVhalfKeyPress(Sender: TObject; var Key: Char);
    procedure edMTauVSlopeKeyPress(Sender: TObject; var Key: Char);
    procedure edHTauFVhalfKeyPress(Sender: TObject; var Key: Char);
    procedure edHTauFVslopeKeyPress(Sender: TObject; var Key: Char);
    procedure edmPowerKeyPress(Sender: TObject; var Key: Char);
    procedure edHTauSMinKeyPress(Sender: TObject; var Key: Char);
    procedure edHTauSMaxKeyPress(Sender: TObject; var Key: Char);
    procedure edHTauSVHalfKeyPress(Sender: TObject; var Key: Char);
    procedure edHTauSVSlopeKeyPress(Sender: TObject; var Key: Char);
    procedure edHFastFractionKeyPress(Sender: TObject; var Key: Char);
    procedure rbOffClick(Sender: TObject);
    procedure bResetClick(Sender: TObject);
    procedure cbPlotChange(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bLoadSettingsClick(Sender: TObject);
    procedure bSaveSettingsClick(Sender: TObject);
    procedure sgStepsKeyPress(Sender: TObject; var Key: Char);
    procedure bCopyToClipboardClick(Sender: TObject);
    procedure rbAddClick(Sender: TObject);
    procedure rbSubtractClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    ComHandle : Integer ;
    OverLapStructure : POverlapped ;
    INIFileName : String ;
//    UpdatesEnabled : Boolean ;
//    UpdateCounter : Integer ;
    StepCounter : Integer ;             // Gmax step number (in steps mode)
    RecordCounter : Integer ;          // Record counter (for Increment after record)
//    RepeatNumber : Integer ;           // Gmax repeat number (in steps mode)
    StepGmax : Integer ;
    StepActSSVh : Integer ;
    StepActTauVh : Integer ;
    StepActTau : Integer ;
    StepInactSSVh : Integer ;
    StepInactTauVh : Integer ;
    StepInactTau : Integer ;
    StepUnits: Array[0..19] of string ;

    UpdateTicks : Integer ;
    UpdateTicksMax : Integer ;
    UpdateStatus : string ;

    function OpenDCLAMP : Boolean ;
    procedure CloseDCLAMP ;
    procedure SetParameter( ParName : String ; Value : Single ) ;
    procedure SetConductance( G : Single ) ;
    procedure TransmitLine( const Line : string ) ;
    function  ReceiveLine : string ;
    procedure PlotGraph ;
    procedure LoadSettingsFile( const IniFileName : string ) ;
    procedure SaveSettingsFile( const IniFileName : string ) ;
    procedure UpdateDCLAMP ;
    function GetStepSize( iPar : Integer ) : single ;
    procedure IncrementModelParameters ;

  public
    { Public declarations }
    GMax : single ;
    SteppedParameter : Integer ;
    Status : string ;
    procedure Initialise ;
    procedure NextProtocol ;
    procedure NextRecord ;
  end;

var
  DCLAMPFrm: TDCLAMPFrm;

implementation

{$R *.dfm}

uses MDIForm, WCPFIleUnit;

procedure TDClampFrm.edGMaxKeyPress(Sender: TObject; var Key: Char);
// ---------
// Set Gmax
// ---------
begin
     if Key = #13 then SetConductance( edGMax.Value ) ;
     end;

procedure TDClampFrm.edCurrentCommandScaleFactorKeyPress(Sender: TObject; var Key: Char);
// ---------
// Set Vrev
// ---------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edVrevKeyPress(Sender: TObject; var Key: Char);
// ---------
// Set Vrev
// ---------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;



procedure TDClampFrm.edMSSVhalfKeyPress(Sender: TObject; var Key: Char);
// -------------------------
// Set M steady state V half
// -------------------------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edMSSVslopeKeyPress(Sender: TObject; var Key: Char);
// ---------------------------
// Set M steady state V slope
// ---------------------------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edMTauMinKeyPress(Sender: TObject; var Key: Char);
// ------------------
// Set M time constant min
// ------------------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edMTauMaxKeyPress(Sender: TObject; var Key: Char);
// -----------------------
// Set H time constant max
// -----------------------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edMTauVhalfKeyPress(Sender: TObject; var Key: Char);
// --------------------------
// Set M time constant V half
// --------------------------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edMTauVSlopeKeyPress(Sender: TObject; var Key: Char);
// ------------------
// Set M time constant V slope
// ------------------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edmPowerKeyPress(Sender: TObject; var Key: Char);
// ------------------
// Set m power factor
// ------------------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;

procedure TDClampFrm.edHFastFractionKeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Set H slow time constant V half
// --------------------------------
begin
     if Key = #13 then begin
         UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edHSSVhalfKeyPress(Sender: TObject; var Key: Char);
// -------------------------
// Set H steady state V half
// -------------------------
begin
     if Key = #13 then begin
      UpdateDClamp ;
        end ;
     end;

procedure TDClampFrm.edHSSVslopeKeyPress(Sender: TObject; var Key: Char);
// ---------------------------
// Set H steady state V slope
// ---------------------------
begin
     if Key = #13 then begin
      UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edHTauFMinKeyPress(Sender: TObject; var Key: Char);
// ------------------
// Set H time constant min
// ------------------
begin
     if Key = #13 then begin
      UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edHTauFMaxKeyPress(Sender: TObject; var Key: Char);
// -----------------------
// Set H time constant max
// -----------------------
begin
     if Key = #13 then begin
      UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edHTauFVhalfKeyPress(Sender: TObject; var Key: Char);
// --------------------------
// Set H time constant V half
// --------------------------
begin
     if Key = #13 then begin
      UpdateDClamp ;
        end ;
     end;




procedure TDClampFrm.edHTauFVslopeKeyPress(Sender: TObject; var Key: Char);
// ------------------
// Set H time constant V slope
// ------------------
begin
     if Key = #13 then begin
      UpdateDClamp ;
        end ;
     end;


procedure TDClampFrm.edHTauSMaxKeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Set H slow time constant maximum
// --------------------------------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;



procedure TDClampFrm.edHTauSMinKeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Set H slow time constant minimum
// --------------------------------
begin
     if Key = #13 then begin
         UpdateDClamp ;
        end ;
     end;

procedure TDClampFrm.edHTauSVHalfKeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Set H slow time constant V half
// --------------------------------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;

procedure TDClampFrm.edHTauSVSlopeKeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Set H slow time constant V slope
// --------------------------------
begin
     if Key = #13 then begin
        UpdateDClamp ;
        end ;
     end;


procedure TDCLAMPFrm.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin
//    UpdatesEnabled := False ;
    StepCounter := 0 ;
    UpdateTicks := 0 ;
    UpdateTicksMax := 0 ;
    UpdateStatus := '' ;
    end;

procedure TDCLAMPFrm.FormResize(Sender: TObject);
// ---------------------------------
// Update controls when form resized
// ---------------------------------
begin
    Page.Width := ClientWidth - Page.Left - 5 ;
    Page.Height := ClientHeight - Page.Top - 5 ;
    plPlot.Width := Max( GraphsTab.ClientWidth - plPlot.Left -5,2) ;
    plPlot.Height := Max( GraphsTab.ClientHeight - plPlot.Top -5,2) ;
    end;


procedure TDCLAMPFrm.FormShow(Sender: TObject);
// -----------------------------------
// Initialisations when form is opened
// -----------------------------------
var
    i : Integer ;
begin

     INIFileName := WCPFile.SettingsDirectory + 'DCLAMP.INI' ;

      edGmax.Value := 4.0 ;
      edVrev.Value := 0.0 ;
      edNumRecords.Value := 1.0 ;

      // Create step increments table
      sgSteps.ColWidths[0] := 90 ;
      sgSteps.ColWidths[1] := 50 ;

      i := 0 ;
      sgSteps.Cells[0,i] := 'Gmax' ;
      StepUnits[i] := '%' ;
      sgSteps.Cells[1,i] := '10 ' + StepUnits[i];
      StepGMax := i ;

      Inc(i) ;
      sgSteps.Cells[0,i] := 'Act.V1/2(ss)' ;
      StepUnits[i] := 'mV' ;
      sgSteps.Cells[1,i] := '0 ' + StepUnits[i];
      StepActSSVh := i ;

      Inc(i) ;
      sgSteps.Cells[0,i] := 'Act.V1/2(tau)' ;
      StepUnits[i] := 'mV' ;
      sgSteps.Cells[1,i] := '0 ' + StepUnits[i];
      StepActTauVh := i ;

      Inc(i) ;
      sgSteps.Cells[0,i] := 'Act.Tau' ;
      StepUnits[i] := '%' ;
      sgSteps.Cells[1,i] := '0 ' + StepUnits[i];
      StepActTau := i ;

      Inc(i) ;
      sgSteps.Cells[0,i] := 'Inact.V1/2(ss)' ;
      StepUnits[i] := 'mV' ;
      sgSteps.Cells[1,i] := '0 ' + StepUnits[i];
      StepInactSSVh := i ;

      Inc(i) ;
      sgSteps.Cells[0,i] := 'Inact.V1/2(tau)' ;
      StepUnits[i] := 'mV' ;
      sgSteps.Cells[1,i] := '0 ' + StepUnits[i];
      StepInactTauVh := i ;

      Inc(i) ;
      sgSteps.Cells[0,i] := 'Inact.Tau' ;
      StepUnits[i] := '%' ;
      sgSteps.Cells[1,i] := '0 ' + StepUnits[i];
      StepInactTau := i ;

      sgSteps.RowCount := i + 1 ;

      rbNoIncrements.Checked := True ;
      rbIncrementAfterProtocol.Checked := False ;
      rbIncrementAfterRecord.Checked := False ;

      // Activation parameter (m) constants
      edMSSVHalf.Value := 30.0 ;
      edMSSVSlope.Value := 10.0 ;
      edMTauMin.Value := 2.0 ;
      edMTauMax.Value :=  5.0 ;
      edMTauVHalf.Value := 30 ;
      edMTauVslope.Value := 10.0 ;

      // Inactivation parameter (h) constants
      edHSSVHalf.Value := 10.0 ;
      edHSSVSlope.Value :=  -10.0 ;

      edHTauFVHalf.Value := 30.0 ;
      edHTauFVslope.Value := 10.0 ;
      edHTauFMin.Value := 5.0 ;
      edHTauFMax.Value := 10.0 ;

      edHTauSVHalf.Value := 30.0 ;
      edHTauSVslope.Value := 10.0 ;
      edHTauSMin.Value := 10.0 ;
      edHTauSMax.Value := 20.0 ;

      edHFastFraction.Value := 0.5 ;

      ckEnableInhibitInput.Checked := false ;

      LoadSettingsFile( INIFileName ) ;

      // Open COM link to DCLAMP
     OpenDCLAMP ;

     cbPlot.Clear ;
     cbPlot.Items.Add('Steady states vs V') ;
     cbPlot.Items.Add('Time constants vs V') ;
     cbPlot.ItemIndex := 0 ;

     // Update of dynamic clamp
     UpdateDClamp ;
//     UpdatesEnabled := True ;

     end;


procedure TDClampFrm.UpdateDCLAMP ;
// ------------------------------------
// Send all parameters to dynamic clamp
// ------------------------------------
var
    s : string ;
begin

     WCPFile.WriteToLogFile('DCLAMP: Update');
     SetConductance( edGMax.Value ) ;
     SetParameter( 'VRV=', edVrev.Value) ;
     s := format( 'Gmax=%.3gnS, Vrev=%.3gmV',
                  [edGMax.Value,edVrev.Value]);
     WCPFile.WriteToLogFile(s) ;

     // Activation
     SetParameter('MVH=', edMSSVHalf.Value ) ;
     SetParameter('MVS=', edMSSVSlope.Value ) ;
     SetParameter('MTMN=', edMTauMin.Value ) ;
     SetParameter('MTMX=', edMTauMax.Value ) ;
     SetParameter('MTVH=', edMTauVHalf.Value ) ;
     SetParameter('MTVS=', edMTauVSlope.Value ) ;

     s := format( 'Act: Minf{V}= 1/(1-exp{-(V - V½)/Vslp}). V½=%.3g, Vslp=%.3gmV',
                  [edMSSVHalf.Value,edMSSVSlope.Value]);
     WCPFile.WriteToLogFile(s) ;
     s := format( 'Act: TauM{V}= TauMin + (TauMax - TauMin)exp{-((V - V½)/Vslp)^2}. TauMin=%.3g, TauMax=%.3gms, V½=%.3g, Vslp=%.3gmV',
                  [edMTauMin.Value,edMTauMax.Value,edMTauVHalf.Value,edMTauVSlope.Value]);
     WCPFile.WriteToLogFile(s) ;

     // Inactivation
     SetParameter('HVH=', edHSSVHalf.Value ) ;
     SetParameter('HVS=', edHSSVSlope.Value ) ;

     SetParameter('HTFMN=', edHTauFMin.Value ) ;
     SetParameter('HTFMX=', edHTauFMax.Value ) ;
     SetParameter('HTFVH=', edHTauFVHalf.Value ) ;
     SetParameter('HTFVS=', edHTauFVSlope.Value ) ;

     SetParameter('HTSMN=', edHTauSMin.Value ) ;
     SetParameter('HTSMX=', edHTauSMax.Value ) ;
     SetParameter('HTSVH=', edHTauSVHalf.Value ) ;
     SetParameter('HTSVS=', edHTauSVSlope.Value ) ;

     SetParameter( 'HTFF=', edHFastFraction.Value) ;

     s := format( 'Inact: Hinf{V}= 1/(1-exp{-(V - V½)/Vslp}). V½=%.3g, Vslp=%.3gmV',
                  [edHSSVHalf.Value,edHSSVSlope.Value]);
     WCPFile.WriteToLogFile(s) ;

     s := format( 'Inact: TauHfast{V}= TauMin + (TauMax - TauMin)exp{-((V - V½)/Vslp)^2}. TauMin=%.3g, TauMax=%.3gms, V½=%.3g, Vslp=%.3gmV',
                  [edHTauFMin.Value,edHTauFMax.Value,edHTauFVHalf.Value,edHTauFVSlope.Value]);
     WCPFile.WriteToLogFile(s) ;

     s := format( 'Inact: TauHslow{V}= TauMin + (TauMax - TauMin)exp{-((V - V½)/Vslp)^2}. TauMin=%.3g, TauMax=%.3gms, V½=%.3g, Vslp=%.3gmV',
                  [edHTauSmin.Value,edHTauSMax.Value,edHTauSVHalf.Value,edHTauSVSlope.Value]);
     WCPFile.WriteToLogFile(s) ;

     s := format('Inact: Fast Fraction=%.3g',[edHFastFraction.Value]);
     WCPFile.WriteToLogFile(s) ;

     if ckEnableInhibitInput.Checked then SetParameter( 'VIH=',2.5)
                                     else SetParameter( 'VIH=',11.0) ;

     StepCounter := 0 ;
     RecordCounter := 0 ;

     UpdateTicks := (45*1000) div Timer1.Interval ;
     UpdateTicksMax := UpdateTicks ;
     UpdateStatus := 'Conductance model updated' ;

     end ;


procedure TDClampFrm.Initialise ;
// -------------------------------------
// Initialise parameter increment series
// -------------------------------------
begin
    StepCounter := 0 ;
    RecordCounter := 0 ;
    IncrementModelParameters ;
    end;

procedure TDClampFrm.NextProtocol ;
// ------------------------
// Increment after protocol
// ------------------------
begin
    if rbIncrementAfterProtocol.Checked then begin
       Inc(StepCounter) ;
       IncrementModelParameters ;
       RecordCounter := 0 ;
       end ;
    end;


procedure TDClampFrm.NextRecord ;
// --------------------------
// Increment after nth record
// --------------------------
begin
    if rbIncrementAfterRecord.Checked then begin
       Inc(RecordCounter) ;
       if RecordCounter >= Round(edNumRecords.Value) then begin
          Inc(StepCounter) ;
          IncrementModelParameters ;
          RecordCounter := 0 ;
          end;
       end;
    end;


procedure TDClampFrm.IncrementModelParameters ;
// -------------------------------------------
// Increment model parameters to next level
// -------------------------------------------
var
    StepValue,StepSize : single ;
    LogMessage : string ;
begin

    LogMessage := '' ;

    Status := format('DC Step %d: ',[StepCounter]) ;
    LogMessage := Status ;

    // Gmax
    StepSize := GetStepSize(StepGMax) ;
    if StepSize <> 0.0 then begin
       StepValue := (100.0 + StepSize*StepCounter)*0.01 ;
       SetConductance( edGMax.Value*StepValue ) ;
       LogMessage := LogMessage + format('GMax=%.4gnS ',[edGMax.Value*StepValue]);
       UpdateTicks := (5*1000) div Timer1.Interval ;
       end;

    // Activation steady-state V1/2
    StepSize := GetStepSize(StepActSSVh) ;
    if StepSize <> 0.0 then begin
       StepValue := StepSize*StepCounter ;
       SetParameter('MVH=', edMSSVHalf.Value + StepValue ) ;
       LogMessage := LogMessage + format('Act: V½(ss)=%.4g ',[edMSSVHalf.Value + StepValue]);
       UpdateTicks := (45*1000) div Timer1.Interval ;
       end ;

    // Activation time constant V1/2
    StepSize := GetStepSize(StepActTauVh) ;
    if StepSize <> 0.0 then begin
       StepValue := StepSize*StepCounter ;
       SetParameter('MTVH=', edMTauVHalf.Value + StepValue ) ;
       LogMessage := LogMessage + format('Act: V½(tau)=%.4g ',[edMTauVHalf.Value + StepValue]);
       UpdateTicks := (45*1000) div Timer1.Interval ;
       end ;

    // Activation time constant size
    StepSize := GetStepSize(StepActTau) ;
    if StepSize <> 0.0 then begin
       StepValue := (100.0 + StepSize*StepCounter)*0.01 ;
       SetParameter('MTMN=', edMTauMin.Value*StepValue ) ;
       SetParameter('MTMX=', edMTauMax.Value*StepValue ) ;
       LogMessage := LogMessage + format('Act: Min(Tau)=%.4g, Max(Tau)=%.4g ms',
                                  [edMTauMin.Value*StepValue,edMTauMax.Value*StepValue]);
       UpdateTicks := (45*1000) div Timer1.Interval ;
       end ;

    // Inactivation steady-state V1/2
    StepSize := GetStepSize(StepInactSSVh) ;
    if StepSize <> 0.0 then begin
       StepValue := StepSize*StepCounter ;
       SetParameter('HVH=', edHSSVHalf.Value + StepValue ) ;
       LogMessage := LogMessage + format('Inact: V½(ss)=%.4g ',[edHSSVHalf.Value + StepValue]);
       UpdateTicks := (45*1000) div Timer1.Interval ;
       end ;

    // Inactivation time constant V1/2
    StepSize := GetStepSize(StepInactTauVh) ;
    if StepSize <> 0.0 then begin
       StepValue := StepSize*StepCounter ;
       SetParameter('HTFVH=', edHTauFVHalf.Value + StepValue ) ;
       SetParameter('HTSVH=', edHTauSVHalf.Value + StepValue ) ;
       LogMessage := LogMessage + format('Inact: V½(TauF)=%.4g, V½(TauS)=%.4g mV',
                                  [edHTauFVHalf.Value + StepValue,edHTauSVHalf.Value + StepValue]);
       UpdateTicks := (45*1000) div Timer1.Interval ;
       end ;

    // Inactivation time constant size
    StepSize := GetStepSize(StepInactTau) ;
    if StepSize <> 0.0 then begin
       StepValue := (100.0 + StepSize*StepCounter)*0.01 ;
       SetParameter('HTFMN=', edHTauFMin.Value*StepValue ) ;
       SetParameter('HTFMX=', edHTauFMax.Value*StepValue ) ;
       SetParameter('HTSMN=', edHTauSMin.Value*StepValue )  ;
       SetParameter('HTSMX=', edHTauSMax.Value*StepValue ) ;
       LogMessage := LogMessage + format('Inact: Min(TauF)=%.4g, Max(TauF)=%.4g, Min(TauS)=%.4g, Max(TauS)=%.4g ms',
                             [edHTauFMin.Value*StepValue,
                              edHTauFMax.Value*StepValue,
                              edHTauSMin.Value*StepValue,
                              edHTauSMax.Value*StepValue]);
       UpdateTicks := (45*1000) div Timer1.Interval ;
       end ;

    WCPFile.WriteToLogFile(LogMessage) ;

    UpdateTicksMax := UpdateTicks ;
    UpdateStatus := LogMessage ;

    end;


function TDClampFrm.GetStepSize(
         iPar : Integer ) : single ;
// ---------------------------------------------------
// Get size of step for parameter iPar from step table
// ---------------------------------------------------
var
    i,iChar : Integer ;
    sIn,sNum : string ;
begin
    sIn := sgSteps.Cells[1,iPar] ;
    sNum := '' ;
    for i := 1 to Length(sIn) do if TCharacter.IsNumber(sIn[i]) or
        (sIn[i] = '-') or (sIn[i] = '+') or (sIn[i] = '.') then sNum := sNum + sIn[i] ;
    if sNum <> '' then begin
       Val( sNum,Result,iChar) ;
       if iChar <> 0 then Result := 0.0 ;
       end
    else Result := 0.0 ;

    sgSteps.Cells[1,iPar] := format('%.3g %s',[Result,StepUnits[iPar]]);
    end;


procedure TDClampFrm.SetConductance( G : Single ) ;
// ----------------
// Set conductance
// ----------------
begin

    if rbOff.checked then G := 0.0
    else if rbAdd.checked then G := -G ;
    GMax := G ;

    G := G*1E-9 ; // Convert to Seimens
    G := G/edCurrentCommandScaleFactor.Value ; // Scale by A/V conversion factor
    G := G*0.1 ;  // Divide by 10 to account for 10X scaling of membrane potential signal
    SetParameter( 'GMX=', G) ;

    UpdateTicks := (5*1000) div Timer1.Interval ;
    UpdateTicksMax := UpdateTicks ;
    UpdateStatus := format('Gmax=%.4g nS',[GMax]) ;

    end ;


procedure TDClampFrm.PlotGraph ;
//
// Plot steady-state or time constant vs voltage graph
// ---------------------------------------------------
var
    i : integer ;
    X,DX,V : Single ;
      ss_m,tau_m,ss_h,tauS_h,tauF_h : single ;
      m,mPower : Single ;
      temp : single ;

begin

     plPlot.xAxisAutoRange := False ;
     plPlot.xAxisMin := -100.0 ;
     plPlot.xAxisMax := 50.0 ;
     plPlot.xAxisTick := 10. ;
     plPlot.yAxisAutoRange := True ;
     plPlot.xAxisLabel := 'Membrane Pot. (mV) ' ;

     { Clear data points line }
     plPlot.ClearAllLines ;
     plPlot.CreateLine( 0 , clBlue, msOpenSquare, psSolid ) ;
     plPlot.CreateLine( 1 , clRed, msOpenSquare, psSolid ) ;
     plPlot.CreateLine( 2 , clGreen, msOpenSquare, psSolid ) ;

     X := plPlot.xAxisMin ;
     DX := 2.0 ;
     while X <= plPlot.xAxisMax do begin

         // Rates
         V := X ;

         SS_m := 1.0 / ( 1.0 + exp(-(V-edMSSVHalf.Value)/edMSSVSlope.Value)) ;
         temp := (V-edMTauVHalf.Value)/edMTauVSlope.Value ;
         Tau_m := edMTauMin.Value
                  + (edMTauMax.Value - edMTauMin.Value)*exp(-temp*temp) ;

         SS_h := 1.0 / ( 1.0 + exp(-(V-edHSSVHalf.Value)/edHSSVSlope.Value)) ;
         temp := (V-edHTauFVHalf.Value)/edHTauFVSlope.Value ;
         TauF_h := edHTauFMin.Value +
                 (edHTauFMax.Value - edHTauFMin.Value)*exp(-temp*temp) ;
         temp := (V-edHTauSVHalf.Value)/edHTauSVSlope.Value ;
         TauS_h := edHTauSMin.Value +
                 (edHTauSMax.Value - edHTauSMin.Value)*exp(-temp*temp) ;

         case cbPlot.ItemIndex of
             SteadyStatesPlot : begin
                m := SS_m ;
                mPower := 1.0 ;
                // Raise m to power
                for i := 1 to Round(edmPower.Value) do mPower := mPower*m ;
                plPlot.AddPoint(0, X, mPower )  ;
                plPlot.AddPoint(1, X, SS_h )  ;
                plPlot.yAxisLabel := 'Steady state' ;
                plPlot.xAxisLabel := 'Membrane Pot. (mV) (Blue=Activation, Red=Inactivation)' ;
                plPlot.YAxisLaw := axLinear ;
                end ;
             TimeConstantsPlot : begin
                plPlot.AddPoint(0, X, Tau_m )  ;
                plPlot.AddPoint(1, X, Tauf_h )  ;
                plPlot.AddPoint(2, X, Taus_h )  ;
                plPlot.yAxisLabel := 'Time constants (ms)' ;
                plPlot.xAxisLabel := 'Membrane Pot. (mV) (Blue=Activation, Red=Inact (fast), Green=Inact (slow))' ;
                plPlot.YAxisLaw := axLog ;
                end ;

             end ;

         X := X + dx ;

         end ;
     end ;


procedure TDClampFrm.FormClose(Sender: TObject; var Action: TCloseAction);
// ----------------------------
// Tidy up when form is closed
// ----------------------------
begin

    // Close COM link to DCLAMP
    CloseDCLAMP ;

    SAveSettingsFile( INIFileName ) ;

    Action := caFree ;

    end;


function TDClampFrm.OpenDCLAMP : Boolean ;
// ---------------------------------------------------
// Establish communications with DCLAMP via COM port
// ---------------------------------------------------
var
   DCB : TDCB ;           { Device control block for COM port }
   CommTimeouts : TCommTimeouts ;
begin

     Result := False ;

     { Open com port  }
     ComHandle :=  CreateFile( PCHar(format('COM%d',[cbCOMport.ItemIndex+1])),
                     GENERIC_READ or GENERIC_WRITE,
                     0,
                     Nil,
                     OPEN_EXISTING,
                     FILE_ATTRIBUTE_NORMAL,
                     0) ;

     if ComHandle < 0 then Exit ;

     { Get current state of COM port and fill device control block }
     GetCommState( ComHandle, DCB ) ;
     { Change settings to those required for 1902 }
     DCB.BaudRate := CBR_9600 ;
     DCB.ByteSize := 8 ;
     DCB.Parity := NOPARITY ;
     DCB.StopBits := ONESTOPBIT ;

     { Update COM port }
     SetCommState( ComHandle, DCB ) ;

     { Initialise Com port and set size of transmit/receive buffers }
     SetupComm( ComHandle, 4096, 4096 ) ;

     { Set Com port timeouts }
     GetCommTimeouts( ComHandle, CommTimeouts ) ;
     CommTimeouts.ReadIntervalTimeout := $FFFFFFFF ;
     CommTimeouts.ReadTotalTimeoutMultiplier := 0 ;
     CommTimeouts.ReadTotalTimeoutConstant := 0 ;
     CommTimeouts.WriteTotalTimeoutMultiplier := 0 ;
     CommTimeouts.WriteTotalTimeoutConstant := 5000 ;
     SetCommTimeouts( ComHandle, CommTimeouts ) ;
     Result := True ;

     end ;


procedure TDCLAMPFrm.PageChange(Sender: TObject);
begin
     if Page.ActivePage = GraphsTab then PlotGraph ;
     end;


procedure TDCLAMPFrm.rbAddClick(Sender: TObject);
begin
    SetConductance( edGMax.Value ) ;
    end;


procedure TDCLAMPFrm.rbOffClick(Sender: TObject);
// ------------------------------
// Conductance clamp mode changed
// ------------------------------
begin
    SetConductance( edGMax.Value ) ;
    end;


procedure TDCLAMPFrm.rbSubtractClick(Sender: TObject);
begin
    SetConductance( edGMax.Value ) ;
    end;


procedure TDCLAMPFrm.bCopyToClipboardClick(Sender: TObject);
// ----------------------------
// Copy graph data to clipboard
// ----------------------------
begin
    plplot.CopyDataToClipboard ;
    end;

procedure TDCLAMPFrm.bLoadSettingsClick(Sender: TObject);
// ----------------------------
// Load settings from .DCS file
// ----------------------------
begin
     OpenDialog.options := [ofPathMustExist] ;
     OpenDialog.DefaultExt := 'DCS' ;
     OpenDialog.Filter := ' DCS Files (*.DCS)|*.DCS';
     OpenDialog.Title := 'Load Settings ' ;
     OpenDialog.InitialDir := WCPFile.SettingsDirectory ;

     if OpenDialog.execute then LoadSettingsFile( OpenDialog.FileName ) ;

     end ;


procedure TDCLAMPFrm.bResetClick(Sender: TObject);
// --------------------
// Reset dynamic clamp
// --------------------
begin
    UpdateDClamp ;
    end;


procedure TDCLAMPFrm.bSaveSettingsClick(Sender: TObject);
// ----------------------------
// Save settings to .DCS file
// ----------------------------
begin
     { Present user with standard Save File dialog box }
     SaveDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     SaveDialog.DefaultExt := 'DCS' ;
     SaveDialog.Filter := ' DCS Files (*.DCS)|*.DCS' ;
     SaveDialog.Title := 'Save Settings' ;
     SaveDialog.InitialDir := WCPFile.SettingsDirectory ;

     if SaveDialog.execute then SaveSettingsFile( SaveDialog.FileName ) ;

     end;


procedure TDCLAMPFrm.cbPlotChange(Sender: TObject);
// -----------------------
// Graph selection changed
// -----------------------
begin
     PlotGraph ;
     end;


procedure TDClampFrm.CloseDCLAMP ;
// -----------------------------------
// Close serial COM linke to CED 1902
// -----------------------------------
begin
     if ComHandle >= 0 then CloseHandle( ComHandle ) ;
     ComHandle := -1 ;
     end ;


procedure TDClampFrm.SetParameter(
          ParName : String ;
          Value : Single ) ;
// -------------------------
// Send parameter to DCLAMP
//--------------------------
var
    s : String ;
begin
    s := format( '%s%.6g',[ParName,Value] );
    TransmitLine(s) ;
    OutputDebugString(Pchar(s)) ;
    end ;


procedure TDCLAMPFrm.sgStepsKeyPress(Sender: TObject; var Key: Char);
var
    i : Integer ;
    Temp : Single ;
begin
    if Key = #13 then begin
        for i := 0 to sgSteps.RowCount-1 do Temp := GetStepSize(i) ;
        end;
    end;

procedure TDCLAMPFrm.Timer1Timer(Sender: TObject);
begin
    UpdateTicks := Max(UpdateTicks-1,0) ;
    edStatus.Text := UpdateStatus ;
    if UpdateTicks > 0 then
       edStatus.Text := edStatus.Text + format(' (Updating %.0f%%)',
                                        [((UpdateTicksMax-UpdateTicks)*100.0)/UpdateTicksMax]);

    end;

procedure TDClampFrm.TransmitLine(
          const Line : string   { Text to be sent to Com port }
          ) ;
{ --------------------------------------
  Write a line of ASCII text to Com port
  --------------------------------------}
var
   i,nC : Integer ;
   nWritten : DWORD ;
   aLine : ANSIString ;
   xBuf : array[0..258] of ANSIchar ;
   Overlapped : Pointer ; //POverlapped ;
   OK : Boolean ;
begin
     { Copy command line to be sent to xMit buffer and and a CR character }
     aLine := ANSIString(Line) ;
     nC := Length(aLine) ;
     for i := 1 to nC do xBuf[i-1] := aLine[i] ;
     xBuf[nC] := #13 ;
     Inc(nC) ;
     xBuf[nC] := #10 ;
     Inc(nC) ;

    Overlapped := Nil ;
    OK := WriteFile( ComHandle, xBuf, nC, nWritten, Overlapped ) ;
    if (not OK) or (nWRitten <> nC) then
        ShowMessage( ' Error writing to COM port ' ) ;
     end ;


function TDClampFrm.ReceiveLine : string ;          { Return line of bytes received }
{ -------------------------------------------------------
  Read bytes from Com port until a line has been received
  -------------------------------------------------------}
const
     TimeOut = 500 ;
var
   Line : ANSIstring ;
   rBuf : array[0..1] of ANSIchar ;
   ComState : TComStat ;
   PComState : PComStat ;
   TimeOutTickCount : LongInt ;
   ComError,NumBytesRead : DWORD ;
   //OverLapStructure : POVERLAPPED ;
begin
     { Set time that ReceiveLine will give up at if a full line has not
       been received }
     TimeOutTickCount := GetTickCount + TimeOut ;

     PComState := @ComState ;
     Line := '' ;
     repeat
        rBuf[0] := ' ' ;
        { Find out if there are any characters in receive buffer }
        ClearCommError( ComHandle, ComError, PComState )  ;
        NumBytesRead := 0 ;
        if ComState.cbInQue > 0 then begin
           ReadFile( ComHandle,
               rBuf,
               1,
               NumBytesRead,
               OverlapStructure ) ;
           end ;

        if NumBytesRead > 0 then begin
           if (rBuf[0] <> #13) and (rBuf[0]<>#10) then
        Line := Line + rBuf[0] ;
           end ;
        until (rBuf[0] = #13) or (GetTickCount >= TimeOutTickCount) ;
     Result := String(Line) ;
     end ;


procedure TDClampFrm.LoadSettingsFile( const IniFileName : string ) ;
{ ---------------------------------------------------------
  Read Initialization file to get initial program settings,
  ---------------------------------------------------------}
var
   Header : TStringList ;
   i : Integer ;
   Value : Single ;
begin

     if not FileExists( IniFileName ) then Exit ;

     // Create file header Name=Value string list
     Header := TStringList.Create ;

     // Load list from file
     Header.LoadFromFile( IniFileName ) ;

     edGMax.Value := WCPFile.GetKeyValue( Header, 'GMX=', edGMax.Value) ;

     edNumRecords.Value := WCPFile.GetKeyValue( Header, 'NUMREPS=', edNumRecords.Value) ;

     edVrev.Value := WCPFile.GetKeyValue( Header, 'VRV=', edVrev.Value) ;

     edMSSVhalf.Value := WCPFile.GetKeyValue( Header, 'MVH=', edMSSVhalf.Value) ;

     edMSSVslope.Value := WCPFile.GetKeyValue( Header, 'MVS=', edMSSVslope.Value) ;

     edMTauVhalf.Value := WCPFile.GetKeyValue( Header, 'MTVH=', edMTauVhalf.Value) ;

     edMTauVslope.Value := WCPFile.GetKeyValue( Header, 'MTVS=', edMTauVslope.Value) ;

     edMTauMin.Value := WCPFile.GetKeyValue( Header, 'MTMN=', edMTauMin.Value) ;

     edMTauMax.Value := WCPFile.GetKeyValue( Header, 'MTMX=', edMTauMax.Value) ;

     edHSSVhalf.Value := WCPFile.GetKeyValue( Header, 'HVH=', edHSSVhalf.Value) ;

     edHSSVslope.Value := WCPFile.GetKeyValue( Header, 'HVS=', edHSSVslope.Value) ;

     edHTauFVhalf.Value := WCPFile.GetKeyValue( Header, 'HTFVH=', edHTauFVhalf.Value) ;

     edHTauFVslope.Value := WCPFile.GetKeyValue( Header, 'HTFVS=', edHTauFVslope.Value) ;

     edHTauFMin.Value := WCPFile.GetKeyValue( Header, 'HTFMN=', edHTauFMin.Value) ;

     edHTauFMax.Value := WCPFile.GetKeyValue( Header, 'HTFMX=', edHTauFMax.Value) ;

     edHTauSVhalf.Value := WCPFile.GetKeyValue( Header, 'HTSVH=', edHTauSVhalf.Value ) ;

     edHTauSVslope.Value := WCPFile.GetKeyValue( Header, 'HTSVS=', edHTauSVslope.Value) ;

     edHTauSMin.Value := WCPFile.GetKeyValue( Header, 'HTSMN=', edHTauSMin.Value) ;

     edHTauSMax.Value := WCPFile.GetKeyValue( Header, 'HTSMX=', edHTauSMax.Value) ;

     edHFastFraction.Value := WCPFile.GetKeyValue( Header, 'HTFF=', edHFastFraction.Value ) ;

     edmPower.Value := WCPFile.GetKeyValue( Header, 'P=', edmPower.Value ) ;

     ckEnableInhibitInput.Checked := WCPFile.GetKeyValue( Header, 'ENINH=', ckEnableInhibitInput.Checked ) ;

     edCurrentCommandScaleFactor.Value := WCPFile.GetKeyValue( Header, 'CCSF=', edCurrentCommandScaleFactor.Value) ;

     for i := 0 to sgSteps.RowCount-1 do
         begin
         Value := WCPFile.GetKeyValue( Header, format('STEPSIZE%d=',[i]), 0.0 ) ;
         sgSteps.Cells[1,i] := format('%.4g %s',[Value,StepUnits[i]]) ;
         end;

     // Dispose of list
     Header.Free ;

     end ;


procedure TDClampFrm.SaveSettingsFile( const IniFileName : string ) ;
{ --------------------------------------------
  Save program settings to Initialization file
  --------------------------------------------}
var
   Header : TStringList ;
   i : Integer ;
begin

     // Create file header Name=Value string list
     Header := TStringList.Create ;

     WCPFile.AddKeyValue( Header, 'GMX=', edGMax.Value) ;
     WCPFile.AddKeyValue( Header, 'NUMREPS=', edNumRecords.Value );
     WCPFile.AddKeyValue( Header, 'STEPPAR=', SteppedParameter );

     WCPFile.AddKeyValue( Header, 'VRV=', edVrev.Value) ;
     WCPFile.AddKeyValue( Header, 'MVH=', edMSSVHalf.Value) ;
     WCPFile.AddKeyValue( Header, 'MVS=', edMSSVSlope.Value) ;
     WCPFile.AddKeyValue( Header, 'MTMN=', edMTauMin.Value) ;
     WCPFile.AddKeyValue( Header, 'MTMX=', edMTauMax.Value) ;
     WCPFile.AddKeyValue( Header, 'MTVH=', edMTauVHalf.Value) ;
     WCPFile.AddKeyValue( Header, 'MTVS=', edMTauVSlope.Value) ;

     WCPFile.AddKeyValue( Header, 'HVH=', edHSSVHalf.Value) ;
     WCPFile.AddKeyValue( Header, 'HVS=', edHSSVSlope.Value) ;

     WCPFile.AddKeyValue( Header, 'HTFMN=', edHTauFMin.Value) ;
     WCPFile.AddKeyValue( Header, 'HTFMX=', edHTauFMax.Value) ;
     WCPFile.AddKeyValue( Header, 'HTFVH=', edHTauFVHalf.Value) ;
     WCPFile.AddKeyValue( Header, 'HTFVS=', edHTauFVSlope.Value) ;

     WCPFile.AddKeyValue( Header, 'HTSMN=', edHTauSMin.Value) ;
     WCPFile.AddKeyValue( Header, 'HTSMX=', edHTauSMax.Value) ;
     WCPFile.AddKeyValue( Header, 'HTSVH=', edHTauSVHalf.Value) ;
     WCPFile.AddKeyValue( Header, 'HTSVS=', edHTauSVSlope.Value) ;

     WCPFile.AddKeyValue( Header, 'HTFF=', edHFastFraction.Value) ;

     WCPFile.AddKeyValue( Header, 'P=', edmPower.Value) ;

     WCPFile.AddKeyValue( Header, 'ENINH=', ckEnableInhibitInput.Checked ) ;

     WCPFile.AddKeyValue( Header, 'CCSF=', edCurrentCommandScaleFactor.Value) ;

     for i := 0 to sgSteps.RowCount-1 do begin
         WCPFile.AddKeyValue( Header, format('STEPSIZE%d=',[i]), GetStepSize(i)) ;
         end;

     // Save list to file
     Header.SaveToFile( IniFileName ) ;

     Header.Free ;

     end ;



end.
