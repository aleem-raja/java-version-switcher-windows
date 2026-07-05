@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0refresh-java.ps1" -List
    exit /b 0
)

if "%~1"=="list" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0refresh-java.ps1" -List
    exit /b 0
)

:: Elevate to admin automatically to update symlinks smoothly
net session >nul 2>&1
if %errorLevel% == 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0refresh-java.ps1" -SwitchTo "%~1"
) else (
    echo [jsw] Requesting administrative privileges to update Java system symlinks...
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~f0"" %~1' -Verb RunAs"
)
exit /b 0
