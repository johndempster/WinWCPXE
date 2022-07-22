unit Qanal;
{ ======================================================
  WinWCP - Quantal Analysis Module (c) J. Dempster 1996
  18/2/98 ... Now has All Record/Range radio buttons
  15/7/99 V3.0 ... Converted to 32 bit (Delphi V3.0)
  25/1/99 V3.0.5 ... Potential correction calculation fixed
01.01.04 .. Out of memory error blocked when windows resized to tiny size
  15/11/21 .. Error in variance calculation when non-linear summation
              correction in use fixed. Variance is now corrected for nls
              as well as mean endplate potential amplitude.
  16.11.21 .. Settings now saved in Settings.QuantalAnalysis

  ======================================================}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, printers,
  ValEdit, RangeEdit, ValidatedEdit, seslabio, math, WCPFIleUnit ;

type
  TQuantFrm = class(TForm)
    ControlGrp: TGroupBox;
    bDoAnalysis: TButton;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    cbEvokedType: TComboBox;
    MiniGrp: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbMiniType: TComboBox;
    rbMiniEventsAvailable: TRadioButton;
    rbUserEntered: TRadioButton;
    ModeGrp: TGroupBox;
    rbCurrent: TRadioButton;
    rbPotentials: TRadioButton;
    Label1: TLabel;
    rbPoisson: TRadioButton;
    rbBinomial: TRadioButton;
    Label6: TLabel;
    Label7: TLabel;
    mmResults: TMemo;
    GroupBox8: TGroupBox;
    rbAllRecords: TRadioButton;
    rbRange: TRadioButton;
    cbChannel: TComboBox;
    Label8: TLabel;
    edRecRange: TRangeEdit;
    edMiniAmplitude: TValidatedEdit;
    edMiniStDev: TValidatedEdit;
    edVRest: TValidatedEdit;
    edVRev: TValidatedEdit;
    edCorrectionFactor: TValidatedEdit;
    procedure bDoAnalysisClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbUserEnteredClick(Sender: TObject);
    procedure rbMiniEventsAvailableClick(Sender: TObject);
    procedure rbCurrentClick(Sender: TObject);
    procedure rbPotentialsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cbChannelChange(Sender: TObject);
  private
    { Private declarations }
    function UseRecord ( const RecH : TRecHeader ; RecType : string ) : Boolean ;
  public
    { Public declarations }
    procedure PrintResults ;
  end;

var
  QuantFrm: TQuantFrm;

implementation
{$R *.DFM}

uses MDIForm,measure,maths ;


procedure TQuantFrm.FormShow(Sender: TObject);
{ ---------------
  Initialise form
  ---------------}
begin

     { Type of record containing evoked signals }
     cbEvokedType.items := WCPFile.RecordTypes ;
     cbEvokedType.itemIndex := cbEvokedType.items.IndexOf(WCPFile.Settings.QuantalAnalysis.EvokedType) ;

     { Type of record containing spontaneous miniature signals }
     cbMiniType.items := WCPFile.RecordTypes ;
     cbMiniType.itemIndex := cbMiniType.items.IndexOf(WCPFile.Settings.QuantalAnalysis.MiniType) ;

     // Current/potential analysis flag
     rbPotentials.Checked := WCPFile.Settings.QuantalAnalysis.Potentials ;

     edRecRange.HiLimit := WCPFile.fH.NumRecords ;
     edRecRange.HiValue := WCPFile.fH.NumRecords ;
     edRecRange.LoLimit := 1 ;
     edRecRange.LoValue := 1 ;

     cbChannel.items := WCPFile.ChannelNames ;
     if cbChannel.ItemIndex < 0 then cbChannel.ItemIndex := 0 ;

     { Set units for manual entry of mini amplitude/st. dev. }
     edMiniAmplitude.Units := WCPFile.Channel[cbChannel.ItemIndex].ADCUnits ;
     edMiniStDev.Units := WCPFile.Channel[cbChannel.ItemIndex].ADCUnits ;

     ClientWidth := ModeGrp.Left + ModeGrp.Width + 5 ;
     ClientHeight := ModeGrp.Top + ModeGrp.Height + 5 ;

     end;


procedure TQuantFrm.bDoAnalysisClick(Sender: TObject);
{---------------------------
 Do quantal content analysis
 ---------------------------}
const
     VDriveLimit = 1E-3 ;
type
TSignal = record
        Sum : single ;
        Mean : single ;
        SD : single ;
        Variance : single ;
        Num : LongInt ;
        end ;
TQuantalContent = record
                Direct : single ;
                Variance : single ;
                Failures : single ;
                end ;

var
   Rec,RecStart,RecEnd : LongInt ;
   UseCh,i : Integer ;
   Evoked : TSignal ;
   EvokedUncorrected : TSignal ;
   QuantalContent : TQuantalContent ;
   Mini : TSignal ;
   NumFailures,NumInvalid : LongInt ;
   x,VRest,VReversal,VDrive,CorrectionFactor : single ;
   ReleaseProbability,PoolSize,Denom : single ;
   Units : string ;
   rH : TRecHeader ;
   Peak : PSingleArray ;

begin

     { Determine record range/channels to be plotted }
     if rbAllRecords.Checked then
        begin
        RecStart := 1 ;
        RecEnd := WCPFIle.FH.NumRecords ;
        end
     else
        begin
        RecStart := Round(edRecRange.LoValue) ;
        RecEnd := Round(edRecRange.HiValue) ;
        end ;

     UseCh := cbChannel.ItemIndex ;
     Units := WCPFile.Channel[UseCh].ADCUnits ;
     mmResults.Clear ;
     mmResults.Lines.Add('Quantal Analysis') ;

     { ** Calculate average of peak evoked and mini signals ** }

     Evoked.Sum := 0. ;
     EvokedUncorrected.Sum := 0.0 ;
     Evoked.Num := 0 ;
     EvokedUncorrected.Num := 0 ;
     Mini.Sum := 0. ;
     Mini.Num := 0 ;
     NumFailures := 0 ;

     // Calculate driving force (not used in current analysis
     VRest := edVRest.Value ;
     VReversal := edVRev.Value ;
     VDrive := VRest - VReversal ;
     CorrectionFactor := edCorrectionFactor.Value ;

     // Assign array to hold corrected EPC peak
     GetMem( Peak, WCPFIle.FH.NumRecords*Sizeof(Single));

     NumInvalid := 0 ;
     for Rec := RecStart to RecEnd do
         begin

         { Read record analysis block from file }
         WCPFile.GetRecordHeaderOnly( WCPFIle.fH, RH, Rec ) ;

         // Get peak value
         Peak[Rec] := RH.Value[UseCh*MaxAnalysisVariables+vPeak] ;

         { Add evoked peak to sum }
         if UseRecord(RH, cbEvokedType.text)  then
            begin
            { Correct potentials for non-linear summation }
            EvokedUncorrected.Sum := EvokedUncorrected.Sum + Peak[Rec] ;
            if rbPotentials.checked and (Abs(VDrive) > VDriveLimit) then begin
               Denom := 1.0 - Abs((CorrectionFactor*Peak[Rec])/VDrive) ;
               if Denom >= 0.0 then Peak[Rec] := Peak[Rec]/Denom
                               else Inc(NumInvalid) ;
               end ;
            Evoked.Sum := Evoked.Sum + Peak[Rec] ;
            Inc(Evoked.Num) ;
            end ;

         { Add spontaneous peak to sum }
         if UseRecord( RH, cbMiniType.text ) then begin
            Mini.Sum := Mini.Sum + Peak[Rec] ;
            Inc(Mini.Num) ;
            end ;

         { Number of stimulations which failed to evoked a post-synaptic signal }
         if UseRecord( RH, 'FAIL' ) then begin
            Inc(NumFailures) ;
            Inc(Evoked.Num) ;
            end ;

         end ;

     // Calculate means
     Evoked.Mean := Evoked.Sum/Max(Evoked.Num,1) ;
     EvokedUncorrected.Mean := EvokedUncorrected.Sum/Max(Evoked.Num,1) ;
     Mini.Mean := Mini.Sum/Max(Mini.Num,1) ;

     { ** Calculate standard dev. of peak evoked and mini signals ** }

     Evoked.Sum := 0. ;
     Mini.Sum := 0. ;
     EvokedUncorrected.Sum := 0.0 ;
     for Rec := RecStart to RecEnd do
         begin

         { Read record analysis block from file }
         WCPFIle.GetRecordHeaderOnly( WCPFIle.fH, RH, Rec ) ;

         { Add evoked residual to S.D. summation }
         if UseRecord( RH, cbEvokedType.text ) then
            begin
            x := Peak[Rec] - Evoked.Mean ;
            Evoked.Sum := Evoked.Sum + x*x ;
            x := RH.Value[UseCh*MaxAnalysisVariables+vPeak] - EvokedUncorrected.Mean ;
            EvokedUncorrected.Sum := EvokedUncorrected.Sum + x*x ;
            end ;

         { Add spontaneous residual to sum }
         if UseRecord( RH, cbMiniType.text ) then
            begin
            x := Peak[Rec] - Mini.Mean ;
            Mini.Sum := Mini.Sum + x*x ;
            end ;

         end ;

     // Corrected variance/sd
     Evoked.Variance := Evoked.Sum/Max(Evoked.Num -1.0,1.0) ;
     Evoked.SD := Sqrt(Evoked.Variance) ;

     // Uncorrected variance/sd
     EvokedUncorrected.Variance := EvokedUncorrected.Sum/Max(Evoked.Num -1.0,1.0) ;
     EvokedUncorrected.SD := Sqrt(EvokedUncorrected.Variance) ;

     // Mini variance/sd
     Mini.Variance := Mini.Sum/Max(Mini.Num -1.0,1.0);
     Mini.SD := sqrt(Mini.Variance) ;

     { ** Report mean/st.dev of evoked signal amplitudes ** }

     if Evoked.Num > 0 then begin

        if rbPotentials.checked then begin
           mmResults.Lines.Add(format('Evoked potentials (n=%d)',[Evoked.Num])) ;
           mmResults.Lines.Add(
           format('VRest = %.3g %s  VRev. = %.3g %s  Cor. factor (f)= %.3g',
                  [VRest,Units,
                   VReversal,Units,
                   CorrectionFactor] ) ) ;
           { Invalid driving force warning }
           if Abs(VDrive) <= VDriveLimit then
              mmResults.Lines.Add(
              format('ERROR! Invalid driving force (VRest-VRev=%.1f)',[VDrive]));
           { Invalid records warning }
           if NumInvalid > 0 then
              mmResults.Lines.Add(format('%d invalid records!',[NumInvalid]));

           end
        else mmResults.Lines.Add(format('Evoked currents (n=%d)',[Evoked.Num])) ;

        if rbPotentials.checked then
           begin
           mmResults.Lines.add( format( 'Mean = %.3g (s.d. %.3g ) %s (nls corrected)',
                                        [Evoked.Mean,Evoked.SD,Units] )) ;
           mmResults.Lines.add( format( 'Mean = %.3g (s.d. %.3g ) %s (uncorrected)',
                                        [EvokedUncorrected.Mean,EvokedUncorrected.SD,Units] )) ;
           end
        else
          begin
          mmResults.Lines.add( format( 'Mean = %.3g (s.d. %.3g ) %s',
                                       [Evoked.Mean,Evoked.SD,Units] )) ;
          end ;

        end
     else begin
        if rbPotentials.checked then mmResults.Lines.add('No evoked potentials available!')
                                else mmResults.Lines.add('No evoked currents available!') ;
        end ;

     { Report mean/st.dev of miniature signal amplitudes }


     if rbMiniEventsAvailable.checked then begin
        mmResults.Lines.add( ' ' ) ;
        if rbPotentials.checked then
             mmResults.Lines.Add(format('Spontaneous miniature potentials (n=%d)',
                                         [Mini.Num]))
        else mmResults.Lines.Add(format('Spontaneous miniature currents (n=%d)',
                                       [Mini.Num])) ;

        if Mini.Num > 0 then
           begin
           mmResults.Lines.add( format( 'Mean = %.3g (s.d. %.3g ) %s',
                                        [Mini.Mean,Mini.SD,Units] )) ;
           end
        else mmResults.Lines.add( 'No minis available!' ) ;

        end
     else begin
          mmResults.Lines.add( ' ' ) ;
          if rbPotentials.checked then
               mmResults.Lines.Add('Spontaneous miniature potentials' )
          else mmResults.Lines.Add('Spontaneous miniature currents ') ;

          Mini.Mean := edMiniAmplitude.Value ;
          Mini.SD := edMiniStDev.Value ;
          Mini.Num := 1 ;

          if Mini.Mean <> 0. then
             begin
             mmResults.Lines.add( format( 'Mean = %.3g (s.d. %.3g) %s (user entered)',
                                          [Mini.Mean,Mini.SD,Units] )) ;
             Mini.Num := 1 ;
             end
          else mmResults.Lines.add( 'Invalid amplitude!' ) ;
          end ;

     mmResults.Lines.add( ' ' ) ;
     if (Evoked.Num > 0) and (Mini.Num > 0) and (Mini.Mean <> 0.0) then begin
        QuantalContent.Direct := Evoked.Mean / Mini.Mean ;
        mmResults.Lines.add( format( 'Quantal content = %.3g (direct method)',
                                     [QuantalContent.Direct] ) );
        end ;

     if (Evoked.Num > 0) and rbPoisson.checked then begin
        { Calculate quantal content by variance method
          (NB only valid for poisson distributions) }

        QuantalContent.Variance := (Evoked.Mean*Evoked.Mean)/Evoked.Variance ;
        mmResults.Lines.add( format( 'Quantal content = %.3g (variance method)',
                                     [QuantalContent.Variance] ) );

        if NumFailures > 0 then  begin
           QuantalContent.Failures := ln( (Evoked.Num+NumFailures)/NumFailures ) ;
           mmResults.Lines.add( format( 'Quantal content = %.3g (failures method)',
                                         [QuantalContent.Failures] ) );
           end ;
        end ;

     if (Evoked.Num > 0) and (Mini.Num > 0) and (not rbPoisson.checked) and
        (Abs(Mini.Mean) > 0. ) then
        begin
        ReleaseProbability := 1. - Evoked.Variance /
                                   (QuantalContent.Direct*Mini.Mean*Mini.Mean)
                                 + Mini.Variance/(Mini.Mean*Mini.Mean) ;
        PoolSize := QuantalContent.Direct / ReleaseProbability ;
        mmResults.Lines.add( ' ' ) ;
        mmResults.Lines.add( 'Binomial Analysis' ) ;
        mmResults.Lines.add( format( 'Release Probability = %.3g',
                                      [ReleaseProbability]));
        mmResults.Lines.add( format( 'Pool size = %.3g',[PoolSize]));

        end ;

     if (Evoked.Num = 0) and (Mini.Num = 0) then
        mmResults.Lines.add( 'No records available for analysis!' ) ;

     if (Evoked.Mean = 0.0) and (Mini.Mean = 0.0) then
        mmResults.Lines.add( 'NOTE! Peaks need to be measured using Waveform Measurements before quantal analysis.' ) ;

     { Copy results to log file }
     for i := 1 to mmResults.Lines.Count do WCPFile.WriteToLogFileNoDate( mmResults.Lines[i] ) ;

     Main.mnPrint.Enabled := True ;

     // Release memory
     FreeMem(Peak) ;

     // Save settings
     WCPFile.Settings.QuantalAnalysis.EvokedType := cbEvokedType.Text ;
     WCPFile.Settings.QuantalAnalysis.MiniType := cbMiniType.Text ;
     WCPFile.Settings.QuantalAnalysis.Potentials := rbPotentials.Checked ;

     end;


function TQuantFrm.UseRecord ( const RecH : TRecHeader ;
                                 RecType : string ) : Boolean ;
{ -----------------------------------------------------
  Select record for inclusion in quantal analysis
  -----------------------------------------------------}
begin
     if (RecH.Status = 'ACCEPTED') and RecH.AnalysisAvailable
        and ( (RecH.RecType = RecType) or ( RecType = 'ALL') ) then
        UseRecord := True
     else UseRecord := False ;
     end ;


procedure TQuantFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Main.mnPrint.Enabled := False ;
     Action := caFree ;
     end;

procedure TQuantFrm.rbUserEnteredClick(Sender: TObject);
begin
     edMiniAmplitude.enabled := True ;
     edMiniStDev.enabled := True ;
     cbMiniType.enabled := False ;
     end;

procedure TQuantFrm.rbMiniEventsAvailableClick(Sender: TObject);
begin
     edMiniAmplitude.enabled := False ;
     edMiniAmplitude.text := ' ' ;
     edMiniStDev.enabled := False  ;
     edMiniStDev.text := ' ' ;
     cbMiniType.enabled := True ;
     end;

procedure TQuantFrm.rbCurrentClick(Sender: TObject);
begin
     edVRev.enabled := False ;
     edVRest.enabled := False ;
     edCorrectionFactor.enabled := False ;
     end;

procedure TQuantFrm.rbPotentialsClick(Sender: TObject);
begin
     edVRev.enabled := True ;
     edVRest.enabled := True ;
     edCorrectionFactor.enabled := True ;
     end;


procedure TQuantFrm.PrintResults ;
{ -----------------------
  Print the results table
  -----------------------}
var
   CharWidth,CharHeight,Row : Integer ;
   PageLeft,PageTop,PageBottom,Line : Integer ;
   FontScale : Integer ;
begin

     Screen.Cursor := crHourglass ;

     { Set print font and size }
     Printer.Canvas.font.name := WCPFile.Settings.Plot.FontName ;
     FontScale := PrinterPointsToPixels(10) ;
     Printer.Canvas.font.Height := FontScale ;

     CharWidth := Printer.canvas.TextWidth('X') ;
     CharHeight := Printer.canvas.TextHeight('X') ;
     PageTop := CharHeight*5 ;
     PageBottom := printer.PageHeight - PageTop ;
     PageLeft := CharWidth*8 ;

     Printer.BeginDoc ;

     { Print resultys
       ===========}

     Line := PageTop ;
     printer.canvas.textout(PageLeft,Line, 'File ... ' + WCPFIle.fH.FileName ) ;
     Line := Line + CharHeight ;
     printer.canvas.textout(PageLeft,Line, WCPFIle.fH.IdentLine) ;
     Line := Line + CharHeight*2 ;

     for Row := 0 to mmResults.Lines.Count-1 do begin
         printer.canvas.textout( PageLeft, Line, mmResults.Lines[Row] ) ;
         Line := Line + CharHeight ;
         end ;

     Printer.EndDoc ;

     Screen.Cursor := crDefault ;

     end ;



procedure TQuantFrm.FormResize(Sender: TObject);
{ ------------------------------------------------------
  Adjust size/position of controls when form is re-sized
  ------------------------------------------------------ }
begin
      MiniGrp.Height := ClientHeight - MiniGrp.Top - 5 ;
      ModeGrp.Top := ClientHeight - ModeGrp.Height - 5 ;
      ModeGrp.Width := ClientWidth - ModeGrp.Left - 5 ;
      mmResults.Height := ModeGrp.Top - mmResults.Top - 5 ;
      mmResults.Width := ClientWidth - mmResults.Left - 5 ;
      end;


procedure TQuantFrm.cbChannelChange(Sender: TObject);
begin
     edMiniAmplitude.Units := WCPFile.Channel[cbChannel.ItemIndex].ADCUnits ;
     edMiniStDev.Units := WCPFile.Channel[cbChannel.ItemIndex].ADCUnits ;
     end;

end.
