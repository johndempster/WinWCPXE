unit Replay;
{ ================================================
  WinWCP View Records module (c) J. Dempster 1996-97
  Lets users view sets of signals records on screen
  2/5/97 ... Channel names on display and print-out                  ec0
             now only displayed when channel enabled
  12/6/97 ... COPY DATA Buffer overflow fixed
  16/6/97 ... Cursor can now be written to log file
              C1-C0 relative cursor mode added
  25/8/97 ... Size of mmCursor box adjusted,
              number format reduced to 3 sign. figs.
  31/8/97 ... Short cut keys for setting record type
  10/9/97 ... Active record now only displayed once (V1.7c)
  24/2/98 ... +/- keys now step forward/back records
              Accepted/Rejected and Record Type no longer accidentally
              changed by short cut keys.
  2/4/98 .... Cursor readout now displays both absolute and C1-C0 readings
  11/7/99 ... V3.0 32 bit version
  4/9/99 ... Display grid added
  22/10/99 ... ScopeDisplay zero levels now updated before CopyDataToClipboard call
  3/11/99 ... NewFile now closes form in no records available
  28/11/00 ... Centre cursor button added
  21/5/01 ... Ctrl+1,2,3 shortcuts for TYP1, TYP2, TYP3 added
  17/7/01 ... Signal difference between Readout-t0 cursors added
  29/8/01 ... Fixed zero level now saved when changed
              From Record zero area indicated by pair of small vertical bars
  23/10/01 ... NewFile modified to zoom display horizontally
               to full extent of record when no. samples/record changed.
  3/12/01 ... NewFile now retains displayed record number position
  4/12/01 ... Save Cursor now saves data to log file in tab formatted table
  19/3/02 ... Channel Units/div information added to display
  6.6.02 ... Display cursor readout now displayed using CursorLabel component
  24.6.03 ... No. of display grid lines can be changed
  01.01.04 .. Out of memory error blocked when windows resized to tiny size
  11.12.04 .. C-C0 Cursor differences now displayed with absolute values
  01.03.07 .. HeapBuffers removed ADC now static allocation in Private
  07.06.13 .. FH.NumZeroAvg now updated when changed in ZeroFrm
  25.07.13 .. Form size and location when opened now set in FormShow
  01.08.13 .. Updated to compile with Delphi XE
              Display Record now set to start of file in NewFile().
              ADC now allocated by GetMem()
  27.08.13 .. Time of day when record acquired now displayed
  23.09.13 .. Recording start time now encoded in en-GB format
  18.11.15 .. TReplayCursors.Base removed since use was redundant.
  12.01.17 .. .VerticalCursors() now single type and converted to integer by round()
  26.05.22 .. ZeroFrm now settings Channel record zero level settings directly
  ===================================================}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Zero, ClipBrd,
  PrintRec,Printers, {PlotLib,} menus, maths, Grids, RangeEdit, ValEdit,
  ScopeDisplay, ComCtrls, CursorLabel, ValidatedEdit, HTMLLabel, seslabio, math, dateutils, WCPFIleUnit ;

type

  TReplayCursors = record
             //Base : Array[0..MaxChannels-1] of Integer ;
             C0 : Integer ;
             C1 : Integer ;
             Value : Array[0..MaxChannels*2] of Single ;
             Diff : Array[0..MaxChannels*2] of Single ;
             end ;

  TReplayFrm = class(TForm)
    CursorGrp: TGroupBox;
    RecordGrp: TGroupBox;
    Label2: TLabel;
    cbRecordType: TComboBox;
    ckBadRecord: TCheckBox;
    sbRecordNum: TScrollBar;
    Label1: TLabel;
    Group: TLabel;
    FilterGrp: TGroupBox;
    edIdent: TEdit;
    Label3: TLabel;
    bSaveCursor: TButton;
    edRecordNum: TRangeEdit;
    edLPFilter: TValidatedEdit;
    lbLPFilter: TLabel;
    ckLPFilterInUse: TCheckBox;
    scDisplay: TScopeDisplay;
    bFindCursor: TButton;
    ZeroGrp: TGroupBox;
    rbBaseline: TRadioButton;
    rbUseC0CursorasZero: TRadioButton;
    Button1: TButton;
    EdRecordIdent: TEdit;
    edGroup: TValidatedEdit;
    Label4: TLabel;
    ckFixedZeroLevels: TCheckBox;
    metime: TMemo;
    procedure FormResize(Sender: TObject);
    procedure sbRecordNumChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edRecordNumKeyPress(Sender: TObject; var Key: Char);
    procedure ckBadRecordClick(Sender: TObject);
    procedure cbRecordTypeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bSaveCursorClick(Sender: TObject);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure edGroupKeyPress(Sender: TObject; var Key: Char);
    procedure scDisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure ckLPFilterInUseClick(Sender: TObject);
    procedure edLPFilterKeyPress(Sender: TObject; var Key: Char);
    procedure bFindCursorClick(Sender: TObject);
    procedure EdRecordIdentKeyPress(Sender: TObject; var Key: Char);
    procedure rbUseBaselineZeroClick(Sender: TObject);
    procedure rbBaselineClick(Sender: TObject);
    procedure rbUseC0CursorasZeroClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edIdentKeyPress(Sender: TObject; var Key: Char);
    procedure EdRecordIdentChange(Sender: TObject);
    procedure ckFixedZeroLevelsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
   Cursors : TReplaycursors ;
   RH : TRecHeader ;      // Signal record header block }
   ADC : PSmallIntArray ; // A/D data buffer
   FirstSave : Boolean ;
   IdentChanged : Boolean ; // File ident line changed flag

    procedure DisplayRecord ;
    procedure SaveCursorReading ;
    procedure AddVerticalCursors ;
  public
    { Public declarations }
   procedure NewFile ;
   procedure ZoomOutAll ;
   procedure ZoomIn( ChanNum : Integer ) ;
   procedure ZoomOut( ChanNum : Integer ) ;
   procedure ChangeDisplayGrid ;
   procedure CopyDataToClipboard ;
   procedure CopyImageToClipboard ;
   procedure Print ;
   procedure SetStoreMode( StorageMode : Boolean ) ;
  end;


var
  ReplayFrm: TReplayFrm;

implementation

uses          MDIForm,copyrec ;

{$R *.DFM}


procedure TReplayFrm.FormShow(Sender: TObject);
{ ---------------------------------------
  Initialisations done when form is shown
  ---------------------------------------}
begin

     // Set position of form
     Left := 20 ;
     Top := 20 ;
     Height := Main.StatusBar.Top - Top - 10 ;
     Width := Main.ClientWidth - Left - 20 ;

     cbRecordType.items := WCPFile.RecordTypes ;
     cbRecordType.items.delete(0) ; {Remove 'ALL' item}

     SetStoreMode(Main.mnStoreTraces.Checked) ;

     Cursors.C0 := -1 ;
     Cursors.C1 := -1 ;

     IdentChanged := False ;

     NewFile ;

     end ;


procedure TReplayFrm.NewFile ;
{ ------------------------------------------------
  Initialise display routines for a new data file
  ------------------------------------------------ }
var
   ch,OldNumSamples : Integer ;
begin

     // Reallocate A/D sample buffer
     if ADC <> Nil then FreeMem(ADC) ;
     GetMem( ADC, Max(WCPFile.FH.NumSamples*WCPFile.FH.NumChannels*2,1024) ) ;

     // Update log if file ident changed
     if IdentChanged then begin
        WCPFile.FH.IdentLine := edIdent.text ;
        WCPFile.RawFH.IdentLine := EdIdent.text ;
        WCPFile.SaveHeader(WCPFile.FH) ;
        WCPFile.SaveHeader(WCPFile.FH) ;
        WCPFile.WriteToLogFile( format('File ident changed to %s',[WCPFile.FH.IdentLine])) ;
        IdentChanged := False ;
        end ;

     if WCPFile.FH.NumRecords > 0 then begin
        Caption := Main.UpdateCaption( WCPFile.FH, 'View ' ) ;

        EdIdent.text := WCPFile.FH.IdentLine ;

        WCPFile.FH.RecordNum := 1 ;
        WCPFile.UpdateScrollBar( sbRecordNum, WCPFile.FH.RecordNum, 1, WCPFile.fH.NumRecords ) ;

        edRecordNum.LoLimit := 1 ;
        edRecordNum.HiLimit := WCPFile.FH.NumRecords ;
        edRecordNum.LoValue := 1 ;
        edRecordNum.HiValue := WCPFile.FH.NumRecords ;

        { Create horizontal cursors }
        scDisplay.ClearHorizontalCursors ;
        for ch := 0 to WCPFile.FH.NumChannels-1 do
            scDisplay.AddHorizontalCursor(ch,clGreen,True,'z') ;

        { Continuous record display channel }
        scDisplay.MaxADCValue := WCPFile.RawFH.MaxADCValue ;
        scDisplay.MinADCValue := WCPFile.RawFH.MinADCValue ;
        scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;
        OldNumSamples := scDisplay.MaxPoints ;
        scDisplay.MaxPoints := WCPFile.FH.NumSamples ;
        scDisplay.NumPoints := scDisplay.MaxPoints ;
        scDisplay.NumChannels := WCPFile.FH.NumChannels ;

        if OldNumSamples <> WCPFile.FH.NumSamples then begin
             WCPFile.Channel[0].xMin := 0 ;
             WCPFile.Channel[0].xMax := WCPFile.FH.NumSamples ;
             end ;

        scDisplay.xMax := Min(Round(WCPFile.Channel[0].xMax),WCPFile.FH.NumSamples-1)  ;
        scDisplay.xMin := Min(Round(WCPFile.Channel[0].xMin),scDisplay.xMax) ;
        if scDisplay.xMin = scDisplay.xMax then begin
           scDisplay.xMin := 0 ;
           scDisplay.xMax := WCPFile.FH.NumSamples-1 ;
           end ;

        // Add vertical cursors to display
        AddVerticalCursors ;

        { Initial settings of display }

        for ch := 0 to WCPFile.FH.NumChannels-1 do begin
            scDisplay.ChanUnits[ch] := WCPFile.Channel[ch].ADCUnits ;
            scDisplay.ChanName[ch] := WCPFile.Channel[ch].ADCName ;
            scDisplay.ChanScale[ch] := WCPFile.Channel[ch].ADCScale ;
            scDisplay.ChanUnits[ch] := WCPFile.Channel[ch].ADCUnits ;
            scDisplay.ChanZero[ch] := WCPFile.Channel[ch].ADCZero ;
            scDisplay.ChanZeroAt[ch] := WCPFile.Channel[ch].ADCZeroAt ;
            scDisplay.ChanOffsets[ch] := WCPFile.Channel[ch].ChannelOffset ;
            scDisplay.yMin[ch] := WCPFile.Channel[ch].yMin ;
            scDisplay.yMax[ch] := WCPFile.Channel[ch].yMax ;
            scDisplay.ChanVisible[ch] := WCPFile.Channel[ch].InUse ;
            scDisplay.ChanColor[ch] := clBlue ;
            end ;
        scDisplay.ChanZeroAvg := WCPFile.FH.NumZeroAvg ;

        scDisplay.SetDataBuf( ADC ) ;
        SetStoreMode( Main.mnStoreTraces.Checked ) ;


        DisplayRecord ;

        // Request title line to be written
        // if cursor data is saved to log file
        FirstSave := True ;

        end
     else Close ;

    end;

procedure TReplayFrm.AddVerticalCursors ;
// -------------------------------
// Add vertical cursors to display
// -------------------------------
var
    OldC0,OldC1 : Integer ;
begin

     // Get old cursor positions
     if Cursors.C0 >= 0 then OldC0 := Round(scDisplay.VerticalCursors[Cursors.C0])
                        else OldC0 := 0 ;
     if Cursors.C1 >= 0 then OldC1 := Round(scDisplay.VerticalCursors[Cursors.C1])
                        else OldC1 := Round((scDisplay.xMin + scDisplay.xMax)*0.5) ;

     { Create and initialise vertical cursors }
     scDisplay.ClearVerticalCursors ;
     Cursors.C0 := scDisplay.AddVerticalCursor(AllChannels,clGreen,'c0') ;
     if rbUseC0CursorasZero.Checked then begin
        Cursors.C1 := scDisplay.AddVerticalCursor(AllChannels,clGreen,'?t0?y0') ;
        end
     else begin
        Cursors.C1 := scDisplay.AddVerticalCursor(AllChannels,clGreen,'?t?y') ;
        end ;

     // Initial cursor positions
     scDisplay.VerticalCursors[Cursors.C0] := OldC0 ;
     scDisplay.VerticalCursors[Cursors.C1] := OldC1 ;

     end ;


procedure TReplayFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
var
    ch : Integer ;

begin
     scDisplay.MaxADCValue := WCPFile.RawFH.MaxADCValue ;
     scDisplay.MinADCValue := WCPFile.RawFH.MinADCValue ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;

     for ch := 0 to scDisplay.NumChannels-1 do begin
         scDisplay.ChanVisible[ch] := WCPFile.Channel[ch].InUse ;
         end ;

     scDisplay.Invalidate ;
     end ;


procedure  TReplayFrm.ZoomOutAll ;
{ ---------------------------------
  Set minimum display magnification
  23/10/01
  --------------------------------- }
begin
     scDisplay.MaxADCValue := WCPFile.RawFH.MaxADCValue ;
     scDisplay.MinADCValue := WCPFile.RawFH.MinADCValue ;
     scDisplay.MaxPoints := WCPFile.FH.NumSamples ;
     scDisplay.NumPoints := scDisplay.MaxPoints ;
     scDisplay.NumChannels := WCPFile.FH.NumChannels ;

     scDisplay.ZoomOut ;
     WCPFile.Channel[0].xMin := scDisplay.xMin ;
     WCPFile.Channel[0].xMax := scDisplay.xMax ;

     end ;


procedure TReplayFrm.ZoomOut(
          ChanNum : Integer ) ;
// ------------------------------------
// Magnify selected A/D channel display
// ------------------------------------
begin
     scDisplay.YZoom( ChanNum, 50.0 ) ;
     end ;


procedure TReplayFrm.ZoomIn( ChanNum : Integer ) ;
// ------------------------------------
// Reduce selected A/D channel display
// ------------------------------------
begin
     scDisplay.YZoom( ChanNum, -50.0 ) ;
     end ;


procedure TReplayFrm.DisplayRecord ;
{ ========================================================
  Display digitised signal record on Page 0 of notebook
  ========================================================}
var
   ch : Integer ;
   StartTime : TDateTime ;
begin

     WCPFile.fH.RecordNum := SbRecordNum.position ;
     WCPFile.fH.CurrentRecord := SbRecordNum.position ;

     { Read record data from file }
     WCPFile.GetRecord( WCPFile.fH, RH, WCPFile.fH.RecordNum, ADC^ ) ;

     { Update low pass filter text box }
     if WCPFile.Settings.CutOffFrequency > 0.0 then begin
        ckLPFilterInUse.Checked := True ;
        edLPFilter.Visible := True ;
        lbLPFilter.Visible := True ;
        if RH.dt > 0.0 then edLPFilter.Scale := 1.0/RH.dt ;
        edLPFilter.Value := WCPFile.Settings.CutOffFrequency ;
        end
     else begin
        ckLPFilterInUse.Checked := False ;
        edLPFilter.Visible := False ;
        lbLPFilter.Visible := False ;
        end ;

     { Set horizontal zero baseline cursors }
     for ch := 0 to WCPFile.FH.NumChannels-1 do begin
         // Zero level
         scDisplay.HorizontalCursors[ch] := WCPFile.Channel[ch].ADCZero ;
         // Start of area from which zero level was computed (-1 indicates fixed zero level)
         scDisplay.ChanZeroAt[ch] := WCPFile.Channel[ch].ADCZeroAt ;
         // Signal scaling factor
         scDisplay.ChanScale[ch] := WCPFile.Channel[ch].ADCScale ;
         end ;
     // No. of samples in zero level area
     scDisplay.ChanZeroAvg := WCPFile.FH.NumZeroAvg ;

     { Show whether record has been rejected by operator }
     if RH.Status = 'ACCEPTED' then ckBadRecord.checked := False
                               else ckBadRecord.checked := True ;

     { Show type of record }
     if cbRecordType.items.indexOf(RH.RecType) >= 0 then
        cbRecordType.ItemIndex := cbRecordType.items.indexOf(RH.RecType);
      meTime.Clear ;
      meTime.Lines.Add('') ;
      meTime.Lines[0] := format('%.3fs',[RH.Time]) ;
     if WCPFile.FH.RecordingStartTimeSecs > 0.0 then begin
        StartTime := Main.StrToDate( WCPFile.FH.RecordingStartTime ) ;
        StartTime := System.DateUtils.IncMillisecond(StartTime,Round(RH.Time*1000.0)) ;
        meTime.Lines[1] := FormatDateTime('hh:mm:ss.zzz',StartTime) ;
        end ;

     edGroup.Value := RH.Number ;
     edRecordIdent.Text := RH.Ident ;

     { Update record number display }
     edRecordNum.HiValue := WCPFile.fH.NumRecords ;
     edRecordNum.LoValue := sbRecordNum.position ;

     { Continuous record display channel }
     scDisplay.TScale := RH.dt*WCPFile.Settings.TScale ;
     scDisplay.TUnits := WCPFile.Settings.TUnits ;
     scDisplay.RecordNumber := WCPFile.fH.RecordNum ;
     scDisplay.Invalidate ;
     end ;


procedure TReplayFrm.sbRecordNumChange(Sender: TObject);
{ ------------------------------------------------------------------
  If the record number has changed ask for the display to be updated
  ------------------------------------------------------------------ }
begin
     DisplayRecord ;
     end;


procedure TReplayFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{ ------------------------
  Function key processing
  31/8/97 ... Short cut keys for setting record type
  -----------------------}
begin
     case key of
          VK_LEFT : scDisplay.MoveActiveVerticalCursor(-1) ;
          VK_RIGHT : scDisplay.MoveActiveVerticalCursor(1) ;
          VK_SUBTRACT : begin { - key }
                if sbRecordNum.Position > sbRecordNum.Min then begin
                   sbRecordNum.Position := sbRecordNum.Position - 1 ;
                   DisplayRecord ;
                   end ;
                end ;
          VK_ADD : begin { + key }
                if sbRecordNum.Position < sbRecordNum.Max then begin
                   sbRecordNum.Position := sbRecordNum.Position + 1 ;
                   DisplayRecord ;
                   end ;
                end ;
          VK_F1 : begin
             SaveCursorReading ;
             end ;

          $31, $32, $33, $54,$4c,$45,$4d,$46  : begin
               if (Shift = [ssCtrl]) then begin
                  { Update record type }
                  case Key of
                     $31 : cbRecordType.ItemIndex := cbRecordType.Items.IndexOf('TYP1') ;
                     $32 : cbRecordType.ItemIndex := cbRecordType.Items.IndexOf('TYP2') ;
                     $33 : cbRecordType.ItemIndex := cbRecordType.Items.IndexOf('TYP3') ;
                     $54 : cbRecordType.ItemIndex := cbRecordType.Items.IndexOf('TEST') ;
                     $4c : cbRecordType.ItemIndex := cbRecordType.Items.IndexOf('LEAK') ;
                     $45 : cbRecordType.ItemIndex := cbRecordType.Items.IndexOf('EVOK') ;
                     $4d : cbRecordType.ItemIndex := cbRecordType.Items.IndexOf('MINI') ;
                     $46 : cbRecordType.ItemIndex := cbRecordType.Items.IndexOf('FAIL') ;
                     end ;
                  RH.RecType := cbRecordType.text ;
                  WCPFile.PutRecordHeaderOnly( WCPFile.fH, RH, WCPFile.fH.RecordNum ) ;
                  end ;
               end ;
          $52 : begin
               if (Shift = [ssCtrl]) then begin
                  ckBadRecord.Checked := not ckBadRecord.Checked ;
                  If ckBadRecord.Checked then RH.Status := 'REJECTED'
                                         else RH.Status := 'ACCEPTED' ;
                  WCPFile.PutRecordHeaderOnly( WCPFile.fH, RH, WCPFile.fH.RecordNum ) ;
                  end;
               end ;
          end ;

     end;


procedure TReplayFrm.edRecordNumKeyPress(Sender: TObject; var Key: Char);
{ ------------------------------------
  Go to record number entered by user
  -----------------------------------}
begin
     if key = chr(13) then begin
        sbRecordNum.Position := Round(edRecordNum.LoValue) ;
        edRecordNum.HiValue := WCPFile.FH.NumRecords ;
        DisplayRecord ;
        end ;
     end;


procedure TReplayFrm.ckBadRecordClick(Sender: TObject);
{ ------------------------------------------------
  Save new record ACCEPTED/REJECTED status to file
  ------------------------------------------------}
begin
     if ckBadRecord.checked then RH.Status := 'REJECTED'
                            else RH.Status := 'ACCEPTED' ;
     WCPFile.PutRecordHeaderOnly( WCPFile.fH, RH, WCPFile.fH.RecordNum ) ;
     end;


procedure TReplayFrm.cbRecordTypeChange(Sender: TObject);
{ -----------------------------
  Save new record type to file
  ----------------------------}
begin
     RH.RecType := cbRecordType.text ;
     WCPFile.PutRecordHeaderOnly( WCPFile.fH, RH, WCPFile.fH.RecordNum ) ;
     end;


procedure TReplayFrm.CopyDataToClipboard ;
{ -----------------------------------------------------------
  Copy the data in currently displayed graph to the clipboard
  -----------------------------------------------------------}
begin
     scDisplay.CopyDataToClipboard ;
     end ;


procedure TReplayFrm.Print ;
{ ---------------------------------------------
  Print the currently displayed graph or table
  --------------------------------------------- }
begin
     PrintRecFrm.Destination := dePrinter ;
     PrintRecFrm.DisplayObj := scDisplay ;
     PrintRecFrm.ShowModal ;
     if PrintRecFrm.ModalResult = mrOK then begin
        scDisplay.ClearPrinterTitle ;
        scDisplay.AddPrinterTitleLine( 'File : ' + WCPFile.FH.FileName ) ;
        scDisplay.AddPrinterTitleLine( WCPFile.FH.IdentLine ) ;
        scDisplay.Print ;
        end ;
     end ;


procedure TReplayFrm.CopyImageToClipboard ;
{ -----------------------------------------------------
  Copy active plot to clipboard as Windows metafile
  ----------------------------------------------------- }
begin
     { Copy record on display }
     PrintRecFrm.Destination := deClipboard ;
     PrintRecFrm.DisplayObj := scDisplay ;
     PrintRecFrm.ShowModal ;
     if PrintRecFrm.ModalResult = mrOK then begin
        scDisplay.ClearPrinterTitle ;
        scDisplay.AddPrinterTitleLine( 'File : ' + WCPFile.FH.FileName ) ;
        scDisplay.AddPrinterTitleLine( WCPFile.FH.IdentLine ) ;
        scDisplay.CopyImageToClipboard ;
        end ;
     end ;


procedure TReplayFrm.SetStoreMode(
          StorageMode : Boolean
          ) ;
{ --------------------------------------------
  Set oscilloscope display storage mode on/off
  -------------------------------------------- }
begin
     scDisplay.StorageMode := StorageMode ;
     end ;


procedure TReplayFrm.bSaveCursorClick(Sender: TObject);
begin
    SaveCursorReading ;
    end ;


procedure TReplayFrm.SaveCursorReading ;
{ ------------------------------------------------
  Save the current cursor reading to the log file
  -----------------------------------------------}
var
   s : string ;
   ch : Integer ;
   Cursor0Pos, Cursor1Pos : Integer ;
   y : Single ;
begin

     // Write title line
     if FirstSave then begin
        // Column names
        s := 'Rec' + #9 + 'T' ;
        if rbUseC0CursorasZero.Checked then s:= s + #9 + 'Diff' ;
        for ch := 0 to scDisplay.NumChannels-1 do if scDisplay.ChanVisible[ch] then begin
            s := s + #9 + WCPFile.Channel[ch].ADCName ;
            if rbUseC0CursorasZero.Checked then s := s + #9 + 'Diff';
            end ;
        WCPFile.WriteToLogFileNoDate( s ) ;
        // Column units
        s := #9 + WCPFile.Settings.TUnits ;
        if rbUseC0CursorasZero.Checked then s := s + #9 + WCPFile.Settings.TUnits ;
        for ch := 0 to scDisplay.NumChannels-1 do if scDisplay.ChanVisible[ch] then begin
            s := s + #9 + WCPFile.Channel[ch].ADCUnits ;
            if rbUseC0CursorasZero.Checked then s := s + #9 + WCPFile.Channel[ch].ADCUnits ;
            end ;
        WCPFile.WriteToLogFileNoDate( s ) ;
        FirstSave := False ;
        end ;

     // Write data
     s := format('%d',[WCPFile.FH.RecordNum] ) ;

     { Time zero cursor }
     Cursor0Pos := Round(scDisplay.VerticalCursors[Cursors.C0]) ;
     Cursor1Pos := Round(scDisplay.VerticalCursors[Cursors.C1]) ;

     // Time values
     if rbUseC0CursorasZero.Checked then begin
        s := s + #9 + format( '%.5g',
                         [(Cursor1Pos-Cursor0Pos)*RH.dt*WCPFile.Settings.TScale]) ;
        end
     else begin
        s := s + #9 + format( '%.5g',
                         [(Cursor1Pos)*RH.dt*WCPFile.Settings.TScale]) ;
        end ;

     for ch := 0 to scDisplay.NumChannels-1 do if scDisplay.ChanVisible[ch] then begin
         // Signal level at readout cursor
         if rbUseC0CursorasZero.Checked then begin
            y := scDisplay.ChanScale[ch] *
                 ( ADC^[(Cursor1Pos*WCPFile.FH.NumChannels)+WCPFile.Channel[ch].ChannelOffset] -
                   ADC^[(Cursor0Pos*WCPFile.FH.NumChannels)+WCPFile.Channel[ch].ChannelOffset]) ;
            end
         else begin
            y := scDisplay.ChanScale[ch]*
                 ( ADC^[(Cursor1Pos*WCPFile.FH.NumChannels)+WCPFile.Channel[ch].ChannelOffset]
                        - scDisplay.HorizontalCursors[ch] ) ;
            end ;

         // Add to readout list
         s := s + #9 + format( '%.5g ',[y] );
         end ;

     WCPFile.WriteToLogFileNoDate( s ) ;

     end;


procedure TReplayFrm.FormResize(Sender: TObject);
{ ---------------------------
  Re-size components on form
  --------------------------}
begin

     scDisplay.left := RecordGrp.Left + RecordGrp.width + 5 ;
     scDisplay.width := MaxInt( [ClientWidth - scDisplay.left - 5,2]) ;
     scDisplay.top := EdIdent.Top + EdIdent.Height + 2 ;

     ckFixedZeroLevels.Left := scDisplay.left ;
     ckFixedZeroLevels.Top := ClientHeight - 5 - ckFixedZeroLevels.Height ;
     scDisplay.Height := Max( ckFixedZeroLevels.Top - scDisplay.Top -1,2) ;

     // Adjust width of ident boxes to match display area
     edIdent.Width := ClientWidth  - edIdent.Left - 5 ;


     end;


procedure TReplayFrm.scDisplayCursorChange(Sender: TObject);
{ -------------------------------------
  Update cursor labels when mouse moved
  -------------------------------------
  17/7/01 Signal difference between Readout-t0 cursors added }
var
   ch : Integer ;
begin

     if not TScopeDisplay(Sender).CursorChangeInProgress then begin
        TScopeDisplay(Sender).CursorChangeInProgress := True ;

        { Update channel descriptors with any changes to display }
        for ch := 0 to scDisplay.NumChannels-1 do begin
            WCPFile.Channel[ch].InUse := scDisplay.ChanVisible[ch] ;

            if WCPFile.Channel[ch].InUse then
               begin
               WCPFile.Channel[Ch].yMin := scDisplay.YMin[Ch] ;
               WCPFile.Channel[Ch].yMax := scDisplay.YMax[Ch] ;

               { Get signal baseline cursor }
               if WCPFile.Settings.FixedZeroLevels or (WCPFile.Channel[ch].ADCZeroAt >= 0) then
                  begin
                  if scDisplay.HorizontalCursors[ch] <> WCPFile.Channel[ch].ADCZero then
                     begin
                     scDisplay.HorizontalCursors[ch] := WCPFile.Channel[ch].ADCZero ;
                     end ;
                  end
               else
                  begin
                  WCPFile.Channel[ch].ADCZero := Round(scDisplay.HorizontalCursors[ch]) ;
                  end;
               end ;
            end ;
        WCPFile.Channel[0].xMin := scDisplay.xMin ;
        WCPFile.Channel[0].xMax := scDisplay.xMax ;

        TScopeDisplay(Sender).CursorChangeInProgress := False ;
        end ;
     end ;


procedure TReplayFrm.edGroupKeyPress(Sender: TObject; var Key: Char);
{ ------------------------------------
  Save new record group number to file
  ------------------------------------}
begin
     if Key = #13 then begin
        RH.Number := Round( Edgroup.Value ) ;
        WCPFile.PutRecordHeaderOnly( WCPFile.fH, RH, WCPFile.fH.RecordNum ) ;
        end ;
     end;


procedure TReplayFrm.scDisplayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{ ---------------------------
  Display zero level mode box
  --------------------------- }
begin

     if (Button = mbRight) and (scDisplay.ActiveHorizontalCursor >=0) then begin
        // If right-mouse button down, display zero baseline level selection dialog box
        ZeroFrm.EnableFromRecord := True ;
        ZeroFrm.Chan := scDisplay.ActiveHorizontalCursor ;
        ZeroFrm.NewZeroAt := Round(scDisplay.ScreenCoordToX( ZeroFrm.Chan, X )) ;
        ZeroFrm. NumSamplesPerRecord := scDisplay.NumPoints ;
        ZeroFrm.Left := Self.Left + Main.Left + 10 + scDisplay.Left + X;
        ZeroFrm.Top := Self.Top + Main.Top + 10 + scDisplay.Top + Y ;
        ZeroFrm.ShowModal ;
        scDisplay.HorizontalCursors[ZeroFrm.Chan] := WCPFile.Channel[ZeroFrm.Chan].ADCZero ;
        if ZeroFrm.ModalResult = mrOK then DisplayRecord ;
        end
     else begin
        // Update zero baseline cursor
        if scDisplay.ActiveHorizontalCursor >= 0 then begin
           if WCPFile.Channel[scDisplay.ActiveHorizontalCursor].ADCZeroAt < 0 then begin
              // Fixed baseline level (update zero level to new position)
              if not WCPFile.Settings.FixedZeroLevels then begin
                 WCPFile.Channel[scDisplay.ActiveHorizontalCursor].ADCZero := Round(
                 scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor]) ;
                 end ;
              end
           else begin
              // Baseline level computed from record (return to computed level)
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor] :=
              WCPFile.Channel[scDisplay.ActiveHorizontalCursor].ADCZero ;
              scDisplay.Invalidate ;
              end ;
           WCPFile.SaveHeader( WCPFile.FH ) ;
           end ;
        end ;
     edGroup.SetFocus ;
     end ;


procedure TReplayFrm.FormClose(Sender: TObject; var Action: TCloseAction);
// ---------------------------
// Tidy up when form is closed
// ---------------------------
begin

     // Update log if file ident changed
     if IdentChanged then begin
        WCPFile.FH.IdentLine := edIdent.text ;
        WCPFile.RawFH.IdentLine := EdIdent.text ;
        WCPFile.SaveHeader(WCPFile.FH) ;
        WCPFile.SaveHeader(WCPFile.RawFH) ;
        WCPFile.WriteToLogFile( format('File ident changedto %s',[WCPFile.FH.IdentLine])) ;
        IdentChanged := False ;
        end ;

     Action := caFree ;

     end;


procedure TReplayFrm.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin
    ADC := Nil ;
    end;

procedure TReplayFrm.FormDestroy(Sender: TObject);
// ------------------------------
// Tidy up when form is destroyed
// ------------------------------
begin
    if ADC <> Nil then FreeMem(ADC) ;
    end;

procedure TReplayFrm.FormActivate(Sender: TObject);
begin

     ckFixedZeroLevels.Checked := WCPFile.Settings.FixedZeroLevels ;

     // Ensure display channels visibility is updated
     ChangeDisplayGrid ;
     { Enable copy and print menus }
     DisplayRecord ;
     end;


procedure TReplayFrm.ckLPFilterInUseClick(Sender: TObject);
{ ----------------------------------
  Enable/disable Low Pass filtering
  ---------------------------------- }
begin
     { Note. Settings.CutOffFrequency=0 indicates no filtering }
     if ckLPFilterInUse.Checked
        and (WCPFile.Settings.CutOffFrequency <= 0.0) then WCPFile.Settings.CutOffFrequency := 0.1
                                                      else WCPFile.Settings.CutOffFrequency := 0.0 ;
     DisplayRecord ;
     end;


procedure TReplayFrm.edLPFilterKeyPress(Sender: TObject; var Key: Char);
// ----------------------------------------------
// Update low-pass filter cut-off when CR pressed
// ----------------------------------------------
begin
     if key = chr(13) then begin
        WCPFile.Settings.CutOffFrequency := edLPFilter.Value ;
        DisplayRecord ;
        end ;
     end;


procedure TReplayFrm.bFindCursorClick(Sender: TObject);
// -------------------------------------
// Bring readout cursor to screen centre
// -------------------------------------
begin
     scDisplay.VerticalCursors[Cursors.C1] := (scDisplay.xMin + scDisplay.xMax) div 2 ;
     end;


procedure TReplayFrm.EdRecordIdentKeyPress(Sender: TObject; var Key: Char);
// ------------------------------
// Update experiment ident record
// ------------------------------
begin

        WCPFile.WriteToLogFile( format('Rec %d: Marker changed %s to %s',
                        [WCPFile.fH.RecordNum,RH.Ident,EdRecordIdent.text])) ;
        RH.Ident := EdRecordIdent.text ;
        WCPFile.PutRecordHeaderOnly( WCPFile.fH, RH, WCPFile.fH.RecordNum ) ;

     end;


procedure TReplayFrm.rbUseBaselineZeroClick(Sender: TObject);
// ---------------------------
// Zero reference mode changed
// ---------------------------
begin
     // Re-display record to force update of cursor reading
     DisplayRecord ;
     end;


procedure TReplayFrm.rbBaselineClick(Sender: TObject);
//
// Toggle Display of cursor differences
begin
     // Refresh display
     AddVerticalCursors ;
     scDisplay.Invalidate ;
     end;


procedure TReplayFrm.rbUseC0CursorasZeroClick(Sender: TObject);
//
// Toggle Display of cursor differences
begin
     // Refresh display
     AddVerticalCursors ;
     scDisplay.Invalidate ;
     end;


procedure TReplayFrm.Button1Click(Sender: TObject);
// -------------------------------------
// Bring c0 cursor to screen
// -------------------------------------
begin
     scDisplay.VerticalCursors[Cursors.C0] := scDisplay.xMin +
                                            (scDisplay.xMax - scDisplay.xMin) div 10 ;
     end;

procedure TReplayFrm.edIdentKeyPress(Sender: TObject; var Key: Char);
// -----------------------
// File ident line changed
// -----------------------
begin
     IdentChanged := True ;
     end;

procedure TReplayFrm.EdRecordIdentChange(Sender: TObject);
// -------------------------
// Record ident text changed
// -------------------------
begin
     RH.Ident := EdRecordIdent.text ;
     WCPFile.PutRecordHeaderOnly( WCPFile.fH, RH, WCPFile.fH.RecordNum ) ;
     end;


procedure TReplayFrm.ckFixedZeroLevelsClick(Sender: TObject);
// --------------------------------
// Enable/Disable fixed zero levels
// --------------------------------
begin
     WCPFile.Settings.FixedZeroLevels := ckFixedZeroLevels.Checked ;
     end;

end.





