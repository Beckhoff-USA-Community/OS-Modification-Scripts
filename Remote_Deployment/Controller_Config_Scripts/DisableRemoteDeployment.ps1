# Stop and Disable the WINRM Service
Stop-Service winrm
Set-Service -Name winrm -StartupType Disabled

# Remove Ping allow rule for firewall
Remove-NetFirewallRule -DisplayName "Allow inbound ICMPv4"
Remove-NetFirewallRule -DisplayName "Allow inbound ICMPv6"

# Remove RPC allow rule for firewall
Remove-NetFirewallRule -DisplayName "RPC Dynamic Ports"

# Enable Remote Execution
Set-ExecutionPolicy Restricted