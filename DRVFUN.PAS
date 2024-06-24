unit Drvfun;
{ ==========================================================================
  WinWCP - Driving function convolution/deconvolution module
  (c) J Dempster, 1997, All Rights Reserved
  15/7/99 V3.0 Converted to 32 bit (Delphi V3.0)
  4/9/99 ... Display grid added
  30/10/99 ... NewFile method added
  3/11/99 ... NewFile now closes form if no records available
  29/8/01 ... Fixed zero level now saved when changed
  24.6.03 ... No. of display grid lines can be changed
  01.01.04 .. Out of memory error blocked when windows resized to tiny size
  24.05.10 .. Driving function corrected for changes in parameter order in exponential function
  07.06.13 .. FH.NumZeroAvg now updated when changed in ZeroFrm
  27.07.15 .. iline added to .CreateLine() & .AddPointToLine()
  12.01.17 .. .VerticalCursors() now single type and converted to integer by round()
  ==========================================================================}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Grids, maths,
  ScopeDisplay, ValEdit, RangeEdit, ComCtrls, ValidatedEdit, seslabio, math ;

type
  TDrvFunFrm = class(TForm)
    RecordGrp: TGroupBox;
    ckBadRecord: TCheckBox;
    sbRecordNum: TScrollBar;
    EqnGrp: TGroupBox;
    EdEquation: TEdit;
    ParametersTable: TStringGrid;
    ckUserSetParameters: TCheckBox;
    ckReconvolution: TCheckBox;
    GroupBox2: TGroupBox;
    GroupBox8: TGroupBox;
    rbAllRecords: TRadioButton;
    rbThisRecord: TRadioButton;
    rbRange: TRadioButton;
    cbChannel: TComboBox;
    bDoTransforms: TButton;
    bAbort: TButton;
    Label4: TLabel;
    PotGrp: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    edRecRange: TRangeEdit;
    edVHold: TValidatedEdit;
    edVRev: TValidatedEdit;
    edRecordNum: TRangeEdit;
    scDisplay: TScopeDisplay;
    ckFixedZeroLevels: TCheckBox;
    procedure sbRecordNumChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbChannelChange(Sender: TObject);
    procedure ckBadRecordClick(Sender: TObject);
    procedure bDoTransformsClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure scDisplayCursorChange(Sender: TObject);
    procedure scDisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
  DrvFunFrm: TDrvFunFrm;

implementation

{$R *.DFM}

uses mdiform, Zero , WCPFIleUnit, System.StrUtils ;

const
     { Deconvolution parameter table rows/column definitions}
     clPar = 0 ;
     clDecon = 1 ;
     clRecon = 2 ;
     rwTitle = 0 ;
     rwTau1 = 1 ;
     rwAmp1 = 2 ;
     rwTau2 = 3 ;
     rwAmp2 = 4 ;

var
   ADC : ^TSmallIntArray ;
   YSig : ^TSingleArray ;
   YFunc : ^TsingleArray ;
   RH : TRecHeader ;
   MathFunc : TMathFunc ;
   BaselineCursor : Integer ;


procedure TDrvFunFrm.FormShow(Sender: TObject);
{ ---------------------------------------------------------
  Initialise controls and create buffers when form is shown
  ---------------------------------------------------------}
begin

     { Initialise Channel combo box }
     cbChannel.items := WCPFile.ChannelNames ;
     if cbChannel.ItemIndex < 0 then cbChannel.ItemIndex := 0 ;

     { Set button states }
     bAbort.enabled := False ;
     bDoTransforms.enabled := True ;

     { Initialise display/controls }
     NewFile ;

     end ;

procedure TDrvFunFrm.NewFile ;
{ ---------------------------------------------------------
  Update controls/display to account for change of data file
  ---------------------------------------------------------}
begin

     { Set up range of records to be displayed in averaging setup display }
     if WCPFile.FH.Numrecords > 0 then begin
        WCPFile.UpdateScrollBar( sbRecordNum, 1, 1, WCPFile.fH.NumRecords ) ;
        edRecRange.HiLimit := WCPFile.FH.NumRecords ;
        edRecRange.HiValue := WCPFile.FH.NumRecords ;
        edRecRange.LoLimit := 1.0 ;
        edRecRange.LoValue := 1.0 ;

        InitialiseDisplay ;
        DisplayRecord ;
        end
     else Close ;

     end;


procedure TDrvFunFrm.InitialiseDisplay ;
{ --------------------------------------------------
  Initialise scope display to show selected channel
  -------------------------------------------------- }
var
    ch : Integer ;
begin
     { Set up scope display }
     scDisplay.MaxADCValue := WCPFile.FH.MaxADCValue ;
     scDisplay.MinADCValue := WCPFile.FH.MinADCValue ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;
     scDisplay.DisableChannelVisibilityButton := True ;

     scDisplay.MaxPoints := WCPFile.FH.NumSamples ;
     scDisplay.NumPoints := WCPFile.FH.NumSamples ;
     scDisplay.NumChannels := WCPFile.FH.NumChannels ;
     { Set channel information }
     for ch := 0 to WCPFile.FH.NumChannels-1 do begin
         scDisplay.ChanOffsets[ch] := WCPFile.Channel[ch].ChannelOffset ;
         scDisplay.ChanUnits[ch] := WCPFile.Channel[Ch].ADCUnits ;
         scDisplay.ChanName[ch] := WCPFile.Channel[Ch].ADCName ;
         scDisplay.ChanScale[ch] := WCPFile.Channel[ch].ADCScale ;
         scDisplay.yMin[ch] := WCPFile.Channel[Ch].yMin ;
         scDisplay.yMax[ch] := WCPFile.Channel[Ch].yMax ;
         if ch = cbChannel.ItemIndex then scDisplay.ChanVisible[ch] := True
                                     else scDisplay.ChanVisible[ch] := False ;
         end ;

     scDisplay.xMin := 0 ;
     scDisplay.xMax := WCPFile.FH.NumSamples - 1 ;

     scDisplay.ClearHorizontalCursors ;
     { Voltage channel baseline }
     BaseLineCursor := scDisplay.AddHorizontalCursor(cbChannel.ItemIndex,
                       WCPFile.Settings.Colors.Cursors,True,'z') ;
     scDisplay.HorizontalCursors[BaselineCursor] := WCPFile.Channel[cbChannel.ItemIndex].ADCZero ;
     scDisplay.ChanZeroAt[cbChannel.ItemIndex] := WCPFile.Channel[cbChannel.ItemIndex].ADCZeroAt ;
     scDisplay.ChanZeroAvg := WCPFile.FH.NumZeroAvg ;

     scDisplay.xOffset := 0 ;
     scDisplay.TScale := WCPFile.FH.dt{*Settings.TScale} ;
     scDisplay.TUnits := WCPFile.Settings.TUnits ;

     end ;


procedure TDrvFunFrm.DisplayRecord ;
{ ===============================
  Display digitised signal record
  ===============================}
var
   y,SumAmp : single ;
   i,col,TZeroAt,iLine : Integer ;
  // EqnType : TEqnType ;
begin

     WCPFile.FH.RecordNum := SbRecordNum.position ;

     { Read record data from file }
     WCPFile.GetRecord( WCPFile.FH, RH, WCPFile.FH.RecordNum, ADC^ ) ;

     scDisplay.SetDataBuf( ADC ) ;

     scDisplay.HorizontalCursors[BaselineCursor] := WCPFile.Channel[cbChannel.ItemIndex].ADCZero ;
     scDisplay.ChanZeroAt[cbChannel.ItemIndex] := WCPFile.Channel[cbChannel.ItemIndex].ADCZeroAt ;
     scDisplay.ChanZeroAvg := WCPFile.FH.NumZeroAvg ;

     edRecordNum.HiLimit := WCPFile.FH.NumRecords ;
     edRecordNum.HiValue := WCPFile.FH.NumRecords ;
     edRecordNum.LoValue := sbRecordNum.position ;
     edRecordNum.LoValue := sbRecordNum.position ;
     edRecordNum.HiValue := WCPFile.FH.NumRecords ;

     { Show whether record has been rejected by operator }
     if RH.Status = 'ACCEPTED' then ckBadRecord.checked := False
                               else ckBadRecord.checked := True ;

     { Plot best fitting equation }
//     EqnType := RH.EqnType ; // TEqnType(Round(RH.Value[vFitEquation])) ;
     if ((RH.EqnType = Exponential) or (RH.EqnType = Exponential2)) then
        begin
        scDisplay.ClearLines ;
        iLine := scDisplay.CreateLine( cbChannel.ItemIndex, clRed, psSolid, 1 ) ;
        MathFunc.Setup( RH.EqnType,
                        WCPFile.Settings.TUnits,
                        WCPFile.Channel[cbChannel.ItemIndex].ADCUnits)  ;

        { Transfer best-fit equation parameters from record header }
        for i := 0 to MathFunc.NumParameters-1 do begin
            MathFunc.Parameters[i] := RH.Value[RH.FitPar0 + i] ;
            end ;
        TZeroAt := RH.FitCursor0 ;

        for i := 0 to WCPFile.FH.NumSamples-1 do begin
            if i >= TZeroAt then
               y := MathFunc.Value( (i-TZeroAt)*RH.dt*WCPFile.Settings.TScale )
                    /WCPFile.Channel[cbChannel.ItemIndex].ADCScale
            else y := 0.0 ;
            scDisplay.AddPointToLine( iLine, i, y+WCPFile.Channel[cbChannel.ItemIndex].ADCZero ) ;
            end ;

        //nPars := MathFunc.NumParameters ;
        ParametersTable.options := [goFixedVertLine,goFixedHorzLine,
                                    goVertLine,goHorzLine,goEditing] ;
        { Table heading }
        ParametersTable.RowCount := 3 ;
        ParametersTable.ColCount := 3 ;
        ParametersTable.cells[clPar,rwTitle] := ' Par.   ' ;
        ParametersTable.cells[clDecon,rwTitle] := ' Deconvolution ' ;
        ParametersTable.cells[clRecon,rwTitle] := ' Reconvolution ' ;
        for Col := 0 to ParametersTable.ColCount-1 do
            ParametersTable.ColWidths[Col] := ParametersTable.canvas.TextWidth(
                                              ParametersTable.cells[Col,rwTitle]
                                              +'.');

        edEquation.text := 'exp( -t/Tau )' ;
        { Time constant }
        ParametersTable.cells[clPar,rwTau1] := MathFunc.ParNames[1] ;
        ParametersTable.cells[clDecon,rwTau1] := format('%.3g',
                                         [{Settings.TScale*}MathFunc.Parameters[1]] )
                                          + '  ' + MathFunc.ParUnits[1] ;

        { Add second time constant and amplitudes, if two exponential fit }
        if MathFunc.Equation = Exponential2 then begin
           edEquation.text := 'A1*exp( -t/Tau1 ) + A2*exp( -t/Tau2 )' ;
           ParametersTable.RowCount := 5 ;
           { Amplitude 1 (normalised) }
           SumAmp := MathFunc.Parameters[0] + MathFunc.Parameters[2] ;
           ParametersTable.cells[clPar,rwAmp1] := MathFunc.ParNames[0] ;
           ParametersTable.cells[clDecon,rwAmp1] := format('%.3g',
                                         [MathFunc.Parameters[0]/SumAmp] )
                                          + '  ' + MathFunc.ParUnits[0] ;
           { 2nd time constant }
           ParametersTable.cells[clPar,rwTau2] := MathFunc.ParNames[3] ;
           ParametersTable.cells[clDecon,rwTau2] := format('%.3g',
                                         [{Settings.TScale*}MathFunc.Parameters[3]] )
                                          + '  ' + MathFunc.ParUnits[3] ;
           { Amplitude 2 (normalised) }
           ParametersTable.cells[clPar,rwAmp2] := MathFunc.ParNames[2] ;
           ParametersTable.cells[clDecon,rwAmp2] := format('%.3g',
                                         [MathFunc.Parameters[2]/SumAmp] ) ;
           end ;
        end
     else edEquation.text := ' None: deconvolution disabled';

     end ;


procedure TDrvFunFrm.sbRecordNumChange(Sender: TObject);
{ -------------------------------------------
  Display a new record when slider bar moved
  ------------------------------------------- }
begin
     DisplayRecord ;
     end;


procedure TDrvFunFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

     if (WCPFile.DrvFH.NumRecords > 0) and (WCPFile.DrvFH.FileName <> '') then begin
        Main.mnShowDrivingFunction.visible := True ;
        Main.mnShowDrivingFunction.Enabled := True ;
        Main.mnShowDrivingFunction.Click ;
        end ;
     Action :=caFree ;
     end;


procedure TDrvFunFrm.FormCreate(Sender: TObject);
// ------------------------------------
// Initialisations when form is created
// ------------------------------------
begin
   New(ADC) ;
   New(YSig) ;
   New(YFunc) ;
   MathFunc := TMathFunc.Create ;
   MathFunc.Setup( None, ' ', ' ' ) ;
   end;


procedure TDrvFunFrm.FormDestroy(Sender: TObject);
// -----------------------------------------
// Dispose of objects when form is destroyed
// -----------------------------------------
begin
    Dispose(ADC) ;
    Dispose(YSig) ;
    Dispose(YFunc) ;
    MathFunc.Free ;
    end;

procedure TDrvFunFrm.cbChannelChange(Sender: TObject);
begin
     InitialiseDisplay ;
     DisplayRecord ;
     end;


procedure TDrvFunFrm.ckBadRecordClick(Sender: TObject);
{ ------------------------------------------------
  Save new record ACCEPTED/REJECTED status to file
  ------------------------------------------------}
begin
     if ckBadRecord.checked then RH.Status := 'REJECTED'
                            else RH.Status := 'ACCEPTED' ;
     WCPFile.PutRecordHeaderOnly( WCPFIle.FH, RH, WCPFIle.FH.RecordNum ) ;
     end;


procedure TDrvFunFrm.bDoTransformsClick(Sender: TObject);
{ ==========================================
  Create a file containing driving functions
  ==========================================}
var
   OldHandle : Integer ;
   i,j,ch,nFFT,StartAt,EndAt,Rec : Integer ;
   iY,i0,i1 : Integer ;
   ChOffset,nPars,ChSel : Integer ;
   YScale,YZero,y,YMin,YMax,t,VDrive,SumAmp : single ;
   YSigR,YSigI,YFuncR,YFuncI,Denominator : single ;
   Eqn : TEquation ;
   Done : Boolean ;
begin

     bDoTransforms.enabled := False ;

     if rbAllRecords.checked then begin
        { Analyse all records in file }
        StartAt := 1 ;
        EndAt := WCPFIle.FH.NumRecords ;
        end
     else if rbThisRecord.checked then begin
        { Analyse the currently displayed record }
        StartAt := WCPFIle.FH.RecordNum ;
        EndAt := WCPFIle.FH.RecordNum ;
        end
     else begin
        StartAt := Round(edRecRange.LoValue) ;
        EndAt := Round(edRecRange.HiValue) ;
        end ;


     { Copy details from original file header (except file handle!!!!) }
     OldHandle := WCPFIle.DrvFH.FileHandle ;
     WCPFIle.DrvfH := WCPFIle.fH ;
     WCPFIle.DrvFH.FileHandle := OldHandle ;

     { The driving functions data file name has the same name as the original file
       but with the extension .dfn }
     WCPFIle.DrvFH.FileName := ChangeFileExt( WCPFIle.FH.FileName, '.dfn' ) ;
     { Create file to hold driving function }
     if WCPFIle.DrvFH.FileHandle >= 0 then FileClose(  WCPFIle.DrvFH.FileHandle ) ;
     WCPFIle.DrvFH.FileHandle := FileCreate( WCPFIle.DrvFH.FileName ) ;
     { Save header block and request}
     if WCPFIle.DrvFH.FileHandle >= 0 then begin
           WCPFIle.DrvFH.NumRecords := 0 ;
           WCPFile.SaveHeader( WCPFIle.DrvfH ) ;
           end
     else SHowMessage( format('FileCreate Error = %d',[WCPFIle.DrvFH.FileHandle]));

     { Channel to be deconvoluted }
     ChSel := cbChannel.ItemIndex ;

     Rec := StartAt ;
     Done := False ;
     While not Done do begin

         { Read record data from file }
         WCPFile.GetRecord( WCPFIle.fH, RH, Rec, ADC^ ) ;

         { if record is ACCEPTED ... process it }
         if (RH.Status = 'ACCEPTED') and
            ( RH.EqnType = Exponential)
            or (RH.EqnType = Exponential2)
            or (RH.EqnType = DecayingExp)
            or (RH.EqnType = DecayingExp2)
            then begin

            { NOTE ... only exponential or 2-exponential functions
            are suitable for deconvolution }

           { Make the size of the transform buffer a power of 2 equal to
             (or greater than) the number of samples points in the record }
           nFFT := 128 ;
           repeat nFFT := nFFT*2 until nFFT >= (WCPFIle.FH.NumSamples) ;
           { Fill the buffer with zero values }
           for i := 1 to 2*nFFT do YSig^[i] := 0. ;

           { Copy signal from ADC buffer and convert to scaled units }
           YScale := WCPFile.Channel[cbChannel.ItemIndex].ADCScale ;
           YZero :=  WCPFile.Channel[cbChannel.ItemIndex].ADCZero ;
           j := WCPFile.Channel[cbChannel.ItemIndex].ChannelOffset ;
           for i := 1 to WCPFIle.FH.NumSamples do begin
               YSig^[i] := (ADC^[j] - YZero)*YScale ;
               j := j + WCPFIle.FH.NumChannels ;
               end ;

           { Transform the signal to the frequency domain }
           RealFFT( YSig^, nFFT, 1 ) ;

           { Create the function which the signal is to be deconvolved from }
           MathFunc.Setup( RH.EqnType,
                           WCPFile.Settings.TUnits,
                           WCPFile.Channel[ChSel].ADCUnits ) ;

           case RH.EqnType of
             Exponential : MathFunc.Parameters[2] := 0. ;
             Exponential2 : MathFunc.Parameters[4] := 0. ;
             end ;

           { Get function parameters from parameter table
             if user entered parameters are selected }
           if ckUserSetParameters.checked then begin
              MathFunc.Parameters[2] := ExtractFloat( ParametersTable.cells[clDecon,rwTau1],
                                        1.0 ){/Settings.TScale} ;
             { Add extra parameters for 2 exponential function }
             if MathFunc.Equation = Exponential2 then begin
                MathFunc.Parameters[4] := ExtractFloat( ParametersTable.cells[clDecon,rwTau2],
                                          1.0 )
                                          {/Settings.TScale} ;
                MathFunc.Parameters[1] := ExtractFloat( ParametersTable.cells[clDecon,rwAmp1],
                                          1.0 ) ;
                MathFunc.Parameters[3] := ExtractFloat( ParametersTable.cells[clDecon,rwAmp2],
                                           1.0 ) ;
                end ;
             end ;

           { Adjust amplitudes to sum to unity }
           if MathFunc.Equation = Exponential then begin
              MathFunc.Parameters[0] := 1. ;
              end
           else begin
              SumAmp := MathFunc.Parameters[1] + MathFunc.Parameters[3] ;
              If SumAmp = 0. then SumAmp := 1. ;
              MathFunc.Parameters[0] := MathFunc.Parameters[1] / SumAmp ;
              MathFunc.Parameters[2] := MathFunc.Parameters[3] / SumAmp ;
             end ;

           { Create the function }
           for i := 1 to 2*nFFT do begin
               t := (i-1)*RH.dt*WCPFile.Settings.TScale ;
               yFunc^[i] := MathFunc.Value( t )
               end ;

           { Transform the function to the frequency domain }
           RealFFT( YFunc^, nFFT, 1 ) ;

           { Divide the FFT of the signal by the FFT of the decay function
             using complex arithmetic }
           if Abs(YFunc^[1]) > 0. then YSig^[1] := YSig^[1] / YFunc^[1] ;
           if Abs(YFunc^[2]) > 0. then YSig^[2] := YSig^[2] / YFunc^[2] ;
           j := 3 ;
           for i := 2 to nFFT do begin
               YSigR := YSig^[j] ;
               YSigI := YSig^[j+1] ;
               YFuncR := YFunc^[j] ;
               YFuncI := YFunc^[j+1] ;
               Denominator := YFuncR*YFuncR + YFuncI*YFuncI ;
               if Abs(Denominator) > 1E-30 then begin
                  YSig^[j] := (YSigR*YFuncR + YSigI*YFuncI) / Denominator ;
                  YSig^[j+1] := (YSigI*YFuncR - YSigR*YFuncI) / Denominator ;
                  end
               else begin
                  YSig^[j] := 0. ;
                  YSig^[j+1] := 0. ;
                  end ;
               j := j + 2 ;
               end ;

           { RECONVOLUTION ===================================
           (If the reconvolution box is checked, convolute the
           driving function with an new exponential function
           =================================================}

           if ckReconvolution.checked then begin
              { Get function parameters from parameter table }
              Eqn.Par[0] := 0. ;
              Eqn.Par[1] := 1. ;
              Eqn.Par[2] := ExtractFloat( ParametersTable.cells[clRecon,rwTau1],
                                        Eqn.Par[2]{*Settings.TScale} )
                                       {/Settings.TScale} ;
              { Extra parameters for 2 exponential function }
              if Eqn.EqnType = Exponential2 then begin
                 Eqn.Par[4] := ExtractFloat( ParametersTable.cells[clRecon,rwTau2],
                                          Eqn.Par[4]{*Settings.TScale} )
                                          {/Settings.TScale} ;
                 Eqn.Par[1] := ExtractFloat( ParametersTable.cells[clRecon,rwAmp1],
                                          Eqn.Par[1] ) ;
                 Eqn.Par[3] := ExtractFloat( ParametersTable.cells[clRecon,rwAmp2],
                                          Eqn.Par[3] ) ;
                 end ;
              { Create function }
              for i := 1 to 2*nFFT do begin
                  t := (i-1)*RH.dt*WCPFile.Settings.TScale;
                  yFunc^[i] := MathFunc.Value( t ) ;
                  end ;

              { Transform the function to the frequency domain }
              RealFFT( YFunc^, nFFT, 1 ) ;

              { Convolute the driving function with the exponential function }
              YSig^[1] := YSig^[1]*YFunc^[1] ;
              YSig^[2] := YSig^[2]*YFunc^[2] ;
              j := 3 ;
              for i := 2 to nFFT do begin
                  YSigR := YSig^[j] ;
                  YSigI := YSig^[j+1] ;
                  YFuncR := YFunc^[j] ;
                  YFuncI := YFunc^[j+1] ;
                  YSig^[j] := YSigR*YFuncR - YSigI*YFuncI ;
                  YSig^[j+1] := YSigI*YFuncR + YSigR*YFuncI  ;
                  j := j + 2 ;
                  end ;
              end ;

           { Transform the result back into the time domain }
           RealFFT( YSig^, nFFT, -1 ) ;

           { Divide by number of samples to get correct reverse transform }
           for i := 1 to nFFT do YSig^[i] := ySig^[i] / nFFT ;

           {Divide by the current driving force to get a conductance value }
           if not ckReconvolution.checked then begin
              VDrive := edVHold.Value - edVRev.Value ;
              if Abs(VDrive) > 1E-4 then for i := 1 to nFFT do YSig^[i] := YSig^[i]/VDrive ;

              { Create appropriate conductance units }
              if ContainsText('nA',WCPFile.Channel[ChSel].ADCUnits) then
                 WCPFile.Channel[ChSel].ADCUnits := 'uS/ms'
              else if ContainsText('pA',WCPFile.Channel[ChSel].ADCUnits) then
                 WCPFile.Channel[ChSel].ADCUnits := 'nS/ms'
              else if ContainsText('uA',WCPFile.Channel[ChSel].ADCUnits) then
                 WCPFile.Channel[ChSel].ADCUnits := 'mS/ms'
              else WCPFile.Channel[ChSel].ADCUnits := '??/ms' ;

              { Find maximum and minimum of driving function }
              YMin := MaxSingle ;
              YMax := -MaxSingle ;
              for i := 0 to WCPFIle.FH.NumSamples-1 do begin
                  y := YSig^[i] ;
                  if Y < YMin then YMin := Y ;
                  if Y > YMax then YMax := Y ;
                  end ;
              YScale := 2.*Abs(YMax - YMin) / WCPFIle.FH.MaxADCValue ;
              YZero := 0 ;
              end ;

           { Copy the driving function into the signal record replacing the
             orginal signal }
           j := cbChannel.ItemIndex ;
           for i := 1 to WCPFIle.FH.NumSamples do begin
               ADC^[j] := Round(YSig^[i]/YScale + YZero );
               j := j + WCPFIle.FH.NumChannels ;
               end ;

           { Save record to Transforms file  }
           Inc(WCPFIle.DrvFH.NumRecords) ;
           RH.AnalysisAvailable := false ;
           RH.EqnType := None ;
           WCPFile.PutRecord( WCPFIle.DrvfH, RH, WCPFIle.DrvFH.NumRecords, ADC^ ) ;
           end ;

         Main.StatusBar.SimpleText := format('Driving function: %d/%d',
                                      [Rec,EndAt]) ;
         Inc(Rec) ;
         if (Rec > EndAt) or bDoTransforms.Enabled then Done := True ;

         Application.ProcessMessages ;

         end ;

     WCPFile.SaveHeader( WCPFIle.DrvFH ) ;
     if not bDoTransforms.Enabled then Close
     else begin
        bDoTransforms.Enabled := True ;
        bAbort.Enabled := False ;
        end ;

     end;

procedure TDrvFunFrm.FormResize(Sender: TObject);
{ ------------------------------------------------------
  Adjust size/position of controls when form is re-sized
  ------------------------------------------------------ }
begin

     PotGrp.Height := ClientHeight - PotGrp.Top - 10 ;

     EqnGrp.Top := ClientHeight - EqnGrp.Height - 10 ;
     EqnGrp.Width := ClientWidth - EqnGrp.Left - 10 ;

     ckFixedZeroLevels.Left := scDisplay.left ;
     ckFixedZeroLevels.Top := EqnGrp.Top - 5 - ckFixedZeroLevels.Height ;
     scDisplay.Height := Max( ckFixedZeroLevels.Top - scDisplay.Top -1,2) ;

     scDisplay.Left := EqnGrp.Left ;
     scDisplay.Width := MaxInt( [EqnGrp.Width,2]) ;
     end;


procedure TDrvFunFrm.ChangeDisplayGrid ;
{ --------------------------------------------
  Update grid pattern on oscilloscope display
  -------------------------------------------- }
begin
     scDisplay.MaxADCValue := WCPFIle.DrvFH.MaxADCValue ;
     scDisplay.MinADCValue := WCPFIle.DrvFH.MinADCValue ;
     scDisplay.DisplayGrid := WCPFile.Settings.DisplayGrid ;
     scDisplay.Invalidate ;
     end ;


procedure  TDrvFunFrm.ZoomOut ;
{ ---------------------------------
  Set minimum display magnification
  --------------------------------- }
begin
     scDisplay.MaxADCValue := WCPFIle.DrvFH.MaxADCValue ;
     scDisplay.MinADCValue := WCPFIle.DrvFH.MinADCValue ;
     scDisplay.ZoomOut ;
     end ;


procedure TDrvFunFrm.scDisplayCursorChange(Sender: TObject);
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
     end;

procedure TDrvFunFrm.scDisplayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{ ---------------------------
  Display zero level mode box
  --------------------------- }
begin
     if (Button = mbRight) and (scDisplay.ActiveHorizontalCursor >=0) then begin
        ZeroFrm.EnableFromRecord := True ;
        ZeroFrm.Chan := cbChannel.ItemIndex ;
        ZeroFrm.Level := WCPFile.Channel[ZeroFrm.Chan].ADCZero ;
        ZeroFrm.ChanName := WCPFile.Channel[ZeroFrm.Chan].ADCName ;
        ZeroFrm.NewZeroAt := Round(scDisplay.ScreenCoordToX( ZeroFrm.Chan, X )) ;
        ZeroFrm.OldZeroAt := WCPFile.Channel[ZeroFrm.Chan].ADCZeroAt ;
        ZeroFrm. NumSamplesPerRecord := scDisplay.NumPoints ;
        ZeroFrm.NumZeroAveraged := WCPFIle.FH.NumZeroAvg ;
        ZeroFrm.MaxValue := WCPFIle.FH.MaxADCValue ;
        ZeroFrm.Left := Self.Left + Main.Left + 10 + scDisplay.Left + X;
        ZeroFrm.Top := Self.Top + Main.Top + 10 + scDisplay.Top + Y ;
        ZeroFrm.ShowModal ;
        WCPFile.Channel[ZeroFrm.Chan].ADCZero := ZeroFrm.Level ;
        WCPFile.Channel[ZeroFrm.Chan].ADCZeroAt := ZeroFrm.NewZeroAt ;
        WCPFIle.FH.NumZeroAvg := ZeroFrm.NumZeroAveraged ;
        WCPFile.SaveHeader( WCPFIle.FH ) ;
        if ZeroFrm.ModalResult = mrOK then DisplayRecord ;

        end
     else begin
        // Update zero baseline cursor
        if scDisplay.ActiveHorizontalCursor >= 0 then begin
           if WCPFile.Channel[cbChannel.ItemIndex].ADCZeroAt < 0 then begin
              // Fixed baseline level (update zero level to new position)
              WCPFile.Channel[cbChannel.ItemIndex].ADCZero := Round(
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor]) ;
              end
           else begin
              // Baseline level computed from record (return to computed level)
              scDisplay.HorizontalCursors[scDisplay.ActiveHorizontalCursor] :=
              WCPFile.Channel[cbChannel.ItemIndex].ADCZero ;
              end ;
           WCPFile.SaveHeader( WCPFIle.DrvFH ) ;
           scDisplay.Invalidate ;
           end ;
        end ;
     edVHold.SetFocus ;
     end ;

procedure TDrvFunFrm.FormKeyDown(Sender: TObject; var Key: Word;
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


procedure TDrvFunFrm.FormActivate(Sender: TObject);
begin
    ckFixedZeroLevels.Checked := WCPFile.Settings.FixedZeroLevels ;
    end;

procedure TDrvFunFrm.ckFixedZeroLevelsClick(Sender: TObject);
// --------------------------------
// Enable/Disable fixed zero levels
// --------------------------------
begin
     WCPFile.Settings.FixedZeroLevels := ckFixedZeroLevels.Checked ;
     end;

end.
