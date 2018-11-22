<#-----------------------------------------------------------------------------
  Create a new Azure Virtual Machine

  Author
    Robert C. Cain | @ArcaneCode | info@arcanetc.com | http://arcanecode.me
 
  Details
    This example walks you through the steps involved to create a virtual
    machine in Azure, using the module PSAzure. You can find the complete
    code at:
    https://github.com/arcanecode/PowerShell/tree/master/PSAzure_Module
    
    You'll start by creating a resource group, then a storage account to 
    hold the VM.

    Next you will need to create a virtual network, and along with it
    a virtual network security group that holds the firewall rules to allow
    traffic in and out of your new virtual machine.
    
    After that you create a virtual NIC (Network Interface Card) that 
    the VM will use to talk to the virtual network. 

    Finally, you are ready to create the VM! To do so, you will need
    to gather certain parameteres ahead of time, such as what image to
    use to create the machine, and how big the machine should be. 
    The script 'Get-AzureVMOptions.ps1', located in these samples,
    walks you through the steps needed to get this information. 

    As a final step the script creates an RDP file to login to your
    VM remotely, then launches it. 

    VERBOSE - Almost all the calls to functions in PSAzure add the 
              -Verbose switch. This is done for learning purposes. 
              Should you adopt this to your own environment you will
              likely want to remove these. 

  Notices
    This module is Copyright (c) 2017, 2018 Robert C. Cain. All rights
    reserved. The code herein is for demonstration purposes. No warranty
    or guarentee is implied or expressly granted. 
    
    This code may be used in your projects. 
    
    This code may NOT be reproduced in whole or in part, in print, video, or
    on the internet, without the express written consent of the author. 

-----------------------------------------------------------------------------#>

Clear-Host
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)

# Path to demos - Set this to where you want to store your code
$dir = "C:\PowerShell\PSAzure-Module\PSAzure-Examples"
#$dir = "$($env:ONEDRIVE)\Pluralsight\PSAzure-Module\PSAzure-Examples"
Set-Location $dir

# Load our module, or force a reload in case it's already loaded
# Assumes you have already installed the module.
Import-Module PSAzure -Force 

# Login. To make login quicker, this uses function looks to 
# see if a profile context file (named, by default, ProfileContext.ctx)
# exists. If so, it uses that info to make logging in easier.
# See the script Create-ProfileContext.ps1 on how to create this file.
# See the help for Connect-PSToAzure for a list of locations where it will
# automatically look for the file, or pass in the location using the -Path
# parameter.

Connect-PSToAzure -Verbose

#------------------------------------------------------------------------------
# Set the foundation. 
#------------------------------------------------------------------------------

# Start with Variable Declaration. This keeps them together for 
# easy copy to other projects.
$resourceGroup = 'xenapptraining'
$location = 'southcentralus'

# Storage account name must be between 3 and 24 characters 
# and use numbers and lower-case letters only.
# PSAzure has function that can validate the naming rules
$storageAccount = 'xenapptrainingstorageact'

$vmName = 'Hyper-V'

# Storage account names must be unique across all of Azure. You can 
# check to see if the storage account name you want to use has been
# taken already. Returns true if the name is available
$saAvailable = Test-PSStorageAccountNameAvailability `
                   -StorageAccountName $storageAccount `
                   -Verbose
Write-Host "Is the name available? $saAvailable"

# You can test to see if the storage account already exists in your
# environment. Returns true if it exists, false otherwise
$saExists = Test-PSStorageAccount `
                -StorageAccountName $storageAccount `
                -ResourceGroupName $resourceGroup `
                -Location $location
Write-Host "Does the account already exist in our environment? $saExists"

# The script from here on assumes the name is available on Azure, and
# that it meets the naming conventions. Depending on your task you may
# wish to adapt this with error handling for an unavailable name or
# an invalid name.

# Create a resource group for our test
New-PSResourceGroup -ResourceGroupName $resourceGroup `
                    -Location $location `
                   
# Create a storage account to keep the VM in
New-PSStorageAccount -StorageAccountName $storageAccount `
                     -ResourceGroupName $resourceGroup `
                     -Location $location `

#------------------------------------------------------------------------------
# Create the virtual networking components
#------------------------------------------------------------------------------

# Network related variables
$networkSecurityGroup = 'xenapptrainingSecurityGroup'
$networkName = 'xenapptrainingNetwork'
$networkAddress = '192.168.0.0/16'
$subnetName = 'xenapptrainingNetworkSubnet'
$subnetAddress = '192.168.100.0/24'
$nicName = "$vmName" + "-Nic"

# Create an Azure Virtual Network
New-PSAzureVirtualNetwork -ResourceGroupName $resourceGroup `
                          -VirtualNetworkName $networkName `
                          -VirtualSubnetName $subnetName `
                          -VirtualNetworkAddress $networkAddress `
                          -VirtualSubnetAddress $subnetAddress `
                          -Location $location `

# Now to create a security group that will configure the 
# firewall for the virtual network
New-PSAzureNetworkSecurityGroup -ResourceGroupName $resourceGroup `
                                -NetworkSecurityGroupName $networkSecurityGroup `
                                -Location $location `

# Finally create the NIC the VM will use to connect to the network
New-PSAzureVirtualNIC -ResourceGroupName $resourceGroup `
                      -NICName $nicName `
                      -VirtualNetworkName $networkName `
                      -NetworkSecurityGroupName $networkSecurityGroup `
                      -Location $location `

#------------------------------------------------------------------------------
# Now you can create the VM
#------------------------------------------------------------------------------

# VM Related Variables
$adminName = 'eucadministrator'
$diskName = "$vmName" + '-Disk'

# The supplied password must be between 8-123 characters long and must 
# satisfy at least 3 of password complexity requirements from the following: 
# 1) Contains an uppercase character
# 2) Contains a lowercase character
# 3) Contains a numeric digit
# 4) Contains a special character
# 5) Control characters are not allowed
$adminPW = 'ZgIiiywerf20BDAbAy2n'

# Note these values were derived using the examples in the script
# Get-AzureVMOptions.ps1
# $vmSize = 'Standard_B2s'
$vmSize = 'Standard_D16_v3'
$vmPublisher = 'MicrosoftWindowsServer' 
$vmOffer = 'WindowsServer' 
$vmSKU = '2016-Datacenter' 
# By default it uses the latest version for a SKU

# Now we can create our VM! This might take a while depending
# on the options we selected and how busy Azure happens to be.
# Be patient if nothing is returned for several minutes. (Your
# humble author has seen it take as long as 20 minutes to create
# a VM.)
New-PSAzureVM `
   -ResourceGroupName $resourceGroup `
   -VMName $vmName `
   -VMAdminName $adminName `
   -VMAdminPassword $adminPW `
   -VMSize $vmSize `
   -Publisher $vmPublisher `
   -Offer $vmOffer `
   -SKU $vmSKU `
   -StorageAccountName $storageAccount `
   -DiskName $diskName `
   -NICName $nicName `
   -Location $location `
   -Verbose

# Get its current status, just to show it is running
Get-PSAzureVMStatus -ResourceGroupName $resourceGroup `
                    -VMName $vmName `
                    -Verbose

# https://365lab.net/2016/02/25/domain-join-azurerm-vms-with-powershell/
function Add-JDAzureRMVMToDomain {
<#
.SYNOPSIS
    The function joins Azure RM virtual machines to a domain.
.EXAMPLE
    Get-AzureRmVM -ResourceGroupName 'ADFS-WestEurope' | Select-Object Name,ResourceGroupName | Out-GridView -PassThru | Add-JDAzureRMVMToDomain -DomainName corp.acme.com -Verbose
.EXAMPLE
    Add-JDAzureRMVMToDomain -DomainName corp.acme.com -VMName AMS-ADFS1 -ResourceGroupName 'ADFS-WestEurope'
.NOTES
    Author   : Johan Dahlbom, johan[at]dahlbom.eu
    Blog     : 365lab.net
    The script are provided “AS IS” with no guarantees, no warranties, and it confer no rights.
#>
 
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    [Parameter(Mandatory=$false)]
    [System.Management.Automation.PSCredential]$Credentials,
    [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [Alias('VMName')]
    [string]$Name,
    [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateScript({Get-AzureRmResourceGroup -Name $_})]
    [string]$ResourceGroupName
)
    begin {
        #Define domain join settings (username/domain/password)
        $Settings = @{
            Name = $DomainName
            User = $Credentials.UserName
            Restart = "true"
            Options = 3
        }
        $ProtectedSettings =  @{
                Password = $Credentials.GetNetworkCredential().Password
        }
        Write-Verbose -Message "Domainname is: $DomainName"
    }
    process {
        try {
            $RG = Get-AzureRmResourceGroup -Name $ResourceGroupName
            $JoinDomainHt = @{
                ResourceGroupName = $RG.ResourceGroupName
                ExtensionType = 'JsonADDomainExtension'
                Name = 'joindomain'
                Publisher = 'Microsoft.Compute'
                TypeHandlerVersion = '1.0'
                Settings = $Settings
                VMName = $Name
                ProtectedSettings = $ProtectedSettings
                Location = $RG.Location
            }
            Write-Verbose -Message "Joining $Name to $DomainName"
            Set-AzureRMVMExtension @JoinDomainHt
        } catch {
            Write-Warning $_
        }
    }
    end { }
}


$securePW = Convertto-secureString -asplaintext -force -string "$adminPW"
$creds = [PSCredential]::new($adminName,$SecurePW);
Add-JDAzureRMVMToDomain -DomainName ctxlab.local -VMName $vmName -ResourceGroupName $resourceGroup

# Generate the file name for the RDP.
# Create the RDP for the new VM and open it
# (Note if the RDP already exists, it will be deleted
#  then recreated.)
$rdpFile = "$($dir)\$($vmName).rdp"
New-PSAzureVMRDP -ResourceGroupName $resourceGroup `
                 -VMName $vmName `
                 -Path $rdpFile `
                 -Verbose

# Run the RDP to connect to the new VM
# When the connection pops up, be sure to use "More Choices"
# Enter the user name and password specified in the
# variables. Before running though we need to give it a bit
# got get fully started, hence the Sleep cmdlet. Once it
# is up, you won't need sleep anymore.

Start-Sleep -Seconds 60
Invoke-Item $rdpFile

Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
