unit MeasureThread;
// ==================================================================
// Compute waveform measurements from signal records in WCP data file
// ==================================================================
// 13.04.21
// 17.08.21 .. Peak-peak peak measurement option added
// 09.03.22 .. Latency measurement now correctly calculated
//             LatencyPercentageIn Added to Create() arguments and iTimeZero set correctly
// 05.07.22 .. Both T.90% and T.x now use same DecayTime() procedure to find decay time
//             Decay to fixed level option added

interface

uses
  System.Classes, WCPFIleUnit ;

type
  TMeasureThread = class(TThread)
  private
    { Private declarations }
    StartAtRec : Integer ;
    EndAtRec : Integer ;
    TypeToBeAnalysed : string ;
    iStart : Array[0..MaxChannels-1] of Integer ;
    iEnd : Array[0..MaxChannels-1] of Integer ;
    iTimeZero : Array[0..MaxChannels-1] of Integer ;
    LatencyPercentage : Single ;

    FH : TFileHeader ;
    RH : TRecHeader ; { Record header }

    function Slope(
             var ADC : Array of Single ;   // Data buffer
             iStart : Integer ;            // Start at array index
             iEnd : Integer ;               // End at array index
             iChan : Integer               // Channel
             ) : Single ;

    function MaxRateOfChange(
             var ADC : Array of Single ;   // Data buffer
             iStart : Integer ;            // Start at array index
             iEnd : Integer ;               // End at array index
             iChan : Integer                // Channel
             ) : Single ;

   function DecayTime(
          var ADC : Array of Single ;
          iPeakAt : Integer ;     // Start at point
          iEnd : Integer ;        // End at point
          ChOffset : Integer ;    // Channel offset in ADC
          Invert : Integer ;      // Invert signal
          EndThreshold : Single   // Decay end-point threshold
          ) : Single ;            // Return decay time


        procedure QuickSort(var A: array of Single ; iLo, iHi: Integer) ;


  public
  constructor Create( StartAtIn : Integer ;
                      EndAtIn : Integer ;
                      TypeToBeAnalysedIn : String ;
                      NumChannels : Integer ;
                      iStartIn : Array of Integer ;
                      iEndIn : Array of Integer ;
                      iTimeZeroIn : Array of Integer ;
                      LatencyPercentageIn : Single ;
                      FHIn : TFileHeader              // File header of WCP file
                      );

  protected
    procedure Execute; override;

  end;

implementation

uses Measure, math, seslabio, MDIForm, SysUtils, WinTypes, WinProcs, Messages, StrUtils ;

const
     ForwardDifference = 0 ;
     Quadratic5point = 1 ;
     Quadratic7point = 2 ;
     SlopeDifference = 3 ;

constructor TMeasureThread.Create( StartAtIn : Integer ;          // Statt at record
                                   EndAtIn : Integer ;            // End at record
                                   TypeToBeAnalysedIn : String ;  // Record type to analyse
                                   NumChannels : Integer ;        // No. signal channels
                                   iStartIn : Array of Integer ;  // Starting sample (for each channel)
                                   iEndIn : Array of Integer ;    // End sample
                                   iTimeZeroIn : Array of Integer ; // T=0 sample
                                   LatencyPercentageIn : Single ;    // Latency % threshold
                                   FHIn : TFileHeader             // File header of WCP file
                                   );
// ----------------------------
// Create and initialise thread
// ----------------------------
var
  ch: Integer;
begin

  inherited Create(False);
//  FreeOnTerminate := True;

  // Set internal variables

  StartAtRec := StartAtIn ;
  EndAtRec := EndAtIn ;
  TypeToBeAnalysed := TypeToBeAnalysedIn ;
  LatencyPercentage := LatencyPercentageIn ;

  for ch := 0 to NumChannels-1 do
      begin
      iStart[ch] := iStartIn[ch] ;
      iEnd[ch] := iEndIn[ch] ;
      iTimeZero[ch] := iTimeZeroIn[ch] ;
      end ;

  FH := FHIn ;

end;


procedure TMeasureThread.Execute;
// --------------------------------------------------------------
// Calculate waveform measurements & stored in .WCP and .csv file
// --------------------------------------------------------------
var
   NumRecAnalysed,Rec : Integer ;
   i,j,k,ch,ChOffset : Integer ;
   x,y,dx,Peak,Temp : single ;
   PeakLo,PeakHi : single ;
   PeakAt,Invert : Integer ;

   PeakPositive,PeakNegative : single ;
   PeakPositiveAt, PeakNegativeAt : Integer ;
   // T.90% and T.X% duration
   Peak10 : single ;  // 10% of peak amplitude threshold
   TXAmplitude : single ;  // X% of peak amplitude threshold
   TXAmplitudeAt : Integer ; // Sample index when y=TXLevel

   Baseline : Integer ;
   Diff,MaxDiff : single ;
   A : array[-15..15] of single ;
   ASum : single ;
   jLow,jHigh,iStep : Integer ;
   row,col : Integer ;
   iY,i0,i1,j0,j1 : Integer ;
   EndPoint : Integer ;
   Sum,AbsSum,Residual,Avg,NumAvg : Single ;
   TestInterval : Integer ;
   RateDone : Boolean ;
   PreviousTime : single ;
   iVar,vStart : Integer ;

   YHiPrev, YLoNext, dRiseTime, YHi, YLo, YPrev, dDecay : Single ;

   InBuf : PSmallIntArray ; // 16 bit integer A/D buffer
   ADC : PSingleArray ;     // Floating point A/D buffer
   // Quantile variables
   SortBuf : PSingleArray ;     // Floating point A/D buffer
   nSort,iQuantile : Integer ;
   iLatency : Integer ;          // Latency sample point
   YLatency : single ;           // Latency trigger level
   s : string ;
   YTable : TStringList ;
   FileName : string ;
begin

     // Create buffers
     New(InBuf) ;
     New(ADC) ;

     // Get list of measurement variable names
     Synchronize( procedure
                  var
                      i : integer ;
                  begin
                  s := '"Channel","Units",' ;
                  for i := 0 to LastMeasureVariable do
                      s := s + '"' + MeasureFrm.VarList[i] +'",' ;
                  s := LeftStr(s,Length(s)-1);
                  end );

     // Create string list
     YTable := TStringList.Create ;
     YTable.Add(s) ;

     { Set previous time variable negative to indicate that it is invalid }
     PreviousTime := -1. ;
     Rec := StartAtRec ;
     NumRecAnalysed := 0 ;

     while (not Terminated) and (Rec <= EndAtRec ) do
         begin

         { Read record data from file }
         WCPFile.GetRecord( fH, rH, Rec, InBuf^ ) ;

         // Copy to float array
         for i := 0 to fH.NumSamples*fH.NumChannels-1 do ADC^[i] := InBuf^[i] ;

         { Analyse records selected according to UseRecord's criteria }

         rH.AnalysisAvailable := True ;

         if MeasureFrm.UseRecord( rH, TypeToBeAnalysed ) then
            begin

            if PreviousTime < 0. then PreviousTime := rH.Time ;

            { Analyse each signal channel in turn }
            for ch := 0 to fH.NumChannels-1 do
                begin

                vStart := ch*MaxAnalysisVariables ;

                rH.Value[vStart + vRecord] := Rec ;
                rH.Value[vStart + vGroup] := Rec ;
                rH.Value[vStart + vTime] := rH.Time ;
                rH.Value[vStart + vInterval] := (rH.Time  - PreviousTime) ;

                ChOffset := WCPFile.Channel[ch].ChannelOffset ;

                { Subtract zero level }
                j := WCPFile.Channel[ch].ChannelOffset ;
                for i := 0 to fH.NumSamples-1 do
                    begin
                    ADC^[j] := ADC^[j] - WCPFile.Channel[ch].ADCZero ;
                    j := j + fH.NumChannels ;
                    end ;

                { Calculate average and area within cursors 0-1 }
                Sum := 0.0 ;
                AbsSum := 0.0 ;
                j := iStart[ch]*fH.NumChannels + WCPFile.Channel[ch].ChannelOffset ;
                for i := iStart[ch] to iEnd[ch] do
                    begin
                    Sum := Sum + ADC^[j] ;
                    AbsSum := AbsSum + Abs(ADC^[j]) ;
                    j := j + fH.NumChannels ;
                    end ;
                NumAvg := (iEnd[ch] - iStart[ch]) + 1 ;
                Avg := Sum / NumAvg ;

                rH.Value[vStart + vAverage] := (Avg * WCPFile.Channel[ch].ADCScale) ;
                rH.Value[vStart + vArea] := (Sum * rH.dt * WCPFile.Channel[ch].ADCScale) ;
                rH.Value[vStart + vAbsArea] := (AbsSum * rH.dt * WCPFile.Channel[ch].ADCScale) ;

                { Calculate variance within cursors 0-1 }

                Sum := 0. ;
                j := iStart[ch]*fH.NumChannels + WCPFile.Channel[ch].ChannelOffset ;
                for i := iStart[ch] to iEnd[ch] do
                    begin
                    Residual := ADC^[j] - Avg ;
                    Sum := Sum + Residual*Residual ;
                    j := j + fH.NumChannels ;
                    end ;
                Avg := Sum / NumAvg ;
                rH.Value[vStart + vVariance] := (Avg * WCPFile.Channel[ch].ADCScale
                                                   * WCPFile.Channel[ch].ADCScale) ;

                { Find peaks within cursor 0-1 region}

                PeakPositive := FH.MinADCValue*2 ;
                PeakNegative := FH.MaxADCValue*2 ;
                j := iStart[ch]*fH.NumChannels + WCPFile.Channel[ch].ChannelOffset ;
                for i := iStart[ch] to iEnd[ch] do
                    begin
                    Y := ADC^[j] ;
                    if Y > PeakPositive then
                       begin
                       PeakPositive := Y ;
                       PeakPositiveAt := i ;
                       end ;
                    if Y < PeakNegative then
                       begin
                       PeakNegative := Y ;
                       PeakNegativeAt := i ;
                       end ;
                    j := j + fH.NumChannels ;
                    end ;

                case FH.PeakMode of
                     PositivePeaks : begin
                         PeakAt := PeakPositiveAt ;
                         Invert := 1 ;
                         end ;
                     NegativePeaks : begin
                         PeakAt := PeakNegativeAt ;
                         Invert := -1 ;
                         end ;
                     else begin
                         if Abs(PeakPositive) < Abs(PeakNegative) then
                            begin
                            PeakAt := PeakNegativeAt ;
                            Invert := -1 ;
                            end
                         else
                            begin
                            PeakAt := PeakPositiveAt ;
                            Invert := 1 ;
                            end ;
                         end ;
                     end ;

                // Determine range of points round peak to average
                if FH.NumPointsAveragedAtPeak >= 1 then
                   begin
                   // Average points after peak
                   i0 := PeakAt ;
                   i1 := Min(i0 + FH.NumPointsAveragedAtPeak - 1,FH.NumSamples-1) ;
                   end
                else if FH.NumPointsAveragedAtPeak <= -1 then
                   begin
                   // (negative) Average points before peak
                   i1 := PeakAt ;
                   i0 := Max(i1 + FH.NumPointsAveragedAtPeak + 1,0);
                   end
                else
                   begin
                   // Single point at peak
                   i0 := PeakAt ;
                   i1 := PeakAt ;
                   end ;

                // Calculate average of points around peak
                Peak := 0.0 ;
                for i := i0 to i1 do
                    begin
                    j := i*FH.NumChannels + WCPFile.Channel[ch].ChannelOffset ;
                    Peak := Peak + ADC^[j] ;
                    end ;
                Peak := Peak / (i1 - i0 + 1) ;

                if FH.PeakMode = PeakPeaks then
                   begin
                   // Peak-peak measurement
                   rH.Value[vStart + vPeak] := (PeakPositive - PeakNegative)*WCPFile.Channel[ch].ADCScale ;
                   end
                else
                  begin
                  // Pos, neg or absolute measurement
                  rH.Value[vStart + vPeak] := Peak*WCPFile.Channel[ch].ADCScale ;
                  end ;

                { Special exception for records designated as transmission
                  failures (FAIL) peak value is always set to zero }
                if rH.RecType = 'FAIL' then rH.Value[vStart+vPeak] := 0.0 ;

                // Get lo-hi limits (ensuring lo < hi)
                PeakLo := Round(Abs(Peak)*FH.RiseTimeLo) ;
                PeakHi := Round(Abs(Peak)*FH.RiseTimeHi) ;
                if PeakLo > PeakHi then
                   begin
                   Temp := PeakLo ;
                   PeakLo := PeakHi ;
                   PeakHi := temp ;
                   end ;

                { Calculate lo% - hi% rise time }
                i0 := PeakAt + 1;
                repeat

                  i0 := i0 - 1 ;
                  j := i0*fH.NumChannels + ChOffset ;
                  Y := ADC^[j]*Invert ;

                  // Save amplitude and last point above upper limit.
                  if Y >= PeakHi then
                     begin
                     i1 := i0 ;
                     YHi := Y ;
                     end ;

                  // Save first point below limit
                  YLo := Y ;

                  // Exit when amplitude drops below lower limit
                  until (Y <= PeakLo) or (i0 <= iStart[ch]) ;

                // V4.0.5 Interpolate to find exact time of lo, hi transitions

                YHiPrev := ADC^[Max(i1-1,0)*fH.NumChannels + ChOffset]*Invert ;
                YLoNext := ADC^[Min(i0+1,fh.NumSamples-1)*fH.NumChannels + ChOffset]*Invert ;
                dRiseTime := 0.0 ;
                if YHi <> YHiPrev then dRiseTime := dRiseTime + ((PeakHi - YHi) /(YHi - YHiPrev)) ;
                if YLoNext <> YLo then dRiseTime := dRiseTime - ((PeakLo - YLo) /(YLoNext - YLo)) ;
                dRiseTime := dRiseTime*rH.dt ;

                rH.Value[vStart + vRiseTime] := ((i1-i0)*rH.dt + dRiseTime) ;

                { Calculate latency as time from zero time cursor to LatencyPercentage % of peak }
                iLatency := PeakAt + 1;
                YLatency := ADC^[PeakAt*fH.NumChannels + ChOffset]*Invert*(LatencyPercentage*0.01) ;
                repeat
                  iLatency := iLatency - 1 ;
                  Y := ADC^[iLatency*fH.NumChannels + ChOffset]*Invert ;
                  // Exit when amplitude drops below lower limit
                  until (Y <= YLatency) or (iLatency <= 0) ;
                rH.Value[ch*MaxAnalysisVariables+vLatency] := ((iLatency - iTimeZero[ch] )*rH.dt) ;

                { Calculate max. rate of rise (over range from iStart ... peak ) }
                if FH.RateOfRiseMode = SlopeDifference then
                   begin
                   // Calculate rate of change as slope of straight line
                   // fitted to (lo% - hi%) rising edge of signal
                   rH.Value[vStart + vRateOfRise] := Slope( ADC^,
                                                            i0,
                                                            i1,
                                                            ch
                                                            ) ;
                   end
                else
                   begin
                   // Calculate maximum rate of rise of signal using
                   // 1,3 or 5 point differentiation
                   rH.Value[vStart + vRateOfRise] := MaxRateofChange( ADC^,iStart[ch],iEnd[ch],ch ) ;
                   end ;

                { Calculate time to 90% decay }
                // V4.0.5 Exact decay point determined by interpolation between
                // first point below threshold and last point above threshold

                Peak10 := Round(Abs(Peak)*0.1) ;

                // Decay time to 90% of peak
                TXAmplitude := Round(Abs(Peak)*(100.0-90.0)*0.01);
                rH.Value[vStart + vt90] := DecayTime( ADC^, PeakAt,iEnd[ch],ChOffset,Invert,TXAmplitude) ;

                // T.x% Duration from Peak - user selected point
                if FH.DecayTimeToLevel then
                   begin
                   // Decay to fixed level
                   TXAmplitude := FH.DecayTimeLevel / WCPFile.Channel[ch].ADCScale ;
                   end
                else
                   begin
                   // Decay time x% of peak
                   TXAmplitude := Round(Abs(Peak)*(100.0-FH.DecayTimePercentage)*0.01);
                   end ;
                rH.Value[vStart + vtDecay] := DecayTime( ADC^, PeakAt,iEnd[ch],ChOffset,Invert,TXAmplitude) ;

                { Baseline level determined from average of samples at TZero cursor
                (Note. TZero cursor always taken from channel 0) }
                i0 := Min(Max(WCPFile.Channel[ch].ADCZeroAt,0),FH.NumSamples-1) ;
                i1 := Min(i0 + Max(FH.NumZeroAvg,1) - 1,FH.NumSamples-1) ;
                Sum := 0. ;
                j := i0*fH.NumChannels + WCPFile.Channel[ch].ChannelOffset ;
                for i := i0 to i1 do
                    begin
                    Sum := Sum + (ADC^[j] + WCPFile.Channel[ch].ADCZero) ;
                    j := j + fH.NumChannels ;
                    end ;
                NumAvg := (i1 - i0) + 1 ;
                Avg := Sum / NumAvg ;
                rH.Value[vStart + vBaseline] := (Avg*WCPFile.Channel[ch].ADCScale) ;

                // Calculate X% quantile
                GetMem(SortBuf,Max(iEnd[ch]-iStart[ch] + 1,1)*SizeOf(Single));
                nSort := 0 ;
                i := iStart[ch] ;
                iStep := Max((iEnd[ch] - iStart[ch]) div 5000,1) ;
                while i <= iEnd[ch] do
                    begin
                    SortBuf^[nSort] := ADC^[i*fH.NumChannels + WCPFile.Channel[ch].ChannelOffset] ;
                    Inc(nSort) ;
                    i := i + iStep ;
                    end ;

                QuickSort( SortBuf^, 0, nSort-1) ;
                iQuantile := Max(Round(FH.QuantilePercentage*nSort*0.01)-1,0);
                rH.Value[vStart + vQuantile] := SortBuf^[iQuantile]*WCPFile.Channel[ch].ADCScale ;
                FreeMem(SortBuf) ;

                // Add measurements for channel to list
                s := format('"%s","%s",',[WCPFile.Channel[ch].ADCName,WCPFile.Channel[ch].ADCUnits]) ;
                for i := 0 to LastMeasureVariable do
                    begin
                    j := vStart + Integer(MeasureFrm.VarList.Objects[i]) ;
                    s := s + format('"%.6g",',[rH.Value[j]]);
                    end ;
                s := LeftStr(s,Length(s)-1);
                YTable.Add(s) ;

                end ;

            { Update time of previous record }
            PreviousTime := rH.Time ;

            end ;

         // No. of records analysed
         Inc(NumRecAnalysed) ;

         { Save record header containing analysis results back to file  }
         WCPFile.PutRecordHeaderOnly( fH, rH, Rec ) ;

         Rec := Rec + 1;

         if (Rec mod 50) = 0 then
           begin
           // Report progress
           Synchronize( procedure
                      begin
                      Main.StatusBar.SimpleText := format(
                      ' Waveform Measurement : Analysing record %d/%d',
                      [Rec,EndAtRec] ) ;
                      end );
           Sleep(1) ;
           end ;

         end ;

     // Final report
     Synchronize( procedure
                  begin
                  Main.StatusBar.SimpleText := format(
                  ' Waveform Measurement : %d records analysed from range %d-%d',
                  [NumRecAnalysed,StartAtRec,EndAtRec] ) ;
                  { Update currently displayed record }
                  MeasureFrm.DisplayRecord ;
                  MeasureFrm.bDoAnalysis.Enabled := True ;
                  MeasureFrm.bAbort.Enabled := False ;
                  end ) ;

     // Save measurements to .csv file
     FileName := ChangeFileExt(FH.FileName,'.csv');
     FileName := ReplaceText( FileName, '.csv', '.wfm.csv') ;
     YTable.SaveToFile( FileName ) ;
     YTable.Free ;

     Dispose(ADC) ;
     Dispose(InBuf) ;

     // Save header data to .WCP file
     WCPFile.SaveHeader(FH) ;

end;


function TMeasureThread.MaxRateOfChange(
         var ADC : Array of Single ;   // Data buffer
         iStart : Integer ;            // Start at array index
         iEnd : Integer ;               // End at array index
         iChan : Integer
         ) : Single ;
// -----------------------------
// Calculate max. rate of change
// -----------------------------
var
   i,j,k,jLow,jHigh : Integer ;
   Diff,MaxDiff : single ;
   A : array[-15..15] of single ;
   ASum : single ;

begin

     if FH.RateOfRiseMode = ForwardDifference then
        begin
        jLow := 0 ;
        jHigh := 1 ;
        A[0] := -1.0 ;
        A[1] := 1.0 ;
        ASum := 1.0 ;
        end
     else if FH.RateOfRiseMode = Quadratic5Point then
        begin
        jLow := -2 ;
        jHigh := 2 ;
        for j := jLow to jHigh do A[j] := j ;
        ASum := 10.0 ;
        end
     else
        begin
        jLow := -3 ;
        jHigh := 3 ;
        for j := jLow to jHigh do A[j] := j ;
        ASum := 28.0 ;
        end ;

     MaxDiff := 0 ;
     for i := iStart to iEnd do
         begin
         Diff := 0.0 ;
         for j := jLow to jHigh do
             begin
             k := Min(Max(i+j,0),fH.NumSamples-1)*FH.NumChannels
                  + WCPFile.Channel[iChan].ChannelOffset ;
             Diff := Diff + A[j]*ADC[k] ;
             end ;
         Diff := Diff / ASum ;
         if Diff > MaxDiff then MaxDiff := Diff ;
         end ;

     Result := (MaxDiff * WCPFile.Channel[iChan].ADCSCale) / rH.dt ;

     end ;


function TMeasureThread.Slope(
          var ADC : Array of Single ;
          iStart : Integer ;     // Start at point
          iEnd : Integer ;       // End at point
          iChan : Integer
          ) : Single ;
// -----------------------
// Calculate slope of line
// -----------------------
var
     i : Integer ;
     y,t : Single ;          //
     SumT : Single ;        // Summation variables for time constant fit
     SumT2 : Single ;         //
     SumY : Single ;         //
     SumYT : Single ;         //
     Denom : Single ;
     nPoints : Integer ;
begin

   t := 0.0 ;
   SumT := 0.0 ;
   SumT2 := 0.0 ;
   SumY := 0.0 ;
   SumYT := 0.0 ;
   nPoints := iEnd - iStart + 1 ;
   for i := iStart to iEnd do begin
      Y := ADC[i*FH.NumChannels + WCPFile.Channel[iChan].ChannelOffset] ;
      SumT := SumT + t ;
      SumT2 := SumT2 + t*t ;
      SumY := SumY + Y ;
      SumYT := SumYT + Y*T ;
      t := t + RH.dt ;
      end ;

   Denom := (nPoints*SumT2) - (SumT*SumT) ;
   if Denom <> 0.0 then Result := ((nPoints*SumYT) - (SumT*SumY))/ Denom
                   else Result := 0.0 ;

   Result := WCPFile.Channel[iChan].ADCSCale*Result ;

   end ;


function TMeasureThread.DecayTime(
          var ADC : Array of Single ;
          iPeakAt : Integer ;     // Peak of signal point
          iEnd : Integer ;        // End at point
          ChOffset : Integer ;    // Channel offset in ADC
          Invert : Integer ;      // Invert signal
          EndThreshold : Single   // Decay end-point threshold
          ) : Single ;            // Return decay time
// ------------------------------------
// Decay time from peak to EndThreshold
// ------------------------------------

var
    iDecayEndAt : Integer ;
    y,dDecay,yPrev : single ;
begin

    // Find point at which threshold crossed

    iDecayEndAt := iPeakAt - 1 ;
    repeat
        Inc(iDecayEndAt) ;
        Y := ADC[iDecayEndAt*fH.NumChannels + ChOffset]*Invert ;
        until (Y < EndThreshold) or (iDecayEndAt >= iEnd) ;

    // V4.0.5 Exact decay point determined by interpolation between
    // first point below threshold and last point above threshold

    YPrev := ADC[Max(iDecayEndAt-1,0)*fH.NumChannels + ChOffset]*Invert ;
    if (Y <> YPrev) then
       begin
       dDecay := -((EndThreshold - Y) /(Y - YPrev)) *rH.dt ;
       end
    else dDecay := 0.0 ;

    Result := ((iDecayEndAt - iPeakAt+1)*rH.dt + dDecay) ;

end ;


procedure TMeasureThread.QuickSort(var A: array of Single ; iLo, iHi: Integer) ;
// --------------------
// Quick sort algorithm
// --------------------
// Modified from http://delphisourcecodes.blogspot.co.uk/2011/12/delphi-quicksort-algorithm.html 12.02.18

 var
   Lo, Hi : Integer;
   T,Pivot : single ;
 begin
   Lo := iLo;
   Hi := iHi;
//   Pivot := A[(Lo + Hi) div 2];
   Pivot := A[Random(iHi-iLo+1)+iLo] ;
   repeat
     while A[Lo] < Pivot do Inc(Lo) ;
     while A[Hi] > Pivot do Dec(Hi) ;
     if Lo <= Hi then
     begin
       T := A[Lo];
       A[Lo] := A[Hi];
       A[Hi] := T;
       Inc(Lo) ;
       Dec(Hi) ;
     end;
   until Lo > Hi;
   if Hi > iLo then QuickSort(A, iLo, Hi) ;
   if Lo < iHi then QuickSort(A, Lo, iHi) ;
 end;


end.
