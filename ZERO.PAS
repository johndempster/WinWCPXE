unit Zero;
{ -----------------------------------------------------------
  WinWCP (c) J.Dempster, University of Strathclyde 1996-97
  Channel zero level setup module
  -----------------------------------------------------------
  3/8/99 ... 32 bit version
  29.08.12 ... Now callable from recordfrm and replay forms
  26.05.22 ... Channel zero settings now directly updated from within OK button method
               (Avoids zero being forced to record-relative when cancel button pressed)
  }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, maths, ValEdit,
  ValidatedEdit;

type
  TZeroFrm = class(TForm)
    TypeGrp: TGroupBox;
    rbFromRecord: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    rbFixed: TRadioButton;
    Label3: TLabel;
    edChannel: TEdit;
    bOK: TButton;
    bCancel: TButton;
    edNumAveraged: TValidatedEdit;
    edAtSample: TValidatedEdit;
    edFixedLevel: TValidatedEdit;
    procedure bOKClick(Sender: TObject);
    procedure rbFixedClick(Sender: TObject);
    procedure rbFromRecordClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Chan : Integer ;
    OldZeroAt : Integer ;
    NewZeroAt : Integer ;
    Level : Integer ;
    ChanName : String ;
    NumSamplesPerRecord : Integer ;
    NumZeroAveraged : Integer ;
    MaxValue : Integer ;
    EnableFromRecord : Boolean ;

  end;

var
  ZeroFrm: TZeroFrm;

implementation

{$R *.DFM}

uses WCPFIleUnit;

procedure TZeroFrm.FormShow(Sender: TObject);
{ ----------------------------------
  Initialisation when form is opened
  ---------------------------------- }
begin

//     ChanName := WCPFile.Channel[Chan].ADCName ;
     edChannel.text := format('Ch.%d %s',[Chan,WCPFile.Channel[Chan].ADCName]) ;
     OldZeroAt := WCPFile.Channel[Chan].ADCZeroAt ;
     NumZeroAveraged := WCPFile.FH.NumZeroAvg ;
     MaxValue := WCPFile.FH.MaxADCValue ;

     { Starting sample for zero level average (-1=fixed level) }
     edAtSample.LoLimit := 0 ;
     edAtSample.HiLimit := NumSamplesPerRecord-1 ;
     edAtSample.Value := NewZeroAt ;
     { Number of samples averaged to compute zero level }
     edNumAveraged.LoLimit := 1 ;
     edNumAveraged.HiLimit := NumSamplesPerRecord ;
     edNumAveraged.Value := NumZeroAveraged ;
     { Amplitude of zero level when in fixed zero mode }
     edFixedLevel.LoLimit := -MaxValue ;
     edFixedLevel.HiLimit := MaxValue ;
     edFixedLevel.Value := Level ;

     rbFromRecord.Enabled := EnableFromRecord ;
     if (OldZeroAt >= 0) and EnableFromRecord then begin
        { Enable "From Record" zero level options }
        rbFromRecord.checked := True ;
        edAtSample.enabled := True ;
        edNumAveraged.enabled := True ;
        edFixedLevel.enabled := False ;
        end
     else begin
        { Enabled "Fixed" zero level options }
        rbFixed.checked := True ;
        edFixedLevel.enabled := True ;
        edAtSample.enabled := False ;
        edNumAveraged.enabled := False ;
        end ;
     end ;



procedure TZeroFrm.bOKClick(Sender: TObject);
{ -----------------
  Update zero level
  ----------------- }
begin
     if rbFromRecord.checked then begin
          NewZeroAt := Round(edAtSample.Value) ;
          NumZeroAveraged := Round(edNumAveraged.Value) ;
          WCPFile.FH.NumZeroAvg := NumZeroAveraged ;
          WCPFile.Channel[Chan].ADCZeroAt := NewZeroAt ;
          end
     else begin
          Level := Round(edFixedLevel.Value) ;
          WCPFile.Channel[Chan].ADCZero := ZeroFrm.Level ;
          NewZeroAt := -1 ;
          WCPFile.Channel[Chan].ADCZeroAt := NewZeroAt ;
          end ;

     // Save changes to file header
     WCPFile.SaveHeader( WCPFile.FH ) ;

     end;


procedure TZeroFrm.rbFixedClick(Sender: TObject);
begin
        edFixedLevel.enabled := True ;
        edAtSample.enabled := False ;
        edNumAveraged.enabled := False ;
        end;

procedure TZeroFrm.rbFromRecordClick(Sender: TObject);
begin
        edAtSample.enabled := True ;
        edNumAveraged.enabled := True ;
        edFixedLevel.enabled := False ;
        end;


end.
