$lognames = "system", "application"
$date = Get-Date
$dateBack = $date.AddDays(-1)

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
		copy \\dcont01\group\operations\batch\RemoteEventLogsCSVLast1Day.ps1 \\$Computer\c$\temp
		winrs -r:$Computer powershell c:\temp\RemoteEventLogsCSVLast1Day.ps1
    }
	else
	{
        Write-Host "$ServerName is not online - skipping"    
    }
}

foreach ($logname in $lognames)
{
	cat \\dcont01\group\Operations\Batch\csv\*.$logname.1days.csv > \\dcont01\group\Operations\Batch\csv\all.$logname.1days.csv
}
		