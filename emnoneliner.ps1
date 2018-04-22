# Get the virtual machine name from the parent partition
$vmName = (Get-ItemProperty –path “HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters”).VirtualMachineName|$vmName = [Regex]::Replace($vmName,"\W","_")|$vmName = $vmName.Substring(0,[System.Math]::Min(15, $vmName.Length))|if ($env:computername -ne $vmName) {(gwmi win32_computersystem).Rename($vmName); shutdown -r -t 0}
# Replace any non-alphanumeric characters with an underscore

# Trim names that are longer than 15 characters

 
# Check the trimmed and cleaned VM name against the guest OS name
# If it is different, change the guest OS name and reboot
