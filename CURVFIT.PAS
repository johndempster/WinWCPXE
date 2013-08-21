unit Curvfit;
{ ==========================================================================
  WinWCP - Curve fitting module (c) J Dempster, 1996, All Rights Reserved
  V1.7f 16/7/97 ... Blocks of data in table and Summary grid can now be
                    selected for copying to clipboard
  V1.7c 11/9/97 ... X-Y plots now hold 6000 points
                    Histograms now copied to clipboard as Bin Mid,Y pairs
  1/12/97 Accepted/rejected toggling added (Ctrl-R)
          Ctrl-T etc sets record type
  24/2/98 ... +/- keys now step forward/back through records
  23/3/98 ... Curve fitting data buffer skip factor now correctly set,
              avoiding crashes when working on large records
              User is now also warned when record is too large for fitting
  12/4/99 ... V2.2 Residual standard deviation added to variable list
  28/6/99 ... V3.x (32 bit version)
  4/9/99 ... Display grid added
  10/9/99 ... Zero baseline level now correctly added to fitted curves
  13/9/99 ... Infinite loop in SelectEquation fixed
  3/11/99 ... NewFile now closes form if no records available
  21/1/01 ... Column selection in data table now works correctly
              Best fit parameters now printed out with fitted curve
  29/8/01 ... Fixed zero level now saved when changed
              From Record zero area indicated by pair of small vertical bars
              Ch. combo box now changes displayed channel correctly
  3/12/01 ... NewFile now retains displayed record number position
  22/3/02 ... Now handles records as large as 32768
  24.6.03 ... No. of display grid lines can be changed
  15.11.03 .. Curve of up to 32768 points can now be fitted
  17.03.04 .. SESLABIO.ADCMaxValue replaced with MaxADCValue
  13.11.04 .. Automatic cursor positioning now limited to displayed area
  23.05.06 .. No. of points per line now increased > 4096
  02.12.06 .. .ADCZero now subtracted as floating point to avoid rollover
              with 16 resolution ADCs
  19.08.07 .. Slope (M) of linear function now scaled correctly when time units = ms
  8.01.08 .. Analysis cursors now initially placed at 2% and 98% of record time course
  04.09.08 .. Get Cursors button added. Places cursors within displayed waveform area
  08.05.09 .. Summary and results tables can now be printed.
              Results table now includes variable units in title
  07.06.13 .. FH.NumZeroAvg now updated when changed in ZeroFrm
  26.07.13 .. Readout cursor added
  09.08.13 .. ADC now allocated by GetMem()
  ==========================================================================}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Grids, StdCtrls, TabNotBk, Global, Shared, Zero,
  FileIO, SetAxes, SetVar, PrintGra,
  Printers, ClipBrd, PrintRec, maths, ScopeDisplay, ValEdit, RangeEdit,
  XYPlotDisplay, ComCtrls, ValidatedEdit, math, strutils, seslabio ;

const
     NumFitChannels = 2 ;


type

TCurveFitCursors = Record
         T0 :   Integer ;
         C0 :   Integer ;
         C1 :   Integer ;
         R : Integer ;
         Base : Array[0..NumFitChannels-1] of Integer ;
         PlotRead : Integer ;
         HistRead : Integer ;
         end ;

  TFitFrm = class(TForm)
    Page: TPageControl;
    CurveFitTab: TTabSheet;
    XYPlotTab: TTabSheet;
    HistogramTab: TTabSheet;
    SummaryTab: TTabSheet;
    TablesTab: TTabSheet;
    RecordGrp: TGroupBox;
    Label2: TLabel;
    ckBadRecord: TCheckBox;
    sbRecordNum: TScrollBar;
    cbRecordType: TComboBox;
    AnalysisGrp: TGroupBox;
    bDoFit: TButton;
    bAbort: TButton;
    bSetParameters: TButton;
    CursorsGrp: TGroupBox;
    Label1: TLabel;
    cbDataLimitCursors: TComboBox;
    rbManualCursors: TRadioButton;
    rbAutoCursors: TRadioButton;
    RangeGrp: TGroupBox;
    Label7: TLabel;
    Label6: TLabel;
    rbThisRecord: TRadioButton;
    rbRecordRange: TRadioButton;
    cbTypeToBeAnalysed: TComboBox;
    cbFitChannel: TComboBox;
    rbAllRecords: TRadioButton;
    XYPlotGrp: TGroupBox;
    bNewXYPlot: TButton;
    XGroup: TGroupBox;
    cbXVariable: TComboBox;
    YGroup: TGroupBox;
    cbYVariable: TComboBox;
    bSetPlotAxes: TButton;
    HistGrp: TGroupBox;
    bNewHistogram: TButton;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label8: TLabel;
    cbHistVariable: TComboBox;
    bSetHistAxes: TButton;
    Summary: TStringGrid;
    Table: TStringGrid;
    plHist: TXYPlotDisplay;
    plPlot: TXYPlotDisplay;
    edRecRange: TRangeEdit;
    edLimits: TRangeEdit;
    edNumBins: TValidatedEdit;
    edHistMin: TValidatedEdit;
    edHistMax: TValidatedEdit;
    ResultsGrp: TGroupBox;
    erResults: TRichEdit;
    cbEquation: TComboBox;
    edRecordNum: TRangeEdit;
    RecordsGrp: TGroupBox;
    Label12: TLabel;
    edPlotRecType: TEdit;
    edPlotRange: TRangeEdit;
    ckPercentage: TCheckBox;
    ckCumulative: TCheckBox;
    SummaryGrp: TGroupBox;
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
    GroupBox1: TGroupBox;
    bFilter: TButton;
    bGetCursors: TButton;
    GroupBox2: TGroupBox;
    bClearTable: TButton;
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
    bAddVariable: TButton;
    bClearAllTableVariables: TButton;
    bSet: TButton;
    bSaveTableToFile: TButton;
    BadFitsGrp: TGroupBox;
    Label3: TLabel;
    ckIncludeBadFits: TCheckBox;
    edBadFitFlag: TValidatedEdit;
    SaveDialog: TSaveDialog;
    scDisplay: TScopeDisplay;
    ckFixedZeroLevels: TCheckBox;
    procedure bDoFitClick(Sender: TObject);
    procedure bAbortClick(Sender: TObject);
    procedure bNewXYPlotClick(Sender: TObject);
    procedure bNewHistogramClick(Sender: TObject);
    procedure bSetPlotAxesClick(Sender: TObject);
    procedure cbHistVariableChange(Sender: TObject);
    procedure bSetHistAxesClick(Sender: TObject);
    procedure TableMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure ckBadRecordClick(Sender: TObject);
    procedure edRecordNumKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bSetParametersClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cbEquationChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure cbRecordTypeChange(Sender: TObject);
    procedure sbRecordNumChange(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure edPlotRangeKeyPress(Sender: TObject; var Key: Char);
    procedure ckVariable0Click(Sender: TObject);
    procedure scDisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure bFilterClick(Sender: TObject);
    procedure bClearTableClick(Sender: TObject);
    procedure cbFitChannelChange(Sender: TObject);
    procedure bGetCursorsClick(Sender: TObject);
    procedure bAddVariableClick(Sender: TObject);
    procedure bClearAllTableVariablesClick(Sender: TObject);
    procedure bSetClick(Sender: TObject);
    procedure bSaveTableToFileClick(Sender: TObject);
    procedure ckFixedZeroLevelsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
   Hist : THistogram ;          { Dwell-time histogram data record }
   Func : TMathFunc ;
   ADC : PSmallIntArray ;
   DispBuf : PSmallIntArray ;
   VarNames : TStringList ;
   Results : TStringList ; // Curve fitting results
   RH : TRecHeader ; { Record header }
   Cursors : TCurveFitCursors ;
   BuffersAllocated : boolean ;{ Indicates if memory buffers have been allocated }
   NewSummaryNeeded : Boolean ;
   NewTableNeeded : Boolean ;
   HistogramLimitsNeeded : Boolean ;


    nDisplaySkip : Integer ;
    KeepCursors : Boolean ;

    VarName : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of string ;
    Units : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of string ;
    MaxValue : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
    MinValue : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
    Mean : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
    StDev : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
    StErr : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of single ;
    NumVariables : Integer ;
    NumRecordsAnalysed : Integer ;

    TableVars : array[0..WCPMaxChannels*MaxAnalysisVariables-1] of Integer ;
    NumTableColumns : Integer ;

    procedure DisplayRecord ;
    procedure CalculateSummary ;
    procedure FillSummaryTable ;
    procedure SetCheckBoxCaption(
              VarNum : Integer ) ;
    procedure ClearCheckBoxCaptions ;
    function GetCheckBoxVariableNumber(
             CheckBoxNum : Integer ) : Integer ;

    function UseVariableInSummary( VarNum : Integer ) : Boolean ;
    function AddVariableToTable( VarNum : Integer ) : Boolean ;
    
    procedure SelectEquation( var FitCh : Integer ; var EqnType : TEqnType ) ;
    procedure FillTable ;
    procedure SetDefaultHistogramLimits ;
    procedure NewVariableNames( FitCh : Integer ;EqnType : TEqnType ) ;

    procedure SetFittingDataCursors ;
    function UseRecord ( const RecH : TRecHeader ; RecType : string ) : Boolean ;

    procedure InitialiseDisplay( scDisplay : TScopeDisplay ) ;
    function TidyNumber( const RawNumber : string ) : string ;
  public
    { Public declarations }

    Procedure NewFile ;
    procedure CopyDataToClipboard ;
    procedure Print ;
    procedure CopyImageToClipboard ;
    procedure ChangeDisplayGrid ;
    procedure ZoomOut ;
    Function DataAvailable : Boolean ;
    Function ImageAvailable : Boolean ;

  end;

var
  FitFrm: TFitFrm;



implementation

uses mdiform, copyrec, Setfitpa, Filter , PrintTableUnit, measure ;
{$R *.DFM}
const
     ChData = 0 ;
     ChRes = 1 ;


procedure TFitFrm.FormShow(Sender: TObject);
{ ---------------------------------------
  Initialisations when form is displayed
  ---------------------------------------}
begin

     // Set position of form
     Left := 30 ;
     Top := 25 ;
     Height := Main.StatusBar.Top - Top - 10 ;
     Width := Main.ClientWidth - Left - 20 ;

     { Record type }
     cbRecordType.items := RecordTypes ;
     cbRecordType.items.delete(0) ; {Remove 'ALL' item}

     { Get list of equations available for fitting }
     { Create list of curves that can be fitted to x/y plots }
     cbEquation.Clear ;
     cbEquation.Items.AddObject( 'None', TObject(None)) ;
     cbEquation.Items.AddObject( 'Linear', TObject(Linear)) ;
     cbEquation.Items.AddObject( 'Exponential', TObject(Exponential)) ;
     cbEquation.Items.AddObject( '2 Exponentials', TObject(Exponential2)) ;
     cbEquation.Items.AddObject( '3 Exponentials', TObject(Exponential3)) ;
     cbEquation.Items.AddObject( 'EPC', TObject(EPC)) ;
     cbEquation.Items.AddObject( 'EPC 2 exp. decay', TObject(EPC2EXP)) ;
     cbEquation.Items.AddObject( 'H-H (K)', TObject(HHK)) ;
     cbEquation.Items.AddObject( 'H-H (Na)', TObject(HHNa)) ;
     cbEquation.Items.AddObject( 'Decaying Exp.', TObject(DecayingExp)) ;
     cbEquation.Items.AddObject( '2 Decaying Exps.', TObject(DecayingExp2)) ;
     cbEquation.Items.AddObject( '3 Decaying Exps.', TObject(DecayingExp3)) ;
     //cbEquation.Items.AddObject( '2 Decaying Exps.(A)', TObject(DecayingExp2A)) ;

     cbEquation.ItemIndex := 0 ;

     if cbEquation.ItemIndex < 0 then cbEquation.ItemIndex := 0 ;
     if cbDataLimitCursors.ItemIndex < 0 then cbDataLimitCursors.ItemIndex := 1 ;

     Screen.Cursor := crDefault ;

     Page.ActivePage := CurveFitTab ;
     RecordsGrp.Visible := False ;

     { Force resize to set dimensions of size-adjustable controls }
     Resize ;

     // Initialisations when a new data file is loaded
     KeepCursors := False ;

     NewFile ;

     // Clear table
     NumTableColumns := 0 ;
     Table.ColCount := 1 ;
     Table.RowCount := 2 ;

     // Force display to minimum magnification
     scDisplay.ZoomOut ;

     end;


procedure TFitFrm.InitialiseDisplay(
          scDisplay : TScopeDisplay   { Drawing area }
          ) ;
{ ------------------------------------------------
  Initialise display
  ------------------------------------------------}
var
   ch : integer ;
   Range : Single ;
begin
     { Continuous record display channel }
     scDisplay.MaxADCValue := FH.MaxADCValue ;
     scDisplay.MinADCValue := FH.MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;
     scDisplay.DisableChannelVisibilityButton := True ;

     scDisplay.MaxPoints := FH.NumSamples ;
     scDisplay.NumPoints := scDisplay.MaxPoints ;
     scDisplay.NumChannels := NumFitChannels ;
     scDisplay.xMin := 0 ;
     scDisplay.xMax := scDisplay.NumPoints - 1 ;
     nDisplaySkip := 1 ;

     { Set channel information }
     for ch := 0 to NumFitChannels-1 do begin
         scDisplay.ChanUnits[ch] := Channel[cbFitChannel.ItemIndex].ADCUnits ;
         scDisplay.ChanName[ch] := Channel[cbFitChannel.ItemIndex].ADCName ;
         scDisplay.ChanScale[ch] := Channel[cbFitChannel.ItemIndex].ADCScale ;
         scDisplay.ChanUnits[ch] := Channel[cbFitChannel.ItemIndex].ADCUnits ;
         scDisplay.ChanZero[ch] := Channel[cbFitChannel.ItemIndex].ADCZero ;
         scDisplay.ChanOffsets[ch] := ch ;
         scDisplay.yMin[ch] := Channel[cbFitChannel.ItemIndex].yMin ;
         scDisplay.yMax[ch] := Channel[cbFitChannel.ItemIndex].yMax ;
         scDisplay.ChanVisible[ch] := True ;
         scDisplay.ChanColor[ch] := clBlue ;
         end ;
     scDisplay.ChanName[chData] := Channel[cbFitChannel.ItemIndex].ADCName ;
     scDisplay.ChanName[chRes] := 'Res.' ;
     Range := Channel[cbFitChannel.ItemIndex].yMax
              - Channel[cbFitChannel.ItemIndex].yMin ;
     scDisplay.yMin[chRes] := -0.5*Range ;
     scDisplay.yMax[chRes] := 0.5*Range ;
     scDisplay.TScale := FH.dt*Settings.TScale ;
     scDisplay.TUnits := Settings.TUnits ; 

     end ;


procedure TFitFrm.NewFile ;
{ -----------------------------------------------------
  Reset variables and channel when a new file is loaded
  -----------------------------------------------------}
begin

     if FH.Numrecords > 0 then begin
        Caption := Main.UpdateCaption( FH, 'Curve Fit ' ) ;

        if DispBuf <> Nil then FreeMem( DispBuf ) ;
        GetMem( DispBuf, FH.NumSamples*4 ) ;
        if ADC <> Nil then FreeMem( ADC ) ;
        GetMem( ADC, FH.NumSamples*FH.NumChannels*2 ) ;

        { Initialise Fit Channel combo box }
        cbFitChannel.items := ChannelNames ;
        if cbFitChannel.ItemIndex < 0 then cbFitChannel.ItemIndex := 0 ;

        cbTypeToBeAnalysed.items := RecordTypes ;
        if cbTypeToBeAnalysed.itemIndex < 0 then cbTypeToBeAnalysed.itemIndex := 0 ;

        edRecRange.LoLimit := 1 ;
        edRecRange.LoValue := 1 ;
        edRecRange.HiLimit := Max(1,fH.NumRecords) ;
        edRecRange.HiValue := Max(1,fH.NumRecords) ;

        edPlotRange.LoLimit := 1 ;
        edPlotRange.LoValue := 1 ;
        edPlotRange.HiLimit := Max(1,fH.NumRecords) ;
        edPlotRange.HiValue := Max(1,fH.NumRecords) ;
        edPlotRecType.Text := 'ALL' ;

        { Initialise record and residuals 'scope displays }
        InitialiseDisplay( scDisplay ) ;

        Func.ParametersSet := False ;

        scDisplay.ClearHorizontalCursors ;
        Cursors.Base[ChData] := scDisplay.AddHorizontalCursor(
                                ChData,
                                Settings.Colors.Cursors,
                                True,
                                'z') ;
        scDisplay.HorizontalCursors[Cursors.Base[ChData]] := Channel[cbFitChannel.ItemIndex].ADCZero ;
        Cursors.Base[ChRes] := scDisplay.AddHorizontalCursor(
                               ChRes,
                               Settings.Colors.Cursors,
                               True,
                               'z') ;
        scDisplay.HorizontalCursors[Cursors.Base[ChRes]] := 0 ;

        // Fitting cursors f---f
        if not KeepCursors then begin
           { Set initial position of alignment cursors }
           scDisplay.ClearVerticalCursors ;
           Cursors.T0 := scDisplay.AddVerticalCursor(AllChannels,clGreen,'t=0') ;
           Cursors.C0 := scDisplay.AddVerticalCursor(AllChannels,clOlive,'?t0') ;
           scDisplay.VerticalCursors[Cursors.C0] := Round(FH.NumSamples*0.1) ;
           Cursors.C1 := scDisplay.AddVerticalCursor(AllChannels,clOlive,'?t1') ;
           scDisplay.VerticalCursors[Cursors.C1] := Round(FH.NumSamples*0.9) ;
           scDisplay.LinkVerticalCursors( Cursors.C0, Cursors.C1 ) ;

           Cursors.R := scDisplay.AddVerticalCursor(AllChannels,clGreen,'?t?y') ;
           scDisplay.VerticalCursors[Cursors.R] := FH.NumSamples div 2 ;

           scDisplay.VerticalCursors[Cursors.T0] := 0 ;
           KeepCursors := False ;
           end ;


        NewSummaryNeeded := True ;
        NewTableNeeded := True ;
        HistogramLimitsNeeded := True ;

        FH.RecordNum := 1 ;
        UpdateScrollBar( sbRecordNum, FH.RecordNum, 1, fH.NumRecords ) ;

        DisplayRecord ;

        end
     else Close ;

     end;


procedure TFitFrm.NewVariableNames(
          FitCh : Integer ;
          EqnType : TEqnType
          ) ;
{ ---------------------------------
  Create new set of variable names
  --------------------------------}
var
   Par,ch,jVar,OldIndex : Integer ;
begin

     VarNames.Clear ;
     ClearCheckBoxCaptions ;

     VarName[vRecord] := 'Record' ;
     VarNames.AddObject( VarName[vRecord], TObject(vRecord) ) ;
     Units[vRecord] := ' ' ;
     SetCheckBoxCaption(vRecord ) ;

     VarName[vGroup] := 'Group' ;
     VarNames.AddObject( VarName[vGroup], TObject(vGroup) ) ;
     Units[vGroup] := ' ' ;
     SetCheckBoxCaption(vGroup ) ;

     VarName[vTime] := 'Time' ;
     VarNames.AddObject( VarName[vTime], TObject(vTime) ) ;
     Units[vTime] := 's' ;
     SetCheckBoxCaption(vTime ) ;

     { Equation parameters }
     Func.Setup( EqnType,
                 Settings.TUnits,
                 Channel[FitCh].ADCUnits ) ;

     { Set function parameter variables }
     for Par := 0 to Func.NumParameters-1 do begin
         jVar := Par*MaxAnalysisVariables + vFitPar ;
         VarName[jVar] := Func.ParNames[Par] ;
         VarNames.AddObject( VarName[jVar],
                             TObject(jVar)) ;
         Units[jVar] := Func.ParUnits[Par] ;
         SetCheckBoxCaption(jVar) ;
         end ;

     { Averages within limits cursor (for ALL channels except the fitting one) }

     for ch := 0 to FH.NumChannels-1 do begin
         if ch <> FitCh then begin
            jVar := ch*MaxAnalysisVariables + vFitAvg ;
            VarName[jVar] := ' Avg. (' + Channel[ch].ADCName + ')' ;
            VarNames.AddObject( VarName[jVar],
                                TObject(jVar)) ;
            Units[jVar] := Channel[ch].ADCUnits ;
            SetCheckBoxCaption(jVar ) ;
            end ;
         end ;

     { Residual standard deviation }
     VarName[vFitResSD] := 'ResSD' ;
     VarNames.AddObject( VarName[vFitResSD], TObject(vFitResSD)) ;
     Units[vFitResSD] := Channel[cbFitChannel.ItemIndex].ADCUnits ;
     SetCheckBoxCaption(vFitResSD ) ;

     { Degrees of freedom }
     VarName[vFitDegF] := 'DegF' ;
     VarNames.AddObject( VarName[vFitDegF], TObject(vFitDegF)) ;
     Units[vFitDegF] := '' ;
     SetCheckBoxCaption(vFitDegF ) ;

     { Create variable name list for X/Y plot }
     OldIndex := cbXVariable.ItemIndex ;
     cbXVariable.items := VarNames  ;
     cbXVariable.ItemIndex := Min(Max(0,OldIndex),cbXVariable.Items.Count-1) ;

     OldIndex := cbYVariable.ItemIndex ;
     cbYVariable.items := VarNames  ;
     cbYVariable.ItemIndex := Min(Max(0,OldIndex),cbYVariable.Items.Count-1) ;

     OldIndex := cbHistVariable.ItemIndex ;
     cbHistVariable.items := VarNames  ;
     cbHistVariable.ItemIndex := Min(Max(0,OldIndex),cbHistVariable.Items.Count-1) ;

     end ;


procedure TFitFrm.DisplayRecord ;
{ ========================================================
  Display digitised signal record on Page 0 of notebook
  ========================================================}
var
   i,j,jTo,jFrom,jEnd,ch : Integer ;
   y,t : single ;
begin

     if ADC  = Nil then Exit ;

     { Set record no. slider bar and text box }
     sbRecordNum.Max := fH.NumRecords ;
     sbRecordNum.Min := 1 ;
     sbRecordNum.Enabled := True ;
     fH.RecordNum := SbRecordNum.position ;
     fH.CurrentRecord := SbRecordNum.position ;

     edRecordNum.LoValue := SbRecordNum.position ;
     edRecordNum.HiValue := fH.NumRecords ;

     { Read record data from file }
     GetRecord( fH, RH, fH.RecordNum, ADC^ ) ;

     { Move A/D samples to be fitted to first channel in scDisplay }
     jFrom := Channel[cbFitChannel.ItemIndex].ChannelOffset ;
     jTo := ChData ;
     jEnd := (FH.NumSamples-1)*FH.NumChannels ;
     if FH.NumSamples <= ((High(DispBuf^)+1) div 2) then nDisplaySkip := 1
                                                    else nDisplaySkip := 2 ;
    nDisplaySkip := 1 ;
     while jFrom < jEnd do begin
         DispBuf^[jTo] := ADC^[jFrom] ;
         jFrom := jFrom + FH.NumChannels*nDisplaySkip ;
         jTo := jTo + NumFitChannels ;
         end ;

     scDisplay.MaxPoints := FH.NumSamples div nDisplaySkip ;
     scDisplay.NumPoints := scDisplay.MaxPoints ;
     scDisplay.TScale := RH.dt*Settings.TScale ;
     scDisplay.SetDataBuf( DispBuf ) ;

     { Set vertical cursors }
     if (RH.EqnType <> None) and
        (RH.FitCursor1 <> RH.FitCursor2) then begin
        { Set cursors to positions used to compute fit }
        scDisplay.VerticalCursors[Cursors.T0] := RH.FitCursor0 div nDisplaySkip ;
        scDisplay.VerticalCursors[Cursors.C0] := RH.FitCursor1 div nDisplaySkip  ;
        scDisplay.VerticalCursors[Cursors.C1] := RH.FitCursor2 div nDisplaySkip  ;
        end
     else if rbAutoCursors.Checked then begin
        { Find waveform and set cursors to rise/decay as required }
        SetFittingDataCursors ;
        end
    else if (scDisplay.VerticalCursors[Cursors.C0]
             = scDisplay.VerticalCursors[Cursors.C1]) or
            (scDisplay.VerticalCursors[Cursors.C0] >= scDisplay.NumPoints) or
            (scDisplay.VerticalCursors[Cursors.C1] >= scDisplay.NumPoints)
            then begin
        { Cursor data is invalid, set to default settings }
        scDisplay.VerticalCursors[Cursors.T0] := 0 ;
        scDisplay.VerticalCursors[Cursors.C0] := 10 ;
        scDisplay.VerticalCursors[Cursors.C1] := scDisplay.NumPoints - 10 ; ;
        end ;

     { Set horizontal cursors }
     scDisplay.HorizontalCursors[Cursors.Base[ChData]] :=
                                               Channel[RH.FitChan].ADCZero ;
     // Start of area from which zero level was computed (-1 indicates fixed zero level)
     scDisplay.ChanZeroAt[ChData] := Channel[RH.FitChan].ADCZeroAt ;
     scDisplay.ChanZeroAvg := FH.NumZeroAvg ;

     scDisplay.HorizontalCursors[Cursors.Base[ChRes]] := 0 ;

     { Make sure display scaling factor is same as for channel }
     scDisplay.ChanScale[ChData] := Channel[RH.FitChan].ADCScale ;
     scDisplay.ChanScale[ChRes] := Channel[RH.FitChan].ADCScale ;

     { Show whether record has been rejected by operator }
     if RH.Status = 'ACCEPTED' then ckBadRecord.checked := False
                                else ckBadRecord.checked := True ;
     { Show type of record }
     if cbRecordType.items.indexOf(RH.RecType) >= 0 then
     cbRecordType.ItemIndex := cbRecordType.items.indexOf(RH.RecType);

     { Display parameters of fitted equation }
     Results.Clear ;
     erResults.Clear ;

     { Create best fit line }
     scDisplay.CreateLine( ChData, clRed, psSolid, 1 ) ;
     { Set residuals to zero }
     jTo := ChRes ;
     for i := 0 to scDisplay.NumPoints-1 do begin
         DispBuf^[jTo] := 0 ;
         jTo := jTo + NumFitChannels ;
         end ;

     if RH.EqnType <> None then begin

        { Draw fitted line on record }
        Func.Setup( RH.EqnType,
                    Settings.TUnits,
                    Channel[RH.FitChan].ADCUnits ) ;

        for i := 0 to Func.NumParameters-1 do begin
            Func.Parameters[i] := RH.Value[i*MaxAnalysisVariables + vFitPar] ;
            end ;

        NewVariableNames( RH.FitChan, RH.EqnType)  ;

        t := 0.0 ;
        j := 0 ;
        for i := 0 to scDisplay.NumPoints-1 do begin
            if i >= scDisplay.VerticalCursors[Cursors.T0] then begin
               y := (Func.Value(t)/Channel[RH.FitChan].ADCScale)
                    + Channel[RH.FitChan].ADCZero ;
               { Draw fitted line over data }
               scDisplay.AddPointToLine( i, y ) ;
               t := t + RH.dt*nDisplaySkip*Settings.TScale ;
               { Compute residual }
               DispBuf^[j+ChRes] := Round(y) - DispBuf^[j+ChData] ;
               end
            else ADC^[j+ChRes] := 0 ;
            j := j + NumFitChannels ;
            end ;

        Results.Add( Func.Name ) ;

        { Best fit parameters and standard error }
        for i := 0 to Func.NumParameters-1 do begin
            if RH.Value[i*MaxAnalysisVariables+vFitParSD] >= 0.0 then
               Results.Add( format(' %s = %.4g ^~ %.4g (sd) %s',
                                           [Func.ParNames[i],
                                            RH.Value[i*MaxAnalysisVariables+vFitPar],
                                            RH.Value[i*MaxAnalysisVariables+vFitParSD],
                                            Func.ParUnits[i]] ) )
            else
               { fixed parameter }
               Results.Add( format(' %s = %.4g (fixed) %s',
                                           [Func.ParNames[i],
                                            RH.Value[i*MaxAnalysisVariables+vFitPar],
                                            Func.ParUnits[i]] ) ) ;
            end ;

        { Residual standard deviation }
        Results.Add( format(' Residual S.D. = %.4g %s',
                             [RH.Value[vFitResSD],
                              Units[vFitResSD]])) ;
        { Statistical degrees of freedom }
        Results.Add( format(' Degrees of freedom = %d ',
                             [Round(RH.Value[vFitDegF])]) ) ;
        { No. of iterations }
        Results.Add( format(' No. of iterations = %d ',
                             [Round(RH.Value[vFitNumIterations])]) ) ;

        { Averages from other channels }
        for ch := 0 to fH.NumChannels-1 do if ch <> RH.FitChan then
            Results.Add( format('Avg. %s %.4g %s',
                                    [Channel[ch].ADCName,
                                     RH.Value[MaxAnalysisVariables*ch + VFitAvg],
                                     Channel[ch].ADCUnits] ) ) ;

        end
     else begin
        RH.FitChan := cbFitChannel.ItemIndex ;
        Results.Add( 'No Fit' ) ;
        end ;

     Func.CopyResultsToRichEdit( Results, erResults ) ;

     end ;


procedure TFitFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
     scDisplay.MaxADCValue := FH.MaxADCValue ;
     scDisplay.MinADCValue := FH.MinADCValue ;
     scDisplay.DisplayGrid := Settings.DisplayGrid ;
     scDisplay.Invalidate ;
     end ;


procedure  TFitFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := FH.MaxADCValue ;
     scDisplay.MinADCValue := FH.MinADCValue ;
     scDisplay.ZoomOut ;
     end ;


procedure TFitFrm.bDoFitClick(Sender: TObject);
{ -------------------
  Start curve fitting
  -------------------}
var
   Rec,StartAtRec,EndAtRec,iStart,iEnd,yZero,TZero : Integer ;
   i,j,ch,ChFit,nFit,iSkip,iStep,NumFitted : Integer ;
   x,dx,Sum : single ;
   FitData : PXYData ;
   Average : Array[0..WCPMaxChannels-1] of Single ;
   OK,Done : Boolean ;

begin

  New( FitData ) ;

  bDoFit.enabled := False ;
  bAbort.enabled := True ;
  sbRecordNum.Enabled := False ;
  Screen.cursor := crHourGlass ;
  NumFitted := 0 ;

  { -- Set range of records to be fitted -- }

  if rbAllRecords.checked then begin
        { Analyse all records in file }
        StartAtRec := 1 ;
        EndAtRec := FH.NumRecords ;
        end
  else if rbThisRecord.checked then begin
        { Analyse the currently displayed record }
        StartAtRec := FH.RecordNum ;
        EndAtRec := FH.RecordNum ;
        end
  else begin
        StartAtRec := Round(edRecRange.LoValue) ;
        EndAtRec := Round(edRecRange.HiValue) ;
        end ;

  Try

     OK := True ;
     { -- Select type of equation to be fitted -- }
     Func.Setup( TEqnType(cbEquation.Items.Objects[cbEquation.ItemIndex]),
                 Settings.TUnits,
                 Channel[cbFitChannel.ItemIndex].ADCUnits ) ;

     { Fit curve to all records in selected range }
     Rec := StartAtRec ;
     Done := False ;
     NumFitted := 0 ;
     while not Done do begin

           OK := True ;

           { Read record data from file }
           GetRecord( fH, RH, Rec, ADC^ ) ;

           { Fit curve if record meets selection criteria }
           if UseRecord(RH,cbTypeToBeAnalysed.text) then begin

              { Position fitting region cursors }
              if rbAutoCursors.checked then SetFittingDataCursors ;

              { Get range of samples to be fitted from positions of cursors 0 and 1 }
              iStart := nDisplaySkip*Min( scDisplay.VerticalCursors[Cursors.C0],
                                          scDisplay.VerticalCursors[Cursors.C1] ) ;
              iEnd :=   nDisplaySkip*Max( scDisplay.VerticalCursors[Cursors.C0],
                                          scDisplay.VerticalCursors[Cursors.C1] ) ;

              { Calculate average of data within cursors for each channel }
              for ch := 0 to fh.NumChannels-1 do begin
                  Sum := 0. ;
                  for i := iStart to iEnd do begin
                      j := i*fH.NumChannels + Channel[ch].ChannelOffset ;
                      Sum := Sum + ADC^[j] ;
                      end ;
                  Average[ch] := Channel[ch].ADCScale *
                                ( Sum /(iEnd-iStart+1) - Channel[ch].ADCZero ) ;
                  end ;

              { Copy data points into fitting array
              (if necessary miss points to make it fit) }
              nFit := 0 ;
              i := iStart ;
              ChFit := cbFitChannel.ItemIndex ;
              yZero := Channel[ChFit].ADCZero ;
              TZero := nDisplaySkip*scDisplay.VerticalCursors[Cursors.T0] ;
              repeat
                  FitData^.x[nFit] := (i - TZero)*RH.dt*Settings.TScale ;
                  j := i*fH.NumChannels + Channel[ChFit].ChannelOffset ;
                  FitData^.y[nFit] := ( ADC^[j] - yZero ) * Channel[ChFit].ADCScale ;
                  Inc(i) ;
                  if nFit < High(FitData^.x) then Inc(nFit) ;
                  until i > iEnd ;

              { Skip fit if not enough data points }
              if nFit < Func.NumParameters then begin
                 ShowMessage( format('%d points is insufficient for fit',[nFit]));
                 OK := False ;
                 end ;

              { Fit curve using non-linear regression }
              if OK then begin

                 { Create an initial set of guesses for parameters }
                 if not Func.ParametersSet then begin
                    for i := 0 to Func.NumParameters-1 do
                        if not Func.FixedParameters[i] then begin
                        Func.Parameters[i] := Func.InitialGuess(FitData^,nFit,i) ;
                        end ;
                    end ;

                 Func.UseBinWidths := False ;
                 Try Func.FitCurve( FitData^, nFit )
                 Except
                 end ;
                 OK :=  Func.GoodFit ;
                 Func.ParametersSet := False ;
                 end ;

              { Update record header block with results }
              if OK and (Func.Equation <> None) then begin
                 { Get best-fit parameters/stdev etc }
                 RH.EqnType := TEqnType(cbEquation.Items.Objects[cbEquation.ItemIndex]) ;
                 { Fitted data limits }
                 RH.FitCursor0 := TZero ;
                 RH.FitCursor1 := iStart ;
                 RH.FitCursor2 := iEnd ;
                 { Channel fitted }
                 RH.FitChan := cbFitChannel.ItemIndex ;
                 RH.Value[vFitResSD] := Func.ResidualSD ;
                 RH.Value[vFitDegF] := Func.DegreesOfFreedom ;
                 RH.Value[vFitNumIterations] := Func.Iterations ;

                 for i := 0 to Func.NumParameters-1 do begin
                     RH.Value[i*MaxAnalysisVariables + vFitPar] := Func.Parameters[i] ;
                     if not Func.FixedParameters[i] then begin
                        RH.Value[i*MaxAnalysisVariables + vFitParSD] := Func.ParameterSDs[i] ;
                        end
                     else begin
                        RH.Value[i*MaxAnalysisVariables + vFitParSD] := -1.0 ;
                        end ;
                     end ;

                 { Average of other channels }
                 for ch := 0 to FH.NumChannels-1 do begin
                     RH.Value[ch*MaxAnalysisVariables+vFitAvg] := Average[Ch] ;
                     end ;
                 // Increment records fitted counter
                 Inc(NumFitted) ;
                 end
              else begin
                 RH.EqnType := None ;
                 end ;

              { Save record header containing analysis results back to file  }
              PutRecordHeaderOnly( fH, RH, Rec ) ;

              { Display fitted curve }
              if OK then begin
                 SbRecordNum.position := Rec ;
                 DisplayRecord ;
                 end
              else begin
                 erResults.Clear ;
                 erResults.Lines.Add('No Fit') ;
                 end ;

              end ;

           // Report progress
           Main.StatusBar.SimpleText := Format( 'Curve Fit : Fitting %d/%d',
                                                [Rec,EndAtRec] ) ;

           { Exit the loop when the last record has been done
           or the user has pressed the abort button (DoFit.Enabled=True) }
           Inc(Rec) ;
           if (Rec > EndAtRec) or bDoFit.Enabled then Done := True ;

           Application.ProcessMessages ;
           end ;

     finally

        Dispose(FitData) ;
        bDoFit.enabled := True ;
        bAbort.enabled := False ;
        sbRecordNum.Enabled := True ;
        Screen.cursor := crDefault ;
        NewSummaryNeeded := True ;

        // Final report
        Main.StatusBar.SimpleText := Format( 'Curve Fit : %d-%d (%d fitted)',
                                             [StartAtRec,EndAtRec,NumFitted] ) ;


        end ;

     end;


procedure TFitFrm.bSetParametersClick(Sender: TObject);
{ -----------------------------------------------
  Set initial parameter guesses / fix parameters
  ----------------------------------------------- }
var
   i,iStart,iEnd,j,nPoints,ChOffset,iStep,FitCh : Integer ;
   Data : PXYData ;
begin

     New(Data) ;

     try

        { Read record data from file }
        GetRecord( fH, RH, sbRecordNum.Position, ADC^ ) ;

        FitCh := cbFitChannel.ItemIndex ;
        Func.Setup( TEqnType(cbEquation.Items.Objects[cbEquation.ItemIndex]),
                    Settings.TUnits,
                    Channel[FitCh].ADCUnits ) ;

        { Get range of samples to be fitted from positions of cursors 0 and 1 }
        iStart := Min( scDisplay.VerticalCursors[Cursors.C0],
                       scDisplay.VerticalCursors[Cursors.C1] ) ;
        iEnd :=   Max( scDisplay.VerticalCursors[Cursors.C0],
                       scDisplay.VerticalCursors[Cursors.C1] ) ;

        { Copy data points into fitting array }
        nPoints := 0 ;
        ChOffset := Channel[FitCh].ChannelOffset ;
        iStep := Max(((iEnd - iStart) + High(Data^.x)+1) div (High(Data^.x)+1),1) ;
        i := iStart ;
        repeat
            Data^.x[nPoints] := (i - scDisplay.VerticalCursors[Cursors.T0]) * RH.dt*Settings.TScale ;
            j := i*fH.NumChannels + ChOffset ;
            Data^.y[nPoints] := ADC^[j] ;
            Data^.y[nPoints] := ( Data^.y[nPoints] - Channel[FitCh].ADCZero )
                                * Channel[FitCh].ADCScale ;
            i := i + iStep ;
            if nPoints < High(Data^.x) then Inc(nPoints) ;
            until i >= iEnd ;

        { Let user modify initial parameter settings
        and/or fix parameters at constant values }
        SetFitParsFrm.MathFunc := Func ;
        SetFitParsFrm.XYData := Data ;
        SetFitParsFrm.NumPoints := nPoints ;
        SetFitParsFrm.ShowModal ;
        if SetFitParsFrm.ModalResult = mrOK then begin
           Func := SetFitParsFrm.MathFunc ;
           Func.ParametersSet := True ;
           end ;

     finally
        Dispose(Data) ;
        end ;

     end;


procedure TFitFrm.SetFittingDataCursors ;
{ -------------------------------------------------------
  Automatically define the range of sample points to be used in the curve fit
  by finding the location of a transient within the record
  and placing cursors on the rising or decay phase or the whole transient
  -----------------------------------------------------------------------}
var
   y,yPeak,i,j,iPeak,MakePositive,yHi,yLo,yZero,ChFit : Integer ;
   RiseStart,RiseEnd,DecayStart,DecayEnd : Integer ;
begin

     ChFit := cbFitChannel.ItemIndex ;
     yZero := scDisplay.HorizontalCursors[Cursors.Base[ChData]] ;

     { Find the location of the peak of the transient }
     yPeak := 0 ;
     iPeak := 0 ;
     for i := scDisplay.xMin to scDisplay.xMax-1 do begin
         j := i*FH.NumChannels + ChFit ;
         y := ADC^[j] - yZero ;
         if Abs(y) > Abs(yPeak) then begin
            yPeak := y ;
            iPeak := i ;
            end ;
         end ;

     { If the waveform is negative-going ... invert it for processing }
     if yPeak > 0 then MakePositive := 1
                  else MakePositive := -1 ;

     { Get the amplitude limits of the data to be used in the fit
       Default is 5%-95% of peak amplitude }

     yLo := Round( yPeak*MakePositive*Abs(edLimits.LoValue) );
     yHi := Round( yPeak*MakePositive*Abs(edLimits.HiValue) ) ;

     { Find decay phase of waveform }
     DecayEnd := iPeak ;
     DecayStart := iPeak ;
     repeat
         j := DecayEnd*FH.NumChannels + ChFit ;
         y := (ADC^[j] - yZero)*MakePositive ;
         if y >= yHi then DecayStart := DecayEnd ;
         Inc(DecayEnd) ;
         until (y < yLo) or (DecayEnd >= (scDisplay.NumPoints-1)) ;

     { Find rising phase of waveform }
     RiseEnd := iPeak ;
     RiseStart := iPeak ;
     repeat
         j := RiseStart*FH.NumChannels + ChFit ;
         y := (ADC^[j] - yZero)*MakePositive ;
         if y >= yHi then RiseEnd := RiseStart ;
         Dec(RiseStart) ;
         until (y < yLo) or (RiseStart <= 0) ;

    if cbDataLimitCursors.text = 'On Rise' then begin
       { Place cursors on rising phase of waveform }
       scDisplay.VerticalCursors[Cursors.C0] := RiseStart ;
       scDisplay.VerticalCursors[Cursors.C1] := RiseEnd ;
       scDisplay.VerticalCursors[Cursors.T0] := RiseStart ;
       end
    else if cbDataLimitCursors.text = 'On Decay' then begin
       { Place cursors on decay phase of waveform }
       scDisplay.VerticalCursors[Cursors.C0] := DecayStart ;
       scDisplay.VerticalCursors[Cursors.C1] := DecayEnd ;
       scDisplay.VerticalCursors[Cursors.T0] := iPeak ;
       end
    else begin
       { Place cursors on whole waveform }
       scDisplay.VerticalCursors[Cursors.C0] := RiseStart ;
       scDisplay.VerticalCursors[Cursors.C1] := DecayEnd ;
       scDisplay.VerticalCursors[Cursors.T0] := RiseStart ;
       end ;
    end ;



procedure TFitFrm.bAbortClick(Sender: TObject);
{ -------------------
  Abort curve fitting
  -------------------}
begin
     bDoFit.enabled := True ;
     end;


{ **** X/Y PLOT METHODS ******************************************** }


procedure TFitFrm.bNewXYPlotClick(Sender: TObject);
{ --------------------
  Create an X/Y Plot
  -------------------}
var
   Rec,StartAtRec,EndAtRec,xVar,yVar : Integer ;
   x,y : Single ;
begin

     bNewXYPlot.Enabled := False ;
     Main.StatusBar.SimpleText := 'Curve Fitting: Plotting graph.' ;

     { Plot graph of currently selected variables }
     plPlot.xAxisAutoRange := True ;
     plPlot.yAxisAutoRange := True ;
     plPlot.MaxPointsPerLine := Round(edPlotRange.HiValue - edPlotRange.LoValue) + 1 ;

     { Get channel and variables to be plotted }
     XVar := Integer(cbXVariable.Items.Objects[cbXVariable.ItemIndex]) ;
     YVar := Integer(cbYVariable.Items.Objects[cbYVariable.ItemIndex]) ;

     { Clear data points line }
     plPlot.CreateLine( 0 , clBlue, msOpenSquare, psSolid ) ;

     StartAtRec := Round(edPlotRange.LoValue) ;
     EndAtRec := Round(edPlotRange.HiValue ) ;
     for Rec := StartAtRec to EndAtRec do begin
         { Read record analysis block from file }
         GetRecordHeaderOnly( fH, RH, Rec ) ;
         { Add to plot if selected and valid }
         if UseRecord(RH,cbTypeToBeAnalysed.text) and (RH.EqnType <> None) then begin
            x := RH.Value[XVar] ;
            y := RH.Value[YVar] ;
            plPlot.AddPoint(0, x, y ) ;
            end ;
         end ;
     plPlot.SortByX( 0 ) ;

     { Create X and Y axes labels }
     plPlot.xAxisLabel := '' ;
     if xVar > vTime then plPlot.xAxisLabel := Channel[RH.FitChan].ADCName + ' ';
     plPlot.xAxisLabel := plPlot.xAxisLabel + VarName[xVar]
                          + ' ' + Units[xVar] ;
     plPlot.yAxisLabel := '' ;
     if yVar > vTime then plPlot.yAxisLabel := Channel[RH.FitChan].ADCName + ' ';
     plPlot.yAxisLabel := plPlot.yAxisLabel + VarName[yVar]
                          + ' ' + Units[yVar] ;

     { Create readout cursors for X/Y plot }
     plPlot.ClearVerticalCursors ;
     Cursors.PlotRead := plPlot.AddVerticalCursor( Settings.Colors.Cursors, '?r',0 ) ;
     plPlot.VerticalCursors[Cursors.PlotRead] := 0.5*(plPlot.xAxisMin + plPlot.xAxisMax) ;

     bNewXYPlot.Enabled := True ;
     Main.StatusBar.SimpleText := 'Curve Fitting: Plotting graph.' ;

     end;


procedure TFitFrm.SelectEquation(
          var FitCh : Integer ;
          var EqnType : TEqnType
          ) ;
{ ------------------------------------------------------
  Find first usable equation with range selected for use
  ------------------------------------------------------ }
var
   Rec,StartAtRec,EndAtRec : Integer ;
   Done : Boolean ;
begin

    StartAtRec := Round(edPlotRange.LoValue) ;
    EndAtRec := Round(edPlotRange.HiValue ) ;
    { Ensure that equation type and channel defined if no equation found }
    EqnType := None ;
    FitCh := 0 ;

    Rec := StartAtRec ;
    Done := False ;
    While not Done do begin
       GetRecordHeaderOnly( fH, RH, Rec ) ;
       if UseRecord(RH,cbTypeToBeAnalysed.text) and (RH.EqnType <> None)
          or (Rec > EndAtRec) then begin
          EqnType := RH.EqnType ;
          FitCh := RH.FitChan ;
          Done := True ;
          end ;
       Inc(Rec) ;
       if Rec > EndAtRec then Done := True ;
       end ;

    end ;



procedure TFitFrm.bSetPlotAxesClick(Sender: TObject);
{ ------------------------------
  Set plot axes range/law/labels
  ------------------------------}
begin
     SetAxesFrm.Plot := plPlot ;
     SetAxesFrm.Histogram := False ;
     SetAxesFrm.ShowModal ;
     end;


{ **** HISTOGRAM METHODS ******************************************** }


procedure TFitFrm.bNewHistogramClick(Sender: TObject);
{ -------------------------------------
  Request a new histogram to be plotted
  -------------------------------------}
var
   i,HistCh,HistVar,Rec,RecStart,RecEnd : Integer ;
   x,HScale,HLowerLimit : single ;
   EqnType : TEqnType ;
begin

     Screen.Cursor := crHourglass ;

     SelectEquation( HistCh, EqnType ) ;

     { Calculate summary data for all channels so that a suitable
     initial histogram range can be supplied for the user }
     if NewSummaryNeeded then FillSummaryTable ;

     { Determine records, channels & variables to be plotted }
     HistVar := Integer(cbHistVariable.Items.Objects[cbHistVariable.ItemIndex]) ;

     if edHistMax.Value <= edHistMin.Value then Exit ;

     { Clear Histogram }
     x := edHistMin.Value ;
     Hist.NumBins := Round( EdNumBins.Value ) ;
     Hist.BinWidth := (edHistMax.Value - x )/Hist.NumBins ;
     for i := 0 to Hist.NumBins-1 do begin
         Hist.Bins[i].lo := x ;
         Hist.Bins[i].Mid := x + Hist.BinWidth / 2. ;
         Hist.Bins[i].Hi := x + Hist.BinWidth ;
         Hist.Bins[i].y := 0. ;
         x := x + Hist.BinWidth ;
         end ;

     { Fill histogram }
     HScale := (Hist.NumBins) / ( Hist.Bins[Hist.NumBins-1].Mid
                                         - Hist.Bins[0].Mid ) ;
     HLowerLimit := Hist.Bins[0].Lo ;

     RecStart := Round( edPlotRange.LoValue ) ;
     RecEnd := Round( edPlotRange.HiValue ) ;
     Screen.Cursor := crHourglass ;
     for Rec := RecStart to RecEnd do begin
            { Read record analysis block from file }
            GetRecordHeaderOnly( fH, RH, Rec ) ;
            if UseRecord( RH, cbTypeToBeAnalysed.text )
               and (RH.EqnType <> None) then begin
               x := RH.Value[HistVar] ;
               i := Round( (x - HLowerLimit) * HScale ) ;
               i := Max( Min( i,Hist.NumBins-1 ), 0 ) ;
               Hist.Bins[i].y := Hist.Bins[i].y + 1. ;
               if Hist.Bins[i].y > Hist.yHi then Hist.yHi := Hist.Bins[i].y ;
               end ;
            end ;


     { Plot new histogram }
     plHist.xAxisAutoRange := False ;
     plHist.xAxisMin := Hist.Bins[0].Lo ;
     plHist.xAxisMax := Hist.Bins[Hist.NumBins-1].Hi ;
     plHist.XAxisTick := (plHist.xAxisMax - plHist.xAxisMin) / 5.0 ;

     plHist.HistogramCumulative := ckCumulative.Checked ;
     plHist.HistogramPercentage := ckPercentage.Checked ;

     { Create X and Y axes labels }
     plHist.xAxisLabel := '' ;
     if HistVar > vTime then plHist.xAxisLabel := Channel[HistCh].ADCName + ' ';
     plHist.xAxisLabel := plHist.xAxisLabel + VarName[HistVar]
                          + ' ' + Units[HistVar] ;

     plHist.yAxisAutoRange := True ;
     if ckPercentage.Checked then plHist.yAxisLabel := '%'
                             else plHist.yAxisLabel := ' ' ;

     { Create histogram plot }
     plHist.CreateHistogram( 0 ) ;
     for i := 0 to Hist.NumBins-1 do plHist.AddBin( 0,
                                     Hist.Bins[i].Lo,
                                     Hist.Bins[i].Mid,
                                     Hist.Bins[i].Hi,
                                     Hist.Bins[i].y ) ;

     { Create readout cursors }
     plHist.ClearVerticalCursors ;
     Cursors.HistRead := plHist.AddVerticalCursor( Settings.Colors.Cursors, '?r',0 ) ;
     plHist.VerticalCursors[Cursors.HistRead] := Hist.Bins[Hist.NumBins div 2].Mid ;

     Screen.Cursor := crDefault ;
     end;


procedure TFitFrm.cbHistVariableChange(Sender: TObject);
begin
   SetDefaultHistogramLimits ;
   end ;



procedure TFitFrm.SetDefaultHistogramLimits ;
{ -----------------------------------------------------------
  Set up default histogram range for selected variable/channel
  ------------------------------------------------------------ }
var
   iVar : Integer ;
begin

   if NewSummaryNeeded then FillSummaryTable ;

   iVar := Integer(cbHistVariable.Items.Objects[cbHistVariable.ItemIndex]) ;

   edHistMin.Units := Units[iVar] ;
   edHistMax.Units := Units[iVar] ;

   if NumRecordsAnalysed > 0 then begin
      edHistMin.Value := MinValue[iVar] ;
      edHistMax.Value := MaxValue[iVar] ;
      end ;

   HistogramLimitsNeeded := False ;
   end;


procedure TFitFrm.bSetHistAxesClick(Sender: TObject);
{ -----------------------------
  Customise histogram plot axes
  -----------------------------}
begin
     SetAxesFrm.Plot := plHist ;
     SetAxesFrm.Histogram := True ;
     SetAxesFrm.ShowModal ;
     end;


{ **** SUMMARY TABLE METHODS ******************************************** }


procedure TFitFrm.CalculateSummary ;
{ ========================================================
  Calculate summary of curve fit results held in file
  ========================================================}
var
   Rec,RecStart,RecEnd,FitCh,iVar,jVar,n : Integer ;
   y : Single ;
   EqnType : TEqnType ;
begin

     screen.cursor := crHourGlass ;

     { Determine record range/channels to be plotted }
     RecStart := Round(edPlotRange.LoValue) ;
     RecEnd := Round(edPlotRange.HiValue) ;

     { Use type of first valid equation in analysis range }
     SelectEquation( FitCh, EqnType ) ;

     { Initialise summary variables }
     for iVar := 0 to NumVariables-1 do begin
         jVar := GetCheckBoxVariableNumber(iVar) ;
         MaxValue[jVar] := -MaxSingle ;
         MinValue[jVar] := MaxSingle ;
         Mean[jVar] := 0. ;
         StDev[jVar] := 0. ;
         StErr[jVar] := 0. ;
         NumRecordsAnalysed := 0 ;
         end ;

     { Update Min/Max range of values in file }
     for Rec := RecStart to RecEnd do begin

         { Get record header containing analysis results }
         GetRecordHeaderOnly( fH, RH, Rec ) ;

         { Add record to analysis (if valid and of selected type }
         if UseRecord( RH, cbTypeToBeAnalysed.text ) then begin
            for iVar := 0 to NumVariables-1 do begin
                jVar := GetCheckBoxVariableNumber(iVar) ;
                { Min./Max. values }
                if MaxValue[jVar] < RH.Value[jVar] then
                   MaxValue[jVar] := RH.Value[jVar] ;
                if MinValue[jVar] > RH.Value[jVar] then
                   MinValue[jVar] := RH.Value[jVar] ;
                { Mean }
                Mean[jVar] := Mean[jVar] + RH.Value[jVar] ;
                end ;
            Inc(NumRecordsAnalysed) ;
            end ;

         end ;

     { Calculate mean value for each variable}
     n := Max( NumRecordsAnalysed, 1 ) ;
     for iVar := 0 to NumVariables-1 do begin
         jVar := GetCheckBoxVariableNumber(iVar) ;
         Mean[jVar]:= Mean[jVar]/n ;
         end ;

     { Re-read the analysis blocks to get residual deviations from mean }
     for Rec := RecStart to RecEnd do begin
         GetRecordHeaderOnly( fH, RH, Rec ) ;
         if UseRecord(RH,cbTypeToBeAnalysed.text) then begin
            for iVar := 0 to NumVariables-1 do begin
                jVar := GetCheckBoxVariableNumber(iVar) ;
                y := RH.Value[jVar] - Mean[jVar] ;
                StDev[jVar] := StDev[jVar] + y*y ;
                end ;
            end ;
         end ;

     { Calculate standard deviation and error for each variable}
     for iVar := 0 to NumVariables-1 do begin
         jVar := GetCheckBoxVariableNumber(iVar) ;
         StDev[jVar]:= sqrt( StDev[jVar] / Max(n - 1,1) ) ;
         StErr[jVar]:= StDev[jVar]/sqrt( n ) ;
         end ;

     screen.cursor := crDefault ;
     NewSummaryNeeded := False ;

     end ;


procedure TFitFrm.FillSummaryTable ;
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
   Row,Col,iVar,jVar,MaxWidth,WidthLimit,TotalWidth,ColWidth : Integer ;
begin

     { Calculate summary data if necessary }
     if NewSummaryNeeded then CalculateSummary ;

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
     for iVar := 0 to NumVariables-1 do begin
         if UseVariableInSummary(iVar) then begin
             jVar := GetCheckBoxVariableNumber(iVar) ;
             Row := Row + 1 ;
             Summary.RowCount := Row + 1 ;
             { Enter row of data }
             Summary.cells[cName,Row]  := VarName[jVar] ;
             if Units[jVar] <> ' ' then
                Summary.cells[cName,Row]  := Summary.cells[cName,Row] + ' (' +
                                             Units[jVar] + ')';
             Summary.cells[cMean,Row]  := format( '%8.4g',
                                          [Mean[jVar]] ) ;
             Summary.cells[cStDev,Row] := format( '%8.4g',
                                          [StDev[jVar]] ) ;
             Summary.cells[cStErr,Row] := format( '%8.4g',
                                          [StErr[jVar]] ) ;
             Summary.cells[cMin,Row]   := format( '%8.4g',
                                          [MinValue[jVar]] ) ;
             Summary.cells[cMax,Row]   := format( '%8.4g',
                                          [MaxValue[jVar]] ) ;
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


procedure TFitFrm.SetCheckBoxCaption(
          VarNum : Integer
          ) ;
{ --------------------------------------
  Set summary check box caption and tag#
  -------------------------------------- }
begin

     case NumVariables of
          0 : begin
            ckVariable0.caption := VarName[VarNum] ;
            ckVariable0.Tag := VarNum ;
            ckVariable0.Visible := True ;
            ckTabVar0.caption := VarName[VarNum] ;
            ckTabVar0.Tag := VarNum ;
            ckTabVar0.Visible := True ;
            end ;
          1 : begin
            ckVariable1.caption := VarName[VarNum] ;
            ckVariable1.Tag := VarNum ;
            ckVariable1.Visible := True ;
            ckTabVar1.caption := VarName[VarNum] ;
            ckTabVar1.Tag := VarNum ;
            ckTabVar1.Visible := True ;
            end ;
          2 : begin
            ckVariable2.caption := VarName[VarNum] ;
            ckVariable2.Tag := VarNum ;
            ckVariable2.Visible := True ;
            ckTabVar2.caption := VarName[VarNum] ;
            ckTabVar2.Tag := VarNum ;
            ckTabVar2.Visible := True ;
            end ;
          3 : begin
            ckVariable3.caption := VarName[VarNum] ;
            ckVariable3.Tag := VarNum ;
            ckVariable3.Visible := True ;
            ckTabVar3.caption := VarName[VarNum] ;
            ckTabVar3.Tag := VarNum ;
            ckTabVar3.Visible := True ;
            end ;
          4 : begin
            ckVariable4.caption := VarName[VarNum] ;
            ckVariable4.Tag := VarNum ;
            ckVariable4.Visible := True ;
            ckTabVar4.caption := VarName[VarNum] ;
            ckTabVar4.Tag := VarNum ;
            ckTabVar4.Visible := True ;
            end ;
          5 : begin
            ckVariable5.caption := VarName[VarNum] ;
            ckVariable5.Tag := VarNum ;
            ckVariable5.Visible := True ;
            ckTabVar5.caption := VarName[VarNum] ;
            ckTabVar5.Tag := VarNum ;
            ckTabVar5.Visible := True ;
            end ;
          6 : begin
            ckVariable6.caption := VarName[VarNum] ;
            ckVariable6.Tag := VarNum ;
            ckVariable6.Visible := True ;
            ckTabVar6.caption := VarName[VarNum] ;
            ckTabVar6.Tag := VarNum ;
            ckTabVar6.Visible := True ;
            end ;
          7 : begin
            ckVariable7.caption := VarName[VarNum] ;
            ckVariable7.Tag := VarNum ;
            ckVariable7.Visible := True ;
            ckTabVar7.caption := VarName[VarNum] ;
            ckTabVar7.Tag := VarNum ;
            ckTabVar7.Visible := True ;
            end ;
          8 : begin
            ckVariable8.caption := VarName[VarNum] ;
            ckVariable8.Tag := VarNum ;
            ckVariable8.Visible := True ;
            ckTabVar8.caption := VarName[VarNum] ;
            ckTabVar8.Tag := VarNum ;
            ckTabVar8.Visible := True ;
            end ;
          9 : begin
            ckVariable9.caption := VarName[VarNum] ;
            ckVariable9.Tag := VarNum ;
            ckVariable9.Visible := True ;
            ckTabVar9.caption := VarName[VarNum] ;
            ckTabVar9.Tag := VarNum ;
            ckTabVar9.Visible := True ;
            end ;
          10 : begin
            ckVariable10.caption := VarName[VarNum] ;
            ckVariable10.Tag := VarNum ;
            ckVariable10.Visible := True ;
            ckTabVar10.caption := VarName[VarNum] ;
            ckTabVar10.Tag := VarNum ;
            ckTabVar10.Visible := True ;
            end ;
          end ;

     Inc(NumVariables) ;

     end ;


procedure TFitFrm.ClearCheckBoxCaptions ;
// ----------------------------
// Clear all check box captions
// ----------------------------
begin

     NumVariables := 0 ;
     ckVariable0.Visible := False ;
     ckVariable1.Visible := False ;
     ckVariable2.Visible := False ;
     ckVariable3.Visible := False ;
     ckVariable4.Visible := False ;
     ckVariable5.Visible := False ;
     ckVariable6.Visible := False ;
     ckVariable7.Visible := False ;
     ckVariable8.Visible := False ;
     ckVariable9.Visible := False ;
     ckVariable10.Visible := False ;
     ckTabVar0.Visible := False ;
     ckTabVar1.Visible := False ;
     ckTabVar2.Visible := False ;
     ckTabVar3.Visible := False ;
     ckTabVar4.Visible := False ;
     ckTabVar5.Visible := False ;
     ckTabVar6.Visible := False ;
     ckTabVar7.Visible := False ;
     ckTabVar8.Visible := False ;
     ckTabVar9.Visible := False ;
     ckTabVar10.Visible := False ;
     end ;


function TFitFrm.GetCheckBoxVariableNumber(
         CheckBoxNum : Integer ) : Integer ;
// ------------------------------------------------------
// Return analysis variable index from variable check box
// ------------------------------------------------------
begin
    case CheckBoxNum of
       0 : Result := ckVariable0.Tag ;
       1 : Result := ckVariable1.Tag ;
       2 : Result := ckVariable2.Tag ;
       3 : Result := ckVariable3.Tag ;
       4 : Result := ckVariable4.Tag ;
       5 : Result := ckVariable5.Tag ;
       6 : Result := ckVariable6.Tag ;
       7 : Result := ckVariable7.Tag ;
       8 : Result := ckVariable8.Tag ;
       9 : Result := ckVariable9.Tag ;
       10 : Result := ckVariable10.Tag ;
       else Result := 0 ;
       end ;
    end ;

function TFitFrm.UseVariableInSummary(
         VarNum : Integer
         ) : Boolean ;
{ ----------------------------------------------------------------------
  Determine whether variable #VarNum is checked for inclusion in summary
  ---------------------------------------------------------------------- }
begin
     case VarNum of
        0 : Result := ckVariable0.Checked ;
        1 : Result := ckVariable1.Checked ;
        2 : Result := ckVariable2.Checked ;
        3 : Result := ckVariable3.Checked ;
        4 : Result := ckVariable4.Checked ;
        5 : Result := ckVariable5.Checked ;
        6 : Result := ckVariable6.Checked ;
        7 : Result := ckVariable7.Checked ;
        8 : Result := ckVariable8.Checked ;
        9 : Result := ckVariable9.Checked ;
        10 : Result := ckVariable10.Checked ;
        else Result := False ;
        end ;

     end ;


function TFitFrm.AddVariableToTable(
         VarNum : Integer
         ) : Boolean ;
{ ----------------------------------------------------------------------
  Determine whether variable #VarNum is checked for inclusion in summary
  ---------------------------------------------------------------------- }
begin
     case VarNum of
        0 : Result := ckTabVar0.Checked ;
        1 : Result := ckTabVar1.Checked ;
        2 : Result := ckTabVar2.Checked ;
        3 : Result := ckTabVar3.Checked ;
        4 : Result := ckTabVar4.Checked ;
        5 : Result := ckTabVar5.Checked ;
        6 : Result := ckTabVar6.Checked ;
        7 : Result := ckTabVar7.Checked ;
        8 : Result := ckTabVar8.Checked ;
        9 : Result := ckTabVar9.Checked ;
        10 : Result := ckTabVar10.Checked ;
        else Result := False ;
        end ;

     end ;



procedure TFitFrm.ckVariable0Click(Sender: TObject);
{ --------------------------------------------------------------
  Refill summary table if a variable selection check box changed
  -------------------------------------------------------------- }
begin
     FillSummaryTable ;
     end;



{ **** DATA TABLE METHODS ******************************************** }


procedure TFitFrm.FillTable ;
{ ===================================================
  Fill table with selected waveform measurement lists
  ===================================================}
var
   StartAt,EndAt,Col,Rec,jVar,FitCh : Integer ;
   EqnType : TEqnType ;
begin

     if NumTableColumns <= 0 then begin
        Table.ColCount := 1 ;
        Table.RowCount := 1 ;
        Table.Cells[0,0] := '' ;
        Exit ;
        end ;

     Table.ColCount := NumTableColumns ;
     Table.RowCount := 2 ;

     { Use type of first valid equation in analysis range }
     SelectEquation( FitCh, EqnType ) ;

     { Create column title }
     for Col := 0 to Table.ColCount-1 do begin
         jVar := TableVars[Col] ;
         Table.cells[Col,0] := VarName[jVar] ;
         case jVar of
              vRecord,vGroup : Table.cells[Col,1] := '' ;
              vTime : Table.cells[Col,1] := '(' + Units[jVar] + ')'
              else begin
                  Table.cells[Col,1] := ' (' + Units[jVar] + ')' ;
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
         if UseRecord( rH, cbTypeToBeAnalysed.text ) and
            ((RH.EqnType = EqnType) or ckIncludeBadFits.Checked) then begin
            { Fill row with selected variables }
            Table.RowCount := Table.RowCount + 1 ;
            for Col := 0 to Table.ColCount-1 do begin
                   jVar := TableVars[Col] ;
                   Table.cells[Col,Table.RowCount-1] := format('%8.4g',
                                                        [rH.Value[jVar]] ) ;
                   end ;
            end ;
         end ;

     { Set width table }
     Table.Width := Page.Width + Page.Left - Table.Left - 30 ;

     Table.FixedRows := Min(2,Table.RowCount-1) ;

     NewTableNeeded := False ;

     end ;


procedure TFitFrm.TableMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Table.Col := Table.MouseCoord( X,Y ).X ;
     end ;


{ **** BUTTON & FORM EVENT HANDLERS ********************************** }


procedure TFitFrm.FormActivate(Sender: TObject);
begin
     { Enable available copy and print menu options when window becomes active }
     ckFixedZeroLevels.Checked := Settings.FixedZeroLevels ;
     DisplayRecord ;
     end;


procedure TFitFrm.ckBadRecordClick(Sender: TObject);
{ ------------------------------------------------
  Save new record ACCEPTED/REJECTED status to file
  ------------------------------------------------}
begin
     if ckBadRecord.checked then RH.Status := 'REJECTED'
                            else RH.Status := 'ACCEPTED' ;
     PutRecordHeaderOnly( fH, RH, fH.RecordNum ) ;
     end;


procedure TFitFrm.edRecordNumKeyPress(Sender: TObject; var Key: Char);
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


procedure TFitFrm.FormClose(Sender: TObject; var Action: TCloseAction);
{ ---------------------------------------------
  Destroy the form to remove it from the screen
  ---------------------------------------------}
begin
     Action := caFree ;
     end;



procedure TFitFrm.FormCreate(Sender: TObject);
// ---------------------------------
// Initialisations when form created
// ---------------------------------
begin
    ADC := Nil ;
    DispBuf := Nil ;
    Hist := THistogram.Create ;
    VarNames := TStringList.Create ;
    Results := TStringList.Create ;
    Func := TMathFunc.Create ;

    end;

procedure TFitFrm.FormDestroy(Sender: TObject);
// ----------------------------
// Tidy up when form destroyed
// ----------------------------
begin
     if ADC <> Nil then FreeMem(ADC) ;
     if DispBuf <> Nil then FreeMem(DispBuf) ;
     Hist.Free ;
     VarNames.Free ;
     Results.Free ;
     Func.Free ;
     end;

procedure TFitFrm.FormResize(Sender: TObject);
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
     erResults.Width := ResultsGrp.Width - erResults.Left - 5 ;

     { Set size of scope display }
     ckFixedZeroLevels.Left := scDisplay.left ;
     ckFixedZeroLevels.Top := ResultsGrp.Top - 5 - ckFixedZeroLevels.Height ;
     scDisplay.Height := Max( ckFixedZeroLevels.Top - scDisplay.Top -1,2) ;
     scDisplay.Width := Max( ResultsGrp.Width,2) ;

     { X/Y Plot page }
     XYPlotGrp.Height := Page.ActivePage.Height - XYPlotGrp.Top - BottomMargin ;
     plPlot.Height := XYPlotGrp.Height - plPlot.Top  - 5 ;
     plPlot.Width := Page.ActivePage.Width - plPlot.Left - 5 ;

     { Histogram page }
     HistGrp.Height := Page.ActivePage.Height - HistGrp.Top - BottomMargin ;
     plHist.Height := HistGrp.Height - plHist.Top  - 5 ;
     plHist.Width := Page.ActivePage.Width - plHist.Left - 5 ;

     { Summary page }
     SummaryGrp.Height := Page.ActivePage.Height - SummaryGrp.Top - BottomMargin ;
     Summary.Height := SummaryGrp.Height ;
     Summary.Width := Page.ActivePage.Width - Summary.Left - 5 ;

     { Tables page }
     Table.Height := Page.ActivePage.Height - Table.Top - 10 ;
     Table.Width := Page.ActivePage.Width - Table.Left - 5 ;
     
     end;


function TFitFrm.UseRecord (
         const RecH : TRecHeader ;
         RecType : string
         ) : Boolean ;
{ -----------------------------------------------------
  Select record for inclusion on graph, histogram, etc.
  -----------------------------------------------------}
begin
     if (RecH.Status = 'ACCEPTED')
        and ( (RecH.RecType = RecType) or ( RecType = 'ALL') ) then
        UseRecord := True
     else UseRecord := False ;
     end ;


procedure TFitFrm.cbEquationChange(Sender: TObject);
begin
    { NewVariableNames ;}
     end;


procedure TFitFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{ ------------------------
  Function key processing
  1/12/97 ... Ctrl-R changes Accepted/Rejected, Record types can be set by key
  -----------------------}
begin
     { function keys only active when a signal record is displayed }
     if (Page.ActivePage = CurveFitTab) then begin

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
          $54,$4c,$45,$4d,$46 : begin
               if (Shift = [ssCtrl]) then begin
                  { Update record type }
                  case Key of
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



procedure TFitFrm.cbRecordTypeChange(Sender: TObject);
{ -----------------------------
  Save new record type to file
  ----------------------------}
begin
     RH.RecType := cbRecordType.text ;
     PutRecordHeaderOnly( fH, RH, fH.RecordNum ) ;
     end;


function TFitFrm.DataAvailable : Boolean ;
// --------------------------------------------------
// Return TRUE if data available for copying/printing
// --------------------------------------------------
begin

     if Page.ActivePage = CurveFitTab then begin
        Result := True ;
        end
     else if Page.ActivePage = XYPlotTab then begin
        Result := plPlot.Available ;
        end
     else if Page.ActivePage = HistogramTab then begin
        Result :=  plHist.Available ;
        end
     else if Page.ActivePage = SummaryTab then begin
        Result := True ;
        end
     else if Page.ActivePage = TablesTab then begin
        Result := True ;
        end
     else begin
        Result := False ;
        end ;

     end ;


function TFitFrm.ImageAvailable : Boolean ;
// --------------------------------------------------
// Return TRUE if data available for copying/printing
// --------------------------------------------------
begin

     if Page.ActivePage = CurveFitTab then begin
        Result := True ;
        end
     else if Page.ActivePage = XYPlotTab then begin
        Result := plPlot.Available ;
        end
     else if Page.ActivePage = HistogramTab then begin
        Result :=  plHist.Available ;
        end
     else if Page.ActivePage = SummaryTab then begin
        Result := False ;
        end
     else if Page.ActivePage = TablesTab then begin
        Result := False ;
        end
     else begin
        Result := False ;
        end ;

     end ;


procedure TFitFrm.sbRecordNumChange(Sender: TObject);
begin
     DisplayRecord ;
     end;


procedure TFitFrm.PageChange(Sender: TObject);
{ ----------------------------------------------
  Modifications to controls when page is changed
  ---------------------------------------------- }
var
   TopOfTabPage,LeftOfTabPage,FitCh : Integer ;
   EqnType : TEqnType ;
begin
     TopOfTabPage := Page.Top + Page.ActivePage.Top ;
     LeftOfTabPage := Page.Left + Page.ActivePage.Left ;

     if Page.ActivePage = CurveFitTab then begin
        RecordsGrp.Visible := False ;
        end
     else if Page.ActivePage = XYPlotTab then begin
        RecordsGrp.Visible := True ;
        RecordsGrp.Top := TopOfTabPage + XYPlotGrp.Top + 10 ;
        RecordsGrp.Left := LeftOfTabPage + XYPlotGrp.Left + bNewXYPlot.Left ;
        SelectEquation( FitCh, EqnType ) ;
        NewVariableNames( FitCh, EqnType ) ;
        end
     else if Page.ActivePage = HistogramTab then begin
        RecordsGrp.Visible := True ;
        RecordsGrp.Top := TopOfTabPage + HistGrp.Top + 10 ;
        RecordsGrp.Left :=  LeftOfTabPage + HistGrp.Left + bNewHistogram.Left ;
        SelectEquation( FitCh, EqnType ) ;
        NewVariableNames( FitCh, EqnType ) ;
        if HistogramLimitsNeeded then SetDefaultHistogramLimits ;
        end
    else if Page.ActivePage = SummaryTab then begin
        { Place records group }
        RecordsGrp.Visible := True ;
        RecordsGrp.Top := TopOfTabPage + SummaryGrp.Top + 10 ;
        RecordsGrp.Left :=  LeftOfTabPage + SummaryGrp.Left + 8 ;
        SelectEquation( FitCh, EqnType ) ;
        NewVariableNames( FitCh, EqnType ) ;
        FillSummaryTable ;
        end
    else if Page.ActivePage = TablesTab then begin
        RecordsGrp.Visible := True ;
        RecordsGrp.Top := TopOfTabPage + 10 ;
        RecordsGrp.Left :=  LeftOfTabPage + BadFitsGrp.Left ;
        SelectEquation( FitCh, EqnType ) ;
        NewVariableNames( FitCh, EqnType ) ;
        {if NewTableNeeded then} FillTable ;
        end ;

    end;


procedure TFitFrm.edPlotRangeKeyPress(Sender: TObject; var Key: Char);
{ -----------------------------------------------
  Update appropriate plot when plot range changed
  ----------------------------------------------- }
begin
     NewSummaryNeeded := True ;
     if key = chr(13) then begin
        if Page.ActivePage = XYPlotTab then bNewXYPlot.Click
        else if Page.ActivePage = HistogramTab then bNewHistogram.Click
        else if Page.ActivePage = SummaryTab then FillSummaryTable
        else if Page.ActivePage = TablesTab then FillTable ;
        end ;
     end;


procedure TFitFrm.CopyDataToClipboard ;
{ -----------------------------------------------------------
  Copy the data in currently displayed graph to the clipboard
  -----------------------------------------------------------}
begin
     if Page.ActivePage = CurveFitTab then scDisplay.CopyDataToClipboard
     else if Page.ActivePage = XYPlotTab then plPlot.CopyDataToClipboard
     else if Page.ActivePage = HistogramTab then plHist.CopyDataToClipboard
     else if Page.ActivePage = SummaryTab then CopyStringGrid(Summary)
     else if Page.ActivePage = TablesTab then CopyStringGrid(Table);
     end ;


procedure TFitFrm.Print ;
{ ---------------------------------------------
  Print the currently displayed graph or table
  --------------------------------------------- }
var
   i : Integer ;
begin

     if Page.ActivePage = CurveFitTab then begin
        { Print record on display }
        PrintRecFrm.Destination := dePrinter ;
        PrintRecFrm.DisplayObj := scDisplay ;
        PrintRecFrm.ShowModal ;
        if PrintRecFrm.ModalResult = mrOK then begin
           scDisplay.ClearPrinterTitle ;
           scDisplay.AddPrinterTitleLine( 'File : ' + FH.FileName ) ;
           scDisplay.AddPrinterTitleLine( FH.IdentLine ) ;
          for i := 0 to Results.Count-1 do
              scDisplay.AddPrinterTitleLine( Results[i] ) ;
           scDisplay.Print ;
           end ;
        end ;

     if Page.ActivePage = XYPlotTab then begin
       { Print X/Y plot }
       PrintGraphFrm.Plot := plPlot ;
       PrintGraphFrm.ToPrinter := True ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then begin
          { Add title information to plot }
          plPlot.ClearPrinterTitle ;
          plPlot.AddPrinterTitleLine( 'File ... ' + FH.FileName ) ;
          plPlot.AddPrinterTitleLine( FH.IdentLine ) ;
          { Plot graph to printer }
          plPlot.Print ;
          end ;
       end ;

     if Page.ActivePage = HistogramTab then begin
       { Print histogram }
       PrintGraphFrm.Plot := plHist ;
       PrintGraphFrm.ToPrinter := True ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then begin
          { Add title information to plot }
          plHist.ClearPrinterTitle ;
          plHist.AddPrinterTitleLine( 'File ... ' + FH.FileName ) ;
          plHist.AddPrinterTitleLine( FH.IdentLine ) ;
          { Plot graph to printer }
          plHist.Print ;
          end ;
       end ;

     if Page.ActivePage = SummaryTab then begin
       PrintTableFrm.Table := Summary ;
       PrintTableFrm.Title :=  'Curve Fit Summary: ' ;
       PrintTableFrm.ShowModal ;
       if PrintTableFrm.ModalResult = mrOK then
          WriteToLogFile( 'Curve Fit  summary table printed' ) ;
       end ;

     if Page.ActivePage = TablesTab then begin
       PrintTableFrm.Table := Table ;
       PrintTableFrm.Title :=  'Curve Fit: ' ;
       PrintTableFrm.ShowModal ;
       if PrintTableFrm.ModalResult = mrOK then
          WriteToLogFile( 'Curve Fit results table printed' ) ;

       end ;

     end ;


procedure TFitFrm.CopyImageToClipboard ;
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
       { Copy histogram }
       PrintGraphFrm.Plot := plHist ;
       PrintGraphFrm.ToPrinter := False ;
       PrintGraphFrm.ShowModal ;
       if PrintGraphFrm.ModalResult = mrOK then plHist.CopyImageToClipboard ;
       end
     else if Page.ActivePage = CurveFitTab then begin
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


procedure TFitFrm.scDisplayMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ ---------------------------
  Display zero level mode box
  --------------------------- }
begin
     if (Button = mbRight) and
        (scDisplay.ActiveHorizontalCursor = ChData) then begin
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
           if Channel[RH.FitChan].ADCZeroAt < 0 then begin
              // Fixed baseline level (update zero level to new position)
              Channel[RH.FitChan].ADCZero :=
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor] ;
              end
           else begin
              // Baseline level computed from record (return to computed level)
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor] :=
              Channel[RH.FitChan].ADCZero ;
              scDisplay.Invalidate ;
              end ;
           SaveHeader( FH ) ;
           end ;

        end ;
     end ;


procedure TFitFrm.scDisplayCursorChange(Sender: TObject);
{ -------------------------------------
  Update cursor labels when mouse moved
  ------------------------------------- }
var
   //TZeroCursorPos,Cursor1Pos,Cursor0Pos : Integer ;
   Range : single ;
begin

     if not TScopeDisplay(Sender).CursorChangeInProgress then begin
        TScopeDisplay(Sender).CursorChangeInProgress := True ;

        { Cursor 0 }
        //Cursor0Pos := scDisplay.VerticalCursors[Cursors.C0] ;

        { Cursor 1 }
        //Cursor1Pos := scDisplay.VerticalCursors[Cursors.C1] ;

        { Time zero }
        //TZeroCursorPos := scDisplay.VerticalCursors[Cursors.T0] ;

         // Fix baseline if required
         if Settings.FixedZeroLevels or (Channel[chData].ADCZeroAt >= 0) then begin
            if scDisplay.HorizontalCursors[chData] <> Channel[chData].ADCZero then begin
               scDisplay.HorizontalCursors[chData] := Channel[chData].ADCZero ;
               end ;
            end
         else Channel[chData].ADCZero := scDisplay.HorizontalCursors[chData] ;


        if (RH.EqnType <> None) and (RH.FitChan >= 0) then begin
           Channel[RH.FitChan].yMin := scDisplay.YMin[chData] ;
           Channel[RH.FitChan].yMax := scDisplay.YMax[chData] ;
           end ;

        Range := scDisplay.YMax[chData] - scDisplay.YMin[chData] ;
        scDisplay.yMin[chRes] := -0.5*Range ;
        scDisplay.yMax[chRes] := 0.5*Range ;

        TScopeDisplay(Sender).CursorChangeInProgress := False ;

        end;
     end ;


procedure TFitFrm.bFilterClick(Sender: TObject);
{ ------------------------------------------------
  Accept/reject records based upon filter criteria
  ------------------------------------------------ }
var
   Rec,StartAtRec,EndAtRec : Integer ;
   y : Single ;
begin

     FilterFrm.VarNames := VarNames ;
     FilterFrm.ShowChannels := False ;
     FilterFrm.ShowModal ;
     if FilterFrm.ModalResult = mrOK then begin
        { Record range }
        StartAtRec := Round(edPlotRange.LoValue) ;
        EndAtRec := Round(edPlotRange.HiValue ) ;

        { Set progress bar }

        for Rec := StartAtRec to EndAtRec do begin
            { Read record analysis block from file }
            GetRecordHeaderOnly( fH, RH, Rec ) ;
            { Set record status/type according to filter criteria }
            if FilterFrm.AllRecords then begin
               if FilterFrm.SetRecordStatus then rH.Status := FilterFrm.Status ;
               if FilterFrm.SetRecordType then rH.RecType := FilterFrm.RecType ;
               end
            else if (RH.EqnType <> None) then begin
               y := RH.Value[FilterFrm.Variable] ;
               if ((FilterFrm.LowerLimit <= y) and (y <= FilterFrm.UpperLimit)) then begin
                  if FilterFrm.SetRecordStatus then rH.Status := FilterFrm.Status ;
                  if FilterFrm.SetRecordType then rH.RecType := FilterFrm.RecType ;
                  end ;
               end ;

            { Write analysis block }
            PutRecordHeaderOnly( fH, RH, Rec ) ;

            { Update progress }
            Main.StatusBar.SimpleText := format(
            'Filtering Records: %d/%d',
            [Rec,EndAtRec]) ;

            Application.ProcessMessages ;
            end ;

        { Log change to log file }
        if not FilterFrm.AllRecords then WriteToLogFile (
                               Format('Records filtered %s = %.3g <= %s <= %.3g',
                               [FilterFrm.Status,
                               FilterFrm.LowerLimit,
                               FilterFrm.VarName,
                               FilterFrm.UpperLimit] ))
        else WriteToLogFile (Format('All Records = %s',[FilterFrm.Status])) ;

        { Update plot }
        bNewXYPlot.Click ;

        end ;

     end;


procedure TFitFrm.bClearTableClick(Sender: TObject);
{ -------------------------------
  Clear all columns in data table
  ------------------------------- }
begin
     NumTableColumns := 0 ;
     Table.ColCount := 1 ;
     Table.RowCount := 2 ;
     FillTable ;
     end;


procedure TFitFrm.cbFitChannelChange(Sender: TObject);
begin
     InitialiseDisplay( scDisplay ) ;
     DisplayRecord ;
     end;

procedure TFitFrm.bGetCursorsClick(Sender: TObject);
// ---------------------------------------------------
// Place analysis cursors within displayed screen area
// ---------------------------------------------------
var
    XMargin : Single ;
begin
   XMargin := (scDisplay.xMax - scDisplay.xMin)*0.02 ;
   scDisplay.VerticalCursors[Cursors.C0] := Round(scDisplay.xMin + XMargin) ;
   scDisplay.VerticalCursors[Cursors.C1] := Round(scDisplay.xMax - XMargin) ;
   scDisplay.VerticalCursors[Cursors.T0] := scDisplay.VerticalCursors[Cursors.C1] ;

   end ;

procedure TFitFrm.bAddVariableClick(Sender: TObject);
// -------------------------------
// Add selected variables to table
// -------------------------------
var
    iVar : Integer ;
begin

    for iVar := 0 to NumVariables-1 do if AddVariableToTable(iVar) then begin
        Inc(NumTableColumns) ;
        Table.ColCount := NumTableColumns  ;
        Table.Col := NumTableColumns - 1;
        TableVars[Table.Col] := GetCheckBoxVariableNumber(iVar) ;
        end ;

    FillTable ;
        
    end;

procedure TFitFrm.bClearAllTableVariablesClick(Sender: TObject);
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
     
     end;

procedure TFitFrm.bSetClick(Sender: TObject);
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

     end;

procedure TFitFrm.bSaveTableToFileClick(Sender: TObject);
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
        SetCurrentDir(Settings.DataDirectory);
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

function TFitFrm.TidyNumber(
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



procedure TFitFrm.ckFixedZeroLevelsClick(Sender: TObject);
begin
     Settings.FixedZeroLevels := ckFixedZeroLevels.Checked ;
     end;

end.
