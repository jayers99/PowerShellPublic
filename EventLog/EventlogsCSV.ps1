$lognames = "system", "application"

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
			Get-EventLog -ComputerName $computer -LogName $logname -EntryType warning, error | select timegenerated, machinename, entrytype, source, EventID, message | Export-Csv d:\batch\csv\$computer.$logname.csv
		}
    }
	else
	{
        Write-Host "$ServerName is not online - skipping"    
    }
}