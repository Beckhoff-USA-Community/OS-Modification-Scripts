# About This Repo

This repo holds some easy-to-use PowerShell templates for automating the Beckhoff IPC/CX image modification process. The scripts located in this repo are not meant to cover all possible options extensively, but they can be used as a starting point for building up your OS image automation pipeline. The current samples cover topics such as changing the default administrator password, installing TwinCAT XAR, installing TwinCAT TFs, and activating core isolation.

# How To Use

There are two ways to execute these scripts, remotely or locally. Below we outline each use-case and the process to run them.

### 1. Local Execution

For local execution, simply find the scripts of interest that are located in the [Samples](Samples) directory. There are some basic samples available, and all they need is slight configuration to the script before running. These modifications might be a username/password, or installer .exe location.

The idea behind local execution of the scripts is that they will sit on a USB stick, along with the XAR and TF installers. The commissioning user can got through each script 1-by-1 and enable each feature by right-clicking the script and selecting **Run with PowerShell**. 

### 2. Remote Execution

Remote execution allows you to run the scripts remotely from your development system. Before attempting remote execution, you will need to run the **EnableRemoteDeployment.ps1** script on the controller to allow remote access. Be sure that when you are finished you run the **DisableRemoteDeployment.ps1** to clean up this remote access feature.

Inside the [Remote Deployment](Remote_Deployment) directory, you will find a **Playbook.ps1** script and a **Beckhoff_Functions.ps1** script. Be sure to read these in detail so that you understand how the functions work. The Beckhoff_Functions are very similar to the local execution samples, but have been modified to be "ScriptBlock" wrapped functions. This allows them to be called easier from the playbook, and run remotely under the hood using the **Invoke-Command** feature with PowerShell.

