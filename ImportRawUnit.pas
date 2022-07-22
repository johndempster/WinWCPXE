unit ImportRawUnit;
// ---------------------------------------
// Raw binary file import setup dialog box
// ---------------------------------------
// 19.03.04 Updated to support WinWCP
// 14.05.10 MaxADCValue now set from input field

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ValidatedEdit, maths, Grids, ADCDataFile,math ;



type
  TImportRawFrm = class(TForm)
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label9: TLabel;
    edNumFileHeaderBytes: TValidatedEdit;
    edNumChannelsPerScan: TValidatedEdit;
    bOK: TButton;
    bCancel: TButton;
    GroupBox1: TGroupBox;
    ChannelTable: TStringGrid;
    GroupBox3: TGroupBox;
    rbFloat: TRadioButton;
    rbInteger: TRadioButton;
    edMaxADCValue: TValidatedEdit;
    lbMaxADCValue: TLabel;
    GroupBox4: TGroupBox;
    rbmsecs: TRadioButton;
    rbSecs: TRadioButton;
    rbMins: TRadioButton;
    edNumScansPerRecord: TValidatedEdit;
    Label2: TLabel;
    Label1: TLabel;
    edNumBytesPerSample: TValidatedEdit;
    lbSamplingInterval: TLabel;
    edScanInterval: TValidatedEdit;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure cbTimeScaleChange(Sender: TObject);
    procedure edNumBytesPerSampleKeyPress(Sender: TObject; var Key: Char);
    procedure edMaxADCValueKeyPress(Sender: TObject; var Key: Char);
    procedure edNumChannelsPerScanKeyPress(Sender: TObject; var Key: Char);
    procedure rbFloatClick(Sender: TObject);
    procedure rbmsecsClick(Sender: TObject);
  private
    { Private declarations }
    SampleADCLimit : Integer ;
    procedure UpdateControls ;
  public
    { Public declarations }
    ImportFile : TADCDataFile ;
  end;

var
  ImportRawFrm: TImportRawFrm;

implementation

{$R *.dfm}

uses MDIForm;
const
     ChNum = 0 ;
     ChName = 1 ;
     ChScale = 2 ;
     ChUnits = 3 ;
     FPformat = 0 ;
     Intformat = 1 ;

procedure TImportRawFrm.FormShow(Sender: TObject);
// ------------------------------------------
// Initialise controls when form is displayed
// ------------------------------------------
var
     Row : Integer ;
     ch : Integer ;
begin

     Top := Main.Top + 60 ;
     Left := Main.Left + 20 ;

    edNumFileHeaderBytes.Value := ImportFile.NumFileHeaderBytes ;
    edNumChannelsPerScan.Value := ImportFile.NumChannelsPerScan ;
    edNumBytesPerSample.Value := ImportFile.NumBytesPerSample ;
    edNumScansPerRecord.Value := ImportFile.NumScansPerRecord ;

    edMaxADCValue.Value := ImportFile.MaxADCValue ;
    edScanInterval.Value := ImportFile.ScanInterval ;

    if rbsecs.Checked then begin
       edScanInterval.Scale := 1.0 ;
       edScanInterval.Units := 's' ;
       end
    else if rbmsecs.Checked then begin
       edScanInterval.Scale := 1000.0 ;
       edScanInterval.Units := 'ms' ;
       end
    else begin
       edScanInterval.Scale := 1.0/60.0 ;
       edScanInterval.Units := 'min' ;
       end ;

    // Set sample format
    rbFloat.Checked := ImportFile.FloatingPointSamples ;
    rbInteger.Checked := not ImportFile.FloatingPointSamples ;
    lbMaxADCValue.Visible := rbInteger.Checked ;
    edMaxADCValue.Visible := rbInteger.Checked ;

    { Set channel calibration table }
    ChannelTable.cells[ChNum,0] := 'Ch.' ;
    ChannelTable.colwidths[ChNum] := ChannelTable.DefaultColWidth div 2 ;
    ChannelTable.cells[ChName,0] := 'Name' ;
    ChannelTable.colwidths[ChName] := ChannelTable.DefaultColWidth ;
    ChannelTable.cells[ChScale,0] := 'Units/bit' ;
    ChannelTable.colwidths[ChScale] := (4*ChannelTable.DefaultColWidth) div 3 ;
    ChannelTable.cells[ChUnits,0] := 'Units' ;
    ChannelTable.colwidths[ChUnits] := ChannelTable.DefaultColWidth ;
    ChannelTable.RowCount := ImportFile.NumChannelsPerScan + 1;
    ChannelTable.options := [goEditing,goHorzLine,goVertLine] ;

     ChannelTable.RowCount := ImportFile.NumChannelsPerScan + 1 ;
     { Add details for new channels to table }
     for Row := 1 to ChannelTable.RowCount-1 do begin
         ch := Row-1 ;
         ChannelTable.cells[ChNum,Row] := format('%d',[ch]) ;
         ChannelTable.cells[ChName,Row] := ImportFile.ChannelName[ch] ;
         ChannelTable.cells[ChScale,Row] := Format('%5.4g',[ImportFile.ChannelScale[ch]] ) ;
         ChannelTable.cells[ChUnits,Row] := ImportFile.ChannelUnits[ch] ;
         end ;

    UpdateControls ;

    end;

procedure TImportRawFrm.bOKClick(Sender: TObject);
// ------------------------------------------
// OK pressed - Update public variables and exit
// ------------------------------------------
var
    ch : Integer ;
begin

    // Ensure all controls are consistent with each other
    UpdateControls ;

    ImportFile.NumFileHeaderBytes := Round(edNumFileHeaderBytes.Value)  ;
    ImportFile.NumChannelsPerScan := Round(edNumChannelsPerScan.Value) ;
    ImportFile.NumBytesPerSample := Round(edNumBytesPerSample.Value) ;
    ImportFile.NumScansPerRecord := Round(edNumScansPerRecord.Value) ;

    ImportFile.MaxADCValue := Round(edMaxADCValue.Value) ;
    ImportFile.MaxADCValue := Min(ImportFile.MaxADCValue,SampleADCLimit) ;

    ImportFile.ScanInterval := edScanInterval.Value ;

    // Floating point integer format
    ImportFile.FloatingPointSamples := rbFloat.Checked ;

    for ch := 0 to ImportFile.NumChannelsPerScan-1 do begin
         ImportFile.ChannelName[ch] := ChannelTable.cells[ChName,ch+1] ;
         ImportFile.ChannelScale[ch] := ExtractFloat(ChannelTable.cells[ChScale,ch+1],1.0) ;
         ImportFile.ChannelUnits[ch] := ChannelTable.cells[ChUnits,ch+1] ;
         end ;


    end;


procedure TImportRawFrm.UpdateControls ;
// --------------------------------------
// Update controls to account for changes
// --------------------------------------
begin

    if rbsecs.Checked then begin
       edScanInterval.Scale := 1.0 ;
       edScanInterval.Units := 's' ;
       end
    else if rbmsecs.Checked then begin
       edScanInterval.Scale := 1000.0 ;
       edScanInterval.Units := 'ms' ;
       end
    else begin
       edScanInterval.Scale := 1.0/60.0 ;
       edScanInterval.Units := 'min' ;
       end ;

    if ImportFile.ScanInterval = 0.0 then ImportFile.ScanInterval := 1.0 ;
    edScanInterval.Value := ImportFile.ScanInterval ;

    ImportFile.NumBytesPerSample := Round(edNumBytesPerSample.Value) ;
    if ImportFile.NumBytesPerSample = 1 then SampleADCLimit := 255
                                        else SampleADCLimit := 32767 ;

    if ImportFile.MaxADCValue = 0 then ImportFile.MaxADCValue := SampleADCLimit ;
    edMaxADCValue.Value := ImportFile.MaxADCValue ;

    ChannelTable.RowCount := ImportFile.NumChannelsPerScan + 1 ;

    end ;


procedure TImportRawFrm.cbTimeScaleChange(Sender: TObject);
begin
     UpdateControls ;
     end;

procedure TImportRawFrm.edNumBytesPerSampleKeyPress(Sender: TObject;
  var Key: Char);
begin
     if Key = #13 then UpdateControls ;
     end;

procedure TImportRawFrm.edMaxADCValueKeyPress(Sender: TObject;
  var Key: Char);
begin
     if Key = #13 then UpdateControls ;
     end;


procedure TImportRawFrm.edNumChannelsPerScanKeyPress(Sender: TObject;
  var Key: Char);
// ------------------------------
// No. of signal channels changed
// ------------------------------
var
     Row : Integer ;
     ch : Integer ;
begin
     if Key = #13 then begin
        { Add details for new channels to table }
        ImportFile.NumChannelsPerScan := Round(edNumChannelsPerScan.Value) ;
        ChannelTable.RowCount := ImportFile.NumChannelsPerScan + 1 ;
        for Row := 1 to ChannelTable.RowCount-1 do begin
            ch := Row-1 ;
            ChannelTable.cells[ChNum,Row] := format('%d',[ch]) ;
            ChannelTable.cells[ChName,Row] := ImportFile.ChannelName[ch] ;
            ChannelTable.cells[ChScale,Row] := Format('%5.4g',[ImportFile.ChannelScale[ch]] ) ;
            ChannelTable.cells[ChUnits,Row] := ImportFile.ChannelUnits[ch] ;
            end ;
        end ;
     end;


procedure TImportRawFrm.rbFloatClick(Sender: TObject);
begin
    lbMaxADCValue.Visible := rbInteger.Checked ;
    edMaxADCValue.Visible := rbInteger.Checked ;
    end;

procedure TImportRawFrm.rbmsecsClick(Sender: TObject);
begin
     UpdateControls ;
     end;

end.
