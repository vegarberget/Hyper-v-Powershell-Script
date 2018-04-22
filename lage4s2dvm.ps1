## Create 8 Gen2 Virtual Machines
## 2 vCPU per VM
## 8 GB per VM
## C: drive 50 GB Dynamic
## 4 x drive 50 GB fixed
## NIC renamed to MGMT
$vSwitchName01 = "NIC-PUB"
$InstallRoot = "x:\"
$InstallHDD = "x:\HDD\"
$VMName = "S2D"
$VMrnd = Get-Random -Minimum 2 -Maximum 200

## How much VM's 1..8 = 8 VM's
1..4 | % {
## New-VHD -Path ($InstallRoot + "\$VMName" + "$_\" + "\$VMName" + "$_" + "_C.vhdx") -SizeBytes 50GB -Dynamic
copy c:\template\ws2016et.vhdx ($InstallRoot + "\$VMName" + "$VMrnd" + "$_" + "_C.vhdx")
New-VHD -Path ($InstallHDD + "\$VMName" + "$VMrnd" + "$_" + "_1.vhdx") -SizeBytes 50GB -Fixed
New-VHD -Path ($InstallHDD + "\$VMName" + "$VMrnd" + "$_" + "_2.vhdx") -SizeBytes 50GB -Fixed
New-VHD -Path ($InstallHDD + "\$VMName" + "$VMrnd" + "$_" + "_3.vhdx") -SizeBytes 50GB -Fixed
New-VHD -Path ($InstallHDD + "\$VMName" + "$VMrnd" + "$_" + "_4.vhdx") -SizeBytes 50GB -Fixed
New-VM -VHDPath ($InstallRoot + "\$VMName" + "$VMrnd" + "$_" + "_C.vhdx") -Generation 1 -BootDevice IDE -MemoryStartupBytes 8GB -Name ("$VMName" + "$VMrnd" + "$_") -Path $InstallRoot -SwitchName $vSwitchName01

Set-VMProcessor -VMName ("$VMName" + "$VMrnd" + "$_") -Count 2
Set-VM -VMName ("$VMName" + "$VMrnd" + "$_") -AutomaticStopAction ShutDown -AutomaticStartAction StartIfRunning
Enable-VMIntegrationService ("$VMName" + "$VMrnd" + "$_") -Name "Guest Service Interface"

#Rename-VMNetworkAdapter -VMName ("$VMName" + "$_") -NewName "MGMT"
#Set-VMNetworkAdapter -VMName ("$VMName" + "$_") -Name "MGMT" -DeviceNaming On

Add-VMScsiController -VMName ("$VMName" + "$VMrnd" + "$_")
Add-VMHardDiskDrive -VMName ("$VMName" + "$VMrnd" + "$_") -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 1 -Path ($InstallHDD + "\$VMName" + "$VMrnd" + "$_" + "_1.vhdx")
Add-VMHardDiskDrive -VMName ("$VMName" + "$VMrnd" + "$_") -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 2 -Path ($InstallHDD + "\$VMName" + "$VMrnd" + "$_" + "_2.vhdx")
Add-VMHardDiskDrive -VMName ("$VMName" + "$VMrnd" + "$_") -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 3 -Path ($InstallHDD + "\$VMName" + "$VMrnd" + "$_" + "_3.vhdx")
Add-VMHardDiskDrive -VMName ("$VMName" + "$VMrnd" + "$_") -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 4 -Path ($InstallHDD + "\$VMName" + "$VMrnd" + "$_" + "_4.vhdx")

Start-VM -Name ("$VMName" + "$VMrnd" + "$_") | Out-Null
}