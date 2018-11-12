# WS16PVS-MI-HV

$VMName = "WS16MCS-MI-HV"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:05"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "1"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB  -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network

# Configure Virtual Machines
Set-VMNetworkAdapter -VMName $VMName
Set-VMProcessor -VMName $VMName -Count $vCPU
Set-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false 
