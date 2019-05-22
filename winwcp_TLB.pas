unit winwcp_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 22/05/2019 13:14:26 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Users\John\Documents\Embarcadero\Studio\Projects\WinWCPXE\winwcp (1)
// LIBID: {2AE1CB67-2310-4EA0-B43D-916A931F4AE1}
// LCID: 0
// Helpfile: mer
// HelpString: winwcp Library
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  winwcpMajorVersion = 1;
  winwcpMinorVersion = 0;

  LIBID_winwcp: TGUID = '{2AE1CB67-2310-4EA0-B43D-916A931F4AE1}';

  IID_IAUTO: TGUID = '{314667FF-F90F-435C-B738-3D6E58FF2BF6}';
  CLASS_AUTO: TGUID = '{D16707AE-40F8-4310-BA8F-F56E544FE6FA}';
  DIID_DispInterface1: TGUID = '{A15A5FCC-989B-40E7-8826-7FECF8DEBFC4}';
  IID_Interface1: TGUID = '{D3C5C4E5-632F-470D-8A9C-D79E86E1F425}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IAUTO = interface;
  IAUTODisp = dispinterface;
  DispInterface1 = dispinterface;
  Interface1 = interface;
  Interface1Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  AUTO = IAUTO;


// *********************************************************************//
// Interface: IAUTO
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {314667FF-F90F-435C-B738-3D6E58FF2BF6}
// *********************************************************************//
  IAUTO = interface(IDispatch)
    ['{314667FF-F90F-435C-B738-3D6E58FF2BF6}']
    procedure NewFile(FileName: OleVariant); safecall;
    procedure OpenFile(FileName: OleVariant); safecall;
    procedure CloseFile; safecall;
    procedure StartSealTest; safecall;
    function Get_Cm: OleVariant; safecall;
    procedure Set_Cm(Value: OleVariant); safecall;
    function Get_Gm: OleVariant; safecall;
    procedure Set_Gm(Value: OleVariant); safecall;
    function Get_Ga: OleVariant; safecall;
    procedure Set_Ga(Value: OleVariant); safecall;
    function Get_Rseal: OleVariant; safecall;
    procedure Set_Rseal(Value: OleVariant); safecall;
    function Get_SealTestPulseAmplitude: OleVariant; safecall;
    procedure Set_SealTestPulseAmplitude(Value: OleVariant); safecall;
    function Get_SealTestPulseDuration: OleVariant; safecall;
    procedure Set_SealTestPulseDuration(Value: OleVariant); safecall;
    procedure StopSealTest; safecall;
    function Get_HoldingVoltage: OleVariant; safecall;
    procedure Set_HoldingVoltage(Value: OleVariant); safecall;
    procedure StartRecording; safecall;
    procedure StopRecording; safecall;
    function Get_TriggerMode: OleVariant; safecall;
    procedure Set_TriggerMode(Value: OleVariant); safecall;
    function Get_StimulusProtocol: OleVariant; safecall;
    procedure Set_StimulusProtocol(Value: OleVariant); safecall;
    function Get_Vm: OleVariant; safecall;
    procedure Set_Vm(Value: OleVariant); safecall;
    function Get_Im: OleVariant; safecall;
    procedure Set_Im(Value: OleVariant); safecall;
    function Get_SealTestNumAverages: OleVariant; safecall;
    procedure Set_SealTestNumAverages(Value: OleVariant); safecall;
    procedure GetADCSample(RecordNum: Integer; ChannelNum: Integer; SampleNum: Integer;
                           out Value: OleVariant); safecall;
    function Get_NumRecordsInFile: Integer; safecall;
    procedure Set_NumRecordsInFile(Value: Integer); safecall;
    function Get_NumChannelsPerRecord: Integer; safecall;
    procedure Set_NumChannelsPerRecord(Value: Integer); safecall;
    function Get_NumSamplesPerChannel: Integer; safecall;
    procedure Set_NumSamplesPerChannel(Value: Integer); safecall;
    function Get_Status: OleVariant; safecall;
    procedure Set_Status(Value: OleVariant); safecall;
    function Get_PicoGain: Integer; safecall;
    procedure Set_PicoGain(Value: Integer); safecall;
    function Get_PicoInput: Integer; safecall;
    procedure Set_PicoInput(Value: Integer); safecall;
    function Get_PicoConfig: Integer; safecall;
    procedure Set_PicoConfig(Value: Integer); safecall;
    function Get_PicoFilter: Integer; safecall;
    procedure Set_PicoFilter(Value: Integer); safecall;
    function Get_PicoEnableCSlow: Integer; safecall;
    procedure Set_PicoEnableCSlow(Value: Integer); safecall;
    function Get_PicoENableCFast: Integer; safecall;
    procedure Set_PicoENableCFast(Value: Integer); safecall;
    function Get_PicoEnableJP: Integer; safecall;
    procedure Set_PicoEnableJP(Value: Integer); safecall;
    function Get_PicoCSlowComp: OleVariant; safecall;
    procedure Set_PicoCSlowComp(Value: OleVariant); safecall;
    function Get_PicoCfastComp: OleVariant; safecall;
    procedure Set_PicoCfastComp(Value: OleVariant); safecall;
    function Get_PicoJPComp: OleVariant; safecall;
    procedure Set_PicoJPComp(Value: OleVariant); safecall;
    procedure PicoAutoCompCFast; safecall;
    procedure PicoAutoCompCSlow; safecall;
    procedure PicoAutoCompJP; safecall;
    procedure PicoClearCompC; safecall;
    procedure PicoClearCompJP; safecall;
    function Get_SealTestGaFromPeak: Integer; safecall;
    procedure Set_SealTestGaFromPeak(Value: Integer); safecall;
    property Cm: OleVariant read Get_Cm write Set_Cm;
    property Gm: OleVariant read Get_Gm write Set_Gm;
    property Ga: OleVariant read Get_Ga write Set_Ga;
    property Rseal: OleVariant read Get_Rseal write Set_Rseal;
    property SealTestPulseAmplitude: OleVariant read Get_SealTestPulseAmplitude write Set_SealTestPulseAmplitude;
    property SealTestPulseDuration: OleVariant read Get_SealTestPulseDuration write Set_SealTestPulseDuration;
    property HoldingVoltage: OleVariant read Get_HoldingVoltage write Set_HoldingVoltage;
    property TriggerMode: OleVariant read Get_TriggerMode write Set_TriggerMode;
    property StimulusProtocol: OleVariant read Get_StimulusProtocol write Set_StimulusProtocol;
    property Vm: OleVariant read Get_Vm write Set_Vm;
    property Im: OleVariant read Get_Im write Set_Im;
    property SealTestNumAverages: OleVariant read Get_SealTestNumAverages write Set_SealTestNumAverages;
    property NumRecordsInFile: Integer read Get_NumRecordsInFile write Set_NumRecordsInFile;
    property NumChannelsPerRecord: Integer read Get_NumChannelsPerRecord write Set_NumChannelsPerRecord;
    property NumSamplesPerChannel: Integer read Get_NumSamplesPerChannel write Set_NumSamplesPerChannel;
    property Status: OleVariant read Get_Status write Set_Status;
    property PicoGain: Integer read Get_PicoGain write Set_PicoGain;
    property PicoInput: Integer read Get_PicoInput write Set_PicoInput;
    property PicoConfig: Integer read Get_PicoConfig write Set_PicoConfig;
    property PicoFilter: Integer read Get_PicoFilter write Set_PicoFilter;
    property PicoEnableCSlow: Integer read Get_PicoEnableCSlow write Set_PicoEnableCSlow;
    property PicoENableCFast: Integer read Get_PicoENableCFast write Set_PicoENableCFast;
    property PicoEnableJP: Integer read Get_PicoEnableJP write Set_PicoEnableJP;
    property PicoCSlowComp: OleVariant read Get_PicoCSlowComp write Set_PicoCSlowComp;
    property PicoCfastComp: OleVariant read Get_PicoCfastComp write Set_PicoCfastComp;
    property PicoJPComp: OleVariant read Get_PicoJPComp write Set_PicoJPComp;
    property SealTestGaFromPeak: Integer read Get_SealTestGaFromPeak write Set_SealTestGaFromPeak;
  end;

// *********************************************************************//
// DispIntf:  IAUTODisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {314667FF-F90F-435C-B738-3D6E58FF2BF6}
// *********************************************************************//
  IAUTODisp = dispinterface
    ['{314667FF-F90F-435C-B738-3D6E58FF2BF6}']
    procedure NewFile(FileName: OleVariant); dispid 201;
    procedure OpenFile(FileName: OleVariant); dispid 202;
    procedure CloseFile; dispid 203;
    procedure StartSealTest; dispid 204;
    property Cm: OleVariant dispid 205;
    property Gm: OleVariant dispid 206;
    property Ga: OleVariant dispid 207;
    property Rseal: OleVariant dispid 208;
    property SealTestPulseAmplitude: OleVariant dispid 209;
    property SealTestPulseDuration: OleVariant dispid 210;
    procedure StopSealTest; dispid 211;
    property HoldingVoltage: OleVariant dispid 212;
    procedure StartRecording; dispid 213;
    procedure StopRecording; dispid 214;
    property TriggerMode: OleVariant dispid 215;
    property StimulusProtocol: OleVariant dispid 216;
    property Vm: OleVariant dispid 217;
    property Im: OleVariant dispid 218;
    property SealTestNumAverages: OleVariant dispid 219;
    procedure GetADCSample(RecordNum: Integer; ChannelNum: Integer; SampleNum: Integer;
                           out Value: OleVariant); dispid 220;
    property NumRecordsInFile: Integer dispid 221;
    property NumChannelsPerRecord: Integer dispid 222;
    property NumSamplesPerChannel: Integer dispid 223;
    property Status: OleVariant dispid 224;
    property PicoGain: Integer dispid 225;
    property PicoInput: Integer dispid 226;
    property PicoConfig: Integer dispid 227;
    property PicoFilter: Integer dispid 228;
    property PicoEnableCSlow: Integer dispid 229;
    property PicoENableCFast: Integer dispid 230;
    property PicoEnableJP: Integer dispid 231;
    property PicoCSlowComp: OleVariant dispid 232;
    property PicoCfastComp: OleVariant dispid 233;
    property PicoJPComp: OleVariant dispid 234;
    procedure PicoAutoCompCFast; dispid 235;
    procedure PicoAutoCompCSlow; dispid 236;
    procedure PicoAutoCompJP; dispid 237;
    procedure PicoClearCompC; dispid 240;
    procedure PicoClearCompJP; dispid 238;
    property SealTestGaFromPeak: Integer dispid 239;
  end;

// *********************************************************************//
// DispIntf:  DispInterface1
// Flags:     (0)
// GUID:      {A15A5FCC-989B-40E7-8826-7FECF8DEBFC4}
// *********************************************************************//
  DispInterface1 = dispinterface
    ['{A15A5FCC-989B-40E7-8826-7FECF8DEBFC4}']
  end;

// *********************************************************************//
// Interface: Interface1
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D3C5C4E5-632F-470D-8A9C-D79E86E1F425}
// *********************************************************************//
  Interface1 = interface(IDispatch)
    ['{D3C5C4E5-632F-470D-8A9C-D79E86E1F425}']
  end;

// *********************************************************************//
// DispIntf:  Interface1Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D3C5C4E5-632F-470D-8A9C-D79E86E1F425}
// *********************************************************************//
  Interface1Disp = dispinterface
    ['{D3C5C4E5-632F-470D-8A9C-D79E86E1F425}']
  end;

// *********************************************************************//
// The Class CoAUTO provides a Create and CreateRemote method to
// create instances of the default interface IAUTO exposed by
// the CoClass AUTO. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoAUTO = class
    class function Create: IAUTO;
    class function CreateRemote(const MachineName: string): IAUTO;
  end;

implementation

uses System.Win.ComObj;

class function CoAUTO.Create: IAUTO;
begin
  Result := CreateComObject(CLASS_AUTO) as IAUTO;
end;

class function CoAUTO.CreateRemote(const MachineName: string): IAUTO;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AUTO) as IAUTO;
end;

end.

