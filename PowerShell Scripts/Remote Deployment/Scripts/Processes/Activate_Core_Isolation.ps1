############################
## Isolate Cores
############################

# This script isolates one CPU core
$logicalProcessors = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
$logicalProcessorsNew = $logicalProcessors - 1
Start-Process -Wait -WindowStyle Hidden -FilePath "bcdedit" -ArgumentList "/set numproc $logicalProcessorsNew"

Write-Host "Changed from $logicalProcessors core to $logicalProcessorsNew shared core and 1 isolated core."