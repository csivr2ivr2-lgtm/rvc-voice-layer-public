param([string]$InstallDir = "$env:PUBLIC\RVC")
$ErrorActionPreference='Stop'

Write-Host 'RVC local installer for i5-7500 / 12GB / Intel HD 630' -ForegroundColor Cyan

if(-not (Get-Command py -ErrorAction SilentlyContinue)){
  throw 'Python launcher not found. Install Python 3.12 x64, then run this script again.'
}

& py -3.12 --version
if($LASTEXITCODE -ne 0){ throw 'Python 3.12 x64 is required.' }

$work = Join-Path $env:PUBLIC 'rvc-local-installer'
$zip = Join-Path $work 'rvc-main.zip'
$extract = Join-Path $work 'extract'
$url = 'https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/archive/refs/heads/main.zip'

if(Test-Path $work){ Remove-Item $work -Recurse -Force }
New-Item -ItemType Directory -Path $extract -Force | Out-Null
Write-Host 'Downloading official RVC...' -ForegroundColor Cyan
curl.exe -L $url -o $zip
if($LASTEXITCODE -ne 0){ throw 'RVC download failed.' }
tar.exe -xf $zip -C $extract
if($LASTEXITCODE -ne 0){ throw 'RVC extraction failed.' }

$src = Get-ChildItem $extract -Directory | Select-Object -First 1
if(-not $src){ throw 'Extracted RVC directory was not found.' }
if(Test-Path $InstallDir){
  Write-Host "Using existing $InstallDir" -ForegroundColor Yellow
} else {
  Move-Item $src.FullName $InstallDir
}

Set-Location $InstallDir
if(-not (Test-Path '.venv')){ & py -3.12 -m venv .venv }
$python = Join-Path $InstallDir '.venv\Scripts\python.exe'

& $python -m pip install --upgrade pip 'setuptools<81' wheel
if($LASTEXITCODE -ne 0){ throw 'Base packaging tools install failed.' }
& $python -m pip install -r requirments_cpu_py312.txt
if($LASTEXITCODE -ne 0){ throw 'RVC requirements install failed.' }
& $python -m pip install 'huggingface_hub==0.36.2'
if($LASTEXITCODE -ne 0){ throw 'huggingface_hub install failed.' }

$downloader = Join-Path $PSScriptRoot 'download_rvc_models.py'
& $python $downloader --rvc-dir $InstallDir
if($LASTEXITCODE -ne 0){ throw 'Model asset download failed.' }

& $python -m pip check
if($LASTEXITCODE -ne 0){ throw 'Dependency conflicts detected.' }

Write-Host ''
Write-Host 'Installation complete.' -ForegroundColor Green
Write-Host "RVC path: $InstallDir"