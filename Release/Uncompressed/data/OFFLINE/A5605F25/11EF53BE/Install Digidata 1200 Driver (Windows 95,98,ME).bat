echo off
rem
rem Digidata 1200 Driver installation batch file for Windows 95, 98, ME
rem
if not exist "c:\winwcp\Digidata 1200 Support\setup_9x.INF" goto NotC
  RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 130 c:\winwcp\Digidata 1200 Support\setup_9x.INF
  goto End
:NotC

if not exist "d:\winwcp\Digidata 1200 Support\setup_9x.INF" goto NotD
  RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 130 d:\winwcp\Digidata 1200 Support\setup_9x.INF
  Goto End
:NotD

if not exist "e:\winwcp\Digidata 1200 Support\setup_9x.INF" goto NotE
  RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 130 e:\winwcp\Digidata 1200 Support\setup_9x.INF
  Goto End
:NotE

:End
echo Please Restart Windows
pause

