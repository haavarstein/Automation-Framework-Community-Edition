$Network = "Internal"
$ISO = "C:\ISO\HYDRATION.iso"
$VMLoc = "C:\Virtual Hard Disks"

# SQL-01

$VMName = "SQL-01"
$MAC = "00:15:5D:1D:20:01"
$VMGen = "1"
$vCPU = "2"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU

# PVS-01

$VMName = "PVS-01"
$MAC = "00:15:5D:1D:20:02"
$VMGen = "1"
$vCPU = "2"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 100GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU

# XADC-01

$VMName = "XADC-01"
$MAC = "00:15:5D:1D:20:04"
$VMGen = "1"
$vCPU = "2"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU
