# Before enabling the WinRM we need to change the network connection type from Public to Private
Set-NetConnectionProfile -NetworkCategory Private 

# Alternatively, you can force WinRM to use Public
# Enable-PSRemoting -SkipNetworkProfileCheck -Force

# Enable WinRM on remote device
winrm quickconfig

# Enable Ping
New-NetFirewallRule -DisplayName "Allow inbound ICMPv4" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow
New-NetFirewallRule -DisplayName "Allow inbound ICMPv6" -Direction Inbound -Protocol ICMPv6 -IcmpType 8 -Action Allow
New-NetFirewallRule -DisplayName 'RPC Dynamic Ports'    -Direction Inbound -Protocol 'TCP' -LocalPort 'RPC' -Action Allow

# Enable Remote Execution
Set-ExecutionPolicy RemoteSigned


# You might need to add the remote to the server's trusted connection list
# Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

# To connect to the remote device, use this command
# Enter-PSSession 192.168.1.238 -Credential $cred