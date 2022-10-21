############################
## Modify IPv4 Address
############################

New-NetIPAddress –InterfaceAlias 'Ethernet0' -AddressFamily IPv4 -IPAddress '192.168.86.91' –PrefixLength 24 #-DefaultGateway '192.168.86.1'
# Echo back the setting
#Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Ethernet0'

############################