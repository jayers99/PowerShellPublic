foreach ($Computer in get-content d:\batch\lists\ComputerList.txt) 
{
	$Computer = $Computer.Trim()
	if ($Computer -eq "") {continue}
	if ($Computer -like "\\*")
	{
		$Computer = $Computer.TrimStart("\\")
	}
	
	#$Computer = $Computer + ".<domain>.com"

	$ServerName = $Computer.ToUpper()
    
    $ping = new-object System.Net.NetworkInformation.Ping
    $Reply = $ping.send($Computer)
	
    
    if($Reply.status -eq "success") 
	{
        Write-Host "============================================================================"
		Write-Host "$ServerName is online"
		
		#do something
		$curValue = (get-item wsman:\$Computer\Client\TrustedHosts).value
		$curValue
		#set-item wsman:\$Computer\Client\TrustedHosts -value "johndev, jgambini"

    }
	else
	{
        Write-Host "$ServerName is not online - skipping"    
    }
}
