@echo off
setlocal enabledelayedexpansion

:: === Set your application name here ===
set "APPLICATION=LogitechGhub"

:: Get script's folder
set "BASE_DIR=%~dp0"
if "%BASE_DIR:~-1%"=="\" set "BASE_DIR=%BASE_DIR:~0,-1%"

:: Target root folder backup root (based on application)
set "BACKUP_ROOT=%BASE_DIR%\%APPLICATION%"

:: Ensure backup root folder exists
if not exist "%BACKUP_ROOT%" mkdir "%BACKUP_ROOT%"

:: Get date (YYYY-MM-DD)
for /f %%A in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set DATE=%%A

:: Find available numbered folder
set /a COUNT=1
:find_folder
if exist "%BACKUP_ROOT%\%DATE%_%COUNT%" (
    set /a COUNT+=1
    goto find_folder
)
set "DEST=%BACKUP_ROOT%\%DATE%_%COUNT%"
mkdir "%DEST%"

:: Begin backup
echo Backing up %APPLICATION% to "%DEST%"...
echo.

:: === Set your target directories here ===
:: Backup AppData/Roaming
xcopy "%AppData%\LGHUB" "%DEST%\Roaming" /E /I /H /Y
:: Backup AppData/Local
xcopy "%LocalAppData%\LGHUB" "%DEST%\Local" /E /I /H /Y

echo.
echo Backup complete.
pause