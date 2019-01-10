# Automation Framework Community Edition (AFCE)

1. Download repo ZIP and extract to C:\Source
2. Download Windows 2019 DataCenter Evaluation : https://www.microsoft.com/en-us/cloud-platform/windows-server-trial
3. Mount ISO and set correct drive letter in .\Install.ps1
4. Run C:\Source\Install.ps1

# Deploy Domain Controller with AFCE

1. Set the local password to the same on all VMs (this applies only to Cloud) : net user administrator YOURLOCALPASSWORD
2. Set Domain Name and Reverse Lookup IP Address in .\Applications\Scripts\Settings.xml
3. Set DHCP Scope in .\Applications\Scripts\DHCP-vendor.ps1

# Deploy Automation Framework with AFCE

1. Set the local password to the same on all VMs (this applies only to Cloud) : net user administrator YOURLOCALPASSWORD
2. Set Computername and Join Domain
2. Add the local password to CustomSettings.ini => AdminPassword=YOURLOCALPASSWORD
3. Set Run As Domain & Password in the Automation Framework Task Sequence (The Tasks with White Icon)
4. Cut / Paste the Windows 2019 ISO into .\Applications\Misc\Automation Framework
5. Add the licensed Install.ps1 (AF) into the same folder.
6. Run cscript \\HYDRATIONSERVERIP\Hydration$\scripts\litetouch.wsf (Cloud Only - Disable Firewall on Hydration Server)

# Download and Extract

[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
wget -uri https://github.com/haavarstein/Automation-Framework-Community-Edition/archive/master.zip -OutFile C:\Windows\Temp\Master.zip
Expand-Archive -Path C:\Windows\Temp\Master.zip -DestinationPath C:\
ren "C:\Automation-Framework-Community-Edition-master" "C:\Source"

