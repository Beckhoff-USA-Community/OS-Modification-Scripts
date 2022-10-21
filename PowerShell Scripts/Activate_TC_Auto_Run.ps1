#####################################
## Activate TwinCAT Run Mode on Boot
#####################################
$RegPath = "HKLM:\SOFTWARE\WOW6432Node\Beckhoff\TwinCAT3\System"
Set-ItemProperty $RegPath "SysStartupState" -Value 5 -type DWord -PassThru

############################