unit TritonPanelUnit;
// ----------------------------------------
// Tecella Triton patch clamp control panel                                                   
// ----------------------------------------
// (c) J. Dempster, University of Strathclyde, 2008
// 9.07.08
// 4.09.08 Revised to work with tecellaamp.dll and tested.
// 13.05.10 Number of Triton now obtained from device
// 29.07.10 Support for Pico added
// 26.08.01 Support for PICO still under development
// 08.09.10 Triton_Zap function added
// 19.05.11 .UpdateTritonSettings now public
// 07.06.11 Digital leak sutraction and arterfact subtraction added to compensation.
// 16.06.11 Tecella amplifier settings now stored in tecella settings.xml (instead of winwcp.ini)
//  22/12/11 To avoid OLE exceptions and access violations,
//           LoadProtocolFromXML/SaveProtocolToXML now Coinitialise/Codeinitialize COM system before after creation of
//           XMLDoc. XMLDOC now an IXMLDocument rather than a TXMLDocument.
//           DACStreaming can now be enabled/disabled
// 16.01.12 GetElementFloat() now handles both ',' and '.' decimal separators
// 14.03.12 Enable current stimulus tick box added which enables/disable current pulses in ICLAMP mode
// 02.04.12 Use of CslowA-D can be enabled/disabled in auto compensation
// 17.04.12 Auto compensation Vtest, Vhold, Thold, Tstep can now be set by user
//          Use CslowsA-D compensation now only visible if CslowA-D supported
// 07.08.13 Updated to compile under Delphi XE3
//  20.08.13 'tecella settings.xml' now stored in Windows
//          <common documents folder>\WinWCP\tecella settings.xml' rather than program folder

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ValidatedEdit, TritonUnit, global, math, ExtCtrls,
  ComCtrls, xmldoc, xmlintf, strutils, ActiveX ;

const
    MaxTecellaChannels = 16 ;

type
  TTritonPanelFrm = class(TForm)
    ControlsGrp: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    cbChannel: TComboBox;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    cbGain: TComboBox;
    cbSource: TComboBox;
    lbSource: TLabel;
    GroupBox5: TGroupBox;
    bUpdateAllChannels: TButton;
    Timer: TTimer;
    edModel: TEdit;
    Label11: TLabel;
    edFilter: TEdit;
    cbUserConfig: TComboBox;
    Label13: TLabel;
    GroupBox1: TGroupBox;
    bZap: TButton;
    edZapDuration: TValidatedEdit;
    edZapAmplitude: TValidatedEdit;
    Label15: TLabel;
    Label16: TLabel;
    ckZapAllChannels: TCheckBox;
    tbFilter: TTrackBar;
    bCalibrate: TButton;
    AutoCompPage: TPageControl;
    AutoPage: TTabSheet;
    GroupBox6: TGroupBox;
    ckUseAnalogLeakCompensation: TCheckBox;
    ckUseDigitalLeakCompensation: TCheckBox;
    ckUseDigitalArtefactSubtraction: TCheckBox;
    CapacityPage: TTabSheet;
    ResistancePage: TTabSheet;
    JunctionPotPage: TTabSheet;
    panJunctionPot: TPanel;
    Label8: TLabel;
    edJunctionPot: TEdit;
    ckJunctionPot: TCheckBox;
    tbJunctionPot: TTrackBar;
    panJunctionPotFIne: TPanel;
    Label12: TLabel;
    ckJunctionPotFine: TCheckBox;
    edJunctionPotFine: TEdit;
    tbJunctionPotFine: TTrackBar;
    panRLeak: TPanel;
    Label9: TLabel;
    edRLeak: TEdit;
    ckRleak: TCheckBox;
    tbRLeak: TTrackBar;
    panRLeakFine: TPanel;
    Label14: TLabel;
    edRLeakFine: TEdit;
    ckRLeakFine: TCheckBox;
    tbRLeakFine: TTrackBar;
    panCFast: TPanel;
    Label2: TLabel;
    edCFast: TEdit;
    tbCFast: TTrackBar;
    panCSlowA: TPanel;
    Label3: TLabel;
    edCSlowA: TEdit;
    ckCslowA: TCheckBox;
    tbCSlowA: TTrackBar;
    panCSlowB: TPanel;
    Label4: TLabel;
    edCSlowB: TEdit;
    ckCslowB: TCheckBox;
    tbCSlowB: TTrackBar;
    panCSlowC: TPanel;
    Label5: TLabel;
    edCSlowC: TEdit;
    ckCslowC: TCheckBox;
    tbCSlowC: TTrackBar;
    panCSlowD: TPanel;
    Label6: TLabel;
    edCSlowD: TEdit;
    ckCslowD: TCheckBox;
    tbCSlowD: TTrackBar;
    panRSeries: TPanel;
    Label7: TLabel;
    edRSeries: TEdit;
    ckRseries: TCheckBox;
    tbRSeries: TTrackBar;
    bAutoCompensate: TButton;
    bClearCompensation: TButton;
    bAutoJunctionNull: TButton;
    edCompensationCoeff: TValidatedEdit;
    Label17: TLabel;
    ckEnableDACStreaming: TCheckBox;
    ckICLAMPOn: TCheckBox;
    ckUseCSlowA: TCheckBox;
    ckUseCSlowB: TCheckBox;
    ckUseCSlowC: TCheckBox;
    ckUseCSlowD: TCheckBox;
    ckUseCFast: TCheckBox;
    edVHold: TValidatedEdit;
    Label18: TLabel;
    Label19: TLabel;
    edTHold: TValidatedEdit;
    ckCompensateAllChannels: TCheckBox;
    Label20: TLabel;
    edVStep: TValidatedEdit;
    Label21: TLabel;
    edTStep: TValidatedEdit;
    procedure FormShow(Sender: TObject);
    procedure sbCfastChange(Sender: TObject);
    procedure sbCSlowAChange(Sender: TObject);
    procedure sbCslowBChange(Sender: TObject);
    procedure sbCSlowCChange(Sender: TObject);
    procedure sbCslowDChange(Sender: TObject);
    procedure sbRseriesChange(Sender: TObject);
    procedure sbJunctionPotChange(Sender: TObject);
    procedure sbRleakChange(Sender: TObject);
    procedure cbGainChange(Sender: TObject);
    procedure cbSourceChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbFilterChange(Sender: TObject);
    procedure cbChannelChange(Sender: TObject);
    procedure ckCslowAClick(Sender: TObject);
    procedure ckCslowBClick(Sender: TObject);
    procedure ckCslowCClick(Sender: TObject);
    procedure ckCslowDClick(Sender: TObject);
    procedure ckRseriesClick(Sender: TObject);
    procedure ckJunctionPotClick(Sender: TObject);
    procedure ckRleakClick(Sender: TObject);
    procedure bAutoCompensateClick(Sender: TObject);
    procedure bUpdateAllChannelsClick(Sender: TObject);
    procedure bClearCompensationClick(Sender: TObject);
    procedure bAutoJunctionNullClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure sbJunctionPotFineChange(Sender: TObject);
    procedure cbUserConfigChange(Sender: TObject);
    procedure sbRLeakFineChange(Sender: TObject);
    procedure ckRLeakFineClick(Sender: TObject);
    procedure bZapClick(Sender: TObject);
    procedure tbFilterChange(Sender: TObject);
    procedure tbCFastChange(Sender: TObject);
    procedure tbCSlowAChange(Sender: TObject);
    procedure tbCSlowBChange(Sender: TObject);
    procedure tbCSlowCChange(Sender: TObject);
    procedure tbCSlowDChange(Sender: TObject);
    procedure tbRSeriesChange(Sender: TObject);
    procedure tbRLeakChange(Sender: TObject);
    procedure tbRLeakFineChange(Sender: TObject);
    procedure tbJunctionPotChange(Sender: TObject);
    procedure tbJunctionPotFineChange(Sender: TObject);
    procedure bCalibrateClick(Sender: TObject);
    procedure ckUseDigitalArtefactSubtractionClick(Sender: TObject);
    procedure ckUseDigitalLeakCompensationClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ckUseAnalogLeakCompensationClick(Sender: TObject);
    procedure ckCompensateAllChannelsClick(Sender: TObject);
    procedure edCompensationCoeffKeyPress(Sender: TObject; var Key: Char);
    procedure ckEnableDACStreamingClick(Sender: TObject);
    procedure ckICLAMPOnClick(Sender: TObject);
    procedure ckUseCSlowAClick(Sender: TObject);
    procedure ckUseCSlowBClick(Sender: TObject);
    procedure ckUseCSlowCClick(Sender: TObject);
    procedure ckUseCSlowDClick(Sender: TObject);
    procedure ckUseCFastClick(Sender: TObject);
    procedure edVHoldKeyPress(Sender: TObject; var Key: Char);
    procedure edTHoldKeyPress(Sender: TObject; var Key: Char);
    procedure edVStepKeyPress(Sender: TObject; var Key: Char);
    procedure edTStepKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    DisableTritonUpdates : Boolean ; // Do not update Triton if TRUE
    // Register update required (handled by timer method)
    GainUpdateRequired : Boolean ;
    BesselFilterUpdateRequired : Boolean ;
    CfastUpdateRequired : Boolean ;
    CslowAUpdateRequired : Boolean ;
    CslowBUpdateRequired : Boolean ;
    CslowCUpdateRequired : Boolean ;
    CslowDUpdateRequired : Boolean ;
    RseriesUpdateRequired : Boolean ;
    JunctionPotUpdateRequired : Boolean ;
    JunctionPotFineUpdateRequired : Boolean ;
    RleakUpdateRequired : Boolean ;
    RleakFineUpdateRequired : Boolean ;
    SettingsFileName : String ;

    // Tecella amplifier settings
    Source : Array[0..MaxTecellaChannels-1] of Integer ;
    Gain : Array[0..MaxTecellaChannels-1] of Integer ;
    InputRange : Array[0..MaxTecellaChannels-1] of Single ;
    CFAST : Array[0..MaxTecellaChannels-1] of Single ;
    CSLOW_A : Array[0..MaxTecellaChannels-1] of Single ;
    CSLOW_B : Array[0..MaxTecellaChannels-1] of Single ;
    CSLOW_C : Array[0..MaxTecellaChannels-1] of Single ;
    CSLOW_D : Array[0..MaxTecellaChannels-1] of Single ;
    RSERIES : Array[0..MaxTecellaChannels-1] of Single ;
    CHANOFF : Array[0..MaxTecellaChannels-1] of Single ;
    CHANOFFFine : Array[0..MaxTecellaChannels-1] of Single ;
    LEAK : Array[0..MaxTecellaChannels-1] of Single ;
    LEAKFine : Array[0..MaxTecellaChannels-1] of Single ;
    BESSEL : Array[0..MaxTecellaChannels-1] of Single ;
    CSLOW_AEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    CSLOW_BEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    CSLOW_CEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    CSLOW_DEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    RSERIESEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    CHANOFFEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    LEAKEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    LEAKFineEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
//    CHANOFFFineEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
//    IClampMode : Array[0..MaxTecellaChannels-1] of Boolean ;
    ZapAmplitude : Single ;
    ZapDuration : Single ;
    UseAnalogLeakSubtraction : Boolean ;
    UseDigitalLeakSubtraction : Boolean ;
    UseDigitalArtefactRemoval : Boolean ;
    UseCfastCompensation : Boolean ;
    UseCSlowACompensation : Boolean ;
    UseCSlowBCompensation : Boolean ;
    UseCSlowCCompensation : Boolean ;
    UseCSlowDCompensation : Boolean ;
    CompensateAllChannels : Boolean ;
    CompensationCoeff : Single ;
    CompensationVHold : Single ;
    CompensationTHold : Single ;
    CompensationVStep : Single ;
    CompensationTStep : Single ;
    EnableDACStreaming : Boolean ;


    procedure TritonGetValueAndEnabled(
              TritonRegister : Integer ;
              iChan : Integer ;
              var EditControl : TEdit ;
              var SliderControl : TTrackBar ;
              var EnableBox : TCheckBox ) ;

    procedure TritonGetValue(
              TritonRegister : Integer ;
              iChan : Integer ;
              var EditControl : TEdit ;
              var SliderControl : TTrackBar  ) ;

    procedure TritonSetPercent(
              TritonRegister : Integer ;
              var EditControl : TEdit ;
              var SliderControl : TTrackBar ) ;
    procedure TritonGetPercent(
              TritonRegister : Integer ;
              var EditControl : TValidatedEdit ;
              var SliderControl : TTrackBar ) ;
    procedure TritonSetEnable(
              TritonEnableRegister : Integer ;
              var EnableBox : TCheckBox ) ;

    procedure SetSlider(
              TrackBar : TTrackBar ;
              Panel : TPanel ;
              Reg : Integer ) ;

    procedure UpdatePanelControls ;

    // XML procedures

    procedure LoadFromXMLFile1( FileName : String ) ;
    procedure SaveToXMLFile1( FileName : String ) ;

    procedure AddElementFloat(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Single
              ) ;
    function GetElementFloat(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Single
              ) : Boolean ;
    procedure AddElementInt(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Integer
              ) ;
    function GetElementInt(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Integer
              ) : Boolean ;
    procedure AddElementBool(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Boolean
              ) ;
    function GetElementBool(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Boolean
              ) : Boolean ;

    procedure AddElementText(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : String
              ) ;
    function GetElementText(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : String
              ) : Boolean ;

    function FindXMLNode(
         const ParentNode : IXMLNode ;  // Node to be searched
         NodeName : String ;            // Element name to be found
         var ChildNode : IXMLNode ;     // Child Node of found element
         var NodeIndex : Integer        // ParentNode.ChildNodes Index #
                          // Starting index on entry, found index on exit
         ) : Boolean ;

  public
    { Public declarations }
    procedure UpdateTritonSettings ;
    procedure LoadFromXMLFile( FileName : String ) ;
    procedure SaveToXMLFile( FileName : String ) ;

  end;

var
  TritonPanelFrm: TTritonPanelFrm;

implementation

uses MDIForm, Sealtest;

{$R *.dfm}

procedure TTritonPanelFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
var
    ch : Integer ;
begin

     ClientWidth := ControlsGrp.Left + ControlsGrp.Width + 5 ;
     ClientHeight := ControlsGrp.Top + ControlsGrp.Height + 5 ;
     DisableTritonUpdates := False ;

     // Amplifier model
     edModel.Text := Main.SESLabIO.LabInterfaceModel ;

     // Channels
     cbChannel.Clear ;
     for ch := 1 to Main.SESLabIO.TritonNumChannels do  cbChannel.Items.Add(format('Ch.%d',[ch])) ;
     cbChannel.ItemIndex := 0 ;

     // Input source
     Main.SESLabIO.TritonGetSourcelist( cbSource.Items ) ;

     // Set slider ranges
     SetSlider( tbCFast, panCFast, TECELLA_REG_CFAST ) ;
     SetSlider( tbCSLowA, panCSlowA, TECELLA_REG_CSLOW_A ) ;
     SetSlider( tbCSLowB, panCSlowB, TECELLA_REG_CSLOW_B ) ;
     SetSlider( tbCSLowC, panCSlowC, TECELLA_REG_CSLOW_C ) ;
     SetSlider( tbCSLowD, panCSlowD, TECELLA_REG_CSLOW_D ) ;
     SetSlider( tbJunctionPot, panJunctionPot, TECELLA_REG_JP ) ;
     SetSlider( tbJunctionPotFine, panJunctionPotFine, TECELLA_REG_JP_FINE ) ;
     SetSlider( tbRLeak, panRLeak, TECELLA_REG_LEAK ) ;
     SetSlider( tbRLeakFine, panRLeakFine, TECELLA_REG_LEAK_FINE ) ;
     SetSlider( tbRSeries, panRSeries, TECELLA_REG_RSERIES ) ;

     ckUseCFast.Visible := PanCFast.Visible ;
     ckUseCSlowA.Visible := PanCSlowA.Visible ;
     ckUseCSlowB.Visible := PanCSlowB.Visible ;
     ckUseCSlowC.Visible := PanCSlowC.Visible ;
     ckUseCSlowD.Visible := PanCSlowD.Visible ;

     // Input Gain
     Main.SESLabIO.TritonGetGainList(cbGain.Items) ;
     cbGain.ItemIndex := 0 ;

     // User config
     Main.SESLabIO.TritonGetUserConfigList(cbUserConfig.Items);
     cbUserConfig.ItemIndex := Main.SESLabIO.TritonUserConfig ;

     UpdateTritonSettings ;

     DisableTritonUpdates := False ;
     GainUpdateRequired := False ;
     BesselFilterUpdateRequired := False ;
     CfastUpdateRequired := False ;
     CslowAUpdateRequired := False ;
     CslowBUpdateRequired := False ;
     CslowCUpdateRequired := False ;
     CslowDUpdateRequired := False ;
     RseriesUpdateRequired := False ;
     JunctionPotUpdateRequired := False ;
     RleakUpdateRequired := False ;
     RleakFineUpdateRequired := False ;

     edZapAmplitude.Value := ZapAmplitude ;
     edZapDuration.Value := ZapDuration ;

    ckUseAnalogLeakCompensation.checked := UseAnalogLeakSubtraction ;
    ckUseDigitalLeakCompensation.Checked := UseDigitalLeakSubtraction ;
    ckUseDigitalArtefactSubtraction.Checked := UseDigitalArtefactRemoval ;
    ckUseCfast.Checked := UseCfastCompensation ;

    ckUseCSlowA.Checked := UseCSlowACompensation ;
    ckUseCSlowB.Checked := UseCSlowBCompensation ;
    ckUseCSlowC.Checked := UseCSlowCCompensation ;
    ckUseCSlowD.Checked := UseCSlowDCompensation ;
    ckCompensateAllChannels.Checked := CompensateAllChannels ;
    edCompensationCoeff.Value := CompensationCoeff ;
    edVHold.Value := CompensationVHold ;
    edTHold.Value := CompensationTHold ;
    edVStep.Value := CompensationVStep ;
    edTStep.Value := CompensationTStep ;
    ckEnableDACStreaming.Checked := EnableDACStreaming ;

    end ;


procedure TTritonPanelFrm.UpdateTritonSettings ;
var
    ch : Integer ;
    Freq : Single ;
begin

     // Input source
     Main.SESLabIO.TritonGetSourceList( cbSource.Items ) ;

     // Input Gain
     Main.SESLabIO.TritonGetGainList(cbGain.Items) ;

     // Update settings in Triton
     for ch := 0 to Main.SESLabIO.TritonNumChannels-1 do begin

         // Source
         Source[ch] :=  Min(Max(Source[ch],0),cbSource.Items.Count-1) ;
         Main.SESLABIO.TritonSource[ch] := Source[ch] ;
         if ch = cbChannel.ItemIndex then cbSource.ItemIndex := Source[ch] ;

         // Gain
         Gain[ch] :=  Min(Max(Gain[ch],0),cbGain.Items.Count-1) ;
         Main.SESLABIO.TritonGain[ch] := Gain[ch] ;
         if ch = cbChannel.ItemIndex then cbGain.ItemIndex := Gain[ch] ;

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CFAST,ch,CFAST[ch]) ;

         Main.SESLABIO.SetTritonBesselFilter( ch, Round(BESSEL[ch]), Freq ) ;
         if ch = cbChannel.ItemIndex then edFilter.Text := format('%.4g kHz',[Freq]) ;

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_A,ch,CSLOW_A[ch]) ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_CSLOW_A,ch,CSLOW_AEnabled[ch]) ;

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_B,ch,CSLOW_B[ch]) ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_CSLOW_B,ch,CSLOW_BEnabled[ch]) ;

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_C,ch,CSLOW_C[ch]) ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_CSLOW_C,ch,CSLOW_CEnabled[ch]) ;

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_D,ch,CSLOW_D[ch]) ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_CSLOW_D,ch,CSLOW_DEnabled[ch]) ;

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_RSERIES,ch,RSERIES[ch]) ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_RSERIES,ch,RSERIESEnabled[ch]) ;

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_JP,ch,CHANOFF[ch]) ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_JP,ch,CHANOFFEnabled[ch]) ;

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_LEAK,ch,LEAK[ch]) ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_LEAK,ch,LEAKEnabled[ch]) ;

         end ;

     GainUpdateRequired := True ;

     // Update panel controls for selected channel
     UpdatePanelControls ;

     end ;


procedure TTritonPanelFrm.SetSlider(
          TrackBar : TTrackBar ;
          Panel : TPanel ;
          Reg : Integer ) ;
// ------------------
// Set slider control
// ------------------
var
    VMin,VMax,VStep : Single ;
    CanBeDisabled : Boolean ;
    Supported : Boolean ;
begin

    Main.SESLabIO.TritonGetRegProperties (Reg, VMin,Vmax,VStep,CanBeDisabled,Supported) ;
    TrackBar.Max := Round((VMax - VMin)/VStep) ;
    TrackBar.Min := 0 ;
    Panel.Visible := Supported ;

    end ;


procedure TTritonPanelFrm.UpdatePanelControls ;
// ------------------------------------------
// Update panel controls for selected channel
// ------------------------------------------
var
    Value : Single ;
begin

     DisableTritonUpdates := True ;

     cbSource.ItemIndex := Source[cbChannel.ItemIndex] ;
     cbGain.ItemIndex := Gain[cbChannel.ItemIndex] ;

     if ANSIContainsText( cbUserConfig.Text, 'ICLAMP' ) then ckICLAMPOn.Visible := True
                                                        else ckICLAMPOn.Visible := False ;
     ckICLAMPOn.Checked := Main.SESLabIO.TritonICLAMPOn ;

     TritonGetValue( TECELLA_REG_CFAST,cbChannel.ItemIndex,edCFast,tbCFast) ;
     TritonGetValueAndEnabled(TECELLA_REG_CSLOW_A,cbChannel.ItemIndex,edCSlowA,tbCSlowA,ckCSlowA) ;
     TritonGetValueAndEnabled(TECELLA_REG_CSLOW_B,cbChannel.ItemIndex,edCSlowB,tbCSlowB,ckCSlowB) ;
     TritonGetValueAndEnabled(TECELLA_REG_CSLOW_C,cbChannel.ItemIndex,edCSlowC,tbCSlowC,ckCSlowC) ;
     TritonGetValueAndEnabled(TECELLA_REG_CSLOW_D,cbChannel.ItemIndex,edCSlowD,tbCSlowD,ckCSlowD) ;
     TritonGetValueAndEnabled(TECELLA_REG_RSERIES,cbChannel.ItemIndex,edRSERIES,tbRSERIES,ckRSERIES) ;
     TritonGetValueAndEnabled(TECELLA_REG_LEAK,cbChannel.ItemIndex,edRLEAK,tbRLEAK,ckRLEAK) ;
     TritonGetValueAndEnabled(TECELLA_REG_LEAK_FINE,cbChannel.ItemIndex,edRLEAKFine,tbRLEAKFine,ckRLEAKFine) ;
     TritonGetValueAndEnabled(TECELLA_REG_JP,cbChannel.ItemIndex,edJunctionPot,tbJunctionPot,ckJunctionPot) ;
     TritonGetValueAndEnabled(TECELLA_REG_JP_FINE,cbChannel.ItemIndex,edJunctionPotFine,tbJunctionPotFine,ckJunctionPotFine) ;

     tbFilter.Position := Round(BESSEL[cbChannel.ItemIndex]) ;
     Main.SESLabIO.SetTritonBesselFilter( cbChannel.ItemIndex, tbFilter.Position, Value ) ;
     edFilter.Text := format('%.4g kHz',[Value]) ;

     DisableTritonUpdates := False ;

     end ;


procedure TTritonPanelFrm.TritonGetValueAndEnabled(
          TritonRegister : Integer ;
          iChan : Integer ;
          var EditControl : TEdit ;
          var SliderControl : TTrackBar ;
          var EnableBox : TCheckBox  ) ;
// --------------------------------------------------
// Get current value of selected register from Triton
// --------------------------------------------------
var
    Value,PercentValue : Single ;
    Enabled : Boolean ;
    Units : String ;
begin

     Main.SESLABIO.TritonGetReg( TritonRegister, cbChannel.ItemIndex, Value,
                                 PercentValue, Units,Enabled ) ;
     SliderControl.Position :=  Round(PercentValue*0.01*SliderControl.Max) ;

     EditControl.Text := format(' %.4g %s',[Value,Units]) ;
     EnableBox.Checked := Enabled ;

     end ;


procedure TTritonPanelFrm.TritonGetValue(
          TritonRegister : Integer ;
          iChan : Integer ;
          var EditControl : TEdit ;
          var SliderControl : TTrackBar  ) ;
// --------------------------------------------------
// Get current value of selected register from Triton
// --------------------------------------------------
var
    Value,PercentValue : Single ;
    Enabled : Boolean ;
    Units : string ;
begin

     Main.SESLABIO.TritonGetReg( TritonRegister, cbChannel.ItemIndex, Value, PercentValue, Units,Enabled ) ;
     EditControl.Text := format(' %.4g %s',[Value,Units]) ;
     SliderControl.Position :=  Round(PercentValue*0.01*SliderControl.Max) ;

     end ;



procedure TTritonPanelFrm.TritonSetEnable(
          TritonEnableRegister : Integer ;
          var EnableBox : TCheckBox ) ;
// --------------------------------------------------
// Set enable state of selected register from Triton
// --------------------------------------------------
begin

     // Set enabled state
     if not DisableTritonUpdates then begin
         Main.SESLABIO.TritonSetRegEnabled(
                                      TritonEnableRegister,
                                      cbChannel.ItemIndex,
                                      EnableBox.Checked ) ;
         end ;

      EnableBox.Checked := Main.SESLABIO.TritonGetRegEnabled(
                                      TritonEnableRegister,
                                      cbChannel.ItemIndex ) ;
     end ;


procedure TTritonPanelFrm.TritonSetPercent(
          TritonRegister : Integer ;
          var EditControl : TEdit ;
          var SliderControl : TTrackBar  ) ;
// --------------------------------------------------
// Set current value of selected register from Triton
// --------------------------------------------------
var
    Value,PercentValue : Single ;
    Enabled : Boolean ;
    Units : String ;
begin

     PercentValue := (SliderControl.Position/SliderControl.Max)*100.0 ;

     // Set register
     if not DisableTritonUpdates then begin
        Main.SESLABIO.TritonSetRegPercent( TritonRegister,
                                           cbChannel.ItemIndex,
                                           PercentValue ) ;
        end ;

     // Get actual value set back
     Main.SESLABIO.TritonGetReg( TritonRegister, cbChannel.ItemIndex, Value, PercentValue, Units,Enabled ) ;

     EditControl.Text := format(' %.4g %s',[Value,Units]) ;

     end ;


procedure TTritonPanelFrm.TritonGetPercent(
          TritonRegister : Integer ;
          var EditControl : TValidatedEdit ;
          var SliderControl : TTrackBar  ) ;
// --------------------------------------------------
// Get current value of selected register from Triton
// --------------------------------------------------
var
    Value,PercentValue : Single ;
    Enabled : Boolean ;
    Units : String ;
begin

     PercentValue := SliderControl.Position ;

     // Get actual value set back
     Main.SESLABIO.TritonGetReg( TritonRegister, cbChannel.ItemIndex, Value, PercentValue, Units,Enabled ) ;

     //EditControl.Value := Value ;

     end ;



procedure TTritonPanelFrm.sbCfastChange(Sender: TObject);
begin
    CfastUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.sbCSlowAChange(Sender: TObject);
begin
     CslowAUpdateRequired := True ;
     end;


procedure TTritonPanelFrm.sbCslowBChange(Sender: TObject);
begin
     CslowBUpdateRequired := True ;
     end;


procedure TTritonPanelFrm.sbCSlowCChange(Sender: TObject);
begin
     CslowCUpdateRequired := True ;
     end;

procedure TTritonPanelFrm.sbCslowDChange(Sender: TObject);
begin
     CslowDUpdateRequired := True ;
     end;

procedure TTritonPanelFrm.sbRseriesChange(Sender: TObject);
begin
     RseriesUpdateRequired := True ;
     end;

procedure TTritonPanelFrm.sbJunctionPotChange(Sender: TObject);
// -----------------------------------
// Junction potential setting changed
// -----------------------------------
begin
     JunctionPotUpdateRequired := True ;
     end;


procedure TTritonPanelFrm.sbRleakChange(Sender: TObject);
// ----------------------
// RLeak setting changed
// ----------------------
begin
    RleakUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.cbGainChange(Sender: TObject);
// -----------------------------------------
// Gain resistir for selected channel changed
// -----------------------------------------
begin
     GainUpdateRequired := True ;
     end;


procedure TTritonPanelFrm.cbSourceChange(Sender: TObject);
// -----------------------------------------
// Input source for selected channel changed
// -----------------------------------------
begin
     Main.SESLABIO.TritonSource[cbChannel.ItemIndex] := cbSource.ItemIndex ;
     Source[cbChannel.ItemIndex] := cbSource.ItemIndex ;
     end;


procedure TTritonPanelFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
// ----------------------
// Tidy up and close form
// ----------------------
begin

     ZapAmplitude := edZapAmplitude.Value ;
     ZapDuration := edZapDuration.Value ;

     // Save amplifier settings
     SaveToXMLFile( SettingsFileName ) ;

     Action := caFree ;

     end;


procedure TTritonPanelFrm.sbFilterChange(Sender: TObject);
// ----------------------------------------------
// Update Bessel filter cut-off frequency setting
// ----------------------------------------------

begin
    BesselFilterUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.cbChannelChange(Sender: TObject);
// -------------------------------
// Selected Triton channel changed
// -------------------------------
begin
     UpdatePanelControls ;
     end;


procedure TTritonPanelFrm.ckCslowAClick(Sender: TObject);
begin
    TritonSetEnable( TECELLA_REG_CSLOW_A, ckCslowA ) ;
    CSLOW_AEnabled[cbChannel.ItemIndex] := ckCslowA.Checked ;
    end;


procedure TTritonPanelFrm.ckCslowBClick(Sender: TObject);
begin
    TritonSetEnable( TECELLA_REG_CSLOW_B, ckCslowB ) ;
    CSLOW_BEnabled[cbChannel.ItemIndex] := ckCslowB.Checked ;
    end;


procedure TTritonPanelFrm.ckCslowCClick(Sender: TObject);
begin
    TritonSetEnable( TECELLA_REG_CSLOW_C, ckCslowC ) ;
    CSLOW_CEnabled[cbChannel.ItemIndex] := ckCslowC.Checked ;
    end;


procedure TTritonPanelFrm.ckCslowDClick(Sender: TObject);
begin
    TritonSetEnable( TECELLA_REG_CSLOW_D, ckCslowD ) ;
    CSLOW_DEnabled[cbChannel.ItemIndex] := ckCslowD.Checked ;
    end;


procedure TTritonPanelFrm.ckRseriesClick(Sender: TObject);
begin
    TritonSetEnable( TECELLA_REG_RSERIES, ckRSERIES ) ;
    RSERIESEnabled[cbChannel.ItemIndex] := ckRSERIES.Checked ;
    end;


procedure TTritonPanelFrm.ckJunctionPotClick(Sender: TObject);
begin
    TritonSetEnable( TECELLA_REG_JP, ckJunctionPot ) ;
    CHANOFFEnabled[cbChannel.ItemIndex] := ckJunctionPot.Checked ;
    end;


procedure TTritonPanelFrm.ckRleakClick(Sender: TObject);
begin
    TritonSetEnable( TECELLA_REG_LEAK, ckRleak ) ;
    LEAKEnabled[cbChannel.ItemIndex] := ckRleak.Checked ;
    end;


procedure TTritonPanelFrm.bAutoCompensateClick(Sender: TObject);
// --------------------------------------------------------------
// Apply automatic capacity/leak compensation to selected channel
// --------------------------------------------------------------
var
    ch : Integer ;
    Enabled : Boolean ;
    Value : Single ;
    Units : String ;
begin

     bClearCompensation.Click ;

     // Stop seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StopADCAndDAC ;
     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Cell capacity compensation in progress.' ;

     bAutoCompensate.Enabled := False ;

     Screen.Cursor := crHourGlass ;

     // Apply compensation                                                                                         edVHold.Value := CompensationVHold ;
     CompensationVHold := edVHold.Value ;
     CompensationTHold := edTHold.Value ;
     CompensationVStep := edVStep.Value ;
     CompensationTStep := edTStep.Value ;
     CompensationCoeff := edCompensationCoeff.Value ;

     Main.SESLabIO.TritonAutoCompensation( ckUseCfast.Checked,
                                           ckUseCSlowA.Checked,
                                           ckUseCSlowB.Checked,
                                           ckUseCSlowC.Checked,
                                           ckUseCSlowD.Checked,
                                           ckUseAnalogLeakCompensation.Checked,
                                           ckUseDigitalLeakCompensation.Checked,
                                           ckUseDigitalArtefactSubtraction.Checked,
                                           edCompensationCoeff.Value,
                                           edVHold.Value,
                                           edTHold.Value,
                                           edVStep.Value,
                                           edTStep.Value
                                            ) ;

     // Update settings
     for ch := 0 to High(Source) do begin
        Main.SESLABIO.TritonGetReg(TECELLA_REG_CFAST,ch,Value,CFAST[ch],Units,Enabled) ;

        Main.SESLABIO.TritonGetreg(TECELLA_REG_CSLOW_A,ch,Value,CSLOW_A[ch],Units,
                                       CSLOW_AEnabled[ch]) ;
        Main.SESLABIO.TritonGetreg(TECELLA_REG_CSLOW_B,ch,Value,CSLOW_B[ch],Units,
                                       CSLOW_BEnabled[ch]) ;
        Main.SESLABIO.TritonGetreg(TECELLA_REG_CSLOW_C,ch,Value,CSLOW_C[ch],Units,
                                       CSLOW_CEnabled[ch]) ;
        Main.SESLABIO.TritonGetreg(TECELLA_REG_CSLOW_D,ch,Value,CSLOW_D[ch],Units,
                                       CSLOW_DEnabled[ch]) ;

        Main.SESLABIO.TritonGetreg(TECELLA_REG_RSERIES,ch,Value,RSERIES[ch],Units,
                                        RSERIESEnabled[ch]  ) ;
        Main.SESLABIO.TritonGetreg(TECELLA_REG_JP,ch,Value,CHANOFF[ch],Units,
                                       CHANOFFEnabled[ch]   ) ;
        Main.SESLABIO.TritonGetreg(TECELLA_REG_LEAK,ch,Value,LEAK[ch],Units,
                                       LEAKEnabled[ch]) ;
        end ;

     UpdatePanelControls ;

     // Restart seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

     bAutoCompensate.Enabled := True ;

     end;

procedure TTritonPanelFrm.bUpdateAllChannelsClick(Sender: TObject);
// --------------------------------------------------
// Make all channel settings same as selected channel
// --------------------------------------------------
var
    ch : Integer ;
    Freq : Single ;
begin

     // Update settings in Triton
     for ch := 0 to High(Source) do begin

         // Source
         Source[ch] :=  Min(Max(Source[cbChannel.ItemIndex],0),cbSource.Items.Count-1) ;
         Main.SESLABIO.TritonSource[ch] := Source[ch] ;
         if ch = cbChannel.ItemIndex then cbSource.ItemIndex := Source[ch] ;

         // Gain
         Gain[ch] :=  Min(Max(Gain[cbChannel.ItemIndex],0),cbGain.Items.Count-1) ;
         Main.SESLABIO.TritonGain[ch] := Gain[ch] ;
         if ch = cbChannel.ItemIndex then cbGain.ItemIndex := Gain[ch] ;

         CFAST[ch] := CFAST[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CFAST,ch,CFAST[ch]) ;

         BESSEL[ch] := BESSEL[cbChannel.ItemIndex] ;
         Main.SESLABIO.SetTritonBesselFilter( ch, Round(BESSEL[ch]), Freq ) ;

         CSLOW_A[ch] := CSLOW_A[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_A,ch,CSLOW_A[ch]) ;

         CSLOW_AEnabled[ch] := CSLOW_AEnabled[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_CSLOW_A,ch,CSLOW_AEnabled[ch]) ;

         CSLOW_B[ch] := CSLOW_B[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_B,ch,CSLOW_B[ch]) ;

         CSLOW_BEnabled[ch] := CSLOW_BEnabled[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_CSLOW_B,ch,CSLOW_BEnabled[ch]) ;

         CSLOW_C[ch] := CSLOW_C[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_C,ch,CSLOW_C[ch]) ;

         CSLOW_CEnabled[ch] := CSLOW_CEnabled[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_CSLOW_C,ch,CSLOW_CEnabled[ch]) ;

         CSLOW_D[ch] := CSLOW_D[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_D,ch,CSLOW_D[ch]) ;

         CSLOW_DEnabled[ch] := CSLOW_DEnabled[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_CSLOW_D,ch,CSLOW_DEnabled[ch]) ;

         RSERIES[ch] := RSERIES[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_RSERIES,ch,RSERIES[ch]) ;
         RSERIESEnabled[ch] := RSERIESEnabled[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_RSERIES,ch,RSERIESEnabled[ch]) ;

         CHANOFF[ch] := CHANOFF[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_JP,ch,CHANOFF[ch]) ;
         CHANOFFEnabled[ch] := CHANOFFEnabled[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_JP,ch,CHANOFFEnabled[ch]) ;

         LEAK[ch] := LEAK[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_LEAK,ch,LEAK[ch]) ;
         LEAKEnabled[ch] := LEAKEnabled[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_LEAK,ch,LEAKEnabled[ch]) ;

         end ;

end;

procedure TTritonPanelFrm.bClearCompensationClick(Sender: TObject);
// ---------------------------
// Clear capacity compensation
// ---------------------------
var
    ch : Integer ;
begin

     // Clear digital compensations
     Main.SESLabIO.TritonDigitalLeakSubtractionEnable(cbChannel.ItemIndex,False) ;
     Main.SESLabIO.TritonAutoArtefactRemovalEnable(False) ;

     for ch := 0 to High(Source) do
        if ckCompensateAllChannels.Checked or (ch = cbChannel.ItemIndex) then begin

        CFAST[ch] := 0 ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CFAST,ch,CFAST[ch]) ;

        CSLOW_A[ch] := 0 ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_A,ch,CSLOW_A[ch]) ;

        CSLOW_B[ch] := 0 ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_B,ch,CSLOW_B[ch]) ;

        CSLOW_C[ch] := 0 ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_C,ch,CSLOW_C[ch]) ;

        CSLOW_D[ch] := 0 ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_D,ch,CSLOW_D[ch]) ;

        RSERIES[ch] := 0 ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_RSERIES,ch,RSERIES[ch]) ;

        CHANOFF[ch] := 50 ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_JP,ch,CHANOFF[ch]) ;

        CHANOFFFine[ch] := 50 ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_JP_FINE,ch,CHANOFFFine[ch]) ;

        LEAK[ch] := 0 ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_LEAK,ch,LEAK[ch]) ;

        LEAKFine[ch] := 100 ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_LEAK_FINE,ch,LEAKFine[ch]) ;

        end ;

     UpdatePanelControls ;

     end;


procedure TTritonPanelFrm.bAutoJunctionNullClick(Sender: TObject);
// --------------------------------------------------------------
// Apply automatic junction potential null
// --------------------------------------------------------------
var
    ch : Integer ;
    Value : Single ;
    Units : string ;
begin

     // Stop seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StopADCAndDAC ;

     bAutoJunctionNull.Enabled := False ;

     Screen.Cursor := crHourGlass ;

     // Apply compensation
     Main.SESLabIO.TritonJPAutoZero ;

     // Update settings
     for ch := 0 to High(Source) do begin
        Main.SESLABIO.TritonGetreg(TECELLA_REG_JP,ch,Value,CHANOFF[ch],Units,
                                       CHANOFFEnabled[ch]   ) ;
        end ;

     UpdatePanelControls ;

     Screen.Cursor := crDefault ;

     // Restart seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;

     bAutoJunctionNull.Enabled := True ;

     end;


procedure TTritonPanelFrm.TimerTimer(Sender: TObject);
var
    Freq : Single ;

begin

     // Calibrate amplifier (if required)
     if (not Main.SESLabIO.TritonIsCalibrated) and
        bCalibrate.Enabled then bCalibrate.Click ;

     if GainUpdateRequired then begin
        Main.SESLABIO.TritonGain[cbChannel.ItemIndex] := cbGain.ItemIndex ;
        Gain[cbChannel.ItemIndex] := cbGain.ItemIndex ;
        GainUpdateRequired := False ;
        end ;

    if BesselFilterUpdateRequired then begin
       // BUG workaround! For some reason, a register must be set to the selected channel before
       // the call to SetTritonBesselFilter to ensure that the correct Triton channel bessel filter is updated
       Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CFAST,cbChannel.ItemIndex,CFAST[cbChannel.ItemIndex]) ;

       // Set bessel filter
       Bessel[cbChannel.ItemIndex] := tbFilter.Position ;
       Main.SESLabIO.SetTritonBesselFilter( cbChannel.ItemIndex,
                                            tbFilter.Position,
                                            Freq ) ;

       edFilter.Text := format('%.4g kHz',[Freq]) ;
       BesselFilterUpdateRequired := False ;


       end ;

    if CfastUpdateRequired then begin
       TritonSetPercent( TECELLA_REG_CFAST, edCFast, tbCFast ) ;
       CFAST[cbChannel.ItemIndex] := (tbCFast.Position*100.0)/tbCFast.Max ;
       CfastUpdateRequired := False ;
       end ;

    if CSlowAUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_CSLOW_A, edCSlowA, tbCSlowA ) ;
     CSLOW_A[cbChannel.ItemIndex] := (tbCSLOWA.Position*100.0)/tbCSLOWA.Max ;
     CSlowAUpdateRequired := False ;
     end ;

    if CSlowBUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_CSLOW_B, edCSlowB, tbCSlowB ) ;
     CSLOW_B[cbChannel.ItemIndex] := (tbCSLOWB.Position*100.0)/tbCSLOWB.Max ;
     CSlowBUpdateRequired := False ;
     end ;

    if CSlowCUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_CSLOW_C, edCSlowC, tbCSlowC ) ;
     CSLOW_C[cbChannel.ItemIndex] := (tbCSLOWC.Position*100.0)/tbCSLOWC.Max ;
     CSlowCUpdateRequired := False ;
     end ;

    if CSlowDUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_CSLOW_D, edCSlowD, tbCSlowD ) ;
     CSLOW_D[cbChannel.ItemIndex] := (tbCSLOWD.Position*100.0)/tbCSLOWD.Max ;
     CSlowDUpdateRequired := False ;
     end ;

    if RseriesUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_RSERIES, edRseries, tbRseries ) ;
     RSERIES[cbChannel.ItemIndex] := (tbRSeries.Position*100.0)/tbRSeries.Max ;
     RseriesUpdateRequired := False ;
     end ;

    if JunctionPotUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_JP, edJunctionPot, tbJunctionPot ) ;
     CHANOFF[cbChannel.ItemIndex] := (tbJunctionPot.Position*100.0)/tbJunctionPot.Max ;
     JunctionPotUpdateRequired := False ;
     end ;

    if JunctionPotFineUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_JP_FINE, edJunctionPotFine, tbJunctionPotFine ) ;
     CHANOFFFine[cbChannel.ItemIndex] := (tbJunctionPotFine.Position*100.0)/tbJunctionPotFine.Max ;
     JunctionPotFineUpdateRequired := False ;
     end ;

    if RleakUpdateRequired then begin
       TritonSetPercent( TECELLA_REG_LEAK, edRleak, tbRleak ) ;
       LEAK[cbChannel.ItemIndex] := (tbRLeak.Position*100.0)/tbRLeak.Max ;
       RleakUpdateRequired := False ;
       end ;

    if RleakFineUpdateRequired then begin
       TritonSetPercent( TECELLA_REG_LEAK_FINE, edRleakFine, tbRleakFine ) ;
       LEAKFine[cbChannel.ItemIndex] := (tbRLeakFine.Position*100.0)/tbRLeakFine.Max ;
       RleakFineUpdateRequired := False ;
       end ;

    end;



procedure TTritonPanelFrm.sbJunctionPotFineChange(Sender: TObject);
// -----------------------------------
// Junction potential fine setting changed
// -----------------------------------
begin
     JunctionPotFineUpdateRequired := True ;
     end;

procedure TTritonPanelFrm.cbUserConfigChange(Sender: TObject);
begin
     // Stop seal test recording form if it is open
     if Main.FormExists( 'SealTestFrm') then SealTestFrm.StopADCandDAC ;

     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Calibrating patch clamp amplifier' ;
     Main.SESLabIO.TritonUserConfig := cbUserConfig.ItemIndex ;
     UpdateTritonSettings ;
     Main.StatusBar.SimpleText := '' ;
     Screen.Cursor := crDefault ;

     if Main.FormExists( 'SealTestFrm') then SealTestFrm.StartADCandDAC ;
     
     end;

procedure TTritonPanelFrm.sbRLeakFineChange(Sender: TObject);
// ----------------------
// RLeak (fine) setting changed
// ----------------------
begin
    RleakFineUpdateRequired := True ;
    end;

procedure TTritonPanelFrm.ckRLeakFineClick(Sender: TObject);
begin
    TritonSetEnable( TECELLA_REG_LEAK_FINE, ckRleakFine ) ;
    LEAKFineEnabled[cbChannel.ItemIndex] := ckRleakFine.Checked ;
    end;

procedure TTritonPanelFrm.bZapClick(Sender: TObject);
// -----------
// Zap channel
// -----------
var
    ChanNum : Integer ;
begin

     // Stop seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StopADCAndDAC ;
     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Cell zap in progress.' ;

     if ckZapAllChannels.Checked then ChanNum := -1
                                 else ChanNum := cbChannel.ItemIndex ;
     Main.SESLabIO.TritonZap( edZapDuration.Value,
                         edZapAmplitude.Value,
                         ChanNum ) ;

     // Stop seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

     end;

procedure TTritonPanelFrm.tbFilterChange(Sender: TObject);
// ----------------------------------------------
// Update Bessel filter cut-off frequency setting
// ----------------------------------------------

begin
    BesselFilterUpdateRequired := True ;
    end;

procedure TTritonPanelFrm.tbCFastChange(Sender: TObject);
begin
    CfastUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.tbCSlowAChange(Sender: TObject);
begin
    CSlowAUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.tbCSlowBChange(Sender: TObject);
begin
    CSlowBUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.tbCSlowCChange(Sender: TObject);
begin
    CSlowCUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.tbCSlowDChange(Sender: TObject);
begin
    CSlowDUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.tbRSeriesChange(Sender: TObject);
begin
    RSeriesUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.tbRLeakChange(Sender: TObject);
begin
    RLeakUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.tbRLeakFineChange(Sender: TObject);
begin
    RLeakFineUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.tbJunctionPotChange(Sender: TObject);
begin
    JunctionPotUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.tbJunctionPotFineChange(Sender: TObject);
begin
    JunctionPotFineUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.bCalibrateClick(Sender: TObject);
// ---------------------
// Calibrate patch clamp
// ---------------------
begin

     bCalibrate.Enabled := False ;
     // Stop seal test recording form if it is open
     if Main.FormExists( 'SealTestFrm') then SealTestFrm.StopADCandDAC ;

     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Calibrating patch clamp amplifier' ;
     Main.SESLabIO.TritonCalibrate ;
     Main.SESLabIO.TritonUserConfig := cbUserConfig.ItemIndex ;
     UpdateTritonSettings ;
     Main.StatusBar.SimpleText := '' ;
     Screen.Cursor := crDefault ;

     if Main.FormExists( 'SealTestFrm') then SealTestFrm.StartADCandDAC ;
     bCalibrate.Enabled := True ;

     end;

procedure TTritonPanelFrm.ckUseDigitalArtefactSubtractionClick(
  Sender: TObject);
begin
     Main.SESLabIO.TritonAutoArtefactRemovalEnable(ckUseDigitalArtefactSubtraction.Checked) ;
     UseDigitalArtefactRemoval := ckUseDigitalArtefactSubtraction.Checked ;
     end;

procedure TTritonPanelFrm.ckUseDigitalLeakCompensationClick(
  Sender: TObject);
begin
     Main.SESLabIO.TritonDigitalLeakSubtractionEnable(cbChannel.ItemIndex,ckUseDigitalLeakCompensation.Checked) ;
     UseDigitalLeakSubtraction := ckUseDigitalLeakCompensation.Checked ;
     end;


procedure TTritonPanelFrm.SaveToXMLFile(
           FileName : String
           ) ;
// -------------------------------------------
// Save tecella amplifier settings to XML file
// -------------------------------------------
begin
    CoInitialize(Nil) ;
    SaveToXMLFile1( FileName ) ;
    CoUnInitialize ;
    end ;


procedure TTritonPanelFrm.SaveToXMLFile1(
           FileName : String
           ) ;
// -------------------------------------------
// Save tecella amplifier settings to XML file (internal)
// -------------------------------------------
var
   iNode,ProtNode : IXMLNode;
   i : Integer ;
   s : TStringList ;
   XMLDoc : IXMLDocument ;
begin

    ckUseAnalogLeakCompensation.checked := UseAnalogLeakSubtraction ;
    ckUseDigitalLeakCompensation.Checked := UseDigitalLeakSubtraction ;
    ckUseDigitalArtefactSubtraction.Checked := UseDigitalArtefactRemoval ;
    ckUseCfast.Checked := UseCfastCompensation ;
    ckUseCSlowA.Checked := UseCSlowACompensation ;
    ckUseCSlowB.Checked := UseCSlowBCompensation ;
    ckUseCSlowC.Checked := UseCSlowCCompensation ;
    ckUseCSlowD.Checked := UseCSlowDCompensation ;
    ckCompensateAllChannels.Checked := CompensateAllChannels ;
    edCompensationCoeff.Value := CompensationCoeff ;
    edVHold.Value := CompensationVHold ;
    edTHold.Value := CompensationTHold ;
    edVStep.Value := CompensationVStep ;
    edTStep.Value := CompensationTStep ;
    ckEnableDACStreaming.Checked := EnableDACStreaming ;

    XMLDoc := TXMLDocument.Create(Self);
    XMLDoc.Active := True ;

    // Clear document
    XMLDoc.ChildNodes.Clear ;

    // Add record name
    ProtNode := XMLDoc.AddChild( 'TECELLASETTINGS' ) ;

    AddElementFloat( ProtNode, 'ZAPAMPLITUDE', ZapAmplitude ) ;
    AddElementFloat( ProtNode, 'ZAPDURATION', ZapDuration ) ;

    AddElementBool( ProtNode, 'USEANALOGLEAKSUBTRACTION',UseAnalogLeakSubtraction) ;
    AddElementBool( ProtNode, 'USEDIGITALEAKSUBTRACTION',UseDigitalLeakSubtraction) ;
    AddElementBool( ProtNode, 'USEDIGITALARTERFACTREMOVAL',UseDigitalArtefactRemoval) ;
    AddElementBool( ProtNode, 'USECFASTCOMPENSATION',UseCfastCompensation) ;
    AddElementBool( ProtNode, 'USECSLOWACOMPENSATION',UseCSlowACompensation) ;
    AddElementBool( ProtNode, 'USECSLOWBCOMPENSATION',UseCSlowBCompensation) ;
    AddElementBool( ProtNode, 'USECSLOWCCOMPENSATION',UseCSlowCCompensation) ;
    AddElementBool( ProtNode, 'USECSLOWDCOMPENSATION',UseCSlowDCompensation) ;

    AddElementBool( ProtNode, 'COMPENSATEALLCHANNELS',CompensateAllChannels) ;
    AddElementFloat( ProtNode, 'COMPENSATIONCOEFF',CompensationCoeff) ;
    AddElementFloat( ProtNode, 'COMPENSATIONVHOLD',CompensationVHold) ;
    AddElementFloat( ProtNode, 'COMPENSATIONTHOLD',CompensationTHold) ;
    AddElementFloat( ProtNode, 'COMPENSATIONVSTEP',CompensationVStep) ;
    AddElementFloat( ProtNode, 'COMPENSATIONTSTEP',CompensationTStep) ;
    AddElementBool( ProtNode, 'ENABLEDACSTREAMING',EnableDACStreaming) ;

    // Input channels
    for i := 0 to MaxTecellaChannels-1 do begin
         iNode := ProtNode.AddChild( 'CHANNEL' ) ;
         AddElementInt( iNode, 'NUMBER', i ) ;
         AddElementInt( iNode, 'SOURCE', Source[i]);
         AddElementInt( iNode, 'GAIN', Gain[i]);
         AddElementFloat( iNode, 'INPUTRANGE', InputRange[i]) ;
         AddElementFloat( iNode, 'CFAST', CFAST[i]);
         AddElementBool( iNode, 'CSLOW_AENABLED', CSLOW_AEnabled[i]);
         AddElementFloat( iNode, 'CSLOW_A', CSLOW_A[i]);
         AddElementBool( iNode, 'CSLOW_BENABLED', CSLOW_BEnabled[i]);
         AddElementFloat( iNode, 'CSLOW_B', CSLOW_B[i]);
         AddElementBool( iNode, 'CSLOW_CENABLED', CSLOW_CEnabled[i]);
         AddElementFloat( iNode, 'CSLOW_C', CSLOW_C[i]);
         AddElementBool( iNode, 'CSLOW_DENABLED', CSLOW_DEnabled[i]);
         AddElementFloat( iNode, 'CSLOW_D', CSLOW_D[i]);
         AddElementBool( iNode, 'RSERIESENABLED', RSERIESEnabled[i]);
         AddElementFloat( iNode, 'RSERIES', RSERIES[i]);
         AddElementBool( iNode, 'CHANOFFENABLED', CHANOFFEnabled[i]);
         AddElementFloat( iNode, 'CHANOFF', CHANOFF[i]);
         AddElementBool( iNode, 'LEAKENABLED', LEAKEnabled[i]);
         AddElementFloat( iNode, 'LEAK', LEAK[i]);
         AddElementFloat( iNode, 'BESSEL', BESSEL[i]);
         end ;

     s := TStringList.Create;
     s.Assign(xmlDoc.XML) ;
     //sl.Insert(0,'<!DOCTYPE ns:mys SYSTEM "myXML.dtd">') ;
     s.Insert(0,'<?xml version="1.0"?>') ;
     s.SaveToFile( FileName ) ;
     s.Free ;
     XMLDoc.Active := False ;
     XMLDoc := Nil ;

    end ;


procedure TTritonPanelFrm.LoadFromXMLFile(
          FileName : String                    // XML protocol file
          ) ;
// ----------------------------------
// Load settings from XML file
// ----------------------------------
begin
    CoInitialize(Nil) ;
    LoadFromXMLFile1( FileName ) ;
    CoUnInitialize ;
    end ;



procedure TTritonPanelFrm.LoadFromXMLFile1(
          FileName : String                    // XML protocol file
          ) ;
// ----------------------------------
// Load settings from XML file  (internal)
// ----------------------------------
var
   iNode,ProtNode : IXMLNode;
   i : Integer ;

   NodeIndex : Integer ;
   XMLDoc : IXMLDocument ;
begin

    XMLDoc := TXMLDocument.Create(Self) ;

    XMLDOC.Active := False ;

    XMLDOC.LoadFromFile( FileName ) ;
    XMLDoc.Active := True ;

//    for i := 0 to  xmldoc.DocumentElement.ChildNodes.Count-1 do
//        OutputDebugString( PChar(String(xmldoc.DocumentElement.ChildNodes[i].NodeName))) ;

    ProtNode := xmldoc.DocumentElement ;

    GetElementFloat( ProtNode, 'ZAPAMPLITUDE', ZapAmplitude ) ;
    GetElementFloat( ProtNode, 'ZAPDURATION', ZapDuration ) ;

    GetElementBool( ProtNode, 'USEANALOGLEAKSUBTRACTION',UseAnalogLeakSubtraction) ;
    GetElementBool( ProtNode, 'USEDIGITALEAKSUBTRACTION',UseDigitalLeakSubtraction) ;
    GetElementBool( ProtNode, 'USEDIGITALARTERFACTREMOVAL',UseDigitalArtefactRemoval) ;
    GetElementBool( ProtNode, 'USECFASTCOMPENSATION',UseCfastCompensation) ;
    GetElementBool( ProtNode, 'USECSLOWACOMPENSATION',UseCSlowACompensation) ;
    GetElementBool( ProtNode, 'USECSLOWBCOMPENSATION',UseCSlowBCompensation) ;
    GetElementBool( ProtNode, 'USECSLOWCCOMPENSATION',UseCSlowCCompensation) ;
    GetElementBool( ProtNode, 'USECSLOWDCOMPENSATION',UseCSlowDCompensation) ;

    GetElementBool( ProtNode, 'COMPENSATEALLCHANNELS',CompensateAllChannels) ;
    GetElementFloat( ProtNode, 'COMPENSATIONCOEFF',CompensationCoeff) ;
    GetElementFloat( ProtNode, 'COMPENSATIONVHOLD',CompensationVHold) ;
    GetElementFloat( ProtNode, 'COMPENSATIONTHOLD',CompensationTHold) ;
    GetElementFloat( ProtNode, 'COMPENSATIONVSTEP',CompensationVStep) ;
    GetElementFloat( ProtNode, 'COMPENSATIONTSTEP',CompensationTStep) ;
    GetElementBool( ProtNode, 'ENABLEDACSTREAMING',EnableDACStreaming) ;

    // Amplifiers
    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'CHANNEL',iNode,NodeIndex) do begin
        GetElementInt( iNode, 'NUMBER', i ) ;
        if (i >= 0) and (i < MaxTecellaChannels) then begin
           GetElementInt( iNode, 'NUMBER', i ) ;
           GetElementInt( iNode, 'SOURCE', Source[i]);
           GetElementInt( iNode, 'GAIN', Gain[i]);
           GetElementFloat( iNode, 'INPUTRANGE', InputRange[i]) ;
           GetElementFloat( iNode, 'CFAST', CFAST[i]);
           GetElementBool( iNode, 'CSLOW_AENABLED', CSLOW_AEnabled[i]);
           GetElementFloat( iNode, 'CSLOW_A', CSLOW_A[i]);
           GetElementBool( iNode, 'CSLOW_BENABLED', CSLOW_BEnabled[i]);
           GetElementFloat( iNode, 'CSLOW_B', CSLOW_B[i]);
           GetElementBool( iNode, 'CSLOW_CENABLED', CSLOW_CEnabled[i]);
           GetElementFloat( iNode, 'CSLOW_C', CSLOW_C[i]);
           GetElementBool( iNode, 'CSLOW_DENABLED', CSLOW_DEnabled[i]);
           GetElementFloat( iNode, 'CSLOW_D', CSLOW_D[i]);
           GetElementBool( iNode, 'RSERIESENABLED', RSERIESEnabled[i]);
           GetElementFloat( iNode, 'RSERIES', RSERIES[i]);
           GetElementBool( iNode, 'CHANOFFENABLED', CHANOFFEnabled[i]);
           GetElementFloat( iNode, 'CHANOFF', CHANOFF[i]);
           GetElementBool( iNode, 'LEAKENABLED', LEAKEnabled[i]);
           GetElementFloat( iNode, 'LEAK', LEAK[i]);
           GetElementFloat( iNode, 'BESSEL', BESSEL[i]);
           end ;
        Inc(NodeIndex) ;
        end ;

    XMLDoc.Active := False ;
    XMLDoc := Nil ;

    end ;


procedure TTritonPanelFrm.AddElementFloat(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Single
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := format('%.10g',[Value]) ;

    end ;


function TTritonPanelFrm.GetElementFloat(
         ParentNode : IXMLNode ;
         NodeName : String ;
         var Value : Single
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   OldValue : Single ;
   NodeIndex : Integer ;
   s,dsep : string ;
begin
    Result := False ;
    OldValue := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       { Correct for use of comma/period as decimal separator }
       s := ChildNode.Text ;
       { Correct for use of comma/period as decimal separator }
       {$IF CompilerVersion > 7.0} dsep := formatsettings.DECIMALSEPARATOR ;
       {$ELSE} dsep := DECIMALSEPARATOR ;
       {$IFEND}
       if dsep = '.' then s := ANSIReplaceText(s ,',',dsep);
       if dsep = ',' then s := ANSIReplaceText(s, '.',dsep);

       try
          Value := StrToFloat(s) ;
          Result := True ;
       except
          Value := OldValue ;
          Result := False ;
          end ;
       end ;

    end ;


procedure TTritonPanelFrm.AddElementInt(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Integer
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := format('%d',[Value]) ;

    end ;


function TTritonPanelFrm.GetElementInt(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : Integer
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
   OldValue : Integer ;
begin
    Result := False ;
    OldValue := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       try
          Value := StrToInt(ChildNode.Text) ;
          Result := True ;
       except
          Value := OldValue ;
          Result := False ;
          end ;
       end ;
    end ;


procedure TTritonPanelFrm.AddElementBool(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Boolean
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    if Value = True then ChildNode.Text := 'T'
                    else ChildNode.Text := 'F' ;

    end ;


function TTritonPanelFrm.GetElementBool(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : Boolean
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
begin
    Result := False ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       if ANSIContainsText(ChildNode.Text,'T') then Value := True
                                               else  Value := False ;
       Result := True ;
       end ;

    end ;


procedure TTritonPanelFrm.AddElementText(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : String
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := Value ;

    end ;


function TTritonPanelFrm.GetElementText(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : String
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
begin

    Result := False ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       Value := ChildNode.Text ;
       Result := True ;
       end ;

    end ;


function TTritonPanelFrm.FindXMLNode(
         const ParentNode : IXMLNode ;  // Node to be searched
         NodeName : String ;            // Element name to be found
         var ChildNode : IXMLNode ;     // Child Node of found element
         var NodeIndex : Integer        // ParentNode.ChildNodes Index #
                                        // Starting index on entry, found index on exit
         ) : Boolean ;
// -------------
// Find XML node
// -------------
var
    i : Integer ;
begin

    Result := False ;
    for i := NodeIndex to ParentNode.ChildNodes.Count-1 do begin
      if ParentNode.ChildNodes[i].NodeName = WideString(NodeName) then begin
         Result := True ;
         ChildNode := ParentNode.ChildNodes[i] ;
         NodeIndex := i ;
         Break ;
         end ;
      end ;
    end ;



procedure TTritonPanelFrm.FormCreate(Sender: TObject);
// ------------------------------------
// Initialisations when form is created
// ------------------------------------
var
    i : Integer ;
begin

     // Default Tecella amplifier settings

     for i := 0 to High(Source) do begin
         Source[i] := 0 ;
         Gain[i] := 0 ;
         InputRange[i] := 1E-7 ;
         CFAST[i] := 0 ;
         CSLOW_A[i] := 0 ;
         CSLOW_B[i] := 0 ;
         CSLOW_C[i] := 0 ;
         CSLOW_D[i] := 0 ;
         RSERIES[i] := 0 ;
         CHANOFF[i] := 0 ;
         LEAK[i] := 0 ;
         BESSEL[i] := 0 ;
         CSLOW_AEnabled[i] := False ;
         CSLOW_BEnabled[i] := False ;
         CSLOW_CEnabled[i] := False ;
         CSLOW_DEnabled[i] := False ;
         RSERIESEnabled[i] := False ;
         CHANOFFEnabled[i] := False ;
         LEAKEnabled[i] := False ;
         end ;
     ZapAmplitude := 1.0 ;
     ZapDuration := 1.0 ;
     UseAnalogLeakSubtraction := True ;
     UseDigitalLeakSubtraction := True ;
     UseDigitalArtefactRemoval  := True ;
     UseCfastCompensation := True ;
     UseCSlowACompensation := True ;
     UseCSlowBCompensation := True ;
     UseCSlowCCompensation := True ;
     UseCSlowDCompensation := True ;
     CompensateAllChannels  := True ;
     CompensationCoeff := 0.0 ;
     CompensationVHold := -0.09 ;
     CompensationTHold := 0.02 ;
     CompensationVStep := 0.01 ;
     CompensationTStep := 0.02 ;

     // Load settings from XML file
     SettingsFileName := Main.SettingsDirectory + 'tecella settings.xml' ;
     if FileExists( SettingsFileName ) then LoadFromXMLFile( SettingsFileName ) ;

     end;

procedure TTritonPanelFrm.FormDestroy(Sender: TObject);
// ------------------------------------
// Save settings when form is destroyed
// ------------------------------------
begin

    SaveToXMLFile(SettingsFileName) ;

    end;

procedure TTritonPanelFrm.ckUseAnalogLeakCompensationClick(
  Sender: TObject);
begin
     UseAnalogLeakSubtraction := ckUseAnalogLeakCompensation.Checked ;
     end;

procedure TTritonPanelFrm.ckCompensateAllChannelsClick(Sender: TObject);
begin
     CompensateAllChannels := ckCompensateAllChannels.Checked ;
     end;

procedure TTritonPanelFrm.edCompensationCoeffKeyPress(Sender: TObject;
  var Key: Char);
begin
     if Key = #13 then CompensationCoeff := edCompensationCoeff.Value ;
     end;

procedure TTritonPanelFrm.ckEnableDACStreamingClick(Sender: TObject);
begin
     Main.SESLabIO.TritonDACStreamingEnabled := ckEnableDACStreaming.Checked ;
     EnableDACStreaming := Main.SESLabIO.TritonDACStreamingEnabled ;
     ckEnableDACStreaming.Checked := EnableDACStreaming ;
     end;

procedure TTritonPanelFrm.ckICLAMPOnClick(Sender: TObject);
// ------------------------------
// ICLAMPOn mode enabled/disabled
// ------------------------------
begin
     // ICLAMPOn = True permits current stimulation in ICLAMP mode
     Main.SESLabIO.TritonICLAMPOn := ckICLAMPOn.Checked ;
     end ;

procedure TTritonPanelFrm.ckUseCSlowAClick(Sender: TObject);
begin
     UseCSlowACompensation := ckUseCSlowA.Checked ;
     end;

procedure TTritonPanelFrm.ckUseCSlowBClick(Sender: TObject);
begin
     UseCSlowBCompensation := ckUseCSlowB.Checked ;
     end;

procedure TTritonPanelFrm.ckUseCSlowCClick(Sender: TObject);
begin
     UseCSlowCCompensation := ckUseCSlowC.Checked ;
     end;

procedure TTritonPanelFrm.ckUseCSlowDClick(Sender: TObject);
begin
     UseCSlowDCompensation := ckUseCSlowD.Checked ;
     end;

procedure TTritonPanelFrm.ckUseCFastClick(Sender: TObject);
begin
     UseCfastCompensation := ckUseCfast.Checked ;
     end;

procedure TTritonPanelFrm.edVHoldKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then CompensationVHold := edVHold.Value ;
     end;


procedure TTritonPanelFrm.edTHoldKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then CompensationTHold := edTHold.Value ;
     end;

procedure TTritonPanelFrm.edVStepKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then CompensationVStep := edVStep.Value ;
     end;

procedure TTritonPanelFrm.edTStepKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then CompensationTStep := edTStep.Value ;
     end;

end.
