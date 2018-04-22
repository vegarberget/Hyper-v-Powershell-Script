## example 
## Endre operativsystem på samme VM
## ./byttutdisk.ps1 -gruppe 10 -antall 9 -operativsystem WS2016et
Param(
[string]$InstallRoot = "x:\",
[string]$InstallHDD = "z:\",
[string]$VMName = "R710-0",
[string]$Gruppe = (Get-Random -Minimum 2 -Maximum 200),
[string]$antall = "1",
[string]$operativsystem = "ws2016et"
)
## How much VM's 1..8 = 8 VM's
1..$antall | % {
Stop-VM -force -Name ("$VMName" + "$Gruppe" + "$_") | Out-Null
Start-Sleep -s 10
#rm ($InstallRoot + "$VMName" + "$Gruppe" + "$_" + "_C.vhdx")
copy c:\template\$operativsystem.vhdx ($InstallRoot + "$VMName" + "$Gruppe" + "$_" + "_C.vhdx")
Set-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -Path ($InstallRoot + "\$VMName" + "$Gruppe" + "$_" + "_C.vhdx")
remove-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 1 
remove-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 2 
remove-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 3 
Remove-VMScsiController -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerNumber 0
rm ($InstallHDD + "$VMName" + "$Gruppe" + "$_" + "_1.vhdx")
rm ($InstallHDD + "$VMName" + "$Gruppe" + "$_" + "_2.vhdx")
rm ($InstallHDD + "$VMName" + "$Gruppe" + "$_" + "_3.vhdx")
New-VHD -Path ($InstallHDD + "$VMName" + "$Gruppe" + "$_" + "_1.vhdx") -SizeBytes 200GB -Dynamic
New-VHD -Path ($InstallHDD + "$VMName" + "$Gruppe" + "$_" + "_2.vhdx") -SizeBytes 200GB -Dynamic
New-VHD -Path ($InstallHDD + "$VMName" + "$Gruppe" + "$_" + "_3.vhdx") -SizeBytes 200GB -Dynamic
Add-VMScsiController -VMName ("$VMName" + "$Gruppe" + "$_")
Add-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 1 -Path ($InstallHDD + "$VMName" + "$Gruppe" + "$_" + "_1.vhdx")
Add-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 2 -Path ($InstallHDD + "$VMName" + "$Gruppe" + "$_" + "_2.vhdx")
Add-VMHardDiskDrive -VMName ("$VMName" + "$Gruppe" + "$_") -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 3 -Path ($InstallHDD + "$VMName" + "$Gruppe" + "$_" + "_3.vhdx")
Start-VM -Name ("$VMName" + "$Gruppe" + "$_") | Out-Null
}