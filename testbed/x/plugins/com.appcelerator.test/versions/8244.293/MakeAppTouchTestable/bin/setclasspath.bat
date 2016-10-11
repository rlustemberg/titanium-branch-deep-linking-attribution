rem
rem %~dp0 evaluates to the directory that this batch file is located in.
rem
SET LIB_DIR=%~dp0..\lib

rem
rem Clear the class path from any previous runs.
rem
SET _CLASSPATH=

rem
rem Add the "lib" directory itself, to pick up any files in there.
rem
SET _CLASSPATH=%_CLASSPATH%;%LIB_DIR%

rem
rem Add every JAR file in the "lib" directory.
rem NOTE: This "for" command only works if the originating script (e.g. scommand.bat) includes the following line: setlocal enabledelayedexpansion
rem
for %%J IN ("%LIB_DIR%\*.jar") do SET _CLASSPATH=!_CLASSPATH!;%%J

rem
rem Directory for native code libraries.
rem
SET _LIBRARY_PATH=%LIB_DIR%

rem Setup the JVM
if not "%JAVA_HOME%"=="" (
  SET JAVA=%JAVA_HOME%\bin\java
) else (
  SET JAVA=java
)
