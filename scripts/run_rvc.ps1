param([string]$InstallDir='C:\RVC')
$ErrorActionPreference='Stop'
Set-Location $InstallDir
& .\.venv\Scripts\python.exe webui.py