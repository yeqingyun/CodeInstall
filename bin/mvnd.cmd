@call vj
@echo off
set MAVEN_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8000
@D:\cf\data\maven\bin\mvn.bat %*
