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
  26.05.22 .. ZeroFrm now settings Channel record zero level settings directly
  ===================================================================}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, maths,
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

uses mdiform, Zero , WCPFIleUnit;

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
     cbCurrent.items := WCPFile.ChannelNames ;
     cbCurrent.ItemIndex := Min(WCPFile.Settings.SealTest.CurrentChannel,WCPFile.RawFH.NumChannels-1) ;
     cbVoltage.items := WCPFile.ChannelNames ;
     cbVoltage.ItemIndex := Min(WCPFile.Settings.SealTest.VoltageChannel,WCPFile.RawFH.NumChannels-1) ;

     cbRecordType.Items := WCPFile.RecordTypes ;

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
var
    np : Integer ;
begin

     // Reallocate buffers
     np := WCPFile.RawFH.NumSamples*WCPFile.RawFH.NumChannels ;
     if ADC <> Nil then FreeMem(ADC) ;
     GetMem( ADC, Max(np*2,1024))  ;
     if ITest <> Nil then FreeMem(ITest) ;
     GetMem( ITest, Max(np*4,1024) ) ;
     if VTest <> Nil then FreeMem(VTest) ;
     GetMem( VTest, Max(np*4,1024) ) ;
     if ILeak <> Nil then FreeMem(ILeak) ;
     GetMem( ILeak, Max(np*4,1024) ) ;
     if VLeak <> Nil then FreeMem(VLeak) ;
     GetMem( VLeak, Max(np*4,1024) ) ;

     if WCPFile.RawFH.Numrecords > 0 then begin

        WCPFile.RawFH.RecordNum := 1 ;
        WCPFile.UpdateScrollBar( sbRecordNum, WCPFile.RawFH.RecordNum, 1, WCPFile.RawfH.NumRecords ) ;

        edRange.LoLimit := 1 ;
        edRange.LoValue := 1 ;
        edRange.HiLimit := WCPFile.RawFH.NumRecords ;
        edRange.HiValue := WCPFile.RawFH.NumRecords ;

        { If there is only one channel in the file ... disable automatic voltage scaling }
        if WCPFile.RawFH.NumChannels < 2 then begin
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
     scDisplay.MaxADCValue := WCPFile.RawFH.MaxADCValue ;
     scDisplay.MinADCValue := WCPFile.RawFH.MinADCValue ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;

     scDisplay.MaxPoints := WCPFile.RawFH.NumSamples ;
     scDisplay.NumPoints := WCPFile.RawFH.NumSamples ;
     scDisplay.NumChannels := WCPFile.RawFH.NumChannels ;
     { Set channel information }
     for ch := 0 to scDisplay.NumChannels-1 do begin
         scDisplay.ChanOffsets[ch] := WCPFile.Channel[ch].ChannelOffset ;
         scDisplay.ChanUnits[ch] := WCPFile.Channel[Ch].ADCUnits ;
         scDisplay.ChanName[ch] := WCPFile.Channel[Ch].ADCName ;
         scDisplay.ChanScale[ch] := WCPFile.Channel[ch].ADCScale ;
         // If the number of channels has changed, zoom out display
         if OldNumChannels <> scDisplay.NumChannels then begin
            WCPFile.Channel[ch].yMin := Main.SESLabIO.ADCMinValue ;
            WCPFile.Channel[ch].yMax := Main.SESLabIO.ADCMaxValue ;
            end ;
         scDisplay.yMin[ch] := WCPFile.Channel[Ch].yMin ;
         scDisplay.yMax[ch] := WCPFile.Channel[Ch].yMax ;
         if (ch = cbCurrent.ItemIndex) or
            (ch = cbVoltage.ItemIndex) then scDisplay.ChanVisible[ch] := True
                                       else scDisplay.ChanVisible[ch] := False ;
         end ;
     OldNumChannels := scDisplay.NumChannels ;

     scDisplay.xMin := 0 ;
     scDisplay.xMax := scDisplay.MaxPoints - 1 ;

     { Remove all cursors }
     scDisplay.ClearHorizontalCursors ;
     scDisplay.ClearVerticalCursors ;

     { Current channel baseline }
     Cursors.IBase := scDisplay.AddHorizontalCursor(
                      cbCurrent.ItemIndex,
                      WCPFile.Settings.Colors.Cursors,
                      True,
                      'z') ;
     scDisplay.HorizontalCursors[Cursors.IBase] := WCPFile.Channel[cbCurrent.ItemIndex].ADCZero ;


     { Add voltage channel cursors only if more than one channel available }
     if WCPFile.RawFH.NumChannels > 1  then begin

        { Voltage channel baseline }
        Cursors.VBase := scDisplay.AddHorizontalCursor(
                         cbVoltage.ItemIndex,
                         WCPFile.Settings.Colors.Cursors,
                         True,
                         'z') ;
        scDisplay.HorizontalCursors[Cursors.VBase] := WCPFile.Channel[cbVoltage.ItemIndex].ADCZero ;

        { Holding voltage measurement position }
        Cursors.VHold := scDisplay.AddVerticalCursor(AllChannels,WCPFile.Settings.Colors.Cursors,'VHold') ;
        scDisplay.VerticalCursors[Cursors.VHold] := 1 ;

        { Test voltage measurement position }
        Cursors.VTest := scDisplay.AddVerticalCursor(AllChannels,WCPFile.Settings.Colors.Cursors,'VTest') ;
        scDisplay.VerticalCursors[Cursors.VTest] := WCPFile.RawFH.NumSamples div 2 ;

        end ;

     scDisplay.xOffset := 0 ;
     scDisplay.TScale := WCPFile.RawFH.dt*WCPFile.Settings.TScale ;
     scDisplay.TUnits := WCPFile.Settings.TUnits ;

     end ;


procedure TLeakSubFrm.DisplayRecord ;
{ ===============================
  Display digitised signal record
  ===============================}
var
    ch : Integer ;
begin

     if ADC = Nil then Exit ;

     WCPFile.RawfH.RecordNum := SbRecordNum.position ;

     { Read record data from file }
     WCPFile.GetRecord( WCPFile.RawfH, RH, WCPFile.RawfH.RecordNum, ADC^ ) ;

     for ch := 0 to WCPFile.RawFH.NumChannels-1 do begin
         // Zero level
         scDisplay.HorizontalCursors[ch] := WCPFile.Channel[ch].ADCZero ;
         // Start of area from which zero level was computed (-1 indicates fixed zero level)
         scDisplay.ChanZeroAt[ch] := WCPFile.Channel[ch].ADCZeroAt ;
         // Signal scaling factor
         scDisplay.ChanScale[ch] := WCPFile.Channel[ch].ADCScale ;
         end ;
     // No. of samples in zero level area
     scDisplay.ChanZeroAvg := WCPFile.RawFH.NumZeroAvg ;


     scDisplay.SetDataBuf( ADC ) ;

     edRecordNum.HiLimit := WCPFile.RawfH.NumRecords ;
     edRecordNum.HiValue := WCPFile.RawfH.NumRecords ;
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
     OldHandle := WCPFile.LeakFH.FileHandle ;
     WCPFile.LeakfH := WCPFile.RawfH ;
     WCPFile.LeakFH.FileHandle := OldHandle ;

     { The averages data file name has the same name as the original file
       but with the extension .sub }
     WCPFile.LeakfH.FileName := ChangeFileExt( WCPFile.RawfH.FileName, '.sub' ) ;
     { Create file to hold averages }
     WCPFile.FileCloseSafe(  WCPFile.LeakFH.FileHandle ) ;
     WCPFile.LeakfH.FileHandle := FileCreate( WCPFile.LeakfH.FileName ) ;
     { Save header block and request subtractions to start}
     if WCPFile.LeakfH.FileHandle >= 0 then begin
           WCPFile.LeakfH.NumRecords := 0 ;
           WCPFile.SaveHeader( WCPFile.LeakfH ) ;
           end
     else ShowMessage( 'FileCreate Error ='+ IntToStr(WCPFile.LeakfH.FileHandle));

     { Current and voltage channel offsets into ADC buffer }
     IOffset := WCPFile.Channel[cbCurrent.ItemIndex].ChannelOffset;
     VOffset := WCPFile.Channel[cbVoltage.ItemIndex].ChannelOffset;

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
            WCPFile.GetRecord( WCPFile.RawfH, RH, Rec, ADC^ ) ;

            { If record is LEAK type and ACCEPTED ... add it to average }
            if (RH.Status = 'ACCEPTED') and (RH.RecType = 'LEAK' ) then begin

               { Current and voltage scaling factors }
               IScale := WCPFile.Channel[cbCurrent.ItemIndex].ADCScale ;
               VScale := WCPFile.Channel[cbVoltage.ItemIndex].ADCScale ;

               if rbAutoScaling.Checked then begin
                  { Use levels under VHold cursor as zero references
                    when voltage scaling is in use}
                  IZero := ADC^[Round(scDisplay.VerticalCursors[Cursors.VHold])*WCPFile.RawFH.NumChannels
                           + IOffset] ;
                  VZero := ADC^[Round(scDisplay.VerticalCursors[Cursors.VHold])*WCPFile.RawFH.NumChannels
                           + VOffset] ;
                  end
               else begin
                  // Use currently selected zero levels
                  IZero := WCPFile.Channel[cbCurrent.ItemIndex].ADCZero ;
                  VZero := WCPFile.Channel[cbVoltage.ItemIndex].ADCZero ;
                  end ;

               { Add current and voltage channels to summation buffers }
                j := 0 ;
                for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
                    if nLeak = 0 then begin
                       ILeak^[i] := 0. ;
                       VLeak^[i] := 0. ;
                       end ;
                    ILeak^[i] := ILeak^[i] + IScale*(ADC^[j+IOffset] - IZero) ;
                    VLeak^[i] := VLeak^[i] + VScale*(ADC^[j+VOffset] - VZero) ;
                    j := j + WCPFile.RawFH.NumChannels ;
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
              for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
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
         WCPFile.GetRecord( WCPFile.RawfH, RH, Rec, ADC^ ) ;
         GroupNumber := RH.Number ;

         { Only use records marked by user as 'ACCEPTED' }
         if RH.Status = 'ACCEPTED' then begin

            if ckSaveLeaks.checked or (RH.RecType <> 'LEAK') then begin
               { *** TEST records *** }
               LastTestRecord := Rec ;
               { Current and voltage scaling factors }
               IScale := WCPFile.Channel[cbCurrent.ItemIndex].ADCScale ;
               VScale := WCPFile.Channel[cbVoltage.ItemIndex].ADCScale ;

               if rbAutoScaling.Checked then begin
                  { Use levels under VHold cursor as zero references }
                  IZero := ADC^[VHoldCursor*WCPFile.RawFH.NumChannels + IOffset] ;
                  VZero := ADC^[VHoldCursor*WCPFile.RawFH.NumChannels + VOffset] ;
                  end
               else begin
                  // Use currently selected zero levels
                  IZero := WCPFile.Channel[cbCurrent.ItemIndex].ADCZero ;
                  VZero := WCPFile.Channel[cbVoltage.ItemIndex].ADCZero ;
                  end ;

               { Add current and voltage channels to summation buffers }
               j := 0 ;
               for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
                   if nTest = 0 then begin
                      ITest^[i] := 0. ;
                      VTest^[i] := 0. ;
                      end ;
                   ITest^[i] := ITest^[i] + IScale*(ADC^[j+IOffset] - IZero) ;
                   VTest^[i] := VTest^[i] + VScale*(ADC^[j+VOffset] - VZero) ;
                   j := j + WCPFile.RawFH.NumChannels ;
                   end ;

               Inc( nTest ) ;
               end
            else if rbGroupMode.checked then begin

               { *** LEAK records *** }

               { Current and voltage scaling factors }
               IScale := WCPFile.Channel[cbCurrent.ItemIndex].ADCScale ;
               VScale := WCPFile.Channel[cbVoltage.ItemIndex].ADCScale ;

               // Zero levels
               if rbAutoScaling.Checked then begin
                  { Use levels under VHold cursor as zero references }
                  IZero := ADC^[VHoldCursor*WCPFile.RawFH.NumChannels + IOffset] ;
                  VZero := ADC^[VHoldCursor*WCPFile.RawFH.NumChannels + VOffset] ;
                  end
               else begin
                  // Use currently selected zero levels
                  IZero := WCPFile.Channel[cbCurrent.ItemIndex].ADCZero ;
                  VZero := WCPFile.Channel[cbVoltage.ItemIndex].ADCZero ;
                  end ;

               j := 0 ;
               for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
                   if nLeak = 0 then begin
                      ILeak^[i] := 0. ;
                      VLeak^[i] := 0 ;
                      end ;
                   ILeak^[i] := ILeak^[i] + IScale*(ADC^[j+IOffset] - IZero) ;
                   VLeak^[i] := VLeak^[i] + VScale*(ADC^[j+VOffset] - VZero) ;
                   j := j + WCPFile.RawFH.NumChannels ;
                   end ;
               Inc( nLeak ) ;
               end ;
            end ;

         { Is this record the last in its group or the last in the file }
         if Rec >= EndAtRec then SaveRecord := True
         else begin
            WCPFile.GetRecordHeaderOnly( WCPFile.RawfH, RH, Rec+1 ) ;
            if RH.Number <> GroupNumber then SaveRecord := True
                                        else SaveRecord := False ;
            end ;

         if SaveRecord then begin

            { If in Group-mode leak subtraction ... average leak record }

            if (nTest > 0) and (nLeak > 0) then OK := True
                                           Else OK := False ;
            if rbGroupMode.checked then begin
               if nLeak > 0 then begin
                  for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
                    VLeak^[i] := VLeak^[i] / nLeak ;
                    ILeak^[i] := ILeak^[i] / nLeak ;
                    end ;
                  nLeak := 0 ;
                  end ;
               end ;

            { Average test records }
            if nTest > 0 then begin
               for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
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
               i1 := Min( VHoldCursor + nAvg - 1,
                          WCPFile.RawFH.NumSamples-1)  ;
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
               i1 := Min(VTestCursor + nAvg - 1,
                           WCPFile.RawFH.NumSamples-1)  ;
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
                  for i := 0 to WCPFile.RawFH.NumSamples-1 do
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
                        (i1 < (WCPFile.RawFH.NumSamples-1)) do Inc(i1) ;
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
                        (i1 < (WCPFile.RawFH.NumSamples-1)) do Inc(i1) ;
                  i1 := i1 - ((i1-i0) div 10) ;
                  IPulseLeak := 0.0 ;
                  for i := i0 to i1 do IPulseLeak := IPulseLeak + ILeak^[i] ;
                  IPulseLeak := (IPulseLeak / (i1 - i0 + 1 )) - IHoldLeak ;

                  if Abs(VLeakStep) > VLimit then GLeak := IPulseLeak / VLeakStep
                                             else GLeak := 0.0 ;

                  for i := 0 to WCPFile.RawFH.NumSamples-1 do
                      ITest^[i] := ITest^[i] - GLeak*(VTest^[i] - VHoldTest) ;
                  end ;

               {Get data from last TEST record }
               WCPFile.GetRecord( WCPFile.RawfH, RH, LastTestRecord, ADC^ ) ;

               { Replace current channel }
               IScale := WCPFile.Channel[cbCurrent.ItemIndex].ADCScale ;

               // Zero levels
               if rbAutoScaling.Checked then begin
                  { Use levels under VHold cursor as zero references }
                  IZero := ADC^[VHoldCursor*WCPFile.RawFH.NumChannels + IOffset] ;
                  end
               else begin
                  // Use currently selected zero levels
                  IZero := WCPFile.Channel[cbCurrent.ItemIndex].ADCZero ;
                  end ;

               j := WCPFile.Channel[cbCurrent.ItemIndex].ChannelOffset ;
               for i := 0 to WCPFile.RawFH.NumSamples-1 do begin
                   ADC^[j] := Trunc( ITest^[i]/IScale ) + IZero ;
                   j := j + WCPFile.RawFH.NumChannels ;
                   end ;

               { Save record to leak subtracted record file  }
               Inc(WCPFile.LeakfH.NumRecords) ;
               RH.AnalysisAvailable := false ;
               RH.EqnType := None ;
               WCPFile.PutRecord( WCPFile.LeakfH, RH, WCPFile.LeakfH.NumRecords, ADC^ ) ;
               end ;
            end ;

         Inc(Rec) ;
         // Report progress
         Main.StatusBar.SimpleText := format(
         ' Leak current subtraction : %d/%d (%d leak-subtracted records created)',
         [Rec,EndAtRec,WCPFile.LeakfH.NumRecords]) ;


         { Terminate the job if that was the last record }
         if (Rec > EndAtRec) or bDoSubtraction.Enabled then Done := True ;

         end ;

     // Final report
     Main.StatusBar.SimpleText := format(
     ' Leak current subtraction : %d-%d (%d leak-subtracted records created)',
     [StartAtRec,EndAtRec,WCPFile.LeakfH.NumRecords]) ;

     { Save file header of leak subtraction file }
     WCPFile.SaveHeader( WCPFile.LeakfH ) ;
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

     if (WCPFile.LeakFH.NumRecords > 0) and (WCPFile.LeakFH.FileName <> '') then begin
        Main.mnShowLeakSubtracted.visible := True ;
        Main.mnShowLeakSubtracted.enabled := True ;
        Main.mnShowLeakSubtracted.Click ;
        end ;

     { Update current/voltage channel settings }
     WCPFile.Settings.SealTest.CurrentChannel := cbCurrent.ItemIndex ;
     WCPFile.Settings.SealTest.VoltageChannel := cbVoltage.ItemIndex ;

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
     WCPFile.PutRecordHeaderOnly( WCPFile.RawfH, RH, WCPFile.RawfH.RecordNum ) ;
     end;


procedure TLeakSubFrm.cbRecordTypeChange(Sender: TObject);
{ -----------------------------
  Save new record type to file
  ----------------------------}
begin
     RH.RecType := cbRecordType.text ;
     WCPFile.PutRecordHeaderOnly( WCPFile.RawfH, RH, WCPFile.RawfH.RecordNum ) ;
     end;


procedure TLeakSubFrm.EdGroupKeyPress(Sender: TObject; var Key: Char);
{ ------------------------------------
  Save new record group number to file
  ------------------------------------}
begin
     if Key = chr(13) then begin
        RH.Number := Round(Edgroup.Value) ;
        WCPFile.PutRecordHeaderOnly( WCPFile.RawfH, RH, WCPFile.RawfH.RecordNum ) ;
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


procedure TLeakSubFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
     scDisplay.MaxADCValue := WCPFile.RawFH.MaxADCValue ;
     scDisplay.MinADCValue := WCPFile.RawFH.MinADCValue ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;

     scDisplay.Invalidate ;
     end ;


procedure  TLeakSubFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := WCPFile.RawFH.MaxADCValue ;
     scDisplay.MinADCValue := WCPFile.RawFH.MinADCValue ;
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
           WCPFile.SaveHeader( WCPFile.LeakfH ) ;
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
    ckFixedZeroLevels.Checked := WCPFile.Settings.FixedZeroLevels ;
    end;

procedure TLeakSubFrm.ckFixedZeroLevelsClick(Sender: TObject);
begin
     WCPFile.Settings.FixedZeroLevels := ckFixedZeroLevels.Checked ;
     end;

Initialization

     OldNumChannels := 0 ;
end.
