@ECHO off
TITLE Downloading NadekoBot, please wait
::Setting convenient to read variables which don't delete the windows temp folder
SET root=%~dp0
CD /D %root%
SET rootdir=%cd%
SET build=%root%NadekoInstall_Temp\NadekoBot\src\NadekoBot\
SET rootinstall=%root%NadekoInstall_Temp\NadekoBot\
SET installtemp=%root%NadekoInstall_Temp\
::Deleting traces of last setup for the sake of clean folders, if by some miracle it still exists
IF EXIST "%root%NadekoInstall_Temp\" ( RMDIR "%root%NadekoInstall_Temp" /S /Q )
::Checks that both git and dotnet are installed
dotnet --version >nul 2>&1 || GOTO :dotnet
git --version >nul 2>&1 || GOTO :git
::Creates the install directory to work in and get the current directory because spaces ruins everything otherwise
MKDIR NadekoInstall_Temp
CD /D %installtemp%
::Downloads the latest version of Nadeko
git clone -b 1.0 --recursive -v https://github.com/Kwoth/NadekoBot.git >nul
TITLE Installing NadekoBot, please wait
ECHO Installing...
::Building Nadeko
CD /D %rootinstall%
dotnet restore >nul 2>&1
CD /D %build%
dotnet build --configuration Release >nul 2>&1
::Attempts to backup old files if they currently exist in the same folder as the batch file
IF EXIST "%root%NadekoBot\" (GOTO :backupinstall)
:freshinstall
	::Moves the NadekoBot folder to keep things tidy
	ROBOCOPY "%root%NadekoInstall_Temp" "%rootdir%" /E /MOVE >nul 2>&1
	GOTO :end
:backupinstall
	TITLE Backing up old files
	::Recursively copies all files and folders from NadekoBot to NadekoBot_Old
	ROBOCOPY "%root%NadekoBot" "%root%NadekoBot_Old" /E /MOVE >nul 2>&1
	ECHO.
	ECHO Old files backed up to NadekoBot_Old
	::Moves the setup Nadeko folder
	ROBOCOPY "%root%NadekoInstall_Temp" "%rootdir%" /E /MOVE >nul 2>&1
	::Copies the credentials and database from the backed up data to the new folder
	COPY "%root%NadekoBot_Old\src\NadekoBot\credentials.json" "%root%NadekoBot\src\NadekoBot\credentials.json" >nul 2>&1
	ECHO.
	ECHO credentials.json copied to new folder
	ROBOCOPY "%root%NadekoBot_Old\src\NadekoBot\bin" "%root%NadekoBot\src\NadekoBot\bin" /E >nul 2>&1
	ECHO.
	ECHO Old bin folder copied to new folder
	ROBOCOPY "%root%NadekoBot_Old\src\NadekoBot\data" "%root%NadekoBot\src\NadekoBot\data" /E >nul 2>&1
	ECHO.
	ECHO Old data folder copied to new folder
	GOTO :end
:dotnet
	::Terminates the batch script if it can't run dotnet --version
	TITLE Error!
	ECHO dotnet not found, make sure it's been installed as per the guides instructions!
	ECHO Press any key to exit.
	PAUSE >nul 2>&1
	CD /D "%root%"
	GOTO :EOF
:git
	::Terminates the batch script if it can't run git --version
	TITLE Error!
	ECHO git not found, make sure it's been installed as per the guides instructions!
	ECHO Press any key to exit.
	PAUSE >nul 2>&1
	CD /D "%root%"
	GOTO :EOF
:end
	::Normal execution of end of script
	TITLE Installation complete!
	CD /D "%root%" 
	RMDIR /S /Q "%installtemp%" >nul 2>&1
	ECHO.
	ECHO Installation complete, press any key to close this window!
	PAUSE >nul 2>&1