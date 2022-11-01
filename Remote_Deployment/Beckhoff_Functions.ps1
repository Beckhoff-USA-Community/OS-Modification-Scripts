# PowerShell function: Open Session to Beckhoff Controller
Function Beckhoff-Connect {
    [CmdletBinding()]
    Param (
        [string]$IPAddress
    )
    # End of Parameters
    Process {
        for ($var = 1; $var -le 5; $var++) {
            # Create credential to controller
            $Credential = Get-Credential 'Administrator'
        
            # Connect to the controller
            Write-Host Attempting connection to host $IPAddress
            $Session = New-PSSession -ComputerName $IPAddress -Credential $Credential
        
            # Check to see if session can be opened and credentails are okay
            if(-not($Session))
            {
                Write-Warning "$IPAddress Inaccessible!"
                if((-not($Session)) -and (($var -eq 5)))
                {
                    Write-Error "`n`n################`n`nTerminating script due to no controller access  `n`n################`n`n"
                    Exit
                }
                Write-Warning "Connection attempt $var out of 5"
            }
            else
            {
                Write-Host "Great! $IPAddress is accessible and session is open!"
                Return $Session
            }
        }
    } # End of Process
}

# PowerShell function: Change the administrator password
Function Beckhoff-SetAdminPassword {
    # Function params
    [CmdletBinding()]
    Param (
        [string]
        $Password,
        [System.Management.Automation.Runspaces.PSSession]
        $Session
    ) # End params

    # Code to run on remote PC #
    $code = {
        param
        (
          [string]
          $Password
        )
        $username = "Administrator"
        $secpassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
        # Create new user account if it does not exist
        $account = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
        # Change Password if User Exists
        if (-not ($null -eq $account)) {
            $account = Get-LocalUser -Name $username
            $account |Set-LocalUser -Password $secpassword
            Write-Host "Admin password changed successfully!"
        }
        else {
            Write-Error "User named $username does not exist"
        }
    } # End code

    #### Invoke Remote Command ####
    Invoke-Command -Session $Session -ScriptBlock $code -ArgumentList $Password
}

# PowerShell function: Add new user
Function Beckhoff-AddUser {
    # Function params
    [CmdletBinding()]
    Param (
        [string]
        $UserName,
        [string]
        $Password,
        [System.Management.Automation.Runspaces.PSSession]
        $Session
    ) # End params
    
    # Code to run on remote PC #
    $code = {
        param
        (
            [string]
            $UserName,
            [string]
            $Password
        )
        ##########################
        ## Add a new user
        ##########################
        $passwordSec = ConvertTo-SecureString -String $Password -AsPlainText -Force
        # Create new user account if it does not exist
        $account = Get-LocalUser -Name $UserName -ErrorAction SilentlyContinue
        if (-not ($null -eq $account)) {
            Remove-LocalUser -Name $UserName
        }
        New-LocalUser -Name $UserName -FullName $UserName -Description "Standard User Account for Twincat" -Password $passwordSec

        # Make the user part of the Administrators Group
        Add-LocalGroupMember -Group "Users" -Member $UserName
        ##########################
    }
    #### Invoke Remote Command ####
    Invoke-Command -Session $Session -ScriptBlock $code -ArgumentList $UserName,$Password
}

# PowerShell function: Activate Auto Login for User
Function Beckhoff-ActivateAutoLogin {
    # Function params
    [CmdletBinding()]
    Param (
        [string]
        $UserName,
        [string]
        $Password,
        [System.Management.Automation.Runspaces.PSSession]
        $Session
    ) # End params
    
    # Code to run on remote PC #
    $code = {
        param
        (
            [string]
            $UserName,
            [string]
            $Password
        )
        ############################
        ## Add Autologin User
        ############################
        $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

        Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
        Set-ItemProperty $RegPath "DefaultUsername" -Value "$UserName" -type String 
        Set-ItemProperty $RegPath "DefaultPassword" -Value "$Password" -type String
        ############################
    }
    #### Invoke Remote Command ####
    Invoke-Command -Session $Session -ScriptBlock $code -ArgumentList $UserName,$Password
}

# PowerShell function: Install TwinCAT XAR
Function Beckhoff-InstallTwinCAT {
    # Function params
    [CmdletBinding()]
    Param (
        [string]
        $Directory,
        [System.Management.Automation.Runspaces.PSSession]
        $Session
    ) # End params
    
    # Code to run on remote PC #
    $code = {
        param
        (
            [string]
            $Directory
        )
        ############################
        ## Install XAR
        ############################
        # Base Installer Directory
        $base_directory=$Directory
        # Install XAR
        $installer_name = "TC31-XAR-Setup.3.1.4024.35.exe"
        $install_path  =$base_directory + $installer_name
        Start-Process -Wait -FilePath $install_path -ArgumentList '/s /v"/qr REBOOT=ReallySuppress ALLUSERS=1"' -PassThru
        ############################
    }
    #### Invoke Remote Command ####
    Invoke-Command -Session $Session -ScriptBlock $code -ArgumentList $Directory
}

# PowerShell function: Install TwinCAT XAR
Function Beckhoff-InstallTwinCATFunctions {
    # Function params
    [CmdletBinding()]
    Param (
        [string]
        $Directory,
        [System.Management.Automation.Runspaces.PSSession]
        $Session
    ) # End params
    
    # Code to run on remote PC #
    $code = {
        param
        (
            [string]
            $Directory
        )
        ############################
        ## Install TFs
        ############################

        # Base Installer Directory
        $base_directory=$Directory

        # Install TF3520
        $installer_name = "TF3520-Analytics-Storage-Provider.exe"
        $install_path  =$base_directory + $installer_name
        Start-Process -Wait -FilePath $install_path -ArgumentList '/s /v"/qr REBOOT=ReallySuppress ALLUSERS=1"' -PassThru

        # Install TF6100
        $installer_name = "TF6100-OPC-UA-Server.exe"
        $install_path  =$base_directory + $installer_name
        Start-Process -Wait -FilePath $install_path -ArgumentList '/s /v"/qr REBOOT=ReallySuppress ALLUSERS=1"' -PassThru

        #Install TF6420
        $installer_name = "TF6420-Database-Server.exe"
        $install_path  =$base_directory + $installer_name
        Start-Process -Wait -FilePath $install_path -ArgumentList '/s /v"/qr REBOOT=ReallySuppress ALLUSERS=1"' -PassThru
        ############################
    }

    #### Invoke Remote Command ####
    Invoke-Command -Session $Session -ScriptBlock $code -ArgumentList $Directory
}

# PowerShell function: Activate Core Isolation
Function Beckhoff-IsolateCores {
    # Function params
    [CmdletBinding()]
    Param (
        [System.Management.Automation.Runspaces.PSSession]
        $Session
    ) # End params
    
    # Code to run on remote PC #
    $code = {
        ############################
        ## Isolate Cores
        ############################
        # This script isolates one CPU core
        $logicalProcessors = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
        $logicalProcessorsNew = $logicalProcessors - 1
        Start-Process -Wait -WindowStyle Hidden -FilePath "bcdedit" -ArgumentList "/set numproc $logicalProcessorsNew"
        Write-Host "Changed from $logicalProcessors core to $logicalProcessorsNew shared core and 1 isolated core."
    }

    #### Invoke Remote Command ####
    Invoke-Command -Session $Session -ScriptBlock $code
}