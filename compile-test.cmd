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

set CLASSDIR=%PROJBASEDIR%/target/CLASSFILETEST
set SRCDIR=%PROJBASEDIR%/src/test/java

REM replace / with \ in SRCDIR
set "SRCDIR_BACKSLASH=%SRCDIR=/=\%"

set TESTCLASSDIR=%PROJBASEDIR%/target/test-classes

mkdir "%TESTCLASSDIR:/=\%"

pushd %SRCDIR_BACKSLASH%

echo compiling %JAVAFILETEST%

javac -d %TESTCLASSDIR% -classpath %SRCDIR%;%CLASSDIR%;%SCRIPTDIR%/junit-platform-console-standalone-1.13.0-M3.jar %JAVATESTFILE%

popd

setlocal enabledelayedexpansion

set "JARLIBDIR_BACKSLASH=%JARLIBDIR:/=\%"
set FILELIST=
for %%F in (%JARLIBDIR_BACKSLASH\jackson-*.jar) do (
    if defined FILELIST (
        set "FILELIST=!FILELIST!;%%F"
    ) else (
        set "FILELIST=%%F"
    )
)

echo FILELIST = %FILELIST%

set "FILELIST=%FILELIST:\=/%"

echo running junit - %CLASSFILETEST%

java -jar %SCRIPTDIR%/junit-platform-console-standalone-1.13.0-M3.jar execute -cp %CLASSDIR%;%TESTCLASSDIR%;%FILELIST% --select-class %CLASSFILETEST%

endlocal