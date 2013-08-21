unit Ced1902;
{ ================================================
  WCP for Windows (c) J. Dempster, 1997
  CED 1902 Programmable Amplifier control module
  20/8/99 32 bit version for WinWCP V3.0
  ================================================}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, global, shared, Spin, maths, Use1902, ced1401,
  ValEdit ;

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
    ckCED1902InUse: TCheckBox;
    ckCED1902ACCoupled: TCheckBox;
    cbCED1902ComPort: TComboBox;
    Label11: TLabel;
    lbDCOffset: TLabel;
    edDCOffset: TValidatedEdit;
    bApply: TButton;
    procedure ckCED1902InUseClick(Sender: TObject);
    procedure cbCED1902GainChange(Sender: TObject);
    procedure cbCED1902InputChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCED1902LPFilterChange(Sender: TObject);
    procedure cbCED1902HPFilterChange(Sender: TObject);
    procedure ckCED1902NotchFilterClick(Sender: TObject);
    procedure ckCED1902ACCoupledClick(Sender: TObject);
    procedure cbCED1902ComPortChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EdDCOffsetKeyPress(Sender: TObject; var Key: Char);
    procedure bApplyClick(Sender: TObject);
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

uses mdiform ;
const
     IP_GROUNDED = 1 ;
     IP_TRANSDUCER_SE = 2 ;
     IP_TRANSDUCER_DIFF = 3 ;
     IP_TRANSDUCER_INV = 4 ;
     IP_ELECTRODES_GROUNDED = 5 ;
     IP_ELECTRODES = 6 ;

procedure TCED1902Frm.FormCreate(Sender: TObject);
{ -------------------------------------
  Initialisations when form is created
  ------------------------------------}
var
   VScale : single ;
begin

     GetCED1902Options ;

     { CED 1902 Communications port list }
     cbCED1902ComPort.clear ;
     cbCED1902ComPort.items.add( ' COM1 ' ) ;
     cbCED1902ComPort.items.add( ' COM2 ' ) ;
     cbCED1902ComPort.ItemIndex := CED1902.ComPort - 1 ;

     Main.mnCED1902.Enabled := false ;

     end;


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


procedure TCED1902Frm.ckCED1902InUseClick(Sender: TObject);
{ -----------------------
  Enable/disable CED 1902
  -----------------------}
begin

     if ckCED1902InUse.checked then begin
        CED1902.InUse := True ;
        SetCED1902( CED1902 ) ;
        end
     else CED1902.InUse := False ;

     { CED 1902 settings are disabled if not in use }
     cbCED1902Gain.enabled := ckCED1902InUse.checked ;
     cbCED1902Input.enabled := ckCED1902InUse.checked ;
     cbCED1902LPFilter.enabled := ckCED1902InUse.checked ;
     cbCED1902HPFilter.enabled := ckCED1902InUse.checked ;
     ckCED1902ACCoupled.enabled := ckCED1902InUse.checked ;
     ckCED1902NotchFilter.enabled := ckCED1902InUse.checked ;
     cbCED1902ComPort.enabled := ckCED1902InUse.checked ;

     end;


procedure TCED1902Frm.cbCED1902GainChange(Sender: TObject);
{ ------------------------------
  Update CED 1902 gain settings
  -----------------------------}
begin
     { Update Ch.0 amplifier gain }
     CED1902.Gain := cbCED1902Gain.ItemIndex + 1;
     CED1902.GainValue := ExtractFloat( cbCED1902Gain.items[cbCED1902Gain.ItemIndex],
                          CED1902.GainValue ) ;
     if CED1902.InUse then SETCED1902( CED1902 ) ;
     end;


procedure TCED1902Frm.cbCED1902InputChange(Sender: TObject);
{ ---------------------
  Update CED 1902 input
  ---------------------}
begin
     { Regenerate Gain combo box if Input has changed
       because Electrodes input has an extra X100 gain
       on all settings }

     { Update Ch.0 amplifier gain }
     CED1902.Input := cbCED1902Input.itemIndex + 1;
     SETCED1902( CED1902 ) ;

     end;


procedure TCED1902Frm.cbCED1902LPFilterChange(Sender: TObject);
{ -------------------------------
  Update CED 1902 low pass filter
  -------------------------------}
begin
     CED1902.LPFilter := cbCED1902LPFilter.ItemIndex ;
     SETCED1902( CED1902 ) ;
     end;


procedure TCED1902Frm.cbCED1902HPFilterChange(Sender: TObject);
{ --------------------------------
  Update CED 1902 high pass filter
  --------------------------------}
begin
     CED1902.HPFilter := cbCED1902HPFilter.ItemIndex ;
     SETCED1902( CED1902 ) ;
     end;


procedure TCED1902Frm.ckCED1902NotchFilterClick(Sender: TObject);
{ --------------------------------------
  Update CED 1902 50Hz notch pass filter
  --------------------------------------}
begin
     if ckCED1902NotchFilter.checked then CED1902.NotchFilter := 1
                                     else CED1902.NotchFilter := 0 ;
     SETCED1902( CED1902 ) ;
     end;


procedure TCED1902Frm.ckCED1902ACCoupledClick(Sender: TObject);
{ -------------------------------
  Update CED 1902 AC/DC coupling
  -------------------------------}
begin
     if ckCED1902ACCoupled.checked   then CED1902.ACCoupled := 1
                                     else CED1902.ACCoupled := 0 ;
     SETCED1902( CED1902 ) ;
     end;


procedure TCED1902Frm.cbCED1902ComPortChange(Sender: TObject);
{ -----------------------------------
  Update CED 1902 communications port
  -----------------------------------}
begin
     CED1902.ComPort := cbCED1902ComPort.itemIndex + 1 ;
     CED1902.InUse := False ;
     end;


procedure TCED1902Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Main.mnCED1902.Enabled := true ;
     Action := caFree ;
     end;


procedure TCED1902Frm.EdDCOffsetKeyPress(Sender: TObject; var Key: Char);
{ -------------------------
  Update CED 1902 DC Offset
  -------------------------}
begin
     if key = chr(13) then begin
        CED1902.DCOffset := Round( edDCOffset.Value ) ;
        if CED1902.InUse then SETCED1902( CED1902 ) ;
        end ;
     end;

procedure TCED1902Frm.bApplyClick(Sender: TObject);
begin
     if CED1902.InUse then SETCED1902( CED1902 ) ;
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

   CED1902.InUse := ckCED1902InUse.checked ;

   if CED1902.InUse then begin
      { Get lists from CED 1902 }

      { Open com port to CED 1902 }
      OK := CED1902.OpenLink ;

      { Read gain/filter options }
      if OK then CED1902Type := CED1902.Query( '?IF;' ) ;
      if OK and (CED1902Type <> '') then begin

         { Type of CED 1902 input stage }
         edCED1902Type.text := ' ' ;
         for i := 3 to Length(CED1902Type) do
             edCED1902Type.text := edCED1902Type.text + CED1902Type[i] ;

         { Input list }
         cbCED1902Input.Clear ;
         CED1902.GetList( '?IS;', cbCED1902Input.Items ) ;
         cbCED1902Input.Itemindex := CED1902.Input - 1 ;

         { Gain list }
         cbCED1902Gain.clear ;
         CED1902.GetList( '?GS;', cbCED1902Gain.Items ) ;
         cbCED1902Gain.Itemindex := CED1902.Gain - 1 ;

         { Low pass filter list }
         cbCED1902LPFilter.clear ;
         cbCED1902LPFilter.items.add(' None ' ) ;
         CED1902.GetList( '?LS;', cbCED1902LPFilter.Items ) ;
         cbCED1902LPFilter.itemindex := CED1902.LPFilter ;

         { High pass filter list }
         cbCED1902HPFilter.clear ;
         cbCED1902HPFilter.items.add(' None ' ) ;
         CED1902.GetList( '?HS;', cbCED1902HPFilter.Items ) ;
         cbCED1902HPFilter.itemindex := CED1902.HPFilter ;

         { 50Hz Notch filter }
         if CED1902.NotchFilter = 1 then ckCED1902NotchFilter.checked := True
                                    else ckCED1902NotchFilter.checked := False ;
         {AC/DC Coupling }
         if CED1902.ACCoupled = 1 then ckCED1902ACCoupled.checked := True
                                  else ckCED1902ACCoupled.checked := False ;

         end
      else begin
         CED1902.InUse := False ;
         ckCED1902InUse.Checked := False ;
         edCED1902Type.text := '1902 not available' ;
         end ;

      CED1902.CloseLink ;

      end ;

   if not CED1902.InUse then begin
      { Input list }
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
      end ;

   { CED 1902 settings are disabled if not in use }
   cbCED1902Gain.enabled := ckCED1902InUse.checked ;
   cbCED1902Input.enabled := ckCED1902InUse.checked ;
   cbCED1902LPFilter.enabled := ckCED1902InUse.checked ;
   cbCED1902HPFilter.enabled := ckCED1902InUse.checked ;
   ckCED1902ACCoupled.enabled := ckCED1902InUse.checked ;
   ckCED1902NotchFilter.enabled := ckCED1902InUse.checked ;

   end ;

end.
