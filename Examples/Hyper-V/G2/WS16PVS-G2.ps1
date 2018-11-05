# WS16PVS-MI-HV

$VMName = "WS16PVS-MI-HV"
$Network = "Internal"
$MAC = "00:15:5D:1D:20:06"
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
Set-VMFirmware -VMName $VMName –EnableSecureBoot On
Set-VMNetworkAdapter -VMName $VMName -StaticMacAddress $MAC
Set-VMProcessor -VMName $VMName -Count $vCPU
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false

    #The well known PVS Virtual System Identifier for the Streaming synthetic NIC 
    $VSIGuid = "{c40165e3-3bce-43f6-81ec-8733731ddcba}"

    #Retrieve the Hyper-V Management Service, The ComputerSystem class for the VM and the VM’s SettingData class. 
    $Msvm_VirtualSystemManagementService = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemManagementService 

    $Msvm_ComputerSystem = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter "ElementName='$VMName'" 
    $Msvm_ComputerSystem

    $Msvm_VirtualSystemSettingData = ($Msvm_ComputerSystem.GetRelated("Msvm_VirtualSystemSettingData", "Msvm_SettingsDefineState", $null, $null, "SettingData", "ManagedElement", $false, $null) | % {$_}) 

    #Retrieve the default (primordial) resource pool for Synthetic Ethernet Port’s 
    $Msvm_ResourcePool = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_ResourcePool -Filter "ResourceSubType = 'Microsoft:Hyper-V:Synthetic Ethernet Port' and Primordial = True" 

    #Retrieve the AllocationCapabilities class for the Resource Pool 
    $Msvm_AllocationCapabilities = ($Msvm_ResourcePool.GetRelated("Msvm_AllocationCapabilities", "Msvm_ElementCapabilities", $null, $null, $null, $null, $false, $null) | % {$_}) 

    #Query the relationships on the AllocationCapabilities class and find the default class (ValueRole = 0) 
    $Msvm_SettingsDefineCapabilities = ($Msvm_AllocationCapabilities.GetRelationships("Msvm_SettingsDefineCapabilities") | Where-Object {$_.ValueRole -eq "0"}) 

    #The PartComponent is the Default SyntheticEthernetPortSettingData class values 
    $Msvm_SyntheticEthernetPortSettingData = [WMI]$Msvm_SettingsDefineCapabilities.PartComponent 

    #Specify a unique identifier, a friendly name and specify dynamic mac addresses 
    $Msvm_SyntheticEthernetPortSettingData.VirtualSystemIdentifiers = $VSIGuid 
    $Msvm_SyntheticEthernetPortSettingData.ElementName = "PVS Streaming Adapter" 
    $Msvm_SyntheticEthernetPortSettingData.StaticMacAddress = $false
    #$Msvm_SyntheticEthernetPortSettingData.Address = $MAC

    #Add the network adapter to the VM 
    $Msvm_VirtualSystemManagementService.AddResourceSettings($Msvm_VirtualSystemSettingData, $Msvm_SyntheticEthernetPortSettingData.GetText(1))
   
# SIG # Begin signature block
# MIIY4QYJKoZIhvcNAQcCoIIY0jCCGM4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXwceSz4aGYPPSUsWPKIhnah2
# BnigghPZMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggUuMIIEFqADAgECAhBNpe3AvijrIdal+xjwiWfyMA0GCSqGSIb3DQEBBQUAMIG0
# MQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsT
# FlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOzA5BgNVBAsTMlRlcm1zIG9mIHVzZSBh
# dCBodHRwczovL3d3dy52ZXJpc2lnbi5jb20vcnBhIChjKTEwMS4wLAYDVQQDEyVW
# ZXJpU2lnbiBDbGFzcyAzIENvZGUgU2lnbmluZyAyMDEwIENBMB4XDTE2MTEwNjAw
# MDAwMFoXDTE3MTEwNjIzNTk1OVowgY8xCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApD
# YWxpZm9ybmlhMRQwEgYDVQQHDAtTYW50YSBDbGFyYTEdMBsGA1UECgwUQ2l0cml4
# IFN5c3RlbXMsIEluYy4xFzAVBgNVBAsMDlhlbkFwcChTZXJ2ZXIpMR0wGwYDVQQD
# DBRDaXRyaXggU3lzdGVtcywgSW5jLjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBALaYYtUka1pQP29ASToKL6xncbBvVdXyfSy55d3JueSBqHmbesy989ZU
# wt1gLN74G/LebllMfb1tQiokzx8D228ufpfKnQjffX5JtzisU3b4DCdQ+n70nHXn
# YILulBa8i4NqGB4omneaFjkUEN7lmGavzGDoQRoh6OPJNf/R4dC7QaSpRu0OzFR7
# 9se/8I9uFlxWU839d2smhLVX0cpboHN2QGUWLLBnW1Y1xGzKsX7ibBzTVH0eJrXs
# EZNb0hijRH2TODDLjj8PK0Hgy9IOWC0/CPSAPSyvbMYffVvIcWAGSADwpkzaf1P5
# e1T1esDEsejRsi8hYwanP4fzdV3+jrcCAwEAAaOCAV0wggFZMAkGA1UdEwQCMAAw
# DgYDVR0PAQH/BAQDAgeAMCsGA1UdHwQkMCIwIKAeoByGGmh0dHA6Ly9zZi5zeW1j
# Yi5jb20vc2YuY3JsMGEGA1UdIARaMFgwVgYGZ4EMAQQBMEwwIwYIKwYBBQUHAgEW
# F2h0dHBzOi8vZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBkMF2h0dHBzOi8v
# ZC5zeW1jYi5jb20vcnBhMBMGA1UdJQQMMAoGCCsGAQUFBwMDMFcGCCsGAQUFBwEB
# BEswSTAfBggrBgEFBQcwAYYTaHR0cDovL3NmLnN5bWNkLmNvbTAmBggrBgEFBQcw
# AoYaaHR0cDovL3NmLnN5bWNiLmNvbS9zZi5jcnQwHwYDVR0jBBgwFoAUz5mp6nsm
# 9EvJjo/X8AUm7+PSp50wHQYDVR0OBBYEFAlWo5RSr5tTjc/qoxYZL997nMITMA0G
# CSqGSIb3DQEBBQUAA4IBAQDu3DiYVi7317sPP6nWyuY6uaVh4Ob7YWyKpfb6L74z
# Op0vzpVRqz5AGJJbeOqiosrFPUxygSYJ8K+l1Z3RaL9bnC294g3nq7ookCy/sKA+
# //qyuMHDAzQa+nRhJg5qenEEQfyivpq8Bb8qcd07hJ391o/x0pG7tUDdnLnmH0SQ
# bFweK70AjToL46lzd2OSxouIUhwuoxTXRfktEmqCp6ilnO7T5uMUlNyQiWbyYJJC
# IUvaJ4ZxRQiq4rLLEN47DVH7EZvs3OprbuY6neNSvGYelBHnmzGMK02flr41QsMw
# 9ozax7P1S2hyrB2r1nyw/XrBEoLBeStJjsg/G1a5v7wcMIIGCjCCBPKgAwIBAgIQ
# UgDlqiVW/BqG7ZbJ1EszxzANBgkqhkiG9w0BAQUFADCByjELMAkGA1UEBhMCVVMx
# FzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVz
# dCBOZXR3b3JrMTowOAYDVQQLEzEoYykgMjAwNiBWZXJpU2lnbiwgSW5jLiAtIEZv
# ciBhdXRob3JpemVkIHVzZSBvbmx5MUUwQwYDVQQDEzxWZXJpU2lnbiBDbGFzcyAz
# IFB1YmxpYyBQcmltYXJ5IENlcnRpZmljYXRpb24gQXV0aG9yaXR5IC0gRzUwHhcN
# MTAwMjA4MDAwMDAwWhcNMjAwMjA3MjM1OTU5WjCBtDELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBO
# ZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVy
# aXNpZ24uY29tL3JwYSAoYykxMDEuMCwGA1UEAxMlVmVyaVNpZ24gQ2xhc3MgMyBD
# b2RlIFNpZ25pbmcgMjAxMCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
# ggEBAPUjS16l14q7MunUV/fv5Mcmfq0ZmP6onX2U9jZrENd1gTB/BGh/yyt1Hs0d
# CIzfaZSnN6Oce4DgmeHuN01fzjsU7obU0PUnNbwlCzinjGOdF6MIpauw+81qYoJM
# 1SHaG9nx44Q7iipPhVuQAU/Jp3YQfycDfL6ufn3B3fkFvBtInGnnwKQ8PEEAPt+W
# 5cXklHHWVQHHACZKQDy1oSapDKdtgI6QJXvPvz8c6y+W+uWHd8a1VrJ6O1QwUxvf
# YjT/HtH0WpMoheVMF05+W/2kk5l/383vpHXv7xX2R+f4GXLYLjQaprSnTH69u08M
# PVfxMNamNo7WgHbXGS6lzX40LYkCAwEAAaOCAf4wggH6MBIGA1UdEwEB/wQIMAYB
# Af8CAQAwcAYDVR0gBGkwZzBlBgtghkgBhvhFAQcXAzBWMCgGCCsGAQUFBwIBFhxo
# dHRwczovL3d3dy52ZXJpc2lnbi5jb20vY3BzMCoGCCsGAQUFBwICMB4aHGh0dHBz
# Oi8vd3d3LnZlcmlzaWduLmNvbS9ycGEwDgYDVR0PAQH/BAQDAgEGMG0GCCsGAQUF
# BwEMBGEwX6FdoFswWTBXMFUWCWltYWdlL2dpZjAhMB8wBwYFKw4DAhoEFI/l0xqG
# rI2Oa8PPgGrUSBgsexkuMCUWI2h0dHA6Ly9sb2dvLnZlcmlzaWduLmNvbS92c2xv
# Z28uZ2lmMDQGA1UdHwQtMCswKaAnoCWGI2h0dHA6Ly9jcmwudmVyaXNpZ24uY29t
# L3BjYTMtZzUuY3JsMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0cDov
# L29jc3AudmVyaXNpZ24uY29tMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
# AzAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVmVyaVNpZ25NUEtJLTItODAdBgNV
# HQ4EFgQUz5mp6nsm9EvJjo/X8AUm7+PSp50wHwYDVR0jBBgwFoAUf9Nlp8Ld7Lvw
# MAnzQzn6Aq8zMTMwDQYJKoZIhvcNAQEFBQADggEBAFYi5jSkxGHLSLkBrVaoZA/Z
# jJHEu8wM5a16oCJ/30c4Si1s0X9xGnzscKmx8E/kDwxT+hVe/nSYSSSFgSYckRRH
# sExjjLuhNNTGRegNhSZzA9CpjGRt3HGS5kUFYBVZUTn8WBRr/tSk7XlrCAxBcuc3
# IgYJviPpP0SaHulhncyxkFz8PdKNrEI9ZTbUtD1AKI+bEM8jJsxLIMuQH12MTDTK
# PNjlN9ZvpSC9NOsm2a4N58Wa96G0IZEzb4boWLslfHQOWP51G2M/zjF8m48blp7F
# U3aEW5ytkfqs7ZO6XcghU8KCU2OvEg1QhxEbPVRSloosnD2SGgiaBS7Hk6VIkdMx
# ggRyMIIEbgIBATCByTCBtDELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWdu
# LCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQL
# EzJUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAo
# YykxMDEuMCwGA1UEAxMlVmVyaVNpZ24gQ2xhc3MgMyBDb2RlIFNpZ25pbmcgMjAx
# MCBDQQIQTaXtwL4o6yHWpfsY8Iln8jAJBgUrDgMCGgUAoHAwEAYKKwYBBAGCNwIB
# DDECMAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFL0chr2xFAAxP/2oR18rZPjv
# 8C72MA0GCSqGSIb3DQEBAQUABIIBAE4tO2OMHuu0XQJKgG8FMcdIPN8Uzr+3Wu9j
# tMhXfBBJUurxZXsWw+XjgkhXqTSjAbQY0fKrZlNfE6j7oM7AjiJkK2tALoED1wUV
# gA7NmqDC4aW0l4WN6kEeCx+8ukZm5tBC5dbNyHfBXFR18knbFhGNwetGsyq+VCKS
# fwr3toQppSBIYTb/9V5oHl9aAaVSwVWotRfZVo9sTkO0dyxPi6I02SPLePXQfOab
# ZH73+j1Wtdk2ua3kg27x0ytpgjtnTE6V2RfYQwmpZmrcAmffgzreAOxCvp4uxQzL
# 0aKywfK85f4eZdod39kQ+CROpT2gjJ3HkapgbXgpoN7O8qO0ztqhggILMIICBwYJ
# KoZIhvcNAQkGMYIB+DCCAfQCAQEwcjBeMQswCQYDVQQGEwJVUzEdMBsGA1UEChMU
# U3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFudGVjIFRpbWUgU3Rh
# bXBpbmcgU2VydmljZXMgQ0EgLSBHMgIQDs/0OMj+vzVuBNhqmBsaUDAJBgUrDgMC
# GgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
# MTcwNTIzMTYyMDAxWjAjBgkqhkiG9w0BCQQxFgQUzQRD/rh8UsRUDEobnqJY/u9G
# 2rswDQYJKoZIhvcNAQEBBQAEggEAWQjUyOAvzZVHeW3c5we7RqTvBVfYqakCyvQP
# YKKKOeLRgb2n6BvGe0/Hw3tlKCQUkcaioB73JuuzNvtl2Q2u/Cs8Pbzkl6obN+1g
# WqVQV2aOMpKML0DFih/FW/zJzq1kjNrli766PE7ljJa1H31jef62jnFmY2tA3Iz7
# ZBC9uM1WJlgWR0iFen2LcZaeIgwqDvfKQ5at1DOu0xJdKkvQdd4uI4DQ6K6zPiYw
# 76jIOpY20Xel70eXHSzJZ8xQcnsOXWMA+bK7Fen3iemV1UYPKNFeUV8I4Woc7ezR
# J10KT3/LXqGQrilmofhNl/Gd47obgEQJmxBiiVOteJC2IT+rJQ==
# SIG # End signature block

