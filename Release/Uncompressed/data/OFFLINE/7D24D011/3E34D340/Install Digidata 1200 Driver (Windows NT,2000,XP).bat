echo off
rem
rem Digidata 1200 Driver installation batch file for Windows NT,2000,XP
rem
if not exist "c:\winwcp\Digidata 1200 Support (Win 2000)\setup_nt.INF" goto NotC
  RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 130 c:\winwcp\Digidata 1200 Support (Win 2000)\setup_nt.INF
  goto End
:NotC

if not exist "d:\winwcp\Digidata 1200 Support (Win 2000)\setup_nt.INF" goto NotD
  RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 130 d:\winwcp\Digidata 1200 Support (Win 2000)\setup_nt.INF
  Goto End
:NotD

if not exist "e:\winwcp\Digidata 1200 Support (Win 2000)\setup_nt.INF" goto NotE
  RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 130 e:\winwcp\Digidata 1200 Support (Win 2000)\setup_nt.INF
  Goto End
:NotE

:End

