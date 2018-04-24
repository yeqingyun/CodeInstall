@echo off
if "%JAVA_HOME%" == "" goto setjava
goto end
:setjava
set JAVA_HOME=D:\cf\data\jdk1.8.0_151
set PATH=%JAVA_HOME%\bin;%PATH%
:end
echo on
