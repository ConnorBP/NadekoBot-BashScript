@ECHO off
@TITLE NadekoBot
CD /D %~dp0NadekoBot\src\NadekoBot
dotnet run --configuration Release
ECHO NadekoBot has been succesfully stopped, press any key to close this window.
TITLE NadekoBot - Stopped
CD /D %~dp0
PAUSE >nul 2>&1
timeout /t 5
del NadekoRunNormal.bat
NadekoWinAIO.bat
