param([string]$InstallDir = "$env:LOCALAPPDATA\RVC")
$ErrorActionPreference='Stop'
$python=Join-Path $InstallDir '.venv\Scripts\python.exe'
if(-not (Test-Path $python)){ throw 'RVC is not installed. Run install_this_pc.ps1 first.' }
Set-Location $InstallDir
$env:OMP_NUM_THREADS='4'
$env:MKL_NUM_THREADS='4'
$env:OPENBLAS_NUM_THREADS='4'
& $python webui.py