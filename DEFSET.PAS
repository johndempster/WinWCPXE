unit Defset;
{ -------------------------------------------------------
  WINWCP (c) J. Dempster, University of Strathclyde 1997
  Set default command voltage and digital output settings
  -------------------------------------------------------
  19/8/99 32 bit version for WinWCP V3.0
  20/12/01 ... D/A and digital default values now set using Main.WriteOutputPorts (V3.2.1)
  5/2/04 ..... Normal/Inverted trigger pulse setting added
  2/11/11 .... Settings now updated when digital outputs changed or return pressed for DAC values
  27/8/12 .... Digital & Analog O/Ps now updated correctly
  }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, global, shared, ValEdit, ValidatedEdit,
  ExtCtrls ;

type
  TDefSetFrm = class(TForm)
    DACGroup: TGroupBox;
    DIGGroup: TGroupBox;
    GroupBox2: TGroupBox;
    rbOn1: TRadioButton;
    rbOff1: TRadioButton;
    GroupBox5: TGroupBox;
    rbOn3: TRadioButton;
    rboff3: TRadioButton;
    GroupBox6: TGroupBox;
    rbon4: TRadioButton;
    rboff4: TRadioButton;
    GroupBox7: TGroupBox;
    rbon5: TRadioButton;
    rboff5: TRadioButton;
    GroupBox8: TGroupBox;
    rbon6: TRadioButton;
    rboff6: TRadioButton;
    GroupBox9: TGroupBox;
    rbon7: TRadioButton;
    rboff7: TRadioButton;
    GroupBox1: TGroupBox;
    rbOn2: TRadioButton;
    rbOff2: TRadioButton;
    Dig0: TGroupBox;
    rbOn0: TRadioButton;
    rbOff0: TRadioButton;
    Label3: TLabel;
    Label4: TLabel;
    bOK: TButton;
    panAO0: TPanel;
    lbAO0: TLabel;
    edLevelAO0: TValidatedEdit;
    panAO1: TPanel;
    lbAO1: TLabel;
    edLevelAO1: TValidatedEdit;
    panAO2: TPanel;
    lbAO2: TLabel;
    edLevelAO2: TValidatedEdit;
    panAo3: TPanel;
    lbAO3: TLabel;
    edLevelAO3: TValidatedEdit;
    procedure bOKClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure edLevelAO0KeyPress(Sender: TObject; var Key: Char);
    procedure rbOn0Click(Sender: TObject);
  private
    { Private declarations }
    Initialised : Boolean ;
    procedure SetAOPanel(
    Panel : TPanel ;           // Display panel
    Lab : TLabel ;             // Output channel label
    edLevel : TValidatedEdit ; // Holding level
    AONum : Integer ) ;        // D/A output #
    procedure SetAOHoldingVoltage(
          edLevel : TValidatedEdit ; // Holding level
          AONum : Integer ) ;        // D/A output #
    procedure UpdateAnalogOutputs ;
    procedure UpdateDigitalOutputs ;

  public
    { Public declarations }
  end;

var
  DefSetFrm: TDefSetFrm;

implementation

{$R *.DFM}

uses mdiform  , AmpModule;

const
     CurrentClampUnits = 'pA' ;
     CurrentClampScale = 1E12 ;
     VoltageClampUnits = 'mV' ;
     VoltageClampScale = 1E3 ;

procedure TDefSetFrm.FormShow(Sender: TObject);
// ------------------------------------------
// Initialise controls when form is displayed
// ------------------------------------------
var
   Bit : Word ;
begin
     Initialised := False ;
     { Stop laboratory interface activity }
     if Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
     if Main.SESLabIO.DACActive then Main.SESLabIO.DACStop ;

     { Get default digital O/P settings }
     Bit := Main.SESLabIO.DIGHoldingLevel and 1 ;
     if Bit <> 0 then rbOn0.checked := true
                 else rbOff0.checked := true ;
     Bit := Main.SESLabIO.DIGHoldingLevel and 2 ;
     if Bit <> 0 then rbOn1.checked := true
                 else rbOff1.checked := true  ;
     Bit := Main.SESLabIO.DIGHoldingLevel and 4 ;
     if Bit <> 0 then rbOn2.checked := true
                 else rbOff2.checked := true  ;
     Bit := Main.SESLabIO.DIGHoldingLevel and 8 ;
     if Bit <> 0 then rbOn3.checked := true
                 else rbOff3.checked := true  ;
     Bit := Main.SESLabIO.DIGHoldingLevel and 16 ;
     if Bit <> 0 then rbOn4.checked := true
                 else rbOff4.checked := true  ;
     Bit := Main.SESLabIO.DIGHoldingLevel and 32 ;
     if Bit <> 0 then rbOn5.checked := true
                 else rbOff5.checked := true  ;
     Bit := Main.SESLabIO.DIGHoldingLevel and 64 ;
     if Bit <> 0 then rbOn6.checked := true
                 else rbOff6.checked := true  ;
     Bit := Main.SESLabIO.DIGHoldingLevel and 128 ;
     if Bit <> 0 then rbOn7.checked := true
                 else rbOff7.checked := true  ;

     // Display D/A output holding level
     SetAOPanel( panAO0,lbAO0,edLevelAO0,0 ) ;
     SetAOPanel( panAO1,lbAO1,edLevelAO1,1 ) ;
     SetAOPanel( panAO2,lbAO2,edLevelAO2,2 ) ;
     SetAOPanel( panAO3,lbAO3,edLevelAO3,3 ) ;

     Initialised := True ;

     end;


procedure TDefSetFrm.SetAOPanel(
          Panel : TPanel ;           // Display panel
          Lab : TLabel ;             // Output channel label
          edLevel : TValidatedEdit ; // Holding level
          AONum : Integer ) ;        // D/A output #
//
// Display holding level for selected D/A output
begin
    if AONum < Main.SESLabIO.DACMaxChannels then begin
       Panel.Visible := True ;
       Lab.Caption := format('AO %d',[AONum]) ;
       if (Amplifier.AmplifierType[AONum] = amNone) or
          (Amplifier.ClampMode[AONum] = amVoltageClamp) then begin
          edLevel.Units := VoltageClampUnits ;
          edLevel.Scale := VoltageClampScale*Amplifier.VoltageCommandScaleFactor[AONum] ;
          end
       else begin
          edLevel.Units := CurrentClampUnits ;
          edLevel.Scale := CurrentClampScale*Amplifier.CurrentCommandScaleFactor[AONum] ;
          end ;
       edLevel.Value := Main.SESLabIO.DACHoldingVoltage[AONum] ;
       end
    else Panel.Visible := False ;
    end ;


procedure TDefSetFrm.SetAOHoldingVoltage(
          edLevel : TValidatedEdit ; // Holding level
          AONum : Integer ) ;        // D/A output #
// ----------------------------------------
// Set AO holding voltage = entry box value
// ----------------------------------------
begin
    if not Initialised then Exit ;
    Main.SESLabIO.DACHoldingVoltage[AONum] := edLevel.Value ;
    end ;


procedure TDefSetFrm.bOKClick(Sender: TObject);
// -----------------------------------------
// Update settings when Apply button clicked
// -----------------------------------------
begin
     UpdateAnalogOutputs ;
     UpdateDigitalOutputs ;
     end ;


procedure TDefSetFrm.UpdateDigitalOutputs ;
// -------------------
// Set digital outputs
// -------------------
var
   Value : Word ;
begin
     if not Initialised then Exit ;

     { Update default digital O/P settings }
     Value := 0 ;
     if rbOn0.checked then Value := Value or 1 ;
     if rbOn1.checked then Value := Value or 2 ;
     if rbOn2.checked then Value := Value or 4 ;
     if rbOn3.checked then Value := Value or 8 ;
     if rbOn4.checked then Value := Value or 16 ;
     if rbOn5.checked then Value := Value or 32 ;
     if rbOn6.checked then Value := Value or 64 ;
     if rbOn7.checked then Value := Value or 128 ;
     Main.SESLabIO.DIGHoldingLevel := Value ;

     end ;


procedure TDefSetFrm.UpdateAnalogOutputs ;
// ---------------------
// Set Analog O/P Levels
// ---------------------
begin

     if not Initialised then Exit ;
     {Update voltage settings (DAC 0 & 1) }
     SetAOHoldingVoltage( edLevelAO0, 0 ) ;
     SetAOHoldingVoltage( edLevelAO1, 1 ) ;
     SetAOHoldingVoltage( edLevelAO2, 2 ) ;
     SetAOHoldingVoltage( edLevelAO3, 3 ) ;

     end;


procedure TDefSetFrm.bCancelClick(Sender: TObject);
begin
     close ;
     end;

procedure TDefSetFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

     Action := caFree ;
     end;


procedure TDefSetFrm.edLevelAO0KeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then UpdateAnalogOutputs ;
    end;

procedure TDefSetFrm.rbOn0Click(Sender: TObject);
begin
    UpdateDigitalOutputs ;
    end;

end.
