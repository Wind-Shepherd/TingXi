@echo off
setlocal EnableExtensions
cd /d "%~dp0"
if not exist "listenloop.html" goto missing

rem All user-visible content is inside listenloop.html.
rem Use Edge app mode if available, otherwise use the default browser.
set "LISTENLOOP_PAGE=%CD%\listenloop.html"
set "LISTENLOOP_BROWSER="
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "LISTENLOOP_BROWSER=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if not defined LISTENLOOP_BROWSER if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "LISTENLOOP_BROWSER=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if not defined LISTENLOOP_BROWSER if exist "%LocalAppData%\Microsoft\Edge\Application\msedge.exe" set "LISTENLOOP_BROWSER=%LocalAppData%\Microsoft\Edge\Application\msedge.exe"

if not defined LISTENLOOP_BROWSER goto browser_fallback
powershell.exe -NoProfile -Command "$u=(New-Object System.Uri($env:LISTENLOOP_PAGE)).AbsoluteUri; Start-Process -FilePath $env:LISTENLOOP_BROWSER -ArgumentList ('--app=' + $u)" >nul 2>&1
if not errorlevel 1 exit /b 0

:browser_fallback
rem PowerShell or Edge unavailable: file association needs no extra tools.
start "" "%LISTENLOOP_PAGE%"
if errorlevel 1 goto failed
exit /b 0

:missing
echo ERROR: listenloop.html is missing.
echo Extract the entire ZIP before running this file.
pause
exit /b 1

:failed
echo Could not open your default browser.
echo Please double-click listenloop.html instead.
pause
exit /b 1
