unit EPC9PanelUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, ValidatedEdit, math, xmldoc, xmlintf, strutils, ActiveX ;

const
    MaxEPC9Channels = 3 ;

type
  TEPC9PanelFrm = class(TForm)
    ControlsGrp: TGroupBox;
    GroupBox3: TGroupBox;
    cbChannel: TComboBox;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    cbGain: TComboBox;
    GroupBox5: TGroupBox;
    Label11: TLabel;
    cbFilter1: TComboBox;
    Label2: TLabel;
    cbFilter2: TComboBox;
    edFilter2Bandwidth: TValidatedEdit;
    edFilter1Bandwidth: TValidatedEdit;
    Zapgrp: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    edZapAmplitude: TValidatedEdit;
    edZapDuration: TValidatedEdit;
    bZap: TButton;
    edModel: TEdit;
    PageControl1: TPageControl;
    CfastTab: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    edCfast: TValidatedEdit;
    edCfastTau: TValidatedEdit;
    bAutoCfast: TButton;
    CslowTab: TTabSheet;
    Label7: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    cbCslowRange: TComboBox;
    edCSlow: TValidatedEdit;
    edGSeries: TValidatedEdit;
    bAutoCSlow: TButton;
    RSCompTab: TTabSheet;
    Label8: TLabel;
    Label9: TLabel;
    cbRSSpeed: TComboBox;
    edRSCompensation: TValidatedEdit;
    bAutoRSCompensation: TButton;
    LeakTab: TTabSheet;
    Label12: TLabel;
    edGLeak: TValidatedEdit;
    bAutoLeakSubtract: TButton;
    cCfastClear: TButton;
    bClearCslow: TButton;
    Button2: TButton;
    VpipTab: TTabSheet;
    Label1: TLabel;
    edVPOffset: TValidatedEdit;
    Label16: TLabel;
    edVLiquidJunction: TValidatedEdit;
    bAutoVPipette: TButton;
    bClearVPOffset: TButton;
    edVHold: TValidatedEdit;
    Label17: TLabel;
    ModeGrp: TGroupBox;
    Label13: TLabel;
    Label18: TLabel;
    cbMode: TComboBox;
    cbCCGain: TComboBox;
    cbCCTrackTau: TComboBox;
    CheckBox1: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbGainChange(Sender: TObject);
    procedure cbFilter2Change(Sender: TObject);
    procedure cbFilter1Change(Sender: TObject);
    procedure edFilter2BandwidthKeyPress(Sender: TObject; var Key: Char);
    procedure edFilter1BandwidthKeyPress(Sender: TObject; var Key: Char);
    procedure edCfastKeyPress(Sender: TObject; var Key: Char);
    procedure edCfastTauKeyPress(Sender: TObject; var Key: Char);
    procedure edCSlowKeyPress(Sender: TObject; var Key: Char);
    procedure edGSeriesKeyPress(Sender: TObject; var Key: Char);
    procedure edRSCompensationKeyPress(Sender: TObject; var Key: Char);
    procedure cbCslowRangeChange(Sender: TObject);
    procedure cbRSSpeedChange(Sender: TObject);
    procedure edGLeakKeyPress(Sender: TObject; var Key: Char);
    procedure cbModeChange(Sender: TObject);
    procedure bAutoCfastClick(Sender: TObject);
    procedure bAutoCSlowClick(Sender: TObject);
    procedure bAutoLeakSubtractClick(Sender: TObject);
    procedure edVPOffsetKeyPress(Sender: TObject; var Key: Char);
    procedure edVLiquidJunctionKeyPress(Sender: TObject; var Key: Char);
    procedure bAutoVPipetteClick(Sender: TObject);
    procedure bClearVPOffsetClick(Sender: TObject);
    procedure bClearCslowClick(Sender: TObject);
    procedure edVHoldKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure cCfastClearClick(Sender: TObject);
    procedure bAutoRSCompensationClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    SettingsFileName : String ;
    Gain : Array[0..MaxEPC9Channels] of Integer ;
    Mode : Array[0..MaxEPC9Channels] of Integer ;
    CFAST : Array[0..MaxEPC9Channels] of Single ;
    CFASTTAU : Array[0..MaxEPC9Channels] of Single ;
    CSLOWRANGE : Array[0..MaxEPC9Channels] of Integer ;
    CSLOW : Array[0..MaxEPC9Channels] of Single ;
    GSERIES : Array[0..MaxEPC9Channels] of Single ;
    GLeak : Array[0..MaxEPC9Channels] of Single ;
    RSMode : Array[0..MaxEPC9Channels] of Integer ;
    RSFraction : Array[0..MaxEPC9Channels] of Single ;
    Filter1 : Array[0..MaxEPC9Channels] of Integer ;
    Filter1Bandwidth : Array[0..MaxEPC9Channels] of Single ;
    Filter2 : Array[0..MaxEPC9Channels] of Integer ;
    Filter2Bandwidth : Array[0..MaxEPC9Channels] of Single ;
    VPOffset : Array[0..MaxEPC9Channels] of Single ;
    VLiquidJunction : Array[0..MaxEPC9Channels] of Single ;
    VHold : Array[0..MaxEPC9Channels] of Single ;
    ZapAmplitude : Array[0..MaxEPC9Channels] of Single ;
    ZapDuration : Array[0..MaxEPC9Channels] of Single ;
    CCGain : Array[0..MaxEPC9Channels] of Integer ;
    CCTrackTau : Array[0..MaxEPC9Channels] of Integer ;

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
    procedure LoadFromXMLFile( FileName : String ) ;
    procedure SaveToXMLFile( FileName : String ) ;
    procedure UpdateEPC9Settings ;
  end;

var
  EPC9PanelFrm: TEPC9PanelFrm;

implementation

{$R *.dfm}

uses MDIForm, SEALTEST;

procedure TEPC9PanelFrm.bAutoCfastClick(Sender: TObject);
// ----------------------------
// Automatic Cfast compensation
// ----------------------------
begin

     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StopADCAndDAC ;
     Screen.Cursor := crHourglass ;
      TButton(Sender).Enabled := False ;
     Main.StatusBar.SimpleText := 'WAIT: Cfast compensation in progress.' ;

     Main.SESLabIO.EPC9AutoCFast ;
     edCFast.Value := Main.SESLabIO.EPC9CFast[1] + Main.SESLabIO.EPC9CFast[2] ;
     edCFastTau.Value := Main.SESLabIO.EPC9CFastTau ;

     // Restart seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

      TButton(Sender).Enabled := True ;

     end;


procedure TEPC9PanelFrm.bAutoCSlowClick(Sender: TObject);
// ----------------------------
// Automatic Cslow compensation
// ----------------------------
begin

     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StopADCAndDAC ;
     Screen.Cursor := crHourglass ;
     TButton(Sender).Enabled := False ;
     Main.StatusBar.SimpleText := 'WAIT: Cslow compensation in progress.' ;

     Main.SESLabIO.EPC9AutoCSlow ;
     edCSlow.Value := Main.SESLabIO.EPC9CSlow ;
     CSlow[cbChannel.ItemIndex] := edCSlow.Value ;
     edGSeries.Value := Main.SESLabIO.EPC9GSeries ;
     GSeries[cbChannel.ItemIndex] := edGSeries.Value ;

     // Restart seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

      TButton(Sender).Enabled := True ;

     end;


procedure TEPC9PanelFrm.bAutoLeakSubtractClick(Sender: TObject);
// ----------------------------
// Automatic leak subtraction
// ----------------------------
begin

     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StopADCAndDAC ;
     Screen.Cursor := crHourglass ;
     TButton(Sender).Enabled := False ;
     Main.StatusBar.SimpleText := 'WAIT: leak subtraction in progress.' ;

     Main.SESLabIO.EPC9AutoGLeak ;
     edGLeak.Value := Main.SESLabIO.EPC9GLeak ;
     GLeak[cbChannel.ItemIndex] := edGLeak.Value ;

     // Restart seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

     TButton(Sender).Enabled := True ;

     end;


procedure TEPC9PanelFrm.bAutoRSCompensationClick(Sender: TObject);
// ----------------------------
// Automatic RS compensation
// ----------------------------
begin

     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StopADCAndDAC ;
     Screen.Cursor := crHourglass ;
     TButton(Sender).Enabled := False ;
     Main.StatusBar.SimpleText := 'WAIT: Cslow compensation in progress.' ;

     // Restart seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

      TButton(Sender).Enabled := True ;

     end;


procedure TEPC9PanelFrm.bAutoVPipetteClick(Sender: TObject);
// ----------------------------
// Automatic V pipette offset
// ----------------------------
begin

     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StopADCAndDAC ;
     Screen.Cursor := crHourglass ;
     TButton(Sender).Enabled := False ;
     Main.StatusBar.SimpleText := 'WAIT: Vpipette offset in progress.' ;

     Main.SESLabIO.EPC9AutoVpOffset ;
     edVpOffset.Value := Main.SESLabIO.EPC9VpOffset ;
     VPOffset[cbChannel.ItemIndex] := edVpOffset.Value ;

     // Restart seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     Screen.Cursor := crDefault ;
     Main.StatusBar.SimpleText := '' ;

     TButton(Sender).Enabled := True ;

     end;


procedure TEPC9PanelFrm.bClearVPOffsetClick(Sender: TObject);
// -------------------------------------
// Clear VPoffset and junction potential
// -------------------------------------
begin
     Main.SESLabIO.EPC9VpOffset := 0.0 ;
     Main.SESLabIO.EPC9VLiquidJunction := 0.0 ;
     edVpOffset.Value := Main.SESLabIO.EPC9VpOffset ;
     VPOffset[cbChannel.ItemIndex] := edVpOffset.Value ;
     edVLiquidJunction.Value := Main.SESLabIO.EPC9VLiquidJunction ;
     VLiquidJunction[cbChannel.ItemIndex] := edVLiquidJunction.Value ;
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     end;


procedure TEPC9PanelFrm.Button2Click(Sender: TObject);
// -------------------------------------
// Clear Gleak
// -------------------------------------
begin
     Main.SESLabIO.EPC9Gleak := 0.0 ;
     edGleak.Value := Main.SESLabIO.EPC9Gleak ;
     Gleak[cbChannel.ItemIndex] :=  edGleak.Value ;
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     end;


procedure TEPC9PanelFrm.bClearCslowClick(Sender: TObject);
// -------------------------------------
// Clear Cslow
// -------------------------------------
begin
     Main.SESLabIO.EPC9Cslow := 0.0 ;
     Main.SESLabIO.EPC9CslowRange := 0 ;
     edCslow.Value := Main.SESLabIO.EPC9Cslow ;
     CSlow[cbChannel.ItemIndex] :=  edCslow.Value ;
     edGseries.Value :=  Main.SESLabIO.EPC9GSeries ;
     Gseries[cbChannel.ItemIndex] :=  edGseries.Value ;
     cbCSlowRange.ItemIndex := Main.SESLabIO.EPC9CslowRange ;
     CSlowRange[cbChannel.ItemIndex] := cbCSlowRange.ItemIndex ;
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     end;

procedure TEPC9PanelFrm.cbCslowRangeChange(Sender: TObject);
// -------------------
// Cslow range changed
// -------------------
begin
     Main.SESLabIO.EPC9CslowRange := cbCslowRange.ItemIndex ;
     cbCslowRange.ItemIndex := Main.SESLabIO.EPC9CslowRange ;
     CSlowRange[cbChannel.ItemIndex] := Main.SESLabIO.EPC9CslowRange ;
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     end;

procedure TEPC9PanelFrm.cbFilter1Change(Sender: TObject);
// -------------------
// Filter 1 changed
// -------------------
begin
    Main.SESLabIO.EPC9FilterMode[1] := cbFilter1.ItemIndex ;
    edFilter1BandWidth.Value := Main.SESLabIO.EPC9FilterBandwidth[1] ;
    cbFilter1.ItemIndex := Main.SESLabIO.EPC9FilterMode[1] ;
    Filter1[cbChannel.ItemIndex] := cbFilter1.ItemIndex ;
    Filter1Bandwidth[cbChannel.ItemIndex] := edFilter1BandWidth.Value ;
    if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
    end;

procedure TEPC9PanelFrm.cbFilter2Change(Sender: TObject);
// -------------------
// Filter 2 changed
// -------------------
begin
    Main.SESLabIO.EPC9FilterMode[2] := cbFilter2.ItemIndex ;
    edFilter2BandWidth.Value := Main.SESLabIO.EPC9FilterBandwidth[2] ;
    cbFilter2.ItemIndex := Main.SESLabIO.EPC9FilterMode[2] ;
    Filter2[cbChannel.ItemIndex] := cbFilter2.ItemIndex ;
    Filter2Bandwidth[cbChannel.ItemIndex] := edFilter2BandWidth.Value ;
    if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
    end;

procedure TEPC9PanelFrm.cbGainChange(Sender: TObject);
// -------------------
// Gain changed
// -------------------
begin
     Main.SESLabIO.EPC9SetCurrentGain( cbGain.ItemIndex) ;
     Gain[cbChannel.ItemIndex] :=  cbGain.ItemIndex ;
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
     end;

procedure TEPC9PanelFrm.cbRSSpeedChange(Sender: TObject);
// -------------------
// RS speed changed
// -------------------
begin
     Main.SESLabIO.EPC9RSMode := cbRSSpeed.ItemIndex ;
     cbRSSpeed.ItemIndex := Main.SESLabIO.EPC9RSMode ;
     RSMode[cbChannel.ItemIndex] := cbRSSpeed.ItemIndex ;
     Main.SESLabIO.EPC9RSMode := cbRSSpeed.ItemIndex ;
     end;


procedure TEPC9PanelFrm.cCfastClearClick(Sender: TObject);
// ----------------------------
// Clear Cfast compensation
// ----------------------------
begin

     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StopADCAndDAC ;

     Main.SESLabIO.EPC9CFast[1] := 0.0 ;
     Main.SESLabIO.EPC9CFast[2] := 0.0 ;
     edCFast.Value := Main.SESLabIO.EPC9CFast[1] + Main.SESLabIO.EPC9CFast[2] ;
     edCFastTau.Value := Main.SESLabIO.EPC9CFastTau ;
     CFast[cbChannel.ItemIndex] := edCFast.Value ;
     CFastTau[cbChannel.ItemIndex] := edCFastTau.Value ;

     // Restart seal test
     if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;

     end;


procedure TEPC9PanelFrm.cbModeChange(Sender: TObject);
// ----------------------------
// Clamp mode changed
// ----------------------------
begin
    Main.SESLabIO.EPC9Mode := cbMode.ItemIndex ;
    cbMode.ItemIndex := Main.SESLabIO.EPC9Mode ;
    Mode[cbChannel.ItemIndex] := cbMode.ItemIndex ;
    if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
    end;

procedure TEPC9PanelFrm.edCfastKeyPress(Sender: TObject; var Key: Char);
// ----------------------------
// Cfast value changed
// ----------------------------
begin
    if Key = #13 then begin
       Main.SESLabIO.EPC9Cfast[1] := 0.5*edCfast.Value ;
       Main.SESLabIO.EPC9Cfast[2] := 0.5*edCfast.Value ;
       edCfast.Value := Main.SESLabIO.EPC9Cfast[1] + Main.SESLabIO.EPC9Cfast[2] ;
       CFast[cbChannel.ItemIndex] :=  edCfast.Value ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
    end;

procedure TEPC9PanelFrm.edCfastTauKeyPress(Sender: TObject; var Key: Char);
// ----------------------------
// Cfast tau value changed
// ----------------------------
begin
    if Key = #13 then begin
       Main.SESLabIO.EPC9CfastTau := edCfastTau.Value ;
       edCfastTau.Value := Main.SESLabIO.EPC9CfastTau ;
       CFastTau[cbChannel.ItemIndex] :=  edCfastTau.Value ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
    end;


procedure TEPC9PanelFrm.edCSlowKeyPress(Sender: TObject; var Key: Char);
// ----------------------------
// Cslow value changed
// ----------------------------
begin
    if Key = #13 then begin
       Main.SESLabIO.EPC9CSlow := edCSlow.Value ;
       edCSlow.Value := Main.SESLabIO.EPC9CSlow ;
       CSlow[cbChannel.ItemIndex] :=  edCSlow.Value ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
    end;



procedure TEPC9PanelFrm.edFilter1BandwidthKeyPress(Sender: TObject;
  var Key: Char);
// ----------------------------
// Filter 1 bandwidth value changed
// ----------------------------
begin
    if Key = #13 then begin
       Main.SESLabIO.EPC9FilterBandwidth[1] := edFilter1Bandwidth.Value ;
       edFilter1Bandwidth.Value := Main.SESLabIO.EPC9FilterBandwidth[1] ;
       Filter1Bandwidth[cbChannel.ItemIndex] :=  edFilter1Bandwidth.Value ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
    end;


procedure TEPC9PanelFrm.edFilter2BandwidthKeyPress(Sender: TObject;
  var Key: Char);
// ----------------------------
// Filter 2 bandwidth value changed
// ----------------------------
begin
    if Key = #13 then begin
       Main.SESLabIO.EPC9FilterBandwidth[2] := edFilter2Bandwidth.Value ;
       edFilter2Bandwidth.Value := Main.SESLabIO.EPC9FilterBandwidth[2] ;
       Filter2Bandwidth[cbChannel.ItemIndex] := edFilter2Bandwidth.Value ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
    end;

procedure TEPC9PanelFrm.edGLeakKeyPress(Sender: TObject; var Key: Char);
// ----------------------------
// Gleak value changed
// ----------------------------
begin
   if Key = #13 then begin
       Main.SESLabIO.EPC9GLeak := edGLeak.Value ;
       edGLeak.Value := Main.SESLabIO.EPC9GLeak ;
       GLeak[cbChannel.ItemIndex] := edGLeak.Value ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
   end;

procedure TEPC9PanelFrm.edRSCompensationKeyPress(Sender: TObject;
  var Key: Char);
// ----------------------------
// RS compensation value changed
// ----------------------------
begin
    if Key = #13 then begin
       Main.SESLabIO.EPC9RSFraction := edRSCompensation.Value ;
       edRSCompensation.Value := Main.SESLabIO.EPC9RSFraction ;
       RSFraction[cbChannel.ItemIndex] := edRSCompensation.Value ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
    end;

procedure TEPC9PanelFrm.edGSeriesKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then begin
       Main.SESLabIO.EPC9GSeries := edGSeries.Value ;
       edGseries.Value := Main.SESLabIO.EPC9GSeries ;
       GSeries[cbChannel.ItemIndex] := Main.SESLabIO.EPC9GSeries ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
    end;


procedure TEPC9PanelFrm.edVHoldKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
       Main.SESLabIO.EPC9VHold := edVHold.Value ;
       edVHold.Value := Main.SESLabIO.EPC9VHold ;
       VHold[cbChannel.ItemIndex] := edVHold.Value ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
end;

procedure TEPC9PanelFrm.edVLiquidJunctionKeyPress(Sender: TObject;
  var Key: Char);
begin
   if Key = #13 then begin
       Main.SESLabIO.EPC9VLiquidJunction := edVLiquidJunction.Value ;
       edVLiquidJunction.Value := Main.SESLabIO.EPC9VLiquidJunction ;
       VLiquidJunction[cbChannel.ItemIndex] := edVLiquidJunction.Value ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
   end;

procedure TEPC9PanelFrm.edVPOffsetKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #13 then begin
       Main.SESLabIO.EPC9VPOffset := edVPOffset.Value ;
       edVPOffset.Value := Main.SESLabIO.EPC9VPOffset ;
       VPOffset[cbChannel.ItemIndex] := edVPOffset.Value ;
       if Main.FormExists( 'SealTestFrm' ) then SealTestFrm.StartADCAndDAC ;
       end;
   end;

procedure TEPC9PanelFrm.FormClose(Sender: TObject; var Action: TCloseAction);
// ----------------------
// Tidy up and close form
// ----------------------
begin

     //ZapAmplitude := edZapAmplitude.Value ;
     //ZapDuration := edZapDuration.Value ;

     // Save amplifier settings
     SaveToXMLFile( SettingsFileName ) ;

     Action := caFree ;

     end;

procedure TEPC9PanelFrm.FormCreate(Sender: TObject);
// ------------------------------------
// Initialisations when form is created
// ------------------------------------
var
    i : Integer ;
begin

    // Initialise settings
    for i := 0 to MaxEPC9Channels-1 do begin
        Gain[i] := 0 ;
        Mode[i] := 0 ;
       CFAST[i] := 0.0 ;
       CFASTTAU[i] := 1E-6 ;
       CSLOWRANGE[i] := 0 ;
       CSLOW[i] := 0.0 ;
       GSERIES[i] := 1E-9 ;
       GLeak[i] := 0.0 ;
       Filter1[i] := 0 ;
       Filter1Bandwidth[i] := 1.0E4 ;
       Filter2[i] := 0 ;
       Filter2Bandwidth[i] := 1.0E4 ;
       VPOffset[i] := 0.0 ;
       VLiquidJunction[i] := 0.0 ;
       ZapAmplitude[i] := 100.0 ;
       ZapDuration[i] := 1E-3 ;
       CCGain[i] := 0 ;
       CCTrackTau[i] := 0 ;
       end;

     // Load settings from XML file
     SettingsFileName := Main.SettingsDirectory + 'EPC9 settings.xml' ;
     if FileExists( SettingsFileName ) then LoadFromXMLFile( SettingsFileName ) ;


end;

procedure TEPC9PanelFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
begin

    // Amplifier selection
    cbChannel.Clear ;
    cbChannel.Items.Add('1') ;
    cbChannel.Items.Add('2') ;
    cbChannel.Items.Add('3') ;
    cbChannel.Items.Add('4') ;
    cbChannel.ItemIndex := 0 ;

    // Gain list
    Main.SESLabIO.EPC9GetCurrentGainList( cbGain.Items ) ;
    cbGain.ItemIndex := Gain[cbChannel.ItemIndex] ;
    Main.SESLabIO.EPC9SetCurrentGain(cbGain.ItemIndex) ;

    cbMode.Clear ;
    cbMode.Items.Add('In Out') ;
    cbMode.Items.Add('On Cell') ;
    cbMode.Items.Add('Out Out') ;
    cbMode.Items.Add('Whole Cell') ;
    cbMode.Items.Add('Current Clamp') ;
    cbMode.ItemIndex := Mode[cbChannel.ItemIndex] ;
    Main.SESLabIO.EPC9Mode := cbMode.ItemIndex ;
    cbMode.ItemIndex := Main.SESLabIO.EPC9Mode ;

    // Filters
    cbFilter2.Clear ;
    cbFilter2.Items.Add('Bessel') ;
    cbFilter2.Items.Add('Butterworth') ;
    Main.SESLabIO.EPC9FilterMode[2] := Filter2[cbChannel.ItemIndex] ;
    cbFilter2.ItemIndex := Main.SESLabIO.EPC9FilterMode[2] ;

    Main.SESLabIO.EPC9FilterBandwidth[2] := Filter2BandWidth[cbChannel.ItemIndex] ;
    edFilter2BandWidth.Value := Main.SESLabIO.EPC9FilterBandwidth[2] ;

    cbFilter1.Clear ;
    cbFilter1.Items.Add('Bessel 100 kHz') ;
    cbFilter1.Items.Add('Bessel 30 kHz') ;
    cbFilter1.Items.Add('Bessel 10 kHz') ;
    cbFilter1.Items.Add('HQ 30 kHz') ;
    Main.SESLabIO.EPC9FilterMode[1] := Filter2[cbChannel.ItemIndex] ;
    cbFilter1.ItemIndex := Main.SESLabIO.EPC9FilterMode[1];

    Main.SESLabIO.EPC9CFast[1] := CFast[cbChannel.ItemIndex] ;
    edCfast.Value := Main.SESLabIO.EPC9CFast[1] ;
    Main.SESLabIO.EPC9CFastTau := CFastTau[cbChannel.ItemIndex] ;
    edCfastTau.Value :=  Main.SESLabIO.EPC9CFastTau ;

    cbCSlowRange.Clear ;
    cbCSlowRange.Items.Add('Off') ;
    cbCSlowRange.Items.Add('30 pF') ;
    cbCSlowRange.Items.Add('100 pF') ;
    cbCSlowRange.Items.Add('1000 pF') ;

    Main.SESLabIO.EPC9CslowRange := CSlowRange[cbChannel.ItemIndex] ;
    cbCSlowRange.ItemIndex := Min(Max(Main.SESLabIO.EPC9CslowRange,0),cbCSlowRange.Items.Count-1);
    Main.SESLabIO.EPC9Cslow := CSlow[cbChannel.ItemIndex] ;
    edCSlow.Value :=  Main.SESLabIO.EPC9Cslow ;
    Main.SESLabIO.EPC9Gseries := GSeries[cbChannel.ItemIndex] ;
    edGSeries.Value := Main.SESLabIO.EPC9Gseries ;

    cbRSSpeed.Clear ;
    cbRSSpeed.Items.Add('Off') ;
    cbRSSpeed.Items.Add('100 us') ;
    cbRSSpeed.Items.Add('10 us') ;
    cbRSSpeed.Items.Add('5 us') ;
    cbRSSpeed.Items.Add('2 us') ;
    Main.SESLabIO.epc9RSMode := RSMode[cbChannel.ItemIndex] ;
    cbRSSpeed.ItemIndex := Min(Max(Main.SESLabIO.epc9RSMode,0),cbCSlowRange.Items.Count-1);
    Main.SESLabIO.EPC9RSFraction := RSFraction[cbChannel.ItemIndex] ;
    edRSCompensation.Value := Main.SESLabIO.EPC9RSFraction ;

    Main.SESLabIO.EPC9GLeak := GLeak[cbChannel.ItemIndex] ;
    edGLeak.Value := Main.SESLabIO.EPC9GLeak ;

    // Current clamp gain
    cbCCGain.Clear ;
    cbCCGain.Items.Add(' 1 pA/mV');
    cbCCGain.Items.Add(' 10 pA/mV');
    cbCCGain.Items.Add(' 100 pA/mV');
    cbCCGain.ItemIndex := CCGain[cbChannel.ItemIndex] ;

    // Current clamp tracking time constant
    cbCCTrackTau.Clear ;
    cbCCTrackTau.Items.Add('Off');
    cbCCTrackTau.Items.Add(' 1 ms');
    cbCCTrackTau.Items.Add(' 3 ms');
    cbCCTrackTau.Items.Add(' 10 ms');
    cbCCTrackTau.Items.Add(' 100 ms');
    cbCCTrackTau.ItemIndex := CCTrackTau[cbChannel.ItemIndex] ;

    end;

procedure TEPC9PanelFrm.UpdateEPC9Settings ;
var
  i: Integer;
begin
    for i := 0 to MaxEPC9Channels-1 do begin
        end ;
end;


procedure TEPC9PanelFrm.SaveToXMLFile(
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


procedure TEPC9PanelFrm.SaveToXMLFile1(
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


    XMLDoc := TXMLDocument.Create(Self);
    XMLDoc.Active := True ;

    // Clear document
    XMLDoc.ChildNodes.Clear ;

    // Add record name
    ProtNode := XMLDoc.AddChild( 'EPC9SETTINGS' ) ;

    // Input channels
    for i := 0 to MaxEPC9Channels-1 do begin
         iNode := ProtNode.AddChild( 'CHANNEL' ) ;
         AddElementInt( iNode, 'NUMBER', i ) ;
         AddElementInt( iNode, 'GAIN', Gain[i]);
         AddElementInt( iNode, 'MODE', Mode[i]);
         AddElementFloat( iNode, 'CFAST', CFAST[i]);
         AddElementFloat( iNode, 'CFASTTAU', CFASTTau[i]);
         AddElementInt( iNode, 'CSLOWRANGE', CSLOWRange[i]);
         AddElementFloat( iNode, 'CSLOW', CSLOW[i]);
         AddElementFloat( iNode, 'GSERIES', GSERIES[i]);
         AddElementFloat( iNode, 'GLEAK', GLEAK[i]);
         AddElementInt( iNode, 'RSMODE', RSMode[i]);
         AddElementFloat( iNode, 'RSFRACTION', RSFraction[i]);
         AddElementInt( iNode, 'FILTER1', Filter1[i]);
         AddElementInt( iNode, 'FILTER2', Filter2[i]);
         AddElementFloat( iNode, 'FILTER1BANDWIDTH', Filter1Bandwidth[i]);
         AddElementFloat( iNode, 'FILTER2BANDWIDTH', Filter2Bandwidth[i]);
         AddElementFloat( iNode, 'VPOFFSET', VPOffset[i]);
         AddElementFloat( iNode, 'VLIQUIDJUNCTION', VLiquidJunction[i]);
         AddElementFloat( iNode, 'VHOLD', VHold[i]);
         AddElementFloat( iNode, 'ZAPAMPLITUDE', ZapDuration[i]);
         AddElementFloat( iNode, 'ZAPDURATION', ZapAmplitude[i]);
         AddElementInt( iNode, 'CCGAIN', CCGain[i]);
         AddElementInt( iNode, 'CCTRACKTAU', CCTrackTau[i]);
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


procedure TEPC9PanelFrm.LoadFromXMLFile(
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



procedure TEPC9PanelFrm.LoadFromXMLFile1(
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


    // Amplifiers
    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'CHANNEL',iNode,NodeIndex) do begin
        GetElementInt( iNode, 'NUMBER', i ) ;
        if (i >= 0) and (i < MaxEPC9Channels) then begin
         GetElementInt( iNode, 'NUMBER', i ) ;
         GetElementInt( iNode, 'GAIN', Gain[i]);
         GetElementInt( iNode, 'MODE', Mode[i]);
         GetElementFloat( iNode, 'CFAST', CFAST[i]);
         GetElementFloat( iNode, 'CFASTTAU', CFASTTau[i]);
         GetElementInt( iNode, 'CSLOWRANGE', CSLOWRange[i]);
         GetElementFloat( iNode, 'CSLOW', CSLOW[i]);
         GetElementFloat( iNode, 'GSERIES', GSERIES[i]);
         GetElementFloat( iNode, 'GLEAK', GLEAK[i]);
         GetElementInt( iNode, 'RSMODE', RSMode[i]);
         GetElementFloat( iNode, 'RSFRACTION', RSFraction[i]);
         GetElementInt( iNode, 'FILTER1', Filter1[i]);
         GetElementInt( iNode, 'FILTER2', Filter2[i]);
         GetElementFloat( iNode, 'FILTER1BANDWIDTH', Filter1Bandwidth[i]);
         GetElementFloat( iNode, 'FILTER2BANDWIDTH', Filter2Bandwidth[i]);
         GetElementFloat( iNode, 'VPOFFSET', VPOffset[i]);
         GetElementFloat( iNode, 'VLIQUIDJUNCTION', VLiquidJunction[i]);
         GetElementFloat( iNode, 'VHOLD', VHold[i]);
         GetElementFloat( iNode, 'ZAPAMPLITUDE', ZapDuration[i]);
         GetElementFloat( iNode, 'ZAPDURATION', ZapAmplitude[i]);
         GetElementInt( iNode, 'CCGAIN', CCGain[i]);
         GetElementInt( iNode, 'CCTRACKTAU', CCTrackTau[i]);
         end ;
        Inc(NodeIndex) ;
        end ;

    XMLDoc.Active := False ;
    XMLDoc := Nil ;

    end ;


procedure TEPC9PanelFrm.AddElementFloat(
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


function TEPC9PanelFrm.GetElementFloat(
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


procedure TEPC9PanelFrm.AddElementInt(
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


function TEPC9PanelFrm.GetElementInt(
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


procedure TEPC9PanelFrm.AddElementBool(
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


function TEPC9PanelFrm.GetElementBool(
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


procedure TEPC9PanelFrm.AddElementText(
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


function TEPC9PanelFrm.GetElementText(
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


function TEPC9PanelFrm.FindXMLNode(
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





end.
