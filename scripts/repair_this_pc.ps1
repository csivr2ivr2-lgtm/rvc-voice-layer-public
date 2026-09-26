param([string]$InstallDir = "$env:PUBLIC\RVC")
$ErrorActionPreference='Stop'

$python = Join-Path $InstallDir '.venv\Scripts\python.exe'
if(-not (Test-Path $python)){ throw "RVC Python environment not found: $python" }

Write-Host 'Repairing RVC Python dependencies...' -ForegroundColor Cyan

# huggingface_hub 2.x pulls a second HTTP stack that conflicts with the
# Gradio/Transformers versions pinned by the current RVC CPU requirements.
& $python -m pip uninstall -y huggingface_hub httpx2 httpcore2

& $python -m pip install -r (Join-Path $InstallDir 'requirments_cpu_py312.txt')
if($LASTEXITCODE -ne 0){ throw 'RVC requirements repair failed.' }

& $python -m pip install 'huggingface_hub==0.36.2' 'anyio==3.7.1' 'h11==0.14.0'
if($LASTEXITCODE -ne 0){ throw 'Dependency pin repair failed.' }

Write-Host 'Downloading/verifying RVC model assets...' -ForegroundColor Cyan
$downloader = Join-Path $PSScriptRoot 'download_rvc_models.py'
& $python $downloader --rvc-dir $InstallDir
if($LASTEXITCODE -ne 0){ throw 'RVC model download/verification failed.' }

Write-Host 'Checking dependency consistency...' -ForegroundColor Cyan
& $python -m pip check
if($LASTEXITCODE -ne 0){ throw 'pip check found dependency conflicts.' }

Write-Host ''
Write-Host 'RVC repair completed successfully.' -ForegroundColor Green
Write-Host "RVC path: $InstallDir"