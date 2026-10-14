@echo off
chcp 65001 >nul
title Courson LMS Server Runner
echo =======================================================================
echo          KHỞI ĐỘNG HỆ THỐNG COURSON LMS (TOMCAT 10 + POSTGRESQL)
echo       Dự án SWP391 - Nhóm SE2051-NET Group 5 (Đại Học FPT)
echo =======================================================================
echo.
echo [1/3] Đang đảm bảo PostgreSQL Server đang chạy...
"C:\Program Files\PostgreSQL\18\bin\pg_ctl.exe" start -D "C:\Program Files\PostgreSQL\18\data" >nul 2>&1

echo [2/3] Đang thiết lập môi trường Tomcat 10...
set "JAVA_HOME=C:\Program Files\Java\jdk-17"
set "CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 10.1"

echo [3/3] Đang mở trình duyệt truy cập hệ thống...
start "" "http://localhost:8080/Courson/home"

echo.
echo =======================================================================
echo   Hệ thống đang chạy tại: http://localhost:8080/Courson/home
echo   (Đóng cửa sổ này nếu muốn dừng máy chủ Tomcat)
echo =======================================================================
echo.
call "%CATALINA_HOME%\bin\catalina.bat" run
