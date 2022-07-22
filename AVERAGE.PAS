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
  20.09.16 .. Interleaved averaging mode added
              ADC32 and Sum buffers now allocated inside bDoAveragesClick procedure
              Averaged signals at upper/lower limits of signal range no longer wrap around.
  12.01.17 .. .VerticalCursors() now single type and converted to integer by round()
  26.05.22 .. ZeroFrm now settings Channel record zero level settings directly
  ========================================================================== }
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, maths,
  ValEdit, RangeEdit, ScopeDisplay, ComCtrls, ValidatedEdit, math, seslabio, WCPFIleUnit;

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
    bAbort: TButton;
    cbAlignMode: TComboBox;
    Label8: TLabel;
    edRange: TRangeEdit;
    edRecordNum: TRangeEdit;
    scDisplay: TScopeDisplay;
    ckFixedZeroLevels: TCheckBox;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    edBlockSize: TValidatedEdit;
    rbSequentialRecords: TRadioButton;
    rbInterleavedRecords: TRadioButton;
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
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ADC16 : PSmallIntArray ;
    RH : TRecHeader ;
    LastUsedRH : TRecHeader ;
    Cursor0 : Integer ;
    Cursor1 : Integer ;
    AlignAt : array[0..MaxChannels-1] of Integer ;
    OldNumChannels : Integer ;

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


procedure TAvgFrm.FormShow(Sender: TObject);
{ ---------------------------------------------------------
  Initialise controls and create buffers when form is shown
  ---------------------------------------------------------}
begin

     { Create record type selector box }
     cbRecordType.items := WCPFile.RecordTypes ;
     cbRecordType.items.delete(0) ; {Remove 'ALL' item}

     { Create time to be averaged selector box }
     cbRecTypeToBeAveraged.items := WCPFile.RecordTypes ;
     if cbRecTypeToBeAveraged.itemIndex < 0 then cbRecTypeToBeAveraged.itemIndex := 0 ;

     edRecordNum.HiLimit := WCPFile.RawFH.NumRecords ;
     edRecordNum.HiValue := WCPFile.RawFH.NumRecords ;
     edRecordNum.LoLimit := 1 ;
     edRecordNum.LoValue := sbRecordNum.position ;

     edRange.LoLimit := 1 ;
     edRange.LoValue := edRange.LoLimit ;
     edRange.HiLimit := WCPFile.RawFH.NumRecords ;
     edRange.HiValue := edRange.HiLimit ;

     edBlockSize.Value :=  WCPFile.RawfH.NumRecords ;

     { Initialise average alignment mode combo box }
     if cbAlignMode.ItemIndex < 0 then cbAlignMode.ItemIndex := 0 ;

     { Set button states }
     bAbort.enabled := False ;
     bDoAverages.enabled := True ;

     Resize ;

     { Initialise display/controls }
     NewFile ;

     { Set up range of records to be displayed in averaging setup display }
     WCPFile.RawFH.RecordNum := 1 ;
     WCPFile.UpdateScrollBar( sbRecordNum, WCPFile.RawFH.RecordNum, 1, WCPFile.RawfH.NumRecords ) ;

     DisplayRecord ;

     end ;

procedure TAvgFrm.NewFile ;
{ ---------------------------------------------------------
  Update controls/display to account for change of data file
  ---------------------------------------------------------}
var
   ch : Integer ;
begin

     // Reallocate A/D sample buffer
     if ADC16 <> Nil then FreeMem(ADC16) ;
     GetMem( ADC16, Max(WCPFile.RawFH.NumSamples*WCPFile.RawFH.NumChannels*2,1024) ) ;
     scDisplay.SetDataBuf( ADC16 ) ;

     if WCPFile.RawFH.NumRecords > 0 then begin
        { Set up scope display }
        scDisplay.MaxADCValue := WCPFile.RawFH.MaxADCValue ;
        scDisplay.MinADCValue := WCPFile.RawFH.MinADCValue ;
        scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;
        scDisplay.MaxPoints := WCPFile.RawfH.NumSamples ;
        scDisplay.NumPoints := WCPFile.RawfH.NumSamples ;
        scDisplay.NumChannels := WCPFile.RawfH.NumChannels ;

        { Set channel information }
        for ch := 0 to scDisplay.NumChannels-1 do begin
            scDisplay.ChanUnits[ch] := WCPFile.Channel[Ch].ADCUnits ;
            scDisplay.ChanName[ch] := WCPFile.Channel[Ch].ADCName ;
            scDisplay.ChanScale[ch] := WCPFile.Channel[ch].ADCScale ;
            // If the number of channels has changed, zoom out display
            if OldNumChannels <> scDisplay.NumChannels then begin
               WCPFile.Channel[ch].yMin := Main.SESLabIO.ADCMinValue ;
               WCPFile.Channel[ch].yMax := Main.SESLabIO.ADCMaxValue ;
               end ;
            scDisplay.ChanOffsets[ch] := WCPFile.Channel[ch].ChannelOffset ;
            scDisplay.ChanVisible[ch] := WCPFile.Channel[ch].InUse ;
            scDisplay.yMin[ch] := WCPFile.Channel[Ch].yMin ;
            scDisplay.yMax[ch] := WCPFile.Channel[Ch].yMax ;
            end ;
        OldNumChannels := WCPFile.FH.NumChannels ;
        scDisplay.ChanZeroAvg := WCPFile.FH.NumZeroAvg ;

        scDisplay.xMin := 0 ;
        scDisplay.xMax := WCPFile.RawFH.NumSamples ;
        scDisplay.xOffset := 0 ;
        scDisplay.TScale := WCPFile.RawFH.dt*WCPFile.Settings.TScale ;
        scDisplay.TUnits := WCPFile.Settings.TUnits ;

        { Set initial position of alignment cursors }
        scDisplay.ClearVerticalCursors ;
        Cursor0 := scDisplay.AddVerticalCursor(AllChannels,clGreen,'a') ;
        Cursor1 := scDisplay.AddVerticalCursor(AllChannels,clGreen,'a') ;
        scDisplay.LinkVerticalCursors(Cursor0,Cursor1);

        scDisplay.VerticalCursors[Cursor0] := 5 ;
        scDisplay.VerticalCursors[Cursor1] := scDisplay.NumPoints - 5 ;

        scDisplay.ClearHorizontalCursors ;
        for ch := 0 to scDisplay.NumChannels-1 do begin
            scDisplay.AddHorizontalCursor(ch,WCPFile.Settings.Colors.Cursors,True,'z') ;
            scDisplay.HorizontalCursors[ch] := WCPFile.Channel[ch].ADCZero ;
            end ;

        


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

     if ADC16 = Nil then Exit ;

     WCPFile.RawfH.RecordNum := SbRecordNum.position ;

     { Read record data from file }
     WCPFile.GetRecord( WCPFile.RawfH, RH, WCPFile.RawfH.RecordNum, ADC16^ ) ;

     scDisplay.TScale := WCPFile.RawFH.dt*WCPFile.Settings.TScale ;

     for ch := 0 to scDisplay.NumChannels-1 do begin
         // Zero level
         scDisplay.HorizontalCursors[ch] := WCPFile.Channel[ch].ADCZero ;
         // Start of area from which zero level was computed (-1 indicates fixed zero level)
         scDisplay.ChanZeroAt[ch] := WCPFile.Channel[ch].ADCZeroAt ;
         // Signal scaling factor
         scDisplay.ChanScale[ch] := WCPFile.Channel[ch].ADCScale ;
         end ;
     // No. of samples in zero level area
     scDisplay.ChanZeroAvg := WCPFile.RawFH.NumZeroAvg ;

     scDisplay.SetDataBuf( ADC16 ) ;

     { Show whether record has been rejected by operator }
     if RH.Status = 'ACCEPTED' then ckBadRecord.checked := False
                               else ckBadRecord.checked := True ;
     { Show type of record }
     if cbRecordType.items.indexOf(RH.RecType) >= 0 then
        cbRecordType.ItemIndex := cbRecordType.items.indexOf(RH.RecType);

     { Update record number display }
     edRecordNum.HiValue := WCPFile.RawfH.NumRecords ;
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
   iStart,iEnd, np : Integer ;
   Done, OK : Boolean ;
   RepeatCounter,NumRepeats : Integer ;
   ADC32 : PIntArray ;
   Sum : PSingleArray ;
   RH : TRecHeader ;
begin

     bDoAverages.Enabled := False ;
     bAbort.Enabled := True ;

     { Create averages file }

     { Copy details from original file header (except file handle!!!!) }
     OldHandle := WCPFile.AvgFH.FileHandle ;
     WCPFile.AvgfH := WCPFile.RawfH ;
     WCPFile.AvgFH.FileHandle := OldHandle ;

     // Allocate buffer
     np := WCPFile.RawFH.NumSamples*WCPFile.RawFH.NumChannels ;
     GetMem( ADC32, np*SizeOf(Integer));
     GetMem( Sum, np*SizeOf(Single));
     for i := 0 to np-1 do Sum^[i] := 0. ;

     { The averages data file name has the same name as the original file
       but with the extension .avg }
     WCPFile.AvgfH.FileName := ChangeFileExt( WCPFile.RawfH.FileName, '.avg' ) ;

     { Create file to hold averages }
     WCPFile.FileCloseSafe(  WCPFile.AvgFH.FileHandle ) ;
     WCPFile.AvgfH.FileHandle := FileCreate( WCPFile.AvgfH.FileName ) ;

     { Save header block and request}
     if WCPFile.AvgfH.FileHandle >= 0 then begin
           WCPFile.AvgfH.NumRecords := 0 ;
           WCPFile.SaveHeader( WCPFile.AvgfH ) ;
           OK := True ;
           end
     else begin
          ShowMessage( format('FileCreate Error =%d',[WCPFile.AvgfH.FileHandle])) ;
          OK := False ;
          end ;


     { Initial averaging loop }
     StartAtRec := Round(edRange.LoValue) ;
     EndAtRec := Round(edRange.HiValue) ;
     BlockSize := Round(edBlockSize.Value) ;

     if rbSequentialRecords.Checked then begin
        // Sequential record averaging
        StartOfBlock := StartAtRec ;
        EndOfBlock := StartAtRec + BlockSize - 1 ;
        NumRepeats := 1 ;
        end
     else begin
        // Interleaved record averaging
        StartOfBlock := StartAtRec ;
        EndOfBlock := EndAtRec ;
        NumRepeats := BlockSize ;
        end ;

     RecordNum := StartAtRec ;
     RepeatCounter := 0 ;
     NumRecordsAveraged := 0 ;
     Done := not OK ;

     { Average records }
     while not Done do begin

        { Read record data from file }
        if RecordNum <= EndAtRec then begin
           WCPFile.GetRecord32( WCPFile.RawfH, RH, RecordNum, ADC32^ ) ;
           end;

        { If no records in buffer yet ... Initialise averaging array }
        if NumRecordsAveraged = 0 then begin
           for i := 0 to np-1 do Sum^[i] := 0. ;
           LastUsedRH := RH ;
           end ;

        // If record is of the right type and is ACCEPTED for use ... add it to average
        if (RH.Status = 'ACCEPTED') and (RecordNum <= EndAtRec) and
           ( (RH.RecType = cbRecTypeToBeAveraged.text ) or
           ( cbRecTypeToBeAveraged.text = 'ALL') ) then begin

           { Keep the record header to use for averaged record }
           LastUsedRH := RH ;

           { Add each channel to record average }
           for ch := 0 to WCPFile.RawFH.NumChannels-1 do begin

               { Subtract zero level }
               j := WCPFile.Channel[ch].ChannelOffset ;
               for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
                   ADC32^[j] := ADC32^[j] - WCPFile.Channel[ch].ADCZero ;
                   j := j +  WCPFile.RawFH.NumChannels ;
                   end ;

               { Get range of samples to be averaged from positions of cursors 0 and 1 }
               iStart := Min( Round(scDisplay.VerticalCursors[Cursor0]),
                              Round(scDisplay.VerticalCursors[Cursor1]) ) ;
               iEnd :=   Max( Round(scDisplay.VerticalCursors[Cursor0]),
                              Round(scDisplay.VerticalCursors[Cursor1]) ) ;

               if cbAlignMode.ItemIndex = NoAlignment then begin
                  { No re-alignment }
                  Shift := 0 ;
                  end
               else begin
                  { If in one of the re-alignment mode ... determine how
                  much the signal should be shifted to align the mid-point
                  of its rising phase with that of the average }

                  { Find peaks within cursor 0-1 region}
                  PeakPositive := WCPFile.RawFH.MinADCValue*2 ;
                  PeakNegative := WCPFile.RawFH.MaxADCValue*2 ;
                  j := iStart*WCPFile.RawFH.NumChannels + WCPFile.Channel[ch].ChannelOffset ;
                  for i := iStart to iEnd do begin
                      iY := ADC32^[j] ;
                      if iY > PeakPositive then begin
                         PeakPositive := iY ;
                         PeakPositiveAt := i ;
                         end ;
                      if iY < PeakNegative then begin
                         PeakNegative := iY ;
                         PeakNegativeAt := i ;
                         end ;
                      j := j +  WCPFile.RawFH.NumChannels ;
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
                      j := HalfPeakAt*WCPFile.RawFH.NumChannels + WCPFile.Channel[ch].ChannelOffset ;
                      iY := Abs(ADC32^[j]) ;
                      HalfPeakAt := HalfPeakAt - 1;
                      end ;

                  if NumRecordsAveraged = 0 then AlignAt[ch] := HalfPeakAt ;
                  Shift := HalfPeakAt - AlignAt[ch] ;
                  end ;

               { Add signal to average. (Note how signal is scaled by
               binary->real scaling factor. This allows averaging of
               records with different gains) }
               for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
                   iFrom := Max(Min(i + Shift,WCPFile.RawFH.NumSamples-1),0) ;
                   jFrom := iFrom*WCPFile.RawFH.NumChannels + WCPFile.Channel[ch].ChannelOffset ;
                   jTo := i*WCPFile.RawFH.NumChannels + WCPFile.Channel[ch].ChannelOffset ;
                   Sum^[jTo] := Sum^[jTo] + ADC32^[jFrom]*WCPFile.Channel[ch].ADCScale ;
                   end ;
               end ;

           NumRecordsAveraged :=  NumRecordsAveraged + 1 ;
           end ;

        { If a block of averages has been acquired, compute average
        and  write it to average file. (Note ... if Do Averages button enabled
        indicates user has aborted averaging) }

        if (RecordNum >= EndOfBlock) or (RecordNum >= EndAtRec) or bDoAverages.Enabled then begin

           if NumRecordsAveraged > 0 then begin
              for ch := 0 to WCPFile.RawFH.NumChannels-1 do begin
                  j := WCPFile.Channel[ch].ChannelOffset ;
                  for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
                      ADC32^[j] := Round( Sum^[j] /
                                 (NumRecordsAveraged*WCPFile.Channel[ch].ADCScale) + WCPFile.Channel[ch].ADCZero ) ;
                      ADC32^[j] := Min(Max(ADC32^[j],WCPFile.RawFH.MinADCValue),WCPFile.RawFH.MaxADCValue);           ;
                      j := j + WCPFile.RawFH.NumChannels ;
                      end ;
                  end ;
              end
           else begin
              { Fill record with zero if no records available }
              for ch := 0 to WCPFile.RawFH.NumChannels-1 do begin
                  j := WCPFile.Channel[ch].ChannelOffset ;
                  for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
                      ADC32^[j] := WCPFile.Channel[ch].ADCZero ;
                      j := j + WCPFile.RawFH.NumChannels ;
                      end ;
                  end ;
              end ;

           { Save record to averages file  }
           WCPFile.AvgfH.NumRecords := WCPFile.AvgfH.NumRecords + 1 ;
           LastUsedRH.Number := WCPFile.AvgfH.NumRecords ;
           LastUsedRH.Ident := format('%d-%d %d',[StartOfBlock,
                                                   EndOfBlock,
                                                   NumRecordsAveraged] ) ;
           LastUsedRH.AnalysisAvailable := false ;
           LastUsedRH.EqnType := None ;
           WCPFile.PutRecord32( WCPFile.AvgfH, LastUsedRH, WCPFile.AvgfH.NumRecords, ADC32^ ) ;

           if rbSequentialRecords.Checked then begin
              // Only increment averaging block range in sequential mode
              StartOfBlock :=  EndofBlock + 1 ;
              EndofBlock := EndOfBlock + BlockSize ;
              end
           else begin
              // Increment repeat counter in interleaved mode and reset record to start
              Inc(RepeatCounter) ;
              RecordNum := StartAtRec + RepeatCounter - BlockSize ;
              end ;
           NumRecordsAveraged := 0 ;
           end ;

        // Report progress
        Main.StatusBar.SimpleText := format(
        ' Signal Average : Adding record %d/%d to average %d ',
            [RecordNum,EndAtRec,WCPFile.AvgfH.NumRecords+1]) ;

        // Increment to next record
        if rbSequentialRecords.Checked then Inc(RecordNum)
                                       else RecordNum := RecordNum + BlockSize ;

        { Terminate the job if that was the last record
        or the user has clicked the abort button }
        if RecordNum > EndAtRec then begin
           // Terminate if at end of range in sequential mode
           // or if required number of repeats acquired in interleaved mode
           if rbSequentialRecords.Checked then Done := True
           else if RepeatCounter >= NumRepeats then Done := True ;
           end;
        if bDoAverages.Enabled then Done := True ;

        { Allow other activities }
        Application.ProcessMessages ;
        end ;

     { Save file header }
     WCPFile.SaveHeader( WCPFile.AvgfH ) ;

     // Final Report
     Main.StatusBar.SimpleText := format(
     ' Signal Average : %d-%d (%d averages created)',
            [StartAtRec,EndAtRec,WCPFile.AvgfH.NumRecords]) ;

     { Restore buttons }
     Screen.Cursor := crDefault ;
     bDoAverages.Enabled := True ;
     bAbort.Enabled := False ;

     FreeMem(ADC32);
     FreeMem(Sum) ;

     { Close form }
     Close ;

     end;


procedure TAvgFrm.FormClose(Sender: TObject; var Action: TCloseAction);
{ ----------------------
  Close form and tidy up
  ---------------------- }
begin

     if (WCPFile.AvgFH.NumRecords > 0) and (WCPFile.AvgFH.FileName <> '') then Main.mnShowAveraged.Click ;

     Action :=caFree ;
     end;


procedure TAvgFrm.FormCreate(Sender: TObject);
begin
    OldNumChannels := 0 ;
    end;

procedure TAvgFrm.FormDestroy(Sender: TObject);
// ------------------------------
// Tidy up when form is destroyed
// ------------------------------
begin
    if ADC16 <> Nil then FreeMem(ADC16) ;
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
     WCPFile.PutRecordHeaderOnly( WCPFile.RawfH, RH, WCPFile.RawfH.RecordNum ) ;
     end;


procedure TAvgFrm.cbRecordTypeChange(Sender: TObject);
{ -----------------------------
  Save new record type to file
  ----------------------------}
begin
     RH.RecType := cbRecordType.text ;
     WCPFile.PutRecordHeaderOnly( WCPFile.RawfH, RH, WCPFile.RawfH.RecordNum ) ;
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

     for ch := 0 to scDisplay.NumChannels-1 do if WCPFile.Channel[ch].InUse then begin
         WCPFile.Channel[Ch].yMin := scDisplay.YMin[Ch] ;
         WCPFile.Channel[Ch].yMax := scDisplay.YMax[Ch] ;
         // Fix baseline if required
         if WCPFile.Settings.FixedZeroLevels or (WCPFile.Channel[ch].ADCZeroAt >= 0) then begin
            if scDisplay.HorizontalCursors[ch] <> WCPFile.Channel[ch].ADCZero then begin
               scDisplay.HorizontalCursors[ch] := WCPFile.Channel[ch].ADCZero ;
               end ;
            end
         else WCPFile.Channel[ch].ADCZero := Round(scDisplay.HorizontalCursors[ch]) ;

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
     scDisplay.MaxADCValue := WCPFile.RawFH.MaxADCValue ;
     scDisplay.MinADCValue := WCPFile.RawFH.MinADCValue ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;
     scDisplay.Invalidate ;
     end ;


procedure  TAvgFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := WCPFile.RawFH.MaxADCValue ;
     scDisplay.MinADCValue := WCPFile.RawFH.MinADCValue ;
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
        ZeroFrm.NewZeroAt := Round(scDisplay.ScreenCoordToX( ZeroFrm.Chan, X )) ;
        ZeroFrm. NumSamplesPerRecord := scDisplay.NumPoints ;
        ZeroFrm.Left := Self.Left + Main.Left + 10 + scDisplay.Left + X;
        ZeroFrm.Top := Self.Top + Main.Top + 10 + scDisplay.Top + Y ;
        ZeroFrm.ShowModal ;
        if ZeroFrm.ModalResult = mrOK then DisplayRecord ;
        end
     else begin
        // Update zero baseline cursor
        if scDisplay.ActiveHorizontalCursor >= 0 then begin
           if WCPFile.Channel[scDisplay.ActiveHorizontalCursor].ADCZeroAt < 0 then begin
              // Fixed baseline level (update zero level to new position)
              WCPFile.Channel[scDisplay.ActiveHorizontalCursor].ADCZero := Round(
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor]) ;
              end
           else begin
              // Baseline level computed from record (return to computed level)
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor] :=
              WCPFile.Channel[scDisplay.ActiveHorizontalCursor].ADCZero ;
              scDisplay.Invalidate ;
              end ;
           WCPFile.SaveHeader( WCPFile.AvgFH ) ;
           end ;
        end ;
     edBlockSize.SetFocus ;
     end ;

procedure TAvgFrm.ckFixedZeroLevelsClick(Sender: TObject);
// --------------------------------
// Enable/Disable fixed zero levels
// --------------------------------
begin
     WCPFile.Settings.FixedZeroLevels := ckFixedZeroLevels.Checked ;
     end;

end.
