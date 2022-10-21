############################
## Install RTE Driver
############################
$adapter_name = "Ethernet1"
Start-Process -Wait C:\TwinCAT\3.1\System\TcRteInstall.exe -ArgumentList "-installnic $adapter_name /S" -PassThru
############################