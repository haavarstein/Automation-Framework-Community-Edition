# RAS-01

$VMName = "RAS-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:08"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "2"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
$DVD = Get-VMDvdDrive -VMName $VMName
Set-VM -Name $VMName -AutomaticCheckpointsEnabled $false
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVD
Set-VMFirmware -VMName $VMName –EnableSecureBoot Off
Set-VMProcessor -VMName $VMName -Count $vCPU
Set-VMNetworkAdapter  -VMName $VMName -StaticMacAddress $MAC
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
Set-VMVideo -VMName $VMName -ResolutionType Single -HorizontalResolution 1280 -VerticalResolution 720

# WS16RDSH-01

$VMName = "WS16RDSH-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:09"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "2"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
$DVD = Get-VMDvdDrive -VMName $VMName
Set-VM -Name $VMName -AutomaticCheckpointsEnabled $false
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVD
Set-VMFirmware -VMName $VMName –EnableSecureBoot Off
Set-VMProcessor -VMName $VMName -Count $vCPU
Set-VMNetworkAdapter  -VMName $VMName -StaticMacAddress $MAC
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
Set-VMVideo -VMName $VMName -ResolutionType Single -HorizontalResolution 1280 -VerticalResolution 720

# WS16RDSH-02

$VMName = "WS16RDSH-02"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:10"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "2"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
$DVD = Get-VMDvdDrive -VMName $VMName
Set-VM -Name $VMName -AutomaticCheckpointsEnabled $false
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVD
Set-VMFirmware -VMName $VMName –EnableSecureBoot Off
Set-VMProcessor -VMName $VMName -Count $vCPU
Set-VMNetworkAdapter  -VMName $VMName -StaticMacAddress $MAC
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
Set-VMVideo -VMName $VMName -ResolutionType Single -HorizontalResolution 1280 -VerticalResolution 720

# CLIENT-01

$VMName = "CLIENT-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:11"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "2"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
$DVD = Get-VMDvdDrive -VMName $VMName
Set-VM -Name $VMName -AutomaticCheckpointsEnabled $false
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVD
Set-VMFirmware -VMName $VMName –EnableSecureBoot Off
Set-VMProcessor -VMName $VMName -Count $vCPU
Set-VMNetworkAdapter  -VMName $VMName -StaticMacAddress $MAC
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
Set-VMVideo -VMName $VMName -ResolutionType Single -HorizontalResolution 1280 -VerticalResolution 720