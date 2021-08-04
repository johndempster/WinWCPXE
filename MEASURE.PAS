unit Measure;
{ ==========================================================================
  WinWCP - Waveform measurement module
  (c) John Dempster, University of Strathclyde, 1997.  All Rights Reserved.
  V1.6f 16/7/97 ... Blocks of data in table and Summary grid can now be
                    selected for copying to clipboard
  V1.7a 31/8/97 ... Availability status for records not selected for
                    measurement now left unchanged
  V1.7c 11/9/97 ... X-Y plots now hold 6000 points
                    Histograms now copied to clipboard as Bin Mid,Y pairs
  V1.7d 1/12/97 ... Ctrl-R changes Accepted/Rejected, Record types can be set by key
  V1.8 17/12/97 ... Rise time 10%-90% limits now defined as
                    10-90% of Peak-Baseline (instead of PeakPos-PeakNeg)
  24/2/98 ... +/- keys now step forward/back through records
  2/4/98 ... 2.0 Interval for calculating rate of rise can now be
                 set by user.
                 Rate of rise limits now set by data cursors
                 (used to be Cursor 0 to Peak)
  11/7/99 ... V3.0 32 bit version
  4/9/99 ... Display grid added
  3/11/99 ... NewFile now closes form if no records available
  12/3/00 ... Rate of rise now computed using forw. difference or quadratic
  7/1/01 ... Records designated as FAIL now always return zero peak measurements
  26/4/01 ... Exponential and gaussian curves fits added to Measurements plots
  17/5/01 ... Lines joining data points in X/Y graph now removed when curve fitted
  21/5/01 ... Ctrl+1,2,3 shortcuts for TYP1, TYP2, TYP3 added
  12/8/01 ... Baseline variable now derived from record-baseline average
              and now visible in results box
  29/8/01 ... Fixed zero level now saved when changed
              From Record zero area indicated by pair of small vertical bars
  3/12/01 ... NewFile now retains displayed record number position
  6/12/01 ... Peak amplitude can now be calculated from average of
              points before or after peak signal
  25/2/02 ... Record type matching criteria added to record selection filter
  26/2/02 ... Rise time limits can now be set by user
              Progress is reported in main status bar
  12/02/03 ... T.50% replaced with user-selectable % decay time
               Boltzmann function added to X-Y plot fitting
               X-Y function & histogram cursor readout tidied up
  24.6.03 ... No. of display grid lines can be changed
  04.02.04 .. Peak - last point exceeding x% level in Peak-90% decay range
              is designateded as decay duration. This biases the decay time to
              longer intervals in the presence of noise. (Problem noticed by
              Delia Beleli. V3.3.9 now gives same T.50% result as V2.3.7)
  01.01.04 .. Out of memory error blocked when windows resized to tiny size
  19.05.05 .. Only channels selected for display now shown.
              x% value of T.(x%) variable decay time measurement now retained in file
  20.05.05 .. Abort button now works
              Correct number of records analysed reported in status line
  23.05.06 .. No. of points per line now increased > 4096
  28.11.06 .. A/D samples now comverted to floating point before measurement
              to avoid 16 bit rollover when zero baseline close to top or bottom
  28.01.08 .. Analysis cursors now initially placed at 2% and 98% of record time course
  04.09.08 .. Get Cursors button added. Places cursors within displayed waveform area
              analysis limits cursors no longer reset when t.x% or peak mode changed
  12.11.08 .. V4.0.6 Rise time and decay time precision increased by interpolating
              between samples to find exact time of threshold transition.
              T.X% decay can now be 100%
              Histograms with zero bin width now prevented
  8.05.09 .. Summary and results tables can now be printed.
              Results table now includes variable units in title
  18.05.09 .. Minor change to rise time calculation. Interpolation
              at upper and lower limits now has separate zero divide protection
  05.05.10 .. Linear slope rate of rise option added
              Variable/channel combinations can be selectively added to table
              Table can be exported to text file
  13.05.10 .. Access violation during t.x% decay time search when reached end of analysis area reached fixed.
              Channel display visibility preserved when window closed
  17.05.10 .. Conductance can now be calculated using X/Y plot
  18.05.10 .. Filter records progress now reported in status bar
  21.8.10 .. Cursors Lock Channel settings now preserved in settings and winwcp.INI file.
              Changes to lock channels no longer resets cursors to default values
  17.09.10 .. 1000X scaling error when ms units selected fixed
  07.06.13 .. FH.NumZeroAvg now updated when changed in ZeroFrm
  25.07.13 .. Rise time now calculated correctly when Peak Points Avgd > 1.
              cbPeakMode, cbRateOfRiseMode, EdRiseTime and now all stored in FH file header
              Readout cursor added
  09.08.13 .. ADC now allocated by GetMem()
  25.06.14 .. Access violations prevented when first point in record is peak
  04.08.15 .. Records now be superimposed when superimpose traces selected
  29.09.15 .. Readout cursor no longer lost when Lock Cursors clicked.
  8.11.15 .. TMeasureFrmCursors.Base removed since use was redundant.
  12.01.17 .. .VerticalCursors() now single type and converted to integer by round()
  28.02.17 .. 0-100% quantile measurement added
  03.03.17 .. .Close form event now terminates bDoAnalysis.Click event before
              closing form to prevent access violation
  12.02.18 .. %Quantile now calculated using sample of max. 5000 points from analysis area
              and quicksort() algorithm to speed up sorting because original
              bubblesort algorithm is too slow when 10000 point records analysed
   30.07.19   Rise time limits now stored in WCP file header
   12.08.19 .. Absolute area measurement variable added
   15.08.19 .. % of peak detection point for latency can now be set by user
   16.08.19 .. Variable table columns now work properly again VarNames renamed to VarList for clarity
   13.04.21 .. Waveform measurements now performed in MeasureThread
               Results saved in CSV table with suffix <file name> .wfm.csv
               Absolute peak values now correctly entered in results table
  ==========================================================================}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Grids, ExtCtrls, TabNotBk, Global, Shared, FileIo,
  Zero, SetAxes, SetVar, Printers, ClipBrd, maths,
  ScopeDisplay, XYPlotDisplay, ComCtrls, ValEdit, RangeEdit, Spin,
  ValidatedEdit, math, seslabio, strutils, MMSYSTEM, MeasureThread  ;

type

TMeasureFrmCursors = Record
         T0 :   Integer ;
         R : Integer ;
         C0 :   array[0..WCPMaxChannels-1] of Integer ;
         C1 :   array[0..WCPMaxChannels-1] of Integer ;
         Base : array[0..WCPMaxChannels-1] of Integer ;
         PlotRead : Integer ;
         PlotFit0 : Integer ;
         PlotFit1 : Integer ;
         PlotT0 : Integer ;
         HistRead : Integer ;
         HistFit0 : Integer ;
         HistFit1 : Integer ;
         end ;

  TMeasureFrm = class(TForm)
    Page: TPageControl;
    AnalysisTab: TTabSheet;
    XYPlotTab: TTabSheet;
    HistogramTab: TTabSheet;
    SummaryTab: TTabSheet;
    TablesTab: TTabSheet;
    XYPlotGrp: TGroupBox;
    bNewXYPlot: TButton;
    XGroup: TGroupBox;
    Label15: TLabel;
    cbXVariable: TComboBox;
    cbXChannel: TComboBox;
    YGroup: TGroupBox;
    cbYVariable: TComboBox;
    bSetPlotAxes: TButton;
    plPlot: TXYPlotDisplay;
    HistGrp: TGroupBox;
    bNewHistogram: TButton;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    cbHistVariable: TComboBox;
    cbHistChannel: TComboBox;
    bSetHistAxes: TButton;
    plHist: TXYPlotDisplay;
    SummaryGrp: TGroupBox;
    Summary: TStringGrid;
    RecordGrp: TGroupBox;
    Label2: TLabel;
    cbRecordType: TComboBox;
    ckBadRecord: TCheckBox;
    sbRecordNum: TScrollBar;
    AnalysisGrp: TGroupBox;
    bDoAnalysis: TButton;
    bAbort: TButton;
    GroupBox8: TGroupBox;
    rbAllRecords: TRadioButton;
    rbThisRecord: TRadioButton;
    rbRange: TRadioButton;
    ResultsGrp: TGroupBox;
    sgResults: TStringGrid;
    Table: TStringGrid;
    edRecordNum: TRangeEdit;
    edRecRange: TRangeEdit;
    edNumBins: TValidatedEdit;
    RecordsGrp: TGroupBox;
    Label12: TLabel;
    edPlotRecType: TEdit;
    edPlotRange: TRangeEdit;
    VariablesGrp: TGroupBox;
    ckVariable0: TCheckBox;
    ckVariable1: TCheckBox;
    ckVariable2: TCheckBox;
    ckVariable3: TCheckBox;
    ckVariable4: TCheckBox;
    ckVariable5: TCheckBox;
    ckVariable6: TCheckBox;
    ckVariable7: TCheckBox;
    ckVariable8: TCheckBox;
    ckVariable9: TCheckBox;
    ckVariable10: TCheckBox;
    ckVariable11: TCheckBox;
    ckVariable12: TCheckBox;
    ckVariable13: TCheckBox;
    ckPercentage: TCheckBox;
    ckCumulative: TCheckBox;
    HistFitGrp: TGroupBox;
    bHistFit: TButton;
    cbHistEquation: TComboBox;
    erHistResults: TRichEdit;
    GroupBox1: TGroupBox;
    bFilter: TButton;
    GroupBox2: TGroupBox;
    bClearTable: TButton;
    XYFitGrp: TGroupBox;
    bXYFit: TButton;
    cbXYEquation: TComboBox;
    erXYResults: TRichEdit;
    gpPeak: TGroupBox;
    cbPeakMode: TComboBox;
    edPeakAvg: TValidatedEdit;
    Label4: TLabel;
    gpRateofRise: TGroupBox;
    cbRateofRiseMode: TComboBox;
    GroupBox6: TGroupBox;
    cbTypeToBeAnalysed: TComboBox;
    gpRiseTime: TGroupBox;
    edRiseTime: TRangeEdit;
    gpDecayTime: TGroupBox;
    edDecayTimePercentage: TValidatedEdit;
    Label1: TLabel;
    GroupBox10: TGroupBox;
    edHistMin: TValidatedEdit;
    Label18: TLabel;
    Label19: TLabel;
    edHistMax: TValidatedEdit;
    GroupBox11: TGroupBox;
    ckTabVar0: TCheckBox;
    ckTabVar1: TCheckBox;
    ckTabVar2: TCheckBox;
    ckTabVar3: TCheckBox;
    ckTabVar4: TCheckBox;
    ckTabVar5: TCheckBox;
    ckTabVar6: TCheckBox;
    ckTabVar7: TCheckBox;
    ckTabVar8: TCheckBox;
    ckTabVar9: TCheckBox;
    ckTabVar10: TCheckBox;
    ckTabVar11: TCheckBox;
    ckTabVar12: TCheckBox;
    ckTabVar13: TCheckBox;
    bAddVariable: TButton;
    cbTableChannel: TComboBox;
    bClearAllTableVariables: TButton;
    bSet: TButton;
    bSaveTableToFile: TButton;
    SaveDialog: TSaveDialog;
    cbSummaryChannel: TComboBox;
    gpCursors: TGroupBox;
    bGetCursors: TButton;
    ckLockChannelCursors: TCheckBox;
    PanConductance: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cbCondIVar: TComboBox;
    cbCondIChan: TComboBox;
    cbCondVVar: TComboBox;
    cbCondVChan: TComboBox;
    edVRev: TValidatedEdit;
    PanVar: TPanel;
    Label16: TLabel;
    cbYChannel: TComboBox;
    cbCondUnits: TComboBox;
    Label9: TLabel;
    ckVariable14: TCheckBox;
    ckTabVar14: TCheckBox;
    scDisplay: TScopeDisplay;
    ckFixedZeroLevels: TCheckBox;
    QuantileGrp: TGroupBox;
    Label13: TLabel;
    edQuantilePercentage: TValidatedEdit;
    ckVariable15: TCheckBox;
    ckTabVar15: TCheckBox;
    ckVariable16: TCheckBox;
    ckTabVar16: TCheckBox;
    gpLatency: TGroupBox;
    Label14: TLabel;
    edLatencyPercentage: TValidatedEdit;
    procedure bDoAnalysisClick(Sender: TObject);
    procedure bAbortClick(Sender: TObject);
    procedure bNewXYPlotClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure bSetPlotAxesClick(Sender: TObject);
    procedure bNewHistogramClick(Sender: TObject);
    procedure cbHistVariableChange(Sender: TObject);
    procedure bSetHistAxesClick(Sender: TObject);
    procedure cbSummaryChannelChange(Sender: TObject);
    procedure ckBadRecordClick(Sender: TObject);
    procedure cbRecordTypeChange(Sender: TObject);
    procedure edRecordNumKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure sbRecordNumChange(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure edPlotRangeKeyPress(Sender: TObject; var Key: Char);
    procedure ckVariable0Click(Sender: TObject);
    procedure scDisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure cbRateofRiseModeChange(Sender: TObject);
    procedure bHistFitClick(Sender: TObject);
    procedure bFilterClick(Sender: TObject);
    procedure bClearTableClick(Sender: TObject);
    procedure bXYFitClick(Sender: TObject);
    procedure cbPeakModeChange(Sender: TObject);
    procedure edDecayTimePercentageKeyPress(Sender: TObject; var Key: Char);
    procedure bGetCursorsClick(Sender: TObject);
    procedure bAddVariableClick(Sender: TObject);
    procedure bClearAllTableVariablesClick(Sender: TObject);
    procedure bSetClick(Sender: TObject);
    procedure bSaveTableToFileClick(Sender: TObject);
    procedure ckLockChannelCursorsClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbYVariableChange(Sender: TObject);
    procedure ckFixedZeroLevelsClick(Sender: TObject);
    procedure edPeakAvgKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private

   Cursors : TMeasureFrmCursors ;
   ADC : PSmallIntArray ;
   Hist : THistogram ;

   HistResults : TStringList ;
   XYResults : TStringList ;
   RH : TRecHeader ; { Record header }
   { Warning/request flags }
   NewSummaryNeeded : Boolean ;
   NewTableNeeded : Boolean ;
   HistogramLimitsNeeded : Boolean ;
   MathFunc : TMathFunc ;
   KeepCursors : Boolean ;

     //InSummary : array[0..MaxAnalysisVariables-1] of Boolean ;
     NumRecordsAnalysed : Integer ;

     TableVars : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of Integer ;
     TableChans : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of Integer ;
     NumTableColumns : Integer ;
     CloseFormASAP : Boolean ;

     DoAnalysisThread : TMeasureThread ;   // Time course computation thread

    { Private declarations }

    procedure CalculateSummary ;
    procedure FillSummaryTable ;
    procedure FillTable ;
    procedure SetDefaultHistogramLimits ;
    procedure SetCheckBoxCaption( CheckBox : TCheckBox ; VarNum : Integer ) ;
    function UseVariableInSummary( VarNum : Integer ) : Boolean ;
    procedure EMFit(
              var Mean : Array of single ;
              var SD : Array of single ;
              var A : Array of single ;
              var nData : Integer ;
              var NumIterations : Integer ) ;
    function GaussianPDF( x : single ; Mean : single ; SD : single ) : single ;


    procedure CreateVariable( iNum : Integer ;
                         VName : string ;
                         VUnits : Array of String ;
                         VScale :single ) ;

    procedure AddVariableToTable( CheckBox : TCheckBox ) ;

    function CalculateConductance(
         var G : single  // Conductance
         ) : Boolean ;   // Returns TRUE if valid conductance calculated

    function TidyNumber( const RawNumber : string ) : string ;

    procedure StopDoAnalysisThread ;

  public
    { Public declarations }
    VarList : TStringList ;
    VarName : array[0..MaxAnalysisVariables-1] of string ;               // Measurement variable names
    Units : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of string ;  // Measurement variable unitss
     UnitsScale : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
     MaxValue : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
     MinValue : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
     Mean : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
     StDev : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
     StErr : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;

    procedure NewFile ;
    procedure DisplayRecord ;
    procedure CopyDataToClipboard ;
    procedure CopyImageToClipboard ;
    procedure Print ;
    procedure ChangeDisplayGrid ;
    procedure ZoomOut ;
    Function DataAvailable : Boolean ;
    Function ImageAvailable : Boolean ;
    procedure SetStoreMode( StorageMode : Boolean ) ;
    function UseRecord ( const RecH : TRecHeader ; RecType : string ) : Boolean ;
  end;


var
  MeasureFrm: TMeasureFrm;

implementation

uses MDIForm,PrintGra, Printrec, Filter, Setfitpa, PrintTableUnit ;

{$R *.DFM}
const
     ForwardDifference = 0 ;
     Quadratic5point = 1 ;
     Quadratic7point = 2 ;
     SlopeDifference = 3 ;
     XYDataLine = 0 ;
     FittedLine = 1 ;
     MaxGaussians = 2 ;
     NumFitPoints = 500 ;

type

TTableVars = record
           Num : Integer ;
           Chan : Integer ;
           InUse : Boolean ;
           end ;



procedure TMeasureFrm.FormShow(Sender: TObject);
{ --------------------------------------
  Initialisations when form is displayed
  --------------------------------------}
begin

     // Set position of form
     Left := 25 ;
     Top := 25 ;
     Height := Main.StatusBar.Top - Top -10 ;
     Width := Main.ClientWidth - Left - 20 ;

     cbRecordType.items := RecordTypes ;
     cbRecordType.items.delete(0) ; {Remove 'ALL' item}

     cbTypeToBeAnalysed.items := RecordTypes ;
     if cbTypeToBeAnalysed.itemIndex < 0 then cbTypeToBeAnalysed.itemIndex := 0 ;

     // Rate of rise mode
     cbRateofRiseMode.Clear ;
     cbRateofRiseMode.Items.Add('Forward Diff.') ;
     cbRateofRiseMode.Items.Add('Quadratic (5)') ;
     cbRateofRiseMode.Items.Add('Quadratic (7)') ;
     cbRateofRiseMode.Items.Add('Linear Slope') ;
     cbRateofRiseMode.ItemIndex := 0 ;

     // X-Y plot fitting equation options
     cbXYEquation.Clear ;
     cbXYEquation.Items.AddObject( 'None', TObject(None)) ;
     cbXYEquation.Items.AddObject( 'Linear', TObject(Linear)) ;
     cbXYEquation.Items.AddObject( 'Exponential', TObject(Exponential)) ;
     cbXYEquation.Items.AddObject( '2 Exponentials', TObject(Exponential2)) ;
     cbXYEquation.Items.AddObject( 'Boltzmann', TObject(Boltzmann)) ;

     // Histogram fitting equation options
     cbHistEquation.Clear ;
     cbHistEquation.Items.AddObject( 'None', TObject(None)) ;
     cbHistEquation.Items.AddObject( 'Gaussian', TObject(Gaussian)) ;
     cbHistEquation.Items.AddObject( '2 Gaussians', TObject(Gaussian2)) ;
     cbHistEquation.Items.AddObject( '3 Gaussians', TObject(Gaussian3)) ;

     ckLockChannelCursors.Checked := Settings.LockChannelCursors ;

     SetStoreMode(Main.mnStoreTraces.Checked) ;

     RecordsGrp.Visible := False ;
     KeepCursors := False ;
     CloseFormASAP := False ;

     NewFile ;

     // Always start on analysis page
     Page.ActivePage := AnalysisTab ;

     end;


procedure TMeasureFrm.NewFile ;
{ -----------------------------------------------------
  Reset variables and channel when a new file is loaded
  -----------------------------------------------------}
var
   ch,v : Integer ;
   VarUnits : Array[0..WCPMaxChannels-1] of String ;
begin

     if FH.NumRecords <= 0 then begin
        Close ;
        Exit ;
        end ;

     // T.(x%) decay time percentage of peak value
     edDecayTimePercentage.Value := FH.DecayTimePercentage ;
     edPeakAvg.Value := FH.NumPointsAveragedAtPeak ;
     cbPeakMode.ItemIndex := FH.PeakMode ;
     cbRateOfRiseMode.ItemIndex := Min(Max(FH.RateOfRiseMode,0),cbRateOfRiseMode.Items.Count-1);

     if FH.RiseTimeLo = FH.RiseTimeHi then
        begin
        FH.RiseTimeLo := 0.1 ;
        FH.RiseTimeHi := 0.9 ;
        end;

     edRiseTime.LoValue := FH.RiseTimeLo ;
     edRiseTime.HiValue := FH.RiseTimeHi ;

     Caption := Main.UpdateCaption( FH, 'Waveform Measurements ' ) ;

     // Clear variable names string list
     VarList.Clear ;

     { Create waveform analysis record }
     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := ' ' ;
     CreateVariable(  vRecord, 'Record',VarUnits, 1. ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := ' ' ;
     CreateVariable( vGroup, 'Group', VarUnits, 1. ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := 's' ;
     CreateVariable( vTime, 'Time', VarUnits, 1. ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Channel[ch].ADCUnits ;
     CreateVariable(vAverage,'Average',VarUnits,1. ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Channel[ch].ADCUnits + '.'
                                                    + Settings.TUnits ;
     CreateVariable(vArea,'Area',VarUnits,Settings.TScale ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Channel[ch].ADCUnits + '.'
                                                    + Settings.TUnits ;
     CreateVariable(vAbsArea,'Abs(Area)',VarUnits,Settings.TScale ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Channel[ch].ADCUnits ;

     { Type of peak analysis required }

     if cbPeakMode.ItemIndex = NegativePeaks then CreateVariable( vPeak,'Peak(-)',VarUnits,1. )
     else if cbPeakMode.ItemIndex = PositivePeaks then CreateVariable( vPeak,'Peak(+)',VarUnits,1. )
     else CreateVariable( vPeak,'Peak(a)',VarUnits,1. ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Channel[ch].ADCUnits + '^2' ;
     CreateVariable(vVariance,'Variance',VarUnits, 1. ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Settings.TUnits ;
     CreateVariable(vRiseTime,'Rise Time',VarUnits, Settings.TScale ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Channel[ch].ADCUnits +
                                                     '/' + Settings.TUnits ;
     CreateVariable( vRateofRise,'Rate of Rise',VarUnits,
                                                       1./Settings.TScale ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Settings.TUnits ;
     CreateVariable(vLatency,'Latency',VarUnits, Settings.TScale ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Settings.TUnits ;
     CreateVariable( vtDecay,
                     format('T.%d%%',[Round(edDecayTimePercentage.Value)]),
                     VarUnits, Settings.TScale ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Settings.TUnits ;
     CreateVariable(vT90,'T.90%',VarUnits, Settings.TScale ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := 's' ;
     CreateVariable(vInterval,'Interval',VarUnits, 1. ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Channel[ch].ADCUnits ;
     CreateVariable(vBaseline,'Baseline',VarUnits, 1. ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := 'mS' ;
     CreateVariable(vConductance,'Conductance',VarUnits, 1. ) ;

     for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := Channel[ch].ADCUnits ;
     CreateVariable( vQuantile,
                     format('%.1f%% Quantile',[edQuantilePercentage.Value]),
                     VarUnits, 1.0 ) ;

        { Set up captions of variables to be summarised }
        SetCheckBoxCaption( ckVariable0, 0 ) ;
        SetCheckBoxCaption( ckVariable1, 1 ) ;
        SetCheckBoxCaption( ckVariable2, 2 ) ;
        SetCheckBoxCaption( ckVariable3, 3 ) ;
        SetCheckBoxCaption( ckVariable4, 4 ) ;
        SetCheckBoxCaption( ckVariable5, 5 ) ;
        SetCheckBoxCaption( ckVariable6, 6 ) ;
        SetCheckBoxCaption( ckVariable7, 7 ) ;
        SetCheckBoxCaption( ckVariable8, 8 ) ;
        SetCheckBoxCaption( ckVariable9, 9 ) ;
        SetCheckBoxCaption( ckVariable10, 10 ) ;
        SetCheckBoxCaption( ckVariable11, 11 ) ;
        SetCheckBoxCaption( ckVariable12, 12 ) ;
        SetCheckBoxCaption( ckVariable13, 13 ) ;
        SetCheckBoxCaption( ckVariable14, 14 ) ;
        SetCheckBoxCaption( ckVariable15, 15 ) ;
        SetCheckBoxCaption( ckVariable16, 16 ) ;

        { Set up captions of TabVars to be summarised }
        SetCheckBoxCaption( ckTabVar0, 0 ) ;
        SetCheckBoxCaption( ckTabVar1, 1 ) ;
        SetCheckBoxCaption( ckTabVar2, 2 ) ;
        SetCheckBoxCaption( ckTabVar3, 3 ) ;
        SetCheckBoxCaption( ckTabVar4, 4 ) ;
        SetCheckBoxCaption( ckTabVar5, 5 ) ;
        SetCheckBoxCaption( ckTabVar6, 6 ) ;
        SetCheckBoxCaption( ckTabVar7, 7 ) ;
        SetCheckBoxCaption( ckTabVar8, 8 ) ;
        SetCheckBoxCaption( ckTabVar9, 9 ) ;
        SetCheckBoxCaption( ckTabVar10, 10 ) ;
        SetCheckBoxCaption( ckTabVar11, 11 ) ;
        SetCheckBoxCaption( ckTabVar12, 12 ) ;
        SetCheckBoxCaption( ckTabVar13, 13 ) ;
        SetCheckBoxCaption( ckTabVar14, 14 ) ;
        SetCheckBoxCaption( ckTabVar15, 15 ) ;
        SetCheckBoxCaption( ckTabVar16, 16 ) ;

     { Create variable name list for X/Y plot }
     cbXVariable.items := VarList  ;
     if cbXVariable.ItemIndex < 0  then cbXVariable.ItemIndex := 0 ;
     cbYVariable.items := VarList  ;
     if cbYVariable.ItemIndex < 0  then cbYVariable.ItemIndex := 0 ;
     cbCondIVar.items := VarList  ;
     if cbCondIVar.ItemIndex < 0  then cbCondIVar.ItemIndex := vAverage ;
     cbCondVVar.items := VarList  ;
     if cbCondVVar.ItemIndex < 0  then cbCondVVar.ItemIndex := vAverage ;

     cbHistVariable.items := VarList  ;
     if cbHistVariable.ItemIndex < 0  then cbHistVariable.ItemIndex := 0 ;

     edRecRange.LoLimit := 1 ;
     edRecRange.LoValue := 1 ;
     edRecRange.HiLimit := Max(1,fH.NumRecords) ;
     edRecRange.HiValue := Max(1,fH.NumRecords) ;

     edPlotRange.LoLimit := 1 ;
     edPlotRange.LoValue := 1 ;
     edPlotRange.HiLimit := Max(1,fH.NumRecords) ;
     edPlotRange.HiValue := Max(1,fH.NumRecords) ;
     edPlotRecType.Text := 'ALL' ;

     { Set up display channels }
     scDisplay.MaxADCValue := RawFH.MaxADCValue ;
     scDisplay.MinADCValue := RawFH.MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;

     scDisplay.MaxPoints := FH.NumSamples ;
     scDisplay.NumPoints := scDisplay.MaxPoints ;
     scDisplay.NumChannels := FH.NumChannels ;

     scDisplay.xMax := Min(Round(Channel[0].xMax),FH.NumSamples-1)  ;
     scDisplay.xMin := Min(Round(Channel[0].xMin),scDisplay.xMax) ;
     if scDisplay.xMin = scDisplay.xMax then begin
           scDisplay.xMin := 0 ;
           scDisplay.xMax := FH.NumSamples-1 ;
           end ;

     { Set channel information }
     for ch := 0 to FH.NumChannels-1 do begin
            scDisplay.ChanUnits[ch] := Channel[ch].ADCUnits ;
            scDisplay.ChanName[ch] := Channel[ch].ADCName ;
            scDisplay.ChanScale[ch] := Channel[ch].ADCScale ;
            scDisplay.ChanUnits[ch] := Channel[ch].ADCUnits ;
            scDisplay.ChanZero[ch] := Channel[ch].ADCZero ;
            scDisplay.ChanOffsets[ch] := Channel[ch].ChannelOffset ;
            scDisplay.yMin[ch] := Channel[ch].yMin ;
            scDisplay.yMax[ch] := Channel[ch].yMax ;
            scDisplay.ChanVisible[ch] := Channel[ch].InUse ;
            scDisplay.ChanColor[ch] := clBlue ;
            end ;

     scDisplay.TScale := FH.dt*Settings.TScale ;
     scDisplay.TUnits := Settings.TUnits ;

     if ADC <> Nil then FreeMem( ADC ) ;
     GetMem( ADC, FH.NumChannels*FH.NumSamples*2 ) ;
     scDisplay.SetDataBuf( ADC );

        { Set initial position of alignment cursors }
     if not KeepCursors then begin
           scDisplay.ClearVerticalCursors ;
           for ch := 0 to FH.NumChannels-1 do begin
               if ckLockChannelCursors.Checked then begin
                  // Single set of cursors for all channels
                  if ch = 0 then begin
                     Cursors.C0[ch] := scDisplay.AddVerticalCursor(AllChannels,clOlive,'?t') ;
                     Cursors.C1[ch] := scDisplay.AddVerticalCursor(AllChannels,clOlive,'?t') ;
                     end
                  else begin
                     Cursors.C0[ch] := Cursors.C0[0] ;
                     Cursors.C1[ch] := Cursors.C1[0] ;
                     end ;
                  end
               else begin
                  // Independent cursors for each channel
                  Cursors.C0[ch] := scDisplay.AddVerticalCursor(ch,clOlive,'?t') ;
                  Cursors.C1[ch] := scDisplay.AddVerticalCursor(ch,clOlive,'?t') ;
                  end ;

               scDisplay.VerticalCursors[Cursors.C0[ch]] := FH.NumSamples div 50 ;
               scDisplay.VerticalCursors[Cursors.C1[ch]] := FH.NumSamples -
                                           scDisplay.VerticalCursors[Cursors.C0[ch]] ;
               scDisplay.LinkVerticalCursors( Cursors.C0[ch], Cursors.C1[ch] ) ;


               end ;

           Cursors.R := scDisplay.AddVerticalCursor(AllChannels,clGreen,'?y?t') ;
           scDisplay.VerticalCursors[Cursors.R] := FH.NumSamples div 2 ;
           Cursors.T0 := scDisplay.AddVerticalCursor(AllChannels,clGreen,'t=0') ;
           scDisplay.VerticalCursors[Cursors.T0] := 0 ;
           KeepCursors := False ;
           end ;

     scDisplay.ClearHorizontalCursors ;
     for ch := 0 to FH.NumChannels-1 do begin
               scDisplay.AddHorizontalCursor(ch,Settings.Colors.Cursors,True,'z' ) ;
               scDisplay.HorizontalCursors[ch] := Channel[ch].ADCZero ;
               end ;

     { Update channel selector boxes }
     cbXChannel.items := ChannelNames ;
     if cbXChannel.ItemIndex < 0 then cbXChannel.ItemIndex := 0 ;
     cbYChannel.items := ChannelNames ;
     if cbYChannel.ItemIndex < 0 then cbYChannel.ItemIndex := 0 ;
     cbYChannel.items := ChannelNames ;
     if cbYChannel.ItemIndex < 0 then cbYChannel.ItemIndex := 0 ;
     cbCondIChan.Items := ChannelNames ;
     if cbCondIChan.ItemIndex < 0 then cbCondIChan.ItemIndex := 0 ;
     cbCondVChan.Items := ChannelNames ;
     if cbCondVChan.ItemIndex < 0 then cbCondVChan.ItemIndex := Max(1,FH.NumChannels-1) ;

     cbHistChannel.items := ChannelNames ;
     if cbHistChannel.ItemIndex < 0 then cbHistChannel.ItemIndex := 0 ;
     { Set up Summary channel selector box }
     cbSummaryChannel.items := ChannelNames ;
     if cbSummaryChannel.ItemIndex < 0 then cbSummaryChannel.ItemIndex := 0 ;

     cbTableChannel.items := ChannelNames ;
     if cbTableChannel.ItemIndex < 0 then cbTableChannel.ItemIndex := 0 ;


     sgResults.RowCount := LastMeasureVariable + 2 ;
     sgResults.ColCount := FH.NumChannels + 1 ;

     { Variable name column }
     for v := 0 to cbXVariable.Items.Count-1 do begin
            sgResults.Cells[0,v+1] := cbXVariable.Items[v] ;
            sgResults.ColWidths[0] := Max(
                                      sgResults.Canvas.TextWidth(cbXVariable.Items[v] + '   '),
                                      sgResults.ColWidths[0] ) ;
            end ;

     { Channel name row }
     for Ch := 0 to FH.NumChannels-1 do begin
            sgResults.Cells[Ch+1,0] := Channel[Ch].ADCName ;
            end ;

     { Initialise peak mode combo box }
     if cbPeakMode.ItemIndex < 0 then cbPeakMode.ItemIndex := 0 ;

     { Initialise Table }
     Table.ColCount := 1 ;
     NumTableColumns := 0 ;

     NewSummaryNeeded := True ;
     NewTableNeeded := True ;
     HistogramLimitsNeeded := True ;

     SetStoreMode( Main.mnStoreTraces.Checked ) ;

     // Update record range (also triggers display of first record
     UpdateScrollBar( sbRecordNum, FH.RecordNum, 1, fH.NumRecords ) ;

     end ;


procedure TMeasureFrm.DisplayRecord ;
{ ========================================================
  Display digitised signal record on Page 0 of notebook
  ========================================================}
var
   ch,v,ColWidth,jVar : Integer ;
   s : string ;
begin
     sbRecordNum.Max := fH.NumRecords ;
     sbRecordNum.Min := 1 ;
     sbRecordNum.Enabled := True ;
     fH.RecordNum := SbRecordNum.position ;
     fH.CurrentRecord := SbRecordNum.position ;

     edRecordNum.LoValue := SbRecordNum.position ;
     edRecordNum.HiValue := fH.NumRecords ;
     scDisplay.RecordNumber := fH.CurrentRecord ;

     { Read record data from file }
     GetRecord( fH, rH, fH.RecordNum, ADC^ ) ;

     for ch := 0 to FH.NumChannels-1 do begin
         // Zero level
         scDisplay.HorizontalCursors[ch] := Channel[ch].ADCZero ;
         // Start of area from which zero level was computed (-1 indicates fixed zero level)
         scDisplay.ChanZeroAt[ch] := Channel[ch].ADCZeroAt ;
         // Signal scaling factor
         scDisplay.ChanScale[ch] := Channel[ch].ADCScale ;
         end ;
     // No. of samples in zero level area
     scDisplay.ChanZeroAvg := FH.NumZeroAvg ;

     scDisplay.TScale := RH.dt*Settings.TScale ;
     scDisplay.SetDataBuf( ADC ) ;

     { Show whether record has been rejected by operator }
     if rh.Status = 'ACCEPTED' then ckBadRecord.checked := False
                               else ckBadRecord.checked := True ;
     { Show type of record }
     if cbRecordType.items.indexOf(rh.RecType) >= 0 then
     cbRecordType.ItemIndex := cbRecordType.items.indexOf(rh.RecType);

     { Display waveform measurements for this record }
     if RH.AnalysisAvailable then begin
        for Ch := 0 to FH.NumChannels-1 do if Channel[Ch].InUse then begin
            ColWidth := 0 ;
            for v := 0 to cbXVariable.Items.Count-1 do begin
                jVar := ch*MaxAnalysisVariables + Integer(VarList.objects[v]) ;
                s := format(' %.4g %s    ',[RH.Value[jVar]*UnitsScale[jVar],Units[jVar]]) ;
                sgResults.Cells[Ch+1,v+1] := s ;
                if ColWidth < sgResults.Canvas.TextWidth(s) then
                   ColWidth := sgResults.Canvas.TextWidth(s)
                end ;
            sgResults.ColWidths[Ch+1] := ColWidth ;
            end ;
        end ;
     end ;


procedure TMeasureFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
var
    ch : Integer ;
begin
     scDisplay.MaxADCValue := RawFH.MaxADCValue ;
     scDisplay.MinADCValue := RawFH.MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;

     for ch := 0 to scDisplay.NumChannels-1 do begin
         scDisplay.ChanVisible[ch] := Channel[ch].InUse ;
         end ;

     DisplayRecord ;
     //scDisplay.Invalidate ;

     end ;


procedure  TMeasureFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := RawFH.MaxADCValue ;
     scDisplay.MinADCValue := RawFH.MinADCValue ;
     scDisplay.ZoomOut ;
     end ;


procedure TMeasureFrm.bDoAnalysisClick(Sender: TObject);
{ ===================================================
  Analyse parameters of waveforms stored in data file
  ===================================================}
var
    ch : Integer ;
    StartAtRec,EndAtRec : Integer ;
    iStart : Array[0..WCPMaxChannels-1] of Integer ;
    iEnd : Array[0..WCPMaxChannels-1] of Integer ;
    iTimeZero : Array[0..WCPMaxChannels-1] of Integer ;
begin
     bDoAnalysis.enabled := False ;
     bAbort.enabled := True ;

      // If computation thread is running, stop it
      StopDoAnalysisThread ;

     { Determine range of records to be analysed }
     if rbAllRecords.checked then
        begin
        { Analyse all records in file }
        StartAtRec := 1 ;
        EndAtRec := FH.NumRecords ;
        end
     else if rbThisRecord.checked then
        begin
        { Analyse the currently displayed record }
        StartAtRec := FH.RecordNum ;
        EndAtRec := FH.RecordNum ;
        end
     else
          begin
          { Analyse the user entered range of records }
          StartAtRec := Round(edRecRange.LoValue) ;
          EndAtRec := Round(edRecRange.HiValue) ;
          end ;

     { Update plot/Histogram record/type range boxes }
     edPlotRange.LoValue := StartAtRec ;
     edPlotRange.HiValue := EndAtRec ;
     edPlotRecType.Text := cbTypeToBeAnalysed.text ;

     // Copy user-selected analysis settings to file header
     FH.PeakMode := cbPeakMode.ItemIndex ;
     FH.NumPointsAveragedAtPeak := Round(edPeakAvg.Value) ;
     FH.RiseTimeLo := edRiseTime.LoValue ;
     FH.RiseTimeHi := edRiseTime.HiValue ;
     FH.RateOfRiseMode := cbRateofRiseMode.ItemIndex ;
     FH.LatencyPercentage := edLatencyPercentage.Value ;
     FH.DecayTimePercentage := edDecayTimePercentage.Value ;

     for ch := 0 to FH.NumChannels-1 do
         begin
        iStart[ch] := Min( Round(scDisplay.VerticalCursors[Cursors.C0[ch]]),
                                             Round(scDisplay.VerticalCursors[Cursors.C1[ch]]) ) ;
        iEnd[ch] :=   Max( Round(scDisplay.VerticalCursors[Cursors.C0[ch]]),
                                            Round(scDisplay.VerticalCursors[Cursors.C1[ch]]) ) ;
                { Zero time cursor }
        iTimeZero[ch] := Round(scDisplay.VerticalCursors[Cursors.t0]) ;
        end ;

     { Set flags to warn other functions that data has changed }
     NewSummaryNeeded := True ;
     HistogramLimitsNeeded := True ;

     // Start thread executing
     DoAnalysisThread := TMeasureThread.Create( StartAtRec,
                                                EndAtRec,
                                                cbTypeToBeAnalysed.text,
                                                FH.NumChannels,
                                                iStart,
                                                iEnd,
                                                iTimeZero ) ;

     end;




procedure TMeasureFrm.bAbortClick(Sender: TObject);
{ -----------------------
  Abort waveform analysis
  -----------------------}
begin
     bDoAnalysis.enabled := True ;
     if DoAnalysisThread <> Nil then DoAnalysisThread.Terminate ;
     end;


procedure TMeasureFrm.bNewXYPlotClick(Sender: TObject);
{ --------------------
  Create an X/Y Plot
  -------------------}
var
   Rec,StartAtRec,EndAtRec,xVar,yVar,xCh,yCh,ch : Integer ;
   x,y : Single ;
   OK : Boolean ;
   VarUnits : Array[0..WCPMaxChannels-1] of String ;
begin

     bNewXYPlot.Enabled := False ;
     Main.StatusBar.SimpleText := 'Waveform Analysis: Plotting graph.' ;

     { Plot graph of currently selected variables }
     plPlot.xAxisAutoRange := True ;
     plPlot.yAxisAutoRange := True ;

     plPlot.MaxPointsPerLine := Max( Round(edPlotRange.HiValue - edPlotRange.LoValue) + 1,
                                     NumFitPoints )  ;

     { Get channel and variables to be plotted }
     Xch := cbXChannel.itemIndex ;
     XVar := Integer(cbXVariable.Items.Objects[cbXVariable.ItemIndex]) ;
     Ych := cbYChannel.itemIndex ;
     YVar := Integer(cbYVariable.Items.Objects[cbYVariable.ItemIndex]) ;

     { Create X and Y axes labels }
     plPlot.xAxisLabel := '' ;
     if xVar > vTime then plPlot.xAxisLabel := Channel[xCh].ADCName + ' ';
     plPlot.xAxisLabel := plPlot.xAxisLabel + VarName[xVar]
                          + ' ' + Units[xCh*MaxAnalysisVariables+xVar] ;

     plPlot.yAxisLabel := '' ;
     if yVar = vConductance then begin
        // Update conductance variable units
        for ch := 0 to FH.NumChannels-1 do VarUnits[ch] := cbCondUnits.Text ;
        CreateVariable(vConductance,'Conductance',VarUnits, 1. ) ;
        SetCheckBoxCaption( ckVariable14, 14 ) ;
        SetCheckBoxCaption( ckTabVar14, 14 ) ;
        end ;

     if (yVar > vTime) then begin
        plPlot.yAxisLabel := Channel[yCh].ADCName + ' ' ;
        plPlot.yAxisLabel := plPlot.yAxisLabel + VarName[yVar]
                             + ' ' + Units[yCh*MaxAnalysisVariables+yVar] ;
        end ;

     { Clear data points line }
     plPlot.CreateLine( XYDataLine , clBlue, msOpenSquare, psSolid ) ;

     StartAtRec := Round(edPlotRange.LoValue) ;
     EndAtRec := Round(edPlotRange.HiValue ) ;
     for Rec := StartAtRec to EndAtRec do begin
         { Read record analysis block from file }
         GetRecordHeaderOnly( fH, rH, Rec ) ;
         { Add to plot if selected and valid }
         if UseRecord(rH,cbTypeToBeAnalysed.text) then begin
            x := rH.Value[XCh*MaxAnalysisVariables+XVar]*UnitsScale[XCh*MaxAnalysisVariables+XVar] ;
            if YVar = vConductance then begin
               // Calculate conductance
               OK := CalculateConductance(y) ;
               if OK then plPlot.AddPoint(0, x, y ) ;
               // Save conductance value to record variables
               PutRecordHeaderOnly( fH, rH, Rec ) ;
               end
            else begin
               // All other variables
               y := rH.Value[YCh*MaxAnalysisVariables+YVar]*UnitsScale[YCh*MaxAnalysisVariables+YVar] ;
               plPlot.AddPoint(0, x, y ) ;
               end ;
            end ;
         end ;
     plPlot.SortByX( 0 ) ;

     { Create cursors for X/Y plot }
     plPlot.ClearVerticalCursors ;
     Cursors.PlotRead := plPlot.AddVerticalCursor( clBlue, '?r',0 ) ;
     plPlot.GetPoint(0,plPlot.GetNumPointsInLine(0) div 2,x,y) ;
     plPlot.VerticalCursors[Cursors.PlotRead] := x ;

     // Create curve fitting limits cursors
     Cursors.PlotFit0 := plPlot.AddVerticalCursor( clOlive, 'f',0 ) ;
     plPlot.GetPoint(0,0,x,y) ;
     plPlot.VerticalCursors[Cursors.PlotFit0] := x ;
     // Time zero cursor
//     Cursors.PlotT0 := plPlot.AddVerticalCursor( clGreen, 'x=0' ) ;
//     plPlot.VerticalCursors[Cursors.PlotT0] := x ;
     // Fitting upper limit cursor
     Cursors.PlotFit1 := plPlot.AddVerticalCursor( clOlive, 'f',0 ) ;
     plPlot.GetPoint(0,plPlot.GetNumPointsInLine(0)-1,x,y) ;
     plPlot.VerticalCursors[Cursors.PlotFit1] := x ;
     plPlot.LinkVerticalCursors(Cursors.PlotFit0,Cursors.PlotFit1);

     // Clear any existing fitted line / results
     plPlot.CreateLine( FittedLine, clRed, msNone, psSolid ) ;
     erXYResults.Lines.Clear ;

     bNewXYPlot.Enabled := True ;
     Main.StatusBar.SimpleText := 'Waveform Analysis: Graph plotted.' ;

     end;

function TMeasureFrm.CalculateConductance(
         var G : single  // Conductance
         ) : Boolean ;   // Returns TRUE if valid conductance calculated
// -------------------------------------------------------------------------
// Calculate membrane conductance from selected current and voltage channels
// -------------------------------------------------------------------------
const
    VDriveMin = 1E-4 ; // Mimimum driving force used in calculation
var
    I,V,VDrive,IScale,VScale,GScale : Single ;
    IVar,ICh,VVar,Vch : Integer ;
    IUnits,VUnits : String ;
begin

     // Current variable
     IVar := cbCondIVar.ItemIndex ;
     Ich := cbCondIChan.ItemIndex ;
     IUnits := Units[ICh*MaxAnalysisVariables+IVar] ;
     if ANSIContainsText(IUnits,'ma') then IScale := 1E-3
     else if ANSIContainsText(IUnits,'ua') then IScale := 1E-6
     else if ANSIContainsText(IUnits,'na') then IScale := 1E-9
     else if ANSIContainsText(IUnits,'pa') then IScale := 1E-12
     else IScale := 1.0 ;

     // Voltage variable
     VVar := cbCondVVar.ItemIndex ;
     Vch := cbCondVChan.ItemIndex ;
     VUnits := Units[VCh*MaxAnalysisVariables+VVar] ;
     if ANSIContainsText(VUnits,'mv') then VScale := 1E-3
     else if ANSIContainsText(VUnits,'uv') then VScale := 1E-6
     else VScale := 1.0 ;

     I := rH.Value[ICh*MaxAnalysisVariables+IVar]*UnitsScale[ICh*MaxAnalysisVariables+IVar]*IScale ;
     V := rH.Value[VCh*MaxAnalysisVariables+VVar]*UnitsScale[VCh*MaxAnalysisVariables+VVar]*VScale ;

     VDrive := V - edVRev.Value ;
     if Abs(VDrive) >= VDriveMin then begin
        G := I / VDrive ;
        Result := True ;
        end
     else begin
        G := 0.0 ;
        Result := False ;
        end ;

     if ANSIContainsText(cbCondUnits.text,'ps') then GScale := 1E12
     else if ANSIContainsText(cbCondUnits.text,'ns') then GScale := 1E9
     else if ANSIContainsText(cbCondUnits.text,'us') then GScale := 1E6
     else if ANSIContainsText(cbCondUnits.text,'ms') then GScale := 1E3
     else GScale := 1.0 ;

     G := G*GScale ; // Return in select conductance units

     // Update record variable
     rH.Value[ICh*MaxAnalysisVariables+VConductance] := G ;

     end ;

procedure TMeasureFrm.bSetPlotAxesClick(Sender: TObject);
{ ------------------------------
  Set plot axes range/law/labels
  ------------------------------}
begin
     SetAxesFrm.Plot := plPlot ;
     SetAxesFrm.Histogram := False ;
     SetAxesFrm.ShowModal ;
     end;


procedure TMeasureFrm.bNewHistogramClick(Sender: TObject);
{ -------------------------------------
  Request a new Histogram to be plotted
  -------------------------------------}
var
   i,VarCh,VarVar,Rec,RecStart,RecEnd : Integer ;
   x,HScale,HLowerLimit : single ;
begin

     Screen.Cursor := crHourglass ;

     { Calculate summary data for all channels so that a suitable
     initial Histogram range can be supplied for the user }
     if NewSummaryNeeded then FillSummaryTable ;

     { Determine records, channels & variables to be plotted }
     VarCh := cbHistChannel.itemIndex ;
     VarVar := Integer(cbHistVariable.Items.Objects[cbHistVariable.ItemIndex]) ;

     { Clear Histogram }
     x := edHistMin.Value ;
     Hist.NumBins := Round( EdNumBins.Value ) ;
     Hist.BinWidth := (edHistMax.Value - x )/Hist.NumBins ;
     if Hist.BinWidth <= 0.0 then Hist.BinWidth := 1.0 ;
     for i := 0 to Hist.NumBins-1 do begin
         Hist.Bins[i].lo := x ;
         Hist.Bins[i].Mid := x + Hist.BinWidth / 2. ;
         Hist.Bins[i].Hi := x + Hist.BinWidth ;
         Hist.Bins[i].y := 0. ;
         x := x + Hist.BinWidth ;
         end ;

     { Fill Histogram }
     HScale := (Hist.NumBins) / ( Hist.Bins[Hist.NumBins-1].Mid
                                         - Hist.Bins[0].Mid ) ;
     HLowerLimit := Hist.Bins[0].Lo ;

     RecStart := Round( edPlotRange.LoValue ) ;
     RecEnd := Round( edPlotRange.HiValue ) ;
     Screen.Cursor := crHourglass ;
     for Rec := RecStart to RecEnd do begin
            { Read record analysis block from file }
            GetRecordHeaderOnly( fH, rH, Rec ) ;
            if UseRecord( rH, cbTypeToBeAnalysed.text ) then begin
               x := rH.Value[ VarCh*MaxAnalysisVariables+VarVar  ]
                    * UnitsScale[VarCh*MaxAnalysisVariables+VarVar] ;
               i := Round( (x - HLowerLimit) * HScale ) ;
               i := Max( Min(i,Hist.NumBins-1), 0) ;
               Hist.Bins[i].y := Hist.Bins[i].y + 1. ;
               if Hist.Bins[i].y > Hist.yHi then Hist.yHi := Hist.Bins[i].y ;
               end ;
            end ;


     { Plot new Histogram }
     plHist.xAxisAutoRange := False ;
     plHist.xAxisMin := Hist.Bins[0].Lo ;
     plHist.xAxisMax := Hist.Bins[Hist.NumBins-1].Hi ;
     plHist.XAxisTick := (plHist.xAxisMax - plHist.xAxisMin) / 5.0 ;

     plHist.HistogramCumulative := ckCumulative.Checked ;
     plHist.HistogramPercentage := ckPercentage.Checked ;

     plPlot.MaxPointsPerLine := Max( Hist.NumBins + 1,NumFitPoints )  ;

     { Create X and Y axes labels }
     plHist.xAxisLabel := '' ;
     if VarVar > vTime then plHist.xAxisLabel := Channel[VarCh].ADCName + ' ';
     plHist.xAxisLabel := plHist.xAxisLabel + VarList[VarVar]
                          + ' ' + Units[VarCh*MaxAnalysisVariables+VarVar] ;

     plHist.yAxisAutoRange := True ;
     if ckPercentage.Checked then plHist.yAxisLabel := '%'
                             else plHist.yAxisLabel := ' ' ;

     { Create Histogram plot }
     plHist.CreateHistogram( 0 ) ;
     for i := 0 to Hist.NumBins-1 do plHist.AddBin( 0,
                                     Hist.Bins[i].Lo,
                                     Hist.Bins[i].Mid,
                                     Hist.Bins[i].Hi,
                                     Hist.Bins[i].y ) ;

     { Create and set Histogram cursors to initial positions }
     plHist.ClearVerticalCursors ;
     Cursors.HistRead := plHist.AddVerticalCursor( clBlue, '?r',0 ) ;
     plHist.VerticalCursors[Cursors.HistRead] := Hist.Bins[Hist.NumBins div 2].Mid ;

     Cursors.HistFit0 := plHist.AddVerticalCursor( clOlive, 'f',0 ) ;
     Cursors.HistFit1 := plHist.AddVerticalCursor( clOlive, 'f',0 ) ;
     plHist.LinkVerticalCursors(Cursors.HistFit0,Cursors.HistFit1);

     i := 0 ;
     while (Hist.Bins[i].y = 0.0) and (i < (Hist.NumBins-1)) do Inc(i) ;
     plHist.VerticalCursors[Cursors.HistFit0] := Hist.Bins[i].Mid ;


     i := Hist.NumBins - 1 ;
     while (Hist.Bins[i].y = 0.0) and (i > 0) do Dec(i) ;
     plHist.VerticalCursors[Cursors.HistFit1] := Hist.Bins[i].Mid ;

     // Clear all existing lines on plot
     plHist.ClearAllLines ;
     erHistResults.Lines.Clear ;

     Screen.Cursor := crDefault ;
     end;


procedure TMeasureFrm.cbHistVariableChange(Sender: TObject);
begin
   SetDefaultHistogramLimits ;
   end ;


procedure TMeasureFrm.SetDefaultHistogramLimits ;
{ -----------------------------------------------------------
  Set up default Histogram range for selected variable/channel
  ------------------------------------------------------------ }
var
    iVar : Integer ;
begin

   iVar := cbHistChannel.ItemIndex*MaxAnalysisVariables + Integer(cbHistVariable.Items.Objects[cbHistVariable.ItemIndex]) ;

   if NewSummaryNeeded then FillSummaryTable ;

   edHistMin.Units := Units[iVar] ;
   edHistMax.Units := Units[iVar] ;

   if NumRecordsAnalysed > 0 then begin
      edHistMin.Value := MinValue[iVar]*UnitsScale[iVar] ;
      edHistMax.Value := MaxValue[iVar]*UnitsScale[iVar] ;
      if edHistMax.Value = edHistMin.Value then edHistMax.Value := edHistMin.Value + 1.0 ;
      end ;

   HistogramLimitsNeeded := False ;
   end;


procedure TMeasureFrm.CalculateSummary ;
{ ========================================================
  Calculate summary of waveform analysis data held in file
  ========================================================}
var
   Rec,RecStart,RecEnd,Ch,iVar,jVar,n : Integer ;
   y : Single ;
begin

     screen.cursor := crHourGlass ;

     { Determine record range/channels to be plotted }
     RecStart := Round(edPlotRange.LoValue) ;
     RecEnd := Round(edPlotRange.HiValue) ;

     { Update Min/Max range of values in file }
     for Rec :=RecStart to RecEnd do begin

         { Get record header containing analysis results }
         GetRecordHeaderOnly( fH, rH, Rec ) ;

         if Rec = RecStart then begin
            { Initialise Min/Max if this is first record }
            for iVar := 0 to LastMeasureVariable do begin
                for ch := 0 to fH.NumChannels -1 do begin
                    jVar := ch*MaxAnalysisVariables + iVar ;
                    MaxValue[jVar] := -MaxSingle ;
                    MinValue[jVar] := MaxSingle ;
                    Mean[jVar] := 0. ;
                    StDev[jVar] := 0. ;
                    StErr[jVar] := 0. ;
                    NumRecordsAnalysed := 0 ;
                    end ;
                end ;
            end ;

         { Add record to analysis (if valid and of selected type }
         if UseRecord( rH, cbTypeToBeAnalysed.text ) then begin
            for iVar := 0 to LastMeasureVariable do begin
                for ch := 0 to fH.NumChannels-1 do begin
                    jVar := ch*MaxAnalysisVariables + iVar ;
                    { Min./Max. values }
                    if MaxValue[jVar] < rH.Value[jVar] then
                       MaxValue[jVar] := rH.Value[jVar] ;

                    if MinValue[jVar] > rH.Value[jVar] then
                       MinValue[jVar] := rH.Value[jVar] ;
                    { Mean }
                    Mean[jVar] := Mean[jVar]
                                                 + rH.Value[jVar] ;
                    end ;
                end ;
            Inc(NumRecordsAnalysed) ;
            end ;

         end ;

     { Calculate mean value for each variable}
     n := Max( NumRecordsAnalysed, 1 ) ;
     for ch := 0 to fH.NumChannels-1 do
         for iVar := 0 to LastMeasureVariable do begin
             jVar := ch*MaxAnalysisVariables + iVar ;
             Mean[jVar]:= Mean[jVar] / n ;
             end ;

     { Re-read the analysis blocks to get residual deviations from mean }
     for Rec := RecStart to RecEnd do begin
         GetRecordHeaderOnly( fH, rH, Rec ) ;
         if UseRecord( rH, cbTypeToBeAnalysed.text ) then begin
            for iVar := 0 to LastMeasureVariable do begin
                for ch := 0 to fH.NumChannels-1 do begin
                    jVar := ch*MaxAnalysisVariables + iVar ;
                    y := rH.Value[jVar] - Mean[jVar] ;
                    StDev[jVar] := StDev[jVar] + y*y ;
                    end ;
                end ;
            end ;
         end ;

     { Calculate standard deviation and error for each variable}
     for ch := 0 to fH.NumChannels-1 do begin
         for iVar := 0 to LastMeasureVariable do begin
             jVar := ch*MaxAnalysisVariables + iVar ;
             StDev[jVar]:= sqrt( StDev[jVar] / Max(n - 1,1) ) ;
             StErr[jVar]:= StDev[jVar]/sqrt( n ) ;
             end ;
         end ;

     screen.cursor := crDefault ;
     NewSummaryNeeded := False ;
     end ;


procedure TMeasureFrm.bSetHistAxesClick(Sender: TObject);
{ -----------------------------
  Customise Histogram plot axes
  -----------------------------}
begin
     SetAxesFrm.Plot := plHist ;
     SetAxesFrm.Histogram := True ;
     SetAxesFrm.ShowModal ;
     end;


procedure TMeasureFrm.FillSummaryTable ;
{ =======================================================================
  Fill summary table with mean/stdevs etc of waveform measurement results
  =======================================================================}
const
     cName = 0 ;
     cMean = 1 ;
     cStDev = 2;
     cStErr = 3 ;
     cMin = 4 ;
     cMax = 5 ;
     cNum = 6 ;
var
   SumCh,Row,Col,iVar,jVar,MaxWidth,WidthLimit,TotalWidth,ColWidth : Integer ;
begin

     { Calculate summary data if necessary }
     if NewSummaryNeeded then CalculateSummary ;

     { Get channel to be summarised }
     if cbSummaryChannel.itemindex < 0 then cbSummaryChannel.itemindex := 0 ;
     SumCh := cbSummaryChannel.itemindex ;

     { Set column titles }
     Summary.ColCount := cNum + 1 ;
     Summary.RowCount := 2 ;
     Summary.cells[0,0] := 'Variable' ;
     Summary.cells[cMean,0] := 'Mean' ;
     Summary.cells[cStDev,0] := 'St. Dev.' ;
     Summary.cells[cStErr,0] := 'St. Error' ;
     Summary.cells[cMin,0] := 'Min.' ;
     Summary.cells[cMax,0] := 'Max.' ;
     Summary.cells[cNum,0] := '(n)' ;

     { Fill rows of table }
     Row := 0 ;
     for iVar := 0 to LastMeasureVariable do begin
         if UseVariableInSummary(iVar) then begin
             jVar := SumCh*MaxAnalysisVariables + Integer(VarList.objects[iVar]);
             Row := Row + 1 ;
             Summary.RowCount := Row + 1 ;
             { Enter row of data }
             Summary.cells[cName,Row]  := VarList[iVar] ;
             if Units[jVar] <> ' ' then
                Summary.cells[cName,Row]  := Summary.cells[cName,Row] + ' (' +
                                             Units[jVar] + ')';
             Summary.cells[cMean,Row]  := format( '%8.4g',
                                          [Mean[jVar] *
                                           UnitsScale[jVar]] ) ;
             Summary.cells[cStDev,Row] := format( '%8.4g',
                                          [StDev[jVar] *
                                          UnitsScale[jVar]] ) ;
             Summary.cells[cStErr,Row] := format( '%8.4g',
                                          [StErr[jVar] *
                                          UnitsScale[jVar]] ) ;
             Summary.cells[cMin,Row]   := format( '%8.4g',
                                          [MinValue[jVar] *
                                          UnitsScale[jVar]] ) ;
             Summary.cells[cMax,Row]   := format( '%8.4g',
                                          [MaxValue[jVar] *
                                          UnitsScale[jVar]] ) ;
             Summary.cells[cNum,Row]   := format( '%d',[NumRecordsAnalysed] ) ;
             end ;
         end ;

     // Process messages to ensure stringgrid properties have changed
     Application.ProcessMessages ;

     { Set widths of columns to maximum of data }
     TotalWidth := 20 ;
     for Col := 0 to Summary.ColCount-1 do begin
         MaxWidth := 0 ;
         for Row := 0 to Summary.RowCount-1 do begin
             Summary.cells[Col,Row] := ' ' + TidyNumber(Summary.cells[Col,Row]) + ' ';
             ColWidth := Summary.canvas.TextWidth(Summary.cells[Col,Row]) ;
             if  ColWidth > MaxWidth then MaxWidth := ColWidth ;
             end ;
        Summary.ColWidths[Col] := MaxWidth ;
        TotalWidth := TotalWidth + MaxWidth ;
        end ;

     { Set width of summary table }
     WidthLimit := Page.ActivePage.Width - Summary.Left - 2 ;
     if TotalWidth < WidthLimit then Summary.Width := TotalWidth
                                else Summary.Width := WidthLimit ;



     end ;


procedure TMeasureFrm.SetCheckBoxCaption(
          CheckBox : TCheckBox ;
          VarNum : Integer
          ) ;
{ --------------------------------------
  Set summary check box caption and tag#
  -------------------------------------- }
begin
     CheckBox.caption := VarList[VarNum] ;
     CheckBox.Tag := VarNum ;
     end ;


function TMeasureFrm.UseVariableInSummary(
         VarNum : Integer
         ) : Boolean ;
{ ----------------------------------------------------------------------
  Determine whether variable #VarNum is checked for inclusion in summary
  ---------------------------------------------------------------------- }
begin
     if ckVariable0.Tag = VarNum then Result := ckVariable0.Checked
     else if ckVariable1.Tag = VarNum then Result := ckVariable1.Checked
     else if ckVariable2.Tag = VarNum then Result := ckVariable2.Checked
     else if ckVariable3.Tag = VarNum then Result := ckVariable3.Checked
     else if ckVariable4.Tag = VarNum then Result := ckVariable4.Checked
     else if ckVariable5.Tag = VarNum then Result := ckVariable5.Checked
     else if ckVariable6.Tag = VarNum then Result := ckVariable6.Checked
     else if ckVariable7.Tag = VarNum then Result := ckVariable7.Checked
     else if ckVariable8.Tag = VarNum then Result := ckVariable8.Checked
     else if ckVariable9.Tag = VarNum then Result := ckVariable9.Checked
     else if ckVariable10.Tag = VarNum then Result := ckVariable10.Checked
     else if ckVariable11.Tag = VarNum then Result := ckVariable11.Checked
     else if ckVariable12.Tag = VarNum then Result := ckVariable12.Checked
     else if ckVariable13.Tag = VarNum then Result := ckVariable13.Checked
     else if ckVariable14.Tag = VarNum then Result := ckVariable14.Checked
     else if ckVariable15.Tag = VarNum then Result := ckVariable15.Checked
     else if ckVariable16.Tag = VarNum then Result := ckVariable16.Checked
     else Result := True ;
     end ;


procedure TMeasureFrm.cbSummaryChannelChange(Sender: TObject);
{ -----------------------------------------------
  Channel displayed in summary table has changed
  ---------------------------------------------- }
begin
     { Request that the summary table be updated }
     FillSummaryTable ;
     end;


procedure TMeasureFrm.FillTable ;
{ ===================================================
  Fill table with selected waveform measurement lists
  ===================================================}
var
   StartAt,EndAt,Col,Rec,jVar : Integer ;
begin

     if NumTableColumns <= 0 then begin
        Table.ColCount := 1 ;
        Table.RowCount := 1 ;
        Table.Cells[0,0] := '' ;
        Exit ;
        end ;

     Table.ColCount := NumTableColumns ;
     Table.RowCount := 2 ;

     { Create column title }
     for Col := 0 to Table.ColCount-1 do begin
            jVar := TableChans[Col]*MaxAnalysisVariables + Integer(VarList.Objects[TableVars[Col]]);
            Table.cells[Col,0] := VarList[TableVars[Col]] ;
            case TableVars[Col] of
               vRecord,vGroup : Table.cells[Col,1] := '' ;
               vTime : Table.cells[Col,1] := '(' + Units[jVar] + ')'
               else begin
                  Table.cells[Col,1] := ChannelNames[TableChans[Col]] +
                                        ' (' + Units[jVar] + ')' ;
                  end ;
               end ;
         end ;

     { Update table with data }

     StartAt := Round(edPlotRange.LoValue) ;
     EndAt := Round(edPlotRange.HiValue) ;
     for Rec := StartAt to EndAt do begin
         { Read analysis data from record }
         GetRecordHeaderOnly( fH, rH, Rec ) ;
         { Only use ACCEPTED records of appropriate type }
         if UseRecord( rH, cbTypeToBeAnalysed.text ) then begin
            { Fill row with selected variables }
            Table.RowCount := Table.RowCount + 1 ;
            for Col := 0 to Table.ColCount-1 do begin
                   jVar := TableChans[Col]*MaxAnalysisVariables + Integer(VarList.Objects[TableVars[Col]]);
                   Table.cells[Col,Table.RowCount-1] := format('%8.4g',
                                                        [rH.Value[jVar]*UnitsScale[jVar]] ) ;
                   end ;
            end ;
         end ;

     { Set width table }
     Table.Width := Page.Width + Page.Left - Table.Left - 30 ;

     Table.FixedRows := Min(2,Table.RowCount-1) ;

     NewTableNeeded := False ;

     end ;


procedure TMeasureFrm.ckBadRecordClick(Sender: TObject);
{ ------------------------------------------------
  Save new record ACCEPTED/REJECTED status to file
  ------------------------------------------------}
begin
     if ckBadRecord.checked then RH.Status := 'REJECTED'
                            else RH.Status := 'ACCEPTED' ;
     PutRecordHeaderOnly( fH, RH, fH.RecordNum ) ;
     end;


procedure TMeasureFrm.cbRecordTypeChange(Sender: TObject);
{ -----------------------------
  Save new record type to file
  ----------------------------}
begin
     RH.RecType := cbRecordType.text ;
     PutRecordHeaderOnly( fH, RH, fH.RecordNum ) ;
     end;


procedure TMeasureFrm.edRecordNumKeyPress(Sender: TObject; var Key: Char);
{ ------------------------------------
  Go to record number entered by user
  -----------------------------------}
begin
     if key = chr(13) then begin
        sbRecordNum.Position := Round(edRecordNum.LoValue) ;
        edRecordNum.HiValue := FH.NumRecords ;
        DisplayRecord ;
        end ;
     end;


procedure TMeasureFrm.FormClose(Sender: TObject; var Action: TCloseAction);
{ ---------------------------------------------
  Destroy the form to remove it from the screen
  ---------------------------------------------}
begin
     Action := CaFree ;

     // Close computation thread (if active)
     StopDoAnalysisThread ;

     end;


procedure TMeasureFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
// ---------------------------
// Check if form can be closed
// ---------------------------
begin
    if not bDoAnalysis.Enabled then CanClose := False ;
    CloseFormASAP := True ;
    end;


procedure TMeasureFrm.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin
     ADC := Nil ;
     Hist := THistogram.Create ;
     VarList := TStringList.Create ;
     XYResults := TStringList.Create ;
     HistResults := TStringList.Create ;
     MathFunc := TMathFunc.Create ;
     MathFunc.Setup( None, ' ', ' ' ) ;
     DoAnalysisThread := Nil ;
     end;


procedure TMeasureFrm.FormDestroy(Sender: TObject);
// ----------------------------
// Tidy up when form destroyed
// ----------------------------
begin
    if ADC <> Nil then FreeMem(ADC) ;
    VarList.Free ;
    Hist.Free ;
    XYResults.Free ;
    HistResults.Free ;
    MathFunc.Free ;
    end;


function TMeasureFrm.UseRecord ( const RecH : TRecHeader ;
                                 RecType : string ) : Boolean ;
{ -----------------------------------------------------
  Select record for inclusion on graph, Histogram, etc.
  -----------------------------------------------------}
begin
     if (RecH.Status = 'ACCEPTED') and RecH.AnalysisAvailable
        and ( (RecH.RecType = RecType) or ( RecType = 'ALL') ) then
        UseRecord := True
     else UseRecord := False ;
     end ;


procedure TMeasureFrm.CreateVariable(
          iNum : Integer ;
          VName : string ;
          VUnits : Array of String ;
          VScale : single
          )  ;
var
   ch,iVar : Integer ;
begin

     VarName[iNum] := VName ;
     VarList.AddObject( VarName[iNum], TObject(iNum) ) ;

     for ch := 0 to RawFH.NumChannels-1 do begin
         iVar := ch*MaxAnalysisVariables + iNum ;
         Units[iVar] := VUnits[ch] ;
         UnitsScale[iVar] := VScale ;
         end ;
    end ;


procedure TMeasureFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{ ------------------------
  Function key processing
  1/12/97 ... Ctrl-R changes Accepted/Rejected, Record types can be set by key
  -----------------------}
begin
     { function keys only active when a signal record is displayed }
     if (Page.ActivePage = AnalysisTab) then begin

        case Key of
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
          $31, $32, $33,$54,$4c,$45,$4d,$46 : begin
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
                  PutRecordHeaderOnly( fH, RH, fH.RecordNum ) ;
                  end ;
               end ;
          $52 : begin
               if (Shift = [ssCtrl]) then begin
                  ckBadRecord.Checked := not ckBadRecord.Checked ;
                  If ckBadRecord.Checked then RH.Status := 'REJECTED'
                                         else RH.Status := 'ACCEPTED' ;
                  PutRecordHeaderOnly( fH, RH, fH.RecordNum ) ;
                  end;
               end ;
          end ;
        end ;
     end;


procedure TMeasureFrm.sbRecordNumChange(Sender: TObject);
begin
     DisplayRecord ;
     end;


procedure TMeasureFrm.PageChange(Sender: TObject);
{ ----------------------------------------------
  Modifications to controls when page is changed
  ---------------------------------------------- }
var
   TopOfTabPage,LeftOfTabPage : Integer ;
begin
     TopOfTabPage := Page.Top + Page.ActivePage.Top ;
     LeftOfTabPage := Page.Left + Page.ActivePage.Left ;

     if Page.ActivePage = AnalysisTab then begin
        RecordsGrp.Visible := False ;
        end
     else if Page.ActivePage = XYPlotTab then begin
        RecordsGrp.Visible := True ;
        RecordsGrp.Top := TopOfTabPage + XYPlotGrp.Top + 10 ;
        RecordsGrp.Left := LeftOfTabPage + XYPlotGrp.Left + bNewXYPlot.Left ;
        if Integer(cbYVariable.Items.Objects[cbYVariable.ItemIndex]) = vConductance then begin
           PanConductance.Visible := True ;
           PanVar.Visible := False ;
           end
        else begin
           PanConductance.Visible := False ;
           PanVar.Visible := True ;
           end ;

        end
     else if Page.ActivePage = HistogramTab then begin
        RecordsGrp.Visible := True ;
        RecordsGrp.Top := TopOfTabPage + HistGrp.Top + 10 ;
        RecordsGrp.Left :=  LeftOfTabPage + HistGrp.Left + bNewHistogram.Left ;
        if HistogramLimitsNeeded then SetDefaultHistogramLimits ;
        end
    else if Page.ActivePage = SummaryTab then begin
        { Place records group }
        RecordsGrp.Visible := True ;
        RecordsGrp.Top := TopOfTabPage + SummaryGrp.Top + 10 ;
        RecordsGrp.Left :=  LeftOfTabPage + SummaryGrp.Left + 8 ;
        FillSummaryTable ;
        end
    else if Page.ActivePage = TablesTab then begin
        RecordsGrp.Visible := True ;
        RecordsGrp.Top := TopOfTabPage + SummaryGrp.Top + 10 ;
        RecordsGrp.Left :=  LeftOfTabPage + SummaryGrp.Left + 8 ;
        FillTable ;
        end ;

    end;


function TMeasureFrm.ImageAvailable ;
// ---------------------------------------------------
// Return TRUR if image available for copying/printing
// ---------------------------------------------------
begin

     Result := False ;

     if Page.ActivePage = AnalysisTab then begin
        Result := True ;
        end
     else if Page.ActivePage = XYPlotTab then begin
        Result := plPlot.Available ;
        end
     else if Page.ActivePage = HistogramTab then begin
        Result := plHist.Available ;
        end
     else if Page.ActivePage = SummaryTab then begin
        Result := False ;
        end
     else if Page.ActivePage = TablesTab then begin
        Result := False ;
        end ;

     end ;


function TMeasureFrm.DataAvailable ;
// ---------------------------------------------------
// Return TRUE if data available for copying/printing
// ---------------------------------------------------
begin

     Result := False ;

     if Page.ActivePage = AnalysisTab then begin
        Result := True ;
        end
     else if Page.ActivePage = XYPlotTab then begin
        Result := plPlot.Available ;
        end
     else if Page.ActivePage = HistogramTab then begin
        Result := plHist.Available ;
        end
     else if Page.ActivePage = SummaryTab then begin
        Result := True ;
        end
     else if Page.ActivePage = TablesTab then begin
        Result := True ;
        end ;

     end ;


procedure TMeasureFrm.FormResize(Sender: TObject);
{ ------------------------------------------------------
  Adjust size/position of controls when form is re-sized
  ------------------------------------------------------ }
const
     BottomMargin = 2 ;
begin
     { Set size of tabbed pages }
     Page.Width := ClientWidth - Page.Left - 5 ;
     Page.Height := ClientHeight - Page.Top - 5 ;

     { Analysis page }
     AnalysisGrp.Height := Page.ActivePage.Height - AnalysisGrp.Top - BottomMargin ;

     { Set size of results group }
     ResultsGrp.Top := Page.ActivePage.Height - ResultsGrp.Height - BottomMargin ;
     ResultsGrp.Width := Page.ActivePage.Width - ResultsGrp.Left - 2 ;
     sgResults.Width := ResultsGrp.Width - sgResults.Left - 5 ;

     { Set size of scope display }
     ckFixedZeroLevels.Left := scDisplay.left ;
     ckFixedZeroLevels.Top := ResultsGrp.Top - 5 - ckFixedZeroLevels.Height ;
     scDisplay.Height := Max( ckFixedZeroLevels.Top - scDisplay.Top -1,2) ;


     scDisplay.Width := Max( ResultsGrp.Width,2) ;

     { X/Y Plot page }

     { Set size of results group }
     XYFitGrp.Top := Page.ActivePage.Height - XYFitGrp.Height - BottomMargin ;
     XYFitGrp.Width := Page.ActivePage.Width - XYFitGrp.Left - 2 ;
     erXYResults.Width := XYFitGrp.Width - erXYResults.Left - 5 ;

     XYPlotGrp.Height := Page.ActivePage.Height - XYPlotGrp.Top - BottomMargin ;
     { Cursor labels }

     plPlot.Height := Max(XYFitGrp.Top - plPlot.Top - 5,2) ;
     plPlot.Width := Max(Page.ActivePage.Width - plPlot.Left - 5,2) ;

     { Histogram page }

     HistGrp.Height := Page.ActivePage.Height - HistGrp.Top - BottomMargin ;
     { Set size of results group }
     HistFitGrp.Top := Page.ActivePage.Height - HistFitGrp.Height - BottomMargin ;
     HistFitGrp.Width := Page.ActivePage.Width - HistFitGrp.Left - 2 ;
     erHistResults.Width := HistFitGrp.Width - erHistResults.Left - 5 ;

     // Plot area size
     plHist.Height := HistFitGrp.Top - plHist.Top  - 5 ;
     plHist.Width := Page.ActivePage.Width - plHist.Left - 5 ;

     { Summary page }
     SummaryGrp.Height := Page.ActivePage.Height - SummaryGrp.Top - BottomMargin ;
     Summary.Height := SummaryGrp.Height - 1 ;
     Summary.Width := Page.ActivePage.Width - Summary.Left - 5 ;

     { Tables page }
     Table.Height := Page.ActivePage.Height - Table.Top - 10 ;
     Table.Width := Page.ActivePage.Width - Table.Left - 5 ;
     
     end;



procedure TMeasureFrm.edPeakAvgKeyPress(Sender: TObject; var Key: Char);
// -------------------------------------
// No. points to average at peak changed
// -------------------------------------
begin
     if Key = #13 then begin
        FH.NumPointsAveragedAtPeak := Round(edPeakAvg.Value) ;
        end;
      end;

procedure TMeasureFrm.edPlotRangeKeyPress(Sender: TObject; var Key: Char);
{ -----------------------------------------------
  Update appropriate plot when plot range changed
  ----------------------------------------------- }
begin
     NewSummaryNeeded := True ;
     if key = chr(13) then begin
        if Page.ActivePage = SummaryTab then FillSummaryTable
        else if Page.ActivePage = XYPlotTab then bNewXYPlot.Click
        else if Page.ActivePage = HistogramTab then bNewHistogram.Click
        else if Page.ActivePage = SummaryTab then FillSummaryTable
        else if Page.ActivePage = TablesTab then FillTable ;
        end ;
     end;


procedure TMeasureFrm.ckVariable0Click(Sender: TObject);
begin
     FillSummaryTable ;
     end;


procedure TMeasureFrm.CopyDataToClipboard ;
{ -----------------------------------------------------------
  Copy the data in currently displayed graph to the clipboard
  -----------------------------------------------------------}
begin
     if Page.ActivePage = XYPlotTab then plPlot.CopyDataToClipboard
     else if Page.ActivePage = HistogramTab then plHist.CopyDataToClipboard
     else if Page.ActivePage = SummaryTab then CopyStringGrid(Summary)
     else if Page.ActivePage = TablesTab then CopyStringGrid(Table);
     end ;


procedure TMeasureFrm.Print ;
{ ---------------------------------------------
  Print the currently displayed graph or table
  --------------------------------------------- }
var
   i : Integer ;
begin

     if Page.ActivePage = AnalysisTab then begin
        { Print record on display }
        PrintRecFrm.Destination := dePrinter ;
        PrintRecFrm.DisplayObj := scDisplay ;
        PrintRecFrm.ShowModal ;
        if PrintRecFrm.ModalResult = mrOK then begin
           scDisplay.ClearPrinterTitle ;
           scDisplay.AddPrinterTitleLine( ' File : ' + FH.FileName ) ;
           scDisplay.AddPrinterTitleLine( ' ' + FH.IdentLine ) ;
           scDisplay.Print ;
           end ;
        end

     else if Page.ActivePage = XYPlotTab then begin
       { Print X/Y plot }
       PrintGraphFrm.Plot := plPlot ;
       PrintGraphFrm.ToPrinter := True ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then begin
          { Add title information to plot }
          plPlot.ClearPrinterTitle ;
          plPlot.AddPrinterTitleLine( ' File ... ' + FH.FileName ) ;
          plPlot.AddPrinterTitleLine( ' ' + FH.IdentLine ) ;
          for i := 0 to erXYResults.Lines.Count-1 do
              plPlot.AddPrinterTitleLine(erXYResults.Lines[i]) ;
          { Plot graph to printer }
          plPlot.Print ;
          end ;
       end

     else if Page.ActivePage = HistogramTab then begin
       { Print Histogram }
       PrintGraphFrm.Plot := plHist ;
       PrintGraphFrm.ToPrinter := True ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then begin
          { Add title information to plot }
          plHist.ClearPrinterTitle ;
          plHist.AddPrinterTitleLine( 'File ... ' + FH.FileName ) ;
          plHist.AddPrinterTitleLine( FH.IdentLine ) ;
          for i := 0 to HistResults.Count-1 do
              plHist.AddPrinterTitleLine(HistResults[i]) ;
          { Plot graph to printer }
          plHist.Print ;
          end ;
       end

     else if Page.ActivePage = SummaryTab then begin
       PrintTableFrm.Table := Summary ;
       PrintTableFrm.Title :=  'Waveform Measurements Summary: ' ;
       PrintTableFrm.ShowModal ;
       if PrintTableFrm.ModalResult = mrOK then
          WriteToLogFile( 'Waveform measurements summary table printed' ) ;
       end

     else if Page.ActivePage = TablesTab then begin
       PrintTableFrm.Table := Table ;
       PrintTableFrm.Title :=  'Waveform Measurements: ' ;
       PrintTableFrm.ShowModal ;
       if PrintTableFrm.ModalResult = mrOK then
          WriteToLogFile( 'Waveform measurements results table printed' ) ;
       end

     end ;


procedure TMeasureFrm.CopyImageToClipboard ;
{ -----------------------------------------------------
  Copy active plot to clipboard as Windows metafile
  ----------------------------------------------------- }
begin

    if Page.ActivePage = XYPlotTab then begin
       { Copy X/Y Plot }
       PrintGraphFrm.Plot := plPlot ;
       PrintGraphFrm.ToPrinter := False ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then plPlot.CopyImageToClipboard ;
       end
    else if Page.ActivePage = HistogramTab then begin
       { Copy Histogram }
       PrintGraphFrm.Plot := plHist ;
       PrintGraphFrm.ToPrinter := False ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then plHist.CopyImageToClipboard ;
       end
     else if Page.ActivePage = AnalysisTab then begin
        { Copy fit record on display }
        PrintRecFrm.Destination := deClipboard ;
        PrintRecFrm.DisplayObj := scDisplay ;
        PrintRecFrm.ShowModal ;
        if PrintRecFrm.ModalResult = mrOK then begin
           scDisplay.ClearPrinterTitle ;
           scDisplay.AddPrinterTitleLine( 'File : ' + FH.FileName ) ;
           scDisplay.AddPrinterTitleLine( FH.IdentLine ) ;
           scDisplay.CopyImageToClipboard ;
           end ;
        end ;

     end ;


procedure TMeasureFrm.scDisplayMouseUp(Sender: TObject;
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
           SaveHeader( FH ) ;
           end ;
        end ;

     end ;


procedure TMeasureFrm.scDisplayCursorChange(Sender: TObject);
{ -------------------------------------
  Update cursor labels when mouse moved
  ------------------------------------- }
var
   ch : Integer ;
begin

     if not TScopeDisplay(Sender).CursorChangeInProgress then begin
        TScopeDisplay(Sender).CursorChangeInProgress := True ;

        { Time zero }
        { Update channel descriptors with any changes to display }
        for ch := 0 to scDisplay.NumChannels-1 do if Channel[ch].InUse then begin
            Channel[Ch].yMin := scDisplay.YMin[Ch] ;
            Channel[Ch].yMax := scDisplay.YMax[Ch] ;
            Channel[ch].InUse := scDisplay.ChanVisible[ch] ;
            { Get signal baseline cursor }
            if Settings.FixedZeroLevels or (Channel[ch].ADCZeroAt >= 0) then begin
               if scDisplay.HorizontalCursors[ch] <> Channel[ch].ADCZero then begin
                  scDisplay.HorizontalCursors[ch] := Channel[ch].ADCZero ;
                  end ;
               end
            else begin
               Channel[ch].ADCZero := Round(scDisplay.HorizontalCursors[ch]) ;
               end ;

            end ;

        TScopeDisplay(Sender).CursorChangeInProgress := False ;

        end;
     end ;


procedure TMeasureFrm.cbRateofRiseModeChange(Sender: TObject);
{ -----------------------------------------------------
  Change differentiation mode for rate of rise variable
  ----------------------------------------------------- }
begin
     Settings.DifferentiationMode := cbRateofRiseMode.ItemIndex ;
     end;


procedure TMeasureFrm.bHistFitClick(Sender: TObject);
{ ---------------------------------------------------
  Fit a gaussian prob. density functions to Histogram
  ---------------------------------------------------
    25/6/98 Clipboard buffer limit reduced to 31000
    14/1/99 New MathFunc object used }
var
   i,iStart,iEnd,nFit,iBins, Comp,LineNum,NumComp : Integer ;
   ParName : string ;
   Scale,x,dx,PScale : single ;
   ParTemp : Array[0..LastParameter] of single ;
   FitData : PXYData ;
   OK : Boolean ;
begin
     OK := True ;
     New( FitData ) ;
     Try

        { Clear all existing lines on plot }
        plHist.ClearAllLines ;
        HistResults.Clear ;
        erHistResults.Lines.Clear ;

        { Select type of equation to be fitted }
        MathFunc.Setup( TEqnType(cbHistEquation.Items.Objects[cbHistEquation.ItemIndex]),
                        Channel[cbHistChannel.ItemIndex].ADCUnits,
                        plHist.yAxisLabel)  ;
        if MathFunc.Equation = None then OK := False ;

        { Copy data into fitting array }
        nFit := 0 ;
        if OK then begin

           { Lower and upper x data limit set by display cursors }
           iStart := plHist.FindNearestIndex( 0, Cursors.HistFit0 ) ;
           iEnd :=   plHist.FindNearestIndex( 0, Cursors.HistFit1 ) ;
           for iBins := Min(iStart,iEnd) to Max(iStart,iEnd) do begin
               FitData^.x[nFit] := Hist.Bins[iBins].Mid ;
               FitData^.y[nFit] := Hist.Bins[iBins].y ;
               Inc(nFit) ;
               end ;

           // Convert to percentage of total events in histogram
           if ckPercentage.Checked then begin
              PScale := 0.0 ;
              for i := 0 to Hist.NumBins-1 do PScale := PScale + Hist.Bins[i].y ;
              PScale := 100.0 / PScale ;
              for i := 0 to nFit-1 do FitData^.y[i] := PScale*FitData^.y[i] ;
              end ;

           { Abort curve fit, if not enough data points }
           if nFit < MathFunc.NumParameters then begin
              ShowMessage( format('%d points is insufficient for fit',[nFit])) ;
              MathFunc.Setup( None, ' ',' ' ) ;
              OK := False ;
              end ;
           end ;

        { Create an initial set of guesses for parameters }
        if OK then begin
           SetFitParsFrm.MathFunc := MathFunc ;
           SetFitParsFrm.XYData := FitData ;
           SetFitParsFrm.NumPoints := nFit ;
           SetFitParsFrm.ShowModal ;
           if SetFitParsFrm.ModalResult <> mrOK then OK := False ;
           end ;

        { Fit curve using non-linear regression }
        if OK then begin
           MathFunc := SetFitParsFrm.MathFunc ;
           { Prevent FitCurve from changing parameter settings }
           MathFunc.ParametersSet := True ;
           MathFunc.UseBinWidths := False ;
           MathFunc.FitCurve( FitData^, nFit ) ;
           OK := MathFunc.GoodFit ;
           end ;

        { Plot equation on graph }
        if OK and (MathFunc.Equation <> None) then begin

           x := plHist.xAxisMin ;
           dx := (plHist.xAxisMax - plHist.xAxisMin) / NumFitPoints ;
           plHist.ShowLines := True ;
           plHist.CreateLine( FittedLine, clRed, msNone, psSolid ) ;
           for i := 0 to NumFitPoints-1 do begin
               plHist.AddPoint( FittedLine, x, MathFunc.Value(x) ) ;
               x := x + dx ;
               end ;

           { Save parameters and initialise gaussian component lines }
           NumComp := MathFunc.NumParameters div 3 ;
           LineNum := FittedLine ;
           for Comp := 0 to NumComp-1 do begin
               Inc(LineNum) ;
               plHist.CreateLine( LineNum, clRed, msNone, psSolid ) ;
               ParTemp[Comp*3] := MathFunc.Parameters[Comp*3] ;
               ParTemp[Comp*3+1] := MathFunc.Parameters[Comp*3+1] ;
               ParTemp[Comp*3+2] := MathFunc.Parameters[Comp*3+2] ;
               MathFunc.Parameters[Comp*3+2] := 0.0 ;
               end ;

           { Plot each individual gaussian component }
           if NumComp > 1 then begin
              LineNum := FittedLine ;
              for Comp := 0 to NumComp-1 do begin
                  MathFunc.Parameters[Comp*3+2] := ParTemp[Comp*3+2] ;
                  Inc(LineNum) ;
                  x := plHist.xAxisMin ;
                  dx := (plHist.xAxisMax - plHist.xAxisMin) / NumFitPoints ;
                  for i := 0 to Hist.NumBins-1 do begin
                      plHist.AddPoint( LineNum, x, MathFunc.Value(x) ) ;
                      x := x + dx ;
                      end ;
                  MathFunc.Parameters[Comp*3+2] := 0.0 ;
                  end ;
              end ;

           { Restore parameters }
           for Comp := 0 to NumComp-1 do begin
               MathFunc.Parameters[Comp*3] := ParTemp[Comp*3] ;
               MathFunc.Parameters[Comp*3+1] := ParTemp[Comp*3+1] ;
               MathFunc.Parameters[Comp*3+2] := ParTemp[Comp*3+2] ;
               end ;
           end ;


        { Display results }

        if OK then begin

          case MathFunc.Equation of
              Gaussian : HistResults.Add(
                ' y(x) = (a/^!(2^sp^ss^+2))*exp(-(x-^sm)^+2/(2*^ss^+2) )') ;
              Gaussian2 : HistResults.Add(
                ' y(x) = ^sS^-i^-=^-1^-.^-.^-2 (a^-i/^!(2^sp^ss^-i^+2))*exp(-(x-^sm^-i)^+2/(2*^ss^-i^+2) )') ;
              Gaussian3 : HistResults.Add(
                ' y(x) = ^sS^-i^-=^-1^-.^-.^-3 (a^-i/^!(2^sp^ss^-i^+2))*exp(-(x-^sm^-i)^+2/(2*^ss^-i^+2) )') ;
              end ;

           { Best fit parameters and standard error }
           for i := 0 to MathFunc.NumParameters-1 do begin

               { Convert gaussian peak parameter to gaussian area }
               if ((i+1) mod 3) = 0 then begin
                  if MathFunc.NumParameters > 3 then
                     ParName := format('Events%d',[(i+1) mod 3])
                  else ParName := 'a' ;
                  Scale := (sqrt(6.2831)*MathFunc.Parameters[i-1])/Hist.BinWidth ;
                  end
               else begin
                  ParName := MathFunc.ParNames[i] ;
                  Scale := 1.0 ;
                  end ;

               if not MathFunc.FixedParameters[i] then
                  HistResults.Add( format(' %s = %.4g ^~ %.4g (sd) %s',
                                       [ParName,
                                        Scale*MathFunc.Parameters[i],
                                        Scale*MathFunc.ParameterSDs[i],
                                        MathFunc.ParUnits[i]] ) )
               else
                  { Fixed parameter }
                  HistResults.Add( format(' %s = %.4g (fixed) %s',
                                       [ParName,
                                        MathFunc.Parameters[i],
                                        MathFunc.ParUnits[i]] ) ) ;
               end ;

           { Residual standard deviation }
           HistResults.Add( format(' Residual S.D. = %.4g %s',
                                   [MathFunc.ResidualSD,plHist.yAxisLabel] ) ) ;

           { Statistical degrees of freedom }
           HistResults.Add( format(' Degrees of freedom = %d ',
                                   [MathFunc.DegreesOfFreedom]) );

           { No. of iterations }
           HistResults.Add( format(' No. of iterations = %d ',[MathFunc.Iterations]) ) ;

           end ;

        MathFunc.CopyResultsToRichEdit( HistResults, erHistResults ) ;

     finally
            Dispose(FitData) ;
            end ;

     { Make sure plot is updated with changes }
     plHist.Invalidate ;

     end ;


procedure TMeasureFrm.EMFit(
          var Mean : Array of single ;
          var SD : Array of single ;
          var A : Array of single ;
          var nData : Integer ;
          var NumIterations : Integer ) ;
const
     MaxGaussians = 2 ;
     MaxIteration = 100 ;
     Threshold = 1E-4 ;
type
     TPostP = Array[0..MaxGaussians-1,0..5000] of Single ;
var
   Gaus : Array[0..MaxGaussians-1] of Single ;
   OldMean : Array[0..MaxGaussians-1] of Single ;
   OldSD : Array[0..MaxGaussians-1] of Single ;
   OldA : Array[0..MaxGaussians-1] of Single ;
   i,g,Iteration,Rec  : Integer ;
   RecStart,RecEnd,VarCh,VarVar,jVar : Integer ;
   Sum,Denom : single ;
   Done : Boolean ;
   x : ^TSingleArray ;
   PostP : ^TPostP ;
begin

     New(x) ;
     New(PostP) ;

     { Determine records, channels & variables to be plotted }
     VarCh := cbHistChannel.itemIndex ;
     VarVar := Integer(cbHistVariable.Items.Objects[cbHistVariable.ItemIndex]) ;
     RecStart := Round( edPlotRange.LoValue ) ;
     RecEnd := Round( edPlotRange.HiValue ) ;

     nData := 0 ;
     for Rec := RecStart to RecEnd do begin
         { Read record analysis block from file }
         GetRecordHeaderOnly( fH, rH, Rec ) ;
         if UseRecord( rH, cbTypeToBeAnalysed.text ) then begin
            jVar := VarCh*MaxAnalysisVariables + VarVar ;
            x^[nData] := rH.Value[jVar]*UnitsScale[jVar] ;
            Inc(nData);
            end ;
         end ;

     for g := 0 to 1 do begin
         OldMean[g] := 0.0 ;
         OldSD[g] := 0.0 ;
         Olda[g] := 0.0 ;
         end ;

     Done := False ;
     Iteration := 0 ;
     while not Done do begin
         { Posterior probabilities }
         for i := 0 to nData-1 do begin
             Gaus[0] := GaussianPDF(x^[i],Mean[0],SD[0]) ;
             Gaus[1] := GaussianPDF(x^[i],Mean[1],SD[1]) ;
             PostP^[0,i] := (a[0]*Gaus[0]) / ( a[0]*Gaus[0] + a[1]*Gaus[1] ) ;
             PostP^[1,i] := 1.0 - PostP^[0,i] ;
             end ;

         { Relative proportions of each component }
         Sum := 0.0 ;
         for i := 0 to nData-1 do Sum := Sum + PostP^[0,i] ;
         a[0] := Sum / nData ;
         a[1] := 1.0 - a[0] ;

         { Mean of each component }
         for g := 0 to 1 do begin
             Sum := 0.0 ;
             for i := 0 to nData-1 do Sum := Sum + PostP^[g,i]*x^[i] ;
             if a[g] > 0.0 then Mean[g] := Sum/(nData*a[g])
                           else Mean[g] := 0.0 ;
             end ;

         { Standard deviation of each component }
         for g := 0 to 1 do begin
             Sum := 0.0 ;
             for i := 0 to nData-1 do
                 Sum := Sum + PostP^[g,i]*(x^[i]-Mean[g])*(x^[i]-Mean[g]) ;
             if a[g] > 0.0 then SD[g] := sqrt(Sum/(nData*a[g]))
                           else SD[g] := 0.0 ;
             end ;

         Inc(Iteration) ;

         Done := True ;
         for g := 0 to 1 do begin
             If OldMean[g] <> 0.0 then Denom := OldMean[g]
                                  else Denom := 1.0 ;
             if Abs(Mean[g]-OldMean[g])/Denom >= Threshold then Done := False ;
             If OldSD[g] <> 0.0 then Denom := OldSD[g]
                                  else Denom := 1.0 ;
             if Abs(SD[g]-OldSD[g])/Denom >= Threshold then Done := False ;
             If Olda[g] <> 0.0 then Denom := Olda[g]
                                  else Denom := 1.0 ;
             if Abs(a[g]-Olda[g])/Denom >= Threshold then Done := False ;
             OldMean[g] := Mean[g] ;
             OldSD[g] := SD[g] ;
             Olda[g] := a[g] ;
             end ;
         if (Iteration = MaxIteration) then Done := True ;
         end ;

     Dispose(x) ;
     Dispose(PostP) ;
     end;


function TMeasureFrm.GaussianPDF(
         x : single ;
         Mean : single ;
         SD : single
         ) : single ;
var
   z : single ;
begin
     z := (x-Mean)/SD ;
     Result := exp(-z*z*0.5)/(SD*sqrt(2.0*Pi)) ;
     end ;


procedure TMeasureFrm.bFilterClick(Sender: TObject);
{ ------------------------------------------------
  Accept/reject records based upon filter criteria
  ------------------------------------------------ }
var
   Rec,StartAtRec,EndAtRec,yVar,yCh,NumMatches,jVar : Integer ;
   Status : string ;
   AllRecords,Matched : Boolean ;
   y : Single ;
begin

     FilterFrm.VarNames := VarList ;
     FilterFrm.ShowChannels := True ;
     FilterFrm.ShowModal ;
     if FilterFrm.ModalResult = mrOK then begin
        { Get filtering criteria }
        AllRecords := FilterFrm.AllRecords ;
        Ych := FilterFrm.Channel ;
        YVar := FilterFrm.Variable ;
        { Record range }
        StartAtRec := Round(edPlotRange.LoValue) ;
        EndAtRec := Round(edPlotRange.HiValue ) ;
        { Set progress bar }
        NumMatches := 0 ;
        for Rec := StartAtRec to EndAtRec do begin
            { Read record analysis block from file }
            GetRecordHeaderOnly( fH, rH, Rec ) ;
            jVar := YCh*MaxAnalysisVariables + YVar ;
            { Set record ACCEPTED/REJECTED according to criteria }
            y := rH.Value[jVar]*UnitsScale[jVar] ;

            Matched := False ;

            // All records have been selected
            if AllRecords then Matched := True ;

            // All types of records with selected variable matching critera
            if (FilterFrm.MatchType = 'ALL')
               and (FilterFrm.LowerLimit <= y)
               and (y <= FilterFrm.UpperLimit) then Matched := True ;

            // Selected type of record with selected variable matching critera
            if (FilterFrm.MatchType <> 'ALL') then begin
               if (rH.RecType = FilterFrm.MatchType)
                  and (FilterFrm.LowerLimit <= y)
                  and (y <= FilterFrm.UpperLimit) then Matched := True ;
               end ;

            if Matched then begin
               if FilterFrm.SetRecordStatus then rH.Status := FilterFrm.Status ;
               if FilterFrm.SetRecordType then rH.RecType := FilterFrm.RecType ;
               Inc(NumMatches) ;
               end ;

            { Write analysis block }
            PutRecordHeaderOnly( fH, rH, Rec ) ;

            { Update progress }
            Main.StatusBar.SimpleText := format(
            'Filtering Records: %d/%d (%d/%d matches',
            [Rec,EndAtRec,NumMatches,EndAtRec-StartAtRec+1]) ;

            Application.ProcessMessages ;

            end ;

        Main.StatusBar.SimpleText := format(
        'Filtering Records Done: %d/%d matches',
        [NumMatches,EndAtRec-StartAtRec+1]) ;

        { Log change to log file }
        if not AllRecords then WriteToLogFile (
                               Format('Records filtered %s = %.3g <= %s (%s) <= %.3g',
                               [Status,
                               FilterFrm.LowerLimit,
                               VarList[YVar],
                               ChannelNames[YCh],
                               FilterFrm.UpperLimit] ))
        else WriteToLogFile (Format('All Records = %s',[Status])) ;

        { Update plot }
        bNewXYPlot.Click ;

        end ;

     end;

procedure TMeasureFrm.bClearTableClick(Sender: TObject);
{ -------------------------------
  Clear all columns in data table
  ------------------------------- }
begin
     NumTableColumns := 0 ;
     Table.ColCount := 1 ;
     Table.RowCount := 2 ;
     FillTable ;
     end;


procedure TMeasureFrm.bXYFitClick(Sender: TObject);
{ --------------------------------------
  Fit mathematical functions to X-Y plot
  --------------------------------------
    25/6/98 Clipboard buffer limit reduced to 31000
    14/1/99 New MathFunc object used }
var
   i,iStart,iEnd,nFit,Chan,XVar,YVar : Integer ;
   x,dx,XStart,XEnd,Y : single ;
   FitData : PXYData ;
begin

     // Make X/Y data graph markers only
     plPlot.MarkerStyles[XYDataLine] := msOpenSquare ;
     plPlot.LineStyles[XYDataLine] := psClear  ;

     // Clear any existing fitted line / results
     plPlot.CreateLine( FittedLine, clRed, msNone, psSolid ) ;
     XYResults.Clear ;
     erXYResults.Lines.Clear ;

     { Select type of equation to be fitted }
     Chan := cbXChannel.ItemIndex ;
     XVar := Integer(cbXVariable.Items.Objects[cbXVariable.ItemIndex]) ;
     YVar := Integer(cbYVariable.Items.Objects[cbYVariable.ItemIndex]) ;
     MathFunc.Setup( TEqnType(cbXYEquation.Items.Objects[cbXYEquation.ItemIndex]),
                     Units[Chan*MaxAnalysisVariables+XVar],
                     Units[Chan*MaxAnalysisVariables+YVar] ) ;
     if MathFunc.Equation = None then begin
        plPlot.Invalidate ;
        Exit ;
        end ;

     { Copy data into fitting array }
     nFit := 0 ;
     { Lower and upper x data limit set by display cursors }
     iStart := plPlot.FindNearestIndex( 0, Cursors.PlotFit0 ) ;
     iEnd :=   plPlot.FindNearestIndex( 0, Cursors.PlotFit1 ) ;

     New( FitData ) ;
     for i := Min(iStart,iEnd) to Max(iStart,iEnd) do begin
         plPlot.GetPoint(0,i,FitData^.x[nFit],FitData^.y[nFit]) ;
         FitData^.x[nFit] := FitData^.x[nFit] ;
         Inc(nFit) ;
         end ;

     { Abort curve fit, if not enough data points }
     if nFit < MathFunc.NumParameters then begin
        ShowMessage( format('%d points is insufficient for fit',[nFit]));
        MathFunc.Setup( None, ' ',' ' ) ;
        Dispose(FitData) ;
        Exit ;
        end ;

     { Let user create/modify initial parameter settings and/or fix parameters at constant values }
     SetFitParsFrm.MathFunc := MathFunc ;
     SetFitParsFrm.XYData := FitData ;
     SetFitParsFrm.NumPoints := nFit ;
     SetFitParsFrm.ShowModal ;
     if SetFitParsFrm.ModalResult <> mrOK then begin
        Dispose(FitData) ;
        Exit ;
        end ;

     { Fit curve using non-linear regression }
     MathFunc := SetFitParsFrm.MathFunc ;
     { Prevent FitCurve from changing parameter settings }
     MathFunc.ParametersSet := True ;
     MathFunc.UseBinWidths := False ;
     MathFunc.FitCurve( FitData^, nFit ) ;
     if not MathFunc.GoodFit then begin
        Dispose(FitData) ;
        Exit ;
        end ;

     // Plot equation on graph
     if MathFunc.Equation <> None then begin
        plPlot.GetPoint(0,iStart,XStart,y) ;
        plPlot.GetPoint(0,iEnd,XEnd,y) ;
        dx := (XEnd - XStart) / NumFitPoints ;
        X := XStart ;
        plPlot.ShowLines := True ;
        for i := 0 to NumFitPoints-1 do begin
            plPlot.AddPoint( FittedLine, x, MathFunc.Value(x) ) ;
            x := x + dx ;
            end ;
        end ;

     XYResults.Add( ' ' + MathFunc.Name ) ;

     { Best fit parameters and standard error }
     for i := 0 to MathFunc.NumParameters-1 do begin
         if not MathFunc.FixedParameters[i] then
            XYResults.Add( format(' %s = %.4g +/- %.4g (sd) %s',
                           [MathFunc.ParNames[i],
                            MathFunc.Parameters[i],
                            MathFunc.ParameterSDs[i],
                            MathFunc.ParUnits[i]] ) )
         else
            { Fixed parameter }
            XYResults.Add( format(' %s = %.4g (fixed) %s',
                                       [MathFunc.ParNames[i],
                                        MathFunc.Parameters[i],
                                        MathFunc.ParUnits[i]] ) ) ;
            end ;

     { Residual standard deviation }
     XYResults.Add( format(' Residual S.D. = %.4g %s',
           [MathFunc.ResidualSD,
           Units[cbYChannel.ItemIndex*MaxAnalysisVariables+YVar]] ) ) ;

     { Statistical degrees of freedom }
     XYResults.Add( format(' Degrees of freedom = %d ',
                                [MathFunc.DegreesOfFreedom]) );

     { No. of iterations }
     XYResults.Add( format(' No. of iterations = %d ',
                                [MathFunc.Iterations]) ) ;

     MathFunc.CopyResultsToRichEdit( XYResults, erXYResults ) ;

     Dispose(FitData) ;

     { Make sure plot is updated with changes }
     plPlot.Invalidate ;

     end ;



procedure TMeasureFrm.cbPeakModeChange(Sender: TObject);
// -----------------------------
// Peak measurement mode changed
// -----------------------------
begin
     // Call NewFile procedure to update peak variable name
     FH.PeakMode := cbPeakMode.ItemIndex ;
     KeepCursors := True ;
     NewFile ;
     end;


procedure TMeasureFrm.edDecayTimePercentageKeyPress(Sender: TObject; var Key: Char);
// ----------------------------------
// T.x% decay time end-point changed
// ----------------------------------
begin
     // Call NewFile procedure to update T.x% variable name
     if Key = #13 then begin
        FH.DecayTimePercentage := edDecayTimePercentage.Value ;
        SaveHeader(FH) ;
        KeepCursors := True ;
        NewFile ;
        end ;
     end ;


procedure TMeasureFrm.bGetCursorsClick(Sender: TObject);
// ---------------------------------------------------
// Place analysis cursors within displayed screen area
// ---------------------------------------------------
var
    ch : Integer ;
    XMargin : Single ;
begin
   XMargin := (scDisplay.xMax - scDisplay.xMin)*0.02 ;
   for ch := 0 to FH.NumChannels-1 do begin
       scDisplay.VerticalCursors[Cursors.C0[ch]] := Round(scDisplay.xMin + XMargin) ;
       scDisplay.VerticalCursors[Cursors.C1[ch]] := Round(scDisplay.xMax - XMargin) ;
       scDisplay.VerticalCursors[Cursors.T0] := Round(scDisplay.xMin) ;
       end ;
   end ;

procedure TMeasureFrm.bAddVariableClick(Sender: TObject);
// ---------------------------
// Add a variable to the table
// ---------------------------
begin

   AddVariableToTable( ckTabVar0 ) ;
   AddVariableToTable( ckTabVar1 ) ;
   AddVariableToTable( ckTabVar2 ) ;
   AddVariableToTable( ckTabVar3 ) ;
   AddVariableToTable( ckTabVar4 ) ;
   AddVariableToTable( ckTabVar5 ) ;
   AddVariableToTable( ckTabVar6 ) ;
   AddVariableToTable( ckTabVar7 ) ;
   AddVariableToTable( ckTabVar8 ) ;
   AddVariableToTable( ckTabVar9 ) ;
   AddVariableToTable( ckTabVar10 ) ;
   AddVariableToTable( ckTabVar11 ) ;
   AddVariableToTable( ckTabVar12) ;
   AddVariableToTable( ckTabVar13 ) ;
   AddVariableToTable( ckTabVar14 ) ;
   AddVariableToTable( ckTabVar15 ) ;
   AddVariableToTable( ckTabVar16 ) ;

   FillTable ;

   end;

procedure TMeasureFrm.AddVariableToTable(
          CheckBox : TCheckBox ) ;
// ---------------------
// Add variable to table
// ---------------------
begin
    if CheckBox.Checked then begin
       Inc(NumTableColumns) ;
       Table.ColCount := NumTableColumns  ;
       Table.Col := NumTableColumns - 1;
       TableChans[Table.Col] := cbTableChannel.ItemIndex ;
       TableVars[Table.Col] := CheckBox.Tag ;
       end ;
    end ;



procedure TMeasureFrm.bClearAllTableVariablesClick(Sender: TObject);
// ---------------------------------------------
// Deselect all variables in table addition list
// ---------------------------------------------
begin
     ckTabVar0.Checked := False ;
     ckTabVar1.Checked := False ;
     ckTabVar2.Checked := False ;
     ckTabVar3.Checked := False ;
     ckTabVar4.Checked := False ;
     ckTabVar5.Checked := False ;
     ckTabVar6.Checked := False ;
     ckTabVar7.Checked := False ;
     ckTabVar8.Checked := False ;
     ckTabVar9.Checked := False ;
     ckTabVar10.Checked := False ;
     ckTabVar11.Checked := False ;
     ckTabVar12.Checked := False ;
     ckTabVar13.Checked := False ;
     ckTabVar14.Checked := False ;
     ckTabVar15.Checked := False ;
     ckTabVar16.Checked := False ;
     end;


procedure TMeasureFrm.bSetClick(Sender: TObject);
// ---------------------------------------------
// Select all variables in table addition list
// ---------------------------------------------
begin
     ckTabVar0.Checked := True ;
     ckTabVar1.Checked := True ;
     ckTabVar2.Checked := True ;
     ckTabVar3.Checked := True ;
     ckTabVar4.Checked := True ;
     ckTabVar5.Checked := True ;
     ckTabVar6.Checked := True ;
     ckTabVar7.Checked := True ;
     ckTabVar8.Checked := True ;
     ckTabVar9.Checked := True ;
     ckTabVar10.Checked := True ;
     ckTabVar11.Checked := True ;
     ckTabVar12.Checked := True ;
     ckTabVar13.Checked := True ;
     ckTabVar14.Checked := True ;
     ckTabVar15.Checked := True ;
     ckTabVar16.Checked := True ;
     end;


procedure TMeasureFrm.bSaveTableToFileClick(Sender: TObject);
// ------------------
// Save table to file
// ------------------
var
    OutFile : TextFile ;
    Row,Col : Integer ;
    Text : String ;
begin

     { Present user with standard Save File dialog box }
     SaveDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     SaveDialog.DefaultExt := '.txt' ;
     SaveDialog.FileName := ChangeFileExt( RawFH.FileName, '.txt' ) ;
     SaveDialog.Filter := ' Text Files (*.txt)|*.txt' ;
     SaveDialog.Title := 'Save Table' ;
     if Settings.DataDirectory <> '' then begin
        SetCurrentDir( Settings.DataDirectory ) ;
        SaveDialog.InitialDir := Settings.DataDirectory ;
        end;
     if not SaveDialog.execute then Exit ;

     // Open file
     AssignFile( OutFile, SaveDialog.FileName ) ;
     ReWrite( OutFile ) ;

     // Write table to file
     for Row := 0 to Table.RowCount-1 do begin
         Text := '' ;
         for Col := 0 to Table.ColCount-1 do begin
             Text := Text + Table.Cells[Col,Row] ;
             if Col < (Table.ColCount-1) then Text := Text + #9
                                         else WriteLn( OutFile, Text ) ;
             end ;
         end ;

     // Close file
     CloseFile( OutFile ) ;

     end;

procedure TMeasureFrm.ckLockChannelCursorsClick(Sender: TObject);
// -------------------------------
// Lock/unlock measurement cursors
// -------------------------------
var
    C0CursorPosition : array[0..WCPMaxChannels-1] of Integer ;
    C1CursorPosition : array[0..WCPMaxChannels-1] of Integer ;
    T0CursorPosition : Integer ;
    ch : Integer ;
begin

    // Save existing cursor positions
    for ch := 0 to FH.NumChannels-1 do begin
        C0CursorPosition[ch] :=  Round(scDisplay.VerticalCursors[Cursors.C0[ch]]) ;
        C1CursorPosition[ch] :=  Round(scDisplay.VerticalCursors[Cursors.C1[ch]]) ;
        end ;
    T0CursorPosition := Round(scDisplay.VerticalCursors[Cursors.T0]) ;

    scDisplay.ClearVerticalCursors ;

    for ch := 0 to FH.NumChannels-1 do begin

        if ckLockChannelCursors.Checked then begin
           // Single set of cursors for all channels
           if ch = 0 then begin
              Cursors.C0[ch] := Round(scDisplay.AddVerticalCursor(AllChannels,clOlive,'?t')) ;
              Cursors.C1[ch] := Round(scDisplay.AddVerticalCursor(AllChannels,clOlive,'?t')) ;
              end
           else begin
              Cursors.C0[ch] := Cursors.C0[0] ;
              Cursors.C1[ch] := Cursors.C1[0] ;
              end ;

           end
        else begin
           // Independent cursors for each channel
           Cursors.C0[ch] := scDisplay.AddVerticalCursor(ch,clOlive,'?t') ;
           Cursors.C1[ch] := scDisplay.AddVerticalCursor(ch,clOlive,'?t') ;

           end ;

        scDisplay.VerticalCursors[Cursors.C0[ch]] := C0CursorPosition[0] ;
        scDisplay.VerticalCursors[Cursors.C1[ch]] := C1CursorPosition[0] ;

        scDisplay.LinkVerticalCursors( Cursors.C0[ch], Cursors.C1[ch] ) ;

        end ;

    Cursors.R := scDisplay.AddVerticalCursor(AllChannels,clGreen,'?y?t') ;
    scDisplay.VerticalCursors[Cursors.R] := FH.NumSamples div 2 ;
    Cursors.T0 := scDisplay.AddVerticalCursor(AllChannels,clGreen,'t=0') ;
    scDisplay.VerticalCursors[Cursors.T0] := T0CursorPosition ;

    Settings.LockChannelCursors := ckLockChannelCursors.Checked ;

    end;

procedure TMeasureFrm.FormActivate(Sender: TObject);
begin
     // Ensure display channels visibility is updated
     ChangeDisplayGrid ;
     ckFixedZeroLevels.Checked := Settings.FixedZeroLevels ;
     end;

procedure TMeasureFrm.cbYVariableChange(Sender: TObject);
begin
    if Integer(cbYVariable.Items.Objects[cbYVariable.ItemIndex]) = vConductance then begin
        PanConductance.Visible := True ;
        PanVar.Visible := False ;
        end
    else begin
        PanConductance.Visible := False ;
        PanVar.Visible := True ;
        end ;
    end;

function TMeasureFrm.TidyNumber(
         const RawNumber : string
         ) : string ;
var
   i0,i1 : Integer ;
begin
     i0 := 1 ;
     while (RawNumber[i0] = ' ') and (i0 < length(RawNumber)) do
           i0 := i0 + 1 ;
     i1 := length(RawNumber) ;
     while (RawNumber[i1] = ' ') and (i1 > 1) do i1 := i1 - 1 ;
     if i1 >= i0 then TidyNumber := Copy( RawNumber, i0, i1-i0+1 )
                 else TidyNumber := '?' ;
     end ;



procedure TMeasureFrm.ckFixedZeroLevelsClick(Sender: TObject);
// --------------------------------
// Enable/Disable fixed zero levels
// --------------------------------
begin
     Settings.FixedZeroLevels := ckFixedZeroLevels.Checked ;
     end;

procedure TMeasureFrm.SetStoreMode(
          StorageMode : Boolean
          ) ;
{ --------------------------------------------
  Set oscilloscope display storage mode on/off
  -------------------------------------------- }
begin
     scDisplay.StorageMode := StorageMode ;
     end ;


procedure TMeasureFrm.StopDoAnalysisThread ;
// ------------------------
// Stop and free computation thread
// ------------------------
begin
     if DoAnalysisThread = Nil Then Exit ;
     DoAnalysisThread.Terminate ;
     DoAnalysisThread.WaitFor ;
     FreeAndNil(DoAnalysisThread);
end;



end.
