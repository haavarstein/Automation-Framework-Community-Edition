# PowerShell Wrapper for MDT, Standalone and Chocolatey Installation - (C)2015 xenappblog.com 

# Example 1: Start-Process "XenDesktopServerSetup.exe" -ArgumentList $unattendedArgs -Wait -Passthru

# Example 2 Powershell: Start-Process powershell.exe -ExecutionPolicy bypass -file $Destination

# Example 3 EXE (Always use ' '):
# $UnattendedArgs='/qn'
# (Start-Process "$PackageName.$InstallerType" $UnattendedArgs -Wait -Passthru).ExitCode

# Example 4 MSI (Always use " "):
# $UnattendedArgs = "/i $PackageName.$InstallerType ALLUSERS=1 /qn /liewa $LogApp"
# (Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -Passthru).ExitCode

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

# Add Module
Import-Module VMware.DeployAutomation

# Connect to vCenter Server
Connect-viserver $VCenter -user $VCUser -password $VCPwd -WarningAction 0

# SQL-01

$VMName = "SQL-01"
$MAC = "00:50:56:1D:20:01"
$VRAM = 2048
$VCPU = 2
$VMDiskGB = 40

$LogPS = "${env:SystemRoot}" + "\Temp\$VMName.log"
Start-Transcript $LogPS

New-VM -Name $VMName -VMHost $ESXi -numcpu $VCPU -MemoryMB $VRAM -DiskGB $VMDiskGB -DiskStorageFormat $VMDiskType -Datastore $VMDS -GuestId $VMGuestOS -NetworkName $NetName -CD
Get-VM $VMName | Get-NetworkAdapter | Set-NetworkAdapter -Type $NICType -MacAddress $MAC -StartConnected:$true -Confirm:$false
Get-VM $VMName | Get-CDDrive | Set-CDDrive -ISOPath $ISO -StartConnected:$true -Confirm:$false
Start-VM -VM $VMName -confirm:$false -RunAsync

# VCS-01

$VMName = "VCS-01"
$MAC = "00:50:56:1D:20:04"
$VRAM = 4096
$VCPU = 4
$VMDiskGB = 40

$LogPS = "${env:SystemRoot}" + "\Temp\$VMName.log"
Start-Transcript $LogPS

New-VM -Name $VMName -VMHost $ESXi -numcpu $VCPU -MemoryMB $VRAM -DiskGB $VMDiskGB -DiskStorageFormat $VMDiskType -Datastore $VMDS -GuestId $VMGuestOS -NetworkName $NetName -CD
Get-VM $VMName | Get-NetworkAdapter | Set-NetworkAdapter -Type $NICType -MacAddress $MAC -StartConnected:$true -Confirm:$false
Get-VM $VMName | Get-CDDrive | Set-CDDrive -ISOPath $ISO -StartConnected:$true -Confirm:$false
Start-VM -VM $VMName -confirm:$false -RunAsync

# CLIENT-01

$VMName = "CLIENT-01"
$MAC = "00:50:56:1D:20:03"
$VRAM = 2048
$VCPU = 2
$VMDiskGB = 40

$LogPS = "${env:SystemRoot}" + "\Temp\$VMName.log"
Start-Transcript $LogPS

New-VM -Name $VMName -VMHost $ESXi -numcpu $VCPU -MemoryMB $VRAM -DiskGB $VMDiskGB -DiskStorageFormat $VMDiskType -Datastore $VMDS -GuestId $VMGuestOS -NetworkName $NetName -CD
Get-VM $VMName | Get-NetworkAdapter | Set-NetworkAdapter -Type $NICType -MacAddress $MAC -StartConnected:$true -Confirm:$false
Get-VM $VMName | Get-CDDrive | Set-CDDrive -ISOPath $ISO -StartConnected:$true -Confirm:$false
Start-VM -VM $VMName -confirm:$false -RunAsync

# WS16RDSH-01

$VMName = "WS16RDSH-01"
$MAC = "00:50:56:1D:20:02"
$VRAM = 2048
$VCPU = 2
$VMDiskGB = 100

$LogPS = "${env:SystemRoot}" + "\Temp\$VMName.log"
Start-Transcript $LogPS

New-VM -Name $VMName -VMHost $ESXi -numcpu $VCPU -MemoryMB $VRAM -DiskGB $VMDiskGB -DiskStorageFormat $VMDiskType -Datastore $VMDS -GuestId $VMGuestOS -NetworkName $NetName -CD
Get-VM $VMName | Get-NetworkAdapter | Set-NetworkAdapter -Type $NICType -MacAddress $MAC -StartConnected:$true -Confirm:$false
Get-VM $VMName | Get-CDDrive | Set-CDDrive -ISOPath $ISO -StartConnected:$true -Confirm:$false
Start-VM -VM $VMName -confirm:$false -RunAsync

# WS16RDSH-01

$VMName = "WS16RDSH-02"
$MAC = "00:50:56:1D:20:05"
$VRAM = 2048
$VCPU = 2
$VMDiskGB = 100

$LogPS = "${env:SystemRoot}" + "\Temp\$VMName.log"
Start-Transcript $LogPS

New-VM -Name $VMName -VMHost $ESXi -numcpu $VCPU -MemoryMB $VRAM -DiskGB $VMDiskGB -DiskStorageFormat $VMDiskType -Datastore $VMDS -GuestId $VMGuestOS -NetworkName $NetName -CD
Get-VM $VMName | Get-NetworkAdapter | Set-NetworkAdapter -Type $NICType -MacAddress $MAC -StartConnected:$true -Confirm:$false
Get-VM $VMName | Get-CDDrive | Set-CDDrive -ISOPath $ISO -StartConnected:$true -Confirm:$false
Start-VM -VM $VMName -confirm:$false -RunAsync

Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript