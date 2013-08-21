Rem Script created: 01.09.2005 22:28
Rem By: cecs06
Rem Script language: VBScript
Rem Original Workspace: Default

Set Test = CreateObject("Autotest.AUTO")
test.Set 3
X = test.value
MsgBox X
Set test = None
