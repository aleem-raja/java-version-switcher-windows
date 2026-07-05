@echo off
setlocal enabledelayedexpansion

:: 1. Ensure admin rights for installation
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo [ERROR] Please right-click install.bat and select "Run as Administrator".
    pause
    exit /b 1
)

set "BIN_DIR=%~dp0bin"
set "JAVA_CURRENT=C:\Program Files\Java\current"

echo [+] Unblocking PowerShell Execution Policy for local scripts...
powershell -NoProfile -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

echo [+] Adding jsw to User PATH...
:: Check if already in user path to avoid duplication
echo %PATH% | findstr /I /C:";%BIN_DIR%" >nul
if %errorLevel% NEQ 0 (
    setx PATH "%BIN_DIR%;%PATH%"
)

echo [+] Pre-configuring System PATH for Java symlink...
echo %PATH% | findstr /I /C:"%JAVA_CURRENT%\bin" >nul
if %errorLevel% NEQ 0 (
    setx /M PATH "%JAVA_CURRENT%\bin;%PATH%"
)

echo [+] Simulating environment refresh for this active session...
:: This injects the new paths into the active CMD session immediately
set "PATH=%BIN_DIR%;%JAVA_CURRENT%\bin;%PATH%"

echo --------------------------------------------------
echo [SUCCESS] Installation completed successfully!
echo [INFO] You can now type 'jsw' right here in this window.
echo --------------------------------------------------

:: Drop into a fresh cmd environment with the new paths loaded so they can test it right away
cmd /k jsw