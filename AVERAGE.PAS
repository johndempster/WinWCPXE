unit Average;
{ ==========================================================================
  WinWCP - Signal averaging module (c) J Dempster, 1996, All Rights Reserved
  V1.7a ... 1/9/97 Averaging EndOfBlock bug fixed
            Zero divide error when all of first block is rejected fixed
  V2.3a ... 24/6/99 Records used in average now listed in record indent field
  V3.0  ... 8/7/99 32 bit versions
  4/9/99 ... Display grid added
  30/10/99 ... NewFile method added
  3/11/99 ... NewFile now closes form in no records available
  29/8/01 ... Fixed zero level now saved when changed
  3/12/01 ... NewFile now retains displayed record number position
  4/12/01 ... MaxTBuf (in global.pas) increased to 32767 to avoid problems
              with averaging large records
              Channels nows displayed in correct order
  29/4/02 ... Progress now reported on status bar
  24.6.03 ... No. of display grid lines can be changed
  01.01.04 .. Out of memory error blocked when windows resized to tiny size
  22.05.05 .. Only channels selected for display now displayed in averaging window
  02.12.06 .. Only channel selected for display in View menu now displayed in average display
              Buffers now static allocation
  07.06.13 .. FH.NumZeroAvg now updated when changed in ZeroFrm
  09.08.13 .. ADC,Buf now allocated by GetMem()
  ========================================================================== }
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Global, Shared, FileIo, maths,
  ValEdit, RangeEdit, ScopeDisplay, ComCtrls, ValidatedEdit, math, seslabio ;

type
  TAvgFrm = class(TForm)
    RecordGrp: TGroupBox;
    Label2: TLabel;
    cbRecordType: TComboBox;
    ckBadRecord: TCheckBox;
    sbRecordNum: TScrollBar;
    AverageGrp: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    bDoAverages: TButton;
    cbRecTypeToBeAveraged: TComboBox;
    Label6: TLabel;
    bAbort: TButton;
    cbAlignMode: TComboBox;
    Label8: TLabel;
    edRange: TRangeEdit;
    edBlockSize: TValidatedEdit;
    edRecordNum: TRangeEdit;
    scDisplay: TScopeDisplay;
    ckFixedZeroLevels: TCheckBox;
    procedure sbRecordNumChange(Sender: TObject);
    procedure bDoAveragesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ckBadRecordClick(Sender: TObject);
    procedure cbRecordTypeChange(Sender: TObject);
    procedure bAbortClick(Sender: TObject);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure scDisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ckFixedZeroLevelsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure DisplayRecord ;
  public
    { Public declarations }
    procedure ChangeDisplayGrid ;
    procedure ZoomOut ;
    procedure NewFile ;
  end;


var
  AvgFrm: TAvgFrm;

implementation

uses MDIform, Replay, Zero ;

{$R *.DFM}
const
     NoAlignment = 0 ;
     OnPositiveRise = 1 ;
     OnNegativeRise = 2 ;
type
    TAlignMode = ( PositivePeaks,NegativePeaks,AbsPeaks ) ;

var
   Sum : PSingleArray ;
   ADC : PSmallIntArray ;
   RH : TRecHeader ;
   LastUsedRH : TRecHeader ;
   Cursor0 : Integer ;
   Cursor1 : Integer ;
   AlignAt : array[0..WCPMaxChannels-1] of Integer ;
   OldNumChannels : Integer ;


procedure TAvgFrm.FormShow(Sender: TObject);
{ ---------------------------------------------------------
  Initialise controls and create buffers when form is shown
  ---------------------------------------------------------}
begin

     { Create record type selector box }
     cbRecordType.items := RecordTypes ;
     cbRecordType.items.delete(0) ; {Remove 'ALL' item}

     { Create time to be averaged selector box }
     cbRecTypeToBeAveraged.items := RecordTypes ;
     if cbRecTypeToBeAveraged.itemIndex < 0 then cbRecTypeToBeAveraged.itemIndex := 0 ;

     edRecordNum.HiLimit := RawFH.NumRecords ;
     edRecordNum.HiValue := RawFH.NumRecords ;
     edRecordNum.LoLimit := 1 ;
     edRecordNum.LoValue := sbRecordNum.position ;

     edRange.LoLimit := 1 ;
     edRange.LoValue := edRange.LoLimit ;
     edRange.HiLimit := RawFH.NumRecords ;
     edRange.HiValue := edRange.HiLimit ;

     edBlockSize.Value :=  RawfH.NumRecords ;

     { Initialise average alignment mode combo box }
     if cbAlignMode.ItemIndex < 0 then cbAlignMode.ItemIndex := 0 ;

     { Set button states }
     bAbort.enabled := False ;
     bDoAverages.enabled := True ;

     Resize ;

     { Initialise display/controls }
     NewFile ;

     { Set up range of records to be displayed in averaging setup display }
     RawFH.RecordNum := 1 ;
     UpdateScrollBar( sbRecordNum, RawFH.RecordNum, 1, RawfH.NumRecords ) ;

     DisplayRecord ;

     end ;

procedure TAvgFrm.NewFile ;
{ ---------------------------------------------------------
  Update controls/display to account for change of data file
  ---------------------------------------------------------}
var
   ch,i : Integer ;
begin

     // Reallocate A/D sample buffer
     if ADC <> Nil then FreeMem(ADC) ;
     GetMem( ADC, Max(RawFH.NumSamples*RawFH.NumChannels*2,1024) ) ;
     if Sum <> Nil then FreeMem(Sum) ;
     GetMem( Sum, Max(RawFH.NumSamples*RawFH.NumChannels*4,1024) ) ;

     if RawFH.NumRecords > 0 then begin
        { Set up scope display }
        scDisplay.MaxADCValue := RawFH.MaxADCValue ;
        scDisplay.MinADCValue := RawFH.MinADCValue ;
        scDisplay.DisplayGrid := Settings.DisplayGrid ;
        scDisplay.MaxPoints := RawfH.NumSamples ;
        scDisplay.NumPoints := RawfH.NumSamples ;
        scDisplay.NumChannels := RawfH.NumChannels ;

        { Set channel information }
        for ch := 0 to RawfH.NumChannels-1 do begin
            scDisplay.ChanUnits[ch] := Channel[Ch].ADCUnits ;
            scDisplay.ChanName[ch] := Channel[Ch].ADCName ;
            scDisplay.ChanScale[ch] := Channel[ch].ADCScale ;
            // If the number of channels has changed, zoom out display
            if OldNumChannels <> RawFH.NumChannels then begin
               Channel[ch].yMin := Main.SESLabIO.ADCMinValue ;
               Channel[ch].yMax := Main.SESLabIO.ADCMaxValue ;
               end ;
            scDisplay.ChanOffsets[ch] := Channel[ch].ChannelOffset ;
            scDisplay.ChanVisible[ch] := Channel[ch].InUse ;
            scDisplay.yMin[ch] := Channel[Ch].yMin ;
            scDisplay.yMax[ch] := Channel[Ch].yMax ;
            end ;
        OldNumChannels := FH.NumChannels ;
        scDisplay.ChanZeroAvg := FH.NumZeroAvg ;
        
        scDisplay.xMin := 0 ;
        scDisplay.xMax := RawFH.NumSamples ;
        scDisplay.xOffset := 0 ;
        scDisplay.TScale := RawFH.dt*Settings.TScale ;
        scDisplay.TUnits := Settings.TUnits ;

        { Set initial position of alignment cursors }
        scDisplay.ClearVerticalCursors ;
        Cursor0 := scDisplay.AddVerticalCursor(AllChannels,clGreen,'a') ;
        Cursor1 := scDisplay.AddVerticalCursor(AllChannels,clGreen,'a') ;
        scDisplay.LinkVerticalCursors(Cursor0,Cursor1);

        scDisplay.VerticalCursors[Cursor0] := 5 ;
        scDisplay.VerticalCursors[Cursor1] := RawFH.NumSamples - 5 ;

        scDisplay.ClearHorizontalCursors ;
        for ch := 0 to RawFH.NumChannels-1 do begin
            scDisplay.AddHorizontalCursor(ch,Settings.Colors.Cursors,True,'z') ;
            scDisplay.HorizontalCursors[ch] := Channel[ch].ADCZero ;
            end ;

        { Clear summation buffer }
        for i := 0 to (RawFH.NumChannels*RawFH.NumSamples)-1 do Sum^[i] := 0. ;

        scDisplay.SetDataBuf( ADC ) ;
        end
     else Close ;

     end;


procedure TAvgFrm.sbRecordNumChange(Sender: TObject);
{ ----------------------------------------------------------
  Request a new record to be displayed when slider bar moved
  ----------------------------------------------------------}
begin
     DisplayRecord ;
     end;


procedure TAvgFrm.DisplayRecord ;
{ ===============================
  Display digitised signal record
  ===============================}
var
    ch : Integer ;
begin

     if ADC = Nil then Exit ;

     RawfH.RecordNum := SbRecordNum.position ;

     { Read record data from file }
     GetRecord( RawfH, RH, RawfH.RecordNum, ADC^ ) ;

     scDisplay.TScale := RawFH.dt*Settings.TScale ;

     for ch := 0 to RawFH.NumChannels-1 do begin
         // Zero level
         scDisplay.HorizontalCursors[ch] := Channel[ch].ADCZero ;
         // Start of area from which zero level was computed (-1 indicates fixed zero level)
         scDisplay.ChanZeroAt[ch] := Channel[ch].ADCZeroAt ;
         // Signal scaling factor
         scDisplay.ChanScale[ch] := Channel[ch].ADCScale ;
         end ;
     // No. of samples in zero level area
     scDisplay.ChanZeroAvg := FH.NumZeroAvg ;

     scDisplay.SetDataBuf( ADC ) ;


     { Show whether record has been rejected by operator }
     if RH.Status = 'ACCEPTED' then ckBadRecord.checked := False
                               else ckBadRecord.checked := True ;
     { Show type of record }
     if cbRecordType.items.indexOf(RH.RecType) >= 0 then
        cbRecordType.ItemIndex := cbRecordType.items.indexOf(RH.RecType);

     { Update record number display }
     edRecordNum.HiValue := fH.NumRecords ;
     edRecordNum.LoValue := sbRecordNum.position ;

     end ;


procedure TAvgFrm.bDoAveragesClick(Sender: TObject);
{ ===================================================
  Create a file containing averaged signal records
  ===================================================}
var
   i,j,jFrom,jTo,iFrom,MaxCh,ch : Integer ;
   Peak,PeakAt,HalfPeak,HalfPeakAt,Shift : Integer ;
   PeakPositive,PeakPositiveAt : Integer ;
   PeakNegative,PeakNegativeAt : Integer ;
   iY,i0,i1 : Integer ;
   ChOffset : Integer ;
   iExt,OldHandle,Temp : Integer ;
   StartAtRec,EndAtRec,RecordNum : Integer ;
   StartOfBlock,EndOfBlock,BlockSize,NumRecordsAveraged : Integer ;
   iStart,iEnd : Integer ;
   Done, OK : Boolean ;
begin

     bDoAverages.Enabled := False ;
     bAbort.Enabled := True ;

     { Create averages file }

     { Copy details from original file header (except file handle!!!!) }
     OldHandle := AvgFH.FileHandle ;
     AvgfH := RawfH ;
     AvgFH.FileHandle := OldHandle ;

     { The averages data file name has the same name as the original file
       but with the extension .avg }
     AvgfH.FileName := ChangeFileExt( RawfH.FileName, '.avg' ) ;

     { Create file to hold averages }
     FileCloseSafe(  AvgFH.FileHandle ) ;
     AvgfH.FileHandle := FileCreate( AvgfH.FileName ) ;

     { Save header block and request}
     if AvgfH.FileHandle >= 0 then begin
           AvgfH.NumRecords := 0 ;
           SaveHeader( AvgfH ) ;
           OK := True ;
           end
     else begin
          ShowMessage( format('FileCreate Error =%d',[AvgfH.FileHandle])) ;
          OK := False ;
          end ;

     { Initial averaging loop }
     StartAtRec := Round(edRange.LoValue) ;
     EndAtRec := Round(edRange.HiValue) ;
     BlockSize := Round(edBlockSize.Value) ;
     RecordNum := StartAtRec ;
     StartOfBlock := StartAtRec ;
     EndOfBlock := StartAtRec + BlockSize - 1 ;
     NumRecordsAveraged := 0 ;
     Done := not OK ;

     { Average records }
     while not Done do begin

        { Read record data from file }
        GetRecord( RawfH, RH, RecordNum, ADC^ ) ;

        { If no records in buffer yet ... Initialise averaging array }
        if NumRecordsAveraged = 0 then begin
           for i := 0 to (RawFH.NumChannels*RawFH.NumSamples)-1 do Sum^[i] := 0. ;
           LastUsedRH := RH ;
           end ;

        { If record is of the right type and is ACCEPTED for use
        ... add it to average }
        if (RH.Status = 'ACCEPTED') and
           ( (RH.RecType = cbRecTypeToBeAveraged.text ) or
           ( cbRecTypeToBeAveraged.text = 'ALL') ) then begin

           { Keep the record header to use for averaged record }
           LastUsedRH := RH ;

           { Add each channel to record average }
           for ch := 0 to RawFH.NumChannels-1 do begin

               { Subtract zero level }
               j := Channel[ch].ChannelOffset ;
               for i := 0 to RawFH.NumSamples-1 do begin
                   ADC^[j] := ADC^[j] - Channel[ch].ADCZero ;
                   j := j +  RawFH.NumChannels ;
                   end ;

               { Get range of samples to be averaged from positions of cursors 0 and 1 }
               iStart := Min( scDisplay.VerticalCursors[Cursor0],
                              scDisplay.VerticalCursors[Cursor1] ) ;
               iEnd :=   Max( scDisplay.VerticalCursors[Cursor0],
                              scDisplay.VerticalCursors[Cursor1] ) ;

               if cbAlignMode.ItemIndex = NoAlignment then begin
                  { No re-alignment }
                  Shift := 0 ;
                  end
               else begin
                  { If in one of the re-alignment mode ... determine how
                  much the signal should be shifted to align the mid-point
                  of its rising phase with that of the average }

                  { Find peaks within cursor 0-1 region}
                  PeakPositive := RawFH.MinADCValue*2 ;
                  PeakNegative := RawFH.MaxADCValue*2 ;
                  j := iStart*RawFH.NumChannels + Channel[ch].ChannelOffset ;
                  for i := iStart to iEnd do begin
                      iY := ADC^[j] ;
                      if iY > PeakPositive then begin
                         PeakPositive := iY ;
                         PeakPositiveAt := i ;
                         end ;
                      if iY < PeakNegative then begin
                         PeakNegative := iY ;
                         PeakNegativeAt := i ;
                         end ;
                      j := j +  RawFH.NumChannels ;
                      end ;

                  if cbAlignMode.ItemIndex = OnPositiveRise then begin
                     PeakAt := PeakPositiveAt ;
                     Peak := Abs(PeakPositive) ;
                     end
                  else if cbAlignMode.ItemIndex = OnNegativeRise then begin
                     PeakAt := PeakNegativeAt ;
                     Peak := Abs(PeakNegative) ;
                     end ;

                  HalfPeak := Peak div 2 ;
                  iY := Peak ;
                  HalfPeakAt := PeakAt ;
                  while (iY >= HalfPeak) and (HalfPeakAt > iStart) do begin
                      j := HalfPeakAt*RawFH.NumChannels + Channel[ch].ChannelOffset ;
                      iY := Abs(ADC^[j]) ;
                      HalfPeakAt := HalfPeakAt - 1;
                      end ;

                  if NumRecordsAveraged = 0 then AlignAt[ch] := HalfPeakAt ;
                  Shift := HalfPeakAt - AlignAt[ch] ;
                  end ;

               { Add signal to average. (Note how signal is scaled by
               binary->real scaling factor. This allows averaging of
               records with different gains) }
               for i := 0 to RawFH.NumSamples-1 do begin
                   iFrom := Max(Min(i + Shift,RawFH.NumSamples-1),0) ;
                   jFrom := iFrom*RawFH.NumChannels + Channel[ch].ChannelOffset ;
                   jTo := i*RawFH.NumChannels + Channel[ch].ChannelOffset ;
                   Sum^[jTo] := Sum^[jTo] + ADC^[jFrom]*Channel[ch].ADCScale ;
                   end ;
               end ;

           NumRecordsAveraged :=  NumRecordsAveraged + 1 ;
           end ;

        { If a block of averages has been acquired, compute average
        and  write it to average file. (Note ... if Do Averages button enabled
        indicates user has aborted averaging) }

        if (RecordNum >= EndOfBlock) or (RecordNum >= EndAtRec)
           or bDoAverages.Enabled then begin

           if NumRecordsAveraged > 0 then begin
              for ch := 0 to RawFH.NumChannels-1 do begin
                  j := Channel[ch].ChannelOffset ;
                  for i := 0 to RawFH.NumSamples-1 do begin
                      ADC^[j] := Trunc( Sum^[j] /
                                 (NumRecordsAveraged*Channel[ch].ADCScale) )
                                 + Channel[ch].ADCZero ;
                      j := j + RawFH.NumChannels ;
                      end ;
                  end ;
              end
           else begin
              { Fill record with zero if no records available }
              for ch := 0 to RawFH.NumChannels-1 do begin
                  j := Channel[ch].ChannelOffset ;
                  for i := 0 to RawFH.NumSamples-1 do begin
                      ADC^[j] := Channel[ch].ADCZero ;
                      j := j + RawFH.NumChannels ;
                      end ;
                  end ;
              end ;

           { Save record to averages file  }
           AvgfH.NumRecords := AvgfH.NumRecords + 1 ;
           LastUsedRH.Number := AvgfH.NumRecords ;
           LastUsedRH.Ident := format('%d-%d %d',[StartOfBlock,
                                                   EndOfBlock,
                                                   NumRecordsAveraged] ) ;
           LastUsedRH.AnalysisAvailable := false ;
           LastUsedRH.EqnType := None ;
           PutRecord( AvgfH, LastUsedRH, AvgfH.NumRecords, ADC^ ) ;

           StartOfBlock :=  EndofBlock + 1 ;
           EndofBlock := EndOfBlock + BlockSize ;
           NumRecordsAveraged := 0 ;
           end ;

        // Report progress
        Main.StatusBar.SimpleText := format(
        ' Signal Average : Adding record %d/%d to average %d ',
            [RecordNum,EndAtRec,AvgfH.NumRecords+1]) ;

        Inc(RecordNum) ;

        { Terminate the job if that was the last record
        or the user has clicked the abort button }
        if (RecordNum > EndAtRec) or bDoAverages.Enabled then Done := True ;

        { Allow other activities }
        Application.ProcessMessages ;
        end ;

     { Save file header }
     SaveHeader( AvgfH ) ;

     // Final Report
     Main.StatusBar.SimpleText := format(
     ' Signal Average : %d-%d (%d averages created)',
            [StartAtRec,EndAtRec,AvgfH.NumRecords]) ;


     { Restore buttons }
     Screen.Cursor := crDefault ;
     bDoAverages.Enabled := True ;
     bAbort.Enabled := False ;

     { Close form }
     Close ;

     end;


procedure TAvgFrm.FormClose(Sender: TObject; var Action: TCloseAction);
{ ----------------------
  Close form and tidy up
  ---------------------- }
begin

     if (AvgFH.NumRecords > 0) and (AvgFH.FileName <> '') then Main.mnShowAveraged.Click ;

     Action :=caFree ;
     end;


procedure TAvgFrm.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin
    ADC := Nil ;
    Sum := Nil ;
    end;


procedure TAvgFrm.FormDestroy(Sender: TObject);
// ------------------------------
// Tidy up when form is destroyed
// ------------------------------
begin
    if ADC <> Nil then FreeMem(ADC) ;
    if Sum <> Nil then FreeMem(Sum) ;
    end;


procedure TAvgFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{ ------------------------
  Function key processing
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
          end ;
     end ;


procedure TAvgFrm.ckBadRecordClick(Sender: TObject);
{ ------------------------------------------------
  Save new record ACCEPTED/REJECTED status to file
  ------------------------------------------------}
begin
     if ckBadRecord.checked then RH.Status := 'REJECTED'
                            else RH.Status := 'ACCEPTED' ;
     PutRecordHeaderOnly( RawfH, RH, RawfH.RecordNum ) ;
     end;


procedure TAvgFrm.cbRecordTypeChange(Sender: TObject);
{ -----------------------------
  Save new record type to file
  ----------------------------}
begin
     RH.RecType := cbRecordType.text ;
     PutRecordHeaderOnly( RawfH, RH, RawfH.RecordNum ) ;
     end;



procedure TAvgFrm.bAbortClick(Sender: TObject);
begin
     bDoAverages.Enabled := True ;
     end;

procedure TAvgFrm.scDisplayCursorChange(Sender: TObject);
{ -------------------------------------
  Update cursor labels when mouse moved
  ------------------------------------- }
var
   ch : Integer ;
begin

     for ch := 0 to scDisplay.NumChannels-1 do if Channel[ch].InUse then begin
         Channel[Ch].yMin := scDisplay.YMin[Ch] ;
         Channel[Ch].yMax := scDisplay.YMax[Ch] ;
         // Fix baseline if required
         if Settings.FixedZeroLevels or (Channel[ch].ADCZeroAt >= 0) then begin
            if scDisplay.HorizontalCursors[ch] <> Channel[ch].ADCZero then begin
               scDisplay.HorizontalCursors[ch] := Channel[ch].ADCZero ;
               end ;
            end
         else Channel[ch].ADCZero := scDisplay.HorizontalCursors[ch] ;

         end ;

     end ;


procedure TAvgFrm.FormResize(Sender: TObject);
{ ------------------------------------------------------
  Adjust size/position of controls when form is re-sized
  ------------------------------------------------------ }
begin
     AverageGrp.Height := ClientHeight - AverageGrp.Top - 5 ;
     ckFixedZeroLevels.Left := scDisplay.left ;
     ckFixedZeroLevels.Top := ClientHeight - 5 - ckFixedZeroLevels.Height ;
     scDisplay.Height := Max( ckFixedZeroLevels.Top - scDisplay.Top -1,2) ;
     scDisplay.Width := Max( ClientWidth - scDisplay.Left - 10,2) ;

     end;


procedure TAvgFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
     scDisplay.MaxADCValue := RawFH.MaxADCValue ;
     scDisplay.MinADCValue := RawFH.MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;
     scDisplay.Invalidate ;
     end ;


procedure  TAvgFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := RawFH.MaxADCValue ;
     scDisplay.MinADCValue := RawFH.MinADCValue ;
     scDisplay.ZoomOut ;
     end ;


procedure TAvgFrm.scDisplayMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ ---------------------------
  Display zero level mode box
  --------------------------- }
begin
     if (Button = mbRight) and (scDisplay.ActiveHorizontalCursor >=0) then begin
        ZeroFrm.EnableFromRecord := True ;
        ZeroFrm.Chan := scDisplay.ActiveHorizontalCursor ;
        ZeroFrm.Level := Channel[ZeroFrm.Chan].ADCZero ;
        ZeroFrm.ChanName := Channel[ZeroFrm.Chan].ADCName ;
        ZeroFrm.NewZeroAt := Round(scDisplay.ScreenCoordToX( ZeroFrm.Chan, X )) ;
        ZeroFrm.OldZeroAt := Channel[ZeroFrm.Chan].ADCZeroAt ;
        ZeroFrm. NumSamplesPerRecord := scDisplay.NumPoints ;
        ZeroFrm.NumZeroAveraged := FH.NumZeroAvg ;
        ZeroFrm.MaxValue := FH.MaxADCValue ;
        ZeroFrm.Left := Self.Left + Main.Left + 10 + scDisplay.Left + X;
        ZeroFrm.Top := Self.Top + Main.Top + 10 + scDisplay.Top + Y ;
        ZeroFrm.ShowModal ;
        Channel[ZeroFrm.Chan].ADCZero := ZeroFrm.Level ;
        Channel[ZeroFrm.Chan].ADCZeroAt := ZeroFrm.NewZeroAt ;
        FH.NumZeroAvg := ZeroFrm.NumZeroAveraged ;
        SaveHeader( FH ) ;
        if ZeroFrm.ModalResult = mrOK then DisplayRecord ;
        end
     else begin
        // Update zero baseline cursor
        if scDisplay.ActiveHorizontalCursor >= 0 then begin
           if Channel[scDisplay.ActiveHorizontalCursor].ADCZeroAt < 0 then begin
              // Fixed baseline level (update zero level to new position)
              Channel[scDisplay.ActiveHorizontalCursor].ADCZero :=
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor] ;
              end
           else begin
              // Baseline level computed from record (return to computed level)
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor] :=
              Channel[scDisplay.ActiveHorizontalCursor].ADCZero ;
              scDisplay.Invalidate ;
              end ;
           SaveHeader( AvgFH ) ;
           end ;
        end ;
     edBlockSize.SetFocus ;
     end ;

procedure TAvgFrm.ckFixedZeroLevelsClick(Sender: TObject);
// --------------------------------
// Enable/Disable fixed zero levels
// --------------------------------
begin
     Settings.FixedZeroLevels := ckFixedZeroLevels.Checked ;
     end;

Initialization
    OldNumChannels := 0 ;
end.
