unit RecPlotUnit;
//  ----------------------------------------
// On-line analysis time course plot module
// ----------------------------------------
// 22.08.07
// 16.04.09 TZero now defined as DWORD
// 14.05.09 Smoothed rate of rise measurement added
//          Measurement plots can be linked to stimulus protocols
//          Measurements logged in log file
// 18.05.09 Interpolation added to rise time calculation
// 06.05.10 Plot data can now be copied to Windows clipboard
//          On-line measurements now saved to log file in table form that can be copied to Excel
// 09.02.11 Additional set of analysis area cursors (3-4) added so measurements
//          can be taken from two different regions of recording sweep.
// 31.08.12 Rising slope variable added
//          Incorrect slope scaling on first recording sweep fixed
//          Channel[].ADCScale scaling replaced with SESLabIO.ADCUnitsPerBit
// 10.02.15 plPlot.CreateLine() Label name added to arguments
// 27.02.17 Average within cursors added
//          On line analysis settings now stored in Settings.RecPlot and saved in INI file

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XMultiYPlot, ValidatedEdit, global, math, mmsystem,
  ExtCtrls, fileio, RangeEdit ;

const
    NumCursorSets = 2 ;

type

  TRecPlotFrm = class(TForm)
    ControlsGrp: TGroupBox;
    plPlot: TXMultiYPlot;
    mePlotList: TMemo;
    GroupBox2: TGroupBox;
    rbZeroLevelC0: TRadioButton;
    rbZeroLevelZ: TRadioButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    cbPlotVar: TComboBox;
    cbPlotChan: TComboBox;
    bAddPlot: TButton;
    panPolarity: TPanel;
    Label3: TLabel;
    cbPolarity: TComboBox;
    panRateofRiseSmooth: TPanel;
    Label4: TLabel;
    cbRateofRiseSmooth: TComboBox;
    panCursors: TPanel;
    Label5: TLabel;
    edNumAveraged: TValidatedEdit;
    cbPulseProgram: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    Shape1: TShape;
    bClearPoints: TButton;
    bCopyToClipboard: TButton;
    panCursorSet: TPanel;
    Label6: TLabel;
    cbCursorSet: TComboBox;
    PanRiseTime: TPanel;
    Label7: TLabel;
    edRiseTimeRange: TRangeEdit;
    procedure FormShow(Sender: TObject);
    procedure bAddPlotClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bClearPointsClick(Sender: TObject);
    procedure cbPlotVarChange(Sender: TObject);
    procedure bCopyToClipboardClick(Sender: TObject);
  private
    { Private declarations }

    PlotsChanged : Boolean ;
    ResetTimeZero : Boolean ;
    TZero : DWORD ;
    procedure ShowControls ;

    function RiseTime(
         var ADC : Array of SmallInt ;
         iStart : Integer ;     // Start at point
         iPeakAt : Integer ;       // Peak point
         iChan : Integer ;      // input channel
         YPeak : Single ;       // Peak amplitude
         YZero : Single ;        // Zero level
         Polarity : Integer    // Polarity of rise
         ) : Single ;

    function RateOfRise(
          var ADC : Array of SmallInt ;
          iStart : Integer ;     // Start at point
          iEnd : Integer ;       // End at point
          iChan : Integer ;      // input channel
          Polarity : Integer ;   // Polarity of rate of change
          DifferentiationMode : Integer // Differention mode
          ) : Single ;

    function Slope(
          var ADC : Array of SmallInt ;
          iStart : Integer ;     // Start at point
          iEnd : Integer ;       // End at point
          iChan : Integer       // input channel
          ) : Single ;

    function RisingSlope(
          var ADC : Array of SmallInt ;
          iChan : Integer ;      // input channel
          iPeakAt : Integer ;
          YPeak : Single ;
          YBaseline : Single ;
          Polarity : Integer
          ) : Single ;

  public
    { Public declarations }
    procedure UpdatePlot(
          var ADC : Array of SmallInt ;
          Cursor0 : Integer ;
          Cursor1 : Integer ;
          Cursor2 : Integer ;
          Cursor3 : Integer ;
          Cursor4 : Integer ;
          StimProtocolInUse : String ;
          RecordNum : Integer
           ) ;

    procedure CopyImageToClipboard ;
    procedure CopyDataToClipboard ;
    procedure Print ;

  end;

var
  RecPlotFrm: TRecPlotFrm;

implementation

uses MDIForm, Printgra, StimModule;

{$R *.dfm}

const
    vPeak = 0 ;
    vTRise = 1 ;
    vNegTRise = 2 ;
    vRateOfRise = 3 ;
    vSlope = 4 ;
    vC1 = 5 ;
    vC2 = 6 ;
    vC3 = 7 ;
    vC4 = 8 ;
    vRisingSlope = 9 ;
    vAverage = 10 ;

    PosPolarity = 0 ;
    NegPolarity = 1 ;
    AbsPolarity = 3 ;

    ForwardDifference = 0 ;
    Quadratic5point = 1 ;
    Quadratic7point = 2 ;


procedure TRecPlotFrm.UpdatePlot(
          var ADC : Array of SmallInt ;
          Cursor0 : Integer ;
          Cursor1 : Integer ;
          Cursor2 : Integer ;
          Cursor3 : Integer ;
          Cursor4 : Integer ;
          StimProtocolInUse : String ;
          RecordNum : Integer
           ) ;
// ------------------------------------------
// Update plot with new waveform measurements
// ------------------------------------------
var
    i,i0,i1,j,ch,iPlot,i90,i10 : Integer ;
    yMax : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yMin : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yMaxAt : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Integer ;
    yMinAt : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Integer ;
    yMaxTRise : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yMinTRise : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yMaxRateOfRiseFD : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yMaxRateOfRiseQ5 : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yMaxRateOfRiseQ7 : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yMaxRisingSlope : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;

    yMinRateOfRiseFD : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yMinRateOfRiseQ5 : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yMinRateOfRiseQ7 : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yMinRisingSlope : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;

    ySlope : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yC0 : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yZero : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yC1 : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yC2 : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yC3 : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yC4 : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;
    yAverage : Array[0..wcpMaxChannels-1,0..NumCursorSets-1] of Single ;

    y,ySum,y90,y10,yDiffMax,yPos,yNeg,YHiPrev,YLoPrev,Sum : Single ;
    RScale : Single ;
    nAvg : Integer ;
    t : single ;
    s : string ;
    iChan,CursorSet : Integer ;
    iP,iStart,iEnd : Integer ;
    YScale : Single ;
    YChanOffset,YZeroLevel : Integer ;
begin

    nAvg := Round( edNumAveraged.Value ) ;

    for CursorSet := 0 to 1 do begin

       // Select cursor range
       if CursorSet = 0 then begin
          iStart := Min(Cursor1,Cursor2) ;
          iEnd := Max(Cursor1,Cursor2) ;
          end
          else begin
          iStart := Min(Cursor3,Cursor4) ;
          iEnd := Max(Cursor3,Cursor4) ;
          end ;

       // Waveform measurements for all channels

       for ch := 0 to Main.SESLabIO.ADCNumChannels-1 do begin

           // Signal level at C0 cursor
           i0 := Max( Cursor0 - (nAvg div 2),0 ) ;
           i1 := Min( i0 + nAvg - 1, Main.SESLabIO.ADCNumSamples-1 );
           ySum := 0.0 ;

           YChanOffset := Main.SESLabIO.ADCChannelOffset[ch] ;
           YZeroLevel := Main.SESLabIO.ADCChannelZero[ch] ;
           YScale := Main.SESLabIO.ADCChannelUnitsPerBit[ch] ;
           for i := i0 to i1 do begin
               j := i*Main.SESLabIO.ADCNumChannels + YChanOffset ;
               ySum := ySum + (ADC[j] - YZeroLevel)*YScale ;
                                         ;
               end ;
           yC0[ch,CursorSet] := ySum / (i1 - i0 + 1) ;

           // Set zero level
           if rbZeroLevelC0.Checked then YZero[ch,CursorSet] := yC0[ch,CursorSet]
                                    else YZero[ch,CursorSet] := 0.0 ;

           // Signal level at cursor 1
           i0 := Max( Cursor1 - (nAvg div 2),0 ) ;
           i1 := Min( i0 + nAvg - 1, Main.SESLabIO.ADCNumSamples-1 );
           ySum := 0.0 ;
           for i := i0 to i1 do begin
               j := i*Main.SESLabIO.ADCNumChannels + YChanOffset ;
               ySum := ySum + (ADC[j] - YZeroLevel)*YScale ;
               end ;
           yC1[ch,CursorSet] := ySum / (i1 - i0 + 1) - YZero[ch,CursorSet] ;

           // Signal level at cursor 2
           i0 := Max( Cursor2 - (nAvg div 2),0 ) ;
           i1 := Min( i0 + nAvg - 1, Main.SESLabIO.ADCNumSamples-1 );
           ySum := 0.0 ;
           for i := i0 to i1 do begin
               j := i*Main.SESLabIO.ADCNumChannels + YChanOffset ;
               ySum := ySum + (ADC[j] - YZeroLevel)*YScale ;
               end ;
           yC2[ch,CursorSet] := ySum / (i1 - i0 + 1) - YZero[ch,CursorSet] ;

           // Signal level at cursor 3
           i0 := Max( Cursor3 - (nAvg div 2),0 ) ;
           i1 := Min( i0 + nAvg - 1, Main.SESLabIO.ADCNumSamples-1 );
           ySum := 0.0 ;
           for i := i0 to i1 do begin
               j := i*Main.SESLabIO.ADCNumChannels + YChanOffset ;
               ySum := ySum + (ADC[j] - YZeroLevel)*YScale ;
               end ;
           yC3[ch,CursorSet] := ySum / (i1 - i0 + 1) - YZero[ch,CursorSet] ;

           // Signal level at cursor 4
           i0 := Max( Cursor4 - (nAvg div 2),0 ) ;
           i1 := Min( i0 + nAvg - 1, Main.SESLabIO.ADCNumSamples-1 );
           ySum := 0.0 ;
           for i := i0 to i1 do begin
               j := i*Main.SESLabIO.ADCNumChannels + YChanOffset ;
               ySum := ySum + (ADC[j] - YZeroLevel)*YScale ;
               end ;
           yC4[ch,CursorSet] := ySum / (i1 - i0 + 1) - YZero[ch,CursorSet] ;

           // Find positive and negative peak signal level
           yMax[ch,CursorSet] := -1E30 ;
           yMin[ch,CursorSet] := 1E30 ;
           for i := iStart to iEnd do begin
               j := i*Main.SESLabIO.ADCNumChannels + YChanOffset ;
               y := ((ADC[j] - YZeroLevel)*YScale) - YZero[ch,CursorSet] ;
               if y >= yMax[ch,CursorSet] then Begin
                  yMax[ch,CursorSet] := y ;
                  yMaxAt[ch,CursorSet] := i ;
                  end ;
               if y <= yMin[ch,CursorSet] then Begin
                  yMin[ch,CursorSet] := y ;
                  yMinAt[ch,CursorSet] := i ;
                  end ;
               end ;

           // Calculate average
           Sum := 0.0 ;
           for i := iStart to iEnd do begin
               j := i*Main.SESLabIO.ADCNumChannels + YChanOffset ;
               y := ((ADC[j] - YZeroLevel)*YScale) - YZero[ch,CursorSet] ;
               Sum := Sum + y ;
               end ;
           yAverage[ch,CursorSet] := Sum / Max(iEnd - iStart + 1,1) ;

            // Max rise time to positive peak
            yMaxTRise[ch,CursorSet] := RiseTime ( ADC,
                                       iStart,
                                       yMaxAt[ch,CursorSet],
                                       ch,
                                       yMax[ch,CursorSet] + YZero[ch,CursorSet],
                                       yC0[ch,CursorSet],
                                       PosPolarity ) ;

            // Max rise time to negative peak
            yMinTRise[ch,CursorSet] := RiseTime( ADC,
                                       iStart,
                                       yMinAt[ch,CursorSet],
                                       ch,
                                       yMin[ch,CursorSet] + YZero[ch,CursorSet],
                                       yC0[ch,CursorSet],
                                       NegPolarity ) ;

           // Rate of rise
           yMaxRateOfRiseFD[ch,CursorSet] :=  RateofRise( ADC,
                                                          iStart,
                                                          iEnd,
                                                          ch,
                                                          PosPolarity,
                                                          ForwardDifference ) ;

           yMinRateOfRiseFD[ch,CursorSet] :=  RateofRise( ADC,
                                                          iStart,
                                                          iEnd,
                                                          ch,
                                                          NegPolarity,
                                                          ForwardDifference ) ;

           yMaxRateOfRiseQ5[ch,CursorSet] :=  RateofRise( ADC,
                                                          iStart,
                                                          iEnd,
                                                          ch,
                                                         PosPolarity,
                                                         Quadratic5point ) ;

           yMinRateOfRiseQ5[ch,CursorSet] :=  RateofRise( ADC,
                                                          iStart,
                                                          iEnd,
                                                          ch,
                                                          NegPolarity,
                                                          Quadratic5point ) ;

           yMaxRateOfRiseQ7[ch,CursorSet] :=  RateofRise( ADC,
                                                           iStart,
                                                           iEnd,
                                                           ch,
                                                           PosPolarity,
                                                           Quadratic7point ) ;

           yMinRateOfRiseQ7[ch,CursorSet] :=  RateofRise( ADC,
                                                           iStart,
                                                           iEnd,
                                                           ch,
                                                           NegPolarity,
                                                           Quadratic7point ) ;

           ySlope[ch,CursorSet] := Slope( ADC,
                                           iStart,
                                           iEnd,
                                           ch ) ;

           yMaxRisingSlope[ch,CursorSet] := RisingSlope( ADC,
                                                         ch,
                                                         yMaxAt[ch,CursorSet],
                                                         yMax[ch,CursorSet] + YZero[ch,CursorSet],
                                                         yC0[ch,CursorSet],
                                                         PosPolarity ) ;

           yMinRisingSlope[ch,CursorSet] := RisingSlope( ADC,
                                                         ch,
                                                         yMinAt[ch,CursorSet],
                                                         yMin[ch,CursorSet] + YZero[ch,CursorSet],
                                                         yC0[ch,CursorSet],
                                                         NegPolarity ) ;

           end ;

        end ;

    // Add to plot(s)
    // --------------

    // Add variable column titles to log file
    if PlotsChanged then begin
       s := #9 + 'Record' + #9 + 'Time (s)';
       for iPlot := 0 to Settings.RecPlot.NumPlots-1 do begin
           s := s + #9 + Settings.RecPlot.Plot[iPlot].YLabel ;
           end ;
       WriteToLogFile(s) ;
       PlotsChanged := False ;
       end ;

    for iP := 0 to Settings.RecPlot.NumPlots-1 do
        if (Settings.RecPlot.Plot[iP].StimProtocol = StimProtocolInUse) or
           (Settings.RecPlot.Plot[iP].StimProtocol = '') then begin

        plPlot.PlotNum := Settings.RecPlot.Plot[iP].PlotNum ;
        iChan := Settings.RecPlot.Plot[iP].ChanNum ;
        CursorSet := Settings.RecPlot.Plot[iP].CursorSet ;

        case Settings.RecPlot.Plot[iP].VarNum of

           // Average
           vAverage : begin
              y := yAverage[iChan,CursorSet] ;
              end ;

           // Peak
           vPeak : begin
              case Settings.RecPlot.Plot[iP].Polarity of
                 PosPolarity : y := yMax[iChan,CursorSet] ;
                 NegPolarity : y := yMin[iChan,CursorSet] ;
                else begin
                  if Abs(yMax[iChan,CursorSet]) >
                     yMin[iChan,CursorSet] then
                       y := yMax[iChan,CursorSet]
                  else y := yMin[iChan,CursorSet] ;
                  end ;
                end ;
              end ;

           // Rise time
           vTRise : begin
              case Settings.RecPlot.Plot[iP].Polarity of
                 PosPolarity : y := yMaxTRise[iChan,CursorSet] ;
                 NegPolarity : y := yMinTRise[iChan,CursorSet] ;
                else begin
                  if Abs(yMax[iChan,CursorSet]) >
                     yMin[iChan,CursorSet] then
                         y := yMaxTRise[iChan,CursorSet]
                    else y := yMinTRise[iChan,CursorSet] ;
                  end ;
                end ;
              end ;

           // Rate of rise
           vRateOfRise : begin
              case Settings.RecPlot.Plot[iP].RateofRiseSmoothing of
                 ForwardDifference : begin
                    YPos := yMaxRateOfRiseFD[iChan,CursorSet] ;
                    YNeg := yMinRateOfRiseFD[iChan,CursorSet] ;
                    end ;
                 Quadratic5point : begin
                    YPos := yMaxRateOfRiseQ5[iChan,CursorSet] ;
                    YNeg := yMinRateOfRiseQ5[iChan,CursorSet] ;
                    end ;
                 Quadratic7point : begin
                    YPos := yMaxRateOfRiseQ7[iChan,CursorSet] ;
                    YNeg := yMinRateOfRiseQ7[iChan,CursorSet] ;
                    end ;
                 end ;

              case Settings.RecPlot.Plot[iP].Polarity of
                  PosPolarity : y := YPos ;
                  NegPolarity : y := YNeg ;
                  AbsPolarity : begin
                    if Abs(YPos) > Abs(YNeg) then y := YPos
                                             else y := YNeg ;
                    end ;
                  end ;
              end ;

           vSlope : y := ySlope[iChan,CursorSet] ;

           vRisingSlope : begin
              case Settings.RecPlot.Plot[iP].Polarity of
                 PosPolarity : y := yMaxRisingSlope[iChan,CursorSet] ;
                 NegPolarity : y := yMinRisingSlope[iChan,CursorSet] ;
                 else begin
                    if Abs(yMax[iChan,CursorSet]) > yMin[iChan,CursorSet] then
                       y := yMaxTRise[iChan,CursorSet]
                    else y := yMinTRise[iChan,CursorSet] ;
                    end ;
                 end ;
              end ;

           vC1 : y := yC1[iChan,CursorSet] ;
           vC2 : y := yC2[iChan,CursorSet] ;
           vC3 : y := yC3[iChan,CursorSet] ;
           vC4 : y := yC4[iChan,CursorSet] ;

           else y := 0.0 ;
           end ;

        // Elapsed time
        if ResetTimeZero then begin ;
           TZero := TimeGetTime ;
           ResetTimeZero := False ;
           end ;

        t := (TimeGetTime - TZero)*0.001 ;
        plPlot.AddPoint( Settings.RecPlot.Plot[iP].LineNum, t, y ) ;

        // Add record number and time at beginning of line
        if iP = 0 then s := format('%s%d%s%.5g',[#9,RecordNum,#9,t] ) ;

        s := s + #9 + format('%.5g',[y]) ;

        end ;

    // Place cursor at end of plot
    t := (TimeGetTime - TZero)*0.001 ;
    plPlot.VerticalCursors[0] := t ;

    // Display results in log file
    if Length(s) > 8 then WriteToLogFile(s) ;


    end ;

function TRecPlotFrm.RiseTime(
         var ADC : Array of SmallInt ;
         iStart : Integer ;     // Start at point
         iPeakAt : Integer ;       // Peak point
         iChan : Integer ;      // input channel
         YPeak : Single ;       // Peak amplitude
         YZero : Single ;       // Zero level
         Polarity : Integer   // Polarity of rise
         ) : Single ;
// --------------------------------------------
// Calculate 10-90% rise time to peak of signal
// --------------------------------------------
var
    Y,YPeak10,YPeak90,YHi,YLo,YHiPrev,YLoNext : Single ;
    dRiseTime : Single ;
    Invert : Single ;
    j,i0,i1 : Integer ;
    YScale : Single ;
    iChanOffset,iZeroLevel : Integer ;
begin


    // Rise time (10-90%) (positive peak)
    // (Note rise time relative to baseline defined by level at cursor 0)

    if Polarity = PosPolarity then Invert := 1.0
                              else Invert := -1.0 ;

    // Get lo-hi limits (ensuring lo < hi)
    YHi := (YPeak - YZero)*Invert ;
    YPeak10 := YHi*edRiseTimeRange.LoValue ;
    YPeak90 := YHi*edRiseTimeRange.HiValue ;

    { Calculate lo% - hi% rise time }
    i0 := Min(iPeakAt + 1,Main.SESLabIO.ADCNumSamples-1);
    i1 := i0 ;
    iChanOffset := Main.SESLabIO.ADCChannelOffset[iChan] ;
    iZeroLevel := Main.SESLabIO.ADCChannelZero[iChan] ;
    YScale := Main.SESLabIO.ADCChannelUnitsPerBit[iChan] ;
    repeat
       i0 := i0 - 1 ;
       j := (i0*Main.SESLabIO.ADCNumChannels) + iChanOffset ;
       Y := ((ADC[j]-iZeroLevel)*YScale - YZero)*Invert ;

       // Save amplitude and last point above upper limit.
       if Y >= YPeak90 then begin
          i1 := i0 ;
          YHi := Y ;
          end ;

       // Save first point below limit
       YLo := Y ;

       // Exit when amplitude drops below lower limit
       until (Y <= YPeak10) or (i0 <= iStart) ;

    YHiPrev := ((ADC[(i1-1)*Main.SESLabIO.ADCNumChannels + iChanOffset]*YScale) - YZero)*Invert ;
    YLoNext := ((ADC[(i0+1)*Main.SESLabIO.ADCNumChannels + iChanOffset]*YScale) - YZero)*Invert ;
    dRiseTime := 0.0 ;
    if YHi <> YHiPrev then dRiseTime := dRiseTime - abs(((YPeak90 - YHi) /(YHi - YHiPrev))) ;
    if YLoNext <> YLo then dRiseTime := dRiseTime - abs(((YPeak10 - YLo) /(YLoNext - YLo))) ;
    dRiseTime := dRiseTime*Main.SESLabIO.ADCSamplingInterval ;

    Result := (i1-i0)*Main.SESLabIO.ADCSamplingInterval + dRiseTime ;
    Result := Result*1000.0 ; // Convert to ms
    end ;


function TRecPlotFrm.RateOfRise(
          var ADC : Array of SmallInt ;
          iStart : Integer ;     // Start at point
          iEnd : Integer ;       // End at point
          iChan : Integer ;      // input channel
          Polarity : Integer ;   // Polarity of rate of change
          DifferentiationMode : Integer // Differention mode
          ) : Single ;
// ----------------------------
// Compute maximum rate of rise
// ----------------------------
var
    A : array[-15..15] of single ;
    ASum : single ;
    i,j,k,jLow,jHigh : Integer ;
    Diff,YDiffMax : Single ;

begin

    // Set up for type of differention

    case DifferentiationMode of

       ForwardDifference : begin
         jLow := 0 ;
         jHigh := 1 ;
         A[0] := -1.0 ;
         A[1] := 1.0 ;
         ASum := 1.0 ;
         end ;

       Quadratic5Point :begin
         jLow := -2 ;
         jHigh := 2 ;
         for j := jLow to jHigh do A[j] := j ;
         ASum := 10.0 ;
         end ;

       else begin
         jLow := -3 ;
         jHigh := 3 ;
         for j := jLow to jHigh do A[j] := j ;
         ASum := 28.0 ;
         end ;

        end ;

    // Max. positive rate of change
    YDiffMax := 0 ;
    for i := iStart to iEnd do begin
        Diff := 0.0 ;
        for j := jLow to jHigh do begin
            k := Min(Max(i+j,0),fH.NumSamples-1) *
                 Main.SESLabIO.ADCNumChannels + Main.SESLabIO.ADCChannelOffset[iChan] ;
            Diff := Diff + A[j]*ADC[k] ;
            end ;
        Diff := Diff / ASum ;
        if Polarity = PosPolarity then begin
           if Diff > YDiffMax then YDiffMax := Diff ;
           end
        else begin
           if Diff < YDiffMax then YDiffMax := Diff ;
           end ;

        end ;

    // Scale to signals units (Channels Units/ms)
    Result := YDiffMax*Main.SESLabIO.ADCChannelUnitsPerBit[iChan]/(Main.SESLabIO.ADCSamplingInterval*1000.0) ;

    end ;

function TRecPlotFrm.Slope(
          var ADC : Array of SmallInt ;
          iStart : Integer ;     // Start at point
          iEnd : Integer ;       // End at point
          iChan : Integer       // input channel
          ) : Single ;
// -----------------------
// Calculate slope of line
// -----------------------
var
     i,j : Integer ;
     y,t,dt : Single ;          //
     SumT : Single ;        // Summation variables for time constant fit
     SumT2 : Single ;         //
     SumY : Single ;         //
     SumYT : Single ;         //
     Denom : Single ;
     nPoints : Integer ;
begin

   // Calculate decay time constant
   t := 0.0 ;
   SumT := 0.0 ;
   SumT2 := 0.0 ;
   SumY := 0.0 ;
   SumYT := 0.0 ;
   dt := Main.SESLabIO.ADCSamplingInterval*1000.0 ; // time in ms
   nPoints := iEnd - iStart + 1 ;
   for i := iStart to iEnd do begin
      j := i*Main.SESLabIO.ADCNumChannels + Main.SESLabIO.ADCChannelOffset[iChan] ;
      Y := ADC[j]*Main.SESLabIO.ADCChannelUnitsPerBit[iChan] ;
      SumT := SumT + t ;
      SumT2 := SumT2 + t*t ;
      SumY := SumY + Y ;
      SumYT := SumYT + Y*T ;
      t := t + dt ;
      end ;

   Denom := (nPoints*SumT2) - (SumT*SumT) ;
   if Denom <> 0.0 then Result := ((nPoints*SumYT) - (SumT*SumY))/ Denom
                   else Result := 0.0 ;

   end ;


function TRecPlotFrm.RisingSlope(
          var ADC : Array of SmallInt ;
          iChan : Integer ;      // input channel
          iPeakAt : Integer ;
          YPeak : Single ;
          YBaseline : Single ;
          Polarity : Integer
          ) : Single ;
// -----------------------
// Calculate slope of line
// -----------------------
var
    Y,YPeak10,YPeak90,YHi : Single ;
    Invert : Single ;
    j,iStart,iEnd : Integer ;
    YScale : Single ;
    iChanOffset,iZeroLevel : Integer ;
begin

    if Polarity = PosPolarity then Invert := 1.0
                              else Invert := -1.0 ;

    // Get lo-hi limits (ensuring lo < hi)
    YHi := (YPeak - YBaseline)*Invert ;
    YPeak10 := YHi*edRiseTimeRange.LoValue ;
    YPeak90 := YHi*edRiseTimeRange.HiValue ;

    { Calculate lo% - hi% rise time }
    iStart := Max(Min(iPeakAt + 1,Main.SESLabIO.ADCNumSamples-1),0);
    iEnd := iStart ;
    iChanOffset := Main.SESLabIO.ADCChannelOffset[iChan] ;
    iZeroLevel := Main.SESLabIO.ADCChannelZero[iChan] ;
    YScale := Main.SESLabIO.ADCChannelUnitsPerBit[iChan] ;
    repeat
       iStart := iStart - 1 ;
       j := (iStart*Main.SESLabIO.ADCNumChannels) + iChanOffset ;
       Y := ((ADC[j]-iZeroLevel)*YScale - YBaseline)*Invert ;
       if Y >= YPeak90 then iEnd := iStart ;
       until (Y <= YPeak10) or (iStart <= 0) ;

    Result := Slope( ADC, iStart,iEnd, iChan ) ;

    end ;


procedure TRecPlotFrm.FormShow(Sender: TObject);
// -------------------------------------
// Initialisation when form is displayed
// -------------------------------------
var
    ch : Integer ;
begin

     // Measurement variables
     cbPlotVar.Clear ;
     cbPlotVar.Items.AddObject( 'Average', TObject(vAverage) ) ;
     cbPlotVar.Items.AddObject( 'Peak', TObject(vPeak) ) ;
     cbPlotVar.Items.AddObject( 'Rise time', TObject(vTRise) ) ;
     cbPlotVar.Items.AddObject( 'Rate of Rise', TObject(vRateOfRise) ) ;
     cbPlotVar.Items.AddObject( 'Slope', TObject(vSlope) ) ;
     cbPlotVar.Items.AddObject( 'Rising slope', TObject(vRisingSlope) ) ;
     cbPlotVar.Items.AddObject( 'Cursor 1', TObject(vC1) ) ;
     cbPlotVar.Items.AddObject( 'Cursor 2', TObject(vC2) ) ;
     cbPlotVar.Items.AddObject( 'Cursor 3', TObject(vC3) ) ;
     cbPlotVar.Items.AddObject( 'Cursor 4', TObject(vC4) ) ;
     cbPlotVar.ItemIndex := 0 ;

     // Rate of rise options
     cbPolarity.Clear ;
     cbPolarity.Items.Add( 'Positive') ;
     cbPolarity.Items.Add( 'Negative') ;
     cbPolarity.Items.Add( 'Absolute') ;
     cbPolarity.ItemIndex := 0 ;

     cbRateofRiseSmooth.Clear ;
     cbRateofRiseSmooth.Items.Add('1 point') ;
     cbRateofRiseSmooth.Items.Add('5 points') ;
     cbRateofRiseSmooth.Items.Add('7 points') ;
     cbRateofRiseSmooth.ItemIndex := 0 ;

     // Channels
     cbPlotChan.Clear ;
     for ch := 0 to Main.SESLabIO.ADCNumChannels-1 do begin
         cbPlotChan.Items.Add( Main.SESLabIO.ADCChannelName[ch] ) ;
         end ;
     cbPlotChan.ItemIndex := 0 ;

     mePlotList.Clear ;

     plPlot.AddVerticalCursor( clGreen, '?r' ) ;

     { Fill combo box with list of available command voltage programs }
     Stimulator.CreateProtocolList( cbPulseProgram ) ;

     ResetTimeZero := True ;
     PlotsChanged := True ;

     // Update addition controls for selected variable
     ShowControls ;

     ClientHeight := ControlsGrp.Top + ControlsGrp.Height + 5 ;

     bClearPoints.Click ;

     Resize ;

     end;


procedure TRecPlotFrm.ShowControls ;
// -------------------------------------------------
// Display additional controls for selected variable
// -------------------------------------------------
begin

    case Integer(cbPlotVar.Items.Objects[cbPlotVar.ItemIndex]) of
        vPeak,vTRise,vRateofRise,vRisingSlope : panPolarity.Visible := True ;
        else panPolarity.Visible := False ;
        end ;

    case Integer(cbPlotVar.Items.Objects[cbPlotVar.ItemIndex]) of
        vTRise,vRisingSlope : panRiseTime.Visible := True ;
        else panRiseTime.Visible := False ;
        end ;

    case Integer(cbPlotVar.Items.Objects[cbPlotVar.ItemIndex]) of
        vRateofRise : panRateofRiseSmooth.Visible := True ;
        else panRateofRiseSmooth.Visible := False ;
        end ;

    case Integer(cbPlotVar.Items.Objects[cbPlotVar.ItemIndex]) of
        vC1,vC2,vC3,vC4 : panCursors.Visible := True ;
        else panCursors.Visible := False ;
        end ;
    panCursorSet.Visible := not panCursors.Visible ;

    case Integer(cbPlotVar.Items.Objects[cbPlotVar.ItemIndex]) of
        vC1,vC2,vC3,vC4 : panCursors.Visible := True ;
        else panCursors.Visible := False ;
        end ;

    end ;


procedure TRecPlotFrm.bAddPlotClick(Sender: TObject);
// ---------------------
// Add new plot to graph
// ---------------------
var
    YUnits : String ;
begin
     { Add new Y Axis to plot }

     if Settings.RecPlot.NumPlots >= MaxOnLinePlots then Exit ;

     Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].PlotNum := plPlot.CreatePlot ;
     Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].Polarity := cbPolarity.ItemIndex ;
     Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].RateofRiseSmoothing := cbRateofRiseSmooth.ItemIndex ;
     Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].StimProtocol := cbPulseProgram.Text ;
     if Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].StimProtocol = ' ' then
        Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].StimProtocol := '' ;

     // Ensure there is enough space allocated for line
     plPlot.MaxPointsPerLine := 100000 ;

     // Add`new line to plot
     Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].LineNum := plPlot.CreateLine( clBlue, msOpenSquare,psSolid, '' ) ;

     Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].VarNum := Integer( cbPlotVar.Items.Objects[cbPlotVar.ItemIndex] ) ;
     Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].ChanNum := cbPlotChan.ItemIndex ;
     Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].CursorSet := cbCursorSet.ItemIndex ;

     plPlot.XAxisLabel := 's' ;
     plPlot.YAxisLabel := cbPlotVar.Text  ;

     // Add polarity (if required)
     case Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].VarNum of
        vPeak,vTRise,vRateofRise,vRisingSlope : begin
           case Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].Polarity of
                PosPolarity : plPlot.YAxisLabel := plPlot.YAxisLabel + '(+)' ;
                NegPolarity : plPlot.YAxisLabel := plPlot.YAxisLabel +  '(-)' ;
                else plPlot.YAxisLabel := plPlot.YAxisLabel + '(a)' ;
                end ;
           end ;
        end ;

     // Smoothing
     case Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].VarNum of
        vRateofRise : begin
          case Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].RateofRiseSmoothing of
            0 : plPlot.YAxisLabel := plPlot.YAxisLabel + '(1)' ;
            1 : plPlot.YAxisLabel := plPlot.YAxisLabel + '(5)' ;
            else plPlot.YAxisLabel := plPlot.YAxisLabel + '(7)' ;
            end ;
          end ;
        end ;

     // Add channel
     plPlot.YAxisLabel := plPlot.YAxisLabel + ' ' + cbPlotChan.Text ;

     // Add cursor set
     if (Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].VarNum <> vC1) and
        (Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].VarNum <> vc2) and
        (Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].VarNum <> vC3) and
        (Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].VarNum <> vC4) then begin
        plPlot.YAxisLabel := plPlot.YAxisLabel + ' ' + format(' (%d-%d)',
                             [2*Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].CursorSet+1,
                             2*Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].CursorSet+2]) ;
        end ;

     // Update list of variables displayed
     Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].ListEntry := plPlot.YAxisLabel ;
     mePlotList.Lines.Add(Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].ListEntry) ;
     if Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].StimProtocol <> '' then
        mePlotList.Lines.Add('from ' + Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].StimProtocol) ;

     // Add units
     YUnits := Main.SESLabIO.ADCChannelUnits[Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].ChanNum] ;
     case Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].VarNum of

        vPeak : begin
            plPlot.YAxisLabel := plPlot.YAxisLabel + ' (' + YUnits + ')' ;
            end ;

        vTRise : begin
            plPlot.YAxisLabel := plPlot.YAxisLabel + ' (ms)' ;
            end ;

        vRateOfRise,vSlope,vRisingSlope : begin
            plPlot.YAxisLabel := plPlot.YAxisLabel + ' (' + YUnits + '/ms)' ;
            end ;

        else begin
            plPlot.YAxisLabel := plPlot.YAxisLabel + ' (' + YUnits + ')' ;
            end ;
        end ;
     Settings.RecPlot.Plot[Settings.RecPlot.NumPlots].YLabel := plPlot.YAxisLabel ;


     { Plot graph of currently selected variables }
     plPlot.xAxisAutoRange := True ;
     plPlot.yAxisAutoRange := True ;

     plPlot.Invalidate ;

     Inc(Settings.RecPlot.NumPlots) ;

     PlotsChanged := True ;

     end;

procedure TRecPlotFrm.FormClose(Sender: TObject; var Action: TCloseAction);
// ------------
// Close window
// ------------
begin
     Action := caFree ;
     end;

procedure TRecPlotFrm.FormResize(Sender: TObject);
// -----------------------------------------
// Update controls on form when form resized
// -----------------------------------------
begin
     ControlsGrp.Height := ClientHeight - ControlsGrp.Top - 5 ;
     plPlot.Height := Max(ClientHeight - plPlot.Top - 5,2) ;
     plPlot.Width := Max(ClientWidth - plPlot.Left - 5,2) ;
     end;


procedure TRecPlotFrm.Button1Click(Sender: TObject);
// -----------
// Clear plots
// -----------
begin
     plPlot.ClearAllPlots ;
     mePlotList.Clear ;
     ResetTimeZero := True ;
     Settings.RecPlot.NumPlots := 0 ;
     end;


procedure TRecPlotFrm.bClearPointsClick(Sender: TObject);
// ------------------------
// Clear all data from plot
// ------------------------
var
    iPlot : Integer ;
begin

     plPlot.ClearAllPlots ;
     mePlotList.Clear ;

     ResetTimeZero := True ;

     // Ensure there is enough space allocated for line
     plPlot.MaxPointsPerLine := 100000 ;
     plPlot.XAxisLabel := 's' ;

     for iPlot := 0 to Settings.RecPlot.NumPlots-1 do begin

        Settings.RecPlot.Plot[iPlot].PlotNum := plPlot.CreatePlot ;

         // Add`new line to plot
        Settings.RecPlot.Plot[iPlot].LineNum := plPlot.CreateLine( clBlue, msOpenSquare,psSolid, '' ) ;

        plPlot.YAxisLabel := Settings.RecPlot.Plot[iPlot].YLabel ;

        mePlotList.Lines.Add(Settings.RecPlot.Plot[iPlot].ListEntry) ;

        { Plot graph of currently selected variables }
        plPlot.xAxisAutoRange := True ;
        plPlot.yAxisAutoRange := True ;

        end ;

     plPlot.Invalidate ;

     end;


procedure TRecPlotFrm.CopyDataToClipBoard ;
{ ---------------------------------------------
  Copy the graph plot(s) data to the clipboard
  --------------------------------------------- }
begin
     plPlot.CopyDataToClipboard ;
     end ;


procedure TRecPlotFrm.Print ;
{ ------------------------------
  Print graph plot(s) on display
  ------------------------------ }
begin
        plPlot.ClearPrinterTitle ;
        plPlot.AddPrinterTitleLine( ' File : ' + FH.FileName ) ;
        plPlot.AddPrinterTitleLine( ' ' + FH.IdentLine ) ;
        plPlot.Print ;
     end ;


procedure TRecPlotFrm.CopyImageToClipboard ;
{ ------------------------------------------------------------
  Copy image of graph plot(s) to clipboard as Windows metafile
  ------------------------------------------------------------ }
begin
     plPlot.CopyImageToClipboard ;
     end ;


procedure TRecPlotFrm.cbPlotVarChange(Sender: TObject);
// -------------------------
// Selected variable changed
// -------------------------
begin
     ShowControls ;
     end;

procedure TRecPlotFrm.bCopyToClipboardClick(Sender: TObject);
// ------------------------------------
// Copy plot data to Windows clipboard
// ------------------------------------
begin
     CopyDataToClipboard ;
     end;

end.
