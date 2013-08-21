unit Qanal;
{ ======================================================
  WinWCP - Quantal Analysis Module (c) J. Dempster 1996
  18/2/98 ... Now has All Record/Range radio buttons
  15/7/99 V3.0 ... Converted to 32 bit (Delphi V3.0)
  25/1/99 V3.0.5 ... Potential correction calculation fixed
01.01.04 .. Out of memory error blocked when windows resized to tiny size    
  ======================================================}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Global, Fileio, shared, printers, plotlib,
  ValEdit, RangeEdit, ValidatedEdit ;

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
uses MDIForm,measure ;


procedure TQuantFrm.FormShow(Sender: TObject);
{ ---------------
  Initialise form
  ---------------}
begin

     { Type of record containing evoked signals }
     cbEvokedType.items := RecordTypes ;
     cbEvokedType.itemIndex := cbEvokedType.items.IndexOf('TEST') ;
     { Type of record containing spontaneous miniature signals }
     cbMiniType.items := RecordTypes ;
     cbMiniType.itemIndex := cbMiniType.items.IndexOf('MINI') ;

     edRecRange.HiLimit := fH.NumRecords ;
     edRecRange.HiValue := fH.NumRecords ;
     edRecRange.LoLimit := 1 ;
     edRecRange.LoValue := 1 ;

     cbChannel.items := ChannelNames ;
     if cbChannel.ItemIndex < 0 then cbChannel.ItemIndex := 0 ;

     { Set units for manual entry of mini amplitude/st. dev. }
     edMiniAmplitude.Units := Channel[cbChannel.ItemIndex].ADCUnits ;
     edMiniStDev.Units := Channel[cbChannel.ItemIndex].ADCUnits ;

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
   QuantalContent : TQuantalContent ;
   Mini : TSignal ;
   NumFailures,NumInvalid : LongInt ;
   x,VRest,VReversal,VDrive,CorrectionFactor : single ;
   ReleaseProbability,PoolSize,Denom : single ;
   Units : string ;
   rH : TRecHeader ;
begin

     { Determine record range/channels to be plotted }
     if rbAllRecords.Checked then begin
        RecStart := 1 ;
        RecEnd := FH.NumRecords ;
        end
     else begin
        RecStart := Round(edRecRange.LoValue) ;
        RecEnd := Round(edRecRange.HiValue) ;
        end ;

     UseCh := cbChannel.ItemIndex ;
     Units := Channel[UseCh].ADCUnits ;
     mmResults.Clear ;
     mmResults.Lines.Add('Quantal Analysis') ;

     { ** Calculate average of peak evoked and mini signals ** }

     Evoked.Sum := 0. ;
     Evoked.Num := 0 ;
     Mini.Sum := 0. ;
     Mini.Num := 0 ;
     NumFailures := 0 ;

     { Calculate driving force if potentials }
     if rbPotentials.checked then begin
        VRest := edVRest.Value ;
        VReversal :=edVRev.Value ;
        VDrive := VRest - VReversal ;
        CorrectionFactor := edCorrectionFactor.Value ;
        end ;

     NumInvalid := 0 ;
     for Rec := RecStart to RecEnd do begin

         { Read record analysis block from file }
         GetRecordHeaderOnly( fH, RH, Rec ) ;

         { Add evoked peak to sum }
         if UseRecord( RH, cbEvokedType.text ) then begin
            x := RH.Value[UseCh*MaxAnalysisVariables+vPeak] ;
            { Correct potentials for non-linear summation }
            if rbPotentials.checked and (Abs(VDrive) > VDriveLimit) then begin
               Denom := 1. - Abs((CorrectionFactor*x)/VDrive) ;
               if Denom <> 0.0 then x := x/Denom
                               else Inc(NumInvalid) ;
               end ;
            Evoked.Sum := Evoked.Sum + x ;
            Inc(Evoked.Num) ;
            end ;

         { Add spontaneous peak to sum }
         if UseRecord( RH, cbMiniType.text ) then begin
            Mini.Sum := Mini.Sum + RH.Value[UseCh*MaxAnalysisVariables+vPeak] ;
            Inc(Mini.Num) ;
            end ;
         { Number of stimulations which failed to evoked a post-synaptic signal }
         if UseRecord( RH, 'FAIL' ) then begin
            Inc(NumFailures) ;
            Inc(Evoked.Num) ;
            end ;

         end ;
     if Evoked.Num > 0 then Evoked.Mean := Evoked.Sum/Evoked.Num ;
     if Mini.Num > 0 then Mini.Mean := Mini.Sum/Mini.Num ;


     { ** Calculate standard dev. of peak evoked and mini signals ** }

     Evoked.Sum := 0. ;
     Mini.Sum := 0. ;
     for Rec := RecStart to RecEnd do begin
         { Read record analysis block from file }
         GetRecordHeaderOnly( fH, RH, Rec ) ;
         { Add evoked residual to S.D. summation }
         if UseRecord( RH, cbEvokedType.text ) then begin
            x := RH.Value[UseCh*MaxAnalysisVariables+vPeak] - Evoked.Mean ;
            Evoked.Sum := Evoked.Sum + x*x ;
            end ;

         { Add spontaneous residual to sum }
         if UseRecord( RH, cbMiniType.text ) then begin
            x := RH.Value[UseCh*MaxAnalysisVariables+vPeak] - Mini.Mean ;
            Mini.Sum := Mini.Sum + x*x ;
            end ;
         end ;

     if Evoked.Num > 1 then Evoked.SD := Sqrt( Evoked.Sum/(Evoked.Num -1. ) )
                       else Evoked.SD := 0. ;
     Evoked.Variance := Evoked.SD*Evoked.SD ;
     if Mini.Num > 1 then Mini.SD := Sqrt( Mini.Sum/(Mini.Num -1. ) )
                     else Mini.SD := 0. ;
     Mini.Variance := Mini.SD*Mini.SD ;

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

        mmResults.Lines.add( format( 'Mean = %.3g %s',[Evoked.Mean,Units] )) ;
        if Evoked.Num > 1 then
           mmResults.Lines.add( format( 'Standard deviation = %.3g %s',
                                        [Evoked.SD,Units])) ;
        end
     else begin
        if rbPotentials.checked then
           mmResults.Lines.add('No evoked potentials available!')
        else
           mmResults.Lines.add('No evoked currents available!') ;
        end ;

     { Report mean/st.dev of miniature signal amplitudes }


     if rbMiniEventsAvailable.checked then begin
        mmResults.Lines.add( ' ' ) ;
        if rbPotentials.checked then
             mmResults.Lines.Add(format('Spontaneous miniature potentials (n=%d)',
                                         [Mini.Num]))
        else mmResults.Lines.Add(format('Spontaneous miniature currents (n=%d)',
                                       [Mini.Num])) ;

        if Mini.Num > 0 then begin
           mmResults.Lines.add( format( 'Mean = %.3g %s',[Mini.Mean,Units] )) ;
           if Mini.Num > 1 then
               mmResults.Lines.add( format( 'Standard deviation = %.3g %s',
                                            [Mini.SD,Units] )) ;
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

          if Mini.Mean <> 0. then begin
             mmResults.Lines.add( format( 'Mean = %.3g %s (user entered)',
                                         [Mini.Mean,Units] )) ;
             mmResults.Lines.add( format( 'Standard deviation = %.3g %s (user entered)',
                                         [Mini.SD,Units] )) ;
             Mini.Num := 1 ;
             end
          else mmResults.Lines.add( 'Invalid amplitude!' ) ;
          end ;

     mmResults.Lines.add( ' ' ) ;
     if (Evoked.Num > 0) and (Mini.Num > 0) then begin
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
        (Abs(Mini.Mean) > 0. ) then begin
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

     { Copy results to log file }
     for i := 1 to mmResults.Lines.Count do WriteToLogFileNoDate( mmResults.Lines[i] ) ;

     Main.mnPrint.Enabled := True ;
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
     Printer.Canvas.font.name := Settings.Plot.FontName ;
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
     printer.canvas.textout(PageLeft,Line, 'File ... ' + fH.FileName ) ;
     Line := Line + CharHeight ;
     printer.canvas.textout(PageLeft,Line, fH.IdentLine) ;
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
     edMiniAmplitude.Units := Channel[cbChannel.ItemIndex].ADCUnits ;
     edMiniStDev.Units := Channel[cbChannel.ItemIndex].ADCUnits ;
     end;

end.
