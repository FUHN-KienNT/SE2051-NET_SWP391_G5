@echo off
setlocal enabledelayedexpansion
title Courson LMS - Rebuild & Run
color 0E

echo ======================================================================
echo             COURSON LMS - BIEN DICH VA KHOI CHAY (MAVEN)
echo ======================================================================
echo.

set "JAVA_HOME=C:\Program Files\Java\jdk-17"
set "CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 10.1"
set "MVN_CMD=C:\Program Files\NetBeans-17\netbeans\java\maven\bin\mvn.cmd"

echo [1/3] Dang bien dich va dong goi bang Maven...
call "%MVN_CMD%" clean package -DskipTests
if !errorlevel! neq 0 (
    color 0C
    echo.
    echo [LOI] Qua trinh build Maven that bai! Vui long kiem tra lai code.
    pause
    exit /b !errorlevel!
)
echo       [OK] Dong goi Courson.war thanh cong!
echo.

echo [2/3] Trien khai Courson.war vao Tomcat...
copy /Y "%~dp0target\Courson.war" "%CATALINA_HOME%\webapps\Courson.war" >nul
echo       [OK] Da cap nhat Courson.war vao Tomcat webapps.
echo.

echo [3/3] Khoi chay he thong...
call "%~dp0start_local.bat"
