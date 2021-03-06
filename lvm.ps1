﻿## Create 8 Gen2 Virtual Machines
## 2 vCPU per VM
## 8 GB per VM
## C: drive 50 GB Dynamic
## 4 x drive 50 GB fixed
## NIC renamed to MGMT
## Lage VM
## .\lvm.ps1 -gruppe biz-10 -antall 1 -operativsystem WS2016et
Param(
[string]$vSwitchName01 = "NIC-PUB",
[string]$InstallRoot = "x:\",
[string]$InstallHDD = "z:\",
[string]$VMName = "R710-0",
[string]$Gruppe = (Get-Random -Minimum 2 -Maximum 200),
[string]$antall = 1,
[string]$operativsystem = "ws2016et"
)
## How much VM's 1..8 = 8 VM's
1..$antall | % {
## New-VHD -Path ($InstallRoot + "\$VMName" + "$_\" + "\$VMName" + "$_" + "_C.vhdx") -SizeBytes 50GB -Dynamic
copy c:\template\$operativsystem.vhdx ($InstallRoot + "$VMName" + "$Gruppe" + "$_" + "_C.vhdx")
New-VHD -Path ($InstallHDD + "\$VMName" + "$Gruppe" + "$_" + "_1.vhdx") -SizeBytes 200GB -Dynamic
New-VHD -Path ($InstallHDD + "\$VMName" + "$Gruppe" + "$_" + "_2.vhdx") -SizeBytes 200GB -Dynamic
New-VHD -Path ($InstallHDD + "\$VMName" + "$Gruppe" + "$_" + "_3.vhdx") -SizeBytes 200GB -Dynamic
#New-VHD -Path ($InstallHDD + "\$VMName" + "$Gruppe" + "$_" + "_4.vhdx") -SizeBytes 50GB -Fixed
New-VM -VHDPath ($InstallRoot + "\$VMName" + "$Gruppe" + "$_" + "_C.vhdx") -Generation 1 -BootDevice IDE -MemoryStartupBytes 16GB -Name ("$VMName" + "$Gruppe" + "$_") -Path $InstallRoot -SwitchName $vSwitchName01
Get-VMNetworkAdapter -VMName ("$VMName" + "$Gruppe" + "$_") |Set-VMNetworkAdapterVlan -Access -VlanId 102 
Set-Vmbios ("$VMName" + "$Gruppe" + "$_") -StartupOrder  @("Floppy", "LegacyNetworkAdapter", "CD", "IDE")
Set-VMProcessor -VMName ("$VMName" + "$Gruppe" + "$_") -Count 2
Set-VM -VMName ("$VMName" + "$Gruppe" + "$_") -AutomaticStopAction ShutDown -AutomaticStartAction StartIfRunning
Enable-VMIntegrationService ("$VMName" + "$Gruppe" + "$_") -Name "Guest Service Interface"

#Rename-VMNetworkAdapter -VMName ("$VMName" + "$_") -NewName "MGMT"
#Set-VMNetworkAdapter -VMName ("$VMName" + "$_") -Name "MGMT" -DeviceNaming On

Add-VMScsiController -VMName ("$VMName" + "$Gruppe" + "$_")
Add-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 1 -Path ($InstallHDD + "\$VMName" + "$Gruppe" + "$_" + "_1.vhdx")
Add-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 2 -Path ($InstallHDD + "\$VMName" + "$Gruppe" + "$_" + "_2.vhdx")
Add-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 3 -Path ($InstallHDD + "\$VMName" + "$Gruppe" + "$_" + "_3.vhdx")
#Add-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 4 -Path ($InstallHDD + "\$VMName" + "$Gruppe" + "$_" + "_4.vhdx")

Start-VM -Name ("$VMName" + "$Gruppe" + "$_") | Out-Null
}