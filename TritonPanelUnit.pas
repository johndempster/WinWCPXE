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
// 08.05.18 Settings can now be changed by entering values into text boxes in addition to using trackbars
//          Fine junction potential now retained when configuration changed
//          Corresponding Head and model input sources now selected when switching between current- and voltage-clamp
//          configs of Pico
//          CurrentStimulusBias field added. Current added to stimulus current to compensate for stimulus bias current of Pico
// 20.03.19 CFast now set to zer0 (rather than negative capacity when Clear Compensation selected
// 03.04.19 Compensation controls re-arranged to simply compensation operations
//          Auto Cfast, Cslow and artefact compensation now carried out as separate operations
//          CFast and total Cslow capacity now display and can be enabled and disabled within WinWCP code rather
//          than using Pico functions. Additional properties added implementing control of patch clamp functions from AUTOUNIT.pas
// 09.04.19 Rleak and RLeakfine enable/disable now works
// 11.04.19 Now uses TritonRemoveArtifact() procedure to remove artifact remaining after C compensation
// 16.04.19 Analogue and digital leak conductance now handled as components of the overall leak conductance
//          rather than as advanced proerties.
// 18.08.19 Support for 16/32 channel Triton X added
// 27.08.21 Auto compensation functions now stop A/D and D/A in both seal test and record forms

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ValidatedEdit, TritonUnit, math, ExtCtrls,
  ComCtrls, xmldoc, xmlintf, strutils, ActiveX ;

const
    MaxTecellaChannels = 32 ;

type
  TTritonPanelFrm = class(TForm)
    gControls: TGroupBox;
    gCompensation: TGroupBox;
    gChannel: TGroupBox;
    Label1: TLabel;
    cbChannel: TComboBox;
    gAmplifier: TGroupBox;
    Label10: TLabel;
    cbGain: TComboBox;
    cbSource: TComboBox;
    lbSource: TLabel;
    gFilter: TGroupBox;
    bUpdateAllChannels: TButton;
    Timer: TTimer;
    edModel: TEdit;
    Label11: TLabel;
    edFilter: TEdit;
    cbUserConfig: TComboBox;
    Label13: TLabel;
    gZap: TGroupBox;
    bZap: TButton;
    edZapDuration: TValidatedEdit;
    edZapAmplitude: TValidatedEdit;
    Label15: TLabel;
    Label16: TLabel;
    ckZapAllChannels: TCheckBox;
    tbFilter: TTrackBar;
    AutoCompPage: TPageControl;
    AutoPage: TTabSheet;
    CapacityPage: TTabSheet;
    ResistancePage: TTabSheet;
    JunctionPotPage: TTabSheet;
    panJunctionPot: TPanel;
    Label8: TLabel;
    ckJunctionPot: TCheckBox;
    tbJunctionPot: TTrackBar;
    panJunctionPotFIne: TPanel;
    Label12: TLabel;
    ckJunctionPotFine: TCheckBox;
    tbJunctionPotFine: TTrackBar;
    panCFast: TPanel;
    Label2: TLabel;
    tbCFast: TTrackBar;
    panRSeries: TPanel;
    Label7: TLabel;
    ckRseries: TCheckBox;
    tbRSeries: TTrackBar;
    ckCompensateAllChannels: TCheckBox;
    edJunctionPot: TValidatedEdit;
    edJunctionPotFine: TValidatedEdit;
    edRSeries: TValidatedEdit;
    edCFast: TValidatedEdit;
    gpCurrentStimulus: TGroupBox;
    Label22: TLabel;
    ckICLAMPOn: TCheckBox;
    edCurrentStimulusBias: TValidatedEdit;
    AdvancedTab: TTabSheet;
    GroupBox6: TGroupBox;
    Label17: TLabel;
    edCompensationCoeff: TValidatedEdit;
    gAutoCapacityComp: TGroupBox;
    bCFastAutoComp: TButton;
    bCSlowAutoComp: TButton;
    bClearCompensation: TButton;
    gAutoJPComp: TGroupBox;
    bAutoCompJunctionPot: TButton;
    bClearJPComp: TButton;
    gAutoLeakComp: TGroupBox;
    bAutoLeakComp: TButton;
    bCleakLeakComp: TButton;
    panCTotal: TPanel;
    panCSlowTotal: TPanel;
    Label24: TLabel;
    edCSlowTotal: TValidatedEdit;
    bCalibrate: TButton;
    ckCFast: TCheckBox;
    ckEnableDACStreaming: TCheckBox;
    pCSlowComponents: TPanel;
    panCSlowD: TPanel;
    Label6: TLabel;
    ckCslowD: TCheckBox;
    tbCSlowD: TTrackBar;
    edCSlowD: TValidatedEdit;
    panCSlowC: TPanel;
    Label5: TLabel;
    ckCslowC: TCheckBox;
    tbCSlowC: TTrackBar;
    edCSlowC: TValidatedEdit;
    panCSlowB: TPanel;
    Label4: TLabel;
    ckCslowB: TCheckBox;
    tbCSlowB: TTrackBar;
    edCSlowB: TValidatedEdit;
    panCSlowA: TPanel;
    Label3: TLabel;
    ckCslowA: TCheckBox;
    tbCSlowA: TTrackBar;
    edCSlowA: TValidatedEdit;
    ckCSlow: TCheckBox;
    CheckBox2: TCheckBox;
    ckShowCSlowComponents: TCheckBox;
    bAutoCompArterfact: TButton;
    pRLeakComponents: TPanel;
    panRLeakAnalog: TPanel;
    Label9: TLabel;
    ckRleakAnalog: TCheckBox;
    tbRLeakAnalog: TTrackBar;
    edRLeakAnalog: TValidatedEdit;
    panRLeakFineAnalog: TPanel;
    Label14: TLabel;
    ckRLeakFineAnalog: TCheckBox;
    tbRLeakFineAnalog: TTrackBar;
    edRLeakFineAnalog: TValidatedEdit;
    panRleakDigital: TPanel;
    Label18: TLabel;
    edRLeakDigital: TValidatedEdit;
    ckRLeakDigital: TCheckBox;
    CheckBox3: TCheckBox;
    Panel1: TPanel;
    Label19: TLabel;
    edRLeakTotal: TValidatedEdit;
    ckRLeak: TCheckBox;
    CheckBox4: TCheckBox;
    ckShowRLeakComponents: TCheckBox;
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
    procedure ckRleakAnalogClick(Sender: TObject);
    procedure bCFastAutoCompClick(Sender: TObject);
    procedure bUpdateAllChannelsClick(Sender: TObject);
    procedure bClearCompensationClick(Sender: TObject);
    procedure bAutoCompJunctionPotClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure sbJunctionPotFineChange(Sender: TObject);
    procedure cbUserConfigChange(Sender: TObject);
    procedure sbRLeakFineChange(Sender: TObject);
    procedure ckRLeakFineAnalogClick(Sender: TObject);
    procedure bZapClick(Sender: TObject);
    procedure tbFilterChange(Sender: TObject);
    procedure tbCFastChange(Sender: TObject);
    procedure tbCSlowAChange(Sender: TObject);
    procedure tbCSlowBChange(Sender: TObject);
    procedure tbCSlowCChange(Sender: TObject);
    procedure tbCSlowDChange(Sender: TObject);
    procedure tbRSeriesChange(Sender: TObject);
    procedure tbRLeakAnalogChange(Sender: TObject);
    procedure tbRLeakFineAnalogChange(Sender: TObject);
    procedure tbJunctionPotChange(Sender: TObject);
    procedure tbJunctionPotFineChange(Sender: TObject);
    procedure bCalibrateClick(Sender: TObject);
    procedure ckUseDigitalArtefactSubtractionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ckCompensateAllChannelsClick(Sender: TObject);
    procedure edCompensationCoeffKeyPress(Sender: TObject; var Key: Char);
    procedure ckEnableDACStreamingClick(Sender: TObject);
    procedure ckICLAMPOnClick(Sender: TObject);
    procedure edJunctionPotKeyPress(Sender: TObject; var Key: Char);
    procedure edJunctionPotFineKeyPress(Sender: TObject; var Key: Char);
    procedure edRSeriesKeyPress(Sender: TObject; var Key: Char);
    procedure edRLeakAnalogKeyPress(Sender: TObject; var Key: Char);
    procedure edRLeakFineAnalogKeyPress(Sender: TObject; var Key: Char);
    procedure edCFastKeyPress(Sender: TObject; var Key: Char);
    procedure edCSlowAKeyPress(Sender: TObject; var Key: Char);
    procedure edCSlowBKeyPress(Sender: TObject; var Key: Char);
    procedure edCSlowCKeyPress(Sender: TObject; var Key: Char);
    procedure edCSlowDKeyPress(Sender: TObject; var Key: Char);
    procedure ckJunctionPotFineClick(Sender: TObject);
    procedure edCurrentStimulusBiasKeyPress(Sender: TObject; var Key: Char);
    procedure bCSlowAutoCompClick(Sender: TObject);
    procedure bClearJPCompClick(Sender: TObject);
    procedure bAutoLeakCompClick(Sender: TObject);
    procedure bCleakLeakCompClick(Sender: TObject);
    procedure ckCFastClick(Sender: TObject);
    procedure ckShowCSlowComponentsClick(Sender: TObject);
    procedure ckCSlowClick(Sender: TObject);
    procedure bAutoCompArterfactClick(Sender: TObject);
    procedure ckShowRLeakComponentsClick(Sender: TObject);
    procedure ckRLeakClick(Sender: TObject);
    procedure ckRLeakDigitalClick(Sender: TObject);
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
    RLeakDigitalUpdateRequired : Boolean ;
    CurrentStimulusBiasUpdateRequired : Boolean ;
    SealTestStartRequired : Boolean ;
    SettingsFileName : String ;

    // Tecella amplifier settings
    FSource : Array[0..MaxTecellaChannels-1] of Integer ;
    LastSourceName : Array[0..MaxTecellaChannels-1] of string ;
    FGain : Array[0..MaxTecellaChannels-1] of Integer ;
    InputRange : Array[0..MaxTecellaChannels-1] of Single ;
    FCFAST : Array[0..MaxTecellaChannels-1] of Single ;
    CSLOW_A : Array[0..MaxTecellaChannels-1] of Single ;
    CSLOW_B : Array[0..MaxTecellaChannels-1] of Single ;
    CSLOW_C : Array[0..MaxTecellaChannels-1] of Single ;
    CSLOW_D : Array[0..MaxTecellaChannels-1] of Single ;
    RSERIES : Array[0..MaxTecellaChannels-1] of Single ;
    CHANOFF : Array[0..MaxTecellaChannels-1] of Single ;
    CHANOFFFine : Array[0..MaxTecellaChannels-1] of Single ;
    LEAK : Array[0..MaxTecellaChannels-1] of Single ;
    LEAKFine : Array[0..MaxTecellaChannels-1] of Single ;
    LEAKDigital : Array[0..MaxTecellaChannels-1] of Single ;
    BESSEL : Array[0..MaxTecellaChannels-1] of Single ;
    CFastEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    CSLOW_AEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    CSLOW_BEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    CSLOW_CEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    CSLOW_DEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    RSERIESEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    CHANOFFEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    LEAKEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    LEAKFineEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
    LEAKDigitalEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;

    CHANOFFFineEnabled : Array[0..MaxTecellaChannels-1] of Boolean ;
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
    CurrentStimulusBias : Single ;


    procedure TritonGetValueAndEnabled(
              TritonRegister : Integer ;
              iChan : Integer ;
              var EditControl : TValidatedEdit ;
              var SliderControl : TTrackBar ;
              var EnableBox : TCheckBox ) ;

    procedure TritonGetValue(
              TritonRegister : Integer ;
              iChan : Integer ;
              var EditControl : TValidatedEdit ;
              var SliderControl : TTrackBar  ) ;

    procedure TritonSetPercent(
              TritonRegister : Integer ;
              var EditControl : TValidatedEdit ;
              var SliderControl : TTrackBar ;
              Enabled : Boolean ) ;

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

    function ConvertToTrackBarPosition(
             Reg : Integer ;                  // Register ID
             Value : Single ;                 // Register value
             TrackBar : TTrackBar            // Track bar
             ) : Integer ;                     // Returns Track bar position

   procedure StopADCAndDAC ;


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

    function GetGain : Integer ;
    procedure SetGain( Value : Integer ) ;
    function GetSource : Integer ;
    procedure SetSource( Value : Integer ) ;
    function GetFilter : Integer ;
    procedure SetFilter( Value : Integer ) ;
    function GetUserConfig : Integer ;
    procedure SetUserConfig( Value : Integer ) ;
    function GetEnableCFast : Boolean ;
    procedure SetEnableCFast( Value : Boolean ) ;
    function GetEnableCSlow : Boolean ;
    procedure SetEnableCSlow( Value : Boolean ) ;
    function GetEnableJP : Boolean ;
    procedure SetEnableJP( Value : Boolean ) ;
    function GetCSlow : Single ;
    function GetCFast : Single ;
    function GetJP : single ;

  public
    { Public declarations }
    procedure UpdateTritonSettings ;
    procedure LoadFromXMLFile( FileName : String ) ;
    procedure SaveToXMLFile( FileName : String ) ;
    procedure AutoCompCFast ;
    procedure AutoCompCSlow ;
    procedure AutoCompArtefact ;
    procedure AutoCompJunctionPot ;
    procedure ClearCompC ;
    procedure ClearCompJP ;
    property Gain : Integer read GetGain write SetGain ;
    property Source : Integer read GetSource write SetSource ;
    property Filter : Integer read GetFilter write SetFilter ;
    property UserConfig : Integer read GetUserConfig write SetUserConfig ;
    property EnableCFast : Boolean read GetEnableCFast write SetEnableCFast ;
    property EnableCSlow : Boolean read GetEnableCSlow write SetEnableCSlow ;
    property EnableJP : Boolean read GetEnableJP write SetEnableJP ;
    property CSlow : Single read GetCSlow ;
    property CFast : Single read GetCFast ;
    property JP : single read GetJP ;


  end;

var
  TritonPanelFrm: TTritonPanelFrm;

implementation

uses MDIForm, Sealtest, REC, WCPFIleUnit;

{$R *.dfm}

procedure TTritonPanelFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
var
    ch : Integer ;
begin

     ClientWidth := gControls.Left + gControls.Width + 5 ;
     ClientHeight := gControls.Top + gControls.Height + 5 ;
     DisableTritonUpdates := False ;

     if Main.SESLabIO.TritonNumChannels > 1 then
        begin
        gChannel.Visible := True ;
        gAmplifier.Top := gChannel.Top + gChannel.Height + 5 ;
        end
     else
        begin
        gChannel.Visible := False ;
        gAmplifier.Top := gChannel.Top ;
        end;

     ckZapAllChannels.Visible := gChannel.Visible ;
     ckCompensateAllChannels.Visible := gChannel.Visible ;
     gFilter.Top := gAmplifier.Top + gAmplifier.Height + 5 ;
     gCompensation.Top := gFilter.Top + gFilter.Height + 5 ;
     gZap.Top := gCompensation.Top + gCompensation.Height ;
     gControls.ClientHeight := gZap.Top + gZap.Height + 5 ;

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
     SetSlider( tbRLeakAnalog, panRLeakAnalog, TECELLA_REG_LEAK ) ;
     SetSlider( tbRLeakFineAnalog, panRLeakFineAnalog, TECELLA_REG_LEAK_FINE ) ;
     SetSlider( tbRSeries, panRSeries, TECELLA_REG_RSERIES ) ;

     pCSlowComponents.Visible := ckShowCSlowComponents.Checked ;
     pRLeakComponents.Visible := ckShowRLeakComponents.Checked ;

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
     JunctionPotFineUpdateRequired := False ;
     RleakUpdateRequired := False ;
     RleakFineUpdateRequired := False ;
     CurrentStimulusBiasUpdateRequired := False ;

     edZapAmplitude.Value := ZapAmplitude ;
     edZapDuration.Value := ZapDuration ;

    ckRLeakAnalog.checked := UseAnalogLeakSubtraction ;
    ckRLeakDigital.Checked := UseDigitalLeakSubtraction ;
    ckCompensateAllChannels.Checked := CompensateAllChannels ;
    edCompensationCoeff.Value := CompensationCoeff ;
    ckEnableDACStreaming.Checked := EnableDACStreaming ;
    edCurrentStimulusBias.Value := CurrentStimulusBias ;

    SealTestStartRequired := False ;

    end ;


procedure TTritonPanelFrm.UpdateTritonSettings ;
var
    ch,i : Integer ;
    Freq : Single ;
begin

     // Input source
     Main.SESLabIO.TritonGetSourceList( cbSource.Items ) ;

     // Input Gain
     Main.SESLabIO.TritonGetGainList(cbGain.Items) ;

     // Update settings in Triton
     for ch := 0 to Main.SESLabIO.TritonNumChannels-1 do begin

         // Source
         FSource[ch] :=  Min(Max(FSource[ch],0),cbSource.Items.Count-1) ;

         // Ensure that source is switched to corresponding Head/model input settings
         // when changing between current- and voltage- clamp modes of Pico

         if ContainsText(LastSourceName[ch],'model') then
            begin
            for i := 0 to cbSource.Items.Count-1 do
                if ContainsText(cbSource.Items[i],'model') then FSource[ch] := i ;
            end
         else if LowerCase(LastSourceName[ch]) = 'head' then
            begin
            for i := 0 to cbSource.Items.Count-1 do
                if LowerCase(cbSource.Items[i]) = 'head' then FSource[ch] := i ;
            end ;

         Main.SESLABIO.TritonSource[ch] := FSource[ch] ;
         if ch = cbChannel.ItemIndex then cbSource.ItemIndex := FSource[ch] ;
         LastSourceName[ch] := cbSource.Items[FSource[ch]] ;

         // Gain
         FGain[ch] :=  Min(Max(FGain[ch],0),cbGain.Items.Count-1) ;
         Main.SESLABIO.TritonGain[ch] := FGain[ch] ;
         if ch = cbChannel.ItemIndex then cbGain.ItemIndex := FGain[ch] ;

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CFAST,ch,FCFAST[ch]) ;

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

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_JP_FINE,ch,CHANOFFFine[ch]) ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_JP_FINE,ch,CHANOFFFineEnabled[ch]) ;

         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_LEAK,ch,LEAK[ch]) ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_LEAK,ch,LEAKEnabled[ch]) ;

         Main.SESLABIO.TritonDigitalLeakConductance[ ch ] := LEAKDigital[ch] ;

         end ;

     Main.SESLABIO.TritonCurrentStimulusBias := CurrentStimulusBias ;

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
    s : string ;
begin

    Main.SESLabIO.TritonGetRegProperties (Reg, VMin,Vmax,VStep,CanBeDisabled,Supported) ;
    TrackBar.Max := Round((VMax - VMin)/VStep) ;
    TrackBar.Min := 0 ;
    Panel.Visible := Supported ;

    case Reg of
         TECELLA_REG_CFAST : s := 'CFAST' ;
         TECELLA_REG_CSLOW_A : s := 'CSLOW_A';
         TECELLA_REG_CSLOW_B : s := 'CSLOW_B';
         TECELLA_REG_CSLOW_C : s := 'CSLOW_C';
         TECELLA_REG_CSLOW_D  : s := 'CSLOW_D';
         TECELLA_REG_JP  : s := 'JP';
         TECELLA_REG_JP_FINE  : s := 'JPfine';
         TECELLA_REG_LEAK  : s := 'Leak';
         TECELLA_REG_LEAK_FINE  : s := 'LeakFine';
         TECELLA_REG_RSERIES  : s := 'Rseries';
         else s := 'Unknown';
         end;

    s := s + format('Range %.4g - %.4g step %.4g',[VMin,Vmax,VStep]);
    if CanBeDisabled then s := s + ' Can be disabled';

    outputdebugstring(pchar(s));

    end ;


procedure TTritonPanelFrm.UpdatePanelControls ;
// ------------------------------------------
// Update panel controls for selected channel
// ------------------------------------------
var
    Value : Single ;
begin

     DisableTritonUpdates := True ;

     cbSource.ItemIndex := FSource[cbChannel.ItemIndex] ;
     cbGain.ItemIndex := FGain[cbChannel.ItemIndex] ;

     if ANSIContainsText( cbUserConfig.Text, 'ICLAMP' ) then gpCurrentStimulus.Visible := True
                                                        else gpCurrentStimulus.Visible := False ;
     ckICLAMPOn.Checked := Main.SESLabIO.TritonICLAMPOn ;

     TritonGetValue( TECELLA_REG_CFAST,cbChannel.ItemIndex,edCFast,tbCFast) ;
     TritonGetValueAndEnabled(TECELLA_REG_CSLOW_A,cbChannel.ItemIndex,edCSlowA,tbCSlowA,ckCSlowA) ;
     TritonGetValueAndEnabled(TECELLA_REG_CSLOW_B,cbChannel.ItemIndex,edCSlowB,tbCSlowB,ckCSlowB) ;
     TritonGetValueAndEnabled(TECELLA_REG_CSLOW_C,cbChannel.ItemIndex,edCSlowC,tbCSlowC,ckCSlowC) ;
     TritonGetValueAndEnabled(TECELLA_REG_CSLOW_D,cbChannel.ItemIndex,edCSlowD,tbCSlowD,ckCSlowD) ;
     TritonGetValueAndEnabled(TECELLA_REG_RSERIES,cbChannel.ItemIndex,edRSERIES,tbRSERIES,ckRSERIES) ;
     TritonGetValueAndEnabled(TECELLA_REG_LEAK,cbChannel.ItemIndex,edRLEAKAnalog,tbRLEAKAnalog,ckRLEAKAnalog) ;
     TritonGetValueAndEnabled(TECELLA_REG_LEAK_FINE,cbChannel.ItemIndex,edRLEAKFineAnalog,tbRLEAKFineAnalog,ckRLEAKFineAnalog) ;
     TritonGetValueAndEnabled(TECELLA_REG_JP,cbChannel.ItemIndex,edJunctionPot,tbJunctionPot,ckJunctionPot) ;
     TritonGetValueAndEnabled(TECELLA_REG_JP_FINE,cbChannel.ItemIndex,edJunctionPotFine,tbJunctionPotFine,ckJunctionPotFine) ;

     edRLeakDigital.Value := Main.SESLabIO.TritonDigitalLeakConductance[cbChannel.ItemIndex] ;

     tbFilter.Position := Round(BESSEL[cbChannel.ItemIndex]) ;
     Main.SESLabIO.SetTritonBesselFilter( cbChannel.ItemIndex, tbFilter.Position, Value ) ;
     edFilter.Text := format('%.4g kHz',[Value]) ;

     DisableTritonUpdates := False ;

     end ;


procedure TTritonPanelFrm.TritonGetValueAndEnabled(
          TritonRegister : Integer ;
          iChan : Integer ;
          var EditControl : TValidatedEdit ;
          var SliderControl : TTrackBar ;
          var EnableBox : TCheckBox  ) ;
// --------------------------------------------------
// Get current value of selected register from Triton
// --------------------------------------------------
var
    Value,PercentValue,Scale : Single ;
    Enabled : Boolean ;
    Units : String ;
begin

     Main.SESLABIO.TritonGetReg( TritonRegister, cbChannel.ItemIndex, Value,
                                 PercentValue, Units,Enabled ) ;
     SliderControl.Position :=  Round(PercentValue*0.01*SliderControl.Max) ;

     if Units = 'MOhm-1' then
        begin
        Units := 'nS'  ;
        Scale := 1000.0 ;
        end
     else Scale := 1.0 ;

     EditControl.Units := Units ;
     EditControl.Scale := Scale ;
     EnableBox.Checked := Enabled ;
     EditControl.Value := Value ;

     end ;


procedure TTritonPanelFrm.TritonGetValue(
          TritonRegister : Integer ;
          iChan : Integer ;
          var EditControl : TValidatedEdit ;
          var SliderControl : TTrackBar  ) ;
// --------------------------------------------------
// Get current value of selected register from Triton
// --------------------------------------------------
var
    Value,PercentValue,Scale : Single ;
    Enabled : Boolean ;
    Units : string ;
begin

     Main.SESLABIO.TritonGetReg( TritonRegister, cbChannel.ItemIndex, Value, PercentValue, Units,Enabled ) ;

     if Units = 'MOhm-1' then
        begin
        Units := 'nS'  ;
        Scale := 1000.0 ;
        end
     else Scale := 1.0 ;

     EditControl.Units := Units ;
     EditControl.Scale := Scale ;
     EditControl.Value := Value ;

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
          var EditControl : TValidatedEdit ;
          var SliderControl : TTrackBar ;
          Enabled : Boolean ) ;
// --------------------------------------------------
// Set current value of selected register from Triton
// --------------------------------------------------
var
    Value,PercentValue,Scale : Single ;
    RegEnabled : Boolean ;
    Units : String ;
begin

     // If register setting enabled, set to slider value, otherwise set to zero
     if Enabled then PercentValue := (SliderControl.Position/SliderControl.Max)*100.0
                else PercentValue :=  Main.SESLABIO.TritonRegValueToPercent(TritonRegister,cbChannel.ItemIndex,0.0) ;

     if not DisableTritonUpdates then
        begin
        Main.SESLABIO.TritonSetRegPercent( TritonRegister,cbChannel.ItemIndex,PercentValue ) ;
        end ;

     // Get actual value set back
     Main.SESLABIO.TritonGetReg( TritonRegister, cbChannel.ItemIndex, Value, PercentValue, Units,RegEnabled ) ;

     if Units = 'MOhm-1' then
        begin
        Units := 'nS'  ;
        Scale := 1000.0 ;
        end
     else Scale := 1.0 ;

     EditControl.Units := Units ;
     EditControl.Scale := Scale ;
     if Enabled then EditControl.Value := Value ;

     SealTestStartRequired := True ;

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
     FSource[cbChannel.ItemIndex] := cbSource.ItemIndex ;
     LastSourceName[cbChannel.ItemIndex] := cbSource.Items[FSource[cbChannel.ItemIndex]] ;
     SealTestStartRequired := True ;
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
//    TritonSetEnable( TECELLA_REG_CSLOW_A, ckCslowA ) ;
    CSLOW_AEnabled[cbChannel.ItemIndex] := ckCslowA.Checked ;
    CSlowAUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.ckCslowBClick(Sender: TObject);
begin
//    TritonSetEnable( TECELLA_REG_CSLOW_B, ckCslowB ) ;
    CSLOW_BEnabled[cbChannel.ItemIndex] := ckCslowB.Checked ;
    CSlowBUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.ckCslowCClick(Sender: TObject);
begin
//    TritonSetEnable( TECELLA_REG_CSLOW_C, ckCslowC ) ;
    CSLOW_CEnabled[cbChannel.ItemIndex] := ckCslowC.Checked ;
    CSlowCUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.ckCSlowClick(Sender: TObject);
// --------------------------------------------------
// Enable/disable CSlow compensation (all components)
// --------------------------------------------------
begin
    CSlowAUpdateRequired := True ;
    CSlowBUpdateRequired := True ;
    CSlowCUpdateRequired := True ;
    CSlowDUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.ckCslowDClick(Sender: TObject);
begin
//    TritonSetEnable( TECELLA_REG_CSLOW_D, ckCslowD ) ;
    CSLOW_DEnabled[cbChannel.ItemIndex] := ckCslowD.Checked ;
    CSlowDUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.ckRseriesClick(Sender: TObject);
begin
//    TritonSetEnable( TECELLA_REG_RSERIES, ckRSERIES ) ;
    RSERIESEnabled[cbChannel.ItemIndex] := ckRSERIES.Checked ;
    RSeriesUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.ckShowCSlowComponentsClick(Sender: TObject);
// ----------------------------------
// Show/Hide CSlow component controls
// ----------------------------------
begin
     pCSlowComponents.Visible := ckShowCSlowComponents.Checked ;
end;

procedure TTritonPanelFrm.ckShowRLeakComponentsClick(Sender: TObject);
// ----------------------------------
// Show/Hide Rleak component controls
// ----------------------------------
begin
     pRLeakComponents.Visible := ckShowRLeakComponents.Checked ;
end;


procedure TTritonPanelFrm.ckJunctionPotClick(Sender: TObject);
begin
//    TritonSetEnable( TECELLA_REG_JP, ckJunctionPot ) ;
    CHANOFFEnabled[cbChannel.ItemIndex] := ckJunctionPot.Checked ;
    JunctionPotUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.ckJunctionPotFineClick(Sender: TObject);
begin
//    TritonSetEnable( TECELLA_REG_JP_FINE, ckJunctionPotFine ) ;
    CHANOFFFineEnabled[cbChannel.ItemIndex] := ckJunctionPotFine.Checked ;
    JunctionPotFineUpdateRequired := True ;
    end;

procedure TTritonPanelFrm.ckRleakAnalogClick(Sender: TObject);
// ----------------------------------------
// Enable/disable coarse Rleak compensation
// ----------------------------------------
begin
    LEAKEnabled[cbChannel.ItemIndex] := ckRleak.Checked ;
    RLeakUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.bCFastAutoCompClick(Sender: TObject);
// -------------------------------------------
// Compensate fast component of cell capacity
// -------------------------------------------
var
    ch : Integer ;
    Enabled : Boolean ;
    Value : Single ;
    Units : String ;
    VHold,VStep,THold,TStep : single ;
begin

     // Stop A/D & D/A in other forms
     StopADCAndDAC ;

     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Cell capacity compensation in progress.' ;

     bCFastAutoComp.Enabled := False ;

     Screen.Cursor := crHourGlass ;

     // Get auto compensation holding and test pulse amplitudes and duration from current seal test WCPFile.Settings

//     TStep := Min(Max(WCPFile.Settings.SealTest.PulseWidth, 0.01 ), 0.1 ) ;
//     THold := TStep ;
     case WCPFile.Settings.SealTest.Use of
          3 : begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage3 ;
              end ;
          2 : begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage2 ;
              end ;
          else begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage1 ;
              end ;
          end;

     VStep := 0.01 ; // Step size (10 mV)
     TStep := 0.02 ;  // Test step time (20 ms)
     THold := 0.02 ; // Hold time (20 ms)

     CompensationCoeff := edCompensationCoeff.Value ;

     ckCfast.Checked := True ;
     Main.SESLabIO.TritonAutoCompensation( ckCfast.Checked,
                                           false,
                                           false,
                                           false,
                                           false,
                                           false,
                                           false,
                                           false,
                                           edCompensationCoeff.Value,
                                           VHold,
                                           THold,
                                           VStep,
                                           TStep
                                            ) ;

     // Update WCPFile.Settings
     for ch := 0 to Main.SESLabIO.TritonNumChannels-1 do
        begin
        Main.SESLABIO.TritonGetReg(TECELLA_REG_CFAST,ch,Value,FCFAST[ch],Units,Enabled) ;

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
        end ;

     UpdatePanelControls ;

     // Restart seal test
     SealTestStartRequired := True ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

    bCFastAutoComp.Enabled := True ;

     end;





procedure TTritonPanelFrm.bUpdateAllChannelsClick(Sender: TObject);
// --------------------------------------------------
// Make all channel WCPFile.Settings same as selected channel
// --------------------------------------------------
var
    ch : Integer ;
    Freq : Single ;
begin

     // Update WCPFile.Settings in Triton
     for ch := 0 to Main.SESLabIO.TritonNumChannels-1 do begin

         // Source
         FSource[ch] :=  Min(Max(FSource[cbChannel.ItemIndex],0),cbSource.Items.Count-1) ;
         Main.SESLABIO.TritonSource[ch] := FSource[ch] ;
         if ch = cbChannel.ItemIndex then cbSource.ItemIndex := FSource[ch] ;

         // Gain
         FGain[ch] :=  Min(Max(FGain[cbChannel.ItemIndex],0),cbGain.Items.Count-1) ;
         Main.SESLABIO.TritonGain[ch] := FGain[ch] ;
         if ch = cbChannel.ItemIndex then cbGain.ItemIndex := FGain[ch] ;

         FCFAST[ch] := FCFAST[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CFAST,ch,FCFAST[ch]) ;

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

         CHANOFFFine[ch] := CHANOFFFine[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_JP_FINE,ch,CHANOFFFine[ch]) ;
         CHANOFFEnabled[ch] := CHANOFFFineEnabled[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_JP_FINE,ch,CHANOFFFineEnabled[ch]) ;


         LEAK[ch] := LEAK[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_LEAK,ch,LEAK[ch]) ;
         LEAKEnabled[ch] := LEAKEnabled[cbChannel.ItemIndex] ;
         Main.SESLABIO.TritonSetRegEnabled(TECELLA_REG_LEAK,ch,LEAKEnabled[ch]) ;

         end ;

end;

procedure TTritonPanelFrm.bCleakLeakCompClick(Sender: TObject);
// -----------------------------------
// Clear leak conductance compensation
// -----------------------------------
var
    ch : Integer ;
begin

     // Clear digital compensations
     Main.SESLabIO.TritonDigitalLeakSubtractionEnable(cbChannel.ItemIndex,False) ;
     Main.SESLabIO.TritonDigitalLeakConductance[cbChannel.ItemIndex] := 0.0 ;

     for ch := 0 to Main.SESLabIO.TritonNumChannels-1 do
        if ckCompensateAllChannels.Checked or (ch = cbChannel.ItemIndex) then begin

        LEAK[ch] := Main.SESLABIO.TritonRegValueToPercent(TECELLA_REG_LEAK,ch,0.0) ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_LEAK,ch,LEAK[ch]) ;

        LEAKFine[ch] := Main.SESLABIO.TritonRegValueToPercent(TECELLA_REG_LEAK_FINE,ch,0.0) ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_LEAK_FINE,ch,LEAKFine[ch]) ;

        LEAKDigital[ch] := Main.SESLabIO.TritonDigitalLeakConductance[ch] ;

        end ;

     UpdatePanelControls ;

     end;


procedure TTritonPanelFrm.bClearCompensationClick(Sender: TObject);
// ---------------------------
// Clear capacity compensation
// ---------------------------
var
    ch : Integer ;
begin

     // Clear digital compensations
     Main.SESLabIO.TritonAutoArtefactRemovalEnable(False) ;

     for ch := 0 to Main.SESLabIO.TritonNumChannels-1 do
        if ckCompensateAllChannels.Checked or (ch = cbChannel.ItemIndex) then begin

        FCFAST[ch] := Main.SESLABIO.TritonRegValueToPercent(TECELLA_REG_CFAST,ch,0.0) ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CFAST,ch,FCFAST[ch]) ;

        CSLOW_A[ch] := Main.SESLABIO.TritonRegValueToPercent(TECELLA_REG_CSLOW_A,ch,0.0) ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_A,ch,CSLOW_A[ch]) ;

        CSLOW_B[ch] := Main.SESLABIO.TritonRegValueToPercent(TECELLA_REG_CSLOW_B,ch,0.0) ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_B,ch,CSLOW_B[ch]) ;

        CSLOW_C[ch] := Main.SESLABIO.TritonRegValueToPercent(TECELLA_REG_CSLOW_C,ch,0.0) ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_C,ch,CSLOW_C[ch]) ;

        CSLOW_D[ch] := Main.SESLABIO.TritonRegValueToPercent(TECELLA_REG_CSLOW_D,ch,0.0) ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CSLOW_D,ch,CSLOW_D[ch]) ;

        RSERIES[ch] := Main.SESLABIO.TritonRegValueToPercent(TECELLA_REG_RSERIES,ch,0.0) ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_RSERIES,ch,RSERIES[ch]) ;

        end ;

     UpdatePanelControls ;

     end;


procedure TTritonPanelFrm.bCSlowAutoCompClick(Sender: TObject);
// -------------------------------------------
// Compensate slow components of cell capacity
// -------------------------------------------
var
    ch : Integer ;
    Value : Single ;
    Units : String ;
    VHold,VStep,THold,TStep : single ;
begin

     //bClearCompensation.Click ;

     // Stop A/D & D/A in other forms
     StopADCAndDAC ;

     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Cell capacity compensation in progress.' ;

     bCSlowAutoComp.Enabled := False ;

     Screen.Cursor := crHourGlass ;

     // Apply compensation                                                                                         edVHold.Value := CompensationVHold ;
     CompensationCoeff := edCompensationCoeff.Value ;

     // Get auto compensation holding and test pulse amplitudes and duration from current seal test WCPFile.Settings

     TStep := Min(Max(WCPFile.Settings.SealTest.PulseWidth, 0.01 ), 0.1 ) ;
     THold := TStep ;
     case WCPFile.Settings.SealTest.Use of
          3 : begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage3 ;
              end ;
          2 : begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage2 ;
              end ;
          else begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage1 ;
              end ;
          end;

     VStep := 0.01 ; // Step size (10 mV)
     TStep := 0.02 ;  // Test step time (20 ms)
     THold := 0.02 ; // Hold time (20 ms)

     Main.SESLabIO.TritonAutoCompensation( false,
                                           ckCSlowA.Checked,
                                           ckCSlowB.Checked,
                                           ckCSlowC.Checked,
                                           ckCSlowD.Checked,
                                           False,
                                           False,
                                           false,
                                           edCompensationCoeff.Value,
                                           VHold,
                                           THold,
                                           VStep,
                                           TStep
                                            ) ;

     // Update WCPFile.Settings
     for ch := 0 to Main.SESLabIO.TritonNumChannels-1 do begin
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
        end ;

     UpdatePanelControls ;

     // Restart seal test
     SealTestStartRequired := True ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

     bCSlowAutoComp.Enabled := True ;

     end;


procedure TTritonPanelFrm.bAutoCompArterfactClick(Sender: TObject);
// -------------------------------------------------------------
// Compensate any artefact remaining after capacity compensation
// -------------------------------------------------------------
var
    VHold,VStep,THold,TStep : single ;
begin

     // Stop A/D & D/A in other forms
     StopADCAndDAC ;

     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Arefact compensation in progress.' ;

     bAutoCompArterfact.Enabled := False ;

     Screen.Cursor := crHourGlass ;

     // Get auto compensation holding and test pulse amplitudes and duration from current seal test WCPFile.Settings

     case WCPFile.Settings.SealTest.Use of
          3 : begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage3 ;
              end ;
          2 : begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage2 ;
              end ;
          else begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage1 ;
              end ;
          end;

     VStep := 0.01 ; // Step size (10 mV)
     TStep := 0.019 ;  // Test step time (20 ms)
     THold := 0.019 ; // Hold time (20 ms)

     Main.SESLabIO.TritonRemoveArtifact( Vhold,THold,VStep,TStep);

     UpdatePanelControls ;

     // Restart seal test
     SealTestStartRequired := True ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

     bAutoCompArterfact.Enabled := True ;

     end;


procedure TTritonPanelFrm.bAutoCompJunctionPotClick(Sender: TObject);
// --------------------------------------------------------------
// Apply automatic junction potential null
// --------------------------------------------------------------
var
    ch : Integer ;
    Value : Single ;
    Units : string ;
begin

     // Stop A/D & D/A in other forms
     StopADCAndDAC ;

     bAutoCompJunctionPot.Enabled := False ;

     Screen.Cursor := crHourGlass ;

     // Apply compensation
     Main.SESLabIO.TritonJPAutoZero ;

     // Update WCPFile.Settings
     for ch := 0 to Main.SESLabIO.TritonNumChannels-1 do begin
        Main.SESLABIO.TritonGetreg(TECELLA_REG_JP,ch,Value,CHANOFF[ch],Units,
                                       CHANOFFEnabled[ch]   ) ;
        Main.SESLABIO.TritonGetreg(TECELLA_REG_JP_FINE,ch,Value,CHANOFFFIne[ch],Units,
                                       CHANOFFFineEnabled[ch]   ) ;
        end ;

     UpdatePanelControls ;

     Screen.Cursor := crDefault ;

     // Restart seal test
     SealTestStartRequired := True ;
     bAutoCompJunctionPot.Enabled := True ;

     end;


procedure TTritonPanelFrm.bAutoLeakCompClick(Sender: TObject);
// ---------------------------
// Compensate leak conductance
// ---------------------------
var
    ch : Integer ;
    Value : Single ;
    Units : String ;
    VHold,VStep,THold,TStep : single ;
begin

     // Stop A/D & D/A in other forms
     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Leak conductance compensation in progress.' ;

     bAutoLeakComp.Enabled := False ;

     Screen.Cursor := crHourGlass ;

     // Get auto compensation holding and test pulse amplitudes and duration from current seal test WCPFile.Settings

     TStep := Min(Max(WCPFile.Settings.SealTest.PulseWidth, 0.01 ), 0.1 ) ;
     THold := TStep ;
     case WCPFile.Settings.SealTest.Use of
          3 : begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage3 ;
              end ;
          2 : begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage2 ;
              end ;
          else begin
              VHold :=  WCPFile.Settings.SealTest.HoldingVoltage1 ;
              end ;
          end;

     // Apply compensation
     CompensationCoeff := edCompensationCoeff.Value ;

     VStep := 0.01 ; // Step size (10 mV)
     TStep := 0.02 ;  // Test step time (20 ms)
     THold := 0.02 ; // Hold time (20 ms)

     Main.SESLabIO.TritonAutoCompensation( false,
                                           false,
                                           false,
                                           false,
                                           false,
                                           ckRLeakAnalog.Checked,
                                           ckRLeakDigital.Checked,
                                           false,
                                           edCompensationCoeff.Value,
                                           VHold,
                                           THold,
                                           VStep,
                                           TStep
                                            ) ;

     // Update WCPFile.Settings
     for ch := 0 to Main.SESLabIO.TritonNumChannels-1 do begin
        Main.SESLABIO.TritonGetreg(TECELLA_REG_LEAK,ch,Value,LEAK[ch],Units,
                                       LEAKEnabled[ch]) ;
        Main.SESLABIO.TritonGetreg(TECELLA_REG_LEAK,ch,Value,LEAKFine[ch],Units,
                                       LEAKEnabled[ch]) ;
        end ;

     if ckRLeakDigital.Checked then
        begin
        LEAKDigital[cbChannel.ItemIndex] := Main.SESLABIO.TritonDigitalLeakConductance[cbChannel.ItemIndex] ;
        Main.SESLabIO.TritonDigitalLeakSubtractionEnable(cbChannel.ItemIndex,True) ;
        end;

     UpdatePanelControls ;

     // Restart seal test
     SealTestStartRequired := True ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

    bAutoLeakComp.Enabled := True ;

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
        FGain[cbChannel.ItemIndex] := cbGain.ItemIndex ;
        GainUpdateRequired := False ;
        end ;

    if BesselFilterUpdateRequired then begin
       // BUG workaround! For some reason, a register must be set to the selected channel before
       // the call to SetTritonBesselFilter to ensure that the correct Triton channel bessel filter is updated
       Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_CFAST,cbChannel.ItemIndex,FCFAST[cbChannel.ItemIndex]) ;

       // Set bessel filter
       Bessel[cbChannel.ItemIndex] := tbFilter.Position ;
       Main.SESLabIO.SetTritonBesselFilter( cbChannel.ItemIndex,
                                            tbFilter.Position,
                                            Freq ) ;

       edFilter.Text := format('%.4g kHz',[Freq]) ;
       BesselFilterUpdateRequired := False ;

       end ;

    if CfastUpdateRequired then begin
       TritonSetPercent( TECELLA_REG_CFAST, edCFast, tbCFast, ckCFast.Checked ) ;
       FCFAST[cbChannel.ItemIndex] := (tbCFast.Position*100.0)/tbCFast.Max ;
       CfastUpdateRequired := False ;
       end ;

    if CSlowAUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_CSLOW_A, edCSlowA, tbCSlowA, ckCSlowA.Checked and ckCSlow.Checked) ;
     CSLOW_A[cbChannel.ItemIndex] := (tbCSLOWA.Position*100.0)/tbCSLOWA.Max ;
     CSlowAUpdateRequired := False ;
     end ;

    if CSlowBUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_CSLOW_B, edCSlowB, tbCSlowB, ckCSlowB.Checked and ckCSlow.Checked ) ;
     CSLOW_B[cbChannel.ItemIndex] := (tbCSLOWB.Position*100.0)/tbCSLOWB.Max ;
     CSlowBUpdateRequired := False ;
     end ;

    if CSlowCUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_CSLOW_C, edCSlowC, tbCSlowC, ckCSlowC.Checked and ckCSlow.Checked ) ;
     CSLOW_C[cbChannel.ItemIndex] := (tbCSLOWC.Position*100.0)/tbCSLOWC.Max ;
     CSlowCUpdateRequired := False ;
     end ;

    if CSlowDUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_CSLOW_D, edCSlowD, tbCSlowD, ckCSlowD.Checked and ckCSlow.Checked ) ;
     CSLOW_D[cbChannel.ItemIndex] := (tbCSLOWD.Position*100.0)/tbCSLOWD.Max ;
     CSlowDUpdateRequired := False ;
     end ;

    if RseriesUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_RSERIES, edRseries, tbRseries, ckRSeries.Checked ) ;
     RSERIES[cbChannel.ItemIndex] := (tbRSeries.Position*100.0)/tbRSeries.Max ;
     RseriesUpdateRequired := False ;
     end ;

    if JunctionPotUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_JP, edJunctionPot, tbJunctionPot, ckJunctionPot.Checked ) ;
     CHANOFF[cbChannel.ItemIndex] := (tbJunctionPot.Position*100.0)/tbJunctionPot.Max ;
     JunctionPotUpdateRequired := False ;
     end ;

    if JunctionPotFineUpdateRequired then begin
     TritonSetPercent( TECELLA_REG_JP_FINE, edJunctionPotFine, tbJunctionPotFine, ckJunctionPotFine.Checked ) ;
     CHANOFFFine[cbChannel.ItemIndex] := (tbJunctionPotFine.Position*100.0)/tbJunctionPotFine.Max ;
     JunctionPotFineUpdateRequired := False ;
     end ;

    if RleakUpdateRequired then begin
       TritonSetPercent( TECELLA_REG_LEAK, edRleakAnalog, tbRleakAnalog, ckRLeakAnalog.Checked and ckRLeak.Checked ) ;
       LEAK[cbChannel.ItemIndex] := (tbRLeakAnalog.Position*100.0)/tbRLeakAnalog.Max ;
       RleakUpdateRequired := False ;
       end ;

    if RleakFineUpdateRequired then begin
       TritonSetPercent( TECELLA_REG_LEAK_FINE, edRleakFineAnalog, tbRleakFineAnalog, ckRLeakFineAnalog.Checked and ckRLeak.Checked ) ;
       LEAKFine[cbChannel.ItemIndex] := (tbRLeakFineAnalog.Position*100.0)/tbRLeakFineAnalog.Max ;
       RleakFineUpdateRequired := False ;
       end ;

    if RLeakDigitalUpdateRequired then begin
       LEAKDigital[cbChannel.ItemIndex] := edRLeakDigital.Value ;
       Main.SESLABIO.TritonDigitalLeakSubtractionEnable(cbChannel.ItemIndex, ckRLeakDigital.Checked and ckRLeak.Checked);
       RLeakDigitalUpdateRequired := False ;
       SealTestStartRequired := True ;
       end ;

    if CurrentStimulusBiasUpdateRequired then begin
       CurrentStimulusBias :=  edCurrentStimulusBias.Value ;
       Main.SESLabIO.TritonCurrentStimulusBias := CurrentStimulusBias ;
       SealTestStartRequired := True ;
       end;

    if SealTestStartRequired then
       begin
       if Main.FormExists( 'SealTestFrm') then SealTestFrm.StartADCandDAC ;
       SealTestStartRequired := False ;
       end;

    // Update totaL capacity fields
    edCSlowTotal.Value := edCSlowA.Value + edCSlowB.Value + edCSlowC.Value + edCSlowD.Value ;
    if panCSlowD.Visible then panCTotal.Top := panCSlowD.Top + panCSlowD.Height + 2
    else if panCSlowC.Visible then panCTotal.Top := panCSlowC.Top + panCSlowC.Height + 2
    else if panCSlowB.Visible then panCTotal.Top := panCSlowB.Top + panCSlowB.Height + 2 ;

    // Update total Rleak (analog + digital

    edRLeakTotal.Value := edRLeakAnalog.Value + edRLeakFineAnalog.Value + edRLeakDigital.Value ;

//    else panCTotal.Top := panCFast.Top + panCFast.Height + 2 ;
//    panCSlowTotal.Top := panCTotal.Top + panCTotal.Height + 2 ;

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
     StopADCandDAC ;

     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Calibrating patch clamp amplifier' ;
     Main.SESLabIO.TritonUserConfig := cbUserConfig.ItemIndex ;
     UpdateTritonSettings ;
     Main.StatusBar.SimpleText := '' ;
     Screen.Cursor := crDefault ;

     SealTestStartRequired := True ;

     end;

procedure TTritonPanelFrm.bClearJPCompClick(Sender: TObject);
// -------------------------------------
// Clear junction potential compensation
// -------------------------------------
var
    ch : Integer ;
begin

     // Clear digital compensations
     Main.SESLabIO.TritonDigitalLeakSubtractionEnable(cbChannel.ItemIndex,False) ;
     Main.SESLabIO.TritonAutoArtefactRemovalEnable(False) ;

     for ch := 0 to Main.SESLabIO.TritonNumChannels-1 do
        if ckCompensateAllChannels.Checked or (ch = cbChannel.ItemIndex) then begin

        CHANOFF[ch] := Main.SESLABIO.TritonRegValueToPercent(TECELLA_REG_JP,ch,0.0) ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_JP,ch,CHANOFF[ch]) ;

        CHANOFFFine[ch] := Main.SESLABIO.TritonRegValueToPercent(TECELLA_REG_JP_FINE,ch,0.0) ;
        Main.SESLABIO.TritonSetRegPercent(TECELLA_REG_JP_FINE,ch,CHANOFFFine[ch]) ;

        end ;

     UpdatePanelControls ;

     end;


procedure TTritonPanelFrm.sbRLeakFineChange(Sender: TObject);
// ----------------------
// RLeak (fine) setting changed
// ----------------------
begin
    RleakFineUpdateRequired := True ;
    end;

procedure TTritonPanelFrm.ckRLeakClick(Sender: TObject);
// --------------------------------------------------
// Enable/disable RLeak compensation (all components)
// --------------------------------------------------
begin
    RLeakUpdateRequired := True ;
    RLeakFineUpdateRequired := True ;
    RLeakDigitalUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.ckRLeakDigitalClick(Sender: TObject);
// ------------------------------------------
// Enable/disable digital R leak compensation
// ------------------------------------------
begin
    LEAKDigitalEnabled[cbChannel.ItemIndex] := ckRleakDigital.Checked ;
    RLeakDigitalUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.ckRLeakFineAnalogClick(Sender: TObject);
begin
//    TritonSetEnable( TECELLA_REG_LEAK_FINE, ckRleakFine ) ;
    LEAKFineEnabled[cbChannel.ItemIndex] := ckRleakFineAnalog.Checked ;
    RleakFineUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.bZapClick(Sender: TObject);
// -----------
// Zap channel
// -----------
var
    ChanNum : Integer ;
begin

     // Stop A/D & D/A in other forms
     StopADCAndDAC ;

     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Cell zap in progress.' ;

     if ckZapAllChannels.Checked then ChanNum := -1
                                 else ChanNum := cbChannel.ItemIndex ;
     Main.SESLabIO.TritonZap( edZapDuration.Value,
                         edZapAmplitude.Value,
                         ChanNum ) ;

     // Stop seal test
     SealTestStartRequired := True ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

     end;

procedure TTritonPanelFrm.tbFilterChange(Sender: TObject);
// ----------------------------------------------
// Update Bessel filter cut-off frequency setting
// ----------------------------------------------

begin
    BesselFilterUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;

procedure TTritonPanelFrm.tbCFastChange(Sender: TObject);
begin
    CfastUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;


procedure TTritonPanelFrm.tbCSlowAChange(Sender: TObject);
begin
    CSlowAUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;


procedure TTritonPanelFrm.tbCSlowBChange(Sender: TObject);
begin
    CSlowBUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;


procedure TTritonPanelFrm.tbCSlowCChange(Sender: TObject);
begin
    CSlowCUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;


procedure TTritonPanelFrm.tbCSlowDChange(Sender: TObject);
begin
    CSlowDUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;


procedure TTritonPanelFrm.tbRSeriesChange(Sender: TObject);
begin
    RSeriesUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;


procedure TTritonPanelFrm.tbRLeakAnalogChange(Sender: TObject);
begin
    RLeakUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;


procedure TTritonPanelFrm.tbRLeakFineAnalogChange(Sender: TObject);
begin
    RLeakFineUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;


procedure TTritonPanelFrm.tbJunctionPotChange(Sender: TObject);
begin
    JunctionPotUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;


procedure TTritonPanelFrm.tbJunctionPotFineChange(Sender: TObject);
begin
    JunctionPotFineUpdateRequired := True ;
    SealTestStartRequired := True ;
    end;


procedure TTritonPanelFrm.bCalibrateClick(Sender: TObject);
// ---------------------
// Calibrate patch clamp
// ---------------------
begin

     bCalibrate.Enabled := False ;

     // Stop A/D & D/A in other forms
     StopADCandDAC ;

     Screen.Cursor := crHourglass ;
     Main.StatusBar.SimpleText := 'WAIT: Calibrating patch clamp amplifier' ;
     Main.SESLabIO.TritonCalibrate ;
     Main.SESLabIO.TritonUserConfig := cbUserConfig.ItemIndex ;
     UpdateTritonSettings ;
     Main.StatusBar.SimpleText := '' ;
     Screen.Cursor := crDefault ;

     SealTestStartRequired := True ;
     bCalibrate.Enabled := True ;

     end;


procedure TTritonPanelFrm.StopADCandDAC ;
// -----------------------------------------------
// Stop A/D sampling and D/A update in other forms
// -----------------------------------------------
begin
     if Main.FormExists( 'SealTestFrm') then SealTestFrm.StopADCandDAC ;
     if Main.FormExists( 'RecordFrm') then RecordFrm.StopADCandDAC ;
end;


procedure TTritonPanelFrm.ckUseDigitalArtefactSubtractionClick(
  Sender: TObject);
begin
  //   Main.SESLabIO.TritonAutoArtefactRemovalEnable(ckUseDigitalArtefactSubtraction.Checked) ;
  //   UseDigitalArtefactRemoval := ckUseDigitalArtefactSubtraction.Checked ;
     SealTestStartRequired := True ;
     end;



procedure TTritonPanelFrm.SaveToXMLFile(
           FileName : String
           ) ;
// -------------------------------------------
// Save tecella amplifier WCPFile.Settings to XML file
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
// Save tecella amplifier WCPFile.Settings to XML file (internal)
// -------------------------------------------
var
   iNode,ProtNode : IXMLNode;
   i : Integer ;
   s : TStringList ;
   XMLDoc : IXMLDocument ;
begin

//    ckUseAnalogLeakCompensation.checked := UseAnalogLeakSubtraction ;
//    ckUseDigitalLeakCompensation.Checked := UseDigitalLeakSubtraction ;
//    ckUseDigitalArtefactSubtraction.Checked := UseDigitalArtefactRemoval ;
{    ckCfast.Checked := UseCfastCompensation ;
    ckCSlowA.Checked := UseCSlowACompensation ;
    ckCSlowB.Checked := UseCSlowBCompensation ;
    ckCSlowC.Checked := UseCSlowCCompensation ;
    ckCSlowD.Checked := UseCSlowDCompensation ;
    ckCompensateAllChannels.Checked := CompensateAllChannels ;
    edCompensationCoeff.Value := CompensationCoeff ;
    ckEnableDACStreaming.Checked := EnableDACStreaming ;
    edCurrentStimulusBias.Value := CurrentStimulusBias ;}

    XMLDoc := TXMLDocument.Create(Self);
    XMLDoc.Active := True ;

    // Clear document
    XMLDoc.ChildNodes.Clear ;

    // Add record name
    ProtNode := XMLDoc.AddChild( 'TECELLAWCPFile.Settings' ) ;

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
    AddElementFloat( ProtNode, 'CURRENTSTIMULUSBIAS',CurrentStimulusBias) ;

    // Input channels
    for i := 0 to MaxTecellaChannels-1 do begin
         iNode := ProtNode.AddChild( 'CHANNEL' ) ;
         AddElementInt( iNode, 'NUMBER', i ) ;
         AddElementInt( iNode, 'SOURCE', FSource[i]);
         AddElementInt( iNode, 'GAIN', FGain[i]);
         AddElementFloat( iNode, 'INPUTRANGE', InputRange[i]) ;
         AddElementFloat( iNode, 'CFAST', FCFAST[i]);
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
         AddElementBool( iNode, 'CHANOFFFINEENABLED', CHANOFFFineEnabled[i]);
         AddElementFloat( iNode, 'CHANOFFFINE', CHANOFFFine[i]);
         AddElementBool( iNode, 'LEAKENABLED', LEAKEnabled[i]);
         AddElementBool( iNode, 'LEAKFINEENABLED', LEAKFineEnabled[i]);
         AddElementBool( iNode, 'LEAKDIGITALENABLED', LEAKDigitalEnabled[i]);
         AddElementFloat( iNode, 'LEAK', LEAK[i]);
         AddElementFloat( iNode, 'LEAKFINE', LEAKFine[i]);
         AddElementFloat( iNode, 'LEAKDIGITAL', LEAKDigital[i]);
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
// Load WCPFile.Settings from XML file
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
// Load WCPFile.Settings from XML file  (internal)
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
    GetElementFloat( ProtNode, 'CURRENTSTIMULUSBIAS',CurrentStimulusBias) ;

    // Amplifiers
    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'CHANNEL',iNode,NodeIndex) do begin
        GetElementInt( iNode, 'NUMBER', i ) ;
        if (i >= 0) and (i < MaxTecellaChannels) then begin
           GetElementInt( iNode, 'NUMBER', i ) ;
           GetElementInt( iNode, 'SOURCE', FSource[i]);
           GetElementInt( iNode, 'GAIN', FGain[i]);
           GetElementFloat( iNode, 'INPUTRANGE', InputRange[i]) ;
           GetElementFloat( iNode, 'CFAST', FCFAST[i]);
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
           GetElementBool( iNode, 'CHANOFFFINEENABLED', CHANOFFFineEnabled[i]);
           GetElementFloat( iNode, 'CHANOFFFINE', CHANOFFFine[i]);
           GetElementBool( iNode, 'LEAKENABLED', LEAKEnabled[i]);
           GetElementBool( iNode, 'LEAKFINEENABLED', LEAKFineEnabled[i]);
           GetElementBool( iNode, 'LEAKDIGITALENABLED', LEAKDigitalEnabled[i]);
           GetElementFloat( iNode, 'LEAK', LEAK[i]);
           GetElementFloat( iNode, 'LEAKFINE', LEAKFine[i]);
           GetElementFloat( iNode, 'LEAKDIGITAL', LEAKDigital[i]);
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
       {$IF CompilerVersion > 7.0} dsep := formatSettings.DECIMALSEPARATOR ;
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

     // Default Tecella amplifier WCPFile.Settings

     for i := 0 to Main.SESLabIO.TritonNumChannels-1 do begin
         FSource[i] := 0 ;
         LastSourceName[i] := '' ;
         FGain[i] := 0 ;
         InputRange[i] := 1E-7 ;
         FCFAST[i] := 0 ;
         CSLOW_A[i] := 0 ;
         CSLOW_B[i] := 0 ;
         CSLOW_C[i] := 0 ;
         CSLOW_D[i] := 0 ;
         RSERIES[i] := 0 ;
         CHANOFF[i] := 0 ;
         CHANOFFFine[i] := 0 ;
         LEAK[i] := 0 ;
         BESSEL[i] := 0 ;
         CSLOW_AEnabled[i] := False ;
         CSLOW_BEnabled[i] := False ;
         CSLOW_CEnabled[i] := False ;
         CSLOW_DEnabled[i] := False ;
         RSERIESEnabled[i] := False ;
         CHANOFFEnabled[i] := False ;
         CHANOFFFineEnabled[i] := False ;
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

     // Load WCPFile.Settings from XML file
     SettingsFileName := WCPFile.SettingsDirectory + 'tecella WCPFile.Settings.xml' ;
     if FileExists( SettingsFileName ) then LoadFromXMLFile( SettingsFileName ) ;

     end;

procedure TTritonPanelFrm.FormDestroy(Sender: TObject);
// ------------------------------------
// Save WCPFile.Settings when form is destroyed
// ------------------------------------
begin

    SaveToXMLFile(SettingsFileName) ;

    end;


procedure TTritonPanelFrm.ckCFastClick(Sender: TObject);
begin
//    TritonSetEnable( TECELLA_REG_CSLOW_A, ckCslowA ) ;
    CFastEnabled[cbChannel.ItemIndex] := ckCFast.Checked ;
    CFastUpdateRequired := True ;
    end;


procedure TTritonPanelFrm.ckCompensateAllChannelsClick(Sender: TObject);
begin
     CompensateAllChannels := ckCompensateAllChannels.Checked ;
     end;

procedure TTritonPanelFrm.edCFastKeyPress(Sender: TObject; var Key: Char);
// ---------------------
// C fast value changed
// ---------------------
begin
    if Key = #13 then
       begin
       tbCFast.Position := ConvertToTrackBarPosition( Tecella_Reg_CFAST, edCFast.Value, tbCFast );
       CFastUpdateRequired := True ;
       end;
    end;


procedure TTritonPanelFrm.edCompensationCoeffKeyPress(Sender: TObject;
  var Key: Char);
begin
     if Key = #13 then CompensationCoeff := edCompensationCoeff.Value ;
     end;


procedure TTritonPanelFrm.edCSlowAKeyPress(Sender: TObject; var Key: Char);
// ---------------------
// C slow A value changed
// ---------------------
begin
    if Key = #13 then
       begin
       tbCSlowA.Position := ConvertToTrackBarPosition( Tecella_Reg_CSLOW_A, edCSlowA.Value, tbCSlowA );
       CSlowAUpdateRequired := True ;
       end;
    end;


procedure TTritonPanelFrm.edCSlowBKeyPress(Sender: TObject; var Key: Char);
// ---------------------
// C slow B value changed
// ---------------------
begin
    if Key = #13 then
       begin
       tbCSlowB.Position := ConvertToTrackBarPosition( Tecella_Reg_CSLOW_B, edCSlowB.Value, tbCSlowB );
       CSlowBUpdateRequired := True ;
       end;
    end;


procedure TTritonPanelFrm.edCSlowCKeyPress(Sender: TObject; var Key: Char);
// ---------------------
// C slow C value changed
// ---------------------
begin
    if Key = #13 then
       begin
       tbCSlowC.Position := ConvertToTrackBarPosition( Tecella_Reg_CSLOW_C, edCSlowC.Value, tbCSlowC );
       CSlowCUpdateRequired := True ;
       end;
    end;


procedure TTritonPanelFrm.edCSlowDKeyPress(Sender: TObject; var Key: Char);
// ---------------------
// C slow D value changed
// ---------------------
begin
    if Key = #13 then
       begin
       tbCSlowD.Position := ConvertToTrackBarPosition( Tecella_Reg_CSLOW_D, edCSlowD.Value, tbCSlowD );
       CSlowDUpdateRequired := True ;
       end;
    end;


procedure TTritonPanelFrm.edCurrentStimulusBiasKeyPress(Sender: TObject;
  var Key: Char);
// ------------------------------
// Current stimulus  bias changed
// ------------------------------
begin
    if Key = #13 then begin
       CurrentStimulusBias := edCurrentStimulusBias.Value ;
       CurrentStimulusBiasUpdateRequired := True ;
       end ;
    end;


procedure TTritonPanelFrm.edJunctionPotFineKeyPress(Sender: TObject;
  var Key: Char);
// -----------------------------------------
// Junction potential (fine) value changed
// -----------------------------------------
begin
    if Key = #13 then
       begin
       tbJunctionPotFine.Position := ConvertToTrackBarPosition( Tecella_Reg_JP_FINE, edJunctionPotFine.Value, tbJunctionPotFine );
       JunctionPotFineUpdateRequired := True ;
       end;
    end;


procedure TTritonPanelFrm.edJunctionPotKeyPress(Sender: TObject; var Key: Char);
// -----------------------------------------
// Junction potential (coarse) value changed
// -----------------------------------------
begin
    if Key = #13 then
       begin
       tbJunctionPot.Position := ConvertToTrackBarPosition( Tecella_Reg_JP, edJunctionPot.Value, tbJunctionPot );
       JunctionPotUpdateRequired := True ;
       end;
    end;


procedure TTritonPanelFrm.edRLeakFineAnalogKeyPress(Sender: TObject; var Key: Char);
// -----------------------------------
// Leak reistance (fine) value changed
// -----------------------------------
begin
    if Key = #13 then
       begin
       tbRLeakFineAnalog.Position := ConvertToTrackBarPosition( TECELLA_REG_LEAK_FINE, edRLeakFineAnalog.Value, tbRLeakFineAnalog );
       RLeakFineUpdateRequired := True ;
       end;
    end;


procedure TTritonPanelFrm.edRLeakAnalogKeyPress(Sender: TObject; var Key: Char);
// -------------------------------------
// Leak reistance (coarse) value changed
// -------------------------------------
begin
    if Key = #13 then
       begin
       tbRLeakAnalog.Position := ConvertToTrackBarPosition( TECELLA_REG_LEAK, edRLeakAnalog.Value, tbRLeakAnalog );
       RLeakUpdateRequired := True ;
       end;
    end;


procedure TTritonPanelFrm.edRSeriesKeyPress(Sender: TObject; var Key: Char);
// ------------------------------
// Series reistance value changed
// ------------------------------
begin
    if Key = #13 then
       begin
       tbRSeries.Position := ConvertToTrackBarPosition( TECELLA_REG_RSERIES, edRSeries.Value, tbRSeries );
       RSeriesUpdateRequired := True ;
       end;
    end;


function TTritonPanelFrm.ConvertToTrackBarPosition(
          Reg : Integer ;                  // Register to read
          Value : Single ;                 // Register value
          TrackBar : TTrackbar             // Track bar to set
          ) : Integer ;                    // Return trackbar position
// ---------------------------------------------
// Convert register value to percentage of range
// ---------------------------------------------
Var
    VMin,VMax,VStep : Single ;
    CanBeDisabled,Supported : Boolean ;
begin
     Main.SESLabIO.TritonGetRegProperties( Reg,VMin,VMax,VStep,CanBeDisabled,Supported);
     Result := Round( ((Value - VMin) / (VMax - VMin)) * (TrackBar.Max - TrackBar.Min)) + TrackBar.Min ;
     end ;


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
     SealTestStartRequired := True ;



     end ;

procedure TTritonPanelFrm.AutoCompCFast ;
// ------------------------------------------
// Auto compensate fast component of capacity
// ------------------------------------------
begin
    bCFastAutoComp.Click ;
    end;

procedure TTritonPanelFrm.AutoCompCSlow ;
// ------------------------------------------
// Auto compensate slow component of capacity
// ------------------------------------------
begin
    bCSlowAutoComp.Click ;
    end;


procedure TTritonPanelFrm.AutoCompArtefact ;
// --------------------------------------------------------------
// Auto compensate remaining artefact after capacity compensation
// --------------------------------------------------------------
begin

    end;


procedure TTritonPanelFrm.AutoCompJunctionPot ;
// -----------------------------------
// Auto compensate junction potential
// -----------------------------------
begin
    bAutoCompJunctionPot.Click ;
    end;


procedure TTritonPanelFrm.ClearCompC ;
// -----------------------------------
// Clear Cfast and Cslow compensation
// -----------------------------------
begin
    bClearCompensation.Click ;
    end;

procedure TTritonPanelFrm.ClearCompJP ;
// -----------------------------------
// Clear junction pot. compensation
// -----------------------------------
begin
    bClearJPComp.Click ;
    end;


function TTritonPanelFrm.GetGain : Integer ;
// --------------------------------
// Get Triton amplifier gain index
// --------------------------------
begin
     Result := TritonPanelFrm.cbGain.ItemIndex ;
     end;


procedure TTritonPanelFrm.SetGain( Value : Integer ) ;
// ---------------------------------
// Set Triton amplifier gain index
// ---------------------------------
begin
    TritonPanelFrm.cbGain.ItemIndex := Min(Max(Value,0),TritonPanelFrm.cbGain.Items.Count-1) ;
    end;


function TTritonPanelFrm.GetSource : Integer ;
// ---------------------------------
// Get Triton amplifier source index
// ---------------------------------
begin
     Result := TritonPanelFrm.cbSource.ItemIndex ;
end;


procedure TTritonPanelFrm.SetSource( Value : Integer ) ;
// ---------------------------------
// Set Triton amplifier source index
// ---------------------------------
begin
    TritonPanelFrm.cbSource.ItemIndex :=
       Min(Max(Value,0),TritonPanelFrm.cbSource.Items.Count-1) ;
    end;


function TTritonPanelFrm.GetFilter : Integer ;
// ----------------------------------
// Get Triton amplifier filter index
// ----------------------------------
begin
     Result := TritonPanelFrm.tbFilter.Position ;
end;


procedure TTritonPanelFrm.SetFilter( Value : Integer ) ;
// ----------------------------------
// Get Triton amplifier filter index
// ----------------------------------
begin
     TritonPanelFrm.tbFilter.Position :=
        Min(Max(Value,TritonPanelFrm.tbFilter.Min),TritonPanelFrm.tbFilter.Max) ;
end;


function TTritonPanelFrm.GetUserConfig : Integer ;
// --------------------------------------
// Get Triton amplifier user config index
// --------------------------------------
begin
     Result := cbUserConfig.ItemIndex ;
end;


procedure TTritonPanelFrm.SetUserConfig( Value : Integer ) ;
// --------------------------------------
// Set Triton amplifier user config index
// --------------------------------------
begin
    cbUserConfig.ItemIndex := Min(Max(Value,0),cbUserConfig.Items.Count-1) ;
end;


function TTritonPanelFrm.GetEnableCFast : Boolean ;
// ------------------------------------------
// Get Triton amplifier CFast enabled setting
// ------------------------------------------
begin
     Result := ckCFast.Checked ;
end;


procedure TTritonPanelFrm.SetEnableCFast( Value : Boolean ) ;
// ------------------------------------------
// Set Triton amplifier CFast enabled setting
// ------------------------------------------
begin
     ckCFast.Checked := Value ;
end;


function TTritonPanelFrm.GetEnableCSlow : Boolean ;
// ------------------------------------------
// Get Triton amplifier CSlow enabled setting
// ------------------------------------------
begin
     Result := ckCSlow.Checked ;
end;


procedure TTritonPanelFrm.SetEnableCSlow( Value : Boolean ) ;
// ------------------------------------------
// Set Triton amplifier CFast enabled setting
// ------------------------------------------
begin
     ckCSlow.Checked := Value ;
end;


function TTritonPanelFrm.GetEnableJP : Boolean ;
// ------------------------------------------
// Get Triton amplifier junction pot. comp. enabled setting
// ------------------------------------------
begin
     Result := ckJunctionPot.Checked ;
end;


procedure TTritonPanelFrm.SetEnableJP( Value : Boolean ) ;
// --------------------------------------------------------
// Set Triton amplifier junction pot. comp. enabled setting
// --------------------------------------------------------
begin
     ckJunctionPot.Checked := Value ;
     ckJunctionPotFine.Checked := ckJunctionPot.Checked ;
     end;


function TTritonPanelFrm.GetCSlow : Single ;
// -----------------------------------------------
// Get Triton amplifier CSlow compensation setting
// -----------------------------------------------
begin
    Result := edCSlowTotal.Value ;
end;


function TTritonPanelFrm.GetCFast : Single ;
// -----------------------------------------------
// Get Triton amplifier CFast compensation setting
// -----------------------------------------------
begin
    Result := edCFast.Value ;
end;


function TTritonPanelFrm.GetJP : Single ;
// ------------------------------------------------------------
// Get Triton amplifier junction potential compensation setting
// ------------------------------------------------------------
begin
    Result := edJunctionPot.Value + edJunctionPotFine.Value ;
end;

end.
