unit AmpModule;
// -------------------------------------------------------------
// Patch clamp and computer-controlled amplifier support module
// -------------------------------------------------------------
// (c) J. Dempster, University of Strathclyde, 2001, All rights reserved.
// USERS OF THIS SOFTWARE MAY MODIFY IT FOR PERSONAL PURPOSES ASSOCIATED
// WITH ACADEMIC RESEARCH. ITS SALE OR INCORPORATION INTO COMMERCIALLY
// DISTRIBUTED PRODUCTS IN WHOLE OR IN PART IS FORBIDDEN WITHOUT THE
// THE EXPRESS PERMISSION OF THE AUTHOR OR THE UNIVERSITY OF STRATHCLYDE
// 20/2/02 Axopatch 200 added
// 26/02/02 Axopatch 200 tested and working correctly
// NOTE Axopatch 200 gain telegraph values X100 or larger require +/-10V ADC range
// 26/2/01 CED 1902 support moved to this module
// 7/8/01 Integers changed to DWORD to make it compile under Delphi 5
// 17.5.02 Communications with CED 1902 via COM port now works under Windows NT/2000
// 24.6.03 Support for WPC-100 patch clamp added
// 25.8.03 CED 1902 queried after each command sent
//         (fixes failure to set AC coupling with 29xx s/n 1902s)
// 24.2.04 VP500 amplifier gain added
// 8.3.04 Errors in WCP-100 gain telegraph corrected
//        Biologic RK400 added
//        All gain telegraphs now use same signal reading algorithm
//        Cairn Optopatch added
//        26.05.04 Axon MultiClamp 700 support added
// 10.08.04 Biologic RK400 gain readout fixed
// 15.09.04 Support for Heka EPC-8 amplifier added (not yet tested)
// 16.09.04 Support for NPI Turbo Tec 03 added
// 06.11.04 Support for A-M Systems 2400 added
// 08.11.04 Two amplifiers now supported
// 12.01.05 Optopatch gain now read correctly
// 13.02.05 AMS-2400 gain corrected
// 14.02.05 Support for NPI Turbo Tec 10C added
// 18.07.05 Support for NPI SEC 05LX switch clamp added
// 29.07.05 NPI SEC 05LX gain corrected
// 01.08.05 NPI SEC 05LX gain corrected (finally?)
// 05.09.05 CED 1902 gain now reading properly
// 12.09.05 EPC-8 digital gain telegraph now supported
//          (Tested with CED1401 at Plymouth CPW)
// 12.13.05 Dagan PC-One patch clamp added
// 11.1.06  CED 1902 settings now downloaded before gain is read
//          if it has not been initialised
// 12.04.06 Support for Dagan 3900A added
// 20.06.06 Multiclamp 700A now supported correctly
//          Primary & Secondary Multiclamp channels can now be changed
// 28.07.06 Warner OC725C, PC501A and PC505B support added
//          Axopatch 200 voltage- current- clamp switching now supported
//          via mode telegraph
// 17.08.06 Telegraph voltage reading now done by GetTelegraphVoltage
// 03.09.06 Mode telegraph support for Cairn Optopatch added
//          Full range of Optopatch telegraph (Big cell-Patch) now covered
// 18.08.07 Default gain telegraph now 7 and mode 6 making it same as user gude
// 18.03.08 Axoclamp 2 and Dagan TEV200A support added
// 28.05.08 Support for Tecella Triton added
// 03.06.08 Amplifiers can now be addressed independently
//          .Number property removed .SetAmpType GetAmpType removed
// 04.06.08 Support for Axoclamp 900A added
// 14.07.08 Support for NPI Turbo TEC-05, TEC-10C, TEC-10CX, TEC-20, TEC-30 added
//          (consoldated into single TurboTec function
//          Amplifier number now stored as object in amplifier list rather than index
//          Allowing amplifiers to be listed in a better order.
// 12.09.08 NPI Turbo-Tec03X gain scaling now correct
// 29.09.09 Dagan PCOne gain telegraph now read correctly over whole range
// 01.02.10 Calibration for Axoclamp 2 corrected and support for HS1, HS10 and HS0.1
//          headstages added
// 12.07.10 X1000 error when Multiclamp returned gain in V/pA (rather than V/nA) units
//          now fixed. Gain with 50 GOhm feedback resistor now correct.
// 10.09.10 Heka EPC-800 added
// 01.11.10 AM Systems 2400 iGain now kept within range of gain array
// 10.05.11 AM Systems 2400 Current/voltage clamp mode telegraph now supported
// 13.06.11 Heka EPC-7 amplifier added
// 17.08.11 FP violation when Multiclamp amplifier selected and
//             record window is first window opened fixed, by ensuring that
//             multiclamp connection is opened before returning channel settings
//             See OpenMulticlamp procedure
// 19/08/11 ... SaveToXML() files can now be appended to existing files
// 13/09/11 ... EPC 800 gain and mode telegraph updated and now working correctly
// 17/10/11 ... Optopatch default command voltage scaling factor corrected to 0.1 V/V
//  20.12.11 To avoid OLE exceptions and access violations, LoadFromXML/SaveToXML
//           now Coinitialise/Codeinitialize COM system before after creation of
//           TXMLDocument. XMLDOC now an IXMLDocument rather than a TXMLDocument.
// 16.01.12 GetElementFloat() now handles both ',' and '.' decimal separators
// 06.03.12 Default current command sensitivity now set to 2E-10 for AMS-2400 amplifier
// 08.03.12 Clamp gain and mode can now be set manually when gain or mode telegraph channel not in use
//          (rather than being fixed in VCLAMP mode)
// 11.03.12 Current and voltage clamp scale factors and units now stored in XML file. User
//          can now change Axopatch 200, a-m 2400 s
//          .ModeSwitchedPrimaryChannel property added indicating whether signal produced by
//          primary channel changes when VC/CC mode switched
// 15.03.12 AMS 2400 current command scale factor set to 2E-9 A/V
// 17.04.12 GetAmplifierType(AmpNum) now returns amNone type when AmpNum >= MaxAmplifiers
//          FPrimaryOutputChannelNames[] etc. no longer updated if AmpNum >= MaxAmplifiers
// 19.09.12 Default command voltage scaling factor of EPC-800 now set to 0.1 (rather than 0.02)
// 30.07.13 Dagan CA-1B Oocyte clamp added
//          Modified to compile under Delphi XE..
//          .GainTelegraphName and .ModeTelegraphName properties added
//          Multiclamp 700B primary channel units now reported correctly
//  20.08.13 'amplifier settings.xml' now stored in Windows
//          <common documents folder>\WinWCP\amplifier settings.xml' rather than program folder
// 27.08.13 Dagan CA1B now reads gain telegraph correctly
// 03.09.13 Heka EPC-9/10 added
// 20.09.13 Heka EPC-10 tested and working
// 04.12.13 Two Multiclamp 700Bs now supported (4 amplifiers)
//          MCTelegraphData[] array now 0 rather than 1 based.
// 17.12.13 Addition Multiclamp messages reported to log file
// 19.12.13 Addition Multiclamp messages to log file updated (may now support 2 amplifiers)
// 22.01.14 Multiclamp support updated to API V2.x Now detects Multiclamp device serial number
// 15.05.14 Amplifier # now appended to channel name if more than one amplifier in use
// 23.07.14 V1.1 message received report format corrected.  No longer produces error.
//          TCopyData updated for 64 bit compatibility
// 25.07.14 V1.1 API now detects channel correctly
// 19.08.14 Support for NPI ELC03X amplifier added
// 18.09.14 Amplifier.VoltageCommandChannel and Amplifier.CurrentCommandChannel properties can now updated
//          and Amplifier.VoltageCommandScaleFactor and Amplifier.CurrentCommandScaleFactor now indexed by
//          Amplifier.VoltageCommandChannel and Amplifier.CurrentCommandChannel (rather than AmpNumber)
//          Now permits correct Axoclamp 2 current channel scaling factor to be recognised.
// 15.12.14 .ResetMultiClamp700 added (closes link forcing it to be reestablished)
// 22.04.15 Multiclamp 700A/B channels now correctly assigned to analog inputs when two Multiclamp 700A/Bs
//          in use Amp #1 (lower s.n) Ch.1 1.Primary->AI0,Secondary->AI1, Ch.2 1.Primary->AI2,Secondary->AI3
//                 Amp #2 (higher s.n) Ch.1 1.Primary->AI4,Secondary->AI5, Ch.2 1.Primary->AI6,Secondary->AI7
// 05.05.15 Multiclamp 700A/B Now correctly allocates Channel 1 of second Multiclamp 700A/B as Amplifier #3
// 29.07.15 Dagan BVC-700A added.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Math, strutils,
  xmldoc, xmlintf,ActiveX, shlobj, fileio  ;

const
     MaxAmplifiers = 4 ;
     MaxAmplifierChannels = MaxAmplifiers*2 ;


     amCurrentClamp = 1 ;
     amVoltageClamp = 0 ;

     amNone = 0 ;
     amAxopatch1d = 1 ;
     amAxopatch200 = 2 ;
     amCED1902 = 3 ;
     amWPC100 = 4 ;
     amVP500 = 5 ;
     amRK400 = 6 ;
     amOptopatch = 7 ;
     amMultiClamp700A = 8 ;
     amMultiClamp700B = 9 ;
     amEPC8 = 10 ;
     amTurboTec03 = 11 ;
     amAMS2400 = 12 ;
     amTurboTec10C = 13 ;
     amSEC05LX = 14 ;
     amManual = 15 ;
     amDaganPCOne10M = 16 ;
     amDaganPCOne100M = 17 ;
     amDaganPCOne1G = 18 ;
     amDaganPCOne10G = 19 ;
     amDagan3900A10nA = 20 ;
     amDagan3900A100nA = 21 ;
     amWarnerPC501A = 22 ;
     amWarnerPC505B = 23 ;
     amWarnerOC725C = 24 ;
     amAxoclamp2HS1 = 25 ;
     amDaganTEV200A = 26 ;
     amTriton = 27 ;
     amAxoClamp900A = 28 ;
     amTurboTec05 = 29 ;
     amTurboTec10CX = 30 ;
     amTurboTec20 = 31 ;
     amTurboTec30 = 32 ;
     amAxoclamp2HS10 = 33 ;
     amAxoclamp2HS01 = 34 ;
     amHekaEPC800 = 35 ;
     amEPC7 = 36 ;
     amDaganCA1B = 37 ;
     amHekaEPC9 = 38 ;
     amNPIELC03SX = 39 ;
     amDaganBVC700A = 40
     ;
     NumAmplifiers = 41 ;

     // Patch clamp mode flags
     VClampMode = 0 ;
     IClampMode = 1 ;

     // Axon Multi-Clamp constants
     MCTG_API_VERSION = 5;
     MCTG_OPEN_MESSAGE_STR : PChar = 'MultiClampTelegraphOpenMsg';
     MCTG_CLOSE_MESSAGE_STR : PChar = 'MultiClampTelegraphCloseMsg';
     MCTG_REQUEST_MESSAGE_STR : PChar = 'MultiClampTelegraphRequestMsg';
     MCTG_RECONNECT_MESSAGE_STR : PChar = 'MultiClampTelegraphReconnectMsg';
     MCTG_BROADCAST_MESSAGE_STR : PChar = 'MultiClampTelegraphBroadcastMsg';
     MCTG_ID_MESSAGE_STR : PChar = 'MultiClampTelegraphIdMsg';

     MCTG_MAX_CLIENTS = 16;

     MCTG_MODE_VCLAMP = 0;
     MCTG_MODE_ICLAMP = 1;
     MCTG_MODE_ICLAMPZERO = 2;
     MCTG_MODE_NUMCHOICES = 3;

     MCTG_OUT_MUX_COMMAND         = 0;
     MCTG_OUT_MUX_I_MEMBRANE      = 1;
     MCTG_OUT_MUX_V_MEMBRANE      = 2;
     MCTG_OUT_MUX_V_MEMBRANEx100  = 3;
     MCTG_OUT_MUX_I_BATH          = 4;
     MCTG_OUT_MUX_V_BATH          = 5;

     MCTG_OUT_MUX_NUMCHOICES_700A      = 6;
     MCTG_ChanNames700A_VC : Array[0..MCTG_OUT_MUX_NUMCHOICES_700A-1] of String =
     ('Vm','Im','Vp','Vm(AC)','Ib','Vb') ;
     MCTG_ChanNames700A_CC : Array[0..MCTG_OUT_MUX_NUMCHOICES_700A-1] of String =
     ('Icom','Im','Vm','Vm(AC)','Ib','Vb') ;

     MCTG_OUT_MUX_NUMCHOICES_700B = 50 ;
     MCTG_ChanNames700B : Array[0..MCTG_OUT_MUX_NUMCHOICES_700B-1] of String = (
     'Im','Vm','Vp','Vm(AC)','Vcom','5','6','7','8','9',
     'Im','Vm','Vp','Vm(AC)','Vcom','15','16','17','18','19',
     'Vm','Im','Icom','Vm(AC)','Icom','25','26','27','28','29',
     'Vm','Im','Vp','Vm(AC)','Icom','35','36','37','38','39',
     'AUX1','41','42','AUX2','44','45','46','47','48','49' ) ;
     MCTG_OUT_MUX_MAXCHOICES = MCTG_OUT_MUX_NUMCHOICES_700B ;

     MCTG_UNITS_VOLTS_PER_VOLT      = 0;
     MCTG_UNITS_VOLTS_PER_MILLIVOLT = 1;
     MCTG_UNITS_VOLTS_PER_MICROVOLT = 2;
     MCTG_UNITS_VOLTS_PER_AMP       = 3;
     MCTG_UNITS_VOLTS_PER_MILLIAMP  = 4;
     MCTG_UNITS_VOLTS_PER_MICROAMP  = 5;
     MCTG_UNITS_VOLTS_PER_NANOAMP   = 6;
     MCTG_UNITS_VOLTS_PER_PICOAMP   = 7;
     MCTG_ChannelUnits : Array[0..7] of String =
     ('V','mV','uV','A','mA','uA', 'nA', 'pA' ) ;

     MCTG_LPF_BYPASS         = 1.0e+5;
     MCTG_NOMEMBRANECAP      = 0.0e+0;

     MCTG_HW_TYPE_MC700A      = 0;
     MCTG_HW_TYPE_NUMCHOICES  = 1;


     AXC_CHAN_1                 = 0;
     AXC_CHAN_2                 = 1;
     AXC_MAX_CHANNELS           = 2;

     AXC_CHAN_ALL               = 2;
     AXC_CHAN_NONE              = 3;

// Axoclamp 900A
     AXC_SOCHAN_1               = 0;
     AXC_SOCHAN_2               = 1;
     AXC_MAX_SOCHANNELS         = 2;
     AXC_MODE_IZERO             = 0;
     AXC_MODE_ICLAMP            = 1;
     AXC_MODE_DCC               = 2;
     AXC_MODE_HVIC              = 3;
     AXC_MODE_DSEVC             = 4;
     AXC_MODE_TEVC              = 5;
     AXC_MAX_MODES              = 6;
     AXC_MODE_NONE              = 6;
     AXC_MODE_ALL               = 7;
     ACX_HW_TYPE_AC900A      = 0;
     ACX_HW_TYPE_NUMCHOICES  = 1;
     ACX_HW_TYPE_CURRENT     = ACX_HW_TYPE_AC900A;
     AXC_AUTO_TEVC              = 0;
     AXC_AUTO_DSEVC             = 1;
     AXC_AUTO_ICRETURN_MANUAL   = 0;
     AXC_AUTO_ICRETURN_EXTERNAL = 1;
     AXC_AUTO_ICRETURN_DELAY    = 2;
     AXC_AUTO_POLARITY_NTOP     = 0;
     AXC_AUTO_POLARITY_PTON     = 1;
     AXC_AUTO_SOURCE_EXTERNAL   = 0;
     AXC_AUTO_SOURCE_INTERNAL   = 1;
     AXC_SIGNAL_ID_XICMD1      = 0;
     AXC_SIGNAL_ID_ICMD1       = 1;
     AXC_SIGNAL_ID_10V1        = 2;
     AXC_SIGNAL_ID_I1          = 3;
     AXC_SIGNAL_ID_MON         = 4;
     AXC_SIGNAL_ID_RMP         = 5;
     AXC_SIGNAL_ID_XICMD2      = 6;
     AXC_SIGNAL_ID_ICMD2       = 7;
     AXC_SIGNAL_ID_10V2        = 8;
     AXC_SIGNAL_ID_I2          = 9;
     AXC_SIGNAL_ID_DIV10V2     = 10;
     AXC_SIGNAL_ID_DIV10I2     = 11;
     AXC_SIGNAL_ID_XVCMD       = 12;
     AXC_SIGNAL_ID_VCMD        = 13;
     AXC_SIGNAL_ID_10AUX1      = 14;
     AXC_SIGNAL_ID_10AUX2      = 15;
     AXC_SIGNAL_ID_10mV        = 16;
     AXC_SIGNAL_ID_GND         = 17;

//==============================================================================================
// Headstage types - 6 to 19 reserved for future headstages
//==============================================================================================
  AXC_HEADSTAGE_TYPE_HS9_ADAPTER          = 0;   // custom headstage, user entered Rf and Ci value
  AXC_HEADSTAGE_TYPE_HS9_x10uA            = 1;   // Rf = 1M
  AXC_HEADSTAGE_TYPE_HS9_x1uA             = 2;   // Rf = 10M
  AXC_HEADSTAGE_TYPE_HS9_x100nA           = 3;   // Rf = 100M
  AXC_HEADSTAGE_TYPE_VG9_x10uA            = 4;   // Rf = 1M
  AXC_HEADSTAGE_TYPE_VG9_x100uA           = 5;   // Rf = 0.1M
  AXC_HEADSTAGE_TYPE_NONE                 = 20;  // headstage not connected


    AXC_SignalName : Array[0..17] of String = (
    'Vc1',
    'Ic1',
    'Vm1',
    'Im1',
    'DCC1',
    'Vrmp',
    'Ic2x',
    'Ic2',
    'Vm2',
    'Im2',
    'Vm2/10',
    'Im2/10',
    'Vex',
    'Vc',
    'Aux1',
    'Aux2',
    'Test',
    'Gnd'
    ) ;

    AXC_SignalUnits : Array[0..17] of String = (
    'mV', {Vc1}
    'nA', {Ic1}
    'mV', {Vm1}
    'nA', {Im1}
    'mV', {DCC1}
    'mV', {Vrmp}
    'nA', {Ic2x}
    'nA', {Ic2}
    'mV', {Vm2}
    'nA', {Im2}
    'mV', {Vm2/10}
    'nA', {Im2/10}
    'mV', {Vex}
    'mV', {Vc}
    'mV', {Aux1}
    'nA', {Aux2}
    'mV', {Test}
    'mV'  {Gnd}
    ) ;

    AXC_ChanCalFactors : Array[0..17] of Single = (
    0.01, {Vc1}
    0.01, {Ic1}
    0.01, {Vm1}
    0.01, {Im1}
    0.01, {DCC1}
    0.01, {Vrmp}
    0.1,  {Ic2x}
    0.1,  {Ic2}
    0.01,  {Vm2}
    0.1, {Im2}
    0.001, {Vm2/10}
    0.01, {Im2/10}
    0.01, {Vex}
    0.01, {Vc}
    0.01, {Aux1}
    0.01, {Aux2}
    0.01, {Test}
    0.01  {Gnd}
    ) ;

type

TCopyDataStruct = record
    dwData : NativeUInt ;
    cbData : NativeInt ;
    lpData : Pointer ;
    end ;
PCopyDataStruct = ^TCopyDataStruct ;

// Axon Multiclamp Commander data record
TMC_TELEGRAPH_DATA = packed record
   Version : Cardinal ;            // must be set to MCTG_API_VERSION
   StructSize : Cardinal ;         // currently 128 bytes
   ComPortID : Cardinal ;          // ( one-based  counting ) 1 -> 8
   AxoBusID : Cardinal ;           // ( zero-based counting ) 0 -> 9
   ChannelID : Cardinal ;          // ( one-based  counting ) 1 -> 2
   OperatingMode : Cardinal ;      // use constants defined above
   PrimaryScaledOutSignal : Cardinal ;    // use constants defined above
   PrimaryAlpha : Double ;              // scaled output gain (dimensionless)
   PrimaryScaleFactor : Double ;        // gain scale factor ( for dAlpha == 1 )
   PrimaryScaleFactorUnits : Cardinal ;   // use constants defined above
   LPFCutoff : Double ;          // ( Hz ) , ( MCTG_LPF_BYPASS indicates Bypass )
   MembraneCap : Double ;        // ( F  )
   ExtCmdSens : Double ;         // external command sensitivity
   SecondaryOutSignal : Cardinal ;       // use constants defined above
   SecondaryScaleFactor : Double ;     // gain scale factor ( for dAlpha == 1 )
   SecondaryScaleFactorUnits : Cardinal ;// use constants defined above
   HardwareType : Cardinal ;       // use constants defined above
   SecondaryAlpha : Double ;

   SecondaryLPFCutoff : Double ;   // ( Hz ) , ( MCTG_LPF_BYPASS indicates Bypass )
                                   // for SECONDARY output signal.
   AppVersion : Array[0..15] of ANSIChar ;       // application version number
   FirmwareVersion : Array[0..15] of ANSIChar ;  // firmware version number
   DSPVersion : Array[0..15] of ANSIChar ;       // DSP version number
   SerialNumber : Array[0..15] of ANSIChar ;     // serial number of device

   SeriesResistance : Double ;     // ( Rs )
                                   // dSeriesResistance will be MCTG_NOSERIESRESIST
                                   // if we are not in V-Clamp mode,
                                   // or
                                   // if Rf is set to range 2 (5G) or range 3 (50G),
                                   // or
                                   // if whole cell comp is explicitly disabled.
   pcPadding1 : Array[1..76] of Byte ;
   end ;
PMC_TELEGRAPH_DATA = ^TMC_TELEGRAPH_DATA ;

TCED1902 = record
           ComPort : LongInt ;
           ComHandle : Integer ;
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
           AmplifierSet : Boolean ;
           end ;

// Axoclamp 900A

TAXC_Signal = record
    Channel : Integer ;
    ID : Integer ;
    Name : pANSIChar ;
    Valid : Boolean ;
    end ;

// Create the Axoclamp device object and return a handle.

TAXC_CheckAPIVersion = function(QueryVersion : pANSIChar ) : Boolean ;

TAXC_CreateHandle = function(
                    bDemo : Boolean ;
                    var Error : Integer ) : Integer ; stdcall ;

// Destroy the Axoclamp device object specified by handle.
TAXC_DestroyHandle = procedure(
                     AxHandle : Integer
                     ) ; stdcall ;


// Find the first Axoclamp 900x and return device info.
TAXC_FindFirstDevice = function(
                       AxHandle : Integer ;
                       pszSerialNum : pANSIChar ;
                       uBufSize : Integer ;
                       var Error : Integer ) : Boolean ; stdcall ;

// Find next Axoclamp 900x and return device info, returns FALSE when all Axoclamp 900x devices have been found.
TAXC_FindNextDevice = function(
                       AxHandle : Integer ;
                       pszSerialNum : pANSIChar ;
                       uBufSize : Integer ;
                       var Error : Integer ) : Boolean ; stdcall ;

// Open Axoclamp 900x device.
TAXC_OpenDevice = function(
                  AxHandle : Integer ;
                  pszSerialNum : pANSIChar ;
                  bReadHardware : Boolean ;
                  var Error : Integer ) : Boolean  ; stdcall ;

// Close Axoclamp 900x device.
TAXC_CloseDevice = function(
                   AxHandle : Integer ;
                   var Error : Integer ) : Boolean  ; stdcall ;

// Get Axoclamp 900x device serial number.
TAXC_GetSerialNumber = function(
                       AxHandle : Integer ;
                       pszSerialNum : pANSIChar ;
                       uBufSize : Integer ;
                       var Error : Integer ) : Boolean  ; stdcall ;

// Is an Axoclamp 900x device open?
TAXC_IsDeviceOpen = function(
                     AxHandle : Integer ;
                     var pbOpen : Boolean ;
                     var Error : Integer ) : Boolean  ; stdcall ;

// Get scaled output signal
TAXC_GetScaledOutputSignal = function(
                             HAxHandle : Integer ;
                             var Signal : Integer ;
                             Channel : Integer ;
                             Mode : Integer ;
                             var Error : Integer) : Boolean  ; stdcall ;

// Set scaled output signal
TAXC_SetScaledOutputSignal = function(
                             HAxHandle : Integer ;
                             Signal : Integer ;
                             Channel : Integer ;
                             Mode : Integer ;
                             var Error : Integer) : Boolean  ; stdcall ;


// Get scaled output gain
TAXC_GetScaledOutputGain = function(
                           AxHandle : Integer ;
                           var Gain : Double ;
                           Channel : Integer ;
                           Mode : Integer ;
                           var Error : Integer) : Boolean  ; stdcall ;

// Get scaled output gain
TAXC_SetScaledOutputGain = function(
                           AxHandle : Integer ;
                           Gain : Double ;
                           Channel : Integer ;
                           Mode : Integer ;
                           var Error : Integer) : Boolean  ; stdcall ;


TAXC_GetMode = function(
               AxHandle : Integer ;
               Channel : Integer ;
               var Mode : Integer ;
               var Error : Integer) : Boolean  ; stdcall ;

TAXC_GetDeviceName = function(
                     AxHandle : Integer ;
                     Name : pANSIChar ;
                     BufSize : Integer ;
                     var Error : Integer ) : Boolean  ; stdcall ;

TAXC_SetMode = function(
               AxHandle : Integer ;
               Channel : Integer ;
               Mode : Integer ;
               var Error : Integer ) : Boolean  ; stdcall ;

TAXC_BuildErrorText = function(
                  AxHandle : Integer ;
                  ErrorNum : Integer ;
                  ErrorText : pANSIChar ;
                  MaxLen : Integer ) : Boolean  ; stdcall ;

TAXC_GetSignalScaleFactor = function(
                            AxHandle : Integer ;
                            var ScaleFactor : Double ;
                            Signal : Integer ;
                            var Error : Integer) : Boolean  ; stdcall ;

TAXC_GetHeadstageType = function(
                        AxHandle : Integer ;
                        var HeadstageType : Integer ;
                        Channel : Integer ;
                        Auxiliary : Boolean ;
                        var Error : Integer ) : Boolean  ; stdcall ;

  TAmplifier = class(TDataModule)
    procedure AmplifierCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FAmpType : Array[0..MaxAmplifiers] of Integer ;
    FGainTelegraphAvailable : Array[0..MaxAmplifiers] of Boolean ;
    FNeedsGainTelegraphChannel : Array[0..MaxAmplifiers] of Boolean ;
    FGainTelegraphChannel : Array[0..MaxAmplifiers] of Integer ;
    LastGain : Array[0..MaxAmplifiers] of Single ;  // Last telegraph gain value

    FModeTelegraphAvailable : Array[0..MaxAmplifiers] of Boolean ;
    FNeedsModeTelegraphChannel : Array[0..MaxAmplifiers] of Boolean ;
    FModeTelegraphChannel : Array[0..MaxAmplifiers] of Integer ;
    FModeSwitchedPrimaryChannel : Array[0..MaxAmplifiers] of Boolean ;

    LastMode : Array[0..MaxAmplifiers] of Integer ; // Last telegraph mode value
    //Dummy : Array[0..100] of Integer ;
    FPrimaryOutputChannelName : Array[0..MaxAmplifiers] of String ;
    FPrimaryChannelUnits : Array[0..MaxAmplifiers] of String ;
    FPrimaryOutputChannel : Array[0..MaxAmplifiers] of Integer ;
    FPrimaryChannelScaleFactor : Array[0..MaxAmplifiers] of Single ;
    FPrimaryChannelScaleFactorX1Gain : Array[0..MaxAmplifiers] of Single ;
    FPrimaryOutputChannelNameCC : Array[0..MaxAmplifiers] of String ;
    FPrimaryChannelUnitsCC : Array[0..MaxAmplifiers] of String ;
    FPrimaryChannelScaleFactorX1GainCC : Array[0..MaxAmplifiers] of Single ;

    FSecondaryOutputChannelName : Array[0..MaxAmplifiers] of String ;
    FSecondaryChannelUnits : Array[0..MaxAmplifiers] of String ;
    FSecondaryOutputChannel : Array[0..MaxAmplifiers] of Integer ;
    FSecondaryChannelScaleFactor : Array[0..MaxAmplifiers] of Single ;
    FSecondaryChannelScaleFactorX1Gain : Array[0..MaxAmplifiers] of Single ;
    FSecondaryOutputChannelNameCC : Array[0..MaxAmplifiers] of String ;
    FSecondaryChannelUnitsCC : Array[0..MaxAmplifiers] of String ;
    FSecondaryChannelScaleFactorX1GainCC : Array[0..MaxAmplifiers] of Single ;

    FVoltageCommandScaleFactor : Array[0..MaxAmplifiers] of Single ;
    FVoltageCommandChannel : Array[0..MaxAmplifiers] of Integer ;
    FCurrentCommandScaleFactor : Array[0..MaxAmplifiers] of Single ;
    FCurrentCommandChannel : Array[0..MaxAmplifiers] of Integer ;

    FAmpCurrentChannel : Integer ;
    FAmpVoltageChannel : Integer ;

    SettingsFileName : String ;

    // Multiclamp Commander
    MCConnectionOpen : Boolean ;
    MCNumChannels : Cardinal ;
    MCChannels: Array[0..16] of Cardinal ;
    MCOpenMessageID : Cardinal ;
    MCCloseMessageID : Cardinal ;
    MCRequestMessageID : Cardinal ;
    MCReconnectMessageID : Cardinal ;
    MCBroadcastMessageID : Cardinal ;
    MCIDMessageID : Cardinal ;

    // Axoclamp 900A
    Axoclamp900ALibPath : String ;
    Axoclamp900ALibLoaded : Boolean ;
    Axoclamp900AOpen : Boolean ;
    Axoclamp900ALibHnd : Integer ;
    Axoclamp900AHIDHnd : Integer ;
    Axoclamp900AHnd : Integer ;

   procedure AddAmplifierNumber(
          var Name : string ;
          iChan : Integer ) ;

    procedure GetNoneChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;

    procedure GetManualChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;

    procedure GetCED1902ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;


    function GetAxopatch1DGain(
         AmpNumber : Integer ) : single ;
    function GetAxopatch1DMode(
         AmpNumber : Integer ) : Integer ;
    procedure GetAxopatch1DChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;

    function GetAxopatch200Gain(
         AmpNumber : Integer ) : single ;
    function GetAxopatch200Mode(
         AmpNumber : Integer ) : Integer ;
    procedure GetAxopatch200ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;

    function GetWPC100Gain(
         AmpNumber : Integer ) : single ;
    function GetWPC100Mode(
         AmpNumber : Integer ) : Integer ;
    procedure GetWPC100ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;

    function GetVP500Gain(
         AmpNumber : Integer ) : single ;
    function GetVP500Mode(
         AmpNumber : Integer ) : Integer ;
    procedure GetVP500ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;

    function GetRK400Gain(
         AmpNumber : Integer ) : single ;
    function GetRK400Mode(
         AmpNumber : Integer ) : Integer ;
    procedure GetRK400ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;

    function GetOptopatchGain(
         AmpNumber : Integer ) : single ;
    function GetOptopatchMode(
         AmpNumber : Integer )  : Integer ;
    procedure GetOptopatchChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;

    procedure OpenMultiClamp ;
    function GetMultiClampGain(
         AmpNumber : Integer ) : single ;
    function GetMultiClampMode(
         AmpNumber : Integer )  : Integer ;
    procedure GetMultiClampChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetTurboTecGain(
         AmpNumber : Integer ) : single ;
    function GetTurboTecMode(
         AmpNumber : Integer ) : Integer ;
    procedure GetTurboTecChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetAMS2400Gain(
         AmpNumber : Integer ) : single ;
    function GetAMS2400Mode(
         AmpNumber : Integer )  : Integer ;
    procedure GetAMS2400ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetEPC8Gain(
         AmpNumber : Integer ) : single ;
    function GetEPC8Mode(
         AmpNumber : Integer )  : Integer ;
    procedure GetEPC8ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetSEC05LXGain(
         AmpNumber : Integer ) : single ;
    function GetSEC05LXMode(
         AmpNumber : Integer ) : Integer ;
    procedure GetSEC05LXChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetDaganPCOneGain(
         AmpNumber : Integer ) : single ;
    function GetDaganPCOneMode(
         AmpNumber : Integer ) : Integer ;
    procedure GetDaganPCOneChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetDagan3900AGain(
         AmpNumber : Integer ) : single ;
    function GetDagan3900AMode(
         AmpNumber : Integer ) : Integer ;
    procedure GetDagan3900AChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetWarnerPC501AGain(
         AmpNumber : Integer ) : single ;
    function GetWarnerPC501AMode(
         AmpNumber : Integer )  : Integer ;
    procedure GetWarnerPC501AChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetWarnerPC505BGain(
         AmpNumber : Integer ) : single ;
    function GetWarnerPC505BMode(
         AmpNumber : Integer ) : Integer ;
    procedure GetWarnerPC505BChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetWarnerOC725CGain(
         AmpNumber : Integer ) : single ;
    function GetWarnerOC725CMode(
         AmpNumber : Integer )  : Integer ;
    procedure GetWarnerOC725CChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetAxoClamp2Gain(
         AmpNumber : Integer ) : single ;
    function GetAxoClamp2Mode(
         AmpNumber : Integer )  : Integer ;
    procedure GetAxoClamp2ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetDaganTEV200AGain(
         AmpNumber : Integer ) : single ;
    function GetDaganTEV200AMode(
         AmpNumber : Integer ) : Integer ;
    procedure GetDaganTEV200AChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetTritonGain(
         AmpNumber : Integer ) : single ;
    function GetTritonMode(
         AmpNumber : Integer )  : Integer ;
    procedure GetTritonChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetAxoclamp900AGain(
         ChanNumber : Integer ) : single ;
    function GetAxoclamp900AMode(
         AmpNumber : Integer )  : Integer ;
    procedure GetAxoclamp900AChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;
    procedure OpenAxoclamp900A ;
    procedure CloseAxoclamp900A ;
    procedure CheckErrorAxoclamp900A( Err : Integer ) ;

    function GetHekaEPC800Gain(
             AmpNumber : Integer ) : single ;
    function GetHekaEPC800Mode(
             AmpNumber : Integer ) : Integer ;

    function GetHekaEPC9Gain(
             AmpNumber : Integer ) : single ;
    function GetHekaEPC9Mode(
             AmpNumber : Integer ) : Integer ;

    function GetDaganCA1BGain(
             AmpNumber : Integer ) : single ;

    procedure GetHekaEPC800ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    procedure GetEPC7ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    procedure GetHekaEPC9ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    procedure GetDaganCA1BChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    function GetNPIELC03SXGain(
         AmpNumber : Integer ;
         TelChan : Integer ) : single ;
    procedure GetNPIELC03SXChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : Single ;
          var ChanScale : Single
          ) ;

    procedure GetDaganBVC700AChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;

    function LoadProcedure(
         Hnd : THandle ;       { Library DLL handle }
         Name : string         { Procedure name within DLL }
         ) : Pointer ;         { Return pointer to procedure }

    function AppHookFunc(var Message : TMessage) : Boolean;


    function GetCurrentCommandScaleFactor(  AOChan : Integer ) : Single ;
    procedure SetCurrentCommandScaleFactor(  AOChan : Integer ; Value : Single ) ;
    function GetCurrentCommandChannel(  AOChan : Integer ) : Integer ;
    procedure SetCurrentCommandChannel(  AOChan : Integer ; Value : Integer ) ;

    function GetVoltageCommandScaleFactor(  AOChan : Integer ) : Single ;
    procedure SetVoltageCommandScaleFactor(  AOChan : Integer ; Value : Single ) ;
    function GetVoltageCommandChannel(  AOChan : Integer ) : Integer ;
    procedure SetVoltageCommandChannel(  AOChan : Integer ; Value : Integer ) ;
    function GetCommandScaleFactor(  AmpNumber : Integer ) : Single ;

    function GetNeedsGainTelegraphChannel(  AmpNumber : Integer ) : Boolean ;
    procedure SetGainTelegraphChannel( AmpNumber : Integer ; Value : Integer ) ;
    function  GetGainTelegraphChannel(  AmpNumber : Integer ) : Integer  ;
    function GetGainTelegraphAvailable( AmpNumber : Integer ) : Boolean ;

    procedure SetModeTelegraphChannel( AmpNumber : Integer ; Value : Integer ) ;
    function  GetModeTelegraphChannel( AmpNumber : Integer ) : Integer  ;
    function GetNeedsModeTelegraphChannel(  AmpNumber : Integer ) : Boolean ;
    function GetModeTelegraphAvailable( AmpNumber : Integer ) : Boolean ;

    function  GetGainTelegraphName(  AmpNumber : Integer ) : String  ;
    function  GetModeTelegraphName(  AmpNumber : Integer ) : String  ;

    function GetModeSwitchedPrimaryChannel( AmpNumber : Integer ) : Boolean ;

    procedure SetAmplifierType( AmpNumber : Integer ; Value : Integer ) ;
    function GetAmplifierType( AmpNumber : Integer ) : Integer ;

    function  GetPrimaryOutputChannel(  AmpNumber : Integer ) : Integer  ;
    function  GetPrimaryOutputChannelName(  AmpNumber : Integer ; ClampMode : Integer ) : String  ;
    function  GetSecondaryOutputChannel(  AmpNumber : Integer ) : Integer  ;
    function  GetSecondaryOutputChannelName(  AmpNumber : Integer ; ClampMode : Integer ) : String  ;

    function getPrimaryChannelScaleFactor( AmpNumber : Integer ) : Single ;
    function getSecondaryChannelScaleFactor( AmpNumber : Integer ) : Single ;
    function getPrimaryChannelScaleFactorX1Gain( AmpNumber : Integer ; ClampMode : Integer ) : Single ;
    function getSecondaryChannelScaleFactorX1Gain( AmpNumber : Integer ; ClampMode : Integer ) : Single ;
    function getPrimaryChannelUnits( AmpNumber : Integer ; ClampMode : Integer) : String ;
    function getSecondaryChannelUnits( AmpNumber : Integer ; ClampMode : Integer) : String ;
    procedure SetPrimaryChannelScaleFactor( AmpNumber : Integer ; Value : Single ) ;
    procedure SetSecondaryChannelScaleFactor( AmpNumber : Integer ; Value : Single ) ;
    procedure SetPrimaryChannelScaleFactorX1Gain( AmpNumber : Integer ; ClampMode : Integer ; Value : Single ) ;
    procedure SetSecondaryChannelScaleFactorX1Gain( AmpNumber : Integer ; ClampMode : Integer ; Value : Single ) ;
    procedure SetPrimaryChannelUnits( AmpNumber : Integer ; ClampMode : Integer ;Value : String ) ;
    procedure SetSecondaryChannelUnits( AmpNumber : Integer ; ClampMode : Integer ; Value : String ) ;


    function GetModelName( AmpNumber : Integer ) : String ;

    // XML procedures
    procedure AddElementFloat(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Single
              ) ;
    function GetElementFloat(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Single
              ) : Boolean ;
    procedure AddElementInt(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Integer
              ) ;
    function GetElementInt(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Integer
              ) : Boolean ;
    procedure AddElementBool(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Boolean
              ) ;
    function GetElementBool(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Boolean
              ) : Boolean ;

    procedure AddElementText(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : String
              ) ;
    function GetElementText(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : String
              ) : Boolean ;

    function FindXMLNode(
         const ParentNode : IXMLNode ;  // Node to be searched
         NodeName : String ;            // Element name to be found
         var ChildNode : IXMLNode ;     // Child Node of found element
         var NodeIndex : Integer        // ParentNode.ChildNodes Index #
                          // Starting index on entry, found index on exit
         ) : Boolean ;

    procedure ForceNonZero( var Value : single ) ;

    procedure LoadFromXMLFile1( FileName : String ) ;
    procedure SaveToXMLFile1( FileName : String ;
                             AppendData : Boolean ) ;

    function GetSpecialFolder(const ASpecialFolderID: Integer): string;

  public
    { Public declarations }

    CED1902 : TCED1902 ;        // CED 1902 Amplifier settings
    MCTelegraphData : Array[0..15] of TMC_TELEGRAPH_DATA ; // Multiclamp 700 settings

    function SettingsFileExists : Boolean ;
    procedure GetList( List : TStrings ) ;
    function GetGain( AmpNumber : Integer ) : single ;

    // CED 1902 amplifier procedures/functions
    procedure TransmitLine( const Line : string ) ;
    function  ReceiveLine : string ;
    function Check1902Error : string ;
    procedure SetCED1902 ;
    function GetCED1902DCOffsetRange : single ;
    procedure GetCED1902List( Command : string ; List : TStrings ) ;
    function QueryCED1902( Request : string ) : string ;
    function OpenCED1902 : Boolean ;
    procedure CloseCED1902 ;

    procedure LoadDefaultAmplifierSettings( AmpNumber : Integer ) ;

    procedure GetChannelSettings(
              iChan : Integer ;
              var ChanName : String ;
              var ChanUnits : String ;
              var ChanCalFactor : Single ;
              var ChanScale : Single
              ) ;

    function GetTelegraphVoltage(
             ChannelNum : Integer
             ) : Single ;

    function GetClampMode( AmpNumber : Integer ) : Integer ;
    procedure SetClampMode( AmpNumber : Integer ; Value : Integer ) ;

    function ADCInUse : Boolean ;

    function GetCurrentChannel( AmpNumber : Integer ) : Integer ;
    function GetVoltageChannel( AmpNumber : Integer ) : Integer ;
    function AmpNumberOfChannel( iChan : Integer ) : Integer ;
    function IsPrimaryChannel(iChan : Integer ) : Boolean ;
    function IsSecondaryChannel(iChan : Integer ) : Boolean ;

    procedure ResetMultiClamp700 ;

    procedure LoadFromXMLFile( FileName : String ) ;
    procedure SaveToXMLFile( FileName : String ;
                             AppendData : Boolean ) ;

    Property AmplifierType[AmpNumber : Integer] : Integer read GetAmplifierType write SetAmplifierType ;
    Property ModelName[AmpNumber : Integer] : String read GetModelName ;
    Property GainTelegraphChannel[AmpNumber : Integer] : Integer read GetGainTelegraphChannel
                                            write SetGainTelegraphChannel ;
    Property ModeTelegraphChannel[AmpNumber : Integer] : Integer read GetModeTelegraphChannel
                                            write SetModeTelegraphChannel ;
    Property NeedsGainTelegraphChannel[AmpNumber : Integer] : Boolean read GetNeedsGainTelegraphChannel ;
    Property NeedsModeTelegraphChannel[AmpNumber : Integer] : Boolean read GetNeedsModeTelegraphChannel ;
    Property ModeSwitchedPrimaryChannel[AmpNumber : Integer] : Boolean read GetModeSwitchedPrimaryChannel ;

    Property VoltageCommandScaleFactor[AmpNumber : Integer] : Single read GetVoltageCommandScaleFactor
                                                                     write SetVoltageCommandScaleFactor ;
    Property VoltageCommandChannel[AmpNumber : Integer] : Integer read GetVoltageCommandChannel
                                                                  write SetVoltageCommandChannel ;
    Property CurrentCommandScaleFactor[AmpNumber : Integer] : Single read GetCurrentCommandScaleFactor
                                                                     write SetCurrentCommandScaleFactor ;
    Property CurrentCommandChannel[AmpNumber : Integer] : Integer read GetCurrentCommandChannel
                                                                  write SetCurrentCommandChannel ;
    Property CommandScaleFactor[AmpNumber : Integer] : Single read GetCommandScaleFactor ;
    Property GainTelegraphAvailable[AmpNumber : Integer] : Boolean read GetGainTelegraphAvailable ;
    Property ModeTelegraphAvailable[AmpNumber : Integer] : Boolean read GetModeTelegraphAvailable ;

    Property GainTelegraphName[AmpNumber : Integer] : String read GetGainTelegraphName ;
    Property ModeTelegraphName[AmpNumber : Integer] : String read GetModeTelegraphName ;

    Property ClampMode[AmpNumber : Integer] : Integer read GetClampMode write SetClampMode ;

    Property PrimaryOutputChannel[AmpNumber : Integer ] : Integer read GetPrimaryOutputChannel ;
    Property PrimaryOutputChannelName[AmpNumber : Integer; ClampMode : Integer] : String read GetPrimaryOutputChannelName ;
    Property SecondaryOutputChannel[AmpNumber : Integer] : Integer read GetSecondaryOutputChannel ;
    Property SecondaryOutputChannelName[AmpNumber : Integer; ClampMode : Integer] : String read GetSecondaryOutputChannelName ;
    Property CurrentChannel[AmpNumber : Integer] : Integer read GetCurrentChannel ;
    Property VoltageChannel[AmpNumber : Integer] : Integer read GetVoltageChannel ;
    Property PrimaryChannelScaleFactor[AmpNumber : Integer] : Single
                                                           read GetPrimaryChannelScaleFactor
                                                           write SetPrimaryChannelScaleFactor ;
    Property SecondaryChannelScaleFactor [AmpNumber : Integer] : Single
                                                           read GetSecondaryChannelScaleFactor
                                                           write SetSecondaryChannelScaleFactor ;
    Property PrimaryChannelScaleFactorX1Gain[AmpNumber : Integer; ClampMode : Integer] : Single
                                                           read GetPrimaryChannelScaleFactorX1Gain
                                                           write SetPrimaryChannelScaleFactorX1Gain ;
    Property SecondaryChannelScaleFactorX1Gain[AmpNumber : Integer; ClampMode : Integer] : Single
                                                           read GetSecondaryChannelScaleFactorX1Gain
                                                           write SetSecondaryChannelScaleFactorX1Gain ;

    Property PrimaryChannelUnits[AmpNumber : Integer; ClampMode : Integer] : String
                                                           read GetPrimaryChannelUnits
                                                           write SetPrimaryChannelUnits ;
    Property SecondaryChannelUnits[AmpNumber : Integer; ClampMode : Integer] : String
                                                           read GetSecondaryChannelUnits
                                                           write SetSecondaryChannelUnits ;

  end;

var
  Amplifier: TAmplifier;

implementation

uses Mdiform, maths, shared, VP500Unit,VP500Lib,TritonUnit,HekaUnit ;

{$R *.DFM}

var
  AXC_CheckAPIVersion : TAXC_CheckAPIVersion ;
  AXC_CreateHandle : TAXC_CreateHandle ;
  AXC_DestroyHandle : TAXC_DestroyHandle ;
  AXC_FindFirstDevice : TAXC_FindFirstDevice ;
  AXC_FindNextDevice : TAXC_FindNextDevice ;
  AXC_OpenDevice : TAXC_OpenDevice ;
  AXC_CloseDevice : TAXC_CloseDevice ;
  AXC_GetSerialNumber : TAXC_GetSerialNumber ;
  AXC_IsDeviceOpen : TAXC_IsDeviceOpen ;
  AXC_GetScaledOutputSignal : TAXC_GetScaledOutputSignal ;
  AXC_SetScaledOutputSignal : TAXC_SetScaledOutputSignal ;
  AXC_GetScaledOutputGain : TAXC_GetScaledOutputGain ;
  AXC_SetScaledOutputGain : TAXC_SetScaledOutputGain ;
  AXC_GetMode : TAXC_GetMode ;
  AXC_GetDeviceName : TAXC_GetDeviceName ;
  AXC_SetMode : TAXC_SetMode ;
  AXC_BuildErrorText : TAXC_BuildErrorText ;
  AXC_GetSignalScaleFactor : TAXC_GetSignalScaleFactor ;
  AXC_GetHeadstageType : TAXC_GetHeadstageType ;

procedure TAmplifier.AmplifierCreate(Sender: TObject);
// ---------------------------------------------
// Initialisations when amplifier module created
// ---------------------------------------------
var
    i : Integer ;
    SettingsDirectory : String ;
begin

     FAmpCurrentChannel := 0 ;
     FAmpVoltageChannel := 1 ;

     for i := 0 to MaxAmplifiers do begin
         FGainTelegraphChannel[i] := 7 ;
         FModeTelegraphChannel[i] := 6 ;
         FPrimaryOutputChannelName[i] := '' ;
         FPrimaryOutputChannelNameCC[i] := '' ;
         FPrimaryChannelUnits[i] := '' ;
         FPrimaryChannelUnitsCC[i] := '' ;
         FPrimaryChannelScaleFactor[i] := 1.0 ;
         FSecondaryOutputChannelName[i] := '' ;
         FSecondaryOutputChannelNameCC[i] := '' ;
         FSecondaryChannelUnits[i] := '' ;
         FSecondaryChannelUnitsCC[i] := '' ;
         FSecondaryChannelScaleFactor[i] := 1.0 ;
         FPrimaryChannelScaleFactorX1Gain[i] := 1.0 ;
         FPrimaryChannelScaleFactorX1GainCC[i] := 1.0 ;
         FSecondaryChannelScaleFactorX1Gain[i] := 1.0 ;
         FSecondaryChannelScaleFactorX1GainCC[i] := 1.0 ;
         FModeSwitchedPrimaryChannel[i] := False ;
         FAmpType[i] := amNone ;
         LastGain[i] := 1.0 ;
         LastMode[i] := VClampMode ;
         end ;

     // Default CED 1902 settings
     CED1902.Input := 1 ;
     CED1902.Gain := 1 ;
     CED1902.GainValue := 1. ;
     CED1902.LPFilter := 0 ;
     CED1902.HPFilter := 0 ;
     CED1902.ACCoupled := 0 ;
     CED1902.NotchFilter := 0 ;
     CED1902.ComPort := 1 ;
     CEd1902.ComHandle := -1 ;
     CED1902.DCOffset := 0 ;
     CED1902.AmplifierSet := False ;

     // Hook main window message handler
     Application.HookMainWindow(AppHookFunc);

     // No Multi-Clamp connection
     MCConnectionOpen := False ;
     // Clear Multi-Clamp channel list
     for i := 0 to High(MCChannels) do MCChannels[i] := 0 ;

     // Axoclamp 900A
     Axoclamp900ALibPath := 'C:\Program Files\Molecular Devices\Axoclamp 900A Commander\' ;
     Axoclamp900ALibLoaded := False ;
     Axoclamp900AOpen := False ;
     Axoclamp900ALibHnd := -1 ;
     Axoclamp900AHIDHnd := -1 ;
     Axoclamp900AHnd := -1 ;

     // Load settings
     SettingsDirectory := GetSpecialFolder(CSIDL_COMMON_DOCUMENTS) + '\WinWCP\';
     if not SysUtils.DirectoryExists(SettingsDirectory) then SysUtils.ForceDirectories(SettingsDirectory) ;
     SettingsFileName := SettingsDirectory + 'amplifier settings.xml' ;
     if FileExists( SettingsFileName ) then LoadFromXMLFile( SettingsFileName ) ;

     end;


procedure TAmplifier.GetList( List : TStrings ) ;
// ---------------------------------
// Get list of supported amplifiers
// ---------------------------------
begin

     List.AddObject('None',Tobject(amNone)) ;
     List.AddObject('Manual gain entry',TObject(amManual)) ;

     List.AddObject('Axopatch 1D',TObject(amAxopatch1d)) ;
     List.AddObject('Axopatch 200',TObject(amAxopatch200)) ;
     List.AddObject('Axon MultiClamp 700A',TObject(amMultiClamp700A)) ;
     List.AddObject('Axon MultiClamp 700B',TObject(amMultiClamp700B)) ;
     List.AddObject('Axon Axoclamp 2 HS1',TObject(amAxoclamp2HS1)) ;
     List.AddObject('Axon Axoclamp 2 HS10',TObject(amAxoclamp2HS10)) ;
     List.AddObject('Axon Axoclamp 2 HS0.1',TObject(amAxoclamp2HS01)) ;

     List.AddObject('Axon Axoclamp 900A',TObject(amAxoClamp900A)) ;

     List.AddObject('CED 1902',TObject(amCED1902)) ;
     List.AddObject('WPC-100',TObject(amWPC100)) ;

     List.AddObject('Biologic VP500',TObject(amVP500)) ;
     List.AddObject('Biologic RK400',TObject(amRK400)) ;

     List.AddObject('Cairn Optopatch',TObject(amOptopatch)) ;
     List.AddObject('Heka EPC-8',TObject(amEPC8)) ;
     List.AddObject('Heka EPC-800',TObject(amHekaEPC800)) ;
     List.AddObject('Heka EPC-7',TObject(amEPC7)) ;
     List.AddObject('Heka EPC-9/10',TObject(amHekaEPC9)) ;

     List.AddObject('NPI Turbo Tec-03X',TObject(amTurboTEC03)) ;
     List.AddObject('A-M Systems 2400',TObject(amAMS2400)) ;

     List.AddObject('NPI SEC 05-LX',TObject(amSEC05LX)) ;
     List.AddObject('NPI Turbo Tec-05',TObject(amTurboTec05)) ;
     List.AddObject('NPI Turbo Tec-10C',TObject(amTurboTEC10C)) ;
     List.AddObject('NPI Turbo Tec-10CX',TObject(amTurboTec10CX)) ;
     List.AddObject('NPI Turbo Tec-20',TObject(amTurboTec20)) ;
     List.AddObject('NPI Turbo Tec-30',TObject(amTurboTec30)) ;
     List.AddObject('NPI ELC03SX',TObject(amNPIELC03SX)) ;

     List.AddObject('Dagan TEV-200',TObject(amDaganTEV200A)) ;
     List.AddObject('Dagan PC-ONE-10 (10M)',TObject(amDaganPCOne10M)) ;
     List.AddObject('Dagan PC-ONE-20 (100M)',TObject(amDaganPCOne100M)) ;
     List.AddObject('Dagan PC-ONE-30 (1G)',TObject(amDaganPCOne1G)) ;
     List.AddObject('Dagan PC-ONE-40 (10G)',TObject(amDaganPCOne10G)) ;
     List.AddObject('Dagan 3900A (H/S 10nA)',TObject(amDagan3900A10nA)) ;
     List.AddObject('Dagan 3900A (H/S 100nA)',TObject(amDagan3900A100nA)) ;
     List.AddObject('Dagan CA-1B',TObject(amDaganCA1B)) ;
     List.AddObject('Dagan BVC-700A',TObject(amDaganBVC700A)) ;

     List.AddObject('Warner PC501A',TObject(amWarnerPC501A)) ;
     List.AddObject('Warner PC505B',TObject(amWarnerPC505B)) ;
     List.AddObject('Warner OC725C',TObject(amWarnerOC725C)) ;

     List.AddObject('Tecella Triton/Pico',TObject(amTriton)) ;

     end ;



procedure TAmplifier.LoadDefaultAmplifierSettings(
          AmpNumber : Integer ) ;
// ----------------------
// Load default settings for amplifier #AmplNumber
// ----------------------
const
    DefGainTelegraphChannel : Array[0..MaxAmplifiers] of Integer = (7,5,15,13,0) ;
    DefModeTelegraphChannel : Array[0..MaxAmplifiers] of Integer = (6,4,14,12,0) ;
begin

    if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then Exit ;

    case FAmpType[AmpNumber] of

        amNone : begin

            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Prim.' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Prim.' ;
            FPrimaryChannelUnits[AmpNumber] := 'mV' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.001 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Sec.' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Sec.' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.001 ;

            FVoltageCommandScaleFactor[AmpNumber] := 1.0 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1.0 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

        amManual : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Im' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Im' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.001 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Vm' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Vm' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.001 ;

            FVoltageCommandScaleFactor[AmpNumber] := 1.0 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1.0 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := False ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amCED1902 : begin

            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Amp Out' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Amp Out' ;
            FPrimaryChannelUnits[AmpNumber] := 'mV' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.001 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.001 ;

            FVoltageCommandScaleFactor[AmpNumber] := 1.0 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1.0 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amAxopatch1d : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Scaled Output' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Scaled Output' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0005 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.0005 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.0005 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := '10 Vm' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := '10 Vm' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-8 ;  // 100pA/10mV B=1
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;

            end ;

          amAxopatch200 : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Scaled Output' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Scaled Output' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0005 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.0005 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.0005 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := '10 Vm' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'I Output' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'pA' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 2E-9 ;  // 2/Beta nA/V Beta=1
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] := True ;
            FModeSwitchedPrimaryChannel[AmpNumber] := True ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;


          amWPC100 : begin

            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Current Monitor' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Current Monitor' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0005 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.0005 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.0005 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := '10 Vm' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := '10 Vm' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.01 ;  // X0.1 scaling)
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-10 ; // 1pA/mV(X0.1 scaling)
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;

            end ;

          amVP500 : begin

            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Im' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Im' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0005 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.0005 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.0005 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Vm' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Vm' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1.0 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;

            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;

            end ;

          amRK400 : begin

            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'I Out' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'I Out' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0001 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.0001 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.0001 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := '10 Vm Out' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := '10 Vm Out' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-9 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;


            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;

            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amOptopatch : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Gain Out' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Gain Out' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0001 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] :=  0.001 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.0001 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Command X10 Out' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Command X10 Out' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'pA' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-10 ;  // 100pA/V
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] := True ;
            FModeSwitchedPrimaryChannel[AmpNumber] := True ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;

            end ;

          amMultiClamp700A : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := format('Ch.%d Scaled Output',[AmpNumber+1]) ;
            FPrimaryOutputChannelNameCC[AmpNumber] := format('Ch.%d Scaled Output',[AmpNumber+1]) ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.001 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := format('Ch.%d Raw Output',[AmpNumber+1]) ;
            FSecondaryOutputChannelNameCC[AmpNumber] := format('Ch.%d Raw Output',[AmpNumber+1]) ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.001 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 4E-10 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amMultiClamp700B : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := format('Ch.%d Primary Output',[AmpNumber+1]) ;
            FPrimaryOutputChannelNameCC[AmpNumber] := format('Ch.%d Primary Output',[AmpNumber+1]) ;
            FPrimaryChannelUnits[AmpNumber] := 'mV' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.001 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := format('Ch.%d Secondary Output',[AmpNumber+1]) ;
            FSecondaryOutputChannelNameCC[AmpNumber] := format('Ch.%d Secondary Output',[AmpNumber+1]) ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.001 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.001 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 4E-10 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amEPC8  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := ' Current Monitor ' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := ' Current Monitor ' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.00001 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.00001 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.00001 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := ' Vcomm Monitor ' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := ' Vcomm Monitor ' ;
            FSecondaryChannelUnits[AmpNumber] := 'mV' ;
            FSecondaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;
            //FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-10 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amTurboTec03,
          amTurboTec05,
          amTurboTec10C,
          amTurboTec10CX,
          amTurboTec20,
          amTurboTec30  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Current Output' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Current Output' ;
            FPrimaryChannelUnits[AmpNumber] := 'uA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'uA' ;

            case FAmpType[AmpNumber] of
               amTurboTEC30 : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
               amTurboTEC20 : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 1.0 ;
               else FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.1 ;
               end ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
            FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Potential Output (X10)' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Potential Output (X10)' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-6 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := True  ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amAMS2400  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Mode Output' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Mode Output' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'mV' ;

            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.00001 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.00001 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.00001 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Fixed 10 Vm' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Fixed Im' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'pA' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 1E-4 ; // Assumes 100MOhm feedback res.
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 2E-9 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] := True ;
            FModeSwitchedPrimaryChannel[AmpNumber] := True ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amSEC05LX  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Current Output' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Current Output' ;
            FPrimaryChannelUnits[AmpNumber] := 'nA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'nA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.1 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.1 ;
            FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Potential Output (X10Vm)' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Potential Output (X10Vm)' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-9 ; // 1nA/V input
            FCurrentCommandChannel[AmpNumber] := Min(AmpNumber+1,MaxAmplifiers-1) ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amNPIELC03SX  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Current Output' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Current Output' ;
            FPrimaryChannelUnits[AmpNumber] := 'nA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'nA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.1 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.1 ;
            FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Potential Output (mV)' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Potential Output (mV)' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-9 ; // 1nA/V input
            FCurrentCommandChannel[AmpNumber] := Min(AmpNumber+1,MaxAmplifiers-1) ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] := True ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amDaganPCOne10M,
          amDaganPCOne100M,
          amDaganPCOne1G,
          amDaganPCOne10G  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Im' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Im' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            case FAmpType[AmpNumber] of
               amDaganPCOne10M : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.00001 ;
               amDaganPCOne100M : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0001 ;
               amDaganPCOne1G : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
               amDaganPCOne10G : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
               else FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0001 ;
               end ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
            FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'X10 Vm' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'X10 Vm' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 2E-10 ; // 0.2nA/V (1nA/V alt.)
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amDagan3900A10nA,amDagan3900A100nA  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Im' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Im' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            case FAmpType[AmpNumber] of
               amDagan3900A10nA : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
               amDagan3900A100nA : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0001 ;
               end ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Vm X10' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Vm X10' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            case FAmpType[AmpNumber] of
               amDagan3900A10nA : FCurrentCommandScaleFactor[AmpNumber] := 2E-10 ;
               amDagan3900A100nA : FCurrentCommandScaleFactor[AmpNumber] := 2E-9 ;
               end ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amWarnerPC501A  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Im' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Im' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0001 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.0001 ;
            FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Vm X10' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Vm X10' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-10 ; // 0.1nA/V (0.1 div factor)
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amWarnerPC505B  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Im' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Im' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.00005 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.00005 ;
            FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Vm X10' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Vm X10' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-10 ;// 0.1nA/V (0.1 div factor)
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
              end ;

          amWarnerOC725C  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'I Monitor' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'I Monitor' ;
            FPrimaryChannelUnits[AmpNumber] := 'uA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'uA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Vm X10' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Vm X10' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1.0 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;

            end ;

          amAxoclamp2HS1,
          amAxoclamp2HS10,
          amAxoclamp2HS01  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Im' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Im' ;
            FPrimaryChannelUnits[AmpNumber] := 'nA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'nA' ;
            case FAmpType[AmpNumber] of
               amAxoclamp2HS01 : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.001 ;
               amAxoclamp2HS1 : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
               amAxoclamp2HS10 : FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.1 ;
               end ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
            FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := '10 Vm' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := '10 Vm' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;

            FCurrentCommandChannel[AmpNumber] := Min(AmpNumber+1,MaxAmplifiers-1) ;
            case FAmpType[AmpNumber] of
               amAxoclamp2HS01  :FCurrentCommandScaleFactor[FCurrentCommandChannel[AmpNumber] ] := 1E-9 ;
               amAxoclamp2HS1 : FCurrentCommandScaleFactor[FCurrentCommandChannel[AmpNumber] ] := 1E-8 ;
               amAxoclamp2HS10 : FCurrentCommandScaleFactor[FCurrentCommandChannel[AmpNumber] ] := 1E-7 ;
               end ;


            FGainTelegraphAvailable[AmpNumber] := False ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amDaganTEV200A  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Im' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Im' ;
            FPrimaryChannelUnits[AmpNumber] := 'uA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'uA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.05 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.05 ;
            FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Vm X10' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Vm X10' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1.0 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

          amAxoclamp900A  : begin

            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Ch.1 Scaled Output' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Ch.1 Scaled Output' ;
            FPrimaryChannelUnits[AmpNumber] := 'nA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'nA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Ch.1 Scaled Output' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Ch.1 Scaled Output' ;
            FSecondaryCHannelUnits[AmpNumber] := 'mV' ;
            FSecondaryCHannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-8 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := False  ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
              end ;

          amHekaEPC800  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Current Monitor' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Current Monitor' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 5E-6 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 5E-6 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 5E-6 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := ' Voltage Monitor ' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := ' Voltage Monitor ' ;
            FSecondaryChannelUnits[AmpNumber] := 'mV' ;
            FSecondaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-10 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  True ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

        amTriton : begin
            FPrimaryOutputChannelName[AmpNumber] := 'Im(VC), Vm(CC)' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Im(VC), Vm(CC)' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FPrimaryOutputChannel[AmpNumber] := 1 ;
            FSecondaryOutputChannel[AmpNumber] := 0 ;
            FSecondaryOutputChannelName[AmpNumber] := 'Stimulus' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := 'Stimulus' ;
            FVoltageCommandScaleFactor[AmpNumber] := 1.0 ;
            FVoltageCommandChannel[AmpNumber] := 0 ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-9 ;
            FCurrentCommandChannel[AmpNumber] := 0 ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

         amEPC7  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := ' Current Monitor ' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := ' Current Monitor ' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.0005 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.0005 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.0005 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := ' Vcomm Monitor ' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := ' Vcomm Monitor ' ;
            FSecondaryChannelUnits[AmpNumber] := 'mV' ;
            FSecondaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ; // 100mV/V Stim scale=0.1
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-10 ; // 0.1pA/mV Stim scale=0.1
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := False ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
              end ;

         amDaganCA1B  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := ' Im Processed Out ' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := ' Im Processed Out ' ;
            FPrimaryChannelUnits[AmpNumber] := 'nA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'nA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.05 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.05 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.05 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := ' 10 V1 ' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := ' 10 V1 ' ;
            FSecondaryChannelUnits[AmpNumber] := 'mV' ;
            FSecondaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ; // 100mV/V Stim scale=0.1
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-10 ; // 0.1pA/mV Stim scale=0.1
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := True ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  True ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
              end ;

          amHekaEPC9  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := 'Current Monitor' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := 'Current Monitor' ;
            FPrimaryChannelUnits[AmpNumber] := 'pA' ;
            FPrimaryChannelUnitsCC[AmpNumber] := 'pA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 5E-6 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 5E-6 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 5E-6 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := ' Voltage Monitor ' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := ' Voltage Monitor ' ;
            FSecondaryChannelUnits[AmpNumber] := 'mV' ;
            FSecondaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.1 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1E-10 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := True ;
            FModeTelegraphAvailable[AmpNumber] := True ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

         amDaganBVC700A  : begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FPrimaryOutputChannelName[AmpNumber] := ' I Monitor ' ;
            FPrimaryOutputChannelNameCC[AmpNumber] := ' I Monitor ' ;
            FPrimaryChannelUnits[AmpNumber] := 'nA' ;
            FPrimaryChannelUnitsCC[AmpNumber] :='nA' ;
            FPrimaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FPrimaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FSecondaryOutputChannelName[AmpNumber] := ' 10 Vm ' ;
            FSecondaryOutputChannelNameCC[AmpNumber] := ' 10 Vm ' ;
            FSecondaryChannelUnits[AmpNumber] := 'mV' ;
            FSecondaryChannelUnitsCC[AmpNumber] := 'mV' ;
            FSecondaryChannelScaleFactorX1Gain[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := 0.01 ;
            FSecondaryChannelScaleFactor[AmpNumber] := 0.01 ;

            FVoltageCommandScaleFactor[AmpNumber] := 0.02 ; // 50mV/V
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 20E-9 ; // 20nA/V
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;

            FGainTelegraphAvailable[AmpNumber] := False ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] :=  False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;

        else begin
            FPrimaryOutputChannel[AmpNumber] := 2*AmpNumber ;
            FSecondaryOutputChannel[AmpNumber] := 2*AmpNumber + 1 ;
            FVoltageCommandScaleFactor[AmpNumber] := 1.0 ;
            FVoltageCommandChannel[AmpNumber] := AmpNumber ;
            FCurrentCommandScaleFactor[AmpNumber] := 1.0 ;
            FCurrentCommandChannel[AmpNumber] := AmpNumber ;
            FGainTelegraphAvailable[AmpNumber] := False ;
            FModeTelegraphAvailable[AmpNumber] := False ;
            FNeedsGainTelegraphChannel[AmpNumber] := False ;
            FNeedsModeTelegraphChannel[AmpNumber] := False ;
            FModeSwitchedPrimaryChannel[AmpNumber] := False ;
            FGainTelegraphChannel[AmpNumber] := DefGainTelegraphChannel[AmpNumber] ;
            FModeTelegraphChannel[AmpNumber] := DefModeTelegraphChannel[AmpNumber] ;
            end ;
        end ;

    end ;


function TAmplifier.GetAmplifierType(AmpNumber : Integer ) : Integer ;
// ------------------------
// Return type of amplifier
// ------------------------
begin
     if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then Result := FAmpType[AmpNumber]
                                                         else Result := amNone ;
     end ;


function  TAmplifier.GetModelName(
          AmpNumber : Integer ) : String  ;
// -----------------------
// Get amplifier name
// -----------------------
var
    List : TStringList ;
begin

     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := 'Unknown' ;
        Exit ;
        end ;

     List := TStringList.Create ;
     GetList(List) ;
     AmpNumber := Min(Max(0,AmpNumber),MaxAmplifiers-1) ;
     Result :=  List[List.IndexofObject(TObject(FAmpType[AmpNumber]))] ;
     List.Free ;
     end ;


function TAmplifier.GetGain(
         AmpNumber : Integer
         ) : single ;
// ---------------------------------------
// Get current gain setting from amplifier
// ---------------------------------------
begin

     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := 1.0 ;
        Exit ;
        end ;

     case GetAmplifierType(AmpNumber) of
          amNone : Result := 1.0 ;
          amCED1902 : Result := CED1902.GainValue ;
          amAxopatch1d : Result := GetAxopatch1dGain(AmpNumber) ;
          amAxopatch200 : Result := GetAxopatch200Gain(AmpNumber) ;
          amWPC100 : Result :=  GetWPC100Gain(AmpNumber) ;
          amVP500 : Result := GetVP500Gain(AmpNumber) ;
          amRK400 : Result := GetRK400Gain(AmpNumber) ;
          amOptopatch : Result := GetOptopatchGain(AmpNumber) ;
          amMultiClamp700A : Result := GetMultiClampGain(AmpNumber)  ;
          amMultiClamp700B : Result := GetMultiClampGain(AmpNumber)  ;
          amEPC8 : Result := GetEPC8Gain(AmpNumber) ;
          amTurboTec03,
          amTurboTec05,
          amTurboTec10C,
          amTurboTec10CX,
          amTurboTec20,
          amTurboTec30 : Result := GetTurboTecGain(AmpNumber) ;
          amAMS2400 : Result := GetAMS2400Gain(AmpNumber) ;
          amSEC05LX : Result := GetSEC05LXGain(AmpNumber) ;
          amDaganPCOne10M,
          amDaganPCOne100M,
          amDaganPCOne1G,
          amDaganPCOne10G : Result :=  GetDaganPCOneGain(AmpNumber) ;
          amDagan3900A10nA,amDagan3900A100nA : Result := GetDagan3900AGain(AmpNumber) ;
          amWarnerPC501A : Result := GetWarnerPC501AGain(AmpNumber) ;
          amWarnerPC505B : Result := GetWarnerPC505BGain(AmpNumber) ;
          amWarnerOC725C : Result := GetWarnerOC725CGain(AmpNumber) ;
          amAxoclamp2HS1,
          amAxoclamp2HS10,
          amAxoclamp2HS01 : Result := GetAxoclamp2Gain(AmpNumber) ;
          amDaganTEV200A : Result := GetDaganTEV200AGain(AmpNumber) ;
          amTriton : Result := GetTritonGain(AmpNumber) ;
          amAxoclamp900A : Result := GetAxoclamp900AGain(AmpNumber) ;
          amHekaEPC800 : Result := GetHekaEPC800Gain(AmpNumber) ;
          amEPC7 : Result := 1.0 ;
          amDaganCA1B : Result := GetDaganCA1BGain(AmpNumber) ;
          amHekaEPC9 : Result := GetHekaEPC9Gain(AmpNumber) ;
          amNPIELC03SX : Result := GetNPIELC03SXGain(AmpNumber,FGainTelegraphChannel[AmpNumber]) ;
          amDaganBVC700A : Result := 1.0 ;
          else Result := 1.0 ;
          end ;
     end ;


function TAmplifier.GetNeedsGainTelegraphChannel(
          AmpNumber : Integer )
           : Boolean ;
// ------------------------------------------------------------------
// Returns TRUE if amplifier needs an analogue gain telegraph channel
// ------------------------------------------------------------------
begin

     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := False ;
        Exit ;
        end ;

     Result := FNeedsGainTelegraphChannel[AmpNumber] ;

     end ;


function TAmplifier.GetNeedsModeTelegraphChannel(
          AmpNumber : Integer
          ) : Boolean ;
// ------------------------------------------------------------------
// Returns TRUE if amplifier needs a mode telegraph channel
// ------------------------------------------------------------------
begin

     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := False ;
        Exit ;
        end ;

     Result := FNeedsModeTelegraphChannel[AmpNumber] ;
     end ;


function TAmplifier.GetVoltageCommandScaleFactor(
         AOChan : Integer
         ) : Single ;
// ------------------------------------------------------------------
// Returns patch clamp command voltage divide factor for amplifier
// ------------------------------------------------------------------
begin

     if (AOChan < 0) or (AOChan >= MaxAmplifiers) then begin
        Result := 1.0 ;
        Exit ;
        end ;

     Result := FVoltageCommandScaleFactor[AOChan] ;
     if Result = 0.0 then Result := 1.0 ;
     end ;

procedure TAmplifier.SetVoltageCommandChannel(
         AOChan : Integer ;
         Value : Integer
         ) ;
// ------------------------------------------------------
// Set patch clamp command voltage analog output channel
// ------------------------------------------------------
begin
     if (AOChan < 0) or (AOChan >= MaxAmplifiers) then Exit ;

     FVoltageCommandChannel[AOChan] := Value ;
     end ;


procedure TAmplifier.SetVoltageCommandScaleFactor(
         AOChan : Integer ;
         Value : Single
         ) ;
// ------------------------------------------------------------------
// Set patch clamp command voltage scale factor for amplifier
// ------------------------------------------------------------------
begin
     if (AOChan < 0) or (AOChan >= MaxAmplifiers) then Exit ;

     FVoltageCommandScaleFactor[AOChan] := Value ;
     end ;

procedure TAmplifier.SetCurrentCommandChannel(
         AOChan : Integer ;
         Value : Integer
         ) ;
// ------------------------------------------------------
// Set patch clamp command current analog output channel
// ------------------------------------------------------
begin
     if (AOChan < 0) or (AOChan >= MaxAmplifiers) then Exit ;

     FCurrentCommandChannel[AOChan] := Value ;
     end ;


function TAmplifier.GetCurrentCommandScaleFactor(
         AOChan : Integer
         ) : Single ;
// ------------------------------------------------------------------
// Returns patch clamp command current divide factor for amplifier
// ------------------------------------------------------------------
begin

     if (AOChan < 0) or (AOChan >= MaxAmplifiers) then begin
        Result := 1.0 ;
        Exit ;
        end ;

     Result := FCurrentCommandScaleFactor[AOChan] ;
     if Result = 0.0 then Result := 1.0 ;
     end ;


procedure TAmplifier.SetCurrentCommandScaleFactor(
         AOChan : Integer ;
         Value : Single
         ) ;
// ------------------------------------------------------------------
// Set patch clamp command current scale factor for amplifier
// ------------------------------------------------------------------
begin
     if (AOChan < 0) or (AOChan >= MaxAmplifiers) then Exit ;
     FCurrentCommandScaleFactor[AOChan] := Value ;
     end ;


function TAmplifier.GetCommandScaleFactor(
         AmpNumber : Integer
         ) : Single ;
// ------------------------------------------------------------------
// Returns patch clamp divide factor for current amplifier mode
// ------------------------------------------------------------------
begin

     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := 1.0 ;
        Exit ;
        end ;

     if GetClampMode(AmpNumber) = amVoltageClamp then begin
        Result := GetVoltageCommandScaleFactor(FVoltageCommandChannel[AmpNumber]) ;
        end
        else begin
        Result := GetCurrentCommandScaleFactor(FCurrentCommandChannel[AmpNumber]) ;
        end ;
     end ;


function TAmplifier.GetGainTelegraphAvailable(
         AmpNumber : Integer ) : Boolean ;
// ------------------------------------------------------------------
// Returns TRUE if amplifier needs an analogue gain telegraph channel
// ------------------------------------------------------------------
begin

     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := False ;
        Exit ;
        end ;

     Result := FGainTelegraphAvailable[AmpNumber] ;

     // If telegraph channel required but not assigned return not available

     if FNeedsGainTelegraphChannel[AmpNumber] then begin
        if (FGainTelegraphChannel[AmpNumber] < 0) or
           (FGainTelegraphChannel[AmpNumber] >= Main.SESLabIO.ADCMaxChannels) then Result := False ;
        end ;

     end ;


function TAmplifier.GetGainTelegraphName(
         AmpNumber : Integer ) : String ;
// ----------------------------------------------
// Returns name of gain telegraph channel on amplifier
// ----------------------------------------------
var
    AmplifierType : Integer ;
begin

     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := '' ;
        Exit ;
        end ;
     AmplifierType := GetAmplifierType(AmpNumber) ;
     case AmplifierType of
        amDaganCA1B : Result := 'Im Gain' ;
        amNPIELC03SX : Result := 'Current Sensitivity' ;
        else Result := 'Gain' ;
        end ;
     end ;


function TAmplifier.GetModeTelegraphName(
         AmpNumber : Integer ) : String ;
// ----------------------------------------------
// Returns name of mode telegraph channel on amplifier
// ----------------------------------------------
var
    AmplifierType : Integer ;
begin

     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := '' ;
        Exit ;
        end ;

     AmplifierType := GetAmplifierType(AmpNumber) ;
     case AmplifierType of
        amDaganCA1B : Result := 'Proc Gain' ;
        amNPIELC03SX : Result := 'Potential Sensitivity' ;
        else Result := 'Voltage/Current Clamp Mode' ;
        end ;
     end ;


function TAmplifier.GetModeTelegraphAvailable(
         AmpNumber : Integer ) : Boolean ;
// -------------------------------------------------------
// Returns TRUE if amplifier has a mode telegraph channel
// -------------------------------------------------------
begin

     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := False ;
        Exit ;
        end ;

     Result := FModeTelegraphAvailable[AmpNumber] ;

     // If telegraph channel required but not assigned return not available

     if FNeedsModeTelegraphChannel[AmpNumber] then begin
        if (FModeTelegraphChannel[AmpNumber] < 0) or
           (FModeTelegraphChannel[AmpNumber] >= Main.SESLabIO.ADCMaxChannels) then Result := False ;
        end ;

     end ;

function TAmplifier.GetModeSwitchedPrimaryChannel(
         AmpNumber : Integer ) : Boolean ;
// ------------------------------------------------------------------------------
// Returns TRUE if amplifier switches primary channel signal on VC/CC mode change
// ------------------------------------------------------------------------------
begin

     if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
        Result := FModeSwitchedPrimaryChannel[AmpNumber] ;
        end
     Else Result := False ;

     end ;


procedure TAmplifier.GetChannelSettings(
          iChan : Integer ;
          var ChanName : String ;         // Returns name of channel
          var ChanUnits : String ;        // Returns units of channel
          var ChanCalFactor : Single ;    // Returns V/Units calibration factor
          var ChanScale : Single          // Returns channel gain factor
          ) ;
// ------------------------------------------
// Get current channel settings for amplifier
// ------------------------------------------
var
   AmplifierType : Integer ;
begin


     AmplifierType := GetAmplifierType(AmpNumberOfChannel(iChan)) ;

     case AmplifierType of

          amNone : GetNoneChannelSettings( iChan,
                                           ChanName,
                                           ChanUnits,
                                           ChanCalFactor,
                                           ChanScale ) ;

          amManual : GetManualChannelSettings( iChan,
                                               ChanName,
                                               ChanUnits,
                                               ChanCalFactor,
                                               ChanScale ) ;

          amCED1902 : GetCED1902ChannelSettings( iChan,
                                                 ChanName,
                                                 ChanUnits,
                                                 ChanCalFactor,
                                                 ChanScale ) ;

          amAxoPatch1D : GetAxoPatch1DChannelSettings( iChan,
                                                       ChanName,
                                                       ChanUnits,
                                                       ChanCalFactor,
                                                       ChanScale ) ;

          amAxoPatch200 : GetAxoPatch200ChannelSettings( iChan,
                                                         ChanName,
                                                         ChanUnits,
                                                         ChanCalFactor,
                                                         ChanScale ) ;

          amWPC100 : GetWPC100ChannelSettings( iChan,
                                               ChanName,
                                               ChanUnits,
                                               ChanCalFactor,
                                               ChanScale ) ;

          amRK400 : GetRK400ChannelSettings( iChan,
                                             ChanName,
                                             ChanUnits,
                                             ChanCalFactor,
                                             ChanScale ) ;

          amVP500 : GetVP500ChannelSettings( iChan,
                                             ChanName,
                                             ChanUnits,
                                             ChanCalFactor,
                                             ChanScale ) ;

          amOptoPatch : GetOptoPatchChannelSettings( iChan,
                                                     ChanName,
                                                     ChanUnits,
                                                     ChanCalFactor,
                                                     ChanScale ) ;

          amMultiClamp700A : GetMultiClampChannelSettings( iChan,
                                                           ChanName,
                                                           ChanUnits,
                                                           ChanCalFactor,
                                                           ChanScale ) ;

          amMultiClamp700B :  GetMultiClampChannelSettings( iChan,
                                                            ChanName,
                                                            ChanUnits,
                                                            ChanCalFactor,
                                                            ChanScale ) ;
          amEPC8 :  GetEPC8ChannelSettings( iChan,
                                            ChanName,
                                            ChanUnits,
                                            ChanCalFactor,
                                            ChanScale ) ;

          amTurboTec03,
          amTurboTec05,
          amTurboTec10C,
          amTurboTec10CX,
          amTurboTec20,
          amTurboTec30  :  GetTurboTecChannelSettings( iChan,
                                                        ChanName,
                                                        ChanUnits,
                                                        ChanCalFactor,
                                                        ChanScale ) ;

          amAMS2400 :  GetAMS2400ChannelSettings( iChan,
                                                  ChanName,
                                                  ChanUnits,
                                                  ChanCalFactor,
                                                  ChanScale ) ;

          amSEC05LX :  GetSEC05LXChannelSettings( iChan,
                                                  ChanName,
                                                  ChanUnits,
                                                  ChanCalFactor,
                                                  ChanScale ) ;

          amDaganPCOne10M,
          amDaganPCOne100M,
          amDaganPCOne1G,
          amDaganPCOne10G : GetDaganPCOneChannelSettings( iChan,
                                                       ChanName,
                                                       ChanUnits,
                                                       ChanCalFactor,
                                                       ChanScale ) ;

          amDagan3900A10nA,
          amDagan3900A100nA : GetDagan3900AChannelSettings( iChan,
                                                       ChanName,
                                                       ChanUnits,
                                                       ChanCalFactor,
                                                       ChanScale ) ;

          amWarnerPC501A :  GetWarnerPC501AChannelSettings( iChan,
                                                  ChanName,
                                                  ChanUnits,
                                                  ChanCalFactor,
                                                  ChanScale ) ;

          amWarnerPC505B :  GetWarnerPC505BChannelSettings( iChan,
                                                  ChanName,
                                                  ChanUnits,
                                                  ChanCalFactor,
                                                  ChanScale ) ;

          amWarnerOC725C :  GetWarnerOC725CChannelSettings( iChan,
                                                  ChanName,
                                                  ChanUnits,
                                                  ChanCalFactor,
                                                  ChanScale ) ;

          amAxoclamp2HS1,
          amAxoclamp2HS10,
          amAxoclamp2HS01 :  GetAxoclamp2ChannelSettings( iChan,
                                                  ChanName,
                                                  ChanUnits,
                                                  ChanCalFactor,
                                                  ChanScale ) ;

          amDaganTEV200A :  GetDaganTEV200AChannelSettings( iChan,
                                                  ChanName,
                                                  ChanUnits,
                                                  ChanCalFactor,
                                                  ChanScale ) ;

          amTriton :  GetTritonChannelSettings( iChan,
                                                ChanName,
                                                ChanUnits,
                                                ChanCalFactor,
                                                ChanScale ) ;

          amAxoclamp900A :  GetAxoclamp900AChannelSettings( iChan,
                                                ChanName,
                                                ChanUnits,
                                                ChanCalFactor,
                                                ChanScale ) ;

          amHekaEPC800 :  GetHekaEPC800ChannelSettings( iChan,
                                                ChanName,
                                                ChanUnits,
                                                ChanCalFactor,
                                                ChanScale ) ;

          amEPC7 :  GetEPC7ChannelSettings( iChan,
                                            ChanName,
                                            ChanUnits,
                                            ChanCalFactor,
                                            ChanScale ) ;

          amDaganCA1B :  GetDaganCA1BChannelSettings( iChan,
                                            ChanName,
                                            ChanUnits,
                                            ChanCalFactor,
                                            ChanScale ) ;

          amHekaEPC9 :  GetHekaEPC9ChannelSettings( iChan,
                                                ChanName,
                                                ChanUnits,
                                                ChanCalFactor,
                                                ChanScale ) ;

          amNPIELC03SX :  GetNPIELC03SXChannelSettings( iChan,
                                                      ChanName,
                                                      ChanUnits,
                                                      ChanCalFactor,
                                                      ChanScale ) ;

          amDaganBVC700A :  GetDaganBVC700AChannelSettings( iChan,
                                                            ChanName,
                                                            ChanUnits,
                                                            ChanCalFactor,
                                                            ChanScale ) ;

          end ;

    if ChanCalFactor = 0.0 then ChanCalFactor := 1.0 ;
    if ChanScale = 0.0 then ChanScale := 1.0 ;

    end ;


function TAmplifier.GetCurrentChannel(
         AmpNumber : Integer
         ) : Integer ;
// ------------------------------------------
// Get current channel for selected amplifier
// ------------------------------------------
var
    iChan : Integer ;
    ChanName,ChanUnits : String ;
    ChanCalFactor,ChanScale : Single ;
begin

     Result := 0 ;

     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := 0 ;
        Exit ;
        end ;

     iChan := GetPrimaryOutputChannel(AmpNumber) ;
     GetChannelSettings( iChan,ChanName,ChanUnits,ChanCalFactor,ChanScale ) ;
     if ANSIContainsText( ChanUnits, 'A' ) then Result := iChan ;

     iChan := GetSecondaryOutputChannel(AmpNumber) ;
     GetChannelSettings( iChan,ChanName,ChanUnits,ChanCalFactor,ChanScale ) ;
     if ANSIContainsText( ChanUnits, 'A' ) then Result := iChan ;

     end ;


function TAmplifier.GetVoltageChannel(
         AmpNumber : Integer
         ) : Integer ;
// ------------------------------------------
// Get current channel for selected amplifier
// ------------------------------------------
var
    iChan : Integer ;
    ChanName,ChanUnits : String ;
    ChanCalFactor,ChanScale : Single ;
begin

     Result := 0 ;
     if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then begin
        Result := 0 ;
        Exit ;
        end ;

     iChan := GetPrimaryOutputChannel(AmpNumber) ;
     GetChannelSettings( iChan,ChanName,ChanUnits,ChanCalFactor,ChanScale ) ;
     if ANSIContainsText( ChanUnits, 'V' ) then Result := iChan ;

     iChan := GetSecondaryOutputChannel(AmpNumber) ;
     GetChannelSettings( iChan,ChanName,ChanUnits,ChanCalFactor,ChanScale ) ;
     if ANSIContainsText( ChanUnits, 'V' ) then Result := iChan ;

     end ;


function TAmplifier.AmpNumberOfChannel( iChan : Integer ) : Integer ;
begin

    case FAmpType[0] of
        amTriton : Result := 0 ;
        else Result := (iChan div 2) ;
        end ;
    //Result := Min(Max(Result,0),MaxAmplifiers-1) ;
    end ;


function TAmplifier.IsPrimaryChannel(iChan : Integer ) : Boolean ;
// ----------------------------------------------------------------------------
// Returns TRUE if analog input channel is attached to primary amplifier output
// ----------------------------------------------------------------------------
begin
    if FPrimaryOutputChannel[AmpNumberofChannel(iChan)] = iChan then Result := True
                                                                else Result := False ;
    end ;


function TAmplifier.IsSecondaryChannel(iChan : Integer ) : Boolean ;
// ----------------------------------------------------------------------------
// Returns TRUE if analog input channel is attached to secondary amplifier output
// ----------------------------------------------------------------------------
begin
    if FSecondaryOutputChannel[AmpNumberofChannel(iChan)] = iChan then Result := True
                                                            else Result := False ;
    end ;



function TAmplifier.GetClampMode( AmpNumber : Integer ) : Integer ;
// ----------------------------------------
// Get amplifier current/voltage clamp mode
// ----------------------------------------
begin
     case GetAmplifierType(AmpNumber)  of
          amNone : Result := LastMode[AmpNumber] ;
          amManual : Result := LastMode[AmpNumber] ;
          amCED1902 : Result := LastMode[AmpNumber] ;
          amAxopatch1d : Result := GetAxopatch1dMode(AmpNumber) ;
          amAxopatch200 : Result := GetAxopatch200Mode(AmpNumber) ;
          amWPC100 : Result := GetWPC100Mode(AmpNumber) ;
          amVP500 : Result := GetVP500Mode(AmpNumber) ;
          amRK400 : Result := GetRK400Mode(AmpNumber) ;
          amOptopatch : Result := GetOptopatchMode(AmpNumber) ;
          amMultiClamp700A : Result := GetMultiClampMode(AmpNumber) ;
          amMultiClamp700B : Result := GetMultiClampMode(AmpNumber) ;
          amEPC8 : Result := GetEPC8Mode(AmpNumber) ;
          amTurboTec03,
          amTurboTec05,
          amTurboTec10C,
          amTurboTec10CX,
          amTurboTec20,
          amTurboTec30  : Result := GetTurboTecMode(AmpNumber) ;
          amAMS2400 : Result := GetAMS2400Mode(AmpNumber) ;
          amSEC05LX : Result := GetSEC05LXMode(AmpNumber) ;
          amDaganPCOne10M,
          amDaganPCOne100M,
          amDaganPCOne1G,
          amDaganPCOne10G : Result := GetDaganPCOneMode(AmpNumber) ;
          amDagan3900A10nA,amDagan3900A100nA : Result := GetDagan3900AMode(AmpNumber) ;
          amWarnerPC501A : Result := GetWarnerPC501AMode(AmpNumber) ;
          amWarnerPC505B : Result := GetWarnerPC505BMode(AmpNumber) ;
          amWarnerOC725C : Result := GetWarnerOC725CMode(AmpNumber) ;
          amAxoclamp2HS1,
          amAxoclamp2HS10,
          amAxoclamp2HS01 : Result := GetAxoclamp2Mode(AmpNumber) ;
          amDaganTEV200A : Result := GetDaganTEV200AMode(AmpNumber) ;
          amTriton : Result := GetTritonMode(AmpNumber) ;
          amAxoclamp900A : Result := GetAxoclamp900AMode(AmpNumber) ;
          amHekaEPC800 : Result := GetHekaEPC800Mode(AmpNumber) ;
          amEPC7 : Result := LastMode[AmpNumber] ;
          amHekaEPC9 : Result := GetHekaEPC9Mode(AmpNumber) ;
          else Result := LastMode[AmpNumber] ;
          end ;
     end ;


procedure TAmplifier.SetClampMode(
          AmpNumber : Integer ;
          Value : Integer ) ;
// -------------------------------
// Set current/voltage clamp mode
// -------------------------------
begin
     if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
        LastMode[AmpNumber] := Value ;
        end ;
     end ;


procedure TAmplifier.GetNoneChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get No amplifier channel settings
// -------------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;

    ChanName := Main.SESLabIO.ADCChannelName[iChan] ;
    ChanUnits := Main.SESLabIO.ADCChannelUnits[iChan] ;
    ChanCalFactor := Main.SESLabIO.ADCChannelVoltsPerUnit[iChan] ;
    ChanScale := 1.0 ;

    if AmpNumber < MaxAmplifiers then begin
       if IsPrimaryChannel(iChan)then begin
         FPrimaryChannelUnits[AmpNumber] := ChanUnits ;
         FPrimaryChannelScaleFactorX1Gain[AmpNumber] := ChanCalFactor ;
         ForceNonZero(FPrimaryChannelScaleFactorX1Gain[AmpNumber]) ;
         ChanScale := 1.0 ;
         FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
         end
       else if IsSecondaryChannel(iChan) then begin
         FSecondaryChannelUnits[AmpNumber] := ChanUnits ;
         FSecondaryChannelScaleFactorX1Gain[AmpNumber] := ChanCalFactor ;
         ForceNonZero(FSecondaryChannelScaleFactorX1Gain[AmpNumber]) ;
         ChanScale := 1.0 ;
         FSecondaryChannelScaleFactor[AmpNumber] := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
         end ;
       end ;

    end ;



procedure TAmplifier.GetManualChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get No amplifier channel settings
// -------------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FPrimaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := FPrimaryChannelScaleFactor[AmpNumber] /
                    FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FSecondaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := FSecondaryChannelScaleFactor[AmpNumber] /
                    FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       end ;
    end ;


procedure TAmplifier.AddAmplifierNumber(
          var Name : string ;
          iChan : Integer ) ;
// Add amplifier number
var
    NumAmps,i : Integer ;
begin

    // No. of amplifiers in use
    NumAmps := 0 ;
    for i := 0 to High(FAmpType) do if FAmpType[i] <> amNone then Inc(NumAmps) ;

    if NumAmps > 1 then Name := Name + format('%d',[(iChan div 2) + 1]) ;

    end;


procedure TAmplifier.ForceNonZero(
          var Value : Single ) ;
begin
    if Value = 0.0 then Value := 1.0 ;
    end ;

procedure TAmplifier.GetCED1902ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get CED 1902 channel settings
// -------------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    // Update amplifier settings
    if not CED1902.AmplifierSet then SetCED1902 ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := format('Ch.%d',[iChan]) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FPrimaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := CED1902.GainValue ;
       FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := format('Ch.%d',[iChan]) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FSecondaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := FSecondaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       end ;

    end ;


function TAmplifier.GetAxopatch1DGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Axopatch current gain from telegraph output
// (See Axopatch manual p.45)
// ---------------------------------------------------
const
     NumGains = 8 ;
     VGainSpacing = 0.4 ;
     VStart = 0.4 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V,AdditionalGain : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Axopatch gain settings
        Gains[0] := 1.0 ;
        Gains[1] := 2.0 ;
        Gains[2] := 4.0 ;
        Gains[3] := 10.0 ;
        Gains[4] := 20.0 ;
        Gains[5] := 40.0 ;
        Gains[6] := 100.0 ;
        Gains[7] := 200.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // If negative gain is X100 larger
        if V < 0.0 then AdditionalGain := 100.0
                   else AdditionalGain := 1.0 ;

        // Extract gain associated with telegraph voltage
        V := Abs(V) ;
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Min(Max(iGain,0),High(Gains)) ;
        LastGain[AmpNumber] := Gains[iGain]*AdditionalGain ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetAxopatch1DMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
     Result := LastMode[AmpNumber] ;
     end ;


procedure TAmplifier.GetAxopatch1DChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get Axon Axopatch 1D channel settings
// -------------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetAxopatch1DGain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ FPrimaryChannelScaleFactorX1Gain[AmpNumber]
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := FSecondaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       end ;

    end ;


function TAmplifier.GetAxopatch200Gain(
         AmpNumber : Integer ) : single ;
// ------------------------------------------------------
// Decode Axopatch 200 current gain from telegraph output
// (See Axopatch manual p.45)
// ------------------------------------------------------
const
     NumGains = 13 ;
     VGainSpacing = 0.5 ;
     VStart = 0.5 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Axopatch gain settings
        Gains[0] := 0.1 ;
        Gains[1] := 0.2 ;
        Gains[2] := 0.4 ;
        Gains[3] := 1.0 ;
        Gains[4] := 2.0 ;
        Gains[5] := 4.0 ;
        Gains[6] := 10.0 ;
        Gains[7] := 20.0 ;
        Gains[8] := 40.0 ;
        Gains[9] := 100.0 ;
        Gains[10] := 200.0 ;
        Gains[11] := 400.0 ;
        Gains[12] := 1000.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        V := Abs(V) ;
        iGain := Trunc( (V - VStart + (VGainSpacing*0.4))/VGainSpacing ) ;
        iGain := Min(Max(iGain,0),High(Gains)) ;
        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetAxopatch200Mode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
const
    VTrack = 4 ;
    VClamp = 6 ;
    IClampZero = 3 ;
    IClampNormal = 2 ;
    IClampFast = 1 ;
var
   V : single ;

begin

     if (FModeTelegraphChannel[AmpNumber] >= 0) and
        (FModeTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin
        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FModeTelegraphChannel[AmpNumber] ) ;
        if V >= (IClampZero + 0.5) then LastMode[AmpNumber] := VClampMode
                                   else LastMode[AmpNumber] := IClampMode ;
        end ;

     Result := LastMode[AmpNumber] ;

     end ;


procedure TAmplifier.GetAxopatch200ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get Axon Axopatch 200 channel settings
// -------------------------------------
var
   AmpNumber : Integer ;

begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    // Current/voltage clamp mode
    LastMode[AmpNumber] := GetAxopatch200Mode(AmpNumber) ;

    if IsPrimaryChannel(iChan) then begin
       if LastMode[AmpNumber] = VClampMode then begin
          // Voltage-clamp mode
          ChanName := 'Im' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
          ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
          end
       else begin
          // Current-clamp mode
          ChanName := 'Vm' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FPrimaryChannelUnitsCC[AmpNumber] ;
          ChanCalFactor := FPrimaryChannelScaleFactorX1GainCC[AmpNumber] ;
          end ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetAxopatch200Gain( AmpNumber ) ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ FPrimaryChannelScaleFactorX1Gain[AmpNumber]
          end ;
       FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end
    else if IsSecondaryChannel(iChan) then begin
       if LastMode[AmpNumber] = VClampMode then begin
          // Voltage-clamp mode
          ChanName := 'Vm' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
          ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
          end
       else begin
          // Current-clamp mode
          ChanName := 'Im' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FSecondaryChannelUnitsCC[AmpNumber] ;
          ChanCalFactor := FSecondaryChannelScaleFactorX1GainCC[AmpNumber] ;
          end ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;


function TAmplifier.GetWPC100Gain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode WPC-100 current gain from telegraph output
// (See WPC-100 manual p.11)
// ---------------------------------------------------
const
     NumGains = 10 ;
     VGainSpacing = 0.5 ;
     VStart = 2.0 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Gain settings
        Gains[0] := 1.0 ;
        Gains[1] := 2.0 ;
        Gains[2] := 4.0 ;
        Gains[3] := 10.0 ;
        Gains[4] := 20.0 ;
        Gains[5] := 40.0 ;
        Gains[6] := 100.0 ;
        Gains[7] := 200.0 ;
        Gains[8] := 400.0 ;
        Gains[9] := 1000.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Min(Max(iGain,0),High(Gains)) ;
        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetWPC100Mode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
     Result := LastMode[AmpNumber] ;
     end ;


procedure TAmplifier.GetWPC100ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------
// Get WPC 100 channel settings
// -----------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetWPC100Gain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ FPrimaryChannelScaleFactorX1Gain[AmpNumber]
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := FSecondaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       end ;

    end ;


function TAmplifier.GetRK400Gain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Biologic RK400 current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 10 ;
     VGainSpacing = 0.4 ;
     VStart = 0.4 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   BaseGain : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Gain settings
        Gains[0] := 1.0 ;
        Gains[1] := 2.0 ;
        Gains[2] := 5.0 ;
        Gains[3] := 10.0 ;
        Gains[4] := 20.0 ;
        Gains[5] := 50.0 ;
        Gains[6] := 100.0 ;
        Gains[7] := 200.0 ;
        Gains[8] := 500.0 ;
        Gains[9] := 1000.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Negative telegraph voltages indicated X100 gain boost
        if V < 0.0 then BaseGain := 100.0
                   else BaseGain := 1.0 ;
        V := Abs(V) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Min(Max(iGain,0),High(Gains)) ;
        LastGain[AmpNumber] := BaseGain*Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetRK400Mode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
     Result := LastMode[AmpNumber] ;
     end ;


procedure TAmplifier.GetRK400ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------
// Get RK400 channel settings
// -----------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetRK400Gain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ FPrimaryChannelScaleFactorX1Gain[AmpNumber]
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := FSecondaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       end ;
    end ;


function TAmplifier.GetOptopatchGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Cairn Optopatch current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 18 ;
     VGainSpacing = 0.5 ;
     VStart = 1.0 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Gain settings
        Gains[0] := 1.0 ; // 1V
        Gains[1] := 2.0 ;
        Gains[2] := 5.0 ; // 2V
        Gains[3] := 10.0 ;
        Gains[4] := 20.0 ; // 3V
        Gains[5] := 50.0 ;
        Gains[6] := 100.0 ; // 4V
        Gains[7] := 200.0 ;
        Gains[8] := 500.0 ; // 5V
        Gains[9] := 1000.0 ;
        Gains[10] := 2000.0 ; // 6V
        Gains[11] := 5000.0 ;
        Gains[12] := 10000.0 ; // 7V
        Gains[13] := 20000.0 ;
        Gains[14] := 50000.0 ; // 8V
        Gains[15] := 100000.0 ;
        Gains[16] := 200000.0 ;
        Gains[17] := 500000.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Min(Max(iGain,0),High(Gains)) ;
        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetOptoPatchMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
var
   V : single ;
begin

     if (FModeTelegraphChannel[AmpNumber] >= 0) and
        (FModeTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin
       // Get voltage from telegraph channel
       V := GetTelegraphVoltage( FModeTelegraphChannel[AmpNumber] ) ;
       if V >= 2.5 then LastMode[AmpNumber] := VClampMode
                   else LastMode[AmpNumber] := IClampMode ;
       end
    else LastMode[AmpNumber] := VClampMode ;
    Result := LastMode[AmpNumber] ;
    end ;



procedure TAmplifier.GetOptoPatchChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------
// Get Cairn OptoPatch channel settings
// -----------------------------
var
    AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberofChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    LastMode[AmpNumber] := GetOptoPatchMode(AmpNumber) ;

    if IsPrimaryChannel(iChan) then begin
       // Channel 0 or 2
       if LastMode[AmpNumber] = VClampMode then begin
          // Voltage-clamp mode
          ChanName :=  'Im' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits :=  FPrimaryChannelUnits[AmpNumber] ;
          ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
          end
       else begin
          // Current-clamp mode
          ChanName := 'Vm' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FPrimaryChannelUnitsCC[AmpNumber] ;
          ChanCalFactor := FPrimaryChannelScaleFactorX1GainCC[AmpNumber]
          end ;
       if GetGainTelegraphAvailable(AmpNumber) then ChanScale := GetOptopatchGain( AmpNumber )
       else ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end
    else if IsSecondaryChannel(iChan) then begin
       if LastMode[AmpNumber] = VClampMode then begin
          // Voltage-clamp mode
          ChanName := 'Vm' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FSecondaryChannelUnitsCC[AmpNumber] ;
          ChanCalFactor := FSecondaryChannelScaleFactorX1GainCC[AmpNumber]
          end
       else begin
          // Current-clamp mode
          ChanName := 'Im' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FSecondaryChannelUnitsCC[AmpNumber] ;
          ChanCalFactor := FSecondaryChannelScaleFactorX1GainCC[AmpNumber]
          end ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;


function TAmplifier.GetVP500Gain(
         AmpNumber : Integer ) : single ;
// -------------------------------------
// Get current gain from VP500 amplifier
// -------------------------------------
var
     VP500 : THardwareConf ;
     Err : Integer ;
begin
     Err := VP500_GetHardwareConf( @VP500 ) ;
     if Err >= 0 then Result := VP500.TotalGain
                 else Result := 1.0 ;
     end ;


function TAmplifier.GetVP500Mode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
     Result := LastMode[AmpNumber] ;
     end ;


procedure TAmplifier.GetVP500ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------
// Get Biologic VP500 channel settings
// -----------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    if  IsPrimaryChannel(iChan) then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := 'pA' ;
       ChanCalFactor := 0.001 ;
       ChanScale := GetVP500Gain(AmpNumber) ;
       FPrimaryChannelScaleFactorX1Gain[AmpNumber] := ChanCalFactor ;
       FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       FPrimaryChannelUnits[AmpNumber] := ChanUnits ;
       end
    else if  IsSecondaryChannel(iChan)  then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := 'mV' ;
       ChanCalFactor := 0.05 ; //
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactorX1Gain[AmpNumber] := ChanCalFactor ;
       FSecondaryChannelScaleFactor[AmpNumber] := FSecondaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       FSecondaryChannelUnits[AmpNumber] := ChanUnits ;
       end ;

    end ;


function TAmplifier.GetMultiClampMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
var
    ChanName : String ;
    ChanUnits : String ;
    ChanCalFactor : single ;
    ChanScale : single ;
begin

     GetMultiClampChannelSettings( FPrimaryOutputChannel[AmpNumber],
                                   ChanName,ChanUnits,ChanCalFactor,ChanScale ) ;
     if ANSIContainsText(ChanUnits,'A') then LastMode[AmpNumber] := VCLAMPMode
                                        else LastMode[AmpNumber] := ICLAMPMode ;
     Result := LastMode[AmpNumber] ;
     end ;


function TAmplifier.GetMultiClampGain(
         AmpNumber : Integer ) : single ;
// --------------------------
// Get Axon Multi-Clamp gain
// --------------------------
begin

    if not MCConnectionOpen then OpenMulticlamp ;
    if not MCConnectionOpen then begin
       Result := 1.0 ;
       Exit ;
       end ;

    Result := MCTelegraphData[AmpNumber].PrimaryAlpha ;
    if Result = 0.0 then Result := 1.0 ;

    end ;


procedure TAmplifier.OpenMultiClamp ;
// ------------------------------------
// Open connection to Multiclamp A or B
// ------------------------------------
var
    lParam : Cardinal ;
    i : Integer ;
begin

    if MCConnectionOpen then Exit ;

    // Register messages
    MCOpenMessageID := RegisterWindowMessage(MCTG_OPEN_MESSAGE_STR) ;
    MCCloseMessageID := RegisterWindowMessage(MCTG_CLOSE_MESSAGE_STR) ;
    MCRequestMessageID := RegisterWindowMessage(MCTG_REQUEST_MESSAGE_STR) ;
    MCReconnectMessageID := RegisterWindowMessage(MCTG_RECONNECT_MESSAGE_STR) ;
    MCBroadcastMessageID := RegisterWindowMessage(MCTG_BROADCAST_MESSAGE_STR) ;
    MCIDMessageID := RegisterWindowMessage(MCTG_ID_MESSAGE_STR) ;
    // Request MultiClamps to identify themselves

    // Clear available channel list
    for i := 0 to High(MCChannels) do MCChannels[i] := 0 ;
    MCNumChannels := 0 ;
    lParam := 0 ;
    if not PostMessage( HWND_BROADCAST,
                        MCBroadcastMessageID,
                        Application.Handle,
                        lParam ) then
                        ShowMessage( 'MultiClamp Commander (Broadcast Message Failed)' ) ;

    MCConnectionOpen := True ;

    end ;


procedure TAmplifier.GetMultiClampChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// --------------------------
// Get Axon Multi-Clamp channel settings
// --------------------------
var
    i : Integer ;
    Units : Integer ;
    ChanNames : Array[0..MCTG_OUT_MUX_MAXCHOICES-1] of String ;
   AmpNumber,AxonAmpNumber : Integer ;
begin

    // Open connection to multiclamp
    if not MCConnectionOpen then OpenMulticlamp ;
    if not MCConnectionOpen then begin
       Exit ;
       end ;

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    AxonAmpNumber := AmpNumber {+ 1} ;

    if MCConnectionOpen then begin

       for i := 0 to High(ChanNames) do begin

           ChanNames[i] := format('%d',[i]) ;

           if MCTelegraphData[AmpNumber].HardwareType = 1 then begin
              if i < High(MCTG_ChanNames700B) then ChanNames[i] := MCTG_ChanNames700B[i] ;
              end
           else if i <= High(MCTG_ChanNames700A_VC) then begin
              if MCTelegraphData[AmpNumber].OperatingMode = MCTG_MODE_VCLAMP then begin
                 ChanNames[i] := MCTG_ChanNames700A_VC[i] ;
                 end
              else begin
                 ChanNames[i] := MCTG_ChanNames700A_CC[i] ;
                 end ;
              end ;
           end ;


       if IsPrimaryChannel(iChan) then begin

          // Primary channel

          if MCTelegraphData[AmpNumber].PrimaryScaledOutSignal < High(ChanNames) then
             ChanName := ChanNames[MCTelegraphData[AmpNumber].PrimaryScaledOutSignal] ;

          ChanName := ChanName + format('%d',[AmpNumber]) ;
          Units := MCTelegraphData[AmpNumber].PrimaryScaleFactorUnits ;
          ChanCalFactor := MCTelegraphData[AmpNumber].PrimaryScaleFactor ;
          ChanScale := MCTelegraphData[AmpNumber].PrimaryAlpha ;
          FPrimaryChannelScaleFactorX1Gain[AmpNumber] := ChanCalFactor ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;

          end
       else if IsSecondaryChannel(iChan) then begin

          // Secondary channel

          if MCTelegraphData[AmpNumber].SecondaryOutSignal < High(ChanNames) then
             ChanName := ChanNames[MCTelegraphData[AmpNumber].SecondaryOutSignal] ;

          ChanName := ChanName + format('%d',[AmpNumber]) ;
          Units := MCTelegraphData[AmpNumber].SecondaryScaleFactorUnits ;
          ChanCalFactor := MCTelegraphData[AmpNumber].SecondaryScaleFactor ;
          ChanScale := MCTelegraphData[AmpNumber].SecondaryAlpha ;
          FSecondaryChannelScaleFactorX1Gain[AmpNumber] := ChanCalFactor ;
          FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end ;

       // Convert to WinWCP preferred units (mV, pA)

       case Units of
           MCTG_UNITS_VOLTS_PER_VOLT : Begin
              ChanCalFactor := ChanCalFactor*0.001 ;
              ChanUnits := 'mV' ;
              end ;
           MCTG_UNITS_VOLTS_PER_MILLIVOLT : Begin
              ChanUnits := 'mV' ;
              end ;
           MCTG_UNITS_VOLTS_PER_MICROVOLT : Begin
              ChanUnits := 'uV' ;
              end ;
           MCTG_UNITS_VOLTS_PER_AMP : Begin
              ChanCalFactor := ChanCalFactor*1E-12 ;
              ChanUnits := 'pA' ;
              end ;
           MCTG_UNITS_VOLTS_PER_MILLIAMP : Begin
              ChanCalFactor := ChanCalFactor*1E-9 ;
              ChanUnits := 'pA' ;
              end ;
           MCTG_UNITS_VOLTS_PER_MICROAMP : Begin
              ChanCalFactor := ChanCalFactor*1E-6 ;
              ChanUnits := 'pA' ;
              end ;
           MCTG_UNITS_VOLTS_PER_NANOAMP : Begin
              ChanCalFactor := ChanCalFactor*1E-3 ;
              ChanUnits := 'pA' ;
              end ;
           MCTG_UNITS_VOLTS_PER_PICOAMP : Begin
              ChanCalFactor := ChanCalFactor ;
              ChanUnits := 'pA' ;
              end ;
           else begin
              ChanUnits := '?' ;
              end ;
           end ;

       if ChanScale = 0.0 then ChanScale := 1.0 ;
       if ChanCalFactor = 0.0 then ChanCalFactor := 1.0 ;

       if IsPrimaryChannel(iChan) then FPrimaryChannelUnits[AmpNumber] := ChanUnits
       else if IsSecondaryChannel(iChan) then FSecondaryChannelUnits[AmpNumber] := ChanUnits ;

       // Set voltage/current command scale factor
       if MCTelegraphData[AmpNumber].OperatingMode = MCTG_MODE_VCLAMP then begin
          FVoltageCommandScaleFactor[AmpNumber] := MCTelegraphData[AmpNumber].ExtCmdSens ;
          Main.StatusBar.SimpleText := format(
                                       'Multiclamp 700: Command Voltage Sensitivity: %.4g mV/V',
                                       [FVoltageCommandScaleFactor[AmpNumber]*1000.0]);
          end
       else begin
          FCurrentCommandScaleFactor[AmpNumber] := MCTelegraphData[AmpNumber].ExtCmdSens ;
          Main.StatusBar.SimpleText := format(
                                       'Multiclamp 700: Current Voltage Sensitivity: %.4g pA/V',
                                       [FCurrentCommandScaleFactor[AmpNumber]*1E12]);

          //Main.StatusBar.SimpleText := format('%.4g',[FCurrentCommandScaleFactor[AmpNumber]]);
          end ;

       end
    else begin
       ChanCalFactor := 1.0 ;
       ChanScale := 1.0 ;
       end ;

    end ;


function TAmplifier.GetTurboTecGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode NPI TurboTec current gain from telegraph output
// ---------------------------------------------------
const
     MaxGains = 8 ;
     VGainSpacing = 1.0 ;
var
   Gains : Array[0..MaxGains-1] of single ;
   NumGains : Integer ;
   VStart : Single ;
   V : single ;
   iGain : Integer ;
begin

     case FAmpType[AmpNumber] of

        amTurboTec03 : Begin
           NumGains := 7 ;
           VStart := 1.0 ;
           Gains[0] := 1.0 ;
           Gains[1] := 2.0 ;
           Gains[2] := 5.0 ;
           Gains[3] := 10.0 ;
           Gains[4] := 20.0 ;
           Gains[5] := 50.0 ;
           Gains[6] := 100.0 ;
           end ;
        amTurboTec05,amTurboTec10CX,amTurboTec10C : Begin
           NumGains := 8 ;
           VStart := 0.0 ;
           Gains[0] := 1.0 ;
           Gains[1] := 1.25 ;
           Gains[2] := 2.0 ;
           Gains[3] := 5.0 ;
           Gains[4] := 10.0 ;
           Gains[5] := 20.0 ;
           Gains[6] := 50.0 ;
           Gains[7] := 100.0 ;
           end ;
        else begin
           // TurboTec 10C, 20, 30
           VStart := 1.0 ;
           NumGains := 6 ;
           Gains[0] := 1.0 ;
           Gains[1] := 2.0 ;
           Gains[2] := 5.0 ;
           Gains[3] := 10.0 ;
           Gains[4] := 50.0 ;
           Gains[5] := 100.0 ;
           end ;
        end ;

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Gain settings

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Min(Max(iGain,0),NumGains-1) ;
        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetTurboTecMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
     Result := LastMode[AmpNumber] ;
     end ;


procedure TAmplifier.GetTurboTecChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get NPI TurboTec10C channel settings
// -----------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetTurboTecGain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ FPrimaryChannelScaleFactorX1Gain[AmpNumber]
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := FSecondaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       end ;

    end ;


function TAmplifier.GetAMS2400Gain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode A-M Systems 2400 current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 16 ;
     VGainSpacing = 0.5 ;
     VStart = 0.3 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Gain settings
        Gains[0] := 1.0 ;
        Gains[1] := 2.0 ;
        Gains[2] := 5.0 ;
        Gains[3] := 10.0 ;
        Gains[4] := 20.0 ;
        Gains[5] := 50.0 ;
        Gains[6] := 100.0 ;
        Gains[7] := 200.0 ;
        Gains[8] := 500.0 ;
        Gains[9] := 1000.0 ;
        Gains[10] := 2000.0 ;
        Gains[11] := 5000.0 ;
        Gains[12] := 10000.0 ;
        Gains[13] := 20000.0 ;
        Gains[14] := 50000.0 ;
        Gains[15] := 100000.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        if V < (VStart-0.1) then iGain := 0
        else begin
           iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) + 1 ;
           end ;
        iGain := Min(Max(iGain,0),NumGains-1) ;
        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;

     end ;


function TAmplifier.GetAMS2400Mode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
var
   V : single ;
begin

    // Get mode telegraph value
    if (FModeTelegraphChannel[AmpNumber] >= 0) and
        (FModeTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin
       // Get voltage from telegraph channel
       V := GetTelegraphVoltage( FModeTelegraphChannel[AmpNumber] ) ;
       if V >= 2.2 then LastMode[AmpNumber] := IClampMode
                   else LastMode[AmpNumber] := VClampMode ;
       end ;
    //else LastMode[AmpNumber] := VClampMode ;
    Result := LastMode[AmpNumber] ;
    end ;



procedure TAmplifier.GetAMS2400ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get A-M Systems 2400  channel settings
// -----------------------------------
var
   AmpNumber : Integer ;

begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    // Current/voltage clamp mode
    LastMode[AmpNumber] := GetAMS2400Mode(AmpNumber) ;

    if IsPrimaryChannel(iChan) then begin
       if LastMode[AmpNumber] = VClampMode then begin
          // Voltage-clamp mode
          ChanName := 'Im' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FPrimaryChannelUnits[AmpNumber];
          ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber];
          end
       else begin
          // Current-clamp mode
          ChanName := 'Vm' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FPrimaryChannelUnitsCC[AmpNumber];
          ChanCalFactor := FPrimaryChannelScaleFactorX1GainCC[AmpNumber]
          end ;
       if GetGainTelegraphAvailable(AmpNumber) then ChanScale := GetAMS2400Gain( AmpNumber )
       else ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
       FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end
    else if IsSecondaryChannel(iChan) then begin
       if LastMode[AmpNumber] = VClampMode then begin
          // Voltage-clamp mode
          ChanName := 'Vm' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FSecondaryChannelUnits[AmpNumber];
          ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber];
          end
       else begin
          // Current-clamp mode
          ChanName := 'Im' ;
          AddAmplifierNumber( ChanName, iChan ) ;
          ChanUnits := FSecondaryChannelUnitsCC[AmpNumber];
          ChanCalFactor := FSecondaryChannelScaleFactorX1GainCC[AmpNumber];
          end ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;


function TAmplifier.GetEPC8Gain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Biologic RK400 current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 6 ;
     NumRanges = 3 ;
var
   Gains : Array[0..NumGains-1] of single ;
   RangeMultiplier : Array[0..NumRanges-1] of single ;
   iGain,iRange : Integer ;
   Bits : Integer ;
begin

     // Gain settings
     Gains[0] := 0.5 ;
     Gains[1] := 1.0 ;
     Gains[2] := 2.0 ;
     Gains[3] := 5.0 ;
     Gains[4] := 10.0 ;
     Gains[5] := 20.0 ;

     RangeMultiplier[0] := 100.0 ; // Medium Gain
     RangeMultiplier[1] := 10000.0 ; // High Gain
     RangeMultiplier[2] := 1.0 ; // Low Gain

     // Read digital I/P lines
     Bits := Main.SESLabIO.DIGInputs ;

     // Decode gain
     iGain := Bits and $7 ;
     iRange := (Bits shr 3) and $3 ;
     iRange := Min( iRange, 2 ) ;
     iGain := Min(Max(iGain,0),NumGains-1) ;
     Result := Gains[iGain]*RangeMultiplier[iRange] ;

     end ;


function TAmplifier.GetEPC8Mode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetEPC8ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get Heka EPC-8 channel settings
// -------------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetEPC8Gain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;


function TAmplifier.GetSEC05LXGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode NPI SEC05LX current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 7 ;
     VGainSpacing = 1.0 ;
     VStart = 1.0 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Gain settings
        Gains[0] := 1.0 ;
        Gains[1] := 2.0 ;
        Gains[2] := 5.0 ;
        Gains[3] := 10.0 ;
        Gains[4] := 20.0 ;
        Gains[5] := 50.0 ;
        Gains[6] := 100.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Max(Min(iGain,NumGains-1),0);

        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetSEC05LXMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetSEC05LXChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get NPI SEC05LX channel settings
// -----------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetSEC05LXGain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;


function TAmplifier.GetDaganPCOneGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Dagan PC-One current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 8 ;
     VGainSpacing = 0.4 ;
     VStart = 0.4 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Gain settings
        Gains[0] := 1 ;
        Gains[1] := 2 ;
        Gains[2] := 5 ;
        Gains[3] := 10 ;
        Gains[4] := 20 ;
        Gains[5] := 50.0 ;
        Gains[6] := 100.0 ;
        Gains[7] := 200.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( ((V - VStart)/VGainSpacing) + 0.1 ) ;
        iGain := Max(Min(iGain,NumGains-1),0);

        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetDaganPCOneMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetDaganPCOneChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get Dagan PC-One channel settings
// -----------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetDaganPCOneGain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] :=ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;


function TAmplifier.GetDagan3900AGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Dagan 3900A current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 8 ;
     VGainSpacing = 0.4 ;
     VStart = 0.4 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Gain settings
        Gains[0] := 1 ;
        Gains[1] := 2 ;
        Gains[2] := 5 ;
        Gains[3] := 10 ;
        Gains[4] := 20 ;
        Gains[5] := 50.0 ;
        Gains[6] := 100.0 ;
        Gains[7] := 500.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Max(Min(iGain,NumGains-1),0);

        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetDagan3900AMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetDagan3900AChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get Dagan 3900A channel settings
// -----------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetDagan3900AGain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;



function TAmplifier.GetWarnerPC501AGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Warner PC501A current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 21 ;
     VGainSpacing = 0.2 ;
     VStart = 0.2 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // 100 MOhm HS Gain settings
        Gains[0] := 1.0  ;
        Gains[1] := 2.0  ;
        Gains[2] := 5.0  ;
        Gains[3] := 10.0  ;
        Gains[4] := 20.0  ;
        Gains[5] := 50.0 ;
        Gains[6] := 100.0 ;

        // 1 GOhm HS Gain settings
        Gains[7] := 10.0  ;
        Gains[8] := 20.0  ;
        Gains[9] := 50.0  ;
        Gains[10] := 100.0  ;
        Gains[11] := 200.0  ;
        Gains[12] := 500.0 ;
        Gains[13] := 1000.0 ;

        // 10 GOhm HS Gain settings
        Gains[14] := 100.0 ;
        Gains[15] := 200.0 ;
        Gains[16] := 500.0 ;
        Gains[17] := 1000.0 ;
        Gains[18] := 2000.0 ;
        Gains[19] := 5000.0 ;
        Gains[20] := 10000.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Max(Min(iGain,NumGains-1),0);

        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;

     end ;


function TAmplifier.GetWarnerPC501AMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetWarnerPC501AChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get Warner PC501A channel settings
// -----------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetWarnerPC501AGain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := FSecondaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       end ;

    end ;


function TAmplifier.GetWarnerPC505BGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Warner PC505B current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 14 ;
     VGainSpacing = 0.5 ;
     VStart = 0.5 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        Gains[0] := 1.0  ;
        Gains[1] := 2.0  ;
        Gains[2] := 4.0  ;
        Gains[3] := 10.0  ;
        Gains[4] := 20.0  ;
        Gains[5] := 40.0 ;
        Gains[6] := 100.0 ;
        Gains[7] := 200.0  ;
        Gains[8] := 400.0  ;
        Gains[9] := 1000.0  ;
        Gains[10] := 2000.0  ;
        Gains[11] := 4000.0  ;
        Gains[12] := 10000.0 ;
        Gains[13] := 20000.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Max(Min(iGain,NumGains-1),0);

        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetWarnerPC505BMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetWarnerPC505BChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get Warner PC505B channel settings
// -----------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetWarnerPC505BGain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;


function TAmplifier.GetWarnerOC725CGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Warner OC725C current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 13 ;
     VGainSpacing = 0.2 ;
     VStart = 0.2 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        Gains[0] := 1.0  ;
        Gains[1] := 2.0  ;
        Gains[2] := 5.0  ;
        Gains[3] := 10.0  ;
        Gains[4] := 20.0  ;
        Gains[5] := 50.0 ;
        Gains[6] := 100.0 ;
        Gains[7] := 200.0  ;
        Gains[8] := 500.0  ;
        Gains[9] := 1000.0  ;
        Gains[10] := 2000.0  ;
        Gains[11] := 5000.0  ;
        Gains[12] := 10000.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Max(Min(iGain,NumGains-1),0);

        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetWarnerOC725CMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetWarnerOC725CChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get Warner OC725C voltage clamp channel settings
// -----------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetWarnerOC725CGain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;


function TAmplifier.GetAxoclamp2Gain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Axoclamp current gain
// ---------------------------------------------------
begin
     Result := 1.0 ;
     end ;


function TAmplifier.GetAxoclamp2Mode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetAxoclamp2ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get Axoclamp 2 voltage clamp channel settings
// -----------------------------------
var
    AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FPrimaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := FPrimaryChannelScaleFactor[AmpNumber] /
                    FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FSecondaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := FSecondaryChannelScaleFactor[AmpNumber] /
                    FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       end ;
    end ;


function TAmplifier.GetDaganTEV200AGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Dagan TEV200A current gain from telegraph output
// ---------------------------------------------------
const
     NumGains = 8 ;
     VGainSpacing = 0.4 ;
     VStart = 0.4 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        Gains[0] := 1.0  ;
        Gains[1] := 2.0  ;
        Gains[2] := 4.0  ;
        Gains[3] := 10.0  ;
        Gains[4] := 20.0  ;
        Gains[5] := 40.0 ;
        Gains[6] := 100.0 ;
        Gains[7] := 200.0  ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Max(Min(iGain,NumGains-1),0);

        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetDaganTEV200AMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetDaganTEV200AChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// ------------------------------------------------
// Get Dagan TEV200A voltage clamp channel settings
// ------------------------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;
    
    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetDaganTEV200AGain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;


function TAmplifier.GetTritonGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Tecella Triton current gain
// ---------------------------------------------------
begin

     Result := 1.0 ;
     Triton_CurrentGain(AmpNumber)

     end ;


procedure TAmplifier.GetTritonChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get Tecella Triton  voltage clamp channel settings
// -----------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    Triton_Channel_Calibration( iChan, ChanName, ChanUnits, ChanCalFactor, ChanScale ) ;
    if IsPrimaryChannel(iChan) then begin
       FPrimaryChannelScaleFactorX1Gain[0] := ChanCalFactor ;
       FPrimaryChannelScaleFactor[0] := FPrimaryChannelScaleFactorX1Gain[0]*ChanScale ;
       FPrimaryChannelUnits[AmpNumber] := ChanUnits ;
       end ;

    end ;

function TAmplifier.GetTritonMode(
         AmpNumber : Integer ) : Integer ;
// ------------------------------
// Get current/voltage clamp mode
// ------------------------------
begin
    Result := Triton_ClampMode ;
    LastMode[AmpNumber] := Result ;
    end ;


function TAmplifier.GetHekaEPC800Gain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Heka EPC-800 current gain from telegraph output
// (See Heka EPC-800 manual p.70)
// ---------------------------------------------------
const
     NumGains = 18 ;
     VGainSpacing = 0.5 ;
     VStart = 0.0 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        Gains[0] :=  1. ;
        Gains[1] :=  2. ;
        Gains[2] :=  4. ;
        Gains[3] :=  10. ;
        Gains[4] :=  20. ;
        Gains[5] :=  40. ;
        Gains[6] :=  100. ;
        Gains[7] :=  200. ;
        Gains[8] :=  400. ;
        Gains[9] :=  1000. ;
        Gains[10] := 2000. ;
        Gains[11] := 4000. ;
        Gains[12] := 10000. ;
        Gains[13] := 20000. ;
        Gains[14] := 40000. ;
        Gains[15] := 100000. ;
        Gains[16] := 200000. ;
        Gains[17] := 400000. ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] ) ;

        // Extract gain associated with telegraph voltage
        V := Abs(V) ;
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Min(Max(iGain,0),High(Gains)) ;
        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetHekaEPC800Mode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
const
       VCurrentClampMode = 1.0 ; // This is a guess!!!
var
   V : single ;
begin
     if (FModeTelegraphChannel[AmpNumber] >= 0) and
        (FModeTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin
       // Get voltage from telegraph channel
       V := GetTelegraphVoltage( FModeTelegraphChannel[AmpNumber] ) ;
       if V >= (VCurrentClampMode+0.1) then LastMode[AmpNumber] := IClampMode
                                       else LastMode[AmpNumber] := VClampMode ;
       end
    else LastMode[AmpNumber] := VClampMode ;
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetHekaEPC800ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get Heka EPC 800 channel settings
// -------------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetHekaEPC800Gain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;



procedure TAmplifier.GetEPC7ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get EPC 7 channel settings
// -------------------------------------
var
    AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FPrimaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := FPrimaryChannelScaleFactor[AmpNumber] /
                    FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FSecondaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := FSecondaryChannelScaleFactor[AmpNumber] /
                    FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       end ;
    end ;


function TAmplifier.GetHekaEPC9Gain(
         AmpNumber : Integer ) : single ;
// -------------------------
// Get EPC-9/10 current gain
// -------------------------
var
    Gain,ScaleFactor : Single ;
begin
     Main.SESLabIO.EPC9GetCurrentGain( AmpNumber, Gain, ScaleFactor ) ;
     LastGain[AmpNumber] := Gain ;
     Result := LastGain[AmpNumber] ;
     end ;


function TAmplifier.GetHekaEPC9Mode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
begin
     if Main.SESLabIO.EPC9Mode < 2 then LastMode[AmpNumber] := VClampMode
                                   else LastMode[AmpNumber] := IClampMode ;
    Result := LastMode[AmpNumber] ;
    end ;


procedure TAmplifier.GetHekaEPC9ChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get Heka EPC 9/10 channel settings
// -------------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          Main.SESLabIO.EPC9GetCurrentGain( AmpNumber, ChanScale, ChanCalFactor ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          FPrimaryChannelScaleFactorX1Gain[AmpNumber] :=  ChanCalFactor ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ChanScale := 1.0 ;
       FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
       end ;

    end ;


function TAmplifier.GetDaganCA1BGain(
         AmpNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Dagan CA-1B current gain from gain and mode telegraph output
// (See Heka EPC-800 manual p.70)
// ---------------------------------------------------
const
     NumImGains = 8 ;
     NumProcGains = 6 ;
     VGainSpacing = 0.4 ;
     VStart = 0.4 ;
var
   ImGains : Array[0..NumImGains-1] of Single ;
   ProcGains : Array[0..NumProcGains-1] of Single ;
   V : single ;
   iGain : Integer ;
   Gain : Single ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (FGainTelegraphChannel[AmpNumber] >= 0) and
        (FGainTelegraphChannel[AmpNumber] < Main.SESLabIO.ADCMaxChannels) and
        (not ADCInUse) then begin

        // Current amplifier gains
        ImGains[0] :=  1.0 ;
        ImGains[1] :=  2.0 ;
        ImGains[2] :=  10.0 ;
        ImGains[3] :=  20.0 ;
        ImGains[4] :=  100.0 ;
        ImGains[5] :=  200.0 ;
        ImGains[6] :=  1000.0 ;
        ImGains[7] :=  2000.0 ;

        // Processing amplifier
        ProcGains[0] :=  1.0 ;
        ProcGains[1] :=  2.0 ;
        ProcGains[2] :=  5.0 ;
        ProcGains[3] :=  10.0 ;
        ProcGains[4] :=  20.0 ;
        ProcGains[5] :=  50.0 ;

        // Extract gain associated with telegraph voltage
        // Get Im gain
        V := Abs(GetTelegraphVoltage( FGainTelegraphChannel[AmpNumber] )) ;
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        Gain := ImGains[Min(Max(iGain,0),High(ImGains))] ;
        // Multiply by proc gain
        V := Abs(GetTelegraphVoltage( FModeTelegraphChannel[AmpNumber] )) ;
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        Gain := Gain*ProcGains[Min(Max(iGain,0),High(ProcGains))] ;

        LastGain[AmpNumber] := Gain ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


procedure TAmplifier.GetDaganCA1BChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get Dagab CA-1B channel settings
// -------------------------------------
var
    AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ForceNonZero(FPrimaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;

       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetDaganCA1BGain( AmpNumber ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ FPrimaryChannelScaleFactorX1Gain[AmpNumber]
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FSecondaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := FSecondaryChannelScaleFactor[AmpNumber] /
                    FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       end ;
    end ;


procedure TAmplifier.GetDaganBVC700AChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -------------------------------------
// Get Dagan BVC700A channel settings
// -------------------------------------
var
    AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FPrimaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := FPrimaryChannelScaleFactor[AmpNumber] /
                    FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       ForceNonZero(FSecondaryChannelScaleFactorX1Gain[AmpNumber]) ;
       ChanScale := FSecondaryChannelScaleFactor[AmpNumber] /
                    FSecondaryChannelScaleFactorX1Gain[AmpNumber] ;
       end ;
    end ;


function TAmplifier.GetAxoclamp900AGain(
         ChanNumber : Integer ) : single ;
// ---------------------------------------------------
// Decode Axoclamp 900A current gain
// ---------------------------------------------------
const
     NumGains = 8 ;
     VGainSpacing = 0.4 ;
     VStart = 0.4 ;
var
   Gain : Double ;
   Mode,Err : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead
     Result := 1.0 ;
     if not Axoclamp900AOpen then OpenAxoclamp900A ;
     if not Axoclamp900AOpen then Exit ;

     ChanNumber := Min(Max(ChanNumber,0),1) ;
     AXC_GetMode( Axoclamp900AHnd, ChanNumber, Mode, Err ) ;
     Gain := -1 ;
     AXC_GetScaledOutputGain( Axoclamp900AHnd, Gain, ChanNumber, Mode, Err ) ;

     Result := Gain ;
     end ;


function TAmplifier.GetAxoclamp900AMode(
         AmpNumber : Integer ) : Integer ;
// -----------------------------------------
// Read voltage/current clamp mode telegraph
// -----------------------------------------
var
    ChanName : String ;
    ChanUnits : String ;
    ChanCalFactor : single ;
    ChanScale : single ;
begin

     GetAxoclamp900AChannelSettings( FPrimaryOutputChannel[AmpNumber],
                                   ChanName,ChanUnits,ChanCalFactor,ChanScale ) ;
     if ANSIContainsText(ChanUnits,'A') then LastMode[AmpNumber] := ICLAMPMode
                                        else LastMode[AmpNumber] := VCLAMPMode ;
     Result := LastMode[AmpNumber] ;
     end ;




procedure TAmplifier.GetAxoclamp900AChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get Axoclamp900A voltage clamp channel settings
// -----------------------------------
var
    Err,iSignal,iMode : Integer ;
    ISCale : Double ;
    HeadstageType : Integer ;
    AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if not Axoclamp900AOpen then OpenAxoclamp900A ;
    if not Axoclamp900AOpen then Exit ;

    if IsPrimaryChannel(iChan) then begin

          // Primary channel

       AXC_GetMode( Axoclamp900AHnd, iChan mod 2, iMode, Err ) ;
       AXC_GetScaledOutputSignal( Axoclamp900AHnd, iSignal, AmpNumber, iMode, Err ) ;
       ChanName := AXC_SignalName[iSignal] ;
       ChanUnits := AXC_SignalUnits[iSignal] ;

       iSignal := Min(Max(iSignal,0),High(AXC_ChanCalFactors)) ;

       //AXC_GetSignalScaleFactor( Axoclamp900AHnd, ScaleFactor, iSignal, Err ) ;
       // Get type of headstage and calculate calibration factor
       AXC_GetHeadstageType( Axoclamp900AHnd, HeadstageType, AmpNumber, False, Err ) ;
       case HeadstageType of
          AXC_HEADSTAGE_TYPE_HS9_x10uA : IScale := 0.001 ;
          AXC_HEADSTAGE_TYPE_HS9_x1uA : IScale := 0.01 ;
          AXC_HEADSTAGE_TYPE_HS9_x100nA : IScale := 0.1 ;
          AXC_HEADSTAGE_TYPE_VG9_x10uA : IScale := 0.001 ;
          AXC_HEADSTAGE_TYPE_VG9_x100uA : IScale := 0.0001 ;
          else IScale := 0.01 ;
          end ;
       if ChanUnits = 'mV' then ChanCalFactor := 0.01
                           else ChanCalFactor := IScale ;

       if (iSignal = AXC_SIGNAL_ID_DIV10V2) or (iSignal = AXC_SIGNAL_ID_DIV10I2) then
          ChanCalFactor := ChanCalFactor*0.1 ;

       ChanScale := GetAxoclamp900AGain(AmpNumber) ;
       FPrimaryChannelScaleFactorX1Gain[AmpNumber] := ChanCalFactor ;
       FPrimaryChannelScaleFactor[AmpNumber] := FPrimaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       FPrimaryChannelUnits[AmpNumber] := ChanUnits ;


       end
    else begin

       AXC_GetMode( Axoclamp900AHnd, AmpNumber, iMode, Err ) ;
       AXC_GetScaledOutputSignal( Axoclamp900AHnd, iSignal, AmpNumber, iMode, Err ) ;

       iSignal := Min(Max(iSignal,0),High(AXC_ChanCalFactors)) ;

       ChanName := AXC_SignalName[iSignal] ;
       ChanUnits := AXC_SignalUnits[iSignal] ;

       // Get type of headstage and calculate calibration factor
       AXC_GetHeadstageType( Axoclamp900AHnd, HeadstageType, AmpNumber, False, Err ) ;
       case HeadstageType of
          AXC_HEADSTAGE_TYPE_HS9_x10uA : IScale := 0.001 ;
          AXC_HEADSTAGE_TYPE_HS9_x1uA : IScale := 0.01 ;
          AXC_HEADSTAGE_TYPE_HS9_x100nA : IScale := 0.1 ;
          AXC_HEADSTAGE_TYPE_VG9_x10uA : IScale := 0.001 ;
          AXC_HEADSTAGE_TYPE_VG9_x100uA : IScale := 0.0001 ;
          else IScale := 0.01 ;
          end ;

       if ChanUnits = 'mV' then ChanCalFactor := 0.01
                           else ChanCalFactor := IScale ;

       if (iSignal = AXC_SIGNAL_ID_DIV10V2) or (iSignal = AXC_SIGNAL_ID_DIV10I2) then
          ChanCalFactor := ChanCalFactor*0.1 ;

       ChanScale := GetAxoclamp900AGain(AmpNumber) ;
       FSecondaryChannelScaleFactorX1Gain[AmpNumber] := ChanCalFactor ;
       FSecondaryChannelScaleFactor[AmpNumber] := FSecondaryChannelScaleFactorX1Gain[AmpNumber]*ChanScale ;
       FSecondaryChannelUnits[AmpNumber] := ChanUnits ;

       end ;

    end ;


procedure TAmplifier.OpenAxoclamp900A ;
// ------------------------------------
// Open link to Axoclamp 900A commander
// ------------------------------------
var
    Err : Integer ;
    SerialNum : Array[0..15] of ANSIChar ;
    DemoMode : Boolean ;
//    Devicename : Array[0..32] of Char ;
begin

     if Axoclamp900AOpen then Exit ;

     if not Axoclamp900ALibLoaded then begin
        // Load main library
        if FileExists(Axoclamp900ALibPath + 'axoclampdriver.dll') then begin
           // Look for DLLs in Axoclamp 900A folder
           Axoclamp900AHIDHnd := LoadLibrary(PChar(Axoclamp900ALibPath + 'axHIDManager.dll')) ;
           Axoclamp900ALibHnd := LoadLibrary(PChar(Axoclamp900ALibPath + 'axoclampdriver.dll')) ;
           end
        else begin
           // Look for DLLs elsewhere
           Axoclamp900AHIDHnd := LoadLibrary(PChar('axHIDManager.dll')) ;
           Axoclamp900ALibHnd := LoadLibrary(PChar('axoclampdriver.dll')) ;
           end ;
        if Axoclamp900ALibHnd <= 0 then begin
           ShowMessage( format('%s library not found',[Axoclamp900ALibPath])) ;
           Exit ;
           end ;
        end ;

     Axoclamp900ALibLoaded := True ;

     @AXC_CheckAPIVersion := LoadProcedure( Axoclamp900ALibHnd, 'AXC_CheckAPIVersion' ) ;
     @AXC_CreateHandle := LoadProcedure( Axoclamp900ALibHnd, 'AXC_CreateHandle' ) ;
     @AXC_DestroyHandle := LoadProcedure( Axoclamp900ALibHnd, 'AXC_DestroyHandle' ) ;
     @AXC_FindFirstDevice := LoadProcedure( Axoclamp900ALibHnd, 'AXC_FindFirstDevice' ) ;
     @AXC_FindNextDevice := LoadProcedure( Axoclamp900ALibHnd, 'AXC_FindNextDevice' ) ;
     @AXC_OpenDevice := LoadProcedure( Axoclamp900ALibHnd, 'AXC_OpenDevice' ) ;
     @AXC_CloseDevice := LoadProcedure( Axoclamp900ALibHnd, 'AXC_CloseDevice' ) ;
     @AXC_GetSerialNumber := LoadProcedure( Axoclamp900ALibHnd, '_AXC_GetSerialNumber@16' ) ;
     @AXC_IsDeviceOpen := LoadProcedure( Axoclamp900ALibHnd, '_AXC_IsDeviceOpen@12' ) ;
     @AXC_GetScaledOutputSignal := LoadProcedure( Axoclamp900ALibHnd, '_AXC_GetScaledOutputSignal@20' ) ;
     AXC_SetScaledOutputSignal := LoadProcedure( Axoclamp900ALibHnd, '_AXC_SetScaledOutputSignal@20' ) ;
     @AXC_GetScaledOutputGain := LoadProcedure( Axoclamp900ALibHnd, '_AXC_GetScaledOutputGain@20' ) ;
     @AXC_SetScaledOutputGain := LoadProcedure( Axoclamp900ALibHnd, '_AXC_SetScaledOutputGain@24' ) ;
     @AXC_GetMode := LoadProcedure( Axoclamp900ALibHnd, '_AXC_GetMode@16' ) ;
     @AXC_GetDeviceName := LoadProcedure( Axoclamp900ALibHnd, '_AXC_GetDeviceName@16' ) ;
     @AXC_SetMode := LoadProcedure( Axoclamp900ALibHnd, '_AXC_SetMode@16' ) ;
     @AXC_BuildErrorText := LoadProcedure( Axoclamp900ALibHnd, 'AXC_BuildErrorText' ) ;
     @AXC_GetSignalScaleFactor := LoadProcedure( Axoclamp900ALibHnd, '_AXC_GetSignalScaleFactor@16' ) ;
     @AXC_GetHeadstageType := LoadProcedure( Axoclamp900ALibHnd, '_AXC_GetHeadstageType@20' ) ;

     DemoMode := TRue ;
     Err := 0 ;
     Axoclamp900AHnd := AXC_CreateHandle( DemoMode, Err ) ;
     AXC_FindFirstDevice( Axoclamp900AHnd, SerialNum, High(SerialNum), Err ) ;
     if Err <> 0 then begin
        ShowMessage('ERROR! Unable to find Axoclamp 900A') ;
        end ;
//     CheckErrorAxoclamp900A(Err) ;

     if Err = 0 then begin
        AXC_OpenDevice( Axoclamp900AHnd, SerialNum, True, Err ) ;
        if Err <> 0 then begin
           ShowMessage('ERROR! Unable to open Axoclamp 900A') ;
           end ;
        end ;

     //CheckErrorAxoclamp900A(Err) ;


{     const UINT AXC_MODE_IZERO             = 0;
const UINT AXC_MODE_ICLAMP            = 1;
const UINT AXC_MODE_DCC               = 2;
const UINT AXC_MODE_HVIC              = 3;
const UINT AXC_MODE_DSEVC             = 4;
const UINT AXC_MODE_TEVC              = 5;
const UINT AXC_MAX_MODES              = 6;

const UINT AXC_MODE_NONE              = 6;
const UINT AXC_MODE_ALL               = 7;

     AXC_SetMode( Axoclamp900AHnd, 0, 2, Err ) ;
     AXC_SetScaledOutputSignal( Axoclamp900AHnd, AXC_SIGNAL_ID_I2, 0, AXC_MODE_ICLAMP, Err ) ;
     AXC_SetScaledOutputGain( Axoclamp900AHnd, 1.0, 0, 2, Err ) ;
     AXC_SetScaledOutputSignal( Axoclamp900AHnd, AXC_SIGNAL_ID_10V1, 1, AXC_MODE_ICLAMP, Err ) ;
     AXC_SetScaledOutputGain( Axoclamp900AHnd, 2.0, 1, 2, Err ) ; }

     //CheckErrorAxoclamp900A(Err) ;

     Axoclamp900AOpen := True ;

     end ;

procedure TAmplifier.CloseAxoclamp900A ;
// --------------------
// Close Axoclamp 900A
// --------------------
var

    Err : Integer ;
begin

    if Axoclamp900AOpen then begin
       AXC_CloseDevice( Axoclamp900AHnd, Err ) ;
       CheckErrorAxoclamp900A(Err) ;
       AXC_DestroyHandle(Axoclamp900AHnd) ;
       Axoclamp900AHnd := -1 ;
       Axoclamp900AOpen := False ;
       end ;

    if Axoclamp900ALibLoaded then begin
       FreeLibrary( Axoclamp900ALibHnd ) ;
       FreeLibrary( Axoclamp900AHIDHnd ) ;
       Axoclamp900ALibLoaded := False ;
       end ;

    end ;


function TAmplifier.GetTelegraphVoltage(
         ChannelNum : Integer
          ) : Single ;
// -----------------------------------
// Read voltage from telegraph channel
// -----------------------------------
var
   OldIndex : Integer ;
   ADCValue : SmallInt ;
begin

    if (ChannelNum < 0) or (ChannelNum >= Main.SESLabIO.ADCMaxChannels) then begin
       Result := 0.0 ;
       Exit ;
       end ;

    // Keep existing A/D input voltage range
    OldIndex := Main.SESLabIO.ADCVoltageRangeIndex ;

    // Set to minimum range
    Main.SESLabIO.ADCVoltageRangeIndex := 0 ;

    // Measure voltage on telegraph channel
    ADCValue := Main.SESLabIO.ReadADC( ChannelNum ) ;
    Result := (ADCValue/Main.SESLabIO.ADCMaxValue)*Main.SESLabIO.ADCVoltageRange ;

    Main.SESLabIO.ADCVoltageRangeIndex := OldIndex ;

    end ;


function TAmplifier.ADCInUse : Boolean ;
// ------------------------------------
// Check if A/D sampling is in progress
// ------------------------------------
begin
     Result := Main.SESLabIO.ADCActive ;
     end ;


procedure TAmplifier.CheckErrorAxoclamp900A(
          Err : Integer
          ) ;
// -------------
// Report error
// -------------
var
    ErrText : Array[0..255] of ANSIChar ;
begin
     if Err <> 0 then begin
        AXC_BuildErrorText( Axoclamp900AHnd, Err, ErrText, High(ErrText)) ;
        ShowMessage(ErrText) ;
        end ;
     end ;


function TAmplifier.GetNPIELC03SXGain(
         AmpNumber : Integer ;
         TelChan : Integer ) : single ;
// ---------------------------------------------
// Decode NPI ELC03SX gain from telegraph output
// ---------------------------------------------
const
     NumGains = 7 ;
     VGainSpacing = 1.0 ;
     VStart = 1.0 ;
var
   Gains : Array[0..NumGains-1] of single ;
   V : single ;
   iGain : Integer ;
begin

     // Note. Don't interrupt A/D sampling if it in progress.
     // Use most recent gain setting instead

    if (TelChan >= 0) and (TelChan < Main.SESLabIO.ADCMaxChannels) and
       (not ADCInUse) then begin

        // Gain settings
        Gains[0] := 1.0 ;
        Gains[1] := 2.0 ;
        Gains[2] := 5.0 ;
        Gains[3] := 10.0 ;
        Gains[4] := 20.0 ;
        Gains[5] := 50.0 ;
        Gains[6] := 100.0 ;

        // Get voltage from telegraph channel
        V := GetTelegraphVoltage( TelChan ) ;

        // Extract gain associated with telegraph voltage
        iGain := Trunc( (V - VStart + 0.1)/VGainSpacing ) ;
        iGain := Max(Min(iGain,NumGains-1),0);

        LastGain[AmpNumber] := Gains[iGain] ;

        end ;

     Result := LastGain[AmpNumber] ;
     end ;


procedure TAmplifier.GetNPIELC03SXChannelSettings(
          iChan : Integer ;
          var ChanName : String ;
          var ChanUnits : String ;
          var ChanCalFactor : single ;
          var ChanScale : Single
          ) ;
// -----------------------------------
// Get NPI ELC03SX channel settings
// -----------------------------------
var
   AmpNumber : Integer ;
begin

    AmpNumber := AmpNumberOfChannel(iChan) ;
    if AmpNumber >= MaxAmplifiers then Exit ;

    if IsPrimaryChannel(iChan)then begin
       ChanName := 'Im' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FPrimaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetGainTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetNPIELC03SXGain( AmpNumber, FGainTelegraphChannel[AmpNumber] ) ;
          FPrimaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FPrimaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end
    else if IsSecondaryChannel(iChan) then begin
       ChanName := 'Vm' ;
       AddAmplifierNumber( ChanName, iChan ) ;
       ChanUnits := FSecondaryChannelUnits[AmpNumber] ;
       ChanCalFactor := FPrimaryChannelScaleFactorX1Gain[AmpNumber] ;
       if GetModeTelegraphAvailable(AmpNumber) then begin
          ChanScale := GetNPIELC03SXGain( AmpNumber, FModeTelegraphChannel[AmpNumber] ) ;
          FSecondaryChannelScaleFactor[AmpNumber] := ChanCalFactor*ChanScale ;
          end
       else begin
          ChanScale := FSecondaryChannelScaleFactor[AmpNumber]/ ChanCalFactor ;
          end ;
       end ;

    end ;




// *** CED 1902 Amplifier methods ***

procedure TAmplifier.TransmitLine(
          const Line : string   { Text to be sent to Com port }
          ) ;
{ --------------------------------------
  Write a line of ASCII text to Com port
  --------------------------------------}
var
   i,nC : Integer ;
   nWritten : DWORD ;
   xBuf : array[0..258] of ANSIchar ;
   Overlapped : Pointer ; //POverlapped ;
   OK : Boolean ;
begin
     { Copy command line to be sent to xMit buffer and and a CR character }
     nC := Length(Line) ;
     for i := 1 to nC do xBuf[i-1] := ANSIChar(Line[i]) ;
     xBuf[nC] := #13 ;
     Inc(nC) ;

    Overlapped := Nil ;
    OK := WriteFile( CED1902.ComHandle, xBuf, nC, nWritten, Overlapped ) ;
    if (not OK) or (nWRitten <> nC) then
        ShowMessage( ' Error writing to COM port ' ) ;
     end ;


function TAmplifier.Check1902Error : string ;         { Error flag returned  }
{ --------------------------------------
  Retrieve error information from 1902
  --------------------------------------}
var
   i,nC : Integer ;
   xBuf : array[0..258] of ANSIchar ;
   Line : string ;
begin


     Line := '?ER;' ;
     nC := Length(Line) ;
     for i := 1 to nC do xBuf[i-1] := ANSIChar(Line[i]) ;
     xBuf[nC] := #13 ;
     Inc(nC) ;
     if FileWrite( CED1902.ComHandle, xBuf, nC ) = nC then begin
        Result := ReceiveLine ;
        end
     else begin
        Result := ' Error writing to COM port ' ;
        end ;
     end ;


function TAmplifier.ReceiveLine : string ;          { Return line of bytes received }
{ -------------------------------------------------------
  Read bytes from Com port until a line has been received
  -------------------------------------------------------}
const
     TimeOut = 500 ;
var
   Line : string ;
   rBuf : array[0..1] of ANSIchar ;
   ComState : TComStat ;
   PComState : PComStat ;
   TimeOutTickCount : LongInt ;
   ComError,NumBytesRead : DWORD ;
   //OverLapStructure : POVERLAPPED ;
begin
     { Set time that ReceiveLine will give up at if a full line has not
       been received }
     TimeOutTickCount := GetTickCount + TimeOut ;

     PComState := @ComState ;
     Line := '' ;
     repeat
        rBuf[0] := ' ' ;
        { Find out if there are any characters in receive buffer }
        ClearCommError( CED1902.ComHandle, ComError, PComState )  ;
        NumBytesRead := 0 ;
        if ComState.cbInQue > 0 then begin
           ReadFile( CED1902.ComHandle,
                     rBuf,
                     1,
                     NumBytesRead,
                     CED1902.OverlapStructure ) ;
           end ;

        if NumBytesRead > 0 then begin
           if (rBuf[0] <> #13) and (rBuf[0]<>chr(10)) then
              Line := Line + rBuf[0] ;
           end ;
        until (rBuf[0] = #13) or (GetTickCount >= TimeOutTickCount) ;
     Result := Line ;
     end ;


procedure TAmplifier.SetCED1902 ;
{ ---------------------------------------------------
  Transmit gain/filter settings to CED 1902 amplifier
  ---------------------------------------------------}
var
   OK : Boolean ;
   Status : String ;
   GainList : TStringList ;
begin

     //   Ensure CED 1902 COM link is open
     if CED1902.ComHandle < 0 then OK := Amplifier.OpenCED1902
                              else OK := True ;

     // If open successful, send commands
     if OK then begin
        TransmitLine( format('IP%d;',[CED1902.Input]));
        Status := QueryCED1902('?IP') ;
        TransmitLine( format('GN%d;',[CED1902.Gain]));
        Status := QueryCED1902('?GN') ;
        TransmitLine( format('LP%d;',[CED1902.LPFilter]));
        Status := QueryCED1902('?LP') ;
        TransmitLine( format('HP%d;',[CED1902.HPFilter]));
        Status := QueryCED1902('?HP') ;
        TransmitLine( format('AC%d;',[CED1902.ACCoupled]));
        Status := QueryCED1902('?AC') ;
        TransmitLine( format('NF%d;',[CED1902.NotchFilter]));
        Status := QueryCED1902('?NF') ;

        { Set DC Offset }
        TransmitLine( 'OR1;' );
        TransmitLine( format('OF%d;',[CED1902.DCOffset]));
        Status := QueryCED1902('?OF') ;
        TransmitLine( 'OR1;') ;
        TransmitLine( format('OF%d;',[CED1902.DCOffset]));
        Status := QueryCED1902('?OF') ;

        GainList := TStringList.Create ;
        GetCED1902List( '?GS;', GainList ) ;
        // Gain value
        if GainList.Count >= CED1902.Gain then begin
           CED1902.GainValue := ExtractFloat( GainList[CED1902.Gain-1],
                                              CED1902.GainValue ) ;
           end ;
        GainList.Free ;

        CloseCED1902 ;

        CED1902.AmplifierSet := True ;

        end ;
     end ;


function TAmplifier.OpenCED1902 ;
// ---------------------------------------------------
// Establish communications with CED 1902 via COM port
// ---------------------------------------------------
var
   DCB : TDCB ;           { Device control block for COM port }
   CommTimeouts : TCommTimeouts ;
begin

     if CED1902.ComPort <= 1 then CED1902.ComPort := 1 ;
     if CED1902.ComPort >= 2 then CED1902.ComPort := 2 ;

     { Open com port  }
     CED1902.ComHandle :=  CreateFile( PCHar(format('COM%d',[CED1902.ComPort])),
                                       GENERIC_READ or GENERIC_WRITE,
                                       0,
                                       Nil,
                                       OPEN_EXISTING,
                                       FILE_ATTRIBUTE_NORMAL,
                                       0) ;

     if CED1902.ComHandle >= 0 then begin

        { Get current state of COM port and fill device control block }
        GetCommState( CED1902.ComHandle, DCB ) ;
        { Change settings to those required for 1902 }
        DCB.BaudRate := CBR_9600 ;
        DCB.ByteSize := 7 ;
        DCB.Parity := EVENPARITY ;
        DCB.StopBits := ONESTOPBIT ;

        { Update COM port }
        SetCommState( CED1902.ComHandle, DCB ) ;

        { Initialise Com port and set size of transmit/receive buffers }
        SetupComm( CED1902.ComHandle, 4096, 4096 ) ;
        { Set Com port timeouts }
        GetCommTimeouts( CED1902.ComHandle, CommTimeouts ) ;

        CommTimeouts.ReadIntervalTimeout := $FFFFFFFF ;
        CommTimeouts.ReadTotalTimeoutMultiplier := 0 ;
        CommTimeouts.ReadTotalTimeoutConstant := 0 ;
        CommTimeouts.WriteTotalTimeoutMultiplier := 0 ;
        CommTimeouts.WriteTotalTimeoutConstant := 5000 ;
        SetCommTimeouts( CED1902.ComHandle, CommTimeouts ) ;
        Result := True ;
        end
     Else Result := False ;
     end ;


procedure TAmplifier.CloseCED1902 ;
//
// Close serial COM link to CED 1902
//
begin
//   Ensure CED 1902 COM link is open
     if CED1902.ComHandle >= 0 then CloseHandle( CED1902.ComHandle ) ;
     CED1902.ComHandle := -1 ;
     end ;


 function TAmplifier.GetCED1902DCOffsetRange : single ;
 begin
      if CED1902.Input = 1 then GetCED1902DCOffsetRange := 0.0005
      else if CED1902.Input = 2 then GetCED1902DCOffsetRange := 0.5
      else if CED1902.Input = 3 then GetCED1902DCOffsetRange := 0.0005
      else if CED1902.Input = 4 then GetCED1902DCOffsetRange := 0.0005
      else if CED1902.Input = 5 then GetCED1902DCOffsetRange := 0.0001
      else GetCED1902DCOffsetRange := 0.0001 ;
      end ;


procedure TAmplifier.GetCED1902List(
           Command : string ;       { Command requesting list }
           List : TStrings   { List of strings returned from 1902 }
           ) ;
var
   NumItems,i : Integer ;
   IOBuf : string ;
begin

//   Ensure CED 1902 COM link is open
     if CED1902.ComHandle < 0 then Amplifier.OpenCED1902 ;

     { Request list of gains }
     TransmitLine( Command ) ;
     IOBuf := ReceiveLine ;
     if IOBuf = '' then begin
        TransmitLine( Command ) ;
        IOBuf := ReceiveLine ;
        end ;
     { Read  list back from 1902 }

     NumItems := ExtractInt( IOBuf ) ;
     //List.Clear ;
     for i := 0 to NumItems-1 do begin
         List.Add( ReceiveLine ) ;
         end ;

     end ;


function TAmplifier.QueryCED1902(
         Request : string         { Request 1902 command string }
         ) : string ;
// ---------------------------------
// Request information from CED 1902
// ---------------------------------
var
   IOBuf : string ;
begin

//   Ensure CED 1902 COM link is open
     if CED1902.ComHandle < 0 then Amplifier.OpenCED1902 ;

     IOBuf := '' ;

     { Request information }
     TransmitLine( Request ) ;

     // Wait for it to come back
     IOBuf := ReceiveLine ;
     if IOBuf = '' then begin
        TransmitLine( Request ) ;
        IOBuf := ReceiveLine ;
        end ;
     Result := IOBuf ;

     end ;


procedure TAmplifier.DataModuleDestroy(Sender: TObject);
// -------------------------------------
// Tidy up when data module is destroyed
// -------------------------------------
var
    i : Cardinal ;
begin

    // Save amplifier settings
    SaveToXMLFile( SettingsFileName, False ) ;

    // Close an open Multiclamp 700 telegraph connection
    if MCConnectionOpen then begin
       if MCNumChannels > 0 then begin
       for i := 0 to MCNumChannels-1 do begin
           if not PostMessage( HWND_BROADCAST, MCCloseMessageID, Application.Handle, MCChannels[i] )
           then ShowMessage( 'Multi-Clamp Commander(Failed to close channel)' ) ;

           end ;
       end ;
       MCConnectionOpen := False ;
       end ;

    // Un-hook special message handle
    Application.UnHookMainWindow(AppHookFunc);

    // Close axoclamp 900A (if it is open)
    CloseAxoclamp900A ;

    end;

function TAmplifier.LoadProcedure(
         Hnd : THandle ;       { Library DLL handle }
         Name : string         { Procedure name within DLL }
         ) : Pointer ;         { Return pointer to procedure }
var
   P : Pointer ;

begin
     P := GetProcAddress(Hnd,PChar(Name)) ;
     if {Integer(P) = Null} P = Nil then begin
        SHowMessage(format('DLL- %s not found',[Name])) ;
        end ;
     Result := P ;
     end ;


procedure TAmplifier.ResetMultiClamp700 ;
// ---------------------------------------------------------------------------------
// Close Multiclamp 700A/B which forces the communications link to be resestablished
// ---------------------------------------------------------------------------------
var
    i : Cardinal ;
begin
    // Close an open Multiclamp 700 telegraph connection
    if MCConnectionOpen then begin
       if MCNumChannels > 0 then begin
       for i := 0 to MCNumChannels-1 do begin
           if not PostMessage( HWND_BROADCAST, MCCloseMessageID, Application.Handle, MCChannels[i] )
           then ShowMessage( 'Multi-Clamp Commander(Failed to close channel)' ) ;
           WriteToLogFile( format('Multiclamp: Channel %x closed.',[MCChannels[i]]) ) ;
           end ;
       end ;
       MCConnectionOpen := False ;
       end ;
    end ;


function TAmplifier.SettingsFileExists : Boolean ;
// ------------------------------------------
// Return TRUE if an XML settings file exists
// ------------------------------------------
begin
    Result := FileExists( SettingsFileName ) ;
    end ;


procedure TAmplifier.SaveToXMLFile(
          FileName : String ;       // File to save to
          AppendData : Boolean      // Add XML data to end of file if TRUE
          ) ;
// ----------------------------------
// Save amplifier settings to XML file
// ----------------------------------
begin
    CoInitialize(Nil) ;
    SaveToXMLFile1( FileName,AppendData ) ;
    CoUnInitialize ;
    end ;


procedure TAmplifier.SaveToXMLFile1(
          FileName : String ;       // File to save to
          AppendData : Boolean      // Add XML data to end of file if TRUE
          ) ;
// ---------------------------------------------------------
// Save amplifier settings to XML file  (after coinitialize)
// ---------------------------------------------------------
var
   iNode,ProtNode : IXMLNode;
   i : Integer ;
   s : TStringList ;
   XMLDoc : IXMLDocument ;
begin

    XMLDoc := TXMLDocument.Create(Self);
    XMLDoc.Active := True ;

    // Clear document
    XMLDoc.ChildNodes.Clear ;

    // Add record name
    ProtNode := XMLDoc.AddChild( 'AMPLIFIERSETTINGS' ) ;

    // Amplifiers
    for i := 0 to MaxAmplifiers-1 do begin
        iNode := ProtNode.AddChild( 'AMPLIFIER' ) ;
        AddElementInt( iNode, 'NUMBER', i ) ;
        AddElementInt( iNode, 'AMPTYPE', FAmpType[i] ) ;
        AddElementBool( iNode, 'GAINTELEGRAPHAVAILABLE', FGainTelegraphAvailable[i] ) ;
        AddElementBool( iNode, 'NEEDSGAINTELEGRAPHCHANNEL', FNeedsGainTelegraphChannel[i] ) ;
        AddElementInt( iNode, 'GAINTELEGRAPHCHANNEL', FGainTelegraphChannel[i] ) ;
        AddElementBool( iNode, 'MODETELEGRAPHAVAILABLE', FModeTelegraphAvailable[i] ) ;
        AddElementBool( iNode, 'NEEDSMODETELEGRAPHCHANNEL', FNeedsModeTelegraphChannel[i] ) ;
        AddElementInt( iNode, 'MODETELEGRAPHCHANNEL', FModeTelegraphChannel[i] ) ;
        AddElementBool( iNode, 'MODESWITCHEDPRIMARYCHANNEL', FModeSwitchedPrimaryChannel[i] ) ;
        AddElementText( iNode, 'PRIMARYOUTPUTCHANNELNAME', FPrimaryOutputChannelName[i] ) ;
        AddElementText( iNode, 'PRIMARYOUTPUTCHANNELNAMECC', FPrimaryOutputChannelNameCC[i] ) ;
        AddElementInt( iNode, 'PRIMARYOUTPUTCHANNEL', FPrimaryOutputChannel[i] ) ;
        AddElementText( iNode, 'SECONDARYOUTPUTCHANNELNAME', FSecondaryOutputChannelName[i] ) ;
        AddElementText( iNode, 'SECONDARYOUTPUTCHANNELNAMECC', FSecondaryOutputChannelNameCC[i] ) ;
        AddElementInt( iNode, 'SECONDARYOUTPUTCHANNEL', FSecondaryOutputChannel[i] ) ;

        AddElementFloat( iNode, 'PRIMARYCHANNELSCALEFACTORX1GAIN', FPrimaryChannelScaleFactorX1Gain[i] ) ;
        AddElementFloat( iNode, 'PRIMARYCHANNELSCALEFACTORX1GAINCC', FPrimaryChannelScaleFactorX1GainCC[i] ) ;
        AddElementFloat( iNode, 'PRIMARYCHANNELSCALEFACTOR', FPrimaryChannelScaleFactor[i] ) ;

        AddElementText( iNode, 'PRIMARYCHANNELUNITS', FPrimaryChannelUnits[i] ) ;
        AddElementText( iNode, 'PRIMARYCHANNELUNITSCC', FPrimaryChannelUnitsCC[i] ) ;
        AddElementFloat( iNode, 'SECONDARYCHANNELSCALEFACTORX1GAIN', FSecondaryChannelScaleFactorX1Gain[i] ) ;
        AddElementFloat( iNode, 'SECONDARYCHANNELSCALEFACTORX1GAINCC', FSecondaryChannelScaleFactorX1GainCC[i] ) ;
        AddElementFloat( iNode, 'SECONDARYCHANNELSCALEFACTORX1', FSecondaryChannelScaleFactor[i] ) ;
        AddElementText( iNode, 'SECONDARYCHANNELUNITS', FSecondaryChannelUnits[i] ) ;
        AddElementText( iNode, 'SECONDARYCHANNELUNITSCC', FSecondaryChannelUnitsCC[i] ) ;

        AddElementFloat( iNode, 'VOLTAGECOMMANDSCALEFACTOR', FVoltageCommandScaleFactor[i] ) ;
        AddElementInt( iNode, 'VOLTAGECOMMANDCHANNEL', FVoltageCommandChannel[i] ) ;
        AddElementFloat( iNode, 'CURRENTCOMMANDSCALEFACTOR', FCurrentCommandScaleFactor[i] ) ;
        AddElementInt( iNode, 'CURRENTCOMMANDCHANNEL', FCurrentCommandChannel[i] ) ;

        end ;

     s := TStringList.Create;
     if not AppendData then begin
        // Save XML data to file
        s.Assign(xmlDoc.XML) ;
     //sl.Insert(0,'<!DOCTYPE ns:mys SYSTEM "myXML.dtd">') ;
        s.Insert(0,'<?xml version="1.0"?>') ;
        s.SaveToFile( FileName ) ;
        end
     else begin
        // Append to existing XML file
        s.LoadFromFile(FileName);
        for i := 0 to xmlDoc.XML.Count-1 do begin
             s.Add(xmlDoc.XML.Strings[i]) ;
             end ;
        s.SaveToFile( FileName ) ;
        end ;
     s.Free ;

     XMLDoc.Active := False ;
     XMLDoc := Nil ;

    end ;


procedure TAmplifier.LoadFromXMLFile(
          FileName : String                    // XML protocol file
          ) ;
// ----------------------------------
// Load settings from XML file
// ----------------------------------
begin
    CoInitialize(Nil) ;
    LoadFromXMLFile1( FileName ) ;
    CoUnInitialize ;
    end ;


procedure TAmplifier.LoadFromXMLFile1(
          FileName : String                    // XML protocol file
          ) ;
// --------------------------------------
// Load settings from XML file (after coinitialize)
// --------------------------------------
var
   iNode,ProtNode : IXMLNode;
   i : Integer ;
   NodeIndex : Integer ;
   XMLDoc : TXMLDocument ;

begin

    XMLDoc := TXMLDocument.Create(Self) ;

    XMLDOC.Active := False ;

    XMLDOC.LoadFromFile( FileName ) ;
    XMLDoc.Active := True ;

//    for i := 0 to  xmldoc.DocumentElement.ChildNodes.Count-1 do
//        OutputDebugString( PChar(String(xmldoc.DocumentElement.ChildNodes[i].NodeName))) ;

    // <AMPLIFIERSETTINGS> is not the root node, search for it
    if xmldoc.DocumentElement.NodeName = 'AMPLIFIERSETTINGS' then begin
       ProtNode := xmldoc.DocumentElement ;
       end
    else begin
       NodeIndex := 0 ;
       FindXMLNode(xmldoc.DocumentElement,'AMPLIFIERSETTINGS',ProtNode,NodeIndex);
       end ;

    // Amplifiers
    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'AMPLIFIER',iNode,NodeIndex) do begin
        GetElementInt( iNode, 'NUMBER', i ) ;
        if (i >= 0) and (i < MaxAmplifiers) then begin
           GetElementInt( iNode, 'AMPTYPE', FAmpType[i] ) ;
           GetElementBool( iNode, 'GAINTELEGRAPHAVAILABLE', FGainTelegraphAvailable[i] ) ;
           GetElementBool( iNode, 'NEEDSGAINTELEGRAPHCHANNEL', FNeedsGainTelegraphChannel[i] ) ;
           GetElementInt( iNode, 'GAINTELEGRAPHCHANNEL', FGainTelegraphChannel[i] ) ;
           GetElementBool( iNode, 'MODETELEGRAPHAVAILABLE', FModeTelegraphAvailable[i] ) ;
           GetElementBool( iNode, 'NEEDSMODETELEGRAPHCHANNEL', FNeedsModeTelegraphChannel[i] ) ;
           GetElementInt( iNode, 'MODETELEGRAPHCHANNEL', FModeTelegraphChannel[i] ) ;
           GetElementBool( iNode, 'MODESWITCHEDPRIMARYCHANNEL', FModeSwitchedPrimaryChannel[i] ) ;

           GetElementText( iNode, 'PRIMARYOUTPUTCHANNELNAME', FPrimaryOutputChannelName[i] ) ;
           GetElementText( iNode, 'PRIMARYOUTPUTCHANNELNAMECC', FPrimaryOutputChannelNameCC[i] ) ;
           GetElementInt( iNode, 'PRIMARYOUTPUTCHANNEL', FPrimaryOutputChannel[i] ) ;
           GetElementText( iNode, 'SECONDARYOUTPUTCHANNELNAME', FSecondaryOutputChannelName[i] ) ;
           GetElementText( iNode, 'SECONDARYOUTPUTCHANNELNAMECC', FSecondaryOutputChannelNameCC[i] ) ;
           GetElementInt( iNode, 'SECONDARYOUTPUTCHANNEL', FSecondaryOutputChannel[i] ) ;

           GetElementFloat( iNode, 'PRIMARYCHANNELSCALEFACTORX1GAIN', FPrimaryChannelScaleFactorX1Gain[i] ) ;
           GetElementFloat( iNode, 'PRIMARYCHANNELSCALEFACTORX1GAINCC', FPrimaryChannelScaleFactorX1GainCC[i] ) ;
           GetElementFloat( iNode, 'PRIMARYCHANNELSCALEFACTOR', FPrimaryChannelScaleFactor[i] ) ;
           GetElementText( iNode, 'PRIMARYCHANNELUNITS', FPrimaryChannelUnits[i] ) ;
           GetElementText( iNode, 'PRIMARYCHANNELUNITSCC', FPrimaryChannelUnitsCC[i] ) ;

           GetElementFloat( iNode, 'SECONDARYCHANNELSCALEFACTORX1GAIN', FSecondaryChannelScaleFactorX1Gain[i] ) ;
           GetElementFloat( iNode, 'SECONDARYCHANNELSCALEFACTORX1GAINCC', FSecondaryChannelScaleFactorX1GainCC[i] ) ;
           GetElementFloat( iNode, 'SECONDARYCHANNELSCALEFACTORX1', FSecondaryChannelScaleFactor[i] ) ;
           GetElementText( iNode, 'SECONDARYCHANNELUNITS', FSecondaryChannelUnits[i] ) ;
           GetElementText( iNode, 'SECONDARYCHANNELUNITSCC', FSecondaryChannelUnitsCC[i] ) ;

           GetElementFloat( iNode, 'VOLTAGECOMMANDSCALEFACTOR', FVoltageCommandScaleFactor[i] ) ;
           GetElementInt( iNode, 'VOLTAGECOMMANDCHANNEL', FVoltageCommandChannel[i] ) ;
           GetElementFloat( iNode, 'CURRENTCOMMANDSCALEFACTOR', FCurrentCommandScaleFactor[i] ) ;
           GetElementInt( iNode, 'CURRENTCOMMANDCHANNEL', FCurrentCommandChannel[i] ) ;
           end ;
        Inc(NodeIndex) ;
        end ;

    XMLDoc.Active := False ;
    XMLDoc.Free ;

    end ;

procedure TAmplifier.AddElementFloat(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Single
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := format('%.10g',[Value]) ;

    end ;


function TAmplifier.GetElementFloat(
         ParentNode : IXMLNode ;
         NodeName : String ;
         var Value : Single
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   OldValue : Single ;
   NodeIndex : Integer ;
   s,dsep : string ;
begin
    Result := False ;
    OldValue := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       // Correct for use of comma/period as decimal separator }
       s := ChildNode.Text ;
       { Correct for use of comma/period as decimal separator }
       {$IF CompilerVersion > 7.0} dsep := formatsettings.DECIMALSEPARATOR ;
       {$ELSE} dsep := DECIMALSEPARATOR ;
       {$IFEND}
       if dsep = '.' then s := ANSIReplaceText(s ,',',dsep);
       if dsep = ',' then s := ANSIReplaceText(s, '.',dsep);

       try
          Value := StrToFloat(s) ;
          Result := True ;
       except
          Value := OldValue ;
          Result := False ;
          end ;
       end ;

    end ;


procedure TAmplifier.AddElementInt(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Integer
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := format('%d',[Value]) ;

    end ;


function TAmplifier.GetElementInt(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : Integer
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
   OldValue : Integer ;
begin
    Result := False ;
    OldValue := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       try
          Value := StrToInt(ChildNode.Text) ;
          Result := True ;
       except
          Value := OldValue ;
          Result := False ;
          end ;
       end ;
    end ;


procedure TAmplifier.AddElementBool(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Boolean
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    if Value = True then ChildNode.Text := 'T'
                    else ChildNode.Text := 'F' ;

    end ;


function TAmplifier.GetElementBool(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : Boolean
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
begin
    Result := False ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       if ANSIContainsText(ChildNode.Text,'T') then Value := True
                                               else  Value := False ;
       Result := True ;
       end ;

    end ;


procedure TAmplifier.AddElementText(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : String
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := Value ;

    end ;


function TAmplifier.GetElementText(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : String
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
begin

    Result := False ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       Value := ChildNode.Text ;
       Result := True ;
       end ;

    end ;


function TAmplifier.FindXMLNode(
         const ParentNode : IXMLNode ;  // Node to be searched
         NodeName : String ;            // Element name to be found
         var ChildNode : IXMLNode ;     // Child Node of found element
         var NodeIndex : Integer        // ParentNode.ChildNodes Index #
                                        // Starting index on entry, found index on exit
         ) : Boolean ;
// -------------
// Find XML node
// -------------
var
    i : Integer ;
begin

    Result := False ;
    for i := NodeIndex to ParentNode.ChildNodes.Count-1 do begin
      if ParentNode.ChildNodes[i].NodeName = WideString(NodeName) then begin
         Result := True ;
         ChildNode := ParentNode.ChildNodes[i] ;
         NodeIndex := i ;
         Break ;
         end ;
      end ;
    end ;

function TAmplifier.AppHookFunc(var Message : TMessage)  : Boolean;
// ---------------
// Message handler
// ---------------
var
    AddChannel : Boolean ;
    TData : TMC_TELEGRAPH_DATA ;
    i,Err,iChan : Integer ;
    SerialNum,MaxSerialNum,MinSerialNum,SN : Cardinal ;
    MaxComPortID,MinComPortID,ComPortID : Cardinal ;
begin
  Result := False; //I just do this by default

   // MultiClamp settings message
   if Message.Msg = WM_COPYDATA then begin

      if ((PCopyDataStruct(Message.lParam)^.cbData = 128) or
          (PCopyDataStruct(Message.lParam)^.cbData = 256)) and
         (PCopyDataStruct(Message.lParam)^.dwData = MCRequestMessageID) then begin
         // Copy telegraph data into record
         TData := PMC_TELEGRAPH_DATA(PCopyDataStruct(Message.lParam)^.lpData)^ ;
         if TData.Version < 6 then begin
            // API V1.x (Multiclamp 700A)
            // Assign channel based upon COM port # and channelID
            MaxComPortID := 0 ;
            MinComPortID := High(MinComPortID) ;
            for i  := 0 to MCNumChannels-1 do begin
                ComPortID := MCChannels[i] and $FFFF ;
                if ComPortID > MaxComPortID then MaxComPortID := ComPortID ;
                if ComPortID < MinComPortID then MinComPortID := ComPortID ;
                end ;
            if TData.ComPortID = MinComPortID then iChan := TData.ChannelID -1
                                              else iChan := TData.ChannelID +1 ;
            iChan := Min(Max(iChan,0),3);
            WriteToLogFile(format(
            'Multiclamp V1.1: Message received from ComPortID=%d ChannelID=%d as Amplifier #%d',
            [TData.ComPortID,TData.ChannelID,iChan+1]));
            end
         else begin
            // API V2.x (Multiclamp 700B)
            // Assign channel based upon Device serial number and ChannelID
            Val( ANSIString(TData.SerialNumber), SerialNum, Err ) ;
            if Err <> 0 then SerialNum := MCChannels[0] and $FFFFFFF ;
            MaxSerialNum := 0 ;
            MinSerialNum := High(MinSerialNum) ;
            for i  := 0 to MCNumChannels-1 do begin
                SN := MCChannels[i] and $FFFFFFF ;
                if SN > MaxSerialNum then MaxSerialNum := SN ;
                if SN < MinSerialNum then MinSerialNum := SN ;
                end ;
            if SerialNum = MinSerialNum then iChan := TData.ChannelID -1
                                        else iChan := TData.ChannelID +1 ;
            iChan := Min(Max(iChan,0),3);
             WriteToLogFile(format(
             'Multiclamp V2.x: Message received from Device=%s  ChannelID=%d as Amplifier #%d',
             [ANSIString(TData.SerialNumber),TData.ChannelID,iChan+1]));
            end ;
         MCTelegraphData[iChan] := TData ;
         Result := True ;
         end ;
      end ;

    // MultiClamp server responses to broadcast identification request
    if (Message.Msg = MCIDMessageID) or (Message.Msg = MCReconnectMessageID) then begin
         AddChannel := True ;
         for i := 0 to MCNumChannels-1 do if MCChannels[i] = Message.lParam then AddChannel := False ;
         WriteToLogFile(format('Multiclamp: Channel detected ID=%x',[Message.lParam]));

         if AddChannel then begin
             // Store server device/channel ID in list
             MCChannels[MCNumChannels] := Message.lParam ;
             // Open connection to this device/channel
             if not PostMessage(HWND_BROADCAST,MCOpenMessageID,Application.Handle,MCChannels[MCNumChannels] ) then
                ShowMessage( 'MultiClamp Commander (Open Message Failed)' ) ;
             Main.StatusBar.SimpleText := format('Multiclamp: MCOpenMessageID broadcast to channel %x',
             [MCChannels[MCNumChannels]]) ;
             WriteToLogFile(Main.StatusBar.SimpleText) ;
             Inc(MCNumChannels) ;
             end ;
         Result := True ;
         end ;

    end;

procedure TAmplifier.SetGainTelegraphChannel(
          AmpNumber : Integer ;
          Value : Integer ) ;
// -----------------------
// Set Gain telegraph channel #
// -----------------------
begin
    FGainTelegraphChannel[AmpNumber] := Value ;
    end ;


function  TAmplifier.GetGainTelegraphChannel(
          AmpNumber : Integer
          ) : Integer  ;
// -----------------------
// Get gain telegraph channel #
// -----------------------
begin
     Result :=  FGainTelegraphChannel[AmpNumber] ;
     end ;


procedure TAmplifier.SetModeTelegraphChannel(
          AmpNumber : Integer ;
          Value : Integer ) ;
// -----------------------
// Set Mode telegraph channel #
// -----------------------
begin
    FModeTelegraphChannel[AmpNumber] := Value ;
    end ;


function  TAmplifier.GetModeTelegraphChannel(
          AmpNumber : Integer )
           : Integer  ;
// -----------------------
// Get Mode telegraph channel #
// -----------------------
begin
     Result :=  FModeTelegraphChannel[AmpNumber] ;
     end ;


function  TAmplifier.GetPrimaryOutputChannel(
          AmpNumber : Integer )
           : Integer  ;
// ---------------------------
// Get primary outputchannel #
// ---------------------------
begin
     if (AmpNumber >= 0) and (AmpNumber <= MaxAmplifiers) then  begin
        Result := FPrimaryOutputChannel[AmpNumber] ;
        end
     else Result := 0 ;
     end ;

function  TAmplifier.GetPrimaryOutputChannelName(
          AmpNumber : Integer ;
          ClampMode : Integer )
           : String  ;
// ---------------------------
// Get primary output channel name
// ---------------------------
begin

     if (AmpNumber >= 0) and (AmpNumber <= MaxAmplifiers) then  begin
        if ClampMode = VClampMode then Result := FPrimaryOutputChannelName[AmpNumber]
                                  else Result := FPrimaryOutputChannelNameCC[AmpNumber] ;
        end
     else Result := '' ;
     end ;


function  TAmplifier.GetSecondaryOutputChannel(
          AmpNumber : Integer )
           : Integer  ;
// ---------------------------
// Get secondary outputchannel #
// ---------------------------
begin
     if (AmpNumber >= 0) and (AmpNumber <= MaxAmplifiers) then  begin
        Result := FSecondaryOutputChannel[AmpNumber] ;
        end
     else Result := 0 ;
     end ;


function  TAmplifier.GetSecondaryOutputChannelName(
          AmpNumber : Integer ;
          ClampMode : Integer )
           : String  ;
// ---------------------------
// Get secondary output channel name
// ---------------------------
begin
     if (AmpNumber >= 0) and (AmpNumber <= MaxAmplifiers) then  begin
        if ClampMode = VClampMode then Result := FSecondaryOutputChannelName[AmpNumber]
                                  else Result := FSecondaryOutputChannelNameCC[AmpNumber] ;
        end
     else Result := '' ;

     end ;


function  TAmplifier.GetVoltageCommandChannel(
          AOChan : Integer )
           : Integer  ;
// ----------------------------------------
// Get voltage command output channel
// ----------------------------------------
begin
     if (AOChan >= 0) and (AOChan <= MaxAmplifiers) then  begin
        Result := FVoltageCommandChannel[AOChan] ;
        end
     else Result := 0 ;
     end ;


function  TAmplifier.GetCurrentCommandChannel(
          AOChan : Integer )
           : Integer  ;
// ----------------------------------------
// Get voltage command output channel
// ----------------------------------------
begin
     if (AOChan >= 0) and (AOChan <= MaxAmplifiers) then  begin
        Result := FCurrentCommandChannel[AOChan] ;
        end
     else Result := 0 ;
     end ;


function TAmplifier.getPrimaryChannelScaleFactor( AmpNumber : Integer ) : Single ;
// --------------------------------
// Get primary channel scale factor
// --------------------------------
var
    ChanName,ChanUnits : String ;
    ChanCalFactor,ChanScale : Single ;
begin

     GetChannelSettings( FPrimaryOutputChannel[AmpNumber],
                         ChanName,ChanUnits,ChanCalFactor,ChanScale) ;
     Result := ChanCalFactor*ChanScale ;
    end ;


function TAmplifier.getSecondaryChannelScaleFactor( AmpNumber : Integer ) : Single ;
// --------------------------------
// Get secondary channel scale factor
// --------------------------------
var
    ChanName,ChanUnits : String ;
    ChanCalFactor,ChanScale : Single ;
begin
     GetChannelSettings( FSecondaryOutputChannel[AmpNumber],
                         ChanName,ChanUnits,ChanCalFactor,ChanScale) ;
     Result := ChanCalFactor ;
    end ;


function TAmplifier.getPrimaryChannelScaleFactorX1Gain(
         AmpNumber : Integer ;
         ClampMode : Integer ) : Single ;
// -----------------------------------------------
// Get primary channel scale factor at X1 gain
// -----------------------------------------------
var
    ChanName,ChanUnits : String ;
    ChanCalFactor,ChanScale : Single ;
begin
    if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
       // This call ensures that fixed primary channel scale factors overrides
       // user entered settings
       GetChannelSettings( FPrimaryOutputChannel[AmpNumber],
                           ChanName,ChanUnits,ChanCalFactor,ChanScale) ;
       if ClampMode = VClampMode then Result := FPrimaryChannelScaleFactorX1Gain[AmpNumber]
                                 else Result := FPrimaryChannelScaleFactorX1GainCC[AmpNumber] ;
       if Result = 0.0 then Result := 1.0 ;
       end
    else Result := 1.0 ;

    end ;


function TAmplifier.getSecondaryChannelScaleFactorX1Gain(
         AmpNumber : Integer ;
         ClampMode : Integer ) : Single ;
// -----------------------------------------------
// Get secondary channel scale factor at X1 gain
// -----------------------------------------------
var
    ChanName,ChanUnits : String ;
    ChanCalFactor,ChanScale : Single ;
begin
    if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
       // This call ensures that fixed primary channel scale factors overrides
       // user entered settings
       GetChannelSettings( FSecondaryOutputChannel[AmpNumber],
                           ChanName,ChanUnits,ChanCalFactor,ChanScale) ;
       if ClampMode = VClampMode then Result := FSecondaryChannelScaleFactorX1Gain[AmpNumber]
                                 else Result := FSecondaryChannelScaleFactorX1GainCC[AmpNumber] ;
       if Result = 0.0 then Result := 1.0 ;
       end
    else Result := 1.0 ;

    end ;


function TAmplifier.getPrimaryChannelUnits(
         AmpNumber : Integer ;
         ClampMode : Integer ) : String ;
// ---------------------------------------
// Get meaurement units of primary channel
// ---------------------------------------
//var
//    ChanName,ChanUnits : String ;
//    ChanCalFactor,ChanScale : Single ;
begin
    if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
        if ClampMode = VClampMode then Result := FPrimaryChannelUnits[AmpNumber]
                                  else Result := FPrimaryChannelUnitsCC[AmpNumber] ;
        end
     else Result := '' ;
     end ;


function TAmplifier.getSecondaryChannelUnits(
         AmpNumber : Integer ;
         ClampMode : Integer ) : String ;
// ---------------------------------------
// Get meaurement units of Secondary channel
// ---------------------------------------
//var
//    ChanName,ChanUnits : String ;
//    ChanCalFactor,ChanScale : Single ;
begin
    if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
        if ClampMode = VClampMode then Result := FSecondaryChannelUnits[AmpNumber]
                                  else Result := FSecondaryChannelUnitsCC[AmpNumber] ;
        end
     else Result := '' ;
     end ;


procedure TAmplifier.SetPrimaryChannelScaleFactor( AmpNumber : Integer ; Value : Single ) ;
begin
    FPrimaryChannelScaleFactor[AmpNumber] := Value ;
    end ;


procedure TAmplifier.SetSecondaryChannelScaleFactor ( AmpNumber : Integer ; Value : Single ) ;
begin
    if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
       FSecondaryChannelScaleFactor[AmpNumber] := Value ;
       end ;
    end ;


procedure TAmplifier.SetPrimaryChannelScaleFactorX1Gain(
          AmpNumber : Integer ;
          ClampMode : Integer ;
          Value : Single ) ;
// ------------------------------------------------------
// Set primary channel V/units scale factor (at X1 gain)
// ------------------------------------------------------
begin
    if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
       if ClampMode = VClampMode then FPrimaryChannelScaleFactorX1Gain[AmpNumber] := Value
                                 else FPrimaryChannelScaleFactorX1GainCC[AmpNumber] := Value ;
       // Note scale factor is set
       FPrimaryChannelScaleFactor[AmpNumber] := Value ;
       end ;
    end ;


procedure TAmplifier.SetSecondaryChannelScaleFactorX1Gain(
          AmpNumber : Integer ;
          ClampMode : Integer ;
          Value : Single ) ;
begin
    if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
       if ClampMode = VClampMode then FSecondaryChannelScaleFactorX1Gain[AmpNumber] := Value
                                 else FSecondaryChannelScaleFactorX1GainCC[AmpNumber] := Value ;
       FSecondaryChannelScaleFactor[AmpNumber] := Value ;
       end ;
    end ;


procedure TAmplifier.SetPrimaryChannelUnits(
          AmpNumber : Integer ;
          ClampMode : Integer ;
          Value : String ) ;
begin
    if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
       if ClampMode = VClampMode then FPrimaryChannelUnits[AmpNumber] := Value
                                 else FPrimaryChannelUnitsCC[AmpNumber] := Value ;
       end ;
    end ;


procedure TAmplifier.SetSecondaryChannelUnits(
          AmpNumber : Integer ;
          ClampMode : Integer ;
          Value : String ) ;
begin
    if (AmpNumber >= 0) and (AmpNumber < MaxAmplifiers) then begin
       if ClampMode = VClampMode then FSecondaryChannelUnits[AmpNumber] := Value
                                 else FSecondaryChannelUnitsCC[AmpNumber] := Value ;
       end ;
    end ;


procedure TAmplifier.SetAmplifierType(
          AmpNumber : Integer ;
          Value : Integer ) ;
// ----------------------
// Set type of amplifier
// ----------------------
var
    OldType : Integer ;
begin

    if (AmpNumber < 0) or (AmpNumber >= MaxAmplifiers) then Exit ;
    OldType := FAmpType[AmpNumber] ;
    FAmpType[AmpNumber] := Value ;
    if FAmpType[AmpNumber] <> OldType then LoadDefaultAmplifierSettings(AmpNumber) ;

    end ;


function TAmplifier.GetSpecialFolder(const ASpecialFolderID: Integer): string;
// --------------------------
// Get Windows special folder
// --------------------------
var
  //vSFolder :  pItemIDList;
  vSpecialPath : array[0..MAX_PATH] of Char;
begin

    SHGetFolderPath( 0, ASpecialFolderID, 0,0,vSpecialPath) ;
//  SHGetSpecialFolderLocation(0, ASpecialFolderID, vSFolder);

//  SHGetPathFromIDList(vSFolder, vSpecialPath);

  Result := StrPas(vSpecialPath);

  end;


end.
