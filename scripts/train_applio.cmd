@echo off
setlocal

if "%APPLIO_DIR%"=="" (
  echo ERROR: set APPLIO_DIR first. Example: set APPLIO_DIR=C:\Applio
  exit /b 1
)

if not exist "%APPLIO_DIR%\core.py" (
  echo ERROR: core.py not found in %APPLIO_DIR%
  exit /b 1
)

set "MODEL_NAME=%~1"
if "%MODEL_NAME%"=="" set "MODEL_NAME=newvoice"
set "ROOT=%~dp0.."
set "DATASET=%ROOT%\dataset\%MODEL_NAME%"

if not exist "%DATASET%" (
  echo ERROR: dataset folder not found: %DATASET%
  exit /b 1
)

pushd "%APPLIO_DIR%"

python core.py preprocess --model_name "%MODEL_NAME%" --dataset_path "%DATASET%" --sample_rate 40000 --cut_preprocess Automatic
if errorlevel 1 goto :fail

python core.py extract --model_name "%MODEL_NAME%" --sample_rate 40000 --f0_method rmvpe --embedder_model contentvec --gpu 0
if errorlevel 1 goto :fail

python core.py train --model_name "%MODEL_NAME%" --sample_rate 40000 --batch_size 4 --save_every_epoch 25 --total_epoch 300
if errorlevel 1 goto :fail

python core.py index --model_name "%MODEL_NAME%" --index_algorithm Auto
if errorlevel 1 goto :fail

popd
echo.
echo Training pipeline finished for %MODEL_NAME%.
exit /b 0

:fail
set "ERR=%ERRORLEVEL%"
popd
echo ERROR: Applio command failed with exit code %ERR%.
exit /b %ERR%