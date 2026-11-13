@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title TingXi EXE Builder

echo ========================================
echo TingXi - Windows EXE Builder
 echo ========================================
if not exist "listenloop.html" goto missing
if not exist "desktop.py" goto missing

rem The player itself needs no Python. Python is only for building the EXE.
set "PYTHON_CMD="
py -3 --version >nul 2>&1
if not errorlevel 1 set "PYTHON_CMD=py -3"
if not defined PYTHON_CMD (
  python --version >nul 2>&1
  if not errorlevel 1 set "PYTHON_CMD=python"
)
if not defined PYTHON_CMD goto no_python

 echo [1/3] Creating an isolated build environment...
if not exist ".build_venv\Scripts\python.exe" (
  %PYTHON_CMD% -m venv ".build_venv"
  if errorlevel 1 goto fail_venv
)
set "VENV_PY=%CD%\.build_venv\Scripts\python.exe"
if not exist "%VENV_PY%" goto fail_venv

 echo [2/3] Installing PyInstaller (Internet required once)...
"%VENV_PY%" -m pip install --disable-pip-version-check --prefer-binary pyinstaller
if errorlevel 1 goto fail_pip

 echo [3/3] Building TingXi.exe...
"%VENV_PY%" -m PyInstaller --noconfirm --clean --onefile --windowed --name TingXi --icon "TingXi.ico" --add-data "listenloop.html;." "desktop.py"
if errorlevel 1 goto fail_build
if not exist "dist\TingXi.exe" goto fail_build

echo.
echo SUCCESS: %CD%\dist\TingXi.exe
echo Windows Edge is recommended for the app window.
pause
exit /b 0

:no_python
echo.
echo ERROR: Python 3 is not installed or is not on PATH.
echo You can use listenloop.html right now without Python.
echo To build an EXE, install Python 3 from https://www.python.org/downloads/windows/
echo Then reopen this BAT file.
goto end_fail

:missing
echo ERROR: listenloop.html or desktop.py is missing.
echo Please extract the complete ZIP first.
goto end_fail

:fail_venv
echo ERROR: Could not create the build environment.
echo Verify that Python 3 and its venv module are installed.
goto end_fail

:fail_pip
echo ERROR: PyInstaller installation failed.
echo Please check network access or proxy settings.
goto end_fail

:fail_build
echo ERROR: PyInstaller failed. See the error messages above.
goto end_fail

:end_fail
echo.
echo If the BAT window closes immediately, run this in CMD:
echo Run this batch file in CMD to inspect the error.
pause
exit /b 1
