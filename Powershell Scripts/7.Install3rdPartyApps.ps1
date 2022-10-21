############################
## Install 3rd Party Apps
############################

# Base Installer Directory
$base_directory="C:\Installers\"

# Install Notepad++
$installer_name = "npp.8.4.6.Installer.x64.exe"
$install_path  =$base_directory + $installer_name
Start-Process -Wait -FilePath $install_path -ArgumentList "/S" -PassThru

# Install Mosquitto
$installer_name = "mosquitto-2.0.15-install-windows-x64.exe"
$install_path  =$base_directory + $installer_name
Start-Process -Wait -FilePath $install_path -ArgumentList "/S" -PassThru

# Start the Mosquitto Broker
$s = Get-Service mosquitto
Start-Service -InputObject $s -PassThru
############################