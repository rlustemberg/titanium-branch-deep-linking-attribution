@echo off

setlocal enabledelayedexpansion

rem Setup the classpath
call "%~dp0setclasspath.bat"

"%JAVA%" -Xmx2g -jar "%~dp0..\MakeAppTouchTestable.jar" %*
