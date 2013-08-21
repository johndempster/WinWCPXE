unit Ced1902u;
{ ================================================
  WCP for Windows (c) J. Dempster, 1997
  CED 1902 Programmable Amplifier control module
  20/8/99 32 bit version for WinWCP V3.0
  26/02/01 Updated to use AmpModule which now contains CED 1902 support methods
  27/02/01 CED 1902 support now working
  23/05/01 Amplifier.GainValue now updated when gain changed
  31/07/06 Error messages when no CED 1902 available handled
  ================================================}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, global, shared, Spin, maths,
  ValEdit, ValidatedEdit ;

type

  TCED1902Frm = class(TForm)
    CED1902Group: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    ckCED1902NotchFilter: TCheckBox;
    cbCED1902LPFilter: TComboBox;
    cbCED1902HPFilter: TComboBox;
    InputGrp: TGroupBox;
    Label7: TLabel;
    cbCED1902Input: TComboBox;
    Label8: TLabel;
    cbCED1902Gain: TComboBox;
    ckCED1902ACCoupled: TCheckBox;
    cbCED1902ComPort: TComboBox;
    Label11: TLabel;
    lbDCOffset: TLabel;
    edDCOffset: TValidatedEdit;
    bCheck1902: TButton;
    edCED1902Type: TEdit;
    Label1: TLabel;
    procedure cbCED1902GainChange(Sender: TObject);
    procedure cbCED1902InputChange(Sender: TObject);
    procedure cbCED1902LPFilterChange(Sender: TObject);
    procedure cbCED1902HPFilterChange(Sender: TObject);
    procedure ckCED1902NotchFilterClick(Sender: TObject);
    procedure ckCED1902ACCoupledClick(Sender: TObject);
    procedure cbCED1902ComPortChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EdDCOffsetKeyPress(Sender: TObject; var Key: Char);
    procedure bCheck1902Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure GetCED1902Options ;
  public
    { Public declarations }

  end;

var
  CED1902Frm: TCED1902Frm;

function VMaxDCOffset( CED1902Input : LongInt ) : single ;

implementation

{$R *.DFM}

uses mdiform, AmpModule ;
const
     IP_GROUNDED = 1 ;
     IP_TRANSDUCER_SE = 2 ;
     IP_TRANSDUCER_DIFF = 3 ;
     IP_TRANSDUCER_INV = 4 ;
     IP_ELECTRODES_GROUNDED = 5 ;
     IP_ELECTRODES = 6 ;

function VMaxDCOffset( CED1902Input : LongInt ) : single ;
var
   V : single ;
begin
     case CED1902Input of
          IP_ELECTRODES, IP_ELECTRODES_GROUNDED : V := 0.01 ;
          IP_TRANSDUCER_SE : V := 5. ;
     else
          V := 0.0005 ;
          end ;
     Result := V ;
     end ;


procedure TCED1902Frm.FormShow(Sender: TObject);
{ --------------------------------------
  Initialisations when form is displayed
  --------------------------------------}
begin

     Main.mnCED1902.Enabled := false ;

     { CED 1902 Communications port list }
     cbCED1902ComPort.clear ;
     cbCED1902ComPort.items.add( ' COM1 ' ) ;
     cbCED1902ComPort.items.add( ' COM2 ' ) ;
     cbCED1902ComPort.items.add( ' COM3 ' ) ;
     cbCED1902ComPort.items.add( ' COM4 ' ) ;
     cbCED1902ComPort.ItemIndex := Amplifier.CED1902.ComPort - 1 ;

     // Set amplifier
     Amplifier.SetCED1902 ;
     // Read back amplifier settings
     GetCED1902Options ;

     end;



procedure TCED1902Frm.cbCED1902GainChange(Sender: TObject);
{ ------------------------------
  Update CED 1902 gain settings
  -----------------------------}
begin
     { Update Ch.0 Amplifier. gain }
     Amplifier.CED1902.Gain := cbCED1902Gain.ItemIndex + 1;
     // Update attached CED 1902 amplifier
     Amplifier.SetCED1902 ;

     Amplifier.CED1902.GainValue := ExtractFloat(
                                    cbCED1902Gain.items[cbCED1902Gain.ItemIndex],
                                    Amplifier.CED1902.GainValue ) ;

     end;


procedure TCED1902Frm.cbCED1902InputChange(Sender: TObject);
{ ---------------------
  Update CED 1902 input
  ---------------------}
begin
     Amplifier.CED1902.Input := cbCED1902Input.itemIndex + 1;
     // Update attached CED 1902 amplifier
     Amplifier.SetCED1902 ;
     { Update Gain list }
     cbCED1902Gain.clear ;
     Amplifier.GetCED1902List( '?GS;', cbCED1902Gain.Items ) ;
     // Current gain setting
     cbCED1902Gain.Itemindex := Amplifier.CED1902.Gain - 1 ;

     // Gain value
     Amplifier.CED1902.GainValue := ExtractFloat(
                                    cbCED1902Gain.items[cbCED1902Gain.ItemIndex],
                                    Amplifier.CED1902.GainValue ) ;

     end;


procedure TCED1902Frm.cbCED1902LPFilterChange(Sender: TObject);
{ -------------------------------
  Update CED 1902 low pass filter
  -------------------------------}
begin
     Amplifier.CED1902.LPFilter := cbCED1902LPFilter.ItemIndex ;
     // Update attached CED 1902 amplifier
     Amplifier.SetCED1902 ;
     end;


procedure TCED1902Frm.cbCED1902HPFilterChange(Sender: TObject);
{ --------------------------------
  Update CED 1902 high pass filter
  --------------------------------}
begin
     Amplifier.CED1902.HPFilter := cbCED1902HPFilter.ItemIndex ;
     // Update attached CED 1902 amplifier
     Amplifier.SetCED1902 ;
     end;


procedure TCED1902Frm.ckCED1902NotchFilterClick(Sender: TObject);
{ --------------------------------------
  Update CED 1902 50Hz notch pass filter
  --------------------------------------}
begin
     if ckCED1902NotchFilter.checked then Amplifier.CED1902.NotchFilter := 1
                                     else Amplifier.CED1902.NotchFilter := 0 ;
     // Update attached CED 1902 amplifier
     Amplifier.SetCED1902 ;
     end;


procedure TCED1902Frm.ckCED1902ACCoupledClick(Sender: TObject);
{ -------------------------------
  Update CED 1902 AC/DC coupling
  -------------------------------}
begin
     if ckCED1902ACCoupled.checked   then Amplifier.CED1902.ACCoupled := 1
                                     else Amplifier.CED1902.ACCoupled := 0 ;
     Amplifier.SetCED1902 ;
     end;


procedure TCED1902Frm.cbCED1902ComPortChange(Sender: TObject);
{ -----------------------------------
  Update CED 1902 communications port
  -----------------------------------}
begin
     Amplifier.CED1902.ComPort := cbCED1902ComPort.itemIndex + 1 ;
     end;


procedure TCED1902Frm.FormClose(Sender: TObject; var Action: TCloseAction);
// ---------------------------
// Tidy up when form is closed
// ---------------------------
begin

     // Read back amplifier settings to make sure all settings are up to date
     GetCED1902Options ;

     Main.mnCED1902.Enabled := true ;
     Action := caFree ;
     end;


procedure TCED1902Frm.EdDCOffsetKeyPress(Sender: TObject; var Key: Char);
{ -------------------------
  Update CED 1902 DC Offset
  -------------------------}
begin
     if key = chr(13) then begin
        Amplifier.CED1902.DCOffset := Round( edDCOffset.Value ) ;
        // Update attached CED 1902 amplifier
        Amplifier.SetCED1902 ;
        end ;
     end;

procedure TCED1902Frm.bCheck1902Click(Sender: TObject);
begin
     // Update attached CED 1902 amplifier
     Amplifier.SetCED1902 ;
     end;


procedure TCED1902Frm.GetCED1902Options ;
{ ------------------------------------------
  Get gain/filter options list from CED 1902
  ------------------------------------------}
var
   i : Integer ;
   OK : Boolean ;
   CED1902Type : string ;
begin

   edCED1902Type.text := 'Disabled' ;

   // Ensure CED 1902 COM link is open
   if Amplifier.CED1902.ComHandle < 0 then OK := Amplifier.OpenCED1902
                                      else OK := True ;

   { Read gain/filter options }
   if OK then CED1902Type := Amplifier.QueryCED1902( '?IF;' ) ;

   if OK and (CED1902Type <> '') then begin

      { Type of CED 1902 input stage }
      edCED1902Type.text := ' ' ;
      for i := 3 to Length(CED1902Type) do
          edCED1902Type.text := edCED1902Type.text + CED1902Type[i] ;

      if Amplifier.AmplifierType[1] = amCED1902 then
         edCED1902Type.text := edCED1902Type.text + ' (In Use)' ;

      { Input list }
      cbCED1902Input.Clear ;
      Amplifier.GetCED1902List( '?IS;', cbCED1902Input.Items ) ;
      cbCED1902Input.Itemindex := Amplifier.CED1902.Input - 1 ;

      { Gain list }
      cbCED1902Gain.clear ;
      Amplifier.GetCED1902List( '?GS;', cbCED1902Gain.Items ) ;
      // Current gain setting
      cbCED1902Gain.Itemindex := Amplifier.CED1902.Gain - 1 ;
      // Gain value
      Amplifier.CED1902.GainValue := ExtractFloat(
                                     cbCED1902Gain.items[cbCED1902Gain.ItemIndex],
                                     Amplifier.CED1902.GainValue ) ;

      { Low pass filter list }
      cbCED1902LPFilter.clear ;
      cbCED1902LPFilter.items.add(' None ' ) ;
      Amplifier.GetCED1902List( '?LS;', cbCED1902LPFilter.Items ) ;
      cbCED1902LPFilter.itemindex := Amplifier.CED1902.LPFilter ;

      { High pass filter list }
      cbCED1902HPFilter.clear ;
      cbCED1902HPFilter.items.add(' None ' ) ;
      Amplifier.GetCED1902List( '?HS;', cbCED1902HPFilter.Items ) ;
      cbCED1902HPFilter.itemindex := Amplifier.CED1902.HPFilter ;

      { 50Hz Notch filter }
      if Amplifier.CED1902.NotchFilter = 1 then ckCED1902NotchFilter.checked := True
                                           else ckCED1902NotchFilter.checked := False ;
      {AC/DC Coupling }
      if Amplifier.CED1902.ACCoupled = 1 then ckCED1902ACCoupled.checked := True
                                         else ckCED1902ACCoupled.checked := False ;

      cbCED1902Gain.enabled := True ;
      cbCED1902Input.enabled :=  True ;
      cbCED1902LPFilter.enabled :=  True ;
      cbCED1902HPFilter.enabled :=  True ;
      ckCED1902ACCoupled.enabled :=  True ;
      ckCED1902NotchFilter.enabled :=  True ;

      end
   else begin
      edCED1902Type.text := ' CED 1902 not available' ;
      cbCED1902Input.clear ;
      cbCED1902Input.Items.Add( ' None ' ) ;
      cbCED1902Input.Itemindex := 0 ;
      { Gain list }
      cbCED1902Gain.clear ;
      cbCED1902Gain.Items.Add( ' X1' ) ;
      cbCED1902Gain.Itemindex := 0 ;

      { Low pass filter list }
      cbCED1902LPFilter.clear ;
      cbCED1902LPFilter.items.add(' None ' ) ;
      cbCED1902LPFilter.itemindex := 0 ;
      { High pass filter list }
      cbCED1902HPFilter.clear ;
      cbCED1902HPFilter.items.add(' None ' ) ;
      cbCED1902HPFilter.itemindex := 0 ;
      { CED 1902 settings are disabled if not in use }
      cbCED1902Gain.enabled := False ;
      cbCED1902Input.enabled :=  False ;
      cbCED1902LPFilter.enabled :=  False ;
      cbCED1902HPFilter.enabled :=  False ;
      ckCED1902ACCoupled.enabled :=  False ;
      ckCED1902NotchFilter.enabled :=  False ;
      end ;

   if Amplifier.CED1902.ComHandle >= 0 then Amplifier.CloseCED1902 ;
   end ;



end.
