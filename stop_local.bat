@echo off
setlocal enabledelayedexpansion
title Courson LMS - Stop Services
color 0C

echo ======================================================================
echo                 COURSON LMS - DUNG DICH VU LOCAL
echo ======================================================================
echo.

set "CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 10.1"
set "PG_BIN=C:\Program Files\PostgreSQL\18\bin"
set "PG_DATA=C:\Program Files\PostgreSQL\18\data"

echo [*] Dang dung Apache Tomcat 10.1...
call "%CATALINA_HOME%\bin\shutdown.bat" >nul 2>&1
ping 127.0.0.1 -n 3 >nul

for /f "tokens=5" %%a in ('netstat -ano ^| find "8080" ^| find "LISTENING"') do (
    taskkill /PID %%a /F >nul 2>&1
)
echo       [OK] Da dung Tomcat.

echo.
echo [*] Dang dung PostgreSQL...
"%PG_BIN%\pg_ctl.exe" stop -D "%PG_DATA%" -m fast -s >nul 2>&1
taskkill /IM postgres.exe /F >nul 2>&1
echo       [OK] Da dung PostgreSQL.

echo.
echo ======================================================================
echo       DA DUNG TOAN BO DICH VU THANH CONG!
echo ======================================================================
ping 127.0.0.1 -n 3 >nul
