$ErrorActionPreference = "continue"
$keyDomain = "SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile"
$keyStandard = "SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile"
$regValue = "EnableFirewall"

foreach ($Computer in get-content d:\batch\lists\ComputerList.txt) 
{
	$EnableFirewallValue = $null
	$Computer = $Computer.Trim()
	if ($Computer -eq "") {continue}
	if ($Computer -like "\\*")
	{
		$Computer = $Computer.TrimStart("\\")
	}	

	$ServerName = $Computer.ToUpper()
    
    $ping = new-object System.Net.NetworkInformation.Ping
    $Reply = $ping.send($Computer)
    
	if($Reply.status -eq "success") 
	{
		Write-Host -NoNewline $Computer " - "
		$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Computer)
		$regKey = $reg.OpenSubKey($keyDomain)
		$EnableFirewallValue = $null
		$EnableFirewallValue = $regkey.GetValue($regValue)
		Write-Host -NoNewline $EnableFirewallValue
		
		$regKey = $reg.OpenSubKey($keyDomain, $True)
		$regkey.SetValue("EnableFirewall", 0)
		
		$EnableFirewallValue = $null
		$EnableFirewallValue = $regkey.GetValue($regValue)
		Write-Host -NoNewline $EnableFirewallValue

		$regKey = $reg.OpenSubKey($keyStandard)
		$EnableFirewallValue = $null
		$EnableFirewallValue = $regkey.GetValue($regValue)
		Write-Host -NoNewline $EnableFirewallValue
		
		$regKey = $reg.OpenSubKey($keyStandard, $True)
		$regkey.SetValue("EnableFirewall", 0)
		
		$EnableFirewallValue = $null
		$EnableFirewallValue = $regkey.GetValue($regValue)
		Write-Host $EnableFirewallValue
    }
	
	else
	{
        Write-Host "$ServerName is not online - skipping"    
    }
}

