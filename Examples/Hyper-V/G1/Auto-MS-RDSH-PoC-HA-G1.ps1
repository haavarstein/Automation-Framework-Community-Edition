# SQL-01

$VMName = "SQL-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:01"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "1"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU
Start-VM $VMName

# RDGW-01

$VMName = "RDGW-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:20"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "1"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

$IPAddress = @("192.168.1.20")
$Subnet = @("255.255.255.0")
$DefaultGateway = @("192.168.1.1")
$DNSServers = @("192.168.1.10")

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU
Start-VM $VMName

# RDGW-02

$VMName = "RDGW-02"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:21"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "1"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU
Start-VM $VMName

# RDWA-01

$VMName = "RDWA-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:22"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "1"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU
Start-VM $VMName

# RDWA-02

$VMName = "RDWA-02"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:23"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "1"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU
Start-VM $VMName

# RDCB-01

$VMName = "RDCB-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:24"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "1"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU
Start-VM $VMName

# RDCB-02

$VMName = "RDCB-02"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:25"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "1"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU
Start-VM $VMName

# RDSH-01

$VMName = "RDSH-01"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:26"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "1"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU
Start-VM $VMName

# RDSH-02

$VMName = "RDSH-02"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:27"
$VMLoc = "C:\Virtual Hard Disks"
$VMGen = "1"
$vCPU = "2"
$ISO = "C:\ISO\HYDRATION.iso"

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -Generation $VMGen -MemoryStartupBytes 2GB -NewVHDPath $VMLOC\$VMName.vhdx -NewVHDSizeBytes 32GB -SwitchName $Network
Set-VMNetworkAdapter -StaticMacAddress $MAC -VMName $VMName

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VMName -Path $ISO
Set-VMProcessor -VMName $VMName -Count $vCPU
Start-VM $VMName