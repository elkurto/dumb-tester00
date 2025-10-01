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

REM accumulate lis of jars (space separated)

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

endlocal

popd