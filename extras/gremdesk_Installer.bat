@echo off
setlocal
cd /d "%~dp0"

:menu
cls
echo ============================
echo       GremDesk Setup
echo ============================
echo.
echo 1) Install
echo 2) Uninstall
echo 3) Exit
echo.
set /p choice=Select an option (1-3): 

if "%choice%"=="1" goto install
if "%choice%"=="2" goto uninstall
if "%choice%"=="3" goto end

echo.
echo Invalid choice.
pause
goto menu

:install
echo.
echo Running install...
powershell -ExecutionPolicy Bypass -File ".\extras\install scripts\install.ps1"
echo.
pause
goto end

:uninstall
echo.
echo Running uninstall...
powershell -ExecutionPolicy Bypass -File ".\extras\install scripts\uninstall.ps1"
echo.
pause
goto end

:end
endlocal
