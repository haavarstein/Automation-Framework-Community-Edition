Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)	

$MyConfigFileloc = ("Settings.xml")
[xml]$MyConfigFile = (Get-Content $MyConfigFileLoc)

$CVM = $MyConfigFile.Post.CVM
$User = $MyConfigFile.Post.User
$Pwd = $MyConfigFile.Post.Pwd
$Password = ConvertTo-SecureString $Pwd -AsPlainText -Force
$Network = $MyConfigFile.Post.NetName
$ISO = $MyConfigFile.Post.ISO

Write-Verbose "Connecting to CVM" -Verbose

Import-Module "C:\Program Files (x86)\Nutanix Inc\NutanixCmdlets\Modules\NutanixCmdletsPSSnapin.dll"
Add-PSSnapin nutanixcmdletspssnapin
connect-ntnxcluster -server $CVM -username $User -password $Password -AcceptInvalidSSLCerts -ForcedConnection
get-ntnxcluster

# SQL-01

$VMName = "SQL-01"
$MAC = "50:6b:8d:1d:20:01"
$VRAM = 2048
$VCPU = 2

New-NTNXVirtualMachine -Name $VMName -NumVcpus $VCPU -MemoryMb $VRAM

## Disk Creation - Setting the SCSI disk of 50GB on Containner ID 1025 (get-ntnxcontainer -> ContainerId)
$diskCreateSpec = New-NTNXObject -Name VmDiskSpecCreateDTO
$diskcreatespec.containerName = "default-container-81102177377574"
$diskcreatespec.sizeMb = 51200
 
Start-Sleep -s 3

# Get the VmID of the VM
$vminfo = Get-NTNXVM | where {$_.vmName -eq $VMName}
$vmId = ($vminfo.vmid.split(":"))[2]

# Set NIC for VM on default vlan (Get-NTNXNetwork -> NetworkUuid)
$nic = New-NTNXObject -Name VMNicSpecDTO
$nic.networkUuid = $Network
$nic.macAddress = $MAC

Add-NTNXVMNic -Vmid $vmId -SpecList $nic

# Creating the Disk
$vmDisk =  New-NTNXObject –Name VMDiskDTO
$vmDisk.vmDiskCreate = $diskCreateSpec
 
# Mount ISO Image
$diskCloneSpec = New-NTNXObject -Name VMDiskSpecCloneDTO
$ISOImage = (Get-NTNXImage | ?{$_.name -eq $ISO})
$diskCloneSpec.vmDiskUuid = $ISOImage.vmDiskId
#setup the new ISO disk from the Cloned Image
$vmISODisk = New-NTNXObject -Name VMDiskDTO
#specify that this is a Cdrom
$vmISODisk.isCdrom = $true
$vmISODisk.vmDiskClone = $diskCloneSpec
$vmDisk = @($vmDisk)
$vmDisk += $vmISODisk

# Adding the Disk ^ ISO to the VM
Add-NTNXVMDisk -Vmid $vmId -Disks $vmDisk

# Power On the VM
Set-NTNXVMPowerOn -Vmid $VMid

# XADC-01

$VMName = "XADC-01"
$MAC = "50:6b:8d:1d:20:04"
$VRAM = 2048
$VCPU = 2
New-NTNXVirtualMachine -Name $VMName -NumVcpus $VCPU -MemoryMb $VRAM

## Disk Creation - Setting the SCSI disk of 50GB on Containner ID 1025 (get-ntnxcontainer -> ContainerId)
$diskCreateSpec = New-NTNXObject -Name VmDiskSpecCreateDTO
$diskcreatespec.containerName = "default-container-81102177377574"
$diskcreatespec.sizeMb = 51200
 
Start-Sleep -s 3

# Get the VmID of the VM
$vminfo = Get-NTNXVM | where {$_.vmName -eq $VMName}
$vmId = ($vminfo.vmid.split(":"))[2]

# Set NIC for VM on default vlan (Get-NTNXNetwork -> NetworkUuid)
$nic = New-NTNXObject -Name VMNicSpecDTO
$nic.networkUuid = $Network
$nic.macAddress = $MAC

Add-NTNXVMNic -Vmid $vmId -SpecList $nic

# Creating the Disk
$vmDisk =  New-NTNXObject –Name VMDiskDTO
$vmDisk.vmDiskCreate = $diskCreateSpec
 
# Mount ISO Image
$diskCloneSpec = New-NTNXObject -Name VMDiskSpecCloneDTO
$ISOImage = (Get-NTNXImage | ?{$_.name -eq $ISO})
$diskCloneSpec.vmDiskUuid = $ISOImage.vmDiskId
#setup the new ISO disk from the Cloned Image
$vmISODisk = New-NTNXObject -Name VMDiskDTO
#specify that this is a Cdrom
$vmISODisk.isCdrom = $true
$vmISODisk.vmDiskClone = $diskCloneSpec
$vmDisk = @($vmDisk)
$vmDisk += $vmISODisk

# Adding the Disk ^ ISO to the VM
Add-NTNXVMDisk -Vmid $vmId -Disks $vmDisk

# Power On the VM
Set-NTNXVMPowerOn -Vmid $VMid

# PVS-01

$VMName = "PVS-01"
$MAC = "50:6b:8d:1d:20:02"
$VRAM = 2048
$VCPU = 2

New-NTNXVirtualMachine -Name $VMName -NumVcpus $VCPU -MemoryMb $VRAM

## Disk Creation - Setting the SCSI disk of 50GB on Containner ID 1025 (get-ntnxcontainer -> ContainerId)
$diskCreateSpec = New-NTNXObject -Name VmDiskSpecCreateDTO
$diskcreatespec.containerName = "default-container-81102177377574"
$diskcreatespec.sizeMb = 102400
 
Start-Sleep -s 3

# Get the VmID of the VM
$vminfo = Get-NTNXVM | where {$_.vmName -eq $VMName}
$vmId = ($vminfo.vmid.split(":"))[2]

# Set NIC for VM on default vlan (Get-NTNXNetwork -> NetworkUuid)
$nic = New-NTNXObject -Name VMNicSpecDTO
$nic.networkUuid = $Network
$nic.macAddress = $MAC

Add-NTNXVMNic -Vmid $vmId -SpecList $nic

# Creating the Disk
$vmDisk =  New-NTNXObject –Name VMDiskDTO
$vmDisk.vmDiskCreate = $diskCreateSpec
 
# Mount ISO Image
$diskCloneSpec = New-NTNXObject -Name VMDiskSpecCloneDTO
$ISOImage = (Get-NTNXImage | ?{$_.name -eq $ISO})
$diskCloneSpec.vmDiskUuid = $ISOImage.vmDiskId
#setup the new ISO disk from the Cloned Image
$vmISODisk = New-NTNXObject -Name VMDiskDTO
#specify that this is a Cdrom
$vmISODisk.isCdrom = $true
$vmISODisk.vmDiskClone = $diskCloneSpec
$vmDisk = @($vmDisk)
$vmDisk += $vmISODisk

# Adding the Disk ^ ISO to the VM
Add-NTNXVMDisk -Vmid $vmId -Disks $vmDisk

# Power On the VM
Set-NTNXVMPowerOn -Vmid $VMid

# WS16MCS-MI

$VMName = "WS16MCS-MI"
$MAC = "50:6b:8d:1d:20:03"
$VRAM = 2048
$VCPU = 2

New-NTNXVirtualMachine -Name $VMName -NumVcpus $VCPU -MemoryMb $VRAM

## Disk Creation - Setting the SCSI disk of 50GB on Containner ID 1025 (get-ntnxcontainer -> ContainerId)
$diskCreateSpec = New-NTNXObject -Name VmDiskSpecCreateDTO
$diskcreatespec.containerName = "default-container-81102177377574"
$diskcreatespec.sizeMb = 51200
 
Start-Sleep -s 3

# Get the VmID of the VM
$vminfo = Get-NTNXVM | where {$_.vmName -eq $VMName}
$vmId = ($vminfo.vmid.split(":"))[2]

# Set NIC for VM on default vlan (Get-NTNXNetwork -> NetworkUuid)
$nic = New-NTNXObject -Name VMNicSpecDTO
$nic.networkUuid = $Network
$nic.macAddress = $MAC

Add-NTNXVMNic -Vmid $vmId -SpecList $nic

# Creating the Disk
$vmDisk =  New-NTNXObject –Name VMDiskDTO
$vmDisk.vmDiskCreate = $diskCreateSpec
 
# Mount ISO Image
$diskCloneSpec = New-NTNXObject -Name VMDiskSpecCloneDTO
$ISOImage = (Get-NTNXImage | ?{$_.name -eq $ISO})
$diskCloneSpec.vmDiskUuid = $ISOImage.vmDiskId
#setup the new ISO disk from the Cloned Image
$vmISODisk = New-NTNXObject -Name VMDiskDTO
#specify that this is a Cdrom
$vmISODisk.isCdrom = $true
$vmISODisk.vmDiskClone = $diskCloneSpec
$vmDisk = @($vmDisk)
$vmDisk += $vmISODisk

# Adding the Disk ^ ISO to the VM
Add-NTNXVMDisk -Vmid $vmId -Disks $vmDisk

# Power On the VM
Set-NTNXVMPowerOn -Vmid $VMid

