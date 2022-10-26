############################
## Install XAR and some TFs
############################

# Base Installer Directory
$base_directory="C:\Deployment_Files\"

# Install XAR
$installer_name = "TC31-XAR-Setup.3.1.4024.35.exe"
$install_path  =$base_directory + $installer_name
Start-Process -Wait -FilePath $install_path -ArgumentList '/s /v"/qr REBOOT=ReallySuppress ALLUSERS=1"' -PassThru
############################