unit Leaksub;
{ ===================================================================
  WinWCP - Digital leak current subtraction module
  (c) J.Dempster 1996, University of Strathclyde, All Rights Reserved
  11/6/97 ... LEAK record are subtracted and included in SUB file
              when in FILE MODE
  13/6/97 ... Save Leak Records check box added
  14/7/99 V3.0 .... Converted to 32 bit (Delphi V3.0)
  4/9/99 ... Display grid added
  30/10/99 ... NewFile method added
  1/11/99 ... Now works OK with current only files
  3/11/99 ... NewFile now closes form if no records available
  15/7/01 ... I scale variable now initialised to 1
  29/8/01 ... Fixed zero level now saved when changed
  3/12/01 ... NewFile now retains displayed record number position
  19/3/02 ... Option for subtracting currents relative to fixed zero levels
              (rather than relative to Vhold) now possible
  27/4/02 ... scDisplay.ChanOffsets now set so that display shows channel
              traces in correct order
  24.6.03 ... No. of display grid lines can be changed
  9.05.04 ... Ionic leak current only subtraction option added
  10.05.04 .. Errors corrected
  01.01.04 .. Out of memory error blocked when windows resized to tiny size
  02.12.06 .. Averaging of leak current when ILeak only subtraction in use
              now works correctly leading to lower noise / more accuration subtraction
              ILeak mode button only now disabled in Group leak subtraction mode
  14.08.07 .. ILeak only mode no longer disabled whe cursor moved
  16.01.13 .. Display cursor update loop which occurred when more than 2 channels in data file fixed.
  07.06.13 .. FH.NumZeroAvg now updated when changed in ZeroFrm
  12.01.17 .. .VerticalCursors() now single type and converted to integer by round()
  ===================================================================}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, global, fileio, shared, maths,
  ScopeDisplay, ValEdit, RangeEdit, Menus, ComCtrls, ValidatedEdit, Math, seslabio ;

type
  TLeakSubFrm = class(TForm)
    RecordGrp: TGroupBox;
    Label2: TLabel;
    cbRecordType: TComboBox;
    ckBadRecord: TCheckBox;
    sbRecordNum: TScrollBar;
    AnalysisGrp: TGroupBox;
    bDoSubtraction: TButton;
    bAbort: TButton;
    cbVoltage: TComboBox;
    Label1: TLabel;
    Label6: TLabel;
    cbCurrent: TComboBox;
    Label5: TLabel;
    ModeGrp: TGroupBox;
    rbGroupMode: TRadioButton;
    rbFileMode: TRadioButton;
    ScalingGrp: TGroupBox;
    rbAutoScaling: TRadioButton;
    rbFixedScaling: TRadioButton;
    Label3: TLabel;
    ckSaveLeaks: TCheckBox;
    edRange: TRangeEdit;
    edIScale: TValidatedEdit;
    edGroup: TValidatedEdit;
    edRecordNum: TRangeEdit;
    SubtractGrp: TGroupBox;
    rbSubtractWholeLeakCurrent: TRadioButton;
    rbSubtractILeakOnly: TRadioButton;
    scDisplay: TScopeDisplay;
    ckFixedZeroLevels: TCheckBox;
    procedure sbRecordNumChange(Sender: TObject);
    procedure bDoSubtractionClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EdGroupKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure bAbortClick(Sender: TObject);
    procedure ckBadRecordClick(Sender: TObject);
    procedure cbRecordTypeChange(Sender: TObject);
    procedure cbVoltageChange(Sender: TObject);
    procedure cbCurrentChange(Sender: TObject);
    procedure rbFileModeClick(Sender: TObject);
    procedure rbGroupModeClick(Sender: TObject);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure scDisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rbFixedScalingClick(Sender: TObject);
    procedure rbAutoScalingClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ckFixedZeroLevelsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure InitialiseDisplay ;
    procedure DisplayRecord ;
  public
    { Public declarations }
    procedure ChangeDisplayGrid ;
    procedure ZoomOut ;
    procedure NewFile ;
  end;

var
  LeakSubFrm: TLeakSubFrm;

implementation

uses mdiform, Zero ;

{$R *.DFM}
type
    TCursors = record
             VHold : Integer ;
             VTest : Integer ;
             IBase : Integer ;
             VBase : Integer ;
             end ;
var
   ITest : PSingleArray ;
   VTest : PSingleArray ;
   ILeak : PSingleArray ;
   VLeak : PSingleArray ;
   ADC : PSmallIntArray ;
   RH : TRecHeader ;
   Cursors : TCursors ;
   OldNumChannels : Integer ;

procedure TLeakSubFrm.FormShow(Sender: TObject);
{ --------------------------------------------
  Initialisation procedures when form is shown
  --------------------------------------------}
begin

     ckSaveLeaks.Checked := false ;
     ckSaveLeaks.Enabled := false ;

     rbSubtractILeakOnly.Enabled := False ;

     { Set up current and voltage channels }
     cbCurrent.items := ChannelNames ;
     cbCurrent.ItemIndex := Min(Settings.SealTest.CurrentChannel,FH.NumChannels-1) ;
     cbVoltage.items := ChannelNames ;
     cbVoltage.ItemIndex := Min(Settings.SealTest.VoltageChannel,FH.NumChannels-1) ;

     cbRecordType.Items := RecordTypes ;

     { Set button states }
     bAbort.enabled := False ;
     bDoSubtraction.enabled := True ;

     ClientWidth := SubtractGrp.Left + SubtractGrp.Width + 5 ;
     ClientHeight := SubtractGrp.Top + SubtractGrp.Height + 5 ;

     { Initialise display/controls }
     NewFile ;

     end;


procedure TLeakSubFrm.NewFile ;
{ ---------------------------------------------------------
  Update controls/display to account for change of data file
  ---------------------------------------------------------}
begin

     // Reallocate buffers
     if ADC <> Nil then FreeMem(ADC) ;
     GetMem( ADC, Max(RawFH.NumSamples*RawFH.NumChannels*2,1024) ) ;
     if ITest <> Nil then FreeMem(ITest) ;
     GetMem( ITest, Max(RawFH.NumSamples*RawFH.NumChannels*4,1024) ) ;
     if VTest <> Nil then FreeMem(VTest) ;
     GetMem( VTest, Max(RawFH.NumSamples*RawFH.NumChannels*4,1024) ) ;
     if ILeak <> Nil then FreeMem(ILeak) ;
     GetMem( ILeak, Max(RawFH.NumSamples*RawFH.NumChannels*4,1024) ) ;
     if VLeak <> Nil then FreeMem(VLeak) ;
     GetMem( VLeak, Max(RawFH.NumSamples*RawFH.NumChannels*4,1024) ) ;

     if RawFH.Numrecords > 0 then begin

        RawFH.RecordNum := 1 ;
        UpdateScrollBar( sbRecordNum, RawFH.RecordNum, 1, RawfH.NumRecords ) ;

        edRange.LoLimit := 1 ;
        edRange.LoValue := 1 ;
        edRange.HiLimit := RawFH.NumRecords ;
        edRange.HiValue := RawFH.NumRecords ;

        { If there is only one channel in the file ... disable automatic voltage scaling }
        if RawFH.NumChannels < 2 then begin
           rbFixedScaling.checked := True ;
           rbAutoScaling.enabled := False ;
           cbVoltage.Enabled := False ;
           cbVoltage.ItemIndex := -1 ;
           end
        else begin
           rbAutoScaling.checked := True ;
           rbAutoScaling.enabled := True ;
           cbVoltage.Enabled := True ;
           end ;

        InitialiseDisplay ;
        DisplayRecord ;
        end
     else Close ;

     end ;


procedure TLeakSubFrm.sbRecordNumChange(Sender: TObject);
{ ----------------------------------------------------------
  Request a new record to be displayed when slider bar moved
  ----------------------------------------------------------}
begin
     DisplayRecord ;
     end;


procedure TLeakSubFrm.InitialiseDisplay ;
{ --------------------------------------------------
  Initialise scope display to show selected channels
  -------------------------------------------------- }
var
   ch : Integer ;
begin


     { Set up scope display }
     scDisplay.MaxADCValue := FH.MaxADCValue ;
     scDisplay.MinADCValue := FH.MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;

     scDisplay.MaxPoints := FH.NumSamples ;
     scDisplay.NumPoints := FH.NumSamples ;
     scDisplay.NumChannels := FH.NumChannels ;
     { Set channel information }
     for ch := 0 to FH.NumChannels-1 do begin
         scDisplay.ChanOffsets[ch] := Channel[ch].ChannelOffset ;
         scDisplay.ChanUnits[ch] := Channel[Ch].ADCUnits ;
         scDisplay.ChanName[ch] := Channel[Ch].ADCName ;
         scDisplay.ChanScale[ch] := Channel[ch].ADCScale ;
         // If the number of channels has changed, zoom out display
         if OldNumChannels <> FH.NumChannels then begin
            Channel[ch].yMin := Main.SESLabIO.ADCMinValue ;
            Channel[ch].yMax := Main.SESLabIO.ADCMaxValue ;
            end ;
         scDisplay.yMin[ch] := Channel[Ch].yMin ;
         scDisplay.yMax[ch] := Channel[Ch].yMax ;
         if (ch = cbCurrent.ItemIndex) or
            (ch = cbVoltage.ItemIndex) then scDisplay.ChanVisible[ch] := True
                                       else scDisplay.ChanVisible[ch] := False ;
         end ;
     OldNumChannels := FH.NumChannels ;

     scDisplay.xMin := 0 ;
     scDisplay.xMax := FH.NumSamples - 1 ;

     { Remove all cursors }
     scDisplay.ClearHorizontalCursors ;
     scDisplay.ClearVerticalCursors ;

     { Current channel baseline }
     Cursors.IBase := scDisplay.AddHorizontalCursor(
                      cbCurrent.ItemIndex,
                      Settings.Colors.Cursors,
                      True,
                      'z') ;
     scDisplay.HorizontalCursors[Cursors.IBase] := Channel[cbCurrent.ItemIndex].ADCZero ;


     { Add voltage channel cursors only if more than one channel available }
     if RawFH.NumChannels > 1  then begin

        { Voltage channel baseline }
        Cursors.VBase := scDisplay.AddHorizontalCursor(
                         cbVoltage.ItemIndex,
                         Settings.Colors.Cursors,
                         True,
                         'z') ;
        scDisplay.HorizontalCursors[Cursors.VBase] := Channel[cbVoltage.ItemIndex].ADCZero ;

        { Holding voltage measurement position }
        Cursors.VHold := scDisplay.AddVerticalCursor(AllChannels,Settings.Colors.Cursors,'VHold') ;
        scDisplay.VerticalCursors[Cursors.VHold] := 1 ;

        { Test voltage measurement position }
        Cursors.VTest := scDisplay.AddVerticalCursor(AllChannels,Settings.Colors.Cursors,'VTest') ;
        scDisplay.VerticalCursors[Cursors.VTest] := RawFH.NumSamples div 2 ;

        end ;

     scDisplay.xOffset := 0 ;
     scDisplay.TScale := FH.dt*Settings.TScale ;
     scDisplay.TUnits := Settings.TUnits ;

     end ;


procedure TLeakSubFrm.DisplayRecord ;
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

     edRecordNum.HiLimit := RawfH.NumRecords ;
     edRecordNum.HiValue := RawfH.NumRecords ;
     edRecordNum.LoValue := sbRecordNum.position ;

     { Show whether record has been rejected by operator }
     if RH.Status = 'ACCEPTED' then ckBadRecord.checked := False
                               else ckBadRecord.checked := True ;



     { Show type of record }
     if cbRecordType.items.indexOf(RH.RecType) >= 0 then
        cbRecordType.ItemIndex := cbRecordType.items.indexOf(RH.RecType);
     edGroup.Value := RH.Number ;

     end ;


procedure TLeakSubFrm.bDoSubtractionClick(Sender: TObject);
{ ----------------------
  Start leak subtraction
  ----------------------}
const
     VLimit = 0.001 ;
     nAvg = 20 ;
var
   StartAtRec : Integer ;
   EndAtRec : Integer ;
   VHoldCursor : Integer ;
   VTestCursor : Integer ;
   RecordNum : Integer ;
   GroupNumber : single ;
   nLeak : Integer ;
   nTest : Integer ;
   LastTestRecord : Integer ;

   OldHandle : Integer ;
   i,j,ch,ChOffset,Rec : Integer ;
   IOffset,VOffset,IZero,VZero : Integer ;
   IScale,VScale : single ;
   iStart,iEnd : Integer ;
   iY,i0,i1 : Integer ;
   VHoldLeak,VPulseLeak,VHoldTest,VPulseTest,VLeakStep,VPulseStep : single ;
   IHoldLeak : Single ; // Leak record holding current
   IPulseLeak : Single ;
   GLeak : Single ;     // Leak conductance
   LeakScale : single ; {Leak current scaling up factor }
   OK, Done, SaveRecord : boolean ;

begin

     bDoSubtraction.Enabled := False ;
     bAbort.Enabled := True ;

     StartAtRec := Round( edRange.LoValue ) ;
     EndAtRec := Round( edRange.HiValue ) ;
     nLeak := 0 ;
     nTest := 0 ;

     { Create leak subtraction file }

     { Copy details from original file header (except file handle!!!!) }
     OldHandle := LeakFH.FileHandle ;
     LeakfH := RawfH ;
     LeakFH.FileHandle := OldHandle ;

     { The averages data file name has the same name as the original file
       but with the extension .sub }
     LeakfH.FileName := ChangeFileExt( RawfH.FileName, '.sub' ) ;
     { Create file to hold averages }
     FileCloseSafe(  LeakFH.FileHandle ) ;
     LeakfH.FileHandle := FileCreate( LeakfH.FileName ) ;
     { Save header block and request subtractions to start}
     if LeakfH.FileHandle >= 0 then begin
           LeakfH.NumRecords := 0 ;
           SaveHeader( LeakfH ) ;
           end
     else ShowMessage( 'FileCreate Error ='+ IntToStr(LeakfH.FileHandle));

     { Current and voltage channel offsets into ADC buffer }
     IOffset := Channel[cbCurrent.ItemIndex].ChannelOffset;
     VOffset := Channel[cbVoltage.ItemIndex].ChannelOffset;

     VHoldCursor := Round(scDisplay.VerticalCursors[Cursors.VHold]) ;
     VTestCursor := Round(scDisplay.VerticalCursors[Cursors.VTest]) ;

     { If in FILE MODE ... compute an averaged leak record
       from all the LEAK type records in the file }

     if rbFileMode.checked then begin

        nLeak := 0 ;
        Rec := StartAtRec ;
        Done := False ;
        While not Done do begin

            { Read record data from file }
            GetRecord( RawfH, RH, Rec, ADC^ ) ;

            { If record is LEAK type and ACCEPTED ... add it to average }
            if (RH.Status = 'ACCEPTED') and (RH.RecType = 'LEAK' ) then begin

               { Current and voltage scaling factors }
               IScale := Channel[cbCurrent.ItemIndex].ADCScale ;
               VScale := Channel[cbVoltage.ItemIndex].ADCScale ;

               if rbAutoScaling.Checked then begin
                  { Use levels under VHold cursor as zero references
                    when voltage scaling is in use}
                  IZero := ADC^[Round(scDisplay.VerticalCursors[Cursors.VHold])*RawFH.NumChannels
                           + IOffset] ;
                  VZero := ADC^[Round(scDisplay.VerticalCursors[Cursors.VHold])*RawFH.NumChannels
                           + VOffset] ;
                  end
               else begin
                  // Use currently selected zero levels
                  IZero := Channel[cbCurrent.ItemIndex].ADCZero ;
                  VZero := Channel[cbVoltage.ItemIndex].ADCZero ;
                  end ;

               { Add current and voltage channels to summation buffers }
                j := 0 ;
                for i := 0 to RawFH.NumSamples-1 do begin
                    if nLeak = 0 then begin
                       ILeak^[i] := 0. ;
                       VLeak^[i] := 0. ;
                       end ;
                    ILeak^[i] := ILeak^[i] + IScale*(ADC^[j+IOffset] - IZero) ;
                    VLeak^[i] := VLeak^[i] + VScale*(ADC^[j+VOffset] - VZero) ;
                    j := j + RawFH.NumChannels ;
                    end ;
                Inc( nLeak ) ;
                end ;

            Inc(Rec) ;

            // Report progress
            Main.StatusBar.SimpleText := format(
            ' Leak current subtraction : %d/%d (%d LEAK records averaged)',
            [Rec,EndAtRec,nLeak]) ;

            { Terminate when last record done or user aborts }
            if (Rec > EndAtRec) or bDoSubtraction.Enabled then Done := True ;
            end ;

        { Calculate averaged leak current and voltage }
        if nLeak > 0 then begin
              for i := 0 to RawFH.NumSamples-1 do begin
                  VLeak^[i] := VLeak^[i] / nLeak ;
                  ILeak^[i] := ILeak^[i] / nLeak ;
                  end ;
              end ;
        end ;

     { Scale and subtract leak records from test records }
     Rec := StartAtRec ;
     Done := False ;
     While not Done do begin

         { Read record from data file }
         GetRecord( RawfH, RH, Rec, ADC^ ) ;
         GroupNumber := RH.Number ;

         { Only use records marked by user as 'ACCEPTED' }
         if RH.Status = 'ACCEPTED' then begin

            if ckSaveLeaks.checked or (RH.RecType <> 'LEAK') then begin
               { *** TEST records *** }
               LastTestRecord := Rec ;
               { Current and voltage scaling factors }
               IScale := Channel[cbCurrent.ItemIndex].ADCScale ;
               VScale := Channel[cbVoltage.ItemIndex].ADCScale ;

               if rbAutoScaling.Checked then begin
                  { Use levels under VHold cursor as zero references }
                  IZero := ADC^[VHoldCursor*RawFH.NumChannels + IOffset] ;
                  VZero := ADC^[VHoldCursor*RawFH.NumChannels + VOffset] ;
                  end
               else begin
                  // Use currently selected zero levels
                  IZero := Channel[cbCurrent.ItemIndex].ADCZero ;
                  VZero := Channel[cbVoltage.ItemIndex].ADCZero ;
                  end ;

               { Add current and voltage channels to summation buffers }
               j := 0 ;
               for i := 0 to RawFH.NumSamples-1 do begin
                   if nTest = 0 then begin
                      ITest^[i] := 0. ;
                      VTest^[i] := 0. ;
                      end ;
                   ITest^[i] := ITest^[i] + IScale*(ADC^[j+IOffset] - IZero) ;
                   VTest^[i] := VTest^[i] + VScale*(ADC^[j+VOffset] - VZero) ;
                   j := j + RawFH.NumChannels ;
                   end ;

               Inc( nTest ) ;
               end
            else if rbGroupMode.checked then begin

               { *** LEAK records *** }

               { Current and voltage scaling factors }
               IScale := Channel[cbCurrent.ItemIndex].ADCScale ;
               VScale := Channel[cbVoltage.ItemIndex].ADCScale ;

               // Zero levels
               if rbAutoScaling.Checked then begin
                  { Use levels under VHold cursor as zero references }
                  IZero := ADC^[VHoldCursor*RawFH.NumChannels + IOffset] ;
                  VZero := ADC^[VHoldCursor*RawFH.NumChannels + VOffset] ;
                  end
               else begin
                  // Use currently selected zero levels
                  IZero := Channel[cbCurrent.ItemIndex].ADCZero ;
                  VZero := Channel[cbVoltage.ItemIndex].ADCZero ;
                  end ;

               j := 0 ;
               for i := 0 to RawFH.NumSamples-1 do begin
                   if nLeak = 0 then begin
                      ILeak^[i] := 0. ;
                      VLeak^[i] := 0 ;
                      end ;
                   ILeak^[i] := ILeak^[i] + IScale*(ADC^[j+IOffset] - IZero) ;
                   VLeak^[i] := VLeak^[i] + VScale*(ADC^[j+VOffset] - VZero) ;
                   j := j + RawFH.NumChannels ;
                   end ;
               Inc( nLeak ) ;
               end ;
            end ;

         { Is this record the last in its group or the last in the file }
         if Rec >= EndAtRec then SaveRecord := True
         else begin
            GetRecordHeaderOnly( RawfH, RH, Rec+1 ) ;
            if RH.Number <> GroupNumber then SaveRecord := True
                                        else SaveRecord := False ;
            end ;

         if SaveRecord then begin

            { If in Group-mode leak subtraction ... average leak record }

            if (nTest > 0) and (nLeak > 0) then OK := True
                                           Else OK := False ;
            if rbGroupMode.checked then begin
               if nLeak > 0 then begin
                  for i := 0 to RawFH.NumSamples-1 do begin
                    VLeak^[i] := VLeak^[i] / nLeak ;
                    ILeak^[i] := ILeak^[i] / nLeak ;
                    end ;
                  nLeak := 0 ;
                  end ;
               end ;

            { Average test records }
            if nTest > 0 then begin
               for i := 0 to RawFH.NumSamples-1 do begin
                   VTest^[i] := VTest^[i] / nTest ;
                   ITest^[i] := ITest^[i] / nTest ;
                   end ;
               nTest := 0 ;
               end ;

            // Calculate factor by which leak current is to be scaled up by
            //  before being subtracted from test current

            if OK and rbAutoScaling.checked then begin
               { Calculate holding voltage level for leak and test records }
               i0 := VHoldCursor ;
               i1 := MinInt([VHoldCursor + nAvg - 1,
                            RawFH.NumSamples-1])  ;
               VHoldLeak := 0. ;
               VHoldTest := 0. ;
               for i := i0 to i1 do begin
                 VHoldLeak := VHoldLeak + VLeak^[i] ;
                 VHoldTest := VHoldTest + VTest^[i] ;
                 end ;
               VHoldLeak := VHoldLeak / (i1 - i0 + 1 ) ;
               VHoldTest := VHoldTest / (i1 - i0 + 1 ) ;

               { Calculate pulse voltage level for leak and test records }
               i0 := VTestCursor ;
               i1 := MinInt([VTestCursor + nAvg - 1,
                           RawFH.NumSamples-1])  ;
               VPulseLeak := 0. ;
               VPulseTest := 0. ;
               for i := i0 to i1 do begin
                   VPulseLeak := VPulseLeak + VLeak^[i] ;
                   VPulseTest := VPulseTest + VTest^[i] ;
                   end ;
               VPulseLeak := VPulseLeak / (i1 - i0 + 1 ) ;
               VPulseTest := VPulseTest / (i1 - i0 + 1 ) ;

               { Voltage steps }
               VPulseStep := VPulseTest - VHoldTest ;
               VLeakStep := VPulseLeak - VHoldLeak ;

               { If either current or voltage steps are too small ... give up }
               if Abs(VLeakStep) > VLimit then begin
                  OK := True ;
                  LeakScale := VPulseStep / VLeakStep ;
                  end
               else OK := False ;
               end ;

            if OK then begin

               { If fixed current scaling ... get scaling factor from user }
               if rbFixedScaling.checked then LeakScale := edIScale.Value ;

               if rbSubtractWholeLeakCurrent.Checked then begin
                  { Subtract scaled leak current from test current }
                  for i := 0 to RawFH.NumSamples-1 do
                      ITest^[i] := ITest^[i] - LeakScale*ILeak^[i] ;
                  end
               else begin
                  // Subtract ionic component of leak current only

                  // Calculate leak pulse holding current
                  // from average current of 90% of A/D samples
                  // from VHold cursot to start of pulse
                  i0 := VHoldCursor ;
                  i1 := i0 ;
                  while (Abs(VLeak^[i1] - VHoldLeak) < Abs(0.05*VLeakStep)) and
                        (i1 < (RawFH.NumSamples-1)) do Inc(i1) ;
                  i1 := i1 - ((i1-i0) div 10) ;
                  IHoldLeak := 0.0 ;
                  for i := i0 to i1 do IHoldLeak := IHoldLeak + ILeak^[i] ;
                  IHoldLeak := IHoldLeak / (i1 - i0 + 1 ) ;

                  // Calculate leak pulse test current
                  // calculated from average of first 90% of sample points from
                  // VTest cursor to end of pulse
                  i0 := VTestCursor ;
                  i1 := i0 ;
                  while (Abs(VLeak^[i1] - VPulseLeak) < Abs(0.05*VLeakStep)) and
                        (i1 < (RawFH.NumSamples-1)) do Inc(i1) ;
                  i1 := i1 - ((i1-i0) div 10) ;
                  IPulseLeak := 0.0 ;
                  for i := i0 to i1 do IPulseLeak := IPulseLeak + ILeak^[i] ;
                  IPulseLeak := (IPulseLeak / (i1 - i0 + 1 )) - IHoldLeak ;

                  if Abs(VLeakStep) > VLimit then GLeak := IPulseLeak / VLeakStep
                                             else GLeak := 0.0 ;

                  for i := 0 to RawFH.NumSamples-1 do
                      ITest^[i] := ITest^[i] - GLeak*(VTest^[i] - VHoldTest) ;
                  end ;

               {Get data from last TEST record }
               GetRecord( RawfH, RH, LastTestRecord, ADC^ ) ;

               { Replace current channel }
               IScale := Channel[cbCurrent.ItemIndex].ADCScale ;

               // Zero levels
               if rbAutoScaling.Checked then begin
                  { Use levels under VHold cursor as zero references }
                  IZero := ADC^[VHoldCursor*RawFH.NumChannels + IOffset] ;
                  end
               else begin
                  // Use currently selected zero levels
                  IZero := Channel[cbCurrent.ItemIndex].ADCZero ;
                  end ;

               j := Channel[cbCurrent.ItemIndex].ChannelOffset ;
               for i := 0 to RawFH.NumSamples-1 do begin
                   ADC^[j] := Trunc( ITest^[i]/IScale ) + IZero ;
                   j := j + RawFH.NumChannels ;
                   end ;

               { Save record to leak subtracted record file  }
               Inc(LeakfH.NumRecords) ;
               RH.AnalysisAvailable := false ;
               RH.EqnType := None ;
               PutRecord( LeakfH, RH, LeakfH.NumRecords, ADC^ ) ;
               end ;
            end ;

         Inc(Rec) ;
         // Report progress
         Main.StatusBar.SimpleText := format(
         ' Leak current subtraction : %d/%d (%d leak-subtracted records created)',
         [Rec,EndAtRec,LeakfH.NumRecords]) ;


         { Terminate the job if that was the last record }
         if (Rec > EndAtRec) or bDoSubtraction.Enabled then Done := True ;

         end ;

     // Final report
     Main.StatusBar.SimpleText := format(
     ' Leak current subtraction : %d-%d (%d leak-subtracted records created)',
     [StartAtRec,EndAtRec,LeakfH.NumRecords]) ;

     { Save file header of leak subtraction file }
     SaveHeader( LeakfH ) ;
     Screen.Cursor := crDefault ;
     bAbort.enabled := False ;
     bDoSubtraction.enabled := True ;
     { Close window }
     Close ;

     end ;


procedure TLeakSubFrm.FormClose(Sender: TObject; var Action: TCloseAction);
{ -------------------
  Close form and exit
  -------------------}
begin

     if (LeakFH.NumRecords > 0) and (LeakFH.FileName <> '') then begin
        Main.mnShowLeakSubtracted.visible := True ;
        Main.mnShowLeakSubtracted.enabled := True ;
        Main.mnShowLeakSubtracted.Click ;
        end ;

     { Update current/voltage channel settings }
     Settings.SealTest.CurrentChannel := cbCurrent.ItemIndex ;
     Settings.SealTest.VoltageChannel := cbVoltage.ItemIndex ;

     Action := caFree ;
     end;


procedure TLeakSubFrm.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin

    ADC := Nil ;
    ITest := Nil ;
    VTest := Nil ;
    ILeak := Nil ;
    VLeak := Nil ;

    end;


procedure TLeakSubFrm.FormDestroy(Sender: TObject);
// ------------------------------
// Tidy up when form is destroyed
// ------------------------------
begin

    if ADC <> Nil then FreeMem(ADC) ;
    if ITest = Nil then FreeMem(ITest) ;
    if VTest = Nil then FreeMem(VTest) ;
    if ILeak = Nil then FreeMem(ILeak) ;
    if VLeak = Nil then FreeMem(VLeak) ;

    end;


procedure TLeakSubFrm.bAbortClick(Sender: TObject);
begin
     bDoSubtraction.Enabled := True ;
     end;


procedure TLeakSubFrm.ckBadRecordClick(Sender: TObject);
{ ------------------------------------------------
  Save new record ACCEPTED/REJECTED status to file
  ------------------------------------------------}
begin
     if ckBadRecord.checked then RH.Status := 'REJECTED'
                            else RH.Status := 'ACCEPTED' ;
     PutRecordHeaderOnly( RawfH, RH, RawfH.RecordNum ) ;
     end;


procedure TLeakSubFrm.cbRecordTypeChange(Sender: TObject);
{ -----------------------------
  Save new record type to file
  ----------------------------}
begin
     RH.RecType := cbRecordType.text ;
     PutRecordHeaderOnly( RawfH, RH, RawfH.RecordNum ) ;
     end;


procedure TLeakSubFrm.EdGroupKeyPress(Sender: TObject; var Key: Char);
{ ------------------------------------
  Save new record group number to file
  ------------------------------------}
begin
     if Key = chr(13) then begin
        RH.Number := Round(Edgroup.Value) ;
        PutRecordHeaderOnly( RawfH, RH, RawfH.RecordNum ) ;
        end ;
     end;


procedure TLeakSubFrm.cbVoltageChange(Sender: TObject);
begin
     InitialiseDisplay ;
     DisplayRecord ;
     end;

procedure TLeakSubFrm.cbCurrentChange(Sender: TObject);
begin
     InitialiseDisplay ;
     DisplayRecord ;
     end;

procedure TLeakSubFrm.rbFileModeClick(Sender: TObject);
// ---------------------------------
// Select file leak subtraction mode
// ---------------------------------
begin
     ckSaveLeaks.Enabled := True ;

     rbSubtractILeakOnly.Enabled := True ;

     end;


procedure TLeakSubFrm.rbGroupModeClick(Sender: TObject);
// -----------------------------------
// Select group leak subtraction mode
// -----------------------------------
begin
     ckSaveLeaks.Enabled := false ;
     ckSaveLeaks.Checked := false ;

     rbSubtractWholeLeakCurrent.Checked := True ;
     rbSubtractILeakOnly.Checked := False ;
     rbSubtractILeakOnly.Enabled := False ;

     end;


procedure TLeakSubFrm.scDisplayCursorChange(Sender: TObject);
{ -------------------------------------
  Update cursor labels when mouse moved
  ------------------------------------- }
var
   ch : Integer ;
begin
     
     for ch := 0 to scDisplay.NumChannels-1 do if scDisplay.ChanVisible[ch] then begin
         Channel[Ch].yMin := scDisplay.YMin[Ch] ;
         Channel[Ch].yMax := scDisplay.YMax[Ch] ;
         // Fix baseline if required
         if Settings.FixedZeroLevels or (Channel[ch].ADCZeroAt >= 0) then begin
            if scDisplay.HorizontalCursors[ch] <> Channel[ch].ADCZero then begin
               scDisplay.HorizontalCursors[ch] := Channel[ch].ADCZero ;
               end ;
            end
         else Channel[ch].ADCZero := Round(scDisplay.HorizontalCursors[ch]) ;

         end ;

     end ;


procedure TLeakSubFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
     scDisplay.MaxADCValue := RawFH.MaxADCValue ;
     scDisplay.MinADCValue := RawFH.MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;

     scDisplay.Invalidate ;
     end ;


procedure  TLeakSubFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := RawFH.MaxADCValue ;
     scDisplay.MinADCValue := RawFH.MinADCValue ;
     scDisplay.ZoomOut ;
     end ;


procedure TLeakSubFrm.FormResize(Sender: TObject);
// -----------------------------------------------
// Update control positions when form size changed
// -----------------------------------------------
var
   Bottom : Integer ;
begin

     Bottom := ClientHeight - 5 ;
     AnalysisGrp.Height := Bottom - AnalysisGrp.Top ;
     ModeGrp.Top := Bottom - ModeGrp.Height ;
     ScalingGrp.Top := ModeGrp.Top ;
     SubtractGrp.Top := ModeGrp.Top ;

     ckFixedZeroLevels.Left := scDisplay.left ;
     ckFixedZeroLevels.Top := ModeGrp.Top - 5 - ckFixedZeroLevels.Height ;
     scDisplay.Height := Max( ckFixedZeroLevels.Top - scDisplay.Top -1,2) ;

     scDisplay.Width := Max( ClientWidth - scDisplay.Left - 5,2 ) ;

     end;

procedure TLeakSubFrm.scDisplayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
              Channel[scDisplay.ActiveHorizontalCursor].ADCZero := Round(
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor]) ;
              end
           else begin
              // Baseline level computed from record (return to computed level)
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor] :=
              Channel[scDisplay.ActiveHorizontalCursor].ADCZero ;
              scDisplay.Invalidate ;
              end ;
           SaveHeader( LeakfH ) ;
           end ;
        end ;
     edGroup.SetFocus ;
     end ;

procedure TLeakSubFrm.FormKeyDown(Sender: TObject; var Key: Word;
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


procedure TLeakSubFrm.rbFixedScalingClick(Sender: TObject);
// ----------------------------------
// Fixed leak scaling option selected
// ----------------------------------
begin
     rbSubtractILeakOnly.Enabled := False ;
     rbSubtractWholeLeakCurrent.Checked := True ;
     end;

procedure TLeakSubFrm.rbAutoScalingClick(Sender: TObject);
// ----------------------------------
// Leak scaling by voltage option selected
// ----------------------------------
begin
     rbSubtractILeakOnly.Enabled := True ;
     end;

procedure TLeakSubFrm.FormActivate(Sender: TObject);
begin
    ckFixedZeroLevels.Checked := Settings.FixedZeroLevels ;
    end;

procedure TLeakSubFrm.ckFixedZeroLevelsClick(Sender: TObject);
begin
     Settings.FixedZeroLevels := ckFixedZeroLevels.Checked ;
     end;

Initialization

     OldNumChannels := 0 ;
end.
