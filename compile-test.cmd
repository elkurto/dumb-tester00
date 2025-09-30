@echo off

REM conditionally remove trailing backslash
set SCRIPTDIR=%~dp0
if "%SCRIPTDIR:~1%"=="\" set "SCRIPTDIR=%SCRIPTDIR:~0,-1%"

set PROJBASEDIR=%CD%
REM conditionally remove trailing backslash
if "%PROJBASEDIR:~-1%"=="\" set "PROJBASEDIR=%PROJBASEDIR:~0:-1%"
set PROJBASEDIR=%PROJBASEDIR:\=/%

echo %PROJBASEDIR%

set JAVAFILETEST=a/b/dumbtester00/UtiltyATest.java
set "JAVAFILETEST=%JAVAFILETEST:\=/%"
set "CLASSFILETEST=%JAVAFILETEST:~0,-5%"
set "CLASSFILETEST=%JAVAFILETEST:/=.%"


REM specfy location of jar file depenedencies
set JARLIBDIR=%PROJBASEDIR%/target/dumb-tester00-0.0.1-SNAPSHOT/WEB-INF/lib

