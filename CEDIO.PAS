unit Cedio;
{ =================================================================
  WinWCP - CED 1401 Interface Library V1.0
  (c) John Dempster, University of Strathclyde, All Rights Reserved
  12/2/97
  =================================================================}

interface

uses WinTypes,Dialogs, SysUtils, WinProcs,global, shared ;

  procedure CED_LoadLibrary  ;
  Procedure CED_GetADCVoltageRangeOptions( var RangeOptions : array of TADCRange ;
                                           var NumOptions : Integer) ;
  procedure  CED_GetSamplingIntervalRange( var MinInterval,MaxInterval : single ) ;
  procedure CED_InitialiseBoard ;
  procedure SendCommand( const CommandString : string ) ;
  procedure CED_ADCToMemory( var ADCBuf : array of integer ;
                             nChannels : LongInt ;
                             nSamples : LongInt ;
                             var dt : Single ;
                             ADCVoltageRange : Single ;
                             WaitForExtTrigger : Boolean ;
                             CircularBuffer : Boolean  ) ;
  procedure  CED_StopADC ;
  procedure  CED_MemoryToDAC( var DACBuf : array of integer ;
                              nChannels : LongInt ;
                              nPoints : LongInt ;
                              dt : Single ;
                              NumRepeats : LongInt ) ;
  procedure CED_ConvertToDACCodes( var DACBuf : Array of Integer ;
                                  nChannels : LongInt ;
                                  nPoints : LongInt ) ;
  procedure  CED_StopDAC ;

 procedure CED_GetLabInterfaceInfo( Supplier, Model : String ) ;

 procedure CED_ClockTicks( var dt : single ; var PreScale,Ticks : Word ) ;

{  Function  CED_ReadADC( Channel : Integer ; ADCVoltageRange : Single ) : Integer ;

  procedure  CED_CheckError( Err : Integer ) ;

  procedure  CED_WriteToDigitalOutPutPort( Pattern : LongInt ) ; }

  function  CED_GetMaxDACVolts : single ;
  procedure  CED_GetChannelOffsets( var Offsets : Array of LongInt ; NumChannels : LongInt ) ;
  {procedure  CED_ReportFailure( const ProcName : string ) ;}
  function  CED_IsLabInterfaceAvailable : boolean ;

implementation
const
     ClockPeriod = 1E-6 ; { 1MHz clock }
var
   DeviceNumber : Integer ;     { Lab. interface board in use }
   ADCVoltageRangeMax : single ;  { Max. positive A/D input voltage range}
   DACVoltageRangeMax : single ;
   MinSamplingInterval : single ;
   MaxSamplingInterval : single ;
   LibraryLoaded : boolean ;      { True if CED 1401 procedures loaded }
   DeviceInitialised : boolean ; { True if hardware has been initialised }
   Device : Integer ;

procedure CED_LoadLibrary  ;
{ ----------------------------------
  Load USE1401.DLL library into memory
  ----------------------------------}
var
   Hnd : THandle ;
   DLLName0 : array[0..79] of char ;
begin
     { Load library }
     StrPCopy( DLLName0,'USE1401.DLL');
     Hnd := LoadLibrary(DLLName0);

     { Get addresses of procedure NI_s used }
     if Hnd > HINSTANCE_ERROR then begin
        end
     else begin
          MessageDlg( 'USE1401.DLL library not found', mtWarning, [mbOK], 0 ) ;
          LibraryLoaded := False ;
          end ;
     end ;


procedure CED_GetLabInterfaceInfo( Supplier, Model : String ) ;
var
   Ver : LongInt ;
begin

     if not DeviceInitialised then CED_InitialiseBoard ;

     Supplier := 'Cambridge Electronic Design Ltd.' ;
     { Get the 1401 model }
    { case U14TypeOf1401( Device ) of
          U14TYPE1401 : Model := 'CED 1401 ';
          U14TYPEPLUS : Model := 'CED 1401-plus ';
          U14TYPEUNKNOWN : Model := 'CED 1401? ';
          else Model := 'CED 1401? ' ;
          end ; }
     { Add the CED1401.SYS driver version number }
     {Ver := U14DriverVersion ;}
     Model := Model + format('Driver V%d.%d',[Ver/$10000,Ver and $FFFF]) ;

     { Cancel all commands and reset 1401 }
     SendCommand( 'CLEAR;' ) ;

     end ;


Procedure CED_GetADCVoltageRangeOptions( var RangeOptions : array of TADCRange ;
                                         var NumOptions : Integer) ;
begin
     RangeOptions[0] := ' ±5V ' ;
     NumOptions := 1 ;
     end ;


function  CED_GetMaxDACVolts : single ;
{ -----------------------------------------------------------------
  Return the maximum positive value of the D/A output voltage range
  -----------------------------------------------------------------}
begin
     Result := DACVoltageRangeMax ;
     end ;

procedure  CED_GetSamplingIntervalRange( var MinInterval,MaxInterval : single ) ;
begin
     MinInterval := 4E-6 ;
     maxInterval := 1000. ;
     end ;


function  CED_IsLabInterfaceAvailable : boolean ;
begin
     if not DeviceInitialised then CED_InitialiseBoard ;
     Result := DeviceInitialised ;
     end ;


procedure CED_InitialiseBoard ;
{ -------------------------------------------
  Initialise CED 1401 interface hardware
  -------------------------------------------}
var
   RetValue : DWORD ;
   Err : Integer ;
begin

   DeviceInitialised := False ;
   { Open 1401 }
 {  Device := U14Open(0) ;}
   if Device > 0 then begin
      { Load required commands }
{      RetValue := U14Ld(Device,' ','ADCMEM,MEMDAC') ;
      Err := RetValue and $FFFF ;
      CheckError(Err)
      if Err = U14ERR_NOERROR then DeviceInitialised := True ;
      end
   else CheckError(Device) ;}
      end ;
   end ;


procedure CED_ADCToMemory( var ADCBuf : array of integer ;
                           nChannels : LongInt ;
                           nSamples : LongInt ;
                           var dt : Single ;
                           ADCVoltageRange : Single ;
                           WaitForExtTrigger : Boolean ;
                           CircularBuffer : Boolean  ) ;
var
   ch : Integer ;
   dt1 : single ;
   NumSamples : LongInt ;
   PreScale,Ticks : Word ;
   CommandString : string ;
begin

     if not DeviceInitialised then CED_InitialiseBoard ;

     { Kill any A/D conversions in progress }
     SendCommand( 'ADCMEM,K;') ;

     { Create ADCMEM command string }
     NumSamples := nChannels*nSamples ;
     CommandString := format('ADCMEM,I,2,0,%d,',[NumSamples]) ;
     { Add channel list }
     for ch := 0 to nChannels do
         CommandString := CommandString + format('%d ',[ch]);

     { Select single-sweep or circular transfer }
     if CircularBuffer then CommandString := CommandString + ',0,'
                       else CommandString := CommandString + ',1,' ;

     { Select immediate sweep or wait for ext. trigger pulse }
     if WaitForExtTrigger then CommandString := CommandString + 'CT,'
                          else CommandString := CommandString + 'C,' ;

     { Set sampling clock }
     dt1 := dt / nChannels ;
     CED_ClockTicks( dt1, PreScale, Ticks ) ;
     dt := dt * nChannels ;
     CommandString := CommandString + format('%d,%d;',[PreScale,Ticks] );

     SendCommand( CommandString ) ;
     end ;


procedure CED_ClockTicks( var dt : single ; var PreScale,Ticks : Word ) ;
var
   fTicks : single ;
begin
     PreScale := 0 ;
     repeat
          Inc(PreScale) ;
          fTicks := dt / (ClockPeriod*PreScale) ;
          until fTicks < 65535. ;
     Ticks := Trunc( fTicks ) ;
     dt := Ticks*PreScale*ClockPeriod ;
     end ;


procedure  CED_StopADC ;
begin
     { Kill any A/D conversions in progress }
     SendCommand( 'ADCMEM,K;') ;
     end ;

procedure  CED_MemoryToDAC( var DACBuf : array of integer ;
                              nChannels : LongInt ;
                              nPoints : LongInt ;
                              dt : Single ;
                              NumRepeats : LongInt ) ;
begin
     end ;
procedure CED_ConvertToDACCodes( var DACBuf : Array of Integer ;
                                  nChannels : LongInt ;
                                  nPoints : LongInt ) ;
begin
     end ;


procedure  CED_StopDAC ;
begin
     end ;



procedure SendCommand( const CommandString : string ) ;
{ -------------------------------
  Send a command to the CED 1401
  ------------------------------}
var
   Command : string ;
begin
     Command := CommandString + chr(0) ;
   {  CheckError( U14sendstring( Device, @Command[1] ) ;}
     end ;


procedure  CED_GetChannelOffsets( var Offsets : Array of LongInt ;
                                 NumChannels : LongInt ) ;
{ --------------------------------------------------------
  Returns the order in which analog channels are acquired
  and stored in the A/D data buffers
  --------------------------------------------------------}
var
   ch : Integer ;
begin
     for ch := 0 to NumChannels-1 do Offsets[ch] := ch ;
     end ;

initialization
    DeviceNumber := -1 ;
    LibraryLoaded := False ;
    DeviceInitialised := False ;
    MinSamplingInterval := 4E-6 ;
    MaxSamplingInterval := 1000. ;
    DACVoltageRangeMax := 5. ;
end.
