# SQL-01

$VMName = "SQL-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:01"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "2"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
$DVD = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVD
Set-VMProcessor -VMName $VMName -Count $vCPU
Set-VMFirmware -VMName $VMName –EnableSecureBoot Off

# PVS-01

$VMName = "PVS-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:02"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "2"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 100GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
$DVD = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVD
Set-VMProcessor -VMName $VMName -Count $vCPU
Set-VMFirmware -VMName $VMName –EnableSecureBoot Off

# XADC-01

$VMName = "XADC-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:04"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "2"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
$DVD = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVD
Set-VMProcessor -VMName $VMName -Count $vCPU
Set-VMFirmware -VMName $VMName –EnableSecureBoot Off