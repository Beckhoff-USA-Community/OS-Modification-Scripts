# Import Functions
. "G:\GitHub\OS-Modification-Scripts\Remote Deployment\Beckhoff_Functions.ps1"

#########################################
#### Configurables 
#########################################
# Controllers IP Address
$IPAddress = "192.168.1.92"
# Installer Files Path (Items to copy to controller)
$Local_File_Location = "G:\GitHub\OS-Modification-Scripts\Remote Deployment\Installers\"
$Remote_File_Location = "C:\DeploymentFiles\"
# New Admin Password
$NewAdminPassword = "TwinCAT123"
# New Username and Password
$NewUser = "TwinCAT_User"
$NewUserPassword = "TwinCAT123"
#########################################
#########################################

# Connect to the controller with Administrator user
$ControllerSession = Beckhoff-Connect -IPAddress $IPAddress

# Download the files to the controller
Write-Host Downloading installer files to controller...
Copy-Item $Local_File_Location -Destination $Remote_File_Location -ToSession $ControllerSession -Recurse -Force

# Change Administrator Password
Set-AdminPassword -Session $ControllerSession -Password $NewAdminPassword 

# Reconnect to the controller with Administrator user
Write-Warning "### Please reconnect using new password ###"
$ControllerSession = Beckhoff-Connect -IPAddress $IPAddress

# Create a new user
Beckhoff-AddUser -Session $ControllerSession -UserName $NewUser -Password $NewUserPassword

# Activate Auto-login for new user
Beckhoff-ActivateAutoLogin -Session $ControllerSession -UserName $NewUser -Password $NewUserPassword

# Install TwinCAT
Write-Host Installing TwinCAT...
Beckhoff-InstallTwinCAT -Session $ControllerSession -Directory $Remote_File_Location

# Activate Core Isolation
Write-Host Isolating Cores...
Beckhoff-IsolateCores -Session $ControllerSession

# Reboot PC
Write-Host Rebooting!
[String]$userPassword = $NewAdminPassword
[SecureString]$secStringPassword = ConvertTo-SecureString $userPassword -AsPlainText -Force
[PSCredential]$Credential = New-Object System.Management.Automation.PSCredential ("Administrator", $secStringPassword)
Restart-Computer -ComputerName $IPAddress -Credential $Credential -Wait -For PowerShell -Timeout 500 -Force

# Reconnect
Write-Host Reconnecting to host...
$ControllerSession = Beckhoff-Connect -IPAddress $IPAddress

# Install TFs
Write-Host Installing TFs...
Beckhoff-InstallTwinCATFunctions -Session $ControllerSession -Directory $Remote_File_Location

# Reboot PC
Write-Host Final Reboot!
Restart-Computer -ComputerName $IPAddress -Credential $Credential -Wait -For PowerShell -Timeout 500 -Force
Write-Host Install Script Complete!!!