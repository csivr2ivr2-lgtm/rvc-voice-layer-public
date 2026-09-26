param([string]$InstallDir='C:\RVC')
$ErrorActionPreference='Stop'
function Need($cmd,$msg){ if(-not (Get-Command $cmd -ErrorAction SilentlyContinue)){ throw $msg } }
Need git 'Git is required.'
Need py 'Python launcher is required. Install Python 3.12 x64.'
if(Test-Path $InstallDir){ Write-Host "Using existing $InstallDir" } else { git clone https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git $InstallDir }
Set-Location $InstallDir
py -3.12 -m venv .venv
& .\.venv\Scripts\python.exe -m pip install --upgrade pip setuptools wheel
$gpu=(Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name) -join ' | '
if($gpu -match 'NVIDIA.*RTX 50'){
  & .\.venv\Scripts\python.exe -m pip install 'torch==2.7.1+cu128' 'torchaudio==2.7.1+cu128' --index-url https://download.pytorch.org/whl/cu128 --extra-index-url https://pypi.org/simple
  & .\.venv\Scripts\python.exe -m pip install -r requirments_cu128_py312.txt
} elseif($gpu -match 'NVIDIA'){
  & .\.venv\Scripts\python.exe -m pip install 'torch==2.7.1+cu118' 'torchaudio==2.7.1+cu118' --index-url https://download.pytorch.org/whl/cu118 --extra-index-url https://pypi.org/simple
  & .\.venv\Scripts\python.exe -m pip install -r requirments_cu118_py312.txt
} else {
  & .\.venv\Scripts\python.exe -m pip install -r requirments_cpu_py312.txt
}
& .\.venv\Scripts\python.exe -m pip install --upgrade huggingface_hub
& .\.venv\Scripts\hf.exe download lj1995/VoiceConversionWebUI --revision main --include 'hubert_base/*' --local-dir assets
if($gpu -match 'NVIDIA'){
  & .\.venv\Scripts\hf.exe download lj1995/VoiceConversionWebUI rmvpe.pt --revision main --local-dir assets/rmvpe
} else {
  & .\.venv\Scripts\hf.exe download lj1995/VoiceConversionWebUI rmvpe.onnx --revision main --local-dir assets/rmvpe
}
& .\.venv\Scripts\hf.exe download lj1995/VoiceConversionWebUI --revision main --include 'pretrained/*' 'pretrained_v2/*' --local-dir assets
& .\.venv\Scripts\hf.exe download lj1995/VoiceConversionWebUI mute.zip --revision main --local-dir .model-downloads
& .\.venv\Scripts\python.exe -m zipfile -e .model-downloads\mute.zip logs
Write-Host 'RVC local installation complete.'