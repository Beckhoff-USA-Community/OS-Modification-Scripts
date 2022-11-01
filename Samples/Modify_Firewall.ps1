############################
## Modify Firewall Ports
############################

# Allow HTTPS (port 443)
New-NetFirewallRule -DisplayName 'HTTPS-Inbound Allow' `
                    -Profile @('Domain', 'Private') `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort 443

# Allow MQTT (both port 1883 and 8883)
New-NetFirewallRule -DisplayName 'MQTT-Inbound Allow' `
                    -Profile @('Domain', 'Private') `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort @('1883', '8883')
                             
# Allow OPC-UA (port 4840)
New-NetFirewallRule -DisplayName 'OPC-Inbound Allow' `
                    -Profile @('Domain', 'Private') `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort 4840                  

# Block HTTP Outbound
New-NetFirewallRule -DisplayName "HTTP-Outbound Block" `
                    -Direction Outbound `
                    -Action Block `
                    -Protocol TCP `
                    -LocalPort 80