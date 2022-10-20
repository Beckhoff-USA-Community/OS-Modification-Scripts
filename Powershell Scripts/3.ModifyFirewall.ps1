############################
## Modify Firewall Ports
############################

# Allow HTTPS (port 443)
New-NetFirewallRule -DisplayName 'HTTPS-Inbound' `
                    -Profile @('Domain', 'Private') `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort 443

# Allow MQTT (both port 1883 and 8883)
New-NetFirewallRule -DisplayName 'MQTT-Inbound' `
                    -Profile @('Domain', 'Private') `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort @('1883', '8883')

# Block HTTP Outbound
New-NetFirewallRule -DisplayName "Block Outbound Port 80" `
                    -Direction Outbound `
                    -Action Block `
                    -Protocol TCP `
                    -LocalPort 80