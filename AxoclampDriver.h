//***********************************************************************************************
//
//    Copyright (c) 2006 Axon Instruments.
//    All rights reserved.
//
//***********************************************************************************************
// MODULE:  AXOCLAMPDRIVER.H
// PURPOSE: Interface definition for AxoclampDriver.DLL
// NOTE:    Rf refers to the headstage feedback resistor which in some modes such as current clamp
//          is not strictly a feedback resistor but an injection resistance, Ro. 
// AUTHOR:  GRB  Jun 2004

#ifndef INC_AXOCLAMPDRIVER_H
#define INC_AXOCLAMPDRIVER_H

#pragma once

// define the macro for exporting/importing the API entry points.
// N.B. the symbol below should only be defined when building this DLL.
#ifdef MAK_AXCAPI_DLL
   #define AXCAPI __declspec(dllexport)
#else
   #define AXCAPI __declspec(dllimport)
#endif

extern "C" {

// The handle type declaration.
DECLARE_HANDLE(HAXC);

// API version number.
#define AXC_APIVERSION       1,0,0,56
#define AXC_APIVERSION_STR  "1.0.0.56"

//==============================================================================================
// SI and index range of a property
//==============================================================================================
struct AXC_PropertyRange
{
   double  dValMin; // minimum value (SI units)
   double  dValMax; // maximum value (SI units)
   int     nValMin; // minimum value index   
   int     nValMax; // maximum value index
   
   AXC_PropertyRange() { memset(this, 0, sizeof(AXC_PropertyRange)); }
};

//==============================================================================================
// Signal settings cache
//==============================================================================================
struct AXC_SignalSettings
{
   BOOL    bSave;       // TRUE if signal settings must be saved to registry
   double  dGain;       // combined gain value (pre and post)
   double  dLPF;        // lowpass filter cutoff in Hz (-3bB)
   double  dHPF;        // highpass filter cutoff in Hz (-3dB)
   double  dZeroLevel;  // output zero in Volts
   bool    bZeroEnable; // output zero enable
   UINT    uLPFType;    // lowpass filter type (Bessel=AXC_SIGNAL_LPFTYPE_BESSEL or Butterworth=AXC_SIGNAL_LPFTYPE_BUTTERWORTH)

   AXC_SignalSettings() { memset(this, 0, sizeof(AXC_SignalSettings)); }
};

//==============================================================================================
// Determines which properties are available 
// Use with GetPropertyRules() for the specified mode and channel.
//==============================================================================================
struct AXC_PropertyRules
{
   BOOL  bMode;
   BOOL  bAutoEnable;
   BOOL  bAutoPolarity;
   BOOL  bAutoSource;
   BOOL  bAutoThreshold;
   BOOL  bAutoICReturn;
   BOOL  bAutoICDelay;
   BOOL  bAutoVCDelay;
   BOOL  bHoldingEnable;
   BOOL  bHoldingLevel;
   BOOL  bExtCmdEnable;
   BOOL  bTestSignalEnable;
   BOOL  bTestSignalAmplitude;
   BOOL  bTestSignalFrequency;
   BOOL  bPulse;
   BOOL  bPulseDuration;
   BOOL  bPulseAmplitude;
   BOOL  bBuzz;
   BOOL  bBuzzDuration;
   BOOL  bBuzzAmplitude;
   BOOL  bAutoPipetteOffset;
   BOOL  bPipetteOffsetLock;
   BOOL  bPipetteOffset;
   BOOL  bOscKillerEnable;
   BOOL  bOscKillerMethod;
   BOOL  bAutoBridge;
   BOOL  bBridgeLock;
   BOOL  bBridgeEnable;
   BOOL  bBridgeLevel;
   BOOL  bClearElectrode;
   BOOL  bCapNeutEnable;
   BOOL  bCapNeutLevel;
   BOOL  bTrackEnable;
   BOOL  bTrackLevel;
   BOOL  bTrackSpeed;
   BOOL  bScaledOutputSignal;
   BOOL  bScaledOutputSignalGain;
   BOOL  bScaledOutputSignalLPF;
   BOOL  bScaledOutputSignalLPFType;
   BOOL  bScaledOutputSignalHPF;
   BOOL  bAutoScaledOutputZero;
   BOOL  bScaledOutputZeroEnable;
   BOOL  bScaledOutputZeroLevel;
   BOOL  bSamplePeriod;
   BOOL  bLoopGain;
   BOOL  bLoopLag;
   BOOL  bDCRestoreEnable;
   BOOL  bAudioSignal;

   AXC_PropertyRules() { memset(this, 0, sizeof(AXC_PropertyRules)); }
};

//==============================================================================================
// Meter and status data
//==============================================================================================
struct AXC_MeterData
{
   // meter values
   double  dMeter1;           // value of meter 1 (SI units)
   double  dMeter2;           // value of meter 2 (SI units)
   double  dMeter3;           // value of meter 3 (SI units)
   double  dMeter4;           // value of meter 4 (SI units)
   BOOL    bOvldMeter1;       // meter 1 overload status
   BOOL    bOvldMeter2;       // meter 2 overload status
   BOOL    bOvldMeter3;       // meter 3 overload status
   BOOL    bOvldMeter4;       // meter 4 overload status

   // status
   BOOL    bPowerFail;        // power loss since last inquiry ?   
   BOOL    bPresenceChan1;    // channel 1 headstage present ? 
   BOOL    bPresenceChan2;    // channel 2 headstage present ? 
   BOOL    bPresenceAux1;     // auxiliary 1 headstage present ?
   BOOL    bPresenceAux2;     // auxiliary 2 headstage present ?
   BOOL    bIsVClampChan1;    // channel 1 operating in VClamp mode ?
   BOOL    bIsVClampChan2;    // channel 2 operating in VClamp mode ?
   BOOL    bOscKillerChan1;   // channel 1 oscillation killer active?
   BOOL    bOscKillerChan2;   // channel 2 oscillation killer active ?

   AXC_MeterData() { memset(this, 0, sizeof(AXC_MeterData)); }
};


//==============================================================================================
// Signal data 
//==============================================================================================
struct AXC_Signal
{
   UINT   uChannel; // headstage channel
   UINT   uID;      // signal ID
   LPCSTR pszName;  // signal name
   BOOL   bValid;   // TRUE when signal is available for use
};

//==============================================================================================
// DLL creation/destruction functions
//==============================================================================================

// Check on the version number of the API interface.
AXCAPI BOOL WINAPI AXC_CheckAPIVersion(LPCSTR pszQueryVersion);

// Create the Axoclamp device object and return a handle.
AXCAPI HAXC WINAPI AXC_CreateHandle(BOOL bDemo, int *pnError);

// Destroy the Axoclamp device object specified by handle.
AXCAPI void WINAPI AXC_DestroyHandle(HAXC hAXC);

//==============================================================================================
// Axoclamp 900x device selection functions
//==============================================================================================

// Find the first Axoclamp 900x and return device info.
AXCAPI BOOL WINAPI AXC_FindFirstDevice(HAXC hAXC, char *pszSerialNum, UINT uBufSize, int *pnError);

// Find next Axoclamp 900x and return device info, returns FALSE when all Axoclamp 900x devices have been found.
AXCAPI BOOL WINAPI AXC_FindNextDevice(HAXC hAXC, char *pszSerialNum, UINT uBufSize, int *pnError);

// Open Axoclamp 900x device.
AXCAPI BOOL WINAPI AXC_OpenDevice(HAXC hAXC, const char *pszSerialNum, BOOL bReadHardware, int *pnError);

// Close Axoclamp 900x device.
AXCAPI BOOL WINAPI AXC_CloseDevice(HAXC hAXC, int *pnError);

// Get Axoclamp 900x device serial number.
AXCAPI BOOL WINAPI AXC_GetSerialNumber(HAXC m_hAXC, char *pszSerialNum, UINT uBufSize, int *pnError);

// Is an Axoclamp 900x device open?
AXCAPI BOOL WINAPI AXC_IsDeviceOpen(HAXC hAXC, BOOL *pbOpen, int *pnError);

// Check demo flag.
AXCAPI BOOL WINAPI AXC_IsDemo(HAXC hAXC, BOOL *pbDemo, int *pnError);

// Reset firmware to factory defaults.
AXCAPI BOOL WINAPI AXC_Reset(HAXC hAXC, int *pnError);

// Property rules for channel and mode
AXCAPI BOOL WINAPI AXC_GetPropertyRules(HAXC hAXC,  AXC_PropertyRules *pRules, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Headstage functions
//==============================================================================================

// Get and store the SI range for properties derived from headstage Rf and/or Ci on the specified channel.
AXCAPI BOOL WINAPI AXC_CalibrateHeadstageProperties(HAXC hAXC, UINT uChannel, int *pnError);

// Check Axoclamp 900x device has a headstage connected on the specified channel.
AXCAPI BOOL WINAPI AXC_IsHeadstagePresent(HAXC hAXC, BOOL *pbPresent, UINT uChannel, BOOL bAuxiliary, int *pnError);

// Get the headstage type connected on the specified channel.
// NOTE: MUST NOT be called within ~1 second of AXC_Reset(). AXC_Reset() instigates a meter autozero
//       that takes about a 1 second to complete. If called within 1 second after a AXC_Reset() the 
//       return value maybe incorrect even though the function will still return true.
AXCAPI BOOL WINAPI AXC_GetHeadstageType(HAXC hAXC, UINT *puType, UINT uChannel, BOOL bAuxiliary, int *pnError);

// Get headstage feedback resistor value.
AXCAPI BOOL WINAPI AXC_GetRf(HAXC hAXC, double *pdRf, UINT uChannel, BOOL bAuxiliary, int *pnError);

// Get headstage injection capacitor value.
AXCAPI BOOL WINAPI AXC_GetCi(HAXC hAXC, double *pdCi, UINT uChannel, int *pnError);

// Set custom values for Rf, Ci and enable state (call when AXC_GetHeadstageType() returns AXC_HEADSTAGE_TYPE_HS9_ADAPTER).
AXCAPI BOOL WINAPI AXC_SetCustomHeadstageValues(HAXC hAXC, double dRf, double dCi, BOOL bEnable, UINT uChannel, int *pnError);

// Get custom values for Rf, Ci and enable state.
AXCAPI BOOL WINAPI AXC_GetCustomHeadstageValues(HAXC hAXC, double *pdRf, double *pdCi, BOOL *pbEnable, UINT uChannel, int *pnError);

//==============================================================================================
// Serialization functions
//==============================================================================================

// Load properties from file or registry into amplifier.
AXCAPI BOOL WINAPI AXC_LoadProperties(HAXC hAXC, LPCSTR pszSettings, LPCSTR pszPath, BOOL bUseFile, int *pnError);

// Save properties from amplifier to registry or file.
AXCAPI BOOL WINAPI AXC_SaveProperties(HAXC hAXC, LPCSTR pszSettings, LPCSTR pszPath, BOOL bUseFile, int *pnError);

//==============================================================================================
// System functions
//==============================================================================================

// Set sync output method.
AXCAPI BOOL WINAPI AXC_SetSyncOutput(HAXC hAXC, UINT uSync, int *pnError);

// Get sync output method.
AXCAPI BOOL WINAPI AXC_GetSyncOutput(HAXC hAXC, UINT *puSync, int *pnError);

// Set auto sync output method.
AXCAPI BOOL WINAPI AXC_SetAutoSyncOutput(HAXC hAXC, UINT uAutoSync, int *pnError);

// Get auto sync output method.
AXCAPI BOOL WINAPI AXC_GetAutoSyncOutput(HAXC hAXC, UINT *puAutoSync, int *pnError);

// Get Axoclamp 900x device firmware version.
AXCAPI BOOL WINAPI AXC_GetFirmwareVersion(HAXC hAXC, char *pszLowVer, char *pszHiVer, UINT uBufSize, int *pnError);

// Get Axoclamp 900x device name.
AXCAPI BOOL WINAPI AXC_GetDeviceName(HAXC hAXC, char *pszName, UINT uBufSize, int *pnError);

// Get Axoclamp 900x device manufacture date. (mmddyy)
AXCAPI BOOL WINAPI AXC_GetManufactureDate(HAXC hAXC, char *pszDate, UINT uBufSize, int *pnError);

// Cache all settings when TRUE.
AXCAPI BOOL WINAPI AXC_SetCacheEnable(HAXC hAXC, BOOL bCache, int *pnError);

// Block all hardware commands when FALSE.
AXCAPI BOOL WINAPI AXC_SetHardwareAccessEnable(HAXC hAXC, BOOL bEnable, int *pnError);

//==============================================================================================
// Meter and status functions
//==============================================================================================

// Set meter signal
AXCAPI BOOL WINAPI AXC_SetMeterSignal(HAXC hAXC, UINT uMeter, UINT uSignal, UINT uMode, int *pnError);

// Get meter signal
AXCAPI BOOL WINAPI AXC_GetMeterSignal(HAXC hAXC, UINT uMeter, UINT *puSignal, UINT uMode, int *pnError);

// Acquire data from all meters
AXCAPI BOOL WINAPI AXC_AcquireMeterData(HAXC hAXC, AXC_MeterData *pMeterData, int *pnError);

// Set meter attenuator (x0.1)
AXCAPI BOOL WINAPI AXC_SetMeterAttenuatorEnable(HAXC hAXC, UINT uMeter, BOOL bAttenuator, int *pnError);

// Get meter attenuator (x0.1)
AXCAPI BOOL WINAPI AXC_GetMeterAttenuatorEnable(HAXC hAXC, UINT uMeter, BOOL *pbAttenuator, int *pnError);

//==============================================================================================
// Mode functions - current and voltage clamp
//==============================================================================================

// Set amplifier mode for the specified channel
AXCAPI BOOL WINAPI AXC_SetMode(HAXC hAXC, UINT uChannel, UINT uMode, int *pnError);

// Get amplifier mode for the specified channel
AXCAPI BOOL WINAPI AXC_GetMode(HAXC hAXC, UINT uChannel, UINT *puMode, int *pnError);

//==============================================================================================
// Auto mode functions - setup criteria to automatically switch from current to voltage clamp
//==============================================================================================

// Set auto enable for the specified channel
AXCAPI BOOL WINAPI AXC_SetAutoEnable(HAXC hAXC, BOOL bEnable, UINT uChannel, int *pnError);

// Get auto enable for the specified channel
AXCAPI BOOL WINAPI AXC_GetAutoEnable(HAXC hAXC, BOOL *pbEnable, UINT uChannel, int *pnError);

// Set auto polarity for the specified channel
AXCAPI BOOL WINAPI AXC_SetAutoPolarity(HAXC hAXC, UINT uPolarity, UINT uChannel, int *pnError);

// Get auto polarity for the specified channel
AXCAPI BOOL WINAPI AXC_GetAutoPolarity(HAXC hAXC, UINT *puPolarity, UINT uChannel, int *pnError);

// Set auto signal source for the specified channel
AXCAPI BOOL WINAPI AXC_SetAutoSource(HAXC hAXC, UINT uSource, UINT uChannel, int *pnError);

// Get auto signal source for the specified channel
AXCAPI BOOL WINAPI AXC_GetAutoSource(HAXC hAXC, UINT *puSource, UINT uChannel, int *pnError);

// Set auto Vm threshold for the specified channel (applies only to Vm triggers)
AXCAPI BOOL WINAPI AXC_SetAutoThreshold(HAXC hAXC, double dThreshold, UINT uChannel, int *pnError);

// Get auto Vm threshold for the specified channel (applies only to Vm triggers)
AXCAPI BOOL WINAPI AXC_GetAutoThreshold(HAXC hAXC, double *pdThreshold, UINT uChannel, int *pnError);

// Get auto Vm threshold range for the specified channel (applies only to Vm triggers)
AXCAPI BOOL WINAPI AXC_GetAutoThresholdRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, int *pnError);

// Set auto IC return method for the specified channel
AXCAPI BOOL WINAPI AXC_SetAutoICReturn(HAXC hAXC, UINT uICReturn, UINT uChannel, int *pnError);

// Get auto IC return method for the specified channel
AXCAPI BOOL WINAPI AXC_GetAutoICReturn(HAXC hAXC, UINT *puICReturn, UINT uChannel, int *pnError);

// Set auto IC return delay for the specified channel
AXCAPI BOOL WINAPI AXC_SetAutoICDelay(HAXC hAXC, double dDelay, UINT uChannel, int *pnError);

// Get auto IC return delay for the specified channel
AXCAPI BOOL WINAPI AXC_GetAutoICDelay(HAXC hAXC, double *pdDelay, UINT uChannel, int *pnError);

// Get auto IC return delay range for the specified channel
AXCAPI BOOL WINAPI AXC_GetAutoICDelayRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, int *pnError);

// Set auto VC delay for the specified channel
AXCAPI BOOL WINAPI AXC_SetAutoVCDelay(HAXC hAXC, double dDelay, UINT uChannel, int *pnError);

// Get auto VC delay for the specified channel
AXCAPI BOOL WINAPI AXC_GetAutoVCDelay(HAXC hAXC, double *pdDelay, UINT uChannel, int *pnError);

// Get auto VC return delay range for the specified channel
AXCAPI BOOL WINAPI AXC_GetAutoVCDelayRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, int *pnError);

//==============================================================================================
// Holding functions - current and voltage clamp
//==============================================================================================

// Set holding enable
AXCAPI BOOL WINAPI AXC_SetHoldingEnable(HAXC hAXC, BOOL bEnable, UINT uChannel, UINT uMode, int *pnError);

// Get holding enable
AXCAPI BOOL WINAPI AXC_GetHoldingEnable(HAXC hAXC, BOOL *pbEnable, UINT uChannel, UINT uMode, int *pnError);

// Set holding value
AXCAPI BOOL WINAPI AXC_SetHoldingLevel(HAXC hAXC, double dLevel, UINT uChannel, UINT uMode, int *pnError);

// Get holding value
AXCAPI BOOL WINAPI AXC_GetHoldingLevel(HAXC hAXC, double *pdLevel, UINT uChannel, UINT uMode, int *pnError);

// Get holding range
AXCAPI BOOL WINAPI AXC_GetHoldingRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// External command functions - current and voltage clamp
//==============================================================================================

// Set external command enable
AXCAPI BOOL WINAPI AXC_SetExtCmdEnable(HAXC hAXC, BOOL bEnable, UINT uChannel, UINT uMode, int *pnError);

// Get external command enable
AXCAPI BOOL WINAPI AXC_GetExtCmdEnable(HAXC hAXC, BOOL *pbEnable, UINT uChannel, UINT uMode, int *pnError);

// Get external command sensitivity as Amperes/Volt or Volts/Volt
AXCAPI BOOL WINAPI AXC_GetExtCmdSensit(HAXC hAXC, double *pdSensit, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Test signal functions - current and voltage clamp
//==============================================================================================

// Set test signal enable
AXCAPI BOOL WINAPI AXC_SetTestSignalEnable(HAXC hAXC, BOOL bEnable, UINT uChannel, UINT uMode, int *pnError);

// Get test signal enable
AXCAPI BOOL WINAPI AXC_GetTestSignalEnable(HAXC hAXC, BOOL *pbEnable, UINT uChannel, UINT uMode, int *pnError);

// Set test signal amplitude
AXCAPI BOOL WINAPI AXC_SetTestSignalAmplitude(HAXC hAXC, double dAmplitude, UINT uChannel, UINT uMode, int *pnError);

// Get test signal amplitude
AXCAPI BOOL WINAPI AXC_GetTestSignalAmplitude(HAXC hAXC, double *pdAmplitude, UINT uChannel, UINT uMode , int *pnError);

// Get test signal amplitude range
AXCAPI BOOL WINAPI AXC_GetTestSignalAmplitudeRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, UINT uMode, int *pnError);

// Set test signal frequency
AXCAPI BOOL WINAPI AXC_SetTestSignalFrequency(HAXC hAXC, double dFrequency, UINT uChannel, UINT uMode , int *pnError);

// Get test signal frequency
AXCAPI BOOL WINAPI AXC_GetTestSignalFrequency(HAXC hAXC, double *pdFrequency, UINT uChannel, UINT uMode , int *pnError);

// Get test signal frequency range
AXCAPI BOOL WINAPI AXC_GetTestSignalFreqRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT *puBufSize, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Pulse functions - current and voltage clamp
//==============================================================================================

// Execute pulse
AXCAPI BOOL WINAPI AXC_Pulse(HAXC hAXC, UINT uChannel, UINT uMode , int *pnError);

// Set test signal pulse duration
AXCAPI BOOL WINAPI AXC_SetPulseDuration(HAXC hAXC, double dDuration, UINT uChannel, UINT uMode , int *pnError);

// Get test signal pulse duration
AXCAPI BOOL WINAPI AXC_GetPulseDuration(HAXC hAXC, double *pdDuration, UINT uChannel, UINT uMode , int *pnError);

// Get test signal pulse duration table 
AXCAPI BOOL WINAPI AXC_GetPulseDurationTable(HAXC hAXC, double *pdTable, UINT *puBufSize, UINT uChannel, UINT uMode, int *pnError);

// Set test signal pulse amplitude
AXCAPI BOOL WINAPI AXC_SetPulseAmplitude(HAXC hAXC, double dAmplitude, UINT uChannel, UINT uMode , int *pnError);

// Get test signal pulse amplitude
AXCAPI BOOL WINAPI AXC_GetPulseAmplitude(HAXC hAXC, double *pdAmplitude, UINT uChannel, UINT uMode , int *pnError);

// Get test signal pulse amplitude range
AXCAPI BOOL WINAPI AXC_GetPulseAmplitudeRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, UINT uMode , int *pnError);

//==============================================================================================
// Buzz functions - current clamp
//==============================================================================================

// Execute buzz
AXCAPI BOOL WINAPI AXC_Buzz(HAXC hAXC, UINT uChannel, UINT uMode, int *pnError);

// Set buzz duration
AXCAPI BOOL WINAPI AXC_SetBuzzDuration(HAXC hAXC, double dDuration, UINT uChannel, UINT uMode, int *pnError);

// Get buzz duration
AXCAPI BOOL WINAPI AXC_GetBuzzDuration(HAXC hAXC, double *pdDuration, UINT uChannel, UINT uMode, int *pnError);

// Get buzz duration table
AXCAPI BOOL WINAPI AXC_GetBuzzDurationTable(HAXC hAXC, double *pdTable, UINT *puBufSize, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Pipette offset functions - current and voltage clamp
//==============================================================================================

// Execute auto pipette offset
AXCAPI BOOL WINAPI AXC_AutoPipetteOffset(HAXC hAXC, UINT uChannel, UINT uMode, int *pnError);

// Set pipette offset lock
AXCAPI BOOL WINAPI AXC_SetPipetteOffsetLock(HAXC hAXC, BOOL bLock, UINT uChannel, UINT uMode, int *pnError);

// Get pipette offset lock
AXCAPI BOOL WINAPI AXC_GetPipetteOffsetLock(HAXC hAXC, BOOL *pbLock, UINT uChannel, UINT uMode, int *pnError);

// Set pipette offset
AXCAPI BOOL WINAPI AXC_SetPipetteOffset(HAXC hAXC, double dPipetteOffset, UINT uChannel, UINT uMode, int *pnError);

// Get pipette offset
AXCAPI BOOL WINAPI AXC_GetPipetteOffset(HAXC hAXC, double *pdPipetteOffset, UINT uChannel, UINT uMode, int *pnError);

// Get pipette offset range
AXCAPI BOOL WINAPI AXC_GetPipetteOffsetRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Oscillation killer functions - current and voltage clamp
//==============================================================================================

// Set oscillation killer enable
AXCAPI BOOL WINAPI AXC_SetOscKillerEnable(HAXC hAXC, BOOL bEnable, UINT uChannel, UINT uMode , int *pnError);

// Get oscillation killer enable
AXCAPI BOOL WINAPI AXC_GetOscKillerEnable(HAXC hAXC, BOOL *pbEnable, UINT uChannel, UINT uMode , int *pnError);

// Set oscillation killer method
AXCAPI BOOL WINAPI AXC_SetOscKillerMethod(HAXC hAXC, UINT uMethod, UINT uChannel, UINT uMode , int *pnError);

// Get oscillation killer method
AXCAPI BOOL WINAPI AXC_GetOscKillerMethod(HAXC hAXC, UINT *puMethod, UINT uChannel, UINT uMode , int *pnError);

//==============================================================================================
// Bridge Balance functions - current clamp
//==============================================================================================

// Auto bridge balance
AXCAPI BOOL WINAPI AXC_AutoBridge(HAXC hAXC, UINT uChannel, UINT uMode, int *pnError);

// Set bridge balance enable
AXCAPI BOOL WINAPI AXC_SetBridgeEnable(HAXC hAXC, BOOL bEnable, UINT uChannel, UINT uMode, int *pnError);

// Get bridge balance enable
AXCAPI BOOL WINAPI AXC_GetBridgeEnable(HAXC hAXC, BOOL *pbEnable, UINT uChannel, UINT uMode, int *pnError);

// Set bridge balance lock
AXCAPI BOOL WINAPI AXC_SetBridgeLock(HAXC hAXC, BOOL bLock, UINT uChannel, UINT uMode, int *pnError);

// Get bridge balance lock
AXCAPI BOOL WINAPI AXC_GetBridgeLock(HAXC hAXC, BOOL *pbLock, UINT uChannel, UINT uMode, int *pnError);

// Set bridge balance resistance
AXCAPI BOOL WINAPI AXC_SetBridgeLevel(HAXC hAXC, double dLevel, UINT uChannel, UINT uMode, int *pnError);

// Get bridge balance resistance
AXCAPI BOOL WINAPI AXC_GetBridgeLevel(HAXC hAXC, double *pdLevel, UINT uChannel, UINT uMode, int *pnError);

// Get bridge balance resistance range
AXCAPI BOOL WINAPI AXC_GetBridgeRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// +/- Clear functions - current clamp
//==============================================================================================

// Delivers a continuous large current step down the micropipette.
AXCAPI BOOL WINAPI AXC_ClearElectrode(HAXC hAXC, BOOL bOn, UINT uPolarity, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Pipette Capacitance Neutralization functions - current clamp
//==============================================================================================

// Set Pipette Capacitance Neutralization enable
AXCAPI BOOL WINAPI AXC_SetCapNeutEnable(HAXC hAXC, BOOL bEnable, UINT uChannel, UINT uMode, int *pnError);

// Get Pipette Capacitance Neutralization enable
AXCAPI BOOL WINAPI AXC_GetCapNeutEnable(HAXC hAXC, BOOL *pbEnable, UINT uChannel, UINT uMode, int *pnError);

// Set Pipette Capacitance Neutralization capacitance
AXCAPI BOOL WINAPI AXC_SetCapNeutLevel(HAXC hAXC, double dLevel, UINT uChannel, UINT uMode, int *pnError);

// Get Pipette Capacitance Neutralization capacitance
AXCAPI BOOL WINAPI AXC_GetCapNeutLevel(HAXC hAXC, double *pdLevel, UINT uChannel, UINT uMode, int *pnError);

// Get Pipette Capacitance Neutralization capacitance range
AXCAPI BOOL WINAPI AXC_GetCapNeutRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Track functions - current clamp
//==============================================================================================

// Set track enable
AXCAPI BOOL WINAPI AXC_SetTrackEnable(HAXC hAXC, BOOL bEnable, UINT uChannel, UINT uMode, int *pnError);

// Get track enable
AXCAPI BOOL WINAPI AXC_GetTrackEnable(HAXC hAXC, BOOL *pbEnable, UINT uChannel, UINT uMode, int *pnError);

// Set track level
AXCAPI BOOL WINAPI AXC_SetTrackLevel(HAXC hAXC, double dLevel, UINT uChannel, UINT uMode, int *pnError);

// Get track level
AXCAPI BOOL WINAPI AXC_GetTrackLevel(HAXC hAXC, double *pdLevel, UINT uChannel, UINT uMode, int *pnError);

// Get track level range
AXCAPI BOOL WINAPI AXC_GetTrackLevelRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, UINT uMode, int *pnError);

// Set track speed
AXCAPI BOOL WINAPI AXC_SetTrackSpeed(HAXC hAXC, double dSpeed, UINT uChannel, UINT uMode, int *pnError);

// Get track speed
AXCAPI BOOL WINAPI AXC_GetTrackSpeed(HAXC hAXC, double *pdSpeed, UINT uChannel, UINT uMode, int *pnError);

// Get track speed table
AXCAPI BOOL WINAPI AXC_GetTrackSpeedTable(HAXC hAXC, double *pdTable, UINT *puBufSize, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Scaled output signal functions - voltage and current clamp
//==============================================================================================

// Set scaled output signal
AXCAPI BOOL WINAPI AXC_SetScaledOutputSignal(HAXC hAXC, UINT uSignal, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output signal
AXCAPI BOOL WINAPI AXC_GetScaledOutputSignal(HAXC hAXC, UINT *puSignal, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output signal table
AXCAPI BOOL WINAPI AXC_GetScaledOutputSignalTable(HAXC hAXC, AXC_Signal *pSignals, UINT uChannel, UINT uMode, int *pnError);

// Set scaled output gain
AXCAPI BOOL WINAPI AXC_SetScaledOutputGain(HAXC hAXC, double dGain, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output gain
AXCAPI BOOL WINAPI AXC_GetScaledOutputGain(HAXC hAXC, double *pdGain, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output gain table
AXCAPI BOOL WINAPI AXC_GetScaledOutputGainTable(HAXC hAXC, double *pdTable, UINT *puBufSize, UINT uChannel, UINT uMode, int *pnError);

// Set scaled output lowpass filter type (Bessel or Butterworth)
AXCAPI BOOL WINAPI AXC_SetScaledOutputLPFType(HAXC hAXC, UINT uType, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output lowpass filter type (Bessel or Butterworth)
AXCAPI BOOL WINAPI AXC_GetScaledOutputLPFType(HAXC hAXC, UINT *puType, UINT uChannel, UINT uMode, int *pnError);

// Set scaled output lowpass filter cutoff (-3bB)
AXCAPI BOOL WINAPI AXC_SetScaledOutputLPF(HAXC hAXC, double dLPF, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output lowpass filter cutoff (-3bB)
AXCAPI BOOL WINAPI AXC_GetScaledOutputLPF(HAXC hAXC, double *pdLPF, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output lowpass filter table
AXCAPI BOOL WINAPI AXC_GetScaledOutputLPFTable(HAXC hAXC, double *pdTable, UINT *puBufSize, UINT uChannel, UINT uMode, int *pnError);

// Set scaled output highpass filter cutoff (-3bB)
AXCAPI BOOL WINAPI AXC_SetScaledOutputHPF(HAXC hAXC, double dHPF, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output highpass filter cutoff (-3bB)
AXCAPI BOOL WINAPI AXC_GetScaledOutputHPF(HAXC hAXC, double *pdHPF, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output highpass filter table
AXCAPI BOOL WINAPI AXC_GetScaledOutputHPFTable(HAXC hAXC, double *pdTable, UINT *puBufSize, UINT uChannel, UINT uMode, int *pnError);

// Auto scaled output zero offset
AXCAPI BOOL WINAPI AXC_AutoScaledOutputZero(HAXC hAXC, UINT uChannel, UINT uMode, int *pnError);

// Set scaled output zero offset enable
AXCAPI BOOL WINAPI AXC_SetScaledOutputZeroEnable(HAXC hAXC, BOOL bEnable, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output zero offset enable
AXCAPI BOOL WINAPI AXC_GetScaledOutputZeroEnable(HAXC hAXC, BOOL *pbEnable, UINT uChannel, UINT uMode, int *pnError);

// Set scaled output zero offset level
AXCAPI BOOL WINAPI AXC_SetScaledOutputZeroLevel(HAXC hAXC, double dZero, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output zero offset level
AXCAPI BOOL WINAPI AXC_GetScaledOutputZeroLevel(HAXC hAXC, double *pdZero, UINT uChannel, UINT uMode, int *pnError);

// Get scaled output zero offset range
AXCAPI BOOL WINAPI AXC_GetScaledOutputZeroRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, UINT uMode, int *pnError);

// Get the cached settings (Gain, LPF, HPF & Output Zero) for the specified signal, channel and mode
AXCAPI BOOL WINAPI AXC_GetScaledOutputCacheSettings(HAXC hAXC, AXC_SignalSettings *pSettings, UINT uSignal, UINT uChannel, UINT uMode, int *pnError);

// Get the scale factor (V/V or V/A) for the specified signal
AXCAPI BOOL WINAPI AXC_GetSignalScaleFactor(HAXC hAXC, double *pdScaleFactor, UINT uSignal, int *pnError);

//==============================================================================================
// Sample Rate function - for DCC and DSEVC modes
//==============================================================================================

// Set the sample period when repetitively cycling between current passing and voltage measuring
AXCAPI BOOL WINAPI AXC_SetSamplePeriod(HAXC hAXC, double dPeriod, UINT uChannel, UINT uMode, int *pnError);

// Get the sample period
AXCAPI BOOL WINAPI AXC_GetSamplePeriod(HAXC hAXC, double *pdPeriod, UINT uChannel, UINT uMode, int *pnError);

// Set the sample period range
AXCAPI BOOL WINAPI AXC_GetSamplePeriodRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Gain and lag functions - for DSEVC and TEVC modes
//==============================================================================================

// Set the DSEVC/TEVC loop gain
AXCAPI BOOL WINAPI AXC_SetLoopGain(HAXC hAXC, double dGain, UINT uChannel, UINT uMode, int *pnError);

// Get the DSEVC/TEVC loop gain
AXCAPI BOOL WINAPI AXC_GetLoopGain(HAXC hAXC, double *pdGain, UINT uChannel, UINT uMode, int *pnError);

// Get the DSEVC/TEVC loop range
AXCAPI BOOL WINAPI AXC_GetLoopGainRange(HAXC hAXC, AXC_PropertyRange *pRange, UINT uChannel, UINT uMode, int *pnError);

// Set the DSEVC/TEVC loop lag
AXCAPI BOOL WINAPI AXC_SetLoopLag(HAXC hAXC, double dLag, UINT uChannel, UINT uMode, int *pnError);

// Get the DSEVC/TEVC loop lag
AXCAPI BOOL WINAPI AXC_GetLoopLag(HAXC hAXC, double *pdLag, UINT uChannel, UINT uMode, int *pnError);

// Get the DSEVC/TEVC loop lag table
AXCAPI BOOL WINAPI AXC_GetLoopLagTable(HAXC hAXC, double *pdTable, UINT *puBufSize, UINT uChannel, UINT uMode, int *pnError);

// Set the DC restore enable
AXCAPI BOOL WINAPI AXC_SetDCRestoreEnable(HAXC hAXC, BOOL bEnable, UINT uChannel, UINT uMode, int *pnError);

// Get the DC restore enable
AXCAPI BOOL WINAPI AXC_GetDCRestoreEnable(HAXC hAXC, BOOL *pbEnable, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Audio functions
//==============================================================================================

// Set the audio enable
AXCAPI BOOL WINAPI AXC_SetAudioEnable(HAXC hAXC, BOOL bEnable, int *pnError);

// Get the audio enable
AXCAPI BOOL WINAPI AXC_GetAudioEnable(HAXC hAXC, BOOL *pbEnable, int *pnError);

// Set the audio gain
AXCAPI BOOL WINAPI AXC_SetAudioGain(HAXC hAXC, UINT uGain, int *pnError);

// Get the audio gain
AXCAPI BOOL WINAPI AXC_GetAudioGain(HAXC hAXC, UINT *puGain, int *pnError);

// Get the audio gain range
AXCAPI BOOL WINAPI AXC_GetAudioGainRange(HAXC hAXC, AXC_PropertyRange *pRange, int *pnError);

// Set the audio mode
AXCAPI BOOL WINAPI AXC_SetAudioMode(HAXC hAXC, UINT uMode, int *pnError);

// Get the audio mode
AXCAPI BOOL WINAPI AXC_GetAudioMode(HAXC hAXC, UINT *puMode, int *pnError);

// Set the audio signal
AXCAPI BOOL WINAPI AXC_SetAudioSignal(HAXC hAXC, UINT uSignal, UINT uChannel, UINT uMode, int *pnError);

// Get the audio signal
AXCAPI BOOL WINAPI AXC_GetAudioSignal(HAXC hAXC, UINT *puSignal, UINT uChannel, UINT uMode, int *pnError);

//==============================================================================================
// Scope functions
//==============================================================================================

// Set the scope mode
AXCAPI BOOL WINAPI AXC_SetScopeMode(HAXC hAXC, UINT uMode, int *pnError);

// Get the scope mode
AXCAPI BOOL WINAPI AXC_GetScopeMode(HAXC hAXC, UINT *puMode, int *pnError);


//==============================================================================================
// Diagnostic functions
//==============================================================================================

// Get the number of commands sent to device
AXCAPI BOOL WINAPI AXC_GetCommandCount(HAXC hAXC, UINT *puCount, int *pnError);

// Get the mean command time in milliseconds
AXCAPI BOOL WINAPI AXC_GetMeanCommandTime(HAXC hAXC, double *pdMean, int *pnError);

//==============================================================================================
// Error functions
//==============================================================================================

// Build error text
AXCAPI BOOL WINAPI AXC_BuildErrorText(HAXC hAXC, int nErrorNum, LPSTR sTxtBuf, UINT uMaxLen);

//==============================================================================================
// Error codes
//==============================================================================================

// General error codes.
const int AXC_ERR_NOERROR                         = 0;
const int AXC_ERR_BASE                            = 9000;                               
const int AXC_ERR_OUTOFMEMORY                     = AXC_ERR_BASE + 1;
const int AXC_ERR_NOTOPEN                         = AXC_ERR_BASE + 2;
const int AXC_ERR_ALREADYOPEN                     = AXC_ERR_BASE + 3;
const int AXC_ERR_ALREADYCLOSED                   = AXC_ERR_BASE + 4;
const int AXC_ERR_BUFFEROVERFLOW                  = AXC_ERR_BASE + 5;
const int AXC_ERR_BADCMDSYNTAX                    = AXC_ERR_BASE + 6;
const int AXC_ERR_UNKNOWNDEVICE                   = AXC_ERR_BASE + 7;
const int AXC_ERR_PROPERTYNOTFOUND                = AXC_ERR_BASE + 8;
const int AXC_ERR_INITIALIZEFAILED                = AXC_ERR_BASE + 9;
const int AXC_ERR_INVALIDDLLHANDLE                = AXC_ERR_BASE + 10;
const int AXC_ERR_INVALIDPARAMETER                = AXC_ERR_BASE + 11;
const int AXC_ERR_INVALIDCHANNEL                  = AXC_ERR_BASE + 12;
const int AXC_ERR_INVALIDMODE                     = AXC_ERR_BASE + 13;
const int AXC_ERR_INVALIDSIGNAL                   = AXC_ERR_BASE + 14;
const int AXC_ERR_INVALIDMETER                    = AXC_ERR_BASE + 15;
const int AXC_ERR_INVALIDHEADSTAGE                = AXC_ERR_BASE + 16;
const int AXC_ERR_INVALIDPIPETTEOFFSET            = AXC_ERR_BASE + 17;
const int AXC_ERR_INVALIDBRIDGEBALANCE            = AXC_ERR_BASE + 18;
const int AXC_ERR_PIPETTEOFFSETLOCKED             = AXC_ERR_BASE + 19;
const int AXC_ERR_BRIDGELOCKED                    = AXC_ERR_BASE + 20;
const int AXC_ERR_TRIGGERCMDFAILED                = AXC_ERR_BASE + 21;
const int AXC_ERR_CANNOTUSEVGHEADSTAGEONMAINPORT  = AXC_ERR_BASE + 22;
const int AXC_ERR_CANNOTUSEHOLDINGWITHTRACK       = AXC_ERR_BASE + 23;
const int AXC_ERR_CANNOTUSETRACKWITHHOLDING       = AXC_ERR_BASE + 24;
const int AXC_ERR_VALUEOUTOFRANGE                 = AXC_ERR_BASE + 25;
const int AXC_ERR_INVALIDCONFIGFILE               = AXC_ERR_BASE + 26;

const int AXC_ERR_FIRSTHIDERROR                   = AXC_ERR_BASE + 200;

//==============================================================================================
// Channel identifiers
//==============================================================================================
const UINT AXC_CHAN_1                 = 0;
const UINT AXC_CHAN_2                 = 1;
const UINT AXC_MAX_CHANNELS           = 2;

const UINT AXC_CHAN_ALL               = 2;
const UINT AXC_CHAN_NONE              = 3;

//==============================================================================================
// Scaled Output Channel identifiers
//==============================================================================================
const UINT AXC_SOCHAN_1               = 0;
const UINT AXC_SOCHAN_2               = 1;
const UINT AXC_MAX_SOCHANNELS         = 2;

//==============================================================================================
// Mode identifiers
//==============================================================================================
const UINT AXC_MODE_IZERO             = 0;
const UINT AXC_MODE_ICLAMP            = 1;
const UINT AXC_MODE_DCC               = 2;   
const UINT AXC_MODE_HVIC              = 3;   
const UINT AXC_MODE_DSEVC             = 4;
const UINT AXC_MODE_TEVC              = 5;
const UINT AXC_MAX_MODES              = 6;

const UINT AXC_MODE_NONE              = 6;
const UINT AXC_MODE_ALL               = 7;

//==============================================================================================
// Hardware Type Identifiers
//==============================================================================================
const UINT ACX_HW_TYPE_AC900A      = 0;
const UINT ACX_HW_TYPE_NUMCHOICES  = 1;
const UINT ACX_HW_TYPE_CURRENT     = ACX_HW_TYPE_AC900A;

//==============================================================================================
// Hardware Type Names
//==============================================================================================
static const char* ACX_HW_TYPE_NAMES[ACX_HW_TYPE_NUMCHOICES] =
{
   "Axoclamp 900A",
};

//==============================================================================================
// Default strings
//==============================================================================================
static LPCSTR g_pszConfigDefault  = "AXC_CONFIG_DEFAULT";
const char c_szDemoSerialNumber[] = "Demo";

//==============================================================================================
// Auto identifiers
//==============================================================================================

// voltage clamp options
const UINT AXC_AUTO_TEVC              = 0;
const UINT AXC_AUTO_DSEVC             = 1;

// "return to IC" options
const UINT AXC_AUTO_ICRETURN_MANUAL   = 0;
const UINT AXC_AUTO_ICRETURN_EXTERNAL = 1;
const UINT AXC_AUTO_ICRETURN_DELAY    = 2;

// Polarity options
const UINT AXC_AUTO_POLARITY_NTOP     = 0;
const UINT AXC_AUTO_POLARITY_PTON     = 1;

// Signal source options
const UINT AXC_AUTO_SOURCE_EXTERNAL   = 0;
const UINT AXC_AUTO_SOURCE_INTERNAL   = 1;

//==============================================================================================
// Signal identifiers
//==============================================================================================
const UINT AXC_SIGNAL_ID_XICMD1      = 0;
const UINT AXC_SIGNAL_ID_ICMD1       = 1;
const UINT AXC_SIGNAL_ID_10V1        = 2;
const UINT AXC_SIGNAL_ID_I1          = 3;
const UINT AXC_SIGNAL_ID_MON         = 4;
const UINT AXC_SIGNAL_ID_RMP         = 5;
const UINT AXC_SIGNAL_ID_XICMD2      = 6;
const UINT AXC_SIGNAL_ID_ICMD2       = 7;
const UINT AXC_SIGNAL_ID_10V2        = 8;
const UINT AXC_SIGNAL_ID_I2          = 9;
const UINT AXC_SIGNAL_ID_DIV10V2     = 10;
const UINT AXC_SIGNAL_ID_DIV10I2     = 11;
const UINT AXC_SIGNAL_ID_XVCMD       = 12;
const UINT AXC_SIGNAL_ID_VCMD        = 13;
const UINT AXC_SIGNAL_ID_10AUX1      = 14;
const UINT AXC_SIGNAL_ID_10AUX2      = 15;
const UINT AXC_SIGNAL_ID_10mV        = 16;
const UINT AXC_SIGNAL_ID_GND         = 17;

//==============================================================================================
// Signal names
//==============================================================================================
const char AXC_SIGNAL_NAME_XICMD1[]  = "Headstage 1, External Current Command";
const char AXC_SIGNAL_NAME_ICMD1[]   = "Headstage 1, Current Command";
const char AXC_SIGNAL_NAME_10V1[]    = "Headstage 1, Membrane Potential";
const char AXC_SIGNAL_NAME_I1[]      = "Headstage 1, Membrane Current";
const char AXC_SIGNAL_NAME_MON[]     = "Headstage 1, DCC Monitor";
const char AXC_SIGNAL_NAME_RMP[]     = "Resting Membrane Potential";
const char AXC_SIGNAL_NAME_XICMD2[]  = "Headstage 2, External Command Current";
const char AXC_SIGNAL_NAME_ICMD2[]   = "Headstage 2, Command Current";
const char AXC_SIGNAL_NAME_10V2[]    = "Headstage 2, Membrane Potential";
const char AXC_SIGNAL_NAME_I2[]      = "Headstage 2, Membrane Current";
const char AXC_SIGNAL_NAME_DIV10V2[] = "Headstage 2, 0.1x Membrane Potential";
const char AXC_SIGNAL_NAME_DIV10I2[] = "Headstage 2, 0.1x Membrane Current";
const char AXC_SIGNAL_NAME_XVCMD[]   = "External Command Potential";
const char AXC_SIGNAL_NAME_VCMD[]    = "Command Potential";
const char AXC_SIGNAL_NAME_10AUX1[]  = "Auxiliary 1";
const char AXC_SIGNAL_NAME_10AUX2[]  = "Auxiliary 2";
const char AXC_SIGNAL_NAME_10mV[]    = "10mV DC Test signal ";
const char AXC_SIGNAL_NAME_GND[]     = "Ground ";

const UINT AXC_MAX_SIGNALS           = 18;

static AXC_Signal s_Signals[AXC_MAX_SIGNALS] =
{
   { AXC_CHAN_1,    AXC_SIGNAL_ID_XICMD1,  AXC_SIGNAL_NAME_XICMD1,  TRUE },
   { AXC_CHAN_1,    AXC_SIGNAL_ID_ICMD1,   AXC_SIGNAL_NAME_ICMD1,   TRUE },
   { AXC_CHAN_1,    AXC_SIGNAL_ID_10V1,    AXC_SIGNAL_NAME_10V1,    TRUE },
   { AXC_CHAN_1,    AXC_SIGNAL_ID_I1,      AXC_SIGNAL_NAME_I1,      TRUE },
   { AXC_CHAN_1,    AXC_SIGNAL_ID_MON,     AXC_SIGNAL_NAME_MON,     TRUE },
   { AXC_CHAN_1,    AXC_SIGNAL_ID_RMP,     AXC_SIGNAL_NAME_RMP,     TRUE },
   { AXC_CHAN_2,    AXC_SIGNAL_ID_XICMD2,  AXC_SIGNAL_NAME_XICMD2,  TRUE },
   { AXC_CHAN_2,    AXC_SIGNAL_ID_ICMD2,   AXC_SIGNAL_NAME_ICMD2,   TRUE },
   { AXC_CHAN_2,    AXC_SIGNAL_ID_10V2,    AXC_SIGNAL_NAME_10V2,    TRUE },
   { AXC_CHAN_2,    AXC_SIGNAL_ID_I2,      AXC_SIGNAL_NAME_I2,      TRUE },
   { AXC_CHAN_2,    AXC_SIGNAL_ID_DIV10V2, AXC_SIGNAL_NAME_DIV10V2, TRUE },
   { AXC_CHAN_2,    AXC_SIGNAL_ID_DIV10I2, AXC_SIGNAL_NAME_DIV10I2, TRUE },
   { AXC_CHAN_ALL,  AXC_SIGNAL_ID_XVCMD,   AXC_SIGNAL_NAME_XVCMD,   TRUE },
   { AXC_CHAN_ALL,  AXC_SIGNAL_ID_VCMD,    AXC_SIGNAL_NAME_VCMD,    TRUE },
   { AXC_CHAN_NONE, AXC_SIGNAL_ID_10AUX1,  AXC_SIGNAL_NAME_10AUX1,  TRUE },
   { AXC_CHAN_NONE, AXC_SIGNAL_ID_10AUX2,  AXC_SIGNAL_NAME_10AUX2,  TRUE },
   { AXC_CHAN_NONE, AXC_SIGNAL_ID_10mV,    AXC_SIGNAL_NAME_10mV,    TRUE },
   { AXC_CHAN_NONE, AXC_SIGNAL_ID_GND,     AXC_SIGNAL_NAME_GND,     TRUE }
};

//==============================================================================================
// Signal Gains - fixed
//==============================================================================================
const double AXC_SIGNAL_GAIN_X100    = 1.0e+2;
const double AXC_SIGNAL_GAIN_X10     = 1.0e+1;
const double AXC_SIGNAL_GAIN_X1      = 1.0e+0;
const double AXC_SIGNAL_GAIN_DIV10   = 1.0e-1;

//==============================================================================================
// External Command Sensitivity 
//==============================================================================================
const double AXC_EXTCMD_RANGE_VOLTS  = 0.10;
const double AXC_EXTCMD_GAIN_VC      = 0.02;   // V/V

//==============================================================================================
// LPF filter type identifiers
//==============================================================================================
const UINT AXC_SIGNAL_LPFTYPE_BESSEL      = 0;
const UINT AXC_SIGNAL_LPFTYPE_BUTTERWORTH = 1;

//==============================================================================================
// oscillation killer identifiers
//==============================================================================================
const UINT AXC_OSCKILLER_METHOD_DISABLE   = 0;
const UINT AXC_OSCKILLER_METHOD_REDUCE    = 1;

//==============================================================================================
// meter identifiers
//==============================================================================================

// Meter Mux IDs
const UINT AXC_MAX_METERS              = 4;

const UINT AXC_METER_MUX_1             = 0;
const UINT AXC_METER_MUX_2             = 1;
const UINT AXC_METER_MUX_3             = 2;
const UINT AXC_METER_MUX_4             = 3;

// Meter signals
const UINT AXC_METER_SIGNAL_MIN        = 0;
const UINT AXC_METER_SIGNAL_MAX        = 40;

const UINT AXC_METER_SIGNAL_CH1_XICMD  = 0;  // Ch1 External command current
const UINT AXC_METER_SIGNAL_CH1_ICMD   = 1;  // Ch1 Headstage command current
const UINT AXC_METER_SIGNAL_CH1_I      = 2;  // Ch1 Headstage current
const UINT AXC_METER_SIGNAL_CH1_10V    = 3;  // Ch1 Headstage voltage x10
const UINT AXC_METER_SIGNAL_SO1        = 4;  // Scaled output 1 voltage (either channel)
const UINT AXC_METER_SIGNAL_XVCMD      = 5;  // External command voltage (either channel)
const UINT AXC_METER_SIGNAL_VCMD       = 6;  // Headstage command voltage (either channel)
const UINT AXC_METER_SIGNAL_RMP        = 7;  // Resting Membrane potential (prior to closing TEVC feedback loop)
const UINT AXC_METER_SIGNAL_CH1_VCRES  = 8;  // Ch1 Voltage clamp resistance
const UINT AXC_METER_SIGNAL_CH1_ICRES  = 9;  // Ch1 Current clamp resistance

const UINT AXC_METER_SIGNAL_CH2_XICMD  = 10; // Ch2 External command current
const UINT AXC_METER_SIGNAL_CH2_ICMD   = 11; // Ch2 Headstage command current
const UINT AXC_METER_SIGNAL_CH2_I      = 12; // Ch2 Headstage current
const UINT AXC_METER_SIGNAL_CH2_DIV10I = 13; // Ch2 Headstage current x0.1
const UINT AXC_METER_SIGNAL_CH2_10V    = 14; // Ch2 Headstage voltage x10
const UINT AXC_METER_SIGNAL_CH2_DIV10V = 15; // Ch2 Headstage voltage x0.1
const UINT AXC_METER_SIGNAL_SO2        = 16; // Scaled output 2 voltage (either channel)
const UINT AXC_METER_SIGNAL_UNUSED1    = 17; // Not used
const UINT AXC_METER_SIGNAL_CH2_VCRES  = 18; // Ch2 Voltage clamp resistance
const UINT AXC_METER_SIGNAL_CH2_ICRES  = 19; // Ch2 Current clamp resistance

const UINT AXC_METER_SIGNAL_10AUX1     = 20; // Auxiliary 1 x10
const UINT AXC_METER_SIGNAL_MON        = 21; // Monitor signal
const UINT AXC_METER_SIGNAL_10AUX2     = 22; // Auxiliary 2 x10
const UINT AXC_METER_SIGNAL_VREF       = 23; // Voltage reference
const UINT AXC_METER_SIGNAL_1V         = 24; // 1V supply
const UINT AXC_METER_SIGNAL_GND        = 25; // Analog Ground
const UINT AXC_METER_SIGNAL_UNUSED2    = 26; // Not used
const UINT AXC_METER_SIGNAL_UNUSED3    = 27; // Not used
const UINT AXC_METER_SIGNAL_PLUS200V   = 28; // +200V supply
const UINT AXC_METER_SIGNAL_MINUS200V  = 29; // -200V supply

const UINT AXC_METER_SIGNAL_PLUS15V    = 30; // +15V supply
const UINT AXC_METER_SIGNAL_MINUS15V   = 31; // -15V supply
const UINT AXC_METER_SIGNAL_PLUS5V     = 32; // +5V  supply
const UINT AXC_METER_SIGNAL_MINUS5V    = 33; // -5V  supply
const UINT AXC_METER_SIGNAL_PLUS35V    = 34; // +35V supply
const UINT AXC_METER_SIGNAL_MINUS35V   = 35; // -35V supply
const UINT AXC_METER_SIGNAL_ID1        = 36; // ?
const UINT AXC_METER_SIGNAL_ID2        = 37; // ?
const UINT AXC_METER_SIGNAL_ID3        = 38; // ?
const UINT AXC_METER_SIGNAL_ID4        = 39; // ?
const UINT AXC_METER_SIGNAL_UNUSED4    = 40; // Not used
                   
//==============================================================================================
// Clear Electrode identifiers
//==============================================================================================
const UINT AXC_CLEAR_OFF                  = 0;   // internal use only
const UINT AXC_CLEAR_POLARITY_POSITIVE    = 1;
const UINT AXC_CLEAR_POLARITY_NEGATIVE    = 2;

//==============================================================================================
// Headstage types - 6 to 19 reserved for future headstages
//==============================================================================================
const UINT AXC_HEADSTAGE_TYPE_HS9_ADAPTER          = 0;   // custom headstage, user entered Rf and Ci value
const UINT AXC_HEADSTAGE_TYPE_HS9_x10uA            = 1;   // Rf = 1M
const UINT AXC_HEADSTAGE_TYPE_HS9_x1uA             = 2;   // Rf = 10M
const UINT AXC_HEADSTAGE_TYPE_HS9_x100nA           = 3;   // Rf = 100M
const UINT AXC_HEADSTAGE_TYPE_VG9_x10uA            = 4;   // Rf = 1M
const UINT AXC_HEADSTAGE_TYPE_VG9_x100uA           = 5;   // Rf = 0.1M
const UINT AXC_HEADSTAGE_TYPE_NONE                 = 20;  // headstage not connected

//==============================================================================================
// Headstage names
//==============================================================================================
static const char AXC_HEADSTAGE_NAME_HS9_ADAPTER[] = "Custom";        // custom headstage, user entered Rf value
static const char AXC_HEADSTAGE_NAME_HS9_x10uA[]   = "HS-9A x10";     // Rf = 1M
static const char AXC_HEADSTAGE_NAME_HS9_x1uA[]    = "HS-9A x1";      // Rf = 10M
static const char AXC_HEADSTAGE_NAME_HS9_x100nA[]  = "HS-9A x0.1";    // Rf = 100M
static const char AXC_HEADSTAGE_NAME_VG9_x10uA[]   = "VG-9A x10";     // Rf = 1M
static const char AXC_HEADSTAGE_NAME_VG9_x100uA[]  = "VG-9A x100";    // Rf = 0.1M
static const char AXC_HEADSTAGE_NAME_NONE[]        = "Not Connected"; // headstage not connected

//==============================================================================================
// Headstage feedback resistor values
//==============================================================================================
const double AXC_HEADSTAGE_RF_ADAPTER_DEFAULT      = 1.0e+6; // Rf = 1M
const double AXC_HEADSTAGE_RF_HS9_x10uA            = 1.0e+6; // Rf = 1M
const double AXC_HEADSTAGE_RF_HS9_x1uA             = 1.0e+7; // Rf = 10M
const double AXC_HEADSTAGE_RF_HS9_x100nA           = 1.0e+8; // Rf = 100M
const double AXC_HEADSTAGE_RF_VG9_x10uA            = 1.0e+6; // Rf = 1M
const double AXC_HEADSTAGE_RF_VG9_x100uA           = 1.0e+5; // Rf = 0.1M

//==============================================================================================
// Headstage injection capacitor values
//=============================================================================================
const double  AXC_HEADSTAGE_CI_ADAPTER_DEFAULT     = 10.0e-12; // Ci = 10pF
const double  AXC_HEADSTAGE_CI_HS9_x10uA           = 10.0e-12; // Ci = 10pF
const double  AXC_HEADSTAGE_CI_HS9_x1uA            = 10.0e-12; // Ci = 10pF
const double  AXC_HEADSTAGE_CI_HS9_x100nA          = 10.0e-12; // Ci = 10pF
const double  AXC_HEADSTAGE_CI_VG9_x10uA           = 10.0e-12; // Ci = 10pF
const double  AXC_HEADSTAGE_CI_VG9_x100uA          = 10.0e-12; // Ci = 10pF

//==============================================================================================
// Audio identifiers
//==============================================================================================
const UINT AXC_AUDIO_MODE_DIRECT  = 0;
const UINT AXC_AUDIO_MODE_VCO     = 1;

const UINT AXC_AUDIO_SIGNAL_I1    = 0;  
const UINT AXC_AUDIO_SIGNAL_I2    = 1;  
const UINT AXC_AUDIO_SIGNAL_10V1  = 2;  
const UINT AXC_AUDIO_SIGNAL_10V2  = 3;  

//==============================================================================================
// Audio signal names
//==============================================================================================
const char AXC_AUDIO_NAME_I[]   = "Membrane Current";
const char AXC_AUDIO_NAME_10V[] = "Membrane Potential";

//==============================================================================================
// Scope identifiers
//==============================================================================================
const UINT AXC_SCOPE_MODE_DCC          = 0;
const UINT AXC_SCOPE_MODE_SCLDOUTPUT   = 1; 

//==============================================================================================
// Sync output identifiers
//==============================================================================================
const UINT AXC_SYNCOUTPUT_CH1_OSC      = 0; // Channel 1 oscillator
const UINT AXC_SYNCOUTPUT_CH2_OSC      = 1; // Channel 2 oscillator
const UINT AXC_SYNCOUTPUT_MODE         = 2; // Amplifier mode

const UINT AXC_SYNCOUTPUT_AUTO_DISABLE = 0; // Sync does not follow active channel
const UINT AXC_SYNCOUTPUT_AUTO_OSC     = 1; // Oscillator sync follows active channel

//==============================================================================================
// string sizes
//==============================================================================================
const UINT AXC_STRSIZE_SN              = 16;  // serial number string size
const UINT AXC_STRSIZE_TX              = 16;  // USB output report string size
const UINT AXC_STRSIZE_RX              = 16;  // USB input report string size
const UINT AXC_STRSIZE_ERR             = 256; // error text string size

} // end of extern "C"

#endif // INC_AXOCLAMPDRIVER_H