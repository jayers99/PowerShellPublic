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
		foreach ($logname in $lognames)
		{
			Get-EventLog -After $dateBack -ComputerName $computer -LogName $logname -EntryType warning, error | select timegenerated, machinename, entrytype, source, EventID, message | Export-Csv d:\batch\csv\$computer.$logname.1days.csv
		}
    }
	else
	{
        Write-Host "$ServerName is not online - skipping"    
    }
}

foreach ($logname in $lognames)
{
	cat d:\batch\csv\*.$logname.1days.csv > d:\batch\csv\all.$logname.1days.csv
}
		