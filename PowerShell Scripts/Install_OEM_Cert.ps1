#####################################
## Install the OEM Cert
#####################################

$certPath = "C:\TwinCAT\3.1\Target\OemCertificates\"
$certName = "EngineeringUSA_at_beckhoff.reg"
$oemCert = $certPath + $certName

#Import the OEM cert
$process = Start-Process reg -ArgumentList "import $oemCert" -PassThru -Wait

#Check if the import had an error
if($process.ExitCode.Equals(1)){
    Write-Host "Error: OEM Cert Import Failed"
} 
else{
    Write-Host "OEM Cert Import Successful"
}
############################