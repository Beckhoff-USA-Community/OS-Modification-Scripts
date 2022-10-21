#####################################
## Install the OEM Cert
#####################################

$certPath = "C:\TwinCAT\3.1\Target\OemCertificates\"
$certName = "EngineeringUSA_at_beckhoff.com_7ea01879-7567-0992-20e4-aadc54427969.reg"
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