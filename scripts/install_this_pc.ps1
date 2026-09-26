param([string]$InstallDir='C:\RVC')
$ErrorActionPreference='Stop'

function Require-Command($name,$message){
  if(-not (Get-Command $name -ErrorAction SilentlyContinue)){ throw $message }
}

Write-Host 'RVC local installer for i5-7500 / 12GB / Intel HD 630' -ForegroundColor Cyan

if(-not (Get-Command py -ErrorAction SilentlyContinue)){
  throw 'Python launcher not found. Install Python 3.12 x64, then run this script again.'
}

& py -3.12 --version
if($LASTEXITCODE -ne 0){ throw 'Python 3.12 x64 is required.' }

$zip = Join-Path $env:TEMP 'rvc-main.zip'
$extract = Join-Path $env:TEMP 'rvc-main-extract'
$url = 'https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/archive/refs/heads/main.zip'

if(Test-Path $extract){ Remove-Item $extract -Recurse -Force }
New-Item -ItemType Directory -Path $extract -Force | Out-Null
Write-Host 'Downloading official RVC...' -ForegroundColor Cyan
Invoke-WebRequest -Uri $url -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $extract -Force

$src = Join-Path $extract 'Retrieval-based-Voice-Conversion-WebUI-main'
if(Test-Path $InstallDir){
  Write-Host "Using existing $InstallDir" -ForegroundColor Yellow
} else {
  Move-Item $src $InstallDir
}

Set-Location $InstallDir
if(-not (Test-Path '.venv')){ & py -3.12 -m venv .venv }
$python = Join-Path $InstallDir '.venv\Scripts\python.exe'
$hf = Join-Path $InstallDir '.venv\Scripts\hf.exe'

& $python -m pip install --upgrade pip 'setuptools<81' wheel
& $python -m pip install -r requirments_cpu_py312.txt
& $python -m pip install --upgrade huggingface_hub

Write-Host 'Downloading HuBERT / RMVPE / pretrained models...' -ForegroundColor Cyan
& $hf download lj1995/VoiceConversionWebUI --revision main --include 'hubert_base/*' --local-dir assets
& $hf download lj1995/VoiceConversionWebUI rmvpe.pt --revision main --local-dir assets/rmvpe
& $hf download lj1995/VoiceConversionWebUI rmvpe.onnx --revision main --local-dir assets/rmvpe
& $hf download lj1995/VoiceConversionWebUI --revision main --include 'pretrained/*' 'pretrained_v2/*' --local-dir assets
& $hf download lj1995/VoiceConversionWebUI mute.zip --revision main --local-dir .model-downloads
& $python -m zipfile -e .model-downloads\mute.zip logs

Write-Host ''
Write-Host 'Installation complete.' -ForegroundColor Green
Write-Host 'Start with:'
Write-Host "  & '$python' '$InstallDir\webui.py'"