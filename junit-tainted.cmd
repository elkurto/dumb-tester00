@echo on

REM conditionally remove trailing backslash
set SCRIPTDIR=%~dp0
if "%SCRIPTDIR:~-1%"=="\" set "SCRIPTDIR=%SCRIPTDIR:~0,-1%"

set PROJBASEDIR=%CD%
REM conditionally remove trailing backslash
if "%PROJBASEDIR:~-1%"=="\" set "PROJBASEDIR=%PROJBASEDIR:~0:-1%"
set PROJBASEDIR=%PROJBASEDIR:\=/%