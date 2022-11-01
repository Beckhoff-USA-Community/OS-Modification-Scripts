# Optional - enabling the WinRM we need to change the network connection type from Public to Private
# This is only required on non-Beckhoff systems, IPCs and CX controllers should ship with Private by default
# Set-NetConnectionProfile -NetworkCategory Private 
# Alternatively, you can force WinRM to use Public
# Enable-PSRemoting -SkipNetworkProfileCheck -Force

# Configure WinRM on remote device
winrm quickconfig

# Allow Ping commands through firewall
New-NetFirewallRule -DisplayName "Allow inbound ICMPv4" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow
New-NetFirewallRule -DisplayName "Allow inbound ICMPv6" -Direction Inbound -Protocol ICMPv6 -IcmpType 8 -Action Allow

# Allow RPC commands through firewall
New-NetFirewallRule -DisplayName 'RPC Dynamic Ports'    -Direction Inbound -Protocol 'TCP' -LocalPort 'RPC' -Action Allow

# Enable Remote Execution
Set-ExecutionPolicy RemoteSigned