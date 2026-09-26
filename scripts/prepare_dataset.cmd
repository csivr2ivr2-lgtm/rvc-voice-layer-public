@echo off
setlocal

if "%~1"=="" (
  echo Usage: prepare_dataset.cmd "C:\path\to\source.wav"
  exit /b 1
)

set "INPUT=%~1"
set "ROOT=%~dp0.."
set "OUTDIR=%ROOT%\dataset\newvoice"
set "OUTPUT=%OUTDIR%\source.wav"

if not exist "%INPUT%" (
  echo ERROR: input file not found: %INPUT%
  exit /b 1
)

where ffmpeg >nul 2>nul
if errorlevel 1 (
  echo ERROR: ffmpeg is not available in PATH.
  exit /b 1
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

ffmpeg -y -i "%INPUT%" -ac 1 -ar 40000 -c:a pcm_s16le "%OUTPUT%"
if errorlevel 1 exit /b 1

echo.
echo Dataset prepared:
echo %OUTPUT%
endlocal