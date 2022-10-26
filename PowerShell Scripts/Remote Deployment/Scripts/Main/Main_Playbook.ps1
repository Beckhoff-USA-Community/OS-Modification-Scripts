# Controllers IP Address
$IPAddress = "192.168.1.238"

##########################################
# Two Methods of providing credentials
##########################################
# 1. Dialog Box
# $Credential = Get-Credential
##########################################
# 2. Code Defined
# Define username and password
[String]$userName = 'Administrator'
[String]$userPassword = "1"
# Convert to SecureString
[SecureString]$secStringPassword = ConvertTo-SecureString $userPassword -AsPlainText -Force
[PSCredential]$Credential = New-Object System.Management.Automation.PSCredential ($userName, $secStringPassword)
##########################################
##########################################

Write-Host Creating connection to host $IPAddress
$Session = New-PSSession -ComputerName $IPAddress -Credential $Credential

# Installer Directory Path
$Installer_Files = "G:\GitHub\OS-Modification-Scripts\PowerShell Scripts\Remote Deployment\Installers\"

# Download the files to the controller
Write-Host Downloading installer files to remote PC...
Copy-Item $Installer_Files -Destination "C:\Deployment_Files\" -ToSession $Session -Recurse -Force

# Change the administrator password
Write-Host Changing Administrator password
Invoke-Command -Session $Session -FilePath "PowerShell Scripts\Remote Deployment\Scripts\Processes\Change_Admin_Password.ps1"

# Reconnect to the host using the NEW administrator password
Write-Host Reconnecting to host $IPAddress
[String]$userPassword = "TwinCAT123"
[SecureString]$secStringPassword = ConvertTo-SecureString $userPassword -AsPlainText -Force
[PSCredential]$Credential = New-Object System.Management.Automation.PSCredential ($userName, $secStringPassword)
$Session = New-PSSession -ComputerName $IPAddress -Credential $Credential

# Create a new user
Write-Host Adding new user
Invoke-Command -Session $Session -FilePath "PowerShell Scripts\Remote Deployment\Scripts\Processes\Add_New_User.ps1"

# Add auto-login to the new user
Write-Host Enabling new user auto-login
Invoke-Command -Session $Session -FilePath "PowerShell Scripts\Remote Deployment\Scripts\Processes\Activate_AutoLogin_User.ps1"

# Install TwinCAT and TFs
Write-Host Installing TwinCAT...
Invoke-Command -Session $Session -FilePath "PowerShell Scripts\Remote Deployment\Scripts\Processes\Install_TwinCAT.ps1"

# Activate Core Isolation
Write-Host Isolating Cores
Invoke-Command -Session $Session -FilePath "PowerShell Scripts\Remote Deployment\Scripts\Processes\Activate_Core_Isolation.ps1"

# Reboot PC
Write-Host Rebooting...
Restart-Computer -ComputerName $IPAddress -Credential $Credential -Wait -For PowerShell -Timeout 500 -Force

# Reconnect
Write-Host Reconnecting to host...
$Session = New-PSSession -ComputerName $IPAddress -Credential $Credential

# Install TwinCAT and TFs
Write-Host Installing TFs...
Invoke-Command -Session $Session -FilePath "PowerShell Scripts\Remote Deployment\Scripts\Processes\Install_TFs.ps1"

# Reboot PC
Write-Host Rebooting...
Invoke-Command -Session $Session -ScriptBlock {Restart-Computer -Force}
# Restart-Computer -ComputerName $IPAddress -Credential $Credential -Wait -For PowerShell -Timeout 500 -Force