unit use1902;
{ ============================================================
  CED 1902 amplifier control module
  (c) J. Dempster, University of Strathclyde, 1996-98
  23/8/98
  8/2/01 Updated to function as proper data module
  ============================================================}

interface

uses
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, WinProcs,WinTypes ;

type


  TCED1902 = class(TDataModule)
  private
    { Private declarations }
    procedure TransmitLine( const Line : string ) ;
    function  ReceiveLine : string ;

  public
    { Public declarations }
    ComPort : LongInt ;
    ComHandle : Integer ;
    InUse : Boolean ;
    Input : LongInt ;
    InputName : string[16] ;
    Gain : LongInt ;
    GainValue : Single ;
    HPFilter : LongInt ;
    HPFilterValue : Single ;
    LPFilter : LongInt ;
    LPFilterValue : Single ;
    NotchFilter : LongInt ;
    ACCoupled : LongInt ;
    DCOffset : LongInt ;
    DCOffsetVMax : single ;
    OverLapStructure : POverlapped ;

    function Check1902Error : string ;
    procedure UpdateAmplifier ;
    function DCOffsetRange : single ;
    procedure GetList( Command : string ; Var List : TStringList ) ;
    function Query( Request : string ) : string ;
    function OpenLink : Boolean ;
    procedure CloseLink ;

  end;


var
  CED1902: TCED1902;

implementation

{$R *.DFM}

uses shared ;



{ --------------------------------------
  Write a line of ASCII text to Com port
  --------------------------------------}
procedure TCED1902.TransmitLine(
          const Line : string   { Text to be sent to Com port }
          ) ;
var
   i,nC,nWritten : Integer ;
   xBuf : array[0..258] of char ;
   Overlapped : POverlapped ;
begin
     { Copy command line to be sent to xMit buffer and and a CR character }
     nC := Length(Line) ;
     for i := 1 to nC do xBuf[i-1] := Line[i] ;
     xBuf[nC] := chr(13) ;
     Inc(nC) ;

    Overlapped := Nil ;
    WriteFile( ComHandle, xBuf, nC, nWritten, Overlapped ) ;

     if nWRitten <> nC then
        MessageDlg( ' Error writing to COM port ', mtWarning, [mbOK], 0 ) ;
     end ;


{ --------------------------------------
  Retrieve error information from 1902
  --------------------------------------}
function TCED1902.Check1902Error : string ;         { Error flag returned  }
var
   i,nC : Integer ;
   xBuf : array[0..258] of char ;
   Line : string ;
begin


     Line := '?ER;' ;
     nC := Length(Line) ;
     for i := 1 to nC do xBuf[i-1] := Line[i] ;
     xBuf[nC] := chr(13) ;
     Inc(nC) ;
     if FileWrite( ComHandle, xBuf, nC ) = nC then begin
        Result := ReceiveLine ;
        end
     else begin
        Result := ' Error writing to COM port ' ;
        end ;
     end ;


{ -------------------------------------------------------
  Read bytes from Com port until a line has been received
  -------------------------------------------------------}
function TCED1902.ReceiveLine : string ;          { Return line of bytes received }
const
     TimeOut = 500 ;
var
   Line : string ;
   rBuf : array[0..1] of char ;
   NumBytesRead : LongInt ;
   ComState : TComStat ;
   PComState : PComStat ;
   TimeOutTickCount : LongInt ;
   ComError : Integer ;
begin
     { Set time that ReceiveLine will give up at if a full line has not
       been received }
     TimeOutTickCount := GetTickCount + TimeOut ;

     PComState := @ComState ;
     Line := '' ;
     repeat
        rBuf[0] := ' ' ;
        { Find out if there are any characters in receive buffer }
        ClearCommError( ComHandle, ComError, PComState )  ;
        NumBytesRead := 0 ;
        if ComState.cbInQue > 0 then begin
           ReadFile( ComHandle,
                     rBuf,
                     1,
                     NumBytesRead,
                     OverlapStructure ) ;
           end ;

        if NumBytesRead > 0 then begin
           if (rBuf[0] <> chr(13)) and (rBuf[0]<>chr(10)) then
              Line := Line + rBuf[0] ;
           end ;
        until (rBuf[0] = chr(13)) or (GetTickCount >= TimeOutTickCount) ;
     Result := Line ;
     end ;


{ ---------------------------------------------------
  Transmit gain/filter settings to CED 1902 amplifier
  ---------------------------------------------------}
procedure TCED1902.UpdateAmplifier ;
var
   OK : Boolean ;
begin
     { Open com link to CED 1902 }
     OK := OpenLink ;
     { If open successful, send commands }
     if OK then begin

        { Problem Here ?? First command to 1902 getting ignored }
        TransmitLine(format('IP%d;',[Input]));
        TransmitLine(format('IP%d;',[Input]));
        TransmitLine(format('GN%d;',[Gain]));
        TransmitLine(format('LP%d;',[LPFilter]));
        TransmitLine(format('HP%d;',[HPFilter]));
        TransmitLine(format('AC%d;',[ACCoupled]));
        TransmitLine(format('NF%d;',[NotchFilter]));

        { Set DC Offset }
        TransmitLine('OR1;' );
        TransmitLine(format('OF%d;',[DCOffset]));
        TransmitLine('OR1;') ;
        TransmitLine(format('OF%d;',[DCOffset]));

        CloseLink ;
        end ;
     end ;


function TCED1902.OpenLink : Boolean ;
var
   DCB : TDCB ;           { Device control block for COM port }
   CommTimeouts : TCommTimeouts ;
begin

     if ComPort <= 1 then ComPort := 1 ;
     if ComPort >= 2 then ComPort := 2 ;

     { Open com port  }
     ComHandle :=  CreateFile( PCHar(format('COM%d',[CED1902.ComPort])),
                               GENERIC_READ or GENERIC_WRITE,
                               0,
                               Nil,
                               OPEN_EXISTING,
                               FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED,
                               0) ;

     if ComHandle >= 0 then begin

        { Get current state of COM port and fill device control block }
        GetCommState( ComHandle, DCB ) ;
        { Change settings to those required for 1902 }
        DCB.BaudRate := CBR_9600 ;
        DCB.ByteSize := 7 ;
        DCB.Parity := EVENPARITY ;
        DCB.StopBits := ONESTOPBIT ;

        { Update COM port }
        SetCommState( ComHandle, DCB ) ;

        { Initialise Com port and set size of transmit/receive buffers }
        SetupComm( ComHandle, 4096, 4096 ) ;

        { Set Com port timeouts }
        GetCommTimeouts( ComHandle, CommTimeouts ) ;
        CommTimeouts.ReadIntervalTimeout := $FFFFFFFF ;
        CommTimeouts.ReadTotalTimeoutMultiplier := 0 ;
        CommTimeouts.ReadTotalTimeoutConstant := 0 ;
        CommTimeouts.WriteTotalTimeoutMultiplier := 0 ;
        CommTimeouts.WriteTotalTimeoutConstant := 5000 ;
        SetCommTimeouts( ComHandle, CommTimeouts ) ;
        Result := True ;
        end
     Else Result := False ;
     end ;


procedure TCED1902.CloseLink ;
begin
     CloseHandle( ComHandle ) ;
     end ;


 function TCED1902.DCOffsetRange : single ;
 begin
      if Input = 1 then Result := 0.0005
      else if Input = 2 then Result := 0.5
      else if Input = 3 then Result := 0.0005
      else if Input = 4 then Result := 0.0005
      else if Input = 5 then Result := 0.0001
      else Result := 0.0001 ;
      end ;


procedure TCED1902.GetList(
           Command : string ;       { Command requesting list }
           Var List : TStringList   { List of strings returned from 1902 }
           ) ;
var
   NumItems,i : Integer ;
   InBuf : string ;
begin
     { Request list of gains }
     TransmitLine( Command ) ;
     InBuf := ReceiveLine ;
     if InBuf = '' then begin
        TransmitLine( Command ) ;
        InBuf := ReceiveLine ;
        end ;
     { Read  list back from 1902 }

     NumItems := ExtractInt( InBuf ) ;
     List.Clear ;
     for i := 0 to NumItems-1 do begin
         List.Add( ReceiveLine ) ;
         end ;


     end ;

function TCED1902.Query(
         Request : string         { Request 1902 command string }
         ) : string ;
var
   InBuf : string ;
begin
     InBuf := '' ;

     { Request list of gains }
     TransmitLine( Request ) ;
     InBuf := ReceiveLine ;
     if InBuf = '' then begin
        TransmitLine( Request ) ;
        InBuf := ReceiveLine ;
        end ;
     Result := InBuf ;

     end ;


end.
