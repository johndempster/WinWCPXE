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

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, XYPlotDisplay,
  Vcl.StdCtrls, HTMLLabel, ValidatedEdit, Vcl.ComCtrls, math, shared ;

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
    cbComPort: TComboBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    edGMax: TValidatedEdit;
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
    edStatus: TEdit;
    bReset: TButton;
    GraphsTab: TTabSheet;
    plPlot: TXYPlotDisplay;
    cbPlot: TComboBox;
    Timer1: TTimer;
    Label3: TLabel;
    edVrev: TValidatedEdit;
    Label7: TLabel;
    edCurrentCommandScaleFactor: TValidatedEdit;
    rbGmaxFixed: TRadioButton;
    rbGMaxSteps: TRadioButton;
    PanGmaxSteps: TPanel;
    edGMaxStepSize: TValidatedEdit;
    Label4: TLabel;
    Label5: TLabel;
    edGMaxNumSteps: TValidatedEdit;
    Label6: TLabel;
    edGMaxNumRepeats: TValidatedEdit;
    bLoadSettings: TButton;
    bSaveSettings: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
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
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbGmaxFixedClick(Sender: TObject);
    procedure rbGMaxStepsClick(Sender: TObject);
    procedure bLoadSettingsClick(Sender: TObject);
    procedure bSaveSettingsClick(Sender: TObject);
  private
    { Private declarations }
    ComHandle : Integer ;
    OverLapStructure : POverlapped ;
    INIFileName : String ;
    UpdatesEnabled : Boolean ;
    UpdateCounter : Integer ;
    StepNumber : Integer ;             // Gmax step number (in steps mode)
    RepeatNumber : Integer ;           // Gmax repeat number (in steps mode)

    function OpenDCLAMP : Boolean ;
    procedure CloseDCLAMP ;
    procedure SetParameter( ParName : String ; Value : Single ) ;
    procedure SetConductance ;
    procedure TransmitLine( const Line : string ) ;
    function  ReceiveLine : string ;
    procedure PlotGraph ;
    procedure LoadSettingsFile( const IniFileName : string ) ;
    procedure SaveSettingsFile( const IniFileName : string ) ;
    procedure UpdateDCLAMP ;

  public
    { Public declarations }
    GMax : single ;
    procedure NextGMaxStep( Initialise : Boolean ) ;
  end;

var
  DCLAMPFrm: TDCLAMPFrm;

implementation

{$R *.dfm}

uses MDIForm ;

procedure TDClampFrm.edGMaxKeyPress(Sender: TObject; var Key: Char);
// ---------
// Set Gmax
// ---------
begin
     if Key = #13 then begin
        UpdateDclamp ;
        //SetConductance ;
        end ;
     end;

procedure TDClampFrm.edCurrentCommandScaleFactorKeyPress(Sender: TObject; var Key: Char);
// ---------
// Set Vrev
// ---------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
//        SetParameter( 'VRV=', edVrev.Value) ;
        end ;
     end;


procedure TDClampFrm.edVrevKeyPress(Sender: TObject; var Key: Char);
// ---------
// Set Vrev
// ---------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
//        SetParameter( 'VRV=', edVrev.Value) ;
        end ;
     end;



procedure TDClampFrm.edMSSVhalfKeyPress(Sender: TObject; var Key: Char);
// -------------------------
// Set M steady state V half
// -------------------------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
   //     SetParameter( 'MVH=', edMSSVhalf.Value) ;
        end ;
     end;


procedure TDClampFrm.edMSSVslopeKeyPress(Sender: TObject; var Key: Char);
// ---------------------------
// Set M steady state V slope
// ---------------------------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
   //     SetParameter( 'MVS=', edMSSVslope.Value) ;
        end ;
     end;


procedure TDClampFrm.edMTauMinKeyPress(Sender: TObject; var Key: Char);
// ------------------
// Set M time constant min
// ------------------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
   //     SetParameter( 'MTMN=', edMTauMin.Value) ;
        end ;
     end;


procedure TDClampFrm.edMTauMaxKeyPress(Sender: TObject; var Key: Char);
// -----------------------
// Set H time constant max
// -----------------------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
   //     SetParameter( 'MTMX=', edMTauMax.Value) ;
        end ;
     end;


procedure TDClampFrm.edMTauVhalfKeyPress(Sender: TObject; var Key: Char);
// --------------------------
// Set M time constant V half
// --------------------------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
   //     SetParameter( 'MTVH=', edMTauVhalf.Value) ;
        end ;
     end;


procedure TDClampFrm.edMTauVSlopeKeyPress(Sender: TObject; var Key: Char);
// ------------------
// Set M time constant V slope
// ------------------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
   //     SetParameter( 'MTVS=', edMTauVSlope.Value) ;
        end ;
     end;


procedure TDClampFrm.edmPowerKeyPress(Sender: TObject; var Key: Char);
// ------------------
// Set m power factor
// ------------------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
   //     SetParameter( 'P', edmPower.Value) ;
        end ;
     end;

procedure TDClampFrm.edHFastFractionKeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Set H slow time constant V half
// --------------------------------
begin
     if Key = #13 then begin
         UpdateDCLAMP ;
//        SetParameter( 'HTFF=', edHFastFraction.Value) ;
        end ;
     end;


procedure TDClampFrm.edHSSVhalfKeyPress(Sender: TObject; var Key: Char);
// -------------------------
// Set H steady state V half
// -------------------------
begin
     if Key = #13 then begin
      UpdateDCLAMP ;
//        SetParameter( 'HVH=', edHSSVhalf.Value) ;
        end ;
     end;

procedure TDClampFrm.edHSSVslopeKeyPress(Sender: TObject; var Key: Char);
// ---------------------------
// Set H steady state V slope
// ---------------------------
begin
     if Key = #13 then begin
      UpdateDCLAMP ;
//        SetParameter( 'HVS=', edHSSVslope.Value) ;
        end ;
     end;


procedure TDClampFrm.edHTauFMinKeyPress(Sender: TObject; var Key: Char);
// ------------------
// Set H time constant min
// ------------------
begin
     if Key = #13 then begin
      UpdateDCLAMP ;
//        SetParameter( 'HTFMN=', edHTauFMin.Value) ;
        end ;
     end;


procedure TDClampFrm.edHTauFMaxKeyPress(Sender: TObject; var Key: Char);
// -----------------------
// Set H time constant max
// -----------------------
begin
     if Key = #13 then begin
      UpdateDCLAMP ;
//        SetParameter( 'HTFMX=', edHTauFMax.Value) ;
        end ;
     end;


procedure TDClampFrm.edHTauFVhalfKeyPress(Sender: TObject; var Key: Char);
// --------------------------
// Set H time constant V half
// --------------------------
begin
     if Key = #13 then begin
      UpdateDCLAMP ;
//        SetParameter( 'HTFVH=', edHTauFVhalf.Value) ;
        end ;
     end;




procedure TDClampFrm.edHTauFVslopeKeyPress(Sender: TObject; var Key: Char);
// ------------------
// Set H time constant V slope
// ------------------
begin
     if Key = #13 then begin
      UpdateDCLAMP ;
//        SetParameter( 'HTFVS=', edHTauFVSlope.Value) ;
        end ;
     end;


procedure TDClampFrm.edHTauSMaxKeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Set H slow time constant maximum
// --------------------------------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
       // SetParameter( 'HTSMX=', edHTauSMax.Value) ;
        end ;
     end;



procedure TDClampFrm.edHTauSMinKeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Set H slow time constant minimum
// --------------------------------
begin
     if Key = #13 then begin
         UpdateDCLAMP ;
        //SetParameter( 'HTSMN=', edHTauSMin.Value) ;
        end ;
     end;

procedure TDClampFrm.edHTauSVHalfKeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Set H slow time constant V half
// --------------------------------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
  //      SetParameter( 'HTSVH=', edHTauSVHalf.Value) ;
        end ;
     end;

procedure TDClampFrm.edHTauSVSlopeKeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Set H slow time constant V slope
// --------------------------------
begin
     if Key = #13 then begin
        UpdateDCLAMP ;
  //      SetParameter( 'HTSVS=', edHTauSVSlope.Value) ;
        end ;
     end;


procedure TDCLAMPFrm.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin
    UpdatesEnabled := False ;
    UpdateCounter := 0 ;
    StepNumber := 0 ;
    RepeatNumber := 0 ;
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
begin

     INIFileName := Main.SettingsDirectory + 'DCLAMP.INI' ;

      edGmax.Value := 4.0 ;
      edVrev.Value := 0.0 ;
      edGmaxStepSize.Value := 0.1 ;
      edGmaxNumSteps.Value := 10.0 ;
      rbGMaxFixed.Checked := True ;
      rbGMaxSteps.Checked := False ;
      PanGMaxSteps.Visible := not rbGMaxFixed.Checked ;

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

     // Request update of dynamic clamp
     UpdatesEnabled := True ;
     UpdateCounter := 0 ;

     // Update settings
     UpdateDClamp ;

     end;


procedure TDClampFrm.UpdateDCLAMP ;
// ------------------------------------
// Send all parameters to dynamic clamp
// ------------------------------------
begin

     SetConductance ;
     SetParameter( 'VRV=', edVrev.Value) ;

     // Activation
     SetParameter('MVH=', edMSSVHalf.Value ) ;
     SetParameter('MVS=', edMSSVSlope.Value ) ;
     SetParameter('MTMN=', edMTauMin.Value ) ;
     SetParameter('MTMX=', edMTauMax.Value ) ;
     SetParameter('MTVH=', edMTauVHalf.Value ) ;
     SetParameter('MTVS=', edMTauVSlope.Value ) ;

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

     if ckEnableInhibitInput.Checked then SetParameter( 'VIH=',2.5)
                                     else SetParameter( 'VIH=',11.0) ;

     //SetParameter( 'P', edmPower.Value) ;

     // Reset dynamic clamp to steady state
     //TransmitLine('R') ;

     end ;


procedure TDClampFrm.NextGMaxStep( Initialise : Boolean ) ;
// -------------------------------------------
// Increment maximum conductance to next level
// -------------------------------------------
begin

    if Initialise then begin
       StepNumber := 0 ;
       RepeatNumber := 0 ;
       end
    else begin
       Inc(RepeatNumber) ;
       if RepeatNumber >= Round(edGMaxNumRepeats.Value) then begin
          RepeatNumber := 0 ;
          Inc(StepNumber) ;

          end;
       if StepNumber >= Round(edGMaxNumSteps.Value) then StepNumber := 0 ;
       end ;

    SetConductance ;

    end;


procedure TDClampFrm.SetConductance ;
// ----------------
// Set conductance
// ----------------
var
    G : Single ;
begin

    G := edGMax.Value ;
    if rbGMaxSteps.checked then begin
       G := G + edGMaxStepSize.Value*Min(Max(StepNumber,0),Round(edGMaxNumSteps.Value)) ;
       end
    else begin
       StepNumber := 0 ;
       RepeatNumber := 0 ;
       end;

    if rbOff.checked then G := 0.0
    else if rbAdd.checked then G := -G ;
    GMax := G ;

    G := G*1E-9 ; // Convert to Seimens
    G := G/edCurrentCommandScaleFactor.Value ; // Scale by A/V conversion factor
    G := G*0.1 ;  // Divide by 10 to account for 10X scaling of membrane potential signal
    SetParameter( 'GMX=', G) ;

    edStatus.Text := format('Gmax=%.4g nS',[GMax]) ;

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


procedure TDCLAMPFrm.rbGmaxFixedClick(Sender: TObject);
begin
     PanGMaxSteps.Visible := not rbGMaxFixed.Checked ;
     end;

procedure TDCLAMPFrm.rbGMaxStepsClick(Sender: TObject);
begin
     PanGMaxSteps.Visible := not rbGMaxFixed.Checked ;
     end;

procedure TDCLAMPFrm.rbOffClick(Sender: TObject);
// ------------------------------
// Conductance clamp mode changed
// ------------------------------
begin
        SetConductance ;
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
     OpenDialog.InitialDir := Main.SettingsDirectory ;

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
     SaveDialog.InitialDir := Main.SettingsDirectory ;

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


procedure TDCLAMPFrm.Timer1Timer(Sender: TObject);
//
// Send parameters to dynamic clamp
//
begin

     if not UpdatesEnabled then Exit ;

     case UpdateCounter of
        0 : SetConductance ;
        1 : SetParameter( 'VRV=', edVrev.Value) ;

        2 : SetParameter('MVH=', edMSSVHalf.Value ) ;
        3 : SetParameter('MVS=', edMSSVSlope.Value ) ;
        4 : SetParameter('MTMN=', edMTauMin.Value ) ;
        5 : SetParameter('MTMX=', edMTauMax.Value ) ;
        6 : SetParameter('MTVH=', edMTauVHalf.Value ) ;
        7 : SetParameter('MTVS=', edMTauVSlope.Value ) ;

        8 : SetParameter('HVH=', edHSSVHalf.Value ) ;
        9 : SetParameter('HVS=', edHSSVSlope.Value ) ;
        10 : SetParameter('HTFMN=', edHTauFMin.Value ) ;
        11 : SetParameter('HTFMX=', edHTauFMax.Value ) ;
        12 : SetParameter('HTFVH=', edHTauFVHalf.Value ) ;
        13 : SetParameter('HTFVS=', edHTauFVSlope.Value ) ;
        14 : SetParameter('HTSMN=', edHTauSMin.Value ) ;
        15 : SetParameter('HTSMX=', edHTauSMax.Value ) ;
        16 : SetParameter('HTSVH=', edHTauSVHalf.Value ) ;
        17 : SetParameter('HTSVS=', edHTauSVSlope.Value ) ;
        18 : SetParameter('HTFF=',  edHFastFraction.Value) ;

        end ;

     if UpdateCounter < 18 then begin
        Inc(UpdateCounter) ;
        bReset.Enabled := False ;
        edStatus.Text := format('Updating %d/18',[UpdateCounter]) ;
        end
     else begin
        UpdatesEnabled := False ;
        UpdateCounter := 0 ;
        edStatus.Text := 'Ready' ;
        bReset.Enabled := True ;
        end ;

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
   Header : array[1..HeaderSize] of ANSIchar ;
   IniFileHandle : LongInt ;
   Value : Single ;
   bValue : Boolean ;
begin

     if not FileExists( IniFileName ) then Exit ;

     // Open initialisation settings file
     IniFileHandle := FileOpen( IniFileName, fmOpenRead ) ;
     if (IniFileHandle < 0) then Exit ;

     if FileRead( IniFileHandle, Header, Sizeof(Header)) > 0 then begin

        Value := edGMax.Value ;
        ReadFloat( Header, 'GMX=', Value) ;
        edGMax.Value := Value ;

        Value := edGMaxStepSize.Value ;
        ReadFloat( Header, 'GMXSTEPSIZE=', Value) ;
        edGMaxStepSize.Value := Value ;

        Value := edGMaxNumSteps.Value ;
        ReadFloat( Header, 'GMXNUMSTEPS=', Value) ;
        edGMaxNumSteps.Value := Value ;

        Value := edGMaxNumRepeats.Value ;
        ReadFloat( Header, 'GMXNUMREPS=', Value) ;
        edGMaxNumRepeats.Value := Value ;

        ReadLogical( Header, 'GMXFIXED=', bValue ) ;
        rbGMaxFixed.Checked := bValue ;
        rbGMaxSteps.Checked := not bValue ;
        PanGMaxSteps.Visible := not bValue ;

        Value := edVrev.Value ;
        ReadFloat( Header, 'VRV=', Value) ;
        edVrev.Value := Value ;

        Value := edMSSVhalf.Value ;
        ReadFloat( Header, 'MVH=', Value) ;
        edMSSVhalf.Value := Value ;

        Value := edMSSVslope.Value ;
        ReadFloat( Header, 'MVS=', Value) ;
        edMSSVslope.Value := Value ;

        Value := edMTauVhalf.Value ;
        ReadFloat( Header, 'MTVH=', Value) ;
        edMTauVhalf.Value := Value ;

        Value := edMTauVslope.Value ;
        ReadFloat( Header, 'MTVS=', Value) ;
        edMTauVslope.Value := Value ;

        Value := edMTauMin.Value ;
        ReadFloat( Header, 'MTMN=', Value) ;
        edMTauMin.Value := Value ;

        Value := edMTauMax.Value ;
        ReadFloat( Header, 'MTMX=', Value) ;
        edMTauMax.Value := Value ;

        Value := edHSSVhalf.Value ;
        ReadFloat( Header, 'HVH=', Value) ;
        edHSSVhalf.Value := Value ;

        Value := edHSSVslope.Value ;
        ReadFloat( Header, 'HVS=', Value) ;
        edHSSVslope.Value := Value ;

        Value := edHTauFVhalf.Value ;
        ReadFloat( Header, 'HTFVH=', Value) ;
        edHTauFVhalf.Value := Value ;

        Value := edHTauFVslope.Value ;
        ReadFloat( Header, 'HTFVS=', Value) ;
        edHTauFVslope.Value := Value ;

        Value := edHTauFMin.Value ;
        ReadFloat( Header, 'HTFMN=', Value) ;
        edHTauFMin.Value := Value ;

        Value := edHTauFMax.Value ;
        ReadFloat( Header, 'HTFMX=', Value) ;
        edHTauFMax.Value := Value ;

        Value := edHTauSVhalf.Value ;
        ReadFloat( Header, 'HTSVH=', Value) ;
        edHTauSVhalf.Value := Value ;

        Value := edHTauSVslope.Value ;
        ReadFloat( Header, 'HTSVS=', Value) ;
        edHTauSVslope.Value := Value ;

        Value := edHTauSMin.Value ;
        ReadFloat( Header, 'HTSMN=', Value) ;
        edHTauSMin.Value := Value ;

        Value := edHTauSMax.Value ;
        ReadFloat( Header, 'HTSMX=', Value) ;
        edHTauSMax.Value := Value ;

        Value := edHFastFraction.Value ;
        ReadFloat( Header, 'HTFF=', Value) ;
        edHFastFraction.Value := Value ;

        Value := edmPower.Value ;
        ReadFloat( Header, 'P=', Value) ;
        edmPower.Value := Value ;

        ReadLogical( Header, 'ENINH=', bValue ) ;
        ckEnableInhibitInput.Checked := bValue ;

        Value := edCurrentCommandScaleFactor.Value ;
        ReadFloat( Header, 'CCSF=', Value) ;
        edCurrentCommandScaleFactor.Value := Value ;

        UpdatesEnabled := True ;
        UpdateCounter := 0 ;

        end ;

     // Close file
     FileClose( IniFileHandle ) ;

     end ;


procedure TDClampFrm.SaveSettingsFile( const IniFileName : string ) ;
{ --------------------------------------------
  Save program settings to Initialization file
  --------------------------------------------}
var
   Header : array[1..HeaderSize] of ANSIchar ;
   i,IniFileHandle : Integer ;
begin

     IniFileHandle := FileCreate( IniFileName ) ;
     if IniFileHandle < 0 then begin
        ShowMessage('Unable to create ' + IniFileName) ;
        Exit ;
        end ;

     { Initialise empty buffer with zero bytes }
     for i := 1 to sizeof(Header) do Header[i] := chr(0) ;

     AppendFloat( Header, 'GMX=', edGMax.Value) ;
     AppendFloat( Header, 'GMXSTEPSIZE=', edGMaxStepSize.Value );
     AppendFloat( Header, 'GMXNUMSTEPS=', edGMaxNumSteps.Value );
     AppendFloat( Header, 'GMXNUMREPS=', edGMaxNumRepeats.Value );
     AppendLogical( Header, 'GMXFIXED=', rbGMaxFixed.Checked );

     AppendFloat( Header, 'VRV=', edVrev.Value) ;
     AppendFloat( Header, 'MVH=', edMSSVHalf.Value) ;
     AppendFloat( Header, 'MVS=', edMSSVSlope.Value) ;
     AppendFloat( Header, 'MTMN=', edMTauMin.Value) ;
     AppendFloat( Header, 'MTMX=', edMTauMax.Value) ;
     AppendFloat( Header, 'MTVH=', edMTauVHalf.Value) ;
     AppendFloat( Header, 'MTVS=', edMTauVSlope.Value) ;

     AppendFloat( Header, 'HVH=', edHSSVHalf.Value) ;
     AppendFloat( Header, 'HVS=', edHSSVSlope.Value) ;

     AppendFloat( Header, 'HTFMN=', edHTauFMin.Value) ;
     AppendFloat( Header, 'HTFMX=', edHTauFMax.Value) ;
     AppendFloat( Header, 'HTFVH=', edHTauFVHalf.Value) ;
     AppendFloat( Header, 'HTFVS=', edHTauFVSlope.Value) ;

     AppendFloat( Header, 'HTSMN=', edHTauSMin.Value) ;
     AppendFloat( Header, 'HTSMX=', edHTauSMax.Value) ;
     AppendFloat( Header, 'HTSVH=', edHTauSVHalf.Value) ;
     AppendFloat( Header, 'HTSVS=', edHTauSVSlope.Value) ;

     AppendFloat( Header, 'HTFF=', edHFastFraction.Value) ;

     AppendFloat( Header, 'P=', edmPower.Value) ;

     AppendLogical( Header, 'ENINH=', ckEnableInhibitInput.Checked ) ;

     AppendFloat( Header, 'CCSF=', edCurrentCommandScaleFactor.Value) ;

     if FileWrite(IniFileHandle,Header,Sizeof(Header)) <> Sizeof(Header) then
        ShowMessage(INIFileName + ' File Write - Failed ' ) ;
     FileClose( IniFileHandle ) ;

     end ;



end.
