unit UDPUnit;
// -------------------------------
// WinWCP - UDP command interface
// -------------------------------
// 26.11.24 WinWCP command set delivered via UDP connection to localhost
//

interface



uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPServer, IdGlobal, IdSocketHandle, System.StrUtils;

const
    ServerPort = 50001 ;
    ClientPort = 50002 ;


type
  TUDP = class(TDataModule)
    IdUDPServer: TIdUDPServer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure IdUDPServerUDPRead(AThread: TIdUDPListenerThread;
      const AData: TIdBytes; ABinding: TIdSocketHandle);
  private
    { Private declarations }
    procedure ParseCommand( command : string ) ;
    function ExtractString( KeyWord : string ;
                            Command : string ) : string ;
    procedure SendStringToClient( s : string ) ;
    procedure SendDoubleToClient( Value : Double ) ;
    function ExtractDouble( KeyWord : string ;
                            Command : string ) : Double ;

  public
    { Public declarations }
  end;

var
  UDP: TUDP;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses WCPFIleUnit, MDIForm, SealTest, AmpModule, Rec, TritonPanelUnit ;

{$R *.dfm}

procedure TUDP.DataModuleCreate(Sender: TObject);
// --------------------------------
// Initialisation when form created
// --------------------------------
begin

    // Enable UDP server
    idUDPServer.Active := True ;

end;


procedure TUDP.DataModuleDestroy(Sender: TObject);
// ---------------------------
// Tidy up when form destroyed
// ---------------------------
begin
    // Disable UDP server
    idUDPServer.Active := False ;

end;


procedure TUDP.IdUDPServerUDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
// -------------------
// UDB Packet received
// -------------------
var
  Command : string;
begin
  Command := BytesToString(AData);
  ParseCommand ( Command ) ;

  // Reply to caller
 // idudpserver.send('localhost',3458,'OK',nil);

end;

procedure TUDP.SendStringToClient( s : string ) ;
// -------------------------
// Send reply to client port
// -------------------------
begin

  idudpserver.send('localhost',ClientPort,s,nil);

end;


procedure TUDP.SendDoubleToClient( Value : double ) ;
// ----------------------------------------
// Send floating point value to client port
// ----------------------------------------
var
    s : string ;
begin

  s := format('%g',[Value]) ;
  idudpserver.send('localhost',ClientPort,s,nil);

end;


procedure TUDP.ParseCommand( command : string ) ;
// ------------------------------------
// Parse command received in UDB packet
// ------------------------------------
var
    VScale,Value : double ;
    i : Integer ;
    s : string ;
    Enabled : Boolean ;
begin

      // Remove any spaces around '= or ?'
      Command := ANSIReplaceText( Command, ' =', '=' ) ;
      Command := ANSIReplaceText( Command, '= ', '=' ) ;
      Command := ANSIReplaceText( Command, ' ?', '?' ) ;
      Command := ANSIReplaceText( Command, '? ', '?' ) ;

     if ANSIContainsText( Command, 'Newfile=' ) then
        begin
        // ----------------------------
        // Create new data file Newfile = <file name>
        // ----------------------------
        WCPFile.CreateNewDataFile( ExtractString( 'Newfile=', Command ) ) ;
        SendStringToClient('OK');

        end
     else if ANSIContainsText( Command, 'Openfile=' ) then
        begin
        // ----------------------------
        // Open existing data file Openfile = <file name>
        // ----------------------------
        WCPFile.LoadDataFiles( ExtractString( 'Openfile=', Command ) ) ;
        SendStringToClient('OK');

        end
     else if ANSIContainsText( Command, 'Closefile' ) then
        begin
        // ----------------------------
        // Close existing data file Closefile
        // ----------------------------
        Main.CloseFormsAndDataFile ;
        SendStringToClient('OK');

        end
     else if ANSIContainsText( Command, 'FileName?' ) then
        begin
        // ----------------------------
        // Send current data file name
        // ----------------------------
        SendStringToClient( WCPFile.RawFH.FileName ) ;

        end
     else if ANSIContainsText( Command, 'Cm?' ) then
        begin
        // ----------------------------
        // Send cell capacity
        // ----------------------------
        SendDoubleToClient( Main.Cm ) ;
        end
     else if ANSIContainsText( Command, 'Ga?' ) then
        begin
        // -------------------------------
        // Send pipette series conductance
        // -------------------------------
        SendDoubleToClient( Main.Ga ) ;
        end
     else if ANSIContainsText( Command, 'Gm?' ) then
        begin
        //
        // Send cell membrane conductance
        //
        SendDoubleToClient( Main.Gm ) ;
        end
     else if ANSIContainsText( Command, 'Rseal?' ) then
        begin
        // -------------------------------
        // Send current seal resistance
        // -------------------------------
        SendDoubleToClient( Main.RSeal ) ;
        end
     else if ANSIContainsText( Command, 'Im?' ) then
        begin
        // -------------------------------
        // Send cell membrane current
        // -------------------------------
        SendDoubleToClient( Main.Im ) ;
        end
     else if ANSIContainsText( Command, 'Vm?' ) then
        begin
        // -------------------------------
        // Send cell membrane voltage
        // -------------------------------
        SendDoubleToClient( Main.Vm ) ;
        end
     else if ANSIContainsText( Command, 'SealTestPulseAmplitude?' ) then
        begin
        // -------------------------------
        // Send seal test pulse amplitude
        // -------------------------------
        if Main.FormExists('SealTestFrm') then WCPFile.Settings.SealTest.PulseHeight1 := SealTestFrm.TestPulseAmplitude[1] ;
        VScale := Amplifier.CommandScaleFactor[0] ;
        if VScale = 0.0 then VScale := 1.0 ;
        SendDoubleToClient( WCPFile.Settings.SealTest.PulseHeight1*VScale ) ;
        end
     else if ANSIContainsText( Command, 'SealTestPulseAmplitude=' ) then
        begin
        // -------------------------------
        // Set seal test pulse amplitude
        // -------------------------------
        Value := ExtractDouble( 'SealTestPulseAmplitude=', Command ) ;
        if Amplifier.CommandScaleFactor[0] <> 0.0 then VScale := 1.0/Amplifier.CommandScaleFactor[0]
                                                  else VScale := 1.0 ;
        WCPFile.Settings.SealTest.PulseHeight1 := Value*VScale ;

        WCPFile.Settings.SealTest.Use := 1 ;
        if Main.FormExists('SealTestFrm') then
           begin
           SealTestFrm.TestPulseNumber := 1 ;
           SealTestFrm.TestPulseAmplitude[1] := WCPFile.Settings.SealTest.PulseHeight1 ;
           end ;

        SendStringToClient('OK');

        end
     else if ANSIContainsText( Command, 'HoldingVoltage?' ) then
        begin
        // -------------------------------
        // Send seal test holding voltage
        // -------------------------------
        if Main.FormExists('SealTestFrm') then WCPFile.Settings.SealTest.HoldingVoltage1 := SealTestFrm.HoldingVoltage[1] ;
        VScale := Amplifier.CommandScaleFactor[0] ;
        if VScale = 0.0 then VScale := 1.0 ;
        SendDoubleToClient( WCPFile.Settings.SealTest.HoldingVoltage1*VScale ) ;
        end
     else if ANSIContainsText( Command, 'HoldingVoltage=' ) then
        begin
        // -------------------------------
        // Set seal test holding voltage
        // -------------------------------
        Value := ExtractDouble( 'HoldingVoltage=', Command ) ;
        if Amplifier.CommandScaleFactor[0] <> 0.0 then VScale := 1.0/Amplifier.CommandScaleFactor[0]
                                                  else VScale := 1.0 ;
        WCPFile.Settings.SealTest.HoldingVoltage1 := Value*VScale ;

        WCPFile.Settings.SealTest.Use := 1 ;
        if Main.FormExists('SealTestFrm') then
           begin
           SealTestFrm.TestPulseNumber := 1 ;
           SealTestFrm.HoldingVoltage[1] := WCPFile.Settings.SealTest.HoldingVoltage1 ;
           end ;

        SendStringToClient('OK');

        end

     else if ANSIContainsText( Command, 'SealTestPulseDuration?' ) then
        begin
        // --------------------------
        // Send seal test pulse width
        // ---------------------------
        Value := WCPFile.Settings.SealTest.PulseWidth ;
        for i := 0 to Main.MDIChildCount-1 do if Main.MDIChildren[i].Name = 'SealTestFrm' then
            Value := TSealTestFrm(Main.MDIChildren[i]).TestPulseWidth ;
        SendDoubleToClient( Value ) ;
        end
     else if ANSIContainsText( Command, 'SealTestPulseDuration=' ) then
        begin
        // -------------------------------
        // Set seal test pulse width
        // -------------------------------
        Value := ExtractDouble( 'SealTestPulseDuration=', Command ) ;
        WCPFile.Settings.SealTest.PulseWidth := Value ;
        for i := 0 to Main.MDIChildCount-1 do if Main.MDIChildren[i].Name = 'SealTestFrm' then
            TSealTestFrm(Main.MDIChildren[i]).TestPulseWidth := WCPFile.Settings.SealTest.PulseWidth ;

        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'SealTestNumAverages?' ) then
        begin
        // ------------------------------------------------
        // Send no averages used to compute seal resistance
        // ------------------------------------------------
        Value := WCPFile.Settings.SealTest.NumAverages ;
        SendDoubleToClient( Value ) ;
        end
     else if ANSIContainsText( Command, 'SealTestNumAverages=' ) then
        begin
        // -----------------------------------------------
        // Set no averages used to compute seal resistance
        // -----------------------------------------------
        Value := ExtractDouble( 'SealTestNumAverages=', Command ) ;
        WCPFile.Settings.SealTest.NumAverages := Round(Value) ;
        for i := 0 to Main.MDIChildCount-1 do if Main.MDIChildren[i].Name = 'SealTestFrm' then
            TSealTestFrm(Main.MDIChildren[i]).Smoothingfactor := Value ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'SealTestGaFromPeak?' ) then
        begin
        // ------------------------------------------------
        // Send seal test G access calculation mode
        // ------------------------------------------------
        if WCPFile.Settings.SealTest.GaFromPeak then Value := 1
                                                else Value := 0 ;
        SendDoubleToClient( Value ) ;

        end
     else if ANSIContainsText( Command, 'SealTestGaFromPeak=' ) then
        begin
        // -----------------------------------------------
        // Set seal test G access calculation mode
        // -----------------------------------------------
        Value := ExtractDouble( 'SealTestGaFromPeak=', Command ) ;
        if Value <> 0 then WCPFile.Settings.SealTest.GaFromPeak := True
                      else WCPFile.Settings.SealTest.GaFromPeak := False ;
        for i := 0 to Main.MDIChildCount-1 do if Main.MDIChildren[i].Name = 'SealTestFrm' then
            TSealTestFrm(Main.MDIChildren[i]).EstimateGaFromPeak := WCPFile.Settings.SealTest.GaFromPeak ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'StartSealTest' ) then
        begin
        // -------------------------------
        // Start seal test (and open form)
        // -------------------------------
        Main.mnSealTest.Click ;

        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'StopSealTest' ) then
        begin
        // -------------------------------
        // Stop seal test (and close form)
        // -------------------------------
        for i := 0 to Main.MDIChildCount-1 do if Main.MDIChildren[i].Name = 'SealTestFrm' then TSealTestFrm(Main.MDIChildren[i]).Close ;

        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'StimulusProtocol?' ) then
        begin
        //
        // Return current selected stimulus protocol
        // -----------------------------------------
        SendStringToClient(AnsiReplaceText(ExtractFileName(WCPFile.Settings.VProgramFileName),'.xml', '' ) ) ;

        end
     else if ANSIContainsText( Command, 'StimulusProtocol=' ) then
        begin
        // ----------------------------
        // Set stimulus protocol in use
        // ----------------------------
        s := ExtractString( 'StimulusProtocol=', Command ) ;
        WCPFile.Settings.VProgramFileName := WCPFile.Settings.VProtDirectory + s + '.xml' ;
        if Main.FormExists('RecordFrm') then RecordFrm.StimulusProtocol := s ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'TriggerMode?' ) then
       begin
       // -----------------------------------------------
       // Return trigger mode
       // F=Free run, E=external, P=pulse, D=Event detect
       // -----------------------------------------------
       case WCPFile.Settings.RecordingMode of
           rmProtocol : s := 'P' ;
           rmFreeRun : s := 'F' ;
           rmExtTrig : s := 'E' ;
           else s := 'D';
        end ;
        SendStringToClient(s) ;

       end
     else if ANSIContainsText( Command, 'TriggerMode=' ) then
       begin
       // ----------------------
       // Set sweep trigger mode
       // ----------------------
       s := ExtractString( 'TriggerMode=', Command ) ;
       if UpperCase(s) = 'P' then WCPFile.Settings.RecordingMode := rmProtocol
       else if UpperCase(s) = 'F' then WCPFile.Settings.RecordingMode := rmFreeRun
       else if UpperCase(s) = 'E' then WCPFile.Settings.RecordingMode := rmExtTrig
       else WCPFile.Settings.RecordingMode := rmDetect ;
       if Main.FormExists('RecordFrm') then RecordFrm.RecordingMode := WCPFile.Settings.RecordingMode ;

       end
     else if ANSIContainsText( Command, 'StartRecording' ) then
        begin
        // -----------------------
        // Start recording to disk
        // -----------------------
        // Make recording form active
        Main.mnRecordToDisk.Click ;
        // Start recording
        if Main.FormExists('RecordFrm') then RecordFrm.StartRecording ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'StopRecording' ) then
        begin
        // --------------
        // Stop recording
        // --------------
        if Main.FormExists('RecordFrm') then RecordFrm.StopRecording ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'NumChannelsPerRecord?' ) then
        begin
        // ----------------------------------
        // Send no. of channels in data file
        // ----------------------------------
        SendDoubleToClient(  WCPFile.FH.NumChannels ) ;
        end
     else if ANSIContainsText( Command, 'NumChannelsPerRecord=' ) then
        begin
        // --------------------------------
        // Set no. of channels in data file
        // --------------------------------
        Value := ExtractDouble( 'NumChannelsPerRecord=', Command ) ;
        WCPFile.Settings.NumChannels := Round(Value) ;
        SendStringToClient( 'OK' ) ;

        end
     else if ANSIContainsText( Command, 'NumRecordsInFile?' ) then
        begin
        // --------------------------------
        // Send no. of records in data file
        // --------------------------------
        SendDoubleToClient( WCPFile.FH.NumRecords ) ;
        end
     else if ANSIContainsText( Command, 'NumRecordsInFile=' ) then
        begin
        // --------------------------------
        // Set no. of records in data file
        // --------------------------------
        Value := ExtractDouble( 'NumRecordsInFile=', Command ) ;
         WCPFile.FH.NumRecords := Round(Value) ;
        SendStringToClient( 'OK' ) ;

        end
     else if ANSIContainsText( Command, 'NumSamplesPerChannel?' ) then
        begin
        // ------------------------------------------
        // Send no. of samples / channel in data file
        // ------------------------------------------
        SendDoubleToClient( WCPFile.FH.NumSamples ) ;
        end
     else if ANSIContainsText( Command, 'NumSamplesPerChannel=' ) then
        begin
        // -------------------------------------------
        // Set no. of samples / channels in data file
        // -------------------------------------------
        Value := ExtractDouble( 'NumSamplesPerChannel=', Command ) ;
        WCPFile.FH.NumSamples := Round(Value) ;
        SendStringToClient( 'OK' ) ;

        end
     else if ANSIContainsText( Command, 'Status?' ) then
        begin
        // -----------------------------------------
        // Return current status of program activity
        // -----------------------------------------
       // 0 = IDLE, 1=SEAL TEST, 2=ANALOGUE DISPLAY, 3=RECORDING

       Value := 0 ;
       if main.FormExists('SealTestFrm') then
          begin
          if SealTestFrm.Running then Value := 1 ;
          end
       else if main.FormExists('RecordFrm') then
          begin
          if RecordFrm.Running then Value := 2 ;
          if RecordFrm.Recording then Value := 3 ;
          end ;
       SendDoubleToClient( Value ) ;

       end
     else if ANSIContainsText( Command, 'PicoConfig?' ) then
        begin
        // ---------------------------------
        // Read Triton amplifier user config
        // ---------------------------------
        if Main.ShowTritonPanel then Value := TritonPanelFrm.UserConfig
                                else Value := 0 ;
        SendDoubleToClient( Value ) ;
        end
     else if ANSIContainsText( Command, 'PicoConfig=' ) then
        begin
        // ---------------------------------
        // Set Triton amplifier user config
        // ---------------------------------
        Value := ExtractDouble( 'PicoConfig=', Command ) ;
        if Main.ShowTritonPanel then TritonPanelFrm.UserConfig := Round(Value) ;
        SendStringToClient( 'OK' ) ;

        end
     else if ANSIContainsText( Command, 'PicoENableCFast?' ) then
        begin
        // ---------------------------------
        // Read Triton amplifier Cfast comp enabled(1), disabled(0)
        // ---------------------------------
        Value := 0 ;
       if Main.ShowTritonPanel then if TritonPanelFrm.EnableCFast then Value := 1 ;
        SendDoubleToClient( Value ) ;
        end
     else if ANSIContainsText( Command, 'PicoENableCFast=' ) then
        begin
        // ---------------------------------
        // Set Triton amplifier Cfast comp enabled(1), disabled(0)
        // ---------------------------------
        Value := ExtractDouble( 'PicoENableCFast=', Command ) ;
        if Value = 1 then Enabled := True
                     else Enabled := False ;
        if Main.ShowTritonPanel then TritonPanelFrm.EnableCFast := Enabled ;
        SendStringToClient( 'OK' ) ;

        end
     else if ANSIContainsText( Command, 'PicoENableCSlow?' ) then
        begin
        // ---------------------------------
        // Read Triton amplifier Cslow comp enabled(1), disabled(0)
        // ---------------------------------
        Value := 0 ;
       if Main.ShowTritonPanel then if TritonPanelFrm.EnableCSlow then Value := 1 ;
        SendDoubleToClient( Value ) ;
        end
     else if ANSIContainsText( Command, 'PicoENableCSlow=' ) then
        begin
        // ---------------------------------
        // Set Triton amplifier Cslow comp enabled(1), disabled(0)
        // ---------------------------------
        Value := ExtractDouble( 'PicoENableCSlow=', Command ) ;
        if Value = 1 then Enabled := True
                     else Enabled := False ;
        if Main.ShowTritonPanel then TritonPanelFrm.EnableCSlow := Enabled ;
        SendStringToClient( 'OK' ) ;

        end
     else if ANSIContainsText( Command, 'PicoENableJP?' ) then
        begin
        // ---------------------------------
        // Read Triton amplifier junction potential comp enabled(1), disabled(0)
        // ---------------------------------
        Value := 0 ;
       if Main.ShowTritonPanel then if TritonPanelFrm.EnableJP then Value := 1 ;
        SendDoubleToClient( Value ) ;
        end
     else if ANSIContainsText( Command, 'PicoENableJP=' ) then
        begin
        // ---------------------------------
        // Set Triton amplifier junction potential comp enabled(1), disabled(0)
        // ---------------------------------
        Value := ExtractDouble( 'PicoENableJP=', Command ) ;
        if Value = 1 then Enabled := True
                     else Enabled := False ;
        if Main.ShowTritonPanel then TritonPanelFrm.EnableJP := Enabled ;
        SendStringToClient( 'OK' ) ;

        end
     else if ANSIContainsText( Command, 'PicoFilter?' ) then
        begin
        // ---------------------------------
        // Read Triton amplifier filter index
        // ---------------------------------
        SendDoubleToClient( TritonPanelFrm.Filter ) ;
        end
     else if ANSIContainsText( Command, 'PicoFilter=' ) then
        begin
        // ---------------------------------
        // Set Triton amplifier filter index
        // ---------------------------------
        Value := ExtractDouble( 'PicoFilter=', Command ) ;
        if Main.ShowTritonPanel then TritonPanelFrm.Filter := Round(Value) ;
        SendStringToClient( 'OK' ) ;

        end
     else if ANSIContainsText( Command, 'PicoGain?' ) then
        begin
        // ---------------------------------
        // Read Triton amplifier gain index
        // ---------------------------------
        SendDoubleToClient( TritonPanelFrm.Gain ) ;
        end
     else if ANSIContainsText( Command, 'PicoGain=' ) then
        begin
        // ---------------------------------
        // Set Triton amplifier Gain index
        // ---------------------------------
        Value := ExtractDouble( 'PicoGain=', Command ) ;
        if Main.ShowTritonPanel then TritonPanelFrm.Gain := Round(Value) ;
        SendStringToClient( 'OK' ) ;

        end
     else if ANSIContainsText( Command, 'PicoInput?' ) then
        begin
        // ---------------------------------
        // Read Triton amplifier source index
        // ---------------------------------
        SendDoubleToClient( TritonPanelFrm.Source ) ;
        end
     else if ANSIContainsText( Command, 'PicoInput=' ) then
        begin
        // ---------------------------------
        // Set Triton amplifier source index
        // ---------------------------------
        Value := ExtractDouble( 'PicoInput=', Command ) ;
        if Main.ShowTritonPanel then TritonPanelFrm.Source := Round(Value) ;
        SendStringToClient( 'OK' ) ;

        end
     else if ANSIContainsText( Command, 'PicoAutoCompCFast' ) then
        begin
        // ------------------------------------
        // Automatically set CFast compensation
        // ------------------------------------
        if Main.ShowTritonPanel then TritonPanelFrm.AutoCompCFast ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'PicoAutoCompCSlow' ) then
        begin
        // ------------------------------------
        // Automatically set CSlow compensation
        // ------------------------------------
        if Main.ShowTritonPanel then TritonPanelFrm.AutoCompCSlow ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'PicoAutoCompJP' ) then
        begin
        // ------------------------------------
        // Automatically set JP compensation
        // ------------------------------------
        if Main.ShowTritonPanel then TritonPanelFrm.AutoCompJunctionPot ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'PicoAutoCompArtefact' ) then
        begin
        // ------------------------------------
        // Automatically set artefact compensation
        // ------------------------------------
        if Main.ShowTritonPanel then TritonPanelFrm.AutoCompArtefact ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'PicoAutoLeakComp' ) then
        begin
        // -----------------------------------------------
        // Automatically set leak conductance compensation
        // -----------------------------------------------
        if Main.ShowTritonPanel then TritonPanelFrm.AutoLeakComp ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'PicoClearLeakComp' ) then
        begin
        // -----------------------------------------------
        // Clear leak conductance compensation
        // -----------------------------------------------
        if Main.ShowTritonPanel then TritonPanelFrm.ClearLeakComp ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'PicoCfastComp?' ) then
        begin
        // ---------------------------------
        // Read Triton amplifier CFast compensation
        // ---------------------------------
        SendDoubleToClient( TritonPanelFrm.CFast ) ;
        end
     else if ANSIContainsText( Command, 'PicoCSlowComp?' ) then
        begin
        // ---------------------------------
        // Read Triton amplifier Cslow compensation
        // ---------------------------------
        SendDoubleToClient( TritonPanelFrm.CSlow ) ;
        end
     else if ANSIContainsText( Command, 'PicoJPComp?' ) then
        begin
        // ---------------------------------
        // Read Triton amplifier JP compensation
        // ---------------------------------
        SendDoubleToClient( TritonPanelFrm.JP ) ;
        end
     else if ANSIContainsText( Command, 'PicoClearCompC' ) then
        begin
        // ------------------------------------
        // Clear C compensation
        // ------------------------------------
        if Main.ShowTritonPanel then TritonPanelFrm.ClearCompC ;
        SendStringToClient('OK') ;

        end
     else if ANSIContainsText( Command, 'PicoClearCompJP' ) then
        begin
        // ------------------------------------
        // Clear JP compensation
        // ------------------------------------
        if Main.ShowTritonPanel then TritonPanelFrm.ClearCompJP ;
        SendStringToClient('OK') ;

        end


{procedure TAUTO.GetADCSample(RecordNum, ChannelNum, SampleNum: Integer;
  out Value: OleVariant);
// ------------------------------------------
// Return select A/D sample value from record
// ------------------------------------------
var
    ADC : Array[0..MaxADCSamples-1] of SmallInt ;
    i : Integer ;
    RH : TRecHeader ;
begin

     if (RecordNum < 1) or (RecordNum > WCPFile.FH.NumRecords) or
        (ChannelNum < 0) or (ChannelNum >= WCPFile.FH.NumChannels) or
        (SampleNum < 0) or (SampleNum >= WCPFile.FH.NumSamples) then begin
        Value := 0.0 ;
        Exit ;
        end ;

     // Read record from file
     WCPFile.GetRecord( WCPFile.fH, RH, RecordNum, ADC ) ;

     // Read and scale sample
     i := SampleNum*WCPFile.FH.NumChannels + WCPFile.Channel[ChannelNum].ChannelOffset ;
     Value := WCPFile.Channel[ChannelNum].ADCScale*( ADC[i] - WCPFile.Channel[ChannelNum].ADCZero) ;

     end;}


end;


function TUDP.ExtractString( KeyWord : string ;
                             Command : string ) : string ;
// ----------------------------------
// Extract string after '=' character
// -----------------------------------
begin
        // Remove keyword
        Command := ANSIReplaceText( Command, KeyWord, '' ) ;
        Result := Command ;
end;


function TUDP.ExtractDouble( KeyWord : string ;
                             Command : string ) : Double ;
// ------------------------------------------------
// Extract floating point value after '=' character
// ------------------------------------------------
begin
        // Remove spaces and keyword
        Command := ANSIReplaceText( Command, ' ', '' ) ;
        Command := ANSIReplaceText( Command, ' ', '' ) ;
        Command := ANSIReplaceText( Command, ' ', '' ) ;
        Command := ANSIReplaceText( Command, KeyWord, '' ) ;
        Result := WCPFile.ExtractFloat( Command, 0.0 ) ;
end;





end.
