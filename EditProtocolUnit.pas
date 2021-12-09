unit EditProtocolUnit;
// ------------------------------------
// Stimulus & recording protocol editor
// ------------------------------------
// 12.04.11
// 13.06.11 No. A/ D channels now included in protocol
// 21.06.11    Nosamplesandchannelsnowlimitedbylabinterface
// 05.07.11 .NumStimulusIncrements changed to .NumRecords
// 19.08.11 Save Protocol button added
// 20.12.11 Protocol.saved now set false when no. D/A or Dig channels changed
// 13.03.12 seal test pulses now stopped when form activated to avoid
//           interference with A/D and D/A interval checks.
// 11.06.12 Recording parameters table now filled correctly when no default protocol exists
//          Opened and Saved protocols now selected as default protocol if none already defined
// 02.07.13 Updated to compile under Delphi XE
//          Recording parameters now set to default values when no previous protocol not available
//          Pulse period of train waveform can now be incremented between records
//          Global stimulus protocol variables feature added
// 20.08.13 SetCurrentDir() now used to ensure file dialog boxes open in current protocol directory
// 25.06.14 Height of Recording settings box increased to ensure External Trigger line is visible
// 15.12.14 Changes to element parameters no longer lost when a new element dropped on waveform palette
// 16.06.15 Fixed tick box moved from Sampling Interval to No. of samples/channel. When Fixed is NOT ticked
//          No. of samples/channel is now altered when sampling interval changed to maintain fixed duration
//          and vice versa.
// 28.07.15 Pulse trains with frequency incrementing added
// 11.07.16 Warning displayed when stimulus duration not more than 150 ms less than repeat period
// 23.09.16 File dialogs initialised to vprot folder when form opened
//          to try to fix failure to open in default protocol folder
//          when WinWCP installed first time.
// 09.02.17 DigWave added. Scale/Offset added to Wave
// 02.10.17 Hint assoociated with ckKeepADCSamplesPerChannelFixed corrected
// 31.05.18 Sine wave protocol added.
// 05.04.19 Digital stimulus protocol display now only shows one pattern when No. records = 1
//          (rather than 1 + next increment.)
// 06.02.20 PulseStaircase waveform type producing a series of pulses on a rising staircase added.
// 01.12.21 Display of user-defined waveforms limited to sample of 10000 points to prevent long delays
//          when large (> 10000) waveforms loaded.
//          Initial delay no longer fixed at default (10 ms) for userr-entered wavedforms
//          Parameter table numbers now set with up to 6 figure accuracy
//  09.12.12 Frequency increment of wvWave sine waves caan now act as a multiplier as well as an additive increment
//           MULTIPLIERFLAG= added to waveform parameter records and spFrequencyMultiplierFlag added to protocol parameter list
//          'Multiply by increment (1=Y,0=N) ' added to parameter table
//

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ValidatedEdit, ComCtrls, math, stimmodule, maths, strutils,
  xmldom, XMLIntf, msxmldom, XMLDoc, global, shared, SESLabIO, Outline,
  DirOutln, FileCtrl, Types, UITYpes ;

const
    MaxAOChannels = 4 ;
    MaxDOChannels = 8 ;
    MaxStimChannels = MaxAOChannels + MaxDOChannels ;
    MaxStimElementsPerChannels = 10 ;
    AOElementsStart = 0 ;
    DOElementsStart = MaxAOChannels*MaxStimElementsPerChannels ;
    MaxStimType = 6 ;

    stUnitsmV = 0 ;
    stUnitspA = 1 ;
    stUnitsnA = 2 ;
    stUnitsuA = 3 ;
    stUnitsmA = 4 ;

type

  TParameterList = record
      Index : Integer ;
      Scale : Single ;
      Units : String ;
      end ;

  TStimType = record
      Name : String ;
      Units : String ;
      Scale : Single ;
      end ;

  TEditProtocolFrm = class(TForm)
    Page: TPageControl;
    RecordTab: TTabSheet;
    StimulusTab: TTabSheet;
    ProtocolGrp: TGroupBox;
    shSelected: TShape;
    ToolBoxGrp: TGroupBox;
    Step1: TImage;
    Step2: TImage;
    pTrain: TImage;
    Ramp: TImage;
    Wave: TImage;
    Step0: TImage;
    None: TImage;
    DigStep0: TImage;
    DigStep1: TImage;
    DigTrain: TImage;
    DigNone: TImage;
    Label8: TLabel;
    Label9: TLabel;
    AO0panel: TPanel;
    Label14: TLabel;
    AO00: TImage;
    AO01: TImage;
    AO02: TImage;
    AO03: TImage;
    AO04: TImage;
    AO05: TImage;
    AO06: TImage;
    AO07: TImage;
    AO08: TImage;
    AO09: TImage;
    AO1Panel: TPanel;
    Label3: TLabel;
    AO10: TImage;
    AO11: TImage;
    AO12: TImage;
    AO13: TImage;
    AO14: TImage;
    AO15: TImage;
    AO16: TImage;
    AO17: TImage;
    AO18: TImage;
    AO19: TImage;
    AO2Panel: TPanel;
    Label6: TLabel;
    AO20: TImage;
    AO21: TImage;
    AO22: TImage;
    AO23: TImage;
    AO24: TImage;
    AO25: TImage;
    AO26: TImage;
    AO27: TImage;
    AO28: TImage;
    AO29: TImage;
    AO3Panel: TPanel;
    Label12: TLabel;
    AO30: TImage;
    AO31: TImage;
    AO32: TImage;
    AO33: TImage;
    AO34: TImage;
    AO35: TImage;
    AO36: TImage;
    AO37: TImage;
    AO38: TImage;
    AO39: TImage;
    ParameterTableGrp: TGroupBox;
    Table: TStringGrid;
    DO0Panel: TPanel;
    Label7: TLabel;
    DO00: TImage;
    DO01: TImage;
    DO02: TImage;
    DO03: TImage;
    DO04: TImage;
    DO05: TImage;
    DO06: TImage;
    DO07: TImage;
    DO08: TImage;
    DO09: TImage;
    DO1Panel: TPanel;
    Label13: TLabel;
    DO10: TImage;
    DO11: TImage;
    DO12: TImage;
    DO13: TImage;
    DO14: TImage;
    DO15: TImage;
    DO16: TImage;
    DO17: TImage;
    DO18: TImage;
    DO19: TImage;
    DO2Panel: TPanel;
    Label15: TLabel;
    DO20: TImage;
    DO21: TImage;
    DO22: TImage;
    DO23: TImage;
    DO24: TImage;
    DO25: TImage;
    DO26: TImage;
    DO27: TImage;
    DO28: TImage;
    DO29: TImage;
    DO3Panel: TPanel;
    Label16: TLabel;
    DO30: TImage;
    DO31: TImage;
    DO32: TImage;
    DO33: TImage;
    DO34: TImage;
    DO35: TImage;
    DO36: TImage;
    DO37: TImage;
    DO38: TImage;
    DO39: TImage;
    DO4Panel: TPanel;
    Label17: TLabel;
    DO40: TImage;
    DO41: TImage;
    DO42: TImage;
    DO43: TImage;
    DO44: TImage;
    DO45: TImage;
    DO46: TImage;
    DO47: TImage;
    DO48: TImage;
    DO49: TImage;
    DO5Panel: TPanel;
    Label18: TLabel;
    DO50: TImage;
    DO51: TImage;
    DO52: TImage;
    DO53: TImage;
    DO54: TImage;
    DO55: TImage;
    DO56: TImage;
    DO57: TImage;
    DO58: TImage;
    DO59: TImage;
    DO6Panel: TPanel;
    Label19: TLabel;
    DO60: TImage;
    DO61: TImage;
    DO62: TImage;
    DO63: TImage;
    DO64: TImage;
    DO65: TImage;
    DO66: TImage;
    DO67: TImage;
    DO68: TImage;
    DO69: TImage;
    DO7Panel: TPanel;
    Label20: TLabel;
    DO70: TImage;
    DO71: TImage;
    DO72: TImage;
    DO73: TImage;
    DO74: TImage;
    DO75: TImage;
    DO76: TImage;
    DO77: TImage;
    DO78: TImage;
    DO79: TImage;
    ControlGrp: TGroupBox;
    bOpen: TButton;
    bSaveAs: TButton;
    bNew: TButton;
    bSetStimFolder: TButton;
    DOGrp: TGroupBox;
    Label24: TLabel;
    cbNumDOChannels: TComboBox;
    AOGrp: TGroupBox;
    DisplayGrp: TGroupBox;
    pbDisplay: TPaintBox;
    Label23: TLabel;
    cbNumAOChannels: TComboBox;
    GroupBox3: TGroupBox;
    cbNextProtocol: TComboBox;
    rbDO0Off: TRadioButton;
    rbDO0On: TRadioButton;
    DO0Hold: TPanel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    DO1Hold: TPanel;
    Label37: TLabel;
    rbDO1Off: TRadioButton;
    rbDO1On: TRadioButton;
    DO2Hold: TPanel;
    Label38: TLabel;
    rbDO2Off: TRadioButton;
    rbDO2On: TRadioButton;
    DO3Hold: TPanel;
    Label39: TLabel;
    rbDO3Off: TRadioButton;
    rbDO3On: TRadioButton;
    DO4Hold: TPanel;
    Label40: TLabel;
    rbDO4Off: TRadioButton;
    rbDO4On: TRadioButton;
    DO5Hold: TPanel;
    Label41: TLabel;
    rbDO5Off: TRadioButton;
    rbDO5On: TRadioButton;
    DO6Hold: TPanel;
    Label42: TLabel;
    rbDo6Off: TRadioButton;
    rbDO6On: TRadioButton;
    DO7Hold: TPanel;
    Label43: TLabel;
    rbDO7Off: TRadioButton;
    rbDo7On: TRadioButton;
    GroupBox2: TGroupBox;
    RecTable: TStringGrid;
    LeakGrp: TGroupBox;
    rbNoLeak: TRadioButton;
    rbPNLeak: TRadioButton;
    PNGroup: TGroupBox;
    lbNumLeaks: TLabel;
    lbLeakScale: TLabel;
    edNumLeaks: TValidatedEdit;
    edLeakScale: TValidatedEdit;
    Shape1: TShape;
    PageControl1: TPageControl;
    AO0Tab: TTabSheet;
    AO0StimGrp: TGroupBox;
    Label25: TLabel;
    Label29: TLabel;
    cbAO0Stim: TComboBox;
    edAO0Hold: TValidatedEdit;
    AO1Tab: TTabSheet;
    AO2Tab: TTabSheet;
    AO3Tab: TTabSheet;
    AO2StimGrp: TGroupBox;
    Label5: TLabel;
    Label11: TLabel;
    cbAO2Stim: TComboBox;
    edAO2Hold: TValidatedEdit;
    AO3StimGrp: TGroupBox;
    Label21: TLabel;
    Label27: TLabel;
    cbAO3Stim: TComboBox;
    edAO3Hold: TValidatedEdit;
    AO1StimGrp: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    cbAO1Stim: TComboBox;
    edAO1Hold: TValidatedEdit;
    XMLDoc: TXMLDocument;
    AO0Background: TShape;
    AO1Background: TShape;
    AO2Background: TShape;
    AO3Background: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    bLoadFile: TButton;
    OpenWaveDialog: TOpenDialog;
    bSave: TButton;
    GroupBox1: TGroupBox;
    edDACUpdateInterval: TValidatedEdit;
    ckFixedDACUpdateInterval: TCheckBox;
    GlobalTab: TTabSheet;
    GroupBox4: TGroupBox;
    GlobalVarTable: TStringGrid;
    ckFixedSamplesPerChannel: TCheckBox;
    pTrainHz: TImage;
    DigTrainHz: TImage;
    lbError: TLabel;
    DigWave: TImage;
    Sine: TImage;
    PulseStaircase: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbNumAOChannelsChange(Sender: TObject);
    procedure cbNumDOChannelsChange(Sender: TObject);
    procedure Step0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AO00DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure AO00DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Image31DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image31DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AO00Click(Sender: TObject);
    procedure TableKeyPress(Sender: TObject; var Key: Char);
    procedure pbDisplayPaint(Sender: TObject);
    procedure RecTableKeyPress(Sender: TObject; var Key: Char);
    procedure PageChange(Sender: TObject);
    procedure cbAO0StimChange(Sender: TObject);
    procedure edAO0HoldKeyPress(Sender: TObject; var Key: Char);
    procedure rbDO0OnClick(Sender: TObject);
    procedure bSaveAsClick(Sender: TObject);
    procedure bOpenClick(Sender: TObject);
    procedure edNumLeaksKeyPress(Sender: TObject; var Key: Char);
    procedure edLeakScaleKeyPress(Sender: TObject; var Key: Char);
    procedure rbNoLeakClick(Sender: TObject);
    procedure rbPNLeakClick(Sender: TObject);
    procedure bNewClick(Sender: TObject);
    procedure bSetStimFolderClick(Sender: TObject);
    procedure bLoadFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edDACUpdateIntervalKeyPress(Sender: TObject; var Key: Char);
    procedure ckFixedDACUpdateIntervalClick(Sender: TObject);
    procedure cbNextProtocolChange(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure GlobalVarTableKeyPress(Sender: TObject; var Key: Char);



  private
    { Private declarations }
    FileName : String ;
    Prot : TStimulusProtocol ;
    NumAOChannels : Integer ;
    NumDOChannels : Integer ;
    SelectedWaveform : Integer ;
    SelectedStimulusElement : Integer ;
    WaveShapeImage : Array[0..20] of TImage ;
    ParNames : Array[0..MaxPars] of string ;
    TUnits : string ;
    TScale : Single ;
    StimType : Array[0..MaxStimType] of TStimType ;

    RecordingParametersTableChanged  : Boolean ;
    StimulusParametersTableChanged  : Boolean ;
    GlobalVarsTableChanged : Boolean ;

    DisableUpdates : Boolean ;

    procedure AdjustWaveformPalettes ;

    procedure GetParameterList(
              iElement : Integer ;                       // Waveform element in stimulus array
              var ParamList : Array of TParameterList    // Parameter list for element
              ) ;
    function GetStimElementName( iElement : Integer ) : string ;
    function GetStimElementUnits( iElement : Integer ) : string ;
    procedure FillParameterTable( iStimElement : Integer ) ;
    procedure UpdateStimulusElement( iElement : Integer ) ;
    procedure DisplayStimulusProtocol( Prot : TStimulusProtocol ) ;
    procedure GetAmplitudeRange(
          Prot : TStimulusProtocol ;
          AONum : Integer ;                 // AO channel
          var YMin : Single ;               // Min. amplitude in protocol
          var YMax : Single                 // Max. amplitude in protocol
          ) ;
    function YScale(
          const AOPlot : TRect ;
          YMin : Single ;
          YMax : Single ;
          Y : Single
          ) : Integer ;
    function YScaleDig(
          const DOPlot : TRect ;
          DOChan : Single ;
          DigState : Integer
          ) : Integer ;

    function XScale(
          const AOPlot : TRect ;
          XMin : Single ;
          XMax : Single ;
          X : Single
          ) : Integer ;
    procedure FillRecordingTable ;
    procedure UpdateRecordingTableParameters ;

    procedure FillHolding ;
    procedure UpdateHolding ;

    procedure FillWaveShapes ;

    procedure FillGlobalVarsTable ;
    procedure UpdateGlobalVars ;

    procedure SetDORadioButton(
          var OnButton : TRadioButton ;         // On button
          var OffButton : TRadioButton ;        // Off button
          DOChan : Integer                  // Digital output channel #
          ) ;

    procedure SaveProtocol ;
    function SaveProtocolToXMLFile( FileName : String ) : String ;
    procedure LoadProtocolFromXMLFile( FileName : String ) ;
  public
    { Public declarations }
  end;

var
  EditProtocolFrm: TEditProtocolFrm;

implementation

uses MDIForm, Rec, DirectorySelectUnit, Sealtest;

{$R *.dfm}

const
    TTLWaveformHeight = 24 ;


procedure TEditProtocolFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
var
    i : Integer ;
begin

     DisableUpdates := True ;

     Page.Width := ParameterTableGrp.Left +  ParameterTableGrp.Width + 10 ;
     Height := Page.Height + 100 ;
     Width := Page.Left + Page.Width + 10 ;
     Width := 960 ;

     TUnits := 'ms' ;
     TScale := 1000.0 ;

     Prot.RecordDuration := 1.0 ;
     Prot.StimulusPeriod := 1.0 ;
     Prot.NumRecords := 10 ;
     Prot.NumRepeatsPerIncrement := 1 ;

     Prot.NumAOChannels := 1 ;
     cbNumAOChannels.ItemIndex := Prot.NumAOChannels-1 ;
     Prot.NumDOChannels := 1 ;
     cbNumDOChannels.ItemIndex := Prot.NumDOChannels-1 ;

     // Initialise to voltage channels
     for i := 0 to MaxAOChannels-1 do Prot.AOChannelUnits[i] := 'mV' ;

     // Populate Next Protocol list
     Stimulator.CreateProtocolList( cbNextProtocol ) ;

     // Clear
     Stimulator.ClearProtocol(Prot) ;

     // Set tag and hint properties of wave shape components
     // Note. tags contain the waveform type used in the TWaveform record }

     Step0.Tag := Ord( wvStep0 ) ;
     WaveShapeImage[Step0.Tag] := Step0 ;

     Step1.Tag := Ord( wvStep1 ) ;
     WaveShapeImage[Step1.Tag] := Step1 ;

     Step2.Tag := Ord( wvStep2 ) ;
     WaveShapeImage[Step2.Tag] := Step2 ;

     Ramp.Tag := Ord( wvRamp ) ;
     WaveShapeImage[Ramp.Tag] := Ramp ;

     PTRain.Tag := Ord( wvPTrain ) ;
     WaveShapeImage[PTRain.Tag] := PTRain ;

     PTRainHz.Tag := Ord( wvPTrainHz ) ;
     WaveShapeImage[PTRainHz.Tag] := PTRainHz ;

     Wave.Tag := Ord( wvWave ) ;
     WaveShapeImage[Wave.Tag] := Wave ;

     Sine.Tag := Ord( wvSine ) ;
     WaveShapeImage[Sine.Tag] := Sine ;

     PulseStaircase.Tag := Ord( wvPulseStaircase ) ;
     WaveShapeImage[PulseStaircase.Tag] := PulseStaircase ;

     None.Tag := Ord(wvNone) ;
     WaveShapeImage[None.Tag] := None ;
     None.hint := 'No analog waveform' ;

     DigStep0.tag := Ord(wvDigStep0) ;
     WaveShapeImage[DigStep0.Tag] := DigStep0 ;

     DigStep1.tag := Ord(wvDigStep1) ;
     WaveShapeImage[DigStep1.Tag] := DigStep1 ;

     DigTrain.tag := Ord(wvDigTrain) ;
     WaveShapeImage[DigTrain.Tag] := DigTrain ;

     DigTrainHz.tag := Ord(wvDigTrainHz) ;
     WaveShapeImage[DigTrainHz.Tag] := DigTrainHz ;

     DigWave.tag := Ord(wvDigWave) ;
     WaveShapeImage[DigWave.Tag] := DigWave ;

     DigNone.Tag := Ord(wvDigNone) ;
     WaveShapeImage[DigNone.Tag] := DigNone ;
     DigNone.hint := 'No digital waveform' ;

     // AO0
     Prot.Stimulus[0].Control := AO00 ;
     AO00.Tag := 0 ;
     Prot.Stimulus[1].Control := AO01 ;
     AO01.Tag := 1 ;
     Prot.Stimulus[2].Control := AO02 ;
     AO02.Tag := 2 ;
     Prot.Stimulus[3].Control := AO03 ;
     AO03.Tag := 3 ;
     Prot.Stimulus[4].Control := AO04 ;
     AO04.Tag := 4 ;
     Prot.Stimulus[5].Control := AO05 ;
     AO05.Tag := 5 ;
     Prot.Stimulus[6].Control := AO06 ;
     AO06.Tag := 6 ;
     Prot.Stimulus[7].Control := AO07 ;
     AO07.Tag := 7 ;
     Prot.Stimulus[8].Control := AO08 ;
     AO08.Tag := 8 ;
     Prot.Stimulus[9].Control := AO09 ;
     AO09.Tag := 9 ;

     // AO1
     Prot.Stimulus[10].Control := AO10 ;
     AO10.Tag := 10 ;
     Prot.Stimulus[11].Control := AO11 ;
     AO11.Tag := 11 ;
     Prot.Stimulus[12].Control := AO12 ;
     AO12.Tag := 12 ;
     Prot.Stimulus[13].Control := AO13 ;
     AO13.Tag := 13 ;
     Prot.Stimulus[14].Control := AO14 ;
     AO14.Tag := 14 ;
     Prot.Stimulus[15].Control := AO15 ;
     AO15.Tag := 15 ;
     Prot.Stimulus[16].Control := AO16 ;
     AO16.Tag := 16 ;
     Prot.Stimulus[17].Control := AO17 ;
     AO17.Tag := 17 ;
     Prot.Stimulus[18].Control := AO18 ;
     AO18.Tag := 18 ;
     Prot.Stimulus[19].Control := AO19 ;
     AO19.Tag := 19 ;

     // AO2
     Prot.Stimulus[20].Control := AO20 ;
     AO20.Tag := 20 ;
     Prot.Stimulus[21].Control := AO21 ;
     AO21.Tag := 21 ;
     Prot.Stimulus[22].Control := AO22 ;
     AO22.Tag := 22 ;
     Prot.Stimulus[23].Control := AO23 ;
     AO23.Tag := 23 ;
     Prot.Stimulus[24].Control := AO24 ;
     AO24.Tag := 24 ;
     Prot.Stimulus[25].Control := AO25 ;
     AO25.Tag := 25 ;
     Prot.Stimulus[26].Control := AO26 ;
     AO26.Tag := 26 ;
     Prot.Stimulus[27].Control := AO27 ;
     AO27.Tag := 27 ;
     Prot.Stimulus[28].Control := AO28 ;
     AO28.Tag := 28 ;
     Prot.Stimulus[29].Control := AO29 ;
     AO29.Tag := 29 ;

     // AO3
     Prot.Stimulus[30].Control := AO30 ;
     AO30.Tag := 30 ;
     Prot.Stimulus[31].Control := AO31 ;
     AO31.Tag := 31 ;
     Prot.Stimulus[32].Control := AO32 ;
     AO32.Tag := 32 ;
     Prot.Stimulus[33].Control := AO33 ;
     AO33.Tag := 33 ;
     Prot.Stimulus[34].Control := AO34 ;
     AO34.Tag := 34 ;
     Prot.Stimulus[35].Control := AO35 ;
     AO35.Tag := 35 ;
     Prot.Stimulus[36].Control := AO36 ;
     AO36.Tag := 36 ;
     Prot.Stimulus[37].Control := AO37 ;
     AO37.Tag := 37 ;
     Prot.Stimulus[38].Control := AO38 ;
     AO38.Tag := 38 ;
     Prot.Stimulus[39].Control := AO39 ;
     AO39.Tag := 39 ;

     // DO0
     Prot.Stimulus[40].Control := DO00 ;
     DO00.Tag := 40 ;
     Prot.Stimulus[41].Control := DO01 ;
     DO01.Tag := 41 ;
     Prot.Stimulus[42].Control := DO02 ;
     DO02.Tag := 42 ;
     Prot.Stimulus[43].Control := DO03 ;
     DO03.Tag := 43 ;
     Prot.Stimulus[44].Control := DO04 ;
     DO04.Tag := 44 ;
     Prot.Stimulus[45].Control := DO05 ;
     DO05.Tag := 45 ;
     Prot.Stimulus[46].Control := DO06 ;
     DO06.Tag := 46 ;
     Prot.Stimulus[47].Control := DO07 ;
     DO07.Tag := 47 ;
     Prot.Stimulus[48].Control := DO08 ;
     DO08.Tag := 48 ;
     Prot.Stimulus[49].Control := DO09 ;
     DO09.Tag := 49 ;

     // DO1
     Prot.Stimulus[50].Control := DO10 ;
     DO10.Tag := 50 ;
     Prot.Stimulus[51].Control := DO11 ;
     DO11.Tag := 51 ;
     Prot.Stimulus[52].Control := DO12 ;
     DO12.Tag := 52 ;
     Prot.Stimulus[53].Control := DO13 ;
     DO13.Tag := 53 ;
     Prot.Stimulus[54].Control := DO14 ;
     DO14.Tag := 54 ;
     Prot.Stimulus[55].Control := DO15 ;
     DO15.Tag := 55 ;
     Prot.Stimulus[56].Control := DO16 ;
     DO16.Tag := 56 ;
     Prot.Stimulus[57].Control := DO17 ;
     DO17.Tag := 57 ;
     Prot.Stimulus[58].Control := DO18 ;
     DO18.Tag := 58 ;
     Prot.Stimulus[59].Control := DO19 ;
     DO19.Tag := 59 ;

     // DO2
     Prot.Stimulus[60].Control := DO20 ;
     DO20.Tag := 60 ;
     Prot.Stimulus[61].Control := DO21 ;
     DO21.Tag := 61 ;
     Prot.Stimulus[62].Control := DO22 ;
     DO22.Tag := 62 ;
     Prot.Stimulus[63].Control := DO23 ;
     DO23.Tag := 63 ;
     Prot.Stimulus[64].Control := DO24 ;
     DO24.Tag := 64 ;
     Prot.Stimulus[65].Control := DO25 ;
     DO25.Tag := 65 ;
     Prot.Stimulus[66].Control := DO26 ;
     DO26.Tag := 66 ;
     Prot.Stimulus[67].Control := DO27 ;
     DO27.Tag := 67 ;
     Prot.Stimulus[68].Control := DO28 ;
     DO28.Tag := 68 ;
     Prot.Stimulus[69].Control := DO29 ;
     DO29.Tag := 69 ;

     // DO3
     Prot.Stimulus[70].Control := DO30 ;
     DO30.Tag := 70 ;
     Prot.Stimulus[71].Control := DO31 ;
     DO31.Tag := 71 ;
     Prot.Stimulus[72].Control := DO32 ;
     DO32.Tag := 72 ;
     Prot.Stimulus[73].Control := DO33 ;
     DO33.Tag := 73 ;
     Prot.Stimulus[74].Control := DO34 ;
     DO34.Tag := 74 ;
     Prot.Stimulus[75].Control := DO35 ;
     DO35.Tag := 75 ;
     Prot.Stimulus[76].Control := DO36 ;
     DO36.Tag := 76 ;
     Prot.Stimulus[77].Control := DO37 ;
     DO37.Tag := 77 ;
     Prot.Stimulus[78].Control := DO38 ;
     DO38.Tag := 78 ;
     Prot.Stimulus[79].Control := DO39 ;
     DO39.Tag := 79 ;

     // DO4
     Prot.Stimulus[80].Control := DO40 ;
     DO40.Tag := 80 ;
     Prot.Stimulus[81].Control := DO41 ;
     DO41.Tag := 81 ;
     Prot.Stimulus[82].Control := DO42 ;
     DO42.Tag := 82 ;
     Prot.Stimulus[83].Control := DO43 ;
     DO43.Tag := 83 ;
     Prot.Stimulus[84].Control := DO44 ;
     DO44.Tag := 84 ;
     Prot.Stimulus[85].Control := DO45 ;
     DO45.Tag := 85 ;
     Prot.Stimulus[86].Control := DO46 ;
     DO46.Tag := 86 ;
     Prot.Stimulus[87].Control := DO47 ;
     DO47.Tag := 87 ;
     Prot.Stimulus[88].Control := DO48 ;
     DO48.Tag := 88 ;
     Prot.Stimulus[89].Control := DO49 ;
     DO49.Tag := 89 ;

     // DO5
     Prot.Stimulus[90].Control := DO50 ;
     DO50.Tag := 90 ;
     Prot.Stimulus[91].Control := DO51 ;
     DO51.Tag := 91 ;
     Prot.Stimulus[92].Control := DO52 ;
     DO52.Tag := 92 ;
     Prot.Stimulus[93].Control := DO53 ;
     DO53.Tag := 93 ;
     Prot.Stimulus[94].Control := DO54 ;
     DO54.Tag := 94 ;
     Prot.Stimulus[95].Control := DO55 ;
     DO55.Tag := 95 ;
     Prot.Stimulus[96].Control := DO56 ;
     DO56.Tag := 96 ;
     Prot.Stimulus[97].Control := DO57 ;
     DO57.Tag := 97 ;
     Prot.Stimulus[98].Control := DO58 ;
     DO58.Tag := 98 ;
     Prot.Stimulus[99].Control := DO59 ;
     DO59.Tag := 99 ;

     // DO6
     Prot.Stimulus[100].Control := DO60 ;
     DO60.Tag := 100 ;
     Prot.Stimulus[101].Control := DO61 ;
     DO61.Tag := 101 ;
     Prot.Stimulus[102].Control := DO62 ;
     DO62.Tag := 102 ;
     Prot.Stimulus[103].Control := DO63 ;
     DO63.Tag := 103 ;
     Prot.Stimulus[104].Control := DO64 ;
     DO64.Tag := 104 ;
     Prot.Stimulus[105].Control := DO65 ;
     DO65.Tag := 105 ;
     Prot.Stimulus[106].Control := DO66 ;
     DO66.Tag := 106 ;
     Prot.Stimulus[107].Control := DO67 ;
     DO67.Tag := 107 ;
     Prot.Stimulus[108].Control := DO68 ;
     DO68.Tag := 108 ;
     Prot.Stimulus[109].Control := DO69 ;
     DO69.Tag := 109 ;

     // DO7
     Prot.Stimulus[110].Control := DO70 ;
     DO70.Tag := 110 ;
     Prot.Stimulus[111].Control := DO71 ;
     DO71.Tag := 111 ;
     Prot.Stimulus[112].Control := DO72 ;
     DO72.Tag := 112 ;
     Prot.Stimulus[113].Control := DO73 ;
     DO73.Tag := 113 ;
     Prot.Stimulus[114].Control := DO74 ;
     DO74.Tag := 114 ;
     Prot.Stimulus[115].Control := DO75 ;
     DO75.Tag := 115 ;
     Prot.Stimulus[116].Control := DO76 ;
     DO76.Tag := 116 ;
     Prot.Stimulus[117].Control := DO77 ;
     DO77.Tag := 117 ;
     Prot.Stimulus[118].Control := DO78 ;
     DO78.Tag := 118 ;
     Prot.Stimulus[119].Control := DO79 ;
     DO79.Tag := 119 ;

     // Create stimulus units and set selection lists

     StimType[0].Name := 'Voltage (mV)' ;
     StimType[0].Units := 'mV' ;
     StimType[0].Scale := 1000. ;
     StimType[1].Name := 'Voltage (V)' ;
     StimType[1].Units := 'V' ;
     StimType[1].Scale := 1. ;
     StimType[2].Name := 'Current (pA)' ;
     StimType[2].Units := 'pA' ;
     StimType[2].Scale := 1E12 ;
     StimType[3].Name := 'Current (nA)' ;
     StimType[3].Units := 'nA' ;
     StimType[3].Scale := 1E9 ;
     StimType[4].Name := 'Current (uA)' ;
     StimType[4].Units := 'uA' ;
     StimType[4].Scale := 1E6 ;
     StimType[5].Name := 'Current (mA)' ;
     StimType[5].Units := 'mA' ;
     StimType[5].Scale := 1E3 ;
     StimType[6].Name := 'Current (A)' ;
     StimType[6].Units := 'A' ;
     StimType[6].Scale := 1. ;

     cbAO0Stim.Clear ;
     for i := 0 to MaxStimType do cbAO0Stim.Items.Add(StimType[i].Name) ;
     cbAO1Stim.Items.Assign(cbAO0Stim.Items) ;
     cbAO2Stim.Items.Assign(cbAO0Stim.Items) ;
     cbAO3Stim.Items.Assign(cbAO0Stim.Items) ;
     cbAO0Stim.ItemIndex := 0 ;
     cbAO1Stim.ItemIndex := 0 ;
     cbAO2Stim.ItemIndex := 0 ;
     cbAO3Stim.ItemIndex := 0 ;

     RecordingParametersTableChanged := False ;
     StimulusParametersTableChanged := False ;
     DisableUpdates := False ;

     if (Settings.VProgramFileName = '') or
        ANSIContainsText(Settings.VProgramFileName,'\ .') or
        (not FileExists(Settings.VProgramFileName)) then begin
        // Create empty protocol
        bNew.Click ;
        end
     else begin
        // Load currently selected protocol
        FileName := Settings.VProgramFileName ;
        Caption := 'Protocol: ' + FileName ;
        LoadProtocolFromXMLFile( FileName ) ;
        end ;
     Resize ;

     AdjustWaveformPalettes ;

     end;


procedure TEditProtocolFrm.AdjustWaveformPalettes ;
// ---------------------------------------------------------
// Adjust visibility/position of selected AO and DO palettes
// ---------------------------------------------------------
var
    i,iTop,iLeft : Integer ;
begin

    DO1Panel.Visible := False ;
    DO2Panel.Visible := False ;
    DO3Panel.Visible := False ;
    DO4Panel.Visible := False ;
    DO5Panel.Visible := False ;
    DO6Panel.Visible := False ;
    DO7Panel.Visible := False ;

    AO0Tab.Caption := 'AO0' ;
    AO0StimGrp.Visible := True ;

    NumAOChannels := cbNumAOChannels.ItemIndex + 1 ;
    if NumAOChannels > 1 then begin
       AO1Tab.Caption := 'AO1' ;
       AO1StimGrp.Visible := True ;
       end
    else begin
       AO1Tab.Caption := '' ;
       AO1StimGrp.Visible := False ;
       end ;

    if NumAOChannels > 2 then begin
       AO2Tab.Caption := 'AO2' ;
       AO2StimGrp.Visible := True ;
       end
    else begin
       AO2Tab.Caption := '' ;
       AO2StimGrp.Visible := False ;
       end ;

    if NumAOChannels > 3 then begin
       AO3Tab.Caption := 'AO3' ;
       AO3StimGrp.Visible := True ;
       end
    else begin
       AO3Tab.Caption := '' ;
       AO3StimGrp.Visible := False ;
       end ;

    // Set AO panel visibility
    AO0Panel.Visible := AO0StimGrp.Visible ;
    AO1Panel.Visible := AO1StimGrp.Visible ;
    AO2Panel.Visible := AO2StimGrp.Visible ;
    AO3Panel.Visible := AO3StimGrp.Visible ;

    iTop := AO0Panel.Top + AO0Panel.Height ;
    AO1Panel.Top := iTop ;
    if AO1Panel.Visible then iTop := iTop + AO1Panel.Height ;
    AO2Panel.Top := iTop ;
    if AO2Panel.Visible then iTop := iTop + AO2Panel.Height ;
    AO3Panel.Top := iTop ;
    if AO3Panel.Visible then iTop := iTop + AO3Panel.Height ;

    // Set DO panel visibility
    NumDOChannels := cbNumDOChannels.ItemIndex + 1 ;
    if NumDOChannels > 1 then DO1Panel.Visible := True ;
    if NumDOChannels > 2 then DO2Panel.Visible := True ;
    if NumDOChannels > 3 then DO3Panel.Visible := True ;
    if NumDOChannels > 4 then DO4Panel.Visible := True ;
    if NumDOChannels > 5 then DO5Panel.Visible := True ;
    if NumDOChannels > 6 then DO6Panel.Visible := True ;
    if NumDOChannels > 7 then DO7Panel.Visible := True ;

    DO0Panel.Top := iTop ;
    if DO0Panel.Visible then iTop := iTop + DO0Panel.Height ;
    DO1Panel.Top := iTop ;
    if DO1Panel.Visible then iTop := iTop + DO1Panel.Height ;
    DO2Panel.Top := iTop ;
    if DO2Panel.Visible then iTop := iTop + DO2Panel.Height ;
    DO3Panel.Top := iTop ;
    if DO3Panel.Visible then iTop := iTop + DO3Panel.Height ;
    DO4Panel.Top := iTop ;
    if DO4Panel.Visible then iTop := iTop + DO4Panel.Height ;
    DO5Panel.Top := iTop ;
    if DO5Panel.Visible then iTop := iTop + DO5Panel.Height ;
    DO6Panel.Top := iTop ;
    if DO6Panel.Visible then iTop := iTop + DO6Panel.Height ;
    DO7Panel.Top := iTop ;
    if DO7Panel.Visible then iTop := iTop + DO7Panel.Height ;

    ProtocolGrp.ClientHeight := iTop + 5 ;
    ProtocolGrp.Height := Max( ProtocolGrp.Height,ToolBoxGrp.Height) ;
    Page.Height := ProtocolGrp.Top + ProtocolGrp.Height + 40 ;

    // Display DO stimulus holding level
    iLeft := DO0Hold.Left + DO0Hold.Width ;
    DO1Hold.Visible := DO1Panel.Visible ;
    DO1Hold.Left := iLeft ;
    if DO1Hold.Visible then iLeft := iLeft + DO0Hold.Width ;
    DO2Hold.Visible := DO2Panel.Visible ;
    DO2Hold.Left := iLeft ;
    if DO2Hold.Visible then iLeft := iLeft + DO0Hold.Width ;
    DO3Hold.Visible := DO3Panel.Visible ;
    DO3Hold.Left := iLeft ;
    if DO3Hold.Visible then iLeft := iLeft + DO0Hold.Width ;
    DO4Hold.Visible := DO4Panel.Visible ;
    DO4Hold.Left := iLeft ;
    if DO4Hold.Visible then iLeft := iLeft + DO0Hold.Width ;
    DO5Hold.Visible := DO5Panel.Visible ;
    DO5Hold.Left := iLeft ;
    if DO5Hold.Visible then iLeft := iLeft + DO0Hold.Width ;
    DO6Hold.Visible := DO6Panel.Visible ;
    DO6Hold.Left := iLeft ;
    if DO6Hold.Visible then iLeft := iLeft + DO0Hold.Width ;
    DO7Hold.Visible := DO7Panel.Visible ;
    DO7Hold.Left := iLeft ;
    if DO7Hold.Visible then iLeft := iLeft + DO0Hold.Width ;

    // Stimulus waveform element parameter names

    ParNames[spDelay] := 'Delay' ;
    ParNames[spDelayInc] := 'Delay (increment) ' ;
    ParNames[spStartAmplitude] := 'Amplitude ' ;
    ParNames[spStartAmplitudeInc] := 'Amplitude (increment) ' ;
    ParNames[spEndAmplitude] :=  'End Amplitude ' ; ;
    ParNames[spEndAmplitudeInc] := 'End Amplitude (increment) ' ; ;
    ParNames[spDuration] := 'Duration ' ;
    ParNames[spDurationInc] := 'Duration (increment) ' ;
    ParNames[spNumRepeats] := 'No. repeats ' ;
    ParNames[spNumRepeatsInc] := 'No. repeats (increment) ' ;
    ParNames[spRepeatPeriod] := 'Repeat period ' ;
    ParNames[spRepeatPeriodInc] := 'Repeat period (increment) ' ;
    ParNames[spDigAmplitude]  := 'State (0=0V,1=5V) ' ;
    ParNames[spFileName] := 'File name ' ;
    ParNames[spDACUpdateInterval] := 'D/A update interval ' ;
    ParNames[spNumPoints] := 'No. points ' ;
    ParNames[spNumPointsInc] := 'Starting point (increment) ' ;
    ParNames[spFrequency] := 'Frequency ' ;
    ParNames[spFrequencyInc] := 'Frequency (increment) ' ;
    ParNames[spScale] := 'Scale by ' ;
    ParNames[spScaleInc] := 'Scale by (increment) ' ;
    ParNames[spOffset] := 'Offset by ' ;
    ParNames[spOffsetInc] := 'Offset by (increment) ' ;
    ParNames[spFrequencyMultiplierFlag] := 'Multiply by increment (1=Y,0=N) ' ;

    Table.ColWidths[0] := 150 ;
    for i := 0 to High(ParNames) do begin
        Table.ColWidths[0] := Max( Table.ColWidths[0],
                                   Table.canvas.TextWidth(ParNames[i]) + 20) ;
        end ;
//    TUnits := 'ms' ;
//    TScale := 1000.0 ;

    SelectedStimulusElement := 0 ;

    pbDisplay.Invalidate ;

    end ;


procedure TEditProtocolFrm.GetParameterList(
           iElement : Integer ;                      // Waveform element in stimulus array
           var ParamList : Array of TParameterList   // Parameter list for element
           ) ;
// -------------------------------------------------------
// Return list of parameters required for stimulus element
// -------------------------------------------------------
var
    i : Integer ;
    StimType : String ;
begin

    StimType := GetStimElementUnits( iElement ) ;

    // Clear list
    for i := 0 to High(ParamList) do ParamList[i].Index := -1 ;

    // Add parameters for this wave shape

    Case Prot.Stimulus[iElement].WaveShape of

        wvStep0 : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spStartAmplitude ;
           ParamList[1].Units := StimType ;
           ParamList[1].Scale := 1.0 ;
           ParamList[2].Index := spDuration ;
           ParamList[2].Units := TUnits ;
           ParamList[2].Scale := TScale ;
           end ;

        wvStep1 : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spStartAmplitude ;
           ParamList[1].Units := StimType ;
           ParamList[1].Scale := 1.0 ;
           ParamList[2].Index := spStartAmplitudeInc ;
           ParamList[2].Units := StimType ;
           ParamList[2].Scale := 1.0 ;
           ParamList[3].Index := spDuration ;
           ParamList[3].Units := TUnits ;
           ParamList[3].Scale := TScale ;
           end ;

        wvStep2 : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units :=  TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spStartAmplitude ;
           ParamList[1].Units := StimType ;
           ParamList[1].Scale := 1. ;
           ParamList[2].Index := spDuration ;
           ParamList[2].Units :=  TUnits ;
           ParamList[2].Scale := TScale ;
           ParamList[3].Index := spDurationInc ;
           ParamList[3].Units := TUnits ;
           ParamList[3].Scale := TScale ;
           end ;

        wvRamp : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spStartAmplitude ;
           ParamList[1].Units := StimType ;
           ParamList[1].Scale := 1. ;
           ParamList[2].Index := spEndAmplitude ;
           ParamList[2].Units := StimType ;
           ParamList[2].Scale := 1. ;
           ParamList[3].Index := spDuration ;
           ParamList[3].Units := TUnits ;
           ParamList[3].Scale := TScale ;
           end ;

        wvPTrain : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spStartAmplitude ;
           ParamList[1].Units := StimType ;
           ParamList[1].Scale := 1. ;
           ParamList[2].Index := spDuration ;
           ParamList[2].Units :=  TUnits ;
           ParamList[2].Scale := TScale ;
           ParamList[3].Index := spRepeatPeriod ;
           ParamList[3].Units :=  TUnits ;
           ParamList[3].Scale := TScale ;
           ParamList[4].Index := spRepeatPeriodInc ;
           ParamList[4].Units :=  TUnits ;
           ParamList[4].Scale := TScale ;
           ParamList[5].Index := spNumRepeats ;
           ParamList[5].Units := '' ;
           ParamList[5].Scale := 1. ;
           end ;

        wvPTrainHz : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spStartAmplitude ;
           ParamList[1].Units := StimType ;
           ParamList[1].Scale := 1. ;
           ParamList[2].Index := spDuration ;
           ParamList[2].Units :=  TUnits ;
           ParamList[2].Scale := TScale ;
           ParamList[3].Index := spFrequency ;
           ParamList[3].Units :=  'Hz' ;
           ParamList[3].Scale := 1.0 ;
           ParamList[4].Index := spFrequencyInc ;
           ParamList[4].Units :=  'Hz' ;
           ParamList[4].Scale := 1.0 ;
           ParamList[5].Index := spNumRepeats ;
           ParamList[5].Units := '' ;
           ParamList[5].Scale := 1. ;
           end ;

        wvSine : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spStartAmplitude ;
           ParamList[1].Units := StimType ;
           ParamList[1].Scale := 1. ;
           ParamList[2].Index := spStartAmplitudeInc ;
           ParamList[2].Units := StimType ;
           ParamList[2].Scale := 1.0 ;
           ParamList[3].Index := spDuration ;
           ParamList[3].Units :=  TUnits ;
           ParamList[3].Scale := TScale ;
           ParamList[4].Index := spFrequency ;
           ParamList[4].Units :=  'Hz' ;
           ParamList[4].Scale := 1.0 ;
           ParamList[5].Index := spFrequencyInc ;
           ParamList[5].Units :=  'Hz' ;
           ParamList[5].Scale := 1.0 ;
           ParamList[6].Index := spFrequencyMultiplierFlag ;
           ParamList[6].Units :=  '' ;
           ParamList[6].Scale := 1.0 ;
           end ;

        wvPulseStaircase : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spStartAmplitude ;
           ParamList[1].Units := StimType ;
           ParamList[1].Scale := 1. ;
           ParamList[2].Index := spEndAmplitude ;
           ParamList[2].Units := StimType ;
           ParamList[2].Scale := 1.0 ;
           ParamList[3].Index := spDuration ;
           ParamList[3].Units :=  TUnits ;
           ParamList[3].Scale := TScale ;
           ParamList[4].Index := spRepeatPeriod ;
           ParamList[4].Units :=  TUnits ;
           ParamList[4].Scale := TScale ;
           ParamList[5].Index := spNumRepeats ;
           ParamList[5].Units := '' ;
           ParamList[5].Scale := 1. ;
           end ;

        wvDigStep0 : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spDigAmplitude ;
           ParamList[1].Units := '' ;
           ParamList[1].Scale := 1. ;
           ParamList[2].Index := spDuration ;
           ParamList[2].Units := TUnits ;
           ParamList[2].Scale := TScale ;
           end ;
        wvDigStep1 : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spDigAmplitude ;
           ParamList[1].Units := '' ;
           ParamList[1].Scale := 1. ;
           ParamList[2].Index := spDuration ;
           ParamList[2].Units := TUnits ;
           ParamList[2].Scale := TScale ;
           ParamList[3].Index := spDurationInc ;
           ParamList[3].Units := TUnits ;
           ParamList[3].Scale := TScale ;
           end ;
        wvDigTrain : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spDigAmplitude ;
           ParamList[1].Units := '' ;
           ParamList[1].Scale := 1. ;
           ParamList[2].Index := spDuration ;
           ParamList[2].Units := TUnits ;
           ParamList[2].Scale := TScale ;
           ParamList[3].Index := spRepeatPeriod ;
           ParamList[3].Units := TUnits ;
           ParamList[3].Scale := TScale ;
           ParamList[4].Index := spRepeatPeriodInc ;
           ParamList[4].Units := TUnits ;
           ParamList[4].Scale := TScale ;
           ParamList[5].Index := spNumRepeats ;
           ParamList[5].Units := '' ;
           ParamList[5].Scale := 1. ;
           end ;
        wvDigTrainHz : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spDigAmplitude ;
           ParamList[1].Units := '' ;
           ParamList[1].Scale := 1. ;
           ParamList[2].Index := spDuration ;
           ParamList[2].Units := TUnits ;
           ParamList[2].Scale := TScale ;
           ParamList[3].Index := spFrequency ;
           ParamList[3].Units :=  'Hz' ;
           ParamList[3].Scale := 1.0 ;
           ParamList[4].Index := spFrequencyInc ;
           ParamList[4].Units :=  'Hz' ;
           ParamList[4].Scale := 1.0 ;
           ParamList[5].Index := spNumRepeats ;
           ParamList[5].Units := '' ;
           ParamList[5].Scale := 1. ;
           end ;
        wvWave : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spFileName ;
           ParamList[1].Units := '' ;
           ParamList[1].Scale := 0.0 ;
           ParamList[2].Index := spDACUpdateInterval ;
           ParamList[2].Units := TUnits ;
           ParamList[2].Scale := TScale ;
           ParamList[3].Index := spNumPoints ;
           ParamList[3].Units := '' ;
           ParamList[3].Scale := 1.0 ;
           ParamList[4].Index := spNumPointsInc ;
           ParamList[4].Units := '' ;
           ParamList[4].Scale := 1.0 ;
           ParamList[5].Index := spScale ;
           ParamList[5].Units := '' ;
           ParamList[5].Scale := 1.0 ;
           ParamList[6].Index := spScaleInc ;
           ParamList[6].Units := '' ;
           ParamList[6].Scale := 1.0 ;
           ParamList[7].Index := spOffset ;
           ParamList[7].Units := StimType ;
           ParamList[7].Scale := 1.0 ;
           ParamList[8].Index := spOffsetInc ;
           ParamList[8].Units := StimType ;
           ParamList[8].Scale := 1.0 ;
           end ;
        wvDigWave : begin
           ParamList[0].Index := spDelay ;
           ParamList[0].Units := TUnits ;
           ParamList[0].Scale := TScale ;
           ParamList[1].Index := spFileName ;
           ParamList[1].Units := '' ;
           ParamList[1].Scale := 0.0 ;
           ParamList[2].Index := spDACUpdateInterval ;
           ParamList[2].Units := TUnits ;
           ParamList[2].Scale := TScale ;
           ParamList[3].Index := spNumPoints ;
           ParamList[3].Units := '' ;
           ParamList[3].Scale := 1.0 ;
           ParamList[4].Index := spNumPointsInc ;
           ParamList[4].Units := '' ;
           ParamList[4].Scale := 1.0 ;
           end ;

        end ;

    end ;


function TEditProtocolFrm.GetStimElementName( iElement : Integer ) : string ;
// -------------------------------
// Return name of selected element
// -------------------------------
begin
    if iElement < DOElementsStart then begin
       Result := format( 'AO %d: Waveform %d',
                 [iElement div MaxStimElementsPerChannels,
                  iElement mod MaxStimElementsPerChannels ] ) ;
       end
    else begin
       Result := format( 'DO %d: Waveform %d',
                 [(iElement-DOElementsStart) div MaxStimElementsPerChannels,
                  (iElement-DOElementsStart) mod MaxStimElementsPerChannels ] ) ;
       end
    end ;


function TEditProtocolFrm.GetStimElementUnits( iElement : Integer ) : string ;
// -----------------------------------------
// Return stimulus units of selected element
// -----------------------------------------
var
    AOChan : Integer ;
begin
    if iElement < DOElementsStart then begin
       AOChan := Min(Max(iElement div MaxStimElementsPerChannels,0),MaxAOChannels) ;
       Result := Prot.AOChannelUnits[AOChan] ;
       end
    else begin
       Result := '' ;
       end
    end ;


procedure TEditProtocolFrm.GlobalVarTableKeyPress(Sender: TObject;
  var Key: Char);
// -----------------------------------
// Key pressed over global vars table
// -----------------------------------
begin
     GlobalVarsTableChanged := True ;
     if Key = #13 then begin
        UpdateGlobalVars ;
        FillGlobalVarsTable ;
        UpdateStimulusElement( SelectedStimulusElement ) ;
        FillParameterTable( SelectedStimulusElement ) ;
        end ;
     end;


procedure TEditProtocolFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
// ------------------------
// Actions when form closed
// ------------------------
begin

     if RecordingParametersTableChanged then UpdateRecordingTableParameters ;
     if StimulusParametersTableChanged then UpdateStimulusElement( SelectedStimulusElement ) ;
     if GlobalVarsTableChanged then UpdateGlobalVars ;

     if not Prot.Saved then begin
        if MessageDlg(
           format('Protocol Changed! Update file: %s ? ',[FileName]),
           mtConfirmation,[mbYes,mbNo], 0 ) = mrYes then begin
           if FileName <> '' then FileName := SaveProtocolToXMLFile(FileName)
                             else SaveProtocol ;
           end ;
        end ;
     Action := caFree ;
     end;


procedure TEditProtocolFrm.FormResize(Sender: TObject);
// ---------------------------------
// Adjust controls when form resized
// ---------------------------------
begin

    Page.Width := ClientWidth - Page.Left - 5 ;
    Page.Top := ClientHeight - Page.Height - 5 ;

    DisplayGrp.Width := ClientWidth - DisplayGrp.Left - 5 ;
    DisplayGrp.Height := Page.Top - DisplayGrp.Top - 2 ;

    pbDisplay.Width := Max(DisplayGrp.ClientWidth - pbDisplay.Left - 2,2) ;
    pbDisplay.Height := Max(DisplayGrp.ClientHeight - pbDisplay.Top - 2,2) ;

    end;


procedure TEditProtocolFrm.cbNumAOChannelsChange(Sender: TObject);
// --------------------------
// No. of AO channels changed
// --------------------------
begin
     Prot.NumAOChannels := cbNumAOChannels.ItemIndex + 1 ;
     AdjustWaveformPalettes ;
     Prot.Saved := False ;
     end;


procedure TEditProtocolFrm.cbNumDOChannelsChange(Sender: TObject);
// --------------------------
// No. of AO channels changed
// --------------------------
begin
     Prot.NumDOChannels := cbNumDOChannels.ItemIndex + 1 ;
     AdjustWaveformPalettes ;
     Prot.Saved := False ;
     end;


procedure TEditProtocolFrm.Step0MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
// ------------------------------------------------------
// Mouse down on waveform palette icon - select waveshape
// -------------------------------------------------
begin
     SelectedWaveform := TImage(Sender).Tag ;
     TIMage(Sender).BeginDrag( False ) ;
     end ;


procedure TEditProtocolFrm.AO00DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
// ---------------------------------------------
// If dragged icon is an analog waveform - accept it
// ---------------------------------------------
begin
     if TImage(Source).Picture.Height = TImage(Sender).Picture.Height then
        accept := True
     else Accept := False ;

     end;


procedure TEditProtocolFrm.AO00DragDrop(Sender, Source: TObject; X,
  Y: Integer);
{ ------------------------------------------------------------
  Accept analogue waveform tool dropped on to waveform icon
  ------------------------------------------------------------}
//var
//   iTag : Integer ;
begin

    // Update current parameter table
    UpdateStimulusElement( SelectedStimulusElement ) ;

     //iTag := TImage(Sender).Tag ;
     if  TImage(Source).Picture.Height = TImage(Sender).Picture.Height then begin
        TIMage(Sender).Picture := TImage(Source).Picture ;
        Prot.Stimulus[TImage(Sender).Tag].WaveShape := TImage(Source).Tag ;
        end ;

     FillParameterTable( TImage(Sender).Tag ) ;
     UpdateStimulusElement( SelectedStimulusElement ) ;
     pbDisplay.Invalidate ;

     end;



procedure TEditProtocolFrm.Image31DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
// ---------------------------------------------
// If dragged icon is a digital waveform - accept it
// ---------------------------------------------
begin
     if TImage(Source).Picture.Height = TTLWaveformHeight then accept := True
                                                          else Accept := False ;

     end;


procedure TEditProtocolFrm.Image31DragDrop(Sender, Source: TObject; X,
  Y: Integer);
{ ------------------------------------------------------------
  Accept digital waveform tool dropped on to waveform icon
  ------------------------------------------------------------}
begin
     if  TImage(Source).Picture.Height = TTLWaveformHeight then begin
        TIMage(Sender).Picture := TImage(Source).Picture ;
        end ;
     end;


procedure TEditProtocolFrm.FillParameterTable( iStimElement : Integer ) ;
// ------------------------------------------------
// Fill edit table with stimulus element parameters
// ------------------------------------------------
var
    ParList : Array[0..MaxPars] of TParameterList ;
    i,g,iRow : Integer ;
    Value : single ;
    s : string ;
begin

    SelectedStimulusElement := iStimElement ;

    // Highlight selected element
    for i := 0 to High(Prot.Stimulus) do
        if Prot.Stimulus[i].Control.Transparent then
           Prot.Stimulus[i].Control.Transparent := False ;
    Prot.Stimulus[iStimElement].Control.Transparent := True ;

    ParameterTableGrp.Caption := ' ' + GetStimElementName(iStimElement) + ' ' ;

    // Get list of parameters for this waveform element
    GetParameterList( iStimElement, ParList ) ;

    // Initialise settings if this is a new protocol
    if  (Prot.Stimulus[iStimElement].Parameters[spStartAmplitude].Value = 0.0) and
        (Prot.Stimulus[iStimElement].Parameters[spStartAmplitudeInc].Value = 0.0) and
        (Prot.Stimulus[iStimElement].Parameters[spNumPoints].Value = 0.0) and
        (Prot.Stimulus[iStimElement].Parameters[spDuration].Value = 0.0) then
        begin
        Prot.Stimulus[iStimElement].Parameters[spDelay].Value := 0.01 ;
        Prot.Stimulus[iStimElement].Parameters[spStartAmplitude].Value := 10.0 ;
        Prot.Stimulus[iStimElement].Parameters[spStartAmplitudeInc].Value := 10.0 ;
        Prot.Stimulus[iStimElement].Parameters[spDuration].Value := 1E-2 ;
        Prot.Stimulus[iStimElement].Parameters[spNumRepeats].Value := 2.0 ;
        Prot.Stimulus[iStimElement].Parameters[spRepeatPeriod].Value := 0.02 ;
        Prot.Stimulus[iStimElement].Parameters[spFrequency].Value := 10.0 ;
        Prot.Stimulus[iStimElement].Parameters[spFrequencyInc].Value := 0.0 ;
        Prot.Stimulus[iStimElement].Parameters[spScale].Value := 1.0 ;
        Prot.Stimulus[iStimElement].Parameters[spScaleInc].Value := 0.0 ;
        Prot.Stimulus[iStimElement].Parameters[spOffset].Value := 0.0 ;
        Prot.Stimulus[iStimElement].Parameters[spOffsetInc].Value := 0.0 ;
        end;

    Table.RowCount := 1 ;
    Table.cells[0,0] := '' ;
    Table.cells[1,0] := '' ;

    iRow := -1 ;
    bLoadFile.Visible := False ;
    for i := 0 to High(ParList) do if ParList[i].Index >= 0 then
        begin
        Inc(IRow) ;
        Table.cells[0,iRow] := ParNames[ParList[i].Index] ;
        if ParList[i].Scale <> 0.0 then
           begin
           Value := Prot.Stimulus[iStimElement].Parameters[ParList[i].Index].Value ;
           // Substitute G1 ... G5 if global variable code present
           s := format('%.6g %s',[Value*ParList[i].Scale,ParList[i].Units]);
           for g := 0 to High(Stimulator.GlobalVarFlag) do
               if Value = Stimulator.GlobalVarFlag[g] then s := format('G%d',[g+1]) ;
           Table.cells[1,iRow] := s ;
           end
        else
           begin
           Table.cells[1,iRow] := Prot.Stimulus[iStimElement].Parameters[ParList[i].Index].Text ;
           end ;
        Prot.Stimulus[iStimElement].Parameters[ParList[i].Index].Exists := True ;

        // Display file load button for file name
        if ParList[i].Index = spFileName then
           begin
           bLoadFile.Left := {Table.ColWidths[0] + Table.ColWidths[1]} + Table.Left + Table.Width + 2 ;
           bLoadFile.Top := Table.RowHeights[0]*iRow  + Table.Top + 2 ;
           bLoadFile.Visible := True ;
           bLoadFile.Tag := iRow ;
           end ;

        Table.RowCount := iRow + 1 ;
        end ;

    StimulusParametersTableChanged := False ;

    end ;


procedure TEditProtocolFrm.UpdateStimulusElement( iElement : Integer ) ;
// --------------------------------------------------
// Update stimulus element with parameters from table
// --------------------------------------------------
{$O-}
var
    ParList : Array[0..MaxPars] of TParameterList ;
    i,g,iRow : Integer ;
    Val,KeepDACUpdateInterval : Single ;
    KeepNumPoints : Integer ;
    s : string ;
begin

    if DisableUpdates then Exit ;
    if (iElement < 0) or (iElement > High(Prot.Stimulus)) then Exit ;

    Prot.Stimulus[iElement].Control.Transparent := False ;

    // Clear element parameter list
    for i := 0 to High(Prot.Stimulus[iElement].Parameters) do
        Prot.Stimulus[iElement].Parameters[i].Exists := False ;

    // Get list of parameters for this waveform element
    GetParameterList( iElement, ParList ) ;

    iRow := -1 ;
    KeepDACUpdateInterval := 0.0 ;
    KeepNumPoints := 0 ;
    for i := 0 to MaxPars do if ParList[i].Index >= 0 then begin
        Inc(iRow) ;

        // Load new file if file name has changed
        if (ParList[i].Index = spFileName) and (Table.cells[1,iRow] <>
            Prot.Stimulus[iElement].Parameters[ParList[i].Index].Text) then begin
            Stimulator.LoadWaveformFromTextFile(Prot,iElement,Table.cells[1,iRow]) ;
            KeepDACUpdateInterval := Prot.Stimulus[iElement].Parameters[spDACUpdateInterval].Value ;
            KeepNumPoints := Round(Prot.Stimulus[iElement].Parameters[spNumPoints].Value) ;
            end ;

        if ParList[i].Scale <> 0. then begin
           s := Table.cells[1,iRow] ;
           Val := Prot.Stimulus[iElement].Parameters[ParList[i].Index].Value*ParList[i].Scale ;
           Val := ExtractFloat( s, Val ) / ParList[i].Scale ;
           for g := 0 to High(Stimulator.GlobalVarFlag) do
              if Uppercase(s) = format('G%d',[g+1]) then Val := Stimulator.GlobalVarFlag[g] ;
           Prot.Stimulus[iElement].Parameters[ParList[i].Index].Value := Val ;
           end ;
        Prot.Stimulus[iElement].Parameters[ParList[i].Index].Exists := True ;

        end ;

    // If a new user-defined waveform has been loaded, substitute its
    // D/A update interval into the waveform parameters
    if KeepDACUpdateInterval <> 0.0 then begin
       Prot.Stimulus[iElement].Parameters[spDACUpdateInterval].Value := KeepDACUpdateInterval ;
       Prot.Stimulus[iElement].Parameters[spNumPoints].Value := KeepNumPoints ;
       Prot.Stimulus[iElement].Parameters[spNumPointsInc].Value := 0 ;
       end ;

    FillParameterTable( SelectedStimulusElement ) ;
    pbDisplay.Invalidate ;

    Prot.Saved := False ;
{$O+}
    end ;


procedure TEditProtocolFrm.AO00Click(Sender: TObject);
// ------------------------
// Waveform element clicked
// ------------------------
var
    i : Integer ;
begin

    // Update parameter table
    UpdateStimulusElement( SelectedStimulusElement ) ;
    FillParameterTable( TImage(Sender).Tag ) ;

    for i := 0 to High(Prot.Stimulus) do
        if Prot.Stimulus[i].Control.Transparent then
           Prot.Stimulus[i].Control.Transparent := False ;
    TImage(Sender).Transparent := True ;

    end;


procedure TEditProtocolFrm.TableKeyPress(Sender: TObject; var Key: Char);
// ------------------------------------------
// Key pressed over stimulus parameters table
// ------------------------------------------
begin
     StimulusParametersTableChanged := True ;
     Prot.Saved := False ;
     if Key = #13 then begin
        UpdateStimulusElement( SelectedStimulusElement ) ;
        FillParameterTable( SelectedStimulusElement ) ;
        end ;
     end;


procedure TEditProtocolFrm.DisplayStimulusProtocol(
          Prot : TStimulusProtocol
          ) ;
// -------------------------
// Display stimulus protocol
// -------------------------
const
    DisplayVoltageRange = 10.0 ;
    nSinePoints = 100 ;
var
    Top :Integer ;
    Left :Integer ;
    i,j,g,sh,iElem,Incr,iInc :Integer ;
    ChannelSpacing : Integer ;
    DigSpacing : Integer ;
    ChannelHeight : Integer ;
    ChannelHalfHeight : Integer ;
    DigChannelHeight :Integer ;
    YZero :Integer ;

    DisplayDuration : Single ;

    AONum,DONum : Integer ;
    // Y Axes range and labels
    VoltsMax : Array[0..MaxAOChannels-1] of Single ;
    VoltsMin : Array[0..MaxAOChannels-1] of Single ;
    VoltsMaxLabel : Array[0..MaxAOChannels-1] of String ;
    VoltsMinLabel : Array[0..MaxAOChannels-1] of String ;
    DACChannelName : String ;
    //
    DigChannelName : String ;

    Step : Integer ;
    TStartLabel : String ;      // Start of protocol time label
    TEndLabel : String ;        // End of protocol time label
    TLabelsTop : Integer ;      // Location of top of time labels
    RecordLabel : String ;      // Recording bar label
    PlotWidth : Integer ;       // Width of plotting area within display (pixels)
    Y,YMax,YMin,T,dT : Single ;
    TMax : Single ;
    StartAmplitude,EndAmplitude : Single ;
    Delay,Duration,PulsePeriod,Freq : Single ;
    NumPulses,iPulse : Integer ;
    Space : Integer ;
    VerticalSpacing : Integer ;
    StimulusDuration : Single ;
    NumIncrements : Integer ;

    iTop,iBottom,iLeft,iRight : Integer ;
    AOPlot : Array[0..MaxAOChannels-1] of TRect ;
    DOPlot : TRect ;
    State : Integer ;
    s : string ;
    StartAt,EndAt,jSteps,NumPoints : Integer ;
    Scale,Offset,TStart,TEnd,ScaleToPhaseAngle : single ;

begin

     pbDisplay.canvas.Font.Size := 8 ;

     { Erase various parts of voltage protocol display }
     pbDisplay.canvas.brush.color := clWhite ;
     pbDisplay.canvas.FillRect( Rect( 0,0,pbDisplay.Width-1,pbDisplay.Height-1) ) ;

     iTop := 2 ;
     iBottom := pbDisplay.Height - 2 ;
     iRight := pbDisplay.Width - pbDisplay.canvas.TextWidth(' ') ;

     // Display stimulus waveform duration
     s := format('%.5g %s',[Prot.RecordDuration*TScale,TUnits]) ;
     iBottom := iBottom - pbDisplay.Canvas.TextHeight(s) ;
     pbDisplay.Canvas.TextOut( iRight - pbDisplay.Canvas.TextWidth(s),iBottom,s) ;
     iBottom := iBottom - 1 ;

     // DO plot vertical space
     if Prot.NumDOChannels > 0 then begin
        DOPlot.Top := iBottom - Round(pbDisplay.canvas.TextHeight('X')*1.5)*Prot.NumDOChannels ;
        DOPlot.Bottom := iBottom ;
        iBottom := DOPlot.Top - 2 ;
        end ;

     // Analog plot(s) location
     VerticalSpacing := (iBottom - iTop) div Prot.NumAOChannels ;
     for AONum := 0 to Prot.NumAOChannels-1 do begin
        AOPlot[AONum].Top := iTop ;
        AOPlot[AONum].Bottom := iTop + VerticalSpacing - 4 ;
        iTop := iTop + VerticalSpacing ;
        AOPlot[AONum].Left := pbDisplay.canvas.TextWidth(' -9999 mV ') ;
        AOPlot[AONum].Right := iRight ;
        end ;

     // Digital plot location
     DOPlot.Left := AOPlot[0].Left ;
     DOPlot.Right := AOPlot[0].Right ;

     dT := 0.0 ;
     for AONum := 0 to Prot.NumAOChannels-1 do
         begin

         // Get amplitude range
         GetAmplitudeRange( Prot, AONum, YMin, YMax ) ;

         // Max. amplitude
         s := format('%.4g %s ',[YMax,Prot.AOChannelUnits[AONum]]) ;
         pbDisplay.canvas.TextOut( AOPlot[AONum].Left - pbDisplay.canvas.TextWidth(s),
                                   AOPlot[AONum].Top,
                                   s ) ;
         // Min. amplitude
         s := format('%.4g %s ',[YMin,Prot.AOChannelUnits[AONum]]) ;
         pbDisplay.canvas.TextOut( AOPlot[AONum].Left - pbDisplay.canvas.TextWidth(s),
                                   AOPlot[AONum].Bottom - pbDisplay.canvas.TextHeight(s) -1,
                                   s ) ;

         // Channel name
         s := format('AO %d ',[AONum]);
         pbDisplay.canvas.TextOut( AOPlot[AONum].Left - pbDisplay.canvas.TextWidth(s),
                                   (AOPlot[AONum].Bottom + AOPlot[AONum].Top
                                   - pbDisplay.canvas.TextHeight(s)) div 2,
                                   s ) ;

         // Draw calibration bar
         Space := pbDisplay.canvas.TextWidth('X') ;
         pbDisplay.canvas.Polyline( [
           Point( AOPlot[AONum].Left - Space, AOPlot[AONum].Top ),
           Point( AOPlot[AONum].Left -1, AOPlot[AONum].Top ),
           Point( AOPlot[AONum].Left -1, AOPlot[AONum].Bottom ),
           Point( AOPlot[AONum].Left - Space, AOPlot[AONum].Bottom )
           ]);

         // Draw stimulus waveforms
         StimulusDuration := Prot.RecordDuration ;
         NumIncrements := Prot.NumRecords div Max(Prot.NumRepeatsPerIncrement,1) ;

         // Substitute global variable value for global variable flag
         Stimulator.SubstituteGlobalVariables( Prot ) ;

         for Incr := 0 to Max(NumIncrements-1,0) do begin

             // Move line to start
             T := 0.0 ;

             pbDisplay.canvas.MoveTo( XScale( AOPlot[AONum], 0.0, StimulusDuration, T ),
                                      YScale( AOPlot[AONum],YMin, YMax, Prot.AOHoldingLevel[AONum])) ;

             for i := 0 to MaxStimElementsPerChannels-1 do
                 begin

                 iElem := i + AONum*MaxStimElementsPerChannels ;

                 if Prot.Stimulus[iElem].WaveShape = Ord(wvNone) then Continue ;

                 // Delay (at holding level)
                 if Prot.Stimulus[iElem].Parameters[spDelay].Exists then
                    begin
                    Delay := Prot.Stimulus[iElem].Parameters[spDelay].Value ;
                    if Prot.Stimulus[iElem].Parameters[spDelayInc].Exists then begin
                       Delay := Delay +
                                Prot.Stimulus[iElem].Parameters[spDelayInc].Value*Incr ;
                       end ;
                    end
                 else Delay := 0.0 ;

                 // Pulse Duration
                 if Prot.Stimulus[iElem].Parameters[spDuration].Exists then begin
                    Duration := Prot.Stimulus[iElem].Parameters[spDuration].Value ;
                    if Prot.Stimulus[iElem].Parameters[spDurationInc].Exists then begin
                       Duration := Duration +
                                   Prot.Stimulus[iElem].Parameters[spDurationInc].Value*Incr ;
                       end ;
                    end
                 else Duration := 0.0 ;

                 // Pulse train
                if Prot.Stimulus[iElem].Parameters[spNumRepeats].Exists then begin
                   NumPulses := Round(Prot.Stimulus[iElem].Parameters[spNumRepeats].Value) + 1 ;
                   if Prot.Stimulus[iElem].Parameters[spNumRepeatsInc].Exists then begin
                      NumPulses := NumPulses +
                                   Round(Prot.Stimulus[iElem].Parameters[spNumRepeatsInc].Value)
                      end ;
                   end
                else NumPulses := 1 ;

                // Pulse period
                if Prot.Stimulus[iElem].Parameters[spRepeatPeriod].Exists then begin
                   PulsePeriod := Prot.Stimulus[iElem].Parameters[spRepeatPeriod].Value ;
                   if Prot.Stimulus[iElem].Parameters[spRepeatPeriodInc].Exists then
                      begin
                      PulsePeriod := PulsePeriod +
                                     Prot.Stimulus[iElem].Parameters[spRepeatPeriodInc].Value*Incr ;
                      end ;
                   end
                else if Prot.Stimulus[iElem].Parameters[spFrequency].Exists then
                   begin

                   Freq := Prot.Stimulus[iElem].Parameters[spFrequency].Value ;

                   if Prot.Stimulus[iElem].Parameters[spFrequencyInc].Exists then
                      begin

                      if Prot.Stimulus[iElem].Parameters[spFrequencyMultiplierFlag].Exists and
                        (Prot.Stimulus[iElem].Parameters[spFrequencyMultiplierFlag].Value = 1.0) then
                         begin
                         // Multiply by increment
                         Freq := Prot.Stimulus[iElem].Parameters[spFrequency].Value ;
                         for iInc := 1 to Incr do Freq := Freq*Prot.Stimulus[iElem].Parameters[spFrequencyInc].Value ;
                         end
                      else
                         begin
                         // Add increment
                         Freq := Prot.Stimulus[iElem].Parameters[spFrequency].Value +
                                 Prot.Stimulus[iElem].Parameters[spFrequencyInc].Value*Incr ;
                         end;

                      end ;
                   PulsePeriod := 1.0 / Max(Freq,1E-6) ;

                   end
                else PulsePeriod := 0 ;

                // Start amplitude
                if Prot.Stimulus[iElem].Parameters[spStartAmplitude].Exists then begin
                   StartAmplitude := Prot.Stimulus[iElem].Parameters[spStartAmplitude].Value ;
                   if (Prot.Stimulus[iElem].Parameters[spStartAmplitudeInc].Exists) then
                      begin
                      StartAmplitude := StartAmplitude +
                                        Prot.Stimulus[iElem].Parameters[spStartAmplitudeInc].Value*Incr ;
                      end ;
                   end
                else StartAmplitude := 0.0 ;

                // End amplitude
                if Prot.Stimulus[iElem].Parameters[spEndAmplitude].Exists then begin
                   EndAmplitude := Prot.Stimulus[iElem].Parameters[spEndAmplitude].Value ;
                   if Prot.Stimulus[iElem].Parameters[spEndAmplitudeInc].Exists then begin
                      EndAmplitude := EndAmplitude +
                                      Prot.Stimulus[iElem].Parameters[spEndAmplitudeInc].Value*Incr ;
                      end
                   end
                else EndAmplitude := StartAmplitude ;

                // D/A update interval (Note All elements must have the same update interval
                if (Prot.Stimulus[iElem].Parameters[spDACUpdateInterval].Exists) and
                   (dT = 0.0) then begin
                   dT := Prot.Stimulus[iElem].Parameters[spDACUpdateInterval].Value ;
                   end ;

                // Delay (at holding level)
                if Delay <> 0.0 then begin
                    // Back to holding level
                    Y := Prot.AOHoldingLevel[AONum] ;
                    pbDisplay.canvas.LineTo( XScale( AOPlot[AONum],0.0, StimulusDuration, T ),
                                               YScale(AOPlot[AONum],YMin,YMax,Y)) ;
                   T := T + Delay ;
                   pbDisplay.canvas.LineTo( XScale( AOPlot[AONum],0.0, StimulusDuration, T ),
                                            YScale(AOPlot[AONum],YMin,YMax,Prot.AOHoldingLevel[AONum])) ;
                   end ;

                for iPulse := 0 to NumPulses-1 do
                    begin

                    if (Prot.Stimulus[iElem].WaveShape = Ord(wvSine)) then
                       begin
                       // Sine waveform
                       Y := Prot.AOHoldingLevel[AONum] ;
                       pbDisplay.canvas.MoveTo( XScale( AOPlot[AONum],0.0, StimulusDuration,T ),
                                                YScale(AOPlot[AONum],YMin,YMax,Y)) ;
                       TStart := T ;
                       TEnd := T + Duration ;
                       dt := StimulusDuration/2000.0 ;
                       ScaleToPhaseAngle := (2.0*pi()) / PulsePeriod ;
                       while T < TEnd do
                          begin
                          Y := Prot.AOHoldingLevel[AONum] + StartAmplitude*sin(ScaleToPhaseAngle*(T-TStart)) ;
                          T := T + dT ;
                          pbDisplay.canvas.LineTo( XScale( AOPlot[AONum],0.0, StimulusDuration, T ),
                                                   YScale(AOPlot[AONum],YMin,YMax,Y)) ;
                          end ;
                        end
                    else
                       begin
                       // Step waveforms
                       if iPulse > 0 then
                          begin
                          // Back to holding level
                          Y := Prot.AOHoldingLevel[AONum] ;
                          if (Prot.Stimulus[iElem].WaveShape = Ord(wvPulseStaircase)) then Y := Y + EndAmplitude*iPulse ;
                          pbDisplay.canvas.LineTo( XScale( AOPlot[AONum],0.0, StimulusDuration, T ),
                                                   YScale(AOPlot[AONum],YMin,YMax,Y)) ;
                          // Inter-pulse period
                          T := T + PulsePeriod - Duration ;
                          pbDisplay.canvas.LineTo( XScale( AOPlot[AONum],0.0, StimulusDuration, T ),
                                                   YScale(AOPlot[AONum],YMin,YMax,Y)) ;
                          end ;

                       // Start of pulse
                       Y := Prot.AOHoldingLevel[AONum] + StartAmplitude ;
                       if Prot.Stimulus[iElem].WaveShape = Ord(wvPulseStaircase) then Y := Y + EndAmplitude*iPulse ;

                       pbDisplay.canvas.LineTo( XScale( AOPlot[AONum],0.0, StimulusDuration, T ),
                                                YScale(AOPlot[AONum],YMin,YMax,Y)) ;
                       // End of pulse
                       T := T + Duration ;
                       if Prot.Stimulus[iElem].WaveShape <> Ord(wvPulseStaircase) then Y := Prot.AOHoldingLevel[AONum] + EndAmplitude ;

                       pbDisplay.canvas.LineTo( XScale( AOPlot[AONum],0.0, StimulusDuration, T ),
                                               YScale(AOPlot[AONum],YMin,YMax,Y)) ;

                       end ;
                   end;

                // Plot user-defined waveform
                if (Prot.Stimulus[iElem].WaveShape = Ord(wvWave)) and
                   (Prot.Stimulus[iElem].Buf <> Nil) then
                   begin

                   // No. points in waveform to be plotted and starting point in waveform buffer
                   if Prot.Stimulus[iElem].Parameters[spNumPoints].Exists then
                      begin
                      NumPoints := Round(Prot.Stimulus[iElem].Parameters[spNumPoints].Value) ;
                      StartAt := 0 ;
                      if Prot.Stimulus[iElem].Parameters[spNumPointsInc].Exists then begin
                         StartAt := Round(Prot.Stimulus[iElem].Parameters[spNumPointsInc].Value*Incr) ;
                         end ;
                      end
                   else begin
                      StartAt := 0 ;
                      NumPoints := Prot.Stimulus[iElem].NumPointsInBuf ;
                      end ;

                   // Scaling applied to user defined wave form
                   if Prot.Stimulus[iElem].Parameters[spScale].Exists then begin
                      Scale := Prot.Stimulus[iElem].Parameters[spScale].Value ;
                      if Prot.Stimulus[iElem].Parameters[spScaleInc].Exists then begin
                         Scale := Scale + Prot.Stimulus[iElem].Parameters[spScaleInc].Value*Incr ;
                         end ;
                      end
                   else Scale := 1.0 ;

                   // Offset applied to user defined wave form
                   if Prot.Stimulus[iElem].Parameters[spOffset].Exists then begin
                      Offset := Prot.Stimulus[iElem].Parameters[spOffset].Value ;
                      if Prot.Stimulus[iElem].Parameters[spOffsetInc].Exists then begin
                         Offset := Offset + Prot.Stimulus[iElem].Parameters[spOffsetInc].Value*Incr ;
                         end ;
                      end
                   else Offset := 0 ;

                   StartAt := Min(Max(StartAt,0),Prot.Stimulus[iElem].NumPointsInBuf-1) ;
                   EndAt := Min(Max(StartAt + NumPoints - 1,0),Prot.Stimulus[iElem].NumPointsInBuf-1) ;
                   jSteps := Max(((EndAt - StartAt)*(NumIncrements+1)) div 10000,1) ;
                   j := StartAt ;
                   while j <= EndAt do
                       begin
                       Y := Prot.AOHoldingLevel[AONum] + Scale*Prot.Stimulus[iElem].Buf^[j] + Offset ;
                       T := T + dT*jSteps ;
                       pbDisplay.canvas.LineTo( XScale( AOPlot[AONum],0.0, StimulusDuration, T ),
                                                YScale(AOPlot[AONum],YMin,YMax,Y)) ;
                       j := j + jSteps ;
                       end ;

                   // Return to holding level
                   Y := Prot.AOHoldingLevel[AONum] ;
                   pbDisplay.canvas.LineTo( XScale(AOPlot[AONum],0.0, StimulusDuration, T ),
                                            YScale(AOPlot[AONum],YMin,YMax,Y )) ;
                   end ;
                end ;

             // Draw to end of display
             Y := Prot.AOHoldingLevel[AONum] ;
             pbDisplay.canvas.LineTo( XScale( AOPlot[AONum],0.0, StimulusDuration, T ),
                                              YScale(AOPlot[AONum],YMin,YMax,Y)) ;
             pbDisplay.canvas.LineTo( XScale( AOPlot[AONum], 0.0, StimulusDuration, StimulusDuration ),
                                      YScale( AOPlot[AONum],YMin, YMax, Y)) ;

             end ;

         end ;

     // Display digital waveforms

     for DONum := 0 to Prot.NumDOChannels-1 do begin

         // Channel name
         s := format('DO %d',[DONum]) ;
         DigSpacing := (DOPlot.Bottom - DOPLot.Top) div Prot.NumDOChannels ;
         pbDisplay.canvas.TextOut( DOPlot.Left - pbDisplay.canvas.TextWidth(s),
                                   DOPlot.Top + DigSpacing*DONum + DigSpacing
                                   - pbDisplay.canvas.TextHeight(s) -1,
                                   s ) ;

         // Draw stimulus waveforms
         StimulusDuration := Prot.RecordDuration ;

         for Incr := 0 to Max(NumIncrements-1,0) do begin

             // Move line to start
             T := 0.0 ;
             pbDisplay.canvas.MoveTo( XScale( DOPlot, 0.0, StimulusDuration, T ),
                                      YScaleDig( DOPlot,DONum, Prot.DOHoldingLevel[DONum])) ;

             for i := 0 to MaxStimElementsPerChannels-1 do begin

                 iElem := i + DONum*MaxStimElementsPerChannels + DOElementsStart ;

                 if Prot.Stimulus[iElem].WaveShape = Ord(wvDigNone) then Continue ;

                 // Delay (at holding level)
                 if Prot.Stimulus[iElem].Parameters[spDelay].Exists then begin
                    Delay := Prot.Stimulus[iElem].Parameters[spDelay].Value ;
                    if Prot.Stimulus[iElem].Parameters[spDelayInc].Exists then begin
                       Delay := Delay +
                                Prot.Stimulus[iElem].Parameters[spDelayInc].Value*Incr ;
                       end ;
                    end
                 else Delay := 0.0 ;

                 // Pulse Duration
                 if Prot.Stimulus[iElem].Parameters[spDuration].Exists then begin
                    Duration := Prot.Stimulus[iElem].Parameters[spDuration].Value ;
                    if Prot.Stimulus[iElem].Parameters[spDurationInc].Exists then begin
                       Duration := Duration +
                                   Prot.Stimulus[iElem].Parameters[spDurationInc].Value*Incr ;
                       end ;
                    end
                 else Duration := 0.0 ;

                 // Pulse train
                if Prot.Stimulus[iElem].Parameters[spNumRepeats].Exists then begin
                   NumPulses := Round(Prot.Stimulus[iElem].Parameters[spNumRepeats].Value) + 1 ;
                   if Prot.Stimulus[iElem].Parameters[spNumRepeatsInc].Exists then begin
                      NumPulses := NumPulses +
                                   Round(Prot.Stimulus[iElem].Parameters[spNumRepeatsInc].Value)
                      end ;
                   end
                else NumPulses := 1 ;

                // Pulse period
                if Prot.Stimulus[iElem].Parameters[spRepeatPeriod].Exists then begin
                   PulsePeriod := Prot.Stimulus[iElem].Parameters[spRepeatPeriod].Value ;
                   if Prot.Stimulus[iElem].Parameters[spRepeatPeriodInc].Exists then begin
                      PulsePeriod := PulsePeriod +
                                     Prot.Stimulus[iElem].Parameters[spRepeatPeriodInc].Value*Incr ;
                      end ;
                   end
                else if Prot.Stimulus[iElem].Parameters[spFrequency].Exists then begin
                   PulsePeriod := 1.0/Max(Prot.Stimulus[iElem].Parameters[spFrequency].Value,1E-6) ;
                   if Prot.Stimulus[iElem].Parameters[spFrequencyInc].Exists then begin
                      PulsePeriod := 1.0 / Max(1E-6,Prot.Stimulus[iElem].Parameters[spFrequency].Value +
                                                    Prot.Stimulus[iElem].Parameters[spFrequencyInc].Value*Incr) ;
                      end ;
                   end
                else PulsePeriod := 0.0 ;

                // Pulse state (1/0)
                if Prot.Stimulus[iElem].Parameters[spDigAmplitude].Exists then begin
                   State := Round(Prot.Stimulus[iElem].Parameters[spDigAmplitude].Value) ;
                   end
                else State := Prot.DOHoldingLevel[DONum] ;

                // Delay (at holding level)
                if Delay <> 0.0 then begin
                   // Back to holding level
                   pbDisplay.canvas.LineTo( XScale( DOPlot,0.0, StimulusDuration, T ),
                                            YScaleDig(DOPlot,DONum,Prot.DOHoldingLevel[DONum])) ;

                   T := T + Delay ;
                   pbDisplay.canvas.LineTo( XScale( DOPlot,0.0, StimulusDuration, T ),
                                            YScaleDig(DOPlot,DONum,Prot.DOHoldingLevel[DONum])) ;
                   end ;


                // Plot user-defined digital waveform
                if (Prot.Stimulus[iElem].WaveShape = Ord(wvDigWave)) and
                   (Prot.Stimulus[iElem].Buf <> Nil) then
                   begin

                   // D/A update interval (Note All elements must have the same update interval
                   if (Prot.Stimulus[iElem].Parameters[spDACUpdateInterval].Exists) and
                      (dT = 0.0) then begin
                      dT := Prot.Stimulus[iElem].Parameters[spDACUpdateInterval].Value ;
                      end ;

                   // No. points in waveform to be plotted and starting point in waveform buffer
                   NumPoints := Prot.Stimulus[iElem].NumPointsInBuf ;
                   if Prot.Stimulus[iElem].Parameters[spNumPoints].Exists then
                      NumPoints := Round(Prot.Stimulus[iElem].Parameters[spNumPoints].Value) ;
                   StartAt := 0 ;
                   if Prot.Stimulus[iElem].Parameters[spNumPointsInc].Exists then
                         StartAt := Round(Prot.Stimulus[iElem].Parameters[spNumPointsInc].Value*Incr) ;

                   StartAt := Min(Max(StartAt,0),Prot.Stimulus[iElem].NumPointsInBuf-1) ;
                   EndAt := Min(Max(StartAt + NumPoints - 1,0),Prot.Stimulus[iElem].NumPointsInBuf-1) ;
                   jSteps := Max( ((EndAt - StartAt)*(NumIncrements+1)) div 10000,1) ;
                   j := StartAt ;
                   while j <=  EndAt do
                      begin
                      pbDisplay.canvas.LineTo( XScale( DOPlot,0.0, StimulusDuration, T ),
                                                YScaleDig(DOPlot,DONum,Round(Prot.Stimulus[iElem].Buf^[j])));
                      T := T + dT*jSteps ;
                      pbDisplay.canvas.LineTo( XScale( DOPlot,0.0, StimulusDuration, T ),
                                                YScaleDig(DOPlot,DONum,Round(Prot.Stimulus[iElem].Buf^[j])));
                      j := j + jSteps ;
                      end ;

                   // Return to holding level
                   pbDisplay.canvas.LineTo( XScale( DOPlot,0.0, StimulusDuration, T ),
                                            YScaleDig(DOPlot,DONum,Prot.DOHoldingLevel[DONum])) ;

                   end
                else begin
                   // Plot other digital waveforms
                   for iPulse := 0 to NumPulses-1 do
                       begin

                       if iPulse > 0 then
                          begin
                          // Back to holding level
                          pbDisplay.canvas.LineTo( XScale( DOPlot,0.0, StimulusDuration, T ),
                                                   YScaleDig(DOPlot,DONum,Prot.DOHoldingLevel[DONum])) ;
                          // Inter-pulse period
                          T := T + PulsePeriod - Duration ;
                          pbDisplay.canvas.LineTo( XScale( DOPlot,0.0, StimulusDuration, T ),
                                                YScaleDig(DOPlot,DONum,Prot.DOHoldingLevel[DONum])) ;
                          end ;

                       // Start of pulse
                       pbDisplay.canvas.LineTo( XScale( DOPlot,0.0, StimulusDuration, T ),
                                                YScaleDig(DOPlot,DONum,State)) ;
                       // End of pulse
                       T := T + Duration ;
                       pbDisplay.canvas.LineTo( XScale( DOPlot,0.0, StimulusDuration, T ),
                                             YScaleDig(DOPlot,DONum,State)) ;
                       end ;
                    end ;
                end ;
             // Draw to end of display

             // Back to holding level
             pbDisplay.canvas.LineTo( XScale( DOPlot,0.0, StimulusDuration, T ),
                                      YScaleDig(DOPlot,DONum,Prot.DOHoldingLevel[DONum])) ;
             pbDisplay.canvas.LineTo( XScale( DOPlot, 0.0, StimulusDuration, StimulusDuration ),
                                      YScaleDig(DOPlot,DONum,Prot.DOHoldingLevel[DONum])) ;

             end ;
         end ;


     Stimulator.SetADCDACUpdateIntervals( Prot ) ;
     edDACUpdateInterval.Value := Prot.AOUpdateInterval ;

     end ;



procedure TEditProtocolFrm.GetAmplitudeRange(
          Prot : TStimulusProtocol ;
          AONum : Integer ;                 // AO channel
          var YMin : Single ;               // Min. amplitude in protocol
          var YMax : Single                 // Max. amplitude in protocol
          ) ;
// --------------------------------------------------
// Determine range of stimulus amplitudes in protocol
// --------------------------------------------------
var
    i,j,iElem : Integer ;
    NumIncrements : Integer ;
    Y,Scale0,Scale1,Offset0,Offset1 : Single ;
begin

     YMin := Prot.AOHoldingLevel[AONum] ;
     YMax := Prot.AOHoldingLevel[AONum] ;
     NumIncrements := Prot.NumRecords div Max(Prot.NumRepeatsPerIncrement,1) ;

     for i := 0 to MaxStimElementsPerChannels-1 do
         begin

         iElem := i + AONum*MaxStimElementsPerChannels ;

         Stimulator.SubstituteGlobalVariables( Prot ) ;

         // Start amplitude
         if Prot.Stimulus[iElem].Parameters[spStartAmplitude].Exists then
            begin

            Y := Prot.Stimulus[iElem].Parameters[spStartAmplitude].Value + Prot.AOHoldingLevel[AONum] ;
            YMax := Max(YMax,Y) ;
            YMin := Min(YMin,Y) ;
            if Prot.Stimulus[iElem].Parameters[spStartAmplitudeInc].Exists then
               begin
               Y := Y + (Prot.Stimulus[iElem].Parameters[spStartAmplitudeInc].Value*NumIncrements) ;
               YMax := Max(YMax,Y) ;
               YMin := Min(YMin,Y) ;
               end ;
            // If sine wave include negative half of sine wave
            if Prot.Stimulus[iElem].WaveShape = wvSine then begin
               YMin := Min(-(YMax - Prot.AOHoldingLevel[AONum]) + Prot.AOHoldingLevel[AONum],YMin) ;
               end;

            end ;

         // End amplitude
         if Prot.Stimulus[iElem].Parameters[spEndAmplitude].Exists then
            begin
            Y := Prot.Stimulus[iElem].Parameters[spEndAmplitude].Value + Prot.AOHoldingLevel[AONum] ;
            YMax := Max(YMax,Y) ;
            YMin := Min(YMin,Y) ;
            if Prot.Stimulus[iElem].Parameters[spEndAmplitudeInc].Exists then begin
               Y := Y + (Prot.Stimulus[iElem].Parameters[spEndAmplitudeInc].Value*NumIncrements) ;
               YMax := Max(YMax,Y) ;
               YMin := Min(YMin,Y) ;
               end ;

            end ;

         if Prot.Stimulus[iElem].Waveshape = wvPulseStaircase then begin
            // Special processing for pulse staircase waveform amplitudes
            Y := Prot.AOHoldingLevel[AONum] +
                 Prot.Stimulus[iElem].Parameters[spStartAmplitude].Value +
                (Prot.Stimulus[iElem].Parameters[spEndAmplitude].Value*Prot.Stimulus[iElem].Parameters[spNumRepeats].Value) ;
            YMax := Max(YMax,Y) ;
            YMin := Min(YMin,Y) ;
            end ;

         // User-defined waveform
         if (Prot.Stimulus[iElem].Parameters[spFileName].Exists) and
            (Prot.Stimulus[iElem].Buf <> Nil) then
            begin

            // Scaling applied to user defined wave form
            Scale0 := 1.0 ;
            if Prot.Stimulus[iElem].Parameters[spScale].Exists then
               Scale0 := Prot.Stimulus[iElem].Parameters[spScale].Value ;
            Scale1 := Scale0 ;
            if Prot.Stimulus[iElem].Parameters[spScaleInc].Exists then
               Scale1 := Scale1 + Prot.Stimulus[iElem].Parameters[spScaleInc].Value*NumIncrements ;

            // Offset applied to user defined wave form
            Offset0 := 0.0 ;
            if Prot.Stimulus[iElem].Parameters[spOffset].Exists then
               Offset0 := Prot.Stimulus[iElem].Parameters[spOffset].Value ;
            Offset1 := Offset0 ;
            if Prot.Stimulus[iElem].Parameters[spOffsetInc].Exists then
               Offset1 := Offset1 + Prot.Stimulus[iElem].Parameters[spOffsetInc].Value*NumIncrements ;

            for j := 0 to Prot.Stimulus[iElem].NumPointsInBuf-1 do begin
                Y := Prot.Stimulus[iElem].Buf[j] + Prot.AOHoldingLevel[AONum] ;
                YMax := Max(YMax,Y*Scale0 + Offset0) ;
                YMin := Min(YMin,Y*Scale0 + Offset0) ;
                YMax := Max(YMax,Y*Scale1 + Offset1) ;
                YMin := Min(YMin,Y*Scale1 + Offset1) ;
                end ;
            end ;
         end ;

     if YMin = YMax then begin
        YMax := YMax + 10.0 ;
        YMin := YMin - 10.0 ;
        end ;

     end ;

function TEditProtocolFrm.YScale(
          const AOPlot : TRect ;
          YMin : Single ;
          YMax : Single ;
          Y : Single
          ) : Integer ;
//
// Scale Y to plot coords
// ----------------------
var
    Scale : Single ;
begin

    if YMin = YMax then begin
       YMax := YMax + 0.5 ;
       YMin := YMin - 0.5 ;
       end ;

    Scale := (AOPlot.Top - AOPlot.Bottom)/(YMax - YMin) ;
    Result := Round((Y - YMin)*Scale) + AOPlot.Bottom ;
    end ;


function TEditProtocolFrm.YScaleDig(
          const DOPlot : TRect ;
          DOChan : Single ;
          DigState : Integer
          ) : Integer ;
//
// Scale Y to plot coords
// ----------------------
var
    ChannelSpacing : Single ;
    OffLevel : Integer ;
begin

    ChannelSpacing := (DOPlot.Bottom - DOPlot.Top)/Max(Prot.NumDOChannels,1) ;
    OffLevel := DOPlot.Top + Round((DOChan+1)*ChannelSpacing) ;
    Result := OffLevel - Round(DigState*(ChannelSpacing-3)) ;

    end ;


function TEditProtocolFrm.XScale(
          const AOPlot : TRect ;
          XMin : Single ;
          XMax : Single ;
          X : Single
          ) : Integer ;
// ----------------------
// Scale X to plot coords
// ----------------------
var
    Scale : Single ;
begin

    if XMin = XMax then XMax := XMax + 1.0 ;

    Scale := (AOPlot.Right - AOPlot.Left)/(XMax - XMin) ;
    Result := Round((X - XMin)*Scale) + AOPlot.Left ;

    end ;


procedure TEditProtocolFrm.pbDisplayPaint(Sender: TObject);
begin
     DisplayStimulusProtocol(Prot) ;
     end;


procedure TEditProtocolFrm.FillRecordingTable ;
// ------------------------------------------------
// Fill recording table with recording parameters
// ------------------------------------------------
var
    i,iRow : Integer ;
begin

    RecTable.cells[0,0] := '' ;
    RecTable.cells[1,0] := '' ;
//  RecTable.Font.Size := 8 ;

    Inc(iRow) ;
    RecTable.RowCount := 1 ;
    if Prot.RecordDuration <= 0.0 then Prot.RecordDuration := 1.0 ;
    RecTable.cells[0,RecTable.RowCount-1] := 'Recording duration ' ;
    RecTable.cells[1,RecTable.RowCount-1] := format('%.6g %s',
                                             [Prot.RecordDuration*TScale,TUnits]);

    RecTable.RowCount := RecTable.RowCount + 1 ;
    if Prot.NumADCSamplesPerChannel < 256 then Prot.NumADCSamplesPerChannel := 2048 ;
    Stimulator.SetADCDACUpdateIntervals( Prot ) ;
    RecTable.cells[0,RecTable.RowCount-1] := 'Sampling interval ' ;
    RecTable.cells[1,RecTable.RowCount-1] := format('%.6g %s',
                                             [Prot.ADCSamplingInterval*TScale,TUnits]);

    RecTable.RowCount := RecTable.RowCount + 1 ;
    if Prot.StimulusPeriod <= 0.0 then Prot.StimulusPeriod := Min(Prot.RecordDuration*2.0,1.0) ;
    RecTable.cells[0,RecTable.RowCount-1] := 'Stimulus repeat period ' ;
    RecTable.cells[1,RecTable.RowCount-1] := format('%.6g %s',
                                             [Prot.StimulusPeriod*TScale,TUnits]);

    RecTable.RowCount := RecTable.RowCount + 1 ;
    if Prot.NumRecords < 1 then Prot.NumRecords := 1 ;
    RecTable.cells[0,RecTable.RowCount-1] := 'No. records ' ;
    RecTable.cells[1,RecTable.RowCount-1] := format('%d',
                                             [Prot.NumRecords]);

    RecTable.RowCount := RecTable.RowCount + 1 ;
    if Prot.NumRepeatsPerIncrement < 1 then Prot.NumRepeatsPerIncrement := 1 ;
    RecTable.cells[0,RecTable.RowCount-1] := 'No. repeats per increment ' ;
    RecTable.cells[1,RecTable.RowCount-1] := format('%d',
                                             [Prot.NumRepeatsPerIncrement]);

    RecTable.RowCount := RecTable.RowCount + 1 ;
    if Prot.NumADCChannels < 1 then Prot.NumADCChannels := 2 ;
    RecTable.cells[0,RecTable.RowCount-1] := 'No. input channels ' ;
    RecTable.cells[1,RecTable.RowCount-1] := format('%d',
                                             [Prot.NumADCChannels]);

    RecTable.RowCount := RecTable.RowCount + 1 ;
    if Prot.NumADCSamplesPerChannel < 256 then Prot.NumADCSamplesPerChannel := 2048 ;
    RecTable.cells[0,RecTable.RowCount-1] := 'No. samples (per channel) ' ;
    RecTable.cells[1,RecTable.RowCount-1] := format('%d',
                                             [Prot.NumADCSamplesPerChannel]);

    RecTable.RowCount := RecTable.RowCount + 1 ;
    RecTable.cells[0,RecTable.RowCount-1] := 'External stimulus trigger (Y/N) ' ;
    if Prot.ExtTrigger then RecTable.cells[1,RecTable.RowCount-1] := 'Y'
                       else RecTable.cells[1,RecTable.RowCount-1] := 'N' ;

    // Set column widths

    RecTable.ColWidths[0] := 200 ;
    for i := 0 to RecTable.RowCount-1 do begin
        RecTable.ColWidths[0] := Max( RecTable.ColWidths[0],
                                      RecTable.Canvas.TextWidth(RecTable.cells[0,i]) ) ;
        end ;

    // Leak subtraction

    edNumLeaks.Value := Prot.NumLeakSubtractionRecords ;
    edLeakScale.Value := Prot.LeakSubtractionDivideFactor ;
    rbPNLeak.Checked := Prot.LeakSubtractionEnabled ;
    rbNoLeak.Checked := not Prot.LeakSubtractionEnabled ;

    edDACUpdateInterval.Value := Prot.AOUpdateIntervalFixed ;
    ckFixedDACUpdateInterval.Checked := Prot.AOUpdateIntervalKeepFixed ;

    ckFixedSamplesPerChannel.Checked := not Prot.ADCSamplingIntervalKeepFixed ;

    // Get linked protocol file name
    if Prot.NextProtocolFileName <> '' then
        cbNextProtocol.ItemIndex := Max(0,
                                    cbNextProtocol.Items.IndexOf(
                                    ExtractFileNameOnly(Prot.NextProtocolFileName)))
     else cbNextProtocol.ItemIndex := 0 ;

    if Prot.RecordDuration >= (Prot.StimulusPeriod - 0.15) then
       lbError.Caption := 'Warning! Recording Duration must be at least 150ms smaller than Stimulus Repeat Period'
       else lbError.Caption := '';

    end ;


procedure TEditProtocolFrm.UpdateRecordingTableParameters ;
// ------------------------------------------------
// Update parameter from recording parameters table
// ------------------------------------------------
begin

     if DisableUpdates then Exit ;

     Prot.RecordDuration := ExtractFloat( RecTable.cells[1,0],
                                          Prot.RecordDuration*TScale )/TScale ;

     Prot.ADCSamplingInterval := ExtractFloat( RecTable.cells[1,1],
                                               Prot.ADCSamplingInterval*TScale )/TScale ;

     Prot.StimulusPeriod := ExtractFloat( RecTable.cells[1,2],
                                          Prot.StimulusPeriod*TScale )/TScale ;

     Prot.NumRecords := Round( ExtractFloat( RecTable.cells[1,3],
                                             Prot.NumRecords*1.0 )) ;

     Prot.NumRepeatsPerIncrement := Round( ExtractFloat( RecTable.cells[1,4],
                                                         Prot.NumRepeatsPerIncrement*1.0 )) ;

     Prot.NumADCChannels := Min( Main.SESLabIO.ADCMaxChannels,
                            Max( 1,
                                 Round( ExtractFloat( RecTable.cells[1,5],
                                        Prot.NumADCChannels*1.0 )))) ;

     Prot.NumADCSamplesPerChannel := Min( Main.SESLabIO.ADCBufferLimit div Prot.NumADCChannels,
                                     Round( ExtractFloat( RecTable.cells[1,6],
                                          Prot.NumADCSamplesPerChannel*1.0 ))) ;

     Prot.NumADCSamplesPerChannel := Max(Prot.NumADCSamplesPerChannel div 256,1)*256 ;

     if ANSIContainsText(RecTable.cells[1,7],'Y') then Prot.ExtTrigger := True
                                                  else Prot.ExtTrigger := False ;

     // Leak subtraction
     Prot.LeakSubtractionEnabled := rbPNLeak.Checked ;
     Prot.NumLeakSubtractionRecords := Round(edNumLeaks.Value);
     Prot.LeakSubtractionDivideFactor := Round(edLeakScale.Value) ;
     if Prot.LeakSubtractionDivideFactor = 0 then Prot.LeakSubtractionDivideFactor := 1 ;

     if ckFixedDACUpdateInterval.Checked then Prot.AOUpdateIntervalFixed := edDACUpdateInterval.Value ;
     Prot.AOUpdateIntervalKeepFixed := ckFixedDACUpdateInterval.Checked ;

     Prot.ADCSamplingIntervalKeepFixed := not ckFixedSamplesPerChannel.Checked ;

     // Linked protocol
     if cbNextProtocol.ItemIndex > 0 then begin
        Prot.NextProtocolFileName := Settings.VProtDirectory + cbNextProtocol.Text + '.xml' ;
        end
     else Prot.NextProtocolFileName := '' ;


     Stimulator.SetADCDACUpdateIntervals( Prot ) ;

     FillRecordingTable ;
     pbDisplay.Invalidate ;

     RecordingParametersTableChanged := False ;

     Prot.Saved := False ;

     end ;


procedure TEditProtocolFrm.RecTableKeyPress(Sender: TObject;
  var Key: Char);
// ---------------------------------
// Update recording table parameters
// ---------------------------------
begin

    RecordingParametersTableChanged := True ;
    Prot.Saved := False ;
    if Key = #13 then UpdateRecordingTableParameters ;

    end;

procedure TEditProtocolFrm.FillGlobalVarsTable ;
// ----------------------------
// Fill global variables table
// ----------------------------
var
    i : Integer ;
begin

    for i := 0 to MaxStimGlobalVars-1 do begin
       GlobalVarTable.cells[0,i] := format('G%d',[i+1]) ;
       GlobalVarTable.cells[1,i] := format('%.4g',[Stimulator.GlobalVar[i]]) ;
       end;

    end;

procedure TEditProtocolFrm.UpdateGlobalVars ;
// ---------------------------------
// Update global variable from table
// ---------------------------------
var
    i : Integer ;
begin

    GlobalVarTable.RowCount := MaxStimGlobalVars ;
    GlobalVarTable.ColCount := 2;

    for i := 0 to MaxStimGlobalVars-1 do begin
       Stimulator.GlobalVar[i] := ExtractFloat( GlobalVarTable.cells[1,i], 0.0 ) ;
       end;

    end;


procedure TEditProtocolFrm.PageChange(Sender: TObject);
// ---------------------------
// Settings table page changed
// ---------------------------
begin
     if RecordingParametersTableChanged then UpdateRecordingTableParameters ;
     if StimulusParametersTableChanged then UpdateStimulusElement( SelectedStimulusElement ) ;
     if GlobalVarsTableChanged then UpdateGlobalVars ;
     end;


procedure TEditProtocolFrm.FillHolding ;
// -----------------------------
// Fill AO and DO holding levels
// -----------------------------
begin

      // Set AO 0..3 holding levels & scaling
      cbAO0Stim.ItemIndex := Min(Max(Prot.AOStimType[0],0),cbAO0Stim.Items.Count-1) ;
      edAO0Hold.Value := Prot.AOHoldingLevel[0] ;
      edAO0Hold.Units := Prot.AOChannelUnits[0] ;

      cbAO1Stim.ItemIndex := Min(Max(Prot.AOStimType[1],0),cbAO1Stim.Items.Count-1) ;
      edAO1Hold.Value := Prot.AOHoldingLevel[1] ;
      edAO1Hold.Units := Prot.AOChannelUnits[1] ;

      cbAO2Stim.ItemIndex := Min(Max(Prot.AOStimType[2],0),cbAO2Stim.Items.Count-1) ;
      edAO2Hold.Value := Prot.AOHoldingLevel[2] ;
      edAO2Hold.Units := Prot.AOChannelUnits[2] ;

      cbAO3Stim.ItemIndex := Min(Max(Prot.AOStimType[3],0),cbAO3Stim.Items.Count-1) ;
      edAO3Hold.Value := Prot.AOHoldingLevel[3] ;
      edAO3Hold.Units := Prot.AOChannelUnits[3] ;

      // Set DO holding states

      SetDORadioButton( rbDO0On, rbDO0Off, 0 ) ;
      SetDORadioButton( rbDO1On, rbDO1Off, 1 ) ;
      SetDORadioButton( rbDO2On, rbDO2Off, 2 ) ;
      SetDORadioButton( rbDO3On, rbDO3Off, 3 ) ;
      SetDORadioButton( rbDO4On, rbDO4Off, 4 ) ;
      SetDORadioButton( rbDO5On, rbDO5Off, 5 ) ;
      SetDORadioButton( rbDO6On, rbDO6Off, 6 ) ;
      SetDORadioButton( rbDO7On, rbDO7Off, 7 ) ;

      end ;

procedure TEditProtocolFrm.SetDORadioButton(
          var OnButton : TRadioButton ;         // On button
          var OffButton : TRadioButton ;        // Off button
          DOChan : Integer                  // Digital output channel #
          ) ;
// ----------------------------
// Set On/Off radio button pair
// ----------------------------
begin

    if Prot.DOHoldingLevel[DOChan] <> 0 then OnButton.Checked := True
                                        else OnButton.Checked := False ;
    OffButton.Checked := not OnButton.Checked ;
    end ;


procedure TEditProtocolFrm.UpdateHolding ;
// -------------------------------
// Update AO and DO holding values
// -------------------------------
var
    i : Integer ;
begin

     if DisableUpdates then Exit ;

      // Update AO holding and scaling
      Prot.AOStimType[0] := cbAO0Stim.ItemIndex ;
      Prot.AOHoldingLevel[0] := edAO0Hold.Value ;
      Prot.AOScale[0] := StimType[cbAO0Stim.ItemIndex].Scale ;
      edAO0Hold.Units := StimType[cbAO0Stim.ItemIndex].Units ;
      Prot.AOChannelUnits[0] := edAO0Hold.Units ;

      Prot.AOStimType[1] := cbAO1Stim.ItemIndex ;
      Prot.AOHoldingLevel[1] := edAO1Hold.Value ;
      Prot.AOScale[1] := StimType[cbAO1Stim.ItemIndex].Scale ;
      edAO1Hold.Units := StimType[cbAO1Stim.ItemIndex].Units ;
      Prot.AOChannelUnits[1] := edAO1Hold.Units ;

      Prot.AOStimType[2] := cbAO2Stim.ItemIndex ;
      Prot.AOHoldingLevel[2] := edAO2Hold.Value ;
      Prot.AOScale[2] := StimType[cbAO2Stim.ItemIndex].Scale ;
      edAO2Hold.Units := StimType[cbAO2Stim.ItemIndex].Units ;
      Prot.AOChannelUnits[2] := edAO2Hold.Units ;

      Prot.AOStimType[3] := cbAO3Stim.ItemIndex ;
      Prot.AOHoldingLevel[3] := edAO3Hold.Value ;
      Prot.AOScale[3] := StimType[cbAO3Stim.ItemIndex].Scale ;
      edAO3Hold.Units := StimType[cbAO3Stim.ItemIndex].Units ;
      Prot.AOChannelUnits[3] := edAO3Hold.Units ;

      // Set DO holding level

      for i := 0 to High(Prot.DOHoldingLevel) do Prot.DOHoldingLevel[i] := 0 ;
      if rbDO0On.Checked then Prot.DOHoldingLevel[0] := 1 ;
      if rbDO1On.Checked then Prot.DOHoldingLevel[1] := 1 ;
      if rbDO2On.Checked then Prot.DOHoldingLevel[2] := 1 ;
      if rbDO3On.Checked then Prot.DOHoldingLevel[3] := 1 ;
      if rbDO4On.Checked then Prot.DOHoldingLevel[4] := 1 ;
      if rbDO5On.Checked then Prot.DOHoldingLevel[5] := 1 ;
      if rbDO6On.Checked then Prot.DOHoldingLevel[6] := 1 ;
      if rbDO7On.Checked then Prot.DOHoldingLevel[7] := 1 ;

      // Update entry boxes
      FillHolding ;
      pbDisplay.Invalidate ;

      Prot.Saved := False ;

      end ;


procedure TEditProtocolFrm.cbAO0StimChange(Sender: TObject);
// ---------------------
// Stimulus type changed
// ---------------------
begin
    UpdateHolding ;
    end;

procedure TEditProtocolFrm.edAO0HoldKeyPress(Sender: TObject;
  var Key: Char);
// ---------------------
// Holding level changed
// ---------------------
begin
     if Key = #13 then UpdateHolding ;
     end;

procedure TEditProtocolFrm.rbDO0OnClick(Sender: TObject);
// ------------------------------------
// Digital output holding state clicked
// ------------------------------------
begin
    UpdateHolding ;
    end;


procedure TEditProtocolFrm.FillWaveShapes ;
// -------------------------------
// Fill protocol waveshape palette
// -------------------------------
var
    i : Integer ;
begin
    for i := 0 to High(Prot.Stimulus) do begin
        if Prot.Stimulus[i].Waveshape <= 0 then begin
           if i >= DOElementsStart then begin
              Prot.Stimulus[i].Control.Picture := WaveShapeImage[Ord(wvDigNone)].Picture ;
              end
           else begin
              Prot.Stimulus[i].Control.Picture := WaveShapeImage[Ord(wvNone)].Picture ;
              end ;
           end
        else begin
           Prot.Stimulus[i].Control.Picture := WaveShapeImage[Prot.Stimulus[i].Waveshape].Picture ;
           end ;
        end ;

    end ;


function TEditProtocolFrm.SaveProtocolToXMLFile(
          FileName : String
          ) : String ;
// ----------------------------------
// Save stimulus protocol to XML file
// ----------------------------------
begin

    // Ensure recent changes added to protocol
    UpdateStimulusElement( SelectedStimulusElement ) ;
    UpdateRecordingTableParameters ;
    UpdateHolding ;

    Stimulator.SaveProtocolToXMLFile( Prot, FileName ) ;

    // Update stimulus protocol list in recording form
    if Main.FormExists('RecordFrm') then RecordFrm.UpdateStimulusProtocolList ;

    Caption := 'Protocol: ' + FileName ;
    Result := FileName ;

    // Select this protocol for use (if none already selected)
    if Settings.VProgramFileName = '' then Settings.VProgramFileName := FileName ;

    end ;


procedure TEditProtocolFrm.LoadProtocolFromXMLFile(
          FileName : String
          ) ;
// ----------------------------------
// Load stimulus protocol from XML file
// ----------------------------------
begin

    DisableUpdates := True ;

    // Clear protocol record
    Stimulator.ClearProtocol(Prot) ;

    Stimulator.LoadProtocolFromXMLFile( Prot, FileName ) ;

    cbNumAOChannels.ItemIndex := Prot.NumAOChannels - 1 ;
    cbNumDOChannels.ItemIndex := Prot.NumDOChannels - 1 ;

    FillRecordingTable ;
    FillWaveShapes ;
    FillHolding ;
    FillGlobalVarsTable ;
    AdjustWaveformPalettes ;
    FillParameterTable( SelectedStimulusElement ) ;

    pbDisplay.Invalidate ;

    DisableUpdates := False ;
    Prot.Saved := True ;

    end ;


procedure TEditProtocolFrm.bSaveAsClick(Sender: TObject);
// ---------------------------------------
//  Save stimulus protocol to file
// --------------------------------
begin
     SaveProtocol ;
     end ;


procedure TEditProtocolFrm.SaveProtocol ;
// -------------------------------
//  Save stimulus protocol to file
// -------------------------------
begin

     SaveDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     SaveDialog.InitialDir := Settings.VProtDirectory ;
     SetCurrentDir(Settings.VProtDirectory) ;
     SaveDialog.Title := 'Save Stimulus Protocol' ;
     SaveDialog.FileName := '*.xml' ;

     if SaveDialog.execute then begin
        FileName := SaveProtocolToXMLFile(SaveDialog.FileName) ;
        Stimulator.CreateProtocolList( cbNextProtocol ) ;
        end ;

     end ;


procedure TEditProtocolFrm.bOpenClick(Sender: TObject);
// ------------------------------------------------------------
//  When Open File button clicked load voltage program from file
// ------------------------------------------------------------}
begin

     { If the current waveform has been edited ... offer to save it to file }
     if not Prot.Saved then begin
        if FileName <> '' then FileName := SaveProtocolToXMLFile(FileName)
                          else SaveProtocol ;
        end ;

     OpenDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     OpenDialog.FileName := '*.xml' ;
     OpenDialog.InitialDir := Settings.VProtDirectory ;
     OpenDialog.Title := 'Load Stimulus Protocol' ;
     if OpenDialog.execute then begin
        FileName := OpenDialog.FileName ;
        Caption := 'Protocol: ' + FileName ;
        LoadProtocolFromXMLFile( FileName ) ;
        // Select this protocol for use (if none already selected)
        if Settings.VProgramFileName = '' then Settings.VProgramFileName := FileName ;
        end ;

     end ;


procedure TEditProtocolFrm.edNumLeaksKeyPress(Sender: TObject;
  var Key: Char);
begin
     if Key = #13 then UpdateRecordingTableParameters ;
     end;

procedure TEditProtocolFrm.edLeakScaleKeyPress(Sender: TObject;
  var Key: Char);
begin
     if Key = #13 then UpdateRecordingTableParameters ;
     end;


procedure TEditProtocolFrm.rbNoLeakClick(Sender: TObject);
begin
     Prot.LeakSubtractionEnabled := rbNoLeak.Checked ;
     UpdateRecordingTableParameters ;
     end;

procedure TEditProtocolFrm.rbPNLeakClick(Sender: TObject);
begin
     Prot.LeakSubtractionEnabled := rbPNLeak.Checked ;
     UpdateRecordingTableParameters ;
     end;


procedure TEditProtocolFrm.bNewClick(Sender: TObject);
// -------------------------------
// Create a new and empty protocol
// -------------------------------
begin
    Stimulator.ClearProtocol(Prot) ;
    FillWaveShapes ;
    pbDisplay.Invalidate;
    Caption := 'Protocol: ' ;
    FileName := '' ;

    FillRecordingTable ;
    FillWaveShapes ;
    FillHolding ;
    FillGlobalVarsTable ;
    FillParameterTable( SelectedStimulusElement ) ;
    AdjustWaveformPalettes ;

    Prot.Saved := True ;
    end ;


procedure TEditProtocolFrm.bSetStimFolderClick(Sender: TObject);
// -----------------------------
//  Set voltage protocol file folder
// -----------------------------
begin
    DirectorySelectFrm.Directory := Settings.VProtDirectory ;
    DirectorySelectFrm.Left := Main.Left +
                               EditProtocolFrm.Left +
                               bSetStimFolder.Left +
                               bSetStimFolder.Width + 20 ;
    DirectorySelectFrm.Top := Main.Top +
                              EditProtocolFrm.Top +
                              bSetStimFolder.Top + 10 ;


    DirectorySelectFrm.ShowModal ;
    if DirectorySelectFrm.ModalResult = mrOK then begin
       Settings.VProtDirectory := DirectorySelectFrm.Directory ;
        // Populate Next Protocol list
        Stimulator.CreateProtocolList( cbNextProtocol ) ;
       end ;

     end ;


procedure TEditProtocolFrm.bLoadFileClick(Sender: TObject);
// ------------------------------------
// Load user-defined waveform from file
// ------------------------------------
begin

     OpenWaveDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     OpenWaveDialog.FileName := '*.txt' ;
     OpenWaveDialog.InitialDir := Settings.VProtDirectory ;
     SetCurrentDir(Settings.VProtDirectory);
     OpenWaveDialog.Title := 'Load user-defined waveform' ;

     if OpenWaveDialog.execute then begin
        Table.cells[1,bLoadFile.Tag] := OpenWaveDialog.FileName ;
        UpdateStimulusElement( SelectedStimulusElement ) ;
       end ;

     end;


procedure TEditProtocolFrm.FormCreate(Sender: TObject);
// -----------------------------------
// Initialisation when form is created
// -----------------------------------
var
    i : Integer ;
begin
    // Initialise file dialog boxes
    OpenDialog.InitialDir := Settings.VProtDirectory ;
    OpenWaveDialog.InitialDir := Settings.VProtDirectory ;
    SaveDialog.InitialDir := Settings.VProtDirectory ;

    // Initialise waveform buffer to empty
    for i := 0 to High(Prot.Stimulus) do begin
        Prot.Stimulus[i].Buf := Nil ;
        end ;
    SelectedStimulusElement := 0 ;
    end;

procedure TEditProtocolFrm.edDACUpdateIntervalKeyPress(Sender: TObject;
  var Key: Char);
begin
     if Key = #13 then UpdateRecordingTableParameters ;
     end;

procedure TEditProtocolFrm.ckFixedDACUpdateIntervalClick(Sender: TObject);
begin
     UpdateRecordingTableParameters ;
     end;


procedure TEditProtocolFrm.cbNextProtocolChange(Sender: TObject);
// ---------------------
// Next protocol changed
// ---------------------
begin
     UpdateRecordingTableParameters ;
     end;

procedure TEditProtocolFrm.bSaveClick(Sender: TObject);
// ---------------------
// Save protocol to file
// ---------------------
begin
     if FileName <> '' then FileName := SaveProtocolToXMLFile(FileName)
                       else SaveProtocol ;
     end;

procedure TEditProtocolFrm.FormActivate(Sender: TObject);
begin
     // If seal test is running, stop it since it interferes with A/D and D/A interval checks
     if Main.FormExists( 'SealTestFrm' ) then begin
        SealTestFrm.StopADCandDAC ;
        end ;
     end;

end.


