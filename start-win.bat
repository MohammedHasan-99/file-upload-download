@echo off
setlocal enabledelayedexpansion

REM Create or clear the log file
echo Logging server start... > log.txt
echo Logging server start...

REM Get the current device IP address (using PowerShell)
echo Fetching current device IP address... >> log.txt
echo Fetching current device IP address...

REM Attempt to fetch the IP address, excluding the loopback address
for /f "tokens=*" %%i in ('powershell -command "Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne '127.0.0.1' -and $_.IPAddress -ne '::1' } | Select-Object -ExpandProperty IPAddress"') do (
    set DEVICE_IP=%%i
)
REM Log the fetched IP address
if defined DEVICE_IP (
    echo Current device IP address: !DEVICE_IP! >> log.txt
    echo Current device IP address: !DEVICE_IP!
) else (
    echo Failed to retrieve the current device IP address. >> log.txt
    echo Failed to retrieve the current device IP address.
    exit /b 1
)

REM Navigate to the file-upload-download directory
@REM cd /d "C:\Users\mohdh\Desktop\file-upload-download"
cd /d "%~dp0"

if errorlevel 1 (
    echo Failed to change directory to %~dp0 >> log.txt
    echo Failed to change directory to %~dp0 
    echo Directory not found. Exiting. >> log.txt
    echo Directory not found. Exiting.
    exit /b 1
) else (
    echo Successfully changed directory to %~dp0 >> log.txt
    echo Successfully changed directory to %~dp0 
)

REM Run npm start with the IP address and port 3000 in the same window
echo Starting server with IP: !DEVICE_IP! on port 3000... >> log.txt
echo Starting server with IP: !DEVICE_IP! on port 3000...
npm start !DEVICE_IP! 3000

REM Wait a few seconds to let the server start
timeout /t 5 /nobreak >nul

REM Output the clickable link in the console
echo. >> log.txt
echo Server started successfully. You can access it at: http://!DEVICE_IP!:3000 >> log.txt
echo Server started successfully. You can access it at: http://!DEVICE_IP!:3000
