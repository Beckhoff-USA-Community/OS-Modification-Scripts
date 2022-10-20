##########################
## Add a new user
##########################
# Create a new user
$username = "JohnH"
$password = "TwinCAT123"
$passwordSec = ConvertTo-SecureString -String $password -AsPlainText -Force

# Create new user account if it does not exist
$account = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
if (-not ($null -eq $account)) {
    Remove-LocalUser -Name $username
}
New-LocalUser -Name $username -FullName $username -Description "Account for John" -Password $passwordSec

# Make the user part of the Administrators Group
Add-LocalGroupMember -Group "Administrators" -Member $username
##########################