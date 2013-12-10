unit AutoUnit;
// -----------------------------
// WinWCP - Automation Interface
// -----------------------------
// 08.12.05
// 06.12.13 Set_HoldingVoltage/Get_HoldingVoltage, Set_SealTestPulseAmplitude/Get_SealTestPulseAmplitude
//          now scaled by amplifier command voltage scale factor

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, winwcp_TLB, StdVcl, sysutils, math, strutils, seslabio, ampmodule ;

type
  TAUTO = class(TAutoObject, IAUTO)
  protected
    procedure NewFile(FileName: OleVariant); safecall;
    procedure CloseFile; safecall;
    procedure OpenFile(FileName: OleVariant); safecall;
    function Get_Cm: OleVariant; safecall;
    function Get_Ga: OleVariant; safecall;
    function Get_Gm: OleVariant; safecall;
    procedure StartSealTest; safecall;
    procedure Set_Cm(Value: OleVariant); safecall;
    procedure Set_Ga(Value: OleVariant); safecall;
    procedure Set_Gm(Value: OleVariant); safecall;
    function Get_Rseal: OleVariant; safecall;
    function Get_SealTestPulseAmplitude: OleVariant; safecall;
    function Get_SealTestPulseDuration: OleVariant; safecall;
    procedure Set_Rseal(Value: OleVariant); safecall;
    procedure Set_SealTestPulseAmplitude(Value: OleVariant); safecall;
    procedure Set_SealTestPulseDuration(Value: OleVariant); safecall;
    procedure StopSealTest; safecall;
    function Get_HoldingVoltage: OleVariant; safecall;
    procedure Set_HoldingVoltage(Value: OleVariant); safecall;
    function Get_StimulusProtocol: OleVariant; safecall;
    function Get_TriggerMode: OleVariant; safecall;
    procedure Set_StimulusProtocol(Value: OleVariant); safecall;
    procedure Set_TriggerMode(Value: OleVariant); safecall;
    procedure StartRecording; safecall;
    procedure StopRecording; safecall;
    function Get_Im: OleVariant; safecall;
    function Get_Vm: OleVariant; safecall;
    procedure Set_Im(Value: OleVariant); safecall;
    procedure Set_Vm(Value: OleVariant); safecall;
    function Get_SealTestSmoothingFactor: OleVariant; safecall;
    procedure Set_SealTestSmoothingFactor(Value: OleVariant); safecall;
    function Get_NumChannelsPerRecord: Integer; safecall;
    function Get_NumRecordsInFile: Integer; safecall;
    function Get_NumSamplesPerChannel: Integer; safecall;
    procedure GetADCSample(RecordNum, ChannelNum, SampleNum: Integer;
      out Value: OleVariant); safecall;
    procedure Set_NumChannelsPerRecord(Value: Integer); safecall;
    procedure Set_NumRecordsInFile(Value: Integer); safecall;
    procedure Set_NumSamplesPerChannel(Value: Integer); safecall;
    function Get_Status: OleVariant; safecall;
    procedure Set_Status(Value: OleVariant); safecall;

  end;

implementation

uses ComServ, mdiform, global, fileio, rec, SealTest ;

procedure TAUTO.NewFile(FileName: OleVariant);
// ----------------------
// Create a new data file
// ----------------------
begin

     Main.CreateNewDataFile( FileName ) ;

     end;


procedure TAUTO.CloseFile;
// ---------------
// Close data file
// ---------------
begin
    Main.CloseFormsAndDataFile ;
    end;


procedure TAUTO.OpenFile(FileName: OleVariant);
// ---------------------
// Open a .WCP data file
// ---------------------
begin
     Main.LoadDataFiles(FileName);
     end;

     
function TAUTO.Get_Cm: OleVariant;
// ---------------------------
// Read cell membrane capacity
// ---------------------------
begin
     Result := Main.Cm ;
     end;

function TAUTO.Get_Ga: OleVariant;
// ---------------------------
// Read pipette access conductance
// ---------------------------
begin
     Result := Main.Ga ;
     end;


function TAUTO.Get_Gm: OleVariant;
// ---------------------------
// Read cell membrane conductance
// ---------------------------
begin
     Result := Main.Gm ;
     end;

procedure TAUTO.StartSealTest;
// ---------------
// Start seal test
// ---------------
begin

     Main.mnSealTest.Click ;

     end;

procedure TAUTO.Set_Cm(Value: OleVariant);
begin

end;

procedure TAUTO.Set_Ga(Value: OleVariant);
begin

end;

procedure TAUTO.Set_Gm(Value: OleVariant);
begin

end;

function TAUTO.Get_Rseal: OleVariant;
// ---------------------------
// Read seal resistance
// ---------------------------
begin
     Result := Main.RSeal ;
 end;

function TAUTO.Get_SealTestPulseAmplitude: OleVariant;
// -------------------
// Get pulse amplitude
// -------------------
var
    VScale : Single ;
begin

     if Main.FormExists('SealTestFrm') then
        Settings.SealTest.PulseHeight1 := SealTestFrm.TestPulseAmplitude[1] ;

     VScale := Amplifier.CommandScaleFactor[0] ;
     if VScale = 0.0 then VScale := 1.0 ;
     Result := Settings.SealTest.PulseHeight1*VScale ;

    end ;


function TAUTO.Get_SealTestPulseDuration: OleVariant;
// -------------------------------
// Return width of seal test pulse
// -------------------------------
var
    i : Integer ;
begin

     Result := Settings.SealTest.PulseWidth ;
     for i := 0 to Main.MDIChildCount-1 do
         if Main.MDIChildren[i].Name = 'SealTestFrm' then
            Result := TSealTestFrm(Main.MDIChildren[i]).TestPulseWidth ;

    end ;

procedure TAUTO.Set_Rseal(Value: OleVariant);
begin

end;


procedure TAUTO.Set_SealTestPulseAmplitude(Value: OleVariant);
// -----------------------------
// Set seal test pulse amplitude
// -----------------------------
var
    VScale : Single ;
begin

     if Amplifier.CommandScaleFactor[0] <> 0.0 then VScale := 1.0/Amplifier.CommandScaleFactor[0]
                                               else VScale := 1.0 ;
     Settings.SealTest.PulseHeight1 := Value*VScale ;

     Settings.SealTest.Use := 1 ;
     if Main.FormExists('SealTestFrm') then begin
        SealTestFrm.TestPulseNumber := 1 ;
        SealTestFrm.TestPulseAmplitude[1] := Settings.SealTest.PulseHeight1 ;
        end ;

     end;


procedure TAUTO.Set_SealTestPulseDuration(Value: OleVariant);
// -------------------------------
// Set width of seal test pulse
// -------------------------------
var
    i : Integer ;
begin

     Settings.SealTest.PulseWidth := Value ;
     for i := 0 to Main.MDIChildCount-1 do
         if Main.MDIChildren[i].Name = 'SealTestFrm' then
            TSealTestFrm(Main.MDIChildren[i]).TestPulseWidth := Settings.SealTest.PulseWidth ;

     end;


procedure TAUTO.StopSealTest;
// -------------------------------
// Stop seal test and close window
// -------------------------------
var
    i : Integer ;
begin

     for i := 0 to Main.MDIChildCount-1 do
         if Main.MDIChildren[i].Name = 'SealTestFrm' then
            TSealTestFrm(Main.MDIChildren[i]).Close ;

     end;

function TAUTO.Get_HoldingVoltage: OleVariant;
// -------------------
// Get holding voltage
// -------------------
var
    VScale : Single ;
begin

     if Main.FormExists('SealTestFrm') then
        Settings.SealTest.HoldingVoltage1 := SealTestFrm.HoldingVoltage[1] ;

     VScale := Amplifier.CommandScaleFactor[0] ;
     if VScale = 0.0 then VScale := 1.0 ;
     Result := Settings.SealTest.HoldingVoltage1*VScale ;

    end ;


procedure TAUTO.Set_HoldingVoltage(Value: OleVariant);
// -------------------
// Set holding voltage
// --------------------
var
    VScale : Single ;
begin

     if Amplifier.CommandScaleFactor[0] <> 0.0 then VScale := 1.0/Amplifier.CommandScaleFactor[0]
                                               else VScale := 1.0 ;
     Settings.SealTest.HoldingVoltage1 := Value*VScale ;

     Settings.SealTest.Use := 1 ;
     if Main.FormExists('SealTestFrm') then begin
        SealTestFrm.TestPulseNumber := 1 ;
        SealTestFrm.HoldingVoltage[1] := Settings.SealTest.HoldingVoltage1 ;
        end ;

     end;

function TAUTO.Get_StimulusProtocol: OleVariant;
// -----------------------------------------
// Return current selected stimulus protocol
// -----------------------------------------
begin
     Result := AnsiReplaceText(ExtractFileName(Settings.VProgramFileName),'.vpr', '' ) ;
     end;


function TAUTO.Get_TriggerMode: OleVariant;
// -----------------------------------------------
// Return trigger mode
// F=Free run, E=external, P=pulse, D=Event detect
// -----------------------------------------------
begin
     case Settings.RecordingMode of
        rmProtocol : Result := 'P' ;
        rmFreeRun : Result := 'F' ;
        rmExtTrig : Result := 'E' ;
        else Result := 'D' ;
        end ;
     end ;


procedure TAUTO.Set_StimulusProtocol(Value: OleVariant);
// ---------------------
// Set stimulus protocol
// ---------------------
begin
     Settings.VProgramFileName := Settings.VProtDirectory + Value + '.vpr' ;
     if Main.FormExists('RecordFrm') then RecordFrm.StimulusProtocol := Value ;
     end;


procedure TAUTO.Set_TriggerMode(Value: OleVariant);
// ----------------------
// Set sweep trigger mode
// ----------------------
begin
       ;
     if UpperCase(Value) = 'P' then Settings.RecordingMode := rmProtocol
     else if UpperCase(Value) = 'F' then Settings.RecordingMode := rmFreeRun
     else if UpperCase(Value) = 'E' then Settings.RecordingMode := rmExtTrig
     else Settings.RecordingMode := rmDetect ;

     if Main.FormExists('RecordFrm') then RecordFrm.RecordingMode := Settings.RecordingMode ;

     end;


procedure TAUTO.StartRecording;
// -----------------------
// Start recording to disk
// -----------------------
begin
     // Make recording form active
     Main.mnRecordToDisk.Click ;
     // Start recording
     if Main.FormExists('RecordFrm') then RecordFrm.StartRecording ;

     end;


procedure TAUTO.StopRecording;
// -----------------------
// Stop recording to disk
// -----------------------
begin
     // Start recording
     if Main.FormExists('RecordFrm') then RecordFrm.StopRecording ;

     end;

function TAUTO.Get_Im: OleVariant;
// --------------------------------
// Return cell membrane current (A)
// --------------------------------
begin
     Result := Main.Im ;
     end;


function TAUTO.Get_Vm: OleVariant;
// --------------------------------
// Return cell membrane voltage (V)
// --------------------------------
begin
     Result := Main.Vm ;
     end;

procedure TAUTO.Set_Im(Value: OleVariant);
begin

end;

procedure TAUTO.Set_Vm(Value: OleVariant);
begin

end;


function TAUTO.Get_SealTestSmoothingFactor: OleVariant;
// ---------------------------------------------
// Get seal test cell parameter smoothing factor
// ---------------------------------------------
begin
     Result := Settings.SealTest.SmoothingFactor ;
     end;


procedure TAUTO.Set_SealTestSmoothingFactor(Value: OleVariant);
// ---------------------------------------------
// Set seal test cell parameter smoothing factor
// ---------------------------------------------
begin
     Settings.SealTest.SmoothingFactor := Min(Max(Value,0.1),1.0) ;
     end;

function TAUTO.Get_NumChannelsPerRecord: Integer;
// ----------------------------------------
// Get no. of A/D input channels per record
// ----------------------------------------
begin
    Result := FH.NumChannels ;
    end;


function TAUTO.Get_NumRecordsInFile: Integer;
// -----------------------------------
// Return number of channels in record
// -----------------------------------
begin
    Result := FH.NumRecords ;
    end;


function TAUTO.Get_NumSamplesPerChannel: Integer;
// -----------------------------------
// Return number of A/D samples per channel
// -----------------------------------
begin
    Result := FH.NumSamples ;
    end;


procedure TAUTO.GetADCSample(RecordNum, ChannelNum, SampleNum: Integer;
  out Value: OleVariant);
// ------------------------------------------
// Return select A/D sample value from record
// ------------------------------------------
var
    ADC : Array[0..MaxADCSamples-1] of SmallInt ;
    i : Integer ;
    RH : TRecHeader ;
begin

     if (RecordNum < 1) or (RecordNum > FH.NumRecords) or
        (ChannelNum < 0) or (ChannelNum >= FH.NumChannels) or
        (SampleNum < 0) or (SampleNum >= FH.NumSamples) then begin
        Value := 0.0 ;
        Exit ;
        end ;

     // Read record from file
     GetRecord( fH, RH, RecordNum, ADC ) ;

     // Read and scale sample
     i := SampleNum*FH.NumChannels + Channel[ChannelNum].ChannelOffset ;
     Value := Channel[ChannelNum].ADCScale*( ADC[i] - Channel[ChannelNum].ADCZero) ;

     end;


procedure TAUTO.Set_NumChannelsPerRecord(Value: Integer);
// -----------------------------------------
// Set number of a/d channels to be acquired
// -----------------------------------------
begin
     Settings.NumChannels := Round(Value) ;
     end;


procedure TAUTO.Set_NumRecordsInFile(Value: Integer);
// -----------------------------------------
// Set number of sweeps to be acquired
// -----------------------------------------
begin
     Settings.NumRecordsRequired := Round(Value) ;
     end;


procedure TAUTO.Set_NumSamplesPerChannel(Value: Integer);
// -----------------------------------------
// Set number of samples/channel to be acquired
// -----------------------------------------
begin
     Settings.NumSamples := Max(Round(Value) div 256,1)*256 ;
     end;


function TAUTO.Get_Status: OleVariant;
// -----------------------------------------
// Return current status of program activity
// -----------------------------------------
// 0 = IDLE, 1=SEAL TEST, 2=ANALOGUE DISPLAY, 3=RECORDING
begin

     Result := 0 ;
     if main.FormExists('SealTestFrm') then begin
        if SealTestFrm.Running then Result := 1 ;
        end
     else if main.FormExists('RecordFrm') then begin
        if RecordFrm.Running then Result := 2 ;
        if RecordFrm.Recording then Result := 3 ;
        end ;

     end;

procedure TAUTO.Set_Status(Value: OleVariant);
begin
     end;



initialization
  TAutoObjectFactory.Create(ComServer, TAUTO, Class_AUTO,
    ciMultiInstance, tmApartment);
end.
