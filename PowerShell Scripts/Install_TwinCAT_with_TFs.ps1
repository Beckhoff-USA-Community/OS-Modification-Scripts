############################
## Install XAR and some TFs
############################

# Base Installer Directory
$base_directory="C:\Installers\"

# Install XAR
$installer_name = "TC31-XAR-Setup.3.1.4024.35.exe"
$install_path  =$base_directory + $installer_name
Start-Process -Wait -FilePath $install_path -ArgumentList '/s /v"/qr REBOOT=ReallySuppress ALLUSERS=1"' -PassThru

# Install TF3520
$installer_name = "TF3520-Analytics-Storage-Provider.exe"
$install_path  =$base_directory + $installer_name
Start-Process -Wait -FilePath $install_path -ArgumentList '/s /v"/qr REBOOT=ReallySuppress ALLUSERS=1"' -PassThru

# Install TF6100
$installer_name = "TF6100-OPC-UA-Server.exe"
$install_path  =$base_directory + $installer_name
Start-Process -Wait -FilePath $install_path -ArgumentList '/s /v"/qr REBOOT=ReallySuppress ALLUSERS=1"' -PassThru

#Install TF6420
$installer_name = "TF6420-Database-Server.exe"
$install_path  =$base_directory + $installer_name
Start-Process -Wait -FilePath $install_path -ArgumentList '/s /v"/qr REBOOT=ReallySuppress ALLUSERS=1"' -PassThru

# Reboot the IPC
Restart-Computer
############################