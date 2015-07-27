unit Pwrspec;
{ ======================================================================
  WinWCP (c) J. Dempster, University of Strathclyde, All Rights Reserved
  Non-stationary Variance / Spectral Analysis module
  ======================================================================
  11/9/99 ... Non-stationary noise analysis
  21/9/99 ... Mid-point alignment added
  3/11/99 ... NewFile now closes form if no records available
  31/1/01 ... Records can now be selected for analysis on basis of record type
              Error in variance computation which excluded peak scaling corrected.
  7/3/01  ... Hard copy of variance-mean plots can now works
  29/8/01 ... Fixed zero level now saved when changed
              From Record zero area indicated by pair of small vertical bars
  19/11/01 ... Average now computed from record range
  3/12/01 ... NewFile now retains displayed record number position
  15/01/02 ... Average now scaled by point on record at peak of average
  16/01/02 ... Average subtraction now works correctly for negative signals
  27/01/02 ... MaxPointsPerLine of XYPlotDisplay components now adjusted to correct size.
  12/2/03 .... Divide by zero error when signal level is zero fixed.
  24.6.03 ... No. of display grid lines can be changed
  21.7.03 ... FitData and nFits now passed correctly to SetFitParamters
              progress now reported on status bar
  01.01.04 .. Out of memory error blocked when windows resized to tiny size
  24.04.06 .. Spectrum copy to clipboard now works
              Spectrum fit results equation now has correct super and sub-scripts
  07.12.06 .. Data with amplitudes greater than 327676 now handled correctly
              Records with long sample lengths now work correctly
              scDisplay.MaxADCValues now derived from WCP file
  08.12.08 .. Parabolic fit curve adjusted to lie just within X axis limits
              to avoid increasing limits every time a curve is fitted
  07.12.09 .. Variance analysis parameters now saved in WCP file header
  27.12.12 .. Spectrum frequency scale now correct (half what it was)
  07.06.13 .. FH.NumZeroAvg now updated when changed in ZeroFrm
  27.07.15 .. iline added to .CreateLine() & .AddPointToLine()
  }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Spin, TabNotBk, ClipBrd,
  global, shared, maths, Grids, setfitpa, printers, fileio,
 ComCtrls, RangeEdit, ValEdit, ScopeDisplay, XYPlotDisplay, ValidatedEdit, math, seslabio ;

const
 //    MaxRecordSize = 8192 ;
     NumDisplayChannels = 2 ;
     ChData = 0 ;
     ChRes = 1 ;
     NoAlignment = 0 ;
     OnPositiveRise = 1 ;
     OnNegativeRise = 2 ;

type

    TRecType = ( Background,Test) ;

    TVariance = record
          StartAtRec : Integer ;
          EndAtRec : Integer ;
          NumRecordsAveraged : Integer ;
          Chan : Integer ;
          StartSample : Integer ;
          EndSample : Integer ;
          AvgPeak : single ;
          AvgAlignedAt : Integer ;
          AvgPeakAt : Integer ;
          end ;


   TSpectrum = record
              RecordNum : Integer ;
              RecordSize : Integer ;
              StartAt : Integer ;
              EndAt : Integer ;
              NumAveraged : Integer ;
              NumPoints : Integer ;
              Available : Boolean ;
              Frequency : Array[0..(MaxPoints div 2)+1] of single ;
              Power : Array[0..(MaxPoints div 2)+1] of single ;
              Variance : single ;
              AvgDCMean : single ;
              MedianFrequency : single ;
              NewPlot : Boolean ;
              end ;

   TSpecCursors = record
         C0 : Integer ;
         C1 : Integer ;
         Read : Integer ;
         end ;


  TPwrSpecFrm = class(TForm)
    Page: TPageControl;
    DataTab: TTabSheet;
    VarianceTab: TTabSheet;
    SpectrumTab: TTabSheet;
    ControlGrp: TGroupBox;
    Label10: TLabel;
    sbRecord: TScrollBar;
    ckRejected: TCheckBox;
    cbRecordType: TComboBox;
    VarGrp: TGroupBox;
    GroupBox5: TGroupBox;
    Label9: TLabel;
    Label8: TLabel;
    cbVarYAxis: TComboBox;
    cbVarXAxis: TComboBox;
    bDoVariance: TButton;
    bVarSetAxes: TButton;
    VarFitGrp: TGroupBox;
    bVarFit: TButton;
    cbVarEquation: TComboBox;
    specGrp: TGroupBox;
    GroupBox8: TGroupBox;
    rbNoWindow: TRadioButton;
    rbCosineWindow: TRadioButton;
    bDoSpectrum: TButton;
    bSpecSetAxes: TButton;
    GroupBox10: TGroupBox;
    Label11: TLabel;
    rbNoFreqAveraging: TRadioButton;
    rbLogFreqAveraging: TRadioButton;
    rbLinFreqAveraging: TRadioButton;
    edNumFreqAveraged: TValidatedEdit;
    GroupBox11: TGroupBox;
    ckSubtractTrends: TCheckBox;
    ckSubtract50Hz: TCheckBox;
    SpecFitGrp: TGroupBox;
    bFitLorentzian: TButton;
    cbSpecEquation: TComboBox;
    plSpecPlot: TXYPlotDisplay;
    erSpecResults: TRichEdit;
    erVarResults: TRichEdit;
    plVarPlot: TXYPlotDisplay;
    edRecord: TRangeEdit;
    AverageGrp: TGroupBox;
    GroupBox1: TGroupBox;
    rbAllRecords: TRadioButton;
    rbRange: TRadioButton;
    edRecRange: TRangeEdit;
    GroupBox4: TGroupBox;
    Label12: TLabel;
    cbAlignMode: TComboBox;
    rbScaleToPeak: TRadioButton;
    rbNoScale: TRadioButton;
    cbChannel: TComboBox;
    Label1: TLabel;
    edNumFFTPoints: TValidatedEdit;
    Label2: TLabel;
    Shape2: TShape;
    cbTypeToBeAnalysed: TComboBox;
    Label7: TLabel;
    GroupBox2: TGroupBox;
    lbPlotRecordRange: TLabel;
    lbPlotSampleRange: TLabel;
    BaselineVarGrp: TGroupBox;
    bCalcBaselineVariance: TButton;
    edBaselineVariance: TEdit;
    scDisplay: TScopeDisplay;
    ckFixedZeroLevels: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbRecordChange(Sender: TObject);
    procedure bDoVarianceClick(Sender: TObject);
    procedure bDoSpectrumClick(Sender: TObject);
    procedure bSpecSetAxesClick(Sender: TObject);
    procedure bVarSetAxesClick(Sender: TObject);
    procedure cbRecordTypeChange(Sender: TObject);
    procedure ckRejectedClick(Sender: TObject);
    procedure edRecordKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bFitLorentzianClick(Sender: TObject);
    procedure bVarFitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure cbAlignModeChange(Sender: TObject);
    procedure rbScaleToPeakClick(Sender: TObject);
    procedure rbNoScaleClick(Sender: TObject);
    procedure cbChannelChange(Sender: TObject);
    procedure scDisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbTypeToBeAnalysedChange(Sender: TObject);
    procedure rbAllRecordsClick(Sender: TObject);
    procedure edRecRangeKeyPress(Sender: TObject; var Key: Char);
    procedure bCalcBaselineVarianceClick(Sender: TObject);
    procedure ckFixedZeroLevelsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
   ADC : PLongIntArray ;    { A/D sample data array }
   InBuf : PLongIntArray ;  { A/D sample data array }
   Avg : PLongIntArray ;    { Averaged A/D sample data array }
   Sum : PSingleArray ;      { Summation array (used by ComputeAverage) }
   VarBuf : PSingleArray ; { Ensemble variance array }
   Mean : PSingleArray ;     { Ensemble mean current array }
   PowerSpectrum : TSpectrum ;

   DispCursors : TSpecCursors ;
   VarFunc : TMathFunc ;
   VarCursors : TSpecCursors ;
   SpecFunc : TMathFunc ;
   SpecCursors : TSpecCursors ;
   Variance : TVariance ;
   OldNumChannels : Integer ;
   Results : TStringList ; // Curve fitting results



    procedure DisplayRecord ;
    procedure ComputeAverage ;
    function FindPeak( var Buf : Array of Integer ;
                       NumChannels : Integer ;
                       ChanOffset : Integer ;
                       yZero : Integer ;
                       var PeakFoundAt : Integer
                       ) : single ;
    function FindMidPointOfRise( var Buf : Array of Integer ;
                                 NumChannels : Integer ;
                                 ChanOffset : Integer ;
                                 yZero : Integer ) : Integer ;

    procedure SubtractScaledAverage( var Buf : Array of Integer ;
                                     var AvgScale : single ;
                                     var iShift : Integer ) ;

    function GetVariable( ItemIndex : Integer ; iSample : Integer ) : single ;
    function GetVariableUnits( ItemIndex : Integer ) : string ;

    procedure ComputePowerSpectrum( var Spectrum : TSpectrum ) ;
    procedure AverageFrequencies( var Spectrum : TSpectrum ) ;
    procedure SubtractLinearTrend( var Y : Array of single ;
                                   iStart,iEnd : Integer ) ;
    procedure Subtract50HzPeak( var Spectrum : TSpectrum ) ;

    procedure CosineWindow( iStart,iEnd : Integer ;
                            var Y : Array of single ;
                            var VarianceCorrection : single ) ;
    procedure SpectralVariance( var Spectrum : TSpectrum ) ;

    function UseRecord ( const RecH : TRecHeader ; RecType : string ) : Boolean ;

  public
    { Public declarations }
    procedure NewFile ;
    procedure PrintDisplay ;
    procedure CopyDataToClipboard ;
    procedure CopyImageToClipboard ;
    Function DataAvailable : Boolean ;
    Function ImageAvailable : Boolean ;

    procedure SetMenus ;
    procedure ZoomOut ;
    procedure ZoomIn( Chan : Integer ) ;
    procedure ChangeDisplayGrid ;
  end;

var
  PwrSpecFrm: TPwrSpecFrm;

implementation

uses mdiform,setaxes, Printgra, Printrec, Zero ;

const
     vSample = 0 ;
     vTime = 1 ;
     vAvg = 2 ;
     vStDev = 3 ;
     vVariance = 4 ;

     DataPage = 0 ;
     VariancePage = 1 ;
     SpectrumPage = 2 ;
     VarDataLine = 0 ;
     VarFitLine = 1 ;
     SpecDataLine = 0 ;
     SpecBackLine = 1 ;
     SpecFitLine = 2 ;

   {$R *.DFM}


procedure TPwrSpecFrm.FormShow(Sender: TObject);
{ --------------------------------------
  Initialisations when form is displayed
  --------------------------------------}
begin

     // Set position of form
     Left := 35 ;
     Top := 35 ;
     Height := Main.StatusBar.Top - Top - 10 ;
     Width := Main.ClientWidth - Left - 20 ;

     // Current channel selected for analysis
     cbChannel.ItemIndex := 0 ;
     cbAlignMode.ItemIndex := 0 ;

     { Set record type list }
     cbRecordType.items := RecordTypes ;
     cbRecordType.items.delete(0) ; {Remove 'ALL' item}

     { Set record type to be analysed list }
     cbTypeToBeAnalysed.items := RecordTypes ;
     if cbTypeToBeAnalysed.itemIndex < 0 then cbTypeToBeAnalysed.itemIndex := 0 ;

     { Initial axis variable selections for variance plot }
     cbVarXAxis.ItemIndex := vSample ;
     cbVarYAxis.ItemIndex := vVariance ;

     { Create list of curves that can be fitted to x/y plots }
     cbVarEquation.Clear ;
     cbVarEquation.Items.AddObject( 'None', TObject(None)) ;
     cbVarEquation.Items.AddObject( 'Linear', TObject(Linear)) ;
     cbVarEquation.Items.AddObject( 'Parabola', TObject(Parabola)) ;
     cbVarEquation.Items.AddObject( 'Exponential', TObject(Exponential)) ;
     cbVarEquation.ItemIndex := 0 ;

     { Create list of curves that can be fitted to spectrum }
     cbSpecEquation.Clear ;
     cbSpecEquation.Items.AddObject( 'None', TObject(None)) ;
     cbSpecEquation.Items.AddObject( 'Lorentzian', TObject(Lorentzian)) ;
     cbSpecEquation.Items.AddObject( 'Lorentzian(X2)', TObject(Lorentzian2)) ;
     cbSpecEquation.Items.AddObject( 'Lor. + 1/f ', TObject(LorAndOneOverF)) ;
     { Set initial power spectrum equation to None }
     cbSpecEquation.ItemIndex := 0 ;



     // Start on data display page
     Page.ActivePage := DataTab ;

     // Adjust controls/pages to size of window }
     Resize ;

     // Initialise display/controls
     NewFile ;

     end;


procedure TPwrSpecFrm.NewFile ;
//
// Update settings when a new file is opened
// -----------------------------------------
var
   ch,n : Integer ;
   Range : Single ;
begin

     if RawFH.Numrecords > 0 then begin

        if ADC = Nil then FreeMem( ADC ) ;
        GetMem( ADC, RawFH.NumSamples*2*4 ) ;
        if InBuf = Nil then FreeMem(InBuf) ;
        GetMem(InBuf, RawFH.NumSamples*RawFH.NumChannels*4 ) ;
        if Avg = Nil then FreeMem(Avg) ;
        GetMem(Avg, RawFH.NumSamples*4 ) ;
        if Sum = Nil then FreeMem(Sum) ;
        GetMem(Sum, RawFH.NumSamples*4 ) ;
        if VarBuf = Nil then FreeMem(VarBuf) ;
        GetMem(VarBuf, RawFH.NumSamples*4 ) ;
        if Mean = Nil then FreeMem(Mean) ;
        GetMem(Mean, RawFH.NumSamples*4 ) ;

        { Fill channel selection list }
        cbChannel.Clear ;
        for ch := 0 to RawFH.NumChannels-1 do begin
            cbChannel.items.add( format('Ch.%d %s',[ch,Channel[ch].ADCName]) ) ;
            end ;

        // Current channel selected for analysis
        cbChannel.ItemIndex := Min(Max(RawFH.NSVChannel,0),RawFH.NumChannels-1) ;

        // Set alignment mode
        cbAlignMode.ItemIndex := Min(Max(RawFH.NSVAlignmentMode,0),2) ;

        cbTypeToBeAnalysed.ItemIndex := Min(Max(RawFH.NSVType,0),
                                        cbTypeToBeAnalysed.Items.Count-1) ;

        edRecRange.LoValue := 1 ;
        edRecRange.HiValue := RawFH.NumRecords ;
        edRecord.LoValue := 1 ;
        edRecord.HiValue := RawFH.NumRecords ;

        // Compute average record
        ComputeAverage ;

        scDisplay.NumBytesPerSample := 4 ;
        scDisplay.MaxADCValue := FH.MaxADCValue ;
        scDisplay.MinADCValue := FH.MinADCValue ;
        scDisplay.DisplayGrid := Settings.DisplayGrid ;

        scDisplay.MaxPoints := RawFH.NumSamples ;
        scDisplay.NumPoints := scDisplay.MaxPoints ;
        scDisplay.NumChannels := NumDisplayChannels ;
        scDisplay.xMin := 0 ;
        scDisplay.xMax := scDisplay.NumPoints - 1 ;

        { Set channel information }
        for ch := 0 to scDisplay.NumChannels-1 do begin
            scDisplay.ChanUnits[ch] := Channel[cbChannel.ItemIndex].ADCUnits ;
            scDisplay.ChanScale[ch] := Channel[cbChannel.ItemIndex].ADCScale ;
            scDisplay.ChanUnits[ch] := Channel[cbChannel.ItemIndex].ADCUnits ;
            if ch = ChData then begin
               scDisplay.ChanName[ch] := Channel[cbChannel.ItemIndex].ADCName ;
               scDisplay.ChanZero[ch] := Channel[cbChannel.ItemIndex].ADCZero ;
               end
            else begin
               scDisplay.ChanName[ch] := 'Res.' ;
               scDisplay.ChanZero[ch] := 0 ;
               end ;

            scDisplay.ChanOffsets[ch] := ch ;

            // If the number of channels has changed, zoom out display
            if OldNumChannels <> RawFH.NumChannels then begin
               Channel[cbChannel.ItemIndex].yMin := scDisplay.MinADCValue ;
               Channel[cbChannel.ItemIndex].yMax := scDisplay.MaxADCValue ;
               end ;

            scDisplay.yMin[ch] := Channel[cbChannel.ItemIndex].yMin ;
            scDisplay.yMax[ch] := Channel[cbChannel.ItemIndex].yMax ;
            scDisplay.ChanVisible[ch] := True ;
            scDisplay.ChanColor[ch] := clBlue ;
            end ;
        OldNumChannels := RawFH.NumChannels ;

        Range := Channel[cbChannel.ItemIndex].yMax - Channel[cbChannel.ItemIndex].yMin ;
        scDisplay.yMin[chRes] := -0.5*Range ;
        scDisplay.yMax[chRes] := 0.5*Range ;

        { Create cursors for signal and residual channel displays }
        scDisplay.ClearHorizontalCursors ;
        scDisplay.AddHorizontalCursor(ChData,Settings.Colors.Cursors,True,'z') ;
        scDisplay.AddHorizontalCursor(ChRes,Settings.Colors.Cursors,True,'z') ;

        // Ensure XYplot components have sufficient capacity
        plVarPlot.MaxPointsPerLine := Max( RawFH.NumSamples,RawFH.NumRecords ) ;
        plSpecPlot.MaxPointsPerLine := Max( RawFH.NumSamples,RawFH.NumRecords ) ;

        // Set variance-mean plot selection cursors
        RawFH.NSVAnalysisCursor0 := Min(Max(RawFH.NSVAnalysisCursor0,0),RawFH.NumSamples-2) ;
        RawFH.NSVAnalysisCursor1 := Min(Max(RawFH.NSVAnalysisCursor1,0),RawFH.NumSamples-2) ;
        if RawFH.NSVAnalysisCursor1 = RawFH.NSVAnalysisCursor0 then begin
           RawFH.NSVAnalysisCursor0 := 0 ;
           RawFH.NSVAnalysisCursor1 := RawFH.NumSamples-2 ;
           end ;

        scDisplay.ClearVerticalCursors ;
        DispCursors.C0 := scDisplay.AddVerticalCursor(AllChannels,clOlive,'a') ;
        scDisplay.VerticalCursors[DispCursors.C0] := RawFH.NSVAnalysisCursor0 ;
        DispCursors.C1 := scDisplay.AddVerticalCursor(AllChannels,clOlive,'a') ;
        scDisplay.VerticalCursors[DispCursors.C1] := RawFH.NSVAnalysisCursor1 ;
        scDisplay.LinkVerticalCursors(DispCursors.C0,DispCursors.C1);

        DispCursors.Read := scDisplay.AddVerticalCursor(AllChannels,clGreen,'?t?y') ;
        scDisplay.VerticalCursors[DispCursors.Read] := RawFH.NumSamples div 2 ;

        { Initialise variance plot display cursors }
        plVarPlot.ClearVerticalCursors ;
        VarCursors.C0 := plVarPlot.AddVerticalCursor( clOlive, 'f',0  ) ;
        VarCursors.C1 := plVarPlot.AddVerticalCursor( clOlive, 'f',0  ) ;
        plVarPlot.LinkVerticalCursors(VarCursors.C0,VarCursors.C1);

        VarCursors.Read := plVarPlot.AddVerticalCursor( clBlue, '?r',0 ) ;

        { Initialise power spectrum plot display cursors }
        plSpecPlot.ClearVerticalCursors ;
        SpecCursors.C0 := plSpecPlot.AddVerticalCursor( clOlive, 'f',0  ) ;
        SpecCursors.C1 := plSpecPlot.AddVerticalCursor( clOlive, 'f',0  ) ;
        plSpecPlot.LinkVerticalCursors(SpecCursors.C0,SpecCursors.C1);
        SpecCursors.Read := plSpecPlot.AddVerticalCursor( clBlue, '?r',0 ) ;

        { Set to zero to force a new computation of average }
        Variance.StartAtRec := 0 ;
        Variance.EndAtRec := 0 ;

        { No. of points for FFT used to compute spectrum }
        n := Round(edNumFFTPoints.LoLimit) ;
        while (n < RawFH.NumSamples) and (n < Round(edNumFFTPoints.HiLimit)) do n := n*2 ;
        edNumFFTPoints.Value := n ;

        // Update limits of record selection scroll bar
        sbRecord.Position := 1 ;
        RawFH.RecordNum := sbRecord.Position ;
        UpdateScrollBar( sbRecord, RawFH.RecordNum, 1, RawfH.NumRecords ) ;

        // Display record
        DisplayRecord ;

        OldNumChannels := RawFH.NumChannels ;

        end
     else Close ;

     end ;


procedure TPwrSpecFrm.CopyDataToClipboard ;
{ -----------------------------------------------------------
  Copy the data in currently displayed graph to the clipboard
  -----------------------------------------------------------}
begin
     if (Page.ActivePage = VarianceTab)  then begin
        { Variance/mean plot }
        plVarPlot.CopyDataToClipboard ;
        end
     else if (Page.ActivePage = SpectrumTab)
          and PowerSpectrum.Available then begin
          plSpecPlot.CopyDataToClipboard ;
          end
     else scDisplay.CopyDataToClipboard ;
     end ;



{ *******************************************************
  Data record display procedures
  *******************************************************}


procedure TPwrSpecFrm.DisplayRecord ;
{ -----------------------------------------
  Get A/D samples for record from data file
  -----------------------------------------}
var

   i,iFrom,iTo,RecordNum,yZero,iShift,iLine : Integer ;
   AvgScale : single ;
   RH : TRecHeader ;
begin

    if InBuf = Nil then Exit ;

    { Update record number box }
    RecordNum := sbRecord.Position ;
    edRecord.LoValue := RecordNum ;
    edRecord.HiValue := RawFH.NumRecords ;

    { Read record data from file }
    GetRecord32( RawFH, RH, RecordNum, InBuf^ ) ;

    scDisplay.TScale := RH.dt*Settings.TScale ;
    scDisplay.TUnits := Settings.TUnits ;

    { Show whether record has been rejected by operator }
    if RH.Status = 'ACCEPTED' then ckRejected.checked := False
                              else ckRejected.checked := True ;

     { Show type of record }
     if cbRecordType.items.indexOf(RH.RecType) >= 0 then
        cbRecordType.ItemIndex := cbRecordType.items.indexOf(RH.RecType);

    { Copy signal into display data channel }
    iFrom := Channel[cbChannel.ItemIndex].ChannelOffset ;
    iTo := ChData ;
    for i := 0 to RawFH.NumSamples-1 do begin
        ADC[iTo] := InBuf[iFrom] ;
        iFrom := iFrom + RawFH.NumChannels ;
        iTo := iTo + NumDisplayChannels ;
        end ;

    { Subtract scaled ensemble average from individual record }
    SubtractScaledAverage( InBuf^, AvgScale, iShift ) ;

    { Copy residual into display data channel }
    iFrom := Channel[cbChannel.ItemIndex].ChannelOffset ;
    iTo := ChRes ;
    for i := 0 to RawFH.NumSamples-1 do begin
        ADC[iTo] := InBuf[iFrom] ;
        iFrom := iFrom + RawFH.NumChannels ;
        iTo := iTo + NumDisplayChannels ;
        end ;

    { Superimpose average on signal record  }
    scDisplay.ClearLines ;
    iLine := scDisplay.CreateLine( ChData, clRed, psSolid, 1 ) ;
    yZero := Channel[cbChannel.ItemIndex].ADCZero ;
    for i := 0 to RawFH.NumSamples-1 do begin
        iFrom := Min(Max(i+iShift,0),RawFH.NumSamples-1) ;
        scDisplay.AddPointToLine( iLine, i, AvgScale*Avg[iFrom] + yZero ) ;
        end ;

    { Re-plot channels }
    scDisplay.HorizontalCursors[ChData] := Channel[cbChannel.ItemIndex].ADCZero ;
    scDisplay.HorizontalCursors[ChRes] := 0 ;

    { Make sure display scaling factor is same as for selected channel }
    scDisplay.ChanScale[ChData] := Channel[cbChannel.ItemIndex].ADCScale ;
    scDisplay.ChanZeroAt[ChData] := Channel[cbChannel.ItemIndex].ADCZeroAt ;
    scDisplay.ChanScale[ChRes] := Channel[cbChannel.ItemIndex].ADCScale ;
    scDisplay.ChanZeroAvg := RawFH.NumZeroAvg ;

    scDisplay.SetDataBuf( ADC ) ;

    end ;


procedure TPwrSpecFrm.ComputeAverage ;
{ ---------------------------------------------
  Compute ensemble average of series of records
  --------------------------------------------- }
var
   i,iFrom,YZero : Integer ;
   Shift,AlignmentPoint,n,Rec : Integer ;
   RH : TRecHeader ;
begin

   { Determine range of records to be used in average }
   if rbAllRecords.Checked then begin
      Variance.StartAtRec := 1 ;
      Variance.EndAtRec := RawFH.NumRecords ;
      end
   else begin
      Variance.StartAtRec := Round(edRecRange.LoValue) ;
      Variance.EndAtRec := Round(edRecRange.HiValue) ;
      end ;

   Variance.Chan := cbChannel.ItemIndex ;

   { Initialise averaging array }
   for i := 0 to RawFH.NumSamples-1 do Sum[i] := 0. ;

   { Average records }
   Variance.NumRecordsAveraged := 0 ;
   for Rec := Variance.StartAtRec to Variance.EndAtRec do begin

       { Read record data from file }
       GetRecord32( RawfH, RH, Rec, InBuf^ ) ;

       { If record is of the right type and is ACCEPTED for use
         ... add it to average }
       if UseRecord( RH, cbTypeToBeAnalysed.text ) then begin

          { Relocate selected channel into single channel buffer }
          yZero := Channel[cbChannel.ItemIndex].ADCZero ;
          iFrom := Channel[cbChannel.ItemIndex].ChannelOffset ;
          for i := 0 to RawFH.NumSamples-1 do begin
              Avg[i] := InBuf[iFrom] - yZero ;
              iFrom := iFrom + RawFH.NumChannels ;
              end ;

          { Find mid-point of signal rising phase to use as alignment }
          AlignmentPoint := FindMidPointOfRise(Avg^,1,0,0) ;

          { Re-align signals ... if required }
          if cbAlignMode.ItemIndex = NoAlignment then begin
             Shift := 0 ;
             Variance.AvgAlignedAt := 0 ;
             end
          else begin
             if Variance.NumRecordsAveraged = 0 then
                Variance.AvgAlignedAt := AlignmentPoint ;
             Shift := AlignmentPoint - Variance.AvgAlignedAt ;
             end ;

          { Add signal to average record }
          for i := 0 to RawFH.NumSamples-1 do begin
                 iFrom := Max( Min( i + Shift,RawFH.NumSamples-1 ),0 ) ;
                 Sum[i] := Sum[i] + Avg[iFrom] ;
                 end ;

          Inc(Variance.NumRecordsAveraged) ;
          end ;
       end ;

   { Calculate average }
   n := Max(Variance.NumRecordsAveraged,1) ;
   for i := 0 to RawFH.NumSamples-1 do Avg[i] := Round(Sum[i]/n) ;

   { Find peak amplitude of average }
   Variance.AvgPeak := FindPeak(Avg^,1,0,0,Variance.AvgPeakAt ) ;

   end ;


function TPwrSpecFrm.FindPeak(
          var Buf : Array of Integer ; { A/D sample buffer }
          NumChannels : Integer ;       { No. of channels in Buf }
          ChanOffset : Integer ;        {Offset of channel to be analysed }
          yZero : Integer ;              { Zero baseline level }
          var PeakFoundAt : Integer     { Returns sample peak was found at }
          ) : single ;                  { Returns peak sample value }
{ --------------------------------------
  Find peak amplitude of a signal record
  -------------------------------------- }

var
   i,y,yPeak : Integer ;
begin

     yPeak := 0 ;
     for i := 0 to RawFH.NumSamples-1 do begin
         y := Buf[i*NumChannels + ChanOffset] - yZero ;
         if Abs(y) > yPeak then begin
            yPeak := Abs(y) ;
            PeakFoundAt := i ;
            end ;
         end ;
     Result := Buf[PeakFoundAt*NumChannels + ChanOffset] - yZero ; ;
     end ;


function TPwrSpecFrm.FindMidPointOfRise(
          var Buf : Array of Integer ; { A/D sample buffer }
          NumChannels : Integer ;       { No. of channels in Buf }
          ChanOffset : Integer ;        {Offset of channel to be analysed }
          yZero : Integer               { Zero baseline level }
          ) : Integer ;                  { Returns sample block # of mid point }
{ -------------------------------------------
  Find mid-point of rising phase of a signal
  ------------------------------------------- }

var
   i,y,yHalf,MidPointAt : Integer ;
   Peak,PeakAt,PeakPositive,PeakPositiveAt,PeakNegative,PeakNegativeAt : Integer ;
   Done : Boolean ;
begin

     { Find peaks within sample range }
     PeakPositive := Main.SESLabIO.ADCMinValue*2 ;
     PeakPositiveAt := 0 ;
     PeakNegative := Main.SESLabIO.ADCMaxValue*2 ;
     PeakNegativeAt := 0 ;
     for i := 0 to RawFH.NumSamples-1 do begin
         y := Buf[i*NumChannels + ChanOffset] - yZero ;
         { Positive peak }
         if y > PeakPositive then begin
            PeakPositive := y ;
            PeakPositiveAt := i ;
            end ;
         { Negative peak }
         if y < PeakNegative then begin
            PeakNegative := y ;
            PeakNegativeAt := i ;
            end ;
         end ;

     { Select type of peak by alignment mode }
     if cbAlignMode.ItemIndex = OnPositiveRise then begin
        { Positive peaks only }
        PeakAt := PeakPositiveAt ;
        Peak := Abs(PeakPositive) ;
        end
     else if cbAlignMode.ItemIndex = OnNegativeRise then begin
       { Positive peaks only }
        PeakAt := PeakNegativeAt ;
        Peak := Abs(PeakNegative) ;
        end
     else begin
        { Otherwise choose biggest peak }
        if PeakPositive > PeakNegative then begin
           PeakAt := PeakPositiveAt ;
           Peak := Abs(PeakPositive) ;
           end
        else begin
           PeakAt := PeakNegativeAt ;
           Peak := Abs(PeakNegative) ;
           end ;
        end ;

     { Find mid-point of rising phase }
     MidPointAt := PeakAt ;
     YHalf := Peak div 2 ;
     Done := False ;
     while not Done do begin
         y := Buf[MidPointAt*NumChannels + ChanOffset] - yZero ;
         if (Abs(y) > yHalf) and (MidPointAt > 0) then Dec(MidPointAt)
                                                  else Done := True ;
         end ;
     Result := MidPointAt ;

     end ;



procedure TPwrSpecFrm.FormClose(Sender: TObject; var Action: TCloseAction);
{ -------------------------
  Close and dispose of form
  -------------------------}
begin

     SaveHeader( RawFH ) ;

     Action := caFree ;
     end;


procedure TPwrSpecFrm.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin

     ADC := Nil ;
     InBuf := Nil ;
     Avg := Nil ;
     Sum := Nil ;
     VarBuf := Nil ;
     Mean := Nil ;
     VarFunc := TMathFunc.Create ;
     VarFunc.Setup( None, ' ', ' ' ) ;
     SpecFunc := TMathFunc.Create ;
     SpecFunc.Setup( None, ' ', ' ' ) ;
     Results := TStringList.Create ;
     end;

procedure TPwrSpecFrm.sbRecordChange(Sender: TObject);
{ -----------------------------------------------
  Data record slider bar changed - Update display
  -----------------------------------------------}
begin
     DisplayRecord ;
     end;


procedure TPwrSpecFrm.cbRecordTypeChange(Sender: TObject);
{{ -----------------------------
  Save new record type to file
  ----------------------------}
var
   RH : TRecHeader ;
begin
     GetRecordHeaderOnly( FH, RH, sbRecord.Position ) ;
     RH.RecType := cbRecordType.text ;
     PutRecordHeaderOnly( FH, RH, sbRecord.Position ) ;
     end;


procedure TPwrSpecFrm.ckRejectedClick(Sender: TObject);
{ ------------------------------------------------
  Save new record ACCEPTED/REJECTED status to file
  ------------------------------------------------}
var
   RH : TRecHeader ;
begin
     GetRecordHeaderOnly( FH, RH, sbRecord.Position ) ;
     if ckRejected.checked then RH.Status := 'REJECTED'
                            else RH.Status := 'ACCEPTED' ;
     PutRecordHeaderOnly( fH, RH, sbRecord.Position ) ;
     end;



procedure TPwrSpecFrm.edRecordKeyPress(Sender: TObject; var Key: Char);
{ -----------------------------------------
  Let user enter the record number directly
  -----------------------------------------}
begin
     if key = chr(13) then begin
        sbRecord.Position := Round(edRecord.LoValue) ;
        DisplayRecord ;
        end ;
     end;


procedure TPwrSpecFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{ --------------------------------
  Process special accelerator keys
  --------------------------------}
begin
     case key of
          VK_SUBTRACT : begin { - key }
                if sbRecord.Position >= 1 then begin
                   sbRecord.Position := sbRecord.Position - 1 ;
                   DisplayRecord ;
                   end ;
                end ;
          VK_ADD : begin { + key }
                if sbRecord.Position < RawFH.NumRecords then begin
                   sbRecord.Position := sbRecord.Position + 1 ;
                   DisplayRecord ;
                   end ;
                end ;
          $54,$4c,$45,$4d,$46 : begin
              { if (Shift = [ssCtrl]) then Action := NewRecordType ;}
               end ;
          $52 : begin
               if (Shift = [ssCtrl]) then begin
                   ckRejected.Checked := not ckRejected.Checked ;
                   end ;
               end ;
          else ;
          end ;
     end;


{ ***********************************************************************
  Variance/mean plot procedures
  ***********************************************************************}

procedure TPwrSpecFrm.bDoVarianceClick(Sender: TObject);
{ ------------------------------------------
  Calculate ensemble variances
  ------------------------------------------}
var
   Rec,i,j,NumRecords,iShift : Integer ;
   x,y,YScale,xMin,xMax, AvgScale : single ;
   RH : TRecHeader ;
begin

     { Determine range of records to be used in average }
     if rbAllRecords.Checked then begin
        Variance.StartAtRec := 1 ;
        Variance.EndAtRec := RawFH.NumRecords ;
        end
     else begin
        Variance.StartAtRec := Round(edRecRange.LoValue) ;
        Variance.EndAtRec := Round(edRecRange.HiValue) ;
        end ;

     { Clear variance buffer }
     for i := 0 to RawFH.NumSamples-1 do VarBuf[i] := 0.0 ;

     { Get range of samples to be plotted }
     Variance.StartSample := Min( scDisplay.VerticalCursors[DispCursors.C0],
                                  scDisplay.VerticalCursors[DispCursors.C1]) ;
     Variance.EndSample := Max( scDisplay.VerticalCursors[DispCursors.C0],
                                scDisplay.VerticalCursors[DispCursors.C1]) ;

     { Compute average signal from selected range of records }
     ComputeAverage ;

     { Calculate ensemble variance }
     NumRecords := 0 ;
     for Rec := Variance.StartAtRec to Variance.EndAtRec do begin

         { Read record data from file }
         GetRecord32( RawFH, RH, Rec, InBuf^ ) ;

         Main.StatusBar.SimpleText := format(
         'Non-stationary Variance: Plotting %d/%d',
         [Rec,Variance.EndAtRec] ) ;
         Application.ProcessMessages ;

         if UseRecord( RH, cbTypeToBeAnalysed.text ) then begin

           { Subtract scaled ensemble average from individual record }
           SubtractScaledAverage( InBuf^, AvgScale, iShift ) ;

           { Add this residual difference to variance buffer }
           //yZero := Channel[cbChannel.ItemIndex].ADCZero ;
           for i := Variance.StartSample to Variance.EndSample do begin
               j := i*RawFH.NumChannels + Channel[cbChannel.ItemIndex].ChannelOffset ;
               y := InBuf[j] ;
               VarBuf[i] := VarBuf[i] + y*y ;
               end ;
           Inc(NumRecords) ;
           end ;
         end ;

     Main.StatusBar.SimpleText := format(
     'Non-stationary Variance: Records %d-%d Plotted',
     [Variance.StartAtRec,Variance.EndAtRec] ) ;

     { Calculate average variance }
     NumRecords := Max(NumRecords,1) ;
     YScale := Channel[cbChannel.ItemIndex].ADCScale ;
     for i := Variance.StartSample to Variance.EndSample do begin
         VarBuf[i] := (VarBuf[i]/NumRecords)*YScale*YScale ;
         end ;

     { Calculate overall mean signal record }
     for i := Variance.StartSample to Variance.EndSample do begin
         Mean[i] := Avg[i]*YScale ;
         end ;

     { Plot graph of currently selected variables }
     plVarPlot.MaxPointsPerLine := RawFH.NumSamples ;
     plVarPlot.xAxisAutoRange := True ;
     plVarPlot.yAxisAutoRange := True ;

     plVarPlot.xAxisLabel := cbVarXAxis.text + ' '
                             + GetVariableUnits(cbVarXAxis.ItemIndex) ;
     plVarPlot.yAxisLabel := cbVarYAxis.text + ' '
                             + GetVariableUnits(cbVarYAxis.ItemIndex) ;
     { Clear data points line }
     plVarPlot.CreateLine( VarDataLine , clBlue, msOpenSquare, psSolid ) ;
     { Clear any fitted line }
     plVarPlot.CreateLine( VarFitLine , clRed, msNone, psSolid ) ;

     xMin := MaxSingle ;
     xMax := -MaxSingle ;
     for i := Variance.StartSample to Variance.EndSample do begin
         x := GetVariable( cbVarXAxis.ItemIndex, i ) ;
         y := GetVariable( cbVarYAxis.ItemIndex, i ) ;
         if x < xMin then xMin := x ;
         if x > xMax then xMax := x ;
         plVarPlot.AddPoint( VarDataLine, x, y ) ;
         end ;
     plVarPlot.SortByX( VarDataLine ) ;
     { Initial cursor positions }
     plVarPlot.VerticalCursors[VarCursors.C0] := xMin ;
     plVarPlot.VerticalCursors[VarCursors.C1] := xMax ;
     plVarPlot.VerticalCursors[VarCursors.Read] := (xMin + xMax)*0.5 ;

     { Display average and number of records in results table }
     erVarResults.Lines.Clear ;
     erVarResults.Lines.Add( format(' No. records = %d',[NumRecords]) );

     end;


procedure TPwrSpecFrm.SubtractScaledAverage(
          var Buf : Array of Integer ;  // A/D data to be subtracted (In/Out)
          var AvgScale : single ;        // Average scaling factor (OUT)
          var iShift : Integer ) ;       // No. of points average was shifted (OUT)
{ --------------------------------------------
  Subtract scaled average from A/D data in Buf
  -------------------------------------------- }
var
   i,j,yZero,iFrom : Integer ;
begin

     { Compute scaling factor if average is to be re-scaled to peak of signal }

     { Compute point shift required to align average with peak of record }
     if cbAlignMode.ItemIndex = NoAlignment then begin
        iShift := 0 ;
        end
     else begin
        iShift := Variance.AvgAlignedAt -
                  FindMidPointOfRise(Buf,RawFH.NumChannels,
                  Channel[cbChannel.ItemIndex].ChannelOffset,
                  Channel[cbChannel.ItemIndex].ADCZero) ;
        end ;

     if rbScaleToPeak.Checked and (Variance.AvgPeak <> 0.0) then
       { AvgScale := FindPeak(Buf,RawFH.NumChannels,
                             Channel[cbChannel.ItemIndex].ChannelOffset,
                             Channel[cbChannel.ItemIndex].ADCZero,
                             PeakAt)/Variance.AvgPeak}
         AvgScale := (Buf[(Variance.AvgPeakAt-iShift)*RawFH.NumChannels
                       + Channel[cbChannel.ItemIndex].ChannelOffset]
                       - Channel[cbChannel.ItemIndex].ADCZero)/Variance.AvgPeak
     else AvgScale := 1.0 ;


    { Subtract average to get residuals }
    yZero := Channel[cbChannel.ItemIndex].ADCZero ;
    for i := 0 to RawFH.NumSamples-1 do begin
        iFrom := Min(Max(i+iShift,0),RawFH.NumSamples-1) ;
        j := i*RawFH.NumChannels + Channel[cbChannel.ItemIndex].ChannelOffset ;
        Buf[j] := Round(Buf[j] - yZero - (AvgScale*Avg[iFrom])) ;
        end ;
    end ;


function TPwrSpecFrm.GetVariable(
         ItemIndex : Integer ;
         iSample : Integer
         ) : single ;
{ ---------------------------------------------------------------------------
  Get the variable selected by the combo box "ItemIndex" for the sample "iSample"
  ---------------------------------------------------------------------------}
begin
     case ItemIndex of
          vSample : Result := iSample ;
          vTime : Result := (iSample-Variance.StartSample)*RawFH.dt*Settings.TScale ;
          { Signal mean level }
          vAvg : Result := Mean[iSample] ;
          { Standard Deviation of signal }
          vStDev : Result := Sqrt(VarBuf[iSample]) ;
          { Variance of signal }
          vVariance : Result := VarBuf[iSample] ;
          else Result := 0.0 ;
          end ;
     end ;


function TPwrSpecFrm.GetVariableUnits( ItemIndex : Integer ) : string ;
{ --------------------------------------------------------------------
  Get the units for the variable selected by the combo box "ItemIndex"
  --------------------------------------------------------------------}
begin
     case ItemIndex of
          vSample : Result := '' ;
          vTime : Result := Settings.TUnits ;
          vAvg : Result := Channel[Variance.Chan].ADCUnits ;
          vStDev : Result := Channel[Variance.Chan].ADCUnits ;
          vVariance : Result := Channel[Variance.Chan].ADCUnits + '^2' ;
          else Result := '' ;
          end ;
     end ;


procedure TPwrSpecFrm.bVarSetAxesClick(Sender: TObject);
{ ------------------------------
  Set plot axes range/law/labels
  ------------------------------}
begin
     SetAxesFrm.Plot := plVarPlot ;
     SetAxesFrm.Histogram := False ;
     SetAxesFrm.ShowModal ;
     end;


procedure TPwrSpecFrm.bVarFitClick(Sender: TObject);
{ -------------------------------------------
  Fit a function to variance/mean VarPlot
  -------------------------------------------
    25/6/98 Clipboard buffer limit reduced to 31000
    13/1/99 }
const
     NumFitPoints = 500 ;
var
   i,nFit : Integer ;
   x,xLoLimit,xHiLimit,xOffset,dx : single ;
   FitData : TXYData ;
   t,Prob : single ;       { T value,Probability (for linear fit only) }
begin

     { Select type of equation to be fitted }
     VarFunc.Setup( TEqnType(cbVarEquation.Items.Objects[cbVarEquation.ItemIndex]),
                    GetVariableUnits(cbVarXAxis.ItemIndex),
                    GetVariableUnits(cbVarYAxis.ItemIndex) ) ;
     if VarFunc.Equation = None then Exit ;

        { Copy data into fitting array }
     { Lower and upper x data limit set by display cursors }
     xLoLimit := Min( plVarPlot.VerticalCursors[VarCursors.C0],
                      plVarPlot.VerticalCursors[VarCursors.C1]) ;
     xHiLimit := Max( plVarPlot.VerticalCursors[VarCursors.C0],
                      plVarPlot.VerticalCursors[VarCursors.C1]) ;
     { If an exponential function is being fitted, measure X relative
             to xLoLimit set by display cursor }
     if VarFunc.Equation = Exponential then xOffset := xLoLimit
                                       else xOffset := 0.0 ;
     nFit := 0 ;
     for i := Variance.StartSample to Variance.EndSample do begin
         x := GetVariable( cbVarXAxis.ItemIndex, i ) ;
         if (xLoLimit <= x) and (x <= xHiLimit) then begin
             FitData.x[nFit] := x - xOffset ;
             FitData.y[nFit] := GetVariable( cbVarYAxis.ItemIndex, i ) ;
             Inc(nFit) ;
             end ;
         end ;

     { Abandon fit if not enough data points }
     if nFit < VarFunc.NumParameters then begin
        ShowMessage( format('%d points is insufficient for fit',[nFit])) ;
        Exit ;
        end ;

     { Create an initial set of guesses for parameters }
     for i := 0 to VarFunc.NumParameters-1 do
         if not VarFunc.FixedParameters[i] then begin
            VarFunc.Parameters[i] := VarFunc.InitialGuess(FitData,nFit,i) ;
            end ;

     { Let user modify initial parameter settings and/or
             fix parameters at constant values }
     SetFitParsFrm.MathFunc := VarFunc ;
     SetFitParsFrm.XYData := @FitData ;
     SetFitParsFrm.NumPoints := nFit ;
     SetFitParsFrm.ShowModal ;
     if SetFitParsFrm.ModalResult <> mrOK then Exit ;

     VarFunc := SetFitParsFrm.MathFunc ;
     VarFunc.ParametersSet := True ;
     VarFunc.UseBinWidths := False ;
     VarFunc.FitCurve( FitData, nFit ) ;

        { Plot equation on graph }
     if VarFunc.GoodFit and (VarFunc.Equation <> None) then begin
        { Set starting point of fitted line }
        if VarFunc.Equation = Exponential then x := xOffset
                                          else x := plVarPlot.xAxisMin ;
        dx := (plVarPlot.xAxisMax - x) / NumFitPoints ;
        x := x + dx ;
        plVarPlot.ShowLines := True ;
        plVarPlot.LineStyles[VarDataLine] := psClear ;
        plVarPlot.CreateLine( VarFitLine, clRed, msNone, psSolid ) ;
        for i := 0 to NumFitPoints-2 do begin
            plVarPlot.AddPoint( VarFitLine, x, VarFunc.Value(x-xOffset) ) ;
            x := x + dx ;
            end ;
        end
     else begin
       plVarPlot.CreateLine( VarFitLine, clRed, msNone, psSolid ) ;
       plVarPlot.LineStyles[VarDataLine] := psSolid ;
       end ;

     { Display results if a good fit }
     Results.Clear ;
     erVarResults.Lines.Clear ;
     if VarFunc.GoodFit then begin

        Results.Add( VarFunc.Name ) ;

        { Best fit parameters and standard error }
        for i := 0 to VarFunc.NumParameters-1 do begin
            if not VarFunc.FixedParameters[i] then
               Results.Add( format(' %s = %.4g ^~ %.4g (sd) %s',
                            [VarFunc.ParNames[i],
                             VarFunc.Parameters[i],
                             VarFunc.ParameterSDs[i],
                             VarFunc.ParUnits[i]] ) )
            else
              { fixed parameter }
              Results.Add( format(' %s = %.4g (fixed) %s',
                                  [VarFunc.ParNames[i],
                                   VarFunc.Parameters[i],
                                   VarFunc.ParUnits[i]] ) ) ;
            end ;

        { Residual standard deviation }
        Results.Add( format(' Residual S.D. = %.4g %s',
                             [VarFunc.ResidualSD,
                              GetVariableUnits(cbVarYAxis.ItemIndex)] ) ) ;
        { Statistical degrees of freedom }
        Results.Add( format(' Degrees of freedom = %d ',
                              [VarFunc.DegreesOfFreedom]) ) ;
        { No. of iterations }
        Results.Add( format(' No. of iterations = %d ',
                              [VarFunc.Iterations]) ) ;

        { Special processing for straight line fits only
             (Only do it if there is at least one degree of freedom
              and the slope of the line has not been fixed ) }
        if (VarFunc.Equation = Linear)
           and (not VarFunc.FixedParameters[0])
           and (VarFunc.DegreesOfFreedom > 0) then begin
           { Calculate t-value for slope different from 0 }
           t := VarFunc.Parameters[1] / VarFunc.ParameterSDs[1] ;
           { Calculate probability of encountering this t value by chance }
           Prob := 2.*TProb( Abs(t), VarFunc.DegreesOfFreedom ) ;
           Results.Add(
           format('Slope T-Test : t(M<>0) = %.4g, p = %.4g',[t,Prob]) ) ;
           if Prob < 0.05 then begin
              { Report significance of t value }
              Results.Add( 'A significant linear trend exists (p<=0.05)' ) ;
              end ;
           end ;
        end ;

     // Copy fit results to rich edit field
     VarFunc.CopyResultsToRichEdit( Results, erVarResults ) ;

     end ;


{ ***********************************************************************
  Power spectrum routines
  ***********************************************************************}

procedure TPwrSpecFrm.bDoSpectrumClick(Sender: TObject);
{ -----------------------
  Calculate power spectra
  -----------------------}
Var
   i : Integer ;
   x,y : single ;
begin


    ComputePowerSpectrum( PowerSpectrum ) ;

    if rbLogFreqAveraging.checked then begin
       { Make axis logarithmic, if log. averaging in use }
       plSpecPlot.xAxisLaw := axLog ;
       plSpecPlot.yAxisLaw := axLog ;
       end
    else begin
       { Make axes linear for all other averaging modes }
       plSpecPlot.xAxisLaw := axLinear ;
       plSpecPlot.yAxisLaw := axLinear ;
       end ;

    { No equation }
    cbSpecEquation.ItemIndex := 0 ;

    { Plot graph of currently selected Variables }
    plSpecPlot.xAxisAutoRange := True ;
    plSpecPlot.yAxisAutoRange := True ;
    plSpecPlot.xAxisLabel := 'Hz' ;
    plSpecPlot.yAxisLabel := Channel[cbChannel.ItemIndex].ADCUnits + '^2' ;

    { Plot main spectrum }
    plSpecPlot.CreateLine( SpecDataLine, clBlue, msOpenSquare, psClear ) ;
    for i := 0 to PowerSpectrum.NumPoints-1 do begin
        x := PowerSpectrum.Frequency[i] ;
        y := PowerSpectrum.Power[i] ;
         plSpecPlot.AddPoint( SpecDataLine, x, y ) ;
         end ;

     { Clear any fitted line }
     plSpecPlot.CreateLine( SpecFitLine , clRed, msNone, psSolid ) ;

     { Initial cursor positions }
     plSpecPlot.VerticalCursors[SpecCursors.C0] := PowerSpectrum.Frequency[0] ;
     plSpecPlot.VerticalCursors[SpecCursors.C1] := PowerSpectrum.Frequency[
                                              PowerSpectrum.NumPoints-1] ;
     plSpecPlot.VerticalCursors[SpecCursors.Read] := PowerSpectrum.Frequency[
                                              PowerSpectrum.NumPoints div 2] ;

     end;


procedure TPwrSpecFrm.ComputePowerSpectrum(
          Var Spectrum : TSpectrum ) ;     { Spectrum record to hold result }
{ -------------------------------
  Compute averaged power spectrum
  -------------------------------}
Var
   Rec,i,j,n,npFFT,yZero,iFrom,cOffset,iShift : Integer ;
   Denom,YReal,YImag,dFreq,yScale,AvgScale : single ;
   FFT : ^TSingleArray ;
   VarianceCorrection : single ;
   StartAt,EndAt : Integer ;
   RH : TRecHeader ;
begin

     { Determine range of records to be used in average }
     if rbAllRecords.Checked then begin
        StartAt := 1 ;
        EndAt := RawFH.NumRecords ;
        end
     else begin
        StartAt := Round(edRecRange.LoValue) ;
        EndAt := Round(edRecRange.HiValue) ;
        end ;

     New(FFT) ;

     try

        Spectrum.StartAt := StartAt ;
        Spectrum.EndAt := EndAt ;
        Spectrum.Available := False ;
        Spectrum.NumAveraged := 0 ;
        Spectrum.AvgDCMean := 0.0 ;

        { Size of FFT (must be power of 2) }
        n := Round(edNumFFTPoints.LoLimit) ;
        while n < Round(edNumFFTPoints.Value) do n := n*2 ;
        edNumFFTPoints.Value := n ;
        npFFT := n div 2 ;
        dFreq := 0.5 / (npFFT*RawFH.dt) ;
        for i := 0 to npFFT do begin
            Spectrum.Power[i] := 0.0 ;
            Spectrum.Frequency[i] := (i+1)*dFreq ;
            end ;
        Spectrum.RecordSize := npFFT ;

        { Initialise progress bar }

        { Compute average signal from selected range of records }
        ComputeAverage ;

        for Rec := StartAt to EndAt do begin

            { Read record data from file }
            GetRecord32( RawFH, RH, Rec, InBuf^ ) ;

            if UseRecord( RH, cbTypeToBeAnalysed.text ) then begin

               { Subtract scaled ensemble average from individual record }
               SubtractScaledAverage( InBuf^, AvgScale, iShift ) ;

               for i := 1 to npFFT*2 do FFT^[i] := 0 ;

               { Add this residual difference to Variance buffer }
               yZero := Channel[cbChannel.ItemIndex].ADCZero ;
               YScale := Channel[cbChannel.ItemIndex].ADCScale ;
               cOffset := Channel[cbChannel.ItemIndex].ChannelOffset ;
               for i := 1 to RawFH.NumSamples do begin
                   iFrom := (i-1)*RawFH.NumChannels + cOffset ;
                   FFT^[i] := (InBuf[iFrom] - yZero - Avg[i-1]*AvgScale)*YScale ;
                   end ;
               Inc(Spectrum.NumAveraged) ;

               { Apply 10% cosine windows, if required }
               if rbCosineWindow.Checked then
                  CosineWindow( 1, npFFT*2, FFT^, VarianceCorrection )
               else VarianceCorrection := 1.0 ;

               {Transform to frequency domain }
               RealFFT( FFT^, npFFT, 1 ) ;

               { Compute power spectrum }
               j := 3 ;
               n := 0 ;
               for i := 2 to npFFT do begin
                   YReal := FFT^[j] ;
                   YImag := FFT^[j+1] ;
                   Spectrum.Power[n] := Spectrum.Power[n] + ((YReal*YReal) + (YImag*YImag)) ;
                   Inc(n) ;
                   j := j + 2 ;
                   end ;
               Spectrum.Power[n] := Spectrum.Power[n] + FFT^[2]*FFT^[2] ;
               Spectrum.NumPoints := n + 1 ;

               Main.StatusBar.SimpleText := format(
               'Non-stationary Variance: Computing spectrum %d/%d',
               [Rec,EndAt] ) ;

               { Allow other events to be processed }
               application.ProcessMessages ;

               Spectrum.Available := True ;
               Inc(Spectrum.NumAveraged) ;
               end ;
            end ;

        { Average spectral time periods }
        if Spectrum.NumAveraged > 0 then begin
           Denom := (Spectrum.NumAveraged*Spectrum.RecordSize*VarianceCorrection)
                    /(2.0*RawFH.DT) ;
           for i := 0 to Spectrum.NumPoints-1 do begin
               Spectrum.Power[i] := Spectrum.Power[i] / Denom ;
               end ;

           { Subtract frequency 3 points around 50Hz }
           if ckSubtract50Hz.checked then Subtract50HzPeak( Spectrum ) ;

           { Average adjacent frequencies within spectrum }
           AverageFrequencies( Spectrum ) ;

           { Compute total Variance of spectrum }
           SpectralVariance( Spectrum ) ;

           { Average DC channel signal level
             (used for unitary current calculation)}
           Spectrum.AvgDCMean := Spectrum.AvgDCMean / Spectrum.NumAveraged ;

           { Display spectrum results }
           erSpecResults.Lines.Clear ;

           erSpecResults.Lines.Add( format(' Total Variance = %.4g %s^2',
                                    [PowerSpectrum.Variance,
                                     Channel[cbChannel.ItemIndex].ADCUnits]) ) ;

           Main.StatusBar.SimpleText := format(
           'Non-stationary Variance: Power Spectrum computed from records %d-%d',
           [StartAt,EndAt] ) ;

           end ;

     finally
            Dispose(FFT) ;
            end ;

     end ;


{ -------------------------------------------
  Subtract any linear trend from data array Y
  ------------------------------------------}
procedure TPwrSpecFrm.SubtractLinearTrend(
          Var Y : Array of single ;   { Array containing data }
          iStart,iEnd : Integer ) ;   { Start/end of points within Y
                                        to have linear trend subtracted from them }
Var
   SumX,SumY,SumXX,SumXY,AvgX,AvgY,Slope,X,YIntercept : single ;
   i : Integer ;
begin

     {Calculate average of X and Y data points}
     SumX := 0.0 ;
     SumY := 0.0 ;
     for i := iStart to iEnd do begin
         SumX := SumX + i ;
         SumY := SumY + Y[i] ;
         end ;
     AvgX := SumX / (iEnd - iStart + 1) ;
     AvgY := SumY / (iEnd - iStart + 1) ;

     { Calculate best fit straight line }
     SumXY  := 0.0 ;
     SumXX := 0.0 ;
     for i := iStart to iEnd do begin
         X := i - AvgX ;
         SumXY := SumXY + (Y[i] - AvgY)*X ;
	 SumXX := SumXX + X*X ;
         end ;
     Slope := SumXY / SumXX ;
     YIntercept := AvgY - Slope*AvgX ;

      for i := iStart to iEnd do begin
          Y[i] := Y[i] - (Slope*i) - YIntercept ;
          end ;
      end ;


{ -------------------------------------------------
  Subtract points around any 50Hz peak in spectrum
  -------------------------------------------------}
procedure TPwrSpecFrm.Subtract50HzPeak(
          Var Spectrum : TSpectrum        { Spectrum to be processed }
          ) ;
Var
   iLo : Integer ;     { Index of nearest frequency below 50 Hz }
   iHi : Integer ;     { Index of nearest frequency above 50 Hz }
   iFrom : Integer ;   { Source index }
   iTo : Integer ;     { Destination index }
   iEnd : Integer ;    { Last index in TSpectrum arrays }
begin
     { Index of last point in spectrum }
     iEnd := Spectrum.NumPoints-1 ;

     { Find nearest frequency point below 50Hz }
     iLo := 0 ;
     while (Spectrum.Frequency[iLo] <= 50.0) and (iLo < iEnd) do inc(iLo) ;

     { Find nearest frequency point above 50Hz }
     iHi := iEnd ;
     while (Spectrum.Frequency[iHi] >= 50.0) and (iHi > 0) do dec(iHi) ;

     { Remove iLo and iHi points from spectrum }
     if (iHi > 0) and (iLo < iEnd) then begin
        iTo := 0 ;
        for iFrom := 0 to iEnd do
            if (iFrom = iLo) or (iFrom = iHi) then
            else begin
               Spectrum.Frequency[iTo] := Spectrum.Frequency[iFrom] ;
               Spectrum.Power[iTo] := Spectrum.Power[iFrom] ;
               Inc(iTo) ;
               end ;
        Spectrum.NumPoints := iTo ;
        end ;
     end ;


{ -------------------------------------------------
  Apply 10% cosine taper to ends of data in array Y
  -------------------------------------------------}
procedure TPwrSpecFrm.CosineWindow(
          iStart,iEnd : Integer ;   { Start/end of data points to window }
          Var Y : Array of single ; { Array containing data to be windowed }
          Var VarianceCorrection : single { Returns as VarBuf correction factor }
          ) ;
Var
   i,nPoints,i10,i90 : Integer ;
   Pi10,YScale : single ;
begin
    nPoints := iEnd - iStart + 1 ;
    i10 := nPoints div 10 ;
    i90 := npoints - i10 ;
    Pi10 := Pi / i10 ;
    //AmplitudeCorrection := 0.0 ;
    VarianceCorrection := 0.0 ;
    for i := iStart to iEnd do begin
        { Scaling factors }
        if i <= i10 then YScale := 0.5*(1.0 - cos((i - iStart)*Pi10))
        else if i >= i90 then YScale := 0.5*(1.0 - cos((iEnd - i)*Pi10))
        else YScale := 1.0 ;

        Y[i] := Y[i] * YScale ;

        //AmplitudeCorrection := AmplitudeCorrection + YScale ;
        VarianceCorrection := VarianceCorrection + YScale*Yscale
        end ;
    //AmplitudeCorrection := AmplitudeCorrection / nPoints ;
    VarianceCorrection := VarianceCorrection / nPoints ;

    end ;


{ ------------------------------------------------
  Average adjacent frequency bands within spectrum
  (Using linear or logarithmic rule)
  ------------------------------------------------}
procedure TPwrSpecFrm.AverageFrequencies(
          Var Spectrum : TSpectrum
          ) ;
Var
   iFrom,iTo,NumAveraged,NumFrequenciesRequired,BlockSize,BlockCount : Integer ;
   Pwr,Freq : single ;
begin

     if rbLinFreqAveraging.Checked then begin
        { ** Linear averaging **
          Average adjacent frequencies in blocks of fixed size,
          set by user (edNumFreqAveraged) }
        iFrom := 0 ;
        iTo := 0 ;
        NumAveraged := 0 ;
        NumFrequenciesRequired := Trunc( edNumFreqAveraged.Value ) ;
        Pwr := 0.0 ;
        Freq := 0.0 ;
        repeat
            { Summate power and frequency for average }
            Pwr := Pwr + Spectrum.Power[iFrom] ;
            Freq := Freq + Spectrum.Frequency[iFrom] ;
            Inc(iFrom) ;
            Inc(NumAveraged) ;
            { Calculate average when required }
            if NumAveraged = NumFrequenciesRequired then begin
               Spectrum.Power[iTo] := Pwr / NumAveraged ;
               Spectrum.Frequency[iTo] := Freq / NumAveraged ;
               Inc(iTo) ;
               NumAveraged := 0 ;
               Pwr := 0.0 ;
               Freq := 0.0 ;
               end ;
            until iFrom >= Spectrum.NumPoints ;
        Spectrum.NumPoints := iTo ;
        end
     else if rbLogFreqAveraging.Checked then begin
        { ** Logarithmic averaging **
          Double the size of the averaging block with increasing
          frequency, at intervals set by the user (edNumFreqAveraged) }
        iFrom := 0 ;
        iTo := 0 ;
        NumAveraged := 0 ;
        { Start with  no averaging }
        NumFrequenciesRequired := 1 ;
        { Set size of block using this average }
        BlockSize := Trunc( edNumFreqAveraged.Value ) ;
        BlockCount := 0 ;
        Pwr := 0.0 ;
        Freq := 0.0 ;
        repeat
              { Summate power and frequency for average }
              Pwr := Pwr + Spectrum.Power[iFrom] ;
              Freq := Freq + Spectrum.Frequency[iFrom] ;
              Inc(iFrom) ;
              Inc(NumAveraged) ;
              { Calculate average when required }
              if NumAveraged = NumFrequenciesRequired then begin
                 Spectrum.Power[iTo] := Pwr / NumAveraged ;
                 Spectrum.Frequency[iTo] := Freq / NumAveraged ;
                 Inc(iTo) ;
                 NumAveraged := 0 ;
                 Pwr := 0.0 ;
                 Freq := 0.0 ;
                 Inc(BlockCount) ;
                 { Double size of averaging block, when required }
                 if BlockCount = BlockSize then begin
                    NumFrequenciesRequired := NumFrequenciesRequired*2 ;
                    BlockCount := 0 ;
                    end ;
                 end ;
              until iFrom >= Spectrum.NumPoints ;
        Spectrum.NumPoints := iTo ;
        end ;

     end ;


{ ---------------------------------------------------------------
  Calculate total VarBuf of spectrum and median power frequency
  ---------------------------------------------------------------}
procedure TPwrSpecFrm.SpectralVariance(
          Var Spectrum : TSpectrum
          ) ;
Var
   Sum,BinWidth,dF,HalfPower,SumHi,SumLo : single ;
   i,iLo,iHi : Integer ;
begin
     { Calculate Variance as integral of power spectrum }
     Spectrum.Variance := 0.0 ;
     for i := 0 to Spectrum.NumPoints-1 do begin
         if i < (Spectrum.NumPoints-2) then
            BinWidth := Spectrum.Frequency[i+1] - Spectrum.Frequency[i] ;
         Spectrum.Variance := Spectrum.Variance + Spectrum.Power[i]*BinWidth ;
         end ;

     { Calculate median power frequency }
     i := 0 ;
     Sum := 0.0 ;
     HalfPower := Spectrum.Variance/2.0 ;
     repeat
         if i < Spectrum.NumPoints-2 then
            BinWidth := Spectrum.Frequency[i+1] - Spectrum.Frequency[i] ;
         Sum := Sum + Spectrum.Power[i]*BinWidth ;
         Inc(i) ;
         until (Sum >= HalfPower) or (i >= Spectrum.NumPoints) ;

     iLo := Max(Min(i-2,Spectrum.NumPoints-1),0) ;
     iHi := Min(i-1,Spectrum.NumPoints-1) ;
     SumLo := Sum - (BinWidth*Spectrum.Power[iHi]) ;
     SumHi := Sum ;

     if iLo <> iHi then begin
        dF := ((Spectrum.Frequency[iHi] - Spectrum.Frequency[iLo])
               * (HalfPower - SumLo)) / (SumHi - SumLo ) ;
        end
     else dF := 0.0 ;

     Spectrum.MedianFrequency := Spectrum.Frequency[iLo] + dF ;

     end ;


procedure TPwrSpecFrm.bSpecSetAxesClick(Sender: TObject);
{ ------------------------------
  Set plot axes range/law/labels
  ------------------------------}
begin
     SetAxesFrm.Plot := plSpecPlot ;
     SetAxesFrm.Histogram := True ;
     SetAxesFrm.ShowModal ;
     end;


procedure TPwrSpecFrm.bFitLorentzianClick(Sender: TObject);
{ -------------------------------------------
  Fit a Lorentzian function to power spectrum
  -------------------------------------------}
Var
   i,nFit : Integer ;
   FitData : TXYData ;
   Tau,FreqLo,FreqHi,x,y : single ;
begin

     { Select type of equation to be fitted }
     SpecFunc.Setup( TEqnType(cbSpecEquation.Items.Objects[cbSpecEquation.ItemIndex]),
                     'Hz',
                     Channel[cbChannel.ItemIndex].ADCUnits)  ;
     if SpecFunc.Equation = None then Exit ;

     { Get range of points to be fitted }
     FreqLo := Min( plSpecPlot.VerticalCursors[SpecCursors.C0],
                    plSpecPlot.VerticalCursors[SpecCursors.C1]) ;
     FreqHi := Max( plSpecPlot.VerticalCursors[SpecCursors.C0],
                    plSpecPlot.VerticalCursors[SpecCursors.C1]) ;
     nFit := 0 ;
     for i := 0 to PowerSpectrum.NumPoints-1 do
         if (FreqLo <= PowerSpectrum.Frequency[i]) and
            (PowerSpectrum.Frequency[i] <= FreqHi ) then begin
            FitData.x[i] := PowerSpectrum.Frequency[i] ;
            FitData.y[i] := PowerSpectrum.Power[i] ;
            Inc(nFit) ;
            end ;

     { Abandon fit if not enough data points }
     if nFit < SpecFunc.NumParameters then begin
        ShowMessage( format('%d points is insufficient for fit',[nFit])) ;
        Exit ;
        end ;

     { Create an initial set of guesses for parameters (if the parameter is not fixed }
     for i := 0 to SpecFunc.NumParameters-1 do
         if not SpecFunc.FixedParameters[i] then begin
            SpecFunc.Parameters[i] := SpecFunc.InitialGuess( FitData, nFit, i ) ;
            end ;

     { Let user modify initial parameter settings and/or fix parameters at constant values }
     SetFitParsFrm.MathFunc := SpecFunc ;
     SetFitParsFrm.XYData := @FitData ;
     SetFitParsFrm.NumPoints := nFit ;
     SetFitParsFrm.ShowModal ;
     if SetFitParsFrm.ModalResult <> mrOK then Exit ;

        { Fit curve using non-linear regression }
     { Prevent FitCurve from changing parameter settings }
     SpecFunc := SetFitParsFrm.MathFunc ;
     SpecFunc.ParametersSet := True ;
     SpecFunc.UseBinWidths := False ;
     SpecFunc.FitCurve( FitData, nFit ) ;

     { Plot equation on graph }
     if SpecFunc.GoodFit and (SpecFunc.Equation <> None) then begin
        plSpecPlot.LineStyles[SpecDataLine] := psClear ;
        plSpecPlot.ShowLines := True ;
        plSpecPlot.CreateLine( SpecFitLine, clRed, msNone, psSolid ) ;
        for i := 0 to PowerSpectrum.NumPoints-1 do begin
            x := PowerSpectrum.Frequency[i] ;
            y := SpecFunc.Value(PowerSpectrum.Frequency[i]) ;
            plSpecPlot.AddPoint( SpecFitLine, x, y ) ;
            end ;
        end
     else begin
        plSpecPlot.CreateLine( SpecFitLine, clRed, msNone, psSolid ) ;
        plSpecPlot.LineStyles[VarDataLine] := psSolid ;
        end ;

     { Display results }
     Results.Clear ;
     if SpecFunc.GoodFit then begin

         Results.Add( SpecFunc.Name ) ;

         // Best fit parameters and standard error }
         for i := 0 to SpecFunc.NumParameters-1 do begin
             if not SpecFunc.FixedParameters[i] then
                Results.Add( format(' %s = %.4g +/- %.4g (sd) %s',
                                         [SpecFunc.ParNames[i],
                                          SpecFunc.Parameters[i],
                                          SpecFunc.ParameterSDs[i],
                                          SpecFunc.ParUnits[i]] ) )
             else
                Results.Add( format(' %s = %.4g (fixed) %s',
                                           [SpecFunc.ParNames[i],
                                           SpecFunc.Parameters[i],
                                           SpecFunc.ParUnits[i]] ) ) ;
             end ;

         { Additional results for particular types of fitted curve }

         case SpecFunc.Equation of
              { Single Lorentzian }
              Lorentzian : begin
                    Tau := SecsToMs / (2.0*Pi*SpecFunc.Parameters[1]) ;
                    Results.Add( format(' Tau = %.4g ms',[Tau]) ) ;
                    end ;

              { Sum of 2 Lorentzians }
              Lorentzian2 : begin
                    Tau := SecsToMs / (2.0*Pi*SpecFunc.Parameters[1]) ;
                    erSpecResults.Lines.Add( format(' Tau1 = %.4g ms',[Tau]) ) ;
                    Tau := SecsToMs / (2.0*Pi*SpecFunc.Parameters[3]) ;
                    Results.Add( format(' Tau2 = %.4g ms',[Tau]) ) ;
                    end ;

              end ;

         { Residual standard deviation }
         Results.Add( format(' Residual S.D. = %.4g %s',
                                  [SpecFunc.ResidualSD,
                                   Channel[cbChannel.ItemIndex].ADCUnits] ) ) ;
         { Statistical degrees of freedom }
         Results.Add( format(' Degrees of freedom = %d ',
                                  [SpecFunc.DegreesOfFreedom]) ) ;
         { No. of iterations }
         Results.Add( format(' No. of iterations = %d ',
                                         [SpecFunc.Iterations]) ) ;
         end ;

     // Copy fit results to rich edit field
     SpecFunc.CopyResultsToRichEdit( Results, erSpecResults ) ;


     end ;


procedure TPwrSpecFrm.FormResize(Sender: TObject);
{ -------------------------------------------
  Resize components from form size is changed
  -------------------------------------------}
Var
   Bottom : Integer ;
begin
     page.Height := ClientHeight - page.Top - 5 ;
     page.Width := ClientWidth - page.Left - 5 ;

     scDisplay.Width := Max( page.Width - scDisplay.Left - 20,2) ;
     plVarPlot.Width := page.Width - plVarPlot.Left - 20 ;
     plSpecPlot.Width := page.Width - plSpecPlot.Left - 20 ;

     Bottom := page.ClientHeight - 40 ;
     AverageGrp.Height := Bottom - AverageGrp.Top ;

     ckFixedZeroLevels.Left := scDisplay.left ;
     ckFixedZeroLevels.Top := DataTab.ClientHeight - 5 - ckFixedZeroLevels.Height ;
     scDisplay.Height := Max( ckFixedZeroLevels.Top - scDisplay.Top -1,2) ;
     
     { Extend VarBuf page control group to bottom of page }
     VarGrp.Height := VarianceTab.ClientHeight - VarGrp.Top - 5 ;

     { Place VarBuf curve fit group at bottom of page }
     VarFitGrp.Top := VarGrp.Top + VarGrp.Height - VarFitGrp.Height ;
     plVarPlot.Height := Max( VarFitGrp.Top - plVarPlot.Top - 2,2) ;
     VarFitGrp.Width := plVarPlot.Width ;
     erVarResults.Width := VarFitGrp.Width - erVarResults.Left - 20 ;

     { Extend spectrum page control group to bottom of page }
     SpecGrp.Height := SpectrumTab.ClientHeight - SpecGrp.Top - 5 ;

     { Place spectrum curve fit group at bottom of page }
     SpecFitGrp.Top := SpecGrp.Top + SpecGrp.Height - SpecFitGrp.Height ;
     SpecFitGrp.Width := plSpecPlot.Width ;
     plSpecPlot.Height := Max( SpecFitGrp.Top - plSpecPlot.Top - 2,2 ) ;
     { Cursor labels }

     erSpecResults.Width := SpecFitGrp.Width - erSpecResults.Left - 20 ;
     end;



procedure TPwrSpecFrm.PrintDisplay ;
{ -----------------------------------------------
  Print currently displayed plot or signal record
  ----------------------------------------------- }
Var
   i : Integer ;
begin
    { Print VarBuf plot }
    if Page.ActivePage = VarianceTab then begin
       PrintGraphFrm.Plot := plVarPlot ;
       PrintGraphFrm.ToPrinter := True ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then begin
          { Add title information to plot }
          plVarPlot.ClearPrinterTitle ;
          plVarPlot.AddPrinterTitleLine( 'File ... ' + RawFH.FileName ) ;
          plVarPlot.AddPrinterTitleLine( RawFH.IdentLine ) ;
          for i := 0 to Results.Count-1 do
              plVarPlot.AddPrinterTitleLine( Results[i] ) ;
          { Plot graph to printer }
          plVarPlot.Print ;
          end ;
       end ;

    { Print Spectrum plot }
    if Page.ActivePage = SpectrumTab then begin
       PrintGraphFrm.Plot := plSpecPlot ;
       PrintGraphFrm.ToPrinter := True ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then begin
          { Add title information to plot }
          plSpecPlot.ClearPrinterTitle ;
          plSpecPlot.AddPrinterTitleLine( 'File ... ' + RawFH.FileName ) ;
          plSpecPlot.AddPrinterTitleLine( RawFH.IdentLine ) ;
          for i := 0 to erSpecResults.Lines.Count-1 do
              plSpecPlot.AddPrinterTitleLine( erSpecResults.Lines[i] ) ;
          { Plot graph to printer }
          plSpecPlot.Print ;
          end ;
       end ;

     { Print AC/DC signal record }
     if Page.ActivePage = DataTab then begin
        PrintRecFrm.Destination := dePrinter ;
        PrintRecFrm.DisplayObj := scDisplay ;
        PrintRecFrm.ShowModal ;
        if PrintRecFrm.ModalResult = mrOK then begin
           scDisplay.ClearPrinterTitle ;
           scDisplay.AddPrinterTitleLine( 'File : ' + RawFH.FileName ) ;
           scDisplay.AddPrinterTitleLine( RawFH.IdentLine ) ;
           scDisplay.Print ;
           end ;
        end ;

     end ;


procedure TPwrSpecFrm.CopyImageToClipboard ;
{ -----------------------------------------------------
  Copy active plot to clipboard as Windows metafile
  ----------------------------------------------------- }
begin
    { Copy VarBuf/mean plot }
    if Page.ActivePage = VarianceTab then begin
       PrintGraphFrm.Plot := plVarPlot ;
       PrintGraphFrm.ToPrinter := False ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then plVarPlot.CopyImageToClipboard ;
       end ;

    { Copy power spectrum }
    if Page.ActivePage = SpectrumTab then begin
       PrintGraphFrm.Plot := plSpecPlot ;
       PrintGraphFrm.ToPrinter := False ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then plSpecPlot.CopyImageToClipboard ;
       end ;

     { Copy signal record to clipboard }
     if Page.ActivePage = DataTab then begin
        PrintRecFrm.Destination := deClipboard ;
        PrintRecFrm.DisplayObj := scDisplay ;
        PrintRecFrm.ShowModal ;
        if PrintRecFrm.ModalResult = mrOK then scDisplay.CopyImageToClipboard ;
        end ;
     end ;


procedure TPwrSpecFrm.PageChange(Sender: TObject);
{ ----------------------------
  Updates when page is changed
  ----------------------------}
begin
     SetMenus ;
     end;


procedure TPwrSpecFrm.SetMenus ;
{ --------------------------------
  Update copy and print menu items
  -------------------------------- }
begin
     if Page.ActivePage = VarianceTab then begin
        { Determine range of records to be used in average }
        if rbAllRecords.Checked then begin
           Variance.StartAtRec := 1 ;
           Variance.EndAtRec := RawFH.NumRecords ;
           end
        else begin
           Variance.StartAtRec := Round(edRecRange.LoValue) ;
           Variance.EndAtRec := Round(edRecRange.HiValue) ;
           end ;
       lbPlotRecordRange.Caption := format('Records: %d-%d',
                                    [Variance.StartAtRec,
                                     Variance.EndAtRec] ) ;

       { Get range of samples to be plotted }
       Variance.StartSample := Min( scDisplay.VerticalCursors[DispCursors.C0],
                                    scDisplay.VerticalCursors[DispCursors.C1]) ;
       Variance.EndSample := Max( scDisplay.VerticalCursors[DispCursors.C0],
                                  scDisplay.VerticalCursors[DispCursors.C1]) ;
       lbPlotSampleRange.Caption := format('Samples: %d-%d',
                                    [Variance.StartSample,
                                     Variance.EndSample] ) ;

        { Main.ZoomMenus( False ) ;}
        end
     else if Page.ActivePage = SpectrumTab then begin
        end
     else begin
        end ;
     end ;


Function TPwrSpecFrm.DataAvailable ;
// --------------------------------------------------
// Return TRUE if data available for copying/printing
// --------------------------------------------------
begin

     if Page.ActivePage = VarianceTab then begin
        Result := plVarPlot.Available ;
        end
     else if Page.ActivePage = SpectrumTab then begin
        Result := plSpecPlot.Available ;
        end
     else begin
        Result := True ;
        end ;
     end ;


Function TPwrSpecFrm.ImageAvailable ;
// --------------------------------------------------
// Return TRUE if image available for copying/printing
// --------------------------------------------------
begin

     if Page.ActivePage = VarianceTab then begin
        Result := plVarPlot.Available ;
        end
     else if Page.ActivePage = SpectrumTab then begin
        Result := plSpecPlot.Available ;
        end
     else begin
        Result := True ;
        end ;
     end ;


procedure TPwrSpecFrm.FormActivate(Sender: TObject);
begin
     ckFixedZeroLevels.Checked := Settings.FixedZeroLevels ;
     SetMenus ;
     DisplayRecord ;
     end;


procedure  TPwrSpecFrm.ZoomIn( Chan : Integer ) ;
{ -----------------------------------------------------
  Let user set display magnification for channel 'Chan'
  ----------------------------------------------------- }
begin
      if Page.ActivePage = DataTab then scDisplay.ZoomIn(cbChannel.ItemIndex);
     end ;


procedure  TPwrSpecFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := RawFH.MaxADCValue ;
     scDisplay.MinADCValue := RawFH.MinADCValue ;
     scDisplay.ZoomOut ;
     end ;



procedure TPwrSpecFrm.FormDeactivate(Sender: TObject);
begin
     { Disable menus }
     SetMenus ;
    { Main.ZoomMenus( False ) ;}
     end;



procedure TPwrSpecFrm.FormDestroy(Sender: TObject);
// ----------------------------
// Tidy up when form destroyed
// ----------------------------
begin
     if ADC = Nil then FreeMem(ADC) ;
     if InBuf = Nil then FreeMem(InBuf) ;
     if Avg = Nil then FreeMem(Avg) ;
     if Sum = Nil then FreeMem(Sum) ;
     if VarBuf = Nil then FreeMem(VarBuf) ;
     if Mean = Nil then FreeMem(Mean) ;

    VarFunc.Free ;
    SpecFunc.Free ;
    Results.Free ;
    end;


procedure TPwrSpecFrm.scDisplayCursorChange(Sender: TObject);
Var
   Range : single ;
begin

     if not TScopeDisplay(Sender).CursorChangeInProgress then begin
        TScopeDisplay(Sender).CursorChangeInProgress := True ;

        { Update vertical display magnification so that changes are retained }
        Channel[cbChannel.ItemIndex].yMin := scDisplay.YMin[ChData] ;
        Channel[cbChannel.ItemIndex].yMax := scDisplay.YMax[ChData] ;

        Range := scDisplay.YMax[chData] - scDisplay.YMin[chData] ;
        scDisplay.yMin[chRes] := -0.5*Range ;
        scDisplay.yMax[chRes] := 0.5*Range ;

        { Get signal baseline cursor }
        if Settings.FixedZeroLevels or (Channel[ChData].ADCZeroAt >= 0) then begin
           if scDisplay.HorizontalCursors[ChData] <> Channel[ChData].ADCZero then begin
              scDisplay.HorizontalCursors[ChData] := Channel[ChData].ADCZero ;
              end ;
           end
        else Channel[ChData].ADCZero := scDisplay.HorizontalCursors[ChData] ;

        // Save analysis cursor settings
        RawFH.NSVAnalysisCursor0 := scDisplay.VerticalCursors[DispCursors.C0] ;
        RawFH.NSVAnalysisCursor1 := scDisplay.VerticalCursors[DispCursors.C1] ;
        SaveHeader( RawFH ) ;

        TScopeDisplay(Sender).CursorChangeInProgress := False ;
        end ;

     end;


procedure TPwrSpecFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
     scDisplay.MaxADCValue  := RawFH.MaxADCValue ;
     scDisplay.MinADCValue  := RawFH.MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;

     scDisplay.Invalidate ;
     end ;

procedure TPwrSpecFrm.cbAlignModeChange(Sender: TObject);
begin
     RawFH.NSVAlignmentMode := cbAlignMode.ItemIndex ;
     SaveHeader( RawFH ) ;
     ComputeAverage ;
     DisplayRecord ;
     end;

procedure TPwrSpecFrm.rbScaleToPeakClick(Sender: TObject);
//
// Select scale peak current option
// --------------------------------
begin
     RawFH.NSVScaleToPeak := True ;
     SaveHeader( RawFH ) ;
     DisplayRecord ;
     end;

     
procedure TPwrSpecFrm.rbNoScaleClick(Sender: TObject);
//
// Deselect scale peak current option
// ----------------------------------
begin
     RawFH.NSVScaleToPeak := False ;
     SaveHeader( RawFH ) ;
     DisplayRecord ;
     end;


procedure TPwrSpecFrm.cbChannelChange(Sender: TObject);
// ------------------------------------
// Select channel for variance analysis
// ------------------------------------
begin
     RawFH.NSVChannel := cbChannel.ItemIndex ;
     SaveHeader( RawFH ) ;
     ComputeAverage ;
     DisplayRecord ;
     end;


procedure TPwrSpecFrm.scDisplayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{ ---------------------------
  Display zero level mode box
  --------------------------- }
begin
     if (Button = mbRight) and (scDisplay.ActiveHorizontalCursor =0) then begin
        Channel[cbChannel.ItemIndex].ADCZero := scDisplay.HorizontalCursors[0] ;
        ZeroFrm.EnableFromRecord := True ;
        ZeroFrm.Chan := cbChannel.ItemIndex ;
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
        scDisplay.HorizontalCursors[ZeroFrm.Chan] := Channel[ZeroFrm.Chan].ADCZero ;
        { Force new calculation of average }
        Variance.StartAtRec := 0 ;
        Variance.EndAtRec := 0 ;
        if ZeroFrm.ModalResult = mrOK then DisplayRecord ;
        end

     else begin
        // Update zero baseline cursor
        if scDisplay.ActiveHorizontalCursor >= 0 then begin
           if Channel[cbChannel.ItemIndex].ADCZeroAt < 0 then begin
              // Fixed baseline level (update zero level to new position)
              Channel[cbChannel.ItemIndex].ADCZero :=
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor] ;
              end
           else begin
              // Baseline level computed from record (return to computed level)
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor] :=
              Channel[cbChannel.ItemIndex].ADCZero ;
              scDisplay.Invalidate ;
              end ;
           SaveHeader( RawFH ) ;
           end ;
        end ;
     end ;

function TPwrSpecFrm.UseRecord ( const RecH : TRecHeader ;
                                 RecType : string ) : Boolean ;
{ -----------------------------------------------------
  Select record for inclusion on graph, Varogram, etc.
  -----------------------------------------------------}
begin
     if (RecH.Status = 'ACCEPTED') and
        ( (RecH.RecType = RecType) or ( RecType = 'ALL') ) then
        UseRecord := True
     else UseRecord := False ;
     end ;

procedure TPwrSpecFrm.cbTypeToBeAnalysedChange(Sender: TObject);
begin
     Variance.StartAtRec := 0 ;
     Variance.EndAtRec := 0 ;
     RawFH.NSVType := cbTypeToBeAnalysed.ItemIndex ;
     SaveHeader( RawFH ) ;
     DisplayRecord ;
     end;

procedure TPwrSpecFrm.rbAllRecordsClick(Sender: TObject);
begin
   { Compute average signal from selected range of records }
    ComputeAverage ;
    DisplayRecord ;
    end;


procedure TPwrSpecFrm.edRecRangeKeyPress(Sender: TObject; var Key: Char);
begin
     if key = chr(13) then begin
        ComputeAverage ;
        DisplayRecord ;
        end ;
     end;

procedure TPwrSpecFrm.bCalcBaselineVarianceClick(Sender: TObject);
// ---------------------------
// Calculate baseline variance
// ---------------------------
var
    Avg,Variance,SumVariance,R,SumSQ,ChanScale : Single ;
    iRec,iStartRec,iEndRec,nRecords : Integer ;
    i,j,iBaseStart,iBaseEnd,NumAvg,ChanOffset : Integer ;
    RH : TRecHeader ;
begin

     { Determine range of records to be used in average }
     if rbAllRecords.Checked then begin
        iStartRec := 1 ;
        iEndRec := RawFH.NumRecords ;
        end
     else begin
        iStartRec := Round(edRecRange.LoValue) ;
        iEndRec := Round(edRecRange.HiValue) ;
        end ;

     iBaseStart := Min(Max(Channel[cbChannel.ItemIndex].ADCZeroAt,0),
                          RawFH.NumSamples-RawFH.NumZeroAvg) ;
     iBaseEnd := Min(Max(iBaseStart + RawFH.NumZeroAvg -1,0),
                        RawFH.NumSamples-1) ;
     ChanOffset := Channel[cbChannel.ItemIndex].ChannelOffset ;
     ChanScale := Channel[cbChannel.ItemIndex].ADCScale ;
     NumAvg := iBaseEnd - iBaseStart + 1 ;
     nRecords := 0 ;
     SumVariance := 0.0 ;
     for iRec := iStartRec to iEndRec do begin

        { Read record data from file }
        GetRecord32( RawFH, RH, iRec, InBuf^ ) ;

        { Show whether record has been rejected by operator }
        if RH.Status <> 'ACCEPTED' then break ;
        if cbRecordType.items.indexOf(RH.RecType) <= 0 then Break ;

        { Calculate baseline variance }
        Avg := 0.0 ;
        for i := iBaseStart to iBaseEnd do begin
            j := i*RawFH.NumChannels + ChanOffset ;
            Avg := Avg + InBuf[j] ;
            end ;
        Avg := Avg / NumAvg ;

        SumSq := 0.0 ;
        for i := iBaseStart to iBaseEnd do begin
            j := i*RawFH.NumChannels + ChanOffset ;
            R := (InBuf[j] - Avg)*ChanScale ;
            SumSq := SumSq + R*R ;
            end ;
        if NumAvg > 1 then Variance := SumSq / (NumAvg-1)
                      else Variance := 0.0 ;
        SumVariance := SumVariance + Variance ;
        nRecords := nRecords + 1 ;

        end ;

     if nRecords > 0 then begin
        edBaselineVariance.Text := format('%.4g %s^2',
                           [SumVariance/nRecords,
                            Channel[cbChannel.ItemIndex].ADCUnits]) ;
        end ;

     end;

procedure TPwrSpecFrm.ckFixedZeroLevelsClick(Sender: TObject);
begin
     Settings.FixedZeroLevels := ckFixedZeroLevels.Checked ;
     end;

end.
