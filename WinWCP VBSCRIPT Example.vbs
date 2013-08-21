' WinWCP Automation interface Example
' J. Dempster 13-12-05

' Create WinWCP COM object
Set W = CreateObject("Winwcp.auto")

' Start seal test pulses
W.StartSealTest

' Set cell parameters smoothing factor (0.1 - 1.0)
' 1 = no smoothing, 
' 0.1 = maximum smoothing (equivalent to averaging over 10 pulses
'
W.SealTestSmoothingFactor = 0.1

' Set patch clamp holding voltage (V)
W.HoldingVoltage = -0.03

' Set seal test pulse amplitude (V)
W.SealTestPulseAmplitude = 0.015

' Set seal test pulse width (secs)
W.SealTestPulseDuration = 0.05

' Read cell parameters back from WinWCP

CellMembraneVoltage = W.Vm
msgbox( "Cell membrane voltage " & CellMembraneVoltage & " V" )

CellMembraneCurrent = W.Im
msgbox( "Cell membrane current " & CellMembraneCurrent & " A" )

SealResistance = W.RSeal
msgbox( "Seal resistance " & SealResistance & " Ohms" )

CellMembraneConductance = W.Gm
msgbox( "Cell Membrane conductance " & CellMembraneConductance & " S" )

CellMembraneCapacity = W.Cm
msgbox( "Cell Membrane capacity " & CellMembraneCapacity & " F" )

PipetteAccessConductance = W.Ga
msgbox( "Pipette access conductance " & PipetteAccessConductance & " S" )

W.NewFile("test_002")
W.TriggerMode="F"
msgbox("Trigger mode = free run")

W.TriggerMode="E"
msgbox("Trigger mode = external")

W.TriggerMode="D"
msgbox("Trigger mode = event detect")

W.TriggerMode="P"
msgbox("Trigger mode = stimulus pulse")

W.StimulusProtocol = "ramp 5s"
msgbox("stimulus protocol = ramp 5s")

W.StartSealTest
msgbox("status = " & W.Status)
W.StartRecording 
msgbox("status = " & W.Status)






