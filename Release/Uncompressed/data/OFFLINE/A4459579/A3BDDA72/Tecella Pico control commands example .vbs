Rem Script created: 01.09.2005 22:28
Rem By: cecs06
Rem Script language: VBScript
Rem Original Workspace: Default

Set W = CreateObject("winwcp.AUTO")

' Start seal test pulses
W.StartSealTest

Input = CInt(InputBox("Set input (0=None, 1=Head, 2=VMODEL)?"))
W.PicoInput = Input


iGain = CInt(InputBox("Set Gain (0=10M, 1=100M, 2=1G, 3=3G, 4=10G)?"))
W.PicoGain = iGain

iFilter = Cint(InputBox("Set LP filter (0=144.7, 100=0.7198 kHz)?"))
W.PicoFilter = iFilter

iConfig = CInt(InputBox("Set Config (0=VCLAMP (255mV) , 2=ICLAMP (2.5nA))?"))
W.PicoConfig = iConfig


msgbox("CLear Cfast and Cslow compensation")
W.PicoClearCompC

msgbox("Auto compensate Cfast")
W.PicoAutoCompCFast

msgbox("Auto cOmpensate CSlow")
W.PicoAutoCompCSlow

msgbox("Get CSlow compensation value")
CSlow = W.PicoCSlowComp 
msgbox( "CSLow= " & CSlow )

msgbox("Get Cfast compensation value")
CFast = W.PicoCFastComp 
msgbox( "CFast= " & CFast )

msgbox( "Disable CSlow compensation" )
W.PicoEnableCSlow = 0

msgbox( "Disable CFast compensation" )
W.PicoEnableCFast = 0

msgbox( "Enable CSlow & CFast " )
W.PicoEnableCFast = 1
W.PicoEnableCSlow = 1

msgbox("CLear junction pot. compensation")
W.PicoClearCompJP

msgbox("Auto compensate junction potential")
W.PicoAutoCompJP

msgbox("Get junction pot. compensation value")
JP = W.PicoJPComp 
msgbox( "JP= " & JP )

msgbox("Disable junction pot. compensation")
W.PicoEnableJP = 0

msgbox("Enable junction pot. compensation")
W.PicoEnableJP = 1

SealResistance = W.RSeal
msgbox( "Seal resistance " & SealResistance & " Ohms" )


