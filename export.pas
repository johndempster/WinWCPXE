unit export;
{ ================================================================
  WinWCP (c) J. Dempster, University of Strathclyde, 1998-99
  Data file export module
  ================================================================
  5/2/00
  28/2/00 ... Change File Name now works, channel captions updated
  9/2/02 ... V2.2.6 ASCII text export added
  26/2/02 ... V2.3.0 ASCII text export now works properly
              Progress reported to main status bar
  14/08/02 ... Bug which prevented export when output file did not exist fixed  (V2.3.4)
  1/12/03 .... Export now uses TADCDataFile component
  19/04/03 ... Modified for use by WinWCP
  }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RangeEdit, global, convert, ADCDataFile, maths ;

type
  TExportFrm = class(TForm)
    GroupBox8: TGroupBox;
    rbAllRecords: TRadioButton;
    rbRange: TRadioButton;
    edRange: TRangeEdit;
    ChannelsGrp: TGroupBox;
    ckCh0: TCheckBox;
    ckCh1: TCheckBox;
    ckCh2: TCheckBox;
    ckCh3: TCheckBox;
    ckCh4: TCheckBox;
    ckCh5: TCheckBox;
    ckCh6: TCheckBox;
    ckCh7: TCheckBox;
    GroupBox3: TGroupBox;
    edFileName: TEdit;
    GroupBox2: TGroupBox;
    rbABF: TRadioButton;
    rbCFS: TRadioButton;
    bChangeName: TButton;
    bOK: TButton;
    bCancel: TButton;
    SaveDialog: TSaveDialog;
    rbASCII: TRadioButton;
    rbEDR: TRadioButton;
    ExportFile: TADCDataFile;
    rbWCP: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bChangeNameClick(Sender: TObject);
    procedure rbABFClick(Sender: TObject);
    procedure rbLDTClick(Sender: TObject);
    procedure rbCFSClick(Sender: TObject);
    procedure rbASCIIClick(Sender: TObject);
    procedure rbEDRClick(Sender: TObject);
    procedure rbWCPClick(Sender: TObject);
  private
    { Private declarations }
    ExportFileName : string ;
    procedure SetChannel( CheckBox : TCheckBox ; ch : Integer ) ;
    procedure UpdateSettings ;
  public
    { Public declarations }
  end;

var
  ExportFrm: TExportFrm;

implementation

uses Mdiform, fileio ;

{$R *.DFM}


procedure TExportFrm.FormShow(Sender: TObject);
// ------------------------------
// Initialise form when displayed
// ------------------------------
begin

     { Set block of EDR file to be exported }
     edRange.LoValue := 1.0 ;
     edRange.HiLimit := RawFH.NumRecords ;
     edRange.HiValue := edRange.HiLimit ;

     { Update O/P file name channel selection options }
     ExportFileName := RawFH.FileName ;
     UpdateSettings ;
     ChannelsGrp.Enabled := True ;

     end;


procedure TExportFrm.SetChannel(
          CheckBox : TCheckBox ;
          ch : Integer
          ) ;
// ---------------------------
// Set channel selection state
// ---------------------------
begin
     if ch < RawFH.NumChannels then begin
        CheckBox.Visible := True ;
        CheckBox.Checked := Channel[ch].InUse ;
        CheckBox.Caption := Channel[ch].ADCName ;
        end
     else CheckBox.Visible := False ;
     end ;


procedure TExportFrm.bOKClick(Sender: TObject);
// -------------------------------------------------
// Copy selected section of data file to export file
// -------------------------------------------------
type
    TSmallIntArray1 = Array[0..9999999] of SmallInt ;
var
   StartAt,EndAt,ch,i,j : Integer ;
   UseChannel : Array[0..ChannelLimit] of Boolean ; // Channels to be exported
   NumBytesPerBuf : Integer ;       // Buffer size
   InBuf : ^TSmallIntArray1 ;       // Source data buffer
   OutBuf : ^TSmallIntArray1 ;      // Output data buffer
   chOut : Integer ;
   iRec : Integer ;                 // Record counter
   RH : TRecHeader ;                // WCP record header
   NumRecordsExported : Integer ;
   WCPRecHeader : TWCPRecordHeader ;
   ExportType : TADCDataFileType ;
begin

     // If destination file already exists, allow user to abort
     if FileExists( ExportFileName ) then begin
        if MessageDlg( ExportFileName + ' exists! Overwrite?!',
           mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit ;
        end ;

     if rbAllRecords.Checked then begin
        StartAt := 1 ;
        EndAt := RawFH.NumRecords ;
        end
     else begin
        StartAt := Round(edRange.LoValue) ;
        EndAt := Round(edRange.HiValue) ;
        end ;

     // Channels to be exported
     UseChannel[0] :=  ckCh0.Checked ;
     UseChannel[1] :=  ckCh1.Checked ;
     UseChannel[2] :=  ckCh2.Checked ;
     UseChannel[3] :=  ckCh3.Checked ;
     UseChannel[4] :=  ckCh4.Checked ;
     UseChannel[5] :=  ckCh5.Checked ;
     UseChannel[6] :=  ckCh6.Checked ;
     UseChannel[7] :=  ckCh7.Checked ;

     // Export file type
     if rbABF.Checked then ExportType := ftAxonABF
     else if rbASCII.Checked then ExportType := ftASC
     else if rbCFS.Checked then ExportType := ftCFS
     else if rbEDR.Checked then ExportType := ftEDR
     else ExportType := ftWCP ;

     // Create empty export data file
     ExportFile.CreateDataFile( ExportFileName,
                                ExportType ) ;

     // Set file parameters
     ExportFile.NumScansPerRecord := RawFH.NumSamples ;
     ExportFile.MaxADCValue := MaxADCValue ;
     ExportFile.MinADCValue := MinADCValue ;
     ExportFile.ScanInterval := RawFH.dt ;
     ExportFile.IdentLine := RawFH.IdentLine ;
     ExportFile.ABFAcquisitionMode := ftEpisodic ;

     NumBytesPerBuf := RawFH.NumSamples*RawFH.NumChannels*2 ;
     GetMem( InBuf, NumBytesPerBuf ) ;
     GetMem( OutBuf, NumBytesPerBuf ) ;

     Try

     chOut := 0 ;
     for ch := 0 to RawFH.NumChannels-1 do if UseChannel[ch] then begin
         ExportFile.ChannelOffset[chOut] := chOut ;
         ExportFile.ChannelADCVoltageRange[chOut] := RawFH.ADCVoltageRange ;
         ExportFile.ChannelName[chOut] := Channel[ch].ADCName ;
         ExportFile.ChannelUnits[chOut] := Channel[ch].ADCUnits ;
         ExportFile.ChannelScale[chOut] := Channel[ch].ADCSCale ;
         ExportFile.ChannelCalibrationFactor[chOut] := Channel[ch].ADCCalibrationFactor ;
         ExportFile.ChannelGain[chOut] := Channel[ch].ADCAmplifierGain ;
         Inc(chOut) ;
         end ;
     ExportFile.NumChannelsPerScan := chOut ;

     { Copy records }
     NumRecordsExported := 0 ;
     for iRec := StartAt to EndAt do begin

         // Read record
         GetRecord(RawFH,RH,iRec,InBuf^) ;

         // Copy required channels
         j := 0 ;
         for i := 0 to RawFH.NumSamples-1 do begin
             for ch := 0 to RawFH.NumChannels-1 do if UseChannel[ch] then begin
                 OutBuf^[j] := InBuf^[(i*RawFH.NumChannels)+Channel[ch].ChannelOffset] ;
                 Inc(j) ;
                 end ;
             end ;

         Inc(NumRecordsExported) ;
         ExportFile.RecordNum := NumRecordsExported ;

         if ExportType = ftWCP then begin
            // Update record header (WCP file only)
            WCPRecHeader.Status := RH.Status ;
            WCPRecHeader.RecType := RH.RecType ;
            WCPRecHeader.Number :=  RH.Number ;
            WCPRecHeader.Time :=  RH.Time ;
            WCPRecHeader.dt := RH.dt ;
            WCPRecHeader.Ident := RH.Ident ;
            chOut := 0 ;
            for ch := 0 to RawFH.NumChannels-1 do if UseChannel[ch] then begin
                WCPRecHeader.ADCVoltageRange[ch] := RH.ADCVoltageRange[ch] ;
                Inc(chOut) ;
                end ;
            WCPRecHeader.Equation.Available := False ;
            WCPRecHeader.Analysis.Available := False ;
            ExportFile.WCPSaveRecordHeader( WCPRecHeader ) ;
            end
         else begin
            // Adjust calibration factor for variations in channel gain (all other formats)
            chOut := 0 ;
            for ch := 0 to RawFH.NumChannels-1 do if UseChannel[ch] then begin
                ExportFile.ChannelCalibrationFactor[chOut] := Channel[ch].ADCCalibrationFactor *
                                                              (RawFH.ADCVoltageRange/RH.ADCVoltageRange[ch]) ;
                Inc(chOut) ;
                end ;
            end ;

         // Write to export file
         ExportFile.SaveADCBuffer( 0, RawFH.NumSamples, OutBuf^ ) ;


         // Report progress
         Main.StatusBar.SimpleText := format(
         ' EXPORT: Exporting record %d/%d to %s ',
         [iRec,EndAt,ExportFileName]) ;

         end ;

     // Close export data file
     ExportFile.CloseDataFile ;

     // Final Report
     Main.StatusBar.SimpleText := format(
     ' EXPORT: %d records exported to %s ',
     [EndAt-StartAt+1,ExportFileName]) ;
     WriteToLogFile( Main.StatusBar.SimpleText ) ;

     Finally
        // Free allocated buffers
        FreeMem( InBuf ) ;
        FreeMem( OutBuf ) ;
        end ;

     end;


procedure TExportFrm.bChangeNameClick(Sender: TObject);
{ ------------------------------------------
  Change name/location of export destination
  ------------------------------------------ }
begin
     SaveDialog.DefaultExt := ExtractFileExt( ExportFileName ) ;
     SaveDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     SaveDialog.Filter := ' Files (*' + SaveDialog.DefaultExt + ')|*' +
                            SaveDialog.DefaultExt + '|' ;

     SaveDialog.FileName := ExportFileName ;
     SaveDialog.Title := 'Export File ' ;
     if Settings.DataDirectory <> '' then
        SaveDialog.InitialDir := Settings.DataDirectory ;

     if SaveDialog.Execute then ExportFileName := SaveDialog.FileName ;
     edFileName.text := ExportFileName ;
     end;


procedure TExportFrm.rbABFClick(Sender: TObject);
// ---------------------------------
// Axon Binary File option selected
// ---------------------------------
begin
     UpdateSettings ;
     ChannelsGrp.Enabled := False ;
     end;


procedure TExportFrm.rbLDTClick(Sender: TObject);
// ---------------------------------
// Qub data file option selected
// ---------------------------------
begin
     UpdateSettings ;
     ChannelsGrp.Enabled := True ;
     end;


procedure TExportFrm.rbCFSClick(Sender: TObject);
// ---------------------------------
// CED Filing System option selected
// ---------------------------------
begin
     UpdateSettings ;
     ChannelsGrp.Enabled := False ;
     end;


procedure TExportFrm.UpdateSettings ;
// ---------------------------------------------------
// Update control settings when export format changed
// ---------------------------------------------------
begin

     SetChannel( ckCh0, 0 ) ;
     SetChannel( ckCh1, 1 ) ;
     SetChannel( ckCh2, 2 ) ;
     SetChannel( ckCh3, 3 ) ;
     SetChannel( ckCh4, 4 ) ;
     SetChannel( ckCh5, 5 ) ;
     SetChannel( ckCh6, 6 ) ;
     SetChannel( ckCh7, 7 ) ;

     if rbABF.Checked then ExportFileName := ChangeFileExt( ExportFileName, '.abf' ) ;
     if rbCFS.Checked then ExportFileName := ChangeFileExt( ExportFileName, '.cfs' ) ;
     if rbASCII.Checked then ExportFileName := ChangeFileExt( ExportFileName, '.txt' ) ;
     if rbEDR.Checked then ExportFileName := ChangeFileExt( ExportFileName, '.edr' ) ;
     if rbWCP.Checked then begin
        ExportFileName := ChangeFileExt( ExportFileName, '.wcp' ) ;
        if LowerCase(ExportFileName) = LowerCase(RawFH.FileName) then begin
           ExportFileName := StringReplace( ExportFileName,
                                            '.wcp',
                                            '(1).wcp',
                                            [rfIgnoreCase] ) ;
           end ;
        end ;
     edFileName.text := ExportFileName ;
     end ;


procedure TExportFrm.rbASCIIClick(Sender: TObject);
// ---------------------------------
// ASCII text file option selected
// ---------------------------------
begin
     UpdateSettings ;
     ChannelsGrp.Enabled := False ;
     end;


procedure TExportFrm.rbEDRClick(Sender: TObject);
// ---------------------------------
// WinEDR file option selected
// ---------------------------------
begin
     UpdateSettings ;
     ChannelsGrp.Enabled := False ;
     end;

procedure TExportFrm.rbWCPClick(Sender: TObject);
// ---------------------------------
// Axon Binary File option selected
// ---------------------------------
begin
     UpdateSettings ;
     ChannelsGrp.Enabled := False ;
     end;

end.
