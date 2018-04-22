$domain = "domain"
$password = "Password" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\administrator"
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
# Get the virtual machine name from the parent partition
$vmName = (Get-ItemProperty �path �HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters�).VirtualMachineName
# Replace any non-alphanumeric characters with an underscore
# $vmName = [Regex]::Replace($vmName,"\W","_")
# Trim names that are longer than 15 characters
$vmName = $vmName.Substring(0,[System.Math]::Min(15, $vmName.Length))
# Check the trimmed and cleaned VM name against the guest OS name
# If it is different, change the guest OS name and reboot
#if ($env:computername -ne $vmName) {Add-Computer -NewName $vmName -DomainName $domain -Credential $credential -restart -force}
if ($env:computername -ne $vmName) {Rename-Computer -NewName $vmName;sleep 5;Add-Computer -DomainName $domain -Credential $credential -force -Options JoinWithNewName,AccountCreate -Restart}