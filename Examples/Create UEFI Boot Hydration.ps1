$Source = "C:\Source"
$Hydration = "C:\Hydration"

## variables ##
$sworkspace = "$Source\Oscdimg\extractedISO\"

If (!(Test-Path -Path $sworkspace)) {New-Item -ItemType directory -Path $sworkspace | Out-Null}

# this will be your NEW ISO
$smynewiso = "$Hydration\Boot\HYDRATION_UEFI.iso"

# this is your old ISO
$stheiso = "$Hydration\Boot\HYDRATION.iso"

$setfsboot = "$Source\Oscdimg\etfsboot.com"
$sefisys = "$Source\Oscdimg\efisys_noprompt.bin"
$soscdimg= "$Source\Oscdimg\oscdimg.exe"

## start script ##
# mount the ISO
$mount = mount-diskimage -imagepath $stheiso -passthru

# get the drive letter assigned to the iso.
$drive = ($mount | get-volume).driveletter + ':'

# copy the existing iso to the temporary folder.
cmd /c "xcopy $drive $sworkspace /E /Y /S /Q"

# remove the read-only attribute from the extracted files.
get-childitem $sworkspace -recurse | %{ if (! $_.psiscontainer) { $_.isreadonly = $false } }

# Create a bootable WinPE ISO file (remove the "Press any button key.." message)
Copy-Item -Path $setfsboot -Destination "$sworkspace\boot" -Recurse -Force
Copy-Item -Path $sefisys -Destination "$sworkspace\EFI\Microsoft\Boot" -Recurse -Force

# recompile the files to an ISO
# This is the part from Johan Arwidmark's WinPE creation script:
$Proc = $null
$Proc = Start-Process -FilePath "$soscdimg" "-o -u2 -udfver102 -bootdata:2#p0,eb$setfsboot#pEF,e,b$sefisys $sworkspace $smynewiso" -PassThru -Wait -NoNewWindow

if($Proc.ExitCode -ne 0)
{
    Throw "Failed to generate ISO with exitcode: $($Proc.ExitCode)"
}

# remove the extracted content.
remove-item $sworkspace -recurse -force

# dismount the iso.
Dismount-DiskImage -ImagePath "$stheiso"
