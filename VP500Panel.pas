unit VP500Panel;
// ================================================
// VP500 patch clamp control panel
// (c) J. Dempster, University of Strathclyde, 2004
// ================================================
// 3.03.04
// 5.04.04
// 4.08.04 Holding current now set correctly in pA
//         Holding current/potentials remembered between mode switches
// 05.12.04 Junction potential up/down arrow buttons added

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ValidatedEdit, vp500Unit, vp500lib, SESLabIO, ExtCtrls,
  Spin ;

type
  TVP500PanelFrm = class(TForm)
    GroupBox1: TGroupBox;
    cbClampMode: TComboBox;
    GroupBox4: TGroupBox;
    cbLPFilter: TComboBox;
    GroupBox5: TGroupBox;
    cbAmplifierGain: TComboBox;
    GroupBox3: TGroupBox;
    cbLowHeadstageGain: TRadioButton;
    rbHeadStageGain: TRadioButton;
    HoldingVIGrp: TGroupBox;
    edHoldingVI: TValidatedEdit;
    GroupBox7: TGroupBox;
    edJunctionPotential: TValidatedEdit;
    GroupBox10: TGroupBox;
    GroupBox9: TGroupBox;
    Label4: TLabel;
    edPercentBoost: TValidatedEdit;
    GroupBox8: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    edPercentRs: TValidatedEdit;
    cbTauPercentRs: TComboBox;
    bAppyCompensation: TButton;
    GroupBox11: TGroupBox;
    GroupBox13: TGroupBox;
    Label6: TLabel;
    edCFast: TValidatedEdit;
    Label7: TLabel;
    edTauFast: TValidatedEdit;
    bCFastNeutralise: TButton;
    Label5: TLabel;
    GroupBox12: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    edCSlow: TValidatedEdit;
    edTauSlow: TValidatedEdit;
    bCSlowNeutralise: TButton;
    GroupBox14: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    edCCell: TValidatedEdit;
    edTauCell: TValidatedEdit;
    bCCellNeutralise: TButton;
    cbClampSpeed: TComboBox;
    lbClampSpeed: TLabel;
    bApplyHoldingIV: TButton;
    bApplyJunction: TButton;
    GroupBox2: TGroupBox;
    edSealResistance: TValidatedEdit;
    bCalcSealResistance: TButton;
    GroupBox6: TGroupBox;
    edRm: TValidatedEdit;
    edCm: TValidatedEdit;
    edRs: TValidatedEdit;
    Label2: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    bCalcCellParameters: TButton;
    GroupBox15: TGroupBox;
    bZap: TButton;
    edZapDuration: TValidatedEdit;
    Label14: TLabel;
    ckNeutraliseLeak: TCheckBox;
    GroupBox16: TGroupBox;
    bInitialise: TButton;
    bOptimiseNeutralisation: TButton;
    GroupBox17: TGroupBox;
    edStatus: TEdit;
    Timer: TTimer;
    spJunctionPotential: TSpinButton;
    procedure FormShow(Sender: TObject);
    procedure cbClampModeChange(Sender: TObject);
    procedure cbClampSpeedChange(Sender: TObject);
    procedure cbAmplifierGainChange(Sender: TObject);
    procedure cbLowHeadstageGainClick(Sender: TObject);
    procedure cbLPFilterChange(Sender: TObject);
    procedure bAppyCompensationClick(Sender: TObject);
    procedure edPercentRsKeyPress(Sender: TObject; var Key: Char);
    procedure edPercentBoostKeyPress(Sender: TObject; var Key: Char);
    procedure cbTauPercentRsChange(Sender: TObject);
    procedure edCFastKeyPress(Sender: TObject; var Key: Char);
    procedure bCFastNeutraliseClick(Sender: TObject);
    procedure bCSlowNeutraliseClick(Sender: TObject);
    procedure bCCellNeutraliseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bApplyHoldingIVClick(Sender: TObject);
    procedure edHoldingVIKeyPress(Sender: TObject; var Key: Char);
    procedure bApplyJunctionClick(Sender: TObject);
    procedure edJunctionPotentialKeyPress(Sender: TObject; var Key: Char);
    procedure bCalcSealResistanceClick(Sender: TObject);
    procedure bCalcCellParametersClick(Sender: TObject);
    procedure bInitialiseClick(Sender: TObject);
    procedure bZapClick(Sender: TObject);
    procedure bOptimiseNeutralisationClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure spJunctionPotentialUpClick(Sender: TObject);
    procedure spJunctionPotentialDownClick(Sender: TObject);
  private
    { Private declarations }
    HardwareConf : THardwareConf ;
    Neutralization : TNeutralization ;
    Compensations : TCompensations ;
    JunctionPotential : Single ;
    HoldingVI : Array[0..3] of Single ;

    procedure UpdateClampModeLabels ;
    procedure UpdateCompensations ;
    procedure UpdateNeutralization ;
    procedure GetNeutralizationSettings ;
    procedure SetHoldingVI ;
  public
    { Public declarations }
  end;

var
  VP500PanelFrm: TVP500PanelFrm;

implementation

uses Mdiform;

{$R *.dfm}

procedure TVP500PanelFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
var
    i,Err : Integer ;
begin

     // Initialise VP500 hardware if another interface is being
     // used for digitisation
     if Main.SESLabIO.LabInterfaceType <> VP500 then VP500_InitialiseBoard ;

     HardwareConf.AmplifierStageGain := 0 ;

     // Get VP500 settings
     Err := VP500_GetHardwareConf( @HardwareConf ) ;
     VP500_CheckError( Err, 'VP500_GetHardwareConf' ) ;

     // Clamp mode
     cbClampMode.ItemIndex := HardwareConf.ClampMode ;

     cbClampSpeed.ItemIndex := HardwareConf.ClampSpeed ;

     // Update labels for clamp mode
     UpdateClampModeLabels ;

     // Head stage gain
     rbHeadStageGain.Checked := HardwareConf.HeadGainH ;
     // Amplifier gain
     cbAmplifierGain.ItemIndex := HardwareConf.AmplifierStageGain ;

     // LP filter
     cbLPFilter.ItemIndex := HardwareConf.AmplifierStageFilter ;

     // Get RC neutralisation settings
     GetNeutralizationSettings ;

     // Get compensation settings
     Err := VP500_GetCompensations( @Compensations ) ;
     edPercentRs.Value := Compensations.PercentRs ;
     cbTauPercentRs.ItemIndex := Compensations.TauPercentRs ;
     edPercentBoost.Value := Compensations.PercentBoost ;

     // Junction potential correction
     Err := VP500_GetJunction( @JunctionPotential ) ;
     edJunctionPotential.Value := JunctionPotential ;

     // Holding potential/current
     for i := 0 to High(HoldingVI) do HoldingVI[i] := 0.0 ;
     Err := VP500_GetVIHold( @HoldingVI[HardwareConf.ClampMode] ) ;
     edHoldingVI.Value := HoldingVI[HardwareConf.ClampMode] ;
     // Set holding V/I
     SetHoldingVI ;

     end;


procedure TVP500PanelFrm.cbClampModeChange(Sender: TObject);
// ------------------
// Clamp mode changed
// ------------------
var
     Err : Integer ;
begin
     HardwareConf.ClampMode := cbClampMode.ItemIndex ;
     Err := VP500_SetHardwareConf( @HardwareConf ) ;
     UpdateClampModeLabels ;

     // Update holding V/I with last settings for new mode
     edHoldingVI.Value := HoldingVI[HardwareConf.ClampMode] ;
     SetHoldingVI ;

     end;


procedure TVP500PanelFrm.UpdateClampModeLabels ;
// ----------------------------------------------
// Update labels/controls when clamp mode changed
// ----------------------------------------------
begin
     if (HardwareConf.ClampMode = 1) or
        (HardwareConf.ClampMode = 2) then begin
        cbClampSpeed.Visible := True ;
        HoldingVIGrp.Caption := ' Holding Current ' ;
        edHoldingVI.Units := 'pA' ;
        edHoldingVI.Scale := 1000.0 ;
        end
     else begin
        cbClampSpeed.Visible := False ;
        HoldingVIGrp.Caption := ' Holding Potential ' ;
        edHoldingVI.Units := 'mV' ;
        edHoldingVI.Scale := 1.0 ;
        end ;

     lbClampSpeed.Visible := cbClampSpeed.Visible ;
     end ;


procedure TVP500PanelFrm.cbClampSpeedChange(Sender: TObject);
// --------------------
// Clamp speeed changed
// --------------------
begin
     HardwareConf.ClampSpeed := cbClampSpeed.ItemIndex ;
     VP500_CheckError( VP500_SetHardwareConf( @HardwareConf ),
                       'VP500_SetHardwareConf' ) ;
     end;


procedure TVP500PanelFrm.cbAmplifierGainChange(Sender: TObject);
// ------------------
// Clamp gain changed
// ------------------
begin
     HardwareConf.AmplifierStageGain := cbAmplifierGain.ItemIndex ;
     VP500_CheckError( VP500_SetHardwareConf( @HardwareConf ),
                       'VP500_SetHardwareConf' ) ;
     end;


procedure TVP500PanelFrm.cbLowHeadstageGainClick(Sender: TObject);
// -----------------------
// Head stage gain changed
// -----------------------
begin
     HardwareConf.HeadGainH := rbHeadStageGain.Checked ;
     VP500_CheckError( VP500_SetHardwareConf( @HardwareConf ),
                       'VP500_SetHardwareConf' ) ;
     end;


procedure TVP500PanelFrm.cbLPFilterChange(Sender: TObject);
// -----------------------
// Low pass filter changed
// -----------------------
begin
     HardwareConf.AmplifierStageFilter := cbLPFilter.ItemIndex ;
     VP500_CheckError( VP500_SetHardwareConf( @HardwareConf ),
                       'VP500_SetHardwareConf' ) ;
     end;


procedure TVP500PanelFrm.UpdateCompensations ;
// --------------------------
// Update VP500 compensations
// --------------------------
begin

     Compensations.PercentRs := Round(edPercentRs.Value) ;
     Compensations.TauPercentRs := cbTauPercentRs.ItemIndex ;
     Compensations.PercentBoost := Round(edPercentBoost.Value) ;

     VP500_CheckError( VP500_SetCompensations( @Compensations ),
                       'VP500_SetCompensations' ) ;

     end ;


procedure TVP500PanelFrm.GetNeutralizationSettings ;
// ----------------------------------
// Read VP500 neutralization settings
// ----------------------------------
var
     Err : Integer ;
begin

     Err := VP500_GetNeutralization( @Neutralization ) ;
     VP500_CheckError( Err, 'VP500_GetNeutralization' ) ;

     edCFast.Value := Neutralization.CFast ;
     edTauFast.Value := Neutralization.TauFast ;
     edCSlow.Value := Neutralization.CSlow ;
     edTauSlow.Value := Neutralization.TauSlow ;
     edCCell.Value := Neutralization.CCell ;
     edTauCell.Value := Neutralization.TauCell ;

     end ;


procedure TVP500PanelFrm.UpdateNeutralization ;
// ------------------------------------
// Update VP500 neutralization settings
// ------------------------------------
var
     Err : Integer ;
begin

     Neutralization.CFast := edCFast.Value ;
     Neutralization.TauFast := edTauFast.Value ;
     Neutralization.CSlow:= edCSlow.Value ;
     Neutralization.TauSlow := edTauSlow.Value ;
     Neutralization.CCell := edCCell.Value ;
     Neutralization.TauCell := edTauCell.Value ;

     Err := VP500_SetNeutralization( @Neutralization ) ;
     VP500_CheckError( Err, 'VP500_SetNeutralization' ) ;

     end ;


procedure TVP500PanelFrm.bAppyCompensationClick(Sender: TObject);
// ----------------------------------
// Update VP500 compensation settings
// ----------------------------------
begin
     UpdateCompensations ;
     end;


procedure TVP500PanelFrm.edPercentRsKeyPress(Sender: TObject;
  var Key: Char);
// -------------------------------
// % R series compensation changed
// -------------------------------
begin
     if Key = #13 then UpdateCompensations ;
     end;

procedure TVP500PanelFrm.edPercentBoostKeyPress(Sender: TObject;
  var Key: Char);
// ------------------------------------------
// % cell capacity boost compensation changed
// ------------------------------------------
begin
     if Key = #13 then UpdateCompensations ;
     end;


procedure TVP500PanelFrm.cbTauPercentRsChange(Sender: TObject);
begin
// -------------------------------
// % Tau R series compensation changed
// -------------------------------
begin
     UpdateCompensations ;
     end;

end;

procedure TVP500PanelFrm.edCFastKeyPress(Sender: TObject; var Key: Char);
// --------------------------------------
// Neutralization changed - manual update
// --------------------------------------
begin
     if Key = #13 then UpdateNeutralization ;
     end;


procedure TVP500PanelFrm.bCFastNeutraliseClick(Sender: TObject);
// ---------------------------
// Neutralise C(fast) capacity
// ---------------------------
begin

     bCFastNeutralise.Enabled := False ;
     // Neutralise fast capacity
     VP500_CheckError( VP500_CFastNeutralization, 'VP500_CFastNeutralization' ) ;
     // Read new settings
     GetNeutralizationSettings ;
     bCFastNeutralise.Enabled := True ;
     end;


procedure TVP500PanelFrm.bCSlowNeutraliseClick(Sender: TObject);
// ---------------------------
// Neutralise C(slow) capacity
// ---------------------------
begin

     bCSlowNeutralise.Enabled := False ;
     // Neutralise slow capacity
     VP500_CheckError( VP500_CSlowNeutralization, 'VP500_CSlowNeutralization' ) ;
     // Read new settings
     GetNeutralizationSettings ;
     bCSlowNeutralise.Enabled := True ;
     end;


procedure TVP500PanelFrm.bCCellNeutraliseClick(Sender: TObject);
// ---------------------------
// Neutralise C(cell) capacity
// ---------------------------
begin

     bCCellNeutralise.Enabled := False ;

     // Neutralise cell capacity
     VP500_CheckError(VP500_CCellNeutralization, 'VP500_CCellNeutralization' ) ;
     // Read new settings
     GetNeutralizationSettings ;
     // Cancel leak neutralisation (if not required)
     if not ckNeutraliseLeak.Checked then begin
        Neutralization.Leak := 0.0 ;
        UpdateNeutralization ;
        GetNeutralizationSettings ;
        end ;

     bCCellNeutralise.Enabled := True ;

     end;


procedure TVP500PanelFrm.bApplyHoldingIVClick(Sender: TObject);
// -----------------------------
// Apply holding voltage/current
// -----------------------------
begin
     SetHoldingVI ;
     end;


procedure TVP500PanelFrm.edHoldingVIKeyPress(Sender: TObject;
  var Key: Char);
// -----------------------------
// Apply holding voltage/current
// -----------------------------
begin
     if Key = #13 then SetHoldingVI ;
     end;


procedure TVP500PanelFrm.SetHoldingVI ;
// ---------------------------
// Set holding voltage/current
// ---------------------------
var
     Err : Integer ;
begin
     Err := VP500_SetVIHold( edHoldingVI.Value ) ;
     VP500_CheckError( Err, 'VP500_SetVIHold' ) ;
     HoldingVI[HardwareConf.ClampMode] := edHoldingVI.Value ;
     end ;


procedure TVP500PanelFrm.bApplyJunctionClick(Sender: TObject);
// -----------------------------------
// Apply junction potential correction
// ----------------------------- -----
var
     Err : Integer ;
begin
     Err := VP500_SetJunction(edJunctionPotential.Value ) ;
     VP500_CheckError( Err, 'VP500_SetJunction' ) ;
     end;


procedure TVP500PanelFrm.edJunctionPotentialKeyPress(Sender: TObject;
  var Key: Char);
// -----------------------------------
// Apply junction potential correction
// ----------------------------- -----
begin
     if Key = #13 then begin
        VP500_CheckError( VP500_SetJunction(edJunctionPotential.Value ), 'VP500_SetJunction' ) ;
        end ;
     end;


procedure TVP500PanelFrm.bCalcSealResistanceClick(Sender: TObject);
// -------------------------
// Calculate seal resistance
// -------------------------
var
    SealImpedance : TSealImpedance ;
begin

    bCalcSealResistance.Enabled := False ;

    SealImpedance.Amplitude := 10.0 ; // 10 mV amplitude
    SealImpedance.Period := 500 ;     // 10 ms period

    //SealImpedance.SamplingRate := 1 ; // 50 kHz sampling rate
    SealImpedance.DirectionUp := True ;
    VP500_CheckError( VP500_CalcSealImpedance( @SealImpedance ), 'VP500_CalcSealImpedance' ) ;
    edSealResistance.Value := SealImpedance.SealImpedance ;

    bCalcSealResistance.Enabled := True ;

    end;


procedure TVP500PanelFrm.bCalcCellParametersClick(Sender: TObject);
// -------------------------
// Calculate cell parameters
// -------------------------
var
    CellParameters : TCellParameters ;
begin

    bCalcCellParameters.Enabled := False ;
    VP500_CheckError( VP500_CellParameters( @CellParameters ), 'VP500_CellParameters' ) ;
    edRm.Value := CellParameters.Rm ;
    edRs.Value := CellParameters.Rs ;
    edCm.Value := CellParameters.Cm ;
    bCalcCellParameters.Enabled := True ;

    end;


procedure TVP500PanelFrm.bInitialiseClick(Sender: TObject);
// ---------------------------------------------------
// Initialise compensation and neutralisation circuits
// ---------------------------------------------------
begin

     // Reset settings
     VP500_CheckError( VP500_Reinitialization, 'VP500_CellParameters' ) ;
     // Get new settings
     GetNeutralizationSettings ;

     end;


procedure TVP500PanelFrm.bZapClick(Sender: TObject);
// ---------------------------------------
// Apply whole cell break-in voltage pulse
// ---------------------------------------
begin

    bZap.Enabled := False ;
    VP500_CheckError( VP500_DoZap( Round( edZapDuration.Value ) ), 'VP500_DoZap' ) ;
    bZap.Enabled := True ;
    end;


procedure TVP500PanelFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
// ---------------------------
// Tidy up when form is closed
// ---------------------------
begin

     Action := caFree ;
     end;



procedure TVP500PanelFrm.bOptimiseNeutralisationClick(Sender: TObject);
// ---------------------------------------------------
// Final optimisation of neutralisation circuits
// ---------------------------------------------------
begin

     bOptimiseNeutralisation.Enabled := False ;

     // Optimise settings
     VP500_CheckError( VP500_OptimizeNeutralization, 'VP500_OptimizeNeutralization' ) ;

     // Read new settings
     GetNeutralizationSettings ;
     // Cancel leak neutralisation (if not required)
     if not ckNeutraliseLeak.Checked then begin
        Neutralization.Leak := 0.0 ;
        UpdateNeutralization ;
        GetNeutralizationSettings ;
        end ;

     bOptimiseNeutralisation.Enabled := True ;

     end;


procedure TVP500PanelFrm.TimerTimer(Sender: TObject);
// -------------------
// Update VP500 status
// -------------------
var
    VP500Status : TVP500Status ;
    s : String ;
begin
     VP500_GetVP500Status( @VP500Status ) ;
     s := '' ;
     if VP500Status.IHeadOverload then s := s + 'IHead OVR ' ;
     if VP500Status.VMOverload then s := s + 'VM OVR ' ;
     if VP500Status.ADC1Overload then s := s + 'ADC1 OVR ' ;
     if VP500Status.ADC2Overload then s := s + 'ADC2 OVR ' ;
     edStatus.Text := s ;
     end ;

procedure TVP500PanelFrm.FormActivate(Sender: TObject);
begin
     Timer.Enabled := True ;
     end;

procedure TVP500PanelFrm.FormDeactivate(Sender: TObject);
begin
     Timer.Enabled := False ;
     end;


procedure TVP500PanelFrm.spJunctionPotentialUpClick(Sender: TObject);
// ------------------------------------------------
// Increase junction potential correction by 0.1 mV
// ------------------------------------------------
begin
     edJunctionPotential.Value := edJunctionPotential.Value + 0.1 ;
     VP500_CheckError( VP500_SetJunction(edJunctionPotential.Value ),
                       'VP500_SetJunction' ) ;
     end;

procedure TVP500PanelFrm.spJunctionPotentialDownClick(Sender: TObject);
// ------------------------------------------------
// Increase junction potential correction by 0.1 mV
// ------------------------------------------------
begin
     edJunctionPotential.Value := edJunctionPotential.Value - 0.1 ;
     VP500_CheckError( VP500_SetJunction(edJunctionPotential.Value ),
                       'VP500_SetJunction' ) ;
     end;

end.
