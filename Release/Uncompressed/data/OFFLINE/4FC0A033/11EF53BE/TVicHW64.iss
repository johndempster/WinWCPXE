;===============================================================
;==                                                           ==
;== This Inno Setup script file is an example of how          ==
;== to make  a TVicHW32-based application installation        ==
;== for Windows XP 64-bit version                             ==
;==                                                           ==
;== Please read this script carefully and change the company  ==
;== name (MySuperCompany) as well as the application name     ==
;== (MySuperApplication) anywhere in this file.               ==
;== Change copyright line, URLs,  and so on.                  ==
;== Also you must provide your own LICENSE.TXT file.          ==
;==                                                           ==
;== The Inno Setup compiler is free, you can download it at   ==
;==           http://www.innosetup.com                        ==
;==                                                           ==
;== Good luck!                                                ==
;==                                                           ==
;===============================================================
;== Victor Ishikeev, tools@entechtaiwan.com                   ==
;===============================================================

[Setup]
AppName=MySuperApplication
AppVerName=MySuperApplication Version 1.0

AppPublisher=MySuperCompany
AppCopyright=Copyright © 2003 MySuperComapny
AppPublisherURL=http://www.MySuperCompany.com
AppSupportURL=http://www.MySuperCompany.com/support.htm
AppUpdatesURL=http://www.MySuperCompany.com/MySuperApplication.htm
DefaultDirName={pf}\MySuperCompany\MySuperApplication
DefaultGroupName=MySuperApplication

; you must provide your own LICENSE.TXT file
LicenseFile=LICENSE.TXT

; name of your installation exe-file
OutputBaseFilename=MySuperApplicationSetup64

MinVersion=0,5.2
PrivilegesRequired=admin
AlwaysRestart=yes

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:";

[Files]

; Core Files - do not remove
; this line installs the TVicHW64.sys driver
Source: "TVicHW64.sys"; DestDir: "{win}\system32\drivers"; Flags: ignoreversion
Source: "TVicHW32.dll"; DestDir: "{win}\system32\drivers"; Flags: ignoreversion

; change application name
Source: "MySuperApplication.exe"; DestDir: "{app}"; Flags: ignoreversion

; the Inno Setup Installation script (this file)
Source: "TVicHW64.iss"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; uncomment these lines if you want create icons
;Name: "{group}\MySuperApplication"; Filename: "{app}\MySuperApplication.exe"
;Name: "{userdesktop}\MySuperApplication"; Filename: "{app}\MySuperApplication.exe"; MinVersion: 4,4; Tasks: desktopicon
Name: "{group}\Uninstall MySuperApplication"; Filename: "{uninstallexe}"


[Registry]
; Start "Software\MySuperCompany\MySuperApplication" keys under HKEY_CURRENT_USER
; and HKEY_LOCAL_MACHINE. The flags tell it to always delete the
; "MySuperApplication" keys upon uninstall, and delete the "MySuperCompany" keys
; if there is nothing left in them.

Root: HKCU; Subkey: "Software\MySuperCompany"; Flags: uninsdeletekeyifempty
Root: HKCU; Subkey: "Software\MySuperCompany\MySuperApplication"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\MySuperCompany"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\MySuperCompany\MySuperApplication"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\MySuperCompany\MySuperApplication\Settings"; ValueType: string; ValueName: "Path"; ValueData: "{app}"

; DO NOT REMOVE OR CHANGE THE FOLLOWING 5 LINES (starts the driver after you reboot)

Root: HKLM; Subkey: "System\CurrentControlSet\Services\TVicHW64"; ValueType: dword;  ValueName: "Type";         ValueData: "1"; Flags: uninsdeletekey
Root: HKLM; Subkey: "System\CurrentControlSet\Services\TVicHW64"; ValueType: dword;  ValueName: "Start";        ValueData: "2"; Flags: uninsdeletekey
Root: HKLM; Subkey: "System\CurrentControlSet\Services\TVicHW64"; ValueType: dword;  ValueName: "ErrorControl"; ValueData: "1"; Flags: uninsdeletekey
Root: HKLM; Subkey: "System\CurrentControlSet\Services\TVicHW64"; ValueType: string; ValueName: "Group";        ValueData: "Extended Base"; Flags: uninsdeletekey
Root: HKLM; Subkey: "System\CurrentControlSet\Services\TVicHW64"; ValueType: string; ValueName: "Parameters";   ValueData: ""; Flags: uninsdeletekey
Root: HKLM; Subkey: "System\CurrentControlSet\Services\TVicHW64"; ValueType: string; ValueName: "ImagePath";    ValueData: "\??\{win}\system32\drivers\tvichw64.sys"; Flags: uninsdeletekey

[Run]
Filename: "{app}\cpd64.exe"; Parameters: "TVicHW64.sys"

