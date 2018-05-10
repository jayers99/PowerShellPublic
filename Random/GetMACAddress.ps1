$ErrorActionPreference = "silentlycontinue"

foreach ($Computer in get-content d:\batch\lists\ComputerList.txt) 
{
	$ComputerSerial = $null
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
		$hostIp = ([System.Net.Dns]::GetHostByName($Computer)).AddressList[0].IpAddressToString
		#$hostIp
		$MacAddress = (gwmi -Class Win32_NetworkAdapterConfiguration | where { $_.IpAddress -eq $hostIp }).MACAddress
		$MacAddress
		Write-Host -NoNewline $Computer
		$strGetMacOut = getmac /s $computer /fo csv /nh
		$strGetMacOut | 
			%{
				[regex]::Match($_, "[0-9|A-F][0-9|A-F]\-[0-9|A-F][0-9|A-F]\-[0-9|A-F][0-9|A-F]\-[0-9|A-F][0-9|A-F]\-[0-9|A-F][0-9|A-F]\-[0-9|A-F][0-9|A-F]")
			} | 
				%{
					if ($_.value.trim() -ne "")
					{
						Write-Host -NoNewline "," $_.value
					}
				}
		Write-Host ""
		
	}
	
	else
	{
        Write-Host "$ServerName is not online - skipping"    
    }
}


