# WS16PVS-MI-HV

$VMName = "WS16MCS-MI-HV"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:05"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "2"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
$DVD = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVD
Set-VMFirmware -VMName $VMName –EnableSecureBoot Off
Set-VMNetworkAdapter -VMName $VMName -StaticMacAddress $MAC
Set-VMProcessor -VMName $VMName -Count $vCPU
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
