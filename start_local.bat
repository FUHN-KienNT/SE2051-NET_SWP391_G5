@echo off
setlocal enabledelayedexpansion
title Courson LMS - Quick Start
color 0B

echo ======================================================================
echo                 COURSON LMS - KHOI CHAY LOCAL
echo ======================================================================
echo.

set "JAVA_HOME=C:\Program Files\Java\jdk-17"
set "CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 10.1"
set "PG_BIN=C:\Program Files\PostgreSQL\18\bin"
set "PG_DATA=C:\Program Files\PostgreSQL\18\data"
set "APP_URL=http://localhost:8080/Courson/"

:: 1. Kiem tra & Khoi dong PostgreSQL
echo [1/3] Kiem tra PostgreSQL Database (Port 5432)...
"%PG_BIN%\pg_isready.exe" -q >nul 2>&1
if !errorlevel! equ 0 (
    echo       [OK] PostgreSQL da san sang.
) else (
    echo       [*] Dang khoi dong PostgreSQL Service...
    "%PG_BIN%\pg_ctl.exe" start -D "%PG_DATA%" -s >nul 2>&1
    if !errorlevel! neq 0 (
        start "PostgreSQL Service" /min "%PG_BIN%\postgres.exe" -D "%PG_DATA%"
    )
    ping 127.0.0.1 -n 3 >nul
    "%PG_BIN%\pg_isready.exe" -q >nul 2>&1
    if !errorlevel! equ 0 (
        echo       [OK] Khoi dong PostgreSQL thanh cong!
    ) else (
        echo       [!] Dang cho PostgreSQL ket noi...
        ping 127.0.0.1 -n 3 >nul
    )
)
echo.

:: 2. Tu dong dong bo giao dien JSP / WebApp
echo [2/3] Dong bo giao dien JSP va webapp vao Tomcat...
robocopy "%~dp0src\main\webapp" "%CATALINA_HOME%\webapps\Courson" /E /XO /NFL /NDL /NJH /NJS >nul 2>&1
echo       [OK] Da dong bo webapp vao Tomcat.
echo.

:: 3. Kiem tra & Khoi dong Apache Tomcat 10.1
echo [3/3] Kiem tra Apache Tomcat 10.1 (Port 8080)...
netstat -ano | find "8080" | find "LISTENING" >nul 2>&1
if !errorlevel! equ 0 (
    echo       [OK] Tomcat 10.1 dang chay tren Port 8080.
) else (
    echo       [*] Dang khoi dong Tomcat 10.1...
    start "Courson LMS - Tomcat Server" "%CATALINA_HOME%\bin\catalina.bat" run
    echo       [*] Dang khoi chay webapp...
    ping 127.0.0.1 -n 4 >nul
)
echo.

echo ======================================================================
echo       HE THONG DA SAN SANG!
echo       Dia chi: %APP_URL%
echo ======================================================================
echo.
echo Dang mo trinh duyet toi Courson LMS...
start "" "%APP_URL%"

echo.
echo Cua so nay se tu dong dong sau 3 giay (Server tiep tuc chay ngam).
ping 127.0.0.1 -n 4 >nul
