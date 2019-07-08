' WinWCP Automation interface Example
' J. Dempster 13-12-05

' Create WinWCP COM object
Set W = CreateObject("Winwcp.AUTO")

W.SealTestGaFromPeak = 1
W.SealTestNumAverages = 8

msgbox("wait")





