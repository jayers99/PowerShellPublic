$listpath = "D:\batch\lists\ComputerList.txt"
$servicename = "nrsvrmon"

foreach ($Computer in get-content $listpath) 
{
	$Computer = $Computer.Trim()
	if ($Computer -eq "") {continue}
	if ($Computer -like "\\*")
	{
		$Computer = $Computer.TrimStart("\\")
	}
	
	$ServerName = $Computer.ToUpper()
    
    Write-Host "$ServerName"
    Get-Service -Name $servicename -ComputerName $ServerName | Stop-service
    Set-Service $servicename -ComputerName $ServerName -StartupType Disabled
}
