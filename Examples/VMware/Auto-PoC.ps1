﻿Function Set-SecureBoot {
    <#
    .SYNOPSIS Enable/Disable Seure Boot setting for a VM in vSphere 6.5
    .NOTES  Author:  William Lam
    .NOTES  Site:    www.virtuallyghetto.com
    .PARAMETER Vm
      VM to enable/disable Secure Boot
    .EXAMPLE
      Get-VM -Name Windows10 | Set-SecureBoot -Enabled
    .EXAMPLE
      Get-VM -Name Windows10 | Set-SecureBoot -Disabled
    #>
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        [VMware.VimAutomation.ViCore.Impl.V1.Inventory.InventoryItemImpl]$Vm,
        [Switch]$Enabled,
        [Switch]$Disabled
     )

    if($Enabled) {
        $secureBootSetting = $true
        $reconfigMessage = "Enabling Secure Boot for $Vm"
    }
    if($Disabled) {
        $secureBootSetting = $false
        $reconfigMessage = "Disabling Secure Boot for $Vm"
    }

    $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
    $bootOptions = New-Object VMware.Vim.VirtualMachineBootOptions
    $bootOptions.EfiSecureBootEnabled = $secureBootSetting
    $spec.BootOptions = $bootOptions
  
    #Write-Host "`n$reconfigMessage ..."
    $task = $vm.ExtensionData.ReconfigVM_Task($spec)
    $task1 = Get-Task -Id ("Task-$($task.value)")
    $task1 | Wait-Task | Out-Null
}

# PowerShell Wrapper for MDT, Standalone and Chocolatey Installation - (C)2015 xenappblog.com 
# Example 1: Start-Process "XenDesktopServerSetup.exe" -ArgumentList $unattendedArgs -Wait -Passthru
# Example 2 Powershell: Start-Process powershell.exe -ExecutionPolicy bypass -file $Destination
# Example 3 EXE (Always use ' '):
# $UnattendedArgs='/qn'
# (Start-Process "$PackageName.$InstallerType" $UnattendedArgs -Wait -Passthru).ExitCode
# Example 4 MSI (Always use " "):
# $UnattendedArgs = "/i $PackageName.$InstallerType ALLUSERS=1 /qn /liewa $LogApp"
# (Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -Passthru).ExitCode

Clear-Host
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)	

$MyConfigFileloc = ("Settings.xml")
[xml]$MyConfigFile = (Get-Content $MyConfigFileLoc)

$VCenter = $MyConfigFile.Post.VCenter
$VCUser = $MyConfigFile.Post.VCUser
$VCPwd = $MyConfigFile.Post.VCPwd
$VMDiskType = $MyConfigFile.Post.VMDiskType
$VMDS = $MyConfigFile.Post.VMDS
$VMCluster = $MyConfigFile.Post.VMCluster
$VMFolder = $MyConfigFile.Post.VMFolder
$NICType = $MyConfigFile.Post.NICType
$NetName = $MyConfigFile.Post.NetName
$VMGuestOS = $MyConfigFile.Post.VMGuestOS
$ISO = $MyConfigFile.Post.ISO
$ESXi = $MyConfigFile.Post.ESXi		# ESXi Standalone Host when not using $VMCluster

if (!(Test-Path -Path "C:\Program Files\PackageManagement\ProviderAssemblies\nuget")) {Find-PackageProvider -Name 'Nuget' -ForceBootstrap -IncludeDependencies}
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
if (!(Get-Module -ListAvailable -Name VMware.PowerCLI)) {Install-Module -Name VMware.PowerCLI -AllowClobber}

# Add Module
Import-Module VMware.DeployAutomation
#Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -ErrorAction SilentlyContinue
#Set-PowerCLIConfiguration -Scope User -InvalidCertificateAction Ignore -ErrorAction SilentlyContinue

# Connect to vCenter Server
Connect-viserver $VCenter -user $VCUser -password $VCPwd -WarningAction 0

# DC-01

$VMName = "DC-01"
$MAC = "00:50:56:00:50:01"
$VRAM = 2048
$VCPU = 2
$VMDiskGB = 40

$LogPS = "${env:SystemRoot}" + "\Temp\$VMName.log"
Start-Transcript $LogPS | Out-Null

New-VM -Name $VMName -VMHost $ESXi -numcpu $VCPU -MemoryMB $VRAM -DiskGB $VMDiskGB -DiskStorageFormat $VMDiskType -Datastore $VMDS -GuestId $VMGuestOS -NetworkName $NetName
Start-Sleep -s 15
Get-VM $VMName | Get-NetworkAdapter | Set-NetworkAdapter -Type $NICType -MacAddress $MAC -StartConnected:$true -Confirm:$false

$VM = Get-VM $VMName
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.Firmware = [VMware.Vim.GuestOsDescriptorFirmwareType]::efi
$vm.ExtensionData.ReconfigVM($spec)
Get-VM -Name $VMName | Set-SecureBoot -Enabled
Start-Sleep -s 15
Start-VM -VM $VMName -confirm:$false -RunAsync

Start-Sleep -s 1500

# DC-02

$VMName = "DC-02"
$MAC = "00:50:56:00:50:02"
$VRAM = 2048
$VCPU = 2
$VMDiskGB = 40

$LogPS = "${env:SystemRoot}" + "\Temp\$VMName.log"
Start-Transcript $LogPS

New-VM -Name $VMName -VMHost $ESXi -numcpu $VCPU -MemoryMB $VRAM -DiskGB $VMDiskGB -DiskStorageFormat $VMDiskType -Datastore $VMDS -GuestId $VMGuestOS -NetworkName $NetName
Get-VM $VMName | Get-NetworkAdapter | Set-NetworkAdapter -Type $NICType -MacAddress $MAC -StartConnected:$true -Confirm:$false

$VM = Get-VM $VMName
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.Firmware = [VMware.Vim.GuestOsDescriptorFirmwareType]::efi
$vm.ExtensionData.ReconfigVM($spec)
Get-VM -Name $VMName | Set-SecureBoot -Enabled
Start-Sleep -s 15
Start-VM -VM $VMName -confirm:$false -RunAsync

# RAS-WS19-GW

$VMName = "RAS-WS19-GW"
$MAC = "00:50:56:00:50:04"
$VRAM = 2048
$VCPU = 2
$VMDiskGB = 40

$LogPS = "${env:SystemRoot}" + "\Temp\$VMName.log"
Start-Transcript $LogPS

New-VM -Name $VMName -VMHost $ESXi -numcpu $VCPU -MemoryMB $VRAM -DiskGB $VMDiskGB -DiskStorageFormat $VMDiskType -Datastore $VMDS -GuestId $VMGuestOS -NetworkName $NetName
Get-VM $VMName | Get-NetworkAdapter | Set-NetworkAdapter -Type $NICType -MacAddress $MAC -StartConnected:$true -Confirm:$false

$VM = Get-VM $VMName
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.Firmware = [VMware.Vim.GuestOsDescriptorFirmwareType]::efi
$vm.ExtensionData.ReconfigVM($spec)
Get-VM -Name $VMName | Set-SecureBoot -Enabled
Start-Sleep -s 15
Start-VM -VM $VMName -confirm:$false -RunAsync

# RAS-WS19-01

$VMName = "RAS-WS19-01"
$MAC = "00:50:56:00:50:05"
$VRAM = 4096
$VCPU = 2
$VMDiskGB = 60

$LogPS = "${env:SystemRoot}" + "\Temp\$VMName.log"
Start-Transcript $LogPS

New-VM -Name $VMName -VMHost $ESXi -numcpu $VCPU -MemoryMB $VRAM -DiskGB $VMDiskGB -DiskStorageFormat $VMDiskType -Datastore $VMDS -GuestId $VMGuestOS -NetworkName $NetName
Get-VM $VMName | Get-NetworkAdapter | Set-NetworkAdapter -Type $NICType -MacAddress $MAC -StartConnected:$true -Confirm:$false

$VM = Get-VM $VMName
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.Firmware = [VMware.Vim.GuestOsDescriptorFirmwareType]::efi
$vm.ExtensionData.ReconfigVM($spec)
Get-VM -Name $VMName | Set-SecureBoot -Enabled
Start-Sleep -s 15
Start-VM -VM $VMName -confirm:$false -RunAsync

Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript