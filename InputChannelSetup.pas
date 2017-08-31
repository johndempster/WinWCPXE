unit InputChannelSetup;
{ ====================================================================
  WinWCP : Digital recording parameters setup dialog.
  (c) J. Dempster, University of Strathclyde 1996, All Rights Reserved
  ====================================================================
  10/9/99 12/16 bit switch added
  7/3/01 Now an MDI form to ensure that FormActivate/Deactivate of
         other MDI forms work (required by SealTest and Record).
  23/10/01 Sampling interval now updated correctly upon first
           opening of Setup dialog box
  22/1/02  Record duration now updated with values consistent with valid sampling intervals
  29.2.02  Settings now saved to WCP file header when OK selected
  24.06.03 No. of horizontal & vertical grid lines added
  18.03.04 MaxADCValue no longer set to SESLabIO.ADCMaxValue
  13.04.04 Channel settings fixed when using VP500 interface
  06.08.04 Channels settings now automatically configured
           when patch clamp amplifier is chosen
  29.07.05 A/D Input mode combo box list added
  25.07.06 Recording channel settings now stored in RecChannel (global.pas)
  24.05.10 Lab. interfaces now listed in alphabetic order
           Channel table shows 16 channels
  25.06.10 NI board device name/number can now be selected (dev1, dev2, etc.)
           Record duration no longer updated to account for changes in sampling int.
           to avoid spurious large values when interface changed
  19.04.11 No. of channels now forced to be greater than 1 for Tecella amplifiers
  10.06.11 Amplifiers and input channel calibration table now on separate tabs
           and separated from lab. interface setup. 4 amplifiers now supported
  13.03.12 VCLAMP/ICLAMP mode no longer set/indicated on amplifiers panel
  17.04.12 Access violation when switching between Amplifiers & Input Channels page
           when more than 16 AI channel were available fixed. (by returning amNone
           for all amplifiers numbers >= MaxAmplifiers. Amplifier.GetChannelSettings()
           no longer changes channel scale factors when Amplifier type is amNone
  19.11.13 SetCurrentDir() now ensure file dialog box opens in correct directory
  20.11.13 Displayed amplifier and channel settings now updated before being written to user-defined settings file
            Settings files now have file ending set to .xml
  18.09.14 Amplifier.VoltageCommandScaleFactor and Amplifier.CurrentCommandScaleFactor now updated by
           cbVoltageCommandChannel.ItemIndex and cbCurrentCommandChannel.ItemIndex not (AmplifiersTab.TabIndex)
           Correct current clamp scale factor now applied for AxoClamp 2s.
  03.06.15 Amplifier.PrimaryChannelUnits & Amplifier.SecondaryChannelUnitsfor for both ICLAMP and VCLAMP modes
           now updated when user makes change to primary channel units for patch clamps
           which DO NOT have mode switched primary/secondary channels.
  24.07.17 AxoPatch 200 and AMS-2440 secondary channel analogue input for CC mode can
           now be defined by user and changed when CC mode selected
           All other channels cannot be changed from default settings

                  }
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Spin, ExtCtrls, shared, sysUtils, Grids, Dialogs, Global, FileIo,
  maths, ValEdit, ValidatedEdit, math, ComCtrls, strutils ;

type
  TInputChannelSetupFrm = class(TForm)
    PageControl: TPageControl;
    ChannelsPage: TTabSheet;
    AmplifiersPage: TTabSheet;
    AmplifiersTab: TTabControl;
    AmpPanel: TPanel;
    cbAmplifier: TComboBox;
    ModeGrp: TGroupBox;
    rbIClamp: TRadioButton;
    rbVClamp: TRadioButton;
    VoltageCommandGrp: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    cbVoltageCommandChannel: TComboBox;
    edVoltageCommandScaleFactor: TValidatedEdit;
    CurrentCommandGrp: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    cbCurrentCommandChannel: TComboBox;
    edCurrentCommandScaleFactor: TValidatedEdit;
    TelegraphChannelsGrp: TGroupBox;
    GainTelegraphPanel: TPanel;
    lbGainTelegraph: TLabel;
    cbGainTelegraphChannel: TComboBox;
    ModeTelegraphPanel: TPanel;
    lbModeTelegraph: TLabel;
    cbModeTelegraphChannel: TComboBox;
    ChannelTable: TStringGrid;
    GroupBox3: TGroupBox;
    TUnitsGrp: TGroupBox;
    rbTmsecs: TRadioButton;
    rbTSecs: TRadioButton;
    bLoadDefaultSettings: TButton;
    bSaveSettings: TButton;
    bLoadSettings: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrimaryChannelGrp: TGroupBox;
    Label3: TLabel;
    Label10: TLabel;
    edPrimaryChannelScaleFactor: TValidatedEdit;
    edPrimaryChannelUnits: TEdit;
    SecondaryChannelGrp: TGroupBox;
    Label5: TLabel;
    Label11: TLabel;
    edSecondaryChannelScaleFactor: TValidatedEdit;
    edSecondaryChannelUnits: TEdit;
    pnSecondaryInputCC: TPanel;
    Label6: TLabel;
    cbSecondaryAnalogInputCC: TComboBox;
    Panel1: TPanel;
    Label1: TLabel;
    cbPrimaryAnalogInput: TComboBox;
    pnSecondaryInputVC: TPanel;
    Label7: TLabel;
    cbSecondaryAnalogInputVC: TComboBox;
    procedure rbTmsecsClick(Sender: TObject);
    procedure rbTSecsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbAmplifierChange(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure AmplifiersTabChange(Sender: TObject);
    procedure edPrimaryChannelUnitsChange(Sender: TObject);
    procedure edSecondaryChannelUnitsChange(Sender: TObject);
    procedure AmplifiersTabChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure edPrimaryChannelScaleFactorKeyPress(Sender: TObject;
      var Key: Char);
    procedure edSecondaryChannelScaleFactorKeyPress(Sender: TObject;
      var Key: Char);
    procedure rbVClampClick(Sender: TObject);
    procedure rbIClampClick(Sender: TObject);
    procedure bLoadDefaultSettingsClick(Sender: TObject);
    procedure ChannelTableKeyPress(Sender: TObject; var Key: Char);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure bSaveSettingsClick(Sender: TObject);
    procedure bLoadSettingsClick(Sender: TObject);
    procedure cbSecondaryAnalogInputCCChange(Sender: TObject);
  private
    { Private declarations }
    AmpNumberonDisplay : Integer ;
    ClampMode : Integer ;

    procedure UpdateAmplifierSettings ;
    procedure FillAmplifierSettings ;
    procedure FillChannelSettings ;
    procedure UpdateChannelSettings ;
    //procedure DisplayClampMode ;
    procedure UpdateADCChannelsWithAmplifierSettings ;
  public
    { Public declarations }
  end;

const
     ChNum = 0 ;
     ChName = 1 ;
     ChVPU = 2 ;
     ChUnits = 3 ;
     ChInputChannel = 4 ;
     chAmp = 5 ;

var
  InputChannelSetupFrm: TInputChannelSetupFrm;
  UpdateOK : boolean ;
  OKorCancelButtonClicked : boolean ;
   OldResolution16Bit : Boolean ;

implementation

uses Mdiform, AmpModule, seslabio , TritonPanelUnit;

{$R *.DFM}



procedure TInputChannelSetupFrm.FormShow(Sender: TObject);
{ --------------------------------------------------------------------------
  Initialise setup's combo lists and tables with current recording parameters
  --------------------------------------------------------------------------}
var
   i : Integer ;
begin

     ClientWidth := PageControl.Left + PageControl.Width + 5 ;
     AmpNumberonDisplay := -1 ;

     { Set time units radio buttons }
     if Settings.TUnits = 's' then rbTSecs.checked := true
                              else rbTmsecs.checked := true ;

     // List of available analog input channels
     cbPrimaryAnalogInput.Clear ;
     cbSecondaryAnalogInputVC.Clear ;
     cbSecondaryAnalogInputCC.Clear ;
     for i := 0 to Min(MaxAmplifiers*2,Main.SESLabIO.ADCMaxChannels)-1 do
         begin
         cbPrimaryAnalogInput.Items.Add(format('AI Ch.%d',[i])) ;
         cbSecondaryAnalogInputCC.Items.Add(format('AI Ch.%d',[i])) ;
         cbSecondaryAnalogInputVC.Items.Add(format('AI Ch.%d',[i])) ;
         end;
     cbPrimaryAnalogInput.ItemIndex := 0 ;
     cbPrimaryAnalogInput.Enabled := False ;
     cbSecondaryAnalogInputVC.ItemIndex := 1 ;
     cbSecondaryAnalogInputVC.Enabled := False ;
     cbSecondaryAnalogInputCC.ItemIndex := 1 ;

     // Telegraph channels
     cbGainTelegraphChannel.Clear ;
     cbModeTelegraphChannel.Clear ;
     for i := 0 to Main.SESLabIO.ADCMaxChannels-1 do begin
         cbGainTelegraphChannel.Items.Add(format('AI Ch.%d',[i])) ;
         cbModeTelegraphChannel.Items.Add(format('AI Ch.%d',[i])) ;
         end ;
     cbGainTelegraphChannel.Items.Add('Off') ;
     cbModeTelegraphChannel.Items.Add('Off') ;
     cbGainTelegraphChannel.ItemIndex := cbGainTelegraphChannel.Items.Count-1 ;
     cbModeTelegraphChannel.ItemIndex := cbModeTelegraphChannel.Items.Count-1 ;

     // Analog output channels
     cbVoltageCommandChannel.Clear ;
     for i := 0 to Main.SESLabIO.DACMaxChannels-1 do
         cbVoltageCommandChannel.Items.Add(format('AO Ch.%d',[i])) ;
     cbCurrentCommandChannel.Items.Assign(cbVoltageCommandChannel.Items) ;
     cbVoltageCommandChannel.ItemIndex := 0 ;
     cbCurrentCommandChannel.ItemIndex := 0 ;

     // Get list of amplifier types
     Amplifier.GetList( cbAmplifier.Items ) ;
     AmplifiersTab.TabIndex := 0 ;
     FillAmplifierSettings ;
     FillChannelSettings ;

     //DisplayClampMode ;

     UpDateOK := True ;
     OKorCancelButtonClicked := False ;
     end;


procedure TInputChannelSetupFrm.FillAmplifierSettings ;
// ----------------------------
// Fill amplifier settings page
// ----------------------------
var
    AmplifierType : Integer ;
      s : string ;
    InCCMode : Boolean ;
begin

     if Main.SESLabIO.LabInterfaceType = Triton then begin
        Amplifier.AmplifierType[0] := amTriton ;
        Amplifier.AmplifierType[1] := amNone ;
        Amplifier.AmplifierType[2] := amNone ;
        Amplifier.AmplifierType[3] := amNone ;
        end ;

     if Main.SESLabIO.LabInterfaceType = vp500 then begin
        Amplifier.AmplifierType[0] := amVP500 ;
        Amplifier.AmplifierType[1] := amNone ;
        Amplifier.AmplifierType[2] := amNone ;
        Amplifier.AmplifierType[3] := amNone ;
        end ;

     // Type of amplifier
     AmplifierType := Amplifier.AmplifierType[AmplifiersTab.TabIndex] ;
     cbAmplifier.ItemIndex := cbAmplifier.Items.IndexofObject(TObject(AmplifierType)) ;

    if not Amplifier.ModeSwitchedPrimaryChannel[AmplifiersTab.TabIndex] then begin
       rbVCLAMP.Checked := True ;
       rbICLAMP.Checked := False ;
       rbVCLAMP.Visible := False ;
       rbICLAMP.Visible := False ;
       end
    else begin
       rbVCLAMP.Visible := True ;
       rbICLAMP.Visible := True ;
       end ;

    if rbVCLAMP.Checked then ClampMode := VClampMode
                        else CLampMode := IClampMode ;

     if AmplifierType = amNone then ModeGrp.Visible := False
                               else ModeGrp.Visible := True ;
     PrimaryChannelGrp.Visible := ModeGrp.Visible ;
     SecondaryChannelGrp.Visible := ModeGrp.Visible ;
     VoltageCommandGrp.Visible := ModeGrp.Visible ;
     CurrentCommandGrp.Visible := ModeGrp.Visible ;
     TelegraphChannelsGrp.Visible := ModeGrp.Visible and
                                     (Amplifier.NeedsGainTelegraphChannel[AmplifiersTab.TabIndex] or
                                      Amplifier.NeedsModeTelegraphChannel[AmplifiersTab.TabIndex]) ;


     s := Amplifier.PrimaryOutputChannelName[AmplifiersTab.TabIndex,ClampMode] ;
     PrimaryChannelGrp.Caption := format(' Ch.%d Primary channel (%s) ',
                                  [Amplifier.PrimaryOutputChannel[AmplifiersTab.TabIndex],s]) ;
     cbPrimaryAnalogInput.ItemIndex := Min(cbPrimaryAnalogInput.Items.Count-1,Max(0,
                                       Amplifier.PrimaryOutputChannel[AmplifiersTab.TabIndex])) ;
     edPrimaryChannelScaleFactor.Value := Amplifier.PrimaryChannelScaleFactorX1Gain[AmplifiersTab.TabIndex,ClampMode] ;
     edPrimaryChannelUnits.Text := Amplifier.PrimaryChannelUnits[AmplifiersTab.TabIndex,ClampMode] ;
     edPrimaryChannelScaleFactor.Units := 'V/' + Amplifier.PrimaryChannelUnits[AmplifiersTab.TabIndex,ClampMode] ;

     // Secondary channel
     s := Amplifier.SecondaryOutputChannelName[AmplifiersTab.TabIndex,ClampMode] ;
     SecondaryChannelGrp.Caption := format(' Ch.%d Secondary channel (%s) ',
                                    [Amplifier.SecondaryOutputChannel[AmplifiersTab.TabIndex],s]) ;
     cbSecondaryAnalogInputVC.ItemIndex := Min(cbSecondaryAnalogInputVC.Items.Count-1,
                                         Max(0,Amplifier.SecondaryOutputChannel[AmplifiersTab.TabIndex])) ;
     cbSecondaryAnalogInputCC.ItemIndex := Min(cbSecondaryAnalogInputCC.Items.Count-1,
                                         Max(0,Amplifier.SecondaryAnalogInputCC[AmplifiersTab.TabIndex])) ;

     // Make secondary analog input menu for this clamp mode visible
     if (ClampMode = IClampMode) then InCCMode := True
                                 else InCCMode := False ;
     pnSecondaryInputCC.Visible := InCCMode ;
     pnSecondaryInputVC.Visible := not InCCMode ;

     // Secondary analog input menu only enabled if amplifier output channel needs to be changed
     if Amplifier.SecondaryOutputChannelName[AmplifiersTab.TabIndex,ICLampMode] =
        Amplifier.SecondaryOutputChannelName[AmplifiersTab.TabIndex,VCLampMode] then
        cbSecondaryAnalogInputCC.Enabled := False
     else cbSecondaryAnalogInputCC.Enabled := True ;

     edSecondaryChannelScaleFactor.Value := Amplifier.SecondaryChannelScaleFactorX1Gain[AmplifiersTab.TabIndex,ClampMode] ;
     edSecondaryChannelUnits.Text := Amplifier.SecondaryChannelUnits[AmplifiersTab.TabIndex,ClampMode] ;
     edSecondaryChannelScaleFactor.Units := 'V/' + Amplifier.SecondaryChannelUnits[AmplifiersTab.TabIndex,ClampMode] ;

     // Gain & mode telegraph

     lbGainTelegraph.Caption := Amplifier.GainTelegraphName[AmplifiersTab.TabIndex] ;
     lbModeTelegraph.Caption := Amplifier.ModeTelegraphName[AmplifiersTab.TabIndex] ;

     GainTelegraphPanel.Visible := Amplifier.NeedsGainTelegraphChannel[AmplifiersTab.TabIndex] ;
     ModeTelegraphPanel.Visible := Amplifier.NeedsModeTelegraphChannel[AmplifiersTab.TabIndex] ;
     cbGainTelegraphChannel.ItemIndex := Min(cbGainTelegraphChannel.Items.Count-1,Max(0,
                                         Amplifier.GainTelegraphChannel[AmplifiersTab.TabIndex])) ;
     cbModeTelegraphChannel.ItemIndex := Min(cbModeTelegraphChannel.Items.Count-1,Max(0,
                                         Amplifier.ModeTelegraphChannel[AmplifiersTab.TabIndex])) ;

     cbVoltageCommandChannel.ItemIndex := Min(cbVoltageCommandChannel.Items.Count-1,Max(0,
                                         Amplifier.VoltageCommandChannel[AmplifiersTab.TabIndex])) ;
     edVoltageCommandScaleFactor.Value := Amplifier.VoltageCommandScaleFactor[cbVoltageCommandChannel.ItemIndex] ;

     cbCurrentCommandChannel.ItemIndex := Min(cbCurrentCommandChannel.Items.Count-1,Max(0,
                                          Amplifier.CurrentCommandChannel[AmplifiersTab.TabIndex])) ;
     edCurrentCommandScaleFactor.Value := Amplifier.CurrentCommandScaleFactor[cbCurrentCommandChannel.ItemIndex] ;

     AmpNumberOnDisplay := AmplifiersTab.TabIndex ;

     end ;


procedure TInputChannelSetupFrm.UpdateAmplifierSettings ;
// ---------------------------------------------
// Update amplifier settings from editing panel
// ---------------------------------------------
begin

     // Type of amplifier
     Amplifier.AmplifierType[AmplifiersTab.TabIndex] := Integer(cbAmplifier.Items.Objects[cbAmplifier.ItemIndex]) ;

     Amplifier.PrimaryChannelScaleFactorX1Gain[AmplifiersTab.TabIndex,ClampMode] := edPrimaryChannelScaleFactor.Value ;

     if Amplifier.ModeSwitchedPrimaryChannel[AmplifiersTab.TabIndex] then begin
        Amplifier.PrimaryChannelUnits[AmplifiersTab.TabIndex,ClampMode] := edPrimaryChannelUnits.Text ;
        end
     else begin
        Amplifier.PrimaryChannelUnits[AmplifiersTab.TabIndex,IClampMode] := edPrimaryChannelUnits.Text ;
        Amplifier.PrimaryChannelUnits[AmplifiersTab.TabIndex,VClampMode] := edPrimaryChannelUnits.Text ;
        end;

     Amplifier.SecondaryChannelScaleFactorX1Gain[AmplifiersTab.TabIndex,ClampMode] := edSecondaryChannelScaleFactor.Value ;
     Amplifier.SecondaryAnalogInputCC[AmplifiersTab.TabIndex] := cbSecondaryAnalogInputCC.ItemIndex ;

     if Amplifier.ModeSwitchedPrimaryChannel[AmplifiersTab.TabIndex] then begin
        Amplifier.SecondaryChannelUnits[AmplifiersTab.TabIndex,ClampMode] :=edSecondaryChannelUnits.Text ;
        end
     else begin
        Amplifier.SecondaryChannelUnits[AmplifiersTab.TabIndex,IClampMode] :=edSecondaryChannelUnits.Text ;
        Amplifier.SecondaryChannelUnits[AmplifiersTab.TabIndex,VClampMode] :=edSecondaryChannelUnits.Text ;
        end ;

     // Gain & mode telegraph
     Amplifier.GainTelegraphChannel[AmplifiersTab.TabIndex] := cbGainTelegraphChannel.ItemIndex ;
     Amplifier.ModeTelegraphChannel[AmplifiersTab.TabIndex] := cbModeTelegraphChannel.ItemIndex ;

     Amplifier.VoltageCommandScaleFactor[cbVoltageCommandChannel.ItemIndex] := edVoltageCommandScaleFactor.Value ;
     Amplifier.CurrentCommandScaleFactor[cbCurrentCommandChannel.ItemIndex] := edCurrentCommandScaleFactor.Value ;

     // Update A/D channels with settings from amplifiers
     UpdateADCChannelsWithAmplifierSettings

     end ;


procedure TInputChannelSetupFrm.FillChannelSettings ;
// ------------------------------
// Fill channel calibration table
// ------------------------------
var
   AmpNumber, ch : Integer ;
begin

     // Ensure channel calibration is matched to amplifier settings
     UpdateADCChannelsWithAmplifierSettings ;

     { Set channel calibration table }
     ChannelTable.RowCount := MaxADCChannels + 1 ;

     ChannelTable.cells[ChNum,0] := 'Ch.' ;
     ChannelTable.colwidths[ChNum] := Round(ChannelTable.DefaultColWidth*0.4) ;
     ChannelTable.cells[ChName,0] := 'Name' ;
     ChannelTable.colwidths[ChName] := ChannelTable.DefaultColWidth ;
     ChannelTable.cells[ChVPU,0] := 'V/Units' ;
     ChannelTable.colwidths[ChVPU] := Round(ChannelTable.DefaultColWidth*1.3) ;
     ChannelTable.cells[ChUnits,0] := 'Units' ;
     ChannelTable.colwidths[ChUnits] := ChannelTable.DefaultColWidth ;
     ChannelTable.cells[ChInputChannel,0] := 'AI Ch.' ;
     ChannelTable.colwidths[ChInputChannel] := Round(ChannelTable.DefaultColWidth*0.9) ;
     ChannelTable.cells[ChAmp,0] := 'Amplifier' ;
     ChannelTable.colwidths[ChAmp] := Round(ChannelTable.DefaultColWidth*2.1) ;
     ChannelTable.options := [goEditing,goHorzLine,goVertLine] ;

     for ch := 0 to Main.SESLabIO.ADCMaxChannels-1  do begin
         ChannelTable.cells[ChNum,ch+1] := IntToStr(ch) ;
         ChannelTable.cells[ChName,ch+1] := Main.SESLabIO.ADCChannelName[ch] ;
         ChannelTable.cells[ChVPU,ch+1] := Format( '%5.4g',[Main.SESLabIO.ADCChannelVoltsPerUnit[ch]] ) ;
         ChannelTable.cells[ChUnits,ch+1] := Main.SESLabIO.ADCChannelUnits[ch] ;
         ChannelTable.cells[ChInputChannel,ch+1] := format('%d',
                                                    [Main.SESLabIO.ADCChannelInputNumber[ch]]) ;
         AmpNumber := ch div 2 ;
         if Amplifier.AmplifierType[AmpNumber] <> amNone then begin
            ChannelTable.cells[ChAmp,ch+1] :=
               format('#%d %s',[AmpNumber+1,Amplifier.ModelName[AmpNumber]]) ;
            end
         else ChannelTable.cells[ChAmp,ch+1] := '' ;

         end ;

     end ;


procedure TInputChannelSetupFrm.UpdateADCChannelsWithAmplifierSettings ;
// ---------------------------------------------------
// Update A/D channel settings with amplifier settings
// ---------------------------------------------------
var
   ch,ADCInput : Integer ;
   Name,Units : string ;
   VPU,Gain : Single ;
begin

     for ch := 0 to Main.SESLabIO.ADCMaxChannels-1 do begin
         Name := Main.SESLabIO.ADCChannelName[ch] ;
         Units := Main.SESLabIO.ADCChannelUnits[ch] ;
         VPU := Main.SESLabIO.ADCChannelVoltsPerUnit[ch] ;
         Gain := Main.SESLabIO.ADCChannelGain[ch] ;
         Amplifier.GetChannelSettings( ch,Name,Units,VPU,Gain,ADCInput ) ;
         Main.SESLabIO.ADCChannelName[ch] := Name ;
         Main.SESLabIO.ADCChannelUnits[ch] := Units ;
         Main.SESLabIO.ADCChannelVoltsPerUnit[ch] := VPU ;
         Main.SESLabIO.ADCChannelGain[ch] := Gain ;
         end ;
     end ;


procedure TInputChannelSetupFrm.UpdateChannelSettings ;
// --------------------------------------
// Update channel calibration from table
// --------------------------------------
var
    ch : Integer ;
begin

     // Update channels with calibration settings from table
     for ch := 0 to Main.SESLabIO.ADCMaxChannels-1  do begin
         Main.SESLabIO.ADCChannelName[ch] := ChannelTable.cells[ChName,ch+1] ;
         Main.SESLabIO.ADCChannelUnits[ch] := ChannelTable.cells[ChUnits,ch+1] ;
         Main.SESLabIO.ADCChannelVoltsPerUnit[ch] := ExtractFloat(ChannelTable.cells[ChVPU,ch+1],1.0) ;
         Main.SESLabIO.ADCChannelInputNumber[ch] := ExtractInt(ChannelTable.cells[ChInputChannel,ch+1]) ;
         end ;

     // Update channels with amplifier settings
     // (Amplifier settings over-ride user-entered channel settings
     //  if an amplifier is defined)
     UpdateADCChannelsWithAmplifierSettings ;

     end ;


procedure TInputChannelSetupFrm.rbTmsecsClick(Sender: TObject);
begin
     Settings.TUnits := 'ms' ;
     Settings.TScale := SecsToms ;
     Settings.TUnscale := MsToSecs ;
     end;


procedure TInputChannelSetupFrm.rbTSecsClick(Sender: TObject);
begin
     Settings.TUnits := 's' ;
     Settings.TScale := 1. ;
     Settings.TUnscale := 1. ;
     end;


procedure TInputChannelSetupFrm.bCancelClick(Sender: TObject);
{ ---------------------------------------
  Exit setup dialog but don't update file
  ---------------------------------------}
begin
     UpdateOK := False ;
     OKorCancelButtonClicked := True ;
     Close ;
     end;


procedure TInputChannelSetupFrm.FormClose(Sender: TObject; var Action: TCloseAction);
{ ---------------------------------------------
  Update values in file header (RawFH) and Exit
  ---------------------------------------------}
var
   ch,ADCInput : Integer ;
   Name,Units : string ;
   VPU,Gain : Single ;
begin

        // Update currently displayed amplifier settings
        UpdateAmplifierSettings ;

        // Update Channel Settings
        UpdateChannelSettings ;

        if Amplifier.AmplifierType[0] = amTriton then begin
            Settings.NumChannels := Min(Settings.NumChannels,2) ;
            if Main.FormExists( 'TritonPanelFrm' ) then TritonPanelFrm.UpdateTritonSettings ;
            // Update channels with amplifier settings
            for ch := 0 to 15 {Main.SESLabIO.ADCMaxChannels-1}  do begin
                Name := Main.SESLabIO.ADCChannelName[ch] ;
                Units := Main.SESLabIO.ADCChannelUnits[ch] ;
                VPU := Main.SESLabIO.ADCChannelVoltsPerUnit[ch] ;
                Gain := Main.SESLabIO.ADCChannelGain[ch] ;
                Amplifier.GetChannelSettings( ch,Name,Units,VPU,Gain,ADCInput ) ;
                Main.SESLabIO.ADCChannelName[ch] := Name ;
                Main.SESLabIO.ADCChannelUnits[ch] := Units ;
                Main.SESLabIO.ADCChannelVoltsPerUnit[ch] := VPU ;
                Main.SESLabIO.ADCChannelGain[ch] := Gain ;
                end ;
            end ;

        // Add Names of channels to list
        ChannelNames.Clear ;
        for ch := 0 to Settings.NumChannels-1 do
            ChannelNames.Add( format('Ch.%d %s',[ch,Main.SESLabIO.ADCChannelName[ch]]) ) ;

        // Initialise channel display settings to minimum magnification
        for ch := 0 to 15 {Main.SESLabIO.ADCMaxChannels-1}  do begin
            Main.SESLabIO.ADCChannelYMin[ch] := Main.SESLabIO.ADCMinValue ;
            Main.SESLabIO.ADCChannelYMax[ch] := Main.SESLabIO.ADCMaxValue ;
            end ;

        Main.NewFileUpdate ;

     Action := caFree ;
     end ;


procedure TInputChannelSetupFrm.cbAmplifierChange(Sender: TObject);
// ----------------------
// Amplifier type changed
// ----------------------
begin
     Amplifier.AmplifierType[AmplifiersTab.TabIndex] := Integer(
                               cbAmplifier.Items.Objects[cbAmplifier.ItemIndex]);
     FillAmplifierSettings ;
     end ;


procedure TInputChannelSetupFrm.cbSecondaryAnalogInputCCChange(Sender: TObject);
// --------------------------------------------------
// Secondary analog input (current clamp mode changed
// --------------------------------------------------
begin
    Amplifier.SecondaryAnalogInputCC[AmplifiersTab.TabIndex] := cbSecondaryAnalogInputCC.ItemIndex ;
    end;

procedure TInputChannelSetupFrm.AmplifiersTabChange(Sender: TObject);
// ---------------------------
// New amplifier tab selected
// ---------------------------
begin
    FillAmplifierSettings ;
    end;

procedure TInputChannelSetupFrm.edPrimaryChannelUnitsChange(Sender: TObject);
// -----------------------------
// Primary channel units changed
// -----------------------------
begin
     edPrimaryChannelScaleFactor.Units := 'V/'+ edPrimaryChannelUnits.Text ;
     if Amplifier.ModeSwitchedPrimaryChannel[AmplifiersTab.TabIndex] then begin
        Amplifier.PrimaryChannelUnits[AmplifiersTab.TabIndex,ClampMode] := edPrimaryChannelUnits.Text ;
        end
     else begin
        Amplifier.PrimaryChannelUnits[AmplifiersTab.TabIndex,IClampMode] := edPrimaryChannelUnits.Text ;
        Amplifier.PrimaryChannelUnits[AmplifiersTab.TabIndex,VClampMode] := edPrimaryChannelUnits.Text ;
        end;
     end ;

procedure TInputChannelSetupFrm.edSecondaryChannelUnitsChange(Sender: TObject);
// -----------------------------
// Secondary channel units changed
// -----------------------------
begin
     edSecondaryChannelScaleFactor.Units := 'V/'+ edSecondaryChannelUnits.Text ;
     if Amplifier.ModeSwitchedPrimaryChannel[AmplifiersTab.TabIndex] then begin
        Amplifier.SecondaryChannelUnits[AmplifiersTab.TabIndex,ClampMode] := edSecondaryChannelUnits.Text ;
        end
     else begin
        Amplifier.SecondaryChannelUnits[AmplifiersTab.TabIndex,IClampMode] := edSecondaryChannelUnits.Text ;
        Amplifier.SecondaryChannelUnits[AmplifiersTab.TabIndex,VClampMode] := edSecondaryChannelUnits.Text ;
        end ;
     end;


procedure TInputChannelSetupFrm.AmplifiersTabChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
    UpdateAmplifierSettings ;
    end;

procedure TInputChannelSetupFrm.edPrimaryChannelScaleFactorKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key = #13 then begin
       Amplifier.PrimaryChannelScaleFactorX1Gain[AmplifiersTab.TabIndex,ClampMode] := edPrimaryChannelScaleFactor.Value ;
       edPrimaryChannelScaleFactor.Value := Amplifier.PrimaryChannelScaleFactorX1Gain[AmplifiersTab.TabIndex,ClampMode] ;
       end ;
    end;

procedure TInputChannelSetupFrm.edSecondaryChannelScaleFactorKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key = #13 then begin
       Amplifier.SecondaryChannelScaleFactorX1Gain[AmplifiersTab.TabIndex,ClampMode] := edSecondaryChannelScaleFactor.Value ;
       edSecondaryChannelScaleFactor.Value := Amplifier.SecondaryChannelScaleFactorX1Gain[AmplifiersTab.TabIndex,ClampMode] ;
       end ;
    end;


procedure TInputChannelSetupFrm.rbVClampClick(Sender: TObject);
// ----------------------------------
// Select voltage-clamp mode settings
// ----------------------------------
begin
     ClampMode := VClampMode ;
     FillAmplifierSettings ;
     end;

procedure TInputChannelSetupFrm.rbIClampClick(Sender: TObject);
// ----------------------------------
// Select current-clamp mode settings
// ----------------------------------
begin
     ClampMode := IClampMode ;
     FillAmplifierSettings ;
     end;


{procedure TInputChannelSetupFrm.DisplayClampMode ;
begin
     if Amplifier.ClampMode[AmplifiersTab.TabIndex] = amVoltageClamp then begin
        rbVClamp.Checked := True ;
        rbIClamp.Checked := False ;
        end
     else begin
        rbVClamp.Checked := False ;
        rbIClamp.Checked := True ;
        end ;

     end ;}



procedure TInputChannelSetupFrm.bLoadDefaultSettingsClick(Sender: TObject);
// -----------------------
// Reload default settings
// ------------------------
begin
     Amplifier.LoadDefaultAmplifierSettings(AmplifiersTab.TabIndex) ;
     FillAmplifierSettings ;
     end;

procedure TInputChannelSetupFrm.ChannelTableKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then begin
        UpdateChannelSettings ;
        FillChannelSettings ;
        end ;
     end;

procedure TInputChannelSetupFrm.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
// -------------------
// Page change started
// -------------------
begin
     if PageControl.ActivePage = ChannelsPage then begin
        UpdateChannelSettings ;
        end
     else if PageControl.ActivePage = AmplifiersPage then begin
        UpdateAmplifierSettings ;
        end ;
     end ;

procedure TInputChannelSetupFrm.PageControlChange(Sender: TObject);
// ----------------------------
// On completion of page change
// -----------------------------
begin
     if PageControl.ActivePage = ChannelsPage then begin
        FillChannelSettings ;
        end
     else if PageControl.ActivePage = AmplifiersPage then begin
        FillAmplifierSettings ;
        end ;
     end ;



procedure TInputChannelSetupFrm.bSaveSettingsClick(Sender: TObject);
// ---------------
//  Save settings
// ---------------
var
  s : TStringList ;
  FileName : String ;
begin

     SaveDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     SaveDialog.InitialDir := Main.SettingsDirectory ;
     SetCurrentDir(Main.SettingsDirectory) ;
     SaveDialog.Title := 'Save Amplifier/Input Channel Settings' ;
     SaveDialog.FileName := '*.xml' ;
     SaveDialog.Filter := ' XML Files (*.XML)';

     if SaveDialog.execute then begin

        UpdateAmplifierSettings ;
        UpdateChannelSettings ;

        FileName := SaveDialog.FileName ;
        if not ContainsText( FileName, '.xml' ) then FileName := FileName + '.xml' ;

        s := TStringList.Create ;
        //s.LoadFromFile(SaveDialog.FileName) ;
        s.Insert(0,'<SETTINGS>') ;
        s.Insert(0,'<?xml version="1.0"?>') ;
        s.SaveToFile(FileName) ;
        Amplifier.SaveToXMLFile(FileName,True) ;
        Main.SESLabIO.SaveToXMLFile(FileName,True) ;
        s.LoadFromFile(FileName) ;
        s.Add('</SETTINGS>') ;
        s.SaveToFile(FileName) ;
        s.Free ;
        end ;

     end ;


procedure TInputChannelSetupFrm.bLoadSettingsClick(Sender: TObject);
// --------------------------------------------------
// Load amplifier & lab. interface settings from file
// --------------------------------------------------
begin
     OpenDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     OpenDialog.FileName := '*.xml' ;
     OpenDialog.InitialDir := Main.SettingsDirectory ;
     SetCurrentDir(Main.SettingsDirectory) ;
     OpenDialog.Title := 'Load Amplifier/Input Channel Settings' ;
     OpenDialog.Filter := ' XML Files (*.XML)';

     if OpenDialog.execute then begin
        Amplifier.LoadFromXMLFile(OpenDialog.FileName) ;
        Main.SESLabIO.LoadFromXMLFile(OpenDialog.FileName) ;
     //   Main.SESLabIO.LabInterfaceType := Main.SESLabIO.LabInterfaceType ;
        FillAmplifierSettings ;
        FillChannelSettings ;
        end ;
     end;

end.
