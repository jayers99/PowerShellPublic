$listpath = "D:\batch\lists\ComputerList.txt"
foreach ($Computer in get-content $listpath) 
{
	$Computer = $Computer.Trim()
	if ($Computer -eq "") {continue}
	if ($Computer -like "\\*")
	{
		$Computer = $Computer.TrimStart("\\")
	}
	
	$ServerName = $Computer.ToUpper()
    
    Write-Host "$ServerName is a servername"    
}
