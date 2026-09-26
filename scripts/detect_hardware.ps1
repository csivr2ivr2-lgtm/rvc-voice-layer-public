$ErrorActionPreference='SilentlyContinue'
$cpu=Get-CimInstance Win32_Processor | Select-Object -First 1 Name,NumberOfCores,NumberOfLogicalProcessors
$ram=[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,1)
$gpus=Get-CimInstance Win32_VideoController | Select-Object Name,@{N='VRAM_GB';E={if($_.AdapterRAM){[math]::Round($_.AdapterRAM/1GB,1)}else{$null}}},DriverVersion
$os=Get-CimInstance Win32_OperatingSystem
[pscustomobject]@{Windows=$os.Caption;Build=$os.BuildNumber;CPU=$cpu.Name;Cores=$cpu.NumberOfCores;Threads=$cpu.NumberOfLogicalProcessors;RAM_GB=$ram} | Format-List
'GPUs:'
$gpus | Format-Table -AutoSize