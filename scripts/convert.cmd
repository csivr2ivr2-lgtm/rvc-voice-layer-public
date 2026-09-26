@echo off
setlocal

if "%APPLIO_DIR%"=="" (
  echo ERROR: set APPLIO_DIR first. Example: set APPLIO_DIR=C:\Applio
  exit /b 1
)

if "%~4"=="" (
  echo Usage: convert.cmd "input.wav" "output.wav" "model.pth" "model.index"
  exit /b 1
)

set "INPUT=%~1"
set "OUTPUT=%~2"
set "MODEL=%~3"
set "INDEX=%~4"

pushd "%APPLIO_DIR%"
python core.py infer --input-path "%INPUT%" --output-path "%OUTPUT%" --pth-path "%MODEL%" --index-path "%INDEX%" --pitch 0 --index-rate 0.75 --volume-envelope 1 --protect 0.33 --f0-method rmvpe --embedder-model contentvec --export-format WAV
set "ERR=%ERRORLEVEL%"
popd
exit /b %ERR%