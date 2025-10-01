@echo on

REM conditionally remove trailing backslash
set SCRIPTDIR=%~dp0
if "%SCRIPTDIR:~-1%"=="\" set "SCRIPTDIR=%SCRIPTDIR:~0,-1%"
set "SCRIPTDIR=%SCRIPTDIR:\=/%"
set CURRDIR=%CD%
REM conditionally remove trailing backslash
if "%CURRDIR:~-1%"=="\" set "CURRDIR=%CURRDIR:~0:-1%"
set CURRDIR=%CURRDIR:\=/%


set JAVAFILETEST=a/b/dumbtester00/service/UtiltyATest.java
set "JAVAFILETEST=%JAVAFILETEST:\=/%"
set "CLASSFILETEST=%JAVAFILETEST:~0,-5%"
set "CLASSFILETEST=%JAVAFILETEST:/=.%"


set WEB_INF_LIB_DIR=%CURRDIR%/target/dumbtester00-0.0.1-SNAPSHOT/WEB-INF/lib

set TEMPDIR=%CURRDIR%/temp

mkdir %TEMPDIR:/=\%
pushd %TEMPDIR:/=\%

set "JUNIT_ORIG_JAR=%SCRIPTDIR%/junit-platform-console-standalone-1.13.0-M3.jar"
set "JUNIT_TAINTED_JAR=%TEMPDIR%/junit-tainted.jar"

copy %JUNIT_ORIG_JAR:/=\% %JUNIT_TAINTED_JAR:/=\%

REM a. accumulate lis of jars (space separated)
REM b. wrap each line at 70 chars including leading space " "

setlocal enabledelayedexpansion

set JARLIBDIR=%WEB_INF_LIB_DIR%
set JARLIBDIR_BACKSLASH=%JARLIBDIR:/=\%
set "JARLIBDIR_BACKSLASH=%JARLIBDIR_BACKSLASH:~2%"

set CLASS_PATH_IN_MANIFEST=
for %%F in (%JARLIBDIR_BACKSLASH%\*.jar) do (
    if defined CLASS_PATH_IN_MANIFEST (
        set "CLASS_PATH_IN_MANIFEST=!CLASS_PATH_IN_MANIFEST!" %%F"
    ) else (
        set "CLASS_PATH_IN_MANIFEST=%%F"
    )
)

set "CLASSPATH_TEMP_TXT=%TEMPDIR%/classpath.temp.txt"
set "CLASS_PATH_IN_MANIFEST=Class-Path: %CLASS_PATH_IN_MANIFEST%"

set "LONGSTRING=%CLASS_PATH_IN_MANIFEST%"
set "CHUNK=%LONGSTRING:~0,70%"
set "CHUNK=%CHUNK:\=/%"
echo %CHUNK% > %CLASSPATH_TEMP_TXT%

set "MAXLEN=69"
set "OFFSET=70"
set "ONESPACE= "

:splitloop
set "CHUNK=!LONGSTRING:~%OFFSET%,%MAXLEN%!"
if "!CHUNK!"=="" goto :done
set "CHUNK=%CHUNK\=/%"
set /a OFFSET+=MAXLEN
echo %ONESPACE%%CHUNK% >> %CLASSPATH_TEMP_TXT%
goto :splitloop
:done

REM  extract original manifest
jar -xvf %JUNIT_ORIG_JAR% META-INF/MAIFEST.MF

REM remove trailing empty lines
set "INFILE_TO_STRIP=META-INF\MANIFEST.MF"
set "INFILE_TO_STRIP_TEMP=%INFILE_TO_STRIP%.temp.txt"
del %INFILE_TO_STRIP_TEMP%

for /f "usebackq delims=" %%A in ("%INFILE%") do (
    echo %%A >> %INFILE_TO_STRIP_TEMP%
)

move %INFILE_TO_STRIP_TEMP% %INFILE_TO_STRIP%

REM modify manifest -- add list of jars
type %CLASSPATH_TEMP_TXT:/=\% >> META-INF\MANIFEST.MF

REM update tainted manifest
jar -uvfm %JUNIT_TAINTED_JAR% META-INF/MANIFEST.MF

endlocal

REM popd %TEMPDIR%
popd