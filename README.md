Automation Framework Community Edition (AFCE)

1. Download repo ZIP and extract to C:\Source
2. Download Windows 2016 DataCenter Evaluation : https://www.microsoft.com/en-us/cloud-platform/windows-server-trial
3. Mount ISO to D:
4. Run C:\Source\Install.ps1

To deploy the full Automation Framework with AFCE

1. Set the local password to the same on all VMs (this applies to Cloud) : net user administrator YOURLOCALPASSWORD
2. Set Computername and Join Domain
2. Add the local password to CustomSettings.ini => AdminPassword=YOURLOCALPASSWORD
3. Set Run As Domain & Password in the Automation Framework Task Sequence (The Tasks with White Icon)
4. Cut / Paste the Windows 2016 ISO into .\Applications\Misc\Automation Framework
5. Add the licensed Install.ps1 (AF) into the same folder.
6. Run cscript \\HYDRATIONSERVERIP\Hydration$\scripts\litetouch.wsf (Cloud Only)
